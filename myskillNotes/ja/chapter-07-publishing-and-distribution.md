# 第 7 章：公開と配布

## 7.1 Plugin Marketplace アーキテクチャ

### ディレクトリ構造
```
sftp-cc/
├── .claude-plugin/
│   └── marketplace.json    # Plugin 設定
├── skills/
│   └── sftp-cc/
│       └── SKILL.md        # Skill 定義
└── scripts/
    └── *.sh               # スクリプト
```

## 7.2 marketplace.json 詳細

### 完全なフィールド
```json
{
  "name": "sftp-cc",
  "description": "汎用 SFTP アップロードツール",
  "author": "toohamster",
  "version": "1.0.0",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "https://github.com/toohamster/sftp-cc.git"
  },
  "homepage": "https://github.com/toohamster/sftp-cc"
}
```

## 7.3 バージョン管理 (SemVer)

### SemVer 仕様
```
MAJOR.MINOR.PATCH
  │     │     │
  │     │     └─ バグ修正
  │     └─ 新機能（後方互換）
  └─ 破壊的変更
```

### バージョン番号の例
| バージョン | 変更タイプ |
|---------|-------------|
| 1.0.0 → 1.0.1 | バグ修正 |
| 1.0.0 → 1.1.0 | 新機能 |
| 1.0.0 → 2.0.0 | 破壊的変更 |

## 7.4 GitHub Release

### API で Release を作成
```bash
# 最新コミットハッシュを取得
COMMIT_HASH=$(git rev-parse HEAD)

# GitHub API でタグを作成
curl -X POST \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  https://api.github.com/repos/toohamster/sftp-cc/git/refs \
  -d "{\"ref\":\"refs/tags/v1.0.0\",\"sha\":\"$COMMIT_HASH\"}"

# Release を作成
curl -X POST \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  https://api.github.com/repos/toohamster/sftp-cc/releases \
  -d '{"tag_name":"v1.0.0","name":"v1.0.0"}'
```

## 7.5 多言語 README

### ファイル構造
```
├── README.md       # 英語（デフォルト）
├── README_CN.md    # 中国語
├── README_JP.md    # 日本語
```

---

## まとめ

- Plugin Marketplace アーキテクチャ
- marketplace.json フィールド設定
- SemVer バージョン管理
- GitHub Release 公開プロセス
- 多言語 README

## 次章

第 8 章では、トピックとベストプラクティスを解説します。
