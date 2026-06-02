# Phase 1 ポートフォリオ構築 ＋ 初受注 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** ポートフォリオ3本をGitHubに公開し、CrowdWorksで提案を開始して最初の受注2件・★5評価を獲得する

**Architecture:** ローリング型（auto-002完成→提案開始→auto-001並行開発→auto-003）。Make/n8nワークフローはJSONで管理・GitHubで公開。Python BotはFlask+Slack SDK。

**Tech Stack:** Make（無料）/ n8n（ローカル）/ Python 3.11 / Flask / slack-sdk / anthropic SDK / pytest

---

## ファイル構成

```
portfolio/samples/auto-002-form-slack/
├── README.md                    # 更新（既存スタブ → 完全版）
├── workflow-blueprint.json      # Make シナリオ（インポート用）
├── setup-guide.md              # クライアント向けセットアップ手順
└── screenshots/                 # （手動で撮影・配置）

portfolio/samples/auto-001-email-notion/
├── README.md                    # 更新（既存スタブ → 完全版）
├── workflow.json                # n8n ワークフロー（インポート用）
├── setup-guide.md
└── screenshots/

portfolio/samples/auto-003-claude-bot/
├── app.py                       # Flask + Slack Bot 本体
├── requirements.txt
├── .env.example
├── README.md                    # 更新
├── tests/
│   └── test_bot.py
└── screenshots/

profile/
└── crowdworks-profile.md        # GitHub URL 更新
```

---

## Task 1: auto-002 環境準備（ブラウザ作業）

**Files:** なし（ブラウザ・外部サービス設定）

- [ ] **Step 1: Slack デモワークスペース作成**

  slack.com/get-started で新規ワークスペース作成。
  名前例：`freelance-demo`
  チャンネル `#通知` を作成しておく。

- [ ] **Step 2: Google フォーム作成**

  forms.google.com で新規フォームを作成。
  フィールド構成：
  ```
  ① お名前（短文）
  ② メールアドレス（短文）
  ③ お問い合わせ内容（長文）
  ```
  フォームIDをメモしておく（URLの `/d/xxxxxxxx/` 部分）。

- [ ] **Step 3: Google スプレッドシート作成**

  sheets.google.com で新規シートを作成。
  シート名：`回答一覧`
  1行目にヘッダー：`名前` / `メール` / `内容` / `受信日時`
  スプレッドシートIDをメモ（URLの `/d/xxxxxxxx/` 部分）。

- [ ] **Step 4: Make アカウント作成**

  make.com で無料アカウント登録。
  Google アカウントでサインアップすると連携が楽。

---

## Task 2: Make ワークフロー JSON 作成（Claude Code 実行）

**Files:**
- Create: `portfolio/samples/auto-002-form-slack/workflow-blueprint.json`

- [ ] **Step 1: ブループリント JSON を作成**

  以下の内容で `portfolio/samples/auto-002-form-slack/workflow-blueprint.json` を作成：

  ```json
  {
    "name": "Googleフォーム→Slack通知＋スプレッドシート記録",
    "flow": [
      {
        "id": 1,
        "module": "google-forms:TriggerFormNewResponseEvent",
        "version": 1,
        "parameters": {
          "formId": "YOUR_FORM_ID"
        },
        "mapper": {},
        "metadata": {
          "designer": { "x": 0, "y": 0 },
          "restore": {
            "parameters": {
              "formId": { "label": "お問い合わせフォーム" }
            }
          }
        }
      },
      {
        "id": 2,
        "module": "google-sheets:addRow",
        "version": 2,
        "parameters": {
          "spreadsheetId": "YOUR_SPREADSHEET_ID",
          "sheetId": "回答一覧",
          "includesHeaders": true
        },
        "mapper": {
          "values": {
            "名前": "{{1.responses[].answer}}",
            "メール": "{{1.respondentEmail}}",
            "内容": "{{1.responses[1].answer}}",
            "受信日時": "{{formatDate(now; 'YYYY-MM-DD HH:mm:ss')}}"
          }
        },
        "metadata": {
          "designer": { "x": 300, "y": 0 }
        }
      },
      {
        "id": 3,
        "module": "slack:createMessage",
        "version": 1,
        "parameters": {
          "channel": "通知"
        },
        "mapper": {
          "text": "📬 *新しいお問い合わせが届きました*\n\n*名前:* {{1.responses[0].answer}}\n*メール:* {{1.respondentEmail}}\n*内容:* {{1.responses[1].answer}}\n*受信:* {{formatDate(now; 'MM/DD HH:mm')}}"
        },
        "metadata": {
          "designer": { "x": 600, "y": 0 }
        }
      }
    ],
    "metadata": {
      "instant": true,
      "version": 1,
      "scenario": {
        "roundtrips": 1,
        "maxErrors": 3,
        "autoCommit": true,
        "autoCommitTriggerLast": true,
        "sequential": false
      }
    }
  }
  ```

---

## Task 3: Make でワークフロー構築・テスト（ブラウザ作業）

**Files:** なし（Make UI での操作）

- [ ] **Step 1: Make にシナリオをインポート**

  Make のダッシュボード → 「Create a new scenario」→ 右上の「...」→「Import Blueprint」
  `workflow-blueprint.json` を選択してインポート。

- [ ] **Step 2: 認証情報を設定**

  各モジュールの認証を設定：
  - Google Forms：Googleアカウント接続
  - Google Sheets：同じGoogleアカウント
  - Slack：作成したワークスペースを接続

- [ ] **Step 3: フォームIDとシートIDを設定**

  Task 1 でメモしたIDを各モジュールに入力。

- [ ] **Step 4: テスト実行**

  Googleフォームにテスト回答を送信。
  確認項目：
  - ✅ スプレッドシートに行が追加された
  - ✅ Slack `#通知` チャンネルにメッセージが届いた

- [ ] **Step 5: シナリオをエクスポートして更新**

  Make の「...」→「Export Blueprint」でJSONをダウンロード。
  `workflow-blueprint.json` を上書き更新（実際のIDが入った版）。
  ※ `YOUR_FORM_ID` など仮の値が残っていたら実際の値に置換する。

---

## Task 4: auto-002 README + セットアップガイド作成（Claude Code 実行）

**Files:**
- Modify: `portfolio/samples/auto-002-form-slack/README.md`
- Create: `portfolio/samples/auto-002-form-slack/setup-guide.md`
- Create: `portfolio/samples/auto-002-form-slack/screenshots/` (ディレクトリのみ)

- [ ] **Step 1: README を完全版に更新**

  ```markdown
  # Googleフォーム送信 → Slack通知 ＋ スプレッドシート自動記録

  ## デモ
  ![ワークフロー全体](screenshots/01-workflow-overview.png)
  ![Slack通知](screenshots/02-slack-notification.png)
  ![スプレッドシート記録](screenshots/03-sheets-record.png)

  ## 何ができるか
  Googleフォームに回答が届くと、即座にSlackへ通知し、スプレッドシートに自動記録します。
  メール通知の遅延をなくし、担当者がリアルタイムで対応できます。

  ## ユースケース
  - 問い合わせフォームの即時通知
  - 採用応募の管理
  - イベント申込の集計

  ## 使用ツール
  - [Make](https://make.com) （旧Integromat）
  - Google Forms
  - Google Sheets
  - Slack

  ## セットアップ
  → [setup-guide.md](setup-guide.md) を参照

  ## ワークフロー構成
  ```
  Googleフォーム 新規回答
      ↓
  Google Sheets に行追加（名前・メール・内容・受信日時）
      ↓
  Slack #通知 チャンネルにメッセージ送信
  ```

  ## 費用
  Make 無料プラン（月1,000オペレーション）で動作します。
  ```

- [ ] **Step 2: setup-guide.md を作成**

  ```markdown
  # セットアップガイド｜Googleフォーム→Slack通知＋スプレッドシート

  ## 必要なもの
  - Makeアカウント（無料）: https://make.com
  - Googleアカウント（Forms・Sheets）
  - Slackワークスペース

  ## 手順（約30分）

  ### 1. Googleフォームを作成
  1. forms.google.com で新規フォーム作成
  2. フィールドを追加（名前・メール・内容など）
  3. フォームIDをメモ（URLの `/d/XXXX/` 部分）

  ### 2. Googleスプレッドシートを作成
  1. sheets.google.com で新規シート作成
  2. 1行目にヘッダーを入力
  3. スプレッドシートIDをメモ

  ### 3. Slackチャンネルを用意
  1. 通知を受け取るチャンネルを作成（例：#問い合わせ）

  ### 4. Makeにシナリオをインポート
  1. make.com にログイン
  2. 「Create a new scenario」
  3. 右上「...」→「Import Blueprint」
  4. `workflow-blueprint.json` をアップロード

  ### 5. 認証情報を設定
  1. Google Formsモジュール：Googleアカウントでログイン
  2. Google Sheetsモジュール：同じアカウントを選択
  3. Slackモジュール：ワークスペースを接続

  ### 6. IDを設定して有効化
  1. フォームID・スプレッドシートIDを各モジュールに入力
  2. 「Run once」でテスト実行
  3. 動作確認後「Scheduling」をONに設定

  ## トラブルシューティング
  - **Slackに通知が来ない**: Slackモジュールの認証を再接続してください
  - **スプレッドシートに記録されない**: シートIDが正しいか確認してください
  ```

- [ ] **Step 3: screenshots ディレクトリを作成**

  ```bash
  mkdir -p portfolio/samples/auto-002-form-slack/screenshots
  touch portfolio/samples/auto-002-form-slack/screenshots/.gitkeep
  ```

- [ ] **Step 4: スクリーンショットを撮影（ブラウザ作業）**

  以下3枚を撮影して `screenshots/` に配置：
  - `01-workflow-overview.png`：Make のワークフロー全体図
  - `02-slack-notification.png`：Slack に届いた通知メッセージ
  - `03-sheets-record.png`：スプレッドシートに記録された行

---

## Task 5: auto-002 GitHub push

**Files:** 上記すべて

- [ ] **Step 1: コミットしてpush**

  ```bash
  git add portfolio/samples/auto-002-form-slack/
  git commit -m "[add] portfolio: auto-002 Googleフォーム→Slack通知＋スプレッドシート完成"
  git push origin main
  ```

- [ ] **Step 2: GitHub で確認**

  https://github.com/Hiro4546M/freelance-portfolio を開き、
  `portfolio/samples/auto-002-form-slack/README.md` が表示されることを確認。

---

## Task 6: CrowdWorks プロフィール更新

**Files:**
- Modify: `profile/crowdworks-profile.md`

- [ ] **Step 1: GitHub URL を更新**

  `profile/crowdworks-profile.md` の以下の行を：
  ```
  https://github.com/（GitHubユーザー名）/freelance-portfolio
  ```
  以下に変更：
  ```
  https://github.com/Hiro4546M/freelance-portfolio
  ```
  TODOチェックリストの `[ ]` も `[x]` に更新する。

- [ ] **Step 2: コミット**

  ```bash
  git add profile/crowdworks-profile.md
  git commit -m "[update] profile: GitHub URL を実際のリポジトリに更新"
  git push origin main
  ```

- [ ] **Step 3: CrowdWorks プロフィールを設定（ブラウザ作業）**

  crowdworks.jp にログイン → プロフィール編集。
  `profile/crowdworks-profile.md` の内容をコピーして設定：
  - タイトル欄
  - 自己紹介文欄
  - スキルタグ

---

## Task 7: 最初の提案3件を準備・送信（ブラウザ作業）

**Files:**
- Modify: `logs/projects.md`

- [ ] **Step 1: CrowdWorks で案件を検索**

  以下のキーワードで検索（優先順）：
  1. `Make`
  2. `n8n`
  3. `業務自動化`

  選定基準：
  - 単価 3万円以上（初期は 1万円以上でも可）
  - 要件が「〇〇を自動化したい」と明確
  - 受けない：ライティングのみ・要件が曖昧・サーバー構築

- [ ] **Step 2: 提案文を作成（案件ごと）**

  `profile/proposal-template.md` のテンプレA（デモあり）を使用：

  ```
  ご依頼内容を拝見しました。
  〇〇（課題の要約）を自動化するご要望ですね。

  類似システムの構築サンプルがあります。
  ▼ ポートフォリオ（GitHub）
  https://github.com/Hiro4546M/freelance-portfolio

  本実装では〇〇と△△を追加して完成させます。

  【対応内容】
  ・使用ツール：Make / n8n（要件に応じて選定）
  ・納品物：ワークフロー本体 ＋ 操作手順書
  ・納期：要件確認後から5営業日以内

  【お見積もり】
  〇〇円（税込・CrowdWorks手数料込）

  仕様で不明な点があれば着手前に確認します。
  よろしくお願いいたします。
  ```

- [ ] **Step 3: 提案を送信**

  3件送信する（月・水・金ペースが理想、初回は連日でも可）。

- [ ] **Step 4: logs/projects.md に記録**

  送信した案件ごとに以下を追記：

  ```markdown
  ## [001] 案件タイトル

  - **プラットフォーム**：CrowdWorks
  - **カテゴリ**：Make / 業務自動化
  - **提案日**：2026-06-XX
  - **単価**：¥XX,000
  - **ステータス**：提案中
  - **デモ作成**：なし
  - **サンプル保存**：-
  - **メモ**：（案件の特記事項）
  ```

- [ ] **Step 5: コミット**

  ```bash
  git add logs/projects.md
  git commit -m "[update] logs: 提案 001〜003 を記録"
  git push origin main
  ```

---

## Task 8: auto-001 環境準備（n8n + Notion）

**Files:** なし（外部サービス設定）

- [ ] **Step 1: n8n をローカルで起動**

  ```bash
  npx n8n
  ```

  ブラウザで http://localhost:5678 が開けることを確認。
  初回はアカウント設定（メール・パスワード）を入力。

- [ ] **Step 2: Notion アカウント作成（未作成の場合）**

  notion.so で無料アカウント作成。
  新規データベースを作成：名前「メール要約」
  プロパティ構成：
  ```
  件名（タイトル）/ 送信者（メール）/ 要約（テキスト）/ 受信日時（日付）
  ```
  データベースIDをメモ（URLの末尾32文字）。

- [ ] **Step 3: Notion インテグレーションを作成**

  notion.so/my-integrations → 「New integration」
  名前：`n8n-email-bot`
  作成後にシークレットキーをメモ。
  作成したデータベースにインテグレーションを接続（データベース右上「...」→「Connections」）。

---

## Task 9: auto-001 n8n ワークフロー JSON 作成（Claude Code 実行）

**Files:**
- Create: `portfolio/samples/auto-001-email-notion/workflow.json`

- [ ] **Step 1: n8n ワークフロー JSON を作成**

  ```json
  {
    "name": "メール受信→Claude要約→Notion保存",
    "nodes": [
      {
        "id": "node-gmail-trigger",
        "name": "Gmail トリガー",
        "type": "n8n-nodes-base.gmailTrigger",
        "typeVersion": 1,
        "position": [250, 300],
        "parameters": {
          "filters": {},
          "options": {}
        },
        "credentials": {
          "gmailOAuth2": {
            "id": "YOUR_GMAIL_CREDENTIAL_ID",
            "name": "Gmail Account"
          }
        }
      },
      {
        "id": "node-claude-summary",
        "name": "Claude で要約",
        "type": "n8n-nodes-base.httpRequest",
        "typeVersion": 4,
        "position": [500, 300],
        "parameters": {
          "method": "POST",
          "url": "https://api.anthropic.com/v1/messages",
          "authentication": "genericCredentialType",
          "genericAuthType": "httpHeaderAuth",
          "sendHeaders": true,
          "headerParameters": {
            "parameters": [
              { "name": "x-api-key", "value": "={{ $credentials.httpHeaderAuth.value }}" },
              { "name": "anthropic-version", "value": "2023-06-01" },
              { "name": "content-type", "value": "application/json" }
            ]
          },
          "sendBody": true,
          "contentType": "json",
          "body": "={\n  \"model\": \"claude-haiku-4-5-20251001\",\n  \"max_tokens\": 300,\n  \"messages\": [\n    {\n      \"role\": \"user\",\n      \"content\": \"以下のメールを3行以内に要約してください。\\n\\n件名: {{ $node[\"Gmail トリガー\"].json.subject }}\\n本文: {{ $node[\"Gmail トリガー\"].json.snippet }}\"\n    }\n  ]\n}"
        },
        "credentials": {
          "httpHeaderAuth": {
            "id": "YOUR_CLAUDE_CREDENTIAL_ID",
            "name": "Claude API Key"
          }
        }
      },
      {
        "id": "node-notion-save",
        "name": "Notion に保存",
        "type": "n8n-nodes-base.notion",
        "typeVersion": 2,
        "position": [750, 300],
        "parameters": {
          "resource": "databasePage",
          "operation": "create",
          "databaseId": "YOUR_NOTION_DATABASE_ID",
          "title": "={{ $node[\"Gmail トリガー\"].json.subject }}",
          "propertiesUi": {
            "propertyValues": [
              {
                "key": "送信者",
                "type": "email",
                "emailValue": "={{ $node[\"Gmail トリガー\"].json.from }}"
              },
              {
                "key": "要約",
                "type": "richText",
                "textContent": "={{ $node[\"Claude で要約\"].json.content[0].text }}"
              },
              {
                "key": "受信日時",
                "type": "date",
                "date": "={{ $now }}"
              }
            ]
          }
        },
        "credentials": {
          "notionApi": {
            "id": "YOUR_NOTION_CREDENTIAL_ID",
            "name": "Notion API"
          }
        }
      }
    ],
    "connections": {
      "Gmail トリガー": {
        "main": [
          [{ "node": "Claude で要約", "type": "main", "index": 0 }]
        ]
      },
      "Claude で要約": {
        "main": [
          [{ "node": "Notion に保存", "type": "main", "index": 0 }]
        ]
      }
    },
    "settings": {
      "executionOrder": "v1"
    }
  }
  ```

---

## Task 10: auto-001 n8n ワークフロー構築・テスト（ブラウザ作業）

**Files:** なし（n8n UI での操作）

- [ ] **Step 1: ワークフローをインポート**

  n8n UI（http://localhost:5678）→「+」→「Import from File」
  `workflow.json` を選択。

- [ ] **Step 2: 認証情報を設定**

  各ノードの認証を設定：
  - Gmail：Googleアカウント OAuth2 接続
  - Claude API：「httpHeaderAuth」でAPIキーを設定（ヘッダー名：`x-api-key`）
  - Notion：インテグレーションシークレットを設定

- [ ] **Step 3: データベースIDを設定**

  「Notion に保存」ノードに Task 8 でメモしたデータベースIDを入力。

- [ ] **Step 4: テスト実行**

  テスト用メールをGmailに送信 → n8n で「Execute Workflow」。
  確認項目：
  - ✅ Claude の要約が3行以内で生成された
  - ✅ Notion データベースに行が追加された

- [ ] **Step 5: ワークフローをエクスポート**

  n8n UI → 「...」→「Export」で JSON ダウンロード。
  `workflow.json` を上書き更新。

---

## Task 11: auto-001 README + セットアップガイド + スクリーンショット

**Files:**
- Modify: `portfolio/samples/auto-001-email-notion/README.md`
- Create: `portfolio/samples/auto-001-email-notion/setup-guide.md`
- Create: `portfolio/samples/auto-001-email-notion/screenshots/.gitkeep`

- [ ] **Step 1: README を完全版に更新**

  ```markdown
  # メール受信 → Claude AI 要約 → Notion 自動保存

  ## デモ
  ![ワークフロー全体](screenshots/01-workflow-overview.png)
  ![Claude要約結果](screenshots/02-claude-summary.png)
  ![Notion記録](screenshots/03-notion-record.png)

  ## 何ができるか
  受信メールをClaude AIが自動で3行要約し、Notionデータベースに保存します。
  大量の営業メールや問い合わせを見落とさず、要点だけ素早く把握できます。

  ## ユースケース
  - 営業メールの自動整理
  - 問い合わせ内容のナレッジベース化
  - ニュースレターの要約保存

  ## 使用ツール
  - [n8n](https://n8n.io)（セルフホスト可・無料）
  - Gmail
  - [Claude API](https://anthropic.com)（Haiku モデル使用）
  - Notion

  ## セットアップ
  → [setup-guide.md](setup-guide.md) を参照

  ## ワークフロー構成
  ```
  Gmail 新規メール受信
      ↓
  Claude API で本文を3行以内に要約
      ↓
  Notion データベースに保存
  （件名・送信者・要約・受信日時）
  ```

  ## 費用
  n8n はセルフホストで無料。Claude API は従量課金（Haiku モデルで低コスト）。
  ```

- [ ] **Step 2: setup-guide.md を作成**

  ```markdown
  # セットアップガイド｜メール→AI要約→Notion

  ## 必要なもの
  - n8n（Docker または `npx n8n` で起動）
  - Googleアカウント（Gmail）
  - Anthropic API キー
  - Notionアカウント（無料）

  ## 手順

  ### 1. n8n を起動
  ```bash
  npx n8n
  # ブラウザで http://localhost:5678 を開く
  ```

  ### 2. Notion インテグレーションを作成
  1. https://notion.so/my-integrations → New integration
  2. シークレットキーをメモ
  3. 使用するデータベースにインテグレーションを接続

  ### 3. ワークフローをインポート
  1. n8n → 「+」→「Import from File」
  2. `workflow.json` を選択

  ### 4. 認証情報を設定
  - Gmail：OAuth2 でGoogleアカウント接続
  - Claude API：httpHeaderAuth で `x-api-key` にAPIキーを設定
  - Notion：シークレットキーを入力

  ### 5. データベースIDを設定
  Notion のデータベースURLの末尾32文字を `notion に保存` ノードに入力。

  ### 6. テスト実行 → 有効化
  「Execute Workflow」でテスト後、右上の toggle をONに設定。
  ```

- [ ] **Step 3: screenshots ディレクトリを作成**

  ```bash
  mkdir -p portfolio/samples/auto-001-email-notion/screenshots
  touch portfolio/samples/auto-001-email-notion/screenshots/.gitkeep
  ```

- [ ] **Step 4: スクリーンショットを撮影（ブラウザ作業）**

  - `01-workflow-overview.png`：n8n のワークフロー全体図
  - `02-claude-summary.png`：実行結果の Claude 要約テキスト
  - `03-notion-record.png`：Notion データベースに追加された行

---

## Task 12: auto-001 GitHub push

- [ ] **Step 1: コミットしてpush**

  ```bash
  git add portfolio/samples/auto-001-email-notion/
  git commit -m "[add] portfolio: auto-001 メール→Claude要約→Notion完成"
  git push origin main
  ```

---

## Task 13: auto-003 Python Slack Bot 実装（Claude Code 実行）

**Files:**
- Create: `portfolio/samples/auto-003-claude-bot/app.py`
- Create: `portfolio/samples/auto-003-claude-bot/requirements.txt`
- Create: `portfolio/samples/auto-003-claude-bot/.env.example`
- Create: `portfolio/samples/auto-003-claude-bot/tests/test_bot.py`

- [ ] **Step 1: requirements.txt を作成**

  ```
  flask==3.1.0
  slack-sdk==3.33.0
  anthropic==0.49.0
  python-dotenv==1.0.1
  pytest==8.3.5
  ```

- [ ] **Step 2: .env.example を作成**

  ```
  SLACK_BOT_TOKEN=xoxb-your-bot-token-here
  SLACK_SIGNING_SECRET=your-signing-secret-here
  ANTHROPIC_API_KEY=sk-ant-your-key-here
  ```

- [ ] **Step 3: app.py を作成**

  ```python
  import os
  import re
  from flask import Flask, request, jsonify
  from slack_sdk import WebClient
  from slack_sdk.errors import SlackApiError
  import anthropic
  from dotenv import load_dotenv

  load_dotenv()

  app = Flask(__name__)
  slack_client = WebClient(token=os.environ["SLACK_BOT_TOKEN"])
  claude_client = anthropic.Anthropic(api_key=os.environ["ANTHROPIC_API_KEY"])

  SYSTEM_PROMPT = (
      "あなたは社内FAQ応答ボットです。"
      "質問に対して、簡潔かつ正確に回答してください。"
      "回答は3〜5文以内にまとめてください。"
      "不明な質問には「確認が必要です。担当者にお問い合わせください」と答えてください。"
  )


  def get_claude_response(question: str) -> str:
      response = claude_client.messages.create(
          model="claude-haiku-4-5-20251001",
          max_tokens=500,
          system=SYSTEM_PROMPT,
          messages=[{"role": "user", "content": question}],
      )
      return response.content[0].text


  @app.route("/slack/events", methods=["POST"])
  def slack_events():
      data = request.json

      if data.get("type") == "url_verification":
          return jsonify({"challenge": data["challenge"]})

      event = data.get("event", {})

      if event.get("type") == "app_mention":
          user_text = re.sub(r"<@[A-Z0-9]+>", "", event["text"]).strip()
          channel = event["channel"]
          thread_ts = event.get("ts")

          answer = get_claude_response(user_text)

          try:
              slack_client.chat_postMessage(
                  channel=channel,
                  text=answer,
                  thread_ts=thread_ts,
              )
          except SlackApiError as e:
              print(f"Slack API error: {e}")

      return jsonify({"ok": True})


  if __name__ == "__main__":
      app.run(port=3000, debug=True)
  ```

- [ ] **Step 4: テストを作成**

  `portfolio/samples/auto-003-claude-bot/tests/test_bot.py`：

  ```python
  import pytest
  import os
  import sys
  from unittest.mock import patch, MagicMock

  sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

  os.environ.setdefault("SLACK_BOT_TOKEN", "xoxb-test")
  os.environ.setdefault("SLACK_SIGNING_SECRET", "test-secret")
  os.environ.setdefault("ANTHROPIC_API_KEY", "test-key")


  @pytest.fixture
  def client():
      from app import app
      app.config["TESTING"] = True
      with app.test_client() as c:
          yield c


  def test_url_verification(client):
      """Slack の URL 検証チャレンジに正しく応答する"""
      response = client.post(
          "/slack/events",
          json={"type": "url_verification", "challenge": "abc123"},
          content_type="application/json",
      )
      assert response.status_code == 200
      assert response.get_json()["challenge"] == "abc123"


  def test_app_mention_triggers_response(client):
      """メンションが届いたら Claude に問い合わせて Slack に返信する"""
      mock_claude_text = "有給申請は社内ポータルから行えます。"

      with patch("app.claude_client") as mock_claude, \
           patch("app.slack_client") as mock_slack:

          mock_content = MagicMock()
          mock_content.text = mock_claude_text
          mock_response = MagicMock()
          mock_response.content = [mock_content]
          mock_claude.messages.create.return_value = mock_response
          mock_slack.chat_postMessage.return_value = {"ok": True}

          response = client.post(
              "/slack/events",
              json={
                  "event": {
                      "type": "app_mention",
                      "text": "<@UBOT123> 有給の申請方法を教えてください",
                      "channel": "C123",
                      "ts": "1000.001",
                  }
              },
              content_type="application/json",
          )

      assert response.status_code == 200
      mock_claude.messages.create.assert_called_once()
      call_kwargs = mock_claude.messages.create.call_args.kwargs
      assert "有給の申請方法" in call_kwargs["messages"][0]["content"]

      mock_slack.chat_postMessage.assert_called_once_with(
          channel="C123",
          text=mock_claude_text,
          thread_ts="1000.001",
      )


  def test_non_mention_event_does_nothing(client):
      """メンション以外のイベントは無視する"""
      with patch("app.claude_client") as mock_claude, \
           patch("app.slack_client") as mock_slack:

          response = client.post(
              "/slack/events",
              json={
                  "event": {
                      "type": "message",
                      "text": "普通のメッセージ",
                      "channel": "C123",
                  }
              },
              content_type="application/json",
          )

      assert response.status_code == 200
      mock_claude.messages.create.assert_not_called()
      mock_slack.chat_postMessage.assert_not_called()


  def test_bot_mention_text_stripped(client):
      """メンション部分（<@UBOT>）が質問テキストから除去される"""
      with patch("app.get_claude_response") as mock_get_response, \
           patch("app.slack_client"):

          mock_get_response.return_value = "テスト回答"

          client.post(
              "/slack/events",
              json={
                  "event": {
                      "type": "app_mention",
                      "text": "<@UBOT123>   経費精算の方法は？",
                      "channel": "C123",
                      "ts": "1000.002",
                  }
              },
              content_type="application/json",
          )

          mock_get_response.assert_called_once_with("経費精算の方法は？")
  ```

---

## Task 14: auto-003 テスト実行

**Files:** なし

- [ ] **Step 1: 依存関係をインストール**

  ```bash
  cd portfolio/samples/auto-003-claude-bot
  pip install -r requirements.txt
  ```

- [ ] **Step 2: テストを実行して全件パスを確認**

  ```bash
  pytest tests/ -v
  ```

  期待される出力：
  ```
  tests/test_bot.py::test_url_verification PASSED
  tests/test_bot.py::test_app_mention_triggers_response PASSED
  tests/test_bot.py::test_non_mention_event_does_nothing PASSED
  tests/test_bot.py::test_bot_mention_text_stripped PASSED

  4 passed in X.XXs
  ```

---

## Task 15: auto-003 README + スクリーンショット + GitHub push

**Files:**
- Modify: `portfolio/samples/auto-003-claude-bot/README.md`
- Create: `portfolio/samples/auto-003-claude-bot/screenshots/.gitkeep`

- [ ] **Step 1: README を完全版に更新**

  ```markdown
  # 社内FAQ Slack Bot（Claude AI 搭載）

  ## デモ
  ![Slack Bot 応答](screenshots/01-slack-bot-response.png)

  ## 何ができるか
  Slackでボットをメンションすると、Claude AIが社内ドキュメントをもとに自動回答します。
  ヘルプデスクの問い合わせ対応を自動化し、担当者の負荷を軽減します。

  ## ユースケース
  - 社内FAQ自動応答
  - ヘルプデスク負荷軽減
  - 新入社員向けナレッジベース

  ## 使用技術
  - Python / Flask
  - [Claude API](https://anthropic.com)（Haiku モデル）
  - [Slack Bolt / SDK](https://slack.dev/python-slack-sdk/)

  ## セットアップ

  ```bash
  pip install -r requirements.txt
  cp .env.example .env
  # .env に各APIキーを入力
  python app.py
  ```

  Slack App の設定：
  1. api.slack.com/apps でアプリ作成
  2. Event Subscriptions で `app_mention` を有効化
  3. Request URL に `https://your-server/slack/events` を設定
  4. Bot Token Scopes：`chat:write` / `app_mentions:read`

  ## テスト

  ```bash
  pytest tests/ -v
  ```

  ## ワークフロー

  ```
  Slack でボットをメンション
      ↓
  Flask でイベントを受信
      ↓
  Claude API で回答を生成
      ↓
  Slack スレッドに返信
  ```
  ```

- [ ] **Step 2: screenshots ディレクトリを作成**

  ```bash
  mkdir -p portfolio/samples/auto-003-claude-bot/screenshots
  touch portfolio/samples/auto-003-claude-bot/screenshots/.gitkeep
  ```

- [ ] **Step 3: Slack App を設定してローカルで動作確認（ブラウザ作業）**

  1. api.slack.com/apps でアプリ作成
  2. `.env` にトークンを設定
  3. `python app.py` でサーバー起動
  4. ngrok 等で公開 URL を作成してイベント URL を登録
  5. Slack でメンションして応答を確認
  6. `screenshots/01-slack-bot-response.png` を撮影

- [ ] **Step 4: コミットしてpush**

  ```bash
  cd ../../..  # portfolio ルートに戻る
  git add portfolio/samples/auto-003-claude-bot/
  git commit -m "[add] portfolio: auto-003 社内FAQ Slack Bot 完成"
  git push origin main
  ```

---

## 完了チェックリスト

| 成果物 | 確認 |
|---|---|
| auto-002 GitHub に公開 | [ ] |
| auto-001 GitHub に公開 | [ ] |
| auto-003 GitHub に公開（テスト全件パス） | [ ] |
| CrowdWorks プロフィール更新（GitHub リンク入り） | [ ] |
| 提案3件送信 | [ ] |
| logs/projects.md に記録 | [ ] |
