---
version: "2.0.0"
name: Dive
description: "Explore Docker image layers and diagnose container build issues. Use when inspecting layers, debugging failures, checking configurations."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Container Inspect

Developer workflow automation tool for initializing, building, testing, and deploying projects from the command line.

## Commands

| Command    | Description                        |
|------------|------------------------------------|
| `init`     | Initialize a new project in the current directory |
| `check`    | Run lint, type check, and tests    |
| `build`    | Build the project                  |
| `test`     | Run the full test suite            |
| `deploy`   | Show deploy pipeline guide (build → test → stage → prod) |
| `config`   | View or edit configuration         |
| `status`   | Check overall project health       |
| `template` | Generate a code template for a given type |
| `docs`     | Generate project documentation     |
| `clean`    | Remove build artifacts             |
| `help`     | Show help and list all commands    |
| `version`  | Print current version              |

## Usage

```bash
container-inspect <command> [args]
```

All actions are logged to `$DATA_DIR/history.log` for auditing.

## Data Storage

- **Default directory:** `~/.local/share/container-inspect/`
- **Override:** Set the `CONTAINER_INSPECT_DIR` environment variable to change the data directory.
- **Files:**
  - `history.log` — timestamped log of every command executed
  - `config.json` — project-level configuration (created by `config`)
  - `data.log` — general data log

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- No external dependencies or API keys required
- Works on Linux, macOS, and WSL

## When to Use

1. **Setting up a new development environment** — Run `container-inspect init` to initialize your project structure before diving into code.
2. **Running pre-merge validation** — Use `container-inspect check` to run lint, type checks, and tests before merging a branch.
3. **Building artifacts for release** — Execute `container-inspect build` to compile and package your project for distribution.
4. **Automated testing in CI** — Use `container-inspect test` in your CI pipeline to run the full test suite on every push.
5. **Generating project docs** — Run `container-inspect docs` to auto-generate documentation from your codebase.

## Examples

```bash
# Initialize a project in the current directory
container-inspect init

# Run all quality checks (lint + type check + tests)
container-inspect check

# Build the project
container-inspect build

# Run the test suite
container-inspect test

# View the deployment pipeline guide
container-inspect deploy
```

```bash
# Check project health status
container-inspect status

# Generate a code template
container-inspect template service

# Generate project documentation
container-inspect docs

# Clean build artifacts
container-inspect clean

# Show version
container-inspect version
```

## Output

All command output goes to stdout. Redirect to a file if needed:

```bash
container-inspect status > report.txt
```

## Configuration

Set `CONTAINER_INSPECT_DIR` to customize where data is stored:

```bash
export CONTAINER_INSPECT_DIR=/path/to/custom/dir
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
