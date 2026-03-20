# Chapter 6: Debugging and Testing

## 6.1 Shell Script Debugging Basics

### set Command Options
```bash
#!/bin/bash
set -euo pipefail  # Recommended for production

# For debugging
set -x  # Print every command executed
set -v  # Print every line read
```

| Option | Description |
|--------|-------------|
| `-e` | Exit immediately on command failure |
| `-u` | Error on undefined variable |
| `-o pipefail` | Pipeline fails if any command fails |
| `-x` | Print execution trace |
| `-v` | Print input lines |

## 6.2 Log Level Design

### Four-Level Log System
```bash
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Log functions
info()  { echo -e "${GREEN}[prefix]${NC} $*"; }
warn()  { echo -e "${YELLOW}[prefix]${NC} $*" >&2; }
error() { echo -e "${RED}[prefix]${NC} $*" >&2; }
```

## 6.3 Verbose Mode

### Add Debug Output Switch
```bash
VERBOSE=false
if [[ "${1:-}" == "-v" ]] || [[ "${1:-}" == "--verbose" ]]; then
    VERBOSE=true
fi

debug() {
    $VERBOSE && echo -e "[DEBUG] $*" >&2
}
```

## 6.4 Temporary File Management

### mktemp Create Temp Files
```bash
tmp_file=$(mktemp)
changed_list=$(mktemp)
```

### trap Cleanup
```bash
cleanup() {
    rm -f "$tmp_file" "$changed_list"
}
trap cleanup EXIT
```

## 6.5 Error Handling Patterns

### Parameter Validation
```bash
MISSING=()
[ -z "$HOST" ] && MISSING+=("host")
[ -z "$USERNAME" ] && MISSING+=("username")

if [ ${#MISSING[@]} -gt 0 ]; then
    error "Configuration incomplete: ${MISSING[*]}"
    exit 1
fi
```

### Command Existence Check
```bash
if ! command -v sftp &>/dev/null; then
    error "sftp command not found"
    exit 1
fi
```

### File Existence Check
```bash
if [ ! -f "$CONFIG_FILE" ]; then
    error "Config file not found"
    exit 1
fi
```

## 6.6 Testing Methods

### Dry-run Mode
```bash
DRY_RUN=false
if [[ "${1:-}" == "-n" ]]; then
    DRY_RUN=true
fi

if $DRY_RUN; then
    info "[Preview] Would upload $count files"
    return 0
fi

# Actually execute
sftp "$SFTP_TARGET" < "$batch_file"
```

---

## Summary

- Use `set -euo pipefail` for strict error handling
- Four-level log system: info/warn/error
- Verbose mode provides detailed output
- Temp files use `mktemp` + `trap`
- Dry-run mode to preview operations

## Next Chapter

Chapter 7 will cover publishing and distribution.
