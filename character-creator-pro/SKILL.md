---
version: "2.0.0"
name: character-creator-pro
description: "角色设计工具。创建角色档案、背景故事、性格特征、人物关系、角色弧光、角色卡。Character creator with profiles, backstories, personality traits, relationships, character arcs."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Character Creator Skill

角色设计工具 — 让角色活起来。

## Commands

Run via: `bash scripts/character.sh <command> [args...]`

| Command      | Description                  |
|--------------|------------------------------|
| create       | 创建角色基础档案              |
| backstory    | 生成角色背景故事              |
| personality  | 设计性格特征和心理画像        |
| relationship | 设计人物关系网                |
| arc          | 规划角色成长弧光              |
| sheet        | 生成完整角色卡                |

## Usage Examples

```bash
# 创建角色（名字 类型 世界观）
bash scripts/character.sh create "林夜" "protagonist" "武侠"

# 背景故事
bash scripts/character.sh backstory "林夜" "orphan,martial-arts,revenge"

# 性格特征
bash scripts/character.sh personality "林夜" "INTJ" "沉稳,机敏,孤傲"

# 人物关系
bash scripts/character.sh relationship "林夜" "师父:慕容白,宿敌:萧无痕,挚友:陈小七"

# 角色弧光
bash scripts/character.sh arc "林夜" "复仇者→守护者" "3acts"

# 完整角色卡
bash scripts/character.sh sheet "林夜" "rpg"
```
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
