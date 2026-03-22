---
name: "flatten"
version: "1.0.0"
description: "Data flatten reference — nested-to-flat conversion, JSON/array flattening, dot-notation keys, depth control. Use when transforming hierarchical data into flat structures or normalizing nested records."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [flatten, data, nested, json, array, transform, normalize, atomic]
category: "atomic"
---

# Flatten — Data Flattening Reference

Quick-reference skill for flattening nested data structures into flat key-value pairs or single-level arrays.

## When to Use

- Converting deeply nested JSON into flat dot-notation objects
- Flattening multi-dimensional arrays into single-level lists
- Normalizing hierarchical API responses for tabular storage
- Preparing nested data for CSV export or database insertion
- Controlling flatten depth for partial flattening

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of data flattening — what it means, why it matters, core concepts.

### `json`

```bash
scripts/script.sh json
```

JSON object flattening — dot-notation keys, bracket notation, separator options.

### `array`

```bash
scripts/script.sh array
```

Array flattening — multi-dimensional to single-level, depth-limited flatten.

### `algorithms`

```bash
scripts/script.sh algorithms
```

Flattening algorithms — recursive vs iterative, stack-based, BFS approaches.

### `languages`

```bash
scripts/script.sh languages
```

Flatten implementations across languages — JavaScript, Python, Go, Bash, SQL.

### `edgecases`

```bash
scripts/script.sh edgecases
```

Edge cases — circular references, null values, mixed types, empty containers.

### `unflatten`

```bash
scripts/script.sh unflatten
```

Reverse operation — reconstructing nested structures from flat key-value pairs.

### `patterns`

```bash
scripts/script.sh patterns
```

Real-world patterns — ETL pipelines, log normalization, config merging.

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
| `FLATTEN_DIR` | Data directory (default: ~/.flatten/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
