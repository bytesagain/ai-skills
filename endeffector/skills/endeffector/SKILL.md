---
name: "endeffector"
version: "1.0.0"
description: "End effector design reference — tool types, mounting standards, TCP calibration, and payload sizing. Use when selecting robot end-effectors, designing custom tooling, or configuring tool center points."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [end-effector, robotics, tooling, tcp, robot-arm, industrial]
category: "industrial"
---

# End Effector — Robot End Effector Reference

Quick-reference for robot end-effector types, mounting standards, tool center point calibration, and custom tooling design.

## When to Use

- Selecting an end-effector for a robot application
- Designing custom tooling for specific parts
- Calibrating tool center points (TCP)
- Understanding ISO flange standards and mounting
- Evaluating tool changers for multi-tool applications

## Commands

### `intro`

```bash
scripts/script.sh intro
```

End effector fundamentals — definition, categories, selection criteria.

### `types`

```bash
scripts/script.sh types
```

End effector types: grippers, welding torches, spray guns, spindles, sensors.

### `flanges`

```bash
scripts/script.sh flanges
```

ISO flange standards, bolt patterns, and robot-to-tool mounting interfaces.

### `tcp`

```bash
scripts/script.sh tcp
```

Tool Center Point calibration methods — 4-point, 6-point, external measurement.

### `changers`

```bash
scripts/script.sh changers
```

Automatic tool changers — types, locking mechanisms, utility pass-through.

### `design`

```bash
scripts/script.sh design
```

Custom end effector design guidelines — weight, stiffness, cable routing.

### `payload`

```bash
scripts/script.sh payload
```

Payload calculation — tool weight, workpiece mass, moment of inertia.

### `checklist`

```bash
scripts/script.sh checklist
```

End effector selection and commissioning checklist.

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
| `ENDEFFECTOR_DIR` | Data directory (default: ~/.endeffector/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
