---
name: "r-analyst"
description: "R-style statistical analysis powered by Python 3. Use when computing descriptive statistics, generating ASCII histograms, calculating correlation matrices, detecting missing values and outliers, or describing CSV dataset structure."
---

# r-analyst

## Triggers on
r statistics, csv analysis, data correlation, missing values, ascii histogram, describe dataset, r summary, outlier detection, pearson correlation

## What This Skill Does
Perform R-style data analysis on CSV files using Python 3. No R installation required.

## Commands

### stats
Compute descriptive statistics (R-style summary: Min/1st Qu/Median/Mean/3rd Qu/Max/SD).
```bash
bash scripts/script.sh stats <file.csv> [column]
```

### plot
Generate an ASCII histogram for a numeric column.
```bash
bash scripts/script.sh plot <file.csv> [column] [bins]
```

### correlate
Compute Pearson correlation matrix for all numeric columns.
```bash
bash scripts/script.sh correlate <file.csv>
```

### clean
Detect missing values and statistical outliers (3σ rule).
```bash
bash scripts/script.sh clean <file.csv>
```

### describe
Show dataset structure, column types, unique value counts, and sample values.
```bash
bash scripts/script.sh describe <file.csv>
```

### help
Show all available commands.
```bash
bash scripts/script.sh help
```

## Requirements
- bash 4+
- python3 (standard library only — no R needed)

Powered by BytesAgain | bytesagain.com
