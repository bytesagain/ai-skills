---
name: "interpolate"
version: "1.0.0"
description: "Data interpolation reference — linear, polynomial, spline, and spatial interpolation methods. Use when estimating values between known data points, filling gaps in time series, or performing spatial interpolation."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [interpolate, interpolation, spline, linear, polynomial, spatial, data]
category: "atomic"
---

# Interpolate — Data Interpolation Reference

Quick-reference for interpolation methods, formulas, and choosing the right technique for your data.

## When to Use

- Estimating values between known data points
- Filling gaps in time series data
- Upsampling or resampling signals and images
- Spatial interpolation (mapping, GIS, weather)
- Understanding interpolation vs extrapolation trade-offs

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of interpolation — what it is, when to use it, and key concepts.

### `linear`

```bash
scripts/script.sh linear
```

Linear interpolation — formula, examples, and piecewise linear methods.

### `polynomial`

```bash
scripts/script.sh polynomial
```

Polynomial interpolation — Lagrange, Newton, and Runge's phenomenon.

### `spline`

```bash
scripts/script.sh spline
```

Spline interpolation — cubic splines, B-splines, and natural splines.

### `spatial`

```bash
scripts/script.sh spatial
```

Spatial interpolation — IDW, kriging, and natural neighbor methods.

### `timeseries`

```bash
scripts/script.sh timeseries
```

Time series interpolation — gap filling, resampling, and alignment.

### `multidim`

```bash
scripts/script.sh multidim
```

Multi-dimensional interpolation — bilinear, bicubic, and trilinear.

### `choosing`

```bash
scripts/script.sh choosing
```

Choosing the right method — decision guide based on data characteristics.

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
| `INTERPOLATE_DIR` | Data directory (default: ~/.interpolate/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
