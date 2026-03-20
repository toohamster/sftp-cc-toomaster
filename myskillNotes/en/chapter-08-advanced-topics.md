# Chapter 8: Advanced Topics and Best Practices

## 8.1 Performance Optimization

### Reduce Subprocess Calls
```bash
# Not recommended: Creates subprocess every time
for file in "${files[@]}"; do
    result=$(grep "pattern" "$file")
done

# Recommended: Batch processing
grep "pattern" "${files[@]}"
```

### Use Arrays Instead of String Concatenation
```bash
# Dangerous
args=""
for f in "${files[@]}"; do
    args="$args \"$f\""
done
eval "command $args"

# Safe
args=()
for f in "${files[@]}"; do
    args+=("$f")
done
command "${args[@]}"
```

## 8.2 Security Best Practices

### Avoid Command Injection
```bash
# Dangerous
user_input="$1"
eval "echo $user_input"

# Safe
user_input="$1"
echo "$user_input"
```

### Safe File Path Handling
```bash
# Always quote variables
cat "$file"

# Validate path
if [[ "$file" == /* ]]; then
    if [[ "$file" != /tmp/* ]] && [[ "$file" != "$PROJECT_ROOT"/* ]]; then
        error "Path not allowed"
        exit 1
    fi
fi
```

### Permission Management
```bash
# Private key must be 600
chmod 600 "$PRIVATE_KEY"

# Config file should be 644
chmod 644 "$CONFIG_FILE"

# Script should be 755
chmod 755 "$SCRIPT_FILE"
```

## 8.3 Code Organization

### Function Naming Convention
```bash
# Verb + Noun: Describe function behavior
init_lang()
load_messages()
push_files()

# Boolean functions: Use is/has/check prefix
is_excluded()
has_permission()
check_config()
```

### Variable Scope
```bash
# Local variables: Use local
process_file() {
    local file="$1"
    local content
}

# Global variables: Uppercase
readonly VERSION="1.0.0"
```

## 8.4 Error Handling with trap

```bash
# Error handler
error_handler() {
    local line_no=$1
    error "Script error at line: $line_no"
}

# Register error handler
trap 'error_handler ${LINENO}' ERR

# Register exit handler
trap 'cleanup' EXIT
```

## 8.5 Troubleshooting Checklist

### Skill Not Triggering
- [ ] Check SKILL.md trigger word definition
- [ ] Reload Plugin
- [ ] Check marketplace.json configuration

### Variable Not Resolved
- [ ] Confirm ${CLAUDE_PLUGIN_ROOT} is used in Skill context
- [ ] Use absolute path when executing directly in shell

### SFTP Connection Failed
- [ ] Check network connection
- [ ] Verify server address and port
- [ ] Check private key permissions (600)
- [ ] Use `sftp -v` for detailed debugging

---

## Book Summary

Through developing sftp-cc, you have mastered:

1. **Plugin Architecture**: SKILL.md, marketplace.json, ${CLAUDE_PLUGIN_ROOT}
2. **Writing Skill**: Trigger words, YAML frontmatter, execution instructions
3. **Shell Scripting**: JSON parsing, error handling, logging
4. **Multi-language Support**: i18n implementation
5. **Debugging & Testing**: set options, verbose mode, dry-run
6. **Publishing**: Version management, GitHub API

### Next Steps
- Develop your own Skill based on this template
- Publish to Plugin Marketplace
- Continuously optimize and iterate

Good luck with your development!
