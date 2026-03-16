#!/usr/bin/env bash
# calendar.sh — 中国农历计算器（纯算法，不用第三方库）
# Usage: bash calendar.sh <command> [args...]
# Commands: today, convert, zodiac, solar-term, festival, year-info
# Powered by BytesAgain | bytesagain.com

set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true
INPUT="$*"

# ═══════════════════════════════════════════════════
# Python农历计算核心（纯算法实现，无第三方依赖）
# ═══════════════════════════════════════════════════

LUNAR_CALC_PY='
import sys, math
from datetime import datetime, timedelta, date

# 农历数据表 (1900-2100)
# 每年用一个十六进制数编码：
# - 低4位: 闰月月份(0=无闰月)
# - 5-16位: 每月大小(1=30天, 0=29天)
# - 高4位: 闰月大小(0=29天, 1=30天)
LUNAR_INFO = [
    0x04bd8, 0x04ae0, 0x0a570, 0x054d5, 0x0d260, 0x0d950, 0x16554, 0x056a0, 0x09ad0, 0x055d2,  # 1900-1909
    0x04ae0, 0x0a5b6, 0x0a4d0, 0x0d250, 0x1d255, 0x0b540, 0x0d6a0, 0x0ada2, 0x095b0, 0x14977,  # 1910-1919
    0x04970, 0x0a4b0, 0x0b4b5, 0x06a50, 0x06d40, 0x1ab54, 0x02b60, 0x09570, 0x052f2, 0x04970,  # 1920-1929
    0x06566, 0x0d4a0, 0x0ea50, 0x06e95, 0x05ad0, 0x02b60, 0x186e3, 0x092e0, 0x1c8d7, 0x0c950,  # 1930-1939
    0x0d4a0, 0x1d8a6, 0x0b550, 0x056a0, 0x1a5b4, 0x025d0, 0x092d0, 0x0d2b2, 0x0a950, 0x0b557,  # 1940-1949
    0x06ca0, 0x0b550, 0x15355, 0x04da0, 0x0a5b0, 0x14573, 0x052b0, 0x0a9a8, 0x0e950, 0x06aa0,  # 1950-1959
    0x0aea6, 0x0ab50, 0x04b60, 0x0aae4, 0x0a570, 0x05260, 0x0f263, 0x0d950, 0x05b57, 0x056a0,  # 1960-1969
    0x096d0, 0x04dd5, 0x04ad0, 0x0a4d0, 0x0d4d4, 0x0d250, 0x0d558, 0x0b540, 0x0b6a0, 0x195a6,  # 1970-1979
    0x095b0, 0x049b0, 0x0a974, 0x0a4b0, 0x0b27a, 0x06a50, 0x06d40, 0x0af46, 0x0ab60, 0x09570,  # 1980-1989
    0x04af5, 0x04970, 0x064b0, 0x074a3, 0x0ea50, 0x06b58, 0x05ac0, 0x0ab60, 0x096d5, 0x092e0,  # 1990-1999
    0x0c960, 0x0d954, 0x0d4a0, 0x0da50, 0x07552, 0x056a0, 0x0abb7, 0x025d0, 0x092d0, 0x0cab5,  # 2000-2009
    0x0a950, 0x0b4a0, 0x0baa4, 0x0ad50, 0x055d9, 0x04ba0, 0x0a5b0, 0x15176, 0x052b0, 0x0a930,  # 2010-2019
    0x07954, 0x06aa0, 0x0ad50, 0x05b52, 0x04b60, 0x0a6e6, 0x0a4e0, 0x0d260, 0x0ea65, 0x0d530,  # 2020-2029
    0x05aa0, 0x076a3, 0x096d0, 0x04afb, 0x04ad0, 0x0a4d0, 0x1d0b6, 0x0d250, 0x0d520, 0x0dd45,  # 2030-2039
    0x0b5a0, 0x056d0, 0x055b2, 0x049b0, 0x0a577, 0x0a4b0, 0x0aa50, 0x1b255, 0x06d20, 0x0ada0,  # 2040-2049
    0x14b63, 0x09370, 0x049f8, 0x04970, 0x064b0, 0x168a6, 0x0ea50, 0x06aa0, 0x1a6c4, 0x0aae0,  # 2050-2059
    0x092e0, 0x0d2e3, 0x0c960, 0x0d557, 0x0d4a0, 0x0da50, 0x05d55, 0x056a0, 0x0a6d0, 0x055d4,  # 2060-2069
    0x052d0, 0x0a9b8, 0x0a950, 0x0b4a0, 0x0b6a6, 0x0ad50, 0x055a0, 0x0aba4, 0x0a5b0, 0x052b0,  # 2070-2079
    0x0b273, 0x06930, 0x07337, 0x06aa0, 0x0ad50, 0x14b55, 0x04b60, 0x0a570, 0x054e4, 0x0d160,  # 2080-2089
    0x0e968, 0x0d520, 0x0daa0, 0x16aa6, 0x056d0, 0x04ae0, 0x0a9d4, 0x0a4d0, 0x0d150, 0x0f252,  # 2090-2099
    0x0d520,  # 2100
]

# 农历起始日: 1900年1月31日 = 农历庚子年正月初一
LUNAR_BASE_DATE = date(1900, 1, 31)

# 天干地支
TIAN_GAN = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
DI_ZHI   = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
SHENG_XIAO = ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"]
LUNAR_MONTHS = ["正", "二", "三", "四", "五", "六", "七", "八", "九", "十", "冬", "腊"]
LUNAR_DAYS_NAME = [
    "初一","初二","初三","初四","初五","初六","初七","初八","初九","初十",
    "十一","十二","十三","十四","十五","十六","十七","十八","十九","二十",
    "廿一","廿二","廿三","廿四","廿五","廿六","廿七","廿八","廿九","三十"
]

# 24节气
SOLAR_TERMS = [
    "小寒","大寒","立春","雨水","惊蛰","春分",
    "清明","谷雨","立夏","小满","芒种","夏至",
    "小暑","大暑","立秋","处暑","白露","秋分",
    "寒露","霜降","立冬","小雪","大雪","冬至"
]

# 节气角度（太阳黄经度数）
SOLAR_TERM_ANGLES = [i * 15 + 285 for i in range(24)]
for i in range(len(SOLAR_TERM_ANGLES)):
    SOLAR_TERM_ANGLES[i] = SOLAR_TERM_ANGLES[i] % 360

# 传统节日
FESTIVALS = {
    (1, 1): "🧧 春节",
    (1, 15): "🏮 元宵节",
    (2, 2): "🐲 龙抬头",
    (3, 3): "🌊 上巳节",
    (5, 5): "🛶 端午节",
    (7, 7): "💕 七夕节",
    (7, 15): "👻 中元节",
    (8, 15): "🥮 中秋节",
    (9, 9): "🏔️ 重阳节",
    (10, 1): "🍂 寒衣节",
    (10, 15): "🔮 下元节",
    (12, 8): "🥣 腊八节",
    (12, 23): "🧹 小年(北方)",
    (12, 24): "🧹 小年(南方)",
    (12, 30): "🎆 除夕",
}

def year_days(year_idx):
    """计算农历year的总天数"""
    info = LUNAR_INFO[year_idx]
    total = 0
    for i in range(12):
        if info & (0x10000 >> i):
            total += 30
        else:
            total += 29
    # 闰月
    leap = info & 0xf
    if leap:
        if info & 0x10000:
            total += 30
        else:
            total += 29
    return total

def leap_month(year_idx):
    """返回闰月月份，0表示无闰月"""
    return LUNAR_INFO[year_idx] & 0xf

def leap_month_days(year_idx):
    """闰月天数"""
    if LUNAR_INFO[year_idx] & 0x10000:
        return 30
    return 29

def month_days(year_idx, month):
    """某月天数(非闰)"""
    if LUNAR_INFO[year_idx] & (0x10000 >> month):
        return 30
    return 29

def solar_to_lunar(y, m, d):
    """公历转农历"""
    target = date(y, m, d)
    offset = (target - LUNAR_BASE_DATE).days
    if offset < 0:
        return None

    # 逐年减
    lunar_year = 1900
    while lunar_year < 2100:
        yd = year_days(lunar_year - 1900)
        if offset < yd:
            break
        offset -= yd
        lunar_year += 1

    year_idx = lunar_year - 1900
    lm = leap_month(year_idx)
    is_leap = False
    lunar_month = 1

    for i in range(1, 13):
        md = month_days(year_idx, i)
        if offset < md:
            lunar_month = i
            break
        offset -= md
        # 闰月在该月之后
        if i == lm:
            lmd = leap_month_days(year_idx)
            if offset < lmd:
                lunar_month = i
                is_leap = True
                break
            offset -= lmd
        lunar_month = i + 1

    if lunar_month > 12:
        lunar_month = 12

    lunar_day = offset + 1
    return (lunar_year, lunar_month, lunar_day, is_leap)

def get_gan_zhi(year):
    """天干地支"""
    gan_idx = (year - 4) % 10
    zhi_idx = (year - 4) % 12
    return TIAN_GAN[gan_idx] + DI_ZHI[zhi_idx]

def get_zodiac(year):
    """生肖"""
    return SHENG_XIAO[(year - 4) % 12]

def format_lunar_date(lunar_year, lunar_month, lunar_day, is_leap):
    month_name = ("闰" if is_leap else "") + LUNAR_MONTHS[lunar_month - 1] + "月"
    day_name = LUNAR_DAYS_NAME[lunar_day - 1] if lunar_day <= 30 else str(lunar_day)
    gz = get_gan_zhi(lunar_year)
    zd = get_zodiac(lunar_year)
    return f"农历 {gz}年({zd}年) {month_name}{day_name}"

def get_solar_terms_for_year(year):
    """计算某年所有24节气的日期（近似算法）"""
    terms = []
    for i in range(24):
        # 节气月份近似
        m = (i // 2 + 1)
        if m > 12:
            m -= 12
        # 使用寿星公式近似
        century = year // 100 + 1
        y = year % 100
        # 近似常数表（基于天文数据）
        C_values = [
            5.4055, 20.12,  3.87,  18.73,  5.63,  20.646,
            4.81,  20.1,   5.52,  21.04,  5.678, 21.37,
            7.108, 22.83,  7.5,   23.13,  7.646, 23.042,
            8.318, 23.438, 7.438, 22.36,  7.18,  21.94
        ]
        C = C_values[i]
        # 近似计算
        jd = int(y * 0.2422 + C) - int(y / 4)
        # 世纪修正
        if century == 20:
            pass  # 20世纪
        elif century == 21:
            if i in [0, 1, 2, 3]:
                pass
        terms.append({
            "name": SOLAR_TERMS[i],
            "month": (i // 2) + 1 if (i // 2) + 1 <= 12 else 12,
            "day": jd,
            "index": i
        })
    return terms

def get_festival(lunar_month, lunar_day):
    return FESTIVALS.get((lunar_month, lunar_day), None)

def cmd_today():
    today = date.today()
    result = solar_to_lunar(today.year, today.month, today.day)
    if not result:
        print("❌ 日期超出范围(1900-2100)")
        return
    ly, lm, ld, is_leap = result
    gz = get_gan_zhi(ly)
    zd = get_zodiac(ly)

    print("━" * 45)
    print("  📅 今日黄历")
    print("━" * 45)
    print(f"  公历: {today.year}年{today.month}月{today.day}日 {['一','二','三','四','五','六','日'][today.weekday()]}曜日")
    print(f"  农历: {format_lunar_date(ly, lm, ld, is_leap)}")
    print(f"  干支: {gz}年")
    emoji = list("🐀🐂🐅🐇🐉🐍🐎🐏🐒🐓🐕🐖")[(ly-4)%12]
    print("  生肖: {} {}".format(zd, emoji))
    print()

    fest = get_festival(lm, ld)
    if fest:
        print(f"  🎉 今日节日: {fest}")
        print()

    # 近期节气
    terms = get_solar_terms_for_year(today.year)
    print("  📌 近期节气:")
    for t in terms:
        try:
            td = date(today.year, t["month"], t["day"])
            diff = (td - today).days
            if -3 <= diff <= 15:
                marker = " ← 今日！" if diff == 0 else f" ({diff}天后)" if diff > 0 else f" ({-diff}天前)"
                print(f"     {t['name']}: {t['month']}月{t['day']}日{marker}")
        except:
            pass
    print()
    print("━" * 45)

def cmd_convert(args):
    parts = args.strip().split()
    if len(parts) < 3:
        print("用法: convert <年> <月> <日>")
        print("示例: convert 2024 2 10")
        return
    y, m, d = int(parts[0]), int(parts[1]), int(parts[2])
    try:
        target = date(y, m, d)
    except:
        print(f"❌ 无效日期: {y}-{m}-{d}")
        return
    result = solar_to_lunar(y, m, d)
    if not result:
        print("❌ 日期超出范围(1900-2100)")
        return
    ly, lm, ld, is_leap = result
    print("━" * 45)
    print("  📅 公历→农历转换")
    print("━" * 45)
    print(f"  公历: {y}年{m}月{d}日")
    print(f"  农历: {format_lunar_date(ly, lm, ld, is_leap)}")
    print(f"  干支: {get_gan_zhi(ly)}年")
    print(f"  生肖: {get_zodiac(ly)}")
    fest = get_festival(lm, ld)
    if fest:
        print(f"  节日: {fest}")
    print("━" * 45)

def cmd_zodiac(args):
    y = int(args.strip()) if args.strip() else date.today().year
    zd = get_zodiac(y)
    gz = get_gan_zhi(y)
    idx = (y - 4) % 12
    emojis = "🐀🐂🐅🐇🐉🐍🐎🐏🐒🐓🐕🐖"

    print("━" * 45)
    print(f"  🐾 {y}年 生肖信息")
    print("━" * 45)
    print(f"  生肖: {zd} {emojis[idx]}")
    print(f"  干支: {gz}年")
    yy_type = "阳" if (y-4)%10 % 2 == 0 else "阴"
    print("  天干: {} ({})".format(TIAN_GAN[(y-4)%10], yy_type))
    print(f"  地支: {DI_ZHI[(y-4)%12]}")
    print()
    # 五行
    wuxing = ["木","木","火","火","土","土","金","金","水","水"]
    print(f"  五行: {wuxing[(y-4)%10]}")
    print()
    # 相合相冲
    chong = ["午-马","未-羊","申-猴","酉-鸡","戌-狗","亥-猪","子-鼠","丑-牛","寅-虎","卯-兔","辰-龙","巳-蛇"]
    he   = ["丑-牛","子-鼠","亥-猪","戌-狗","酉-鸡","申-猴","未-羊","午-马","巳-蛇","辰-龙","卯-兔","寅-虎"]
    print(f"  六合: {he[idx]}")
    print(f"  相冲: {chong[idx]}")
    print()
    # 列出12生肖
    print("  十二生肖:")
    for i, sx in enumerate(SHENG_XIAO):
        marker = " ◀" if i == idx else ""
        print(f"    {DI_ZHI[i]}-{sx} {emojis[i]}{marker}")
    print("━" * 45)

def cmd_solar_terms(args):
    y = int(args.strip()) if args.strip() else date.today().year
    terms = get_solar_terms_for_year(y)
    today = date.today()
    print("━" * 45)
    print(f"  🌿 {y}年 二十四节气")
    print("━" * 45)
    seasons = [("🌱 春", 2, 7), ("☀️ 夏", 8, 13), ("🍂 秋", 14, 19), ("❄️ 冬", 20, 25)]
    for sname, si, ei in seasons:
        print(f"\n  {sname}:")
        for t in terms:
            if si <= t["index"] + 1 <= ei or (ei > 24 and t["index"] + 1 <= ei - 24):
                idx = t["index"]
                if si <= idx + 1 <= ei:
                    try:
                        td = date(y, t["month"], t["day"])
                        is_today = (td == today)
                        marker = " ← 今日" if is_today else ""
                        past = " (已过)" if td < today and y == today.year else ""
                        print(f"    {t['name']:4s}  {t['month']:2d}月{t['day']:2d}日{marker}{past}")
                    except:
                        print(f"    {t['name']:4s}  {t['month']:2d}月{t['day']:2d}日")
    print()
    print("━" * 45)

def cmd_festival_list():
    print("━" * 45)
    print("  🎊 中国传统节日一览")
    print("━" * 45)
    for (m, d), name in sorted(FESTIVALS.items()):
        month_name = LUNAR_MONTHS[m - 1] + "月"
        day_name = LUNAR_DAYS_NAME[d - 1]
        print(f"  {name:14s}  农历{month_name}{day_name}")
    print()

    today = date.today()
    result = solar_to_lunar(today.year, today.month, today.day)
    if result:
        ly, lm, ld, _ = result
        print("  📌 近期节日:")
        for (m, d), name in sorted(FESTIVALS.items()):
            diff_m = m - lm
            diff_d = d - ld
            if diff_m == 0 and 0 <= diff_d <= 30:
                print(f"     {name} - 约{diff_d}天后")
            elif diff_m == 1 and diff_d < 0:
                print(f"     {name} - 约{30 + diff_d}天后")
    print("━" * 45)

def cmd_year_info(args):
    y = int(args.strip()) if args.strip() else date.today().year
    if y < 1900 or y > 2100:
        print("❌ 支持范围: 1900-2100")
        return
    year_idx = y - 1900
    gz = get_gan_zhi(y)
    zd = get_zodiac(y)
    lm = leap_month(year_idx)
    td = year_days(year_idx)

    print("━" * 45)
    print(f"  📊 {y}年 农历年度信息")
    print("━" * 45)
    print(f"  干支: {gz}年")
    print(f"  生肖: {zd}")
    lm_str = "无" if lm == 0 else LUNAR_MONTHS[lm-1] + "月 (" + str(leap_month_days(year_idx)) + "天)"
    print("  闰月: {}".format(lm_str))
    print(f"  全年: {td}天")
    print()
    print("  各月天数:")
    for i in range(1, 13):
        md = month_days(year_idx, i)
        m_size = "(大)" if md == 30 else "(小)"
        print("    {}月: {}天 {}".format(LUNAR_MONTHS[i-1], md, m_size))
        if i == lm:
            lmd = leap_month_days(year_idx)
            lm_size = "(大)" if lmd == 30 else "(小)"
            print("    闰{}月: {}天 {}".format(LUNAR_MONTHS[i-1], lmd, lm_size))
    print("━" * 45)

# 主入口
if len(sys.argv) < 2:
    print("need command")
    sys.exit(1)

cmd = sys.argv[1]
arg = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else ""

if cmd == "today":
    cmd_today()
elif cmd == "convert":
    cmd_convert(arg)
elif cmd == "zodiac":
    cmd_zodiac(arg)
elif cmd == "solar-term":
    cmd_solar_terms(arg)
elif cmd == "festival":
    cmd_festival_list()
elif cmd == "year-info":
    cmd_year_info(arg)
else:
    print("Unknown command:", cmd)
'

show_help() {
  cat <<'HELP'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📅 中国农历计算器 — 纯算法实现
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  today                    今日黄历(公历→农历)
  convert <年> <月> <日>   公历转农历
  zodiac [年份]            生肖/干支/五行查询
  solar-term [年份]        二十四节气日期
  festival                 传统节日一览
  year-info [年份]         年度农历信息

  示例:
    bash calendar.sh today
    bash calendar.sh convert 2024 2 10
    bash calendar.sh zodiac 2000
    bash calendar.sh solar-term 2025
    bash calendar.sh year-info 2024

  支持范围: 1900-2100
  算法: 纯Python计算，无需第三方库

  Powered by BytesAgain | bytesagain.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
HELP
}

case "$CMD" in
  today|convert|zodiac|solar-term|festival|year-info)
    python3 -c "$LUNAR_CALC_PY" "$CMD" $INPUT
    ;;
  *)
    show_help
    ;;
esac
