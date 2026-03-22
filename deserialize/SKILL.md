---
name: "deserialize"
version: "1.0.0"
description: "Deserialization reference — binary formats, schema evolution, security risks, and cross-language patterns. Use when parsing binary protocols, handling untrusted data, or choosing serialization formats."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [deserialize, serialization, binary, protobuf, msgpack, security, atomic]
category: "atomic"
---

# Deserialize — Deserialization Reference

Quick-reference skill for deserialization formats, security, and cross-language data exchange.

## When to Use

- Choosing a serialization format (JSON, Protobuf, MessagePack, Avro)
- Handling untrusted deserialization safely
- Implementing schema evolution and backward compatibility
- Debugging binary format parsing issues
- Understanding serialization performance tradeoffs

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of serialization/deserialization — concepts, formats, and tradeoffs.

### `formats`

```bash
scripts/script.sh formats
```

Format comparison: JSON, Protobuf, MessagePack, Avro, CBOR, FlatBuffers.

### `security`

```bash
scripts/script.sh security
```

Deserialization security — RCE vulnerabilities, safe patterns, and CVE examples.

### `schemas`

```bash
scripts/script.sh schemas
```

Schema evolution — backward/forward compatibility, field numbering, default values.

### `binary`

```bash
scripts/script.sh binary
```

Binary format internals — wire types, varint encoding, endianness, TLV.

### `languages`

```bash
scripts/script.sh languages
```

Language-specific deserialization: Python pickle, Java ObjectInputStream, JSON parsers.

### `performance`

```bash
scripts/script.sh performance
```

Performance benchmarks and optimization — zero-copy, arena allocation, streaming.

### `migration`

```bash
scripts/script.sh migration
```

Data migration patterns — versioned schemas, envelope pattern, polyglot persistence.

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
