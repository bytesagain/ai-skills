#!/usr/bin/env bash
# ppt-outline — Presentation outline and slide deck planning tool
set -euo pipefail
VERSION="2.0.0"
DATA_DIR="${PPT_OUTLINE_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/ppt-outline}"
DB="$DATA_DIR/entries.jsonl"
mkdir -p "$DATA_DIR"

show_help() {
    cat << EOF
ppt-outline v$VERSION — Presentation planning and outline tool

Usage: ppt-outline <command> [args]

Plan:
  outline <topic> [slides]     Generate slide outline
  structure <type>             Deck structure (pitch/report/tutorial/keynote)
  slide <n> <title> <points>   Individual slide content
  flow <topic>                 Presentation flow diagram

Content:
  opener <style>               Opening slide ideas (question/story/stat/bold)
  closer <style>               Closing slide ideas (cta/summary/question)
  data-slide <metric>          Data visualization slide
  compare <a> <b>              Comparison slide
  timeline <events>            Timeline slide

Design:
  layout <type>                Layout suggestions
  colors <mood>                Color palette recommendation
  fonts                        Font pairing suggestions
  rules                        Design best practices

Delivery:
  notes <slide-n> <text>       Speaker notes
  timing <total-min> <slides>  Time per slide calculator
  checklist                    Pre-presentation checklist
  help                         Show this help
EOF
}

cmd_outline() {
    local topic="${1:?Usage: ppt-outline outline <topic> [slides]}"
    local slides="${2:-10}"
    echo "  ═══ Presentation Outline: $topic ═══"
    echo "  Total slides: $slides"
    echo ""
    echo "  Slide 1: Title"
    echo "    $topic"
    echo "    [Subtitle / Your name / Date]"
    echo ""
    echo "  Slide 2: Agenda"
    echo "    • What we will cover today"
    echo ""
    local body=$((slides - 4))
    for i in $(seq 3 $((slides - 2))); do
        echo "  Slide $i: [Section $((i-2))]"
        echo "    • Key point"
        echo "    • Supporting detail"
        echo ""
    done
    echo "  Slide $((slides - 1)): Summary"
    echo "    • Key takeaways"
    echo ""
    echo "  Slide $slides: Q&A / Contact"
    echo "    • Questions?"
    echo "    • Contact info"
    _log "outline" "$topic ($slides slides)"
}

cmd_structure() {
    local type="${1:-pitch}"
    echo "  ═══ Deck Structure: $type ═══"
    case "$type" in
        pitch)
            echo "  1. Problem (1 slide)"
            echo "  2. Solution (1-2 slides)"
            echo "  3. Market size (1 slide)"
            echo "  4. Product demo (2-3 slides)"
            echo "  5. Business model (1 slide)"
            echo "  6. Traction (1 slide)"
            echo "  7. Team (1 slide)"
            echo "  8. Ask (1 slide)" ;;
        report)
            echo "  1. Executive summary"
            echo "  2. Key metrics dashboard"
            echo "  3. Achievements this period"
            echo "  4. Challenges & solutions"
            echo "  5. Financial overview"
            echo "  6. Next quarter goals"
            echo "  7. Action items" ;;
        tutorial)
            echo "  1. What you will learn"
            echo "  2. Prerequisites"
            echo "  3-N. Step-by-step (one concept per slide)"
            echo "  N+1. Practice exercise"
            echo "  N+2. Resources & next steps" ;;
        keynote)
            echo "  1. Bold opening statement"
            echo "  2. The problem/opportunity"
            echo "  3. Story/anecdote"
            echo "  4. The vision (3 pillars)"
            echo "  5-7. Deep dive each pillar"
            echo "  8. Call to action"
            echo "  9. Memorable closing" ;;
        *) echo "  Types: pitch, report, tutorial, keynote" ;;
    esac
}

cmd_opener() {
    local style="${1:-question}"
    echo "  ═══ Opening Slide ($style) ═══"
    case "$style" in
        question) echo "  \"What if I told you [surprising claim]?\"" ;;
        story)    echo "  \"Last year, [brief personal anecdote]...\"" ;;
        stat)     echo "  \"[Big number]% of [audience] struggle with [problem]\"" ;;
        bold)     echo "  \"[Topic] is broken. Here is how we fix it.\"" ;;
        *) echo "  Styles: question, story, stat, bold" ;;
    esac
}

cmd_timing() {
    local total="${1:?Usage: ppt-outline timing <total-minutes> <slides>}"
    local slides="${2:?}"
    local per=$(python3 -c "print('{:.1f}'.format($total / $slides))")
    echo "  ═══ Timing Plan ═══"
    echo "  Total: ${total} min | Slides: $slides | Per slide: ${per} min"
    echo ""
    echo "  Opening (10%):  $((total * 10 / 100)) min"
    echo "  Body (75%):     $((total * 75 / 100)) min"
    echo "  Closing (10%):  $((total * 10 / 100)) min"
    echo "  Buffer (5%):    $((total * 5 / 100)) min"
    echo ""
    echo "  Rule: 1 slide per 2-3 minutes for talks"
    echo "  Rule: More slides OK for quick walkthroughs"
}

cmd_rules() {
    echo "  ═══ Slide Design Rules ═══"
    echo "  1. One idea per slide"
    echo "  2. Max 6 bullet points, max 6 words each"
    echo "  3. Font size minimum 24pt"
    echo "  4. High contrast (dark on light or light on dark)"
    echo "  5. Full-bleed images > clipart"
    echo "  6. Charts: bar for comparison, line for trends, pie for parts"
    echo "  7. Animate sparingly (entrance only, no spinning)"
    echo "  8. Consistent alignment and spacing"
    echo "  9. Your slides support YOU, not replace you"
}

cmd_checklist() {
    echo "  ═══ Pre-Presentation Checklist ═══"
    echo "  Content:"
    echo "  [ ] Every slide has a clear purpose?"
    echo "  [ ] No walls of text?"
    echo "  [ ] Data visualized, not just listed?"
    echo "  [ ] Consistent branding/colors?"
    echo "  Tech:"
    echo "  [ ] Tested on presentation screen?"
    echo "  [ ] Backup copy on USB?"
    echo "  [ ] Fonts embedded in file?"
    echo "  [ ] Videos play without internet?"
    echo "  Delivery:"
    echo "  [ ] Speaker notes prepared?"
    echo "  [ ] Practiced timing?"
    echo "  [ ] Know how to advance/go back?"
}

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

case "${{1:-help}}" in
    outline) shift; cmd_outline "$@" ;;
    structure) shift; cmd_structure "$@" ;;
    opener) shift; cmd_opener "$@" ;;
    timing) shift; cmd_timing "$@" ;;
    rules) shift; cmd_rules "$@" ;;
    checklist) shift; cmd_checklist "$@" ;;
    help|-h) show_help ;;
    version|-v) echo "ppt-outline v$VERSION" ;;
    *) echo "Unknown: $1"; show_help; exit 1 ;;
esac
