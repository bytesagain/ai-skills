#!/usr/bin/env bash
# stretch — Stretching & Flexibility Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Stretching Science ===

Stretching is the deliberate lengthening of muscles and tendons to
improve flexibility, range of motion, and movement quality.

Types of Stretching:
  Dynamic     Controlled movement through range of motion
              Best for: pre-workout warm-up
              Example: leg swings, arm circles, walking lunges

  Static      Holding a stretched position for 15-60 seconds
              Best for: post-workout cooldown, flexibility gains
              Example: hamstring hold, quad stretch, chest doorway stretch

  PNF         Contract-relax cycles to trick the stretch reflex
              Best for: maximum flexibility gains, rehab
              Example: contract hamstring 6s → relax → deeper stretch

  Ballistic   Bouncing at end range (NOT recommended for most people)
              Risk of injury, minimal benefit over dynamic stretching

  Active      Using agonist muscles to stretch antagonist
              Example: lifting leg with hip flexors to stretch hamstrings

Physiology:
  Muscle Spindle   Detects stretch rate → triggers protective contraction
  Golgi Tendon     Detects tension → triggers relaxation (autogenic inhibition)
  Creep            Gradual lengthening of fascia under sustained load
  Thixotropy       Tissues become more pliable with warmth and movement

Timing Rules:
  Before exercise  → Dynamic stretching (5-10 min)
  After exercise   → Static stretching (10-15 min)
  Separate session → Deep flexibility work (20-30 min)

  ⚠ Static stretching BEFORE explosive activity reduces power output
    by 3-5%. Save it for after.

Key Principles:
  1. Warm up before stretching (light cardio 5 min)
  2. Never stretch through sharp pain — discomfort is OK, pain is not
  3. Breathe deeply — exhale into the stretch
  4. Hold static stretches 30-60s for flexibility gains
  5. Consistency beats intensity — daily gentle > weekly aggressive
EOF
}

cmd_dynamic() {
    cat << 'EOF'
=== Dynamic Stretching Routines ===

Dynamic stretches use controlled movement through full range of motion.
Perform before workouts to activate muscles and prime the nervous system.

--- Lower Body Dynamic Warm-Up (5 minutes) ---

1. Leg Swings (forward/back)
   Stand on one leg, swing other forward and back
   10 swings each leg, gradually increase range
   Targets: hamstrings, hip flexors

2. Lateral Leg Swings
   Swing leg side to side across body
   10 swings each leg
   Targets: adductors, abductors

3. Walking Lunges with Twist
   Step into lunge, rotate torso over front knee
   10 steps each side
   Targets: hip flexors, quads, obliques

4. High Knees
   March in place, driving knees to chest
   20 reps (10 each side)
   Targets: hip flexors, core

5. Butt Kicks
   Jog in place, heels to glutes
   20 reps (10 each side)
   Targets: quadriceps

6. Inchworms
   Stand → fold forward → walk hands to plank → walk feet to hands
   5 reps
   Targets: hamstrings, shoulders, core

--- Upper Body Dynamic Warm-Up (5 minutes) ---

1. Arm Circles
   Small → large circles, forward then backward
   10 each direction
   Targets: deltoids, rotator cuff

2. Band Pull-Aparts
   Hold resistance band at shoulder width, pull apart
   15 reps
   Targets: rear deltoids, rhomboids

3. Cat-Cow
   On all fours, alternate arching and rounding spine
   10 reps
   Targets: thoracic spine, erectors

4. Thread the Needle
   From all fours, reach one arm under body, then rotate open
   5 each side
   Targets: thoracic rotation, lats

5. Scapular Push-Ups
   In plank, protract and retract shoulder blades
   10 reps
   Targets: serratus anterior, scapular stabilizers
EOF
}

cmd_static() {
    cat << 'EOF'
=== Static Stretching Guide ===

Hold each stretch 30-60 seconds. Breathe deeply. No bouncing.
Perform after workouts or as a separate flexibility session.

--- Lower Body ---

Hamstring Stretch (Standing):
  Place heel on elevated surface (bench/step)
  Hinge at hips, keep back flat
  Feel stretch behind the thigh
  Hold 30-60s each leg

Hip Flexor Stretch (Half-Kneeling):
  Kneel on one knee, other foot forward
  Squeeze glute of kneeling leg, shift hips forward
  Optional: raise arm on same side, lean slightly away
  Hold 30-60s each side

Quad Stretch (Standing):
  Grab ankle behind you, pull heel toward glute
  Keep knees together, hips square
  Hold 30-60s each leg

Pigeon Pose (Glutes/Piriformis):
  From push-up position, bring one knee forward to same-side wrist
  Lower hips toward floor, extend back leg
  Hold 60-90s each side

Calf Stretch (Wall):
  Hands on wall, one foot back with heel down
  Straight leg = gastrocnemius
  Bent knee = soleus
  Hold 30s each position, each leg

--- Upper Body ---

Chest Stretch (Doorway):
  Place forearm on doorframe at 90°
  Step through doorway until stretch in chest
  Hold 30-60s each side

Lat Stretch (Hang/Doorway):
  Grab overhead bar or top of doorframe
  Let body hang, shift hips away from arm
  Hold 30-60s each side

Tricep Stretch:
  Reach one arm overhead, bend elbow
  Use other hand to gently press elbow back
  Hold 30s each arm

Upper Trap Stretch:
  Tilt head to one side, ear toward shoulder
  Gently press with same-side hand
  Hold 30s each side, DO NOT force
EOF
}

cmd_pnf() {
    cat << 'EOF'
=== PNF Stretching (Proprioceptive Neuromuscular Facilitation) ===

PNF produces the greatest flexibility gains of any stretching method.
It exploits the Golgi tendon organ's autogenic inhibition reflex.

How It Works:
  1. Stretch the muscle to its current limit
  2. Contract the stretched muscle isometrically (6-10 seconds)
  3. Relax the muscle
  4. Immediately stretch deeper into the new range
  5. Repeat 2-4 times

Main PNF Techniques:

--- Contract-Relax (CR) ---
  1. Partner stretches hamstring to limit
  2. Client pushes leg against partner's resistance (6s isometric)
  3. Client relaxes, partner pushes into deeper stretch
  4. Repeat 3 times
  Mechanism: Golgi tendon organ triggers muscle relaxation

--- Contract-Relax-Agonist-Contract (CRAC) ---
  1. Stretch hamstring to limit
  2. Contract hamstring against resistance (6s)
  3. Relax hamstring
  4. Contract quadricep to pull deeper into stretch
  5. Hold new range 30s
  Mechanism: reciprocal inhibition + autogenic inhibition
  Most effective PNF technique

--- Hold-Relax ---
  Similar to CR but uses a static hold against resistance
  instead of a concentric contraction
  Better for injured or sensitive muscles

Solo PNF (Without Partner):
  Hamstring: Loop strap around foot while lying down
    - Pull leg up to stretch limit
    - Push foot into strap for 6s (hamstring contracts)
    - Relax and pull deeper
  Hip flexor: Use wall or doorframe as resistance
  Chest: Use doorframe, press into frame for 6s, then step through

Guidelines:
  - Always warm up first (5-10 min light cardio)
  - Contract at 60-80% max effort (not 100%)
  - Never use PNF on acute injuries
  - 2-3 sessions per week maximum
  - Best gains: 2-4 contract-relax cycles per muscle
  - Allow 48 hours between intense PNF sessions
EOF
}

cmd_mobility() {
    cat << 'EOF'
=== Joint Mobility Drills ===

Mobility = strength through full range of motion.
Unlike passive stretching, mobility drills build active control.

--- Shoulder Mobility ---

Wall Slides:
  Back against wall, arms in "goal post" position
  Slide arms up and down keeping contact with wall
  3 × 10 reps
  Tests: if you can't touch wall with wrists → tight pecs/lats

Shoulder CARs (Controlled Articular Rotations):
  Slowly trace the largest circle your shoulder can make
  Keep body still, only shoulder moves
  5 circles each direction, each arm
  This is joint health maintenance

Face Pulls (with band):
  Pull band to face, elbows high
  External rotate at end position
  3 × 15 reps
  Targets: rotator cuff, lower trap, rhomboid

--- Hip Mobility ---

90/90 Hip Switches:
  Sit with both legs in 90° angles
  Rotate from internal to external rotation
  10 switches each direction
  Gold standard hip mobility drill

Deep Squat Hold:
  Sit in deep squat, elbows pressing knees out
  Hold 60-120 seconds total
  If heels rise → tight calves; elevate heels until mobility improves

Hip CARs:
  Standing on one leg, make largest hip circle possible
  5 circles each direction, each leg
  Maintain pelvis neutral (don't rotate trunk)

--- Thoracic Spine ---

Open Book:
  Side-lying, knees stacked at 90°
  Rotate top arm across body to other side
  Follow hand with eyes
  10 reps each side

Foam Roller Extension:
  Roll placed across upper back
  Arms overhead, extend over roller
  5 spots along thoracic spine, 5 extensions each

--- Ankle Mobility ---

Wall Ankle Dorsiflexion:
  Foot 4-5 inches from wall, drive knee forward over toe
  Knee should reach wall without heel lifting
  Goal: 5 inches = good, <3 inches = restricted
  3 × 10 reps each ankle
EOF
}

cmd_routines() {
    cat << 'EOF'
=== Complete Stretching Routines ===

--- Morning Wake-Up (10 min) ---
  1. Cat-Cow                    10 reps
  2. Thread the Needle          5 each side
  3. World's Greatest Stretch   5 each side
  4. Downward Dog pedal feet    30 seconds
  5. Standing side bend         15s each side
  6. Neck circles               5 each direction
  All movements gentle, no forcing

--- Desk Worker Rescue (8 min, every 2 hours) ---
  1. Chest doorway stretch      30s each side
  2. Upper trap stretch         20s each side
  3. Seated figure-4 (piriformis) 30s each side
  4. Standing hip flexor lunge  30s each side
  5. Wrist extensor stretch     20s each hand
  6. Chin tucks                 10 reps
  Reverses the "desk posture": rounded shoulders, tight hip flexors

--- Pre-Run Warm-Up (7 min) ---
  1. Walking lunges             10 each leg
  2. Leg swings (forward/back)  10 each leg
  3. Lateral leg swings         10 each leg
  4. High knees                 20 total
  5. Butt kicks                 20 total
  6. A-skips                    10 each leg
  7. Build-up strides           3 × 50m

--- Post-Lift Cooldown (12 min) ---
  1. Foam roll quads            60s
  2. Foam roll lats             60s
  3. Hamstring stretch          45s each leg
  4. Hip flexor stretch         45s each side
  5. Pigeon pose                60s each side
  6. Chest stretch              30s each side
  7. Lat stretch                30s each side
  8. Child's pose               60s

--- Deep Flexibility Session (25 min) ---
  Hold each stretch 60-90 seconds, 2 rounds:
  1. Forward fold (hamstrings)
  2. Pigeon (glutes/hip rotators)
  3. Frog pose (adductors)
  4. Low lunge (hip flexors)
  5. Saddle pose (quads)
  6. Puppy pose (lats/shoulders)
  7. Chest opener on foam roller
  8. Seated twist (spine)
  Best done in evening or as standalone session
EOF
}

cmd_anatomy() {
    cat << 'EOF'
=== Stretching Anatomy — Key Muscle Groups ===

--- Posterior Chain ---
Hamstrings (biceps femoris, semitendinosus, semimembranosus):
  Function: knee flexion, hip extension
  Tight from: sitting, running, deadlifts
  Stretch: forward fold, supine leg raise

Calves (gastrocnemius + soleus):
  Gastrocnemius: crosses knee — stretch with straight leg
  Soleus: below knee — stretch with bent knee
  Tight from: high heels, running, standing
  Stretch: wall calf stretch, downward dog

Glutes (gluteus maximus, medius, minimus):
  Function: hip extension, abduction, external rotation
  Tight from: sitting (paradoxically — weakened + shortened)
  Stretch: pigeon pose, figure-4, knee-to-chest

--- Anterior Chain ---
Hip Flexors (psoas, iliacus, rectus femoris):
  The most commonly tight muscle in modern humans
  Tight from: sitting 8+ hours/day
  Effects: anterior pelvic tilt, lower back pain
  Stretch: half-kneeling lunge, couch stretch

Quadriceps (rectus femoris, vastus group):
  Function: knee extension, hip flexion (rectus femoris only)
  Stretch: standing quad pull, couch stretch

Pectorals (pec major + minor):
  Tight from: desk work, bench press focus
  Effects: rounded shoulders, impingement risk
  Stretch: doorway stretch, foam roller chest opener

--- Lateral/Rotational ---
IT Band / TFL:
  Not actually stretchable (it's fascia, not muscle)
  Foam roll the surrounding muscles instead
  Address: TFL, vastus lateralis, glute medius

Adductors (inner thigh):
  Function: hip adduction, stabilization
  Tight from: sitting with legs together
  Stretch: frog pose, wide-legged forward fold, cossack squat

Lats (latissimus dorsi):
  Function: shoulder extension, adduction, internal rotation
  Tight from: desk work, pull-ups, swimming
  Stretch: hang from bar, child's pose with reach
EOF
}

cmd_mistakes() {
    cat << 'EOF'
=== Common Stretching Mistakes ===

1. Static Stretching Before Explosive Activity
   Why bad: Reduces power output by 3-5%, dulls stretch reflex
   Fix: Use dynamic stretching before workouts
   Exception: If a muscle is so tight it limits range, brief static OK

2. Bouncing (Ballistic Stretching)
   Why bad: Triggers stretch reflex → muscle contracts → micro-tears
   Fix: Smooth, steady holds for static; controlled motion for dynamic

3. Holding Breath
   Why bad: Increases muscle tension, raises blood pressure
   Fix: Slow, deep breaths. Exhale to deepen the stretch

4. Stretching Cold Muscles
   Why bad: Cold tissue is less pliable → higher injury risk
   Fix: 5 minutes light cardio before any stretching session

5. Going Too Hard, Too Fast
   Why bad: Micro-tears, inflammation, reduced range (protective tightening)
   Fix: "Mild discomfort" not pain. 2/10 intensity, not 8/10
   Rule: If you can't breathe normally, you're too deep

6. Ignoring Asymmetry
   Why bad: Stretching both sides equally when one is tighter
   Fix: Extra set on the tight side. Compare left vs right regularly

7. Only Stretching What's Already Flexible
   Why bad: Hypermobility in some joints, restriction in others
   Fix: Prioritize tight areas (usually hip flexors, chest, hamstrings)

8. Treating Stretching as Strength Work
   Why bad: Flexibility without stability → joint instability
   Fix: Pair stretching with strengthening:
     - Stretch hip flexors → strengthen glutes
     - Stretch chest → strengthen upper back
     - Stretch hamstrings → strengthen hamstrings eccentrically

Injury Red Flags — STOP stretching if:
  ⚠ Sharp, shooting, or electrical pain
  ⚠ Pain that refers to another area
  ⚠ Numbness or tingling
  ⚠ Joint pain (vs muscle stretch sensation)
  ⚠ Pain that persists after stretching stops
  → These may indicate nerve involvement or joint pathology
EOF
}

show_help() {
    cat << EOF
stretch v$VERSION — Stretching & Flexibility Reference

Usage: script.sh <command>

Commands:
  intro        Stretching science and types overview
  dynamic      Dynamic stretching warm-up routines
  static       Static stretching holds and cooldowns
  pnf          PNF advanced stretching techniques
  mobility     Joint mobility drills for all major areas
  routines     Complete routines: morning, desk, pre-run, post-lift
  anatomy      Key muscle groups and their stretching patterns
  mistakes     Common stretching mistakes and injury prevention
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    dynamic)    cmd_dynamic ;;
    static)     cmd_static ;;
    pnf)        cmd_pnf ;;
    mobility)   cmd_mobility ;;
    routines)   cmd_routines ;;
    anatomy)    cmd_anatomy ;;
    mistakes)   cmd_mistakes ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "stretch v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
