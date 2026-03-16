#!/usr/bin/env bash
# Task Planner — AI task decomposition and planning
# Powered by BytesAgain

PLAN_DIR="$HOME/task-planner"
CMD="${1:-help}"
shift 2>/dev/null

case "$CMD" in
  plan)
    TASK="${1:-}"
    if [ -z "$TASK" ]; then
      echo "Usage: task-planner.sh plan \"task description\""
      echo ""
      echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
      exit 1
    fi
    python3 << PYEOF
import os, datetime, hashlib

base = os.path.expanduser("~/task-planner")
plans_dir = os.path.join(base, "plans")
os.makedirs(plans_dir, exist_ok=True)

task = """${TASK}"""
now = datetime.datetime.now()
task_id = hashlib.md5(task.encode()).hexdigest()[:8]
filepath = os.path.join(plans_dir, "plan_{}.md".format(task_id))

print("=" * 60)
print("  TASK PLANNER — Decomposition")
print("=" * 60)
print()
print("  Task: {}".format(task[:70]))
print("  ID  : {}".format(task_id))
print()
print("  Suggested subtask breakdown:")
print()

words = task.lower().split()
subtasks = [
    "1. Define requirements and acceptance criteria",
    "2. Research existing solutions and patterns",
    "3. Design approach and architecture",
    "4. Implement core functionality",
    "5. Add error handling and edge cases",
    "6. Write tests and validation",
    "7. Document the solution",
    "8. Review and iterate",
]

with open(filepath, "w") as f:
    f.write("# Plan: {}\n\n".format(task))
    f.write("ID: {} | Created: {}\n\n".format(task_id, now.strftime("%Y-%m-%d %H:%M")))
    f.write("## Subtasks\n\n")
    for st in subtasks:
        f.write("- [ ] {}\n".format(st))
        print("  - [ ] {}".format(st))
    f.write("\n## Notes\n\n")

print()
print("  Plan saved: {}".format(filepath))
print("  Edit the file to customize subtasks.")
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  estimate)
    TASK="${1:-}"
    python3 << PYEOF
import os

task = """${TASK}"""

print("=" * 60)
print("  TASK PLANNER — Estimation")
print("=" * 60)
print()

if not task:
    print("  Usage: task-planner.sh estimate \"task description\"")
else:
    words = len(task.split())
    # Heuristic complexity scoring
    complex_kw = ["integrate", "migrate", "refactor", "distributed", "security", "scale", "database", "api"]
    simple_kw = ["fix", "update", "add", "change", "rename", "move", "delete"]

    score = 5  # baseline
    for kw in complex_kw:
        if kw in task.lower():
            score += 2
    for kw in simple_kw:
        if kw in task.lower():
            score -= 1
    score = max(1, min(10, score))

    if score <= 3:
        time_est = "30 min - 2 hours"
        level = "LOW"
    elif score <= 6:
        time_est = "2 - 8 hours"
        level = "MEDIUM"
    elif score <= 8:
        time_est = "1 - 3 days"
        level = "HIGH"
    else:
        time_est = "3 - 7 days"
        level = "VERY HIGH"

    bar = "#" * score + "." * (10 - score)
    print("  Task       : {}".format(task[:60]))
    print("  Complexity : {}/10 [{}] {}".format(score, bar, level))
    print("  Time est.  : {}".format(time_est))
    print()
    print("  Factors considered:")
    print("    Keywords detected, task description length,")
    print("    integration/migration/scaling indicators")

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  dependencies)
    PLAN_ID="${1:-}"
    python3 << PYEOF
import os, glob

base = os.path.expanduser("~/task-planner")
plans_dir = os.path.join(base, "plans")
plan_id = "${PLAN_ID}"

print("=" * 60)
print("  TASK PLANNER — Dependencies")
print("=" * 60)
print()

if plan_id and os.path.exists(plans_dir):
    matches = glob.glob(os.path.join(plans_dir, "*{}*".format(plan_id)))
    if matches:
        with open(matches[0]) as f:
            content = f.read()
        tasks = [l.strip() for l in content.split("\n") if l.strip().startswith("- [")]
        print("  Plan: {}".format(os.path.basename(matches[0])))
        print()
        print("  Dependency Chain (sequential by default):")
        print()
        for i, t in enumerate(tasks):
            task_text = t[6:]
            if i == 0:
                print("    {} (START)".format(task_text))
            else:
                print("    |")
                print("    v")
                print("    {} (depends on #{})".format(task_text, i))
        print()
        print("  Edit the plan file to customize dependencies.")
    else:
        print("  No plan found matching: {}".format(plan_id))
else:
    print("  Usage: task-planner.sh dependencies <plan_id>")
    print("  List plans with: ls ~/task-planner/plans/")

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  prioritize)
    python3 << 'PYEOF'
import os, glob

base = os.path.expanduser("~/task-planner")
plans_dir = os.path.join(base, "plans")

print("=" * 60)
print("  TASK PLANNER — Prioritize")
print("=" * 60)
print()

if not os.path.exists(plans_dir):
    print("  No plans found. Create some with 'plan' first.")
else:
    plans = []
    for fname in sorted(os.listdir(plans_dir)):
        if not fname.endswith(".md"):
            continue
        fpath = os.path.join(plans_dir, fname)
        with open(fpath) as f:
            content = f.read()
        title = ""
        total = 0
        done = 0
        for line in content.split("\n"):
            if line.startswith("# Plan:"):
                title = line.replace("# Plan:", "").strip()
            if line.strip().startswith("- ["):
                total += 1
                if "[x]" in line.lower():
                    done += 1
        pct = done * 100 // max(total, 1)
        remaining = total - done
        plans.append((remaining, pct, title[:50], fname))

    plans.sort(reverse=True)
    print("  Priority ranking (most remaining work first):")
    print()
    print("  {:4s} {:5s} {:50s} {}".format("Rank", "Done", "Task", "File"))
    print("  " + "-" * 70)
    for i, (remaining, pct, title, fname) in enumerate(plans, 1):
        print("  {:4d} {:3d}%  {:50s} {}".format(i, pct, title, fname))

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  parallel)
    PLAN_ID="${1:-}"
    python3 << PYEOF
import os, glob

base = os.path.expanduser("~/task-planner")
plans_dir = os.path.join(base, "plans")
plan_id = "${PLAN_ID}"

print("=" * 60)
print("  TASK PLANNER — Parallel Analysis")
print("=" * 60)
print()

if not plan_id:
    print("  Usage: task-planner.sh parallel <plan_id>")
else:
    matches = glob.glob(os.path.join(plans_dir, "*{}*".format(plan_id))) if os.path.exists(plans_dir) else []
    if not matches:
        print("  No plan found matching: {}".format(plan_id))
    else:
        with open(matches[0]) as f:
            content = f.read()
        tasks = [l.strip()[6:] for l in content.split("\n") if l.strip().startswith("- [")]

        independent_kw = ["document", "test", "review", "research"]
        sequential = []
        parallel = []
        for t in tasks:
            if any(k in t.lower() for k in independent_kw):
                parallel.append(t)
            else:
                sequential.append(t)

        print("  Sequential (must be in order):")
        for t in sequential:
            print("    -> {}".format(t))
        print()
        print("  Parallelizable (can run simultaneously):")
        for t in parallel:
            print("    || {}".format(t))
        print()
        if parallel:
            speedup = len(tasks) / max(len(sequential) + 1, 1)
            print("  Potential speedup: {:.1f}x with {} parallel tasks".format(speedup, len(parallel)))

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  risk)
    PLAN_ID="${1:-}"
    python3 << PYEOF
import os, glob

base = os.path.expanduser("~/task-planner")
plans_dir = os.path.join(base, "plans")
plan_id = "${PLAN_ID}"

print("=" * 60)
print("  TASK PLANNER — Risk Assessment")
print("=" * 60)
print()

if not plan_id:
    print("  Usage: task-planner.sh risk <plan_id>")
else:
    matches = glob.glob(os.path.join(plans_dir, "*{}*".format(plan_id))) if os.path.exists(plans_dir) else []
    if not matches:
        print("  No plan found matching: {}".format(plan_id))
    else:
        with open(matches[0]) as f:
            content = f.read()
        tasks = [l.strip()[6:] for l in content.split("\n") if l.strip().startswith("- [")]

        risk_kw = {"integrate": "HIGH", "migrate": "HIGH", "security": "HIGH",
                    "design": "MEDIUM", "implement": "MEDIUM", "core": "MEDIUM",
                    "document": "LOW", "test": "LOW", "review": "LOW", "define": "LOW"}

        print("  Risk Assessment per Subtask:")
        print()
        for t in tasks:
            level = "MEDIUM"
            for kw, risk in risk_kw.items():
                if kw in t.lower():
                    level = risk
                    break
            icon = {"HIGH": "[!!!]", "MEDIUM": "[ ! ]", "LOW": "[ . ]"}
            print("  {} {:7s} {}".format(icon.get(level, "[ ? ]"), level, t[:55]))
        print()
        high_count = sum(1 for t in tasks if any(k in t.lower() for k in ["integrate", "migrate", "security"]))
        if high_count > 0:
            print("  WARNING: {} high-risk task(s) identified. Plan mitigations.".format(high_count))

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  progress)
    python3 << 'PYEOF'
import os

base = os.path.expanduser("~/task-planner")
plans_dir = os.path.join(base, "plans")

print("=" * 60)
print("  TASK PLANNER — Progress Tracker")
print("=" * 60)
print()

if not os.path.exists(plans_dir):
    print("  No plans found.")
else:
    for fname in sorted(os.listdir(plans_dir)):
        if not fname.endswith(".md"):
            continue
        fpath = os.path.join(plans_dir, fname)
        with open(fpath) as f:
            content = f.read()
        title = fname
        total = 0
        done = 0
        for line in content.split("\n"):
            if line.startswith("# Plan:"):
                title = line.replace("# Plan:", "").strip()[:40]
            if line.strip().startswith("- ["):
                total += 1
                if "[x]" in line.lower():
                    done += 1
        if total > 0:
            pct = done * 100 // total
            bar = "#" * (pct // 5) + "." * (20 - pct // 5)
            print("  {:40s} [{:20s}] {:3d}% ({}/{})".format(title, bar, pct, done, total))

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  retrospective)
    PLAN_ID="${1:-}"
    python3 << PYEOF
import os, glob, datetime

base = os.path.expanduser("~/task-planner")
plans_dir = os.path.join(base, "plans")
retro_dir = os.path.join(base, "retrospectives")
os.makedirs(retro_dir, exist_ok=True)
plan_id = "${PLAN_ID}"

print("=" * 60)
print("  TASK PLANNER — Retrospective")
print("=" * 60)
print()

if not plan_id:
    print("  Usage: task-planner.sh retrospective <plan_id>")
else:
    matches = glob.glob(os.path.join(plans_dir, "*{}*".format(plan_id))) if os.path.exists(plans_dir) else []
    if not matches:
        print("  No plan found matching: {}".format(plan_id))
    else:
        with open(matches[0]) as f:
            content = f.read()
        total = content.count("- [")
        done = content.count("- [x]") + content.count("- [X]")
        pct = done * 100 // max(total, 1)

        now = datetime.datetime.now()
        retro_file = os.path.join(retro_dir, "retro_{}.md".format(plan_id))

        print("  Plan: {}".format(os.path.basename(matches[0])))
        print("  Completion: {}/{} ({}%)".format(done, total, pct))
        print()
        print("  Retrospective Prompts:")
        print("  ----------------------")
        print("  1. What went well?")
        print("  2. What went poorly?")
        print("  3. Were estimates accurate?")
        print("  4. Any unexpected blockers?")
        print("  5. What would you change?")
        print("  6. Key takeaway for next time?")
        print()

        with open(retro_file, "w") as f:
            f.write("# Retrospective: {}\n\n".format(plan_id))
            f.write("Date: {}\nCompletion: {}%\n\n".format(now.strftime("%Y-%m-%d"), pct))
            f.write("## What went well?\n\n\n## What went poorly?\n\n\n")
            f.write("## Estimates accuracy?\n\n\n## Unexpected blockers?\n\n\n")
            f.write("## What to change?\n\n\n## Key takeaway?\n\n")

        print("  Template saved: {}".format(retro_file))

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  *)
    echo "=================================================="
    echo "  TASK PLANNER — AI Task Decomposition"
    echo "=================================================="
    echo ""
    echo "  Commands:"
    echo "    plan          Break task into subtasks"
    echo "    estimate      Time/complexity estimation"
    echo "    dependencies  Identify task dependencies"
    echo "    prioritize    Rank by remaining work"
    echo "    parallel      Find parallelizable tasks"
    echo "    risk          Risk assessment per task"
    echo "    progress      Track completion"
    echo "    retrospective Post-completion review"
    echo ""
    echo "  Usage:"
    echo "    bash task-planner.sh <command> [args]"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;
esac
