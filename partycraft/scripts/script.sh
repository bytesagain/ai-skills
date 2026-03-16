#!/bin/bash
# PartyCraft - 活动策划助手
# Powered by BytesAgain | bytesagain.com

DATA_DIR="$HOME/.partycraft"
EVENTS_FILE="$DATA_DIR/events.json"
mkdir -p "$DATA_DIR"
[ ! -f "$EVENTS_FILE" ] && echo "[]" > "$EVENTS_FILE"

cmd_create() {
    local name="$1"; shift
    local date="$1"; shift
    local type="${1:-general}"
    if [ -z "$name" ] || [ -z "$date" ]; then
        echo "Usage: partycraft create <name> <date> [type]"
        echo "Types: wedding, birthday, corporate, party, general"
        return 1
    fi
    python3 << PYEOF
import json, time
event = {"id": int(time.time()), "name": "$name", "date": "$date", "type": "$type", "budget": 0, "tasks": [], "guests": [], "created": time.strftime("%Y-%m-%d")}
try:
    with open("$EVENTS_FILE") as f: data = json.load(f)
except: data = []
data.append(event)
with open("$EVENTS_FILE", "w") as f: json.dump(data, f, indent=2)
print("Event created: {} ({}) on {}".format("$name", "$type", "$date"))
PYEOF
}

cmd_list() {
    python3 << PYEOF
import json
try:
    with open("$EVENTS_FILE") as f: data = json.load(f)
except: data = []
if not data:
    print("No events. Create one: partycraft create <name> <date>")
else:
    print("Your Events:")
    print("-" * 50)
    for e in data:
        tasks_done = sum(1 for t in e.get("tasks",[]) if t.get("done"))
        total_tasks = len(e.get("tasks",[]))
        guests = len(e.get("guests",[]))
        print("  [{}] {} - {} ({})".format(e["id"], e["name"], e["date"], e["type"]))
        print("      Tasks: {}/{} | Guests: {} | Budget: \${}".format(tasks_done, total_tasks, guests, e.get("budget",0)))
PYEOF
}

cmd_budget() {
    local event_id="$1"
    local amount="$2"
    if [ -z "$event_id" ] || [ -z "$amount" ]; then
        echo "Usage: partycraft budget <event_id> <amount>"
        return 1
    fi
    python3 << PYEOF
import json
try:
    with open("$EVENTS_FILE") as f: data = json.load(f)
except: data = []
found = False
for e in data:
    if str(e["id"]) == "$event_id":
        e["budget"] = float("$amount")
        found = True
        print("Budget set to \${} for: {}".format("$amount", e["name"]))
        break
if not found: print("Event not found: $event_id")
with open("$EVENTS_FILE", "w") as f: json.dump(data, f, indent=2)
PYEOF
}

cmd_task() {
    local event_id="$1"; shift
    local action="$1"; shift
    local task_text="$*"
    if [ -z "$event_id" ] || [ -z "$action" ]; then
        echo "Usage: partycraft task <event_id> add <task_text>"
        echo "       partycraft task <event_id> done <task_number>"
        echo "       partycraft task <event_id> list"
        return 1
    fi
    python3 << PYEOF
import json
try:
    with open("$EVENTS_FILE") as f: data = json.load(f)
except: data = []
found = False
for e in data:
    if str(e["id"]) == "$event_id":
        found = True
        if "$action" == "add":
            e.setdefault("tasks",[]).append({"text": "$task_text", "done": False})
            print("Task added: $task_text")
        elif "$action" == "done":
            idx = int("$task_text") - 1
            if 0 <= idx < len(e.get("tasks",[])):
                e["tasks"][idx]["done"] = True
                print("Task completed: {}".format(e["tasks"][idx]["text"]))
            else:
                print("Invalid task number")
        elif "$action" == "list":
            tasks = e.get("tasks",[])
            if not tasks: print("No tasks yet.")
            else:
                for i,t in enumerate(tasks,1):
                    status = "✅" if t["done"] else "⬜"
                    print("  {} {}. {}".format(status, i, t["text"]))
        break
if not found: print("Event not found: $event_id")
with open("$EVENTS_FILE", "w") as f: json.dump(data, f, indent=2)
PYEOF
}

cmd_guest() {
    local event_id="$1"; shift
    local action="$1"; shift
    local guest_name="$*"
    if [ -z "$event_id" ] || [ -z "$action" ]; then
        echo "Usage: partycraft guest <event_id> add <name>"
        echo "       partycraft guest <event_id> list"
        return 1
    fi
    python3 << PYEOF
import json
try:
    with open("$EVENTS_FILE") as f: data = json.load(f)
except: data = []
found = False
for e in data:
    if str(e["id"]) == "$event_id":
        found = True
        if "$action" == "add":
            e.setdefault("guests",[]).append({"name": "$guest_name", "rsvp": "pending"})
            print("Guest added: $guest_name")
        elif "$action" == "list":
            guests = e.get("guests",[])
            if not guests: print("No guests yet.")
            else:
                for g in guests:
                    print("  {} ({})".format(g["name"], g.get("rsvp","pending")))
        break
if not found: print("Event not found: $event_id")
with open("$EVENTS_FILE", "w") as f: json.dump(data, f, indent=2)
PYEOF
}

cmd_timeline() {
    local event_id="$1"
    if [ -z "$event_id" ]; then
        echo "Usage: partycraft timeline <event_id>"
        return 1
    fi
    python3 << PYEOF
import json, datetime
try:
    with open("$EVENTS_FILE") as f: data = json.load(f)
except: data = []
for e in data:
    if str(e["id"]) == "$event_id":
        try:
            event_date = datetime.datetime.strptime(e["date"], "%Y-%m-%d").date()
            today = datetime.date.today()
            days_left = (event_date - today).days
            print("Timeline for: {} ({})".format(e["name"], e["date"]))
            print("-" * 40)
            if days_left > 0:
                print("  {} days until event".format(days_left))
                tasks = e.get("tasks",[])
                done = sum(1 for t in tasks if t["done"])
                print("  Tasks: {}/{} complete".format(done, len(tasks)))
                print("  Guests: {} invited".format(len(e.get("guests",[]))))
                if days_left <= 7: print("  ⚠️  Less than a week! Final preparations!")
                elif days_left <= 30: print("  📋 One month out. Confirm details.")
            elif days_left == 0:
                print("  🎉 Event is TODAY!")
            else:
                print("  Event was {} days ago".format(abs(days_left)))
        except: print("Invalid date format. Use YYYY-MM-DD")
        break
PYEOF
}

cmd_checklist() {
    local event_type="${1:-general}"
    echo "Suggested Checklist for: $event_type"
    echo "-" * 40
    case "$event_type" in
        wedding)
            echo "  □ Book venue"
            echo "  □ Send invitations (3 months before)"
            echo "  □ Arrange catering"
            echo "  □ Book photographer"
            echo "  □ Order flowers"
            echo "  □ Plan seating"
            echo "  □ Arrange music/DJ"
            echo "  □ Wedding cake"
            echo "  □ Rehearsal dinner"
            echo "  □ Final guest count (1 week before)"
            ;;
        birthday)
            echo "  □ Choose theme"
            echo "  □ Send invitations"
            echo "  □ Order cake"
            echo "  □ Buy decorations"
            echo "  □ Plan activities/games"
            echo "  □ Arrange food/drinks"
            echo "  □ Party favors"
            ;;
        corporate)
            echo "  □ Define objectives"
            echo "  □ Book venue"
            echo "  □ Send invitations"
            echo "  □ Arrange AV equipment"
            echo "  □ Plan agenda/speakers"
            echo "  □ Catering"
            echo "  □ Name badges"
            echo "  □ Follow-up materials"
            ;;
        *)
            echo "  □ Set date and time"
            echo "  □ Choose venue"
            echo "  □ Create guest list"
            echo "  □ Send invitations"
            echo "  □ Plan food and drinks"
            echo "  □ Decorations"
            echo "  □ Activities/entertainment"
            echo "  □ Clean up plan"
            ;;
    esac
}

cmd_info() {
    echo "PartyCraft v1.0.0"
    echo "Powered by BytesAgain | bytesagain.com"
}

cmd_help() {
    echo "PartyCraft - 活动策划助手"
    echo "Usage: partycraft <command> [arguments]"
    echo ""
    echo "Commands:"
    echo "  create <name> <date> [type]  Create event (types: wedding/birthday/corporate/party/general)"
    echo "  list                         List all events"
    echo "  budget <id> <amount>         Set event budget"
    echo "  task <id> add <text>         Add task to event"
    echo "  task <id> done <number>      Mark task complete"
    echo "  task <id> list               List event tasks"
    echo "  guest <id> add <name>        Add guest"
    echo "  guest <id> list              List guests"
    echo "  timeline <id>                Show event timeline"
    echo "  checklist [type]             Show suggested checklist"
    echo "  info                         Version info"
    echo "  help                         Show this help"
}

case "$1" in
    create) shift; cmd_create "$@";;
    list) cmd_list;;
    budget) shift; cmd_budget "$@";;
    task) shift; cmd_task "$@";;
    guest) shift; cmd_guest "$@";;
    timeline) shift; cmd_timeline "$@";;
    checklist) shift; cmd_checklist "$@";;
    info) cmd_info;;
    help|"") cmd_help;;
    *) echo "Unknown command: $1"; cmd_help; exit 1;;
esac
