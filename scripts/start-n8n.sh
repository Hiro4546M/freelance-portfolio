#!/bin/bash
# start-n8n.sh｜n8n ローカル起動スクリプト
# 使い方: bash scripts/start-n8n.sh

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}▶ n8n を起動します...${NC}"
echo ""
echo -e "${YELLOW}📌 起動後はブラウザで以下を開いてください:${NC}"
echo "   http://localhost:5678"
echo ""
echo -e "${YELLOW}📌 ワークフローのインポート先:${NC}"
echo "   portfolio/samples/auto-001-email-notion/workflow.json"
echo ""
echo "終了するには Ctrl+C を押してください。"
echo "---"

npx n8n
