---
version: "2.0.0"
name: Claude Code Templates
description: "Configure and manage Claude Code templates, presets, and monitoring. Use when standardizing project setups, sharing configs, or initializing repos."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Code Templates

Developer workflow automation tool for initializing projects, running checks, building, testing, deploying, and managing code templates — all from one CLI.

## Commands

| Command | Description |
|---------|-------------|
| `init` | Initialize a new project in the current directory |
| `check` | Run lint, type check, and tests in one pass |
| `build` | Build the project |
| `test` | Run the full test suite |
| `deploy` | Show deployment guide (build → test → stage → prod) |
| `config` | Show or edit configuration (stored in `config.json`) |
| `status` | Check overall project health |
| `template` | Generate a code template for a given type |
| `docs` | Generate project documentation |
| `clean` | Remove build artifacts |
| `help` | Show help message with all available commands |
| `version` | Print current version (v2.0.0) |

## Usage

```bash
code-templates <command> [args]
```

Every command logs its invocation to `$DATA_DIR/history.log` for auditability.

## Data Storage

- **Default location**: `$XDG_DATA_HOME/code-templates` (falls back to `~/.local/share/code-templates`)
- **Override**: Set `CODE_TEMPLATES_DIR` environment variable to use a custom path
- **Files stored**:
  - `history.log` — timestamped log of every command run
  - `config.json` — project configuration (managed via `config` command)
  - `data.log` — general data log

## Requirements

- Bash 4+ with `set -euo pipefail` (strict mode)
- No external dependencies or API keys required
- Standard Unix tools (`date`, `pwd`)

## When to Use

1. **Starting a new project** — Run `code-templates init` to scaffold the project structure in your current directory
2. **Pre-commit quality gate** — Use `code-templates check` to run lint, type checks, and tests together before committing
3. **CI/CD pipeline integration** — Chain `code-templates build` and `code-templates test` in your pipeline scripts
4. **Deployment planning** — Run `code-templates deploy` to see the full build → test → stage → prod workflow
5. **Project maintenance** — Use `code-templates clean` to remove stale build artifacts, then `code-templates status` to verify project health

## Examples

```bash
# Initialize a new project
code-templates init

# Run all quality checks (lint + type check + tests)
code-templates check

# Build the project
code-templates build

# Run the test suite
code-templates test

# See the deployment guide
code-templates deploy

# Generate a code template for a React component
code-templates template react-component

# Generate project docs
code-templates docs

# Check project health
code-templates status

# View or edit config
code-templates config

# Clean up build artifacts
code-templates clean

# Show version
code-templates version
```

## Output

All command output goes to stdout. History is automatically appended to `$DATA_DIR/history.log`. Redirect output as needed:

```bash
code-templates build > build.log 2>&1
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
