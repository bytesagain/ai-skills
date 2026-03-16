#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys,json,os
from datetime import datetime
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
DATA="/tmp/medication-data.json"
def load():
    if os.path.exists(DATA):
        with open(DATA) as f: return json.load(f)
    return {"meds":[],"log":[]}
def save(d):
    with open(DATA,"w") as f: json.dump(d,f,indent=2)
if cmd=="add":
    parts=inp.split() if inp else []
    if len(parts)<2:
        print("  Usage: add <name> <dosage> [frequency]")
        print("  Example: add Aspirin 100mg daily")
    else:
        d=load()
        med={"name":parts[0],"dose":parts[1],"freq":parts[2] if len(parts)>2 else "daily","added":datetime.now().strftime("%Y-%m-%d")}
        d["meds"].append(med)
        save(d)
        print("  Added: {} {} ({})".format(med["name"],med["dose"],med["freq"]))
elif cmd=="list":
    d=load()
    if not d["meds"]:
        print("  No medications. Use: add <name> <dose> [freq]")
    else:
        print("  {:20s} {:10s} {:10s}".format("Medication","Dosage","Frequency"))
        print("  "+"-"*42)
        for m in d["meds"]:
            print("  {:20s} {:10s} {:10s}".format(m["name"],m["dose"],m["freq"]))
elif cmd=="take":
    name=inp.strip() if inp else ""
    d=load()
    found=any(m["name"].lower()==name.lower() for m in d["meds"])
    if found:
        d["log"].append({"med":name,"time":datetime.now().strftime("%Y-%m-%d %H:%M")})
        save(d)
        print("  Logged: {} taken at {}".format(name,datetime.now().strftime("%H:%M")))
    else: print("  Not found: {}".format(name))
elif cmd=="history":
    d=load()
    for entry in d.get("log",[])[-10:]:
        print("  [{}] {}".format(entry["time"],entry["med"]))
elif cmd=="interactions":
    print("  Common Drug Interactions (ALWAYS check with pharmacist):")
    for pair,risk in [("Aspirin + Warfarin","Increased bleeding risk"),("ACE inhibitors + Potassium","Hyperkalemia risk"),("SSRIs + MAOIs","Serotonin syndrome"),("Statins + Grapefruit","Increased side effects"),("Metformin + Alcohol","Lactic acidosis risk")]:
        print("    {} — {}".format(pair,risk))
elif cmd=="help":
    print("Medication Reminder\n  add <name> <dose> [freq]  — Add medication\n  list                     — Show all medications\n  take <name>              — Log dose taken\n  history                  — Recent log\n  interactions             — Common interactions")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com\nDisclaimer: Not medical advice.")
' "$CMD" $INPUT