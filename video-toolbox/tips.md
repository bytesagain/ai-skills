# Video Toolbox — Tips & Examples

**Powered by [BytesAgain](https://bytesagain.com) | hello@bytesagain.com**

## Quick Start

```bash
# Always check video info first
bash scripts/main.sh info video.mp4

# JSON output for programmatic use
bash scripts/main.sh info video.mp4 --json
```

## Real-World Recipes

### 📱 Prepare video for social media (Instagram Reel)
```bash
# Resize to 1080x1920 (9:16), trim to 60s, compress
bash scripts/main.sh resize input.mp4 -o step1.mp4 --width 1080 --height 1920
bash scripts/main.sh trim step1.mp4 -o step2.mp4 --start 0 --duration 60
bash scripts/main.sh compress step2.mp4 -o reel.mp4 --quality medium
```

### 🎬 Extract key frames for a blog post
```bash
# Get 5 evenly-spaced frames as PNG
bash scripts/main.sh extract-frames lecture.mp4 -o ./blog-images/ --count 5 --format png
```

### 🎵 Podcast: rip audio from video interview
```bash
bash scripts/main.sh extract-audio interview.mp4 -o podcast.mp3 --format mp3
```

### 📧 Create a lightweight GIF preview for email
```bash
bash scripts/main.sh gif product-demo.mp4 -o preview.gif --start 2 --duration 4 --fps 8 --width 480
```

### 🔀 Merge conference talk parts
```bash
bash scripts/main.sh merge part1.mp4 part2.mp4 part3.mp4 -o full-talk.mp4
```

### ⏩ Speed up a tutorial (2x)
```bash
bash scripts/main.sh speed tutorial.mp4 -o tutorial_2x.mp4 --factor 2
```

### 🔄 Fix sideways phone video
```bash
bash scripts/main.sh rotate sideways.mp4 -o fixed.mp4 --angle 90
```

### © Add watermark before sharing
```bash
bash scripts/main.sh watermark raw.mp4 -o branded.mp4 --text "© MyBrand 2026" --position bottom-right --fontsize 24 --opacity 0.7
```

### 📊 Batch: generate thumbnail + info for all videos
```bash
for f in *.mp4; do
  bash scripts/main.sh info "$f" --json > "${f%.mp4}_info.json"
  bash scripts/main.sh thumbnail "$f" -o "${f%.mp4}_thumb.jpg"
done
```

## Pro Tips

1. **Always use `info` first** — know your input before processing. Resolution, codec, and duration affect which options make sense.

2. **Timestamps are flexible** — use `01:30:00` (HH:MM:SS), `90:00` (MM:SS), or just `90` (seconds). All work.

3. **Omit `-o` for auto-naming** — the script generates names like `input_trimmed.mp4`, `input_compressed.mp4`. Useful for quick one-offs.

4. **Chain commands for complex workflows** — trim → resize → compress → watermark. Each step produces a clean intermediate file.

5. **Use `--quality` wisely for compress:**
   - `high` — visually lossless, ~60% original size
   - `medium` — good balance, ~35% original size  
   - `low` — noticeable quality loss, ~15% original size

6. **GIF optimization** — lower `--fps` (8-10) and `--width` (480 or less) dramatically reduce file size. Perfect for email/chat previews.

7. **`extract-frames` with `--count`** — more useful than `--fps` when you want exactly N frames regardless of video length. Great for creating storyboards.

8. **Metadata editing** — use `metadata --set title="My Video"` for organizing files. Useful before publishing.

9. **Merging requires same codec** — if your files have different codecs, convert them first with `convert --codec h264`.

10. **Silent mode** — add `-q` to any command to suppress ffmpeg's progress output. Essential when scripting or piping.

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "ffmpeg not found" | Install: `apt install ffmpeg` or `brew install ffmpeg` |
| "codec not supported" | Try `--codec h264` (most universal) |
| Merge produces glitchy output | Ensure all inputs share the same resolution and codec |
| GIF is too large | Reduce `--fps` and `--width` |
| Output has no audio | Some formats (gif) don't support audio — expected behavior |
| "Permission denied" | Check output directory is writable |

## Command Quick Reference

```
info          Show video details (resolution, duration, codecs, bitrate)
trim          Cut a time segment
resize        Change resolution
convert       Change format (mp4/webm/avi/mov/mkv/gif)
extract-frames  Save frames as images
extract-audio   Save audio track
compress      Reduce file size
thumbnail     Generate best-frame thumbnail
gif           Create animated GIF
merge         Join multiple videos
watermark     Add text overlay
speed         Change playback speed
rotate        Rotate 90°/180°/270°
metadata      View/edit metadata tags
```
