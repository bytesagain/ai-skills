#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# Video Downloader — video download & info (inspired by iawia002/lux 30K+ stars)
set -euo pipefail
CMD="${1:-help}"
shift 2>/dev/null || true
case "$CMD" in
    help)
        echo "Video Downloader — video info & download helper"
        echo "Commands:"
        echo "  info <url>           Get video metadata"
        echo "  formats <url>        List available formats"
        echo "  download <url>       Download video"
        echo "  audio <url>          Extract audio only"
        echo "  thumbnail <url>      Download thumbnail"
        echo "  playlist <url>       Playlist info"
        echo "  batch <file>         Download from URL list"
        echo "  convert <f> <fmt>    Convert format (ffmpeg)"
        echo "  version              Version info"
        echo "Requires: yt-dlp or youtube-dl"
        echo "Powered by BytesAgain | bytesagain.com";;
    info)
        url="${1:-}"; [ -z "$url" ] && { echo "Usage: info <url>"; exit 1; }
        if command -v yt-dlp >/dev/null 2>&1; then
            yt-dlp --dump-json "$url" 2>/dev/null | python3 -c "
import json, sys
d = json.load(sys.stdin)
print('Title: {}'.format(d.get('title', '?')))
print('Duration: {}s'.format(d.get('duration', '?')))
print('Views: {:,}'.format(d.get('view_count', 0)))
print('Uploader: {}'.format(d.get('uploader', '?')))
print('Upload date: {}'.format(d.get('upload_date', '?')))
print('Resolution: {}'.format(d.get('resolution', '?')))
print('Filesize: {:.1f} MB'.format(d.get('filesize_approx', 0)/1048576))
print('URL: {}'.format(d.get('webpage_url', '?')))
" || echo "Failed to get info"
        elif command -v youtube-dl >/dev/null 2>&1; then
            youtube-dl --dump-json "$url" 2>/dev/null | python3 -c "
import json, sys; d = json.load(sys.stdin)
print('Title: {}'.format(d.get('title','?')))
print('Duration: {}s'.format(d.get('duration','?')))
" || echo "Failed"
        else
            echo "Requires yt-dlp or youtube-dl"
            echo "Install: pip install yt-dlp"
        fi;;
    formats)
        url="${1:-}"; [ -z "$url" ] && { echo "Usage: formats <url>"; exit 1; }
        if command -v yt-dlp >/dev/null 2>&1; then
            yt-dlp -F "$url" 2>/dev/null || echo "Failed"
        else echo "Requires yt-dlp"; fi;;
    download)
        url="${1:-}"; [ -z "$url" ] && { echo "Usage: download <url>"; exit 1; }
        if command -v yt-dlp >/dev/null 2>&1; then
            yt-dlp -f "best[height<=1080]" --no-playlist "$url"
        elif command -v youtube-dl >/dev/null 2>&1; then
            youtube-dl -f best "$url"
        else echo "Requires yt-dlp: pip install yt-dlp"; fi;;
    audio)
        url="${1:-}"; [ -z "$url" ] && { echo "Usage: audio <url>"; exit 1; }
        if command -v yt-dlp >/dev/null 2>&1; then
            yt-dlp -x --audio-format mp3 "$url" 2>/dev/null || echo "Failed (ffmpeg needed for conversion)"
        else echo "Requires yt-dlp"; fi;;
    thumbnail)
        url="${1:-}"; [ -z "$url" ] && { echo "Usage: thumbnail <url>"; exit 1; }
        if command -v yt-dlp >/dev/null 2>&1; then
            yt-dlp --write-thumbnail --skip-download "$url" 2>/dev/null || echo "Failed"
        else echo "Requires yt-dlp"; fi;;
    playlist)
        url="${1:-}"; [ -z "$url" ] && { echo "Usage: playlist <url>"; exit 1; }
        if command -v yt-dlp >/dev/null 2>&1; then
            yt-dlp --flat-playlist -J "$url" 2>/dev/null | python3 -c "
import json, sys
d = json.load(sys.stdin)
print('Playlist: {}'.format(d.get('title','?')))
entries = d.get('entries', [])
print('Videos: {}'.format(len(entries)))
for i, e in enumerate(entries[:20], 1):
    print('  {:>3d}. {} ({})'.format(i, e.get('title','?')[:50], e.get('duration_string','?')))
if len(entries) > 20: print('  ...and {} more'.format(len(entries)-20))
" || echo "Failed"
        else echo "Requires yt-dlp"; fi;;
    batch)
        file="${1:-}"; [ -z "$file" ] && { echo "Usage: batch <file>"; exit 1; }
        [ ! -f "$file" ] && { echo "Not found: $file"; exit 1; }
        if command -v yt-dlp >/dev/null 2>&1; then
            yt-dlp -a "$file" -f "best[height<=720]"
        else echo "Requires yt-dlp"; fi;;
    convert)
        file="${1:-}"; fmt="${2:-mp4}"; [ -z "$file" ] && { echo "Usage: convert <file> <format>"; exit 1; }
        if command -v ffmpeg >/dev/null 2>&1; then
            out="${file%.*}.$fmt"
            ffmpeg -i "$file" "$out" 2>/dev/null && echo "Converted: $out" || echo "Failed"
        else echo "Requires ffmpeg"; fi;;
    version|info) echo "Video Downloader v1.0.0"; echo "Inspired by: lux (30,000+ stars)"; echo "Powered by BytesAgain | bytesagain.com";;
    *) echo "Unknown: $CMD"; exit 1;;
esac
