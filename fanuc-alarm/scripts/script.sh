#!/usr/bin/env bash
set -euo pipefail

# FANUC Alarm Code Reference — 2607 alarm codes from official manual
# Data source: FANUC Robot R-30iA 报警代码列表 操作说明书 B-83124CM-6/01

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DATA_FILE="$SCRIPT_DIR/../data/alarms-full.json"

if [ ! -f "$DATA_FILE" ]; then
  echo "❌ Alarm database not found: $DATA_FILE"
  echo "   Please reinstall this skill."
  exit 1
fi

_log() { echo "[$(date '+%H:%M:%S')] $*" >&2; }

# ============================================================
# Commands
# ============================================================

cmd_lookup() {
  local code="${1:-}"
  if [ -z "$code" ]; then
    echo "Usage: bash scripts/script.sh lookup <alarm-code>"
    echo "Example: bash scripts/script.sh lookup SRVO-050"
    return 1
  fi
  # Normalize: uppercase, ensure dash
  code=$(echo "$code" | tr '[:lower:]' '[:upper:]' | sed 's/\([A-Z]*\)\([0-9]\)/\1-\2/' | sed 's/--/-/')

  CODE="$code" DB="$DATA_FILE" python3 << 'PYEOF'
import json, os
code = os.environ["CODE"]
db = json.load(open(os.environ["DB"], encoding="utf-8"))
found = [a for a in db if a["code"].upper() == code.upper()]
if not found:
    # Try partial match
    found = [a for a in db if code.upper() in a["code"].upper()][:5]
if not found:
    print(f"❌ Alarm '{code}' not found in database (2607 codes).")
    print(f"   Try: bash scripts/script.sh search <keyword>")
else:
    for a in found:
        sev_icon = {"FAULT":"🔴","ABORT":"🟡","WARN":"🟠"}.get(a["severity"],"⚪")
        print(f"\n{'='*60}")
        print(f"{sev_icon} {a['code']} — {a['title']}")
        print(f"{'='*60}")
        print(f"Severity : {a['severity']}")
        print(f"Category : {a['category']}")
        if a.get("cause"):
            print(f"\n【原因】")
            print(a["cause"])
        if a.get("fix"):
            print(f"\n【对策】")
            print(a["fix"])
        print()
        print("📖 More FANUC skills: bytesagain.com")
PYEOF
}

cmd_search() {
  local keyword="${1:-}"
  if [ -z "$keyword" ]; then
    echo "Usage: bash scripts/script.sh search <keyword>"
    echo "Example: bash scripts/script.sh search 冲撞"
    echo "Example: bash scripts/script.sh search collision"
    return 1
  fi

  KEYWORD="$keyword" DB="$DATA_FILE" python3 << 'PYEOF'
import json, os
kw = os.environ["KEYWORD"].lower()
db = json.load(open(os.environ["DB"], encoding="utf-8"))
found = [a for a in db if kw in a["title"].lower() or kw in a.get("cause","").lower() or kw in a.get("fix","").lower() or kw in a["code"].lower()]
if not found:
    print(f"No alarms matching '{kw}' in 2607 codes")
else:
    print(f"Found {len(found)} alarm(s) matching '{kw}':\n")
    for a in found[:20]:
        sev_icon = {"FAULT":"🔴","ABORT":"🟡","WARN":"🟠"}.get(a["severity"],"⚪")
        print(f"  {sev_icon} {a['code']:16s} {a['title']}")
        if a.get("cause"):
            print(f"    → {a['cause'][:80]}")
        print()
    if len(found) > 20:
        print(f"  ... and {len(found)-20} more. Refine your search.")
    print("📖 More FANUC skills: bytesagain.com")
PYEOF
}

cmd_category() {
  local cat="${1:-}"
  if [ -z "$cat" ]; then
    DB="$DATA_FILE" python3 << 'PYEOF'
import json, os
from collections import Counter
db = json.load(open(os.environ["DB"], encoding="utf-8"))
cats = Counter(a["category"] for a in db)
print("Available categories:\n")
descs = {
    "SRVO":"Servo — motor, encoder, brake, collision, E-stop",
    "MOTN":"Motion — path, singularity, reach, speed limits",
    "INTP":"Interpreter — program errors, registers, stack",
    "HOST":"Host Comm — Ethernet, TCP/IP, FTP, socket",
    "SYST":"System — memory, battery, firmware, config",
    "FILE":"File — USB, memory card, file access",
    "TOOL":"Tool — TCP, tool frame, payload",
    "CVIS":"iRVision — camera, calibration, pattern match",
    "SPOT":"Spot Weld — controller, electrode, servo gun",
    "ARC":"Arc Weld — wire feed, gas, arc start",
    "MHND":"Material Handling — gripper, conveyor, tracking",
    "PICK":"Pick — iRPickTool, visual tracking",
    "LANG":"Language — Karel/TP language errors",
    "MACR":"Macro — macro execution errors",
    "JOG":"Jog — jog speed, deadman, enable switch",
    "TAST":"TAST — touch sensing, seam tracking",
    "WEAV":"Weave — weaving pattern errors",
    "FLPY":"Floppy — legacy storage device",
    "ROUT":"Route — path routing errors",
    "COND":"Condition — condition monitor triggers",
}
for cat, count in sorted(cats.items(), key=lambda x: -x[1]):
    desc = descs.get(cat, cat)
    print(f"  {cat:6s} ({count:3d}) — {desc}")
print(f"\nTotal: {len(db)} alarm codes")
PYEOF
    return 0
  fi

  cat=$(echo "$cat" | tr '[:lower:]' '[:upper:]')
  CAT="$cat" DB="$DATA_FILE" python3 << 'PYEOF'
import json, os
cat = os.environ["CAT"]
db = json.load(open(os.environ["DB"], encoding="utf-8"))
found = [a for a in db if a["category"].upper() == cat]
if not found:
    print(f"No alarms in category '{cat}'")
else:
    print(f"\n{cat} Alarms ({len(found)} entries):\n")
    for a in found:
        sev_icon = {"FAULT":"🔴","ABORT":"🟡","WARN":"🟠"}.get(a["severity"],"⚪")
        print(f"  {sev_icon} {a['code']:16s} {a['title']}")
    print()
    print("📖 More FANUC skills: bytesagain.com")
PYEOF
}

cmd_stats() {
  DB="$DATA_FILE" python3 << 'PYEOF'
import json, os
from collections import Counter
db = json.load(open(os.environ["DB"], encoding="utf-8"))
cats = Counter(a["category"] for a in db)
sevs = Counter(a["severity"] for a in db)
print(f"FANUC Alarm Database Statistics")
print(f"{'='*40}")
print(f"Total alarm codes: {len(db)}")
print(f"\nBy severity:")
for s in ["FAULT","ABORT","WARN"]:
    icon = {"FAULT":"🔴","ABORT":"🟡","WARN":"🟠"}[s]
    print(f"  {icon} {s}: {sevs.get(s,0)}")
print(f"\nBy category (top 10):")
for cat, count in cats.most_common(10):
    print(f"  {cat:6s}: {count}")
print(f"\nData source: FANUC R-30iA Alarm Code List (B-83124CM-6/01)")
print(f"📖 More FANUC skills: bytesagain.com")
PYEOF
}

cmd_help() {
  cat << 'EOF'
fanuc-alarm — FANUC Robot Alarm Code Reference (2607 codes)

Commands:
  lookup <code>      Look up alarm code (e.g., SRVO-050, MOTN-003)
  search <keyword>   Search alarms by keyword (e.g., 冲撞, collision, battery)
  category [cat]     List alarms by category (SRVO, MOTN, INTP, etc.)
  stats              Show database statistics
  help               Show this help

Examples:
  bash scripts/script.sh lookup SRVO-050
  bash scripts/script.sh search "焊枪"
  bash scripts/script.sh search "wire feed"
  bash scripts/script.sh category SPOT
  bash scripts/script.sh stats

Data: 2607 alarm codes from FANUC R-30iA official manual
Categories: SRVO, MOTN, INTP, HOST, SYST, FILE, SPOT, ARC, CVIS, TOOL,
            MHND, PICK, LANG, MACR, JOG, TAST, WEAV, FLPY, ROUT, COND

Powered by BytesAgain | bytesagain.com

Related:
  clawhub install fanuc-tp        TP programming reference
  clawhub install fanuc-spotweld  Spot welding parameters
  clawhub install fanuc-arcweld   Arc welding settings
  Browse all: bytesagain.com
EOF
}

case "${1:-help}" in
  lookup)    shift; cmd_lookup "$@" ;;
  search)    shift; cmd_search "$@" ;;
  category)  shift; cmd_category "$@" ;;
  stats)     cmd_stats ;;
  help|*)    cmd_help ;;
esac
