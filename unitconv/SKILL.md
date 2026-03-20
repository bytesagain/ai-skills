---
name: UnitConv
description: "Convert units for length, weight, temperature, data, and speed. Use when switching measurement systems, sizing storage, or adjusting recipe quantities."
version: "3.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["converter","units","metric","imperial","temperature","length","weight","utility"]
categories: ["Utility", "Productivity"]
---

# UnitConv — Unit Converter

Convert between units for length, weight, temperature, speed, data storage, and time. Uses `awk` for precise math.

## Commands

| Command | Description |
|---------|-------------|
| `length <value> <from> <to>` | Convert length: m, cm, mm, km, in, ft, yd, mi |
| `weight <value> <from> <to>` | Convert weight: g, mg, kg, lb, oz, ton |
| `temp <value> <from> <to>` | Convert temperature: C, F, K |
| `speed <value> <from> <to>` | Convert speed: ms, kmh, mph, knots, fts |
| `data <value> <from> <to>` | Convert data: B, KB, MB, GB, TB, PB |
| `time <value> <from> <to>` | Convert time: s, m, h, d, w, mo, y |

## Examples

```bash
# Length
unitconv length 100 cm in        # → 39.3701 in
unitconv length 5 mi km          # → 8.04672 km

# Weight
unitconv weight 150 lb kg        # → 68.0389 kg

# Temperature
unitconv temp 100 C F            # → 212°F
unitconv temp 0 K C              # → -273.15°C

# Speed
unitconv speed 60 mph kmh        # → 96.5606 kmh
unitconv speed 100 kmh knots     # → 53.9957 knots

# Data storage
unitconv data 1024 MB GB         # → 1 GB
unitconv data 2 TB GB            # → 2048 GB

# Time
unitconv time 3600 s h           # → 1 h
unitconv time 7 d h              # → 168 h
```

## Supported Units

- **Length:** m (meter), cm, mm, km, in (inch), ft (foot), yd (yard), mi (mile)
- **Weight:** g (gram), mg, kg, lb (pound), oz (ounce), ton
- **Temperature:** C (Celsius), F (Fahrenheit), K (Kelvin)
- **Speed:** ms (m/s), kmh (km/h), mph, knots, fts (ft/s)
- **Data:** B (byte), KB, MB, GB, TB, PB
- **Time:** s (second), m (minute), h (hour), d (day), w (week), mo (month ~30d), y (year ~365d)
