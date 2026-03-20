---
version: "2.0.0"
name: DeFi Calculator
description: "Calculate DeFi yields including APY, impermanent loss, and staking rewards. Use when estimating returns, comparing protocols, tracking farming."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# Crypto DeFi

A thorough crypto toolkit for tracking DeFi positions, managing portfolios, monitoring prices, watching whale activity, and analyzing market data. Crypto DeFi provides 16+ commands for recording and reviewing crypto-related observations with timestamped logs and multi-format data export.

## Commands

| Command | Description |
|---------|-------------|
| `crypto-defi track <input>` | Record a tracking entry (token, protocol, position) — run without args to view recent entries |
| `crypto-defi portfolio <input>` | Log a portfolio update or snapshot — run without args to view recent portfolio entries |
| `crypto-defi alert <input>` | Record a price or event alert — run without args to view recent alerts |
| `crypto-defi price <input>` | Log a price observation — run without args to view recent price entries |
| `crypto-defi compare <input>` | Record a protocol or token comparison — run without args to view recent comparisons |
| `crypto-defi history <input>` | Log a historical note — run without args to view recent history entries |
| `crypto-defi gas <input>` | Record gas fee data — run without args to view recent gas entries |
| `crypto-defi whale-watch <input>` | Log whale activity observations — run without args to view recent whale-watch entries |
| `crypto-defi report <input>` | Record a report entry — run without args to view recent reports |
| `crypto-defi watchlist <input>` | Add to or view the watchlist — run without args to view recent watchlist entries |
| `crypto-defi analyze <input>` | Log an analysis note — run without args to view recent analysis entries |
| `crypto-defi export <input>` | Record an export event — run without args to view recent export entries |
| `crypto-defi stats` | Display summary statistics across all log categories |
| `crypto-defi search <term>` | Search across all log files for a keyword |
| `crypto-defi recent` | Show the 20 most recent activity entries from the history log |
| `crypto-defi status` | Health check — shows version, data directory, entry count, disk usage |
| `crypto-defi help` | Display available commands and usage information |
| `crypto-defi version` | Print current version (v2.0.0) |

Each data command (track, portfolio, alert, etc.) works in two modes:
- **With arguments**: Records the input with a timestamp into its dedicated log file
- **Without arguments**: Displays the 20 most recent entries from that category

## Data Storage

All data is stored locally in plain-text log files:

- **Location**: `~/.local/share/crypto-defi/`
- **Format**: Each entry is saved as `YYYY-MM-DD HH:MM|<value>` in per-category `.log` files
- **History**: All operations are additionally logged to `history.log` with timestamps
- **Stats**: The `stats` command aggregates entry counts and disk usage across all categories
- **No cloud sync** — everything stays on your machine, no API keys needed

## Requirements

- Bash 4.0+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `head`, `tail`, `grep`, `basename`, `cat`
- No external dependencies, no API keys, no network access required
- Works on Linux and macOS

## When to Use

1. **DeFi position tracking** — Record yield farming positions, staking entries, and liquidity pool allocations with timestamps for historical review
2. **Portfolio management** — Log portfolio snapshots, token balances, and allocation changes to maintain a running record of your holdings
3. **Whale activity monitoring** — Use `whale-watch` to record large transaction observations and spot market-moving activity patterns
4. **Gas fee tracking** — Log gas fee observations over time to identify optimal transaction windows and track network congestion trends
5. **Multi-protocol comparison** — Use `compare` and `analyze` to record side-by-side protocol evaluations and store your analysis notes

## Examples

```bash
# Track a new DeFi position
crypto-defi track "Uniswap V3 ETH/USDC 0.3% pool — 5 ETH deposited"

# Log current portfolio state
crypto-defi portfolio "BTC: 0.5, ETH: 10, SOL: 200 — total ~$45k"

# Record a price alert trigger
crypto-defi alert "ETH crossed $4000 resistance level"

# Log gas fee observation
crypto-defi gas "Ethereum mainnet base fee 25 gwei — good time for swaps"

# Record whale activity
crypto-defi whale-watch "0xdead... moved 10,000 ETH to Binance deposit address"

# View summary statistics across all categories
crypto-defi stats

# Search for all entries mentioning a specific protocol
crypto-defi search "Uniswap"

# Quick health check
crypto-defi status
```

## Configuration

Set `DATA_DIR` by modifying the script or symlinking `~/.local/share/crypto-defi/` to your preferred location.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
