#!/bin/bash
# content-calendar-scheduler — Content Calendar Manager
# Original implementation by BytesAgain

DATA_DIR="${HOME}/.content-calendar"
mkdir -p "$DATA_DIR"
CAL_FILE="$DATA_DIR/calendar.json"
[ -f "$CAL_FILE" ] || echo '[]' > "$CAL_FILE"

show_help() {
    cat << 'HELP'
Content Calendar Scheduler — Plan & track content across platforms

Commands:
  add       Add a content item to calendar
  list      Show upcoming content schedule  
  today     Show today's content plan
  week      Show this week's schedule
  status    Content pipeline overview
  done      Mark content as published
  remove    Remove a calendar entry
  export    Export calendar to markdown
  help      Show this help

Usage:
  content-calendar.sh add "Blog post about AI tools" --date 2024-03-20 --platform blog
  content-calendar.sh list --days 7
  content-calendar.sh today
  content-calendar.sh done <id>
HELP
}

cmd_add() {
    local title="" date="" platform="general" priority="normal"
    while [ $# -gt 0 ]; do
        case "$1" in
            --date) date="$2"; shift 2 ;;
            --platform) platform="$2"; shift 2 ;;
            --priority) priority="$2"; shift 2 ;;
            *) title="$title $1"; shift ;;
        esac
    done
    title=$(echo "$title" | sed 's/^ //')
    [ -z "$title" ] && { echo "Usage: add <title> --date YYYY-MM-DD --platform <platform>"; return 1; }
    [ -z "$date" ] && date=$(date +%Y-%m-%d)
    
    local id=$(date +%s | tail -c 6)
    python3 -c "
import json
with open('$CAL_FILE') as f: cal = json.load(f)
cal.append({
    'id': '$id', 'title': '''$title''', 'date': '$date',
    'platform': '$platform', 'priority': '$priority',
    'status': 'planned', 'created': '$(date +%Y-%m-%d)'
})
with open('$CAL_FILE','w') as f: json.dump(cal, f, indent=2)
print('  Added: {} [{}] on {} (ID: {})'.format('$title','$platform','$date','$id'))
"
}

cmd_list() {
    local days=${1:-30}
    python3 -c "
import json, datetime
with open('$CAL_FILE') as f: cal = json.load(f)
today = datetime.date.today()
end = today + datetime.timedelta(days=$days)
upcoming = [c for c in cal if c['status'] != 'done']
upcoming.sort(key=lambda x: x['date'])
print('Content Schedule (next {} days):'.format($days))
print('{:6s} {:12s} {:10s} {:8s} {}'.format('ID','Date','Platform','Priority','Title'))
print('-' * 70)
for c in upcoming:
    try:
        d = datetime.date(*[int(x) for x in c['date'].split('-')])
        if d <= end:
            flag = '🔴' if c['priority'] == 'high' else '🟡' if c['priority'] == 'normal' else '⚪'
            print('{} {:6s} {:12s} {:10s} {:8s} {}'.format(flag, c['id'], c['date'], c['platform'], c['priority'], c['title']))
    except: pass
if not upcoming: print('  (empty - use \"add\" to schedule content)')
"
}

cmd_today() {
    python3 -c "
import json, datetime
with open('$CAL_FILE') as f: cal = json.load(f)
today = datetime.date.today().strftime('%Y-%m-%d')
items = [c for c in cal if c['date'] == today and c['status'] != 'done']
print('Today ({}) — {} items:'.format(today, len(items)))
for c in items:
    print('  [{}] {} ({})'.format(c['id'], c['title'], c['platform']))
if not items: print('  Nothing scheduled for today.')
"
}

cmd_week() {
    python3 -c "
import json, datetime
with open('$CAL_FILE') as f: cal = json.load(f)
today = datetime.date.today()
week_end = today + datetime.timedelta(days=7)
items = []
for c in cal:
    if c['status'] == 'done': continue
    try:
        d = datetime.date(*[int(x) for x in c['date'].split('-')])
        if today <= d <= week_end: items.append(c)
    except: pass
items.sort(key=lambda x: x['date'])
print('This Week ({} — {}):'.format(today, week_end))
cur_date = ''
for c in items:
    if c['date'] != cur_date:
        cur_date = c['date']
        day = datetime.date(*[int(x) for x in cur_date.split('-')]).strftime('%A')
        print('  {} ({}):'.format(cur_date, day))
    print('    [{}] {} ({})'.format(c['id'], c['title'], c['platform']))
if not items: print('  No content planned this week.')
"
}

cmd_status() {
    python3 -c "
import json
from collections import Counter
with open('$CAL_FILE') as f: cal = json.load(f)
status = Counter(c['status'] for c in cal)
platform = Counter(c['platform'] for c in cal)
print('Content Pipeline:')
print('  Planned:   {}'.format(status.get('planned',0)))
print('  In Progress: {}'.format(status.get('in-progress',0)))
print('  Done:      {}'.format(status.get('done',0)))
print('  Total:     {}'.format(len(cal)))
print('')
print('By Platform:')
for p, cnt in platform.most_common():
    print('  {:15s} {}'.format(p, cnt))
"
}

cmd_done() {
    local target_id="$1"
    [ -z "$target_id" ] && { echo "Usage: done <id>"; return 1; }
    python3 -c "
import json
with open('$CAL_FILE') as f: cal = json.load(f)
found = False
for c in cal:
    if c['id'] == '$target_id':
        c['status'] = 'done'
        c['completed'] = '$(date +%Y-%m-%d)'
        found = True
        print('  Marked done: {}'.format(c['title']))
        break
if not found: print('  Not found: $target_id')
with open('$CAL_FILE','w') as f: json.dump(cal, f, indent=2)
"
}

cmd_remove() {
    local target_id="$1"
    [ -z "$target_id" ] && { echo "Usage: remove <id>"; return 1; }
    python3 -c "
import json
with open('$CAL_FILE') as f: cal = json.load(f)
before = len(cal)
cal = [c for c in cal if c['id'] != '$target_id']
if len(cal) < before: print('  Removed entry $target_id')
else: print('  Not found: $target_id')
with open('$CAL_FILE','w') as f: json.dump(cal, f, indent=2)
"
}

cmd_export() {
    python3 -c "
import json, datetime
with open('$CAL_FILE') as f: cal = json.load(f)
cal.sort(key=lambda x: x['date'])
print('# Content Calendar')
print('')
print('Generated: {}'.format(datetime.date.today()))
print('')
cur_date = ''
for c in cal:
    if c['date'] != cur_date:
        cur_date = c['date']
        print('## {}'.format(cur_date))
    status = '✅' if c['status'] == 'done' else '⏳'
    print('- {} [{}] {} ({})'.format(status, c['platform'], c['title'], c['id']))
"
}

case "${1:-help}" in
    add)    shift; cmd_add "$@" ;;
    list)   shift; cmd_list "$@" ;;
    today)  cmd_today ;;
    week)   cmd_week ;;
    status) cmd_status ;;
    done)   cmd_done "$2" ;;
    remove) cmd_remove "$2" ;;
    export) cmd_export ;;
    help)   show_help ;;
    *)      echo "Unknown: $1"; show_help ;;
esac
