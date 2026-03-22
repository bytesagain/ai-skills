#!/usr/bin/env bash
# hydrate — Hydration & Fluid Balance Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Hydration Science ===

Water makes up 50-70% of body weight and is essential for every
biological process. Even mild dehydration (1-2% body weight loss)
impairs cognitive and physical performance.

Why Water Matters:
  - Regulates body temperature (sweating, vasodilation)
  - Transports nutrients and oxygen via blood
  - Removes waste through kidneys and bowels
  - Lubricates joints (synovial fluid)
  - Cushions organs and tissues
  - Enables chemical reactions (hydrolysis, metabolism)
  - Maintains blood pressure and volume

Body Water Distribution:
  Intracellular (inside cells):    ~65% of total body water
  Extracellular (outside cells):   ~35%
    - Interstitial (between cells):  ~75% of extracellular
    - Plasma (blood):                ~25% of extracellular

How the Body Regulates Water:
  Input:   Drinking (~60%), food (~30%), metabolic water (~10%)
  Output:  Urine (~60%), sweat (~6%), breath (~12%), feces (~4%)

  Regulation mechanisms:
    Thirst:        Triggered at ~1-2% dehydration
    ADH hormone:   Signals kidneys to retain water
    Aldosterone:   Signals kidneys to retain sodium (and water)
    Renin-angiotensin: Blood pressure regulation

  Average daily water turnover:
    Sedentary adult: 2.5L in, 2.5L out
    Active adult:    3.5-4.5L in, 3.5-4.5L out
    Endurance athlete in heat: 6-10L+ in/out

Water Quality Matters:
  Tap water:       Generally safe in developed countries, check local reports
  Filtered:        Removes chlorine taste, some contaminants
  Mineral water:   Contains natural electrolytes (varies by source)
  Distilled:       No minerals — not ideal for regular drinking
  Temperature:     Cold water absorbs faster, warm water aids digestion
EOF
}

cmd_intake() {
    cat << 'EOF'
=== Daily Water Intake Guidelines ===

General Recommendations:
  Men:      ~3.7L (125 oz) total water/day (all sources)
  Women:    ~2.7L (91 oz) total water/day (all sources)
  Source: National Academies of Sciences (2004)

  This includes water from food (~20% of intake)
  Drinking water target:
    Men:    ~3.0L (~13 cups)
    Women:  ~2.2L (~9 cups)

Simple Formula (body weight method):
  Ounces = Body weight (lbs) × 0.5 to 0.67
  Example: 150 lbs → 75-100 oz (2.2-3.0L) per day

  Liters = Body weight (kg) × 0.033
  Example: 70 kg → 2.3L per day

Adjustment Factors:
  Add 500-1000mL for each factor:
    ☀ Hot weather (>30°C / 86°F)
    🏃 Exercise (add 500mL per 30 min of moderate exercise)
    🏔 Altitude (>2500m — faster breathing, more water loss)
    ✈️ Air travel (cabin humidity ~10-20%, very dehydrating)
    🤒 Illness (fever, vomiting, diarrhea increase losses)
    🤰 Pregnancy (+300mL) / Breastfeeding (+700mL)
    ☕ High caffeine intake (mild diuretic effect above 400mg)
    🍺 Alcohol (diuretic — match each drink with water)

Timing Strategy:
  Wake up:       500mL (rehydrate from overnight fast)
  30 min before meals: 250mL (aids digestion)
  Between meals:  sip regularly (don't chug)
  Before bed:     small sip (enough to prevent thirst, not disruptive)
  Before exercise: 500mL 2 hours prior
  After exercise:  150% of sweat loss over 2-4 hours

Water-Rich Foods (contribute to daily intake):
  Cucumber:     96% water     Watermelon:   92% water
  Lettuce:      96% water     Strawberries: 91% water
  Celery:       95% water     Oranges:      87% water
  Tomatoes:     94% water     Yogurt:       85% water
  Zucchini:     94% water     Soup/broth:   90%+ water
EOF
}

cmd_electrolytes() {
    cat << 'EOF'
=== Electrolyte Guide ===

Electrolytes are minerals that carry electric charges in body fluids.
They're critical for nerve function, muscle contraction, pH balance,
and fluid regulation.

Sodium (Na⁺):
  Role: fluid balance, nerve impulses, muscle contraction
  RDI: 1500-2300 mg/day (varies by guidelines)
  Lost in sweat: 200-2000 mg/L (average ~900 mg/L)
  Deficiency (hyponatremia): confusion, seizures, coma
  Sources: salt, pickles, broth, olives, cheese
  Athletes: may need 500-1000 mg/hour during intense exercise

Potassium (K⁺):
  Role: heart rhythm, muscle function, blood pressure
  RDI: 2600-3400 mg/day
  Lost in sweat: ~200 mg/L
  Deficiency: muscle cramps, weakness, irregular heartbeat
  Sources: banana (422mg), potato (926mg), avocado (485mg),
           spinach (558mg/cup), coconut water (600mg/cup)

Magnesium (Mg²⁺):
  Role: 300+ enzyme reactions, muscle/nerve function, sleep
  RDI: 310-420 mg/day
  Lost in sweat: ~15 mg/L (small but cumulative)
  Deficiency: cramps, fatigue, insomnia, anxiety
  Sources: almonds (80mg/oz), dark chocolate (65mg/oz),
           pumpkin seeds (156mg/oz), spinach (157mg/cup)
  Note: ~50% of population is deficient

Calcium (Ca²⁺):
  Role: bone health, muscle contraction, blood clotting
  RDI: 1000-1300 mg/day
  Lost in sweat: ~40 mg/L
  Deficiency: osteoporosis, muscle spasms, dental problems
  Sources: dairy, sardines, fortified foods, broccoli, kale

Chloride (Cl⁻):
  Role: stomach acid (HCl), fluid balance (follows sodium)
  RDI: 2300 mg/day
  Usually sufficient if sodium intake is adequate

DIY Electrolyte Drink:
  1L water + 1/4 tsp salt (575mg Na) + 1/4 tsp salt substitute
  (KCl, ~600mg K) + 2 tbsp honey + juice of 1 lemon
  Cost: ~$0.10 vs $2-3 for commercial drinks
EOF
}

cmd_signs() {
    cat << 'EOF'
=== Dehydration Signs & Stages ===

Stage 1 — Mild Dehydration (1-3% body weight loss):
  Symptoms:
    - Thirst (most obvious but LATE indicator)
    - Dry mouth and lips
    - Slightly darker urine (straw to dark yellow)
    - Mild headache
    - Decreased concentration
    - Slight fatigue
  Performance impact: 10-20% reduction in endurance
  Fix: drink 500-1000mL water over 1-2 hours

Stage 2 — Moderate Dehydration (3-5% body weight loss):
  Symptoms:
    - Strong thirst
    - Dark yellow/amber urine, reduced volume
    - Dry, cool skin
    - Headache (more intense)
    - Dizziness when standing (orthostatic hypotension)
    - Rapid heartbeat
    - Muscle cramps
    - Irritability, difficulty concentrating
  Performance impact: 20-40% reduction
  Fix: oral rehydration solution (ORS), slow sipping over 2-4 hours

Stage 3 — Severe Dehydration (>5% body weight loss):
  Symptoms:
    - No urine output or very dark urine
    - Sunken eyes
    - Rapid, weak pulse
    - Low blood pressure
    - Confusion, delirium
    - Fainting
    - Skin tenting (pinched skin stays raised)
    - In children: no tears when crying
  MEDICAL EMERGENCY — seek immediate medical attention
  Treatment: IV fluid replacement in hospital

Urine Color Chart:
  1. Clear/pale straw     → Well hydrated
  2. Light yellow          → Adequately hydrated
  3. Yellow                → Normal, drink soon
  4. Dark yellow           → Mildly dehydrated — drink now
  5. Amber/honey           → Moderately dehydrated
  6. Dark amber/brown      → Severely dehydrated — seek help
  Note: B vitamins, beets, medications can alter color

Quick Self-Tests:
  Skin turgor: pinch back of hand, skin should snap back instantly
  Capillary refill: press fingernail, color returns in <2 seconds
  Weight: weigh before/after exercise — each kg lost ≈ 1L sweat
EOF
}

cmd_exercise() {
    cat << 'EOF'
=== Exercise Hydration Strategy ===

Pre-Exercise (2-4 hours before):
  Drink 500-600mL (17-20 oz) 2-4 hours before
  Then 200-300mL (7-10 oz) 10-20 minutes before
  Goal: start well-hydrated (pale yellow urine)
  Avoid chugging — spread intake over the pre-exercise window

During Exercise:
  General: 150-250mL (5-8 oz) every 15-20 minutes
  Adjust by intensity:
    Light (walking, yoga):        100-200 mL/hour
    Moderate (jogging, cycling):  400-800 mL/hour
    Intense (racing, team sport): 800-1200 mL/hour
    Ultra/heat:                   up to 1500 mL/hour

  When to add electrolytes:
    < 60 min exercise: water is sufficient
    60-90 min: water + light electrolytes
    > 90 min: electrolyte sports drink essential
    Heavy sweater: sodium supplement needed (salt tabs or drink)

  Sports Drink Composition (optimal):
    Carbohydrates: 4-8% (40-80g/L) — glucose + fructose mix
    Sodium: 300-800 mg/L
    Potassium: 75-200 mg/L
    Osmolality: 200-300 mOsm/kg (hypotonic to isotonic)

Post-Exercise Recovery:
  Weigh before and after exercise
  Each 1 kg lost = 1L of sweat
  Replace 150% of weight lost over 2-4 hours
    Lost 2 kg → drink 3L over 2-4 hours

  Recovery drink priorities:
    Fluid (water or electrolyte drink)
    Sodium (to retain the fluid you drink)
    Carbohydrates (replenish glycogen)
    Protein (muscle recovery, within 30 min)
    Example: chocolate milk (surprisingly optimal ratio)

Sweat Rate Calculation:
  1. Weigh yourself nude before exercise (kg)
  2. Exercise for 1 hour (no bathroom, track fluid intake)
  3. Weigh yourself nude after
  4. Sweat rate = (Pre-weight - Post-weight) + fluid consumed
  Example: 70.0 kg → 69.2 kg, drank 0.5L
  Sweat rate = 0.8 + 0.5 = 1.3 L/hour
EOF
}

cmd_rehydrate() {
    cat << 'EOF'
=== Rehydration Protocols ===

WHO Oral Rehydration Solution (ORS):
  The gold standard for treating dehydration from diarrhea/vomiting
  Formula (per liter of clean water):
    Salt (NaCl):        3.5g (¾ tsp)
    Sugar (glucose):    20g (4 tsp)
    Baking soda:        2.5g (½ tsp)  — or trisodium citrate 2.9g
    Potassium chloride: 1.5g (salt substitute)

  Simplified WHO-ORS:
    1L water + 6 tsp sugar + ½ tsp salt
    (less precise but effective in emergencies)

  How to use:
    Sip small amounts frequently (not big gulps)
    Children: 1 teaspoon every 1-2 minutes
    Adults: 200-400mL after each loose stool
    Continue until urine is pale yellow

Illness Rehydration:
  Fever: add 500mL per degree above 37°C (per day)
  Vomiting: wait 15-20 min after episode, then small sips
  Diarrhea: replace with ORS, avoid plain water (no electrolytes)
  Food poisoning: ORS + BRAT diet (banana, rice, applesauce, toast)

  What to avoid when sick:
    - Sugary sodas (osmotic diarrhea)
    - Caffeine (mild diuretic)
    - Alcohol (dehydrating)
    - Fruit juice undiluted (too much sugar)
    - Dairy if lactose intolerant

Hangover Rehydration:
  Alcohol blocks ADH → excess urine production
  Each alcoholic drink → ~120mL extra urine (net fluid loss)
  Prevention: 1 glass water per alcoholic drink during the night
  Morning after protocol:
    1. 500mL water with electrolytes immediately
    2. Light breakfast with salt (eggs, toast, broth)
    3. Continue sipping water through the day
    4. Avoid coffee until baseline hydration restored
    5. Coconut water is excellent (natural electrolytes + potassium)

Heat Exhaustion Recovery:
  1. Move to shade/cool area
  2. Lie down, elevate legs
  3. Remove excess clothing
  4. Cool with wet cloths on neck, armpits, groin
  5. Sip cool (not ice cold) electrolyte water
  6. If no improvement in 30 min → emergency services
EOF
}

cmd_myths() {
    cat << 'EOF'
=== Hydration Myths Debunked ===

Myth: "Drink 8 glasses of water a day"
  Reality: No scientific basis for this specific number
  Origin: 1945 US Food and Nutrition Board recommendation
  (included water from ALL sources, including food)
  Truth: needs vary wildly by body size, activity, climate, diet
  Better rule: drink when thirsty + check urine color

Myth: "Clear urine means you're well hydrated"
  Reality: completely clear urine may mean OVER-hydration
  Target: pale straw color (not clear, not dark)
  Clear urine = dilute urine = potentially flushing electrolytes
  Exception: some medications change urine color regardless

Myth: "Coffee and tea dehydrate you"
  Reality: caffeine is a mild diuretic, but the fluid content
  far outweighs the diuretic effect
  Studies show: regular caffeine consumers develop tolerance
  Net hydration: a cup of coffee still adds net positive fluid
  Caution: >400mg caffeine/day may have mild dehydrating effect

Myth: "You can't drink too much water"
  Reality: overhydration (hyponatremia) can be FATAL
  Occurs when: blood sodium drops below 135 mEq/L
  Risk groups: marathon runners, military, ecstasy users
  Symptoms: nausea, headache, confusion, seizures
  Prevention: don't drink more than 1L/hour consistently
  Replace electrolytes during prolonged sweating

Myth: "Thirst means you're already dehydrated"
  Reality: partly true but overstated
  Thirst kicks in at ~1-2% dehydration (very mild)
  For most people, drinking when thirsty is perfectly adequate
  Exception: elderly (thirst mechanism weakens with age)
  Exception: during intense exercise (thirst lags behind need)

Myth: "Cold water is dangerous during exercise"
  Reality: cold water (5-10°C) is actually BETTER during exercise
  Absorbs faster than warm water
  Helps cool core body temperature
  People drink more of it voluntarily (tastes better when hot)
  The "cold water shock" myth has no scientific support

Myth: "Sparkling water doesn't hydrate as well"
  Reality: sparkling water hydrates identically to still water
  CO₂ doesn't affect absorption
  May cause bloating → people drink less (only concern)
  No effect on bone density (old myth debunked)
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Daily Hydration Checklist ===

Morning Routine:
  [ ] Drink 500mL water within 30 min of waking
  [ ] Check urine color (aim for pale straw)
  [ ] Prepare water bottle for the day

Throughout the Day:
  [ ] Keep water bottle visible and within reach
  [ ] Sip water before each meal (250mL, 30 min prior)
  [ ] Drink water with every meal
  [ ] Set reminders if you forget to drink (every 1-2 hours)
  [ ] Eat at least 2 water-rich foods (fruit, vegetables, soup)

Exercise Days:
  [ ] Pre-hydrate: 500mL 2 hours before exercise
  [ ] During: 150-250mL every 15-20 min
  [ ] Post: weigh yourself, replace 150% of weight lost
  [ ] Add electrolytes if exercising >60 minutes

Environmental Adjustments:
  [ ] Hot day: add 500-1000mL to baseline
  [ ] Air-conditioned office: still drink (AC dehydrates)
  [ ] Flying: drink 250mL per hour of flight
  [ ] High altitude: increase by 500mL

Tracking Methods:
  1. Water bottle method:
     Buy a marked 1L bottle, aim to finish it 2-3 times/day
  2. Rubber band method:
     Put 8 rubber bands on bottle, remove one per glass
  3. App tracking:
     WaterMinder, Plant Nanny, My Water (gamified)
  4. Urine color:
     Simplest — if pale yellow, you're on track

Signs You're On Track:
  ✓ Urine is pale straw color
  ✓ No persistent thirst
  ✓ Skin is supple (no tenting)
  ✓ Energy levels stable through the day
  ✓ Urinating every 2-4 hours
  ✓ No headaches from dehydration

Signs You Need More:
  ✗ Dark urine (after ruling out supplements/meds)
  ✗ Dry mouth or lips
  ✗ Afternoon headaches
  ✗ Feeling sluggish or foggy
  ✗ Muscle cramps during/after exercise
  ✗ Constipation
EOF
}

show_help() {
    cat << EOF
hydrate v$VERSION — Hydration & Fluid Balance Reference

Usage: script.sh <command>

Commands:
  intro        Why water matters and body fluid regulation
  intake       Daily water intake guidelines and adjustment factors
  electrolytes Sodium, potassium, magnesium, calcium guide
  signs        Dehydration stages — mild, moderate, severe
  exercise     Exercise hydration — pre, during, post workout
  rehydrate    Rehydration protocols — ORS, illness, hangover
  myths        Hydration myths debunked
  checklist    Daily hydration tracking checklist
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    intake)       cmd_intake ;;
    electrolytes) cmd_electrolytes ;;
    signs)        cmd_signs ;;
    exercise)     cmd_exercise ;;
    rehydrate)    cmd_rehydrate ;;
    myths)        cmd_myths ;;
    checklist)    cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "hydrate v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
