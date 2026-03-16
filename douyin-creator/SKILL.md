---
version: "2.0.0"
name: douyin-creator
description: "抖音内容创作与运营助手。抖音运营、抖音涨粉、短视频创作、抖音标题、抖音标签、抖音SEO、抖音账号运营、抖音数据分析、抖音选题、抖音脚本、抖音文案、抖音评论区运营、抖音人设定位、抖音发布时间、DOU+投放、抖音流量、短视频运营、视频创意、直播脚本、话题标签策略、合拍翻拍创意、抖音变现、带货星图、Douyin content creation、monetization。Use when: (1) generating Douyin video ideas and topics, (2) writing video scripts and口播稿, (3) creating viral titles and captions, (4) planning content calendars and posting schedules, (5) analyzing video performance metrics, (6) writing comment section engagement copy, (7) building account persona and positioning, (8) optimizing Douyin SEO and hashtags, (9) hashtag strategy with traffic tiers, (10) duet/remake ideas for using others' traffic, (11) monetization path analysis based on follower count, (12) any Douyin/short video operations task. 适用场景：抖音选题策划、视频脚本、爆款标题、发布计划、数据复盘、评论区话术、账号定位、标签优化、话题标签策略、合拍翻拍创意、变现路径分析。纯本地运行，不连接任何API，数据存储在本地。 Triggers on: douyin creator."
author: BytesAgain
---

# 抖音创作助手

抖音内容创作+运营一站式工具。

## 为什么用这个 Skill？ / Why This Skill?

- **抖音专属**：针对抖音算法特性优化，不是通用短视频模板
- **全链路运营**：从账号定位→选题→脚本→标题→标签→发布计划→数据复盘，完整闭环
- **实战策略**：内置黄金发布时间、标签策略（大+中+长尾）、评论区引战技巧等实操经验
- Compared to asking AI directly: Douyin-specific strategies, algorithm-aware content optimization, and complete operations workflow in one place

## 命令

```bash
scripts/douyin.sh idea "赛道"          # 生成10个视频创意
scripts/douyin.sh hook "主题"          # 5个开场钩子（前3秒留人）
scripts/douyin.sh script "主题" [30|60] # 完整视频脚本
scripts/douyin.sh title "主题"         # 5个爆款标题
scripts/douyin.sh tags "主题"          # 标签推荐（SEO优化）
scripts/douyin.sh hashtag "主题"       # 话题标签策略（大流量+精准+长尾）
scripts/douyin.sh duet "主题"          # 合拍/翻拍创意（借流量）
scripts/douyin.sh monetize "粉丝量"    # 变现路径分析（带货/星图/直播/私域）
scripts/douyin.sh schedule [3|5|7]     # 生成每周发布计划
scripts/douyin.sh comment "视频主题"    # 评论区互动话术
scripts/douyin.sh persona "赛道"       # 账号人设定位建议
scripts/douyin.sh trending            # 当前热门赛道
scripts/douyin.sh review "播放,点赞,评论,转发" # 数据复盘建议
```

## 抖音运营要点

- 前3秒决定生死：用悬念/冲突/痛点开场
- 黄金发布时间：7:00-9:00 / 12:00-13:00 / 18:00-20:00 / 21:00-23:00
- 标签策略：2个热门大标签 + 3个精准中标签 + 2个长尾小标签
- 完播率>互动率>点赞率——内容节奏比内容质量更重要
- 评论区是第二战场：主动引导评论，置顶引战评论

## 数据

所有数据本地存储，不连接抖音API。
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Commands

Run `douyin-creator help` to see all available commands.
