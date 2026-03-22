#!/usr/bin/env bash
# goal — Goal Setting & Achievement Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Goal Setting Fundamentals ===

Why Goals Work (Locke & Latham, 2002 — 35 years of research):
  1. Goals direct attention and effort toward relevant activities
  2. Goals energize — higher goals lead to greater effort
  3. Goals affect persistence — clear targets increase endurance
  4. Goals activate cognitive knowledge and strategies

Key Findings:
  - Specific, difficult goals outperform "do your best" by 20-25%
  - Written goals are 42% more likely to be achieved (Matthews, 2015)
  - Public commitment increases follow-through
  - Progress tracking doubles success rate

Goal Hierarchy:
  Vision        "What does my ideal life look like?" (5-10 years)
  Mission       "What am I here to do?" (purpose statement)
  Goals         "What will I achieve?" (1-3 years)
  Milestones    "What are the major checkpoints?" (quarterly)
  Projects      "What must I build/do?" (monthly)
  Actions       "What do I do today?" (daily/weekly)

Types of Goals:
  Outcome goals    End result ("lose 20 lbs") — motivating but less controllable
  Performance goals Benchmark ("run 5K in 25 min") — measurable progress
  Process goals    Daily actions ("run 3x/week") — most controllable
  Best practice: Set outcome goal, measure performance, focus on process

The 3 Domains of Life Goals:
  Health & Vitality    Body, energy, longevity, mental health
  Relationships        Family, friends, community, love
  Work & Contribution  Career, skills, impact, wealth
  Balance across all three — success in one doesn't compensate for neglect in others
EOF
}

cmd_smart() {
    cat << 'EOF'
=== SMART Goals Framework ===

S — Specific
  Who, what, where, when, why?
  Bad:  "Get in shape"
  Good: "Complete a half marathon in my city"

M — Measurable
  How will you know you've achieved it?
  Bad:  "Save more money"
  Good: "Save $10,000 in emergency fund"

A — Achievable (but challenging)
  Stretch enough to grow, realistic enough to believe
  Bad:  "Become fluent in 5 languages this year"
  Good: "Reach B2 conversational level in Spanish by December"

R — Relevant
  Aligned with your values and larger life goals
  Ask: "If I achieve this, will it actually matter to me?"
  Ask: "Is this MY goal, or someone else's expectation?"

T — Time-bound
  Clear deadline creates urgency and enables planning
  Bad:  "Eventually learn to code"
  Good: "Build and deploy a portfolio website by March 31"

SMART EXAMPLES:

  Health:
    "Run 3 times per week for 30 minutes, increasing to 5K
     distance by June 1, tracking runs in Strava."

  Career:
    "Earn AWS Solutions Architect certification by Q2 2025,
     studying 1 hour per weekday, using official practice exams."

  Financial:
    "Reduce monthly discretionary spending by 20% ($400)
     starting February 1, tracking in YNAB budget app."

  Relationship:
    "Have a weekly 1-hour date night with partner every
     Friday, phone-free, trying a new restaurant monthly."

BEYOND SMART — Add:
  E — Evaluated (regularly check progress)
  R — Revised (adjust based on learning)
  → SMARTER goals adapt to reality
EOF
}

cmd_okr() {
    cat << 'EOF'
=== OKR Framework (Objectives & Key Results) ===

Origin: Andy Grove at Intel, popularized by John Doerr at Google.
Used by: Google, LinkedIn, Twitter, Spotify, Airbnb, and thousands more.

STRUCTURE:
  Objective:  Qualitative, inspiring, action-oriented
              "What do I want to accomplish?"
  Key Results: Quantitative, measurable, verifiable
              "How will I know I got there?" (2-5 per objective)

RULES:
  - Set 3-5 objectives per quarter (focus!)
  - Each objective has 2-5 key results
  - Key results must be measurable (number, %, date)
  - Stretch: aim for 60-70% achievement (aspirational OKRs)
  - Score: 0.0 to 1.0 (0.7 = target for stretch OKRs)
  - OKRs are NOT performance reviews (safe to stretch and fail)

EXAMPLE — Personal:
  Objective: Become a stronger software engineer
  KR1: Complete 3 system design case studies with written analysis
  KR2: Contribute 5 merged PRs to an open-source project
  KR3: Score 90%+ on AWS Solutions Architect practice exam
  KR4: Mentor 1 junior developer for 12 weeks

EXAMPLE — Team:
  Objective: Delight our customers with faster support
  KR1: Reduce average first-response time from 4h to 1h
  KR2: Achieve 95% customer satisfaction score (currently 82%)
  KR3: Resolve 80% of tickets on first contact (currently 60%)
  KR4: Launch self-service knowledge base with 50 articles

CADENCE:
  Annual:     Company/personal vision OKRs (directional)
  Quarterly:  Primary OKR cycle (set → execute → score)
  Weekly:     Check-in on KR progress, adjust tactics
  End of Q:   Score, reflect, set next quarter's OKRs

ALIGNMENT:
  Company OKRs → Department OKRs → Team OKRs → Individual OKRs
  Not top-down cascade! ~60% bottom-up + ~40% top-down
  Alignment = connected goals, not micromanagement

SCORING:
  0.0-0.3  Red — failed to make significant progress
  0.4-0.6  Yellow — progress but fell short
  0.7-1.0  Green — strong delivery
  Consistent 1.0 scores? Your OKRs aren't ambitious enough.
EOF
}

cmd_habits() {
    cat << 'EOF'
=== Habit Formation Science ===

THE HABIT LOOP (Charles Duhigg / BJ Fogg):
  Cue → Routine → Reward → Repeat

  Cue:     Trigger that initiates behavior
           Time, location, preceding event, emotional state, other people
  Routine: The behavior itself (what you do)
  Reward:  Satisfaction that reinforces the loop
           Intrinsic (pride) or extrinsic (treat)

ATOMIC HABITS (James Clear) — 4 Laws:
  1. Make it Obvious     (Cue)
     - Implementation intention: "I will [BEHAVIOR] at [TIME] in [LOCATION]"
     - Habit stacking: "After I [CURRENT HABIT], I will [NEW HABIT]"
     - Environment design: put cues in visible places

  2. Make it Attractive   (Craving)
     - Temptation bundling: pair habit with something you enjoy
     - Join a culture where the behavior is normal
     - Reframe: "I GET to" instead of "I HAVE to"

  3. Make it Easy         (Response)
     - Two-Minute Rule: start with just 2 minutes
     - Reduce friction: lay out gym clothes the night before
     - Pre-commitment: automate, schedule, remove choices

  4. Make it Satisfying   (Reward)
     - Immediate reward after the habit
     - Habit tracking (visual progress — "don't break the chain")
     - Never miss twice (one miss is an accident, two is a new habit)

HABIT FORMATION TIMELINE:
  Research (Lally et al., 2010): Average 66 days to automaticity
  Range: 18-254 days depending on complexity
  Simple (drink water): ~20 days
  Moderate (exercise): ~66 days
  Complex (meditation): ~100+ days

KEYSTONE HABITS:
  Habits that trigger positive cascading changes:
    Exercise     → better sleep → better mood → better eating
    Journaling   → self-awareness → better decisions → growth
    Making bed   → sense of order → productivity → discipline

BREAKING BAD HABITS (Invert the 4 Laws):
  1. Make it Invisible    Remove cues (hide phone, uninstall apps)
  2. Make it Unattractive Highlight negative consequences
  3. Make it Difficult    Increase friction (website blockers, lock boxes)
  4. Make it Unsatisfying Accountability partner, commitment contracts
EOF
}

cmd_planning() {
    cat << 'EOF'
=== Goal Decomposition & Planning ===

BACKWARD PLANNING (Start from the End):
  1. Define the goal with deadline
  2. Identify the final milestone before completion
  3. Work backward: what must happen before that?
  4. Continue until you reach today
  5. You now have a reverse-engineered action plan

Example:
  Goal: "Launch SaaS product by December 1"
  Nov: Beta testing with 20 users → fix critical bugs
  Oct: Build MVP with core features → deploy to staging
  Sep: Design system architecture → set up CI/CD
  Aug: Customer interviews → validate problem → define MVP scope
  Jul: Market research → competitor analysis → positioning
  Today: Schedule 5 customer interview calls this week

MILESTONE FRAMEWORK:
  Break annual goals into quarterly milestones
  Break quarterly milestones into monthly targets
  Break monthly targets into weekly sprints
  Break weekly sprints into daily actions

  Example:
    Annual:    Save $12,000
    Quarterly: Save $3,000
    Monthly:   Save $1,000
    Weekly:    Save $250
    Daily:     Bring lunch ($10 savings), skip coffee ($5)

THE 12-WEEK YEAR (Brian Moran):
  Treat 12 weeks like a full year
  Benefits:
    - Urgency: every week is a "month"
    - Focus: only 2-3 goals per 12-week cycle
    - Scoring: measure weekly execution against plan
    - Reset: fresh start every 12 weeks

  Weekly execution score = (completed actions / planned actions) × 100
  Target: 85%+ weekly execution score

TIME BLOCKING FOR GOALS:
  Calendar your goal-related activities as appointments
  "What gets scheduled gets done"

  Morning block:    Deep work on #1 goal (before distractions)
  Midday block:     Learning/skill development
  Evening block:    Review, planning, reflection

  Protect these blocks like meetings with your boss.

MINIMUM VIABLE PROGRESS:
  On bad days, do the minimum to maintain momentum:
  - Exercise goal? Do 5 pushups (not zero)
  - Writing goal? Write one sentence
  - Study goal? Review one flashcard
  The habit of showing up matters more than the amount.
EOF
}

cmd_motivation() {
    cat << 'EOF'
=== Motivation Science ===

SELF-DETERMINATION THEORY (Deci & Ryan):
  Three innate psychological needs:
  Autonomy     "I choose this" — internal locus of control
  Competence   "I can do this" — mastery and growth
  Relatedness  "I belong" — connection to others

  Goals that satisfy all three = sustainable motivation
  Goals that rely only on external pressure = burnout

INTRINSIC vs EXTRINSIC MOTIVATION:
  Intrinsic:   Doing it because it's inherently rewarding
               Curiosity, mastery, purpose, enjoyment
  Extrinsic:   Doing it for external outcomes
               Money, praise, avoiding punishment, status

  ⚠️ Overjustification Effect:
  Adding external rewards to intrinsically motivated activities
  can DECREASE motivation. (e.g., paying kids to read → they read less)

THE MOTIVATION EQUATION (Piers Steel):
  Motivation = (Expectancy × Value) / (Impulsiveness × Delay)

  Expectancy:     "Can I actually do this?" → build confidence with small wins
  Value:          "Is this worth doing?" → connect to identity and values
  Impulsiveness:  "Shiny distractions!" → reduce temptations, environment design
  Delay:          "Results are far away" → break into smaller milestones

OVERCOMING PLATEAUS:
  Recognition:    Progress isn't linear — plateaus are part of learning
  Variation:      Change approach (different methods, same goal)
  Novelty:        New challenge within the domain
  Rest:           Sometimes plateau = overtraining (physical or mental)
  Reframing:      Plateau = consolidation, not stagnation
  Community:      Others going through the same → normalize the struggle

MOTIVATION TRAPS:
  "I'll start Monday"    → Start now, imperfectly
  "I need to feel ready" → Action creates motivation, not vice versa
  "All or nothing"       → Something beats nothing, every time
  "Comparison to others" → Compare to your yesterday-self only
  "Motivation will last"  → It won't. Build systems, not just motivation.

IDENTITY-BASED MOTIVATION (James Clear):
  Instead of: "I want to lose weight" (outcome)
  Think:      "I am a person who moves every day" (identity)
  Each action is a vote for the type of person you want to become.
  Ask: "What would a healthy/productive/kind person do right now?"
EOF
}

cmd_review() {
    cat << 'EOF'
=== Review Systems ===

WEEKLY REVIEW (30-60 minutes, same day each week):
  1. Review last week's actions — what got done? What didn't?
  2. Check metrics — are KPIs/KRs on track?
  3. Celebrate wins — acknowledge progress (no matter how small)
  4. Identify blockers — what's preventing progress?
  5. Plan next week — set 3-5 priority actions per goal
  6. Schedule time blocks for goal work

  Template:
    WINS this week:
    LESSONS learned:
    BLOCKERS encountered:
    NEXT WEEK priorities (top 3):
    ADJUSTMENTS needed:

MONTHLY REVIEW (1-2 hours):
  1. Score monthly targets (0-100%)
  2. Review habit streaks and consistency
  3. Analyze what's working vs what's not
  4. Adjust tactics (not goals, unless fundamentally wrong)
  5. Set next month's specific targets

QUARTERLY REVIEW (half day):
  1. Score quarterly OKRs / milestones
  2. Deep reflection: Am I still pursuing the right goals?
  3. Alignment check: Are daily actions serving long-term vision?
  4. Course correction: Adjust, add, or drop goals
  5. Set next quarter's OKRs / milestones

ANNUAL REVIEW (full day):
  1. Celebrate the year's achievements
  2. Review against annual goals — what was the score?
  3. Life balance assessment across all domains
  4. Lessons learned — what will I carry forward?
  5. Vision setting for next year
  6. Set new annual goals and first quarter milestones

THE RETROSPECTIVE FORMAT (Agile-inspired):
  What went WELL? (Keep doing)
  What DIDN'T go well? (Stop or change)
  What will I TRY differently? (Experiment)

METRICS TO TRACK:
  Leading indicators:  Hours invested, sessions completed, actions taken
  Lagging indicators:  Weight, revenue, test scores, followers
  Focus on leading indicators — they predict lagging indicators
  Review lagging indicators monthly to validate direction
EOF
}

cmd_pitfalls() {
    cat << 'EOF'
=== Common Goal-Setting Pitfalls ===

1. TOO MANY GOALS
   Problem: Spreading focus across 10+ goals = progress on none
   Fix: Maximum 3 major goals at a time. "If everything is important,
        nothing is important." Ruthlessly prioritize.

2. VAGUE GOALS
   Problem: "Be healthier" has no finish line, no measurement
   Fix: Make it SMART. "Walk 10,000 steps daily for 90 days,
        tracked in Apple Health."

3. ONLY OUTCOME GOALS (no process)
   Problem: "Make $100K" gives no daily guidance
   Fix: Pair outcome with process: "Contact 5 new clients weekly,
        follow up within 48h, track in CRM."

4. NO WRITTEN PLAN
   Problem: Goals in your head feel real but aren't actionable
   Fix: Write it down. Put it where you'll see it daily.
        Digital or physical — doesn't matter. Written > thought.

5. PERFECTIONISM
   Problem: "If I can't do it perfectly, I won't start"
   Fix: "Done is better than perfect." Set a B+ standard.
        Ship, learn, improve. Iteration > perfection.

6. NO ACCOUNTABILITY
   Problem: Secret goals are easy to quietly abandon
   Fix: Tell someone. Accountability partner, coach, public
        commitment. Weekly check-ins with someone who cares.

7. IGNORING ENVIRONMENT
   Problem: Fighting willpower against a hostile environment
   Fix: Design your environment for success:
        - Remove junk food from house (not just resist it)
        - Block distracting websites (not just try harder)
        - Surround yourself with people who share your goals

8. GIVING UP AFTER FAILURE
   Problem: One bad week → "I'm not cut out for this"
   Fix: Expect failure. Plan for it. "When I miss a day, I will
        [backup plan]." Never miss twice. Consistency ≠ perfection.

9. MOVING GOALPOSTS
   Problem: Achieving the goal but immediately raising the bar
            without celebrating — hedonic treadmill
   Fix: Celebrate milestones. Rest at the summit before climbing
        the next mountain. Gratitude for progress made.

10. WRONG GOALS (not yours)
    Problem: Pursuing goals from parents, society, social media
    Fix: Ask "If no one would ever know, would I still want this?"
         If not, it might not be YOUR goal.
EOF
}

show_help() {
    cat << EOF
goal v$VERSION — Goal Setting & Achievement Reference

Usage: script.sh <command>

Commands:
  intro        Goal setting research and fundamentals
  smart        SMART goals framework with examples
  okr          Objectives & Key Results framework
  habits       Habit formation science and atomic habits
  planning     Goal decomposition and backward planning
  motivation   Motivation science and overcoming plateaus
  review       Weekly, monthly, quarterly review systems
  pitfalls     Common mistakes and evidence-based fixes
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    smart)      cmd_smart ;;
    okr)        cmd_okr ;;
    habits)     cmd_habits ;;
    planning)   cmd_planning ;;
    motivation) cmd_motivation ;;
    review)     cmd_review ;;
    pitfalls)   cmd_pitfalls ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "goal v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
