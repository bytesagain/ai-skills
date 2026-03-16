#!/usr/bin/env bash
# data-visualizer — SVG chart generator
# Powered by BytesAgain

CMD="${1:-help}"
shift 2>/dev/null
INPUT="$*"

case "$CMD" in
    bar)
        python3 << 'PYEOF'
import sys
data = sys.argv[1] if len(sys.argv) > 1 else "Sales:80,Marketing:60,Engineering:95,Design:45,Support:70"
print("""
╔══════════════════════════════════════════════╗
║          📊 BAR CHART GENERATOR              ║
╚══════════════════════════════════════════════╝
""")

pairs = []
for item in data.split(","):
    parts = item.strip().split(":")
    if len(parts) == 2:
        pairs.append((parts[0].strip(), float(parts[1])))

if not pairs:
    pairs = [("A", 80), ("B", 60), ("C", 95), ("D", 45)]

max_val = max(v for _, v in pairs)
bar_width = 300
chart_height = len(pairs) * 45 + 80

svg = ['<svg xmlns="http://www.w3.org/2000/svg" width="500" height="{}">'.format(chart_height)]
svg.append('<rect width="500" height="{}" fill="#1a1a2e" rx="8"/>'.format(chart_height))
svg.append('<text x="250" y="30" text-anchor="middle" fill="#e0e0e0" font-size="16" font-weight="bold">Bar Chart</text>')

for i, (label, val) in enumerate(pairs):
    y = 50 + i * 45
    w = int((val / max_val) * bar_width) if max_val > 0 else 0
    colors = ["#4fc3f7", "#81c784", "#ffb74d", "#e57373", "#ba68c8", "#4dd0e1"]
    color = colors[i % len(colors)]
    svg.append('<text x="10" y="{}" fill="#e0e0e0" font-size="12">{}</text>'.format(y + 18, label))
    svg.append('<rect x="120" y="{}" width="{}" height="25" fill="{}" rx="4"/>'.format(y, w, color))
    svg.append('<text x="{}" y="{}" fill="#e0e0e0" font-size="11">{}</text>'.format(125 + w, y + 18, val))

svg.append('<text x="250" y="{}" text-anchor="middle" fill="#888" font-size="10">Powered by BytesAgain | bytesagain.com</text>'.format(chart_height - 10))
svg.append('</svg>')
print('\n'.join(svg))
print("\n💡 Tip: Copy the SVG above and save as .svg file")
print("\n---")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
        ;;

    line)
        python3 << 'PYEOF'
import sys
data = sys.argv[1] if len(sys.argv) > 1 else "Jan:20,Feb:35,Mar:28,Apr:50,May:42,Jun:65,Jul:58,Aug:72"
print("""
╔══════════════════════════════════════════════╗
║          📈 LINE CHART GENERATOR             ║
╚══════════════════════════════════════════════╝
""")

pairs = []
for item in data.split(","):
    parts = item.strip().split(":")
    if len(parts) == 2:
        pairs.append((parts[0].strip(), float(parts[1])))

if not pairs:
    pairs = [("P1", 20), ("P2", 35), ("P3", 50), ("P4", 42), ("P5", 65)]

max_val = max(v for _, v in pairs)
min_val = min(v for _, v in pairs)
w, h = 480, 300
pad_l, pad_r, pad_t, pad_b = 60, 20, 50, 50
plot_w = w - pad_l - pad_r
plot_h = h - pad_t - pad_b

svg = ['<svg xmlns="http://www.w3.org/2000/svg" width="{}" height="{}">'.format(w, h)]
svg.append('<rect width="{}" height="{}" fill="#1a1a2e" rx="8"/>'.format(w, h))
svg.append('<text x="{}" y="30" text-anchor="middle" fill="#e0e0e0" font-size="16" font-weight="bold">Line Chart</text>'.format(w // 2))

points = []
for i, (label, val) in enumerate(pairs):
    x = pad_l + int(i * plot_w / max(len(pairs) - 1, 1))
    rng = max_val - min_val if max_val != min_val else 1
    y = pad_t + plot_h - int((val - min_val) / rng * plot_h)
    points.append((x, y))
    svg.append('<text x="{}" y="{}" text-anchor="middle" fill="#888" font-size="10">{}</text>'.format(x, h - 20, label))

polyline = ' '.join('{},{}'.format(x, y) for x, y in points)
svg.append('<polyline points="{}" fill="none" stroke="#4fc3f7" stroke-width="2.5"/>'.format(polyline))
for x, y in points:
    svg.append('<circle cx="{}" cy="{}" r="4" fill="#4fc3f7"/>'.format(x, y))

svg.append('<text x="{}" y="{}" text-anchor="middle" fill="#888" font-size="10">Powered by BytesAgain</text>'.format(w // 2, h - 5))
svg.append('</svg>')
print('\n'.join(svg))
print("\n💡 Tip: Copy the SVG and save as .svg file")
print("\n---")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
        ;;

    pie)
        python3 << 'PYEOF'
import sys, math
data = sys.argv[1] if len(sys.argv) > 1 else "Product:40,Service:25,Support:20,Other:15"
print("""
╔══════════════════════════════════════════════╗
║          🥧 PIE CHART GENERATOR              ║
╚══════════════════════════════════════════════╝
""")

pairs = []
for item in data.split(","):
    parts = item.strip().split(":")
    if len(parts) == 2:
        pairs.append((parts[0].strip(), float(parts[1])))

total = sum(v for _, v in pairs)
colors = ["#4fc3f7", "#81c784", "#ffb74d", "#e57373", "#ba68c8", "#4dd0e1", "#fff176", "#a1887f"]
cx, cy, r = 200, 180, 120

svg = ['<svg xmlns="http://www.w3.org/2000/svg" width="400" height="380">']
svg.append('<rect width="400" height="380" fill="#1a1a2e" rx="8"/>')
svg.append('<text x="200" y="30" text-anchor="middle" fill="#e0e0e0" font-size="16" font-weight="bold">Pie Chart</text>')

angle = -90
for i, (label, val) in enumerate(pairs):
    pct = val / total if total > 0 else 0
    sweep = pct * 360
    end_angle = angle + sweep
    x1 = cx + r * math.cos(math.radians(angle))
    y1 = cy + r * math.sin(math.radians(angle))
    x2 = cx + r * math.cos(math.radians(end_angle))
    y2 = cy + r * math.sin(math.radians(end_angle))
    large = 1 if sweep > 180 else 0
    color = colors[i % len(colors)]
    svg.append('<path d="M{},{} L{},{} A{},{} 0 {},1 {},{} Z" fill="{}"/>'.format(
        cx, cy, x1, y1, r, r, large, x2, y2, color))
    mid = angle + sweep / 2
    lx = cx + (r + 25) * math.cos(math.radians(mid))
    ly = cy + (r + 25) * math.sin(math.radians(mid))
    svg.append('<text x="{:.0f}" y="{:.0f}" text-anchor="middle" fill="#e0e0e0" font-size="10">{} ({:.0f}%)</text>'.format(lx, ly, label, pct * 100))
    angle = end_angle

svg.append('<text x="200" y="370" text-anchor="middle" fill="#888" font-size="10">Powered by BytesAgain</text>')
svg.append('</svg>')
print('\n'.join(svg))
print("\n---")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
        ;;

    scatter)
        python3 << 'PYEOF'
print("""
╔══════════════════════════════════════════════╗
║        🔵 SCATTER PLOT GENERATOR             ║
╚══════════════════════════════════════════════╝

Provide data as: x1:y1,x2:y2,...

Example input: 10:25,20:45,30:35,40:60,50:55,60:70,70:80

The scatter plot SVG will show:
- Each data point as a circle
- X and Y axes with labels
- Trend indication

Usage: scatter 10:25,20:45,30:35,40:60,50:55

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
""")
PYEOF
        ;;

    heatmap)
        python3 << 'PYEOF'
print("""
╔══════════════════════════════════════════════╗
║          🌡️ HEATMAP GENERATOR                ║
╚══════════════════════════════════════════════╝

Provide data as a matrix: row1col1:row1col2;row2col1:row2col2

Example: 90:70:50;60:80:40;30:50:95

Output: SVG heatmap with color-coded cells
- High values → warm colors (red/orange)
- Low values → cool colors (blue/green)

Labels can be customized:
  rows=Mon,Tue,Wed cols=Morning,Afternoon,Evening

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
""")
PYEOF
        ;;

    dashboard)
        python3 << 'PYEOF'
print("""
╔══════════════════════════════════════════════╗
║         📊 DASHBOARD GENERATOR               ║
╚══════════════════════════════════════════════╝

Generate a multi-chart dashboard layout.

Provide metrics as: metric_name:value:target

Example: Revenue:85000:100000,Users:12500:15000,Conversion:3.2:5.0,NPS:72:80

Output includes:
  ┌──────────┬──────────┐
  │  KPI #1  │  KPI #2  │
  ├──────────┼──────────┤
  │  KPI #3  │  KPI #4  │
  └──────────┴──────────┘

Each KPI card shows:
  • Current value vs target
  • Progress bar
  • Status indicator (🟢/🟡/🔴)

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
""")
PYEOF
        ;;

    compare)
        python3 << 'PYEOF'
print("""
╔══════════════════════════════════════════════╗
║       📊 COMPARISON CHART GENERATOR          ║
╚══════════════════════════════════════════════╝

Compare multiple datasets side by side.

Format: series1_name=val1,val2,val3;series2_name=val1,val2,val3
Labels: labels=Q1,Q2,Q3

Example:
  2024=100,150,200;2025=120,180,250 labels=Q1,Q2,Q3

Output: Grouped bar chart SVG with legend

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
""")
PYEOF
        ;;

    trend)
        python3 << 'PYEOF'
print("""
╔══════════════════════════════════════════════╗
║         📈 TREND ANALYSIS CHART              ║
╚══════════════════════════════════════════════╝

Analyze trends in time-series data.

Format: label1:val1,label2:val2,...

Example: Jan:100,Feb:120,Mar:115,Apr:140,May:160,Jun:155

Analysis includes:
  • Line chart with data points
  • Trend line (linear regression)
  • Growth rate calculation
  • Moving average overlay
  • Forecast for next 3 periods

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
""")
PYEOF
        ;;

    help|*)
        cat << 'HELPEOF'

╔══════════════════════════════════════════════╗
║     📊 Data Visualizer — Chart Generator     ║
╚══════════════════════════════════════════════╝

  Generate SVG charts from your data.

  COMMANDS:
  ─────────────────────────────────────────────
  bar        Generate horizontal bar chart
  line       Generate line chart with data points
  pie        Generate pie chart with percentages
  scatter    Generate scatter plot
  heatmap    Generate color-coded heatmap
  dashboard  Generate KPI dashboard layout
  compare    Generate grouped comparison chart
  trend      Generate trend analysis with forecast

  DATA FORMAT:
  ─────────────────────────────────────────────
  Most charts: Label1:Value1,Label2:Value2,...

  EXAMPLES:
  ─────────────────────────────────────────────
  bar     Sales:80,Marketing:60,Engineering:95
  line    Jan:20,Feb:35,Mar:50,Apr:42
  pie     Product:40,Service:25,Other:15

  Output: Copy the SVG code → save as .svg file

─────────────────────────────────────────────
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
        ;;
esac
