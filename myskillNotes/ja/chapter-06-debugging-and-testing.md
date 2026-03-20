# 第 6 章：デバッグとテスト

## 6.1 Shell スクリプトデバッグ基礎

### set コマンドオプション
```bash
#!/bin/bash
set -euo pipefail  # 本番環境に推奨

# デバッグ用
set -x  # 実行されたすべてのコマンドを表示
set -v  # 読み取られたすべての行を表示
```

| オプション | 説明 |
|--------|-------------|
| `-e` | コマンド失敗時に即座に終了 |
| `-u` | 未定義変数使用時にエラー |
| `-o pipefail` | パイプ中のいずれかのコマンドが失敗した場合に失敗 |
| `-x` | 実行トレースを表示 |
| `-v` | 入力行を表示 |

## 6.2 ログレベル設計

### 4 レベルログシステム
```bash
# 色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ログ関数
info()  { echo -e "${GREEN}[prefix]${NC} $*"; }
warn()  { echo -e "${YELLOW}[prefix]${NC} $*" >&2; }
error() { echo -e "${RED}[prefix]${NC} $*" >&2; }
```

## 6.3 Verbose モード

### デバッグ出力スイッチを追加
```bash
VERBOSE=false
if [[ "${1:-}" == "-v" ]] || [[ "${1:-}" == "--verbose" ]]; then
    VERBOSE=true
fi

debug() {
    $VERBOSE && echo -e "[DEBUG] $*" >&2
}
```

## 6.4 一時ファイル管理

### mktemp 一時ファイル作成
```bash
tmp_file=$(mktemp)
changed_list=$(mktemp)
```

### trap クリーンアップ
```bash
cleanup() {
    rm -f "$tmp_file" "$changed_list"
}
trap cleanup EXIT
```

## 6.5 エラーハンドリングパターン

### パラメータ検証
```bash
MISSING=()
[ -z "$HOST" ] && MISSING+=("host")
[ -z "$USERNAME" ] && MISSING+=("username")

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
    error "設定ファイルが見つかりません"
    exit 1
fi
```

## 6.6 テスト方法

### Dry-run モード
```bash
DRY_RUN=false
if [[ "${1:-}" == "-n" ]]; then
    DRY_RUN=true
fi

if $DRY_RUN; then
    info "[プレビュー] $count ファイルをアップロード予定"
    return 0
fi

# 実際に実行
sftp "$SFTP_TARGET" < "$batch_file"
```

---

## まとめ

- 厳格なエラーハンドリングには `set -euo pipefail` を使用
- 4 レベルログシステム：info/warn/error
- verbose モードは詳細な出力を提供
- 一時ファイルは `mktemp` + `trap` を使用
- dry-run モードで操作をプレビュー

## 次章

第 7 章では、公開と配布を解説します。
