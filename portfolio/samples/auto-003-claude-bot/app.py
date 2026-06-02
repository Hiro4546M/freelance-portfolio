import os
import re
from flask import Flask, request, jsonify, abort
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError
from slack_sdk.signature import SignatureVerifier
import anthropic
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
slack_client = WebClient(token=os.environ["SLACK_BOT_TOKEN"])
claude_client = anthropic.Anthropic(api_key=os.environ["ANTHROPIC_API_KEY"])
signature_verifier = SignatureVerifier(os.environ["SLACK_SIGNING_SECRET"])

SYSTEM_PROMPT = (
    "あなたは社内FAQ応答ボットです。"
    "質問に対して、簡潔かつ正確に回答してください。"
    "回答は3〜5文以内にまとめてください。"
    "不明な質問には「確認が必要です。担当者にお問い合わせください」と答えてください。"
)


def get_claude_response(question: str) -> str:
    response = claude_client.messages.create(
        model=os.environ.get("CLAUDE_MODEL", "claude-haiku-4-5-20251001"),
        max_tokens=500,
        system=SYSTEM_PROMPT,
        messages=[{"role": "user", "content": question}],
    )
    return response.content[0].text


@app.route("/slack/events", methods=["POST"])
def slack_events():
    # Slack リクエスト署名検証（url_verification は除外）
    if request.json.get("type") != "url_verification":
        if not signature_verifier.is_valid_request(request.get_data(), request.headers):
            abort(403)

    data = request.json

    if data.get("type") == "url_verification":
        return jsonify({"challenge": data["challenge"]})

    event = data.get("event", {})

    if event.get("type") == "app_mention":
        user_text = re.sub(r"<@[A-Z0-9]+>", "", event["text"]).strip()
        if not user_text:
            return jsonify({"ok": True})

        channel = event["channel"]
        message_ts = event.get("ts")

        answer = get_claude_response(user_text)

        try:
            slack_client.chat_postMessage(
                channel=channel,
                text=answer,
                thread_ts=message_ts,
            )
        except SlackApiError as e:
            print(f"Slack API error: {e}")
            return jsonify({"ok": False, "error": str(e)}), 500

    return jsonify({"ok": True})


if __name__ == "__main__":
    debug = os.environ.get("FLASK_DEBUG", "false").lower() == "true"
    app.run(port=3000, debug=debug)
