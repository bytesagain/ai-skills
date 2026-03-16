#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
ROOMS={"kitchen":["Clear countertops","Organize pantry by category","Clean out fridge (weekly)","Drawer dividers for utensils","Label containers"],"bedroom":["Make bed daily","Seasonal clothing rotation","Nightstand: only essentials","Under-bed storage boxes","Closet: one-in-one-out rule"],"bathroom":["Toss expired products","Shower caddy for bottles","Drawer organizers","Weekly deep clean","Minimize countertop items"],"office":["Cable management","File/scan papers weekly","Desktop: only current items","Inbox zero system","Ergonomic setup check"],"living":["Remove items that do not belong","Coffee table: max 3 items","Bookshelf organization","Cord hiding solutions","Weekly vacuum schedule"]}
if cmd=="room":
    room=inp.lower().strip() if inp else ""
    if room in ROOMS:
        print("  {} Organization:".format(room.title()))
        for tip in ROOMS[room]: print("    - {}".format(tip))
    else:
        for r in ROOMS: print("  {}".format(r))
        print("  Usage: room <name>")
elif cmd=="declutter":
    print("  Declutter Decision Tree:")
    print("  For each item ask:")
    print("    1. Used in last 12 months? No -> Donate/Toss")
    print("    2. Sparks joy? No -> Thank it, let go")
    print("    3. Duplicate? Yes -> Keep best, donate rest")
    print("    4. Broken? Yes -> Fix this week or toss")
    print("    5. Sentimental? Take photo, let object go")
elif cmd=="checklist":
    print("  Weekly Cleaning Checklist:")
    for task in ["[ ] Vacuum all rooms","[ ] Mop kitchen/bathroom","[ ] Wipe countertops","[ ] Clean mirrors","[ ] Change bed linens","[ ] Take out trash/recycling","[ ] Wipe appliances","[ ] Organize mail/papers"]:
        print("    {}".format(task))
elif cmd=="help":
    print("Home Organizer\n  room [name]    — Room-specific tips\n  declutter       — Decision tree\n  checklist       — Weekly cleaning list")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT