#!/usr/bin/env bash
# crypto-tax-calc — Cryptocurrency Tax Reference
set -euo pipefail
VERSION="3.0.0"

cmd_intro() { cat << 'EOF'
# Cryptocurrency Taxation — Overview

## Taxable Events
  Trading: Selling crypto for fiat (BTC → USD) — capital gain/loss
  Swapping: Trading one crypto for another (BTC → ETH) — taxable event
  Spending: Buying goods/services with crypto — taxable at fair market value
  Mining: Income at fair market value when received (ordinary income)
  Staking: Rewards taxed as ordinary income when received
  Airdrops: Taxed as ordinary income at fair market value when received
  Hard Forks: Taxable as ordinary income when you gain dominion/control
  NFT Sales: Capital gain/loss on sale (cost basis = purchase price + gas)
  DeFi Yields: Farming rewards, lending interest = ordinary income
  Liquidity Pool: Add/remove may be taxable depending on interpretation

## Non-Taxable Events
  Buying crypto with fiat (no gain/loss yet)
  Transferring between your own wallets (same-person transfer)
  Gifting (below gift tax exclusion: $18,000/person in 2024)
  Donating to qualified charity (may get deduction, no capital gains)
  HODLing (unrealized gains are not taxed until disposed)

## Tax Categories
  Short-term capital gains: Held ≤1 year → taxed as ordinary income
  Long-term capital gains: Held >1 year → preferential rates (0/15/20%)
  Ordinary income: Mining, staking, airdrops → income tax rates (10-37%)

## Key Tax Authority Guidance
  IRS (US):     Notice 2014-21, Rev. Rul. 2019-24, Rev. Rul. 2023-14
  HMRC (UK):    CRYPTO01000 manual
  ATO (AU):     Crypto asset guidance
  BZSt (DE):    1 year holding = tax-free for individuals
  Portugal:     Previously tax-free, now 28% on short-term gains
EOF
}

cmd_standards() { cat << 'EOF'
# Tax Calculation Standards

## Cost Basis Methods (IRS-Approved)
  FIFO (First In, First Out):
    Default method if you don't specify
    Sell oldest coins first
    In bull market: Higher gains (bought cheap, selling at higher price)
    Most common, simplest for auditing

  LIFO (Last In, First Out):
    Sell newest coins first
    In bull market: Lower gains (recently bought at higher price)
    Must be specifically elected and consistently applied

  Specific Identification:
    Choose exactly which coins to sell
    Best for tax optimization (pick highest cost basis to minimize gain)
    Requires: Transaction ID, date, amount, cost basis for each lot
    IRS: Must identify "before the transfer" (not retroactive)

  HIFO (Highest In, First Out):
    Variant of specific ID — always sell highest cost basis first
    Minimizes realized gains
    Supported by most crypto tax software
    Most tax-efficient but hardest to track manually

## IRS Crypto Reporting Requirements
  Form 8949: Report each disposal (sale, swap, spend)
    Column (a): Description ("0.5 BTC")
    Column (b): Date acquired
    Column (c): Date sold/disposed
    Column (d): Proceeds
    Column (e): Cost basis
    Column (h): Gain or loss (d - e)
  Schedule D: Summary of total capital gains/losses
  Form 1040: "Did you receive, sell, send, exchange, or otherwise acquire
    any digital assets?" — must answer YES if any crypto activity
  1099-DA: New form starting 2025 tax year (exchanges report to IRS)
EOF
}

cmd_troubleshooting() { cat << 'EOF'
# Crypto Tax Troubleshooting

## Missing Cost Basis
  Problem: Bought on exchange that closed or lost records
  Solutions:
    1. Check email for trade confirmation/receipts
    2. Request data export (most exchanges keep 7+ years)
    3. Use blockchain data: Find original acquisition transaction
    4. CoinMarketCap historical prices for fair market value on date
    5. Last resort: IRS may accept $0 cost basis (maximum gain)
  Best practice: Export trade history from every exchange quarterly

## DeFi Transaction Categorization
  Swap on DEX: Capital gain/loss event (like trading on CEX)
  Add to LP: Potentially taxable (disposing tokens for LP tokens)
  Remove from LP: Capital gain/loss on LP token disposal
  Yield farming rewards: Ordinary income when claimed
  Borrowing: NOT taxable (debt, not income)
  Liquidation: Taxable disposal (forced sale at liquidation price)
  Wrapping/unwrapping (ETH→WETH): Debatable — most treat as non-taxable
  Bridge transfers: Should be non-taxable (same asset, different chain)
  Gas fees: Add to cost basis (buy) or subtract from proceeds (sell)

## Wash Sale Considerations
  US: Wash sale rule (30-day rule) does NOT currently apply to crypto
  Reason: IRS classifies crypto as property, not securities
  Strategy: Tax loss harvesting — sell at loss, immediately rebuy
  WARNING: May change in future legislation (proposed in Build Back Better)
  International: Rules vary — UK has a 30-day "bed and breakfasting" rule

## Fork and Airdrop Valuation
  Hard fork (e.g., BTC → BCH):
    Cost basis of new coin = Fair market value when you gain control
    This becomes ordinary income
    If you can't access forked coin, taxable when you CAN access it
  Airdrop:
    Similar to hard fork — income at FMV when received
    If airdrop has $0 value at receipt, no income (IRS Rev. Rul. 2023-14)
    Cost basis = FMV at time of receipt (or $0 if worthless)
EOF
}

cmd_performance() { cat << 'EOF'
# Crypto Tax Optimization

## Tax Loss Harvesting
  Strategy: Sell positions at a loss to offset capital gains
  No wash sale rule for crypto (as of 2024): Buy back immediately
  Example:
    Gain from selling ETH: +$10,000
    Sell LINK at loss: -$3,000, immediately rebuy LINK
    Net taxable gain: $7,000 (saved ~$1,050 at 15% rate)
  Capital loss deduction: Up to $3,000/year against ordinary income
  Excess losses: Carry forward to future years (unlimited)
  Best timing: December (maximize current-year deductions)

## Long-Term vs Short-Term Planning
  Short-term rate: Up to 37% (ordinary income)
  Long-term rate: 0% (<$47K), 15% ($47K-$518K), 20% (>$518K) + 3.8% NIIT
  Strategy: Hold >1 year whenever possible = save 17-20% in taxes
  Net Investment Income Tax (NIIT): Additional 3.8% above $200K/$250K

## Batch Transaction Processing
  Problem: Thousands of DeFi transactions to categorize
  Solution: Automated tax software (see migration section)
  Approach:
    1. Connect all exchange accounts via API
    2. Import on-chain transactions via wallet address
    3. Software auto-categorizes (trade, income, transfer, etc.)
    4. Review flagged/uncertain transactions manually
    5. Generate Form 8949 and Schedule D

## Donation Strategy
  Donate appreciated crypto directly to charity
  Deduct fair market value (if held >1 year)
  No capital gains tax on the appreciation
  Example: Bought BTC at $10K, now worth $50K
    Sell and donate cash: Pay $6K tax on $40K gain, donate $44K
    Donate BTC directly: Deduct full $50K, pay $0 capital gains tax
  Limits: Deduction capped at 30% of AGI for appreciated property
EOF
}

cmd_security() { cat << 'EOF'
# Tax Record-Keeping & Audit Preparation

## Record-Keeping Requirements
  What to keep for every transaction:
    - Date and time (UTC or local timezone, be consistent)
    - Type of transaction (buy, sell, swap, transfer, income)
    - Amount of crypto (to 8+ decimal places)
    - Fair market value in USD at time of transaction
    - Cost basis and acquisition date
    - Fees paid (trading fees, gas fees, withdrawal fees)
    - Exchange or platform name
    - Transaction hash (for on-chain transactions)
  Retention: IRS can audit 3 years (6 years if >25% understatement)
  Keep records indefinitely if you don't file (no statute of limitations)

## Audit Preparation
  Triggers for crypto audit:
    - Large unreported gains
    - Inconsistency between 1099 and Form 8949
    - Exchange reporting (1099-B/1099-MISC) doesn't match your filing
    - John Doe summons (IRS served to Coinbase, Kraken, Circle)
  Prepare:
    - Complete transaction history with cost basis calculations
    - Matching between exchange records and tax forms
    - Supporting documents for claimed losses
    - Proof of holding period for long-term treatment

## Statute of Limitations
  Standard: 3 years from filing date (or due date, whichever is later)
  Substantial understatement (>25%): 6 years
  Fraud or non-filing: No limit
  Foreign account reporting (FBAR): 6 years
  Best practice: Keep records for at least 7 years

## International Reporting
  FBAR: Report foreign exchange accounts >$10K aggregate (FinCEN 114)
  FATCA: Form 8938 if foreign financial assets >$50K/$200K
  Does crypto on foreign exchange count? IRS position unclear but trending yes
  Penalties: $10K-$100K per violation for FBAR non-compliance
EOF
}

cmd_migration() { cat << 'EOF'
# Tax Software & Migration

## Spreadsheet → Tax Software Migration
  Popular crypto tax platforms:
    Koinly:       Supports 800+ exchanges, DeFi, NFTs. From $49/year.
    CoinTracker:  Clean UI, Coinbase integration. From $59/year.
    TokenTax:     Full service option with CPA review. From $65/year.
    TaxBit:       Enterprise-grade, free for basic. Powers TurboTax Crypto.
    CryptoTaxCalculator: Australian-based, good DeFi support. From $49/year.
    ZenLedger:    DeFi focus, integrates with TurboTax. From $49/year.

  Migration steps:
    1. Export all trades from exchanges (CSV or API connection)
    2. Import wallet addresses for on-chain transactions
    3. Review auto-categorization (transfers vs trades)
    4. Fix missing cost basis (manual entry or blockchain lookup)
    5. Choose cost basis method (FIFO/LIFO/HIFO)
    6. Generate tax forms (Form 8949, Schedule D, international forms)

## Exchange Export Formats
  Coinbase:     CSV (Reports → Tax Reports → Generate report)
  Binance:      CSV (Orders → Spot Order → Trade History → Export)
  Kraken:       CSV (History → Export → Trades)
  Gemini:       CSV (Account → Statements → Transaction History)
  API method:   Most tax software can read directly via read-only API key
  On-chain:     Enter wallet address — software reads blockchain

## TurboTax / Tax Preparer Integration
  TurboTax: Direct import from CoinTracker, TaxBit
  H&R Block: CSV upload of Form 8949 data
  CPA: Provide generated 8949 in CSV or PDF format
  Important: Give CPA your methodology memo (which cost basis method)

## Year-End Tax Planning Checklist
  [ ] Export all exchange trade history
  [ ] Reconcile wallet-to-wallet transfers (not taxable)
  [ ] Calculate unrealized gains/losses
  [ ] Execute tax loss harvesting before Dec 31
  [ ] Verify staking/mining income recorded as ordinary income
  [ ] Check if any positions qualify for long-term treatment
  [ ] Confirm FBAR filing requirement if foreign exchange
  [ ] Generate Form 8949 draft for review
EOF
}

cmd_cheatsheet() { cat << 'EOF'
# Crypto Tax Quick Reference

## 2024 US Tax Rate Brackets (Single)
  Short-term (= ordinary income):
    10%:  $0 - $11,600
    12%:  $11,601 - $47,150
    22%:  $47,151 - $100,525
    24%:  $100,526 - $191,950
    32%:  $191,951 - $243,725
    35%:  $243,726 - $609,350
    37%:  $609,351+

  Long-term capital gains:
    0%:   $0 - $47,025
    15%:  $47,026 - $518,900
    20%:  $518,901+
    +3.8% NIIT above $200K (single) / $250K (married)

## Form 8949 Fields
  Part I:  Short-term (held ≤1 year)
  Part II: Long-term (held >1 year)
  Box A: Reported to IRS on 1099-B (basis reported)
  Box B: Reported to IRS on 1099-B (basis NOT reported)
  Box C: NOT reported to IRS on 1099-B

## Key Dates
  April 15:   Tax filing deadline (or October 15 with extension)
  January 31: Exchanges issue 1099 forms
  March 15:   FBAR calendar-year filing (extended to October 15)
  December 31: Last day for tax loss harvesting in current year

## Taxable vs Non-Taxable Quick Check
  Taxable:     Sell, swap, spend, mine, stake rewards, airdrops, LP rewards
  Non-taxable: Buy with fiat, transfer between own wallets, hold, gift (<$18K)
  Debatable:   Wrap/unwrap, bridge transfers, LP deposit/withdrawal

## Cost Basis Calculation
  Cost basis = Purchase price + Fees (trading + gas)
  Gain/Loss = Proceeds - Cost basis
  Example: Buy 1 ETH @ $3,000 + $5 gas = $3,005 cost basis
           Sell 1 ETH @ $4,000 - $3 gas = $3,997 proceeds
           Capital gain = $3,997 - $3,005 = $992
EOF
}

cmd_faq() { cat << 'EOF'
# Crypto Tax — FAQ

Q: Do I need to report crypto if I didn't sell?
A: If you ONLY bought and held (no selling, swapping, spending), you still
   must answer "Yes" to the crypto question on Form 1040 but have no
   taxable event to report. If you received staking rewards or airdrops,
   those are ordinary income even if you didn't sell.

Q: What if I lost money on crypto?
A: Capital losses offset capital gains dollar-for-dollar.
   Excess losses deduct up to $3,000/year against ordinary income.
   Remaining losses carry forward to future years (no limit).
   Keep records of worthless tokens — you may need to "abandon" them.

Q: Are gas fees tax-deductible?
A: Gas fees on purchases: Add to cost basis (reduces future gain).
   Gas fees on sales: Reduce proceeds (reduces current gain).
   Gas fees for DeFi activities: Treatment depends on the activity.
   Gas fees not directly tied to a transaction: May not be deductible.
   Keep records of all gas fees — they add up significantly.

Q: How does the IRS know about my crypto?
A: Exchanges report to IRS via 1099-B (starting 2025 with 1099-DA).
   IRS has served summons to Coinbase, Kraken, Circle for user data.
   Chain analytics firms (Chainalysis) work with IRS to trace on-chain.
   The IRS crypto unit has grown significantly since 2020.
   Voluntary compliance is strongly recommended.

Q: Is moving crypto between my own wallets taxable?
A: No. Same-person transfers are not taxable events.
   BUT you must be able to prove both wallets are yours.
   Problem: Tax software may flag wallet-to-wallet as a sale.
   Fix: Manually tag these as "transfers" in your tax software.
   Keep records showing wallet addresses you control.
EOF
}

cmd_help() {
    echo "crypto-tax-calc v$VERSION — Cryptocurrency Tax Reference"
    echo ""
    echo "Usage: crypto-tax-calc <command>"
    echo ""
    echo "Commands:"
    echo "  intro           Taxable events, tax categories, IRS guidance"
    echo "  standards       Cost basis methods, Form 8949, reporting"
    echo "  troubleshooting Missing basis, DeFi categorization, wash sales"
    echo "  performance     Tax loss harvesting, donation strategy"
    echo "  security        Record-keeping, audit preparation, FBAR"
    echo "  migration       Spreadsheet→tax software, exchange exports"
    echo "  cheatsheet      Tax brackets, form fields, key dates"
    echo "  faq             Reporting requirements, gas fees, IRS tracking"
    echo "  help            Show this help"
}

case "${1:-help}" in
    intro) cmd_intro ;; standards) cmd_standards ;;
    troubleshooting) cmd_troubleshooting ;; performance) cmd_performance ;;
    security) cmd_security ;; migration) cmd_migration ;;
    cheatsheet) cmd_cheatsheet ;; faq) cmd_faq ;;
    help|--help|-h) cmd_help ;;
    *) echo "Unknown: $1"; echo "Run: crypto-tax-calc help" ;;
esac
