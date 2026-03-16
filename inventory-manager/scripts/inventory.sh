#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
DATA_FILE="/tmp/inventory-data.json"
run_python() {
python3 << 'PYEOF'
import sys, json, os
from datetime import datetime

cmd = sys.argv[1] if len(sys.argv) > 1 else "help"
inp = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else ""
data_file = "/tmp/inventory-data.json"

def load():
    if os.path.exists(data_file):
        with open(data_file) as f:
            return json.load(f)
    return {"items": [], "log": []}

def save(data):
    with open(data_file, "w") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

def cmd_add():
    if not inp:
        print("Usage: add <name> <quantity> <price> [category]")
        return
    parts = inp.split()
    name = parts[0]
    qty = int(parts[1]) if len(parts) > 1 else 0
    price = float(parts[2]) if len(parts) > 2 else 0
    cat = parts[3] if len(parts) > 3 else "general"
    data = load()
    item = {"name": name, "qty": qty, "price": price, "category": cat,
            "added": datetime.now().strftime("%Y-%m-%d %H:%M")}
    data["items"].append(item)
    data["log"].append({"action": "add", "item": name, "qty": qty, "time": item["added"]})
    save(data)
    print("Added: {} x{} @{:.2f} [{}]".format(name, qty, price, cat))

def cmd_list():
    data = load()
    if not data["items"]:
        print("  Inventory is empty. Use: add <name> <qty> <price>")
        return
    print("=" * 60)
    print("  Inventory ({} items)".format(len(data["items"])))
    print("=" * 60)
    print("")
    print("  {:20s} {:>6s} {:>10s} {:>10s} {:>8s}".format("Name","Qty","Price","Value","Category"))
    print("  " + "-" * 56)
    total_val = 0
    for item in sorted(data["items"], key=lambda x: x.get("category","")):
        val = item["qty"] * item["price"]
        total_val += val
        low = " LOW!" if item["qty"] < 5 else ""
        print("  {:20s} {:>6d} {:>10.2f} {:>10.2f} {:>8s}{}".format(
            item["name"], item["qty"], item["price"], val, item.get("category",""), low))
    print("  " + "-" * 56)
    print("  {:20s} {:>6s} {:>10s} {:>10.2f}".format("TOTAL","","",total_val))

def cmd_adjust():
    if not inp:
        print("Usage: adjust <name> <+/-qty>")
        print("Example: adjust Widget +50 or adjust Widget -10")
        return
    parts = inp.split()
    name = parts[0]
    delta = int(parts[1]) if len(parts) > 1 else 0
    data = load()
    found = False
    for item in data["items"]:
        if item["name"].lower() == name.lower():
            item["qty"] += delta
            found = True
            data["log"].append({"action":"adjust","item":name,"delta":delta,"new_qty":item["qty"],
                "time":datetime.now().strftime("%Y-%m-%d %H:%M")})
            print("  {} qty: {} (delta: {:+d})".format(name, item["qty"], delta))
            if item["qty"] < 5:
                print("  WARNING: Low stock!")
            break
    if not found:
        print("  Item not found: {}".format(name))
    else:
        save(data)

def cmd_report():
    data = load()
    items = data["items"]
    if not items:
        print("  No data")
        return
    print("=" * 50)
    print("  Inventory Report — {}".format(datetime.now().strftime("%Y-%m-%d")))
    print("=" * 50)
    cats = {}
    total_val = 0
    low_stock = []
    for item in items:
        c = item.get("category", "general")
        cats.setdefault(c, {"count": 0, "value": 0})
        cats[c]["count"] += 1
        val = item["qty"] * item["price"]
        cats[c]["value"] += val
        total_val += val
        if item["qty"] < 5:
            low_stock.append(item)
    print("")
    print("  By Category:")
    for c, info in sorted(cats.items()):
        print("    {:15s} {:>3d} items  ${:>10,.2f}".format(c, info["count"], info["value"]))
    print("  Total value: ${:,.2f}".format(total_val))
    print("  Total SKUs: {}".format(len(items)))
    if low_stock:
        print("")
        print("  LOW STOCK ALERT:")
        for item in low_stock:
            print("    {} — only {} left!".format(item["name"], item["qty"]))

def cmd_log():
    data = load()
    entries = data.get("log", [])[-20:]
    print("  Recent Activity:")
    for e in reversed(entries):
        print("  [{}] {} {} {}".format(e.get("time","?"), e["action"], e["item"],
            "qty={}".format(e.get("qty", e.get("delta","")))))

commands = {"add": cmd_add, "list": cmd_list, "adjust": cmd_adjust, "report": cmd_report, "log": cmd_log}
if cmd == "help":
    print("Inventory Manager")
    print("")
    print("Commands:")
    print("  add <name> <qty> <price> [cat]  — Add new item")
    print("  list                            — Show all inventory")
    print("  adjust <name> <+/-qty>          — Adjust stock level")
    print("  report                          — Summary report")
    print("  log                             — Recent activity log")
elif cmd in commands:
    commands[cmd]()
else:
    print("Unknown: {}".format(cmd))
print("")
print("Powered by BytesAgain | bytesagain.com")
PYEOF
}
run_python "$CMD" $INPUT
