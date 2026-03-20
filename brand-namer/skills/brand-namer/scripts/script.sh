#!/usr/bin/env bash
# brand-namer - Brand name generation and management tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="3.0.3"
DATA_DIR="${BRAND_NAMER_DIR:-$HOME/.brand-namer}"
SAVED_FILE="$DATA_DIR/saved.txt"
HISTORY_LOG="$DATA_DIR/history.log"

mkdir -p "$DATA_DIR"

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$HISTORY_LOG"
}

# ---------------------------------------------------------------------------
# Word banks by industry
# ---------------------------------------------------------------------------
TECH_PREFIXES=(cyber cloud net byte data pixel code algo flux sync quantum ion digi vox nova)
TECH_ROOTS=(stack forge pulse wave link node grid core beam shift spark drift arc mesh vault)
TECH_SUFFIXES=(ly io ai hub lab ware bit fy os ix)

FOOD_PREFIXES=(fresh green farm pure tasty golden sweet ripe crisp bright sun harvest wild herb)
FOOD_ROOTS=(bite bowl plate spoon fork feast crop mill grain brew blend churn roast zest bake)
FOOD_SUFFIXES=(ly ful co hub lab io ery ist ish ette)

FASHION_PREFIXES=(luxe chic vogue pure bold sleek mod glam haute noir silk lush vivid regal posh)
FASHION_ROOTS=(thread stitch loom weave drape blend tone shade edge form line curve frame style mode)
FASHION_SUFFIXES=(ly ist ette co io ful ery ique ista haus)

HEALTH_PREFIXES=(vita zen pure well bio calm fit glow core heal bloom prime vital thrive flex)
HEALTH_ROOTS=(pulse wave flow spring root leaf bloom stem seed bark herb tonic balm aura spark)
HEALTH_SUFFIXES=(ly ful io co hub lab ify ics ity ness)

FINANCE_PREFIXES=(fin cap fund apex prime vault ledger mint equity trust clear peak solid swift smart)
FINANCE_ROOTS=(stack forge pulse wave link node grid coin gain yield flow bank bond trade port)
FINANCE_SUFFIXES=(ly io ai hub fy co ium ity ics ware)

# ---------------------------------------------------------------------------
# Utility: pick random element from array
# ---------------------------------------------------------------------------
pick_random() {
    local arr=("$@")
    local len=${#arr[@]}
    local idx=$((RANDOM % len))
    echo "${arr[$idx]}"
}

# ---------------------------------------------------------------------------
# Utility: capitalize first letter
# ---------------------------------------------------------------------------
capitalize() {
    local word="$1"
    local first upper rest
    first="${word:0:1}"
    upper=$(echo "$first" | tr '[:lower:]' '[:upper:]')
    rest="${word:1}"
    echo "${upper}${rest}"
}

# ---------------------------------------------------------------------------
# Utility: count syllables (heuristic)
# ---------------------------------------------------------------------------
count_syllables() {
    local name
    name=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    local len=${#name}
    local count=0
    local prev_vowel=0

    for ((i = 0; i < len; i++)); do
        local ch="${name:$i:1}"
        case "$ch" in
            a|e|i|o|u|y)
                if [[ $prev_vowel -eq 0 ]]; then
                    count=$((count + 1))
                fi
                prev_vowel=1
                ;;
            *)
                prev_vowel=0
                ;;
        esac
    done

    # At minimum 1 syllable
    if [[ $count -lt 1 ]]; then
        count=1
    fi
    echo "$count"
}

# ---------------------------------------------------------------------------
# Utility: readability score (simple heuristic 1-10)
# ---------------------------------------------------------------------------
readability_score() {
    local name="$1"
    local len=${#name}
    local syllables
    syllables=$(count_syllables "$name")
    local score=10

    # Penalize long names
    if [[ $len -gt 12 ]]; then
        score=$((score - 2))
    elif [[ $len -gt 8 ]]; then
        score=$((score - 1))
    fi

    # Penalize many syllables
    if [[ $syllables -gt 4 ]]; then
        score=$((score - 3))
    elif [[ $syllables -gt 3 ]]; then
        score=$((score - 2))
    elif [[ $syllables -gt 2 ]]; then
        score=$((score - 1))
    fi

    # Bonus for short punchy names
    if [[ $len -le 5 && $syllables -le 2 ]]; then
        score=$((score + 1))
    fi

    # Clamp to 1-10
    if [[ $score -gt 10 ]]; then
        score=10
    elif [[ $score -lt 1 ]]; then
        score=1
    fi

    echo "$score"
}

# ---------------------------------------------------------------------------
# Command: generate <industry> [count]
# ---------------------------------------------------------------------------
cmd_generate() {
    local industry="${1:-}"
    local count="${2:-10}"

    if [[ -z "$industry" ]]; then
        echo "Usage: brand-namer generate <industry> [count]"
        echo "Industries: tech, food, fashion, health, finance"
        return 1
    fi

    local -a prefixes roots suffixes

    case "$industry" in
        tech)
            prefixes=("${TECH_PREFIXES[@]}")
            roots=("${TECH_ROOTS[@]}")
            suffixes=("${TECH_SUFFIXES[@]}")
            ;;
        food)
            prefixes=("${FOOD_PREFIXES[@]}")
            roots=("${FOOD_ROOTS[@]}")
            suffixes=("${FOOD_SUFFIXES[@]}")
            ;;
        fashion)
            prefixes=("${FASHION_PREFIXES[@]}")
            roots=("${FASHION_ROOTS[@]}")
            suffixes=("${FASHION_SUFFIXES[@]}")
            ;;
        health)
            prefixes=("${HEALTH_PREFIXES[@]}")
            roots=("${HEALTH_ROOTS[@]}")
            suffixes=("${HEALTH_SUFFIXES[@]}")
            ;;
        finance)
            prefixes=("${FINANCE_PREFIXES[@]}")
            roots=("${FINANCE_ROOTS[@]}")
            suffixes=("${FINANCE_SUFFIXES[@]}")
            ;;
        *)
            echo "Unknown industry: $industry"
            echo "Supported: tech, food, fashion, health, finance"
            return 1
            ;;
    esac

    echo "=== Brand Names for $industry (${count} candidates) ==="
    echo ""

    for ((i = 1; i <= count; i++)); do
        local style=$((RANDOM % 3))
        local name=""

        case $style in
            0)
                # prefix + root
                local p r
                p=$(pick_random "${prefixes[@]}")
                r=$(pick_random "${roots[@]}")
                name="$(capitalize "$p")$(capitalize "$r")"
                ;;
            1)
                # root + suffix
                local r s
                r=$(pick_random "${roots[@]}")
                s=$(pick_random "${suffixes[@]}")
                name="$(capitalize "$r")${s}"
                ;;
            2)
                # prefix + root + suffix
                local p r s
                p=$(pick_random "${prefixes[@]}")
                r=$(pick_random "${roots[@]}")
                s=$(pick_random "${suffixes[@]}")
                name="$(capitalize "$p")$(capitalize "$r")${s}"
                ;;
        esac

        printf "  %2d. %s\n" "$i" "$name"
    done

    echo ""
    echo "Tip: Use 'brand-namer check <name>' to verify domain availability."
    log_action "generate $industry $count"
}

# ---------------------------------------------------------------------------
# Command: check <name>
# ---------------------------------------------------------------------------
cmd_check() {
    local name="${1:-}"

    if [[ -z "$name" ]]; then
        echo "Usage: brand-namer check <name>"
        return 1
    fi

    local lower_name
    lower_name=$(echo "$name" | tr '[:upper:]' '[:lower:]')

    echo "=== Domain Check: $name ==="
    echo ""

    local tlds=("com" "io" "co")

    for tld in "${tlds[@]}"; do
        local domain="${lower_name}.${tld}"
        local result
        result=$(dig +short A "$domain" 2>/dev/null || true)

        if [[ -n "$result" ]]; then
            echo "  ${domain}  →  TAKEN (resolves to ${result})"
        else
            echo "  ${domain}  →  likely available (no A record)"
        fi
    done

    echo ""
    echo "Note: No A record suggests availability but is not a guarantee."
    echo "      Check your registrar to confirm."
    log_action "check $name"
}

# ---------------------------------------------------------------------------
# Command: analyze <name>
# ---------------------------------------------------------------------------
cmd_analyze() {
    local name="${1:-}"

    if [[ -z "$name" ]]; then
        echo "Usage: brand-namer analyze <name>"
        return 1
    fi

    local len=${#name}
    local syllables
    syllables=$(count_syllables "$name")
    local score
    score=$(readability_score "$name")

    echo "=== Name Analysis: $name ==="
    echo ""
    echo "  Length:       ${len} characters"
    echo "  Syllables:   ${syllables} (estimated)"
    echo "  Readability:  ${score}/10"
    echo ""

    # Length assessment
    if [[ $len -le 5 ]]; then
        echo "  ✓ Very short — easy to type and remember"
    elif [[ $len -le 8 ]]; then
        echo "  ✓ Short — good length for a brand"
    elif [[ $len -le 12 ]]; then
        echo "  ~ Medium — acceptable but consider shorter"
    else
        echo "  ✗ Long — may be hard to remember"
    fi

    # Syllable assessment
    if [[ $syllables -le 2 ]]; then
        echo "  ✓ Punchy — easy to say"
    elif [[ $syllables -le 3 ]]; then
        echo "  ✓ Moderate — rolls off the tongue"
    else
        echo "  ✗ Complex — might be a mouthful"
    fi

    # Language adaptability
    echo ""
    echo "  Language notes:"
    local has_hard=0
    local lower
    lower=$(echo "$name" | tr '[:upper:]' '[:lower:]')
    if echo "$lower" | grep -qE '[xzq]'; then
        echo "    - Contains letters (x/z/q) that may be harder in some languages"
        has_hard=1
    fi
    if echo "$lower" | grep -qE 'th|ph|ght'; then
        echo "    - Contains English-specific clusters (th/ph/ght)"
        has_hard=1
    fi
    if [[ $has_hard -eq 0 ]]; then
        echo "    - Uses common consonant-vowel patterns"
        echo "    - Generally adaptable across languages"
    fi

    log_action "analyze $name"
}

# ---------------------------------------------------------------------------
# Command: combine <word1> <word2>
# ---------------------------------------------------------------------------
cmd_combine() {
    local word1="${1:-}"
    local word2="${2:-}"

    if [[ -z "$word1" || -z "$word2" ]]; then
        echo "Usage: brand-namer combine <word1> <word2>"
        return 1
    fi

    local w1 w2
    w1=$(echo "$word1" | tr '[:upper:]' '[:lower:]')
    w2=$(echo "$word2" | tr '[:upper:]' '[:lower:]')
    local w1_cap w2_cap
    w1_cap=$(capitalize "$w1")
    w2_cap=$(capitalize "$w2")

    echo "=== Combinations: $word1 + $word2 ==="
    echo ""

    # CamelCase both ways
    echo "  1. ${w1_cap}${w2_cap}"
    echo "  2. ${w2_cap}${w1_cap}"

    # Blend: first half of word1 + second half of word2
    local half1=$(( ${#w1} / 2 ))
    local half2=$(( ${#w2} / 2 ))
    local blend1="${w1:0:$half1}${w2:$half2}"
    local blend2="${w2:0:$half2}${w1:$half1}"
    echo "  3. $(capitalize "$blend1")"
    echo "  4. $(capitalize "$blend2")"

    # With separator
    echo "  5. ${w1_cap}-${w2_cap}"
    echo "  6. ${w1_cap}&${w2_cap}"

    # Overlap: if last char of w1 matches first char of w2
    local last1="${w1: -1}"
    local first2="${w2:0:1}"
    if [[ "$last1" == "$first2" ]]; then
        local overlap="${w1}${w2:1}"
        echo "  7. $(capitalize "$overlap")  (overlap blend)"
    fi

    # Abbreviation combo
    local abbrev="${w1:0:3}${w2:0:3}"
    echo "  8. $(capitalize "$abbrev")"

    echo ""
    echo "Tip: Use 'brand-namer analyze <name>' to evaluate any of these."
    log_action "combine $word1 $word2"
}

# ---------------------------------------------------------------------------
# Command: prefix <word>
# ---------------------------------------------------------------------------
cmd_prefix() {
    local word="${1:-}"

    if [[ -z "$word" ]]; then
        echo "Usage: brand-namer prefix <word>"
        return 1
    fi

    local lower
    lower=$(echo "$word" | tr '[:upper:]' '[:lower:]')

    local brand_prefixes=("re" "un" "pro" "super" "meta" "neo" "hyper" "ultra" "omni" "zen")

    echo "=== Prefix Variants: $word ==="
    echo ""

    local idx=1
    for p in "${brand_prefixes[@]}"; do
        local variant="${p}${lower}"
        printf "  %2d. %s\n" "$idx" "$(capitalize "$variant")"
        idx=$((idx + 1))
    done

    echo ""
    echo "Tip: Use 'brand-namer check <name>' to verify domain availability."
    log_action "prefix $word"
}

# ---------------------------------------------------------------------------
# Command: suffix <word>
# ---------------------------------------------------------------------------
cmd_suffix() {
    local word="${1:-}"

    if [[ -z "$word" ]]; then
        echo "Usage: brand-namer suffix <word>"
        return 1
    fi

    local lower
    lower=$(echo "$word" | tr '[:upper:]' '[:lower:]')

    local brand_suffixes=("ly" "ify" "hub" "lab" "io" "ai" "ful" "ist" "ware" "bit")

    echo "=== Suffix Variants: $word ==="
    echo ""

    local idx=1
    for s in "${brand_suffixes[@]}"; do
        local variant="${lower}${s}"
        printf "  %2d. %s\n" "$idx" "$(capitalize "$variant")"
        idx=$((idx + 1))
    done

    echo ""
    echo "Tip: Use 'brand-namer analyze <name>' to evaluate any of these."
    log_action "suffix $word"
}

# ---------------------------------------------------------------------------
# Command: save <name>
# ---------------------------------------------------------------------------
cmd_save() {
    local name="${1:-}"

    if [[ -z "$name" ]]; then
        echo "Usage: brand-namer save <name>"
        return 1
    fi

    # Check for duplicates
    if [[ -f "$SAVED_FILE" ]] && grep -q "| ${name}$" "$SAVED_FILE" 2>/dev/null; then
        echo "Already saved: $name"
        return 0
    fi

    echo "$(date '+%Y-%m-%d %H:%M') | ${name}" >> "$SAVED_FILE"
    echo "Saved: $name"

    local total=0
    if [[ -f "$SAVED_FILE" ]]; then
        total=$(wc -l < "$SAVED_FILE")
    fi
    echo "Total in shortlist: $total"
    log_action "save $name"
}

# ---------------------------------------------------------------------------
# Command: list
# ---------------------------------------------------------------------------
cmd_list() {
    if [[ ! -f "$SAVED_FILE" ]] || [[ ! -s "$SAVED_FILE" ]]; then
        echo "Shortlist is empty."
        echo "Use 'brand-namer save <name>' to add names."
        return 0
    fi

    echo "=== Saved Brand Names ==="
    echo ""

    local idx=1
    while IFS= read -r line; do
        local timestamp name
        timestamp=$(echo "$line" | cut -d'|' -f1 | xargs)
        name=$(echo "$line" | cut -d'|' -f2 | xargs)
        printf "  %2d. %-20s  (saved %s)\n" "$idx" "$name" "$timestamp"
        idx=$((idx + 1))
    done < "$SAVED_FILE"

    echo ""
    local total
    total=$(wc -l < "$SAVED_FILE")
    echo "Total: $total name(s)"
    log_action "list"
}

# ---------------------------------------------------------------------------
# Command: export <format>
# ---------------------------------------------------------------------------
cmd_export() {
    local format="${1:-}"

    if [[ -z "$format" ]]; then
        echo "Usage: brand-namer export <format>"
        echo "Formats: txt, csv, json"
        return 1
    fi

    if [[ ! -f "$SAVED_FILE" ]] || [[ ! -s "$SAVED_FILE" ]]; then
        echo "Nothing to export. Shortlist is empty."
        return 0
    fi

    case "$format" in
        txt)
            echo "# Brand Name Shortlist"
            echo "# Exported $(date '+%Y-%m-%d %H:%M')"
            echo ""
            while IFS= read -r line; do
                local name
                name=$(echo "$line" | cut -d'|' -f2 | xargs)
                echo "$name"
            done < "$SAVED_FILE"
            ;;
        csv)
            echo "name,saved_date"
            while IFS= read -r line; do
                local timestamp name
                timestamp=$(echo "$line" | cut -d'|' -f1 | xargs)
                name=$(echo "$line" | cut -d'|' -f2 | xargs)
                echo "\"${name}\",\"${timestamp}\""
            done < "$SAVED_FILE"
            ;;
        json)
            echo "{"
            echo "  \"exported\": \"$(date '+%Y-%m-%dT%H:%M:%S')\","
            echo "  \"names\": ["
            local total first=1
            total=$(wc -l < "$SAVED_FILE")
            while IFS= read -r line; do
                local timestamp name
                timestamp=$(echo "$line" | cut -d'|' -f1 | xargs)
                name=$(echo "$line" | cut -d'|' -f2 | xargs)
                if [[ $first -eq 1 ]]; then
                    first=0
                else
                    echo ","
                fi
                printf "    {\"name\": \"%s\", \"saved\": \"%s\"}" "$name" "$timestamp"
            done < "$SAVED_FILE"
            echo ""
            echo "  ]"
            echo "}"
            ;;
        *)
            echo "Unknown format: $format"
            echo "Supported: txt, csv, json"
            return 1
            ;;
    esac

    log_action "export $format"
}

# ---------------------------------------------------------------------------
# Command: help
# ---------------------------------------------------------------------------
show_help() {
    cat << 'EOF'
brand-namer v2.0.0 — Brand name generation tool

Usage: brand-namer <command> [args]

Commands:
  generate <industry> [count]   Generate brand name candidates (default 10)
  check <name>                  Check domain availability via dig
  analyze <name>                Analyze name quality and readability
  combine <word1> <word2>       Combine two words into brand variants
  prefix <word>                 Generate prefix variants
  suffix <word>                 Generate suffix variants
  save <name>                   Save a name to shortlist
  list                          List saved names
  export <format>               Export saved names (txt/csv/json)
  help                          Show this help
  version                       Show version

Industries: tech, food, fashion, health, finance
Data dir:   ~/.brand-namer/
EOF
}

# ---------------------------------------------------------------------------
# Main dispatch
# ---------------------------------------------------------------------------
case "${1:-help}" in
    generate)  shift; cmd_generate "$@" ;;
    check)     shift; cmd_check "$@" ;;
    analyze)   shift; cmd_analyze "$@" ;;
    combine)   shift; cmd_combine "$@" ;;
    prefix)    shift; cmd_prefix "$@" ;;
    suffix)    shift; cmd_suffix "$@" ;;
    save)      shift; cmd_save "$@" ;;
    list)      cmd_list ;;
    export)    shift; cmd_export "$@" ;;
    help|-h)   show_help ;;
    version|-v) echo "brand-namer v$VERSION" ;;
    *) echo "Unknown command: $1"; echo ""; show_help; exit 1 ;;
esac
