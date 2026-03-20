# BytesAgain AI Skills

**The largest open-source AI Agent Skill collection** — 461+ plugins for Claude Code, OpenClaw, and all SKILL.md-compatible platforms.

## 🚀 Quick Install (Claude Code)

Add our marketplace to Claude Code with one command:

```
/plugin marketplace add bytesagain/ai-skills
```

Then browse and install any skill:

```
/plugin install chart-generator@bytesagain-skills
/plugin install sql-generator@bytesagain-skills
/plugin install debug@bytesagain-skills
```

## 📦 What's Inside

| Category | Examples | Count |
|----------|---------|-------|
| **Dev Tools** | debug, lint, git, docker, sql-generator | 80+ |
| **Content** | blog-writer, tweet-generator, copywriter | 50+ |
| **Finance** | crypto-tracker, portfolio, bookkeeper | 40+ |
| **Productivity** | task-planner, calendar, note-taker | 40+ |
| **Chinese Tools** | 中文日历, 成语词典, 公务员考试 | 30+ |
| **Data** | chart-generator, csv-analyzer, dashboard | 30+ |
| **Health** | fitness-plan, sleep-tracker, meditation | 20+ |
| **Industrial** | PLC, SCADA, HMI, CNC, CAD, CAM | 60+ |
| **More...** | 150+ additional skills | 150+ |

## 🔧 Also Works With

- **OpenClaw** — `clawhub install <skill-name>`
- **Any SKILL.md platform** — Copy the `SKILL.md` file directly

## 📁 Structure

Each skill follows the Claude Code Plugin format:

```
skill-name/
  .claude-plugin/
    plugin.json          # Plugin manifest
  skills/
    skill-name/
      SKILL.md           # Skill instructions
      scripts/
        script.sh        # Executable script
  SKILL.md               # Also at root (ClawHub/OpenClaw compat)
  scripts/
    script.sh            # Also at root (backward compat)
```

## 🌐 Links

- **Website**: [bytesagain.com](https://bytesagain.com)
- **ClawHub**: [clawhub.ai](https://clawhub.ai) — Search "BytesAgain"
- **Email**: hello@bytesagain.com

## 📄 License

MIT — Use freely, attribution appreciated.

---

*Built by [BytesAgain](https://bytesagain.com) — The AI Agent Skill Hub*
