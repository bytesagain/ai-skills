#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
run_python() {
python3 << 'PYEOF'
import sys, hashlib
from datetime import datetime
cmd = sys.argv[1] if len(sys.argv) > 1 else "help"
inp = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else ""

ZONES = {"gaming":"游戏","tech":"科技","life":"生活","food":"美食","anime":"动画","music":"音乐","dance":"舞蹈","knowledge":"知识","fashion":"时尚","sports":"运动","car":"汽车","movie":"影视"}

TITLE_PATTERNS = [
    "{}，这才是正确的打开方式！",
    "全网最详细的{}教程，看完你就懂了",
    "{}的10个隐藏技巧，90%的人不知道",
    "花了3天研究{}，结果让我震惊",
    "别再{}了！试试这个方法",
    "{}入门到精通，一个视频就够了",
    "我用{}赚了第一桶金，分享给你",
    "{}避坑指南：这些错误千万别犯",
]

TAG_DB = {
    "tech": ["科技","数码","评测","开箱","教程","干货","科普"],
    "gaming": ["游戏","攻略","实况","手游","PC","主机","电竞"],
    "life": ["日常","vlog","记录","分享","生活方式","收纳","好物"],
    "knowledge": ["知识","学习","科普","考试","课程","技能","自学"],
    "food": ["美食","做饭","食谱","探店","吃播","烹饪","下厨"],
}

def cmd_title():
    if not inp:
        print("Usage: title <topic>")
        print("Example: title Python编程")
        return
    topic = inp.strip()
    print("=" * 55)
    print("  B站标题优化 — {}".format(topic))
    print("=" * 55)
    print("")
    for p in TITLE_PATTERNS:
        print("  - {}".format(p.format(topic)))
    print("")
    print("  标题技巧:")
    print("  1. 控制在20字以内")
    print("  2. 数字+悬念+痛点")
    print("  3. 避免标题党(会被限流)")

def cmd_tags():
    zone = inp.strip().lower() if inp else "tech"
    tags = TAG_DB.get(zone, TAG_DB["tech"])
    print("  推荐标签 ({}):".format(zone))
    for t in tags:
        print("    #{}".format(t))
    print("")
    print("  标签规则:")
    print("  - 最多10个标签")
    print("  - 第一个标签权重最高")
    print("  - 混合大类+细分+热门")

def cmd_cover():
    if not inp:
        print("Usage: cover <video_topic>")
        return
    print("=" * 50)
    print("  封面设计建议 — {}".format(inp))
    print("=" * 50)
    print("")
    print("  尺寸: 1146x717 (16:10)")
    print("  格式: JPG/PNG, <2MB")
    print("")
    print("  封面公式:")
    print("  1. 人物表情(夸张) + 大字标题")
    print("  2. 对比图(前/后, 好/坏)")
    print("  3. 产品特写 + 价格/评分")
    print("  4. 数据/图表 + 震惊表情")
    print("")
    print("  文字规则:")
    print("  - 最多8个大字")
    print("  - 用对比色(白底红字/黑底黄字)")
    print("  - 不要把重要信息放右下角(会被时长遮挡)")

def cmd_strategy():
    print("=" * 55)
    print("  B站涨粉策略")
    print("=" * 55)
    print("")
    phases = [
        ("0-1K粉", ["日更或隔日更","蹭热点+原创结合","积极回复每条评论","投稿到相关话题活动"]),
        ("1K-1W粉", ["稳定更新频率(周2-3)","系列化内容","互动抽奖","与同量级UP互推"]),
        ("1W-10W粉", ["提升制作质量","建立个人风格","接商单但不影响内容","开通专栏/动态"]),
    ]
    for phase, tips in phases:
        print("  {} 阶段:".format(phase))
        for t in tips:
            print("    - {}".format(t))
        print("")

commands = {"title": cmd_title, "tags": cmd_tags, "cover": cmd_cover, "strategy": cmd_strategy}
if cmd == "help":
    print("Bilibili Creator Helper")
    print("")
    print("Commands:")
    print("  title <topic>       — Title optimization (8 templates)")
    print("  tags [zone]         — Tag recommendations (tech/gaming/life/...)")
    print("  cover <topic>       — Cover design guide")
    print("  strategy            — Growth strategy by follower stage")
    print("")
    print("Zones: {}".format(", ".join(ZONES.keys())))
elif cmd in commands:
    commands[cmd]()
else:
    print("Unknown: {}".format(cmd))
print("")
print("Powered by BytesAgain | bytesagain.com")
PYEOF
}
run_python "$CMD" $INPUT
