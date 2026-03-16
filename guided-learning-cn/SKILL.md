---
version: "2.0.0"
name: guided-learning-cn
description: "中文引导式学习助手。学习助手、知识学习、学习计划、学习路线、概念讲解、复习备考、考试复习、费曼学习法、循序渐进学习、学科辅导、自学、教程、课程学习、教材学习、知识点总结、记忆卡片、闪卡、Anki、学习方法、一对一辅导、自测试卷、选择题、简答题。Chinese guided learning assistant with step-by-step concept teaching, quizzes, tests, Feynman technique, and reviews. Use when: (1) learning any topic/skill/subject in Chinese, (2) creating a study plan or learning roadmap, (3) explaining concepts step by step, (4) preparing for exams or reviews, (5) using Feynman technique or analogies to learn, (6) generating flashcards or quiz questions, (7) creating self-assessment tests with multiple choice and short answer, (8) any Chinese-language tutoring or self-study scenario. 适用场景：学习新知识、制定学习计划、概念讲解、复习备考、做练习题、知识总结、用类比解释抽象概念、费曼学习法、自测试卷。 Triggers on: guided learning cn."
author: BytesAgain
---

# 中文引导式学习助手

一次一个概念，理解了再往下走。

## 为什么用这个 Skill？ / Why This Skill?

- **循序渐进**：不会一次灌输太多，每次只教一个概念，确认理解后再推进
- **费曼学习法**：用生活类比解释抽象概念，"像给5岁小孩讲"模式
- **自动检查**：每个概念后自动出检查题，确保真正理解而非死记硬背
- Compared to asking AI directly: structured pedagogy with automatic comprehension checks, analogies, and progressive difficulty — not just dumping information

## 命令

```bash
scripts/learn.sh plan "主题"           # 生成学习计划
scripts/learn.sh concept "概念"        # 讲解单个概念
scripts/learn.sh quiz "主题"           # 生成检查题
scripts/learn.sh review "主题"         # 知识点总结回顾
scripts/learn.sh analogy "概念"        # 用生活类比解释概念
scripts/learn.sh roadmap "领域"        # 学习路线图
scripts/learn.sh flashcard "主题"      # 生成记忆卡片
scripts/learn.sh explain-like-5 "概念" # 用最简单的话解释
scripts/learn.sh test "主题"           # 生成自测试卷（选择+简答）
scripts/learn.sh feynman "概念"        # 费曼学习法四步练习
```

See also: `tips.md` for effective learning methodologies.

## 教学原则

1. 一次只教一个概念
2. 用生活中的类比解释抽象概念
3. 每个概念后配检查题
4. 循序渐进，从易到难
5. 鼓励式反馈，不打击自信
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Commands

Run `guided-learning-cn help` to see all available commands.
