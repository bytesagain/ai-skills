---
version: "2.0.0"
name: contract-template
description: "Contract and agreement template generator. 合同模板、合同范本、协议书、contract template、劳动合同、employment contract、劳动协议、保密协议NDA、non-disclosure agreement、租赁合同、租房合同、lease agreement、服务协议、service agreement、合作协议、合伙协议、法律文书、法律模板、免责声明、竞业禁止、知识产权协议、外包合同、freelance contract。Generate labor contracts, NDAs, service agreements, rental contracts. Use when: (1) drafting labor/employment contracts, (2) creating NDA/confidentiality agreements, (3) writing service agreements, (4) generating rental/lease contracts, (5) any contract or legal document template. 适用场景：写劳动合同、保密协议、服务协议、租赁合同、合作协议、法律文书模板。 Triggers on: contract template."
author: BytesAgain
---

# contract-template

合同和协议模板生成器。劳动合同、保密协议、合作协议、租赁合同。

## 为什么用这个 Skill？ / Why This Skill?

- **标准条款**：内置常见合同必备条款（甲乙方信息、权利义务、违约责任、争议解决等）
- **即填即用**：生成的模板留有明确的填写位置，直接填信息就能用
- **多种类型**：劳动合同、NDA、服务协议、租赁合同，覆盖常见场景
- Compared to asking AI directly: structured legal templates with standard clauses, fill-in-the-blank format, and proper legal formatting

## Usage

Run the script at `scripts/contract.sh`:

| Command | Description |
|---------|-------------|
| `contract.sh labor "甲方" "乙方"` | 劳动合同模板 |
| `contract.sh nda "甲方" "乙方"` | 保密协议NDA |
| `contract.sh service "甲方" "乙方" "服务内容"` | 服务协议 |
| `contract.sh rental "房东" "租客" "地址"` | 租赁合同 |
| `contract.sh help` | 显示帮助信息 |

## Examples

```bash
# 劳动合同
bash scripts/contract.sh labor "北京科技有限公司" "张三"

# 保密协议
bash scripts/contract.sh nda "甲方公司" "乙方公司"

# 服务协议
bash scripts/contract.sh service "委托方" "服务方" "软件开发与维护"

# 租赁合同
bash scripts/contract.sh rental "李四" "王五" "北京市朝阳区XX路XX号"
```
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
