---
version: "2.0.0"
name: gas-tracker
description: "Multi-chain gas fee tracker with real-time prices, historical trends, and optimal transaction timing for Ethereum, BSC, Polygon, Arbitrum, and more. Use when you need gas tracker capabilities. Triggers on: gas tracker, chain, estimate, history, alert, compare."
---

# ⛽ Gas Tracker

Real-time gas prices across multiple chains with smart timing recommendations.

## Workflow

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Fetch Gas   │────▶│  Analyze &   │────▶│  Generate    │
│  Prices      │     │  Compare     │     │  Report      │
└──────────────┘     └──────────────┘     └──────────────┘
       │                    │                    │
       ▼                    ▼                    ▼
  ETH, BSC, Polygon    Cost estimates      Best time to
  Arbitrum, Base       for common ops      transact
  Optimism, zkSync     (swap, transfer)    recommendation
```

## Quick Reference

| Command | What It Does |
|---------|-------------|
| `bash scripts/gas_tracker.sh` | Show all chains' gas prices |
| `bash scripts/gas_tracker.sh --chain ethereum` | ETH gas only |
| `bash scripts/gas_tracker.sh --estimate swap` | Estimate swap cost |
| `bash scripts/gas_tracker.sh --history` | 24h gas history |
| `bash scripts/gas_tracker.sh --alert 30` | Alert when gas < 30 gwei |
| `bash scripts/gas_tracker.sh --compare` | Compare all chains |
| `bash scripts/gas_tracker.sh --format html` | HTML report |

## Supported Chains

| Chain | Native Token | Unit | Typical Gas |
|-------|-------------|------|-------------|
| Ethereum | ETH | gwei | 15-100 gwei |
| BSC | BNB | gwei | 3-5 gwei |
| Polygon | MATIC | gwei | 30-200 gwei |
| Arbitrum | ETH | gwei | 0.1-1 gwei |
| Optimism | ETH | gwei | 0.01-0.1 gwei |
| Base | ETH | gwei | 0.01-0.1 gwei |
| Avalanche | AVAX | nAVAX | 25-30 nAVAX |
| Fantom | FTM | gwei | 1-10 gwei |

## Gas Cost Estimates

The tool estimates costs for common operations:

| Operation | Gas Units (ETH) | At 30 gwei |
|-----------|----------------|------------|
| ETH Transfer | 21,000 | ~$1.50 |
| ERC-20 Transfer | 65,000 | ~$4.70 |
| Uniswap Swap | 150,000 | ~$10.80 |
| NFT Mint | 200,000 | ~$14.40 |
| Contract Deploy | 1,000,000+ | ~$72.00 |
| OpenSea Sale | 250,000 | ~$18.00 |

## Parameters

| Flag | Default | Description |
|------|---------|-------------|
| `--chain` | all | Chain to check |
| `--estimate` | - | Estimate cost: transfer, swap, mint, deploy |
| `--history` | false | Show 24h gas history |
| `--alert` | - | Alert threshold in gwei |
| `--compare` | false | Side-by-side chain comparison |
| `--format` | text | Output: text, json, html |
| `--output` | stdout | Output file |
| `--watch` | false | Continuous monitoring mode |
| `--interval` | 60 | Watch interval in seconds |

## Best Time to Transact

Gas prices follow patterns:
- **Cheapest**: Weekends, early morning UTC (2-6 AM)
- **Most expensive**: Weekday US market hours (14-20 UTC)
- **Spikes**: During NFT mints, market crashes, or major events

## Files

- `scripts/gas_tracker.sh` — Main gas tracking script
- `tips.md` — Gas saving tips
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Commands

| Command | Description |
|---------|-------------|
| `gas-tracker help` | Show usage info |
| `gas-tracker run` | Run main task |
