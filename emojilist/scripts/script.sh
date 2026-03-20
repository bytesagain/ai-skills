#!/usr/bin/env bash
# ============================================================================
# EmojiList — Emoji Reference & Search Tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
# ============================================================================
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="emojilist"

# --- Colors ----------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# --- Helpers ---------------------------------------------------------------
info()    { echo -e "${BLUE}ℹ${NC} $*"; }
success() { echo -e "${GREEN}✔${NC} $*"; }
warn()    { echo -e "${YELLOW}⚠${NC} $*"; }
error()   { echo -e "${RED}✖${NC} $*" >&2; }
die()     { error "$@"; exit 1; }

# --- Emoji Database -------------------------------------------------------
# Format: "emoji|name|category"
EMOJI_DB=(
    # Faces - Smileys
    "😀|grinning face|faces"
    "😃|grinning face with big eyes|faces"
    "😄|grinning face with smiling eyes|faces"
    "😁|beaming face with smiling eyes|faces"
    "😆|grinning squinting face|faces"
    "😅|grinning face with sweat|faces"
    "🤣|rolling on the floor laughing|faces"
    "😂|face with tears of joy|faces"
    "🙂|slightly smiling face|faces"
    "🙃|upside down face|faces"
    "😉|winking face|faces"
    "😊|smiling face with smiling eyes|faces"
    "😇|smiling face with halo|faces"
    "🥰|smiling face with hearts|faces"
    "😍|smiling face with heart eyes|faces"
    "🤩|star struck|faces"
    "😘|face blowing a kiss|faces"
    "😗|kissing face|faces"
    "😚|kissing face with closed eyes|faces"
    "😙|kissing face with smiling eyes|faces"
    "🥲|smiling face with tear|faces"
    "😋|face savoring food|faces"
    "😛|face with tongue|faces"
    "😜|winking face with tongue|faces"
    "🤪|zany face|faces"
    "😝|squinting face with tongue|faces"
    "🤑|money mouth face|faces"
    "🤗|hugging face|faces"
    "🤭|face with hand over mouth|faces"
    "🤫|shushing face|faces"
    "🤔|thinking face|faces"
    "😐|neutral face|faces"
    "😑|expressionless face|faces"
    "😶|face without mouth|faces"
    "😏|smirking face|faces"
    "😒|unamused face|faces"
    "🙄|face with rolling eyes|faces"
    "😬|grimacing face|faces"
    "😮‍💨|face exhaling|faces"
    "🤥|lying face|faces"
    "😌|relieved face|faces"
    "😔|pensive face|faces"
    "😪|sleepy face|faces"
    "🤤|drooling face|faces"
    "😴|sleeping face|faces"
    "😷|face with medical mask|faces"
    "🤒|face with thermometer|faces"
    "🤕|face with head bandage|faces"
    "🤢|nauseated face|faces"
    "🤮|face vomiting|faces"
    "🥴|woozy face|faces"
    "😵|face with crossed out eyes|faces"
    "🤯|exploding head|faces"
    "😎|smiling face with sunglasses|faces"
    "🥸|disguised face|faces"
    "🤓|nerd face|faces"
    "😱|face screaming in fear|faces"
    "😨|fearful face|faces"
    "😰|anxious face with sweat|faces"
    "😥|sad but relieved face|faces"
    "😢|crying face|faces"
    "😭|loudly crying face|faces"
    "🥺|pleading face|faces"
    "😤|face with steam from nose|faces"
    "😡|pouting face|faces"
    "😠|angry face|faces"
    "🤬|face with symbols on mouth|faces"

    # Gestures / Hands
    "👋|waving hand|gestures"
    "🤚|raised back of hand|gestures"
    "🖐️|hand with fingers splayed|gestures"
    "✋|raised hand|gestures"
    "🖖|vulcan salute|gestures"
    "👌|ok hand|gestures"
    "🤌|pinched fingers|gestures"
    "🤏|pinching hand|gestures"
    "✌️|victory hand|gestures"
    "🤞|crossed fingers|gestures"
    "🤟|love you gesture|gestures"
    "🤘|sign of the horns|gestures"
    "🤙|call me hand|gestures"
    "👈|backhand index pointing left|gestures"
    "👉|backhand index pointing right|gestures"
    "👆|backhand index pointing up|gestures"
    "👇|backhand index pointing down|gestures"
    "☝️|index pointing up|gestures"
    "👍|thumbs up|gestures"
    "👎|thumbs down|gestures"
    "✊|raised fist|gestures"
    "👊|oncoming fist|gestures"
    "🤛|left facing fist|gestures"
    "🤜|right facing fist|gestures"
    "👏|clapping hands|gestures"
    "🙌|raising hands|gestures"
    "👐|open hands|gestures"
    "🤲|palms up together|gestures"
    "🙏|folded hands|gestures"
    "💪|flexed biceps|gestures"

    # Hearts & Love
    "❤️|red heart|hearts"
    "🧡|orange heart|hearts"
    "💛|yellow heart|hearts"
    "💚|green heart|hearts"
    "💙|blue heart|hearts"
    "💜|purple heart|hearts"
    "🖤|black heart|hearts"
    "🤍|white heart|hearts"
    "🤎|brown heart|hearts"
    "💔|broken heart|hearts"
    "💕|two hearts|hearts"
    "💞|revolving hearts|hearts"
    "💓|beating heart|hearts"
    "💗|growing heart|hearts"
    "💖|sparkling heart|hearts"
    "💘|heart with arrow|hearts"
    "💝|heart with ribbon|hearts"

    # Animals
    "🐶|dog face|animals"
    "🐱|cat face|animals"
    "🐭|mouse face|animals"
    "🐹|hamster|animals"
    "🐰|rabbit face|animals"
    "🦊|fox|animals"
    "🐻|bear|animals"
    "🐼|panda|animals"
    "🐨|koala|animals"
    "🐯|tiger face|animals"
    "🦁|lion|animals"
    "🐮|cow face|animals"
    "🐷|pig face|animals"
    "🐸|frog|animals"
    "🐵|monkey face|animals"
    "🙈|see no evil monkey|animals"
    "🙉|hear no evil monkey|animals"
    "🙊|speak no evil monkey|animals"
    "🐔|chicken|animals"
    "🐧|penguin|animals"
    "🐦|bird|animals"
    "🦅|eagle|animals"
    "🦆|duck|animals"
    "🦉|owl|animals"
    "🐺|wolf|animals"
    "🐗|boar|animals"
    "🐴|horse face|animals"
    "🦄|unicorn|animals"
    "🐝|honeybee|animals"
    "🐛|bug|animals"
    "🦋|butterfly|animals"
    "🐌|snail|animals"
    "🐙|octopus|animals"
    "🦑|squid|animals"
    "🦀|crab|animals"
    "🐠|tropical fish|animals"
    "🐟|fish|animals"
    "🐬|dolphin|animals"
    "🐳|spouting whale|animals"
    "🐋|whale|animals"
    "🦈|shark|animals"
    "🐊|crocodile|animals"
    "🐘|elephant|animals"
    "🦏|rhinoceros|animals"
    "🦒|giraffe|animals"
    "🐪|camel|animals"
    "🐫|two hump camel|animals"
    "🦙|llama|animals"
    "🐍|snake|animals"
    "🦎|lizard|animals"
    "🐢|turtle|animals"
    "🦖|t-rex dinosaur|animals"
    "🦕|sauropod dinosaur|animals"

    # Food & Drink
    "🍎|red apple|food"
    "🍐|pear|food"
    "🍊|tangerine orange|food"
    "🍋|lemon|food"
    "🍌|banana|food"
    "🍉|watermelon|food"
    "🍇|grapes|food"
    "🍓|strawberry|food"
    "🫐|blueberries|food"
    "🍈|melon|food"
    "🍒|cherries|food"
    "🍑|peach|food"
    "🥭|mango|food"
    "🍍|pineapple|food"
    "🥝|kiwi fruit|food"
    "🍅|tomato|food"
    "🥑|avocado|food"
    "🥦|broccoli|food"
    "🥬|leafy green|food"
    "🥒|cucumber|food"
    "🌶️|hot pepper chili|food"
    "🫑|bell pepper|food"
    "🌽|corn|food"
    "🥕|carrot|food"
    "🧄|garlic|food"
    "🧅|onion|food"
    "🥔|potato|food"
    "🍠|sweet potato|food"
    "🍕|pizza|food"
    "🍔|hamburger burger|food"
    "🍟|french fries|food"
    "🌭|hot dog|food"
    "🥪|sandwich|food"
    "🌮|taco|food"
    "🌯|burrito|food"
    "🍣|sushi|food"
    "🍱|bento box|food"
    "🥟|dumpling|food"
    "🍜|steaming bowl noodles ramen|food"
    "🍝|spaghetti pasta|food"
    "🍛|curry rice|food"
    "🍲|pot of food stew|food"
    "🥗|green salad|food"
    "🍿|popcorn|food"
    "🧈|butter|food"
    "🥞|pancakes|food"
    "🧇|waffle|food"
    "🍞|bread|food"
    "🥐|croissant|food"
    "🥖|baguette bread|food"
    "🧁|cupcake|food"
    "🍰|shortcake cake|food"
    "🎂|birthday cake|food"
    "🍩|doughnut donut|food"
    "🍪|cookie|food"
    "🍫|chocolate bar|food"
    "🍬|candy|food"
    "🍭|lollipop|food"
    "🍮|custard pudding|food"
    "☕|hot beverage coffee|food"
    "🍵|teacup tea|food"
    "🥤|cup with straw|food"
    "🧃|beverage box juice|food"
    "🍺|beer mug|food"
    "🍻|clinking beer mugs cheers|food"
    "🥂|clinking glasses champagne|food"
    "🍷|wine glass|food"
    "🍸|cocktail glass martini|food"
    "🥃|tumbler glass whiskey|food"
    "🧋|bubble tea boba|food"

    # Nature & Weather
    "🌸|cherry blossom|nature"
    "🌹|rose|nature"
    "🌺|hibiscus|nature"
    "🌻|sunflower|nature"
    "🌷|tulip|nature"
    "🌱|seedling|nature"
    "🌲|evergreen tree|nature"
    "🌳|deciduous tree|nature"
    "🌴|palm tree|nature"
    "🍀|four leaf clover|nature"
    "🍁|maple leaf|nature"
    "🍂|fallen leaf|nature"
    "🍃|leaf fluttering in wind|nature"
    "🌍|globe earth|nature"
    "🌙|crescent moon|nature"
    "⭐|star|nature"
    "🌟|glowing star|nature"
    "✨|sparkles|nature"
    "⚡|lightning zap|nature"
    "🔥|fire flame hot|nature"
    "💧|droplet water|nature"
    "🌊|ocean wave|nature"
    "☀️|sun|nature"
    "🌈|rainbow|nature"
    "❄️|snowflake|nature"
    "🌪️|tornado|nature"

    # Objects & Tech
    "💻|laptop computer|tech"
    "🖥️|desktop computer|tech"
    "⌨️|keyboard|tech"
    "🖱️|computer mouse|tech"
    "📱|mobile phone|tech"
    "📞|telephone|tech"
    "📧|email|tech"
    "💾|floppy disk|tech"
    "💿|optical disk cd|tech"
    "🔌|electric plug|tech"
    "🔋|battery|tech"
    "💡|light bulb idea|tech"
    "🔧|wrench tool|tech"
    "🔨|hammer|tech"
    "⚙️|gear settings|tech"
    "🔒|locked|tech"
    "🔓|unlocked|tech"
    "🔑|key|tech"
    "🗝️|old key|tech"
    "📦|package box|tech"
    "🗑️|wastebasket trash|tech"
    "📋|clipboard|tech"
    "📝|memo note|tech"
    "📎|paperclip|tech"
    "📊|bar chart|tech"
    "📈|chart increasing|tech"
    "📉|chart decreasing|tech"

    # Travel & Places
    "🚗|automobile car|travel"
    "🚕|taxi|travel"
    "🚌|bus|travel"
    "🚎|trolleybus|travel"
    "🏎️|racing car|travel"
    "🚓|police car|travel"
    "🚑|ambulance|travel"
    "🚒|fire engine|travel"
    "✈️|airplane|travel"
    "🚀|rocket|travel"
    "🛸|flying saucer ufo|travel"
    "🚁|helicopter|travel"
    "🚂|locomotive train|travel"
    "🚢|ship boat|travel"
    "🏠|house|travel"
    "🏢|office building|travel"
    "🏥|hospital|travel"
    "🏫|school|travel"
    "🏰|castle|travel"
    "⛪|church|travel"
    "🗼|tokyo tower|travel"
    "🗽|statue of liberty|travel"

    # Activities & Sports
    "⚽|soccer ball football|sports"
    "🏀|basketball|sports"
    "🏈|american football|sports"
    "⚾|baseball|sports"
    "🎾|tennis|sports"
    "🏐|volleyball|sports"
    "🏓|table tennis ping pong|sports"
    "🏸|badminton|sports"
    "🥊|boxing glove|sports"
    "🏊|person swimming|sports"
    "🚴|person biking|sports"
    "🏃|person running|sports"
    "🧗|person climbing|sports"
    "🎯|bullseye target|sports"
    "🎮|video game controller|sports"
    "🎲|game die dice|sports"
    "♟️|chess pawn|sports"
    "🎳|bowling|sports"
    "🏆|trophy winner|sports"
    "🥇|gold medal first|sports"
    "🥈|silver medal second|sports"
    "🥉|bronze medal third|sports"

    # Symbols & Signs
    "✅|check mark button|symbols"
    "❌|cross mark|symbols"
    "❓|question mark|symbols"
    "❗|exclamation mark|symbols"
    "⚠️|warning|symbols"
    "🚫|prohibited|symbols"
    "♻️|recycling symbol|symbols"
    "✏️|pencil|symbols"
    "📌|pushpin|symbols"
    "🏷️|label tag|symbols"
    "🔴|red circle|symbols"
    "🟠|orange circle|symbols"
    "🟡|yellow circle|symbols"
    "🟢|green circle|symbols"
    "🔵|blue circle|symbols"
    "🟣|purple circle|symbols"
    "⚫|black circle|symbols"
    "⚪|white circle|symbols"
    "🟥|red square|symbols"
    "🟧|orange square|symbols"
    "🟨|yellow square|symbols"
    "🟩|green square|symbols"
    "🟦|blue square|symbols"
    "🟪|purple square|symbols"
    "⬛|black large square|symbols"
    "⬜|white large square|symbols"
    "▶️|play button|symbols"
    "⏸️|pause button|symbols"
    "⏹️|stop button|symbols"
    "🔀|shuffle|symbols"
    "🔁|repeat|symbols"
    "💯|hundred points|symbols"
    "➕|plus|symbols"
    "➖|minus|symbols"
    "➗|divide|symbols"
    "✖️|multiply|symbols"
    "♾️|infinity|symbols"
    "💲|dollar sign money|symbols"
    "©️|copyright|symbols"
    "®️|registered|symbols"
    "™️|trade mark|symbols"

    # Flags (popular)
    "🇺🇸|united states usa flag|flags"
    "🇬🇧|united kingdom uk flag|flags"
    "🇨🇳|china flag|flags"
    "🇯🇵|japan flag|flags"
    "🇰🇷|south korea flag|flags"
    "🇫🇷|france flag|flags"
    "🇩🇪|germany flag|flags"
    "🇪🇸|spain flag|flags"
    "🇮🇹|italy flag|flags"
    "🇧🇷|brazil flag|flags"
    "🇷🇺|russia flag|flags"
    "🇮🇳|india flag|flags"
    "🇦🇺|australia flag|flags"
    "🇨🇦|canada flag|flags"
    "🇲🇽|mexico flag|flags"
    "🏳️‍🌈|rainbow flag pride|flags"
    "🏴‍☠️|pirate flag|flags"
    "🏁|checkered flag racing|flags"
)

# All categories
CATEGORIES=("faces" "gestures" "hearts" "animals" "food" "nature" "tech" "travel" "sports" "symbols" "flags")

# --- Usage -----------------------------------------------------------------
usage() {
    cat <<EOF
${BOLD}EmojiList v${VERSION}${NC} — Emoji Reference & Search Tool
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

${BOLD}Usage:${NC}
  ${SCRIPT_NAME} <command> [arguments]

${BOLD}Commands:${NC}
  search   <keyword>       Search emoji by name/keyword
  category <name>          List emoji in a category
  random   [count]         Show random emoji (default: 5)
  popular                  Show most commonly used emoji
  list                     List all categories

${BOLD}Options:${NC}
  -h, --help               Show this help
  -v, --version            Show version

${BOLD}Categories:${NC}
  faces, gestures, hearts, animals, food,
  nature, tech, travel, sports, symbols, flags

${BOLD}Examples:${NC}
  ${SCRIPT_NAME} search heart
  ${SCRIPT_NAME} search fire
  ${SCRIPT_NAME} category animals
  ${SCRIPT_NAME} random 10
  ${SCRIPT_NAME} popular
  ${SCRIPT_NAME} list
EOF
}

# --- Commands --------------------------------------------------------------

cmd_search() {
    [[ -z "${1:-}" ]] && die "Missing argument: <keyword>"
    local keyword
    keyword=$(echo "$1" | tr '[:upper:]' '[:lower:]')

    info "Searching for: ${CYAN}${keyword}${NC}"
    echo ""

    local count=0
    for entry in "${EMOJI_DB[@]}"; do
        IFS='|' read -r emoji name category <<< "$entry"
        local name_lower
        name_lower=$(echo "$name" | tr '[:upper:]' '[:lower:]')
        if [[ "$name_lower" == *"$keyword"* ]]; then
            printf "  %s  %-40s  [%s]\n" "$emoji" "$name" "$category"
            count=$((count + 1))
        fi
    done

    echo ""
    if [[ $count -eq 0 ]]; then
        warn "No emoji found matching '${keyword}'"
        info "Try broader terms like: face, heart, animal, food, star, hand"
        return 1
    else
        success "Found ${count} emoji matching '${keyword}'"
    fi
}

cmd_category() {
    [[ -z "${1:-}" ]] && die "Missing argument: <category> (use 'list' to see categories)"
    local cat
    cat=$(echo "$1" | tr '[:upper:]' '[:lower:]')

    # Check if category exists
    local found=0
    for c in "${CATEGORIES[@]}"; do
        [[ "$c" == "$cat" ]] && found=1 && break
    done
    [[ $found -eq 0 ]] && die "Unknown category '${cat}'. Use '${SCRIPT_NAME} list' to see available categories."

    info "Category: ${CYAN}${cat}${NC}"
    echo ""

    local count=0
    for entry in "${EMOJI_DB[@]}"; do
        IFS='|' read -r emoji name category <<< "$entry"
        if [[ "$category" == "$cat" ]]; then
            printf "  %s  %s\n" "$emoji" "$name"
            count=$((count + 1))
        fi
    done

    echo ""
    success "Total: ${count} emoji in '${cat}'"
}

cmd_random() {
    local count="${1:-5}"
    # Validate count is a number
    [[ "$count" =~ ^[0-9]+$ ]] || die "Count must be a number"
    [[ "$count" -lt 1 ]] && count=1
    [[ "$count" -gt 50 ]] && count=50

    local db_size=${#EMOJI_DB[@]}
    info "Random ${count} emoji (from ${db_size} total):"
    echo ""

    # Generate random indices
    local selected=0
    local used_indices=()
    while [[ $selected -lt $count ]] && [[ $selected -lt $db_size ]]; do
        local idx=$((RANDOM % db_size))
        # Check if already used
        local already=0
        for used in "${used_indices[@]+"${used_indices[@]}"}"; do
            [[ "$used" -eq "$idx" ]] && already=1 && break
        done
        [[ $already -eq 1 ]] && continue

        used_indices+=("$idx")
        IFS='|' read -r emoji name category <<< "${EMOJI_DB[$idx]}"
        printf "  %s  %-40s  [%s]\n" "$emoji" "$name" "$category"
        selected=$((selected + 1))
    done
    echo ""
}

cmd_popular() {
    info "Most commonly used emoji:"
    echo ""

    local popular_emoji=(
        "😂|face with tears of joy|Most used on social media"
        "❤️|red heart|Universal love symbol"
        "🤣|rolling on the floor laughing|Top reaction emoji"
        "👍|thumbs up|Quick approval"
        "😭|loudly crying face|Emotional reactions"
        "🙏|folded hands|Please/thank you/prayer"
        "😘|face blowing a kiss|Affection"
        "🥰|smiling face with hearts|Love and warmth"
        "😍|smiling face with heart eyes|Adoration"
        "😊|smiling face with smiling eyes|Friendly positivity"
        "🔥|fire|Trending/hot/awesome"
        "😁|beaming face with smiling eyes|Joyful"
        "💕|two hearts|Love"
        "🥺|pleading face|Puppy eyes / begging"
        "😅|grinning face with sweat|Nervous/relief"
        "🤗|hugging face|Warm embrace"
        "🤔|thinking face|Pondering/questioning"
        "😎|smiling face with sunglasses|Cool"
        "👏|clapping hands|Applause/well done"
        "✨|sparkles|Magic/excitement/new"
        "💯|hundred points|Perfect score"
        "🎉|party popper|Celebration"
        "💪|flexed biceps|Strength/power"
        "🤷|person shrugging|Who knows"
        "👀|eyes|Looking/attention"
    )

    local rank=0
    for entry in "${popular_emoji[@]}"; do
        rank=$((rank + 1))
        IFS='|' read -r emoji name note <<< "$entry"
        printf "  %2d. %s  %-35s  ${CYAN}%s${NC}\n" "$rank" "$emoji" "$name" "$note"
    done
    echo ""
    success "Top ${rank} most popular emoji worldwide"
}

cmd_list() {
    info "Available emoji categories:"
    echo ""

    for cat in "${CATEGORIES[@]}"; do
        local count=0
        local sample=""
        local sample_count=0
        for entry in "${EMOJI_DB[@]}"; do
            IFS='|' read -r emoji name category <<< "$entry"
            if [[ "$category" == "$cat" ]]; then
                count=$((count + 1))
                if [[ $sample_count -lt 5 ]]; then
                    sample+="$emoji "
                    sample_count=$((sample_count + 1))
                fi
            fi
        done
        printf "  ${BOLD}%-12s${NC} (%3d emoji)  %s\n" "$cat" "$count" "$sample"
    done

    echo ""
    local total=${#EMOJI_DB[@]}
    success "Total: ${total} emoji across ${#CATEGORIES[@]} categories"
    echo ""
    info "Usage: ${SCRIPT_NAME} category <name>"
}

# --- Main ------------------------------------------------------------------
main() {
    [[ $# -eq 0 ]] && { usage; exit 0; }

    case "${1}" in
        -h|--help)      usage ;;
        -v|--version)   echo "${SCRIPT_NAME} v${VERSION}" ;;
        search)         shift; cmd_search "${1:-}" ;;
        category)       shift; cmd_category "${1:-}" ;;
        random)         shift; cmd_random "${1:-}" ;;
        popular)        cmd_popular ;;
        list)           cmd_list ;;
        *)              die "Unknown command: $1 (try --help)" ;;
    esac
}

main "$@"
