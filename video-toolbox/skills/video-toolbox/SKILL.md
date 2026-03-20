---
name: "video-toolbox"
version: "3.0.0"
description: "Process video files with ffmpeg for conversion, trimming, and compression. Use when editing videos. Requires ffmpeg."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# video-toolbox

Process video files with ffmpeg for conversion, trimming, and compression. Use when editing videos. Requires ffmpeg.

## Commands

### `info`

```bash
scripts/script.sh info <file>
```

### `convert`

```bash
scripts/script.sh convert <in out>
```

### `trim`

```bash
scripts/script.sh trim <file start end out>
```

### `thumbnail`

```bash
scripts/script.sh thumbnail <file timestamp>
```

### `compress`

```bash
scripts/script.sh compress <file out>
```

### `merge`

```bash
scripts/script.sh merge <f1 f2 out>
```

## Data Storage

Data stored in `~/.local/share/video-toolbox/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
