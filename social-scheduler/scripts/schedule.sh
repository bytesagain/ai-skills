#!/usr/bin/env bash
set -euo pipefail

python3 - "$@" << 'PYTHON_HEREDOC_END'
# -*- coding: utf-8 -*-
from __future__ import print_function
import sys, os, json, random, string, datetime

DATA_DIR = os.path.expanduser("~/.social-scheduler")
DATA_FILE = os.path.join(DATA_DIR, "schedules.json")
SUPPORTED_PLATFORMS = ["twitter", "xhs", "weibo", "bilibili", "binance-square", "blog"]
PLATFORM_LABELS = {
    "twitter": "Twitter",
    "xhs": u"\u5c0f\u7ea2\u4e66",
    "weibo": u"\u5fae\u535a",
    "bilibili": u"B\u7ad9",
    "binance-square": "Binance Square",
    "blog": "Blog",
}

E_CHECK = u"\u2705"
E_WAIT = u"\u23f3"
E_CROSS = u"\u274c"
E_INFO = u"\u2139\ufe0f"
E_MAIL = u"\U0001f4ed"
E_LIST = u"\U0001f4cb"
E_TRASH = u"\U0001f5d1\ufe0f"
E_CAL = u"\U0001f4c5"
E_CHART = u"\U0001f4ca"

def ensure_data_dir():
    if not os.path.exists(DATA_DIR):
        os.makedirs(DATA_DIR)

def load_data():
    ensure_data_dir()
    if not os.path.exists(DATA_FILE):
        return []
    with open(DATA_FILE, "r") as f:
        try:
            return json.load(f)
        except (json.JSONDecodeError, ValueError):
            return []

def save_data(data):
    ensure_data_dir()
    with open(DATA_FILE, "w") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

def gen_id():
    chars = string.ascii_lowercase + string.digits
    return "".join(random.choice(chars) for _ in range(8))

def parse_date(date_str):
    formats = ["%Y-%m-%d %H:%M", "%Y-%m-%d %H:%M:%S", "%Y-%m-%d"]
    for fmt in formats:
        try:
            return datetime.datetime.strptime(date_str, fmt)
        except ValueError:
            continue
    return None

def format_dt(dt_str):
    dt = parse_date(dt_str)
    if dt is None:
        return dt_str
    return dt.strftime("%Y-%m-%d %H:%M")

def status_icon(done):
    return E_CHECK if done else E_WAIT

def platform_str(platforms):
    labels = []
    for p in platforms:
        label = PLATFORM_LABELS.get(p, p)
        labels.append(label)
    return ", ".join(labels)

def find_item(data, item_id):
    for i, item in enumerate(data):
        if item.get("id") == item_id:
            return i, item
    return -1, None

def print_item(item):
    icon = status_icon(item.get("done", False))
    state = u"\u5df2\u53d1\u5e03" if item.get("done", False) else u"\u5f85\u53d1\u5e03"
    print("  {} [{}] {} | {} | {}".format(
        icon,
        item["id"],
        format_dt(item.get("date", "")),
        platform_str(item.get("platforms", [])),
        state
    ))
    content = item.get("content", "")
    if len(content) > 80:
        content = content[:77] + "..."
    print("     {}".format(content))

# ---- Commands ----

def cmd_add(args):
    content = None
    platforms = []
    date_str = None
    i = 0
    while i < len(args):
        a = args[i]
        if a in ("--platform", "-p"):
            i += 1
            if i < len(args):
                platforms = [x.strip() for x in args[i].split(",")]
        elif a in ("--date", "-d"):
            i += 1
            if i < len(args):
                date_str = args[i]
                if i + 1 < len(args) and ":" in args[i + 1] and not args[i + 1].startswith("-"):
                    date_str = date_str + " " + args[i + 1]
                    i += 1
        elif not a.startswith("-") and content is None:
            content = a
        i += 1

    if content is None:
        print(E_CROSS + u" \u8bf7\u63d0\u4f9b\u5185\u5bb9\uff01\u7528\u6cd5: schedule.sh add \"\u5185\u5bb9\" --platform twitter,xhs --date \"2026-03-10 09:00\"")
        sys.exit(1)

    if not platforms:
        print(E_CROSS + u" \u8bf7\u6307\u5b9a\u5e73\u53f0! --platform twitter,xhs,weibo,bilibili,binance-square,blog")
        sys.exit(1)

    bad = [p for p in platforms if p not in SUPPORTED_PLATFORMS]
    if bad:
        print(E_CROSS + u" \u4e0d\u652f\u6301\u7684\u5e73\u53f0: {}".format(", ".join(bad)))
        print(u"   \u652f\u6301\u7684\u5e73\u53f0: {}".format(", ".join(SUPPORTED_PLATFORMS)))
        sys.exit(1)

    if date_str is None:
        date_str = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")

    if parse_date(date_str) is None:
        print(E_CROSS + u" \u65e5\u671f\u683c\u5f0f\u9519\u8bef! \u652f\u6301: YYYY-MM-DD HH:MM \u6216 YYYY-MM-DD")
        sys.exit(1)

    data = load_data()
    item_id = gen_id()
    item = {
        "id": item_id,
        "content": content,
        "platforms": platforms,
        "date": date_str,
        "done": False,
        "created_at": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
    }
    data.append(item)
    save_data(data)
    print(E_CHECK + u" \u6392\u7a0b\u5df2\u6dfb\u52a0!")
    print_item(item)

def cmd_list(args):
    date_filter = None
    i = 0
    while i < len(args):
        a = args[i]
        if a in ("--date", "-d"):
            i += 1
            if i < len(args):
                date_filter = args[i]
        elif not a.startswith("-"):
            date_filter = a
        i += 1

    data = load_data()
    if not data:
        print(E_MAIL + u" \u6ca1\u6709\u4efb\u4f55\u6392\u7a0b\u3002")
        return

    today = datetime.date.today()
    filtered = data

    if date_filter == "today":
        today_str = today.strftime("%Y-%m-%d")
        filtered = [x for x in data if x.get("date", "").startswith(today_str)]
    elif date_filter == "tomorrow":
        tmr = today + datetime.timedelta(days=1)
        tmr_str = tmr.strftime("%Y-%m-%d")
        filtered = [x for x in data if x.get("date", "").startswith(tmr_str)]
    elif date_filter == "week":
        week_end = today + datetime.timedelta(days=7)
        new_filtered = []
        for x in data:
            dt = parse_date(x.get("date", ""))
            if dt and today <= dt.date() <= week_end:
                new_filtered.append(x)
        filtered = new_filtered

    if not filtered:
        print(E_MAIL + u" \u6ca1\u6709\u7b26\u5408\u6761\u4ef6\u7684\u6392\u7a0b\u3002")
        return

    filtered.sort(key=lambda x: x.get("date", ""))
    print(E_LIST + u" \u6392\u7a0b\u5217\u8868 ({} \u6761):".format(len(filtered)))
    print("")
    for item in filtered:
        print_item(item)
        print("")

def cmd_edit(args):
    if len(args) < 2:
        print(E_CROSS + u" \u7528\u6cd5: schedule.sh edit <id> \"\u65b0\u5185\u5bb9\"")
        sys.exit(1)

    item_id = args[0]
    new_content = args[1]
    data = load_data()
    idx, item = find_item(data, item_id)
    if idx < 0:
        print(E_CROSS + u" \u627e\u4e0d\u5230 ID: {}".format(item_id))
        sys.exit(1)

    data[idx]["content"] = new_content
    data[idx]["updated_at"] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    save_data(data)
    print(E_CHECK + u" \u6392\u7a0b\u5df2\u66f4\u65b0!")
    print_item(data[idx])

def cmd_delete(args):
    if len(args) < 1:
        print(E_CROSS + u" \u7528\u6cd5: schedule.sh delete <id>")
        sys.exit(1)

    item_id = args[0]
    data = load_data()
    idx, item = find_item(data, item_id)
    if idx < 0:
        print(E_CROSS + u" \u627e\u4e0d\u5230 ID: {}".format(item_id))
        sys.exit(1)

    removed = data.pop(idx)
    save_data(data)
    print(E_TRASH + u" \u6392\u7a0b\u5df2\u5220\u9664:")
    print_item(removed)

def cmd_status(args):
    data = load_data()
    today_str = datetime.date.today().strftime("%Y-%m-%d")
    today_items = [x for x in data if x.get("date", "").startswith(today_str)]

    if not today_items:
        print(E_CAL + u" \u4eca\u65e5\u6ca1\u6709\u6392\u7a0b\u3002")
        return

    done = [x for x in today_items if x.get("done", False)]
    pending = [x for x in today_items if not x.get("done", False)]

    print(E_CAL + u" \u4eca\u65e5\u53d1\u5e03\u72b6\u6001 ({})".format(today_str))
    print(u"   \u603b\u8ba1: {} | \u5df2\u53d1\u5e03: {} | \u5f85\u53d1\u5e03: {}".format(
        len(today_items), len(done), len(pending)
    ))
    print("")
    for item in today_items:
        print_item(item)
        print("")

def cmd_calendar(args):
    month = None
    year = None
    i = 0
    while i < len(args):
        a = args[i]
        if a in ("--month", "-m"):
            i += 1
            if i < len(args):
                month = int(args[i])
        elif a in ("--year", "-y"):
            i += 1
            if i < len(args):
                year = int(args[i])
        i += 1

    now = datetime.date.today()
    if month is None:
        month = now.month
    if year is None:
        year = now.year

    data = load_data()
    month_str = "{:04d}-{:02d}".format(year, month)
    month_items = [x for x in data if x.get("date", "").startswith(month_str)]
    month_items.sort(key=lambda x: x.get("date", ""))

    days = {}
    for item in month_items:
        day = item.get("date", "")[:10]
        if day not in days:
            days[day] = []
        days[day].append(item)

    import calendar
    month_name = calendar.month_name[month]
    print(E_CAL + u" {} {} \u5185\u5bb9\u65e5\u5386 ({} \u6761\u6392\u7a0b)".format(year, month_name, len(month_items)))
    print("")

    if not days:
        print(u"   \u672c\u6708\u6ca1\u6709\u6392\u7a0b\u3002")
        return

    for day_str in sorted(days.keys()):
        items = days[day_str]
        done_count = len([x for x in items if x.get("done", False)])
        print(u"  {} ({}/{} \u5df2\u53d1\u5e03)".format(day_str, done_count, len(items)))
        for item in items:
            icon = status_icon(item.get("done", False))
            content = item.get("content", "")
            if len(content) > 50:
                content = content[:47] + "..."
            time_part = item.get("date", "")[11:16] if len(item.get("date", "")) > 10 else "--:--"
            print(u"    {} {} | {} | {}".format(
                icon, time_part, platform_str(item.get("platforms", [])), content
            ))
        print("")

def cmd_stats(args):
    data = load_data()
    if not data:
        print(E_CHART + u" \u6ca1\u6709\u6570\u636e\u3002")
        return

    total = len(data)
    done = len([x for x in data if x.get("done", False)])
    pending = total - done

    plat_count = {}
    for item in data:
        for p in item.get("platforms", []):
            plat_count[p] = plat_count.get(p, 0) + 1

    month_count = {}
    for item in data:
        m = item.get("date", "")[:7]
        if m:
            month_count[m] = month_count.get(m, 0) + 1

    print(E_CHART + u" \u53d1\u5e03\u7edf\u8ba1")
    print(u"   \u603b\u6392\u7a0b: {} | \u5df2\u53d1\u5e03: {} | \u5f85\u53d1\u5e03: {}".format(total, done, pending))
    if total > 0:
        pct = int(done * 100.0 / total)
        print(u"   \u5b8c\u6210\u7387: {}%".format(pct))
    print("")

    if plat_count:
        print(u"   \u5e73\u53f0\u5206\u5e03:")
        for p in sorted(plat_count.keys(), key=lambda x: plat_count[x], reverse=True):
            label = PLATFORM_LABELS.get(p, p)
            print(u"     {} : {} \u6761".format(label, plat_count[p]))
        print("")

    if month_count:
        print(u"   \u6708\u5ea6\u5206\u5e03:")
        for m in sorted(month_count.keys()):
            print(u"     {} : {} \u6761".format(m, month_count[m]))

def cmd_mark_done(args):
    if len(args) < 1:
        print(E_CROSS + u" \u7528\u6cd5: schedule.sh mark-done <id>")
        sys.exit(1)

    item_id = args[0]
    data = load_data()
    idx, item = find_item(data, item_id)
    if idx < 0:
        print(E_CROSS + u" \u627e\u4e0d\u5230 ID: {}".format(item_id))
        sys.exit(1)

    if data[idx].get("done", False):
        print(E_INFO + u" \u8be5\u6392\u7a0b\u5df2\u7ecf\u6807\u8bb0\u4e3a\u5df2\u53d1\u5e03\u3002")
        return

    data[idx]["done"] = True
    data[idx]["done_at"] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    save_data(data)
    print(E_CHECK + u" \u5df2\u6807\u8bb0\u4e3a\u5df2\u53d1\u5e03!")
    print_item(data[idx])

def cmd_export(args):
    fmt = "json"
    i = 0
    while i < len(args):
        a = args[i]
        if a in ("--format", "-f"):
            i += 1
            if i < len(args):
                fmt = args[i]
        elif not a.startswith("-"):
            fmt = a
        i += 1

    data = load_data()
    if not data:
        print(E_MAIL + u" \u6ca1\u6709\u6570\u636e\u53ef\u5bfc\u51fa\u3002")
        return

    if fmt == "json":
        print(json.dumps(data, ensure_ascii=False, indent=2))
    elif fmt == "md":
        print(u"# \u793e\u4ea4\u5a92\u4f53\u6392\u7a0b")
        print("")
        data_sorted = sorted(data, key=lambda x: x.get("date", ""))
        for item in data_sorted:
            icon = status_icon(item.get("done", False))
            print(u"## {} [{}] {}".format(icon, item["id"], format_dt(item.get("date", ""))))
            print("")
            print(u"- **\u5e73\u53f0**: {}".format(platform_str(item.get("platforms", []))))
            state = u"\u5df2\u53d1\u5e03" if item.get("done", False) else u"\u5f85\u53d1\u5e03"
            print(u"- **\u72b6\u6001**: {}".format(state))
            print(u"- **\u5185\u5bb9**: {}".format(item.get("content", "")))
            print("")
    else:
        print(E_CROSS + u" \u4e0d\u652f\u6301\u7684\u683c\u5f0f: {}. \u652f\u6301: md, json".format(fmt))
        sys.exit(1)

def cmd_week(args):
    """本周概览 — ASCII日历表"""
    data = load_data()
    today = datetime.date.today()
    # Find Monday of current week
    monday = today - datetime.timedelta(days=today.weekday())
    sunday = monday + datetime.timedelta(days=6)

    weekdays = [u"周一", u"周二", u"周三", u"周四", u"周五", u"周六", u"周日"]
    days = []
    for i in range(7):
        d = monday + datetime.timedelta(days=i)
        days.append(d)

    # Collect items per day
    day_items = {}
    for d in days:
        d_str = d.strftime("%Y-%m-%d")
        day_items[d_str] = [x for x in data if x.get("date", "").startswith(d_str)]

    total_week = sum(len(v) for v in day_items.values())
    done_week = sum(len([x for x in v if x.get("done", False)]) for v in day_items.values())

    print(E_CAL + u" 本周概览 ({} ~ {})".format(
        monday.strftime("%m/%d"), sunday.strftime("%m/%d")))
    print(u"   总排程: {} | 已完成: {} | 待发布: {} | 完成率: {}%".format(
        total_week, done_week, total_week - done_week,
        int(done_week * 100.0 / total_week) if total_week > 0 else 0))
    print("")

    # ASCII calendar table
    col_width = 22
    sep_line = "+" + (("-" * col_width + "+") * 7)

    # Header
    print(sep_line)
    header = "|"
    for i, wd in enumerate(weekdays):
        d = days[i]
        is_today = (d == today)
        label = u"{} {}{}".format(wd, d.strftime("%m/%d"), u" ★" if is_today else "")
        header += u" {:<{w}}|".format(label, w=col_width - 1)
    print(header)
    print(sep_line)

    # Content rows (up to 4 rows)
    max_items = max(len(v) for v in day_items.values()) if day_items else 0
    max_rows = min(max(max_items, 1), 4)
    for row in range(max_rows):
        line = "|"
        for d in days:
            d_str = d.strftime("%Y-%m-%d")
            items = day_items.get(d_str, [])
            if row < len(items):
                item = items[row]
                icon = status_icon(item.get("done", False))
                time_part = item.get("date", "")[11:16] if len(item.get("date", "")) > 10 else "--:--"
                content = item.get("content", "")
                plat = ",".join(item.get("platforms", []))[:6]
                cell = u"{} {} {}".format(icon, time_part, plat)
                if len(cell) > col_width - 1:
                    cell = cell[:col_width - 2] + u"…"
                line += u" {:<{w}}|".format(cell, w=col_width - 1)
            elif row == 0 and len(items) == 0:
                line += u" {:<{w}}|".format(u"  (空)", w=col_width - 1)
            else:
                line += u" {:<{w}}|".format("", w=col_width - 1)
        print(line)
    print(sep_line)
    print("")

    # Detail list for today
    today_str = today.strftime("%Y-%m-%d")
    today_items = day_items.get(today_str, [])
    if today_items:
        print(u"  📌 今日详情 ({})".format(today_str))
        print("")
        for item in today_items:
            print_item(item)
            print("")

    # Upcoming tomorrow
    tmr = today + datetime.timedelta(days=1)
    tmr_str = tmr.strftime("%Y-%m-%d")
    tmr_items = day_items.get(tmr_str, [])
    if tmr_items:
        print(u"  📌 明日预览 ({})".format(tmr_str))
        print("")
        for item in tmr_items:
            print_item(item)
            print("")

def cmd_template(args):
    """内容模板库 — 根据赛道生成一周内容计划"""
    if not args:
        print(E_CROSS + u" 用法: schedule.sh template \"赛道\"")
        print(u"   支持赛道: 美妆 / 科技 / 美食 / 健身 / 穿搭 / 教育 / 职场 / 旅行")
        sys.exit(1)

    track = args[0]
    weekdays = [u"周一", u"周二", u"周三", u"周四", u"周五", u"周六", u"周日"]

    TEMPLATES = {
        u"美妆": {
            "name": u"美妆/护肤",
            "platforms": ["xhs", "weibo"],
            "week": [
                {"theme": u"成分科普", "content": u"【干货】XX成分到底有什么用？一篇讲透", "time": "12:00", "type": u"图文"},
                {"theme": u"产品测评", "content": u"【测评】最近火的XX到底值不值得买？实测告诉你", "time": "20:00", "type": u"视频"},
                {"theme": u"妆容教程", "content": u"【教程】日常通勤妆5分钟搞定，新手也能学", "time": "18:00", "type": u"视频"},
                {"theme": u"好物分享", "content": u"【合集】本月空瓶记！这几个真的会无限回购", "time": "12:00", "type": u"图文"},
                {"theme": u"护肤答疑", "content": u"【互动】你们最想解决的皮肤问题是什么？评论区聊", "time": "20:00", "type": u"图文"},
                {"theme": u"探店/开箱", "content": u"【Vlog】周末逛XX店，帮你们试了10支口红", "time": "15:00", "type": u"视频"},
                {"theme": u"一周复盘", "content": u"【总结】本周热门新品盘点+下周预告", "time": "21:00", "type": u"图文"},
            ]
        },
        u"科技": {
            "name": u"科技/数码",
            "platforms": ["bilibili", "twitter"],
            "week": [
                {"theme": u"新品资讯", "content": u"【速报】XX品牌发布新品，核心参数一图看懂", "time": "09:00", "type": u"图文"},
                {"theme": u"深度评测", "content": u"【评测】XX使用一周真实体验，优缺点全说", "time": "19:00", "type": u"视频"},
                {"theme": u"技巧教程", "content": u"【教程】XX隐藏功能你知道几个？第3个太实用了", "time": "12:00", "type": u"图文"},
                {"theme": u"行业观点", "content": u"【观点】XX技术会改变什么？聊聊我的看法", "time": "20:00", "type": u"图文"},
                {"theme": u"好物推荐", "content": u"【推荐】500元以内最值得买的XX，亲测好用", "time": "18:00", "type": u"视频"},
                {"theme": u"拆解/科普", "content": u"【科普】XX的工作原理是什么？用人话给你讲明白", "time": "15:00", "type": u"视频"},
                {"theme": u"一周盘点", "content": u"【盘点】本周科技圈大事件TOP5", "time": "21:00", "type": u"图文"},
            ]
        },
        u"美食": {
            "name": u"美食/烹饪",
            "platforms": ["xhs", "bilibili"],
            "week": [
                {"theme": u"快手菜谱", "content": u"【食谱】10分钟搞定的XX，上班族救星", "time": "11:00", "type": u"视频"},
                {"theme": u"探店打卡", "content": u"【探店】本地隐藏的XX小店，排队2小时值不值", "time": "12:00", "type": u"视频"},
                {"theme": u"食材科普", "content": u"【科普】如何挑选新鲜的XX？菜市场老板不会告诉你的", "time": "10:00", "type": u"图文"},
                {"theme": u"挑战/创意", "content": u"【挑战】用XX元做一桌菜，能做出什么水平？", "time": "19:00", "type": u"视频"},
                {"theme": u"厨房好物", "content": u"【推荐】这5个厨房神器，用过就回不去了", "time": "12:00", "type": u"图文"},
                {"theme": u"周末大菜", "content": u"【硬菜】周末家宴必备！手把手教你做XX", "time": "14:00", "type": u"视频"},
                {"theme": u"互动/投票", "content": u"【投票】下周想看什么菜谱？评论区点菜", "time": "20:00", "type": u"图文"},
            ]
        },
        u"健身": {
            "name": u"健身/运动",
            "platforms": ["xhs", "bilibili"],
            "week": [
                {"theme": u"训练教程", "content": u"【教程】居家XX训练，不用器械也能练", "time": "07:00", "type": u"视频"},
                {"theme": u"饮食方案", "content": u"【干货】增肌/减脂期怎么吃？一日三餐食谱分享", "time": "12:00", "type": u"图文"},
                {"theme": u"动作纠正", "content": u"【避坑】XX动作90%的人都做错了！正确姿势看这里", "time": "18:00", "type": u"视频"},
                {"theme": u"打卡分享", "content": u"【打卡】30天挑战Day X，身体变化记录", "time": "20:00", "type": u"图文"},
                {"theme": u"装备推荐", "content": u"【推荐】新手必备的XX装备，别踩坑", "time": "12:00", "type": u"图文"},
                {"theme": u"户外运动", "content": u"【Vlog】周末XX运动体验，比健身房有趣多了", "time": "15:00", "type": u"视频"},
                {"theme": u"知识问答", "content": u"【答疑】你们问最多的5个健身问题，统一回答", "time": "21:00", "type": u"图文"},
            ]
        },
    }

    # Default template for unrecognized tracks
    default_template = {
        "name": track,
        "platforms": ["xhs", "twitter"],
        "week": [
            {"theme": u"干货分享", "content": u"【干货】关于{}你必须知道的5件事".format(track), "time": "12:00", "type": u"图文"},
            {"theme": u"深度内容", "content": u"【深度】{}领域的最新趋势分析".format(track), "time": "19:00", "type": u"视频"},
            {"theme": u"教程技巧", "content": u"【教程】{}入门指南，新手必看".format(track), "time": "12:00", "type": u"图文"},
            {"theme": u"观点讨论", "content": u"【讨论】关于{}，你怎么看？".format(track), "time": "20:00", "type": u"图文"},
            {"theme": u"推荐清单", "content": u"【推荐】{}领域必关注的资源/工具/账号".format(track), "time": "18:00", "type": u"图文"},
            {"theme": u"实践分享", "content": u"【实践】我在{}领域的真实经历和收获".format(track), "time": "15:00", "type": u"视频"},
            {"theme": u"互动总结", "content": u"【互动】一周{}内容回顾+下周预告".format(track), "time": "21:00", "type": u"图文"},
        ]
    }

    tmpl = TEMPLATES.get(track, default_template)

    today_d = datetime.date.today()
    next_monday = today_d + datetime.timedelta(days=(7 - today_d.weekday()))

    print(E_CAL + u" 内容模板 — {} 赛道".format(tmpl["name"]))
    print(u"   建议平台: {}".format(platform_str(tmpl["platforms"])))
    print(u"   计划周期: {} ~ {}".format(
        next_monday.strftime("%m/%d"),
        (next_monday + datetime.timedelta(days=6)).strftime("%m/%d")))
    print("")
    print(u"=" * 60)

    for i, day_plan in enumerate(tmpl["week"]):
        d = next_monday + datetime.timedelta(days=i)
        wd = weekdays[i]
        print(u"")
        print(u"  {} {} ({})".format(wd, d.strftime("%m/%d"), day_plan["theme"]))
        print(u"  " + u"─" * 40)
        print(u"  📝 内容: {}".format(day_plan["content"]))
        print(u"  ⏰ 建议时间: {}".format(day_plan["time"]))
        print(u"  📱 类型: {}".format(day_plan["type"]))
        print(u"  🏷️ 平台: {}".format(platform_str(tmpl["platforms"])))

    print(u"")
    print(u"=" * 60)
    print(u"")
    print(u"  💡 使用方式:")
    print(u"  • 直接复制以上内容到排程:")
    print(u'    schedule.sh add "内容" --platform {} --date "日期 时间"'.format(
        ",".join(tmpl["platforms"])))
    print(u"  • 根据实际情况替换 [XX] 占位符")
    print(u"  • 建议每周日晚上规划下周内容")
    print(u"")

def cmd_analytics(args):
    """发布效果分析 — 数据洞察"""
    data = load_data()
    if not data:
        print(E_CHART + u" 没有数据，无法分析。")
        return

    total = len(data)
    done = [x for x in data if x.get("done", False)]
    pending = [x for x in data if not x.get("done", False)]
    done_count = len(done)
    pending_count = len(pending)

    print(E_CHART + u" 发布效果分析")
    print(u"=" * 60)
    print(u"")

    # 1. Completion rate with visual bar
    pct = int(done_count * 100.0 / total) if total > 0 else 0
    bar_len = 30
    filled = int(bar_len * pct / 100)
    bar = u"█" * filled + u"░" * (bar_len - filled)
    print(u"  📊 完成率概览")
    print(u"  [{bar}] {pct}%".format(bar=bar, pct=pct))
    print(u"  总排程: {t} | 已完成: {d} | 待发布: {p}".format(
        t=total, d=done_count, p=pending_count))
    print(u"")

    # 2. Platform distribution
    plat_total = {}
    plat_done = {}
    for item in data:
        for p in item.get("platforms", []):
            plat_total[p] = plat_total.get(p, 0) + 1
            if item.get("done", False):
                plat_done[p] = plat_done.get(p, 0) + 1

    if plat_total:
        print(u"  📱 平台分布 & 各平台完成率")
        print(u"  " + u"-" * 50)
        max_plat_count = max(plat_total.values())
        for p in sorted(plat_total.keys(), key=lambda x: plat_total[x], reverse=True):
            label = PLATFORM_LABELS.get(p, p)
            cnt = plat_total[p]
            d_cnt = plat_done.get(p, 0)
            p_pct = int(d_cnt * 100.0 / cnt) if cnt > 0 else 0
            vis_len = int(15 * cnt / max_plat_count) if max_plat_count > 0 else 0
            vis = u"▓" * vis_len
            print(u"  {label:<12} {vis:<15} {cnt}条 (完成率 {pct}%)".format(
                label=label, vis=vis, cnt=cnt, pct=p_pct))
        print(u"")

    # 3. Time analysis — find best posting time slots
    hour_count = {}
    hour_done = {}
    for item in data:
        date_str = item.get("date", "")
        if len(date_str) > 13:
            try:
                hour = int(date_str[11:13])
                hour_count[hour] = hour_count.get(hour, 0) + 1
                if item.get("done", False):
                    hour_done[hour] = hour_done.get(hour, 0) + 1
            except (ValueError, IndexError):
                pass

    if hour_count:
        print(u"  ⏰ 时间段分布")
        print(u"  " + u"-" * 50)

        # Group into time slots
        slots = [
            (u"早间 06-09", range(6, 9)),
            (u"上午 09-12", range(9, 12)),
            (u"午间 12-14", range(12, 14)),
            (u"下午 14-18", range(14, 18)),
            (u"晚间 18-21", range(18, 21)),
            (u"深夜 21-24", range(21, 24)),
        ]
        slot_data = []
        for slot_name, hours in slots:
            cnt = sum(hour_count.get(h, 0) for h in hours)
            if cnt > 0:
                slot_data.append((slot_name, cnt))

        if slot_data:
            max_slot = max(s[1] for s in slot_data)
            best_slot = max(slot_data, key=lambda x: x[1])
            for slot_name, cnt in slot_data:
                vis_len = int(15 * cnt / max_slot) if max_slot > 0 else 0
                vis = u"▓" * vis_len
                marker = u" ← 🔥 最佳时段" if slot_name == best_slot[0] else ""
                print(u"  {name:<12} {vis:<15} {cnt}条{m}".format(
                    name=slot_name, vis=vis, cnt=cnt, m=marker))
        print(u"")

    # 4. Weekly pattern
    weekday_count = {}
    weekday_names = [u"周一", u"周二", u"周三", u"周四", u"周五", u"周六", u"周日"]
    for item in data:
        dt = parse_date(item.get("date", ""))
        if dt:
            wd = dt.weekday()
            weekday_count[wd] = weekday_count.get(wd, 0) + 1

    if weekday_count:
        print(u"  📅 星期分布")
        print(u"  " + u"-" * 50)
        max_wd = max(weekday_count.values()) if weekday_count else 1
        for wd in range(7):
            cnt = weekday_count.get(wd, 0)
            vis_len = int(15 * cnt / max_wd) if max_wd > 0 else 0
            vis = u"▓" * vis_len
            print(u"  {name:<6} {vis:<15} {cnt}条".format(
                name=weekday_names[wd], vis=vis, cnt=cnt))
        print(u"")

    # 5. Insights
    print(u"  💡 数据洞察")
    print(u"  " + u"-" * 50)

    if pct >= 80:
        print(u"  ✅ 执行力很强！完成率 {}%，继续保持。".format(pct))
    elif pct >= 50:
        print(u"  ⚠️  完成率 {}%，还有提升空间。建议减少排程量或设置提醒。".format(pct))
    else:
        print(u"  ❌ 完成率仅 {}%，建议精简排程，聚焦核心平台。".format(pct))

    if plat_total:
        top_plat = max(plat_total.keys(), key=lambda x: plat_total[x])
        top_label = PLATFORM_LABELS.get(top_plat, top_plat)
        if len(plat_total) == 1:
            print(u"  📱 目前只发 {}，可以考虑拓展到其他平台。".format(top_label))
        else:
            print(u"  📱 {} 是发布最多的平台 ({}条)。".format(top_label, plat_total[top_plat]))

    if pending_count > 0:
        # Find overdue items
        now = datetime.datetime.now()
        overdue = [x for x in pending if parse_date(x.get("date", "")) and parse_date(x.get("date", "")) < now]
        if overdue:
            print(u"  🔴 有 {} 条已过期但未标记完成的排程，建议清理。".format(len(overdue)))

    print(u"")

def cmd_duplicate(args):
    """复制已有计划"""
    if not args:
        print(E_CROSS + u" 用法: schedule.sh duplicate <id>")
        sys.exit(1)

    item_id = args[0]
    data = load_data()
    idx, item = find_item(data, item_id)
    if idx < 0:
        print(E_CROSS + u" 找不到 ID: {}".format(item_id))
        sys.exit(1)

    new_item = {
        "id": gen_id(),
        "content": item.get("content", ""),
        "platforms": list(item.get("platforms", [])),
        "date": item.get("date", ""),
        "done": False,
        "created_at": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "copied_from": item_id,
    }
    data.append(new_item)
    save_data(data)
    print(E_CHECK + u" 已复制排程! (原 ID: {}, 新 ID: {})".format(item_id, new_item["id"]))
    print(u"   💡 提示: 用 edit 命令修改日期或内容")
    print("")
    print(u"  原始:")
    print_item(item)
    print(u"  副本:")
    print_item(new_item)

def cmd_batch_add(args):
    """批量添加排程"""
    if len(args) < 2:
        print(E_CROSS + u" 用法: schedule.sh batch-add \"主题1,主题2,主题3\" \"平台\"")
        print(u"   可选: --start \"YYYY-MM-DD\" --interval 1 (间隔天数)")
        sys.exit(1)

    topics_str = args[0]
    platform_str_input = args[1]
    topics = [t.strip() for t in topics_str.split(",") if t.strip()]
    platforms = [p.strip() for p in platform_str_input.split(",")]

    bad = [p for p in platforms if p not in SUPPORTED_PLATFORMS]
    if bad:
        print(E_CROSS + u" 不支持的平台: {}".format(", ".join(bad)))
        print(u"   支持的平台: {}".format(", ".join(SUPPORTED_PLATFORMS)))
        sys.exit(1)

    # Parse optional arguments
    start_date = datetime.date.today() + datetime.timedelta(days=1)  # default: tomorrow
    interval = 1  # default: 1 day apart
    default_time = "12:00"

    i = 2
    while i < len(args):
        if args[i] == "--start" and i + 1 < len(args):
            dt = parse_date(args[i + 1])
            if dt:
                start_date = dt.date() if hasattr(dt, 'date') else dt
            i += 2
        elif args[i] == "--interval" and i + 1 < len(args):
            try:
                interval = int(args[i + 1])
            except ValueError:
                pass
            i += 2
        elif args[i] == "--time" and i + 1 < len(args):
            default_time = args[i + 1]
            i += 2
        else:
            i += 1

    data = load_data()
    added = []
    for idx, topic in enumerate(topics):
        pub_date = start_date + datetime.timedelta(days=idx * interval)
        date_str = "{} {}".format(pub_date.strftime("%Y-%m-%d"), default_time)
        new_item = {
            "id": gen_id(),
            "content": topic,
            "platforms": list(platforms),
            "date": date_str,
            "done": False,
            "created_at": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        }
        data.append(new_item)
        added.append(new_item)

    save_data(data)
    print(E_CHECK + u" 批量添加 {} 条排程!".format(len(added)))
    print("")
    for item in added:
        print_item(item)
        print("")

def cmd_help(args=None):
    help_text = u"""Social Scheduler - \u793e\u4ea4\u5a92\u4f53\u5185\u5bb9\u6392\u7a0b\u7ba1\u7406\u5668

\u7528\u6cd5: schedule.sh <command> [options]

\u547d\u4ee4:
  add "<content>" --platform <platforms> --date "<datetime>"
      \u6dfb\u52a0\u65b0\u6392\u7a0b
      --platform, -p    \u5e73\u53f0\u5217\u8868\uff0c\u9017\u53f7\u5206\u9694
      --date, -d        \u53d1\u5e03\u65f6\u95f4 (YYYY-MM-DD HH:MM)

  list [--date today|tomorrow|week]
      \u67e5\u770b\u6392\u7a0b\u5217\u8868

  edit <id> "<new_content>"
      \u7f16\u8f91\u6392\u7a0b\u5185\u5bb9

  delete <id>
      \u5220\u9664\u6392\u7a0b

  status
      \u4eca\u65e5\u53d1\u5e03\u72b6\u6001\u603b\u89c8

  calendar [--month <N>] [--year <N>]
      \u6708\u5ea6\u5185\u5bb9\u65e5\u5386

  stats
      \u53d1\u5e03\u7edf\u8ba1

  mark-done <id>
      \u6807\u8bb0\u4e3a\u5df2\u53d1\u5e03

  export [--format md|json]
      \u5bfc\u51fa\u6392\u7a0b\u6570\u636e

  week
      \u672c\u5468\u6982\u89c8\uff08ASCII\u65e5\u5386\u8868+\u4eca\u660e\u4e24\u65e5\u8be6\u60c5\uff09

  template "\u8d5b\u9053"
      \u5185\u5bb9\u6a21\u677f\u5e93\uff08\u7f8e\u5986/\u79d1\u6280/\u7f8e\u98df/\u5065\u8eab\uff09\uff0c\u751f\u6210\u4e00\u5468\u5185\u5bb9\u8ba1\u5212

  analytics
      \u53d1\u5e03\u6548\u679c\u5206\u6790\uff08\u5b8c\u6210\u7387/\u5e73\u53f0\u5206\u5e03/\u6700\u4f73\u65f6\u6bb5/\u6570\u636e\u6d1e\u5bdf\uff09

  duplicate <id>
      \u590d\u5236\u5df2\u6709\u6392\u7a0b

  batch-add "\u4e3b\u98981,\u4e3b\u98982,\u4e3b\u98983" "\u5e73\u53f0"
      \u6279\u91cf\u6dfb\u52a0\u6392\u7a0b\uff08\u53ef\u9009 --start --interval --time\uff09

  help
      \u663e\u793a\u6b64\u5e2e\u52a9\u4fe1\u606f

\u652f\u6301\u5e73\u53f0: twitter, xhs(\u5c0f\u7ea2\u4e66), weibo(\u5fae\u535a), bilibili(B\u7ad9), binance-square, blog
\u6570\u636e\u5b58\u50a8: ~/.social-scheduler/schedules.json"""
    print(help_text)

def main():
    args = sys.argv[1:]
    if not args or args[0] in ("help", "--help", "-h"):
        cmd_help()
        return

    cmd = args[0]
    cmd_args = args[1:]

    commands = {
        "add": cmd_add,
        "list": cmd_list,
        "edit": cmd_edit,
        "delete": cmd_delete,
        "status": cmd_status,
        "calendar": cmd_calendar,
        "stats": cmd_stats,
        "mark-done": cmd_mark_done,
        "export": cmd_export,
        "week": cmd_week,
        "template": cmd_template,
        "analytics": cmd_analytics,
        "duplicate": cmd_duplicate,
        "batch-add": cmd_batch_add,
        "help": cmd_help,
    }

    if cmd not in commands:
        print(E_CROSS + u" \u672a\u77e5\u547d\u4ee4: {}".format(cmd))
        print(u"\u8f93\u5165 schedule.sh help \u67e5\u770b\u5e2e\u52a9\u3002")
        sys.exit(1)

    commands[cmd](cmd_args)

if __name__ == "__main__":
    main()
PYTHON_HEREDOC_END
echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
