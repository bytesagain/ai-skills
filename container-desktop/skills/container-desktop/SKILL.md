---
version: "2.0.0"
name: Podman Desktop
description: "Podman Desktop is the best free and open source tool to work with Containers and Kubernetes for deve podman desktop, typescript, container, containers."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Container Desktop

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
container-desktop <command> [args]
```

All actions are logged to `$DATA_DIR/history.log` for auditing.

## Data Storage

- **Default directory:** `~/.local/share/container-desktop/`
- **Override:** Set the `CONTAINER_DESKTOP_DIR` environment variable to change the data directory.
- **Files:**
  - `history.log` — timestamped log of every command executed
  - `config.json` — project-level configuration (created by `config`)
  - `data.log` — general data log

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- No external dependencies or API keys required
- Works on Linux, macOS, and WSL

## When to Use

1. **Starting a new project** — Run `container-desktop init` to scaffold and initialize your workspace before writing any code.
2. **Pre-commit quality checks** — Use `container-desktop check` to run lint, type checking, and tests in a single command before pushing code.
3. **Building for deployment** — Execute `container-desktop build` as part of your CI/CD pipeline or local build workflow.
4. **Running tests** — Use `container-desktop test` to run your full test suite during development or in automated pipelines.
5. **Cleaning up after builds** — Run `container-desktop clean` to remove generated artifacts and free disk space between builds.

## Examples

```bash
# Initialize a project in the current directory
container-desktop init

# Run all quality checks (lint + type check + tests)
container-desktop check

# Build the project
container-desktop build

# Run the test suite
container-desktop test

# View the deployment pipeline guide
container-desktop deploy
```

```bash
# Check project health status
container-desktop status

# Generate a code template
container-desktop template component

# Generate project documentation
container-desktop docs

# Clean build artifacts
container-desktop clean

# Show version
container-desktop version
```

## Output

All command output goes to stdout. Redirect to a file if needed:

```bash
container-desktop status > report.txt
```

## Configuration

Set `CONTAINER_DESKTOP_DIR` to customize where data is stored:

```bash
export CONTAINER_DESKTOP_DIR=/path/to/custom/dir
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
