#!/usr/bin/env bash
# Game Design — gaming tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

DATA_DIR="${HOME}/.local/share/game-design"
mkdir -p "$DATA_DIR"

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }
_version() { echo "game-design v2.0.0"; }

_help() {
    echo "Game Design v2.0.0 — gaming toolkit"
    echo ""
    echo "Usage: game-design <command> [args]"
    echo ""
    echo "Commands:"
    echo "  roll               Roll"
    echo "  score              Score"
    echo "  rank               Rank"
    echo "  history            History"
    echo "  stats              Stats"
    echo "  challenge          Challenge"
    echo "  create             Create"
    echo "  join               Join"
    echo "  track              Track"
    echo "  leaderboard        Leaderboard"
    echo "  reward             Reward"
    echo "  reset              Reset"
    echo "  stats              Summary statistics"
    echo "  export <fmt>       Export (json|csv|txt)"
    echo "  search <term>      Search entries"
    echo "  recent             Recent activity"
    echo "  status             Health check"
    echo "  help               Show this help"
    echo "  version            Show version"
    echo ""
    echo "Data: $DATA_DIR"
}

_stats() {
    echo "=== Game Design Stats ==="
    local total=0
    for f in "$DATA_DIR"/*.log; do
        [ -f "$f" ] || continue
        local name=$(basename "$f" .log)
        local c=$(wc -l < "$f")
        total=$((total + c))
        echo "  $name: $c entries"
    done
    echo "  ---"
    echo "  Total: $total entries"
    echo "  Data size: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
}

_export() {
    local fmt="${1:-json}"
    local out="$DATA_DIR/export.$fmt"
    case "$fmt" in
        json)
            echo "[" > "$out"
            local first=1
            for f in "$DATA_DIR"/*.log; do
                [ -f "$f" ] || continue
                local name=$(basename "$f" .log)
                while IFS='|' read -r ts val; do
                    [ $first -eq 1 ] && first=0 || echo "," >> "$out"
                    printf '  {"type":"%s","time":"%s","value":"%s"}' "$name" "$ts" "$val" >> "$out"
                done < "$f"
            done
            echo "\n]" >> "$out"
            ;;
        csv)
            echo "type,time,value" > "$out"
            for f in "$DATA_DIR"/*.log; do
                [ -f "$f" ] || continue
                local name=$(basename "$f" .log)
                while IFS='|' read -r ts val; do echo "$name,$ts,$val" >> "$out"; done < "$f"
            done
            ;;
        txt)
            echo "=== Game Design Export ===" > "$out"
            for f in "$DATA_DIR"/*.log; do
                [ -f "$f" ] || continue
                echo "--- $(basename "$f" .log) ---" >> "$out"
                cat "$f" >> "$out"
            done
            ;;
        *) echo "Formats: json, csv, txt"; return 1 ;;
    esac
    echo "Exported to $out ($(wc -c < "$out") bytes)"
}

_status() {
    echo "=== Game Design Status ==="
    echo "  Version: v2.0.0"
    echo "  Data dir: $DATA_DIR"
    echo "  Entries: $(cat "$DATA_DIR"/*.log 2>/dev/null | wc -l) total"
    echo "  Disk: $(du -sh "$DATA_DIR" 2>/dev/null | cut -f1)"
    echo "  Last: $(tail -1 "$DATA_DIR/history.log" 2>/dev/null || echo never)"
    echo "  Status: OK"
}

_search() {
    local term="${1:?Usage: game-design search <term>}"
    echo "Searching for: $term"
    for f in "$DATA_DIR"/*.log; do
        [ -f "$f" ] || continue
        local m=$(grep -i "$term" "$f" 2>/dev/null || true)
        if [ -n "$m" ]; then
            echo "  --- $(basename "$f" .log) ---"
            echo "$m" | sed 's/^/    /'
        fi
    done
}

_recent() {
    echo "=== Recent Activity ==="
    tail -20 "$DATA_DIR/history.log" 2>/dev/null | sed 's/^/  /' || echo "  No activity yet."
}

case "${1:-help}" in
    roll)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent roll entries:"
            tail -20 "$DATA_DIR/roll.log" 2>/dev/null || echo "  No entries yet. Use: game-design roll <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/roll.log"
            local total=$(wc -l < "$DATA_DIR/roll.log")
            echo "  [Game Design] roll: $input"
            echo "  Saved. Total roll entries: $total"
            _log "roll" "$input"
        fi
        ;;
    score)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent score entries:"
            tail -20 "$DATA_DIR/score.log" 2>/dev/null || echo "  No entries yet. Use: game-design score <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/score.log"
            local total=$(wc -l < "$DATA_DIR/score.log")
            echo "  [Game Design] score: $input"
            echo "  Saved. Total score entries: $total"
            _log "score" "$input"
        fi
        ;;
    rank)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent rank entries:"
            tail -20 "$DATA_DIR/rank.log" 2>/dev/null || echo "  No entries yet. Use: game-design rank <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/rank.log"
            local total=$(wc -l < "$DATA_DIR/rank.log")
            echo "  [Game Design] rank: $input"
            echo "  Saved. Total rank entries: $total"
            _log "rank" "$input"
        fi
        ;;
    history)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent history entries:"
            tail -20 "$DATA_DIR/history.log" 2>/dev/null || echo "  No entries yet. Use: game-design history <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/history.log"
            local total=$(wc -l < "$DATA_DIR/history.log")
            echo "  [Game Design] history: $input"
            echo "  Saved. Total history entries: $total"
            _log "history" "$input"
        fi
        ;;
    stats)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent stats entries:"
            tail -20 "$DATA_DIR/stats.log" 2>/dev/null || echo "  No entries yet. Use: game-design stats <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/stats.log"
            local total=$(wc -l < "$DATA_DIR/stats.log")
            echo "  [Game Design] stats: $input"
            echo "  Saved. Total stats entries: $total"
            _log "stats" "$input"
        fi
        ;;
    challenge)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent challenge entries:"
            tail -20 "$DATA_DIR/challenge.log" 2>/dev/null || echo "  No entries yet. Use: game-design challenge <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/challenge.log"
            local total=$(wc -l < "$DATA_DIR/challenge.log")
            echo "  [Game Design] challenge: $input"
            echo "  Saved. Total challenge entries: $total"
            _log "challenge" "$input"
        fi
        ;;
    create)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent create entries:"
            tail -20 "$DATA_DIR/create.log" 2>/dev/null || echo "  No entries yet. Use: game-design create <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/create.log"
            local total=$(wc -l < "$DATA_DIR/create.log")
            echo "  [Game Design] create: $input"
            echo "  Saved. Total create entries: $total"
            _log "create" "$input"
        fi
        ;;
    join)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent join entries:"
            tail -20 "$DATA_DIR/join.log" 2>/dev/null || echo "  No entries yet. Use: game-design join <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/join.log"
            local total=$(wc -l < "$DATA_DIR/join.log")
            echo "  [Game Design] join: $input"
            echo "  Saved. Total join entries: $total"
            _log "join" "$input"
        fi
        ;;
    track)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent track entries:"
            tail -20 "$DATA_DIR/track.log" 2>/dev/null || echo "  No entries yet. Use: game-design track <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/track.log"
            local total=$(wc -l < "$DATA_DIR/track.log")
            echo "  [Game Design] track: $input"
            echo "  Saved. Total track entries: $total"
            _log "track" "$input"
        fi
        ;;
    leaderboard)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent leaderboard entries:"
            tail -20 "$DATA_DIR/leaderboard.log" 2>/dev/null || echo "  No entries yet. Use: game-design leaderboard <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/leaderboard.log"
            local total=$(wc -l < "$DATA_DIR/leaderboard.log")
            echo "  [Game Design] leaderboard: $input"
            echo "  Saved. Total leaderboard entries: $total"
            _log "leaderboard" "$input"
        fi
        ;;
    reward)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent reward entries:"
            tail -20 "$DATA_DIR/reward.log" 2>/dev/null || echo "  No entries yet. Use: game-design reward <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/reward.log"
            local total=$(wc -l < "$DATA_DIR/reward.log")
            echo "  [Game Design] reward: $input"
            echo "  Saved. Total reward entries: $total"
            _log "reward" "$input"
        fi
        ;;
    reset)
        shift
        if [ $# -eq 0 ]; then
            echo "Recent reset entries:"
            tail -20 "$DATA_DIR/reset.log" 2>/dev/null || echo "  No entries yet. Use: game-design reset <input>"
        else
            local input="$*"
            local ts=$(date '+%Y-%m-%d %H:%M')
            echo "$ts|$input" >> "$DATA_DIR/reset.log"
            local total=$(wc -l < "$DATA_DIR/reset.log")
            echo "  [Game Design] reset: $input"
            echo "  Saved. Total reset entries: $total"
            _log "reset" "$input"
        fi
        ;;
    stats) _stats ;;
    export) shift; _export "$@" ;;
    search) shift; _search "$@" ;;
    recent) _recent ;;
    status) _status ;;
    help|--help|-h) _help ;;
    version|--version|-v) _version ;;
    *)
        echo "Unknown: $1 — run 'game-design help'"
        exit 1
        ;;
esac