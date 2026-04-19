#!/usr/bin/env bash
# supabase-tool — Generate Supabase API curl commands and SQL helpers
set -euo pipefail

cmd_query() {
    local sql="${1:-SELECT version()}"
    cat << EOF
# Run SQL query against your Supabase project
# Replace YOUR_PROJECT_REF, YOUR_ACCESS_TOKEN, and YOUR_SQL:

curl -s -X POST "https://api.supabase.com/v1/projects/YOUR_PROJECT_REF/database/query" \\
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \\
  -H "Content-Type: application/json" \\
  -d '{"query": "$sql"}' | python3 -m json.tool

EOF
}

cmd_select() {
    local table="${1:-your_table}"; shift || true
    local limit=20; local filter=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --limit) limit="$2"; shift 2 ;;
            --filter) filter="&${2}"; shift 2 ;;
            *) shift ;;
        esac
    done
    cat << EOF
# Query table: $table (limit $limit)

curl -s "https://YOUR_PROJECT_REF.supabase.co/rest/v1/$table?limit=$limit${filter}" \\
  -H "apikey: YOUR_ANON_KEY" \\
  -H "Authorization: Bearer YOUR_ANON_KEY" | python3 -m json.tool

EOF
}

cmd_count() {
    local table="${1:-your_table}"
    cat << EOF
# Count rows in table: $table

curl -s "https://YOUR_PROJECT_REF.supabase.co/rest/v1/$table?select=*" \\
  -H "apikey: YOUR_ANON_KEY" \\
  -H "Authorization: Bearer YOUR_ANON_KEY" \\
  -H "Prefer: count=exact" \\
  -I | grep -i content-range

EOF
}

cmd_insert() {
    local table="${1:-your_table}"; local data="${2:-'{\"key\": \"value\"}'}"
    cat << EOF
# Insert record into table: $table

curl -s -X POST "https://YOUR_PROJECT_REF.supabase.co/rest/v1/$table" \\
  -H "apikey: YOUR_ANON_KEY" \\
  -H "Authorization: Bearer YOUR_ANON_KEY" \\
  -H "Content-Type: application/json" \\
  -H "Prefer: return=representation" \\
  -d '$data' | python3 -m json.tool

EOF
}

cmd_health() {
    cat << 'EOF'
# Check Supabase REST API health

curl -s "https://YOUR_PROJECT_REF.supabase.co/rest/v1/" \
  -H "apikey: YOUR_ANON_KEY" \
  -o /dev/null -w "HTTP %{http_code} | Time: %{time_total}s\n"

# Check Auth API health
curl -s "https://YOUR_PROJECT_REF.supabase.co/auth/v1/health"

EOF
}

cmd_rls() {
    cat << 'EOF'
# Check RLS policy issues via Security Advisor API

curl -s "https://api.supabase.com/v1/projects/YOUR_PROJECT_REF/advisors/security" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" | \
  python3 -c "
import sys, json
data = json.load(sys.stdin)
lints = data.get('lints', [])
print(f'Security issues: {len(lints)}')
for l in lints:
    level = l.get('level','?')
    icon = {'ERROR':'🔴','WARN':'🟡','INFO':'🔵'}.get(level,'⚪')
    print(icon, l.get('title',''), '—', l.get('detail','')[:80])
"

EOF
}

cmd_tables() {
    cat << 'EOF'
# List all public tables in your Supabase project

curl -s -X POST "https://api.supabase.com/v1/projects/YOUR_PROJECT_REF/database/query" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query": "SELECT table_name FROM information_schema.tables WHERE table_schema='"'"'public'"'"' ORDER BY table_name"}' | \
  python3 -c "import sys,json; [print(r['table_name']) for r in json.load(sys.stdin)]"

EOF
}

cmd_config() {
    cat << 'EOF'
# Supabase connection details — find these in your project dashboard:
# https://app.supabase.com/project/YOUR_PROJECT_REF/settings/api

# Project URL:       https://YOUR_PROJECT_REF.supabase.co
# Anon key:          eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...  (safe for client use)
# Access token:      sbp_xxx  (for management API — from https://supabase.com/dashboard/account/tokens)

# Quick test:
# curl -s "https://YOUR_PROJECT_REF.supabase.co/rest/v1/" -H "apikey: YOUR_ANON_KEY"
EOF
}

cmd_help() {
    cat << 'EOF'
supabase-tool — Generate Supabase API curl commands and SQL helpers

Commands:
  query   "<SQL>"               Generate SQL query command
  select  <table> [options]     Generate table select command
  count   <table>               Generate row count command
  insert  <table> '<json>'      Generate record insert command
  health                        Generate health check commands
  rls                           Generate RLS audit command
  tables                        Generate table listing command
  config                        Show where to find your Supabase credentials
  help                          Show this help

Options for select:
  --limit N          Limit rows (default: 20)
  --filter col=val   Filter rows (e.g. --filter is_ours=eq.true)

Examples:
  bash scripts/script.sh select skills --limit 5
  bash scripts/script.sh count posts
  bash scripts/script.sh query "SELECT COUNT(*) FROM users"
  bash scripts/script.sh health

No credentials stored. Commands are generated for you to run.
Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    query)  shift; cmd_query "$@" ;;
    select) shift; cmd_select "$@" ;;
    count)  shift; cmd_count "$@" ;;
    insert) shift; cmd_insert "$@" ;;
    health) cmd_health ;;
    rls)    cmd_rls ;;
    tables) cmd_tables ;;
    config) cmd_config ;;
    help|*) cmd_help ;;
esac
