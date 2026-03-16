#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
if cmd=="plan":
    role=inp if inp else "Key Role"
    print("=" * 55)
    print("  Succession Plan: {}".format(role))
    print("=" * 55)
    for section in [("Current Holder","Name: ___  Tenure: ___  Retirement/departure: ___"),("Critical Knowledge","1. ___\n  2. ___\n  3. ___"),("Successor Candidates","Primary: ___ (Readiness: Now/6mo/1yr)\n  Secondary: ___ (Readiness: ___)\n  External: Consider if needed"),("Development Plan","1. Mentoring with current holder\n  2. Stretch assignments\n  3. Training courses\n  4. Cross-functional exposure"),("Transition Timeline","Month 1: Shadow and observe\n  Month 2-3: Co-lead responsibilities\n  Month 4-6: Lead with support\n  Month 7+: Fully independent")]:
        print("\n  {}:".format(section[0]))
        for line in section[1].split("\n"): print("    {}".format(line.strip()))
elif cmd=="matrix":
    print("  9-Box Talent Matrix:")
    print("  Performance ->")
    print("              Low         Med          High")
    print("  High   | Enigma     | Growth Star | Future Leader |")
    print("  Med    | Underperf  | Core Player | High Potential|")
    print("  Low    | Risk       | Average     | Specialist    |")
    print("  ^ Potential")
elif cmd=="help":
    print("Succession Planner\n  plan [role]   — Succession plan template\n  matrix         — 9-Box talent matrix")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT