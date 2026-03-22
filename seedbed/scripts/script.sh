#!/usr/bin/env bash
# seedbed — Seedbed Preparation Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Seedbed Preparation ===

A seedbed is the upper layer of soil prepared for seed placement
and germination. Good seedbed preparation creates conditions that
maximize seed-to-soil contact, moisture availability, and uniform
emergence.

Goals of Seedbed Preparation:
  1. Proper aggregate size — not too coarse, not too fine
  2. Firm seed zone — good seed-to-soil contact for moisture
  3. Loose surface — allows seedling emergence
  4. Weed-free — clean start for crop establishment
  5. Residue management — incorporate or position crop residue
  6. Adequate moisture — conserve soil water for germination

The Ideal Seedbed:
  Surface:    Loose crumb structure (1-10mm aggregates)
  Seed zone:  Firm, moist (capillary connection to subsoil water)
  Below seed: Firm base for root anchorage and water movement
  Profile:    "Loose over firm" — the universal seedbed principle

  Think of it like a sponge layer over a brick:
    Sponge (surface): protects from crusting, allows emergence
    Brick (seed zone): holds seed in place, provides moisture

Soil Tilth:
  Tilth = the physical condition of soil for planting
  Good tilth: crumbly, well-aggregated, easy to work
  Poor tilth: cloddy, compacted, or pulverized (dusty)

  Factors affecting tilth:
    - Organic matter content (higher = better structure)
    - Soil texture (clay vs sand vs loam)
    - Moisture at time of tillage (critical!)
    - Tillage history (over-tillage destroys structure)
    - Biological activity (earthworms, fungi improve tilth)
    - Freeze-thaw and wet-dry cycles (natural mellowing)

Seedbed vs Seed Trench (No-Till):
  Conventional: entire field surface prepared
  No-till: only a narrow slot cut for seed placement
  Strip-till: 8-12" strip tilled, rest undisturbed
  Each system has a "seedbed" — just different in scale
EOF
}

cmd_tillage() {
    cat << 'EOF'
=== Tillage Systems ===

Conventional Tillage:
  Full soil inversion or mixing across entire field
  Sequence: moldboard plow → disk → field cultivator → planting
  Passes: 3-5 before planting
  Residue: <15% surface cover after planting
  Pros: clean seedbed, weed control, residue incorporation
  Cons: erosion risk, fuel cost, moisture loss, destroys structure

Reduced (Minimum) Tillage:
  Fewer passes, less aggressive implements
  Sequence: chisel plow → one cultivator pass → planting
  Passes: 1-3 before planting
  Residue: 15-30% surface cover
  Pros: less erosion, lower cost, some soil health benefits
  Cons: more weed seed near surface, some residue challenges

Conservation Tillage:
  Definition: ≥30% residue cover after planting
  Includes: no-till, strip-till, ridge-till, mulch-till
  Required for many USDA conservation program payments

No-Till:
  No tillage — plant directly into previous crop residue
  Only soil disturbance is the planter opening a slot
  Residue: 50-100% surface cover
  Pros: erosion control, moisture conservation, soil biology thrives
        lower fuel/labor cost, carbon sequestration
  Cons: requires adapted planter, more herbicide initially
        cool/wet soil in spring, learning curve

Strip-Till:
  Combine benefits of no-till (residue) and tillage (warm seed zone)
  Till 8-12" wide strips in fall or spring
  Plant into tilled strips
  Between strips: undisturbed residue cover
  Pros: warm seedbed, residue moisture conservation, banding fertilizer
  Cons: requires GPS (precise strip/planter alignment), equipment cost

Ridge-Till:
  Permanent ridges rebuilt each year by cultivation
  Plant on ridge top (warm, dry, clean seedbed)
  Ridge rebuilt during last cultivation
  Pros: excellent for heavy/wet soils, good seed environment
  Cons: requires cultivator, limited crop flexibility

System Comparison:
  System         Passes  Residue%  Erosion  Fuel Cost
  Conventional    3-5     <15%     High     $$$
  Minimum         1-3     15-30%   Medium   $$
  No-till         0       >50%     Low      $
  Strip-till      1       >50%     Low      $$
  Ridge-till      1-2     30-50%   Low      $$
EOF
}

cmd_equipment() {
    cat << 'EOF'
=== Tillage Equipment ===

Primary Tillage (First Pass — Deep):

  Moldboard Plow:
    Action: inverts and buries top 8-12" of soil
    Buries residue nearly 100%, kills perennial weeds
    Creates rough surface requiring secondary tillage
    HP requirement: 6-8 HP per bottom (14-18" width)
    Use declining: erosion concerns, fuel cost

  Chisel Plow:
    Action: shatters soil 8-15" deep without inversion
    Shanks spaced 12-15", various point styles
    Leaves 50-70% residue on surface
    HP requirement: 8-15 HP per shank
    Good for breaking compaction while preserving residue

  Subsoiler / Ripper:
    Action: fractures soil 14-20" deep
    Narrow shanks, wide spacing (20-30")
    Targets plow pans and compaction layers
    HP requirement: 15-25 HP per shank
    Use: only when compaction diagnosed (not routine)

Secondary Tillage (Seedbed Finishing):

  Disk Harrow:
    Action: cuts and mixes soil 3-6"
    Tandem (two gangs) most common
    Sizes residue, levels surface, incorporates amendments
    HP requirement: 3-5 HP per foot of width
    Caution: creates compaction layer at disk depth ("disk pan")

  Field Cultivator:
    Action: loosens soil 3-5", levels surface
    Sweeps or shovels on S-tine or C-shank shanks
    Often has trailing rolling basket or harrow for firming
    The workhorse of seedbed preparation
    HP requirement: 3-6 HP per foot

  Harrow (Finishing):
    Spike-tooth: levels and breaks small clods
    Coil-tine: flexible, gentle, residue-friendly
    Rolling basket: firms and sizes aggregates
    Rotary: aggressive clod breaking (vegetable seedbeds)

  Cultipacker / Roller:
    Action: firms seedbed surface after tillage
    Creates firm-over-loose profile for small seeds
    Essential for alfalfa, small grains, grasses
    Corrugated roller improves seed-to-soil contact
EOF
}

cmd_moisture() {
    cat << 'EOF'
=== Soil Moisture Management ===

Optimal Moisture for Tillage:
  Too wet: smearing, compaction, clod formation
  Too dry: hard clods, dust, excessive power needed
  Just right: soil crumbles easily, holds shape briefly

  "Ribbon Test" for Tillage Readiness:
    1. Grab a handful of soil from tillage depth
    2. Squeeze into a ball
    3. Try to form a ribbon by pressing between thumb and forefinger
    
    Sandy loam: crumbles, can't form ribbon → usually OK to till
    Silt loam: forms short ribbon (<1"), breaks → OK to till
    Clay loam: forms long ribbon (>1"), smooth → TOO WET, wait!
    
    If soil is shiny when squeezed → definitely too wet
    If soil won't form ball at all → may be too dry (but tillable)

  "Ball Drop Test":
    Drop a squeezed soil ball from waist height
    If it shatters: good moisture for tillage
    If it stays intact or deforms: too wet — wait

Compaction from Wet Tillage:
  Wet soil + equipment weight = smeared, dense soil layer
  Compacted soil:
    - Bulk density >1.6 g/cm³ (sandy) or >1.4 g/cm³ (clay)
    - Root penetration restricted
    - Water infiltration reduced (ponding)
    - Yield loss: 10-30% on compacted soils

  Prevention:
    - Wait for proper moisture before field entry
    - Use tracks instead of tires (lower ground pressure)
    - Reduce axle loads (controlled traffic farming)
    - Limit tillage passes
    - Avoid tillage when soil is at or above plastic limit

Moisture Conservation:
  Every tillage pass loses moisture (exposes wet soil to air)
  Evaporative loss per pass: 0.2-0.5" of soil water
  Strategies:
    - Minimize passes (combine operations)
    - Till just before planting (shorten drying window)
    - Preserve residue cover (mulch effect)
    - Plant into moisture (don't let seedbed dry out)
    - Night tillage loses less moisture (cooler, less wind)

Soil Temperature Interaction:
  Dark, bare soil: warms faster (good for spring planting)
  Residue-covered soil: 3-8°F cooler (delays warm-season crops)
  Tradeoff: moisture conservation vs soil warming
  Strip-till compromise: bare strip warms, residue conserves moisture
EOF
}

cmd_structure() {
    cat << 'EOF'
=== Soil Structure for Seedbeds ===

Aggregate Size Targets:
  Small-seeded crops (alfalfa, grass, carrot):
    Surface: 1-5 mm aggregates (fine, firm)
    Seed zone: compact, excellent seed-to-soil contact
    Surface must not crust after rain

  Medium-seeded crops (wheat, canola, soybean):
    Surface: 2-10 mm aggregates
    Seed zone: firm but not compacted
    Some surface roughness OK

  Large-seeded crops (corn, sunflower):
    Surface: 5-25 mm aggregates (coarser OK)
    More tolerant of clods
    Vigor pushes through imperfect seedbed

  Rule of Thumb:
    Ideal aggregate diameter = 1-5× seed diameter
    Smaller seeds need finer seedbed

Bulk Density Targets:
  Soil Type     Ideal for Roots    Restricting
  Sandy          <1.60 g/cm³       >1.80
  Sandy loam     <1.55             >1.75
  Silt loam      <1.45             >1.65
  Clay loam      <1.40             >1.55
  Clay           <1.35             >1.47

Porosity:
  Total porosity: 45-55% ideal for seedbed
  Macropores (>0.075mm): drainage and aeration
  Micropores (<0.075mm): water retention
  Ideal balance: 25% macro / 25% micro / 50% solids
  
  Air-filled porosity: minimum 10% for root growth
  Below 10%: anaerobic conditions → root damage

Seed-to-Soil Contact:
  Critical for moisture transfer from soil to seed
  Imbibition requires continuous capillary connection
  Gaps around seed = slow or no germination
  
  Improving contact:
    - Press wheels on planter (firm seed slot)
    - Cultipacker after broadcast seeding
    - Proper aggregate size (fills around seed)
    - Adequate moisture at planting depth
    - Seed trench closure (no air gaps or "hair-pinning")

Over-Tillage Warning:
  Too many passes → soil aggregates break down completely
  Pulverized soil crusts severely after first rain
  Crust = barrier to emergence + reduced infiltration
  Especially dangerous on silt loam soils (low OM, high silt)
  "The best seedbed is the one you DON'T over-prepare"
EOF
}

cmd_crops() {
    cat << 'EOF'
=== Seedbed Requirements by Crop ===

Corn:
  Seed depth: 1.5-2" (consistent depth critical)
  Aggregate size: 5-25mm (tolerant of coarser seedbed)
  Firmness: firm seed zone at planting depth
  Key: uniform depth and spacing > perfect tilth
  No-till: excellent candidate (vigorous emergence)

Soybean:
  Seed depth: 1-1.5"
  Aggregate size: 2-15mm
  Firmness: firm at seed depth, loose surface
  Key: adequate moisture at shallow depth
  No-till: good candidate (but watch slugs in heavy residue)

Wheat / Small Grains:
  Seed depth: 1-1.5"
  Aggregate size: 1-10mm (finer than corn)
  Firmness: firm and packed (cultipacker ideal)
  Key: seed-to-soil contact for rapid establishment
  No-till drill: works well (eliminate seedbed prep entirely)

Canola / Rapeseed:
  Seed depth: 0.5-1" (very shallow — tiny seed)
  Aggregate size: 1-5mm (FINE seedbed required)
  Firmness: very firm at seed depth
  Key: even surface, no deep ruts or clods
  Extremely sensitive to seeding depth variation

Alfalfa / Small-Seeded Forages:
  Seed depth: 0.25-0.5" (surface to barely covered)
  Aggregate size: 1-3mm (finest seedbed of any crop)
  Firmness: packed surface — cultipacker before AND after seeding
  Key: must not crust, must maintain moisture at surface
  Often planted with companion crop (oats) for protection

Sugar Beet:
  Seed depth: 0.75-1.25"
  Aggregate size: 1-5mm (precision seedbed)
  Firmness: uniform, clod-free surface
  Key: emergence through surface must be easy (no crusting)
  Most demanding seedbed of row crops

Potato:
  Seed depth: 3-5" (seed piece, not true seed)
  Aggregate size: 10-30mm (coarsest acceptable)
  Firmness: loose for hilling, not compacted
  Key: good drainage, no waterlogging
  Deep tillage: often chisel + disk + bed former

Vegetable Transplants:
  Seedbed preparation for transplants:
  Level, stone-free surface
  Beds formed and shaped (raised beds common)
  Plastic mulch applied if applicable
  Drip tape installed under mulch
  Seedbed precision critical for mechanical transplanting
EOF
}

cmd_problems() {
    cat << 'EOF'
=== Seedbed Troubleshooting ===

Surface Crusting:
  Cause: fine, dispersed soil particles seal after rain/irrigation
  Risk factors: low OM, high silt content, bare soil, heavy rain
  Impact: seedlings can't break through, poor stand
  Prevention:
    - Don't over-till (preserve aggregates)
    - Apply gypsum (improves aggregate stability)
    - Light mulch or straw cover
    - Use rotary hoe 2-3 days after rain to break crust
  Fix: rotary hoe at shallow depth (break crust without disturbing seed)

Cloddy Seedbed:
  Cause: tilling soil too wet or too dry, clay soils, insufficient passes
  Impact: poor seed-to-soil contact, uneven emergence
  Prevention:
    - Till at optimal moisture
    - Use harrow or rolling basket behind cultivator
    - Allow freeze-thaw to mellow fall-tilled soil
  Fix: additional harrow pass, or plant and accept some unevenness

Compaction (Plow Pan):
  Cause: repeated tillage at same depth, wet field traffic
  Depth: typically 6-12" below surface
  Diagnosis: dig pit, probe with wire — resistance spike = pan
  Impact: restricted rooting, ponding, yield loss 10-30%
  Fix: deep chisel or subsoil (go 2-4" below pan)
  Prevention: vary tillage depth, reduce traffic, controlled traffic

Hair-Pinning (No-Till):
  Cause: residue pushed into seed trench by opener disk
  Impact: seed not contacting soil, trapped on residue
  Prevention:
    - Sharp coulters and opener disks
    - Adequate down-pressure
    - Straw choppers/spreaders on combine
    - Wait until residue is dry and brittle (cuts cleaner)

Uneven Emergence:
  Cause: variable seeding depth or moisture across field
  Especially in variable topography or soil types
  Impact: non-uniform stand → uneven maturity → yield loss
  Prevention:
    - Uniform seedbed preparation
    - Consistent planter depth control
    - Variable-rate seeding by zone (if soil varies)
    - Adequate seed-to-soil contact everywhere

Sidewall Compaction:
  Cause: planting in too-wet soil — disk openers smear slot walls
  Impact: roots can't penetrate sidewall, "flowerpot" effect
  Diagnosis: dig up plants — roots circling, not spreading
  Prevention: plant when soil moisture below plastic limit
  No fix once planted — prevention only
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Seedbed Preparation Checklist ===

Pre-Tillage Assessment:
  [ ] Soil moisture evaluated (ribbon test or ball drop test)
  [ ] Not too wet (no smearing or shiny surfaces)
  [ ] Residue condition assessed (amount, type, distribution)
  [ ] Compaction checked (probe or penetrometer)
  [ ] Soil temperature measured at planting depth
  [ ] Previous crop and herbicide history reviewed

Equipment Setup:
  [ ] Tillage implement selected for soil type and goal
  [ ] Working depth set correctly
  [ ] Level confirmed (side-to-side and front-to-back)
  [ ] Finishing attachments in place (harrow, basket, roller)
  [ ] Speed appropriate for implement type
  [ ] Disc/coulter sharpness checked

Seedbed Quality Check:
  [ ] Aggregate size appropriate for crop to be planted
  [ ] Surface level and uniform (no deep ruts or ridges)
  [ ] Seed zone firm at planting depth
  [ ] Surface loose enough for emergence
  [ ] No large clods in planting zone (>2× seed diameter)
  [ ] Residue distributed evenly (not bunched)

Planting Readiness:
  [ ] Soil temperature at planting depth meets crop minimum
  [ ] Moisture adequate at seed depth
  [ ] Weed-free or pre-plant herbicide applied
  [ ] Fertilizer placed (broadcast or banded)
  [ ] Planter calibrated for depth and population
  [ ] Press wheel pressure appropriate

Post-Planting:
  [ ] Seed trench closed properly (no open slots)
  [ ] Surface smoothed by closing wheels
  [ ] Monitor for crusting after first rain
  [ ] Rotary hoe ready if crust forms
  [ ] Scout for emergence at 5-7 days
  [ ] Evaluate stand uniformity and adjust for next field

Conservation Compliance:
  [ ] Residue cover meets conservation plan requirements
  [ ] Erosion control structures functional (terraces, waterways)
  [ ] HEL (Highly Erodible Land) provisions followed
  [ ] Tillage direction across slope (not up-and-down)
EOF
}

show_help() {
    cat << EOF
seedbed v$VERSION — Seedbed Preparation Reference

Usage: script.sh <command>

Commands:
  intro        Seedbed goals, soil physics, tilth
  tillage      Conventional, minimum, no-till, strip-till
  equipment    Plow, chisel, disk, cultivator, harrow, roller
  moisture     Timing, ribbon test, compaction avoidance
  structure    Aggregate size, bulk density, porosity targets
  crops        Seedbed requirements by crop type
  problems     Crusting, clods, compaction, hair-pinning
  checklist    Seedbed quality assessment checklist
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)     cmd_intro ;;
    tillage)   cmd_tillage ;;
    equipment) cmd_equipment ;;
    moisture)  cmd_moisture ;;
    structure) cmd_structure ;;
    crops)     cmd_crops ;;
    problems)  cmd_problems ;;
    checklist) cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "seedbed v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
