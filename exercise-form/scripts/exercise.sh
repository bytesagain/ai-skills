#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
DB={"push-up":{"muscles":"Chest, Triceps, Shoulders","reps":"3x15","form":["Hands shoulder-width apart","Body straight line","Lower until chest near floor","Push up explosively"]},"squat":{"muscles":"Quads, Glutes, Hamstrings","reps":"3x20","form":["Feet shoulder-width","Knees track over toes","Thighs parallel to floor","Back straight, chest up"]},"plank":{"muscles":"Core, Shoulders, Back","reps":"3x60s","form":["Forearms on ground","Body straight line","Engage core tight","Do not sag hips"]},"deadlift":{"muscles":"Back, Glutes, Hamstrings","reps":"3x8","form":["Feet hip-width","Bar over mid-foot","Hinge at hips","Keep back neutral"]},"lunge":{"muscles":"Quads, Glutes, Balance","reps":"3x12/leg","form":["Step forward","Both knees 90 degrees","Front knee over ankle","Push back to start"]}}
if cmd=="lookup":
    ex=inp.lower().strip() if inp else ""
    if ex in DB:
        e=DB[ex]
        print("  {} — {}".format(ex.upper(),e["muscles"]))
        print("  Recommended: {}".format(e["reps"]))
        print("  Form:")
        for f in e["form"]: print("    - {}".format(f))
    else:
        print("  Available: {}".format(", ".join(DB.keys())))
elif cmd=="plan":
    level=inp.lower() if inp else "beginner"
    plans={"beginner":[("Mon","Push-ups 3x10, Squats 3x15, Plank 3x30s"),("Wed","Lunges 3x10, Push-ups 3x10, Plank 3x30s"),("Fri","Squats 3x15, Push-ups 3x12, Plank 3x45s")],"intermediate":[("Mon","Push-ups 4x15, Squats 4x20, Plank 3x60s, Lunges 3x12"),("Wed","Deadlifts 3x8, Push-ups 4x15, Plank 3x60s"),("Fri","Squats 4x20, Lunges 3x15, Push-ups 4x20, Plank 3x90s")]}
    p=plans.get(level,plans["beginner"])
    print("  {} Plan:".format(level.title()))
    for day,workout in p: print("  {:5s} {}".format(day,workout))
elif cmd=="muscle":
    groups={"chest":"push-up, bench press, dips","back":"deadlift, rows, pull-ups","legs":"squat, lunge, calf raise","core":"plank, crunches, leg raise","arms":"curls, tricep dips, push-ups","shoulders":"overhead press, lateral raise"}
    if inp and inp.lower() in groups:
        print("  {}: {}".format(inp.upper(), groups[inp.lower()]))
    else:
        for g,ex in groups.items(): print("  {:10s} {}".format(g.upper(),ex))
elif cmd=="help":
    print("Exercise Form Guide\n  lookup <exercise>  — Form guide (push-up/squat/plank/deadlift/lunge)\n  plan [level]       — Weekly plan (beginner/intermediate)\n  muscle [group]     — Exercises by muscle group")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT