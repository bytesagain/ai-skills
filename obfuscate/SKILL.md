---
name: "obfuscate"
version: "1.0.0"
description: "Code obfuscation reference — JavaScript/bytecode obfuscation techniques, control flow flattening, string encryption, anti-debugging, and reverse engineering countermeasures. Use when protecting intellectual property in client-side code."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [obfuscate, obfuscation, security, javascript, protection, reverse-engineering, devtools]
category: "devtools"
---

# Obfuscate — Code Obfuscation Reference

Quick-reference skill for code obfuscation techniques, protection strategies, and reverse engineering countermeasures.

## When to Use

- Protecting client-side JavaScript intellectual property
- Understanding obfuscation techniques and their tradeoffs
- Implementing anti-debugging and anti-tampering measures
- Evaluating obfuscation tools and their effectiveness
- Understanding the limitations of code obfuscation

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of obfuscation — goals, threat model, obfuscation vs encryption.

### `techniques`

```bash
scripts/script.sh techniques
```

Core techniques: renaming, dead code injection, string encoding, control flow flattening.

### `controlflow`

```bash
scripts/script.sh controlflow
```

Control flow obfuscation — flattening, opaque predicates, dispatcher loops.

### `strings`

```bash
scripts/script.sh strings
```

String protection — encoding, encryption, runtime decoding, string array rotation.

### `antidebug`

```bash
scripts/script.sh antidebug
```

Anti-debugging techniques — debugger detection, timing checks, DevTools traps.

### `tools`

```bash
scripts/script.sh tools
```

Obfuscation tools: javascript-obfuscator, JScrambler, Webpack obfuscator plugins.

### `wasm`

```bash
scripts/script.sh wasm
```

WebAssembly as obfuscation — compiling logic to Wasm for protection.

### `limits`

```bash
scripts/script.sh limits
```

Limitations — what obfuscation cannot protect, cost-benefit analysis, legal aspects.

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
| `OBFUSCATE_DIR` | Data directory (default: ~/.obfuscate/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
