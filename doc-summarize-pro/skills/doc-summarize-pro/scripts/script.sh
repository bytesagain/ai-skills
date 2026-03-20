#!/usr/bin/env bash
# doc-summarize-pro — Document Analysis Toolkit
# Powered by BytesAgain | bytesagain.com
set -euo pipefail

VERSION="3.0.0"
DATA_DIR="$HOME/.doc-summarize-pro"
CONFIG_FILE="$DATA_DIR/config"
HISTORY_FILE="$DATA_DIR/history.log"
mkdir -p "$DATA_DIR"

# ── Default config ──────────────────────────────────────────────
_config_init() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        cat > "$CONFIG_FILE" <<CFG
summary_sentences=2
keyword_count=15
CFG
    fi
}

_config_get() {
    _config_init
    local key="$1" default="${2:-}"
    local val
    val=$(grep -m1 "^${key}=" "$CONFIG_FILE" 2>/dev/null | cut -d= -f2-)
    echo "${val:-$default}"
}

_config_set() {
    _config_init
    local key="$1" value="$2"
    if grep -q "^${key}=" "$CONFIG_FILE" 2>/dev/null; then
        sed -i "s|^${key}=.*|${key}=${value}|" "$CONFIG_FILE"
    else
        echo "${key}=${value}" >> "$CONFIG_FILE"
    fi
    echo "  ✓ ${key} = ${value}"
}

# ── History logging ─────────────────────────────────────────────
_log() {
    local cmd="$1" detail="${2:-}"
    echo "$(date '+%Y-%m-%d %H:%M:%S')  ${cmd}  ${detail}" >> "$HISTORY_FILE"
}

# ── Stop words (English common words filtered from keywords) ────
_is_stopword() {
    local w="${1,,}"
    case "$w" in
        the|a|an|and|or|but|in|on|at|to|for|of|with|by|from|is|are|was|were|\
it|its|this|that|these|those|be|been|being|have|has|had|do|does|did|\
will|would|shall|should|can|could|may|might|must|not|no|nor|so|if|\
then|than|too|very|just|about|above|after|again|all|also|am|any|\
because|before|between|both|during|each|few|get|got|he|she|her|him|\
his|how|i|into|me|more|most|my|new|now|only|other|our|out|over|\
own|re|s|same|some|such|t|their|them|there|they|through|under|up|\
us|we|what|when|where|which|while|who|whom|why|you|your|one|two|\
three|four|five|been|said|many|well|back|much|go|like|make|made)
            return 0 ;;
        *) return 1 ;;
    esac
}

# ── Sentence splitting helper ───────────────────────────────────
# Splits text into sentences (one per line) using awk
_split_sentences() {
    awk '{
        gsub(/([.!?])[ \t]+/, "&\n")
        print
    }' "$1" | sed '/^[[:space:]]*$/d'
}

# ── Count sentences in a string ─────────────────────────────────
_count_sentences() {
    local file="$1"
    _split_sentences "$file" | wc -l
}

# ── Validate file exists ───────────────────────────────────────
_require_file() {
    if [[ -z "${1:-}" ]]; then
        echo "Error: no file specified" >&2
        exit 1
    fi
    if [[ ! -f "$1" ]]; then
        echo "Error: file not found: $1" >&2
        exit 1
    fi
}

# ── Validate directory exists ──────────────────────────────────
_require_dir() {
    if [[ -z "${1:-}" ]]; then
        echo "Error: no directory specified" >&2
        exit 1
    fi
    if [[ ! -d "$1" ]]; then
        echo "Error: directory not found: $1" >&2
        exit 1
    fi
}

# ════════════════════════════════════════════════════════════════
# COMMANDS
# ════════════════════════════════════════════════════════════════

# ── summarize <file> ────────────────────────────────────────────
cmd_summarize() {
    _require_file "${1:-}"
    local file="$1"
    local n
    n=$(_config_get summary_sentences 2)

    echo "── Summary: $(basename "$file") ──"
    echo

    # Extract first N and last sentence from each paragraph
    awk -v n="$n" '
    BEGIN { para="" }
    /^[[:space:]]*$/ {
        if (para != "") {
            # split para into sentences
            split(para, words, /[.!?][[:space:]]+/)
            total = length(words)
            if (total <= n) {
                print para
            } else {
                for (i = 1; i <= n && i <= total; i++) {
                    printf "%s. ", words[i]
                }
                if (total > n) {
                    printf "%s.", words[total]
                }
                print ""
            }
            print ""
        }
        para = ""
        next
    }
    /^#/ { next }  # skip markdown headers
    {
        if (para == "") para = $0
        else para = para " " $0
    }
    END {
        if (para != "") {
            split(para, words, /[.!?][[:space:]]+/)
            total = length(words)
            if (total <= n) {
                print para
            } else {
                for (i = 1; i <= n && i <= total; i++) {
                    printf "%s. ", words[i]
                }
                if (total > n) {
                    printf "%s.", words[total]
                }
                print ""
            }
        }
    }
    ' "$file"

    _log "summarize" "$file"
}

# ── keywords <file> ────────────────────────────────────────────
cmd_keywords() {
    _require_file "${1:-}"
    local file="$1"
    local max_kw
    max_kw=$(_config_get keyword_count 15)

    echo "── Keywords: $(basename "$file") ──"
    echo

    # Tokenize → lowercase → filter stop words → count → sort → top N
    tr '[:upper:]' '[:lower:]' < "$file" \
        | tr -cs '[:alpha:]' '\n' \
        | sed '/^$/d' \
        | awk 'length >= 3' \
        | while IFS= read -r word; do
            if ! _is_stopword "$word"; then
                echo "$word"
            fi
        done \
        | sort \
        | uniq -c \
        | sort -rn \
        | head -n "$max_kw" \
        | awk '{ printf "  %3d  %s\n", $1, $2 }'

    _log "keywords" "$file"
}

# ── outline <file> ─────────────────────────────────────────────
cmd_outline() {
    _require_file "${1:-}"
    local file="$1"

    echo "── Outline: $(basename "$file") ──"
    echo

    awk '
    /^######[[:space:]]/ { printf "          • %s\n", substr($0, index($0,$2)); next }
    /^#####[[:space:]]/  { printf "        • %s\n",  substr($0, index($0,$2)); next }
    /^####[[:space:]]/   { printf "      • %s\n",   substr($0, index($0,$2)); next }
    /^###[[:space:]]/    { printf "    • %s\n",    substr($0, index($0,$2)); next }
    /^##[[:space:]]/     { printf "  • %s\n",     substr($0, index($0,$2)); next }
    /^#[[:space:]]/      { printf "• %s\n",      substr($0, index($0,$2)); next }
    /^[A-Z][A-Z ]{4,}$/ { printf "• %s\n", $0; next }
    /^[0-9]+\.[[:space:]]/ { printf "  %s\n", $0; next }
    ' "$file"

    _log "outline" "$file"
}

# ── stats <file> ───────────────────────────────────────────────
cmd_stats() {
    _require_file "${1:-}"
    local file="$1"

    echo "── Stats: $(basename "$file") ──"
    echo

    local words chars lines paragraphs sentences unique_words reading_min

    words=$(wc -w < "$file")
    chars=$(wc -m < "$file")
    lines=$(wc -l < "$file")

    # Paragraphs = groups of non-blank lines separated by blank lines
    paragraphs=$(awk '
        BEGIN { p=0; in_para=0 }
        /^[[:space:]]*$/ { if (in_para) { p++; in_para=0 } next }
        { in_para=1 }
        END { if (in_para) p++; print p }
    ' "$file")

    # Sentence count: count . ! ? followed by space or end-of-line
    sentences=$(grep -oE '[.!?]([[:space:]]|$)' "$file" | wc -l)
    if [[ "$sentences" -eq 0 ]]; then
        sentences=1
    fi

    # Unique words
    unique_words=$(tr '[:upper:]' '[:lower:]' < "$file" \
        | tr -cs '[:alpha:]' '\n' \
        | sed '/^$/d' \
        | sort -u \
        | wc -l)

    # Reading time (avg 238 wpm)
    reading_min=$(( (words + 237) / 238 ))
    if [[ "$reading_min" -lt 1 ]]; then
        reading_min=1
    fi

    printf "  Words:        %d\n" "$words"
    printf "  Characters:   %d\n" "$chars"
    printf "  Lines:        %d\n" "$lines"
    printf "  Paragraphs:   %d\n" "$paragraphs"
    printf "  Sentences:    %d\n" "$sentences"
    printf "  Unique words: %d\n" "$unique_words"
    printf "  Reading time: ~%d min\n" "$reading_min"

    _log "stats" "$file"
}

# ── compare <file1> <file2> ────────────────────────────────────
cmd_compare() {
    _require_file "${1:-}"
    _require_file "${2:-}"
    local file1="$1" file2="$2"

    echo "── Compare ──"
    echo "  File A: $(basename "$file1")"
    echo "  File B: $(basename "$file2")"
    echo

    local words1 words2
    words1=$(wc -w < "$file1")
    words2=$(wc -w < "$file2")

    local diff=$(( words2 - words1 ))
    printf "  Words A: %d\n" "$words1"
    printf "  Words B: %d\n" "$words2"
    printf "  Diff:    %+d words\n" "$diff"
    echo

    # Extract top keywords from each, find shared and unique
    local tmp_a="$DATA_DIR/.cmp_a.$$"
    local tmp_b="$DATA_DIR/.cmp_b.$$"
    trap 'rm -f "$tmp_a" "$tmp_b"' EXIT

    _extract_top_words "$file1" 30 > "$tmp_a"
    _extract_top_words "$file2" 30 > "$tmp_b"

    echo "  Shared keywords:"
    local shared
    shared=$(comm -12 "$tmp_a" "$tmp_b")
    if [[ -n "$shared" ]]; then
        echo "$shared" | awk '{ printf "    • %s\n", $0 }'
    else
        echo "    (none)"
    fi

    echo
    echo "  Unique to A:"
    local only_a
    only_a=$(comm -23 "$tmp_a" "$tmp_b" | head -10)
    if [[ -n "$only_a" ]]; then
        echo "$only_a" | awk '{ printf "    • %s\n", $0 }'
    else
        echo "    (none)"
    fi

    echo
    echo "  Unique to B:"
    local only_b
    only_b=$(comm -13 "$tmp_a" "$tmp_b" | head -10)
    if [[ -n "$only_b" ]]; then
        echo "$only_b" | awk '{ printf "    • %s\n", $0 }'
    else
        echo "    (none)"
    fi

    rm -f "$tmp_a" "$tmp_b"
    trap - EXIT

    _log "compare" "$file1 vs $file2"
}

# Helper: extract top N words (sorted alphabetically for comm)
_extract_top_words() {
    local file="$1" n="${2:-20}"
    tr '[:upper:]' '[:lower:]' < "$file" \
        | tr -cs '[:alpha:]' '\n' \
        | sed '/^$/d' \
        | awk 'length >= 3' \
        | while IFS= read -r word; do
            if ! _is_stopword "$word"; then
                echo "$word"
            fi
        done \
        | sort \
        | uniq -c \
        | sort -rn \
        | head -n "$n" \
        | awk '{ print $2 }' \
        | sort
}

# ── batch <dir> ────────────────────────────────────────────────
cmd_batch() {
    _require_dir "${1:-}"
    local dir="$1"
    local count=0

    echo "── Batch Summarize: $dir ──"
    echo

    local f
    shopt -s nullglob
    for f in "$dir"/*.txt "$dir"/*.md "$dir"/*.rst "$dir"/*.log; do
        [[ -f "$f" ]] || continue
        count=$((count + 1))
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        cmd_summarize "$f"
        echo
    done

    if [[ "$count" -eq 0 ]]; then
        echo "  No supported files found (.txt, .md, .rst, .log)"
    else
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "  Processed $count file(s)."
    fi

    _log "batch" "$dir ($count files)"
}

# ── export <file> <format> ─────────────────────────────────────
cmd_export() {
    _require_file "${1:-}"
    local file="$1"
    local fmt="${2:-md}"

    case "$fmt" in
        md|txt|json) ;;
        *)
            echo "Error: unsupported format '$fmt'. Use: md, txt, json" >&2
            exit 1
            ;;
    esac

    # Capture summary text
    local summary
    summary=$(cmd_summarize "$file" 2>/dev/null | tail -n +3)

    # Capture keywords
    local keywords_raw
    keywords_raw=$(cmd_keywords "$file" 2>/dev/null | tail -n +3)

    # Capture stats
    local stats_raw
    stats_raw=$(cmd_stats "$file" 2>/dev/null | tail -n +3)

    local basename_f
    basename_f=$(basename "$file")

    case "$fmt" in
        md)
            echo "# Summary: $basename_f"
            echo
            echo "## Summary"
            echo "$summary"
            echo
            echo "## Keywords"
            echo "$keywords_raw"
            echo
            echo "## Statistics"
            echo "$stats_raw"
            ;;
        txt)
            echo "Summary: $basename_f"
            echo "========================="
            echo
            echo "$summary"
            echo
            echo "Keywords:"
            echo "$keywords_raw"
            echo
            echo "Statistics:"
            echo "$stats_raw"
            ;;
        json)
            # Build JSON with awk
            local summary_esc keywords_esc stats_esc
            summary_esc=$(echo "$summary" | awk '
                { gsub(/\\/, "\\\\"); gsub(/"/, "\\\""); gsub(/\t/, "\\t") }
                NR>1 { printf "\\n" } { printf "%s", $0 }
            ')
            keywords_esc=$(echo "$keywords_raw" | awk '
                { gsub(/\\/, "\\\\"); gsub(/"/, "\\\""); gsub(/\t/, "\\t") }
                NR>1 { printf "\\n" } { printf "%s", $0 }
            ')
            stats_esc=$(echo "$stats_raw" | awk '
                { gsub(/\\/, "\\\\"); gsub(/"/, "\\\""); gsub(/\t/, "\\t") }
                NR>1 { printf "\\n" } { printf "%s", $0 }
            ')
            printf '{\n'
            printf '  "file": "%s",\n' "$basename_f"
            printf '  "summary": "%s",\n' "$summary_esc"
            printf '  "keywords": "%s",\n' "$keywords_esc"
            printf '  "statistics": "%s"\n' "$stats_esc"
            printf '}\n'
            ;;
    esac

    _log "export" "$file → $fmt"
}

# ── history ────────────────────────────────────────────────────
cmd_history() {
    echo "── Processing History ──"
    echo
    if [[ -f "$HISTORY_FILE" ]] && [[ -s "$HISTORY_FILE" ]]; then
        awk '{ printf "  %s\n", $0 }' "$HISTORY_FILE"
    else
        echo "  (no history yet)"
    fi
}

# ── config [key] [value] ──────────────────────────────────────
cmd_config() {
    _config_init
    if [[ $# -eq 0 ]]; then
        echo "── Configuration ──"
        echo
        while IFS='=' read -r key value; do
            [[ -z "$key" || "$key" == \#* ]] && continue
            printf "  %-20s %s\n" "$key" "$value"
        done < "$CONFIG_FILE"
        echo
        echo "  Config file: $CONFIG_FILE"
        return
    fi
    if [[ $# -eq 1 ]]; then
        local val
        val=$(_config_get "$1" "")
        if [[ -n "$val" ]]; then
            echo "  $1 = $val"
        else
            echo "  (not set: $1)"
        fi
        return
    fi
    _config_set "$1" "$2"
    _log "config" "$1=$2"
}

# ── help ───────────────────────────────────────────────────────
show_help() {
    cat <<EOF
📝 doc-summarize-pro v$VERSION — Document Analysis Toolkit

Usage: script.sh <command> [args]

Commands:
  summarize <file>            Generate document summary
  keywords <file>             Extract keywords (frequency analysis)
  outline <file>              Extract document outline / headings
  stats <file>                Document statistics (words, reading time, etc.)
  compare <file1> <file2>     Compare two documents
  batch <dir>                 Batch-summarize all files in a directory
  export <file> <format>      Export summary (md / txt / json)
  history                     Show processing history
  config [key] [value]        View or update configuration
  help                        Show this help
  version                     Show version

Data: $DATA_DIR
Powered by BytesAgain | bytesagain.com
EOF
}

# ════════════════════════════════════════════════════════════════
# MAIN DISPATCH
# ════════════════════════════════════════════════════════════════
case "${1:-help}" in
    summarize)  shift; cmd_summarize "$@" ;;
    keywords)   shift; cmd_keywords "$@" ;;
    outline)    shift; cmd_outline "$@" ;;
    stats)      shift; cmd_stats "$@" ;;
    compare)    shift; cmd_compare "$@" ;;
    batch)      shift; cmd_batch "$@" ;;
    export)     shift; cmd_export "$@" ;;
    history)    cmd_history ;;
    config)     shift; cmd_config "$@" ;;
    help|-h)    show_help ;;
    version|-v) echo "doc-summarize-pro v$VERSION" ;;
    *)          echo "Unknown command: $1" >&2; show_help; exit 1 ;;
esac
