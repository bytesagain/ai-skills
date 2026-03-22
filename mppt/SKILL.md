---
name: "mppt"
version: "1.0.0"
description: "Maximum Power Point Tracking reference — MPPT algorithms, converter topologies, PV curve analysis, and controller tuning. Use when designing or optimizing solar charge controllers and PV power systems."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [mppt, solar, photovoltaic, power-electronics, tracking, converter, energy]
category: "energy"
---

# MPPT — Maximum Power Point Tracking Reference

Quick-reference skill for MPPT algorithms, DC-DC converter topologies, and solar power optimization.

## When to Use

- Understanding I-V and P-V curves of PV panels
- Selecting MPPT algorithms (P&O, InC, fuzzy logic)
- Designing DC-DC converters for solar applications
- Tuning MPPT controller parameters
- Diagnosing partial shading and multi-peak issues

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of MPPT — why it's needed, PV characteristics, maximum power point concept.

### `algorithms`

```bash
scripts/script.sh algorithms
```

MPPT algorithms: Perturb & Observe, Incremental Conductance, constant voltage, fuzzy logic.

### `converters`

```bash
scripts/script.sh converters
```

DC-DC converter topologies for MPPT: buck, boost, buck-boost, SEPIC.

### `curves`

```bash
scripts/script.sh curves
```

PV I-V and P-V curves — shape factors, fill factor, effects of irradiance and temperature.

### `shading`

```bash
scripts/script.sh shading
```

Partial shading problems — multiple peaks, bypass diodes, global MPPT strategies.

### `tuning`

```bash
scripts/script.sh tuning
```

Controller tuning — step size, perturbation frequency, tracking speed vs stability.

### `hardware`

```bash
scripts/script.sh hardware
```

MPPT hardware design — microcontroller selection, current/voltage sensing, gate drivers.

### `efficiency`

```bash
scripts/script.sh efficiency
```

MPPT efficiency metrics, losses analysis, and real-world performance factors.

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
| `MPPT_DIR` | Data directory (default: ~/.mppt/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
