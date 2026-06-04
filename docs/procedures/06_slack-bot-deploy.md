# 手順書 06｜Slack Bot セットアップ・デプロイ・スクリーンショット

**所要時間**: 約40〜60分
**前提**: Python 環境あり、Slack ワークスペースあり（auto-002 で作成）
**目的**: auto-003 ポートフォリオの完成とGitHubへの反映

## チェックリスト
- [ ] Slack App 作成（api.slack.com）
- [ ] Bot Token・Signing Secret を取得
- [ ] 依存関係インストール
- [ ] .env 設定（env.example をコピー）
- [ ] ngrok でローカルを公開
- [ ] Slack App に URL 登録
- [ ] Slack でメンションしてボット動作確認
- [ ] スクリーンショット1枚撮影
- [ ] GitHub に反映

---

## Step 1: Slack App の作成

1. ブラウザで https://api.slack.com/apps を開く
2. 「Create New App」ボタンをクリック
3. 「From scratch」を選択
4. 以下を入力：
   - App Name: `FAQ Bot`
   - ワークスペース: auto-002 で作成したデモワークスペースを選択
5. 「Create App」をクリック

---

## Step 2: Bot Token Scopes の設定

1. 左メニューの「OAuth & Permissions」をクリック
2. 「Bot Token Scopes」セクションまでスクロール
3. 「Add an OAuth Scope」をクリックし、以下を追加：
   - `chat:write`
   - `app_mentions:read`
4. ページ上部の「Install to Workspace」ボタンをクリック
5. 「Allow」をクリック
6. 「Bot User OAuth Token」（`xoxb-` で始まる文字列）をコピーして保存

---

## Step 3: Signing Secret の取得

1. 左メニューの「Basic Information」をクリック
2. 「App Credentials」セクションまでスクロール
3. 「Signing Secret」の横にある「Show」をクリック
4. 表示された文字列をコピーして保存

---

## Step 4: 環境変数の設定

```bash
cd portfolio/samples/auto-003-claude-bot
cp env.example .env
```

`.env` ファイルを開いて以下を設定：

```
SLACK_BOT_TOKEN=xoxb-...        # Step 2 でコピーしたもの
SLACK_SIGNING_SECRET=...        # Step 3 でコピーしたもの
ANTHROPIC_API_KEY=sk-ant-...    # 既存の API キー
```

---

## Step 5: 依存関係のインストールとサーバー起動

既存の .venv を使用する場合：

```bash
.venv/bin/python app.py
# → http://localhost:3000 で起動
```

.venv がない場合：

```bash
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
.venv/bin/python app.py
```

ターミナルに `⚡️ Bolt app is running!` が表示されれば起動成功。

---

## Step 6: ngrok でローカルを公開

ngrok はすでに `scripts/bin/ngrok` にインストール済みです。

**初回のみ：ngrok アカウント登録と authtoken 設定**

1. https://ngrok.com/signup で無料アカウント登録
2. ログイン後 https://dashboard.ngrok.com/get-started/your-authtoken を開く
3. authtoken をコピーして以下を実行：

```bash
scripts/bin/ngrok config add-authtoken YOUR_TOKEN_HERE
```

**別ターミナルで起動：**

```bash
bash scripts/start-ngrok.sh
# → https://xxxx-xxxx.ngrok-free.app のような URL が表示される
```

表示された `https://` の URL をコピーして保存する（次のステップで使用）。

---

## Step 7: Slack App に Event URL を登録

1. https://api.slack.com/apps を開き、作成した `FAQ Bot` をクリック
2. 左メニューの「Event Subscriptions」をクリック
3. 「Enable Events」を ON にする
4. 「Request URL」に以下を入力：
   ```
   https://xxxx.ngrok-free.app/slack/events
   ```
   （`xxxx.ngrok-free.app` は Step 6 で取得した URL に置き換える）
5. Slack が自動検証を行い、「Verified ✅」と表示されれば成功
   - 表示されない場合は「トラブルシューティング」を参照
6. 「Subscribe to bot events」セクションで「Add Bot User Event」をクリック
7. `app_mention` を検索して追加
8. 「Save Changes」をクリック

---

## Step 8: Bot をチャンネルに招待

1. Slack の自分のデモワークスペースを開く
2. `#通知` チャンネル（または任意のチャンネル）を開く
3. メッセージ入力欄に以下を入力して送信：
   ```
   /invite @FAQ Bot
   ```
4. 「FAQ Bot をチャンネルに追加しました」と表示されれば完了

---

## Step 9: 動作確認

チャンネルのメッセージ入力欄に以下のようにメンションして送信：

```
@FAQ Bot 有給申請の方法を教えてください
```

数秒後にスレッドへ返答が来ることを確認する。  
返答がない場合は「トラブルシューティング」を参照。

---

## Step 10: スクリーンショット撮影

撮影内容：
- Slack でメンションした質問と、Bot の返答が表示されているスレッド画面

保存先：

```bash
# screenshots ディレクトリの作成（存在しない場合）
mkdir -p portfolio/samples/auto-003-claude-bot/screenshots
```

ファイル名: `portfolio/samples/auto-003-claude-bot/screenshots/01-slack-bot-response.png`

**撮影のコツ**: スレッドを開いた状態でスクリーンショットを撮ると、質問と回答が両方見えて見栄えが良くなる。

---

## Step 11: README のデモ画像参照を有効化

スクリーンショット撮影後、`portfolio/samples/auto-003-claude-bot/README.md` の「デモ」セクションを以下に更新：

```markdown
## デモ

![Slack Bot 応答](screenshots/01-slack-bot-response.png)
```

---

## Step 12: GitHub に反映

```bash
cd /home/hiro/projects/AI_Company/projects/freelance-ai-project-v3
git add portfolio/samples/auto-003-claude-bot/screenshots/
git add portfolio/samples/auto-003-claude-bot/README.md
git commit -m "[add] portfolio: auto-003 スクリーンショット追加・README更新"
git push origin main
```

---

## トラブルシューティング

| 症状 | 確認事項 |
|------|---------|
| Request URL が「Verified」にならない | `python app.py` が起動しているか確認。ngrok URL が最新か確認（ngrok を再起動すると URL が変わる） |
| Bot が返答しない | Slack App の Event Subscriptions で `app_mention` が有効か確認。Bot がチャンネルに招待済みか確認 |
| 署名エラー（403） | `.env` の `SLACK_SIGNING_SECRET` が正しいか確認 |
| `ModuleNotFoundError` | `.venv/bin/pip install -r requirements.txt` を再実行 |
| ngrok が使えない | ngrok のアカウント登録が必要な場合がある（無料プランで可）。https://dashboard.ngrok.com/signup |

---

## 完了確認

- [ ] スクリーンショットが GitHub に反映
- [ ] GitHub の README でデモ画像が表示される
- [ ] ポートフォリオ3本完成
- [ ] 次のステップ → CrowdWorks に「ポートフォリオ」欄を追加

---

## ポートフォリオ完成後にやること

1. CrowdWorks プロフィールの「ポートフォリオ」欄に GitHub リンクを追加
2. 「n8n」「Make」「業務自動化」で案件検索開始
3. `docs/procedures/03_crowdworks-proposal.md` に従って提案開始
