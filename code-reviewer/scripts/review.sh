#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys
cmd = sys.argv[1] if len(sys.argv)>1 else "help"
inp = " ".join(sys.argv[2:])
CHECKLIST={"logic":["Off-by-one errors","Null/undefined checks","Edge cases handled","Error handling present","No infinite loops"],"security":["SQL injection prevention","XSS prevention","Input validation","Auth checks","Secrets not hardcoded"],"style":["Consistent naming","Functions <30 lines","No magic numbers","Comments for why not what","DRY principle"],"perf":["No N+1 queries","Caching considered","Unnecessary loops removed","Memory leaks checked","Lazy loading used"]}
if cmd=="checklist":
    cat=inp.lower() if inp else ""
    items=CHECKLIST if not cat else {cat:CHECKLIST[cat]} if cat in CHECKLIST else CHECKLIST
    for c,checks in items.items():
        print("  {}:".format(c.upper()))
        for ch in checks: print("    [ ] {}".format(ch))
        print("")
elif cmd=="score":
    total=20; passed=int(inp) if inp and inp.isdigit() else 0
    pct=passed/total*100
    print("  Score: {}/{} ({:.0f}%)".format(passed,total,pct))
    print("  " + "#"*int(pct/5) + "-"*(20-int(pct/5)))
    if pct>=80: print("  PASS - Ship it!")
    elif pct>=60: print("  REVIEW - Fix issues first")
    else: print("  REJECT - Major issues")
elif cmd=="help":
    print("Code Reviewer\n  checklist [category]  — Review checklist (logic/security/style/perf)\n  score <passed>        — Score out of 20")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT