---
version: "2.0.0"
name: Capistrano
description: "Automate deployments over SSH with Ruby-based release workflows. Use when deploying Rails apps, managing releases, or configuring multi-stage deploys."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Capistrano

Capistrano is a developer workflow automation tool that helps you initialize projects, run checks, build, test, deploy, and manage configuration — all from the terminal. It logs every action with timestamps for full auditability.

## Commands

| Command | Description |
|---------|-------------|
| `capistrano init` | Initialize a new project in the current directory |
| `capistrano check` | Run lint, type checks, and tests |
| `capistrano build` | Build the project |
| `capistrano test` | Run the full test suite |
| `capistrano deploy` | Show the deploy pipeline: build → test → stage → prod |
| `capistrano config` | Show or edit configuration (stored in `config.json`) |
| `capistrano status` | Check project health status |
| `capistrano template <name>` | Generate a code template for the given name |
| `capistrano docs` | Generate project documentation |
| `capistrano clean` | Remove build artifacts |
| `capistrano help` | Show help with all available commands |
| `capistrano version` | Show current version |

## How It Works

Every command is dispatched via a `case` statement in the shell script. Each action prints a summary to stdout and appends a timestamped entry to `history.log` in the data directory. This gives you a persistent audit trail of every operation you've run.

The deploy pipeline follows a clear progression: **build → test → stage → prod**, ensuring each phase passes before moving forward.

## Data Storage

All data is stored locally in `~/.local/share/capistrano/` by default:

- `history.log` — Timestamped log of every command executed
- `config.json` — Project configuration (via `capistrano config`)

Override the storage location by setting the `CAPISTRANO_DIR` environment variable:

```bash
export CAPISTRANO_DIR="$HOME/my-project/.capistrano"
```

## Requirements

- **bash 4+** (uses `set -euo pipefail` for strict mode)
- No external dependencies — pure bash
- No API keys needed

## When to Use

1. **Bootstrapping a new project** — Run `capistrano init` to set up project scaffolding in the current working directory
2. **Pre-commit quality gates** — Use `capistrano check` to run lint, type checks, and tests before committing code
3. **Building and testing in CI** — Chain `capistrano build` and `capistrano test` in your CI/CD pipeline for consistent workflows
4. **Guided deployments** — Run `capistrano deploy` to follow the build → test → stage → prod pipeline step by step
5. **Cleaning up between builds** — Use `capistrano clean` to remove stale build artifacts and start fresh

## Examples

```bash
# Initialize a project in the current directory
capistrano init

# Run all checks (lint + type check + tests)
capistrano check

# Build the project
capistrano build

# Run the test suite
capistrano test

# Show the deploy pipeline
capistrano deploy
```

```bash
# Generate documentation
capistrano docs

# Generate a code template
capistrano template api-controller

# Check project health
capistrano status
```

```bash
# View or edit configuration
capistrano config

# Clean build artifacts
capistrano clean

# Show version
capistrano version
```

## Output

All command output goes to stdout. The history log is always written to `$DATA_DIR/history.log`. You can redirect output as needed:

```bash
capistrano status > project-health.txt
```

## Configuration

| Variable | Purpose | Default |
|----------|---------|---------|
| `CAPISTRANO_DIR` | Override data/config directory | `~/.local/share/capistrano/` |

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
