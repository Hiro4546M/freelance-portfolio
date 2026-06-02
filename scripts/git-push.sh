#!/bin/bash
# git-push.sh｜GitHub自動pushスクリプト
# 使い方: bash scripts/git-push.sh "コミットメッセージ"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

if [ -z "$1" ]; then
  echo -e "${YELLOW}使い方: bash scripts/git-push.sh \"コミットメッセージ\"${NC}"
  echo ""
  echo "例:"
  echo "  bash scripts/git-push.sh \"[add] portfolio: email→notion自動化サンプル追加\""
  echo "  bash scripts/git-push.sh \"[update] CLAUDE.md: 案件ログを更新\""
  exit 1
fi

COMMIT_MSG="$1"

# .envの誤push防止
if git status --porcelain | grep -q "\.env"; then
  echo -e "${RED}⚠️  .envファイルが検出されました。pushを中止します。${NC}"
  echo ".gitignoreに.envを追加してから再試行してください。"
  exit 1
fi

# 変更確認
if [ -z "$(git status --porcelain)" ]; then
  echo -e "${YELLOW}変更がありません。pushをスキップします。${NC}"
  exit 0
fi

echo -e "${GREEN}▶ git add .${NC}"
git add .

echo -e "${GREEN}▶ git commit${NC}"
git commit -m "$COMMIT_MSG"

echo -e "${GREEN}▶ git push${NC}"
git push origin main

if [ $? -eq 0 ]; then
  echo ""
  echo -e "${GREEN}✅ GitHubへのpush完了！${NC}"
  REPO_URL=$(git remote get-url origin 2>/dev/null | sed 's/git@github.com:/https:\/\/github.com\//' | sed 's/\.git$//')
  [ ! -z "$REPO_URL" ] && echo "  → ${REPO_URL}"
else
  echo -e "${RED}❌ pushに失敗しました。${NC}"
  echo "→ git pull origin main --rebase を試してから再実行してください。"
fi
