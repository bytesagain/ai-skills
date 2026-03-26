#!/usr/bin/env bash
# fitness-plan — Exercise Science & Training Reference
set -euo pipefail
VERSION="6.0.0"

cmd_intro() { cat << 'EOF'
# Exercise Science & Training — Overview

## Training Principles
  Progressive Overload:
    Gradually increase stress (weight, reps, sets, frequency) over time
    Without overload, adaptation stalls — the body needs a reason to grow
    Methods: Add 2.5-5 lbs per session (novice), per week (intermediate)

  Specificity (SAID Principle):
    Specific Adaptation to Imposed Demands
    Want to bench more? Bench more. Want to run faster? Sprint.
    Training must match the goal (strength, endurance, power, flexibility)

  Recovery:
    Muscle growth happens during rest, not during training
    Sleep: 7-9 hours (growth hormone peaks during deep sleep)
    Between sessions: 48-72 hours for same muscle group
    Deload: Reduce volume/intensity every 4-6 weeks

  Periodization:
    Linear: Increase load weekly (beginner, 3-6 months)
    Undulating: Vary intensity daily (Mon heavy, Wed moderate, Fri light)
    Block: 3-4 week blocks focused on one quality (hypertrophy→strength→power)

## Energy Systems
  Phosphagen (ATP-CP):  0-10 seconds, max power (sprints, 1RM lifts)
  Glycolytic:           10s-2 min, high intensity (400m, sets of 8-12)
  Oxidative:            2+ min, sustained effort (distance running, cycling)
  Training specificity applies to energy systems too
EOF
}

cmd_standards() { cat << 'EOF'
# Training Standards & Guidelines

## ACSM (American College of Sports Medicine) Guidelines
  Resistance Training:
    Frequency: 2-3 days/week per muscle group
    Intensity: 60-80% 1RM for hypertrophy, 80-100% for strength
    Volume: 2-4 sets of 6-12 reps (hypertrophy), 2-6 sets of 1-6 reps (strength)
    Rest: 1-2 min (hypertrophy), 2-5 min (strength), 30-90s (endurance)

  Cardiovascular Exercise:
    150 min/week moderate OR 75 min/week vigorous
    3-5 days/week
    RPE 12-16 (moderate to hard)
    Can be accumulated in 10+ min bouts

## Rep Ranges by Goal
  Strength:    1-5 reps @ 85-100% 1RM, 3-5 sets, 3-5 min rest
  Hypertrophy: 6-12 reps @ 65-85% 1RM, 3-5 sets, 1-2 min rest
  Endurance:   12-20+ reps @ 50-65% 1RM, 2-3 sets, 30-60s rest
  Power:       1-5 reps @ 30-60% 1RM (explosive), 3-5 sets, 2-5 min rest

## RPE Scale (Rate of Perceived Exertion)
  RPE 6:  No exertion at all (sitting)
  RPE 7:  Extremely light
  RPE 9:  Very light (easy walking)
  RPE 11: Light (comfortable pace)
  RPE 13: Somewhat hard (can talk, slightly breathless)
  RPE 15: Hard (short sentences only)
  RPE 17: Very hard (a few words between breaths)
  RPE 19: Extremely hard (nearly maximal)
  RPE 20: Maximal exertion

## RIR Scale (Reps In Reserve) — Modern Alternative
  RIR 0:  Failure (cannot do another rep)
  RIR 1:  Could maybe do 1 more
  RIR 2:  Could definitely do 2 more
  RIR 3:  3 reps left in the tank
  Training recommendation: Stay at RIR 1-3 for most sets (avoid failure)
  Why: Failure increases fatigue disproportionately vs gains
EOF
}

cmd_troubleshooting() { cat << 'EOF'
# Training Troubleshooting

## Plateau Breaking Strategies
  Problem: Weights haven't increased in 2+ weeks
  Strategies:
    1. Deload: Drop volume 40-50% for 1 week, then return
    2. Change rep scheme: If stuck at 5x5, try 3x8 or 4x6
    3. Add variations: Pause squats, tempo bench, deficit deadlifts
    4. Increase frequency: Train movement 3x/week instead of 2x
    5. Fix weak links: Identify sticking point, train accessories
    6. Eat more: Caloric surplus drives strength gains (most common fix)

## Overtraining Syndrome Signs
  Physical: Persistent fatigue, declining performance, elevated resting HR
  Immune: Frequent colds/infections, slow wound healing
  Psychological: Loss of motivation, irritability, disrupted sleep
  Performance: Weights going down despite consistent training
  Recovery: Takes 2-4 weeks of reduced training
  Prevention: Track RPE/RIR, schedule deloads, monitor sleep quality

## Common Form Errors
  Squat:
    - Knees caving (valgus): Strengthen glutes, use band around knees
    - Butt wink: Tight hip flexors, reduce depth slightly, widen stance
    - Forward lean: Weak quads, front squat to fix motor pattern
  Bench Press:
    - Elbows flared 90°: Tuck to 45°, saves shoulders
    - No arch: Mild thoracic arch is safe and improves leverage
    - Bouncing off chest: Pause briefly, control the eccentric
  Deadlift:
    - Rounding lower back: Engage lats, chest up, reduce weight
    - Hips shooting up first: Weak quads, practice deficit deadlifts
    - Hitching: Bar stops moving, knees extend before hips = no good
  Overhead Press:
    - Leaning back excessively: Brace core, squeeze glutes
    - Bar path around face: Push head through once bar clears
EOF
}

cmd_performance() { cat << 'EOF'
# Training Splits & Advanced Techniques

## Training Split Comparison
  Full Body (3 days/week):
    Best for: Beginners, time-limited, strength focus
    Example: Mon/Wed/Fri — Squat, Bench, Row, OHP, Deadlift
    Recovery: Each muscle hit 3x/week with moderate volume
    Programs: Starting Strength, StrongLifts 5x5, GZCLP

  Upper/Lower (4 days/week):
    Best for: Intermediates, balanced approach
    Example: Mon Upper, Tue Lower, Thu Upper, Fri Lower
    Recovery: Each muscle hit 2x/week with higher volume
    Programs: PHUL, Lyle McDonald Generic Bulk, 5/3/1 BBB

  Push/Pull/Legs (6 days/week):
    Best for: Intermediate-advanced, maximum volume
    Push: Chest, shoulders, triceps
    Pull: Back, biceps, rear delts
    Legs: Quads, hamstrings, glutes, calves
    Programs: PPL Reddit, PHAT, Arnold Split variant

## Deload Protocols
  Option A: Same exercises, 50% volume (half the sets)
  Option B: Same exercises, 60% intensity (lighter weight)
  Option C: Active recovery (light cardio, mobility work only)
  Frequency: Every 4-6 weeks or when RPE consistently >9
  Don't skip deloads — they enable the next training block

## Advanced Intensity Techniques
  Supersets:      Pair opposing muscles (bench + rows) — saves time
  Drop sets:      Reduce weight 20-30%, continue to failure, repeat
  Rest-pause:     Hit failure, rest 10-15 seconds, continue for 2-4 more reps
  Myo-reps:       Activation set near failure, 3-5 mini-sets of 3-5 reps (20s rest)
  Tempo training: Slow eccentrics (3-5 seconds) for hypertrophy
  Cluster sets:   Heavy singles with 15-30 second rest (strength)
  Warning: Advanced techniques increase fatigue; use sparingly (1-2 sets/session)
EOF
}

cmd_security() { cat << 'EOF'
# Injury Prevention & Safety

## Warm-Up Protocol
  General (5-10 min):
    - Light cardio: Rowing, cycling, jumping jacks
    - Dynamic stretching: Leg swings, arm circles, hip circles
    - DO NOT static stretch before lifting (reduces force production)

  Specific (5-10 min):
    - Empty bar work for the first exercise
    - Ramp-up sets: 50% x 8, 60% x 5, 70% x 3, 80% x 2, then work sets
    - Practice the movement pattern before loading

## Mobility Work
  Daily maintenance (10-15 min):
    - Hip flexor stretch: 90/90, couch stretch
    - Thoracic extension: Foam roller, cat-cow
    - Shoulder: Band pull-aparts, face pulls, wall slides
    - Ankle: Wall ankle stretch (knee to wall test: >10cm = good)

  Post-workout (5-10 min):
    - Static stretching now is fine (flexibility gains)
    - Hold 30-60 seconds per stretch
    - Focus on muscles trained that session

## Load Progression Guidelines
  Beginner (0-6 months):
    - Add 5 lbs/session upper body, 10 lbs/session lower body
    - Linear progression works until it doesn't
  Intermediate (6 months - 2 years):
    - Add 5 lbs/week upper, 5-10 lbs/week lower
    - Need periodization (weekly undulation or block)
  Advanced (2+ years):
    - Add 5 lbs/month or less
    - Advanced programming required (DUP, conjugate, RPE-based)

## When to Stop a Set
  STOP if: Sharp pain (not muscle burn), joint clicking with pain,
  dizziness, loss of form on consecutive reps
  DO NOT push through: Lower back rounding on deadlifts,
  shoulder pain on pressing, knee pain that worsens with movement
  Muscle soreness ≠ injury. DOMS is normal for 24-72 hours.
  Joint pain > 48 hours after training = see a professional
EOF
}

cmd_migration() { cat << 'EOF'
# Training Program Progressions

## Beginner → Intermediate Transition
  Signs you've outgrown beginner programs:
    - Can't add weight every session anymore
    - Workouts take >90 minutes due to rest times
    - Stalling on all lifts despite deloads
  Typical timeline: 3-9 months of consistent training
  Strength benchmarks (rough, bodyweight-dependent):
    Male: Squat 1.25x BW, Bench 1x BW, Deadlift 1.5x BW
    Female: Squat 1x BW, Bench 0.65x BW, Deadlift 1.25x BW
  Transition: Move from session-to-session progression to weekly

## Intermediate → Advanced
  Signs:
    - Weekly progression stalls
    - Need dedicated blocks for different qualities
    - Training age 2-4+ years
  Strength benchmarks (rough):
    Male: Squat 2x BW, Bench 1.5x BW, Deadlift 2.5x BW
    Female: Squat 1.5x BW, Bench 1x BW, Deadlift 2x BW
  Programs: Juggernaut Method, GZCL, 5/3/1 advanced, Westside Conjugate

## Recommended Program Progression
  Months 1-3:     Starting Strength or StrongLifts 5x5 (linear LP)
  Months 3-6:     GZCLP or 5/3/1 for Beginners (modified LP)
  Months 6-18:    5/3/1 BBB, PHUL, or nSuns (weekly progression)
  Months 18-36:   GZCL UHF, Juggernaut, or custom RPE-based
  Year 3+:        Coach-designed or self-designed periodized programs

## Sport-Specific Adaptation
  Powerlifting:  SBD focus, peaking cycle before meet, attempt selection
  Bodybuilding:  Hypertrophy blocks, isolation work, posing practice
  CrossFit:      Mixed modal, high-skill gymnastics + weightlifting
  Running:        Easy runs (80%), speed work (20%), gradual mileage increase
  General health: 2-3x strength + 150 min cardio + daily movement
EOF
}

cmd_cheatsheet() { cat << 'EOF'
# Training Quick Reference

## Compound Lift Technique Cues
  Squat:  "Chest up, knees out, sit back, drive through heels"
  Bench:  "Arch, retract scapulae, leg drive, bar to nipple line"
  Deadlift: "Wedge in, lats tight, push floor away, lock hips"
  OHP:    "Elbows under bar, brace core, push head through"
  Row:    "Chest to bench, pull to lower chest, squeeze shoulder blades"

## Plate Math (per side, standard barbell = 45 lbs)
  Bar only: 45 lbs
  +25 each side: 95 lbs
  +45 each side: 135 lbs (1 plate)
  +45+25: 185 lbs      +45+35: 205 lbs
  +45+45: 225 lbs (2 plates)
  +45+45+25: 275 lbs   +45+45+35: 295 lbs
  +45+45+45: 315 lbs (3 plates)
  +45+45+45+45: 405 lbs (4 plates)

## 1RM Estimation (Epley Formula)
  1RM = Weight × (1 + Reps / 30)
  Example: 200 lbs × 5 reps → 1RM ≈ 200 × (1 + 5/30) = 233 lbs
  Other formulas: Brzycki, Lombardi, O'Conner (all ±5% accuracy)
  Most accurate with 1-10 reps (>10 reps = less reliable)

## Wilks Score (Relative Strength)
  Compares lifters across weight classes
  Formula: Wilks = Total × Coefficient(bodyweight)
  Competitive totals: >300 Wilks (male), >250 Wilks (female)
  Modern alternative: DOTS score (better at extremes of bodyweight)

## Heart Rate Zones
  Zone 1 (50-60% max HR): Recovery, fat burning
  Zone 2 (60-70% max HR): Aerobic base, easy conversation
  Zone 3 (70-80% max HR): Tempo, can speak short sentences
  Zone 4 (80-90% max HR): Threshold, a few words only
  Zone 5 (90-100% max HR): Maximum effort, cannot speak
  Max HR estimate: 220 - age (rough) or 208 - 0.7 × age (better)
EOF
}

cmd_faq() { cat << 'EOF'
# Exercise Science — FAQ

Q: How much protein do I need?
A: For muscle building: 1.6-2.2 g per kg bodyweight per day.
   Example: 80 kg person → 128-176 g protein/day.
   Spread across 3-5 meals (30-50g per meal for optimal MPS).
   Whey protein is convenient but whole foods work just as well.
   Higher end of range when in caloric deficit (to preserve muscle).

Q: Should I do cardio if I want to build muscle?
A: Yes, but manage volume. 2-3 sessions/week of 20-30 min moderate.
   Cardio does NOT kill gains unless excessive (>5 hours/week).
   Separate cardio and lifting by 6+ hours if possible.
   Low-impact preferred: Cycling, swimming, walking (less interference).
   Zone 2 cardio improves recovery between lifting sessions.

Q: How long should I rest between sets?
A: Strength (1-5 reps): 3-5 minutes (full ATP replenishment).
   Hypertrophy (6-12 reps): 90 seconds to 3 minutes.
   Endurance (12+ reps): 30-90 seconds.
   Compound lifts need more rest than isolation exercises.
   Rest until you can perform the next set with good form.

Q: Is muscle soreness a sign of a good workout?
A: No. DOMS (Delayed Onset Muscle Soreness) indicates novelty,
   not effectiveness. As your body adapts, soreness decreases.
   You can build muscle without ever being sore.
   Excessive soreness means you did too much too soon.
   Slight soreness (can function normally) is fine.

Q: Should I stretch before or after lifting?
A: Before: Dynamic stretching only (leg swings, arm circles).
   Static stretching before lifting REDUCES force production 5-10%.
   After: Static stretching is fine and helps flexibility.
   Daily: 10-15 min mobility work improves long-term performance.
   Foam rolling: OK before or after, reduces perceived soreness.
EOF
}

cmd_help() {
    echo "fitness-plan v$VERSION — Exercise Science & Training Reference"
    echo ""
    echo "Usage: fitness-plan <command>"
    echo ""
    echo "Commands:"
    echo "  intro           Training principles, energy systems"
    echo "  standards       ACSM guidelines, rep ranges, RPE/RIR scales"
    echo "  troubleshooting Plateaus, overtraining, form errors"
    echo "  performance     Training splits, deloads, intensity techniques"
    echo "  security        Warm-up, mobility, injury prevention"
    echo "  migration       Beginner→intermediate→advanced progressions"
    echo "  cheatsheet      Lift cues, plate math, 1RM formulas, HR zones"
    echo "  faq             Protein, cardio, rest times, soreness"
    echo "  help            Show this help"
}

case "${1:-help}" in
    intro) cmd_intro ;; standards) cmd_standards ;;
    troubleshooting) cmd_troubleshooting ;; performance) cmd_performance ;;
    security) cmd_security ;; migration) cmd_migration ;;
    cheatsheet) cmd_cheatsheet ;; faq) cmd_faq ;;
    help|--help|-h) cmd_help ;;
    *) echo "Unknown: $1"; echo "Run: fitness-plan help" ;;
esac
