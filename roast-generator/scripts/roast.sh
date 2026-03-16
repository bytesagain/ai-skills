#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys,hashlib
from datetime import datetime
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
ROASTS={"programmer":["Your code has more bugs than a dumpster behind Dennys.","You write spaghetti code and call it architecture.","Git blame always points to you.","Your commit messages are just keyboard smashes.","You use Stack Overflow so much they should charge you rent."],"general":["You bring everyone so much joy... when you leave.","I would explain it to you but I ran out of crayons.","You are the reason they put instructions on shampoo.","Somewhere out there, a tree is producing oxygen for you. Apologize to it.","If you were any more laid back, you would be horizontal."],"friend":["You are the human equivalent of a participation trophy.","I am not saying you are boring, but your autobiography would be one page.","You are proof that evolution can go in reverse.","If personalities had calories, you would be a rice cake.","Your WiFi personality: always connected, never strong."]}
if cmd=="generate":
    cat=inp.lower() if inp and inp in ROASTS else "general"
    seed=int(hashlib.md5(datetime.now().strftime("%S%M%H").encode()).hexdigest()[:8],16)
    pool=ROASTS[cat]
    print("  {}".format(pool[seed%len(pool)]))
    print("\n  (All in good fun! Never use to actually hurt someone.)")
elif cmd=="category":
    for c in ROASTS: print("  {} ({} roasts)".format(c,len(ROASTS[c])))
elif cmd=="help":
    print("Roast Generator\n  generate [programmer|general|friend] — Random roast\n  category                             — List categories")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com\nAll in good fun!")
' "$CMD" $INPUT