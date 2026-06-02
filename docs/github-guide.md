# GitHub使い方ガイド｜このプロジェクト専用

---

## GitHubとは何か（1行で）

**コードの保管場所 ＋ ポートフォリオサイト**

作ったコードをGitHubに置いておくと、
クライアントに「これが私の作ったものです」とリンクで見せられる。
履歴書のようなもの。

---

## 最初の1回だけやること（セットアップ）

### 1. GitHubアカウント作成
```
https://github.com にアクセス → Sign up
メールアドレス・パスワード・ユーザー名を設定
```

### 2. ローカルにGitをインストール（Mac）
```bash
# Homebrewがある場合
brew install git

# インストール確認
git --version
```

### 3. 自分の名前とメールを登録
```bash
git config --global user.name "あなたの名前"
git config --global user.email "あなたのメールアドレス"
```

### 4. このプロジェクトをGitHubに登録する
```bash
# GitHubでリポジトリ（保管場所）を作る
# https://github.com/new にアクセス
# Repository name: freelance-portfolio
# Public（公開）にする → 作成

# ローカルのプロジェクトをGitHubに接続
cd freelance-ai-project/
git init
git add .
git commit -m "[add] プロジェクト初期設定"
git branch -M main
git remote add origin https://github.com/あなたのユーザー名/freelance-portfolio.git
git push -u origin main
```

---

## 覚えるのはこの3コマンドだけ

```bash
git add .          # 変更をまとめる（荷物をカバンに入れる）
git commit -m ""   # 変更を記録する（セーブポイント）
git push           # GitHubにアップロードする（クラウドに保存）
```

### イメージで理解する
```
作業フォルダ  →[add]→  準備エリア  →[commit]→  手元の記録  →[push]→  GitHub
（作業机）              （カバン）               （日記）              （クラウド）
```

---

## 普段の使い方（scripts/git-push.sh を使う）

毎回3コマンド打つのが面倒なので、1コマンドで済むスクリプトを用意してある。

```bash
# サンプルを追加したとき
bash scripts/git-push.sh "[add] portfolio: email→notion自動化サンプル追加"

# ファイルを更新したとき
bash scripts/git-push.sh "[update] CLAUDE.md: 案件ログを更新"
```

これだけ。

---

## ポートフォリオとして見せる方法

### サンプルの公開URL
```
https://github.com/あなたのユーザー名/freelance-portfolio/tree/main/portfolio/samples/auto-001-email-notion
```

このURLを提案文に貼るだけ。

### README.mdがポートフォリオページになる
GitHubは各フォルダのREADME.mdを自動で表示する。
サンプルごとにREADMEを書いておくと、クライアントが見やすい。

```markdown
# メール受信→Claude要約→Notion自動保存

## 何ができるか
受信メールをClaudeが自動要約してNotionに保存するn8nワークフロー

## 使用技術
n8n / Claude API / Notion API / Gmail

## デモ動画
[リンク]

## セットアップ手順
1. ...
```

---

## よくあるエラーと対処

### 「rejected」と出てpushできない
```bash
git pull origin main --rebase
git push origin main
```

### 誤って.envをaddしてしまった
```bash
git reset HEAD .env
# .gitignoreに.envを追加する
echo ".env" >> .gitignore
```

### .gitignore（pushしないファイルを指定）
プロジェクトルートに `.gitignore` ファイルを作って以下を記載：
```
.env
*.env
node_modules/
.DS_Store
**/client-data/
```

---

## Claude Codeにやってもらうこと

CLAUDE.mdに記載のpushタイミングで、
Claude Codeが自動的に `scripts/git-push.sh` を実行する。
自分でコマンドを打たなくてもよい。

手動でpushしたい場合は上記コマンドを使う。
