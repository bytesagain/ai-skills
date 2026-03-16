#!/usr/bin/env bash
# Crypto Tax Calculator — Calculate capital gains from crypto trading
# Usage: bash tax.sh <command> [options]
set -euo pipefail

COMMAND="${1:-help}"
shift 2>/dev/null || true

DATA_DIR="${HOME}/.crypto-tax"
mkdir -p "$DATA_DIR"

case "$COMMAND" in
  import)
    FILE="${1:-}"
    FORMAT="${2:-generic}"
    
    python3 << 'PYEOF'
import csv, json, sys, os, time

data_dir = os.path.expanduser("~/.crypto-tax")
file_path = sys.argv[1] if len(sys.argv) > 1 else ""
fmt = sys.argv[2] if len(sys.argv) > 2 else "generic"

if not file_path or not os.path.exists(file_path):
    print("Usage: bash tax.sh import <csv_file> [format]")
    print("Formats: generic, binance, coinbase, kraken, kucoin")
    print("")
    print("Generic CSV format:")
    print("  date,type,asset,amount,price_usd,fee_usd")
    print("  2024-01-15,buy,BTC,0.5,21000,10")
    print("  2024-03-20,sell,BTC,0.3,45000,15")
    sys.exit(1)

# Column mappings for different exchanges
mappings = {
    "generic": {"date": "date", "type": "type", "asset": "asset", "amount": "amount", "price": "price_usd", "fee": "fee_usd"},
    "binance": {"date": "Date(UTC)", "type": "Side", "asset": "Market", "amount": "Executed", "price": "Price", "fee": "Fee"},
    "coinbase": {"date": "Timestamp", "type": "Transaction Type", "asset": "Asset", "amount": "Quantity Transacted", "price": "Spot Price at Transaction", "fee": "Fees and/or Spread"},
    "kraken": {"date": "time", "type": "type", "asset": "pair", "amount": "vol", "price": "price", "fee": "fee"},
    "kucoin": {"date": "tradeCreatedAt", "type": "side", "asset": "symbol", "amount": "size", "price": "price", "fee": "fee"}
}

mapping = mappings.get(fmt, mappings["generic"])
transactions = []

with open(file_path, "r") as f:
    reader = csv.DictReader(f)
    for row in reader:
        try:
            tx = {
                "date": row.get(mapping["date"], ""),
                "type": row.get(mapping["type"], "").lower(),
                "asset": row.get(mapping["asset"], ""),
                "amount": float(row.get(mapping["amount"], 0)),
                "price_usd": float(row.get(mapping["price"], 0)),
                "fee_usd": float(row.get(mapping["fee"], 0))
            }
            if tx["type"] in ["buy", "sell", "trade", "swap"]:
                transactions.append(tx)
        except (ValueError, KeyError):
            continue

# Save imported transactions
existing = []
tx_file = os.path.join(data_dir, "transactions.json")
if os.path.exists(tx_file):
    with open(tx_file, "r") as f:
        existing = json.load(f)

existing.extend(transactions)
with open(tx_file, "w") as f:
    json.dump(existing, f, indent=2)

print("Imported {} transactions from {}".format(len(transactions), file_path))
print("Total transactions in database: {}".format(len(existing)))
print("Saved to: {}".format(tx_file))

# Summary
assets = {}
for tx in transactions:
    asset = tx["asset"]
    if asset not in assets:
        assets[asset] = {"buys": 0, "sells": 0}
    if tx["type"] in ["buy"]:
        assets[asset]["buys"] += 1
    elif tx["type"] in ["sell"]:
        assets[asset]["sells"] += 1

print("")
print("Assets found:")
for asset, counts in sorted(assets.items()):
    print("  {}: {} buys, {} sells".format(asset, counts["buys"], counts["sells"]))
PYEOF
    ;;

  calculate)
    METHOD="${1:-fifo}"
    YEAR="${2:-2024}"
    COUNTRY="${3:-us}"
    
    python3 << 'PYEOF'
import json, sys, os
from datetime import datetime
from copy import deepcopy

data_dir = os.path.expanduser("~/.crypto-tax")
method = sys.argv[1] if len(sys.argv) > 1 else "fifo"
year = int(sys.argv[2]) if len(sys.argv) > 2 else 2024
country = sys.argv[3] if len(sys.argv) > 3 else "us"

tx_file = os.path.join(data_dir, "transactions.json")
if not os.path.exists(tx_file):
    print("No transactions found. Run 'bash tax.sh import <file>' first.")
    print("")
    print("Or add sample data:")
    print("  bash tax.sh add buy BTC 0.5 20000 2024-01-15")
    print("  bash tax.sh add sell BTC 0.3 45000 2024-06-20")
    print("  bash tax.sh calculate fifo 2024 us")
    sys.exit(1)

with open(tx_file, "r") as f:
    all_tx = json.load(f)

# Filter by year
year_tx = []
for tx in all_tx:
    try:
        tx_year = int(tx["date"][:4])
        if tx_year == year:
            year_tx.append(tx)
    except (ValueError, IndexError):
        continue

# Sort by date
year_tx.sort(key=lambda x: x["date"])

# Tax calculation by method
cost_basis_pools = {}  # asset -> list of (amount, cost_per_unit, date)
gains = []
total_short_term = 0.0
total_long_term = 0.0
total_fees = 0.0

for tx in all_tx:
    asset = tx["asset"]
    if asset not in cost_basis_pools:
        cost_basis_pools[asset] = []
    
    if tx["type"] == "buy":
        cost_per_unit = tx["price_usd"] / tx["amount"] if tx["amount"] > 0 else tx["price_usd"]
        cost_basis_pools[asset].append({
            "amount": tx["amount"],
            "cost_per_unit": cost_per_unit,
            "date": tx["date"]
        })
    elif tx["type"] == "sell":
        try:
            tx_year = int(tx["date"][:4])
        except (ValueError, IndexError):
            continue
        if tx_year != year:
            # Still consume from pool but don't record gain
            remaining = tx["amount"]
            pool = cost_basis_pools.get(asset, [])
            if method == "fifo":
                while remaining > 0 and pool:
                    lot = pool[0]
                    if lot["amount"] <= remaining:
                        remaining -= lot["amount"]
                        pool.pop(0)
                    else:
                        lot["amount"] -= remaining
                        remaining = 0
            elif method == "lifo":
                while remaining > 0 and pool:
                    lot = pool[-1]
                    if lot["amount"] <= remaining:
                        remaining -= lot["amount"]
                        pool.pop()
                    else:
                        lot["amount"] -= remaining
                        remaining = 0
            continue

        sell_price = tx["price_usd"] / tx["amount"] if tx["amount"] > 0 else tx["price_usd"]
        remaining = tx["amount"]
        fee = tx.get("fee_usd", 0)
        total_fees += fee
        pool = cost_basis_pools.get(asset, [])
        
        if method == "fifo":
            while remaining > 0 and pool:
                lot = pool[0]
                used = min(lot["amount"], remaining)
                cost = lot["cost_per_unit"] * used
                proceeds = sell_price * used
                gain = proceeds - cost - (fee * used / tx["amount"] if tx["amount"] > 0 else 0)
                
                # Determine short vs long term (365 days)
                try:
                    buy_date = datetime.strptime(lot["date"][:10], "%Y-%m-%d")
                    sell_date = datetime.strptime(tx["date"][:10], "%Y-%m-%d")
                    holding_days = (sell_date - buy_date).days
                    term = "long" if holding_days > 365 else "short"
                except (ValueError, IndexError):
                    holding_days = 0
                    term = "short"
                
                gains.append({
                    "asset": asset,
                    "amount": used,
                    "buy_date": lot["date"],
                    "sell_date": tx["date"],
                    "cost_basis": cost,
                    "proceeds": proceeds,
                    "gain": gain,
                    "term": term,
                    "holding_days": holding_days
                })
                
                if term == "short":
                    total_short_term += gain
                else:
                    total_long_term += gain
                
                if lot["amount"] <= remaining:
                    remaining -= lot["amount"]
                    pool.pop(0)
                else:
                    lot["amount"] -= remaining
                    remaining = 0

        elif method == "lifo":
            while remaining > 0 and pool:
                lot = pool[-1]
                used = min(lot["amount"], remaining)
                cost = lot["cost_per_unit"] * used
                proceeds = sell_price * used
                gain = proceeds - cost - (fee * used / tx["amount"] if tx["amount"] > 0 else 0)
                
                try:
                    buy_date = datetime.strptime(lot["date"][:10], "%Y-%m-%d")
                    sell_date = datetime.strptime(tx["date"][:10], "%Y-%m-%d")
                    holding_days = (sell_date - buy_date).days
                    term = "long" if holding_days > 365 else "short"
                except (ValueError, IndexError):
                    holding_days = 0
                    term = "short"
                
                gains.append({
                    "asset": asset,
                    "amount": used,
                    "buy_date": lot["date"],
                    "sell_date": tx["date"],
                    "cost_basis": cost,
                    "proceeds": proceeds,
                    "gain": gain,
                    "term": term,
                    "holding_days": holding_days
                })
                
                if term == "short":
                    total_short_term += gain
                else:
                    total_long_term += gain
                
                if lot["amount"] <= remaining:
                    remaining -= lot["amount"]
                    pool.pop()
                else:
                    lot["amount"] -= remaining
                    remaining = 0
        
        elif method == "average":
            if pool:
                total_amount = sum(l["amount"] for l in pool)
                total_cost = sum(l["amount"] * l["cost_per_unit"] for l in pool)
                avg_cost = total_cost / total_amount if total_amount > 0 else 0
                
                used = min(remaining, total_amount)
                cost = avg_cost * used
                proceeds = sell_price * used
                gain = proceeds - cost - fee
                
                gains.append({
                    "asset": asset,
                    "amount": used,
                    "buy_date": "average",
                    "sell_date": tx["date"],
                    "cost_basis": cost,
                    "proceeds": proceeds,
                    "gain": gain,
                    "term": "short",
                    "holding_days": 0
                })
                total_short_term += gain
                
                ratio = used / total_amount if total_amount > 0 else 1
                for lot in pool:
                    lot["amount"] *= (1 - ratio)
                pool[:] = [l for l in pool if l["amount"] > 0.0001]

# Tax rates by country
tax_rates = {
    "us": {"short": 0.37, "long": 0.20, "label": "US (Federal)", "currency": "USD", "notes": "State taxes additional. Short-term = ordinary income rate."},
    "uk": {"short": 0.20, "long": 0.20, "label": "UK", "currency": "GBP", "notes": "Capital Gains Tax. £6,000 annual exemption (2024/25)."},
    "au": {"short": 0.47, "long": 0.235, "label": "Australia", "currency": "AUD", "notes": "50% CGT discount for assets held >12 months."},
    "cn": {"short": 0.20, "long": 0.20, "label": "China", "currency": "CNY", "notes": "20% on capital gains. Crypto trading technically banned."},
    "de": {"short": 0.26, "long": 0.0, "label": "Germany", "currency": "EUR", "notes": "Tax-free if held >1 year! 26.375% (incl. solidarity) if <1 year."},
    "sg": {"short": 0.0, "long": 0.0, "label": "Singapore", "currency": "SGD", "notes": "No capital gains tax!"},
    "ae": {"short": 0.0, "long": 0.0, "label": "UAE", "currency": "AED", "notes": "No capital gains tax!"}
}

rates = tax_rates.get(country, tax_rates["us"])

est_tax_short = total_short_term * rates["short"] if total_short_term > 0 else 0
est_tax_long = total_long_term * rates["long"] if total_long_term > 0 else 0

total_gain = total_short_term + total_long_term

print("=" * 65)
print("CRYPTO TAX REPORT — {} ({})".format(year, rates["label"]))
print("=" * 65)
print("Method: {}".format(method.upper()))
print("Transactions in {}: {}".format(year, len([g for g in gains])))
print("")
print("-" * 65)
print("CAPITAL GAINS SUMMARY")
print("-" * 65)
print("  Short-term gains: ${:>12,.2f}".format(total_short_term))
print("  Long-term gains:  ${:>12,.2f}".format(total_long_term))
print("  Total fees paid:  ${:>12,.2f}".format(total_fees))
print("  ─────────────────────────────")
print("  NET GAIN/LOSS:    ${:>12,.2f}".format(total_gain))
print("")
print("-" * 65)
print("ESTIMATED TAX")
print("-" * 65)
print("  Short-term rate: {:.0%}".format(rates["short"]))
print("  Long-term rate:  {:.0%}".format(rates["long"]))
print("  Short-term tax:  ${:>12,.2f}".format(est_tax_short))
print("  Long-term tax:   ${:>12,.2f}".format(est_tax_long))
print("  ─────────────────────────────")
print("  TOTAL EST. TAX:  ${:>12,.2f}".format(est_tax_short + est_tax_long))
print("")
print("  Note: {}".format(rates["notes"]))

if gains:
    print("")
    print("-" * 65)
    print("TRANSACTION DETAILS")
    print("-" * 65)
    for i, g in enumerate(gains[:20], 1):
        print("  {}. {} {:.4f} {}".format(i, g["term"].upper(), g["amount"], g["asset"]))
        print("     Bought: {} | Sold: {}".format(g["buy_date"][:10], g["sell_date"][:10]))
        print("     Cost: ${:,.2f} | Proceeds: ${:,.2f} | Gain: ${:,.2f}".format(g["cost_basis"], g["proceeds"], g["gain"]))
    if len(gains) > 20:
        print("  ... and {} more transactions".format(len(gains) - 20))

# Save report
report = {
    "year": year,
    "method": method,
    "country": country,
    "short_term_gains": total_short_term,
    "long_term_gains": total_long_term,
    "total_fees": total_fees,
    "estimated_tax": est_tax_short + est_tax_long,
    "transactions": len(gains),
    "generated": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
}
report_file = os.path.join(data_dir, "report-{}-{}.json".format(year, method))
with open(report_file, "w") as f:
    json.dump(report, f, indent=2)
print("")
print("Report saved to: {}".format(report_file))
PYEOF
    ;;

  add)
    TYPE="${1:-buy}"
    ASSET="${2:-BTC}"
    AMOUNT="${3:-1}"
    PRICE="${4:-50000}"
    DATE="${5:-$(date +%Y-%m-%d)}"
    FEE="${6:-0}"
    
    python3 << 'PYEOF'
import json, sys, os

data_dir = os.path.expanduser("~/.crypto-tax")
tx_type = sys.argv[1] if len(sys.argv) > 1 else "buy"
asset = sys.argv[2] if len(sys.argv) > 2 else "BTC"
amount = float(sys.argv[3]) if len(sys.argv) > 3 else 1.0
price = float(sys.argv[4]) if len(sys.argv) > 4 else 50000
date = sys.argv[5] if len(sys.argv) > 5 else "2024-01-01"
fee = float(sys.argv[6]) if len(sys.argv) > 6 else 0

tx = {
    "date": date,
    "type": tx_type,
    "asset": asset,
    "amount": amount,
    "price_usd": price * amount,
    "fee_usd": fee
}

tx_file = os.path.join(data_dir, "transactions.json")
existing = []
if os.path.exists(tx_file):
    with open(tx_file, "r") as f:
        existing = json.load(f)

existing.append(tx)
with open(tx_file, "w") as f:
    json.dump(existing, f, indent=2)

print("Added: {} {} {} @ ${:,.2f} on {}".format(tx_type.upper(), amount, asset, price, date))
print("Total transactions: {}".format(len(existing)))
PYEOF
    ;;

  report)
    YEAR="${1:-2024}"
    FORMAT="${2:-text}"
    
    python3 << 'PYEOF'
import json, sys, os

data_dir = os.path.expanduser("~/.crypto-tax")
year = sys.argv[1] if len(sys.argv) > 1 else "2024"
fmt = sys.argv[2] if len(sys.argv) > 2 else "text"

# Find latest report
reports = []
for f in os.listdir(data_dir):
    if f.startswith("report-{}-".format(year)) and f.endswith(".json"):
        with open(os.path.join(data_dir, f), "r") as rf:
            reports.append(json.load(rf))

if not reports:
    print("No reports found for {}. Run 'bash tax.sh calculate' first.".format(year))
    sys.exit(1)

if fmt == "html":
    html = """<!DOCTYPE html>
<html><head><title>Crypto Tax Report {year}</title>
<style>
body {{ font-family: Arial, sans-serif; max-width: 800px; margin: 40px auto; background: #0d1117; color: #c9d1d9; padding: 20px; }}
h1 {{ color: #58a6ff; border-bottom: 2px solid #30363d; padding-bottom: 10px; }}
h2 {{ color: #f0f6fc; }}
table {{ width: 100%; border-collapse: collapse; margin: 20px 0; }}
th, td {{ padding: 10px; text-align: left; border: 1px solid #30363d; }}
th {{ background: #161b22; color: #58a6ff; }}
.positive {{ color: #3fb950; }}
.negative {{ color: #f85149; }}
.footer {{ margin-top: 40px; padding-top: 20px; border-top: 1px solid #30363d; color: #8b949e; font-size: 0.9em; }}
</style></head><body>
<h1>Crypto Tax Report — {year}</h1>
""".format(year=year)
    
    for r in reports:
        total = r.get("short_term_gains", 0) + r.get("long_term_gains", 0)
        gain_class = "positive" if total >= 0 else "negative"
        html += """<h2>Method: {method}</h2>
<table>
<tr><th>Category</th><th>Amount</th></tr>
<tr><td>Short-term Gains</td><td class="{gc}">${st:,.2f}</td></tr>
<tr><td>Long-term Gains</td><td class="{gc}">${lt:,.2f}</td></tr>
<tr><td>Total Fees</td><td>${fees:,.2f}</td></tr>
<tr><td><strong>Net Gain/Loss</strong></td><td class="{gc}"><strong>${total:,.2f}</strong></td></tr>
<tr><td><strong>Estimated Tax</strong></td><td><strong>${tax:,.2f}</strong></td></tr>
</table>
""".format(
            method=r.get("method", "fifo").upper(),
            gc=gain_class,
            st=r.get("short_term_gains", 0),
            lt=r.get("long_term_gains", 0),
            fees=r.get("total_fees", 0),
            total=total,
            tax=r.get("estimated_tax", 0)
        )
    
    html += """<div class="footer">
<p>Generated: {}</p>
<p>⚠️ This is an estimate only. Consult a tax professional for official filing.</p>
<p>Powered by BytesAgain | bytesagain.com</p>
</div></body></html>""".format(reports[0].get("generated", ""))
    
    report_path = os.path.join(data_dir, "tax-report-{}.html".format(year))
    with open(report_path, "w") as f:
        f.write(html)
    print("HTML report saved to: {}".format(report_path))
else:
    for r in reports:
        total = r.get("short_term_gains", 0) + r.get("long_term_gains", 0)
        print("Method: {}".format(r.get("method", "?").upper()))
        print("  Short-term: ${:,.2f}".format(r.get("short_term_gains", 0)))
        print("  Long-term: ${:,.2f}".format(r.get("long_term_gains", 0)))
        print("  Net: ${:,.2f}".format(total))
        print("  Est. Tax: ${:,.2f}".format(r.get("estimated_tax", 0)))
        print("")
PYEOF
    ;;

  compare-methods)
    YEAR="${1:-2024}"
    
    python3 << 'PYEOF'
import json, sys, os

data_dir = os.path.expanduser("~/.crypto-tax")
year = sys.argv[1] if len(sys.argv) > 1 else "2024"

print("=" * 60)
print("TAX METHOD COMPARISON — {}".format(year))
print("=" * 60)
print("")

methods = [
    ("FIFO", "First In, First Out — oldest lots sold first", "Most common, IRS default"),
    ("LIFO", "Last In, First Out — newest lots sold first", "May reduce tax in rising markets"),
    ("Average", "Average Cost — weighted average of all purchases", "Simpler but less flexible")
]

print("{:<10} {:<40} {}".format("Method", "Description", "Best For"))
print("-" * 60)
for name, desc, best in methods:
    print("{:<10} {:<40} {}".format(name, desc, best))

print("")
print("TIP: Run 'bash tax.sh calculate <method> {}' for each".format(year))
print("     to compare actual results with your data.")
print("")
print("Country-specific rules:")
print("  US: FIFO is default. Specific ID allowed.")
print("  UK: Section 104 pooling (similar to average cost)")
print("  AU: FIFO or specific identification")
print("  DE: FIFO mandatory")
PYEOF
    ;;

  help|*)
    cat << 'HELPEOF'
Crypto Tax Calculator — Calculate capital gains from trading

COMMANDS:
  import <csv_file> [format]
         Import transactions (generic|binance|coinbase|kraken|kucoin)

  add <type> <asset> <amount> <price> [date] [fee]
         Manually add a transaction

  calculate [method] [year] [country]
         Calculate capital gains (fifo|lifo|average)

  report [year] [format]
         Generate report (text|html)

  compare-methods [year]
         Compare FIFO vs LIFO vs Average Cost

EXAMPLES:
  bash tax.sh import trades.csv binance
  bash tax.sh add buy BTC 0.5 42000 2024-01-15 10
  bash tax.sh add sell BTC 0.3 68000 2024-06-20 15
  bash tax.sh calculate fifo 2024 us
  bash tax.sh report 2024 html
  bash tax.sh compare-methods 2024

COUNTRIES: us, uk, au, cn, de, sg, ae
HELPEOF
    ;;
esac

echo ""
echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
