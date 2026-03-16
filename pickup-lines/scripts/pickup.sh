#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys,hashlib
from datetime import datetime
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
LINES={"nerdy":["Are you a keyboard? Because you are my type.","You must be made of copper and tellurium because you are CuTe.","Are you a 90 degree angle? Because you look just right.","I wish I were your derivative so I could lie tangent to your curves.","Are you a compiler? Because you make my heart race."],"smooth":["Do you have a map? I keep getting lost in your eyes.","Is your name Google? Because you have everything I have been searching for.","Are you a parking ticket? Because you have FINE written all over you.","Do you believe in love at first sight, or should I walk by again?","I am not a photographer, but I can picture us together."],"funny":["Are you a bank loan? Because you have my interest.","Do you have a Band-Aid? I just scraped my knee falling for you.","Are you WiFi? Because I am feeling a connection.","Is there an airport nearby, or is that just my heart taking off?","Did it hurt? When you fell from the vending machine? Because you look like a snack."]}
if cmd=="random":
    cat=inp.lower() if inp and inp in LINES else ""
    seed=int(hashlib.md5(datetime.now().strftime("%Y%m%d%H%M%S").encode()).hexdigest()[:8],16)
    if cat:
        pool=LINES[cat]
    else:
        pool=[l for lines in LINES.values() for l in lines]
    print("  {}".format(pool[seed%len(pool)]))
elif cmd=="category":
    cat=inp.lower() if inp else ""
    if cat in LINES:
        print("  {} lines:".format(cat.title()))
        for l in LINES[cat]: print("    - {}".format(l))
    else:
        for c in LINES: print("  {}".format(c))
elif cmd=="help":
    print("Pickup Lines\n  random [category]    — Random line (nerdy/smooth/funny)\n  category [name]      — Browse by category")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com\nUse responsibly and respectfully!")
' "$CMD" $INPUT