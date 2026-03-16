#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
if cmd=="answer":
    topic=inp if inp else "topic"
    print("=" * 50)
    print("  知乎回答框架: {}".format(topic))
    print("=" * 50)
    print("  结构: STAR法则")
    print("  S — 先说结论（吸引人继续读）")
    print("  T — 背景铺垫（为什么这个问题重要）")
    print("  A — 详细论述（分点,每点配例子）")
    print("  R — 总结+升华（给读者行动建议）")
    print("")
    print("  长度建议: 1500-3000字")
    print("  配图: 3-5张（数据图/示例截图）")
    print("  排版: 小标题+粗体+引用块")
elif cmd=="title":
    topic=inp if inp else "话题"
    print("  知乎好标题模式:")
    patterns=["如何评价{}？".format(topic),"{}是一种什么样的体验？".format(topic),"{}有哪些不为人知的冷知识？".format(topic),"为什么{}越来越火了？".format(topic),"有哪些关于{}的建议？".format(topic)]
    for t in patterns: print("    {}".format(t))
elif cmd=="seo":
    print("  知乎SEO技巧:")
    for tip in ["回答前50字最关键(搜索摘要)","高赞回答权重更高","在回答中自然嵌入关键词","定期更新旧回答","蹭热榜话题提高曝光","互动率影响推荐(引导评论)","发布时间: 晚8-10点最佳"]:
        print("    - {}".format(tip))
elif cmd=="help":
    print("Zhihu Writer\n  answer [topic]  — Answer framework\n  title [topic]   — Title templates\n  seo             — SEO optimization tips")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT