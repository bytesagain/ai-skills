#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# layout/scripts/script.sh — Generate CSS grid, flexbox, responsive layouts
# Version: 3.0.0 | Author: BytesAgain
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── Helpers ────────────────────────────────────────────────────────────────

die()  { echo "ERROR: $*" >&2; exit 1; }
info() { echo "▸ $*"; }

write_file() {
  local path="$1" content="$2"
  local dir
  dir="$(dirname "$path")"
  mkdir -p "$dir"
  echo "$content" > "$path"
  info "Written: $path"
}

# ─── Commands ───────────────────────────────────────────────────────────────

cmd_help() {
  cat <<'EOF'
layout — Generate CSS grid, flexbox, and responsive layouts

Commands:
  grid        Generate CSS Grid layout
  flex        Generate Flexbox layout
  responsive  Generate responsive breakpoint media queries
  scaffold    Generate page skeleton HTML
  spacing     Generate spacing utility classes
  analyze     Analyze existing CSS layout properties

Run: bash scripts/script.sh <command> [options]
EOF
}

cmd_grid() {
  local columns=3 rows=1 gap="1rem" output="" class="grid-container"
  local col_template="" row_template="" areas=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --columns)      columns="$2";      shift 2 ;;
      --rows)         rows="$2";         shift 2 ;;
      --gap)          gap="$2";          shift 2 ;;
      --output)       output="$2";       shift 2 ;;
      --class)        class="$2";        shift 2 ;;
      --col-template) col_template="$2"; shift 2 ;;
      --row-template) row_template="$2"; shift 2 ;;
      --areas)        areas="$2";        shift 2 ;;
      *) die "Unknown option: $1" ;;
    esac
  done

  # Build column template
  if [[ -z "$col_template" ]]; then
    col_template="repeat(${columns}, 1fr)"
  fi

  # Build row template
  if [[ -z "$row_template" ]] && [[ "$rows" -gt 1 ]]; then
    row_template="repeat(${rows}, auto)"
  fi

  local css=""
  css+=".${class} {\n"
  css+="  display: grid;\n"
  css+="  grid-template-columns: ${col_template};\n"
  if [[ -n "$row_template" ]]; then
    css+="  grid-template-rows: ${row_template};\n"
  fi
  if [[ -n "$areas" ]]; then
    # areas format: "header header header|sidebar main main|footer footer footer"
    css+="  grid-template-areas:\n"
    IFS='|' read -ra area_rows <<< "$areas"
    for arow in "${area_rows[@]}"; do
      css+="    \"${arow}\"\n"
    done
    css+="  ;\n"
  fi
  css+="  gap: ${gap};\n"
  css+="}\n\n"

  # Generate child items
  local total=$(( columns * rows ))
  for i in $(seq 1 "$total"); do
    css+=".${class}__item-${i} {\n"
    css+="  /* grid-column: span 1; */\n"
    css+="  /* grid-row: span 1; */\n"
    css+="}\n\n"
  done

  local result
  result="$(echo -e "$css")"

  if [[ -n "$output" ]]; then
    write_file "$output" "$result"
  else
    echo "$result"
  fi
}

cmd_flex() {
  local direction="row" wrap="nowrap" justify="flex-start" align="stretch"
  local items=3 output="" class="flex-container" item_grow="0"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --direction) direction="$2"; shift 2 ;;
      --wrap)      wrap="wrap";    shift ;;
      --nowrap)    wrap="nowrap";  shift ;;
      --justify)   justify="$2";  shift 2 ;;
      --align)     align="$2";    shift 2 ;;
      --items)     items="$2";    shift 2 ;;
      --output)    output="$2";   shift 2 ;;
      --class)     class="$2";    shift 2 ;;
      --grow)      item_grow="$2"; shift 2 ;;
      *) die "Unknown option: $1" ;;
    esac
  done

  local css=""
  css+=".${class} {\n"
  css+="  display: flex;\n"
  css+="  flex-direction: ${direction};\n"
  css+="  flex-wrap: ${wrap};\n"
  css+="  justify-content: ${justify};\n"
  css+="  align-items: ${align};\n"
  css+="}\n\n"

  for i in $(seq 1 "$items"); do
    css+=".${class}__item-${i} {\n"
    css+="  flex: ${item_grow} 1 auto;\n"
    css+="}\n\n"
  done

  local result
  result="$(echo -e "$css")"

  if [[ -n "$output" ]]; then
    write_file "$output" "$result"
  else
    echo "$result"
  fi
}

cmd_responsive() {
  local breakpoints_str="" output="" prefix="screen-"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --breakpoints) breakpoints_str="$2"; shift 2 ;;
      --output)      output="$2";          shift 2 ;;
      --prefix)      prefix="$2";          shift 2 ;;
      *) die "Unknown option: $1" ;;
    esac
  done
  [[ -n "$breakpoints_str" ]] || die "Missing --breakpoints (e.g. sm:640,md:768,lg:1024)"

  IFS=',' read -ra pairs <<< "$breakpoints_str"

  local css="/* Responsive breakpoints */\n\n"

  # Mobile-first: min-width media queries
  for pair in "${pairs[@]}"; do
    IFS=':' read -r name value <<< "$pair"
    [[ -n "$name" && -n "$value" ]] || die "Invalid breakpoint: $pair (expected name:px)"
    css+="/* ${name}: ${value}px and up */\n"
    css+="@media (min-width: ${value}px) {\n"
    css+="  .${prefix}${name}-only {\n"
    css+="    /* styles for ${name} screens */\n"
    css+="  }\n"
    css+="}\n\n"
  done

  # Also generate max-width (desktop-first) variants
  css+="/* Desktop-first variants */\n\n"
  for pair in "${pairs[@]}"; do
    IFS=':' read -r name value <<< "$pair"
    local max_val=$(( value - 1 ))
    css+="@media (max-width: ${max_val}px) {\n"
    css+="  .below-${name} {\n"
    css+="    /* styles below ${name} */\n"
    css+="  }\n"
    css+="}\n\n"
  done

  local result
  result="$(echo -e "$css")"

  if [[ -n "$output" ]]; then
    write_file "$output" "$result"
  else
    echo "$result"
  fi
}

cmd_scaffold() {
  local type="basic" output="" title="Page" css_file=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --type)     type="$2";     shift 2 ;;
      --output)   output="$2";   shift 2 ;;
      --title)    title="$2";    shift 2 ;;
      --css)      css_file="$2"; shift 2 ;;
      *) die "Unknown option: $1" ;;
    esac
  done

  local css_link=""
  if [[ -n "$css_file" ]]; then
    css_link="<link rel=\"stylesheet\" href=\"${css_file}\">"
  fi

  local body=""
  case "$type" in
    basic)
      body=$(cat <<'BODY'
  <header class="header">
    <nav class="nav">Navigation</nav>
  </header>
  <main class="main">
    <h1>Main Content</h1>
  </main>
  <footer class="footer">
    <p>Footer</p>
  </footer>
BODY
      ) ;;
    holy-grail)
      body=$(cat <<'BODY'
  <header class="header">
    <nav class="nav">Navigation</nav>
  </header>
  <div class="body-grid">
    <aside class="sidebar-left">Left Sidebar</aside>
    <main class="main">
      <h1>Main Content</h1>
    </main>
    <aside class="sidebar-right">Right Sidebar</aside>
  </div>
  <footer class="footer">
    <p>Footer</p>
  </footer>
BODY
      ) ;;
    dashboard)
      body=$(cat <<'BODY'
  <header class="header">
    <div class="header__logo">Logo</div>
    <nav class="header__nav">Nav Items</nav>
    <div class="header__user">User</div>
  </header>
  <div class="dashboard">
    <aside class="dashboard__sidebar">
      <nav class="sidebar-nav">
        <ul>
          <li>Overview</li>
          <li>Analytics</li>
          <li>Settings</li>
        </ul>
      </nav>
    </aside>
    <main class="dashboard__content">
      <div class="dashboard__cards">
        <div class="card">Card 1</div>
        <div class="card">Card 2</div>
        <div class="card">Card 3</div>
      </div>
      <div class="dashboard__table">
        <table><tr><th>Data Table</th></tr></table>
      </div>
    </main>
  </div>
BODY
      ) ;;
    landing)
      body=$(cat <<'BODY'
  <header class="header">
    <div class="header__logo">Brand</div>
    <nav class="header__nav">
      <a href="#features">Features</a>
      <a href="#pricing">Pricing</a>
      <a href="#contact">Contact</a>
    </nav>
  </header>
  <section class="hero">
    <h1>Hero Headline</h1>
    <p>Subheadline text goes here</p>
    <button class="cta-button">Get Started</button>
  </section>
  <section id="features" class="features">
    <div class="feature-card">Feature 1</div>
    <div class="feature-card">Feature 2</div>
    <div class="feature-card">Feature 3</div>
  </section>
  <section id="pricing" class="pricing">
    <div class="price-card">Basic</div>
    <div class="price-card">Pro</div>
    <div class="price-card">Enterprise</div>
  </section>
  <footer class="footer">
    <p>Footer</p>
  </footer>
BODY
      ) ;;
    *)
      die "Unknown scaffold type: $type (basic|holy-grail|dashboard|landing)"
      ;;
  esac

  local html
  html=$(cat <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${title}</title>
  ${css_link}
</head>
<body>
${body}
</body>
</html>
HTML
  )

  if [[ -n "$output" ]]; then
    write_file "$output" "$html"
  else
    echo "$html"
  fi
}

cmd_spacing() {
  local base=4 steps=8 unit="px" output="" prefix="sp"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --base)   base="$2";   shift 2 ;;
      --steps)  steps="$2";  shift 2 ;;
      --unit)   unit="$2";   shift 2 ;;
      --output) output="$2"; shift 2 ;;
      --prefix) prefix="$2"; shift 2 ;;
      *) die "Unknown option: $1" ;;
    esac
  done

  local css="/* Spacing system: base=${base}${unit}, ${steps} steps */\n"
  css+=":root {\n"
  for i in $(seq 0 "$steps"); do
    local val=$(( base * i ))
    css+="  --${prefix}-${i}: ${val}${unit};\n"
  done
  css+="}\n\n"

  # Margin utilities
  css+="/* Margin utilities */\n"
  for i in $(seq 0 "$steps"); do
    local val=$(( base * i ))
    css+=".m-${i}  { margin: ${val}${unit}; }\n"
    css+=".mt-${i} { margin-top: ${val}${unit}; }\n"
    css+=".mr-${i} { margin-right: ${val}${unit}; }\n"
    css+=".mb-${i} { margin-bottom: ${val}${unit}; }\n"
    css+=".ml-${i} { margin-left: ${val}${unit}; }\n"
    css+=".mx-${i} { margin-left: ${val}${unit}; margin-right: ${val}${unit}; }\n"
    css+=".my-${i} { margin-top: ${val}${unit}; margin-bottom: ${val}${unit}; }\n"
  done
  css+="\n"

  # Padding utilities
  css+="/* Padding utilities */\n"
  for i in $(seq 0 "$steps"); do
    local val=$(( base * i ))
    css+=".p-${i}  { padding: ${val}${unit}; }\n"
    css+=".pt-${i} { padding-top: ${val}${unit}; }\n"
    css+=".pr-${i} { padding-right: ${val}${unit}; }\n"
    css+=".pb-${i} { padding-bottom: ${val}${unit}; }\n"
    css+=".pl-${i} { padding-left: ${val}${unit}; }\n"
    css+=".px-${i} { padding-left: ${val}${unit}; padding-right: ${val}${unit}; }\n"
    css+=".py-${i} { padding-top: ${val}${unit}; padding-bottom: ${val}${unit}; }\n"
  done

  local result
  result="$(echo -e "$css")"

  if [[ -n "$output" ]]; then
    write_file "$output" "$result"
  else
    echo "$result"
  fi
}

cmd_analyze() {
  local input=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --input) input="$2"; shift 2 ;;
      *) die "Unknown option: $1" ;;
    esac
  done
  [[ -n "$input" ]] || die "Missing --input CSS file"
  [[ -f "$input" ]] || die "File not found: $input"

  echo "=== Layout Analysis: $input ==="
  echo ""

  # Count selectors
  local selector_count
  selector_count=$(grep -c '{' "$input" 2>/dev/null || echo "0")
  echo "Total rule blocks: $selector_count"

  # Find display properties
  echo ""
  echo "--- Display Types ---"
  local display_grid display_flex display_block display_inline
  display_grid=$(grep -c 'display:\s*grid' "$input" 2>/dev/null || echo "0")
  display_flex=$(grep -c 'display:\s*flex' "$input" 2>/dev/null || echo "0")
  display_block=$(grep -c 'display:\s*block' "$input" 2>/dev/null || echo "0")
  display_inline=$(grep -c 'display:\s*inline' "$input" 2>/dev/null || echo "0")
  echo "  grid:   $display_grid"
  echo "  flex:   $display_flex"
  echo "  block:  $display_block"
  echo "  inline: $display_inline"

  # Find media queries
  echo ""
  echo "--- Media Queries ---"
  local mq_count
  mq_count=$(grep -c '@media' "$input" 2>/dev/null || echo "0")
  echo "  Total: $mq_count"
  if [[ "$mq_count" -gt 0 ]]; then
    grep -oP '@media\s*\([^)]+\)' "$input" | sort -u | while read -r mq; do
      echo "    $mq"
    done
  fi

  # Find grid properties
  echo ""
  echo "--- Grid Properties ---"
  grep -oP 'grid-template-columns:\s*[^;]+' "$input" 2>/dev/null | head -5 | while read -r line; do
    echo "  $line"
  done
  grep -oP 'grid-template-rows:\s*[^;]+' "$input" 2>/dev/null | head -5 | while read -r line; do
    echo "  $line"
  done

  # Find flex properties
  echo ""
  echo "--- Flex Properties ---"
  grep -oP 'flex-direction:\s*[^;]+' "$input" 2>/dev/null | sort -u | while read -r line; do
    echo "  $line"
  done
  grep -oP 'justify-content:\s*[^;]+' "$input" 2>/dev/null | sort -u | while read -r line; do
    echo "  $line"
  done

  # Nesting estimate (by indentation depth)
  echo ""
  echo "--- Nesting ---"
  local max_depth=0
  while IFS= read -r line; do
    local spaces="${line%%[^ ]*}"
    local depth=$(( ${#spaces} / 2 ))
    if [[ $depth -gt $max_depth ]]; then
      max_depth=$depth
    fi
  done < "$input"
  echo "  Max nesting depth (approx): $max_depth"

  # File stats
  echo ""
  echo "--- File Stats ---"
  local lines bytes
  lines=$(wc -l < "$input")
  bytes=$(wc -c < "$input")
  echo "  Lines: $lines"
  echo "  Size: $bytes bytes"
}

# ─── Main dispatcher ───────────────────────────────────────────────────────

main() {
  local cmd="${1:-help}"
  shift || true

  case "$cmd" in
    grid)       cmd_grid "$@" ;;
    flex)       cmd_flex "$@" ;;
    responsive) cmd_responsive "$@" ;;
    scaffold)   cmd_scaffold "$@" ;;
    spacing)    cmd_spacing "$@" ;;
    analyze)    cmd_analyze "$@" ;;
    help|--help|-h) cmd_help ;;
    *) die "Unknown command: $cmd. Run with 'help' for usage." ;;
  esac
}

main "$@"
