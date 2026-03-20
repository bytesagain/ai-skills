#!/usr/bin/env bash
set -euo pipefail

######################################################################
# leads/scripts/script.sh — Sales Lead CRM
# Powered by BytesAgain | bytesagain.com
######################################################################

DATA_DIR="${HOME}/.leads"
LEADS_FILE="${DATA_DIR}/leads.json"

# ── helpers ─────────────────────────────────────────────────────────

ensure_data_dir() {
  mkdir -p "${DATA_DIR}"
  [[ -f "${LEADS_FILE}" ]] || echo '[]' > "${LEADS_FILE}"
}

today() {
  date +%Y-%m-%d
}

current_month() {
  date +%Y-%m
}

generate_id() {
  # Short unique ID based on timestamp + random
  printf "L%s%04d" "$(date +%s | tail -c 6)" "$((RANDOM % 10000))"
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

validate_email() {
  local email="${1:-}"
  if [[ ! "${email}" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "Warning: '${email}' may not be a valid email address." >&2
  fi
}

# ── cmd_add ─────────────────────────────────────────────────────────

cmd_add() {
  local name="${1:-}" email="${2:-}" company="${3:-}" source="${4:-direct}"

  if [[ -z "${name}" || -z "${email}" || -z "${company}" ]]; then
    echo "Usage: script.sh add \"<name>\" \"<email>\" \"<company>\" [source]"
    echo "  source: direct | referral | website | social | event (default: direct)"
    exit 1
  fi

  validate_email "${email}"
  ensure_data_dir

  local lead_id
  lead_id="$(generate_id)"
  local created
  created="$(today)"

  LEADS_FILE="$LEADS_FILE" python3 << 'PYEOF' "${name}" "${email}" "${company}" "${source}" "${lead_id}" "${created}"
import json, sys, os

leads_file = os.environ['LEADS_FILE']
with open(leads_file, 'r') as f:
    data = json.load(f)

# Check for duplicate email
for lead in data:
    if lead.get('email', '').lower() == sys.argv[2].lower():
        print(f'⚠️  Lead with email {sys.argv[2]} already exists (ID: {lead["id"]})')
        sys.exit(1)

lead = {
    'id': sys.argv[5],
    'name': sys.argv[1],
    'email': sys.argv[2],
    'company': sys.argv[3],
    'source': sys.argv[4],
    'status': 'new',
    'score': 0,
    'created': sys.argv[6],
    'follow_ups': [],
    'notes': [],
    'deal_value': None
}

data.append(lead)

with open(leads_file, 'w') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print(f'✅ Lead added')
print(f'   ID:      {lead["id"]}')
print(f'   Name:    {lead["name"]}')
print(f'   Email:   {lead["email"]}')
print(f'   Company: {lead["company"]}')
print(f'   Source:  {lead["source"]}')
print(f'   Status:  {lead["status"]}')
PYEOF
}

# ── cmd_list ────────────────────────────────────────────────────────

cmd_list() {
  local filter_status="" sort_by="date"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --sort)
        sort_by="${2:-date}"
        shift 2
        ;;
      new|contacted|qualified|converted|lost)
        filter_status="$1"
        shift
        ;;
      *)
        shift
        ;;
    esac
  done

  ensure_data_dir

  local today_str
  today_str="$(today)"

  LEADS_FILE="$LEADS_FILE" FILTER_STATUS="$filter_status" SORT_BY="$sort_by" TODAY_STR="$today_str" python3 << 'PYEOF'
import json, os

leads_file = os.environ['LEADS_FILE']
status_filter = os.environ['FILTER_STATUS']
sort_by = os.environ['SORT_BY']
today_str = os.environ['TODAY_STR']

with open(leads_file, 'r') as f:
    data = json.load(f)

if status_filter:
    data = [l for l in data if l['status'] == status_filter]

if sort_by == 'score':
    data.sort(key=lambda x: x.get('score', 0), reverse=True)
else:
    data.sort(key=lambda x: x.get('created', ''), reverse=True)

if not data:
    label = f' (status: {status_filter})' if status_filter else ''
    print(f'No leads found{label}.')
    raise SystemExit(0)

status_icons = {
    'new': '🆕', 'contacted': '📧', 'qualified': '⭐',
    'converted': '🎉', 'lost': '❌'
}

title = f'Leads' + (f' [{status_filter}]' if status_filter else '') + f' (sorted by {sort_by})'
print(f'📋 {title}')
print('=' * 65)
print(f'{"ID":<12s} {"Name":<18s} {"Company":<15s} {"Score":<6s} {"Status":<10s}')
print('-' * 65)

for l in data:
    icon = status_icons.get(l['status'], '❓')
    score_bar = '█' * (l.get('score', 0) // 10) + '░' * (10 - l.get('score', 0) // 10)
    print(f'{l["id"]:<12s} {l["name"]:<18s} {l["company"]:<15s} {l.get("score", 0):<6d} {icon} {l["status"]}')

# Show upcoming follow-ups
upcoming = []
for l in data:
    for fu in l.get('follow_ups', []):
        if fu.get('date', '') >= today_str and not fu.get('done', False):
            upcoming.append((fu['date'], l['name'], l['id'], fu.get('note', '')))

if upcoming:
    upcoming.sort()
    print()
    print('📅 Upcoming follow-ups:')
    for d, name, lid, note in upcoming[:5]:
        print(f'   {d} — {name} ({lid}): {note}')

print(f'\nTotal: {len(data)} leads')
PYEOF
}

# ── cmd_score ───────────────────────────────────────────────────────

cmd_score() {
  local lead_id="${1:-}" points="${2:-}" reason="${3:-manual scoring}"

  if [[ -z "${lead_id}" || -z "${points}" ]]; then
    echo "Usage: script.sh score \"<lead_id>\" <points> [\"reason\"]"
    echo "  points: 0-100"
    exit 1
  fi

  validate_number "${points}" "points"
  ensure_data_dir

  LEADS_FILE="$LEADS_FILE" python3 << 'PYEOF' "${lead_id}" "${points}" "${reason}"
import json, sys, os

leads_file = os.environ['LEADS_FILE']
with open(leads_file, 'r') as f:
    data = json.load(f)

lead_id = sys.argv[1]
points = int(sys.argv[2])
reason = sys.argv[3]

found = False
for lead in data:
    if lead['id'] == lead_id:
        found = True
        old_score = lead.get('score', 0)
        new_score = min(100, max(0, old_score + points))
        lead['score'] = new_score

        # Auto-upgrade status based on score
        if new_score >= 60 and lead['status'] == 'new':
            lead['status'] = 'contacted'
        if new_score >= 80 and lead['status'] in ('new', 'contacted'):
            lead['status'] = 'qualified'

        lead.setdefault('notes', []).append(f'Score: {old_score} → {new_score} ({reason})')

        with open(leads_file, 'w') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)

        print(f'📊 Score updated for {lead["name"]}')
        print(f'   ID:     {lead_id}')
        print(f'   Score:  {old_score} → {new_score}')
        print(f'   Status: {lead["status"]}')
        print(f'   Reason: {reason}')
        break

if not found:
    print(f'Error: lead "{lead_id}" not found.', file=sys.stderr)
    sys.exit(1)
PYEOF
}

# ── cmd_follow_up ───────────────────────────────────────────────────

cmd_follow_up() {
  local lead_id="${1:-}" fu_date="${2:-}" note="${3:-}"

  if [[ -z "${lead_id}" || -z "${fu_date}" || -z "${note}" ]]; then
    echo "Usage: script.sh follow-up \"<lead_id>\" \"<YYYY-MM-DD>\" \"<note>\""
    exit 1
  fi

  fu_date="$(validate_date "${fu_date}")"
  ensure_data_dir

  LEADS_FILE="$LEADS_FILE" python3 << 'PYEOF' "${lead_id}" "${fu_date}" "${note}"
import json, sys, os

leads_file = os.environ['LEADS_FILE']
with open(leads_file, 'r') as f:
    data = json.load(f)

lead_id = sys.argv[1]
fu_date = sys.argv[2]
note = sys.argv[3]

found = False
for lead in data:
    if lead['id'] == lead_id:
        found = True
        fu = {'date': fu_date, 'note': note, 'done': False}
        lead.setdefault('follow_ups', []).append(fu)

        if lead['status'] == 'new':
            lead['status'] = 'contacted'

        with open(leads_file, 'w') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)

        print(f'📅 Follow-up scheduled')
        print(f'   Lead:  {lead["name"]} ({lead_id})')
        print(f'   Date:  {fu_date}')
        print(f'   Note:  {note}')
        print(f'   Status: {lead["status"]}')
        total_fu = len(lead.get('follow_ups', []))
        print(f'   Total follow-ups: {total_fu}')
        break

if not found:
    print(f'Error: lead "{lead_id}" not found.', file=sys.stderr)
    sys.exit(1)
PYEOF
}

# ── cmd_convert ─────────────────────────────────────────────────────

cmd_convert() {
  local lead_id="${1:-}" deal_value="${2:-}"

  if [[ -z "${lead_id}" ]]; then
    echo "Usage: script.sh convert \"<lead_id>\" [deal_value]"
    exit 1
  fi

  if [[ -n "${deal_value}" ]]; then
    validate_number "${deal_value}" "deal_value"
  fi

  ensure_data_dir

  LEADS_FILE="$LEADS_FILE" python3 << 'PYEOF' "${lead_id}" "${deal_value}"
import json, sys, os
from datetime import date

leads_file = os.environ['LEADS_FILE']
with open(leads_file, 'r') as f:
    data = json.load(f)

lead_id = sys.argv[1]
deal_value = sys.argv[2] if len(sys.argv) > 2 and sys.argv[2] else None

found = False
for lead in data:
    if lead['id'] == lead_id:
        found = True
        if lead['status'] == 'converted':
            print(f'⚠️  Lead {lead_id} is already converted.')
            sys.exit(0)

        old_status = lead['status']
        lead['status'] = 'converted'
        lead['converted_date'] = str(date.today())
        if deal_value:
            lead['deal_value'] = float(deal_value)

        lead.setdefault('notes', []).append(f'Converted from {old_status}')

        with open(leads_file, 'w') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)

        print(f'🎉 Lead converted!')
        print(f'   Name:    {lead["name"]}')
        print(f'   Company: {lead["company"]}')
        print(f'   From:    {old_status} → converted')
        if deal_value:
            print(f'   Deal:    ${float(deal_value):,.2f}')
        break

if not found:
    print(f'Error: lead "{lead_id}" not found.', file=sys.stderr)
    sys.exit(1)
PYEOF
}

# ── cmd_pipeline ────────────────────────────────────────────────────

cmd_pipeline() {
  local month="${1:-}"
  if [[ -z "${month}" ]]; then
    month="$(current_month)"
  fi

  ensure_data_dir

  LEADS_FILE="$LEADS_FILE" MONTH="$month" python3 << 'PYEOF'
import json, os

leads_file = os.environ['LEADS_FILE']
month = os.environ['MONTH']

with open(leads_file, 'r') as f:
    data = json.load(f)

filtered = [l for l in data if l.get('created', '').startswith(month)]

statuses = ['new', 'contacted', 'qualified', 'converted', 'lost']
status_icons = {
    'new': '🆕', 'contacted': '📧', 'qualified': '⭐',
    'converted': '🎉', 'lost': '❌'
}
counts = {}
for s in statuses:
    counts[s] = len([l for l in filtered if l['status'] == s])

total = len(filtered)
total_deal = sum(l.get('deal_value', 0) or 0 for l in filtered if l['status'] == 'converted')

print(f'📊 Pipeline Report — {month}')
print('=' * 50)

if total == 0:
    print('  No leads found for this period.')
    raise SystemExit(0)

# Funnel visualization
max_bar = 30
for s in statuses:
    c = counts[s]
    pct = (c / total * 100) if total else 0
    bar_len = int(pct / 100 * max_bar)
    bar = '█' * bar_len + '░' * (max_bar - bar_len)
    icon = status_icons.get(s, '❓')
    print(f'  {icon} {s:<12s} {bar} {c:>3d} ({pct:.0f}%)')

print()
print(f'  Total leads:     {total}')
converted = counts['converted']
if converted:
    conv_rate = converted / total * 100
    print(f'  Converted:       {converted} ({conv_rate:.1f}%)')
    print(f'  Total deal value: ${total_deal:,.2f}')
    if converted > 0:
        avg_deal = total_deal / converted
        print(f'  Avg deal value:   ${avg_deal:,.2f}')

lost = counts['lost']
if lost:
    loss_rate = lost / total * 100
    print(f'  Lost:            {lost} ({loss_rate:.1f}%)')

active = counts['new'] + counts['contacted'] + counts['qualified']
if active:
    print(f'  Active pipeline: {active}')

# Score distribution
scores = [l.get('score', 0) for l in filtered]
if scores:
    avg_score = sum(scores) / len(scores)
    print(f'  Avg lead score:  {avg_score:.0f}/100')

# Source breakdown
sources = {}
for l in filtered:
    src = l.get('source', 'unknown')
    sources[src] = sources.get(src, 0) + 1

if sources:
    print()
    print('  Lead sources:')
    for src, cnt in sorted(sources.items(), key=lambda x: x[1], reverse=True):
        print(f'    {src:<15s}: {cnt}')
PYEOF
}

# ── cmd_help ────────────────────────────────────────────────────────

cmd_help() {
  cat <<'EOF'
leads — Sales Lead CRM

Commands:
  add "<name>" "<email>" "<company>" [source]      Add a new lead
  list [status] [--sort score|date]                 View leads
  score "<lead_id>" <points> ["reason"]             Score a lead (0-100)
  follow-up "<lead_id>" "<YYYY-MM-DD>" "<note>"     Schedule follow-up
  convert "<lead_id>" [deal_value]                  Mark as converted
  pipeline [YYYY-MM]                                Sales funnel report
  help                                              Show this help message

Statuses: new → contacted → qualified → converted / lost
Data stored in: ~/.leads/
EOF
}

# ── main dispatch ───────────────────────────────────────────────────

main() {
  local cmd="${1:-help}"
  shift || true

  case "${cmd}" in
    add)       cmd_add "$@" ;;
    list)      cmd_list "$@" ;;
    score)     cmd_score "$@" ;;
    follow-up) cmd_follow_up "$@" ;;
    convert)   cmd_convert "$@" ;;
    pipeline)  cmd_pipeline "$@" ;;
    help|--help|-h) cmd_help ;;
    *)
      echo "Unknown command: ${cmd}" >&2
      cmd_help
      exit 1
      ;;
  esac
}

main "$@"
