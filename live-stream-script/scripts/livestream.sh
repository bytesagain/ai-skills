#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
if cmd=="plan":
    topic=inp if inp else "My Live Stream"
    print("=" * 50)
    print("  Live Stream Plan: {}".format(topic))
    print("=" * 50)
    timeline=[("0:00-0:05","Opening — Greet viewers, introduce topic, ask where they are from"),("0:05-0:15","Main Content Part 1 — Core topic discussion"),("0:15-0:20","Interaction — Q&A, polls, shoutouts"),("0:20-0:35","Main Content Part 2 — Deep dive, demos"),("0:35-0:45","Interaction — Comments, giveaway, challenges"),("0:45-0:55","Main Content Part 3 — Summary, key takeaways"),("0:55-1:00","Closing — CTA, next stream preview, thanks")]
    for time,desc in timeline:
        print("  {:12s} {}".format(time,desc))
elif cmd=="hooks":
    hooks=["Let me show you something most people get wrong...","I tried this for 30 days and here is what happened...","The #1 mistake beginners make is...","Stay until the end for a special announcement!","Quick poll: option A or B? Type in chat!","This next tip alone is worth the whole stream...","I have never shared this before but..."]
    print("  Engagement Hooks:")
    for h in hooks: print("    - {}".format(h))
elif cmd=="checklist":
    for phase,items in [("Pre-Stream",["[ ] Topic and outline ready","[ ] OBS/streaming software tested","[ ] Camera and mic check","[ ] Lighting adjusted","[ ] Chat moderation rules set","[ ] Social media announcement posted"]),("During",["[ ] Welcome early viewers","[ ] Monitor chat actively","[ ] Stay on schedule","[ ] Call-to-action reminders","[ ] Engage with comments"]),("Post-Stream",["[ ] Save VOD","[ ] Clip highlights","[ ] Post recap on social","[ ] Review chat for feedback","[ ] Plan next stream"])]:
        print("  {}:".format(phase))
        for i in items: print("    {}".format(i))
        print("")
elif cmd=="help":
    print("Live Stream Script\n  plan [topic]   — 1-hour stream timeline\n  hooks          — Engagement hook library\n  checklist      — Pre/during/post checklist")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT