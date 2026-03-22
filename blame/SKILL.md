---
name: "blame"
version: "1.0.0"
description: "Git blame and code archaeology reference — annotation, history traversal, and root cause tracing. Use when investigating code authorship, tracking bug origins, or understanding commit history."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [blame, git, annotation, history, forensics, debugging, devtools]
category: "devtools"
---

# Blame — Git Blame & Code Archaeology Reference

Quick-reference skill for git blame techniques, code forensics, and history investigation.

## When to Use

- Finding who changed a specific line and why
- Tracing bug introductions through git history
- Understanding code evolution over time
- Using advanced blame options (ignore revs, follow renames)
- Code archaeology with git log, bisect, and pickaxe

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of git blame — purpose, output format, and basic usage.

### `options`

```bash
scripts/script.sh options
```

Key git blame flags: -L, -C, -M, -w, --since, --ignore-rev.

### `archaeology`

```bash
scripts/script.sh archaeology
```

Code archaeology techniques: git log -S, -G, --follow, --all.

### `bisect`

```bash
scripts/script.sh bisect
```

Git bisect workflow for finding the commit that introduced a bug.

### `ignorerevs`

```bash
scripts/script.sh ignorerevs
```

Setting up .git-blame-ignore-revs for formatting commits.

### `patterns`

```bash
scripts/script.sh patterns
```

Common investigation patterns: why was this line added/changed/deleted?

### `tooling`

```bash
scripts/script.sh tooling
```

IDE and tool integration: VS Code, IntelliJ, GitHub, tig, fugitive.

### `forensics`

```bash
scripts/script.sh forensics
```

Advanced forensics: reflog, lost commits, merge archaeology, file resurrection.

### `help`

```bash
scripts/script.sh help
```

### `version`

```bash
scripts/script.sh version
```

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
