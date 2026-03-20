# Chapter 3: Writing Your First Skill

## 3.1 SKILL.md Structure

### Complete Example
```markdown
---
name: sftp-cc
description: Universal SFTP upload tool, triggered by natural language, uploads local project files to remote server. Supports incremental upload, automatic private key binding and permission correction.
---

# SFTP Push Skill — sftp-cc

> Universal SFTP upload tool with automatic private key binding and permission correction.

## When to Trigger

**SFTP Upload/Deploy**:
- "sync code to server", "upload to server", "deploy code"
- "同步代码到服务器", "上传到服务器"
- "サーバーに同期する", "デプロイする"

**Private Key Binding**:
- "bind sftp private key", "bind ssh key"
- "绑定 SFTP 私钥", "绑定私钥"

**Important**: Do NOT treat "push" as a trigger — it conflicts with git push.
```

## 3.2 YAML Frontmatter

### Required Fields
```yaml
---
name: sftp-cc
description: Universal SFTP upload tool...
---
```

| Field | Description | Example |
|-------|-------------|---------|
| name | Skill name | `sftp-cc` |
| description | Skill description | Universal SFTP upload tool... |

## 3.3 Trigger Word Design

### Good Trigger Word Characteristics
1. **Natural language**: What users would say
2. **Multi-language coverage**: English, Chinese, Japanese
3. **Avoid ambiguity**: "sftp push" not just "push"

## 3.4 Script Path Explanation

### Correct Usage
```markdown
**Script Location**: `${CLAUDE_PLUGIN_ROOT}/scripts/`

**Note**: `${CLAUDE_PLUGIN_ROOT}` is injected by Claude Code, only valid in Skill context.
```

## 3.5 First Use Guide

When user first requests SFTP operation:

1. **Check if config exists**: `.claude/sftp-cc/sftp-config.json`
2. **If not exists**: Run `sftp-init.sh`
3. **Deploy public key**: Run `sftp-copy-id.sh`
4. **Check private key**: Look in `.claude/sftp-cc/`
5. **Execute upload**: Run `sftp-push.sh`

---

## Summary

- SKILL.md contains YAML frontmatter and trigger words
- Trigger words should be natural, multi-language, unambiguous
- Add clear script execution instructions
- `${CLAUDE_PLUGIN_ROOT}` needs special explanation

## Next Chapter

Chapter 4 will cover script development practices.
