#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# llm - LLM Prompt Engineering Toolkit
# Version: 3.0.0
# Author: BytesAgain
#
# Commands: prompt, compare, tokenize, template, chain, evaluate
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="${HOME}/.llm-skill/templates"
JSON_OUTPUT=false

# ---------------------------------------------------------------------------
# Utilities
# ---------------------------------------------------------------------------

die() { echo "ERROR: $*" >&2; exit 1; }

log() { echo "[llm] $*" >&2; }

ensure_dir() {
  [[ -d "$1" ]] || mkdir -p "$1"
}

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
  # Read from --input string or --file path
  local input="" file=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --input) shift; input="$1" ;;
      --file)  shift; file="$1" ;;
    esac
    shift 2>/dev/null || true
  done

  if [[ -n "$input" ]]; then
    echo "$input"
  elif [[ -n "$file" ]]; then
    [[ -f "$file" ]] || die "File not found: $file"
    cat "$file"
  else
    # Try stdin
    if [[ ! -t 0 ]]; then
      cat
    else
      die "No input provided. Use --input, --file, or pipe via stdin."
    fi
  fi
}

# ---------------------------------------------------------------------------
# cmd_help - List all commands
# ---------------------------------------------------------------------------

cmd_help() {
  cat <<'EOF'
llm - LLM Prompt Engineering Toolkit

Usage: bash script.sh <command> [options]

Commands:
  prompt      Build a structured prompt from role, context, and task
  compare     Compare two or more prompt variations side by side
  tokenize    Estimate token count for text
  template    Manage reusable prompt templates (save/list/load/delete)
  chain       Run multi-step prompt chains
  evaluate    Score prompt quality (clarity, specificity, structure)
  help        Show this help message

Global flags:
  --json      Output in JSON format where supported

Examples:
  bash script.sh prompt --role "developer" --task "write tests"
  bash script.sh tokenize --file prompt.txt
  bash script.sh template --list
  bash script.sh evaluate --input "Explain quantum computing"
EOF
}

# ---------------------------------------------------------------------------
# cmd_prompt - Build structured prompt
# ---------------------------------------------------------------------------

cmd_prompt() {
  local role="" context="" task="" constraints="" output_format=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --role)        shift; role="$1" ;;
      --context)     shift; context="$1" ;;
      --task)        shift; task="$1" ;;
      --constraints) shift; constraints="$1" ;;
      --format)      shift; output_format="$1" ;;
      *) die "Unknown option for prompt: $1" ;;
    esac
    shift
  done

  [[ -n "$task" ]] || die "prompt requires --task"

  local result=""

  # Build the structured prompt
  if [[ -n "$role" ]]; then
    result+="# Role\n"
    result+="You are ${role}.\n\n"
  fi

  if [[ -n "$context" ]]; then
    result+="# Context\n"
    result+="${context}\n\n"
  fi

  result+="# Task\n"
  result+="${task}\n"

  if [[ -n "$constraints" ]]; then
    result+="\n# Constraints\n"
    result+="${constraints}\n"
  fi

  if [[ -n "$output_format" ]]; then
    result+="\n# Output Format\n"
    result+="${output_format}\n"
  fi

  if [[ "$JSON_OUTPUT" == true ]]; then
    local json_role="${role:-null}"
    local json_ctx="${context:-null}"
    printf '{"role":"%s","context":"%s","task":"%s","constraints":"%s","format":"%s","prompt":"%s"}\n' \
      "$json_role" "$json_ctx" "$task" "${constraints:-}" "${output_format:-}" \
      "$(echo -e "$result" | sed 's/"/\\"/g' | tr '\n' ' ')"
  else
    echo -e "$result"
  fi
}

# ---------------------------------------------------------------------------
# cmd_compare - Compare prompt variations
# ---------------------------------------------------------------------------

cmd_compare() {
  local prompts=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --prompts) shift
        while [[ $# -gt 0 && ! "$1" =~ ^-- ]]; do
          prompts+=("$1")
          shift
        done
        continue
        ;;
      *) die "Unknown option for compare: $1" ;;
    esac
    shift
  done

  [[ ${#prompts[@]} -ge 2 ]] || die "compare requires at least 2 prompt files via --prompts"

  for f in "${prompts[@]}"; do
    [[ -f "$f" ]] || die "File not found: $f"
  done

  echo "=== Prompt Comparison ==="
  echo ""

  # Show each prompt with header
  local idx=1
  for f in "${prompts[@]}"; do
    echo "--- Variant $idx: $(basename "$f") ---"
    cat "$f"
    echo ""

    local wc_words wc_lines wc_chars
    wc_words=$(wc -w < "$f")
    wc_lines=$(wc -l < "$f")
    wc_chars=$(wc -c < "$f")
    local est_tokens=$(( wc_words * 4 / 3 ))

    echo "  Words: $wc_words | Lines: $wc_lines | Chars: $wc_chars | Est. tokens: $est_tokens"
    echo ""
    idx=$((idx + 1))
  done

  # Side-by-side diff of first two
  echo "=== Diff (Variant 1 vs Variant 2) ==="
  diff --side-by-side --width=100 "${prompts[0]}" "${prompts[1]}" || true
  echo ""

  # Stats comparison
  echo "=== Summary ==="
  for f in "${prompts[@]}"; do
    local w
    w=$(wc -w < "$f")
    local t=$(( w * 4 / 3 ))
    printf "  %-30s %5d words  ~%5d tokens\n" "$(basename "$f")" "$w" "$t"
  done
}

# ---------------------------------------------------------------------------
# cmd_tokenize - Estimate token count
# ---------------------------------------------------------------------------

estimate_tokens_cl100k() {
  # Approximate cl100k_base tokenization:
  # Average English: ~4 chars per token
  # We split on whitespace and punctuation boundaries for a better estimate
  local text="$1"
  local char_count=${#text}

  # Count whitespace-separated words
  local word_count
  word_count=$(echo "$text" | wc -w)

  # Heuristic: tokens ≈ words * 1.3 (accounts for subword splits)
  # But also consider that very short texts have more overhead
  local est_by_words=$(( (word_count * 13 + 5) / 10 ))
  local est_by_chars=$(( (char_count + 3) / 4 ))

  # Take the average of both methods for a better estimate
  local estimate=$(( (est_by_words + est_by_chars) / 2 ))

  # Minimum 1 token for non-empty text
  [[ $estimate -lt 1 && $char_count -gt 0 ]] && estimate=1

  echo "$estimate"
}

cmd_tokenize() {
  local text
  text=$(read_input "$@")

  local char_count=${#text}
  local word_count
  word_count=$(echo "$text" | wc -w)
  local line_count
  line_count=$(echo "$text" | wc -l)
  local token_estimate
  token_estimate=$(estimate_tokens_cl100k "$text")

  if [[ "$JSON_OUTPUT" == true ]]; then
    printf '{"chars":%d,"words":%d,"lines":%d,"estimated_tokens":%d,"model":"cl100k_base_approx"}\n' \
      "$char_count" "$word_count" "$line_count" "$token_estimate"
  else
    echo "Characters:       $char_count"
    echo "Words:            $word_count"
    echo "Lines:            $line_count"
    echo "Estimated tokens: $token_estimate (cl100k_base approx)"
  fi
}

# ---------------------------------------------------------------------------
# cmd_template - Prompt template management
# ---------------------------------------------------------------------------

cmd_template() {
  local action="" name="" file=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --save)   action="save";   shift; name="$1" ;;
      --load)   action="load";   shift; name="$1" ;;
      --list)   action="list" ;;
      --delete) action="delete"; shift; name="$1" ;;
      --file)   shift; file="$1" ;;
      *) die "Unknown option for template: $1" ;;
    esac
    shift
  done

  ensure_dir "$TEMPLATE_DIR"

  case "$action" in
    save)
      [[ -n "$name" ]] || die "template --save requires a name"
      local content
      if [[ -n "$file" ]]; then
        [[ -f "$file" ]] || die "File not found: $file"
        content=$(cat "$file")
      elif [[ ! -t 0 ]]; then
        content=$(cat)
      else
        die "template --save requires --file or stdin input"
      fi
      echo "$content" > "${TEMPLATE_DIR}/${name}.txt"
      log "Template saved: $name"
      ;;

    load)
      [[ -n "$name" ]] || die "template --load requires a name"
      local tpl="${TEMPLATE_DIR}/${name}.txt"
      [[ -f "$tpl" ]] || die "Template not found: $name"
      cat "$tpl"
      ;;

    list)
      if [[ "$JSON_OUTPUT" == true ]]; then
        printf '{"templates":['
        local first=true
        for f in "$TEMPLATE_DIR"/*.txt; do
          [[ -f "$f" ]] || continue
          local tname
          tname=$(basename "$f" .txt)
          local size
          size=$(wc -c < "$f")
          if [[ "$first" == true ]]; then
            first=false
          else
            printf ','
          fi
          printf '{"name":"%s","size":%d}' "$tname" "$size"
        done
        printf ']}\n'
      else
        echo "Saved templates:"
        local count=0
        for f in "$TEMPLATE_DIR"/*.txt; do
          [[ -f "$f" ]] || continue
          local tname
          tname=$(basename "$f" .txt)
          local size
          size=$(wc -c < "$f")
          printf "  %-30s %6d bytes\n" "$tname" "$size"
          count=$((count + 1))
        done
        [[ $count -eq 0 ]] && echo "  (none)"
        echo ""
        echo "Total: $count template(s)"
      fi
      ;;

    delete)
      [[ -n "$name" ]] || die "template --delete requires a name"
      local tpl="${TEMPLATE_DIR}/${name}.txt"
      [[ -f "$tpl" ]] || die "Template not found: $name"
      rm "$tpl"
      log "Template deleted: $name"
      ;;

    *)
      die "template requires --save, --list, --load, or --delete"
      ;;
  esac
}

# ---------------------------------------------------------------------------
# cmd_chain - Multi-step prompt chain
# ---------------------------------------------------------------------------

cmd_chain() {
  local steps=()
  local config_file=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --steps) shift
        while [[ $# -gt 0 && ! "$1" =~ ^-- ]]; do
          steps+=("$1")
          shift
        done
        continue
        ;;
      --from) shift; config_file="$1" ;;
      *) die "Unknown option for chain: $1" ;;
    esac
    shift
  done

  # Load steps from config file if provided
  if [[ -n "$config_file" ]]; then
    [[ -f "$config_file" ]] || die "Config file not found: $config_file"
    # Read steps array from JSON config
    while IFS= read -r line; do
      [[ -n "$line" ]] && steps+=("$line")
    done < <(grep -oP '"[^"]+\.txt"' "$config_file" | tr -d '"')

    [[ ${#steps[@]} -gt 0 ]] || die "No steps found in config file"
  fi

  [[ ${#steps[@]} -ge 1 ]] || die "chain requires --steps or --from with at least 1 step"

  for f in "${steps[@]}"; do
    [[ -f "$f" ]] || die "Step file not found: $f"
  done

  echo "=== Prompt Chain ==="
  echo "Steps: ${#steps[@]}"
  echo ""

  local step_num=1
  local prev_output=""

  for step_file in "${steps[@]}"; do
    echo "--- Step $step_num: $(basename "$step_file") ---"
    local step_content
    step_content=$(cat "$step_file")

    # Substitute {{previous_output}} placeholder if present
    if [[ -n "$prev_output" ]]; then
      step_content="${step_content//\{\{previous_output\}\}/$prev_output}"
    fi

    echo "$step_content"
    echo ""

    # The output of this step becomes input for the next
    prev_output="$step_content"
    step_num=$((step_num + 1))
  done

  if [[ "$JSON_OUTPUT" == true ]]; then
    printf '{"chain_length":%d,"steps":[' "${#steps[@]}"
    local first=true
    local sn=1
    for sf in "${steps[@]}"; do
      [[ "$first" == true ]] && first=false || printf ','
      printf '{"step":%d,"file":"%s"}' "$sn" "$(basename "$sf")"
      sn=$((sn + 1))
    done
    printf ']}\n'
  fi

  echo "=== Chain complete ==="
}

# ---------------------------------------------------------------------------
# cmd_evaluate - Evaluate prompt quality
# ---------------------------------------------------------------------------

score_dimension() {
  local text="$1"
  local dimension="$2"
  local score=50  # Base score

  case "$dimension" in
    clarity)
      # Deduct for vague words, award for specific instructions
      local vague_count
      vague_count=$(echo "$text" | grep -ioP '\b(something|stuff|things|whatever|maybe|probably)\b' | wc -l)
      score=$((score - vague_count * 10))

      # Award for clear structure markers
      local structure_count
      structure_count=$(echo "$text" | grep -cP '(^#|\d\.|^-|\*|Step \d)' || true)
      score=$((score + structure_count * 5))

      # Award for specific verbs
      local verb_count
      verb_count=$(echo "$text" | grep -ioP '\b(write|create|list|explain|compare|analyze|generate|describe|summarize|translate)\b' | wc -l)
      score=$((score + verb_count * 8))
      ;;

    specificity)
      # Award for concrete details
      local number_count
      number_count=$(echo "$text" | grep -oP '\d+' | wc -l)
      score=$((score + number_count * 5))

      # Award for quoted examples
      local quote_count
      quote_count=$(echo "$text" | grep -oP '"[^"]+"' | wc -l)
      score=$((score + quote_count * 8))

      # Length factor - longer prompts tend to be more specific
      local wc
      wc=$(echo "$text" | wc -w)
      if [[ $wc -gt 50 ]]; then
        score=$((score + 15))
      elif [[ $wc -gt 20 ]]; then
        score=$((score + 8))
      fi
      ;;

    structure)
      # Check for sections/headers
      local header_count
      header_count=$(echo "$text" | grep -cP '^#+\s' || true)
      score=$((score + header_count * 12))

      # Check for lists
      local list_count
      list_count=$(echo "$text" | grep -cP '^\s*[-*\d]+[\.\)]\s' || true)
      score=$((score + list_count * 6))

      # Check for line breaks / paragraphs
      local para_count
      para_count=$(echo "$text" | grep -cP '^\s*$' || true)
      score=$((score + para_count * 4))
      ;;

    completeness)
      # Check for role definition
      echo "$text" | grep -iqP '(you are|act as|role|persona)' && score=$((score + 15))

      # Check for output format spec
      echo "$text" | grep -iqP '(output|format|return|respond|reply)' && score=$((score + 12))

      # Check for constraints
      echo "$text" | grep -iqP '(do not|don.t|must|should|avoid|constraint|limit)' && score=$((score + 10))

      # Check for examples
      echo "$text" | grep -iqP '(example|e\.g\.|for instance|such as)' && score=$((score + 12))
      ;;
  esac

  # Clamp to 0-100
  [[ $score -lt 0 ]] && score=0
  [[ $score -gt 100 ]] && score=100

  echo "$score"
}

cmd_evaluate() {
  local text
  text=$(read_input "$@")

  local clarity specificity structure completeness
  clarity=$(score_dimension "$text" "clarity")
  specificity=$(score_dimension "$text" "specificity")
  structure=$(score_dimension "$text" "structure")
  completeness=$(score_dimension "$text" "completeness")

  local total=$(( (clarity + specificity + structure + completeness) / 4 ))

  local grade
  if [[ $total -ge 85 ]]; then grade="A"
  elif [[ $total -ge 70 ]]; then grade="B"
  elif [[ $total -ge 55 ]]; then grade="C"
  elif [[ $total -ge 40 ]]; then grade="D"
  else grade="F"
  fi

  if [[ "$JSON_OUTPUT" == true ]]; then
    printf '{"overall":%d,"grade":"%s","clarity":%d,"specificity":%d,"structure":%d,"completeness":%d}\n' \
      "$total" "$grade" "$clarity" "$specificity" "$structure" "$completeness"
  else
    echo "=== Prompt Quality Evaluation ==="
    echo ""
    echo "Overall Score: ${total}/100 (Grade: $grade)"
    echo ""
    echo "Breakdown:"
    printf "  Clarity:      %3d/100\n" "$clarity"
    printf "  Specificity:  %3d/100\n" "$specificity"
    printf "  Structure:    %3d/100\n" "$structure"
    printf "  Completeness: %3d/100\n" "$completeness"
    echo ""

    # Suggestions
    echo "Suggestions:"
    [[ $clarity -lt 60 ]] && echo "  - Add specific action verbs (write, create, list, explain)"
    [[ $specificity -lt 60 ]] && echo "  - Include concrete details, numbers, or examples"
    [[ $structure -lt 60 ]] && echo "  - Add headers, bullet points, or numbered steps"
    [[ $completeness -lt 60 ]] && echo "  - Define role, output format, constraints, and examples"
    [[ $total -ge 80 ]] && echo "  - Prompt looks solid. Minor tweaks only."
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
    prompt)   cmd_prompt "$@" ;;
    compare)  cmd_compare "$@" ;;
    tokenize) cmd_tokenize "$@" ;;
    template) cmd_template "$@" ;;
    chain)    cmd_chain "$@" ;;
    evaluate) cmd_evaluate "$@" ;;
    help)     cmd_help ;;
    *)        die "Unknown command: $command. Run 'help' for usage." ;;
  esac
}

main "$@"
