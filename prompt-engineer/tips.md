# Prompt Engineer Tips

1. **Lead with role** — Start with "You are a senior backend engineer" and watch output quality jump
2. **Specific beats vague** — "Write an 800-word product review" is miles ahead of "write something"
3. **Specify output format** — Tell the LLM you want JSON, a Markdown table, or bullet points. Cuts rework
4. **Few-shot is magic** — 2-3 input/output examples outperform paragraphs of instructions
5. **Chain of Thought** — Add "think step by step" for complex tasks. Reasoning accuracy improves 30%+
6. **Negative constraints work** — "Do NOT include X" is sometimes more effective than positive instructions
7. **Test across models** — Same prompt performs differently on GPT vs Claude vs Gemini. Use `translate` to adapt
8. **Iterate with evaluate** — Run `evaluate` → `optimize` → `evaluate` in a loop until all dimensions hit 80%+
