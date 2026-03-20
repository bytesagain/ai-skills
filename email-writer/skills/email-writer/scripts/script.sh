#!/usr/bin/env bash
# email-writer — Professional email drafting for business, sales, and personal
set -euo pipefail
VERSION="2.0.0"
DATA_DIR="${EMAIL_WRITER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/email-writer}"
DB="$DATA_DIR/entries.jsonl"
mkdir -p "$DATA_DIR"

show_help() {
    cat << EOF
email-writer v$VERSION — Professional email composer

Usage: email-writer <command> [args]

Compose:
  write <type> <to> <subject>   Draft an email (formal/casual/sales/follow-up)
  reply <tone> <context>        Draft a reply
  cold <product> <recipient>    Cold outreach email
  follow-up <context> <n>       Follow-up sequence (n emails)
  intro <person1> <person2>     Introduction email

Templates:
  meeting <topic> <time>        Meeting request
  thank-you <context>           Thank you note
  apology <context>             Professional apology
  decline <context>             Politely decline
  resign <company>              Resignation letter

Polish:
  subject <topic> [n]           Subject line generator
  tone <draft> <target-tone>    Adjust tone
  shorten <draft>               Make concise
  checklist                     Pre-send checklist
  help                          Show this help
EOF
}

cmd_write() {
    local type="${1:-formal}"
    local to="${2:-Recipient}"
    local subject="${3:-Subject}"
    echo "  ═══ Email Draft ($type) ═══"
    echo ""
    case "$type" in
        formal)
            echo "  Subject: $subject"
            echo "  To: $to"
            echo ""
            echo "  Dear $to,"
            echo ""
            echo "  I hope this email finds you well. I am writing to [purpose]."
            echo ""
            echo "  [Body paragraph 1: Context and background]"
            echo ""
            echo "  [Body paragraph 2: Key details or request]"
            echo ""
            echo "  [Body paragraph 3: Next steps or call to action]"
            echo ""
            echo "  Thank you for your time and consideration."
            echo ""
            echo "  Best regards,"
            echo "  [Your name]" ;;
        casual)
            echo "  Subject: $subject"
            echo ""
            echo "  Hey $to,"
            echo ""
            echo "  Quick note about [topic]. [Main point in 2-3 sentences]."
            echo ""
            echo "  Let me know what you think!"
            echo ""
            echo "  Cheers,"
            echo "  [Your name]" ;;
        sales)
            echo "  Subject: $subject"
            echo ""
            echo "  Hi $to,"
            echo ""
            echo "  I noticed [specific observation about them/their company]."
            echo ""
            echo "  We help [target audience] achieve [specific result]."
            echo "  [Social proof: X companies use us / Y% improvement]"
            echo ""
            echo "  Would you be open to a quick 15-min call this week?"
            echo ""
            echo "  Best,"
            echo "  [Your name]" ;;
        follow-up|followup)
            echo "  Subject: Re: $subject"
            echo ""
            echo "  Hi $to,"
            echo ""
            echo "  Just following up on my previous email about [topic]."
            echo "  I wanted to check if you had a chance to review it."
            echo ""
            echo "  Happy to provide any additional information."
            echo ""
            echo "  Best,"
            echo "  [Your name]" ;;
        *) echo "  Types: formal, casual, sales, follow-up" ;;
    esac
    _log "write" "$type to $to"
}

cmd_cold() {
    local product="${1:?Usage: email-writer cold <product> <recipient>}"
    local recipient="${2:-there}"
    echo "  ═══ Cold Outreach: $product ═══"
    echo ""
    echo "  Subject: Quick question about [their specific challenge]"
    echo ""
    echo "  Hi $recipient,"
    echo ""
    echo "  [1 sentence about their company/role - show you did research]"
    echo ""
    echo "  I am reaching out because $product helps [target audience]"
    echo "  [specific measurable result]. For example, [case study]."
    echo ""
    echo "  Would it make sense to chat for 15 minutes this week?"
    echo ""
    echo "  [Your name]"
    echo "  P.S. [Soft CTA or interesting stat]"
}

cmd_subject() {
    local topic="${1:?}"
    local n="${2:-5}"
    echo "  ═══ Subject Lines: $topic ═══"
    echo "  1. Quick question about $topic"
    echo "  2. $topic — action needed by [date]"
    echo "  3. Thoughts on $topic?"
    echo "  4. Following up: $topic"
    echo "  5. [Name], re: $topic"
    echo ""
    echo "  Tips: Keep under 50 chars, personalize, avoid spam words"
}

cmd_meeting() {
    local topic="${1:?}"
    local time="${2:-this week}"
    echo "  ═══ Meeting Request ═══"
    echo ""
    echo "  Subject: Meeting request: $topic"
    echo ""
    echo "  Hi [Name],"
    echo ""
    echo "  I would like to schedule a meeting to discuss $topic."
    echo ""
    echo "  Proposed time: $time"
    echo "  Duration: 30 minutes"
    echo "  Location: [Zoom/Office/TBD]"
    echo ""
    echo "  Agenda:"
    echo "  1. [Item 1]"
    echo "  2. [Item 2]"
    echo "  3. Next steps"
    echo ""
    echo "  Please let me know if this works for you."
}

cmd_checklist() {
    echo "  ═══ Pre-Send Checklist ═══"
    echo "  [ ] Correct recipient(s)?"
    echo "  [ ] Subject line clear and specific?"
    echo "  [ ] Greeting appropriate for relationship?"
    echo "  [ ] Purpose stated in first 2 sentences?"
    echo "  [ ] One clear call to action?"
    echo "  [ ] Proofread for typos?"
    echo "  [ ] Attachments actually attached?"
    echo "  [ ] Reply-all not needed?"
    echo "  [ ] Tone matches context?"
    echo "  [ ] Would you be okay if this was forwarded?"
}

cmd_decline() {
    echo "  ═══ Polite Decline ═══"
    echo ""
    echo "  Hi [Name],"
    echo ""
    echo "  Thank you for thinking of me regarding [topic]."
    echo ""
    echo "  Unfortunately, I am unable to [commit/attend/participate]"
    echo "  at this time due to [brief reason]."
    echo ""
    echo "  I appreciate the opportunity and wish you the best."
    echo ""
    echo "  Best regards,"
    echo "  [Your name]"
}

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

case "${{1:-help}}" in
    write) shift; cmd_write "$@" ;;
    cold) shift; cmd_cold "$@" ;;
    subject) shift; cmd_subject "$@" ;;
    meeting) shift; cmd_meeting "$@" ;;
    checklist) shift; cmd_checklist "$@" ;;
    decline) shift; cmd_decline "$@" ;;
    help|-h) show_help ;;
    version|-v) echo "email-writer v$VERSION" ;;
    *) echo "Unknown: $1"; show_help; exit 1 ;;
esac
