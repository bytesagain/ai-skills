#!/usr/bin/env bash
# bytesagain-chart-generator — ASCII chart generator
set -euo pipefail

CMD="${1:-help}"
shift || true
INPUT="${*:-}"

show_help() {
    echo "bytesagain-chart-generator — Terminal ASCII chart generator"
    echo ""
    echo "Usage:"
    echo "  bytesagain-chart-generator bar  <file_or_data>   Bar chart"
    echo "  bytesagain-chart-generator line <file_or_data>   Line chart"
    echo "  bytesagain-chart-generator pie  <file_or_data>   Pie chart"
    echo "  bytesagain-chart-generator scatter <file>        Scatter plot"
    echo "  bytesagain-chart-generator demo                  Show examples"
    echo ""
    echo "Data format: 'Label:Value,Label:Value' or CSV file"
    echo ""
}

parse_input() {
    local raw="$1"
    if [ -f "$raw" ]; then
        cat "$raw"
    else
        echo "$raw" | tr ',' '\n' | tr ':' ','
    fi
}

cmd_bar() {
    local data
    data=$(parse_input "$INPUT")
    python3 << 'PYEOF'
import sys, os

raw = os.environ.get("CHART_DATA", "")
lines = [l.strip() for l in raw.strip().split("\n") if l.strip()]

items = []
for line in lines:
    parts = line.split(",")
    if len(parts) >= 2:
        try:
            items.append((parts[0].strip(), float(parts[1].strip())))
        except ValueError:
            continue

if not items:
    print("No data to chart. Format: 'Label:Value,Label:Value'")
    sys.exit(0)

max_val = max(v for _, v in items)
max_label = max(len(l) for l, _ in items)
bar_width = 40

print(f"\n{'Label':<{max_label}}  {'Value':>8}  Chart")
print("─" * (max_label + bar_width + 15))
for label, val in items:
    bar_len = int((val / max_val) * bar_width)
    bar = "█" * bar_len
    pct = (val / sum(v for _, v in items)) * 100
    print(f"{label:<{max_label}}  {val:>8.1f}  {bar} {pct:.1f}%")
print()
PYEOF
}

cmd_line() {
    local data
    data=$(parse_input "$INPUT")
    python3 << 'PYEOF'
import sys, os

raw = os.environ.get("CHART_DATA", "")
lines = [l.strip() for l in raw.strip().split("\n") if l.strip()]

items = []
for line in lines:
    parts = line.split(",")
    if len(parts) >= 2:
        try:
            items.append((parts[0].strip(), float(parts[1].strip())))
        except ValueError:
            continue

if not items:
    print("No data. Format: 'Jan:100,Feb:150,Mar:120'")
    sys.exit(0)

labels = [l for l, _ in items]
values = [v for _, v in items]
height = 15
width = max(len(labels) * 4, 40)

min_v, max_v = min(values), max(values)
range_v = max_v - min_v or 1

print()
for row in range(height, -1, -1):
    threshold = min_v + (row / height) * range_v
    if row % 3 == 0:
        line = f"{threshold:>8.1f} |"
    else:
        line = f"{'':>8} |"
    for i, v in enumerate(values):
        col = " "
        normalized = (v - min_v) / range_v * height
        if abs(normalized - row) < 0.6:
            col = "●"
        elif i > 0:
            prev_n = (values[i-1] - min_v) / range_v * height
            if (prev_n < row < normalized) or (normalized < row < prev_n):
                col = "│"
        line += f"  {col} "
    print(line)

print(f"{'':>9}+" + "─" * (len(values) * 4 + 2))
label_line = f"{'':>10}"
for l in labels:
    label_line += f"{l[:4]:<4}"
print(label_line)
print()
PYEOF
}

cmd_pie() {
    local data
    data=$(parse_input "$INPUT")
    python3 << 'PYEOF'
import sys, os

raw = os.environ.get("CHART_DATA", "")
lines = [l.strip() for l in raw.strip().split("\n") if l.strip()]

items = []
for line in lines:
    parts = line.split(",")
    if len(parts) >= 2:
        try:
            items.append((parts[0].strip(), float(parts[1].strip())))
        except ValueError:
            continue

if not items:
    print("No data. Format: 'Apple:45,Google:30,Others:25'")
    sys.exit(0)

total = sum(v for _, v in items)
chars = ["█", "▓", "▒", "░", "▪", "▫", "◆", "◇"]
bar_width = 40

print(f"\n  Pie Chart (total: {total:.1f})\n")
print(f"  {'Category':<20} {'Value':>8}  {'Share':>6}  Distribution")
print(f"  {'─'*20} {'─'*8}  {'─'*6}  {'─'*bar_width}")

for i, (label, val) in enumerate(items):
    pct = (val / total) * 100
    bar_len = int(pct / 100 * bar_width)
    bar = chars[i % len(chars)] * bar_len
    print(f"  {label:<20} {val:>8.1f}  {pct:>5.1f}%  {bar}")

print()
PYEOF
}

cmd_scatter() {
    python3 << 'PYEOF'
import sys, os

raw = os.environ.get("CHART_DATA", "")
lines = [l.strip() for l in raw.strip().split("\n") if l.strip() and not l.startswith("#")]

points = []
for line in lines:
    parts = line.replace(",", " ").split()
    if len(parts) >= 2:
        try:
            points.append((float(parts[0]), float(parts[1])))
        except ValueError:
            continue

if not points:
    print("No data. Format: 'x1,y1' per line or 'x1:y1,x2:y2'")
    sys.exit(0)

width, height = 60, 20
xs = [p[0] for p in points]
ys = [p[1] for p in points]
min_x, max_x = min(xs), max(xs)
min_y, max_y = min(ys), max(ys)
rx = max_x - min_x or 1
ry = max_y - min_y or 1

grid = [[" "] * width for _ in range(height)]
for x, y in points:
    col = int((x - min_x) / rx * (width - 1))
    row = height - 1 - int((y - min_y) / ry * (height - 1))
    grid[row][col] = "●"

print()
for i, row in enumerate(grid):
    y_val = max_y - (i / (height-1)) * ry
    if i % 4 == 0:
        print(f"{y_val:>8.1f} |{''.join(row)}")
    else:
        print(f"{'':>8} |{''.join(row)}")

print(f"{'':>9}+" + "─" * width)
print(f"{'':>10}{min_x:<10.1f}{'':>{width//2-10}}{max_x:.1f}")
print()
PYEOF
}

cmd_demo() {
    echo "=== Bar Chart Demo ==="
    export CHART_DATA=$'Q1,1200\nQ2,1850\nQ3,1420\nQ4,2100'
    cmd_bar

    echo "=== Line Chart Demo ==="
    export CHART_DATA=$'Jan,320\nFeb,450\nMar,380\nApr,520\nMay,490\nJun,610'
    cmd_line

    echo "=== Pie Chart Demo ==="
    export CHART_DATA=$'Chrome,65\nFirefox,15\nSafari,12\nOthers,8'
    cmd_pie

    echo "=== Scatter Plot Demo ==="
    export CHART_DATA=$'1,2\n2,4\n3,3\n4,7\n5,6\n6,9\n7,8\n8,11'
    cmd_scatter
}

case "$CMD" in
    bar)     export CHART_DATA=$(parse_input "$INPUT"); cmd_bar ;;
    line)    export CHART_DATA=$(parse_input "$INPUT"); cmd_line ;;
    pie)     export CHART_DATA=$(parse_input "$INPUT"); cmd_pie ;;
    scatter) export CHART_DATA=$(parse_input "$INPUT"); cmd_scatter ;;
    demo)    cmd_demo ;;
    help|--help|-h) show_help ;;
    *) echo "Unknown command: $CMD"; show_help; exit 1 ;;
esac
