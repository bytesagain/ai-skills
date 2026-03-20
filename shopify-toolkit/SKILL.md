---
version: "2.0.0"
name: shopify-toolkit
description: "Manage Shopify products, orders, inventory, and collections via API. Use when syncing catalogs, monitoring orders, automating stock, notifying events."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Shopify Toolkit

A full-featured Shopify store management toolkit for listing and managing products, orders, customers, inventory, collections, and shop settings — all from the command line using the Shopify Admin REST API. Provides complete e-commerce store management capabilities for automation and reporting.

## Description

Shopify Toolkit gives you programmatic control over your Shopify store. List and search products, view and manage orders, update inventory levels, manage customer records, handle collections, and retrieve shop analytics. Supports pagination for large datasets, formatted output for reporting, and all standard CRUD operations. Ideal for inventory automation, order management, bulk product updates, customer analytics, and e-commerce operations.

## Requirements

- `SHOPIFY_STORE` — Your Shopify store name (the `xxx` in `xxx.myshopify.com`)
- `SHOPIFY_ACCESS_TOKEN` — Admin API access token
- Create a custom app in your Shopify Admin → Settings → Apps and sales channels → Develop apps

## Commands

- `count-orders` — Execute count-orders
- `count-products` — Execute count-products
- `create-product` — Error: --title required
- `get-order` — {}'.format(o.get('order_number','')))
- `get-product` — Error: --product-id required
- `list-customers` — Execute list-customers
- `list-orders` — {} — \${:.2f}'.format(status, fulfillment, o.get('order_numb
- `list-products` — Execute list-products
- `shop-info` — Execute shop-info
- `xxx` — -gt 0 ]; do
## Environment Variables

| Variable | Required | Description |
| Command | Description |
|---------|-------------|
| `shop-info` | Shop Info |
| `list-products` | List Products |
| `get-product` | Get Product |
| `create-product` | Create Product |
| `list-orders` | List Orders |
| `get-order` | Get Order |
| `list-customers` | List Customers |
| `count-products` | Count Products |
| `count-orders` | Count Orders |

## Examples

```bash
# List products
SHOPIFY_STORE=mystore SHOPIFY_ACCESS_TOKEN=shpat_xxx shopify-toolkit products 20

# Search products
SHOPIFY_STORE=mystore SHOPIFY_ACCESS_TOKEN=shpat_xxx shopify-toolkit product search "t-shirt"

# List recent orders
SHOPIFY_STORE=mystore SHOPIFY_ACCESS_TOKEN=shpat_xxx shopify-toolkit orders 10 open

# Get order details
SHOPIFY_STORE=mystore SHOPIFY_ACCESS_TOKEN=shpat_xxx shopify-toolkit order get 12345

# Update inventory
SHOPIFY_STORE=mystore SHOPIFY_ACCESS_TOKEN=shpat_xxx shopify-toolkit inventory set 111 222 50

# Store summary
SHOPIFY_STORE=mystore SHOPIFY_ACCESS_TOKEN=shpat_xxx shopify-toolkit summary
```
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
