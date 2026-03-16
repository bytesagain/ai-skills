#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys,hashlib
from datetime import datetime
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
MOODS={"focus":["Lofi beats","Ambient electronic","Classical piano","Jazz instrumentals","Nature sounds"],"workout":["EDM/Dance","Hip hop","Rock","Drum and bass","Power metal"],"relax":["Acoustic indie","Bossa nova","Ambient","New age","Soft jazz"],"party":["Pop hits","Dance/EDM","Reggaeton","Funk","Disco"],"sad":["Singer-songwriter","Indie folk","Blues","Classical","Slow R&B"],"morning":["Acoustic pop","Indie folk","Jazz","Lofi","Classical guitar"]}
if cmd=="mood":
    mood=inp.lower().strip() if inp else "focus"
    genres=MOODS.get(mood,MOODS["focus"])
    print("  {} Playlist Genres:".format(mood.title()))
    for g in genres: print("    - {}".format(g))
    print("\n  Suggested playlist length:")
    print("    Focus: 2-4 hours")
    print("    Workout: 45-90 min")
    print("    Other: 1-2 hours")
elif cmd=="structure":
    length=int(inp) if inp and inp.isdigit() else 20
    print("  Playlist Structure ({} songs):".format(length))
    phases=[("Opening (20%)",int(length*0.2),"Medium energy, set the vibe"),("Build (30%)",int(length*0.3),"Increasing energy"),("Peak (30%)",int(length*0.3),"Highest energy songs"),("Cool down (20%)",int(length*0.2),"Gradual decrease")]
    for name,count,desc in phases:
        print("    {:20s} {} songs — {}".format(name,count,desc))
elif cmd=="discover":
    sources=["Spotify Discover Weekly","YouTube Music Mix","Last.fm similar artists","Rate Your Music charts","Bandcamp daily","Reddit r/listentothis","Pitchfork reviews","Album of the Year"]
    print("  Music Discovery Sources:")
    for s in sources: print("    - {}".format(s))
elif cmd=="help":
    print("Music Playlist\n  mood [type]       — Genre suggestions (focus/workout/relax/party/sad/morning)\n  structure [count] — Playlist pacing guide\n  discover          — Discovery sources")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT