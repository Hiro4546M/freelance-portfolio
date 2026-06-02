import os
import re
from flask import Flask, request, jsonify
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError
import anthropic
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
slack_client = WebClient(token=os.environ["SLACK_BOT_TOKEN"])
claude_client = anthropic.Anthropic(api_key=os.environ["ANTHROPIC_API_KEY"])

SYSTEM_PROMPT = (
    "あなたは社内FAQ応答ボットです。"
    "質問に対して、簡潔かつ正確に回答してください。"
    "回答は3〜5文以内にまとめてください。"
    "不明な質問には「確認が必要です。担当者にお問い合わせください」と答えてください。"
)


def get_claude_response(question: str) -> str:
    response = claude_client.messages.create(
        model="claude-haiku-4-5-20251001",
        max_tokens=500,
        system=SYSTEM_PROMPT,
        messages=[{"role": "user", "content": question}],
    )
    return response.content[0].text


@app.route("/slack/events", methods=["POST"])
def slack_events():
    data = request.json

    if data.get("type") == "url_verification":
        return jsonify({"challenge": data["challenge"]})

    event = data.get("event", {})

    if event.get("type") == "app_mention":
        user_text = re.sub(r"<@[A-Z0-9]+>", "", event["text"]).strip()
        channel = event["channel"]
        thread_ts = event.get("ts")

        answer = get_claude_response(user_text)

        try:
            slack_client.chat_postMessage(
                channel=channel,
                text=answer,
                thread_ts=thread_ts,
            )
        except SlackApiError as e:
            print(f"Slack API error: {e}")

    return jsonify({"ok": True})


if __name__ == "__main__":
    app.run(port=3000, debug=True)
