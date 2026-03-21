#!/usr/bin/env bash
# tillage — Soil Tillage Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Tillage — Overview ===

Tillage is the mechanical manipulation of soil to prepare a seedbed,
incorporate residue, manage weeds, and improve soil conditions for
crop production.

Purpose of Tillage:
  Seedbed preparation    Create uniform, fine-textured bed for planting
  Residue management     Incorporate or redistribute crop residue
  Weed control           Uproot or bury weeds and weed seeds
  Soil loosening         Break up compacted layers
  Aeration               Improve air and water movement
  Nutrient incorporation Mix fertilizer and amendments into soil

Tillage Classification:
  Primary tillage      First, deep operation (plow, chisel, disc)
  Secondary tillage    Follow-up, shallower (harrow, cultivator)
  Tertiary tillage     Final seedbed prep (roller, leveler)
  In-crop cultivation  Weed control between rows during season

Tillage Intensity Spectrum:
  Conventional     Full inversion (moldboard plow) + multiple passes
  Reduced          Fewer passes, less aggressive equipment
  Conservation     Minimum 30% residue cover after planting
  Strip-till       Till only narrow planting strips
  No-till          Zero tillage, plant directly into residue

Global Trends:
  - Movement toward reduced/conservation tillage
  - No-till adoption: ~180 million hectares worldwide
  - Cover crops replacing mechanical tillage for soil management
  - Precision tillage: GPS-guided, variable depth
  - Regenerative agriculture: minimize soil disturbance

Key Trade-offs:
  Intensive tillage:
    + Good seedbed, easy planting
    + Effective weed control
    - Erosion risk (wind and water)
    - Destroys soil structure
    - Oxidizes organic matter
    - High fuel/labor costs
  
  No-till:
    + Reduces erosion 80-95%
    + Builds organic matter
    + Saves fuel and time
    + Improves water infiltration
    - Requires herbicides for weed control
    - May compact in wet soils
    - Slower soil warming in spring
    - Slug and disease pressure in residue
EOF
}

cmd_primary() {
    cat << 'EOF'
=== Primary Tillage ===

Moldboard Plow:
  Action:    Inverts soil completely (turns 180°)
  Depth:     6-12 inches (15-30 cm)
  Speed:     4-6 mph
  Power:     15-20 HP per bottom (plow body)
  
  When to use:
    - Heavy sod or pasture conversion
    - Burying heavy crop residue
    - Incorporating lime to depth
    - Breaking disease cycles (bury inoculum)
  
  Disadvantages:
    - Exposes soil to erosion
    - Destroys soil structure
    - Brings weed seeds to surface
    - High fuel consumption
    - Creates plow pan (hardpan) at tillage depth
  
  Declining use: Down from 60% (1980s) to <10% in many regions

Chisel Plow:
  Action:    Shatters soil without inversion
  Depth:     8-14 inches (20-35 cm)
  Speed:     4-7 mph
  Power:     8-12 HP per shank
  
  Shank types:
    Straight:  Aggressive fracturing, more draft
    Curved (C):  Less aggressive, better residue flow
  
  Point types:
    Narrow point (2"):   Deep shattering, minimal surface disturbance
    Twisted shovel (3"):  More mixing, moderate disturbance
    Sweep (6-12"):       Maximum surface disturbance, shallow
  
  Advantages:
    - Breaks compaction
    - Leaves 50-70% residue on surface
    - Lower draft than moldboard
    - Good for fall tillage
  
  Most popular primary tillage tool in Corn Belt

Disc Plow (Heavy Disc):
  Action:    Cuts and partially inverts soil
  Depth:     6-10 inches
  Disc size: 24-36 inches diameter
  Spacing:   9-12 inches between discs
  
  When to use:
    - Sticky or heavy clay soils
    - Rocky or stony soils (discs ride over rocks)
    - First tillage of fallow or heavy residue
  
  Types:
    Offset disc:  Heavy-duty, one-pass primary tillage
    Tandem disc:  Lighter, often used as secondary tool

Subsoiler (Ripper):
  Action:    Deep fracture of compacted layers
  Depth:     14-24 inches (35-60 cm)
  Power:     25-40 HP per shank
  Spacing:   20-40 inches between shanks
  
  When to use:
    - Breaking plow pan or traffic compaction
    - Opening hardpan for root penetration
    - Improving deep drainage
  
  Rule: Soil must be DRY for effective shattering
        Wet soil = smearing, making compaction worse
  
  Frequency: Every 3-5 years, or as needed by penetrometer readings
EOF
}

cmd_secondary() {
    cat << 'EOF'
=== Secondary Tillage ===

Disc Harrow (Tandem Disc):
  Action:    Cuts residue, mixes top 3-6 inches
  Disc size: 18-24 inches
  Speed:     5-7 mph
  Passes:    1-2 after primary tillage
  
  Gang angle:
    Steep (20°+):  Aggressive cutting and mixing
    Shallow (15°): Light finishing, less soil movement
  
  Use: Break clods, incorporate residue, level field

Field Cultivator:
  Action:    Loosens and levels top 3-5 inches
  Components: Shanks with sweeps + finishing attachments
  Speed:     5-8 mph
  
  Sweep sizes:
    Narrow (6"): Deep penetration, row crop stubble
    Wide (12"): Maximum weed kill, seedbed finishing
  
  Finishing attachments:
    Rolling basket: Firms and levels seedbed
    Drag chain:     Fills in tracks
    Harrow section: Breaks small clods
  
  Use: Final seedbed preparation before planting

Rotary Tiller (Rototiller / Rotavator):
  Action:    L-shaped blades pulverize soil
  Depth:     3-8 inches
  Speed:     2-4 mph (slow)
  Power:     PTO-driven (15-25 HP per foot of width)
  
  Advantages:
    - Excellent seedbed in one pass
    - Mixes amendments thoroughly
    - Good for garden/horticultural applications
  
  Disadvantages:
    - Destroys soil structure if overused
    - Creates fine powder (crusting risk)
    - High power requirement
    - Not for large-scale field crops
  
  Best for: Vegetable production, incorporating cover crops

Cultipacker / Roller:
  Action:    Firms and levels seedbed surface
  Use:       After seeding (press seed into soil)
  Types:
    Smooth roller: Level and firm
    Cultipacker: Ridged rollers crush clods and firm
    Cambridge roller: Ring roller for clod crushing
  
  Purpose:
    - Ensure seed-to-soil contact
    - Reduce air pockets
    - Smooth surface for harvest equipment

Rotary Hoe:
  Action:    Shallow crust breaking (0.5-1 inch)
  Speed:     8-12 mph (must be fast to work)
  Use:       Break soil crust after rain before emergence
  Timing:    1-3 days after planting, before crop emerges
  Effect:    Kills small weed seedlings, improves emergence
EOF
}

cmd_conservation() {
    cat << 'EOF'
=== Conservation Tillage ===

Definition (USDA): Any tillage system that maintains at least
30% of the soil surface covered with crop residue after planting.

No-Till (Zero Tillage):
  Method: Plant directly into previous crop residue
  Equipment: No-till drill or planter with residue-cutting coulters
  
  Benefits:
    - 80-95% erosion reduction
    - Builds soil organic matter (+0.1%/year)
    - Saves 3-5 gallons fuel per acre
    - Reduces labor and equipment costs
    - Improves water infiltration and retention
    - Sequesters carbon (0.2-0.5 tons C/acre/year)
  
  Challenges:
    - Weed control depends on herbicides
    - Cooler, wetter soil in spring → delayed planting
    - Slug and residue-borne disease pressure
    - Compaction in wet soils (no mechanical loosening)
    - Learning curve for farmers (3-5 year transition)
  
  Adoption: ~100M hectares globally (led by Brazil, Argentina, U.S.)

Strip-Till:
  Method: Till only narrow strips (6-10") where seeds will be planted
  Leaves inter-row residue undisturbed
  
  Equipment: Strip-till units with shanks, coulters, berming discs
  Timing: Fall or spring before planting
  
  Benefits:
    - Warms and dries seed zone (like conventional)
    - Residue protection between rows
    - Places fertilizer in root zone
    - Good compromise: tillage benefits + conservation
  
  Best for: Corn and sugar beets in heavy residue

Mulch-Till:
  Method: Full-width tillage that leaves ≥30% residue
  Equipment: Chisel plow, disc, field cultivator (shallow settings)
  Passes: Minimize number of passes
  
  Residue retention by implement:
    Moldboard plow:    0-10% (worst)
    Chisel plow:       50-70%
    Disc harrow:       40-60% per pass
    Field cultivator:  70-85%
    No-till:           90-100% (best)

Ridge-Till:
  Method: Plant on permanent ridges, clean off ridge top at planting
  Ridges rebuilt during cultivation
  
  Benefits:
    - Good drainage and soil warming on ridges
    - Residue in furrows reduces erosion
    - Permanent traffic lanes (controlled traffic)
    - Reduced herbicide use (mechanical weed control)
  
  Limitations: Requires specialized equipment, row crops only

Cover Crops as Tillage Alternative:
  Replace mechanical tillage with biological tillage
  Deep-rooted covers (radish, cereal rye) break compaction
  Decomposing roots create macropores
  Surface residue protects against erosion
  "Bio-drill" effect: roots create channels for next crop
EOF
}

cmd_soil() {
    cat << 'EOF'
=== Soil Considerations for Tillage ===

Soil Texture and Tillage Response:

Sandy Soils:
  Tillage need: Minimal (naturally loose)
  Risk: Over-tillage destroys structure, wind erosion
  Recommendation: No-till or strip-till preferred
  Timing: Can work in wider moisture range
  Notes: Low organic matter — every tillage pass oxidizes OM

Clay Soils:
  Tillage need: Moderate (compacts easily, benefits from loosening)
  Risk: Smearing when too wet, clodding when too dry
  Recommendation: Fall tillage preferred (freeze-thaw helps)
  Timing: Narrow optimal moisture window
  Notes: "Ball test" — squeeze soil, if it ribbons, too wet to till

Loam Soils:
  Tillage need: Moderate (versatile, responds well)
  Risk: Plow pan formation with repeated tillage at same depth
  Recommendation: Vary tillage depth year to year
  Timing: Broadest workable moisture range
  Notes: Best soils for farming, protect them

Soil Moisture and Tillage:
  Too Wet:
    - Soil smears and compacts
    - Creates hardpan layer
    - Clumps stick to equipment
    - Test: If soil sticks to a knife blade, it's too wet
  
  Too Dry:
    - Creates large clods (especially clay)
    - High draft force (hard pulling)
    - Dust generation
    - Equipment wear increases
  
  Optimal:
    - Soil crumbles when squeezed (friable)
    - Does not stick to equipment
    - Shatters cleanly with tillage tools

Compaction:
  Causes:
    - Heavy equipment traffic (especially when wet)
    - Repeated tillage at same depth (plow pan)
    - Livestock trampling
  
  Diagnosis:
    - Penetrometer readings >300 PSI = restricted roots
    - Dig a soil pit — look for platy structure
    - Poor root penetration visible on pulled plants
  
  Prevention:
    - Controlled traffic farming (same wheel tracks)
    - Reduce axle loads (bigger tires at lower pressure)
    - Avoid field operations when soil is wet
    - Vary tillage depth
  
  Remediation:
    - Subsoiling/ripping (soil MUST be dry)
    - Deep-rooted cover crops (radish, alfalfa)
    - Freeze-thaw cycles (natural, surface compaction only)

Soil Organic Matter Impact:
  Each 1% OM ≈ 20,000 lbs/acre of stable carbon
  Conventional tillage: loses 0.05-0.1% OM per year
  No-till: gains 0.05-0.1% OM per year
  OM benefits: water holding, nutrient supply, structure
  10 years of no-till can increase OM by 0.5-1.0%
EOF
}

cmd_equipment() {
    cat << 'EOF'
=== Tillage Equipment Selection ===

Matching Tractor to Implement:

Power Requirements (approximate):
  Implement              HP per foot of width
  Moldboard plow         12-18 HP/bottom (14" width)
  Chisel plow            8-12 HP/shank
  Subsoiler              25-40 HP/shank
  Heavy disc             8-12 HP/foot
  Tandem disc            5-8 HP/foot
  Field cultivator       4-6 HP/foot
  Rotary tiller          15-25 HP/foot
  Strip-till             15-20 HP/row

Field Capacity:
  Capacity (acres/hr) = Speed (mph) × Width (ft) × Efficiency ÷ 8.25
  
  Typical field efficiency:
    Plowing:             75-85%
    Discing:             80-90%
    Cultivating:         80-90%
    Planting:            65-80%
  
  Example: 30' field cultivator at 6 mph, 85% efficiency
    = 6 × 30 × 0.85 ÷ 8.25 = 18.5 acres/hour

Tillage Depth Guide:
  Operation              Typical Depth
  Surface cultivation    1-3 inches
  Secondary tillage      3-5 inches
  Primary disc           4-8 inches
  Chisel plow            8-14 inches
  Moldboard plow         8-12 inches
  Subsoiler              14-24 inches

Equipment Adjustments:
  Disc Harrow:
    - Gang angle: 15-25° (steeper = more aggressive)
    - Blade spacing: 7-9" typical
    - Depth: Set by hydraulic cylinder or weight
    - Check: Discs sharp, bearings good, spacing uniform
  
  Chisel Plow:
    - Shank spacing: 12-15" typical
    - Point selection: match to purpose
    - Depth: Adjust by hydraulic cylinder
    - Check: Points sharp, shanks not bent, springs tight
  
  Field Cultivator:
    - Sweep size: 6-12" (match to shank spacing)
    - Depth: 3-5" (uniform across machine)
    - Finishing attachment: adjust pressure
    - Check: Sweeps sharp, overlapping coverage

Fuel Cost Estimation:
  Diesel consumption ≈ HP × 0.044 gal/HP-hr × load factor
  Load factors: Plowing 85%, Discing 70%, Cultivating 60%
  Example: 200HP tractor chisel plowing
    = 200 × 0.044 × 0.85 = 7.5 gal/hr
    At $3.50/gal and 12 acres/hr = $2.19/acre
EOF
}

cmd_examples() {
    cat << 'EOF'
=== Tillage System Examples ===

--- Corn-Soybean Rotation (Midwest U.S.) ---
Conventional System:
  Fall: Chisel plow corn stalks (10" deep)
  Spring: Disc harrow (2 passes, 4" deep)
  Spring: Field cultivator (1 pass, 3" deep)
  Plant corn
  Total: 4 passes, ~$35-45/acre, <15% residue remaining

Conservation System:
  Fall: No fall tillage
  Spring: One-pass field cultivator (4" deep)
  Plant corn with residue managers
  Total: 1 pass, ~$12-15/acre, 30-40% residue remaining

No-Till System:
  No tillage operations
  Burndown herbicide application
  Plant with no-till planter
  Total: 0 tillage passes, ~$0 tillage cost, 70-90% residue
  Note: Herbicide cost higher (~$15-25/acre for burndown)

--- Wheat Production (Great Plains) ---
Summer fallow (traditional):
  After wheat harvest: disc stubble
  Spring: chisel plow or sweep
  Summer: 2-3 cultivations (weed control)
  Fall: seed wheat
  Problem: 12+ months exposed soil, severe erosion

Chemical fallow (modern):
  After wheat harvest: leave stubble standing
  Herbicide applications as needed (2-3)
  No mechanical tillage
  Fall: plant wheat with no-till drill
  Benefit: 80% erosion reduction, moisture conservation

--- Vegetable Production ---
Spring:
  1. Moldboard plow or spader (incorporate cover crop)
  2. Disc harrow (2 passes, break clods)
  3. Rotary tiller (fine seedbed, 4" deep)
  4. Bed shaper (form raised beds)
  5. Plastic mulch layer (if used)
  Total: 4-5 passes, intensive but necessary for vegetables
  Note: Fine seedbed critical for small-seeded crops (carrots, lettuce)

--- Soil Health Transition Plan ---
Year 1: Reduce to one primary tillage + one secondary
Year 2: Switch to strip-till or minimum-till
Year 3: Add cover crops to rotation
Year 4: Transition to no-till on best fields
Year 5+: Full no-till with diverse cover crop mixes
  Expected: Yields may dip 5-10% during transition
  Long-term: Yields match or exceed conventional after 3-5 years
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Tillage Planning & Operations Checklist ===

Pre-Season Planning:
  [ ] Review soil test results (nutrient needs, pH, OM)
  [ ] Assess compaction (penetrometer readings)
  [ ] Determine tillage system for each field
  [ ] Match equipment to tractor power
  [ ] Plan tillage timing based on soil moisture
  [ ] Schedule based on crop rotation needs
  [ ] Budget fuel and labor costs

Field Assessment:
  [ ] Check soil moisture (squeeze test)
  [ ] Evaluate residue levels and distribution
  [ ] Identify compacted areas (yield maps, penetrometer)
  [ ] Note wet spots, waterways, and slopes
  [ ] Mark rocks, tile outlets, or obstructions
  [ ] Consider slope and erosion risk

Equipment Preparation:
  [ ] Inspect and sharpen cutting edges (discs, sweeps, shares)
  [ ] Check bearing condition (spin by hand)
  [ ] Grease all fittings
  [ ] Verify hydraulic cylinder operation
  [ ] Check frame for cracks or bends
  [ ] Adjust depth settings before going to field
  [ ] Calibrate GPS guidance (if equipped)

Field Operations:
  [ ] Start with test pass — check depth uniformity
  [ ] Verify residue incorporation level meets goal
  [ ] Watch for smearing (too wet) or large clods (too dry)
  [ ] Monitor fuel consumption vs plan
  [ ] Follow contours on slopes (not up and down)
  [ ] Leave grassed waterways undisturbed
  [ ] Maintain headland turning areas
  [ ] Record field conditions and settings used

Post-Tillage:
  [ ] Evaluate seedbed quality (clod size, firmness)
  [ ] Check for plow pan (dig with probe)
  [ ] Estimate residue cover remaining (line transect method)
  [ ] Document operations for farm records
  [ ] Clean equipment before moving to next field
  [ ] Assess whether additional passes needed
  [ ] Schedule planting window based on seedbed conditions
EOF
}

show_help() {
    cat << EOF
tillage v$VERSION — Soil Tillage Reference

Usage: script.sh <command>

Commands:
  intro          Tillage overview — purpose, types, trade-offs
  primary        Primary tillage — moldboard, chisel, disc, subsoiler
  secondary      Secondary — disc harrow, cultivator, rotary tiller
  conservation   Conservation tillage — no-till, strip-till, mulch-till
  soil           Soil considerations — texture, moisture, compaction
  equipment      Equipment selection, power, and settings
  examples       Tillage system examples for common rotations
  checklist      Planning and operations checklist
  help           Show this help
  version        Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    primary)      cmd_primary ;;
    secondary)    cmd_secondary ;;
    conservation) cmd_conservation ;;
    soil)         cmd_soil ;;
    equipment)    cmd_equipment ;;
    examples)     cmd_examples ;;
    checklist)    cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "tillage v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
