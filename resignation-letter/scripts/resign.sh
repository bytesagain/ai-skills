#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys
from datetime import datetime,timedelta
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
if cmd=="generate":
    parts=inp.split() if inp else []
    name=parts[0] if parts else "[Your Name]"
    company=parts[1] if len(parts)>1 else "[Company]"
    weeks=int(parts[2]) if len(parts)>2 else 2
    last_day=(datetime.now()+timedelta(weeks=weeks)).strftime("%B %d, %Y")
    print("LETTER OF RESIGNATION")
    print("="*50)
    print("")
    print("Date: {}".format(datetime.now().strftime("%B %d, %Y")))
    print("")
    print("Dear [Manager Name],")
    print("")
    print("I am writing to formally notify you of my resignation")
    print("from my position at {}.".format(company))
    print("")
    print("My last day of work will be {}, providing".format(last_day))
    print("the standard {} weeks notice.".format(weeks))
    print("")
    print("I am grateful for the opportunities I have had during")
    print("my time at {}. I have valued the experience".format(company))
    print("and professional growth.")
    print("")
    print("I am committed to ensuring a smooth transition and am")
    print("happy to help train my replacement during this period.")
    print("")
    print("Sincerely,")
    print(name)
elif cmd=="checklist":
    print("  Pre-Resignation Checklist:")
    for item in ["[ ] New job offer signed (if applicable)","[ ] Review employment contract (notice period, non-compete)","[ ] Calculate remaining PTO/benefits","[ ] Prepare resignation letter","[ ] Schedule meeting with manager (in person preferred)","[ ] Back up personal files from work computer","[ ] Update LinkedIn quietly","[ ] Prepare handover document","[ ] Have financial buffer (1-3 months expenses)","[ ] Know your last paycheck date"]:
        print("    {}".format(item))
elif cmd=="help":
    print("Resignation Letter\n  generate <name> [company] [weeks] — Generate letter\n  checklist                         — Pre-resignation checklist")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT