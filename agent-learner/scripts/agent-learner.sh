#!/usr/bin/env bash
# Agent Learner — AI self-learning from mistakes and corrections
# Powered by BytesAgain

LEARN_DIR="$HOME/agent-learner"
CMD="${1:-help}"
shift 2>/dev/null

case "$CMD" in
  mistake)
    WHAT="${1:-}"
    WHY="${2:-}"
    if [ -z "$WHAT" ]; then
      echo "Usage: agent-learner.sh mistake \"what went wrong\" \"why it happened\""
      echo ""
      echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
      exit 1
    fi
    python3 << PYEOF
import os, datetime

base = os.path.expanduser("~/agent-learner")
mistakes_dir = os.path.join(base, "mistakes")
os.makedirs(mistakes_dir, exist_ok=True)

now = datetime.datetime.now()
date_str = now.strftime("%Y-%m-%d")
time_str = now.strftime("%H:%M:%S")
what = """${WHAT}"""
why = """${WHY}""" if """${WHY}""" else "Not specified"

filepath = os.path.join(mistakes_dir, "{}.md".format(date_str))
entry = "\n### {} {}\n\n- **What:** {}\n- **Why:** {}\n- **Status:** Unresolved\n".format(
    date_str, time_str, what, why)

with open(filepath, "a") as f:
    f.write(entry)

count = 0
for fname in os.listdir(mistakes_dir):
    if fname.endswith(".md"):
        with open(os.path.join(mistakes_dir, fname), "r") as f:
            count += f.read().count("### ")

print("=" * 60)
print("  AGENT LEARNER — Mistake Logged")
print("=" * 60)
print()
print("  What : {}".format(what[:70]))
print("  Why  : {}".format(why[:70]))
print("  Time : {} {}".format(date_str, time_str))
print("  File : {}".format(filepath))
print("  Total mistakes logged: {}".format(count))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  correction)
    ORIGINAL="${1:-}"
    CORRECTED="${2:-}"
    if [ -z "$ORIGINAL" ] || [ -z "$CORRECTED" ]; then
      echo "Usage: agent-learner.sh correction \"original output\" \"corrected version\""
      echo ""
      echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
      exit 1
    fi
    python3 << PYEOF
import os, datetime

base = os.path.expanduser("~/agent-learner")
corr_dir = os.path.join(base, "corrections")
os.makedirs(corr_dir, exist_ok=True)

now = datetime.datetime.now()
date_str = now.strftime("%Y-%m-%d")
time_str = now.strftime("%H:%M:%S")
original = """${ORIGINAL}"""
corrected = """${CORRECTED}"""

filepath = os.path.join(corr_dir, "{}.md".format(date_str))
entry = "\n### Correction {} {}\n\n- **Original:** {}\n- **Corrected:** {}\n- **Lesson:** Pending analysis\n".format(
    date_str, time_str, original, corrected)

with open(filepath, "a") as f:
    f.write(entry)

print("=" * 60)
print("  AGENT LEARNER — Correction Logged")
print("=" * 60)
print()
print("  Original  : {}".format(original[:60]))
print("  Corrected : {}".format(corrected[:60]))
print("  Saved to  : {}".format(filepath))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  pattern)
    python3 << 'PYEOF'
import os, collections

base = os.path.expanduser("~/agent-learner")
mistakes_dir = os.path.join(base, "mistakes")

print("=" * 60)
print("  AGENT LEARNER — Pattern Analysis")
print("=" * 60)
print()

if not os.path.exists(mistakes_dir):
    print("  No mistakes logged yet. Run 'mistake' first.")
else:
    words = collections.Counter()
    total = 0
    for fname in os.listdir(mistakes_dir):
        if not fname.endswith(".md"):
            continue
        with open(os.path.join(mistakes_dir, fname), "r") as f:
            content = f.read()
        total += content.count("### ")
        for line in content.split("\n"):
            if line.startswith("- **What:**"):
                text = line.replace("- **What:**", "").strip().lower()
                for word in text.split():
                    if len(word) > 3:
                        words[word] += 1

    print("  Total mistakes analyzed: {}".format(total))
    print()
    if words:
        print("  Top recurring keywords:")
        print()
        for word, count in words.most_common(10):
            bar = "#" * min(count, 20)
            print("    {:20s} {:3d} {}".format(word, count, bar))
    else:
        print("  Not enough data for pattern analysis.")

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  improve)
    python3 << 'PYEOF'
import os

base = os.path.expanduser("~/agent-learner")

print("=" * 60)
print("  AGENT LEARNER — Improvement Plan")
print("=" * 60)
print()

mistakes_count = 0
corrections_count = 0

m_dir = os.path.join(base, "mistakes")
c_dir = os.path.join(base, "corrections")

if os.path.exists(m_dir):
    for f in os.listdir(m_dir):
        if f.endswith(".md"):
            with open(os.path.join(m_dir, f)) as fh:
                mistakes_count += fh.read().count("### ")

if os.path.exists(c_dir):
    for f in os.listdir(c_dir):
        if f.endswith(".md"):
            with open(os.path.join(c_dir, f)) as fh:
                corrections_count += fh.read().count("### ")

print("  Based on {} mistakes and {} corrections:".format(mistakes_count, corrections_count))
print()
print("  Improvement Plan:")
print("  -" * 30)
print()
if mistakes_count == 0:
    print("  1. Start logging mistakes to build a baseline")
    print("  2. Ask for corrections to calibrate outputs")
    print("  3. Run pattern analysis after 10+ entries")
else:
    print("  1. Review the {} logged mistakes for common themes".format(mistakes_count))
    print("  2. Create checklists for recurring error categories")
    print("  3. Add pre-output validation for top error types")
    print("  4. Set up periodic self-quiz sessions")
    print("  5. Track improvement with weekly reports")
    if corrections_count > 0:
        ratio = corrections_count / max(mistakes_count, 1) * 100
        print("  6. Correction coverage: {:.0f}% — aim for 80%+".format(ratio))

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  quiz)
    python3 << 'PYEOF'
import os, random

base = os.path.expanduser("~/agent-learner")
mistakes_dir = os.path.join(base, "mistakes")

print("=" * 60)
print("  AGENT LEARNER — Self Quiz")
print("=" * 60)
print()

mistakes = []
if os.path.exists(mistakes_dir):
    for fname in os.listdir(mistakes_dir):
        if not fname.endswith(".md"):
            continue
        with open(os.path.join(mistakes_dir, fname), "r") as f:
            content = f.read()
        entries = content.split("### ")
        for entry in entries:
            if "**What:**" in entry:
                lines = entry.strip().split("\n")
                what = ""
                why = ""
                for line in lines:
                    if "**What:**" in line:
                        what = line.split("**What:**")[-1].strip()
                    if "**Why:**" in line:
                        why = line.split("**Why:**")[-1].strip()
                if what:
                    mistakes.append((what, why))

if not mistakes:
    print("  No mistakes logged yet. Log some mistakes first!")
else:
    sample = random.sample(mistakes, min(3, len(mistakes)))
    print("  Quick Quiz — {} question(s):\n".format(len(sample)))
    for i, (what, why) in enumerate(sample, 1):
        print("  Q{}: What would you do differently?".format(i))
        print("      Mistake: {}".format(what[:70]))
        print("      Root cause: {}".format(why[:70]))
        print()

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  report)
    python3 << 'PYEOF'
import os, datetime

base = os.path.expanduser("~/agent-learner")

print("=" * 60)
print("  AGENT LEARNER — Progress Report")
print("=" * 60)
print()

for subdir, label in [("mistakes", "Mistakes"), ("corrections", "Corrections")]:
    d = os.path.join(base, subdir)
    if not os.path.exists(d):
        print("  {} : 0 entries".format(label))
        continue
    total = 0
    dates = set()
    for fname in os.listdir(d):
        if fname.endswith(".md"):
            dates.add(fname.replace(".md", ""))
            with open(os.path.join(d, fname)) as f:
                total += f.read().count("### ")
    print("  {:12s}: {} entries across {} day(s)".format(label, total, len(dates)))

bp_file = os.path.join(base, "best-practices.md")
if os.path.exists(bp_file):
    with open(bp_file) as f:
        bp_count = f.read().count("- ")
    print("  Best Practices: {} items documented".format(bp_count))

print()
print("  Report generated: {}".format(datetime.datetime.now().strftime("%Y-%m-%d %H:%M")))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  reset)
    python3 << 'PYEOF'
import os, shutil, datetime

base = os.path.expanduser("~/agent-learner")

print("=" * 60)
print("  AGENT LEARNER — Reset")
print("=" * 60)
print()

if os.path.exists(base):
    archive = base + "_backup_" + datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    shutil.copytree(base, archive)
    print("  Backup created: {}".format(archive))
    for subdir in ["mistakes", "corrections"]:
        d = os.path.join(base, subdir)
        if os.path.exists(d):
            shutil.rmtree(d)
            os.makedirs(d)
    print("  Mistakes and corrections cleared.")
    print("  Best practices preserved (if any).")
else:
    print("  Nothing to reset — no learner data found.")

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  best-practices)
    python3 << 'PYEOF'
import os

base = os.path.expanduser("~/agent-learner")
bp_file = os.path.join(base, "best-practices.md")

print("=" * 60)
print("  AGENT LEARNER — Best Practices")
print("=" * 60)
print()

if os.path.exists(bp_file):
    with open(bp_file, "r") as f:
        content = f.read()
    print(content)
else:
    print("  No best practices documented yet.")
    print()
    print("  To build best practices, start by:")
    print("  1. Logging mistakes with 'mistake' command")
    print("  2. Recording corrections with 'correction' command")
    print("  3. Running 'pattern' to identify themes")
    print("  4. Creating ~/agent-learner/best-practices.md")
    os.makedirs(base, exist_ok=True)
    with open(bp_file, "w") as f:
        f.write("# Learned Best Practices\n\n")
        f.write("_Add practices as you learn from mistakes._\n\n")
        f.write("- Always validate inputs before processing\n")
        f.write("- Double-check assumptions against source data\n")
        f.write("- Ask clarifying questions when requirements are ambiguous\n")
    print()
    print("  Created starter file: {}".format(bp_file))

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  *)
    echo "=================================================="
    echo "  AGENT LEARNER — AI Self-Learning System"
    echo "=================================================="
    echo ""
    echo "  Commands:"
    echo "    mistake        Log a mistake"
    echo "    correction     Log a user correction"
    echo "    pattern        Identify recurring issues"
    echo "    improve        Generate improvement plan"
    echo "    quiz           Self-test on past mistakes"
    echo "    report         Learning progress report"
    echo "    reset          Start fresh (with backup)"
    echo "    best-practices Output learned best practices"
    echo ""
    echo "  Usage:"
    echo "    bash agent-learner.sh <command> [args]"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;
esac
