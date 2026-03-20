#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# portfolio/scripts/script.sh — Investment portfolio manager.
# Add/remove holdings, analyze allocation, rebalance, calculate performance.
###############################################################################

DATA_DIR="${HOME}/.portfolio"
HOLDINGS_FILE="${DATA_DIR}/holdings.json"
TRANSACTIONS_FILE="${DATA_DIR}/transactions.json"

ensure_data_dir() {
  mkdir -p "${DATA_DIR}"
  if [[ ! -f "${HOLDINGS_FILE}" ]]; then
    echo '[]' > "${HOLDINGS_FILE}"
  fi
  if [[ ! -f "${TRANSACTIONS_FILE}" ]]; then
    echo '[]' > "${TRANSACTIONS_FILE}"
  fi
}

# ─── add ─────────────────────────────────────────────────────────────────────

cmd_add() {
  ensure_data_dir
  local ticker="" quantity="" price="" date=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --date) date="$2"; shift 2 ;;
      -*)     echo "Unknown flag: $1" >&2; return 1 ;;
      *)
        if [[ -z "${ticker}" ]]; then
          ticker=$(echo "$1" | tr '[:lower:]' '[:upper:]')
        elif [[ -z "${quantity}" ]]; then
          quantity="$1"
        elif [[ -z "${price}" ]]; then
          price="$1"
        fi
        shift
        ;;
    esac
  done

  if [[ -z "${ticker}" || -z "${quantity}" || -z "${price}" ]]; then
    echo "Usage: script.sh add <ticker> <quantity> <price> [--date YYYY-MM-DD]" >&2
    return 1
  fi

  if [[ -z "${date}" ]]; then
    date=$(date +%Y-%m-%d)
  fi

  HOLDINGS_FILE="$HOLDINGS_FILE" TRANSACTIONS_FILE="$TRANSACTIONS_FILE" \
  TICKER="$ticker" QUANTITY="$quantity" PRICE="$price" DATE="$date" \
  python3 << 'PYEOF'
import json, sys, os

holdings_file = os.environ["HOLDINGS_FILE"]
transactions_file = os.environ["TRANSACTIONS_FILE"]
ticker = os.environ["TICKER"]
qty = float(os.environ["QUANTITY"])
px = float(os.environ["PRICE"])
dt = os.environ["DATE"]

holdings = json.load(open(holdings_file))
transactions = json.load(open(transactions_file))

# Update holdings — merge if ticker exists
found = False
for h in holdings:
    if h['ticker'] == ticker:
        old_qty = h['quantity']
        old_cost = h['avg_price'] * old_qty
        new_cost = px * qty
        h['quantity'] = old_qty + qty
        h['avg_price'] = round((old_cost + new_cost) / (old_qty + qty), 4)
        found = True
        break

if not found:
    holdings.append({
        'ticker': ticker,
        'quantity': qty,
        'avg_price': px,
        'date_added': dt
    })

transactions.append({
    'type': 'buy',
    'ticker': ticker,
    'quantity': qty,
    'price': px,
    'date': dt
})

json.dump(holdings, open(holdings_file, 'w'), indent=2)
json.dump(transactions, open(transactions_file, 'w'), indent=2)
print(f'Added {qty} shares of {ticker} at ${px} on {dt}.')
PYEOF
}

# ─── remove ──────────────────────────────────────────────────────────────────

cmd_remove() {
  ensure_data_dir
  local ticker="" quantity=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --quantity) quantity="$2"; shift 2 ;;
      -*)         echo "Unknown flag: $1" >&2; return 1 ;;
      *)          ticker=$(echo "$1" | tr '[:lower:]' '[:upper:]'); shift ;;
    esac
  done

  if [[ -z "${ticker}" ]]; then
    echo "Usage: script.sh remove <ticker> [--quantity N]" >&2
    return 1
  fi

  local sell_date
  sell_date=$(date +%Y-%m-%d)

  HOLDINGS_FILE="$HOLDINGS_FILE" TRANSACTIONS_FILE="$TRANSACTIONS_FILE" \
  TICKER="$ticker" QUANTITY="$quantity" SELL_DATE="$sell_date" \
  python3 << 'PYEOF'
import json, sys, os

holdings_file = os.environ["HOLDINGS_FILE"]
transactions_file = os.environ["TRANSACTIONS_FILE"]
ticker = os.environ["TICKER"]
qty_to_remove = os.environ["QUANTITY"]
sell_date = os.environ["SELL_DATE"]

holdings = json.load(open(holdings_file))
transactions = json.load(open(transactions_file))

found = False
new_holdings = []
for h in holdings:
    if h['ticker'] == ticker:
        found = True
        if qty_to_remove and float(qty_to_remove) < h['quantity']:
            removed = float(qty_to_remove)
            h['quantity'] -= removed
            new_holdings.append(h)
            print(f'Removed {removed} shares of {ticker}. Remaining: {h["quantity"]}')
        else:
            removed = h['quantity']
            print(f'Removed all {removed} shares of {ticker}.')
        transactions.append({
            'type': 'sell',
            'ticker': ticker,
            'quantity': removed,
            'price': h['avg_price'],
            'date': sell_date
        })
    else:
        new_holdings.append(h)

if not found:
    print(f'Ticker {ticker} not found in portfolio.')
    sys.exit(1)

json.dump(new_holdings, open(holdings_file, 'w'), indent=2)
json.dump(transactions, open(transactions_file, 'w'), indent=2)
PYEOF
}

# ─── list ────────────────────────────────────────────────────────────────────

cmd_list() {
  ensure_data_dir
  local format="table"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --format) format="$2"; shift 2 ;;
      -*)       echo "Unknown flag: $1" >&2; return 1 ;;
      *)        shift ;;
    esac
  done

  HOLDINGS_FILE="$HOLDINGS_FILE" FORMAT="$format" python3 << 'PYEOF'
import json, os

holdings_file = os.environ["HOLDINGS_FILE"]
fmt = os.environ["FORMAT"]

holdings = json.load(open(holdings_file))

if not holdings:
    print('Portfolio is empty. Use "script.sh add" to add holdings.')
    exit(0)

if fmt == 'json':
    print(json.dumps(holdings, indent=2))
elif fmt == 'csv':
    print('ticker,quantity,avg_price,value,date_added')
    for h in holdings:
        val = round(h['quantity'] * h['avg_price'], 2)
        print(f"{h['ticker']},{h['quantity']},{h['avg_price']},{val},{h.get('date_added','')}")
else:
    total = 0
    print(f"{'Ticker':<10} {'Qty':>10} {'Avg Price':>12} {'Value':>14} {'Date Added':>12}")
    print('-' * 60)
    for h in holdings:
        val = round(h['quantity'] * h['avg_price'], 2)
        total += val
        print(f"{h['ticker']:<10} {h['quantity']:>10.2f} {h['avg_price']:>12.4f} {val:>14.2f} {h.get('date_added',''):>12}")
    print('-' * 60)
    print(f"{'TOTAL':<10} {'':>10} {'':>12} {total:>14.2f}")
PYEOF
}

# ─── analyze ─────────────────────────────────────────────────────────────────

cmd_analyze() {
  ensure_data_dir
  local by="ticker" format="table"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --by)     by="$2"; shift 2 ;;
      --format) format="$2"; shift 2 ;;
      -*)       echo "Unknown flag: $1" >&2; return 1 ;;
      *)        shift ;;
    esac
  done

  HOLDINGS_FILE="$HOLDINGS_FILE" FORMAT="$format" BY="$by" python3 << 'PYEOF'
import json, os

holdings_file = os.environ["HOLDINGS_FILE"]
fmt = os.environ["FORMAT"]
by = os.environ["BY"]

holdings = json.load(open(holdings_file))

if not holdings:
    print('Portfolio is empty.')
    exit(0)

# Calculate values
values = {}
total = 0
for h in holdings:
    val = h['quantity'] * h['avg_price']
    key = h['ticker']
    values[key] = values.get(key, 0) + val
    total += val

if total == 0:
    print('Portfolio total value is zero.')
    exit(0)

if fmt == 'json':
    result = []
    for k, v in sorted(values.items(), key=lambda x: -x[1]):
        result.append({'asset': k, 'value': round(v, 2), 'weight_pct': round(v / total * 100, 2)})
    print(json.dumps({'total': round(total, 2), 'allocations': result}, indent=2))
else:
    print(f'=== Portfolio Allocation (by {by}) ===')
    print(f"{'Asset':<12} {'Value':>12} {'Weight':>10}")
    print('-' * 36)
    for k, v in sorted(values.items(), key=lambda x: -x[1]):
        pct = v / total * 100
        bar = '█' * int(pct / 2)
        print(f'{k:<12} {v:>12.2f} {pct:>8.1f}%  {bar}')
    print('-' * 36)
    print(f"{'TOTAL':<12} {total:>12.2f} {'100.0%':>10}")
PYEOF
}

# ─── rebalance ───────────────────────────────────────────────────────────────

cmd_rebalance() {
  ensure_data_dir
  local target="" threshold=5

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --target)    target="$2"; shift 2 ;;
      --threshold) threshold="$2"; shift 2 ;;
      -*)          echo "Unknown flag: $1" >&2; return 1 ;;
      *)           shift ;;
    esac
  done

  HOLDINGS_FILE="$HOLDINGS_FILE" TARGET="$target" THRESHOLD="$threshold" python3 << 'PYEOF'
import json, os

holdings_file = os.environ["HOLDINGS_FILE"]
target_str = os.environ["TARGET"]
threshold = float(os.environ["THRESHOLD"])

holdings = json.load(open(holdings_file))

if not holdings:
    print('Portfolio is empty.')
    exit(0)

# Parse targets: AAPL:40,GOOG:30,MSFT:30
targets = {}
if target_str:
    for pair in target_str.split(','):
        parts = pair.strip().split(':')
        if len(parts) == 2:
            targets[parts[0].upper()] = float(parts[1])

# Current allocation
total = sum(h['quantity'] * h['avg_price'] for h in holdings)
if total == 0:
    print('Portfolio total is zero.')
    exit(0)

current = {}
for h in holdings:
    val = h['quantity'] * h['avg_price']
    current[h['ticker']] = round(val / total * 100, 2)

# If no targets given, default to equal weight
if not targets:
    tickers = list(current.keys())
    equal = round(100 / len(tickers), 2)
    targets = {t: equal for t in tickers}

print('=== Rebalance Suggestions ===')
print(f"{'Ticker':<10} {'Current%':>10} {'Target%':>10} {'Diff%':>10} {'Action':>12}")
print('-' * 54)

all_tickers = set(list(current.keys()) + list(targets.keys()))
for t in sorted(all_tickers):
    cur = current.get(t, 0)
    tgt = targets.get(t, 0)
    diff = round(cur - tgt, 2)
    if abs(diff) > threshold:
        action = 'SELL' if diff > 0 else 'BUY'
        amt = round(abs(diff) / 100 * total, 2)
        print(f'{t:<10} {cur:>9.1f}% {tgt:>9.1f}% {diff:>+9.1f}%  {action} ${amt:.2f}')
    else:
        print(f'{t:<10} {cur:>9.1f}% {tgt:>9.1f}% {diff:>+9.1f}%  OK')

print()
print(f'Threshold: {threshold}% | Portfolio value: ${total:.2f}')
PYEOF
}

# ─── performance ─────────────────────────────────────────────────────────────

cmd_performance() {
  ensure_data_dir
  local period="all" format="table"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --period) period="$2"; shift 2 ;;
      --format) format="$2"; shift 2 ;;
      -*)       echo "Unknown flag: $1" >&2; return 1 ;;
      *)        shift ;;
    esac
  done

  HOLDINGS_FILE="$HOLDINGS_FILE" TRANSACTIONS_FILE="$TRANSACTIONS_FILE" \
  PERIOD="$period" FORMAT="$format" python3 << 'PYEOF'
import json, os
from datetime import datetime, timedelta

holdings_file = os.environ["HOLDINGS_FILE"]
transactions_file = os.environ["TRANSACTIONS_FILE"]
period = os.environ["PERIOD"]
fmt = os.environ["FORMAT"]

holdings = json.load(open(holdings_file))
transactions = json.load(open(transactions_file))

if not holdings and not transactions:
    print('No portfolio data. Add holdings first.')
    exit(0)

# Filter transactions by period
now = datetime.now()
period_map = {
    '1d': timedelta(days=1),
    '1w': timedelta(weeks=1),
    '1m': timedelta(days=30),
    '3m': timedelta(days=90),
    '1y': timedelta(days=365),
}

if period in period_map:
    cutoff = now - period_map[period]
else:
    cutoff = datetime.min

filtered = []
for t in transactions:
    try:
        td = datetime.strptime(t['date'], '%Y-%m-%d')
        if td >= cutoff:
            filtered.append(t)
    except (ValueError, KeyError):
        filtered.append(t)

total_invested = sum(t['quantity'] * t['price'] for t in filtered if t['type'] == 'buy')
total_sold = sum(t['quantity'] * t['price'] for t in filtered if t['type'] == 'sell')
current_value = sum(h['quantity'] * h['avg_price'] for h in holdings)

gain = current_value + total_sold - total_invested
gain_pct = (gain / total_invested * 100) if total_invested > 0 else 0

if fmt == 'json':
    print(json.dumps({
        'period': period,
        'total_invested': round(total_invested, 2),
        'total_sold': round(total_sold, 2),
        'current_value': round(current_value, 2),
        'gain_loss': round(gain, 2),
        'return_pct': round(gain_pct, 2),
        'transactions_count': len(filtered)
    }, indent=2))
else:
    print(f'=== Portfolio Performance ({period}) ===')
    print(f'Total invested:    ${total_invested:>12.2f}')
    print(f'Total sold:        ${total_sold:>12.2f}')
    print(f'Current value:     ${current_value:>12.2f}')
    sign = '+' if gain >= 0 else ''
    print(f'Gain/Loss:         ${sign}{gain:>11.2f} ({sign}{gain_pct:.2f}%)')
    print(f'Transactions:      {len(filtered):>12}')
PYEOF
}

# ─── help ────────────────────────────────────────────────────────────────────

cmd_help() {
  cat <<'EOF'
portfolio — Investment portfolio manager.

Commands:
  add          Add a position (ticker, quantity, price)
  remove       Remove a position or reduce quantity
  list         Display all current holdings
  analyze      Analyze portfolio allocation by asset
  rebalance    Generate rebalance suggestions against target weights
  performance  Calculate portfolio returns over a period
  help         Show this help message

Examples:
  script.sh add AAPL 100 150.50 --date 2024-01-15
  script.sh add BTC 0.5 42000
  script.sh remove AAPL --quantity 50
  script.sh list --format json
  script.sh analyze --format table
  script.sh rebalance --target AAPL:40,GOOG:30,BTC:30 --threshold 3
  script.sh performance --period 1m
EOF
}

# ─── main dispatch ───────────────────────────────────────────────────────────

main() {
  if [[ $# -lt 1 ]]; then
    cmd_help
    exit 1
  fi

  local command="$1"
  shift

  case "${command}" in
    add)         cmd_add "$@" ;;
    remove)      cmd_remove "$@" ;;
    list)        cmd_list "$@" ;;
    analyze)     cmd_analyze "$@" ;;
    rebalance)   cmd_rebalance "$@" ;;
    performance) cmd_performance "$@" ;;
    help|--help|-h) cmd_help ;;
    *)
      echo "Unknown command: ${command}" >&2
      echo "Run 'script.sh help' for usage." >&2
      exit 1
      ;;
  esac
}

main "$@"
