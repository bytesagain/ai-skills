#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""video-script-creator engine - 短视频脚本生成器"""

from __future__ import print_function
import sys
import random
import argparse
import textwrap

# ============================================================
# 平台配置
# ============================================================

PLATFORMS = {
    "douyin": {
        "name": "抖音",
        "style": "快节奏、强钩子、口语化、情绪拉满",
        "tags_prefix": "#抖音",
        "audience": "18-35岁，碎片化浏览",
        "tips": [
            "前3秒必须抓住注意力",
            "多用反问/悬念开场",
            "节奏紧凑，每5-8秒一个信息点",
            "结尾引导点赞+关注",
            "背景音乐很重要，选热门BGM",
        ],
    },
    "kuaishou": {
        "name": "快手",
        "style": "接地气、真实感、故事性强",
        "tags_prefix": "#快手",
        "audience": "下沉市场为主，注重真实和共鸣",
        "tips": [
            "真实感第一，不要太做作",
            "讲故事比讲道理更有效",
            "多展示过程和细节",
            "老铁文化，互动感强",
            "家庭/生活/手艺类内容受欢迎",
        ],
    },
    "youtube": {
        "name": "YouTube Shorts",
        "style": "信息密度高、国际化视角、字幕清晰",
        "tags_prefix": "#Shorts",
        "audience": "全球用户，偏好高质量内容",
        "tips": [
            "开场直奔主题，不要铺垫",
            "信息密度要高",
            "画面质量要求较高",
            "可中英双语字幕",
            "结尾引导订阅",
        ],
    },
    "bilibili": {
        "name": "B站",
        "style": "有深度、有梗、知识型/二次元友好",
        "tags_prefix": "#bilibili",
        "audience": "Z世代，喜欢有深度有趣的内容",
        "tips": [
            "可以稍微深入一点，观众有耐心",
            "玩梗要自然，不要硬蹭",
            "知识科普类很受欢迎",
            "弹幕互动文化，留互动点",
            "一键三连引导要自然",
        ],
    },
}

DURATIONS = {
    30: {"label": "30秒", "sections": 3, "words": "80-120字"},
    60: {"label": "60秒", "sections": 5, "words": "180-250字"},
    90: {"label": "90秒", "sections": 7, "words": "280-380字"},
}

# ============================================================
# 模板数据
# ============================================================

HOOK_TEMPLATES = [
    "【反问型】{topic}？90%的人都做错了！",
    "【悬念型】关于{topic}，我发现了一个惊人的秘密……",
    "【数字型】{topic}的3个隐藏技巧，第2个太绝了！",
    "【痛点型】还在为{topic}发愁？看完这条视频你就懂了",
    "【对比型】{topic}：新手 vs 高手的区别，差距太大了！",
    "【故事型】我花了3年才明白{topic}的真相……",
    "【挑战型】{topic}挑战！你敢试试吗？",
    "【揭秘型】{topic}的行业内幕，从来没人告诉你！",
    "【共鸣型】如果你也在纠结{topic}，一定要看完！",
    "【反常识型】{topic}？你以为的常识其实都是错的！",
]

TITLE_TEMPLATES = [
    "🔥 {topic}｜99%的人不知道的{n}个秘密",
    "💡 一分钟学会{topic}，小白也能秒懂！",
    "⚡ {topic}避坑指南！别再踩雷了",
    "🎯 {topic}终极攻略，看这一条就够了",
    "😱 {topic}的真相，看完我沉默了……",
    "✨ 手把手教你{topic}，从零到精通",
    "🚀 {topic}效率翻倍的{n}个神技巧",
    "💰 {topic}省钱秘籍，一年能省好几千",
    "❌ {topic}千万别这样做！我踩过的坑",
    "🏆 {topic}天花板教程，学到就是赚到",
]

CTA_TEMPLATES = [
    "觉得有用的话，双击屏幕给个❤️，关注我学习更多{topic}干货！",
    "你在{topic}方面有什么经验？评论区告诉我，我会一一回复！",
    "转发给你身边需要的人，收藏起来以后用得到！关注 @账号名 不迷路～",
    "{topic}系列持续更新中！点击关注，下期教你更进阶的玩法🔥",
    "如果这条视频帮到你了，点个赞让更多人看到！还想看什么主题？评论区留言📝",
    "这只是{topic}的冰山一角！关注我，带你解锁更多隐藏技能✨",
    "学会了吗？学会的扣1，没学会的扣2，我出详细教程！",
    "赶紧收藏！下次需要{topic}的时候就不用到处找了📌",
]

OUTLINE_SECTIONS = [
    {"name": "开场钩子", "desc": "3秒内抓住注意力，抛出核心悬念或痛点", "duration_pct": 10},
    {"name": "问题/痛点", "desc": "明确观众的困扰，引发共鸣", "duration_pct": 15},
    {"name": "核心内容", "desc": "干货输出，分2-3个要点展开", "duration_pct": 45},
    {"name": "案例/演示", "desc": "用实例或演示强化说服力", "duration_pct": 15},
    {"name": "总结+CTA", "desc": "回扣主题，引导互动（点赞/关注/评论）", "duration_pct": 15},
]

TRENDING_CATEGORIES = [
    {
        "category": "🎓 知识科普",
        "examples": ["冷知识合集", "一分钟看懂XX", "XX的前世今生"],
        "heat": "🔥🔥🔥🔥🔥",
    },
    {
        "category": "💼 职场成长",
        "examples": ["面试技巧", "副业赚钱", "职场避坑"],
        "heat": "🔥🔥🔥🔥",
    },
    {
        "category": "🍳 美食教程",
        "examples": ["快手菜", "一人食", "复刻网红美食"],
        "heat": "🔥🔥🔥🔥🔥",
    },
    {
        "category": "💪 健身运动",
        "examples": ["居家健身", "体态矫正", "减脂餐"],
        "heat": "🔥🔥🔥🔥",
    },
    {
        "category": "🛍️ 好物推荐",
        "examples": ["平价替代", "年度爱用", "避雷清单"],
        "heat": "🔥🔥🔥🔥🔥",
    },
    {
        "category": "🏠 生活技巧",
        "examples": ["收纳整理", "清洁妙招", "租房攻略"],
        "heat": "🔥🔥🔥🔥",
    },
    {
        "category": "💻 科技数码",
        "examples": ["APP推荐", "手机技巧", "AI工具"],
        "heat": "🔥🔥🔥🔥🔥",
    },
    {
        "category": "🎭 剧情/反转",
        "examples": ["职场小剧场", "情侣日常", "反转神结局"],
        "heat": "🔥🔥🔥",
    },
    {
        "category": "✈️ 旅行探店",
        "examples": ["小众景点", "城市citywalk", "探店打卡"],
        "heat": "🔥🔥🔥🔥",
    },
    {
        "category": "📚 读书分享",
        "examples": ["3分钟读完一本书", "书单推荐", "读书笔记"],
        "heat": "🔥🔥🔥",
    },
]

STORYBOARD_CUES = [
    "【镜头】正脸中景，直视镜头，表情{emotion}",
    "【镜头】产品/素材特写，手指指向重点",
    "【镜头】画面切换，插入相关素材/图片",
    "【镜头】全景展示环境/场景",
    "【镜头】屏幕录制/操作演示",
    "【镜头】文字弹出动效，强调关键信息",
    "【镜头】对比画面，左右分屏",
    "【镜头】慢动作/快进，增加节奏感",
]

EMOTIONS = ["认真", "惊讶", "兴奋", "严肃", "微笑", "夸张", "思考"]


# ============================================================
# 核心函数
# ============================================================

def print_divider(char="─", length=50):
    print(char * length)


def print_header(title):
    print("")
    print_divider("═")
    print("  {}".format(title))
    print_divider("═")
    print("")


def gen_script(topic, platform="douyin", duration=60):
    """生成完整短视频脚本"""
    plat = PLATFORMS.get(platform, PLATFORMS["douyin"])
    dur = DURATIONS.get(duration, DURATIONS[60])

    print_header("📹 短视频脚本 — {}".format(plat["name"]))

    print("📌 主题：{}".format(topic))
    print("📱 平台：{}（{}）".format(plat["name"], plat["style"]))
    print("⏱️  时长：{}（口播约{}）".format(dur["label"], dur["words"]))
    print("")
    print_divider()

    # 平台Tips
    print("")
    print("💡 平台要点：")
    for tip in plat["tips"]:
        print("   • {}".format(tip))
    print("")
    print_divider()

    # 开场（前3秒）
    print("")
    print("🎬 【第一幕 · 开场钩子】（0-3秒）")
    print("")
    hook = random.choice(HOOK_TEMPLATES).format(topic=topic)
    emotion = random.choice(EMOTIONS)
    cue = random.choice(STORYBOARD_CUES).format(emotion=emotion)
    print("   口播：「{}」".format(hook))
    print("   {}".format(cue))
    print("   🎵 BGM：节奏感强的热门音乐，从第一秒开始")
    print("")
    print_divider("·")

    # 主体
    section_count = dur["sections"] - 2  # 去掉开场和结尾
    if section_count < 1:
        section_count = 1

    time_per_section = (duration - 10) // section_count  # 留10秒给开场和结尾

    for i in range(section_count):
        start = 3 + i * time_per_section
        end = start + time_per_section
        print("")
        print("📝 【第{}幕 · 核心内容{}】（{}-{}秒）".format(
            i + 2,
            "·要点{}".format(i + 1) if section_count > 1 else "",
            start, end
        ))
        print("")

        prompts = [
            "围绕「{}」展开第{}个要点".format(topic, i + 1),
            "用具体案例或数据支撑观点",
            "语言口语化，避免书面语",
        ]
        if i == 0:
            prompts.append("承接开场钩子，自然过渡")
        if platform == "bilibili":
            prompts.append("可以适当玩梗，增加趣味性")
        if platform == "kuaishou":
            prompts.append("多用真实经历/故事来讲述")

        print("   口播要点：")
        for p in prompts:
            print("      → {}".format(p))

        emotion = random.choice(EMOTIONS)
        cue = random.choice(STORYBOARD_CUES).format(emotion=emotion)
        print("   {}".format(cue))
        print("   📌 字幕关键词：{}".format(topic))
        print("")
        print_divider("·")

    # 结尾
    print("")
    print("🎯 【最终幕 · 结尾CTA】（最后5秒）")
    print("")
    cta = random.choice(CTA_TEMPLATES).format(topic=topic)
    print("   口播：「{}」".format(cta))
    emotion = random.choice(EMOTIONS)
    cue = STORYBOARD_CUES[0].format(emotion=emotion)
    print("   {}".format(cue))
    print("   🎵 BGM渐弱，留出口播空间")
    print("")
    print_divider()

    # 标签推荐
    print("")
    print("🏷️  推荐标签：")
    base_tags = [
        "{} #{}".format(plat["tags_prefix"], topic),
        "#短视频",
        "#干货分享",
        "#涨知识",
        "#必看",
    ]
    for tag in base_tags:
        print("   {}".format(tag))

    print("")
    print_divider()
    print("")
    print("📋 脚本备注：")
    print("   • 以上为框架模板，请根据实际内容填充具体口播词")
    print("   • 建议先录音频确认节奏，再拍画面")
    print("   • {}平台建议竖屏拍摄（9:16）".format(plat["name"]))
    print("   • 字幕建议用醒目颜色+描边，放在画面下方1/3处")
    print("")


def gen_hooks(topic):
    """生成5个开场钩子"""
    print_header("🪝 开场钩子 · 前3秒留人")
    print("📌 主题：{}".format(topic))
    print("")
    print_divider()
    print("")

    selected = random.sample(HOOK_TEMPLATES, min(5, len(HOOK_TEMPLATES)))
    for i, tmpl in enumerate(selected, 1):
        hook = tmpl.format(topic=topic)
        print("{}. {}".format(i, hook))
        print("")

    print_divider()
    print("")
    print("💡 使用技巧：")
    print("   • 语速要快，语气要强，表情要到位")
    print("   • 前3秒决定完播率，反复测试不同钩子")
    print("   • 可以搭配画面闪切+音效增强冲击力")
    print("   • A/B测试：同一内容用不同钩子发布，看数据选最优")
    print("")


def gen_titles(topic):
    """生成5个爆款标题"""
    print_header("✍️  爆款标题生成器")
    print("📌 主题：{}".format(topic))
    print("")
    print_divider()
    print("")

    selected = random.sample(TITLE_TEMPLATES, min(5, len(TITLE_TEMPLATES)))
    for i, tmpl in enumerate(selected, 1):
        n = random.choice([3, 5, 7, 10])
        title = tmpl.format(topic=topic, n=n)
        print("{}. {}".format(i, title))
        print("")

    print_divider()
    print("")
    print("💡 标题优化技巧：")
    print("   • 数字+情绪词=高点击率")
    print("   • 控制在20字以内，手机端完整展示")
    print("   • 善用emoji增加视觉吸引力")
    print("   • 制造信息差/好奇心缺口")
    print("   • 蹭热点但不要标题党")
    print("")


def gen_outline(topic):
    """生成视频大纲"""
    print_header("📋 视频大纲")
    print("📌 主题：{}".format(topic))
    print("")
    print_divider()
    print("")

    for i, section in enumerate(OUTLINE_SECTIONS, 1):
        bar_len = section["duration_pct"] // 5
        bar = "█" * bar_len + "░" * (10 - bar_len)
        print("{} {} [{}] (占比 {}%)".format(
            i, section["name"], bar, section["duration_pct"]
        ))
        print("   {}".format(section["desc"]))
        print("")

    print_divider()
    print("")
    print("📐 大纲应用建议：")
    print("")
    print("   30秒视频：压缩为 钩子→核心1点→CTA 三段式")
    print("   60秒视频：完整五段式，每段10-15秒")
    print("   90秒视频：核心内容可拆分2-3个子要点，加案例")
    print("")
    print("   通用公式：")
    print("   钩子（抓注意力）→ 痛点（引共鸣）→ 干货（给价值）")
    print("   → 案例（增信任）→ CTA（促行动）")
    print("")


def gen_cta(topic):
    """生成结尾CTA"""
    print_header("🎯 结尾互动引导（CTA）")
    print("📌 主题：{}".format(topic))
    print("")
    print_divider()
    print("")

    selected = random.sample(CTA_TEMPLATES, min(5, len(CTA_TEMPLATES)))
    for i, tmpl in enumerate(selected, 1):
        cta = tmpl.format(topic=topic)
        print("{}. {}".format(i, cta))
        print("")

    print_divider()
    print("")
    print("💡 CTA技巧：")
    print("   • 明确告诉观众要做什么（点赞/关注/评论/收藏）")
    print("   • 给一个互动理由，不要硬求")
    print("   • 提问式CTA效果最好（引发评论区讨论）")
    print("   • 预告下期内容，制造期待感")
    print("   • 语气真诚自然，不要太套路")
    print("")


def gen_trending():
    """展示热门视频类型"""
    print_header("🔥 热门短视频类型 & 方向")
    print("")

    for item in TRENDING_CATEGORIES:
        print("{} {}".format(item["category"], item["heat"]))
        examples_str = " / ".join(item["examples"])
        print("   热门选题：{}".format(examples_str))
        print("")

    print_divider()
    print("")
    print("💡 选题建议：")
    print("   • 从自己擅长的领域切入，真实感最重要")
    print("   • 关注各平台热搜/话题榜，借势不造势")
    print("   • 垂直领域深耕 > 什么都拍")
    print("   • 爆款公式：热门话题 × 个人特色 × 实用价值")
    print("   • 多看同类型头部账号，学习选题角度")
    print("")


def gen_storyboard(topic, platform="douyin", duration=60):
    """生成完整分镜脚本"""
    plat = PLATFORMS.get(platform, PLATFORMS["douyin"])
    dur = DURATIONS.get(duration, DURATIONS[60])

    print_header("🎬 完整分镜脚本 — {}".format(topic))

    print("📌 主题：{}".format(topic))
    print("📱 平台：{}（{}）".format(plat["name"], plat["style"]))
    print("⏱️  时长：{}".format(dur["label"]))
    print("")
    print_divider()

    # 分镜表头
    print("")
    print("{:<6} {:<8} {:<22} {:<20} {:<10}".format(
        "镜号", "时长", "画面描述", "旁白/字幕", "BGM/音效"
    ))
    print("─" * 70)

    scenes = [
        ("S1", "0-3s", "正脸中景，表情惊讶/兴奋，直视镜头",
         random.choice(HOOK_TEMPLATES).format(topic=topic),
         "🎵 节奏感强的热门BGM开场"),
        ("S2", "3-8s", "手指指向文字标题弹出，画面闪切",
         "关于{}，大多数人都不知道这几点".format(topic),
         "🔊 转场音效「叮」"),
        ("S3", "8-15s", "产品/场景特写，展示细节",
         "第一个要点：{}的核心是......".format(topic),
         "🎵 BGM降低，突出人声"),
        ("S4", "15-25s", "屏幕录制/操作演示/实物展示",
         "具体操作方法：先......再......最后......",
         "🎵 轻快背景音乐"),
        ("S5", "25-38s", "对比画面，左右分屏/前后对比",
         "对比效果：之前 vs 之后，差距一目了然",
         "🔊 \"哇哦\" 音效"),
        ("S6", "38-48s", "文字弹出动效，列出要点",
         "总结一下：1.{topic}的关键是...... 2.一定要注意......".format(topic=topic),
         "🎵 BGM节奏加快"),
        ("S7", "48-55s", "回到正脸，表情真诚",
         "如果你也在研究{}，这些经验希望能帮到你".format(topic),
         "🎵 BGM保持"),
        ("S8", "55-60s", "指向关注按钮，点赞手势",
         random.choice(CTA_TEMPLATES).format(topic=topic),
         "🎵 BGM渐弱结束"),
    ]

    # 根据时长调整场景数量
    if duration <= 30:
        scenes = [scenes[0], scenes[2], scenes[7]]
    elif duration <= 60:
        pass  # 默认8个场景
    else:
        # 90秒版本插入额外场景
        extra = ("S4b", "25-35s", "深入讲解案例/数据支撑",
                 "有数据显示，{}方面......".format(topic),
                 "🎵 舒缓背景音")
        scenes.insert(4, extra)

    for scene in scenes:
        sid, timing, visual, narration, bgm = scene
        # 截断显示
        visual_short = visual[:20] + ".." if len(visual) > 20 else visual
        narration_short = narration[:18] + ".." if len(narration) > 18 else narration
        print("{:<6} {:<8} {:<22} {:<20} {}".format(
            sid, timing, visual_short, narration_short, bgm
        ))
    print("")
    print_divider()

    # 详细分镜
    print("")
    print("📋 详细分镜说明：")
    print("")
    for scene in scenes:
        sid, timing, visual, narration, bgm = scene
        print("  ┌─ {} ({}) ──────────────────────────────────┐".format(sid, timing))
        print("  │ 🎥 画面：{}".format(visual))
        print("  │ 🗣️ 旁白：「{}」".format(narration))
        print("  │ 📝 字幕：加粗关键词，放画面下方1/3处")
        print("  │ {}".format(bgm))
        print("  └──────────────────────────────────────────────┘")
        print("")

    print("📌 拍摄注意事项：")
    print("   • 竖屏拍摄（9:16），分辨率 1080×1920 以上")
    print("   • 光线充足，避免逆光")
    print("   • 正脸镜头时保持眼神接触，不要读稿")
    print("   • 字幕用醒目颜色（白底黑字+描边）")
    print("   • 剪辑节奏紧凑，避免空镜超过2秒")
    print("")


def gen_hooks_10(topic):
    """生成10个不同风格的前3秒开头钩子"""
    print_header("🪝 前3秒钩子大全 — 10种风格")
    print("📌 主题：{}".format(topic))
    print("")
    print_divider()
    print("")

    hook_styles = [
        ("反问型", "{}？90%的人都做错了，你中招了吗？".format(topic)),
        ("悬念型", "关于{}，我发现了一个惊人的秘密，听完你会感谢我……".format(topic)),
        ("数字型", "{}的5个隐藏技巧，第3个99%的人不知道！".format(topic)),
        ("痛点型", "还在为{}发愁？看完这条你会恨自己没早看到！".format(topic)),
        ("对比型", "{}：花1000块的效果 vs 不花钱的方法，差距惊人！".format(topic)),
        ("故事型", "我曾经在{}上栽了大跟头，花了3年才明白这个道理……".format(topic)),
        ("挑战型", "敢不敢用30秒学会{}？我打赌你做不到！".format(topic)),
        ("揭秘型", "{}的行业内幕，从业10年的人都不一定知道！".format(topic)),
        ("共鸣型", "如果你也曾经在{}上感到迷茫，请一定看完这条视频".format(topic)),
        ("反常识型", "{}？你以为你懂了，其实全错了！看完颠覆三观".format(topic)),
    ]

    for i, (style, hook) in enumerate(hook_styles, 1):
        print("  {:>2}. 【{}】".format(i, style))
        print("      「{}」".format(hook))
        print("       📹 配合动作：{}".format(random.choice([
            "瞪大眼睛，表情夸张，快速说完",
            "手指指向镜头，语气肯定",
            "摇头+叹气，然后表情变认真",
            "快速闪切3个画面，配合节拍",
            "从画面外闯入，制造惊喜感",
            "手挡住镜头然后移开，露出内容",
            "倒数3-2-1手势，制造紧迫感",
            "竖起手指，严肃脸",
            "左右看，然后凑近镜头小声说",
            "双手合十，表情真诚",
        ])))
        print("")

    print_divider()
    print("")
    print("💡 前3秒黄金法则：")
    print("   • 语速快：比正常说话快1.3倍，制造紧迫感")
    print("   • 表情大：夸张30%，手机屏幕小需要放大情绪")
    print("   • 信息量满：第一句话就要传递核心信息/悬念")
    print("   • 视觉冲击：配合画面闪切、文字弹出、音效")
    print("   • A/B测试：同一内容用不同钩子发布，数据说话")
    print("")


def gen_series(topic, episodes):
    """系列视频规划"""
    print_header("📺 系列视频规划 — {}（共{}集）".format(topic, episodes))
    print("")
    print_divider()
    print("")

    phase_map = [
        ("入门篇", "基础概念和认知，吸引新关注", [
            "什么是{}？一分钟带你入门".format(topic),
            "{}新手最常犯的3个错误".format(topic),
            "为什么你需要了解{}？".format(topic),
        ]),
        ("进阶篇", "深入技巧和方法，建立专业感", [
            "{}的5个核心技巧，从入门到精通".format(topic),
            "{}高手都在用的秘密方法".format(topic),
            "{}进阶指南：突破瓶颈的关键".format(topic),
        ]),
        ("实战篇", "案例和实操，提供实用价值", [
            "手把手教你{}实操全流程".format(topic),
            "{}实战案例拆解：成功vs失败".format(topic),
            "跟着做：{}从0到1完整教程".format(topic),
        ]),
        ("高级篇", "行业洞察和趋势，建立权威", [
            "{}的未来趋势，提前布局".format(topic),
            "{}行业大佬都在关注的方向".format(topic),
            "从{}看整个行业的变化".format(topic),
        ]),
    ]

    ep_num = 1
    for phase_name, phase_desc, templates in phase_map:
        if ep_num > episodes:
            break
        print("  📂 {} — {}".format(phase_name, phase_desc))
        print("  " + "─" * 48)
        # 每个阶段分配的集数
        eps_in_phase = max(1, episodes // len(phase_map))
        for j in range(eps_in_phase):
            if ep_num > episodes:
                break
            template = templates[j % len(templates)]
            print("")
            print("    第{:>2}集：{}".format(ep_num, template))
            print("    ├─ 核心内容：围绕「{}」的第{}个要点展开".format(topic, ep_num))
            print("    ├─ 时长建议：60秒（抖音/快手）或 3-5分钟（B站/YouTube）")
            print("    ├─ 开场钩子：{}".format(random.choice(HOOK_TEMPLATES).format(topic=topic)))
            print("    └─ CTA：引导关注系列，预告下一集内容")
            ep_num += 1
        print("")

    print(_divider_str())
    print("")
    print("  📋 系列视频运营策略：")
    print("     • 固定更新频率：每周2-3条，培养用户期待")
    print("     • 统一封面风格：系列感 = 专业感")
    print("     • 每集开头回顾上集 + 预告本集内容")
    print("     • 评论区置顶往期合集链接")
    print("     • 前3集决定用户是否追更，要精心制作")
    print("     • 使用话题标签统一系列：#{}系列".format(topic))
    print("")


def gen_review(data):
    """视频数据复盘"""
    print_header("📊 视频数据复盘分析")
    print("")
    print("📌 输入数据：{}".format(data))
    print("")
    print_divider()
    print("")

    # 尝试解析数据
    metrics = {}
    for item in data.split(","):
        item = item.strip()
        if ":" in item:
            k, v = item.rsplit(":", 1)
            metrics[k.strip()] = v.strip()

    print("  📈 数据概览：")
    print("  " + "─" * 48)
    if metrics:
        for k, v in metrics.items():
            print("    {:<15} {}".format(k, v))
    else:
        print("    （请按 \"播放量:1000,点赞:50,评论:10,转发:5,完播率:35%\" 格式输入）")
    print("")

    print("  📊 关键指标分析：")
    print("  " + "─" * 48)
    print("")

    indicators = [
        ("完播率", "最核心指标", [
            ("< 15%", "🔴 很低", "开头钩子无效，需要重写前3秒"),
            ("15-30%", "🟡 一般", "钩子有效但中间内容流失，节奏需要加快"),
            ("30-50%", "🟢 良好", "内容结构合理，可优化细节"),
            ("> 50%", "🔵 优秀", "高质量内容，可以复制这个模式"),
        ]),
        ("互动率（(点赞+评论+转发)/播放量）", "衡量内容质量", [
            ("< 1%", "🔴 低", "内容缺乏共鸣点或CTA引导弱"),
            ("1-3%", "🟡 一般", "有基本互动，优化CTA可提升"),
            ("3-5%", "🟢 良好", "内容引发共鸣，继续保持"),
            ("> 5%", "🔵 优秀", "强互动内容，容易被推荐"),
        ]),
        ("点赞率（点赞/播放量）", "衡量认同感", [
            ("< 2%", "🔴 低", "内容可能不够有价值或有争议"),
            ("2-5%", "🟡 一般", "内容ok但缺乏惊喜"),
            ("5-10%", "🟢 良好", "观众认可度高"),
            ("> 10%", "🔵 优秀", "内容非常受欢迎"),
        ]),
        ("转发率（转发/播放量）", "衡量传播力", [
            ("< 0.5%", "🔴 低", "内容实用性或社交货币不足"),
            ("0.5-2%", "🟡 一般", "有一定传播力"),
            ("2-5%", "🟢 良好", "内容有社交传播价值"),
            ("> 5%", "🔵 优秀", "强传播力，可能要爆"),
        ]),
    ]

    for name, importance, levels in indicators:
        print("    📍 {}（{}）".format(name, importance))
        for threshold, status, suggestion in levels:
            print("       {} {} → {}".format(threshold, status, suggestion))
        print("")

    print("  " + "─" * 48)
    print("")
    print("  🔧 优化建议：")
    print("     若完播率低 → 优化前3秒钩子，加快节奏，减少废话")
    print("     若互动率低 → 加强CTA引导，提问式结尾，制造话题")
    print("     若点赞低   → 提供更多价值感/情绪共鸣/认同感")
    print("     若转发低   → 增加实用性/社交货币/争议性观点")
    print("")
    print("  📌 复盘公式：")
    print("     数据 → 诊断问题 → 调整内容 → A/B测试 → 再复盘")
    print("     每发10条视频做一次系统复盘，找出爆款规律")
    print("")


def gen_retention(topic):
    """完播率优化 — 5个提升完播率的脚本技巧"""
    print_header("📈 完播率优化方案 — {}".format(topic))
    print("")

    techniques = [
        {
            "name": "🪝 黄金3秒 — 开场钩子",
            "principle": "前3秒决定生死，用户决定是否划走只需1.5秒",
            "examples": [
                "悬念型：「关于{t}，我要说一个可能颠覆你认知的事实——」（停顿+看镜头）".format(t=topic),
                "痛点型：「还在为{t}发愁？我花了3年踩的坑，3分钟全告诉你」".format(t=topic),
                "反转型：「所有人都说{t}应该这样做——但全错了！」（摇头+手势否定）".format(t=topic),
                "利益型：「学会{t}这个技巧，我一个月省了5000块」（竖起手指）".format(t=topic),
            ],
            "do": [
                "语速比正常快30%，制造紧迫感",
                "怼脸特写 or 走向镜头，拉近距离",
                "第一句话就抛出核心信息，不要铺垫",
                "加入手势/道具/画面变化，吸引注意力",
            ],
            "dont": [
                "不要以「大家好」开头，直接上干货",
                "不要背景太杂乱，分散注意力",
            ],
        },
        {
            "name": "⏱️ 节奏控制 — 每10秒一个兴奋点",
            "principle": "观众注意力曲线每10秒下降一次，必须在下降前刷新注意力",
            "examples": [
                "10秒：「但这还不是最关键的——」（转折）",
                "20秒：「很多人不知道的是——」（切换画面+加字幕强调）",
                "30秒：「接下来这一点，才是{t}的精髓」（降低音量→突然提高）".format(t=topic),
                "40秒：「你猜结果是什么？」（停顿2秒，加悬疑BGM）",
            ],
            "do": [
                "每10秒至少有一个「信息钩子」或「画面切换」",
                "变换语速：快→慢→快，制造韵律感",
                "关键信息用字幕放大+颜色标注",
                "适当使用音效/BGM变化标记转折",
            ],
            "dont": [
                "不要一个镜头超过10秒不切换",
                "不要平铺直叙，像念稿一样",
            ],
        },
        {
            "name": "🎭 悬念设计 — 让观众想看到最后",
            "principle": "提前埋钩子，制造信息缺口，让人必须看到结尾才知道答案",
            "examples": [
                "开头埋雷：「关于{t}有5个技巧，最后一个最重要，直接翻倍」".format(t=topic),
                "中间悬疑：「做到这一步后，神奇的事情发生了——我们最后揭晓」",
                "反转预告：「结局出乎所有人意料，一定要看到最后」",
                "递进期待：「第3个技巧比前两个都强，但第5个才是王炸」",
            ],
            "do": [
                "开头就预告「最后会有彩蛋/最重要的内容」",
                "使用倒叙结构：先展示结果，再回溯过程",
                "每个段落结尾留一个小悬念连接下一段",
                "最后30%放最有价值的内容，不要虎头蛇尾",
            ],
            "dont": [
                "不要太早揭晓答案",
                "不要承诺了彩蛋最后不给",
            ],
        },
        {
            "name": "📊 情绪曲线 — 跌宕起伏抓人心",
            "principle": "好的视频情绪曲线像过山车，有高有低，单一情绪容易让人疲劳",
            "examples": [
                "焦虑→希望：「{t}越来越卷——但掌握这个方法，你就能脱颖而出」".format(t=topic),
                "平静→震惊：「看起来很普通的一个操作——但效果让所有人都惊了」",
                "共鸣→激励：「你是不是也遇到过这种情况？（停顿）其实解决方法超简单」",
                "幽默→干货：「虽然听起来像个段子——但这真的管用，来看数据」",
            ],
            "do": [
                "整体设计：低开→高走→小低谷→超高潮→温暖收尾",
                "在信息密集段之间插入轻松/有趣的内容",
                "用表情和语气变化带动观众情绪",
                "高潮部分配合BGM和特效加强感染力",
            ],
            "dont": [
                "不要全程都是高能，观众会审美疲劳",
                "不要全程都是低沉的知识灌输",
            ],
        },
        {
            "name": "🎯 结尾钩子 — 让完播变互动",
            "principle": "结尾不是结束，是另一个开始。好结尾=高完播+高互动+高关注",
            "examples": [
                "反问型：「你觉得{t}最重要的是哪一点？评论区告诉我」".format(t=topic),
                "预告型：「下期我会分享{t}进阶版，关注我不错过」".format(t=topic),
                "彩蛋型：「评论区扣'要'，我私信发你{t}完整资料」".format(t=topic),
                "挑战型：「如果你也想试试，拍个视频@我，看看谁做得最好」",
            ],
            "do": [
                "结尾语速放慢，给观众反应时间",
                "用手指引导关注按钮方向",
                "明确告诉观众下一步做什么（点赞/关注/评论）",
                "设置互动门槛（扣1/评论关键词/转发）",
            ],
            "dont": [
                "不要突然结束没有引导",
                "不要同时要求太多（最多引导2个动作）",
            ],
        },
    ]

    for i, tech in enumerate(techniques, 1):
        print("  {}/5 {}".format(i, tech["name"]))
        print("  " + "─" * 48)
        print("  原理：{}".format(tech["principle"]))
        print("")
        print("  📝 {} 示例：".format(topic))
        for ex in tech["examples"]:
            print("    • {}".format(ex))
        print("")
        print("  ✅ 建议：")
        for d in tech["do"]:
            print("    + {}".format(d))
        for d in tech["dont"]:
            print("    - {}".format(d))
        print("")
        print("")

    print_divider()
    print("")
    print("  📌 完播率优化公式（{}）：".format(topic))
    print("    完播率 = 黄金3秒留人 × 10秒节奏刷新 × 悬念驱动 × 情绪起伏 × 结尾钩子")
    print("")
    print("  📊 完播率参考标准：")
    print("    15秒视频 > 60% = 优秀   > 45% = 合格   < 30% = 需优化")
    print("    60秒视频 > 40% = 优秀   > 25% = 合格   < 15% = 需优化")
    print("    3分钟以上 > 30% = 优秀   > 20% = 合格   < 10% = 需优化")
    print("")
    print("  💡 黄金法则：如果完播率低，先优化前3秒！70%的流失发生在前3秒。")
    print("")


def _divider_str(char="─", length=50):
    return char * length


def show_help():
    """显示帮助信息"""
    print_header("📹 video-script-creator · 短视频脚本生成器")

    print("支持平台：抖音 | 快手 | YouTube Shorts | B站")
    print("")
    print_divider()
    print("")
    print("📖 命令列表：")
    print("")

    commands = [
        ("script \"主题\"", "生成完整脚本（开场-主体-结尾+分镜提示）"),
        ("", "  选项: --platform douyin|kuaishou|youtube|bilibili"),
        ("", "         --duration 30|60|90"),
        ("hook \"主题\"", "生成5个开场钩子（前3秒留人）"),
        ("title \"主题\"", "生成5个爆款标题"),
        ("outline \"主题\"", "生成视频大纲"),
        ("cta \"主题\"", "生成结尾引导互动文案"),
        ("storyboard \"主题\"", "完整分镜脚本（画面+旁白+字幕+BGM）"),
        ("series \"主题\" \"集数\"", "系列视频规划（每集主题+大纲）"),
        ("review \"数据\"", "视频数据复盘（完播率、互动率分析）"),
        ("retention \"主题\"", "完播率优化（5个脚本技巧+具体示例）"),
        ("trending", "热门视频类型/方向"),
        ("help", "显示此帮助信息"),
    ]

    for cmd, desc in commands:
        if cmd:
            print("  {:<30s} {}".format(cmd, desc))
        else:
            print("  {:<30s} {}".format("", desc))

    print("")
    print_divider()
    print("")
    print("📝 示例：")
    print("")
    print("  video-script.sh script \"咖啡拉花教程\" --platform douyin --duration 60")
    print("  video-script.sh hook \"租房避坑\"")
    print("  video-script.sh title \"Python入门\"")
    print("  video-script.sh trending")
    print("")


# ============================================================
# 主入口
# ============================================================

def main():
    if len(sys.argv) < 2:
        show_help()
        return

    command = sys.argv[1]

    if command == "help":
        show_help()
        return

    if command == "trending":
        gen_trending()
        return

    # 以下命令需要主题参数
    if command in ("script", "hook", "title", "outline", "cta", "storyboard", "series", "review", "retention"):
        # 解析参数
        parser = argparse.ArgumentParser(add_help=False)
        parser.add_argument("command")
        parser.add_argument("topic", nargs="?", default=None)
        parser.add_argument("episodes", nargs="?", default="5")
        parser.add_argument("--platform", default="douyin",
                            choices=["douyin", "kuaishou", "youtube", "bilibili"])
        parser.add_argument("--duration", type=int, default=60,
                            choices=[30, 60, 90])

        args = parser.parse_args()

        if not args.topic:
            print("❌ 请提供主题！")
            print("用法：video-script.sh {} \"你的主题\"".format(command))
            sys.exit(1)

        topic = args.topic

        if command == "script":
            gen_script(topic, args.platform, args.duration)
        elif command == "hook":
            gen_hooks_10(topic)
        elif command == "title":
            gen_titles(topic)
        elif command == "outline":
            gen_outline(topic)
        elif command == "cta":
            gen_cta(topic)
        elif command == "storyboard":
            gen_storyboard(topic, args.platform, args.duration)
        elif command == "series":
            try:
                ep_count = int(args.episodes)
            except (ValueError, TypeError):
                ep_count = 5
            gen_series(topic, ep_count)
        elif command == "review":
            gen_review(topic)
        elif command == "retention":
            gen_retention(topic)
    else:
        print("❌ 未知命令: {}".format(command))
        print("运行 'video-script.sh help' 查看帮助")
        sys.exit(1)


if __name__ == "__main__":
    main()
