---
name: orders
description: "Track orders locally. Use when creating orders, checking status, updating quantities, canceling, or generating sales reports."
version: "3.4.0"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags:
  - orders
  - management
  - ecommerce
  - tracking
  - inventory
  - report
---

# Orders Skill

Create, track, update, cancel, and report on orders.

## Commands

### create

Create a new order.

```bash
bash scripts/script.sh create <customer> <item> <quantity> <unit_price> [--note <text>]
```

### list

List all orders or filter by status.

```bash
bash scripts/script.sh list [--status pending|shipped|delivered|cancelled] [--format table|json|csv]
```

### status

Query the status of a specific order.

```bash
bash scripts/script.sh status <order_id>
```

### update

Update an existing order (status, quantity, or note).

```bash
bash scripts/script.sh update <order_id> [--status <new_status>] [--quantity <num>] [--note <text>]
```

### cancel

Cancel an order by ID.

```bash
bash scripts/script.sh cancel <order_id> [--reason <text>]
```

### report

Generate a summary report of all orders.

```bash
bash scripts/script.sh report [--period today|week|month|all] [--format table|json]
```

## Output

All commands print to stdout. Order data is stored in `~/.orders/orders.json`. Order IDs are auto-generated. Use `--format json` for machine-readable output where supported.


## Requirements
- bash 4+
- python3 (standard library only)

## Feedback

Questions or suggestions? → [https://bytesagain.com/feedback/](https://bytesagain.com/feedback/)

---

Powered by BytesAgain | bytesagain.com
