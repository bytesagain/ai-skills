# Arbitrage Finder — Tips & Tricks 🔄

## Understanding Real Spreads

1. **Posted spread ≠ real profit** — Always subtract trading fees, withdrawal fees, and network gas.
2. **Slippage kills profits** — The spread you see at $100 trade size won't exist at $10,000.
3. **Transfer time is your enemy** — A 1% spread means nothing if it takes 30 minutes to transfer and the price moves 2%.

## Execution Tips

- **Pre-fund both exchanges** — The only way to capture spreads quickly is to already have funds on both sides.
- **Use stablecoin pairs** — USDT/USDC arbitrage has lower volatility risk during transfer.
- **Start small** — Test with small amounts to verify the full cycle works before scaling up.
- **Same-chain arbitrage** — DEX-to-DEX on the same chain eliminates transfer time risk entirely.

## Best Times for Arbitrage

- During high volatility events (CPI announcements, FOMC meetings)
- When one exchange has technical issues (delayed price updates)
- During sudden pumps/dumps (CEX prices often lead DEX prices)
- Weekend/holiday when liquidity is thinner

## Score Interpretation

- **Score 80+** — Act quickly, these don't last long
- **Score 60-79** — Worth investigating, check order book depth
- **Score 40-59** — Marginal, only attempt with pre-funded accounts
- **Score <40** — Skip it, fees will eat the profit

## Common Mistakes

- ❌ Forgetting to account for deposit confirmation times
- ❌ Not checking if withdrawals are suspended on either exchange
- ❌ Trying to arbitrage illiquid tokens (can't fill orders)
- ❌ Over-leveraging on a single opportunity
- ❌ Ignoring tax implications of high-frequency trading
