#!/usr/bin/env bash
# rsi — RSI (Relative Strength Index) Calculator & Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="2.0.1"

cmd_calculate() {
    local period="${1:-14}"
    cat << EOF
═══════════════════════════════════════════════════
  RSI Calculator — Period: ${period}
═══════════════════════════════════════════════════

【RSI Formula】
  RSI = 100 - (100 / (1 + RS))
  RS  = Average Gain / Average Loss (over ${period} periods)

【Step-by-step Calculation】
  1. Collect ${period} periods of closing prices
  2. Calculate price changes: Change = Close[i] - Close[i-1]
  3. Separate gains (positive changes) and losses (negative changes)
  4. Average Gain = Sum of gains / ${period}
  5. Average Loss = Sum of losses / ${period}
  6. RS = Average Gain / Average Loss
  7. RSI = 100 - (100 / (1 + RS))

【Smoothed RSI (Wilder's method, more common)】
  After first ${period} periods:
  Avg Gain = (Prev Avg Gain × $(( period - 1 )) + Current Gain) / ${period}
  Avg Loss = (Prev Avg Loss × $(( period - 1 )) + Current Loss) / ${period}

【Example】
  14-day prices: 44, 44.34, 44.09, 43.61, 44.33, 44.83, 45.10,
                 45.42, 45.84, 46.08, 45.89, 46.03, 45.61, 46.28

  Gains: 0.34, 0, 0, 0.72, 0.50, 0.27, 0.32, 0.42, 0.24, 0, 0.14, 0, 0.67
  Losses: 0, 0.25, 0.48, 0, 0, 0, 0, 0, 0, 0.19, 0, 0.42, 0

  Avg Gain = 3.62 / 14 = 0.2586
  Avg Loss = 1.34 / 14 = 0.0957
  RS = 0.2586 / 0.0957 = 2.7024
  RSI = 100 - (100 / 3.7024) = 72.98

  → RSI = 72.98 (Overbought zone)

📖 More skills: bytesagain.com
EOF
}

cmd_interpret() {
    local rsi_val="${1:-}"
    if [ -z "$rsi_val" ]; then
        echo "Usage: bash scripts/script.sh interpret <rsi_value>"
        echo "Example: bash scripts/script.sh interpret 72.5"
        return 1
    fi

    RSI_VAL="$rsi_val" python3 << 'PYEOF'
import os
rsi = float(os.environ["RSI_VAL"])

print("═" * 50)
print(f"  RSI Analysis: {rsi:.1f}")
print("═" * 50)

if rsi >= 80:
    zone = "🔴 EXTREME OVERBOUGHT"
    signal = "STRONG SELL"
    desc = "Asset severely overbought. High probability of pullback."
    action = "Consider taking profits. Set tight stop-loss."
elif rsi >= 70:
    zone = "🟠 OVERBOUGHT"
    signal = "SELL / CAUTION"
    desc = "Asset overbought. Momentum may be weakening."
    action = "Watch for bearish divergence. Tighten stops."
elif rsi >= 60:
    zone = "🟡 BULLISH"
    signal = "HOLD / ACCUMULATE"
    desc = "Healthy uptrend. RSI shows strong momentum."
    action = "Hold positions. Trail stops below support."
elif rsi >= 40:
    zone = "⚪ NEUTRAL"
    signal = "WAIT"
    desc = "No clear direction. Market consolidating."
    action = "Wait for breakout above 60 or breakdown below 40."
elif rsi >= 30:
    zone = "🟢 BEARISH"
    signal = "WATCH FOR ENTRY"
    desc = "Downtrend but not yet oversold."
    action = "Watch for bullish divergence near 30."
elif rsi >= 20:
    zone = "🔵 OVERSOLD"
    signal = "BUY / ACCUMULATE"
    desc = "Asset oversold. Bounce likely."
    action = "Look for reversal candles. Scale in gradually."
else:
    zone = "💎 EXTREME OVERSOLD"
    signal = "STRONG BUY"
    desc = "Asset severely oversold. High probability of bounce."
    action = "Strong entry zone. Use dollar-cost averaging."

print(f"\n  Zone:   {zone}")
print(f"  Signal: {signal}")
print(f"  Note:   {desc}")
print(f"  Action: {action}")
print(f"\n  ⚠️  RSI alone is not enough. Combine with price action,")
print(f"     volume, and support/resistance levels.")
print(f"\n📖 More skills: bytesagain.com")
PYEOF
}

cmd_zones() {
    cat << 'EOF'
═══════════════════════════════════════════════════
  RSI Zone Definitions
═══════════════════════════════════════════════════

【Standard Zones (Wilder's original)】
  80-100  🔴 Extreme Overbought — Strong sell signal
  70-80   🟠 Overbought — Sell / reduce positions
  60-70   🟡 Bullish — Uptrend, hold longs
  40-60   ⚪ Neutral — No clear trend
  30-40   🟢 Bearish — Downtrend, watch for entry
  20-30   🔵 Oversold — Buy signal
   0-20   💎 Extreme Oversold — Strong buy signal

【Trending Market Adjustment】
  In strong uptrends, RSI often stays 40-90:
    - Support at 40-50 (not 30)
    - Overbought only above 80

  In strong downtrends, RSI often stays 10-60:
    - Resistance at 50-60 (not 70)
    - Oversold only below 20

【Common Period Settings】
  Period   Use Case
  ─────────────────────────────
  7        Short-term / scalping
  9        Swing trading (crypto)
  14       Standard (Wilder default) ⭐
  21       Medium-term / stocks
  25       Long-term / investing

【Key Rules】
  • RSI > 50 = bullish bias
  • RSI < 50 = bearish bias
  • RSI crossing 50 = trend change signal
  • Never use RSI alone — always confirm with price action

📖 More skills: bytesagain.com
EOF
}

cmd_divergence() {
    cat << 'EOF'
═══════════════════════════════════════════════════
  RSI Divergence Patterns
═══════════════════════════════════════════════════

【Bullish Divergence 🟢 (Buy signal)】
  Price:  Lower Low  ↘
  RSI:    Higher Low ↗

  Meaning: Selling pressure weakening despite lower prices.
  Action:  Look for entry on next candle close above resistance.
  Best at: RSI below 30 (oversold zone)

【Bearish Divergence 🔴 (Sell signal)】
  Price:  Higher High ↗
  RSI:    Lower High  ↘

  Meaning: Buying pressure weakening despite higher prices.
  Action:  Tighten stops. Consider taking profits.
  Best at: RSI above 70 (overbought zone)

【Hidden Bullish Divergence 🟢 (Trend continuation)】
  Price:  Higher Low ↗
  RSI:    Lower Low  ↘

  Meaning: Uptrend pullback. Buyers absorbing dip.
  Action:  Add to long position on support.

【Hidden Bearish Divergence 🔴 (Trend continuation)】
  Price:  Lower High ↘
  RSI:    Higher High ↗

  Meaning: Downtrend rally. Sellers still in control.
  Action:  Look for short entry on resistance rejection.

【Divergence Quality Checklist】
  ✅ RSI in overbought/oversold zone
  ✅ Clear swing highs/lows (not choppy)
  ✅ Divergence spans 5-20 bars (not too tight)
  ✅ Volume confirms (decreasing on divergence move)
  ❌ Ignore divergence in strong trending markets

📖 More skills: bytesagain.com
EOF
}

cmd_strategies() {
    cat << 'EOF'
═══════════════════════════════════════════════════
  RSI Trading Strategies
═══════════════════════════════════════════════════

【Strategy 1: Classic Overbought/Oversold】
  Entry:  Buy when RSI crosses above 30 from below
  Exit:   Sell when RSI crosses below 70 from above
  Stop:   Below recent swing low
  Best:   Range-bound / sideways markets
  Risk:   Fails in strong trends (RSI stays overbought)

【Strategy 2: RSI + Moving Average Combo】
  Setup:  50-period SMA on price chart
  Long:   Price > SMA AND RSI crosses above 40
  Short:  Price < SMA AND RSI crosses below 60
  Edge:   Filters out counter-trend signals

【Strategy 3: RSI Failure Swing (Wilder's original)】
  Bullish Failure Swing:
    1. RSI drops below 30
    2. RSI bounces above 30
    3. RSI pulls back but stays above 30
    4. RSI breaks above the bounce high → BUY

  Bearish Failure Swing:
    1. RSI rises above 70
    2. RSI drops below 70
    3. RSI rallies but stays below 70
    4. RSI breaks below the dip low → SELL

【Strategy 4: Multi-Timeframe RSI】
  Weekly RSI:  Determines trend direction
  Daily RSI:   Determines entry timing

  If Weekly RSI > 50 (bullish trend):
    → Buy when Daily RSI dips to 30-40 (pullback entry)
  If Weekly RSI < 50 (bearish trend):
    → Short when Daily RSI rises to 60-70 (rally entry)

【Strategy 5: RSI Range Shift (Andrew Cardwell)】
  Uptrend:    RSI oscillates between 40-80
  Downtrend:  RSI oscillates between 20-60
  Transition: Watch for RSI breaking out of its range
              → Signals potential trend change

📖 More skills: bytesagain.com
EOF
}

cmd_help() {
    cat << EOF
RSI v${VERSION} — Relative Strength Index Calculator

Commands:
  calculate [period]   Calculate RSI step-by-step (default: 14)
  interpret <value>    Interpret an RSI value with trading signals
  zones                RSI zone definitions and trading rules
  divergence           RSI divergence patterns (bullish/bearish)
  strategies           Common RSI trading strategies
  help                 Show this help
  version              Show version

Usage:
  bash scripts/script.sh calculate 14
  bash scripts/script.sh interpret 72.5
  bash scripts/script.sh zones

Related skills:
  clawhub install macd
  clawhub install atr
Browse all: bytesagain.com

Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    calculate)   shift; cmd_calculate "$@" ;;
    interpret)   shift; cmd_interpret "$@" ;;
    zones)       cmd_zones ;;
    divergence)  cmd_divergence ;;
    strategies)  cmd_strategies ;;
    version)     echo "rsi v${VERSION}" ;;
    help|*)      cmd_help ;;
esac
