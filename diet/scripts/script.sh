#!/usr/bin/env bash
set -euo pipefail

######################################################################
# diet/scripts/script.sh — Meal & Nutrition Tracker
# Powered by BytesAgain | bytesagain.com
######################################################################

DATA_DIR="${HOME}/.diet"
MEALS_FILE="${DATA_DIR}/meals.json"
WATER_FILE="${DATA_DIR}/water.json"


ensure_data_dir() {
  mkdir -p "${DATA_DIR}"
  [[ -f "${MEALS_FILE}" ]] || echo '[]' > "${MEALS_FILE}"
  [[ -f "${WATER_FILE}" ]] || echo '[]' > "${WATER_FILE}"
}

today() {
  date +%Y-%m-%d
}

validate_date() {
  local d="${1:-}"
  if [[ -z "${d}" ]]; then
    echo "$(today)"
    return
  fi
  if [[ "${d}" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "${d}"
  else
    echo "Error: invalid date format '${d}'. Use YYYY-MM-DD." >&2
    exit 1
  fi
}

validate_number() {
  local val="${1:-}" label="${2:-value}"
  if [[ -z "${val}" ]] || ! [[ "${val}" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    echo "Error: ${label} must be a positive number, got '${val}'." >&2
    exit 1
  fi
}

jq_or_python() {
  # Use jq if available, otherwise fall back to python3
  if command -v jq &>/dev/null; then
    jq "$@"
  else
    local filter="$1"
    shift
    python3 << 'PYEOF'
import sys, json
data = json.load(sys.stdin)
# minimal jq-compatible subset handled via python
print(json.dumps(data, ensure_ascii=False, indent=2))
PYEOF
  fi
}

read_json() {
  cat "$1"
}

write_json() {
  local file="$1"
  local content="$2"
  printf '%s\n' "${content}" > "${file}"
}


cmd_log() {
  local food="${1:-}" cal="${2:-}" protein="${3:-}" carbs="${4:-}" fat="${5:-}" meal_type="${6:-snack}"

  if [[ -z "${food}" || -z "${cal}" || -z "${protein}" || -z "${carbs}" || -z "${fat}" ]]; then
    echo "Usage: script.sh log \"<food>\" <calories> <protein_g> <carbs_g> <fat_g> [meal_type]"
    echo "  meal_type: breakfast | lunch | dinner | snack (default: snack)"
    exit 1
  fi

  validate_number "${cal}" "calories"
  validate_number "${protein}" "protein"
  validate_number "${carbs}" "carbs"
  validate_number "${fat}" "fat"

  local valid_types="breakfast lunch dinner snack"
  if ! echo "${valid_types}" | grep -qw "${meal_type}"; then
    echo "Error: meal_type must be one of: ${valid_types}" >&2
    exit 1
  fi

  ensure_data_dir

  local timestamp
  timestamp="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  local date_str
  date_str="$(today)"

  local entry
  entry=$(DATE_STR="$date_str" TIMESTAMP="$timestamp" MEALS_FILE="$MEALS_FILE" python3 << 'PYEOF' "$food" "$cal" "$protein" "$carbs" "$fat" "$meal_type"
import json, sys, os
entry = {
    'date': os.environ['DATE_STR'],
    'timestamp': os.environ['TIMESTAMP'],
    'food': sys.argv[1],
    'calories': float(sys.argv[2]),
    'protein': float(sys.argv[3]),
    'carbs': float(sys.argv[4]),
    'fat': float(sys.argv[5]),
    'meal_type': sys.argv[6]
}
meals_file = os.environ['MEALS_FILE']
with open(meals_file, 'r') as f:
    data = json.load(f)
data.append(entry)
with open(meals_file, 'w') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)
print(json.dumps(entry, ensure_ascii=False, indent=2))
PYEOF
)

  echo "✅ Logged: ${food} (${cal} kcal, P:${protein}g C:${carbs}g F:${fat}g) [${meal_type}]"
}


cmd_calories() {
  local date_str
  date_str="$(validate_date "${1:-}")"
  ensure_data_dir

  MEALS_FILE="$MEALS_FILE" DATE_STR="$date_str" python3 << 'PYEOF'
import json, os
meals_file = os.environ['MEALS_FILE']
date_str = os.environ['DATE_STR']
with open(meals_file, 'r') as f:
    data = json.load(f)
total = sum(e['calories'] for e in data if e['date'] == date_str)
count = sum(1 for e in data if e['date'] == date_str)
print(f'📊 Calories for {date_str}')
print(f'   Entries: {count}')
print(f'   Total:   {total:.0f} kcal')
PYEOF
}


cmd_plan() {
  local target="${1:-}" days="${2:-}"

  if [[ -z "${target}" || -z "${days}" ]]; then
    echo "Usage: script.sh plan <target_calories> <days>"
    exit 1
  fi

  validate_number "${target}" "target_calories"
  validate_number "${days}" "days"

  ensure_data_dir

  MEALS_FILE="$MEALS_FILE" TARGET="$target" DAYS="$days" python3 << 'PYEOF'
import json, random, os

meals_file = os.environ['MEALS_FILE']
with open(meals_file, 'r') as f:
    data = json.load(f)

target = float(os.environ['TARGET'])
days = int(os.environ['DAYS'])

# Group foods by meal type
by_type = {}
for e in data:
    mt = e.get('meal_type', 'snack')
    by_type.setdefault(mt, []).append(e)

if not data:
    print('⚠️  No logged foods yet. Log some meals first to generate plans.')
    raise SystemExit(0)

print(f'🍽️  Meal Plan — {target:.0f} kcal/day × {days} days')
print('=' * 50)

for d in range(1, days + 1):
    print(f'\n--- Day {d} ---')
    day_cal = 0
    for meal in ['breakfast', 'lunch', 'dinner', 'snack']:
        pool = by_type.get(meal, data)
        if pool:
            pick = random.choice(pool)
            day_cal += pick['calories']
            print(f'  {meal.capitalize():10s}: {pick["food"]} ({pick["calories"]:.0f} kcal)')
    print(f'  {"Total":>10s}: {day_cal:.0f} kcal (target: {target:.0f})')
PYEOF
}


cmd_macros() {
  local date_str
  date_str="$(validate_date "${1:-}")"
  ensure_data_dir

  MEALS_FILE="$MEALS_FILE" DATE_STR="$date_str" python3 << 'PYEOF'
import json, os
meals_file = os.environ['MEALS_FILE']
date_str = os.environ['DATE_STR']
with open(meals_file, 'r') as f:
    data = json.load(f)

entries = [e for e in data if e['date'] == date_str]
if not entries:
    print(f'No entries for {date_str}.')
    raise SystemExit(0)

protein = sum(e['protein'] for e in entries)
carbs = sum(e['carbs'] for e in entries)
fat = sum(e['fat'] for e in entries)
total_g = protein + carbs + fat

print(f'🥩 Macros for {date_str}')
print(f'   Protein: {protein:>7.1f}g  ({(protein/total_g*100) if total_g else 0:>5.1f}%)')
print(f'   Carbs:   {carbs:>7.1f}g  ({(carbs/total_g*100) if total_g else 0:>5.1f}%)')
print(f'   Fat:     {fat:>7.1f}g  ({(fat/total_g*100) if total_g else 0:>5.1f}%)')
print(f'   Total:   {total_g:>7.1f}g')
cal_from_macros = protein * 4 + carbs * 4 + fat * 9
print(f'   Est kcal: {cal_from_macros:.0f} (P×4 + C×4 + F×9)')
PYEOF
}


cmd_water() {
  local ml="${1:-}" date_str
  if [[ -z "${ml}" ]]; then
    echo "Usage: script.sh water <ml> [YYYY-MM-DD]"
    exit 1
  fi
  validate_number "${ml}" "ml"
  date_str="$(validate_date "${2:-}")"
  ensure_data_dir

  WATER_FILE="$WATER_FILE" DATE_STR="$date_str" ML="$ml" python3 << 'PYEOF'
import json, os
water_file = os.environ['WATER_FILE']
date_str = os.environ['DATE_STR']
ml = os.environ['ML']
with open(water_file, 'r') as f:
    data = json.load(f)
data.append({'date': date_str, 'ml': float(ml)})
with open(water_file, 'w') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)
total = sum(e['ml'] for e in data if e['date'] == date_str)
print(f'💧 Logged {ml} ml for {date_str}')
print(f'   Daily total: {total:.0f} ml')
goal = 2000
remaining = max(0, goal - total)
print(f'   Goal: {goal} ml | Remaining: {remaining:.0f} ml')
PYEOF
}


cmd_report() {
  local mode="${1:-daily}" date_str
  date_str="$(validate_date "${2:-}")"
  ensure_data_dir

  if [[ "${mode}" == "daily" ]]; then
    MEALS_FILE="$MEALS_FILE" WATER_FILE="$WATER_FILE" DATE_STR="$date_str" python3 << 'PYEOF'
import json, os
meals_file = os.environ['MEALS_FILE']
water_file = os.environ['WATER_FILE']
d = os.environ['DATE_STR']
with open(meals_file, 'r') as f:
    meals = json.load(f)
with open(water_file, 'r') as f:
    water = json.load(f)

day_meals = [e for e in meals if e['date'] == d]
day_water = [e for e in water if e['date'] == d]

print(f'📋 Daily Report — {d}')
print('=' * 40)

if not day_meals:
    print('  No meals logged.')
else:
    total_cal = 0
    for mt in ['breakfast', 'lunch', 'dinner', 'snack']:
        items = [e for e in day_meals if e['meal_type'] == mt]
        if items:
            print(f'  {mt.capitalize()}:')
            for i in items:
                print(f'    • {i["food"]} — {i["calories"]:.0f} kcal')
                total_cal += i['calories']
    p = sum(e['protein'] for e in day_meals)
    c = sum(e['carbs'] for e in day_meals)
    f_ = sum(e['fat'] for e in day_meals)
    print(f'  Total: {total_cal:.0f} kcal | P:{p:.0f}g C:{c:.0f}g F:{f_:.0f}g')

water_total = sum(e['ml'] for e in day_water)
print(f'  Water: {water_total:.0f} ml')
PYEOF
  elif [[ "${mode}" == "weekly" ]]; then
    MEALS_FILE="$MEALS_FILE" WATER_FILE="$WATER_FILE" DATE_STR="$date_str" python3 << 'PYEOF'
import json, os
from datetime import datetime, timedelta

meals_file = os.environ['MEALS_FILE']
water_file = os.environ['WATER_FILE']
date_str = os.environ['DATE_STR']

with open(meals_file, 'r') as f:
    meals = json.load(f)
with open(water_file, 'r') as f:
    water = json.load(f)

end = datetime.strptime(date_str, '%Y-%m-%d')
start = end - timedelta(days=6)

print(f'📋 Weekly Report — {start.strftime("%Y-%m-%d")} to {date_str}')
print('=' * 50)

total_cal = 0
total_water = 0
days_with_data = 0

for i in range(7):
    d = (start + timedelta(days=i)).strftime('%Y-%m-%d')
    day_meals = [e for e in meals if e['date'] == d]
    day_water = [e for e in water if e['date'] == d]
    cal = sum(e['calories'] for e in day_meals)
    wml = sum(e['ml'] for e in day_water)
    if day_meals or day_water:
        days_with_data += 1
    total_cal += cal
    total_water += wml
    indicator = '█' * int(cal / 100) if cal else '—'
    print(f'  {d}: {cal:>6.0f} kcal | {wml:>5.0f} ml  {indicator}')

if days_with_data:
    print(f'\n  Avg calories: {total_cal/days_with_data:.0f} kcal/day')
    print(f'  Avg water:    {total_water/days_with_data:.0f} ml/day')
    print(f'  Total:        {total_cal:.0f} kcal | {total_water:.0f} ml')
else:
    print('  No data for this week.')
PYEOF
  else
    echo "Usage: script.sh report [daily|weekly] [YYYY-MM-DD]"
    exit 1
  fi
}


cmd_help() {
  cat <<'EOF'
diet — Meal & Nutrition Tracker

Commands:
  log <food> <cal> <protein> <carbs> <fat> [type]  Record a meal entry
  calories [YYYY-MM-DD]                             Show calorie total for a date
  plan <target_cal> <days>                          Generate a meal plan
  macros [YYYY-MM-DD]                               Show macronutrient breakdown
  water <ml> [YYYY-MM-DD]                           Log water intake
  report [daily|weekly] [YYYY-MM-DD]                Nutrition report
  help                                              Show this help message

Data stored in: ~/.diet/
EOF
}


main() {
  local cmd="${1:-help}"
  shift || true

  case "${cmd}" in
    log)       cmd_log "$@" ;;
    calories)  cmd_calories "$@" ;;
    plan)      cmd_plan "$@" ;;
    macros)    cmd_macros "$@" ;;
    water)     cmd_water "$@" ;;
    report)    cmd_report "$@" ;;
    help|--help|-h) cmd_help ;;
    *)
      echo "Unknown command: ${cmd}" >&2
      cmd_help
      exit 1
      ;;
  esac
}

main "$@"
