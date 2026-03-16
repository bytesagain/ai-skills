# Crypto Tax Calculator — Tips & Tricks 📊

## Data Preparation

1. **Export from every exchange** — Don't forget DEX trades! Use blockchain explorers for on-chain swaps.
2. **Standardize dates** — Make sure all CSVs use the same timezone. UTC is recommended.
3. **Include fees** — Trading fees are deductible in most jurisdictions and reduce your taxable gains.

## Method Selection

- **FIFO** is safest — Most tax authorities accept it, and it's the default in the US
- **LIFO** can save taxes in a bull market — You sell the most recently (expensively) bought tokens first
- **Average Cost** is mandatory in the UK — Don't use FIFO/LIFO for HMRC reporting

## Tax Optimization Tips

- **Tax-loss harvesting** — Sell losing positions before year-end to offset gains
- **Hold for long-term** — In the US, holding >1 year gets preferential 15-20% rates vs up to 37%
- **Track airdrops** — Most jurisdictions tax airdrops as income at receipt value
- **DeFi is taxable** — Swaps, LP entry/exit, and yield farming are all taxable events

## Common Gotchas

- ❌ Forgetting to account for staking rewards (taxed as income)
- ❌ Ignoring cross-chain bridge transactions (may create taxable events)
- ❌ Not tracking cost basis for airdropped tokens ($0 basis = 100% gain on sale)
- ❌ Missing exchange delistings — download your history before an exchange shuts down

## Country-Specific Notes

- 🇺🇸 US: Use the `compare` command to see FIFO vs LIFO side-by-side
- 🇬🇧 UK: Annual exempt amount is shrinking — use it or lose it
- 🇦🇺 AU: The 50% CGT discount is powerful — track your holding periods carefully
- 🇨🇳 CN: Keep records even if enforcement is unclear — regulations can be retroactive
