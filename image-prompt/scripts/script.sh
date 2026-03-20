#!/usr/bin/env bash
# ============================================================================
# image-prompt — AI Image Prompt Generator & Optimizer
# Generate, enhance, and manage prompts for AI image generation tools.
#
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
# ============================================================================
set -euo pipefail

VERSION="2.1.0"
DATA_DIR="${IMAGE_PROMPT_DIR:-$HOME/.image-prompt}"
PROMPTS_FILE="$DATA_DIR/prompts.txt"
HISTORY_LOG="$DATA_DIR/history.log"
mkdir -p "$DATA_DIR"
touch "$PROMPTS_FILE" "$HISTORY_LOG"

# ---------------------------------------------------------------------------
# Word Banks
# ---------------------------------------------------------------------------

SUBJECTS=(
    "a mechanical owl perched on ancient ruins"
    "a lone samurai standing in a bamboo forest"
    "an underwater city with bioluminescent buildings"
    "a floating island above the clouds"
    "a cyberpunk street market at night"
    "a cozy cabin in a snowy mountain valley"
    "a giant tree growing through an abandoned cathedral"
    "a phoenix rising from volcanic ash"
    "a time traveler stepping out of a portal"
    "a dragon coiled around a lighthouse"
    "a garden of crystal flowers under moonlight"
    "a witch brewing potions in a mushroom house"
    "a robot painting a self-portrait"
    "a library carved inside a mountain"
    "a train crossing a bridge over a cloud sea"
    "an astronaut floating above a neon planet"
    "a deer with galaxy antlers in a dark forest"
    "a pirate ship sailing through a desert"
    "a fox spirit dancing among lanterns"
    "a clocktower overgrown with vines and flowers"
)

STYLES=(
    "digital painting"
    "concept art"
    "matte painting"
    "cinematic"
    "illustration"
    "photorealistic"
    "hyperrealistic"
    "surrealist"
    "impressionist"
    "art nouveau"
    "cyberpunk"
    "steampunk"
    "fantasy art"
    "gothic"
    "retro futurism"
)

LIGHTINGS=(
    "golden hour lighting"
    "dramatic rim lighting"
    "soft ambient lighting"
    "volumetric lighting"
    "neon glow"
    "moonlit"
    "studio lighting"
    "backlit silhouette"
    "candlelight"
    "bioluminescent glow"
    "overcast diffused light"
    "harsh midday sun"
    "aurora borealis illumination"
    "firelight"
    "dawn light"
)

COMPOSITIONS=(
    "rule of thirds"
    "centered composition"
    "wide angle"
    "close-up"
    "bird's eye view"
    "low angle shot"
    "panoramic"
    "symmetrical"
    "dynamic angle"
    "depth of field"
    "leading lines"
    "aerial perspective"
    "dutch angle"
    "over the shoulder"
    "worm's eye view"
)

QUALITY_TAGS=(
    "highly detailed"
    "sharp focus"
    "8k resolution"
    "intricate details"
    "masterpiece"
    "best quality"
    "trending on artstation"
    "award winning"
    "professional"
    "4k wallpaper"
    "ultra detailed"
    "photorealistic rendering"
    "octane render"
    "unreal engine 5"
    "ray tracing"
)

NEGATIVE_ANATOMY=(
    "bad anatomy"
    "bad hands"
    "extra fingers"
    "fewer fingers"
    "extra limbs"
    "missing arms"
    "missing legs"
    "fused fingers"
    "mutated hands"
    "poorly drawn hands"
    "poorly drawn face"
    "deformed"
    "disfigured"
    "mutation"
    "ugly"
)

NEGATIVE_QUALITY=(
    "blurry"
    "low quality"
    "low resolution"
    "worst quality"
    "jpeg artifacts"
    "pixelated"
    "noisy"
    "grainy"
    "out of focus"
    "overexposed"
    "underexposed"
    "chromatic aberration"
)

NEGATIVE_STYLE=(
    "watermark"
    "text"
    "signature"
    "logo"
    "username"
    "artist name"
    "cropped"
    "frame"
    "border"
    "stock photo"
)

NEGATIVE_ARTIFACTS=(
    "duplicate"
    "error"
    "glitch"
    "distorted"
    "morbid"
    "mutilated"
    "poorly rendered"
    "bad proportions"
    "cloned face"
    "long neck"
)

# ---------------------------------------------------------------------------
# Style Presets (for the `style` command)
# ---------------------------------------------------------------------------

declare -A STYLE_PRESETS
STYLE_PRESETS=(
    [photorealistic]="photorealistic, hyperrealistic, DSLR photo, 85mm lens, natural lighting, shallow depth of field, film grain, raw photo"
    [anime]="anime style, cel shading, vibrant colors, clean lines, studio ghibli inspired, high quality anime art, detailed background"
    [oil-painting]="oil painting on canvas, visible brushstrokes, rich colors, classical composition, old masters technique, impasto texture, gallery quality"
    [watercolor]="watercolor painting, soft washes, wet on wet technique, delicate colors, paper texture visible, flowing pigments, artistic"
    [pixel-art]="pixel art, 16-bit style, retro gaming aesthetic, clean pixels, limited color palette, sprite art, nostalgic"
    [3d-render]="3D render, octane render, ray tracing, subsurface scattering, volumetric lighting, physically based rendering, cinema 4d, blender"
    [sketch]="pencil sketch, charcoal drawing, hand drawn, crosshatching, graphite on paper, fine lines, artistic study"
)

declare -A STYLE_NEGATIVES
STYLE_NEGATIVES=(
    [photorealistic]="cartoon, painting, illustration, anime, drawing, 3d render"
    [anime]="photorealistic, 3d render, blurry, low quality, deformed"
    [oil-painting]="photo, digital, 3d render, anime, cartoon, smooth"
    [watercolor]="photo, digital, sharp edges, 3d render, heavy contrast"
    [pixel-art]="realistic, smooth, high resolution, blurry, 3d render"
    [3d-render]="flat, 2d, painting, sketch, cartoon, hand drawn"
    [sketch]="color, photo, digital painting, 3d render, vibrant"
)

# ---------------------------------------------------------------------------
# Template Library
# ---------------------------------------------------------------------------

declare -A TEMPLATES
TEMPLATES=(
    [portrait]="[Person/Character description], [expression], [clothing/accessories], [background setting], portrait photography, eye-level angle, shallow depth of field, studio lighting, sharp focus, 8k, detailed skin texture"
    [landscape]="[Scene description], [time of day], [weather/atmosphere], [foreground elements], landscape photography, wide angle, golden hour lighting, panoramic, vivid colors, high dynamic range, 8k wallpaper"
    [product]="[Product name and description], [material/finish], [background], product photography, studio lighting, centered composition, clean background, commercial quality, sharp focus, high resolution"
    [food]="[Dish description], [plating style], [garnish details], [surface/table setting], food photography, overhead shot, natural lighting, appetizing colors, shallow depth of field, editorial quality"
    [architecture]="[Building/space description], [architectural style], [surroundings], architectural photography, [interior/exterior], symmetrical composition, natural lighting, leading lines, wide angle lens, high detail"
    [fantasy]="[Fantasy scene/creature description], [magical elements], [environment], fantasy art, epic scale, dramatic lighting, intricate details, concept art, vibrant colors, masterpiece, trending on artstation"
)

# ---------------------------------------------------------------------------
# Utility Functions
# ---------------------------------------------------------------------------

_log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$1] $2" >> "$HISTORY_LOG"
}

_pick_random() {
    local -n arr=$1
    local len=${#arr[@]}
    echo "${arr[$((RANDOM % len))]}"
}

_pick_n_random() {
    local -n src=$1
    local n=$2
    local len=${#src[@]}
    local picked=()
    local indices=()

    # Generate n unique random indices
    while [[ ${#indices[@]} -lt $n && ${#indices[@]} -lt $len ]]; do
        local idx=$((RANDOM % len))
        local already=0
        for existing in "${indices[@]+"${indices[@]}"}"; do
            if [[ "$existing" == "$idx" ]]; then
                already=1
                break
            fi
        done
        if [[ $already -eq 0 ]]; then
            indices+=("$idx")
        fi
    done

    for idx in "${indices[@]}"; do
        picked+=("${src[$idx]}")
    done

    local IFS=", "
    echo "${picked[*]}"
}

_default_negative() {
    echo "blurry, low quality, deformed, watermark, text, signature, bad anatomy, disfigured, poorly drawn, extra limbs, ugly, worst quality"
}

_print_prompt() {
    local prompt="$1"
    local negative="${2:-$(_default_negative)}"
    echo ""
    echo "🎨 Prompt:"
    echo "$prompt"
    echo ""
    echo "📛 Negative:"
    echo "$negative"
    echo ""
}

# ---------------------------------------------------------------------------
# Commands
# ---------------------------------------------------------------------------

cmd_generate() {
    if [[ $# -lt 1 ]]; then
        echo "Usage: image-prompt generate <subject>"
        echo "Example: image-prompt generate \"a fox in a forest\""
        exit 1
    fi
    local subject="$*"
    local style
    style=$(_pick_random STYLES)
    local lighting
    lighting=$(_pick_random LIGHTINGS)
    local composition
    composition=$(_pick_random COMPOSITIONS)
    local quality
    quality=$(_pick_n_random QUALITY_TAGS 3)

    local prompt="${subject}, ${style} style, ${lighting}, ${composition} composition, ${quality}"
    local negative
    negative=$(_default_negative)

    _print_prompt "$prompt" "$negative"
    _log "generate" "$subject"
}

cmd_style() {
    if [[ $# -lt 2 ]]; then
        echo "Usage: image-prompt style <subject> <style>"
        echo ""
        echo "Available styles:"
        echo "  photorealistic  anime  oil-painting  watercolor"
        echo "  pixel-art  3d-render  sketch"
        exit 1
    fi

    # Last argument is the style, everything before is the subject
    local args=("$@")
    local style_name="${args[${#args[@]}-1]}"
    local subject="${*:1:$#-1}"

    if [[ -z "${STYLE_PRESETS[$style_name]+x}" ]]; then
        echo "Unknown style: $style_name"
        echo ""
        echo "Available styles:"
        echo "  photorealistic  anime  oil-painting  watercolor"
        echo "  pixel-art  3d-render  sketch"
        exit 1
    fi

    local lighting
    lighting=$(_pick_random LIGHTINGS)
    local composition
    composition=$(_pick_random COMPOSITIONS)
    local quality
    quality=$(_pick_n_random QUALITY_TAGS 2)

    local prompt="${subject}, ${STYLE_PRESETS[$style_name]}, ${lighting}, ${composition}, ${quality}"
    local negative="${STYLE_NEGATIVES[$style_name]}, blurry, low quality, deformed, watermark, text"

    _print_prompt "$prompt" "$negative"
    _log "style" "$subject ($style_name)"
}

cmd_enhance() {
    if [[ $# -lt 1 ]]; then
        echo "Usage: image-prompt enhance <existing_prompt>"
        echo "Example: image-prompt enhance \"a cat on a windowsill\""
        exit 1
    fi
    local original="$*"
    local quality
    quality=$(_pick_n_random QUALITY_TAGS 4)
    local lighting
    lighting=$(_pick_random LIGHTINGS)

    local enhanced="${original}, ${lighting}, ${quality}, cinematic color grading, professional composition"
    local negative
    negative=$(_default_negative)

    echo ""
    echo "📝 Original:"
    echo "$original"
    _print_prompt "$enhanced" "$negative"
    _log "enhance" "$original"
}

cmd_negative() {
    echo ""
    echo "📛 Negative Prompt Reference"
    echo "============================"
    echo ""
    echo "🦴 Anatomy:"
    local IFS=", "
    echo "  ${NEGATIVE_ANATOMY[*]}"
    echo ""
    echo "📉 Quality:"
    echo "  ${NEGATIVE_QUALITY[*]}"
    echo ""
    echo "🏷️  Style/Watermark:"
    echo "  ${NEGATIVE_STYLE[*]}"
    echo ""
    echo "⚠️  Artifacts:"
    echo "  ${NEGATIVE_ARTIFACTS[*]}"
    echo ""
    echo "💡 Copy-paste combo:"
    echo "  $(_default_negative)"
    echo ""
    _log "negative" "viewed"
}

cmd_template() {
    if [[ $# -lt 1 ]]; then
        echo "Usage: image-prompt template <type>"
        echo ""
        echo "Available templates:"
        echo "  portrait     — character/person focus"
        echo "  landscape    — scenery and environments"
        echo "  product      — commercial product shots"
        echo "  food         — food photography"
        echo "  architecture — buildings and interiors"
        echo "  fantasy      — fantasy/sci-fi illustration"
        exit 1
    fi
    local ttype="$1"

    if [[ -z "${TEMPLATES[$ttype]+x}" ]]; then
        echo "Unknown template: $ttype"
        echo ""
        echo "Available: portrait, landscape, product, food, architecture, fantasy"
        exit 1
    fi

    echo ""
    echo "📋 Template: $ttype"
    echo "========================"
    echo ""
    echo "${TEMPLATES[$ttype]}"
    echo ""
    echo "Replace the [bracketed] sections with your specifics."
    echo ""
    echo "📛 Suggested Negative:"
    echo "$(_default_negative)"
    echo ""
    _log "template" "$ttype"
}

cmd_random() {
    local subject
    subject=$(_pick_random SUBJECTS)
    local style
    style=$(_pick_random STYLES)
    local lighting
    lighting=$(_pick_random LIGHTINGS)
    local composition
    composition=$(_pick_random COMPOSITIONS)
    local quality
    quality=$(_pick_n_random QUALITY_TAGS 3)

    local prompt="${subject}, ${style} style, ${lighting}, ${composition} composition, ${quality}"
    local negative
    negative=$(_default_negative)

    _print_prompt "$prompt" "$negative"
    _log "random" "$subject"
}

cmd_translate() {
    if [[ $# -lt 1 ]]; then
        echo "Usage: image-prompt translate <chinese_description>"
        echo "Example: image-prompt translate \"一只猫坐在樱花树下\""
        exit 1
    fi
    local input="$*"

    # Basic Chinese-to-English keyword mapping
    declare -A ZH_EN
    ZH_EN=(
        [猫]="cat" [狗]="dog" [鸟]="bird" [鱼]="fish" [龙]="dragon"
        [马]="horse" [兔]="rabbit" [鹿]="deer" [狐狸]="fox" [狼]="wolf"
        [老虎]="tiger" [熊]="bear" [蝴蝶]="butterfly" [凤凰]="phoenix"
        [树]="tree" [花]="flower" [草]="grass" [山]="mountain" [海]="sea"
        [河]="river" [湖]="lake" [森林]="forest" [天空]="sky" [云]="cloud"
        [月亮]="moon" [太阳]="sun" [星星]="stars" [雨]="rain" [雪]="snow"
        [樱花]="cherry blossom" [竹]="bamboo" [莲花]="lotus" [玫瑰]="rose"
        [城市]="city" [村庄]="village" [城堡]="castle" [桥]="bridge"
        [房子]="house" [小屋]="cabin" [宫殿]="palace" [寺庙]="temple"
        [女孩]="girl" [男孩]="boy" [老人]="old man" [武士]="warrior"
        [魔法师]="wizard" [公主]="princess" [骑士]="knight" [忍者]="ninja"
        [坐]="sitting" [站]="standing" [走]="walking" [飞]="flying"
        [跑]="running" [跳]="jumping" [躺]="lying" [看]="looking"
        [美丽]="beautiful" [神秘]="mysterious" [古老]="ancient"
        [可爱]="cute" [巨大]="giant" [小小]="tiny" [金色]="golden"
        [银色]="silver" [红色]="red" [蓝色]="blue" [绿色]="green"
        [黑暗]="dark" [明亮]="bright" [梦幻]="dreamy" [魔法]="magical"
        [水下]="underwater" [夜晚]="night" [黄昏]="dusk" [黎明]="dawn"
        [春天]="spring" [夏天]="summer" [秋天]="autumn" [冬天]="winter"
        [一只]="a" [一个]="a" [在]="" [的]="" [和]="and" [上]="on"
        [下]="under" [里]="inside" [旁]="beside" [中]="among"
    )

    local translated="$input"
    # Sort keys by length (longest first) to avoid partial replacements
    local sorted_keys
    sorted_keys=$(for key in "${!ZH_EN[@]}"; do echo "$key"; done | awk '{ print length, $0 }' | sort -rn | cut -d' ' -f2-)

    for zh in $sorted_keys; do
        local en="${ZH_EN[$zh]}"
        if [[ -n "$en" ]]; then
            translated="${translated//$zh/ $en }"
        else
            translated="${translated//$zh/ }"
        fi
    done

    # Clean up extra spaces
    translated=$(echo "$translated" | sed 's/  */ /g; s/^ *//; s/ *$//; s/ ,/,/g')

    local style
    style=$(_pick_random STYLES)
    local lighting
    lighting=$(_pick_random LIGHTINGS)
    local quality
    quality=$(_pick_n_random QUALITY_TAGS 3)

    echo ""
    echo "🇨🇳 Original: $input"
    echo "🇬🇧 Translation: $translated"
    echo ""
    local prompt="${translated}, ${style}, ${lighting}, ${quality}"
    _print_prompt "$prompt" "$(_default_negative)"
    _log "translate" "$input -> $translated"
}

cmd_save() {
    if [[ $# -lt 2 ]]; then
        echo "Usage: image-prompt save <name> <prompt>"
        echo "Example: image-prompt save hero-shot \"a knight on a cliff, dramatic lighting\""
        exit 1
    fi
    local name="$1"
    shift
    local prompt="$*"

    # Check for duplicate name
    if grep -q "^${name}|" "$PROMPTS_FILE" 2>/dev/null; then
        echo "⚠️  A prompt named '$name' already exists. Overwriting."
        local tmp
        tmp=$(grep -v "^${name}|" "$PROMPTS_FILE")
        echo "$tmp" > "$PROMPTS_FILE"
    fi

    echo "${name}|${prompt}" >> "$PROMPTS_FILE"
    echo "✅ Saved prompt '$name'"
    _log "save" "$name: $prompt"
}

cmd_list() {
    if [[ ! -s "$PROMPTS_FILE" ]]; then
        echo "📭 No saved prompts yet. Use 'image-prompt save <name> <prompt>' to add one."
        return
    fi

    echo ""
    echo "📚 Saved Prompts"
    echo "================"
    echo ""
    local count=0
    while IFS='|' read -r name prompt; do
        [[ -z "$name" ]] && continue
        count=$((count + 1))
        echo "  📌 $name"
        echo "     $prompt"
        echo ""
    done < "$PROMPTS_FILE"
    echo "Total: $count prompt(s)"
    _log "list" "$count prompts"
}

cmd_search() {
    if [[ $# -lt 1 ]]; then
        echo "Usage: image-prompt search <keyword>"
        exit 1
    fi
    local keyword="$1"

    if [[ ! -s "$PROMPTS_FILE" ]]; then
        echo "📭 No saved prompts to search."
        return
    fi

    echo ""
    echo "🔍 Search results for: $keyword"
    echo "=============================="
    echo ""
    local count=0
    while IFS='|' read -r name prompt; do
        [[ -z "$name" ]] && continue
        if echo "$name $prompt" | grep -qi "$keyword"; then
            count=$((count + 1))
            echo "  📌 $name"
            echo "     $prompt"
            echo ""
        fi
    done < "$PROMPTS_FILE"

    if [[ $count -eq 0 ]]; then
        echo "  No matches found."
    else
        echo "Found: $count prompt(s)"
    fi
    _log "search" "$keyword ($count results)"
}

show_help() {
    cat << 'EOF'
🎨 image-prompt — AI Image Prompt Generator & Optimizer

Usage: image-prompt <command> [args]

Commands:
  generate <subject>         Generate a full image prompt with random style/lighting/composition
  style <subject> <style>    Generate prompt in a specific style
                             Styles: photorealistic, anime, oil-painting, watercolor,
                                     pixel-art, 3d-render, sketch
  enhance <prompt>           Enhance an existing prompt with quality tags and details
  negative                   Show common negative prompt terms by category
  template <type>            Get a fill-in-the-blank prompt template
                             Types: portrait, landscape, product, food, architecture, fantasy
  random                     Generate a random creative prompt from the word bank
  translate <description>    Convert Chinese description to English prompt
  save <name> <prompt>       Save a prompt to your local library
  list                       List all saved prompts
  search <keyword>           Search saved prompts by keyword
  help                       Show this help
  version                    Show version

Examples:
  image-prompt generate "a fox in a forest"
  image-prompt style "mountain village" watercolor
  image-prompt enhance "a cat sitting on a windowsill"
  image-prompt template portrait
  image-prompt random
  image-prompt translate "一只猫坐在樱花树下"
  image-prompt save hero "a knight on a cliff, dramatic lighting"

Data: $HOME/.image-prompt/
EOF
}

# ---------------------------------------------------------------------------
# Main Router
# ---------------------------------------------------------------------------

case "${1:-help}" in
    generate)   shift; cmd_generate "$@" ;;
    style)      shift; cmd_style "$@" ;;
    enhance)    shift; cmd_enhance "$@" ;;
    negative)   cmd_negative ;;
    template)   shift; cmd_template "$@" ;;
    random)     cmd_random ;;
    translate)  shift; cmd_translate "$@" ;;
    save)       shift; cmd_save "$@" ;;
    list)       cmd_list ;;
    search)     shift; cmd_search "$@" ;;
    help|-h)    show_help ;;
    version|-v) echo "image-prompt v$VERSION" ;;
    *)          echo "Unknown command: $1"; echo ""; show_help; exit 1 ;;
esac
