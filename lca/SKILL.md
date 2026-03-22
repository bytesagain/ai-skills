---
name: "lca"
version: "1.0.0"
description: "Life Cycle Assessment reference — ISO 14040/14044 methodology, impact categories, and environmental footprint analysis. Use when conducting LCA studies, comparing product environmental impacts, or understanding cradle-to-grave analysis."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [lca, lifecycle, assessment, ISO14040, environmental, carbon-footprint, cradle-to-grave]
category: "energy"
---

# LCA — Life Cycle Assessment Reference

Quick-reference for life cycle assessment methodology, impact categories, and environmental footprint analysis.

## When to Use

- Conducting an LCA study following ISO 14040/14044
- Comparing environmental impacts of product alternatives
- Understanding impact categories (GWP, acidification, eutrophication)
- Building life cycle inventories (LCI) with database sources
- Interpreting LCA results for decision-making

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of LCA — four phases, standards, and applications.

### `phases`

```bash
scripts/script.sh phases
```

LCA phases — goal/scope, inventory, impact assessment, interpretation.

### `impacts`

```bash
scripts/script.sh impacts
```

Impact categories — climate change, acidification, eutrophication, toxicity.

### `inventory`

```bash
scripts/script.sh inventory
```

Life Cycle Inventory (LCI) — data collection, databases, and allocation.

### `boundaries`

```bash
scripts/script.sh boundaries
```

System boundaries — cradle-to-gate, cradle-to-grave, gate-to-gate.

### `tools`

```bash
scripts/script.sh tools
```

LCA software and databases — openLCA, SimaPro, ecoinvent, GaBi.

### `examples`

```bash
scripts/script.sh examples
```

LCA examples — product comparisons and typical results.

### `pitfalls`

```bash
scripts/script.sh pitfalls
```

Common LCA pitfalls — boundary issues, data quality, and misinterpretation.

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
| `LCA_DIR` | Data directory (default: ~/.lca/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
