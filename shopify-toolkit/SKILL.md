---
name: "shopify-toolkit"
version: "7.0.0"
description: "Shopify development reference — Liquid templates, Admin/Storefront API, theme architecture, OAuth, checkout extensibility, and CLI commands."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [shopify, ecommerce, liquid, storefront-api, theme-development]
category: "devtools"
---

# Shopify Toolkit

Shopify development reference covering Liquid templates, Admin and Storefront APIs, theme architecture (OS 2.0), app development with OAuth, checkout extensibility, and performance optimization. No API keys or credentials required — outputs reference documentation only.

## When to Use

- Building or customizing a Shopify theme with Liquid templates
- Working with Shopify Admin or Storefront GraphQL APIs
- Setting up OAuth flow for a Shopify app
- Optimizing storefront Core Web Vitals (LCP, CLS, INP)
- Migrating from Theme 1.0 to OS 2.0 or Checkout Extensibility
- Looking up Liquid filters, tags, or CLI commands

## Commands

| Command | Description |
|---------|-------------|
| `intro` | Platform architecture — Liquid, APIs, Functions, Hydrogen, CLI |
| `standards` | Theme file structure, section schema, OAuth scopes, metafields |
| `troubleshooting` | Liquid errors, API rate limits (40 req/s), webhook failures, checkout issues |
| `performance` | Liquid optimization, image srcset, JS/CSS auditing, Core Web Vitals |
| `security` | HMAC webhook validation, session tokens, OAuth flow, CSP |
| `migration` | Theme 1.0→2.0, checkout.liquid→Checkout Extensibility, platform migration |
| `cheatsheet` | Shopify CLI commands, GraphQL queries, Liquid filters/tags, webhook events |
| `faq` | Payments, multi-currency, Hydrogen vs Online Store, app count, Plus pricing |

## Usage

```bash
scripts/script.sh intro
scripts/script.sh cheatsheet
scripts/script.sh troubleshooting
```

## Output Format

All commands output plain-text reference documentation via heredoc. No external API calls, no credentials needed, no network access.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
