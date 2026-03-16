# DeFi Yield Finder Tips

## Finding Safe Yields

1. **TVL is your friend** — Pools with >$10M TVL have survived market tests. Below $1M is degen territory.

2. **APY vs APR** — APY includes compounding. A 50% APR compounds to ~65% APY. Know the difference.

3. **If APY > 1000%, ask why** — Unsustainably high yields usually mean:
   - Token emissions that dilute value
   - New protocol subsidizing growth (temporary)
   - Ponzi mechanics
   - Rug pull bait

4. **Stablecoin yields are the benchmark** — If stablecoin yields on Aave are 5%, anything above 15% on stables should make you suspicious.

5. **Check impermanent loss** — LP pools with volatile pairs can lose more to IL than they earn in fees. Use `--stablecoin` for zero-IL options.

## Risk Management

- Never put more than 10% of portfolio in a single pool
- Diversify across chains AND protocols
- Check if the protocol has been audited (use DeFiSafety)
- Understand what you're earning — native token rewards often dump
- Set price alerts on reward tokens

## Best Practices

- Run the tool weekly to rebalance
- Use `--risk low` for your core holdings
- Use `--risk medium` for growth allocation
- Avoid `degen` risk unless you can afford to lose it all
- Compare yields across the same asset on different protocols

## Useful Combos

```bash
# Safe stablecoin yields across all chains
bash scripts/yield_finder.sh --stablecoin --risk low --min-tvl 10000000

# Find ETH staking yields
bash scripts/yield_finder.sh --chain ethereum --protocol "lido,rocketpool,frax" --sort apy

# Arbitrum opportunities
bash scripts/yield_finder.sh --chain arbitrum --min-tvl 1000000 --min-apy 10
```
