#!/usr/bin/env bash
# r-analyst/scripts/script.sh
# R-style statistical analysis powered by Python 3 — no R required.
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
err()   { echo -e "${RED}✘ ${*}${RESET}"; exit 1; }
head_() { echo -e "\n${BOLD}${*}${RESET}"; }

# ─── require python3 ──────────────────────────────────────────────────────────
require_python() {
  if ! command -v python3 &>/dev/null; then
    err "python3 not found. Please install Python 3.8+."
  fi
}

# ─── require CSV file arg ─────────────────────────────────────────────────────
require_csv() {
  local f="${1:-}"
  [[ -z "$f" ]] && err "Usage: $0 $COMMAND <file.csv> [options]"
  [[ ! -f "$f" ]] && err "File not found: $f"
  [[ "${f##*.}" != "csv" ]] && warn "File does not have .csv extension — proceeding anyway."
  echo "$f"
}

# ─── COMMAND: stats ───────────────────────────────────────────────────────────
cmd_stats() {
  local csv; csv=$(require_csv "${1:-}")
  local col="${2:-}"
  require_python

  python3 - "$csv" "$col" <<'PYEOF'
import sys, csv, math, statistics

csv_file = sys.argv[1]
target_col = sys.argv[2] if len(sys.argv) > 2 else ""

def parse_csv(path):
    with open(path, newline="", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        rows = list(reader)
        return reader.fieldnames or [], rows

def to_float(v):
    try:
        return float(v)
    except (ValueError, TypeError):
        return None

def r_summary(name, values):
    nums = [v for v in (to_float(x) for x in values) if v is not None]
    if not nums:
        print(f"\n[{name}]  (no numeric data)")
        return
    nums_sorted = sorted(nums)
    n = len(nums)
    mean_ = statistics.mean(nums)
    med_  = statistics.median(nums)
    try:
        sd_   = statistics.stdev(nums)
    except statistics.StatisticsError:
        sd_ = 0.0
    mn_   = min(nums)
    mx_   = max(nums)
    q1_   = nums_sorted[n // 4]
    q3_   = nums_sorted[(3 * n) // 4]

    print(f"\n{'─'*50}")
    print(f"  Variable : {name}  (n={n})")
    print(f"{'─'*50}")
    print(f"  Min.     : {mn_:>12.4f}")
    print(f"  1st Qu.  : {q1_:>12.4f}")
    print(f"  Median   : {med_:>12.4f}")
    print(f"  Mean     : {mean_:>12.4f}")
    print(f"  3rd Qu.  : {q3_:>12.4f}")
    print(f"  Max.     : {mx_:>12.4f}")
    print(f"  Std Dev  : {sd_:>12.4f}")

fields, rows = parse_csv(csv_file)
print(f"\n📊 R-style Summary — {csv_file}")
print(f"   Rows: {len(rows)}   Columns: {len(fields)}")

if target_col:
    if target_col not in fields:
        print(f"Column '{target_col}' not found. Available: {', '.join(fields)}", file=sys.stderr)
        sys.exit(1)
    r_summary(target_col, [r[target_col] for r in rows])
else:
    for col in fields:
        vals = [r.get(col, "") for r in rows]
        r_summary(col, vals)
print()
PYEOF
}

# ─── COMMAND: plot ────────────────────────────────────────────────────────────
cmd_plot() {
  local csv; csv=$(require_csv "${1:-}")
  local col="${2:-}"
  local bins="${3:-10}"
  require_python

  python3 - "$csv" "$col" "$bins" <<'PYEOF'
import sys, csv, math

csv_file   = sys.argv[1]
target_col = sys.argv[2] if len(sys.argv) > 2 else ""
bins       = int(sys.argv[3]) if len(sys.argv) > 3 else 10

def parse_csv(path):
    with open(path, newline="", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        rows = list(reader)
        return reader.fieldnames or [], rows

def to_float(v):
    try:    return float(v)
    except: return None

def ascii_hist(name, values, bins=10, width=40):
    nums = sorted(v for v in (to_float(x) for x in values) if v is not None)
    if not nums:
        print(f"[{name}] no numeric data"); return
    mn, mx = min(nums), max(nums)
    if mn == mx:
        print(f"[{name}] all values equal {mn}"); return
    step = (mx - mn) / bins
    counts = [0] * bins
    for v in nums:
        idx = min(int((v - mn) / step), bins - 1)
        counts[idx] += 1
    max_count = max(counts) or 1
    print(f"\n📊 Histogram: {name}  (n={len(nums)}, bins={bins})")
    print(f"   Range: [{mn:.3g}, {mx:.3g}]")
    print()
    for i, c in enumerate(counts):
        lo = mn + i * step
        hi = lo + step
        bar = '█' * round(c / max_count * width)
        print(f"  {lo:>8.3g} – {hi:<8.3g} | {bar:<{width}} {c}")
    print()

fields, rows = parse_csv(csv_file)
numeric_cols = [
    f for f in fields
    if any(to_float(r.get(f, "")) is not None for r in rows)
]

if target_col:
    if target_col not in fields:
        print(f"Column '{target_col}' not found. Available: {', '.join(fields)}", file=sys.stderr)
        sys.exit(1)
    ascii_hist(target_col, [r[target_col] for r in rows], bins)
else:
    if not numeric_cols:
        print("No numeric columns detected.")
        sys.exit(0)
    # plot first numeric column
    col = numeric_cols[0]
    ascii_hist(col, [r[col] for r in rows], bins)
    if len(numeric_cols) > 1:
        print(f"  (Other numeric columns: {', '.join(numeric_cols[1:])})")
        print(f"  Run: r-analyst plot <file.csv> <colname> to pick one.")
PYEOF
}

# ─── COMMAND: correlate ───────────────────────────────────────────────────────
cmd_correlate() {
  local csv; csv=$(require_csv "${1:-}")
  require_python

  python3 - "$csv" <<'PYEOF'
import sys, csv, math

csv_file = sys.argv[1]

with open(csv_file, newline="", encoding="utf-8-sig") as f:
    reader = csv.DictReader(f)
    rows = list(reader)
    fields = reader.fieldnames or []

def to_float(v):
    try:    return float(v)
    except: return None

def pearson(xs, ys):
    pairs = [(x, y) for x, y in zip(xs, ys) if x is not None and y is not None]
    if len(pairs) < 2:
        return None
    n = len(pairs)
    sx = sum(p[0] for p in pairs)
    sy = sum(p[1] for p in pairs)
    sxx = sum(p[0]**2 for p in pairs)
    syy = sum(p[1]**2 for p in pairs)
    sxy = sum(p[0]*p[1] for p in pairs)
    denom = math.sqrt((n*sxx - sx**2) * (n*syy - sy**2))
    return (n*sxy - sx*sy) / denom if denom else None

numeric_cols = {}
for col in fields:
    vals = [to_float(r.get(col, "")) for r in rows]
    if any(v is not None for v in vals):
        numeric_cols[col] = vals

cols = list(numeric_cols.keys())
n = len(cols)

if n < 2:
    print("Need at least 2 numeric columns for correlation.")
    sys.exit(1)

print(f"\n📐 Pearson Correlation Matrix — {csv_file}")
print(f"   Numeric columns: {', '.join(cols)}\n")

# header
col_w = 10
print(" " * 20, end="")
for c in cols:
    print(f"{c[:col_w]:>{col_w}}", end=" ")
print()
print(" " * 20 + "─" * (col_w + 1) * n)

for c1 in cols:
    print(f"{c1[:18]:<20}", end="")
    for c2 in cols:
        r = pearson(numeric_cols[c1], numeric_cols[c2])
        if r is None:
            print(f"{'N/A':>{col_w}}", end=" ")
        else:
            print(f"{r:>{col_w}.4f}", end=" ")
    print()

print()
print("  Interpretation: +1 perfect positive | 0 none | -1 perfect negative")
print()
PYEOF
}

# ─── COMMAND: clean ───────────────────────────────────────────────────────────
cmd_clean() {
  local csv; csv=$(require_csv "${1:-}")
  require_python

  python3 - "$csv" <<'PYEOF'
import sys, csv, math

csv_file = sys.argv[1]

with open(csv_file, newline="", encoding="utf-8-sig") as f:
    reader = csv.DictReader(f)
    rows = list(reader)
    fields = reader.fieldnames or []

def to_float(v):
    try:    return float(v)
    except: return None

n_rows = len(rows)
print(f"\n🧹 Data Quality Report — {csv_file}")
print(f"   Total rows: {n_rows} | Columns: {len(fields)}\n")
print(f"{'Column':<22} {'Missing':>8} {'Missing%':>9} {'Outliers':>9} {'Notes'}")
print("─" * 75)

total_issues = 0
for col in fields:
    vals = [r.get(col, "") for r in rows]
    missing = sum(1 for v in vals if v.strip() == "" or v.lower() in ("na","n/a","null","none","nan"))
    miss_pct = missing / n_rows * 100 if n_rows else 0

    nums = [to_float(v) for v in vals if to_float(v) is not None]
    outliers = 0
    notes = []

    if missing:
        notes.append(f"{missing} missing")
        total_issues += missing

    if len(nums) >= 4:
        import statistics
        try:
            mean_ = statistics.mean(nums)
            sd_   = statistics.stdev(nums)
            if sd_ > 0:
                outliers = sum(1 for v in nums if abs(v - mean_) > 3 * sd_)
                if outliers:
                    notes.append(f"{outliers} >3σ outliers")
                    total_issues += outliers
        except Exception:
            pass

    note_str = "; ".join(notes) if notes else "✔ OK"
    print(f"  {col[:20]:<20} {missing:>8} {miss_pct:>8.1f}% {outliers:>9}  {note_str}")

print("─" * 75)
if total_issues:
    print(f"\n  ⚠ Total issues found: {total_issues}")
    print("  Tip: remove rows with df.dropna() or impute with df.fillna(median)")
else:
    print("\n  ✔ Dataset looks clean!")
print()
PYEOF
}

# ─── COMMAND: describe ────────────────────────────────────────────────────────
cmd_describe() {
  local csv; csv=$(require_csv "${1:-}")
  require_python

  python3 - "$csv" <<'PYEOF'
import sys, csv

csv_file = sys.argv[1]

with open(csv_file, newline="", encoding="utf-8-sig") as f:
    reader = csv.DictReader(f)
    rows = list(reader)
    fields = reader.fieldnames or []

def to_float(v):
    try:    return float(v)
    except: return None

n_rows = len(rows)
print(f"\n📋 Dataset Structure — {csv_file}")
print(f"   Rows: {n_rows}  |  Columns: {len(fields)}\n")
print(f"  {'#':<4} {'Column':<22} {'Type':<12} {'Unique':>7} {'Sample Values'}")
print("─" * 75)

for i, col in enumerate(fields, 1):
    vals = [r.get(col, "") for r in rows]
    non_empty = [v for v in vals if v.strip()]
    unique_count = len(set(vals))

    # detect type
    num_vals = [to_float(v) for v in non_empty]
    if all(v is not None for v in num_vals) and num_vals:
        dtype = "numeric"
    elif all(v.strip().lower() in ("true","false","yes","no","0","1") for v in non_empty) and non_empty:
        dtype = "boolean"
    else:
        dtype = "character"

    sample = list(dict.fromkeys(v for v in vals if v.strip()))[:3]
    sample_str = ", ".join(f'"{s}"' for s in sample)

    print(f"  {i:<4} {col[:20]:<22} {dtype:<12} {unique_count:>7}  {sample_str}")

print()
# File size
import os
size = os.path.getsize(csv_file)
print(f"   File size: {size:,} bytes ({size/1024:.1f} KB)")
print()
PYEOF
}

# ─── COMMAND: help ────────────────────────────────────────────────────────────
cmd_help() {
  echo ""
  echo -e "${BOLD}📊 R Analyst${RESET} — R-style data analysis powered by Python 3"
  echo ""
  echo -e "  ${CYAN}stats${RESET}     <file.csv> [col]     Descriptive statistics (R-style summary)"
  echo -e "  ${CYAN}plot${RESET}      <file.csv> [col] [bins]  ASCII histogram"
  echo -e "  ${CYAN}correlate${RESET} <file.csv>           Pearson correlation matrix"
  echo -e "  ${CYAN}clean${RESET}     <file.csv>           Detect missing values & outliers"
  echo -e "  ${CYAN}describe${RESET}  <file.csv>           Dataset structure & column types"
  echo -e "  ${CYAN}help${RESET}                          Show this help"
  echo ""
  echo -e "${YELLOW}Powered by BytesAgain | bytesagain.com${RESET}"
  echo ""
}

# ─── dispatch ─────────────────────────────────────────────────────────────────
case "$COMMAND" in
  stats)     cmd_stats     "$@" ;;
  plot)      cmd_plot      "$@" ;;
  correlate) cmd_correlate "$@" ;;
  clean)     cmd_clean     "$@" ;;
  describe)  cmd_describe  "$@" ;;
  help|--help|-h) cmd_help ;;
  *)
    err "Unknown command: $COMMAND"
    cmd_help
    exit 1
    ;;
esac

# Powered by BytesAgain | bytesagain.com
