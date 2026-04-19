#!/usr/bin/env bash
# budget-tracker v2.0.0 - Local Personal Finance Manager
# Powered by BytesAgain | bytesagain.com
set -uo pipefail
VERSION="2.0.0"
DB_DIR="$HOME/.budget-tracker"
DB_FILE="$DB_DIR/ledger.json"
mkdir -p "$DB_DIR"
[ -f "$DB_FILE" ] || echo '[]' > "$DB_FILE"

_log() { echo "[$(date '+%H:%M:%S')] $*" >&2; }

_py_call() {
    DATA_FILE="$DB_FILE" python3 -u - "$@" << 'PYEOF'
import sys, json, os, time
from datetime import datetime

db_file = os.environ.get("DATA_FILE")
cmd = sys.argv[1]

with open(db_file, 'r') as f:
    db = json.load(f)

if cmd == "add":
    amount = float(sys.argv[2])
    cat = sys.argv[3]
    note = sys.argv[4]
    db.append({
        "ts": datetime.now().isoformat(),
        "amount": amount,
        "category": cat,
        "note": note
    })
    print(f"✅ Recorded: {'Income' if amount > 0 else 'Expense'} of {abs(amount)} in {cat}")

elif cmd == "list":
    print(f"{'Date':20s} | {'Amount':>10s} | {'Category':15s} | {'Note'}")
    print("-" * 65)
    for entry in db[-10:]:
        dt = entry['ts'][:16].replace('T', ' ')
        print(f"{dt:20s} | {entry['amount']:>10.2f} | {entry['category']:15s} | {entry['note']}")

elif cmd == "report":
    total_in = sum(e['amount'] for e in db if e['amount'] > 0)
    total_out = sum(e['amount'] for e in db if e['amount'] < 0)
    print("📊 Monthly Financial Summary")
    print(f"──────────────────────────────────────────")
    print(f"Total Income:   ¥{total_in:.2f}")
    print(f"Total Expense:  ¥{abs(total_out):.2f}")
    print(f"Net Balance:    ¥{total_in + total_out:.2f}")
    print(f"──────────────────────────────────────────")

with open(db_file, 'w') as f:
    json.dump(db, f, indent=2)
PYEOF
}

cmd_add() {
    local amt="${1:-0}"; local cat="${2:-General}"; local note="${3:-No note}"
    _py_call add "$amt" "$cat" "$note"
}

case "${1:-help}" in
    add) shift; cmd_add "$@" ;;
    list) _py_call list ;;
    report) _py_call report ;;
    *) echo "Usage: script.sh add <amount> <category> <note> | list | report" ;;
esac
echo -e "\n📖 More skills: bytesagain.com"
