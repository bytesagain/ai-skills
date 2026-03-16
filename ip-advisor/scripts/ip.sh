#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
run_python() {
python3 << 'PYEOF'
import sys
cmd = sys.argv[1] if len(sys.argv) > 1 else "help"
inp = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else ""

def cmd_trademark():
    print("=" * 55)
    print("  Trademark Registration Guide")
    print("=" * 55)
    print("")
    steps = [
        ("1. Search", "Check if mark is available\n    - USPTO TESS: https://tess2.uspto.gov\n    - CNIPA: https://wcjs.sbj.cnipa.gov.cn"),
        ("2. Choose Class", "Nice Classification (45 classes)\n    - Class 9: Software\n    - Class 35: Advertising/Business\n    - Class 42: IT/SaaS\n    - Average cost: $250-350 per class (USPTO)"),
        ("3. File Application", "Required info:\n    - Mark (word/design/combo)\n    - Owner name and address\n    - Class and description of goods/services\n    - Specimen of use (if use-based)"),
        ("4. Examination", "USPTO: 8-12 months\n    CNIPA: 6-9 months"),
        ("5. Publication", "30-day opposition period"),
        ("6. Registration", "Valid for 10 years, renewable"),
    ]
    for title, desc in steps:
        print("  {}".format(title))
        for line in desc.split("\n"):
            print("    {}".format(line.strip()))
        print("")

def cmd_patent():
    print("=" * 55)
    print("  Patent Filing Overview")
    print("=" * 55)
    print("")
    types = [
        ("Utility Patent", "New/useful process, machine, composition\n  Duration: 20 years\n  Cost: $5K-15K (with attorney)\n  Timeline: 18-36 months"),
        ("Design Patent", "New ornamental design\n  Duration: 15 years\n  Cost: $2K-5K\n  Timeline: 12-18 months"),
        ("Provisional", "Placeholder (12 months to file full)\n  Cost: $1K-3K\n  Benefit: Establishes priority date"),
    ]
    for name, desc in types:
        print("  {}".format(name))
        for line in desc.split("\n"):
            print("    {}".format(line.strip()))
        print("")
    print("  Patentability Requirements:")
    print("    1. Novel (not previously known)")
    print("    2. Non-obvious (to skilled person)")
    print("    3. Useful (has practical application)")
    print("    4. Adequately described")

def cmd_copyright():
    print("=" * 55)
    print("  Copyright Protection Guide")
    print("=" * 55)
    print("")
    print("  Automatic Protection:")
    print("    Copyright exists from the moment of creation.")
    print("    Registration is optional but recommended.")
    print("")
    print("  What is Protected:")
    print("    + Literary works, music, art, photos")
    print("    + Software code, databases")
    print("    + Architecture, choreography")
    print("    - Ideas, facts, titles, names")
    print("    - Methods, systems, processes")
    print("")
    print("  Duration:")
    print("    Individual: Life + 70 years")
    print("    Work for hire: 95 years from publication")
    print("    Anonymous: 95 years from publication")
    print("")
    print("  Registration Benefits:")
    print("    - Legal presumption of ownership")
    print("    - Statutory damages available")
    print("    - Required before filing lawsuit (US)")
    print("    - US: copyright.gov ($65 online)")
    print("    - China: ccopyright.com.cn")

def cmd_evaluate():
    if not inp:
        print("Usage: evaluate <ip_type> <industry> <stage>")
        print("Example: evaluate trademark tech startup")
        return
    parts = inp.split()
    ip_type = parts[0] if parts else "trademark"
    industry = parts[1] if len(parts) > 1 else "tech"
    stage = parts[2] if len(parts) > 2 else "startup"

    print("=" * 50)
    print("  IP Strategy Assessment")
    print("=" * 50)
    print("")
    print("  Type: {}  Industry: {}  Stage: {}".format(ip_type, industry, stage))
    print("")
    priorities = {
        "startup": ["Trademark (brand protection)", "Trade secrets (NDAs)", "Copyright (code)", "Patent (if novel tech)"],
        "growth": ["Patent portfolio", "Trademark expansion", "IP licensing", "Monitoring/enforcement"],
        "enterprise": ["Global IP strategy", "Portfolio optimization", "Litigation readiness", "IP valuation"],
    }
    p = priorities.get(stage, priorities["startup"])
    print("  Recommended Priority:")
    for i, item in enumerate(p, 1):
        print("    {}. {}".format(i, item))
    print("")
    print("  Estimated Budget:")
    budgets = {"startup": "$2K-10K/year", "growth": "$10K-50K/year", "enterprise": "$50K+/year"}
    print("    {}".format(budgets.get(stage, "$5K-20K/year")))

commands = {"trademark": cmd_trademark, "patent": cmd_patent, "copyright": cmd_copyright, "evaluate": cmd_evaluate}
if cmd == "help":
    print("IP Advisor — Intellectual Property Guide")
    print("")
    print("Commands:")
    print("  trademark              — Trademark registration guide")
    print("  patent                 — Patent filing overview")
    print("  copyright              — Copyright protection guide")
    print("  evaluate <type> <ind>  — IP strategy assessment")
elif cmd in commands:
    commands[cmd]()
else:
    print("Unknown: {}".format(cmd))
print("")
print("Powered by BytesAgain | bytesagain.com")
print("Note: Consult an IP attorney for specific legal advice.")
PYEOF
}
run_python "$CMD" $INPUT
