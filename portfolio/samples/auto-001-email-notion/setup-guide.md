# セットアップガイド｜メール→AI要約→Notion

## 必要なもの
- n8n（Docker または `npx n8n` で起動）
- Google アカウント（Gmail）
- Anthropic API キー（https://console.anthropic.com）
- Notion アカウント（無料）

## 手順

### 1. Notion データベースを作成
1. notion.so で新しいページを作成
2. 「/database」でデータベースを追加
3. 以下のプロパティを設定：

   | プロパティ名 | 型の変更方法 |
   |---|---|
   | タイトル | デフォルトのまま（件名として使用） |
   | 送信者 | 「テキスト」→「メール」に変更 |
   | 要約 | 「テキスト」のまま |
   | 受信日時 | 「テキスト」→「日付」に変更 |

4. データベースIDをメモ（URLの末尾32文字）

### 2. Notion インテグレーションを作成
1. https://notion.so/my-integrations → 「New integration」
2. 名前：`n8n-email-bot`
3. 権限：「Read content」「Insert content」にチェック
4. シークレットキーをメモ
5. データベースページ右上「...」→「Connections」→ 作成したインテグレーションを追加

### 3. n8n を起動

```bash
npx n8n
# ブラウザで http://localhost:5678 を開く
```

### 4. ワークフローをインポート
1. n8n → 画面右上「+」→「Import from File」
2. `workflow.json` を選択

### 5. 認証情報を設定
各ノードをクリックして認証情報を入力：

- **Gmail トリガー**：「Gmail OAuth2」でGoogleアカウントと接続
- **Claude で要約**：「HTTP Header Auth」を作成
  - 名前: `Claude API Key`
  - ヘッダー名: `x-api-key`
  - 値: Anthropic API キー
- **Notion に保存**：「Notion API」を作成
  - API Key: Notion インテグレーションのシークレット

### 6. データベースIDを設定
「Notion に保存」ノードの `databaseId` にメモしたIDを入力。

### 7. テスト実行 → 有効化
1. 「Execute Workflow」でテスト実行
2. テスト用メールを送信
3. Notion にレコードが追加されたか確認
4. 動作確認後、右上トグルをONにして有効化

## トラブルシューティング

- **Gmail 認証エラー**：Google Cloud Console で Gmail API が有効になっているか確認
- **Notion エラー `object_not_found`**：インテグレーションがデータベースに接続されているか確認
- **Claude API エラー 401**：`x-api-key` ヘッダー名とAPIキーが正しいか確認
- **要約が空**：`snippet` フィールドが空のメールがある場合に発生。メール本文が短すぎると snippet が生成されない
