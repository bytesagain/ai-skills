---
name: "middleware"
version: "1.0.0"
description: "Middleware architecture reference — request pipelines, chain-of-responsibility patterns, error handling, and middleware composition in web frameworks. Use when designing or debugging middleware stacks."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [middleware, web, pipeline, express, koa, http, devtools]
category: "devtools"
---

# Middleware — Middleware Architecture Reference

Quick-reference skill for middleware design patterns, request pipelines, and composition strategies across web frameworks.

## When to Use

- Designing a middleware pipeline for a web application
- Understanding chain-of-responsibility and onion model patterns
- Implementing auth, logging, error handling, or CORS middleware
- Debugging middleware execution order issues
- Comparing middleware approaches across frameworks

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of middleware concept — history, patterns, request lifecycle.

### `patterns`

```bash
scripts/script.sh patterns
```

Middleware patterns: linear pipeline, onion model, interceptors, filters.

### `express`

```bash
scripts/script.sh express
```

Express.js middleware — app.use, router-level, error handling, ordering.

### `auth`

```bash
scripts/script.sh auth
```

Authentication/authorization middleware patterns — JWT, session, RBAC.

### `errors`

```bash
scripts/script.sh errors
```

Error handling middleware — centralized error handlers, async errors, error boundaries.

### `cors`

```bash
scripts/script.sh cors
```

CORS middleware — preflight, headers, origin validation, credentials.

### `performance`

```bash
scripts/script.sh performance
```

Performance middleware — compression, caching, rate limiting, request coalescing.

### `testing`

```bash
scripts/script.sh testing
```

Testing middleware in isolation — mocking req/res, integration testing strategies.

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
| `MIDDLEWARE_DIR` | Data directory (default: ~/.middleware/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
