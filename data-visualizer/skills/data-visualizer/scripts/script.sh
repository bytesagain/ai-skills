#!/usr/bin/env bash
# data-visualizer — Terminal data visualization toolkit
set -euo pipefail
VERSION="3.0.0"
DATA_DIR="${DATAVIZ_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/data-visualizer}"
mkdir -p "$DATA_DIR"

show_help() {
    cat << HELP
data-visualizer v$VERSION

Usage: data-visualizer <command> [args]

Visualizations:
  bar <label:value> ...         Horizontal bar chart
  histogram <value> ...         Frequency histogram
  sparkline <value> ...         Inline sparkline
  heatmap <rows> <cols> <data>  Color-coded heat grid
  treemap <label:value> ...     Proportional blocks
  gauge <value> <max> [label]   Gauge meter
  matrix <file>                 Matrix/table view

Data Processing:
  summarize <file>              Stats summary (min/max/avg/median)
  distribution <file> [bins]    Value distribution
  correlate <file>              Column correlations
  normalize <file>              Normalize values 0-1
  pivot <file> <group-col>      Group and aggregate

I/O:
  from-csv <file>               Auto-visualize CSV
  from-json <file>              Auto-visualize JSON array
  to-svg <chart-data>           Export as SVG
  to-html <chart-data>          Export as HTML

HELP
}

cmd_bar() {
    local max_val=0
    declare -a labels=() values=()
    for pair in "$@"; do
        labels+=("${pair%%:*}")
        local v="${pair##*:}"
        values+=("$v")
        [ "$v" -gt "$max_val" ] 2>/dev/null && max_val="$v"
    done
    [ ${#labels[@]} -eq 0 ] && { echo "Usage: data-visualizer bar <label:value> ..."; return 1; }
    
    for i in "${!labels[@]}"; do
        local v="${values[$i]}"
        local w=$((v * 40 / (max_val > 0 ? max_val : 1)))
        local bar=$(printf '▓%.0s' $(seq 1 "$w") 2>/dev/null || echo "")
        printf "  %-15s %s %s\n" "${labels[$i]}" "$bar" "$v"
    done
}

cmd_histogram() {
    [ $# -eq 0 ] && { echo "Usage: data-visualizer histogram <values...>"; return 1; }
    declare -A bins
    local min=999999 max=0
    for v in "$@"; do
        [ "$v" -lt "$min" ] && min="$v"
        [ "$v" -gt "$max" ] && max="$v"
    done
    local range=$(( (max - min + 1) ))
    local bsize=$(( range > 5 ? range / 5 : 1 ))
    
    for v in "$@"; do
        local b=$(( (v - min) / bsize * bsize + min ))
        bins[$b]=$(( ${bins[$b]:-0} + 1 ))
    done
    
    echo "  Histogram ($# values, range $min-$max):"
    for b in $(echo "${!bins[@]}" | tr ' ' '\n' | sort -n); do
        local count="${bins[$b]}"
        local bar=$(printf '█%.0s' $(seq 1 "$count") 2>/dev/null || echo "")
        printf "  %5d-%-5d │%s %d\n" "$b" "$((b + bsize - 1))" "$bar" "$count"
    done
}

cmd_sparkline() {
    [ $# -eq 0 ] && { echo "Usage: data-visualizer sparkline <values...>"; return 1; }
    local sparks=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")
    local min=999999 max=0
    for v in "$@"; do
        [ "$v" -lt "$min" ] && min="$v"
        [ "$v" -gt "$max" ] && max="$v"
    done
    local range=$((max - min))
    [ "$range" -eq 0 ] && range=1
    printf "  "
    for v in "$@"; do
        printf "%s" "${sparks[$(( (v - min) * 7 / range ))]}"
    done
    echo " (min=$min max=$max n=$#)"
}

cmd_gauge() {
    local val="${1:?Usage: data-visualizer gauge <value> <max> [label]}"
    local max="${2:-100}"
    local label="${3:-Gauge}"
    local pct=$((val * 100 / (max > 0 ? max : 1)))
    local filled=$((pct * 30 / 100))
    local empty=$((30 - filled))
    
    echo "  $label"
    printf "  ["
    printf '█%.0s' $(seq 1 "$filled") 2>/dev/null || true
    printf '░%.0s' $(seq 1 "$empty") 2>/dev/null || true
    printf "] %d/%d (%d%%)\n" "$val" "$max" "$pct"
}

cmd_summarize() {
    local file="${1:?Usage: data-visualizer summarize <file>}"
    [ -f "$file" ] || { echo "Not found: $file"; return 1; }
    
    INPUT_FILE="$file" python3 << 'PYEOF'
import csv, sys
import os; fname = os.environ['INPUT_FILE']
with open(fname) as f:
    reader = csv.DictReader(f)
    rows = list(reader)

print("  File: {}".format(fname))
print("  Rows: {}".format(len(rows)))
print("  Columns: {}".format(len(rows[0]) if rows else 0))
print("")

for col in (rows[0].keys() if rows else []):
    vals = []
    for r in rows:
        try: vals.append(float(r[col]))
        except: pass
    if vals:
        vals.sort()
        n = len(vals)
        med = vals[n//2] if n % 2 else (vals[n//2-1] + vals[n//2]) / 2
        print("  {}:".format(col))
        print("    min={:.2f}  max={:.2f}  avg={:.2f}  median={:.2f}".format(
            min(vals), max(vals), sum(vals)/n, med))
PYEOF
}

cmd_distribution() {
    local file="${1:?Usage: data-visualizer distribution <file> [bins]}"
    local bins="${2:-10}"
    [ -f "$file" ] || { echo "Not found: $file"; return 1; }
    
    INPUT_FILE="$file" python3 << 'PYEOF'
import csv
import os; fname = os.environ['INPUT_FILE']
with open(fname) as f:
    reader = csv.reader(f)
    next(reader, None)  # skip header
    vals = []
    for row in reader:
        for cell in row:
            try: vals.append(float(cell))
            except: pass

if not vals:
    print("  No numeric data found")
else:
    mn, mx = min(vals), max(vals)
    bsize = (mx - mn) / $bins if mx > mn else 1
    buckets = [0] * $bins
    for v in vals:
        idx = min(int((v - mn) / bsize), $bins - 1)
        buckets[idx] += 1
    
    mx_count = max(buckets) if buckets else 1
    print("  Distribution ({} values, {} bins):".format(len(vals), $bins))
    for i, count in enumerate(buckets):
        lo = mn + i * bsize
        hi = lo + bsize
        bar = '#' * (count * 30 // mx_count) if mx_count > 0 else ''
        print("  {:8.1f}-{:<8.1f} |{} {}".format(lo, hi, bar, count))
PYEOF
}

cmd_from_csv() {
    local file="${1:?Usage: data-visualizer from-csv <file>}"
    [ -f "$file" ] || { echo "Not found: $file"; return 1; }
    echo "  Auto-visualizing: $file"
    cmd_summarize "$file"
}

cmd_treemap() {
    local total=0
    declare -a labels=() values=()
    for pair in "$@"; do
        labels+=("${pair%%:*}")
        local v="${pair##*:}"
        values+=("$v")
        total=$((total + v))
    done
    [ ${#labels[@]} -eq 0 ] && { echo "Usage: data-visualizer treemap <label:value> ..."; return 1; }
    
    echo "  Treemap (total: $total):"
    for i in "${!labels[@]}"; do
        local v="${values[$i]}"
        local pct=$((v * 100 / (total > 0 ? total : 1)))
        local blocks=$((pct / 2))
        local bar=$(printf '██%.0s' $(seq 1 "$blocks") 2>/dev/null || echo "")
        printf "  %-12s %s %d%% (%d)\n" "${labels[$i]}" "$bar" "$pct" "$v"
    done
}

cmd_heatmap() {
    local rows="${1:?Usage: data-visualizer heatmap <rows> <cols> <data...>}"
    local cols="${2:?Usage: data-visualizer heatmap <rows> <cols> <data...>}"
    shift 2
    local cells=("$@")
    local shades=("░" "▒" "▓" "█")
    
    local max_val=0
    for v in "${cells[@]}"; do
        [ "$v" -gt "$max_val" ] 2>/dev/null && max_val="$v"
    done
    [ "$max_val" -eq 0 ] && max_val=1
    
    echo "  Heatmap (${rows}x${cols}, max=$max_val):"
    local idx=0
    for ((r=0; r<rows; r++)); do
        printf "  "
        for ((c=0; c<cols; c++)); do
            local v="${cells[$idx]:-0}"
            local shade_idx=$((v * 3 / max_val))
            [ "$shade_idx" -gt 3 ] && shade_idx=3
            printf "%s%s" "${shades[$shade_idx]}" "${shades[$shade_idx]}"
            idx=$((idx + 1))
        done
        echo ""
    done
}

cmd_matrix() {
    local file="${1:?Usage: data-visualizer matrix <csv-file>}"
    [ -f "$file" ] || { echo "Not found: $file"; return 1; }
    
    echo "  Matrix view: $file"
    echo ""
    local line_num=0
    while IFS= read -r line; do
        if [ "$line_num" -eq 0 ]; then
            printf "  │ "
            echo "$line" | tr ',' '\t'
            printf "  │"
            echo "$line" | sed 's/[^,]/-/g; s/,/\t/g' | tr -c '\t\n' '-'
            echo ""
        else
            printf "  │ "
            echo "$line" | tr ',' '\t'
        fi
        line_num=$((line_num + 1))
        [ "$line_num" -gt 30 ] && { echo "  ... (showing first 30 rows)"; break; }
    done < "$file"
    echo "  Total: $line_num rows"
}

cmd_correlate() {
    local file="${1:?Usage: data-visualizer correlate <csv-file>}"
    [ -f "$file" ] || { echo "Not found: $file"; return 1; }
    
    INPUT_FILE="$file" python3 << 'PYEOF'
import csv, os, math
fname = os.environ['INPUT_FILE']
with open(fname) as f:
    reader = csv.DictReader(f)
    rows = list(reader)

if not rows:
    print("  No data")
else:
    numeric_cols = []
    for col in rows[0].keys():
        vals = []
        for r in rows:
            try:
                vals.append(float(r[col]))
            except:
                pass
        if len(vals) > 2:
            numeric_cols.append((col, vals))
    
    print("  Correlation matrix ({} numeric columns):".format(len(numeric_cols)))
    print("")
    
    header = "  {:>12}".format("")
    for name, _ in numeric_cols:
        header += " {:>8}".format(name[:8])
    print(header)
    
    for i, (name_i, vals_i) in enumerate(numeric_cols):
        line = "  {:>12}".format(name_i[:12])
        n = min(len(vals_i), min(len(v) for _, v in numeric_cols))
        for j, (name_j, vals_j) in enumerate(numeric_cols):
            vi = vals_i[:n]
            vj = vals_j[:n]
            mean_i = sum(vi) / n
            mean_j = sum(vj) / n
            cov = sum((a - mean_i) * (b - mean_j) for a, b in zip(vi, vj)) / n
            std_i = math.sqrt(sum((a - mean_i) ** 2 for a in vi) / n) or 1
            std_j = math.sqrt(sum((b - mean_j) ** 2 for b in vj) / n) or 1
            r = cov / (std_i * std_j)
            line += " {:>8.3f}".format(r)
        print(line)
PYEOF
}

cmd_normalize() {
    local file="${1:?Usage: data-visualizer normalize <csv-file>}"
    [ -f "$file" ] || { echo "Not found: $file"; return 1; }
    
    INPUT_FILE="$file" python3 << 'PYEOF'
import csv, os
fname = os.environ['INPUT_FILE']
with open(fname) as f:
    reader = csv.DictReader(f)
    rows = list(reader)

if not rows:
    print("  No data")
else:
    cols = list(rows[0].keys())
    print(",".join(cols))
    
    ranges = {}
    for col in cols:
        vals = []
        for r in rows:
            try:
                vals.append(float(r[col]))
            except:
                vals.append(None)
        nums = [v for v in vals if v is not None]
        if nums:
            ranges[col] = (min(nums), max(nums))
        else:
            ranges[col] = None
    
    for r in rows:
        out = []
        for col in cols:
            if ranges.get(col):
                mn, mx = ranges[col]
                try:
                    v = float(r[col])
                    norm = (v - mn) / (mx - mn) if mx > mn else 0
                    out.append("{:.4f}".format(norm))
                except:
                    out.append(r[col])
            else:
                out.append(r[col])
        print(",".join(out))
PYEOF
}

cmd_pivot() {
    local file="${1:?Usage: data-visualizer pivot <csv-file> <group-column>}"
    local group_col="${2:?Usage: data-visualizer pivot <csv-file> <group-column>}"
    [ -f "$file" ] || { echo "Not found: $file"; return 1; }
    
    INPUT_FILE="$file" GROUP_COL="$group_col" python3 << 'PYEOF'
import csv, os
fname = os.environ['INPUT_FILE']
gcol = os.environ['GROUP_COL']

with open(fname) as f:
    reader = csv.DictReader(f)
    rows = list(reader)

if not rows:
    print("  No data")
elif gcol not in rows[0]:
    print("  Column '{}' not found. Available: {}".format(gcol, ", ".join(rows[0].keys())))
else:
    groups = {}
    for r in rows:
        key = r[gcol]
        if key not in groups:
            groups[key] = []
        groups[key].append(r)
    
    print("  Pivot by '{}' ({} groups):".format(gcol, len(groups)))
    print("")
    
    numeric_cols = []
    for col in rows[0].keys():
        if col == gcol:
            continue
        try:
            float(rows[0][col])
            numeric_cols.append(col)
        except:
            pass
    
    for key in sorted(groups.keys()):
        group = groups[key]
        print("  {} ({} rows):".format(key, len(group)))
        for col in numeric_cols:
            vals = []
            for r in group:
                try:
                    vals.append(float(r[col]))
                except:
                    pass
            if vals:
                print("    {}: sum={:.1f} avg={:.1f} min={:.1f} max={:.1f}".format(
                    col, sum(vals), sum(vals)/len(vals), min(vals), max(vals)))
        print("")
PYEOF
}

cmd_from_json() {
    local file="${1:?Usage: data-visualizer from-json <json-file>}"
    [ -f "$file" ] || { echo "Not found: $file"; return 1; }
    
    echo "  Auto-visualizing JSON: $file"
    INPUT_FILE="$file" python3 << 'PYEOF'
import json, os
fname = os.environ['INPUT_FILE']
with open(fname) as f:
    data = json.load(f)

if isinstance(data, list):
    print("  Array with {} items".format(len(data)))
    if data and isinstance(data[0], dict):
        cols = list(data[0].keys())
        print("  Columns: {}".format(", ".join(cols)))
        for col in cols:
            vals = []
            for item in data:
                try:
                    vals.append(float(item.get(col, "")))
                except:
                    pass
            if vals:
                print("  {}: min={:.1f} max={:.1f} avg={:.1f}".format(
                    col, min(vals), max(vals), sum(vals)/len(vals)))
elif isinstance(data, dict):
    print("  Object with {} keys".format(len(data)))
    for k, v in list(data.items())[:20]:
        print("  {}: {} ({})".format(k, str(v)[:40], type(v).__name__))
PYEOF
}

cmd_to_svg() {
    local file="${1:?Usage: data-visualizer to-svg <csv-file>}"
    [ -f "$file" ] || { echo "Not found: $file"; return 1; }
    
    local outfile="${file%.csv}.svg"
    INPUT_FILE="$file" OUTPUT_FILE="$outfile" python3 << 'PYEOF'
import csv, os
fname = os.environ['INPUT_FILE']
outname = os.environ['OUTPUT_FILE']

with open(fname) as f:
    reader = csv.reader(f)
    header = next(reader, None)
    rows_data = list(reader)

vals = []
labels = []
for row in rows_data:
    if row:
        labels.append(row[0] if row else "")
        for cell in row[1:]:
            try:
                vals.append(float(cell))
                break
            except:
                pass

if not vals:
    print("  No numeric data for SVG chart")
else:
    mx = max(vals) if vals else 1
    w, h = 500, 300
    bar_w = w // (len(vals) + 1)
    
    svg = ['<svg xmlns="http://www.w3.org/2000/svg" width="{}" height="{}">'.format(w, h)]
    svg.append('<rect width="100%" height="100%" fill="white"/>')
    
    for i, v in enumerate(vals):
        bar_h = int(v / mx * (h - 40))
        x = 20 + i * bar_w
        y = h - 20 - bar_h
        svg.append('<rect x="{}" y="{}" width="{}" height="{}" fill="#4285f4"/>'.format(
            x, y, bar_w - 4, bar_h))
        lbl = labels[i] if i < len(labels) else str(i)
        svg.append('<text x="{}" y="{}" font-size="10" text-anchor="middle">{}</text>'.format(
            x + bar_w//2, h - 5, lbl[:8]))
    
    svg.append('</svg>')
    
    with open(outname, 'w') as f:
        f.write('\n'.join(svg))
    print("  SVG chart saved: {}".format(outname))
PYEOF
}

cmd_to_html() {
    local file="${1:?Usage: data-visualizer to-html <csv-file>}"
    [ -f "$file" ] || { echo "Not found: $file"; return 1; }
    
    local outfile="${file%.csv}.html"
    echo "<!DOCTYPE html><html><head><title>Data Visualization</title>" > "$outfile"
    echo "<style>table{border-collapse:collapse;margin:20px}td,th{border:1px solid #ddd;padding:8px;text-align:right}th{background:#4285f4;color:white}</style>" >> "$outfile"
    echo "</head><body><h2>$(basename "$file")</h2><table>" >> "$outfile"
    
    local first=true
    while IFS= read -r line; do
        if $first; then
            echo "<tr>$(echo "$line" | sed 's/,/<\/th><th>/g; s/^/<th>/; s/$/<\/th>/')</tr>" >> "$outfile"
            first=false
        else
            echo "<tr>$(echo "$line" | sed 's/,/<\/td><td>/g; s/^/<td>/; s/$/<\/td>/')</tr>" >> "$outfile"
        fi
    done < "$file"
    
    echo "</table></body></html>" >> "$outfile"
    echo "  HTML table saved: $outfile"
}

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

show_version() {
    echo "data-visualizer v$VERSION"
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

case "${1:-help}" in
    bar)          shift; cmd_bar "$@" ;;
    histogram)    shift; cmd_histogram "$@" ;;
    sparkline)    shift; cmd_sparkline "$@" ;;
    heatmap)      shift; cmd_heatmap "$@" ;;
    treemap)      shift; cmd_treemap "$@" ;;
    gauge)        shift; cmd_gauge "$@" ;;
    matrix)       shift; cmd_matrix "$@" ;;
    summarize)    shift; cmd_summarize "$@" ;;
    distribution) shift; cmd_distribution "$@" ;;
    correlate)    shift; cmd_correlate "$@" ;;
    normalize)    shift; cmd_normalize "$@" ;;
    pivot)        shift; cmd_pivot "$@" ;;
    from-csv)     shift; cmd_from_csv "$@" ;;
    from-json)    shift; cmd_from_json "$@" ;;
    to-svg)       shift; cmd_to_svg "$@" ;;
    to-html)      shift; cmd_to_html "$@" ;;
    help|-h)      show_help ;;
    version|-v)   show_version ;;
    *)            echo "Unknown: $1"; show_help; exit 1 ;;
esac
