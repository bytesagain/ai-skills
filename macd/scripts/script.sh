#!/usr/bin/env bash
# macd — MACD (Moving Average Convergence Divergence) Calculator & Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="2.0.3"

cmd_calculate() {
    local fast="${1:-12}"
    local slow="${2:-26}"
    local signal="${3:-9}"
    cat <<EOF
═══════════════════════════════════════════════════
  MACD Calculator — Parameters: (${fast}, ${slow}, ${signal})
═══════════════════════════════════════════════════

【What is MACD?】
  MACD (Moving Average Convergence Divergence) is a trend-following
  momentum indicator developed by Gerald Appel in the late 1970s.
  It shows the relationship between two exponential moving averages.

【MACD Formula】
  MACD Line   = EMA(${fast}) - EMA(${slow})
  Signal Line = EMA(${signal}) of MACD Line
  Histogram   = MACD Line - Signal Line

【EMA Calculation (Exponential Moving Average)】
  Multiplier = 2 / (Period + 1)

  EMA${fast} multiplier = 2 / (${fast} + 1) = $(python3 -c "print(f'{2/(${fast}+1):.4f}')")
  EMA${slow} multiplier = 2 / (${slow} + 1) = $(python3 -c "print(f'{2/(${slow}+1):.4f}')")
  Signal multiplier     = 2 / (${signal} + 1) = $(python3 -c "print(f'{2/(${signal}+1):.4f}')")

  EMA_today = (Price_today × Multiplier) + (EMA_yesterday × (1 - Multiplier))

【Step-by-step Calculation】
  1. Collect at least ${slow} + ${signal} periods of closing prices
  2. Calculate ${fast}-period EMA of closing prices
  3. Calculate ${slow}-period EMA of closing prices
  4. MACD Line = EMA(${fast}) - EMA(${slow})
  5. Signal Line = ${signal}-period EMA of the MACD Line
  6. Histogram = MACD Line - Signal Line

【Worked Example (Daily Closes)】
  Assume 26 days of price data ending with:
    Day 25: EMA(12) = 176.42, EMA(26) = 174.89
    Day 26: Close = 177.30

  Step 1 — Update EMA(12):
    EMA(12) = 177.30 × $(python3 -c "print(f'{2/(${fast}+1):.4f}')") + 176.42 × $(python3 -c "print(f'{1-2/(${fast}+1):.4f}')") = 176.56

  Step 2 — Update EMA(26):
    EMA(26) = 177.30 × $(python3 -c "print(f'{2/(${slow}+1):.4f}')") + 174.89 × $(python3 -c "print(f'{1-2/(${slow}+1):.4f}')") = 175.07

  Step 3 — MACD Line:
    MACD = 176.56 - 175.07 = 1.49

  Step 4 — Signal Line (if prev signal = 1.20):
    Signal = 1.49 × $(python3 -c "print(f'{2/(${signal}+1):.4f}')") + 1.20 × $(python3 -c "print(f'{1-2/(${signal}+1):.4f}')") = 1.26

  Step 5 — Histogram:
    Histogram = 1.49 - 1.26 = 0.23 (positive, bullish momentum)

【Key Readings】
  MACD > 0 and rising   → Bullish momentum strengthening
  MACD > 0 and falling  → Bullish momentum weakening
  MACD < 0 and falling  → Bearish momentum strengthening
  MACD < 0 and rising   → Bearish momentum weakening

【Common Parameter Sets】
  Setting        Fast  Slow  Signal   Use Case
  ──────────────────────────────────────────────────
  Standard       12    26    9        Default (all markets) ⭐
  Short-term     5     13    1        Scalping / day trading
  Crypto fast    8     21    5        Volatile crypto markets
  Long-term      19    39    9        Position trading / investing
  Weekly         12    26    9        Weekly chart analysis

📖 More skills: bytesagain.com
EOF
}

cmd_interpret() {
    local macd_val="${1:-}"
    local signal_val="${2:-}"
    if [ -z "$macd_val" ] || [ -z "$signal_val" ]; then
        echo "Usage: bash scripts/script.sh interpret <macd_value> <signal_value>"
        echo "Example: bash scripts/script.sh interpret 1.25 0.80"
        return 1
    fi

    MACD_VAL="$macd_val" SIGNAL_VAL="$signal_val" python3 -u <<'PYEOF'
import os

macd = float(os.environ["MACD_VAL"])
signal = float(os.environ["SIGNAL_VAL"])
histogram = macd - signal

print("═" * 50)
print(f"  MACD Analysis")
print("═" * 50)
print(f"\n  MACD Line:   {macd:+.4f}")
print(f"  Signal Line: {signal:+.4f}")
print(f"  Histogram:   {histogram:+.4f}")

# Determine trend
if macd > 0 and signal > 0:
    trend = "📈 BULLISH — Both lines above zero"
elif macd < 0 and signal < 0:
    trend = "📉 BEARISH — Both lines below zero"
elif macd > 0 and signal < 0:
    trend = "🔄 TRANSITIONING BULLISH — MACD crossed above zero"
else:
    trend = "🔄 TRANSITIONING BEARISH — MACD crossed below zero"

# Determine signal
if histogram > 0 and macd > signal:
    if histogram > abs(macd) * 0.3:
        action = "🟢 STRONG BUY — MACD well above signal, momentum strong"
    else:
        action = "🟢 BUY — MACD above signal line"
elif histogram < 0 and macd < signal:
    if abs(histogram) > abs(macd) * 0.3:
        action = "🔴 STRONG SELL — MACD well below signal, momentum bearish"
    else:
        action = "🔴 SELL — MACD below signal line"
else:
    action = "⚪ NEUTRAL — Lines converging, watch for crossover"

# Histogram momentum
if histogram > 0:
    h_reading = "Positive — bullish momentum"
    h_bars = "▓" * min(int(abs(histogram) * 10) + 1, 20)
    h_color = f"  ▲ {h_bars}"
else:
    h_reading = "Negative — bearish momentum"
    h_bars = "▓" * min(int(abs(histogram) * 10) + 1, 20)
    h_color = f"  ▼ {h_bars}"

print(f"\n  Trend:     {trend}")
print(f"  Signal:    {action}")
print(f"  Histogram: {h_reading}")
print(f"  {h_color}")

# Distance analysis
distance = abs(macd - signal)
print(f"\n  Line Separation: {distance:.4f}")
if distance < 0.1:
    print("  ⚠️  Lines very close — crossover imminent!")
    print("     Watch next 1-3 candles for confirmation.")
elif distance > 2.0:
    print("  ⚠️  Lines far apart — extended move, reversion likely.")
    print("     Consider taking partial profits.")

print(f"\n  💡 Tip: Confirm MACD signals with volume and")
print(f"     support/resistance levels for better accuracy.")
print(f"\n📖 More skills: bytesagain.com")
PYEOF
}

cmd_crossover() {
    cat <<'EOF'
═══════════════════════════════════════════════════
  MACD Crossover Patterns
═══════════════════════════════════════════════════

【Bullish Crossover 🟢 (Buy Signal)】
  MACD Line crosses ABOVE the Signal Line

  Strength levels:
  1. Below zero line → Early reversal signal (moderate)
  2. At zero line    → Trend confirmation (strong)
  3. Above zero line → Momentum continuation (use caution)

  Entry rules:
  • Wait for the crossover candle to close
  • Confirm with increasing volume
  • Best when histogram bars start turning positive
  • Place stop-loss below recent swing low

【Bearish Crossover 🔴 (Sell Signal)】
  MACD Line crosses BELOW the Signal Line

  Strength levels:
  1. Above zero line → Early reversal signal (moderate)
  2. At zero line    → Trend confirmation (strong)
  3. Below zero line → Momentum continuation (use caution)

  Exit rules:
  • Wait for the crossover candle to close
  • Confirm with increasing volume
  • Best when histogram bars start turning negative
  • Place stop-loss above recent swing high

【Zero Line Crossover】
  MACD Line crosses the Zero Line (not the signal line)

  MACD crosses above 0:
  → EMA(12) > EMA(26), short-term momentum > long-term
  → Bullish trend confirmation

  MACD crosses below 0:
  → EMA(12) < EMA(26), short-term momentum < long-term
  → Bearish trend confirmation

【False Crossover Filter】
  Not every crossover is a valid signal. Filter with:

  ✅ Volume confirmation (higher volume = stronger signal)
  ✅ Crossover after a clear trend (not in chop)
  ✅ Histogram bars growing after crossover
  ✅ Price at key support/resistance level
  ❌ Ignore crossovers in tight consolidation
  ❌ Ignore if histogram is tiny (< 0.05 separation)
  ❌ Beware of whipsaw in sideways markets

【Crossover + Histogram Confirmation】
  The strongest signals combine crossover with histogram:

  1. Histogram shrinking → approaching crossover
  2. Histogram crosses zero → crossover confirmed
  3. Histogram growing → momentum building after crossover

  Think of histogram as the "speed" of the MACD/Signal gap.
  Shrinking histogram = deceleration = warning sign.

📖 More skills: bytesagain.com
EOF
}

cmd_histogram() {
    cat <<'EOF'
═══════════════════════════════════════════════════
  MACD Histogram — Deep Dive
═══════════════════════════════════════════════════

【What the Histogram Shows】
  Histogram = MACD Line - Signal Line
  It measures the DISTANCE between MACD and its signal line.
  Think of it as "momentum of momentum."

  Positive histogram → MACD above signal → bullish momentum
  Negative histogram → MACD below signal → bearish momentum

【Reading Histogram Bars】
  ▓▓▓▓▓▓▓▓  Growing positive bars = accelerating bullish momentum
  ▓▓▓▓▓     Shrinking positive bars = decelerating (warning!)
  ▓▓
  ──────── zero line ────────
  ▓▓
  ▓▓▓▓▓     Growing negative bars = accelerating bearish momentum
  ▓▓▓▓▓▓▓▓  Shrinking negative bars = bears losing control

【Four Phases of Histogram】

  Phase 1: Positive & Growing  📈
    → Strong bullish momentum
    → Hold long positions
    → Don't short against this

  Phase 2: Positive & Shrinking  ⚠️
    → Bulls losing steam
    → Tighten stops on longs
    → Prepare for possible crossover

  Phase 3: Negative & Growing  📉
    → Strong bearish momentum
    → Hold short positions
    → Don't buy against this

  Phase 4: Negative & Shrinking  ⚠️
    → Bears losing steam
    → Tighten stops on shorts
    → Prepare for possible bullish crossover

【Histogram Divergence (Most Powerful Signal)】

  Bullish histogram divergence:
    Price:     Lower Low  ↘
    Histogram: Higher Low ↗  (shallower negative bar)
    → Bears exhausting, reversal coming
    → This often leads crossover by 2-5 bars

  Bearish histogram divergence:
    Price:     Higher High ↗
    Histogram: Lower High  ↘  (shorter positive bar)
    → Bulls exhausting, pullback coming
    → Excellent profit-taking signal

【Histogram Peak/Trough Analysis】
  • Histogram peak → histogram starts declining = first sell warning
  • Histogram trough → histogram starts rising = first buy warning
  • These signals come BEFORE the actual MACD/Signal crossover
  • Earlier entry = better price, but more false signals

【Histogram Zero Cross = MACD Crossover】
  When histogram crosses zero, it means MACD and Signal
  have crossed. This is mathematically identical.
  But watching histogram APPROACH zero gives you advance notice.

📖 More skills: bytesagain.com
EOF
}

cmd_strategies() {
    cat <<'EOF'
═══════════════════════════════════════════════════
  MACD Trading Strategies
═══════════════════════════════════════════════════

【Strategy 1: Classic MACD Crossover】
  Entry:  Buy when MACD crosses above signal below zero line
  Exit:   Sell when MACD crosses below signal above zero line
  Stop:   Below recent swing low (for longs)
  Target: 2:1 reward-to-risk minimum
  Best:   Trending markets with clear direction
  Avoid:  Sideways/choppy markets (whipsaw risk)

【Strategy 2: MACD + RSI Confirmation】
  Setup:  MACD (12,26,9) + RSI (14)

  Long entry:
    1. MACD bullish crossover (MACD > Signal)
    2. RSI > 50 but < 70 (bullish but not overbought)
    3. Enter on next candle open
    4. Stop below swing low

  Short entry:
    1. MACD bearish crossover (MACD < Signal)
    2. RSI < 50 but > 30 (bearish but not oversold)
    3. Enter on next candle open
    4. Stop above swing high

  Edge: RSI filters out weak crossover signals.

【Strategy 3: Histogram Reversal】
  This is Alexander Elder's favorite MACD technique.

  Buy signal:
    1. Histogram is below zero (bearish zone)
    2. Histogram starts rising (bar less negative than previous)
    3. This is a "buy" — bears are losing momentum
    4. Best when histogram turns from a new low

  Sell signal:
    1. Histogram is above zero (bullish zone)
    2. Histogram starts falling (bar less positive than previous)
    3. This is a "sell" — bulls are losing momentum
    4. Best when histogram turns from a new high

  Key: You're trading the TURN of momentum, not waiting
  for the full crossover. Earlier entry, tighter risk.

【Strategy 4: MACD Divergence Trading】
  The highest-probability MACD signal.

  Bullish divergence trade:
    1. Price makes lower low
    2. MACD (or histogram) makes higher low
    3. Wait for bullish crossover confirmation
    4. Enter with stop below the price low
    5. Target: previous swing high or 2:1 R:R

  Bearish divergence trade:
    1. Price makes higher high
    2. MACD (or histogram) makes lower high
    3. Wait for bearish crossover confirmation
    4. Enter with stop above the price high
    5. Target: previous swing low or 2:1 R:R

  ⚠️ Divergence in strong trends can persist!
  Always wait for crossover confirmation.

【Strategy 5: Zero Line Rejection】
  In strong trends, MACD pulls back to zero but doesn't cross.

  Bullish zero line rejection:
    1. MACD has been positive (uptrend)
    2. MACD pulls back toward zero
    3. MACD bounces from zero (doesn't go negative)
    4. Enter long → trend continuation

  Bearish zero line rejection:
    1. MACD has been negative (downtrend)
    2. MACD rallies toward zero
    3. MACD drops from zero (doesn't go positive)
    4. Enter short → trend continuation

  This is a trend-following pullback strategy.
  Works beautifully in strong directional markets.

【Strategy 6: Multi-Timeframe MACD】
  Weekly MACD: Determine primary trend direction
  Daily MACD:  Time your entries

  If Weekly MACD > 0 (bullish trend):
    → Only take bullish crossovers on daily
    → Ignore bearish daily crossovers (counter-trend)

  If Weekly MACD < 0 (bearish trend):
    → Only take bearish crossovers on daily
    → Ignore bullish daily crossovers (counter-trend)

  This dramatically reduces false signals.

📖 More skills: bytesagain.com
EOF
}

cmd_help() {
    cat <<EOF
MACD v${VERSION} — Moving Average Convergence Divergence

Commands:
  calculate [fast] [slow] [signal]   Calculate MACD step-by-step (default: 12,26,9)
  interpret <macd> <signal>          Interpret MACD & signal values with trading signals
  crossover                          MACD/signal line crossover patterns
  histogram                          MACD histogram deep dive & momentum reading
  strategies                         Proven MACD trading strategies
  help                               Show this help
  version                            Show version

Usage:
  bash scripts/script.sh calculate 12 26 9
  bash scripts/script.sh interpret 1.25 0.80
  bash scripts/script.sh crossover

Related skills:
  clawhub install rsi        — RSI overbought/oversold analysis
  clawhub install atr        — ATR volatility & position sizing
Browse all: bytesagain.com

Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    calculate)   shift; cmd_calculate "$@" ;;
    interpret)   shift; cmd_interpret "$@" ;;
    crossover)   cmd_crossover ;;
    histogram)   cmd_histogram ;;
    strategies)  cmd_strategies ;;
    version)     echo "macd v${VERSION}" ;;
    help|*)      cmd_help ;;
esac
