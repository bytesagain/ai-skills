#!/usr/bin/env bash
# crypto-market-cli — Cryptocurrency market toolkit with live CoinGecko data
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="5.0.0"
DATA_DIR="${CRYPTO_CLI_DIR:-$HOME/.crypto-market-cli}"
mkdir -p "$DATA_DIR"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; BOLD='\033[1m'; DIM='\033[2m'; RESET='\033[0m'

API="https://api.coingecko.com/api/v3"

die() { echo -e "${RED}Error: $1${RESET}" >&2; exit 1; }
info() { echo -e "${GREEN}✓${RESET} $1"; }

# Fetch JSON from CoinGecko with error handling
_fetch() {
    local url="$1"
    local result
    result=$(curl -sf --max-time 15 "$url" 2>/dev/null) || die "API request failed. Check your internet connection."
    echo "$result"
}

# === price: get live price ===
cmd_price() {
    local coin="${1:-bitcoin}"
    local vs="${2:-usd}"
    coin=$(echo "$coin" | tr '[:upper:]' '[:lower:]')

    echo -e "${BOLD}Price: $coin${RESET}"
    local data
    data=$(_fetch "$API/simple/price?ids=$coin&vs_currencies=$vs&include_24hr_change=true&include_market_cap=true")

    COIN="$coin" VS="$vs" python3 << 'PYEOF'
import json, sys, os
coin = os.environ["COIN"]
vs = os.environ["VS"]
data = json.loads(sys.stdin.read())
if coin not in data:
    print("  Coin '{}' not found. Try the full ID (e.g. 'bitcoin', 'ethereum').".format(coin))
else:
    d = data[coin]
    price = d.get(vs, 0)
    change = d.get("{}_24h_change".format(vs), 0)
    mcap = d.get("{}_market_cap".format(vs), 0)
    arrow = "↑" if change >= 0 else "↓"
    print("  Price:      ${:,.2f} {}".format(price, vs.upper()))
    print("  24h Change: {:+.2f}% {}".format(change, arrow))
    if mcap > 0:
        if mcap >= 1e9:
            print("  Market Cap: ${:.2f}B".format(mcap / 1e9))
        else:
            print("  Market Cap: ${:,.0f}".format(mcap))
PYEOF
    <<< "$data"

    echo "$coin" >> "$DATA_DIR/history.log"
}

# === search: find coins ===
cmd_search() {
    local query="${1:?Usage: crypto-market-cli search <query>}"
    echo -e "${BOLD}Searching: $query${RESET}"
    local data
    data=$(_fetch "$API/search?query=$query")

    python3 << 'PYEOF'
import json, sys
data = json.loads(sys.stdin.read())
coins = data.get("coins", [])[:10]
if not coins:
    print("  No results found.")
else:
    print("  {:>5} {:<20} {:<8} {:>8}".format("#", "Name", "Symbol", "Rank"))
    print("  " + "-" * 44)
    for i, c in enumerate(coins, 1):
        print("  {:>5} {:<20} {:<8} {:>8}".format(
            i, c.get("name", "")[:20], c.get("symbol", "").upper(),
            c.get("market_cap_rank", "—") or "—"))
PYEOF
    <<< "$data"
}

# === track: add to watchlist ===
cmd_track() {
    local coin="${1:?Usage: crypto-market-cli track <coin-id>}"
    coin=$(echo "$coin" | tr '[:upper:]' '[:lower:]')
    local wl="$DATA_DIR/watchlist.txt"
    if grep -qx "$coin" "$wl" 2>/dev/null; then
        echo "  $coin is already on your watchlist."
    else
        echo "$coin" >> "$wl"
        info "$coin added to watchlist"
    fi
}

# === watchlist: show watchlist with prices ===
cmd_watchlist() {
    local wl="$DATA_DIR/watchlist.txt"
    [ ! -f "$wl" ] && { echo "  Watchlist is empty. Use: track <coin>"; return 0; }

    local coins
    coins=$(cat "$wl" | tr '\n' ',' | sed 's/,$//')
    [ -z "$coins" ] && { echo "  Watchlist is empty."; return 0; }

    echo -e "${BOLD}Watchlist${RESET}"
    local data
    data=$(_fetch "$API/simple/price?ids=$coins&vs_currencies=usd&include_24hr_change=true")

    python3 << 'PYEOF'
import json, sys
data = json.loads(sys.stdin.read())
print("  {:<16} {:>12} {:>10}".format("Coin", "Price (USD)", "24h %"))
print("  " + "-" * 40)
for coin in sorted(data.keys()):
    d = data[coin]
    price = d.get("usd", 0)
    change = d.get("usd_24h_change", 0)
    arrow = "↑" if change >= 0 else "↓"
    print("  {:<16} ${:>11,.2f} {:>+8.2f}% {}".format(coin, price, change, arrow))
PYEOF
    <<< "$data"
}

# === portfolio: manage portfolio ===
cmd_portfolio() {
    local action="${1:-show}"
    local pf="$DATA_DIR/portfolio.jsonl"

    case "$action" in
        add)
            local coin="${2:?Usage: portfolio add <coin> <amount> <buy_price>}"
            local amount="${3:?Missing amount}"
            local buy_price="${4:?Missing buy_price}"
            coin=$(echo "$coin" | tr '[:upper:]' '[:lower:]')
            local ts
            ts=$(date '+%Y-%m-%d %H:%M:%S')

            COIN="$coin" AMOUNT="$amount" BUY="$buy_price" TS="$ts" python3 << 'PYEOF'
import json, os
entry = {
    "coin": os.environ["COIN"],
    "amount": float(os.environ["AMOUNT"]),
    "buy_price": float(os.environ["BUY"]),
    "date": os.environ["TS"]
}
pf = os.path.expanduser("~/.crypto-market-cli/portfolio.jsonl")
with open(pf, "a") as f:
    f.write(json.dumps(entry) + "\n")
print("  Added {} {} at ${} each".format(entry["amount"], entry["coin"], entry["buy_price"]))
PYEOF
            ;;
        show|"")
            [ ! -f "$pf" ] && { echo "  Portfolio is empty. Use: portfolio add <coin> <amount> <buy_price>"; return 0; }
            echo -e "${BOLD}Portfolio${RESET}"

            # Get unique coins
            local coins
            coins=$(python3 -c "
import json
pf = open('$pf')
coins = set()
for line in pf:
    if line.strip():
        coins.add(json.loads(line)['coin'])
print(','.join(coins))
" 2>/dev/null)

            [ -z "$coins" ] && { echo "  No holdings."; return 0; }
            local prices
            prices=$(_fetch "$API/simple/price?ids=$coins&vs_currencies=usd")

            PF_FILE="$pf" python3 << 'PYEOF'
import json, sys, os
prices = json.loads(sys.stdin.read())
pf_file = os.environ["PF_FILE"]

holdings = {}
with open(pf_file) as f:
    for line in f:
        if not line.strip():
            continue
        entry = json.loads(line)
        coin = entry["coin"]
        if coin not in holdings:
            holdings[coin] = {"amount": 0, "cost": 0}
        holdings[coin]["amount"] += entry["amount"]
        holdings[coin]["cost"] += entry["amount"] * entry["buy_price"]

total_value = 0
total_cost = 0
print("  {:<14} {:>10} {:>12} {:>12} {:>10}".format("Coin", "Amount", "Value", "Cost", "P/L"))
print("  " + "-" * 60)

for coin in sorted(holdings.keys()):
    h = holdings[coin]
    current_price = prices.get(coin, {}).get("usd", 0)
    value = h["amount"] * current_price
    cost = h["cost"]
    pl = value - cost
    pct = pl / cost * 100 if cost > 0 else 0
    total_value += value
    total_cost += cost
    print("  {:<14} {:>10.4f} ${:>11,.2f} ${:>11,.2f} {:>+9.1f}%".format(
        coin, h["amount"], value, cost, pct))

total_pl = total_value - total_cost
total_pct = total_pl / total_cost * 100 if total_cost > 0 else 0
print("  " + "-" * 60)
print("  {:<14} {:>10} ${:>11,.2f} ${:>11,.2f} {:>+9.1f}%".format(
    "TOTAL", "", total_value, total_cost, total_pct))
PYEOF
            <<< "$prices"
            ;;
        *)
            echo "Usage: portfolio add <coin> <amount> <buy_price>"
            echo "       portfolio show"
            ;;
    esac
}

# === history: price history ===
cmd_history() {
    local coin="${1:-bitcoin}"
    local days="${2:-7}"
    coin=$(echo "$coin" | tr '[:upper:]' '[:lower:]')

    echo -e "${BOLD}$coin — ${days}-day price history${RESET}"
    local data
    data=$(_fetch "$API/coins/$coin/market_chart?vs_currency=usd&days=$days")

    DAYS="$days" python3 << 'PYEOF'
import json, sys
from datetime import datetime
data = json.loads(sys.stdin.read())
prices = data.get("prices", [])
if not prices:
    print("  No data available.")
else:
    step = max(1, len(prices) // 14)
    sampled = prices[::step]
    vals = [p[1] for p in sampled]
    mn, mx = min(vals), max(vals)
    sparks = "▁▂▃▄▅▆▇█"

    print("  {:>12} {:>12}".format("Date", "Price"))
    print("  " + "-" * 26)
    for ts, price in sampled:
        dt = datetime.fromtimestamp(ts / 1000).strftime("%m-%d %H:%M")
        idx = int((price - mn) / (mx - mn) * 7) if mx > mn else 4
        print("  {:>12} ${:>11,.2f} {}".format(dt, price, sparks[idx]))

    print("")
    print("  Range: ${:,.2f} — ${:,.2f}".format(mn, mx))
    print("  Change: {:+.2f}%".format((prices[-1][1] - prices[0][1]) / prices[0][1] * 100))
PYEOF
    <<< "$data"
}

# === gas: ethereum gas ===
cmd_gas() {
    echo -e "${BOLD}Ethereum Gas Prices${RESET}"
    echo "  Note: CoinGecko free API does not provide gas data."
    echo "  Check https://etherscan.io/gastracker for current gas prices."
    echo ""
    echo "  Tip: Set ETHERSCAN_API_KEY for automated gas tracking."
}

# === alert: price alerts ===
cmd_alert() {
    local action="${1:-list}"
    local alerts_file="$DATA_DIR/alerts.jsonl"

    case "$action" in
        add)
            local coin="${2:?Usage: alert add <coin> <price> <above|below>}"
            local target="${3:?Missing target price}"
            local direction="${4:-above}"
            coin=$(echo "$coin" | tr '[:upper:]' '[:lower:]')

            COIN="$coin" TARGET="$target" DIR="$direction" python3 << 'PYEOF'
import json, os
from datetime import datetime
alert = {
    "coin": os.environ["COIN"],
    "target": float(os.environ["TARGET"]),
    "direction": os.environ["DIR"],
    "created": datetime.now().strftime("%Y-%m-%d %H:%M")
}
af = os.path.expanduser("~/.crypto-market-cli/alerts.jsonl")
with open(af, "a") as f:
    f.write(json.dumps(alert) + "\n")
print("  Alert set: {} {} ${}".format(alert["coin"], alert["direction"], alert["target"]))
PYEOF
            ;;
        list|"")
            [ ! -f "$alerts_file" ] && { echo "  No alerts set."; return 0; }
            echo -e "${BOLD}Price Alerts${RESET}"
            python3 << 'PYEOF'
import json, os
af = open(os.path.expanduser("~/.crypto-market-cli/alerts.jsonl"))
for line in af:
    if line.strip():
        a = json.loads(line)
        print("  {:<14} ${:>9,.2f} {:>8} {:>12}".format(
            a["coin"], a["target"], a["direction"], a["created"]))
PYEOF
            ;;
        *) echo "Usage: alert add <coin> <price> <above|below>" ;;
    esac
}

# === compare: compare two coins ===
cmd_compare() {
    local c1="${1:?Usage: compare <coin1> <coin2>}"
    local c2="${2:?Missing second coin}"
    c1=$(echo "$c1" | tr '[:upper:]' '[:lower:]')
    c2=$(echo "$c2" | tr '[:upper:]' '[:lower:]')

    echo -e "${BOLD}Compare: $c1 vs $c2${RESET}"
    local data
    data=$(_fetch "$API/simple/price?ids=$c1,$c2&vs_currencies=usd&include_24hr_change=true&include_market_cap=true")

    C1="$c1" C2="$c2" python3 << 'PYEOF'
import json, sys, os
data = json.loads(sys.stdin.read())
c1, c2 = os.environ["C1"], os.environ["C2"]

print("  {:>14} {:>14} {:>14}".format("", c1, c2))
print("  " + "-" * 44)

for coin in [c1, c2]:
    if coin not in data:
        print("  {} not found".format(coin))

d1 = data.get(c1, {})
d2 = data.get(c2, {})
print("  {:>14} ${:>13,.2f} ${:>13,.2f}".format("Price", d1.get("usd",0), d2.get("usd",0)))
print("  {:>14} {:>+13.2f}% {:>+13.2f}%".format("24h", d1.get("usd_24h_change",0), d2.get("usd_24h_change",0)))

m1 = d1.get("usd_market_cap", 0)
m2 = d2.get("usd_market_cap", 0)
fmt = lambda x: "${:.1f}B".format(x/1e9) if x >= 1e9 else "${:,.0f}".format(x)
print("  {:>14} {:>14} {:>14}".format("MCap", fmt(m1), fmt(m2)))
PYEOF
    <<< "$data"
}

# === stats ===
cmd_stats() {
    echo -e "${BOLD}Usage Statistics${RESET}"
    local wl="$DATA_DIR/watchlist.txt"
    local pf="$DATA_DIR/portfolio.jsonl"
    local al="$DATA_DIR/alerts.jsonl"
    echo "  Watchlist:  $(wc -l < "$wl" 2>/dev/null || echo 0) coins"
    echo "  Portfolio:  $(wc -l < "$pf" 2>/dev/null || echo 0) entries"
    echo "  Alerts:     $(wc -l < "$al" 2>/dev/null || echo 0) set"
    echo "  Disk:       $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
}

# === export ===
cmd_export() {
    local fmt="${1:-json}"
    local pf="$DATA_DIR/portfolio.jsonl"
    [ ! -f "$pf" ] && { echo "No portfolio data to export."; return 0; }

    case "$fmt" in
        json)
            echo "["
            local first=true
            while IFS= read -r line; do
                [ -z "$line" ] && continue
                $first && first=false || echo ","
                echo "  $line"
            done < "$pf"
            echo "]"
            ;;
        csv)
            echo "coin,amount,buy_price,date"
            python3 << 'PYEOF'
import json, os
with open(os.path.expanduser("~/.crypto-market-cli/portfolio.jsonl")) as f:
    for line in f:
        if line.strip():
            d = json.loads(line)
            print("{},{},{},{}".format(d["coin"], d["amount"], d["buy_price"], d["date"]))
PYEOF
            ;;
        *) die "Unknown format: $fmt (use json or csv)" ;;
    esac
}

show_help() {
    cat << EOF
crypto-market-cli v$VERSION — Cryptocurrency market toolkit

Usage: crypto-market-cli <command> [args]

Market Data (via CoinGecko API):
  price <coin> [currency]       Get live price, 24h change, market cap
  search <query>                Search for coins by name or symbol
  history <coin> [days]         Price history with sparkline chart
  compare <coin1> <coin2>       Side-by-side price comparison
  gas                           Ethereum gas price info

Portfolio:
  track <coin>                  Add coin to watchlist
  watchlist                     Show watchlist with live prices
  portfolio add <c> <amt> <p>   Record a buy (coin, amount, price)
  portfolio show                Show holdings with current P/L

Alerts:
  alert add <coin> <price> <dir>  Set price alert (above/below)
  alert list                      List active alerts

Data:
  stats                         Usage statistics
  export <json|csv>             Export portfolio data
  help                          Show this help
  version                       Show version

API: CoinGecko free tier (no key required, rate-limited)
Data: $DATA_DIR
EOF
}

show_version() {
    echo "crypto-market-cli v$VERSION"
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

[ $# -eq 0 ] && { show_help; exit 0; }

case "$1" in
    price)      shift; cmd_price "$@" ;;
    search)     shift; cmd_search "$@" ;;
    track)      shift; cmd_track "$@" ;;
    watchlist)  cmd_watchlist ;;
    portfolio)  shift; cmd_portfolio "$@" ;;
    history)    shift; cmd_history "$@" ;;
    gas)        cmd_gas ;;
    alert)      shift; cmd_alert "$@" ;;
    compare)    shift; cmd_compare "$@" ;;
    stats)      cmd_stats ;;
    export)     shift; cmd_export "$@" ;;
    help|-h)    show_help ;;
    version|-v) show_version ;;
    *)          echo "Unknown: $1"; show_help; exit 1 ;;
esac
