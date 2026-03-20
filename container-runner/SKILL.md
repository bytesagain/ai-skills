---
version: "2.0.0"
name: Podman
description: "Run and manage OCI containers and pods with Podman rootless mode. Use when launching containers, managing pods, building images."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Container Runner

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
container-runner <command> [args]
```

All actions are logged to `$DATA_DIR/history.log` for auditing.

## Data Storage

- **Default directory:** `~/.local/share/container-runner/`
- **Override:** Set the `CONTAINER_RUNNER_DIR` environment variable to change the data directory.
- **Files:**
  - `history.log` — timestamped log of every command executed
  - `config.json` — project-level configuration (created by `config`)
  - `data.log` — general data log

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- No external dependencies or API keys required
- Works on Linux, macOS, and WSL

## When to Use

1. **Bootstrapping a new project** — Run `container-runner init` to set up the initial project scaffolding in your working directory.
2. **Running quality gates before deployment** — Use `container-runner check` to validate code quality with lint, type checks, and tests in one shot.
3. **Building release artifacts** — Execute `container-runner build` to compile and package your application for staging or production.
4. **Executing the full test suite** — Use `container-runner test` during development or in CI to verify all tests pass.
5. **Deploying to production** — Run `container-runner deploy` to see the recommended deployment pipeline (build → test → stage → prod).

## Examples

```bash
# Initialize a project in the current directory
container-runner init

# Run all quality checks (lint + type check + tests)
container-runner check

# Build the project
container-runner build

# Run the test suite
container-runner test

# View the deployment pipeline guide
container-runner deploy
```

```bash
# Check project health status
container-runner status

# Generate a code template
container-runner template controller

# Generate project documentation
container-runner docs

# Clean build artifacts
container-runner clean

# Show version
container-runner version
```

## Output

All command output goes to stdout. Redirect to a file if needed:

```bash
container-runner status > report.txt
```

## Configuration

Set `CONTAINER_RUNNER_DIR` to customize where data is stored:

```bash
export CONTAINER_RUNNER_DIR=/path/to/custom/dir
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
