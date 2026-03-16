---
version: "2.0.0"
name: Legal Advisor
description: "法律咨询模板生成器。劳动纠纷、消费维权、租房纠纷、交通事故。含法律条文参考。. Use when you need legal advisor capabilities. Triggers on: legal advisor."
  法律咨询助手。劳动法、合同法、消费者权益、知识产权、民事纠纷。Legal advisor for labor law, contract law, consumer rights, IP, civil disputes. 法律咨询、律师、维权、法律常识。Use when needing legal guidance.
author: BytesAgain
---

# legal-advisor

法律咨询模板生成器。劳动纠纷、消费维权、租房纠纷、交通事故。含法律条文参考。

> ⚠️ **免责声明：本工具仅供参考，不构成法律建议。如需专业法律服务，请咨询执业律师。**

## Usage

When the user asks about legal questions, labor disputes, consumer rights, rental issues, or traffic accidents, use the script to generate consultation templates.

### Commands

Run scripts from: `~/.openclaw/workspace/skills/legal-advisor/scripts/`

| Command | Description |
|---------|-------------|
| `legal.sh labor "问题描述"` | 劳动法咨询（工资拖欠、加班、解雇等） |
| `legal.sh consumer "问题描述"` | 消费维权（假货、退款、欺诈等） |
| `legal.sh rental "问题描述"` | 租房纠纷（押金、合同、维修等） |
| `legal.sh traffic "问题描述"` | 交通事故（责任认定、赔偿、保险等） |
| `legal.sh help` | 显示帮助信息 |

### Example

```bash
bash scripts/legal.sh labor "公司拖欠两个月工资不发"
bash scripts/legal.sh consumer "网购收到假货商家拒绝退款"
bash scripts/legal.sh rental "房东不退押金"
bash scripts/legal.sh traffic "被追尾对方全责如何索赔"
```

### Workflow

1. Identify the legal category from user's question
2. Run the appropriate command with a concise problem description
3. Present the generated template to the user
4. **Always include the disclaimer** that this is for reference only

### Output

The script outputs a structured JSON template containing:
- 问题分类 (category)
- 相关法律条文 (relevant laws)
- 维权步骤 (steps to protect rights)
- 证据清单 (evidence checklist)
- 注意事项 (important notes)
- 免责声明 (disclaimer)
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
