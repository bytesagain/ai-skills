#!/usr/bin/env bash
# leave-doc: 请假条生成器
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

CMD="${1:-help}"
shift 2>/dev/null || true

python3 - "$CMD" "$@" << 'PYEOF'
# -*- coding: utf-8 -*-
import sys
import datetime

def today():
    return datetime.date.today().strftime("%Y年%m月%d日")

def year():
    return datetime.date.today().year

def leave_basic(leave_type, days, reason):
    """基础请假条"""
    type_map = {
        "事假": {"label": "事假", "note": "事假期间不计薪"},
        "病假": {"label": "病假", "note": "请附医院证明/病历"},
        "年假": {"label": "年假", "note": "年假属带薪假期"},
        "婚假": {"label": "婚假", "note": "婚假通常3-30天（各地不同）"},
        "产假": {"label": "产假", "note": "产假98天+各地延长假"},
        "陪产假": {"label": "陪产假", "note": "各地天数不同，通常7-30天"},
        "丧假": {"label": "丧假", "note": "直系亲属丧假1-3天"},
        "调休": {"label": "调休", "note": "使用之前的加班时长"},
    }

    info = type_map.get(leave_type, {"label": leave_type, "note": ""})

    print("""
================================================================================
                          请  假  条
================================================================================

致：[直属领导/部门负责人]

  本人因{reason}，特此申请{label}。

  请假类型：{label}
  请假天数：{days}天
  起止日期：____年__月__日 至 ____年__月__日
  工作交接：已与[同事姓名]沟通，由其代为处理紧急事务

  恳请批准。

                                          申请人：________
                                          部  门：________
                                          日  期：{date}

  ─────────────────────────────────────────────
  审批意见：
    □ 同意    □ 不同意
    批注：

    审批人签字：________    日期：________
  ─────────────────────────────────────────────

================================================================================
💡 {note}
================================================================================
""".format(reason=reason, label=info["label"], days=days,
           date=today(), note=info["note"]))

def multi_day(leave_type, days_str, reason):
    """多天请假（自动计算工作日）"""
    try:
        total_days = int(days_str)
    except ValueError:
        print("❌ 天数请输入数字，如: 5")
        sys.exit(1)

    # 计算工作日
    start = datetime.date.today() + datetime.timedelta(days=1)
    work_days = 0
    calendar_days = 0
    end_date = start
    weekends = 0

    while work_days < total_days:
        if start.weekday() < 5:  # 周一到周五
            work_days += 1
        else:
            weekends += 1
        calendar_days += 1
        end_date = start
        start = start + datetime.timedelta(days=1)

    start_date = datetime.date.today() + datetime.timedelta(days=1)

    print("""
================================================================================
                       多天请假申请（自动计算工作日）
================================================================================

致：[直属领导/部门负责人]

  本人因{reason}，特此申请{leave_type} {work_days}个工作日。

  请假类型：{leave_type}
  工作日数：{work_days}天
  自然日数：{calendar_days}天（含{weekends}个周末天）
  起始日期：{start}（{start_wd}）
  结束日期：{end}（{end_wd}）
  返回上班：{return_date}（{return_wd}）

  ┌──────────────────────────────────────────┐
  │  日期明细                                 │
  │                                          │""".format(
        reason=reason,
        leave_type=leave_type,
        work_days=work_days,
        calendar_days=calendar_days,
        weekends=weekends,
        start=start_date.strftime("%Y年%m月%d日"),
        start_wd=["周一","周二","周三","周四","周五","周六","周日"][start_date.weekday()],
        end=end_date.strftime("%Y年%m月%d日"),
        end_wd=["周一","周二","周三","周四","周五","周六","周日"][end_date.weekday()],
        return_date=(end_date + datetime.timedelta(days=1)).strftime("%Y年%m月%d日"),
        return_wd=["周一","周二","周三","周四","周五","周六","周日"][(end_date + datetime.timedelta(days=1)).weekday()],
    ))

    # 逐日列出
    cur = datetime.date.today() + datetime.timedelta(days=1)
    day_names = ["周一","周二","周三","周四","周五","周六","周日"]
    idx = 1
    while cur <= end_date:
        wd = day_names[cur.weekday()]
        if cur.weekday() < 5:
            print("  │  工作日{}: {} {}  ← 请假   │".format(
                idx, cur.strftime("%m/%d"), wd))
            idx += 1
        else:
            print("  │  ------: {} {}  ← 周末休息 │".format(
                cur.strftime("%m/%d"), wd))
        cur = cur + datetime.timedelta(days=1)

    print("""  │                                          │
  └──────────────────────────────────────────┘

  工作交接安排：
    - 紧急事务联系人：[同事姓名] [手机号]
    - 进行中的项目：[项目名] 由 [同事] 跟进
    - 其他交接：[说明]

  恳请批准。

                                          申请人：________
                                          部  门：________
                                          日  期：{date}

  ─────────────────────────────────────────────
  审批意见：
    □ 同意    □ 不同意
    审批人签字：________    日期：________
  ─────────────────────────────────────────────

================================================================================
💡 注意：以上日期排除了周末，法定节假日需要自行确认调整
================================================================================
""".format(date=today()))

def emergency():
    """紧急请假模板"""
    now = datetime.datetime.now()
    print("""
================================================================================
                       紧 急 请 假 申 请
================================================================================

致：[直属领导]

  因突发紧急情况，本人需要立即请假处理。

  ── 第一时间通知（简短版）──

  [领导称呼]您好，我因[紧急原因]需要立即请假，
  预计请假[X]天。手头工作已简要交代给[同事]，
  详细交接稍后补充。抱歉给工作带来不便。

  ── 正式请假条（事后补）──

  请假类型：□ 事假  □ 病假  □ 其他：____
  紧急原因：________________________________
  请假天数：____天
  起止日期：____年__月__日 至 ____年__月__日
  发送时间：{now}

  工作交接（简要）：
    1. 最紧急的事：[事项] → 交给 [同事]
    2. 今天要做的：[事项] → 交给 [同事]
    3. 本周deadline：[事项] → 交给 [同事]

  联系方式：手机 ____________（保持畅通）

                                          申请人：________
                                          日  期：{date}

================================================================================

📋 紧急请假沟通模板（直接复制使用）：

  ── 微信/钉钉消息模板 ──

  模板1（病假）：
    "[领导]您好，我身体突然不适（发烧/腹痛/...），
     需要去医院检查，今天请假一天。手头的[任务]已
     和[同事]交代，紧急事务可联系我手机。抱歉🙏"

  模板2（家中急事）：
    "[领导]您好，家中有急事需要立即处理，
     预计请假[X]天。我已把今天的工作简要交代给[同事]，
     回来后会补正式请假条。非常抱歉🙏"

  模板3（突发意外）：
    "[领导]您好，遇到紧急情况需要请假处理，
     暂时无法确定天数，会尽快回复。
     手头工作已通知[同事]协助。抱歉🙏"

================================================================================
💡 提示：
  1. 第一时间用最快的方式通知领导（微信/电话）
  2. 简要说明情况，不需要长篇大论
  3. 安排好最紧急的工作交接
  4. 事后补正式请假条和相关证明
================================================================================
""".format(now=now.strftime("%Y-%m-%d %H:%M"), date=today()))

def annual_plan(annual_days_str):
    """年假规划"""
    try:
        annual_days = int(annual_days_str)
    except ValueError:
        print("❌ 年假天数请输入数字")
        sys.exit(1)

    cur_year = year()

    # 中国法定节假日（大致固定的）
    holidays = [
        {"name": "元旦", "date": "1月1日", "days": 1, "tip": "前后拼假可得3天"},
        {"name": "春节", "date": "1月底/2月初", "days": 7, "tip": "前后+年假 = 超长假期"},
        {"name": "清明节", "date": "4月初", "days": 1, "tip": "+周末 = 3天"},
        {"name": "劳动节", "date": "5月1日", "days": 5, "tip": "前后+年假 = 9-12天"},
        {"name": "端午节", "date": "6月初", "days": 1, "tip": "+周末 = 3天"},
        {"name": "中秋节", "date": "9月中", "days": 1, "tip": "与国庆可能连休"},
        {"name": "国庆节", "date": "10月1日", "days": 7, "tip": "前后+年假 = 超长假期"},
    ]

    print("""
================================================================================
                    年假最优规划方案（{year}年）
================================================================================

  你的年假天数：{days}天
  目标：用最少的年假，拼出最长的假期 🏖️

───────────────────────────────────────────────────

一、法定节假日概览

""".format(year=cur_year, days=annual_days))

    for h in holidays:
        print("  📅 {} — {} | 放假{}天 | {}".format(
            h["name"], h["date"], h["days"], h["tip"]))
    print("")

    print("""───────────────────────────────────────────────────

二、拼假方案推荐（按性价比排序）

  ⭐ 方案A：春节前后拼假（推荐指数：★★★★★）
     用2-3天年假 + 春节7天 = 10-12天连续假期
     适合：回老家过年、出国旅行
     操作：春节前请2天 或 春节后请3天

  ⭐ 方案B：劳动节前后拼假（推荐指数：★★★★★）
     用3-4天年假 + 五一5天 = 9-12天连续假期
     适合：国内深度游、出境游
     操作：五一前请2天 + 五一后请2天

  ⭐ 方案C：国庆前后拼假（推荐指数：★★★★☆）
     用2-3天年假 + 国庆7天 = 10-12天连续假期
     适合：长途旅行（但机票酒店贵）
     操作：国庆前请2天 或 国庆后请3天

  ⭐ 方案D：清明/端午拼小长假（推荐指数：★★★☆☆）
     用2天年假 + 3天假期 = 5天
     适合：短途旅行、休息充电
     操作：在周末和假期之间补请1-2天""")

    print("")

    # 根据年假天数给出具体分配建议
    print("───────────────────────────────────────────────────")
    print("")
    print("三、你的{}天年假分配建议".format(annual_days))
    print("")

    if annual_days <= 5:
        print("  年假较少，建议集中使用：")
        print("    方案1：全部用在春节/国庆，拼一个10天+长假")
        print("    方案2：分两次，春节2天 + 五一3天")
        print("    方案3：分三次小长假，各用1-2天")
    elif annual_days <= 10:
        print("  年假适中，建议分散+集中结合：")
        print("    方案1：春节3天 + 五一3天 + 清明/端午2天 + 机动{}天".format(annual_days - 8))
        print("    方案2：春节3天 + 国庆3天 + 零散{}天".format(annual_days - 6))
        print("    方案3：攒一个超长假期（7天年假+国庆 = 14天+）")
    else:
        print("  年假充裕，建议多次休息：")
        print("    方案1：每个季度安排一次5天左右的假期")
        print("    方案2：春节5天 + 暑假5天 + 零散{}天".format(annual_days - 10))
        print("    方案3：攒一次超长假（10天+国庆/春节 = 17天出国旅行）")

    print("""
───────────────────────────────────────────────────

四、年假使用注意事项

  📋 法律规定：
    1. 年假当年未休，可延至次年
    2. 单位确因工作需要不能安排年休假的，
       应支付 300% 日工资的年假补偿
    3. 年假天数标准：
       工龄1-10年: 5天  |  10-20年: 10天  |  20年+: 15天

  ⚠️  常见坑：
    - 有些公司规定年假不能跨年 → 12月前用完
    - 有些公司要求提前N天申请 → 早规划
    - 试用期通常不能休年假 → 转正后计算

  💡 小技巧：
    - 周三请1天假 = 把一周拆成两个"周末"
    - 请假尽量避开月初月末（财务结算期）
    - 和团队错开休假，更容易被批准

================================================================================
""")

def show_help():
    print("""
📝 请假条生成器
==============================

用法：doc.sh <命令> [参数...]

命令：
  leave     <类型> <天数> <原因>           基础请假条
  multi-day <类型> <天数> <原因>           多天请假（自动排除周末）
  emergency                               紧急请假模板
  annual-plan <年假天数>                   年假最优规划
  help                                     显示此帮助

请假类型：事假 | 病假 | 年假 | 婚假 | 产假 | 陪产假 | 丧假 | 调休

示例：
  doc.sh leave "事假" "3" "家中有事需要处理"
  doc.sh multi-day "年假" "5" "出国旅行"
  doc.sh emergency
  doc.sh annual-plan "10"

💡 多天请假会自动计算工作日，排除周末
""")

if __name__ == "__main__":
    args = sys.argv[1:]
    if not args:
        show_help()
        sys.exit(0)

    cmd = args[0]
    rest = args[1:]

    if cmd == "leave":
        if len(rest) < 3:
            print("❌ 用法: doc.sh leave <类型> <天数> <原因>")
            sys.exit(1)
        leave_basic(rest[0], rest[1], rest[2])
    elif cmd == "multi-day":
        if len(rest) < 3:
            print("❌ 用法: doc.sh multi-day <类型> <天数> <原因>")
            sys.exit(1)
        multi_day(rest[0], rest[1], rest[2])
    elif cmd == "emergency":
        emergency()
    elif cmd == "annual-plan":
        if len(rest) < 1:
            print("❌ 用法: doc.sh annual-plan <年假天数>")
            sys.exit(1)
        annual_plan(rest[0])
    elif cmd == "help":
        show_help()
    else:
        print("❌ 未知命令: {}".format(cmd))
        show_help()
        sys.exit(1)
PYEOF

echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
