#!/usr/bin/env bash
# meeting.sh — 会议纪要生成器
set -euo pipefail

DATE=$(date '+%Y-%m-%d')
TIME=$(date '+%H:%M')

show_help() {
    cat <<'EOF'
会议纪要生成器 - meeting.sh

用法：
  meeting.sh minutes   "参会人" "议题1,议题2"     生成会议纪要模板
  meeting.sh action    "待办1,待办2,待办3"        生成行动项清单
  meeting.sh summary   "讨论内容概要"             生成会议摘要
  meeting.sh template  [standup|review|brainstorm|decision]  会议模板
  meeting.sh agenda    "主题" "时长(分钟)"        会议议程生成（时间分配+讨论要点）
  meeting.sh follow-up "会议主题"                 会后跟进邮件模板
  meeting.sh track                                查看未完成行动项（逾期/即将到期）
  meeting.sh track add "任务" "负责人" "截止日期"  添加行动项
  meeting.sh help                                显示本帮助

示例：
  meeting.sh minutes "张三,李四" "预算,发布计划"
  meeting.sh action "完成设计稿,提交报价"
  meeting.sh summary "讨论了Q1目标"
  meeting.sh template standup
  meeting.sh track
  meeting.sh track add "完成设计稿" "张三" "2026-03-15"
EOF
}

cmd_minutes() {
    local attendees="$1"
    local topics="$2"
    python3 -c "
import sys, datetime

date = '${DATE}'
time_now = '${TIME}'
attendees = sys.argv[1].split(',')
topics = sys.argv[2].split(',')

print('=' * 60)
print('会 议 纪 要'.center(60))
print('=' * 60)
print('')
print('日期：{}'.format(date))
print('时间：{}'.format(time_now))
print('地点：_____________')
print('主持人：_____________')
print('')
print('【参会人员】')
for i, a in enumerate(attendees, 1):
    print('  {}. {}'.format(i, a.strip()))
print('')
print('【会议议题】')
for i, t in enumerate(topics, 1):
    print('  {}. {}'.format(i, t.strip()))
print('')
print('-' * 60)
print('【会议内容】')
print('')
for i, t in enumerate(topics, 1):
    print('议题 {}：{}'.format(i, t.strip()))
    print('  讨论要点：')
    print('    - ')
    print('    - ')
    print('  结论/决议：')
    print('    ')
    print('')
print('-' * 60)
print('【决议事项】')
print('  1. ')
print('  2. ')
print('')
print('【待办事项】')
print('  | 序号 | 事项 | 负责人 | 截止日期 |')
print('  |------|------|--------|----------|')
print('  | 1    |      |        |          |')
print('  | 2    |      |        |          |')
print('')
print('【下次会议】')
print('  时间：_____________')
print('  议题：_____________')
print('')
print('记录人：_____________')
print('=' * 60)
" "$attendees" "$topics"
}

cmd_action() {
    local items="$1"
    python3 -c "
import sys, datetime

date = '${DATE}'
items = sys.argv[1].split(',')
deadline = (datetime.datetime.now() + datetime.timedelta(days=7)).strftime('%Y-%m-%d')

print('=' * 60)
print('行 动 项 清 单'.center(60))
print('=' * 60)
print('')
print('生成日期：{}'.format(date))
print('默认截止：{}'.format(deadline))
print('')
print('| 序号 | 行动项 | 负责人 | 优先级 | 截止日期 | 状态 |')
print('|------|--------|--------|--------|----------|------|')
for i, item in enumerate(items, 1):
    print('| {:<4} | {:<20} | ______ | P{}     | {}  | 待办 |'.format(
        i, item.strip()[:20], min(i, 3), deadline))
print('')
print('优先级说明：P1=紧急重要  P2=重要不紧急  P3=一般')
print('状态说明：待办 / 进行中 / 已完成 / 已取消')
print('')
print('【备注】')
print('  - 请各负责人确认截止日期')
print('  - 每周五下班前更新进度')
print('=' * 60)
" "$items"
}

cmd_summary() {
    local content="$1"
    python3 -c "
import sys

date = '${DATE}'
time_now = '${TIME}'
content = sys.argv[1]

print('=' * 60)
print('会 议 摘 要'.center(60))
print('=' * 60)
print('')
print('日期：{}'.format(date))
print('时间：{}'.format(time_now))
print('')
print('【会议概要】')
print('  {}'.format(content))
print('')
print('【关键要点】')
print('  1. （请从上述概要中提炼第一个要点）')
print('  2. （请提炼第二个要点）')
print('  3. （请提炼第三个要点）')
print('')
print('【主要决议】')
print('  - ')
print('')
print('【后续行动】')
print('  - ')
print('')
print('【风险/问题】')
print('  - ')
print('')
print('=' * 60)
" "$content"
}

cmd_template() {
    local ttype="${1:-standup}"
    python3 -c "
import sys

date = '${DATE}'
time_now = '${TIME}'
ttype = sys.argv[1]

templates = {
    'standup': {
        'title': '每日站会 (Daily Standup)',
        'sections': [
            ('【昨日完成】', ['  - 成员1：', '  - 成员2：', '  - 成员3：']),
            ('【今日计划】', ['  - 成员1：', '  - 成员2：', '  - 成员3：']),
            ('【遇到阻碍】', ['  - ', '  - ']),
            ('【需要协助】', ['  - ']),
        ]
    },
    'review': {
        'title': '复盘会议 (Review Meeting)',
        'sections': [
            ('【项目/迭代回顾】', ['  项目名称：', '  周期：______ 至 ______']),
            ('【目标完成情况】', ['  | 目标 | 完成度 | 说明 |', '  |------|--------|------|', '  |      |        |      |']),
            ('【做得好的方面 (Keep)】', ['  1. ', '  2. ']),
            ('【需要改进的方面 (Problem)】', ['  1. ', '  2. ']),
            ('【尝试新做法 (Try)】', ['  1. ', '  2. ']),
            ('【行动项】', ['  - ']),
        ]
    },
    'brainstorm': {
        'title': '头脑风暴 (Brainstorming)',
        'sections': [
            ('【主题】', ['  ']),
            ('【背景说明】', ['  ']),
            ('【规则】', ['  - 不批判任何想法', '  - 数量优先于质量', '  - 鼓励天马行空', '  - 可在他人想法上延伸']),
            ('【创意收集】', ['  1. ', '  2. ', '  3. ', '  4. ', '  5. ']),
            ('【分类整理】', ['  A类（可立即执行）：', '  B类（需要调研）：', '  C类（长期储备）：']),
            ('【投票结果】', ['  第1名：', '  第2名：', '  第3名：']),
            ('【下一步】', ['  - ']),
        ]
    },
    'decision': {
        'title': '决策会议 (Decision Meeting)',
        'sections': [
            ('【决策议题】', ['  ']),
            ('【背景信息】', ['  ']),
            ('【方案对比】', [
                '  | 维度 | 方案A | 方案B | 方案C |',
                '  |------|-------|-------|-------|',
                '  | 成本 |       |       |       |',
                '  | 周期 |       |       |       |',
                '  | 风险 |       |       |       |',
                '  | 收益 |       |       |       |',
            ]),
            ('【各方意见】', ['  - 支持方：', '  - 反对方：', '  - 中立方：']),
            ('【最终决策】', ['  选择方案：', '  决策理由：', '  决策人：']),
            ('【执行计划】', ['  - ']),
            ('【风险预案】', ['  - ']),
        ]
    },
}

if ttype not in templates:
    print('未知模板类型: {}'.format(ttype))
    print('可用类型: standup, review, brainstorm, decision')
    sys.exit(1)

tmpl = templates[ttype]
print('=' * 60)
print(tmpl['title'].center(60))
print('=' * 60)
print('')
print('日期：{}'.format(date))
print('时间：{}'.format(time_now))
print('参会人：_____________')
print('')
for section_title, lines in tmpl['sections']:
    print(section_title)
    for line in lines:
        print(line)
    print('')
print('=' * 60)
" "$ttype"
}

# Main dispatch
case "${1:-help}" in
    minutes)
        [ $# -lt 3 ] && { echo "用法: meeting.sh minutes \"参会人\" \"议题1,议题2\""; exit 1; }
        cmd_minutes "$2" "$3"
        ;;
    action)
        [ $# -lt 2 ] && { echo "用法: meeting.sh action \"待办1,待办2\""; exit 1; }
        cmd_action "$2"
        ;;
    summary)
        [ $# -lt 2 ] && { echo "用法: meeting.sh summary \"讨论内容概要\""; exit 1; }
        cmd_summary "$2"
        ;;
    template)
        cmd_template "${2:-standup}"
        ;;
    agenda)
        [ $# -lt 3 ] && { echo "用法: meeting.sh agenda \"主题\" \"时长(分钟)\""; exit 1; }
        export MEETING_TOPIC="$2"
        export MEETING_DURATION="$3"
        export MEETING_DATE="$DATE"
        export MEETING_TIME="$TIME"
        python3 <<'PYEOF'
import os, sys

topic = os.environ.get('MEETING_TOPIC', '')
duration = int(os.environ.get('MEETING_DURATION', '60'))
date = os.environ.get('MEETING_DATE', '')
time_now = os.environ.get('MEETING_TIME', '')

print('=' * 60)
print('会 议 议 程'.center(60))
print('=' * 60)
print('')
print('会议主题：{}'.format(topic))
print('会议日期：{} {}'.format(date, time_now))
print('计划时长：{} 分钟'.format(duration))
print('主 持 人：_____________')
print('记 录 人：_____________')
print('')
print('-' * 60)
print('【议程安排】')
print('')

if duration <= 30:
    segments = [
        ('开场与签到', 3, '确认参会人员、说明会议目标'),
        ('议题讨论：{}'.format(topic), duration - 8, '围绕核心议题展开讨论'),
        ('决议与行动项', 3, '明确结论、分配任务'),
        ('收尾', 2, '确认下次会议时间'),
    ]
elif duration <= 60:
    segments = [
        ('开场与回顾', 5, '签到、回顾上次会议行动项完成情况'),
        ('议题一：{} — 现状分析'.format(topic), int(duration * 0.25), '数据/进展汇报，当前状况概述'),
        ('议题二：{} — 问题讨论'.format(topic), int(duration * 0.30), '核心问题深入讨论、方案对比'),
        ('议题三：{} — 方案决策'.format(topic), int(duration * 0.20), '投票/决策、形成结论'),
        ('行动项确认', 5, '明确每项任务的负责人、截止日期、优先级'),
        ('Q&A与收尾', 5, '开放提问、确认下次会议安排'),
    ]
else:
    half = duration // 2
    segments = [
        ('开场与破冰', 5, '签到、自我介绍（如有新人）、说明会议目标'),
        ('背景介绍', 10, '项目/议题背景、数据汇报'),
        ('议题一：{} — 深度分析'.format(topic), int(half * 0.4), '第一个核心议题的深入讨论'),
        ('议题二：方案评估', int(half * 0.35), '备选方案对比、利弊分析'),
        ('☕ 中场休息', 10, '休息、非正式交流'),
        ('议题三：执行规划', int(half * 0.35), '实施路径、资源分配、时间节点'),
        ('议题四：风险与应对', int(half * 0.2), '潜在风险识别、预案制定'),
        ('行动项汇总', 10, '所有待办事项的负责人、截止日期、优先级'),
        ('总结与展望', 5, '回顾决议要点、确认后续安排'),
    ]

total_alloc = 0
for i, (name, mins, desc) in enumerate(segments, 1):
    total_alloc += mins
    print('  {}.  [{:>3} 分钟]  {}'.format(i, mins, name))
    print('      📌 {}'.format(desc))
    print('      讨论要点：')
    print('        - ')
    print('        - ')
    print('')

print('-' * 60)
print('【时间分配摘要】')
print('  计划总时长：{} 分钟'.format(duration))
print('  已分配时长：{} 分钟'.format(total_alloc))
if total_alloc != duration:
    print('  剩余缓冲：{} 分钟（可用于延伸讨论）'.format(duration - total_alloc))
print('')
print('【会前准备清单】')
print('  □ 提前发送议程给所有参会人（至少提前1天）')
print('  □ 准备相关数据/材料/文档')
print('  □ 确认会议室/线上链接')
print('  □ 指定记录人')
print('  □ 各议题负责人准备5分钟汇报')
print('')
print('【会议规则建议】')
print('  ✦ 准时开始、准时结束')
print('  ✦ 手机静音，专注讨论')
print('  ✦ 每人发言不超过3分钟（大型会议）')
print('  ✦ 分歧较大的议题设置计时器，避免超时')
print('  ✦ 使用"停车场"记录脱离主题的讨论')
print('=' * 60)
PYEOF
        ;;
    follow-up)
        [ $# -lt 2 ] && { echo "用法: meeting.sh follow-up \"会议主题\""; exit 1; }
        export MEETING_TOPIC="$2"
        export MEETING_DATE="$DATE"
        python3 <<'PYEOF'
import os, datetime

topic = os.environ.get('MEETING_TOPIC', '')
date = os.environ.get('MEETING_DATE', '')
next_week = (datetime.datetime.now() + datetime.timedelta(days=7)).strftime('%Y-%m-%d')

print('=' * 60)
print('会 后 跟 进 邮 件'.center(60))
print('=' * 60)
print('')
print('【中文版】')
print('')
print('收件人：[全体参会人员]')
print('主  题：【会议跟进】{} ({})'.format(topic, date))
print('')
print('各位同事好，')
print('')
print('感谢大家参加今天关于「{}」的会议。'.format(topic))
print('现将会议要点和后续行动整理如下：')
print('')
print('━━━ 会议概要 ━━━')
print('')
print('📅 会议时间：{}'.format(date))
print('📍 会议主题：{}'.format(topic))
print('👥 参会人员：______')
print('')
print('━━━ 关键决议 ━━━')
print('')
print('  1. [决议一：______]')
print('  2. [决议二：______]')
print('  3. [决议三：______]')
print('')
print('━━━ 行动项 ━━━')
print('')
print('  | 序号 | 行动项       | 负责人 | 截止日期   | 优先级 |')
print('  |------|-------------|--------|-----------|--------|')
print('  | 1    | [待办事项1]  | ______ | {}   | P1     |'.format(next_week))
print('  | 2    | [待办事项2]  | ______ | {}   | P2     |'.format(next_week))
print('  | 3    | [待办事项3]  | ______ | {}   | P2     |'.format(next_week))
print('')
print('━━━ 遗留问题 ━━━')
print('')
print('  - [需要进一步讨论/确认的问题1]')
print('  - [需要进一步讨论/确认的问题2]')
print('')
print('━━━ 下次会议 ━━━')
print('')
print('  📅 暂定时间：______')
print('  📋 预计议题：______')
print('')
print('请各位确认行动项和截止日期，如有异议请在明天下班前回复。')
print('')
print('谢谢！')
print('______')
print('')
print('-' * 60)
print('')
print('【English Version】')
print('')
print('To: [All Meeting Attendees]')
print('Subject: [Meeting Follow-up] {} ({})'.format(topic, date))
print('')
print('Hi team,')
print('')
print('Thank you for attending today\'s meeting on "{}".'.format(topic))
print('Here is a summary of key points and action items:')
print('')
print('--- Key Decisions ---')
print('  1. [Decision 1]')
print('  2. [Decision 2]')
print('  3. [Decision 3]')
print('')
print('--- Action Items ---')
print('  | # | Action Item  | Owner  | Due Date   | Priority |')
print('  |---|-------------|--------|-----------|----------|')
print('  | 1 | [Action 1]  | ______ | {}   | P1       |'.format(next_week))
print('  | 2 | [Action 2]  | ______ | {}   | P2       |'.format(next_week))
print('  | 3 | [Action 3]  | ______ | {}   | P2       |'.format(next_week))
print('')
print('--- Open Items ---')
print('  - [Item requiring further discussion]')
print('')
print('--- Next Meeting ---')
print('  Date: TBD')
print('  Topics: ______')
print('')
print('Please confirm your action items by EOD tomorrow.')
print('')
print('Best regards,')
print('______')
print('=' * 60)
PYEOF
        ;;
    track)
        export TRACK_ACTION="${2:-list}"
        export TRACK_TASK="${3:-}"
        export TRACK_OWNER="${4:-}"
        export TRACK_DUE="${5:-}"
        export TRACK_DATE="$DATE"
        python3 << 'PYEOF'
import os, json, sys, datetime

ACTIONS_FILE = os.path.expanduser("~/.meeting-notes/actions.json")
action = os.environ.get("TRACK_ACTION", "list")
task = os.environ.get("TRACK_TASK", "")
owner = os.environ.get("TRACK_OWNER", "")
due = os.environ.get("TRACK_DUE", "")
today_str = os.environ.get("TRACK_DATE", "")

def ensure_dir():
    d = os.path.dirname(ACTIONS_FILE)
    if not os.path.exists(d):
        os.makedirs(d)

def load_actions():
    if not os.path.exists(ACTIONS_FILE):
        return []
    with open(ACTIONS_FILE, "r") as f:
        try:
            return json.load(f)
        except Exception:
            return []

def save_actions(actions):
    ensure_dir()
    with open(ACTIONS_FILE, "w") as f:
        json.dump(actions, f, ensure_ascii=False, indent=2)

if action == "add":
    if not task:
        print("用法: meeting.sh track add \"任务\" \"负责人\" \"截止日期(YYYY-MM-DD)\"")
        sys.exit(1)
    if not due:
        due = (datetime.datetime.now() + datetime.timedelta(days=7)).strftime("%Y-%m-%d")
    if not owner:
        owner = "待指定"
    actions = load_actions()
    new_item = {
        "id": len(actions) + 1,
        "task": task,
        "owner": owner,
        "due": due,
        "status": "pending",
        "created": today_str,
    }
    actions.append(new_item)
    save_actions(actions)
    print("=" * 60)
    print("  \u2705 \u884c\u52a8\u9879\u5df2\u6dfb\u52a0")
    print("=" * 60)
    print("")
    print("  \u4efb\u52a1\uff1a{}".format(task))
    print("  \u8d1f\u8d23\u4eba\uff1a{}".format(owner))
    print("  \u622a\u6b62\u65e5\u671f\uff1a{}".format(due))
    print("  \u72b6\u6001\uff1a\u5f85\u529e")
    print("")
    print("  \u8fd0\u884c meeting.sh track \u67e5\u770b\u6240\u6709\u884c\u52a8\u9879")

elif action == "done":
    if not task:
        print("用法: meeting.sh track done \"任务ID或任务名\"")
        sys.exit(1)
    actions = load_actions()
    found = False
    for a in actions:
        try:
            match_id = (str(a.get("id", "")) == task)
        except Exception:
            match_id = False
        if match_id or a.get("task", "") == task:
            a["status"] = "done"
            found = True
            break
    if found:
        save_actions(actions)
        print("\u2705 \u5df2\u6807\u8bb0\u5b8c\u6210\uff1a{}".format(task))
    else:
        print("\u274c \u672a\u627e\u5230\u4efb\u52a1\uff1a{}".format(task))

else:
    # list
    actions = load_actions()
    pending = [a for a in actions if a.get("status") != "done"]

    print("=" * 60)
    print("  \U0001f4cb \u884c\u52a8\u9879\u8ffd\u8e2a".center(60))
    print("=" * 60)
    print("")

    if not pending:
        print("  \U0001f389 \u6ca1\u6709\u672a\u5b8c\u6210\u7684\u884c\u52a8\u9879\uff01")
        print("")
        print("  \u7528 meeting.sh track add \"\u4efb\u52a1\" \"\u8d1f\u8d23\u4eba\" \"截止日期\" \u6dfb\u52a0")
    else:
        today = datetime.datetime.strptime(today_str, "%Y-%m-%d").date()
        overdue = []
        urgent = []
        normal = []

        for a in pending:
            try:
                due_date = datetime.datetime.strptime(a["due"], "%Y-%m-%d").date()
                diff = (due_date - today).days
            except Exception:
                diff = 999
                due_date = None

            a["_diff"] = diff
            if diff < 0:
                overdue.append(a)
            elif diff <= 3:
                urgent.append(a)
            else:
                normal.append(a)

        if overdue:
            print("  \U0001f534 \u5df2\u903e\u671f\uff08{}\u9879\uff09\uff1a".format(len(overdue)))
            for a in overdue:
                print("    \u274c [{}] {} | \u8d1f\u8d23\u4eba:{} | \u622a\u6b62:{} | \u903e\u671f{}\u5929".format(
                    a.get("id", "?"), a["task"], a["owner"], a["due"], abs(a["_diff"])))
            print("")

        if urgent:
            print("  \U0001f7e1 \u5373\u5c06\u5230\u671f\uff08{}\u9879\uff0c\u22643\u5929\uff09\uff1a".format(len(urgent)))
            for a in urgent:
                label = "\u4eca\u5929\u5230\u671f" if a["_diff"] == 0 else "\u5269{}\u5929".format(a["_diff"])
                print("    \u26a0\ufe0f  [{}] {} | \u8d1f\u8d23\u4eba:{} | \u622a\u6b62:{} | {}".format(
                    a.get("id", "?"), a["task"], a["owner"], a["due"], label))
            print("")

        if normal:
            print("  \U0001f7e2 \u8fdb\u884c\u4e2d\uff08{}\u9879\uff09\uff1a".format(len(normal)))
            for a in normal:
                print("    \U0001f4cc [{}] {} | \u8d1f\u8d23\u4eba:{} | \u622a\u6b62:{} | \u5269{}\u5929".format(
                    a.get("id", "?"), a["task"], a["owner"], a["due"], a["_diff"]))
            print("")

        print("  \u2500" * 50)
        print("  \u603b\u8ba1\uff1a{}\u9879\u5f85\u529e | {}\u9879\u903e\u671f | {}\u9879\u5373\u5c06\u5230\u671f".format(
            len(pending), len(overdue), len(urgent)))
        print("")
        print("  \U0001f4a1 \u64cd\u4f5c\uff1a")
        print("    \u6dfb\u52a0: meeting.sh track add \"\u4efb\u52a1\" \"\u8d1f\u8d23\u4eba\" \"YYYY-MM-DD\"")
        print("    \u5b8c\u6210: meeting.sh track done \"\u4efb\u52a1ID\"")
        print("    \u67e5\u770b: meeting.sh track")

    print("")
    print("  \u6570\u636e\u5b58\u50a8: {}".format(ACTIONS_FILE))
PYEOF
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "未知命令: $1"
        show_help
        exit 1
        ;;
esac

echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
