---
version: "2.0.0"
name: defi-yield-finder
description: "Search and compare DeFi yield opportunities across chains and protocols using DeFiLlama API. Filter by APY, TVL, risk level, and chain. Use when you need defi yield finder capabilities. Triggers on: defi yield finder, chain, protocol, min-apy, max-apy, min-tvl."
---

# DeFi Yield Finder

> Find the best DeFi yields without the spreadsheet hell.

## FAQ

### What does this tool do?
It queries the DeFiLlama API to find the highest-yielding DeFi pools across all major chains and protocols. You can filter by chain, minimum TVL, APY range, and risk tolerance.

### Do I need an API key?
No. DeFiLlama's API is free and open. No authentication required.

### What chains are supported?
All chains indexed by DeFiLlama: Ethereum, BSC, Polygon, Arbitrum, Optimism, Avalanche, Solana, Fantom, Base, zkSync, and 100+ more.

### How is risk assessed?
The tool evaluates several factors:
- **TVL**: Higher TVL = more battle-tested
- **Protocol age**: Older protocols are generally safer
- **IL risk**: Impermanent loss exposure for LP pools
- **Audit status**: Whether the protocol has been audited
- **Stablecoin exposure**: Stable pairs are lower risk

### How fresh is the data?
DeFiLlama updates pool data every ~15 minutes. APY values reflect trailing 24h or 7d averages.

### Can I export results?
Yes — text, JSON, CSV, and HTML formats are supported.

---

## Commands

```bash
# Find top yields across all chains
bash scripts/yield_finder.sh --top 20

# Filter by chain
bash scripts/yield_finder.sh --chain ethereum --top 10

# Stablecoin yields only
bash scripts/yield_finder.sh --stablecoin --min-tvl 1000000

# High APY with minimum TVL
bash scripts/yield_finder.sh --min-apy 20 --max-apy 100 --min-tvl 500000

# Specific protocol
bash scripts/yield_finder.sh --protocol aave

# Low risk only
bash scripts/yield_finder.sh --risk low --top 15

# Export as HTML report
bash scripts/yield_finder.sh --chain arbitrum --format html --output yields.html

# Compare protocols
bash scripts/yield_finder.sh --compare "aave,compound,morpho"
```

## Risk Levels Explained

| Level | TVL | Protocol Age | IL Risk | Description |
|-------|-----|-------------|---------|-------------|
| **Low** | >$100M | >2 years | None/Low | Blue-chip protocols, stablecoin pairs |
| **Medium** | $10M-$100M | 6mo-2yr | Medium | Established protocols, volatile pairs |
| **High** | $1M-$10M | <6 months | High | Newer protocols, exotic pairs |
| **Degen** | <$1M | <3 months | Very High | Unaudited, new farms, high APY traps |

## Parameters

| Flag | Description | Default |
|------|-------------|---------|
| `--chain` | Filter by blockchain | all |
| `--protocol` | Filter by protocol name | all |
| `--min-apy` | Minimum APY percentage | 0 |
| `--max-apy` | Maximum APY (filters scams) | 10000 |
| `--min-tvl` | Minimum TVL in USD | 0 |
| `--stablecoin` | Only stablecoin pools | false |
| `--risk` | Risk level filter: low/medium/high/degen | all |
| `--top` | Number of results | 20 |
| `--sort` | Sort by: apy, tvl, risk | apy |
| `--format` | Output: text, json, csv, html | text |
| `--output` | File path for output | stdout |
| `--compare` | Compare specific protocols | - |

## Files

- `scripts/yield_finder.sh` — Main yield search script
- `tips.md` — Tips for finding safe yields
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
