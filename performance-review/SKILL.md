---
version: "2.0.0"
name: Performance Review
description: "绩效评估和述职报告生成器。自评、主管评语、KPI总结、晋升述职、SMART目标设定、360反馈撰写。. Use when you need performance review capabilities. Triggers on: performance review."
  绩效评估助手。自评、上级评语、OKR复盘、KPI分析、改进计划、SMART目标设定、360反馈撰写。Performance review assistant with self-assessment, manager feedback, OKR review, SMART goals, 360 feedback writing. 绩效考核、年终评估、360评估。Use when writing performance reviews.
author: BytesAgain
---

# performance-review

绩效评估和述职报告生成器。自评、主管评语、KPI总结、晋升述职、SMART目标设定、360反馈撰写。

## Usage

Run the script at `scripts/review.sh` with the following commands:

| Command | Description |
|---------|-------------|
| `review.sh self "岗位" "成果1,成果2,成果3"` | 生成自评报告 |
| `review.sh manager "员工表现描述"` | 生成主管评语 |
| `review.sh kpi "目标1:完成度,目标2:完成度"` | KPI报告 |
| `review.sh promotion "岗位" "年限" "成果"` | 晋升述职报告 |
| `review.sh goal "目标1,目标2"` | SMART目标设定/OKR转化 |
| `review.sh feedback "对象" "情况"` | 360反馈撰写 |
| `review.sh help` | 显示帮助信息 |

## Examples

```bash
# 自评报告
bash scripts/review.sh self "产品经理" "上线3个新功能,用户增长20%,客户满意度提升"

# 主管评语
bash scripts/review.sh manager "该员工工作积极主动，完成了多个重要项目"

# KPI报告
bash scripts/review.sh kpi "销售额目标100万:完成120万,新客户50个:完成45个"

# 晋升述职
bash scripts/review.sh promotion "高级工程师" "3年" "主导微服务架构改造"

# SMART目标设定
bash scripts/review.sh goal "提升用户留存率,优化推荐算法,带新人"

# 360反馈
bash scripts/review.sh feedback "同事" "项目合作中沟通积极,但deadline意识需加强"
```

## Requirements

- Python 3.6+
- No external dependencies
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
