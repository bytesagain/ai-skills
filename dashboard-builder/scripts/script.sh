#!/usr/bin/env bash
# dashboard-builder — CLI dashboard builder with ASCII chart rendering
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="3.3.0"
DATA_DIR="${DASHBOARD_BUILDER_DIR:-$HOME/.dashboard-builder}"
DASHBOARDS="$DATA_DIR/dashboards"

ensure_dirs() { mkdir -p "$DATA_DIR" "$DASHBOARDS"; }
ts() { date '+%Y-%m-%d %H:%M:%S'; }

show_help() {
    cat << EOF
dashboard-builder v$VERSION — ASCII dashboard toolkit

Usage: dashboard-builder <command> [args]

Commands:
  create <name>                       Create a new dashboard
  add-widget <dash> <type> <data>     Add widget (bar|gauge|table|text)
  render <dash>                       Render dashboard in terminal
  list                                List all dashboards
  show <dash>                         Show dashboard config
  delete <dash>                       Delete a dashboard
  export <dash> <fmt>                 Export (json|txt|html)
  import <file>                       Import dashboard from JSON
  demo                                Show built-in demo dashboard
  help                                Show this help
  version                             Show version

Widget types:
  bar    <label:value,...>   Horizontal bar chart
  gauge  <label:value:max>  Progress gauge with threshold
  table  <h1:h2|r1:r2,...>  Data table with headers
  text   <message>          Text panel

Data: $DATA_DIR
EOF
}

cmd_create() {
    ensure_dirs
    local name="${1:?Usage: dashboard-builder create <name>}"
    local file="$DASHBOARDS/${name}.json"
    if [ -f "$file" ]; then
        echo "Dashboard '$name' already exists"; return 1
    fi
    cat > "$file" << JSONEOF
{
  "name": "$name",
  "created": "$(ts)",
  "widgets": []
}
JSONEOF
    echo "[dashboard-builder] Created: $name"
    echo "  File: $file"
    echo "  Next: dashboard-builder add-widget $name bar 'Sales:45,Marketing:32,Engineering:28'"
}

cmd_add_widget() {
    ensure_dirs
    local dash="${1:?Usage: dashboard-builder add-widget <dash> <type> <data>}"
    local wtype="${2:?Widget type required: bar|gauge|table|text}"
    local data="${3:?Widget data required}"
    local file="$DASHBOARDS/${dash}.json"
    if [ ! -f "$file" ]; then
        echo "Dashboard '$dash' not found"; return 1
    fi

    local id="w$(date +%s)"
    local tmpfile="${file}.tmp"

    # Read existing widgets count
    local wcount=$(grep -c '"type"' "$file" 2>/dev/null || echo 0)

    # Append widget using sed (insert before closing bracket of widgets array)
    local widget_json="{\"id\":\"$id\",\"type\":\"$wtype\",\"data\":\"$data\",\"added\":\"$(ts)\"}"

    if grep -q '"widgets": \[\]' "$file"; then
        sed "s|\"widgets\": \[\]|\"widgets\": [$widget_json]|" "$file" > "$tmpfile"
    else
        sed "s|\(.*\)\]|\1, $widget_json]|" "$file" > "$tmpfile"
    fi
    mv "$tmpfile" "$file"

    echo "[dashboard-builder] Added $wtype widget to '$dash'"
    echo "  ID: $id | Data: $data"
}

draw_bar_chart() {
    local data="$1"
    local max_val=0
    local bar_width=40

    # Parse label:value pairs
    IFS=',' read -ra items <<< "$data"
    local labels=()
    local values=()
    for item in "${items[@]}"; do
        local label="${item%%:*}"
        local val="${item##*:}"
        labels+=("$label")
        values+=("$val")
        [ "$val" -gt "$max_val" ] 2>/dev/null && max_val=$val
    done

    [ "$max_val" -eq 0 ] && max_val=1

    for i in "${!labels[@]}"; do
        local label="${labels[$i]}"
        local val="${values[$i]}"
        local filled=$((val * bar_width / max_val))
        local bar=""
        for ((j=0; j<filled; j++)); do bar+="█"; done
        for ((j=filled; j<bar_width; j++)); do bar+="░"; done
        printf "  %-15s │%s│ %d\n" "$label" "$bar" "$val"
    done
}

draw_gauge() {
    local data="$1"
    local label="${data%%:*}"
    local rest="${data#*:}"
    local value="${rest%%:*}"
    local max="${rest##*:}"
    [ "$max" -eq 0 ] 2>/dev/null && max=100
    local pct=$((value * 100 / max))
    local filled=$((pct * 30 / 100))
    local bar=""
    for ((j=0; j<filled; j++)); do bar+="▓"; done
    for ((j=filled; j<30; j++)); do bar+="░"; done

    local status="OK"
    [ "$pct" -gt 80 ] && status="HIGH"
    [ "$pct" -lt 20 ] && status="LOW"

    printf "  %-12s [%s] %d/%d (%d%%) %s\n" "$label" "$bar" "$value" "$max" "$pct" "$status"
}

draw_table() {
    local data="$1"
    IFS='|' read -ra rows <<< "$data"
    local header="${rows[0]}"
    IFS=':' read -ra cols <<< "$header"
    local ncols=${#cols[@]}

    # Header
    printf "  ┌"
    for ((c=0; c<ncols; c++)); do printf "──────────────"; done
    printf "┐\n"
    printf "  │"
    for col in "${cols[@]}"; do printf " %-12s" "$col"; done
    printf "│\n"
    printf "  ├"
    for ((c=0; c<ncols; c++)); do printf "──────────────"; done
    printf "┤\n"

    # Data rows
    for ((r=1; r<${#rows[@]}; r++)); do
        IFS=':' read -ra cells <<< "${rows[$r]}"
        printf "  │"
        for cell in "${cells[@]}"; do printf " %-12s" "$cell"; done
        printf "│\n"
    done

    printf "  └"
    for ((c=0; c<ncols; c++)); do printf "──────────────"; done
    printf "┘\n"
}

draw_text() {
    local msg="$1"
    local len=${#msg}
    local pad=$((len + 4))
    printf "  ┌"
    for ((i=0; i<pad; i++)); do printf "─"; done
    printf "┐\n"
    printf "  │  %s  │\n" "$msg"
    printf "  └"
    for ((i=0; i<pad; i++)); do printf "─"; done
    printf "┘\n"
}

cmd_render() {
    ensure_dirs
    local dash="${1:?Usage: dashboard-builder render <dash>}"
    local file="$DASHBOARDS/${dash}.json"
    if [ ! -f "$file" ]; then
        echo "Dashboard '$dash' not found"; return 1
    fi

    local name="$dash"
    echo ""
    echo "╔══════════════════════════════════════════════════════╗"
    printf "║  Dashboard: %-40s ║\n" "$name"
    printf "║  Rendered:  %-40s ║\n" "$(ts)"
    echo "╚══════════════════════════════════════════════════════╝"
    echo ""

    # Parse widgets from JSON using grep/sed
    local types=($(grep -oP '"type":"[^"]*"' "$file" | sed 's/"type":"//;s/"//'))
    local datas=($(grep -oP '"data":"[^"]*"' "$file" | sed 's/"data":"//;s/"//'))

    if [ ${#types[@]} -eq 0 ]; then
        echo "  (no widgets — use: dashboard-builder add-widget $dash bar 'A:10,B:20')"
        return
    fi

    for i in "${!types[@]}"; do
        local wtype="${types[$i]}"
        local wdata="${datas[$i]}"
        echo "  ── $wtype ──"
        case "$wtype" in
            bar)   draw_bar_chart "$wdata" ;;
            gauge) draw_gauge "$wdata" ;;
            table) draw_table "$wdata" ;;
            text)  draw_text "$wdata" ;;
            *)     echo "  Unknown widget type: $wtype" ;;
        esac
        echo ""
    done
}

cmd_list() {
    ensure_dirs
    echo "[dashboard-builder] Dashboards:"
    local count=0
    for f in "$DASHBOARDS"/*.json; do
        [ -f "$f" ] || continue
        count=$((count + 1))
        local name=$(basename "$f" .json)
        local widgets=$(grep -c '"type"' "$f" 2>/dev/null || echo 0)
        local size=$(wc -c < "$f")
        local created=$(grep -oP '"created":"[^"]*"' "$f" | head -1 | sed 's/"created":"//;s/"//')
        printf "  %2d. %-25s %2d widgets  %5d bytes  %s\n" "$count" "$name" "$widgets" "$size" "$created"
    done
    [ "$count" -eq 0 ] && echo "  (none — try: dashboard-builder create my-dashboard)"
    echo "  Total: $count dashboards"
}

cmd_show() {
    ensure_dirs
    local dash="${1:?Usage: dashboard-builder show <dash>}"
    local file="$DASHBOARDS/${dash}.json"
    if [ ! -f "$file" ]; then
        echo "Dashboard '$dash' not found"; return 1
    fi
    echo "[dashboard-builder] Dashboard: $dash"
    echo "  File: $file"
    echo "  Size: $(wc -c < "$file") bytes"
    echo "  Widgets: $(grep -c '"type"' "$file" 2>/dev/null || echo 0)"
    echo ""
    echo "  Config:"
    cat "$file" | sed 's/^/    /'
}

cmd_delete() {
    ensure_dirs
    local dash="${1:?Usage: dashboard-builder delete <dash>}"
    local file="$DASHBOARDS/${dash}.json"
    if [ ! -f "$file" ]; then
        echo "Dashboard '$dash' not found"; return 1
    fi
    rm -f "$file"
    echo "[dashboard-builder] Deleted: $dash"
}

cmd_export() {
    ensure_dirs
    local dash="${1:?Usage: dashboard-builder export <dash> <format>}"
    local fmt="${2:-json}"
    local file="$DASHBOARDS/${dash}.json"
    if [ ! -f "$file" ]; then
        echo "Dashboard '$dash' not found"; return 1
    fi
    local outfile="$DATA_DIR/${dash}-export.${fmt}"
    case "$fmt" in
        json)
            cp "$file" "$outfile"
            ;;
        txt)
            echo "Dashboard: $dash" > "$outfile"
            echo "Exported: $(ts)" >> "$outfile"
            echo "" >> "$outfile"
            grep -oP '"type":"[^"]*"' "$file" | sed 's/"type":"//;s/"//' | while read -r t; do
                echo "Widget: $t" >> "$outfile"
            done
            ;;
        html)
            cat > "$outfile" << HTMLEOF
<!DOCTYPE html>
<html><head><title>$dash</title>
<style>body{background:#1a1a2e;color:#e0e0e0;font-family:monospace;padding:20px}
h1{color:#00d4ff}pre{background:#16213e;padding:15px;border-radius:8px}</style>
</head><body>
<h1>$dash</h1>
<pre>$(cat "$file")</pre>
<p>Exported: $(ts)</p>
</body></html>
HTMLEOF
            ;;
        *) echo "Formats: json, txt, html"; return 1 ;;
    esac
    echo "[dashboard-builder] Exported: $outfile ($(wc -c < "$outfile") bytes)"
}

cmd_import() {
    ensure_dirs
    local file="${1:?Usage: dashboard-builder import <file>}"
    if [ ! -f "$file" ]; then
        echo "File not found: $file"; return 1
    fi
    local name=$(basename "$file" .json)
    local dest="$DASHBOARDS/${name}.json"
    cp "$file" "$dest"
    local widgets=$(grep -c '"type"' "$dest" 2>/dev/null || echo 0)
    echo "[dashboard-builder] Imported: $name ($widgets widgets)"
}

cmd_demo() {
    ensure_dirs
    echo ""
    echo "╔══════════════════════════════════════════════════════╗"
    echo "║  DEMO DASHBOARD                                     ║"
    printf "║  %-52s ║\n" "$(ts)"
    echo "╚══════════════════════════════════════════════════════╝"
    echo ""

    echo "  ── bar chart ──"
    draw_bar_chart "Revenue:85,Costs:42,Profit:43,Growth:67"
    echo ""

    echo "  ── gauge ──"
    draw_gauge "CPU:72:100"
    draw_gauge "Memory:4200:8192"
    draw_gauge "Disk:15:100"
    echo ""

    echo "  ── table ──"
    draw_table "Service:Status:Uptime|API:Running:99.9%|DB:Running:99.7%|Cache:Warning:98.2%"
    echo ""

    echo "  ── text ──"
    draw_text "System healthy — last check $(ts)"
}

# Main
CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in
    create)     cmd_create "$@" ;;
    add-widget) cmd_add_widget "$@" ;;
    render)     cmd_render "$@" ;;
    list)       cmd_list ;;
    show)       cmd_show "$@" ;;
    delete)     cmd_delete "$@" ;;
    export)     cmd_export "$@" ;;
    import)     cmd_import "$@" ;;
    demo)       cmd_demo ;;
    help|-h)    show_help ;;
    version|-v) echo "dashboard-builder v$VERSION — Powered by BytesAgain" ;;
    *)          echo "Unknown: $CMD"; show_help; exit 1 ;;
esac
