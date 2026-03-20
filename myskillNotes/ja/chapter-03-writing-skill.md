# 第 3 章：初めての Skill を書く

## 3.1 SKILL.md 構造

### 完全な例
```markdown
---
name: sftp-cc
description: 汎用 SFTP アップロードツール、自然言語でトリガー、ローカルプロジェクトファイルをリモートサーバーにアップロード。増分アップロード、自動秘密鍵バインド、権限修正をサポート。
---

# SFTP Push Skill — sftp-cc

> 自動秘密鍵バインドと権限修正付きの汎用 SFTP アップロードツール。

## トリガー時期

**SFTP アップロード/デプロイ**:
- "sync code to server", "upload to server", "deploy code"
- "同步代码到服务器", "上传到服务器"
- "サーバーに同期する", "デプロイする"

**秘密鍵バインド**:
- "bind sftp private key", "bind ssh key"
- "绑定 SFTP 私钥", "绑定私钥"

**重要**: "push" をトリガーとして扱わない — git push と競合します。
```

## 3.2 YAML Frontmatter

### 必須フィールド
```yaml
---
name: sftp-cc
description: 汎用 SFTP アップロードツール...
---
```

| フィールド | 説明 | 例 |
|-------|-------------|---------|
| name | Skill 名 | `sftp-cc` |
| description | Skill 説明 | 汎用 SFTP アップロードツール... |

## 3.3 トリガーワード設計

### 良いトリガーワードの特徴
1. **自然言語**: ユーザーが言うこと
2. **多言語カバレッジ**: 英語、中国語、日本語
3. **曖昧さ回避**: "push" ではなく "sftp push"

## 3.4 スクリプトパス説明

### 正しい使い方
```markdown
**スクリプト場所**: `${CLAUDE_PLUGIN_ROOT}/scripts/`

**注**: `${CLAUDE_PLUGIN_ROOT}` は Claude Code によって注入され、Skill コンテキストでのみ有効。
```

## 3.5 初回使用ガイド

ユーザーが初めて SFTP 操作を要求したとき：

1. **設定が存在するか確認**: `.claude/sftp-cc/sftp-config.json`
2. **存在しない場合**: `sftp-init.sh` を実行
3. **公開鍵をデプロイ**: `sftp-copy-id.sh` を実行
4. **秘密鍵を確認**: `.claude/sftp-cc/` を見る
5. **アップロードを実行**: `sftp-push.sh` を実行

---

## まとめ

- SKILL.md は YAML frontmatter とトリガーワードを含む
- トリガーワードは自然で、多言語で、曖昧でない
- 明確なスクリプト実行指示を追加
- `${CLAUDE_PLUGIN_ROOT}` は特別な説明が必要

## 次章

第 4 章では、スクリプト開発プラクティスを解説します。
