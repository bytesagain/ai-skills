#!/usr/bin/env bash
# python-cookbook/scripts/script.sh
# Practical Python code snippets, runner, linter, formatter, and debugger.
# Powered by BytesAgain | bytesagain.com

set -euo pipefail

COMMAND="${1:-help}"
shift || true

# ─── colour helpers ────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

info()  { echo -e "${CYAN}${*}${RESET}"; }
ok()    { echo -e "${GREEN}✔ ${*}${RESET}"; }
warn()  { echo -e "${YELLOW}⚠ ${*}${RESET}"; }
err()   { echo -e "${RED}✘ ${*}${RESET}"; }
head_()  { echo -e "\n${BOLD}${*}${RESET}"; }

# ─── snippet database ─────────────────────────────────────────────────────────
declare -A SNIPPETS

SNIPPETS["file-read"]='# Read a file line-by-line
with open("data.txt", "r", encoding="utf-8") as f:
    for line in f:
        print(line.rstrip())'

SNIPPETS["file-write"]='# Write lines to a file safely
lines = ["hello", "world"]
with open("output.txt", "w", encoding="utf-8") as f:
    f.writelines(line + "\n" for line in lines)'

SNIPPETS["file-json"]='# Load / dump JSON
import json
with open("data.json") as f:
    data = json.load(f)
with open("out.json", "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)'

SNIPPETS["list-comprehension"]='# List comprehension patterns
squares   = [x**2 for x in range(10)]
evens     = [x for x in range(20) if x % 2 == 0]
flat      = [n for row in [[1,2],[3,4]] for n in row]
print(squares, evens, flat)'

SNIPPETS["list-sort"]='# Sort lists and custom objects
nums = [3, 1, 4, 1, 5, 9]
nums.sort()                          # in-place
desc = sorted(nums, reverse=True)    # new list
# Sort dicts by value
d = {"a": 3, "b": 1, "c": 2}
by_val = dict(sorted(d.items(), key=lambda kv: kv[1]))'

SNIPPETS["dict-merge"]='# Merge / update dicts (Python 3.9+)
a = {"x": 1, "y": 2}
b = {"y": 99, "z": 3}
merged = a | b          # {x:1, y:99, z:3}
a |= b                  # in-place update'

SNIPPETS["dict-default"]='# defaultdict and Counter
from collections import defaultdict, Counter
freq = Counter("abracadabra")     # Counter({a:5, b:2, r:2, c:1, d:1})
groups = defaultdict(list)
for item in [("a",1),("b",2),("a",3)]:
    groups[item[0]].append(item[1])'

SNIPPETS["decorator-basic"]='# Simple decorator
import functools
def log_call(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        print(f"→ calling {func.__name__}")
        result = func(*args, **kwargs)
        print(f"← done {func.__name__}")
        return result
    return wrapper

@log_call
def greet(name: str) -> str:
    return f"Hello, {name}!"'

SNIPPETS["decorator-retry"]='# Retry decorator with exponential back-off
import functools, time
def retry(times=3, delay=1.0, backoff=2.0):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            wait = delay
            for attempt in range(1, times + 1):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    if attempt == times:
                        raise
                    print(f"Retry {attempt}/{times} after {wait}s: {e}")
                    time.sleep(wait)
                    wait *= backoff
        return wrapper
    return decorator'

SNIPPETS["async-basic"]='# Async / await basics
import asyncio

async def fetch(url: str) -> str:
    await asyncio.sleep(0.1)   # simulate IO
    return f"data from {url}"

async def main():
    results = await asyncio.gather(
        fetch("http://a.com"),
        fetch("http://b.com"),
    )
    for r in results:
        print(r)

asyncio.run(main())'

SNIPPETS["async-httpx"]='# Async HTTP with httpx
import asyncio, httpx

async def get_json(url: str):
    async with httpx.AsyncClient(timeout=10) as client:
        resp = await client.get(url)
        resp.raise_for_status()
        return resp.json()

data = asyncio.run(get_json("https://api.github.com"))'

SNIPPETS["regex-basic"]='# Common regex patterns
import re
text = "My email is foo@bar.com and phone 123-456-7890"
email   = re.findall(r"[\w.+-]+@[\w-]+\.\w+", text)
phone   = re.findall(r"\d{3}-\d{3}-\d{4}", text)
cleaned = re.sub(r"\s+", " ", "  too   many  spaces  ").strip()'

SNIPPETS["date-basic"]='# Dates and times
from datetime import datetime, timedelta, timezone
now   = datetime.now()
utcnow = datetime.now(timezone.utc)
tomorrow = now + timedelta(days=1)
fmt   = now.strftime("%Y-%m-%d %H:%M:%S")
parsed = datetime.strptime("2024-01-15", "%Y-%m-%d")'

SNIPPETS["date-diff"]='# Business-day-aware date diff
from datetime import date, timedelta
def business_days_between(start: date, end: date) -> int:
    count = 0
    cur = start
    while cur < end:
        if cur.weekday() < 5:   # Mon-Fri
            count += 1
        cur += timedelta(days=1)
    return count'

# ─── COMMAND: snippet ─────────────────────────────────────────────────────────
cmd_snippet() {
  local query="${1:-}"
  local -a keys=(
    file-read file-write file-json
    list-comprehension list-sort
    dict-merge dict-default
    decorator-basic decorator-retry
    async-basic async-httpx
    regex-basic
    date-basic date-diff
  )

  if [[ -z "$query" ]]; then
    head_ "📚 Available Python Snippets"
    echo ""
    for k in "${keys[@]}"; do
      local cat="${k%%-*}"
      printf "  ${CYAN}%-22s${RESET} %s\n" "$k" "(category: $cat)"
    done
    echo ""
    info "Usage: $0 snippet <name|keyword>"
    return 0
  fi

  # exact match
  if [[ -v "SNIPPETS[$query]" ]]; then
    head_ "📋 Snippet: $query"
    echo ""
    echo "${SNIPPETS[$query]}"
    return 0
  fi

  # fuzzy search
  local matched=()
  for k in "${keys[@]}"; do
    if [[ "$k" == *"$query"* ]] || echo "${SNIPPETS[$k]}" | grep -qi "$query"; then
      matched+=("$k")
    fi
  done

  if [[ ${#matched[@]} -eq 0 ]]; then
    err "No snippet found matching: $query"
    info "Run '$0 snippet' to see all available snippets."
    return 1
  fi

  for k in "${matched[@]}"; do
    head_ "📋 Snippet: $k"
    echo ""
    echo "${SNIPPETS[$k]}"
    echo ""
  done
}

# ─── COMMAND: run ─────────────────────────────────────────────────────────────
cmd_run() {
  local code="${1:-}"
  if [[ -z "$code" ]]; then
    err "Usage: $0 run '<python code>'"
    err "   or: $0 run @<file.py>"
    return 1
  fi

  if [[ "$code" == @* ]]; then
    local file="${code:1}"
    if [[ ! -f "$file" ]]; then
      err "File not found: $file"
      return 1
    fi
    info "▶ Running $file …"
    python3 "$file"
  else
    info "▶ Running inline code …"
    echo "$code" | python3
  fi
}

# ─── COMMAND: lint ────────────────────────────────────────────────────────────
cmd_lint() {
  if [[ $# -eq 0 ]]; then
    err "Usage: $0 lint <file.py> [file2.py ...]"
    return 1
  fi

  local any_error=0
  for f in "$@"; do
    if [[ ! -f "$f" ]]; then
      warn "Not found: $f"
      any_error=1
      continue
    fi
    if python3 -m py_compile "$f" 2>&1; then
      ok "$f  — syntax OK"
    else
      err "$f  — syntax error"
      any_error=1
    fi
  done
  return $any_error
}

# ─── COMMAND: format ──────────────────────────────────────────────────────────
cmd_format() {
  if [[ $# -eq 0 ]]; then
    err "Usage: $0 format <file.py> [file2.py ...]"
    return 1
  fi

  # Prefer black, fall back to autopep8, skip gracefully if neither
  local formatter=""
  if command -v black &>/dev/null; then
    formatter="black"
  elif command -v autopep8 &>/dev/null; then
    formatter="autopep8 --in-place"
  else
    warn "No formatter found. Install black or autopep8:"
    warn "  pip install black   OR   pip install autopep8"
    return 0
  fi

  info "Using formatter: ${formatter%% *}"
  for f in "$@"; do
    if [[ ! -f "$f" ]]; then
      warn "Not found: $f"; continue
    fi
    if $formatter "$f"; then
      ok "Formatted: $f"
    else
      err "Format failed: $f"
    fi
  done
}

# ─── COMMAND: debug ───────────────────────────────────────────────────────────
cmd_debug() {
  local topic="${1:-}"
  declare -A TIPS

  TIPS["NameError"]="NameError: variable used before assignment or outside scope.
  • Check spelling of the variable name.
  • Make sure the variable is defined before use.
  • In a function, pass variables as arguments or use 'global' (sparingly).
  Example fix:
    x = 0          # define first
    print(x + 1)"

  TIPS["TypeError"]="TypeError: wrong type passed to an operation or function.
  • Check argument types: use type() or isinstance() to inspect.
  • Common: adding str + int — fix with str(n) or int(s).
  • None returned from a function used as a value.
  Example fix:
    age = int(input('Age: '))   # convert before arithmetic"

  TIPS["IndexError"]="IndexError: list index out of range.
  • Print len(lst) before accessing lst[i].
  • Use 'for item in lst:' instead of index loops when possible.
  • Guard with: if i < len(lst): ..."

  TIPS["KeyError"]="KeyError: key not present in dictionary.
  • Use dict.get(key, default) instead of dict[key].
  • Check membership: if key in d: ...
  • Use collections.defaultdict if auto-creation is needed."

  TIPS["ImportError"]="ImportError / ModuleNotFoundError:
  • Install missing package: pip install <package>
  • Check virtual env is activated: source .venv/bin/activate
  • Confirm package name (e.g. 'PIL' is installed as 'Pillow').
  • Check PYTHONPATH if using local modules."

  TIPS["IndentationError"]="IndentationError: mixed tabs/spaces or wrong indent level.
  • Use spaces only (PEP 8: 4 spaces per level).
  • Run: python3 -m py_compile file.py to locate the line.
  • Editor tip: set 'convert tabs to spaces' in your editor."

  TIPS["RecursionError"]="RecursionError: maximum recursion depth exceeded.
  • Add a base case to your recursive function.
  • Consider iterative approach for deep recursions.
  • Increase limit (last resort): sys.setrecursionlimit(5000)"

  TIPS["UnicodeDecodeError"]="UnicodeDecodeError: file encoding mismatch.
  • Open with explicit encoding: open(f, encoding='utf-8')
  • Or use errors='replace' / errors='ignore' as fallback.
  • Detect encoding: pip install chardet; chardet.detect(raw_bytes)"

  if [[ -z "$topic" ]]; then
    head_ "🐛 Python Common Errors — Debug Guide"
    echo ""
    for k in "${!TIPS[@]}"; do
      printf "  ${CYAN}%-20s${RESET}\n" "$k"
    done
    echo ""
    info "Usage: $0 debug <ErrorName>"
    return 0
  fi

  # case-insensitive search
  local found=0
  for k in "${!TIPS[@]}"; do
    if [[ "${k,,}" == "${topic,,}"* ]]; then
      head_ "🔍 $k"
      echo ""
      echo "${TIPS[$k]}"
      found=1
    fi
  done

  if [[ $found -eq 0 ]]; then
    warn "No tip found for: $topic"
    info "Available topics: ${!TIPS[*]}"
  fi
}

# ─── COMMAND: help ────────────────────────────────────────────────────────────
cmd_help() {
  echo ""
  echo -e "${BOLD}🐍 Python Cookbook${RESET} — practical Python at your fingertips"
  echo ""
  echo -e "  ${CYAN}snippet${RESET} [keyword]     Search / display code snippets"
  echo -e "  ${CYAN}run${RESET} '<code>'|@file   Execute Python code or a file"
  echo -e "  ${CYAN}lint${RESET} <file.py>        Check syntax with py_compile"
  echo -e "  ${CYAN}format${RESET} <file.py>      Auto-format with black / autopep8"
  echo -e "  ${CYAN}debug${RESET} [ErrorName]     Show solutions for common errors"
  echo -e "  ${CYAN}help${RESET}                  Show this help"
  echo ""
  echo -e "${YELLOW}Powered by BytesAgain | bytesagain.com${RESET}"
  echo ""
}

# ─── dispatch ─────────────────────────────────────────────────────────────────
case "$COMMAND" in
  snippet) cmd_snippet "$@" ;;
  run)     cmd_run     "$@" ;;
  lint)    cmd_lint    "$@" ;;
  format)  cmd_format  "$@" ;;
  debug)   cmd_debug   "$@" ;;
  help|--help|-h) cmd_help ;;
  *)
    err "Unknown command: $COMMAND"
    cmd_help
    exit 1
    ;;
esac

# Powered by BytesAgain | bytesagain.com
