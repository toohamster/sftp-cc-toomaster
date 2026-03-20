# Chapter 2: Project Planning and Design

## 2.1 Requirements Analysis

### Starting from Pain Points
The original motivation for developing sftp-cc:
> "When using PhpStorm, the built-in SFTP extension automatically syncs files to the server. After switching to Claude Code, I lost this capability — every time Claude modified code, I had to manually pull on the test server, which was very inefficient."

### Requirements List
| Requirement | Priority | Description |
|-------------|----------|-------------|
| Upload files to server | ⭐⭐⭐ | Core functionality |
| Incremental upload | ⭐⭐⭐ | Only upload changed files |
| Automatic private key binding | ⭐⭐ | Simplify configuration |
| Permission correction | ⭐⭐ | chmod 600 |
| Multi-language support | ⭐ | Internationalization |

### Functional Boundaries
**What NOT to do**:
- Download files (one-way sync only)
- Real-time file change monitoring
- Multi-server simultaneous deployment

---

## 2.2 Functional Design

### Core Function Modules
```
sftp-cc
├── Config initialization (sftp-init.sh)
├── Private key binding (sftp-keybind.sh)
├── Public key deployment (sftp-copy-id.sh)
└── File upload (sftp-push.sh)
```

### Upload Mode Design
| Mode | Command | Description |
|------|---------|-------------|
| Incremental upload | `sftp-push.sh` | Default, only upload changes |
| Full upload | `sftp-push.sh --full` | Upload all files |
| Specific file | `sftp-push.sh file.php` | Upload specified file |
| Specific directory | `sftp-push.sh -d src/` | Upload specified directory |
| Preview mode | `sftp-push.sh -n` | Show only, do not execute |

### Incremental Detection Logic
```bash
# 1. Committed changes
git diff --name-only --diff-filter=ACMR <last_hash> HEAD

# 2. Staged changes
git diff --cached --name-only --diff-filter=ACMR

# 3. Working directory changes
git diff --name-only --diff-filter=ACMR

# 4. Untracked files
git ls-files --others --exclude-standard
```

---

## 2.3 Directory Structure Planning

### Final Structure
```
sftp-cc/
├── .claude-plugin/
│   └── marketplace.json        # Plugin configuration
├── skills/
│   └── sftp-cc/
│       └── SKILL.md            # Skill definition
├── scripts/
│   ├── sftp-init.sh            # Initialize configuration
│   ├── sftp-keybind.sh         # Private key binding
│   ├── sftp-copy-id.sh         # Public key deployment
│   ├── sftp-push.sh            # File upload
│   └── i18n.sh                 # Multi-language support
├── templates/
│   └── sftp-config.example.json # Configuration template
├── skill.md                     # Manual installation Skill definition
├── install.sh                   # Manual installation script
├── README.md                    # English documentation
├── README_CN.md                 # Chinese documentation
├── README_JP.md                 # Japanese documentation
├── SPEC.md                      # Technical specifications
└── CLAUDE.md                    # Development guide
```

### Two Installation Methods
| Installation method | Path | Description |
|---------------------|------|-------------|
| Plugin installation | `~/.claude/plugins/marketplaces/sftp-cc/` | Recommended, auto-update |
| Manual installation | `.claude/skills/sftp-cc/` | Compatible with old versions |

---

## 2.4 Configuration File Design

### sftp-config.json
```json
{
  "host": "Server address",
  "port": 22,
  "username": "Username",
  "remote_path": "/remote/target/path",
  "local_path": ".",
  "private_key": "",
  "language": "en",
  "excludes": [".git", ".claude", "node_modules"]
}
```

### Field Descriptions
| Field | Required | Default | Description |
|-------|----------|---------|-------------|
| host | Yes | - | SFTP server address |
| port | No | 22 | SFTP port |
| username | Yes | - | Login username |
| remote_path | Yes | - | Remote target path |
| local_path | No | "." | Local source directory |
| private_key | No | "" | Private key path (auto-filled) |
| language | No | "en" | Interface language |
| excludes | No | See above | Excluded files/directories |

---

## 2.5 Trigger Word Design

### Upload Trigger Words
```
English: "sync code to server", "upload to server", "deploy code"
Chinese: "同步代码到服务器", "上传到服务器", "部署代码"
Japanese: "サーバーに同期する", "デプロイする"
```

### Private Key Binding Trigger Words
```
English: "bind sftp private key", "bind ssh key"
Chinese: "绑定 SFTP 私钥", "绑定私钥"
Japanese: "秘密鍵をバインドする", "SSH 鍵をバインドする"
```

### Words That Should NOT Trigger
- "push" — Avoid conflict with git push

---

## 2.6 Technology Selection

### Why Choose Shell
| Item | Shell | Python | Node.js |
|------|-------|--------|---------|
| External dependencies | None | Requires pip | Requires npm |
| System compatibility | Built-in | Requires installation | Requires installation |
| Development difficulty | Low | Medium | Medium |
| Execution speed | Fast | Medium | Medium |

### Zero External Dependencies Principle
- Use system built-in commands: `sftp`, `git`, `grep`, `sed`
- JSON parsing implemented in shell, no dependency on jq
- Improve compatibility and portability

---

## Summary

- Requirements analysis starting from pain points
- Plan clear directory structure
- Design reasonable configuration file format
- Multi-language trigger word coverage

## Next Chapter

Chapter 3 will guide you through writing your first Skill, starting with SKILL.md.
