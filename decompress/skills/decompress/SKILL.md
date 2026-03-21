---
name: "decompress"
version: "1.0.0"
description: "Decompression reference — archive formats, algorithms, streaming extraction, and corruption recovery. Use when extracting archives, choosing compression formats, or troubleshooting corrupt files."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [decompress, extract, archive, gzip, zstd, compression, atomic]
category: "atomic"
---

# Decompress — Archive & Compression Reference

Quick-reference skill for decompression algorithms, archive formats, and extraction techniques.

## When to Use

- Extracting tar, zip, 7z, rar, or other archive formats
- Choosing between compression algorithms (gzip, zstd, brotli, lz4)
- Handling corrupted or partial archives
- Streaming decompression for pipelines
- Understanding compression ratios and performance tradeoffs

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of compression and decompression — algorithms, formats, terminology.

### `formats`

```bash
scripts/script.sh formats
```

Archive format comparison — tar, zip, 7z, rar, and their features.

### `algorithms`

```bash
scripts/script.sh algorithms
```

Compression algorithms — gzip, bzip2, xz, zstd, lz4, brotli.

### `extract`

```bash
scripts/script.sh extract
```

Extraction commands for every common format.

### `streaming`

```bash
scripts/script.sh streaming
```

Streaming decompression — pipes, on-the-fly extraction, network transfers.

### `recovery`

```bash
scripts/script.sh recovery
```

Recovering data from corrupted or partial archives.

### `performance`

```bash
scripts/script.sh performance
```

Performance benchmarks — speed vs ratio tradeoffs by algorithm.

### `checklist`

```bash
scripts/script.sh checklist
```

Decompression safety checklist — zip bombs, path traversal, verification.

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
| `DECOMPRESS_DIR` | Data directory (default: ~/.decompress/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
