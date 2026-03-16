#!/usr/bin/env bash
# investment-portfolio — Investment portfolio tracker and analyzer
set -euo pipefail
VERSION="2.0.0"
DATA_DIR="${PORTFOLIO_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/investment-portfolio}"
DB="$DATA_DIR/holdings.jsonl"
mkdir -p "$DATA_DIR"

show_help() {
    cat << EOF
investment-portfolio v$VERSION

Track, analyze, and rebalance your investment portfolio

Usage: investment-portfolio <command> [args]

Holdings:
  add <ticker> <shares> <price>   Add a position
  remove <ticker>                  Remove a position
  update <ticker> <price>          Update current price
  list                             Show all holdings

Analysis:
  summary                         Portfolio summary
  allocation                      Asset allocation chart
  performance                     Gain/loss analysis
  risk                            Risk metrics
  diversify                       Diversification score
  dividend <ticker> <annual>      Track dividend yield

Strategy:
  rebalance <target-json>         Rebalance suggestions
  dca <ticker> <amount> <freq>    Dollar cost averaging plan
  compare <t1> <t2>               Compare two assets
  sectors                         Sector breakdown

Export:
  export [csv|json]               Export portfolio
  history                         Transaction history
  help                            Show this help

EOF
}

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

cmd_add() {
    local ticker="${1:?Usage: investment-portfolio add <ticker> <shares> <price>}"
    local shares="${2:?}"
    local price="${3:?}"
    ticker=$(echo "$ticker" | tr 'a-z' 'A-Z')
    local cost=$(python3 -c "print('{:.2f}'.format($shares * $price))")
    echo "{\"ticker\":\"$ticker\",\"shares\":$shares,\"buy_price\":$price,\"cost\":$cost,\"date\":\"$(date +%Y-%m-%d)\",\"current\":$price}" >> "$DB"
    echo "  Added: $shares shares of $ticker @ \$$price (total: \$$cost)"
    _log "add" "$ticker $shares@$price"
}

cmd_remove() {
    local ticker="${1:?}"
    ticker=$(echo "$ticker" | tr 'a-z' 'A-Z')
    if [ -f "$DB" ]; then
        grep -v "\"$ticker\"" "$DB" > "$DB.tmp" && mv "$DB.tmp" "$DB"
        echo "  Removed: $ticker"
    fi
    _log "remove" "$ticker"
}

cmd_update() {
    local ticker="${1:?Usage: investment-portfolio update <ticker> <price>}"
    local price="${2:?}"
    ticker=$(echo "$ticker" | tr 'a-z' 'A-Z')
    [ -f "$DB" ] || { echo "No holdings"; return 1; }
    python3 << PYEOF
import json
lines = []
found = False
with open("$DB") as f:
    for line in f:
        line = line.strip()
        if not line: continue
        d = json.loads(line)
        if d["ticker"] == "$ticker":
            d["current"] = $price
            found = True
        lines.append(json.dumps(d))
if found:
    with open("$DB", "w") as f:
        f.write("\n".join(lines) + "\n")
    print("  Updated $ticker to \$$price")
else:
    print("  $ticker not found")
PYEOF
}

cmd_list() {
    [ -f "$DB" ] || { echo "  No holdings. Use: investment-portfolio add <ticker> <shares> <price>"; return; }
    echo "  ═══ Portfolio Holdings ═══"
    printf "  %-8s %8s %10s %10s %10s %8s\n" "TICKER" "SHARES" "BUY PRICE" "CURRENT" "VALUE" "P/L %"
    echo "  $(printf '%.0s─' {1..60})"
    python3 << PYEOF
import json
with open("$DB") as f:
    for line in f:
        line = line.strip()
        if not line: continue
        d = json.loads(line)
        val = d["shares"] * d.get("current", d["buy_price"])
        cost = d["shares"] * d["buy_price"]
        pnl = ((val - cost) / cost * 100) if cost > 0 else 0
        sign = "+" if pnl >= 0 else ""
        print("  {:<8s} {:>8.1f} {:>10.2f} {:>10.2f} {:>10.2f} {:>7s}%".format(
            d["ticker"], d["shares"], d["buy_price"], 
            d.get("current", d["buy_price"]), val, "{}{}".format(sign, "{:.1f}".format(pnl))))
PYEOF
}

cmd_summary() {
    [ -f "$DB" ] || { echo "  No holdings."; return; }
    echo "  ═══ Portfolio Summary ═══"
    python3 << PYEOF
import json
total_cost = 0
total_value = 0
positions = 0
with open("$DB") as f:
    for line in f:
        line = line.strip()
        if not line: continue
        d = json.loads(line)
        cost = d["shares"] * d["buy_price"]
        val = d["shares"] * d.get("current", d["buy_price"])
        total_cost += cost
        total_value += val
        positions += 1

pnl = total_value - total_cost
pnl_pct = (pnl / total_cost * 100) if total_cost > 0 else 0
print("  Positions:   {}".format(positions))
print("  Total cost:  ${:,.2f}".format(total_cost))
print("  Total value: ${:,.2f}".format(total_value))
print("  P/L:         ${:,.2f} ({:+.1f}%)".format(pnl, pnl_pct))
PYEOF
}

cmd_allocation() {
    [ -f "$DB" ] || { echo "  No holdings."; return; }
    echo "  ═══ Asset Allocation ═══"
    python3 << PYEOF
import json
holdings = {}
total = 0
with open("$DB") as f:
    for line in f:
        line = line.strip()
        if not line: continue
        d = json.loads(line)
        val = d["shares"] * d.get("current", d["buy_price"])
        holdings[d["ticker"]] = holdings.get(d["ticker"], 0) + val
        total += val

for ticker in sorted(holdings, key=lambda t: holdings[t], reverse=True):
    val = holdings[ticker]
    pct = (val / total * 100) if total > 0 else 0
    bar = "█" * int(pct / 2)
    print("  {:<8s} {:>8.1f}%  {} ${:,.0f}".format(ticker, pct, bar, val))
PYEOF
}

cmd_performance() {
    [ -f "$DB" ] || return
    echo "  ═══ Performance Analysis ═══"
    python3 << PYEOF
import json
winners = []
losers = []
with open("$DB") as f:
    for line in f:
        line = line.strip()
        if not line: continue
        d = json.loads(line)
        pnl = (d.get("current", d["buy_price"]) - d["buy_price"]) / d["buy_price"] * 100
        if pnl >= 0:
            winners.append((d["ticker"], pnl))
        else:
            losers.append((d["ticker"], pnl))

print("  Winners ({})".format(len(winners)))
for t, p in sorted(winners, key=lambda x: x[1], reverse=True):
    print("    ✅ {}: +{:.1f}%".format(t, p))
print("  Losers ({})".format(len(losers)))
for t, p in sorted(losers, key=lambda x: x[1]):
    print("    ❌ {}: {:.1f}%".format(t, p))
PYEOF
}

cmd_risk() {
    echo "  ═══ Risk Assessment ═══"
    [ -f "$DB" ] || { echo "  No holdings."; return; }
    python3 << PYEOF
import json
positions = []
total = 0
with open("$DB") as f:
    for line in f:
        line = line.strip()
        if not line: continue
        d = json.loads(line)
        val = d["shares"] * d.get("current", d["buy_price"])
        positions.append(val)
        total += val

n = len(positions)
if n == 0:
    print("  No data")
else:
    max_pct = max(positions) / total * 100 if total > 0 else 0
    print("  Positions: {}".format(n))
    print("  Largest position: {:.1f}% of portfolio".format(max_pct))
    if max_pct > 50: print("  ⚠️ HIGH concentration risk")
    elif max_pct > 25: print("  ⚠️ MODERATE concentration")
    else: print("  ✅ Well diversified")
    if n < 5: print("  ⚠️ Few positions — consider diversifying")
    elif n > 30: print("  ℹ️ Many positions — consider consolidating")
PYEOF
}

cmd_dca() {
    local ticker="${1:?Usage: investment-portfolio dca <ticker> <amount> <frequency>}"
    local amount="${2:?}"
    local freq="${3:-monthly}"
    echo "  ═══ DCA Plan: $ticker ═══"
    echo "  Amount: \$$amount per $freq"
    echo ""
    echo "  Month    Investment   Cumulative"
    echo "  ─────────────────────────────────"
    for m in $(seq 1 12); do
        local cum=$((m * amount))
        printf "  %-8d \$%-11d \$%d\n" "$m" "$amount" "$cum"
    done
    echo ""
    echo "  Annual total: \$$((12 * amount))"
}

cmd_export() {
    local fmt="${1:-csv}"
    [ -f "$DB" ] || { echo "No holdings."; return; }
    case "$fmt" in
        csv) echo "ticker,shares,buy_price,current,date"
             python3 -c "
import json
with open('$DB') as f:
    for line in f:
        line = line.strip()
        if not line: continue
        d = json.loads(line)
        print('{},{},{},{},{}'.format(d['ticker'],d['shares'],d['buy_price'],d.get('current',''),d.get('date','')))" ;;
        json) cat "$DB" ;;
        *) echo "Formats: csv, json" ;;
    esac
}

cmd_history() {
    [ -f "$DATA_DIR/history.log" ] && tail -20 "$DATA_DIR/history.log" || echo "  No history"
}

case "${1:-help}" in
    add)          shift; cmd_add "$@" ;;
    remove)       shift; cmd_remove "$@" ;;
    update)       shift; cmd_update "$@" ;;
    list)         cmd_list ;;
    summary)      cmd_summary ;;
    allocation)   cmd_allocation ;;
    performance)  cmd_performance ;;
    risk)         cmd_risk ;;
    diversify)    cmd_risk ;;
    dividend)     shift; echo "  $1 annual dividend \$$2 → yield $(python3 -c "print('{:.1f}'.format($2/$3*100) if $3>0 else '?')" 2>/dev/null || echo "?")%" ;;
    rebalance)    shift; echo "  Provide target: {\"AAPL\":40,\"GOOGL\":30,\"BTC\":30}" ;;
    dca)          shift; cmd_dca "$@" ;;
    compare)      shift; echo "  Compare $1 vs $2: check current prices and P/L in your holdings" ;;
    sectors)      echo "  Sector breakdown: tag your holdings with sectors first" ;;
    export)       shift; cmd_export "${1:-csv}" ;;
    history)      cmd_history ;;
    help|-h)      show_help ;;
    version|-v)   echo "investment-portfolio v$VERSION" ;;
    *)            echo "Unknown: $1"; show_help; exit 1 ;;
esac
