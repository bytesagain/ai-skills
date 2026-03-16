#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
GIFTS={"low":[("Handwritten card","$2"),("Custom playlist","Free"),("Baked goods","$10"),("Photo collage","$5"),("Book","$15"),("Candle","$12"),("Mug with message","$10")],"mid":[("Bluetooth speaker","$30"),("Skincare set","$40"),("Board game","$25"),("Cookbook","$20"),("Subscription box","$30"),("Smart water bottle","$35")],"high":[("Noise-canceling headphones","$100"),("Smart watch","$150"),("Weekend getaway","$200"),("Online course bundle","$100"),("High-end backpack","$120")]}
OCCASIONS={"birthday":"Something personal reflecting their interests","anniversary":"Romantic + meaningful, shared experiences","graduation":"Practical + aspirational","holiday":"Universal crowd-pleasers","thank-you":"Thoughtful, not expensive"}
if cmd=="suggest":
    parts=inp.split() if inp else []
    budget=parts[0] if parts else "mid"
    items=GIFTS.get(budget,GIFTS["mid"])
    print("  Gift Ideas ({} budget):".format(budget))
    for name,price in items: print("    {} — {}".format(name,price))
elif cmd=="occasion":
    occ=inp.lower().strip() if inp else ""
    if occ in OCCASIONS:
        print("  {} gifts: {}".format(occ.title(),OCCASIONS[occ]))
    else:
        for o,tip in OCCASIONS.items(): print("  {:12s} {}".format(o,tip))
elif cmd=="help":
    print("Gift Finder\n  suggest [low|mid|high]  — Gift ideas by budget\n  occasion [type]         — Tips by occasion")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT