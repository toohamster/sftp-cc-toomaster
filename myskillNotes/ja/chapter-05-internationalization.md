# 第 5 章：国際化 (i18n)

## 5.1 多言語の理由

### ユーザーエクスペリエンス優先
ユーザーが Skill を使用する際、出力は彼らの馴染みのある言語であるべき：
- 英語ユーザー：`"Upload complete!"`
- 中国語ユーザー：`"上传完成！"`
- 日本語ユーザー：`"アップロード完了！"`

### i18n 原則
1. **ユーザー言語優先**: ユーザー設定に基づいて自動切り替え
2. **外部依存ゼロ**: gettext なし、Python なし
3. **シンプルで保守可能**: ピュア Shell 実装

## 5.2 変数式多言語ソリューション

### gettext を選ばない理由
| 項目 | gettext | 変数式ソリューション |
|------|---------|-------------------|
| 外部依存 | 必要 | なし |
| 学習曲線 | .po/.mo ファイル | 通常の変数 |
| Shell 互換性 | 複雑 | ネイティブサポート |

### コアコンセプト
```bash
# 定義ステージ（言語別にロード）
MSG_UPLOAD_COMPLETE="上传完成！"

# 使用ステージ（直接参照）
info "$MSG_UPLOAD_COMPLETE"

# パラメータ付き（printf を使用）
printf "$MSG_UPLOADING_FILES" "10" "server:/var/www"
```

## 5.3 i18n.sh 実装

### コア関数
```bash
# 設定から言語を初期化
init_lang() {
    local config_file="$1"
    local lang=""
    
    if [ -f "$config_file" ]; then
        lang=$(grep '"language"' "$config_file" 2>/dev/null | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')
    fi
    
    # デフォルトは英語
    if [ -z "$lang" ] || [ "$lang" = "null" ]; then
        lang="en"
    fi
    
    load_messages "$lang"
}

# 言語のメッセージをロード
load_messages() {
    local lang="$1"
    
    case "$lang" in
        zh|zh_CN|zh_TW)
            MSG_UPLOAD_COMPLETE="上传完成！"
            ;;
        ja|ja_JP)
            MSG_UPLOAD_COMPLETE="アップロード完了！"
            ;;
        *)
            MSG_UPLOAD_COMPLETE="Upload complete!"
            ;;
    esac
}
```

## 5.4 スクリプトで i18n を使用

### 例
```bash
# i18n ライブラリをソース
source "$SCRIPT_DIR/i18n.sh"
init_lang "$CONFIG_FILE"

# 単純なメッセージを使用
info "$MSG_UPLOAD_COMPLETE"

# フォーマットメッセージを使用
info "$(printf "$MSG_UPLOADING_FILES" "$count" "$server:$path")"
```

## 5.5 言語設定

### sftp-config.json
```json
{
  "host": "example.com",
  "language": "zh"
}
```

### サポート言語
| コード | 言語 |
|------|----------|
| `en` | 英語（デフォルト） |
| `zh`, `zh_CN`, `zh_TW` | 中国語 |
| `ja`, `ja_JP` | 日本語 |

---

## まとめ

- 多言語はユーザーエクスペリエンスを向上
- 変数ソリューションは依存関係ゼロ
- `init_lang()` は設定から言語を読み取り
- `load_messages()` は言語別にメッセージをロード
- 英語、中国語、日本語をサポート

## 次章

第 6 章では、デバッグとテストを解説します。
