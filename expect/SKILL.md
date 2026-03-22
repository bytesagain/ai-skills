---
name: "expect"
version: "1.0.0"
description: "Test assertion and expectation patterns reference — matcher syntax, assertion styles, and testing best practices. Use when writing test expectations, choosing assertion libraries, or debugging failing test matchers."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [expect, testing, assertions, matchers, jest, mocha, tdd, bdd]
category: "devtools"
---

# Expect — Test Assertion & Expectation Patterns

Quick-reference for test assertion patterns, matcher types, and expectation best practices across testing frameworks.

## When to Use

- Writing test expectations with proper matcher selection
- Understanding assertion styles (assert vs expect vs should)
- Debugging why a test matcher is failing
- Choosing between equality, truthiness, and structural matchers
- Writing custom matchers for domain-specific assertions

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of test expectations — assertion philosophy, TDD/BDD styles, framework landscape.

### `matchers`

```bash
scripts/script.sh matchers
```

Core matcher reference: equality, truthiness, numeric, string, array, and object matchers.

### `async`

```bash
scripts/script.sh async
```

Async expectation patterns — promises, rejects, resolves, and callback-style assertions.

### `custom`

```bash
scripts/script.sh custom
```

Writing custom matchers — extend expect with domain-specific assertions.

### `errors`

```bash
scripts/script.sh errors
```

Error and exception expectations — toThrow, rejects, error matching patterns.

### `snapshots`

```bash
scripts/script.sh snapshots
```

Snapshot testing — inline snapshots, serializers, and update strategies.

### `patterns`

```bash
scripts/script.sh patterns
```

Common assertion patterns and anti-patterns — best practices for reliable tests.

### `debug`

```bash
scripts/script.sh debug
```

Debugging failing expectations — reading diff output, common matcher mistakes.

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
| `EXPECT_DIR` | Data directory (default: ~/.expect/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
