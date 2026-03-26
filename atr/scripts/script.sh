#!/usr/bin/env bash
# atr — ATR (Average True Range) Volatility Meter & Position Sizer
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="2.0.1"

cmd_calculate() {
    local period="${1:-14}"
    cat <<EOF
═══════════════════════════════════════════════════
  ATR Calculator — Period: ${period}
═══════════════════════════════════════════════════

【What is ATR?】
  ATR (Average True Range) was developed by J. Welles Wilder Jr.
  in 1978. It measures market VOLATILITY — not direction. ATR tells
  you how much an asset typically moves, not which way.

【True Range (TR) — The Foundation】
  True Range is the GREATEST of three values:

  Method 1: Current High - Current Low
    → Normal daily range (most common case)

  Method 2: |Current High - Previous Close|
    → Captures gap-up volatility

  Method 3: |Current Low - Previous Close|
    → Captures gap-down volatility

  TR = MAX(High-Low, |High-PrevClose|, |Low-PrevClose|)

  Why 3 methods? Because gaps matter! If a stock closes at 100,
  then opens at 105 with a high of 107 and low of 104:
    Method 1: 107 - 104 = 3
    Method 2: |107 - 100| = 7  ← TRUE RANGE (captures the gap)
    Method 3: |104 - 100| = 4

【ATR Calculation (Wilder's Smoothing)】
  First ATR = Simple average of ${period} True Range values

  Subsequent ATR:
  ATR = ((Previous ATR × $(( period - 1 ))) + Current TR) / ${period}

  This is Wilder's smoothing method — gives more weight to
  recent values while maintaining a smooth line.

【Step-by-step Example】
  Day   High    Low     Close   TR
  ───────────────────────────────────
  1     48.70   47.79   48.16   0.91
  2     48.72   48.14   48.61   0.58
  3     48.90   48.39   48.75   0.56
  4     48.87   48.37   48.63   0.50
  5     48.82   48.24   48.74   0.58
  6     49.05   48.64   49.03   0.41
  7     49.20   48.94   49.07   0.30 ← very narrow day
  8     49.35   48.86   49.32   0.49
  9     49.92   49.50   49.91   0.60
  10    50.19   49.87   50.13   0.32
  11    50.12   49.20   49.53   0.93 ← high volatility day
  12    49.66   48.90   49.50   0.76
  13    49.88   49.43   49.75   0.45
  14    50.19   49.73   50.03   0.46
  ───────────────────────────────────

  First ATR(14) = (0.91+0.58+0.56+0.50+0.58+0.41+0.30+
                   0.49+0.60+0.32+0.93+0.76+0.45+0.46) / 14
               = 7.85 / 14 = 0.5607

  Day 15: TR = 0.55
  ATR(15) = (0.5607 × 13 + 0.55) / 14 = 0.5599

  The smoothing makes ATR very stable — it doesn't jump
  wildly from one extreme TR value.

【Common Period Settings】
  Period   Use Case
  ──────────────────────────────────────
  5-7      Scalping / day trading
  10       Short-term swing trading
  14       Standard (Wilder default) ⭐
  20-21    Position trading
  50       Long-term trend analysis

【ATR is NOT Directional】
  ATR = 5.0 means the asset moves ~5.0 per period on average.
  It does NOT tell you if it's going up or down.
  High ATR = volatile (big moves expected)
  Low ATR  = calm (small moves expected)

📖 More skills: bytesagain.com
EOF
}

cmd_interpret() {
    local atr_val="${1:-}"
    local price="${2:-}"
    if [ -z "$atr_val" ] || [ -z "$price" ]; then
        echo "Usage: bash scripts/script.sh interpret <atr_value> <current_price>"
        echo "Example: bash scripts/script.sh interpret 2.45 150.00"
        return 1
    fi

    ATR_VAL="$atr_val" PRICE="$price" python3 -u <<'PYEOF'
import os

atr = float(os.environ["ATR_VAL"])
price = float(os.environ["PRICE"])
atr_pct = (atr / price) * 100

print("═" * 50)
print(f"  ATR Volatility Analysis")
print("═" * 50)
print(f"\n  ATR Value:      {atr:.4f}")
print(f"  Current Price:  {price:.2f}")
print(f"  ATR as % Price: {atr_pct:.2f}%")

# Volatility classification
if atr_pct < 1.0:
    vol_class = "🟢 LOW VOLATILITY"
    desc = "Tight range, small moves expected."
    implication = "Good for range strategies. Breakout may be coming."
    stop_mult = "Wider multiplier needed (2.5-3.0x ATR)"
elif atr_pct < 2.0:
    vol_class = "🟡 MODERATE VOLATILITY"
    desc = "Normal market conditions, average moves."
    implication = "Standard strategies work well."
    stop_mult = "Standard multiplier (2.0x ATR)"
elif atr_pct < 4.0:
    vol_class = "🟠 HIGH VOLATILITY"
    desc = "Above-average moves, wider swings."
    implication = "Reduce position size. Wider stops needed."
    stop_mult = "Tighter multiplier okay (1.5-2.0x ATR)"
elif atr_pct < 8.0:
    vol_class = "🔴 VERY HIGH VOLATILITY"
    desc = "Large daily swings, significant risk."
    implication = "Smaller positions mandatory. Day trading risky."
    stop_mult = "Use 1.5x ATR or tighter"
else:
    vol_class = "💥 EXTREME VOLATILITY"
    desc = "Crisis-level moves. Typical in crypto or penny stocks."
    implication = "Consider sitting out or using minimal size."
    stop_mult = "Use 1.0x ATR with very small positions"

print(f"\n  Classification: {vol_class}")
print(f"  Description:    {desc}")
print(f"  Implication:    {implication}")
print(f"  Stop-loss tip:  {stop_mult}")

# Expected ranges
print(f"\n  Expected Daily Ranges:")
print(f"    1 ATR move:  ±{atr:.2f}  ({price-atr:.2f} to {price+atr:.2f})")
print(f"    2 ATR move:  ±{atr*2:.2f}  ({price-atr*2:.2f} to {price+atr*2:.2f}) — unusual")
print(f"    3 ATR move:  ±{atr*3:.2f}  ({price-atr*3:.2f} to {price+atr*3:.2f}) — extreme/news")

# Context
print(f"\n  Reference Points:")
print(f"    Stocks (SPY-like):  ATR% ≈ 0.8-1.5%")
print(f"    Forex (majors):     ATR% ≈ 0.3-0.8%")
print(f"    Crypto (BTC):       ATR% ≈ 2.0-5.0%")
print(f"    Crypto (altcoins):  ATR% ≈ 5.0-15.0%")
print(f"    Your asset:         ATR% = {atr_pct:.2f}%")

print(f"\n  💡 Tip: Compare ATR% to historical average for the same")
print(f"     asset. Rising ATR = increasing volatility (trend likely).")
print(f"     Falling ATR = decreasing volatility (breakout setup).")
print(f"\n📖 More skills: bytesagain.com")
PYEOF
}

cmd_stoploss() {
    local atr_val="${1:-}"
    local entry="${2:-}"
    local direction="${3:-long}"
    local multiplier="${4:-2.0}"

    if [ -z "$atr_val" ] || [ -z "$entry" ]; then
        echo "Usage: bash scripts/script.sh stoploss <atr> <entry_price> [long|short] [multiplier]"
        echo "Example: bash scripts/script.sh stoploss 2.45 150.00 long 2.0"
        return 1
    fi

    ATR_VAL="$atr_val" ENTRY="$entry" DIR="$direction" MULT="$multiplier" python3 -u <<'PYEOF'
import os

atr = float(os.environ["ATR_VAL"])
entry = float(os.environ["ENTRY"])
direction = os.environ["DIR"].lower()
mult = float(os.environ["MULT"])

stop_distance = atr * mult

print("═" * 50)
print(f"  ATR Stop-Loss Calculator")
print("═" * 50)
print(f"\n  ATR Value:       {atr:.4f}")
print(f"  Entry Price:     {entry:.2f}")
print(f"  Direction:       {'📈 LONG' if direction == 'long' else '📉 SHORT'}")
print(f"  ATR Multiplier:  {mult:.1f}x")
print(f"  Stop Distance:   {stop_distance:.2f}")

if direction == "long":
    stop = entry - stop_distance
    risk_pct = (stop_distance / entry) * 100
    print(f"\n  ┌─────────────────────────────┐")
    print(f"  │  Entry:     {entry:.2f}           │")
    print(f"  │  Stop-Loss: {stop:.2f}  🛑        │")
    print(f"  │  Distance:  {stop_distance:.2f} ({risk_pct:.2f}%)    │")
    print(f"  └─────────────────────────────┘")

    print(f"\n  Target Levels (Risk:Reward):")
    for rr in [1.0, 1.5, 2.0, 3.0]:
        target = entry + (stop_distance * rr)
        print(f"    {rr:.1f}:1 R:R → {target:.2f}  (+{stop_distance*rr:.2f})")
else:
    stop = entry + stop_distance
    risk_pct = (stop_distance / entry) * 100
    print(f"\n  ┌─────────────────────────────┐")
    print(f"  │  Stop-Loss: {stop:.2f}  🛑        │")
    print(f"  │  Entry:     {entry:.2f}           │")
    print(f"  │  Distance:  {stop_distance:.2f} ({risk_pct:.2f}%)    │")
    print(f"  └─────────────────────────────┘")

    print(f"\n  Target Levels (Risk:Reward):")
    for rr in [1.0, 1.5, 2.0, 3.0]:
        target = entry - (stop_distance * rr)
        print(f"    {rr:.1f}:1 R:R → {target:.2f}  (-{stop_distance*rr:.2f})")

print(f"\n  ATR Multiplier Guide:")
print(f"    1.0x ATR — Very tight, frequent stops (scalping)")
print(f"    1.5x ATR — Tight, swing trading in low-vol markets")
print(f"    2.0x ATR — Standard, most common setting ⭐")
print(f"    2.5x ATR — Wide, position trading / trending markets")
print(f"    3.0x ATR — Very wide, long-term / volatile assets")

print(f"\n  ⚠️  ATR stops adapt to volatility automatically!")
print(f"     When ATR rises, stops widen → protects in volatile markets")
print(f"     When ATR falls, stops tighten → locks in profits in calm markets")
print(f"\n📖 More skills: bytesagain.com")
PYEOF
}

cmd_position_size() {
    local atr_val="${1:-}"
    local account="${2:-}"
    local risk_pct="${3:-2.0}"
    local atr_mult="${4:-2.0}"

    if [ -z "$atr_val" ] || [ -z "$account" ]; then
        echo "Usage: bash scripts/script.sh position-size <atr> <account_size> [risk_%] [atr_multiplier]"
        echo "Example: bash scripts/script.sh position-size 2.45 10000 2.0 2.0"
        return 1
    fi

    ATR_VAL="$atr_val" ACCOUNT="$account" RISK_PCT="$risk_pct" ATR_MULT="$atr_mult" python3 -u <<'PYEOF'
import os

atr = float(os.environ["ATR_VAL"])
account = float(os.environ["ACCOUNT"])
risk_pct = float(os.environ["RISK_PCT"])
atr_mult = float(os.environ["ATR_MULT"])

risk_amount = account * (risk_pct / 100)
stop_distance = atr * atr_mult
position_units = risk_amount / stop_distance if stop_distance > 0 else 0

print("═" * 50)
print(f"  ATR Position Size Calculator")
print("═" * 50)
print(f"\n  Account Size:     ${account:,.2f}")
print(f"  Risk Tolerance:   {risk_pct:.1f}% (${risk_amount:,.2f})")
print(f"  ATR Value:        {atr:.4f}")
print(f"  ATR Multiplier:   {atr_mult:.1f}x")
print(f"  Stop Distance:    {stop_distance:.4f} per unit")

print(f"\n  ┌─────────────────────────────────────┐")
print(f"  │  Position Size: {position_units:,.2f} units         │")
print(f"  │  Max Loss:      ${risk_amount:,.2f}              │")
print(f"  └─────────────────────────────────────┘")

print(f"\n  Formula:")
print(f"    Position Size = Risk Amount / Stop Distance")
print(f"    Position Size = ${risk_amount:,.2f} / {stop_distance:.4f}")
print(f"    Position Size = {position_units:,.2f} units")

# Show different risk levels
print(f"\n  Position Sizes at Different Risk Levels:")
print(f"    Risk%   Risk$       Stop      Units")
print(f"    ────────────────────────────────────────")
for r in [0.5, 1.0, 1.5, 2.0, 3.0, 5.0]:
    r_amt = account * (r / 100)
    units = r_amt / stop_distance if stop_distance > 0 else 0
    marker = " ⭐" if r == risk_pct else ""
    print(f"    {r:.1f}%    ${r_amt:>8,.2f}   {stop_distance:.4f}   {units:>8,.2f}{marker}")

# Van Tharp's position sizing
print(f"\n  Van Tharp's R-Multiple Framework:")
print(f"    1R = ${risk_amount:,.2f} (your risk per trade)")
print(f"    Winning trade at 2R = ${risk_amount*2:,.2f} profit")
print(f"    Winning trade at 3R = ${risk_amount*3:,.2f} profit")
print(f"    Losing trade = -${risk_amount:,.2f} (always 1R)")
print(f"\n    Goal: Average R-multiple > 0 across all trades")

print(f"\n  ⚠️  Professional risk management rules:")
print(f"     • Never risk > 2% per trade (beginners: 1%)")
print(f"     • Never risk > 6% total across all open positions")
print(f"     • Adjust position size when ATR changes significantly")
print(f"     • Higher ATR = fewer units (auto risk control!)")
print(f"\n📖 More skills: bytesagain.com")
PYEOF
}

cmd_compare() {
    cat <<'EOF'
═══════════════════════════════════════════════════
  ATR Comparison Across Timeframes & Contexts
═══════════════════════════════════════════════════

【Multi-Timeframe ATR Analysis】
  The SAME asset will show different ATR on different timeframes:

  Timeframe    Typical ATR%     Use Case
  ─────────────────────────────────────────────────
  1-minute     0.02-0.10%       Scalping
  5-minute     0.05-0.25%       Day trading
  15-minute    0.10-0.50%       Intraday swing
  1-hour       0.20-1.00%       Short-term trading
  4-hour       0.50-2.00%       Swing trading
  Daily        0.80-5.00%       Position trading ⭐
  Weekly       2.00-12.00%      Investing

  Rule: Longer timeframe = larger ATR (more time to move)
  ATR does NOT scale linearly! Weekly ≠ Daily × 5.

【Asset Class ATR% Comparison (Daily)】

  Asset Class       Typical ATR%    Example
  ─────────────────────────────────────────────────
  Treasury bonds    0.20-0.50%      TLT
  Forex majors      0.30-0.80%      EUR/USD
  Large-cap stocks  0.80-2.00%      AAPL, MSFT
  S&P 500 ETF       0.70-1.50%      SPY
  Commodities       1.00-3.00%      Gold, Oil
  Small-cap stocks  2.00-5.00%      Russell 2000
  Bitcoin           2.00-5.00%      BTC/USD
  Altcoins          5.00-20.00%     ETH, SOL, etc.
  Meme coins        10.00-50.00%    DOGE, SHIB

【ATR Regime Detection】
  Compare current ATR to its own moving average:

  ATR > ATR_MA(20) → Volatility EXPANDING
    → Trending market likely
    → Use trend-following strategies
    → Wider stops needed

  ATR < ATR_MA(20) → Volatility CONTRACTING
    → Range-bound market likely
    → Use mean-reversion strategies
    → Tighter stops okay

  ATR at extreme low → Volatility SQUEEZE
    → Big move coming (Bollinger Band squeeze)
    → Prepare for breakout in either direction
    → Don't predict direction, just prepare

【ATR Percentile Ranking】
  Where does current ATR sit vs. last 100 readings?

  0-20th percentile:  Very low vol → breakout imminent
  20-40th percentile: Below average → normal calm market
  40-60th percentile: Average → standard conditions
  60-80th percentile: Above average → trending market
  80-100th percentile: Extreme vol → crisis or euphoria

  When ATR jumps from <20th to >80th percentile rapidly,
  a major move has started. Don't fight it.

【Normalized ATR (NATR) for Cross-Asset Comparison】
  NATR = (ATR / Close) × 100

  This converts ATR to a percentage, allowing fair
  comparison between assets with different price levels.

  Example:
    BTC: ATR = 2,500, Price = 65,000 → NATR = 3.85%
    ETH: ATR = 120,   Price = 3,200  → NATR = 3.75%
    AAPL: ATR = 3.50, Price = 175    → NATR = 2.00%

  → BTC and ETH have similar volatility profiles
  → AAPL is notably less volatile

【Practical Tips】
  • ATR rising + price rising = strong uptrend (conviction)
  • ATR rising + price falling = panic selling (climax coming)
  • ATR falling + price rising = weak rally (potential top)
  • ATR falling + price flat = coiling for breakout

📖 More skills: bytesagain.com
EOF
}

cmd_help() {
    cat <<EOF
ATR v${VERSION} — Average True Range Volatility Meter

Commands:
  calculate [period]                    Calculate ATR step-by-step (default: 14)
  interpret <atr> <price>               Interpret ATR with volatility classification
  stoploss <atr> <entry> [dir] [mult]   ATR-based stop-loss calculator
  position-size <atr> <acct> [%] [mult] Position size from ATR risk model
  compare                               ATR across timeframes and asset classes
  help                                  Show this help
  version                               Show version

Usage:
  bash scripts/script.sh calculate 14
  bash scripts/script.sh interpret 2.45 150.00
  bash scripts/script.sh stoploss 2.45 150.00 long 2.0
  bash scripts/script.sh position-size 2.45 10000 2.0 2.0

Related skills:
  clawhub install rsi        — RSI overbought/oversold analysis
  clawhub install macd       — MACD trend & momentum signals
Browse all: bytesagain.com

Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    calculate)       shift; cmd_calculate "$@" ;;
    interpret)       shift; cmd_interpret "$@" ;;
    stoploss)        shift; cmd_stoploss "$@" ;;
    position-size)   shift; cmd_position_size "$@" ;;
    compare)         cmd_compare ;;
    version)         echo "atr v${VERSION}" ;;
    help|*)          cmd_help ;;
esac
