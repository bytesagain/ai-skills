---
name: "error"
version: "1.0.0"
description: "Error handling reference — error types, exception patterns, HTTP status codes, retry strategies, and observability. Use when designing error handling, debugging failures, or implementing resilient systems."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [error, exception, debugging, http-status, retry, resilience, devtools]
category: "devtools"
---

# Error — Error Handling & Resilience Reference

Quick-reference skill for error handling patterns, HTTP status codes, retry strategies, and debugging techniques.

## When to Use

- Designing error handling strategy for an application
- Looking up HTTP status codes and their proper usage
- Implementing retry logic with backoff strategies
- Debugging production errors and failure patterns
- Building resilient systems with circuit breakers

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of error handling — philosophy, types, and design principles.

### `http`

```bash
scripts/script.sh http
```

HTTP status codes — complete reference with proper usage.

### `patterns`

```bash
scripts/script.sh patterns
```

Error handling patterns — try/catch, Result types, error boundaries.

### `retry`

```bash
scripts/script.sh retry
```

Retry strategies — exponential backoff, jitter, circuit breakers.

### `logging`

```bash
scripts/script.sh logging
```

Error logging best practices — structured logging, context, severity levels.

### `messages`

```bash
scripts/script.sh messages
```

Error message design — user-facing vs developer-facing, i18n, codes.

### `debug`

```bash
scripts/script.sh debug
```

Debugging techniques — root cause analysis, bisection, tracing.

### `checklist`

```bash
scripts/script.sh checklist
```

Error handling checklist for production applications.

### `help`

```bash
scripts/script.sh help
```

### `version`

```bash
scripts/script.sh version
```

## Configuration

| Variable | Description |
|----------|-------------|
| `ERROR_DIR` | Data directory (default: ~/.error/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
