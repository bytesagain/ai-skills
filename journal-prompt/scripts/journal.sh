#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys,hashlib
from datetime import datetime
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
PROMPTS={"morning":["What am I grateful for today?","What is my #1 priority today?","How do I want to feel by end of day?","What challenge might I face and how will I handle it?","What would make today great?"],"evening":["What went well today?","What did I learn?","What would I do differently?","Who made a positive impact on me?","What am I looking forward to tomorrow?"],"deep":["What fear is holding me back?","If money were no object, what would I do?","What relationship needs more attention?","What habit do I want to build/break?","What would my 80-year-old self advise?"],"creative":["Write about a door that should not be opened","Describe your perfect day in detail","Letter to your future self","What does home mean to you?","The best mistake I ever made"]}
if cmd=="today":
    cat=inp.lower() if inp and inp in PROMPTS else "morning" if datetime.now().hour<12 else "evening"
    seed=int(hashlib.md5(datetime.now().strftime("%Y%m%d").encode()).hexdigest()[:8],16)
    prompts=PROMPTS[cat]
    idx=seed%len(prompts)
    print("  Journal Prompt — {} ({})".format(datetime.now().strftime("%Y-%m-%d"),cat))
    print("")
    print("  {}".format(prompts[idx]))
    print("")
    print("  Take 10 minutes. Write freely. No editing.")
elif cmd=="all":
    for cat,prompts in PROMPTS.items():
        print("  {}:".format(cat.upper()))
        for p in prompts: print("    - {}".format(p))
        print("")
elif cmd=="help":
    print("Journal Prompts\n  today [morning|evening|deep|creative]  — Daily prompt\n  all                                    — List all prompts")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT