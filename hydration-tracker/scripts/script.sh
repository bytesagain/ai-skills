#!/bin/bash

# Configuration
DATA_DIR="$HOME/.water_reminder"
DATA_FILE="$DATA_DIR/data.json"
GOAL_FILE="$DATA_DIR/goal.json"
DEFAULT_GOAL_ML=2000
DEFAULT_DRINK_ML=250
DEFAULT_CUP_ML=250
DEFAULT_BOTTLE_ML=500
MAX_HISTORY_DAYS=30

# Ensure data directory exists
mkdir -p "$DATA_DIR"

# Initialize data files if they don't exist
if [ ! -f "$DATA_FILE" ]; then
    echo "{}" > "$DATA_FILE"
fi
if [ ! -f "$GOAL_FILE" ]; then
    echo "{\"goal\": $DEFAULT_GOAL_ML}" > "$GOAL_FILE"
fi

# Helper function to get today's date in YYYY-MM-DD format
get_today_date() {
    date +%Y-%m-%d
}

# Helper function to get a specific date in YYYY-MM-DD format (e.g., date -d "N days ago")
get_date_n_days_ago() {
    local days_ago=$1
    date -d "$days_ago days ago" +%Y-%m-%d
}

# Read JSON value using Python (more robust than grep/sed for nested JSON)
read_json_value() {
    local file=$1
    local key=$2
    FILE="$file" KEY="$key" python3 << 'PYEOF'
import json, os
try:
    with open(os.environ["FILE"]) as f:
        data = json.load(f)
    print(data.get(os.environ["KEY"], ''))
except (FileNotFoundError, json.JSONDecodeError):
    print('')
PYEOF
}

# Write JSON value using Python
write_json_value() {
    local file=$1
    local key=$2
    local value=$3 # raw value, will be handled by python as int/str
    local is_int=$4 # 'true' if value is an integer

    FILE="$file" KEY="$key" VALUE="$value" IS_INT="$is_int" python3 << 'PYEOF'
import json, os, sys

file_path = os.environ["FILE"]
key = os.environ["KEY"]
value = os.environ["VALUE"]
is_int = os.environ.get("IS_INT", "") == 'true'

try:
    with open(file_path, 'r') as f:
        data = json.load(f)
except (FileNotFoundError, json.JSONDecodeError):
    data = {}

if is_int:
    try:
        data[key] = int(value)
    except ValueError:
        print('Error: Value is not a valid integer.', file=sys.stderr)
        sys.exit(1)
else:
    data[key] = value

with open(file_path, 'w') as f:
    json.dump(data, f, indent=2)
PYEOF
}

# Get current goal
get_goal() {
    local current_goal=$(read_json_value "$GOAL_FILE" "goal")
    if [ -z "$current_goal" ]; then
        current_goal=$DEFAULT_GOAL_ML
        write_json_value "$GOAL_FILE" "goal" "$current_goal" true >/dev/null 2>&1
    fi
    echo "$current_goal"
}

# Log water intake
cmd_drink() {
    local amount_ml=${1:-$DEFAULT_DRINK_ML}
    if ! [[ "$amount_ml" =~ ^[0-9]+$ ]]; then
        echo "Error: Amount must be a positive integer."
        return 1
    fi

    local today_date=$(get_today_date)
    local current_intake=$(read_json_value "$DATA_FILE" "$today_date")
    local new_intake=$((current_intake + amount_ml))
    write_json_value "$DATA_FILE" "$today_date" "$new_intake" true

    local current_goal=$(get_goal)
    echo "Logged ${amount_ml}ml. Today's total: ${new_intake}ml / ${current_goal}ml."
    if (( new_intake >= current_goal )); then
        echo "🎉 You've reached your daily goal!"
    elif (( new_intake >= current_goal * 0.8 )); then
        echo "Almost there! Keep going!"
    fi
}

cmd_cup() {
    cmd_drink "$DEFAULT_CUP_ML"
}

cmd_bottle() {
    cmd_drink "$DEFAULT_BOTTLE_ML"
}

# Show today's intake
cmd_today() {
    local today_date=$(get_today_date)
    local current_intake=$(read_json_value "$DATA_FILE" "$today_date")
    local current_goal=$(get_goal)

    echo "Today's intake (${today_date}): ${current_intake}ml / ${current_goal}ml"
    local remaining=$((current_goal - current_intake))
    if (( remaining > 0 )); then
        echo "Remaining: ${remaining}ml"
    else
        echo "Goal reached! 🎉"
    fi
}

# Set daily goal
cmd_goal() {
    local new_goal_ml=${1:-$DEFAULT_GOAL_ML}
    if ! [[ "$new_goal_ml" =~ ^[0-9]+$ ]]; then
        echo "Error: Goal must be a positive integer."
        return 1
    fi
    write_json_value "$GOAL_FILE" "goal" "$new_goal_ml" true
    echo "Daily goal set to ${new_goal_ml}ml."
}

# Check if on track (simple check: if current intake is 50% of goal by midday)
cmd_check() {
    local today_date=$(get_today_date)
    local current_intake=$(read_json_value "$DATA_FILE" "$today_date")
    local current_goal=$(get_goal)
    local hour=$(date +%H)

    echo "Current intake: ${current_intake}ml, Daily goal: ${current_goal}ml"

    if (( current_intake >= current_goal )); then
        echo "Goal reached! 🎉"
        return 0
    fi

    local target_by_now=$(( current_goal * hour / 24 ))
    if (( current_intake >= target_by_now )); then
        echo "You are on track! Keep up the good work."
    else
        echo "You might be falling behind. Drink some water!"
    fi
}

# Weekly summary
cmd_week() {
    echo "--- Weekly Hydration Summary ---"
    local total_intake_week=0
    local goal=$(get_goal)
    for i in $(seq 0 6); do
        local d=$(get_date_n_days_ago "$i")
        local intake=$(read_json_value "$DATA_FILE" "$d")
        total_intake_week=$((total_intake_week + intake))
        local status="(${intake}ml / ${goal}ml)"
        if (( intake >= goal )); then
            status+=" 🎉"
        elif (( intake > 0 )); then
            status+=" 💧"
        fi
        echo "$d: $status"
    done
    local avg_intake_day=$((total_intake_week / 7))
    echo "------------------------------"
    echo "Weekly total: ${total_intake_week}ml"
    echo "Daily average: ${avg_intake_day}ml (Goal: ${goal}ml)"
}

# Intake history
cmd_history() {
    local days=${1:-7}
    if ! [[ "$days" =~ ^[0-9]+$ ]] || (( days <= 0 )); then
        echo "Error: Days must be a positive integer."
        return 1
    fi
    if (( days > MAX_HISTORY_DAYS )); then
        echo "Displaying maximum ${MAX_HISTORY_DAYS} days of history."
        days=$MAX_HISTORY_DAYS
    fi

    echo "--- Hydration History (last ${days} days) ---"
    local goal=$(get_goal)
    for i in $(seq 0 $((days - 1))); do
        local d=$(get_date_n_days_ago "$i")
        local intake=$(read_json_value "$DATA_FILE" "$d")
        local status="(${intake}ml / ${goal}ml)"
        if (( intake >= goal )); then
            status+=" 🎉"
        elif (( intake > 0 )); then
            status+=" 💧"
        fi
        echo "$d: $status"
    done
    echo "-----------------------------------"
}

# Hydration statistics (simple version)
cmd_stats() {
    echo "--- Hydration Statistics ---"
    local total_days
    total_days=$(DATA_FILE="$DATA_FILE" python3 << 'PYEOF'
import json, os
try:
    with open(os.environ["DATA_FILE"]) as f:
        data = json.load(f)
    print(len(data))
except:
    print(0)
PYEOF
    )
    local total_intake
    total_intake=$(DATA_FILE="$DATA_FILE" python3 << 'PYEOF'
import json, os
try:
    with open(os.environ["DATA_FILE"]) as f:
        data = json.load(f)
    print(sum(data.values()))
except:
    print(0)
PYEOF
    )
    local goal=$(get_goal)

    echo "Days tracked: $total_days"
    echo "Total intake across all tracked days: ${total_intake}ml"
    if (( total_days > 0 )); then
        local avg_intake=$((total_intake / total_days))
        echo "Average daily intake: ${avg_intake}ml (Goal: ${goal}ml)"
    fi
    echo "--------------------------"
}

# Hydration tips
cmd_remind() {
    tips=(
        "Remember to drink water regularly throughout the day, not just when you feel thirsty."
        "Keep a water bottle handy as a visual reminder to drink more."
        "Add slices of fruit or vegetables to your water for flavor."
        "Drink a glass of water before each meal."
        "Aim for about 8 glasses (approx. 2 liters) of water daily, adjust based on activity and climate."
        "Set alarms or use apps to remind you to drink water."
        "Replace sugary drinks with water."
    )
    # Get a random tip
    random_tip=${tips[$(( RANDOM % ${#tips[@]} ))]}
    echo "💧 Hydration Tip: $random_tip"
}

# Version info
cmd_info() {
    echo "Hydration Tracker Skill v1.0.0"
    echo "Powered by BytesAgain | bytesagain.com"
}

# Help message
cmd_help() {
    echo "Hydration Tracker Skill - Daily Hydration Tracker"
    echo "Usage: hydration-tracker <command> [arguments]"
    echo ""
    echo "Commands:"
    echo "  drink [ml]        Log water intake (default: ${DEFAULT_DRINK_ML}ml)"
    echo "  cup               Log ${DEFAULT_CUP_ML}ml (quick log)"
    echo "  bottle            Log ${DEFAULT_BOTTLE_ML}ml (quick log)"
    echo "  today             Show today's total intake and progress"
    echo "  goal [ml]         Set daily hydration goal (default: ${DEFAULT_GOAL_ML}ml)"
    echo "  check             Check if you are on track with your daily goal"
    echo "  week              Show weekly hydration summary"
    echo "  history [n]       Show hydration history for the last 'n' days (default: 7)"
    echo "  stats             Display overall hydration statistics"
    echo "  remind            Get a random hydration tip"
    echo "  info              Show skill version and info"
    echo "  help              Show this help message"
    echo ""
    echo "Example: hydration-tracker drink 300"
    echo "Example: hydration-tracker goal 2500"
}

# Main logic
case "$1" in
    drink) shift; cmd_drink "$@";;
    cup) cmd_cup;;
    bottle) cmd_bottle;;
    today) cmd_today;;
    goal) shift; cmd_goal "$@";;
    check) cmd_check;;
    week) cmd_week;;
    history) shift; cmd_history "$@";;
    stats) cmd_stats;;
    remind) cmd_remind;;
    info) cmd_info;;
    help) cmd_help;;
    *)
        cmd_help
        exit 1
        ;;
esac
