---
name: "addon"
version: "1.0.0"
description: "Browser and software addon architecture reference — extension APIs, manifest formats, lifecycle hooks, and plugin security models. Use when building browser extensions, designing plugin systems, or understanding addon sandboxing."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [addon, extension, plugin, browser, architecture, api, devtools]
category: "devtools"
---

# Addon — Addon & Extension Architecture Reference

Quick-reference skill for browser extension development, plugin system design, and addon security.

## When to Use

- Building browser extensions (Chrome, Firefox, Safari)
- Designing plugin/addon architectures for applications
- Understanding extension manifest formats and permissions
- Implementing addon lifecycle hooks and event systems
- Reviewing addon security models and sandboxing

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of addon/extension architecture — types, platforms, and design patterns.

### `manifest`

```bash
scripts/script.sh manifest
```

Extension manifest formats — Manifest V3, permissions, content scripts.

### `lifecycle`

```bash
scripts/script.sh lifecycle
```

Addon lifecycle — install, activate, update, disable, uninstall hooks.

### `apis`

```bash
scripts/script.sh apis
```

Browser extension APIs — tabs, storage, messaging, alarms, notifications.

### `security`

```bash
scripts/script.sh security
```

Addon security — sandboxing, CSP, permission models, code review.

### `patterns`

```bash
scripts/script.sh patterns
```

Plugin architecture patterns — hook systems, middleware, event buses.

### `messaging`

```bash
scripts/script.sh messaging
```

Inter-component messaging — background ↔ content script ↔ popup communication.

### `publishing`

```bash
scripts/script.sh publishing
```

Publishing addons — Chrome Web Store, AMO, review process, updates.

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
| `ADDON_DIR` | Data directory (default: ~/.addon/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
