# 手順書 02｜Make ワークフロー構築・テスト・スクリーンショット

**所要時間**: 約20〜30分
**前提**: [01_make-account-setup.md](./01_make-account-setup.md) 完了済み
**目的**: auto-002 ポートフォリオの完成と GitHub への反映

---

## チェックリスト

- [ ] ブループリントのインポート
- [ ] 認証情報の設定（Google・Slack）
- [ ] フォームID・シートIDの設定
- [ ] テスト実行（回答送信 → 通知確認）
- [ ] スクリーンショット3枚撮影
- [ ] GitHub に反映

---

## Step 1: ブループリントをインポート

### 1-1. シナリオ作成画面を開く

1. [https://www.make.com](https://www.make.com) にログインする
2. 左サイドバーの「Scenarios」をクリック
3. 右上の「Create a new scenario」ボタンをクリック
4. モジュール選択画面が表示されたら、いったん右上の「×」で閉じる（インポートを使うため）

### 1-2. ブループリントをインポートする

1. シナリオエディタ画面（空のキャンバス）が表示されていることを確認する
2. 画面上部のメニューから「...」（3点リーダー）をクリック
3. 「Import Blueprint」を選択する
4. ファイル選択ダイアログが表示される
5. 以下のファイルを選択する：
   ```
   portfolio/samples/auto-002-form-slack/workflow-blueprint.json
   ```
6. 「Import」をクリックする

> インポート後、Google Forms → Google Sheets → Slack の3モジュールが並んだワークフローが表示されれば成功。

---

## Step 2: Google 認証の設定

### 2-1. Google Forms モジュールの設定

1. キャンバス上の「Google Forms」モジュールをクリックする
2. 右パネルに設定画面が開く
3. **Connection（接続）** の欄を確認する
   - 「Add」または「Create a connection」ボタンをクリック
   - 「Sign in with Google」が表示されるのでクリック
   - ブラウザのポップアップで Google アカウントを選択し、Make へのアクセスを許可する
   - 接続名（Connection name）は `Google Portfolio Demo` などわかりやすい名前を入力
4. 接続が完了したら **Form ID** の欄に手順書01でメモしたフォームIDを入力する
   - 例: `1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgVE2upms`
5. **Limit** は `5` のままでよい
6. 「OK」をクリックして保存する

### 2-2. Google Sheets モジュールの設定

1. キャンバス上の「Google Sheets」モジュールをクリックする
2. **Connection（接続）** の欄で、先ほど作成した接続（`Google Portfolio Demo`）を選択する
   - 同じ Google アカウントを使うので新規作成は不要
3. 以下の項目を設定する：

| 項目 | 設定値 |
|------|--------|
| Spreadsheet ID | 手順書01でメモしたスプレッドシートID |
| Sheet Name | `回答一覧` |

4. シート名を入力後、列マッピング（Column mapping）が表示される：
   - **A列（名前）**: `{{1.responses[0].answer}}` のような変数が自動で入るか確認
   - ブループリントに含まれている場合はそのまま。空の場合は手動でマッピングする
5. 「OK」をクリックして保存する

---

## Step 3: Slack 認証の設定

### 3-1. Slack モジュールの設定

1. キャンバス上の「Slack」モジュールをクリックする
2. **Connection（接続）** の欄で「Add」をクリック
3. Slack の認証ページが開く
   - **ワークスペース**: 手順書01で作成した `portfolio-demo` を選択する
   - 「許可する」をクリック
4. Make に戻り、接続が完了したことを確認する
5. 以下の項目を設定する：

| 項目 | 設定値 |
|------|--------|
| Channel | `通知` |
| Text | （ブループリントに設定済みのメッセージテンプレートを確認） |

> **メッセージテンプレートの例:**
> ```
> 新しいお問い合わせが届きました！
> 名前: {{名前の変数}}
> メール: {{メールの変数}}
> 内容: {{内容の変数}}
> 受信日時: {{now}}
> ```

6. 「OK」をクリックして保存する

---

## Step 4: テスト実行

### 4-1. シナリオを保存する

1. 画面下部の「Save」ボタンをクリックして設定を保存する
2. エラーがないことを確認する（モジュール左下に赤いマークがなければOK）

### 4-2. テスト実行を開始する

1. 画面左下の「Run once」ボタンをクリックする
2. Make が待機状態（Listening...）になる

### 4-3. テスト用フォームを送信する

1. 新しいブラウザタブで Google フォームを開く
   - URL: `https://docs.google.com/forms/d/[フォームID]/viewform`
2. 以下のテストデータを入力して送信する：

| 項目 | 入力値 |
|------|--------|
| お名前 | テスト 太郎 |
| メールアドレス | test@example.com |
| お問い合わせ内容 | これはポートフォリオデモのテスト送信です。 |

3. 「送信」ボタンをクリックする

### 4-4. 結果を確認する

Make のダッシュボードに戻り、以下を確認する：

- [ ] Slack の `#通知` チャンネルにメッセージが届いた
- [ ] スプレッドシートの「回答一覧」シートに1行追加された
- [ ] スプレッドシートの名前・メール・内容が正しく記録されている
- [ ] Make の実行ログにエラーが表示されていない（緑のチェックマーク）

> **うまく動かない場合の確認ポイント:**
> - フォームID・スプレッドシートIDが正しいか再確認する
> - Slack のチャンネル名が `通知` と完全一致しているか確認する
> - Google の認証が切れていないか確認する（再認証が必要な場合あり）

---

## Step 5: スクリーンショット撮影

ポートフォリオの証拠として3枚のスクリーンショットを撮影する。

### 撮影する画面と保存先

#### スクリーンショット 1: ワークフロー全体図

- **撮影する画面**: Make シナリオエディタ（3つのモジュールが並んでいる全体図）
- **見せたいポイント**: Google Forms → Google Sheets → Slack の連携フローが一目でわかる状態
- **保存先**:
  ```
  portfolio/samples/auto-002-form-slack/screenshots/01-workflow-overview.png
  ```

#### スクリーンショット 2: Slack 通知メッセージ

- **撮影する画面**: Slack の `#通知` チャンネルに届いたメッセージ
- **見せたいポイント**: 名前・メール・内容・受信日時がきれいにフォーマットされている状態
- **保存先**:
  ```
  portfolio/samples/auto-002-form-slack/screenshots/02-slack-notification.png
  ```

#### スクリーンショット 3: スプレッドシートの記録

- **撮影する画面**: Google スプレッドシートの「回答一覧」シート
- **見せたいポイント**: ヘッダー行と1件のデータが正しく記録されている状態
- **保存先**:
  ```
  portfolio/samples/auto-002-form-slack/screenshots/03-sheets-record.png
  ```

### 撮影のコツ

- Chrome の場合: `Ctrl + Shift + P` → 「screenshot」と入力 → 「Capture full size screenshot」で全画面キャプチャ
- または Windows のSnipping Tool（`Win + Shift + S`）を使う
- 個人情報が映り込まないよう、テストデータ（`テスト 太郎`、`test@example.com`）を使うこと

---

## Step 6: GitHub に反映

スクリーンショットの保存が完了したら、以下のコマンドで GitHub に反映する。

```bash
cd /home/hiro/projects/AI_Company/projects/freelance-ai-project-v3

# スクリーンショットを追加
git add portfolio/samples/auto-002-form-slack/screenshots/

# コミット
git commit -m "[add] portfolio: auto-002 スクリーンショット追加"

# プッシュ
git push origin main
```

### README への反映（任意だが推奨）

スクリーンショットを GitHub の README に表示させると、訪問者に視覚的にアピールできる。

`portfolio/samples/auto-002-form-slack/README.md` を開き、以下のように画像を追加する：

```markdown
## スクリーンショット

### ワークフロー全体図
![ワークフロー全体図](screenshots/01-workflow-overview.png)

### Slack 通知
![Slack 通知](screenshots/02-slack-notification.png)

### スプレッドシート記録
![スプレッドシート記録](screenshots/03-sheets-record.png)
```

README を更新した場合は追加でコミットする：

```bash
git add portfolio/samples/auto-002-form-slack/README.md
git commit -m "[update] portfolio: auto-002 READMEにスクリーンショット追加"
git push origin main
```

---

## 完了確認

- [ ] スクリーンショット3枚が `screenshots/` フォルダに保存されている
- [ ] GitHub にプッシュ済み（コミットハッシュをメモしておくと便利）
- [ ] GitHub のリポジトリページでスクリーンショットが表示されることを確認した
- [ ] README にスクリーンショットのリンクを追加した（任意）

---

**次のステップ**: `03_crowdworks-proposal.md`（案件への提案文作成）
