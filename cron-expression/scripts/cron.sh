#!/usr/bin/env bash
# cron-expression helper script
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

show_help() {
    cat << 'EOF'
Cron Expression Helper - Cron表达式助手

用法: bash cron.sh <command> [args]

命令:
  generate <description>   根据自然语言描述生成cron表达式
  explain <expression>     解释cron表达式含义
  examples                 显示常用cron表达式示例
  validate <expression>    验证cron表达式是否合法
  next <expression> [n]    计算下次N次执行时间(默认5次)
  convert <expr> <platform> 跨平台转换(linux/aws/github)
  help                     显示此帮助信息

示例:
  bash cron.sh generate "每天凌晨3点"
  bash cron.sh explain "0 3 * * *"
  bash cron.sh validate "0 3 * * *"
  bash cron.sh next "0 3 * * *" 3
  bash cron.sh convert "0 3 * * *" aws

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
}

cmd_generate() {
    local desc="${1:-}"
    if [ -z "$desc" ]; then
        echo "错误: 请提供描述，例如: bash cron.sh generate \"每天凌晨3点\""
        exit 1
    fi
    python3 - "$desc" << 'PYEOF'
import sys
import re

desc = sys.argv[1] if len(sys.argv) > 1 else ""

patterns = [
    # 每N分钟
    (r'每(\d+)分钟', lambda m: '*/{} * * * *'.format(m.group(1))),
    (r'every (\d+) minutes?', lambda m: '*/{} * * * *'.format(m.group(1))),
    # 每N小时
    (r'每(\d+)小时', lambda m: '0 */{} * * *'.format(m.group(1))),
    (r'every (\d+) hours?', lambda m: '0 */{} * * *'.format(m.group(1))),
    # 每天某时某分
    (r'每天.*?(\d+)[点时](\d+)分?', lambda m: '{} {} * * *'.format(m.group(2), m.group(1))),
    (r'every day at (\d+):(\d+)', lambda m: '{} {} * * *'.format(m.group(2), m.group(1))),
    # 每天某时(整点)
    (r'每天.*?(\d+)[点时]', lambda m: '0 {} * * *'.format(m.group(1))),
    # 凌晨某时
    (r'凌晨(\d+)[点时]', lambda m: '0 {} * * *'.format(m.group(1))),
    # 每周某天
    (r'每周([一二三四五六日天])', lambda m: '0 0 * * {}'.format(
        {'一': '1', '二': '2', '三': '3', '四': '4', '五': '5', '六': '6', '日': '0', '天': '0'}[m.group(1)]
    )),
    # 每月某日
    (r'每月(\d+)[号日]', lambda m: '0 0 {} * *'.format(m.group(1))),
    # 工作日
    (r'工作日|weekday', lambda m: '0 9 * * 1-5'),
    # 每分钟
    (r'每分钟|every minute', lambda m: '* * * * *'),
    # 每小时
    (r'每小时|every hour', lambda m: '0 * * * *'),
    # 每天
    (r'每天|every day|daily', lambda m: '0 0 * * *'),
    # 每周
    (r'每周|every week|weekly', lambda m: '0 0 * * 0'),
    # 每月
    (r'每月|every month|monthly', lambda m: '0 0 1 * *'),
]

result = None
for pattern, handler in patterns:
    m = re.search(pattern, desc, re.IGNORECASE)
    if m:
        result = handler(m)
        break

if result:
    print("描述: {}".format(desc))
    print("Cron: {}".format(result))
    parts = result.split()
    labels = ['分钟', '小时', '日', '月', '星期']
    print("\n字段分解:")
    for i, (p, l) in enumerate(zip(parts, labels)):
        print("  {} = {}".format(l, p))
else:
    print("无法自动解析: {}".format(desc))
    print("请提供更具体的描述，例如:")
    print("  每天凌晨3点")
    print("  每5分钟")
    print("  每周一")
    print("  每月15号")
    sys.exit(1)
PYEOF
}

cmd_explain() {
    local expr="${1:-}"
    if [ -z "$expr" ]; then
        echo "错误: 请提供cron表达式，例如: bash cron.sh explain \"0 3 * * *\""
        exit 1
    fi
    python3 - "$expr" << 'PYEOF'
import sys

expr = sys.argv[1]
parts = expr.strip().split()

if len(parts) not in (5, 6, 7):
    print("错误: cron表达式应有5-7个字段，当前有{}个".format(len(parts)))
    sys.exit(1)

labels_5 = ['分钟(0-59)', '小时(0-23)', '日(1-31)', '月(1-12)', '星期(0-7)']
labels_6 = ['秒(0-59)', '分钟(0-59)', '小时(0-23)', '日(1-31)', '月(1-12)', '星期(0-7)']

labels = labels_5 if len(parts) == 5 else labels_6

def explain_field(value, label):
    if value == '*':
        return '每{}'.format(label.split('(')[0])
    elif value.startswith('*/'):
        return '每{}个{}'.format(value[2:], label.split('(')[0])
    elif ',' in value:
        return '在 {} 的{}'.format(value, label.split('(')[0])
    elif '-' in value:
        rng = value.split('-')
        return '从{}到{}的{}'.format(rng[0], rng[1], label.split('(')[0])
    else:
        return '第{}个{}'.format(value, label.split('(')[0])

weekday_names = {
    '0': '周日', '1': '周一', '2': '周二', '3': '周三',
    '4': '周四', '5': '周五', '6': '周六', '7': '周日'
}

print("表达式: {}".format(expr))
print("\n字段解析:")
for i, (p, l) in enumerate(zip(parts, labels)):
    explanation = explain_field(p, l)
    if '星期' in l and p in weekday_names:
        explanation = weekday_names[p]
    print("  {} [{}] = {}".format(l, p, explanation))

# Generate human-readable summary
if len(parts) == 5:
    minute, hour, day, month, weekday = parts
    summary_parts = []
    if month != '*':
        summary_parts.append('{}月'.format(month))
    if day != '*':
        summary_parts.append('{}号'.format(day))
    if weekday != '*':
        if '-' in weekday:
            wd = weekday.split('-')
            summary_parts.append('周{}-周{}'.format(
                weekday_names.get(wd[0], wd[0]),
                weekday_names.get(wd[1], wd[1])
            ))
        elif weekday in weekday_names:
            summary_parts.append(weekday_names[weekday])
    if hour != '*':
        if hour.startswith('*/'):
            summary_parts.append('每{}小时'.format(hour[2:]))
        else:
            summary_parts.append('{}点'.format(hour))
    if minute != '*':
        if minute.startswith('*/'):
            summary_parts.append('每{}分钟'.format(minute[2:]))
        elif minute != '0':
            summary_parts.append('{}分'.format(minute))
    
    print("\n通俗解释: {}执行".format(' '.join(summary_parts) if summary_parts else '每分钟'))
PYEOF
}

cmd_examples() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                    常用 Cron 表达式示例                       ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  ── 基础频率 ──                                              ║
║  * * * * *        每分钟                                     ║
║  */5 * * * *      每5分钟                                    ║
║  */15 * * * *     每15分钟                                   ║
║  */30 * * * *     每30分钟                                   ║
║  0 * * * *        每小时整点                                 ║
║  0 */2 * * *      每2小时                                    ║
║  0 */6 * * *      每6小时                                    ║
║                                                              ║
║  ── 每日任务 ──                                              ║
║  0 0 * * *        每天午夜(00:00)                            ║
║  0 3 * * *        每天凌晨3点                                ║
║  0 8 * * *        每天早上8点                                ║
║  0 9,18 * * *     每天9点和18点                              ║
║  30 23 * * *      每天23:30                                  ║
║                                                              ║
║  ── 工作日/周末 ──                                           ║
║  0 9 * * 1-5      工作日早上9点                              ║
║  0 10 * * 6,0     周末早上10点                               ║
║  0 9 * * 1        每周一早上9点                              ║
║  0 17 * * 5       每周五下午5点                              ║
║                                                              ║
║  ── 月度/年度 ──                                             ║
║  0 0 1 * *        每月1日午夜                                ║
║  0 0 15 * *       每月15日午夜                               ║
║  0 0 L * *        每月最后一天(部分系统)                      ║
║  0 0 1 1 *        每年1月1日                                 ║
║  0 0 1 */3 *      每季度第一天                               ║
║                                                              ║
║  ── 运维常用 ──                                              ║
║  0 2 * * *        每天凌晨2点(数据库备份)                    ║
║  */10 * * * *     每10分钟(健康检查)                         ║
║  0 0 * * 0        每周日午夜(周报/清理)                      ║
║  0 4 1 * *        每月1日凌晨4点(月度报告)                   ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
}

cmd_validate() {
    local expr="${1:-}"
    if [ -z "$expr" ]; then
        echo "错误: 请提供cron表达式，例如: bash cron.sh validate \"0 3 * * *\""
        exit 1
    fi
    python3 - "$expr" << 'PYEOF'
import sys
import re

expr = sys.argv[1]
parts = expr.strip().split()

if len(parts) != 5:
    print("❌ 无效: 标准cron应有5个字段，当前有{}个".format(len(parts)))
    if len(parts) == 6:
        print("   提示: 6个字段可能是带秒的cron(如Quartz/Spring)或带年的AWS格式")
    sys.exit(1)

ranges = [
    (0, 59, '分钟'),
    (0, 23, '小时'),
    (1, 31, '日'),
    (1, 12, '月'),
    (0, 7, '星期'),
]

valid = True
for i, (lo, hi, name) in enumerate(ranges):
    field = parts[i]
    # Check basic pattern
    pattern = r'^(\*|(\d+(-\d+)?)(,\d+(-\d+)?)*)(/\d+)?$'
    if not re.match(pattern, field):
        print("❌ 字段{} [{}] '{}': 格式不合法".format(i+1, name, field))
        valid = False
        continue
    
    # Extract numbers and check range
    nums = re.findall(r'\d+', field)
    for n in nums:
        val = int(n)
        if val < lo or val > hi:
            # Special case: step value after /
            if '/' in field and n == field.split('/')[-1]:
                continue
            print("❌ 字段{} [{}] '{}': 值{}超出范围({}-{})".format(i+1, name, field, val, lo, hi))
            valid = False

if valid:
    print("✅ 有效的cron表达式: {}".format(expr))
    print("\n各字段:")
    labels = ['分钟', '小时', '日', '月', '星期']
    for i, (p, l) in enumerate(zip(parts, labels)):
        print("  {} = {}".format(l, p))
else:
    print("\n表达式: {}".format(expr))
PYEOF
}

cmd_next() {
    local expr="${1:-}"
    local count="${2:-5}"
    if [ -z "$expr" ]; then
        echo "错误: 请提供cron表达式，例如: bash cron.sh next \"0 3 * * *\" 5"
        exit 1
    fi
    python3 - "$expr" "$count" << 'PYEOF'
import sys
import datetime
import re

expr = sys.argv[1]
count = int(sys.argv[2]) if len(sys.argv) > 2 else 5

parts = expr.strip().split()
if len(parts) != 5:
    print("错误: 需要标准5字段cron表达式")
    sys.exit(1)

def parse_field(field, lo, hi):
    """Parse a cron field and return list of valid values"""
    values = set()
    for part in field.split(','):
        step = 1
        if '/' in part:
            part, step_str = part.split('/')
            step = int(step_str)
        
        if part == '*':
            values.update(range(lo, hi + 1, step))
        elif '-' in part:
            start, end = part.split('-')
            values.update(range(int(start), int(end) + 1, step))
        else:
            values.add(int(part))
    
    return sorted(values)

try:
    minutes = parse_field(parts[0], 0, 59)
    hours = parse_field(parts[1], 0, 23)
    days = parse_field(parts[2], 1, 31)
    months = parse_field(parts[3], 1, 12)
    weekdays_raw = parse_field(parts[4], 0, 7)
    weekdays = set()
    for w in weekdays_raw:
        weekdays.add(w % 7)
    weekdays = sorted(weekdays)
except Exception as e:
    print("解析错误: {}".format(str(e)))
    sys.exit(1)

day_any = parts[2] == '*'
weekday_any = parts[4] == '*'

now = datetime.datetime.now()
current = now.replace(second=0, microsecond=0) + datetime.timedelta(minutes=1)

results = []
checked = 0
max_check = 366 * 24 * 60  # max 1 year of minutes

while len(results) < count and checked < max_check:
    m = current.minute
    h = current.hour
    d = current.day
    mo = current.month
    wd = current.weekday()  # 0=Monday
    # Convert to cron weekday (0=Sunday)
    cron_wd = (wd + 1) % 7

    if mo in months and m in minutes and h in hours:
        day_match = d in days if not day_any else True
        wd_match = cron_wd in weekdays if not weekday_any else True
        
        if day_any and weekday_any:
            results.append(current)
        elif day_any:
            if wd_match:
                results.append(current)
        elif weekday_any:
            if day_match:
                results.append(current)
        else:
            if day_match or wd_match:
                results.append(current)
    
    current += datetime.timedelta(minutes=1)
    checked += 1

print("表达式: {}".format(expr))
print("当前时间: {}".format(now.strftime('%Y-%m-%d %H:%M:%S')))
print("\n接下来{}次执行时间:".format(count))
for i, dt in enumerate(results):
    weekday_cn = ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
    wd_name = weekday_cn[dt.weekday()]
    print("  {}. {} ({})".format(i + 1, dt.strftime('%Y-%m-%d %H:%M'), wd_name))

if not results:
    print("  (未找到匹配的执行时间，请检查表达式)")
PYEOF
}

cmd_convert() {
    local expr="${1:-}"
    local platform="${2:-}"
    if [ -z "$expr" ] || [ -z "$platform" ]; then
        echo "错误: 用法: bash cron.sh convert \"0 3 * * *\" <platform>"
        echo "平台: linux, aws, github"
        exit 1
    fi
    python3 - "$expr" "$platform" << 'PYEOF'
import sys

expr = sys.argv[1]
platform = sys.argv[2].lower()
parts = expr.strip().split()

print("原始表达式: {} ({}个字段)".format(expr, len(parts)))
print("目标平台: {}\n".format(platform))

if platform == 'aws':
    if len(parts) == 5:
        # Linux 5-field -> AWS 6-field (add year)
        # AWS uses ? for day-of-month or day-of-week
        minute, hour, day, month, weekday = parts
        if weekday != '*' and day == '*':
            day = '?'
        elif day != '*' and weekday == '*':
            weekday = '?'
        elif day == '*' and weekday == '*':
            day = '*'
            weekday = '?'
        aws_expr = 'cron({} {} {} {} {} *)'.format(minute, hour, day, month, weekday)
        print("AWS CloudWatch/EventBridge:")
        print("  {}".format(aws_expr))
        print("\n注意:")
        print("  - AWS cron有6个字段: 分 时 日 月 周 年")
        print("  - 日和周不能同时为*，其中一个必须用?")
        print("  - AWS使用UTC时区")
        print("  - 周: 1=SUN, 2=MON, ..., 7=SAT")
    elif len(parts) == 6:
        print("已经是6字段格式，可能已经是AWS格式")
        print("  cron({})".format(expr))

elif platform == 'github':
    if len(parts) == 5:
        print("GitHub Actions cron:")
        print("  schedule:")
        print("    - cron: '{}'".format(expr))
        print("\n注意:")
        print("  - GitHub Actions使用标准5字段cron")
        print("  - 使用UTC时区")
        print("  - 最短间隔5分钟")
        minute, hour, day, month, weekday = parts
        if minute.startswith('*/'):
            interval = int(minute[2:])
            if interval < 5:
                print("  ⚠️ 警告: GitHub Actions最短间隔为5分钟，当前设置为每{}分钟".format(interval))
        
        # Show with timezone note
        try:
            h = int(hour)
            cst_h = (h + 8) % 24
            print("\n  UTC {}:00 = 北京时间 {}:00".format(hour, cst_h))
        except ValueError:
            pass

elif platform == 'linux':
    if len(parts) == 6:
        # Try to convert AWS 6-field to Linux 5-field
        minute, hour, day, month, weekday, year = parts
        day = day.replace('?', '*')
        weekday = weekday.replace('?', '*')
        linux_expr = '{} {} {} {} {}'.format(minute, hour, day, month, weekday)
        print("Linux crontab:")
        print("  {}".format(linux_expr))
    elif len(parts) == 5:
        print("已经是标准Linux cron格式:")
        print("  {}".format(expr))
    print("\n添加到crontab:")
    linux_e = expr if len(parts) == 5 else '{} {} {} {} {}'.format(*parts[:5])
    print("  crontab -e")
    print("  {} /path/to/command".format(linux_e))
else:
    print("不支持的平台: {}".format(platform))
    print("支持: linux, aws, github")
    sys.exit(1)
PYEOF
}

case "$CMD" in
    generate)
        cmd_generate "$@"
        ;;
    explain)
        cmd_explain "$@"
        ;;
    examples)
        cmd_examples
        ;;
    validate)
        cmd_validate "$@"
        ;;
    next)
        cmd_next "$@"
        ;;
    convert)
        cmd_convert "$@"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "未知命令: $CMD"
        echo ""
        show_help
        exit 1
        ;;
esac
