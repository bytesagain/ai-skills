# ⛽ Gas Tracker Tips

## Save on Gas

1. **Time your transactions** — Gas is cheapest on weekends and early morning UTC. Avoid US market open hours.

2. **Use L2s** — Arbitrum, Optimism, and Base are 10-100x cheaper than Ethereum mainnet for the same operations.

3. **Batch transactions** — Some protocols let you batch multiple operations into one transaction.

4. **Set max fee wisely** — Don't overpay. Use the "slow" gas price if your transaction isn't urgent.

5. **EIP-1559 tips** — Set a reasonable max priority fee (tip) and a higher max fee. You only pay the base fee + tip.

## Understanding Gas

- **Gas Limit**: Maximum gas units your transaction can use
- **Base Fee**: Minimum price per gas unit (burned)
- **Priority Fee**: Tip to validators for faster inclusion
- **Max Fee**: Maximum total you're willing to pay per gas unit

## When to Use Each Chain

| Need | Best Chain | Why |
|------|-----------|-----|
| Highest security | Ethereum | Most decentralized |
| Cheap DeFi | Arbitrum | Low fees, EVM compatible |
| NFT gaming | Polygon | Very cheap, fast |
| Quick swaps | BSC | Low fees, lots of liquidity |
| New projects | Base | Growing ecosystem, cheap |

## Watch Mode

Use `--watch` for continuous monitoring:
```bash
bash scripts/gas_tracker.sh --chain ethereum --watch --interval 30 --alert 20
```
This checks every 30 seconds and alerts when gas drops below 20 gwei.
