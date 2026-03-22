---
name: "extension"
version: "1.0.0"
description: "Browser and editor extension development reference — manifest v3, content scripts, background workers, and extension APIs. Use when building browser extensions, VS Code extensions, or understanding extension architecture."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [extension, browser, chrome, vscode, plugin, manifest, addon]
category: "devtools"
---

# Extension — Browser & Editor Extension Development

Quick-reference for building browser extensions (Chrome/Firefox) and editor extensions (VS Code).

## When to Use

- Building a Chrome extension with Manifest V3
- Writing content scripts and background service workers
- Understanding extension permission models
- Developing VS Code extensions and Language Server Protocol
- Debugging extension lifecycle and messaging

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of extension development — architecture, types, and platform landscape.

### `manifest`

```bash
scripts/script.sh manifest
```

Chrome Manifest V3 reference — permissions, content scripts, background workers.

### `content`

```bash
scripts/script.sh content
```

Content scripts — DOM access, isolation, injection patterns, and messaging.

### `background`

```bash
scripts/script.sh background
```

Background service workers — lifecycle, event handling, alarms, and storage.

### `messaging`

```bash
scripts/script.sh messaging
```

Extension messaging — content↔background, cross-extension, and native messaging.

### `vscode`

```bash
scripts/script.sh vscode
```

VS Code extension development — activation events, commands, and API.

### `security`

```bash
scripts/script.sh security
```

Extension security — CSP, permission scoping, and review process.

### `publish`

```bash
scripts/script.sh publish
```

Publishing extensions — Chrome Web Store, AMO, VS Code Marketplace.

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
| `EXTENSION_DIR` | Data directory (default: ~/.extension/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
