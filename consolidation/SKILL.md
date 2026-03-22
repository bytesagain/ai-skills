---
name: "consolidation"
version: "1.0.0"
description: "Freight consolidation reference — LCL groupage, milk runs, cross-docking, and shipment merging strategies. Use when optimizing shipping costs, planning consolidated loads, or reducing freight spend."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [consolidation, freight, shipping, logistics, lcl, groupage, cross-dock]
category: "logistics"
---

# Consolidation — Freight Consolidation Reference

Quick-reference skill for shipment consolidation strategies, cost optimization, and logistics planning.

## When to Use

- Combining multiple small shipments into full container loads
- Planning LCL (Less than Container Load) groupage
- Designing cross-dock and merge-in-transit operations
- Calculating consolidation savings vs direct shipping
- Implementing milk run and zone-skip strategies

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of freight consolidation — concepts, types, and economics.

### `lcl`

```bash
scripts/script.sh lcl
```

LCL groupage — how ocean freight consolidation works from CFS to CFS.

### `crossdock`

```bash
scripts/script.sh crossdock
```

Cross-docking operations — receive, sort, and ship without storage.

### `milkrun`

```bash
scripts/script.sh milkrun
```

Milk run pickup routes — collecting from multiple suppliers in one trip.

### `savings`

```bash
scripts/script.sh savings
```

Consolidation economics — cost calculations and break-even analysis.

### `methods`

```bash
scripts/script.sh methods
```

Consolidation methods: zone-skip, pool distribution, merge-in-transit.

### `planning`

```bash
scripts/script.sh planning
```

Consolidation planning — order windows, weight breaks, and timing.

### `risks`

```bash
scripts/script.sh risks
```

Consolidation risks and mitigation: delays, damage, customs complications.

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
| `CONSOLIDATION_DIR` | Data directory (default: ~/.consolidation/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
