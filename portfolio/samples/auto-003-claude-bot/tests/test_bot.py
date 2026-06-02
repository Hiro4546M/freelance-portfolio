import pytest
import os
import sys
from unittest.mock import patch, MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

os.environ.setdefault("SLACK_BOT_TOKEN", "xoxb-test")
os.environ.setdefault("SLACK_SIGNING_SECRET", "test-secret")
os.environ.setdefault("ANTHROPIC_API_KEY", "test-key")


@pytest.fixture
def client():
    from app import app
    app.config["TESTING"] = True
    with app.test_client() as c:
        yield c


def test_url_verification(client):
    """Slack の URL 検証チャレンジに正しく応答する（署名検証をスキップ）"""
    response = client.post(
        "/slack/events",
        json={"type": "url_verification", "challenge": "abc123"},
        content_type="application/json",
    )
    assert response.status_code == 200
    assert response.get_json()["challenge"] == "abc123"


def test_app_mention_triggers_response(client):
    """メンションが届いたら Claude に問い合わせて Slack に返信する"""
    mock_claude_text = "有給申請は社内ポータルから行えます。"

    with patch("app.signature_verifier") as mock_verifier, \
         patch("app.claude_client") as mock_claude, \
         patch("app.slack_client") as mock_slack:

        mock_verifier.is_valid_request.return_value = True
        mock_content = MagicMock()
        mock_content.text = mock_claude_text
        mock_response = MagicMock()
        mock_response.content = [mock_content]
        mock_claude.messages.create.return_value = mock_response
        mock_slack.chat_postMessage.return_value = {"ok": True}

        response = client.post(
            "/slack/events",
            json={
                "event": {
                    "type": "app_mention",
                    "text": "<@UBOT123> 有給の申請方法を教えてください",
                    "channel": "C123",
                    "ts": "1000.001",
                }
            },
            content_type="application/json",
        )

    assert response.status_code == 200
    mock_claude.messages.create.assert_called_once()
    call_kwargs = mock_claude.messages.create.call_args.kwargs
    assert "有給の申請方法" in call_kwargs["messages"][0]["content"]
    mock_slack.chat_postMessage.assert_called_once_with(
        channel="C123",
        text=mock_claude_text,
        thread_ts="1000.001",
    )


def test_non_mention_event_does_nothing(client):
    """メンション以外のイベントは無視する"""
    with patch("app.signature_verifier") as mock_verifier, \
         patch("app.claude_client") as mock_claude, \
         patch("app.slack_client") as mock_slack:

        mock_verifier.is_valid_request.return_value = True

        response = client.post(
            "/slack/events",
            json={
                "event": {
                    "type": "message",
                    "text": "普通のメッセージ",
                    "channel": "C123",
                }
            },
            content_type="application/json",
        )

    assert response.status_code == 200
    mock_claude.messages.create.assert_not_called()
    mock_slack.chat_postMessage.assert_not_called()


def test_bot_mention_text_stripped(client):
    """メンション部分（<@UBOT>）が質問テキストから除去される"""
    with patch("app.signature_verifier") as mock_verifier, \
         patch("app.get_claude_response") as mock_get_response, \
         patch("app.slack_client"):

        mock_verifier.is_valid_request.return_value = True
        mock_get_response.return_value = "テスト回答"

        client.post(
            "/slack/events",
            json={
                "event": {
                    "type": "app_mention",
                    "text": "<@UBOT123>   経費精算の方法は？",
                    "channel": "C123",
                    "ts": "1000.002",
                }
            },
            content_type="application/json",
        )

        mock_get_response.assert_called_once_with("経費精算の方法は？")


def test_invalid_signature_rejected(client):
    """不正なリクエスト署名は 403 を返す"""
    with patch("app.signature_verifier") as mock_verifier:
        mock_verifier.is_valid_request.return_value = False

        response = client.post(
            "/slack/events",
            json={
                "event": {
                    "type": "app_mention",
                    "text": "<@UBOT123> テスト",
                    "channel": "C123",
                    "ts": "1000.003",
                }
            },
            content_type="application/json",
        )

    assert response.status_code == 403
