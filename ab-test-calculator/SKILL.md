---
version: "2.0.0"
name: ab-test-calculator
description: "A/B测试计算器。样本量计算、统计显著性检验、实验时长预估、结果报告、贝叶斯分析。AB test calculator with sample size, significance testing, duration estimation, reports."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# A/B Test Calculator Skill

A/B测试统计计算器 — 科学决策，数据驱动。

## Commands

Run via: `bash scripts/abtest.sh <command> [args...]`

| Command      | Description                    |
|--------------|--------------------------------|
| calculate    | 计算两组的统计显著性             |
| sample       | 计算所需最小样本量               |
| significance | 检验p值和置信区间                |
| duration     | 预估实验所需天数                 |
| report       | 生成完整A/B测试报告              |
| bayesian     | 贝叶斯方法分析胜率               |

## Usage Examples

```bash
# 计算显著性（访客数 转化数）
bash scripts/abtest.sh calculate 1000 50 1000 65

# 计算样本量（基线转化率 最小可检测提升 显著性水平）
bash scripts/abtest.sh sample 0.05 0.02 0.95

# 预估实验时长（日均流量 所需样本量）
bash scripts/abtest.sh duration 5000 16000

# 贝叶斯分析
bash scripts/abtest.sh bayesian 1000 50 1000 65

# 生成报告
bash scripts/abtest.sh report 1000 50 1000 65 "按钮颜色测试"
```
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
