---
version: "2.0.0"
name: prompt-generator
description: "AI prompt generator for image and text. AI绘画提示词、AI画图、Midjourney提示词、MJ提示词、Stable Diffusion提示词、SD提示词、DALL-E提示词、AI绘图、AI生图、AI画画、文生图提示词、text-to-image prompt、写作提示词."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Prompt Generator

AI绘画/写作提示词生成器。基于模板+随机组合，纯本地运行。

## 为什么用这个 Skill？ / Why This Skill?

- **平台专属格式**：Midjourney带`--ar --v`参数，SD带quality tags + negative prompt，不是通用提示词
- **中翻英**：中文描述自动翻译成专业英文提示词，包含风格、光影、质量词
- **负面提示词**：自动生成negative prompt，避免常见出图问题
- Compared to asking AI directly: platform-specific formatting (MJ params, SD quality tags, negative prompts), built-in style presets, and batch variation generation

## Commands

All commands via `scripts/prompt.sh`:

```bash
# 通用AI绘画提示词（英文，含正面+负面提示词）
prompt.sh image "主题" [--style realistic|anime|oil|watercolor|3d|pixel|cyberpunk|fantasy]

# Midjourney专用（含 --ar --v 参数）
prompt.sh midjourney "主题"

# Stable Diffusion专用（含quality tags + negative prompt）
prompt.sh sd "主题"

# 写作提示词
prompt.sh writing "主题" [--tone formal|casual|creative|academic]

# 中文翻译成英文提示词
prompt.sh translate "中文描述"

# 增强/优化已有提示词
prompt.sh enhance "基础提示词"

# 批量生成变体
prompt.sh batch "主题" --count 5

# 风格词库（赛博朋克/国风/油画/水彩/动漫/奇幻/科幻/极简/恐怖）
prompt.sh style "cyberpunk"

# 负面提示词大全
prompt.sh negative

# 完整工作流（构思→参数→出图→后处理）
prompt.sh workflow "portrait"

# 提示词升级（简单→专业，4级递进）
prompt.sh upscale "a cat in rain"

# 帮助
prompt.sh help
```

## Usage Notes

- 绘画提示词输出均为英文（AI绘画标准）
- 自动包含quality boosters和negative prompt
- Midjourney格式: `/imagine prompt: ... --ar 16:9 --v 6`
- SD格式: 正面提示词 + Negative prompt 分开显示
- 支持中文主题输入，自动处理
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
