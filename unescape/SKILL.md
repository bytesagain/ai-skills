---
name: "unescape"
version: "1.0.0"
description: "String unescaping reference — decode escaped sequences in HTML entities, URL encoding, JSON strings, regex, and shell. Use when handling double-escaped data, decoding user input, or understanding escape sequence semantics."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [unescape, decode, html-entities, url-encoding, escape-sequence, sanitize]
category: "atomic"
---

# Unescape — String Unescaping Reference

Quick-reference skill for unescaping — decoding escaped characters back to their original form.

## When to Use

- Decoding HTML entities (&amp; → &)
- URL decoding (%20 → space)
- Unescaping JSON strings (\\n → newline)
- Handling double-escaped data in pipelines
- Understanding escape sequences across contexts (shell, regex, SQL)

## Commands

### `intro`

```bash
scripts/script.sh intro
```

What escaping/unescaping is, why it exists, the escape-unescape cycle.

### `html`

```bash
scripts/script.sh html
```

HTML entity unescaping — named entities, numeric, hex, XSS considerations.

### `url`

```bash
scripts/script.sh url
```

URL decoding — percent encoding, encodeURIComponent, plus-as-space.

### `json`

```bash
scripts/script.sh json
```

JSON string unescaping — backslash sequences, Unicode escapes, edge cases.

### `shell`

```bash
scripts/script.sh shell
```

Shell unescaping — single quotes, double quotes, ANSI-C quoting, here-docs.

### `regex`

```bash
scripts/script.sh regex
```

Regex unescaping — metacharacters, character classes, raw strings.

### `sql`

```bash
scripts/script.sh sql
```

SQL unescaping — single quote doubling, backslash escapes, parameterized queries.

### `double`

```bash
scripts/script.sh double
```

Double-escaping problems — diagnosis, prevention, and layer-by-layer debugging.

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
