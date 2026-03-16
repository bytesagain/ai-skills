#!/usr/bin/env bash
# Self Learning — Continuous improvement framework for AI agents
# Powered by BytesAgain

SELF_DIR="$HOME/self-learning"
CMD="${1:-help}"
shift 2>/dev/null

case "$CMD" in
  reflect)
    TOPIC="${1:-general}"
    python3 << PYEOF
import os, datetime

base = os.path.expanduser("~/self-learning")
refl_dir = os.path.join(base, "reflections")
os.makedirs(refl_dir, exist_ok=True)

now = datetime.datetime.now()
date_str = now.strftime("%Y-%m-%d")
topic = "${TOPIC}"

print("=" * 60)
print("  SELF LEARNING — Reflection Guide")
print("=" * 60)
print()
print("  Topic: {}".format(topic))
print("  Date : {}".format(date_str))
print()
print("  Reflection Prompts:")
print("  -------------------")
print("  1. What went well in my recent work?")
print("  2. What could I have done better?")
print("  3. Did I make any assumptions that were wrong?")
print("  4. What surprised me?")
print("  5. What would I do differently next time?")
print("  6. What skill gap did I notice?")
print()

filepath = os.path.join(refl_dir, "{}.md".format(date_str))
with open(filepath, "a") as f:
    f.write("\n## Reflection - {} ({})\n\n".format(date_str, topic))
    f.write("- Well: \n- Better: \n- Assumptions: \n- Surprise: \n- Next time: \n- Gap: \n\n")

print("  Template saved to: {}".format(filepath))
print("  Fill in your answers in the file above.")
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  evaluate)
    SCORE="${1:-}"
    NOTES="${2:-No notes}"
    python3 << PYEOF
import os, datetime

base = os.path.expanduser("~/self-learning")
eval_dir = os.path.join(base, "evaluations")
os.makedirs(eval_dir, exist_ok=True)

now = datetime.datetime.now()
date_str = now.strftime("%Y-%m-%d")
time_str = now.strftime("%H:%M:%S")
score = "${SCORE}"
notes = """${NOTES}"""

print("=" * 60)
print("  SELF LEARNING — Quality Evaluation")
print("=" * 60)
print()

if not score:
    print("  Score your recent output (1-10):")
    print()
    print("   1-3 : Poor - major issues")
    print("   4-5 : Below average - several problems")
    print("   6-7 : Good - minor issues, mostly solid")
    print("   8-9 : Excellent - high quality")
    print("    10 : Outstanding")
    print()
    print("  Usage: self-learning.sh evaluate <score> \"notes\"")
else:
    try:
        s = int(score)
        if s < 1 or s > 10:
            raise ValueError("out of range")
        filepath = os.path.join(eval_dir, "{}.md".format(date_str))
        with open(filepath, "a") as f:
            f.write("### {} {} - Score: {}/10\n\nNotes: {}\n\n".format(date_str, time_str, s, notes))
        labels = {1:"POOR",2:"POOR",3:"POOR",4:"BELOW AVG",5:"BELOW AVG",
                  6:"GOOD",7:"GOOD",8:"EXCELLENT",9:"EXCELLENT",10:"OUTSTANDING"}
        bar = "#" * s + "." * (10 - s)
        print("  Score : {}/10 [{}] {}".format(s, bar, labels[s]))
        print("  Notes : {}".format(notes[:60]))
        print("  Saved : {}".format(filepath))
    except ValueError:
        print("  Error: Score must be a number 1-10")

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  goals)
    GOAL="${1:-}"
    DEADLINE="${2:-none}"
    python3 << PYEOF
import os, datetime

base = os.path.expanduser("~/self-learning")
os.makedirs(base, exist_ok=True)
goals_file = os.path.join(base, "goals.md")
goal = """${GOAL}"""
deadline = "${DEADLINE}"

print("=" * 60)
print("  SELF LEARNING — Goals")
print("=" * 60)
print()

if not goal:
    if os.path.exists(goals_file):
        with open(goals_file) as f:
            print(f.read())
    else:
        print("  No goals set yet.")
        print("  Usage: self-learning.sh goals \"description\" \"deadline\"")
else:
    now = datetime.datetime.now()
    if not os.path.exists(goals_file):
        with open(goals_file, "w") as f:
            f.write("# Self Learning Goals\n\n")
    with open(goals_file, "a") as f:
        f.write("- [ ] {} (set: {}, deadline: {})\n".format(
            goal, now.strftime("%Y-%m-%d"), deadline))
    print("  Goal added: {}".format(goal[:60]))
    print("  Deadline  : {}".format(deadline))
    print("  Saved to  : {}".format(goals_file))

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  track)
    python3 << 'PYEOF'
import os

base = os.path.expanduser("~/self-learning")
goals_file = os.path.join(base, "goals.md")

print("=" * 60)
print("  SELF LEARNING — Goal Progress")
print("=" * 60)
print()

if not os.path.exists(goals_file):
    print("  No goals found. Set some with 'goals' command.")
else:
    with open(goals_file) as f:
        lines = f.readlines()
    total = 0
    done = 0
    for line in lines:
        ls = line.strip()
        if ls.startswith("- ["):
            total += 1
            if "[x]" in ls.lower():
                done += 1
                print("  DONE  {}".format(ls[6:]))
            else:
                print("  TODO  {}".format(ls[6:]))
    print()
    if total > 0:
        pct = done * 100 // total
        bar = "#" * (pct // 5) + "." * (20 - pct // 5)
        print("  Progress: {}/{} [{}] {}%".format(done, total, bar, pct))
    else:
        print("  No goals found in file.")

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  journal)
    ENTRY="${1:-}"
    python3 << PYEOF
import os, datetime

base = os.path.expanduser("~/self-learning")
journal_dir = os.path.join(base, "journal")
os.makedirs(journal_dir, exist_ok=True)

now = datetime.datetime.now()
date_str = now.strftime("%Y-%m-%d")
time_str = now.strftime("%H:%M:%S")
entry = """${ENTRY}"""

filepath = os.path.join(journal_dir, "{}.md".format(date_str))

print("=" * 60)
print("  SELF LEARNING — Daily Journal")
print("=" * 60)
print()

if not entry:
    if os.path.exists(filepath):
        with open(filepath) as f:
            print(f.read())
    else:
        print("  No journal entry for today yet.")
        print("  Usage: self-learning.sh journal \"what I learned today\"")
else:
    header_needed = not os.path.exists(filepath)
    with open(filepath, "a") as f:
        if header_needed:
            f.write("# Journal - {}\n\n".format(date_str))
        f.write("### {}\n\n{}\n\n".format(time_str, entry))
    print("  Entry added at {}".format(time_str))
    print("  Content: {}".format(entry[:60]))
    print("  File   : {}".format(filepath))

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  insights)
    python3 << 'PYEOF'
import os, collections

base = os.path.expanduser("~/self-learning")
journal_dir = os.path.join(base, "journal")

print("=" * 60)
print("  SELF LEARNING — Journal Insights")
print("=" * 60)
print()

if not os.path.exists(journal_dir):
    print("  No journal entries found. Start with 'journal' command.")
else:
    words = collections.Counter()
    entry_count = 0
    day_count = 0
    for fname in sorted(os.listdir(journal_dir)):
        if not fname.endswith(".md"):
            continue
        day_count += 1
        with open(os.path.join(journal_dir, fname)) as f:
            content = f.read()
        entry_count += content.count("### ")
        for line in content.split("\n"):
            if line.startswith("#"):
                continue
            for word in line.lower().split():
                w = word.strip(".,!?:;\"'()-")
                if len(w) > 4:
                    words[w] += 1

    print("  Journal span   : {} day(s)".format(day_count))
    print("  Total entries  : {}".format(entry_count))
    print()
    if words:
        print("  Top themes (by frequency):")
        print()
        for word, count in words.most_common(12):
            bar = "#" * min(count, 20)
            print("    {:18s} {:3d} {}".format(word, count, bar))
    else:
        print("  Not enough data for insights yet.")

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  habits)
    python3 << 'PYEOF'
import os, datetime

base = os.path.expanduser("~/self-learning")
os.makedirs(base, exist_ok=True)
habits_file = os.path.join(base, "habits.md")

print("=" * 60)
print("  SELF LEARNING — Good Habits Checklist")
print("=" * 60)
print()

if not os.path.exists(habits_file):
    habits = [
        "Validate assumptions before acting",
        "Ask clarifying questions when unsure",
        "Double-check outputs before delivering",
        "Log mistakes immediately",
        "Reflect at end of each major task",
        "Update documentation after changes",
        "Test edge cases explicitly",
        "Summarize before responding to complex queries",
    ]
    with open(habits_file, "w") as f:
        f.write("# Good Agent Habits\n\n")
        for h in habits:
            f.write("- [ ] {}\n".format(h))
    print("  Created default habits checklist.")
    print()

with open(habits_file) as f:
    content = f.read()

total = content.count("- [")
checked = content.count("- [x]") + content.count("- [X]")
print(content)
print()
if total > 0:
    pct = checked * 100 // total
    print("  Streak: {}/{} habits active ({}%)".format(checked, total, pct))
print()
print("  Edit {} to check off habits.".format(habits_file))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  benchmark)
    python3 << 'PYEOF'
import os, collections

base = os.path.expanduser("~/self-learning")
eval_dir = os.path.join(base, "evaluations")

print("=" * 60)
print("  SELF LEARNING — Performance Benchmark")
print("=" * 60)
print()

if not os.path.exists(eval_dir):
    print("  No evaluations found. Use 'evaluate' to score outputs first.")
else:
    scores_by_date = collections.OrderedDict()
    for fname in sorted(os.listdir(eval_dir)):
        if not fname.endswith(".md"):
            continue
        date = fname.replace(".md", "")
        with open(os.path.join(eval_dir, fname)) as f:
            content = f.read()
        day_scores = []
        for line in content.split("\n"):
            if "Score:" in line:
                try:
                    s = int(line.split("Score:")[1].split("/")[0].strip())
                    day_scores.append(s)
                except (ValueError, IndexError):
                    pass
        if day_scores:
            scores_by_date[date] = sum(day_scores) / len(day_scores)

    if scores_by_date:
        print("  Daily Average Scores:")
        print()
        for date, avg in scores_by_date.items():
            bar = "#" * int(avg) + "." * (10 - int(avg))
            print("  {} [{:10s}] {:.1f}/10".format(date, bar, avg))

        all_scores = list(scores_by_date.values())
        overall = sum(all_scores) / len(all_scores)
        print()
        print("  Overall average : {:.1f}/10".format(overall))
        print("  Days tracked    : {}".format(len(all_scores)))
        if len(all_scores) > 1:
            trend = all_scores[-1] - all_scores[0]
            arrow = "UP" if trend > 0 else ("DOWN" if trend < 0 else "FLAT")
            print("  Trend           : {} ({:+.1f})".format(arrow, trend))
    else:
        print("  No scores found in evaluation files.")

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  *)
    echo "=================================================="
    echo "  SELF LEARNING — AI Improvement Framework"
    echo "=================================================="
    echo ""
    echo "  Commands:"
    echo "    reflect    Self-reflection on recent work"
    echo "    evaluate   Score output quality (1-10)"
    echo "    goals      Set improvement goals"
    echo "    track      Track goal progress"
    echo "    journal    Daily learning journal"
    echo "    insights   Extract journal insights"
    echo "    habits     Good habits checklist"
    echo "    benchmark  Compare performance over time"
    echo ""
    echo "  Usage:"
    echo "    bash self-learning.sh <command> [args]"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;
esac
