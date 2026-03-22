---
name: "mixin"
version: "1.0.0"
description: "Mixin pattern reference — composition-over-inheritance strategies, trait systems, multiple inheritance alternatives, and mixin implementation across languages. Use when designing reusable behavior sharing without deep class hierarchies."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [mixin, composition, inheritance, traits, oop, design-pattern, devtools]
category: "devtools"
---

# Mixin — Mixin Pattern Reference

Quick-reference skill for mixin patterns, trait systems, and composition-based code reuse strategies.

## When to Use

- Sharing behavior across classes without inheritance hierarchies
- Implementing cross-cutting concerns (serialization, logging, comparison)
- Understanding trait vs mixin vs interface distinctions
- Resolving multiple inheritance conflicts (diamond problem)
- Designing composable APIs and plugin systems

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of mixin concept — definition, history, composition vs inheritance.

### `javascript`

```bash
scripts/script.sh javascript
```

JavaScript mixin patterns — Object.assign, class expression mixins, Symbol-based.

### `python`

```bash
scripts/script.sh python
```

Python mixins and MRO — cooperative multiple inheritance, super() chain.

### `traits`

```bash
scripts/script.sh traits
```

Trait systems: Rust traits, Scala traits, PHP traits — semantics and conflict resolution.

### `diamond`

```bash
scripts/script.sh diamond
```

Diamond problem — multiple inheritance conflicts and resolution strategies.

### `functional`

```bash
scripts/script.sh functional
```

Functional mixins — higher-order functions, stampit, compose patterns.

### `realworld`

```bash
scripts/script.sh realworld
```

Real-world mixin examples — Serializable, Comparable, Observable, EventEmitter.

### `antipatterns`

```bash
scripts/script.sh antipatterns
```

Mixin anti-patterns and when NOT to use mixins.

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
| `MIXIN_DIR` | Data directory (default: ~/.mixin/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
