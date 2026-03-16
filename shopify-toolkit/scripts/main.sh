#!/usr/bin/env bash
# Shopify Toolkit — Manage Shopify store via Admin API
# Usage: bash main.sh --action <action> --store <store> --token <token> [options]
set -euo pipefail

ACTION="" STORE="${SHOPIFY_STORE:-}" TOKEN="${SHOPIFY_TOKEN:-}" PRODUCT_ID="" ORDER_ID="" CUSTOMER_ID="" LIMIT="10" TITLE="" BODY="" PRICE="" OUTPUT=""

show_help() { cat << 'HELPEOF'
Shopify Toolkit — Full Shopify Admin API management

Usage: bash main.sh --action <action> --store <store> --token <token> [options]

Actions: list-products, get-product, create-product, list-orders, get-order,
         list-customers, get-customer, shop-info, list-collections,
         inventory-levels, count-products, count-orders

Options:
  --store <store>      Store name (xxx.myshopify.com or just xxx)
  --token <token>      Admin API access token (or SHOPIFY_TOKEN env)
  --product-id <id>    Product ID
  --order-id <id>      Order ID
  --customer-id <id>   Customer ID
  --title <title>      Product title
  --body <html>        Product description
  --price <price>      Product price
  --limit <n>          Results limit (default: 10)
  --output <file>      Save to file

Examples:
  bash main.sh --action shop-info --store mystore --token shpat_xxx
  bash main.sh --action list-products --limit 20
  bash main.sh --action create-product --title "New Item" --price "29.99" --body "Description"
  bash main.sh --action list-orders
  bash main.sh --action list-customers

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --action) ACTION="$2"; shift 2;; --store) STORE="$2"; shift 2;;
        --token) TOKEN="$2"; shift 2;; --product-id) PRODUCT_ID="$2"; shift 2;;
        --order-id) ORDER_ID="$2"; shift 2;; --customer-id) CUSTOMER_ID="$2"; shift 2;;
        --title) TITLE="$2"; shift 2;; --body) BODY="$2"; shift 2;;
        --price) PRICE="$2"; shift 2;; --limit) LIMIT="$2"; shift 2;;
        --output) OUTPUT="$2"; shift 2;; --help|-h) show_help; exit 0;; *) shift;;
    esac
done

[ -z "$ACTION" ] && { echo "Error: --action required"; show_help; exit 1; }
[ -z "$STORE" ] && { echo "Error: --store required"; exit 1; }
[ -z "$TOKEN" ] && { echo "Error: --token required"; exit 1; }

# Normalize store URL
case "$STORE" in
    *myshopify.com*) API_BASE="https://$STORE/admin/api/2024-01";;
    *) API_BASE="https://$STORE.myshopify.com/admin/api/2024-01";;
esac

shopify_api() {
    local method="$1" endpoint="$2" data="${3:-}"
    local args=(-s -X "$method" "$API_BASE/$endpoint.json" -H "X-Shopify-Access-Token: $TOKEN" -H "Content-Type: application/json")
    [ -n "$data" ] && args+=(-d "$data")
    curl "${args[@]}" 2>/dev/null
}

case "$ACTION" in
    shop-info)
        shopify_api GET "shop" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'errors' in data: print('Error:', data['errors']); sys.exit(1)
shop = data.get('shop', {})
print('🏪 {}'.format(shop.get('name','')))
print('   Domain: {}'.format(shop.get('domain','')))
print('   Plan: {}'.format(shop.get('plan_name','')))
print('   Currency: {}'.format(shop.get('currency','')))
print('   Country: {}'.format(shop.get('country_name','')))
print('   Email: {}'.format(shop.get('email','')))
print('   Created: {}'.format(shop.get('created_at','')[:10]))
"
        ;;
    list-products)
        shopify_api GET "products?limit=$LIMIT" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'errors' in data: print('Error:', data['errors']); sys.exit(1)
products = data.get('products', [])
print('Products ({})'.format(len(products)))
print('')
for p in products:
    variants = p.get('variants', [])
    price = variants[0].get('price','?') if variants else '?'
    status = '✅' if p.get('status') == 'active' else '📝'
    inventory = sum(v.get('inventory_quantity', 0) for v in variants)
    print('  {} {} — \${}'.format(status, p.get('title',''), price))
    print('     ID: {} | Variants: {} | Stock: {}'.format(p.get('id',''), len(variants), inventory))
"
        ;;
    get-product)
        [ -z "$PRODUCT_ID" ] && { echo "Error: --product-id required"; exit 1; }
        shopify_api GET "products/$PRODUCT_ID" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'errors' in data: print('Error:', data['errors']); sys.exit(1)
p = data.get('product', {})
print('Product: {}'.format(p.get('title','')))
print('ID: {}'.format(p.get('id','')))
print('Status: {}'.format(p.get('status','')))
print('Type: {}'.format(p.get('product_type','')))
print('Vendor: {}'.format(p.get('vendor','')))
print('Tags: {}'.format(p.get('tags','')))
print('Created: {}'.format(p.get('created_at','')[:10]))
print('')
print('Variants:')
for v in p.get('variants', []):
    print('  {} — \${} (stock: {})'.format(v.get('title',''), v.get('price',''), v.get('inventory_quantity',0)))
"
        ;;
    create-product)
        [ -z "$TITLE" ] && { echo "Error: --title required"; exit 1; }
        payload=$(python3 -c "
import json
product = {'title': '$TITLE'}
if '$BODY': product['body_html'] = '$BODY'
if '$PRICE':
    product['variants'] = [{'price': '$PRICE'}]
print(json.dumps({'product': product}))
")
        shopify_api POST "products" "$payload" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'errors' in data: print('Error:', data['errors']); sys.exit(1)
p = data.get('product', {})
print('✅ Product created: {}'.format(p.get('title','')))
print('   ID: {}'.format(p.get('id','')))
"
        ;;
    list-orders)
        shopify_api GET "orders?limit=$LIMIT&status=any" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'errors' in data: print('Error:', data['errors']); sys.exit(1)
orders = data.get('orders', [])
print('Orders ({})'.format(len(orders)))
print('')
total_revenue = 0
for o in orders:
    amount = float(o.get('total_price', 0))
    total_revenue += amount
    status = {'paid':'✅','pending':'⏳','refunded':'↩️'}.get(o.get('financial_status',''),'❓')
    fulfillment = {'fulfilled':'📦','partial':'📦⏳',None:'📋'}.get(o.get('fulfillment_status'),'❓')
    print('  {} {} #{} — \${:.2f}'.format(status, fulfillment, o.get('order_number',''), amount))
    customer = o.get('customer', {})
    if customer:
        name = '{} {}'.format(customer.get('first_name',''), customer.get('last_name','')).strip()
        print('     Customer: {} | Items: {}'.format(name, len(o.get('line_items',[]))))
print('')
print('Total revenue: \${:.2f}'.format(total_revenue))
"
        ;;
    get-order)
        [ -z "$ORDER_ID" ] && { echo "Error: --order-id required"; exit 1; }
        shopify_api GET "orders/$ORDER_ID" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'errors' in data: print('Error:', data['errors']); sys.exit(1)
o = data.get('order', {})
print('Order #{}'.format(o.get('order_number','')))
print('ID: {}'.format(o.get('id','')))
print('Total: \${}'.format(o.get('total_price','')))
print('Financial: {}'.format(o.get('financial_status','')))
print('Fulfillment: {}'.format(o.get('fulfillment_status','')))
print('Created: {}'.format(o.get('created_at','')[:10]))
print('')
print('Items:')
for item in o.get('line_items', []):
    print('  {} x{} — \${}'.format(item.get('title',''), item.get('quantity',0), item.get('price','')))
"
        ;;
    list-customers)
        shopify_api GET "customers?limit=$LIMIT" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'errors' in data: print('Error:', data['errors']); sys.exit(1)
customers = data.get('customers', [])
print('Customers ({})'.format(len(customers)))
print('')
for c in customers:
    name = '{} {}'.format(c.get('first_name',''), c.get('last_name','')).strip()
    orders = c.get('orders_count', 0)
    spent = c.get('total_spent', '0.00')
    print('  {} — {} orders, \${} spent'.format(name, orders, spent))
    print('     Email: {} | ID: {}'.format(c.get('email',''), c.get('id','')))
"
        ;;
    count-products)
        shopify_api GET "products/count" | python3 -c "
import json, sys
data = json.load(sys.stdin)
print('Total products: {}'.format(data.get('count', '?')))
"
        ;;
    count-orders)
        shopify_api GET "orders/count?status=any" | python3 -c "
import json, sys
data = json.load(sys.stdin)
print('Total orders: {}'.format(data.get('count', '?')))
"
        ;;
    *) echo "Unknown action: $ACTION"; show_help; exit 1;;
esac
