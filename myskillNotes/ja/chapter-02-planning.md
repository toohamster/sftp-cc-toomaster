# 第 2 章：プロジェクト計画と設計

## 2.1 要件分析

### ペインポイントから出発
sftp-cc 開発の元の動機：
> 「PhpStorm を使用していたとき、組み込みの SFTP 拡張は自動的にファイルをサーバーに同期しました。Claude Code に切り替えた後、この機能を失いました — Claude がコードを変更するたびに、テストサーバーで手動でプルする必要があり、非常に非効率的でした。」

### 要件リスト
| 要件 | 優先度 | 説明 |
|------|--------|------|
| サーバーにファイルをアップロード | ⭐⭐⭐ | コア機能 |
| 増分アップロード | ⭐⭐⭐ | 変更されたファイルのみをアップロード |
| 自動秘密鍵バインド | ⭐⭐ | 設定を簡素化 |
| 権限修正 | ⭐⭐ | chmod 600 |
| 多言語サポート | ⭐ | 国際化 |

### 機能バウンダリ
**やらないこと**：
- ファイルをダウンロード（片方向同期のみ）
- リアルタイムファイル変更監視
- マルチサーバー同時デプロイ

---

## 2.2 機能設計

### コア機能モジュール
```
sftp-cc
├── 設定初期化 (sftp-init.sh)
├── 秘密鍵バインド (sftp-keybind.sh)
├── 公開鍵デプロイ (sftp-copy-id.sh)
└── ファイルアップロード (sftp-push.sh)
```

### アップロードモード設計
| モード | コマンド | 説明 |
|------|---------|-------------|
| 増分アップロード | `sftp-push.sh` | デフォルト、変更のみをアップロード |
| 完全アップロード | `sftp-push.sh --full` | すべてのファイルをアップロード |
| 指定ファイル | `sftp-push.sh file.php` | 指定ファイルをアップロード |
| 指定ディレクトリ | `sftp-push.sh -d src/` | 指定ディレクトリをアップロード |
| プレビューモード | `sftp-push.sh -n` | 表示のみ、実行しない |

### 増分検出ロジック
```bash
# 1. コミット済み変更
git diff --name-only --diff-filter=ACMR <last_hash> HEAD

# 2. ステージング済み変更
git diff --cached --name-only --diff-filter=ACMR

# 3. ワークキングディレクトリ変更
git diff --name-only --diff-filter=ACMR

# 4. 未トラックファイル
git ls-files --others --exclude-standard
```

---

## 2.3 ディレクトリ構造計画

### 最終構造
```
sftp-cc/
├── .claude-plugin/
│   └── marketplace.json        # Plugin 設定
├── skills/
│   └── sftp-cc/
│       └── SKILL.md            # Skill 定義
├── scripts/
│   ├── sftp-init.sh            # 設定初期化
│   ├── sftp-keybind.sh         # 秘密鍵バインド
│   ├── sftp-copy-id.sh         # 公開鍵デプロイ
│   ├── sftp-push.sh            # ファイルアップロード
│   └── i18n.sh                 # 多言語サポート
├── templates/
│   └── sftp-config.example.json # 設定テンプレート
├── skill.md                     # 手動インストール Skill 定義
├── install.sh                   # 手動インストールスクリプト
├── README.md                    # 英語ドキュメント
├── README_CN.md                 # 中国語ドキュメント
├── README_JP.md                 # 日本語ドキュメント
├── SPEC.md                      # 技術仕様
└── CLAUDE.md                    # 開発ガイド
```

### 2 つのインストール方法
| インストール方法 | パス | 説明 |
|---------------------|------|-------------|
| Plugin インストール | `~/.claude/plugins/marketplaces/sftp-cc/` | 推奨、自動更新 |
| 手動インストール | `.claude/skills/sftp-cc/` | 旧バージョンと互換性 |

---

## 2.4 設定ファイル設計

### sftp-config.json
```json
{
  "host": "サーバーアドレス",
  "port": 22,
  "username": "ユーザー名",
  "remote_path": "/リモート/ターゲット/パス",
  "local_path": ".",
  "private_key": "",
  "language": "en",
  "excludes": [".git", ".claude", "node_modules"]
}
```

### フィールド説明
| フィールド | 必須 | デフォルト | 説明 |
|-------|----------|---------|-------------|
| host | はい | - | SFTP サーバーアドレス |
| port | いいえ | 22 | SFTP ポート |
| username | はい | - | ログインユーザー名 |
| remote_path | はい | - | リモートターゲットパス |
| local_path | いいえ | "." | ローカルソースディレクトリ |
| private_key | いいえ | "" | 秘密鍵パス（自動入力） |
| language | いいえ | "en" | インターフェース言語 |
| excludes | いいえ | 上記参照 | 除外されるファイル/ディレクトリ |

---

## 2.5 トリガーワード設計

### アップロードトリガーワード
```
英語："sync code to server", "upload to server", "deploy code"
中国語："同步代码到服务器", "上传到服务器", "部署代码"
日本語："サーバーに同期する", "デプロイする"
```

### 秘密鍵バインドトリガーワード
```
英語："bind sftp private key", "bind ssh key"
中国語："绑定 SFTP 私钥", "绑定私钥"
日本語："秘密鍵をバインドする", "SSH 鍵をバインドする"
```

### トリガーしないワード
- "push" — git push との衝突を避ける

---

## 2.6 技術選択

### Shell を選ぶ理由
| 項目 | Shell | Python | Node.js |
|------|-------|--------|---------|
| 外部依存 | なし | pip が必要 | npm が必要 |
| システム互換性 | 標準搭載 | インストール必要 | インストール必要 |
| 開発難易度 | 低 | 中 | 中 |
| 実行速度 | 速 | 中 | 中 |

### 外部依存ゼロの原則
- システム標準コマンドを使用：`sftp`, `git`, `grep`, `sed`
- JSON パースは Shell で実装、jq に依存しない
- 互換性と移植性を向上

---

## まとめ

- ペインポイントから出発した要件分析
- 明確なディレクトリ構造の計画
- 合理的な設定ファイル形式の設計
- 多言語トリガーワードのカバレッジ

## 次章

第 3 章では、SKILL.md から始めて、最初の Skill を作成します。
