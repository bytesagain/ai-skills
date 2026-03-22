---
name: "pad"
version: "1.0.0"
description: "Data padding reference — cryptographic padding schemes (PKCS#7, OAEP, zero-padding), binary alignment, network protocol padding, and string formatting. Use when implementing or understanding padding in cryptography, protocols, or data alignment."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [pad, padding, cryptography, alignment, protocol, binary, atomic]
category: "atomic"
---

# Pad — Data Padding Reference

Quick-reference skill for padding schemes across cryptography, binary data, network protocols, and string formatting.

## When to Use

- Implementing cryptographic block cipher padding (PKCS#7, OAEP)
- Understanding padding oracle attacks and countermeasures
- Aligning binary data for hardware/protocol requirements
- Network protocol padding for fixed-size frames
- String padding for display formatting

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of padding — why it's needed, where it's used, categories of padding.

### `crypto`

```bash
scripts/script.sh crypto
```

Cryptographic padding: PKCS#5/7, ISO 10126, ANSI X.923, zero padding, bit padding.

### `oaep`

```bash
scripts/script.sh oaep
```

OAEP and asymmetric padding — RSA-OAEP, PSS, PKCS#1 v1.5 vulnerabilities.

### `oracle`

```bash
scripts/script.sh oracle
```

Padding oracle attacks — how they work, prevention, CBC vs authenticated encryption.

### `binary`

```bash
scripts/script.sh binary
```

Binary alignment padding — struct alignment, memory padding, cache line optimization.

### `network`

```bash
scripts/script.sh network
```

Network protocol padding — TLS record padding, IP options, Ethernet frame padding.

### `string`

```bash
scripts/script.sh string
```

String padding techniques — left/right pad, zero-fill, fixed-width formatting.

### `audio`

```bash
scripts/script.sh audio
```

Audio and signal padding — zero-padding for FFT, overlap-add, sample alignment.

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
| `PAD_DIR` | Data directory (default: ~/.pad/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
