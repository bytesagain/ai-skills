---
name: "sorter"
version: "1.0.0"
description: "Sorting algorithm and system reference — comparison sorts, distribution sorts, parallel sorting, and industrial sortation. Use when choosing sorting strategies, understanding algorithmic complexity, or designing physical sortation systems."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [sorter, sorting, algorithm, logistics, warehouse, sortation]
category: "logistics"
---

# Sorter — Sorting Reference

Quick-reference skill for sorting algorithms, complexity analysis, and industrial sortation systems.

## When to Use

- Choosing the right sorting algorithm for a dataset
- Understanding time/space complexity of sorting methods
- Designing physical sortation systems for warehouses
- Optimizing sort performance for large-scale data processing
- Comparing stable vs unstable sorts for specific use cases

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of sorting — classification, stability, and when to use what.

### `comparison`

```bash
scripts/script.sh comparison
```

Comparison-based sorts — quicksort, mergesort, heapsort, timsort.

### `distribution`

```bash
scripts/script.sh distribution
```

Distribution sorts — counting sort, radix sort, bucket sort.

### `simple`

```bash
scripts/script.sh simple
```

Simple sorts — insertion, selection, bubble, and when they actually win.

### `parallel`

```bash
scripts/script.sh parallel
```

Parallel and external sorting — merge sort for disk, MapReduce, GPU sorts.

### `choosing`

```bash
scripts/script.sh choosing
```

Decision guide — which sort for which situation, with benchmarks.

### `physical`

```bash
scripts/script.sh physical
```

Physical sortation systems — warehouse sorters, postal sorting, and throughput.

### `tricks`

```bash
scripts/script.sh tricks
```

Sorting tricks — partial sorts, nth element, stability hacks, presorted data.

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
| `SORTER_DIR` | Data directory (default: ~/.sorter/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
