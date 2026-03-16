#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════╗
# ║  Video Toolbox — Complete Video Processing Toolkit      ║
# ║  Powered by BytesAgain | bytesagain.com                 ║
# ║  hello@bytesagain.com                                   ║
# ╚══════════════════════════════════════════════════════════╝
# Usage: bash main.sh <command> [options]
set -euo pipefail

CMD="${1:-help}"
if [ $# -gt 0 ]; then
    shift
fi

# ──── Helpers ────
require_ffmpeg() {
    command -v ffmpeg >/dev/null 2>&1 || { echo "Error: ffmpeg is required. Install: apt install ffmpeg / brew install ffmpeg"; exit 1; }
}

require_input() {
    [ -n "${INPUT:-}" ] || { echo "Error: --input <file> is required"; exit 1; }
    [ -f "$INPUT" ] || { echo "Error: File not found: $INPUT"; exit 1; }
}

parse_args() {
    INPUT="" OUTPUT="" START="" END="" DURATION="" WIDTH="" HEIGHT=""
    FPS="" COUNT="" QUALITY="medium" FORMAT="" TEXT="" SPEED="" ANGLE=""
    POSITION="" FONTSIZE="" COLOR="" OPACITY="" SCALE="" CODEC="" JSON_OUTPUT=""
    SET_META="" CLEAR_META="" TIME=""
    while [ $# -gt 0 ]; do
        case "$1" in
            --input|-i) INPUT="$2"; shift 2;;
            --output|-o) OUTPUT="$2"; shift 2;;
            --start|-s) START="$2"; shift 2;;
            --end|-e) END="$2"; shift 2;;
            --duration|-d) DURATION="$2"; shift 2;;
            --width|-w) WIDTH="$2"; shift 2;;
            --height|-h) HEIGHT="$2"; shift 2;;
            --fps) FPS="$2"; shift 2;;
            --count) COUNT="$2"; shift 2;;
            --quality|-q) QUALITY="$2"; shift 2;;
            --format|-f) FORMAT="$2"; shift 2;;
            --text|-t) TEXT="$2"; shift 2;;
            --speed) SPEED="$2"; shift 2;;
            --angle) ANGLE="$2"; shift 2;;
            --position) POSITION="$2"; shift 2;;
            --fontsize) FONTSIZE="$2"; shift 2;;
            --color) COLOR="$2"; shift 2;;
            --opacity) OPACITY="$2"; shift 2;;
            --scale) SCALE="$2"; shift 2;;
            --codec) CODEC="$2"; shift 2;;
            --json) JSON_OUTPUT="1"; shift;;
            --set) SET_META="$2"; shift 2;;
            --clear) CLEAR_META="1"; shift;;
            --time) TIME="$2"; shift 2;;
            *) echo "Warning: unknown option '$1', ignoring" >&2; shift;;
        esac
    done
}

auto_output() {
    local input="$1" suffix="$2"
    local base="${input%.*}"
    local ext="${input##*.}"
    echo "${base}${suffix}.${ext}"
}

show_help() {
    cat << 'HELPEOF'
╔══════════════════════════════════════════════════════════╗
║  Video Toolbox — Complete Video Processing Toolkit      ║
║  Powered by BytesAgain | bytesagain.com                 ║
╚══════════════════════════════════════════════════════════╝

Usage: bash main.sh <command> [options]

Commands:
  info             Show video information (resolution, duration, codec, bitrate)
  trim             Cut a segment (--start, --end or --duration)
  resize           Change resolution (--width, --height, or --scale)
  convert          Format conversion (--format mp4/webm/avi/mov/mkv, --codec)
  extract-frames   Extract frames as images (--fps or --count, --format jpg/png)
  extract-audio    Extract audio track (--format mp3/wav/aac/flac)
  compress         Reduce file size (--quality low/medium/high)
  thumbnail        Generate thumbnail (--time, --count, --width)
  gif              Convert to animated GIF (--start, --duration, --fps)
  merge            Merge multiple videos (--input file1 --input file2 ...)
  watermark        Add text watermark (--text, --position, --fontsize, --color, --opacity)
  speed            Change playback speed (--speed 0.25-4.0, chain atempo)
  rotate           Rotate video (--angle 90/180/270)
  metadata         Show/edit metadata (--set key=value, --clear)

Common Options:
  --input, -i      Input file (required for most commands)
  --output, -o     Output file (auto-generated if not specified)
  --start, -s      Start time (HH:MM:SS or seconds)
  --end, -e        End time
  --duration, -d   Duration
  --quality, -q    Quality preset: low, medium, high (compress only)

Examples:
  bash main.sh info --input video.mp4
  bash main.sh info --input video.mp4 --json
  bash main.sh trim --input video.mp4 --start 00:01:00 --end 00:02:30
  bash main.sh resize --input video.mp4 --width 1280 --height 720
  bash main.sh resize --input video.mp4 --scale 0.5
  bash main.sh compress --input video.mp4 --quality medium
  bash main.sh gif --input video.mp4 --start 00:00:10 --duration 5 --fps 15
  bash main.sh extract-frames --input video.mp4 --fps 1 --format jpg
  bash main.sh watermark --input video.mp4 --text "BytesAgain" --position bottom-right
  bash main.sh speed --input video.mp4 --speed 2.0
  bash main.sh merge --input part1.mp4 --input part2.mp4 --input part3.mp4 -o full.mp4
  bash main.sh metadata --input video.mp4 --set "title=My Video"
  bash main.sh convert --input video.mp4 --format webm --codec libvpx-vp9
  bash main.sh thumbnail --input video.mp4 --time 00:00:30 --width 640
  bash main.sh thumbnail --input video.mp4 --count 5

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
}

# ──── Commands ────

cmd_info() {
    parse_args "$@"
    require_ffmpeg
    require_input

    if [ -n "$JSON_OUTPUT" ]; then
        ffprobe -v quiet -print_format json -show_format -show_streams "$INPUT" 2>/dev/null
        return
    fi

    echo "═══════════════════════════════════════"
    echo "  Video Info: $(basename "$INPUT")"
    echo "═══════════════════════════════════════"
    ffprobe -v quiet -print_format json -show_format -show_streams "$INPUT" 2>/dev/null | python3 << 'PYEOF'
import json, sys
data = json.load(sys.stdin)
fmt = data.get("format", {})
streams = data.get("streams", [])

print("")
print("  File:       {}".format(fmt.get("filename", "?").split("/")[-1]))
size_mb = int(fmt.get("size", 0)) / 1048576
print("  Size:       {:.1f} MB".format(size_mb))
duration = float(fmt.get("duration", 0))
mins = int(duration // 60)
secs = int(duration % 60)
print("  Duration:   {}:{:02d} ({:.1f}s)".format(mins, secs, duration))
bitrate = int(fmt.get("bit_rate", 0)) / 1000
print("  Bitrate:    {:.0f} kbps".format(bitrate))
print("  Format:     {}".format(fmt.get("format_long_name", "?")))
print("")

for s in streams:
    codec_type = s.get("codec_type", "?")
    if codec_type == "video":
        print("  🎬 Video Stream:")
        print("     Codec:      {}".format(s.get("codec_long_name", s.get("codec_name", "?"))))
        print("     Resolution: {}x{}".format(s.get("width", "?"), s.get("height", "?")))
        fps = s.get("r_frame_rate", "0/1")
        if "/" in str(fps):
            parts = str(fps).split("/")
            try: fps_val = int(parts[0]) / int(parts[1])
            except: fps_val = 0
        else:
            fps_val = float(fps)
        print("     FPS:        {:.2f}".format(fps_val))
        print("     Pixel Fmt:  {}".format(s.get("pix_fmt", "?")))
    elif codec_type == "audio":
        print("  🔊 Audio Stream:")
        print("     Codec:      {}".format(s.get("codec_long_name", s.get("codec_name", "?"))))
        print("     Channels:   {}".format(s.get("channels", "?")))
        print("     Sample Rate: {} Hz".format(s.get("sample_rate", "?")))
        abr = int(s.get("bit_rate", 0)) / 1000
        if abr > 0: print("     Bitrate:    {:.0f} kbps".format(abr))
print("")
PYEOF
}

cmd_trim() {
    parse_args "$@"
    require_ffmpeg
    require_input
    [ -z "$START" ] && { echo "Error: --start required"; exit 1; }
    [ -z "$OUTPUT" ] && OUTPUT=$(auto_output "$INPUT" "_trimmed")
    
    local args=(-ss "$START")
    [ -n "$END" ] && args+=(-to "$END")
    [ -n "$DURATION" ] && args+=(-t "$DURATION")
    
    echo "Trimming: $INPUT → $OUTPUT"
    ffmpeg -y -i "$INPUT" "${args[@]}" -c copy "$OUTPUT" 2>/dev/null
    echo "✅ Done: $OUTPUT ($(du -h "$OUTPUT" 2>/dev/null | cut -f1))"
}

cmd_resize() {
    parse_args "$@"
    require_ffmpeg
    require_input
    
    # Support --scale as alternative to --width/--height
    if [ -n "$SCALE" ]; then
        [ -z "$OUTPUT" ] && OUTPUT=$(auto_output "$INPUT" "_resized")
        echo "Resizing: $INPUT → scale ${SCALE}x"
        ffmpeg -y -i "$INPUT" -vf "scale=iw*${SCALE}:ih*${SCALE}" -c:a copy "$OUTPUT" 2>/dev/null
        echo "✅ Done: $OUTPUT"
        return
    fi
    
    [ -z "$WIDTH" ] && [ -z "$HEIGHT" ] && { echo "Error: --width and/or --height (or --scale) required"; exit 1; }
    [ -z "$OUTPUT" ] && OUTPUT=$(auto_output "$INPUT" "_resized")
    
    local scale=""
    if [ -n "$WIDTH" ] && [ -n "$HEIGHT" ]; then
        scale="${WIDTH}:${HEIGHT}"
    elif [ -n "$WIDTH" ]; then
        scale="${WIDTH}:-2"
    else
        scale="-2:${HEIGHT}"
    fi
    
    echo "Resizing: $INPUT → ${scale}"
    ffmpeg -y -i "$INPUT" -vf "scale=$scale" -c:a copy "$OUTPUT" 2>/dev/null
    echo "✅ Done: $OUTPUT"
}

cmd_convert() {
    parse_args "$@"
    require_ffmpeg
    require_input
    [ -z "$FORMAT" ] && { echo "Error: --format required (mp4/webm/avi/mov/mkv)"; exit 1; }
    local base="${INPUT%.*}"
    [ -z "$OUTPUT" ] && OUTPUT="${base}.${FORMAT}"
    
    local codec_args=()
    if [ -n "$CODEC" ]; then
        codec_args+=(-c:v "$CODEC")
    fi
    
    echo "Converting: $INPUT → $FORMAT${CODEC:+ (codec: $CODEC)}"
    ffmpeg -y -i "$INPUT" "${codec_args[@]}" "$OUTPUT" 2>/dev/null
    echo "✅ Done: $OUTPUT ($(du -h "$OUTPUT" 2>/dev/null | cut -f1))"
}

cmd_extract_frames() {
    parse_args "$@"
    require_ffmpeg
    require_input
    
    local outdir="${OUTPUT:-frames_$(date +%s)}"
    local img_format="${FORMAT:-png}"
    mkdir -p "$outdir"
    
    if [ -n "$FPS" ]; then
        echo "Extracting frames at ${FPS} fps (${img_format})..."
        ffmpeg -y -i "$INPUT" -vf "fps=$FPS" "$outdir/frame_%04d.${img_format}" 2>/dev/null
    elif [ -n "$COUNT" ]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$INPUT" 2>/dev/null)
        interval=$(python3 -c "print('{:.4f}'.format(float('$duration') / int('$COUNT')))")
        echo "Extracting $COUNT frames (every ${interval}s, ${img_format})..."
        ffmpeg -y -i "$INPUT" -vf "fps=1/$interval" "$outdir/frame_%04d.${img_format}" 2>/dev/null
    else
        echo "Extracting at 1 fps (use --fps or --count to customize)..."
        ffmpeg -y -i "$INPUT" -vf "fps=1" "$outdir/frame_%04d.${img_format}" 2>/dev/null
    fi
    
    count=$(ls "$outdir"/*."${img_format}" 2>/dev/null | wc -l)
    echo "✅ Extracted $count frames → $outdir/"
}

cmd_extract_audio() {
    parse_args "$@"
    require_ffmpeg
    require_input
    local fmt="${FORMAT:-mp3}"
    local base="${INPUT%.*}"
    [ -z "$OUTPUT" ] && OUTPUT="${base}.${fmt}"
    
    local codec_args=""
    case "$fmt" in
        mp3) codec_args="-codec:a libmp3lame -q:a 2";;
        wav) codec_args="-codec:a pcm_s16le";;
        aac) codec_args="-codec:a aac -b:a 192k";;
        flac) codec_args="-codec:a flac";;
        *) codec_args="";;
    esac
    
    echo "Extracting audio ($fmt): $INPUT → $OUTPUT"
    ffmpeg -y -i "$INPUT" -vn $codec_args "$OUTPUT" 2>/dev/null
    echo "✅ Done: $OUTPUT ($(du -h "$OUTPUT" 2>/dev/null | cut -f1))"
}

cmd_compress() {
    parse_args "$@"
    require_ffmpeg
    require_input
    [ -z "$OUTPUT" ] && OUTPUT=$(auto_output "$INPUT" "_compressed")
    
    local crf
    case "$QUALITY" in
        low) crf=32; echo "Compressing (low quality, smallest size)...";;
        medium) crf=26; echo "Compressing (balanced quality/size)...";;
        high) crf=20; echo "Compressing (high quality, larger size)...";;
        *) crf=26; echo "Compressing (medium)...";;
    esac
    
    local orig_size=$(du -b "$INPUT" 2>/dev/null | cut -f1)
    ffmpeg -y -i "$INPUT" -c:v libx264 -crf "$crf" -preset medium -c:a aac -b:a 128k "$OUTPUT" 2>/dev/null
    local new_size=$(du -b "$OUTPUT" 2>/dev/null | cut -f1)
    
    if [ -n "$orig_size" ] && [ -n "$new_size" ] && [ "$orig_size" -gt 0 ] 2>/dev/null; then
        local pct=$(python3 -c "print('{:.0f}'.format((1 - $new_size/$orig_size) * 100))")
        echo "✅ Done: $OUTPUT"
        echo "   Original: $(du -h "$INPUT" | cut -f1) → Compressed: $(du -h "$OUTPUT" | cut -f1) (${pct}% smaller)"
    else
        echo "✅ Done: $OUTPUT ($(du -h "$OUTPUT" 2>/dev/null | cut -f1))"
    fi
}

cmd_thumbnail() {
    parse_args "$@"
    require_ffmpeg
    require_input
    
    # --count: generate multiple thumbnails
    if [ -n "$COUNT" ] && [ "$COUNT" -gt 1 ] 2>/dev/null; then
        local outdir="${OUTPUT:-thumbnails_$(date +%s)}"
        mkdir -p "$outdir"
        local duration
        duration=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$INPUT" 2>/dev/null)
        echo "Generating $COUNT thumbnails..."
        local scale_filter=""
        [ -n "$WIDTH" ] && scale_filter=",scale=${WIDTH}:-1"
        for idx in $(seq 1 "$COUNT"); do
            local pos
            pos=$(python3 -c "print('{:.2f}'.format(float('${duration:-10}') * $idx / ($COUNT + 1)))")
            ffmpeg -y -ss "$pos" -i "$INPUT" -vframes 1 -q:v 2 -vf "select=1${scale_filter}" "$outdir/thumb_$(printf '%03d' "$idx").jpg" 2>/dev/null
        done
        local generated
        generated=$(ls "$outdir"/thumb_*.jpg 2>/dev/null | wc -l)
        echo "✅ Generated $generated thumbnails → $outdir/"
        return
    fi
    
    local base="${INPUT%.*}"
    [ -z "$OUTPUT" ] && OUTPUT="${base}_thumb.jpg"
    
    # --time: use specified time, otherwise auto-detect at 10%
    local pos
    if [ -n "$TIME" ]; then
        pos="$TIME"
    else
        local duration
        duration=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$INPUT" 2>/dev/null)
        pos=$(python3 -c "print('{:.2f}'.format(float('${duration:-10}') * 0.1))")
    fi
    
    local scale_filter=""
    [ -n "$WIDTH" ] && scale_filter="-vf scale=${WIDTH}:-1"
    
    echo "Generating thumbnail at ${pos}s..."
    ffmpeg -y -ss "$pos" -i "$INPUT" -vframes 1 -q:v 2 $scale_filter "$OUTPUT" 2>/dev/null
    echo "✅ Thumbnail: $OUTPUT"
}

cmd_gif() {
    parse_args "$@"
    require_ffmpeg
    require_input
    [ -z "$OUTPUT" ] && OUTPUT="${INPUT%.*}.gif"
    local gif_fps="${FPS:-10}"
    local gif_start="${START:-0}"
    local gif_dur="${DURATION:-5}"
    
    echo "Creating GIF (start=${gif_start}, duration=${gif_dur}s, fps=${gif_fps})..."
    ffmpeg -y -ss "$gif_start" -t "$gif_dur" -i "$INPUT" \
        -vf "fps=$gif_fps,scale=480:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
        "$OUTPUT" 2>/dev/null
    echo "✅ GIF: $OUTPUT ($(du -h "$OUTPUT" 2>/dev/null | cut -f1))"
}

cmd_merge() {
    require_ffmpeg
    # Collect all --input files
    local files=()
    OUTPUT=""
    while [ $# -gt 0 ]; do
        case "$1" in
            --input|-i) files+=("$2"); shift 2;;
            --output|-o) OUTPUT="$2"; shift 2;;
            *) echo "Warning: unknown option '$1', ignoring" >&2; shift;;
        esac
    done
    
    [ ${#files[@]} -lt 2 ] && { echo "Error: Need at least 2 --input files"; exit 1; }
    [ -z "$OUTPUT" ] && OUTPUT="merged_$(date +%s).mp4"
    
    # Create concat file with trap for cleanup
    local concat_file="/tmp/ffmpeg_concat_$$.txt"
    trap 'rm -f "$concat_file"' EXIT ERR INT TERM
    for f in "${files[@]}"; do
        echo "file '$(realpath "$f")'" >> "$concat_file"
    done
    
    echo "Merging ${#files[@]} videos..."
    ffmpeg -y -f concat -safe 0 -i "$concat_file" -c copy "$OUTPUT" 2>/dev/null
    rm -f "$concat_file"
    trap - EXIT ERR INT TERM
    echo "✅ Merged: $OUTPUT"
}

cmd_watermark() {
    parse_args "$@"
    require_ffmpeg
    require_input
    [ -z "$TEXT" ] && { echo "Error: --text required"; exit 1; }
    [ -z "$OUTPUT" ] && OUTPUT=$(auto_output "$INPUT" "_watermarked")
    
    # Defaults
    local wm_fontsize="${FONTSIZE:-24}"
    local wm_color="${COLOR:-white}"
    local wm_opacity="${OPACITY:-0.7}"
    local wm_position="${POSITION:-bottom-right}"
    
    # Compute x:y from --position
    local x_expr y_expr
    case "$wm_position" in
        top-left)      x_expr="10";                 y_expr="10";;
        top-right)     x_expr="(w-text_w-10)";      y_expr="10";;
        top-center)    x_expr="(w-text_w)/2";        y_expr="10";;
        bottom-left)   x_expr="10";                  y_expr="(h-text_h-10)";;
        bottom-right)  x_expr="(w-text_w-10)";       y_expr="(h-text_h-10)";;
        bottom-center) x_expr="(w-text_w)/2";        y_expr="(h-text_h-10)";;
        center)        x_expr="(w-text_w)/2";        y_expr="(h-text_h)/2";;
        *)             x_expr="(w-text_w-10)";       y_expr="(h-text_h-10)";;  # default bottom-right
    esac
    
    echo "Adding watermark: \"$TEXT\" (position=$wm_position, fontsize=$wm_fontsize, color=$wm_color, opacity=$wm_opacity)..."
    ffmpeg -y -i "$INPUT" \
        -vf "drawtext=text='$TEXT':fontsize=${wm_fontsize}:fontcolor=${wm_color}@${wm_opacity}:x=${x_expr}:y=${y_expr}:shadowcolor=black@0.5:shadowx=1:shadowy=1" \
        -c:a copy "$OUTPUT" 2>/dev/null
    echo "✅ Watermarked: $OUTPUT"
}

cmd_speed() {
    parse_args "$@"
    require_ffmpeg
    require_input
    local spd="${SPEED:-2.0}"
    [ -z "$OUTPUT" ] && OUTPUT=$(auto_output "$INPUT" "_${spd}x")
    
    local video_pts
    video_pts=$(python3 -c "print('{:.4f}'.format(1.0 / float('$spd')))")
    
    # Build chain of atempo filters for values outside 0.5-2.0
    # ffmpeg atempo only supports 0.5 to 100.0 per filter, but for quality
    # we chain in 0.5-2.0 range steps
    local atempo_filter
    atempo_filter=$(python3 << PYEOF
import math
speed = float('$spd')
# atempo is the audio speed factor (same as video speed)
# We need to chain atempo filters, each in range [0.5, 2.0]
factors = []
remaining = speed
if remaining >= 1.0:
    while remaining > 2.0:
        factors.append(2.0)
        remaining /= 2.0
    factors.append(remaining)
else:
    while remaining < 0.5:
        factors.append(0.5)
        remaining /= 0.5
    factors.append(remaining)
print(",".join("atempo={:.4f}".format(f) for f in factors))
PYEOF
)
    
    echo "Changing speed to ${spd}x..."
    ffmpeg -y -i "$INPUT" \
        -filter:v "setpts=${video_pts}*PTS" \
        -filter:a "$atempo_filter" \
        "$OUTPUT" 2>/dev/null
    echo "✅ Speed ${spd}x: $OUTPUT"
}

cmd_rotate() {
    parse_args "$@"
    require_ffmpeg
    require_input
    local ang="${ANGLE:-90}"
    [ -z "$OUTPUT" ] && OUTPUT=$(auto_output "$INPUT" "_rotated${ang}")
    
    local transpose=""
    case "$ang" in
        90) transpose="transpose=1";;
        180) transpose="transpose=1,transpose=1";;
        270) transpose="transpose=2";;
        *) echo "Error: --angle must be 90, 180, or 270"; exit 1;;
    esac
    
    echo "Rotating ${ang}°..."
    ffmpeg -y -i "$INPUT" -vf "$transpose" -c:a copy "$OUTPUT" 2>/dev/null
    echo "✅ Rotated: $OUTPUT"
}

cmd_metadata() {
    parse_args "$@"
    require_ffmpeg
    require_input
    
    # --clear: strip all metadata
    if [ -n "$CLEAR_META" ]; then
        [ -z "$OUTPUT" ] && OUTPUT=$(auto_output "$INPUT" "_cleared")
        echo "Clearing all metadata..."
        ffmpeg -y -i "$INPUT" -map_metadata -1 -c copy "$OUTPUT" 2>/dev/null
        echo "✅ Metadata cleared: $OUTPUT"
        return
    fi
    
    # --set key=value: write metadata
    if [ -n "$SET_META" ]; then
        [ -z "$OUTPUT" ] && OUTPUT=$(auto_output "$INPUT" "_meta")
        local meta_key="${SET_META%%=*}"
        local meta_val="${SET_META#*=}"
        echo "Setting metadata: $meta_key=$meta_val..."
        ffmpeg -y -i "$INPUT" -metadata "$meta_key=$meta_val" -c copy "$OUTPUT" 2>/dev/null
        echo "✅ Metadata set: $OUTPUT"
        return
    fi
    
    # Default: read metadata
    echo "═══════════════════════════════════════"
    echo "  Metadata: $(basename "$INPUT")"
    echo "═══════════════════════════════════════"
    ffprobe -v quiet -show_format "$INPUT" 2>/dev/null | grep -E "^TAG:" | while read line; do
        key="${line#TAG:}"
        echo "  $key"
    done
    echo ""
    echo "  (Use --set key=value to edit, --clear to strip all)"
}

# ──── Main Router ────
case "$CMD" in
    info) cmd_info "$@";;
    trim) cmd_trim "$@";;
    resize) cmd_resize "$@";;
    convert) cmd_convert "$@";;
    extract-frames) cmd_extract_frames "$@";;
    extract-audio) cmd_extract_audio "$@";;
    compress) cmd_compress "$@";;
    thumbnail) cmd_thumbnail "$@";;
    gif) cmd_gif "$@";;
    merge) cmd_merge "$@";;
    watermark) cmd_watermark "$@";;
    speed) cmd_speed "$@";;
    rotate) cmd_rotate "$@";;
    metadata) cmd_metadata "$@";;
    help|--help|-h) show_help;;
    *) echo "Unknown command: $CMD"; echo "Run: bash main.sh help"; exit 1;;
esac
