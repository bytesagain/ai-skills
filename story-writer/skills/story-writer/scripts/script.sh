#!/usr/bin/env bash
# story-writer — Interactive story and fiction writing toolkit
set -euo pipefail
VERSION="2.0.0"
DATA_DIR="${STORY_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/story-writer}"
mkdir -p "$DATA_DIR/stories" "$DATA_DIR/characters"

show_help() {
    cat << EOF
story-writer v$VERSION

Story and fiction writing toolkit with structure, characters, and worldbuilding

Usage: story-writer <command> [args]

Structure:
  outline <title> <genre>    Story outline generator
  plot <type>                Plot structure template (3act/hero/mystery/romance)
  chapter <n> <title>        Chapter template
  scene <setting> <mood>     Scene description generator
  twist                      Plot twist generator

Characters:
  character <name> <role>    Character profile builder
  dialogue <char1> <char2>   Dialogue scene template
  motivation <archetype>     Character motivation guide
  arc <type>                 Character arc template (growth/fall/flat)

Worldbuilding:
  world <genre>              World setting generator
  magic <type>               Magic system template
  conflict <type>            Conflict generator (internal/external/society)

Writing:
  prompt [genre]             Random writing prompt
  opener <genre>             Opening line generator
  describe <subject>         Sensory description helper
  pace <act>                 Pacing guide

Management:
  save <name>                Save story draft
  list                       List saved stories
  wordcount <file>           Word count + reading time
  help                       Show this help

EOF
}

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

cmd_outline() {
    local title="${1:?Usage: story-writer outline <title> <genre>}"
    local genre="${2:-fantasy}"
    echo "  ═══ Story Outline: $title ═══"
    echo "  Genre: $genre"
    echo ""
    echo "  PREMISE:"
    echo "  [One sentence: Who wants what, but what stands in the way?]"
    echo ""
    echo "  ACT 1 - SETUP (25%)"
    echo "  • Opening image: [First impression of the world]"
    echo "  • Meet protagonist: [Name, flaw, desire]"
    echo "  • Inciting incident: [What disrupts normal life?]"
    echo "  • Debate: [Should they accept the call?]"
    echo ""
    echo "  ACT 2 - CONFRONTATION (50%)"
    echo "  • New world: [Unfamiliar territory]"
    echo "  • Rising stakes: [3 escalating challenges]"
    echo "  • Midpoint twist: [Game-changer revelation]"
    echo "  • Dark moment: [All seems lost]"
    echo ""
    echo "  ACT 3 - RESOLUTION (25%)"
    echo "  • Climax: [Final confrontation]"
    echo "  • Resolution: [How the world changed]"
    echo "  • Final image: [Mirror of opening, showing growth]"
    _log "outline" "$title ($genre)"
}

cmd_plot() {
    local type="${1:-3act}"
    echo "  ═══ Plot Structure: $type ═══"
    case "$type" in
        3act)
            echo "  Act 1: Setup → Inciting Incident → Plot Point 1"
            echo "  Act 2: Rising Action → Midpoint → Crisis → Plot Point 2"
            echo "  Act 3: Climax → Falling Action → Resolution" ;;
        hero)
            echo "  1. Ordinary World     7. Approach"
            echo "  2. Call to Adventure   8. Ordeal"
            echo "  3. Refusal             9. Reward"
            echo "  4. Meeting Mentor     10. Road Back"
            echo "  5. Crossing Threshold 11. Resurrection"
            echo "  6. Tests & Allies     12. Return with Elixir" ;;
        mystery)
            echo "  1. Crime/puzzle introduced"
            echo "  2. Initial investigation + red herrings"
            echo "  3. First breakthrough clue"
            echo "  4. Complication (new victim/suspect)"
            echo "  5. Key revelation changes everything"
            echo "  6. Final deduction + confrontation"
            echo "  7. Resolution + reveal" ;;
        romance)
            echo "  1. Meet cute / first encounter"
            echo "  2. Attraction + resistance"
            echo "  3. Growing closer"
            echo "  4. Midpoint commitment"
            echo "  5. Major conflict / breakup"
            echo "  6. Grand gesture / reconciliation"
            echo "  7. Happy ending" ;;
        *) echo "  Types: 3act, hero, mystery, romance" ;;
    esac
}

cmd_character() {
    local name="${1:?Usage: story-writer character <name> <role>}"
    local role="${2:-protagonist}"
    echo "  ═══ Character Profile: $name ═══"
    echo "  Role: $role"
    echo ""
    echo "  BASICS:"
    echo "  Name: $name"
    echo "  Age:         [   ]"
    echo "  Appearance:  [   ]"
    echo "  Occupation:  [   ]"
    echo ""
    echo "  PERSONALITY:"
    echo "  Strengths:   [   ]"
    echo "  Flaws:       [   ] ← (this drives the story)"
    echo "  Fear:        [   ]"
    echo "  Secret:      [   ]"
    echo ""
    echo "  MOTIVATION:"
    echo "  Want:        [External goal - what they chase]"
    echo "  Need:        [Internal goal - what they actually need]"
    echo "  Lie:         [False belief they hold]"
    echo ""
    echo "  VOICE:"
    echo "  Speech style: [Formal/casual/dialect/terse/verbose]"
    echo "  Catchphrase:  [   ]"
    echo "  Quirk:        [   ]"
    echo "$name" >> "$DATA_DIR/characters/list.txt" 2>/dev/null
    _log "character" "$name ($role)"
}

cmd_dialogue() {
    local c1="${1:?Usage: story-writer dialogue <char1> <char2>}"
    local c2="${2:?}"
    echo "  ═══ Dialogue Scene: $c1 & $c2 ═══"
    echo ""
    echo "  [Setting: where and when]"
    echo ""
    echo "  $c1: [Opening line - reveals character]"
    echo "  $c2: [Response - shows relationship dynamic]"
    echo "  $c1: [Escalation or revelation]"
    echo "  $c2: [Reaction - body language + words]"
    echo ""
    echo "  Tips:"
    echo "  • Each character should sound different"
    echo "  • Subtext > direct statements"
    echo "  • Break up dialogue with action beats"
    echo "  • People rarely answer questions directly"
}

cmd_scene() {
    local setting="${1:?Usage: story-writer scene <setting> <mood>}"
    local mood="${2:-tense}"
    echo "  ═══ Scene: $setting ($mood) ═══"
    echo ""
    echo "  SIGHT:  [What does the character see first?]"
    echo "  SOUND:  [Background noise, silence, echoes?]"
    echo "  SMELL:  [Often the most evocative sense]"
    echo "  TOUCH:  [Temperature, texture, wind?]"
    echo "  TASTE:  [If relevant]"
    echo ""
    echo "  MOOD ($mood):"
    case "$mood" in
        tense)   echo "  Short sentences. Sharp details. Clock ticking." ;;
        calm)    echo "  Long flowing descriptions. Gentle imagery. Warmth." ;;
        eerie)   echo "  Wrong details. Familiar but off. Silence too deep." ;;
        joyful)  echo "  Bright colors. Light movement. Open spaces." ;;
        sad)     echo "  Muted tones. Heavy weight. Time dragging." ;;
        *) echo "  Moods: tense/calm/eerie/joyful/sad" ;;
    esac
}

cmd_twist() {
    echo "  ═══ Plot Twist Generator ═══"
    local twists=(
        "The mentor is the real villain"
        "The protagonist caused the problem they're trying to solve"
        "The ally has been dead the whole time"
        "Two enemies discover they share a parent"
        "The treasure was worthless; the journey was the point"
        "The prophecy was misinterpreted"
        "The villain and hero want the same thing"
        "Time has been moving differently than assumed"
        "The narrator has been unreliable"
        "The safe haven is actually a trap"
    )
    local idx=$((RANDOM % ${#twists[@]}))
    echo "  💡 ${twists[$idx]}"
    echo ""
    echo "  Roll again? Run: story-writer twist"
}

cmd_prompt() {
    local genre="${1:-any}"
    local prompts_fantasy=("A map appears showing a place that shouldn't exist" "The last dragon asks for help" "Magic suddenly stops working")
    local prompts_scifi=("A signal from the future arrives" "Everyone forgets the same day" "AI develops homesickness")
    local prompts_mystery=("A locked room with two victims but only one could fit" "The detective receives evidence from themselves" "A town where nobody dies")
    local prompts_any=("Write about the last time something happened" "A stranger gives your character a key" "Two people meet at the worst possible moment")
    
    echo "  ═══ Writing Prompt ($genre) ═══"
    case "$genre" in
        fantasy)  local arr=("${prompts_fantasy[@]}"); echo "  ${arr[$((RANDOM % ${#arr[@]}))]}" ;;
        scifi)    local arr=("${prompts_scifi[@]}"); echo "  ${arr[$((RANDOM % ${#arr[@]}))]}" ;;
        mystery)  local arr=("${prompts_mystery[@]}"); echo "  ${arr[$((RANDOM % ${#arr[@]}))]}" ;;
        *)        local arr=("${prompts_any[@]}"); echo "  ${arr[$((RANDOM % ${#arr[@]}))]}" ;;
    esac
}

cmd_opener() {
    local genre="${1:-general}"
    echo "  ═══ Opening Lines ($genre) ═══"
    case "$genre" in
        thriller) echo "  \"The phone rang at 3 AM, and [name] already knew who it was.\"" ;;
        fantasy)  echo "  \"The day the sky turned silver, everything changed.\"" ;;
        romance)  echo "  \"Of all the coffee shops in the city, [name] walked into mine.\"" ;;
        horror)   echo "  \"The house had been empty for years. That's what they told us.\"" ;;
        *)        echo "  \"[Name] had exactly 24 hours to [impossible task]. It started with a lie.\"" ;;
    esac
    echo ""
    echo "  Formula: Character + Situation + Hook"
}

cmd_wordcount() {
    local file="${1:?Usage: story-writer wordcount <file>}"
    [ -f "$file" ] || { echo "Not found: $file"; return 1; }
    local words=$(wc -w < "$file")
    local mins=$((words / 250))
    echo "  Words: $words"
    echo "  Reading time: ~${mins} min"
    echo "  Pages (250w/p): ~$((words / 250))"
    if [ "$words" -lt 1000 ]; then echo "  Type: Flash fiction"
    elif [ "$words" -lt 7500 ]; then echo "  Type: Short story"
    elif [ "$words" -lt 40000 ]; then echo "  Type: Novella"
    else echo "  Type: Novel"; fi
}

cmd_save() {
    local name="${1:?}"
    cat > "$DATA_DIR/stories/$name.md"
    echo "  Saved: $name"
    _log "save" "$name"
}

cmd_list() {
    echo "  Saved stories:"
    ls -1 "$DATA_DIR/stories/"*.md 2>/dev/null | while read -r f; do
        printf "  %-25s %s words\n" "$(basename "$f" .md)" "$(wc -w < "$f")"
    done || echo "  (none)"
}

case "${1:-help}" in
    outline)    shift; cmd_outline "$@" ;;
    plot)       shift; cmd_plot "$@" ;;
    chapter)    shift; echo "  === Chapter ${1:-1}: ${2:-Untitled} ===" ;;
    scene)      shift; cmd_scene "$@" ;;
    twist)      cmd_twist ;;
    character)  shift; cmd_character "$@" ;;
    dialogue)   shift; cmd_dialogue "$@" ;;
    motivation) shift; echo "  Archetypes: hero/mentor/trickster/shadow/herald" ;;
    arc)        shift; echo "  Arc ($1): Start state → Challenge → Transform → New state" ;;
    world)      shift; echo "  World ($1): Geography | Culture | History | Rules | Conflict" ;;
    magic)      shift; echo "  Magic system: Source | Cost | Limits | Who can use | Social impact" ;;
    conflict)   shift; echo "  Conflict ($1): Stakes | Opposing forces | Escalation | Resolution" ;;
    prompt)     shift; cmd_prompt "${1:-any}" ;;
    opener)     shift; cmd_opener "${1:-general}" ;;
    describe)   shift; echo "  Describe '$1': See | Hear | Smell | Touch | Feel(emotion)" ;;
    pace)       shift; echo "  Pacing: Short sentences=fast. Long sentences=slow. Mix both." ;;
    save)       shift; cmd_save "$@" ;;
    list)       cmd_list ;;
    wordcount)  shift; cmd_wordcount "$@" ;;
    help|-h)    show_help ;;
    version|-v) echo "story-writer v$VERSION" ;;
    *)          echo "Unknown: $1"; show_help; exit 1 ;;
esac
