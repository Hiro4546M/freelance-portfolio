#!/bin/bash
# start-ngrok.sh｜ngrok でローカルを公開するスクリプト
# 使い方: bash scripts/start-ngrok.sh
# 前提: ngrok のアカウント登録 + authtoken の設定が必要

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

NGROK="scripts/bin/ngrok"
PORT=3000

# ngrok authtoken の確認
if ! "$NGROK" config check 2>/dev/null | grep -q "authtoken"; then
  echo -e "${YELLOW}⚠️  ngrok の authtoken が未設定です。${NC}"
  echo ""
  echo "1. https://ngrok.com/signup でアカウント登録（無料）"
  echo "2. ダッシュボードで authtoken をコピー"
  echo "3. 以下を実行:"
  echo "   scripts/bin/ngrok config add-authtoken YOUR_TOKEN"
  echo ""
  echo "設定後、このスクリプトを再実行してください。"
  exit 1
fi

echo -e "${GREEN}▶ ngrok でポート ${PORT} を公開します...${NC}"
echo ""
echo -e "${YELLOW}📌 表示された Forwarding URL を Slack App の Event URL に設定:${NC}"
echo "   例: https://xxxx-xxxx.ngrok-free.app/slack/events"
echo ""
echo "終了するには Ctrl+C を押してください。"
echo "---"

"$NGROK" http "$PORT"
