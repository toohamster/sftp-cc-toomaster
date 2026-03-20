# Chapter 4: Script Development

## 4.1 Script Structure Template

### Standard Structure
```bash
#!/bin/bash
# Script name: Description
# Usage: Instructions

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Log functions
info()  { echo -e "${GREEN}[script]${NC} $*"; }
warn()  { echo -e "${YELLOW}[script]${NC} $*" >&2; }
error() { echo -e "${RED}[script]${NC} $*" >&2; }

# Main logic
main() {
    info "Starting..."
    # ...
}

main "$@"
```

## 4.2 Pure Shell JSON Parsing

### Why Not jq
- External dependency, requires installation
- Not available on all systems
- Shell can handle simple JSON

### JSON Parsing Functions
```bash
# Read string value
json_get() {
    local file="$1" key="$2" default="${3:-}"
    local val
    val=$(grep "\"$key\"" "$file" 2>/dev/null | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')
    echo "${val:-$default}"
}

# Read number value
json_get_num() {
    local file="$1" key="$2" default="${3:-0}"
    local val
    val=$(grep "\"$key\"" "$file" 2>/dev/null | head -1 | sed 's/.*: *\([0-9]*\).*/\1/')
    echo "${val:-$default}"
}
```

## 4.3 Error Handling

### Parameter Validation
```bash
MISSING=()
[ -z "$HOST" ]        && MISSING+=("host")
[ -z "$USERNAME" ]    && MISSING+=("username")
[ -z "$REMOTE_PATH" ] && MISSING+=("remote_path")

if [ ${#MISSING[@]} -gt 0 ]; then
    error "Configuration incomplete, missing: ${MISSING[*]}"
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
    error "Config file not found: $CONFIG_FILE"
    exit 1
fi
```

## 4.4 Locate Project Root

### Using git
```bash
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
```

### Why
- Support execution in subdirectories
- Compatible with non-git projects (fallback to pwd)
- Unified path reference

---

## Summary

- Master pure Shell JSON parsing
- Complete error handling
- Use git to locate project root
- Clean up temporary files promptly

## Next Chapter

Chapter 5 will cover internationalization (i18n).
