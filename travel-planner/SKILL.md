---
version: "2.0.0"
name: Travel Planner
description: "旅行攻略生成器。行程规划、景点推荐、预算估算、打包清单。. Use when you need travel planner capabilities. Triggers on: travel planner."
  旅行规划助手。行程安排、景点推荐、预算规划、打包清单。Travel planner with itinerary, attractions, budget planning, packing list. 旅游攻略、自由行、旅行计划。Use when planning trips.
---

# travel-planner

旅行攻略生成器。行程规划、景点推荐、预算估算、打包清单。

## Commands

| 命令 | 说明 |
|------|------|
| `travel.sh plan "目的地" "天数"` | 生成每日行程规划 |
| `travel.sh budget "目的地" "天数" "人数"` | 预算估算（交通/住宿/餐饮/门票） |
| `travel.sh packing "目的地" "季节"` | 打包清单 |
| `travel.sh tips "目的地"` | 旅行注意事项 |
| `travel.sh help` | 显示帮助信息 |

## Usage

当用户询问旅行规划、攻略、预算、打包清单等话题时，使用对应命令生成内容。

**示例：**
```bash
# 规划5天东京行程
bash scripts/travel.sh plan "东京" "5"

# 估算3人5天东京预算
bash scripts/travel.sh budget "东京" "5" "3"

# 夏天去东京的打包清单
bash scripts/travel.sh packing "东京" "夏天"

# 东京旅行注意事项
bash scripts/travel.sh tips "东京"
```

将脚本输出作为回复内容的基础，可根据用户需求进一步调整和补充。
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
