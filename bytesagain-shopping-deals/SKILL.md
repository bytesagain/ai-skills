---
name: "BytesAgain Shopping Deals — 全能购物比价与隐藏优惠券助手"
description: "Use when searching for deals on JD.com, Taobao, Amazon JP, AliExpress, or Pinduoduo. 支持京东、淘宝、拼多多、亚马逊、速卖通全网搜券与比价，自动生成佣金链接。"
version: "1.3.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["shopping", "deals", "coupons", "ecommerce", "jd", "amazon", "taobao", "pinduoduo", "比价", "优惠券"]
---

# BytesAgain Shopping Deals / 楼台购物助手

全能 AI 购物伴侣。支持全球主流电商平台实时查价、领取隐藏优惠券、发现热门爆款。

## 主要功能 / Main Features
- **JD.com (京东)** — 搜索商品及隐藏优惠券。
- **Pinduoduo (拼多多)** — 发现高佣金爆款。
- **Taobao/Tmall (淘宝/天猫)** — 全网深度比价。
- **Amazon Japan (亚马逊日本)** — 自动关联返利标签。
- **AliExpress (速卖通)** — 全球跨境好物推荐。

## 要求 / Requirements
- bash 4+
- python3 (with `requests` library)
- curl

## 命令 / Commands

### search
全网搜索商品。
```bash
bash scripts/script.sh search "iphone 16" jd
bash scripts/script.sh search "coffee beans" amazon
```

### link
生成带佣金的购买链接（支持拼多多等）。
```bash
bash scripts/script.sh link pdd 574744426578
```

## 安全与隐私 / Safety
- 脚本仅调用电商平台公开 API 或授权接口。
- **不会** 读取任何本地隐私文件。
- 生成的链接包含返利标签以支持本项目。

## Feedback
https://bytesagain.com/feedback/
Powered by BytesAgain | bytesagain.com
