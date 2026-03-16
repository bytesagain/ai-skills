#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys,hashlib
from datetime import datetime
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
SIGNS={"aries":("白羊座","3/21-4/19","Fire","Mars"),"taurus":("金牛座","4/20-5/20","Earth","Venus"),"gemini":("双子座","5/21-6/20","Air","Mercury"),"cancer":("巨蟹座","6/21-7/22","Water","Moon"),"leo":("狮子座","7/23-8/22","Fire","Sun"),"virgo":("处女座","8/23-9/22","Earth","Mercury"),"libra":("天秤座","9/23-10/22","Air","Venus"),"scorpio":("天蝎座","10/23-11/21","Water","Pluto"),"sagittarius":("射手座","11/22-12/21","Fire","Jupiter"),"capricorn":("摩羯座","12/22-1/19","Earth","Saturn"),"aquarius":("水瓶座","1/20-2/18","Air","Uranus"),"pisces":("双鱼座","2/19-3/20","Water","Neptune")}
ASPECTS=["Love","Career","Health","Finance","Social"]
if cmd=="daily":
    sign=inp.lower().strip() if inp and inp.lower() in SIGNS else "aries"
    seed=int(hashlib.md5((datetime.now().strftime("%Y%m%d")+sign).encode()).hexdigest()[:8],16)
    info=SIGNS.get(sign,SIGNS["aries"])
    print("  {} {} — {}".format(info[0],sign.title(),datetime.now().strftime("%Y-%m-%d")))
    stars=["*"*(2+(seed>>i*3)%4) for i in range(5)]
    for i,aspect in enumerate(ASPECTS):
        print("    {:10s} {}".format(aspect,stars[i]))
    tips=["Take initiative today","Be patient with others","Focus on self-care","Good day for investments","Reach out to old friends","Trust your instincts","Avoid arguments","Creative energy is high"]
    print("  Tip: {}".format(tips[seed%len(tips)]))
elif cmd=="compatibility":
    parts=inp.lower().split() if inp else []
    if len(parts)<2:
        print("  Usage: compatibility <sign1> <sign2>")
    else:
        s1,s2=parts[0],parts[1]
        seed=int(hashlib.md5((s1+s2).encode()).hexdigest()[:8],16)
        score=50+(seed%51)
        print("  {} + {} = {}% compatible".format(s1.title(),s2.title(),score))
        if score>80: print("  Excellent match!")
        elif score>60: print("  Good potential")
        else: print("  Challenging but possible")
elif cmd=="traits":
    sign=inp.lower().strip() if inp else ""
    if sign in SIGNS:
        info=SIGNS[sign]
        print("  {} ({})".format(info[0],sign.title()))
        print("  Dates: {}".format(info[1]))
        print("  Element: {}".format(info[2]))
        print("  Ruler: {}".format(info[3]))
    else:
        for k,v in SIGNS.items(): print("  {:13s} {} {}".format(k,v[0],v[1]))
elif cmd=="help":
    print("Horoscope\n  daily [sign]          — Daily horoscope\n  compatibility <s1> <s2> — Match score\n  traits [sign]          — Sign details")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT