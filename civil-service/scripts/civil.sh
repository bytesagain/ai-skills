#!/usr/bin/env bash
# civil-service — 公务员考试助手
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
run_python() {
python3 << 'PYEOF'
import sys, hashlib, math
from datetime import datetime

cmd = sys.argv[1] if len(sys.argv) > 1 else "help"
inp = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else ""

# Knowledge database
COMMON_SENSE = [
    {"q": "我国最高权力机关是什么？", "a": "全国人民代表大会", "cat": "政治"},
    {"q": "我国现行宪法是哪一年颁布的？", "a": "1982年", "cat": "法律"},
    {"q": "GDP是什么的缩写？", "a": "Gross Domestic Product（国内生产总值）", "cat": "经济"},
    {"q": "光年是什么单位？", "a": "距离单位（不是时间）", "cat": "科学"},
    {"q": "我国第一部社会主义类型宪法颁布于？", "a": "1954年", "cat": "法律"},
    {"q": "三大改造是指？", "a": "农业、手工业、资本主义工商业的社会主义改造", "cat": "历史"},
    {"q": "一带一路全称？", "a": "丝绸之路经济带和21世纪海上丝绸之路", "cat": "政治"},
    {"q": "CPI衡量的是？", "a": "消费者物价指数，反映通货膨胀水平", "cat": "经济"},
    {"q": "哪个朝代发明了活字印刷术？", "a": "北宋（毕昇）", "cat": "历史"},
    {"q": "我国最长的河流是？", "a": "长江（6300公里）", "cat": "地理"},
    {"q": "pH值7代表什么？", "a": "中性（<7酸性，>7碱性）", "cat": "科学"},
    {"q": "人大代表每届任期几年？", "a": "5年", "cat": "政治"},
    {"q": "我国四大发明是？", "a": "造纸术、印刷术、火药、指南针", "cat": "历史"},
    {"q": "我国最大的淡水湖是？", "a": "鄱阳湖", "cat": "地理"},
    {"q": "民法典自何时施行？", "a": "2021年1月1日", "cat": "法律"},
    {"q": "GDP前三甲国家？", "a": "美国、中国、日本", "cat": "经济"},
    {"q": "光合作用的产物是？", "a": "氧气和有机物（葡萄糖）", "cat": "科学"},
    {"q": "联合国成立于哪一年？", "a": "1945年", "cat": "政治"},
    {"q": "中国加入WTO是哪一年？", "a": "2001年", "cat": "经济"},
    {"q": "我国五个自治区是？", "a": "内蒙古、新疆、西藏、宁夏、广西", "cat": "地理"},
]

MATH_PATTERNS = [
    {"name": "等差数列", "formula": "an = a1 + (n-1)d, Sn = n(a1+an)/2",
     "example": "2,5,8,11,14 (d=3)"},
    {"name": "等比数列", "formula": "an = a1 * r^(n-1), Sn = a1(1-r^n)/(1-r)",
     "example": "2,6,18,54 (r=3)"},
    {"name": "递推数列", "formula": "每项等于前两项之和/差/积",
     "example": "1,1,2,3,5,8 (斐波那契)"},
    {"name": "工程问题", "formula": "效率=工作量/时间, 合作效率=各效率之和",
     "example": "A做10天完成,B做15天,合作=1/10+1/15=1/6,6天完成"},
    {"name": "行程问题", "formula": "路程=速度x时间, 相遇:t=S/(v1+v2), 追及:t=S/(v1-v2)",
     "example": "甲60km/h,乙40km/h,相距200km,相向=200/100=2h"},
    {"name": "排列组合", "formula": "P(n,m)=n!/(n-m)!, C(n,m)=n!/[m!(n-m)!]",
     "example": "C(5,2)=10, P(5,2)=20"},
    {"name": "概率", "formula": "P(A)=有利/全部, P(A+B)=P(A)+P(B)-P(AB)",
     "example": "掷骰子P(6)=1/6"},
    {"name": "利润问题", "formula": "利润=售价-成本, 利润率=利润/成本x100%",
     "example": "成本100,售价150,利润率50%"},
]

ESSAY_FRAMEWORKS = {
    "policy": {
        "name": "政策分析型",
        "structure": ["背景+问题","原因分析","对策建议","总结展望"],
        "tips": ["开头引用政策原文","分析要多角度(政府/企业/个人)","对策要具体可操作"],
    },
    "opinion": {
        "name": "观点论述型",
        "structure": ["亮明观点","论证(正面)","论证(反面/让步)","总结升华"],
        "tips": ["观点鲜明不骑墙","举例要新颖","结尾升华到社会/国家层面"],
    },
    "case": {
        "name": "案例分析型",
        "structure": ["概括案例","分析问题","提出方案","推广意义"],
        "tips": ["概括精练不超100字","问题分析要有层次","方案要有针对性"],
    },
}

def cmd_quiz():
    cat = inp.strip() if inp else ""
    if cat:
        items = [q for q in COMMON_SENSE if cat in q["cat"]]
    else:
        seed = int(hashlib.md5(datetime.now().strftime("%Y%m%d%H%M").encode()).hexdigest()[:8], 16)
        items = []
        for i in range(10):
            idx = (seed + i * 7) % len(COMMON_SENSE)
            if COMMON_SENSE[idx] not in items:
                items.append(COMMON_SENSE[idx])

    print("=" * 55)
    print("  公务员考试 — 常识练习")
    if cat:
        print("  类别: {}".format(cat))
    print("=" * 55)
    print("")
    for i, q in enumerate(items[:10], 1):
        print("  {}. [{}] {}".format(i, q["cat"], q["q"]))
        print("     答案: {}".format(q["a"]))
        print("")

def cmd_math():
    if inp:
        keyword = inp.strip()
        matches = [p for p in MATH_PATTERNS if keyword in p["name"]]
        if matches:
            for p in matches:
                print("=" * 50)
                print("  {}".format(p["name"]))
                print("=" * 50)
                print("  公式: {}".format(p["formula"]))
                print("  示例: {}".format(p["example"]))
            return

    print("=" * 55)
    print("  行测数量关系 — 常用公式速查")
    print("=" * 55)
    print("")
    for p in MATH_PATTERNS:
        print("  {}".format(p["name"]))
        print("    公式: {}".format(p["formula"]))
        print("    例: {}".format(p["example"]))
        print("")

def cmd_essay():
    ftype = inp.strip().lower() if inp else ""
    if ftype and ftype in ESSAY_FRAMEWORKS:
        f = ESSAY_FRAMEWORKS[ftype]
        print("=" * 50)
        print("  申论 — {}".format(f["name"]))
        print("=" * 50)
        print("")
        print("  结构:")
        for i, s in enumerate(f["structure"], 1):
            print("    第{}段: {}".format(i, s))
        print("")
        print("  技巧:")
        for t in f["tips"]:
            print("    - {}".format(t))
        return

    print("=" * 55)
    print("  申论写作框架")
    print("=" * 55)
    print("")
    for key, f in ESSAY_FRAMEWORKS.items():
        print("  {} (type: {})".format(f["name"], key))
        print("    结构: {}".format(" -> ".join(f["structure"])))
        print("")

    print("  通用技巧:")
    print("    1. 字数控制: 800-1200字")
    print("    2. 分段清晰: 4-5段")
    print("    3. 开头: 不超过150字")
    print("    4. 每段有中心句")
    print("    5. 结尾: 回扣主题+展望")

def cmd_score():
    if not inp:
        print("Usage: score <xingce> <shenlun> [加分]")
        print("Example: score 70 65 5")
        return
    parts = inp.split()
    xc = float(parts[0])
    sl = float(parts[1])
    bonus = float(parts[2]) if len(parts) > 2 else 0

    total = xc * 0.5 + sl * 0.5 + bonus
    print("=" * 45)
    print("  笔试成绩估算")
    print("=" * 45)
    print("")
    print("  行测: {:.1f} (权重50%)  = {:.2f}".format(xc, xc * 0.5))
    print("  申论: {:.1f} (权重50%)  = {:.2f}".format(sl, sl * 0.5))
    if bonus > 0:
        print("  加分: {:.1f}".format(bonus))
    print("  " + "-" * 30)
    print("  笔试总分: {:.2f}".format(total))
    print("")
    if total >= 55:
        print("  参考: 国考一般55+有面试机会")
    elif total >= 50:
        print("  参考: 部分岗位50+可进面")
    else:
        print("  参考: 需要继续努力")

def cmd_plan():
    print("=" * 55)
    print("  公考备考计划 (3个月)")
    print("=" * 55)
    print("")
    plan = [
        ("第1月: 基础夯实", [
            "行测: 每天2小时，专项突破(言语→判断→数量→资料)",
            "申论: 每天1小时，积累热点+练习概括",
            "常识: 碎片时间刷题",
            "目标: 行测正确率60%+",
        ]),
        ("第2月: 强化提升", [
            "行测: 每天3小时，限时训练(言语25min/20题)",
            "申论: 每周写2篇大作文",
            "真题: 开始做近5年真题",
            "目标: 行测正确率70%+",
        ]),
        ("第3月: 冲刺模考", [
            "行测: 全真模考，每周2-3套",
            "申论: 每周1篇全真作文",
            "时间分配: 按考试时间严格训练",
            "目标: 稳定在75%+",
        ]),
    ]
    for phase, items in plan:
        print("  {}".format(phase))
        for item in items:
            print("    - {}".format(item))
        print("")

commands = {
    "quiz": cmd_quiz, "math": cmd_math,
    "essay": cmd_essay, "score": cmd_score, "plan": cmd_plan,
}
if cmd == "help":
    print("Civil Service Exam Assistant")
    print("")
    print("Commands:")
    print("  quiz [category]        — Knowledge quiz (政治/法律/经济/历史/地理/科学)")
    print("  math [topic]           — Math formulas & patterns")
    print("  essay [type]           — Essay frameworks (policy/opinion/case)")
    print("  score <xc> <sl> [bonus] — Score calculator")
    print("  plan                   — 3-month study plan")
elif cmd in commands:
    commands[cmd]()
else:
    print("Unknown: {}".format(cmd))
print("")
print("Powered by BytesAgain | bytesagain.com")
PYEOF
}
run_python "$CMD" $INPUT
