#!/usr/bin/env bash
# debugger — Error analyzer and fix suggester
set -euo pipefail

CMD="${1:-help}"
shift || true
INPUT="${*:-}"

PATTERNS_FILE="/tmp/debug-patterns.json"

init_patterns() {
python3 << 'PYEOF'
import json
patterns = [
    {"pattern": "TypeError: 'NoneType'", "lang": "Python", "cause": "Variable is None when a value was expected", "fix": "Add a None check before using the variable: if var is not None:"},
    {"pattern": "ModuleNotFoundError", "lang": "Python", "cause": "Module not installed or wrong environment", "fix": "Run: pip install <module_name> or activate the correct virtualenv"},
    {"pattern": "IndentationError", "lang": "Python", "cause": "Mixed tabs and spaces or wrong indentation level", "fix": "Use consistent 4-space indentation. Run: python -m tabnanny script.py"},
    {"pattern": "KeyError", "lang": "Python", "cause": "Dictionary key does not exist", "fix": "Use dict.get(key, default) or check 'if key in dict' before access"},
    {"pattern": "ImportError", "lang": "Python", "cause": "Cannot import name from module", "fix": "Check spelling, ensure package is installed, check __init__.py"},
    {"pattern": "ECONNREFUSED", "lang": "Node/System", "cause": "Connection refused — target service is not running or wrong port", "fix": "Check the service is running: systemctl status <service> or netstat -tlnp"},
    {"pattern": "ENOENT", "lang": "Node/System", "cause": "File or directory does not exist", "fix": "Check the path exists: ls -la <path>. Check for typos in the filename"},
    {"pattern": "EACCES", "lang": "Node/System", "cause": "Permission denied", "fix": "Check file permissions: chmod 644 <file> or run with appropriate user"},
    {"pattern": "Cannot find module", "lang": "Node", "cause": "npm module not installed", "fix": "Run: npm install <module> or npm install in project root"},
    {"pattern": "SyntaxError: Unexpected token", "lang": "Node/JS", "cause": "JavaScript syntax error", "fix": "Check for missing brackets, commas, or semicolons near the indicated line"},
    {"pattern": "panic: runtime error", "lang": "Go", "cause": "Runtime panic — nil pointer or index out of bounds", "fix": "Add nil checks before dereferencing pointers. Check slice bounds"},
    {"pattern": "undefined: ", "lang": "Go", "cause": "Symbol not defined in scope", "fix": "Check import paths, spelling, and that the package is in go.mod"},
    {"pattern": "command not found", "lang": "Bash", "cause": "Command not installed or not in PATH", "fix": "Install the command or add its directory to PATH: export PATH=$PATH:/path/to/bin"},
    {"pattern": "No such file or directory", "lang": "Bash", "cause": "File or path does not exist", "fix": "Check the path with: ls -la <path>. Ensure working directory is correct"},
    {"pattern": "Permission denied", "lang": "Bash", "cause": "Insufficient permissions to access file or execute command", "fix": "Use chmod to fix permissions or prefix with sudo if appropriate"},
    {"pattern": "OOMKilled", "lang": "Docker/K8s", "cause": "Container killed due to out of memory", "fix": "Increase memory limits in container spec or optimize application memory usage"},
    {"pattern": "CrashLoopBackOff", "lang": "Kubernetes", "cause": "Container keeps crashing and restarting", "fix": "Check logs: kubectl logs <pod> --previous. Fix the application startup error"},
    {"pattern": "ImagePullBackOff", "lang": "Kubernetes", "cause": "Cannot pull container image", "fix": "Check image name/tag, registry credentials: kubectl describe pod <pod>"},
    {"pattern": "fatal: not a git repository", "lang": "Git", "cause": "Not inside a git repository", "fix": "Run: git init or cd to the correct directory"},
    {"pattern": "CONFLICT", "lang": "Git", "cause": "Merge conflict in files", "fix": "Edit conflicted files, remove conflict markers, then: git add <file> && git commit"},
    {"pattern": "Connection refused.*5432", "lang": "PostgreSQL", "cause": "PostgreSQL not running or wrong port", "fix": "Start PostgreSQL: systemctl start postgresql or check pg_hba.conf"},
    {"pattern": "Access denied for user", "lang": "MySQL", "cause": "Wrong MySQL credentials or insufficient privileges", "fix": "Check username/password. Grant privileges: GRANT ALL ON db.* TO user@host"},
    {"pattern": "SSL certificate problem", "lang": "curl/HTTP", "cause": "SSL certificate verification failed", "fix": "Update CA certificates: apt-get install ca-certificates or use --insecure for testing only"},
    {"pattern": "Too many open files", "lang": "System", "cause": "File descriptor limit exceeded", "fix": "Increase ulimit: ulimit -n 65536 or set in /etc/security/limits.conf"},
]
with open("/tmp/debug-patterns.json", "w") as f:
    json.dump(patterns, f)
print(f"Loaded {len(patterns)} error patterns")
PYEOF
}

do_analyze() {
    local input="$1"
    local text
    if [ -f "$input" ]; then
        text=$(cat "$input")
    else
        text="$input"
    fi
    DBG_TEXT="$text" python3 << 'PYEOF'
import json, re, sys, os

text = os.environ.get("DBG_TEXT", "")
with open("/tmp/debug-patterns.json") as f:
    patterns = json.load(f)

matches = []
for p in patterns:
    if p["pattern"].lower() in text.lower():
        matches.append(p)

if not matches:
    print("⚠️  No known error patterns matched.")
    print("Try: debugger explain '<error message>' for specific error codes")
    sys.exit(0)

print(f"🔍 Found {len(matches)} matching pattern(s):\n")
for i, m in enumerate(matches, 1):
    print(f"{'='*50}")
    print(f"Match {i}: [{m['lang']}] {m['pattern']}")
    print(f"  Cause:  {m['cause']}")
    print(f"  Fix:    {m['fix']}")
print(f"{'='*50}")
PYEOF
}

do_explain() {
    local query="$1"
    DBG_QUERY="$query" python3 << 'PYEOF'
import json, os

query = os.environ.get("DBG_QUERY", "")
with open("/tmp/debug-patterns.json") as f:
    patterns = json.load(f)

matches = [p for p in patterns if query.lower() in p["pattern"].lower() or query.lower() in p["cause"].lower()]

if not matches:
    print(f"❓ No explanation found for: {query}")
    print("Common error codes: ECONNREFUSED ENOENT EACCES EPERM ETIMEDOUT EADDRINUSE")
else:
    for m in matches:
        print(f"\n📖 [{m['lang']}] {m['pattern']}")
        print(f"   Meaning: {m['cause']}")
        print(f"   Fix:     {m['fix']}")
PYEOF
}

do_suggest() {
    local input="$1"
    local text
    if [ -f "$input" ]; then
        text=$(tail -50 "$input")
    else
        text="$input"
    fi

    echo "💡 Fix Suggestions:"
    echo ""
    DBG_TEXT="$text" python3 << 'PYEOF'
import json, os

text = os.environ.get("DBG_TEXT", "")
with open("/tmp/debug-patterns.json") as f:
    patterns = json.load(f)

suggestions = []
for p in patterns:
    if p["pattern"].lower() in text.lower():
        suggestions.append(f"  → [{p['lang']}] {p['fix']}")

if suggestions:
    for s in suggestions:
        print(s)
else:
    print("  → No specific suggestions. Try:")
    print("    1. Check the full stack trace for the root error")
    print("    2. Search the error message online")
    print("    3. Run with verbose/debug flags (-v, --debug, -x for bash)")
    print("    4. Check recent changes: git diff HEAD~1")
PYEOF
}

show_help() {
    echo "debug — Error analyzer and fix suggester"
    echo ""
    echo "Usage:"
    echo "  debug analyze <error_text_or_file>   Analyze error and find root cause"
    echo "  debug explain <error_code_or_message> Explain what an error means"
    echo "  debug suggest <error_text_or_file>   Get fix suggestions"
    echo ""
    echo "Examples:"
    echo "  debug analyze \"TypeError: 'NoneType' object is not subscriptable\""
    echo "  debug explain ECONNREFUSED"
    echo "  debug suggest error.log"
    echo ""
}

init_patterns

case "$CMD" in
    analyze) do_analyze "$INPUT" ;;
    explain) do_explain "$INPUT" ;;
    suggest) do_suggest "$INPUT" ;;
    help|--help|-h) show_help ;;
    *) echo "Unknown command: $CMD"; show_help; exit 1 ;;
esac
