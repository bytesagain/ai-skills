#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
RECIPES=[("Gmail to Slack","Trigger: New email in Gmail\nAction: Post message to Slack channel","Email notification, team updates"),("Form to Sheet","Trigger: New form submission (Typeform/Google Forms)\nAction: Create row in Google Sheets","Lead capture, surveys"),("Calendar to Todoist","Trigger: New Google Calendar event\nAction: Create task in Todoist","Meeting prep automation"),("Stripe to Email","Trigger: New payment in Stripe\nAction: Send thank you email","Customer onboarding"),("GitHub to Slack","Trigger: New PR/Issue on GitHub\nAction: Post to Slack dev channel","Dev team notifications"),("RSS to Twitter","Trigger: New RSS feed item\nAction: Create tweet","Content distribution"),("Notion to Email","Trigger: New item in Notion database\nAction: Send digest email","Project updates"),("Webhook to Sheets","Trigger: Catch webhook\nAction: Log to Google Sheets","API monitoring, logging")]
if cmd=="browse":
    cat=inp.lower() if inp else ""
    print("  Popular Zap Recipes:")
    for i,(name,flow,use) in enumerate(RECIPES,1):
        if cat and cat not in name.lower() and cat not in use.lower(): continue
        print("\n  {}. {}".format(i,name))
        for line in flow.split("\n"): print("     {}".format(line.strip()))
        print("     Use: {}".format(use))
elif cmd=="custom":
    print("  Build Custom Zap:")
    print("  1. TRIGGER: When ___ happens in [App]")
    print("  2. FILTER: Only if [condition]")
    print("  3. ACTION: Do ___ in [App]")
    print("  4. (Optional) ACTION 2: Also do ___ in [App]")
    print("")
    print("  Popular triggers: New email, New row, Webhook, Schedule, New file")
    print("  Popular actions: Send email, Create row, Post message, Create task")
elif cmd=="help":
    print("Zapier Recipe Book\n  browse [keyword]  — Browse automation recipes\n  custom             — Build custom zap template")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT