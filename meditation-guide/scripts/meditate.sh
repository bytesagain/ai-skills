#!/usr/bin/env bash
# meditation-guide — 冥想与正念工具
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
run_python() {
python3 << 'PYEOF'
import sys, time, hashlib, math
from datetime import datetime

cmd = sys.argv[1] if len(sys.argv) > 1 else "help"
inp = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else ""

BREATHING = {
    "478": {"name": "4-7-8 Breathing", "desc": "Calming technique", "inhale": 4, "hold": 7, "exhale": 8, "cycles": 4},
    "box": {"name": "Box Breathing", "desc": "Focus & calm", "inhale": 4, "hold": 4, "exhale": 4, "hold2": 4, "cycles": 4},
    "energize": {"name": "Energizing Breath", "desc": "Quick energy boost", "inhale": 2, "hold": 0, "exhale": 2, "cycles": 10},
    "relaxing": {"name": "Deep Relaxation", "desc": "Before sleep", "inhale": 5, "hold": 3, "exhale": 7, "cycles": 6},
    "wim-hof": {"name": "Wim Hof Method", "desc": "30 power breaths + hold", "inhale": 2, "hold": 0, "exhale": 2, "cycles": 30},
}

MEDITATIONS = {
    "body-scan": {"duration": 10, "steps": [
        "Close your eyes. Take 3 deep breaths.",
        "Focus on the top of your head. Notice any tension.",
        "Move attention to your forehead, eyebrows, eyes. Relax.",
        "Jaw, neck, shoulders. Let tension melt away.",
        "Arms, hands, fingers. Feel warmth spreading.",
        "Chest, belly. Notice your breathing rhythm.",
        "Lower back, hips. Release any tightness.",
        "Thighs, knees, calves. Feel grounded.",
        "Feet, toes. Feel connected to the earth.",
        "Whole body. Sit with this feeling of completeness.",
    ]},
    "mindfulness": {"duration": 5, "steps": [
        "Sit comfortably. Close your eyes.",
        "Focus on your breath. In... Out...",
        "When thoughts arise, notice them without judgment.",
        "Label them: thinking, planning, remembering...",
        "Gently return focus to your breath.",
        "Notice sounds around you. Accept them.",
        "Feel the air on your skin.",
        "Return to breath. In... Out...",
    ]},
    "gratitude": {"duration": 5, "steps": [
        "Close your eyes. Take 3 deep breaths.",
        "Think of one person you are grateful for.",
        "Feel the warmth of that gratitude.",
        "Think of one thing that happened today you appreciate.",
        "Think of one ability you have that you are thankful for.",
        "Hold all three gratitudes together.",
        "Send silent thanks to each one.",
        "Open your eyes. Carry this feeling forward.",
    ]},
    "focus": {"duration": 8, "steps": [
        "Sit upright. Close your eyes.",
        "Choose one word or phrase as your anchor.",
        "Breathe in deeply. On exhale, silently repeat your word.",
        "If mind wanders, notice, and return to your word.",
        "Continue for 3 minutes.",
        "Now shift: count breaths from 1 to 10.",
        "If you lose count, start over at 1.",
        "This trains single-pointed concentration.",
    ]},
}

PROMPTS = [
    "What am I feeling right now, without judging it?",
    "What would I do today if fear were not a factor?",
    "Name three things I can see, hear, and feel right now.",
    "What am I holding onto that I can release?",
    "How can I show kindness to myself today?",
    "What lesson is this difficult moment teaching me?",
    "If my body could speak, what would it say?",
    "What brings me peace? How can I create more of it?",
    "Am I living according to my values today?",
    "What would my wisest self advise me right now?",
    "What am I grateful for that I usually overlook?",
    "How does my breathing feel right now?",
]

def cmd_breathe():
    pattern = inp.strip().lower() if inp else "478"
    if pattern not in BREATHING:
        print("Available: {}".format(", ".join(BREATHING.keys())))
        return
    b = BREATHING[pattern]
    print("=" * 45)
    print("  {} ".format(b["name"]))
    print("  {}".format(b["desc"]))
    print("=" * 45)
    print("")
    total_time = 0
    for c in range(1, b["cycles"] + 1):
        line = "  Cycle {}: ".format(c)
        line += "INHALE({}s)".format(b["inhale"])
        total_time += b["inhale"]
        if b.get("hold", 0) > 0:
            line += " > HOLD({}s)".format(b["hold"])
            total_time += b["hold"]
        line += " > EXHALE({}s)".format(b["exhale"])
        total_time += b["exhale"]
        if b.get("hold2", 0):
            line += " > HOLD({}s)".format(b["hold2"])
            total_time += b["hold2"]
        print(line)
    print("")
    print("  Total time: ~{}s ({:.1f} min)".format(total_time, total_time/60))
    print("  Tip: Set a timer and follow the rhythm")

def cmd_meditate():
    mtype = inp.strip().lower() if inp else "mindfulness"
    if mtype not in MEDITATIONS:
        print("Available: {}".format(", ".join(MEDITATIONS.keys())))
        return
    m = MEDITATIONS[mtype]
    print("=" * 50)
    print("  {} Meditation (~{} min)".format(mtype.replace("-", " ").title(), m["duration"]))
    print("=" * 50)
    print("")
    interval = m["duration"] * 60 // len(m["steps"])
    for i, step in enumerate(m["steps"], 1):
        mins = i * interval // 60
        secs = i * interval % 60
        print("  [{:02d}:{:02d}] Step {}: {}".format(mins, secs, i, step))
    print("")
    print("  Set a timer for {} minutes.".format(m["duration"]))
    print("  Ring a bell/chime at the end.")

def cmd_journal():
    seed = int(hashlib.md5(datetime.now().strftime("%Y%m%d").encode()).hexdigest()[:8], 16)
    idx1 = seed % len(PROMPTS)
    idx2 = (seed + 7) % len(PROMPTS)
    idx3 = (seed + 13) % len(PROMPTS)
    print("=" * 50)
    print("  Mindfulness Journal — {}".format(datetime.now().strftime("%Y-%m-%d")))
    print("=" * 50)
    print("")
    print("  Today's Prompts:")
    print("")
    print("  1. {}".format(PROMPTS[idx1]))
    print("")
    print("  2. {}".format(PROMPTS[idx2]))
    print("")
    print("  3. {}".format(PROMPTS[idx3]))
    print("")
    print("  Take 5-10 minutes to reflect and write freely.")
    print("  No right or wrong answers.")

def cmd_timer():
    minutes = int(inp) if inp and inp.isdigit() else 5
    total = minutes * 60
    print("=" * 40)
    print("  Meditation Timer: {} minutes".format(minutes))
    print("=" * 40)
    print("")
    print("  Start: {}".format(datetime.now().strftime("%H:%M:%S")))
    end = datetime.now()
    end_time = end.replace(second=end.second + total) if total < 60 else end
    print("  Suggested schedule:")
    intervals = [0, total//4, total//2, total*3//4, total]
    labels = ["Begin", "Quarter", "Halfway", "Three-quarter", "End - ring bell"]
    for t, l in zip(intervals, labels):
        m = t // 60
        s = t % 60
        print("    {:02d}:{:02d} — {}".format(m, s, l))

def cmd_streak():
    print("=" * 45)
    print("  Meditation Streak Tracker")
    print("=" * 45)
    print("")
    print("  Track your daily practice:")
    print("")
    now = datetime.now()
    for i in range(7):
        d = now.replace(day=now.day - i) if now.day - i > 0 else now
        day_str = d.strftime("%a %m/%d")
        print("    {} [ ]  ___ minutes  Type: ___".format(day_str))
    print("")
    print("  Weekly Goal: 5+ sessions")
    print("  Monthly Goal: 20+ sessions")
    print("  Tips: Start with 5min, build to 20min")

commands = {
    "breathe": cmd_breathe, "meditate": cmd_meditate,
    "journal": cmd_journal, "timer": cmd_timer, "streak": cmd_streak,
}
if cmd == "help":
    print("Meditation & Mindfulness Guide")
    print("")
    print("Commands:")
    print("  breathe [pattern]    — Guided breathing (478/box/energize/relaxing/wim-hof)")
    print("  meditate [type]      — Guided meditation (body-scan/mindfulness/gratitude/focus)")
    print("  journal              — Daily mindfulness journal prompts")
    print("  timer [minutes]      — Meditation timer with intervals")
    print("  streak               — Practice streak tracker")
elif cmd in commands:
    commands[cmd]()
else:
    print("Unknown: {}".format(cmd))
print("")
print("Powered by BytesAgain | bytesagain.com")
PYEOF
}
run_python "$CMD" $INPUT
