#!/usr/bin/env bash
# snippet — Code snippet manager
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="3.0.1"
DATA_DIR="${SNIPPET_DIR:-$HOME/.local/share/snippet}"
DB="$DATA_DIR/snippets.jsonl"
mkdir -p "$DATA_DIR"

BOLD='\033[1m'; GREEN='\033[0;32m'; RED='\033[0;31m'; DIM='\033[2m'; RESET='\033[0m'
die() { echo -e "${RED}Error: $1${RESET}" >&2; exit 1; }
info() { echo -e "${GREEN}✓${RESET} $1"; }

cmd_save() {
    local name="${1:?Usage: echo 'code' | snippet save <name> [lang]}"
    local lang="${2:-text}"
    
    local content
    if [ -t 0 ]; then
        echo "Enter snippet (Ctrl+D to finish):"
        content=$(cat)
    else
        content=$(cat)
    fi
    
    [ -z "$content" ] && die "No content provided"
    
    NAME="$name" LANG="$lang" CONTENT="$content" DB_FILE="$DB" python3 << 'PYEOF'
import json, os
from datetime import datetime
entry = {
    "name": os.environ["NAME"],
    "lang": os.environ["LANG"],
    "content": os.environ["CONTENT"],
    "tags": [],
    "created": datetime.now().strftime("%Y-%m-%d %H:%M"),
    "updated": datetime.now().strftime("%Y-%m-%d %H:%M")
}
with open(os.environ["DB_FILE"], "a") as f:
    f.write(json.dumps(entry) + "\n")
print("  Saved: {} ({}, {} bytes)".format(entry["name"], entry["lang"], len(entry["content"])))
PYEOF
}

cmd_get() {
    local name="${1:?Usage: snippet get <name>}"
    [ ! -f "$DB" ] && die "No snippets saved yet"
    
    NAME="$name" DB_FILE="$DB" python3 << 'PYEOF'
import json, os
name = os.environ["NAME"]
db = os.environ["DB_FILE"]
found = None
with open(db) as f:
    for line in f:
        if not line.strip():
            continue
        entry = json.loads(line)
        if entry["name"] == name:
            found = entry

if found:
    print("# {} [{}] — {}".format(found["name"], found["lang"], found.get("created","")))
    if found.get("tags"):
        print("# Tags: {}".format(", ".join(found["tags"])))
    print("")
    print(found["content"])
else:
    print("  Snippet '{}' not found".format(name))
PYEOF
}

cmd_list() {
    local lang_filter="${1:-}"
    [ ! -f "$DB" ] || [ ! -s "$DB" ] && { echo "  No snippets saved."; return 0; }
    
    echo -e "${BOLD}Saved Snippets${RESET}"
    echo ""
    
    LANG_FILTER="$lang_filter" DB_FILE="$DB" python3 << 'PYEOF'
import json, os
lang_filter = os.environ["LANG_FILTER"]
db = os.environ["DB_FILE"]
count = 0
with open(db) as f:
    for line in f:
        if not line.strip():
            continue
        entry = json.loads(line)
        if lang_filter and entry.get("lang") != lang_filter:
            continue
        count += 1
        tags = " [{}]".format(",".join(entry["tags"])) if entry.get("tags") else ""
        size = len(entry.get("content",""))
        print("  {:>3}. {:20s} {:8s} {:>6}b  {}{}".format(
            count, entry["name"], entry.get("lang",""), size, entry.get("created",""), tags))

if count == 0:
    print("  No snippets found")
else:
    print("\n  Total: {} snippets".format(count))
PYEOF
}

cmd_search() {
    local keyword="${1:?Usage: snippet search <keyword>}"
    [ ! -f "$DB" ] && die "No snippets saved"
    
    KEYWORD="$keyword" DB_FILE="$DB" python3 << 'PYEOF'
import json, os
kw = os.environ["KEYWORD"].lower()
db = os.environ["DB_FILE"]
results = []
with open(db) as f:
    for line in f:
        if not line.strip():
            continue
        entry = json.loads(line)
        if kw in entry["name"].lower() or kw in entry.get("content","").lower() or kw in " ".join(entry.get("tags",[])).lower():
            results.append(entry)

if results:
    print("  Found {} matches for '{}':\n".format(len(results), os.environ["KEYWORD"]))
    for r in results:
        preview = r.get("content","")[:60].replace("\n"," ")
        print("  {} [{}] — {}...".format(r["name"], r.get("lang",""), preview))
else:
    print("  No matches for '{}'".format(os.environ["KEYWORD"]))
PYEOF
}

cmd_delete() {
    local name="${1:?Usage: snippet delete <name>}"
    [ ! -f "$DB" ] && die "No snippets"
    
    NAME="$name" DB_FILE="$DB" python3 << 'PYEOF'
import json, os
name = os.environ["NAME"]
db = os.environ["DB_FILE"]
kept = []
removed = 0
with open(db) as f:
    for line in f:
        if not line.strip():
            continue
        entry = json.loads(line)
        if entry["name"] == name:
            removed += 1
        else:
            kept.append(line)
with open(db, "w") as f:
    f.writelines(kept)
if removed:
    print("  Deleted: {}".format(name))
else:
    print("  '{}' not found".format(name))
PYEOF
}

cmd_tags() {
    local name="${1:?Usage: snippet tags <name> <tag1> [tag2...]}"
    shift
    [ $# -eq 0 ] && die "No tags specified"
    [ ! -f "$DB" ] && die "No snippets"
    
    NAME="$name" TAGS="$*" DB_FILE="$DB" python3 << 'PYEOF'
import json, os
name = os.environ["NAME"]
new_tags = os.environ["TAGS"].split()
db = os.environ["DB_FILE"]
lines = []
updated = False
with open(db) as f:
    for line in f:
        if not line.strip():
            continue
        entry = json.loads(line)
        if entry["name"] == name:
            existing = set(entry.get("tags", []))
            existing.update(new_tags)
            entry["tags"] = sorted(existing)
            updated = True
        lines.append(json.dumps(entry) + "\n")
with open(db, "w") as f:
    f.writelines(lines)
if updated:
    print("  Tags updated for {}".format(name))
else:
    print("  '{}' not found".format(name))
PYEOF
}

cmd_export() {
    local fmt="${1:-json}"
    [ ! -f "$DB" ] && die "No snippets"
    
    case "$fmt" in
        json)
            echo "["
            local first=true
            while IFS= read -r line; do
                [ -z "$line" ] && continue
                $first && first=false || echo ","
                echo "  $line"
            done < "$DB"
            echo "]"
            ;;
        md|markdown)
            DB_FILE="$DB" python3 << 'PYEOF'
import json, os
with open(os.environ["DB_FILE"]) as f:
    for line in f:
        if not line.strip():
            continue
        e = json.loads(line)
        print("## {}".format(e["name"]))
        print("")
        print("```{}".format(e.get("lang","")))
        print(e.get("content",""))
        print("```")
        print("")
PYEOF
            ;;
        *) die "Unknown format: $fmt (json or md)" ;;
    esac
}

cmd_stats() {
    [ ! -f "$DB" ] || [ ! -s "$DB" ] && { echo "  No snippets."; return 0; }
    
    DB_FILE="$DB" python3 << 'PYEOF'
import json, os
from collections import Counter
db = os.environ["DB_FILE"]
langs = Counter()
total_size = 0
count = 0
with open(db) as f:
    for line in f:
        if not line.strip():
            continue
        e = json.loads(line)
        langs[e.get("lang","text")] += 1
        total_size += len(e.get("content",""))
        count += 1

print("  Snippets:  {}".format(count))
print("  Total size: {} bytes".format(total_size))
print("  Languages:")
for lang, c in langs.most_common(10):
    print("    {}: {}".format(lang, c))
PYEOF
}

show_help() {
    cat << EOF
snippet v$VERSION — Code snippet manager

Usage: snippet <command> [args]

Save/Retrieve:
  save <name> [lang]          Save snippet from stdin
  get <name>                  Display a snippet
  list [lang]                 List all snippets (filter by language)
  search <keyword>            Search snippets by name/content/tags

Manage:
  delete <name>               Delete a snippet
  tags <name> <tag1> ...      Add tags to a snippet
  export <json|md>            Export all snippets
  stats                       Usage statistics

  help                        Show this help
  version                     Show version

Data: $DATA_DIR
Requires: python3
EOF
}

[ $# -eq 0 ] && { show_help; exit 0; }
case "$1" in
    save)    shift; cmd_save "$@" ;;
    get)     shift; cmd_get "$@" ;;
    list|ls) shift; cmd_list "${1:-}" ;;
    search)  shift; cmd_search "$@" ;;
    delete)  shift; cmd_delete "$@" ;;
    tags)    shift; cmd_tags "$@" ;;
    export)  shift; cmd_export "${1:-json}" ;;
    stats)   cmd_stats ;;
    help|-h) show_help ;;
    version|-v) echo "snippet v$VERSION"; echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com" ;;
    *)       echo "Unknown: $1"; show_help; exit 1 ;;
esac
