---
version: "2.0.0"
name: Crypto Tax Calculator
description: "Calculate crypto capital gains taxes with FIFO/LIFO/average cost methods, multi-country tax law support, and HTML report generation. Use when you need crypto tax calc capabilities. Triggers on: crypto tax calc."
author: BytesAgain
---

# Crypto Tax Calculator 📊

A complete cryptocurrency tax calculation engine. Import your trades, select your jurisdiction, and generate professional tax reports.

## Workflow Overview

```
[Import CSV] → [Parse Trades] → [Match Cost Basis] → [Calculate Gains] → [Apply Tax Rules] → [Generate Report]
     ↓              ↓                  ↓                    ↓                   ↓                    ↓
  Validate      Normalize         FIFO/LIFO/AVG        Short vs Long       US/UK/AU/CN         HTML + CSV
  Format        Currencies        Cost Matching         Term Gains          Rate Tables          Tax Report
```

## Step 1: Prepare Your Data

Your CSV must have these columns (order doesn't matter):

| Column | Required | Format | Example |
|--------|----------|--------|---------|
| date | ✅ | YYYY-MM-DD HH:MM:SS | 2024-03-15 14:30:00 |
| type | ✅ | buy/sell/swap/transfer | buy |
| asset | ✅ | Symbol | BTC |
| amount | ✅ | Decimal number | 0.5 |
| price_usd | ✅ | USD value per unit | 65000.00 |
| fee_usd | ❌ | Fee in USD | 2.50 |
| exchange | ❌ | Exchange name | Binance |
| tx_hash | ❌ | Transaction hash | 0xabc... |

## Step 2: Choose Your Method

```bash
# FIFO — First In, First Out (most common, required in some jurisdictions)
bash scripts/crypto-tax-calc.sh calculate --input trades.csv --method fifo --country US

# LIFO — Last In, First Out (can minimize taxes in rising markets)
bash scripts/crypto-tax-calc.sh calculate --input trades.csv --method lifo --country US

# Average Cost — Weighted average (required in UK, simpler calculation)
bash scripts/crypto-tax-calc.sh calculate --input trades.csv --method average --country UK
```

## Step 3: Select Jurisdiction

### 🇺🇸 United States
- Short-term gains (<1 year): Taxed as ordinary income (10%-37%)
- Long-term gains (>1 year): 0%, 15%, or 20%
- Wash sale rules: Currently not enforced for crypto (may change)
- Form 8949 generation supported

### 🇬🇧 United Kingdom
- Capital Gains Tax: 10% (basic) / 20% (higher rate)
- Annual exempt amount: £6,000 (2024/25)
- Must use share pooling (average cost)
- HMRC-compatible report format

### 🇦🇺 Australia
- CGT discount: 50% for assets held >12 months
- Marginal tax rates apply (19%-45%)
- Personal use asset exemption <$10,000
- ATO-compatible output

### 🇨🇳 China
- Individual income tax: 20% on gains
- Currently ambiguous regulation
- Report provides gain calculations for reference

## Step 4: Generate Report

The tool outputs:
- **HTML Report** — Visual summary with charts, tables, per-asset breakdown
- **CSV Export** — Machine-readable gain/loss per trade
- **Summary JSON** — Totals for integration with other tools

## Full Command Reference

```bash
# Calculate taxes
bash scripts/crypto-tax-calc.sh calculate --input FILE --method METHOD --country CODE [--year YEAR]

# Validate CSV format
bash scripts/crypto-tax-calc.sh validate --input FILE

# Show summary only (no report file)
bash scripts/crypto-tax-calc.sh summary --input FILE --method METHOD

# Merge multiple exchange CSVs
bash scripts/crypto-tax-calc.sh merge --inputs "file1.csv,file2.csv" --output merged.csv

# Compare methods side-by-side
bash scripts/crypto-tax-calc.sh compare --input FILE --country CODE
```

## Important Disclaimers

⚠️ This tool is for **informational purposes only**. It is NOT tax advice. Consult a qualified tax professional for your specific situation.

⚠️ Tax laws change frequently. Always verify current rates and rules with your local tax authority.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Commands

- `import` — Import
- `calculate` — Calculate
- `add` — Add
- `report` — Report
- `compare-methods` — Compare Methods
