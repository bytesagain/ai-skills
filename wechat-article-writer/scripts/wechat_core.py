#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# wechat_core.py - 微信公众号文章生成器核心逻辑
# 兼容 Python 3.6+（不使用 f-string）

from __future__ import print_function
import sys
import random

# ============================================================
# 模板数据
# ============================================================

POWER_WORDS = [
    '竟然', '居然', '必看', '揭秘', '震惊', '颠覆',
    '真相', '秘密', '反转', '逆袭', '爆款', '刷屏',
    '扎心', '戳心', '泪目', '炸裂',
]

EMOTIONS = [
    '太绝了', '绝了', '真香', '后悔没早知道', '看完沉默了',
    '建议收藏', '赶紧收藏', '强烈推荐', '不看亏大了', '错过可惜',
]

NUMBERS = ['3个', '5个', '7个', '10个', '99%的人']

TITLE_TEMPLATES = [
    '{num}不知道的{topic}真相，第{n}个{pw}让人{emo}！',
    '{pw}！{topic}原来可以这样做，{emo}',
    '关于{topic}，{num}都不知道的秘密，{pw}{emo}',
    '{topic}的{num}大误区，{pw}很多人还在犯！',
    '为什么{topic}总是做不好？看完这篇{pw}{emo}',
]

SUMMARY_TEMPLATES = [
    '关于{topic}，这可能是我看过最透彻的一篇文章了。强烈建议收藏！',
    '刷到一篇关于{topic}的干货，看完{pw}受益匪浅，分享给需要的朋友。',
    '{topic}这件事，原来我们都想错了。这篇讲得太好了，{emo}！',
    '终于有人把{topic}讲明白了！后悔没早看到，赶紧转发收藏。',
    '一篇关于{topic}的好文，信息量很大，值得反复看。{emo}',
]

OUTLINE_SECTIONS = [
    '一、引言——为什么{topic}值得关注？',
    '二、现状分析——{topic}的现状与痛点',
    '三、核心观点——关于{topic}的{n}个关键认知',
    '四、实操指南——如何在{topic}中脱颖而出',
    '五、案例拆解——成功案例深度解析',
    '六、常见误区——{num}都踩过的坑',
    '七、总结与行动建议',
]

CTA_TEMPLATES = [
    (
        '\n'
        '━━━━━━━━━━━━━━━━━━━━\n'
        '\n'
        '**如果这篇文章对你有帮助：**\n'
        '\n'
        '👍 点个「赞」，让我知道你在看\n'
        '⭐ 点个「在看」，让更多人看到\n'
        '🔄 「转发」给需要的朋友\n'
        '\n'
        '你的每一次互动，都是对我最大的鼓励 ❤️\n'
        '\n'
        '━━━━━━━━━━━━━━━━━━━━\n'
    ),
    (
        '\n'
        '━━━━━━━━━━━━━━━━━━━━\n'
        '\n'
        '**写在最后：**\n'
        '\n'
        '看到这里的你，一定是一个爱学习的人 📚\n'
        '\n'
        '如果觉得有收获，别忘了：\n'
        '✅ 点「赞」= 认可\n'
        '✅ 点「在看」= 支持\n'
        '✅ 「转发」= 利他\n'
        '\n'
        '关注我，每天进步一点点 💪\n'
        '\n'
        '━━━━━━━━━━━━━━━━━━━━\n'
    ),
    (
        '\n'
        '━━━━━━━━━━━━━━━━━━━━\n'
        '\n'
        '**感谢你的阅读！**\n'
        '\n'
        '📌 觉得有用？长按点「赞」+「在看」\n'
        '📌 想让朋友也看到？点右上角「转发」\n'
        '📌 想第一时间收到更新？点「关注」\n'
        '\n'
        '我们下篇见 👋\n'
        '\n'
        '━━━━━━━━━━━━━━━━━━━━\n'
    ),
]

TRENDING_TOPICS = [
    {
        'category': '🤖 AI与科技',
        'topics': [
            'ChatGPT/AI工具实操教程', 'AI对各行业的影响',
            '普通人如何用AI赚钱', 'AI绘画入门指南', '大模型对比评测',
        ],
    },
    {
        'category': '💰 个人成长与赚钱',
        'topics': [
            '副业赚钱实操', '自媒体运营干货', '时间管理方法论',
            '认知升级', '35岁职场破局',
        ],
    },
    {
        'category': '🏠 生活方式',
        'topics': [
            '极简生活', '居家好物推荐', '健康饮食指南',
            '睡眠质量提升', '断舍离实践',
        ],
    },
    {
        'category': '📚 知识干货',
        'topics': [
            '读书笔记精华', '行业深度分析', '思维模型应用',
            '心理学实用技巧', '经济趋势解读',
        ],
    },
    {
        'category': '👨\u200d👩\u200d👧 情感与关系',
        'topics': [
            '亲密关系经营', '职场人际关系', '原生家庭影响',
            '沟通技巧', '情绪管理',
        ],
    },
    {
        'category': '🔥 热点追踪',
        'topics': [
            '社会热点深度解读', '行业政策变化解析', '热门影视剧点评',
            '节日节气营销', '年度盘点/预测',
        ],
    },
]

STYLE_CONFIGS = {
    '干货': {
        'intro': '今天分享一个关于{topic}的硬核干货，全文信息量巨大，建议先收藏再看。',
        'tone': '专业、理性、数据驱动',
        'sections': ['核心概念', '方法论', '实操步骤', '常见问题', '总结'],
    },
    '故事': {
        'intro': '今天想给大家讲一个关于{topic}的真实故事，看完之后你一定会有所触动。',
        'tone': '感性、共情、娓娓道来',
        'sections': ['故事开端', '转折冲突', '深度思考', '启发感悟', '回归现实'],
    },
    '评测': {
        'intro': '最近深度体验了一番{topic}，今天来做一个全面客观的评测，帮你避坑。',
        'tone': '客观、详细、有对比',
        'sections': ['评测背景', '外观/第一印象', '核心体验', '优缺点对比', '购买建议'],
    },
    '教程': {
        'intro': '手把手教你搞定{topic}！零基础也能学会，跟着做就行。',
        'tone': '耐心、细致、步骤清晰',
        'sections': ['准备工作', '第一步', '第二步', '第三步', '进阶技巧'],
    },
    '观点': {
        'intro': '关于{topic}，我有一些不同的看法。可能会引起争议，但我觉得有必要说出来。',
        'tone': '犀利、有态度、引发思考',
        'sections': ['现象观察', '主流观点', '我的观点', '论据支撑', '结论'],
    },
}

GOLDEN_QUOTES = [
    '**真正厉害的人，从来不是天赋异禀，而是在正确的方向上持续积累。**',
    '**所有看起来毫不费力的背后，都藏着超乎想象的努力。**',
    '**认知决定选择，选择决定命运。这不是鸡汤，是事实。**',
    '**世界上最大的成本，不是金钱，而是时间和注意力。**',
    '**不要用战术上的勤奋，掩盖战略上的懒惰。**',
    '**方向对了，慢一点也无妨；方向错了，越努力越尴尬。**',
    '**成长的本质，是不断打破旧认知，建立新认知。**',
    '**普通人最大的杠杆，不是资本，而是认知差。**',
]


# ============================================================
# 工具函数
# ============================================================

def pick(lst):
    return random.choice(lst)


def gen_title(topic):
    t = pick(TITLE_TEMPLATES)
    return t.format(
        topic=topic,
        num=pick(NUMBERS),
        n=random.randint(2, 5),
        pw=pick(POWER_WORDS),
        emo=pick(EMOTIONS),
    )


def print_divider():
    print('=' * 50)


def print_section(title, content=''):
    print()
    print('## {}'.format(title))
    print()
    if content:
        print(content)
        print()


# ============================================================
# 命令实现
# ============================================================

def cmd_help():
    print()
    print('微信公众号文章生成器 wechat.sh')
    print('======================================')
    print()
    print('用法:')
    print('  wechat.sh article "主题" [--style 干货|故事|评测|教程|观点]')
    print('      生成完整公众号文章（标题+导语+正文+结语+引导关注）')
    print()
    print('  wechat.sh title "主题"')
    print('      生成5个10w+爆款标题')
    print()
    print('  wechat.sh summary "主题"')
    print('      生成文章摘要（朋友圈转发语）')
    print()
    print('  wechat.sh outline "主题"')
    print('      生成文章大纲')
    print()
    print('  wechat.sh cta "关注|转发|留言"')
    print('      生成行动号召结尾模板（按类型）')
    print()
    print('  wechat.sh trending')
    print('      热门公众号选题方向')
    print()
    print('  wechat.sh series "主题" [篇数]')
    print('      系列文章规划（默认5篇）')
    print()
    print('  wechat.sh headline-ab "主题"')
    print('      生成5对A/B测试标题')
    print()
    print('  wechat.sh data-article "数据主题"')
    print('      生成数据型文章模板')
    print()
    print('  wechat.sh diagnose "标题" "阅读量" "粉丝数"')
    print('      文章诊断（打开率+标题分析+优化建议）')
    print()
    print('  wechat.sh help')
    print('      显示本帮助信息')
    print()
    print('风格选项（article命令）:')
    print('  干货  — 专业理性，信息密度高')
    print('  故事  — 感性共情，以故事打动人')
    print('  评测  — 客观详细，有对比有结论')
    print('  教程  — 手把手教学，步骤清晰')
    print('  观点  — 犀利有态度，引发思考')
    print()


def cmd_title(args):
    if not args:
        print('请提供主题，例如: wechat.sh title "时间管理"')
        sys.exit(1)
    topic = args[0]
    print()
    print('🔥 关于「{}」的5个10w+爆款标题'.format(topic))
    print_divider()
    seen = set()
    count = 0
    attempts = 0
    while count < 5 and attempts < 50:
        t = gen_title(topic)
        attempts += 1
        if t not in seen:
            seen.add(t)
            count += 1
            print('{}. {}'.format(count, t))
    print()
    print('💡 标题公式：数字 + 情绪词 + 好奇心缺口')
    print('📌 建议A/B测试，选择点击率最高的标题')
    print()


def cmd_summary(args):
    if not args:
        print('请提供主题，例如: wechat.sh summary "AI绘画"')
        sys.exit(1)
    topic = args[0]
    pw = pick(POWER_WORDS)
    emo = pick(EMOTIONS)
    print()
    print('📋 关于「{}」的朋友圈转发语'.format(topic))
    print_divider()
    for i, tmpl in enumerate(SUMMARY_TEMPLATES, 1):
        text = tmpl.format(topic=topic, pw=pw, emo=emo)
        print('{}. {}'.format(i, text))
        print()
    print('💡 Tips: 朋友圈转发语要短、有悬念、让人想点开')
    print()


def cmd_outline(args):
    if not args:
        print('请提供主题，例如: wechat.sh outline "自媒体运营"')
        sys.exit(1)
    topic = args[0]
    title = gen_title(topic)
    print()
    print('📑 关于「{}」的文章大纲'.format(topic))
    print_divider()
    print()
    print('标题：{}'.format(title))
    print()
    for section in OUTLINE_SECTIONS:
        text = section.format(
            topic=topic,
            n=random.randint(3, 7),
            num=pick(NUMBERS),
        )
        print(text)
    print()
    print('💡 大纲仅供参考，可根据实际内容调整章节')
    print()


def cmd_cta():
    print()
    print('🎯 引导关注/转发结尾模板')
    print_divider()
    for i, cta in enumerate(CTA_TEMPLATES, 1):
        print('--- 模板 {} ---'.format(i))
        print(cta)
    print('💡 选一个适合你风格的模板，稍作修改即可使用')
    print()


def cmd_trending():
    print()
    print('🔥 热门公众号选题方向')
    print_divider()
    print()
    for cat in TRENDING_TOPICS:
        print(cat['category'])
        for t in cat['topics']:
            print('  - {}'.format(t))
        print()
    print('💡 选题建议：结合自身定位 + 热点 + 读者需求，找到交叉点')
    print('📌 可以用 wechat.sh title "选题" 为感兴趣的方向生成标题')
    print()


def _gen_paragraphs(style, topic, sec):
    """根据风格和章节生成段落列表"""
    if style == '干货':
        return [
            '关于{}的{}，很多人都存在误解。'.format(topic, sec),
            '',
            '实际上，真正理解这一点的人并不多。根据相关数据显示，'
            '超过80%的人在{}方面都走了弯路。'.format(topic),
            '',
            pick(GOLDEN_QUOTES),
            '',
            '具体来说，你需要做到以下几点：',
            '',
            '**第一，** 建立正确的认知框架',
            '**第二，** 制定可执行的行动计划',
            '**第三，** 持续迭代，定期复盘',
            '',
            '这不是空谈，而是经过验证的方法论。',
        ]
    elif style == '故事':
        return [
            '说到{}，我想起了一个真实的故事。'.format(sec),
            '',
            '那是在一个普通的工作日，关于{}的一切似乎都很平常。'.format(topic),
            '',
            '但转折就在那一刻发生了……',
            '',
            pick(GOLDEN_QUOTES),
            '',
            '回头看，正是这次经历，彻底改变了我对{}的认知。'.format(topic),
        ]
    elif style == '评测':
        return [
            '在{}这个维度上，我给出 ⭐⭐⭐⭐ 的评价（满分5星）。'.format(sec),
            '',
            '**优点：**',
            '- 在{}方面表现出色'.format(topic),
            '- 用户体验流畅',
            '- 性价比较高',
            '',
            '**不足：**',
            '- 部分细节有待完善',
            '- 学习曲线略陡',
            '',
            pick(GOLDEN_QUOTES),
        ]
    elif style == '教程':
        return [
            '📌 **{}**'.format(sec),
            '',
            '这一步非常关键，请仔细按照以下操作：',
            '',
            '步骤说明：',
            '1. 打开相关工具/平台',
            '2. 找到{}相关的设置'.format(topic),
            '3. 按照图示进行配置',
            '4. 确认并保存',
            '',
            '⚠️ **注意事项：** 这里容易出错，记得仔细核对！',
            '',
            pick(GOLDEN_QUOTES),
        ]
    elif style == '观点':
        return [
            '关于{}，主流观点认为……'.format(sec),
            '',
            '但我要说：**这个观点是有问题的。**',
            '',
            '为什么？因为当我们深入审视{}的本质时会发现，'.format(topic)
            + '很多所谓的「常识」其实经不起推敲。',
            '',
            pick(GOLDEN_QUOTES),
            '',
            '我知道这个观点可能会引起争议，但数据和事实不会说谎。',
        ]
    else:
        return ['（{}相关内容）'.format(sec)]


def cmd_article(args):
    if not args:
        print('请提供主题，例如: wechat.sh article "时间管理" --style 干货')
        sys.exit(1)
    topic = args[0]
    style = '干货'
    if '--style' in args:
        idx = args.index('--style')
        if idx + 1 < len(args):
            style = args[idx + 1]
    if style not in STYLE_CONFIGS:
        print('未知风格「{}」，可选：干货、故事、评测、教程、观点'.format(style))
        sys.exit(1)

    cfg = STYLE_CONFIGS[style]
    title = gen_title(topic)
    intro = cfg['intro'].format(topic=topic)
    sections = cfg['sections']

    print()
    print_divider()
    print('📝 微信公众号文章 | 风格：{}'.format(style))
    print_divider()
    print()

    # 标题
    print('# {}'.format(title))
    print()

    # 导语
    print('> {}'.format(intro))
    print()

    # 正文各段
    for sec in sections:
        print_section(sec)
        paragraphs = _gen_paragraphs(style, topic, sec)
        for p in paragraphs:
            print(p)
        print()

    # 结语
    print_section('写在最后')
    print('关于{}，今天就聊到这里。'.format(topic))
    print()
    print('希望这篇文章能给你带来一些启发和帮助。')
    print()
    print(pick(GOLDEN_QUOTES))
    print()

    # CTA
    print(pick(CTA_TEMPLATES))

    print_divider()
    print('📌 以上为模板生成的文章框架，请根据实际内容填充细节')
    print('💡 建议：用 wechat.sh title "{}" 多生成几个标题做A/B测试'.format(topic))
    print()


def cmd_series(args):
    if len(args) < 1:
        print('请提供主题，例如: wechat.sh series "AI工具" 5')
        sys.exit(1)
    topic = args[0]
    try:
        count = int(args[1]) if len(args) > 1 else 5
    except ValueError:
        count = 5

    print()
    print('📚 系列文章规划 — 「{}」（共{}篇）'.format(topic, count))
    print_divider()
    print()

    phases = [
        ('认知篇', '建立基础认知，吸引新读者关注', [
            '什么是{}？这是我见过最通俗的解释'.format(topic),
            '为什么你必须了解{}？3个理由让你无法忽视'.format(topic),
            '关于{}，99%的人都存在这些误解'.format(topic),
        ]),
        ('方法篇', '提供实操干货，建立专业形象', [
            '{}入门指南：从零到一的完整攻略'.format(topic),
            '{}的5个核心技巧，学会一个就够用'.format(topic),
            '手把手教你搞定{}，看完就能上手'.format(topic),
        ]),
        ('案例篇', '用案例增加说服力和可信度', [
            '{}实战案例：他是如何做到的？'.format(topic),
            '{}踩坑实录：花了3万买来的教训'.format(topic),
            '{}案例拆解：成功vs失败的关键差异'.format(topic),
        ]),
        ('进阶篇', '深度内容留住核心读者', [
            '{}进阶：90%的人不知道的高级玩法'.format(topic),
            '{}的未来趋势：提前布局才能赢'.format(topic),
            '从{}看行业变化：深度分析报告'.format(topic),
        ]),
    ]

    ep = 1
    for phase_name, phase_desc, templates in phases:
        if ep > count:
            break
        print('📂 {} — {}'.format(phase_name, phase_desc))
        print('─' * 48)
        eps_in_phase = max(1, count // len(phases))
        for j in range(eps_in_phase):
            if ep > count:
                break
            template = templates[j % len(templates)]
            print()
            print('  第{}篇：{}'.format(ep, template))
            print('  ├─ 风格：{}'.format(random.choice(list(STYLE_CONFIGS.keys()))))
            print('  ├─ 预计阅读：{}-{}分钟'.format(random.randint(3, 5), random.randint(6, 10)))
            print('  ├─ 关键词：{}、{}、{}'.format(
                topic,
                random.choice(['干货', '攻略', '方法论', '实操', '案例']),
                random.choice(['入门', '进阶', '避坑', '趋势', '分析']),
            ))
            print('  └─ CTA：引导关注系列，预告下一篇')
            ep += 1
        print()

    print('─' * 48)
    print()
    print('📋 系列文章运营策略：')
    print('   • 固定更新频率：每周2-3篇，培养读者期待')
    print('   • 首篇文章加「系列导读」，列出所有篇目')
    print('   • 每篇开头回顾上篇 + 预告本篇核心内容')
    print('   • 文末引导关注：「关注不迷路，系列持续更新中」')
    print('   • 合集功能：在公众号菜单设置系列文章合集')
    print('   • 朋友圈推广：每篇发布时发朋友圈配合推荐语')
    print()


def cmd_cta_types(args):
    cta_type = args[0] if args else '关注'
    print()
    print('🎯 行动号召结尾 — 类型：{}'.format(cta_type))
    print_divider()
    print()

    cta_map = {
        '关注': [
            (
                '**如果你觉得这篇有价值：**\n\n'
                '👆 点击上方蓝字「公众号名」关注我\n'
                '📌 设为「星标」，第一时间收到更新\n'
                '💬 加入读者群，和同频的人一起成长\n\n'
                '每周更新2-3篇干货，陪你一起进步 💪'
            ),
            (
                '写了这么多，希望对你有帮助。\n\n'
                '如果你想持续获取更多关于这个领域的干货：\n'
                '✅ 长按下方二维码关注\n'
                '✅ 回复「资料」获取独家学习包\n'
                '✅ 加入读者交流群（群内每周答疑）\n\n'
                '你的关注，是我持续输出的最大动力 ❤️'
            ),
        ],
        '转发': [
            (
                '**如果这篇文章帮到了你：**\n\n'
                '🔄 转发到朋友圈，帮助更多人看到\n'
                '💌 发给你觉得需要的朋友\n'
                '📣 好内容值得被更多人看到\n\n'
                '你的每一次转发，都可能帮到一个正在迷茫的人。'
            ),
            (
                '看到这里的你，一定是一个爱学习的人。\n\n'
                '如果你身边也有人需要这些信息：\n'
                '→ 长按文章，点击「转发」\n'
                '→ 或者截图发到群里讨论\n\n'
                '独乐乐不如众乐乐，好文章要一起看 📖'
            ),
        ],
        '留言': [
            (
                '**今日互动话题：**\n\n'
                '看完这篇文章，你最大的收获是什么？\n\n'
                '📝 在评论区留下你的想法\n'
                '💡 我会精选优质留言置顶\n'
                '🎁 点赞最高的留言送神秘礼物\n\n'
                '期待看到你的精彩观点 👇'
            ),
            (
                '聊了这么多，现在轮到你了——\n\n'
                '关于今天的话题，你的看法是？\n'
                '你有没有类似的经历或故事？\n\n'
                '📝 写在评论区，我每条都会看\n'
                '💬 优质留言我会单独回复\n\n'
                '来，聊聊 👇'
            ),
        ],
    }

    # 默认全部展示
    if cta_type not in cta_map:
        print('  可选类型：关注、转发、留言')
        print('  展示所有类型：')
        print()
        for t, templates in cta_map.items():
            print('  ── {} 型CTA ──'.format(t))
            for i, tmpl in enumerate(templates, 1):
                print('  模板{}：'.format(i))
                print(tmpl)
                print()
    else:
        templates = cta_map[cta_type]
        for i, tmpl in enumerate(templates, 1):
            print('  ── 模板{} ──'.format(i))
            print(tmpl)
            print()

    print('💡 CTA技巧：')
    print('   • 一篇文章只用1种主CTA，不要贪多')
    print('   • CTA要具体：告诉读者做什么、怎么做')
    print('   • 给出互动理由：奖励、好奇心、归属感')
    print('   • 用问题式CTA效果最好（引发讨论）')
    print()


def cmd_headline_ab(args):
    if not args:
        print('请提供主题，例如: wechat.sh headline-ab "AI工具"')
        sys.exit(1)
    topic = args[0]

    print()
    print('🔬 A/B测试标题 — 「{}」'.format(topic))
    print_divider()
    print()
    print('  5组对照标题，帮你测出最高点击率：')
    print()

    ab_pairs = [
        ('数字型 vs 问题型',
         gen_title(topic),
         '关于{}，你真的了解吗？看完这篇你会改变看法'.format(topic)),
        ('恐惧型 vs 利益型',
         '不了解{}的后果有多严重？{}的人都后悔了'.format(topic, pick(NUMBERS)),
         '掌握{}之后，我的生活发生了翻天覆地的变化'.format(topic)),
        ('故事型 vs 清单型',
         '一个关于{}的真实故事，看完{}……'.format(topic, pick(EMOTIONS)),
         '{}必备的{}件事，最后一个太重要了'.format(topic, random.randint(3, 10))),
        ('权威型 vs 亲民型',
         '专家终于说出了{}的真相，{}！'.format(topic, pick(POWER_WORDS)),
         '我和{}打交道{}年，总结出这些大实话'.format(topic, random.randint(3, 10))),
        ('悬念型 vs 直给型',
         '关于{}，有一件事我一直不敢说……今天豁出去了'.format(topic),
         '{}全攻略：从入门到精通，看这一篇就够'.format(topic)),
    ]

    for i, (category, title_a, title_b) in enumerate(ab_pairs, 1):
        print('  第{}组 ({})'.format(i, category))
        print('  ┌─ A: {}'.format(title_a))
        print('  └─ B: {}'.format(title_b))
        print()

    print('─' * 48)
    print()
    print('📊 A/B测试方法：')
    print('   1. 在不同时间段发布相同内容但不同标题的文章')
    print('   2. 或在多个平台分别测试（公众号+知乎+头条）')
    print('   3. 记录72小时内的打开率、阅读量、分享率')
    print('   4. 样本量至少500次曝光才有统计意义')
    print('   5. 持续积累数据，找到适合你账号的标题风格')
    print()
    print('💡 标题要素排行（按点击率贡献）：')
    print('   ① 数字（提升23%） ② 情绪词（提升18%）')
    print('   ③ 悬念/好奇（提升15%） ④ 痛点/恐惧（提升12%）')
    print()


def cmd_data_article(args):
    if not args:
        print('请提供数据描述，例如: wechat.sh data-article "2024年AI行业数据"')
        sys.exit(1)
    data_desc = args[0]

    title = gen_title(data_desc)
    print()
    print_divider()
    print('📊 数据型文章 — {}'.format(data_desc))
    print_divider()
    print()

    print('# {}'.format(title))
    print()
    print('> 用数据说话，让事实替你论证。本文基于{}相关数据整理分析。'.format(data_desc))
    print()

    print('## 一、数据概览')
    print()
    print('> 📊 **核心数据一览**')
    print()
    print('| 指标 | 数值 | 同比变化 | 趋势 |')
    print('|------|------|----------|------|')
    print('| 核心指标A | 待填写 | +XX% | 📈 |')
    print('| 核心指标B | 待填写 | -XX% | 📉 |')
    print('| 核心指标C | 待填写 | +XX% | 📈 |')
    print()
    print('**💡 一句话总结：** （用一句话概括数据最重要的发现）')
    print()

    print('## 二、趋势分析')
    print()
    print('### 趋势1：XXX呈上升趋势')
    print()
    print('```')
    print('  2021  ████████████       35%')
    print('  2022  ██████████████     42%')
    print('  2023  ████████████████   51%')
    print('  2024  ██████████████████ 58%')
    print('```')
    print()
    print('从数据可以明显看出，{}领域正在经历快速增长。'.format(data_desc))
    print()
    print(pick(GOLDEN_QUOTES))
    print()

    print('### 趋势2：XXX值得关注')
    print()
    print('> 📌 **关键发现：** 数据显示......（请用具体数据支撑）')
    print()

    print('## 三、对比分析')
    print()
    print('| 维度 | 类别A | 类别B | 差距 |')
    print('|------|-------|-------|------|')
    print('| 维度1 | XX | XX | XX% |')
    print('| 维度2 | XX | XX | XX% |')
    print('| 维度3 | XX | XX | XX% |')
    print()
    print('**对比结论：** ......（基于数据得出的结论）')
    print()

    print('## 四、深度解读')
    print()
    print('### 这些数据背后意味着什么？')
    print()
    print('1. **对个人的影响**：......')
    print('2. **对行业的影响**：......')
    print('3. **对未来的启示**：......')
    print()
    print(pick(GOLDEN_QUOTES))
    print()

    print('## 五、行动建议')
    print()
    print('基于以上数据分析，给出{}条实操建议：'.format(random.randint(3, 5)))
    print()
    print('- [ ] 建议1：......')
    print('- [ ] 建议2：......')
    print('- [ ] 建议3：......')
    print()

    print('## 写在最后')
    print()
    print('数据不会说谎，但数据也不会主动告诉你答案。')
    print('希望这篇关于{}的数据分析，能给你带来一些新的认知和启发。'.format(data_desc))
    print()
    print(pick(GOLDEN_QUOTES))
    print()
    print(pick(CTA_TEMPLATES))

    print_divider()
    print('📌 以上为数据型文章框架，请替换具体数据和分析')
    print('💡 数据型文章关键：数据准确、图表清晰、结论明确、行动导向')
    print()


# ============================================================
# 主入口
def cmd_diagnose(args):
    if len(args) < 3:
        print('用法: wechat.sh diagnose "标题" "阅读量" "粉丝数"')
        print('示例: wechat.sh diagnose "为什么你总是存不下钱" "1500" "10000"')
        sys.exit(1)

    title = args[0]
    try:
        reads = int(args[1].replace(',', '').replace(' ', ''))
    except ValueError:
        print('阅读量请输入数字')
        sys.exit(1)
    try:
        followers = int(args[2].replace(',', '').replace(' ', ''))
    except ValueError:
        print('粉丝数请输入数字')
        sys.exit(1)

    if followers <= 0:
        print('粉丝数必须大于0')
        sys.exit(1)

    open_rate = reads / followers * 100

    print()
    print_divider()
    print('🔍 文章诊断报告')
    print_divider()
    print()
    print('  📝 标题：「{}」'.format(title))
    print('  📊 阅读量：{:,}'.format(reads))
    print('  👥 粉丝数：{:,}'.format(followers))
    print('  📈 打开率：{:.1f}%'.format(open_rate))
    print()

    # 打开率评级
    if open_rate >= 8:
        level = '🟢 优秀'
        level_desc = '恭喜！打开率远超行业平均，标题和内容都很棒'
    elif open_rate >= 5:
        level = '🟢 良好'
        level_desc = '高于行业平均水平，还有优化空间'
    elif open_rate >= 3:
        level = '🟡 一般'
        level_desc = '接近行业平均（3-5%），需要优化标题吸引力'
    elif open_rate >= 1:
        level = '🟠 偏低'
        level_desc = '低于行业平均，标题和推送时间都需要调整'
    else:
        level = '🔴 危险'
        level_desc = '打开率极低，需要全面诊断账号健康度'

    print('  评级：{}'.format(level))
    print('  诊断：{}'.format(level_desc))
    print()
    print_divider()
    print()

    # 标题分析
    print('  📋 标题分析：')
    print()

    title_len = len(title)
    issues = []
    strengths = []

    # 长度分析
    if title_len > 30:
        issues.append('标题过长（{}字），超过30字会被截断，建议控制在20-28字'.format(title_len))
    elif title_len < 10:
        issues.append('标题过短（{}字），信息量不足，建议扩展到15-25字'.format(title_len))
    else:
        strengths.append('标题长度合适（{}字）'.format(title_len))

    # 数字检测
    has_number = any(c.isdigit() for c in title)
    if has_number:
        strengths.append('包含数字，增加具体感和可信度')
    else:
        issues.append('缺少数字——加入数字可提升17%的点击率（如「3个方法」「90%的人」）')

    # 情绪词检测
    emotion_words = ['竟然', '居然', '必看', '揭秘', '震惊', '颠覆', '真相',
                     '秘密', '反转', '逆袭', '扎心', '绝了', '真香', '后悔',
                     '亏大', '可惜', '千万别', '一定要', '赶紧']
    found_emotions = [w for w in emotion_words if w in title]
    if found_emotions:
        strengths.append('包含情绪词「{}」，能引发好奇心'.format('、'.join(found_emotions)))
    else:
        issues.append('缺少情绪词——加入「竟然/必看/真相/后悔」等可提升打开率')

    # 疑问句检测
    has_question = any(c in title for c in ['？', '?', '吗', '呢', '嘛'])
    if has_question:
        strengths.append('使用了疑问句式，能激发好奇心')
    else:
        issues.append('尝试用疑问句式——「为什么……？」「你知道……吗？」提升好奇心')

    # 痛点/利益检测
    benefit_words = ['如何', '怎么', '方法', '技巧', '攻略', '指南', '避坑',
                     '省钱', '赚钱', '免费', '涨薪', '升职']
    found_benefits = [w for w in benefit_words if w in title]
    if found_benefits:
        strengths.append('有利益暗示「{}」，用户能感知价值'.format('、'.join(found_benefits)))

    if strengths:
        print('  ✅ 优点：')
        for s_item in strengths:
            print('    + {}'.format(s_item))
        print()

    if issues:
        print('  ⚠️ 问题：')
        for issue in issues:
            print('    - {}'.format(issue))
        print()

    print_divider()
    print()

    # 标题优化建议
    print('  ✨ 标题优化示例（5个方向）：')
    print()

    # 提取关键词
    topic = title.replace('？', '').replace('?', '').replace('！', '').replace('!', '')
    optimized = [
        ('数字+痛点型', '{}个关于{}的真相，看完少走3年弯路'.format(
            random.choice(['3', '5', '7']), topic)),
        ('好奇心型', '关于{}，{}都不知道的秘密'.format(
            topic, random.choice(NUMBERS))),
        ('反转型', '{}？大多数人都想错了！真相竟然是……'.format(topic)),
        ('利益驱动型', '学会这一招{}，效率直接翻倍（建议收藏）'.format(topic)),
        ('FOMO型', '{}最全指南，再不看就晚了！'.format(topic)),
    ]

    for i, (style, new_title) in enumerate(optimized, 1):
        print('  {}. 【{}】'.format(i, style))
        print('     {}'.format(new_title))
        print()

    print_divider()
    print()

    # 综合提升建议
    print('  🎯 提升打开率的综合建议：')
    print()

    if open_rate < 3:
        print('  ❗ 当前打开率{:.1f}%，优先解决以下问题：'.format(open_rate))
        print('    1. 标题优化：参考上面5个方向重写标题')
        print('    2. 推送时间：最佳时段 20:00-22:00（晚间阅读高峰）')
        print('    3. 粉丝质量：检查是否有大量僵尸粉拉低数据')
        print('    4. 封面图片：加入吸引力的封面（配合标题）')
        print('    5. 摘要优化：朋友圈转发语要有悬念，引人点击')
    elif open_rate < 5:
        print('  💡 打开率{:.1f}%，接近平均，优化方向：'.format(open_rate))
        print('    1. A/B测试标题（用 headline-ab 命令）')
        print('    2. 尝试不同推送时间（周二/四 20:00效果最佳）')
        print('    3. 在标题中加入更强的情绪钩子')
        print('    4. 利用系列文章培养阅读习惯')
    else:
        print('  🎉 打开率{:.1f}%，表现{}！继续保持：'.format(
            open_rate, '优秀' if open_rate >= 8 else '良好'))
        print('    1. 分析这篇标题成功的要素，形成标题公式')
        print('    2. 复制成功模式到后续文章')
        print('    3. 关注转发率和在看率，提升二次传播')

    print()
    print('  📊 行业打开率参考：')
    print('    1000粉以下：8-15%（粉丝精准，打开率高）')
    print('    1000-1万粉：5-10%')
    print('    1万-10万粉：3-8%')
    print('    10万+粉：  2-5%（粉丝基数大，比率自然下降）')
    print()


# ============================================================

def main():
    if len(sys.argv) < 2:
        cmd_help()
        return

    command = sys.argv[1]
    rest = sys.argv[2:]

    dispatch = {
        'help': lambda: cmd_help(),
        'title': lambda: cmd_title(rest),
        'summary': lambda: cmd_summary(rest),
        'outline': lambda: cmd_outline(rest),
        'cta': lambda: cmd_cta_types(rest),
        'trending': lambda: cmd_trending(),
        'article': lambda: cmd_article(rest),
        'series': lambda: cmd_series(rest),
        'headline-ab': lambda: cmd_headline_ab(rest),
        'data-article': lambda: cmd_data_article(rest),
        'diagnose': lambda: cmd_diagnose(rest),
    }

    handler = dispatch.get(command)
    if handler:
        handler()
    else:
        print('未知命令「{}」'.format(command))
        print('运行 wechat.sh help 查看帮助')
        sys.exit(1)


if __name__ == '__main__':
    main()
