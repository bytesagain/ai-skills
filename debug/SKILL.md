# debug

Analyze error messages, stack traces, and logs to diagnose issues and suggest fixes. Covers Python, Node.js, Go, Bash, Docker, Git, and database errors.

## Usage

```
debug analyze <error_text_or_file>
debug explain <error_code_or_message>
debug suggest <error_text_or_file>
```

## Commands

- `analyze` — Parse and diagnose an error message or log file, identify root cause
- `explain` — Explain what an error code or message means in plain language
- `suggest` — Provide actionable fix suggestions for a given error

## Examples

```bash
# Analyze a Python traceback
debug analyze "TypeError: 'NoneType' object is not subscriptable"

# Explain an error code
debug explain "ECONNREFUSED"

# Get fix suggestions from a log file
debug suggest error.log
```

## Requirements

- bash
- python3

## When to Use

Use when you encounter error messages, stack traces, or cryptic error codes and need quick diagnosis and fix suggestions without leaving the terminal.
