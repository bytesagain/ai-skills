#!/usr/bin/env bash
# ai-product-description-writer — Generate product descriptions via Grok AI
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

cmd_write() {
    local product="" features="" style="all"
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --product)  product="$2";  shift 2 ;;
            --features) features="$2"; shift 2 ;;
            --style)    style="$2";    shift 2 ;;
            *) shift ;;
        esac
    done

    if [[ -z "$product" || -z "$features" ]]; then
        echo "Error: --product and --features are required" >&2
        echo "Usage: $0 write --product <name> --features <feat1,feat2,...> [--style professional|casual|luxury|seo|all]"
        exit 1
    fi

    _check_key

    PRODUCT="$product" FEATURES="$features" STYLE="$style" \
    API_KEY="${XAI_API_KEY}" API_URL="$API_URL" \
    python3 -u - << 'PYEOF'
import urllib.request, json, sys, os

API_KEY = os.environ["API_KEY"]
API_URL = os.environ["API_URL"]
product  = os.environ["PRODUCT"]
features = os.environ["FEATURES"]
style    = os.environ["STYLE"]

STYLES = {
    "professional": "Write a formal, professional product description suitable for B2B buyers and corporate procurement. Use clear, factual language.",
    "casual":       "Write a friendly, casual product description as if recommending to a friend. Use conversational language.",
    "luxury":       "Write a premium, aspirational product description for luxury shoppers. Use evocative, sophisticated language.",
    "seo":          "Write an SEO-optimized product description. Include natural keyword repetition, bullet points of key benefits, and a call to action.",
}

styles_to_run = list(STYLES.items()) if style == "all" else [(style, STYLES.get(style, STYLES["professional"]))]

for style_name, instruction in styles_to_run:
    prompt = f"""{instruction}

Product: {product}
Key features: {features}

Write a 2-3 paragraph product description. Be specific and compelling. Do not use filler phrases."""

    payload = json.dumps({
        "model": "grok-3-mini",
        "messages": [{"role": "user", "content": prompt}],
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
        print(f"\n=== {style_name.upper()} ===")
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
ai-product-description-writer — Generate AI product descriptions

Usage:
  XAI_API_KEY=<key> bash scripts/script.sh write --product <name> --features <features> [--style <style>]
  bash scripts/script.sh help

Commands:
  write    Generate descriptions from product name + features
  help     Show this help

Options for write:
  --product   Product name (required)
  --features  Key features, comma-separated (required)
  --style     professional|casual|luxury|seo|all (default: all)

Credentials:
  XAI_API_KEY  Grok API key (get from console.x.ai)

Examples:
  XAI_API_KEY=xai-xxx bash scripts/script.sh write --product "Wireless Headphones" --features "noise cancelling, 30h battery"
  XAI_API_KEY=xai-xxx bash scripts/script.sh write --product "Running Shoes" --features "lightweight, breathable" --style seo

Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    write) shift; cmd_write "$@" ;;
    help|*) cmd_help ;;
esac
