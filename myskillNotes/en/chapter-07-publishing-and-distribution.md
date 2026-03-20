# Chapter 7: Publishing and Distribution

## 7.1 Plugin Marketplace Architecture

### Directory Structure
```
sftp-cc/
├── .claude-plugin/
│   └── marketplace.json    # Plugin configuration
├── skills/
│   └── sftp-cc/
│       └── SKILL.md        # Skill definition
└── scripts/
    └── *.sh               # Scripts
```

## 7.2 marketplace.json详解

### Complete Fields
```json
{
  "name": "sftp-cc",
  "description": "Universal SFTP upload tool",
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

## 7.3 Version Management (SemVer)

### SemVer Specification
```
MAJOR.MINOR.PATCH
  │     │     │
  │     │     └─ Bug fixes
  │     └─ New features (backward compatible)
  └─ Breaking changes
```

### Version Number Examples
| Version | Change Type |
|---------|-------------|
| 1.0.0 → 1.0.1 | Bug fix |
| 1.0.0 → 1.1.0 | New feature |
| 1.0.0 → 2.0.0 | Breaking change |

## 7.4 GitHub Release

### Create Release via API
```bash
# Get latest commit hash
COMMIT_HASH=$(git rev-parse HEAD)

# Create tag via GitHub API
curl -X POST \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  https://api.github.com/repos/toohamster/sftp-cc/git/refs \
  -d "{\"ref\":\"refs/tags/v1.0.0\",\"sha\":\"$COMMIT_HASH\"}"

# Create Release
curl -X POST \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  https://api.github.com/repos/toohamster/sftp-cc/releases \
  -d '{"tag_name":"v1.0.0","name":"v1.0.0"}'
```

## 7.5 Multi-language README

### File Structure
```
├── README.md       # English (default)
├── README_CN.md    # Chinese
├── README_JP.md    # Japanese
```

---

## Summary

- Plugin Marketplace architecture
- marketplace.json field configuration
- SemVer version management
- GitHub Release publishing process
- Multi-language README

## Next Chapter

Chapter 8 will cover advanced topics and best practices.
