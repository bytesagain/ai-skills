# Time Tracker — Prompt Tips

## When User Asks for Time Tracking

1. Identify the need: log / analyze / categorize / report / improve / pomodoro
2. Run: `bash scripts/timetrack.sh <command> [options]`
3. Present results in clear format
4. Suggest improvements based on patterns

## Time Categories (Default)

- 💻 **Deep Work** — coding, writing, design, analysis
- 📧 **Communication** — email, chat, calls, meetings
- 📋 **Admin** — planning, organizing, paperwork
- 📚 **Learning** — reading, courses, research
- 🏃 **Health** — exercise, meals, breaks
- 🎮 **Personal** — hobbies, entertainment, social

## Analysis Metrics

- **Productive ratio** — deep work / total work hours
- **Meeting load** — meeting hours / total hours
- **Focus blocks** — uninterrupted periods >90min
- **Context switches** — number of category changes per day
- **Overtime** — hours beyond target work hours

## Pomodoro Technique

- 🍅 25min focus + 5min break = 1 pomodoro
- After 4 pomodoros: 15-30min long break
- Estimate tasks in pomodoros (1-8 per task)
- Track interruptions: internal (✓) vs external (→)
