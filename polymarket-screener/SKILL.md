---
version: "2.0.0"
name: Polymarket Screener
description: "Screen Polymarket prediction markets by category, probability, liquidity, and track probability changes to find high-value opportunities. Use when you need polymarket screener capabilities. Triggers on: polymarket screener."
author: BytesAgain
---

# Polymarket Screener 🎯

Filter and analyze prediction markets on Polymarket using their public API. Find undervalued bets, track probability movements, and discover high-opportunity markets.

## Comparison: Polymarket Screener vs Manual Browsing

| Capability | Manual Browsing | Polymarket Screener |
|-----------|----------------|-------------------|
| Filter by probability range | ❌ Limited | ✅ Exact range (e.g., 20%-40%) |
| Filter by liquidity | ❌ No | ✅ Min/max liquidity filters |
| Track probability changes | ❌ Manual checking | ✅ Automated tracking with delta |
| Multi-category scan | ❌ One at a time | ✅ All categories at once |
| Probability movement alerts | ❌ No | ✅ Configurable thresholds |
| Historical probability data | ❌ Limited chart | ✅ Exportable time series |
| Bulk opportunity scoring | ❌ No | ✅ Automated scoring |
| Custom watchlists | ❌ No | ✅ JSON watchlist with tracking |
| Export to HTML report | ❌ No | ✅ Professional report output |
| Sort by expected value | ❌ No | ✅ Built-in EV calculator |

## Getting Started

No API key needed — Polymarket's public API is free.

```bash
# List active markets
bash scripts/polymarket-screener.sh list --limit 20

# Filter by category
bash scripts/polymarket-screener.sh list --category politics --limit 50

# Find high-opportunity markets (low probability, high liquidity)
bash scripts/polymarket-screener.sh opportunities --min-liquidity 50000 --prob-range "5-30"

# Track probability changes
bash scripts/polymarket-screener.sh track --market-id MARKET_SLUG --hours 48

# Generate full screening report
bash scripts/polymarket-screener.sh report --output polymarket-report.html
```

## Market Categories

- **politics** — Elections, legislation, government actions
- **crypto** — Price predictions, ETF approvals, protocol events
- **sports** — Game outcomes, championships, player performance
- **entertainment** — Awards, releases, celebrity events
- **science** — Space, climate, research milestones
- **business** — Earnings, IPOs, M&A, market indices
- **world** — Geopolitics, international events

## Opportunity Scoring

Markets are scored based on:

```
Score = (Liquidity Factor × 0.3) + (Probability Edge × 0.3) + (Time Value × 0.2) + (Movement × 0.2)

Liquidity Factor:  Higher liquidity = higher score (easier to enter/exit)
Probability Edge:  Markets with probabilities far from 50% but trending = opportunity
Time Value:        Markets resolving soon with high uncertainty = valuable
Movement:          Recent probability shifts indicate new information
```

### What Makes a Good Opportunity?

1. **Probability between 15-35% or 65-85%** — Enough edge without extreme odds
2. **Liquidity > $50K** — Can enter meaningful position
3. **Recent movement > 5%** — Market is actively repricing
4. **Resolution within 30 days** — Time value is concrete
5. **Your own knowledge edge** — You know something the market doesn't

## Output Formats

| Command | Description |
|---------|-------------|
| `markets` | Markets |
| `odds` | Odds |
| `value-bets` | Value Bets |
| `watchlist` | Watchlist |

## API Rate Limits

Polymarket's public API has rate limits. The screener respects these automatically:
- **60 requests/minute** for listing endpoints
- **120 requests/minute** for market detail endpoints
- Built-in retry with exponential backoff

## Disclaimer

⚠️ Prediction markets involve real money and financial risk. This tool provides analysis only — it does not place bets or manage positions. Always do your own research.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Commands

Run `polymarket-screener help` to see all available commands.
