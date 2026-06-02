# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## プロジェクトの目的

CrowdWorksで業務自動化システム案件（n8n・Make・API連携）を受注し、高単価・低競合ポジションで副業収入を安定させる。最終的にはClaude Codeで案件発見〜納品を自動化する。

**特化カテゴリ**：業務自動化システム（n8n・Make・Zapier・API連携）

---

## 現在のフェーズと状態

**Phase 1 - ポートフォリオ構築 ＋ 初受注（Week 1〜4）**

| 完了条件 | 状態 |
|---|---|
| portfolio/samples/ にサンプル3本実装・push | ❌ README スタブのみ、実装未着手 |
| CrowdWorksプロフィールをGitHubリンク付きに更新 | ❌ |
| 受注2件・★5評価取得 | ❌ |
| 月収3万円以上 | ❌ |

フェーズ詳細 → `docs/phases.md` / KPI → `docs/kpi.md`

---

## 戦略の核心（v3）

```
旧v2：誰でもできる仕事をAIで爆速こなす
新v3：技術的に難しい案件をAIで実装して高単価を狙う
```

### 差別化：二段構え

```
【事前】GitHubポートフォリオ（サンプル3本）
  → 「こういうものが作れます」の常設証明

【提案時】案件専用ミニデモ
  → 「あなたの要件で作れます」の個別証明
```

### 案件選定基準

```
✅ 受ける
- 単価3万円以上（最初の2件は1万円以上でも可）
- 「〇〇を自動化したい」が明確な要件
- n8n / Make / Zapier / Slack / Notion / LINE / API連携

❌ 受けない
- ライティング・文章作成のみ
- 要件が「なんとなく自動化したい」レベル
- 単価1万円未満（実績3件後）
- サーバー構築・インフラ系（範囲外）
```

### 単価設定

```
1〜2件目：3〜5万円（実績作り・★5確保優先）
3〜5件目：5〜10万円
6件目〜 ：10〜30万円（設計込みの複雑な案件）
```

---

## 重要ファイル一覧

| ファイル | 用途 |
|---|---|
| `portfolio/samples/auto-001-email-notion/` | メール→Claude要約→Notion保存（n8n） |
| `portfolio/samples/auto-002-form-slack/` | Googleフォーム→Slack通知＋スプレッドシート（Make） |
| `portfolio/samples/auto-003-claude-bot/` | 社内FAQボット（Claude API＋Slack） |
| `profile/crowdworks-profile.md` | CrowdWorksプロフィール文（設定用テキスト） |
| `profile/proposal-template.md` | 提案文テンプレ（デモあり版・なし版・見積り早見表） |
| `profile/proposal-youtube-script.md` | YouTube台本用提案スクリプト |
| `logs/projects.md` | 案件ログ（提案・受注・納品・評価を毎回記録） |
| `docs/test-results.md` | テスト・検証結果の記録 |

---

## 作業フロー（1案件）

```
① 案件発見（5分）
   CrowdWorksで「n8n」「Make」「API連携」「業務自動化」を検索

② ミニデモ作成（30〜60分）
   Claude Codeで要件に合わせて実装
   → portfolio/samples/案件名-demo/ に保存

③ 提案文生成・送信（10分）
   profile/proposal-template.md をベースに生成
   デモのGitHubリンクを添付

④ 受注後：本実装（1〜4時間）
   実装 → テスト → ドキュメント作成

⑤ 納品（15分）
   操作手順書 ＋ コード一式を納品
   → 匿名化して portfolio/samples/ に保存
   → logs/projects.md に記録
   → git-push.sh でGitHubに反映
```

---

## GitHub 運用ルール

### コミットメッセージのフォーマット

```
[add]    新規ファイル追加時
[update] 既存ファイル更新時
[fix]    バグ修正時
[docs]   ドキュメント更新時

例：
[add] portfolio: email→notion自動化サンプル追加
[update] logs: 案件#001を受注に更新
```

### pushの実行方法

```bash
# scripts/git-push.sh を使う（.env 誤 push 防止チェック付き）
bash scripts/git-push.sh "コミットメッセージ"
```

### 絶対にpushしないもの

```
- .env ファイル（APIキー・パスワード）
- クライアントの社名・個人情報が入ったファイル
- 未テストで動かないコード
```

### pushするタイミング

```
1. portfolio/samples/ に新しいサンプルを完成させたとき
2. 案件を納品したとき（匿名化後）
3. CLAUDE.md や docs/ を更新したとき
4. 作業セッション終了時（変更がある場合）
```

> **注意**：Claude Codeのグローバルルールではpush前に確認を求める。自動pushが必要な場合はユーザーに確認を取ること。

---

*フェーズ移行時に「現在のフェーズと状態」セクションを更新する*
