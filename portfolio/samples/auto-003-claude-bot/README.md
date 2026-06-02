# 社内FAQ Slack Bot（Claude AI 搭載）

## デモ

> スクリーンショットは Slack App セットアップ完了後に追加予定です。
> セットアップ後、`screenshots/` ディレクトリに以下の画像を配置してください：
> - `01-slack-bot-response.png`：Slack でメンションしたときの Bot 返答

## 何ができるか
Slack でボットをメンションすると、Claude AI が自動回答します。
社内ヘルプデスクの問い合わせを自動化し、担当者の負荷を軽減します。

## ユースケース
- 社内 FAQ 自動応答
- ヘルプデスク負荷軽減
- 新入社員向けナレッジベース

## 使用技術
- Python / Flask
- [Claude API](https://anthropic.com)（Haiku モデル）
- [Slack SDK](https://slack.dev/python-slack-sdk/)

## セットアップ

### 1. 依存関係をインストール
```bash
pip install -r requirements.txt
```

### 2. 環境変数を設定
```bash
cp env.example .env
# .env を編集して各キーを入力
```

### 3. Slack App を作成
1. https://api.slack.com/apps でアプリ作成
2. **OAuth & Permissions** → Bot Token Scopes:
   - `chat:write`
   - `app_mentions:read`
3. **Event Subscriptions** → `app_mention` を有効化
4. Request URL に `https://your-server/slack/events` を設定
5. Bot Token（`xoxb-...`）と Signing Secret を `.env` に入力

### 4. サーバーを起動
```bash
python app.py
# または本番環境: gunicorn app:app
```

## テスト
```bash
pytest tests/ -v
```

## ワークフロー
```
Slack でボットをメンション（@BotName 質問内容）
    ↓
Flask がイベントを受信・署名検証
    ↓
Claude Haiku が回答を生成
    ↓
Slack スレッドに返信
```

## 費用
Claude Haiku は低コストモデル。100件の質問応答でも数十円程度。
