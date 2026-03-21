---
name: "gripper"
version: "1.0.0"
description: "Robot gripper reference — jaw types, force calculation, pneumatic vs electric, and end-effector selection. Use when designing gripping systems, selecting actuators, or sizing grippers for robotic applications."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [gripper, robotics, end-effector, pneumatic, actuator, industrial]
category: "industrial"
---

# Gripper — Robot Gripper Reference

Quick-reference skill for gripper types, force calculations, actuator selection, and end-effector design.

## When to Use

- Selecting a gripper type for a robot application
- Calculating required gripping force for a payload
- Choosing between pneumatic, electric, and vacuum grippers
- Designing custom jaw geometry for specific parts
- Troubleshooting grip failures in production

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Gripper fundamentals — types, actuation methods, key specifications.

### `types`

```bash
scripts/script.sh types
```

Gripper types: parallel, angular, three-jaw, vacuum, magnetic, soft, adaptive.

### `force`

```bash
scripts/script.sh force
```

Grip force calculation — formulas, safety factors, friction coefficients.

### `pneumatic`

```bash
scripts/script.sh pneumatic
```

Pneumatic grippers — cylinders, valves, air prep, circuit design.

### `electric`

```bash
scripts/script.sh electric
```

Electric grippers — servo, stepper, advantages over pneumatic.

### `vacuum`

```bash
scripts/script.sh vacuum
```

Vacuum grippers — suction cups, venturi generators, cup selection.

### `applications`

```bash
scripts/script.sh applications
```

Gripper applications by industry: automotive, electronics, food, pharma.

### `checklist`

```bash
scripts/script.sh checklist
```

Gripper selection and commissioning checklist.

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
| `GRIPPER_DIR` | Data directory (default: ~/.gripper/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
