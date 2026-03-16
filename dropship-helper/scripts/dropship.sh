#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
run_python() {
python3 << 'PYEOF'
import sys, math
cmd = sys.argv[1] if len(sys.argv) > 1 else "help"
inp = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else ""

def cmd_profit():
    if not inp:
        print("Usage: profit <cost> <sell_price> <shipping> [ad_cost] [units]")
        print("Example: profit 5 19.99 3 2 100")
        return
    p = inp.split()
    cost = float(p[0])
    sell = float(p[1])
    ship = float(p[2]) if len(p) > 2 else 0
    ad = float(p[3]) if len(p) > 3 else 0
    units = int(p[4]) if len(p) > 4 else 1
    platform_fee = sell * 0.029 + 0.30
    total_cost = cost + ship + ad + platform_fee
    profit = sell - total_cost
    margin = (profit / sell * 100) if sell > 0 else 0
    print("=" * 45)
    print("  Dropship Profit Calculator")
    print("=" * 45)
    print("")
    print("  Sell Price:     ${:.2f}".format(sell))
    print("  Product Cost:   ${:.2f}".format(cost))
    print("  Shipping:       ${:.2f}".format(ship))
    print("  Ad Cost/Unit:   ${:.2f}".format(ad))
    print("  Platform Fee:   ${:.2f} (2.9%+$0.30)".format(platform_fee))
    print("  " + "-" * 30)
    print("  Total Cost:     ${:.2f}".format(total_cost))
    print("  Profit/Unit:    ${:.2f}".format(profit))
    print("  Margin:         {:.1f}%".format(margin))
    if units > 1:
        print("")
        print("  At {} units/month:".format(units))
        print("  Revenue:  ${:,.2f}".format(sell * units))
        print("  Profit:   ${:,.2f}".format(profit * units))
    print("")
    if margin >= 30:
        print("  Verdict: GOOD margin (30%+)")
    elif margin >= 15:
        print("  Verdict: OK margin, optimize costs")
    else:
        print("  Verdict: LOW margin, reconsider pricing")

def cmd_supplier():
    print("=" * 55)
    print("  Supplier Evaluation Scorecard")
    print("=" * 55)
    print("")
    criteria = [
        ("Product Quality", "Sample inspection, reviews, certifications"),
        ("Price", "Unit cost, MOQ, bulk discounts"),
        ("Shipping Speed", "Processing time, delivery to customer"),
        ("Communication", "Response time, English proficiency"),
        ("Reliability", "Order accuracy, consistency"),
        ("Returns Policy", "Defect handling, refund process"),
        ("Payment Terms", "Methods accepted, credit terms"),
    ]
    print("  {:20s} {:>6s} {:>6s}  Notes".format("Criteria", "Score", "Weight"))
    print("  " + "-" * 55)
    for name, note in criteria:
        print("  {:20s} {:>5s}  {:>5s}  {}".format(name, "_/10", "___", note))
    print("")
    print("  Platforms to find suppliers:")
    print("    - AliExpress (small orders)")
    print("    - Alibaba (bulk/custom)")
    print("    - 1688.com (China domestic)")
    print("    - CJ Dropshipping (integrated)")
    print("    - Spocket (US/EU suppliers)")

def cmd_pricing():
    if not inp:
        print("Usage: pricing <cost> [target_margin]")
        print("Example: pricing 8 40")
        return
    parts = inp.split()
    cost = float(parts[0])
    target = float(parts[1]) if len(parts) > 1 else 30
    print("=" * 50)
    print("  Pricing Strategy")
    print("  Product Cost: ${:.2f}".format(cost))
    print("=" * 50)
    print("")
    print("  {:>8s} {:>8s} {:>8s} {:>10s}".format("Margin", "Price", "Profit", "Strategy"))
    print("  " + "-" * 40)
    for m in [20, 25, 30, 40, 50, 60]:
        price = cost / (1 - m/100)
        profit = price - cost
        star = " <--" if m == target else ""
        print("  {:>7.0f}% ${:>7.2f} ${:>7.2f} {}".format(m, price, profit, star))
    print("")
    print("  Recommended: {}% margin = ${:.2f}".format(target, cost / (1 - target/100)))

def cmd_shipping():
    if not inp:
        print("Usage: shipping <weight_kg> <origin> <dest>")
        print("Example: shipping 0.5 CN US")
        return
    parts = inp.split()
    weight = float(parts[0])
    origin = parts[1].upper() if len(parts) > 1 else "CN"
    dest = parts[2].upper() if len(parts) > 2 else "US"
    rates = {
        "CN-US": {"epacket": 3 + weight * 8, "standard": 5 + weight * 12, "express": 15 + weight * 25},
        "CN-EU": {"epacket": 4 + weight * 10, "standard": 6 + weight * 14, "express": 18 + weight * 28},
        "CN-UK": {"epacket": 4 + weight * 9, "standard": 6 + weight * 13, "express": 17 + weight * 26},
    }
    key = "{}-{}".format(origin, dest)
    r = rates.get(key, rates["CN-US"])
    print("=" * 50)
    print("  Shipping Estimate: {} to {} ({:.1f}kg)".format(origin, dest, weight))
    print("=" * 50)
    print("")
    print("  {:15s} {:>8s} {:>12s}".format("Method", "Cost", "Delivery"))
    print("  " + "-" * 38)
    times = {"epacket": "15-30 days", "standard": "10-20 days", "express": "5-10 days"}
    for method in ["epacket", "standard", "express"]:
        print("  {:15s} ${:>7.2f} {:>12s}".format(method, r[method], times[method]))

commands = {"profit": cmd_profit, "supplier": cmd_supplier, "pricing": cmd_pricing, "shipping": cmd_shipping}
if cmd == "help":
    print("Dropship Helper")
    print("")
    print("Commands:")
    print("  profit <cost> <price> <ship> [ad] [units] — Profit calculator")
    print("  supplier                                   — Supplier evaluation")
    print("  pricing <cost> [margin]                    — Pricing strategy")
    print("  shipping <kg> <from> <to>                  — Shipping estimator")
elif cmd in commands:
    commands[cmd]()
else:
    print("Unknown: {}".format(cmd))
print("")
print("Powered by BytesAgain | bytesagain.com")
PYEOF
}
run_python "$CMD" $INPUT
