#!/usr/bin/env bash
# gear — Gear Ratio & Mechanical Drive Calculator
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="2.0.1"

cmd_ratio() {
    local driving="${1:-}"
    local driven="${2:-}"

    if [ -z "$driving" ] || [ -z "$driven" ]; then
        cat <<'EOF'
═══════════════════════════════════════════════════
  Gear Ratio Calculator
═══════════════════════════════════════════════════

Usage:
  bash scripts/script.sh ratio <driving_teeth> <driven_teeth>

Arguments:
  driving_teeth   Number of teeth on driving gear (pinion)
  driven_teeth    Number of teeth on driven gear (wheel)

Examples:
  bash scripts/script.sh ratio 20 60     → 1:3 (speed reduction)
  bash scripts/script.sh ratio 48 16     → 3:1 (speed increase)
  bash scripts/script.sh ratio 40 40     → 1:1 (direct drive)

【Gear Ratio Fundamentals】
  Ratio = Driven Teeth / Driving Teeth
  Ratio > 1 → Speed reduction, torque multiplication
  Ratio < 1 → Speed increase, torque reduction
  Ratio = 1 → Direct drive

【Common Gear Types & Typical Ratios】
  Spur Gear      1:1 to 1:6 per stage     (parallel shafts)
  Helical Gear   1:1 to 1:10 per stage    (quieter, parallel)
  Bevel Gear     1:1 to 1:5              (perpendicular shafts)
  Worm Gear      5:1 to 100:1            (right angle, self-lock)
  Planetary      3:1 to 10:1 per stage   (compact, inline)
  Harmonic       30:1 to 320:1           (zero backlash)

📖 More skills: bytesagain.com
EOF
        return 0
    fi

    DRIVING="$driving" DRIVEN="$driven" python3 -u <<'PYEOF'
import os
driving = float(os.environ["DRIVING"])
driven = float(os.environ["DRIVEN"])

ratio = driven / driving
inv_ratio = driving / driven
speed_mult = 1 / ratio
torque_mult = ratio

print("═" * 50)
print("  ⚙️  Gear Ratio Calculation")
print("═" * 50)
print(f"""
  Driving Gear (Pinion):  {driving:.0f} teeth
  Driven Gear (Wheel):    {driven:.0f} teeth

  Gear Ratio:             1:{ratio:.4f}  ({driving:.0f}:{driven:.0f})
  Inverse Ratio:          {inv_ratio:.4f}:1

  Speed Multiplier:       ×{speed_mult:.4f}
  Torque Multiplier:      ×{torque_mult:.4f}
""")

if ratio > 1:
    print("  Type: SPEED REDUCTION / TORQUE MULTIPLICATION")
    print(f"  → Output shaft runs {ratio:.2f}× slower")
    print(f"  → Output torque is {ratio:.2f}× higher (before losses)")
elif ratio < 1:
    print("  Type: SPEED INCREASE / TORQUE REDUCTION")
    print(f"  → Output shaft runs {1/ratio:.2f}× faster")
    print(f"  → Output torque is {1/ratio:.2f}× lower")
else:
    print("  Type: DIRECT DRIVE (1:1)")
    print("  → No speed or torque change")

# Module/pitch guidance
print("""
【Minimum Teeth Recommendations (to avoid undercutting)】
  Standard spur (20° pressure angle):  min 17 teeth
  Helical gear:                        min 14 teeth
  With profile shift:                  can go as low as 12

【Efficiency Estimates】
  Spur/Helical pair:  97-99% per stage
  Bevel pair:         95-98% per stage
  Worm gear:          40-90% (depends on lead angle)
  Planetary stage:    96-98% per stage
""")
print("📖 More skills: bytesagain.com")
PYEOF
}

cmd_speed() {
    local input_rpm="${1:-}"
    local ratio="${2:-}"

    if [ -z "$input_rpm" ] || [ -z "$ratio" ]; then
        cat <<'EOF'
═══════════════════════════════════════════════════
  RPM / Speed Conversion
═══════════════════════════════════════════════════

Usage:
  bash scripts/script.sh speed <input_rpm> <gear_ratio>

Arguments:
  input_rpm    Input shaft speed in RPM
  gear_ratio   Gear ratio (driven/driving)

Examples:
  bash scripts/script.sh speed 1800 3.5    → 514.3 RPM output
  bash scripts/script.sh speed 3600 0.5    → 7200 RPM output
  bash scripts/script.sh speed 1450 7.2    → 201.4 RPM output

【Speed Formulas】
  Output RPM = Input RPM / Gear Ratio
  Output Angular Velocity (rad/s) = Output RPM × 2π / 60
  Output Linear Velocity = ω × r  (at gear pitch radius)

【Common Motor Speeds (at 60 Hz)】
  2-pole:  3600 RPM (synchronous), ~3450 RPM (induction)
  4-pole:  1800 RPM (synchronous), ~1750 RPM (induction)
  6-pole:  1200 RPM (synchronous), ~1150 RPM (induction)
  8-pole:   900 RPM (synchronous), ~875 RPM (induction)

📖 More skills: bytesagain.com
EOF
        return 0
    fi

    RPM="$input_rpm" RATIO="$ratio" python3 -u <<'PYEOF'
import os, math

rpm_in = float(os.environ["RPM"])
ratio = float(os.environ["RATIO"])

rpm_out = rpm_in / ratio
omega_in = rpm_in * 2 * math.pi / 60
omega_out = rpm_out * 2 * math.pi / 60

print("═" * 50)
print("  🔄 Speed Conversion Through Gear Ratio")
print("═" * 50)
print(f"""
  Input Speed:       {rpm_in:.1f} RPM  ({omega_in:.2f} rad/s)
  Gear Ratio:        1:{ratio:.4f}
  Output Speed:      {rpm_out:.1f} RPM  ({omega_out:.2f} rad/s)

  Speed Change:      {abs(1 - 1/ratio)*100:.1f}% {'reduction' if ratio > 1 else 'increase'}
""")

# Surface speed table for common gear sizes
print("【Surface Speed at Output (Pitch Diameter)】")
print(f"  {'Diameter':>10}  {'Surface Speed':>14}  {'ft/min':>10}")
print(f"  {'─'*10}  {'─'*14}  {'─'*10}")
for d_mm in [50, 100, 150, 200, 300]:
    v_ms = omega_out * (d_mm / 1000) / 2
    v_ftmin = v_ms * 196.85
    print(f"  {d_mm:>7} mm  {v_ms:>11.2f} m/s  {v_ftmin:>7.0f}")

print(f"""
【Speed Limits by Gear Type】
  Spur gear:    < 20 m/s pitch line velocity
  Helical gear: < 40 m/s pitch line velocity
  Bevel gear:   < 20 m/s pitch line velocity
  Worm gear:    < 30 m/s sliding velocity
""")
print("📖 More skills: bytesagain.com")
PYEOF
}

cmd_torque() {
    local input_torque="${1:-}"
    local ratio="${2:-}"
    local efficiency="${3:-0.97}"

    if [ -z "$input_torque" ] || [ -z "$ratio" ]; then
        cat <<'EOF'
═══════════════════════════════════════════════════
  Torque Calculator
═══════════════════════════════════════════════════

Usage:
  bash scripts/script.sh torque <input_Nm> <gear_ratio> [efficiency]

Arguments:
  input_Nm     Input torque in Newton-meters
  gear_ratio   Gear ratio (driven/driving teeth)
  efficiency   Mesh efficiency 0-1 (default: 0.97)

Examples:
  bash scripts/script.sh torque 10 3.5          → 33.95 Nm
  bash scripts/script.sh torque 10 3.5 0.95     → 33.25 Nm
  bash scripts/script.sh torque 50 7.2 0.92     → 331.2 Nm

【Torque Formulas】
  T_out = T_in × Ratio × Efficiency
  Power = Torque × Angular Velocity = T × (2π × RPM / 60)
  P (watts) = T (Nm) × ω (rad/s)
  P (HP) = T (lb·ft) × RPM / 5252

【Unit Conversions】
  1 Nm = 0.7376 lb·ft
  1 Nm = 8.851 lb·in
  1 kgf·cm = 0.0981 Nm
  1 oz·in = 0.00706 Nm

📖 More skills: bytesagain.com
EOF
        return 0
    fi

    T_IN="$input_torque" RATIO="$ratio" EFF="$efficiency" python3 -u <<'PYEOF'
import os

t_in = float(os.environ["T_IN"])
ratio = float(os.environ["RATIO"])
eff = float(os.environ["EFF"])

t_out = t_in * ratio * eff
t_out_ideal = t_in * ratio
t_loss = t_out_ideal - t_out

print("═" * 50)
print("  🔧 Torque Calculation")
print("═" * 50)
print(f"""
  Input Torque:       {t_in:.2f} Nm  ({t_in * 0.7376:.2f} lb·ft)
  Gear Ratio:         1:{ratio:.4f}
  Mesh Efficiency:    {eff*100:.1f}%

  Output Torque:      {t_out:.2f} Nm  ({t_out * 0.7376:.2f} lb·ft)
  Ideal (no loss):    {t_out_ideal:.2f} Nm
  Friction Loss:      {t_loss:.2f} Nm  ({(1-eff)*100:.1f}%)
""")

# Power equivalence at various RPMs
print("【Power at Various Input Speeds】")
print(f"  {'Input RPM':>10}  {'Power (W)':>10}  {'Power (HP)':>10}  {'Out Torque':>11}")
print(f"  {'─'*10}  {'─'*10}  {'─'*10}  {'─'*11}")
import math
for rpm in [500, 1000, 1450, 1800, 3600]:
    omega = 2 * math.pi * rpm / 60
    power_w = t_in * omega
    power_hp = power_w / 745.7
    print(f"  {rpm:>10}  {power_w:>8.1f} W  {power_hp:>7.3f} HP  {t_out:>8.2f} Nm")

print(f"""
【Torque Design Factors】
  Service Factor (typical):
    Uniform load:         1.00
    Moderate shock:       1.25 – 1.50
    Heavy shock:          1.75 – 2.00

  Design Torque = Output Torque × Service Factor
  For {t_out:.1f} Nm with moderate shock: {t_out * 1.25:.1f} – {t_out * 1.50:.1f} Nm
""")
print("📖 More skills: bytesagain.com")
PYEOF
}

cmd_drivetrain() {
    local stages="${1:-}"

    if [ -z "$stages" ]; then
        cat <<'EOF'
═══════════════════════════════════════════════════
  Multi-Stage Drivetrain Analyzer
═══════════════════════════════════════════════════

Usage:
  bash scripts/script.sh drivetrain "<stage1>,<stage2>,..."

Each stage: driving_teeth:driven_teeth
Separate stages with commas.

Examples:
  bash scripts/script.sh drivetrain "20:60,15:45,18:72"
  bash scripts/script.sh drivetrain "12:48,16:64"
  bash scripts/script.sh drivetrain "24:72"

【Multi-Stage Gear Train Rules】
  Total Ratio = Stage1 × Stage2 × Stage3 × ...
  Total Efficiency = η₁ × η₂ × η₃ × ...
  Each intermediate shaft is both output and input

【Why Multiple Stages?】
  • Single spur gear pair: practical limit ~1:6
  • Two stages: up to 1:36
  • Three stages: up to 1:216
  • Planetary gearbox: compact multi-stage in one unit
  • More stages = more losses, more cost, more size

📖 More skills: bytesagain.com
EOF
        return 0
    fi

    STAGES="$stages" python3 -u <<'PYEOF'
import os

stages_str = os.environ["STAGES"]
pairs = stages_str.split(",")

print("═" * 50)
print("  🔗 Multi-Stage Drivetrain Analysis")
print("═" * 50)
print()

total_ratio = 1.0
total_eff = 1.0
stage_eff = 0.97  # assumed per spur/helical stage

for i, pair in enumerate(pairs, 1):
    parts = pair.strip().split(":")
    driving = float(parts[0])
    driven = float(parts[1])
    ratio = driven / driving

    total_ratio *= ratio
    total_eff *= stage_eff

    print(f"  Stage {i}: {driving:.0f}T → {driven:.0f}T")
    print(f"    Ratio: 1:{ratio:.3f}  |  Speed: ÷{ratio:.2f}  |  Torque: ×{ratio:.2f}")
    print()

print("  " + "─" * 46)
print(f"""
  Total Gear Ratio:       1:{total_ratio:.3f}
  Overall Efficiency:     {total_eff*100:.1f}% (at {stage_eff*100:.0f}%/stage)
  Number of Stages:       {len(pairs)}

  If Input = 1800 RPM, 10 Nm:
    Output Speed:   {1800/total_ratio:.1f} RPM
    Output Torque:  {10 * total_ratio * total_eff:.1f} Nm
    Power:          {10 * 1800 * 2 * 3.14159 / 60:.0f} W (constant minus losses)
""")
print("📖 More skills: bytesagain.com")
PYEOF
}

cmd_motor_select() {
    local torque_nm="${1:-}"
    local rpm="${2:-}"

    if [ -z "$torque_nm" ] || [ -z "$rpm" ]; then
        cat <<'EOF'
═══════════════════════════════════════════════════
  Motor Selection Helper
═══════════════════════════════════════════════════

Usage:
  bash scripts/script.sh motor-select <required_torque_Nm> <required_rpm>

Arguments:
  required_torque_Nm   Load torque requirement in Nm
  required_rpm         Required output speed in RPM

Examples:
  bash scripts/script.sh motor-select 50 300
  bash scripts/script.sh motor-select 5 1500
  bash scripts/script.sh motor-select 200 60

【Motor Types Overview】
  AC Induction     — Robust, cheap, 50/60 Hz, needs VFD for speed control
  Brushless DC     — Efficient, precise speed, good for servo applications
  Stepper          — Precise positioning, no feedback needed, limited speed
  Servo (AC/DC)    — High performance, closed-loop, expensive
  Universal        — AC/DC capable, high speed, short life (power tools)

📖 More skills: bytesagain.com
EOF
        return 0
    fi

    TORQUE="$torque_nm" RPM="$rpm" python3 -u <<'PYEOF'
import os, math

torque = float(os.environ["TORQUE"])
rpm = float(os.environ["RPM"])

omega = 2 * math.pi * rpm / 60
power_w = torque * omega
power_kw = power_w / 1000
power_hp = power_w / 745.7

print("═" * 50)
print("  🏭 Motor Selection Guide")
print("═" * 50)
print(f"""
  Required Torque:   {torque:.1f} Nm
  Required Speed:    {rpm:.0f} RPM
  Required Power:    {power_w:.0f} W  ({power_kw:.2f} kW / {power_hp:.2f} HP)
""")

# Add safety margin
design_power = power_kw * 1.25
print(f"  Design Power (×1.25 SF): {design_power:.2f} kW / {design_power/0.7457:.2f} HP")
print()

# Motor + gearbox combinations
print("【Recommended Motor + Gearbox Combinations】")
print()

motor_speeds = [
    ("4-pole AC Induction (1750 RPM)", 1750, 0.88),
    ("2-pole AC Induction (3500 RPM)", 3500, 0.90),
    ("BLDC Motor (3000 RPM)", 3000, 0.92),
    ("Servo Motor (2000 RPM)", 2000, 0.95),
]

for name, motor_rpm, motor_eff in motor_speeds:
    gear_ratio = motor_rpm / rpm
    if gear_ratio < 1:
        continue
    motor_torque = torque / gear_ratio / 0.97  # gear eff
    motor_power = motor_torque * (2 * math.pi * motor_rpm / 60)

    print(f"  {name}")
    print(f"    Gear ratio needed:   1:{gear_ratio:.2f}")
    print(f"    Motor torque:        {motor_torque:.2f} Nm")
    print(f"    Motor power:         {motor_power:.0f} W ({motor_power/745.7:.2f} HP)")
    print(f"    Motor efficiency:    ~{motor_eff*100:.0f}%")
    print()

print("""【Motor Frame Size Guide (IEC)】
  Power Range        Frame Size
  ────────────────────────────
  0.12 – 0.37 kW     56 – 71
  0.37 – 1.1  kW     71 – 90
  1.1  – 4.0  kW     90 – 112
  4.0  – 11   kW     132 – 160
  11   – 30   kW     160 – 200
  30   – 75   kW     225 – 280
""")
print("📖 More skills: bytesagain.com")
PYEOF
}

cmd_help() {
    cat <<EOF
Gear v${VERSION} — Gear Ratio & Mechanical Drive Calculator

Commands:
  ratio <driving> <driven>     Calculate gear ratio from tooth counts
  speed <rpm> <ratio>          Convert RPM through a gear ratio
  torque <Nm> <ratio> [eff]    Compute output torque (default eff: 0.97)
  drivetrain "<stages>"        Analyze multi-stage gear train
  motor-select <Nm> <rpm>      Motor selection helper
  help                         Show this help
  version                      Show version

Usage:
  bash scripts/script.sh ratio 20 60
  bash scripts/script.sh speed 1800 3.5
  bash scripts/script.sh torque 10 3.5 0.95
  bash scripts/script.sh drivetrain "20:60,15:45"
  bash scripts/script.sh motor-select 50 300

Related skills:
  clawhub install cam
  clawhub install bearing
Browse all: bytesagain.com

Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    ratio)         shift; cmd_ratio "$@" ;;
    speed)         shift; cmd_speed "$@" ;;
    torque)        shift; cmd_torque "$@" ;;
    drivetrain)    shift; cmd_drivetrain "$@" ;;
    motor-select)  shift; cmd_motor_select "$@" ;;
    version)       echo "gear v${VERSION}" ;;
    help|*)        cmd_help ;;
esac
