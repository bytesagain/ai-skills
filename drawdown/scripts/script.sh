#!/usr/bin/env bash
# drawdown — Drawdown Analysis & Risk Measurement Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Drawdown Analysis ===

A drawdown is the decline from a historical peak in the value of a
portfolio, fund, or asset. It measures how much you've lost from
the highest point before a new high is reached.

Definition:
  Drawdown(t) = [Peak(t) - Value(t)] / Peak(t)
  Where Peak(t) = maximum value from inception to time t

Key Concepts:
  Peak           The highest portfolio value achieved so far
  Trough         The lowest point during a drawdown period
  Drawdown       The percentage decline from peak to current value
  Max Drawdown   The largest peak-to-trough decline ever observed
  Recovery       The period from trough back to previous peak
  Underwater     The total time spent below the previous peak

Why Drawdown Matters:
  1. Captures REAL investor pain (not abstract volatility)
  2. Shows worst-case scenario (what you'd have actually lived through)
  3. Accounts for path dependency (order of returns matters)
  4. Sticky: a 50% loss requires a 100% gain to recover
  5. Behavioral: investors abandon strategies during drawdowns

Types of Drawdown:
  Maximum Drawdown (MDD)    Largest ever peak-to-trough decline
  Average Drawdown          Mean of all drawdown periods
  Current Drawdown          How far below the current peak right now
  Longest Drawdown          Maximum time spent underwater
  Conditional Drawdown      Expected drawdown in worst X% of cases
EOF
}

cmd_calculate() {
    cat << 'EOF'
=== Calculating Drawdown ===

Step-by-Step Algorithm:
  1. Track running peak: Peak(t) = max(Value(0), ..., Value(t))
  2. At each time t: DD(t) = [Peak(t) - Value(t)] / Peak(t)
  3. Maximum Drawdown = max(DD(t)) for all t

Example:
  Day  Value   Peak   Drawdown
  1    100     100    0.0%
  2    105     105    0.0%
  3    98      105    -6.7%    ← drawdown begins
  4    92      105    -12.4%
  5    88      105    -16.2%   ← trough
  6    95      105    -9.5%    ← recovering
  7    103     105    -1.9%
  8    108     108    0.0%     ← new peak (drawdown ends)
  9    102     108    -5.6%    ← new drawdown begins

  Maximum Drawdown = 16.2% (day 2 peak → day 5 trough)
  Drawdown Duration = 6 days (day 3 to day 8)
  Recovery Time = 3 days (day 5 to day 8)

In Dollar Terms:
  MDD$ = Peak$ - Trough$
  Example: $105 - $88 = $17 per unit

Annualized Maximum Drawdown:
  Not commonly annualized — MDD is typically reported as-is
  Longer track records naturally show larger MDDs

Rolling Drawdown:
  Calculate MDD over a rolling window (e.g., 12 months)
  Shows how worst-case loss evolves over time
  Useful for detecting regime changes in risk

Drawdown Series:
  Plot DD(t) as a time series → "underwater curve"
  Shows how long the portfolio spends below each peak
  Deeper/wider underwater periods = more investor pain
EOF
}

cmd_metrics() {
    cat << 'EOF'
=== Drawdown-Based Risk Metrics ===

Maximum Drawdown (MDD):
  MDD = max peak-to-trough decline over entire period
  Simple, intuitive, worst-case measure
  Limitation: single worst event, doesn't capture frequency

Calmar Ratio:
  = Annualized Return / Maximum Drawdown
  Higher = better risk-adjusted return per unit of worst loss
  Example: 12% return / 20% MDD = 0.60
  Benchmarks:
    < 0.5   Poor
    0.5-1.0 Acceptable
    1.0-2.0 Good
    > 2.0   Excellent (rare, often unsustainable)

Sterling Ratio:
  = Annualized Return / (Average Annual MDD - 10%)
  The -10% is a "risk-free" adjustment (somewhat arbitrary)
  Modified Sterling: just use Average Annual MDD

Ulcer Index (UI):
  = sqrt(mean(DD(t)²))
  Like standard deviation, but only for downside
  Captures both depth and duration of drawdowns
  Martin Ratio = (Return - Rᶠ) / Ulcer Index

Pain Index:
  = mean(|DD(t)|)
  Average depth of the underwater curve
  Pain Ratio = (Return - Rᶠ) / Pain Index

Burke Ratio:
  = (Return - Rᶠ) / sqrt(Σ DD²ᵢ)
  Uses sum of squared drawdowns (penalizes frequent drawdowns)

Conditional Drawdown at Risk (CDaR):
  Average of the worst X% of drawdowns
  Like CVaR (Expected Shortfall) but for drawdowns
  Example: CDaR(95%) = average of top 5% worst drawdowns

  Comparison:
    MDD           Single worst event
    CDaR(95%)     Average of worst 5% (more robust)
    Ulcer Index   Ongoing pain measure (depth × duration)
    Pain Index    Average underwater depth
EOF
}

cmd_historical() {
    cat << 'EOF'
=== Major Historical Drawdowns ===

US Stock Market (S&P 500):
  1929-1932  Great Depression      -86%   Recovery: 25 years (1954)
  1937-1942  WWII Bear Market      -60%   Recovery: 6 years
  1973-1974  Oil Crisis/Stagflation -48%  Recovery: 7 years
  1987       Black Monday           -34%  Recovery: 2 years
  2000-2002  Dot-com Bust          -49%   Recovery: 7 years
  2007-2009  Global Financial Crisis -57%  Recovery: 5.5 years
  2020       COVID Crash            -34%  Recovery: 5 months
  2022       Rate Hike Bear         -25%  Recovery: ~2 years

Key Observations:
  - Average bear market drawdown: ~35%
  - Average recovery time: 3-5 years
  - Deeper drawdowns have disproportionately longer recoveries
  - The 1929 crash took 25 YEARS to recover (in nominal terms)

Other Markets:
  Japan Nikkei 225   1989-2009  -82%  (30+ years to recover, 2024)
  NASDAQ             2000-2002  -78%  Recovery: 15 years
  Bitcoin            2017-2018  -83%  Recovery: 3 years
  Bitcoin            2021-2022  -77%  Recovery: ~2 years
  Gold               1980-1999  -70%  Recovery: 28 years
  US Bonds (AGG)     2020-2023  -18%  Worst bond drawdown in decades

Lessons:
  1. 50%+ drawdowns happen roughly once per generation
  2. Diversification reduces drawdown but doesn't eliminate it
  3. Leverage amplifies drawdowns (LTCM: -92% in months)
  4. Timing recoveries is nearly impossible
  5. Having cash during drawdowns is the best opportunity
EOF
}

cmd_management() {
    cat << 'EOF'
=== Drawdown Management ===

Position Sizing by Drawdown Budget:
  Max acceptable drawdown = your risk budget
  Position size = Risk Budget / Expected Worst Drawdown

  Example:
    Risk budget: 15% portfolio drawdown max
    Strategy expected MDD: 30%
    Max allocation = 15% / 30% = 50% of portfolio

  Kelly-adjusted:
    Half-Kelly (conservative) is standard
    Full Kelly maximizes growth but has ~50% MDD typically

Stop-Loss Strategies:
  Fixed Stop:      Sell if down X% from entry (e.g., -8%)
  Trailing Stop:   Sell if down X% from highest price since entry
  Time Stop:       Sell if no recovery within N months
  Volatility Stop: Stop distance = X × ATR (average true range)

  Tradeoffs:
    Tight stops: limit drawdowns but increase whipsaws
    Wide stops: fewer false signals but deeper drawdowns
    No stops: full drawdowns but no whipsaw cost

Risk Budgeting:
  Allocate total risk budget across strategies
  Example: 20% max DD budget across 4 strategies
    Strategy A: 5% budget (low vol, 10% expected MDD at 50% alloc)
    Strategy B: 5% budget (medium vol)
    Strategy C: 5% budget (medium vol)
    Strategy D: 5% budget (high vol, 25% expected MDD at 20% alloc)

Drawdown Circuit Breakers:
  Reduce position size as drawdown deepens:
    0-5% DD:    Full position (100%)
    5-10% DD:   Reduce to 75%
    10-15% DD:  Reduce to 50%
    15-20% DD:  Reduce to 25%
    >20% DD:    Flat (reassess strategy)

  Benefit: limits max loss
  Cost: slower recovery (you reduce exposure near the bottom)
EOF
}

cmd_recovery() {
    cat << 'EOF'
=== Recovery Analysis ===

The Asymmetry of Losses:
  Loss       Gain Needed to Recover
  -10%       +11.1%
  -20%       +25.0%
  -30%       +42.9%
  -40%       +66.7%
  -50%       +100.0%     ← must DOUBLE to recover
  -60%       +150.0%
  -70%       +233.3%
  -80%       +400.0%
  -90%       +900.0%

  Formula: Required gain = Loss / (1 - Loss)
  This is why drawdown prevention is more important than maximizing returns

Recovery Time Factors:
  1. Depth of drawdown (deeper = exponentially longer)
  2. Expected return going forward
  3. Volatility during recovery (drag on compound returns)
  4. Continued contributions (dollar-cost averaging helps)
  5. Market regime (V-shape vs L-shape recovery)

Time to Recover (simplified):
  T = -ln(1 - DD) / ln(1 + r)
  Where DD = drawdown fraction, r = expected annual return

  Example: 50% drawdown, 8% annual return
  T = -ln(0.5) / ln(1.08) = 0.693 / 0.077 = 9 years

Recovery Patterns:
  V-shape:   Sharp decline, sharp recovery (COVID 2020)
  U-shape:   Decline, extended bottom, gradual recovery
  L-shape:   Decline, no meaningful recovery for years (Japan)
  W-shape:   False recovery, second decline, then real recovery

Impact of Volatility on Recovery:
  "Volatility drag" slows compound growth:
    Arithmetic return: (50% + -50%) / 2 = 0%
    Actual return: $100 → $150 → $75 = -25%
  Higher volatility during recovery = slower actual recovery
  This is why reducing volatility matters, not just returns
EOF
}

cmd_comparison() {
    cat << 'EOF'
=== Drawdown vs Other Risk Measures ===

Volatility (Standard Deviation):
  Pros: mathematically clean, widely understood, symmetric
  Cons: penalizes upside equally, doesn't capture tail risk
  vs DD: volatility says "how bumpy," drawdown says "how painful"

Value at Risk (VaR):
  "With 95% confidence, loss won't exceed X% in one day/month"
  Pros: simple probability statement, regulatory standard
  Cons: says nothing about what happens BEYOND VaR
  vs DD: VaR is a point estimate, drawdown is a path measure

Conditional VaR (CVaR / Expected Shortfall):
  Average loss in the worst X% of scenarios
  Pros: captures tail risk, coherent risk measure
  Cons: still single-period, needs distribution assumptions
  vs DD: CVaR captures tail depth, drawdown captures duration too

Sortino Ratio:
  = (Return - Target) / Downside Deviation
  Pros: only penalizes downside volatility
  Cons: still deviation-based, doesn't capture max loss
  vs DD: Sortino is a ratio, MDD is the actual worst experience

Comparison Table:
  Measure     Captures    Time Aware?   Intuitive?   Path Dependent?
  Volatility  Dispersion  No            Moderate     No
  VaR         Tail risk   No            Yes          No
  CVaR        Tail avg    No            Moderate     No
  Sortino     Downside    No            Moderate     No
  MDD         Worst loss  Yes           Very         Yes
  Ulcer Index Ongoing pain Yes          Moderate     Yes
  Calmar      Return/MDD  Yes           Yes          Yes

Recommendation:
  Use multiple measures together:
    - Volatility for day-to-day risk
    - VaR/CVaR for tail risk budgeting
    - MDD for worst-case scenarios
    - Calmar/Ulcer for risk-adjusted performance
EOF
}

cmd_examples() {
    cat << 'EOF'
=== Drawdown Worked Examples ===

--- Example 1: Calculate MDD from Return Series ---
Month  Return   Value    Peak    Drawdown
  0      —      1000     1000    0.0%
  1    +5.0%    1050     1050    0.0%
  2    -3.0%    1018.5   1050    -3.0%
  3    -7.0%     947.2   1050    -9.8%
  4    -4.0%     909.3   1050    -13.4%   ← MDD
  5    +8.0%     982.1   1050    -6.5%
  6    +6.0%    1041.0   1050    -0.9%
  7    +2.0%    1061.8   1061.8   0.0%   ← recovered

  MDD = 13.4% (month 1 peak to month 4 trough)
  Recovery time = 3 months (month 4 to month 7)
  Underwater period = 5 months (month 2 to month 7)

--- Example 2: Calmar Ratio Comparison ---
  Fund A: 15% annual return, 25% MDD → Calmar = 0.60
  Fund B: 10% annual return, 12% MDD → Calmar = 0.83
  Fund C: 20% annual return, 40% MDD → Calmar = 0.50

  Fund B has the best risk-adjusted return per worst loss
  Fund C has highest return but worst drawdown experience

--- Example 3: Position Sizing ---
  Risk budget: 10% max portfolio drawdown
  Strategy X has 30% historical MDD

  Max allocation = 10% / 30% = 33.3%
  Allocate 33% to Strategy X, rest to cash/bonds

  With leverage consideration:
    2x leveraged: expected MDD ≈ 60%
    Max allocation = 10% / 60% = 16.7%

--- Example 4: Recovery Time ---
  Portfolio drops 40% during a crisis
  Expected going-forward return: 10%/year
  T = -ln(0.60) / ln(1.10) = 0.511 / 0.0953 = 5.4 years
  With 7% return: T = 0.511 / 0.0677 = 7.5 years
EOF
}

show_help() {
    cat << EOF
drawdown v$VERSION — Drawdown Analysis & Risk Measurement Reference

Usage: script.sh <command>

Commands:
  intro        Drawdown overview — definition, types, significance
  calculate    How to calculate drawdown step-by-step
  metrics      Key metrics — MDD, Calmar, Ulcer Index, Pain Index
  historical   Major market drawdowns and recovery timelines
  management   Position sizing, stop-losses, risk budgeting
  recovery     Math of recovery, loss asymmetry, recovery patterns
  comparison   Drawdown vs volatility, VaR, CVaR, Sortino
  examples     Worked calculations and strategy comparisons
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    calculate)   cmd_calculate ;;
    metrics)     cmd_metrics ;;
    historical)  cmd_historical ;;
    management)  cmd_management ;;
    recovery)    cmd_recovery ;;
    comparison)  cmd_comparison ;;
    examples)    cmd_examples ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "drawdown v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
