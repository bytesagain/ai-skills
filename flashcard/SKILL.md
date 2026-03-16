---
name: Flashcard
description: "Spaced repetition study tool with deck management. Create flashcard decks, add question-answer pairs, study with prioritized review (weakest cards first), track correct and wrong answers, view mastery progress, and manage multiple subject decks. Learn anything more efficiently."
version: "2.0.0"
author: "BytesAgain"
tags: ["flashcard","study","learning","spaced-repetition","education","memory","quiz","anki"]
categories: ["Education", "Productivity", "Personal Management"]
---

# Flashcard

Study smarter with spaced repetition. Cards you struggle with come up more often.

## Commands

- `create <deck>` — Create a new flashcard deck
- `add <deck> <front> <back>` — Add a card to a deck
- `study <deck>` — Study weakest cards first
- `correct <deck>` — Mark current card as correct
- `wrong <deck>` — Mark current card as wrong (will repeat sooner)
- `decks` — List all decks with card counts
- `stats` — Overall study statistics
- `help` — Show commands

## Usage Examples

```bash
flashcard create Spanish
flashcard add Spanish "hola" "hello"
flashcard add Spanish "gracias" "thank you"
flashcard study Spanish
flashcard correct Spanish
flashcard decks
flashcard stats
```

---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
