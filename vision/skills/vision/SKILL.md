---
name: vision
description: "Resize, crop, convert, and optimize images using ImageMagick. Use when processing photos, reading EXIF, or adding watermarks."
version: "3.4.1"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags:
  - vision
  - image-processing
  - resize
  - crop
  - convert
  - optimize
  - exif
  - watermark
---

# vision

Image processing toolkit. Resize, crop, convert between formats, optimize file size, read EXIF/metadata, and add watermarks — all via ImageMagick from the command line.

## Commands

### resize

Resize an image to specified dimensions or percentage.

```bash
bash scripts/script.sh resize --input photo.jpg --width 800 --height 600
bash scripts/script.sh resize --input photo.jpg --percent 50 --output thumb.jpg
```

### crop

Crop an image to a region defined by position and dimensions.

```bash
bash scripts/script.sh crop --input photo.jpg --width 400 --height 300 --x 100 --y 50
bash scripts/script.sh crop --input photo.jpg --gravity center --width 500 --height 500
```

### convert

Convert image format between png, jpg, and webp.

```bash
bash scripts/script.sh convert --input photo.png --to jpg --output photo.jpg
bash scripts/script.sh convert --input photo.jpg --to webp --quality 85
```

### optimize

Compress and optimize image file size while preserving visual quality.

```bash
bash scripts/script.sh optimize --input photo.jpg --quality 80
bash scripts/script.sh optimize --input photo.png --output optimized.png
```

### info

Read EXIF data and image metadata (dimensions, format, file size, color space).

```bash
bash scripts/script.sh info --input photo.jpg
bash scripts/script.sh info --input photo.jpg --json
```

### watermark

Add a text watermark to an image with configurable position and style.

```bash
bash scripts/script.sh watermark --input photo.jpg --text "© 2025" --position southeast
bash scripts/script.sh watermark --input photo.jpg --text "DRAFT" --opacity 30 --size 48
```

## Output

Processed images are written to `--output` path or auto-named with suffix (e.g., `photo_resized.jpg`). Info command prints metadata to stdout. Use `--json` with info for structured output.


## Requirements
- bash 4+
- ImageMagick (convert, identify, mogrify)
- exiftool (optional, for detailed EXIF data)

## Feedback

Report issues or suggestions: https://bytesagain.com/feedback/

---

Powered by BytesAgain | bytesagain.com
