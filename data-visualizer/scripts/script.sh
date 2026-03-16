#!/usr/bin/env bash
# data-visualizer — Terminal data visualization toolkit
set -euo pipefail
VERSION="2.0.0"
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
    
    python3 << PYEOF
import csv, sys
with open('$file') as f:
    reader = csv.DictReader(f)
    rows = list(reader)

print("  File: $file")
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
    
    python3 << PYEOF
import csv
with open('$file') as f:
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

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

case "${1:-help}" in
    bar)          shift; cmd_bar "$@" ;;
    histogram)    shift; cmd_histogram "$@" ;;
    sparkline)    shift; cmd_sparkline "$@" ;;
    heatmap)      shift; echo "TODO: heatmap" ;;
    treemap)      shift; cmd_treemap "$@" ;;
    gauge)        shift; cmd_gauge "$@" ;;
    matrix)       shift; echo "TODO: matrix" ;;
    summarize)    shift; cmd_summarize "$@" ;;
    distribution) shift; cmd_distribution "$@" ;;
    correlate)    shift; echo "TODO: correlate" ;;
    normalize)    shift; echo "TODO: normalize" ;;
    pivot)        shift; echo "TODO: pivot" ;;
    from-csv)     shift; cmd_from_csv "$@" ;;
    from-json)    shift; echo "TODO: from-json" ;;
    to-svg)       shift; echo "TODO: svg export" ;;
    to-html)      shift; echo "TODO: html export" ;;
    help|-h)      show_help ;;
    version|-v)   echo "data-visualizer v$VERSION" ;;
    *)            echo "Unknown: $1"; show_help; exit 1 ;;
esac
