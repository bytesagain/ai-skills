---
name: "Gear Ratio & Mechanical Drive Calculator"
description: "Use when calculating gear ratios, converting RPM between shafts, computing torque output, analyzing drivetrain configurations, or selecting motors for mechanical systems."
version: "2.0.1"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["gear", "mechanical", "engineering", "torque", "drivetrain", "motor", "calculator"]
---

# Gear Ratio & Mechanical Drive Calculator

Calculate gear ratios, convert RPM, compute torque, analyze multi-stage drivetrains, and get motor selection guidance for mechanical systems.

## Commands

### ratio
Calculate gear ratio from tooth counts or diameters.
```bash
bash scripts/script.sh ratio 20 60
```

### speed
Convert RPM through a gear ratio.
```bash
bash scripts/script.sh speed 1800 3.5
```

### torque
Compute output torque given input torque and gear ratio.
```bash
bash scripts/script.sh torque 10 3.5 0.95
```

### drivetrain
Analyze a multi-stage gear train.
```bash
bash scripts/script.sh drivetrain "20:60,15:45,18:72"
```

### motor-select
Motor selection helper based on load requirements.
```bash
bash scripts/script.sh motor-select 50 300
```

### help
Show all commands.
```bash
bash scripts/script.sh help
```

## Output
- Gear ratios with speed/torque multipliers
- Multi-stage drivetrain analysis
- Motor specification recommendations

## Feedback
https://bytesagain.com/feedback/
Powered by BytesAgain | bytesagain.com
