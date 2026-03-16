#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""B站视频运营助手 - Python 3.6 compatible"""

from __future__ import print_function
import sys
import random
import textwrap
import argparse


def gen_title(topic):
    """生成5个B站爆款标题"""
    templates = [
        # 震惊型
        "【{}】看完我直接跪了！这也太离谱了吧",
        "{}？看到结尾我人傻了……",
        "全网最全{}教程！看完直接起飞",
        # 挑战型
        "挑战用{}做XX，结果竟然……",
        "花了1000块体验{}，值不值？",
        "{}的天花板！没有人比这更强了",
        # 教程型
        "【保姆级教程】{}从入门到精通，看这一个就够了",
        "{}避坑指南！我踩过的雷你别再踩了",
        "学了3年{}，这些经验白送给你",
        # 盘点型
        "{}TOP10盘点！第一名绝对想不到",
        "2024年最值得{}的10个选择，闭眼入！",
        "盘点那些关于{}的冷知识，你知道几个？",
        # 争议型
        "{}到底值不值得？说点大家不敢说的",
        "为什么我不推荐{}？真相可能让你不舒服",
        "{}的真实水平，可能和你想的不一样",
    ]

    print("=" * 60)
    print("📺 B站爆款标题 | 主题: {}".format(topic))
    print("=" * 60)
    print("")

    selected = random.sample(templates, 5)
    for i, tmpl in enumerate(selected, 1):
        title = tmpl.format(topic)
        print("{}. {}".format(i, title))

    print("")
    print("💡 B站标题技巧：")
    print("  - 用【】突出关键词，系统会加粗显示")
    print("  - 标题控制在20-30字，太长会被截断")
    print("  - 适当使用emoji增加点击率")
    print("  - 教程类加「保姆级」「从零开始」等关键词")
    print("  - 避免纯标题党，B站用户反感clickbait")


def gen_desc(topic):
    """生成视频简介+标签"""
    print("=" * 60)
    print("📝 视频简介 | 主题: {}".format(topic))
    print("=" * 60)
    print("")
    print(textwrap.dedent("""\
        📺 关于本期视频

        大家好，这期视频我们来聊聊「{topic}」。

        [用1-2句话概括视频核心内容]
        [说明看完视频能获得什么]

        ⏱ 时间线（必备！B站用户最爱的功能）
        00:00 开场
        01:30 {topic}是什么？
        03:00 为什么要了解{topic}？
        05:00 核心内容讲解
        08:00 实操演示
        10:00 总结和建议

        📌 相关资源
        - [资料链接1]
        - [资料链接2]
        - [文档/工具链接]

        💬 互动话题
        你对{topic}有什么看法？欢迎在评论区分享！

        🔔 关注不迷路
        如果觉得有帮助，一键三连（点赞+投币+收藏）支持一下~
        关注UP主，持续更新{topic}相关内容！

        📧 商务合作：[邮箱]

        #B站 #{topic} #干货分享 #涨知识
    """.format(topic=topic)))


def gen_script(topic, length=5):
    """生成视频口播脚本"""
    length = int(length)
    word_count = length * 250  # 约每分钟250字

    print("=" * 60)
    print("🎬 视频口播脚本 | 主题: {} | 时长: {}分钟 | 约{}字".format(topic, length, word_count))
    print("=" * 60)
    print("")

    hooks = [
        "大家好，今天这期视频可能会颠覆你对{}的认知。".format(topic),
        "关于{}，90%的人都搞错了，今天我来讲清楚。".format(topic),
        "如果你正在纠结{}，那这期视频你一定要看完。".format(topic),
        "{}到底是怎么回事？3分钟给你讲明白。".format(topic),
    ]

    print("## 🎯 开场 Hook（前30秒最关键！）")
    print("")
    print("[镜头：正面中景]")
    print("")
    print(random.choice(hooks))
    print("")
    print("[停顿1秒，制造悬念]")
    print("")

    if length <= 5:
        print(textwrap.dedent("""\
            ## 📖 正文（约{length}分钟）

            ### Part 1: 是什么？（约1分钟）

            [镜头：配合画面/PPT]

            首先我们来搞清楚，{topic}到底是什么。
            简单来说……[用大白话解释]
            举个例子……[用生活化的比喻]

            ### Part 2: 为什么重要？（约1.5分钟）

            [镜头：适当加入数据图表]

            那为什么我要专门做一期视频来讲{topic}呢？
            原因有三：
            第一……
            第二……
            第三……

            ### Part 3: 怎么做？（约2分钟）

            [镜头：实操演示/步骤展示]

            OK，知道了是什么和为什么，接下来最关键的——怎么做？
            我总结了X个步骤：

            步骤一：……
            步骤二：……
            步骤三：……

            [每个步骤配合实际演示]
        """.format(topic=topic, length=length)))
    else:
        print(textwrap.dedent("""\
            ## 📖 正文（约{length}分钟）

            ### Part 1: 背景介绍（约2分钟）

            [镜头：配合画面/PPT]

            要理解{topic}，我们先要了解一些背景。
            [介绍背景知识，让新手也能跟上]

            ### Part 2: 核心概念（约3分钟）

            [镜头：图文并茂]

            搞清楚背景后，我们来看核心内容。
            {topic}主要分为以下几个方面：
            第一个方面……
            第二个方面……
            第三个方面……

            ### Part 3: 实操演示（约3分钟）

            [镜头：屏幕录制/实拍]

            理论讲完了，我们来实操。
            [详细的步骤演示]

            ### Part 4: 进阶技巧（约2分钟）

            [镜头：回到正面]

            如果你已经掌握了基础，这里有几个进阶技巧：
            技巧一……
            技巧二……
            技巧三……

            ### Part 5: 常见问题（约{qa}分钟）

            [镜头：Q&A画面]

            最后回答几个大家最常问的问题：
            Q1：……？A：……
            Q2：……？A：……
        """.format(topic=topic, length=length, qa=max(1, length - 10))))

    print(textwrap.dedent("""\
        ## 🎬 结尾（30秒）

        [镜头：正面中景，微笑]

        好了，以上就是关于{topic}的全部内容。
        如果觉得有帮助，别忘了一键三连支持一下~
        有任何问题欢迎在评论区留言，我会一一回复。
        我们下期视频再见！

        [结尾动画+BGM]

        ---
        💡 脚本备注：
        - 语速建议：每分钟250字左右
        - 关键数据用画面强调
        - 每2-3分钟切换一次画面节奏
        - 开头30秒决定完播率，务必抓人
    """.format(topic=topic)))


def gen_tags(topic):
    """标签推荐"""
    general_tags = [
        "干货", "涨知识", "科普", "教程", "经验分享",
        "深度解析", "必看", "收藏", "学习", "知识",
    ]
    style_tags = [
        "保姆级教程", "一看就会", "全网最全",
        "避坑指南", "新手必看", "进阶教程",
    ]
    trending = [
        "2024", "最新", "爆款", "热门", "必备",
    ]

    print("=" * 60)
    print("🏷️ B站标签推荐 | 主题: {}".format(topic))
    print("=" * 60)
    print("")

    print("## 核心标签（必加）")
    print("  {}".format(topic))
    print("")

    print("## 内容标签（选3-5个）")
    for tag in random.sample(general_tags, 5):
        print("  #{}".format(tag))
    print("")

    print("## 风格标签（选1-2个）")
    for tag in random.sample(style_tags, 3):
        print("  #{}".format(tag))
    print("")

    print("## 热度标签（选1个）")
    for tag in random.sample(trending, 2):
        print("  #{}".format(tag))
    print("")

    print("## 推荐分区")
    zones = [
        ("知识 > 科学科普", "科普类、知识分享类"),
        ("知识 > 社科·法律·心理", "社会话题、心理分析"),
        ("科技 > 软件应用", "软件教程、APP推荐"),
        ("科技 > 计算机技术", "编程、IT技术"),
        ("生活 > 日常", "日常分享、生活技巧"),
        ("影视 > 影视杂谈", "影视点评、盘点"),
    ]
    print("")
    for zone, desc in zones:
        print("  📁 {} — {}".format(zone, desc))

    print("")
    print("💡 标签技巧：")
    print("  - B站最多支持10个标签")
    print("  - 第一个标签权重最高，放最核心的")
    print("  - 混合使用大词（流量大）和小词（精准）")
    print("  - 关注B站热搜，蹭相关热度标签")


def main():
    if len(sys.argv) < 2:
        print("用法: bili_gen.py <command> [args]")
        sys.exit(1)

    cmd = sys.argv[1]

    if cmd == "title":
        if len(sys.argv) < 3:
            print("用法: bili_gen.py title \"主题\"")
            sys.exit(1)
        gen_title(sys.argv[2])

    elif cmd == "desc":
        if len(sys.argv) < 3:
            print("用法: bili_gen.py desc \"视频主题\"")
            sys.exit(1)
        gen_desc(sys.argv[2])

    elif cmd == "script":
        parser = argparse.ArgumentParser()
        parser.add_argument("topic")
        parser.add_argument("--length", default="5", choices=["5", "10", "15"])
        args = parser.parse_args(sys.argv[2:])
        gen_script(args.topic, args.length)

    elif cmd == "tags":
        if len(sys.argv) < 3:
            print("用法: bili_gen.py tags \"主题\"")
            sys.exit(1)
        gen_tags(sys.argv[2])

    else:
        print("未知命令: {}".format(cmd))
        sys.exit(1)


if __name__ == "__main__":
    main()
