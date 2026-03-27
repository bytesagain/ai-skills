---
name: "BytesAgain Shopping Deals — All-in-One Price Tracker & Coupon Finder"
description: "Use when searching for deals on JD.com, Taobao, Amazon JP, AliExpress, or Pinduoduo. Get real-time prices, hidden coupons, and direct purchase links."
version: "1.2.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["shopping", "deals", "coupons", "ecommerce", "price-comparison", "jd", "amazon", "taobao", "aliexpress"]
---

# BytesAgain Shopping Deals

The ultimate AI shopping companion. Find the best prices, claim hidden coupons, and discover trending deals across major global e-commerce platforms.

Platforms supported:
- **JD.com (京东)** — Search products and find coupons.
- **Pinduoduo (拼多多)** — High-commission deals.
- **Taobao/Tmall (淘宝/天猫)** — Global product search.
- **Amazon Japan** — Electronics, household goods, and more.
- **AliExpress** — Global cross-border deals.

## Requirements
- bash 4+
- python3 (standard library)
- curl

## Commands

### search
Search for products across multiple platforms.
```bash
bash scripts/script.sh search "iphone 16" --source jd
bash scripts/script.sh search "coffee beans" --source amazon
```

### coupons
Find hidden coupons for a specific product or keyword.
```bash
bash scripts/script.sh coupons "skincare"
```

### trending
Discover current trending products and top-selling deals.
```bash
bash scripts/script.sh trending --source pdd
```

### detail
Get product details and a direct purchase link.
```bash
bash scripts/script.sh detail --id "GOODS_ID" --source "jd"
```

## Safety & Transparency
- This tool makes outbound network calls to official e-commerce APIs and trusted price-aggregation endpoints.
- No personal user data or payment information is collected.
- All links generated include affiliate tags to support the project.

## Feedback
https://bytesagain.com/feedback/
Powered by BytesAgain | bytesagain.com
