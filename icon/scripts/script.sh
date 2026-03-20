#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# icon/scripts/script.sh — Generate, convert, search, resize icons & favicons
# Version: 3.0.0 | Author: BytesAgain
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── Helpers ────────────────────────────────────────────────────────────────

die()  { echo "ERROR: $*" >&2; exit 1; }
info() { echo "▸ $*"; }

ensure_dir() {
  [[ -n "${1:-}" ]] || die "Output directory not specified"
  mkdir -p "$1"
}

parse_csv() {
  # Split comma-separated values into an array
  local IFS=','
  read -ra PARSED <<< "$1"
  echo "${PARSED[@]}"
}

# ─── Built-in icon shapes ──────────────────────────────────────────────────

svg_shape_arrow_right() {
  local size="$1" color="$2"
  cat <<SVG
<svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}" viewBox="0 0 ${size} ${size}" fill="none" stroke="${color}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <line x1="5" y1="$((size/2))" x2="$((size-5))" y2="$((size/2))"/>
  <polyline points="$((size/2)),5 $((size-5)),$((size/2)) $((size/2)),$((size-5))"/>
</svg>
SVG
}

svg_shape_circle() {
  local size="$1" color="$2"
  local r=$(( size/2 - 2 ))
  cat <<SVG
<svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}" viewBox="0 0 ${size} ${size}">
  <circle cx="$((size/2))" cy="$((size/2))" r="${r}" fill="none" stroke="${color}" stroke-width="2"/>
</svg>
SVG
}

svg_shape_square() {
  local size="$1" color="$2"
  cat <<SVG
<svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}" viewBox="0 0 ${size} ${size}">
  <rect x="2" y="2" width="$((size-4))" height="$((size-4))" rx="2" fill="none" stroke="${color}" stroke-width="2"/>
</svg>
SVG
}

svg_shape_star() {
  local size="$1" color="$2"
  local cx=$((size/2)) cy=$((size/2))
  cat <<SVG
<svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}" viewBox="0 0 ${size} ${size}">
  <polygon points="${cx},2 $((cx+3)),$((cy-2)) $((size-2)),$((cy-2)) $((cx+5)),$((cy+2)) $((cx+4)),$((size-2)) ${cx},$((cy+4)) $((cx-4)),$((size-2)) $((cx-5)),$((cy+2)) 2,$((cy-2)) $((cx-3)),$((cy-2))" fill="none" stroke="${color}" stroke-width="1.5"/>
</svg>
SVG
}

svg_shape_placeholder() {
  local size="$1" color="$2" name="$3"
  local letter="${name:0:1}"
  letter="${letter^^}"
  cat <<SVG
<svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}" viewBox="0 0 ${size} ${size}">
  <rect x="1" y="1" width="$((size-2))" height="$((size-2))" rx="4" fill="none" stroke="${color}" stroke-width="2"/>
  <text x="50%" y="55%" text-anchor="middle" dominant-baseline="middle" font-family="sans-serif" font-size="$((size*40/100))" fill="${color}">${letter}</text>
</svg>
SVG
}

# ─── Icon registry for search ──────────────────────────────────────────────

ICON_NAMES=(
  arrow-right arrow-left arrow-up arrow-down
  chevron-right chevron-left chevron-up chevron-down
  circle square star triangle diamond
  check close plus minus
  search home menu settings
  user users mail phone
  heart bookmark flag bell
  edit trash copy paste
  download upload share link
  lock unlock eye eye-off
  sun moon cloud rain
  play pause stop skip
  folder file image video
  camera mic speaker volume
  calendar clock map pin
  wifi bluetooth battery power
)

# ─── Commands ───────────────────────────────────────────────────────────────

cmd_help() {
  cat <<'EOF'
icon — Generate, convert, search, and resize icons

Commands:
  generate   Generate an SVG icon by name
  sprite     Combine SVGs into a sprite sheet
  convert    Convert between ICO/PNG/SVG formats
  search     Search icon names by keyword
  resize     Batch resize icon files
  favicon    Generate full favicon set from source

Run: bash scripts/script.sh <command> [options]
EOF
}

cmd_generate() {
  local name="" size=24 color="#333333" output="."
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --name)   name="$2";   shift 2 ;;
      --size)   size="$2";   shift 2 ;;
      --color)  color="$2";  shift 2 ;;
      --output) output="$2"; shift 2 ;;
      *) die "Unknown option: $1" ;;
    esac
  done
  [[ -n "$name" ]] || die "Missing --name"
  ensure_dir "$output"

  local outfile="${output}/${name}.svg"
  case "$name" in
    arrow-right|arrow-left|arrow-up|arrow-down)
      svg_shape_arrow_right "$size" "$color" > "$outfile" ;;
    circle)
      svg_shape_circle "$size" "$color" > "$outfile" ;;
    square|check|close|plus|minus)
      svg_shape_square "$size" "$color" > "$outfile" ;;
    star|heart|bookmark)
      svg_shape_star "$size" "$color" > "$outfile" ;;
    *)
      svg_shape_placeholder "$size" "$color" "$name" > "$outfile" ;;
  esac
  info "Generated ${outfile} (${size}x${size}, ${color})"
}

cmd_sprite() {
  local input="" output="sprite.svg" prefix="icon-"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --input)  input="$2";  shift 2 ;;
      --output) output="$2"; shift 2 ;;
      --prefix) prefix="$2"; shift 2 ;;
      *) die "Unknown option: $1" ;;
    esac
  done
  [[ -n "$input" ]] || die "Missing --input directory"
  [[ -d "$input" ]] || die "Input directory not found: $input"

  local svgs=()
  while IFS= read -r -d '' f; do
    svgs+=("$f")
  done < <(find "$input" -maxdepth 1 -name '*.svg' -print0 | sort -z)

  [[ ${#svgs[@]} -gt 0 ]] || die "No SVG files found in $input"

  {
    echo '<svg xmlns="http://www.w3.org/2000/svg" style="display:none">'
    for svg_file in "${svgs[@]}"; do
      local basename_noext
      basename_noext="$(basename "$svg_file" .svg)"
      local id="${prefix}${basename_noext}"
      # Extract viewBox from source SVG
      local viewbox
      viewbox=$(grep -oP 'viewBox="[^"]*"' "$svg_file" | head -1 || echo 'viewBox="0 0 24 24"')
      echo "  <symbol id=\"${id}\" ${viewbox}>"
      # Extract inner content (skip opening/closing svg tags)
      sed -n '/<svg/,/<\/svg>/{ /<svg/d; /<\/svg>/d; p; }' "$svg_file" | sed 's/^/    /'
      echo "  </symbol>"
    done
    echo '</svg>'
  } > "$output"
  info "Sprite sheet created: ${output} (${#svgs[@]} icons)"
}

cmd_convert() {
  local input="" format="" sizes_str="32"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --input)  input="$2";      shift 2 ;;
      --format) format="$2";     shift 2 ;;
      --sizes)  sizes_str="$2";  shift 2 ;;
      *) die "Unknown option: $1" ;;
    esac
  done
  [[ -n "$input" ]]  || die "Missing --input file"
  [[ -f "$input" ]]  || die "File not found: $input"
  [[ -n "$format" ]] || die "Missing --format (png|ico|svg)"

  local base
  base="$(basename "$input" | sed 's/\.[^.]*$//')"
  local outdir
  outdir="$(dirname "$input")"

  IFS=',' read -ra sizes <<< "$sizes_str"

  case "$format" in
    png)
      if command -v convert &>/dev/null; then
        for s in "${sizes[@]}"; do
          local outf="${outdir}/${base}-${s}.png"
          convert -background none -resize "${s}x${s}" "$input" "$outf"
          info "Converted: $outf"
        done
      elif command -v rsvg-convert &>/dev/null; then
        for s in "${sizes[@]}"; do
          local outf="${outdir}/${base}-${s}.png"
          rsvg-convert -w "$s" -h "$s" "$input" -o "$outf"
          info "Converted: $outf"
        done
      else
        die "No image converter found. Install ImageMagick or librsvg."
      fi
      ;;
    ico)
      if command -v convert &>/dev/null; then
        local ico_args=()
        for s in "${sizes[@]}"; do
          ico_args+=( "(" -clone 0 -resize "${s}x${s}" ")" )
        done
        local outf="${outdir}/${base}.ico"
        convert -background none "$input" "${ico_args[@]}" -delete 0 "$outf"
        info "Converted: $outf"
      else
        die "ImageMagick required for ICO conversion"
      fi
      ;;
    svg)
      if [[ "$input" == *.svg ]]; then
        info "Input is already SVG: $input"
      else
        die "Cannot convert raster to SVG without a tracer (try potrace)"
      fi
      ;;
    *)
      die "Unknown format: $format (expected png|ico|svg)"
      ;;
  esac
}

cmd_search() {
  local query="" style=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --query) query="$2"; shift 2 ;;
      --style) style="$2"; shift 2 ;;
      *) die "Unknown option: $1" ;;
    esac
  done
  [[ -n "$query" ]] || die "Missing --query keyword"

  local matches=()
  for name in "${ICON_NAMES[@]}"; do
    if [[ "$name" == *"$query"* ]]; then
      matches+=("$name")
    fi
  done

  if [[ ${#matches[@]} -eq 0 ]]; then
    echo "No icons matching \"$query\""
  else
    echo "Found ${#matches[@]} icon(s) matching \"$query\":"
    for m in "${matches[@]}"; do
      echo "  • $m"
    done
  fi
}

cmd_resize() {
  local input="" sizes_str="" output="."
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --input)  input="$2";      shift 2 ;;
      --sizes)  sizes_str="$2";  shift 2 ;;
      --output) output="$2";     shift 2 ;;
      *) die "Unknown option: $1" ;;
    esac
  done
  [[ -n "$input" ]]     || die "Missing --input"
  [[ -n "$sizes_str" ]] || die "Missing --sizes"
  ensure_dir "$output"

  IFS=',' read -ra sizes <<< "$sizes_str"

  local files=()
  if [[ -d "$input" ]]; then
    while IFS= read -r -d '' f; do
      files+=("$f")
    done < <(find "$input" -maxdepth 1 \( -name '*.svg' -o -name '*.png' \) -print0 | sort -z)
  elif [[ -f "$input" ]]; then
    files+=("$input")
  else
    die "Input not found: $input"
  fi

  [[ ${#files[@]} -gt 0 ]] || die "No icon files found"

  local count=0
  for f in "${files[@]}"; do
    local base ext
    base="$(basename "$f")"
    ext="${base##*.}"
    base="${base%.*}"
    for s in "${sizes[@]}"; do
      if [[ "$ext" == "svg" ]]; then
        # For SVG, update width/height attributes
        local outf="${output}/${base}-${s}.svg"
        sed -E "s/width=\"[^\"]*\"/width=\"${s}\"/; s/height=\"[^\"]*\"/height=\"${s}\"/" "$f" > "$outf"
        (( count++ ))
      elif command -v convert &>/dev/null; then
        local outf="${output}/${base}-${s}.png"
        convert "$f" -resize "${s}x${s}" "$outf"
        (( count++ ))
      else
        die "ImageMagick needed for PNG resize"
      fi
    done
  done
  info "Resized ${count} file(s) to ${output}/"
}

cmd_favicon() {
  local input="" output="."
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --input)  input="$2";  shift 2 ;;
      --output) output="$2"; shift 2 ;;
      *) die "Unknown option: $1" ;;
    esac
  done
  [[ -n "$input" ]] || die "Missing --input source file"
  [[ -f "$input" ]] || die "File not found: $input"
  ensure_dir "$output"

  local favicon_sizes=(16 32 48 180 192 512)
  local ext="${input##*.}"

  # Generate PNGs at each size
  for s in "${favicon_sizes[@]}"; do
    local outf="${output}/favicon-${s}x${s}.png"
    if [[ "$ext" == "svg" ]] && command -v rsvg-convert &>/dev/null; then
      rsvg-convert -w "$s" -h "$s" "$input" -o "$outf"
    elif command -v convert &>/dev/null; then
      convert -background none -resize "${s}x${s}" "$input" "$outf"
    else
      # Fallback: copy SVG as reference
      cp "$input" "${output}/favicon-${s}x${s}.svg"
      info "Warning: no converter available, copied source for ${s}x${s}"
      continue
    fi
    info "Created favicon-${s}x${s}.png"
  done

  # Generate ICO from 16+32+48
  if command -v convert &>/dev/null; then
    local ico_inputs=()
    for s in 16 32 48; do
      local pf="${output}/favicon-${s}x${s}.png"
      [[ -f "$pf" ]] && ico_inputs+=("$pf")
    done
    if [[ ${#ico_inputs[@]} -gt 0 ]]; then
      convert "${ico_inputs[@]}" "${output}/favicon.ico"
      info "Created favicon.ico"
    fi
  fi

  # Apple touch icon
  if [[ -f "${output}/favicon-180x180.png" ]]; then
    cp "${output}/favicon-180x180.png" "${output}/apple-touch-icon.png"
    info "Created apple-touch-icon.png"
  fi

  # Web manifest
  cat > "${output}/site.webmanifest" <<MANIFEST
{
  "name": "",
  "short_name": "",
  "icons": [
    { "src": "favicon-192x192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "favicon-512x512.png", "sizes": "512x512", "type": "image/png" }
  ],
  "theme_color": "#ffffff",
  "background_color": "#ffffff",
  "display": "standalone"
}
MANIFEST
  info "Created site.webmanifest"

  # HTML snippet
  cat > "${output}/favicon-head.html" <<HTML
<link rel="icon" type="image/x-icon" href="favicon.ico">
<link rel="icon" type="image/png" sizes="32x32" href="favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="favicon-16x16.png">
<link rel="apple-touch-icon" sizes="180x180" href="apple-touch-icon.png">
<link rel="manifest" href="site.webmanifest">
HTML
  info "Created favicon-head.html (paste into <head>)"
  info "Favicon set complete in ${output}/"
}

# ─── Main dispatcher ───────────────────────────────────────────────────────

main() {
  local cmd="${1:-help}"
  shift || true

  case "$cmd" in
    generate) cmd_generate "$@" ;;
    sprite)   cmd_sprite "$@" ;;
    convert)  cmd_convert "$@" ;;
    search)   cmd_search "$@" ;;
    resize)   cmd_resize "$@" ;;
    favicon)  cmd_favicon "$@" ;;
    help|--help|-h) cmd_help ;;
    *) die "Unknown command: $cmd. Run with 'help' for usage." ;;
  esac
}

main "$@"
