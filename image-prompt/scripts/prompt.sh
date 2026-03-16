#!/usr/bin/env bash
# image-prompt: AI image prompt optimizer
# Usage: bash prompt.sh <command> [description]

set -euo pipefail

COMMAND="${1:-help}"
shift 2>/dev/null || true
INPUT="$*"

case "$COMMAND" in
  midjourney)
    python3 << 'PYEOF'
import random
inp = """{}"""
if not inp.strip():
    inp = "a cat sitting on a windowsill"
print("=" * 60)
print("  MIDJOURNEY PROMPT GENERATOR")
print("=" * 60)
print()
styles = ["cinematic", "hyperrealistic", "ethereal", "dramatic", "painterly", "moody"]
lighting = ["golden hour", "soft ambient light", "dramatic lighting", "backlit", "neon glow"]
quality = ["8k", "highly detailed", "professional photography", "masterpiece", "award winning"]
cameras = ["wide angle", "close-up", "bird's eye view", "macro", "portrait lens 85mm"]
style = random.choice(styles)
light = random.choice(lighting)
qual = random.choice(quality)
cam = random.choice(cameras)
prompt = "{}, {}, {}, {}, {}".format(inp.strip(), style, light, cam, qual)
print("PROMPT:")
print(prompt)
print()
ratios = ["--ar 16:9", "--ar 1:1", "--ar 9:16", "--ar 3:2", "--ar 2:3"]
print("PARAMETERS:")
print("  {}".format(random.choice(ratios)))
print("  --v 6")
print("  --s {}".format(random.choice([100, 250, 500, 750])))
print("  --q 2")
print()
print("FULL COMMAND:")
print("/imagine prompt: {} --ar 16:9 --v 6 --s 250 --q 2".format(prompt))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  dalle)
    python3 << 'PYEOF'
import random
inp = """{}"""
if not inp.strip():
    inp = "a cat sitting on a windowsill"
print("=" * 60)
print("  DALL-E PROMPT GENERATOR")
print("=" * 60)
print()
details = [
    "with intricate details and textures",
    "in a photorealistic style",
    "with vibrant colors and sharp focus",
    "rendered in a digital art style",
    "with soft natural lighting"
]
scenes = [
    "set in a serene environment",
    "surrounded by atmospheric elements",
    "with a complementary background",
    "in a carefully composed scene"
]
detail = random.choice(details)
scene = random.choice(scenes)
prompt = "Create an image of {}, {}, {}. The composition should be balanced and visually striking.".format(
    inp.strip(), detail, scene)
print("PROMPT:")
print(prompt)
print()
print("SETTINGS:")
print("  Size: 1024x1024 (square) or 1792x1024 (landscape)")
print("  Style: vivid (for dramatic) / natural (for realistic)")
print("  Quality: hd")
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  sd)
    python3 << 'PYEOF'
import random
inp = """{}"""
if not inp.strip():
    inp = "a cat sitting on a windowsill"
print("=" * 60)
print("  STABLE DIFFUSION PROMPT GENERATOR")
print("=" * 60)
print()
pos_tags = [
    "(masterpiece:1.4)", "(best quality:1.4)", "(ultra detailed:1.2)",
    "(8k:1.2)", "(photorealistic:1.3)", "(sharp focus:1.1)",
    "(professional:1.1)", "(vivid colors:1.1)"
]
selected = random.sample(pos_tags, min(5, len(pos_tags)))
prompt = "{}, {}".format(inp.strip(), ", ".join(selected))
print("POSITIVE PROMPT:")
print(prompt)
print()
neg = "(worst quality:1.4), (low quality:1.4), (blurry:1.2), (deformed:1.3), extra limbs, bad anatomy, bad hands, missing fingers, watermark, text, signature, jpeg artifacts"
print("NEGATIVE PROMPT:")
print(neg)
print()
print("RECOMMENDED SETTINGS:")
print("  Sampler: DPM++ 2M Karras")
print("  Steps: 30-40")
print("  CFG Scale: 7-9")
print("  Size: 512x768 or 768x512")
print("  Seed: -1 (random)")
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  enhance)
    python3 << 'PYEOF'
import random
inp = """{}"""
if not inp.strip():
    inp = "a beautiful landscape"
print("=" * 60)
print("  PROMPT ENHANCER")
print("=" * 60)
print()
print("ORIGINAL:")
print("  {}".format(inp.strip()))
print()
enhancements = {
    "Lighting": ["golden hour sunlight", "volumetric fog", "rim lighting", "chiaroscuro", "soft diffused light"],
    "Detail": ["intricate details", "hyperdetailed textures", "microscopic precision", "crisp sharp focus"],
    "Mood": ["ethereal atmosphere", "cinematic mood", "dramatic tension", "peaceful serenity", "mysterious ambiance"],
    "Technical": ["8k uhd", "octane render", "unreal engine 5", "ray tracing", "global illumination"],
    "Composition": ["rule of thirds", "leading lines", "symmetrical balance", "depth of field bokeh"]
}
parts = [inp.strip()]
for category, options in enhancements.items():
    pick = random.choice(options)
    parts.append(pick)
    print("  + [{}] {}".format(category, pick))
print()
print("ENHANCED PROMPT:")
print(", ".join(parts))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  negative)
    python3 << 'PYEOF'
inp = """{}"""
print("=" * 60)
print("  NEGATIVE PROMPT GENERATOR")
print("=" * 60)
print()
categories = {
    "Quality": "worst quality, low quality, normal quality, jpeg artifacts, blurry, noise, grainy",
    "Anatomy": "bad anatomy, bad hands, missing fingers, extra fingers, extra limbs, deformed, mutated, malformed",
    "Face": "ugly, deformed face, asymmetrical eyes, cross-eyed, bad teeth",
    "Body": "long neck, extra arms, missing arms, extra legs, fused fingers, too many fingers",
    "Style": "cartoon, anime, 3d render, drawing, painting, sketch, illustration",
    "Text": "text, watermark, signature, logo, username, copyright, title, caption",
    "Other": "cropped, out of frame, duplicate, clone, tiling, nsfw"
}
print("Category-based Negative Prompts:")
print("-" * 40)
for cat, terms in categories.items():
    print()
    print("[{}]".format(cat))
    print("  {}".format(terms))
print()
print("UNIVERSAL NEGATIVE (copy-paste):")
all_neg = "worst quality, low quality, blurry, bad anatomy, bad hands, deformed, extra limbs, missing fingers, watermark, text, signature, ugly, jpeg artifacts"
print(all_neg)
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  style)
    python3 << 'PYEOF'
print("=" * 60)
print("  STYLE REFERENCE LIBRARY")
print("=" * 60)
print()
styles = {
    "Photography": [
        "photorealistic, DSLR, 35mm film",
        "portrait photography, studio lighting",
        "street photography, candid, urban",
        "macro photography, extreme close-up"
    ],
    "Art Movements": [
        "impressionism, Monet style, soft brushstrokes",
        "art nouveau, decorative, organic curves",
        "pop art, bold colors, Andy Warhol style",
        "surrealism, dreamlike, Salvador Dali style"
    ],
    "Digital Art": [
        "concept art, digital painting, ArtStation",
        "anime style, cel shading, vibrant",
        "pixel art, retro 16-bit, nostalgic",
        "3D render, octane, unreal engine 5"
    ],
    "Traditional": [
        "oil painting, classical, Renaissance",
        "watercolor, soft washes, transparent",
        "ink wash, Chinese painting, sumi-e",
        "pencil sketch, charcoal drawing"
    ],
    "Mood": [
        "dark fantasy, gothic, ominous",
        "cyberpunk, neon, futuristic city",
        "cottagecore, pastoral, warm cozy",
        "vaporwave, retro 80s, synthwave"
    ]
}
for cat, items in styles.items():
    print("[{}]".format(cat))
    for item in items:
        print("  - {}".format(item))
    print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  batch)
    python3 << 'PYEOF'
import random
inp = """{}"""
if not inp.strip():
    inp = "a warrior in battle"
print("=" * 60)
print("  BATCH PROMPT VARIANTS")
print("=" * 60)
print()
base = inp.strip()
variant_sets = [
    {"style": "oil painting", "mood": "dramatic", "light": "chiaroscuro"},
    {"style": "anime illustration", "mood": "epic", "light": "neon glow"},
    {"style": "photorealistic", "mood": "serene", "light": "golden hour"},
    {"style": "watercolor", "mood": "dreamy", "light": "soft diffused"},
    {"style": "cyberpunk", "mood": "intense", "light": "holographic"},
    {"style": "ink sketch", "mood": "minimalist", "light": "high contrast"},
]
random.shuffle(variant_sets)
for i, v in enumerate(variant_sets[:5], 1):
    prompt = "{}, {} style, {} atmosphere, {} lighting, masterpiece, 8k".format(
        base, v["style"], v["mood"], v["light"])
    print("Variant {}:".format(i))
    print("  {}".format(prompt))
    print()
print("Total variants: 5")
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  help|*)
    cat << 'HELPEOF'
========================================
  Image Prompt - AI Art Optimizer
========================================

Commands:
  midjourney   MJ-style prompt
  dalle        DALL-E prompt
  sd           Stable Diffusion prompt
  enhance      Enhance existing prompt
  negative     Generate negative prompt
  style        Style reference library
  batch        Batch variants

Usage:
  bash prompt.sh <command> <description>

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
    ;;
esac
