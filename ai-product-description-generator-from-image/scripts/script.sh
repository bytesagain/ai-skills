#!/usr/bin/env bash
# ai-product-description-generator-from-image — Analyze image URL and generate product description
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
    local image_url="" style="professional" lang="en"
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --url)   image_url="$2"; shift 2 ;;
            --style) style="$2";     shift 2 ;;
            --lang)  lang="$2";      shift 2 ;;
            *) shift ;;
        esac
    done

    if [[ -z "$image_url" ]]; then
        echo "Error: --url is required" >&2
        echo "Usage: $0 describe --url <image_url> [--style professional|casual|luxury|seo] [--lang en|zh|es]"
        exit 1
    fi

    if [[ "$image_url" != https://* ]]; then
        echo "Error: URL must start with https://" >&2
        exit 1
    fi

    _check_key

    IMAGE_URL="$image_url" STYLE="$style" LANG="$lang" \
    API_KEY="${XAI_API_KEY}" API_URL="$API_URL" \
    python3 -u - << 'PYEOF'
import urllib.request, json, sys, os

API_KEY  = os.environ["API_KEY"]
API_URL  = os.environ["API_URL"]
img_url  = os.environ["IMAGE_URL"]
style    = os.environ["STYLE"]
lang     = os.environ["LANG"]

STYLE_INSTRUCTIONS = {
    "professional": "Write a formal, professional product description suitable for B2B buyers.",
    "casual":       "Write a friendly, casual product description as if recommending to a friend.",
    "luxury":       "Write a premium, aspirational product description for luxury shoppers.",
    "seo":          "Write an SEO-optimized product description with keywords and bullet points.",
}

instruction = STYLE_INSTRUCTIONS.get(style, STYLE_INSTRUCTIONS["professional"])
lang_note = {"zh": " Write the description in Chinese.", "es": " Write the description in Spanish."}.get(lang, "")

prompt = f"""{instruction}{lang_note}

Analyze the product in the image and include:
1. What the product is
2. Key visible features and benefits
3. Who it is ideal for
4. A compelling call to action

Keep it 2-3 paragraphs."""

payload = json.dumps({
    "model": "grok-2-vision-latest",
    "messages": [{
        "role": "user",
        "content": [
            {"type": "image_url", "image_url": {"url": img_url}},
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
    print(text)
except urllib.error.HTTPError as e:
    body = e.read().decode()
    print(f"Error ({e.code}): {body}", file=sys.stderr)
    sys.exit(1)
except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(1)
PYEOF
}

cmd_help() {
    cat << 'EOF'
ai-product-description-generator-from-image — Generate product descriptions from image URLs

Usage:
  XAI_API_KEY=<key> bash scripts/script.sh describe --url <image_url> [--style <style>] [--lang <lang>]
  bash scripts/script.sh help

Commands:
  describe   Analyze an image URL and generate a product description
  help       Show this help

Options for describe:
  --url     Public image URL (required, must be https://)
  --style   professional|casual|luxury|seo (default: professional)
  --lang    en|zh|es (default: en)

Credentials:
  XAI_API_KEY  Grok API key (get from console.x.ai)

Examples:
  XAI_API_KEY=xai-xxx bash scripts/script.sh describe --url "https://example.com/product.jpg"
  XAI_API_KEY=xai-xxx bash scripts/script.sh describe --url "https://example.com/shoe.jpg" --style luxury --lang zh

Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    describe) shift; cmd_describe "$@" ;;
    help|*)   cmd_help ;;
esac
