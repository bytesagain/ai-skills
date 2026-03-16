---
version: "2.0.0"
name: Jd Writer
description: "招聘JD撰写助手。职位描述、任职要求、公司介绍、福利亮点、薪资市场参考、JD包容性检查。. Use when you need jd writer capabilities. Triggers on: jd writer."
  招聘JD生成器。职位描述、任职要求、公司介绍、福利待遇、薪资参考、包容性检查。Job description writer for hiring with requirements, benefits, salary benchmark, inclusivity check. 招聘文案、岗位描述、HR工具。Use when writing job descriptions.
author: BytesAgain
---

# jd-writer

招聘JD撰写助手。职位描述、任职要求、公司介绍、福利亮点、薪资市场参考、JD包容性检查。

## Usage

Run the script at `scripts/jd.sh` with the following commands:

| Command | Description |
|---------|-------------|
| `jd.sh write "职位" "公司" [--level 初级\|中级\|高级]` | 生成完整职位描述 |
| `jd.sh requirements "职位"` | 生成任职要求 |
| `jd.sh benefits "公司类型"` | 生成福利亮点 |
| `jd.sh optimize "现有JD文本"` | JD优化建议（分析问题+改写建议） |
| `jd.sh benchmark "职位" ["城市"]` | 薪资市场参考（薪资范围+福利标配） |
| `jd.sh inclusive "JD文本"` | 包容性检查（性别偏见/年龄歧视等） |
| `jd.sh help` | 显示帮助信息 |

## Examples

```bash
# 写一份完整JD
bash scripts/jd.sh write "前端开发工程师" "字节跳动" --level 高级

# 生成任职要求
bash scripts/jd.sh requirements "产品经理"

# 福利亮点
bash scripts/jd.sh benefits "互联网大厂"

# 优化现有JD
bash scripts/jd.sh optimize "招聘Java开发，要求3年经验，会Spring"

# 薪资参考
bash scripts/jd.sh benchmark "后端开发" "杭州"

# 包容性检查
bash scripts/jd.sh inclusive "招聘前端开发，男性优先，35岁以下，985院校"
```

## Requirements

- Python 3.6+
- No external dependencies
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
