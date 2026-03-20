---
version: "2.4.0"
name: Option Calculator
description: "Price options, compute Greeks, and plot P&L diagrams with exercise analysis. Use when pricing options, calculating Greeks, visualizing profit-loss curves."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Option Calculator

A Black-Scholes option pricing toolkit that runs entirely in your terminal. Feed it a spot price, strike, volatility, and time to expiration — it returns theoretical prices, Greeks, implied volatility, payoff tables, and more.

All math is computed inline via Python 3 using the Abramowitz & Stegun approximation for the normal CDF (no scipy dependency).

## Commands

### `price`

```
option-calculator price <type> <spot> <strike> <rate> <vol> <days>
```

Compute the Black-Scholes theoretical price for a European call or put.

| Argument | Description |
|----------|-------------|
| `type` | `call` or `put` |
| `spot` | Current underlying price |
| `strike` | Strike price |
| `rate` | Risk-free rate (annualized, e.g. `0.05`) |
| `vol` | Implied volatility (annualized, e.g. `0.20`) |
| `days` | Days to expiration |

### `greeks`

```
option-calculator greeks <type> <spot> <strike> <rate> <vol> <days>
```

Compute the five standard Greeks: Delta, Gamma, Theta (per day), Vega (per 1% vol move), and Rho (per 1% rate move). Same arguments as `price`.

### `iv`

```
option-calculator iv <type> <spot> <strike> <rate> <days> <market_price>
```

Back out the implied volatility from a known market price using Newton-Raphson iteration. Converges to 1e-8 precision within 200 iterations.

| Argument | Description |
|----------|-------------|
| `market_price` | The observed option premium |

### `payoff`

```
option-calculator payoff <type> <strike> <premium> [range]
```

Print a table showing intrinsic value and net P/L at expiration across a range of underlying prices. Default range is ±20 around the strike.

### `compare`

```
option-calculator compare <spot> <strike1> <strike2> <vol> <days>
```

Side-by-side comparison of two strikes — call price, put price, deltas, and gamma. Uses a fixed risk-free rate of 5%.

### `chain`

```
option-calculator chain <spot> <vol> <days>
```

Generate a full option chain with calls, puts, deltas, and gamma across strikes from ~80% to ~120% of spot. Each row is flagged as ITM, ATM, or OTM relative to the call side.

### `pnl`

```
option-calculator pnl <type> <entry> <current> <qty>
```

Calculate profit or loss on an existing position. Assumes standard 100 shares per contract. Use negative `qty` for short positions.

### `breakeven`

```
option-calculator breakeven <type> <strike> <premium>
```

Compute the breakeven underlying price at expiration and show max loss for the buyer.

### `help`

```
option-calculator help
```

Print the built-in usage guide.

### `version`

```
option-calculator version
```

Print the current version string.

## Examples

```bash
# Price a 30-day call: spot=100, strike=105, rate=5%, vol=20%
$ option-calculator price call 100 105 0.05 0.20 30
Black-Scholes Price (call):
  0.7677

# Greeks for a 60-day put: spot=50, strike=48, rate=3%, vol=35%
$ option-calculator greeks put 50 48 0.03 0.35 60
Greeks (put)  S=50 K=48 r=0.03 σ=0.35 T=60d
──────────────────────────────────
Delta:  -0.312245
Gamma:  0.052040
Theta:  -0.020369  (per day)
Vega:   0.074853  (per 1% vol)
Rho:    -0.029259  (per 1% rate)

# Solve implied volatility from a market price of 3.50
$ option-calculator iv call 100 105 0.05 30 3.50
Implied Volatility Solver (call)  S=100 K=105 r=0.05 T=30d  Market=3.50
──────────────────────────────────
Implied Volatility: 0.416566  (41.66%)

# Payoff table for a call, strike=100, premium=5.50
$ option-calculator payoff call 100 5.50
Payoff Table (call)  K=100  Premium=5.50
──────────────────────────────────
  Underlying    Intrinsic       Net P/L
------------------------------------
       80.00        0.00       -5.50
       85.00        0.00       -5.50
       ...
      100.00        0.00       -5.50 <-- strike
      105.00        5.00       -0.50
      106.00        6.00       +0.50
      110.00       10.00       +4.50
      120.00       20.00      +14.50

# Compare two strikes
$ option-calculator compare 100 95 110 0.25 45
Strike Comparison  S=100  K1=95 vs K2=110  σ=0.25 T=45d
──────────────────────────────────
                      Strike 95.0   Strike 110.0
------------------------------------------------
        Call Price         7.0150         0.7353
         Put Price         1.4312        10.0593
        Call Delta      +0.793714      +0.135799
         Put Delta      -0.206286      -0.864201
             Gamma       0.035611       0.028346

Spot: 100.0  |  Rate: 0.05  |  Vol: 0.25  |  Days: 45.0

# Generate an option chain
$ option-calculator chain 100 0.25 45
Option Chain  |  Spot: 100.0  |  Vol: 25%  |  Days: 45  |  Rate: 0.05
  Strike      Call   C.Delta       Put   P.Delta     Gamma  IV flag
--------------------------------------------------------------
     90.00   10.7823  +0.9268    0.2279  -0.0732  0.012463  ITM
     93.00    8.1952  +0.8639    0.6229  -0.1361  0.019087  ITM
    100.00    3.6738  +0.5580    3.0651  -0.4420  0.032208  ATM
     ...
    110.00    0.8916  +0.1623   10.2497  -0.8377  0.019938  OTM
     ...
    110.00    0.8916  +0.1623   10.2497  -0.8377  0.019938  OTM

# P/L on a long position: bought 5 call contracts at 3.20, now worth 4.80
$ option-calculator pnl call 3.20 4.80 5
Position P/L
──────────────────────────────────
Position:    Long 5x call
Entry:       3.2000
Current:     4.8000
P/L per contract: +1.6000
Total P/L:   +800.00  (+50.00%)

# Breakeven for a put
$ option-calculator breakeven put 100 4.50
Breakeven Analysis
──────────────────────────────────
Put Breakeven: 95.5000
  Strike (100.00) - Premium (4.5000)
  Underlying must fall below 95.5000 to profit at expiration.
  Max loss (buyer): 4.5000 per share
```

## Configuration

The data directory defaults to `$HOME/.option-calculator/`. It stores a `history.log` file that records each `price` command you run for later reference.

Override the directory by setting the `OPTION_CALCULATOR_DIR` environment variable before invoking the tool:

```bash
export OPTION_CALCULATOR_DIR="/tmp/my-options"
```

## Data Storage

| File | Purpose |
|------|---------|
| `$HOME/.option-calculator/history.log` | Append-only log of pricing commands and results |

The directory is created automatically on first run.

## Requirements

- **bash** 4.0+
- **python3** (standard library only — `math` module)
- No third-party Python packages needed

## When to Use

- Pricing a European option before placing a trade
- Checking how Greeks shift across different strikes or expirations
- Backing out implied volatility from a quoted premium
- Comparing strikes to decide which contract to buy/sell
- Generating a quick option chain for scenario analysis
- Calculating breakeven and P/L on existing positions

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
