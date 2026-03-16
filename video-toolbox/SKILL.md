---
version: "2.0.0"
name: video-toolbox
description: "╔══════════════════════════════════════════════════════════╗. Use when you need video toolbox capabilities. Triggers on: video toolbox, input, output, start, end, duration."
author: BytesAgain
---

# Video Toolbox

Complete video processing toolkit for AI agents. One script, 14 commands, zero hassle.

**Powered by [BytesAgain](https://bytesagain.com) | hello@bytesagain.com**

## Description

Video Toolbox is a complete, production-ready video processing skill that wraps ffmpeg/ffprobe into a single, agent-friendly bash script. Unlike simpler tools that only extract frames, Video Toolbox covers the entire video processing workflow — from inspection to trimming, conversion, compression, watermarking, GIF creation, audio extraction, and beyond.

Every command includes input validation, meaningful error messages, and sensible defaults. Designed so an AI agent can confidently process any video file without memorizing ffmpeg's sprawling option syntax.

## Requirements

- **ffmpeg** (>= 4.0) with libx264, libx265, libvpx-vp9, libmp3lame, libvorbis
- **ffprobe** (bundled with ffmpeg)
- **bash** (>= 4.0)
- **python3** (for arithmetic and JSON parsing)

Install on Debian/Ubuntu: `sudo apt install ffmpeg python3`
Install on macOS: `brew install ffmpeg python3`

## Commands

| Command | Description | Key Options |
|---------|-------------|-------------|
| `info` | Show video metadata (resolution, duration, codecs, bitrate, fps, audio) | `--json` for machine-readable output |
| `trim` | Cut a segment from a video | `--start`, `--end`, `--duration` |
| `resize` | Change video resolution | `--width`, `--height`, `--scale` (e.g. `0.5`) |
| `convert` | Convert between formats (mp4, webm, avi, mov, mkv) | `--format`, `--codec` |
| `extract-frames` | Extract frames as images | `--fps`, `--count`, `--format` (jpg/png) |
| `extract-audio` | Extract audio track to file | `--format` (mp3/wav/aac/flac) |
| `compress` | Reduce file size | `--quality` (low/medium/high) |
| `thumbnail` | Generate thumbnail(s) | `--time`, `--width`, `--count` |
| `gif` | Convert video segment to animated GIF | `--start`, `--duration`, `--fps`, `--width` |
| `merge` | Concatenate multiple videos | Multiple `--input` files |
| `watermark` | Add text watermark overlay | `--text`, `--position`, `--fontsize`, `--color`, `--opacity` |
| `speed` | Change playback speed (0.25x–4x, chain atempo) | `--speed` |
| `rotate` | Rotate video (90°, 180°, 270°) | `--angle` |
| `metadata` | View or edit file metadata | `--set key=value`, `--clear` |

## Usage

```bash
# Get video info
bash scripts/main.sh info --input input.mp4

# Get video info as JSON
bash scripts/main.sh info --input input.mp4 --json

# Trim 30 seconds starting at 1:00
bash scripts/main.sh trim --input input.mp4 -o clip.mp4 --start 00:01:00 --duration 30

# Extract 10 frames evenly spaced (as jpg)
bash scripts/main.sh extract-frames --input input.mp4 -o ./frames/ --count 10 --format jpg

# Compress to medium quality
bash scripts/main.sh compress --input input.mp4 -o smaller.mp4 --quality medium

# Convert to WebM with specific codec
bash scripts/main.sh convert --input input.mp4 -o output.webm --format webm --codec libvpx-vp9

# Create GIF from first 5 seconds
bash scripts/main.sh gif --input input.mp4 -o preview.gif --start 0 --duration 5 --fps 10

# Add watermark with position and style
bash scripts/main.sh watermark --input input.mp4 -o marked.mp4 --text "© 2026" --position bottom-right --fontsize 32 --color yellow --opacity 0.8

# 2x speed (chain atempo for values outside 0.5-2.0)
bash scripts/main.sh speed --input input.mp4 -o fast.mp4 --speed 2.0

# 4x speed (auto-chains atempo filters)
bash scripts/main.sh speed --input input.mp4 -o fast4x.mp4 --speed 4.0

# 0.25x slow motion
bash scripts/main.sh speed --input input.mp4 -o slow.mp4 --speed 0.25

# Merge videos
bash scripts/main.sh merge --input part1.mp4 --input part2.mp4 --input part3.mp4 -o full.mp4

# Resize by scale factor
bash scripts/main.sh resize --input input.mp4 --scale 0.5

# Resize to specific dimensions
bash scripts/main.sh resize --input input.mp4 --width 1280 --height 720

# Generate thumbnail at specific time with width
bash scripts/main.sh thumbnail --input input.mp4 --time 00:00:30 --width 640

# Generate 5 thumbnails evenly spaced
bash scripts/main.sh thumbnail --input input.mp4 --count 5

# View metadata
bash scripts/main.sh metadata --input input.mp4

# Set metadata
bash scripts/main.sh metadata --input input.mp4 --set "title=My Video"

# Clear all metadata
bash scripts/main.sh metadata --input input.mp4 --clear -o clean.mp4
```

## How the Agent Should Use This Skill

1. Determine the user's goal (e.g., "make this video smaller", "grab a thumbnail", "convert to GIF").
2. Map to the appropriate command from the table above.
3. Run `bash scripts/main.sh <command> [options]` from the skill directory.
4. The script outputs the result file path on success, or a clear error message on failure.
5. Report the result to the user, including output file path and any relevant stats (file size, duration, resolution).

## Common Options

| Option | Short | Description |
|--------|-------|-------------|
| `--input` | `-i` | Input file (required for most commands) |
| `--output` | `-o` | Output file (auto-generated if not specified) |
| `--start` | `-s` | Start time (HH:MM:SS or seconds) |
| `--end` | `-e` | End time |
| `--duration` | `-d` | Duration |
| `--quality` | `-q` | Quality preset: low, medium, high (compress only) |

## Output Behavior

- All commands print the output file path on the last line of stdout on success.
- Errors go to stderr with a descriptive message and non-zero exit code.
- The `info` command prints human-readable text by default, or JSON with `--json`.
- Unknown options produce a warning on stderr and are skipped.

## Notes

- Input files are never modified. All operations produce new output files.
- If `-o` / `--output` is omitted, a sensible default name is generated (e.g., `input_trimmed.mp4`).
- The script auto-detects codec support and falls back gracefully.
- Timestamps accept both `HH:MM:SS` and seconds (e.g., `90` = `00:01:30`).
- Speed changes outside ffmpeg's native atempo range (0.5–2.0) are handled via chained atempo filters.

## File Structure

```
video-toolbox/
├── SKILL.md          # This file
├── tips.md           # Usage examples and pro tips
└── scripts/
    └── main.sh       # The main processing script
```
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
