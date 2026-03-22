---
name: "lithium"
version: "1.0.0"
description: "Lithium battery technology reference — cell chemistries, charging profiles, degradation mechanisms, BMS fundamentals, and safety. Use when working with Li-ion battery design, selection, or management."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [lithium, battery, li-ion, energy-storage, bms, charging, energy]
category: "energy"
---

# Lithium — Lithium Battery Technology Reference

Quick-reference skill for lithium-ion battery chemistries, charging protocols, degradation science, and safety practices.

## When to Use

- Selecting a lithium cell chemistry for an application
- Understanding charge/discharge profiles and C-rates
- Diagnosing battery degradation and capacity fade
- Designing or evaluating a Battery Management System (BMS)
- Ensuring lithium battery safety compliance

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of lithium-ion technology — history, working principle, key parameters.

### `chemistries`

```bash
scripts/script.sh chemistries
```

Cell chemistries compared: NMC, LFP, NCA, LCO, LMO, LTO, sodium-ion.

### `charging`

```bash
scripts/script.sh charging
```

Charging protocols: CC-CV, step charging, fast charging, preconditioning.

### `degradation`

```bash
scripts/script.sh degradation
```

Degradation mechanisms: SEI growth, lithium plating, cathode cracking, calendar aging.

### `bms`

```bash
scripts/script.sh bms
```

Battery Management System fundamentals — cell balancing, SOC estimation, protection.

### `safety`

```bash
scripts/script.sh safety
```

Safety hazards, thermal runaway, UN38.3 testing, transport regulations.

### `sizing`

```bash
scripts/script.sh sizing
```

Battery pack sizing — series/parallel, energy vs power cells, thermal design.

### `specs`

```bash
scripts/script.sh specs
```

Key specifications table and how to read a battery datasheet.

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
| `LITHIUM_DIR` | Data directory (default: ~/.lithium/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
