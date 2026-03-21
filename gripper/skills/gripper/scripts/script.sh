#!/usr/bin/env bash
# gripper — Robot Gripper Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Robot Gripper Fundamentals ===

A gripper is an end-effector mounted on a robot arm that grasps,
holds, and releases workpieces. It's the robot's "hand."

Actuation Methods:
  Pneumatic    Compressed air drives piston/cylinder
    + Fast, simple, high force-to-size ratio
    - Binary (open/close), needs air supply, noisy
  
  Electric     Servo or stepper motor drives mechanism
    + Precise position/force control, programmable
    - Slower, more expensive, complex control
  
  Hydraulic    Oil pressure drives piston
    + Very high force, smooth motion
    - Heavy, messy, expensive, maintenance-heavy
  
  Vacuum       Negative pressure holds via suction cups
    + Gentle, handles flat/smooth objects well
    - Porous/irregular surfaces don't seal

Key Specifications:
  Gripping Force    Force applied to workpiece (N)
  Stroke            Opening/closing distance (mm)
  Closing Time      Time to fully close (ms)
  Repeat Accuracy   Position repeatability (mm)
  Weight            Gripper mass (affects robot payload)
  IP Rating         Dust/water ingress protection
  Finger Length     Distance from jaw pivot to contact point

Major Manufacturers:
  Schunk        Market leader, parallel/centric grippers
  SMC           Pneumatic grippers, wide range
  Festo         Pneumatic + adaptive/soft grippers
  Zimmer        Versatile, GEP/GPP series
  Robotiq       Collaborative robot grippers (2F/3F)
  OnRobot       Electric grippers + sensors for cobots
  SCHMALZ       Vacuum gripping systems
  Destaco       Toggle clamps and grippers
EOF
}

cmd_types() {
    cat << 'EOF'
=== Gripper Types ===

Parallel Jaw Gripper:
  Fingers move in parallel (linear motion)
  Most common industrial gripper
  2-finger (external/internal grip)
  Good for: prismatic parts, cylinders, boxes
  Brands: Schunk PGN-plus, SMC MHZ2

Angular Gripper:
  Fingers pivot around a point (arc motion)
  Wider opening with compact design
  Good for: larger parts, limited-space applications
  Angle: typically 30°-180° per jaw
  Brands: Schunk MPC, SMC MHC2

Three-Jaw (Centric) Gripper:
  Three fingers close simultaneously to center
  Self-centering for round/irregular parts
  Good for: cylindrical parts, rings, shafts
  Brands: Schunk PZN-plus, Festo DHPS

Vacuum Gripper:
  Suction cups on frame/tooling plate
  Single or multi-cup arrays
  Good for: flat objects (sheets, glass, boxes, PCBs)
  Needs: vacuum generator (venturi or pump)

Magnetic Gripper:
  Electro-permanent or electromagnetic
  No moving parts, instant grip/release
  Good for: ferrous metal sheets, stamped parts
  Limitation: ferrous materials only

Soft / Adaptive Gripper:
  Compliant fingers conform to object shape
  Fin Ray, pneumatic bladder, or elastomer designs
  Good for: variable products, food, fragile items
  Brands: Soft Robotics, Festo DHEF, Robotiq

Needle Gripper:
  Fine needles penetrate soft material
  Good for: textiles, foam, carbon fiber preforms
  Low damage to material surface

Tool Changer:
  Not a gripper itself — swaps end-effectors
  Allows robot to use multiple gripper types
  Brands: ATI, Schunk SWS, Stäubli
  Pneumatic/electric/manual coupling
EOF
}

cmd_force() {
    cat << 'EOF'
=== Grip Force Calculation ===

Basic Formula (vertical lift, gravity opposing grip):
  F_grip = m × g × S / (μ × n)

  Where:
    F_grip = required gripping force per finger (N)
    m      = workpiece mass (kg)
    g      = gravity (9.81 m/s²)
    S      = safety factor (typically 2-4)
    μ      = friction coefficient
    n      = number of gripping surfaces (usually 2)

Safety Factor Guidelines:
  S = 2    Static handling (pick and place, low speed)
  S = 3    Dynamic with acceleration (conveyor loading)
  S = 4    High speed, vibration, uncertain conditions

Friction Coefficients (μ):
  Steel on steel (dry)           0.15-0.20
  Steel on rubber jaw            0.50-0.80
  Aluminum on rubber             0.40-0.60
  Plastic on rubber              0.40-0.60
  Cardboard on rubber            0.50-0.70
  Glass on rubber (suction)      0.50-0.70
  Oily metal on metal            0.05-0.10
  Serrated jaw on metal          0.30-0.50

Dynamic Forces to Consider:
  Acceleration: F = m × a (add to gravity load)
  Centrifugal: F = m × ω² × r (rotation at speed)
  Impact: sudden stop multiplies force 2-5×

Example Calculation:
  Part: 2 kg steel cylinder, rubber jaws
  Motion: pick up vertically, moderate speed
  
  F_grip = 2 × 9.81 × 3 / (0.6 × 2)
  F_grip = 58.86 / 1.2
  F_grip = 49.1 N per finger

  Select gripper rated ≥ 50N per finger

Vacuum Force:
  F = (P_vacuum × A_cup × n) / S
  P_vacuum = vacuum level (typically -0.6 to -0.85 bar)
  A_cup = suction cup area (m²)
  n = number of cups
  
  Bellows cups: better on curved surfaces
  Flat cups: higher force, smooth surfaces only
EOF
}

cmd_pneumatic() {
    cat << 'EOF'
=== Pneumatic Grippers ===

Air Supply Requirements:
  Pressure: typically 4-6 bar (60-90 psi)
  Clean, dry air (ISO 8573-1 Class 4 or better)
  Filter-Regulator-Lubricator (FRL) unit required
  Flow: depends on cylinder bore and cycle rate

Cylinder Types:
  Single-acting: spring return, air on one side
    + Simpler, fail-safe (spring opens/closes on air loss)
    - Lower force in one direction
  
  Double-acting: air on both sides
    + Full force both directions, adjustable speed
    - Needs 2 air lines, no fail-safe position

Valve Selection:
  5/2 valve: double-acting cylinders (2 positions)
  5/3 valve: center position options:
    - Center closed: holds position on air loss
    - Center exhaust: releases on air loss
    - Center pressure: maintains force on air loss
  
  Solenoid voltage: 24VDC (most common industrial)

Circuit Design:
  Air supply → FRL → Directional valve → Gripper
  Add flow controls (meter-out) for speed adjustment
  Add quick-exhaust for faster closing
  Proximity sensors on cylinder for position feedback

Speed Adjustment:
  Flow control valves (needle valves)
  Meter-out preferred (controls exhaust, smoother)
  Typical close time: 30-100ms
  Shock absorbers for high-speed applications

Sensors:
  Magnetic reed switches on cylinder barrel
  Detect open and closed positions
  PNP (sourcing) or NPN (sinking) output
  Hall-effect for higher reliability than reed
EOF
}

cmd_electric() {
    cat << 'EOF'
=== Electric Grippers ===

Advantages Over Pneumatic:
  - Programmable position (not just open/close)
  - Adjustable grip force (gentle for fragile parts)
  - No air supply needed (cleaner, simpler install)
  - Quieter operation
  - Energy efficient (no compressor)
  - Position and force feedback built-in
  - Multiple grip positions in one program

Motor Types:
  Servo motor: precise position + velocity control
  Stepper motor: open-loop, simpler, lower cost
  Brushless DC: compact, long life
  Linear motor: direct drive, no mechanism backlash

Drive Mechanisms:
  Lead screw: high force, compact, self-locking
  Ball screw: smoother, higher efficiency, higher speed
  Rack and pinion: simple, parallel motion
  Linkage: force multiplication, compact
  Belt drive: long stroke, lightweight

Key Parameters:
  Stroke:        5-150mm typical
  Gripping force: 5-1000N+ depending on size
  Close speed:   50-500mm/s
  Repeatability: 0.01-0.05mm
  Communication: IO-Link, EtherCAT, Profinet, Modbus

Popular Electric Grippers:
  Schunk EGP/EGH    Parallel/centric, IO-Link
  Robotiq 2F-85/140  Adaptive, cobot-ready
  OnRobot RG2/RG6    Easy setup, force sensing
  Festo EHPS          Parallel, servo-pneumatic hybrid
  Zimmer GEH6000      Heavy-duty electric

When to Choose Electric:
  - Force/position control needed (fragile/variable parts)
  - Cleanroom or food-grade (no air contamination)
  - Collaborative robot (cobot) applications
  - Energy savings matter (no compressor running 24/7)
  - Complex grip sequences (multiple widths per cycle)
EOF
}

cmd_vacuum() {
    cat << 'EOF'
=== Vacuum Grippers ===

Vacuum Generation:
  Venturi (ejector):
    Compressed air creates vacuum via Bernoulli effect
    + Simple, no moving parts, fast response
    - Consumes compressed air, limited vacuum level
    Typical: -0.6 to -0.85 bar vacuum
  
  Vacuum pump (electric):
    Mechanical pump creates vacuum
    + Higher vacuum, more efficient for multi-cup
    - Slower response, maintenance, noise
    Types: rotary vane, diaphragm, regenerative blower

Suction Cup Types:
  Flat Cup:
    Best for: smooth, flat surfaces (glass, metal sheets)
    Highest force per area, fastest response
    Materials: NBR, silicone, Viton, polyurethane

  Bellows Cup (1.5-3.5 folds):
    Best for: curved, uneven, or flexible surfaces
    Compensates height differences
    1.5 fold: slight curves
    2.5 fold: moderate unevenness
    3.5 fold: significant height variation

  Oval Cup:
    Best for: narrow, elongated workpieces
    Profiles, beams, rails

  Foam Seal Cup:
    Best for: textured, rough, or porous surfaces
    Closed-cell foam creates seal on irregular surfaces
    Cardboard boxes, wood panels, stone

Cup Sizing:
  F_hold = P_vac × A_cup × n_cups
  
  P_vac = vacuum pressure (Pa, typically 60,000-85,000 Pa)
  A_cup = cup area (m²), diameter × π/4
  
  Rule of thumb: select cups so total force ≥ 4× payload weight
  
  Common diameters: 10, 20, 30, 40, 50, 60, 80mm
  Material temp ranges:
    NBR:       -30 to +70°C (general purpose)
    Silicone:  -40 to +200°C (hot parts, food-grade)
    Viton:     -20 to +200°C (chemical resistance)
    PU:        -20 to +60°C (wear resistance)

Vacuum Level Monitoring:
  Vacuum switch: confirms grip before robot moves
  Analog sensor: measures actual vacuum level
  Leak detection: if vacuum drops during move → alarm
  Important: always verify grip before lifting!
EOF
}

cmd_applications() {
    cat << 'EOF'
=== Gripper Applications by Industry ===

Automotive:
  Body-in-white: magnetic grippers for steel panels
  Engine assembly: multi-finger for complex shapes
  Glass installation: large vacuum cup arrays
  Trim/clips: needle or soft grippers
  Typical: high speed (< 1s cycle), heavy loads

Electronics:
  PCB handling: ESD-safe vacuum cups, gentle force
  Chip placement: micro-grippers, ±0.01mm accuracy
  Cable assembly: soft grippers for flexible parts
  Display handling: non-marking cups (silicone)
  Typical: high precision, cleanroom compatible

Food & Beverage:
  Bakery: soft grippers (Fin Ray, bladder type)
  Meat/fish: needle grippers, food-safe material
  Bottles: parallel jaw with V-shaped fingers
  Boxes/cartons: vacuum with foam seal cups
  Requirements: FDA/EU food contact, washdown (IP67+)

Pharma & Medical:
  Syringe handling: precision parallel grippers
  Vial capping: torque-controlled electric grippers
  Blister pack: vacuum cup arrays
  Requirements: cleanroom, stainless steel, no lubricants

Logistics / E-commerce:
  Box picking: large vacuum grippers (multi-cup)
  Depalletizing: fork or clamp style
  Bin picking: 3D vision + adaptive grippers
  Variable products: AI-guided grip planning
  Challenge: huge variety of shapes, sizes, weights

Metal Fabrication:
  Sheet handling: magnetic (ferrous) or vacuum (non-ferrous)
  Stamped parts: custom jaw profiles
  CNC machine tending: hydraulic or pneumatic
  Welding: clamp-and-hold fixtures
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Gripper Selection & Commissioning Checklist ===

Part Analysis:
  [ ] Part weight (including worst-case tolerance)
  [ ] Part dimensions and shape (flat, round, irregular?)
  [ ] Surface finish (smooth, rough, oily, porous?)
  [ ] Material (steel, plastic, glass, food, fragile?)
  [ ] Temperature at time of gripping
  [ ] Part-to-part variation (one SKU or many?)

Application Requirements:
  [ ] Cycle time requirement (picks per minute)
  [ ] Robot speed and acceleration (dynamic forces)
  [ ] Orientation changes during handling (tilt, rotate)
  [ ] Accuracy needed (placement tolerance)
  [ ] Environment (clean, dirty, wet, hot, cold?)
  [ ] Cleanroom / food-grade / ESD requirements

Gripper Sizing:
  [ ] Grip force calculated with safety factor (≥ 2×)
  [ ] Stroke covers full range of part sizes
  [ ] Gripper weight within robot payload budget
  [ ] Mounting interface compatible with robot flange
  [ ] Finger/jaw length sized for part geometry

Installation:
  [ ] Air supply connected, FRL unit installed (pneumatic)
  [ ] Electrical connections: power, signal, communication
  [ ] Position sensors wired and tested (open/close detect)
  [ ] Gripper mounted square to robot flange
  [ ] TCP (Tool Center Point) calibrated in robot controller

Commissioning:
  [ ] Manual jog test: open/close at low speed
  [ ] Grip force verified (force gauge or crush test)
  [ ] Cycle time measured and meets target
  [ ] Grip confirmed before robot moves (sensor/vacuum check)
  [ ] Emergency stop releases part safely (fail mode)
  [ ] Run 100+ cycles, check for slip or misalignment
  [ ] Document: gripper model, jaw design, settings, spares
EOF
}

show_help() {
    cat << EOF
gripper v$VERSION — Robot Gripper Reference

Usage: script.sh <command>

Commands:
  intro        Gripper fundamentals, actuation, specifications
  types        Gripper types: parallel, angular, vacuum, soft
  force        Grip force calculation and safety factors
  pneumatic    Pneumatic gripper systems and circuits
  electric     Electric gripper advantages and selection
  vacuum       Vacuum grippers, cups, and sizing
  applications Industry applications: auto, food, electronics
  checklist    Gripper selection and commissioning checklist
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    types)        cmd_types ;;
    force)        cmd_force ;;
    pneumatic)    cmd_pneumatic ;;
    electric)     cmd_electric ;;
    vacuum)       cmd_vacuum ;;
    applications) cmd_applications ;;
    checklist)    cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "gripper v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
