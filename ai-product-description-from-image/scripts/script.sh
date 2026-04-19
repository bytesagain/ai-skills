#!/usr/bin/env bash
# ai-product-description-from-image — Convert local images to product descriptions
# Requires: XAI_API_KEY environment variable
set -euo pipefail

API_URL="https://api.x.ai/v1/chat/completions"

_check_key() {
    if [[ -z "${XAI_API_KEY:-}" ]]; then
        echo "Error: XAI_API_KEY environment variable not set" >&2
        echo "Get your key at: https://console.x.ai" >&2
        exit 1
    fi
}

cmd_describe() {
    local image_path="" style="professional" lang="en"
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --image) image_path="$2"; shift 2 ;;
            --style) style="$2";      shift 2 ;;
            --lang)  lang="$2";       shift 2 ;;
            *) shift ;;
        esac
    done

    if [[ -z "$image_path" ]]; then
        echo "Error: --image is required" >&2
        echo "Usage: $0 describe --image <path> [--style professional|casual|luxury|seo] [--lang en|zh|es]"
        exit 1
    fi

    if [[ ! -f "$image_path" ]]; then
        echo "Error: File not found: $image_path" >&2
        exit 1
    fi

    _check_key

    IMAGE_PATH="$image_path" STYLE="$style" LANG="$lang" \
    API_KEY="${XAI_API_KEY}" API_URL="$API_URL" \
    python3 -u - << 'PYEOF'
import urllib.request, json, sys, os, base64

API_KEY    = os.environ["API_KEY"]
API_URL    = os.environ["API_URL"]
image_path = os.environ["IMAGE_PATH"]
style      = os.environ["STYLE"]
lang       = os.environ["LANG"]

ext = os.path.splitext(image_path)[1].lower()
mime_map = {".jpg": "image/jpeg", ".jpeg": "image/jpeg", ".png": "image/png", ".webp": "image/webp"}
mime = mime_map.get(ext, "image/jpeg")

with open(image_path, "rb") as f:
    b64 = base64.b64encode(f.read()).decode()
data_url = f"data:{mime};base64,{b64}"

STYLE_INSTRUCTIONS = {
    "professional": "Write a formal, professional product description suitable for B2B buyers.",
    "casual":       "Write a friendly, casual product description as if recommending to a friend.",
    "luxury":       "Write a premium, aspirational product description for luxury shoppers.",
    "seo":          "Write an SEO-optimized product description with keywords and bullet points.",
}

instruction = STYLE_INSTRUCTIONS.get(style, STYLE_INSTRUCTIONS["professional"])
lang_note = {"zh": " Write in Chinese.", "es": " Write in Spanish."}.get(lang, "")

prompt = f"""{instruction}{lang_note}

Analyze this product image and include:
1. What the product is
2. Key visible features and benefits
3. Who it is ideal for
4. A compelling call to action"""

payload = json.dumps({
    "model": "grok-2-vision-latest",
    "messages": [{
        "role": "user",
        "content": [
            {"type": "image_url", "image_url": {"url": data_url}},
            {"type": "text", "text": prompt}
        ]
    }],
    "temperature": 0.7,
    "max_tokens": 400
}).encode()

req = urllib.request.Request(API_URL, data=payload, headers={
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json"
})

try:
    with urllib.request.urlopen(req, timeout=30) as r:
        data = json.loads(r.read())
    text = data["choices"][0]["message"]["content"].strip()
    fname = os.path.basename(image_path)
    print(f"[{fname}]\n{text}\n")
except urllib.error.HTTPError as e:
    body = e.read().decode()
    print(f"Error ({e.code}): {body}", file=sys.stderr)
    sys.exit(1)
except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(1)
PYEOF
}

cmd_batch() {
    local folder="" style="professional" lang="en"
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --folder) folder="$2"; shift 2 ;;
            --style)  style="$2";  shift 2 ;;
            --lang)   lang="$2";   shift 2 ;;
            *) shift ;;
        esac
    done

    if [[ -z "$folder" || ! -d "$folder" ]]; then
        echo "Error: --folder must be a valid directory" >&2
        exit 1
    fi

    _check_key

    local count=0
    for img in "$folder"/*.jpg "$folder"/*.jpeg "$folder"/*.png "$folder"/*.webp; do
        [[ -f "$img" ]] || continue
        echo "Processing: $(basename "$img")"
        XAI_API_KEY="${XAI_API_KEY}" bash "$0" describe --image "$img" --style "$style" --lang "$lang"
        count=$((count + 1))
    done
    echo "Done: processed $count images"
}

cmd_help() {
    cat << 'EOF'
ai-product-description-from-image — Convert local images to product descriptions

Usage:
  XAI_API_KEY=<key> bash scripts/script.sh describe --image <path> [--style <style>] [--lang <lang>]
  XAI_API_KEY=<key> bash scripts/script.sh batch --folder <dir> [--style <style>]
  bash scripts/script.sh help

Commands:
  describe   Generate description from a single local image
  batch      Process all images in a folder
  help       Show this help

Options:
  --image    Local image file path (jpg/jpeg/png/webp)
  --folder   Folder path containing images
  --style    professional|casual|luxury|seo (default: professional)
  --lang     en|zh|es (default: en)

Credentials:
  XAI_API_KEY  Grok API key (get from console.x.ai)

Examples:
  XAI_API_KEY=xai-xxx bash scripts/script.sh describe --image ./product.jpg
  XAI_API_KEY=xai-xxx bash scripts/script.sh describe --image ./shoe.png --style luxury --lang zh
  XAI_API_KEY=xai-xxx bash scripts/script.sh batch --folder ./product-images --style seo

Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    describe) shift; cmd_describe "$@" ;;
    batch)    shift; cmd_batch "$@" ;;
    help|*)   cmd_help ;;
esac
