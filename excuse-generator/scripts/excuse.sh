#!/usr/bin/env bash
# excuse-generator — 借口生成器
# 场景分类、借口数据库、可信度评分、随机生成
set -euo pipefail

INPUT="${1:-${INPUT:-}}"

python3 << 'PYEOF'
import sys, os, random, hashlib
from datetime import datetime

INPUT = os.environ.get("INPUT", "")
if len(sys.argv) > 1:
    INPUT = " ".join(sys.argv[1:])

# ============================================================
# 借口数据库 - 按场景分类
# ============================================================
EXCUSES = {
    "请假": {
        "高可信": [
            {"text": "家里水管爆了，需要等维修师傅上门", "credibility": 9, "tip": "拍一张水渍照片备用"},
            {"text": "昨晚突然发烧38.5度，今天去医院检查", "credibility": 9, "tip": "可以去社区医院开个证明"},
            {"text": "父母从老家来，需要去车站接他们", "credibility": 8, "tip": "适合提前一天请假"},
            {"text": "牙疼得厉害，约了牙医今天看诊", "credibility": 9, "tip": "牙疼是最难被质疑的病"},
            {"text": "孩子学校临时通知家长会", "credibility": 8, "tip": "适合有孩子的同事使用"},
            {"text": "社区通知今天必须在家做燃气安全检查", "credibility": 8, "tip": "燃气检查确实需要有人在家"},
            {"text": "身份证到期了，需要去派出所办理", "credibility": 9, "tip": "政务办理只能工作日去"},
            {"text": "昨晚吃坏了肚子，上吐下泻", "credibility": 8, "tip": "肠胃炎恢复需要1-2天"},
            {"text": "车坏在路上了，等拖车来", "credibility": 7, "tip": "适合开车通勤的人"},
            {"text": "房东说今天有人来看房，必须在场", "credibility": 7, "tip": "适合租房族"},
        ],
        "中可信": [
            {"text": "昨晚失眠到凌晨四点，实在起不来", "credibility": 6, "tip": "偶尔用一次可以，频繁使用会减分"},
            {"text": "表弟结婚，需要回老家帮忙", "credibility": 6, "tip": "最好在周末前后使用"},
            {"text": "快递送了个大件家具，需要在家等签收组装", "credibility": 5, "tip": "只适合请半天假"},
            {"text": "头痛得厉害，可能是颈椎问题", "credibility": 6, "tip": "适合长期伏案工作的人"},
            {"text": "家里老人身体不舒服，需要陪去检查", "credibility": 7, "tip": "不要频繁使用，容易穿帮"},
        ],
        "低可信": [
            {"text": "闹钟没响，睡过了", "credibility": 3, "tip": "过于老套，建议配合其他理由"},
            {"text": "做了个噩梦，状态很差", "credibility": 2, "tip": "除非领导很开明，否则不建议"},
            {"text": "宠物生病了", "credibility": 4, "tip": "爱宠人士可能理解，但不是所有领导都买账"},
        ],
    },
    "迟到": {
        "高可信": [
            {"text": "地铁临时停运/故障，换了其他交通方式", "credibility": 9, "tip": "可以查一下当天是否真有故障"},
            {"text": "路上出了交通事故（不是我），堵车严重", "credibility": 9, "tip": "拍一张堵车照片"},
            {"text": "电梯坏了，爬了20层楼", "credibility": 8, "tip": "适合住高楼的人"},
            {"text": "出门发现车胎没气了，临时换了交通方式", "credibility": 8, "tip": "适合开车通勤的人"},
            {"text": "小区门口有施工，被拦住等了20分钟", "credibility": 8, "tip": "合理且难验证"},
            {"text": "公交车抛锚了，等了两班车", "credibility": 8, "tip": "公交故障很常见"},
            {"text": "共享单车扫了三辆都是坏的", "credibility": 7, "tip": "最后一公里的通用借口"},
            {"text": "早上送孩子上学时学校有事耽搁了", "credibility": 8, "tip": "有孩子的同事专用"},
        ],
        "中可信": [
            {"text": "早上跑步扭到脚了，走路很慢", "credibility": 6, "tip": "需要配合适当的表演"},
            {"text": "钥匙忘在家里了，找锁匠开门耽误了", "credibility": 6, "tip": "一年最多用一次"},
            {"text": "出门忘带工牌/电脑，折返回去拿", "credibility": 6, "tip": "诚实但暴露粗心"},
        ],
        "低可信": [
            {"text": "表坏了/手机没电不知道时间", "credibility": 2, "tip": "在智能手机时代基本没人信"},
            {"text": "走错路了", "credibility": 3, "tip": "除非你是新员工"},
        ],
    },
    "拒绝邀请": {
        "高可信": [
            {"text": "那天已经有约了，之前答应了朋友", "credibility": 8, "tip": "简单直接，不要编太多细节"},
            {"text": "最近在吃药，医生说不能喝酒/熬夜", "credibility": 8, "tip": "适合拒绝聚餐"},
            {"text": "家里有人过生日，已经订了餐厅", "credibility": 8, "tip": "家庭活动优先级高"},
            {"text": "最近项目很赶，周末要加班", "credibility": 7, "tip": "工作忙是万能理由"},
            {"text": "那天要考试/考证，需要复习", "credibility": 8, "tip": "学习型借口很正面"},
            {"text": "老家有亲戚来，需要招待", "credibility": 7, "tip": "亲戚来访难拒绝"},
            {"text": "约了搬家公司那天搬家", "credibility": 8, "tip": "搬家借口不可能被要求改期"},
            {"text": "提前约了体检/看牙/复查", "credibility": 8, "tip": "医疗预约最难被质疑"},
        ],
        "中可信": [
            {"text": "最近减肥，不太方便聚餐", "credibility": 5, "tip": "可能被说随便吃点就好"},
            {"text": "有点社恐，人多的场合不太舒服", "credibility": 5, "tip": "诚实但可能让人担心"},
            {"text": "最近在存钱，减少不必要的开支", "credibility": 5, "tip": "诚实但可能被劝说"},
        ],
        "低可信": [
            {"text": "那天天气不好不想出门", "credibility": 2, "tip": "太随意了"},
            {"text": "忘了，等我看看日历", "credibility": 3, "tip": "拖延战术，迟早要给答复"},
        ],
    },
    "忘事": {
        "高可信": [
            {"text": "最近事情太多，这个确实漏掉了，马上补", "credibility": 8, "tip": "承认+立即行动，最加分"},
            {"text": "我记在备忘录里了但手机更新后数据丢了", "credibility": 7, "tip": "技术故障是好挡箭牌"},
            {"text": "我记得设了提醒但没响，可能是手机问题", "credibility": 7, "tip": "暗示你有在努力记住"},
            {"text": "邮件太多被淹没了，刚翻到这条", "credibility": 7, "tip": "适合工作场景"},
            {"text": "我以为是下周的deadline", "credibility": 6, "tip": "日期搞混很常见"},
            {"text": "那天正好有紧急事情打断了，回来就忘了", "credibility": 7, "tip": "被打断是合理的遗忘原因"},
        ],
        "中可信": [
            {"text": "最近睡眠不好，记忆力下降", "credibility": 5, "tip": "适合偶尔使用"},
            {"text": "同事跟我说的时候我在开会，没记住", "credibility": 5, "tip": "多任务处理的合理借口"},
        ],
        "低可信": [
            {"text": "我不知道有这回事", "credibility": 2, "tip": "如果有聊天记录会被打脸"},
            {"text": "我以为别人会做", "credibility": 3, "tip": "推责不可取"},
        ],
    },
    "缺席": {
        "高可信": [
            {"text": "临时被叫去处理一个紧急客户投诉", "credibility": 8, "tip": "适合工作相关的会议缺席"},
            {"text": "家里突然停电了（远程办公场景）", "credibility": 8, "tip": "适合线上会议"},
            {"text": "网络突然断了，一直在尝试重连", "credibility": 8, "tip": "线上会议万能理由"},
            {"text": "之前的会议拖堂了没赶上", "credibility": 7, "tip": "会议冲突很常见"},
            {"text": "日历上时间记错了，以为是下午的", "credibility": 6, "tip": "如果日历确实可以佐证"},
        ],
        "中可信": [
            {"text": "会议链接打不开，后来发现链接过期了", "credibility": 5, "tip": "技术问题类借口"},
            {"text": "我以为这次是可选参加的", "credibility": 5, "tip": "适合非关键会议"},
        ],
        "低可信": [
            {"text": "完全忘了有这个会", "credibility": 3, "tip": "太直白了"},
        ],
    },
}

# 可信度评级
def credibility_rating(score):
    if score >= 8:
        return "极高 - 基本不会被怀疑"
    elif score >= 6:
        return "较高 - 大部分人会相信"
    elif score >= 4:
        return "一般 - 可能被追问细节"
    else:
        return "较低 - 容易被看穿"

def credibility_bar(score):
    filled = int(score)
    empty = 10 - filled
    return "[" + "#" * filled + "." * empty + "] {s}/10".format(s=score)

def list_categories():
    lines = []
    lines.append("=" * 50)
    lines.append("  EXCUSE GENERATOR | 借口生成器")
    lines.append("=" * 50)
    lines.append("")
    lines.append("可用场景分类:")
    lines.append("")
    for cat in EXCUSES:
        total = sum(len(v) for v in EXCUSES[cat].values())
        lines.append("  [{cat}]  共{n}个借口".format(cat=cat, n=total))
    lines.append("")
    lines.append("用法:")
    lines.append("  请假          查看请假类借口")
    lines.append("  迟到          查看迟到类借口")
    lines.append("  拒绝邀请      查看拒绝邀请类借口")
    lines.append("  忘事          查看忘事类借口")
    lines.append("  缺席          查看缺席类借口")
    lines.append("  随机          随机生成一个高可信借口")
    lines.append("  随机 请假     随机生成一个请假借口")
    lines.append("  全部          查看所有借口")
    lines.append("  <描述场景>    智能匹配推荐借口")
    lines.append("")
    lines.append("示例:")
    lines.append("  明天不想上班")
    lines.append("  老板问我为什么迟到")
    lines.append("  朋友约饭不想去")
    return "\n".join(lines)

def show_category(cat):
    if cat not in EXCUSES:
        return "未找到分类: {c}\n可用分类: {cats}".format(c=cat, cats=" | ".join(EXCUSES.keys()))
    data = EXCUSES[cat]
    lines = []
    lines.append("=" * 50)
    lines.append("  [{cat}] 借口库".format(cat=cat))
    lines.append("=" * 50)
    for level in ["高可信", "中可信", "低可信"]:
        if level in data:
            lines.append("")
            lines.append("--- {lv} ---".format(lv=level))
            for i, exc in enumerate(data[level], 1):
                lines.append("")
                lines.append("  {n}. {text}".format(n=i, text=exc["text"]))
                lines.append("     可信度: {bar}".format(bar=credibility_bar(exc["credibility"])))
                lines.append("     {rating}".format(rating=credibility_rating(exc["credibility"])))
                lines.append("     TIP: {tip}".format(tip=exc["tip"]))
    return "\n".join(lines)

def random_excuse(category=None):
    if category and category in EXCUSES:
        cats = {category: EXCUSES[category]}
    else:
        cats = EXCUSES

    # 优先从高可信中选
    high_pool = []
    for cat, levels in cats.items():
        for exc in levels.get("高可信", []):
            high_pool.append((cat, exc))

    if not high_pool:
        return "没有找到合适的借口"

    cat, exc = random.choice(high_pool)
    lines = []
    lines.append("=" * 50)
    lines.append("  RANDOM EXCUSE | 随机借口")
    lines.append("=" * 50)
    lines.append("")
    lines.append("  场景: [{cat}]".format(cat=cat))
    lines.append("")
    lines.append("  >>> {text}".format(text=exc["text"]))
    lines.append("")
    lines.append("  可信度: {bar}".format(bar=credibility_bar(exc["credibility"])))
    lines.append("  评级: {rating}".format(rating=credibility_rating(exc["credibility"])))
    lines.append("  使用技巧: {tip}".format(tip=exc["tip"]))
    lines.append("")
    lines.append("  [ 不满意？再输入 '随机' 换一个 ]")
    return "\n".join(lines)

def smart_match(text):
    """根据用户描述智能匹配借口"""
    keywords_map = {
        "请假": ["请假", "不想上班", "休息", "不去公司", "不想去", "翘班", "病假", "事假"],
        "迟到": ["迟到", "晚了", "来晚", "没赶上", "堵车", "起晚"],
        "拒绝邀请": ["不想去", "拒绝", "推掉", "聚餐", "约饭", "唱歌", "邀请", "party", "饭局", "应酬"],
        "忘事": ["忘了", "忘记", "没做", "漏掉", "忘掉", "deadline"],
        "缺席": ["缺席", "没参加", "没去", "会议", "活动", "旷"],
    }

    scores = {}
    for cat, keywords in keywords_map.items():
        score = 0
        for kw in keywords:
            if kw in text:
                score += 1
        if score > 0:
            scores[cat] = score

    if not scores:
        # 默认推荐随机
        return random_excuse()

    best_cat = max(scores, key=scores.get)
    lines = []
    lines.append("=" * 50)
    lines.append("  SMART MATCH | 智能匹配")
    lines.append("=" * 50)
    lines.append("")
    lines.append("  根据你的描述，推荐 [{cat}] 类借口:".format(cat=best_cat))
    lines.append("")

    # 推荐前3个高可信借口
    high = EXCUSES[best_cat].get("高可信", [])
    picks = random.sample(high, min(3, len(high)))
    for i, exc in enumerate(picks, 1):
        lines.append("  推荐{n}:".format(n=i))
        lines.append("  >>> {text}".format(text=exc["text"]))
        lines.append("  可信度: {bar}  |  TIP: {tip}".format(
            bar=credibility_bar(exc["credibility"]),
            tip=exc["tip"]
        ))
        lines.append("")

    lines.append("  输入 '{cat}' 查看该分类全部借口".format(cat=best_cat))
    return "\n".join(lines)

def show_all():
    lines = []
    lines.append("=" * 50)
    lines.append("  EXCUSE DATABASE | 借口大全")
    lines.append("=" * 50)
    total = 0
    for cat in EXCUSES:
        cat_total = sum(len(v) for v in EXCUSES[cat].values())
        total += cat_total
    lines.append("  共 {n} 个借口".format(n=total))
    for cat in EXCUSES:
        lines.append("")
        lines.append(show_category(cat))
    return "\n".join(lines)

def main():
    text = INPUT.strip()
    if not text:
        print(list_categories())
        return

    lower = text.lower()

    # 直接分类查询
    for cat in EXCUSES:
        if text == cat:
            print(show_category(cat))
            return

    if lower in ("random", "随机"):
        print(random_excuse())
        return

    # 随机+分类
    parts = text.split()
    if len(parts) == 2 and parts[0] in ("随机", "random"):
        print(random_excuse(parts[1]))
        return

    if lower in ("all", "全部", "所有"):
        print(show_all())
        return

    if lower in ("help", "帮助"):
        print(list_categories())
        return

    # 智能匹配
    print(smart_match(text))

main()
PYEOF

echo ""
echo "Powered by BytesAgain | bytesagain.com"
