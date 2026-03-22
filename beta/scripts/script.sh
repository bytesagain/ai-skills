#!/usr/bin/env bash
# beta — Beta Coefficient & Systematic Risk Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Beta Coefficient ===

Beta (β) measures the sensitivity of an asset's returns to the returns of
a benchmark (usually the market portfolio). It is the cornerstone of
systematic risk measurement in modern finance.

Definition:
  β = Cov(Rᵢ, Rₘ) / Var(Rₘ)

  Rᵢ = Return of asset i
  Rₘ = Return of the market portfolio

Intuition:
  β = 1.0   Asset moves exactly with the market
  β > 1.0   Asset amplifies market moves (more volatile)
  β < 1.0   Asset dampens market moves (less volatile)
  β = 0     Asset is uncorrelated with the market
  β < 0     Asset moves opposite to the market (rare)

Key Properties:
  - Beta captures only SYSTEMATIC risk (market-wide)
  - It does NOT capture firm-specific (idiosyncratic) risk
  - Diversification eliminates idiosyncratic risk, not beta risk
  - The market portfolio has β = 1.0 by definition
  - Risk-free asset has β = 0

History:
  1964    William Sharpe introduces CAPM and beta
  1965    John Lintner independently derives CAPM
  1972    Fischer Black extends to zero-beta version
  1992    Fama-French challenge beta's explanatory power
  2000s   Beta remains central despite multi-factor models
EOF
}

cmd_capm() {
    cat << 'EOF'
=== Capital Asset Pricing Model (CAPM) ===

Formula:
  E(Rᵢ) = Rᶠ + βᵢ × (E(Rₘ) - Rᶠ)

  E(Rᵢ)        Expected return of asset i
  Rᶠ            Risk-free rate (e.g., T-bill yield)
  βᵢ            Beta of asset i
  E(Rₘ)         Expected market return
  E(Rₘ) - Rᶠ    Market risk premium (equity risk premium)

Example:
  Risk-free rate:       3%
  Market return:        10%
  Stock beta:           1.5
  E(Rᵢ) = 3% + 1.5 × (10% - 3%) = 3% + 10.5% = 13.5%

CAPM Assumptions:
  1. Investors are rational mean-variance optimizers
  2. Single-period investment horizon
  3. Homogeneous expectations (everyone agrees on inputs)
  4. No taxes, transaction costs, or short-selling constraints
  5. All assets are infinitely divisible
  6. Investors can borrow/lend at the risk-free rate

Security Market Line (SML):
  E(R) = Rᶠ + β × (E(Rₘ) - Rᶠ)
  - Plots expected return vs beta
  - Assets ABOVE the SML are undervalued (positive alpha)
  - Assets BELOW the SML are overvalued (negative alpha)
  - Alpha (α) = Actual Return - CAPM Expected Return

Capital Market Line (CML):
  E(Rₚ) = Rᶠ + [(E(Rₘ) - Rᶠ) / σₘ] × σₚ
  - Only efficient portfolios lie on the CML
  - Slope = Sharpe ratio of the market portfolio
EOF
}

cmd_calculate() {
    cat << 'EOF'
=== Calculating Beta ===

Method 1: Regression (Most Common)
  Run OLS regression: Rᵢ - Rᶠ = α + β(Rₘ - Rᶠ) + ε
  - Slope coefficient = beta
  - Intercept = Jensen's alpha
  - R² = proportion of variance explained by market

  Practical Steps:
    1. Gather returns (monthly for 3-5 years is standard)
    2. Choose benchmark (S&P 500, MSCI World, sector index)
    3. Calculate excess returns (subtract risk-free rate)
    4. Run regression: Y = asset excess returns, X = market excess returns
    5. Slope = β, Standard error tells you precision

Method 2: Covariance/Variance
  β = Cov(Rᵢ, Rₘ) / Var(Rₘ)
  Equivalent to regression but calculated directly

  Step-by-step:
    1. Calculate mean returns for asset and market
    2. Compute deviations from mean for each period
    3. Multiply paired deviations → covariance
    4. Divide by market variance

Method 3: Correlation-Based
  β = ρ(Rᵢ, Rₘ) × (σᵢ / σₘ)
  Where ρ = correlation, σ = standard deviation

Data Choices That Matter:
  Frequency     Daily, weekly, monthly (monthly = less noise)
  Window        2 years, 3 years, 5 years (longer = more stable)
  Benchmark     S&P 500, Russell 2000, sector index
  Returns       Arithmetic vs logarithmic
  Adjusted      Dividends included or price-only?

  Rule of thumb: 60 monthly observations against a broad index
EOF
}

cmd_interpret() {
    cat << 'EOF'
=== Interpreting Beta Values ===

β > 1.0 — Aggressive / High-Beta
  More volatile than the market
  Amplifies both gains and losses
  Examples: Tech stocks, small caps, leveraged companies
  AAPL historically ~1.2, TSLA ~1.5-2.0
  Higher expected return (per CAPM) to compensate

β = 1.0 — Market-Matching
  Moves in lockstep with the market
  A well-diversified index fund ≈ 1.0
  Useful as a benchmark for comparison

0 < β < 1.0 — Defensive / Low-Beta
  Less volatile than the market
  Dampens market swings
  Examples: Utilities (0.3-0.5), consumer staples (0.5-0.7)
  Lower expected return but smoother ride
  Often called "defensive" stocks

β = 0 — Uncorrelated
  No linear relationship with the market
  Examples: Some commodities, certain hedge fund strategies
  NOT the same as "riskless" — can have high total volatility

β < 0 — Inverse / Negative Beta
  Moves opposite to the market
  Very rare in equities
  Examples: Gold (~-0.1 to 0.1), inverse ETFs (by design)
  Valuable for hedging (natural portfolio insurance)

Important Nuances:
  - Beta is NOT total risk (σ), it's systematic risk only
  - A stock with β=0.5 can still be very volatile (high idiosyncratic risk)
  - Beta changes over time (non-stationary)
  - Industry matters: fintech firm β ≠ traditional bank β
  - Leverage increases beta mechanically
EOF
}

cmd_types() {
    cat << 'EOF'
=== Types of Beta ===

Levered Beta (Equity Beta, βₑ):
  The observed beta from market data
  Reflects BOTH business risk and financial risk (leverage)
  This is what you get from regression on stock returns

Unlevered Beta (Asset Beta, βₐ):
  Removes the effect of financial leverage
  βₐ = βₑ / [1 + (1 - Tax Rate) × (Debt/Equity)]
  Reflects pure business/operating risk
  Used for comparing companies with different capital structures
  Essential for WACC calculations in DCF

Re-levering Beta:
  βₑ = βₐ × [1 + (1 - Tax Rate) × (Debt/Equity)]
  Apply target company's capital structure to peer's asset beta
  Used when the target has no publicly traded equity

Adjusted Beta (Bloomberg Beta):
  βₐdⱼ = (2/3) × Raw β + (1/3) × 1.0
  Shrinks raw beta toward 1.0 (mean-reversion assumption)
  Rationale: betas tend to regress toward the market average
  Vasicek adjustment uses Bayesian shrinkage with standard error

Bottom-Up Beta:
  Average the unlevered betas of comparable public companies
  Re-lever using the target company's D/E ratio
  Advantages:
    - More stable than single-stock regression
    - Usable for private companies
    - Forward-looking (can adjust for changing business mix)
  Steps:
    1. Identify comparable companies
    2. Get each company's levered beta
    3. Unlever each using their D/E ratios
    4. Average the unlevered betas
    5. Re-lever using the target's D/E ratio

Fundamental Beta:
  Estimated from company fundamentals, not market data
  Factors: size, leverage, earnings variability, dividend yield, growth
  Used by Barra/MSCI risk models
EOF
}

cmd_portfolio() {
    cat << 'EOF'
=== Portfolio Beta ===

Portfolio Beta = Weighted Average:
  βₚ = Σ(wᵢ × βᵢ)
  Where wᵢ = weight of asset i in portfolio

Example:
  Asset A: 40% weight, β = 1.2 → contribution = 0.48
  Asset B: 35% weight, β = 0.8 → contribution = 0.28
  Asset C: 25% weight, β = 1.5 → contribution = 0.375
  Portfolio β = 0.48 + 0.28 + 0.375 = 1.135

Target Beta Construction:
  To achieve a target beta, solve for weights
  For β-neutral portfolio (βₚ = 0):
    Long high-β stocks + Short enough to offset
    Example: Long $100 of β=1.2, Short $120 of β=1.0
    Net β = (1.0)(1.2) + (-1.2)(1.0) = 0

Beta Hedging with Futures:
  Number of contracts = (βₜ - βₚ) × (Portfolio Value / Futures Value)
  βₜ = target beta
  βₚ = current portfolio beta

  To eliminate market risk (βₜ = 0):
    If portfolio = $10M, β = 1.3, S&P futures = $250,000
    Contracts = (0 - 1.3) × (10,000,000 / 250,000) = -52
    Short 52 futures contracts

Portable Alpha Strategy:
  1. Generate alpha in any asset class
  2. Use futures/swaps to overlay desired beta exposure
  3. Total return = Alpha + Beta × Market Return

Smart Beta / Factor Investing:
  Low-volatility anomaly: low-β stocks have historically outperformed
  on a risk-adjusted basis (contradicts CAPM)
  Minimum variance portfolios tilt toward low-beta stocks
EOF
}

cmd_pitfalls() {
    cat << 'EOF'
=== Common Pitfalls in Beta Estimation ===

1. Estimation Window:
   Too short (< 1 year): noisy, unreliable
   Too long (> 5 years): may not reflect current business
   Standard: 3-5 years of monthly data (60 observations)
   Exception: fast-changing firms → use 2 years weekly

2. Benchmark Choice:
   S&P 500 for US large-caps
   Russell 2000 for US small-caps
   MSCI EAFE for international
   Wrong benchmark → misleading beta
   Example: measuring a Japanese stock vs S&P 500 = bad idea

3. Return Frequency:
   Daily: more data points but noisy (microstructure effects)
   Weekly: reasonable compromise
   Monthly: standard for practitioners
   Thin-trading bias: illiquid stocks show downward-biased beta
   Fix: use Dimson beta (lagged market returns in regression)

4. Non-Stationarity:
   Beta changes over time — it's NOT a constant
   Company events: M&A, leverage changes, new business lines
   Market regime: betas increase during crises (correlation spike)
   Rolling-window beta: use 36-month rolling to visualize shifts

5. Survivorship Bias:
   Using only surviving companies overestimates historical returns
   Failed companies (often high-beta) drop out of the sample

6. Beta ≠ Total Risk:
   High R² → most risk is systematic (beta captures it)
   Low R² → most risk is idiosyncratic (beta misses it)
   Biotech: β=1.5 but R²=0.10 (drug trial risk dominates)

7. Leverage Distortion:
   Highly levered firms have mechanically higher equity beta
   Always unlever before comparing business risk across firms
   A company that doubles debt will roughly double its equity beta

8. Negative Beta Illusion:
   Very few assets have truly negative beta
   Often an artifact of low correlation + noise
   Test: is the negative beta statistically significant?
EOF
}

cmd_examples() {
    cat << 'EOF'
=== Beta Worked Examples ===

--- Example 1: Calculating Beta from Returns ---
Month  Stock   Market
  1     +4%     +3%
  2     -2%     -1%
  3     +6%     +4%
  4     -3%     -2%
  5     +5%     +3%

Mean stock = 2.0%, Mean market = 1.4%

Covariance calculation:
  Σ[(Rᵢ - R̄ᵢ)(Rₘ - R̄ₘ)] / (n-1)
  = [(4-2)(3-1.4) + (-2-2)(-1-1.4) + (6-2)(4-1.4)
     + (-3-2)(-2-1.4) + (5-2)(3-1.4)] / 4
  = [3.2 + 9.6 + 10.4 + 17.0 + 4.8] / 4
  = 11.25

Var(market) = Σ(Rₘ - R̄ₘ)² / (n-1)
  = [2.56 + 5.76 + 6.76 + 11.56 + 2.56] / 4 = 7.30

β = 11.25 / 7.30 = 1.54

--- Example 2: CAPM Expected Return ---
  Risk-free rate = 4.0%
  Market premium = 6.0% (historical average)
  Stock beta = 1.54
  E(R) = 4.0% + 1.54 × 6.0% = 13.24%

--- Example 3: Unlevering / Re-levering ---
Company A (comparable):
  Equity β = 1.4, D/E = 0.5, Tax = 25%
  Asset β = 1.4 / [1 + (1-0.25)(0.5)] = 1.4 / 1.375 = 1.018

Target company:
  D/E = 0.8, Tax = 25%
  Equity β = 1.018 × [1 + (1-0.25)(0.8)] = 1.018 × 1.6 = 1.629

--- Example 4: Portfolio Beta Hedging ---
  Portfolio: $5M, current β = 1.2
  Goal: reduce to β = 0.7
  S&P 500 futures: $250,000 per contract, β = 1.0
  Contracts = (0.7 - 1.2) × (5,000,000 / 250,000) = -10
  Short 10 futures contracts
EOF
}

show_help() {
    cat << EOF
beta v$VERSION — Beta Coefficient & Systematic Risk Reference

Usage: script.sh <command>

Commands:
  intro        Beta overview — definition, intuition, history
  capm         Capital Asset Pricing Model formula and components
  calculate    How to calculate beta — regression and variance methods
  interpret    What beta values mean — aggressive, defensive, negative
  types        Levered, unlevered, adjusted, bottom-up, fundamental beta
  portfolio    Portfolio beta, hedging, target construction
  pitfalls     Common estimation errors and how to avoid them
  examples     Worked calculations with real-world scenarios
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    capm)       cmd_capm ;;
    calculate)  cmd_calculate ;;
    interpret)  cmd_interpret ;;
    types)      cmd_types ;;
    portfolio)  cmd_portfolio ;;
    pitfalls)   cmd_pitfalls ;;
    examples)   cmd_examples ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "beta v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
