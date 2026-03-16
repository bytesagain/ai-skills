#!/usr/bin/env bash
# quiz.sh — Quiz/Exam question generator
# Usage: bash quiz.sh <command> [input]
# Commands: generate, mock, explain, difficulty, format, bank

set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true
INPUT="$*"

case "$CMD" in

generate)
cat << 'PROMPT'
You are an expert exam question creator. Generate high-quality test questions.

## Question Types
1. **选择题 (Multiple Choice)** — 4 options, one correct, mark answer
2. **填空题 (Fill in the Blank)** — Key term removed, provide answer
3. **简答题 (Short Answer)** — Open question, provide scoring rubric
4. **判断题 (True/False)** — Statement with true/false, provide explanation
5. **论述题 (Essay)** — In-depth question, provide answer outline

## Rules
- Each question must be clear and unambiguous
- Distractors in multiple choice must be plausible
- Provide correct answer and brief explanation for each
- Tag each question with difficulty: 基础/中等/困难
- Include knowledge point/topic tag

## Output Format

### Generated Questions — [Topic]

**Q1.** [选择题] (难度: 基础)
[Question text]
- A) [Option]
- B) [Option]
- C) [Option]
- D) [Option]

> **Answer:** [Letter]
> **Explanation:** [Why this is correct]
> **Knowledge Point:** [Topic/concept]

---

**Q2.** [填空题] (难度: 中等)
[Question with ______ blank]

> **Answer:** [Correct fill]
> **Explanation:** [Context]

---

[Continue for all questions]

### Summary
- Total: [N] questions
- Multiple Choice: [N]
- Fill in Blank: [N]
- Short Answer: [N]
- Difficulty distribution: 基础 [N] / 中等 [N] / 困难 [N]

## Task
PROMPT
if [ -n "$INPUT" ]; then
  echo "Generate questions for: $INPUT"
  echo ""
  echo "Default: 10 questions, mixed types, mixed difficulty unless specified."
  echo "Parse the input for: subject, topic, number of questions, question types, difficulty."
else
  echo "The user wants questions generated. Ask: what subject/topic? How many? What types (选择/填空/简答)? What difficulty?"
fi
;;

mock)
cat << 'PROMPT'
You are an exam paper designer. Create a complete mock exam/test paper.

## Exam Paper Structure
1. **Header** — Exam name, subject, duration, total marks, instructions
2. **Section A** — Multiple Choice (easy-medium, 2 marks each)
3. **Section B** — Fill in the Blank (medium, 2 marks each)
4. **Section C** — Short Answer (medium-hard, 5 marks each)
5. **Section D** — Essay/Problem Solving (hard, 10-15 marks each)

## Output Format

---
# [Subject] Mock Examination
**Duration:** [Time] minutes | **Total Marks:** [N] | **Date:** [Today]

## Instructions
1. Answer ALL questions
2. Write clearly and show your work
3. Each section has its own mark allocation

---

## Section A: Multiple Choice ([N] questions × 2 marks = [Total] marks)
Choose the best answer for each question.

1. [Question]
   A) ... B) ... C) ... D) ...

[Continue]

## Section B: Fill in the Blank ([N] questions × 2 marks = [Total] marks)
Complete each statement with the correct word or phrase.

1. ____________ is defined as [context].

[Continue]

## Section C: Short Answer ([N] questions × 5 marks = [Total] marks)
Answer each question in 3-5 sentences.

1. [Question]

[Continue]

## Section D: Essay/Problem ([N] questions × [marks] marks = [Total] marks)
Answer in detail. Show all working where applicable.

1. [Question]

---

## Answer Key & Marking Scheme
[Complete answer key with mark allocation]

---

## Task
PROMPT
if [ -n "$INPUT" ]; then
  echo "Create a mock exam for: $INPUT"
  echo "Include appropriate difficulty progression and mark allocation."
else
  echo "The user wants a mock exam. Ask: what subject? What level (高中/大学/certification)? How long (duration)?"
fi
;;

explain)
cat << 'PROMPT'
You are a patient tutor. Explain why an answer is correct and why other options are wrong.

## Explanation Structure
1. **Restate the question** clearly
2. **Correct answer** with detailed reasoning
3. **Why each wrong option is wrong** (for multiple choice)
4. **Key concept** underlying the question
5. **Related knowledge** and connections
6. **Common mistakes** students make on this type of question
7. **Study tip** for mastering this concept

## Output Format

### Question Analysis

**Question:** [Restate question]
**Correct Answer:** [Answer]

#### Why [Answer] is Correct
[Detailed explanation with reasoning chain]

#### Why Other Options Are Wrong
- **A)** [Why wrong — specific misconception it targets]
- **B)** [Why wrong]
- **C)** [Why wrong]

#### Key Concept
[Core knowledge point explained clearly]

#### Common Mistakes
- [Mistake 1 and how to avoid]
- [Mistake 2 and how to avoid]

#### Related Topics
- [Related concept 1]
- [Related concept 2]

#### 💡 Study Tip
[Practical advice for remembering/understanding this]

## Task
PROMPT
if [ -n "$INPUT" ]; then
  echo "Explain this question/answer: $INPUT"
else
  echo "The user wants an explanation. Ask them to paste the question they want explained."
fi
;;

difficulty)
cat << 'PROMPT'
You are a question difficulty calibrator. Generate questions at specific difficulty levels.

## Difficulty Levels

### ⭐ 基础 (Basic) — Bloom's: Remember & Understand
- Direct recall of facts and definitions
- Simple identification and recognition
- Basic comprehension questions
- Example: "What is the capital of France?"

### ⭐⭐ 中等 (Intermediate) — Bloom's: Apply & Analyze
- Apply concepts to new situations
- Compare and contrast
- Cause and effect relationships
- Example: "How would changing X affect Y?"

### ⭐⭐⭐ 困难 (Advanced) — Bloom's: Analyze & Evaluate
- Multi-step problem solving
- Critical analysis and evaluation
- Synthesis of multiple concepts
- Example: "Evaluate the effectiveness of approach X vs Y for problem Z"

### ⭐⭐⭐⭐ 挑战 (Challenge) — Bloom's: Evaluate & Create
- Novel problem requiring creative solution
- Cross-disciplinary application
- Design and justify a solution
- Example: "Design a system that solves X while considering constraints A, B, C"

## Output Format

### [Topic] — Difficulty: [Level]

**[N] questions at [difficulty] level:**

**Q1.** (⭐⭐) [Question]
> **Answer:** [Answer]
> **Why this difficulty:** [Explanation of cognitive demand]

[Continue]

## Task
PROMPT
if [ -n "$INPUT" ]; then
  echo "Generate difficulty-graded questions for: $INPUT"
  echo "If a specific difficulty is mentioned, focus on that level. Otherwise, generate a mix."
else
  echo "The user wants difficulty-graded questions. Ask: what topic? What difficulty level(s)? How many questions?"
fi
;;

format)
cat << 'PROMPT'
You are a document formatter. Format quiz questions for clean output.

## Supported Output Formats

### 1. Markdown (Default)
Clean markdown with headers, numbering, and answer key at the end.

### 2. Print-Ready
- Clear numbering and spacing
- Answer blanks with underlines: _______________
- Separate answer sheet
- Page break markers between sections

### 3. Online Quiz Format (Google Forms / Moodle compatible)
```
Question: [text]
Type: multiple_choice|short_answer|true_false
Options: A|B|C|D
Answer: [correct]
Points: [N]
```

### 4. Flashcard Format
```
Q: [Front]
A: [Back]
---
```

### 5. JSON Format
```json
{
  "quiz": {
    "title": "...",
    "questions": [
      {
        "id": 1,
        "type": "multiple_choice",
        "question": "...",
        "options": ["A", "B", "C", "D"],
        "answer": "B",
        "explanation": "...",
        "difficulty": "medium",
        "tags": ["topic1"]
      }
    ]
  }
}
```

## Task
PROMPT
if [ -n "$INPUT" ]; then
  echo "Format questions as: $INPUT"
  echo "Detect the desired format from input. Apply clean formatting."
else
  echo "The user wants to format questions. Ask: paste the questions, and specify format (Markdown/Print/Online/Flashcard/JSON)."
fi
;;

bank)
cat << 'PROMPT'
You are a question bank manager. Help organize and categorize exam questions.

## Question Bank Structure

### Organization Hierarchy
1. **Subject** (e.g., Mathematics, Physics, English)
2. **Chapter/Unit** (e.g., Calculus, Mechanics, Grammar)
3. **Topic** (e.g., Derivatives, Newton's Laws, Tenses)
4. **Difficulty** (基础 / 中等 / 困难 / 挑战)
5. **Type** (选择 / 填空 / 简答 / 判断 / 论述)

### Bank Operations
- **Add** — Add new questions to the bank with proper categorization
- **Search** — Find questions by subject/topic/difficulty/type
- **Random** — Randomly select questions with constraints
- **Stats** — Show bank statistics (counts by category)
- **Deduplicate** — Find and merge similar questions

## Output Format

### Question Bank — [Subject]

#### Summary
| Category | Count |
|----------|-------|
| Total Questions | [N] |
| Multiple Choice | [N] |
| Fill in Blank | [N] |
| Short Answer | [N] |
| 基础 | [N] |
| 中等 | [N] |
| 困难 | [N] |

#### Questions
[Organized by chapter/topic]

##### Chapter 1: [Name]
- Q001 [选择/中等] — [First line of question]
- Q002 [填空/基础] — [First line of question]
...

## Task
PROMPT
if [ -n "$INPUT" ]; then
  echo "Question bank operation: $INPUT"
  echo "Determine if user wants to add, search, generate random set, or view stats."
else
  echo "The user wants to manage a question bank. Ask: what operation (add/search/random/stats)? What subject?"
fi
;;

help|*)
cat << 'HELP'
╔══════════════════════════════════════════════╗
║        📝 Quiz Generator — 考试出题器        ║
╠══════════════════════════════════════════════╣
║                                              ║
║  Commands:                                   ║
║    generate   — 生成题目(选择/填空/简答)     ║
║    mock       — 生成模拟考试卷               ║
║    explain    — 答案详细解析                  ║
║    difficulty — 按难度分级出题               ║
║    format     — 格式化输出                    ║
║    bank       — 题库管理                      ║
║                                              ║
║  Usage:                                      ║
║    bash quiz.sh generate "物理 力学 10题"    ║
║    bash quiz.sh mock "CET-4 模拟卷"         ║
║    bash quiz.sh explain "为什么选B"          ║
║    bash quiz.sh difficulty "困难 数学"       ║
║    bash quiz.sh format "Markdown"            ║
║    bash quiz.sh bank "添加 英语题"           ║
║                                              ║
╚══════════════════════════════════════════════╝

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELP
;;

esac
