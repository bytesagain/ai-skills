#!/bin/bash
# douyin.sh — 抖音内容创作与运营助手
# 基于模板生成，不依赖外部API
set -euo pipefail

cmd="${1:-help}"
shift 2>/dev/null || true

case "$cmd" in

  idea)
    NICHE="${1:-通用}"
    python3 << PYEOF
import random
niche = "$NICHE"

formats = ["教程型", "故事型", "对比型", "反转型", "盘点型", "揭秘型", "挑战型", "日常型", "科普型", "测评型"]
angles = [
    "{n}行业内幕，从来没人敢说！",
    "3个{n}技巧，学会了直接起飞",
    "{n}新手最容易犯的5个错误",
    "为什么你的{n}总是做不好？原因在这",
    "{n}高手都在用的方法，一般人不知道",
    "花了3万块学{n}，总结出这些干货",
    "做{n}千万别这样！我踩过的坑",
    "{n}排行榜：TOP5最值得关注的",
    "如果你想做{n}，先看完这条视频",
    "一个视频讲清楚{n}的核心逻辑",
    "{n}的未来趋势，99%的人还不知道",
    "做{n}半年，我赚了多少钱？",
]

random.shuffle(formats)
random.shuffle(angles)

print("=" * 55)
print("  💡 视频创意 — {}赛道".format(niche))
print("=" * 55)
for i in range(min(10, len(angles))):
    fmt = formats[i % len(formats)]
    angle = angles[i].format(n=niche)
    print()
    print("  {} | [{}] {}".format(i+1, fmt, angle))

print()
print("  📌 建议：选2-3个创意，先拍完播率最高的那个类型")
PYEOF
    ;;

  hook)
    TOPIC="${1:?请输入主题}"
    python3 << PYEOF
import random
topic = "$TOPIC"
hooks = [
    ("悬念型", "你知道{}最大的秘密是什么吗？看完这条视频你就懂了".format(topic)),
    ("痛点型", "还在为{}发愁？90%的人都用错了方法".format(topic)),
    ("反转型", "所有人都说{}应该这样做，但其实完全相反！".format(topic)),
    ("数据型", "{}行业数据出来了，这个数字让所有人震惊".format(topic)),
    ("故事型", "我做{}三年，从月入3千到月入3万，就靠这一个方法".format(topic)),
    ("挑战型", "99%的人不知道{}的这个用法，你敢试试吗？".format(topic)),
    ("共鸣型", "如果你也在纠结{}的问题，这条视频一定要看完！".format(topic)),
    ("权威型", "做了8年{}，我发现大部分人第一步就错了".format(topic)),
]
random.shuffle(hooks)
print("=" * 55)
print("  🪝 开场钩子 — {}".format(topic))
print("  前3秒留人，决定完播率！")
print("=" * 55)
for i, (style, text) in enumerate(hooks[:5], 1):
    print()
    print("  {} | [{}]".format(i, style))
    print("    {}".format(text))
print()
print("  💡 技巧：前3秒语速要快，表情要夸张，直接抛出核心信息")
PYEOF
    ;;

  script)
    TOPIC="${1:?请输入主题}"
    DURATION="${2:-60}"
    python3 << PYEOF
import random
topic = "$TOPIC"
dur = int("$DURATION")

print("=" * 55)
print("  🎬 视频脚本 — {}".format(topic))
print("  时长: {}秒".format(dur))
print("=" * 55)

if dur <= 30:
    print("""
  ⏱️ 0-3秒 | 开场钩子
  "{t}你真的了解吗？99%的人都搞错了！"
  [镜头：怼脸特写，表情震惊]

  ⏱️ 3-15秒 | 核心内容
  "其实{t}的关键就三个字：XXX"
  "第一，......"
  "第二，......"
  [镜头：切换到演示/图文/实操画面]

  ⏱️ 15-25秒 | 价值升华
  "学会了这个方法，你的{t}直接起飞"
  [镜头：展示效果/前后对比]

  ⏱️ 25-30秒 | 引导互动
  "觉得有用的点个赞！关注我学更多{t}干货"
  [镜头：指向关注按钮]""".format(t=topic))
else:
    print("""
  ⏱️ 0-3秒 | 钩子（决定生死）
  "关于{t}，我要说一个可能颠覆你认知的事情"
  [画面：怼脸/走近镜头，表情认真]

  ⏱️ 3-10秒 | 建立信任
  "我研究{t}已经X年了，今天把最核心的干货分享给大家"
  [画面：展示相关场景/道具]

  ⏱️ 10-30秒 | 核心干货Part1
  "首先，{t}最重要的一点是......"
  "很多人以为......其实......"
  [画面：图文标注/演示操作]
  💡 每10秒要有一个"信息钩子"防止划走

  ⏱️ 30-45秒 | 核心干货Part2
  "第二个关键点......"
  "这里有个小技巧......"
  [画面：切换角度/加入B-roll]

  ⏱️ 45-55秒 | 总结升华
  "总结一下，{t}其实就是......"
  "掌握这几点，你就已经超过90%的人了"
  [画面：回到正脸，语气总结]

  ⏱️ 55-60秒 | CTA引导
  "想学更多{t}干货？关注我，下期更精彩！"
  "评论区告诉我你最想了解{t}的哪个方面"
  [画面：指向关注/评论区]""".format(t=topic))

print()
print("  📌 拍摄提示：")
print("  - 背景干净，光线充足")
print("  - 语速比正常快20%")
print("  - 每10秒切换一次画面角度")
print("  - 字幕必加，用醒目颜色标注关键词")
PYEOF
    ;;

  title)
    TOPIC="${1:?请输入主题}"
    python3 << PYEOF
import random
topic = "$TOPIC"
templates = [
    "{}，99%的人都不知道的秘密！",
    "做{}千万别踩这5个坑！",
    "{}小白逆袭指南，从0到精通",
    "为什么你的{}总是做不好？答案在这",
    "{}行业内幕，看完少走3年弯路",
    "3分钟学会{}核心技巧，学不会算我输",
    "{}排行榜TOP5，第一名居然是它！",
    "花了5万学{}，这些经验免费分享给你",
    "{}新手必看！别再交智商税了",
    "一个视频讲透{}，建议收藏反复看",
]
random.shuffle(templates)
print("=" * 55)
print("  🏷️ 爆款标题 — {}".format(topic))
print("=" * 55)
for i, t in enumerate(templates[:5], 1):
    print()
    print("  {} | {}".format(i, t.format(topic)))
print()
print("  📌 标题公式：数字+痛点+好奇心+情绪词")
PYEOF
    ;;

  tags)
    TOPIC="${1:?请输入主题}"
    python3 << PYEOF
topic = "$TOPIC"
print("=" * 55)
print("  # 标签推荐 — {}".format(topic))
print("=" * 55)
print()
print("  🔥 热门大标签（10w+内容）：")
print("    #{t} #干货分享 #涨知识".format(t=topic))
print()
print("  🎯 精准中标签（1w-10w内容）：")
print("    #{t}教程 #{t}入门 #{t}技巧".format(t=topic))
print()
print("  🔍 长尾小标签（<1w内容，易上热门）：")
print("    #{t}避坑 #{t}实操 #{t}干货分享".format(t=topic))
print()
print("  📌 策略：2大+3中+2小=7个标签最佳")
print("  📌 位置：标题里放1个核心标签，文案里放其余")
PYEOF
    ;;

  schedule)
    FREQ="${1:-5}"
    python3 << PYEOF
import random
freq = int("$FREQ")
days = ["周一","周二","周三","周四","周五","周六","周日"]
times = ["7:30","8:00","12:00","12:30","18:00","18:30","19:00","19:30","20:00","21:00","21:30","22:00"]
types = ["教程型","故事型","热点型","互动型","干货型","日常型","测评型"]

print("=" * 55)
print("  📅 每周发布计划（{}条/周）".format(freq))
print("=" * 55)

selected_days = days[:freq] if freq <= 7 else days
random.shuffle(types)
for i, day in enumerate(selected_days):
    time = random.choice(times)
    vtype = types[i % len(types)]
    print()
    print("  {} {}  [{}]".format(day, time, vtype))
    
print()
print("  📌 黄金时间段：")
print("    早高峰 7:00-9:00  | 通勤刷手机")
print("    午休   12:00-13:00 | 吃饭刷手机")
print("    晚高峰 18:00-20:00 | 下班刷手机")
print("    深夜   21:00-23:00 | 睡前刷手机")
print()
print("  📌 建议：固定时间发布，培养粉丝习惯")
PYEOF
    ;;

  comment)
    TOPIC="${1:?请输入视频主题}"
    python3 << PYEOF
import random
topic = "$TOPIC"
print("=" * 55)
print("  💬 评论区互动话术 — {}".format(topic))
print("=" * 55)

starters = [
    ("引战型（引发讨论）", [
        "你们觉得{}到底值不值得？评论区说说".format(topic),
        "关于{}，你是正方还是反方？".format(topic),
        "做{}遇到最大的坑是什么？来交流一下".format(topic),
    ]),
    ("互动型（提升评论量）", [
        "{}新手扣1，老手扣2，我根据比例出下期内容".format(topic),
        "你最想了解{}的哪个方面？评论区告诉我".format(topic),
        "猜猜{}最重要的一个技巧是什么？答对的私信送资料".format(topic),
    ]),
    ("置顶评论（自己发）", [
        "这条视频的核心就一句话：{}的关键在于......点赞这条评论的人我私信送完整资料".format(topic),
        "感谢大家支持！关于{}有任何问题都可以问我，看到必回！".format(topic),
    ]),
]

for category, comments in starters:
    print()
    print("  📌 {}：".format(category))
    for c in comments:
        print("    - {}".format(c))
PYEOF
    ;;

  persona)
    NICHE="${1:?请输入赛道}"
    python3 << PYEOF
import random
niche = "$NICHE"
print("=" * 55)
print("  🎭 账号人设定位 — {}赛道".format(niche))
print("=" * 55)

personas = [
    ("专业导师型", "xx年从业经验，手把手教你{}".format(niche), "权威感+信任感", "30-50岁职场人"),
    ("草根逆袭型", "从小白到大神，我的{}之路".format(niche), "亲和力+励志感", "18-35岁有上进心"),
    ("犀利点评型", "{}行业真相，敢说别人不敢说的".format(niche), "犀利+有态度", "25-45岁理性派"),
    ("可爱学姐型", "用最简单的方式讲{}".format(niche), "亲切+易懂", "18-30岁女性为主"),
    ("数据极客型", "用数据说话，{}深度分析".format(niche), "专业+严谨", "25-40岁数据控"),
]

for name, bio, vibe, audience in personas:
    print()
    print("  方案: {}".format(name))
    print("    简介: {}".format(bio))
    print("    风格: {}".format(vibe))
    print("    受众: {}".format(audience))

print()
print("  📌 定位原则：")
print("    1. 一个账号只做一个赛道")
print("    2. 人设要有辨识度（口头禅/开场白/穿着）")
print("    3. 前30条视频定风格，之后保持一致")
PYEOF
    ;;

  trending)
    python3 << 'PYEOF'
import random, datetime
today = datetime.date.today().strftime("%Y-%m-%d")
trends = [
    ("AI工具教程", "🔥🔥🔥🔥🔥", "AI应用爆发，工具实操类完播率高"),
    ("副业/搞钱", "🔥🔥🔥🔥🔥", "永恒刚需，变现路径清晰"),
    ("知识付费", "🔥🔥🔥🔥", "卖课/咨询/社群，高客单价"),
    ("健身/减脂", "🔥🔥🔥🔥", "春夏换季，减肥需求高峰"),
    ("穿搭/时尚", "🔥🔥🔥🔥", "换季内容，女性用户主力"),
    ("数码测评", "🔥🔥🔥🔥", "新品发布季，男性用户买单"),
    ("育儿教育", "🔥🔥🔥🔥", "家长焦虑=持续流量"),
    ("美食探店", "🔥🔥🔥", "本地生活赛道，带货能力强"),
    ("投资理财", "🔥🔥🔥🔥", "财经科普，粉丝价值高"),
    ("宠物日常", "🔥🔥🔥", "情绪价值赛道，涨粉快"),
]
print("=" * 55)
print("  📈 抖音热门赛道 ({})".format(today))
print("=" * 55)
for topic, heat, reason in trends:
    print()
    print("  {} {}".format(heat, topic))
    print("    {}".format(reason))
PYEOF
    ;;

  review)
    DATA="${1:?格式: 播放,点赞,评论,转发}"
    python3 << PYEOF
data = "$DATA".split(",")
if len(data) < 4:
    print("格式: review 播放,点赞,评论,转发")
    exit(1)
views = int(data[0])
likes = int(data[1])
comments = int(data[2])
shares = int(data[3])

like_rate = likes / max(views, 1) * 100
comment_rate = comments / max(views, 1) * 100
share_rate = shares / max(views, 1) * 100
engagement = (likes + comments + shares) / max(views, 1) * 100

print("=" * 55)
print("  📊 数据复盘")
print("=" * 55)
print()
print("  播放: {:,}  点赞: {:,}  评论: {:,}  转发: {:,}".format(views, likes, comments, shares))
print()
print("  点赞率: {:.1f}%  {}".format(like_rate, "✅ 优秀" if like_rate > 5 else "🟡 一般" if like_rate > 2 else "🔴 偏低"))
print("  评论率: {:.1f}%  {}".format(comment_rate, "✅ 优秀" if comment_rate > 1 else "🟡 一般" if comment_rate > 0.3 else "🔴 偏低"))
print("  转发率: {:.1f}%  {}".format(share_rate, "✅ 优秀" if share_rate > 1 else "🟡 一般" if share_rate > 0.3 else "🔴 偏低"))
print("  总互动: {:.1f}%  {}".format(engagement, "✅ 优秀" if engagement > 8 else "🟡 一般" if engagement > 3 else "🔴 需改进"))
print()

if like_rate < 2:
    print("  💡 点赞率低：内容共鸣不够，试试加入更多情绪价值")
if comment_rate < 0.3:
    print("  💡 评论率低：结尾缺少互动引导，加入提问/投票")
if share_rate < 0.3:
    print("  💡 转发率低：内容实用性不够，加入更多干货/教程")
if views < 500:
    print("  💡 播放低：标题/封面不够吸引，优化前3秒钩子")
PYEOF
    ;;

  hashtag)
    TOPIC="${1:?请输入主题}"
    export TOPIC
    python3 << 'PYEOF'
import os, random
topic = os.environ["TOPIC"]

print("=" * 58)
print("  #️⃣  话题标签策略 — {}".format(topic))
print("=" * 58)

big_tags = [
    "#{t}".format(t=topic),
    "#干货分享",
    "#涨知识",
    "#抖音教程",
    "#热门",
    "#推荐",
]
mid_tags = [
    "#{t}教程".format(t=topic),
    "#{t}技巧".format(t=topic),
    "#{t}入门".format(t=topic),
    "#{t}分享".format(t=topic),
    "#{t}攻略".format(t=topic),
    "#{t}学习".format(t=topic),
]
long_tail = [
    "#{t}避坑指南".format(t=topic),
    "#{t}实操干货".format(t=topic),
    "#{t}新手必看".format(t=topic),
    "#{t}零基础入门".format(t=topic),
    "#{t}从零到一".format(t=topic),
    "#{t}深度解析".format(t=topic),
    "#{t}行业内幕".format(t=topic),
]
random.shuffle(big_tags)
random.shuffle(mid_tags)
random.shuffle(long_tail)

print()
print("  🔥 大流量标签（100w+内容池，蹭曝光）：")
for t in big_tags[:4]:
    print("    {}".format(t))
print()
print("  🎯 精准标签（1w-100w，锁定目标用户）：")
for t in mid_tags[:4]:
    print("    {}".format(t))
print()
print("  🔍 长尾标签（<1w，竞争小易上热门）：")
for t in long_tail[:4]:
    print("    {}".format(t))
print()
print("  📋 推荐组合（复制即用）：")
combo = big_tags[:2] + mid_tags[:3] + long_tail[:2]
print("    " + " ".join(combo))
print()
print("  📌 标签使用策略：")
print("    1. 总数控制在5-8个，太多会被判垃圾")
print("    2. 标题里放1个核心大标签")
print("    3. 文案正文放精准+长尾标签")
print("    4. 评论区置顶追加2-3个热门标签")
print("    5. 蹭热点时加当日热搜话题标签")
print("    6. 定期换标签组合，避免被限流")
PYEOF
    ;;

  duet)
    TOPIC="${1:?请输入主题}"
    export TOPIC
    python3 << 'PYEOF'
import os, random
topic = os.environ["TOPIC"]

print("=" * 58)
print("  🤝 合拍/翻拍创意 — {}".format(topic))
print("  借势大号流量，快速起号！")
print("=" * 58)

ideas = [
    {
        "type": "正反对比合拍",
        "desc": "找一条关于{t}的热门视频，拍出完全相反的观点或效果".format(t=topic),
        "example": "原视频说「{t}要这样做」→ 你合拍说「其实恰恰相反，应该这样」".format(t=topic),
        "tip": "争议=流量，但注意尺度别引战过火",
    },
    {
        "type": "专业补充合拍",
        "desc": "找一条{t}的科普视频，在合拍中补充更专业的信息".format(t=topic),
        "example": "原视频讲了3个技巧 → 你合拍补充「他没说的第4个才是最重要的」",
        "tip": "展示专业度，容易被原作者翻牌互动",
    },
    {
        "type": "效果验证翻拍",
        "desc": "把热门{t}教程实际操作一遍，展示真实效果".format(t=topic),
        "example": "「照着百万播放的{t}教程做了一遍，结果竟然…」".format(t=topic),
        "tip": "不管成功还是翻车都有看点",
    },
    {
        "type": "不同角色翻拍",
        "desc": "用不同身份/年龄/性别的视角重新诠释{t}话题".format(t=topic),
        "example": "原视频：打工人版{t} → 你翻拍：老板视角的{t}".format(t=topic),
        "tip": "角色反差越大，趣味性越强",
    },
    {
        "type": "升级版翻拍",
        "desc": "把别人的基础版{t}内容，做一个高阶升级版".format(t=topic),
        "example": "原视频：{t}入门3步 → 你：{t}进阶版，高手都这样做".format(t=topic),
        "tip": "定位自己为进阶导师",
    },
    {
        "type": "地域版本翻拍",
        "desc": "把热门{t}内容本地化，加入地方特色".format(t=topic),
        "example": "原视频在上海做{t} → 你在成都做同样的内容，对比差异".format(t=topic),
        "tip": "本地化内容更容易进同城推荐",
    },
]

random.shuffle(ideas)
for i, idea in enumerate(ideas, 1):
    print()
    print("  创意{} | 【{}】".format(i, idea["type"]))
    print("    做法：{}".format(idea["desc"]))
    print("    示例：{}".format(idea["example"]))
    print("    技巧：{}".format(idea["tip"]))

print()
print("  📌 合拍/翻拍核心技巧：")
print("    1. 选择3天内的热门视频合拍，时效性很重要")
print("    2. 合拍时@原作者，增加互动概率")
print("    3. 翻拍不是抄袭，要有自己的差异化角度")
print("    4. 利用「合拍」功能时，左右分屏比例选3:7")
print("    5. 标题加上「合拍」「翻拍」标签蹭合拍流量池")
PYEOF
    ;;

  monetize)
    FANS="${1:?请输入粉丝量，如1000/1w/10w/50w/100w}"
    export FANS
    python3 << 'PYEOF'
import os, re
fans_str = os.environ["FANS"]

# Parse fan count
fans_str_lower = fans_str.lower().replace(",", "").replace(" ", "")
multiplier = 1
if "w" in fans_str_lower or "万" in fans_str_lower:
    multiplier = 10000
    fans_str_lower = fans_str_lower.replace("w", "").replace("万", "")
elif "k" in fans_str_lower or "千" in fans_str_lower:
    multiplier = 1000
    fans_str_lower = fans_str_lower.replace("k", "").replace("千", "")

try:
    fans = int(float(fans_str_lower) * multiplier)
except:
    fans = 10000

def fmt_fans(n):
    if n >= 10000:
        return "{:.1f}w".format(n / 10000)
    return str(n)

print("=" * 58)
print("  💰 变现路径分析 — {}粉丝".format(fmt_fans(fans)))
print("=" * 58)

paths = []

# 根据粉丝量推荐不同变现路径
if fans >= 1000:
    paths.append({
        "name": "🛒 橱窗带货",
        "threshold": "1000粉丝即可开通",
        "income": "佣金5%-50%不等",
        "difficulty": "⭐⭐",
        "desc": "开通商品橱窗，在视频/直播中挂商品链接。选品是关键，优先选佣金高、复购率高的品类。",
        "tips": [
            "优先选择与你内容相关的商品",
            "佣金率>20%的商品才值得带",
            "多拍「好物分享」「开箱测评」类内容",
            "利用精选联盟找高佣商品",
        ],
        "est_income": "月均{}~{}元".format(
            max(500, fans // 100),
            max(2000, fans // 20)
        ),
    })

if fans >= 10000:
    paths.append({
        "name": "⭐ 星图广告",
        "threshold": "1w粉丝可入驻巨量星图",
        "income": "单条视频广告费",
        "difficulty": "⭐⭐⭐",
        "desc": "品牌方通过星图平台找你做广告植入。粉丝越多、互动率越高，报价越高。",
        "tips": [
            "完善星图主页，展示数据亮点",
            "报价参考：粉丝数×0.03~0.1元/条",
            "保持内容垂直度，品牌更青睐垂类账号",
            "主动在星图接受任务积累口碑",
        ],
        "est_income": "单条广告{}~{}元".format(
            max(300, fans // 100),
            max(1000, fans // 10)
        ),
    })

if fans >= 5000:
    paths.append({
        "name": "🎙️ 直播变现",
        "threshold": "5000粉丝效果最佳",
        "income": "打赏+带货+连麦",
        "difficulty": "⭐⭐⭐⭐",
        "desc": "通过直播获取打赏收入和带货佣金。需要持续直播积累忠实粉丝。",
        "tips": [
            "固定直播时间，培养粉丝习惯",
            "直播前2小时发预热视频",
            "福袋+秒杀引流，提升在线人数",
            "直播时长>2小时，流量才能稳定",
        ],
        "est_income": "月均{}~{}元".format(
            max(1000, fans // 50),
            max(5000, fans // 10)
        ),
    })

paths.append({
    "name": "🔒 私域引流",
    "threshold": "任何粉丝量都可以做",
    "income": "微信/社群变现",
    "difficulty": "⭐⭐⭐",
    "desc": "通过抖音引流到微信私域，做高客单价的产品/服务变现。",
    "tips": [
        "个人简介留引流钩子（不要直接放微信号）",
        "用「私信领取资料」引导加微信",
        "私域做付费社群/一对一咨询/课程",
        "私域变现单价通常是抖音的5-10倍",
    ],
    "est_income": "取决于产品/服务定价",
})

if fans >= 50000:
    paths.append({
        "name": "📚 知识付费",
        "threshold": "5w+粉丝建议开始",
        "income": "课程/专栏/付费圈子",
        "difficulty": "⭐⭐⭐⭐⭐",
        "desc": "开设付费课程、专栏或知识付费圈子。需要强专业背景和粉丝信任度。",
        "tips": [
            "先免费分享80%干货建立信任",
            "课程定价99-999元覆盖最大人群",
            "用「学员案例」做社会证明",
            "抖音小程序+学浪平台都可以卖课",
        ],
        "est_income": "月均{}~{}元".format(
            max(5000, fans // 20),
            max(20000, fans // 5)
        ),
    })

for path in paths:
    print()
    print("  {}".format(path["name"]))
    print("    门槛：{}".format(path["threshold"]))
    print("    难度：{}".format(path["difficulty"]))
    print("    说明：{}".format(path["desc"]))
    print("    预估收入：{}".format(path["est_income"]))
    print("    实操建议：")
    for tip in path["tips"]:
        print("      • {}".format(tip))

print()
print("  📌 变现优先级建议（{}粉丝阶段）：".format(fmt_fans(fans)))
if fans < 5000:
    print("    1️⃣ 先专注涨粉，内容质量>变现")
    print("    2️⃣ 开始布局私域引流")
    print("    3️⃣ 1000粉后开通橱窗试水")
elif fans < 50000:
    print("    1️⃣ 橱窗带货 + 直播带货双管齐下")
    print("    2️⃣ 入驻星图接广告")
    print("    3️⃣ 持续私域引流，积累精准用户")
elif fans < 500000:
    print("    1️⃣ 星图广告为主，稳定收入")
    print("    2️⃣ 启动知识付费/课程")
    print("    3️⃣ 直播常态化，打造IP")
else:
    print("    1️⃣ IP矩阵化运营")
    print("    2️⃣ 自建品牌/供应链")
    print("    3️⃣ 多平台分发+MCN合作")
PYEOF
    ;;

  growth)
    FANS="${1:?请输入当前粉丝量，如500/1000/1w/10w}"
    NICHE="${2:-通用}"
    export FANS NICHE
    python3 << 'PYEOF'
import os, re

fans_str = os.environ.get("FANS", "0")
niche = os.environ.get("NICHE", "通用")

# Parse fan count
fs = fans_str.lower().replace(",", "").replace(" ", "")
multiplier = 1
if "w" in fs or "\u4e07" in fs:
    multiplier = 10000
    fs = fs.replace("w", "").replace("\u4e07", "")
elif "k" in fs or "\u5343" in fs:
    multiplier = 1000
    fs = fs.replace("k", "").replace("\u5343", "")
try:
    fans = int(float(fs) * multiplier)
except Exception:
    fans = 0

def fmt(n):
    if n >= 10000:
        return "{:.1f}w".format(n / 10000)
    return str(n)

print("=" * 58)
print("  \U0001f4c8 涨粉策略 \u2014 {}粉丝 | {}赛道".format(fmt(fans), niche))
print("=" * 58)

stages = [
    {
        "range": "0-1000粉",
        "min": 0, "max": 1000,
        "title": "\U0001f331 冷启动期：从0到1000粉",
        "goal": "建立基础流量池，找到内容方向",
        "strategy": [
            {
                "name": "\u2460 高频试错，找到爆款模型",
                "steps": [
                    "前30天至少发30条视频，日更或隔日更",
                    "尝试3-5种内容类型（教程/故事/测评/吐槽/分享）",
                    "记录每条视频数据，找出完播率>30%的类型",
                    "找到1-2个有效模型后，反复复制迭代",
                ],
            },
            {
                "name": "\u2461 蹭热点+借流量",
                "steps": [
                    "每天刷抖音30分钟，关注{}赛道热门话题".format(niche),
                    "热门BGM/话题/模板出来后24小时内跟拍",
                    "合拍大号视频，@对方增加互动概率",
                    "参加抖音官方活动和挑战赛（有流量扶持）",
                ],
            },
            {
                "name": "\u2462 评论区引流",
                "steps": [
                    "在{}赛道头部账号评论区发高质量评论".format(niche),
                    "评论要有观点、有干货，吸引人点进主页",
                    "每天评论20-30条，坚持一个月",
                    "避免广告感，真诚互动比硬推有效10倍",
                ],
            },
        ],
        "kpi": "日均涨粉30-50，月涨粉1000",
    },
    {
        "range": "1000-1万粉",
        "min": 1000, "max": 10000,
        "title": "\U0001f33f 成长期：从1K到1W粉",
        "goal": "稳定内容输出，建立粉丝认知",
        "strategy": [
            {
                "name": "\u2460 内容垂直化+系列化",
                "steps": [
                    "确定1个核心方向，所有视频围绕{}展开".format(niche),
                    "打造2-3个系列内容（如：{}避坑系列/{}入门系列）".format(niche, niche),
                    "固定开场白和结束语，建立辨识度",
                    "保持每周4-5条的更新频率",
                ],
            },
            {
                "name": "\u2461 互动运营提升粘性",
                "steps": [
                    "每条视频的评论必回（前2小时内）",
                    "直播1-2次/周，时长>1小时，和粉丝面对面",
                    "评论区引导话题讨论（提问/投票/PK）",
                    "建立粉丝群，发直播预告和独家内容",
                ],
            },
            {
                "name": "\u2462 开通橱窗+小变现",
                "steps": [
                    "1000粉即可开通橱窗，选{}相关商品".format(niche),
                    "每3条内容视频穿插1条带货视频",
                    "用「好物推荐」「工具测评」形式自然带货",
                    "收入不是目的，验证变现能力才是关键",
                ],
            },
        ],
        "kpi": "日均涨粉100-300，月涨粉3000-5000",
    },
    {
        "range": "1万-10万粉",
        "min": 10000, "max": 100000,
        "title": "\U0001f332 加速期：从1W到10W粉",
        "goal": "扩大影响力，建立个人IP",
        "strategy": [
            {
                "name": "\u2460 打造爆款公式",
                "steps": [
                    "分析过往数据，提炼出你的爆款三要素（主题+形式+钩子）",
                    "每周至少1条\"押宝视频\"（精心制作，冲爆款）",
                    "爆款视频发布后立即追投DOU+（100-500元测试）",
                    "拆解同赛道10w+点赞的视频，学习结构",
                ],
            },
            {
                "name": "\u2461 入驻星图+商业化",
                "steps": [
                    "入驻巨量星图，完善主页和数据展示",
                    "主动联系{}赛道的品牌方谈合作".format(niche),
                    "报价参考：粉丝数×0.03-0.1元/条",
                    "保持内容质量，广告视频<20%",
                ],
            },
            {
                "name": "\u2462 矩阵化+跨平台",
                "steps": [
                    "开设第二个账号，从不同角度切入{}赛道".format(niche),
                    "内容同步分发到快手/视频号/B站",
                    "利用私域（微信群/公众号）沉淀忠实粉丝",
                    "和同量级博主互推/连麦，交换粉丝",
                ],
            },
        ],
        "kpi": "日均涨粉500-2000，月涨粉1W-3W",
    },
    {
        "range": "10万+粉",
        "min": 100000, "max": 999999999,
        "title": "\U0001f3d4\ufe0f 突破期：10W+粉丝",
        "goal": "IP化运营，多元变现",
        "strategy": [
            {
                "name": "\u2460 IP人设强化",
                "steps": [
                    "提炼个人标签：你={}领域的______".format(niche),
                    "出金句/口头禅，让粉丝记住你",
                    "跨领域联名合作，破圈获取新用户",
                    "出席线下活动/行业峰会，增加权威感",
                ],
            },
            {
                "name": "\u2461 多元变现体系",
                "steps": [
                    "知识付费：推出{}领域课程/训练营".format(niche),
                    "自有品牌：开发联名/自有产品",
                    "直播常态化：每周3+次，打造直播间人气",
                    "MCN合作或自建团队，规模化运营",
                ],
            },
            {
                "name": "\u2462 内容升级+长尾",
                "steps": [
                    "制作高质量长视频（3-10分钟），沉淀到主页",
                    "打造年度系列内容IP（固定栏目名+周期）",
                    "关注行业趋势，做第一个吃螃蟹的人",
                    "保持初心：粉丝增长<内容质量<用户价值",
                ],
            },
        ],
        "kpi": "日均涨粉2000+，月涨粉5W+",
    },
]

# 找到当前阶段
current_idx = 0
for i, s in enumerate(stages):
    if s["min"] <= fans < s["max"]:
        current_idx = i
        break
else:
    current_idx = len(stages) - 1

# 显示当前阶段（重点）和下一阶段（展望）
show_stages = [current_idx]
if current_idx + 1 < len(stages):
    show_stages.append(current_idx + 1)

for idx in show_stages:
    s = stages[idx]
    is_current = (idx == current_idx)
    marker = "\u2b50 \u5f53\u524d\u9636\u6bb5" if is_current else "\U0001f449 \u4e0b\u4e00\u9636\u6bb5"
    print("")
    print("  {} {}".format(marker, s["title"]))
    print("  " + "\u2501" * 50)
    print("  \U0001f3af \u76ee\u6807\uff1a{}".format(s["goal"]))
    print("")
    for strat in s["strategy"]:
        print("  {}".format(strat["name"]))
        for step in strat["steps"]:
            print("    \u2022 {}".format(step))
        print("")
    print("  \U0001f4ca KPI\u53c2\u8003\uff1a{}".format(s["kpi"]))
    print("")

print("  " + "\u2500" * 50)
print("")
print("  \U0001f4cc \u6da8\u7c89\u6838\u5fc3\u516c\u5f0f\uff1a")
print("    \u6da8\u7c89\u901f\u5ea6 = \u5185\u5bb9\u8d28\u91cf \u00d7 \u66f4\u65b0\u9891\u7387 \u00d7 \u4e92\u52a8\u8fd0\u8425 \u00d7 \u7b97\u6cd5\u5229\u7528")
print("")
print("  \u26a0\ufe0f \u6da8\u7c89\u5927\u5fcc\uff1a")
print("    1. \u4e0d\u8981\u4e70\u7c89\uff01\u5047\u7c89\u62c9\u4f4e\u8d26\u53f7\u6743\u91cd\uff0c\u8d8a\u4e70\u8d8a\u6b7b")
print("    2. \u4e0d\u8981\u4e09\u5929\u6253\u9c7c\u4e24\u5929\u6652\u7f51\uff0c\u7b97\u6cd5\u559c\u6b22\u7a33\u5b9a\u8f93\u51fa")
print("    3. \u4e0d\u8981\u8d2a\u591a\u8d5b\u9053\uff0c\u5148\u6253\u7a7f\u4e00\u4e2a\u518d\u6269\u5c55")
print("    4. \u4e0d\u8981\u53ea\u770b\u7c89\u4e1d\u6570\uff0c\u5173\u6ce8\u4e92\u52a8\u7387\u548c\u53d8\u73b0\u80fd\u529b")
PYEOF
    ;;

  help|*)
    echo "🎬 抖音创作助手"
    echo ""
    echo "Usage: douyin.sh <command> [args]"
    echo ""
    echo "Commands:"
    echo "  idea \"赛道\"              生成10个视频创意"
    echo "  hook \"主题\"              5个开场钩子（前3秒留人）"
    echo "  script \"主题\" [30|60]    完整视频脚本"
    echo "  title \"主题\"             5个爆款标题"
    echo "  tags \"主题\"              标签推荐（SEO优化）"
    echo "  hashtag \"主题\"           话题标签策略（大流量+精准+长尾）"
    echo "  duet \"主题\"              合拍/翻拍创意（借流量）"
    echo "  monetize \"粉丝量\"        变现路径分析"
    echo "  growth \"粉丝量\" \"赛道\"   涨粉策略（分阶段+具体步骤）"
    echo "  schedule [3|5|7]         每周发布计划"
    echo "  comment \"视频主题\"       评论区互动话术"
    echo "  persona \"赛道\"           账号人设定位建议"
    echo "  trending                 热门赛道"
    echo "  review \"播放,赞,评,转\"   数据复盘建议"
    echo "  help                     显示帮助"
    ;;
esac

echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
