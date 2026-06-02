# Phase 1 実行設計書｜フリーランス副業プロジェクト v3

**作成日**: 2026-06-02  
**対象フェーズ**: Phase 1（ポートフォリオ構築 ＋ 初受注）  
**戦略**: ローリング型（1本完成→提案開始→並行で2本目）

---

## 目標

| 指標 | 目標値 |
|---|---|
| ポートフォリオサンプル公開 | 3本（GitHub） |
| 受注件数 | 2件 |
| ★5評価 | 2件 |
| 月収 | 3万円以上 |

---

## 全体スケジュール

```
Day 1〜3：auto-002 実装（Make）
Day 3〜4：CrowdWorks プロフィール更新 → 提案開始
Day 4〜 ：週3件ペースで提案継続
Day 5〜8：auto-001 実装（n8n）
Week 3〜4：auto-003 実装（Python） ＋ 受注対応
```

---

## ポートフォリオ実装仕様

### 共通方針
- 形式：スクリーンショット付きドキュメント（実際に動かして画像撮影）
- 成果物：`workflow.json` または `.py` ＋ `README.md` ＋ `screenshots/`
- 公開先：`https://github.com/Hiro4546M/freelance-portfolio`

---

### auto-002（優先度1）：Googleフォーム→Slack通知＋スプレッドシート

**使用ツール**: Make（無料プラン）/ Google Forms / Google Sheets / Slack  
**ビジネス用途**: 問い合わせ即時通知・採用応募管理・イベント申込集計

**ワークフロー**:
```
[トリガー] Googleフォーム 新規回答
    ↓ Make
[ステップ1] Google Sheets に行追加（回答内容＋タイムスタンプ）
    ↓
[ステップ2] Slack にメッセージ送信（送信者名・サマリー・シートリンク）
```

**必要アカウント（すべて無料）**:
- Make（make.com）
- Google アカウント（Forms・Sheets）
- Slack ワークスペース（デモ用に新規作成）

**成果物**:
- `portfolio/samples/auto-002-form-slack/workflow.json`
- `portfolio/samples/auto-002-form-slack/README.md`
- `portfolio/samples/auto-002-form-slack/screenshots/`

---

### auto-001（優先度2）：メール受信→Claude要約→Notion保存

**使用ツール**: n8n（ローカル：`npx n8n`）/ Gmail / Claude API / Notion API  
**ビジネス用途**: 営業メール自動整理・問い合わせ管理・ニュースレター要約

**ワークフロー**:
```
[トリガー] Gmail 新規メール受信
    ↓ n8n
[ステップ1] Claude API で本文を要約（3行以内）
    ↓
[ステップ2] Notion データベースに保存（件名・送信者・要約・受信日時）
```

**必要アカウント**:
- n8n（ローカル起動・無料）
- Gmail（既存）
- Claude API（既存）
- Notion（無料プラン）

**成果物**:
- `portfolio/samples/auto-001-email-notion/workflow.json`
- `portfolio/samples/auto-001-email-notion/README.md`
- `portfolio/samples/auto-001-email-notion/screenshots/`

---

### auto-003（優先度3）：社内FAQ Slack Bot

**使用ツール**: Python / Claude API / Slack API  
**ビジネス用途**: 社内FAQ自動応答・ヘルプデスク負荷軽減

**アーキテクチャ**:
```
Slack メンション受信
    ↓ Slack Events API（Python / Flask）
Claude API にコンテキスト付きで問い合わせ
    ↓
Slack にレスポンス送信
```

**成果物**:
- `portfolio/samples/auto-003-claude-bot/app.py`
- `portfolio/samples/auto-003-claude-bot/README.md`
- `portfolio/samples/auto-003-claude-bot/screenshots/`

---

## CrowdWorks プロフィール戦略

**タイトル**: 業務自動化（Make/n8n/Claude API）専門エンジニア

**差別化ポイント**:
1. 冒頭に GitHub リンクを配置（「実際に動くサンプルあり」を証明）
2. AI連携（Claude API）を強調
3. 使用ツールを具体的に列挙（n8n / Make / Zapier / Slack / Notion / LINE）

---

## 案件検索キーワード（優先順）

| 優先度 | キーワード | 理由 |
|---|---|---|
| 高 | Make / n8n / Zapier | ツール名指定で要件明確・受注率高い |
| 中 | 業務自動化 / API連携 | 件数が多い |
| 低 | Slack通知 / Notion連携 | 具体的で競合が少ない |

---

## 提案フロー（1件あたり20分）

```
① 案件選定（3万円以上・要件明確・自動化系）
② proposal-template.md のテンプレA（デモあり）またはB（ポートフォリオ提示）を選択
③ 要件に合わせて3行カスタマイズ
④ GitHub リンク添付
⑤ 送信 → logs/projects.md に記録
```

**週3件ペース**: 月・水・金に各1件

---

## 受注後の対応フロー

```
① 要件ヒアリング（Zoom or チャット）
② Claude Code で実装（1〜4時間）
③ テスト + 操作手順書作成
④ 納品
⑤ 匿名化して portfolio/samples/ に保存
⑥ git push & logs/projects.md 更新
```

---

## 撤退・見直しトリガー

| 条件 | アクション |
|---|---|
| 2週間提案して受注0件 | 提案文・キーワードを見直す |
| 受注単価が1万円未満が続く | 案件選定基準を上げる |
| 特定ツールへの依頼が集中 | そのツールの案件に特化する |
