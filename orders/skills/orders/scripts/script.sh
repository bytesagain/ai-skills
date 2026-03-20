#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# orders/scripts/script.sh — Order management system.
# Create, list, query, update, cancel orders and generate reports.
###############################################################################

DATA_DIR="${HOME}/.orders"
ORDERS_FILE="${DATA_DIR}/orders.json"

ensure_data_dir() {
  mkdir -p "${DATA_DIR}"
  if [[ ! -f "${ORDERS_FILE}" ]]; then
    echo '[]' > "${ORDERS_FILE}"
  fi
}

generate_order_id() {
  echo "ORD-$(date +%Y%m%d)-$(printf '%04d' $(( RANDOM % 10000 )))"
}

# ─── create ──────────────────────────────────────────────────────────────────

cmd_create() {
  ensure_data_dir
  local customer="" item="" quantity="" unit_price="" note=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --note) note="$2"; shift 2 ;;
      -*)     echo "Unknown flag: $1" >&2; return 1 ;;
      *)
        if [[ -z "${customer}" ]]; then
          customer="$1"
        elif [[ -z "${item}" ]]; then
          item="$1"
        elif [[ -z "${quantity}" ]]; then
          quantity="$1"
        elif [[ -z "${unit_price}" ]]; then
          unit_price="$1"
        fi
        shift
        ;;
    esac
  done

  if [[ -z "${customer}" || -z "${item}" || -z "${quantity}" || -z "${unit_price}" ]]; then
    echo "Usage: script.sh create <customer> <item> <quantity> <unit_price> [--note text]" >&2
    return 1
  fi

  local order_id
  order_id=$(generate_order_id)
  local created_at
  created_at=$(date +%Y-%m-%dT%H:%M:%S)

  ORDERS_FILE="$ORDERS_FILE" ORDER_ID="$order_id" CUSTOMER="$customer" \
  ITEM="$item" QUANTITY="$quantity" UNIT_PRICE="$unit_price" NOTE="$note" \
  CREATED_AT="$created_at" python3 << 'PYEOF'
import json, os

orders_file = os.environ["ORDERS_FILE"]
order_id = os.environ["ORDER_ID"]
customer = os.environ["CUSTOMER"]
item = os.environ["ITEM"]
quantity = int(os.environ["QUANTITY"])
unit_price = float(os.environ["UNIT_PRICE"])
note = os.environ["NOTE"]
created_at = os.environ["CREATED_AT"]

orders = json.load(open(orders_file))

order = {
    'id': order_id,
    'customer': customer,
    'item': item,
    'quantity': quantity,
    'unit_price': unit_price,
    'total': quantity * unit_price,
    'status': 'pending',
    'note': note,
    'created_at': created_at,
    'updated_at': created_at
}

orders.append(order)
json.dump(orders, open(orders_file, 'w'), indent=2)

print(f'Order created: {order_id}')
print(f'  Customer: {customer}')
print(f'  Item:     {item} x {quantity} @ ${unit_price}')
print(f'  Total:    ${order["total"]:.2f}')
print(f'  Status:   pending')
PYEOF
}

# ─── list ────────────────────────────────────────────────────────────────────

cmd_list() {
  ensure_data_dir
  local status_filter="" format="table"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --status) status_filter="$2"; shift 2 ;;
      --format) format="$2"; shift 2 ;;
      -*)       echo "Unknown flag: $1" >&2; return 1 ;;
      *)        shift ;;
    esac
  done

  ORDERS_FILE="$ORDERS_FILE" STATUS_FILTER="$status_filter" FORMAT="$format" python3 << 'PYEOF'
import json, os

orders_file = os.environ["ORDERS_FILE"]
status_filter = os.environ["STATUS_FILTER"]
fmt = os.environ["FORMAT"]

orders = json.load(open(orders_file))

if status_filter:
    orders = [o for o in orders if o['status'] == status_filter]

if not orders:
    print('No orders found.')
    exit(0)

if fmt == 'json':
    print(json.dumps(orders, indent=2))
elif fmt == 'csv':
    print('id,customer,item,quantity,unit_price,total,status,created_at')
    for o in orders:
        print(f"{o['id']},{o['customer']},{o['item']},{o['quantity']},{o['unit_price']},{o['total']},{o['status']},{o['created_at']}")
else:
    print(f"{'ID':<20} {'Customer':<15} {'Item':<15} {'Qty':>5} {'Total':>10} {'Status':<12} {'Created':<20}")
    print('-' * 100)
    for o in orders:
        print(f"{o['id']:<20} {o['customer']:<15} {o['item']:<15} {o['quantity']:>5} {o['total']:>10.2f} {o['status']:<12} {o['created_at']:<20}")
    print(f'\nTotal orders: {len(orders)}')
PYEOF
}

# ─── status ──────────────────────────────────────────────────────────────────

cmd_status() {
  ensure_data_dir
  local order_id=""

  if [[ $# -ge 1 ]]; then
    order_id="$1"
  else
    echo "Usage: script.sh status <order_id>" >&2
    return 1
  fi

  ORDERS_FILE="$ORDERS_FILE" ORDER_ID="$order_id" python3 << 'PYEOF'
import json, sys, os

orders_file = os.environ["ORDERS_FILE"]
oid = os.environ["ORDER_ID"]

orders = json.load(open(orders_file))

found = None
for o in orders:
    if o['id'] == oid:
        found = o
        break

if not found:
    print(f'Order {oid} not found.')
    sys.exit(1)

print(f'=== Order: {found["id"]} ===')
print(f'Customer:   {found["customer"]}')
print(f'Item:       {found["item"]}')
print(f'Quantity:   {found["quantity"]}')
print(f'Unit Price: ${found["unit_price"]:.2f}')
print(f'Total:      ${found["total"]:.2f}')
print(f'Status:     {found["status"]}')
print(f'Note:       {found.get("note", "")}')
print(f'Created:    {found["created_at"]}')
print(f'Updated:    {found["updated_at"]}')
PYEOF
}

# ─── update ──────────────────────────────────────────────────────────────────

cmd_update() {
  ensure_data_dir
  local order_id="" new_status="" new_quantity="" new_note=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --status)   new_status="$2"; shift 2 ;;
      --quantity) new_quantity="$2"; shift 2 ;;
      --note)     new_note="$2"; shift 2 ;;
      -*)         echo "Unknown flag: $1" >&2; return 1 ;;
      *)          order_id="$1"; shift ;;
    esac
  done

  if [[ -z "${order_id}" ]]; then
    echo "Usage: script.sh update <order_id> [--status S] [--quantity N] [--note TEXT]" >&2
    return 1
  fi

  local updated_at
  updated_at=$(date +%Y-%m-%dT%H:%M:%S)

  ORDERS_FILE="$ORDERS_FILE" ORDER_ID="$order_id" NEW_STATUS="$new_status" \
  NEW_QUANTITY="$new_quantity" NEW_NOTE="$new_note" UPDATED_AT="$updated_at" \
  python3 << 'PYEOF'
import json, sys, os

orders_file = os.environ["ORDERS_FILE"]
oid = os.environ["ORDER_ID"]
new_status = os.environ["NEW_STATUS"]
new_quantity = os.environ["NEW_QUANTITY"]
new_note = os.environ["NEW_NOTE"]
updated_at = os.environ["UPDATED_AT"]

orders = json.load(open(orders_file))

found = False
for o in orders:
    if o['id'] == oid:
        found = True
        changes = []
        if new_status:
            o['status'] = new_status
            changes.append(f'status → {new_status}')
        if new_quantity:
            o['quantity'] = int(new_quantity)
            o['total'] = int(new_quantity) * o['unit_price']
            changes.append(f'quantity → {new_quantity}')
        if new_note:
            o['note'] = new_note
            changes.append(f'note updated')
        o['updated_at'] = updated_at

        if changes:
            json.dump(orders, open(orders_file, 'w'), indent=2)
            print(f'Order {oid} updated: {", ".join(changes)}')
        else:
            print('No changes specified.')
        break

if not found:
    print(f'Order {oid} not found.')
    sys.exit(1)
PYEOF
}

# ─── cancel ──────────────────────────────────────────────────────────────────

cmd_cancel() {
  ensure_data_dir
  local order_id="" reason=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --reason) reason="$2"; shift 2 ;;
      -*)       echo "Unknown flag: $1" >&2; return 1 ;;
      *)        order_id="$1"; shift ;;
    esac
  done

  if [[ -z "${order_id}" ]]; then
    echo "Usage: script.sh cancel <order_id> [--reason TEXT]" >&2
    return 1
  fi

  local cancelled_at
  cancelled_at=$(date +%Y-%m-%dT%H:%M:%S)

  ORDERS_FILE="$ORDERS_FILE" ORDER_ID="$order_id" REASON="$reason" \
  CANCELLED_AT="$cancelled_at" python3 << 'PYEOF'
import json, sys, os

orders_file = os.environ["ORDERS_FILE"]
oid = os.environ["ORDER_ID"]
reason = os.environ["REASON"]
cancelled_at = os.environ["CANCELLED_AT"]

orders = json.load(open(orders_file))

found = False
for o in orders:
    if o['id'] == oid:
        found = True
        if o['status'] == 'cancelled':
            print(f'Order {oid} is already cancelled.')
            sys.exit(0)
        o['status'] = 'cancelled'
        o['updated_at'] = cancelled_at
        if reason:
            o['cancel_reason'] = reason
        json.dump(orders, open(orders_file, 'w'), indent=2)
        print(f'Order {oid} cancelled.')
        if reason:
            print(f'Reason: {reason}')
        break

if not found:
    print(f'Order {oid} not found.')
    sys.exit(1)
PYEOF
}

# ─── report ──────────────────────────────────────────────────────────────────

cmd_report() {
  ensure_data_dir
  local period="all" format="table"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --period) period="$2"; shift 2 ;;
      --format) format="$2"; shift 2 ;;
      -*)       echo "Unknown flag: $1" >&2; return 1 ;;
      *)        shift ;;
    esac
  done

  ORDERS_FILE="$ORDERS_FILE" PERIOD="$period" FORMAT="$format" python3 << 'PYEOF'
import json, os
from datetime import datetime, timedelta

orders_file = os.environ["ORDERS_FILE"]
period = os.environ["PERIOD"]
fmt = os.environ["FORMAT"]

orders = json.load(open(orders_file))

# Filter by period
now = datetime.now()
period_map = {
    'today': timedelta(days=1),
    'week':  timedelta(weeks=1),
    'month': timedelta(days=30),
}

if period in period_map:
    cutoff = now - period_map[period]
    filtered = []
    for o in orders:
        try:
            created = datetime.fromisoformat(o['created_at'])
            if created >= cutoff:
                filtered.append(o)
        except (ValueError, KeyError):
            filtered.append(o)
else:
    filtered = orders

if not filtered:
    print('No orders found for the specified period.')
    exit(0)

# Compute stats
total_orders = len(filtered)
total_revenue = sum(o['total'] for o in filtered)
by_status = {}
for o in filtered:
    s = o['status']
    by_status[s] = by_status.get(s, 0) + 1

top_items = {}
for o in filtered:
    item = o['item']
    top_items[item] = top_items.get(item, 0) + o['quantity']

top_customers = {}
for o in filtered:
    c = o['customer']
    top_customers[c] = top_customers.get(c, 0) + o['total']

if fmt == 'json':
    print(json.dumps({
        'period': period,
        'total_orders': total_orders,
        'total_revenue': round(total_revenue, 2),
        'by_status': by_status,
        'top_items': dict(sorted(top_items.items(), key=lambda x: -x[1])[:5]),
        'top_customers': {k: round(v, 2) for k, v in sorted(top_customers.items(), key=lambda x: -x[1])[:5]}
    }, indent=2))
else:
    print(f'=== Order Report ({period}) ===')
    print(f'Total orders:   {total_orders}')
    print(f'Total revenue:  ${total_revenue:,.2f}')
    print()

    print('By Status:')
    for s, count in sorted(by_status.items()):
        pct = count / total_orders * 100
        bar = '█' * int(pct / 2)
        print(f'  {s:<15} {count:>5}  ({pct:>5.1f}%)  {bar}')
    print()

    print('Top Items (by quantity):')
    for item, qty in sorted(top_items.items(), key=lambda x: -x[1])[:5]:
        print(f'  {item:<20} {qty:>8}')
    print()

    print('Top Customers (by spend):')
    for cust, spend in sorted(top_customers.items(), key=lambda x: -x[1])[:5]:
        print(f'  {cust:<20} ${spend:>10,.2f}')
PYEOF
}

# ─── help ────────────────────────────────────────────────────────────────────

cmd_help() {
  cat <<'EOF'
orders — Order management system.

Commands:
  create     Create a new order (customer, item, quantity, price)
  list       List all orders, optionally filter by status
  status     Query the status of a specific order by ID
  update     Update an order's status, quantity, or note
  cancel     Cancel an order by ID
  report     Generate a summary report with totals and breakdowns
  help       Show this help message

Examples:
  script.sh create "John Doe" Widget 5 19.99 --note "rush delivery"
  script.sh list --status pending --format table
  script.sh status ORD-20240115-0042
  script.sh update ORD-20240115-0042 --status shipped
  script.sh cancel ORD-20240115-0042 --reason "customer request"
  script.sh report --period month --format json
EOF
}

# ─── main dispatch ───────────────────────────────────────────────────────────

main() {
  if [[ $# -lt 1 ]]; then
    cmd_help
    exit 1
  fi

  local command="$1"
  shift

  case "${command}" in
    create)  cmd_create "$@" ;;
    list)    cmd_list "$@" ;;
    status)  cmd_status "$@" ;;
    update)  cmd_update "$@" ;;
    cancel)  cmd_cancel "$@" ;;
    report)  cmd_report "$@" ;;
    help|--help|-h) cmd_help ;;
    *)
      echo "Unknown command: ${command}" >&2
      echo "Run 'script.sh help' for usage." >&2
      exit 1
      ;;
  esac
}

main "$@"
