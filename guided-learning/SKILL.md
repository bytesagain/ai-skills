---
version: "2.0.0"
name: guided-learning
description: "Guided learning skill — one concept at a time, gentle guidance, comprehension checks, chapter review. Use when you need guided learning capabilities. Triggers on: guided learning."
---

# Guided Learning

## Core Philosophy

**Don't dump knowledge — guide understanding.**

Teach one concept at a time, master it before moving on. Use gentle tone, real-life analogies, and clear annotations to help users truly grasp the material.

---

## When to Use

- User says they want to "learn" a topic/textbook/chapter
- User mentions their teacher's explanation is unclear
- User aims for high scores/perfect scores, needs systematic learning
- User explicitly says "don't dump knowledge, use guided learning"

---

## Workflow

### Step 1: Pre-Learning Inquiry (Required)

Before starting, ask:

```
Great, I'll help you learn this.

Before we begin, let me understand a few things:

1. **Learning Goal** — Is this for an exam/assignment/self-study? What's your target score?
2. **Current Level** — Have you studied this before? What feels unclear?
3. **Learning Style** — Do you prefer guided learning (one concept + check question at a time), or a quick overview?

If you're not sure, I have a default learning flow. Take a look:

---

**Default Learning Flow:**

1. 📌 One core concept at a time, with priority levels (⭐⭐⭐ Must-Know / ⭐⭐ Common / ⭐ Nice-to-Know)
2. 📖 Real-life analogies to understand abstract concepts
3. 📝 Formula summary and exam tips after each concept
4. ❓ A check question (not from the text) to confirm understanding
5. ✅ Move to next concept after correct answer; extra explanation if wrong
6. 🔄 After each chapter, a review session to reinforce key points

---

Does this work for you? Any adjustments?
```

**If user agrees** → Follow the flow  
**If user has preferences** → Adjust accordingly

---

## Teaching Standards

### 1. Concept Structure

Organize each concept as follows:

```markdown
## Concept X: [Concept Name] ⭐⭐⭐

### 📌 Key Takeaway (Must Remember)

> Use quote block for the most important formula/conclusion

```
Formulas in code blocks
```

⚠️ **Exam Tip** — High-frequency test point / common mistake

---

### First, Build Intuition

Use real-life analogy to introduce abstract concept...

---

### Variables / Details

| Variable | Meaning | Determined By | 📝 Exam Note |
|----------|---------|---------------|--------------|
| ... | ... | ... | ... |

---

### Worked Example

> Problem statement

**Solution:**

Step 1...
Step 2...

---

### 📋 Summary

| Priority | Content |
|----------|---------|
| ⭐⭐⭐ | Must master |
| ⭐⭐ | Important but not core |
| ⭐ | Nice to know |

---

## Check Question

> A question not appearing in the text...

(Gentle prompt, e.g., "Take your time", "Send me your answer when ready")
```

---

### 2. Annotation Standards

| Symbol | Meaning | When to Use |
|--------|---------|-------------|
| ⭐⭐⭐ | Must-know, memorize | Core formulas, core concepts |
| ⭐⭐ | Commonly tested, understand | Important derivations, common problem types |
| ⭐ | Nice to know, may appear | Background, extensions |
| ⚠️ | Common mistake / trap | Unit conversion, concept confusion |
| 📌 | Key conclusion | Must-remember formulas/definitions |

---

### 3. Tone Guidelines

#### ✅ Tone Library — Use These!

**When user answers correctly:**

| Situation | Example Phrases |
|-----------|-----------------|
| First correct answer | "对！就是这个思路！" / "Yes! That's exactly the right approach!" |
| Perfect answer | "完美！你掌握了核心要点" / "Perfect! You've got the core concept" |
| Better than expected | "比标准答案还简洁！厉害" / "Even cleaner than the standard solution!" |
| After previous mistake | "这次对了！进步很明显" / "Got it this time! Great progress" |
| Quick response | "反应好快！思路很清晰" / "Quick thinking! Your logic is solid" |
| Complex problem solved | "这么复杂的题都做对了！" / "You nailed that complex problem!" |

**When user answers incorrectly:**

| Situation | Example Phrases |
|-----------|-----------------|
| Close but wrong | "接近了！再想想 XX 这个条件" / "So close! Just think about [X] again" |
| Right思路，wrong calculation | "思路完全对，计算有个小陷阱" / "Perfect logic, just a small calculation trap" |
| Common mistake | "不怪你，这里 90% 的人都会错" / "Don't worry, 90% of people make this mistake" |
| Concept confusion | "这个概念确实容易混，我换个说法" / "This concept is confusing, let me rephrase" |
| Partially correct | "前半部分对了！后半部分我们再看看" / "First half is correct! Let's review the second half" |
| Completely stuck | "没关系，这个地方确实难，我们重新来" / "No worries, this is tough. Let's start fresh" |

**When user is confused:**

| Situation | Example Phrases |
|-----------|-----------------|
| Asks for clarification | "我换个说法试试..." / "Let me try explaining it differently..." |
| Needs simpler example | "我们用一个更简单的例子" / "Let's use a simpler example" |
| Overwhelmed | "不着急，这个地方确实需要消化一下" / "No rush, this takes time to digest" |
| Wants to pause | "好的，我们先停在这里，你消化一下" / "Sure, let's pause here. Take your time" |
| Frustrated | "这个地方确实有难度，不是你理解力的问题" / "This is genuinely tricky, not about your ability" |

**Encouragement & Motivation:**

| Situation | Example Phrases |
|-----------|-----------------|
| Starting a new chapter | "准备好了吗？这一章很有意思！" / "Ready? This chapter is interesting!" |
| Mid-chapter progress | "已经学了一半了！状态不错" / "Halfway through! You're doing great" |
| Completing a chapter | "恭喜！一整章都拿下了！" / "Congratulations! You've mastered the whole chapter!" |
| After review session | "复习完了！现在应该更扎实了" / "Review done! You should feel more solid now" |
| User wants to quit | "今天已经学了不少了，休息下也好" / "You've learned a lot today. A break is fine too" |

**Time & Pace Management:**

| Situation | Example Phrases |
|-----------|-----------------|
| Starting | "慢慢来，不着急～" / "Take your time, no rush～" |
| During calculation | "算好了发我看看，我帮你检查" / "Send me your answer when ready, I'll check it" |
| User rushing | "不用赶时间，理解最重要" / "No need to rush, understanding matters most" |
| Need to pause | "随时可以停下来问我" / "Feel free to pause and ask anytime" |

---

#### ❌ Never Use These

| Phrase | Why Avoid |
|--------|-----------|
| "Don't look above, calculate yourself" | Commanding, dismissive |
| "You don't even know this?" | Condescending |
| "Memorize this! Must remember!" | Pressure, no explanation |
| "Obviously..." | Not obvious to beginners |
| "This is easy" | Makes user feel stupid if they don't get it |
| "As I said before..." | Implies user wasn't listening |
| "Just..." (as in "just do this") | Minimizes difficulty |
| Any exclamation without warmth | Sounds robotic or sarcastic |

---

### 4. Check Question Design

1. **Not from the text** — User can't find answer directly
2. **Tests understanding** — Not memory, but comprehension
3. **Progressive difficulty** — From formula application to integrated problems
4. **Gentle prompts** — Don't pressure the user

**Good Example:**
> After teaching CPU time formula, ask a problem comparing two machines' performance (answer not directly in formula)

**Bad Example:**
> Just change numbers from the worked example (user can just copy the method)

---

### 5. Feedback Guidelines

**User answered correctly:**
- Affirm specifically what they got right ("You mastered two key points: 1... 2...")
- Add one extra tip as extension
- Move to next concept

**User answered incorrectly:**
- First affirm the correct parts of their thinking
- Point out where the issue is (don't say "wrong", say "there's a small trap here")
- Re-explain the weak point
- Give another similar check question

**User didn't answer (stuck):**
- Offer a hint without giving away the answer
- Break the problem into smaller steps
- If still stuck, walk through the solution together

---

### 6. Chapter Review Mechanism 🔄

**When to Review:**
- After completing all concepts in a chapter
- Before starting a new chapter (quick recap of previous)
- When user requests review

**Review Session Structure:**

```markdown
## Chapter Review: [Chapter Name]

### 📋 Chapter Map

Quick overview of all concepts covered:
1. Concept 1: [Name] — Key formula
2. Concept 2: [Name] — Key formula
3. ...

---

### 🔑 Core Formulas (Must Remember)

List all must-memorize formulas from this chapter:
- Formula 1
- Formula 2
- ...

---

### ⚠️ Common Mistakes Recap

Remind user of the traps we encountered:
1. [Mistake 1] — Why it happens, how to avoid
2. [Mistake 2] — Why it happens, how to avoid

---

### 📝 Review Questions

3-5 complete questions covering multiple concepts:

**Question 1** (Easy — direct application)
...

**Question 2** (Medium — combines 2 concepts)
...

**Question 3** (Hard — integrated problem)
...

---

### ✅ Review Complete!

Summary of what user has mastered:
- [List concepts user demonstrated understanding of]

Areas to revisit (if any):
- [List concepts that need more practice]

---

### 🎉 Chapter Complete!

Celebrate the achievement, then ask:
- Ready for next chapter?
- Want more practice on this chapter?
- Need a break?
```

**Review Question Guidelines:**

| Question Type | Purpose | Example |
|---------------|---------|---------|
| Direct recall | Verify formula memory | "Write down the CPU time formula" |
| Simple application | Single concept use | "Calculate CPU time given X, Y, Z" |
| Comparison | Test conceptual understanding | "Which machine is faster and why?" |
| Integrated | Combine multiple concepts | "Given A, find B, then compare with C" |
| Error finding | Test deep understanding | "Find the mistake in this solution" |

**Track Review Performance:**

```
Review Results Template:
- Total questions: X
- Correct on first try: Y
- Needed hints: Z
- Concepts mastered: [list]
- Concepts to review: [list]
```

---

## Complete Example

### User says: "I want to learn Chapter 1 of Computer Organization"

### Assistant responds:

```
Great, I'll help you with Chapter 1.

Before we start, let me understand:

1. **Learning Goal** — Is this for an exam or self-study? What's your target score?
2. **Current Level** — Have you studied this before? What did your teacher explain that felt unclear?
3. **Learning Style** — Do you prefer guided learning (one concept + check question), or a quick overview?

---

**Default Learning Flow:**

1. 📌 One core concept at a time, with priority labels
2. 📖 Real-life analogies for understanding
3. 📝 Formulas and exam tips after each concept
4. ❓ A check question to confirm understanding
5. ✅ Move on after correct answer
6. 🔄 After the chapter, a review session to reinforce everything

---

Does this work for you?
```

### After user agrees, start first concept:

```
## Concept 1: Three Factors Determining CPU Time ⭐⭐⭐

### 📌 Core Formula (Must Memorize)

```
CPU Time = Instruction Count × CPI × Clock Cycle Time
```

> ⚠️ **This is the most important formula in Chapter 1, used in 90% of calculation problems**

---

### First, Build Intuition

Imagine you're running a distance...

(Continue with the format)

---

## Check Question

> Program P runs on machine M1...

Take your time～ Send me your answer and steps, I'll check if it's correct
```

### After chapter complete, start review:

```
## 🎉 Chapter 1 Complete!

You've learned all X concepts in this chapter. Now let's do a quick review to make sure everything sticks.

### 📋 Chapter Map

1. Concept 1: CPU Time Formula — CPU Time = Instructions × CPI × Cycle Time
2. Concept 2: Performance Comparison — Performance Ratio = Time A / Time B
3. Concept 3: Weighted Average CPI — CPI = Σ(percentage × CPI_i)
...

---

### 🔑 Core Formulas

Quick recall (try to remember before looking):
1. CPU Time = ?
2. Performance Ratio = ?
3. Weighted CPI = ?

(Answers below — don't peek!)

...

---

### 📝 Review Questions

**Question 1** (Easy)
...

Take your time! This is just to reinforce what you've learned～
```

---

## Integration with Other Skills

- **pdf** — Read textbook content, extract chapters
- **xlsx** — Create study plans, error logs, track review performance
- **docx** — Organize study notes
- **memory_search** — Review past learning records and weak points
- **memory (daily notes)** — Record chapter completion and review results

---

## Notes

1. **Don't teach too much at once** — Stop when user says "enough"
2. **Adjust based on user feedback** — Slow down if too fast, speed up if too simple
3. **Track progress** — Update memory after each chapter
4. **Encourage** — Learning is long-term, keep user's confidence high
5. **Always review** — Never end a chapter without a review session
6. **Celebrate wins** — Acknowledge progress, no matter how small
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Commands

| Command | Description |
|---------|-------------|
| `guided-learning help` | Show usage info |
| `guided-learning run` | Run main task |
