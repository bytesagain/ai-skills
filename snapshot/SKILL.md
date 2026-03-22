---
name: "snapshot"
version: "1.0.0"
description: "Snapshot testing reference — capture, compare, and update test snapshots for UI components, API responses, and serialized output. Use when implementing snapshot tests, debugging snapshot mismatches, or choosing snapshot strategies."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [snapshot, testing, jest, regression, ui-testing, serialization]
category: "devtools"
---

# Snapshot — Snapshot Testing Reference

Quick-reference skill for snapshot testing concepts, strategies, and best practices across testing frameworks.

## When to Use

- Setting up snapshot tests for React components or API responses
- Debugging unexpected snapshot diffs
- Choosing between inline vs file snapshots
- Understanding snapshot serialization and custom serializers
- Reviewing snapshot update workflows in CI/CD

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of snapshot testing — what it is, when to use it, how it fits in the testing pyramid.

### `workflow`

```bash
scripts/script.sh workflow
```

The snapshot test lifecycle: capture, commit, compare, update.

### `formats`

```bash
scripts/script.sh formats
```

Snapshot format types: file-based, inline, property matchers, and custom serializers.

### `jest`

```bash
scripts/script.sh jest
```

Jest snapshot testing API — toMatchSnapshot, toMatchInlineSnapshot, snapshot resolvers.

### `pitfalls`

```bash
scripts/script.sh pitfalls
```

Common snapshot testing anti-patterns and how to avoid them.

### `diffing`

```bash
scripts/script.sh diffing
```

Reading and interpreting snapshot diffs — structural vs cosmetic changes.

### `ci`

```bash
scripts/script.sh ci
```

Snapshot testing in CI/CD pipelines — preventing accidental updates, review gates.

### `strategies`

```bash
scripts/script.sh strategies
```

Advanced strategies: focused snapshots, snapshot per component, database snapshots.

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
