---
name: "escape"
version: "1.0.0"
description: "String escaping reference — HTML, URL, SQL, shell, regex, JSON, and Unicode escaping. Use when sanitizing user input, preventing injection attacks, or encoding data for different contexts."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [escape, encoding, sanitize, injection, xss, sql, shell, atomic]
category: "atomic"
---

# Escape — String Escaping Reference

Quick-reference skill for escaping and encoding data across contexts.

## When to Use

- Sanitizing user input for HTML (preventing XSS)
- Encoding URL parameters and path segments
- Preventing SQL injection with parameterized queries
- Safely constructing shell commands with arguments
- Understanding escape sequences across contexts

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of escaping — why context matters, the injection problem.

### `html`

```bash
scripts/script.sh html
```

HTML escaping — entity encoding, attribute contexts, and XSS prevention.

### `url`

```bash
scripts/script.sh url
```

URL encoding — percent encoding, path vs query, reserved characters.

### `sql`

```bash
scripts/script.sh sql
```

SQL escaping — parameterized queries, prepared statements, ORM safety.

### `shell`

```bash
scripts/script.sh shell
```

Shell escaping — quoting rules, command injection, safe subprocess calls.

### `regex`

```bash
scripts/script.sh regex
```

Regex escaping — metacharacters, literal matching, language-specific functions.

### `json`

```bash
scripts/script.sh json
```

JSON escaping — string encoding, Unicode escapes, edge cases.

### `unicode`

```bash
scripts/script.sh unicode
```

Unicode escaping — UTF-8, surrogate pairs, normalization, homoglyph attacks.

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
