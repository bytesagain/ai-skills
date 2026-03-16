#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys
cmd = sys.argv[1] if len(sys.argv)>1 else "help"
inp = " ".join(sys.argv[2:])
if cmd=="plan":
    name=inp if inp else "My Event"
    print("=" * 50)
    print("  Event Plan: {}".format(name))
    print("=" * 50)
    for section in [("Date & Time","___"),("Venue","___"),("Expected Attendance","___"),("Budget","$___"),("Theme","___")]:
        print("  {:20s} {}".format(section[0]+":", section[1]))
    print("\n  Timeline:")
    for w in ["8 weeks: Book venue, set date","6 weeks: Send invitations","4 weeks: Confirm vendors/catering","2 weeks: Final headcount","1 week: Confirm all details","Day of: Setup, execute, enjoy!"]:
        print("    {}".format(w))
elif cmd=="budget":
    total=float(inp) if inp and inp.replace(".","").isdigit() else 10000
    items=[("Venue",30),("Catering",35),("Entertainment",10),("Decorations",8),("Marketing",7),("Misc/Buffer",10)]
    print("  Budget Breakdown (${:,.0f} total):".format(total))
    for name,pct in items:
        print("    {:15s} {:>5.0f}%  ${:>10,.0f}".format(name,pct,total*pct/100))
elif cmd=="checklist":
    for phase,items in [("Pre-Event",["[ ] Venue booked","[ ] Budget approved","[ ] Invitations sent","[ ] Vendors confirmed","[ ] Schedule finalized"]),("Day-Of",["[ ] Setup complete","[ ] AV tested","[ ] Registration ready","[ ] Emergency contacts shared","[ ] Photography arranged"]),("Post-Event",["[ ] Thank you notes sent","[ ] Feedback survey","[ ] Final budget reconciled","[ ] Photos shared","[ ] Lessons learned documented"])]:
        print("  {}:".format(phase))
        for i in items: print("    {}".format(i))
        print("")
elif cmd=="help":
    print("Event Planner\n  plan [name]      — Event planning template\n  budget [amount]   — Budget breakdown\n  checklist         — Pre/during/post checklists")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT