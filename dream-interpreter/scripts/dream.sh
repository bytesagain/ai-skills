#!/usr/bin/env bash
# dream-interpreter — 解梦工具
# 梦境符号数据库、周公解梦查询、心理学分析框架、梦境日记
set -euo pipefail

INPUT="${1:-${INPUT:-}}"

python3 << 'PYEOF'
import sys, os, random, json, hashlib
from datetime import datetime

INPUT = os.environ.get("INPUT", "")
if len(sys.argv) > 1:
    INPUT = " ".join(sys.argv[1:])

# ============================================================
# 梦境符号数据库 (60+ 常见意象)
# ============================================================
DREAM_SYMBOLS = {
    "水": {"zhou": "水为财，梦见清水主财运亨通，浑水则需防小人", "psych": "水象征潜意识和情感流动，清澈代表内心平静，浑浊代表情绪困扰", "element": "水", "luck": 7},
    "火": {"zhou": "火主旺盛，梦见火焰升腾主事业兴旺", "psych": "火象征激情、愤怒或转变的力量，也可能代表创造力的迸发", "element": "火", "luck": 8},
    "飞": {"zhou": "梦见飞翔主志向高远，将有贵人相助", "psych": "飞翔代表对自由的渴望，也可能反映对现实束缚的逃避心理", "element": "风", "luck": 9},
    "蛇": {"zhou": "蛇为小龙，梦见蛇主财运，但需防口舌是非", "psych": "蛇在荣格心理学中象征智慧与本能，也代表被压抑的恐惧或欲望", "element": "土", "luck": 6},
    "猫": {"zhou": "梦见猫主有小人暗算，需谨慎交友", "psych": "猫象征独立性和女性特质，也可能代表直觉和神秘感", "element": "金", "luck": 5},
    "狗": {"zhou": "狗为忠义之兽，梦见狗主有贵人相助，忠友不离", "psych": "狗象征忠诚和友谊，也可能反映对被保护的需求", "element": "土", "luck": 8},
    "鱼": {"zhou": "鱼主富贵，梦见鱼跃龙门主事业高升", "psych": "鱼象征潜意识中的洞察力，也代表丰饶和生命力", "element": "水", "luck": 9},
    "树": {"zhou": "树主根基稳固，梦见大树主家业兴旺", "psych": "树象征生命力和成长，树根代表潜意识，树冠代表意识层面", "element": "木", "luck": 7},
    "花": {"zhou": "花主美好姻缘，梦见花开主感情顺遂", "psych": "花象征美好、短暂与绽放，也可能代表对爱情的期待", "element": "木", "luck": 8},
    "山": {"zhou": "山主稳重，梦见高山主事业有靠山", "psych": "山象征障碍或目标，攀登山峰代表追求成就的动力", "element": "土", "luck": 7},
    "雨": {"zhou": "雨主润泽，梦见下雨主将有好运降临", "psych": "雨象征情感的释放和净化，也可能代表悲伤或忧郁", "element": "水", "luck": 6},
    "雪": {"zhou": "雪主纯洁，梦见下雪主心事将解", "psych": "雪象征纯净和新的开始，也可能代表情感的冷却", "element": "水", "luck": 7},
    "风": {"zhou": "风主变动，梦见大风主生活将有变化", "psych": "风象征变化和不确定性，也代表精神力量的流动", "element": "风", "luck": 5},
    "月亮": {"zhou": "月主阴柔，梦见明月主家庭和睦", "psych": "月亮象征女性能量、直觉和潜意识的照映", "element": "水", "luck": 8},
    "太阳": {"zhou": "日主阳刚，梦见太阳主事业光明", "psych": "太阳象征意识、活力和自我认同", "element": "火", "luck": 9},
    "星星": {"zhou": "星主希望，梦见繁星主前途光明", "psych": "星星象征理想、希望和高远的目标", "element": "火", "luck": 8},
    "房子": {"zhou": "房屋主安居，梦见新房主生活改善", "psych": "房子象征自我人格结构，不同房间代表人格的不同面向", "element": "土", "luck": 7},
    "门": {"zhou": "门主机遇，梦见开门主新机会来临", "psych": "门象征过渡和选择，打开的门代表新的可能性", "element": "金", "luck": 7},
    "路": {"zhou": "路主前程，梦见大路主前途坦荡", "psych": "路象征人生方向和选择，岔路代表决策点", "element": "土", "luck": 6},
    "桥": {"zhou": "桥主过渡，梦见过桥主困难将解", "psych": "桥象征从一个状态过渡到另一个状态的转变", "element": "木", "luck": 7},
    "车": {"zhou": "车主出行，梦见坐车主将有远行或变动", "psych": "车象征人生旅途中的控制感，驾驶代表自主性", "element": "金", "luck": 6},
    "船": {"zhou": "船主远行，梦见乘船主将有贵人引路", "psych": "船象征穿越情感海洋的工具，也代表人生旅程", "element": "水", "luck": 7},
    "钱": {"zhou": "梦见捡钱主意外之财，丢钱则需防破财", "psych": "金钱象征自我价值感和安全感", "element": "金", "luck": 8},
    "考试": {"zhou": "梦见考试主将受考验，需做好准备", "psych": "考试梦反映对被评判的焦虑和对自我能力的怀疑", "element": "火", "luck": 5},
    "迟到": {"zhou": "梦见迟到主错失良机，需把握时机", "psych": "迟到梦反映对时间压力和责任的焦虑感", "element": "风", "luck": 4},
    "掉牙": {"zhou": "掉牙主亲人健康需关注，也主蜕变新生", "psych": "掉牙梦反映对衰老、失去控制或外貌的焦虑", "element": "金", "luck": 4},
    "怀孕": {"zhou": "梦见怀孕主有新计划酝酿，将有喜事", "psych": "怀孕象征创造力和新项目的孕育", "element": "木", "luck": 8},
    "死亡": {"zhou": "梦见死亡反主长寿，旧事将了结", "psych": "死亡象征结束和新的开始，代表人格的转化", "element": "水", "luck": 6},
    "婚礼": {"zhou": "梦见婚礼主合作或结盟，有喜事临门", "psych": "婚礼象征内在对立面的整合与和谐", "element": "火", "luck": 9},
    "孩子": {"zhou": "梦见小孩主纯真，将有新的开始", "psych": "孩子象征内在小孩、纯真和新的可能性", "element": "木", "luck": 8},
    "老人": {"zhou": "梦见老人主智慧，将得长辈指点", "psych": "老人象征智慧原型，代表内在的指导力量", "element": "土", "luck": 7},
    "追赶": {"zhou": "梦见被追主有压力，需正面应对", "psych": "被追赶反映逃避现实问题的心理，追赶者往往是被压抑的自我", "element": "风", "luck": 4},
    "坠落": {"zhou": "梦见坠落主失控感，需稳住心态", "psych": "坠落梦反映对失去控制的恐惧和不安全感", "element": "风", "luck": 3},
    "裸体": {"zhou": "梦见裸体主坦诚，有事将真相大白", "psych": "裸体梦反映对暴露和脆弱的恐惧", "element": "火", "luck": 5},
    "镜子": {"zhou": "镜主反思，梦见照镜主需审视自身", "psych": "镜子象征自我审视和对真实自我的探索", "element": "金", "luck": 6},
    "钥匙": {"zhou": "钥匙主解决，梦见钥匙主困难将迎刃而解", "psych": "钥匙象征解决问题的方法和进入新领域的途径", "element": "金", "luck": 8},
    "书": {"zhou": "梦见读书主学业进步，考运亨通", "psych": "书象征知识、学习和自我提升的渴望", "element": "木", "luck": 7},
    "食物": {"zhou": "梦见美食主生活富足，有口福", "psych": "食物象征精神滋养和情感需求的满足", "element": "土", "luck": 7},
    "血": {"zhou": "梦见血主有财运，但需注意健康", "psych": "血象征生命力、激情和深层情感", "element": "火", "luck": 6},
    "哭": {"zhou": "梦中哭泣反主喜事将至", "psych": "哭泣反映被压抑的情感需要释放", "element": "水", "luck": 7},
    "笑": {"zhou": "梦中大笑需防乐极生悲", "psych": "笑可能掩盖内在的紧张或焦虑", "element": "火", "luck": 5},
    "电话": {"zhou": "梦见打电话主有消息传来", "psych": "电话象征与他人或自我内在的沟通需求", "element": "风", "luck": 6},
    "飞机": {"zhou": "梦见飞机主远大前程，事业腾飞", "psych": "飞机象征快速的进步和高远的目标追求", "element": "风", "luck": 8},
    "海": {"zhou": "梦见大海主心胸开阔，将有大发展", "psych": "海洋象征集体潜意识和无限的可能性", "element": "水", "luck": 8},
    "森林": {"zhou": "梦见森林主探索未知，需谨慎前行", "psych": "森林象征潜意识的深处和未知的自我领域", "element": "木", "luck": 6},
    "龙": {"zhou": "龙主大贵，梦见龙主有极大好运", "psych": "龙象征强大的生命力和超越的力量", "element": "火", "luck": 10},
    "凤凰": {"zhou": "凤凰主涅槃重生，梦见凤凰主否极泰来", "psych": "凤凰象征死亡与重生的循环转化", "element": "火", "luck": 9},
    "乌龟": {"zhou": "龟主长寿，梦见龟主健康长寿", "psych": "乌龟象征智慧、耐心和自我保护", "element": "水", "luck": 7},
    "马": {"zhou": "马主奔腾，梦见骏马主事业一马当先", "psych": "马象征力量、自由和本能的驱动力", "element": "火", "luck": 8},
    "鸟": {"zhou": "鸟主自由，梦见飞鸟主好消息将至", "psych": "鸟象征精神自由和超越物质的追求", "element": "风", "luck": 7},
    "蜘蛛": {"zhou": "蜘蛛主编织，梦见蜘蛛主有人暗中布局", "psych": "蜘蛛象征创造力和命运的编织者", "element": "土", "luck": 5},
    "蝴蝶": {"zhou": "蝶主变化，梦见蝴蝶主将有美好蜕变", "psych": "蝴蝶象征转化、美丽和灵魂的自由", "element": "风", "luck": 8},
    "老虎": {"zhou": "虎主威严，梦见老虎主有贵人但需谨慎", "psych": "老虎象征强大的本能力量和潜在的威胁", "element": "金", "luck": 7},
    "兔子": {"zhou": "兔主机敏，梦见兔子主好运和灵活应变", "psych": "兔子象征敏感、生育力和直觉", "element": "木", "luck": 7},
    "下楼梯": {"zhou": "下楼主沉淀，梦见下楼梯主回归本心", "psych": "下楼梯象征深入潜意识的探索", "element": "土", "luck": 6},
    "上楼梯": {"zhou": "上楼主进步，梦见上楼梯主步步高升", "psych": "上楼梯象征意识的提升和目标的追求", "element": "火", "luck": 8},
    "游泳": {"zhou": "梦见游泳主在困境中自如应对", "psych": "游泳象征在情感世界中的适应能力", "element": "水", "luck": 7},
    "跑步": {"zhou": "梦见跑步主追求目标，需加倍努力", "psych": "跑步反映对目标的追求或对某事的逃避", "element": "风", "luck": 6},
    "下雨天": {"zhou": "雨天主洗涤，梦见雨天主烦恼将消", "psych": "雨天象征情绪的低落期和内在的清洗", "element": "水", "luck": 6},
    "彩虹": {"zhou": "虹主吉祥，梦见彩虹主好事将近", "psych": "彩虹象征希望、承诺和困难后的美好", "element": "火", "luck": 9},
}

# 五行相生相克
WUXING_CYCLE = {"木": "火", "火": "土", "土": "金", "金": "水", "水": "木"}
WUXING_CLASH = {"木": "土", "火": "金", "土": "水", "金": "木", "水": "火"}

# 心理学分析框架
PSYCH_FRAMEWORKS = {
    "弗洛伊德": "梦是潜意识愿望的伪装满足。梦中的符号往往与被压抑的欲望、童年经历有关。",
    "荣格": "梦是潜意识与意识的对话。梦中的原型意象(阴影、阿尼玛/阿尼姆斯、自性)反映人格整合的过程。",
    "阿德勒": "梦反映个体对未来的准备和期望，与生活目标和社会兴趣密切相关。",
    "格式塔": "梦中的每个元素都是做梦者人格的投射，通过角色扮演可以整合分裂的自我。",
    "认知行为": "梦反映日常认知模式和核心信念，反复出现的梦境主题揭示认知偏差。",
}

DREAM_DIARY_DIR = os.path.expanduser("~/.openclaw/workspace/skills/dream-interpreter/diary")

def ensure_diary_dir():
    if not os.path.exists(DREAM_DIARY_DIR):
        os.makedirs(DREAM_DIARY_DIR, exist_ok=True)

def save_diary(dream_text, analysis):
    ensure_diary_dir()
    now = datetime.now()
    filename = now.strftime("%Y-%m-%d_%H%M%S") + ".md"
    filepath = os.path.join(DREAM_DIARY_DIR, filename)
    content = "# 梦境日记 - {date}\n\n".format(date=now.strftime("%Y-%m-%d %H:%M"))
    content += "## 梦境描述\n{text}\n\n".format(text=dream_text)
    content += "## 解析结果\n{result}\n".format(result=analysis)
    with open(filepath, "w", encoding="utf-8") as fh:
        fh.write(content)
    return filepath

def find_symbols(text):
    found = []
    for symbol in DREAM_SYMBOLS:
        if symbol in text:
            found.append(symbol)
    return found

def calc_luck_score(symbols):
    if not symbols:
        return random.randint(5, 7)
    scores = [DREAM_SYMBOLS[s]["luck"] for s in symbols]
    base = sum(scores) / len(scores)
    day_seed = int(datetime.now().strftime("%Y%m%d"))
    random.seed(day_seed + hash(tuple(symbols)))
    adj = random.uniform(-1.0, 1.0)
    random.seed()
    return min(10, max(1, round(base + adj, 1)))

def analyze_elements(symbols):
    elements = {}
    for s in symbols:
        el = DREAM_SYMBOLS[s]["element"]
        elements[el] = elements.get(el, 0) + 1
    return elements

def get_element_analysis(elements):
    if not elements:
        return "未检测到明显的五行倾向"
    dominant = max(elements, key=elements.get)
    generates = WUXING_CYCLE.get(dominant, "")
    clashes = WUXING_CLASH.get(dominant, "")
    lines = []
    lines.append("主导五行: {el} (出现{n}次)".format(el=dominant, n=elements[dominant]))
    lines.append("五行分布: {dist}".format(dist=" | ".join(["{k}:{v}".format(k=k, v=v) for k, v in sorted(elements.items())])))
    lines.append("{el}生{gen} — 建议关注{gen}相关的事物以增强运势".format(el=dominant, gen=generates))
    lines.append("{el}克{clash} — 需注意{clash}相关的冲突".format(el=dominant, clash=clashes))
    return "\n".join(lines)

def interpret_dream(text):
    if not text.strip():
        return show_help()

    # 检查是否是查看日记的命令
    lower = text.strip().lower()
    if lower in ("diary", "日记", "查看日记"):
        return show_diary()
    if lower in ("symbols", "符号", "符号表"):
        return show_symbols()
    if lower in ("help", "帮助"):
        return show_help()

    symbols = find_symbols(text)
    luck = calc_luck_score(symbols)
    elements = analyze_elements(symbols)

    lines = []
    lines.append("=" * 50)
    lines.append("  DREAM INTERPRETER | 解梦大师")
    lines.append("=" * 50)
    lines.append("")
    lines.append("[ 梦境描述 ]")
    lines.append(text)
    lines.append("")

    if symbols:
        lines.append("[ 识别到的梦境意象 ] ({n}个)".format(n=len(symbols)))
        lines.append("-" * 40)
        for s in symbols:
            info = DREAM_SYMBOLS[s]
            lines.append("")
            lines.append("  {icon} {sym} ({el})".format(icon="*", sym=s, el=info["element"]))
            lines.append("  -- 周公解梦: {zhou}".format(zhou=info["zhou"]))
            lines.append("  -- 心理分析: {psych}".format(psych=info["psych"]))
    else:
        lines.append("[ 未识别到常见梦境意象 ]")
        lines.append("您的梦境较为独特，以下提供通用分析框架")

    lines.append("")
    lines.append("[ 五行分析 ]")
    lines.append("-" * 40)
    lines.append(get_element_analysis(elements))

    lines.append("")
    lines.append("[ 综合运势指数 ]: {score}/10 {bar}".format(
        score=luck,
        bar="*" * int(luck) + "." * (10 - int(luck))
    ))

    # 根据运势给建议
    if luck >= 8:
        lines.append(">> 整体大吉！此梦预示好运将至，宜积极行动")
    elif luck >= 6:
        lines.append(">> 运势中上，稳中求进，注意把握机会")
    elif luck >= 4:
        lines.append(">> 运势平平，宜低调行事，韬光养晦")
    else:
        lines.append(">> 运势偏低，建议谨慎行事，多加注意")

    # 随机选择一个心理学框架进行分析
    framework_name = random.choice(list(PSYCH_FRAMEWORKS.keys()))
    framework_desc = PSYCH_FRAMEWORKS[framework_name]

    lines.append("")
    lines.append("[ 心理学视角 - {name}学派 ]".format(name=framework_name))
    lines.append("-" * 40)
    lines.append(framework_desc)

    if symbols:
        lines.append("")
        if framework_name == "荣格":
            arch_map = {"水": "阴影", "火": "英雄", "风": "精神", "土": "大母神", "金": "智慧老人", "木": "重生"}
            archetypes = set()
            for s in symbols:
                el = DREAM_SYMBOLS[s]["element"]
                if el in arch_map:
                    archetypes.add(arch_map[el])
            if archetypes:
                lines.append("涉及的荣格原型: {archs}".format(archs="、".join(archetypes)))
                lines.append("建议通过积极想象法与这些原型对话，促进人格整合")
        elif framework_name == "弗洛伊德":
            lines.append("梦中的 {syms} 可能是潜意识愿望的象征性表达".format(syms="、".join(symbols)))
            lines.append("建议回忆近期是否有被压抑的想法或未满足的需求")
        else:
            lines.append("梦中出现的 {syms} 值得在清醒状态下进一步探索".format(syms="、".join(symbols)))

    lines.append("")
    lines.append("[ 行动建议 ]")
    lines.append("-" * 40)
    suggestions = [
        "记录此梦的细节，注意反复出现的主题",
        "关注梦中的情绪感受，它比具体情节更重要",
        "如果此梦反复出现，可能有重要的潜意识信息需要关注",
        "尝试在入睡前设定意图，引导梦境的方向",
        "白天遇到与梦境相似的场景时，注意内心的反应",
    ]
    for sug in suggestions[:3]:
        lines.append("  - {s}".format(s=sug))

    # 保存日记
    analysis_text = "\n".join(lines)
    diary_path = save_diary(text, analysis_text)
    lines.append("")
    lines.append("[ 梦境已记录 ] -> {path}".format(path=diary_path))
    lines.append("")

    return "\n".join(lines)

def show_symbols():
    lines = []
    lines.append("=" * 50)
    lines.append("  梦境符号数据库 ({n}个意象)".format(n=len(DREAM_SYMBOLS)))
    lines.append("=" * 50)
    by_element = {}
    for sym, info in DREAM_SYMBOLS.items():
        el = info["element"]
        if el not in by_element:
            by_element[el] = []
        by_element[el].append(sym)
    for el in ["金", "木", "水", "火", "土", "风"]:
        if el in by_element:
            lines.append("")
            lines.append("[ {el} ] {syms}".format(el=el, syms=" | ".join(by_element[el])))
    lines.append("")
    lines.append("使用方法: 描述你的梦境，系统将自动识别其中的意象")
    return "\n".join(lines)

def show_diary():
    ensure_diary_dir()
    files = sorted([f for f in os.listdir(DREAM_DIARY_DIR) if f.endswith(".md")], reverse=True)
    if not files:
        return "暂无梦境日记记录。描述一个梦境即可自动记录！"
    lines = []
    lines.append("=" * 50)
    lines.append("  梦境日记 (最近10条)")
    lines.append("=" * 50)
    for f in files[:10]:
        filepath = os.path.join(DREAM_DIARY_DIR, f)
        with open(filepath, "r", encoding="utf-8") as fh:
            first_lines = fh.read().split("\n")[:5]
        date_part = f.replace(".md", "").replace("_", " ")
        lines.append("")
        lines.append("- {date}".format(date=date_part))
        for fl in first_lines[3:5]:
            if fl.strip():
                lines.append("  {line}".format(line=fl.strip()[:60]))
    lines.append("")
    lines.append("日记目录: {d}".format(d=DREAM_DIARY_DIR))
    return "\n".join(lines)

def show_help():
    return """==================================================
  DREAM INTERPRETER | 解梦大师
==================================================

用法:
  描述你的梦境内容，系统将自动解析

命令:
  <梦境描述>    解析梦境 (如: 梦见在水里游泳看到一条蛇)
  symbols/符号表  查看所有梦境意象符号
  diary/日记     查看梦境日记记录
  help/帮助      显示此帮助

示例:
  梦见在山上飞翔看到彩虹
  昨晚梦到蛇和水
  梦见考试迟到了

特色:
  - 60+ 常见梦境意象数据库
  - 周公解梦 + 心理学双重解析
  - 五行分析与运势评估
  - 自动保存梦境日记"""

result = interpret_dream(INPUT)
print(result)
PYEOF

echo ""
echo "Powered by BytesAgain | bytesagain.com"
