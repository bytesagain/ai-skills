---
version: "2.0.0"
name: compensation-calc
description: "薪酬计算器。薪资计算、奖金方案、股权激励、市场对标、薪资谈判、总包计算。Compensation calculator with salary, bonus, equity, benchmarking, negotiation, total comp. 薪酬、工资、奖金、股权、谈薪。Use when calculating or designing compensation. Triggers on: compensation calc."
author: BytesAgain
---

# Compensation Calc — 薪酬计算器

薪酬设计与计算全能工具，涵盖薪资、奖金、股权、对标、谈判。

## Commands

| Command | Description |
|---------|-------------|
| `salary` | 薪资计算 — 税前税后、社保公积金 |
| `bonus` | 奖金方案 — 年终奖、绩效奖金设计 |
| `equity` | 股权激励 — 期权/RSU方案设计 |
| `benchmark` | 市场对标 — 行业薪资水平参考 |
| `negotiate` | 薪资谈判 — 谈薪策略和话术 |
| `total` | 总包计算 — 全面薪酬总包分析 |

## Usage

```bash
bash scripts/comp.sh salary "月薪25000 北京"
bash scripts/comp.sh bonus "年终奖方案"
bash scripts/comp.sh equity "A轮创业公司 CTO"
bash scripts/comp.sh benchmark "高级前端 上海"
bash scripts/comp.sh negotiate "期望涨幅30%"
bash scripts/comp.sh total "月薪3万 年终3个月 期权1万股"
```
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

- Run `compensation-calc help` for all commands

