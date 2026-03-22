#!/usr/bin/env bash
# strapping — Cargo Strapping & Banding Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Strapping & Banding ===

Strapping (banding) is the process of applying a strap to an item
to combine, hold, reinforce, or fasten it for transport or storage.

Purpose:
  - Unitize multiple items into a single load
  - Secure cargo to pallets for transport
  - Bundle products (lumber, pipes, coils)
  - Reinforce boxes and containers
  - Compress loads to reduce volume

Industry Applications:
  Logistics       Pallet strapping, container securing
  Manufacturing   Coil banding, bundle packaging
  Construction    Lumber, steel, brick bundling
  Paper/Print     Ream banding, newspaper bundling
  Food/Beverage   Case strapping, pallet unitizing
  Metals          Steel coil and sheet banding
  Textiles        Bale strapping (cotton, recycling)

Key Metrics:
  Break Strength      Maximum force before strap breaks (lbs/kg)
  Joint Strength      Strength at the seal/joint (weakest point)
  Elongation          How much strap stretches under load (%)
  Retained Tension    Force strap maintains over time
  Split Resistance    Resistance to lengthwise tearing

Strapping vs Stretch Wrap:
  Strapping    Point loads, heavy items, edge protection
               Higher tension, structural support
  Stretch Wrap Area coverage, dust/moisture protection
               Lower tension, containment force
  Often used together: strap the pallet, then wrap it

History:
  1800s    Steel strapping for railroad freight
  1940s    Flat wire strapping introduced
  1960s    Polypropylene (PP) strapping developed
  1990s    Polyester (PET) strapping gains market share
  2000s+   Battery-powered tools, automated systems
EOF
}

cmd_materials() {
    cat << 'EOF'
=== Strapping Materials ===

Steel Strapping:
  Grades:
    Regular Duty    0.015"-0.023" thick, general packaging
    High Tensile    0.020"-0.031" thick, heavy loads
    Stainless       Corrosion resistant, outdoor/marine use
  Break Strength:   1,000 - 8,000 lbs (depending on size)
  Elongation:       2-5% (very rigid)
  Pros:
    - Highest break strength available
    - Minimal elongation (rigid hold)
    - Temperature resistant
    - Good for heavy, sharp-edged loads
  Cons:
    - Dangerous edges (cut hazard)
    - Rusts in wet conditions
    - No shock absorption
    - Heavy (higher shipping cost)
    - Cannot be retensioned after relaxation
  Applications: Steel coils, heavy machinery, lumber

Polyester (PET) Strapping:
  Widths:          1/2" to 1-1/4"
  Thickness:       0.020" to 0.050"
  Break Strength:  400 - 1,600 lbs
  Elongation:      6-8% (absorbs shocks)
  Retained Tension: Excellent (holds tight over time)
  Pros:
    - Best plastic alternative to steel
    - Shock absorption (survives impacts)
    - High retained tension (doesn't relax)
    - Weather resistant, no rust
    - Safer handling than steel
    - Recyclable
  Cons:
    - More expensive than PP
    - Lower break strength than steel
    - Requires specific tools
  Applications: Bricks, lumber, heavy pallets, coils

Polypropylene (PP) Strapping:
  Widths:          1/4" to 3/4"
  Thickness:       0.015" to 0.035"
  Break Strength:  100 - 600 lbs
  Elongation:      15-25% (very flexible)
  Retained Tension: Poor (relaxes significantly over time)
  Pros:
    - Lowest cost strapping material
    - Lightweight
    - Easy to apply manually
    - Available in colors for coding
    - Good for light-duty applications
  Cons:
    - Low break strength
    - Poor tension retention
    - UV degradation (not for outdoor storage)
    - Splits easily lengthwise
  Applications: Carton sealing, light bundles, newspaper

Comparison Table:
  Property          Steel      PET       PP
  Break Strength    ●●●●●     ●●●●      ●●
  Elongation        ●          ●●●       ●●●●●
  Retained Tension  ●●●        ●●●●●     ●●
  Cost              ●●●●       ●●●       ●
  Safety            ●●         ●●●●      ●●●●●
  Recyclable        ●●●●●     ●●●●      ●●●
EOF
}

cmd_tools() {
    cat << 'EOF'
=== Strapping Tools ===

Manual Tools:
  Tensioner (Windlass):
    - Hand-cranked tension on the strap
    - For steel: feed-wheel tensioners
    - For PP/PET: manual ratchet tensioners
    - Tension range: 50-300 lbs typically
    - Best for: Low volume, field work

  Sealer/Crimper:
    - Crimps metal seal over strap joint
    - Notch type: most common, indent seal into strap
    - Snap-on seals: no tool needed for PP
    - Push-type: for threading seals

  Combination Tool:
    - Tensions and seals in one device
    - Available for steel, PET, and PP
    - Reduces tool changes
    - Weight: 3-8 lbs (manual)

Pneumatic Tools:
  Air-powered tensioner/sealer
  Tension range: up to 900 lbs
  Seal methods: friction weld, seal-less
  Cycle time: 3-5 seconds
  Requires: Air compressor (90-100 PSI)
  Best for: Medium to high volume, stationary use

Battery-Powered Tools:
  Cordless tensioner/sealer (most popular modern choice)
  Brands: Signode, Fromm, Orgapack, Strapex, Cyklop
  Tension range: up to 1,200 lbs
  Seal method: Friction weld (no metal seals needed)
  Battery: 14.4V-18V lithium-ion
  Cycles per charge: 200-500 straps
  Weight: 7-12 lbs with battery
  Best for: High volume, mobile, warehouses

Automatic Strapping Machines:
  Tabletop: Small cartons, bundle strapping
    Speed: 20-65 cycles/minute
    Strap: PP (5-15mm wide)
  
  Inline: Integrated into conveyor lines
    Speed: up to 45 cycles/minute
    Sensor-triggered, fully automatic
    
  Palletizer: Full-pallet strapping
    Horizontal and vertical strapping
    Multiple strap patterns programmable
    Speed: 15-25 pallets/hour

Seal Types:
  Metal Seals       Crimped with sealer tool (strongest)
  Friction Weld     Heat-fused by vibration (sealless, fast)
  Heat Seal         Heated blade melts PP together
  Snap-On Buckle    Manual, no tool needed (weakest)
  Wire Buckle       Threading strap through wire loop
EOF
}

cmd_techniques() {
    cat << 'EOF'
=== Strapping Techniques ===

Strap Placement Patterns:

  Horizontal (around pallet):
    ┌─────────────┐
    │  ═══════════│   Wrap around the load horizontally
    │             │   Secures layers together
    │  ═══════════│   Minimum 2 straps per pallet
    └─────────────┘

  Vertical (over top):
    ┌──┬──────┬──┐
    │  ║      ║  │   Over the top and under the pallet
    │  ║      ║  │   Secures load to pallet
    │  ║      ║  │   Combined with horizontal for best hold
    └──╨──────╨──┘

  Cross Pattern:
    Two straps crossing at 90° on top of load
    Best for: Square loads, prevent shifting
    Requires: Edge protectors at strap crossing points

Placement Rules:
  1. Place straps at 1/6 of load length from each end
  2. Space additional straps evenly between
  3. Never strap over unsupported overhangs
  4. Use edge protectors on all corners
  5. Route straps through pallet openings (not over bottom boards)

Tensioning Guidelines:
  Load Type              Recommended Tension
  Rigid (cans, bricks)   50-70% of strap break strength
  Semi-rigid (cartons)   30-50% of strap break strength
  Compressible (bales)   70-90% of strap break strength
  Fragile products       20-30% (don't crush!)

  Over-tensioning risks:
    - Cutting into product (corrugate collapse)
    - Strap breakage during transport vibration
    - Product damage (denting, crushing)

  Under-tensioning risks:
    - Load shifting during transport
    - Strap sliding off load
    - Loss of unitization

Edge Protectors:
  Purpose: Distribute strap force, prevent cutting
  Materials: Plastic, cardboard, foam
  Placement: Every corner where strap changes direction
  Rule: Always use on corrugated boxes (strap cuts into board)
  Size: Should extend 2" beyond strap width on each side

Number of Straps per Pallet:
  Light loads (<500 lbs):    2 horizontal minimum
  Medium loads (500-1500):   3 horizontal + 2 vertical
  Heavy loads (>1500 lbs):   4 horizontal + 2-3 vertical
  Unitizing layers:          1 strap per 2-3 layers
EOF
}

cmd_sizing() {
    cat << 'EOF'
=== Strap Sizing Guide ===

Selecting Strap Width and Thickness:

Step 1: Determine Load Requirements
  - Total load weight
  - Transport mode (truck, rail, sea, air)
  - Distance and duration
  - Vibration and shock expected
  - Temperature and weather exposure

Step 2: Calculate Required Strap Strength

  Safety Factor Method:
    Required Strength = Load Force × Safety Factor ÷ Number of Straps

    Safety factors by transport:
      Local truck:     1.5×
      Long-haul truck: 2.0×
      Rail:            3.0× (high shock and vibration)
      Ocean freight:   3.0-4.0× (wave action, stacking)
      Air freight:     2.0×

  Example:
    Load: 2,000 lbs on pallet, long-haul truck
    4 horizontal straps
    Required = 2,000 × 2.0 ÷ 4 = 1,000 lbs per strap
    Select: 1/2" × 0.031" PET (1,100 lbs break strength) ✓

Common Steel Strap Sizes:
  Width × Thickness    Break Strength    Application
  3/8" × 0.015"       600 lbs           Light bundles
  1/2" × 0.020"       1,150 lbs         Standard pallets
  3/4" × 0.023"       1,900 lbs         Heavy loads
  3/4" × 0.029"       2,680 lbs         Steel coils
  1-1/4" × 0.031"     3,600 lbs         Heavy industrial

Common PET Strap Sizes:
  Width × Thickness    Break Strength    Application
  1/2" × 0.020"       400 lbs           Light pallets
  1/2" × 0.028"       600 lbs           Medium loads
  5/8" × 0.035"       900 lbs           Heavy pallets
  3/4" × 0.040"       1,200 lbs         Bricks, blocks
  1-1/4" × 0.050"     1,600 lbs         Timber, heavy goods

Common PP Strap Sizes:
  Width × Thickness    Break Strength    Application
  1/4" × 0.017"       100 lbs           Newspaper bundles
  3/8" × 0.021"       180 lbs           Light cartons
  1/2" × 0.024"       300 lbs           Standard cartons
  5/8" × 0.030"       450 lbs           Medium bundles
  3/4" × 0.035"       600 lbs           Heavy cartons

Joint Efficiency:
  The joint (seal) is always weaker than the strap itself
  Metal seal:      75-90% of strap strength
  Friction weld:   70-85% of strap strength
  Heat seal (PP):  50-70% of strap strength
  Design using JOINT strength, not strap break strength
EOF
}

cmd_standards() {
    cat << 'EOF'
=== Load Securing Standards ===

EN 12195 (European Standard):
  EN 12195-1    Calculation of securing forces
  EN 12195-2    Lashing equipment — web lashing
  EN 12195-3    Lashing chains
  EN 12195-4    Steel wire ropes

  Key Principles:
    - Load must withstand 0.8g forward deceleration
    - 0.5g sideways and rearward
    - Friction coefficient determines required securing force
    - All securing devices must be certified

EUMOS 40509:
  European Safe Loading of Cargo in Road Vehicles
  Transport simulation test standard
  Tests: horizontal impact (deceleration), tilt
  Pass criteria: Load must not shift more than defined limits
  Used to validate packaging/strapping configurations

U.S. DOT / FMCSA (49 CFR Part 393):
  Subpart I — Protection Against Shifting and Falling Cargo
  Requirements:
    - Cargo must be immovable or secured
    - Articles that can roll must be restrained
    - Aggregate working load limit ≥ 50% of cargo weight
    - Minimum number of tiedowns based on article length

IMO/ILO Code of Practice:
  For maritime container loading
  CTU Code (Cargo Transport Units)
  Requires securing against:
    - 1.0g longitudinal
    - 0.8g transverse
    - 1.0g vertical (down) + 0.2g (up)
  Strap lashing strength must account for sea state

ISO Standards:
  ISO 16104    Packaging — transport packages — strapping
  ISO 5765     Steel strapping for packaging
  ISO 18602    Packaging and the environment

Key Friction Coefficients (μ):
  Wood on wood:           0.20 - 0.40
  Cardboard on wood:      0.30 - 0.50
  Rubber mat on wood:     0.60 - 0.70
  Metal on metal:         0.10 - 0.25
  Anti-slip mat:          0.60 - 0.80
  Tip: Higher friction = fewer straps needed
EOF
}

cmd_examples() {
    cat << 'EOF'
=== Strapping Applications ===

--- Pallet of Boxed Goods (500 kg) ---
Material: PP strapping, 12mm × 0.63mm
Pattern: 3 horizontal straps
Tensioning: Manual ratchet, 40% break strength
Edge protectors: Plastic corners on top layer
Additional: Stretch wrap after strapping
Result: Unitized load for local truck delivery

--- Lumber Bundle (2,000 kg) ---
Material: PET strapping, 19mm × 0.80mm
Pattern: 4 horizontal straps, 2 vertical
Tensioning: Battery tool, 60% break strength
Edge protectors: Metal corner guards
Spacing: 600mm from ends, even intervals
Result: Secured for long-haul truck transport

--- Steel Coil (5,000 kg) ---
Material: Steel strapping, 32mm × 0.80mm
Pattern: Eye-to-eye configuration
  - 3 circumferential straps
  - 2 radial straps through coil eye
Tensioning: Pneumatic sealer, 50% break strength
Additional: Coil cradle on pallet, chocking
Result: Secured for rail and ocean transport

--- Brick Pallet (1,800 kg) ---
Material: PET strapping, 16mm × 0.90mm
Pattern: 2 vertical + 2 horizontal
Tensioning: Battery tool, 70% break strength
Edge protectors: Cardboard corners
Additional: Anti-slip mat between layers
Result: Withstands fork truck handling, stacking

--- Automated Carton Line ---
Equipment: Inline PP strapping machine
Speed: 35 cycles/minute
Strap: 9mm PP on 200kg coil
Pattern: 1 strap per carton (cross direction)
Trigger: Photocell sensor on conveyor
Seal: Heat weld
Result: 2,000+ cartons per hour, no operator

--- Textile Bale (300 kg) ---
Material: PET strapping, 16mm × 0.65mm
Pattern: 4 straps at 90° intervals
Tensioning: High compression (80% break strength)
Purpose: Compress bale from 2m³ to 0.8m³
No edge protectors needed (soft material)
Result: Volume reduction for container loading
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Strapping Quality & Safety Checklist ===

Material Selection:
  [ ] Strap material matches load requirements (steel/PET/PP)
  [ ] Break strength exceeds calculated requirements
  [ ] Width and thickness appropriate for load
  [ ] Joint efficiency factored into calculations
  [ ] Material suitable for environment (indoor/outdoor, temperature)

Application Quality:
  [ ] Correct number of straps applied
  [ ] Straps positioned at correct intervals
  [ ] Edge protectors installed at all corners
  [ ] Strap tension within recommended range
  [ ] Joints/seals properly formed (visual inspection)
  [ ] No twisted or overlapping straps
  [ ] Straps not cutting into product

Tool Maintenance:
  [ ] Tensioner calibrated to correct settings
  [ ] Sealer forming proper seals (test pull)
  [ ] Battery charged (battery-powered tools)
  [ ] Friction weld pads not worn
  [ ] Cutter blade sharp
  [ ] Tool serviced per manufacturer schedule

Safety:
  [ ] Operators trained on tool operation
  [ ] Safety glasses worn (strap breakage risk)
  [ ] Gloves worn when handling steel strapping
  [ ] Steel strap ends properly disposed (sharp edges)
  [ ] Strapping area clear of trip hazards
  [ ] Emergency procedures posted
  [ ] Proper body positioning during tensioning

Transport Compliance:
  [ ] Load securing meets applicable regulations
  [ ] Safety factor appropriate for transport mode
  [ ] Anti-slip measures in place (mats, boards)
  [ ] Load weight within vehicle capacity
  [ ] Strapping configuration documented/photographed
  [ ] Driver walk-around inspection before departure
EOF
}

show_help() {
    cat << EOF
strapping v$VERSION — Cargo Strapping & Banding Reference

Usage: script.sh <command>

Commands:
  intro        Strapping overview — purpose, materials, applications
  materials    Steel vs PET vs PP strapping comparison
  tools        Manual, pneumatic, battery, and automatic tools
  techniques   Strap patterns, placement, tensioning methods
  sizing       Width, thickness, and break strength selection
  standards    Load securing regulations (EN 12195, DOT, IMO)
  examples     Real-world strapping applications
  checklist    Strapping quality and safety checklist
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    materials)  cmd_materials ;;
    tools)      cmd_tools ;;
    techniques) cmd_techniques ;;
    sizing)     cmd_sizing ;;
    standards)  cmd_standards ;;
    examples)   cmd_examples ;;
    checklist)  cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "strapping v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
