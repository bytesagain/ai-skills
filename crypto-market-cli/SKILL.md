---
version: "5.0.0"
name: crypto-market-cli
description: "Track crypto prices, portfolios, and market data via CoinGecko. Use when checking coin prices, managing a portfolio, setting alerts, or comparing cryptocurrencies."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# crypto-market-cli

Cryptocurrency market toolkit — get live prices from CoinGecko API, manage watchlists and portfolios, view price history with sparkline charts, set price alerts, and compare coins.

## Commands

### `price`

Get live price, 24h change, and market cap for a coin from CoinGecko.

```bash
scripts/script.sh price bitcoin
scripts/script.sh price ethereum eur
```

### `search`

Search for coins by name or symbol. Returns top 10 results with rank.

```bash
scripts/script.sh search "solana"
```

### `track`

Add a coin to your local watchlist.

```bash
scripts/script.sh track bitcoin
scripts/script.sh track ethereum
```

### `watchlist`

Display all watchlist coins with current prices and 24h changes (fetched live).

```bash
scripts/script.sh watchlist
```

### `portfolio`

Manage your portfolio — record buys and view current holdings with live P/L.

```bash
scripts/script.sh portfolio add bitcoin 0.5 42000
scripts/script.sh portfolio add ethereum 2.0 3200
scripts/script.sh portfolio show
```

### `history`

View price history for a coin over N days, with sparkline visualization.

```bash
scripts/script.sh history bitcoin 7
scripts/script.sh history ethereum 30
```

### `compare`

Side-by-side price comparison of two coins.

```bash
scripts/script.sh compare bitcoin ethereum
```

### `gas`

Ethereum gas price information and links.

```bash
scripts/script.sh gas
```

### `alert`

Set and view price alerts (stored locally).

```bash
scripts/script.sh alert add bitcoin 50000 above
scripts/script.sh alert add ethereum 2000 below
scripts/script.sh alert list
```

### `stats`

Show usage statistics — watchlist size, portfolio entries, alerts count.

```bash
scripts/script.sh stats
```

### `export`

Export portfolio data as JSON or CSV.

```bash
scripts/script.sh export json
scripts/script.sh export csv
```

### `help`

```bash
scripts/script.sh help
```

### `version`

```bash
scripts/script.sh version
```

## Examples

```bash
# Quick price check
scripts/script.sh price bitcoin
scripts/script.sh price solana

# Build a watchlist
scripts/script.sh track bitcoin
scripts/script.sh track ethereum
scripts/script.sh track solana
scripts/script.sh watchlist

# Track portfolio P/L
scripts/script.sh portfolio add bitcoin 0.1 45000
scripts/script.sh portfolio show

# Research
scripts/script.sh history bitcoin 30
scripts/script.sh compare bitcoin ethereum
```

## Configuration

| Variable | Required | Description |
|----------|----------|-------------|
| `CRYPTO_CLI_DIR` | No | Data directory (default: `~/.crypto-market-cli/`) |

## Data Storage

All data saved in `~/.crypto-market-cli/`:
- `watchlist.txt` — Tracked coins
- `portfolio.jsonl` — Buy records
- `alerts.jsonl` — Price alerts
- `history.log` — Query history

## Requirements

- bash 4.0+
- curl (for CoinGecko API calls)
- python3 (for JSON parsing)

CoinGecko free API — no key required, rate-limited to ~10 requests/minute.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
