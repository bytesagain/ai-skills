---
version: "2.0.0"
name: Gorilla
description: "Gorilla: Training and Evaluating LLMs for Function Calls (Tool Calls) api-router, python, api, api-documentation, chatgpt, claude-api."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# API Router

API Router v2.0.0 — a developer workflow automation tool for initializing projects, running checks, building, testing, deploying, generating templates, and managing documentation from the command line.

## Commands

| Command | Description |
|---------|-------------|
| `api-router init` | Initialize a new project in the current directory |
| `api-router check` | Run lint, type check, and test checks |
| `api-router build` | Build the project |
| `api-router test` | Run the test suite |
| `api-router deploy` | Show the deploy pipeline guide (build → test → stage → prod) |
| `api-router config` | Show configuration file path |
| `api-router status` | Check project health and status |
| `api-router template <name>` | Generate a code template for the given name |
| `api-router docs` | Generate project documentation |
| `api-router clean` | Clean build artifacts |
| `api-router help` | Show usage info and all available commands |
| `api-router version` | Show version (v2.0.0) |

## How It Works

API Router provides a unified CLI for common developer workflow tasks. Each command performs its action and logs the activity with a timestamp to `history.log` for full traceability.

- **`init`** — scaffolds a new project in the current working directory
- **`check`** — runs lint + type check + tests in sequence
- **`build`** — triggers the build process
- **`test`** — executes the test suite
- **`deploy`** — outputs the recommended deployment pipeline (build → test → stage → prod)
- **`template`** — generates boilerplate code for a given component
- **`docs`** — auto-generates documentation
- **`clean`** — removes build artifacts
- **`config`** — points to the configuration file location
- **`status`** — reports on overall project health

## Data Storage

- **Location**: `~/.local/share/api-router/` (override with `API_ROUTER_DIR` or `XDG_DATA_HOME`)
- **History**: `history.log` — audit trail of all commands executed with timestamps
- **Config**: `config.json` (referenced by the config command)
- **Data log**: `data.log` — general-purpose data store

## Requirements

- Bash (4.0+)
- Standard Unix utilities (`date`, `echo`)
- No external dependencies or API keys required

## When to Use

1. **Starting a new project** — run `api-router init` to scaffold the project structure, then `api-router config` to review settings
2. **Pre-commit validation** — use `api-router check` to run lint, type checks, and tests before committing code
3. **Building and deploying** — execute `api-router build` followed by `api-router deploy` to see the full deployment pipeline
4. **Generating boilerplate** — `api-router template controller` to quickly create code templates for common patterns
5. **Project maintenance** — run `api-router clean` to remove stale artifacts, then `api-router status` to verify project health

## Examples

```bash
# Initialize a new project
api-router init

# Run all checks (lint + type check + tests)
api-router check

# Build the project
api-router build

# Run tests
api-router test

# Show the deployment pipeline
api-router deploy

# Generate a code template
api-router template auth-middleware

# Generate documentation
api-router docs

# Check project health
api-router status

# Clean build artifacts
api-router clean

# View configuration
api-router config

# Show all available commands
api-router help
```

## Output

Results go to stdout. Redirect output with `api-router build > build.log`. All commands are logged to `history.log` for auditability.

## Configuration

Set `API_ROUTER_DIR` environment variable to change the data directory. Alternatively, set `XDG_DATA_HOME` (data will go to `$XDG_DATA_HOME/api-router/`). Default: `~/.local/share/api-router/`

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
