#!/usr/bin/env bash
# conveyor — Conveyor System Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Conveyor Systems ===

Conveyors are mechanical systems that transport materials continuously
along a fixed path. The backbone of modern warehousing, manufacturing,
mining, and distribution.

Why Conveyors:
  - Move goods faster than manual handling (200-600 ft/min typical)
  - Reduce labor (1 conveyor replaces 5-10 manual handlers)
  - Consistent throughput (no breaks, no fatigue)
  - Predictable timing for downstream processes
  - Lower injury risk (less lifting, carrying, bending)

Applications by Industry:
  E-commerce/Distribution:  Parcel sortation, order fulfillment
  Manufacturing:            Assembly lines, WIP transfer
  Mining:                   Bulk ore/coal transport (miles long)
  Food Processing:          Product transport under hygiene standards
  Airport:                  Baggage handling systems
  Postal/Courier:           Letter/parcel sorting
  Automotive:               Body-in-white, paint shops

Selection Criteria:
  What is being moved?      Size, weight, shape, fragility
  How far?                  10 feet vs 1 mile vs 10 miles
  How fast?                 Items per minute or tons per hour
  What environment?         Clean room, food grade, outdoor, explosive
  Incline needed?           Level, incline, decline, vertical
  Accumulation needed?      Can items queue without pressure?
  Budget?                   Belt is cheap, crossbelt sorter is expensive

Throughput Units:
  Discrete items:    cartons per minute (CPM), pieces per hour
  Bulk materials:    tons per hour (TPH), cubic yards per hour
  Typical ranges:    30-200 CPM for parcel, 100-5000 TPH for mining
EOF
}

cmd_types() {
    cat << 'EOF'
=== Conveyor Types ===

Belt Conveyor:
  Flat belt on rollers/slider bed
  Most common type for unit loads
  Speeds: 50-600 ft/min
  Max incline: 15-18° (flat belt), 30-45° (cleated/rough top)
  Materials: PVC, rubber, polyurethane, modular plastic
  Best for: cartons, totes, bags, food products

Roller Conveyor:
  Gravity Roller: angled slightly, product rolls by gravity
    No power needed, cheapest option
    Requires: rigid flat-bottom products
  Powered (Live) Roller: motor-driven via belt or chain
    Each roller can be individually controlled (zones)
    Zero-pressure accumulation possible
    Best for: carton handling, merge/divert, accumulation

Chain Conveyor:
  Heavy-duty, moves pallets and large items
  One or two strands of chain carry the load
  Speeds: 20-100 ft/min
  Loads: up to 10,000 lbs per pallet
  Best for: pallet handling, heavy manufacturing

Screw (Auger) Conveyor:
  Helical screw blade inside a tube
  Moves bulk materials: grain, cement, powders
  Can operate horizontally, inclined, or vertically
  Throughput: 10-500 TPH depending on diameter
  Best for: bulk granular materials, food processing

Bucket Elevator:
  Buckets on belt or chain, moves material vertically
  Heights: up to 200+ feet
  Materials: grain, cement, ore, fertilizer
  Types: centrifugal discharge, continuous bucket
  Best for: vertical lift of bulk materials

Pneumatic Conveyor:
  Uses air pressure or vacuum to move materials through pipes
  Positive pressure: blows material forward
  Negative (vacuum): sucks material through system
  Best for: powders, granules, pills, food ingredients
  Advantages: enclosed (dust-free), flexible routing

Overhead Conveyor:
  Track mounted on ceiling, carriers hang below
  Power-and-free: can accumulate and reroute
  Used in: paint lines, garment industry, automotive assembly
  Saves floor space, moves items over obstacles
EOF
}

cmd_sizing() {
    cat << 'EOF'
=== Conveyor Engineering Calculations ===

--- Belt Speed ---
  Speed (ft/min) = Items per minute × Item spacing (ft)

  Example: 60 cartons/min, 2 ft spacing
  Speed = 60 × 2 = 120 ft/min

  Speed (m/s) = π × Roller Diameter (m) × RPM / 60

--- Throughput ---
  Discrete: Throughput = Belt Speed / Item Pitch
    Item pitch = item length + gap
    Example: 150 ft/min ÷ 2.5 ft pitch = 60 items/min

  Bulk: Throughput (TPH) = Cross-section area × speed × density
    Q = A × v × ρ × 3600 (metric, m²·m/s·t/m³)

--- Motor Power (Belt Conveyor) ---
  HP = (F × V) / 33,000

  Where:
    F = total force (lbs) = friction + incline + acceleration
    V = belt speed (ft/min)
    33,000 = conversion constant (ft·lb/min per HP)

  Friction force:
    F_friction = μ × W_total
    μ = friction coefficient (0.03 slider bed, 0.015 rollers)
    W_total = weight of belt + load on conveyor

  Incline force:
    F_incline = W_load × sin(angle)

  Service factor: multiply HP by 1.25-1.5 for safety margin

  Example:
    500 lb load, 200 ft belt, 100 ft/min, 10° incline
    F_friction = 0.03 × (200 + 500) = 21 lbs
    F_incline = 500 × sin(10°) = 87 lbs
    F_total = 108 lbs
    HP = (108 × 100) / 33,000 = 0.33 HP
    With 1.5 safety factor → 0.5 HP motor

--- Belt Width ---
  Belt width = item width + 2 inches (minimum)
  For sortation: belt width = item width + 6 inches
  Standard widths: 12", 18", 24", 30", 36", 48", 60"

--- Incline Limits ---
  Flat smooth belt:       max 15-18°
  Rough top belt:         max 25-28°
  Cleated belt:           max 30-45°
  Sandwich belt:          up to 90° (vertical)
  Beyond 45°:             consider bucket elevator

--- Accumulation Zone Length ---
  Zone length = item length + 2-4 inches
  Buffer capacity = number of zones × 1 item each
  Zero-pressure: each zone has independent drive
EOF
}

cmd_layout() {
    cat << 'EOF'
=== Conveyor Layout Design ===

--- Curves ---
  Belt curves: 30°, 45°, 60°, 90°, 180° standard
  Minimum radius depends on belt width and product:
    12" belt → 24" inside radius
    24" belt → 36" inside radius
    36" belt → 48" inside radius
  Tapered rollers needed to maintain belt tracking on curves
  Products must not overhang inside edge

--- Merges ---
  Y-Merge: two lines into one at an angle (30° or 45°)
    Requires: upstream metering to prevent collisions
    Control: photoeye at merge point, upstream hold-back zones

  Side Merge: 90° push or divert onto mainline
    Transfer conveyor or pusher at right angle
    Requires gap creation on mainline

  Throughput rule: merged output ≤ sum of inputs × 0.85
    (account for merge gaps and timing)

--- Diverts ---
  Pop-up wheel divert: wheels rise through roller gaps
    Speed: 30-60 CPM, moderate accuracy
    Best for: right-angle diverts to takeaway lanes

  Activated roller belt (ARB): angled belt sections pop up
    Speed: 60-150 CPM, reliable
    Best for: high-speed right-angle diverts

  Pusher divert: pneumatic or electric pusher
    Speed: 20-40 CPM, simple and robust
    Best for: heavy items, low speed

  Sliding shoe: angled shoes slide across belt
    Speed: 100-300 CPM, high accuracy
    Best for: high-speed parcel sortation

--- Accumulation Zones ---
  Purpose: buffer items without back-pressure damage
  Types:
    Zero-pressure: each zone independently motor-driven
      Items stop without touching each other
      Best for: fragile or variable-size items

    Minimum-pressure: slight contact between items
      Simpler, cheaper, some back-pressure
      Best for: sturdy cartons of similar size

    Zero-contact: air gap maintained between zones
      Used in semiconductor and pharma

--- Elevation Changes ---
  Incline/decline conveyor: gradual slope (< 18° typically)
  Spiral conveyor: continuous helical path, saves floor space
  Vertical reciprocating conveyor (VRC): elevator for goods
  Vertical lift module: for tote/carton retrieval
EOF
}

cmd_controls() {
    cat << 'EOF'
=== Conveyor Controls & Sensors ===

--- Sensors ---

Photoeye (Photoelectric Sensor):
  Most common conveyor sensor
  Types:
    Through-beam:  emitter + receiver, most reliable, 30m range
    Retro-reflective: sensor + reflector, 10m range
    Diffuse:       sensor only, detects object reflection, 2m range
  Use: detect item presence, count items, trigger diverts

Encoder (Rotary):
  Attached to motor shaft or roller
  Outputs pulses per revolution (PPR): 100-10000 typical
  Use: measure belt speed, track item position, synchronize zones

Proximity Sensor:
  Inductive: detects metal objects (5-50mm range)
  Capacitive: detects any material (5-25mm range)
  Use: confirm divert position, detect jams, end-of-stroke

Barcode Scanner / RFID Reader:
  Fixed-mount scanner reads barcode on each item
  Triggers sort decision based on destination
  Integration: scanner → PLC/WCS → divert command

Scale (In-Motion Weighing):
  Conveyor section with load cells
  Weighs items at full belt speed (± 0.5% accuracy)
  Use: weight-based sorting, shipping manifest verification

--- Motor Control ---

VFD (Variable Frequency Drive):
  Controls motor speed by varying AC frequency
  Soft start/stop (no jarring acceleration)
  Speed adjustment: 10-100% of rated speed
  Energy savings: 20-50% vs fixed-speed motors
  Required for: accumulation zones, speed matching, metering

--- PLC Logic Patterns ---

Zone Control (accumulation):
  IF downstream_zone_full THEN
    stop this zone's motor
    signal upstream: "I'm full"
  ELSE
    run motor
    signal upstream: "I'm clear"
  END IF

Gap Creation (before merge):
  IF item detected at gap sensor THEN
    slow belt to 50% speed for T seconds
    resume full speed
  END IF
  Result: creates gap on mainline for side-merge entry

Sort Decision:
  Scanner reads barcode → lookup destination in route table
  Track item position via encoder pulses from scanner
  When item reaches correct divert → fire divert
  Tracking accuracy: ± 1 inch typical

--- Communication ---
  Fieldbus: EtherNet/IP, PROFINET, Modbus TCP
  WCS (Warehouse Control System) sends sort commands
  PLC executes motor control and I/O
  SCADA/HMI displays status and alarms
EOF
}

cmd_sorting() {
    cat << 'EOF'
=== Sortation Systems ===

--- Sliding Shoe Sorter ---
  Angled shoes (slats) slide across a flat belt/slat surface
  Shoes create a diagonal wall that gently pushes items off
  Speed: 100-300+ items/min
  Item weight: up to 100 lbs
  Accuracy: 99.9%+
  Destinations: 30-100+ takeaway lanes per sorter
  Best for: parcels, polybags, cartons
  Example: FedEx, UPS hub sort systems

--- Crossbelt Sorter ---
  Individual carriers with small belt conveyors
  Each carrier independently loads and unloads items
  Loop or linear configuration
  Speed: 200-400+ items/min
  Item variety: handles odd shapes, polybags, small items
  Accuracy: 99.99%
  Best for: e-commerce, postal, high-variety operations
  Most expensive but most versatile

--- Tilt-Tray Sorter ---
  Carriers tilt to dump items into chutes below
  Circular loop of trays
  Speed: 150-250 items/min
  Best for: small items (cosmetics, electronics components)
  Limitation: items must fit in tray, no tall items

--- Pop-Up Wheel Divert ---
  Wheels pop up through roller conveyor gaps
  Angled wheels redirect items 30° or 90°
  Speed: 30-60 items/min per divert
  Cost: lowest sortation option
  Best for: carton sorting with <20 destinations

--- Bomb Bay Sorter ---
  Floor panels open like bomb bay doors
  Items fall into chutes below
  Very fast: 200+ items/min
  Best for: flat items (envelopes, polybags, books)
  Cannot handle fragile items

--- Sort Decision Flow ---
  1. Induct: item placed on sorter (manual or automated)
  2. Scan: barcode/RFID read, identify destination
  3. Track: encoder tracks exact position on sorter
  4. Sort: when item reaches destination, fire sorter mechanism
  5. Verify: confirm item left sorter (photoeye at takeaway)
  6. Recirculate: if scan fail or missed sort → goes around again

  No-read handling:
    1st pass: recirculate for re-scan
    2nd pass: divert to manual sort station
    Target no-read rate: < 1%
EOF
}

cmd_maintenance() {
    cat << 'EOF'
=== Conveyor Maintenance ===

--- Preventive Maintenance Schedule ---

Daily:
  [ ] Visual inspection for debris, damage, misalignment
  [ ] Listen for unusual noises (bearing grind, belt squeal)
  [ ] Check emergency stops function correctly
  [ ] Verify photoeyes are clean and aligned
  [ ] Check for product jams or accumulation issues

Weekly:
  [ ] Inspect belt for wear, cuts, edge fraying
  [ ] Check belt tracking (should run center ± 0.5")
  [ ] Inspect roller condition (spin freely, no flat spots)
  [ ] Clean sensors (photoeyes, scanners)
  [ ] Check chain tension (if chain-driven)

Monthly:
  [ ] Lubricate bearings (grease per manufacturer spec)
  [ ] Check motor amperage (compare to baseline)
  [ ] Inspect electrical connections for heat damage
  [ ] Verify VFD parameters haven't drifted
  [ ] Test safety devices (e-stops, pull cords, guards)

Quarterly:
  [ ] Replace worn belts (edge wear > 0.5", surface cracking)
  [ ] Check reducer oil level and condition
  [ ] Inspect drive components (sprockets, pulleys, couplings)
  [ ] Calibrate in-motion scales
  [ ] Review alarm/fault history for patterns

--- Common Failures ---

Belt Tracking Off-Center:
  Causes: uneven loading, misaligned rollers, worn edge
  Fix: adjust tracking roller/idler, check for debris under belt
  Prevention: keep load centered, regular roller alignment

Belt Slippage:
  Causes: worn lagging on drive roller, low tension, oil contamination
  Symptoms: motor runs but belt moves slow or stops
  Fix: re-tension belt, replace lagging, clean belt and rollers

Motor Overheating:
  Causes: overloading, VFD fault, bearing failure, insufficient cooling
  Check: amperage vs nameplate, bearing temperature, VFD faults
  Fix: reduce load, replace bearings, verify VFD settings

Roller Failure:
  Causes: bearing failure, overloading, corrosion, impact damage
  Symptoms: roller doesn't spin, squealing noise, flat spot
  Fix: replace roller (keep spares in stock)
  Impact: one stuck roller can damage belt or cause jams

Jam at Transfer Points:
  Causes: speed mismatch, gap too large, product shape inconsistency
  Fix: match speeds between conveyors, add dead plates at gaps
  Prevention: nose-over rollers, smooth transitions
EOF
}

cmd_safety() {
    cat << 'EOF'
=== Conveyor Safety ===

Conveyor systems are the #1 source of material handling injuries
in warehouses and factories. Take safety seriously.

--- Hazard Points ---

  Nip Points:    Where belt meets roller (in-running nip)
                 Can pull in fingers, clothing, hair
                 Guard ALL nip points with covers or barriers

  Shear Points:  Where moving parts pass fixed structures
                 Especially at transfers, diverts, curves
                 Maintain clearance or guard

  Pinch Points:  Between moving items and fixed guards/structures
                 Common at merge points and curves

  Falls:         Elevated conveyors without walkway guardrails
                 Crossovers without proper stairs/platforms

--- Required Safety Devices ---

Emergency Stop (E-Stop):
  Red mushroom-head button, yellow background
  Located every 50-100 feet along conveyor
  Stops ALL connected conveyors when pressed
  Must require manual reset (not auto-restart)

Pull Cord:
  Continuous cable along conveyor length
  Pull from anywhere to stop
  Required on conveyors > 100 feet
  Common in mining and bulk handling

Safety Guarding:
  Fixed guards: cover all nip points, drive components
  Interlocked guards: conveyor stops when guard is opened
  Material: steel mesh, polycarbonate panels
  Standards: OSHA 1910.212, ANSI B20.1, EN 619

Light Curtains:
  Infrared beam array across access points
  Stops conveyor if beam is broken
  Used at manual induction/removal stations

--- Lockout/Tagout (LOTO) ---
  Before any maintenance:
  1. Press E-stop
  2. Disconnect main power
  3. Apply personal lock to disconnect
  4. Apply "DO NOT OPERATE" tag
  5. Verify zero energy (try to start)
  6. Perform maintenance
  7. Remove lock/tag, re-energize, test

--- Standards & Regulations ---
  OSHA 1910.212     General machine guarding
  ANSI/ASME B20.1   Safety standard for conveyors
  EN 619            Conveyor safety (European)
  NFPA 79           Electrical standard for industrial machinery
  ISO 12100         Safety of machinery — general principles

--- Training Requirements ---
  All personnel near conveyors must be trained on:
  [ ] Location of all E-stops and pull cords
  [ ] How to perform LOTO
  [ ] What nip/pinch/shear points look like
  [ ] Proper clothing (no loose sleeves, jewelry, long hair tied)
  [ ] Never ride on a conveyor
  [ ] Never reach under a moving belt
  [ ] Report any damage, unusual noise, or safety concern
EOF
}

show_help() {
    cat << EOF
conveyor v$VERSION — Conveyor System Reference

Usage: script.sh <command>

Commands:
  intro        Conveyor systems overview and selection criteria
  types        Conveyor types: belt, roller, chain, screw, pneumatic
  sizing       Engineering calculations: speed, throughput, motor power
  layout       Layout design: curves, merges, diverts, accumulation
  controls     Controls and sensors: photoeyes, encoders, VFDs, PLC
  sorting      Sortation systems: shoe, crossbelt, tilt-tray, pop-up
  maintenance  Preventive maintenance and troubleshooting
  safety       Safety standards, guarding, e-stops, LOTO
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    types)       cmd_types ;;
    sizing)      cmd_sizing ;;
    layout)      cmd_layout ;;
    controls)    cmd_controls ;;
    sorting)     cmd_sorting ;;
    maintenance) cmd_maintenance ;;
    safety)      cmd_safety ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "conveyor v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
