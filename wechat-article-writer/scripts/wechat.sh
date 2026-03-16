#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
if cmd=="outline":
    topic=inp if inp else "My Article"
    print("=" * 50)
    print("  WeChat Article: {}".format(topic))
    print("=" * 50)
    print("  Title: {} (控制在22字以内)".format(topic))
    print("  Cover: 900x383px or 200x200px")
    print("")
    for section in [("开头 (100字)","用故事/数据/问题吸引读者"),("正文第一部分","核心观点 + 案例"),("正文第二部分","深入分析 + 数据支撑"),("正文第三部分","行动建议 / 实操方法"),("结尾 (50字)","总结 + 引导点赞/在看/关注")]:
        print("  {}".format(section[0]))
        print("    {}".format(section[1]))
        print("")
elif cmd=="title":
    topic=inp if inp else "topic"
    patterns=["{}，90%的人都不知道".format(topic),"深度解析{}：你可能一直都做错了".format(topic),"一文读懂{}".format(topic),"{}的5个真相，第3个太扎心".format(topic),"关于{}，我有话要说".format(topic),"{}实操指南：从入门到精通".format(topic)]
    print("  Title ideas:")
    for t in patterns: print("    - {}".format(t))
elif cmd=="format":
    print("  WeChat Article Formatting Tips:")
    for tip in ["段落不超过3行（手机阅读体验）","重点加粗或变色","每隔300字插入配图","引用框突出金句","列表用序号，不要纯文字","字体14-16px，行距1.75-2","底部固定模板：关注+分享引导"]:
        print("    - {}".format(tip))
elif cmd=="help":
    print("WeChat Article Writer\n  outline [topic]  — Article outline template\n  title [topic]    — Title ideas\n  format           — Formatting tips")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT