#!/usr/bin/env bash
# meeting-minutes — Meeting recording, agenda, and action item tracker
set -euo pipefail
VERSION="2.0.0"
DATA_DIR="${MEETING_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/meeting-minutes}"
MEETINGS="$DATA_DIR/meetings"
mkdir -p "$MEETINGS"

show_help() {
    cat << EOF
meeting-minutes v$VERSION

Usage: meeting-minutes <command> [args]

Meeting Flow:
  new <title>                    Start a new meeting
  agenda <item> ...              Set agenda items
  note <text>                    Add discussion note
  action <who> <what> [due]      Add action item
  decision <text>                Record a decision
  end                            Close current meeting

Review:
  list                           List all meetings
  show <id|latest>               Show meeting details
  actions [--open]               List all action items
  decisions                      List all decisions
  search <term>                  Search across meetings

Export:
  export <id> <format>           Export (md|txt|html|json)
  template <type>                Meeting template (standup|retro|planning|1on1)
  summary <id>                   Generate executive summary
  email <id>                     Format for email sharing

EOF
}

CURRENT="$DATA_DIR/.current"

cmd_new() {
    local title="${*:?Usage: meeting-minutes new <title>}"
    local id=$(date +%Y%m%d-%H%M)
    local dir="$MEETINGS/$id"
    mkdir -p "$dir"
    
    cat > "$dir/meta.json" << METAEOF
{"id":"$id","title":"$title","date":"$(date '+%Y-%m-%d %H:%M')","status":"active","attendees":[]}
METAEOF
    touch "$dir/notes.md" "$dir/actions.jsonl" "$dir/decisions.md"
    echo "$id" > "$CURRENT"
    
    echo "  ╔═══════════════════════════════════════╗"
    echo "  ║  Meeting Started                      ║"
    echo "  ║  ID:    $id"
    echo "  ║  Title: $title"
    echo "  ║  Time:  $(date '+%Y-%m-%d %H:%M')"
    echo "  ╚═══════════════════════════════════════╝"
}

_get_current() {
    [ -f "$CURRENT" ] && cat "$CURRENT" || { echo "No active meeting. Run: meeting-minutes new <title>"; exit 1; }
}

cmd_agenda() {
    local id=$(_get_current)
    local dir="$MEETINGS/$id"
    echo "## Agenda" > "$dir/agenda.md"
    local i=1
    for item in "$@"; do
        echo "$i. $item" >> "$dir/agenda.md"
        i=$((i+1))
    done
    echo "  Agenda set: $# items"
    cat "$dir/agenda.md"
}

cmd_note() {
    local id=$(_get_current)
    echo "- [$(date +%H:%M)] $*" >> "$MEETINGS/$id/notes.md"
    echo "  Note added."
}

cmd_action() {
    local who="${1:?Usage: meeting-minutes action <who> <what> [due]}"
    local what="${2:?}"
    local due="${3:-}"
    local id=$(_get_current)
    printf '{"who":"%s","what":"%s","due":"%s","status":"open","created":"%s"}\n' \
        "$who" "$what" "$due" "$(date '+%Y-%m-%d')" >> "$MEETINGS/$id/actions.jsonl"
    echo "  Action: $who → $what${due:+ (due: $due)}"
}

cmd_decision() {
    local id=$(_get_current)
    echo "- [$(date +%H:%M)] **DECISION:** $*" >> "$MEETINGS/$id/decisions.md"
    echo "  Decision recorded."
}

cmd_end() {
    local id=$(_get_current)
    python3 -c "
import json
with open('$MEETINGS/$id/meta.json') as f: d = json.load(f)
d['status'] = 'closed'
d['ended'] = '$(date '+%Y-%m-%d %H:%M')'
with open('$MEETINGS/$id/meta.json','w') as f: json.dump(d, f)
"
    local notes=$(wc -l < "$MEETINGS/$id/notes.md" 2>/dev/null || echo 0)
    local actions=$(wc -l < "$MEETINGS/$id/actions.jsonl" 2>/dev/null || echo 0)
    echo "  Meeting $id closed."
    echo "  Notes: $notes | Actions: $actions"
    rm -f "$CURRENT"
}

cmd_list() {
    echo "  Meetings:"
    for dir in "$MEETINGS"/*/; do
        [ -d "$dir" ] || continue
        local id=$(basename "$dir")
        if [ -f "$dir/meta.json" ]; then
            python3 -c "
import json
with open('$dir/meta.json') as f: d = json.load(f)
status = '●' if d.get('status') == 'active' else '○'
print('  {} {} {}'.format(status, d.get('id','?'), d.get('title','?')))
" 2>/dev/null
        fi
    done
}

cmd_show() {
    local target="${1:-latest}"
    local id
    if [ "$target" = "latest" ]; then
        id=$(ls -1 "$MEETINGS" 2>/dev/null | sort | tail -1)
    else
        id="$target"
    fi
    [ -z "$id" ] && { echo "No meetings found."; return; }
    local dir="$MEETINGS/$id"
    [ -d "$dir" ] || { echo "Not found: $id"; return; }
    
    python3 -c "
import json
with open('$dir/meta.json') as f: d = json.load(f)
print('  Meeting: {} — {}'.format(d['id'], d['title']))
print('  Date: {} | Status: {}'.format(d.get('date','?'), d.get('status','?')))
"
    echo ""
    [ -f "$dir/agenda.md" ] && { echo "  Agenda:"; sed 's/^/  /' "$dir/agenda.md"; echo ""; }
    [ -s "$dir/notes.md" ] && { echo "  Notes:"; sed 's/^/  /' "$dir/notes.md"; echo ""; }
    [ -s "$dir/actions.jsonl" ] && {
        echo "  Actions:"
        while IFS= read -r line; do
            echo "$line" | python3 -c "
import json,sys
d=json.load(sys.stdin)
due = ' (due: {})'.format(d['due']) if d.get('due') else ''
print('    [{}] {} → {}{}'.format(d.get('status','?'), d['who'], d['what'], due))
" 2>/dev/null
        done < "$dir/actions.jsonl"
    }
}

cmd_actions() {
    local filter="${1:-}"
    echo "  All Action Items:"
    for dir in "$MEETINGS"/*/; do
        [ -f "$dir/actions.jsonl" ] || continue
        while IFS= read -r line; do
            local status=$(echo "$line" | python3 -c "import json,sys; print(json.load(sys.stdin).get('status','?'))" 2>/dev/null)
            if [ "$filter" = "--open" ] && [ "$status" != "open" ]; then continue; fi
            echo "$line" | python3 -c "
import json,sys
d=json.load(sys.stdin)
print('    [{}] {} → {}'.format(d.get('status','?'), d['who'], d['what']))
" 2>/dev/null
        done < "$dir/actions.jsonl"
    done
}

cmd_search() {
    local term="${1:?Usage: meeting-minutes search <term>}"
    echo "  Search: '$term'"
    grep -rl "$term" "$MEETINGS" 2>/dev/null | while read -r f; do
        local mid=$(echo "$f" | grep -oP '\d{8}-\d{4}')
        echo "  Found in: $mid — $(basename "$f")"
    done
}

cmd_template() {
    local type="${1:-standup}"
    case "$type" in
        standup)
            echo "  STANDUP TEMPLATE:"
            echo "  1. What I did yesterday"
            echo "  2. What I'm doing today"
            echo "  3. Any blockers"
            ;;
        retro)
            echo "  RETROSPECTIVE:"
            echo "  ✅ What went well"
            echo "  ❌ What didn't go well"
            echo "  💡 What to improve"
            ;;
        planning)
            echo "  PLANNING:"
            echo "  1. Review backlog"
            echo "  2. Estimate stories"
            echo "  3. Set sprint goal"
            echo "  4. Assign tasks"
            ;;
        1on1)
            echo "  1-ON-1 TEMPLATE:"
            echo "  1. How are you doing?"
            echo "  2. Wins this week"
            echo "  3. Challenges"
            echo "  4. Career goals"
            echo "  5. Feedback"
            ;;
    esac
}

cmd_export() {
    local id="${1:?Usage: meeting-minutes export <id> <format>}"
    local fmt="${2:-md}"
    cmd_show "$id"
}

cmd_summary() {
    local id="${1:-latest}"
    echo "  Executive Summary:"
    cmd_show "$id" | head -20
}

case "${1:-help}" in
    new)        shift; cmd_new "$@" ;;
    agenda)     shift; cmd_agenda "$@" ;;
    note)       shift; cmd_note "$@" ;;
    action)     shift; cmd_action "$@" ;;
    decision)   shift; cmd_decision "$@" ;;
    end|close)  cmd_end ;;
    list)       cmd_list ;;
    show)       shift; cmd_show "$@" ;;
    actions)    shift; cmd_actions "$@" ;;
    decisions)  echo "TODO: list decisions" ;;
    search)     shift; cmd_search "$@" ;;
    export)     shift; cmd_export "$@" ;;
    template)   shift; cmd_template "$@" ;;
    summary)    shift; cmd_summary "$@" ;;
    email)      shift; cmd_export "$@" ;;
    help|-h)    show_help ;;
    version|-v) echo "meeting-minutes v$VERSION" ;;
    *)          echo "Unknown: $1"; show_help; exit 1 ;;
esac
