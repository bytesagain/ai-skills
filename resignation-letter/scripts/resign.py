#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""离职信和工作交接文档生成器 - Python 3.6+"""
from __future__ import print_function
import sys
import datetime

TODAY = datetime.date.today().strftime("%Y年%m月%d日")


def cmd_letter(args):
    """生成辞职信"""
    if len(args) < 2:
        print("用法: resign.sh letter \"公司\" \"原因\" [--tone 诚恳|简洁|感恩]")
        sys.exit(1)

    company = args[0]
    reason = args[1]
    tone = "诚恳"
    if "--tone" in args:
        idx = args.index("--tone")
        if idx + 1 < len(args):
            tone = args[idx + 1]

    tones = {
        "诚恳": {
            "opening": "经过深思熟虑，我怀着复杂的心情向您提交这封辞职信。",
            "body": "在{company}工作的这段时间里，我收获了宝贵的经验和成长。感谢公司和团队对我的培养与信任。经过慎重考虑，出于{reason}的原因，我决定离开目前的岗位。",
            "closing": "我会在离职交接期间尽最大努力完成工作交接，确保工作的平稳过渡。再次感谢公司给予的一切机会，祝愿{company}事业蒸蒸日上。",
        },
        "简洁": {
            "opening": "我在此正式提交辞职申请。",
            "body": "因{reason}，我决定辞去在{company}的现有职务。",
            "closing": "我将配合完成工作交接。感谢公司的栽培。",
        },
        "感恩": {
            "opening": "提笔写这封信，心中满是感恩与不舍。",
            "body": "回首在{company}的日子，每一天都充满意义。从入职时的青涩到现在的成长，离不开每一位同事和领导的帮助与指导。这段经历将是我职业生涯中最珍贵的财富。\n\n然而，出于{reason}的考虑，我不得不做出这个艰难的决定，向您递交辞职申请。",
            "closing": "虽然即将离开，但{company}永远是我心中的一个温暖的存在。我会认真完成所有交接工作，绝不辜负公司对我的信任。\n\n衷心祝愿{company}越来越好，也祝愿每一位同事前程似锦！",
        },
    }

    if tone not in tones:
        tone = "诚恳"

    t = tones[tone]

    print("=" * 60)
    print("辞 职 信")
    print("=" * 60)
    print("")
    print("尊敬的领导：")
    print("")
    print("  {opening}".format(opening=t["opening"]))
    print("")
    print("  {body}".format(body=t["body"].format(company=company, reason=reason)))
    print("")
    print("  {closing}".format(closing=t["closing"].format(company=company)))
    print("")
    print("  此致")
    print("")
    print("敬礼！")
    print("")
    print("                                          申请人：________")
    print("                                          日  期：{today}".format(today=TODAY))
    print("")
    print("---")
    print("（风格：{tone} | 由resignation-letter生成，请根据实际情况调整）".format(tone=tone))


def cmd_handover(args):
    """生成交接文档"""
    if len(args) < 2:
        print("用法: resign.sh handover \"岗位\" \"交接内容1,交接内容2\"")
        sys.exit(1)

    position = args[0]
    items = args[1].split(",")

    print("=" * 60)
    print("工 作 交 接 文 档")
    print("=" * 60)
    print("")
    print("交接日期：{today}".format(today=TODAY))
    print("交接岗位：{position}".format(position=position))
    print("交接人：________")
    print("接收人：________")
    print("监交人：________")
    print("")
    print("-" * 60)
    print("")
    print("## 一、交接事项清单")
    print("")
    for i, item in enumerate(items, 1):
        item = item.strip()
        print("### {i}. {item}".format(i=i, item=item))
        print("")
        print("  - 当前状态：[ ] 进行中 / [ ] 已完成 / [ ] 待处理")
        print("  - 相关文档：")
        print("  - 注意事项：")
        print("  - 联系人：")
        print("")

    print("## 二、账号与权限")
    print("")
    print("| 序号 | 系统/平台 | 账号 | 备注 |")
    print("|------|----------|------|------|")
    print("| 1    |          |      |      |")
    print("| 2    |          |      |      |")
    print("| 3    |          |      |      |")
    print("")
    print("## 三、重要联系人")
    print("")
    print("| 序号 | 姓名 | 部门/公司 | 联系方式 | 对接事项 |")
    print("|------|------|----------|---------|---------|")
    print("| 1    |      |          |         |         |")
    print("| 2    |      |          |         |         |")
    print("")
    print("## 四、待办事项")
    print("")
    print("- [ ] ")
    print("- [ ] ")
    print("- [ ] ")
    print("")
    print("## 五、交接确认")
    print("")
    print("交接人签字：________  日期：________")
    print("接收人签字：________  日期：________")
    print("监交人签字：________  日期：________")
    print("")
    print("---")
    print("（由resignation-letter生成，请补充具体内容）")


def cmd_interview(args):
    """离职面谈准备"""
    print("=" * 60)
    print("离职面谈准备指南")
    print("=" * 60)
    print("")
    print("## 一、面谈前准备")
    print("")
    print("1. 明确自己的离职原因，准备简洁清晰的表述")
    print("2. 回顾在公司的成长和收获，准备感谢的话")
    print("3. 了解公司离职流程和时间节点")
    print("4. 准备好回答以下常见问题")
    print("")
    print("## 二、常见问题与参考回答")
    print("")
    qa = [
        ("为什么要离职？", "以职业发展、个人规划等正面原因回答，避免抱怨。\n     参考：\"感谢公司给我的成长机会。经过认真思考，我希望在XX方向继续探索和发展。\""),
        ("对公司有什么建议？", "客观提出建设性意见，不带情绪。\n     参考：\"建议加强XX方面的建设，比如...\""),
        ("有没有挽留的可能？", "如果决心已定，温和但坚定地表明态度。\n     参考：\"非常感谢领导的认可。这个决定是经过深思熟虑的...\""),
        ("什么时候可以办完交接？", "给出合理的时间节点。\n     参考：\"我会在X周内完成所有交接工作，确保平稳过渡。\""),
        ("下一步打算？", "可以适当分享，也可以选择不透露。\n     参考：\"我计划在XX领域继续发展\" 或 \"还在规划中\""),
    ]
    for i, (q, a) in enumerate(qa, 1):
        print("**Q{i}: {q}**".format(i=i, q=q))
        print("   A: {a}".format(a=a))
        print("")

    print("## 三、注意事项")
    print("")
    print("- ✅ 保持专业和礼貌，不要情绪化")
    print("- ✅ 对公司和同事表示感谢")
    print("- ✅ 表明愿意配合完成交接")
    print("- ❌ 不要说前同事/领导的坏话")
    print("- ❌ 不要透露下家公司的机密信息")
    print("- ❌ 不要在社交媒体上发表负面言论")
    print("")
    print("## 四、面谈后")
    print("")
    print("1. 按约定完成工作交接")
    print("2. 保持与同事的良好关系")
    print("3. 收集离职证明、社保转移等材料")
    print("4. 做好竞业限制的确认（如有）")


def cmd_checklist(args):
    """离职流程清单"""
    print("=" * 60)
    print("离职流程清单")
    print("=" * 60)
    print("")
    print("日期：{today}".format(today=TODAY))
    print("")

    sections = [
        ("提出离职（提前30天）", [
            "向直属领导口头沟通离职意向",
            "提交书面辞职信/邮件",
            "确认最后工作日",
            "了解公司离职流程和所需材料",
        ]),
        ("工作交接（离职前2-4周）", [
            "整理当前工作内容和进度",
            "编写交接文档",
            "与接手人进行交接",
            "确保所有项目有人跟进",
            "交接完毕后双方确认签字",
        ]),
        ("行政手续（离职前1周）", [
            "归还公司设备（电脑、工牌、钥匙等）",
            "清理个人物品",
            "归还公司资料和文件",
            "注销/移交工作账号",
            "结清财务事项（报销、借款等）",
        ]),
        ("离职手续（最后工作日）", [
            "签署离职交接单",
            "获取离职证明",
            "确认社保、公积金停缴时间",
            "了解档案转移事宜",
            "确认竞业限制协议（如有）",
            "获取薪资结算单",
        ]),
        ("离职后", [
            "保存好离职证明（电子+纸质）",
            "办理社保、公积金转移",
            "更新个人档案",
            "与前同事保持良好关系",
            "如有竞业限制，遵守相关约定",
        ]),
    ]

    for title, items in sections:
        print("## {title}".format(title=title))
        print("")
        for item in items:
            print("- [ ] {item}".format(item=item))
        print("")

    print("---")
    print("💡 提示：各公司流程可能有所不同，请以公司HR通知为准。")


def cmd_farewell(args):
    """告别信"""
    style = args[0] if len(args) > 0 else "真诚"

    styles = {
        "真诚": {
            "title": "一封告别信",
            "body": """亲爱的同事们：

  提笔写这封信，内心充满感慨。

  在这里工作的每一天，都让我收获了宝贵的经历和珍贵的友谊。
  从第一天入职时的紧张忐忑，到后来的得心应手，每一步成长都离不开
  你们的帮助和支持。

  感谢每一位曾经和我并肩作战的伙伴。那些一起赶deadline的深夜、
  一起头脑风暴的午后、一起庆祝项目上线的欢呼，都会成为我最珍贵的记忆。

  特别感谢[直属领导姓名]的悉心指导，是你让我从一个[青涩的新人/...]
  成长为今天的自己。

  虽然即将离开，但请相信：
  - 我的微信/手机号不会变，随时欢迎联系
  - 工作上有任何需要交接的问题，离职后也可以找我
  - 希望未来我们还能在某个路口重逢

  祝愿每一位同事前程似锦，祝愿公司越来越好！

  [你的名字]
  {date}""",
        },
        "简洁": {
            "title": "告别通知",
            "body": """各位同事：

  由于个人原因，我将于[最后工作日]正式离职。

  感谢大家一直以来的支持与配合。工作交接已安排妥当，
  如有任何问题，可联系[接手人姓名]。

  祝好。

  [你的名字]
  {date}""",
        },
        "幽默": {
            "title": "一封不正经的告别信",
            "body": """各位亲爱的"难友"们：

  是的，你们没看错，我要"越狱"了 🏃‍♂️

  经过深思熟虑（大概想了0.5秒），我决定离开这个让我
  又爱又恨的地方。别问我为什么，问就是"追求诗和远方"
  （其实是去另一个地方继续搬砖）。

  在这里的日子，有几件事我必须承认：
  - 公司的免费咖啡是我坚持到现在的主要动力
  - 和你们一起吐槽是我每天最快乐的时光
  - 中午抢不到好位置的食堂，我一点都不会想念（才怪）

  说真的，和你们共事是一段特别美好的经历。
  每个人都教会了我一些东西（包括如何在会议中优雅地摸鱼）。

  我的联系方式不变，随时可以约饭、约咖啡、约吐槽。
  唯一变的是，以后吐槽的对象可能要换成新公司了 😂

  江湖路远，后会有期！🎬

  你们永远的"前同事"
  [你的名字]
  {date}

  P.S. 工位上的零食请自行瓜分，先到先得！""",
        },
    }

    # 匹配风格
    matched_style = "真诚"
    for key in styles:
        if key in style:
            matched_style = key
            break

    s = styles[matched_style]

    print("=" * 60)
    print("  {} （风格：{}）".format(s["title"], matched_style))
    print("=" * 60)
    print("")
    print(s["body"].format(date=TODAY))
    print("")
    print("-" * 60)
    print("💡 发送建议：")
    print("  - 邮件发送给全组/全部门")
    print("  - 微信群可以发简短版本")
    print("  - 最后工作日发送，不要太早")
    print("  - 附上你的个人联系方式")
    print("-" * 60)
    print("")
    print("可选风格：真诚 | 简洁 | 幽默")
    print("用法：resign.sh farewell \"真诚\"")


def cmd_timing(args):
    """最佳辞职时机分析"""
    situation = args[0] if len(args) > 0 else ""

    print("=" * 60)
    print("  最佳辞职时机分析")
    print("=" * 60)
    print("")
    if situation:
        print("  你的情况：{}".format(situation))
        print("")

    print("-" * 60)
    print("  一、年终奖时间线（最重要！）")
    print("-" * 60)
    print("")
    print("  大多数公司年终奖发放时间：")
    print("    - 互联网公司：通常次年3-4月发放")
    print("    - 外企：通常次年2-3月发放")
    print("    - 国企：通常春节前发放")
    print("    - 创业公司：时间不定，需确认")
    print("")
    print("  ⚠️  关键规则：")
    print("    1. 大多数公司规定：在职员工才能领年终奖")
    print("    2. 提离职 ≠ 离职，提了离职通常还能拿年终奖")
    print("    3. 但部分公司规定：提出离职即不发年终奖，需看合同")
    print("")
    print("  💰 建议：拿到年终奖入账后再提离职！")
    print("")

    print("-" * 60)
    print("  二、社保公积金衔接")
    print("-" * 60)
    print("")
    print("  社保断缴影响：")
    print("    - 医保：断缴次月起无法使用医保报销")
    print("    - 养老：累计计算，断几个月影响不大")
    print("    - 公积金：断缴后无法贷款或提取")
    print("    - 生育险：部分城市要求连续缴纳12个月")
    print("")
    print("  ⚠️  重要城市规则：")
    print("    - 北京/上海：社保影响购房、购车资格（连续缴纳5年）")
    print("    - 深圳/广州：影响购房资格（连续缴纳5年）")
    print("")
    print("  💡 最佳操作：")
    print("    1. 月中前入职新公司 → 新公司当月缴社保")
    print("    2. 月末离职 → 当月社保由旧公司缴纳")
    print("    3. 无缝衔接 = 本月最后一天离职 + 下月第一天入职")
    print("")

    print("-" * 60)
    print("  三、假期盘点")
    print("-" * 60)
    print("")
    print("  离职前检查你还有多少假：")
    print("    □ 年假：未休年假应折算工资")
    print("    □ 调休：确认调休是否清零")
    print("    □ 加班：确认加班费结算方式")
    print("")
    print("  💡 年假折算公式（法定）：")
    print("    当年应休年假 = (当年已过日历天数 ÷ 365) × 全年年假天数")
    print("    未休年假补偿 = 日工资 × 200% × 未休天数")
    print("")

    print("-" * 60)
    print("  四、最佳月份参考")
    print("-" * 60)
    print("")
    print("  ✅ 推荐辞职月份：")
    print("    - 3-4月：金三银四，拿完年终奖+招聘旺季")
    print("    - 9-10月：金九银十，秋招旺季机会多")
    print("")
    print("  ⚠️  谨慎辞职月份：")
    print("    - 1-2月：春节前，年终奖未发")
    print("    - 6-8月：招聘淡季，机会少")
    print("    - 11-12月：年底不适合跳槽，等年终奖")
    print("")

    print("-" * 60)
    print("  五、辞职前 Checklist")
    print("-" * 60)
    print("")
    print("  财务类：")
    print("    □ 年终奖是否已到账")
    print("    □ 股票/期权归属情况")
    print("    □ 报销单据是否已提交")
    print("    □ 借款是否已清理")
    print("")
    print("  合同类：")
    print("    □ 竞业限制协议内容（是否激活、补偿标准）")
    print("    □ 保密协议范围")
    print("    □ 培训协议违约金（如有服务期约定）")
    print("")
    print("  衔接类：")
    print("    □ 新公司offer已签署")
    print("    □ 社保衔接方案已确认")
    print("    □ 公积金转移方式已了解")
    print("    □ 档案转移手续已咨询")
    print("")
    print("  📋 法律提示：劳动者提前30天书面通知即可解除合同")
    print("     试用期提前3天通知即可")

    print("")
    print("=" * 60)


def cmd_help():
    print("=" * 60)
    print("resignation-letter - 离职信和工作交接文档生成器")
    print("=" * 60)
    print("")
    print("用法:")
    print("  resign.sh letter \"公司\" \"原因\" [--tone 诚恳|简洁|感恩]  生成辞职信")
    print("  resign.sh handover \"岗位\" \"交接内容1,内容2\"             生成交接文档")
    print("  resign.sh interview                                       离职面谈准备")
    print("  resign.sh checklist                                       离职流程清单")
    print("  resign.sh farewell \"风格\"                                告别信（真诚|简洁|幽默）")
    print("  resign.sh timing [\"情况\"]                                最佳辞职时机分析")
    print("  resign.sh help                                            显示帮助")
    print("")
    print("示例:")
    print("  resign.sh letter \"腾讯\" \"个人发展\" --tone 感恩")
    print("  resign.sh handover \"后端开发\" \"项目维护,数据库管理,部署流程\"")
    print("  resign.sh farewell \"幽默\"")
    print("  resign.sh timing \"已拿到新offer，犹豫什么时候提离职\"")


def main():
    if len(sys.argv) < 2:
        cmd_help()
        sys.exit(0)

    cmd = sys.argv[1]
    args = sys.argv[2:]

    commands = {
        "letter": cmd_letter,
        "handover": cmd_handover,
        "interview": cmd_interview,
        "checklist": cmd_checklist,
        "farewell": cmd_farewell,
        "timing": cmd_timing,
        "help": lambda a: cmd_help(),
    }

    if cmd in commands:
        commands[cmd](args)
    else:
        print("未知命令: {cmd}".format(cmd=cmd))
        print("使用 resign.sh help 查看帮助")
        sys.exit(1)


if __name__ == "__main__":
    main()
