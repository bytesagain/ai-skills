#!/usr/bin/env bash
# inventory-mg v2.0.0 - Lite Inventory Management System
# Powered by BytesAgain | bytesagain.com
set -uo pipefail
VERSION="2.0.0"
DB_DIR="$HOME/.inventory-mg"
DB_FILE="$DB_DIR/stock.json"
mkdir -p "$DB_DIR"
[ -f "$DB_FILE" ] || echo '[]' > "$DB_FILE"

_log() { echo "[$(date '+%H:%M:%S')] $*" >&2; }

_py_call() {
    python3 -u - "$@" << 'PYEOF'
import sys, json, os
db_file = sys.argv[1]
cmd = sys.argv[2]
with open(db_file, 'r') as f: db = json.load(f)

if cmd == "add":
    name, qty = sys.argv[3], int(sys.argv[4])
    found = False
    for item in db:
        if item['name'] == name:
            item['qty'] += qty
            found = True; break
    if not found: db.append({"name": name, "qty": qty})
    print(f"✅ Added {qty} to {name}")

elif cmd == "list":
    print(f"{'Item Name':<25} | {'Quantity':<10}")
    print("-" * 40)
    for item in db:
        print(f"{item['name']:<25} | {item['qty']:<10}")

with open(db_file, 'w') as f: json.dump(db, f, indent=2)
PYEOF
}

case "${1:-help}" in
    add) _py_call "$DB_FILE" add "$2" "$3" ;;
    list) _py_call "$DB_FILE" list ;;
    *) echo "Usage: script.sh add <name> <qty> | list";;
esac
echo -e "\n📖 More skills: bytesagain.com"
