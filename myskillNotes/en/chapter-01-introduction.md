# Chapter 1: Introduction to Claude Code Skill

## 1.1 What is Claude Code Skill

### Definition of Skill
- Skill is the plugin system for Claude Code
- Triggered by natural language
- Automatically executes predefined actions

### What Skills Can Do
- File operations (upload, download, sync)
- Code generation and transformation
- External API calls
- Automated workflows

### Difference from VS Code Extensions
| Item | Claude Code Skill | VS Code Extension |
|------|------------------|-------------|
| Trigger method | Natural language | Button click / keyboard shortcut |
| Runtime environment | Claude Code CLI | VS Code |
| Development difficulty | Low (documentation + scripts) | High (TypeScript + API) |

---

## 1.2 Claude Code Plugin Architecture

### Directory Structure
```
my-plugin/
├── .claude-plugin/
│   └── marketplace.json    # Marketplace configuration
├── skills/
│   └── my-skill/
│       └── SKILL.md        # Skill definition (core)
├── scripts/
│   └── my-script.sh        # Execution script
└── README.md               # Documentation
```

### Core Components

#### 1. SKILL.md
- Core definition file for Skill
- Contains YAML frontmatter
- Defines trigger words and execution logic

#### 2. ${CLAUDE_PLUGIN_ROOT} Variable
```markdown
**Important**: ${CLAUDE_PLUGIN_ROOT} is an internal Skill variable injected by Claude Code

- Only valid in Skill context
- Automatically resolved to plugin root directory path at runtime
- Example: `~/.claude/plugins/marketplaces/my-plugin/`
```

#### 3. scripts/ Directory
- Stores executable scripts
- Supports shell, Python, etc.
- Access via ${CLAUDE_PLUGIN_ROOT}/scripts/

---

## 1.3 How Skill Works

### Trigger Flow
```
User input → Claude recognizes intent → Matches trigger words → Loads SKILL.md → Executes corresponding script
```

### Variable Injection Mechanism
```
User says: "Sync code to server"
  ↓
Claude recognizes SFTP upload intent
  ↓
Finds matching Skill (sftp-cc)
  ↓
Loads SKILL.md, injects ${CLAUDE_PLUGIN_ROOT}
  ↓
Executes: bash ${CLAUDE_PLUGIN_ROOT}/scripts/sftp-push.sh
```

### FAQ

**Q: Why is ${CLAUDE_PLUGIN_ROOT} empty when I execute with bash?**

A: `${CLAUDE_PLUGIN_ROOT}` is only injected by Claude Code in Skill context. When executing directly in shell, you need to use absolute path:
```bash
# Wrong: Direct execution, variable is empty
bash ${CLAUDE_PLUGIN_ROOT}/scripts/sftp-push.sh

# Correct: Use absolute path
bash ~/.claude/plugins/marketplaces/sftp-cc/scripts/sftp-push.sh
```

---

## 1.4 Development Environment Setup

### Install Claude Code
```bash
# macOS
brew install claude-code

# npm
npm install -g @anthropic-ai/claude-code
```

### Verify Installation
```bash
claude --version
```

### Directory Preparation
```bash
# Create project directory
mkdir my-first-skill
cd my-first-skill

# Create basic structure
mkdir -p .claude-plugin skills/my-skill scripts
```

---

## Summary

- Skill is the plugin system for Claude Code
- SKILL.md is the core definition file
- ${CLAUDE_PLUGIN_ROOT} is an internal variable, automatically resolved at runtime
- Development environment requires Claude Code CLI

## Next Chapter

Chapter 2 will guide you through project planning and design, from requirements analysis to directory structure planning.
