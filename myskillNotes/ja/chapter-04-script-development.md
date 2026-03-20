# 第 4 章：スクリプト開発

## 4.1 スクリプト構造テンプレート

### 標準構造
```bash
#!/bin/bash
# スクリプト名：説明
# Usage: 使用方法

set -euo pipefail

# 色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ログ関数
info()  { echo -e "${GREEN}[script]${NC} $*"; }
warn()  { echo -e "${YELLOW}[script]${NC} $*" >&2; }
error() { echo -e "${RED}[script]${NC} $*" >&2; }

# メインロジック
main() {
    info "開始..."
    # ...
}

main "$@"
```

## 4.2 ピュア Shell JSON パース

### jq を使わない理由
- 外部依存、インストールが必要
- すべてのシステムで利用可能ではない
- Shell でシンプルな JSON を処理可能

### JSON パース関数
```bash
# 文字列値を読み取り
json_get() {
    local file="$1" key="$2" default="${3:-}"
    local val
    val=$(grep "\"$key\"" "$file" 2>/dev/null | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')
    echo "${val:-$default}"
}

# 数値値を読み取り
json_get_num() {
    local file="$1" key="$2" default="${3:-0}"
    local val
    val=$(grep "\"$key\"" "$file" 2>/dev/null | head -1 | sed 's/.*: *\([0-9]*\).*/\1/')
    echo "${val:-$default}"
}
```

## 4.3 エラーハンドリング

### パラメータ検証
```bash
MISSING=()
[ -z "$HOST" ]        && MISSING+=("host")
[ -z "$USERNAME" ]    && MISSING+=("username")
[ -z "$REMOTE_PATH" ] && MISSING+=("remote_path")

if [ ${#MISSING[@]} -gt 0 ]; then
    error "設定が不完全です：${MISSING[*]}"
    exit 1
fi
```

### コマンド存在チェック
```bash
if ! command -v sftp &>/dev/null; then
    error "sftp コマンドが見つかりません"
    exit 1
fi
```

### ファイル存在チェック
```bash
if [ ! -f "$CONFIG_FILE" ]; then
    error "設定ファイルが見つかりません：$CONFIG_FILE"
    exit 1
fi
```

## 4.4 プロジェクトルートの特定

### git を使用
```bash
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
```

### 理由
- サブディレクトリでの実行をサポート
- 非 git プロジェクトと互換（pwd にフォールバック）
- パス参照を統一

---

## まとめ

- ピュア Shell JSON パースを習得
- 完全なエラーハンドリング
- git でプロジェクトルートを特定
- 一時ファイルをすぐにクリーンアップ

## 次章

第 5 章では、国際化（i18n）を解説します。
