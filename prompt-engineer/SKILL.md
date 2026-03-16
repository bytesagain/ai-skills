---
version: "2.0.0"
name: prompt-engineer
description: "Prompt engineering expert. Optimize prompts, generate system prompts, design prompt chains, create few-shot examples, evaluate quality, translate across models, access template library, debug inefficient prompts. Commands: optimize, system, chain, few-shot, evaluate, translate, template, debug. Use for prompt optimization, LLM tuning, AI prompt design. Use when you need prompt engineer capabilities. Triggers on: prompt engineer."
---

# 🎯 Prompt Engineer

Master the art of talking to LLMs. Make every token count.

## Quick Start

```bash
bash scripts/prompt.sh <command> [args...]
```

## Commands

**Optimization**
- `optimize <prompt>` — Analyze and improve a prompt, output enhanced version with change notes
- `debug <prompt>` — Diagnose weak prompts, find vague instructions and redundancy

**Generation**
- `system <role>` — Generate high-quality system prompts
- `chain <task>` — Design multi-step prompt chains (Chain of Thought)
- `few-shot <task>` — Generate few-shot example pairs
- `template <category>` — Pull from the prompt template library

**Evaluation**
- `evaluate <prompt>` — Multi-dimensional quality score (clarity / specificity / constraints / format)
- `translate <prompt>` — Cross-model conversion (GPT ↔ Claude ↔ Gemini ↔ Llama)

## Quality Dimensions

```
Clarity     ████████░░ 80%   Is the intent unambiguous?
Specificity ██████░░░░ 60%   Are details concrete enough?
Constraints ███████░░░ 70%   Are boundaries well-defined?
Formatting  █████░░░░░ 50%   Is output format specified?
```

## Core Principles

1. Define the role → 2. State the task → 3. Set constraints → 4. Specify format → 5. Give examples
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
