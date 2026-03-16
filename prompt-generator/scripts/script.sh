#!/usr/bin/env bash
# prompt-generator — AI prompt engineering and template generator
set -euo pipefail
VERSION="2.0.0"
DATA_DIR="${PROMPT_GENERATOR_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/prompt-generator}"
DB="$DATA_DIR/entries.jsonl"
mkdir -p "$DATA_DIR"

show_help() {
    cat << EOF
prompt-generator v$VERSION — AI prompt crafting toolkit

Usage: prompt-generator <command> [args]

Generate:
  create <task> [style]        Generate a prompt for any task
  system <role>                System prompt for a role
  chain <task> <steps>         Multi-step prompt chain
  few-shot <task> <n>          Few-shot prompt with N examples

Templates:
  code <language> <task>       Code generation prompt
  write <type> <topic>         Writing prompt (blog/essay/email/story)
  analyze <subject>            Analysis prompt
  translate <from> <to>        Translation prompt
  summarize <style>            Summarization prompt (bullet/paragraph/tldr)

Optimize:
  improve <prompt>             Improve an existing prompt
  score <prompt>               Rate prompt quality
  debug <prompt>               Find prompt issues
  compare <p1> <p2>            Compare two prompts

Techniques:
  cot <task>                   Chain-of-thought template
  tree <task>                  Tree-of-thought template
  react <task>                 ReAct (Reasoning + Acting) template
  persona <role> <task>        Role-play prompt
  constraints <task> <rules>   Constrained generation
  help                         Show this help
EOF
}

cmd_create() {
    local task="${1:?Usage: prompt-generator create <task> [style]}"
    local style="${2:-detailed}"
    echo "  ═══ Generated Prompt ═══"
    echo ""
    echo "  You are an expert at $task."
    echo ""
    echo "  ## Task"
    echo "  [Specific description of what to do]"
    echo ""
    echo "  ## Context"
    echo "  [Background information and constraints]"
    echo ""
    echo "  ## Requirements"
    echo "  - [Requirement 1]"
    echo "  - [Requirement 2]"
    echo "  - [Requirement 3]"
    echo ""
    echo "  ## Output Format"
    echo "  [Specify exact format: JSON/markdown/list/etc]"
    echo ""
    echo "  ## Examples"
    echo "  Input: [example input]"
    echo "  Output: [example output]"
    _log "create" "$task"
}

cmd_system() {
    local role="${1:?Usage: prompt-generator system <role>}"
    echo "  ═══ System Prompt: $role ═══"
    echo ""
    echo "  You are a $role with deep expertise in [domain]."
    echo ""
    echo "  ## Behavior"
    echo "  - Always [key behavior 1]"
    echo "  - Never [prohibited behavior]"
    echo "  - When uncertain, [fallback behavior]"
    echo ""
    echo "  ## Knowledge"
    echo "  - You are an expert in [specific areas]"
    echo "  - Your knowledge cutoff is [date]"
    echo ""
    echo "  ## Response Style"
    echo "  - Tone: [professional/casual/academic]"
    echo "  - Length: [concise/detailed/as-needed]"
    echo "  - Format: [structured/conversational]"
}

cmd_cot() {
    local task="${1:?}"
    echo "  ═══ Chain-of-Thought: $task ═══"
    echo ""
    echo "  Let us solve this step by step:"
    echo ""
    echo "  Step 1: Understand the problem"
    echo "  [Restate $task in your own words]"
    echo ""
    echo "  Step 2: Identify key information"
    echo "  [List relevant facts and constraints]"
    echo ""
    echo "  Step 3: Plan the approach"
    echo "  [Outline your solution strategy]"
    echo ""
    echo "  Step 4: Execute"
    echo "  [Show your work]"
    echo ""
    echo "  Step 5: Verify"
    echo "  [Check your answer makes sense]"
}

cmd_code() {
    local lang="${1:?Usage: prompt-generator code <language> <task>}"
    local task="${2:?}"
    echo "  ═══ Code Prompt: $lang ═══"
    echo ""
    echo "  Write a $lang program that $task."
    echo ""
    echo "  Requirements:"
    echo "  - Follow $lang best practices and conventions"
    echo "  - Include error handling"
    echo "  - Add comments for complex logic"
    echo "  - Write clean, readable code"
    echo ""
    echo "  Constraints:"
    echo "  - No external dependencies unless specified"
    echo "  - Must handle edge cases"
    echo ""
    echo "  Output: Complete, runnable code with usage example"
}

cmd_write() {
    local type="${1:-blog}"
    local topic="${2:-topic}"
    echo "  ═══ Writing Prompt ($type): $topic ═══"
    case "$type" in
        blog)  echo "  Write a blog post about $topic."
               echo "  Target: 800-1200 words, casual-professional tone"
               echo "  Include: intro hook, 3-5 sections with headers, conclusion with CTA"
               echo "  SEO: include relevant keywords naturally" ;;
        essay) echo "  Write an analytical essay about $topic."
               echo "  Structure: thesis, 3 supporting arguments, counterargument, conclusion"
               echo "  Tone: academic but accessible" ;;
        *) echo "  Types: blog, essay, email, story" ;;
    esac
}

cmd_score() {
    echo "  ═══ Prompt Quality Score ═══"
    echo "  [ ] Clear task definition?           /20"
    echo "  [ ] Specific output format?          /15"
    echo "  [ ] Context provided?                /15"
    echo "  [ ] Examples included?               /15"
    echo "  [ ] Constraints defined?             /10"
    echo "  [ ] Role/persona set?                /10"
    echo "  [ ] Edge cases addressed?            /10"
    echo "  [ ] Concise (no fluff)?              /5"
    echo "  ──────────────────────────────"
    echo "  Total:                               /100"
}

cmd_techniques() {
    echo "  ═══ Prompt Techniques ═══"
    echo "  1. Few-shot: provide examples"
    echo "  2. Chain-of-thought: step by step"
    echo "  3. Role-play: you are an expert..."
    echo "  4. Constraints: must/must not"
    echo "  5. Format control: respond in JSON/table"
    echo "  6. Temperature hint: be creative vs precise"
    echo "  7. Decomposition: break complex tasks"
}

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

case "${{1:-help}}" in
    create) shift; cmd_create "$@" ;;
    system) shift; cmd_system "$@" ;;
    cot) shift; cmd_cot "$@" ;;
    code) shift; cmd_code "$@" ;;
    write) shift; cmd_write "$@" ;;
    score) shift; cmd_score "$@" ;;
    techniques) shift; cmd_techniques "$@" ;;
    help|-h) show_help ;;
    version|-v) echo "prompt-generator v$VERSION" ;;
    *) echo "Unknown: $1"; show_help; exit 1 ;;
esac
