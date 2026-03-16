#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
TEMPLATES={"engineer":{"title":"Software Engineer","req":["3+ years experience","Proficient in Python/Java/Go","System design skills","CI/CD knowledge","Team collaboration"],"nice":["Open source contributions","Cloud platform experience","Leadership experience"],"resp":["Design and implement features","Code review and mentoring","On-call rotation","Technical documentation"]},"pm":{"title":"Product Manager","req":["3+ years PM experience","Data-driven decision making","User research skills","Roadmap planning","Cross-functional collaboration"],"nice":["Technical background","MBA","Domain expertise"],"resp":["Define product vision","Prioritize backlog","Analyze metrics","Stakeholder communication"]},"designer":{"title":"UI/UX Designer","req":["Portfolio required","Figma/Sketch proficiency","User research experience","Design system knowledge","Responsive design"],"nice":["Motion design","Front-end coding","Accessibility expertise"],"resp":["Create wireframes and mockups","Conduct user testing","Maintain design system","Collaborate with engineering"]}}
if cmd=="generate":
    parts=inp.split() if inp else ["engineer"]
    role=parts[0].lower()
    company=parts[1] if len(parts)>1 else "Our Company"
    t=TEMPLATES.get(role,TEMPLATES["engineer"])
    print("JOB DESCRIPTION")
    print("=" * 50)
    print("  {} — {}".format(t["title"],company))
    print("")
    print("  About Us:")
    print("  {} is a [describe company]...".format(company))
    print("")
    print("  Responsibilities:")
    for r in t["resp"]: print("  - {}".format(r))
    print("")
    print("  Requirements:")
    for r in t["req"]: print("  - {}".format(r))
    print("")
    print("  Nice to Have:")
    for r in t["nice"]: print("  - {}".format(r))
    print("")
    print("  Benefits:")
    for b in ["Competitive salary","Health insurance","Flexible WFH","Learning budget","Stock options"]: print("  - {}".format(b))
elif cmd=="roles":
    print("  Available templates: {}".format(", ".join(TEMPLATES.keys())))
elif cmd=="help":
    print("JD Writer\n  generate <role> [company]  — Generate job description\n  roles                     — List available templates")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT