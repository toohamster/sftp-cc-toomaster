# 第 1 章：Claude Code Skill とは

## 1.1 Claude Code Skill の定義

### Skill とは
- Claude Code のプラグインシステム
- 自然言語でトリガー
- 事前定義された操作を自動実行

### Skill でできること
- ファイル操作（アップロード、ダウンロード、同期）
- コード生成と変換
- 外部 API 呼び出し
- 自動化ワークフロー

### VS Code 拡張との違い
| 項目 | Claude Code Skill | VS Code 拡張 |
|------|------------------|-------------|
| トリガー方法 | 自然言語 | ボタンクリック / ショートカット |
| 実行環境 | Claude Code CLI | VS Code |
| 開発難易度 | 低（ドキュメント + スクリプト） | 高（TypeScript + API） |

---

## 1.2 Claude Code Plugin アーキテクチャ

### ディレクトリ構造
```
my-plugin/
├── .claude-plugin/
│   └── marketplace.json    # Marketplace 設定
├── skills/
│   └── my-skill/
│       └── SKILL.md        # Skill 定義（コア）
├── scripts/
│   └── my-script.sh        # 実行スクリプト
└── README.md               # ドキュメント
```

### コアコンポーネント

#### 1. SKILL.md
- Skill のコア定義ファイル
- YAML frontmatter を含む
- トリガーワードと実行ロジックを定義

#### 2. ${CLAUDE_PLUGIN_ROOT} 変数
```markdown
**重要**: ${CLAUDE_PLUGIN_ROOT} は Claude Code によって注入される Skill 内部変数

- Skill コンテキストでのみ有効
- 実行時にプラグインルートディレクトリパスに自動解決
- 例：`~/.claude/plugins/marketplaces/my-plugin/`
```

#### 3. scripts/ ディレクトリ
- 実行可能スクリプトを格納
- shell、Python などをサポート
- ${CLAUDE_PLUGIN_ROOT}/scripts/ でアクセス

---

## 1.3 Skill の仕組み

### トリガーフロー
```
ユーザー入力 → Claude が意図を認識 → トリガーワードにマッチ → SKILL.md をロード → 対応スクリプトを実行
```

### 変数注入メカニズム
```
ユーザー：「コードをサーバーに同期」
  ↓
Claude が SFTP アップロード意図を認識
  ↓
一致する Skill（sftp-cc）を検索
  ↓
SKILL.md をロード、${CLAUDE_PLUGIN_ROOT} を注入
  ↓
実行：bash ${CLAUDE_PLUGIN_ROOT}/scripts/sftp-push.sh
```

### よくある質問

**Q: bash で実行する際に ${CLAUDE_PLUGIN_ROOT} が空になるのはなぜ？**

A: `${CLAUDE_PLUGIN_ROOT}` は Skill コンテキストでのみ Claude Code によって注入されます。shell で直接実行する場合は、絶対パスを使用する必要があります：
```bash
# 間違い：直接実行、変数が空
bash ${CLAUDE_PLUGIN_ROOT}/scripts/sftp-push.sh

# 正しい：絶対パスを使用
bash ~/.claude/plugins/marketplaces/sftp-cc/scripts/sftp-push.sh
```

---

## 1.4 開発環境の準備

### Claude Code のインストール
```bash
# macOS
brew install claude-code

# npm
npm install -g @anthropic-ai/claude-code
```

### インストールの確認
```bash
claude --version
```

### ディレクトリの準備
```bash
# プロジェクトディレクトリを作成
mkdir my-first-skill
cd my-first-skill

# 基本構造を作成
mkdir -p .claude-plugin skills/my-skill scripts
```

---

## まとめ

- Skill は Claude Code のプラグインシステム
- SKILL.md がコア定義ファイル
- ${CLAUDE_PLUGIN_ROOT} は内部変数で、実行時に自動解決
- 開発環境には Claude Code CLI が必要

## 次章

第 2 章では、要件分析からディレクトリ構造規劃まで、プロジェクト規劃と設計を解説します。
