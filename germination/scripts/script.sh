#!/usr/bin/env bash
# germination — Seed Germination Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Seed Germination ===

Germination is the process by which a seed develops into a new plant.
It begins with water uptake (imbibition) and ends when the radicle
(embryonic root) emerges from the seed coat.

Three Phases of Germination:
  Phase I — Imbibition (0-12 hours):
    Rapid water uptake through seed coat
    Seed swells 50-200% of original size
    Enzymes reactivate, cellular repair begins
    Physical: seed coat softens and may crack

  Phase II — Lag Phase (12-48 hours):
    Water uptake slows
    Metabolic activation: respiration ↑, DNA repair
    mRNA translation, protein synthesis begins
    Stored reserves (starch, lipids) mobilized
    Gibberellic acid (GA3) signals aleurone layer

  Phase III — Radicle Emergence (48-120+ hours):
    Cell elongation in embryonic axis
    Radicle breaks through seed coat
    This is the formal endpoint of "germination"
    Subsequent growth = seedling establishment, not germination

Essential Requirements:
  1. Water — triggers imbibition and enzyme activation
  2. Oxygen — aerobic respiration for energy
  3. Temperature — within species-specific range
  4. Light/Dark — species-dependent (some need light, some dark)

Seed Viability:
  Most seeds remain viable 1-5 years under proper storage
  Some exceptional cases:
    Lotus seeds: germinated after 1,300 years
    Date palm: germinated from 2,000-year-old seed (Masada)
  Storage rule: cool (5-10°C) + dry (< 8% moisture) = long life
EOF
}

cmd_conditions() {
    cat << 'EOF'
=== Optimal Germination Conditions ===

Temperature Ranges (°C):
  Category        Min    Optimal    Max
  Cool-season     2-5    15-20      25-30
  Warm-season     10-15  25-30      35-40
  Tropical        15-20  30-35      40-45

  Examples:
  Lettuce         2°C    18°C       25°C (thermodormancy above 25°C)
  Tomato          10°C   25°C       35°C
  Pepper          15°C   30°C       35°C
  Corn            10°C   30°C       40°C
  Wheat           4°C    20°C       30°C
  Rice            10°C   30°C       40°C

Moisture:
  Imbibition requires 25-50% of seed weight in water
  Too little: germination stalls at Phase I
  Too much: oxygen deprivation → anaerobic rot
  Ideal soil moisture: 50-75% of field capacity
  Testing: squeeze soil — should form ball but not drip

Oxygen:
  Seeds need O2 for aerobic respiration
  Waterlogged soil = anaerobic = poor germination
  Planting depth affects O2 availability
  Large seeds tolerate deeper planting (more stored energy)
  Soil crusting blocks both O2 and emergence

Light Requirements:
  Positive photoblastic (need light): lettuce, celery, petunia
    Plant on surface or barely cover
  Negative photoblastic (need dark): onion, phlox, calendula
    Cover well with soil or vermiculite
  Neutral (light indifferent): most crops — tomato, pepper, corn
  Light detected by phytochrome pigment (red/far-red ratio)

Soil pH:
  Most seeds germinate in pH 5.5-7.5
  Acidic (<5): aluminum toxicity inhibits root growth
  Alkaline (>8): micronutrient lockout
  Ideal germination mix: pH 6.0-6.5
EOF
}

cmd_dormancy() {
    cat << 'EOF'
=== Seed Dormancy ===

Dormancy is a survival mechanism preventing germination under
unfavorable conditions, even when water, oxygen, and temperature
are present.

Types of Dormancy:

1. Physical Dormancy (Hardseededness):
   Impermeable seed coat blocks water entry
   Common in: legumes, morning glory, lotus, acacia
   Breaking methods:
     Scarification — mechanical (sandpaper, nicking)
     Hot water soak — 80°C water, cool naturally
     Acid scarification — H2SO4 for 1-30 minutes (careful!)
     Freeze-thaw cycles — natural winter weathering

2. Physiological Dormancy:
   Embryo chemical/hormonal block
   ABA (abscisic acid) inhibits germination
   GA (gibberellic acid) promotes germination
   Breaking methods:
     Cold stratification — 1-5°C moist for 30-120 days
     Warm stratification — 20-25°C moist for 30-60 days
     GA3 application — soak in 100-500 ppm gibberellic acid
     After-ripening — dry storage at room temp for months

3. Morphological Dormancy:
   Embryo not fully developed at seed shed
   Must grow inside seed before germination
   Common in: carrot family, magnolia, ginseng
   Breaking: warm stratification to allow embryo growth

4. Combinational Dormancy:
   Physical + physiological (double dormancy)
   Common in: redbud, hawthorn, some roses
   Requires: scarification THEN stratification
   Can take 2 seasons in nature

5. Morphophysiological Dormancy:
   Underdeveloped embryo + physiological block
   Most complex — requires specific warm/cold sequences
   Common in: trillium, peony, lily
   May take 2-3 years to germinate naturally

Stratification Protocol:
  1. Soak seeds 24h in water
  2. Mix with moist peat or vermiculite (1:3 ratio)
  3. Place in sealed bag with air holes
  4. Refrigerate at 1-5°C
  5. Check weekly for moisture and premature germination
  6. Duration: 30-120 days depending on species
EOF
}

cmd_testing() {
    cat << 'EOF'
=== Germination Testing ===

Standard Germination Test (ISTA Rules):
  International Seed Testing Association (ISTA) protocols
  Used by seed labs worldwide for official results

  Procedure:
    1. Draw 400 seeds (4 replicates × 100 seeds)
    2. Place on moist germination paper or sand
    3. Incubate at species-specific temp (see ISTA tables)
    4. Count normal seedlings at first count (early vigor)
    5. Count again at final count (total germination)
    6. Record: normal, abnormal, dead, fresh ungerminated

  Result: Germination % = (Normal seedlings / Total seeds) × 100

Paper Towel (Ragdoll) Test — DIY:
  1. Wet paper towels (damp, not dripping)
  2. Place 10-25 seeds on towel
  3. Roll up loosely, place in plastic bag (partially open)
  4. Keep at 20-25°C
  5. Check daily for 7-14 days
  6. Count seeds with visible radicle (≥2mm)

  Interpretation:
    >90%: Excellent — full seeding rate
    70-90%: Good — slight overseeding may help
    50-70%: Fair — increase seeding rate 25-50%
    <50%: Poor — consider new seed lot

Tetrazolium (TZ) Test:
  Rapid viability test (24-48 hours vs 7-28 days)
  Seeds soaked in 2,3,5-triphenyltetrazolium chloride solution
  Living tissue stains RED (respiring cells reduce TZ)
  Dead tissue stays WHITE
  Cut seeds and evaluate staining pattern
  Not a germination test — a viability estimate

Vigor Tests:
  Cold test: germinate at 10°C in soil (simulates early planting)
  Accelerated aging: 41°C at 100% RH for 72h, then germinate
  Electrical conductivity: measure solute leakage from soaked seeds
  Low leakage = intact membranes = high vigor

Seed Lot Quality Metrics:
  Pure seed %:     ≥98% for certified seed
  Germination %:   species-specific minimums (e.g., corn ≥80%)
  Vigor index:     germination % × mean seedling length
  Moisture content: <13% for safe storage
EOF
}

cmd_crops() {
    cat << 'EOF'
=== Germination Data by Crop ===

Vegetables:
  Crop          Days    Opt°C   Depth(cm)  Min Germ%
  Tomato        5-10    25      0.6        75%
  Pepper        7-14    30      0.6        55%
  Lettuce       2-7     18      0.3        80%
  Carrot        10-21   25      0.6        55%
  Onion         7-10    20      1.3        70%
  Cucumber      3-7     30      1.3        80%
  Bean          5-10    25      2.5        70%
  Pea           5-10    20      2.5        80%
  Corn (sweet)  4-7     30      2.5        75%
  Spinach       5-10    20      1.3        60%
  Squash        4-7     30      2.5        75%
  Radish        3-5     25      1.3        75%
  Broccoli      3-7     25      0.6        75%
  Watermelon    4-8     30      2.5        70%

Field Crops:
  Crop          Days    Opt°C   Depth(cm)  Min Germ%
  Wheat         5-10    20      3-5        85%
  Rice          5-10    30      1-2        80%
  Corn (field)  4-7     30      4-5        90%
  Soybean       5-10    25      3-4        80%
  Cotton        5-10    30      3-5        80%
  Sunflower     5-10    25      3-5        75%
  Barley        5-10    20      3-4        85%
  Canola        3-7     20      1-2        80%

Herbs:
  Crop          Days    Opt°C   Depth(cm)  Light?
  Basil         5-10    25      0.3        Light
  Cilantro      7-14    20      0.6        Dark
  Dill          7-14    20      0.3        Light
  Parsley       14-28   20      0.6        Dark
  Thyme         7-21    20      surface    Light
  Oregano       7-14    20      surface    Light
  Sage          10-21   20      0.3        Light

Seeding Rate Adjustment:
  If germination test shows 70% and target is 100 plants:
  Seeds needed = Target plants / (Germ% × Field emergence%)
  = 100 / (0.70 × 0.85) = 168 seeds
  Field emergence is typically 80-90% of lab germination
EOF
}

cmd_problems() {
    cat << 'EOF'
=== Troubleshooting Poor Germination ===

Damping Off:
  Cause: Pythium, Rhizoctonia, Fusarium fungi
  Symptoms: seedlings collapse at soil line, wire-stem
  Pre-emergence: seeds rot before emerging
  Prevention:
    - Use sterile/pasteurized growing media
    - Don't overwater (let surface dry between waterings)
    - Good air circulation
    - Treat seed with fungicide (thiram, captan)
    - Biological: Trichoderma seed treatment

Soil Crusting:
  Cause: heavy rain/irrigation on fine-textured soil
  Blocks emergence physically
  Prevention:
    - Light mulch over seeded rows
    - Vermiculite/perlite topdressing
    - Gentle irrigation (mist, not flood)
    - Plant at proper depth

Temperature Problems:
  Too cold: slow/no germination, seed rot in wet soil
  Too hot: thermodormancy (lettuce >25°C), embryo damage
  Fluctuating: can actually improve germination for some species
  Solution: use heat mats (set 5°C above ambient for warm crops)

Old Seed / Low Viability:
  Seed deterioration accelerates with:
    - High moisture (>13%)
    - High temperature
    - Age beyond recommended storage life
  Quick test: paper towel test before planting
  Onion, parsley: use within 1-2 years
  Tomato, pepper: good for 4-5 years if stored well
  Cucumber, melon: can last 5-10 years

Seed-Borne Pathogens:
  Bacterial: black rot (Xanthomonas) in brassicas
  Fungal: Alternaria on carrots, Ascochyta on peas
  Treatment:
    - Hot water treatment (50°C for 20-30 min, species-specific)
    - Bleach soak (10% for 10 min, rinse well)
    - Commercial seed treatment fungicides

Other Causes:
  - Planting too deep (small seeds especially)
  - Fertilizer burn (salt damage to emerging radicle)
  - Herbicide residue in soil or compost
  - Bird/rodent predation
  - Insufficient seed-to-soil contact
EOF
}

cmd_enhancement() {
    cat << 'EOF'
=== Seed Enhancement Technologies ===

Seed Priming:
  Controlled hydration to initiate Phase I/II without radicle emergence
  Then dry back to original moisture for storage/planting

  Types:
    Hydropriming: soak in water for defined hours, then dry
    Osmopriming: soak in PEG or salt solution (controlled ψ)
    Matripriming: mix with moist solid matrix (vermiculite)
    Biopriming: prime + beneficial microbes (Trichoderma, Bacillus)

  Benefits:
    - Faster emergence (2-5 days earlier)
    - More uniform stand
    - Better performance under stress
    - Improved early vigor

Seed Pelleting:
  Coat seeds with inert material to create uniform round shape
  Used for small/irregular seeds: lettuce, carrot, onion, petunia

  Materials: clay, diatomaceous earth, talc + binder
  Benefits: precision planting, less thinning, singulation
  Drawback: slightly slower imbibition (coating barrier)
  Common in: commercial vegetable production, flowers

Seed Coating:
  Thin layer of material applied to seed surface
  Types:
    Film coating: thin polymer + colorant (ID + protection)
    Fungicide coating: thiram, metalaxyl, fludioxonil
    Insecticide coating: imidacloprid, clothianidin (neonicotinoids)
    Biological coating: Rhizobium for legumes, mycorrhizae
    Nutrient coating: zinc, molybdenum for early nutrition

Seed Tapes / Mats:
  Seeds embedded in water-soluble paper at proper spacing
  Benefits: perfect spacing, no thinning, easy planting
  Popular for: carrot, radish, lettuce in small gardens
  DIY: flour paste + toilet paper + seeds

Seed Enhancement Comparison:
  Method       Speed↑   Uniform↑   Protect   Cost
  Hydropriming  ++       ++         -         $
  Osmopriming   +++      +++        -         $$
  Biopriming    ++       ++         ++        $$
  Pelleting     -        +++        +         $$$
  Film coating  +        +          ++        $$
  Seed tape     -        +++        -         $$
EOF
}

cmd_schedule() {
    cat << 'EOF'
=== Germination Scheduling ===

Working Backwards from Transplant Date:
  Last frost date (your area):            ___________
  Minus transplant age:                   ___________
  Minus germination days:                 ___________
  = Indoor seed start date                ___________

  Example (Tomato, last frost April 15):
    Transplant age: 6-8 weeks = 42-56 days
    Germination: 5-10 days
    Start seeds: Feb 5-20 (indoors)
    Transplant: April 15-May 1 (after last frost)

Common Indoor Start Times (before last frost):
  10-12 weeks: onion, leek, celery, artichoke
  8-10 weeks:  pepper, eggplant
  6-8 weeks:   tomato, broccoli, cabbage, cauliflower
  4-6 weeks:   lettuce, kale, Swiss chard
  3-4 weeks:   cucumber, squash, melon (if starting indoors)
  0 weeks:     beans, corn, peas (direct sow only)

Hardening Off Protocol:
  Day 1-2:  Outdoors 1-2 hours, shade, no wind
  Day 3-4:  Outdoors 3-4 hours, partial sun
  Day 5-6:  Outdoors 5-6 hours, morning sun
  Day 7-8:  Outdoors all day, full sun, bring in at night
  Day 9-10: Outdoors day and night (if no frost threat)
  Day 11+:  Transplant

Succession Planting:
  For continuous harvest, start new batch every 2-3 weeks:
    Lettuce: every 2 weeks, April through September
    Beans: every 3 weeks, May through July
    Cilantro: every 2 weeks (bolts quickly in heat)
    Radish: every 2 weeks, spring and fall

Growing Degree Days (GDD):
  GDD = ((Tmax + Tmin) / 2) - Tbase
  Corn Tbase = 10°C, needs ~100 GDD to emerge
  Wheat Tbase = 0°C, needs ~50 GDD to emerge
  Track cumulative GDD to predict field emergence date
  Many extension services provide GDD calculators
EOF
}

show_help() {
    cat << EOF
germination v$VERSION — Seed Germination Reference

Usage: script.sh <command>

Commands:
  intro        Germination phases, biology, requirements
  conditions   Temperature, moisture, light, pH by crop
  dormancy     Dormancy types, stratification, scarification
  testing      ISTA protocols, paper towel test, TZ test
  crops        Germination data tables for common crops
  problems     Troubleshooting poor germination
  enhancement  Priming, pelleting, coating, seed tapes
  schedule     Start date calculations, hardening off, GDD
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    conditions)  cmd_conditions ;;
    dormancy)    cmd_dormancy ;;
    testing)     cmd_testing ;;
    crops)       cmd_crops ;;
    problems)    cmd_problems ;;
    enhancement) cmd_enhancement ;;
    schedule)    cmd_schedule ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "germination v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
