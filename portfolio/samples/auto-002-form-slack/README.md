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
Googleフォーム 新規回答（3問：名前・メール・内容）
    ↓
Google Sheets に行追加（名前・メール・内容・受信日時）
    ↓
Slack #通知 チャンネルにメッセージ送信
```

## フォームの質問構成（必須）
このワークフローは以下の順序で質問が設定されていることを前提とします：
1. お名前（responses[0]）
2. メールアドレス（responses[1]）
3. お問い合わせ内容（responses[2]）

順序が異なる場合は `workflow-blueprint.json` の mapper を修正してください。

## 費用
Make 無料プラン（月1,000オペレーション）で動作します。
