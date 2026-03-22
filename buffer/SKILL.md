---
name: "buffer"
version: "1.0.0"
description: "Memory buffer reference — allocation strategies, ring buffers, protocol buffers, zero-copy, overflow prevention. Use when designing data buffers, debugging memory issues, or optimizing I/O throughput."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [buffer, memory, allocation, ring-buffer, io, performance, devtools]
category: "devtools"
---

# Buffer — Memory Buffer & Data Buffering Reference

Quick-reference skill for memory buffer concepts, allocation strategies, common buffer patterns, and overflow prevention.

## When to Use

- Designing data buffers for streaming or I/O operations
- Debugging buffer overflow or underrun issues
- Choosing between buffer types (ring, double, protocol)
- Optimizing memory allocation and throughput
- Understanding zero-copy and DMA buffer patterns

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of buffers — what they are, why they matter, and core concepts.

### `types`

```bash
scripts/script.sh types
```

Buffer types — ring, double, circular, frame, protocol buffers.

### `allocation`

```bash
scripts/script.sh allocation
```

Memory allocation strategies — stack, heap, pool, slab, mmap.

### `overflow`

```bash
scripts/script.sh overflow
```

Buffer overflow — causes, prevention, security implications, safe coding.

### `io`

```bash
scripts/script.sh io
```

I/O buffering — line, block, unbuffered, zero-copy, scatter-gather.

### `patterns`

```bash
scripts/script.sh patterns
```

Common buffer patterns — producer-consumer, back-pressure, watermarks.

### `languages`

```bash
scripts/script.sh languages
```

Buffer APIs across languages — C, Python, Node.js, Go, Rust.

### `sizing`

```bash
scripts/script.sh sizing
```

Buffer sizing guide — how to calculate optimal buffer sizes.

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
| `BUFFER_DIR` | Data directory (default: ~/.buffer/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
