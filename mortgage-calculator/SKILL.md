---
version: "2.0.0"
name: Mortgage Calculator
description: "房贷计算器。等额本息、等额本金、提前还款、两种方式对比、贷款能力评估。. Use when you need mortgage calculator capabilities. Triggers on: mortgage calculator."
  房贷计算器。等额本息、等额本金、提前还款、利率对比、月供计算、贷款能力评估。Mortgage calculator with equal principal, prepayment analysis, rate comparison, affordability assessment. 房贷计算、买房、月供、公积金贷款、我能贷多少。Use when calculating mortgage payments.
author: BytesAgain
---

# mortgage-calculator

房贷计算器。等额本息、等额本金、提前还款、两种方式对比、贷款能力评估。

## Commands

All commands via `scripts/mortgage.sh`:

| Command | Usage | Description |
|---------|-------|-------------|
| `equal-payment` | `mortgage.sh equal-payment "总额万" "年限" "利率%"` | 等额本息计算（月供固定） |
| `equal-principal` | `mortgage.sh equal-principal "总额万" "年限" "利率%"` | 等额本金计算（月供递减） |
| `prepay` | `mortgage.sh prepay "剩余本金万" "已还月数" "提前还款万"` | 提前还款节省利息计算 |
| `compare` | `mortgage.sh compare "总额万" "年限" "利率%"` | 等额本息 vs 等额本金全面对比 |
| `afford` | `mortgage.sh afford "月收入" "月支出"` | 我能贷多少？（反算贷款能力） |
| `help` | `mortgage.sh help` | 显示帮助信息 |

## Examples

```bash
# 贷款100万，30年，利率3.5%（等额本息）
bash scripts/mortgage.sh equal-payment 100 30 3.5

# 贷款80万，20年，利率3.5%（等额本金）
bash scripts/mortgage.sh equal-principal 80 20 3.5

# 剩余本金60万，已还60个月，提前还20万
bash scripts/mortgage.sh prepay 60 60 20

# 对比两种还款方式
bash scripts/mortgage.sh compare 100 30 3.5

# 月收入2万，月支出5千，能贷多少？
bash scripts/mortgage.sh afford 20000 5000
```

## Reference

- 参考文档: `tips.md` — 房贷实用指南（提前还款攻略、利率知识、买房避坑）

## Notes

- 金额单位：万元
- 利率单位：年利率百分比（如3.5表示3.5%）
- 纯本地计算，无需联网
- Python 3.6+ 兼容
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
