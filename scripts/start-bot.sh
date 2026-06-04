#!/bin/bash
# start-bot.sh｜auto-003 Slack Bot 起動スクリプト
# 使い方: bash scripts/start-bot.sh
# 前提: portfolio/samples/auto-003-claude-bot/.env に認証情報を設定済み

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

BOT_DIR="portfolio/samples/auto-003-claude-bot"
ENV_FILE="$BOT_DIR/.env"
VENV_PYTHON="$BOT_DIR/.venv/bin/python"

# .env の確認
if [ ! -f "$ENV_FILE" ]; then
  echo -e "${RED}❌ .env ファイルが見つかりません。${NC}"
  echo ""
  echo "以下を実行して設定してください："
  echo "  cp $BOT_DIR/env.example $BOT_DIR/.env"
  echo "  # .env を編集して各キーを入力"
  exit 1
fi

# SLACK_BOT_TOKEN が設定されているか確認
if grep -q "xoxb-your-bot-token-here" "$ENV_FILE"; then
  echo -e "${RED}❌ .env の SLACK_BOT_TOKEN がまだデフォルト値です。${NC}"
  echo "Slack App の Bot Token を設定してください。"
  exit 1
fi

echo -e "${GREEN}▶ Slack Bot を起動します...${NC}"
echo ""
echo -e "${YELLOW}📌 別ターミナルで ngrok を起動してください:${NC}"
echo "   bash scripts/start-ngrok.sh"
echo ""
echo "終了するには Ctrl+C を押してください。"
echo "---"

cd "$BOT_DIR" && "$VENV_PYTHON" app.py
