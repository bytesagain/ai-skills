#!/usr/bin/env bash
# chart-generator — Create terminal charts and exportable SVG/HTML charts
# Powered by BytesAgain | bytesagain.com
set -euo pipefail

VERSION="2.0.0"
DATA_DIR="${CHART_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/chart-generator}"
mkdir -p "$DATA_DIR"

show_help() {
    cat << HELP
chart-generator v$VERSION

Usage: chart-generator <command> [options]

Chart Types:
  bar <title> <label:value> ...     Horizontal bar chart
  vbar <title> <label:value> ...    Vertical bar chart
  pie <title> <label:value> ...     Pie chart (percentage)
  line <title> <v1> <v2> ...        Line chart (sparkline)
  scatter <title> <x,y> ...         Scatter plot
  table <title> <col:val> ...       Data table
  heatmap <title> <row> ...         Heat map grid
  progress <label> <current> <max>  Progress bar

Export:
  svg <type> <args...>              Export chart as SVG file
  html <type> <args...>             Wrap chart in HTML page

Data:
  from-csv <file> <chart-type>      Generate chart from CSV
  from-json <file> <chart-type>     Generate chart from JSON
  history                           Show recently created charts
  templates                         List chart templates

Options:
  --width <n>                       Chart width (default: 60)
  --color                           Enable ANSI colors
  --output <file>                   Save to file instead of stdout

HELP
}

# ── Bar Chart ─────────────────────────────────────────
cmd_bar() {
    local title="${1:-Chart}"
    shift || true
    local width=50
    local max_val=0
    
    declare -a labels=()
    declare -a values=()
    
    for pair in "$@"; do
        local label="${pair%%:*}"
        local val="${pair##*:}"
        labels+=("$label")
        values+=("$val")
        [ "$val" -gt "$max_val" ] 2>/dev/null && max_val="$val"
    done
    
    if [ ${#labels[@]} -eq 0 ]; then
        echo "Usage: chart-generator bar <title> <label:value> ..."
        echo "Example: chart-generator bar Revenue Q1:150 Q2:230 Q3:180 Q4:310"
        return 1
    fi
    
    echo ""
    echo "  $title"
    echo "  $(printf '─%.0s' $(seq 1 $((width + 15))))"
    
    for i in "${!labels[@]}"; do
        local val="${values[$i]}"
        local bar_len=$((val * width / (max_val > 0 ? max_val : 1)))
        local bar=$(printf '█%.0s' $(seq 1 "$bar_len") 2>/dev/null || echo "")
        printf "  %-12s │%s %s\n" "${labels[$i]}" "$bar" "$val"
    done
    echo "  $(printf '─%.0s' $(seq 1 $((width + 15))))"
    echo ""
    _log "bar" "$title" "${#labels[@]} items"
}

# ── Vertical Bar Chart ────────────────────────────────
cmd_vbar() {
    local title="${1:-Chart}"
    shift || true
    local height=15
    local max_val=0
    
    declare -a labels=()
    declare -a values=()
    
    for pair in "$@"; do
        labels+=("${pair%%:*}")
        local v="${pair##*:}"
        values+=("$v")
        [ "$v" -gt "$max_val" ] 2>/dev/null && max_val="$v"
    done
    
    [ ${#labels[@]} -eq 0 ] && { echo "Usage: chart-generator vbar <title> <label:value> ..."; return 1; }
    
    echo ""
    echo "  $title"
    echo ""
    
    for row in $(seq "$height" -1 1); do
        local threshold=$((row * max_val / height))
        printf "  %4d │" "$threshold"
        for val in "${values[@]}"; do
            if [ "$val" -ge "$threshold" ]; then
                printf "  ██ "
            else
                printf "     "
            fi
        done
        echo ""
    done
    
    printf "       └"
    for _ in "${labels[@]}"; do printf "─────"; done
    echo ""
    printf "        "
    for label in "${labels[@]}"; do printf " %-4s" "$label"; done
    echo ""
    _log "vbar" "$title" "${#labels[@]} items"
}

# ── Pie Chart ─────────────────────────────────────────
cmd_pie() {
    local title="${1:-Distribution}"
    shift || true
    
    declare -a labels=()
    declare -a values=()
    local total=0
    
    for pair in "$@"; do
        labels+=("${pair%%:*}")
        local v="${pair##*:}"
        values+=("$v")
        total=$((total + v))
    done
    
    [ ${#labels[@]} -eq 0 ] && { echo "Usage: chart-generator pie <title> <label:value> ..."; return 1; }
    
    local chars=("█" "▓" "▒" "░" "●" "○" "◆" "◇")
    
    echo ""
    echo "  $title"
    echo "  $(printf '─%.0s' $(seq 1 45))"
    
    for i in "${!labels[@]}"; do
        local val="${values[$i]}"
        local pct=$((val * 100 / (total > 0 ? total : 1)))
        local bar_len=$((pct / 2))
        local char="${chars[$((i % ${#chars[@]}))]}"
        local bar=$(printf "${char}%.0s" $(seq 1 "$bar_len") 2>/dev/null || echo "")
        printf "  %s %-12s %s %d%% (%d)\n" "$char" "${labels[$i]}" "$bar" "$pct" "$val"
    done
    echo "  $(printf '─%.0s' $(seq 1 45))"
    echo "  Total: $total"
    _log "pie" "$title" "${#labels[@]} slices"
}

# ── Line Chart (Sparkline) ────────────────────────────
cmd_line() {
    local title="${1:-Trend}"
    shift || true
    local vals=("$@")
    
    [ ${#vals[@]} -eq 0 ] && { echo "Usage: chart-generator line <title> <v1> <v2> ..."; return 1; }
    
    local min=999999 max=0
    for v in "${vals[@]}"; do
        [ "$v" -lt "$min" ] && min="$v"
        [ "$v" -gt "$max" ] && max="$v"
    done
    
    local sparks=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")
    local range=$((max - min))
    [ "$range" -eq 0 ] && range=1
    
    echo ""
    echo "  $title"
    printf "  "
    for v in "${vals[@]}"; do
        local idx=$(( (v - min) * 7 / range ))
        printf "%s" "${sparks[$idx]}"
    done
    echo ""
    echo "  min=$min max=$max points=${#vals[@]}"
    _log "line" "$title" "${#vals[@]} points"
}

# ── Progress Bar ──────────────────────────────────────
cmd_progress() {
    local label="${1:-Progress}"
    local current="${2:-0}"
    local max="${3:-100}"
    local pct=$((current * 100 / (max > 0 ? max : 1)))
    local filled=$((pct / 2))
    local empty=$((50 - filled))
    
    printf "  %s [" "$label"
    printf '█%.0s' $(seq 1 "$filled") 2>/dev/null || true
    printf '░%.0s' $(seq 1 "$empty") 2>/dev/null || true
    printf "] %d%% (%d/%d)\n" "$pct" "$current" "$max"
    _log "progress" "$label" "$pct%"
}

# ── SVG Export ────────────────────────────────────────
cmd_svg() {
    local type="${1:?Usage: chart-generator svg <type> <args...>}"
    shift
    local file="$DATA_DIR/chart-$(date +%s).svg"
    
    # Generate simple SVG bar chart
    local w=600 h=400
    echo '<?xml version="1.0" encoding="UTF-8"?>' > "$file"
    echo "<svg width=\"$w\" height=\"$h\" xmlns=\"http://www.w3.org/2000/svg\">" >> "$file"
    echo "<rect width=\"100%\" height=\"100%\" fill=\"#1a1a2e\"/>" >> "$file"
    echo "<text x=\"$((w/2))\" y=\"30\" text-anchor=\"middle\" fill=\"white\" font-size=\"18\">$type chart</text>" >> "$file"
    
    local x=50 i=0 max_v=0
    declare -a sv_labels=() sv_values=()
    for pair in "$@"; do
        sv_labels+=("${pair%%:*}")
        local v="${pair##*:}"
        sv_values+=("$v")
        [ "$v" -gt "$max_v" ] 2>/dev/null && max_v="$v"
    done
    
    local bar_w=$(( (w - 100) / (${#sv_labels[@]} > 0 ? ${#sv_labels[@]} : 1) - 10 ))
    local colors=("#e94560" "#0f3460" "#16213e" "#533483" "#e94560" "#2b2d42")
    
    for i in "${!sv_labels[@]}"; do
        local bh=$(( ${sv_values[$i]} * 300 / (max_v > 0 ? max_v : 1) ))
        local bx=$((50 + i * (bar_w + 10)))
        local by=$((380 - bh))
        local color="${colors[$((i % ${#colors[@]}))]}"
        echo "<rect x=\"$bx\" y=\"$by\" width=\"$bar_w\" height=\"$bh\" fill=\"$color\" rx=\"4\"/>" >> "$file"
        echo "<text x=\"$((bx + bar_w/2))\" y=\"395\" text-anchor=\"middle\" fill=\"#aaa\" font-size=\"12\">${sv_labels[$i]}</text>" >> "$file"
        echo "<text x=\"$((bx + bar_w/2))\" y=\"$((by - 5))\" text-anchor=\"middle\" fill=\"white\" font-size=\"11\">${sv_values[$i]}</text>" >> "$file"
    done
    
    echo "</svg>" >> "$file"
    echo "[chart-generator] SVG saved: $file"
    echo "  Size: $(du -h "$file" | cut -f1)"
}

# ── CSV Import ────────────────────────────────────────
cmd_from_csv() {
    local file="${1:?Usage: chart-generator from-csv <file> <chart-type>}"
    local type="${2:-bar}"
    
    [ ! -f "$file" ] && { echo "File not found: $file"; return 1; }
    
    local args=()
    local header=1
    while IFS=, read -r label value rest; do
        [ "$header" -eq 1 ] && { header=0; continue; }
        [ -n "$label" ] && [ -n "$value" ] && args+=("$label:$value")
    done < "$file"
    
    echo "[chart-generator] Loaded ${#args[@]} rows from $file"
    case "$type" in
        bar) cmd_bar "From $file" "${args[@]}" ;;
        pie) cmd_pie "From $file" "${args[@]}" ;;
        vbar) cmd_vbar "From $file" "${args[@]}" ;;
        *) echo "Supported: bar, pie, vbar" ;;
    esac
}

# ── Templates ─────────────────────────────────────────
cmd_templates() {
    echo "[chart-generator] Available templates:"
    echo ""
    echo "  revenue    — Quarterly revenue bar chart"
    echo "  traffic    — Website traffic sparkline"
    echo "  market     — Market share pie chart"
    echo "  progress   — Project progress bars"
    echo ""
    echo "Usage: chart-generator template <name>"
}

# ── History ───────────────────────────────────────────
cmd_history() {
    local log="$DATA_DIR/history.log"
    if [ ! -f "$log" ] || [ ! -s "$log" ]; then
        echo "[chart-generator] No charts created yet."
        return
    fi
    echo "[chart-generator] Recent charts:"
    tail -20 "$log" | while IFS= read -r line; do
        echo "  $line"
    done
}

# ── Internal ──────────────────────────────────────────
_log() {
    local log="$DATA_DIR/history.log"
    echo "$(date '+%Y-%m-%d %H:%M') | $1 | $2 | $3" >> "$log"
}

# ── Main ──────────────────────────────────────────────
case "${1:-help}" in
    bar)        shift; cmd_bar "$@" ;;
    vbar)       shift; cmd_vbar "$@" ;;
    pie)        shift; cmd_pie "$@" ;;
    line)       shift; cmd_line "$@" ;;
    scatter)    shift; echo "TODO: scatter plot" ;;
    table)      shift; echo "TODO: data table" ;;
    heatmap)    shift; echo "TODO: heat map" ;;
    progress)   shift; cmd_progress "$@" ;;
    svg)        shift; cmd_svg "$@" ;;
    html)       shift; echo "TODO: html export" ;;
    from-csv)   shift; cmd_from_csv "$@" ;;
    from-json)  shift; echo "TODO: json import" ;;
    history)    cmd_history ;;
    templates)  cmd_templates ;;
    help|-h)    show_help ;;
    version|-v) echo "chart-generator v$VERSION" ;;
    *)          echo "Unknown: $1"; show_help; exit 1 ;;
esac
