---
version: "2.0.0"
name: ppt-outline
description: "PPT outline and HTML presentation generator. PPT大纲、PPT模板、演示文稿、presentation、PowerPoint、幻灯片、slides、HTML演示文稿、HTML slides、浏览器演示、商业路演、pitch deck、BP商业计划书、business plan、工作汇报PPT、培训课件、课件大纲、产品介绍PPT、产品发布、keynote、演讲稿、述职PPT、答辩PPT、竞品分析PPT、毕业答辩、论文答辩、项目复盘、迭代复盘。Generate PPT outlines and standalone HTML presentations (open directly in browser, no dependencies). Use when: (1) creating PPT/presentation outlines, (2) building pitch deck/BP structures, (3) preparing work report slides, (4) designing training course outlines, (5) creating thesis defense PPT outlines, (6) building project review/retrospective PPTs, (7) generating HTML slide decks for browser-based presentations, (8) any PowerPoint/Keynote/Google Slides planning. 适用场景：做PPT大纲、写路演BP、汇报PPT结构、培训课件大纲、毕业答辩PPT、项目复盘PPT、述职答辩PPT、生成HTML演示文稿（浏览器直接打开，支持dark/light/tech/minimal四种风格）。 Triggers on: ppt outline."
author: BytesAgain
---

# ppt-outline

PPT大纲和演示文稿结构生成器。商业路演、工作汇报、产品介绍、培训课件。

## 为什么用这个 Skill？ / Why This Skill?

- **场景化大纲**：路演BP有固定结构（痛点→方案→市场→团队→融资），汇报有汇报的逻辑，不是万能模板
- **每页要点**：不只给标题，每页都有2-4个要点提示，拿来直接填内容
- **页数控制**：`--slides 10` 控制总页数，按需伸缩
- Compared to asking AI directly: scenario-specific slide structures (pitch vs report vs training), per-slide talking points, and slide count control

## Usage

Run the script at `scripts/ppt.sh`:

| Command | Description |
|---------|-------------|
| `ppt.sh outline "主题" [--slides 10]` | 生成PPT大纲（每页标题+要点） |
| `ppt.sh pitch "项目名"` | 商业路演BP大纲 |
| `ppt.sh report "汇报主题"` | 工作汇报PPT大纲 |
| `ppt.sh training "课程主题"` | 培训课件大纲 |
| `ppt.sh defense "论文题目"` | 毕业答辩PPT大纲 |
| `ppt.sh review "项目名"` | 项目复盘PPT大纲 |
| `ppt.sh html "主题" [--style S]` | 生成HTML演示文稿（浏览器直接打开） |
| `ppt.sh help` | 显示帮助信息 |

## Examples

```bash
# 通用PPT大纲（指定页数）
bash scripts/ppt.sh outline "人工智能在医疗领域的应用" --slides 12

# 商业路演
bash scripts/ppt.sh pitch "智能客服SaaS平台"

# 工作汇报
bash scripts/ppt.sh report "2024年Q4部门工作总结"

# 培训课件
bash scripts/ppt.sh training "新员工入职培训-公司文化"

# 毕业答辩
bash scripts/ppt.sh defense "社交媒体对消费行为的影响研究"

# 项目复盘
bash scripts/ppt.sh review "双十一大促活动"

# 生成HTML演示文稿（浏览器直接打开）
bash scripts/ppt.sh html "AI在医疗的应用" --style tech
# 支持风格：dark(默认深色科技) | light(白色商务) | tech(渐变科技) | minimal(极简)
```
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
