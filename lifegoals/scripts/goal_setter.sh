#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# License: MIT — independent, not derived from any third-party source
# Goal setter — track goals, milestones, and progress
set -euo pipefail
GOAL_DIR="${GOAL_DIR:-$HOME/.goals}"
mkdir -p "$GOAL_DIR"
DB="$GOAL_DIR/goals.json"
[ ! -f "$DB" ] && echo '[]' > "$DB"
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "Goal Setter — achieve your goals step by step
Commands:
  set <goal> [deadline]     Set a new goal
  milestone <goal> <step>   Add milestone to goal
  progress <goal> <pct>     Update progress (0-100%)
  check <goal> <milestone>  Check off milestone
  list                      List all goals
  active                    Show active goals
  review                    Weekly goal review
  motivate                  Motivational quote
  archive <goal>            Archive completed goal
  stats                     Goal statistics
  info                      Version info
Powered by BytesAgain | bytesagain.com";;
set)
    goal="${1:-}"; deadline="${2:-}"
    [ -z "$goal" ] && { echo "Usage: set <goal> [deadline]"; exit 1; }
    python3 << PYEOF
import json, time
with open("$DB") as f: goals = json.load(f)
gid = max([g.get("id",0) for g in goals]+[0]) + 1
goals.append({"id":gid,"goal":"$goal","deadline":"$deadline","progress":0,
              "milestones":[],"status":"active","created":time.strftime("%Y-%m-%d"),
              "notes":""})
with open("$DB","w") as f: json.dump(goals, f, indent=2, ensure_ascii=False)
print("🎯 Goal #{} set: $goal".format(gid))
if "$deadline": print("   Deadline: $deadline")
PYEOF
;;
milestone)
    goal="${1:-}"; step="${2:-}"
    [ -z "$goal" ] || [ -z "$step" ] && { echo "Usage: milestone <goal> <step>"; exit 1; }
    python3 -c "
import json
with open('$DB') as f: goals = json.load(f)
for g in goals:
    if g['goal'] == '$goal' or str(g.get('id','')) == '$goal':
        g.setdefault('milestones',[]).append({'step':'$step','done':False})
        print('📍 Milestone added to {}: $step'.format(g['goal']))
        break
with open('$DB','w') as f: json.dump(goals, f, indent=2, ensure_ascii=False)
";;
progress)
    goal="${1:-}"; pct="${2:-0}"
    [ -z "$goal" ] && { echo "Usage: progress <goal> <percent>"; exit 1; }
    python3 -c "
import json
with open('$DB') as f: goals = json.load(f)
for g in goals:
    if g['goal'] == '$goal' or str(g.get('id','')) == '$goal':
        g['progress'] = int('$pct')
        bar = '█' * (int('$pct')//10) + '░' * (10-int('$pct')//10)
        print('📊 {} [{}] {}%'.format(g['goal'], bar, '$pct'))
        if int('$pct') >= 100:
            g['status'] = 'done'
            print('🎉 Goal achieved!')
        break
with open('$DB','w') as f: json.dump(goals, f, indent=2, ensure_ascii=False)
";;
check)
    goal="${1:-}"; milestone="${2:-}"
    python3 -c "
import json
with open('$DB') as f: goals = json.load(f)
for g in goals:
    if g['goal'] == '$goal' or str(g.get('id','')) == '$goal':
        for m in g.get('milestones',[]):
            if m['step'] == '$milestone':
                m['done'] = True
                print('✅ Milestone done: $milestone')
                break
        done = len([m for m in g.get('milestones',[]) if m['done']])
        total = len(g.get('milestones',[]))
        if total > 0:
            g['progress'] = done * 100 // total
            print('   Progress: {}/{} ({:.0f}%)'.format(done, total, done*100/total))
        break
with open('$DB','w') as f: json.dump(goals, f, indent=2, ensure_ascii=False)
";;
list)
    python3 << PYEOF
import json
with open("$DB") as f: goals = json.load(f)
print("🎯 All Goals:")
for g in goals:
    bar = "█" * (g["progress"]//10) + "░" * (10-g["progress"]//10)
    status = "✅" if g["status"]=="done" else ("📌" if g["status"]=="active" else "📦")
    dl = " 📅{}".format(g["deadline"]) if g.get("deadline") else ""
    print("  {} #{} {} [{}] {}%{}".format(status, g["id"], g["goal"][:30], bar, g["progress"], dl))
    for m in g.get("milestones",[]):
        check = "✅" if m["done"] else "⬜"
        print("     {} {}".format(check, m["step"]))
PYEOF
;;
active)
    python3 -c "
import json
with open('$DB') as f: goals = json.load(f)
active = [g for g in goals if g['status']=='active']
print('📌 Active Goals:')
for g in active:
    bar = '█'*(g['progress']//10) + '░'*(10-g['progress']//10)
    print('  #{} {} [{}] {}%'.format(g['id'], g['goal'][:30], bar, g['progress']))
if not active: print('  (no active goals — use set to create one)')
";;
review)
    python3 << PYEOF
import json
with open("$DB") as f: goals = json.load(f)
active = [g for g in goals if g["status"]=="active"]
done = [g for g in goals if g["status"]=="done"]
print("📊 Weekly Review:")
print("  Active: {}  Done: {}  Total: {}".format(len(active), len(done), len(goals)))
print("\n  Active Goals:")
for g in active:
    bar = "█"*(g["progress"]//10) + "░"*(10-g["progress"]//10)
    milestones_done = len([m for m in g.get("milestones",[]) if m["done"]])
    milestones_total = len(g.get("milestones",[]))
    print("  #{} {} [{}] {}% ({}/{} milestones)".format(
        g["id"], g["goal"][:25], bar, g["progress"], milestones_done, milestones_total))
if done:
    print("\n  🏆 Recently Completed:")
    for g in done[-3:]:
        print("  ✅ {}".format(g["goal"]))
PYEOF
;;
motivate)
    python3 -c "
import random
quotes = [
    '\"The only way to do great work is to love what you do.\" — Steve Jobs',
    '\"It does not matter how slowly you go as long as you do not stop.\" — Confucius',
    '\"A goal without a plan is just a wish.\" — Antoine de Saint-Exupery',
    '\"The secret of getting ahead is getting started.\" — Mark Twain',
    '\"Success is not final, failure is not fatal: it is the courage to continue that counts.\" — Churchill',
    '\"The best time to plant a tree was 20 years ago. The second best time is now.\" — Chinese Proverb',
    '\"Small progress is still progress.\"',
    '\"You don\\'t have to be great to start, but you have to start to be great.\"',
    '\"Break big goals into small steps. Then take the first one.\"',
    '\"Discipline is choosing between what you want now and what you want most.\"',
]
print('💪 ' + random.choice(quotes))
";;
archive)
    goal="${1:-}"; [ -z "$goal" ] && { echo "Usage: archive <goal>"; exit 1; }
    python3 -c "
import json
with open('$DB') as f: goals = json.load(f)
for g in goals:
    if g['goal'] == '$goal' or str(g.get('id','')) == '$goal':
        g['status'] = 'archived'
        print('📦 Archived: {}'.format(g['goal']))
        break
with open('$DB','w') as f: json.dump(goals, f, indent=2, ensure_ascii=False)
";;
stats)
    python3 -c "
import json
with open('$DB') as f: goals = json.load(f)
active = len([g for g in goals if g['status']=='active'])
done = len([g for g in goals if g['status']=='done'])
archived = len([g for g in goals if g['status']=='archived'])
avg_progress = sum(g['progress'] for g in goals)/max(len(goals),1)
total_milestones = sum(len(g.get('milestones',[])) for g in goals)
done_milestones = sum(len([m for m in g.get('milestones',[]) if m['done']]) for g in goals)
print('📊 Goal Stats:')
print('  Total: {}  Active: {}  Done: {}  Archived: {}'.format(len(goals), active, done, archived))
print('  Avg progress: {:.0f}%'.format(avg_progress))
print('  Milestones: {}/{} done'.format(done_milestones, total_milestones))
if done: print('  Completion rate: {:.0f}%'.format(done*100/max(done+active,1)))
";;
info) echo "Goal Setter v1.0.0"; echo "Achieve your goals step by step"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
