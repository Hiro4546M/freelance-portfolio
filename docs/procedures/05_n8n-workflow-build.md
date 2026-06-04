# 手順書 05｜n8n ワークフロー構築・テスト・スクリーンショット

**所要時間**: 約20〜30分
**前提**: [04_n8n-notion-setup.md](./04_n8n-notion-setup.md) 完了済み
**目的**: auto-001 ポートフォリオの完成と GitHub への反映

---

## チェックリスト

- [ ] ワークフロー JSON のインポート
- [ ] Gmail 認証設定
- [ ] Claude API 認証設定
- [ ] Notion 認証設定・データベースID入力
- [ ] テスト実行（メール送信 → Notion 記録確認）
- [ ] スクリーンショット3枚撮影
- [ ] GitHub に反映

---

## Step 1: ワークフローをインポート

1. ブラウザで http://localhost:5678 を開く
2. 左サイドバーの「Workflows」をクリックする
3. 右上の「+」ボタンをクリックする
4. 「Import from File」を選択する
5. 以下のファイルを選択する:

```
portfolio/samples/auto-001-email-notion/workflow.json
```

インポートが成功すると、3つのノード（Gmail トリガー・Claude で要約・Notion に保存）が接続されたワークフローが表示される。

---

## Step 2: Gmail 認証の設定

1. ワークフロー上の「Gmail トリガー」ノードをクリックする
2. 右側のパネルで「Credentials」欄を探す
3. ドロップダウンから「Create new credential」を選択する
4. 「Gmail OAuth2」を選択する
5. 「Sign in with Google」ボタンをクリックする
6. Google アカウント選択画面でアカウントを選択し、「許可」をクリックする
7. ブラウザが n8n に戻り、認証完了のメッセージが表示される

**補足: Google Cloud Console の設定が必要な場合**

Gmail OAuth2 を初めて使う場合、Google Cloud Console でプロジェクトと認証情報を作成する必要がある。

1. https://console.cloud.google.com にアクセスする
2. プロジェクトを作成する（例: `n8n-local`）
3. 「APIとサービス」→「ライブラリ」で「Gmail API」を有効にする
4. 「認証情報」→「認証情報を作成」→「OAuth クライアントID」を選択する
5. アプリケーションの種類を「ウェブアプリケーション」にする
6. 承認済みリダイレクトURIに `http://localhost:5678/rest/oauth2-credential/callback` を追加する
7. クライアントIDとクライアントシークレットを n8n の認証情報入力欄に貼り付ける

---

## Step 3: Claude API 認証の設定

n8n の HTTP Request ノードでは「HTTP Header Auth」を使って Anthropic API にアクセスする。

1. 「Claude で要約」ノードをクリックする
2. 「Credentials」欄で「Create new credential」を選択する
3. 「HTTP Header Auth」を選択する
4. 以下を入力する:
   - **名前（表示名）**: `Claude API Key`
   - **Name（ヘッダー名）**: `x-api-key`（ハイフン1つ、スペースなし）
   - **Value**: Anthropic API キー（`sk-ant-` から始まる文字列）を貼り付ける
5. 「Save」をクリックする

**注意**: `x-api-key` のスペルを正確に入力すること。大文字・小文字の違いでエラーになる。

---

## Step 4: Notion 認証の設定

1. 「Notion に保存」ノードをクリックする
2. 「Credentials」欄で「Create new credential」を選択する
3. 「Notion API」を選択する
4. **Internal Integration Secret** の欄に、手順書04でコピーした `secret_` から始まる文字列を貼り付ける
5. 「Save」をクリックする
6. 同じノードの設定欄で「Database ID」を探す
7. 手順書04でメモしたデータベースID（32文字の英数字）を入力する

---

## Step 5: テスト実行

準備が整ったら実際にワークフローを実行してテストする。

### 5-1. テスト用メールを送信

自分の Gmail アドレス宛に件名・本文を含むテストメールを送信する。

- 件名例: `【テスト】n8n ワークフロー動作確認`
- 本文例: 数行のダミーテキスト（要約が正常に生成されることを確認するため）

### 5-2. ワークフローを実行

1. n8n のワークフロー画面右上の「Execute Workflow」をクリックする
2. Gmail トリガーがメールを検出するまで5〜10秒待機する
3. 各ノードの上に緑のチェックマークが表示されれば成功

### 5-3. 完了確認

- [ ] n8n の実行ログに「Success」が表示されている
- [ ] Notion データベースに新しい行が追加されている
- [ ] 件名・送信者・要約（3行以内）・受信日時が正しく入っている
- [ ] 要約が日本語で自然な内容になっている

---

## Step 6: スクリーンショット撮影

ポートフォリオとして GitHub に掲載するスクリーンショットを3枚撮影する。

撮影前に以下のディレクトリを作成する:

```bash
mkdir -p /home/hiro/projects/AI_Company/projects/freelance-ai-project-v3/portfolio/samples/auto-001-email-notion/screenshots
```

### 撮影する3枚と保存先

**1枚目: ワークフロー全体図**

- 内容: n8n のワークフロー全体図。3つのノード（Gmail トリガー・Claude で要約・Notion に保存）が矢印で接続されている画面
- 保存先: `portfolio/samples/auto-001-email-notion/screenshots/01-workflow-overview.png`
- ポイント: ノード全体が画面に収まるようにズームを調整する

**2枚目: Claude 要約ノードの出力**

- 内容: 実行ログの「Claude で要約」ノードの出力詳細。`content[0].text` の要約テキストが確認できる画面
- 保存先: `portfolio/samples/auto-001-email-notion/screenshots/02-claude-summary.png`
- ポイント: ノードをクリックして右パネルの「Output」タブを開き、要約テキストが読めるサイズで撮影する

**3枚目: Notion データベースの記録**

- 内容: Notion データベースのテーブルビュー。テスト実行で追加された行（件名・送信者・要約・受信日時）が表示されている画面
- 保存先: `portfolio/samples/auto-001-email-notion/screenshots/03-notion-record.png`
- ポイント: 追加された行全体が見えるようにスクロール位置を調整する

---

## Step 7: GitHub に反映

スクリーンショット撮影後、GitHub にプッシュしてポートフォリオを公開する。

```bash
cd /home/hiro/projects/AI_Company/projects/freelance-ai-project-v3
git add portfolio/samples/auto-001-email-notion/screenshots/
git commit -m "[add] portfolio: auto-001 スクリーンショット追加"
git push origin main
```

プッシュ後、GitHub のリポジトリページで画像が表示されることを確認する。

---

## トラブルシューティング

### Gmail 認証に失敗する

- Google Cloud Console で Gmail API が有効になっているか確認する
- リダイレクトURIが `http://localhost:5678/rest/oauth2-credential/callback` になっているか確認する
- ブラウザのポップアップブロックが有効になっている場合は無効にする

### 要約ノードでエラーが出る

- `x-api-key` ヘッダー名のスペルを確認する（`x-api-key` は半角ハイフン、スペースなし）
- Anthropic API キーの有効期限・残高を確認する（https://console.anthropic.com）
- エラーメッセージが `401` の場合はAPIキーが誤っている

### Notion にデータが保存されない

- Notion インテグレーションがデータベースに「接続済み（Connected）」になっているか確認する（手順書04 Step 4-3）
- データベースIDの入力が正しいか確認する（32文字の英数字、ハイフンなし）
- インテグレーションに「Insert content」権限が付与されているか確認する

### ワークフローがメールを検出しない

- Gmail トリガーの「Polling Time」設定を確認する（デフォルトは1分ごと）
- 「Execute Workflow」ではなく「Listen for Test Event」を使ってリアルタイムで試す
- Gmail フィルタで受信トレイに届いているか確認する（スパムフォルダに入っている場合がある）

---

## 完了確認

- [ ] スクリーンショット3枚が `screenshots/` フォルダに保存されている
- [ ] GitHub にプッシュ済みでリポジトリ上で画像が確認できる

**次のステップ**: [03_crowdworks-proposal.md](./03_crowdworks-proposal.md)（提案開始）
