#!/usr/bin/env bash
# return-policy — 电商退货政策生成器
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
run_python() {
python3 << 'PYEOF'
import sys
from datetime import datetime

cmd = sys.argv[1] if len(sys.argv) > 1 else "help"
inp = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else ""

def cmd_generate():
    if not inp:
        print("Usage: generate <store_name> [return_days] [refund_days]")
        print("Example: generate MyStore 30 7")
        return
    parts = inp.split()
    store = parts[0]
    ret_days = int(parts[1]) if len(parts) > 1 else 30
    refund_days = int(parts[2]) if len(parts) > 2 else 7

    print("=" * 60)
    print("  RETURN & REFUND POLICY")
    print("  {}".format(store))
    print("  Last Updated: {}".format(datetime.now().strftime("%Y-%m-%d")))
    print("=" * 60)
    print("")
    print("  1. RETURN WINDOW")
    print("  You have {} days from the date of delivery to".format(ret_days))
    print("  initiate a return. Items must be unused, in original")
    print("  packaging, with all tags attached.")
    print("")
    print("  2. ELIGIBLE ITEMS")
    print("  - Unused and undamaged products")
    print("  - Items in original packaging")
    print("  - Products with original tags/labels")
    print("  - Items purchased within {} days".format(ret_days))
    print("")
    print("  3. NON-RETURNABLE ITEMS")
    print("  - Perishable goods (food, flowers)")
    print("  - Personal care items (opened)")
    print("  - Customized or personalized products")
    print("  - Digital downloads or gift cards")
    print("  - Intimate apparel and swimwear")
    print("  - Hazardous materials")
    print("")
    print("  4. RETURN PROCESS")
    print("  Step 1: Contact us at support@{}.com".format(store.lower()))
    print("  Step 2: Receive your Return Authorization (RA) number")
    print("  Step 3: Pack item securely with RA number visible")
    print("  Step 4: Ship to our return center")
    print("  Step 5: Receive confirmation email upon processing")
    print("")
    print("  5. REFUNDS")
    print("  Refunds are processed within {} business days".format(refund_days))
    print("  after we receive your returned item.")
    print("  - Original payment method: {} business days".format(refund_days))
    print("  - Store credit: 1-2 business days")
    print("  - Shipping costs are non-refundable")
    print("")
    print("  6. EXCHANGES")
    print("  For exchanges, please return the original item and")
    print("  place a new order. This ensures the fastest service.")
    print("")
    print("  7. DAMAGED OR DEFECTIVE ITEMS")
    print("  If you receive a damaged or defective item:")
    print("  - Contact us within 48 hours of delivery")
    print("  - Include photos of the damage")
    print("  - We will provide a prepaid return label")
    print("  - Full refund or replacement at no extra cost")
    print("")
    print("  8. CONTACT")
    print("  Email: support@{}.com".format(store.lower()))
    print("  Response time: 1-2 business days")

def cmd_html():
    if not inp:
        print("Usage: html <store_name> [return_days]")
        return
    parts = inp.split()
    store = parts[0]
    days = int(parts[1]) if len(parts) > 1 else 30

    html = """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>{store} Return Policy</title>
<style>
body {{ font-family: -apple-system, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; line-height: 1.6; }}
h1 {{ color: #333; border-bottom: 2px solid #007bff; padding-bottom: 10px; }}
h2 {{ color: #555; margin-top: 30px; }}
.highlight {{ background: #f8f9fa; padding: 15px; border-left: 4px solid #007bff; margin: 15px 0; }}
ul {{ padding-left: 20px; }}
li {{ margin: 5px 0; }}
.updated {{ color: #888; font-size: 0.9em; }}
</style>
</head>
<body>
<h1>{store} Return &amp; Refund Policy</h1>
<p class="updated">Last Updated: {date}</p>

<div class="highlight">
<strong>Quick Summary:</strong> {days}-day returns. Free returns for defective items.
Refunds processed within 7 business days.
</div>

<h2>Return Window</h2>
<p>You have <strong>{days} days</strong> from delivery to initiate a return.</p>

<h2>How to Return</h2>
<ol>
<li>Contact support@{store_lower}.com with your order number</li>
<li>Receive your Return Authorization number</li>
<li>Ship the item back in original packaging</li>
<li>Refund processed within 7 business days</li>
</ol>

<h2>Non-Returnable Items</h2>
<ul>
<li>Perishable goods</li>
<li>Opened personal care items</li>
<li>Customized products</li>
<li>Digital downloads</li>
</ul>

<h2>Contact Us</h2>
<p>Email: support@{store_lower}.com</p>
</body>
</html>""".format(store=store, date=datetime.now().strftime("%Y-%m-%d"),
                   days=days, store_lower=store.lower())
    print(html)

def cmd_compare():
    print("=" * 65)
    print("  Return Policy Comparison — Industry Standards")
    print("=" * 65)
    print("")
    print("  {:20s} {:>8s} {:>10s} {:>12s} {:>10s}".format(
        "Retailer", "Days", "Free Ship", "Refund Time", "Restocking"))
    print("  " + "-" * 62)
    data = [
        ("Amazon", "30", "Yes", "3-5 days", "No"),
        ("Walmart", "90", "Yes", "5-7 days", "No"),
        ("Target", "90", "Yes", "5-7 days", "No"),
        ("Best Buy", "15", "No", "5-10 days", "15%"),
        ("Apple", "14", "Yes", "3-5 days", "No"),
        ("IKEA", "365", "No", "7-10 days", "No"),
        ("Costco", "90", "Yes", "Instant", "No"),
        ("Zara", "30", "No", "5-7 days", "No"),
        ("Nike", "60", "Yes", "5-10 days", "No"),
        ("YOUR STORE", "??", "??", "??", "??"),
    ]
    for row in data:
        print("  {:20s} {:>8s} {:>10s} {:>12s} {:>10s}".format(*row))

def cmd_cn():
    if not inp:
        print("Usage: cn <store_name> [return_days]")
        return
    parts = inp.split()
    store = parts[0]
    days = int(parts[1]) if len(parts) > 1 else 7

    print("=" * 55)
    print("  {} 退换货政策".format(store))
    print("  更新日期: {}".format(datetime.now().strftime("%Y-%m-%d")))
    print("=" * 55)
    print("")
    print("  一、退货规则")
    print("  收到商品后{}天内可申请退货（以签收日期为准）。".format(days))
    print("  退货商品需保持原包装完好，不影响二次销售。")
    print("")
    print("  二、退款方式")
    print("  - 原路退回：3-7个工作日到账")
    print("  - 退回运费：质量问题由卖家承担；非质量问题由买家承担")
    print("")
    print("  三、不支持退换的商品")
    print("  - 定制类商品")
    print("  - 生鲜食品")
    print("  - 已拆封的贴身衣物")
    print("  - 虚拟商品/充值卡")
    print("")
    print("  四、售后联系")
    print("  客服邮箱: service@{}.com".format(store.lower()))
    print("  处理时效: 24小时内回复")

commands = {
    "generate": cmd_generate, "html": cmd_html,
    "compare": cmd_compare, "cn": cmd_cn,
}
if cmd == "help":
    print("Return Policy Generator")
    print("")
    print("Commands:")
    print("  generate <store> [days] [refund_days] — Full return policy (English)")
    print("  cn <store> [days]                     — Chinese return policy")
    print("  html <store> [days]                   — HTML formatted policy")
    print("  compare                               — Industry standards comparison")
elif cmd in commands:
    commands[cmd]()
else:
    print("Unknown: {}".format(cmd))
print("")
print("Powered by BytesAgain | bytesagain.com")
PYEOF
}
run_python "$CMD" $INPUT
