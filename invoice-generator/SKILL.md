---
version: "2.0.0"
name: invoice-generator
description: "发票生成器。HTML发票生成、模板库、金额计算(含税)、定期账单、收据、导出格式。Invoice generator with HTML output, templates, tax calculation, recurring billing, receipts, export formats. Use when you need invoice generator capabilities. Triggers on: invoice generator."
---
# invoice-generator

发票生成器。HTML发票生成、模板库、金额计算(含税)、定期账单、收据、导出格式。Invoice generator with HTML output, templates, tax calculation, recurring billing, receipts, export formats.

## 如何使用

1. 选择你需要的功能命令
2. 输入你的具体需求描述
3. 获取专业的输出结果
4. 根据需要调整和完善

## 命令速查

```
  create          create
  template        template
  minimal         minimal
  detailed        detailed
  calculate       calculate
  recurring       recurring
  receipt         receipt
  export          export
```


## 专业建议

- 发票编号规范**: 使用 `INV-YYYY-NNN` 格式，便于归档和检索
- 税率常用值**: 增值税一般纳税人13%/9%/6%，小规模3%
- HTML发票**: 输出后用浏览器打开，Ctrl+P 可直接打印或存PDF
- 定期账单**: 先用 `recurring` 生成计划，再逐月用 `create` 生成
- 多行项目**: 用分号分隔多个项目，如 "项目1:1000;项目2:2000"

---
*invoice-generator by BytesAgain*
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Commands

| Command | Description |
|---------|-------------|
| `invoice-generator help` | Show usage info |
| `invoice-generator run` | Run main task |
