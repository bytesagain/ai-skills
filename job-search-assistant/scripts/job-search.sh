#!/bin/bash
# job-search-assistant — Job Search Toolkit
# Original implementation by BytesAgain

DATA_DIR="${HOME}/.job-search"
mkdir -p "$DATA_DIR"
APPS_FILE="$DATA_DIR/applications.json"
[ -f "$APPS_FILE" ] || echo '[]' > "$APPS_FILE"

show_help() {
    cat << 'HELP'
Job Search Assistant — Track applications & prep for interviews

Commands:
  add       Log a job application
  list      Show all applications
  status    Application pipeline stats
  update    Update application status
  resume    Generate tailored resume tips
  cover     Generate cover letter outline
  prep      Interview preparation guide
  salary    Salary research helper
  help      Show this help

Usage:
  job-search.sh add "Software Engineer" --company "Google" --url "https://..."
  job-search.sh list
  job-search.sh update <id> interviewing
  job-search.sh resume "Python developer with 5 years experience"
  job-search.sh prep "frontend interview"
HELP
}

cmd_add() {
    local title="" company="" url="" location="remote"
    while [ $# -gt 0 ]; do
        case "$1" in
            --company) company="$2"; shift 2 ;;
            --url) url="$2"; shift 2 ;;
            --location) location="$2"; shift 2 ;;
            *) title="$title $1"; shift ;;
        esac
    done
    title=$(echo "$title" | sed 's/^ //')
    [ -z "$title" ] && { echo "Usage: add <job title> --company <name>"; return 1; }
    
    local id=$(date +%s | tail -c 6)
    python3 -c "
import json
with open('$APPS_FILE') as f: apps = json.load(f)
apps.append({
    'id': '$id', 'title': '''$title''', 'company': '''$company''',
    'url': '$url', 'location': '$location',
    'status': 'applied', 'applied_date': '$(date +%Y-%m-%d)',
    'notes': ''
})
with open('$APPS_FILE','w') as f: json.dump(apps, f, indent=2)
print('  Added: $title @ $company (ID: $id)')
"
}

cmd_list() {
    python3 -c "
import json
with open('$APPS_FILE') as f: apps = json.load(f)
if not apps:
    print('No applications yet. Use \"add\" to start tracking.')
else:
    status_emoji = {'applied':'📤','interviewing':'🎤','offered':'🎉','rejected':'❌','accepted':'✅','withdrawn':'⏸️'}
    print('{:6s} {:20s} {:15s} {:12s} {:10s}'.format('ID','Title','Company','Status','Date'))
    print('-' * 65)
    for a in apps:
        e = status_emoji.get(a['status'],'📋')
        print('{} {:6s} {:20s} {:15s} {:12s} {:10s}'.format(e, a['id'], a['title'][:20], a['company'][:15], a['status'], a['applied_date']))
"
}

cmd_status() {
    python3 -c "
import json
from collections import Counter
with open('$APPS_FILE') as f: apps = json.load(f)
st = Counter(a['status'] for a in apps)
total = len(apps)
print('Application Pipeline:')
for status in ['applied','interviewing','offered','accepted','rejected','withdrawn']:
    cnt = st.get(status, 0)
    bar = '█' * cnt
    if cnt > 0: print('  {:15s} {} {}'.format(status, bar, cnt))
print('')
print('Total: {} applications'.format(total))
if total > 0:
    rate = st.get('interviewing',0) + st.get('offered',0) + st.get('accepted',0)
    print('Response rate: {:.0f}%'.format(rate/total*100))
"
}

cmd_update() {
    local target_id="$1" new_status="$2"
    [ -z "$target_id" ] || [ -z "$new_status" ] && { echo "Usage: update <id> <status>"; echo "Statuses: applied, interviewing, offered, accepted, rejected, withdrawn"; return 1; }
    python3 -c "
import json
with open('$APPS_FILE') as f: apps = json.load(f)
found = False
for a in apps:
    if a['id'] == '$target_id':
        a['status'] = '$new_status'
        found = True
        print('  Updated: {} @ {} → {}'.format(a['title'], a['company'], '$new_status'))
        break
if not found: print('  Not found: $target_id')
with open('$APPS_FILE','w') as f: json.dump(apps, f, indent=2)
"
}

cmd_resume() {
    local profile="$*"
    [ -z "$profile" ] && { echo "Usage: resume <your profile summary>"; return 1; }
    cat << EOF
Resume Tips for: $profile

Structure:
  1. Contact Info — Name, email, phone, LinkedIn, portfolio
  2. Summary — 2-3 sentences highlighting key strengths
  3. Experience — Reverse chronological, use action verbs
  4. Skills — Technical skills, tools, languages
  5. Education — Degree, university, year
  
Action Verb Starters:
  • Led, Developed, Implemented, Designed, Optimized
  • Reduced, Increased, Automated, Migrated, Scaled
  
Tips:
  • Quantify achievements (increased revenue by 30%)
  • Tailor to each job description
  • Keep to 1-2 pages maximum
  • Use ATS-friendly formatting (no tables/graphics)
  • Include keywords from job posting
EOF
}

cmd_cover() {
    local role="$*"
    [ -z "$role" ] && { echo "Usage: cover <job title and company>"; return 1; }
    cat << EOF
Cover Letter Outline for: $role

Paragraph 1 — Hook:
  "I'm excited to apply for [role] at [company] because..."
  • Mention specific company project/value that resonates
  
Paragraph 2 — Why You:
  • 2-3 relevant achievements with metrics
  • Connect your experience to their requirements
  
Paragraph 3 — Why Them:
  • Show you've researched the company
  • Explain cultural/mission alignment
  
Closing:
  • Express enthusiasm for interview
  • Thank them for consideration
  
Tips:
  • Keep under 300 words
  • Match the tone of the job posting
  • Address to hiring manager by name if possible
EOF
}

cmd_prep() {
    local topic="${*:-general}"
    cat << EOF
Interview Prep Guide: $topic

Before Interview:
  □ Research company (mission, products, recent news)
  □ Review job description keywords
  □ Prepare 5 STAR stories (Situation, Task, Action, Result)
  □ Prepare 3-5 questions to ask them
  □ Test your tech setup (camera, mic, internet)

Common Questions:
  1. Tell me about yourself (2-min pitch)
  2. Why this company/role?
  3. Biggest achievement?
  4. How do you handle conflict?
  5. Where do you see yourself in 5 years?
  
Technical Prep:
  • Review fundamentals of your stack
  • Practice coding problems (if applicable)
  • Prepare system design examples
  • Review your own past projects
  
Day Of:
  • Join 5 minutes early
  • Have resume and notes ready
  • Dress one level above company culture
  • Follow up with thank-you email within 24h
EOF
}

cmd_salary() {
    local role="${*:-software engineer}"
    cat << EOF
Salary Research: $role

Research Sources:
  • levels.fyi — Tech company compensation
  • glassdoor.com — Salary reports by company
  • payscale.com — Market rate data
  • LinkedIn Salary — Role-based ranges
  
Negotiation Framework:
  1. Know your market rate (research 3+ sources)
  2. Consider total comp (base + bonus + equity + benefits)
  3. Let them make the first offer
  4. Counter with data: "Market rate for [role] in [city] is..."
  5. Get the offer in writing before accepting
  
Red Flags:
  • Won't discuss salary range upfront
  • Below market by >15%
  • "We'll revisit in 6 months"
  • Equity with no vesting schedule details
EOF
}

case "${1:-help}" in
    add)    shift; cmd_add "$@" ;;
    list)   cmd_list ;;
    status) cmd_status ;;
    update) cmd_update "$2" "$3" ;;
    resume) shift; cmd_resume "$@" ;;
    cover)  shift; cmd_cover "$@" ;;
    prep)   shift; cmd_prep "$@" ;;
    salary) shift; cmd_salary "$@" ;;
    help)   show_help ;;
    *)      echo "Unknown: $1"; show_help ;;
esac
