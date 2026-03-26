#!/usr/bin/env bash
# halving — Bitcoin Halving Countdown & Impact Analyzer
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="2.0.1"

cmd_countdown() {
    python3 -u <<'PYEOF'
from datetime import datetime, timezone

# Bitcoin halving occurs every 210,000 blocks
HALVING_INTERVAL = 210_000

# Known halving data
halvings = [
    {"number": 0, "block": 0,       "date": "2009-01-03", "reward": 50.0},
    {"number": 1, "block": 210000,   "date": "2012-11-28", "reward": 25.0},
    {"number": 2, "block": 420000,   "date": "2016-07-09", "reward": 12.5},
    {"number": 3, "block": 630000,   "date": "2020-05-11", "reward": 6.25},
    {"number": 4, "block": 840000,   "date": "2024-04-20", "reward": 3.125},
]

# Next halving
next_halving_num = 5
next_halving_block = 1_050_000
next_reward = 1.5625  # BTC per block

# Estimation: ~10 minutes per block average
# Halving 4 was at block 840,000 on April 20, 2024
halving4_date = datetime(2024, 4, 20, tzinfo=timezone.utc)
halving4_block = 840_000

now = datetime.now(timezone.utc)
seconds_since_h4 = (now - halving4_date).total_seconds()
avg_block_time = 600  # 10 minutes in seconds

# Estimated current block
est_blocks_since_h4 = int(seconds_since_h4 / avg_block_time)
est_current_block = halving4_block + est_blocks_since_h4
blocks_remaining = next_halving_block - est_current_block

if blocks_remaining < 0:
    blocks_remaining = 0

# Estimated time remaining
seconds_remaining = blocks_remaining * avg_block_time
days_remaining = seconds_remaining / 86400
hours_remaining = (seconds_remaining % 86400) / 3600

# Estimated halving date
from datetime import timedelta
est_halving_date = now + timedelta(seconds=seconds_remaining)

print("═" * 55)
print("  ₿ Bitcoin Halving Countdown")
print("═" * 55)
print()
print(f"  Next Halving:     #{next_halving_num}")
print(f"  Target Block:     {next_halving_block:,}")
print(f"  Est. Current:     ~{est_current_block:,}")
print(f"  Blocks Left:      ~{blocks_remaining:,}")
print()
print(f"  ┌──────────────────────────────────────┐")
print(f"  │  ⏰ ~{int(days_remaining)} days {int(hours_remaining)} hours remaining      │")
print(f"  │  📅 Est. date: {est_halving_date.strftime('%Y-%m-%d')}              │")
print(f"  └──────────────────────────────────────┘")
print()
print(f"  Current Reward:   3.125 BTC/block")
print(f"  After Halving:    {next_reward} BTC/block")
print(f"  Reward Cut:       50% reduction")
print()

# Progress bar
total_blocks = HALVING_INTERVAL
done_blocks = HALVING_INTERVAL - blocks_remaining
pct = (done_blocks / total_blocks) * 100 if total_blocks > 0 else 100
bar_len = 30
filled = int(bar_len * pct / 100)
bar = "▓" * filled + "░" * (bar_len - filled)
print(f"  Progress: [{bar}] {pct:.1f}%")
print(f"            Block {halving4_block:,} → {next_halving_block:,}")
print()
print(f"  ⚠️  Estimate based on ~10 min/block average.")
print(f"     Actual block time varies (8-12 min).")
print(f"     Check a block explorer for real-time data.")
print()
print("📖 More skills: bytesagain.com")
PYEOF
}

cmd_history() {
    cat <<'EOF'
═══════════════════════════════════════════════════════
  ₿ Bitcoin Halving History — Complete Record
═══════════════════════════════════════════════════════

【Genesis — Block 0 (January 3, 2009)】
  Block Reward:    50 BTC
  BTC Price:       $0 (no market yet)
  Daily Issuance:  ~7,200 BTC (144 blocks/day)
  Annual Supply:   ~2,628,000 BTC
  Notes:           Satoshi Nakamoto mines the genesis block.
                   "Chancellor on brink of second bailout for banks"

【Halving #1 — Block 210,000 (November 28, 2012)】
  Block Reward:    50 → 25 BTC
  BTC Price:       ~$12.35
  Market Cap:      ~$134M
  Daily Issuance:  7,200 → 3,600 BTC
  Annual Inflation: 25% → 12.5%
  Pre-halving low: ~$2.01 (Nov 2011, 12 months prior)
  Peak after:      ~$1,163 (Nov 2013, 12 months later)
  ROI halving→peak: ~9,300%

【Halving #2 — Block 420,000 (July 9, 2016)】
  Block Reward:    25 → 12.5 BTC
  BTC Price:       ~$650
  Market Cap:      ~$10.1B
  Daily Issuance:  3,600 → 1,800 BTC
  Annual Inflation: 8.3% → 4.17%
  Pre-halving low: ~$200 (Jan 2015, 18 months prior)
  Peak after:      ~$19,783 (Dec 2017, 17 months later)
  ROI halving→peak: ~2,943%

【Halving #3 — Block 630,000 (May 11, 2020)】
  Block Reward:    12.5 → 6.25 BTC
  BTC Price:       ~$8,572
  Market Cap:      ~$158B
  Daily Issuance:  1,800 → 900 BTC
  Annual Inflation: 3.57% → 1.79%
  Pre-halving low: ~$3,850 (Mar 2020, COVID crash)
  Peak after:      ~$69,000 (Nov 2021, 18 months later)
  ROI halving→peak: ~705%

【Halving #4 — Block 840,000 (April 20, 2024)】
  Block Reward:    6.25 → 3.125 BTC
  BTC Price:       ~$63,800
  Market Cap:      ~$1.25T
  Daily Issuance:  900 → 450 BTC
  Annual Inflation: 1.79% → 0.85%
  Context:         First halving with spot Bitcoin ETFs approved
  Notable:         BTC hit ATH before halving (unusual)

【Halving #5 — Block 1,050,000 (Est. ~2028)】
  Block Reward:    3.125 → 1.5625 BTC
  Daily Issuance:  450 → 225 BTC
  Annual Inflation: 0.85% → ~0.40%
  Annual New BTC:  ~82,125 BTC
  Note:            Inflation rate below gold (~1.5%)

【Supply Milestones】
  Total supply cap:     21,000,000 BTC
  Currently mined:      ~19,600,000+ BTC (~93.3%)
  Remaining to mine:    ~1,400,000 BTC
  Last BTC mined:       ~Year 2140
  Total halvings:       32 (until reward < 1 satoshi)

📖 More skills: bytesagain.com
EOF
}

cmd_impact() {
    cat <<'EOF'
═══════════════════════════════════════════════════════
  ₿ Bitcoin Halving — Price Impact Analysis
═══════════════════════════════════════════════════════

【Price Performance Summary】

  Halving   Price@Halving   Cycle Peak    ROI      Time to Peak
  ──────────────────────────────────────────────────────────────
  #1 2012   $12.35          $1,163        9,300%   ~12 months
  #2 2016   $650            $19,783       2,943%   ~17 months
  #3 2020   $8,572          $69,000       705%     ~18 months
  #4 2024   $63,800         TBD           TBD      TBD

  Pattern: Diminishing returns each cycle (still massive)

【Pre-Halving Price Behavior】

  12-18 months before halving:
  → Market typically bottoms (cycle low)
  → Smart money accumulation begins

  6-12 months before halving:
  → Gradual price recovery
  → Media coverage increases
  → "Halving narrative" builds anticipation

  3-6 months before halving:
  → Acceleration phase
  → FOMO begins
  → Some pre-halving rally

  0-3 months before halving:
  → Often a "sell the news" dip around the event itself
  → Short-term traders take profits
  → Not always — 2024 broke this pattern

【Post-Halving Price Behavior】

  0-3 months after halving:
  → Usually consolidation / mild disappointment
  → "Nothing happened" narrative
  → Smart money continues accumulating

  3-6 months after halving:
  → Supply squeeze begins to bite
  → Miners sell less (less to sell)
  → Price starts trending up

  6-12 months after halving:
  → Acceleration phase
  → New ATH typically achieved
  → Mainstream media attention

  12-18 months after halving:
  → Parabolic blow-off top
  → Extreme euphoria
  → Cycle peak usually in this window

  18-24 months after halving:
  → Bear market begins
  → 70-80% drawdown from peak (historically)

【Supply Shock Mechanics】
  Why does price go up after halving?

  Before halving:
    Miners produce X BTC/day → sell most to cover costs
    Market absorbs X BTC/day of sell pressure

  After halving:
    Miners produce X/2 BTC/day
    Same (or growing) demand
    Less new supply hitting market
    → Supply/demand imbalance → price rises

  It's not magic — it's basic economics:
    Demand constant + Supply cut 50% = Price increase

【Diminishing Returns Theory】
  Each halving has smaller supply impact:
  #1: 50→25 BTC (3,600 fewer BTC/day)
  #2: 25→12.5 (1,800 fewer BTC/day)
  #3: 12.5→6.25 (900 fewer BTC/day)
  #4: 6.25→3.125 (450 fewer BTC/day)

  The absolute supply reduction shrinks each cycle.
  New supply becomes less significant vs. total float.
  Other factors (ETFs, regulation, macro) increasingly matter.

【Is "This Time Different"?】
  Arguments FOR continued pattern:
  ✅ Supply mechanics are mathematically guaranteed
  ✅ Growing institutional demand (ETFs)
  ✅ Global adoption still early (<5% world population)
  ✅ Macro environment (money printing, inflation)

  Arguments AGAINST:
  ❌ Market is more efficient (priced in?)
  ❌ Diminishing supply impact each cycle
  ❌ Regulatory uncertainty
  ❌ Past performance ≠ future results

📖 More skills: bytesagain.com
EOF
}

cmd_mining() {
    cat <<'EOF'
═══════════════════════════════════════════════════════
  ₿ Bitcoin Mining Economics & Halving Impact
═══════════════════════════════════════════════════════

【Block Reward History】
  Era    Blocks           Reward     Daily BTC    Annual BTC
  ──────────────────────────────────────────────────────────
  1      0-209,999        50.0       7,200        2,628,000
  2      210k-419,999     25.0       3,600        1,314,000
  3      420k-629,999     12.5       1,800        657,000
  4      630k-839,999     6.25       900          328,500
  5      840k-1,049,999   3.125      450          164,250
  6      1,050k-1,259,999 1.5625     225          82,125

【Miner Revenue Components】
  Total Miner Revenue = Block Reward + Transaction Fees

  Block Reward:
  → Fixed BTC amount per block (halves every 210k blocks)
  → Currently: 3.125 BTC/block
  → Predictable and decreasing over time

  Transaction Fees:
  → Variable, depends on network demand
  → Typically 2-10% of block reward in normal times
  → Can spike to 50%+ during congestion (Ordinals, BRC-20)
  → Becoming more important as block reward shrinks

【Revenue Impact of Each Halving】
  At constant BTC price, halving cuts miner revenue ~50%.

  Example at $65,000/BTC:
  Before halving #4: 6.25 BTC × $65,000 = $406,250/block
  After halving #4:  3.125 BTC × $65,000 = $203,125/block

  Daily revenue (144 blocks):
  Before: $58.5M/day
  After:  $29.3M/day  (-50%)

  For miners to maintain the same $ revenue post-halving,
  BTC price must approximately double.

【Miner Break-Even Analysis】
  Miner costs (simplified):
  → Electricity: 60-80% of total costs
  → Hardware depreciation: 15-25%
  → Facility, cooling, staff: 5-15%

  Break-even price = Total Costs / BTC Mined

  If a miner's cost to produce 1 BTC = $40,000:
    Before halving: profitable at any price > $40,000
    After halving: cost doubles to ~$80,000 per BTC
    If BTC < $80,000: that miner is unprofitable

  Result: Inefficient miners get squeezed out after each halving.
  → Hash rate temporarily drops
  → Difficulty adjusts downward
  → Surviving miners become more profitable
  → Network finds new equilibrium

【Hash Rate & Difficulty Post-Halving】
  Typical pattern after halving:

  Week 1-4:   Hash rate may dip 5-15%
              (unprofitable miners shut down)
  Month 1-3:  Difficulty adjusts down to compensate
              Surviving miners see improved margins
  Month 3-6:  If price rises, new miners come online
              Hash rate recovers and exceeds pre-halving
  Month 6-12: Hash rate reaches new all-time highs
              (higher price justifies new hardware investment)

【Mining Hardware Generations】
  Halving #1 (2012): CPU/GPU mining era ending, FPGAs emerging
  Halving #2 (2016): ASIC-dominated (Antminer S9 era)
  Halving #3 (2020): Efficient ASICs (S19 series, ~30 J/TH)
  Halving #4 (2024): Ultra-efficient (S21, ~17 J/TH)
  Halving #5 (2028): Next-gen (<10 J/TH expected?)

  Each halving forces efficiency improvements.
  Miners that don't upgrade get eliminated.

【Fee Revenue Becoming Critical】
  As block reward → 0, transaction fees must sustain mining.

  Current fee % of total reward:
  2012-2016: ~0.5-2%
  2016-2020: ~2-5%
  2020-2024: ~3-15% (higher with Ordinals)
  2024-2028: Expected ~10-25%
  Long-term:  Must reach ~100% by 2140

  This is Bitcoin's security budget question:
  Will fees alone be enough to incentivize mining
  and secure the network after all BTC is mined?

【Miner Behavior Around Halving】
  Pre-halving (3-6 months before):
  → Miners stockpile BTC (reduce selling)
  → Upgrade hardware aggressively
  → Lock in electricity contracts

  Post-halving (0-6 months after):
  → Weak miners capitulate (forced to sell reserves)
  → Short-term sell pressure from struggling miners
  → Consolidation in mining industry
  → Mergers and acquisitions

📖 More skills: bytesagain.com
EOF
}

cmd_cycles() {
    cat <<'EOF'
═══════════════════════════════════════════════════════
  ₿ Bitcoin 4-Year Market Cycle Analysis
═══════════════════════════════════════════════════════

【The 4-Year Cycle Theory】
  Bitcoin follows a roughly 4-year cycle driven by:
  1. Halving event (supply shock catalyst)
  2. Market psychology (greed → fear → greed)
  3. Liquidity cycles (global macro)
  4. Adoption waves (technology S-curve)

  Each cycle has 4 distinct phases:

【Phase 1: Accumulation (Bear Market Bottom)】
  Duration: ~12-14 months
  Typical timing: 12-24 months after previous cycle peak

  Characteristics:
  → Price 70-85% below previous ATH
  → Extreme fear and apathy
  → Media declares "Bitcoin is dead" (again)
  → Smart money quietly accumulates
  → Low volume, low volatility
  → Many retail investors have capitulated

  Historical examples:
    2011: $2 bottom (from $32 peak) → -94%
    2015: $200 bottom (from $1,163 peak) → -83%
    2018: $3,200 bottom (from $19,783 peak) → -84%
    2022: $15,500 bottom (from $69,000 peak) → -77%

  Strategy: DCA aggressively. Maximum opportunity zone.

【Phase 2: Mark-Up (Recovery & Pre-Halving)】
  Duration: ~12-18 months
  Typical timing: 6-18 months before halving

  Characteristics:
  → Steady price recovery from bottom
  → Halving narrative builds excitement
  → Gradually increasing volume
  → Still below previous ATH
  → Early adopters and institutions enter
  → Mining difficulty starts recovering

  Strategy: Continue accumulating. Build position before halving.

【Phase 3: Parabolic (Bull Run)】
  Duration: ~12-18 months
  Typical timing: 6-18 months after halving

  Characteristics:
  → New all-time highs
  → Exponential price growth
  → Mainstream media frenzy
  → "Everyone" talking about Bitcoin
  → Extreme greed on Fear & Greed Index
  → Altcoin season typically follows BTC peak
  → Blow-off top with massive volume

  Historical peaks:
    Cycle 1: $1,163 (Nov 2013)  — 12 months post-halving
    Cycle 2: $19,783 (Dec 2017) — 17 months post-halving
    Cycle 3: $69,000 (Nov 2021) — 18 months post-halving
    Cycle 4: TBD

  Strategy: Take profits gradually. Don't try to time exact top.

【Phase 4: Distribution & Crash (Bear Market)】
  Duration: ~12-14 months
  Typical timing: peak to bottom

  Characteristics:
  → Sharp initial crash (30-50% in weeks)
  → Dead cat bounces that trap buyers
  → Grinding lower prices over months
  → Leverage liquidation cascades
  → Projects and exchanges fail
  → Capitulation event near bottom

  Strategy: Preserve capital. Start DCA plan near bottom signals.

【Cycle Length Comparison】
  Cycle   Bottom      Halving     Peak        Bottom
  ────────────────────────────────────────────────────
  1       2011-11     2012-11     2013-11     2015-01
  2       2015-01     2016-07     2017-12     2018-12
  3       2018-12     2020-05     2021-11     2022-11
  4       2022-11     2024-04     TBD         TBD

  Average cycle: ~47-48 months (bottom to bottom)

【Lengthening Cycles Theory】
  Some analysts observe:
  → Each cycle peak takes slightly longer to reach
  → Each cycle correction is slightly less severe
  → Returns diminish but remain substantial

  If pattern holds for Cycle 4:
  → Peak: Late 2025 to Mid 2026 (19-20 months post-halving)
  → Correction: -60 to -75% (less severe)

  Counter-argument: Cycles may compress or break entirely
  as Bitcoin matures and becomes more institutional.

【Cycle Indicators to Watch】
  At the BOTTOM (buy signals):
  ✅ MVRV Z-Score < 0 (historically never fails)
  ✅ Puell Multiple < 0.5
  ✅ 200-week MA holding as support
  ✅ Long-term holder supply at ATH
  ✅ Mayer Multiple < 0.8

  At the TOP (sell signals):
  🔴 MVRV Z-Score > 7
  🔴 Puell Multiple > 4
  🔴 Pi Cycle Top indicator cross
  🔴 Exchange inflow spike (dumping)
  🔴 Google Trends "Bitcoin" at 100

【Stock-to-Flow Model (S2F)】
  S2F = Existing Supply / Annual New Supply

  Pre-halving 4:  S2F ≈ 57 (comparable to gold at ~62)
  Post-halving 4: S2F ≈ 120 (2x gold scarcity)
  Post-halving 5: S2F ≈ 240 (approaching infinity)

  Controversial model by PlanB:
  → Accurately predicted cycles 1-3 price range
  → Increasingly debated for future accuracy
  → Critics: sample size too small, correlation ≠ causation

【The Big Question: Will Cycles Continue?】
  Arguments for continued cycles:
  ✅ Halving is hard-coded, supply shocks are guaranteed
  ✅ Human psychology doesn't change (greed/fear)
  ✅ 4-year cycle aligns with broader liquidity cycles

  Arguments against:
  ❌ Institutional participation dampens volatility
  ❌ Market efficiency increases with size
  ❌ Eventually, halving supply impact becomes negligible
  ❌ Regulation could alter market dynamics

📖 More skills: bytesagain.com
EOF
}

cmd_help() {
    cat <<EOF
Halving v${VERSION} — Bitcoin Halving Countdown & Impact Analyzer

Commands:
  countdown    Estimate time until next Bitcoin halving
  history      Complete halving history (dates, blocks, prices)
  impact       Price impact analysis before and after halvings
  mining       Mining economics and profitability changes
  cycles       Bitcoin 4-year market cycle theory
  help         Show this help
  version      Show version

Usage:
  bash scripts/script.sh countdown
  bash scripts/script.sh history
  bash scripts/script.sh impact

Related skills:
  clawhub install rsi        — RSI overbought/oversold analysis
  clawhub install macd       — MACD trend & momentum signals
  clawhub install atr        — ATR volatility & position sizing
Browse all: bytesagain.com

Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    countdown)   cmd_countdown ;;
    history)     cmd_history ;;
    impact)      cmd_impact ;;
    mining)      cmd_mining ;;
    cycles)      cmd_cycles ;;
    version)     echo "halving v${VERSION}" ;;
    help|*)      cmd_help ;;
esac
