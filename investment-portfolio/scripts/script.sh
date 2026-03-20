#!/usr/bin/env bash
# investment-portfolio — Investment portfolio tracker and analyzer
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="4.0.0"
DATA_DIR="${PORTFOLIO_DIR:-$HOME/.investment-portfolio}"
DB="$DATA_DIR/holdings.jsonl"
HISTORY="$DATA_DIR/history.log"
mkdir -p "$DATA_DIR"

BOLD='\033[1m'; GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; DIM='\033[2m'; RESET='\033[0m'

die() { echo -e "${RED}Error: $1${RESET}" >&2; exit 1; }
info() { echo -e "${GREEN}✓${RESET} $1"; }

_log() { echo "$(date '+%Y-%m-%d %H:%M') $*" >> "$HISTORY"; }

# === add: add a holding ===
cmd_add() {
    local ticker="${1:?Usage: investment-portfolio add <TICKER> <shares> <buy_price>}"
    local shares="${2:?Missing shares}"
    local buy_price="${3:?Missing buy_price}"
    ticker=$(echo "$ticker" | tr 'a-z' 'A-Z')

    TICKER="$ticker" SHARES="$shares" PRICE="$buy_price" DB_FILE="$DB" python3 << 'PYEOF'
import json, os
from datetime import datetime
entry = {
    "ticker": os.environ["TICKER"],
    "shares": float(os.environ["SHARES"]),
    "buy_price": float(os.environ["PRICE"]),
    "current_price": float(os.environ["PRICE"]),
    "date": datetime.now().strftime("%Y-%m-%d")
}
with open(os.environ["DB_FILE"], "a") as f:
    f.write(json.dumps(entry) + "\n")
cost = entry["shares"] * entry["buy_price"]
print("  Added: {} x {:.2f} shares @ ${:.2f} (${:,.2f} total)".format(
    entry["ticker"], entry["shares"], entry["buy_price"], cost))
PYEOF
    _log "ADD $ticker $shares @ $buy_price"
}

# === remove: remove a holding ===
cmd_remove() {
    local ticker="${1:?Usage: investment-portfolio remove <TICKER>}"
    ticker=$(echo "$ticker" | tr 'a-z' 'A-Z')
    [ ! -f "$DB" ] && { echo "  No holdings."; return 0; }

    TICKER="$ticker" DB_FILE="$DB" python3 << 'PYEOF'
import json, os
ticker = os.environ["TICKER"]
db = os.environ["DB_FILE"]
kept = []
removed = 0
with open(db) as f:
    for line in f:
        if not line.strip():
            continue
        h = json.loads(line)
        if h["ticker"] == ticker:
            removed += 1
        else:
            kept.append(line)
with open(db, "w") as f:
    f.writelines(kept)
if removed:
    print("  Removed {} entries for {}".format(removed, ticker))
else:
    print("  {} not found in portfolio".format(ticker))
PYEOF
    _log "REMOVE $ticker"
}

# === update: update current price ===
cmd_update() {
    local ticker="${1:?Usage: investment-portfolio update <TICKER> <current_price>}"
    local price="${2:?Missing current price}"
    ticker=$(echo "$ticker" | tr 'a-z' 'A-Z')
    [ ! -f "$DB" ] && { echo "  No holdings."; return 0; }

    TICKER="$ticker" PRICE="$price" DB_FILE="$DB" python3 << 'PYEOF'
import json, os
ticker = os.environ["TICKER"]
price = float(os.environ["PRICE"])
db = os.environ["DB_FILE"]
updated = 0
lines = []
with open(db) as f:
    for line in f:
        if not line.strip():
            continue
        h = json.loads(line)
        if h["ticker"] == ticker:
            h["current_price"] = price
            updated += 1
        lines.append(json.dumps(h) + "\n")
with open(db, "w") as f:
    f.writelines(lines)
if updated:
    print("  Updated {} → ${:,.2f} ({} entries)".format(ticker, price, updated))
else:
    print("  {} not found".format(ticker))
PYEOF
    _log "UPDATE $ticker $price"
}

# === list: show all holdings ===
cmd_list() {
    [ ! -f "$DB" ] || [ ! -s "$DB" ] && { echo "  Portfolio is empty."; return 0; }
    echo -e "${BOLD}Holdings${RESET}"
    echo ""

    DB_FILE="$DB" python3 << 'PYEOF'
import json, os
db = os.environ["DB_FILE"]
print("  {:>8} {:>10} {:>10} {:>10} {:>10}".format("Ticker", "Shares", "Buy", "Current", "P/L%"))
print("  " + "-" * 52)
with open(db) as f:
    for line in f:
        if not line.strip():
            continue
        h = json.loads(line)
        pnl = (h["current_price"] - h["buy_price"]) / h["buy_price"] * 100 if h["buy_price"] > 0 else 0
        print("  {:>8} {:>10.2f} ${:>9.2f} ${:>9.2f} {:>+9.1f}%".format(
            h["ticker"], h["shares"], h["buy_price"], h["current_price"], pnl))
PYEOF
}

# === summary: portfolio summary ===
cmd_summary() {
    [ ! -f "$DB" ] || [ ! -s "$DB" ] && { echo "  Portfolio is empty."; return 0; }
    echo -e "${BOLD}Portfolio Summary${RESET}"

    DB_FILE="$DB" python3 << 'PYEOF'
import json, os
db = os.environ["DB_FILE"]
total_cost = 0
total_value = 0
count = 0
with open(db) as f:
    for line in f:
        if not line.strip():
            continue
        h = json.loads(line)
        cost = h["shares"] * h["buy_price"]
        value = h["shares"] * h["current_price"]
        total_cost += cost
        total_value += value
        count += 1

pnl = total_value - total_cost
pct = pnl / total_cost * 100 if total_cost > 0 else 0

print("  Holdings:    {}".format(count))
print("  Total Cost:  ${:,.2f}".format(total_cost))
print("  Total Value: ${:,.2f}".format(total_value))
print("  P/L:         ${:+,.2f} ({:+.1f}%)".format(pnl, pct))
PYEOF
}

# === allocation: allocation chart ===
cmd_allocation() {
    [ ! -f "$DB" ] || [ ! -s "$DB" ] && { echo "  No holdings."; return 0; }
    echo -e "${BOLD}Asset Allocation${RESET}"

    DB_FILE="$DB" python3 << 'PYEOF'
import json, os
db = os.environ["DB_FILE"]
holdings = {}
total = 0
with open(db) as f:
    for line in f:
        if not line.strip():
            continue
        h = json.loads(line)
        val = h["shares"] * h["current_price"]
        ticker = h["ticker"]
        holdings[ticker] = holdings.get(ticker, 0) + val
        total += val

if total == 0:
    print("  No value")
else:
    print("")
    for ticker in sorted(holdings, key=holdings.get, reverse=True):
        val = holdings[ticker]
        pct = val / total * 100
        bar_len = int(pct / 2)
        bar = chr(9608) * bar_len
        print("  {:>8} {:>8.1f}%  {} ${:,.0f}".format(ticker, pct, bar, val))
PYEOF
}

# === performance: gain/loss per holding ===
cmd_performance() {
    [ ! -f "$DB" ] || [ ! -s "$DB" ] && { echo "  No holdings."; return 0; }
    echo -e "${BOLD}Performance Analysis${RESET}"

    DB_FILE="$DB" python3 << 'PYEOF'
import json, os
db = os.environ["DB_FILE"]
print("")
print("  {:>8} {:>12} {:>12} {:>12} {:>8}".format("Ticker", "Cost", "Value", "P/L", "Return"))
print("  " + "-" * 56)
with open(db) as f:
    for line in f:
        if not line.strip():
            continue
        h = json.loads(line)
        cost = h["shares"] * h["buy_price"]
        value = h["shares"] * h["current_price"]
        pl = value - cost
        ret = pl / cost * 100 if cost > 0 else 0
        print("  {:>8} ${:>11,.2f} ${:>11,.2f} ${:>+11,.2f} {:>+7.1f}%".format(
            h["ticker"], cost, value, pl, ret))
PYEOF
}

# === risk: risk assessment ===
cmd_risk() {
    [ ! -f "$DB" ] || [ ! -s "$DB" ] && { echo "  No holdings."; return 0; }
    echo -e "${BOLD}Risk Assessment${RESET}"

    DB_FILE="$DB" python3 << 'PYEOF'
import json, os, math
db = os.environ["DB_FILE"]
returns = []
tickers = set()
with open(db) as f:
    for line in f:
        if not line.strip():
            continue
        h = json.loads(line)
        tickers.add(h["ticker"])
        if h["buy_price"] > 0:
            ret = (h["current_price"] - h["buy_price"]) / h["buy_price"]
            returns.append(ret)

n = len(returns)
if n < 2:
    print("  Need at least 2 holdings for risk analysis.")
else:
    avg = sum(returns) / n
    variance = sum((r - avg) ** 2 for r in returns) / (n - 1)
    std = math.sqrt(variance)
    max_r = max(returns)
    min_r = min(returns)
    
    div_score = min(10, len(tickers))
    
    print("  Positions:        {}".format(n))
    print("  Unique tickers:   {}".format(len(tickers)))
    print("  Avg return:       {:+.1f}%".format(avg * 100))
    print("  Std deviation:    {:.1f}%".format(std * 100))
    print("  Best performer:   {:+.1f}%".format(max_r * 100))
    print("  Worst performer:  {:+.1f}%".format(min_r * 100))
    print("  Diversification:  {}/10".format(div_score))
PYEOF
}

# === rebalance: rebalance suggestions ===
cmd_rebalance() {
    local target="${1:-}"
    [ -z "$target" ] && { echo "Usage: investment-portfolio rebalance '{\"AAPL\":40,\"GOOGL\":30,\"BTC\":30}'"; return 1; }
    [ ! -f "$DB" ] || [ ! -s "$DB" ] && { echo "  No holdings."; return 0; }

    DB_FILE="$DB" TARGET_JSON="$target" python3 << 'PYEOF'
import json, os, sys
target_raw = os.environ["TARGET_JSON"]
db = os.environ["DB_FILE"]
try:
    target = json.loads(target_raw)
except:
    print("  Invalid JSON. Example: {\"AAPL\":40,\"GOOGL\":30,\"BTC\":30}")
    sys.exit(1)

holdings = {}
total = 0.0
with open(db) as f:
    for line in f:
        if not line.strip():
            continue
        h = json.loads(line)
        val = h["shares"] * h["current_price"]
        t = h["ticker"]
        holdings[t] = holdings.get(t, 0) + val
        total += val

if total == 0:
    print("  Portfolio value is $0.")
    sys.exit(0)

print("  Rebalance Suggestions (total: ${:,.2f}):".format(total))
print("")
print("  {:>8} {:>10} {:>10} {:>10} {:>12}".format("Ticker", "Current%", "Target%", "Diff%", "Action"))
print("  " + "-" * 54)

for ticker, tgt_pct in sorted(target.items()):
    cur_val = holdings.get(ticker, 0)
    cur_pct = cur_val / total * 100
    diff = tgt_pct - cur_pct
    amount = abs(diff) / 100 * total
    if diff > 1:
        action = "BUY ${:,.0f}".format(amount)
    elif diff < -1:
        action = "SELL ${:,.0f}".format(amount)
    else:
        action = "OK"
    print("  {:>8} {:>9.1f}% {:>9.1f}% {:>+9.1f}% {:>12}".format(
        ticker, cur_pct, tgt_pct, diff, action))
PYEOF
}

# === dca: dollar cost averaging ===
cmd_dca() {
    local ticker="${1:?Usage: investment-portfolio dca <TICKER> <monthly_amount>}"
    local monthly="${2:?Missing monthly amount}"
    ticker=$(echo "$ticker" | tr 'a-z' 'A-Z')

    echo -e "${BOLD}DCA Calculator: $ticker @ \$$monthly/month${RESET}"
    echo ""
    echo "  Month   Investment    Cumulative"
    echo "  ──────────────────────────────────"
    local total=0
    for m in $(seq 1 12); do
        total=$((total + monthly))
        printf "  %-7d \$%-12s \$%s\n" "$m" "$monthly" "$total"
    done
    echo ""
    echo "  Total invested after 12 months: \$$total"
}

# === dividend: yield calculator ===
cmd_dividend() {
    local ticker="${1:?Usage: investment-portfolio dividend <TICKER> <annual_div> <price>}"
    local annual_div="${2:?Missing annual dividend}"
    local price="${3:?Missing current price}"

    ANNUAL="$annual_div" PRICE="$price" python3 << 'PYEOF'
import os
div = float(os.environ["ANNUAL"])
price = float(os.environ["PRICE"])
if price > 0:
    yld = div / price * 100
    print("  Dividend Yield: {:.2f}%".format(yld))
    print("  Annual:  ${:.2f} per share".format(div))
    print("  Price:   ${:.2f}".format(price))
    print("  Quarterly: ${:.4f}".format(div / 4))
else:
    print("  Invalid price")
PYEOF
}

# === compare: compare two holdings ===
cmd_compare() {
    local t1="${1:?Usage: investment-portfolio compare <TICKER1> <TICKER2>}"
    local t2="${2:?Missing second ticker}"
    t1=$(echo "$t1" | tr 'a-z' 'A-Z')
    t2=$(echo "$t2" | tr 'a-z' 'A-Z')
    [ ! -f "$DB" ] && { echo "  No holdings."; return 0; }

    DB_FILE="$DB" T1="$t1" T2="$t2" python3 << 'PYEOF'
import json, os
db = os.environ["DB_FILE"]
t1, t2 = os.environ["T1"], os.environ["T2"]
holdings = {}
with open(db) as f:
    for line in f:
        if not line.strip():
            continue
        h = json.loads(line)
        t = h["ticker"]
        if t in (t1, t2):
            if t not in holdings:
                holdings[t] = {"shares": 0, "cost": 0, "value": 0}
            holdings[t]["shares"] += h["shares"]
            holdings[t]["cost"] += h["shares"] * h["buy_price"]
            holdings[t]["value"] += h["shares"] * h["current_price"]

print("  {:>12} {:>14} {:>14}".format("", t1, t2))
print("  " + "-" * 42)
for label, key in [("Shares", "shares"), ("Cost", "cost"), ("Value", "value")]:
    v1 = holdings.get(t1, {}).get(key, 0)
    v2 = holdings.get(t2, {}).get(key, 0)
    if key == "shares":
        print("  {:>12} {:>14.2f} {:>14.2f}".format(label, v1, v2))
    else:
        print("  {:>12} ${:>13,.2f} ${:>13,.2f}".format(label, v1, v2))

for t in [t1, t2]:
    d = holdings.get(t)
    if d and d["cost"] > 0:
        pl = d["value"] - d["cost"]
        pct = pl / d["cost"] * 100
        print("  {:>12} {:>+13,.2f} ({:+.1f}%)".format(t + " P/L", pl, pct))
PYEOF
}

# === sectors: sector breakdown ===
cmd_sectors() {
    [ ! -f "$DB" ] || [ ! -s "$DB" ] && { echo "  No holdings."; return 0; }
    echo -e "${BOLD}Sector Breakdown${RESET}"

    DB_FILE="$DB" python3 << 'PYEOF'
import json, os
db = os.environ["DB_FILE"]
sector_map = {
    "AAPL": "Technology", "GOOGL": "Technology", "MSFT": "Technology",
    "AMZN": "Consumer", "TSLA": "Automotive", "META": "Technology",
    "NVDA": "Technology", "AMD": "Technology", "INTC": "Technology",
    "BTC": "Crypto", "ETH": "Crypto", "SOL": "Crypto", "BNB": "Crypto",
    "JPM": "Finance", "GS": "Finance", "BAC": "Finance", "V": "Finance",
    "JNJ": "Healthcare", "PFE": "Healthcare", "UNH": "Healthcare",
    "XOM": "Energy", "CVX": "Energy", "BP": "Energy",
}
sectors = {}
total = 0.0
with open(db) as f:
    for line in f:
        if not line.strip():
            continue
        h = json.loads(line)
        val = h["shares"] * h["current_price"]
        sector = sector_map.get(h["ticker"].upper(), "Other")
        sectors[sector] = sectors.get(sector, 0) + val
        total += val

if not sectors:
    print("  No holdings.")
else:
    print("")
    for sector in sorted(sectors, key=sectors.get, reverse=True):
        val = sectors[sector]
        pct = val / total * 100 if total > 0 else 0
        bar = chr(9608) * int(pct / 2)
        print("  {:>14} ${:>10,.2f} {:>5.1f}% {}".format(sector, val, pct, bar))
PYEOF
}

# === export ===
cmd_export() {
    local fmt="${1:-csv}"
    [ ! -f "$DB" ] && { echo "  No data."; return 0; }
    case "$fmt" in
        csv)
            echo "ticker,shares,buy_price,current_price,date"
            DB_FILE="$DB" python3 << 'PYEOF'
import json, os
with open(os.environ["DB_FILE"]) as f:
    for line in f:
        if not line.strip():
            continue
        h = json.loads(line)
        print("{},{},{},{},{}".format(h["ticker"], h["shares"], h["buy_price"], h["current_price"], h.get("date","")))
PYEOF
            ;;
        json)
            echo "["
            local first=true
            while IFS= read -r line; do
                [ -z "$line" ] && continue
                $first && first=false || echo ","
                echo "  $line"
            done < "$DB"
            echo "]"
            ;;
        *) die "Unknown format: $fmt (csv or json)" ;;
    esac
}

# === history ===
cmd_history() {
    if [ -f "$HISTORY" ]; then
        echo -e "${BOLD}Transaction History${RESET}"
        tail -20 "$HISTORY"
    else
        echo "  No history yet."
    fi
}

show_help() {
    cat << EOF
investment-portfolio v$VERSION — Investment portfolio tracker

Usage: investment-portfolio <command> [args]

Holdings:
  add <ticker> <shares> <price>   Add a position
  remove <ticker>                  Remove a position
  update <ticker> <price>          Update current price
  list                             Show all holdings

Analysis:
  summary                          Portfolio summary (total value, P/L)
  allocation                       Asset allocation bar chart
  performance                      Per-holding gain/loss analysis
  risk                             Risk metrics (std dev, diversification)
  rebalance <target-json>          Rebalance suggestions
  compare <t1> <t2>                Compare two holdings
  sectors                          Sector breakdown

Tools:
  dca <ticker> <monthly>           DCA calculator (12-month table)
  dividend <t> <annual> <price>    Dividend yield calculator
  export <csv|json>                Export portfolio data
  history                          Transaction history

  help                             Show this help
  version                          Show version

All prices manually entered. Data: $DATA_DIR
EOF
}

show_version() {
    echo "investment-portfolio v$VERSION"
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

[ $# -eq 0 ] && { show_help; exit 0; }

case "$1" in
    add)          shift; cmd_add "$@" ;;
    remove)       shift; cmd_remove "$@" ;;
    update)       shift; cmd_update "$@" ;;
    list)         cmd_list ;;
    summary)      cmd_summary ;;
    allocation)   cmd_allocation ;;
    performance)  cmd_performance ;;
    risk)         cmd_risk ;;
    rebalance)    shift; cmd_rebalance "$@" ;;
    dca)          shift; cmd_dca "$@" ;;
    dividend)     shift; cmd_dividend "$@" ;;
    compare)      shift; cmd_compare "$@" ;;
    sectors)      cmd_sectors ;;
    diversify)    cmd_risk ;;
    export)       shift; cmd_export "$@" ;;
    history)      cmd_history ;;
    help|-h)      show_help ;;
    version|-v)   show_version ;;
    *)            echo "Unknown: $1"; show_help; exit 1 ;;
esac
