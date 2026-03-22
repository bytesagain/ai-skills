---
name: "stub"
version: "1.0.0"
description: "Test stub reference — creating fake implementations for isolating units under test. Use when building test doubles, understanding stub vs mock vs fake, or implementing stubs across testing frameworks."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [stub, testing, mock, fake, test-double, isolation]
category: "devtools"
---

# Stub — Test Stub Reference

Quick-reference skill for test stubs — creating controlled fake implementations for unit test isolation.

## When to Use

- Creating test doubles for external dependencies
- Understanding stub vs mock vs fake vs spy
- Implementing stubs in Jest, Sinon, Go, Rust, Python
- Designing code for testability with dependency injection
- Stubbing HTTP calls, databases, file systems, and timers

## Commands

### `intro`

```bash
scripts/script.sh intro
```

What stubs are, test double taxonomy, when to use each type.

### `javascript`

```bash
scripts/script.sh javascript
```

JavaScript stubbing with Jest and Sinon — modules, functions, timers.

### `golang`

```bash
scripts/script.sh golang
```

Go stubs using interfaces, struct implementations, and test helpers.

### `python`

```bash
scripts/script.sh python
```

Python stubs with unittest.mock — patch, MagicMock, side_effect.

### `http`

```bash
scripts/script.sh http
```

Stubbing HTTP calls — MSW, nock, httptest, responses.

### `design`

```bash
scripts/script.sh design
```

Designing for stubability — dependency injection, ports & adapters.

### `antipatterns`

```bash
scripts/script.sh antipatterns
```

Common stubbing mistakes and how to avoid over-mocking.

### `advanced`

```bash
scripts/script.sh advanced
```

Advanced techniques: partial stubs, conditional responses, stateful stubs.

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
