#!/usr/bin/env bash
# macd — MACD (Moving Average Convergence Divergence) Calculator
# Requires: python3 (standard library only)
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="2.0.4"

cmd_calculate() {
    local prices="${1:-}"
    local fast="${2:-12}"
    local slow="${3:-26}"
    local signal="${4:-9}"

    if [ -z "$prices" ]; then
        echo "Usage: bash scripts/script.sh calculate \"price1,price2,...\" [fast] [slow] [signal]"
        echo "  Defaults: fast=12, slow=26, signal=9"
        echo ""
        echo "Example:"
        echo "  bash scripts/script.sh calculate \"170.5,171.2,172.8,171.0,173.5,174.2,175.0,174.8,176.1,175.5,177.2,178.0,176.5,177.8,179.0,178.5,180.2,179.8,181.0,180.5,182.3,181.8,183.0,182.5,184.0,183.5\""
        return 1
    fi

    PRICES="$prices" FAST="$fast" SLOW="$slow" SIGNAL="$signal" python3 << 'PYEOF'
import os

prices_str = os.environ["PRICES"]
fast = int(os.environ["FAST"])
slow = int(os.environ["SLOW"])
signal_p = int(os.environ["SIGNAL"])

prices = [float(p.strip()) for p in prices_str.split(",") if p.strip()]

if len(prices) < slow + signal_p:
    print(f"Error: Need at least {slow + signal_p} prices, got {len(prices)}")
    exit(1)

def calc_ema(data, period):
    """Calculate EMA series from price data."""
    ema = []
    # First EMA = SMA of first 'period' values
    sma = sum(data[:period]) / period
    ema.append(sma)
    mult = 2.0 / (period + 1)
    for i in range(period, len(data)):
        val = data[i] * mult + ema[-1] * (1 - mult)
        ema.append(val)
    return ema

# Calculate EMAs
ema_fast = calc_ema(prices, fast)
ema_slow = calc_ema(prices, slow)

# Align: ema_fast starts at index fast-1, ema_slow at slow-1
# MACD line starts where both exist
offset = slow - fast
macd_line = []
for i in range(len(ema_slow)):
    macd_val = ema_fast[i + offset] - ema_slow[i]
    macd_line.append(macd_val)

# Signal line = EMA of MACD line
signal_line = calc_ema(macd_line, signal_p)

# Histogram
hist_offset = signal_p
histogram = []
for i in range(len(signal_line)):
    h = macd_line[i + signal_p - 1 + 1 - 1] - signal_line[i]
    histogram.append(h)

# Recalculate aligned
# ema_slow starts at index slow-1 of prices
# macd_line[j] corresponds to prices index slow-1+j
# signal_line starts at index signal_p-1 of macd_line
# So signal_line[k] corresponds to macd_line[signal_p-1+k]

print("=" * 60)
print(f"  MACD Calculator — ({fast}, {slow}, {signal_p})")
print("=" * 60)
print(f"  Input: {len(prices)} prices")
print(f"  EMA({fast}) multiplier: {2/(fast+1):.4f}")
print(f"  EMA({slow}) multiplier: {2/(slow+1):.4f}")
print(f"  Signal multiplier:  {2/(signal_p+1):.4f}")
print()

# Show last 10 data points with aligned indices
n_show = min(10, len(signal_line))
print(f"  Last {n_show} computed values:")
print(f"  {'Day':<6} {'Price':<10} {'EMA'+str(fast):<12} {'EMA'+str(slow):<12} {'MACD':<10} {'Signal':<10} {'Hist':<10}")
print(f"  {'-'*70}")

for i in range(len(signal_line) - n_show, len(signal_line)):
    macd_idx = i + signal_p - 1
    price_idx = slow - 1 + macd_idx
    if price_idx < len(prices) and macd_idx < len(macd_line):
        ema_f_idx = macd_idx + offset
        p = prices[price_idx] if price_idx < len(prices) else 0
        ef = ema_fast[ema_f_idx] if ema_f_idx < len(ema_fast) else 0
        es = ema_slow[macd_idx] if macd_idx < len(ema_slow) else 0
        m = macd_line[macd_idx]
        s = signal_line[i]
        h = m - s
        print(f"  {price_idx+1:<6} {p:<10.2f} {ef:<12.4f} {es:<12.4f} {m:<10.4f} {s:<10.4f} {h:<+10.4f}")

# Current values (last)
last_macd = macd_line[-1]
last_signal = signal_line[-1]
last_hist = last_macd - last_signal

print()
print(f"  Current MACD:      {last_macd:+.4f}")
print(f"  Current Signal:    {last_signal:+.4f}")
print(f"  Current Histogram: {last_hist:+.4f}")
print()

# Generate signal
if last_macd > last_signal:
    if last_hist > 0 and len(histogram) > 1 and histogram[-1] > histogram[-2]:
        sig = "BULLISH (MACD above signal, histogram expanding)"
    else:
        sig = "BULLISH (MACD above signal)"
else:
    if last_hist < 0 and len(histogram) > 1 and histogram[-1] < histogram[-2]:
        sig = "BEARISH (MACD below signal, histogram expanding down)"
    else:
        sig = "BEARISH (MACD below signal)"

if abs(last_hist) < 0.05:
    sig += " ⚠️ Near crossover"

print(f"  Signal: {sig}")
print(f"\n📖 More skills: bytesagain.com")
PYEOF
}

cmd_calculate_file() {
    local file="${1:-}"
    if [ -z "$file" ] || [ ! -f "$file" ]; then
        echo "Usage: bash scripts/script.sh calculate-file <prices.csv>"
        echo "  CSV format: one price per line, or first column of CSV"
        return 1
    fi

    # Extract prices from CSV (first numeric column)
    local prices
    prices=$(python3 << PYEOF
import csv, sys
with open("$file") as f:
    reader = csv.reader(f)
    vals = []
    for row in reader:
        for cell in row:
            cell = cell.strip()
            try:
                v = float(cell)
                vals.append(str(v))
                break
            except ValueError:
                continue
    print(",".join(vals))
PYEOF
    )

    if [ -z "$prices" ]; then
        echo "Error: No numeric data found in $file"
        return 1
    fi

    cmd_calculate "$prices" "${2:-12}" "${3:-26}" "${4:-9}"
}

cmd_interpret() {
    local macd_val="${1:-}"
    local signal_val="${2:-}"

    if [ -z "$macd_val" ] || [ -z "$signal_val" ]; then
        echo "Usage: bash scripts/script.sh interpret <macd_value> <signal_value>"
        echo "Example: bash scripts/script.sh interpret 1.25 0.80"
        return 1
    fi

    MACD_VAL="$macd_val" SIG_VAL="$signal_val" python3 << 'PYEOF'
import os

macd = float(os.environ["MACD_VAL"])
signal = float(os.environ["SIG_VAL"])
hist = macd - signal

print("=" * 55)
print(f"  MACD Analysis")
print("=" * 55)
print(f"  MACD Line:   {macd:+.4f}")
print(f"  Signal Line: {signal:+.4f}")
print(f"  Histogram:   {hist:+.4f}")
print()

# Zone analysis
if macd > 0 and signal > 0:
    zone = "ABOVE ZERO — Bullish territory"
elif macd < 0 and signal < 0:
    zone = "BELOW ZERO — Bearish territory"
else:
    zone = "ZERO LINE AREA — Trend transition"

# Crossover
if macd > signal:
    cross = "MACD above Signal — Bullish"
    if hist > 0.5:
        momentum = "Strong upward momentum"
    elif hist > 0:
        momentum = "Mild upward momentum"
    else:
        momentum = "Weak momentum"
else:
    cross = "MACD below Signal — Bearish"
    if hist < -0.5:
        momentum = "Strong downward momentum"
    elif hist < 0:
        momentum = "Mild downward momentum"
    else:
        momentum = "Weak momentum"

# Action
if macd > signal and macd > 0:
    action = "Hold longs. Trail stop below support."
elif macd > signal and macd <= 0:
    action = "Potential bottom. Watch for zero-line crossover to confirm."
elif macd < signal and macd < 0:
    action = "Bearish. Avoid longs. Look for oversold bounce signals."
else:
    action = "Topping signal. Consider taking profits. Tighten stops."

print(f"  Zone:     {zone}")
print(f"  Cross:    {cross}")
print(f"  Momentum: {momentum}")
print(f"  Action:   {action}")

if abs(hist) < 0.1:
    print(f"\n  ⚠️  Histogram near zero — crossover imminent!")

print(f"\n📖 More skills: bytesagain.com")
PYEOF
}

cmd_crossover() {
    cat << 'EOF'
═══════════════════════════════════════════════════
  MACD Crossover Patterns
═══════════════════════════════════════════════════

【Bullish Crossover 🟢】
  MACD line crosses ABOVE signal line
  Histogram: negative → positive

  Strength filters:
    ✅ Strong: occurs below zero line (early trend)
    ⚠️ Medium: occurs near zero line
    ❌ Weak: occurs far above zero (late, risky)

  Entry: Buy on close after crossover confirms
  Stop:  Below recent swing low
  Target: Previous resistance or 2:1 R:R

【Bearish Crossover 🔴】
  MACD line crosses BELOW signal line
  Histogram: positive → negative

  Strength filters:
    ✅ Strong: occurs above zero line (early trend)
    ⚠️ Medium: occurs near zero line
    ❌ Weak: occurs far below zero (late, risky)

  Entry: Sell/short on close after crossover confirms
  Stop:  Above recent swing high
  Target: Previous support or 2:1 R:R

【Zero Line Crossover】
  MACD crosses above zero = bullish trend confirmed
  MACD crosses below zero = bearish trend confirmed

  More significant than signal crossover but lags more.
  Use as trend filter, not entry trigger.

【False Crossover Filters】
  Skip crossover if:
  - Histogram bar is tiny (< 0.05)
  - Crossover happens in choppy sideways market
  - Volume is declining during crossover
  - Price is inside a tight range

  Confirm with:
  - Volume spike on crossover bar
  - Price breaks key support/resistance
  - RSI confirms direction (> 50 bullish, < 50 bearish)

📖 More skills: bytesagain.com
EOF
}

cmd_histogram() {
    cat << 'EOF'
═══════════════════════════════════════════════════
  MACD Histogram Deep Dive
═══════════════════════════════════════════════════

【What the Histogram Shows】
  Histogram = MACD Line - Signal Line
  Positive bars: MACD above signal (bullish momentum)
  Negative bars: MACD below signal (bearish momentum)
  Bar height = momentum strength

【Alexander Elder's Histogram Rules】
  1. Histogram rising = momentum increasing (don't short)
  2. Histogram falling = momentum decreasing (don't buy)
  3. New histogram peak > previous peak = strong trend
  4. New histogram peak < previous peak = weakening trend (divergence!)

【Histogram Divergence (Most Powerful Signal)】
  Bullish: Price makes lower low, histogram makes higher low
    → Selling exhaustion, reversal likely
    → Best signal when histogram is below zero

  Bearish: Price makes higher high, histogram makes lower high
    → Buying exhaustion, reversal likely
    → Best signal when histogram is above zero

【Reading Histogram Shape】
  Expanding bars (growing taller):
    → Trend accelerating, stay in trade

  Contracting bars (getting shorter):
    → Trend decelerating, prepare for reversal
    → Tighten stops, take partial profits

  Bars crossing zero:
    → Crossover event (see crossover command)

【Common Mistakes】
  ❌ Trading histogram in isolation
  ❌ Ignoring the actual bar height (tiny = meaningless)
  ❌ Fighting expanding histogram (counter-trend trading)
  ✅ Use histogram + price action + volume together

📖 More skills: bytesagain.com
EOF
}

cmd_strategies() {
    cat << 'EOF'
═══════════════════════════════════════════════════
  MACD Trading Strategies
═══════════════════════════════════════════════════

【Strategy 1: Classic Crossover】
  Entry:  MACD crosses above signal → BUY
          MACD crosses below signal → SELL
  Stop:   Below/above recent swing
  Target: 2:1 reward-to-risk minimum
  Filter: Only trade crossovers in direction of daily trend
  Best:   Trending markets

【Strategy 2: Zero Line Rejection】
  Setup:  MACD pulls back toward zero but does not cross
  Long:   MACD dips toward zero, bounces up → BUY
  Short:  MACD rallies toward zero, turns down → SELL
  Edge:   Catches trend continuation after pullback
  Best:   Strong trending markets

【Strategy 3: Histogram Divergence】
  Bullish: Price lower low + histogram higher low → BUY
  Bearish: Price higher high + histogram lower high → SELL
  Stop:   Beyond the divergence swing point
  Note:   Most reliable MACD signal (Elder)
  Best:   Reversals at support/resistance

【Strategy 4: MACD + Moving Average Filter】
  Setup:  Add 200-period SMA to chart
  Long:   Price > 200 SMA AND MACD bullish crossover → BUY
  Short:  Price < 200 SMA AND MACD bearish crossover → SELL
  Edge:   Filters out counter-trend signals
  Best:   Swing trading (daily chart)

【Strategy 5: Multi-Timeframe MACD】
  Weekly MACD: Determines trend direction
  Daily MACD:  Determines entry timing

  If Weekly MACD > 0 (bullish):
    → Only take daily bullish crossovers (ignore bearish)
  If Weekly MACD < 0 (bearish):
    → Only take daily bearish crossovers (ignore bullish)

  Edge: Dramatically reduces false signals

【Parameter Variations】
  Standard:   (12, 26, 9) — most common, balanced
  Fast:       (8, 17, 9) — more signals, more noise
  Slow:       (21, 55, 9) — fewer signals, higher quality
  Crypto:     (12, 26, 9) on 4H chart — best for crypto volatility

📖 More skills: bytesagain.com
EOF
}

cmd_help() {
    cat << EOF
MACD v${VERSION} — Moving Average Convergence Divergence Calculator

Commands:
  calculate <prices> [fast] [slow] [sig]
                         Compute MACD from comma-separated prices
  calculate-file <csv>   Compute MACD from a CSV file
  interpret <macd> <sig> Interpret MACD/signal values
  crossover              Crossover patterns and trading rules
  histogram              Histogram analysis guide
  strategies             MACD trading strategies
  help                   Show this help
  version                Show version

Usage:
  bash scripts/script.sh calculate "170.5,171.2,...,183.5"
  bash scripts/script.sh calculate-file prices.csv
  bash scripts/script.sh interpret 1.25 0.80

Requires: python3 (standard library only)

Related skills:
  clawhub install rsi
  clawhub install atr
Browse all: bytesagain.com

Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    calculate)       shift; cmd_calculate "$@" ;;
    calculate-file)  shift; cmd_calculate_file "$@" ;;
    interpret)       shift; cmd_interpret "$@" ;;
    crossover)       cmd_crossover ;;
    histogram)       cmd_histogram ;;
    strategies)      cmd_strategies ;;
    version)         echo "macd v${VERSION}" ;;
    help|*)          cmd_help ;;
esac
