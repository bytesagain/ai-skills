---
version: "2.0.0"
name: Payment Integration
description: "Integrate WeChat Pay and Alipay with refund handling and callbacks. Use when adding payment flows, debugging webhooks, or testing sandbox."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# Payment Integration

支付集成指南。微信支付、支付宝、退款、回调webhook、测试。Payment integration guide for WeChat Pay, Alipay. 支付、微信支付、支付宝。

## 功能命令

| 命令 | 说明 |
|------|------|
| `integrate` | integrate |
| `wechat-pay` | wechat pay |
| `alipay` | alipay |
| `refund` | refund |
| `webhook` | webhook |
| `test` | test |

## 快速开始

```bash
alipay-helper help
```
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Commands

- `qrcode` — <金额> [描述]     生成收款码链接/HTML
- `bill` — [月份]            生成账单分析模板
- `reconcile` — Reconcile
- `refund` — <订单号> <金额>   退款流程模板
- `webhook` — 回调处理代码模板
- `config` — <平台>            配置检查清单
- `test` — 支付测试清单

- Run `alipay-helper help` for all commands


## When to Use

- Quick alipay tasks from terminal
- Automation pipelines
