---
name: "plugin"
version: "1.0.0"
description: "Plugin architecture reference — plugin system design patterns, hook mechanisms, dependency injection, sandboxing, and lifecycle management. Use when designing extensible software with plugin APIs."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [plugin, extension, hooks, architecture, api, extensibility, devtools]
category: "devtools"
---

# Plugin — Plugin Architecture Reference

Quick-reference skill for plugin system design, hook mechanisms, and extensibility patterns.

## When to Use

- Designing a plugin/extension system for an application
- Implementing hook/event systems for third-party extensibility
- Understanding plugin lifecycle (discovery, loading, activation)
- Building sandboxed plugin execution environments
- Evaluating plugin architectures in existing systems

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of plugin architecture — goals, trade-offs, when to use plugins.

### `patterns`

```bash
scripts/script.sh patterns
```

Plugin design patterns: hooks, middleware, interceptors, dependency injection.

### `lifecycle`

```bash
scripts/script.sh lifecycle
```

Plugin lifecycle — discovery, loading, initialization, activation, deactivation, unloading.

### `hooks`

```bash
scripts/script.sh hooks
```

Hook systems — action hooks, filter hooks, event emitters, tap/call patterns.

### `isolation`

```bash
scripts/script.sh isolation
```

Plugin isolation — sandboxing, permissions, process separation, WASM plugins.

### `api`

```bash
scripts/script.sh api
```

Plugin API design — stable contracts, versioning, capability negotiation.

### `realworld`

```bash
scripts/script.sh realworld
```

Real-world plugin systems — VS Code, webpack, WordPress, Vim, Figma.

### `testing`

```bash
scripts/script.sh testing
```

Testing plugin systems — plugin testing, host testing, compatibility matrices.

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
| `PLUGIN_DIR` | Data directory (default: ~/.plugin/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
