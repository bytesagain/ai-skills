#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
run_python() {
python3 << 'PYEOF'
import sys
cmd = sys.argv[1] if len(sys.argv) > 1 else "help"
inp = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else ""

FALLACIES = [
    {"name":"Ad Hominem","cn":"人身攻击","desc":"Attacking the person instead of the argument","example":"You cant talk about health, you smoke!"},
    {"name":"Straw Man","cn":"稻草人谬误","desc":"Misrepresenting the opponent position","example":"So you want NO regulations at all?"},
    {"name":"Appeal to Authority","cn":"诉诸权威","desc":"Using authority as proof instead of evidence","example":"Einstein believed in God, so God exists"},
    {"name":"False Dichotomy","cn":"非黑即白","desc":"Presenting only two options when more exist","example":"You either support us or you are against us"},
    {"name":"Slippery Slope","cn":"滑坡谬误","desc":"Claiming one event will lead to extreme outcomes","example":"If we allow X, next thing you know, Y and Z!"},
    {"name":"Red Herring","cn":"转移话题","desc":"Introducing irrelevant topic to divert attention","example":"Why worry about climate when there is poverty?"},
    {"name":"Circular Reasoning","cn":"循环论证","desc":"Using the conclusion as a premise","example":"The Bible is true because it says so"},
    {"name":"Hasty Generalization","cn":"以偏概全","desc":"Drawing conclusions from insufficient evidence","example":"I met two rude French people, so all French are rude"},
    {"name":"Appeal to Emotion","cn":"诉诸情感","desc":"Using emotions instead of logic","example":"Think of the children!"},
    {"name":"Bandwagon","cn":"从众谬误","desc":"Arguing something is true because many believe it","example":"Everyone is doing it, so it must be right"},
]

def cmd_argue():
    if not inp:
        print("Usage: argue <topic> <position>")
        print("Example: argue remote-work pro")
        return
    parts = inp.split()
    topic = parts[0].replace("-"," ")
    position = parts[1] if len(parts) > 1 else "pro"
    print("=" * 55)
    print("  Argument Builder: {} ({})".format(topic.title(), position.upper()))
    print("=" * 55)
    print("")
    print("  Structure (ARE model):")
    print("")
    print("  A — ASSERTION")
    print("    State your position clearly:")
    print("    [{}] is [beneficial/harmful] because ___".format(topic))
    print("")
    print("  R — REASONING")
    print("    Provide 3 supporting reasons:")
    print("    1. [Economic] ___")
    print("    2. [Social] ___")
    print("    3. [Practical] ___")
    print("")
    print("  E — EVIDENCE")
    print("    Back each reason with:")
    print("    - Statistics: ___")
    print("    - Expert opinion: ___")
    print("    - Case study: ___")
    print("")
    print("  REBUTTAL PREP:")
    print("    Anticipate opposing argument:")
    print("    - They will say: ___")
    print("    - Our response: ___")

def cmd_rebut():
    if not inp:
        print("Usage: rebut <opponent_argument>")
        return
    print("=" * 55)
    print("  Rebuttal Framework")
    print("=" * 55)
    print("")
    print("  Opponent says: {}".format(inp))
    print("")
    print("  4-Step Rebuttal:")
    print("  1. ACKNOWLEDGE: They raise a fair point that ___")
    print("  2. CHALLENGE: However, this overlooks ___")
    print("  3. COUNTER: The evidence actually shows ___")
    print("  4. IMPACT: Therefore, my argument stands because ___")
    print("")
    print("  Check for fallacies in their argument:")
    for f in FALLACIES[:5]:
        print("    [ ] {} ({})".format(f["name"], f["cn"]))

def cmd_fallacy():
    if inp:
        matches = [f for f in FALLACIES if inp.lower() in f["name"].lower() or inp in f["cn"]]
        if matches:
            for f in matches:
                print("  {} ({})".format(f["name"], f["cn"]))
                print("  {}".format(f["desc"]))
                print("  Example: {}".format(f["example"]))
                print("")
            return
    print("=" * 55)
    print("  Common Logical Fallacies")
    print("=" * 55)
    print("")
    for f in FALLACIES:
        print("  {} ({})".format(f["name"], f["cn"]))
        print("    {}".format(f["desc"]))
        print("    Ex: {}".format(f["example"]))
        print("")

def cmd_timer():
    if not inp:
        print("Usage: timer <format>")
        print("Formats: policy, lincoln-douglas, british-parliamentary")
        return
    fmt = inp.strip().lower()
    formats = {
        "policy": [("1AC",8),("CX",3),("1NC",8),("CX",3),("2AC",8),("CX",3),("2NC",8),("CX",3),("1NR",5),("1AR",5),("2NR",5),("2AR",5)],
        "lincoln-douglas": [("AC",6),("CX",3),("NC",7),("CX",3),("1AR",4),("NR",6),("2AR",3)],
        "british-parliamentary": [("PM",7),("LO",7),("DPM",7),("DLO",7),("MG",7),("MO",7),("GW",7),("OW",7)],
    }
    if fmt not in formats:
        print("Available: {}".format(", ".join(formats.keys())))
        return
    print("  {} Format:".format(fmt.replace("-"," ").title()))
    print("")
    total = 0
    for speech, mins in formats[fmt]:
        total += mins
        print("    {:5s} — {} min".format(speech, mins))
    print("    " + "-" * 20)
    print("    Total: {} min".format(total))

commands = {"argue": cmd_argue, "rebut": cmd_rebut, "fallacy": cmd_fallacy, "timer": cmd_timer}
if cmd == "help":
    print("Debate Helper")
    print("")
    print("Commands:")
    print("  argue <topic> <pro/con>  — Build structured argument")
    print("  rebut <argument>         — Rebuttal framework")
    print("  fallacy [name]           — Logical fallacy guide")
    print("  timer <format>           — Debate format timer")
elif cmd in commands:
    commands[cmd]()
else:
    print("Unknown: {}".format(cmd))
print("")
print("Powered by BytesAgain | bytesagain.com")
PYEOF
}
run_python "$CMD" $INPUT
