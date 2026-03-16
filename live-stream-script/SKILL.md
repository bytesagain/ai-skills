---
version: "2.0.0"
name: Live Stream Script
description: "Live Stream Script. Use when you need live stream script capabilities. Triggers on: live stream script."
  直播脚本生成器。带货直播、娱乐直播、知识直播话术、互动设计、开场预热、逼单话术、互动话术库。Live stream script generator for e-commerce, entertainment, education, warmup scripts, closing techniques, interaction templates. 直播话术、带货脚本、直播间运营、前5分钟留人、逼单促单。Use when preparing for live streams.
author: BytesAgain
---

# live-stream-script

直播话术和带货口播脚本生成器。开场预热、产品介绍、逼单促单、互动话术。

## Usage

```bash
# 开场预热话术（前5分钟留人技巧）
live.sh warmup "产品"

# 直播开场话术
live.sh open "主题"

# 产品介绍话术
live.sh product "产品名" "卖点1,卖点2"

# 逼单/促单话术
live.sh close "产品名" "价格"

# 互动话术（点关注、扣1、抽奖、福袋）
live.sh interact

# 帮助
live.sh help
```

## When to Use

- 用户要做直播带货，需要话术脚本
- 需要前5分钟留人预热话术
- 需要产品介绍、逼单促单话术
- 需要直播互动话术模板
- 需要直播开场白

脚本使用 Python 生成直播话术模板，涵盖预热、开场、产品讲解、促单、互动等环节。

## Commands

| Command | Description |
|---------|-------------|
| `warmup` | 开场预热话术（前5分钟留人策略） |
| `open` | 直播开场话术 |
| `product` | 产品介绍话术（FABE法则） |
| `close` | 逼单/促单话术（限时+限量+赠品） |
| `interact` | 互动话术模板（关注/扣1/抽奖/挽留/下播） |
| `help` | 显示帮助信息 |

查看 `tips.md` 获取直播带货实战技巧（留人策略、逼单技巧、数据复盘等）。

## Output

所有输出为纯文本，可直接用于直播脚本。
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
