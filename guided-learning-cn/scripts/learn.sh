#!/bin/bash
# learn.sh — 中文引导式学习助手
set -euo pipefail

cmd="${1:-help}"
shift 2>/dev/null || true

case "$cmd" in

  plan)
    TOPIC="${1:?请输入学习主题}"
    python3 << PYEOF
topic = "$TOPIC"
print("=" * 55)
print("  📚 学习计划 — {}".format(topic))
print("=" * 55)
print()
print("  🎯 学习目标：系统掌握{}的核心知识".format(topic))
print()
print("  📅 建议学习安排：")
print()
phases = [
    ("第1阶段：入门基础", "1-2天", [
        "了解{}的基本概念和定义".format(topic),
        "理解为什么要学{}".format(topic),
        "掌握{}的核心术语".format(topic),
    ]),
    ("第2阶段：核心知识", "3-5天", [
        "深入理解{}的核心原理".format(topic),
        "学习{}的主要方法和技巧".format(topic),
        "通过例子加深理解",
    ]),
    ("第3阶段：实践应用", "5-7天", [
        "动手实践{}相关练习".format(topic),
        "解决实际问题",
        "总结常见错误和避坑指南",
    ]),
    ("第4阶段：进阶提升", "7-14天", [
        "探索{}的高级话题".format(topic),
        "了解前沿发展和趋势",
        "形成自己的知识体系",
    ]),
]
for name, time, tasks in phases:
    print("  {} ({})".format(name, time))
    for t in tasks:
        print("    ✅ {}".format(t))
    print()
print("  💡 建议：每天学习30-60分钟，比一次学很久效果更好")
print("  💡 方法：学完一个概念就用 quiz 命令检测掌握程度")
PYEOF
    ;;

  concept)
    CONCEPT="${1:?请输入概念}"
    python3 << PYEOF
concept = "$CONCEPT"
print("=" * 55)
print("  💡 概念讲解 — {}".format(concept))
print("=" * 55)
print()
print("  📖 什么是{}？".format(concept))
print("  {}是一个重要的概念，让我们一步步来理解。".format(concept))
print()
print("  🔍 核心要点：")
print("  1. {}的定义：用最简单的话说，就是......".format(concept))
print("  2. {}的作用：它解决了......的问题".format(concept))
print("  3. {}的特点：它与其他概念的区别在于......".format(concept))
print()
print("  🌍 生活类比：")
print("  想象一下{}就像生活中的......".format(concept))
print("  就好比你去超市买东西，{}就相当于......".format(concept))
print()
print("  ✅ 检查一下：")
print("  Q: 用你自己的话解释一下{}是什么？".format(concept))
print("  Q: {}最核心的特点是什么？".format(concept))
print()
print("  💡 理解了？用 quiz \"{}\" 来测试一下！".format(concept))
PYEOF
    ;;

  quiz)
    TOPIC="${1:?请输入主题}"
    python3 << PYEOF
import random
topic = "$TOPIC"
print("=" * 55)
print("  📝 知识检查 — {}".format(topic))
print("=" * 55)
print()
questions = [
    ("填空题", "{}的核心概念是______。".format(topic)),
    ("判断题", "{}只有一种实现方式。（对/错）".format(topic)),
    ("简答题", "请用3句话以内解释什么是{}。".format(topic)),
    ("应用题", "举一个生活中{}的实际应用例子。".format(topic)),
    ("对比题", "{}和______的区别是什么？".format(topic)),
    ("思考题", "如果没有{}，会产生什么影响？".format(topic)),
]
random.shuffle(questions)
for i, (qtype, q) in enumerate(questions[:4], 1):
    print("  Q{} [{}]".format(i, qtype))
    print("  {}".format(q))
    print()
print("  💡 先自己想答案，再对照学习笔记检查")
print("  💡 答不上来的题目，用 concept 命令回顾对应知识点")
PYEOF
    ;;

  review)
    TOPIC="${1:?请输入主题}"
    export TOPIC
    python3 << 'PYEOF'
import os, datetime

topic = os.environ.get("TOPIC", "")
today = datetime.date.today()

print("=" * 55)
print("  \U0001f501 \u95f4\u9694\u590d\u4e60\u8ba1\u5212 \u2014 {}".format(topic))
print("  \u57fa\u4e8e\u827e\u5bbe\u6d69\u65af\u9057\u5fd8\u66f2\u7ebf\uff0c\u79d1\u5b66\u8bb0\u5fc6\uff01")
print("=" * 55)
print()
print("  \U0001f4c5 \u5f00\u59cb\u65e5\u671f\uff1a{}".format(today.strftime("%Y-%m-%d")))
print()

intervals = [
    (1, "\u7b2c1\u6b21\u590d\u4e60", "20\u5206\u949f\u540e\u5df2\u5fd8\u8bb042%", [
        "\u2705 \u5feb\u901f\u6d4f\u89c8{}\u7684\u6838\u5fc3\u7b14\u8bb0".format(topic),
        "\u2705 \u5408\u4e0a\u7b14\u8bb0\uff0c\u7528\u81ea\u5df1\u7684\u8bdd\u590d\u8ff0\u5173\u952e\u6982\u5ff5",
        "\u2705 \u505a3\u9053\u57fa\u7840\u68c0\u6d4b\u9898\uff08\u7528 quiz \u547d\u4ee4\u751f\u6210\uff09",
        "\u2705 \u6807\u8bb0\u4e0d\u786e\u5b9a\u7684\u70b9\uff0c\u91cd\u70b9\u590d\u4e60",
    ]),
    (2, "\u7b2c2\u6b21\u590d\u4e60", "\u5df2\u7ecf\u5fd8\u8bb060%+", [
        "\u2705 \u7528\u8bb0\u5fc6\u5361\u7247\u81ea\u6d4b\uff08\u7528 flashcard \u547d\u4ee4\uff09",
        "\u2705 \u628a{}\u6982\u5ff5\u8bb2\u7ed9\u522b\u4eba\u542c\uff08\u8d39\u66fc\u5b66\u4e60\u6cd5\uff09".format(topic),
        "\u2705 \u8865\u5145\u7b14\u8bb0\uff1a\u52a0\u5165\u81ea\u5df1\u7684\u7406\u89e3\u548c\u4f8b\u5b50",
        "\u2705 \u91cd\u505a\u6628\u5929\u6807\u8bb0\u7684\u4e0d\u786e\u5b9a\u70b9",
    ]),
    (4, "\u7b2c3\u6b21\u590d\u4e60", "\u8bb0\u5fc6\u5f00\u59cb\u7a33\u56fa", [
        "\u2705 \u4e0d\u770b\u7b14\u8bb0\uff0c\u5199\u51fa{}\u7684\u77e5\u8bc6\u6846\u67b6".format(topic),
        "\u2705 \u505a\u4e00\u5957\u5b8c\u6574\u81ea\u6d4b\u5377\uff08\u7528 test \u547d\u4ee4\uff09",
        "\u2705 \u627e\u51fa\u8584\u5f31\u73af\u8282\uff0c\u91cd\u70b9\u7a81\u7834",
        "\u2705 \u5c1d\u8bd5\u7528\u7c7b\u6bd4\u89e3\u91ca\uff08\u7528 analogy \u547d\u4ee4\uff09",
    ]),
    (7, "\u7b2c4\u6b21\u590d\u4e60", "\u957f\u671f\u8bb0\u5fc6\u5f62\u6210\u4e2d", [
        "\u2705 \u7528\u601d\u7ef4\u5bfc\u56fe\u6574\u7406{}\u7684\u5168\u90e8\u77e5\u8bc6\u70b9".format(topic),
        "\u2705 \u505a\u8fdb\u9636\u7ec3\u4e60\u9898\uff0c\u68c0\u9a8c\u5e94\u7528\u80fd\u529b",
        "\u2705 \u548c\u522b\u4eba\u8ba8\u8bba{}\u7684\u96be\u70b9\u548c\u4e89\u8bae\u70b9".format(topic),
        "\u2705 \u6574\u7406\u300c\u9519\u9898\u672c\u300d\uff0c\u603b\u7ed3\u6613\u9519\u70b9",
    ]),
    (15, "\u7b2c5\u6b21\u590d\u4e60", "\u8bb0\u5fc6\u57fa\u672c\u7a33\u56fa", [
        "\u2705 \u4e0d\u770b\u4efb\u4f55\u8d44\u6599\uff0c\u5199\u4e00\u7bc7{}\u7684\u603b\u7ed3\u6587\u7ae0".format(topic),
        "\u2705 \u6559\u4e00\u4e2a\u5b8c\u5168\u4e0d\u61c2\u7684\u4eba\u5b66{}\uff08\u8d39\u66fc\u68c0\u9a8c\uff09".format(topic),
        "\u2705 \u505a\u96be\u5ea6\u6700\u9ad8\u7684\u68c0\u6d4b\u9898",
        "\u2705 \u601d\u8003\uff1a\u5b66\u4e86{}\u5bf9\u6211\u7684\u5b9e\u9645\u5e2e\u52a9\u662f\u4ec0\u4e48\uff1f".format(topic),
    ]),
    (30, "\u7b2c6\u6b21\u590d\u4e60", "\u8fdb\u5165\u6c38\u4e45\u8bb0\u5fc6", [
        "\u2705 \u5feb\u901f\u6d4f\u89c8\u7b14\u8bb0\uff0c\u786e\u8ba4\u6ca1\u6709\u9057\u5fd8",
        "\u2705 \u5c1d\u8bd5\u5c06{}\u7684\u77e5\u8bc6\u8fde\u63a5\u5230\u5176\u4ed6\u9886\u57df".format(topic),
        "\u2705 \u5199\u4e00\u4e2a\u5b9e\u9645\u9879\u76ee/\u6848\u4f8b\u6765\u5e94\u7528{}\u77e5\u8bc6".format(topic),
        "\u2705 \u606d\u559c\uff01\u5982\u679c\u8fd9\u6b21\u5168\u90e8\u901a\u8fc7\uff0c\u8bf4\u660e\u5df2\u7262\u56fa\u638c\u63e1 \U0001f389",
    ]),
]

for days, name, science, tasks in intervals:
    review_date = today + datetime.timedelta(days=days)
    weekday_names = ["\u5468\u4e00","\u5468\u4e8c","\u5468\u4e09","\u5468\u56db","\u5468\u4e94","\u5468\u516d","\u5468\u65e5"]
    wd = weekday_names[review_date.weekday()]
    print("  \U0001f4cc {} | {} ({}) \u2014 \u7b2c{}天".format(
        name, review_date.strftime("%Y-%m-%d"), wd, days))
    print("     \U0001f9e0 \u79d1\u5b66\u4f9d\u636e\uff1a{}".format(science))
    print("     \u590d\u4e60\u4efb\u52a1\uff1a")
    for t in tasks:
        print("       {}".format(t))
    print()

print("  " + "\u2500" * 48)
print()
print("  \U0001f4ca \u827e\u5bbe\u6d69\u65af\u9057\u5fd8\u66f2\u7ebf\uff1a")
print("    20\u5206\u949f\u540e\uff1a\u5fd8\u8bb042%")
print("    1\u5c0f\u65f6\u540e\uff1a\u5fd8\u8bb056%")
print("    1\u5929\u540e\uff1a  \u5fd8\u8bb074%")
print("    1\u5468\u540e\uff1a  \u5fd8\u8bb077%")
print("    1\u4e2a\u6708\u540e\uff1a\u5fd8\u8bb079%")
print()
print("  \U0001f4a1 \u590d\u4e60\u6280\u5de7\uff1a")
print("    1. \u6bcf\u6b21\u590d\u4e60\u524d\u5148\u56de\u5fc6\uff0c\u518d\u770b\u7b14\u8bb0\uff08\u4e3b\u52a8\u56de\u5fc6 > \u88ab\u52a8\u9605\u8bfb\uff09")
print("    2. \u7528\u300c\u8d39\u66fc\u6280\u5de7\u300d\uff1a\u80fd\u6559\u4f1a\u522b\u4eba\u624d\u7b97\u771f\u6b63\u5b66\u4f1a")
print("    3. \u590d\u4e60\u65f6\u95f4\u4e0d\u7528\u957f\uff0c\u6bcf\u6b2115-30\u5206\u949f\u5c31\u591f")
print("    4. \u575a\u6301\u5b8c\u62106\u6b21\u590d\u4e60\uff0c\u8bb0\u5fc6\u4fdd\u6301\u7387\u53ef\u8fbe95%+")
print()
print("  \U0001f4cc \u914d\u5957\u547d\u4ee4\uff1a")
print("    learn.sh quiz \"{}\"       \u2014 \u751f\u6210\u68c0\u6d4b\u9898".format(topic))
print("    learn.sh flashcard \"{}\"  \u2014 \u751f\u6210\u8bb0\u5fc6\u5361\u7247".format(topic))
print("    learn.sh test \"{}\"       \u2014 \u751f\u6210\u81ea\u6d4b\u8bd5\u5377".format(topic))
print("    learn.sh feynman \"{}\"    \u2014 \u8d39\u66fc\u5b66\u4e60\u6cd5\u7ec3\u4e60".format(topic))
PYEOF
    ;;

  analogy)
    CONCEPT="${1:?请输入概念}"
    python3 << PYEOF
import random
concept = "$CONCEPT"
analogies = [
    ("超市购物", "就像你去超市，{}相当于......而购物车就是......".format(concept)),
    ("做饭", "{}就像做菜一样，食材是......，调料是......，最后出锅就是......".format(concept)),
    ("盖房子", "理解{}就像盖房子：地基是......，框架是......，装修是......".format(concept)),
    ("开车", "学{}就像学开车：先学规则（理论），再练操作（实践），最后上路（应用）".format(concept)),
    ("打游戏", "{}就像打游戏：新手村学基础，刷副本练技能，打Boss检验成果".format(concept)),
]
random.shuffle(analogies)
print("=" * 55)
print("  🌍 用类比理解 — {}".format(concept))
print("=" * 55)
for name, text in analogies[:3]:
    print()
    print("  📌 {} 类比：".format(name))
    print("  {}".format(text))
print()
print("  💡 最好的类比是你自己想出来的——试试用你熟悉的事物来解释{}".format(concept))
PYEOF
    ;;

  roadmap)
    FIELD="${1:?请输入领域}"
    python3 << PYEOF
field = "$FIELD"
print("=" * 55)
print("  🗺️ 学习路线图 — {}".format(field))
print("=" * 55)
print()
stages = [
    ("🌱 入门期", "0-1个月", "建立基本认知，掌握核心术语"),
    ("🌿 成长期", "1-3个月", "深入核心知识，动手实践"),
    ("🌲 进阶期", "3-6个月", "解决复杂问题，形成方法论"),
    ("🏔️ 精通期", "6-12个月", "融会贯通，能教给别人"),
]
for emoji, period, desc in stages:
    print("  {} {} ({})".format(emoji, period, desc))
    print()
print("  📌 每个阶段的检验标准：能把学到的知识讲给别人听")
print("  📌 学习资源推荐：书籍→视频→实践→社群，逐步深入")
PYEOF
    ;;

  flashcard)
    TOPIC="${1:?请输入主题}"
    python3 << PYEOF
topic = "$TOPIC"
print("=" * 55)
print("  🃏 记忆卡片 — {}".format(topic))
print("=" * 55)
cards = [
    ("{}是什么？".format(topic), "（用一句话定义）"),
    ("{}的核心特点？".format(topic), "（列出3个关键词）"),
    ("{}有什么用？".format(topic), "（说出2个应用场景）"),
    ("{}和______的区别？".format(topic), "（对比最容易混淆的概念）"),
    ("{}常见的错误理解？".format(topic), "（列出1-2个误区）"),
]
for i, (front, back) in enumerate(cards, 1):
    print()
    print("  卡片 {} 正面：{}".format(i, front))
    print("  卡片 {} 背面：{}".format(i, back))
print()
print("  💡 使用方法：先看正面回答，再翻背面检查")
print("  💡 记不住的卡片放到一堆，重复复习直到全部记住")
PYEOF
    ;;

  explain-like-5)
    CONCEPT="${1:?请输入概念}"
    python3 << PYEOF
concept = "$CONCEPT"
print("=" * 55)
print("  👶 像给5岁小孩解释 — {}".format(concept))
print("=" * 55)
print()
print("  小朋友，你知道{}是什么吗？".format(concept))
print()
print("  想象一下......")
print()
print("  {}就像是......".format(concept))
print()
print("  比如说，你每天都会......对吧？")
print("  {}就是帮助我们......的东西。".format(concept))
print()
print("  简单说：{}就是让......变得更......的方法！".format(concept))
print()
print("  📌 费曼学习法：如果你能像给5岁小孩解释一样讲清楚，")
print("     说明你真的理解了。如果讲不清楚，说明还需要学习。")
PYEOF
    ;;

  test)
    TOPIC="${1:?请输入主题}"
    export TOPIC
    python3 <<'PYEOF'
# -*- coding: utf-8 -*-
import os
import random

topic = os.environ.get("TOPIC", "")
print("=" * 55)
print("  📝 自测试卷 — {}".format(topic))
print("=" * 55)
print()

# 选择题
print("  ┌─────────────────────────────────────────────┐")
print("  │          第一部分：选择题（共5题）           │")
print("  └─────────────────────────────────────────────┘")
print()

mc_templates = [
    ("以下关于{}的说法，哪个是正确的？".format(topic),
     ["A. {}只有一种实现方式".format(topic),
      "B. {}是近年才出现的概念".format(topic),
      "C. {}有多种应用场景和实现方法".format(topic),
      "D. {}与其他领域没有关联".format(topic)],
     "C"),
    ("{}的核心特征是什么？".format(topic),
     ["A. 简单易学",
      "B. 需要深入理解其原理和应用",
      "C. 只适合专业人士",
      "D. 不需要练习就能掌握"],
     "B"),
    ("学习{}时，最重要的方法是？".format(topic),
     ["A. 只看不练",
      "B. 死记硬背",
      "C. 理解原理 + 动手实践",
      "D. 只看考试重点"],
     "C"),
    ("以下哪种情况说明你真正理解了{}？".format(topic),
     ["A. 能背诵定义",
      "B. 做题正确率高",
      "C. 能用自己的话给别人讲清楚",
      "D. 能认出相关的关键词"],
     "C"),
    ("关于{}的学习路径，正确的顺序是？".format(topic),
     ["A. 高级技巧 → 基础概念 → 实践",
      "B. 基础概念 → 核心原理 → 实践应用 → 进阶",
      "C. 实践 → 理论 → 忘记 → 重来",
      "D. 随便学，没有顺序"],
     "B"),
]

random.shuffle(mc_templates)
for i, (question, options, answer) in enumerate(mc_templates[:5], 1):
    print("  {}. {}".format(i, question))
    for opt in options:
        print("     {}".format(opt))
    print("     📎 参考答案：{}".format(answer))
    print()

# 简答题
print("  ┌─────────────────────────────────────────────┐")
print("  │          第二部分：简答题（共3题）           │")
print("  └─────────────────────────────────────────────┘")
print()

short_qs = [
    "请用3句话以内解释什么是{}。".format(topic),
    "{}在实际生活/工作中有哪些应用？请举2个例子。".format(topic),
    "学习{}过程中最常见的误区是什么？你如何避免？".format(topic),
    "{}和______（一个相关概念）的区别和联系是什么？".format(topic),
    "如果你要向完全不懂的人推荐学习{}，你会建议从哪里开始？".format(topic),
]
random.shuffle(short_qs)
for i, q in enumerate(short_qs[:3], 1):
    print("  {}. {}".format(i, q))
    print("     （请用自己的话作答，不要照搬教材）")
    print()

print("  " + "─" * 50)
print("  💡 评分标准：")
print("     选择题：每题 10 分，共 50 分")
print("     简答题：每题 15 分，共 45 分（+ 5分卷面分）")
print("     90+ = 掌握优秀  70-89 = 基本掌握  <70 = 需要复习")
print()
print("  💡 做完后用 concept 命令回顾不确定的知识点")
PYEOF
    ;;

  feynman)
    CONCEPT="${1:?请输入概念}"
    export CONCEPT
    python3 <<'PYEOF'
# -*- coding: utf-8 -*-
import os

concept = os.environ.get("CONCEPT", "")
print("=" * 55)
print("  🧪 费曼学习法练习 — {}".format(concept))
print("=" * 55)
print()

print("  费曼学习法（Feynman Technique）四步走：")
print()
print("  ┌───────────────────────────────────────────────┐")
print('  │  理查德·费曼：\u201c如果你不能简单地解释一件事，  │')
print('  │  说明你还没有真正理解它。\u201d                    │')
print("  └───────────────────────────────────────────────┘")
print()

steps = [
    ("第1步：选择概念", "写下你想学习的概念名称",
     [
         "你选择的概念是：{}".format(concept),
         "先不看任何资料，写下你目前对它的理解",
         "不确定的地方标记出来",
     ]),
    ("第2步：教给别人", "假装你在教一个完全不懂的朋友",
     [
         "🎯 挑战：用简单的话解释「{}」".format(concept),
         "",
         "想象你在和一个 10 岁小孩对话：",
         "",
         "小孩问：「{}是什么呀？」".format(concept),
         "你回答：「简单来说，{}就像是......」".format(concept),
         "",
         "小孩问：「那它有什么用呢？」",
         "你回答：「比如在生活中，当你......的时候就会用到它」",
         "",
         "小孩问：「它是怎么工作的？」",
         "你回答：「你可以想象成......的过程」",
         "",
         "⚠️ 规则：",
         "  • 不能使用专业术语",
         '  • 不能说"就是那个意思"',
         "  • 必须用类比或例子",
     ]),
    ("第3步：找到差距", "回到原材料，找出你讲不清楚的地方",
     [
         "🔍 自我检查清单：",
         "  ☐ 我能解释{}的核心定义吗？".format(concept),
         "  ☐ 我能说出它和相关概念的区别吗？",
         "  ☐ 我能举出3个实际应用的例子吗？",
         "  ☐ 我能解释它为什么重要吗？",
         "  ☐ 我能画出一个示意图吗？",
         "",
         "打 ☐ 的地方就是你需要回去重新学习的部分",
     ]),
    ("第4步：简化和类比", "用最简洁的语言重新组织",
     [
         "🌍 常用类比模板：",
         "",
         "  1. 超市类比：",
         "     {}就像去超市买东西——".format(concept),
         "     输入是......，过程是......，输出是......",
         "",
         "  2. 做菜类比：",
         "     理解{}就像做菜——".format(concept),
         "     食材(原料)是......，烹饪方法是......，成品是......",
         "",
         "  3. 交通类比：",
         "     {}就像一条高速公路——".format(concept),
         "     车(数据)在上面跑，收费站(检查)控制通行，出口(结果)到达目的地",
         "",
         "  4. 建筑类比：",
         "     学{}就像盖楼——".format(concept),
         "     地基(基础概念)最重要，框架(核心原理)决定结构，装修(应用)让它有用",
         "",
         "  📌 你的一句话总结：",
         "  「{}就是______，它能帮我们______。」".format(concept),
     ]),
]

for title, subtitle, points in steps:
    print("  📌 {}".format(title))
    print("     {}".format(subtitle))
    print("  " + "─" * 50)
    for p in points:
        if p:
            print("     {}".format(p))
        else:
            print()
    print()

print("  " + "═" * 50)
print("  💡 费曼学习法的精髓：")
print("     • 教是最好的学——你教不会别人，说明自己没懂")
print("     • 简单 ≠ 粗浅——越是深入理解，越能简单表达")
print("     • 反复循环——每次循环都会加深理解")
print("     • 类比是桥梁——连接新知识和已有经验")
print()
print("  📌 完成后，用 quiz \"{}\" 检验你的理解".format(concept))
PYEOF
    ;;

  help|*)
    echo "📚 中文引导式学习助手"
    echo ""
    echo "Usage: learn.sh <command> [args]"
    echo ""
    echo "Commands:"
    echo "  plan \"主题\"           生成学习计划"
    echo "  concept \"概念\"        讲解单个概念"
    echo "  quiz \"主题\"           生成检查题"
    echo "  review \"主题\"         间隔复习计划（艾宾浩斯遗忘曲线）"
    echo "  analogy \"概念\"        用生活类比解释"
    echo "  roadmap \"领域\"        学习路线图"
    echo "  flashcard \"主题\"      生成记忆卡片"
    echo "  explain-like-5 \"概念\" 像给5岁小孩解释"
    echo "  test \"主题\"          生成自测试卷（选择+简答）"
    echo "  feynman \"概念\"       费曼学习法四步练习"
    echo "  help                  显示帮助"
    ;;
esac

echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
