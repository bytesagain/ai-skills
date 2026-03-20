#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# meditation/scripts/script.sh — Meditation practice tool.
# Timer, breathing guide, body scan, session logger, stats, and playlists.
###############################################################################

DATA_DIR="${HOME}/.meditation"
SESSIONS_FILE="${DATA_DIR}/sessions.json"

ensure_data_dir() {
  mkdir -p "${DATA_DIR}"
  if [[ ! -f "${SESSIONS_FILE}" ]]; then
    echo '[]' > "${SESSIONS_FILE}"
  fi
}

# ─── start ───────────────────────────────────────────────────────────────────

cmd_start() {
  local duration=10 bell=0 session_type="focus"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --duration) duration="$2"; shift 2 ;;
      --bell)     bell="$2"; shift 2 ;;
      --type)     session_type="$2"; shift 2 ;;
      -*)         echo "Unknown flag: $1" >&2; return 1 ;;
      *)          shift ;;
    esac
  done

  local total_seconds=$(( duration * 60 ))

  echo "=== Meditation Session ==="
  echo "Type: ${session_type} | Duration: ${duration} minutes"
  if [[ ${bell} -gt 0 ]]; then
    echo "Bell interval: every ${bell} minutes"
  fi
  echo ""

  # Opening guidance based on type
  case "${session_type}" in
    focus)
      echo "Find a comfortable position. Close your eyes."
      echo "Bring your attention to your breath."
      echo "When your mind wanders, gently return to the breath."
      ;;
    open)
      echo "Sit comfortably with an open, relaxed awareness."
      echo "Notice sounds, sensations, and thoughts as they arise."
      echo "Let everything come and go without attachment."
      ;;
    loving-kindness)
      echo "Sit comfortably and bring to mind someone you care about."
      echo "Silently repeat: May you be happy. May you be healthy."
      echo "May you be safe. May you live with ease."
      ;;
  esac

  echo ""
  echo "🔔 Session started at $(date +%H:%M:%S)"
  echo ""

  local elapsed=0
  local bell_seconds=$(( bell * 60 ))
  local next_bell=${bell_seconds}

  while [[ ${elapsed} -lt ${total_seconds} ]]; do
    sleep 1
    elapsed=$(( elapsed + 1 ))

    # Show progress every minute
    if [[ $(( elapsed % 60 )) -eq 0 ]]; then
      local minutes_passed=$(( elapsed / 60 ))
      local minutes_left=$(( duration - minutes_passed ))
      echo "  ⏱  ${minutes_passed}/${duration} min (${minutes_left} remaining)"
    fi

    # Bell at intervals
    if [[ ${bell_seconds} -gt 0 && ${elapsed} -ge ${next_bell} && ${elapsed} -lt ${total_seconds} ]]; then
      echo "  🔔 Bell — ${next_bell} seconds"
      next_bell=$(( next_bell + bell_seconds ))
    fi
  done

  echo ""
  echo "🔔🔔🔔 Session complete! ${duration} minutes of ${session_type} meditation."
  echo ""
  echo "Take a moment before opening your eyes."
  echo ""

  # Auto-log the session
  ensure_data_dir
  local session_date
  session_date=$(date +%Y-%m-%dT%H:%M:%S)

  SESSIONS_FILE="$SESSIONS_FILE" SESSION_DATE="$session_date" \
  DURATION="$duration" SESSION_TYPE="$session_type" python3 << 'PYEOF'
import json, os

sessions_file = os.environ["SESSIONS_FILE"]
session_date = os.environ["SESSION_DATE"]
duration = int(os.environ["DURATION"])
session_type = os.environ["SESSION_TYPE"]

sessions = json.load(open(sessions_file))
sessions.append({
    'date': session_date,
    'duration_min': duration,
    'type': session_type,
    'mood': None,
    'note': 'auto-logged from timer'
})
json.dump(sessions, open(sessions_file, 'w'), indent=2)
PYEOF
  echo "Session auto-logged. Use 'script.sh stats' to see your history."
}

# ─── breathe ─────────────────────────────────────────────────────────────────

cmd_breathe() {
  local pattern="4-7-8" cycles=4

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --pattern) pattern="$2"; shift 2 ;;
      --cycles)  cycles="$2"; shift 2 ;;
      -*)        echo "Unknown flag: $1" >&2; return 1 ;;
      *)         shift ;;
    esac
  done

  local inhale=4 hold=7 exhale=8

  case "${pattern}" in
    4-7-8)
      inhale=4; hold=7; exhale=8
      echo "=== 4-7-8 Breathing ==="
      echo "Relaxation technique. Inhale 4s, hold 7s, exhale 8s."
      ;;
    box)
      inhale=4; hold=4; exhale=4
      echo "=== Box Breathing ==="
      echo "Equal-phase breathing. Inhale 4s, hold 4s, exhale 4s, hold 4s."
      ;;
    deep)
      inhale=5; hold=2; exhale=7
      echo "=== Deep Breathing ==="
      echo "Slow deep breaths. Inhale 5s, hold 2s, exhale 7s."
      ;;
    *)
      echo "Unknown pattern: ${pattern}. Use 4-7-8, box, or deep." >&2
      return 1
      ;;
  esac

  echo "Cycles: ${cycles}"
  echo ""
  echo "Get comfortable. Let's begin."
  echo ""

  for (( c=1; c<=cycles; c++ )); do
    echo "--- Cycle ${c}/${cycles} ---"

    echo -n "  INHALE  "
    for (( s=1; s<=inhale; s++ )); do
      echo -n "▓"
      sleep 1
    done
    echo " (${inhale}s)"

    echo -n "  HOLD    "
    for (( s=1; s<=hold; s++ )); do
      echo -n "░"
      sleep 1
    done
    echo " (${hold}s)"

    echo -n "  EXHALE  "
    for (( s=1; s<=exhale; s++ )); do
      echo -n "▒"
      sleep 1
    done
    echo " (${exhale}s)"

    if [[ "${pattern}" == "box" ]]; then
      echo -n "  HOLD    "
      for (( s=1; s<=hold; s++ )); do
        echo -n "░"
        sleep 1
      done
      echo " (${hold}s)"
    fi

    echo ""
  done

  echo "Breathing exercise complete. ${cycles} cycles of ${pattern}."
}

# ─── body-scan ───────────────────────────────────────────────────────────────

cmd_body_scan() {
  local duration="medium" focus="full"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --duration) duration="$2"; shift 2 ;;
      --focus)    focus="$2"; shift 2 ;;
      -*)         echo "Unknown flag: $1" >&2; return 1 ;;
      *)          shift ;;
    esac
  done

  echo "=== Body Scan Meditation ==="
  echo "Duration: ${duration} | Focus: ${focus}"
  echo ""
  echo "Lie down or sit comfortably. Close your eyes."
  echo "Take three deep breaths to settle in."
  echo ""

  local pause_seconds
  case "${duration}" in
    short)  pause_seconds=3 ;;
    medium) pause_seconds=5 ;;
    long)   pause_seconds=8 ;;
    *)      pause_seconds=5 ;;
  esac

  local -a regions_full=("feet" "ankles" "calves" "knees" "thighs" "hips" "lower back" "abdomen" "chest" "upper back" "shoulders" "arms" "hands" "neck" "jaw" "face" "forehead" "crown of head")
  local -a regions_upper=("abdomen" "chest" "upper back" "shoulders" "arms" "hands" "neck" "jaw" "face" "forehead" "crown of head")
  local -a regions_lower=("feet" "ankles" "calves" "knees" "thighs" "hips" "lower back" "abdomen")

  local -a regions
  case "${focus}" in
    full)  regions=("${regions_full[@]}") ;;
    upper) regions=("${regions_upper[@]}") ;;
    lower) regions=("${regions_lower[@]}") ;;
    *)     regions=("${regions_full[@]}") ;;
  esac

  for region in "${regions[@]}"; do
    echo "→ Bring your attention to your ${region}."
    echo "  Notice any sensations — tension, warmth, tingling."
    echo "  Breathe into this area. Let any tension release."
    sleep ${pause_seconds}
    echo ""
  done

  echo "Now expand your awareness to your whole body."
  echo "Feel the wholeness. Breathe naturally."
  sleep $(( pause_seconds * 2 ))
  echo ""
  echo "Body scan complete. Take your time coming back."
  echo ""
  echo "Scanned ${#regions[@]} regions (${focus} body, ${duration} pace)."
}

# ─── log ─────────────────────────────────────────────────────────────────────

cmd_log() {
  ensure_data_dir
  local duration_min="" session_type="general" mood="" note=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --type) session_type="$2"; shift 2 ;;
      --mood) mood="$2"; shift 2 ;;
      --note) note="$2"; shift 2 ;;
      -*)     echo "Unknown flag: $1" >&2; return 1 ;;
      *)      duration_min="$1"; shift ;;
    esac
  done

  if [[ -z "${duration_min}" ]]; then
    echo "Usage: script.sh log <duration_min> [--type TYPE] [--mood 1-10] [--note TEXT]" >&2
    return 1
  fi

  local session_date
  session_date=$(date +%Y-%m-%dT%H:%M:%S)

  SESSIONS_FILE="$SESSIONS_FILE" SESSION_DATE="$session_date" \
  DURATION_MIN="$duration_min" SESSION_TYPE="$session_type" \
  MOOD="$mood" NOTE="$note" python3 << 'PYEOF'
import json, os

sessions_file = os.environ["SESSIONS_FILE"]
session_date = os.environ["SESSION_DATE"]
duration_min = int(os.environ["DURATION_MIN"])
session_type = os.environ["SESSION_TYPE"]
mood_val = os.environ["MOOD"]
note = os.environ["NOTE"]

sessions = json.load(open(sessions_file))

mood_int = int(mood_val) if mood_val else None

sessions.append({
    'date': session_date,
    'duration_min': duration_min,
    'type': session_type,
    'mood': mood_int,
    'note': note
})

json.dump(sessions, open(sessions_file, 'w'), indent=2)

print('Session logged:')
print(f'  Date:     {session_date}')
print(f'  Duration: {duration_min} min')
print(f'  Type:     {session_type}')
if mood_int:
    print(f'  Mood:     {mood_int}/10')
if note:
    print(f'  Note:     {note}')
PYEOF
}

# ─── stats ───────────────────────────────────────────────────────────────────

cmd_stats() {
  ensure_data_dir
  local period="all" format="table"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --period) period="$2"; shift 2 ;;
      --format) format="$2"; shift 2 ;;
      -*)       echo "Unknown flag: $1" >&2; return 1 ;;
      *)        shift ;;
    esac
  done

  SESSIONS_FILE="$SESSIONS_FILE" PERIOD="$period" FORMAT="$format" python3 << 'PYEOF'
import json, os
from datetime import datetime, timedelta

sessions_file = os.environ["SESSIONS_FILE"]
period = os.environ["PERIOD"]
fmt = os.environ["FORMAT"]

sessions = json.load(open(sessions_file))

# Filter by period
now = datetime.now()
period_map = {
    'week':  timedelta(weeks=1),
    'month': timedelta(days=30),
    'year':  timedelta(days=365),
}

if period in period_map:
    cutoff = now - period_map[period]
    filtered = []
    for s in sessions:
        try:
            dt = datetime.fromisoformat(s['date'])
            if dt >= cutoff:
                filtered.append(s)
        except (ValueError, KeyError):
            filtered.append(s)
else:
    filtered = sessions

if not filtered:
    print('No meditation sessions found.')
    exit(0)

total_sessions = len(filtered)
total_minutes = sum(s.get('duration_min', 0) for s in filtered)
avg_duration = total_minutes / total_sessions if total_sessions > 0 else 0
moods = [s['mood'] for s in filtered if s.get('mood') is not None]
avg_mood = sum(moods) / len(moods) if moods else None

by_type = {}
for s in filtered:
    t = s.get('type', 'unknown')
    by_type[t] = by_type.get(t, 0) + 1

# Streak calculation
dates = set()
for s in filtered:
    try:
        dt = datetime.fromisoformat(s['date']).date()
        dates.add(dt)
    except (ValueError, KeyError):
        pass

streak = 0
if dates:
    today = now.date()
    d = today
    while d in dates:
        streak += 1
        d -= timedelta(days=1)

if fmt == 'json':
    print(json.dumps({
        'period': period,
        'total_sessions': total_sessions,
        'total_minutes': total_minutes,
        'avg_duration_min': round(avg_duration, 1),
        'avg_mood': round(avg_mood, 1) if avg_mood else None,
        'current_streak_days': streak,
        'by_type': by_type
    }, indent=2))
else:
    print(f'=== Meditation Stats ({period}) ===')
    print(f'Total sessions:   {total_sessions}')
    print(f'Total time:       {total_minutes} min ({total_minutes / 60:.1f} hours)')
    print(f'Avg duration:     {avg_duration:.1f} min')
    if avg_mood:
        print(f'Avg mood:         {avg_mood:.1f}/10')
    print(f'Current streak:   {streak} day(s)')
    print()
    print('By Type:')
    for t, count in sorted(by_type.items(), key=lambda x: -x[1]):
        pct = count / total_sessions * 100
        bar = '█' * int(pct / 2)
        print(f'  {t:<18} {count:>4}  ({pct:>5.1f}%)  {bar}')
PYEOF
}

# ─── playlist ────────────────────────────────────────────────────────────────

cmd_playlist() {
  local mood="calm" duration=30 count=5

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --mood)     mood="$2"; shift 2 ;;
      --duration) duration="$2"; shift 2 ;;
      --count)    count="$2"; shift 2 ;;
      -*)         echo "Unknown flag: $1" >&2; return 1 ;;
      *)          shift ;;
    esac
  done

  echo "=== Meditation Playlist ==="
  echo "Mood: ${mood} | Target: ${duration} min | Tracks: ${count}"
  echo ""

  MOOD="$mood" DURATION="$duration" COUNT="$count" python3 << 'PYEOF'
import random, os

mood = os.environ["MOOD"]
duration = int(os.environ["DURATION"])
count = int(os.environ["COUNT"])

tracks = {
    'calm': [
        'Rain on Leaves',
        'Ocean Waves',
        'Forest Stream',
        'Wind Through Pines',
        'Gentle Bells',
        'Singing Bowls',
        'Soft Piano Ambience',
        'Mountain Silence',
        'Lakeside Morning',
        'Night Cricket Song',
    ],
    'sleep': [
        'Deep Sleep Drone',
        'Delta Wave Tones',
        'White Noise Blanket',
        'Slow Heartbeat',
        'Rain on Roof',
        'Night Ocean',
        'Lullaby Hum',
        'Fireplace Crackle',
        'Distant Thunder',
        'Starlight Ambience',
    ],
    'focus': [
        'Brown Noise',
        'Binaural Beats 40Hz',
        'Coffee Shop Ambience',
        'Steady Rain',
        'Tibetan Bowls',
        'Alpha Wave Drone',
        'Library Silence',
        'Wind Chimes',
        'Flowing River',
        'Cathedral Echo',
    ],
    'energy': [
        'Morning Sun Rising',
        'Drum Circle',
        'Upbeat Nature Sounds',
        'Waterfall Power',
        'Breath of Fire Rhythm',
        'Sunrise Chimes',
        'Fast Flowing Stream',
        'Tropical Birds',
        'Mountain Wind',
        'Thunder Awakening',
    ],
}

pool = tracks.get(mood, tracks['calm'])
selected = random.sample(pool, min(count, len(pool)))

# Distribute duration across tracks
track_minutes = duration / len(selected)

total = 0
for i, track in enumerate(selected, 1):
    mins = round(track_minutes + random.uniform(-1, 1), 1)
    if mins < 1:
        mins = 1.0
    total += mins
    print(f'  {i}. {track} ({mins:.1f} min)')

print()
print(f'Total playlist: {total:.1f} min | Mood: {mood}')
print()
print('Note: These are suggested ambient sound categories.')
print('Search for these on your preferred music/sound platform.')
PYEOF
}

# ─── help ────────────────────────────────────────────────────────────────────

cmd_help() {
  cat <<'EOF'
meditation — Meditation practice tool.

Commands:
  start      Start a meditation timer with optional bell intervals
  breathe    Run a guided breathing exercise (4-7-8, box, deep)
  body-scan  Generate a body scan meditation guide
  log        Record a meditation session to the journal
  stats      View meditation practice statistics
  playlist   Generate a meditation audio playlist
  help       Show this help message

Examples:
  script.sh start --duration 15 --bell 5 --type focus
  script.sh breathe --pattern box --cycles 6
  script.sh body-scan --duration long --focus upper
  script.sh log 20 --type focus --mood 8 --note "felt calm"
  script.sh stats --period month
  script.sh playlist --mood sleep --duration 45 --count 8
EOF
}

# ─── main dispatch ───────────────────────────────────────────────────────────

main() {
  if [[ $# -lt 1 ]]; then
    cmd_help
    exit 1
  fi

  local command="$1"
  shift

  case "${command}" in
    start)     cmd_start "$@" ;;
    breathe)   cmd_breathe "$@" ;;
    body-scan) cmd_body_scan "$@" ;;
    log)       cmd_log "$@" ;;
    stats)     cmd_stats "$@" ;;
    playlist)  cmd_playlist "$@" ;;
    help|--help|-h) cmd_help ;;
    *)
      echo "Unknown command: ${command}" >&2
      echo "Run 'script.sh help' for usage." >&2
      exit 1
      ;;
  esac
}

main "$@"
