#!/usr/bin/env bash
# Stripe Manager — Manage Stripe payments via API
# Usage: bash main.sh --action <action> --key <key> [options]
set -euo pipefail

ACTION="" API_KEY="${STRIPE_API_KEY:-}" CUSTOMER_ID="" AMOUNT="" CURRENCY="usd" DESCRIPTION="" EMAIL="" LIMIT="10" OUTPUT=""

show_help() { cat << 'HELPEOF'
Stripe Manager — Full Stripe API payment toolkit

Usage: bash main.sh --action <action> --key <key> [options]

Actions: list-customers, create-customer, get-customer, list-charges,
         list-subscriptions, create-payment-link, get-balance, list-products,
         list-invoices, list-events, get-charge

Options:
  --key <key>          Stripe API key (or STRIPE_API_KEY env)
  --customer-id <id>   Customer ID
  --amount <cents>     Amount in cents (e.g., 1000 = $10.00)
  --currency <cur>     Currency code (default: usd)
  --desc <text>        Description
  --email <email>      Customer email
  --limit <n>          Results limit (default: 10)
  --output <file>      Save to file

Examples:
  bash main.sh --action get-balance --key sk_test_xxx
  bash main.sh --action list-customers --limit 20
  bash main.sh --action create-customer --email "user@example.com" --desc "New customer"
  bash main.sh --action list-charges --customer-id cus_xxx
  bash main.sh --action list-subscriptions

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --action) ACTION="$2"; shift 2;; --key) API_KEY="$2"; shift 2;;
        --customer-id) CUSTOMER_ID="$2"; shift 2;; --amount) AMOUNT="$2"; shift 2;;
        --currency) CURRENCY="$2"; shift 2;; --desc) DESCRIPTION="$2"; shift 2;;
        --email) EMAIL="$2"; shift 2;; --limit) LIMIT="$2"; shift 2;;
        --output) OUTPUT="$2"; shift 2;; --help|-h) show_help; exit 0;; *) shift;;
    esac
done

[ -z "$ACTION" ] && { echo "Error: --action required"; show_help; exit 1; }
[ -z "$API_KEY" ] && { echo "Error: --key required (or STRIPE_API_KEY env)"; exit 1; }

API="https://api.stripe.com/v1"

stripe_api() {
    local endpoint="$1"; shift
    curl -s -u "$API_KEY:" "$API/$endpoint" "$@" 2>/dev/null
}

fmt_money() {
    python3 -c "
amount = $1
currency = '$2'.upper()
print('{} {:.2f}'.format(currency, amount / 100.0))
"
}

case "$ACTION" in
    get-balance)
        stripe_api "balance" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'error' in data: print('Error:', data['error'].get('message','')); sys.exit(1)
print('💰 Stripe Balance')
print('')
for b in data.get('available', []):
    print('  Available: {} {:.2f}'.format(b.get('currency','').upper(), b.get('amount',0)/100.0))
for b in data.get('pending', []):
    print('  Pending:   {} {:.2f}'.format(b.get('currency','').upper(), b.get('amount',0)/100.0))
"
        ;;
    list-customers)
        stripe_api "customers?limit=$LIMIT" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'error' in data: print('Error:', data['error'].get('message','')); sys.exit(1)
customers = data.get('data', [])
print('Customers ({} shown)'.format(len(customers)))
print('')
for c in customers:
    name = c.get('name') or c.get('email') or '(unnamed)'
    balance = c.get('balance', 0)
    print('  {} — {}'.format(name, c.get('id','')))
    print('     Email: {} | Balance: {:.2f}'.format(c.get('email',''), balance/100.0))
    if c.get('description'): print('     Desc: {}'.format(c['description']))
"
        ;;
    create-customer)
        args=()
        [ -n "$EMAIL" ] && args+=(-d "email=$EMAIL")
        [ -n "$DESCRIPTION" ] && args+=(-d "description=$DESCRIPTION")
        stripe_api "customers" -X POST "${args[@]}" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'error' in data: print('Error:', data['error'].get('message','')); sys.exit(1)
print('✅ Customer created')
print('   ID: {}'.format(data.get('id','')))
print('   Email: {}'.format(data.get('email','')))
"
        ;;
    get-customer)
        [ -z "$CUSTOMER_ID" ] && { echo "Error: --customer-id required"; exit 1; }
        stripe_api "customers/$CUSTOMER_ID" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'error' in data: print('Error:', data['error'].get('message','')); sys.exit(1)
print('Customer: {}'.format(data.get('name', data.get('email',''))))
print('ID: {}'.format(data.get('id','')))
print('Email: {}'.format(data.get('email','')))
print('Balance: {:.2f}'.format(data.get('balance',0)/100.0))
print('Created: {}'.format(data.get('created','')))
print('Currency: {}'.format(data.get('currency','')))
subs = data.get('subscriptions', {}).get('data', [])
if subs:
    print('Subscriptions: {}'.format(len(subs)))
    for s in subs:
        print('  {} — {} ({})'.format(s.get('id',''), s.get('status',''), s.get('current_period_end','')))
"
        ;;
    list-charges)
        params="limit=$LIMIT"
        [ -n "$CUSTOMER_ID" ] && params="$params&customer=$CUSTOMER_ID"
        stripe_api "charges?$params" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'error' in data: print('Error:', data['error'].get('message','')); sys.exit(1)
charges = data.get('data', [])
print('Charges ({} shown)'.format(len(charges)))
print('')
total = 0
for c in charges:
    amount = c.get('amount', 0)
    total += amount
    status = '✅' if c.get('paid') else ('❌' if c.get('refunded') else '⏳')
    currency = c.get('currency', 'usd').upper()
    print('  {} {} {:.2f} — {} ({})'.format(status, currency, amount/100.0, c.get('description',''), c.get('id','')))
print('')
print('Total: {:.2f}'.format(total/100.0))
"
        ;;
    list-subscriptions)
        params="limit=$LIMIT"
        [ -n "$CUSTOMER_ID" ] && params="$params&customer=$CUSTOMER_ID"
        stripe_api "subscriptions?$params" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'error' in data: print('Error:', data['error'].get('message','')); sys.exit(1)
subs = data.get('data', [])
print('Subscriptions ({})'.format(len(subs)))
print('')
for s in subs:
    status = {'active':'✅','past_due':'⚠️','canceled':'❌','trialing':'🔄'}.get(s.get('status',''),'❓')
    print('  {} {} — {}'.format(status, s.get('status',''), s.get('id','')))
    items = s.get('items',{}).get('data',[])
    for item in items:
        price = item.get('price',{})
        amount = price.get('unit_amount',0)
        interval = price.get('recurring',{}).get('interval','')
        print('     {:.2f}/{}'.format(amount/100.0, interval))
"
        ;;
    list-products)
        stripe_api "products?limit=$LIMIT&active=true" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'error' in data: print('Error:', data['error'].get('message','')); sys.exit(1)
products = data.get('data', [])
print('Products ({})'.format(len(products)))
for p in products:
    print('  {} — {}'.format(p.get('name',''), p.get('id','')))
    if p.get('description'): print('     {}'.format(p['description'][:100]))
"
        ;;
    list-invoices)
        params="limit=$LIMIT"
        [ -n "$CUSTOMER_ID" ] && params="$params&customer=$CUSTOMER_ID"
        stripe_api "invoices?$params" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'error' in data: print('Error:', data['error'].get('message','')); sys.exit(1)
invoices = data.get('data', [])
print('Invoices ({})'.format(len(invoices)))
for inv in invoices:
    status = {'paid':'✅','open':'📬','draft':'📝','void':'🚫'}.get(inv.get('status',''),'❓')
    amount = inv.get('amount_due', 0)
    print('  {} {:.2f} — {} ({})'.format(status, amount/100.0, inv.get('status',''), inv.get('id','')))
"
        ;;
    list-events)
        stripe_api "events?limit=$LIMIT" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'error' in data: print('Error:', data['error'].get('message','')); sys.exit(1)
events = data.get('data', [])
print('Recent events ({})'.format(len(events)))
for e in events:
    print('  {} — {} ({})'.format(e.get('type',''), e.get('id',''), e.get('created','')))
"
        ;;
    *) echo "Unknown action: $ACTION"; show_help; exit 1;;
esac
