#!/usr/bin/env bash
set -euo pipefail

######################################################################
# font/scripts/script.sh — Font Management Tool
# Powered by BytesAgain | bytesagain.com
######################################################################

# ── platform detection ──────────────────────────────────────────────

detect_platform() {
  case "$(uname -s)" in
    Linux*)  echo "linux" ;;
    Darwin*) echo "macos" ;;
    *)       echo "unknown" ;;
  esac
}

PLATFORM="$(detect_platform)"

USER_FONT_DIR=""
if [[ "${PLATFORM}" == "linux" ]]; then
  USER_FONT_DIR="${HOME}/.local/share/fonts"
elif [[ "${PLATFORM}" == "macos" ]]; then
  USER_FONT_DIR="${HOME}/Library/Fonts"
fi

# ── helpers ─────────────────────────────────────────────────────────

require_fc_tools() {
  if ! command -v fc-list &>/dev/null; then
    echo "Error: fontconfig tools (fc-list, fc-query) not found." >&2
    echo "Install with: sudo apt install fontconfig (Debian/Ubuntu)" >&2
    echo "              or: sudo yum install fontconfig (RHEL/CentOS)" >&2
    exit 1
  fi
}

get_font_list_raw() {
  if [[ "${PLATFORM}" == "linux" ]]; then
    fc-list --format="%{family}\t%{style}\t%{file}\n" 2>/dev/null | sort -u
  elif [[ "${PLATFORM}" == "macos" ]]; then
    if command -v fc-list &>/dev/null; then
      fc-list --format="%{family}\t%{style}\t%{file}\n" 2>/dev/null | sort -u
    else
      system_profiler SPFontsDataType 2>/dev/null | grep "Full Name:" | sed 's/.*Full Name: //' | sort -u
    fi
  else
    echo "Error: unsupported platform" >&2
    exit 1
  fi
}

classify_font() {
  local name_lower
  name_lower="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  if echo "${name_lower}" | grep -qE "(mono|consol|courier|code|terminal|fixed|hack|fira.?code|jetbrains|menlo|source.?code)"; then
    echo "monospace"
  elif echo "${name_lower}" | grep -qE "(serif|times|georgia|garamond|palatino|baskerville|caslon|didot|bodoni|cambria|constantia)"; then
    if echo "${name_lower}" | grep -qE "(sans|gothic|grotesk|helvetica|arial)"; then
      echo "sans-serif"
    else
      echo "serif"
    fi
  elif echo "${name_lower}" | grep -qE "(sans|gothic|grotesk|helvetica|arial|verdana|tahoma|calibri|segoe|roboto|open.?sans|lato|nunito|inter|poppins|noto.?sans|ubuntu|dejavu.?sans|liberation.?sans)"; then
    echo "sans-serif"
  elif echo "${name_lower}" | grep -qE "(display|decorat|script|handwrit|comic|impact|brush|poster|stencil|fancy)"; then
    echo "display"
  else
    echo "sans-serif"
  fi
}

# ── cmd_list ────────────────────────────────────────────────────────

cmd_list() {
  local group_family=false limit=0

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --family) group_family=true; shift ;;
      --limit)  limit="${2:-50}"; shift 2 ;;
      *)        shift ;;
    esac
  done

  if [[ "${PLATFORM}" == "linux" ]]; then
    require_fc_tools
  fi

  if [[ "${group_family}" == true ]]; then
    echo "🔤 Installed Font Families"
    echo "=" "$(printf '=%.0s' $(seq 1 40))"

    local families
    if [[ "${PLATFORM}" == "linux" ]]; then
      families=$(fc-list --format="%{family}\n" 2>/dev/null | sed 's/,.*$//' | sort -u)
    elif [[ "${PLATFORM}" == "macos" ]] && command -v fc-list &>/dev/null; then
      families=$(fc-list --format="%{family}\n" 2>/dev/null | sed 's/,.*$//' | sort -u)
    else
      families=$(get_font_list_raw)
    fi

    local count=0
    local total
    total=$(echo "${families}" | wc -l | tr -d ' ')

    while IFS= read -r fam; do
      [[ -z "${fam}" ]] && continue
      local category
      category="$(classify_font "${fam}")"
      printf "  %-35s [%s]\n" "${fam}" "${category}"
      ((count++))
      if [[ ${limit} -gt 0 && ${count} -ge ${limit} ]]; then
        echo "  ... (showing ${limit} of ${total})"
        break
      fi
    done <<< "${families}"

    echo ""
    echo "Total families: ${total}"

  else
    echo "🔤 Installed Fonts"
    echo "=" "$(printf '=%.0s' $(seq 1 50))"
    printf "  %-30s %-15s %s\n" "Family" "Style" "File"
    echo "  $(printf -- '-%.0s' $(seq 1 70))"

    local count=0
    local total=0

    while IFS=$'\t' read -r family style file; do
      [[ -z "${family}" ]] && continue
      ((total++))
      if [[ ${limit} -gt 0 && ${count} -ge ${limit} ]]; then
        continue  # still counting total
      fi
      # Truncate long paths
      local short_file
      short_file="$(basename "${file}" 2>/dev/null || echo "${file}")"
      printf "  %-30s %-15s %s\n" "${family:0:30}" "${style:0:15}" "${short_file}"
      ((count++))
    done < <(get_font_list_raw)

    if [[ ${limit} -gt 0 && ${total} -gt ${limit} ]]; then
      echo "  ... (showing ${limit} of ${total})"
    fi
    echo ""
    echo "Total fonts: ${total}"
  fi
}

# ── cmd_search ──────────────────────────────────────────────────────

cmd_search() {
  local query="${1:-}"
  if [[ -z "${query}" ]]; then
    echo "Usage: script.sh search \"<query>\""
    exit 1
  fi

  if [[ "${PLATFORM}" == "linux" ]]; then
    require_fc_tools
  fi

  echo "🔍 Searching for: ${query}"
  echo "=" "$(printf '=%.0s' $(seq 1 40))"

  local results
  local count=0

  if [[ "${PLATFORM}" == "linux" ]] || command -v fc-list &>/dev/null; then
    results=$(fc-list --format="%{family}\t%{style}\t%{file}\n" 2>/dev/null | grep -i "${query}" | sort -u || true)
  else
    results=$(get_font_list_raw | grep -i "${query}" || true)
  fi

  if [[ -z "${results}" ]]; then
    echo "  No fonts found matching '${query}'."
    return
  fi

  printf "  %-30s %-15s %s\n" "Family" "Style" "File"
  echo "  $(printf -- '-%.0s' $(seq 1 70))"

  while IFS=$'\t' read -r family style file; do
    [[ -z "${family}" ]] && continue
    local category
    category="$(classify_font "${family}")"
    local short_file
    short_file="$(basename "${file}" 2>/dev/null || echo "${file}")"
    printf "  %-30s %-15s %s  [%s]\n" "${family:0:30}" "${style:0:15}" "${short_file}" "${category}"
    ((count++))
  done <<< "${results}"

  echo ""
  echo "Found: ${count} matches"
}

# ── cmd_preview ─────────────────────────────────────────────────────

cmd_preview() {
  local font_name="${1:-}" sample="${2:-The quick brown fox jumps over the lazy dog.}"

  if [[ -z "${font_name}" ]]; then
    echo "Usage: script.sh preview \"<font_name>\" [\"sample text\"]"
    exit 1
  fi

  echo "🖼  Font Preview: ${font_name}"
  echo "=" "$(printf '=%.0s' $(seq 1 50))"

  # Try figlet first for ASCII art rendering
  if command -v figlet &>/dev/null; then
    local figlet_font=""
    # Check if font exists in figlet
    local font_lower
    font_lower="$(echo "${font_name}" | tr '[:upper:]' '[:lower:]')"
    if figlet -f "${font_lower}" "test" &>/dev/null; then
      figlet_font="${font_lower}"
    fi

    if [[ -n "${figlet_font}" ]]; then
      echo ""
      figlet -f "${figlet_font}" "${sample:0:30}"
    else
      echo ""
      figlet "${sample:0:40}" 2>/dev/null || true
    fi
    echo ""
  fi

  # Also show plain text samples
  echo "  Font: ${font_name}"
  local category
  category="$(classify_font "${font_name}")"
  echo "  Type: ${category}"
  echo ""
  echo "  Sample text:"
  echo "  ────────────────────────────────────────"
  echo "  ${sample}"
  echo ""
  echo "  ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  echo "  abcdefghijklmnopqrstuvwxyz"
  echo "  0123456789"
  echo "  !@#\$%^&*()_+-=[]{}|;':\",./<>?"
  echo ""

  # Size samples
  echo "  Size samples:"
  echo "  12px: ${sample}"
  echo "  16px: ${sample}"
  echo "  24px: ${sample:0:50}"
  echo ""

  # Check if font actually exists on system
  if command -v fc-list &>/dev/null; then
    local matches
    matches=$(fc-list | grep -ic "${font_name}" || true)
    if [[ "${matches}" -gt 0 ]]; then
      echo "  ✅ Font '${font_name}' is installed (${matches} variants)"
    else
      echo "  ⚠️  Font '${font_name}' not found on system"
    fi
  fi
}

# ── cmd_pair ────────────────────────────────────────────────────────

cmd_pair() {
  local font_name="${1:-}"

  if [[ -z "${font_name}" ]]; then
    echo "Usage: script.sh pair \"<font_name>\""
    exit 1
  fi

  local category
  category="$(classify_font "${font_name}")"

  echo "🎨 Font Pairing Suggestions for: ${font_name}"
  echo "   Category: ${category}"
  echo "=" "$(printf '=%.0s' $(seq 1 50))"
  echo ""

  python3 << 'PYEOF' "${font_name}" "${category}"
import sys

font_name = sys.argv[1]
category = sys.argv[2]

pairings = {
    'serif': {
        'heading_with': ['sans-serif', 'display'],
        'body_with': ['sans-serif'],
        'suggestions': [
            ('Heading', 'Roboto / Open Sans / Lato', 'sans-serif for contrast'),
            ('Body', 'Georgia / Garamond / Palatino', 'classic readability'),
            ('Code', 'Fira Code / JetBrains Mono / Source Code Pro', 'monospace for code blocks'),
            ('Accent', 'Playfair Display / Merriweather', 'decorative serif for emphasis'),
        ]
    },
    'sans-serif': {
        'heading_with': ['serif', 'display'],
        'body_with': ['serif'],
        'suggestions': [
            ('Heading', 'Playfair Display / Merriweather / Georgia', 'serif for visual hierarchy'),
            ('Body', 'Inter / Roboto / Open Sans', 'matching sans-serif for body'),
            ('Code', 'JetBrains Mono / Fira Code / Cascadia Code', 'monospace for code blocks'),
            ('Accent', 'Montserrat / Oswald / Raleway', 'bold sans for emphasis'),
        ]
    },
    'monospace': {
        'heading_with': ['sans-serif', 'serif'],
        'body_with': ['sans-serif'],
        'suggestions': [
            ('Heading', 'Inter / Roboto / Helvetica Neue', 'clean sans-serif heading'),
            ('Body', 'Open Sans / Noto Sans / Lato', 'readable body text'),
            ('Code', 'Keep using ' + font_name, 'monospace for all code'),
            ('UI', 'SF Pro / Segoe UI / Ubuntu', 'system font for interface'),
        ]
    },
    'display': {
        'heading_with': ['display'],
        'body_with': ['sans-serif', 'serif'],
        'suggestions': [
            ('Heading', 'Use ' + font_name + ' sparingly', 'display fonts for titles only'),
            ('Body', 'Open Sans / Roboto / Lora', 'readable body font'),
            ('Sub-heading', 'Raleway / Montserrat / Source Sans', 'lighter weight for subtitles'),
            ('Code', 'Fira Code / Source Code Pro', 'monospace for code blocks'),
        ]
    }
}

info = pairings.get(category, pairings['sans-serif'])

print('  Recommended pairings:')
print()
for role, fonts, reason in info['suggestions']:
    print(f'  {role:<14s}: {fonts}')
    print(f'  {"":14s}  → {reason}')
    print()

print('  General rules:')
print('  • Pair fonts from different categories (serif + sans-serif)')
print('  • Limit to 2-3 fonts per project')
print('  • Match x-height for visual consistency')
print('  • Use weight contrast (light body + bold heading)')
PYEOF
}

# ── cmd_info ────────────────────────────────────────────────────────

cmd_info() {
  local target="${1:-}"

  if [[ -z "${target}" ]]; then
    echo "Usage: script.sh info \"<font_name_or_path>\""
    exit 1
  fi

  echo "ℹ️  Font Info: ${target}"
  echo "=" "$(printf '=%.0s' $(seq 1 50))"

  # If target is a file path
  if [[ -f "${target}" ]]; then
    if command -v fc-query &>/dev/null; then
      echo ""
      echo "  File: ${target}"
      echo "  Size: $(du -h "${target}" | cut -f1)"
      echo ""

      fc-query "${target}" --format="  Family:     %{family}\n  Style:      %{style}\n  Weight:     %{weight}\n  Slant:      %{slant}\n  Format:     %{fontformat}\n  Spacing:    %{spacing}\n" 2>/dev/null || echo "  (Could not parse font file)"

      # Character count
      local char_count
      char_count=$(fc-query "${target}" --format="%{charset}\n" 2>/dev/null | tr ' ' '\n' | wc -l || echo "unknown")
      echo "  Char ranges: ${char_count}"
    else
      echo "  File: ${target}"
      echo "  Size: $(du -h "${target}" | cut -f1)"
      local ext="${target##*.}"
      echo "  Format: ${ext}"
      echo "  (Install fontconfig for detailed info)"
    fi
    return
  fi

  # Search by font name
  if [[ "${PLATFORM}" == "linux" ]] || command -v fc-list &>/dev/null; then
    require_fc_tools

    local matches
    matches=$(fc-list | grep -i "${target}" || true)

    if [[ -z "${matches}" ]]; then
      echo "  Font '${target}' not found on system."
      return
    fi

    # Get the first matching file
    local first_file
    first_file=$(echo "${matches}" | head -1 | cut -d: -f1 | tr -d ' ')

    if [[ -f "${first_file}" ]]; then
      echo ""
      echo "  File: ${first_file}"
      echo "  Size: $(du -h "${first_file}" | cut -f1)"
      echo ""

      fc-query "${first_file}" --format="  Family:     %{family}\n  Style:      %{style}\n  Weight:     %{weight}\n  Slant:      %{slant}\n  Format:     %{fontformat}\n  Spacing:    %{spacing}\n" 2>/dev/null || true

      # Character count
      local char_count
      char_count=$(fc-query "${first_file}" --format="%{charset}\n" 2>/dev/null | tr ' ' '\n' | wc -l || echo "unknown")
      echo "  Char ranges: ${char_count}"
    fi

    local variant_count
    variant_count=$(echo "${matches}" | wc -l | tr -d ' ')
    if [[ "${variant_count}" -gt 1 ]]; then
      echo ""
      echo "  Variants (${variant_count}):"
      echo "${matches}" | head -10 | while IFS= read -r line; do
        local f
        f="$(echo "${line}" | cut -d: -f1 | tr -d ' ')"
        local name
        name="$(basename "${f}")"
        echo "    • ${name}"
      done
      if [[ "${variant_count}" -gt 10 ]]; then
        echo "    ... and $((variant_count - 10)) more"
      fi
    fi
  else
    echo "  (fontconfig not available; provide a file path for info)"
  fi

  local category
  category="$(classify_font "${target}")"
  echo ""
  echo "  Category: ${category}"
}

# ── cmd_install ─────────────────────────────────────────────────────

cmd_install() {
  local font_file="${1:-}"

  if [[ -z "${font_file}" ]]; then
    echo "Usage: script.sh install \"<font_file_path>\""
    echo "  Supports: .ttf, .otf, .woff2"
    exit 1
  fi

  if [[ ! -f "${font_file}" ]]; then
    echo "Error: file not found: ${font_file}" >&2
    exit 1
  fi

  # Validate extension
  local ext="${font_file##*.}"
  ext="$(echo "${ext}" | tr '[:upper:]' '[:lower:]')"
  case "${ext}" in
    ttf|otf|woff2) ;;
    *)
      echo "Error: unsupported font format '.${ext}'. Use .ttf, .otf, or .woff2." >&2
      exit 1
      ;;
  esac

  if [[ -z "${USER_FONT_DIR}" ]]; then
    echo "Error: unsupported platform for font installation." >&2
    exit 1
  fi

  mkdir -p "${USER_FONT_DIR}"

  local filename
  filename="$(basename "${font_file}")"
  local dest="${USER_FONT_DIR}/${filename}"

  # Check if already installed
  if [[ -f "${dest}" ]]; then
    echo "⚠️  Font '${filename}' already installed at ${dest}"
    echo "   Overwrite? This will replace the existing file."
    # In non-interactive mode, just overwrite
  fi

  cp "${font_file}" "${dest}"
  echo "📁 Copied ${filename} → ${USER_FONT_DIR}/"

  # Refresh font cache
  if command -v fc-cache &>/dev/null; then
    echo "🔄 Refreshing font cache..."
    fc-cache -f "${USER_FONT_DIR}" 2>/dev/null
    echo "✅ Font cache updated."
  elif [[ "${PLATFORM}" == "macos" ]]; then
    echo "✅ Font installed (macOS auto-detects new fonts)."
  fi

  echo ""
  echo "✅ Font '${filename}' installed."
  echo "   Location: ${dest}"

  # Show info about the installed font
  if command -v fc-query &>/dev/null; then
    echo ""
    fc-query "${dest}" --format="   Family: %{family}\n   Style:  %{style}\n   Format: %{fontformat}\n" 2>/dev/null || true
  fi
}

# ── cmd_help ────────────────────────────────────────────────────────

cmd_help() {
  cat <<'EOF'
font — Font Management Tool

Commands:
  list [--family] [--limit N]             List installed fonts
  search "<query>"                        Search fonts by name
  preview "<font>" ["sample text"]        Preview a font sample
  pair "<font>"                           Font pairing suggestions
  info "<font_name_or_path>"              Font metadata
  install "<font_file>"                   Install a font (.ttf/.otf/.woff2)
  help                                    Show this help message

Requires: fontconfig (fc-list, fc-query, fc-cache) on Linux
EOF
}

# ── main dispatch ───────────────────────────────────────────────────

main() {
  local cmd="${1:-help}"
  shift || true

  case "${cmd}" in
    list)    cmd_list "$@" ;;
    search)  cmd_search "$@" ;;
    preview) cmd_preview "$@" ;;
    pair)    cmd_pair "$@" ;;
    info)    cmd_info "$@" ;;
    install) cmd_install "$@" ;;
    help|--help|-h) cmd_help ;;
    *)
      echo "Unknown command: ${cmd}" >&2
      cmd_help
      exit 1
      ;;
  esac
}

main "$@"
