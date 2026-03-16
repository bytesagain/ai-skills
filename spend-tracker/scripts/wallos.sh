#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# License: MIT — independent, not derived from any third-party source
# Expense tracker — personal finance management
set -euo pipefail
FIN_DIR="${FIN_DIR:-$HOME/.expenses}"
mkdir -p "$FIN_DIR"
DB="$FIN_DIR/expenses.json"
[ ! -f "$DB" ] && echo '[]' > "$DB"
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "Expense Tracker — personal finance manager
Commands:
  add <amount> <cat> [note]  Add expense
  income <amount> [note]     Add income
  list [n]                   Recent transactions
  today                      Today's spending
  month                      Monthly summary
  categories                 Spending by category
  budget <cat> <amount>      Set budget
  budget-check               Check budgets
  trend [months]             Spending trend
  export [format]            Export (csv/json/md)
  info                       Version info
Powered by BytesAgain | bytesagain.com";;
add)
    amount="${1:-0}"; cat="${2:-other}"; note="${3:-}"
    python3 << PYEOF
import json, time
with open("$DB") as f: data = json.load(f)
data.append({"type":"expense","amount":float("$amount"),"category":"$cat",
             "note":"$note","date":time.strftime("%Y-%m-%d"),"time":time.strftime("%H:%M")})
with open("$DB","w") as f: json.dump(data, f, indent=2)
print("💰 Expense: -\${} [{}] {}".format("$amount", "$cat", "$note"))
PYEOF
;;
income)
    amount="${1:-0}"; note="${2:-income}"
    python3 << PYEOF
import json, time
with open("$DB") as f: data = json.load(f)
data.append({"type":"income","amount":float("$amount"),"category":"income",
             "note":"$note","date":time.strftime("%Y-%m-%d"),"time":time.strftime("%H:%M")})
with open("$DB","w") as f: json.dump(data, f, indent=2)
print("💵 Income: +\${} {}".format("$amount", "$note"))
PYEOF
;;
list)
    n="${1:-10}"
    python3 << PYEOF
import json
with open("$DB") as f: data = json.load(f)
print("📋 Recent Transactions:")
for e in data[-int("$n"):][::-1]:
    icon = "🔴" if e["type"]=="expense" else "🟢"
    sign = "-" if e["type"]=="expense" else "+"
    print("  {} {} \${:<8.2f} {:10s} {} {}".format(icon, e["date"], e["amount"], e["category"][:10], e.get("note",""), e.get("time","")))
PYEOF
;;
today)
    python3 << PYEOF
import json, time
with open("$DB") as f: data = json.load(f)
today = time.strftime("%Y-%m-%d")
todays = [e for e in data if e["date"] == today]
spent = sum(e["amount"] for e in todays if e["type"]=="expense")
earned = sum(e["amount"] for e in todays if e["type"]=="income")
print("📅 Today ({}):".format(today))
for e in todays:
    icon = "🔴" if e["type"]=="expense" else "🟢"
    print("  {} \${:.2f} {} {}".format(icon, e["amount"], e["category"], e.get("note","")))
print("  Spent: \${:.2f} | Income: \${:.2f} | Net: \${:.2f}".format(spent, earned, earned-spent))
PYEOF
;;
month)
    python3 << PYEOF
import json, time
from collections import defaultdict
with open("$DB") as f: data = json.load(f)
month = time.strftime("%Y-%m")
monthly = [e for e in data if e["date"].startswith(month)]
by_cat = defaultdict(float)
for e in monthly:
    if e["type"]=="expense": by_cat[e["category"]] += e["amount"]
spent = sum(by_cat.values())
income = sum(e["amount"] for e in monthly if e["type"]=="income")
print("📊 {} Summary:".format(month))
print("  Income: \${:.2f}".format(income))
print("  Expenses: \${:.2f}".format(spent))
print("  Net: \${:.2f}".format(income - spent))
print("\n  By Category:")
for c, a in sorted(by_cat.items(), key=lambda x:-x[1]):
    pct = a*100/max(spent,0.01)
    bar = "█" * int(pct/5) + "░" * (20-int(pct/5))
    print("    {:12s} [{}] \${:.2f} ({:.0f}%)".format(c[:12], bar, a, pct))
PYEOF
;;
categories)
    python3 -c "
import json
from collections import defaultdict
with open('$DB') as f: data = json.load(f)
cats = defaultdict(float)
for e in data:
    if e['type']=='expense': cats[e['category']] += e['amount']
print('📂 Categories:')
for c, a in sorted(cats.items(), key=lambda x:-x[1]):
    print('  {:15s} \${:.2f}'.format(c, a))
";;
budget)
    cat="${1:-}"; amount="${2:-0}"
    [ -z "$cat" ] && { echo "Usage: budget <category> <amount>"; exit 1; }
    python3 -c "
import json
bf = '$FIN_DIR/budgets.json'
try:
    with open(bf) as f: budgets = json.load(f)
except: budgets = {}
budgets['$cat'] = float('$amount')
with open(bf,'w') as f: json.dump(budgets, f, indent=2)
print('✅ Budget set: $cat = \$$amount/month')
";;
budget-check)
    python3 << PYEOF
import json, time
from collections import defaultdict
bf = "$FIN_DIR/budgets.json"
try:
    with open(bf) as f: budgets = json.load(f)
except: budgets = {}
with open("$DB") as f: data = json.load(f)
month = time.strftime("%Y-%m")
spent = defaultdict(float)
for e in data:
    if e["date"].startswith(month) and e["type"]=="expense":
        spent[e["category"]] += e["amount"]
print("📊 Budget Check ({}):".format(month))
for cat, limit in sorted(budgets.items()):
    used = spent.get(cat, 0)
    pct = used*100/max(limit,0.01)
    icon = "✅" if pct < 80 else ("⚠" if pct < 100 else "🚨")
    print("  {} {:12s} \${:.0f}/\${:.0f} ({:.0f}%)".format(icon, cat[:12], used, limit, pct))
PYEOF
;;
trend)
    months="${1:-6}"
    python3 << PYEOF
import json, time
from collections import defaultdict
with open("$DB") as f: data = json.load(f)
by_month = defaultdict(float)
for e in data:
    if e["type"]=="expense":
        m = e["date"][:7]
        by_month[m] += e["amount"]
print("📈 Spending Trend:")
for m in sorted(by_month.keys())[-int("$months"):]:
    a = by_month[m]
    bar = "█" * int(a/100) if a < 2000 else "█" * 20
    print("  {} \${:>8.2f} {}".format(m, a, bar))
PYEOF
;;
export)
    fmt="${1:-csv}"
    python3 -c "
import json
with open('$DB') as f: data = json.load(f)
if '$fmt' == 'csv':
    print('date,type,amount,category,note')
    for e in data:
        print('{},{},{},{},{}'.format(e['date'],e['type'],e['amount'],e['category'],e.get('note','')))
elif '$fmt' == 'md':
    print('| Date | Type | Amount | Category | Note |')
    print('|------|------|--------|----------|------|')
    for e in data:
        print('| {} | {} | \${:.2f} | {} | {} |'.format(e['date'],e['type'],e['amount'],e['category'],e.get('note','')))
else:
    print(json.dumps(data, indent=2))
";;
info) echo "Expense Tracker v1.0.0"; echo "Track your spending, set budgets, stay on track"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
