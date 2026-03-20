#!/usr/bin/env bash
# job-search-assistant — Job search tracker and career toolkit
set -euo pipefail
VERSION="2.0.0"
DATA_DIR="${JOB_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/job-search-assistant}"
DB="$DATA_DIR/applications.txt"
mkdir -p "$DATA_DIR"

show_help() {
    cat << EOF
job-search-assistant v$VERSION — Job search and career toolkit

Usage: job-search-assistant <command> [args]

Track:
  add <company> <role> [status]    Add application
  update <company> <status>        Update status
  list [status]                    List applications
  stats                            Statistics

Prepare:
  resume <role>                    Resume tips
  cover-letter <company> <role>    Cover letter template
  interview <type>                 Prep (behavioral/technical)
  questions <role>                 Common questions
  negotiate                        Salary negotiation tips

Research:
  red-flags                        Job posting red flags
  weekly-plan                      Weekly search plan
  help                             Show this help
EOF
}

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

cmd_add() {
    local company="${1:?Usage: job-search-assistant add <company> <role>}"
    local role="${2:?}"
    local status="${3:-applied}"
    echo "$(date +%Y-%m-%d)|$company|$role|$status" >> "$DB"
    echo "  Added: $company - $role ($status)"
}

cmd_update() {
    local company="${1:?}"
    local status="${2:?}"
    [ -f "$DB" ] || { echo "No data"; return; }
    sed -i "s/|$company|\\(.*\\)|.*/|$company|\\1|$status/" "$DB"
    echo "  Updated: $company -> $status"
}

cmd_list() {
    local filter="${1:-}"
    echo "  === Applications ==="
    [ -f "$DB" ] || { echo "  (empty)"; return; }
    printf "  %-12s %-18s %-18s %s\n" "DATE" "COMPANY" "ROLE" "STATUS"
    echo "  $(printf '%.0s-' {1..55})"
    while IFS='|' read -r date company role status; do
        [ -n "$filter" ] && [ "$status" != "$filter" ] && continue
        printf "  %-12s %-18s %-18s %s\n" "$date" "$company" "$role" "$status"
    done < "$DB"
}

cmd_stats() {
    [ -f "$DB" ] || { echo "  No data"; return; }
    local total=$(wc -l < "$DB")
    echo "  === Stats ==="
    echo "  Total: $total"
    for s in applied interview offer rejected; do
        local c=$(grep -c "|$s" "$DB" 2>/dev/null || echo 0)
        echo "  $s: $c"
    done
}

cmd_resume() {
    echo "  === Resume Tips ==="
    echo "  1. One page max (2 for 10+ years)"
    echo "  2. Quantify: Led, Built, Increased X by Y%"
    echo "  3. Tailor to each job posting"
    echo "  4. Action verbs, not passive"
    echo "  5. No typos (proofread 3x)"
    echo "  6. ATS-friendly format (no tables)"
}

cmd_cover_letter() {
    local company="${1:?}"
    local role="${2:?}"
    echo "  === Cover Letter: $role at $company ==="
    echo ""
    echo "  Dear Hiring Manager,"
    echo ""
    echo "  I am writing to express my interest in the $role"
    echo "  position at $company. [Why this company specifically]."
    echo ""
    echo "  [Paragraph 2: Your relevant experience + impact]"
    echo ""
    echo "  [Paragraph 3: Why you are a great fit]"
    echo ""
    echo "  I look forward to discussing how I can contribute."
    echo "  Best regards, [Your Name]"
}

cmd_interview() {
    local type="${1:-behavioral}"
    echo "  === Interview Prep: $type ==="
    case "$type" in
        behavioral)
            echo "  STAR Method: Situation, Task, Action, Result"
            echo "  Prepare stories for:"
            echo "  - Leadership / initiative"
            echo "  - Conflict resolution"
            echo "  - Failure and recovery"
            echo "  - Teamwork" ;;
        technical)
            echo "  1. Review fundamentals"
            echo "  2. Practice coding (LeetCode)"
            echo "  3. System design for senior roles"
            echo "  4. Know your resume projects deeply" ;;
        *) echo "  Types: behavioral, technical" ;;
    esac
}

cmd_negotiate() {
    echo "  === Salary Negotiation ==="
    echo "  1. Research market rate first"
    echo "  2. Never give a number first"
    echo "  3. Counter 10-20% above offer"
    echo "  4. Total comp = base+bonus+equity+benefits"
    echo "  5. Get it in writing"
    echo "  6. Negotiate perks too (WFH, PTO)"
}

cmd_red_flags() {
    echo "  === Red Flags ==="
    echo "  - 'We are like a family'"
    echo "  - 'Must be passionate' (= low pay)"
    echo "  - Vague job description"
    echo "  - No salary range"
    echo "  - Extremely long interview"
    echo "  - High turnover on LinkedIn"
}

cmd_weekly_plan() {
    echo "  === Weekly Job Search Plan ==="
    echo "  Mon: Update resume, search new postings"
    echo "  Tue: Apply to 3-5 jobs"
    echo "  Wed: Networking (LinkedIn, events)"
    echo "  Thu: Apply to 3-5 jobs"
    echo "  Fri: Follow up on applications"
    echo "  Goal: 10+ applications per week"
}

case "${1:-help}" in
    add)          shift; cmd_add "$@" ;;
    update)       shift; cmd_update "$@" ;;
    list)         shift; cmd_list "${1:-}" ;;
    stats)        cmd_stats ;;
    resume)       shift; cmd_resume ;;
    cover-letter) shift; cmd_cover_letter "$@" ;;
    interview)    shift; cmd_interview "$@" ;;
    questions)    shift; echo "  Search: '$1 interview questions' on Glassdoor" ;;
    negotiate)    cmd_negotiate ;;
    red-flags)    cmd_red_flags ;;
    weekly-plan)  cmd_weekly_plan ;;
    help|-h)      show_help ;;
    version|-v)   echo "job-search-assistant v$VERSION" ;;
    *)            echo "Unknown: $1"; show_help; exit 1 ;;
esac
