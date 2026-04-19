#!/usr/bin/env bash
# ai-product-description-generator-free/scripts/script.sh
# Generate product descriptions using free AI backends (Ollama or HuggingFace)

set -euo pipefail

CMD="${1:-help}"
shift || true

PRODUCT=""
FEATURES=""
BACKEND="ollama"
STYLE="professional"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --product)   PRODUCT="$2";  shift 2 ;;
    --features)  FEATURES="$2"; shift 2 ;;
    --backend)   BACKEND="$2";  shift 2 ;;
    --style)     STYLE="$2";    shift 2 ;;
    *) shift ;;
  esac
done

show_help() {
  cat <<'EOF'
AI Product Description Generator (Free - No Paid API Key Required)
Usage:
  script.sh generate --product <name> --features <feat1,feat2,...> [--backend <backend>] [--style <style>]
  script.sh help

Backends:
  ollama      Local LLM via Ollama (default). Requires: ollama serve + ollama pull llama3
  huggingface Free HuggingFace Inference API. Optional: export HF_TOKEN=hf_...

Styles: professional | casual | seo (default: professional)

Examples:
  # Ollama (local, offline):
  script.sh generate --product "Bamboo Toothbrush" --features "biodegradable,soft bristles,pack of 4"

  # HuggingFace (free online):
  script.sh generate --product "Insulated Tumbler" --features "24oz,keeps cold 24h,BPA free" --backend huggingface

Requirements:
  pip install requests
  For Ollama: install from https://ollama.ai then run 'ollama pull llama3'
  For HuggingFace: free account at huggingface.co (optional HF_TOKEN for higher limits)
EOF
}

cmd_generate() {
  if [[ -z "$PRODUCT" || -z "$FEATURES" ]]; then
    echo "Error: --product and --features are required" >&2
    exit 1
  fi

  python3 -u << 'PYEOF'
import os, sys, json

try:
    import requests
except ImportError:
    print("Error: requests not found. Run: pip install requests", file=sys.stderr)
    sys.exit(1)

product  = os.environ.get("_PRODUCT", "")
features = os.environ.get("_FEATURES", "")
backend  = os.environ.get("_BACKEND", "ollama")
style    = os.environ.get("_STYLE", "professional")

STYLE_INSTRUCTIONS = {
    "professional": "Write a concise, professional product description for a retail website.",
    "casual":       "Write a friendly, conversational product description that feels approachable.",
    "seo":          "Write an SEO-optimized product description with keywords naturally integrated and 5 bullet-point features.",
}

instruction = STYLE_INSTRUCTIONS.get(style, STYLE_INSTRUCTIONS["professional"])

prompt = (
    f"You are an expert e-commerce copywriter.\n\n"
    f"Product: {product}\n"
    f"Key features: {features}\n\n"
    f"{instruction}\n\n"
    f"Output:\n"
    f"Title: (short, compelling)\n"
    f"Description: (2-3 sentences)\n"
    f"Features:\n- ...\n- ...\n- ..."
)

def generate_ollama(prompt):
    url = os.environ.get("OLLAMA_HOST", "http://localhost:11434") + "/api/generate"
    model = os.environ.get("OLLAMA_MODEL", "llama3")
    payload = {"model": model, "prompt": prompt, "stream": False}
    print(f"[Ollama] Using model: {model} at {url.replace('/api/generate', '')}")
    resp = requests.post(url, json=payload, timeout=120)
    resp.raise_for_status()
    data = resp.json()
    return data.get("response", "")

def generate_huggingface(prompt):
    hf_token = os.environ.get("HF_TOKEN", "")
    model_id  = "mistralai/Mistral-7B-Instruct-v0.3"
    api_url   = f"https://api-inference.huggingface.co/models/{model_id}"
    headers   = {"Content-Type": "application/json"}
    if hf_token:
        headers["Authorization"] = f"Bearer {hf_token}"
    payload = {
        "inputs": f"<s>[INST] {prompt} [/INST]",
        "parameters": {"max_new_tokens": 400, "temperature": 0.7, "return_full_text": False},
    }
    print(f"[HuggingFace] Using model: {model_id}")
    resp = requests.post(api_url, headers=headers, json=payload, timeout=60)
    if resp.status_code == 503:
        print("Model is loading, please retry in ~30 seconds.", file=sys.stderr)
        sys.exit(1)
    resp.raise_for_status()
    data = resp.json()
    if isinstance(data, list) and data:
        return data[0].get("generated_text", "")
    return str(data)

print(f"Generating '{style}' description for: {product}")
print(f"Features: {features}")
print(f"Backend: {backend}\n")

if backend == "ollama":
    result = generate_ollama(prompt)
elif backend == "huggingface":
    result = generate_huggingface(prompt)
else:
    print(f"Unknown backend '{backend}'. Use: ollama | huggingface", file=sys.stderr)
    sys.exit(1)

print("=" * 60)
print(result.strip())
print("=" * 60)
print("\nDone.")
PYEOF
}

export _PRODUCT="$PRODUCT"
export _FEATURES="$FEATURES"
export _BACKEND="$BACKEND"
export _STYLE="$STYLE"

case "$CMD" in
  generate) cmd_generate ;;
  help|*)   show_help ;;
esac
