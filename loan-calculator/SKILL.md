---
version: "2.0.0"
name: loan-calculator
description: "贷款计算器。等额本息/等额本金计算、方案对比、提前还款分析、贷款能力评估、还款计划表、再融资分析。Loan calculator with equal installment/principal, comparison, prepayment analysis, affordability, schedule, refinance. Use when you need loan calculator capabilities. Triggers on: loan calculator."
author: BytesAgain
---
# loan-calculator

贷款计算器。等额本息/等额本金计算、方案对比、提前还款分析、贷款能力评估、还款计划表、再融资分析。Loan calculator with equal installment/principal, comparison, prepayment analysis, affordability, schedule, refinance.

## 如何使用

1. 选择你需要的功能命令
2. 输入你的具体需求描述
3. 获取专业的输出结果
4. 根据需要调整和完善

## 命令列表

| 命令 | 功能 |
|------|------|
| `calculate` | calculate |
| `compare` | compare |
| `prepay` | prepay |
| `afford` | afford |
| `schedule` | schedule |
| `refinance` | refinance |
| `help` | help |

## 专业建议

- `calculate` 默认使用等额本息（月供固定），加 `equal-principal` 切换等额本金
- `afford` 按月收入的40%计算最大月供，保守安全
- 等额本息**：每月还款相同，前期利息多，适合收入稳定者
- 等额本金**：每月递减，总利息少，适合收入较高者
- 贷款前1/3时间提前还款最划算（利息占比大）

---
*loan-calculator by BytesAgain*
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Examples

```bash
# Show help
loan-calculator help

# Run
loan-calculator run
```

## Commands

Run `loan-calculator help` to see all available commands.
