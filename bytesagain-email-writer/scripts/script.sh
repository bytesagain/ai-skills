#!/usr/bin/env bash
# bytesagain-email-writer — Email writing assistant
set -euo pipefail

CMD="${1:-help}"
shift || true

show_help() {
    echo "bytesagain-email-writer — Professional email templates and writing assistant"
    echo ""
    echo "Usage:"
    echo "  bytesagain-email-writer cold <name> <company> <goal>    Cold outreach"
    echo "  bytesagain-email-writer followup <context> <days>       Follow-up email"
    echo "  bytesagain-email-writer apology <issue> <audience>      Apology email"
    echo "  bytesagain-email-writer intro <your_name> <their_name>  Introduction"
    echo "  bytesagain-email-writer decline <request>               Polite decline"
    echo "  bytesagain-email-writer subject <topic> <goal>          Subject line ideas"
    echo ""
}

cmd_cold() {
    local name="${1:-Contact}"; local company="${2:-Company}"; local goal="${3:-connect}"
    python3 << 'PYEOF'
name="$name"; company="$company"; goal="$goal"
print(f"""
=== Cold Outreach Email: {name} @ {company} ===

Subject: Quick question about {company}'s [specific topic]

Hi {name},

I noticed [specific thing about their work/company] — [genuine compliment or observation].

I'm reaching out because [specific reason you're contacting them, not generic].

[One sentence on who you are and why it's relevant].

I'd love to [specific small ask — 15-min call / get your thoughts / share something].

Would [specific day/time option] work, or is there a better time?

[Your name]
[Title] | [Company]
[One-line value prop]

---
Tips for this email:
• Research them first: LinkedIn, recent articles, company news
• Personalize the opening — generic = ignored
• One ask only, make it tiny (15 min, not "pick your brain")
• Short subject: question or specific topic works best
• Best send time: Tue-Thu, 8-9am or 3-4pm their timezone
""")
PYEOF
}

cmd_followup() {
    local context="${1:-our last conversation}"; local days="${2:-3}"
    python3 << 'PYEOF'
context="$context"; days="$days"
print(f"""
=== Follow-up Email ({days} days later) ===

Subject: Re: [Original subject] — following up

Hi [Name],

Just wanted to follow up on {context}.

[One sentence recap of where things stood]

[Gentle value add or new information — not just "checking in"]

Happy to [make it easier for them — answer questions, send more info, schedule a call].

[Name]

---
Version B (more direct):
Subject: Still interested in [topic]?

Hi [Name],

I know things get busy. Just wanted to make sure [previous email] didn't get buried.

[Restate the value/offer in one sentence]

Worth a quick reply?

[Name]

---
Follow-up cadence:
Day 0: First email
Day {days}: This follow-up (bump, add value)
Day {int(days)*3}: Final follow-up ("closing the loop")
After that: Move on — stay in touch quarterly
""")
PYEOF
}

cmd_apology() {
    local issue="${1:-the issue}"; local audience="${2:-customer}"
    python3 << 'PYEOF'
issue="$issue"; audience="$audience"
print(f"""
=== Apology Email: {issue} ===
Audience: {audience}

Subject: We're sorry about {issue} — here's what we're doing

Hi [Name / Team / valued {audience}],

We want to address {issue} directly.

[What happened — factual, no excuses]
On [date], [describe what went wrong clearly and honestly].

[The impact]
We understand this [inconvenienced you / caused disruption / wasn't acceptable].

[What we're doing about it]
Here's what we've done / are doing:
• [Immediate action taken]
• [Prevention measure going forward]
• [How we'll make it right for you]

[Make it right]
As a result, we're [specific remedy: refund/credit/extension/etc.].

[Commitment]
This isn't the standard we hold ourselves to. You have our commitment to [specific improvement].

If you have questions or concerns, please reply directly to this email.

[Name]
[Title], [Company]

---
Apology email rules:
✅ Say "I'm sorry" / "We're sorry" — not "I'm sorry you feel that way"
✅ Take clear responsibility
✅ Explain what happened (briefly, no excuses)
✅ State what you're doing to fix it
✅ Offer concrete remedy
❌ Don't over-apologize or be defensive
❌ Don't promise things you can't deliver
""")
PYEOF
}

cmd_intro() {
    local your_name="${1:-Your Name}"; local their_name="${2:-Their Name}"
    python3 << 'PYEOF'
your_name="$your_name"; their_name="$their_name"
print(f"""
=== Introduction Email ===

--- Self-introduction ---
Subject: Introduction — {your_name}

Hi {their_name},

I'm {your_name}, [role] at [company/context].

I [one sentence on what you do and why it might be relevant to them].

[Why you're reaching out specifically — reference any connection or context].

Looking forward to connecting.

{your_name}
[Contact / LinkedIn]

--- Introducing two people ---
Subject: Introduction: {your_name} ↔ {their_name}

Hi both,

I'm making a quick intro and then stepping out.

{your_name}: {their_name} is [brief description + why relevant].
{their_name}: {your_name} is [brief description + why relevant].

You two should [specific reason they'd benefit from talking].

I'll let you take it from here!

[Your name]

--- Tips ---
• Keep it under 150 words
• State the "why you" clearly
• Make it easy to respond with a simple yes/no
""")
PYEOF
}

cmd_decline() {
    local request="${1:-the request}"
    python3 << 'PYEOF'
request="$request"
print(f"""
=== Polite Decline Email ===

Subject: Re: [Original subject]

Hi [Name],

Thank you for reaching out about {request}.

After careful consideration, I'm not able to [accept/participate/help with this] at this time.

[Optional: brief reason without over-explaining]
[My current commitments / This isn't within my expertise / Timing doesn't work right now]

I appreciate you thinking of me, and I hope you find the right [person/solution/fit].

Best,
[Name]

---
Version B (with alternative):
I won't be able to take this on, but [Name] at [Company] might be a great fit — they specialize in [relevant area].

---
Version C (delay, not decline):
I'm fully committed until [date]. If this is still relevant then, I'd love to revisit.

---
Tips:
• Decline promptly — delay wastes their time
• Be clear: "I can't" not "I might be able to"
• Offer alternative if possible — adds value anyway
• No need to over-explain — brief is kinder
""")
PYEOF
}

cmd_subject() {
    local topic="${1:-topic}"; local goal="${2:-open}"
    python3 << 'PYEOF'
topic="$topic"; goal="$goal"
formulas = {
    "open": [
        f"Quick question about {topic}",
        f"Have you tried this with {topic}?",
        f"Re: {topic} (3-min read)",
        f"Honest take on {topic}",
        f"[First name], your {topic} question",
    ],
    "convert": [
        f"{topic}: last chance this month",
        f"Your {topic} results are ready",
        f"[Name], don't miss the {topic} deadline",
        f"[X]% off {topic} — today only",
        f"The {topic} offer expires tonight",
    ],
    "engage": [
        f"We messed up the {topic} — here's what happened",
        f"Unpopular opinion about {topic}",
        f"The {topic} mistake 90% of people make",
        f"I was wrong about {topic}",
        f"What nobody tells you about {topic}",
    ],
}
lines = formulas.get(goal, formulas["open"])
print(f"\n=== Subject Line Ideas: {topic} (goal: {goal}) ===\n")
for i, s in enumerate(lines, 1):
    est_open = [45, 38, 42, 35, 50][i-1]
    print(f"  {i}. {s}")
    print(f"     Est. open rate: ~{est_open}% | {len(s)} chars")
    print()
print(f"Goals: open (curiosity), convert (urgency), engage (emotion)")
PYEOF
}

case "$CMD" in
    cold)     cmd_cold "$@" ;;
    followup) cmd_followup "$@" ;;
    apology)  cmd_apology "$@" ;;
    intro)    cmd_intro "$@" ;;
    decline)  cmd_decline "$@" ;;
    subject)  cmd_subject "$@" ;;
    help|--help|-h) show_help ;;
    *) echo "Unknown: $CMD"; show_help; exit 1 ;;
esac
