#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys,hashlib
from datetime import datetime
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
QS=[("What is the capital of Australia?","Canberra"),("How many planets in our solar system?","8"),("What year did the Titanic sink?","1912"),("What is the largest ocean?","Pacific"),("How many bones in the human body?","206"),("What is the speed of light?","~300,000 km/s"),("Who painted the Mona Lisa?","Leonardo da Vinci"),("What is the smallest country?","Vatican City"),("What gas do plants absorb?","Carbon dioxide (CO2)"),("How many continents are there?","7"),("What is the longest river?","Nile (~6,650 km)"),("What element has symbol Au?","Gold"),("Who wrote Romeo and Juliet?","William Shakespeare"),("What is the boiling point of water?","100C / 212F"),("What planet is known as Red Planet?","Mars")]
if cmd=="play":
    count=int(inp) if inp and inp.isdigit() else 5
    seed=int(hashlib.md5(datetime.now().strftime("%Y%m%d%H%M").encode()).hexdigest()[:8],16)
    print("  Trivia Quiz ({} questions):".format(count))
    print("")
    for i in range(count):
        idx=(seed+i*7)%len(QS)
        q,a=QS[idx]
        print("  Q{}: {}".format(i+1,q))
        print("  A{}: {}".format(i+1,a))
        print("")
elif cmd=="categories":
    print("  Categories: General Knowledge, Science, Geography, History, Arts")
elif cmd=="help":
    print("Trivia Quiz\n  play [count]   — Generate quiz questions\n  categories      — List categories")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT