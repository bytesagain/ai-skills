#!/usr/bin/env bash
# mindmap skill - ASCII mind map generator from text outlines
# Usage: bash script.sh <create|view|export> [input]
set -euo pipefail

COMMAND="${1:-}"
ARG="${2:-}"

BOLD='\033[1m'
CYAN='\033[0;36m'
RED='\033[0;31m'
RESET='\033[0m'

usage() {
  cat <<EOF
${BOLD}mindmap skill${RESET} — ASCII mind map generator

Commands:
  create "<text>"    Render mind map from inline text (use \\n for newlines)
  view <file>        Render mind map from a text file (use - for stdin)
  export <file>      Output as a Markdown fenced code block

Input format (indented outline):
  Root
    Branch A
      Leaf 1
      Leaf 2
    Branch B

Examples:
  bash script.sh create "Root\\n  A\\n    A1\\n  B"
  bash script.sh view outline.txt
  cat outline.txt | bash script.sh view -
  bash script.sh export outline.txt > mindmap.md
EOF
  exit 0
}

# Core Python renderer
render_mindmap() {
  local mode="$1"   # ascii | markdown
  local text="$2"

  python3 -u - "$mode" "$text" <<'PYEOF'
import sys
import re

mode = sys.argv[1]
raw  = sys.argv[2]

# ── Parse indented outline ───────────────────────────────────────────────────

def parse_outline(text):
    """Parse indented text into a tree: list of (level, label) tuples."""
    lines = text.splitlines()
    nodes = []
    for line in lines:
        if not line.strip():
            continue
        stripped = line.lstrip()
        indent = len(line) - len(stripped)
        # Normalize: treat every 2 spaces or 1 tab as one level
        if '\t' in line:
            level = len(line) - len(line.lstrip('\t'))
        else:
            level = indent // 2 if indent >= 2 else (1 if indent > 0 else 0)
        # Remove leading list markers (-, *, •)
        label = re.sub(r'^[-*•]\s*', '', stripped)
        nodes.append((level, label))
    return nodes

def build_tree(nodes):
    """Convert flat (level, label) list to nested dicts."""
    if not nodes:
        return None
    root_level, root_label = nodes[0]
    root = {"label": root_label, "children": []}
    stack = [(root_level, root)]

    for level, label in nodes[1:]:
        node = {"label": label, "children": []}
        # Pop until we find the right parent
        while len(stack) > 1 and stack[-1][0] >= level:
            stack.pop()
        stack[-1][1]["children"].append(node)
        stack.append((level, node))

    return root

# ── ASCII rendering ──────────────────────────────────────────────────────────

PIPE  = "│"
TEE   = "├── "
LAST  = "└── "
BLANK = "    "
CONT  = "│   "

def render_tree(node, prefix="", is_last=True, is_root=True):
    lines = []
    if is_root:
        lines.append(node["label"])
    else:
        connector = LAST if is_last else TEE
        lines.append(prefix + connector + node["label"])

    children = node.get("children", [])
    for i, child in enumerate(children):
        last = (i == len(children) - 1)
        if is_root:
            child_prefix = ""
        else:
            child_prefix = prefix + (BLANK if is_last else CONT)
        lines.extend(render_tree(child, child_prefix, last, is_root=False))
    return lines

# ── Main ─────────────────────────────────────────────────────────────────────

nodes = parse_outline(raw)
if not nodes:
    print("Error: empty input. Provide an indented outline.")
    sys.exit(1)

tree = build_tree(nodes)
rendered = render_tree(tree)

if mode == "markdown":
    print("```mindmap")
    for line in rendered:
        print(line)
    print("```")
else:
    for line in rendered:
        print(line)
PYEOF
}

get_input() {
  local arg="${1:-}"
  if [[ "$arg" == "-" || -z "$arg" ]]; then
    cat
  elif [[ -f "$arg" ]]; then
    cat "$arg"
  else
    # Treat as raw text (unescape \n)
    printf '%b' "$arg"
  fi
}

case "$COMMAND" in
  create)
    if [[ -z "$ARG" ]]; then
      echo -e "${RED}Error: provide text as argument${RESET}"
      echo 'Usage: bash script.sh create "Root\n  A\n  B"'
      exit 1
    fi
    TEXT="$(printf '%b' "$ARG")"
    render_mindmap "ascii" "$TEXT"
    ;;
  view)
    if [[ -z "$ARG" ]]; then
      TEXT="$(cat)"
    elif [[ "$ARG" == "-" ]]; then
      TEXT="$(cat)"
    elif [[ -f "$ARG" ]]; then
      TEXT="$(cat "$ARG")"
    else
      echo -e "${RED}File not found: $ARG${RESET}"
      exit 1
    fi
    render_mindmap "ascii" "$TEXT"
    ;;
  export)
    if [[ -z "$ARG" ]]; then
      TEXT="$(cat)"
    elif [[ "$ARG" == "-" ]]; then
      TEXT="$(cat)"
    elif [[ -f "$ARG" ]]; then
      TEXT="$(cat "$ARG")"
    else
      # treat as inline text
      TEXT="$(printf '%b' "$ARG")"
    fi
    render_mindmap "markdown" "$TEXT"
    ;;
  help|--help|-h|"")
    usage
    ;;
  *)
    echo -e "${RED}Unknown command: $COMMAND${RESET}"
    echo "Run: bash script.sh help"
    exit 1
    ;;
esac
