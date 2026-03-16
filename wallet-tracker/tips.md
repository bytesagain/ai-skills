# Wallet Tracker — Tips & Tricks 👛

## Setup Best Practices

1. **Use a config file** — Put all your wallets in `~/.wallet-tracker.json` instead of passing them as CLI args every time.
2. **Label your wallets** — When you have 5+ wallets, labels like "Main ETH", "DeFi Hot", "Cold Storage" save sanity.
3. **Set custom RPCs** — Public RPCs have strict rate limits. Use Alchemy/Infura free tiers for reliable tracking.

## Monitoring Strategy

- Check portfolio once daily for personal use
- Set alerts for >5% balance changes to catch unauthorized transfers
- Use `snapshot` weekly for accounting records
- Compare snapshots monthly to see where your portfolio is shifting

## Whale Watching Tips

- Follow known VC and whale wallets for alpha
- Large deposits to exchanges often signal upcoming sells
- Large withdrawals from exchanges often signal accumulation
- New wallet interactions with DEXes can signal upcoming token launches

## Privacy Considerations

- Remember: all blockchain data is public. Anyone can track YOUR wallets too.
- Use separate wallets for different activities
- Consider using multiple addresses to reduce on-chain correlation
- This tool never requires private keys — if anything asks for them, it's a scam

## Performance Tips

- ❌ Don't track 100+ wallets with 1-minute intervals — you'll get rate limited
- ✅ Use 5-10 minute intervals for active monitoring
- ✅ Use hourly checks for portfolio overview
- ✅ Batch wallet queries when possible (the tool does this automatically)
