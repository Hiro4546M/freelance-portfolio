#!/bin/bash
# push-screenshots.sh｜スクリーンショット撮影後の GitHub 反映スクリプト
# スクリーンショットを screenshots/ に配置してから実行する
# 使い方: bash scripts/push-screenshots.sh

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}▶ スクリーンショットの配置確認...${NC}"
echo ""

MISSING=0

# auto-002 のスクリーンショット確認
AUTO002_DIR="portfolio/samples/auto-002-form-slack/screenshots"
echo "【auto-002】Make フォーム→Slack："
for f in "01-workflow-overview.png" "02-slack-notification.png" "03-sheets-record.png"; do
  if [ -f "$AUTO002_DIR/$f" ]; then
    echo -e "  ${GREEN}✅ $f${NC}"
  else
    echo -e "  ${RED}❌ $f （未配置）${NC}"
    MISSING=1
  fi
done

echo ""

# auto-001 のスクリーンショット確認
AUTO001_DIR="portfolio/samples/auto-001-email-notion/screenshots"
echo "【auto-001】n8n メール→AI→Notion："
for f in "01-workflow-overview.png" "02-claude-summary.png" "03-notion-record.png"; do
  if [ -f "$AUTO001_DIR/$f" ]; then
    echo -e "  ${GREEN}✅ $f${NC}"
  else
    echo -e "  ${RED}❌ $f （未配置）${NC}"
    MISSING=1
  fi
done

echo ""

# auto-003 のスクリーンショット確認
AUTO003_DIR="portfolio/samples/auto-003-claude-bot/screenshots"
echo "【auto-003】Slack Bot："
for f in "01-slack-bot-response.png"; do
  if [ -f "$AUTO003_DIR/$f" ]; then
    echo -e "  ${GREEN}✅ $f${NC}"
  else
    echo -e "  ${RED}❌ $f （未配置）${NC}"
    MISSING=1
  fi
done

echo ""

if [ $MISSING -eq 1 ]; then
  echo -e "${YELLOW}⚠️  未配置のスクリーンショットがあります。撮影後に再実行してください。${NC}"
  exit 1
fi

# README のデモセクションを実画像参照に更新
echo -e "${GREEN}▶ README のデモセクションを更新します...${NC}"

# auto-002 README 更新
sed -i 's|> スクリーンショットは Make でのセットアップ完了後に追加予定です。.*||g' \
  portfolio/samples/auto-002-form-slack/README.md 2>/dev/null || true

python3 - <<'EOF'
import re

# auto-002
with open("portfolio/samples/auto-002-form-slack/README.md", "r") as f:
    content = f.read()

demo_section = """## デモ
![ワークフロー全体](screenshots/01-workflow-overview.png)
![Slack通知](screenshots/02-slack-notification.png)
![スプレッドシート記録](screenshots/03-sheets-record.png)"""

content = re.sub(
    r'## デモ\n>.*?\n(>.*?\n)*',
    demo_section + "\n",
    content,
    flags=re.MULTILINE
)
with open("portfolio/samples/auto-002-form-slack/README.md", "w") as f:
    f.write(content)

# auto-001
with open("portfolio/samples/auto-001-email-notion/README.md", "r") as f:
    content = f.read()

demo_section = """## デモ
![ワークフロー全体](screenshots/01-workflow-overview.png)
![Claude要約結果](screenshots/02-claude-summary.png)
![Notion記録](screenshots/03-notion-record.png)"""

content = re.sub(
    r'## デモ\n>.*?\n(>.*?\n)*',
    demo_section + "\n",
    content,
    flags=re.MULTILINE
)
with open("portfolio/samples/auto-001-email-notion/README.md", "w") as f:
    f.write(content)

# auto-003
with open("portfolio/samples/auto-003-claude-bot/README.md", "r") as f:
    content = f.read()

demo_section = """## デモ
![Slack Bot 応答](screenshots/01-slack-bot-response.png)"""

content = re.sub(
    r'## デモ\n>.*?\n(>.*?\n)*',
    demo_section + "\n",
    content,
    flags=re.MULTILINE
)
with open("portfolio/samples/auto-003-claude-bot/README.md", "w") as f:
    f.write(content)

print("README 更新完了")
EOF

# git add & commit & push
echo ""
echo -e "${GREEN}▶ GitHub に反映します...${NC}"

git add \
  portfolio/samples/auto-002-form-slack/screenshots/ \
  portfolio/samples/auto-001-email-notion/screenshots/ \
  portfolio/samples/auto-003-claude-bot/screenshots/ \
  portfolio/samples/auto-002-form-slack/README.md \
  portfolio/samples/auto-001-email-notion/README.md \
  portfolio/samples/auto-003-claude-bot/README.md

git commit -m "[add] portfolio: 全サンプルのスクリーンショット追加・README更新"
git push origin main

if [ $? -eq 0 ]; then
  echo ""
  echo -e "${GREEN}✅ GitHub への反映完了！${NC}"
  echo "   → https://github.com/Hiro4546M/freelance-portfolio"
  echo ""
  echo -e "${YELLOW}🎉 ポートフォリオ3本が完成しました！${NC}"
  echo "次のステップ: CrowdWorks で案件に提案を始めましょう"
  echo "→ docs/procedures/03_crowdworks-proposal.md"
else
  echo -e "${RED}❌ push に失敗しました。${NC}"
fi
