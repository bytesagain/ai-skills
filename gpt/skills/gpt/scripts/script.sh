#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# gpt - GPT API Calling Assistant
# Version: 3.0.0
# Author: BytesAgain
#
# Commands: chat, embed, finetune, cost, batch, convert
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------------------------------------------------------------------------
# Utilities
# ---------------------------------------------------------------------------

die() { echo "ERROR: $*" >&2; exit 1; }

log() { echo "[gpt] $*" >&2; }

json_escape() {
  local text="$1"
  text="${text//\\/\\\\}"
  text="${text//\"/\\\"}"
  text="${text//$'\n'/\\n}"
  text="${text//$'\t'/\\t}"
  echo "$text"
}

estimate_tokens() {
  local text="$1"
  local words
  words=$(echo "$text" | wc -w)
  echo $(( (words * 13 + 5) / 10 ))
}

file_tokens() {
  local file="$1"
  [[ -f "$file" ]] || die "File not found: $file"
  local words
  words=$(wc -w < "$file")
  echo $(( (words * 13 + 5) / 10 ))
}

# ---------------------------------------------------------------------------
# Model pricing (per 1M tokens, USD)
# ---------------------------------------------------------------------------

get_input_price() {
  case "$1" in
    gpt-4o)              echo "2.50" ;;
    gpt-4o-mini)         echo "0.15" ;;
    gpt-4-turbo)         echo "10.00" ;;
    gpt-4)               echo "30.00" ;;
    gpt-3.5-turbo)       echo "0.50" ;;
    text-embedding-3-small) echo "0.02" ;;
    text-embedding-3-large) echo "0.13" ;;
    *)                   echo "2.50" ;;  # default to gpt-4o
  esac
}

get_output_price() {
  case "$1" in
    gpt-4o)              echo "10.00" ;;
    gpt-4o-mini)         echo "0.60" ;;
    gpt-4-turbo)         echo "30.00" ;;
    gpt-4)               echo "60.00" ;;
    gpt-3.5-turbo)       echo "1.50" ;;
    text-embedding-3-small) echo "0.00" ;;
    text-embedding-3-large) echo "0.00" ;;
    *)                   echo "10.00" ;;
  esac
}

# ---------------------------------------------------------------------------
# cmd_help - List all commands
# ---------------------------------------------------------------------------

cmd_help() {
  cat <<'EOF'
gpt - GPT API Calling Assistant

Usage: bash script.sh <command> [options]

Commands:
  chat        Build a chat completion request JSON payload
  embed       Generate an embedding API request payload
  finetune    Prepare and validate fine-tuning JSONL data
  cost        Estimate API costs by token count and model
  batch       Generate multiple API request payloads from input list
  convert     Convert between JSONL and CSV formats
  help        Show this help message

Common options:
  --model     Model name (default: gpt-4o)
  --output    Write output to file instead of stdout

Examples:
  bash script.sh chat --system "Translator" --user "Hello"
  bash script.sh cost --tokens 5000 --model gpt-4o
  bash script.sh convert --input data.csv --to jsonl
EOF
}

# ---------------------------------------------------------------------------
# cmd_chat - Build chat completion request
# ---------------------------------------------------------------------------

cmd_chat() {
  local system_msg="" user_msg="" model="gpt-4o" temperature="1" max_tokens="" output=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --system)      shift; system_msg="$1" ;;
      --user)        shift; user_msg="$1" ;;
      --model)       shift; model="$1" ;;
      --temperature) shift; temperature="$1" ;;
      --max-tokens)  shift; max_tokens="$1" ;;
      --output)      shift; output="$1" ;;
      *) die "Unknown option for chat: $1" ;;
    esac
    shift
  done

  [[ -n "$user_msg" ]] || die "chat requires --user message"

  local json='{'
  json+="\"model\":\"${model}\","
  json+="\"messages\":["

  if [[ -n "$system_msg" ]]; then
    json+="{\"role\":\"system\",\"content\":\"$(json_escape "$system_msg")\"},"
  fi

  json+="{\"role\":\"user\",\"content\":\"$(json_escape "$user_msg")\"}"
  json+="],"
  json+="\"temperature\":${temperature}"

  if [[ -n "$max_tokens" ]]; then
    json+=",\"max_tokens\":${max_tokens}"
  fi

  json+='}'

  if [[ -n "$output" ]]; then
    echo "$json" > "$output"
    log "Chat request written to $output"
  else
    echo "$json"
  fi
}

# ---------------------------------------------------------------------------
# cmd_embed - Generate embedding request
# ---------------------------------------------------------------------------

cmd_embed() {
  local input="" file="" model="text-embedding-3-small" output=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --input)  shift; input="$1" ;;
      --file)   shift; file="$1" ;;
      --model)  shift; model="$1" ;;
      --output) shift; output="$1" ;;
      *) die "Unknown option for embed: $1" ;;
    esac
    shift
  done

  local texts=()

  if [[ -n "$input" ]]; then
    texts+=("$input")
  elif [[ -n "$file" ]]; then
    [[ -f "$file" ]] || die "File not found: $file"
    while IFS= read -r line; do
      [[ -n "$line" ]] && texts+=("$line")
    done < "$file"
  else
    die "embed requires --input or --file"
  fi

  local json='{'
  json+="\"model\":\"${model}\","

  if [[ ${#texts[@]} -eq 1 ]]; then
    json+="\"input\":\"$(json_escape "${texts[0]}")\""
  else
    json+="\"input\":["
    local first=true
    for t in "${texts[@]}"; do
      [[ "$first" == true ]] && first=false || json+=","
      json+="\"$(json_escape "$t")\""
    done
    json+="]"
  fi

  json+='}'

  if [[ -n "$output" ]]; then
    echo "$json" > "$output"
    log "Embedding request written to $output"
  else
    echo "$json"
  fi
}

# ---------------------------------------------------------------------------
# cmd_finetune - Prepare fine-tuning data
# ---------------------------------------------------------------------------

cmd_finetune() {
  local input="" output="" validate=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --input)    shift; input="$1" ;;
      --output)   shift; output="$1" ;;
      --validate) shift; validate="$1" ;;
      *) die "Unknown option for finetune: $1" ;;
    esac
    shift
  done

  if [[ -n "$validate" ]]; then
    # Validate a JSONL file
    [[ -f "$validate" ]] || die "File not found: $validate"

    local line_num=0
    local errors=0
    local valid=0

    while IFS= read -r line; do
      line_num=$((line_num + 1))
      [[ -z "$line" ]] && continue

      # Check it's valid JSON-ish (has messages array)
      if echo "$line" | grep -q '"messages"'; then
        # Check for required roles
        if echo "$line" | grep -q '"role"'; then
          valid=$((valid + 1))
        else
          echo "Line $line_num: Missing 'role' field"
          errors=$((errors + 1))
        fi
      else
        echo "Line $line_num: Missing 'messages' field"
        errors=$((errors + 1))
      fi
    done < "$validate"

    echo ""
    echo "=== Validation Results ==="
    echo "Total lines:  $line_num"
    echo "Valid:        $valid"
    echo "Errors:       $errors"

    if [[ $errors -eq 0 ]]; then
      echo "Status:       PASS"
    else
      echo "Status:       FAIL"
      exit 1
    fi
    return
  fi

  [[ -n "$input" ]] || die "finetune requires --input (CSV file) or --validate (JSONL file)"
  [[ -f "$input" ]] || die "File not found: $input"

  # Convert CSV (system,user,assistant) to JSONL
  local out_target="${output:-/dev/stdout}"
  local count=0

  # Skip header line
  local first=true
  while IFS=, read -r system_msg user_msg assistant_msg; do
    if [[ "$first" == true ]]; then
      first=false
      # Check if it's a header
      if [[ "$system_msg" == "system" || "$system_msg" == "System" ]]; then
        continue
      fi
    fi

    [[ -z "$user_msg" ]] && continue

    local entry='{"messages":['
    if [[ -n "$system_msg" ]]; then
      entry+="{\"role\":\"system\",\"content\":\"$(json_escape "$system_msg")\"},"
    fi
    entry+="{\"role\":\"user\",\"content\":\"$(json_escape "$user_msg")\"},"
    entry+="{\"role\":\"assistant\",\"content\":\"$(json_escape "$assistant_msg")\"}"
    entry+=']}'

    echo "$entry"
    count=$((count + 1))
  done < "$input" > "$out_target"

  log "Converted $count examples to JSONL"
}

# ---------------------------------------------------------------------------
# cmd_cost - Estimate API costs
# ---------------------------------------------------------------------------

cmd_cost() {
  local tokens="" model="gpt-4o" file="" output_ratio="1.5"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --tokens)       shift; tokens="$1" ;;
      --model)        shift; model="$1" ;;
      --file)         shift; file="$1" ;;
      --output-ratio) shift; output_ratio="$1" ;;
      *) die "Unknown option for cost: $1" ;;
    esac
    shift
  done

  if [[ -n "$file" ]]; then
    tokens=$(file_tokens "$file")
    log "Estimated $tokens input tokens from $file"
  fi

  [[ -n "$tokens" ]] || die "cost requires --tokens or --file"

  local input_price output_price
  input_price=$(get_input_price "$model")
  output_price=$(get_output_price "$model")

  # Estimate output tokens as input * ratio
  local output_tokens
  output_tokens=$(awk "BEGIN {printf \"%d\", $tokens * $output_ratio}")

  # Calculate costs (per 1M tokens)
  local input_cost output_cost total_cost
  input_cost=$(awk "BEGIN {printf \"%.6f\", $tokens * $input_price / 1000000}")
  output_cost=$(awk "BEGIN {printf \"%.6f\", $output_tokens * $output_price / 1000000}")
  total_cost=$(awk "BEGIN {printf \"%.6f\", $input_cost + $output_cost}")

  echo "=== API Cost Estimate ==="
  echo ""
  echo "Model:          $model"
  echo "Input tokens:   $tokens"
  echo "Output tokens:  $output_tokens (estimated at ${output_ratio}x input)"
  echo ""
  printf "Input cost:     \$%s  (\$%s / 1M tokens)\n" "$input_cost" "$input_price"
  printf "Output cost:    \$%s  (\$%s / 1M tokens)\n" "$output_cost" "$output_price"
  echo "----------------------------"
  printf "Total:          \$%s\n" "$total_cost"
  echo ""

  # Show comparison with other models
  echo "=== Comparison (same input) ==="
  printf "  %-25s %10s %10s %10s\n" "Model" "Input" "Output" "Total"
  for m in gpt-4o gpt-4o-mini gpt-4-turbo gpt-3.5-turbo; do
    local ip op ic oc tc
    ip=$(get_input_price "$m")
    op=$(get_output_price "$m")
    ic=$(awk "BEGIN {printf \"%.4f\", $tokens * $ip / 1000000}")
    oc=$(awk "BEGIN {printf \"%.4f\", $output_tokens * $op / 1000000}")
    tc=$(awk "BEGIN {printf \"%.4f\", $ic + $oc}")
    printf "  %-25s \$%8s \$%8s \$%8s\n" "$m" "$ic" "$oc" "$tc"
  done
}

# ---------------------------------------------------------------------------
# cmd_batch - Generate batch requests
# ---------------------------------------------------------------------------

cmd_batch() {
  local file="" model="gpt-4o" output="" system_msg="" temperature="1"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --file)        shift; file="$1" ;;
      --model)       shift; model="$1" ;;
      --output)      shift; output="$1" ;;
      --system)      shift; system_msg="$1" ;;
      --temperature) shift; temperature="$1" ;;
      *) die "Unknown option for batch: $1" ;;
    esac
    shift
  done

  [[ -n "$file" ]] || die "batch requires --file (one prompt per line)"
  [[ -f "$file" ]] || die "File not found: $file"

  local out_target="${output:-/dev/stdout}"
  local count=0
  local idx=0

  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    idx=$((idx + 1))

    local request='{"custom_id":"request-'${idx}'",'
    request+='"method":"POST","url":"/v1/chat/completions",'
    request+='"body":{"model":"'${model}'","messages":['

    if [[ -n "$system_msg" ]]; then
      request+="{\"role\":\"system\",\"content\":\"$(json_escape "$system_msg")\"},"
    fi

    request+="{\"role\":\"user\",\"content\":\"$(json_escape "$line")\"}"
    request+="],\"temperature\":${temperature}}}"

    echo "$request"
    count=$((count + 1))
  done < "$file" > "$out_target"

  log "Generated $count batch requests"
}

# ---------------------------------------------------------------------------
# cmd_convert - Format conversion (JSONL <-> CSV)
# ---------------------------------------------------------------------------

cmd_convert() {
  local input="" to="" output=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --input)  shift; input="$1" ;;
      --to)     shift; to="$1" ;;
      --output) shift; output="$1" ;;
      *) die "Unknown option for convert: $1" ;;
    esac
    shift
  done

  [[ -n "$input" ]] || die "convert requires --input"
  [[ -f "$input" ]] || die "File not found: $input"
  [[ -n "$to" ]]    || die "convert requires --to (jsonl or csv)"

  local out_target="${output:-/dev/stdout}"

  case "$to" in
    jsonl)
      # CSV to JSONL
      local first=true
      local headers=()
      while IFS=, read -r -a fields; do
        if [[ "$first" == true ]]; then
          first=false
          headers=("${fields[@]}")
          continue
        fi

        local json="{"
        local f_first=true
        for i in "${!headers[@]}"; do
          [[ "$f_first" == true ]] && f_first=false || json+=","
          local val="${fields[$i]:-}"
          # Remove surrounding quotes if present
          val="${val#\"}"
          val="${val%\"}"
          json+="\"${headers[$i]}\":\"$(json_escape "$val")\""
        done
        json+="}"
        echo "$json"
      done < "$input" > "$out_target"
      log "Converted CSV to JSONL"
      ;;

    csv)
      # JSONL to CSV - extract keys from first line as headers
      local first_line
      first_line=$(head -1 "$input")

      # Extract keys (simple approach: find "key": patterns)
      local keys=()
      while IFS= read -r key; do
        keys+=("$key")
      done < <(echo "$first_line" | grep -oP '"([^"]+)"\s*:' | grep -oP '"[^"]+"' | tr -d '"')

      # Print header
      local header=""
      local h_first=true
      for k in "${keys[@]}"; do
        [[ "$h_first" == true ]] && h_first=false || header+=","
        header+="$k"
      done
      echo "$header" > "$out_target"

      # Print rows
      while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        local row=""
        local r_first=true
        for k in "${keys[@]}"; do
          [[ "$r_first" == true ]] && r_first=false || row+=","
          # Extract value for this key
          local val
          val=$(echo "$line" | grep -oP "\"${k}\"\s*:\s*\"[^\"]*\"" | head -1 | sed 's/.*: *"//;s/"$//' || echo "")
          if [[ -z "$val" ]]; then
            # Try numeric value
            val=$(echo "$line" | grep -oP "\"${k}\"\s*:\s*[0-9.]+" | head -1 | sed 's/.*: *//' || echo "")
          fi
          row+="\"$val\""
        done
        echo "$row"
      done < "$input" >> "$out_target"
      log "Converted JSONL to CSV"
      ;;

    *)
      die "Unknown format: $to (supported: jsonl, csv)"
      ;;
  esac
}

# ---------------------------------------------------------------------------
# Main dispatch
# ---------------------------------------------------------------------------

main() {
  [[ $# -ge 1 ]] || { cmd_help; exit 0; }

  local command="$1"
  shift

  case "$command" in
    chat)     cmd_chat "$@" ;;
    embed)    cmd_embed "$@" ;;
    finetune) cmd_finetune "$@" ;;
    cost)     cmd_cost "$@" ;;
    batch)    cmd_batch "$@" ;;
    convert)  cmd_convert "$@" ;;
    help)     cmd_help ;;
    *)        die "Unknown command: $command. Run 'help' for usage." ;;
  esac
}

main "$@"
