# portfolio/samples｜サンプル・納品物管理

受注案件で作ったコードや自主制作サンプルを保存するフォルダ。
GitHub公開用のコードもここで管理する。

---

## 命名規則

```
samples/
├── gas-001-gmail-auto-label/     ← GAS系
├── gas-002-sheet-to-slack/
├── py-001-web-scraper/           ← Python系
├── xl-001-vba-auto-report/       ← Excel VBA系
└── ...
```

## 各サンプルに含めるもの

```
サンプルフォルダ/
├── README.md        ← 概要・使い方
├── main.gs or .py   ← メインコード
└── USAGE.md         ← 操作手順書（納品物と同じ）
```

## サンプル一覧

| ID | タイトル | カテゴリ | 公開 | 元案件 |
|---|---|---|---|---|
| （なし） | - | - | - | - |

---

## GitHub公開手順

```bash
# 個人情報・APIキーが含まれていないか確認してから公開
grep -r "api_key\|password\|secret" ./
```
