---
name: "fertigation"
version: "1.0.0"
description: "Fertigation reference — injecting fertilizers through irrigation systems, nutrient scheduling, injection methods, and crop-specific programs. Use when designing fertigation systems, calculating nutrient rates, or managing drip/sprinkler fertilizer delivery."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [fertigation, irrigation, fertilizer, agriculture, nutrients, drip]
category: "agriculture"
---

# Fertigation — Fertigation Systems Reference

Quick-reference skill for fertigation techniques, nutrient management, and injection system design.

## When to Use

- Designing fertigation systems for drip or sprinkler irrigation
- Calculating fertilizer injection rates and concentrations
- Selecting injection equipment (Venturi, positive displacement, proportional)
- Planning nutrient schedules for different crop growth stages
- Troubleshooting fertigation uniformity and compatibility issues

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of fertigation — principles, advantages, and system components.

### `methods`

```bash
scripts/script.sh methods
```

Injection methods — Venturi, diaphragm pump, piston pump, proportional dosing.

### `nutrients`

```bash
scripts/script.sh nutrients
```

Fertilizer types for fertigation — solubility, compatibility, and stock solutions.

### `scheduling`

```bash
scripts/script.sh scheduling
```

Nutrient scheduling by crop growth stage — vegetative, flowering, fruiting.

### `calculations`

```bash
scripts/script.sh calculations
```

Injection rate calculations — ppm, EC targets, dilution ratios, flow rates.

### `drip`

```bash
scripts/script.sh drip
```

Drip fertigation specifics — emitter clogging prevention, acid injection, flushing.

### `monitoring`

```bash
scripts/script.sh monitoring
```

Monitoring fertigation — EC, pH, runoff analysis, sensor placement.

### `problems`

```bash
scripts/script.sh problems
```

Common fertigation problems — precipitates, uneven distribution, salt buildup.

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
| `FERTIGATION_DIR` | Data directory (default: ~/.fertigation/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
