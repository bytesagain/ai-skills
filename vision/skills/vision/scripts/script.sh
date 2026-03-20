#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# vision - Image Processing Toolkit
# Version: 3.0.0
# Author: BytesAgain
#
# Commands: resize, crop, convert, optimize, info, watermark
# Requires: ImageMagick (convert/identify/mogrify commands)
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JSON_OUTPUT=false

# ---------------------------------------------------------------------------
# Utilities
# ---------------------------------------------------------------------------

die() { echo "ERROR: $*" >&2; exit 1; }

log() { echo "[vision] $*" >&2; }

check_imagemagick() {
  if ! command -v convert &>/dev/null && ! command -v magick &>/dev/null; then
    die "ImageMagick is required but not installed. Install with: apt install imagemagick / brew install imagemagick"
  fi
}

# Wrapper to handle both ImageMagick 6 (convert) and 7 (magick)
im_convert() {
  if command -v magick &>/dev/null; then
    magick "$@"
  else
    convert "$@"
  fi
}

im_identify() {
  if command -v magick &>/dev/null; then
    magick identify "$@"
  else
    identify "$@"
  fi
}

parse_global_flags() {
  local args=()
  for arg in "$@"; do
    if [[ "$arg" == "--json" ]]; then
      JSON_OUTPUT=true
    else
      args+=("$arg")
    fi
  done
  REMAINING_ARGS=("${args[@]+"${args[@]}"}")
}

get_extension() {
  local filename="$1"
  echo "${filename##*.}" | tr '[:upper:]' '[:lower:]'
}

get_basename() {
  local filename="$1"
  local base
  base=$(basename "$filename")
  echo "${base%.*}"
}

get_dirname() {
  dirname "$1"
}

auto_output_name() {
  local input="$1"
  local suffix="$2"
  local ext="${3:-$(get_extension "$input")}"
  local dir
  dir=$(get_dirname "$input")
  local base
  base=$(get_basename "$input")
  echo "${dir}/${base}_${suffix}.${ext}"
}

validate_input() {
  local input="$1"
  [[ -n "$input" ]] || die "No input file specified. Use --input"
  [[ -f "$input" ]] || die "File not found: $input"
}

# ---------------------------------------------------------------------------
# cmd_help - List all commands
# ---------------------------------------------------------------------------

cmd_help() {
  cat <<'EOF'
vision - Image Processing Toolkit

Usage: bash script.sh <command> [options]

Commands:
  resize      Resize image to dimensions or percentage
  crop        Crop image to a region
  convert     Convert between png, jpg, webp formats
  optimize    Compress image to reduce file size
  info        Read EXIF and image metadata
  watermark   Add text watermark to image
  help        Show this help message

Common options:
  --input     Input image file (required for all commands)
  --output    Output file path (auto-generated if omitted)
  --json      JSON output for info command

Requires: ImageMagick (apt install imagemagick)

Examples:
  bash script.sh resize --input photo.jpg --width 800
  bash script.sh convert --input photo.png --to webp
  bash script.sh info --input photo.jpg --json
EOF
}

# ---------------------------------------------------------------------------
# cmd_resize - Resize image
# ---------------------------------------------------------------------------

cmd_resize() {
  check_imagemagick

  local input="" output="" width="" height="" percent=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --input)   shift; input="$1" ;;
      --output)  shift; output="$1" ;;
      --width)   shift; width="$1" ;;
      --height)  shift; height="$1" ;;
      --percent) shift; percent="$1" ;;
      *) die "Unknown option for resize: $1" ;;
    esac
    shift
  done

  validate_input "$input"

  [[ -n "$output" ]] || output=$(auto_output_name "$input" "resized")

  local geometry=""
  if [[ -n "$percent" ]]; then
    geometry="${percent}%"
  elif [[ -n "$width" && -n "$height" ]]; then
    geometry="${width}x${height}!"
  elif [[ -n "$width" ]]; then
    geometry="${width}x"
  elif [[ -n "$height" ]]; then
    geometry="x${height}"
  else
    die "resize requires --width, --height, or --percent"
  fi

  im_convert "$input" -resize "$geometry" "$output"

  # Report results
  local orig_size new_size
  orig_size=$(stat -c%s "$input" 2>/dev/null || stat -f%z "$input")
  new_size=$(stat -c%s "$output" 2>/dev/null || stat -f%z "$output")

  local orig_dims new_dims
  orig_dims=$(im_identify -format "%wx%h" "$input")
  new_dims=$(im_identify -format "%wx%h" "$output")

  echo "Resized: $input → $output"
  echo "  Original:  ${orig_dims} ($(( orig_size / 1024 )) KB)"
  echo "  Resized:   ${new_dims} ($(( new_size / 1024 )) KB)"
}

# ---------------------------------------------------------------------------
# cmd_crop - Crop image
# ---------------------------------------------------------------------------

cmd_crop() {
  check_imagemagick

  local input="" output="" width="" height="" x="0" y="0" gravity=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --input)   shift; input="$1" ;;
      --output)  shift; output="$1" ;;
      --width)   shift; width="$1" ;;
      --height)  shift; height="$1" ;;
      --x)       shift; x="$1" ;;
      --y)       shift; y="$1" ;;
      --gravity) shift; gravity="$1" ;;
      *) die "Unknown option for crop: $1" ;;
    esac
    shift
  done

  validate_input "$input"
  [[ -n "$width" ]]  || die "crop requires --width"
  [[ -n "$height" ]] || die "crop requires --height"
  [[ -n "$output" ]] || output=$(auto_output_name "$input" "cropped")

  if [[ -n "$gravity" ]]; then
    im_convert "$input" -gravity "$gravity" -crop "${width}x${height}+0+0" +repage "$output"
  else
    im_convert "$input" -crop "${width}x${height}+${x}+${y}" +repage "$output"
  fi

  local new_dims
  new_dims=$(im_identify -format "%wx%h" "$output")

  echo "Cropped: $input → $output"
  echo "  Region: ${width}x${height}+${x}+${y}"
  echo "  Result: ${new_dims}"
}

# ---------------------------------------------------------------------------
# cmd_convert - Format conversion
# ---------------------------------------------------------------------------

cmd_convert() {
  check_imagemagick

  local input="" output="" to="" quality=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --input)   shift; input="$1" ;;
      --output)  shift; output="$1" ;;
      --to)      shift; to="$1" ;;
      --quality) shift; quality="$1" ;;
      *) die "Unknown option for convert: $1" ;;
    esac
    shift
  done

  validate_input "$input"
  [[ -n "$to" ]] || die "convert requires --to (png, jpg, webp)"

  # Normalize format name
  case "$to" in
    jpeg) to="jpg" ;;
  esac

  [[ "$to" =~ ^(png|jpg|webp)$ ]] || die "Supported formats: png, jpg, webp"

  if [[ -z "$output" ]]; then
    local dir base
    dir=$(get_dirname "$input")
    base=$(get_basename "$input")
    output="${dir}/${base}.${to}"
  fi

  local cmd_args=("$input")
  [[ -n "$quality" ]] && cmd_args+=(-quality "$quality")
  cmd_args+=("$output")

  im_convert "${cmd_args[@]}"

  local orig_size new_size
  orig_size=$(stat -c%s "$input" 2>/dev/null || stat -f%z "$input")
  new_size=$(stat -c%s "$output" 2>/dev/null || stat -f%z "$output")
  local orig_ext
  orig_ext=$(get_extension "$input")

  echo "Converted: $input ($orig_ext) → $output ($to)"
  echo "  Original: $(( orig_size / 1024 )) KB"
  echo "  Output:   $(( new_size / 1024 )) KB"

  local ratio
  ratio=$(awk "BEGIN {printf \"%.1f\", $new_size * 100 / $orig_size}")
  echo "  Size:     ${ratio}% of original"
}

# ---------------------------------------------------------------------------
# cmd_optimize - Compress image
# ---------------------------------------------------------------------------

cmd_optimize() {
  check_imagemagick

  local input="" output="" quality="85"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --input)   shift; input="$1" ;;
      --output)  shift; output="$1" ;;
      --quality) shift; quality="$1" ;;
      *) die "Unknown option for optimize: $1" ;;
    esac
    shift
  done

  validate_input "$input"
  [[ -n "$output" ]] || output=$(auto_output_name "$input" "optimized")

  local ext
  ext=$(get_extension "$input")

  local orig_size
  orig_size=$(stat -c%s "$input" 2>/dev/null || stat -f%z "$input")

  case "$ext" in
    jpg|jpeg)
      im_convert "$input" -quality "$quality" -sampling-factor 4:2:0 -strip \
        -interlace JPEG "$output"
      ;;
    png)
      im_convert "$input" -quality "$quality" -strip -define png:compression-level=9 "$output"
      ;;
    webp)
      im_convert "$input" -quality "$quality" -define webp:method=6 "$output"
      ;;
    *)
      im_convert "$input" -quality "$quality" -strip "$output"
      ;;
  esac

  local new_size
  new_size=$(stat -c%s "$output" 2>/dev/null || stat -f%z "$output")

  local saved=$((orig_size - new_size))
  local ratio
  ratio=$(awk "BEGIN {printf \"%.1f\", $new_size * 100 / $orig_size}")

  echo "Optimized: $input → $output"
  echo "  Original: $(( orig_size / 1024 )) KB"
  echo "  Output:   $(( new_size / 1024 )) KB"
  echo "  Saved:    $(( saved / 1024 )) KB (${ratio}% of original)"
  echo "  Quality:  $quality"
}

# ---------------------------------------------------------------------------
# cmd_info - Read EXIF and metadata
# ---------------------------------------------------------------------------

cmd_info() {
  check_imagemagick

  local input=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --input) shift; input="$1" ;;
      *) die "Unknown option for info: $1" ;;
    esac
    shift
  done

  validate_input "$input"

  local format width height colorspace depth filesize
  format=$(im_identify -format "%m" "$input" 2>/dev/null | head -1)
  width=$(im_identify -format "%w" "$input" 2>/dev/null | head -1)
  height=$(im_identify -format "%h" "$input" 2>/dev/null | head -1)
  colorspace=$(im_identify -format "%[colorspace]" "$input" 2>/dev/null | head -1)
  depth=$(im_identify -format "%z" "$input" 2>/dev/null | head -1)
  filesize=$(stat -c%s "$input" 2>/dev/null || stat -f%z "$input")

  # Try to get EXIF data
  local exif_make="" exif_model="" exif_date="" exif_exposure="" exif_iso="" exif_focal=""
  if command -v exiftool &>/dev/null; then
    exif_make=$(exiftool -Make -s3 "$input" 2>/dev/null || true)
    exif_model=$(exiftool -Model -s3 "$input" 2>/dev/null || true)
    exif_date=$(exiftool -DateTimeOriginal -s3 "$input" 2>/dev/null || true)
    exif_exposure=$(exiftool -ExposureTime -s3 "$input" 2>/dev/null || true)
    exif_iso=$(exiftool -ISO -s3 "$input" 2>/dev/null || true)
    exif_focal=$(exiftool -FocalLength -s3 "$input" 2>/dev/null || true)
  else
    # Fallback: try ImageMagick verbose output
    local verbose
    verbose=$(im_identify -verbose "$input" 2>/dev/null || true)
    exif_make=$(echo "$verbose" | grep -i "exif:Make:" | head -1 | sed 's/.*: *//' || true)
    exif_model=$(echo "$verbose" | grep -i "exif:Model:" | head -1 | sed 's/.*: *//' || true)
    exif_date=$(echo "$verbose" | grep -i "exif:DateTimeOriginal:" | head -1 | sed 's/.*: *//' || true)
    exif_exposure=$(echo "$verbose" | grep -i "exif:ExposureTime:" | head -1 | sed 's/.*: *//' || true)
    exif_iso=$(echo "$verbose" | grep -i "exif:ISOSpeedRatings:" | head -1 | sed 's/.*: *//' || true)
    exif_focal=$(echo "$verbose" | grep -i "exif:FocalLength:" | head -1 | sed 's/.*: *//' || true)
  fi

  local filesize_kb=$(( filesize / 1024 ))
  local filesize_mb=""
  [[ $filesize -gt 1048576 ]] && filesize_mb=" ($(awk "BEGIN {printf \"%.1f\", $filesize / 1048576}") MB)"

  if [[ "$JSON_OUTPUT" == true ]]; then
    printf '{'
    printf '"file":"%s",' "$(basename "$input")"
    printf '"format":"%s",' "$format"
    printf '"width":%s,' "$width"
    printf '"height":%s,' "$height"
    printf '"colorspace":"%s",' "$colorspace"
    printf '"depth":%s,' "$depth"
    printf '"filesize":%s,' "$filesize"
    printf '"filesize_kb":%s,' "$filesize_kb"
    printf '"exif":{'
    printf '"make":"%s",' "${exif_make:-}"
    printf '"model":"%s",' "${exif_model:-}"
    printf '"date":"%s",' "${exif_date:-}"
    printf '"exposure":"%s",' "${exif_exposure:-}"
    printf '"iso":"%s",' "${exif_iso:-}"
    printf '"focal_length":"%s"' "${exif_focal:-}"
    printf '}}\n'
  else
    echo "=== Image Info ==="
    echo ""
    echo "File:         $(basename "$input")"
    echo "Format:       $format"
    echo "Dimensions:   ${width}x${height}"
    echo "Color space:  $colorspace"
    echo "Bit depth:    $depth"
    echo "File size:    ${filesize_kb} KB${filesize_mb}"
    echo ""

    if [[ -n "$exif_make" || -n "$exif_model" || -n "$exif_date" ]]; then
      echo "EXIF Data:"
      [[ -n "$exif_make" ]]     && echo "  Camera make:    $exif_make"
      [[ -n "$exif_model" ]]    && echo "  Camera model:   $exif_model"
      [[ -n "$exif_date" ]]     && echo "  Date taken:     $exif_date"
      [[ -n "$exif_exposure" ]] && echo "  Exposure:       $exif_exposure"
      [[ -n "$exif_iso" ]]      && echo "  ISO:            $exif_iso"
      [[ -n "$exif_focal" ]]    && echo "  Focal length:   $exif_focal"
    else
      echo "EXIF Data:    (none found)"
    fi
  fi
}

# ---------------------------------------------------------------------------
# cmd_watermark - Add text watermark
# ---------------------------------------------------------------------------

cmd_watermark() {
  check_imagemagick

  local input="" output="" text="" position="southeast" opacity="50" size="24" color="white"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --input)    shift; input="$1" ;;
      --output)   shift; output="$1" ;;
      --text)     shift; text="$1" ;;
      --position) shift; position="$1" ;;
      --opacity)  shift; opacity="$1" ;;
      --size)     shift; size="$1" ;;
      --color)    shift; color="$1" ;;
      *) die "Unknown option for watermark: $1" ;;
    esac
    shift
  done

  validate_input "$input"
  [[ -n "$text" ]] || die "watermark requires --text"
  [[ -n "$output" ]] || output=$(auto_output_name "$input" "watermarked")

  # Map position to ImageMagick gravity
  local gravity
  case "$position" in
    northwest|nw) gravity="NorthWest" ;;
    north|n)      gravity="North" ;;
    northeast|ne) gravity="NorthEast" ;;
    west|w)       gravity="West" ;;
    center|c)     gravity="Center" ;;
    east|e)       gravity="East" ;;
    southwest|sw) gravity="SouthWest" ;;
    south|s)      gravity="South" ;;
    southeast|se) gravity="SouthEast" ;;
    *)            gravity="SouthEast" ;;
  esac

  # Calculate dissolve value (ImageMagick uses 0-100)
  local dissolve="$opacity"

  im_convert "$input" \
    \( -size "$(im_identify -format '%w' "$input")x$(im_identify -format '%h' "$input")" xc:none \
       -gravity "$gravity" \
       -fill "$color" \
       -pointsize "$size" \
       -annotate +10+10 "$text" \) \
    -gravity "$gravity" \
    -compose dissolve -define "compose:args=${dissolve}" \
    -composite "$output"

  echo "Watermark added: $input → $output"
  echo "  Text:     \"$text\""
  echo "  Position: $position ($gravity)"
  echo "  Opacity:  ${opacity}%"
  echo "  Size:     ${size}pt"
  echo "  Color:    $color"
}

# ---------------------------------------------------------------------------
# Main dispatch
# ---------------------------------------------------------------------------

main() {
  [[ $# -ge 1 ]] || { cmd_help; exit 0; }

  local command="$1"
  shift

  parse_global_flags "$@"
  set -- "${REMAINING_ARGS[@]+"${REMAINING_ARGS[@]}"}"

  case "$command" in
    resize)    cmd_resize "$@" ;;
    crop)      cmd_crop "$@" ;;
    convert)   cmd_convert "$@" ;;
    optimize)  cmd_optimize "$@" ;;
    info)      cmd_info "$@" ;;
    watermark) cmd_watermark "$@" ;;
    help)      cmd_help ;;
    *)         die "Unknown command: $command. Run 'help' for usage." ;;
  esac
}

main "$@"
