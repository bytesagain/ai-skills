#!/usr/bin/env bash
# image-prompt - Design reference and helper tool
set -euo pipefail
VERSION="2.0.0"
DATA_DIR="${IMAGE_PROMPT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/image-prompt}"
DB="$DATA_DIR/data.log"
mkdir -p "$DATA_DIR"

show_help() {
    cat << EOF
image-prompt v$VERSION

Design reference and helper tool

Usage: image-prompt <command> [args]

Commands:
  palette              Color palette
  font                 Font pairing
  layout               Layout template
  icon                 Icon reference
  spacing              Spacing guide
  breakpoint           Responsive breakpoints
  contrast             Contrast checker
  shadow               Shadow presets
  mockup               Mockup template
  checklist            Design checklist
  help                 Show this help
  version              Show version

Data: \$DATA_DIR
EOF
}

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

cmd_palette() {
    echo "  Primary: #2563EB | Secondary: #7C3AED | Accent: #F59E0B"
    _log "palette" "${1:-}"
}

cmd_font() {
    echo "  Heading: Inter/Poppins | Body: Open Sans/Lato"
    _log "font" "${1:-}"
}

cmd_layout() {
    echo "  Grid: 12-col | Spacing: 8px base | Max-width: 1200px"
    _log "layout" "${1:-}"
}

cmd_icon() {
    echo "  Libraries: Heroicons | Lucide | Phosphor | Tabler"
    _log "icon" "${1:-}"
}

cmd_spacing() {
    echo "  xs:4 sm:8 md:16 lg:24 xl:32 2xl:48"
    _log "spacing" "${1:-}"
}

cmd_breakpoint() {
    echo "  sm:640 md:768 lg:1024 xl:1280 2xl:1536"
    _log "breakpoint" "${1:-}"
}

cmd_contrast() {
    echo "  Check: webaim.org/resources/contrastchecker"
    _log "contrast" "${1:-}"
}

cmd_shadow() {
    echo "  sm: 0 1px 2px | md: 0 4px 6px | lg: 0 10px 15px"
    _log "shadow" "${1:-}"
}

cmd_mockup() {
    echo "  Tool: Figma | Sketch | Adobe XD"
    _log "mockup" "${1:-}"
}

cmd_checklist() {
    echo "  [ ] Consistent spacing | [ ] Color contrast | [ ] Mobile responsive"
    _log "checklist" "${1:-}"
}

case "${1:-help}" in
    palette) shift; cmd_palette "$@" ;;
    font) shift; cmd_font "$@" ;;
    layout) shift; cmd_layout "$@" ;;
    icon) shift; cmd_icon "$@" ;;
    spacing) shift; cmd_spacing "$@" ;;
    breakpoint) shift; cmd_breakpoint "$@" ;;
    contrast) shift; cmd_contrast "$@" ;;
    shadow) shift; cmd_shadow "$@" ;;
    mockup) shift; cmd_mockup "$@" ;;
    checklist) shift; cmd_checklist "$@" ;;
    help|-h) show_help ;;
    version|-v) echo "image-prompt v$VERSION" ;;
    *) echo "Unknown: $1"; show_help; exit 1 ;;
esac
