#!/usr/bin/env bash
set -euo pipefail

######################################################################
# student/scripts/script.sh — Study & Academic Assistant
# Powered by BytesAgain | bytesagain.com
######################################################################

DATA_DIR="${HOME}/.student"
NOTES_DIR="${DATA_DIR}/notes"

# ── helpers ─────────────────────────────────────────────────────────

ensure_data_dir() {
  mkdir -p "${NOTES_DIR}"
}

timestamp() {
  date +"%Y-%m-%d %H:%M:%S"
}

today() {
  date +%Y-%m-%d
}

validate_number() {
  local val="${1:-}" label="${2:-value}"
  if [[ -z "${val}" ]] || ! [[ "${val}" =~ ^[0-9]+$ ]]; then
    echo "Error: ${label} must be a positive integer, got '${val}'." >&2
    exit 1
  fi
}

# ── cmd_note ────────────────────────────────────────────────────────

cmd_note() {
  local subject="${1:-}" content="${2:-}"

  if [[ -z "${subject}" || -z "${content}" ]]; then
    echo "Usage: script.sh note <subject> \"<content>\""
    echo "  Example: script.sh note biology \"Mitosis has 4 phases: prophase, metaphase, anaphase, telophase\""
    exit 1
  fi

  ensure_data_dir

  local subject_dir="${NOTES_DIR}/${subject}"
  mkdir -p "${subject_dir}"

  local ts
  ts="$(timestamp)"
  local filename="${subject_dir}/$(today).md"

  # Append to the day's note file
  {
    echo ""
    echo "## ${ts}"
    echo ""
    echo "${content}"
    echo ""
  } >> "${filename}"

  local count
  count=$(grep -c "^## " "${filename}" 2>/dev/null || echo "0")

  echo "📝 Note added to ${subject}"
  echo "   File: ${filename}"
  echo "   Entries today: ${count}"
}

# ── cmd_summarize ───────────────────────────────────────────────────

cmd_summarize() {
  local filepath="${1:-}" max_sentences="${2:-5}"

  if [[ -z "${filepath}" ]]; then
    echo "Usage: script.sh summarize <file_path> [max_sentences]"
    exit 1
  fi

  if [[ ! -f "${filepath}" ]]; then
    echo "Error: file not found: ${filepath}" >&2
    exit 1
  fi

  validate_number "${max_sentences}" "max_sentences"

  python3 << 'PYEOF' "${filepath}" "${max_sentences}"
import re, sys

with open(sys.argv[1], 'r') as f:
    text = f.read()

max_s = int(sys.argv[2])

# Split into sentences
sentences = re.split(r'(?<=[.!?])\s+', text.strip())
sentences = [s.strip() for s in sentences if len(s.strip()) > 10]

if not sentences:
    print('⚠️  No extractable sentences found.')
    sys.exit(0)

# Score sentences by word count and position
scored = []
total = len(sentences)
for i, s in enumerate(sentences):
    words = s.split()
    word_count = len(words)
    # Favor longer sentences and those near start/end
    position_score = 1.0
    if i < total * 0.2:
        position_score = 1.5
    elif i > total * 0.8:
        position_score = 1.3
    score = word_count * position_score
    scored.append((score, i, s))

scored.sort(key=lambda x: x[0], reverse=True)
top = sorted(scored[:max_s], key=lambda x: x[1])  # restore original order

print(f'📖 Summary ({len(top)} of {total} sentences):')
print('=' * 50)
for _, _, s in top:
    print(f'  • {s}')
print()
print(f'Original: {len(text)} chars, {total} sentences')
print(f'Summary:  {sum(len(s) for _,_,s in top)} chars, {len(top)} sentences')
PYEOF
}

# ── cmd_cite ────────────────────────────────────────────────────────

cmd_cite() {
  local style="${1:-}" author="${2:-}" title="${3:-}" year="${4:-}" publisher="${5:-}" url="${6:-}"

  if [[ -z "${style}" || -z "${author}" || -z "${title}" || -z "${year}" ]]; then
    echo "Usage: script.sh cite <apa|mla> \"<author>\" \"<title>\" <year> [\"publisher\"] [\"url\"]"
    echo "  Example: script.sh cite apa \"Smith, J.\" \"Data Science Basics\" 2023 \"O'Reilly\""
    exit 1
  fi

  style_lower="$(echo "${style}" | tr '[:upper:]' '[:lower:]')"

  case "${style_lower}" in
    apa)
      local citation="${author} (${year}). ${title}."
      [[ -n "${publisher}" ]] && citation="${citation} ${publisher}."
      [[ -n "${url}" ]] && citation="${citation} Retrieved from ${url}"
      echo "📚 APA Citation:"
      echo "   ${citation}"
      ;;
    mla)
      local citation="${author}. \"${title}.\" "
      [[ -n "${publisher}" ]] && citation="${citation}${publisher}, "
      citation="${citation}${year}."
      [[ -n "${url}" ]] && citation="${citation} ${url}."
      echo "📚 MLA Citation:"
      echo "   ${citation}"
      ;;
    *)
      echo "Error: style must be 'apa' or 'mla', got '${style}'." >&2
      exit 1
      ;;
  esac
}

# ── cmd_outline ─────────────────────────────────────────────────────

cmd_outline() {
  local topic="${1:-}" num_sections="${2:-3}"

  if [[ -z "${topic}" ]]; then
    echo "Usage: script.sh outline \"<topic>\" [num_sections]"
    exit 1
  fi

  validate_number "${num_sections}" "num_sections"

  echo "📑 Essay Outline: ${topic}"
  echo "=" "$(printf '=%.0s' $(seq 1 50))"
  echo ""
  echo "I. Introduction"
  echo "   A. Hook / Opening statement"
  echo "   B. Background on ${topic}"
  echo "   C. Thesis statement"
  echo ""

  local roman=("II" "III" "IV" "V" "VI" "VII" "VIII" "IX" "X" "XI" "XII")
  for ((i = 0; i < num_sections && i < ${#roman[@]}; i++)); do
    local section_num=$((i + 1))
    echo "${roman[$i]}. Body Section ${section_num}"
    echo "   A. Topic sentence"
    echo "   B. Supporting evidence / data"
    echo "   C. Analysis and connection to thesis"
    echo "   D. Transition to next section"
    echo ""
  done

  local conclusion_idx=$((num_sections))
  if ((conclusion_idx < ${#roman[@]})); then
    echo "${roman[$conclusion_idx]}. Conclusion"
  else
    echo "XIII. Conclusion"
  fi
  echo "   A. Restate thesis"
  echo "   B. Summarize key points"
  echo "   C. Final thought / call to action"
  echo ""
  echo "References"
  echo "   [List sources in chosen citation format]"
}

# ── cmd_timer ───────────────────────────────────────────────────────

cmd_timer() {
  local work="${1:-25}" break_time="${2:-5}"

  validate_number "${work}" "work_minutes"
  validate_number "${break_time}" "break_minutes"

  echo "🍅 Pomodoro Timer"
  echo "   Work:  ${work} minutes"
  echo "   Break: ${break_time} minutes"
  echo ""

  # Work phase
  echo "▶ Starting work phase (${work} min)..."
  local total_seconds=$((work * 60))
  local elapsed=0
  while ((elapsed < total_seconds)); do
    local remaining=$((total_seconds - elapsed))
    local mins=$((remaining / 60))
    local secs=$((remaining % 60))
    printf "\r   ⏱  %02d:%02d remaining " "${mins}" "${secs}"
    sleep 1
    ((elapsed++))
  done
  printf "\r   ✅ Work phase complete!           \n"

  echo ""
  echo "☕ Break time! (${break_time} min)"

  # Break phase
  total_seconds=$((break_time * 60))
  elapsed=0
  while ((elapsed < total_seconds)); do
    local remaining=$((total_seconds - elapsed))
    local mins=$((remaining / 60))
    local secs=$((remaining % 60))
    printf "\r   ⏱  %02d:%02d remaining " "${mins}" "${secs}"
    sleep 1
    ((elapsed++))
  done
  printf "\r   ✅ Break over! Ready for next session.\n"
}

# ── cmd_gpa ─────────────────────────────────────────────────────────

cmd_gpa() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: script.sh gpa \"<course:grade:credits>\" [\"<course:grade:credits>\" ...]"
    echo "  Grades: A (4.0), A- (3.7), B+ (3.3), B (3.0), B- (2.7),"
    echo "          C+ (2.3), C (2.0), C- (1.7), D+ (1.3), D (1.0), F (0.0)"
    echo "  Example: script.sh gpa \"Math:A:3\" \"English:B+:4\" \"History:A-:3\""
    exit 1
  fi

  python3 << 'PYEOF' "$@"
import sys

grade_points = {
    'A': 4.0, 'A+': 4.0, 'A-': 3.7,
    'B+': 3.3, 'B': 3.0, 'B-': 2.7,
    'C+': 2.3, 'C': 2.0, 'C-': 1.7,
    'D+': 1.3, 'D': 1.0, 'D-': 0.7,
    'F': 0.0
}

entries = sys.argv[1:]
total_points = 0.0
total_credits = 0.0
rows = []

for entry in entries:
    parts = entry.split(':')
    if len(parts) != 3:
        print(f'Error: invalid format "{entry}". Use "course:grade:credits"', file=sys.stderr)
        sys.exit(1)
    course, grade, credits = parts[0].strip(), parts[1].strip().upper(), parts[2].strip()
    try:
        cred = float(credits)
    except ValueError:
        print(f'Error: credits must be a number in "{entry}"', file=sys.stderr)
        sys.exit(1)
    if grade not in grade_points:
        print(f'Error: unknown grade "{grade}" in "{entry}"', file=sys.stderr)
        sys.exit(1)
    gp = grade_points[grade]
    total_points += gp * cred
    total_credits += cred
    rows.append((course, grade, cred, gp))

gpa = total_points / total_credits if total_credits else 0.0

print('🎓 GPA Calculator')
print('=' * 50)
print(f'{"Course":<20s} {"Grade":<6s} {"Credits":<8s} {"Points":<6s}')
print('-' * 50)
for course, grade, cred, gp in rows:
    print(f'{course:<20s} {grade:<6s} {cred:<8.1f} {gp * cred:<6.1f}')
print('-' * 50)
print(f'{"Total":<20s} {"":<6s} {total_credits:<8.1f} {total_points:<6.1f}')
print()
print(f'📊 GPA: {gpa:.2f} / 4.00')
if gpa >= 3.7:
    label = "Dean's List"
elif gpa >= 3.0:
    label = 'Honors'
elif gpa >= 2.0:
    label = 'Good Standing'
else:
    label = 'Academic Warning'
print(f'   Status: {label}')
PYEOF
}

# ── cmd_help ────────────────────────────────────────────────────────

cmd_help() {
  cat <<'EOF'
student — Study & Academic Assistant

Commands:
  note <subject> "<content>"                    Record a study note
  summarize <file> [max_sentences]              Extract key sentences from text
  cite <apa|mla> "<author>" "<title>" <year>    Format a citation
  outline "<topic>" [num_sections]              Generate an essay outline
  timer [work_min] [break_min]                  Pomodoro study timer
  gpa "<course:grade:credits>" [...]            Calculate GPA
  help                                          Show this help message

Data stored in: ~/.student/
EOF
}

# ── main dispatch ───────────────────────────────────────────────────

main() {
  local cmd="${1:-help}"
  shift || true

  case "${cmd}" in
    note)      cmd_note "$@" ;;
    summarize) cmd_summarize "$@" ;;
    cite)      cmd_cite "$@" ;;
    outline)   cmd_outline "$@" ;;
    timer)     cmd_timer "$@" ;;
    gpa)       cmd_gpa "$@" ;;
    help|--help|-h) cmd_help ;;
    *)
      echo "Unknown command: ${cmd}" >&2
      cmd_help
      exit 1
      ;;
  esac
}

main "$@"
