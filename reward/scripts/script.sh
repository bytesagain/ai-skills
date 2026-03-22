#!/usr/bin/env bash
# reward — Reward System Design Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Reward System Fundamentals ===

A reward system is any structured mechanism that delivers positive
outcomes in response to desired behaviors, driving engagement,
loyalty, and habit formation.

BEHAVIORAL SCIENCE FOUNDATIONS:

  Operant Conditioning (BF Skinner):
    Behavior is shaped by its consequences.
    Positive reinforcement: Add something pleasant → repeat behavior
    Negative reinforcement: Remove something unpleasant → repeat behavior
    Punishment: Add something unpleasant → reduce behavior
    Extinction: Remove reinforcement → behavior fades

  Dopamine & Anticipation:
    The brain's reward circuit releases dopamine not just at reward,
    but during ANTICIPATION of reward. Uncertainty amplifies this.
    → Variable rewards are more engaging than predictable ones
    → The journey to the reward matters as much as the reward itself

TYPES OF REWARDS:
  Tangible         Money, gifts, products, discounts
  Social           Recognition, status, praise, titles
  Experiential     Access, exclusive events, early access, VIP treatment
  Informational    Feedback, progress data, achievement unlock
  Autonomy         Freedom, choice, self-direction opportunities

REWARD DESIGN PRINCIPLES:
  1. Timely         Reward close to the behavior (immediacy matters)
  2. Proportional   Value matches effort (don't over or under reward)
  3. Meaningful     Aligns with recipient's values and desires
  4. Variable       Some unpredictability maintains engagement
  5. Visible        Others can see the reward (social proof)
  6. Achievable     Goals feel reachable (not impossibly distant)
  7. Progressive    Rewards grow with sustained engagement
  8. Authentic      Feels genuine, not manipulative
EOF
}

cmd_schedules() {
    cat << 'EOF'
=== Reinforcement Schedules ===

How rewards are timed fundamentally determines behavior patterns.

FIXED RATIO (FR):
  Reward after every N actions.
  Example: "Buy 10 coffees, get 1 free" (FR-10)
  Behavior: Steady effort, brief pause after reward (post-reinforcement pause)
  Use for: Simple loyalty programs, piecework compensation
  Pro: Predictable, easy to understand
  Con: Engagement drops right after reward, then ramps back up

VARIABLE RATIO (VR):
  Reward after unpredictable number of actions.
  Example: Slot machines, gacha games, fishing, loot drops
  Behavior: High, steady response rate — MOST RESISTANT TO EXTINCTION
  Use for: Games, engagement hooks, social media likes
  Pro: Highest engagement, persistent behavior
  Con: Can become addictive, ethical concerns
  ⚠️ The most powerful and most dangerous schedule

FIXED INTERVAL (FI):
  Reward available after fixed time period.
  Example: Daily login bonus, weekly paycheck, monthly subscription box
  Behavior: Low activity early, increases as reward time approaches
  Use for: Recurring engagement, retention tools
  Pro: Regular return visits, predictable costs
  Con: Activity clusters around reward time, dead periods

VARIABLE INTERVAL (VI):
  Reward available after unpredictable time period.
  Example: Random pop-up sales, surprise bonus, "mystery" daily reward
  Behavior: Steady, moderate response rate
  Use for: Maintaining consistent checking behavior
  Pro: Reduces dead periods, steady engagement
  Con: Harder to plan/budget, may frustrate users

COMPOUND SCHEDULES (real-world combinations):
  Season pass:     Fixed interval (season) + Fixed ratio (XP per level)
  Loot boxes:      Variable ratio (drop rate) + fixed interval (daily free one)
  Social media:    Variable interval (when friends post) + variable ratio (likes)

OPTIMAL ENGAGEMENT PATTERN:
  1. Start with Fixed Ratio (low threshold) → quick wins, teach the loop
  2. Graduate to Variable Ratio → sustained engagement
  3. Layer Fixed Interval → daily return habit
  4. Add Variable surprises → delight and discovery
EOF
}

cmd_loyalty() {
    cat << 'EOF'
=== Loyalty Program Design ===

PROGRAM MODELS:

  Points-Based:
    Earn points per dollar/action, redeem for rewards
    Examples: Airline miles, credit card points, Starbucks Stars
    Design: 1 point per $1 spent, redeem at $0.01-0.02/point value
    Key: Points must feel valuable and be easy to redeem

  Tiered:
    Status levels unlock better benefits
    Examples: Hotel programs (Silver → Gold → Platinum → Diamond)
    Design: 3-5 tiers, clear qualification criteria
    Key: Each tier must feel meaningfully different

  Paid/Subscription:
    Pay upfront for better rewards
    Examples: Amazon Prime, Costco membership, airline status match
    Design: Annual fee < perceived annual benefit
    Key: Must deliver obvious, immediate value

  Coalition:
    Multiple brands share one loyalty currency
    Examples: Aeroplan (Canada), Nectar (UK), Tmall Points
    Design: Common currency, brand-specific bonuses
    Key: Wide earn/burn options increase perceived value

  Cashback:
    Simple percentage back on purchases
    Examples: Credit card cashback, Rakuten, Ibotta
    Design: 1-5% standard, category bonuses 5-10%
    Key: Simplicity is the appeal

TIER DESIGN BEST PRACTICES:
  Entry tier:    Easy to reach (~80% of members), basic benefits
  Middle tier:   Meaningful effort (~15%), noticeable upgrade
  Top tier:      Aspirational (~5%), exclusive experiences
  Re-qualification: Annual cycle, slightly lower than initial qualification
  Status matching: Acquire competitors' high-value customers

EARN RATE GUIDELINES:
  Too stingy: Customer gives up ("I'll never earn enough")
  Too generous: Unsustainable liability, devaluation risk
  Sweet spot: First meaningful reward achievable in 3-5 transactions
  Show progress: "You're 70% to your next reward!"

LOYALTY METRICS:
  Enrollment rate:     % eligible customers who join
  Active rate:         % members with activity in last 90 days
  Redemption rate:     Points redeemed / points earned
  Breakage:            Points earned but never redeemed (revenue)
  Incremental revenue: Additional spend from members vs non-members
  CLV lift:            Customer lifetime value increase from program
EOF
}

cmd_gamification() {
    cat << 'EOF'
=== Gamification Mechanics ===

CORE MECHANICS:

  Points:
    Quantified progress currency
    Types: experience (XP), currency (coins), karma, reputation
    Best practice: Clear earning rules, visible balance, multiple uses

  Badges/Achievements:
    Visual markers of accomplishment
    Types: milestone (100 purchases), skill (first review), special (event)
    Best practice: Mix easy + hard, surprise + known, limited editions

  Leaderboards:
    Competitive ranking among peers
    Types: global, friends-only, weekly reset, category-specific
    ⚠️ Risk: Demotivates bottom 90% who can never compete
    Fix: Segmented boards (top 100, your percentile, friends)

  Progress Bars:
    Visual completion indicator
    Endowed progress effect: Start at 20% → feels achievable
    Best practice: Break into segments, show % and absolute numbers

  Streaks:
    Consecutive activity counter
    Examples: Duolingo daily streak, Snapchat streaks
    Power: Loss aversion — don't want to lose the streak
    ⚠️ Risk: Stressful, punishing for legitimate breaks
    Fix: Streak freezes, grace periods, streak recovery items

  Challenges/Quests:
    Time-bound goals with specific rewards
    Daily challenges: low effort, small reward (login habit)
    Weekly challenges: medium effort, better reward
    Special events: limited-time, exclusive rewards (FOMO)

  Levels:
    Progressive difficulty and status markers
    XP curve: typically exponential (each level takes more)
    Best practice: Level 1-5 quick (hook), then gradual increase
    Prestige system: reset and do it again with bonuses

OCTALYSIS FRAMEWORK (Yu-kai Chou):
  8 core drives of gamification:
  1. Epic Meaning       "I'm part of something bigger"
  2. Development        "I'm getting better/stronger"
  3. Empowerment        "I can be creative and get feedback"
  4. Ownership          "I own and want to improve this"
  5. Social Influence   "Others are doing it / watching me"
  6. Scarcity           "I can't get this easily, I want it more"
  7. Unpredictability   "I wonder what happens next"
  8. Avoidance          "I don't want to lose my progress"

  White hat (1-3): feel great, sustainable, intrinsic
  Black hat (6-8): urgent, addictive, potentially harmful
  Best design: primarily white hat with strategic black hat elements
EOF
}

cmd_intrinsic() {
    cat << 'EOF'
=== Intrinsic Rewards ===

Intrinsic rewards come from the activity itself, not external incentives.
They are more sustainable and create deeper engagement than extrinsic rewards.

SELF-DETERMINATION THEORY (Deci & Ryan):
  Three innate needs that drive intrinsic motivation:

  AUTONOMY — "I choose this"
    Let people decide HOW to complete tasks
    Offer meaningful choices, not just yes/no
    Self-directed goals > assigned goals
    Example: 20% time (Google), flexible work arrangements

  COMPETENCE — "I'm growing"
    Clear feedback on performance
    Challenges that match skill level (flow)
    Visible progress and mastery indicators
    Example: Skill trees, mastery badges, performance dashboards

  RELATEDNESS — "I belong"
    Connection to others and community
    Shared purpose and collaborative goals
    Social recognition from peers (not just managers)
    Example: Team achievements, community contributions, mentoring

FLOW STATE (Csikszentmihalyi):
  Optimal experience when challenge matches skill:
  Challenge too high → anxiety
  Challenge too low → boredom
  Challenge = skill → FLOW

  Flow conditions:
    1. Clear goals for each step
    2. Immediate feedback
    3. Balance between challenge and skill
    4. Merger of action and awareness
    5. Sense of control
    6. Loss of self-consciousness
    7. Altered sense of time

MEANINGFUL WORK:
  Connect tasks to impact: "Who benefits from what I do?"
  Purpose: work serves something larger than self
  Craft: pride in quality of work itself
  Connection: relationships formed through work
  Progress: visible forward movement (Teresa Amabile's research)

THE OVERJUSTIFICATION EFFECT:
  ⚠️ Adding external rewards to intrinsically motivated behavior
  can DECREASE intrinsic motivation!

  Classic study: Children who loved drawing were paid to draw.
  Result: They drew LESS when payment stopped.

  Lesson: Use extrinsic rewards for unenjoyable tasks.
          For naturally enjoyable tasks, enhance intrinsic rewards instead.
          If you must use extrinsic: make them unexpected, informational,
          and tied to competence (not just completion).
EOF
}

cmd_pitfalls() {
    cat << 'EOF'
=== Reward Design Pitfalls ===

1. COBRA EFFECT (Perverse Incentives):
   Reward creates the opposite of desired behavior.
   Example: Bounty on cobra snakes → people breed cobras for bounty
   Example: Reward for bug fixes → developers introduce bugs to fix
   Fix: Reward outcomes, not outputs. Measure what matters.

2. GAMING THE SYSTEM:
   People optimize for the reward metric, not the intent.
   Example: Call center rewards "calls per hour" → hang up on hard calls
   Example: Lines of code reward → bloated, verbose code
   Fix: Multiple balanced metrics, qualitative review, spirit-of-the-law clauses

3. CROWDING OUT INTRINSIC MOTIVATION:
   External rewards can kill internal motivation.
   Example: Paying volunteers → they feel like cheap labor, not helpers
   Example: Giving grades for reading → kids read less for fun
   Fix: Use extrinsic rewards sparingly, prefer recognition over cash

4. ENTITLEMENT ESCALATION:
   Rewards become expected, then demanded, then insufficient.
   Example: Annual bonus → employees see it as part of salary
   Example: Loyalty discount → customers won't buy at full price
   Fix: Variable rewards, surprise bonuses, clear framing as extra

5. INEQUITY PERCEPTION:
   If rewards feel unfair, they demotivate EVERYONE.
   Example: Sales commission structure favors legacy accounts
   Example: Top performer bonus too close to average performer bonus
   Fix: Transparent criteria, differentiated rewards, perceived fairness

6. SHORT-TERM FOCUS:
   Rewards for short-term metrics sacrifice long-term value.
   Example: Quarterly sales bonus → end-of-quarter discounting
   Example: Daily active user rewards → low-quality sessions
   Fix: Balance immediate rewards with long-term incentives

7. REWARD INFLATION:
   Need bigger rewards over time for same effect (habituation).
   Example: First discount email gets 20% open rate, 50th gets 2%
   Fix: Vary reward types, intermittent schedules, meaningful > big

8. EXCLUDING THE MAJORITY:
   Top-performer-only rewards demotivate everyone else.
   Example: "Employee of the Month" → same 3 people rotate
   Fix: Tiered recognition, effort-based + outcome-based, team rewards
EOF
}

cmd_workplace() {
    cat << 'EOF'
=== Workplace Incentives ===

RECOGNITION PROGRAMS:

  Peer-to-Peer Recognition:
    Platform: Bonusly, Kudos, Nectar, Motivosity
    How: Employees give micro-bonuses/points to each other
    Budget: $20-50/employee/month to distribute
    Impact: 14% better engagement than manager-only recognition

  Spot Awards:
    Immediate recognition for exceptional work
    Manager can award on-the-spot (gift card, bonus, time off)
    Budget: $50-500 per award
    Key: Timely, specific, public when appropriate

  Service Awards:
    Milestone-based: 1, 3, 5, 10, 15, 20+ years
    Modern approach: experience catalog (choose your reward)
    Old approach: generic plaque/pin (low impact)

BONUS STRUCTURES:

  Individual Performance Bonus:
    Tied to personal KPIs/OKRs
    Typical: 5-20% of base salary
    Risk: Competition over collaboration
    Mitigate: Include team metrics (30% team, 70% individual)

  Team/Group Bonus:
    Shared pool based on team achievement
    Promotes collaboration, knowledge sharing
    Risk: Free-rider problem (some coast on others' work)
    Mitigate: Peer evaluation component, minimum individual standard

  Profit Sharing:
    Percentage of company profit distributed to employees
    Typical: 2-10% of profits
    Creates ownership mentality
    Risk: Employees can't control profitability individually

  Equity/Stock Options:
    Long-term alignment with company success
    Vesting schedule: typically 4 years with 1-year cliff
    Most powerful for early-stage companies

NON-MONETARY REWARDS (often more impactful):
  Flexible work hours / remote work options
  Extra paid time off (birthday off, mental health days)
  Learning budget ($1000-5000/year for courses)
  Conference attendance
  Lunch with leadership
  Project choice (pick your next assignment)
  Title upgrade
  Public presentation opportunity
  Mentoring from senior leader
EOF
}

cmd_metrics() {
    cat << 'EOF'
=== Measuring Reward Effectiveness ===

ENGAGEMENT METRICS:
  Participation rate:    % of eligible people engaging with program
  Active rate:           % with activity in last 30/60/90 days
  Frequency:             Average interactions per user per period
  Session depth:         How deeply users engage per visit

  Benchmarks:
    Good participation: >60% of eligible
    Good active rate: >40% monthly active
    Warning sign: participation dropping month-over-month

RETENTION METRICS:
  Churn rate:            % of members who disengage per period
  Retention curve:       % remaining at day 1, 7, 30, 90, 365
  Cohort analysis:       Compare retention across signup periods
  Reactivation rate:     % of churned members who return

  Program Impact:
    Members vs non-members retention comparison
    Target: 20-40% better retention for program members

SATISFACTION METRICS:
  NPS (Net Promoter Score):     "Would you recommend this program?"
  CSAT (Customer Satisfaction): "How satisfied are you with rewards?"
  CES (Customer Effort Score):  "How easy was it to earn/redeem?"

  Survey at key moments:
    After first reward earned
    After first redemption
    At program anniversary
    After tier upgrade/downgrade

FINANCIAL METRICS:
  Incremental revenue:   Additional spend attributable to program
  Cost per member:       Total program cost / active members
  ROI:                   (Incremental revenue - program cost) / program cost
  Breakage rate:         % of earned rewards never redeemed
  Liability:             Outstanding unredeemed points value

  Calculation example:
    Members spend $150/month vs non-members $100/month
    Incremental: $50/month × 10,000 members = $500,000/month
    Program cost: $100,000/month
    ROI: ($500,000 - $100,000) / $100,000 = 400%

BEHAVIORAL METRICS:
  Desired behavior change:  Did the target behavior increase?
  Unintended behaviors:     Any gaming or perverse outcomes?
  Habit formation:          Does behavior persist without reward?
  Referral rate:            Do members bring others in?

REPORTING CADENCE:
  Daily:      Participation, earn/burn activity
  Weekly:     Engagement trends, anomaly detection
  Monthly:    ROI, retention, satisfaction scores
  Quarterly:  Program review, strategy adjustment
  Annually:   Full program audit, competitive benchmark
EOF
}

show_help() {
    cat << EOF
reward v$VERSION — Reward System Design Reference

Usage: script.sh <command>

Commands:
  intro        Behavioral science, reinforcement theory, reward types
  schedules    Reinforcement schedules — fixed/variable ratio/interval
  loyalty      Loyalty program models, tiers, earn rates, metrics
  gamification Badges, leaderboards, streaks, progress, Octalysis
  intrinsic    Autonomy, mastery, purpose, flow, meaningful work
  pitfalls     Cobra effect, gaming, crowding out, entitlement
  workplace    Recognition programs, bonuses, non-monetary rewards
  metrics      Engagement, retention, satisfaction, ROI measurement
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    schedules)    cmd_schedules ;;
    loyalty)      cmd_loyalty ;;
    gamification) cmd_gamification ;;
    intrinsic)    cmd_intrinsic ;;
    pitfalls)     cmd_pitfalls ;;
    workplace)    cmd_workplace ;;
    metrics)      cmd_metrics ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "reward v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
