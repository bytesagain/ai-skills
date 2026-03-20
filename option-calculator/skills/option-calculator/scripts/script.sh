#!/usr/bin/env bash
# option-calculator — Black-Scholes option pricing & Greeks calculator
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="2.4.0"
DATA_DIR="$HOME/.option-calculator"
mkdir -p "$DATA_DIR"

# ─── Help ───────────────────────────────────────────────────────────────────────

show_help() {
    cat << 'EOF'
option-calculator v1.0.0

Black-Scholes option pricing toolkit.

Usage: option-calculator <command> [args]

Commands:
  price   <type> <spot> <strike> <rate> <vol> <days>
          Price a call or put using Black-Scholes.
            type   = call | put
            spot   = current underlying price
            strike = strike price
            rate   = risk-free rate (annualized, e.g. 0.05 for 5%)
            vol    = volatility (annualized, e.g. 0.20 for 20%)
            days   = days to expiration

  greeks  <type> <spot> <strike> <rate> <vol> <days>
          Compute Delta, Gamma, Theta, Vega, and Rho.

  iv      <type> <spot> <strike> <rate> <days> <market_price>
          Solve for implied volatility given a market price.

  payoff  <type> <strike> <premium> [range]
          Print a payoff table at expiration.
            range = price range around strike (default: 20)

  compare <spot> <strike1> <strike2> <vol> <days>
          Side-by-side comparison of two strikes (rate=0.05).

  chain   <spot> <vol> <days>
          Generate an option chain across multiple strikes.

  pnl     <type> <entry> <current> <qty>
          Calculate profit/loss on a position.
            type  = call | put
            entry = premium paid per contract
            current = current premium
            qty   = number of contracts (negative = short)

  breakeven <type> <strike> <premium>
          Compute the breakeven underlying price at expiration.

  help    Show this help message.
  version Print version.

Examples:
  option-calculator price call 100 105 0.05 0.20 30
  option-calculator greeks put 50 48 0.03 0.35 60
  option-calculator iv call 100 105 0.05 30 3.50
  option-calculator payoff call 100 5.50
  option-calculator chain 100 0.25 45
EOF
}

# ─── Black-Scholes core (Python inline) ─────────────────────────────────────────

bs_price() {
    local opt_type="$1" spot="$2" strike="$3" rate="$4" vol="$5" days="$6"
    python3 << PYEOF
import math

def norm_cdf(x):
    """Abramowitz & Stegun approximation (error < 7.5e-8)."""
    if x < -10:
        return 0.0
    if x > 10:
        return 1.0
    a1, a2, a3, a4, a5 = 0.254829592, -0.284496736, 1.421413741, -1.453152027, 1.061405429
    p = 0.3275911
    sign = 1 if x >= 0 else -1
    x_abs = abs(x)
    t = 1.0 / (1.0 + p * x_abs)
    y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * math.exp(-x_abs * x_abs / 2.0)
    return 0.5 * (1.0 + sign * y)

def norm_pdf(x):
    return math.exp(-0.5 * x * x) / math.sqrt(2.0 * math.pi)

opt_type = "${opt_type}"
S = float(${spot})
K = float(${strike})
r = float(${rate})
sigma = float(${vol})
days = float(${days})
T = days / 365.0

if T <= 0 or sigma <= 0:
    print("ERROR: days and vol must be positive")
    raise SystemExit(1)

d1 = (math.log(S / K) + (r + 0.5 * sigma ** 2) * T) / (sigma * math.sqrt(T))
d2 = d1 - sigma * math.sqrt(T)

if opt_type == "call":
    price = S * norm_cdf(d1) - K * math.exp(-r * T) * norm_cdf(d2)
else:
    price = K * math.exp(-r * T) * norm_cdf(-d2) - S * norm_cdf(-d1)

print(f"{price:.4f}")
PYEOF
}

# ─── Greeks ──────────────────────────────────────────────────────────────────────

bs_greeks() {
    local opt_type="$1" spot="$2" strike="$3" rate="$4" vol="$5" days="$6"
    python3 << PYEOF
import math

def norm_cdf(x):
    if x < -10:
        return 0.0
    if x > 10:
        return 1.0
    a1, a2, a3, a4, a5 = 0.254829592, -0.284496736, 1.421413741, -1.453152027, 1.061405429
    p = 0.3275911
    sign = 1 if x >= 0 else -1
    x_abs = abs(x)
    t = 1.0 / (1.0 + p * x_abs)
    y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * math.exp(-x_abs * x_abs / 2.0)
    return 0.5 * (1.0 + sign * y)

def norm_pdf(x):
    return math.exp(-0.5 * x * x) / math.sqrt(2.0 * math.pi)

opt_type = "${opt_type}"
S = float(${spot})
K = float(${strike})
r = float(${rate})
sigma = float(${vol})
days = float(${days})
T = days / 365.0

if T <= 0 or sigma <= 0:
    print("ERROR: days and vol must be positive")
    raise SystemExit(1)

sqrtT = math.sqrt(T)
d1 = (math.log(S / K) + (r + 0.5 * sigma ** 2) * T) / (sigma * sqrtT)
d2 = d1 - sigma * sqrtT

# Delta
if opt_type == "call":
    delta = norm_cdf(d1)
else:
    delta = norm_cdf(d1) - 1.0

# Gamma (same for call and put)
gamma = norm_pdf(d1) / (S * sigma * sqrtT)

# Theta (per day)
term1 = -(S * norm_pdf(d1) * sigma) / (2.0 * sqrtT)
if opt_type == "call":
    theta = (term1 - r * K * math.exp(-r * T) * norm_cdf(d2)) / 365.0
else:
    theta = (term1 + r * K * math.exp(-r * T) * norm_cdf(-d2)) / 365.0

# Vega (per 1% move in vol)
vega = S * norm_pdf(d1) * sqrtT / 100.0

# Rho (per 1% move in rate)
if opt_type == "call":
    rho = K * T * math.exp(-r * T) * norm_cdf(d2) / 100.0
else:
    rho = -K * T * math.exp(-r * T) * norm_cdf(-d2) / 100.0

print(f"Delta:  {delta:+.6f}")
print(f"Gamma:  {gamma:.6f}")
print(f"Theta:  {theta:+.6f}  (per day)")
print(f"Vega:   {vega:.6f}  (per 1% vol)")
print(f"Rho:    {rho:+.6f}  (per 1% rate)")
PYEOF
}

# ─── Implied Volatility ─────────────────────────────────────────────────────────

bs_iv() {
    local opt_type="$1" spot="$2" strike="$3" rate="$4" days="$5" market_price="$6"
    python3 << PYEOF
import math

def norm_cdf(x):
    if x < -10:
        return 0.0
    if x > 10:
        return 1.0
    a1, a2, a3, a4, a5 = 0.254829592, -0.284496736, 1.421413741, -1.453152027, 1.061405429
    p = 0.3275911
    sign = 1 if x >= 0 else -1
    x_abs = abs(x)
    t = 1.0 / (1.0 + p * x_abs)
    y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * math.exp(-x_abs * x_abs / 2.0)
    return 0.5 * (1.0 + sign * y)

def norm_pdf(x):
    return math.exp(-0.5 * x * x) / math.sqrt(2.0 * math.pi)

def bs_price(S, K, r, sigma, T, opt_type):
    sqrtT = math.sqrt(T)
    d1 = (math.log(S / K) + (r + 0.5 * sigma ** 2) * T) / (sigma * sqrtT)
    d2 = d1 - sigma * sqrtT
    if opt_type == "call":
        return S * norm_cdf(d1) - K * math.exp(-r * T) * norm_cdf(d2)
    else:
        return K * math.exp(-r * T) * norm_cdf(-d2) - S * norm_cdf(-d1)

def bs_vega(S, K, r, sigma, T):
    sqrtT = math.sqrt(T)
    d1 = (math.log(S / K) + (r + 0.5 * sigma ** 2) * T) / (sigma * sqrtT)
    return S * norm_pdf(d1) * sqrtT

opt_type = "${opt_type}"
S = float(${spot})
K = float(${strike})
r = float(${rate})
days = float(${days})
T = days / 365.0
target = float(${market_price})

if T <= 0:
    print("ERROR: days must be positive")
    raise SystemExit(1)

# Newton-Raphson
sigma = 0.3  # initial guess
for i in range(200):
    price = bs_price(S, K, r, sigma, T, opt_type)
    vega = bs_vega(S, K, r, sigma, T)
    if vega < 1e-12:
        break
    diff = price - target
    if abs(diff) < 1e-8:
        break
    sigma = sigma - diff / vega
    if sigma <= 0.0001:
        sigma = 0.0001

if abs(bs_price(S, K, r, sigma, T, opt_type) - target) > 0.01:
    print("WARNING: IV solver may not have converged")

print(f"Implied Volatility: {sigma:.6f}  ({sigma * 100:.2f}%)")
PYEOF
}

# ─── Payoff Table ────────────────────────────────────────────────────────────────

bs_payoff() {
    local opt_type="$1" strike="$2" premium="$3" range="${4:-20}"
    python3 << PYEOF
opt_type = "${opt_type}"
K = float(${strike})
premium = float(${premium})
rng = int(${range})

low = max(0, int(K) - rng)
high = int(K) + rng

print(f"{'Underlying':>12}  {'Intrinsic':>10}  {'Net P/L':>10}")
print("-" * 36)
for price in range(low, high + 1):
    if opt_type == "call":
        intrinsic = max(0, price - K)
    else:
        intrinsic = max(0, K - price)
    pnl = intrinsic - premium
    marker = " <-- strike" if price == int(K) else ""
    print(f"{price:>12.2f}  {intrinsic:>10.2f}  {pnl:>+10.2f}{marker}")
PYEOF
}

# ─── Compare Two Strikes ────────────────────────────────────────────────────────

bs_compare() {
    local spot="$1" strike1="$2" strike2="$3" vol="$4" days="$5"
    python3 << PYEOF
import math

def norm_cdf(x):
    if x < -10:
        return 0.0
    if x > 10:
        return 1.0
    a1, a2, a3, a4, a5 = 0.254829592, -0.284496736, 1.421413741, -1.453152027, 1.061405429
    p = 0.3275911
    sign = 1 if x >= 0 else -1
    x_abs = abs(x)
    t = 1.0 / (1.0 + p * x_abs)
    y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * math.exp(-x_abs * x_abs / 2.0)
    return 0.5 * (1.0 + sign * y)

def norm_pdf(x):
    return math.exp(-0.5 * x * x) / math.sqrt(2.0 * math.pi)

def bs_calc(S, K, r, sigma, T):
    sqrtT = math.sqrt(T)
    d1 = (math.log(S / K) + (r + 0.5 * sigma ** 2) * T) / (sigma * sqrtT)
    d2 = d1 - sigma * sqrtT
    call = S * norm_cdf(d1) - K * math.exp(-r * T) * norm_cdf(d2)
    put = K * math.exp(-r * T) * norm_cdf(-d2) - S * norm_cdf(-d1)
    delta_c = norm_cdf(d1)
    delta_p = delta_c - 1.0
    gamma = norm_pdf(d1) / (S * sigma * sqrtT)
    return call, put, delta_c, delta_p, gamma

S = float(${spot})
K1 = float(${strike1})
K2 = float(${strike2})
sigma = float(${vol})
days = float(${days})
r = 0.05
T = days / 365.0

c1, p1, dc1, dp1, g1 = bs_calc(S, K1, r, sigma, T)
c2, p2, dc2, dp2, g2 = bs_calc(S, K2, r, sigma, T)

header = f"{'':>18} {'Strike '+str(K1):>14} {'Strike '+str(K2):>14}"
print(header)
print("-" * len(header))
print(f"{'Call Price':>18} {c1:>14.4f} {c2:>14.4f}")
print(f"{'Put Price':>18} {p1:>14.4f} {p2:>14.4f}")
print(f"{'Call Delta':>18} {dc1:>+14.6f} {dc2:>+14.6f}")
print(f"{'Put Delta':>18} {dp1:>+14.6f} {dp2:>+14.6f}")
print(f"{'Gamma':>18} {g1:>14.6f} {g2:>14.6f}")
print()
print(f"Spot: {S}  |  Rate: {r}  |  Vol: {sigma}  |  Days: {days}")
PYEOF
}

# ─── Option Chain ────────────────────────────────────────────────────────────────

bs_chain() {
    local spot="$1" vol="$2" days="$3"
    python3 << PYEOF
import math

def norm_cdf(x):
    if x < -10:
        return 0.0
    if x > 10:
        return 1.0
    a1, a2, a3, a4, a5 = 0.254829592, -0.284496736, 1.421413741, -1.453152027, 1.061405429
    p = 0.3275911
    sign = 1 if x >= 0 else -1
    x_abs = abs(x)
    t = 1.0 / (1.0 + p * x_abs)
    y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * math.exp(-x_abs * x_abs / 2.0)
    return 0.5 * (1.0 + sign * y)

def norm_pdf(x):
    return math.exp(-0.5 * x * x) / math.sqrt(2.0 * math.pi)

S = float(${spot})
sigma = float(${vol})
days = float(${days})
r = 0.05
T = days / 365.0
sqrtT = math.sqrt(T)

# Generate strikes: 80% to 120% of spot, step by ~2.5%
base = round(S)
step = max(1, round(S * 0.025))
strikes = list(range(base - step * 4, base + step * 5, step))

print(f"Option Chain  |  Spot: {S}  |  Vol: {sigma*100:.0f}%  |  Days: {days:.0f}  |  Rate: {r}")
print()
print(f"{'Strike':>8}  {'Call':>8}  {'C.Delta':>8}  {'Put':>8}  {'P.Delta':>8}  {'Gamma':>8}  {'IV flag':>8}")
print("-" * 62)

for K in strikes:
    if K <= 0:
        continue
    d1 = (math.log(S / K) + (r + 0.5 * sigma ** 2) * T) / (sigma * sqrtT)
    d2 = d1 - sigma * sqrtT
    call_p = S * norm_cdf(d1) - K * math.exp(-r * T) * norm_cdf(d2)
    put_p = K * math.exp(-r * T) * norm_cdf(-d2) - S * norm_cdf(-d1)
    dc = norm_cdf(d1)
    dp = dc - 1.0
    gm = norm_pdf(d1) / (S * sigma * sqrtT)

    flag = ""
    if abs(K - S) <= step * 0.6:
        flag = "  ATM"
    elif K < S:
        flag = "  ITM" if True else ""
    else:
        flag = "  OTM"

    print(f"{K:>8.2f}  {call_p:>8.4f}  {dc:>+8.4f}  {put_p:>8.4f}  {dp:>+8.4f}  {gm:>8.6f}{flag}")
PYEOF
}

# ─── P&L Calculation ────────────────────────────────────────────────────────────

bs_pnl() {
    local opt_type="$1" entry="$2" current="$3" qty="$4"
    python3 << PYEOF
opt_type = "${opt_type}"
entry = float(${entry})
current = float(${current})
qty = float(${qty})

pnl_per = current - entry
total_pnl = pnl_per * qty * 100  # standard 100 shares per contract
pct = (pnl_per / entry * 100) if entry != 0 else 0.0

direction = "Long" if qty > 0 else "Short"
print(f"Position:    {direction} {abs(qty):.0f}x {opt_type}")
print(f"Entry:       {entry:.4f}")
print(f"Current:     {current:.4f}")
print(f"P/L per contract: {pnl_per:+.4f}")
print(f"Total P/L:   {total_pnl:+.2f}  ({pct:+.2f}%)")
PYEOF
}

# ─── Breakeven ───────────────────────────────────────────────────────────────────

bs_breakeven() {
    local opt_type="$1" strike="$2" premium="$3"
    python3 << PYEOF
opt_type = "${opt_type}"
K = float(${strike})
premium = float(${premium})

if opt_type == "call":
    be = K + premium
    print(f"Call Breakeven: {be:.4f}")
    print(f"  Strike ({K:.2f}) + Premium ({premium:.4f})")
    print(f"  Underlying must exceed {be:.4f} to profit at expiration.")
else:
    be = K - premium
    print(f"Put Breakeven: {be:.4f}")
    print(f"  Strike ({K:.2f}) - Premium ({premium:.4f})")
    print(f"  Underlying must fall below {be:.4f} to profit at expiration.")

print(f"  Max loss (buyer): {premium:.4f} per share")
PYEOF
}

# ─── Argument Validation Helpers ─────────────────────────────────────────────────

require_args() {
    local cmd="$1" need="$2" got="$3"
    if [ "$got" -lt "$need" ]; then
        echo "Error: '$cmd' requires $need arguments, got $got."
        echo "Run 'option-calculator help' for usage."
        exit 1
    fi
}

validate_type() {
    if [[ "$1" != "call" && "$1" != "put" ]]; then
        echo "Error: type must be 'call' or 'put', got '$1'."
        exit 1
    fi
}

# ─── Main Dispatch ───────────────────────────────────────────────────────────────

CMD="${1:-help}"
shift || true

case "$CMD" in
    price)
        require_args "price" 6 "$#"
        validate_type "$1"
        echo "Black-Scholes Price ($1):"
        result=$(bs_price "$1" "$2" "$3" "$4" "$5" "$6")
        echo "  $result"
        echo "$1 | S=$2 K=$3 r=$4 σ=$5 T=$6d | price=$result" >> "$DATA_DIR/history.log"
        ;;
    greeks)
        require_args "greeks" 6 "$#"
        validate_type "$1"
        echo "Greeks ($1)  S=$2 K=$3 r=$4 σ=$5 T=$6d"
        echo "──────────────────────────────────"
        bs_greeks "$1" "$2" "$3" "$4" "$5" "$6"
        ;;
    iv)
        require_args "iv" 6 "$#"
        validate_type "$1"
        echo "Implied Volatility Solver ($1)  S=$2 K=$3 r=$4 T=$5d  Market=$6"
        echo "──────────────────────────────────"
        bs_iv "$1" "$2" "$3" "$4" "$5" "$6"
        ;;
    payoff)
        require_args "payoff" 3 "$#"
        validate_type "$1"
        echo "Payoff Table ($1)  K=$2  Premium=$3"
        echo "──────────────────────────────────"
        bs_payoff "$1" "$2" "$3" "${4:-20}"
        ;;
    compare)
        require_args "compare" 5 "$#"
        echo "Strike Comparison  S=$1  K1=$2 vs K2=$3  σ=$4 T=$5d"
        echo "──────────────────────────────────"
        bs_compare "$1" "$2" "$3" "$4" "$5"
        ;;
    chain)
        require_args "chain" 3 "$#"
        bs_chain "$1" "$2" "$3"
        ;;
    pnl)
        require_args "pnl" 4 "$#"
        validate_type "$1"
        echo "Position P/L"
        echo "──────────────────────────────────"
        bs_pnl "$1" "$2" "$3" "$4"
        ;;
    breakeven)
        require_args "breakeven" 3 "$#"
        validate_type "$1"
        echo "Breakeven Analysis"
        echo "──────────────────────────────────"
        bs_breakeven "$1" "$2" "$3"
        ;;
    help|-h|--help)
        show_help
        ;;
    version|-v|--version)
        echo "option-calculator v$VERSION"
        ;;
    *)
        echo "Unknown command: $CMD"
        echo "Run 'option-calculator help' for usage."
        exit 1
        ;;
esac
