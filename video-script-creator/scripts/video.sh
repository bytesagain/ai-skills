#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
if cmd=="outline":
    topic=inp if inp else "My Video"
    print("=" * 50)
    print("  Video Script: {}".format(topic))
    print("=" * 50)
    sections=[("Hook (0:00-0:15)","Grab attention immediately.\n  Question, bold statement, or surprising fact."),("Intro (0:15-0:30)","Brief intro + what viewer will learn.\n  Like, subscribe CTA."),("Point 1 (0:30-2:00)","First main point with example."),("Point 2 (2:00-3:30)","Second main point with example."),("Point 3 (3:30-5:00)","Third main point with example."),("Summary (5:00-5:30)","Recap key takeaways."),("CTA (5:30-6:00)","Like, comment, subscribe. Next video teaser.")]
    for title,desc in sections:
        print("\n  {}".format(title))
        for line in desc.split("\n"): print("    {}".format(line.strip()))
elif cmd=="hook":
    hooks=["Did you know that [surprising stat]?","Stop doing [common mistake] right now.","In the next 5 minutes, you will learn [promise].","I tested [thing] for 30 days. Here is what happened.","Most people get [topic] completely wrong.","This one trick changed everything for me."]
    print("  Video Hook Templates:")
    for h in hooks: print("    - {}".format(h))
elif cmd=="thumbnail":
    print("  YouTube Thumbnail Checklist:")
    for tip in ["Face with emotion (surprise/excitement)","3-4 words MAX in large text","Contrasting colors (yellow/red on dark)","Rule of thirds composition","1280x720 minimum resolution","No clickbait (match content!)","Test at small size (mobile preview)"]:
        print("    - {}".format(tip))
elif cmd=="help":
    print("Video Script Creator\n  outline [topic]  — Full video script outline\n  hook              — Opening hook templates\n  thumbnail         — Thumbnail design tips")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT