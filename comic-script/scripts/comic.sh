#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
run_python() {
python3 << 'PYEOF'
import sys
cmd = sys.argv[1] if len(sys.argv) > 1 else "help"
inp = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else ""

def cmd_storyboard():
    if not inp:
        print("Usage: storyboard <scene_count> [title]")
        print("Example: storyboard 6 Hero-Journey")
        return
    parts = inp.split()
    scenes = int(parts[0]) if parts else 4
    title = parts[1] if len(parts) > 1 else "Untitled"
    print("=" * 60)
    print("  Storyboard — {} ({} panels)".format(title, scenes))
    print("=" * 60)
    for i in range(1, scenes + 1):
        print("")
        print("  Panel {} / {}".format(i, scenes))
        print("  +" + "-" * 40 + "+")
        print("  |" + " " * 40 + "|")
        print("  |  [Visual Description]" + " " * 16 + "|")
        print("  |" + " " * 40 + "|")
        print("  |" + " " * 40 + "|")
        print("  +" + "-" * 40 + "+")
        print("  Shot: [wide/medium/close-up/extreme close]")
        print("  Dialogue: ___")
        print("  SFX: ___")
        print("  Note: ___")

def cmd_character():
    if not inp:
        print("Usage: character <name> [archetype]")
        print("Archetypes: hero, villain, mentor, sidekick, love-interest")
        return
    parts = inp.split()
    name = parts[0]
    arch = parts[1] if len(parts) > 1 else "hero"
    visual_traits = {
        "hero": ["Determined eyes","Athletic build","Distinctive hair/scar","Primary colors"],
        "villain": ["Sharp features","Dark palette","Exaggerated expressions","Imposing silhouette"],
        "mentor": ["Wise eyes","Aged features","Calm posture","Muted tones"],
        "sidekick": ["Expressive face","Smaller stature","Bright accent color","Dynamic poses"],
    }
    traits = visual_traits.get(arch, visual_traits["hero"])
    print("=" * 50)
    print("  Character Sheet: {} ({})".format(name, arch))
    print("=" * 50)
    print("")
    print("  Name: {}".format(name))
    print("  Archetype: {}".format(arch))
    print("  Age: ___")
    print("  Height: ___")
    print("")
    print("  Visual Design:")
    for t in traits:
        print("    - {}".format(t))
    print("")
    print("  Expression Sheet (draw these):")
    for expr in ["Neutral","Happy","Angry","Surprised","Sad","Determined"]:
        print("    [ ] {}".format(expr))
    print("")
    print("  Signature Pose: ___")
    print("  Color Palette: #___ #___ #___ #___")

def cmd_dialogue():
    print("=" * 50)
    print("  Comic Dialogue Tips")
    print("=" * 50)
    print("")
    rules = [
        ("Bubble Types", ["Round: normal speech","Cloud: thought","Spiky: shouting","Whisper: dashed outline","Narration: rectangular box"]),
        ("Writing Rules", ["Max 25 words per bubble","2-3 bubbles per panel max","Read order: top-left to bottom-right","Each character gets distinct voice","Show, do not tell"]),
        ("SFX Examples", ["BOOM! POW! CRASH!","*knock knock*","~sigh~","WHOOOOSH","...silence..."]),
    ]
    for title, items in rules:
        print("  {}:".format(title))
        for item in items:
            print("    - {}".format(item))
        print("")

def cmd_layout():
    layouts = [
        ("Standard Grid", "2x3 or 3x3 equal panels\nBest for: calm scenes, dialogue"),
        ("Splash Page", "One big panel = full page\nBest for: dramatic reveals, action peaks"),
        ("L-Shape", "One tall panel + 2-3 small\nBest for: establishing shot + details"),
        ("Diagonal", "Tilted panel borders\nBest for: action, tension, movement"),
        ("Borderless", "No panel borders, bleeding art\nBest for: emotional, dreamlike moments"),
    ]
    print("=" * 50)
    print("  Page Layout Templates")
    print("=" * 50)
    print("")
    for name, desc in layouts:
        print("  {}".format(name))
        for line in desc.split("\n"):
            print("    {}".format(line.strip()))
        print("")

commands = {"storyboard": cmd_storyboard, "character": cmd_character, "dialogue": cmd_dialogue, "layout": cmd_layout}
if cmd == "help":
    print("Comic Script Writer")
    print("")
    print("Commands:")
    print("  storyboard <panels> [title] — Panel-by-panel template")
    print("  character <name> [type]     — Character design sheet")
    print("  dialogue                    — Dialogue writing tips")
    print("  layout                      — Page layout templates")
elif cmd in commands:
    commands[cmd]()
else:
    print("Unknown: {}".format(cmd))
print("")
print("Powered by BytesAgain | bytesagain.com")
PYEOF
}
run_python "$CMD" $INPUT
