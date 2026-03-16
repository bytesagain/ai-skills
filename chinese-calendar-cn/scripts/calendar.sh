#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 << PYEOF
import sys
from datetime import datetime
cmd = "$CMD"; inp = """$INPUT"""
ZODIAC = ["鼠","牛","虎","兔","龙","蛇","马","羊","猴","鸡","狗","猪"]
HEAVENLY = ["甲","乙","丙","丁","戊","己","庚","辛","壬","癸"]
EARTHLY = ["子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥"]
SOLAR_TERMS = [("小寒","1-6"),("大寒","1-20"),("立春","2-4"),("雨水","2-19"),("惊蛰","3-6"),("春分","3-21"),("清明","4-5"),("谷雨","4-20"),("立夏","5-6"),("小满","5-21"),("芒种","6-6"),("夏至","6-21"),("小暑","7-7"),("大暑","7-23"),("立秋","8-7"),("处暑","8-23"),("白露","9-8"),("秋分","9-23"),("寒露","10-8"),("霜降","10-23"),("立冬","11-7"),("小雪","11-22"),("大雪","12-7"),("冬至","12-22")]
FESTIVALS = [("春节","正月初一"),("元宵","正月十五"),("清明","4月5日左右"),("端午","五月初五"),("七夕","七月初七"),("中秋","八月十五"),("重阳","九月初九"),("冬至","12月22日左右"),("除夕","腊月三十")]
def cmd_today():
    now = datetime.now()
    y = now.year
    gz = "{}{}".format(HEAVENLY[(y-4)%10], EARTHLY[(y-4)%12])
    zd = ZODIAC[(y-4)%12]
    print("=" * 45)
    print("  {} — 农历速查".format(now.strftime("%Y-%m-%d")))
    print("=" * 45)
    print("  公历: {}".format(now.strftime("%Y年%m月%d日 %A")))
    print("  干支: {}年".format(gz))
    print("  生肖: {}".format(zd))
    upcoming = []
    for name, date_str in SOLAR_TERMS:
        parts = date_str.split("-")
        m, d = int(parts[0]), int(parts[1])
        try:
            st_date = datetime(y, m, d)
            if st_date >= now:
                diff = (st_date - now).days
                upcoming.append((name, st_date.strftime("%m-%d"), diff))
        except: pass
    if upcoming:
        n = upcoming[0]
        print("  下一节气: {} ({}, {}天后)".format(n[0], n[1], n[2]))
def cmd_zodiac():
    year = int(inp) if inp and inp.strip().isdigit() else datetime.now().year
    zd = ZODIAC[(year-4)%12]
    gz = "{}{}".format(HEAVENLY[(year-4)%10], EARTHLY[(year-4)%12])
    print("  {}年: {} {}年".format(year, gz, zd))
def cmd_solar():
    print("=" * 45)
    print("  二十四节气")
    print("=" * 45)
    for name, date in SOLAR_TERMS:
        print("  {:6s} — 约{}".format(name, date))
def cmd_festival():
    print("=" * 45)
    print("  中国传统节日")
    print("=" * 45)
    for name, date in FESTIVALS:
        print("  {:6s} — {}".format(name, date))
cmds = {"today":cmd_today,"zodiac":cmd_zodiac,"solar":cmd_solar,"festival":cmd_festival}
if cmd == "help":
    print("Chinese Calendar Tool")
    print("  today             — Today in Chinese calendar")
    print("  zodiac [year]     — Zodiac animal lookup")
    print("  solar             — 24 solar terms")
    print("  festival          — Traditional festivals")
elif cmd in cmds: cmds[cmd]()
else: print("Unknown: {}".format(cmd))
print("\nPowered by BytesAgain | bytesagain.com")
PYEOF
