---
version: "2.0.0"
name: Arbitrage Finder
description: "Scan price differences across exchanges, score arbitrage opportunities, and track historical success rates. Use when you need arbitrage finder capabilities. Triggers on: arbitrage finder."
author: BytesAgain
---

# Arbitrage Finder 🔄

Discover cross-exchange arbitrage opportunities by scanning price differences, factoring in fees and transfer times, and scoring profitability.

## How It Works — Step by Step

### Step 1: Configure Exchanges

Set up the exchanges you want to monitor. The tool uses public ticker APIs (no API keys needed for price scanning).

```bash
bash scripts/arbitrage-finder.sh config \
  --exchanges "binance,okx,bybit,coinbase,kraken,kucoin"
```

### Step 2: Scan for Opportunities

Run a scan across all configured exchanges for a specific asset or all tracked assets:

```bash
# Scan specific pair
bash scripts/arbitrage-finder.sh scan --pair BTC/USDT

# Scan all tracked pairs
bash scripts/arbitrage-finder.sh scan --all

# Scan with minimum spread threshold
bash scripts/arbitrage-finder.sh scan --all --min-spread 0.5
```

### Step 3: Analyze an Opportunity

When a spread is found, analyze it with fees and timing factored in:

```bash
bash scripts/arbitrage-finder.sh analyze \
  --pair ETH/USDT \
  --buy-exchange binance \
  --sell-exchange coinbase \
  --amount 10000
```

This outputs:
- Buy price & total cost (including fees)
- Sell price & total revenue (minus fees)
- Network transfer fee and estimated time
- **Net profit/loss** after all costs
- **Opportunity score** (0-100)

### Step 4: Review History

Track past opportunities and their outcomes:

```bash
bash scripts/arbitrage-finder.sh history --days 7 --pair BTC/USDT
```

### Step 5: Generate Report

```bash
bash scripts/arbitrage-finder.sh report --days 30 --output arb-report.html
```

## Opportunity Scoring

Each opportunity is scored 0-100 based on:

| Factor | Weight | How It's Measured |
|--------|--------|------------------|
| Net Spread | 30% | Spread after ALL fees |
| Liquidity | 25% | Can you fill the order at quoted price? |
| Transfer Speed | 20% | Faster = less price risk |
| Historical Success | 15% | Has this route been profitable before? |
| Volatility Risk | 10% | Price change risk during transfer |

### Score Interpretation

- **80-100** 🟢 Strong opportunity — likely profitable
- **60-79** 🟡 Moderate — profitable with good execution
- **40-59** 🟠 Risky — tight margins, timing critical
- **0-39** 🔴 Not recommended — fees likely eat the spread

## Fee Reference

| Exchange | Maker Fee | Taker Fee | Withdrawal (BTC) | Withdrawal (ETH) |
|----------|-----------|-----------|-------------------|-------------------|
| Binance | 0.10% | 0.10% | 0.0001 | 0.00028 |
| Coinbase | 0.40% | 0.60% | 0.0001 | 0.00044 |
| Kraken | 0.16% | 0.26% | 0.00015 | 0.0025 |
| OKX | 0.08% | 0.10% | 0.0001 | 0.00028 |
| Bybit | 0.10% | 0.10% | 0.0002 | 0.0003 |
| KuCoin | 0.10% | 0.10% | 0.0002 | 0.0028 |

> Fees are approximate and change frequently. The tool fetches current fee schedules when available.

## Transfer Time Estimates

| Network | Avg Confirmation | Notes |
|---------|-----------------|-------|
| Bitcoin | 30-60 min | 2-6 confirmations required |
| Ethereum | 5-15 min | 12+ confirmations typical |
| Solana | <1 min | Near instant |
| TRON | 1-3 min | 19 confirmations |
| Polygon | 2-5 min | 128 confirmations |

## Risk Warnings

⚠️ **Slippage risk**: Large orders may not fill at displayed price.
⚠️ **Transfer risk**: Prices can move during withdrawal/deposit time.
⚠️ **Exchange risk**: Deposits can be delayed or suspended without notice.
⚠️ **This tool does NOT execute trades.** It only identifies and scores opportunities.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Commands

- `scan` — Scan
- `multi` — Scan top 10 assets for opportunities
- `history` — History
