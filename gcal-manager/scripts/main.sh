#!/usr/bin/env bash
# Google Calendar Manager — Manage events via Google Calendar API
# Usage: bash main.sh --action <action> --token <token> [options]
set -euo pipefail

ACTION=""
TOKEN="${GCAL_TOKEN:-}"
CALENDAR_ID="primary"
EVENT_ID=""
TITLE=""
START=""
END=""
DESCRIPTION=""
LOCATION=""
DAYS="7"
OUTPUT=""

show_help() {
    cat << 'HELPEOF'
Google Calendar Manager — Full calendar management toolkit

Usage: bash main.sh --action <action> --token <token> [options]

Actions:
  list-calendars    List all calendars
  list-events       List upcoming events (--days for range)
  today             Show today's events
  create-event      Create event (--title --start --end)
  get-event         Get event details (--event-id)
  update-event      Update event (--event-id --title)
  delete-event      Delete event (--event-id)
  free-busy         Check availability (--start --end)

Options:
  --token <token>      OAuth2 access token (or GCAL_TOKEN env)
  --calendar <id>      Calendar ID (default: primary)
  --event-id <id>      Event ID
  --title <title>      Event title/summary
  --start <datetime>   Start time (ISO 8601: 2026-03-15T10:00:00Z)
  --end <datetime>     End time (ISO 8601: 2026-03-15T11:00:00Z)
  --desc <text>        Event description
  --location <loc>     Event location
  --days <n>           Days ahead for list (default: 7)
  --output <file>      Save output to file

Examples:
  bash main.sh --action today --token ya29.xxx
  bash main.sh --action list-events --days 14
  bash main.sh --action create-event --title "Meeting" --start "2026-03-15T10:00:00Z" --end "2026-03-15T11:00:00Z"
  bash main.sh --action free-busy --start "2026-03-15T09:00:00Z" --end "2026-03-15T18:00:00Z"

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --action) ACTION="$2"; shift 2;;
        --token) TOKEN="$2"; shift 2;;
        --calendar) CALENDAR_ID="$2"; shift 2;;
        --event-id) EVENT_ID="$2"; shift 2;;
        --title) TITLE="$2"; shift 2;;
        --start) START="$2"; shift 2;;
        --end) END="$2"; shift 2;;
        --desc) DESCRIPTION="$2"; shift 2;;
        --location) LOCATION="$2"; shift 2;;
        --days) DAYS="$2"; shift 2;;
        --output) OUTPUT="$2"; shift 2;;
        --help|-h) show_help; exit 0;;
        *) shift;;
    esac
done

[ -z "$ACTION" ] && { echo "Error: --action required"; show_help; exit 1; }
[ -z "$TOKEN" ] && { echo "Error: --token required (or set GCAL_TOKEN env)"; exit 1; }

API="https://www.googleapis.com/calendar/v3"

gcal_api() {
    local method="$1" endpoint="$2" data="${3:-}"
    local url="$API/$endpoint"
    local args=(-s -X "$method" "$url" -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json")
    [ -n "$data" ] && args+=(-d "$data")
    curl "${args[@]}" 2>/dev/null
}

format_events() {
    python3 << 'PYEOF'
import json, sys
data = json.load(sys.stdin)

if "error" in data:
    err = data["error"]
    print("Error: {} — {}".format(err.get("code","?"), err.get("message","?")))
    sys.exit(1)

items = data.get("items", [])
if not items:
    print("No events found")
    sys.exit(0)

print("Found {} events".format(len(items)))
print("")

for event in items:
    title = event.get("summary", "(No title)")
    start = event.get("start", {})
    end = event.get("end", {})
    start_time = start.get("dateTime", start.get("date", "?"))
    end_time = end.get("dateTime", end.get("date", "?"))
    location = event.get("location", "")
    status = event.get("status", "")
    
    print("  {} {}".format("✅" if status == "confirmed" else "⏳", title))
    print("     {} → {}".format(start_time[:16], end_time[:16]))
    if location:
        print("     📍 {}".format(location))
    eid = event.get("id", "")
    if eid:
        print("     ID: {}".format(eid))
    print("")
PYEOF
}

format_calendars() {
    python3 << 'PYEOF'
import json, sys
data = json.load(sys.stdin)
items = data.get("items", [])
print("Found {} calendars".format(len(items)))
print("")
for cal in items:
    primary = " ⭐" if cal.get("primary") else ""
    print("  {} — {}{}".format(cal.get("summary","?"), cal.get("id","?"), primary))
PYEOF
}

format_event() {
    python3 << 'PYEOF'
import json, sys
data = json.load(sys.stdin)
if "error" in data:
    print("Error: {}".format(data["error"].get("message","")))
    sys.exit(1)
print("Event: {}".format(data.get("summary","")))
print("ID: {}".format(data.get("id","")))
start = data.get("start", {})
end = data.get("end", {})
print("Start: {}".format(start.get("dateTime", start.get("date",""))))
print("End: {}".format(end.get("dateTime", end.get("date",""))))
if data.get("location"): print("Location: {}".format(data["location"]))
if data.get("description"): print("Description: {}".format(data["description"]))
print("Status: {}".format(data.get("status","")))
print("Link: {}".format(data.get("htmlLink","")))
PYEOF
}

case "$ACTION" in
    list-calendars)
        gcal_api GET "users/me/calendarList" | format_calendars
        ;;
    today)
        today_start=$(date -u '+%Y-%m-%dT00:00:00Z')
        today_end=$(date -u '+%Y-%m-%dT23:59:59Z')
        gcal_api GET "calendars/$CALENDAR_ID/events?timeMin=$today_start&timeMax=$today_end&singleEvents=true&orderBy=startTime" | format_events
        ;;
    list-events)
        time_min=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
        time_max=$(date -u -d "+${DAYS} days" '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date -u -v+${DAYS}d '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || echo "")
        [ -z "$time_max" ] && time_max=$(python3 -c "import datetime; print((datetime.datetime.utcnow()+datetime.timedelta(days=$DAYS)).strftime('%Y-%m-%dT%H:%M:%SZ'))")
        gcal_api GET "calendars/$CALENDAR_ID/events?timeMin=$time_min&timeMax=$time_max&singleEvents=true&orderBy=startTime&maxResults=50" | format_events
        ;;
    create-event)
        [ -z "$TITLE" ] && { echo "Error: --title required"; exit 1; }
        [ -z "$START" ] && { echo "Error: --start required (ISO 8601)"; exit 1; }
        [ -z "$END" ] && { echo "Error: --end required (ISO 8601)"; exit 1; }
        payload=$(python3 -c "
import json
event = {
    'summary': '$TITLE',
    'start': {'dateTime': '$START', 'timeZone': 'UTC'},
    'end': {'dateTime': '$END', 'timeZone': 'UTC'}
}
if '$DESCRIPTION': event['description'] = '$DESCRIPTION'
if '$LOCATION': event['location'] = '$LOCATION'
print(json.dumps(event))
")
        gcal_api POST "calendars/$CALENDAR_ID/events" "$payload" | format_event
        ;;
    get-event)
        [ -z "$EVENT_ID" ] && { echo "Error: --event-id required"; exit 1; }
        gcal_api GET "calendars/$CALENDAR_ID/events/$EVENT_ID" | format_event
        ;;
    update-event)
        [ -z "$EVENT_ID" ] && { echo "Error: --event-id required"; exit 1; }
        payload=$(python3 -c "
import json
event = {}
if '$TITLE': event['summary'] = '$TITLE'
if '$START': event['start'] = {'dateTime': '$START', 'timeZone': 'UTC'}
if '$END': event['end'] = {'dateTime': '$END', 'timeZone': 'UTC'}
if '$DESCRIPTION': event['description'] = '$DESCRIPTION'
if '$LOCATION': event['location'] = '$LOCATION'
print(json.dumps(event))
")
        gcal_api PATCH "calendars/$CALENDAR_ID/events/$EVENT_ID" "$payload" | format_event
        ;;
    delete-event)
        [ -z "$EVENT_ID" ] && { echo "Error: --event-id required"; exit 1; }
        result=$(gcal_api DELETE "calendars/$CALENDAR_ID/events/$EVENT_ID")
        if [ -z "$result" ]; then
            echo "✅ Event deleted"
        else
            echo "$result"
        fi
        ;;
    free-busy)
        [ -z "$START" ] && { echo "Error: --start required"; exit 1; }
        [ -z "$END" ] && { echo "Error: --end required"; exit 1; }
        payload="{\"timeMin\":\"$START\",\"timeMax\":\"$END\",\"items\":[{\"id\":\"$CALENDAR_ID\"}]}"
        gcal_api POST "freeBusy" "$payload" | python3 -c "
import json, sys
data = json.load(sys.stdin)
cals = data.get('calendars', {})
for cal_id, info in cals.items():
    busy = info.get('busy', [])
    if not busy:
        print('Free during this period')
    else:
        print('Busy periods:')
        for b in busy:
            print('  {} → {}'.format(b.get('start','')[:16], b.get('end','')[:16]))
"
        ;;
    *)
        echo "Unknown action: $ACTION"; show_help; exit 1;;
esac
