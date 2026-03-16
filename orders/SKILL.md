---
name: orders
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [orders, tool, utility]
description: "Orders - command-line tool for everyday use"
---

# Orders

Order management toolkit — track orders, manage inventory, process returns, generate invoices, shipping status, and sales analytics.

## Commands

| Command | Description |
|---------|-------------|
| `orders list` | [status] |
| `orders track` | <id> |
| `orders create` | <item> |
| `orders return` | <id> |
| `orders invoice` | <id> |
| `orders stats` | [period] |

## Usage

```bash
# Show help
orders help

# Quick start
orders list [status]
```

## Examples

```bash
# Example 1
orders list [status]

# Example 2
orders track <id>
```

- Run `orders help` for all available commands

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

## When to Use

- Quick orders tasks from terminal
- Automation pipelines

## Output

Results go to stdout. Save with `orders run > output.txt`.

## Configuration

Set `ORDERS_DIR` to change data directory. Default: `~/.local/share/orders/`

## When to Use

- Quick orders tasks from terminal
- Automation pipelines
