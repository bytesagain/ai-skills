---
name: "kanban"
version: "1.0.0"
description: "Kanban system reference — board design, WIP limits, pull signals, and flow metrics. Use when implementing kanban boards, managing work-in-progress, or optimizing workflow."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [kanban, agile, workflow, wip, pull-system, industrial]
category: "industrial"
---

# Kanban — Kanban System Reference

Quick-reference skill for kanban board design, WIP limits, pull-based workflow, and flow optimization.

## When to Use

- Designing a kanban board for production or software teams
- Setting and adjusting WIP limits
- Measuring flow metrics (lead time, throughput, CFD)
- Transitioning from push to pull system
- Troubleshooting bottlenecks in workflow

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Kanban origins, core principles, and pull system fundamentals.

### `board`

```bash
scripts/script.sh board
```

Board design patterns — columns, swimlanes, card design, physical vs digital.

### `wip`

```bash
scripts/script.sh wip
```

WIP limits — how to set, adjust, and enforce work-in-progress constraints.

### `metrics`

```bash
scripts/script.sh metrics
```

Flow metrics: lead time, cycle time, throughput, cumulative flow diagram.

### `signals`

```bash
scripts/script.sh signals
```

Pull signals — card-based, bin-based, electronic kanban, and replenishment triggers.

### `practices`

```bash
scripts/script.sh practices
```

Core practices: visualize work, limit WIP, manage flow, make policies explicit.

### `examples`

```bash
scripts/script.sh examples
```

Kanban implementation examples in manufacturing and software.

### `checklist`

```bash
scripts/script.sh checklist
```

Kanban readiness and health assessment checklist.

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
| `KANBAN_DIR` | Data directory (default: ~/.kanban/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
