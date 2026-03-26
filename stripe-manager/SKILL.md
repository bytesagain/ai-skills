---
name: "stripe-manager"
version: "5.0.0"
description: "Stripe payment platform reference — PaymentIntents, webhooks, PCI compliance, 3DS/SCA, Radar fraud rules, and CLI commands."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [stripe, payments, fintech, webhooks, pci-dss]
category: "finance"
---

# Stripe Manager

Stripe payment platform reference covering PaymentIntents API, webhook signature verification, PCI DSS compliance levels, SCA/3D Secure, Radar fraud prevention, and Stripe CLI. No API keys required — outputs reference documentation only.

## When to Use

- Integrating Stripe PaymentIntents or SetupIntents
- Debugging webhook signature verification failures
- Understanding PCI DSS compliance levels (SAQ-A through SAQ-D)
- Looking up card decline codes or error categories
- Migrating from legacy Charges API to PaymentIntents
- Setting up Stripe Connect for marketplace payments

## Commands

| Command | Description |
|---------|-------------|
| `intro` | Stripe architecture — PaymentIntents, Customers, Products, payment flow |
| `standards` | PCI DSS levels, SCA/3DS2, idempotency keys, webhook best practices |
| `troubleshooting` | Card decline codes, webhook failures, payout delays, subscription issues |
| `performance` | Rate limits (100 r+w/s), batch operations, auto-pagination, caching |
| `security` | API key rotation, restricted keys, Radar rules, webhook signatures |
| `migration` | Charges→PaymentIntents, test→live checklist, single→Connect platform |
| `cheatsheet` | CLI commands, API endpoints, test card numbers, webhook event types |
| `faq` | Pricing, payout timing, disputes, international, testing |

## Output Format

All commands output plain-text reference documentation via heredoc. No external API calls, no credentials needed, no network access.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
