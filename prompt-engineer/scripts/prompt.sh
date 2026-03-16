#!/usr/bin/env bash
# Prompt Engineer — Powered by BytesAgain
set -euo pipefail

COMMAND="${1:-help}"
ARG="${2:-}"
BRAND="Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"

case "$COMMAND" in

optimize)
  python3 - "$ARG" << 'PYEOF'
import sys
prompt = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "Write something good"

issues = []
if len(prompt) < 20:
    issues.append("Too short — add more context and detail")
if "you are" not in prompt.lower() and "act as" not in prompt.lower():
    issues.append("No role definition — tell the model who it should be")
if "format" not in prompt.lower() and "json" not in prompt.lower() and "list" not in prompt.lower() and "table" not in prompt.lower():
    issues.append("No output format specified — tell the model what shape the answer should take")
if "example" not in prompt.lower() and "e.g." not in prompt.lower():
    issues.append("No examples — add 1-2 input/output examples for clarity")
if "step" not in prompt.lower() and "first" not in prompt.lower():
    issues.append("No structure cues — guide the model through steps if the task is complex")
if "do not" not in prompt.lower() and "avoid" not in prompt.lower() and "don't" not in prompt.lower():
    issues.append("No negative constraints — tell the model what to avoid")

print("=" * 60)
print("  Prompt Optimization Report")
print("=" * 60)
print("")
print("  Original prompt:")
print("  \"{}\"".format(prompt[:200]))
print("")

if issues:
    print("  Issues found ({})".format(len(issues)))
    for i, issue in enumerate(issues, 1):
        print("    {}. {}".format(i, issue))
    print("")

print("  Optimized version:")
print("  ---")
optimized = prompt
if "you are" not in prompt.lower():
    optimized = "You are an expert assistant. " + optimized
if "format" not in prompt.lower():
    optimized += " Provide your response in a clear, structured format."
if "step" not in prompt.lower():
    optimized += " Think through this step by step."
print("  \"{}\"".format(optimized[:500]))
print("  ---")
print("")
print("  Score: {}/10 -> {}/10".format(max(2, 10 - len(issues)), min(10, max(2, 10 - len(issues)) + len(issues))))
print("=" * 60)
PYEOF
  echo "$BRAND"
  ;;

system)
  python3 - "$ARG" << 'PYEOF'
import sys
role = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "assistant"

templates = {
    "coder": {
        "name": "Senior Software Engineer",
        "prompt": """You are a senior software engineer with 10+ years of experience.

## Core Behaviors
- Write clean, maintainable, well-documented code
- Follow SOLID principles and design patterns
- Consider edge cases, error handling, and security
- Prefer simple solutions over clever ones

## Response Format
- Start with a brief approach summary
- Write code with inline comments for complex logic
- Note any assumptions or trade-offs
- Suggest tests for critical paths

## Constraints
- Do not use deprecated APIs or libraries
- Do not ignore error handling
- Do not write code without explaining the reasoning"""
    },
    "writer": {
        "name": "Professional Content Writer",
        "prompt": """You are a professional content writer and editor.

## Core Behaviors
- Write clear, engaging, well-structured content
- Match tone to the target audience
- Use active voice and concrete language
- Support claims with examples or data

## Response Format
- Start with a hook or key takeaway
- Use headers, bullets, and short paragraphs
- End with a call to action or summary

## Constraints
- Do not use jargon without explanation
- Do not pad content with filler words
- Do not make unsupported claims"""
    },
    "analyst": {
        "name": "Data Analyst",
        "prompt": """You are a senior data analyst with expertise in statistics and business intelligence.

## Core Behaviors
- Ground all analysis in data and evidence
- Distinguish correlation from causation
- Present findings with appropriate uncertainty
- Recommend actionable next steps

## Response Format
- Lead with key findings
- Support with data and methodology
- Include limitations and caveats
- End with recommendations

## Constraints
- Do not overstate statistical significance
- Do not ignore confounding variables
- Do not present opinions as data"""
    }
}

role_lower = role.lower()
template = None
for key, val in templates.items():
    if key in role_lower:
        template = val
        break

if template is None:
    template = {
        "name": role.title(),
        "prompt": """You are a highly skilled {role}.

## Core Behaviors
- Provide accurate, well-reasoned responses
- Tailor communication to the audience
- Acknowledge uncertainty when appropriate
- Focus on actionable, practical advice

## Response Format
- Start with the most important information
- Use structured formatting (headers, lists)
- Include examples where helpful
- Summarize key points at the end

## Constraints
- Do not fabricate information
- Do not ignore context or nuance
- Do not provide advice outside your expertise""".format(role=role)
    }

print("=" * 60)
print("  System Prompt: {}".format(template["name"]))
print("=" * 60)
print("")
print(template["prompt"])
print("")
print("=" * 60)
PYEOF
  echo "$BRAND"
  ;;

chain)
  python3 - "$ARG" << 'PYEOF'
import sys
task = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "analyze and solve a problem"

print("=" * 60)
print("  Prompt Chain Design: {}".format(task[:50]))
print("=" * 60)
print("")
print("  Step 1: UNDERSTAND")
print("  Prompt: \"Analyze the following task and identify the key")
print("           requirements, constraints, and success criteria:")
print("           [{}]\"".format(task[:80]))
print("")
print("  Step 2: PLAN")
print("  Prompt: \"Based on this analysis: [Step 1 output],")
print("           create a detailed action plan with numbered steps.\"")
print("")
print("  Step 3: EXECUTE")
print("  Prompt: \"Follow this plan: [Step 2 output].")
print("           Execute each step and show your work.\"")
print("")
print("  Step 4: REVIEW")
print("  Prompt: \"Review this output: [Step 3 output].")
print("           Check for errors, gaps, and improvements.")
print("           Provide a final polished version.\"")
print("")
print("  Chain type: Sequential (output of N feeds into N+1)")
print("  Estimated calls: 4")
print("  Best for: Complex tasks requiring analysis before action")
print("")
print("=" * 60)
PYEOF
  echo "$BRAND"
  ;;

few-shot)
  python3 - "$ARG" << 'PYEOF'
import sys
task = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "text classification"

examples = {
    "classification": [
        {"input": "This product is amazing, best purchase ever!", "output": "Positive (confidence: 0.95)"},
        {"input": "Terrible quality, broke after one day.", "output": "Negative (confidence: 0.92)"},
        {"input": "It works fine, nothing special.", "output": "Neutral (confidence: 0.78)"}
    ],
    "extraction": [
        {"input": "John Smith, CEO of Acme Corp, announced the merger on March 15.", "output": "Person: John Smith\nTitle: CEO\nOrg: Acme Corp\nDate: March 15"},
        {"input": "Dr. Sarah Lee published her findings in Nature last Tuesday.", "output": "Person: Dr. Sarah Lee\nPublication: Nature\nDate: last Tuesday"},
    ],
    "summarization": [
        {"input": "A 500-word article about climate change impacts...", "output": "Climate change is accelerating, causing rising sea levels, extreme weather, and biodiversity loss. Key actions: reduce emissions, invest in renewables. (1 sentence summary)"},
    ]
}

task_lower = task.lower()
matched_examples = None
matched_type = task_lower
for key, exs in examples.items():
    if key in task_lower:
        matched_examples = exs
        matched_type = key
        break

if matched_examples is None:
    matched_examples = [
        {"input": "Example input for {}".format(task), "output": "Expected output format"},
        {"input": "Another input example", "output": "Another expected output"},
        {"input": "Edge case input", "output": "Edge case handling"}
    ]

print("=" * 60)
print("  Few-Shot Examples: {}".format(matched_type.title()))
print("=" * 60)
print("")
print("  Task: {}".format(task))
print("")

for i, ex in enumerate(matched_examples, 1):
    print("  Example {}:".format(i))
    print("    Input:  {}".format(ex["input"]))
    print("    Output: {}".format(ex["output"]))
    print("")

print("  Usage in prompt:")
print("  \"Here are some examples of the expected behavior:")
for i, ex in enumerate(matched_examples[:2], 1):
    print("   Input: {} -> Output: {}".format(ex["input"][:50], ex["output"][:50]))
print("")
print("   Now process this input: [YOUR INPUT]\"")
print("")
print("=" * 60)
PYEOF
  echo "$BRAND"
  ;;

evaluate)
  python3 - "$ARG" << 'PYEOF'
import sys
prompt = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else ""

if not prompt:
    print("Usage: prompt.sh evaluate <prompt_text>")
    sys.exit(1)

scores = {}

# Clarity
clarity = 5
if len(prompt.split()) > 10:
    clarity += 1
if "?" in prompt or "." in prompt:
    clarity += 1
if any(w in prompt.lower() for w in ["explain", "describe", "analyze", "create", "write", "generate"]):
    clarity += 2
scores["Clarity"] = min(10, clarity)

# Specificity
specificity = 3
if any(c.isdigit() for c in prompt):
    specificity += 2
if any(w in prompt.lower() for w in ["specific", "exactly", "precisely"]):
    specificity += 2
if len(prompt) > 100:
    specificity += 2
scores["Specificity"] = min(10, specificity)

# Constraints
constraints = 3
if any(w in prompt.lower() for w in ["do not", "don't", "avoid", "must", "should not", "never"]):
    constraints += 3
if any(w in prompt.lower() for w in ["limit", "maximum", "minimum", "at most", "at least"]):
    constraints += 2
scores["Constraints"] = min(10, constraints)

# Format
fmt = 3
if any(w in prompt.lower() for w in ["json", "markdown", "table", "list", "bullet", "csv", "format"]):
    fmt += 3
if any(w in prompt.lower() for w in ["header", "section", "paragraph", "structured"]):
    fmt += 2
scores["Formatting"] = min(10, fmt)

# Role
role = 3
if any(w in prompt.lower() for w in ["you are", "act as", "role", "expert", "specialist"]):
    role += 4
scores["Role def."] = min(10, role)

total = sum(scores.values())
avg = total / len(scores)

print("=" * 60)
print("  Prompt Quality Evaluation")
print("=" * 60)
print("")
print("  Prompt: \"{}\"".format(prompt[:150]))
print("")

for dim, score in scores.items():
    bar = "#" * score + "-" * (10 - score)
    print("  {:<14} [{}] {}/10".format(dim, bar, score))

print("")
print("  Overall: {:.1f}/10".format(avg))
if avg >= 8:
    grade = "A - Excellent prompt"
elif avg >= 6:
    grade = "B - Good, minor improvements possible"
elif avg >= 4:
    grade = "C - Needs work, see low-scoring dimensions"
else:
    grade = "D - Significant rewrite recommended"
print("  Grade: {}".format(grade))
print("")
print("=" * 60)
PYEOF
  echo "$BRAND"
  ;;

translate)
  python3 - "$ARG" << 'PYEOF'
import sys
prompt = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "You are a helpful assistant."

print("=" * 60)
print("  Cross-Model Prompt Translation")
print("=" * 60)
print("")
print("  Original: \"{}\"".format(prompt[:200]))
print("")
print("  --- GPT-4 / OpenAI ---")
print("  system: {}".format(prompt))
print("  Notes: GPT-4 responds well to direct instructions.")
print("         Use 'You are...' for role setting.")
print("")
print("  --- Claude / Anthropic ---")
print("  system: {}".format(prompt))
print("  Notes: Claude prefers structured XML-style tags.")
print("         Use <instructions> blocks for complex tasks.")
print("         Add 'Think step by step' for reasoning.")
print("")
print("  --- Gemini / Google ---")
print("  system: {}".format(prompt))
print("  Notes: Gemini handles multimodal well.")
print("         Be explicit about output format.")
print("         Works well with numbered instructions.")
print("")
print("  --- Llama / Meta ---")
print("  system: [INST] <<SYS>>")
print("  {}".format(prompt))
print("  <</SYS>> [/INST]")
print("  Notes: Llama uses special tokens for system prompts.")
print("         Keep instructions concise for smaller models.")
print("")
print("=" * 60)
PYEOF
  echo "$BRAND"
  ;;

template)
  python3 - "$ARG" << 'PYEOF'
import sys
category = sys.argv[1] if len(sys.argv) > 1 else "all"

templates = {
    "code-review": {
        "name": "Code Review",
        "prompt": "Review this code for bugs, performance issues, security vulnerabilities, and style. Provide specific line-by-line feedback. Rate severity as: Critical / Warning / Info.",
    },
    "data-analysis": {
        "name": "Data Analysis",
        "prompt": "Analyze the following dataset. Provide: 1) Summary statistics 2) Key patterns and trends 3) Anomalies or outliers 4) Actionable recommendations. Format as a structured report.",
    },
    "content-writing": {
        "name": "Content Writing",
        "prompt": "Write a [type] about [topic] for [audience]. Tone: [tone]. Length: [word count]. Include: compelling hook, key points with examples, clear conclusion with CTA.",
    },
    "debugging": {
        "name": "Debugging",
        "prompt": "Debug this code. 1) Identify the error 2) Explain root cause 3) Provide the fix with explanation 4) Suggest how to prevent similar issues. Show before/after code.",
    },
    "api-design": {
        "name": "API Design",
        "prompt": "Design a REST API for [resource]. Include: endpoint URLs, HTTP methods, request/response schemas (JSON), error codes, auth requirements, and pagination strategy.",
    },
    "email-draft": {
        "name": "Email Draft",
        "prompt": "Write a professional email. Context: [situation]. Tone: [formal/friendly/urgent]. Goal: [desired outcome]. Keep under 200 words. Include clear subject line.",
    }
}

cat = category.lower()

print("=" * 60)
print("  Prompt Template Library")
print("=" * 60)
print("")

if cat == "all" or cat not in templates:
    for key, tmpl in templates.items():
        print("  [{}]".format(key))
        print("  {}".format(tmpl["name"]))
        print("  {}".format(tmpl["prompt"][:80] + "..."))
        print("")
else:
    tmpl = templates[cat]
    print("  Template: {}".format(tmpl["name"]))
    print("  Category: {}".format(cat))
    print("")
    print("  {}".format(tmpl["prompt"]))
    print("")
    print("  Usage: Copy and fill in the [brackets]")

print("")
print("=" * 60)
PYEOF
  echo "$BRAND"
  ;;

debug)
  python3 - "$ARG" << 'PYEOF'
import sys
prompt = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else ""

if not prompt:
    print("Usage: prompt.sh debug <prompt_text>")
    sys.exit(1)

problems = []
fixes = []

words = prompt.split()
if len(words) < 5:
    problems.append("Extremely short ({} words). LLMs need context.".format(len(words)))
    fixes.append("Expand to at least 20-30 words with context and details.")

vague_words = ["something", "stuff", "things", "good", "nice", "better", "some"]
found_vague = [w for w in vague_words if w in prompt.lower()]
if found_vague:
    problems.append("Vague language detected: {}".format(", ".join(found_vague)))
    fixes.append("Replace vague words with specific, concrete terms.")

if prompt == prompt.lower() and len(words) > 3:
    if "." not in prompt and "?" not in prompt:
        problems.append("No punctuation. Makes intent ambiguous.")
        fixes.append("Add proper punctuation to clarify sentence boundaries.")

if len(set(words)) < len(words) * 0.6:
    problems.append("High word repetition detected. May confuse the model.")
    fixes.append("Rephrase to reduce redundancy.")

if not any(w in prompt.lower() for w in ["what", "how", "why", "create", "write", "explain", "analyze", "generate", "list", "compare", "design"]):
    problems.append("No clear action verb or question word.")
    fixes.append("Start with a clear action: 'Create...', 'Explain...', 'Write...'")

print("=" * 60)
print("  Prompt Debug Report")
print("=" * 60)
print("")
print("  Input: \"{}\"".format(prompt[:200]))
print("")

if problems:
    print("  Problems ({})".format(len(problems)))
    for i, p in enumerate(problems, 1):
        print("    {}. {}".format(i, p))
    print("")
    print("  Suggested fixes:")
    for i, f in enumerate(fixes, 1):
        print("    {}. {}".format(i, f))
else:
    print("  No obvious issues found.")
    print("  Consider running 'evaluate' for a deeper quality check.")

print("")
print("=" * 60)
PYEOF
  echo "$BRAND"
  ;;

help|*)
  cat << 'HELPEOF'
╔══════════════════════════════════════════════════╗
║          🎯 Prompt Engineer                      ║
╠══════════════════════════════════════════════════╣
║  optimize  <prompt>  — Improve a prompt          ║
║  system    <role>    — Generate system prompt    ║
║  chain     <task>    — Design prompt chain       ║
║  few-shot  <task>    — Generate few-shot pairs   ║
║  evaluate  <prompt>  — Score prompt quality      ║
║  translate <prompt>  — Cross-model conversion    ║
║  template  [category]— Prompt template library   ║
║  debug     <prompt>  — Diagnose weak prompts     ║
╚══════════════════════════════════════════════════╝
HELPEOF
  echo "$BRAND"
  ;;

esac
