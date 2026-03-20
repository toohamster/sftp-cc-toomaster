# 第 8 章：トピックとベストプラクティス

## 8.1 パフォーマンス最適化

### サブプロセス呼び出しを削減
```bash
# 非推奨：毎回サブプロセスを作成
for file in "${files[@]}"; do
    result=$(grep "pattern" "$file")
done

# 推奨：バッチ処理
grep "pattern" "${files[@]}"
```

### 文字列連結ではなく配列を使用
```bash
# 危険
args=""
for f in "${files[@]}"; do
    args="$args \"$f\""
done
eval "command $args"

# 安全
args=()
for f in "${files[@]}"; do
    args+=("$f")
done
command "${args[@]}"
```

## 8.2 セキュリティベストプラクティス

### コマンドインジェクションを回避
```bash
# 危険
user_input="$1"
eval "echo $user_input"

# 安全
user_input="$1"
echo "$user_input"
```

### 安全なファイルパス処理
```bash
# 常に変数を引用
cat "$file"

# パスを検証
if [[ "$file" == /* ]]; then
    if [[ "$file" != /tmp/* ]] && [[ "$file" != "$PROJECT_ROOT"/* ]]; then
        error "許可されていないパス"
        exit 1
    fi
fi
```

### 権限管理
```bash
# 秘密鍵は 600 でなければならない
chmod 600 "$PRIVATE_KEY"

# 設定ファイルは 644 が推奨
chmod 644 "$CONFIG_FILE"

# スクリプトは 755 が推奨
chmod 755 "$SCRIPT_FILE"
```

## 8.3 コード組織

### 関数名付け規則
```bash
# 動詞 + 名詞：関数の動作を記述
init_lang()
load_messages()
push_files()

# ブール関数：is/has/check プレフィックスを使用
is_excluded()
has_permission()
check_config()
```

### 変数スコープ
```bash
# ローカル変数：local を使用
process_file() {
    local file="$1"
    local content
}

# グローバル変数：大文字
readonly VERSION="1.0.0"
```

## 8.4 trap を使用したエラーハンドリング

```bash
# エラーハンドラ
error_handler() {
    local line_no=$1
    error "スクリプトエラー 行：$line_no"
}

# エラーハンドラを登録
trap 'error_handler ${LINENO}' ERR

# 終了ハンドラを登録
trap 'cleanup' EXIT
```

## 8.5 トラブルシューティングチェックリスト

### Skill がトリガーされない
- [ ] SKILL.md トリガーワード定義を確認
- [ ] Plugin をリロード
- [ ] marketplace.json 設定を確認

### 変数が解決されない
- [ ] ${CLAUDE_PLUGIN_ROOT} が Skill コンテキストで使用されているか確認
- [ ] shell で直接実行する場合は絶対パスを使用

### SFTP 接続に失敗
- [ ] ネットワーク接続を確認
- [ ] サーバーアドレスとポートを検証
- [ ] 秘密鍵の権限を確認（600）
- [ ] `sftp -v` で詳細デバッグ

---

## 本書のまとめ

sftp-cc の開発を通じて、以下を習得しました：

1. **Plugin アーキテクチャ**: SKILL.md, marketplace.json, ${CLAUDE_PLUGIN_ROOT}
2. **Skill 作成**: トリガーワード、YAML frontmatter、実行指示
3. **Shell スクリプト**: JSON パース、エラーハンドリング、ロギング
4. **多言語サポート**: i18n 実装
5. **デバッグとテスト**: set オプション、verbose モード、dry-run
6. **公開**: バージョン管理、GitHub API

### 次のステップ
- このテンプレートを基に独自の Skill を開発
- Plugin Marketplace に公開
- 継続的に最適化と反復

開発頑張ってください！
