#!/usr/bin/env bash
# slot — Time Slot & Schedule Block Manager
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="2.0.3"
SLOT_DIR="${SLOT_DATA_DIR:-$HOME/.slot-manager}"
SLOT_FILE="${SLOT_DIR}/slots.csv"

ensure_data_dir() {
    mkdir -p "$SLOT_DIR"
    if [ ! -f "$SLOT_FILE" ]; then
        echo "id,date,start,end,label,category,created_at" > "$SLOT_FILE"
    fi
}

generate_id() {
    date +%s%N | sha256sum | head -c 8
}

validate_time() {
    local t="$1"
    if [[ ! "$t" =~ ^[0-2][0-9]:[0-5][0-9]$ ]]; then
        echo "❌ Invalid time format: $t (use HH:MM, 24h)" >&2
        return 1
    fi
    local hour="${t%%:*}"
    if (( hour > 23 )); then
        echo "❌ Invalid hour: $hour" >&2
        return 1
    fi
}

validate_date() {
    local d="$1"
    if [[ ! "$d" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        echo "❌ Invalid date format: $d (use YYYY-MM-DD)" >&2
        return 1
    fi
}

time_to_minutes() {
    local t="$1"
    local h="${t%%:*}"
    local m="${t##*:}"
    echo $(( 10#$h * 60 + 10#$m ))
}

minutes_to_time() {
    local mins="$1"
    printf "%02d:%02d" $(( mins / 60 )) $(( mins % 60 ))
}

cmd_create() {
    local date_str="${1:-}"
    local start_time="${2:-}"
    local end_time="${3:-}"
    local label="${4:-Untitled}"
    local category="${5:-general}"

    if [ -z "$date_str" ] || [ -z "$start_time" ] || [ -z "$end_time" ]; then
        cat <<'EOF'
═══════════════════════════════════════════════════
  Create Time Slot
═══════════════════════════════════════════════════

Usage:
  bash scripts/script.sh create <date> <start> <end> [label] [category]

Arguments:
  date      Date in YYYY-MM-DD format
  start     Start time in HH:MM (24h)
  end       End time in HH:MM (24h)
  label     Slot label/name (optional, default: "Untitled")
  category  Category tag (optional, default: "general")

Examples:
  bash scripts/script.sh create "2024-03-15" "09:00" "10:30" "Team Standup" "meeting"
  bash scripts/script.sh create "2024-03-15" "14:00" "15:00" "Deep Work" "focus"
  bash scripts/script.sh create "2024-03-16" "08:00" "08:30" "Morning Review"

Categories:
  meeting     — Meetings and calls
  focus       — Deep work / focus time
  break       — Breaks and rest
  admin       — Administrative tasks
  personal    — Personal appointments
  general     — Default category

📖 More skills: bytesagain.com
EOF
        return 0
    fi

    ensure_data_dir
    validate_date "$date_str" || return 1
    validate_time "$start_time" || return 1
    validate_time "$end_time" || return 1

    local start_min end_min
    start_min=$(time_to_minutes "$start_time")
    end_min=$(time_to_minutes "$end_time")

    if (( start_min >= end_min )); then
        echo "❌ Start time ($start_time) must be before end time ($end_time)" >&2
        return 1
    fi

    local duration=$(( end_min - start_min ))
    local id
    id=$(generate_id)
    local created_at
    created_at=$(date -Iseconds 2>/dev/null || date +%Y-%m-%dT%H:%M:%S)

    # Check for conflicts before creating
    local conflicts=0
    while IFS=',' read -r sid sdate sstart send slabel scat screated; do
        [ "$sid" = "id" ] && continue
        [ "$sdate" != "$date_str" ] && continue
        local existing_start existing_end
        existing_start=$(time_to_minutes "$sstart")
        existing_end=$(time_to_minutes "$send")
        if (( start_min < existing_end && end_min > existing_start )); then
            conflicts=1
            echo "⚠️  Conflict detected with: [$slabel] $sstart-$send"
        fi
    done < "$SLOT_FILE"

    if (( conflicts )); then
        echo ""
        echo "⚠️  Creating slot despite conflict(s). Use check-conflict to review."
    fi

    echo "$id,$date_str,$start_time,$end_time,$label,$category,$created_at" >> "$SLOT_FILE"

    cat <<EOF
═══════════════════════════════════════════════════
  ✅ Slot Created
═══════════════════════════════════════════════════

  ID:        $id
  Date:      $date_str
  Time:      $start_time — $end_time (${duration} min)
  Label:     $label
  Category:  $category
  Created:   $created_at

  Stored in: $SLOT_FILE

📖 More skills: bytesagain.com
EOF
}

cmd_list() {
    local from_date="${1:-}"
    local to_date="${2:-}"

    ensure_data_dir

    local total=0
    local total_minutes=0

    echo "═══════════════════════════════════════════════════"
    echo "  📅 Scheduled Time Slots"
    echo "═══════════════════════════════════════════════════"
    echo ""

    if [ ! -s "$SLOT_FILE" ] || [ "$(wc -l < "$SLOT_FILE")" -le 1 ]; then
        echo "  (No slots found. Use 'create' to add one.)"
        echo ""
        echo "📖 More skills: bytesagain.com"
        return 0
    fi

    printf "  %-8s  %-12s  %-6s  %-6s  %-5s  %-10s  %s\n" \
           "ID" "Date" "Start" "End" "Min" "Category" "Label"
    echo "  ─────────────────────────────────────────────────────────────────────"

    while IFS=',' read -r sid sdate sstart send slabel scat screated; do
        [ "$sid" = "id" ] && continue

        # Date range filtering
        if [ -n "$from_date" ] && [[ "$sdate" < "$from_date" ]]; then
            continue
        fi
        if [ -n "$to_date" ] && [[ "$sdate" > "$to_date" ]]; then
            continue
        fi

        local start_min end_min duration
        start_min=$(time_to_minutes "$sstart")
        end_min=$(time_to_minutes "$send")
        duration=$(( end_min - start_min ))
        total_minutes=$(( total_minutes + duration ))
        total=$(( total + 1 ))

        printf "  %-8s  %-12s  %-6s  %-6s  %3dm   %-10s  %s\n" \
               "$sid" "$sdate" "$sstart" "$send" "$duration" "$scat" "$slabel"
    done < "$SLOT_FILE"

    echo ""
    echo "  Total: $total slots, $(( total_minutes / 60 ))h $((total_minutes % 60))m scheduled"
    if [ -n "$from_date" ]; then
        echo "  Filter: $from_date → ${to_date:-now}"
    fi
    echo ""
    echo "📖 More skills: bytesagain.com"
}

cmd_check_conflict() {
    local date_str="${1:-}"
    local start_time="${2:-}"
    local end_time="${3:-}"

    if [ -z "$date_str" ] || [ -z "$start_time" ] || [ -z "$end_time" ]; then
        cat <<'EOF'
═══════════════════════════════════════════════════
  Check Schedule Conflicts
═══════════════════════════════════════════════════

Usage:
  bash scripts/script.sh check-conflict <date> <start> <end>

Examples:
  bash scripts/script.sh check-conflict "2024-03-15" "09:30" "10:00"
  bash scripts/script.sh check-conflict "2024-03-15" "14:00" "16:00"

Conflict Types:
  🔴 Full Overlap    — Proposed slot entirely within existing
  🟠 Partial Overlap — Start or end falls within existing slot
  🟡 Enclosing       — Proposed slot contains an existing slot
  🟢 Adjacent        — Slots touch but don't overlap (no conflict)

📖 More skills: bytesagain.com
EOF
        return 0
    fi

    ensure_data_dir
    validate_date "$date_str" || return 1
    validate_time "$start_time" || return 1
    validate_time "$end_time" || return 1

    local new_start new_end
    new_start=$(time_to_minutes "$start_time")
    new_end=$(time_to_minutes "$end_time")

    echo "═══════════════════════════════════════════════════"
    echo "  🔍 Conflict Check: $date_str $start_time—$end_time"
    echo "═══════════════════════════════════════════════════"
    echo ""

    local conflicts=0
    while IFS=',' read -r sid sdate sstart send slabel scat screated; do
        [ "$sid" = "id" ] && continue
        [ "$sdate" != "$date_str" ] && continue

        local ex_start ex_end
        ex_start=$(time_to_minutes "$sstart")
        ex_end=$(time_to_minutes "$send")

        if (( new_start < ex_end && new_end > ex_start )); then
            conflicts=$(( conflicts + 1 ))

            local ctype
            if (( new_start >= ex_start && new_end <= ex_end )); then
                ctype="🔴 Full Overlap"
            elif (( new_start <= ex_start && new_end >= ex_end )); then
                ctype="🟡 Enclosing"
            else
                ctype="🟠 Partial Overlap"
            fi

            local overlap_start=$(( new_start > ex_start ? new_start : ex_start ))
            local overlap_end=$(( new_end < ex_end ? new_end : ex_end ))
            local overlap_min=$(( overlap_end - overlap_start ))

            echo "  $ctype with [$slabel]"
            echo "    Existing:  $sstart — $send"
            echo "    Overlap:   $(minutes_to_time $overlap_start) — $(minutes_to_time $overlap_end) (${overlap_min}m)"
            echo ""
        fi
    done < "$SLOT_FILE"

    if (( conflicts == 0 )); then
        echo "  ✅ No conflicts found! Time slot is available."
    else
        echo "  ⚠️  Found $conflicts conflict(s)."
    fi
    echo ""
    echo "📖 More skills: bytesagain.com"
}

cmd_export() {
    local format="${1:-ics}"

    ensure_data_dir

    case "$format" in
        ics|ical)
            local outfile="${SLOT_DIR}/slots.ics"
            {
                echo "BEGIN:VCALENDAR"
                echo "VERSION:2.0"
                echo "PRODID:-//BytesAgain//Slot Manager//EN"
                echo "CALSCALE:GREGORIAN"
                echo "METHOD:PUBLISH"

                while IFS=',' read -r sid sdate sstart send slabel scat screated; do
                    [ "$sid" = "id" ] && continue
                    local dnum="${sdate//-/}"
                    local snum="${sstart/:/}00"
                    local enum="${send/:/}00"
                    echo "BEGIN:VEVENT"
                    echo "UID:${sid}@slot-manager"
                    echo "DTSTART:${dnum}T${snum}"
                    echo "DTEND:${dnum}T${enum}"
                    echo "SUMMARY:${slabel}"
                    echo "CATEGORIES:${scat}"
                    echo "DESCRIPTION:Created by Slot Manager v${VERSION}"
                    echo "END:VEVENT"
                done < "$SLOT_FILE"

                echo "END:VCALENDAR"
            } > "$outfile"

            echo "═══════════════════════════════════════════════════"
            echo "  📤 Export — iCalendar (.ics)"
            echo "═══════════════════════════════════════════════════"
            echo ""
            echo "  ✅ Exported to: $outfile"
            echo "  Format: iCalendar 2.0 (RFC 5545)"
            echo ""
            echo "  Import into:"
            echo "    • Google Calendar → Settings → Import"
            echo "    • Apple Calendar  → File → Import"
            echo "    • Outlook         → File → Open & Export"
            echo ""
            echo "📖 More skills: bytesagain.com"
            ;;
        csv)
            local outfile="${SLOT_DIR}/slots_export.csv"
            cp "$SLOT_FILE" "$outfile"

            echo "═══════════════════════════════════════════════════"
            echo "  📤 Export — CSV"
            echo "═══════════════════════════════════════════════════"
            echo ""
            echo "  ✅ Exported to: $outfile"
            echo "  Columns: id, date, start, end, label, category, created_at"
            echo ""
            echo "  Open with: Excel, Google Sheets, LibreOffice Calc"
            echo ""
            echo "📖 More skills: bytesagain.com"
            ;;
        *)
            echo "❌ Unknown format: $format"
            echo "Supported: ics, csv"
            echo ""
            echo "📖 More skills: bytesagain.com"
            ;;
    esac
}

cmd_templates() {
    local template="${1:-}"

    if [ -z "$template" ]; then
        cat <<'EOF'
═══════════════════════════════════════════════════
  📋 Scheduling Templates
═══════════════════════════════════════════════════

【Available Templates】

  pomodoro       4 × 25-min focus + 5-min breaks, then 15-min long break
  work-day       Standard 9-5 with lunch break and focus blocks
  meeting-day    Back-to-back meeting blocks with buffer time
  deep-work      Cal Newport-style: 2 × 90-min deep work blocks
  interview      Interview day: prep, sessions, debrief
  school         Class periods with passing time

Usage:
  bash scripts/script.sh templates <name>
  bash scripts/script.sh templates pomodoro

Template Structure:
  Each template defines time blocks relative to a start time.
  Blocks include: label, duration, category, and break indicators.

【Template Design Principles】
  • Every focus block has a matched break
  • Buffer time between meetings (min 5 min)
  • Longest unbroken focus: 90 minutes
  • Lunch minimum: 30 minutes
  • Context-switch cost: add 10-min transition blocks

📖 More skills: bytesagain.com
EOF
        return 0
    fi

    case "$template" in
        pomodoro)
            cat <<'EOF'
═══════════════════════════════════════════════════
  🍅 Pomodoro Template
═══════════════════════════════════════════════════

  Cycle: 4 pomodoros + 1 long break = ~2h 25m

  Block 1:  00:00 — 00:25  Focus Session #1        [focus]
  Break 1:  00:25 — 00:30  Short Break             [break]
  Block 2:  00:30 — 00:55  Focus Session #2        [focus]
  Break 2:  00:55 — 01:00  Short Break             [break]
  Block 3:  01:00 — 01:25  Focus Session #3        [focus]
  Break 3:  01:25 — 01:30  Short Break             [break]
  Block 4:  01:30 — 01:55  Focus Session #4        [focus]
  Break 4:  01:55 — 02:10  Long Break (15 min)     [break]

  Total Focus: 100 min | Total Break: 30 min
  Recommended: 2–3 cycles per day

  Tips:
  • During focus: no email, no chat, phone silent
  • During short break: stretch, water, look away
  • During long break: walk, snack, real rest
  • Track completed pomodoros for productivity metrics

📖 More skills: bytesagain.com
EOF
            ;;
        work-day)
            cat <<'EOF'
═══════════════════════════════════════════════════
  💼 Standard Work Day Template
═══════════════════════════════════════════════════

  08:30 — 09:00  Morning Planning & Review       [admin]
  09:00 — 10:30  Deep Work Block #1              [focus]
  10:30 — 10:45  Break                           [break]
  10:45 — 11:30  Meetings / Collaboration        [meeting]
  11:30 — 12:00  Email & Communications          [admin]
  12:00 — 13:00  Lunch                           [break]
  13:00 — 14:30  Deep Work Block #2              [focus]
  14:30 — 14:45  Break                           [break]
  14:45 — 16:00  Meetings / Collaboration        [meeting]
  16:00 — 16:30  Admin & Follow-ups              [admin]
  16:30 — 17:00  Daily Review & Tomorrow Prep    [admin]

  Focus Time: 3h | Meeting Time: 2h 45m
  Admin: 1h 30m | Breaks: 1h 15m

📖 More skills: bytesagain.com
EOF
            ;;
        deep-work)
            cat <<'EOF'
═══════════════════════════════════════════════════
  🧠 Deep Work Template (Cal Newport)
═══════════════════════════════════════════════════

  08:00 — 08:15  Warm-up & Intention Setting     [admin]
  08:15 — 09:45  Deep Work Session #1 (90 min)   [focus]
  09:45 — 10:15  Recovery Break                  [break]
  10:15 — 11:45  Deep Work Session #2 (90 min)   [focus]
  11:45 — 13:00  Lunch & Shallow Work            [break]
  13:00 — 14:00  Email, Meetings, Admin          [admin]
  14:00 — 15:30  Deep Work Session #3 (90 min)   [focus]
  15:30 — 16:00  Recovery Break                  [break]
  16:00 — 17:00  Shutdown Routine & Review       [admin]

  Deep Focus: 4h 30m (3 × 90-min blocks)
  Max cognitive output per day

  Rules:
  • Zero notifications during deep work
  • Pre-commit: what will you produce this session?
  • Shutdown ritual: review, plan tomorrow, close loops

📖 More skills: bytesagain.com
EOF
            ;;
        *)
            echo "❌ Unknown template: $template"
            echo "Available: pomodoro, work-day, deep-work, meeting-day, interview, school"
            echo ""
            echo "📖 More skills: bytesagain.com"
            ;;
    esac
}

cmd_help() {
    cat <<EOF
Slot v${VERSION} — Time Slot & Schedule Block Manager

Commands:
  create <date> <start> <end> [label] [category]
                         Create a new time slot
  list [from] [to]       List slots, optionally filtered by date range
  check-conflict <date> <start> <end>
                         Check for scheduling conflicts
  export <ics|csv>       Export slots to iCal or CSV
  templates [name]       Show or apply scheduling templates
  help                   Show this help
  version                Show version

Usage:
  bash scripts/script.sh create "2024-03-15" "09:00" "10:30" "Standup" "meeting"
  bash scripts/script.sh list "2024-03-15" "2024-03-22"
  bash scripts/script.sh check-conflict "2024-03-15" "09:30" "10:00"
  bash scripts/script.sh export ics
  bash scripts/script.sh templates pomodoro

Related skills:
  clawhub install cal
  clawhub install pomodoro
Browse all: bytesagain.com

Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    create)          shift; cmd_create "$@" ;;
    list)            shift; cmd_list "$@" ;;
    check-conflict)  shift; cmd_check_conflict "$@" ;;
    export)          shift; cmd_export "$@" ;;
    templates)       shift; cmd_templates "$@" ;;
    version)         echo "slot v${VERSION}" ;;
    help|*)          cmd_help ;;
esac
