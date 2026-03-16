#!/bin/bash
# personal-bookkeeper — Personal Finance Tracker
# Original implementation by BytesAgain

DATA_DIR="${HOME}/.bookkeeper"
mkdir -p "$DATA_DIR"
LEDGER="$DATA_DIR/ledger.json"
[ -f "$LEDGER" ] || echo '[]' > "$LEDGER"

show_help() {
    cat << 'HELP'
Personal Bookkeeper — Track income, expenses & budgets

Commands:
  income    Record income
  expense   Record expense
  balance   Show current balance
  report    Monthly summary report
  category  Breakdown by category
  budget    Set & check budget limits
  export    Export to CSV
  search    Search transactions
  help      Show this help

Usage:
  bookkeeper.sh income 5000 --note "Salary" --cat work
  bookkeeper.sh expense 120 --note "Groceries" --cat food
  bookkeeper.sh balance
  bookkeeper.sh report 2024-03
HELP
}

add_entry() {
    local entry_type="$1"; shift
    local amount="$1"; shift
    local note="" category="misc"
    while [ $# -gt 0 ]; do
        case "$1" in
            --note) note="$2"; shift 2 ;;
            --cat) category="$2"; shift 2 ;;
            *) shift ;;
        esac
    done
    [ -z "$amount" ] && { echo "Usage: $entry_type <amount> --note <text> --cat <category>"; return 1; }
    python3 -c "
import json
with open('$LEDGER') as f: ledger = json.load(f)
ledger.append({
    'type': '$entry_type', 'amount': float('$amount'),
    'note': '''$note''', 'category': '$category',
    'date': '$(date +%Y-%m-%d)', 'time': '$(date +%H:%M)'
})
with open('$LEDGER','w') as f: json.dump(ledger, f, indent=2)
sym = '+' if '$entry_type' == 'income' else '-'
print('  {}{} [{}] {}'.format(sym, '$amount', '$category', '$note' if '$note' else ''))
"
}

cmd_balance() {
    python3 -c "
import json
with open('$LEDGER') as f: ledger = json.load(f)
income = sum(e['amount'] for e in ledger if e['type'] == 'income')
expense = sum(e['amount'] for e in ledger if e['type'] == 'expense')
balance = income - expense
print('Balance Summary:')
print('  Income:  +{:,.2f}'.format(income))
print('  Expense: -{:,.2f}'.format(expense))
print('  ─────────────')
print('  Balance:  {:,.2f}'.format(balance))
"
}

cmd_report() {
    local month="${1:-$(date +%Y-%m)}"
    python3 -c "
import json
from collections import Counter
with open('$LEDGER') as f: ledger = json.load(f)
monthly = [e for e in ledger if e['date'].startswith('$month')]
income = sum(e['amount'] for e in monthly if e['type'] == 'income')
expense = sum(e['amount'] for e in monthly if e['type'] == 'expense')
print('Report: $month')
print('  Transactions: {}'.format(len(monthly)))
print('  Income:  +{:,.2f}'.format(income))
print('  Expense: -{:,.2f}'.format(expense))
print('  Net:      {:,.2f}'.format(income - expense))
print('')
# Top expenses
exp_cats = Counter()
for e in monthly:
    if e['type'] == 'expense': exp_cats[e['category']] += e['amount']
if exp_cats:
    print('Top Expense Categories:')
    for cat, amt in exp_cats.most_common(5):
        pct = amt / expense * 100 if expense > 0 else 0
        bar = '█' * int(pct / 5)
        print('  {:15s} {:>10,.2f} {:>5.1f}% {}'.format(cat, amt, pct, bar))
"
}

cmd_category() {
    python3 -c "
import json
from collections import Counter
with open('$LEDGER') as f: ledger = json.load(f)
cats = Counter()
for e in ledger:
    key = ('+' if e['type']=='income' else '-') + e['category']
    cats[key] += e['amount']
print('Categories:')
for key, amt in sorted(cats.items()):
    print('  {:20s} {:>10,.2f}'.format(key, amt))
"
}

cmd_budget() {
    local cat="$1" limit="$2"
    if [ -z "$cat" ]; then
        echo "Usage: budget <category> <monthly_limit>"
        echo "       budget check"
        return 1
    fi
    local budget_file="$DATA_DIR/budgets.json"
    [ -f "$budget_file" ] || echo '{}' > "$budget_file"
    
    if [ "$cat" = "check" ]; then
        python3 -c "
import json
with open('$budget_file') as f: budgets = json.load(f)
with open('$LEDGER') as f: ledger = json.load(f)
import datetime
month = datetime.date.today().strftime('%Y-%m')
for cat, limit in budgets.items():
    spent = sum(e['amount'] for e in ledger if e['type']=='expense' and e['category']==cat and e['date'].startswith(month))
    pct = spent/limit*100 if limit > 0 else 0
    status = '✅' if pct < 80 else '⚠️' if pct < 100 else '🔴'
    bar = '█' * min(int(pct/5), 20)
    print('{} {:15s} {:>8,.0f}/{:>8,.0f} ({:.0f}%) {}'.format(status, cat, spent, limit, pct, bar))
"
    else
        python3 -c "
import json
with open('$budget_file') as f: budgets = json.load(f)
budgets['$cat'] = float('$limit')
with open('$budget_file','w') as f: json.dump(budgets, f, indent=2)
print('  Budget set: $cat = $limit/month')
"
    fi
}

cmd_export() {
    python3 -c "
import json
with open('$LEDGER') as f: ledger = json.load(f)
print('date,type,amount,category,note')
for e in ledger:
    note = e.get('note','').replace(',',';')
    print('{},{},{},{},{}'.format(e['date'],e['type'],e['amount'],e['category'],note))
"
}

cmd_search() {
    local query="$*"
    [ -z "$query" ] && { echo "Usage: search <keyword>"; return 1; }
    python3 -c "
import json
with open('$LEDGER') as f: ledger = json.load(f)
q = '$query'.lower()
found = [e for e in ledger if q in e.get('note','').lower() or q in e['category'].lower()]
print('Search: \"$query\" ({} results)'.format(len(found)))
for e in found:
    sym = '+' if e['type'] == 'income' else '-'
    print('  {} {:10s} {}{:>10,.2f} [{}] {}'.format(e['date'], e.get('time',''), sym, e['amount'], e['category'], e.get('note','')))
"
}

case "${1:-help}" in
    income)   shift; add_entry income "$@" ;;
    expense)  shift; add_entry expense "$@" ;;
    balance)  cmd_balance ;;
    report)   cmd_report "$2" ;;
    category) cmd_category ;;
    budget)   shift; cmd_budget "$@" ;;
    export)   cmd_export ;;
    search)   shift; cmd_search "$@" ;;
    help)     show_help ;;
    *)        echo "Unknown: $1"; show_help ;;
esac
