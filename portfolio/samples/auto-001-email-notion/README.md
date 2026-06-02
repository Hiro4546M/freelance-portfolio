# メール受信 → Claude AI 要約 → Notion 自動保存

## デモ

> スクリーンショットは n8n でのセットアップ完了後に追加予定です。
> セットアップ後、`screenshots/` ディレクトリに以下の画像を配置してください：
> - `01-workflow-overview.png`：n8n ワークフロー全体図
> - `02-claude-summary.png`：実行結果の Claude 要約テキスト
> - `03-notion-record.png`：Notion データベースに追加された行

## 何ができるか
受信メールを Claude AI が自動で3行要約し、Notion データベースに保存します。
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
Claude API で本文を3行以内に要約（claude-haiku-4-5-20251001）
    ↓
Notion データベースに保存
（件名・送信者・要約・受信日時）
```

## Notion データベーススキーマ（必須）

このワークフローは以下のプロパティ名・型を持つ Notion データベースを前提とします：

| プロパティ名 | 型 |
|---|---|
| タイトル（件名） | タイトル（デフォルト） |
| 送信者 | テキスト |
| 要約 | テキスト |
| 受信日時 | 日付 |

プロパティ名が異なる場合は `workflow.json` の `propertiesUi` セクションを修正してください。

## 費用
n8n はセルフホストで無料。Claude API は従量課金（Haiku モデルで低コスト）。
