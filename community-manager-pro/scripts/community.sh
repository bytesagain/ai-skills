#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys
cmd = sys.argv[1] if len(sys.argv)>1 else "help"
inp = " ".join(sys.argv[2:])
if cmd=="welcome":
    name=inp if inp else "new member"
    print("Welcome Message Templates for {}:".format(name))
    for t in ["Hey {}! Welcome to our community. Introduce yourself!".format(name),"Welcome aboard, {}! Check out #rules and #introductions.".format(name),"Glad to have you, {}! Here are 3 things to do first:\n  1. Read the rules\n  2. Introduce yourself\n  3. Ask questions!".format(name)]:
        print("\n  > {}".format(t))
elif cmd=="rules":
    rules=["Be respectful and inclusive","No spam or self-promotion without permission","Stay on topic in channels","No NSFW content","Use search before asking","Help others when you can","Report issues to moderators","English only in main channels"]
    print("  Community Rules Template:")
    for i,r in enumerate(rules,1): print("  {}. {}".format(i,r))
elif cmd=="engagement":
    ideas=["Weekly AMA sessions","Member spotlight/shoutouts","Polls and surveys","Content challenges","Feedback Fridays","New member onboarding","Monthly community report","Gamification (roles/badges)"]
    print("  Engagement Ideas:")
    for i in ideas: print("    - {}".format(i))
elif cmd=="metrics":
    print("  Community Health Metrics:")
    for m in ["DAU/MAU ratio (target: >20%)","Messages per member per week","New member retention (30-day)","Response time to questions","Active contributor % (target: 10%+)","NPS score","Churn rate"]:
        print("    {} = ___".format(m))
elif cmd=="help":
    print("Community Manager\n  welcome [name]  — Welcome message templates\n  rules           — Community rules template\n  engagement      — Engagement ideas\n  metrics         — Health metrics dashboard")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT