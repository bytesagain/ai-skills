---
name: "unwrap"
version: "1.0.0"
description: "Unwrap operations reference — extracting values from Option, Result, Promise, and wrapper types. Use when handling nullable values, understanding Rust's unwrap/expect/? operator, or safely extracting values from monadic containers."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [unwrap, option, result, monad, nullable, error-handling, pattern-matching]
category: "atomic"
---

# Unwrap — Value Extraction Reference

Quick-reference skill for unwrapping — extracting values from Option, Result, Optional, and other wrapper types.

## When to Use

- Using Rust's unwrap, expect, unwrap_or, and ? operator
- Handling Swift optionals with if-let, guard-let, and nil coalescing
- Extracting values from Java/Kotlin Optional
- Understanding the monad unwrap pattern
- Choosing between safe and unsafe unwrapping strategies

## Commands

### `intro`

```bash
scripts/script.sh intro
```

What unwrapping is, why wrapper types exist, safe vs unsafe unwrapping.

### `rust`

```bash
scripts/script.sh rust
```

Rust unwrap — Option and Result methods, ? operator, expect, combinators.

### `swift`

```bash
scripts/script.sh swift
```

Swift optionals — if-let, guard-let, optional chaining, nil coalescing.

### `kotlin`

```bash
scripts/script.sh kotlin
```

Kotlin null safety — ?., !!, let, Elvis operator, smart casts.

### `typescript`

```bash
scripts/script.sh typescript
```

TypeScript — optional chaining, nullish coalescing, type guards, assertions.

### `functional`

```bash
scripts/script.sh functional
```

Monadic unwrapping — map, flatMap, fold, pattern matching.

### `antipatterns`

```bash
scripts/script.sh antipatterns
```

Unwrap anti-patterns: bare unwrap, swallowed errors, pyramid of doom.

### `strategies`

```bash
scripts/script.sh strategies
```

Safe unwrapping strategies: defaults, early return, combinators, validation.

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
