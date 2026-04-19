#!/usr/bin/env bash
# vercel-tool — Generate Vercel API curl commands and manage local deployment configs
set -euo pipefail

VERCEL_API="https://api.vercel.com"

cmd_status() {
    local project="${1:-}"
    [[ -z "$project" ]] && { echo "Usage: status <project-name>"; exit 1; }
    cat << EOF
# Check deployment status for: $project
# Run this command (replace YOUR_TOKEN with your Vercel token):

curl -s "$VERCEL_API/v9/projects/$project" \\
  -H "Authorization: Bearer YOUR_TOKEN" | \\
  python3 -c "
import sys, json
d = json.load(sys.stdin)
deps = d.get('latestDeployments', [])
if deps:
    dep = deps[0]
    print('State:  ', dep.get('readyState'))
    print('URL:    ', 'https://' + dep.get('url',''))
    print('Branch: ', dep.get('meta',{}).get('githubCommitRef',''))
"

EOF
}

cmd_list() {
    local limit="${1:-10}"
    cat << EOF
# List recent $limit deployments
# Run this command:

curl -s "$VERCEL_API/v6/deployments?limit=$limit" \\
  -H "Authorization: Bearer YOUR_TOKEN" | \\
  python3 -c "
import sys, json
from datetime import datetime, timezone
data = json.load(sys.stdin)
for d in data.get('deployments', []):
    ts = datetime.fromtimestamp(d.get('createdAt',0)//1000, tz=timezone.utc).strftime('%m-%d %H:%M')
    state = d.get('readyState','?')
    icon = {'READY':'✅','ERROR':'❌','BUILDING':'🔨'}.get(state,'❓')
    print(icon, ts, d.get('name',''), state)
"

EOF
}

cmd_logs() {
    local project="${1:-}"; local dep_id="${2:-latest}"
    [[ -z "$project" ]] && { echo "Usage: logs <project-name> [deployment-id]"; exit 1; }
    cat << EOF
# Step 1: Get latest deployment ID for $project
curl -s "$VERCEL_API/v9/projects/$project" \\
  -H "Authorization: Bearer YOUR_TOKEN" | \\
  python3 -c "import sys,json; d=json.load(sys.stdin); print(d['latestDeployments'][0]['uid'])"

# Step 2: Get build logs (replace DEP_ID with result above)
curl -s "$VERCEL_API/v2/deployments/DEP_ID/events" \\
  -H "Authorization: Bearer YOUR_TOKEN"

EOF
}

cmd_domains() {
    local project="${1:-}"
    [[ -z "$project" ]] && { echo "Usage: domains <project-name>"; exit 1; }
    cat << EOF
# Check domain and SSL status for: $project

curl -s "$VERCEL_API/v9/projects/$project/domains" \\
  -H "Authorization: Bearer YOUR_TOKEN" | \\
  python3 -c "
import sys, json
data = json.load(sys.stdin)
for d in data.get('domains', []):
    verified = '✅' if d.get('verified') else '❌'
    ssl = d.get('ssl', {})
    ssl_state = ssl.get('state','?') if isinstance(ssl, dict) else '?'
    ssl_icon = '🔒' if ssl_state == 'ISSUED' else '⚠️'
    print(verified, ssl_icon, d.get('name'), '| SSL:', ssl_state)
"

EOF
}

cmd_rollback() {
    local project="${1:-}"; local dep_id="${2:-}"
    [[ -z "$project" || -z "$dep_id" ]] && { echo "Usage: rollback <project-name> <deployment-id>"; exit 1; }
    cat << EOF
# Rollback $project to deployment $dep_id

curl -s -X POST "$VERCEL_API/v9/projects/$project/promote/$dep_id" \\
  -H "Authorization: Bearer YOUR_TOKEN" \\
  -H "Content-Type: application/json"

EOF
}

cmd_env() {
    local project="${1:-}"; local target="${2:-production}"
    [[ -z "$project" ]] && { echo "Usage: env <project-name> [production|preview|development]"; exit 1; }
    cat << EOF
# List $target environment variables for: $project

curl -s "$VERCEL_API/v9/projects/$project/env" \\
  -H "Authorization: Bearer YOUR_TOKEN" | \\
  python3 -c "
import sys, json
data = json.load(sys.stdin)
envs = [e for e in data.get('envs', []) if '$target' in e.get('target', [])]
print(f'$target env vars ({len(envs)}):')
for e in envs:
    print(' ', e.get('key'), '|', e.get('type'))
"

EOF
}

cmd_deploy() {
    cat << 'EOF'
# Trigger a new Vercel deployment by pushing to git:
#   git add . && git commit -m "deploy" && git push

# Or use Vercel CLI:
#   npm i -g vercel
#   vercel --prod

EOF
}

cmd_config() {
    cat << 'EOF'
# Quick setup — add to your shell profile (~/.bashrc or ~/.zshrc):
export VERCEL_TOKEN=your_token_here

# Get your token at: https://vercel.com/account/tokens
# Then replace YOUR_TOKEN in any command above with: $VERCEL_TOKEN
EOF
}

cmd_help() {
    cat << 'EOF'
vercel-tool — Generate Vercel API commands for deployment management

Commands:
  status  <project>              Show curl command to check deployment status
  list    [limit]                Show curl command to list recent deployments
  logs    <project>              Show curl commands to view build logs
  domains <project>              Show curl command to check domains & SSL
  rollback <project> <dep-id>   Show curl command to rollback deployment
  env     <project> [target]     Show curl command to list env vars
  deploy                         Show how to trigger a new deployment
  config                         Show how to set up your Vercel token
  help                           Show this help

Usage:
  bash scripts/script.sh status my-project
  bash scripts/script.sh list 20
  bash scripts/script.sh domains my-project

No API credentials stored. Commands are generated for you to run.
Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    status)   shift; cmd_status "$@" ;;
    list)     shift; cmd_list "$@" ;;
    logs)     shift; cmd_logs "$@" ;;
    domains)  shift; cmd_domains "$@" ;;
    rollback) shift; cmd_rollback "$@" ;;
    env)      shift; cmd_env "$@" ;;
    deploy)   cmd_deploy ;;
    config)   cmd_config ;;
    help|*)   cmd_help ;;
esac
