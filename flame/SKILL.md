---
name: "flame"
version: "1.0.0"
description: "Flame graph profiling reference — CPU flame graphs, memory flamecharts, and performance visualization. Use when profiling application performance, reading flame graphs, or identifying hot paths in code."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [flame, flamegraph, profiling, performance, cpu, perf, brendangregg]
category: "devtools"
---

# Flame — Flame Graph Profiling Reference

Quick-reference for flame graph generation, interpretation, and performance profiling techniques.

## When to Use

- Generating CPU or memory flame graphs
- Reading and interpreting flame graph visualizations
- Profiling Node.js, Python, Java, Go, or system-level performance
- Identifying hot paths, bottlenecks, and unexpected CPU consumers
- Comparing before/after performance with differential flame graphs

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of flame graphs — origin, anatomy, and how to read them.

### `cpu`

```bash
scripts/script.sh cpu
```

CPU flame graph generation — perf, DTrace, and sampling profilers.

### `memory`

```bash
scripts/script.sh memory
```

Memory profiling — allocation flame graphs, heap snapshots.

### `nodejs`

```bash
scripts/script.sh nodejs
```

Node.js flame graphs — V8 profiler, 0x, clinic.js.

### `languages`

```bash
scripts/script.sh languages
```

Language-specific profiling — Python, Java, Go, Rust flame graphs.

### `tools`

```bash
scripts/script.sh tools
```

Flame graph tools — Brendan Gregg's tools, speedscope, Firefox Profiler.

### `differential`

```bash
scripts/script.sh differential
```

Differential flame graphs — comparing two profiles to find regressions.

### `interpret`

```bash
scripts/script.sh interpret
```

How to interpret flame graphs — common patterns, anti-patterns, and gotchas.

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
| `FLAME_DIR` | Data directory (default: ~/.flame/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
