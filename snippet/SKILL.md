---
name: Snippet
description: "Save and search code snippets in a personal vault for instant recall. Use when checking syntax, validating blocks, generating boilerplate, formatting code."
version: "3.0.1"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["snippet","code","manager","clipboard","template","cheatsheet","developer"]
categories: ["Developer Tools", "Productivity"]
---

# snippet

Code snippet manager.

## Commands

### `save`

Save snippet from stdin

```bash
scripts/script.sh save <name> [lang]
```

### `get`

Display a snippet

```bash
scripts/script.sh get <name>
```

### `list`

List all snippets (filter by language)

```bash
scripts/script.sh list [lang]
```

### `search`

Search snippets by name/content/tags

```bash
scripts/script.sh search <keyword>
```

### `delete`

Delete a snippet

```bash
scripts/script.sh delete <name>
```

### `tags`

Add tags to a snippet

```bash
scripts/script.sh tags <name> <tag1> ...
```

### `export`

Export all snippets

```bash
scripts/script.sh export <json|md>
```

### `stats`

Usage statistics

```bash
scripts/script.sh stats
```

## Requirements

- python3

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
