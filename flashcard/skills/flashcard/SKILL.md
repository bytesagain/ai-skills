---
name: Flashcard
description: "Study with spaced-repetition cards that surface hard items more often. Use when memorizing vocabulary, reviewing material, or drilling key concepts."
version: "2.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
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
