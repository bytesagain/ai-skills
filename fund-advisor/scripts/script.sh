#!/usr/bin/env bash
# fund-invest-advisor — Fund investment analysis and portfolio advisory
set -euo pipefail
VERSION="2.0.0"
DATA_DIR="${FUND_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/fund-invest-advisor}"
PORTFOLIO="$DATA_DIR/portfolio.jsonl"
mkdir -p "$DATA_DIR"

show_help() {
    cat << HELP
fund-invest-advisor v$VERSION

Usage: fund-invest-advisor <command> [args]

Portfolio:
  add <fund> <amount> [date]     Add fund position
  sell <fund> <amount> [date]    Record sell
  holdings                       Current portfolio view
  allocation                     Asset allocation breakdown
  rebalance <target-file>        Rebalance suggestions
  pnl                            Profit & loss summary

Analysis:
  score <fund>                   Fund scoring (1-10)
  compare <fund1> <fund2>        Side-by-side comparison
  risk                           Portfolio risk assessment
  fees <fund> <amount> <years>   Fee impact calculator
  dca <amount> <months>          Dollar-cost-average simulator

Strategy:
  screen <criteria>              Fund screening filters
  model <type>                   Model portfolio templates
  checklist                      Investment checklist
  calendar                       Dividend/rebalance calendar

Data:
  export <format>                Export (csv|json|txt)
  import <file>                  Import holdings
  stats                          Portfolio statistics
  history                        Transaction history

HELP
}

cmd_add() {
    local fund="${1:?Usage: fund-invest-advisor add <fund> <amount> [date]}"
    local amount="${2:?}"
    local date="${3:-$(date +%Y-%m-%d)}"
    printf '{"action":"buy","fund":"%s","amount":%s,"date":"%s"}\n' "$fund" "$amount" "$date" >> "$PORTFOLIO"
    echo "[fund] Bought: $fund ¥$amount on $date"
    _log "buy" "$fund ¥$amount"
}

cmd_sell() {
    local fund="${1:?Usage: fund-invest-advisor sell <fund> <amount> [date]}"
    local amount="${2:?}"
    local date="${3:-$(date +%Y-%m-%d)}"
    printf '{"action":"sell","fund":"%s","amount":%s,"date":"%s"}\n' "$fund" "$amount" "$date" >> "$PORTFOLIO"
    echo "[fund] Sold: $fund ¥$amount on $date"
    _log "sell" "$fund ¥$amount"
}

cmd_holdings() {
    [ ! -f "$PORTFOLIO" ] && { echo "No holdings. Use: fund-invest-advisor add <fund> <amount>"; return; }
    python3 << PYEOF
import json
holdings = {}
with open('$PORTFOLIO') as f:
    for line in f:
        d = json.loads(line)
        fund = d['fund']
        amt = float(d['amount'])
        if d['action'] == 'buy':
            holdings[fund] = holdings.get(fund, 0) + amt
        else:
            holdings[fund] = holdings.get(fund, 0) - amt

total = sum(holdings.values())
print("  Portfolio Holdings:")
print("  {:20s} {:>12s} {:>8s}".format("Fund", "Amount", "Weight"))
print("  " + "─" * 42)
for fund, amt in sorted(holdings.items(), key=lambda x: -x[1]):
    if amt > 0:
        pct = amt / total * 100 if total > 0 else 0
        print("  {:20s} {:>12,.2f} {:>7.1f}%".format(fund, amt, pct))
print("  " + "─" * 42)
print("  {:20s} {:>12,.2f}".format("TOTAL", total))
PYEOF
}

cmd_allocation() {
    echo "  Asset Allocation:"
    echo "  ─────────────────────────"
    echo "  Stocks (equity funds):  ??%"
    echo "  Bonds (fixed income):   ??%"
    echo "  Money Market:           ??%"
    echo "  Other:                  ??%"
    echo ""
    echo "  Tip: Tag your funds with asset class for auto-allocation"
    echo "  fund-invest-advisor add 'SP500 [equity]' 10000"
}

cmd_score() {
    local fund="${1:?Usage: fund-invest-advisor score <fund>}"
    echo "  ═══ Fund Score: $fund ═══"
    echo ""
    echo "  ┌────────────────────┬───────┐"
    echo "  │ Criteria           │ Score │"
    echo "  ├────────────────────┼───────┤"
    echo "  │ Expense Ratio      │  ?/10 │"
    echo "  │ 3-Year Return      │  ?/10 │"
    echo "  │ Risk (Sharpe)      │  ?/10 │"
    echo "  │ Manager Tenure     │  ?/10 │"
    echo "  │ AUM Size           │  ?/10 │"
    echo "  ├────────────────────┼───────┤"
    echo "  │ TOTAL              │  ?/50 │"
    echo "  └────────────────────┴───────┘"
    echo ""
    echo "  Add fund data: fund-invest-advisor data $fund"
}

cmd_compare() {
    local f1="${1:?Usage: fund-invest-advisor compare <fund1> <fund2>}"
    local f2="${2:?}"
    echo "  ═══ Fund Comparison ═══"
    echo ""
    printf "  %-20s %-15s %-15s\n" "Metric" "$f1" "$f2"
    echo "  $(printf '─%.0s' $(seq 1 50))"
    printf "  %-20s %-15s %-15s\n" "Expense Ratio" "—" "—"
    printf "  %-20s %-15s %-15s\n" "1Y Return" "—" "—"
    printf "  %-20s %-15s %-15s\n" "3Y Return" "—" "—"
    printf "  %-20s %-15s %-15s\n" "Max Drawdown" "—" "—"
    printf "  %-20s %-15s %-15s\n" "Sharpe Ratio" "—" "—"
    echo ""
    echo "  Tip: Add data with 'fund-invest-advisor data <fund>'"
}

cmd_fees() {
    local fund="${1:?Usage: fund-invest-advisor fees <fund> <amount> <years>}"
    local amount="${2:?}"
    local years="${3:-10}"
    echo "  Fee Impact Calculator: $fund"
    for rate in 0.1 0.5 1.0 1.5 2.0; do
        local fee=$(python3 -c "print('{:,.0f}'.format($amount * $rate / 100 * $years))")
        local pct=$(python3 -c "print('{:.1f}'.format($rate * $years))")
        printf "  %4.1f%% fee × %d years = ¥%s (%s%% of principal)\n" "$rate" "$years" "$fee" "$pct"
    done
}

cmd_dca() {
    local amount="${1:?Usage: fund-invest-advisor dca <monthly-amount> <months>}"
    local months="${2:-12}"
    local total=$((amount * months))
    echo "  DCA Simulation:"
    echo "  Monthly: ¥$amount × $months months = ¥$total invested"
    echo ""
    for ret in -10 0 5 10 15; do
        local final=$(python3 -c "
total = 0
for i in range($months):
    total = (total + $amount) * (1 + $ret / 100 / 12)
print('{:,.0f}'.format(total))
")
        local gain=$((${final//,/} - total))
        printf "  %+3d%% annual return → ¥%s (gain: ¥%d)\n" "$ret" "$final" "$gain" 2>/dev/null || true
    done
}

cmd_risk() {
    echo "  ═══ Portfolio Risk Assessment ═══"
    echo "  Concentration:  Check if any fund > 25%"
    echo "  Correlation:    Are your funds diversified?"
    echo "  Drawdown:       What's the worst case?"
    echo "  Liquidity:      Can you sell when needed?"
    echo ""
    echo "  Use 'holdings' to review positions"
    echo "  Use 'allocation' to check balance"
}

cmd_model() {
    local type="${1:-balanced}"
    echo "  Model Portfolio: $type"
    case "$type" in
        conservative)
            echo "  Bonds:        60%"; echo "  Large Cap:    25%"
            echo "  Money Market: 10%"; echo "  Gold:          5%"
            ;;
        balanced)
            echo "  Large Cap:    40%"; echo "  Bonds:        30%"
            echo "  Intl:         15%"; echo "  Small Cap:    10%"
            echo "  REITs:         5%"
            ;;
        aggressive)
            echo "  Growth:       50%"; echo "  Small Cap:    20%"
            echo "  Intl/EM:      20%"; echo "  Bonds:        10%"
            ;;
        *) echo "  Models: conservative, balanced, aggressive" ;;
    esac
}

cmd_checklist() {
    echo "  ═══ Investment Checklist ═══"
    echo "  [ ] Expense ratio < 0.5%?"
    echo "  [ ] Fund size > ¥1B AUM?"
    echo "  [ ] Manager tenure > 3 years?"
    echo "  [ ] Consistent returns (not just recent)?"
    echo "  [ ] Fits portfolio allocation target?"
    echo "  [ ] Understood the risk factors?"
    echo "  [ ] Emergency fund separate?"
}

cmd_export() {
    local fmt="${1:-csv}"
    [ ! -f "$PORTFOLIO" ] && { echo "No data"; return; }
    case "$fmt" in
        csv) echo "action,fund,amount,date"; while IFS= read -r line; do echo "$line" | python3 -c "import json,sys; d=json.load(sys.stdin); print('{},{},{},{}'.format(d['action'],d['fund'],d['amount'],d['date']))"; done < "$PORTFOLIO" ;;
        json) echo "["; head -c -1 "$PORTFOLIO" | sed 's/$/,/'; tail -1 "$PORTFOLIO"; echo "]" ;;
        *) echo "Formats: csv, json" ;;
    esac
}

cmd_stats() {
    [ ! -f "$PORTFOLIO" ] && { echo "No data"; return; }
    local txns=$(wc -l < "$PORTFOLIO")
    echo "  Portfolio Stats:"
    echo "  Transactions: $txns"
    echo "  Data file:    $PORTFOLIO"
}

cmd_history() {
    [ ! -f "$PORTFOLIO" ] && { echo "No transactions"; return; }
    echo "  Transaction History:"
    while IFS= read -r line; do
        echo "$line" | python3 -c "
import json, sys
d = json.load(sys.stdin)
icon = '🟢' if d['action'] == 'buy' else '🔴'
print('  {} {} {} ¥{:,.0f} on {}'.format(icon, d['action'].upper(), d['fund'], float(d['amount']), d['date']))
" 2>/dev/null
    done < "$PORTFOLIO"
}

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

case "${1:-help}" in
    add)         shift; cmd_add "$@" ;;
    sell)        shift; cmd_sell "$@" ;;
    holdings)    cmd_holdings ;;
    allocation)  cmd_allocation ;;
    rebalance)   echo "TODO: rebalance" ;;
    pnl)         cmd_holdings ;;
    score)       shift; cmd_score "$@" ;;
    compare)     shift; cmd_compare "$@" ;;
    risk)        cmd_risk ;;
    fees)        shift; cmd_fees "$@" ;;
    dca)         shift; cmd_dca "$@" ;;
    screen)      echo "TODO: screening" ;;
    model)       shift; cmd_model "$@" ;;
    checklist)   cmd_checklist ;;
    calendar)    echo "TODO: calendar" ;;
    export)      shift; cmd_export "$@" ;;
    import)      echo "TODO: import" ;;
    stats)       cmd_stats ;;
    history)     cmd_history ;;
    help|-h)     show_help ;;
    version|-v)  echo "fund-invest-advisor v$VERSION" ;;
    *)           echo "Unknown: $1"; show_help; exit 1 ;;
esac
