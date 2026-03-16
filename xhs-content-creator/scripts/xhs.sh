#!/bin/bash
# xhs.sh — 小红书爆款笔记内容生成器
# 模板+随机组合，不依赖外部API
set -euo pipefail

cmd="${1:-help}"
shift 2>/dev/null || true

case "$cmd" in

  note)
    TOPIC="${1:?请输入主题}"
    python3 << PYEOF
import random, datetime
topic = "$TOPIC"

emojis = ["✨","🔥","💯","❤️","🌟","💕","👀","🎉","😍","🤩","💪","🎯","📢","🏆","💡","🌈","☀️","🍀","💎","👏"]
hooks = [
    "姐妹们！这个{}真的绝了！",
    "天花板级别的{}，不允许你们不知道！",
    "后悔没早点发现的{}攻略！",
    "被问了800遍的{}，今天统一回复！",
    "{}踩坑3年总结出来的经验！",
    "看完这篇{}，少走99%的弯路！",
    "我敢说这是全网最全的{}指南！",
    "{}新手必看！手把手教你入门！",
]
closings = [
    "觉得有用的话记得点赞收藏哦～下次找不到就亏了！",
    "姐妹们有什么问题评论区见！看到都会回的～",
    "关注我，每天分享更多{}干货！".format(topic),
    "你们还想看什么内容？评论区告诉我！",
    "先码住！以后一定用得上！",
]
titles = [
    "{e} {n}个{t}技巧，学会了直接起飞！",
    "{e} 全网最全{t}攻略｜新手小白必看",
    "{e} 后悔没早知道的{t}方法！太实用了",
    "{e} {t}避坑指南｜这些雷千万别踩",
    "{e} 姐妹们！{t}就该这么搞！亲测有效",
]

# Generate title
e = random.choice(emojis)
n = random.choice([3,5,6,7,8,10])
title = random.choice(titles).format(e=e, t=topic, n=n)

# Generate body
body_sections = [
    random.choice(hooks).format(topic),
    "",
    "{} 为什么要了解{}？".format(random.choice(emojis), topic),
    "很多姐妹都在问{}到底怎么搞，今天楼主把压箱底的经验全分享出来！".format(topic),
    "",
    "{} 干货来了！".format(random.choice(emojis)),
    "",
]

tips = [
    "第一步：做好功课，先了解基本概念，别上来就冲！",
    "第二步：多看多对比，不要只听一家之言",
    "第三步：从小处开始，别一上来就梭哈",
    "第四步：记录过程，总结经验，持续优化",
    "第五步：找到靠谱的社群和前辈，少走弯路",
]
for i, tip in enumerate(tips):
    body_sections.append("{} {}".format(random.choice(emojis), tip))

body_sections.extend([
    "",
    "{} 最后提醒：".format(random.choice(emojis)),
    "以上就是关于{}的全部心得！".format(topic),
    random.choice(closings),
])

# Tags
base_tags = [topic, "干货分享", "经验分享", "新手必看", "避坑指南", "涨知识", "收藏备用", "好物推荐"]
random.shuffle(base_tags)
tags = " ".join(["#" + t for t in base_tags[:8]])

print("=" * 50)
print("{} 小红书笔记".format(random.choice(emojis)))
print("=" * 50)
print()
print("【标题】")
print(title)
print()
print("【正文】")
print("\n".join(body_sections))
print()
print("【标签】")
print(tags)
print()
print("【发布建议】")
print("- 最佳发布时间: 12:00-13:00 / 18:00-20:00 / 21:00-22:00")
print("- 封面: 用醒目大字+对比色背景")
print("- 首图文字: 建议用'{}'相关关键词".format(topic))
PYEOF
    ;;

  title)
    TOPIC="${1:?请输入主题}"
    python3 << PYEOF
import random
topic = "$TOPIC"
emojis = ["✨","🔥","💯","❤️","🌟","💕","👀","🎉","😍","🤩","💪","🎯","💡","🌈","💎"]
templates = [
    "{e} {n}个{t}技巧，学会了直接起飞！",
    "{e} 全网最全{t}攻略｜新手小白必看",
    "{e} 后悔没早知道的{t}方法！太实用了",
    "{e} {t}避坑指南｜这些雷千万别踩",
    "{e} 姐妹们！{t}就该这么搞！亲测有效",
    "{e} {t}天花板！用过的都说好",
    "{e} 拒绝踩坑！{t}保姆级教程来了",
    "{e} 别再乱搞{t}了！正确方式在这里",
    "{e} 我的{t}心得｜从入门到精通",
    "{e} {t}红黑榜｜良心推荐vs智商税",
]
random.shuffle(templates)
print("=" * 50)
print("🏷️  标题生成 — {}".format(topic))
print("=" * 50)
for i, t in enumerate(templates[:5], 1):
    e = random.choice(emojis)
    n = random.choice([3,5,6,7,8,10])
    print()
    print("  {} | {}".format(i, t.format(e=e, t=topic, n=n)))
PYEOF
    ;;

  tags)
    TOPIC="${1:?请输入主题}"
    python3 << PYEOF
import random
topic = "$TOPIC"
generic = ["干货分享","经验分享","新手必看","避坑指南","涨知识","收藏备用","好物推荐","宝藏分享","自我提升","生活方式","每日分享","实用技巧"]
random.shuffle(generic)
print("=" * 50)
print("🏷️  标签推荐 — {}".format(topic))
print("=" * 50)
print()
print("  核心标签: #{} #{}攻略 #{}推荐".format(topic, topic, topic))
print()
print("  流量标签: {}".format(" ".join(["#"+t for t in generic[:5]])))
print()
print("  长尾标签: #{t}怎么选 #{t}入门 #{t}教程 #{t}测评".format(t=topic))
print()
print("  建议: 选5-8个标签，核心+流量混搭效果最佳")
PYEOF
    ;;

  hook)
    TOPIC="${1:?请输入主题}"
    python3 << PYEOF
import random
topic = "$TOPIC"
hooks = [
    "姐妹们！这个{}真的绝了！用过的都回来感谢我了".format(topic),
    "天哪！我居然现在才发现{}的正确打开方式！".format(topic),
    "被问了800遍的{}，今天统一回复！建议收藏！".format(topic),
    "{}踩坑3年，花了上万块总结出来的血泪经验…".format(topic),
    "救命！这个{}方法也太好用了吧？！怎么没人早告诉我！".format(topic),
    "不懂{}的姐妹看过来！5分钟让你从小白变大神！".format(topic),
    "全网都在推的{}，到底值不值得？我帮你们试过了！".format(topic),
    "看完这篇{}攻略，少走99%的弯路！先码后看！".format(topic),
]
random.shuffle(hooks)
print("=" * 50)
print("🪝  开头钩子 — {}".format(topic))
print("=" * 50)
for i, h in enumerate(hooks[:5], 1):
    print()
    print("  {} | {}".format(i, h))
PYEOF
    ;;

  cover)
    TOPIC="${1:?请输入主题}"
    python3 << PYEOF
import random
topic = "$TOPIC"
styles = [
    {"title": "{}全攻略".format(topic), "subtitle": "新手必看·保姆级教程", "color": "红色/橙色渐变", "font": "粗黑体大字"},
    {"title": "{}避坑指南".format(topic), "subtitle": "这些雷千万别踩！", "color": "黑色/金色", "font": "对比色标题"},
    {"title": "{}红黑榜".format(topic), "subtitle": "良心推荐vs智商税", "color": "红绿对比", "font": "左右分栏"},
    {"title": "{}入门到精通".format(topic), "subtitle": "一篇搞定所有问题", "color": "蓝色/白色清新", "font": "简约风"},
    {"title": "{}｜亲测有效".format(topic), "subtitle": "用过的都说好！", "color": "粉色/紫色", "font": "可爱圆体"},
]
print("=" * 50)
print("🎨  封面文案建议 — {}".format(topic))
print("=" * 50)
for i, s in enumerate(styles, 1):
    print()
    print("  方案 {}:".format(i))
    print("    主标题: {}".format(s["title"]))
    print("    副标题: {}".format(s["subtitle"]))
    print("    配色: {}".format(s["color"]))
    print("    字体: {}".format(s["font"]))
print()
print("  💡 Tips: 封面文字不超过10个字效果最佳，用1-2种颜色就够")
PYEOF
    ;;

  trending)
    python3 << 'PYEOF'
import random, datetime
today = datetime.date.today().strftime("%Y-%m-%d")
trends = [
    {"topic": "AI工具", "heat": "🔥🔥🔥🔥🔥", "reason": "AI应用爆发，工具测评类内容流量大"},
    {"topic": "平替推荐", "heat": "🔥🔥🔥🔥🔥", "reason": "消费降级趋势，大牌平替永远有流量"},
    {"topic": "自律打卡", "heat": "🔥🔥🔥🔥", "reason": "自我提升类内容持续热门"},
    {"topic": "副业赚钱", "heat": "🔥🔥🔥🔥🔥", "reason": "搞钱永远是刚需"},
    {"topic": "数码好物", "heat": "🔥🔥🔥🔥", "reason": "3C数码测评，男女通吃"},
    {"topic": "穿搭分享", "heat": "🔥🔥🔥🔥", "reason": "换季穿搭，常青赛道"},
    {"topic": "护肤成分", "heat": "🔥🔥🔥🔥", "reason": "成分党持续增长"},
    {"topic": "居家好物", "heat": "🔥🔥🔥", "reason": "家居收纳类实用内容"},
    {"topic": "英语学习", "heat": "🔥🔥🔥🔥", "reason": "知识类内容权重高"},
    {"topic": "投资理财", "heat": "🔥🔥🔥🔥", "reason": "财经科普需求旺盛"},
]
random.shuffle(trends)
print("=" * 50)
print("📈  热门赛道方向  ({})".format(today))
print("=" * 50)
for t in trends:
    print()
    print("  {} {} {}".format(t["heat"], t["topic"], ""))
    print("    {}".format(t["reason"]))
PYEOF
    ;;

  rewrite)
    TEXT="${1:?请输入原文}"
    python3 << PYEOF
import random
text = """$TEXT"""
emojis = ["✨","🔥","💯","❤️","🌟","💕","👀","🎉","😍","🤩","💪","🎯","💡"]
print("=" * 50)
print("✏️  笔记改写")
print("=" * 50)
print()
print("【原文】")
print(text)
print()
print("【改写建议】")
print("1. {} 开头加钩子：用提问/惊叹/数字开场".format(random.choice(emojis)))
print("2. {} 分段更短：每段不超过3行，增加可读性".format(random.choice(emojis)))
print("3. {} 加emoji：每2-3句加一个，增加活泼感".format(random.choice(emojis)))
print("4. {} 口语化：把'因此/所以'改成'所以说/就是说'".format(random.choice(emojis)))
print("5. {} 加互动：结尾问问题，引导评论".format(random.choice(emojis)))
print("6. {} 标签优化：至少5个标签，核心+流量混搭".format(random.choice(emojis)))
PYEOF
    ;;

  batch)
    TOPIC="${1:?请输入主题}"
    python3 << PYEOF
import random
topic = "$TOPIC"
emojis = ["✨","💫","🌟","⭐","💖","🔥","💯","🎯","👀","🙌","💪","📌","🎀","💝","🌈"]
hooks = ["震惊！","天花板级别！","后悔没早知道！","绝绝子！","yyds！","救命！","太绝了！","必看！","干货！","宝藏！"]
endings = ["记得收藏备用哦~","关注我不迷路~","码住！以后一定用得上","你们觉得呢？评论区聊聊","双击屏幕告诉我你喜欢~"]
print("=" * 55)
print("  {} 批量笔记生成（5篇）".format(topic))
print("=" * 55)
for i in range(5):
    random.shuffle(emojis)
    random.shuffle(hooks)
    print()
    print("  ━━━ 第{}篇 ━━━".format(i+1))
    print()
    print("  标题: {} {}，这{}个方法让你少走弯路！".format(hooks[0], topic, random.randint(3,7)))
    print()
    print("  正文:")
    print("  {} 姐妹们！今天必须跟你们聊聊{}！".format(emojis[0], topic))
    print("  作为一个研究{}多年的博主，".format(topic))
    print("  今天把压箱底的干货全分享出来！")
    print()
    for j in range(3):
        print("  {} {}核心要点{}：".format(emojis[j+1], topic, j+1))
        print("  这个真的超级重要！很多人都忽略了")
        print("  具体做法是：先......然后......最后......")
        print("  我自己试了之后效果真的惊人！")
        print()
    print("  {}".format(random.choice(endings)))
    print()
    tags = ["#{t}".format(t=topic), "#{}攻略".format(topic), "#干货分享", "#{}推荐".format(topic),
            "#好物分享", "#经验分享", "#涨知识", "#收藏备用", "#{}教程".format(topic), "#实用技巧"]
    random.shuffle(tags)
    print("  标签: {}".format(" ".join(tags[:7])))
    print("  封面: 大字报风格，主标题「{}必看」+ 副标题数字".format(topic))
PYEOF
    ;;

  analyze)
    DATA="${1:?格式: 点赞,收藏,评论,分享}"
    python3 << PYEOF
data = "$DATA".split(",")
if len(data) < 4:
    print("格式: analyze 点赞,收藏,评论,分享")
    exit(1)
likes = int(data[0])
collects = int(data[1])
comments = int(data[2])
shares = int(data[3])
total = likes + collects + comments + shares
interact_rate = total / max(likes * 20, 1) * 100

print("=" * 55)
print("  小红书数据复盘")
print("=" * 55)
print()
print("  点赞: {:,}  收藏: {:,}  评论: {:,}  转发: {:,}".format(likes, collects, comments, shares))
print()
cr = collects / max(likes, 1) * 100
print("  收藏率: {:.1f}% {}".format(cr, "✅ 优秀(干货型)" if cr > 60 else "🟡 一般" if cr > 30 else "🔴 偏低"))
print("  评赞比: {:.1f}% {}".format(comments/max(likes,1)*100, "✅ 互动强" if comments/max(likes,1) > 0.1 else "🔴 需加引导"))
print("  转发率: {:.1f}% {}".format(shares/max(likes,1)*100, "✅ 传播力强" if shares/max(likes,1) > 0.05 else "🟡 一般"))
print()
print("  📊 综合诊断：")
if cr > 60:
    print("  → 干货型内容！收藏率高说明内容有实用价值")
    print("  → 建议：多出系列内容，做合集提升粉丝粘性")
if comments/max(likes,1) < 0.1:
    print("  → 互动率低：结尾加提问引导，如「你们觉得呢？」")
    print("  → 试试争议性话题或投票型内容")
if shares/max(likes,1) < 0.05:
    print("  → 转发低：内容实用性够但分享欲不足")
    print("  → 加入「转给需要的朋友」等引导语")
if likes < 100:
    print("  → 曝光不足：优化标题关键词和封面")
    print("  → 发布时间建议：7-9点/12-13点/18-20点/21-23点")
PYEOF
    ;;

  persona)
    NICHE="${1:?请输入赛道}"
    python3 << PYEOF
niche = "$NICHE"
print("=" * 55)
print("  小红书IP人设方案 — {}赛道".format(niche))
print("=" * 55)
personas = [
    ("专业导师型", "{}领域资深从业者".format(niche), "专业干货+行业内幕", "付费咨询/课程/社群",
     ["Day1-7: 发5篇基础科普，建立专业形象",
      "Day8-14: 发3篇深度干货+2篇个人经历",
      "Day15-21: 开始互动，回复评论，做合集",
      "Day22-30: 发起话题讨论，引导私域"]),
    ("亲和学姐型", "{}小白逆袭，陪你一起成长".format(niche), "成长记录+踩坑分享", "好物推荐/品牌合作",
     ["Day1-7: 分享自己入门{}的故事".format(niche),
      "Day8-14: 发对比测评和真实体验",
      "Day15-21: 做粉丝答疑，建立信任",
      "Day22-30: 开始接软广，自然植入"]),
    ("数据极客型", "用数据说话，{}深度分析".format(niche), "数据测评+理性分析", "知识付费/咨询",
     ["Day1-7: 发3篇数据对比图文",
      "Day8-14: 做行业报告解读",
      "Day15-21: 出「避坑指南」系列",
      "Day22-30: 推出付费报告/社群"]),
]
for name, bio, style, monetize, plan in personas:
    print()
    print("  ┌─ 方案: {} ─┐".format(name))
    print("  │ 简介: {}".format(bio))
    print("  │ 内容: {}".format(style))
    print("  │ 变现: {}".format(monetize))
    print("  │ 30天启动计划:")
    for p in plan:
        print("  │   {}".format(p))
    print("  └────────────────┘")
PYEOF
    ;;

  seo)
    KW="${1:?请输入关键词}"
    python3 << PYEOF
kw = "$KW"
print("=" * 55)
print("  小红书SEO优化 — {}".format(kw))
print("=" * 55)
print()
print("  1. 标题关键词布局")
print("     核心词放标题前半段：「{}XXX」".format(kw))
print("     长尾词：{}推荐/{}教程/{}避坑/{}测评".format(kw,kw,kw,kw))
print("     数字+关键词：「5个{}技巧」「{}TOP10」".format(kw,kw))
print()
print("  2. 正文关键词密度")
print("     首段必出现「{}」".format(kw))
print("     全文出现3-5次，自然分布")
print("     用同义词替换避免堆砌")
print()
print("  3. 标签策略")
print("     大流量标签: #{}".format(kw))
print("     精准标签: #{}推荐 #{}攻略".format(kw,kw))
print("     长尾标签: #{}怎么选 #{}避坑指南".format(kw,kw))
print()
print("  4. 发布时间")
print("     工作日: 7:00-8:30 / 12:00-13:00 / 18:00-20:00")
print("     周末: 9:00-11:00 / 14:00-16:00 / 20:00-22:00")
print()
print("  5. 封面优化")
print("     封面文字包含「{}」关键词".format(kw))
print("     高对比色+大字体，3秒内传达主题")
PYEOF
    ;;

  collab)
    FANS="${1:?请输入粉丝量}"
    NICHE="${2:-通用}"
    python3 << PYEOF
fans = int("$FANS")
niche = "$NICHE"
print("=" * 55)
print("  品牌合作报价参考")
print("  粉丝: {:,}  赛道: {}".format(fans, niche))
print("=" * 55)
print()
base = fans * 0.1
if niche in ["美妆","护肤"]: base *= 1.5
elif niche in ["母婴","数码"]: base *= 1.3
elif niche in ["美食","旅行"]: base *= 1.0
print("  图文笔记: {:.0f}-{:.0f} 元/篇".format(base*0.8, base*1.2))
print("  视频笔记: {:.0f}-{:.0f} 元/条".format(base*1.5, base*2.5))
print("  直播带货: {:.0f}-{:.0f} 元/场 + 佣金".format(base*3, base*5))
print()
print("  报价影响因素:")
print("    粉丝质量 > 粉丝数量")
print("    互动率>5%可溢价30-50%")
print("    垂直赛道>泛娱乐")
print()
if fans < 5000:
    print("  当前阶段: 素人博主")
    print("  建议: 先做到5000粉再接商单，目前积累作品集")
elif fans < 50000:
    print("  当前阶段: 初级达人")
    print("  建议: 可接置换/低价单，积累合作案例")
elif fans < 500000:
    print("  当前阶段: 腰部达人")
    print("  建议: 可正常报价，建立媒介联系")
else:
    print("  当前阶段: 头部达人")
    print("  建议: 签MCN或自建商务团队")
PYEOF
    ;;

  audit)
    NICHE="${1:?请输入赛道，如：美妆/穿搭/美食}"
    export XHS_NICHE="$NICHE"
    python3 << 'PYEOF'
import os, datetime

niche = os.environ.get('XHS_NICHE', '通用')
today = datetime.date.today().strftime('%Y-%m-%d')

# Diagnostic checklist
sections = [
    ("📱 账号设置", [
        ("头像是否为真人/品牌IP形象", "避免风景/动漫头像，真人头像信任感+300%"),
        ("昵称是否包含赛道关键词", "如「小鹿爱穿搭」而非「快乐小鹿」，利于搜索发现"),
        ("简介是否有明确价值主张", "一句话说清'关注我你能得到什么'"),
        ("简介是否留了联系方式/引导", "合规引流：'全网同名'或'置顶笔记有惊喜'"),
        ("是否完成专业号认证", "认证后权重更高，搜索优先展示"),
        ("背景图是否利用起来", "展示作品集/成就/价值主张"),
    ]),
    ("📝 内容质量", [
        ("标题是否包含数字+情绪词", "「5个技巧」比「一些技巧」点击率高47%"),
        ("标题是否在18字以内", "超长标题被折叠，核心信息必须在前15字"),
        ("封面是否有大字标题", "纯图片封面点击率远低于图文封面"),
        ("封面色彩是否醒目（高饱和度）", "红/橙/黄暖色系在信息流中更抓眼球"),
        ("正文是否分段清晰（每段≤3行）", "大段文字劝退率极高，短段+emoji提升完读率"),
        ("正文是否使用emoji分隔", "每2-3句加emoji，视觉节奏感提升阅读体验"),
        ("是否有明确的CTA（引导互动）", "结尾加'你们觉得呢？'评论互动率提升2倍"),
        ("图片数量是否在6-9张", "少于4张内容单薄，多于9张用户疲劳"),
    ]),
    ("📊 发布策略", [
        ("发布频率是否稳定（每周≥3篇）", "断更会降权，稳定输出比爆发式更好"),
        ("发布时间是否在黄金时段", "7-9点/12-13点/18-20点/21-23点流量最大"),
        ("是否在发布后1小时内回复评论", "发布初期互动数据影响推荐权重"),
        ("是否在评论区做互动引导", "置顶评论引导讨论，提升评论区热度"),
        ("是否做过合集/专栏整理", "合集提升用户停留时长和关注转化率"),
    ]),
    ("💰 变现准备度", [
        ("粉丝量是否达到1000+", "蒲公英平台接单门槛1000粉"),
        ("近30天互动率是否>5%", "互动率=（赞+藏+评）÷阅读，5%以上品牌认可"),
        ("内容垂直度是否>80%", "80%以上内容在同一赛道，品牌更愿意合作"),
        ("是否有爆款笔记（赞藏>1000）", "至少1篇爆款作为'作品集'展示"),
        ("是否建立了个人内容风格", "辨识度=长期竞争力，模板化内容难变现"),
    ]),
]

total_items = sum(len(items) for _, items in sections)
print("=" * 60)
print("🔍 小红书账号诊断报告".center(52))
print("=" * 60)
print()
print("  赛道: {}".format(niche))
print("  日期: {}".format(today))
print("  检查项: {}项".format(total_items))
print()
print("  ⚠️  请对照自己账号，逐项自检：")
print("      ✅ = 已做到    ❌ = 未做到/需改进")
print()

for section_name, items in sections:
    print("-" * 60)
    print("  {}".format(section_name))
    print("-" * 60)
    for i, (check, tip) in enumerate(items, 1):
        print()
        print("  [ ] {}".format(check))
        print("      💡 {}".format(tip))
    print()

print("=" * 60)
print("  📋 诊断评分方法")
print("=" * 60)
print()
print("  每个 ✅ 得1分，共{}项".format(total_items))
print()
print("  {} - {} 分 → 🏆 优秀！继续保持，聚焦变现".format(int(total_items*0.8), total_items))
print("  {} - {} 分 → 👍 良好！补齐短板就能起飞".format(int(total_items*0.6), int(total_items*0.8)-1))
print("  {} - {} 分 → 🟡 及格！有明显提升空间".format(int(total_items*0.4), int(total_items*0.6)-1))
print("  0 - {} 分 → 🔴 需重建！建议从头规划".format(int(total_items*0.4)-1))
print()
print("=" * 60)
print("  🎯 TOP3 优先改进方向（按投入产出比排序）")
print("=" * 60)
print()
print("  1️⃣  封面+标题优化（提升点击率，见效最快）")
print("     → 所有笔记封面加文字标题，用数字+情绪词")
print("     → 预计效果：点击率提升50-200%")
print()
print("  2️⃣  发布频率和时间（提升曝光量）")
print("     → 固定每周3-5篇，选黄金时段发布")
print("     → 预计效果：基础曝光量翻倍")
print()
print("  3️⃣  互动引导（提升推荐权重）")
print("     → 每篇结尾加提问，发布后1小时回复评论")
print("     → 预计效果：互动率提升100-300%")
print()
print("  💡 执行建议：每周聚焦1个改进方向，4周一轮回")
PYEOF
    ;;

  hotspot)
    python3 << 'PYEOF'
import datetime, random

today = datetime.date.today()
month = today.month
year = today.year

# Seasonal context
if month in [3,4,5]:
    season = "春季"
    season_tag = "春天/换季"
elif month in [6,7,8]:
    season = "夏季"
    season_tag = "夏天/暑期"
elif month in [9,10,11]:
    season = "秋季"
    season_tag = "秋冬/开学"
else:
    season = "冬季"
    season_tag = "冬天/年末"

categories = [
    ("💄 美妆", [
        ("{}换季护肤急救指南".format(season), "换季=敏感肌高发期，搜索量暴涨", "新手"),
        ("早八通勤妆容（5分钟出门）", "打工人刚需，实用性极强", "新手"),
        ("大牌平替彩妆合集", "消费降级趋势下永恒流量密码", "中级"),
    ]),
    ("👗 穿搭", [
        ("{}胶囊衣橱（10件搞定一季）".format(season), "极简穿搭+省钱双重卖点", "新手"),
        ("小个子显高穿搭公式", "垂直痛点，受众精准", "新手"),
        ("通勤职场穿搭一周不重样", "打工人高频搜索", "中级"),
    ]),
    ("🍽️ 美食", [
        ("一人食快手晚餐（15分钟）", "独居年轻人刚需场景", "新手"),
        ("减脂期外卖避坑指南", "健康+外卖结合，痛点明确", "新手"),
        ("{}时令食材创意做法".format(season), "时令内容搜索权重高", "中级"),
    ]),
    ("✈️ 旅行", [
        ("{}周末短途目的地TOP5".format(season), "短途=决策门槛低，转化高", "新手"),
        ("旅行拍照pose大全（不尬）", "长青内容，收藏率极高", "新手"),
        ("人均500的小众旅行地", "性价比+小众=流量密码", "中级"),
    ]),
    ("👶 母婴", [
        ("新手妈妈待产包清单（不踩雷）", "刚需+高决策成本=高收藏率", "新手"),
        ("宝宝辅食每日食谱", "系列内容，粉丝粘性强", "中级"),
        ("早教启蒙在家怎么做", "教育焦虑下的流量入口", "中级"),
    ]),
    ("💪 健身", [
        ("居家帕梅拉替代（关节友好版）", "蹭IP+降低门槛", "新手"),
        ("体态矫正每日5分钟", "体态问题意识觉醒，搜索增长快", "新手"),
        ("减脂餐不重样一周计划", "减脂永恒话题+实操性强", "中级"),
    ]),
    ("🏠 家居", [
        ("出租屋改造（花500变高级）", "低成本改造=高传播性", "新手"),
        ("收纳神器平价合集", "好物推荐+实用=高收藏", "新手"),
        ("小户型空间利用黑科技", "居住痛点，共鸣感强", "中级"),
    ]),
    ("📱 数码", [
        ("AI工具效率翻倍合集", "AI热度持续走高，男女通吃", "新手"),
        ("手机摄影调色教程", "人人有手机，门槛低受众广", "新手"),
        ("办公软件隐藏技巧", "打工人提效刚需", "中级"),
    ]),
    ("💰 理财", [
        ("月薪5000存钱攻略", "省钱=普适性最强的理财话题", "新手"),
        ("基金定投入门傻瓜教程", "理财科普搜索量稳定增长", "中级"),
        ("副业赚钱真实经历分享", "搞钱永远是顶级流量", "高手"),
    ]),
    ("💼 职场", [
        ("简历优化前后对比", "求职季流量高，可视化效果好", "新手"),
        ("职场沟通话术模板", "软技能类内容收藏率高", "新手"),
        ("裸辞/转行真实经历", "故事型内容互动率高", "中级"),
    ]),
]

difficulty_map = {"新手": "⭐", "中级": "⭐⭐", "高手": "⭐⭐⭐"}

print("=" * 60)
print("🔥 小红书热点话题方向".center(52))
print("=" * 60)
print()
print("  {} {}年{}月 | 关键词：{}".format(season, year, month, season_tag))
print()

for cat_name, topics in categories:
    print("─" * 60)
    print("  {}".format(cat_name))
    print("─" * 60)
    for i, (topic, reason, diff) in enumerate(topics, 1):
        print()
        print("  {}. 📌 {}".format(i, topic))
        print("     原因: {}".format(reason))
        print("     难度: {} ({})".format(difficulty_map[diff], diff))
    print()

print("=" * 60)
print("  💡 选题建议")
print("=" * 60)
print()
print("  新手起步 → 选⭐难度，模仿爆款结构，先跑通流程")
print("  有基础   → 选⭐⭐难度，加入个人风格和深度")
print("  想突破   → 选⭐⭐⭐难度，做差异化内容建立壁垒")
print()
print("  🎯 万能公式：当季热点 + 个人经历 + 实操干货")
PYEOF
    ;;

  monetize)
    FANS="${1:?请输入粉丝量（数字）}"
    NICHE="${2:?请输入赛道（如：美妆/穿搭/美食）}"
    ENGAGE="${3:-5}"
    export XHS_FANS="$FANS" XHS_NICHE="$NICHE" XHS_ENGAGE="$ENGAGE"
    python3 << 'PYEOF'
import os

fans = int(os.environ.get('XHS_FANS', '0'))
niche = os.environ.get('XHS_NICHE', '通用')
engage = float(os.environ.get('XHS_ENGAGE', '5'))

# Niche multipliers for ad pricing
niche_mult = {
    "美妆": 1.5, "护肤": 1.5, "母婴": 1.4, "数码": 1.3,
    "家居": 1.2, "穿搭": 1.2, "美食": 1.0, "旅行": 1.1,
    "健身": 1.1, "理财": 1.3, "职场": 1.0, "教育": 1.2,
}
mult = niche_mult.get(niche, 1.0)

# Engagement quality bonus
if engage >= 10:
    eng_bonus = 1.5
    eng_level = "🏆 极优"
elif engage >= 7:
    eng_bonus = 1.3
    eng_level = "✅ 优秀"
elif engage >= 5:
    eng_bonus = 1.0
    eng_level = "👍 良好"
elif engage >= 3:
    eng_bonus = 0.7
    eng_level = "🟡 一般"
else:
    eng_bonus = 0.4
    eng_level = "🔴 偏低"

print("=" * 60)
print("💰 小红书变现路径规划".center(52))
print("=" * 60)
print()
print("  粉丝量: {:,}".format(fans))
print("  赛道:   {}（溢价系数 {:.1f}x）".format(niche, mult))
print("  互动率: {:.1f}% {}".format(engage, eng_level))
print()

# === Determine stage and paths ===
if fans < 1000:
    stage = "🌱 素人阶段"
    print("─" * 60)
    print("  当前阶段: {}".format(stage))
    print("─" * 60)
    print()
    print("  ⚠️  粉丝不足1000，暂不建议急于变现")
    print("  🎯  当前目标：先把粉丝做到1000+")
    print()
    print("  📋 行动清单：")
    print("  ┌──────────────────────────────────────┐")
    print("  │ Step 1: 确定垂直赛道，不要什么都发     │")
    print("  │ Step 2: 每周发3-5篇，保持稳定更新     │")
    print("  │ Step 3: 模仿赛道TOP10博主的选题和封面  │")
    print("  │ Step 4: 互动！回复每条评论，去同行下互动│")
    print("  │ Step 5: 做1-2个爆款内容冲破冷启动     │")
    print("  └──────────────────────────────────────┘")
    print()
    print("  💰 可尝试的变现方式：")
    print("     • 好物分享（挂链接赚佣金，无粉丝门槛）")
    print("     • 知识付费（小额咨询/资料包）")
    print()
    print("  📈 预期月收入: 0-500元（佣金为主）")

elif fans < 5000:
    stage = "🌿 新手博主"
    base_income_low = int(fans * 0.05 * mult * eng_bonus)
    base_income_high = int(fans * 0.15 * mult * eng_bonus)
    print("─" * 60)
    print("  当前阶段: {}".format(stage))
    print("─" * 60)
    print()
    print("  🔓 已解锁：蒲公英平台（1000粉门槛）")
    print()
    print("  💰 推荐变现路径（按优先级）：")
    print()
    print("  1️⃣  好物分享/带货佣金")
    print("     • 挂小红书商品链接，赚销售佣金")
    print("     • 适合：好物推荐/测评类内容")
    print("     • 预期：每篇10-200元佣金")
    print()
    print("  2️⃣  品牌置换合作")
    print("     • 免费收到产品，写真实体验笔记")
    print("     • 适合：积累合作案例和作品集")
    print("     • 主动联系品牌PR或在蒲公英接单")
    print()
    print("  3️⃣  知识变现（如果有专业技能）")
    print("     • 1v1咨询/付费社群/资料包")
    print("     • 适合：技能类赛道（设计/编程/理财等）")
    print()
    print("  📋 行动清单：")
    print("  ┌──────────────────────────────────────┐")
    print("  │ Step 1: 开通蒲公英平台，完善创作者资料 │")
    print("  │ Step 2: 选3-5个对标品牌，研究他们投的KOC│")
    print("  │ Step 3: 每周产出2篇高质量种草笔记      │")
    print("  │ Step 4: 主动联系小品牌PR，邮件/私信    │")
    print("  │ Step 5: 积累3-5个合作案例做media kit   │")
    print("  └──────────────────────────────────────┘")
    print()
    print("  📈 预期月收入: {:,}-{:,}元".format(base_income_low, base_income_high))

elif fans < 50000:
    stage = "🌳 腰部达人"
    ad_low = int(fans * 0.08 * mult * eng_bonus)
    ad_high = int(fans * 0.15 * mult * eng_bonus)
    monthly_low = ad_low * 2
    monthly_high = ad_high * 4
    print("─" * 60)
    print("  当前阶段: {}".format(stage))
    print("─" * 60)
    print()
    print("  💰 推荐变现路径（按收入潜力）：")
    print()
    print("  1️⃣  品牌广告合作（主要收入）")
    print("     • 图文报价参考: {:,}-{:,}元/篇".format(ad_low, ad_high))
    print("     • 视频报价参考: {:,}-{:,}元/条".format(int(ad_low*1.5), int(ad_high*2)))
    print("     • 每月接2-4单 → 稳定收入来源")
    print()
    print("  2️⃣  直播带货")
    print("     • 坑位费+佣金模式")
    print("     • 适合：有供应链资源或选品能力")
    print("     • 预期：每场500-5000元")
    print()
    print("  3️⃣  私域导流")
    print("     • 引流到微信做高客单价转化")
    print("     • 适合：咨询/课程/高端产品")
    print()
    print("  4️⃣  知识付费")
    print("     • 线上课程/社群/训练营")
    print("     • 适合：有专业壁垒的赛道")
    print()
    print("  📋 行动清单：")
    print("  ┌──────────────────────────────────────┐")
    print("  │ Step 1: 制作专业media kit（数据+案例） │")
    print("  │ Step 2: 入驻蒲公英+对接MCN/PR资源     │")
    print("  │ Step 3: 建立报价体系（图文/视频/合集） │")
    print("  │ Step 4: 保持内容质量，广告比≤30%      │")
    print("  │ Step 5: 开始规划私域和个人品牌         │")
    print("  └──────────────────────────────────────┘")
    print()
    print("  📈 预期月收入: {:,}-{:,}元".format(monthly_low, monthly_high))

else:
    stage = "🏔️ 头部达人"
    ad_low = int(fans * 0.1 * mult * eng_bonus)
    ad_high = int(fans * 0.2 * mult * eng_bonus)
    monthly_low = ad_high * 3
    monthly_high = ad_high * 8
    print("─" * 60)
    print("  当前阶段: {}".format(stage))
    print("─" * 60)
    print()
    print("  💰 变现矩阵（多元化收入）：")
    print()
    print("  1️⃣  品牌广告（基本盘）")
    print("     • 图文: {:,}-{:,}元/篇".format(ad_low, ad_high))
    print("     • 视频: {:,}-{:,}元/条".format(int(ad_low*2), int(ad_high*3)))
    print("     • 年框合作: {:,}-{:,}元/年".format(ad_high*12, ad_high*24))
    print()
    print("  2️⃣  自有品牌/选品店")
    print("     • 利用粉丝信任做自有产品线")
    print("     • 利润率远高于广告")
    print()
    print("  3️⃣  直播带货")
    print("     • 坑位费+佣金，每场万元级")
    print()
    print("  4️⃣  IP授权/代言")
    print("     • 品牌代言、联名款")
    print()
    print("  5️⃣  知识付费/咨询")
    print("     • 高端课程/1v1咨询/企业培训")
    print()
    print("  📋 行动清单：")
    print("  ┌──────────────────────────────────────┐")
    print("  │ Step 1: 组建团队（助理/编辑/商务）     │")
    print("  │ Step 2: 签约MCN或自建商务体系          │")
    print("  │ Step 3: 规划自有品牌/产品线            │")
    print("  │ Step 4: 多平台分发（抖音/B站/视频号）  │")
    print("  │ Step 5: 建立长期品牌合作关系           │")
    print("  └──────────────────────────────────────┘")
    print()
    print("  📈 预期月收入: {:,}-{:,}元".format(monthly_low, monthly_high))

print()
print("=" * 60)
print("  ⚡ 提升变现能力的通用建议")
print("=" * 60)
print()
print("  1. 互动率 > 粉丝量（品牌最看重互动率）")
print("  2. 垂直 > 泛娱乐（垂直赛道报价高50-100%）")
print("  3. 内容质量 > 发布数量（1篇爆款顶10篇普通）")
print("  4. 人设 > 内容（有辨识度才有长期价值）")
print("  5. 广告比例控制在30%以内，否则掉粉")
PYEOF
    ;;

  help|*)
    echo "📕 小红书爆款笔记生成器"
    echo ""
    echo "Usage: xhs.sh <command> [args]"
    echo ""
    echo "Commands:"
    echo "  note \"主题\"     生成完整小红书笔记（标题+正文+标签）"
    echo "  title \"主题\"    生成5个爆款标题"
    echo "  tags \"主题\"     推荐标签组合"
    echo "  hook \"主题\"     生成开头钩子（吸引点击）"
    echo "  cover \"主题\"    封面文案建议"
    echo "  trending        热门赛道方向"
    echo "  rewrite \"原文\"  改写/优化已有笔记"
    echo "  batch \"主题\"     批量生成5篇完整笔记"
    echo "  analyze \"数据\"   数据复盘(点赞,收藏,评论,分享)"
    echo "  persona \"赛道\"   账号IP人设方案"
    echo "  seo \"关键词\"     搜索优化策略"
    echo "  collab 粉丝 赛道  品牌合作报价"
    echo "  audit \"赛道\"     账号诊断（20+项检查清单）"
    echo "  hotspot          实时热点追踪（10大品类）"
    echo "  monetize 粉丝 赛道 互动率  变现路径规划"
    echo "  help             显示帮助"
    echo ""
    echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;
esac
