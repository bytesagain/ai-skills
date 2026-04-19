---
description: "Analyze errors, stack traces, and logs to diagnose root causes and suggest fixes. Use when debugging Python, Node.js, Go, or Bash errors, interpreting Kubernetes events, diagnosing Docker issues, or resolving database connection errors."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# debugger

Analyze error messages, stack traces, and logs to diagnose root causes and suggest actionable fixes. Covers Python, Node.js, Go, Bash, Docker, Kubernetes, Git, and database errors with 24+ built-in patterns.

## Usage

```
debugger analyze <error_text_or_file>
debugger explain <error_code>
debugger suggest <error_text_or_file>
```

## Commands

- `analyze` — Parse error input, match known patterns, identify root cause and language context
- `explain` — Explain what a specific error code or message means in plain language
- `suggest` — Return actionable fix steps for the given error

## Examples

```bash
debugger analyze "TypeError: 'NoneType' object is not subscriptable"
debugger explain ECONNREFUSED
debugger suggest error.log
debugger analyze "CrashLoopBackOff"
```

## Requirements

- bash
- python3

## When to Use

Use when you encounter cryptic error messages, stack traces, or error codes and need quick diagnosis without leaving the terminal. Supports Python, Node.js, Go, Bash, Docker, Kubernetes, Git, PostgreSQL, MySQL errors.
