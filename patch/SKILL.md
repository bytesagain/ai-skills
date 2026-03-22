---
name: "patch"
version: "1.0.0"
description: "Software patching reference — diff/patch formats, semantic patching, binary patching, hot patching, and version management. Use when creating, applying, or understanding software patches and update mechanisms."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [patch, diff, update, binary-patch, hotfix, version, devtools]
category: "devtools"
---

# Patch — Software Patching Reference

Quick-reference skill for patch formats, diff algorithms, binary patching, and software update mechanisms.

## When to Use

- Creating and applying unified diff patches
- Understanding diff algorithms (Myers, patience, histogram)
- Implementing binary delta patching for software updates
- Hot patching running systems without restarts
- Managing patch workflows in version control

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of patching — history, diff/patch workflow, types of patches.

### `formats`

```bash
scripts/script.sh formats
```

Patch formats: unified diff, context diff, ed script, git diff format.

### `algorithms`

```bash
scripts/script.sh algorithms
```

Diff algorithms: Myers, patience, histogram — how they find differences.

### `git`

```bash
scripts/script.sh git
```

Git patch workflow — format-patch, am, cherry-pick, rebase, conflict resolution.

### `binary`

```bash
scripts/script.sh binary
```

Binary delta patching — bsdiff, xdelta, courgette, OTA updates.

### `hotpatch`

```bash
scripts/script.sh hotpatch
```

Hot patching — live kernel patching, JVM hotswap, feature flags, blue-green deploy.

### `security`

```bash
scripts/script.sh security
```

Security patching — CVE lifecycle, patch management, vulnerability windows.

### `kernel`

```bash
scripts/script.sh kernel
```

OS and kernel patching — Linux kpatch/livepatch, Windows Update, patch Tuesday.

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
| `PATCH_DIR` | Data directory (default: ~/.patch/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
