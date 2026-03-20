# Chapter 5: Internationalization (i18n)

## 5.1 Why Multi-language

### User Experience First
When users use the Skill, output should be in their familiar language:
- English user: `"Upload complete!"`
- Chinese user: `"上传完成！"`
- Japanese user: `"アップロード完了！"`

### i18n Principles
1. **User language first**: Auto-switch based on user config
2. **Zero external dependencies**: No gettext, no Python
3. **Simple and maintainable**: Pure Shell implementation

## 5.2 Variable-based Multi-language Solution

### Why Not gettext
| Item | gettext | Variable Solution |
|------|---------|-------------------|
| External dependency | Required | None |
| Learning curve | .po/.mo files | Plain variables |
| Shell compatibility | Complex | Native support |

### Core Concept
```bash
# Define stage (load by language)
MSG_UPLOAD_COMPLETE="上传完成！"

# Use stage (direct reference)
info "$MSG_UPLOAD_COMPLETE"

# With parameters (use printf)
printf "$MSG_UPLOADING_FILES" "10" "server:/var/www"
```

## 5.3 i18n.sh Implementation

### Core Functions
```bash
# Initialize language from config
init_lang() {
    local config_file="$1"
    local lang=""
    
    if [ -f "$config_file" ]; then
        lang=$(grep '"language"' "$config_file" 2>/dev/null | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')
    fi
    
    # Default to English
    if [ -z "$lang" ] || [ "$lang" = "null" ]; then
        lang="en"
    fi
    
    load_messages "$lang"
}

# Load messages for language
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

## 5.4 Using i18n in Scripts

### Example
```bash
# Source i18n library
source "$SCRIPT_DIR/i18n.sh"
init_lang "$CONFIG_FILE"

# Use simple message
info "$MSG_UPLOAD_COMPLETE"

# Use formatted message
info "$(printf "$MSG_UPLOADING_FILES" "$count" "$server:$path")"
```

## 5.5 Language Configuration

### sftp-config.json
```json
{
  "host": "example.com",
  "language": "zh"
}
```

### Supported Languages
| Code | Language |
|------|----------|
| `en` | English (default) |
| `zh`, `zh_CN`, `zh_TW` | Chinese |
| `ja`, `ja_JP` | Japanese |

---

## Summary

- Multi-language improves user experience
- Variable solution has zero dependencies
- `init_lang()` reads language from config
- `load_messages()` loads messages by language
- Support English, Chinese, Japanese

## Next Chapter

Chapter 6 will cover debugging and testing.
