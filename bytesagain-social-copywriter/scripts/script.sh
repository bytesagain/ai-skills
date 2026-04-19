#!/usr/bin/env bash
# bytesagain-social-copywriter — Social media copy generator
set -euo pipefail

CMD="${1:-help}"
shift || true

show_help() {
    echo "bytesagain-social-copywriter — Generate platform-optimized social media copy"
    echo ""
    echo "Usage:"
    echo "  bytesagain-social-copywriter twitter <topic> [tone]"
    echo "  bytesagain-social-copywriter linkedin <topic> [type]"
    echo "  bytesagain-social-copywriter instagram <topic>"
    echo "  bytesagain-social-copywriter weibo <topic>"
    echo "  bytesagain-social-copywriter hashtags <topic> <platform>"
    echo "  bytesagain-social-copywriter ab <topic> <platform>"
    echo ""
    echo "Tones: professional casual funny inspiring urgent"
    echo ""
}

cmd_twitter() {
    local topic="${1:-topic}"; local tone="${2:-professional}"
    SC_TOPIC="$topic" SC_TONE="${tone:-professional}" SC_TYPE="${ltype:-insight}" SC_PLATFORM="${platform:-twitter}" python3 << 'PYEOF'
import os; topic = os.environ.get("SC_TOPIC",""); tone = os.environ.get("SC_TONE","professional")
variants = {
    "professional": [
        f"Thread: Everything you need to know about {topic} 🧵\n\n1/ The fundamentals most people skip...",
        f"Hot take on {topic}: The conventional wisdom is wrong.\n\nHere's what actually works:",
        f"After years working with {topic}, here's my honest take:\n\n[Your insight here]\n\nWhat's your experience?",
    ],
    "casual": [
        f"okay so I've been obsessing over {topic} and I need to share 👇",
        f"can we talk about {topic} for a sec because THIS 👇",
        f"nobody talks about this part of {topic} and it's driving me crazy",
    ],
    "funny": [
        f"me trying to explain {topic} to my non-tech friends vs what they hear:",
        f"{topic} be like: *works perfectly in theory*\n\nAlso {topic}:",
        f"POV: You just discovered {topic} exists\n\n[reaction image]",
    ],
    "inspiring": [
        f"One year ago I knew nothing about {topic}.\n\nToday: [result]\n\nHere's exactly how:",
        f"The best time to start learning {topic} was yesterday.\nThe second best time is now.",
        f"Stop waiting until you're ready to learn {topic}.\nReady comes AFTER you start.",
    ],
    "urgent": [
        f"⚠️ If you're ignoring {topic} right now, read this.",
        f"This {topic} trend is happening whether you're ready or not.",
        f"Your competitors are already using {topic}. Are you?",
    ],
}
tones = variants.get(tone, variants["professional"])
print(f"\n=== Twitter/X Copy: {topic} [{tone}] ===")
print(f"Character limit: 280 | Recommended: 150-220 for engagement\n")
for i, v in enumerate(tones, 1):
    print(f"Version {i} ({len(v)} chars):")
    print(f"  {v}")
    print()
PYEOF
}

cmd_linkedin() {
    local topic="${1:-topic}"; local ltype="${2:-insight}"
    SC_TOPIC="$topic" SC_TONE="${tone:-professional}" SC_TYPE="${ltype:-insight}" SC_PLATFORM="${platform:-twitter}" python3 << 'PYEOF'
import os; topic = os.environ.get("SC_TOPIC",""); ltype = os.environ.get("SC_TYPE","insight")
print(f"""
=== LinkedIn Post: {topic} [{ltype}] ===
Optimal length: 1,200-1,500 characters | No link in first comment

--- HOOK LINE (make them click 'see more') ---
I made a big mistake with {topic}. Here's what I learned:

--- BODY (3-5 short paragraphs) ---
[Short paragraph 1 — the situation/problem]
I used to think {topic} was about [common misconception].

[Short paragraph 2 — the turning point]
Then I discovered [key insight]. Everything changed.

[Short paragraph 3 — the lesson]
Here's what actually works:
→ Point 1: [Specific, actionable]
→ Point 2: [Contrarian or surprising]
→ Point 3: [The one thing]

[Short paragraph 4 — broader implication]
This applies beyond just {topic}. It's really about [bigger principle].

--- ENGAGEMENT LINE ---
What's your experience with {topic}?
Drop your take in the comments 👇

--- HASHTAGS (first comment or end of post) ---
#{topic.replace(' ','')} #ProfessionalDevelopment #CareerGrowth

--- FORMAT TIPS ---
• Use line breaks aggressively (LinkedIn rewards them)
• Bold key words with *asterisks* (renders in some clients)
• Post at 8-10am or 5-6pm in your audience's timezone
• Reply to every comment in first 2 hours
""")
PYEOF
}

cmd_instagram() {
    local topic="${1:-topic}"
    SC_TOPIC="$topic" SC_TONE="${tone:-professional}" SC_TYPE="${ltype:-insight}" SC_PLATFORM="${platform:-twitter}" python3 << 'PYEOF'
import os; topic = os.environ.get("SC_TOPIC","")
print(f"""
=== Instagram Caption: {topic} ===
Max: 2,200 chars | First 125 chars shown before 'more'

--- CAPTION HOOK (first 125 chars — crucial!) ---
The {topic} mistake I see every day 👇 (save this!)

--- BODY ---
It happens all the time.

Someone asks about {topic}, and gets completely overwhelmed.

The truth? It's actually simple once you know these 3 things:

✅ 1. [First key point — short and punchy]

✅ 2. [Second key point — actionable]

✅ 3. [Third key point — the most important one]

The biggest mistake? [Common error].

Instead, try [better approach].

Which of these resonates most with you? Tell me below! 👇

--- HASHTAG BLOCK (add as comment or end of caption) ---
#{topic.replace(' ','')} #{topic.split()[0] if ' ' in topic else topic}tips
#learnon{topic.split()[0].lower() if ' ' in topic else topic.lower()}
#instagramlearning #dailytips #contentcreator
#growthmindset #entrepreneur #smallbusiness
[Add 5-10 more niche hashtags for your industry]

--- STORY COMPANION ---
Slide 1: Bold text — "{topic}?"
Slide 2: "Here's what nobody tells you..."
Slide 3: Tip 1 (one line, big font)
Slide 4: Tip 2
Slide 5: Tip 3
Slide 6: "Save this for later! ❤️"
""")
PYEOF
}

cmd_weibo() {
    local topic="${1:-话题}"
    SC_TOPIC="$topic" SC_TONE="${tone:-professional}" SC_TYPE="${ltype:-insight}" SC_PLATFORM="${platform:-twitter}" python3 << 'PYEOF'
import os; topic = os.environ.get("SC_TOPIC","")
print(f"""
=== 微博文案: {topic} ===
字数限制: 2000字 | 黄金前140字决定展开率

【钩子文案 (前140字)】
真的！关于{topic}，这条微博可能是你今年看到最实用的干货！

【正文】
很多人对{topic}有误解，以为[常见误区]。

但其实——

✅ 第一点：[具体干货，50字内]

✅ 第二点：[进阶技巧，反直觉的]

✅ 第三点：[最重要的，很多人忽略]

用好这3点，[预期结果]。

你们在{topic}上最大的困惑是什么？评论区聊聊👇

【话题标签】
#{topic}# #干货分享# #知识分享# #每日学习#

【发布技巧】
• 工作日早9点、午12点、晚8点发布效果最好
• 带图片/视频的微博比纯文字互动率高3倍
• 蹭热门话题时前3小时内发布
• 转发+评论比单纯点赞权重高

【互动引导】
• 结尾提问：引导评论
• "转发+关注"：增加传播
• 设置投票：提升停留时长
""")
PYEOF
}

cmd_hashtags() {
    local topic="${1:-topic}"; local platform="${2:-instagram}"
    SC_TOPIC="$topic" SC_TONE="${tone:-professional}" SC_TYPE="${ltype:-insight}" SC_PLATFORM="${platform:-twitter}" python3 << 'PYEOF'
import re
import os; topic = os.environ.get("SC_TOPIC",""); platform = os.environ.get("SC_PLATFORM","twitter")
slug = re.sub(r'[^a-z0-9]', '', topic.lower())

platform_strategies = {
    "instagram": f"""
Instagram Hashtag Strategy: {topic}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Optimal: 5-10 hashtags (algorithm sweet spot in 2024)

Mega (1M+):  #{slug} #tips #howto #tutorial #learn
Large (100K-1M): #{slug}tips #{slug}hack #master{slug}
Medium (10K-100K): #{slug}community #{slug}advice #daily{slug}
Niche (<10K): #{slug}beginner #{slug}expert #learn{slug}today

Strategy: Mix 2 mega + 3 large + 3 medium + 2 niche
Place in caption (not comments — algorithm prefers it)
""",
    "twitter": f"""
Twitter/X Hashtag Strategy: {topic}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Optimal: 1-2 hashtags maximum

Primary: #{slug}
Secondary (if trending): Check trending tab before posting
Format: Inline in text, not at end
Example: "The truth about #{slug} nobody talks about..."

Avoid: More than 2 hashtags (reduces engagement 17%)
""",
    "linkedin": f"""
LinkedIn Hashtag Strategy: {topic}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Optimal: 3-5 hashtags

#{slug} #Leadership #ProfessionalDevelopment
#CareerGrowth #BusinessStrategy

Place at end of post, not inline
Follow your own hashtags to see trending content
""",
}
print(platform_strategies.get(platform, platform_strategies["instagram"]))
PYEOF
}

cmd_ab() {
    local topic="${1:-topic}"; local platform="${2:-twitter}"
    SC_TOPIC="$topic" SC_TONE="${tone:-professional}" SC_TYPE="${ltype:-insight}" SC_PLATFORM="${platform:-twitter}" python3 << 'PYEOF'
import os; topic = os.environ.get("SC_TOPIC",""); platform = os.environ.get("SC_PLATFORM","twitter")
print(f"""
=== A/B Test Variations: {topic} on {platform.title()} ===

VERSION A — Question Hook:
"What's the #1 mistake people make with {topic}?
(Most get this completely wrong)"

VERSION B — Statement Hook:
"I stopped doing {topic} the traditional way.
Here's what actually works:"

VERSION C — Data Hook:
"87% of people do {topic} wrong.
Here are the 3 signs you're in the other 13%:"

VERSION D — Story Hook:
"Last year I failed at {topic}.
This year it's my biggest strength.
What changed:"

VERSION E — Contrarian Hook:
"Unpopular opinion: {topic} is overrated.
Here's what to do instead:"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TEST GUIDE:
• Post A/B with 48-hour gap (same time of day)
• Measure: engagement rate (not just likes)
• Winner: highest comments + shares = distribution
• Run with 5 posts each before declaring winner
""")
PYEOF
}

case "$CMD" in
    twitter)   cmd_twitter "$@" ;;
    linkedin)  cmd_linkedin "$@" ;;
    instagram) cmd_instagram "$@" ;;
    weibo)     cmd_weibo "$@" ;;
    hashtags)  cmd_hashtags "$@" ;;
    ab)        cmd_ab "$@" ;;
    help|--help|-h) show_help ;;
    *) echo "Unknown: $CMD"; show_help; exit 1 ;;
esac
