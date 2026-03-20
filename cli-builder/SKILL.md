---
version: "2.0.0"
name: CLI Builder
description: "CLI tool generator. Project scaffolding, command adding, argument parsing, help docs, config handling, publish checklist, interactive prompts."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# CLI Builder — Command-Line Tool Generator

> Scaffold professional CLI tools from scratch, full lifecycle coverage

## Quick Start

```bash
bash scripts/cli-builder.sh init myapp python
bash scripts/cli-builder.sh command myapp serve "Start dev server"
bash scripts/cli-builder.sh args python --name,--port,--verbose
```

## Commands

| Command | Purpose | Arguments |
|---------|---------|-----------|
| `init` | Project skeleton | `<name> <lang>` |
| `command` | Add a command | `<app> <cmd> <desc>` |
| `args` | Argument parser code | `<lang> <args>` |
| `help` | Help doc generation | `<app> <commands>` |
| `config` | Config file handling | `<lang> <format>` |
| `publish` | Publish checklist | `<platform>` |
| `interactive` | Interactive prompts | `<lang> <prompts>` |
| `color` | Colored output code | `<lang>` |

## Supported Languages

- **Python** — argparse / click / typer
- **Node.js** — commander / yargs / inquirer
- **Bash** — getopts / case patterns
- **Go** — cobra / flag

## Output

All generated code is copy-paste ready with comments and best practices included.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
