#!/usr/bin/env bash
# endeffector — Robot End Effector Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== End Effector Fundamentals ===

An end effector is the device at the end of a robotic arm that
interacts with the environment. It's the "business end" of the robot.

Categories:
  Gripping     Hold and move objects (grippers, vacuum, magnetic)
  Processing   Perform work on objects (welding, cutting, painting)
  Sensing      Inspect or measure (cameras, probes, force sensors)
  Dispensing   Apply material (glue, sealant, paint)
  Fastening    Join parts (screwdriving, riveting, nut running)

Selection Criteria:
  1. Task requirements (grip, process, inspect?)
  2. Workpiece properties (size, weight, material, temperature)
  3. Cycle time and speed requirements
  4. Accuracy and repeatability needs
  5. Environment (clean, dirty, wet, explosive?)
  6. Robot payload capacity (tool + workpiece)
  7. Utility needs (air, electric, water, signals)
  8. Maintenance and changeover frequency

Key Terms:
  TCP    Tool Center Point — the reference point for robot motion
  EOAT   End of Arm Tooling — same as end effector
  Flange  Robot mounting interface (ISO standard)
  Payload  Max weight robot can handle at TCP (tool + workpiece)
  Moment   Rotational force at wrist (affected by tool length/weight)
  Inertia  Resistance to rotational acceleration
EOF
}

cmd_types() {
    cat << 'EOF'
=== End Effector Types ===

Grippers:
  Parallel jaw    Two fingers, linear motion
  Angular         Fingers pivot, wider opening
  Three-jaw       Self-centering, round parts
  Vacuum          Suction cups for flat objects
  Magnetic        Electromagnetic/permanent, ferrous parts
  Soft/adaptive   Compliant fingers, variable shapes

Welding Torches:
  MIG/MAG (GMAW)  Wire-fed, gas-shielded, most common robot welding
  TIG (GTAW)       High quality, slower, thin materials
  Spot welding     Resistance welding, automotive body panels
  Laser welding    High speed, deep penetration, minimal distortion
  Typical: water-cooled, wire feeder, gas supply through arm

Cutting Tools:
  Laser cutting    CO2 or fiber laser, thin to medium sheet
  Plasma cutting   Thick metal, high speed
  Waterjet         No heat affected zone, any material
  Router/spindle   Trimming, deburring, milling
  Ultrasonic       Composites, food, textiles

Spray/Dispensing:
  Paint spray      Electrostatic bell cup (automotive)
  Adhesive         Bead dispensing, dot dispensing
  Sealant          Seam sealing, underbody coating
  Thermal spray    Metal/ceramic coating

Measurement/Inspection:
  3D vision camera   Part location, quality inspection
  Laser scanner      Profile measurement, seam tracking
  Touch probe        Dimensional verification
  Force/torque sensor  Assembly feedback, polishing

Material Removal:
  Deburring spindle   Remove machining burrs
  Grinding wheel      Surface finishing
  Polishing pad       Mirror finish, buffing
  Sanding disc        Wood, composite finishing
EOF
}

cmd_flanges() {
    cat << 'EOF'
=== Robot Flange Standards ===

ISO 9409-1 (Robot Flange Interfaces):
  Defines mechanical interface between robot and tool

Common Flange Sizes:
  ISO 9409-1-31.5  Small robots (3-5 kg payload)
    Bolt circle: 31.5mm, 4× M5 bolts
    Centering: 31.5mm pilot diameter
  
  ISO 9409-1-40    Small-medium robots (5-10 kg)
    Bolt circle: 40mm, 4× M6 bolts
  
  ISO 9409-1-50    Medium robots (10-20 kg)
    Bolt circle: 50mm, 4× M6 bolts
    Most common for collaborative robots
  
  ISO 9409-1-63    Medium-large (20-50 kg)
    Bolt circle: 63mm, 6× M6 bolts
  
  ISO 9409-1-100   Large robots (50-150 kg)
    Bolt circle: 100mm, 6× M8 bolts
  
  ISO 9409-1-125   Heavy-duty (100-300 kg)
    Bolt circle: 125mm, 6× M10 bolts
  
  ISO 9409-1-200   Very heavy (300+ kg)
    Bolt circle: 200mm, 8× M12 bolts

Robot-Specific Flanges:
  Universal Robots   ISO 9409-1-50 (UR3/5/10/16/20)
  FANUC             Varies by model (custom + ISO options)
  KUKA              ISO compliant, model-specific
  ABB               ISO compliant, model-specific
  Yaskawa           ISO compliant

Mounting Best Practices:
  - Use dowel pins for precise alignment (not just bolts)
  - Torque bolts to manufacturer spec (use torque wrench)
  - Apply thread-lock compound on critical joints
  - Verify flatness of mating surfaces
  - Record mounting orientation for TCP calibration
EOF
}

cmd_tcp() {
    cat << 'EOF'
=== Tool Center Point (TCP) Calibration ===

What is TCP:
  The point on the tool where the robot "thinks" it is.
  All programmed positions are relative to TCP.
  Wrong TCP = wrong positions = collisions or bad quality.

4-Point Method (Most Common):
  1. Mount a sharp reference point in the workspace (fixed needle)
  2. Move TCP to touch the reference point from 4+ different angles
  3. Robot controller calculates TCP from the intersection
  4. Accuracy: typically ±1mm

  Orientations should be as different as possible:
    - Approach from top, left, right, tilted
    - Minimum 4 points, 5-6 is better
    - Keep reference point stationary and rigid

6-Point Method (TCP + Orientation):
  Points 1-4: define TCP position (same as 4-point)
  Point 5: tool pointing straight down (+Z direction)
  Point 6: tool rotated to define +X direction
  Result: full TCP frame (position + orientation)

External Measurement:
  Using laser tracker or measurement arm
  Measure actual TCP position relative to flange
  Enter values directly: X, Y, Z, Rx, Ry, Rz
  Most accurate method (±0.1mm possible)

Verification:
  After calibration, verify by:
  1. Move to a known reference point from multiple angles
  2. TCP should arrive at same position regardless of approach
  3. Acceptable error: < 1mm for handling, < 0.5mm for welding
  4. If error too large: redo calibration or check tool rigidity

Common Mistakes:
  - Reference point not rigid (moves during touch)
  - Not enough angle variation between points
  - Tool deflects under its own weight (heavy tools)
  - Forgetting to update TCP after tool maintenance
  - Wrong coordinate convention (mm vs m, degrees vs radians)
EOF
}

cmd_changers() {
    cat << 'EOF'
=== Automatic Tool Changers ===

Purpose:
  Allow a robot to swap end-effectors automatically
  One robot handles multiple tasks (gripper → drill → camera)
  Reduces number of robots needed

Components:
  Master side    Mounted on robot flange (stays on robot)
  Tool side      Mounted on each end-effector (stored in rack)
  Tool rack      Docking station for unused tools
  Lock mechanism Holds master and tool together during operation

Locking Mechanisms:
  Pneumatic     Air-driven ball lock (most common)
    + Fast coupling (< 1 sec), high force
    - Needs air supply, fails if air lost
  
  Electric      Motor or solenoid actuated
    + No air needed, position feedback
    - Slower, more complex
  
  Mechanical    Cam or bayonet twist-lock
    + No utilities needed, fail-safe
    - Manual or requires rotation motion

Utility Pass-Through:
  Pneumatic     Air lines for grippers, cylinders
  Electrical    Power (24V, 48V), signals (I/O, analog)
  Communication EtherCAT, Profinet, DeviceNet, IO-Link
  Fluid         Water cooling, adhesive, paint
  
  Module types are stackable (add what you need)
  Contact count: 4 to 48+ electrical contacts typical

Major Manufacturers:
  ATI Industrial    Force sensors + tool changers
  Schunk SWS/SHS    Wide range, pneumatic/electric
  Stäubli MPS       High-speed, clean applications
  Destaco QC/TC     Pneumatic, cost-effective
  Nitta             Compact, lightweight

Design Considerations:
  - Total weight: master + tool side + utilities
  - Alignment accuracy after coupling (repeatability)
  - Locking force vs tool weight + dynamic loads
  - Utility requirements (how many air/electric lines?)
  - Rack placement within robot reach
  - Collision avoidance during tool change motion
EOF
}

cmd_design() {
    cat << 'EOF'
=== Custom End Effector Design ===

Design Principles:
  1. Minimize weight (every gram counts against payload)
  2. Maximize stiffness (flex = position error)
  3. Keep cables/hoses inside or well-routed
  4. Design for maintenance (quick-swap wearing parts)
  5. Consider failure modes (what happens if air/power lost?)

Material Selection:
  Aluminum 6061-T6   Good strength-to-weight, easy to machine
  Aluminum 7075      Higher strength, aerospace applications
  Carbon fiber       Lightest, highest stiffness, expensive
  Steel              Only where strength absolutely required
  3D printed (PLA/PETG/PA)  Prototyping, light-duty tooling
  3D printed (metal)  Complex geometries, production use

Weight Budget:
  Robot payload = tool weight + workpiece weight + safety margin
  
  Example: Robot rated 10 kg payload
    Workpiece:     3 kg
    Safety margin: 1 kg (10%)
    Tool budget:   6 kg max
    
  Tip: weigh everything including cables, hoses, connectors

Stiffness Considerations:
  F = k × δ   (force = stiffness × deflection)
  Long tools = more deflection (moment arm)
  I-beam or box section profiles are stiffer than solid round
  Add ribs at stress concentration points
  FEA (Finite Element Analysis) for critical applications

Cable Routing:
  - Route cables through or along the tool structure
  - Use cable carriers (drag chains) for moving joints
  - Strain relief at both ends
  - Service loop for rotation (avoid cable wrap)
  - Quick-disconnect connectors for tool changes
  - Label all cables and connectors

Pneumatic Integration:
  - Mount valves on tool (reduces air line length)
  - Use manifold blocks (fewer fittings)
  - Size lines for flow rate (don't choke the cylinder)
  - Add quick-exhaust valves for speed
EOF
}

cmd_payload() {
    cat << 'EOF'
=== Payload Calculation ===

Robot Payload Capacity:
  The maximum load at the tool flange, including:
  - End effector weight
  - Workpiece weight
  - Any fixturing, adapters, or cables

  NOT just a weight limit — also moment and inertia limits!

Weight Check:
  Total mass = M_tool + M_workpiece + M_adapter
  Must be ≤ robot rated payload

  Example:
    Robot payload: 10 kg
    Tool: 4.2 kg
    Adapter plate: 0.3 kg
    Available for workpiece: 10 - 4.2 - 0.3 = 5.5 kg

Moment Check (Often the Real Limit):
  Moment = Force × Distance
  M = m × g × L

  Where:
    m = mass at center of gravity (kg)
    g = 9.81 m/s²
    L = distance from flange to CoG (m)

  Robot wrist has moment limits for each axis (J4, J5, J6)
  Check manufacturer datasheet for Mx, My, Mz limits

  Example:
    Tool CoG at 150mm from flange, total mass 8 kg
    M = 8 × 9.81 × 0.15 = 11.8 Nm
    If robot J6 moment limit = 10 Nm → EXCEEDED!
    Solution: lighter tool or shorter design

Inertia Check:
  J = m × r²  (for point mass approximation)
  Affects acceleration capability of wrist joints
  High inertia = slower motion or robot fault
  Check J4, J5, J6 inertia limits in robot datasheet

  To reduce inertia:
    - Move mass closer to flange (shorter tool)
    - Use lighter materials
    - Distribute mass symmetrically

Center of Gravity:
  Must be reported accurately to robot controller
  Offset CoG = uneven wear on joints, reduced accuracy
  Measure or calculate from CAD model
  Enter in robot: mass, CoG(x,y,z), inertia(Ix,Iy,Iz)
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== End Effector Checklist ===

Selection:
  [ ] Task requirements defined (grip, process, inspect)
  [ ] Workpiece properties documented (weight, size, material)
  [ ] Cycle time target established
  [ ] Robot payload verified (weight + moment + inertia)
  [ ] Environment requirements noted (IP rating, temp, clean)
  [ ] Utility requirements listed (air, electric, fluid)

Design / Procurement:
  [ ] Tool weight within payload budget
  [ ] Flange interface matches robot (ISO 9409-1)
  [ ] Cable/hose routing planned
  [ ] Failure mode analysis done (what if air/power lost?)
  [ ] Spare parts identified and ordered
  [ ] Tool drawing and BOM documented

Installation:
  [ ] Flange bolts torqued to spec
  [ ] Dowel pins installed for alignment
  [ ] All utility connections secure (air, electric)
  [ ] Cables routed and strain-relieved
  [ ] Tool mass and CoG entered in robot controller

Calibration:
  [ ] TCP calibrated (4-point or 6-point method)
  [ ] TCP verified from multiple approach angles
  [ ] Tool frame orientation correct
  [ ] Payload data entered (mass, CoG, inertia)

Commissioning:
  [ ] Manual jog test at low speed
  [ ] Automatic cycle test at reduced speed
  [ ] Full speed test with production parts
  [ ] Verify accuracy meets specification
  [ ] Emergency stop behavior confirmed
  [ ] Maintenance schedule documented
EOF
}

show_help() {
    cat << EOF
endeffector v$VERSION — Robot End Effector Reference

Usage: script.sh <command>

Commands:
  intro      End effector fundamentals and selection criteria
  types      Types: grippers, welding, cutting, spraying, sensing
  flanges    ISO flange standards and mounting interfaces
  tcp        Tool Center Point calibration methods
  changers   Automatic tool changers and utility pass-through
  design     Custom end effector design guidelines
  payload    Payload, moment, and inertia calculation
  checklist  Selection and commissioning checklist
  help       Show this help
  version    Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    types)      cmd_types ;;
    flanges)    cmd_flanges ;;
    tcp)        cmd_tcp ;;
    changers)   cmd_changers ;;
    design)     cmd_design ;;
    payload)    cmd_payload ;;
    checklist)  cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "endeffector v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
