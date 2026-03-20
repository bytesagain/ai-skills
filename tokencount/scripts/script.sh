#!/usr/bin/env bash
# ============================================================================
# TokenCount — Text & Token Counter
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
# ============================================================================
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="tokencount"

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

# Resolve input: if it's a file, use the file; otherwise treat as text
resolve_input() {
    if [[ -f "${1:-}" ]]; then
        echo "file"
    else
        echo "text"
    fi
}

# --- Usage -----------------------------------------------------------------
usage() {
    cat <<EOF
${BOLD}TokenCount v${VERSION}${NC} — Text & Token Counter
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

${BOLD}Usage:${NC}
  ${SCRIPT_NAME} <command> [arguments]

${BOLD}Commands:${NC}
  count  <file|text>       Count words, lines, characters, sentences
  tokens <file>            Estimate LLM token count (chars/4 approx)
  freq   <file>            Word frequency analysis
  top    <file> [n]        Top N most common words (default: 20)
  diff   <file1> <file2>   Compare word counts between files

${BOLD}Options:${NC}
  -h, --help               Show this help
  -v, --version            Show version

${BOLD}Examples:${NC}
  ${SCRIPT_NAME} count README.md
  ${SCRIPT_NAME} count "Hello, world! This is a test."
  ${SCRIPT_NAME} tokens article.txt
  ${SCRIPT_NAME} freq   novel.txt
  ${SCRIPT_NAME} top    essay.txt 10
  ${SCRIPT_NAME} diff   draft1.txt draft2.txt
EOF
}

# --- Commands --------------------------------------------------------------

cmd_count() {
    [[ -z "${1:-}" ]] && die "Missing argument: <file> or <text>"
    local input_type
    input_type=$(resolve_input "$1")

    if [[ "$input_type" == "file" ]]; then
        info "Counting: ${CYAN}$1${NC} (file)"
        echo ""

        local chars words lines bytes
        chars=$(wc -m < "$1" | tr -d ' ')
        words=$(wc -w < "$1" | tr -d ' ')
        lines=$(wc -l < "$1" | tr -d ' ')
        bytes=$(wc -c < "$1" | tr -d ' ')

        # Count sentences (rough: split on .!?)
        local sentences
        sentences=$(grep -oE '[.!?]+' "$1" 2>/dev/null | wc -l | tr -d ' ')

        # Count paragraphs (blocks separated by blank lines)
        local paragraphs
        paragraphs=$(awk 'BEGIN{p=0; in_para=0} /^[[:space:]]*$/{if(in_para) in_para=0} /[^[:space:]]/{if(!in_para){p++; in_para=1}} END{print p}' "$1")

        # Average word length
        local avg_word_len
        if [[ "$words" -gt 0 ]]; then
            avg_word_len=$(awk '{for(i=1;i<=NF;i++){total+=length($i); count++}} END{if(count>0) printf "%.1f", total/count; else print "0"}' "$1")
        else
            avg_word_len="0"
        fi

        # Average words per sentence
        local avg_wps
        if [[ "$sentences" -gt 0 ]]; then
            avg_wps=$((words / sentences))
        else
            avg_wps="N/A"
        fi

        printf "  %-22s %s\n" "Characters:" "$chars"
        printf "  %-22s %s\n" "Characters (no space):" "$(tr -d '[:space:]' < "$1" | wc -m | tr -d ' ')"
        printf "  %-22s %s\n" "Words:" "$words"
        printf "  %-22s %s\n" "Lines:" "$lines"
        printf "  %-22s %s\n" "Sentences (approx):" "$sentences"
        printf "  %-22s %s\n" "Paragraphs:" "$paragraphs"
        printf "  %-22s %s\n" "Bytes:" "$bytes"
        printf "  %-22s %s\n" "Avg word length:" "${avg_word_len} chars"
        printf "  %-22s %s\n" "Avg words/sentence:" "$avg_wps"

        # Reading time estimate (200 wpm average)
        if [[ "$words" -gt 0 ]]; then
            local read_min=$((words / 200))
            local read_sec=$(( (words % 200) * 60 / 200 ))
            printf "  %-22s %s\n" "Reading time:" "${read_min}m ${read_sec}s (@ 200 wpm)"
        fi
    else
        # Text input
        local text="$1"
        info "Counting: inline text"
        echo ""

        local chars=${#text}
        local words
        words=$(echo "$text" | wc -w | tr -d ' ')
        local sentences
        sentences=$(echo "$text" | grep -oE '[.!?]+' | wc -l | tr -d ' ')

        printf "  %-22s %s\n" "Characters:" "$chars"
        printf "  %-22s %s\n" "Words:" "$words"
        printf "  %-22s %s\n" "Sentences (approx):" "$sentences"
    fi
}

cmd_tokens() {
    [[ -z "${1:-}" ]] && die "Missing argument: <file>"
    [[ -f "$1" ]]     || die "File not found: $1"

    info "Estimating tokens: ${CYAN}$1${NC}"
    echo ""

    local chars words bytes
    chars=$(wc -m < "$1" | tr -d ' ')
    words=$(wc -w < "$1" | tr -d ' ')
    bytes=$(wc -c < "$1" | tr -d ' ')

    # Method 1: chars / 4 (OpenAI rule of thumb)
    local tokens_by_chars=$((chars / 4))

    # Method 2: words * 1.33 (another common approximation)
    local tokens_by_words
    tokens_by_words=$(awk "BEGIN{printf \"%d\", ${words} * 1.33}")

    # Method 3: bytes-based for code (bytes / 3.5)
    local tokens_by_bytes
    tokens_by_bytes=$(awk "BEGIN{printf \"%d\", ${bytes} / 3.5}")

    # Average of methods
    local avg_tokens=$(( (tokens_by_chars + tokens_by_words + tokens_by_bytes) / 3 ))

    printf "  ${BOLD}%-30s %s${NC}\n" "Estimated tokens (average):" "~${avg_tokens}"
    echo ""
    printf "  %-30s %s\n" "Method 1 (chars ÷ 4):" "~${tokens_by_chars}"
    printf "  %-30s %s\n" "Method 2 (words × 1.33):" "~${tokens_by_words}"
    printf "  %-30s %s\n" "Method 3 (bytes ÷ 3.5):" "~${tokens_by_bytes}"
    echo ""

    # Cost estimates (approximate, based on GPT-4 pricing)
    local cost_input cost_output
    cost_input=$(awk "BEGIN{printf \"%.4f\", ${avg_tokens} / 1000000 * 30}")
    cost_output=$(awk "BEGIN{printf \"%.4f\", ${avg_tokens} / 1000000 * 60}")

    printf "  ${BOLD}Approximate costs (GPT-4 class):${NC}\n"
    printf "  %-30s \$%s\n" "As input tokens:" "$cost_input"
    printf "  %-30s \$%s\n" "As output tokens:" "$cost_output"
    echo ""

    # Model context window comparison
    printf "  ${BOLD}Context window usage:${NC}\n"
    for model_info in "GPT-4o:128000" "Claude-3:200000" "Gemini-1.5:1000000" "GPT-3.5:16385"; do
        local model_name="${model_info%%:*}"
        local ctx="${model_info##*:}"
        local pct
        pct=$(awk "BEGIN{printf \"%.1f\", ${avg_tokens} / ${ctx} * 100}")
        local bar_len
        bar_len=$(awk "BEGIN{v=int(${avg_tokens}/${ctx}*20); if(v>20) v=20; print v}")
        local bar=""
        for ((i=0; i<bar_len; i++)); do bar+="█"; done
        for ((i=bar_len; i<20; i++)); do bar+="░"; done
        printf "  %-12s [%s] %s%%\n" "${model_name}:" "$bar" "$pct"
    done
}

cmd_freq() {
    [[ -z "${1:-}" ]] && die "Missing argument: <file>"
    [[ -f "$1" ]]     || die "File not found: $1"

    info "Word frequency analysis: ${CYAN}$1${NC}"
    echo ""

    # Extract words, lowercase, count frequency
    local total_words unique_words
    total_words=$(wc -w < "$1" | tr -d ' ')

    echo "  ${BOLD}Word Frequency Distribution${NC}"
    echo ""

    # Top words with count and bar chart
    tr '[:upper:]' '[:lower:]' < "$1" | \
        tr -cs '[:alpha:]' '\n' | \
        grep -v '^$' | \
        sort | uniq -c | sort -rn | \
        head -30 | \
        awk -v total="$total_words" '
        BEGIN {
            printf "  %-4s  %-20s  %6s  %6s  %s\n", "Rank", "Word", "Count", "Pct", "Bar"
            printf "  %-4s  %-20s  %6s  %6s  %s\n", "----", "--------------------", "------", "------", "---"
        }
        {
            rank++
            pct = ($1 / total) * 100
            bar_len = int(pct * 2)
            if (bar_len < 1 && $1 > 0) bar_len = 1
            if (bar_len > 40) bar_len = 40
            bar = ""
            for (i = 0; i < bar_len; i++) bar = bar "█"
            printf "  %4d  %-20s  %6d  %5.1f%%  %s\n", rank, $2, $1, pct, bar
        }'

    echo ""
    unique_words=$(tr '[:upper:]' '[:lower:]' < "$1" | tr -cs '[:alpha:]' '\n' | grep -v '^$' | sort -u | wc -l | tr -d ' ')
    printf "  Total words: %s | Unique words: %s | Vocabulary richness: %.1f%%\n" \
        "$total_words" "$unique_words" \
        "$(awk "BEGIN{printf \"%.1f\", ${unique_words}/${total_words}*100}")"
}

cmd_top() {
    [[ -z "${1:-}" ]] && die "Missing argument: <file>"
    [[ -f "$1" ]]     || die "File not found: $1"
    local n="${2:-20}"

    info "Top ${n} words in: ${CYAN}$1${NC}"
    echo ""

    tr '[:upper:]' '[:lower:]' < "$1" | \
        tr -cs '[:alpha:]' '\n' | \
        grep -v '^$' | \
        sort | uniq -c | sort -rn | \
        head -"$n" | \
        awk '{printf "  %4d  %-30s  (%d occurrences)\n", NR, $2, $1}'
}

cmd_diff() {
    [[ -z "${1:-}" ]] && die "Missing argument: <file1>"
    [[ -z "${2:-}" ]] && die "Missing argument: <file2>"
    [[ -f "$1" ]]     || die "File not found: $1"
    [[ -f "$2" ]]     || die "File not found: $2"

    info "Comparing: ${CYAN}$1${NC} vs ${CYAN}$2${NC}"
    echo ""

    # Get stats for both files
    local w1 w2 l1 l2 c1 c2
    w1=$(wc -w < "$1" | tr -d ' ')
    w2=$(wc -w < "$2" | tr -d ' ')
    l1=$(wc -l < "$1" | tr -d ' ')
    l2=$(wc -l < "$2" | tr -d ' ')
    c1=$(wc -m < "$1" | tr -d ' ')
    c2=$(wc -m < "$2" | tr -d ' ')

    local b1 b2
    b1=$(wc -c < "$1" | tr -d ' ')
    b2=$(wc -c < "$2" | tr -d ' ')

    printf "  ${BOLD}%-20s  %12s  %12s  %12s${NC}\n" "Metric" "$(basename "$1")" "$(basename "$2")" "Difference"
    printf "  %-20s  %12s  %12s  %12s\n" "--------------------" "------------" "------------" "------------"
    printf "  %-20s  %12d  %12d  %+12d\n" "Words" "$w1" "$w2" "$((w2 - w1))"
    printf "  %-20s  %12d  %12d  %+12d\n" "Lines" "$l1" "$l2" "$((l2 - l1))"
    printf "  %-20s  %12d  %12d  %+12d\n" "Characters" "$c1" "$c2" "$((c2 - c1))"
    printf "  %-20s  %12d  %12d  %+12d\n" "Bytes" "$b1" "$b2" "$((b2 - b1))"

    # Unique words comparison
    local u1 u2
    u1=$(tr '[:upper:]' '[:lower:]' < "$1" | tr -cs '[:alpha:]' '\n' | grep -v '^$' | sort -u | wc -l | tr -d ' ')
    u2=$(tr '[:upper:]' '[:lower:]' < "$2" | tr -cs '[:alpha:]' '\n' | grep -v '^$' | sort -u | wc -l | tr -d ' ')
    printf "  %-20s  %12d  %12d  %+12d\n" "Unique words" "$u1" "$u2" "$((u2 - u1))"

    # Token estimates
    local t1=$((c1 / 4))
    local t2=$((c2 / 4))
    printf "  %-20s  %12d  %12d  %+12d\n" "Est. tokens" "$t1" "$t2" "$((t2 - t1))"

    echo ""
    # Words only in file1, only in file2
    local only1 only2 common
    local tmp1 tmp2
    tmp1=$(mktemp)
    tmp2=$(mktemp)
    tr '[:upper:]' '[:lower:]' < "$1" | tr -cs '[:alpha:]' '\n' | grep -v '^$' | sort -u > "$tmp1"
    tr '[:upper:]' '[:lower:]' < "$2" | tr -cs '[:alpha:]' '\n' | grep -v '^$' | sort -u > "$tmp2"
    only1=$(comm -23 "$tmp1" "$tmp2" | wc -l | tr -d ' ')
    only2=$(comm -13 "$tmp1" "$tmp2" | wc -l | tr -d ' ')
    common=$(comm -12 "$tmp1" "$tmp2" | wc -l | tr -d ' ')
    rm -f "$tmp1" "$tmp2"

    printf "  Words only in %s: %d\n" "$(basename "$1")" "$only1"
    printf "  Words only in %s: %d\n" "$(basename "$2")" "$only2"
    printf "  Words in common: %d\n" "$common"
}

# --- Main ------------------------------------------------------------------
main() {
    [[ $# -eq 0 ]] && { usage; exit 0; }

    case "${1}" in
        -h|--help)      usage ;;
        -v|--version)   echo "${SCRIPT_NAME} v${VERSION}" ;;
        count)          shift; cmd_count "${1:-}" ;;
        tokens)         shift; cmd_tokens "${1:-}" ;;
        freq)           shift; cmd_freq "${1:-}" ;;
        top)            shift; cmd_top "${1:-}" "${2:-}" ;;
        diff)           shift; cmd_diff "${1:-}" "${2:-}" ;;
        *)              die "Unknown command: $1 (try --help)" ;;
    esac
}

main "$@"
