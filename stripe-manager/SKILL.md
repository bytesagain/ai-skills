---
version: "2.0.0"
name: stripe-manager
description: "Error: --action required. Use when you need stripe manager capabilities. Triggers on: stripe manager, key, customer-id, amount, currency, desc."
author: BytesAgain
---

# Stripe Manager

A complete Stripe payment management toolkit for listing customers, charges, and subscriptions, creating payment links, checking account balances, managing products and prices, handling refunds, and retrieving payment analytics — all from the command line using the Stripe REST API.

## Description

Stripe Manager provides full access to your Stripe account for payment operations. List and search customers, view charge history, manage subscriptions, create and configure products and prices, generate payment links, process refunds, check your account balance, and retrieve financial summaries. Supports both live and test mode keys. Ideal for payment operations, financial reporting, subscription management, and e-commerce automation.

## Requirements

- `get-balance` — Get Balance
- `list-customers` — List Customers
- `create-customer` — Create Customer
- `get-customer` — Get Customer
- `list-charges` — List Charges
- `list-subscriptions` — List Subscriptions
- `list-products` — List Products
- `list-invoices` — List Invoices
- `list-events` — List Events
- Get your API keys from [configured-endpoint]

## Commands

See commands above.

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `STRIPE_API_KEY` | Yes | Stripe secret key (`sk_live_` or `sk_test_`) |
| `STRIPE_OUTPUT_FORMAT` | No | Output format: `table`, `json`, `markdown` |

## Examples

```bash
# List customers
STRIPE_API_KEY=sk_test_xxx stripe-manager customers 20

# Create a customer
STRIPE_API_KEY=sk_test_xxx stripe-manager customer create "alice@example.com" "Alice Smith"

# Check balance
STRIPE_API_KEY=sk_test_xxx stripe-manager balance

# List charges
STRIPE_API_KEY=sk_test_xxx stripe-manager charges 10

# Refund a charge
STRIPE_API_KEY=sk_test_xxx stripe-manager refund ch_1234 5000

# Create a product and price
STRIPE_API_KEY=sk_test_xxx stripe-manager product create "Pro Plan" "Professional subscription"
STRIPE_API_KEY=sk_test_xxx stripe-manager price create prod_xxx 2999 usd month

# Create a payment link
STRIPE_API_KEY=sk_test_xxx stripe-manager paylink price_xxx 1

# Revenue summary
STRIPE_API_KEY=sk_test_xxx stripe-manager summary 30
```
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
