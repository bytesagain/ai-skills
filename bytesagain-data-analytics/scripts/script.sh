#!/usr/bin/env bash
# bytesagain-data-analytics — Data analysis toolkit
set -euo pipefail

CMD="${1:-help}"
shift || true

show_help() {
    echo "bytesagain-data-analytics — Terminal data analysis for CSV and JSON files"
    echo ""
    echo "Usage:"
    echo "  bytesagain-data-analytics describe <csv_file>     Statistical summary"
    echo "  bytesagain-data-analytics correlate <csv_file>    Correlation matrix"
    echo "  bytesagain-data-analytics top <csv_file> <col>    Top N values"
    echo "  bytesagain-data-analytics trend <csv_file> <col>  Trend analysis"
    echo "  bytesagain-data-analytics clean <csv_file>        Data quality report"
    echo "  bytesagain-data-analytics pivot <csv> <row> <col> Pivot table"
    echo ""
}

cmd_describe() {
    local file="${1:-}"
    [ -z "$file" ] && echo "Usage: describe <csv_file>" && exit 1
    [ ! -f "$file" ] && echo "File not found: $file" && exit 1
    DA_COL="$col" DA_ROW="${row_col:-}" DA_VAL="${val_col:-}" python3 << 'PYEOF'
import csv, os, math
from collections import Counter

with open("$file", encoding="utf-8-sig", errors="ignore") as f:
    reader = csv.DictReader(f)
    rows = list(reader)
    headers = reader.fieldnames or []

if not rows:
    print("No data found in file")
    exit(0)

print(f"\n📊 Data Description: {os.path.basename('$file')}")
print(f"   Rows: {len(rows)} | Columns: {len(headers)}\n")

for col in headers:
    values = [r[col] for r in rows if r.get(col, '').strip()]
    numeric = []
    for v in values:
        try: numeric.append(float(v.replace(',','')))
        except: pass

    print(f"  [{col}]")
    print(f"    Non-null: {len(values)}/{len(rows)} ({len(values)/len(rows)*100:.1f}%)")

    if len(numeric) > len(values) * 0.5:
        numeric.sort()
        n = len(numeric)
        mean = sum(numeric)/n
        variance = sum((x-mean)**2 for x in numeric)/n
        std = math.sqrt(variance)
        p25 = numeric[n//4]
        p50 = numeric[n//2]
        p75 = numeric[3*n//4]
        print(f"    Type: numeric | Min: {min(numeric):.2f} | Max: {max(numeric):.2f}")
        print(f"    Mean: {mean:.2f} | Std: {std:.2f}")
        print(f"    P25: {p25:.2f} | Median: {p50:.2f} | P75: {p75:.2f}")
    else:
        counts = Counter(values)
        unique = len(counts)
        top = counts.most_common(3)
        print(f"    Type: categorical | Unique: {unique}")
        print(f"    Top values: {', '.join(f'{v}({c})' for v,c in top)}")
    print()
PYEOF
}

cmd_correlate() {
    local file="${1:-}"
    [ -z "$file" ] && echo "Usage: correlate <csv_file>" && exit 1
    [ ! -f "$file" ] && echo "File not found: $file" && exit 1
    DA_COL="$col" DA_ROW="${row_col:-}" DA_VAL="${val_col:-}" python3 << 'PYEOF'
import csv, math

with open("$file", encoding="utf-8-sig", errors="ignore") as f:
    reader = csv.DictReader(f)
    rows = list(reader)
    headers = reader.fieldnames or []

def to_numeric(col):
    vals = []
    for r in rows:
        try: vals.append(float(r[col].replace(',','')))
        except: vals.append(None)
    return vals

def pearson(xs, ys):
    pairs = [(x,y) for x,y in zip(xs,ys) if x is not None and y is not None]
    if len(pairs) < 3: return None
    n = len(pairs)
    xs2 = [p[0] for p in pairs]; ys2 = [p[1] for p in pairs]
    mx = sum(xs2)/n; my = sum(ys2)/n
    num = sum((x-mx)*(y-my) for x,y in pairs)
    den = math.sqrt(sum((x-mx)**2 for x in xs2) * sum((y-my)**2 for y in ys2))
    return num/den if den > 0 else 0

num_cols = [h for h in headers if len([r for r in rows if r.get(h,'').replace('.','').replace('-','').replace(',','').isdigit()]) > len(rows)*0.5]

if len(num_cols) < 2:
    print("Need at least 2 numeric columns for correlation")
    exit(0)

print(f"\n📈 Correlation Matrix (Pearson r)\n")
w = max(len(c) for c in num_cols)
print(f"  {'':{w}}", end="")
for c in num_cols:
    print(f"  {c[:8]:>8}", end="")
print()
print(f"  {'─'*(w + len(num_cols)*10)}")

data = {c: to_numeric(c) for c in num_cols}
for c1 in num_cols:
    print(f"  {c1:{w}}", end="")
    for c2 in num_cols:
        r = pearson(data[c1], data[c2])
        if r is None: val = "   N/A  "
        elif c1 == c2: val = "   1.00 "
        else:
            marker = "🔴" if abs(r)>0.7 else ("🟡" if abs(r)>0.4 else "  ")
            val = f"{marker}{r:+.2f}  "
        print(f"  {val:>8}", end="")
    print()
print(f"\n  🔴 |r|>0.7 strong | 🟡 |r|>0.4 moderate")
PYEOF
}

cmd_top() {
    local file="${1:-}"; local col="${2:-}"
    [ -z "$file" ] || [ -z "$col" ] && echo "Usage: top <csv_file> <column>" && exit 1
    [ ! -f "$file" ] && echo "File not found: $file" && exit 1
    DA_COL="$col" DA_ROW="${row_col:-}" DA_VAL="${val_col:-}" python3 << 'PYEOF'
import csv
from collections import Counter

with open("$file", encoding="utf-8-sig", errors="ignore") as f:
    reader = csv.DictReader(f)
    rows = list(reader)

import os; col = os.environ.get("DA_COL","")
values = [r.get(col, '').strip() for r in rows if r.get(col, '').strip()]
counts = Counter(values)
total = len(values)

print(f"\n📊 Top Values: {col} ({total} records)\n")
print(f"  {'Value':<30}  {'Count':>6}  {'%':>6}  Bar")
print(f"  {'─'*30}  {'─'*6}  {'─'*6}  {'─'*20}")
max_c = counts.most_common(1)[0][1]
for val, count in counts.most_common(15):
    pct = count/total*100
    bar = '█' * int(count/max_c*20)
    print(f"  {val[:30]:<30}  {count:>6}  {pct:>5.1f}%  {bar}")
PYEOF
}

cmd_trend() {
    local file="${1:-}"; local col="${2:-}"
    [ -z "$file" ] || [ -z "$col" ] && echo "Usage: trend <csv_file> <column>" && exit 1
    [ ! -f "$file" ] && echo "File not found: $file" && exit 1
    DA_COL="$col" DA_ROW="${row_col:-}" DA_VAL="${val_col:-}" python3 << 'PYEOF'
import csv, math

with open("$file", encoding="utf-8-sig", errors="ignore") as f:
    reader = csv.DictReader(f)
    rows = list(reader)

import os; col = os.environ.get("DA_COL","")
vals = []
for r in rows:
    try: vals.append(float(r[col].replace(',','')))
    except: vals.append(None)

vals = [v for v in vals if v is not None]
if not vals:
    print(f"No numeric data in column: {col}")
    exit(0)

n = len(vals)
chunk = max(1, n//10)
chunks = [vals[i:i+chunk] for i in range(0, n, chunk)]
avgs = [sum(c)/len(c) for c in chunks if c]

min_v, max_v = min(avgs), max(avgs)
height = 8

print(f"\n📈 Trend: {col} ({n} data points)\n")
for row in range(height, -1, -1):
    threshold = min_v + (row/height)*(max_v-min_v)
    label = f"{threshold:>8.1f} |" if row % 2 == 0 else f"{'':>8} |"
    line = label
    for avg in avgs:
        norm = (avg-min_v)/max(max_v-min_v, 0.001)*height
        if abs(norm-row) < 0.6: line += "●"
        else: line += " "
    print(line)

print(f"{'':>9}+" + "─"*len(avgs))

# Trend direction
first_half = sum(avgs[:len(avgs)//2])/max(len(avgs)//2, 1)
second_half = sum(avgs[len(avgs)//2:])/max(len(avgs)-len(avgs)//2, 1)
direction = "📈 Upward" if second_half > first_half*1.05 else ("📉 Downward" if second_half < first_half*0.95 else "➡️  Stable")
change_pct = (second_half-first_half)/max(abs(first_half), 0.001)*100
print(f"\n  Trend: {direction} | Change: {change_pct:+.1f}%")
print(f"  Range: {min(vals):.2f} — {max(vals):.2f} | Avg: {sum(vals)/n:.2f}")
PYEOF
}

cmd_clean() {
    local file="${1:-}"
    [ -z "$file" ] && echo "Usage: clean <csv_file>" && exit 1
    [ ! -f "$file" ] && echo "File not found: $file" && exit 1
    DA_COL="$col" DA_ROW="${row_col:-}" DA_VAL="${val_col:-}" python3 << 'PYEOF'
import csv, re

with open("$file", encoding="utf-8-sig", errors="ignore") as f:
    reader = csv.DictReader(f)
    rows = list(reader)
    headers = reader.fieldnames or []

total = len(rows)
print(f"\n🧹 Data Quality Report: {total} rows, {len(headers)} columns\n")

issues = 0
for col in headers:
    vals = [r.get(col,'') for r in rows]
    nulls = sum(1 for v in vals if not v.strip())
    dups = total - len(set(v.strip() for v in vals if v.strip()))
    numeric = sum(1 for v in vals if v.strip() and re.match(r'^-?\d+\.?\d*$', v.replace(',','')))

    problems = []
    if nulls > 0: problems.append(f"{nulls} nulls ({nulls/total*100:.1f}%)")
    if dups > total*0.8 and len(set(v for v in vals if v)) < 5: problems.append(f"low cardinality")

    status = "⚠️" if problems else "✅"
    print(f"  {status} {col}")
    if problems:
        for p in problems: print(f"      → {p}")
        issues += 1

print(f"\n  Score: {(len(headers)-issues)/len(headers)*100:.0f}% clean")
print(f"  Issues found in {issues}/{len(headers)} columns")
PYEOF
}

cmd_pivot() {
    local file="${1:-}"; local row_col="${2:-}"; local val_col="${3:-}"
    [ -z "$file" ] || [ -z "$row_col" ] || [ -z "$val_col" ] && echo "Usage: pivot <csv> <row_column> <value_column>" && exit 1
    [ ! -f "$file" ] && echo "File not found: $file" && exit 1
    DA_COL="$col" DA_ROW="${row_col:-}" DA_VAL="${val_col:-}" python3 << 'PYEOF'
import csv
from collections import defaultdict

with open("$file", encoding="utf-8-sig", errors="ignore") as f:
    rows = list(csv.DictReader(f))

import os; row_col = os.environ.get("DA_ROW",""); val_col = os.environ.get("DA_VAL","")
pivot = defaultdict(list)
for r in rows:
    k = r.get(row_col,'').strip()
    v = r.get(val_col,'').strip()
    if k and v:
        try: pivot[k].append(float(v.replace(',','')))
        except: pivot[k].append(v)

print(f"\n📊 Pivot: {row_col} × {val_col}\n")
print(f"  {'Category':<25}  {'Count':>6}  {'Sum/Total':>12}  {'Average':>10}")
print(f"  {'─'*25}  {'─'*6}  {'─'*12}  {'─'*10}")

for k in sorted(pivot):
    vals = pivot[k]
    if vals and isinstance(vals[0], float):
        total = sum(vals)
        avg = total/len(vals)
        print(f"  {k[:25]:<25}  {len(vals):>6}  {total:>12.2f}  {avg:>10.2f}")
    else:
        print(f"  {k[:25]:<25}  {len(vals):>6}  {'N/A':>12}  {'N/A':>10}")
PYEOF
}

case "$CMD" in
    describe)  cmd_describe "$@" ;;
    correlate) cmd_correlate "$@" ;;
    top)       cmd_top "$@" ;;
    trend)     cmd_trend "$@" ;;
    clean)     cmd_clean "$@" ;;
    pivot)     cmd_pivot "$@" ;;
    help|--help|-h) show_help ;;
    *) echo "Unknown: $CMD"; show_help; exit 1 ;;
esac
