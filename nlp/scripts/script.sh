#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# nlp - Natural Language Processing Toolbox
# Version: 3.0.0
# Author: BytesAgain
#
# Commands: tokenize, sentiment, extract, summarize, similarity, classify
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JSON_OUTPUT=false

# ---------------------------------------------------------------------------
# Utilities
# ---------------------------------------------------------------------------

die() { echo "ERROR: $*" >&2; exit 1; }

log() { echo "[nlp] $*" >&2; }

parse_global_flags() {
  local args=()
  for arg in "$@"; do
    if [[ "$arg" == "--json" ]]; then
      JSON_OUTPUT=true
    else
      args+=("$arg")
    fi
  done
  REMAINING_ARGS=("${args[@]+"${args[@]}"}")
}

read_input() {
  local input="" file=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --input) shift; input="$1" ;;
      --file)  shift; file="$1" ;;
      *) shift; continue ;;
    esac
    shift 2>/dev/null || true
  done

  if [[ -n "$input" ]]; then
    echo "$input"
  elif [[ -n "$file" ]]; then
    [[ -f "$file" ]] || die "File not found: $file"
    cat "$file"
  elif [[ ! -t 0 ]]; then
    cat
  else
    die "No input. Use --input, --file, or pipe via stdin."
  fi
}

to_lower() {
  echo "$1" | tr '[:upper:]' '[:lower:]'
}

# ---------------------------------------------------------------------------
# cmd_help - List all commands
# ---------------------------------------------------------------------------

cmd_help() {
  cat <<'EOF'
nlp - Natural Language Processing Toolbox

Usage: bash script.sh <command> [options]

Commands:
  tokenize    Split text into words and sentences with frequencies
  sentiment   Analyze text sentiment (positive/negative/neutral)
  extract     Extract named entities (people, places, orgs, dates)
  summarize   Generate text summary by extracting key sentences
  similarity  Compute similarity score between two texts
  classify    Classify text into given categories
  help        Show this help message

Global flags:
  --json      Output in JSON format

Examples:
  bash script.sh tokenize --input "Hello world"
  bash script.sh sentiment --file review.txt
  bash script.sh similarity --text1 "cat sat" --text2 "cat sits"
EOF
}

# ---------------------------------------------------------------------------
# cmd_tokenize - Word/sentence tokenization
# ---------------------------------------------------------------------------

cmd_tokenize() {
  local text
  text=$(read_input "$@")

  # Split into words - remove punctuation for word tokens
  local clean_text
  clean_text=$(echo "$text" | sed 's/[^a-zA-Z0-9 \t\n]/ /g' | tr -s ' ')

  local words=()
  while IFS= read -r word; do
    [[ -n "$word" ]] && words+=("$word")
  done < <(echo "$clean_text" | tr ' ' '\n' | grep -v '^$')

  local word_count=${#words[@]}

  # Split into sentences (on . ! ?)
  local sentences=()
  while IFS= read -r sent; do
    sent=$(echo "$sent" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    [[ -n "$sent" ]] && sentences+=("$sent")
  done < <(echo "$text" | sed 's/[.!?]/\n/g')

  local sentence_count=${#sentences[@]}

  # Word frequency (top 10)
  declare -A freq
  for w in "${words[@]}"; do
    local lw
    lw=$(to_lower "$w")
    freq["$lw"]=$(( ${freq["$lw"]:-0} + 1 ))
  done

  # Sort frequencies
  local sorted_freq=""
  for w in "${!freq[@]}"; do
    sorted_freq+="${freq[$w]} $w\n"
  done
  local top_words
  top_words=$(echo -e "$sorted_freq" | sort -rn | head -10)

  if [[ "$JSON_OUTPUT" == true ]]; then
    printf '{"word_count":%d,"sentence_count":%d,"tokens":[' "$word_count" "$sentence_count"
    local first=true
    for w in "${words[@]}"; do
      [[ "$first" == true ]] && first=false || printf ','
      printf '"%s"' "$w"
    done
    printf '],"top_words":{'
    first=true
    while IFS= read -r line; do
      [[ -z "$line" ]] && continue
      local cnt wrd
      cnt=$(echo "$line" | awk '{print $1}')
      wrd=$(echo "$line" | awk '{print $2}')
      [[ "$first" == true ]] && first=false || printf ','
      printf '"%s":%s' "$wrd" "$cnt"
    done <<< "$top_words"
    printf '}}\n'
  else
    echo "=== Tokenization Results ==="
    echo ""
    echo "Words:     $word_count"
    echo "Sentences: $sentence_count"
    echo ""
    echo "Tokens:"
    for w in "${words[@]}"; do
      printf "  %s\n" "$w"
    done | head -50
    [[ $word_count -gt 50 ]] && echo "  ... ($((word_count - 50)) more)"
    echo ""
    echo "Top 10 words by frequency:"
    while IFS= read -r line; do
      [[ -n "$line" ]] && printf "  %s\n" "$line"
    done <<< "$top_words"
  fi
}

# ---------------------------------------------------------------------------
# cmd_sentiment - Sentiment analysis
# ---------------------------------------------------------------------------

# Word lists for sentiment scoring
POSITIVE_WORDS="good great excellent amazing wonderful fantastic love happy joy beautiful perfect brilliant awesome outstanding incredible delightful pleasant superb terrific marvelous best like enjoy prefer recommend worth impressive satisfied exciting thrilled pleased glad cheerful optimistic fortunate"
NEGATIVE_WORDS="bad terrible awful horrible worst hate sad angry disappointed disgusting poor ugly boring dreadful miserable pathetic unpleasant dull failure broken wrong useless weak painful annoying frustrating offensive nasty lousy inferior regret unfortunately ruined wasted"
INTENSIFIERS="very extremely really truly absolutely incredibly highly particularly exceptionally remarkably"
NEGATORS="not never no none neither nor without barely hardly"

cmd_sentiment() {
  local text
  text=$(read_input "$@")

  local lower_text
  lower_text=$(to_lower "$text")

  local pos_count=0
  local neg_count=0
  local intensifier_count=0
  local negator_count=0
  local pos_matches=()
  local neg_matches=()

  # Count positive words
  for word in $POSITIVE_WORDS; do
    local count
    count=$(echo "$lower_text" | grep -ioP "\b${word}\b" | wc -l)
    if [[ $count -gt 0 ]]; then
      pos_count=$((pos_count + count))
      pos_matches+=("$word($count)")
    fi
  done

  # Count negative words
  for word in $NEGATIVE_WORDS; do
    local count
    count=$(echo "$lower_text" | grep -ioP "\b${word}\b" | wc -l)
    if [[ $count -gt 0 ]]; then
      neg_count=$((neg_count + count))
      neg_matches+=("$word($count)")
    fi
  done

  # Count intensifiers
  for word in $INTENSIFIERS; do
    local count
    count=$(echo "$lower_text" | grep -ioP "\b${word}\b" | wc -l)
    intensifier_count=$((intensifier_count + count))
  done

  # Count negators (flip sentiment)
  for word in $NEGATORS; do
    local count
    count=$(echo "$lower_text" | grep -ioP "\b${word}\b" | wc -l)
    negator_count=$((negator_count + count))
  done

  # Adjust for negators (odd number of negators flips sentiment)
  if [[ $((negator_count % 2)) -eq 1 ]]; then
    local tmp=$pos_count
    pos_count=$neg_count
    neg_count=$tmp
  fi

  # Calculate score: -1.0 to 1.0
  local total=$((pos_count + neg_count))
  local score="0.00"
  local polarity="neutral"
  local confidence="0.50"

  if [[ $total -gt 0 ]]; then
    score=$(awk "BEGIN {printf \"%.2f\", ($pos_count - $neg_count) / $total}")
    # Boost confidence with more matches
    confidence=$(awk "BEGIN {c = 0.5 + ($total * 0.05); if (c > 0.99) c = 0.99; printf \"%.2f\", c}")
  fi

  # Determine polarity
  local score_val
  score_val=$(awk "BEGIN {print ($score > 0.1) ? 1 : ($score < -0.1) ? -1 : 0}")
  case "$score_val" in
    1)  polarity="positive" ;;
    -1) polarity="negative" ;;
    0)  polarity="neutral" ;;
  esac

  if [[ "$JSON_OUTPUT" == true ]]; then
    printf '{"polarity":"%s","score":%s,"confidence":%s,"positive_count":%d,"negative_count":%d,"negators":%d}\n' \
      "$polarity" "$score" "$confidence" "$pos_count" "$neg_count" "$negator_count"
  else
    echo "=== Sentiment Analysis ==="
    echo ""
    echo "Polarity:    $polarity"
    echo "Score:       $score (-1.0 to 1.0)"
    echo "Confidence:  $confidence"
    echo ""
    echo "Positive matches ($pos_count): ${pos_matches[*]:-none}"
    echo "Negative matches ($neg_count): ${neg_matches[*]:-none}"
    [[ $negator_count -gt 0 ]] && echo "Negators found: $negator_count (sentiment flipped)"
  fi
}

# ---------------------------------------------------------------------------
# cmd_extract - Named entity extraction
# ---------------------------------------------------------------------------

cmd_extract() {
  local text
  text=$(read_input "$@")

  local people=() places=() orgs=() dates=() numbers=() emails=() urls=()

  # Extract emails
  while IFS= read -r match; do
    [[ -n "$match" ]] && emails+=("$match")
  done < <(echo "$text" | grep -oP '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' || true)

  # Extract URLs
  while IFS= read -r match; do
    [[ -n "$match" ]] && urls+=("$match")
  done < <(echo "$text" | grep -oP 'https?://[^\s<>"]+' || true)

  # Extract dates (various formats)
  while IFS= read -r match; do
    [[ -n "$match" ]] && dates+=("$match")
  done < <(echo "$text" | grep -oP '\d{4}[-/]\d{1,2}[-/]\d{1,2}|\d{1,2}[-/]\d{1,2}[-/]\d{2,4}|\b(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]* \d{1,2},? \d{4}|\b\d{4}\b' || true)

  # Extract numbers with units
  while IFS= read -r match; do
    [[ -n "$match" ]] && numbers+=("$match")
  done < <(echo "$text" | grep -oP '\$?[\d,]+\.?\d*\s*(%|USD|EUR|GBP|kg|km|mi|mb|gb|tb|hrs?|mins?|secs?)' || true)

  # Extract capitalized words as potential names/places/orgs (2+ consecutive capitalized words)
  while IFS= read -r match; do
    [[ -n "$match" ]] && people+=("$match")
  done < <(echo "$text" | grep -oP '\b[A-Z][a-z]+(?:\s+[A-Z][a-z]+)+\b' || true)

  # Extract known org patterns
  while IFS= read -r match; do
    [[ -n "$match" ]] && orgs+=("$match")
  done < <(echo "$text" | grep -oP '\b[A-Z][a-zA-Z]*(?:\s+(?:Inc|Corp|Ltd|LLC|Co|Group|Foundation|University|Institute|Association))\b\.?' || true)

  if [[ "$JSON_OUTPUT" == true ]]; then
    printf '{"entities":{'
    printf '"names":['; local first=true
    for e in "${people[@]}"; do
      [[ "$first" == true ]] && first=false || printf ','
      printf '"%s"' "$e"
    done
    printf '],"organizations":['; first=true
    for e in "${orgs[@]}"; do
      [[ "$first" == true ]] && first=false || printf ','
      printf '"%s"' "$e"
    done
    printf '],"dates":['; first=true
    for e in "${dates[@]}"; do
      [[ "$first" == true ]] && first=false || printf ','
      printf '"%s"' "$e"
    done
    printf '],"numbers":['; first=true
    for e in "${numbers[@]}"; do
      [[ "$first" == true ]] && first=false || printf ','
      printf '"%s"' "$e"
    done
    printf '],"emails":['; first=true
    for e in "${emails[@]}"; do
      [[ "$first" == true ]] && first=false || printf ','
      printf '"%s"' "$e"
    done
    printf '],"urls":['; first=true
    for e in "${urls[@]}"; do
      [[ "$first" == true ]] && first=false || printf ','
      printf '"%s"' "$e"
    done
    printf ']}}\n'
  else
    echo "=== Named Entity Extraction ==="
    echo ""

    echo "Names/People (${#people[@]}):"
    for e in "${people[@]}"; do echo "  - $e"; done
    [[ ${#people[@]} -eq 0 ]] && echo "  (none found)"

    echo ""
    echo "Organizations (${#orgs[@]}):"
    for e in "${orgs[@]}"; do echo "  - $e"; done
    [[ ${#orgs[@]} -eq 0 ]] && echo "  (none found)"

    echo ""
    echo "Dates (${#dates[@]}):"
    for e in "${dates[@]}"; do echo "  - $e"; done
    [[ ${#dates[@]} -eq 0 ]] && echo "  (none found)"

    echo ""
    echo "Numbers (${#numbers[@]}):"
    for e in "${numbers[@]}"; do echo "  - $e"; done
    [[ ${#numbers[@]} -eq 0 ]] && echo "  (none found)"

    echo ""
    echo "Emails (${#emails[@]}):"
    for e in "${emails[@]}"; do echo "  - $e"; done
    [[ ${#emails[@]} -eq 0 ]] && echo "  (none found)"

    echo ""
    echo "URLs (${#urls[@]}):"
    for e in "${urls[@]}"; do echo "  - $e"; done
    [[ ${#urls[@]} -eq 0 ]] && echo "  (none found)"
  fi
}

# ---------------------------------------------------------------------------
# cmd_summarize - Text summarization
# ---------------------------------------------------------------------------

cmd_summarize() {
  local text="" file="" num_sentences=3 ratio=""

  local args_copy=("$@")
  # Parse specific args first
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --sentences) shift; num_sentences="$1" ;;
      --ratio)     shift; ratio="$1" ;;
      --input)     shift; text="$1" ;;
      --file)      shift; file="$1" ;;
      *) ;;
    esac
    shift
  done

  local full_text=""
  if [[ -n "$text" ]]; then
    full_text="$text"
  elif [[ -n "$file" ]]; then
    [[ -f "$file" ]] || die "File not found: $file"
    full_text=$(cat "$file")
  elif [[ ! -t 0 ]]; then
    full_text=$(cat)
  else
    die "No input. Use --input, --file, or pipe via stdin."
  fi

  # Split into sentences
  local sentences=()
  while IFS= read -r sent; do
    sent=$(echo "$sent" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    [[ ${#sent} -gt 10 ]] && sentences+=("$sent")
  done < <(echo "$full_text" | sed 's/\([.!?]\)/\1\n/g')

  local total_sentences=${#sentences[@]}

  # Apply ratio if specified
  if [[ -n "$ratio" ]]; then
    num_sentences=$(awk "BEGIN {n = int($total_sentences * $ratio + 0.5); if (n < 1) n = 1; print n}")
  fi

  [[ $num_sentences -gt $total_sentences ]] && num_sentences=$total_sentences

  # Score each sentence based on word frequency
  declare -A word_freq
  local lower_text
  lower_text=$(to_lower "$full_text")
  local clean_lower
  clean_lower=$(echo "$lower_text" | sed 's/[^a-z0-9 ]/ /g' | tr -s ' ')

  for word in $clean_lower; do
    [[ ${#word} -gt 3 ]] && word_freq["$word"]=$(( ${word_freq["$word"]:-0} + 1 ))
  done

  # Score sentences
  local scores=()
  for i in "${!sentences[@]}"; do
    local sent_lower
    sent_lower=$(to_lower "${sentences[$i]}" | sed 's/[^a-z0-9 ]/ /g' | tr -s ' ')
    local score=0
    for word in $sent_lower; do
      score=$((score + ${word_freq["$word"]:-0}))
    done
    # Normalize by sentence length
    local wcount
    wcount=$(echo "$sent_lower" | wc -w)
    [[ $wcount -gt 0 ]] && score=$((score * 100 / wcount))

    # Bonus for position (first and last sentences)
    [[ $i -eq 0 ]] && score=$((score + 50))
    [[ $i -eq $((total_sentences - 1)) ]] && score=$((score + 20))

    scores+=("$score:$i")
  done

  # Sort by score and take top N
  local top_indices=()
  while IFS= read -r entry; do
    local idx
    idx=$(echo "$entry" | cut -d: -f2)
    top_indices+=("$idx")
  done < <(printf '%s\n' "${scores[@]}" | sort -t: -k1 -rn | head -"$num_sentences")

  # Sort indices to maintain original order
  local sorted_indices
  sorted_indices=$(printf '%s\n' "${top_indices[@]}" | sort -n)

  if [[ "$JSON_OUTPUT" == true ]]; then
    printf '{"original_sentences":%d,"summary_sentences":%d,"summary":"' "$total_sentences" "$num_sentences"
    local first=true
    while IFS= read -r idx; do
      [[ "$first" == true ]] && first=false || printf ' '
      printf '%s' "${sentences[$idx]}"
    done <<< "$sorted_indices"
    printf '"}\n'
  else
    echo "=== Text Summary ==="
    echo ""
    echo "Original: $total_sentences sentences"
    echo "Summary:  $num_sentences sentences"
    echo ""
    while IFS= read -r idx; do
      echo "${sentences[$idx]}"
    done <<< "$sorted_indices"
  fi
}

# ---------------------------------------------------------------------------
# cmd_similarity - Text similarity
# ---------------------------------------------------------------------------

cmd_similarity() {
  local text1="" text2="" file1="" file2=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --text1) shift; text1="$1" ;;
      --text2) shift; text2="$1" ;;
      --file1) shift; file1="$1" ;;
      --file2) shift; file2="$1" ;;
      *) die "Unknown option for similarity: $1" ;;
    esac
    shift
  done

  if [[ -n "$file1" ]]; then
    [[ -f "$file1" ]] || die "File not found: $file1"
    text1=$(cat "$file1")
  fi
  if [[ -n "$file2" ]]; then
    [[ -f "$file2" ]] || die "File not found: $file2"
    text2=$(cat "$file2")
  fi

  [[ -n "$text1" ]] || die "similarity requires --text1 or --file1"
  [[ -n "$text2" ]] || die "similarity requires --text2 or --file2"

  # Tokenize both texts (lowercase, remove punctuation)
  local words1 words2
  words1=$(to_lower "$text1" | sed 's/[^a-z0-9 ]/ /g' | tr -s ' ')
  words2=$(to_lower "$text2" | sed 's/[^a-z0-9 ]/ /g' | tr -s ' ')

  # Build word sets
  declare -A set1 set2 all_words

  for w in $words1; do
    [[ ${#w} -gt 1 ]] && set1["$w"]=1 && all_words["$w"]=1
  done
  for w in $words2; do
    [[ ${#w} -gt 1 ]] && set2["$w"]=1 && all_words["$w"]=1
  done

  # Jaccard similarity: |intersection| / |union|
  local intersection=0
  local union=${#all_words[@]}

  for w in "${!set1[@]}"; do
    [[ -n "${set2[$w]:-}" ]] && intersection=$((intersection + 1))
  done

  local jaccard="0.00"
  [[ $union -gt 0 ]] && jaccard=$(awk "BEGIN {printf \"%.4f\", $intersection / $union}")

  # Cosine similarity based on word frequencies
  declare -A freq1 freq2
  for w in $words1; do
    [[ ${#w} -gt 1 ]] && freq1["$w"]=$(( ${freq1["$w"]:-0} + 1 ))
  done
  for w in $words2; do
    [[ ${#w} -gt 1 ]] && freq2["$w"]=$(( ${freq2["$w"]:-0} + 1 ))
  done

  local dot_product=0 mag1=0 mag2=0
  for w in "${!all_words[@]}"; do
    local f1=${freq1["$w"]:-0}
    local f2=${freq2["$w"]:-0}
    dot_product=$((dot_product + f1 * f2))
    mag1=$((mag1 + f1 * f1))
    mag2=$((mag2 + f2 * f2))
  done

  local cosine="0.00"
  if [[ $mag1 -gt 0 && $mag2 -gt 0 ]]; then
    cosine=$(awk "BEGIN {printf \"%.4f\", $dot_product / (sqrt($mag1) * sqrt($mag2))}")
  fi

  # Overall score (average of both)
  local overall
  overall=$(awk "BEGIN {printf \"%.4f\", ($jaccard + $cosine) / 2}")

  if [[ "$JSON_OUTPUT" == true ]]; then
    printf '{"overall":%s,"jaccard":%s,"cosine":%s,"shared_words":%d,"unique_words":%d}\n' \
      "$overall" "$jaccard" "$cosine" "$intersection" "$union"
  else
    echo "=== Text Similarity ==="
    echo ""
    echo "Overall score:    $overall (0.0 = different, 1.0 = identical)"
    echo ""
    echo "Jaccard index:    $jaccard"
    echo "Cosine similarity: $cosine"
    echo ""
    echo "Shared words:     $intersection"
    echo "Total unique:     $union"
    echo ""
    echo "Text 1 words: ${#set1[@]}"
    echo "Text 2 words: ${#set2[@]}"
  fi
}

# ---------------------------------------------------------------------------
# cmd_classify - Text classification
# ---------------------------------------------------------------------------

cmd_classify() {
  local text="" categories="" file=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --input)      shift; text="$1" ;;
      --file)       shift; file="$1" ;;
      --categories) shift; categories="$1" ;;
      *) die "Unknown option for classify: $1" ;;
    esac
    shift
  done

  if [[ -n "$file" ]]; then
    [[ -f "$file" ]] || die "File not found: $file"
    text=$(cat "$file")
  fi

  [[ -n "$text" ]] || die "classify requires --input or --file"
  [[ -n "$categories" ]] || die "classify requires --categories (comma-separated)"

  local lower_text
  lower_text=$(to_lower "$text")

  # Category keyword definitions
  declare -A category_keywords
  category_keywords["finance"]="stock market invest money bank fund trading profit loss revenue earnings dividend portfolio asset debt capital economy financial budget"
  category_keywords["sports"]="game team player score win match tournament league season championship coach goal ball run race athlete competition play"
  category_keywords["tech"]="software hardware computer algorithm data code programming developer api cloud server network database machine digital technology app"
  category_keywords["politics"]="government election president senator congress vote policy law legislation democrat republican party campaign bill parliament minister"
  category_keywords["science"]="research study experiment hypothesis theory discovery molecule atom particle energy physics chemistry biology lab"
  category_keywords["health"]="doctor hospital medical patient treatment disease diagnosis symptom medicine therapy vaccine health clinical drug prescription"
  category_keywords["positive"]="good great excellent love happy amazing wonderful fantastic beautiful perfect enjoy like best awesome terrific pleasant"
  category_keywords["negative"]="bad terrible awful hate sad horrible worst disgusting poor ugly boring dreadful miserable pathetic wrong failure"
  category_keywords["neutral"]="said stated reported according noted mentioned described explained indicated the is was were"

  # Parse and score each category
  IFS=',' read -ra cats <<< "$categories"

  declare -A cat_scores
  local max_score=0
  local best_cat=""

  for cat in "${cats[@]}"; do
    cat=$(echo "$cat" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    local cat_lower
    cat_lower=$(to_lower "$cat")
    local score=0

    # Use predefined keywords if available, otherwise use category name as keyword
    local keywords="${category_keywords[$cat_lower]:-$cat_lower}"

    for kw in $keywords; do
      local matches
      matches=$(echo "$lower_text" | grep -ioP "\b${kw}\b" | wc -l)
      score=$((score + matches))
    done

    cat_scores["$cat"]=$score

    if [[ $score -gt $max_score ]]; then
      max_score=$score
      best_cat="$cat"
    fi
  done

  # Calculate total for percentages
  local total=0
  for cat in "${cats[@]}"; do
    cat=$(echo "$cat" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    total=$((total + ${cat_scores[$cat]}))
  done

  if [[ "$JSON_OUTPUT" == true ]]; then
    printf '{"predicted":"%s","scores":{' "$best_cat"
    local first=true
    for cat in "${cats[@]}"; do
      cat=$(echo "$cat" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
      [[ "$first" == true ]] && first=false || printf ','
      local pct="0.00"
      [[ $total -gt 0 ]] && pct=$(awk "BEGIN {printf \"%.2f\", ${cat_scores[$cat]} / $total}")
      printf '"%s":{"hits":%d,"confidence":%s}' "$cat" "${cat_scores[$cat]}" "$pct"
    done
    printf '}}\n'
  else
    echo "=== Text Classification ==="
    echo ""
    echo "Predicted category: $best_cat"
    echo ""
    echo "Scores:"
    for cat in "${cats[@]}"; do
      cat=$(echo "$cat" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
      local pct="0.0"
      [[ $total -gt 0 ]] && pct=$(awk "BEGIN {printf \"%.1f\", ${cat_scores[$cat]} * 100 / $total}")
      local bar=""
      local bar_len=$(( ${cat_scores[$cat]} * 2 ))
      [[ $bar_len -gt 40 ]] && bar_len=40
      for ((b=0; b<bar_len; b++)); do bar+="█"; done
      printf "  %-15s %3d hits  %5s%%  %s\n" "$cat" "${cat_scores[$cat]}" "$pct" "$bar"
    done

    [[ $total -eq 0 ]] && echo "" && echo "  No keyword matches found. Try more specific categories."
  fi
}

# ---------------------------------------------------------------------------
# Main dispatch
# ---------------------------------------------------------------------------

main() {
  [[ $# -ge 1 ]] || { cmd_help; exit 0; }

  local command="$1"
  shift

  parse_global_flags "$@"
  set -- "${REMAINING_ARGS[@]+"${REMAINING_ARGS[@]}"}"

  case "$command" in
    tokenize)   cmd_tokenize "$@" ;;
    sentiment)  cmd_sentiment "$@" ;;
    extract)    cmd_extract "$@" ;;
    summarize)  cmd_summarize "$@" ;;
    similarity) cmd_similarity "$@" ;;
    classify)   cmd_classify "$@" ;;
    help)       cmd_help ;;
    *)          die "Unknown command: $command. Run 'help' for usage." ;;
  esac
}

main "$@"
