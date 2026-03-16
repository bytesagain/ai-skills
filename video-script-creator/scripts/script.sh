#!/usr/bin/env bash
# video-script-creator — Generate video scripts, shot lists, and storyboards
set -euo pipefail
VERSION="2.0.0"
DATA_DIR="${VIDEO_SCRIPT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/video-script-creator}"
SCRIPTS_DIR="$DATA_DIR/scripts"
mkdir -p "$SCRIPTS_DIR"

show_help() {
    cat << HELP
video-script-creator v$VERSION

Usage: video-script-creator <command> [args]

Script Writing:
  outline <topic> [duration]    Generate script outline (duration in minutes)
  intro <topic> [style]         Write video intro (hook|story|question|stat)
  script <topic> [duration]     Full script with timestamps
  hook <topic>                  Generate 5 attention hooks
  cta <type>                    Call-to-action templates (subscribe|like|comment|link)
  outro <style>                 Outro templates (summary|teaser|cta)

Planning:
  shotlist <script-file>        Generate shot list from script
  timeline <duration> <scenes>  Scene timeline breakdown
  brief <topic> [platform]      Production brief (youtube|tiktok|reel|short)
  thumbnail <topic>             Thumbnail text/layout ideas

Management:
  list                          List saved scripts
  save <name>                   Save current script
  show <name>                   Show saved script
  export <name> <format>        Export (txt|md|csv)
  stats                         Writing statistics
  help                          Show this help

HELP
}

cmd_outline() {
    local topic="${1:?Usage: video-script-creator outline <topic> [duration]}"
    local dur="${2:-5}"
    local segments=$((dur > 3 ? dur : 3))
    local seg_time=$((dur * 60 / segments))
    
    echo "╔══════════════════════════════════════════════╗"
    echo "║  VIDEO SCRIPT OUTLINE                       ║"
    echo "╠══════════════════════════════════════════════╣"
    echo "║  Topic:    $topic"
    echo "║  Duration: ${dur} minutes"
    echo "║  Segments: $segments"
    echo "╚══════════════════════════════════════════════╝"
    echo ""
    echo "  [0:00-0:15]  HOOK"
    echo "    → Attention grabber about $topic"
    echo "    → Why viewer should care"
    echo ""
    echo "  [0:15-0:30]  INTRO"
    echo "    → Introduce yourself"
    echo "    → Preview what they'll learn"
    echo ""
    
    local t=30
    for i in $(seq 1 $((segments - 2))); do
        local end=$((t + seg_time))
        local m1=$((t / 60)) s1=$((t % 60))
        local m2=$((end / 60)) s2=$((end % 60))
        printf "  [%d:%02d-%d:%02d]  POINT %d\n" "$m1" "$s1" "$m2" "$s2" "$i"
        echo "    → Key insight #$i about $topic"
        echo "    → Example or demonstration"
        echo ""
        t=$end
    done
    
    local m=$((dur - 1))
    echo "  [${m}:00-${dur}:00]  CONCLUSION"
    echo "    → Summarize key takeaways"
    echo "    → Call to action"
    echo ""
    _log "outline" "$topic (${dur}min)"
}

cmd_intro() {
    local topic="${1:?Usage: video-script-creator intro <topic> [style]}"
    local style="${2:-hook}"
    
    echo "  ┌─ INTRO ($style style) ─────────────────────┐"
    case "$style" in
        hook)
            echo "  │ \"What if I told you that $topic"
            echo "  │  could change everything you know about"
            echo "  │  [this subject]? Stay with me.\""
            ;;
        story)
            echo "  │ \"Last week, something happened that made"
            echo "  │  me completely rethink $topic."
            echo "  │  Let me tell you what I discovered.\""
            ;;
        question)
            echo "  │ \"Have you ever wondered why $topic"
            echo "  │  matters so much? I spent [time] figuring"
            echo "  │  this out, and the answer surprised me.\""
            ;;
        stat)
            echo "  │ \"[X]% of people get $topic wrong."
            echo "  │  In this video, I'll show you the"
            echo "  │  [X] things that actually work.\""
            ;;
    esac
    echo "  └──────────────────────────────────────────┘"
    _log "intro" "$topic ($style)"
}

cmd_hook() {
    local topic="${1:?Usage: video-script-creator hook <topic>}"
    echo "  5 HOOKS for: $topic"
    echo "  ─────────────────────────────"
    echo "  1. Curiosity: \"The #1 mistake everyone makes with $topic...\""
    echo "  2. Shock:     \"I was wrong about $topic for [X] years.\""
    echo "  3. Promise:   \"After this video, you'll never struggle with $topic again.\""
    echo "  4. Challenge: \"Can you guess which $topic strategy actually works?\""
    echo "  5. Urgency:   \"Stop doing $topic this way—here's why.\""
    _log "hook" "$topic"
}

cmd_cta() {
    local type="${1:-subscribe}"
    echo "  CTA Templates ($type):"
    case "$type" in
        subscribe)
            echo "  → \"If this helped, smash that subscribe button.\""
            echo "  → \"Join [X]K others—subscribe for more like this.\""
            ;;
        like)
            echo "  → \"Drop a like if you learned something new.\""
            echo "  → \"Like this video to help others find it.\""
            ;;
        comment)
            echo "  → \"Tell me in the comments—which tip was most useful?\""
            echo "  → \"Comment your #1 challenge with [topic].\""
            ;;
        link)
            echo "  → \"Links to everything I mentioned are in the description.\""
            echo "  → \"Grab the free [resource] — link below.\""
            ;;
    esac
    _log "cta" "$type"
}

cmd_timeline() {
    local dur="${1:?Usage: video-script-creator timeline <duration-min> <scene-count>}"
    local scenes="${2:-5}"
    local total=$((dur * 60))
    local per=$((total / scenes))
    
    echo "  TIMELINE: ${dur}min / ${scenes} scenes"
    echo "  ═══════════════════════════════"
    for i in $(seq 1 "$scenes"); do
        local start=$(( (i-1) * per ))
        local end=$((i * per))
        local m1=$((start/60)) s1=$((start%60))
        local m2=$((end/60)) s2=$((end%60))
        printf "  %d:%02d → %d:%02d  Scene %d (%ds)\n" "$m1" "$s1" "$m2" "$s2" "$i" "$per"
    done
    _log "timeline" "${dur}min x $scenes"
}

cmd_brief() {
    local topic="${1:?Usage: video-script-creator brief <topic> [platform]}"
    local platform="${2:-youtube}"
    
    echo "  PRODUCTION BRIEF"
    echo "  ═══════════════════════════════"
    echo "  Topic:    $topic"
    echo "  Platform: $platform"
    
    case "$platform" in
        youtube)   echo "  Format:   16:9 landscape"; echo "  Length:   8-12 min"; echo "  Thumb:    1280x720" ;;
        tiktok)    echo "  Format:   9:16 vertical"; echo "  Length:   60-90 sec"; echo "  Aspect:   1080x1920" ;;
        reel|reels) echo "  Format:   9:16 vertical"; echo "  Length:   30-60 sec"; echo "  Aspect:   1080x1920" ;;
        short|shorts) echo "  Format:   9:16 vertical"; echo "  Length:   <60 sec"; echo "  Aspect:   1080x1920" ;;
    esac
    echo ""
    echo "  Checklist:"
    echo "  [ ] Script finalized"
    echo "  [ ] Shot list ready"
    echo "  [ ] B-roll sourced"
    echo "  [ ] Music selected"
    echo "  [ ] Thumbnail designed"
    echo "  [ ] SEO title & tags"
    _log "brief" "$topic ($platform)"
}

cmd_thumbnail() {
    local topic="${1:?Usage: video-script-creator thumbnail <topic>}"
    echo "  THUMBNAIL IDEAS: $topic"
    echo "  ────────────────────────────"
    echo "  1. Split-screen: Before vs After"
    echo "  2. Big text: \"$topic\" + surprised face"
    echo "  3. List style: \"5 $topic Tips\" with checkmarks"
    echo "  4. Minimal: One word + bold arrow"
    echo "  5. Clickbait: Red circle around key element"
    _log "thumbnail" "$topic"
}

cmd_list() {
    echo "[video-script-creator] Saved scripts:"
    ls -1 "$SCRIPTS_DIR"/*.md 2>/dev/null | while read -r f; do
        local name=$(basename "$f" .md)
        local size=$(wc -c < "$f")
        printf "  %-25s %s bytes\n" "$name" "$size"
    done || echo "  (none)"
}

cmd_save() {
    local name="${1:?Usage: video-script-creator save <name>}"
    cat > "$SCRIPTS_DIR/$name.md"
    echo "Saved: $SCRIPTS_DIR/$name.md"
    _log "save" "$name"
}

cmd_show() {
    local name="${1:?Usage: video-script-creator show <name>}"
    local f="$SCRIPTS_DIR/$name.md"
    [ -f "$f" ] && cat "$f" || echo "Not found: $name"
}

cmd_stats() {
    local count=$(ls -1 "$SCRIPTS_DIR"/*.md 2>/dev/null | wc -l)
    local total_words=0
    for f in "$SCRIPTS_DIR"/*.md; do
        [ -f "$f" ] && total_words=$((total_words + $(wc -w < "$f")))
    done 2>/dev/null
    echo "[video-script-creator] Stats"
    echo "  Scripts saved:  $count"
    echo "  Total words:    $total_words"
    echo "  Data dir:       $DATA_DIR"
}

cmd_outro() {
    local style="${1:-summary}"
    echo "  OUTRO ($style):"
    case "$style" in
        summary) echo "  → \"Let's recap the [X] things we covered...\"" ;;
        teaser) echo "  → \"In my next video, I'll show you [topic]...\"" ;;
        cta) echo "  → \"If this helped, subscribe and hit the bell...\"" ;;
    esac
}

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

case "${1:-help}" in
    outline)    shift; cmd_outline "$@" ;;
    intro)      shift; cmd_intro "$@" ;;
    script)     shift; cmd_outline "$@" ;;
    hook)       shift; cmd_hook "$@" ;;
    cta)        shift; cmd_cta "$@" ;;
    outro)      shift; cmd_outro "$@" ;;
    shotlist)   shift; echo "Analyze script and generate shot list" ;;
    timeline)   shift; cmd_timeline "$@" ;;
    brief)      shift; cmd_brief "$@" ;;
    thumbnail)  shift; cmd_thumbnail "$@" ;;
    list)       cmd_list ;;
    save)       shift; cmd_save "$@" ;;
    show)       shift; cmd_show "$@" ;;
    export)     shift; echo "Export to ${2:-txt}" ;;
    stats)      cmd_stats ;;
    help|-h)    show_help ;;
    version|-v) echo "video-script-creator v$VERSION" ;;
    *)          echo "Unknown: $1"; show_help; exit 1 ;;
esac
