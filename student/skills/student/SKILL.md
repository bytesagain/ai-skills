---
name: student
description: "Help with coursework. Use when taking notes, summarizing readings, formatting citations, outlining essays, or calculating GPA."
version: "3.4.0"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags:
  - study
  - notes
  - citation
  - gpa
  - pomodoro
  - academic
---

# Student — Study & Academic Assistant

Take notes, summarize text, generate citations, outline essays, time study sessions, and track GPA.

## Commands

### note — Record a study note

```bash
bash scripts/script.sh note <subject> "<content>"
```

Appends a timestamped note under the given subject. Notes stored in `~/.student/notes/`.

### summarize — Generate a text summary

```bash
bash scripts/script.sh summarize <file_path> [max_sentences]
```

Reads a text file and outputs a summary by extracting key sentences. Defaults to 5 sentences.

### cite — Format a citation

```bash
bash scripts/script.sh cite <apa|mla> "<author>" "<title>" <year> "[publisher]" "[url]"
```

Generates a formatted citation string in APA or MLA style.

### outline — Create an essay outline

```bash
bash scripts/script.sh outline "<topic>" <num_sections>
```

Produces a structured outline with introduction, N body sections, and conclusion for the given topic.

### timer — Pomodoro study timer

```bash
bash scripts/script.sh timer [work_minutes] [break_minutes]
```

Runs a Pomodoro timer. Defaults to 25 min work / 5 min break. Prints countdown to stdout.

### gpa — Calculate GPA

```bash
bash scripts/script.sh gpa "<course:grade:credits>" ["<course:grade:credits>" ...]
```

Calculates GPA from course entries. Grade format: A/A-/B+/B/B-/C+/C/C-/D+/D/F. Example: `gpa "Math:A:3" "English:B+:4"`

## Output

All commands print plain text to stdout. Notes are stored as text files in `~/.student/notes/<subject>/`.


## Requirements
- bash 4+
- python3 (standard library only)

## Feedback

Report issues or suggestions: [https://bytesagain.com/feedback/](https://bytesagain.com/feedback/)

---

Powered by BytesAgain | bytesagain.com
