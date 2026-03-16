#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys,hashlib
from datetime import datetime
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
ZODIAC=["鼠","牛","虎","兔","龙","蛇","马","羊","猴","鸡","狗","猪"]
ELEMENTS=["金","木","水","火","土"]
HEAVENLY=["甲","乙","丙","丁","戊","己","庚","辛","壬","癸"]
EARTHLY=["子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥"]
if cmd=="bazi":
    year=int(inp) if inp and inp.isdigit() else datetime.now().year
    gz="{}{}".format(HEAVENLY[(year-4)%10],EARTHLY[(year-4)%12])
    zd=ZODIAC[(year-4)%12]
    elem=ELEMENTS[(year-4)%10//2]
    print("  {}年 八字速查".format(year))
    print("  干支: {}年".format(gz))
    print("  生肖: {}".format(zd))
    print("  五行: {} ({})".format(elem, "阳" if (year-4)%2==0 else "阴"))
elif cmd=="daily":
    seed=int(hashlib.md5(datetime.now().strftime("%Y%m%d").encode()).hexdigest()[:8],16)
    luck=["大吉","中吉","小吉","吉","末吉","凶"][seed%6]
    lucky_num=(seed%9)+1
    colors=["红色","金色","蓝色","绿色","紫色","白色","黄色"]
    lucky_color=colors[seed%len(colors)]
    dirs=["东","南","西","北","东南","东北","西南","西北"]
    lucky_dir=dirs[seed%len(dirs)]
    print("  今日运势 — {}".format(datetime.now().strftime("%Y-%m-%d")))
    print("  运势: {}".format(luck))
    print("  幸运数字: {}".format(lucky_num))
    print("  幸运颜色: {}".format(lucky_color))
    print("  吉利方位: {}".format(lucky_dir))
    do_list=["签合同","表白","出行","面试","搬家","开业","投资"]
    dont_list=["争吵","赌博","熬夜","借钱","冲动消费"]
    print("  宜: {}".format(do_list[seed%len(do_list)]))
    print("  忌: {}".format(dont_list[seed%len(dont_list)]))
elif cmd=="zodiac":
    year=int(inp) if inp and inp.isdigit() else datetime.now().year
    zd=ZODIAC[(year-4)%12]
    compat=ZODIAC[((year-4)+4)%12]
    clash=ZODIAC[((year-4)+6)%12]
    print("  {}年 = {} 🐾".format(year,zd))
    print("  六合: {}".format(compat))
    print("  相冲: {}".format(clash))
elif cmd=="help":
    print("Fortune Teller\n  bazi [year]    — Ba Zi / Eight Characters\n  daily          — Today fortune\n  zodiac [year]  — Zodiac compatibility")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT