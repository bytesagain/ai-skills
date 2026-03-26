#!/usr/bin/env bash
# cam — CAM: Computer-Aided Manufacturing Toolpath Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="2.0.1"

cmd_speeds_feeds() {
    local material="${1:-}"
    if [ -z "$material" ]; then
        cat << 'EOF'
═══════════════════════════════════════════════════
  Cutting Speed & Feed Rate Reference
═══════════════════════════════════════════════════

Usage: bash scripts/script.sh speeds-feeds <material>
  Materials: aluminum, steel, stainless, titanium, brass, plastic, wood

【Speed Formula】
  RPM = (SFM × 12) / (π × Diameter)
  
  SFM = Surface Feet per Minute (from material table)
  Diameter = Tool diameter in inches

【Feed Formula】
  Feed Rate (IPM) = RPM × Number of Flutes × Chip Load per Tooth

【Quick Reference — HSS End Mills】
  Material          SFM      Chip Load (per tooth, 1/2" EM)
  ──────────────────────────────────────────────────────────
  Aluminum 6061     600-1000   0.004-0.006"
  Mild Steel        80-120     0.002-0.004"
  Stainless 304     40-80      0.001-0.003"
  Titanium Ti-6Al   30-60      0.001-0.002"
  Brass             200-400    0.003-0.005"
  Plastics          500-800    0.005-0.010"
  Hardwood          400-600    0.004-0.008"

【Carbide Multiplier】
  Carbide tools: SFM × 2.5-4x compared to HSS
  Coated carbide: additional 20-50% increase

📖 More skills: bytesagain.com
EOF
        return
    fi

    MATERIAL="$material" python3 << 'PYEOF'
import os, math

material = os.environ["MATERIAL"].lower()

data = {
    "aluminum": {"sfm_low": 600, "sfm_high": 1000, "chip_low": 0.004, "chip_high": 0.006, "grade": "6061-T6", "carbide_mult": 3.0},
    "steel":    {"sfm_low": 80,  "sfm_high": 120,  "chip_low": 0.002, "chip_high": 0.004, "grade": "1018/1045", "carbide_mult": 3.0},
    "stainless":{"sfm_low": 40,  "sfm_high": 80,   "chip_low": 0.001, "chip_high": 0.003, "grade": "304/316", "carbide_mult": 2.5},
    "titanium": {"sfm_low": 30,  "sfm_high": 60,   "chip_low": 0.001, "chip_high": 0.002, "grade": "Ti-6Al-4V", "carbide_mult": 2.0},
    "brass":    {"sfm_low": 200, "sfm_high": 400,   "chip_low": 0.003, "chip_high": 0.005, "grade": "C360", "carbide_mult": 2.5},
    "plastic":  {"sfm_low": 500, "sfm_high": 800,   "chip_low": 0.005, "chip_high": 0.010, "grade": "Acetal/Nylon", "carbide_mult": 1.5},
    "wood":     {"sfm_low": 400, "sfm_high": 600,   "chip_low": 0.004, "chip_high": 0.008, "grade": "Hardwood", "carbide_mult": 1.5},
}

if material not in data:
    print(f"Unknown material: {material}")
    print(f"Available: {', '.join(data.keys())}")
    exit(1)

m = data[material]
print("=" * 55)
print(f"  Speeds & Feeds — {material.title()} ({m['grade']})")
print("=" * 55)

for dia in [0.125, 0.25, 0.375, 0.5, 0.75, 1.0]:
    sfm_avg = (m["sfm_low"] + m["sfm_high"]) / 2
    rpm = (sfm_avg * 12) / (math.pi * dia)
    chip_avg = (m["chip_low"] + m["chip_high"]) / 2
    flutes = 2 if material in ["aluminum", "plastic", "wood"] else 4
    feed = rpm * flutes * chip_avg
    print(f"\n  Tool: {dia}\" end mill, {flutes} flute (HSS)")
    print(f"  RPM:  {int(rpm):,}")
    print(f"  Feed: {feed:.1f} IPM")
    print(f"  Chip: {chip_avg:.4f}\" per tooth")

    carb_rpm = int(rpm * m["carbide_mult"])
    carb_feed = carb_rpm * flutes * chip_avg
    print(f"  Carbide: {carb_rpm:,} RPM / {carb_feed:.1f} IPM")

print(f"\n📖 More skills: bytesagain.com")
PYEOF
}

cmd_toolpath() {
    cat << 'EOF'
═══════════════════════════════════════════════════
  CNC Toolpath Strategies
═══════════════════════════════════════════════════

【Roughing Strategies】
  Adaptive/HSM (High Speed Machining):
    - Constant tool engagement angle
    - Light radial, full axial depth
    - 2-3x faster than conventional
    - Best for: pockets, large material removal
    - Stepover: 10-25% of tool diameter
    - Depth: up to 2x tool diameter

  Conventional Pocket:
    - Zigzag or spiral pattern
    - Moderate radial + axial depth
    - Higher tool wear than adaptive
    - Best for: simple pockets, soft materials

  Plunge Roughing:
    - Axial plunges like drilling
    - Converts radial load to axial
    - Best for: deep slots, weak setups

【Finishing Strategies】
  Contour/Profile:
    - Follow part outline at final depth
    - Leave 0.005-0.010" stock for spring pass
    - Climb milling preferred

  Parallel/Raster:
    - Linear passes across surface
    - Stepover: 5-15% of tool diameter
    - Good for: flat areas, gentle curves

  Scallop:
    - Constant cusp height
    - Variable stepover based on curvature
    - Best for: complex 3D surfaces

  Pencil:
    - Traces inside corners and fillets
    - Removes scallop leftover material
    - Run after parallel/scallop finish

【Entry Methods】
  Ramp:   Gradual linear descent (safest)
  Helix:  Circular descent into pocket (preferred for pockets)
  Plunge: Straight down (only for center-cutting tools)
  Pre-drill: Drill entry point first (for hard materials)

【Stepover Guidelines】
  Operation          Stepover (% of tool dia)
  ──────────────────────────────────────────
  Adaptive rough     10-25%
  Conv. rough        40-60%
  Finish parallel    5-15%
  Finish scallop     3-10%
  Pencil trace       N/A (follows geometry)

📖 More skills: bytesagain.com
EOF
}

cmd_gcode() {
    cat << 'EOF'
═══════════════════════════════════════════════════
  G-Code Quick Reference (Fanuc/ISO)
═══════════════════════════════════════════════════

【Motion Codes】
  G00   Rapid positioning (no cutting)
  G01   Linear interpolation (cutting feed)
  G02   Circular interpolation CW
  G03   Circular interpolation CCW
  G04   Dwell (pause) — G04 P1000 = 1 second

【Plane Selection】
  G17   XY plane (default, most milling)
  G18   XZ plane (lathe, side milling)
  G19   YZ plane

【Positioning】
  G28   Return to machine home
  G30   Return to 2nd reference point
  G53   Machine coordinate positioning
  G54-G59  Work coordinate systems (offsets)

【Canned Cycles (Drilling)】
  G73   High-speed peck drill (chip break)
  G76   Fine boring cycle
  G80   Cancel canned cycle
  G81   Simple drill cycle
  G82   Drill + dwell at bottom
  G83   Deep peck drilling (full retract)
  G84   Tapping cycle
  G85   Boring cycle (feed out)

【Compensation】
  G40   Cancel cutter compensation
  G41   Cutter comp left (climb)
  G42   Cutter comp right (conventional)
  G43   Tool length compensation +
  G49   Cancel tool length comp

【Common M-Codes】
  M00   Program stop (operator resume)
  M01   Optional stop
  M02   Program end
  M03   Spindle CW
  M04   Spindle CCW
  M05   Spindle stop
  M06   Tool change — M06 T01
  M08   Coolant ON
  M09   Coolant OFF
  M30   Program end + rewind

【Example Program】
  %
  O0001 (PART-NAME)
  G90 G21 G17          (Absolute, metric, XY plane)
  G28 G91 Z0           (Home Z)
  T01 M06              (Tool 1)
  G54                  (Work offset)
  S8000 M03            (Spindle 8000 RPM CW)
  G43 H01 Z50.0        (Tool length comp)
  G00 X0 Y0            (Rapid to start)
  G00 Z5.0             (Rapid to clearance)
  G01 Z-2.0 F200       (Plunge at 200mm/min)
  G01 X50.0 F500       (Cut to X50)
  G01 Y50.0            (Cut to Y50)
  G00 Z50.0            (Retract)
  G28 G91 Z0           (Home Z)
  M05                  (Spindle stop)
  M30                  (End + rewind)
  %

📖 More skills: bytesagain.com
EOF
}

cmd_materials() {
    cat << 'EOF'
═══════════════════════════════════════════════════
  Material Machinability Reference
═══════════════════════════════════════════════════

【Machinability Rating (100 = baseline 1212 steel)】
  Material              Rating    Difficulty    Coolant
  ──────────────────────────────────────────────────────
  Free-machining brass   300      Very Easy     Dry/mist
  Aluminum 6061          200      Easy          Flood/WD-40
  Aluminum 7075          180      Easy          Flood
  Free-machining steel   100      Medium        Flood
  Mild steel 1018         80      Medium        Flood
  Carbon steel 1045       65      Medium+       Flood
  4140 alloy steel        55      Moderate      Flood
  304 stainless            45      Hard          Flood+
  316 stainless            40      Hard          Flood+
  Inconel 718              12      Very Hard     High-pressure
  Titanium Ti-6Al-4V       10      Very Hard     Flood+
  Hardened steel (>45 HRC)  5      Extreme       Air blast

【Chip Control Guide】
  Long stringy chips → Increase feed rate or add chip breaker
  Powder/dust chips  → Decrease feed rate (overheating)
  Blue chips         → Too much heat, reduce speed
  Silver/clean chips → Good parameters ✅

【Coolant Selection】
  Dry:          Brass, some plastics, cast iron
  Mist/MQL:     Aluminum (prevents BUE), hardened steel
  Flood:        Steel, stainless, general purpose
  High-pressure: Titanium, Inconel, deep holes

【Work Hardening Materials ⚠️】
  304/316 Stainless, Inconel, Titanium
  Rules:
    - Never dwell in cut (keep moving)
    - Use climb milling only
    - Sharp tools only (replace at first sign of wear)
    - Minimum chip load: don't rub, CUT
    - If previous pass work-hardened: take deeper cut to get under it

📖 More skills: bytesagain.com
EOF
}

cmd_calculate() {
    local mode="${1:-}"
    if [ -z "$mode" ]; then
        echo "Usage: bash scripts/script.sh calculate <rpm|feed|time>"
        echo "  rpm   - Calculate RPM from SFM and diameter"
        echo "  feed  - Calculate feed rate from RPM and chip load"
        echo "  time  - Estimate machining time"
        return 1
    fi

    case "$mode" in
        rpm)
            local sfm="${2:-}" dia="${3:-}"
            if [ -z "$sfm" ] || [ -z "$dia" ]; then
                echo "Usage: bash scripts/script.sh calculate rpm <SFM> <diameter_inches>"
                echo "Example: bash scripts/script.sh calculate rpm 600 0.5"
                return 1
            fi
            SFM="$sfm" DIA="$dia" python3 << 'PYEOF'
import os, math
sfm = float(os.environ["SFM"])
dia = float(os.environ["DIA"])
rpm = (sfm * 12) / (math.pi * dia)
print(f"\n  SFM: {sfm}")
print(f"  Tool Diameter: {dia}\"")
print(f"  RPM = (SFM × 12) / (π × D)")
print(f"  RPM = ({sfm} × 12) / ({math.pi:.4f} × {dia})")
print(f"  RPM = {rpm:.0f}")
print(f"\n📖 More skills: bytesagain.com")
PYEOF
            ;;
        feed)
            local rpm="${2:-}" flutes="${3:-}" chipload="${4:-}"
            if [ -z "$rpm" ] || [ -z "$flutes" ] || [ -z "$chipload" ]; then
                echo "Usage: bash scripts/script.sh calculate feed <RPM> <flutes> <chipload>"
                echo "Example: bash scripts/script.sh calculate feed 5000 4 0.003"
                return 1
            fi
            RPM_VAL="$rpm" FLUTES="$flutes" CHIP="$chipload" python3 << 'PYEOF'
import os
rpm = float(os.environ["RPM_VAL"])
flutes = int(os.environ["FLUTES"])
chip = float(os.environ["CHIP"])
feed = rpm * flutes * chip
print(f"\n  RPM: {rpm:.0f}")
print(f"  Flutes: {flutes}")
print(f"  Chip Load: {chip}\" per tooth")
print(f"  Feed Rate = RPM × Flutes × Chip Load")
print(f"  Feed Rate = {rpm:.0f} × {flutes} × {chip}")
print(f"  Feed Rate = {feed:.1f} IPM")
print(f"\n📖 More skills: bytesagain.com")
PYEOF
            ;;
        time)
            local length="${2:-}" feed="${3:-}"
            if [ -z "$length" ] || [ -z "$feed" ]; then
                echo "Usage: bash scripts/script.sh calculate time <cut_length_in> <feed_ipm>"
                echo "Example: bash scripts/script.sh calculate time 24 15.5"
                return 1
            fi
            LEN="$length" FEED="$feed" python3 << 'PYEOF'
import os
length = float(os.environ["LEN"])
feed = float(os.environ["FEED"])
time_min = length / feed
print(f"\n  Cut Length: {length}\"")
print(f"  Feed Rate: {feed} IPM")
print(f"  Time = Length / Feed")
print(f"  Time = {time_min:.2f} minutes ({time_min*60:.0f} seconds)")
print(f"\n📖 More skills: bytesagain.com")
PYEOF
            ;;
        *)
            echo "Unknown mode: $mode (use rpm, feed, or time)"
            ;;
    esac
}

cmd_help() {
    cat << EOF
CAM v${VERSION} — Computer-Aided Manufacturing Toolpath Reference

Commands:
  speeds-feeds [mat]   Cutting speeds & feeds by material
  toolpath             CNC toolpath strategies (rough/finish)
  gcode                G-code & M-code quick reference
  materials            Material machinability ratings
  calculate <mode>     Calculate RPM, feed rate, or machining time
  help                 Show this help
  version              Show version

Usage:
  bash scripts/script.sh speeds-feeds aluminum
  bash scripts/script.sh gcode
  bash scripts/script.sh calculate rpm 600 0.5
  bash scripts/script.sh calculate feed 5000 4 0.003

Related skills:
  clawhub install gear
  clawhub install cnc-feeds
Browse all: bytesagain.com

Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    speeds-feeds)   shift; cmd_speeds_feeds "$@" ;;
    toolpath)       cmd_toolpath ;;
    gcode)          cmd_gcode ;;
    materials)      cmd_materials ;;
    calculate)      shift; cmd_calculate "$@" ;;
    version)        echo "cam v${VERSION}" ;;
    help|*)         cmd_help ;;
esac
