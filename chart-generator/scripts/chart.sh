#!/usr/bin/env bash
# chart.sh — Data visualization chart generator
# Usage: chart.sh <command> <data> [options]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_help() {
    cat <<'EOF'
chart.sh — 数据可视化图表生成器

Usage:
  chart.sh bar "标签1:值1,标签2:值2" [--title "标题"]     ASCII柱状图
  chart.sh line "1,5,3,8,2,7" [--title "趋势"]            ASCII折线图
  chart.sh pie "A:30,B:50,C:20" [--title "分布"]           ASCII饼图
  chart.sh table "H1,H2,H3|R1,R2,R3|..."                  格式化表格
  chart.sh html-bar "A:30,B:50" --output chart.html        HTML图表
  chart.sh sparkline "1,5,3,8,2,7,4,9"                    迷你趋势图
  chart.sh dashboard "标题"                                数据看板模板
  chart.sh progress "已完成,总数" [--title "标题"]          进度条可视化
  chart.sh trend "1,5,3,8,2,7" [--title "趋势"]            趋势分析+变化率
  chart.sh heatmap "1,2,3|4,5,6|7,8,9" [--title "热力"]   ASCII热力图
  chart.sh svg-bar "标题" "标签:值,标签:值" [--color blue]  SVG柱状图文件
  chart.sh svg-pie "标题" "类别:值,类别:值"                SVG饼图文件
  chart.sh svg-line "标题" "1月:100,2月:150"               SVG折线图文件
  chart.sh help                                            显示帮助

Data formats:
  键值对: "标签:数值,标签:数值"    (bar, pie, html-bar)
  纯数值: "1,5,3,8"              (line, sparkline)
  表格:   "H1,H2|R1C1,R1C2|..."  (table, | 分隔行)
EOF
}

if [ $# -lt 1 ]; then
    show_help
    exit 1
fi

CMD="$1"

if [ "$CMD" = "help" ]; then
    show_help
    exit 0
fi

# ── SVG commands (different arg pattern) ───────────────────────────────
case "$CMD" in
    svg-bar|svg-pie|svg-line)
        if [ $# -lt 3 ]; then
            echo "Usage: chart.sh $CMD \"标题\" \"标签:值,标签:值\" [--color blue|green|red|rainbow]" >&2
            exit 1
        fi
        SVG_TITLE="$2"
        SVG_DATA="$3"
        shift 3
        SVG_COLOR="blue"
        while [ $# -gt 0 ]; do
            case "$1" in
                --color) SVG_COLOR="${2:-blue}"; shift 2 ;;
                *) shift ;;
            esac
        done
        export SVG_CMD="$CMD"
        export SVG_TITLE
        export SVG_DATA
        export SVG_COLOR
        python3 << 'SVGPYEOF'
# -*- coding: utf-8 -*-
from __future__ import print_function
import os, math, re

cmd = os.environ.get('SVG_CMD', '')
title = os.environ.get('SVG_TITLE', 'chart')
data_raw = os.environ.get('SVG_DATA', '')
color_scheme = os.environ.get('SVG_COLOR', 'blue')

def safe_filename(s):
    s = re.sub(r'[^\w\u4e00-\u9fff-]', '_', s)
    return s.strip('_') or 'chart'

def parse_kv(raw):
    pairs = []
    for item in raw.split(","):
        item = item.strip()
        if ":" not in item:
            raise ValueError("Expected 'label:value', got: {}".format(item))
        parts = item.rsplit(":", 1)
        pairs.append((parts[0].strip(), float(parts[1].strip())))
    return pairs

def get_colors(n, scheme):
    palettes = {
        'blue':    ['#1e88e5','#42a5f5','#64b5f6','#90caf9','#bbdefb','#1565c0','#0d47a1','#82b1ff'],
        'green':   ['#43a047','#66bb6a','#81c784','#a5d6a7','#c8e6c9','#2e7d32','#1b5e20','#69f0ae'],
        'red':     ['#e53935','#ef5350','#e57373','#ef9a9a','#ffcdd2','#c62828','#b71c1c','#ff8a80'],
        'rainbow': ['#e53935','#fb8c00','#fdd835','#43a047','#1e88e5','#8e24aa','#f06292','#00acc1'],
    }
    pal = palettes.get(scheme, palettes['blue'])
    return [pal[i % len(pal)] for i in range(n)]

# ── SVG BAR ──────────────────────────────────────────────
def svg_bar(title, data_raw, color_scheme):
    pairs = parse_kv(data_raw)
    n = len(pairs)
    colors = get_colors(n, color_scheme)
    max_val = max(p[1] for p in pairs) if pairs else 1

    margin_left = 120
    margin_top = 60
    margin_right = 60
    margin_bottom = 80
    bar_w = 50
    gap = 20
    chart_h = 300

    chart_w = n * (bar_w + gap) + gap
    svg_w = margin_left + chart_w + margin_right
    svg_h = margin_top + chart_h + margin_bottom

    parts = []
    parts.append('<?xml version="1.0" encoding="UTF-8"?>')
    parts.append('<svg xmlns="http://www.w3.org/2000/svg" width="{}" height="{}" viewBox="0 0 {} {}">'.format(svg_w, svg_h, svg_w, svg_h))
    parts.append('<rect width="100%" height="100%" fill="#fafafa"/>')

    # Title
    parts.append('<text x="{}" y="35" text-anchor="middle" font-family="system-ui,sans-serif" font-size="20" font-weight="bold" fill="#333">{}</text>'.format(svg_w/2, title))

    # Y-axis ticks
    num_ticks = 5
    for i in range(num_ticks + 1):
        val = max_val * i / num_ticks
        y = margin_top + chart_h - (chart_h * i / num_ticks)
        val_str = str(int(val)) if val == int(val) else "{:.1f}".format(val)
        parts.append('<line x1="{}" y1="{}" x2="{}" y2="{}" stroke="#ddd" stroke-width="1"/>'.format(margin_left, y, margin_left + chart_w, y))
        parts.append('<text x="{}" y="{}" text-anchor="end" font-family="system-ui,sans-serif" font-size="12" fill="#666">{}</text>'.format(margin_left - 8, y + 4, val_str))

    # Y-axis line
    parts.append('<line x1="{}" y1="{}" x2="{}" y2="{}" stroke="#999" stroke-width="1.5"/>'.format(margin_left, margin_top, margin_left, margin_top + chart_h))
    # X-axis line
    parts.append('<line x1="{}" y1="{}" x2="{}" y2="{}" stroke="#999" stroke-width="1.5"/>'.format(margin_left, margin_top + chart_h, margin_left + chart_w, margin_top + chart_h))

    # Bars
    for i, (label, val) in enumerate(pairs):
        x = margin_left + gap + i * (bar_w + gap)
        bar_h = (val / max_val * chart_h) if max_val > 0 else 0
        y = margin_top + chart_h - bar_h
        color = colors[i]
        val_str = str(int(val)) if val == int(val) else "{:.1f}".format(val)

        parts.append('<rect x="{}" y="{}" width="{}" height="{}" fill="{}" rx="3"/>'.format(x, y, bar_w, bar_h, color))
        parts.append('<text x="{}" y="{}" text-anchor="middle" font-family="system-ui,sans-serif" font-size="12" fill="#333">{}</text>'.format(x + bar_w/2, y - 6, val_str))
        parts.append('<text x="{}" y="{}" text-anchor="middle" font-family="system-ui,sans-serif" font-size="12" fill="#555">{}</text>'.format(x + bar_w/2, margin_top + chart_h + 20, label))

    parts.append('</svg>')

    fname = "chart_{}.svg".format(safe_filename(title))
    with open(fname, 'w', encoding='utf-8') as f:
        f.write('\n'.join(parts))
    print("")
    print("✅ 图表已生成: {}".format(fname))
    print("   用浏览器打开即可查看")
    print("")

# ── SVG PIE ──────────────────────────────────────────────
def svg_pie(title, data_raw, color_scheme):
    pairs = parse_kv(data_raw)
    n = len(pairs)
    colors = get_colors(n, color_scheme)
    total = sum(p[1] for p in pairs)
    if total <= 0:
        print("Error: total must be > 0")
        return

    svg_w = 500
    svg_h = 420
    cx, cy, r = 200, 210, 150

    parts = []
    parts.append('<?xml version="1.0" encoding="UTF-8"?>')
    parts.append('<svg xmlns="http://www.w3.org/2000/svg" width="{}" height="{}" viewBox="0 0 {} {}">'.format(svg_w, svg_h, svg_w, svg_h))
    parts.append('<rect width="100%" height="100%" fill="#fafafa"/>')
    parts.append('<text x="{}" y="35" text-anchor="middle" font-family="system-ui,sans-serif" font-size="20" font-weight="bold" fill="#333">{}</text>'.format(svg_w/2, title))

    start_angle = -math.pi / 2  # Start from top
    for i, (label, val) in enumerate(pairs):
        pct = val / total
        angle = pct * 2 * math.pi
        end_angle = start_angle + angle
        large_arc = 1 if angle > math.pi else 0

        x1 = cx + r * math.cos(start_angle)
        y1 = cy + r * math.sin(start_angle)
        x2 = cx + r * math.cos(end_angle)
        y2 = cy + r * math.sin(end_angle)

        if abs(pct - 1.0) < 0.001:
            # Full circle: draw as two half arcs
            xm = cx + r * math.cos(start_angle + math.pi)
            ym = cy + r * math.sin(start_angle + math.pi)
            d = "M {},{} A {},{} 0 1,1 {},{} A {},{} 0 1,1 {},{}".format(
                x1, y1, r, r, xm, ym, r, r, x2, y2)
        else:
            d = "M {},{} L {},{} A {},{} 0 {},{} {},{} Z".format(
                cx, cy, x1, y1, r, r, large_arc, 1, x2, y2)

        parts.append('<path d="{}" fill="{}" stroke="#fff" stroke-width="2"/>'.format(d, colors[i]))

        # Percentage label on the slice
        mid_angle = start_angle + angle / 2
        lx = cx + r * 0.65 * math.cos(mid_angle)
        ly = cy + r * 0.65 * math.sin(mid_angle)
        pct_str = "{:.1f}%".format(pct * 100)
        parts.append('<text x="{:.1f}" y="{:.1f}" text-anchor="middle" font-family="system-ui,sans-serif" font-size="12" font-weight="bold" fill="#fff">{}</text>'.format(lx, ly, pct_str))

        start_angle = end_angle

    # Legend
    legend_x = 380
    legend_y = 80
    for i, (label, val) in enumerate(pairs):
        pct = val / total * 100
        ly = legend_y + i * 25
        parts.append('<rect x="{}" y="{}" width="14" height="14" fill="{}" rx="2"/>'.format(legend_x, ly, colors[i]))
        parts.append('<text x="{}" y="{}" font-family="system-ui,sans-serif" font-size="12" fill="#555">{} ({:.1f}%)</text>'.format(legend_x + 20, ly + 12, label, pct))

    parts.append('</svg>')

    fname = "chart_{}.svg".format(safe_filename(title))
    with open(fname, 'w', encoding='utf-8') as f:
        f.write('\n'.join(parts))
    print("")
    print("✅ 图表已生成: {}".format(fname))
    print("   用浏览器打开即可查看")
    print("")

# ── SVG LINE ─────────────────────────────────────────────
def svg_line(title, data_raw, color_scheme):
    pairs = parse_kv(data_raw)
    n = len(pairs)
    colors = get_colors(1, color_scheme)
    line_color = colors[0]

    labels = [p[0] for p in pairs]
    values = [p[1] for p in pairs]
    min_val = min(values)
    max_val = max(values)
    val_range = max_val - min_val if max_val != min_val else 1

    margin_left = 80
    margin_top = 60
    margin_right = 40
    margin_bottom = 80
    chart_w = max(n * 70, 300)
    chart_h = 280

    svg_w = margin_left + chart_w + margin_right
    svg_h = margin_top + chart_h + margin_bottom

    parts = []
    parts.append('<?xml version="1.0" encoding="UTF-8"?>')
    parts.append('<svg xmlns="http://www.w3.org/2000/svg" width="{}" height="{}" viewBox="0 0 {} {}">'.format(svg_w, svg_h, svg_w, svg_h))
    parts.append('<rect width="100%" height="100%" fill="#fafafa"/>')
    parts.append('<text x="{}" y="35" text-anchor="middle" font-family="system-ui,sans-serif" font-size="20" font-weight="bold" fill="#333">{}</text>'.format(svg_w/2, title))

    # Y-axis ticks
    num_ticks = 5
    for i in range(num_ticks + 1):
        val = min_val + val_range * i / num_ticks
        y = margin_top + chart_h - (chart_h * i / num_ticks)
        val_str = str(int(val)) if val == int(val) else "{:.1f}".format(val)
        parts.append('<line x1="{}" y1="{}" x2="{}" y2="{}" stroke="#eee" stroke-width="1"/>'.format(margin_left, y, margin_left + chart_w, y))
        parts.append('<text x="{}" y="{}" text-anchor="end" font-family="system-ui,sans-serif" font-size="11" fill="#888">{}</text>'.format(margin_left - 8, y + 4, val_str))

    # Axes
    parts.append('<line x1="{}" y1="{}" x2="{}" y2="{}" stroke="#999" stroke-width="1.5"/>'.format(margin_left, margin_top, margin_left, margin_top + chart_h))
    parts.append('<line x1="{}" y1="{}" x2="{}" y2="{}" stroke="#999" stroke-width="1.5"/>'.format(margin_left, margin_top + chart_h, margin_left + chart_w, margin_top + chart_h))

    # Compute points
    points = []
    step = chart_w / max(n - 1, 1)
    for i, val in enumerate(values):
        x = margin_left + i * step
        y = margin_top + chart_h - ((val - min_val) / val_range * chart_h)
        points.append((x, y))

    # Area fill
    area_pts = ["{:.1f},{:.1f}".format(p[0], p[1]) for p in points]
    area_pts.append("{:.1f},{:.1f}".format(points[-1][0], margin_top + chart_h))
    area_pts.append("{:.1f},{:.1f}".format(points[0][0], margin_top + chart_h))
    parts.append('<polygon points="{}" fill="{}" opacity="0.1"/>'.format(' '.join(area_pts), line_color))

    # Line
    line_pts = ' '.join(["{:.1f},{:.1f}".format(p[0], p[1]) for p in points])
    parts.append('<polyline points="{}" fill="none" stroke="{}" stroke-width="2.5" stroke-linejoin="round"/>'.format(line_pts, line_color))

    # Dots + labels
    for i, (x, y) in enumerate(points):
        val = values[i]
        val_str = str(int(val)) if val == int(val) else "{:.1f}".format(val)
        parts.append('<circle cx="{:.1f}" cy="{:.1f}" r="4" fill="{}" stroke="#fff" stroke-width="2"/>'.format(x, y, line_color))
        parts.append('<text x="{:.1f}" y="{:.1f}" text-anchor="middle" font-family="system-ui,sans-serif" font-size="11" fill="#333">{}</text>'.format(x, y - 10, val_str))
        # X-axis label
        parts.append('<text x="{:.1f}" y="{}" text-anchor="middle" font-family="system-ui,sans-serif" font-size="11" fill="#666">{}</text>'.format(x, margin_top + chart_h + 20, labels[i]))

    parts.append('</svg>')

    fname = "chart_{}.svg".format(safe_filename(title))
    with open(fname, 'w', encoding='utf-8') as f:
        f.write('\n'.join(parts))
    print("")
    print("✅ 图表已生成: {}".format(fname))
    print("   用浏览器打开即可查看")
    print("")

# ── Dispatch ─────────────────────────────────────────────
if cmd == 'svg-bar':
    svg_bar(title, data_raw, color_scheme)
elif cmd == 'svg-pie':
    svg_pie(title, data_raw, color_scheme)
elif cmd == 'svg-line':
    svg_line(title, data_raw, color_scheme)
else:
    print("Unknown SVG command: {}".format(cmd))
    import sys
    sys.exit(1)
SVGPYEOF
        exit $?
        ;;
esac

if [ $# -lt 2 ]; then
    echo "Error: missing data argument. Run 'chart.sh help' for usage." >&2
    exit 1
fi

DATA="$2"
shift 2

# Parse remaining options
TITLE=""
OUTPUT=""
while [ $# -gt 0 ]; do
    case "$1" in
        --title)
            TITLE="$2"
            shift 2
            ;;
        --output)
            OUTPUT="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
done

# ── Python dispatcher ──────────────────────────────────────────────────
python3 - "$CMD" "$DATA" "$TITLE" "$OUTPUT" <<'PYEOF'
# -*- coding: utf-8 -*-
from __future__ import print_function
import sys
import math

cmd = sys.argv[1]
data_raw = sys.argv[2]
title = sys.argv[3] if len(sys.argv) > 3 else ""
output = sys.argv[4] if len(sys.argv) > 4 else ""


def parse_kv(raw):
    """Parse 'label:value,label:value' into list of (label, float)."""
    pairs = []
    for item in raw.split(","):
        item = item.strip()
        if ":" not in item:
            raise ValueError("Expected 'label:value' format, got: {}".format(item))
        parts = item.rsplit(":", 1)
        pairs.append((parts[0].strip(), float(parts[1].strip())))
    return pairs


def parse_values(raw):
    """Parse '1,5,3,8' into list of floats."""
    return [float(x.strip()) for x in raw.split(",")]


# ── BAR CHART ──────────────────────────────────────────────────────────

def cmd_bar(data_raw, title):
    pairs = parse_kv(data_raw)
    if not pairs:
        return
    labels = [p[0] for p in pairs]
    values = [p[1] for p in pairs]
    max_val = max(values) if values else 1
    max_label_len = max(len(l) for l in labels)
    bar_width = 40

    if title:
        print("")
        print("  {}".format(title))
        print("  {}".format("─" * (bar_width + max_label_len + 10)))

    print("")
    for label, val in pairs:
        filled = int(round(val / max_val * bar_width)) if max_val > 0 else 0
        bar = "█" * filled
        padding = " " * (max_label_len - len(label))
        # Format value: integer if whole, else 1 decimal
        if val == int(val):
            val_str = str(int(val))
        else:
            val_str = "{:.1f}".format(val)
        print("  {}{} │ {} {}".format(padding, label, bar, val_str))

    print("")


# ── LINE CHART ─────────────────────────────────────────────────────────

def cmd_line(data_raw, title):
    values = parse_values(data_raw)
    if not values:
        return

    height = 12
    min_val = min(values)
    max_val = max(values)
    val_range = max_val - min_val if max_val != min_val else 1

    if title:
        print("")
        print("  {}".format(title))

    # Build grid
    grid = [[" " for _ in range(len(values))] for _ in range(height)]

    for col, val in enumerate(values):
        row = int(round((val - min_val) / val_range * (height - 1)))
        grid[row][col] = "●"

    # Connect dots with lines between points
    for col in range(len(values) - 1):
        row1 = int(round((values[col] - min_val) / val_range * (height - 1)))
        row2 = int(round((values[col + 1] - min_val) / val_range * (height - 1)))
        if abs(row2 - row1) > 1:
            step = 1 if row2 > row1 else -1
            for r in range(row1 + step, row2, step):
                if grid[r][col] == " ":
                    grid[r][col] = "│"

    # Axis labels
    max_lbl = "{:.1f}".format(max_val) if max_val != int(max_val) else str(int(max_val))
    min_lbl = "{:.1f}".format(min_val) if min_val != int(min_val) else str(int(min_val))
    lbl_w = max(len(max_lbl), len(min_lbl))

    print("")
    for row_idx in range(height - 1, -1, -1):
        if row_idx == height - 1:
            lbl = max_lbl.rjust(lbl_w)
        elif row_idx == 0:
            lbl = min_lbl.rjust(lbl_w)
        else:
            lbl = " " * lbl_w
        print("  {} │ {}".format(lbl, "".join(grid[row_idx])))

    print("  {} └─{}".format(" " * lbl_w, "─" * len(values)))

    # X-axis indices
    idx_line = "".join(str(i % 10) for i in range(len(values)))
    print("  {}   {}".format(" " * lbl_w, idx_line))
    print("")


# ── PIE CHART (percentage bar) ─────────────────────────────────────────

def cmd_pie(data_raw, title):
    pairs = parse_kv(data_raw)
    if not pairs:
        return
    total = sum(p[1] for p in pairs)
    if total <= 0:
        print("Error: total must be > 0")
        return

    bar_width = 50
    blocks = ["█", "▓", "░", "▒", "▊", "▋", "▌", "▍"]

    if title:
        print("")
        print("  {}".format(title))

    # Full bar
    print("")
    bar = ""
    for i, (label, val) in enumerate(pairs):
        seg_len = int(round(val / total * bar_width))
        if seg_len < 1:
            seg_len = 1
        char = blocks[i % len(blocks)]
        bar += char * seg_len
    print("  [{}]".format(bar[:bar_width]))
    print("")

    # Legend
    max_label_len = max(len(p[0]) for p in pairs)
    for i, (label, val) in enumerate(pairs):
        pct = val / total * 100
        char = blocks[i % len(blocks)]
        padding = " " * (max_label_len - len(label))
        val_str = str(int(val)) if val == int(val) else "{:.1f}".format(val)
        print("  {} {}{} {:5.1f}%  ({})".format(char * 2, padding, label, pct, val_str))

    print("")


# ── TABLE ──────────────────────────────────────────────────────────────

def cmd_table(data_raw):
    rows = [r.strip() for r in data_raw.split("|")]
    if not rows:
        return
    parsed = [r.split(",") for r in rows]
    # Strip whitespace
    parsed = [[c.strip() for c in row] for row in parsed]

    # Calculate column widths
    num_cols = max(len(row) for row in parsed)
    col_widths = [0] * num_cols
    for row in parsed:
        for i, cell in enumerate(row):
            if i < num_cols:
                col_widths[i] = max(col_widths[i], len(cell))

    def fmt_row(row):
        cells = []
        for i in range(num_cols):
            val = row[i] if i < len(row) else ""
            cells.append(" {} ".format(val.ljust(col_widths[i])))
        return "│".join(cells)

    separator = "┼".join("─" * (w + 2) for w in col_widths)

    print("")
    # Header
    if parsed:
        print("  │{}│".format(fmt_row(parsed[0])))
        print("  │{}│".format(separator))
        for row in parsed[1:]:
            print("  │{}│".format(fmt_row(row)))
    print("")


# ── HTML BAR ───────────────────────────────────────────────────────────

def cmd_html_bar(data_raw, title, output):
    if not output:
        print("Error: --output is required for html-bar", file=sys.stderr)
        sys.exit(1)

    pairs = parse_kv(data_raw)
    if not pairs:
        return
    max_val = max(p[1] for p in pairs) if pairs else 1

    colors = ["#4e79a7", "#f28e2b", "#e15759", "#76b7b2", "#59a14f",
              "#edc948", "#b07aa1", "#ff9da7", "#9c755f", "#bab0ac"]

    svg_bars = []
    bar_height = 36
    gap = 12
    chart_width = 500
    chart_height = len(pairs) * (bar_height + gap) + 40
    y = 30

    title_str = title if title else "Bar Chart"

    for i, (label, val) in enumerate(pairs):
        w = int(val / max_val * 380) if max_val > 0 else 0
        color = colors[i % len(colors)]
        val_str = str(int(val)) if val == int(val) else "{:.1f}".format(val)
        svg_bars.append(
            '    <text x="95" y="{ty}" text-anchor="end" '
            'font-family="system-ui,sans-serif" font-size="14" fill="#333">'
            '{label}</text>\n'
            '    <rect x="100" y="{ry}" width="{w}" height="{h}" '
            'fill="{color}" rx="4"/>\n'
            '    <text x="{tx}" y="{ty}" font-family="system-ui,sans-serif" '
            'font-size="13" fill="#555">{val}</text>'.format(
                ty=y + bar_height // 2 + 5,
                label=label,
                ry=y,
                w=w,
                h=bar_height,
                color=color,
                tx=w + 108,
                val=val_str
            )
        )
        y += bar_height + gap

    html = """<!DOCTYPE html>
<html lang="zh">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{title}</title>
<style>
  body {{
    font-family: system-ui, -apple-system, sans-serif;
    background: #f8f9fa;
    display: flex;
    justify-content: center;
    padding: 40px 20px;
    margin: 0;
  }}
  .chart-container {{
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 2px 12px rgba(0,0,0,0.08);
    padding: 32px;
    max-width: 600px;
    width: 100%;
  }}
  h2 {{
    margin: 0 0 20px 0;
    color: #1a1a2e;
    font-weight: 600;
  }}
</style>
</head>
<body>
<div class="chart-container">
  <h2>{title}</h2>
  <svg width="100%" viewBox="0 0 {svg_w} {svg_h}" xmlns="http://www.w3.org/2000/svg">
{bars}
  </svg>
</div>
</body>
</html>""".format(
        title=title_str,
        svg_w=chart_width,
        svg_h=chart_height,
        bars="\n".join(svg_bars)
    )

    with open(output, "w") as f:
        f.write(html)
    print("HTML chart saved to: {}".format(output))


# ── SPARKLINE ──────────────────────────────────────────────────────────

def cmd_sparkline(data_raw):
    values = parse_values(data_raw)
    if not values:
        return
    # Unicode block characters for 8 levels
    blocks = " ▁▂▃▄▅▆▇█"
    min_val = min(values)
    max_val = max(values)
    val_range = max_val - min_val if max_val != min_val else 1

    spark = ""
    for v in values:
        idx = int(round((v - min_val) / val_range * 8))
        if idx < 0:
            idx = 0
        if idx > 8:
            idx = 8
        spark += blocks[idx]

    min_str = str(int(min_val)) if min_val == int(min_val) else "{:.1f}".format(min_val)
    max_str = str(int(max_val)) if max_val == int(max_val) else "{:.1f}".format(max_val)
    print("  {} ({} ~ {})".format(spark, min_str, max_str))


# ── DASHBOARD ──────────────────────────────────────────────────────────

def cmd_dashboard(data_raw, title):
    """生成数据看板模板（多图表组合）"""
    dashboard_title = title if title else data_raw

    print("")
    print("  ╔{}╗".format("═" * 58))
    print("  ║{:^58}║".format("📊 " + dashboard_title + " — 数据看板"))
    print("  ╚{}╝".format("═" * 58))
    print("")

    # KPI 卡片区
    print("  ┌─ 📈 核心指标 ─────────────────────────────────────────┐")
    print("  │                                                       │")
    print("  │   总量        增长率       完成率       环比          │")
    print("  │  ┌───────┐  ┌───────┐  ┌───────┐  ┌───────┐        │")
    print("  │  │ 12,345│  │ +15.2%│  │  87.3%│  │  +3.1%│        │")
    print("  │  │       │  │   ▲   │  │  ████░│  │   ▲   │        │")
    print("  │  └───────┘  └───────┘  └───────┘  └───────┘        │")
    print("  │                                                       │")
    print("  └───────────────────────────────────────────────────────┘")
    print("")

    # 趋势图区
    print("  ┌─ 📉 趋势变化 ─────────────────────────────────────────┐")
    print("  │                                                       │")
    # 模拟趋势线
    trend_data = [3, 5, 4, 7, 6, 8, 7, 9, 8, 10, 9, 11]
    blocks = " ▁▂▃▄▅▆▇█"
    min_v = min(trend_data)
    max_v = max(trend_data)
    rng = max_v - min_v if max_v != min_v else 1
    spark = ""
    for v in trend_data:
        idx = int(round((v - min_v) / rng * 8))
        spark += blocks[max(0, min(8, idx))]
    print("  │   月度趋势：{}                     │".format(spark))
    print("  │   Jan  Feb  Mar  Apr  May  Jun  Jul  Aug  Sep  Oct   │")
    print("  │                                                       │")
    print("  └───────────────────────────────────────────────────────┘")
    print("")

    # 分布图区
    print("  ┌─ 🥧 分布占比 ─────────────────────────────────────────┐")
    print("  │                                                       │")
    print("  │   [████████████████████░░░░░░░░░░░░░░░░░░░░]          │")
    print("  │   ██ 类别A  42%    ▓▓ 类别B  28%                     │")
    print("  │   ░░ 类别C  18%    ▒▒ 类别D  12%                     │")
    print("  │                                                       │")
    print("  └───────────────────────────────────────────────────────┘")
    print("")

    # 排行榜区
    print("  ┌─ 🏆 排行榜 ───────────────────────────────────────────┐")
    print("  │                                                       │")
    print("  │   1. ████████████████████████████████████  95.2       │")
    print("  │   2. ███████████████████████████████       82.7       │")
    print("  │   3. ████████████████████████              67.3       │")
    print("  │   4. █████████████████                     51.8       │")
    print("  │   5. ████████████                          38.4       │")
    print("  │                                                       │")
    print("  └───────────────────────────────────────────────────────┘")
    print("")

    print("  📌 说明：以上为看板模板，请替换为实际数据")
    print("  💡 使用 chart.sh bar/line/pie 生成具体图表填充看板")
    print("")


# ── PROGRESS BAR ───────────────────────────────────────────────────────

def cmd_progress(data_raw, title):
    """进度条可视化"""
    parts = data_raw.split(",")
    if len(parts) < 2:
        print("Error: 需要两个数值，格式：\"已完成,总数\"", file=sys.stderr)
        sys.exit(1)

    try:
        completed = float(parts[0].strip())
        total = float(parts[1].strip())
    except ValueError:
        print("Error: 无法解析数值", file=sys.stderr)
        sys.exit(1)

    if total <= 0:
        print("Error: 总数必须大于0", file=sys.stderr)
        sys.exit(1)

    pct = completed / total * 100
    if pct > 100:
        pct = 100

    bar_width = 40
    filled = int(round(pct / 100 * bar_width))
    empty = bar_width - filled

    label = title if title else "进度"

    print("")
    print("  📊 {} — {}/{}".format(label, int(completed) if completed == int(completed) else completed,
                                     int(total) if total == int(total) else total))
    print("")

    # 主进度条
    bar = "█" * filled + "░" * empty
    print("  [{}] {:.1f}%".format(bar, pct))
    print("")

    # 状态指示
    if pct >= 100:
        status = "🎉 已完成！"
        color = "🟢"
    elif pct >= 75:
        status = "💪 即将完成"
        color = "🟢"
    elif pct >= 50:
        status = "📈 过半了，继续加油"
        color = "🟡"
    elif pct >= 25:
        status = "🔄 进行中"
        color = "🟡"
    else:
        status = "🚀 刚起步"
        color = "🔴"

    print("  {} 状态：{} ({:.1f}%)".format(color, status, pct))
    print("  📌 剩余：{}".format(
        int(total - completed) if (total - completed) == int(total - completed) else "{:.1f}".format(total - completed)
    ))
    print("")

    # 里程碑进度
    milestones = [25, 50, 75, 100]
    print("  📍 里程碑：")
    for ms in milestones:
        if pct >= ms:
            print("    ✅ {}%".format(ms))
        else:
            print("    ⬜ {}%".format(ms))
    print("")


# ── TREND ANALYSIS ─────────────────────────────────────────────────────

def cmd_trend(data_raw, title):
    """趋势分析（折线+变化率）"""
    values = parse_values(data_raw)
    if len(values) < 2:
        print("Error: 至少需要2个数据点", file=sys.stderr)
        sys.exit(1)

    label = title if title else "趋势分析"

    print("")
    print("  📈 {}".format(label))
    print("  " + "─" * 50)
    print("")

    # 迷你折线图
    blocks = " ▁▂▃▄▅▆▇█"
    min_val = min(values)
    max_val = max(values)
    val_range = max_val - min_val if max_val != min_val else 1

    spark = ""
    for v in values:
        idx = int(round((v - min_val) / val_range * 8))
        spark += blocks[max(0, min(8, idx))]

    min_str = str(int(min_val)) if min_val == int(min_val) else "{:.1f}".format(min_val)
    max_str = str(int(max_val)) if max_val == int(max_val) else "{:.1f}".format(max_val)
    print("  趋势线：{} ({} ~ {})".format(spark, min_str, max_str))
    print("")

    # 数据表格
    print("  {:<6} {:<10} {:<10} {:<10}".format("序号", "数值", "变化量", "变化率"))
    print("  " + "─" * 40)

    for i, v in enumerate(values):
        val_str = str(int(v)) if v == int(v) else "{:.1f}".format(v)
        if i == 0:
            print("  {:<6} {:<10} {:<10} {:<10}".format(i + 1, val_str, "—", "—"))
        else:
            diff = v - values[i - 1]
            diff_str = "{:+.1f}".format(diff)
            if values[i - 1] != 0:
                rate = diff / values[i - 1] * 100
                rate_str = "{:+.1f}%".format(rate)
            else:
                rate_str = "N/A"
            arrow = "📈" if diff > 0 else ("📉" if diff < 0 else "➡️")
            print("  {:<6} {:<10} {:<10} {} {}".format(i + 1, val_str, diff_str, rate_str, arrow))

    print("")

    # 统计摘要
    avg_val = sum(values) / len(values)
    total_change = values[-1] - values[0]
    if values[0] != 0:
        total_rate = total_change / values[0] * 100
        total_rate_str = "{:+.1f}%".format(total_rate)
    else:
        total_rate_str = "N/A"

    print("  📊 统计摘要：")
    print("     平均值：{:.1f}".format(avg_val))
    print("     最大值：{} (第{}个)".format(max_str, values.index(max_val) + 1))
    print("     最小值：{} (第{}个)".format(min_str, values.index(min_val) + 1))
    print("     总变化：{:+.1f} ({})".format(total_change, total_rate_str))
    print("     总体趋势：{}".format(
        "📈 上升" if total_change > 0 else ("📉 下降" if total_change < 0 else "➡️ 平稳")
    ))
    print("")


# ── HEATMAP ────────────────────────────────────────────────────────────

def cmd_heatmap(data_raw, title):
    """ASCII热力图"""
    label = title if title else "热力图"

    # 解析多行数据，用 | 分隔行，逗号分隔列
    rows = [r.strip() for r in data_raw.split("|")]
    grid = []
    for row_str in rows:
        row_vals = []
        for cell in row_str.split(","):
            cell = cell.strip()
            try:
                row_vals.append(float(cell))
            except ValueError:
                row_vals.append(0)
        grid.append(row_vals)

    if not grid or not grid[0]:
        print("Error: 无法解析热力图数据", file=sys.stderr)
        print("格式：\"1,2,3|4,5,6|7,8,9\"（| 分隔行，逗号分隔列）", file=sys.stderr)
        sys.exit(1)

    # 确保所有行长度相同
    max_cols = max(len(r) for r in grid)
    for r in grid:
        while len(r) < max_cols:
            r.append(0)

    # 获取全局最大最小值
    all_vals = [v for row in grid for v in row]
    min_v = min(all_vals)
    max_v = max(all_vals)
    rng = max_v - min_v if max_v != min_v else 1

    # 热力色块
    heat_chars = ["  ", "░░", "▒▒", "▓▓", "██"]

    print("")
    print("  🌡️ {}".format(label))
    print("  " + "─" * (max_cols * 4 + 10))
    print("")

    # 列标题
    col_header = "     "
    for c in range(max_cols):
        col_header += " {:>2} ".format(c + 1)
    print(col_header)

    # 热力图主体
    for r_idx, row in enumerate(grid):
        line = "  {:>2} │".format(r_idx + 1)
        for val in row:
            level = int(round((val - min_v) / rng * 4))
            level = max(0, min(4, level))
            line += heat_chars[level]
        line += "│"
        print(line)

    print("")

    # 图例
    print("  图例：")
    legend_items = []
    for i, char in enumerate(heat_chars):
        pct_low = i * 25
        pct_high = (i + 1) * 25
        legend_items.append("  {} = {}-{}%".format(char if char.strip() else "  (空)", pct_low, pct_high))
    for item in legend_items:
        print("  {}".format(item))
    print("")
    print("  数值范围：{:.1f} ~ {:.1f}".format(min_v, max_v))
    print("")


# ── DISPATCH ───────────────────────────────────────────────────────────

if cmd == "bar":
    cmd_bar(data_raw, title)
elif cmd == "line":
    cmd_line(data_raw, title)
elif cmd == "pie":
    cmd_pie(data_raw, title)
elif cmd == "table":
    cmd_table(data_raw)
elif cmd == "html-bar":
    cmd_html_bar(data_raw, title, output)
elif cmd == "sparkline":
    cmd_sparkline(data_raw)
elif cmd == "dashboard":
    cmd_dashboard(data_raw, title)
elif cmd == "progress":
    cmd_progress(data_raw, title)
elif cmd == "trend":
    cmd_trend(data_raw, title)
elif cmd == "heatmap":
    cmd_heatmap(data_raw, title)
else:
    print("Unknown command: {}".format(cmd), file=sys.stderr)
    sys.exit(1)
PYEOF

echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
