#!/usr/bin/env bash
# bytesagain-video-script-creator — Video script generator
set -euo pipefail

CMD="${1:-help}"
shift || true

show_help() {
    echo "bytesagain-video-script-creator — Generate video scripts for any platform"
    echo ""
    echo "Usage:"
    echo "  bytesagain-video-script-creator youtube <topic> <duration_min>"
    echo "  bytesagain-video-script-creator tiktok <topic>"
    echo "  bytesagain-video-script-creator douyin <topic>"
    echo "  bytesagain-video-script-creator bilibili <topic> <duration_min>"
    echo "  bytesagain-video-script-creator hooks <topic>"
    echo "  bytesagain-video-script-creator outline <topic> <sections>"
    echo ""
}

cmd_youtube() {
    local topic="${1:-Your Topic}"; local mins="${2:-10}"
    SC_TOPIC="$topic" SC_MINS="$mins" python3 << 'PYEOF'
import os; topic = os.environ.get("SC_TOPIC","Your Topic")
mins = int(os.environ.get("SC_MINS","10"))
words = mins * 130  # avg speaking speed

print(f"""
=== YouTube Script: {topic} ===
Platform: YouTube | Duration: ~{mins} min (~{words} words)

[HOOK - 0:00-0:30]
Are you struggling with {topic}? In the next {mins} minutes, I'll show you exactly
how to master it. Stay till the end for the #1 tip most people miss.

[INTRO - 0:30-1:00]
What's up everyone, welcome back to the channel! Today we're diving deep into
{topic}. If you're new here, hit subscribe — we post weekly guides just like this.

[SECTION 1 - 1:00-{mins//3}:00]
TITLE: Why {topic} matters
- Key point 1: The foundation you need to understand
- Key point 2: Common mistakes to avoid
- Key point 3: What the experts do differently

[B-ROLL NOTE]: Show screen recording / demo here

[SECTION 2 - {mins//3}:00-{mins*2//3}:00]
TITLE: Step-by-step breakdown
- Step 1: Start with the basics (show example)
- Step 2: Build on the foundation (hands-on demo)
- Step 3: Advanced technique (the secret sauce)

[SECTION 3 - {mins*2//3}:00-{mins-1}:00]
TITLE: Real-world application
- Case study: How someone used this to get results
- Common pitfalls and how to avoid them
- Pro tips to accelerate your progress

[CTA - {mins-1}:00-{mins}:00]
That's everything you need to know about {topic}! If this helped you,
smash that like button and share with someone who needs this.
Comment below: what's YOUR biggest challenge with {topic}?
See you in the next one!

[END SCREEN - Cards + Subscribe animation]
""")
PYEOF
}

cmd_tiktok() {
    local topic="${1:-Your Topic}"
    SC_TOPIC="$topic" SC_MINS="$mins" python3 << 'PYEOF'
import os; topic = os.environ.get("SC_TOPIC","Your Topic")
print(f"""
=== TikTok Script: {topic} ===
Platform: TikTok | Duration: 30-60 sec | Format: Vertical 9:16

[0-3s HOOK - Critical!]
Visual: Close-up, bold text overlay
Script: "Stop doing {topic} wrong! Here's what nobody tells you 👇"

[3-8s PROBLEM]
Visual: Show the wrong way
Script: "Most people think {topic} means [common misconception].
That's why they're not getting results."

[8-25s SOLUTION]
Visual: Step-by-step demo
Script:
"Here's the RIGHT way:"
"Step 1 — [First key action]"
"Step 2 — [Second key action]"  
"Step 3 — [The surprising twist]"

[25-35s PROOF/RESULT]
Visual: Before/After or result screenshot
Script: "When I started doing this, [specific result].
You can do this in [timeframe]."

[35-45s CTA]
Visual: Point to camera, text overlay
Script: "Follow for more {topic} tips!
Comment 'YES' if you want my full guide 👇"

[HASHTAGS]
#{topic.replace(' ','')} #tips #howto #tutorial #fyp #viral

[SOUND]: Use trending audio from Creative Hub
""")
PYEOF
}

cmd_douyin() {
    local topic="${1:-主题}"
    SC_TOPIC="$topic" SC_MINS="$mins" python3 << 'PYEOF'
import os; topic = os.environ.get("SC_TOPIC","Your Topic")
print(f"""
=== 抖音脚本: {topic} ===
平台: 抖音 | 时长: 30-60秒 | 格式: 竖屏9:16

【0-3秒 黄金钩子】
画面: 特写镜头 + 大字幕
台词: "{topic}居然还能这样做？90%的人都不知道⬇️"

【3-10秒 痛点引入】
画面: 展示常见错误场景
台词: "你是不是也遇到过这种情况？
[具体痛点描述]，太让人崩溃了！"

【10-40秒 干货核心】
画面: 真实演示 + 字幕关键词
台词:
"教你3个绝招："
"第1招 — [具体方法，简单直接]"
"第2招 — [进阶技巧，反直觉]"
"第3招 — [最强杀手锏]"

【40-50秒 效果展示】
画面: 前后对比 / 数据结果
台词: "用了这个方法之后，[具体结果]！
真的太爽了！"

【50-60秒 引导互动】
画面: 镜头怼脸 + 贴纸动效
台词: "关注我，每天分享{topic}干货！
点个赞让更多人看到👍"

【话题标签】
#{topic} #干货分享 #涨知识 #新手必看
""")
PYEOF
}

cmd_bilibili() {
    local topic="${1:-Your Topic}"; local mins="${2:-15}"
    SC_TOPIC="$topic" SC_MINS="$mins" python3 << 'PYEOF'
import os; topic = os.environ.get("SC_TOPIC","Your Topic")
mins = int(os.environ.get("SC_MINS","10"))
print(f"""
=== B站脚本: {topic} ===
平台: Bilibili | 时长: ~{mins}分钟 | 格式: 横屏16:9

[封面文案]: "{topic}终极指南 | {mins}分钟学会"

[片头 0:00-0:30]
BGM: 节奏感强的背景音乐
内容: 频道Logo动画 + 本期预告
台词: "大家好，我是[UP主名]！
今天{mins}分钟带你彻底搞懂{topic}。
视频分三部分：[Part1] / [Part2] / [Part3]
建议三连收藏！"

[第一部分 基础概念 {mins//3}分钟]
- 什么是{topic}（配图解说）
- 为什么重要（数据/案例支撑）
- 常见误区（弹幕互动：你中了几个？）

[第二部分 实操演示 {mins//3}分钟]
- 环境准备 / 工具介绍
- Step by Step演示
- 踩坑记录（增加真实感）

[第三部分 进阶技巧 {mins//3}分钟]
- 高手才知道的技巧
- 资源推荐
- 观众问题解答

[片尾 最后30秒]
台词: "好了，以上就是今天关于{topic}的全部内容！
觉得有用的话，一键三连支持一下！
有问题在评论区留言，我会一一回复~
我们下期见！"

[结尾卡片]: 推荐相关视频 + 订阅按钮
""")
PYEOF
}

cmd_hooks() {
    local topic="${1:-Your Topic}"
    SC_TOPIC="$topic" SC_MINS="$mins" python3 << 'PYEOF'
import os; topic = os.environ.get("SC_TOPIC","Your Topic")
hooks = [
    f"I wasted 3 years on {topic} before learning THIS.",
    f"Nobody talks about the dark side of {topic}.",
    f"The {topic} mistake that's costing you [result].",
    f"I tried {topic} for 30 days. Here's what happened.",
    f"Why everything you know about {topic} is wrong.",
    f"The {topic} trick that experts don't want you to know.",
    f"Stop doing {topic} until you watch this.",
    f"How I went from beginner to pro at {topic} in [timeframe].",
    f"The {topic} method that changed everything for me.",
    f"This one {topic} tip will save you [time/money].",
    f"I asked 100 {topic} experts. They all said the same thing.",
    f"The uncomfortable truth about {topic} nobody says out loud.",
]
print(f"\n=== 12 Hook Ideas for: {topic} ===\n")
for i, h in enumerate(hooks, 1):
    print(f"  {i:2}. {h}")
print(f"\n💡 Tip: Pair each hook with a strong visual or stat for maximum impact")
PYEOF
}

cmd_outline() {
    local topic="${1:-Your Topic}"; local sections="${2:-5}"
    SC_TOPIC="$topic" SC_MINS="$mins" python3 << 'PYEOF'
import os; topic = os.environ.get("SC_TOPIC","Your Topic")
n = int("$sections")
structures = {
    3: ["Introduction & Hook", "Main Content & Demo", "Summary & CTA"],
    4: ["Hook & Problem", "Solution Overview", "Step-by-Step Demo", "Results & CTA"],
    5: ["Hook (0-30s)", "Problem Setup", "Solution Part 1", "Solution Part 2 + Demo", "Results & CTA"],
    6: ["Hook", "Context & Why It Matters", "Part 1: Foundation", "Part 2: Application", "Advanced Tips", "CTA & Recap"],
}
default = [f"Section {i}: [Content]" for i in range(1, n+1)]
outline = structures.get(n, default)
print(f"\n=== Video Outline: {topic} ({n} sections) ===\n")
for i, section in enumerate(outline, 1):
    print(f"  {i}. {section}")
print(f"\n  Estimated time per section: ~{10//n} minutes")
print(f"  Total: ~10 minutes for standard YouTube format")
PYEOF
}

case "$CMD" in
    youtube)  cmd_youtube "$@" ;;
    tiktok)   cmd_tiktok "$@" ;;
    douyin)   cmd_douyin "$@" ;;
    bilibili) cmd_bilibili "$@" ;;
    hooks)    cmd_hooks "$@" ;;
    outline)  cmd_outline "$@" ;;
    help|--help|-h) show_help ;;
    *) echo "Unknown: $CMD"; show_help; exit 1 ;;
esac
