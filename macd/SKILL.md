---
name: "MACD — Moving Average Convergence Divergence"
description: "Calculate MACD from price data. Use when computing MACD/signal/histogram from a price series, spotting crossovers, reading momentum, or planning MACD-based entries."
version: "2.0.4"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["macd", "trading", "crypto", "stocks", "technical-analysis", "finance", "momentum"]
---

# MACD — Moving Average Convergence Divergence

Calculate MACD from price data. Compute EMA, MACD line, signal line, and histogram from a CSV or inline price series.

## Requirements
- bash 4+
- python3 (standard library only)

## Commands

### calculate
Calculate MACD from a comma-separated price series.
```bash
bash scripts/script.sh calculate "170.5,171.2,172.8,171.0,173.5,174.2,175.0,174.8,176.1,175.5,177.2,178.0,176.5,177.8,179.0,178.5,180.2,179.8,181.0,180.5,182.3,181.8,183.0,182.5,184.0,183.5"
```

### calculate-file
Calculate MACD from a CSV file (one price per line or column).
```bash
bash scripts/script.sh calculate-file prices.csv
```

### interpret
Interpret MACD, signal, and histogram values with trading signals.
```bash
bash scripts/script.sh interpret 1.25 0.80
```

### crossover
Explain crossover patterns and trading rules.
```bash
bash scripts/script.sh crossover
```

### histogram
MACD histogram analysis and momentum reading guide.
```bash
bash scripts/script.sh histogram
```

### strategies
MACD trading strategies with entry/exit rules.
```bash
bash scripts/script.sh strategies
```

### help
Show all commands.
```bash
bash scripts/script.sh help
```

## Output
- Computed MACD line, signal line, and histogram from real price data
- EMA values at each step
- Crossover and divergence signals
- Trading strategy frameworks

## Feedback
https://bytesagain.com/feedback/
Powered by BytesAgain | bytesagain.com
