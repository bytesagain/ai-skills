#!/usr/bin/env bash
# mood — Mood & Emotional Wellness Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Mood Science Fundamentals ===

EMOTIONS vs MOODS:
  Emotions:
    - Brief (seconds to minutes)
    - Triggered by specific event
    - Identifiable cause
    - Intense, focused
    - Example: Fear when a car swerves toward you

  Moods:
    - Longer lasting (hours to days)
    - Often no single trigger
    - Background state, diffuse
    - Less intense, more pervasive
    - Example: Feeling irritable all afternoon

  Affect:
    - Umbrella term for all feeling states
    - Includes emotions, moods, and sentiments

CORE AFFECT MODEL (Russell's Circumplex):
  Two dimensions map all emotional states:

  High Energy (Arousal)
        │
   Anxious  │  Excited
   Stressed │  Enthusiastic
   ─────────┼──────────
   Sad      │  Content
   Bored    │  Calm
        │
  Low Energy (Arousal)
        
  Negative ←──────→ Positive
   (Valence)        (Valence)

NEUROSCIENCE BASICS:
  Key brain regions for mood:
    Amygdala         Threat detection, fear, emotional memory
    Prefrontal cortex  Regulation, decision-making, planning
    Hippocampus      Memory, context for emotions
    Insula           Body awareness, feeling states
    Anterior cingulate  Conflict monitoring, error detection

  Key neurotransmitters:
    Serotonin        Mood stability, well-being, sleep
    Dopamine         Reward, motivation, pleasure anticipation
    Norepinephrine   Alertness, energy, stress response
    GABA             Calm, relaxation, anxiety reduction
    Endorphins       Pain relief, runner's high, euphoria

EMOTIONAL LITERACY:
  The ability to identify, understand, and express emotions effectively.
  Research shows people who can name emotions precisely
  experience better regulation and mental health outcomes.
  "Name it to tame it" — Dan Siegel
  Expanding your emotion vocabulary is itself therapeutic.
EOF
}

cmd_wheel() {
    cat << 'EOF'
=== Emotion Taxonomy ===

PLUTCHIK'S WHEEL OF EMOTIONS (8 primary emotions):

  Primary       Opposite       Intensity Levels
  ───────       ────────       ──────────────────
  Joy          ↔ Sadness       Ecstasy → Joy → Serenity
  Trust        ↔ Disgust       Admiration → Trust → Acceptance
  Fear         ↔ Anger         Terror → Fear → Apprehension
  Surprise     ↔ Anticipation  Amazement → Surprise → Distraction

  Combined emotions (dyads):
    Joy + Trust       = Love
    Joy + Anticipation = Optimism
    Trust + Fear      = Submission
    Fear + Surprise   = Awe
    Surprise + Sadness = Disapproval
    Sadness + Disgust  = Remorse
    Disgust + Anger   = Contempt
    Anger + Anticipation = Aggressiveness

GRANULAR EMOTION VOCABULARY:

  Happy spectrum:
    Mild:     content, pleased, satisfied, comfortable
    Moderate: happy, cheerful, joyful, delighted, grateful
    Intense:  ecstatic, euphoric, elated, blissful, thrilled

  Sad spectrum:
    Mild:     disappointed, let down, melancholy, wistful
    Moderate: sad, unhappy, sorrowful, gloomy, heartbroken
    Intense:  devastated, despairing, grief-stricken, anguished

  Angry spectrum:
    Mild:     annoyed, irritated, frustrated, bothered
    Moderate: angry, resentful, indignant, furious
    Intense:  enraged, livid, seething, wrathful

  Anxious spectrum:
    Mild:     uneasy, worried, nervous, restless
    Moderate: anxious, apprehensive, tense, stressed
    Intense:  panicked, terrified, overwhelmed, dread

  Calm spectrum:
    Mild:     okay, fine, neutral, unbothered
    Moderate: calm, peaceful, relaxed, serene
    Intense:  blissful, transcendent, deeply at peace

MICRO-EMOTIONS (subtle states worth noticing):
  Ennui        Listless dissatisfaction, existential boredom
  Saudade      Nostalgic longing for something lost
  Schadenfreude  Pleasure at another's misfortune
  Hygge        Cozy contentment (Danish)
  Ikigai       Purposeful fulfillment (Japanese)
  Flow         Absorbed engagement in a challenging task
  Frisson      Pleasurable shiver from music/beauty
  Awe          Vastness + accommodation (mind expanding)
EOF
}

cmd_regulation() {
    cat << 'EOF'
=== Emotional Regulation Strategies ===

COGNITIVE REAPPRAISAL (most effective long-term):
  Reframe the situation to change the emotional response.
  Not: "This presentation will be a disaster"
  But: "This is a chance to practice speaking, and some nervousness
        means I care about doing well"

  Steps:
    1. Notice the emotion and the thought behind it
    2. Ask: "Is there another way to see this?"
    3. Generate 2-3 alternative interpretations
    4. Choose the most balanced one (not fake positive)

GROUNDING TECHNIQUES (for acute distress):

  5-4-3-2-1 Sensory Grounding:
    Name: 5 things you SEE
          4 things you TOUCH/FEEL
          3 things you HEAR
          2 things you SMELL
          1 thing you TASTE

  Box Breathing (4-4-4-4):
    Inhale 4 seconds → Hold 4 seconds →
    Exhale 4 seconds → Hold 4 seconds → Repeat

  Cold Exposure:
    Splash cold water on face (activates dive reflex)
    Hold ice cube in hand
    Cold shower burst
    → Triggers parasympathetic nervous system

DISTRESS TOLERANCE (DBT — Marsha Linehan):

  TIPP Skills:
    T — Temperature (cold water on face)
    I — Intense exercise (5-10 min burst)
    P — Paced breathing (long exhale)
    P — Progressive muscle relaxation

  ACCEPTS (distraction):
    Activities, Contributing, Comparisons, Emotions (opposite),
    Pushing away, Thoughts (replace), Sensations

PROCESS MODEL (Gross):
  5 points to intervene in emotional response:
    1. Situation selection    Avoid/approach situations
    2. Situation modification Change the situation
    3. Attention deployment   Redirect attention
    4. Cognitive change       Reappraise meaning
    5. Response modulation    Manage the response itself

  Earlier intervention = more effective and less effortful

HEALTHY vs UNHEALTHY REGULATION:
  Healthy:    Reappraisal, problem-solving, acceptance, social support,
              exercise, mindfulness, journaling
  Unhealthy:  Suppression, avoidance, rumination, substance use,
              emotional eating, self-harm
  Key: Suppressing emotions doesn't reduce them — it intensifies
       them and impairs memory, social connection, and health.
EOF
}

cmd_triggers() {
    cat << 'EOF'
=== Mood Triggers ===

HALT FRAMEWORK (check these first):
  H — Hungry?     Low blood sugar → irritability, brain fog
  A — Angry?      Unresolved anger → mood degradation
  L — Lonely?     Social isolation → sadness, anxiety
  T — Tired?      Sleep deprivation → emotional dysregulation

  Extended: HALTS
  S — Stressed?   Chronic stress → baseline mood drops
  S — Sick?       Illness → mood changes, reduced coping

ENVIRONMENTAL TRIGGERS:
  Light:         Seasonal Affective Disorder (SAD), blue light exposure
  Noise:         Chronic noise → stress, irritability
  Clutter:       Cluttered space → elevated cortisol
  Weather:       Rain, gray skies → lower mood (for some people)
  Air quality:   Poor air → fatigue, cognitive impairment
  Temperature:   Too hot/cold → irritability, discomfort

SOCIAL TRIGGERS:
  Conflict:        Arguments, criticism, rejection
  Social media:    Comparison, FOMO, doom scrolling
  Loneliness:      Isolation, lack of meaningful connection
  Crowding:        Overstimulation, loss of personal space
  Positive:        Connection, laughter, kindness received

COGNITIVE DISTORTIONS (Beck):
  All-or-Nothing:     "If it's not perfect, it's a failure"
  Catastrophizing:    "This will definitely be a disaster"
  Mind Reading:       "They think I'm stupid"
  Personalization:    "It's my fault they're upset"
  Should Statements:  "I should be happy" → guilt for feeling bad
  Filtering:          Focus only on negatives, ignore positives
  Overgeneralization: "This ALWAYS happens to me"
  Emotional Reasoning: "I feel stupid, so I must BE stupid"

  Fix: Notice the distortion → challenge it with evidence →
       generate balanced thought

PHYSIOLOGICAL TRIGGERS:
  Hormonal cycles:    Menstrual cycle, testosterone fluctuations
  Medication:         Side effects, withdrawal
  Caffeine:           Anxiety, sleep disruption
  Alcohol:            Depressant (next-day mood drop)
  Blood sugar:        Hypoglycemia → irritability ("hangry")
  Chronic pain:       Persistent pain → mood depression
  Gut health:         Microbiome affects serotonin production (90% in gut)
EOF
}

cmd_journaling() {
    cat << 'EOF'
=== Mood Journaling Techniques ===

BASIC MOOD LOG:
  Time:       _______________
  Mood:       _______________ (1-10 scale)
  Feeling:    _______________ (specific emotion word)
  Trigger:    What happened right before?
  Thought:    What went through my mind?
  Body:       Where do I feel this in my body?
  Action:     What did I do in response?

CBT THOUGHT RECORD:
  1. Situation:     What happened? (objective facts)
  2. Emotions:      What did I feel? (name + intensity 0-100%)
  3. Automatic thought: What went through my mind?
  4. Evidence FOR:  What supports this thought?
  5. Evidence AGAINST: What contradicts this thought?
  6. Balanced thought: More realistic perspective
  7. Outcome:       How do I feel now? (re-rate 0-100%)

GRATITUDE JOURNALING:
  Daily: Write 3 things you're grateful for
  Be specific: Not "family" but "Mom's phone call that made me laugh"
  Why it works: Shifts attention from threats to blessings
  Research: 10 weeks of gratitude journaling → 25% happier (Emmons)
  Avoid: Don't make it a chore — genuine > routine

EXPRESSIVE WRITING (Pennebaker Method):
  Write for 20 minutes about deepest thoughts and feelings
  About a difficult experience or strong emotion
  No editing, no grammar concerns, just write
  Repeat 3-4 days on the same topic
  Research: improved immune function, lower depression,
            better grades, fewer doctor visits

PROMPT IDEAS:
  Morning:   "How do I want to feel today? What would support that?"
  Evening:   "What was the emotional highlight and lowlight of today?"
  Weekly:    "What patterns am I noticing in my mood this week?"
  Stuck:     "If my emotion could speak, what would it say?"
  Growth:    "What did I handle better this time than last time?"

TRACKING PATTERNS:
  After 2-4 weeks of daily logging, look for:
    - Time-of-day patterns (morning vs evening mood)
    - Day-of-week patterns (weekend vs weekday)
    - Trigger patterns (same situations → same emotions)
    - Sleep-mood correlation
    - Exercise-mood correlation
    - Social-mood correlation
  Visual: Plot mood ratings over time → identify trends
EOF
}

cmd_lifestyle() {
    cat << 'EOF'
=== Lifestyle Factors Affecting Mood ===

SLEEP (most impactful):
  Duration:    7-9 hours for adults (less = emotional dysregulation)
  Quality:     Deep sleep + REM critical for emotional processing
  Consistency: Same sleep/wake time (±30 min) even weekends
  
  Sleep deprivation effects on mood:
    1 night poor sleep → 60% increase in emotional reactivity
    Chronic poor sleep → similar symptoms to depression
    REM deprivation → impaired emotional memory processing

  Sleep hygiene essentials:
    - No screens 1 hour before bed (or use blue light filter)
    - Cool room (65-68°F / 18-20°C)
    - Consistent schedule
    - Caffeine cutoff 8-10 hours before bed
    - Dark room (blackout curtains or sleep mask)

EXERCISE (most reliable mood booster):
  Acute:       Single session improves mood for 4-6 hours
  Chronic:     Regular exercise = as effective as antidepressants for mild-moderate depression
  
  Minimum effective dose: 20 minutes moderate activity, 3x/week
  Optimal: 150 min moderate OR 75 min vigorous per week
  
  Best for mood:
    Aerobic (running, cycling, swimming) → endorphins, serotonin
    Yoga → GABA increase, stress reduction
    Strength training → confidence, mastery, testosterone
    Nature walks → combines exercise + nature (double benefit)

NUTRITION:
  Mediterranean diet: associated with 33% lower depression risk
  Omega-3 fatty acids: anti-inflammatory, mood-supporting
  Gut health: fermented foods, fiber → serotonin production
  Blood sugar stability: regular meals, complex carbs, protein
  
  Mood-damaging:
    Excessive sugar → energy crashes → irritability
    Ultra-processed food → inflammation → mood decline
    Excessive alcohol → disrupts sleep, depressant
    Excessive caffeine → anxiety, sleep disruption

SOCIAL CONNECTION:
  Loneliness is as harmful as smoking 15 cigarettes/day (Holt-Lunstad)
  Meaningful conversations (not small talk) boost mood
  Physical touch releases oxytocin
  Minimum: 2-3 close relationships for emotional buffer
  Quality > quantity: one deep friendship > many acquaintances

NATURE EXPOSURE:
  20 minutes in nature → cortisol drops measurably
  "Forest bathing" (Shinrin-yoku) → lower stress hormones
  Even houseplants and nature photos have mild benefits
  Sunlight → vitamin D + serotonin + circadian alignment
  Target: some outdoor time daily, ideally morning sunlight
EOF
}

cmd_tracking() {
    cat << 'EOF'
=== Mood Tracking Systems ===

SCALES:

  Simple (1-5):
    1 = Very bad  2 = Bad  3 = Okay  4 = Good  5 = Great
    Best for: daily quick check-in, minimal friction

  Numerical (1-10):
    More granular, better for detecting trends
    Anchor points: 1 = worst ever, 5 = neutral, 10 = best ever

  Visual Analog Scale (VAS):
    Slider from "worst" to "best"
    More nuanced, less categorical bias
    Good for apps and digital tracking

  Emoji Scale:
    😢 😟 😐 🙂 😄
    Low barrier, universal, culturally inclusive
    Less precise but higher compliance

  Circumplex (2D):
    Rate both valence (negative↔positive) AND arousal (low↔high)
    More informative: "calm-positive" vs "excited-positive"

FREQUENCY:
  3x daily:    Morning, afternoon, evening (best for pattern detection)
  2x daily:    Morning + evening (good balance)
  1x daily:    End of day reflection (minimum recommended)
  Event-based: Log when something notable happens (less systematic)
  Weekly:      Too infrequent for pattern detection

  Best practice: Start with 1x daily, increase if engaged

WHAT TO TRACK ALONGSIDE MOOD:
  Sleep hours and quality (previous night)
  Exercise (type, duration)
  Meals (quality, timing)
  Social interaction (alone, small group, crowd)
  Weather and light exposure
  Menstrual cycle (if applicable)
  Medication adherence
  Significant events or stressors
  Screen time / social media
  Caffeine and alcohol intake

PATTERN RECOGNITION:
  After 2-4 weeks, analyze:
    Correlation: mood × sleep (usually strong)
    Correlation: mood × exercise
    Time patterns: morning person? Evening dip?
    Weekly patterns: Sunday scaries? Friday relief?
    Trigger patterns: meetings → anxiety? Nature → calm?

  Visualization:
    Line chart: mood over time (trend, cycles)
    Heat map: mood by day/time (weekly patterns)
    Scatter plot: mood vs sleep hours (correlation)
    Calendar view: color-coded days (at-a-glance month)

APPS:
  Daylio          Simple, visual, no writing required
  Pixels          Year-in-pixels calendar view
  Bearable        Correlates mood with health factors
  Moodfit         CBT-based tools + tracking
  How We Feel     Research-backed, circumplex model
EOF
}

cmd_resilience() {
    cat << 'EOF'
=== Building Emotional Resilience ===

WHAT IS RESILIENCE:
  Not: never feeling bad or being unaffected by adversity
  Is: the ability to recover from difficulties and adapt
  Resilience is a skill that can be developed, not a fixed trait

THE RESILIENCE FRAMEWORK (APA):

  1. CONNECTIONS
     Build and maintain supportive relationships
     Don't isolate during difficult times
     Accept help and support
     Prioritize relationships proactively

  2. WELLNESS
     Take care of your body (sleep, exercise, nutrition)
     Practice mindfulness or meditation
     Avoid unhealthy coping (substances, avoidance)
     Rest is not laziness — it's recovery

  3. HEALTHY THINKING
     Keep perspective (this too shall pass)
     Accept that change is part of life
     Maintain a hopeful outlook (realistic, not delusional)
     Learn from adversity (post-traumatic growth)

  4. MEANING
     Set meaningful goals (direction during chaos)
     Look for opportunities in challenges
     Help others (shifts focus, builds purpose)
     Connect to values and purpose

  5. PROACTIVE STEPS
     Don't wait for problems — build capacity
     Face fears gradually (exposure therapy principle)
     Develop problem-solving skills before crises
     Create routines that support well-being

STRESS INOCULATION (Meichenbaum):
  Train resilience by graduated exposure to stress:
  1. Education: understand stress response (it's normal, adaptive)
  2. Skills: learn coping techniques (breathing, reappraisal)
  3. Application: practice in low-stress situations first
  4. Graduation: apply in progressively challenging situations
  Like a vaccine: small doses build immunity

GROWTH MINDSET (Dweck):
  Fixed mindset: "I failed, I'm a failure"
  Growth mindset: "I failed, I can learn from this"
  
  Reframes:
    "I can't do this" → "I can't do this YET"
    "This is too hard" → "This will take effort and practice"
    "I made a mistake" → "Mistakes help me learn"

POST-TRAUMATIC GROWTH:
  Some people report positive changes after adversity:
    - Greater appreciation for life
    - More meaningful relationships
    - Increased personal strength
    - Recognition of new possibilities
    - Spiritual or existential deepening
  Not guaranteed, not expected — but possible.
  Growth and suffering can coexist.

DAILY RESILIENCE PRACTICES:
  Morning:   Set intention, brief meditation (5 min)
  Midday:    Check in with HALT (Hungry, Angry, Lonely, Tired?)
  Evening:   Gratitude practice, wind-down routine
  Weekly:    Social connection, nature time, reflection
  Monthly:   Review patterns, adjust strategies, celebrate progress
EOF
}

show_help() {
    cat << EOF
mood v$VERSION — Mood & Emotional Wellness Reference

Usage: script.sh <command>

Commands:
  intro       Mood science, emotions vs moods, neuroscience basics
  wheel       Emotion taxonomy, Plutchik's wheel, vocabulary
  regulation  Regulation strategies — reappraisal, grounding, DBT
  triggers    Mood triggers — HALT, cognitive distortions, environment
  journaling  Journaling techniques, CBT thought records, gratitude
  lifestyle   Sleep, exercise, nutrition, social connection, nature
  tracking    Mood scales, tracking frequency, pattern recognition
  resilience  Building resilience, stress inoculation, growth mindset
  help        Show this help
  version     Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    wheel)      cmd_wheel ;;
    regulation) cmd_regulation ;;
    triggers)   cmd_triggers ;;
    journaling) cmd_journaling ;;
    lifestyle)  cmd_lifestyle ;;
    tracking)   cmd_tracking ;;
    resilience) cmd_resilience ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "mood v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
