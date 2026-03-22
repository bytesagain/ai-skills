---
name: "fuzz"
version: "1.0.0"
description: "Fuzz testing reference — mutation fuzzing, coverage-guided fuzzing, and vulnerability discovery. Use when implementing fuzz tests, choosing fuzzing tools, or understanding fuzzing strategies for security testing."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [fuzz, fuzzing, testing, security, AFL, libFuzzer, mutation, coverage]
category: "devtools"
---

# Fuzz — Fuzz Testing Reference

Quick-reference for fuzz testing techniques, tools, and coverage-guided vulnerability discovery.

## When to Use

- Implementing fuzz tests for parsers, protocols, or APIs
- Choosing between AFL++, libFuzzer, or language-native fuzzers
- Understanding mutation vs generation-based fuzzing
- Setting up continuous fuzzing in CI/CD
- Finding crashes, hangs, and memory safety bugs

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of fuzz testing — history, types, and why it finds bugs others miss.

### `coverage`

```bash
scripts/script.sh coverage
```

Coverage-guided fuzzing — how instrumentation drives input evolution.

### `tools`

```bash
scripts/script.sh tools
```

Fuzzing tools — AFL++, libFuzzer, Honggfuzz, Go fuzzing, Jazzer.

### `harness`

```bash
scripts/script.sh harness
```

Writing fuzz harnesses — target functions, seed corpus, and dictionaries.

### `mutation`

```bash
scripts/script.sh mutation
```

Mutation strategies — bit flipping, arithmetic, splicing, and structure-aware.

### `triage`

```bash
scripts/script.sh triage
```

Crash triage — deduplication, minimization, root cause analysis.

### `continuous`

```bash
scripts/script.sh continuous
```

Continuous fuzzing — OSS-Fuzz, ClusterFuzz, CI integration.

### `targets`

```bash
scripts/script.sh targets
```

High-value fuzz targets — parsers, deserializers, network protocols.

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
| `FUZZ_DIR` | Data directory (default: ~/.fuzz/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
