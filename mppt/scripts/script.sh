#!/usr/bin/env bash
# mppt — Maximum Power Point Tracking Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Maximum Power Point Tracking (MPPT) ===

MPPT is a technique used in solar charge controllers and inverters
to extract the maximum available power from a photovoltaic panel
under varying conditions.

Why MPPT Is Needed:
  A solar panel has a non-linear I-V characteristic
  Power output depends on the operating voltage
  Only ONE point on the I-V curve gives maximum power
  That point shifts with irradiance, temperature, shading, aging

  Without MPPT: panel operates at fixed voltage (e.g., battery voltage)
    - 12V battery connected to 36-cell panel (Vmp ≈ 17-18V)
    - Operating at 12V instead of 17V → losing ~25-30% potential power
  
  With MPPT: converter adjusts operating point to track MPP
    - Panel operates at 17V, converter steps down to 12V battery
    - Captures nearly all available power

Key Parameters:
  Isc   Short-circuit current (maximum current, zero voltage)
  Voc   Open-circuit voltage (maximum voltage, zero current)
  Imp   Current at maximum power point
  Vmp   Voltage at maximum power point
  Pmp   Maximum power = Vmp × Imp
  FF    Fill Factor = Pmp / (Voc × Isc) — typically 0.70-0.85

  Temperature effects:
    Voc decreases ~0.3-0.5%/°C (significant!)
    Isc increases ~0.05%/°C (minor)
    Net effect: Pmp decreases ~0.3-0.5%/°C

  Irradiance effects:
    Isc proportional to irradiance (linear)
    Voc changes logarithmically (less impact)
    1000 W/m² → full power (STC)
    500 W/m² → ~50% current, ~95% voltage

MPPT Efficiency:
  MPPT tracking efficiency = actual power extracted / Pmp
  Good controllers: 97-99.5% MPPT efficiency
  Note: MPPT efficiency ≠ converter efficiency
  Total efficiency = MPPT efficiency × converter efficiency
EOF
}

cmd_algorithms() {
    cat << 'EOF'
=== MPPT Algorithms ===

1. Perturb and Observe (P&O):
  Most common algorithm (simple and effective)
  
  Algorithm:
    1. Measure voltage and current → calculate power
    2. Perturb voltage by small step ΔV
    3. Measure new power
    4. If power increased → continue same direction
       If power decreased → reverse direction
    5. Repeat continuously

  Pseudocode:
    if (P_new > P_old)
      if (V_new > V_old) → increase voltage
      else               → decrease voltage
    else
      if (V_new > V_old) → decrease voltage
      else               → increase voltage

  Pros: simple, few sensors needed, works well in uniform conditions
  Cons: oscillates around MPP, fails with partial shading (local maxima)
  Step size tradeoff: large = fast tracking, more oscillation
                      small = less oscillation, slower tracking

2. Incremental Conductance (InC):
  Based on slope of P-V curve:
    At MPP:    dP/dV = 0   →  dI/dV = -I/V
    Left of MPP:  dP/dV > 0 → increase voltage
    Right of MPP: dP/dV < 0 → decrease voltage

  Algorithm:
    ΔI = I_new - I_old;  ΔV = V_new - V_old
    if (ΔV == 0):
      if (ΔI == 0) → at MPP
      if (ΔI > 0) → increase voltage
      else         → decrease voltage
    else:
      if (ΔI/ΔV == -I/V) → at MPP
      if (ΔI/ΔV > -I/V) → increase voltage
      else               → decrease voltage

  Pros: theoretically zero oscillation at MPP, handles changing conditions
  Cons: more computation, sensitive to noise, needs precise sensors

3. Constant Voltage (CV):
  Simplest: operate at ~76-80% of Voc
  Vmp ≈ 0.76 × Voc (typical for crystalline silicon)
  Periodically measure Voc (disconnect load briefly)
  Pros: extremely simple, low cost
  Cons: inaccurate, power lost during Voc measurement

4. Fuzzy Logic Controller:
  Inputs: error (E) and change in error (ΔE)
  E = ΔP/ΔV, ΔE = E(k) - E(k-1)
  Fuzzification → Rule evaluation → Defuzzification
  Rules: IF E is Positive AND ΔE is Zero THEN increase voltage
  Pros: handles non-linearity, robust to noise
  Cons: complex design, rule tuning required

5. Particle Swarm Optimization (PSO):
  For partial shading with multiple peaks
  Multiple "particles" explore P-V curve simultaneously
  Each particle has position (voltage) and velocity
  Converge on global maximum power point
  Pros: finds global MPP under partial shading
  Cons: slow convergence, computational cost, complex
EOF
}

cmd_converters() {
    cat << 'EOF'
=== DC-DC Converter Topologies for MPPT ===

Buck Converter (Step-Down):
  Vout = D × Vin   (D = duty cycle, 0-1)
  Use when: panel voltage > battery/load voltage
  Example: 36V panel → 12V battery
  
  Components: MOSFET switch, diode, inductor, capacitor
  Efficiency: 92-97%
  
  Advantages:
    - Simple design, low component count
    - High efficiency at moderate step-down ratios
    - Input current is discontinuous (pulsed)
    - Output current is continuous (smooth)
  
  MPPT consideration:
    Input (panel side) sees pulsed current
    Panel capacitance smooths voltage ripple

Boost Converter (Step-Up):
  Vout = Vin / (1 - D)
  Use when: panel voltage < load/grid voltage
  Example: 12V panel → 48V DC bus
  
  Advantages:
    - Input current is continuous (good for MPPT)
    - Panel sees smooth current draw
    - Better MPPT accuracy
  
  Disadvantages:
    - Output current is pulsed
    - Can't easily limit output current
    - Less efficient at very high step-up ratios

Buck-Boost Converter:
  Vout = -Vin × D / (1 - D)
  Use when: panel voltage may be above or below load voltage
  Example: 15-25V panel → 24V battery (varies with conditions)
  
  Variants:
    Inverting buck-boost (simple, negative output)
    Four-switch buck-boost (non-inverting, complex)
    Ćuk converter (non-inverting, uses coupled capacitor)

SEPIC (Single-Ended Primary-Inductor Converter):
  Non-inverting buck-boost functionality
  Vout = Vin × D / (1 - D)
  
  Advantages:
    - Non-inverting output
    - Input current is continuous
    - Can step up or down
    - Coupling capacitor provides isolation
  
  Disadvantages:
    - More components (2 inductors, coupling cap)
    - Lower efficiency than buck or boost alone
    - Larger physical size

Choosing Topology:
  Vpanel > Vload always:    Buck (simplest, most efficient)
  Vpanel < Vload always:    Boost (continuous input current)
  Vpanel varies around Vload: SEPIC or buck-boost
  Grid-tied inverter:       Boost + H-bridge inverter

Design Parameters:
  Switching frequency: 20-200 kHz (tradeoff: size vs losses)
  Inductor sizing: L = V × D / (f × ΔI)
  Capacitor sizing: C = I × D / (f × ΔV)
  MOSFET: Rds(on), Vds rating, gate charge
  Diode: Schottky preferred (low forward drop)
EOF
}

cmd_curves() {
    cat << 'EOF'
=== PV I-V and P-V Curves ===

I-V Curve Shape:
  Current (I)
  Isc ┤━━━━━━━━━━━╗
      │            ╲
  Imp ┤─ ─ ─ ─ ─ ─ ●MPP
      │              ╲
      │               ╲
      │                ╲
      │                 ╲
      ├────────────────────┤
      0     Vmp         Voc  Voltage (V)

P-V Curve Shape:
  Power (P)
  Pmp ┤         ╱╲
      │        ╱  ╲
      │       ╱    ╲
      │      ╱      ╲
      │     ╱        ╲
      │    ╱          ╲
      │   ╱            ╲
      ├──╱──────────────╲──┤
      0     Vmp         Voc  Voltage (V)

Single-Diode Model:
  I = Iph - I0 × [exp((V + I×Rs)/(n×Vt)) - 1] - (V + I×Rs)/Rsh

  Parameters:
    Iph   Photocurrent (proportional to irradiance)
    I0    Reverse saturation current (~10⁻¹² A)
    Rs    Series resistance (0.1-0.5 Ω, wiring, contacts)
    Rsh   Shunt resistance (100-1000 Ω, leakage paths)
    n     Ideality factor (1.0-2.0)
    Vt    Thermal voltage = kT/q ≈ 26 mV at 25°C

Fill Factor (FF):
  FF = (Vmp × Imp) / (Voc × Isc)
  Ideal FF ≈ 0.85-0.90 (limited by physics)
  Real FF ≈ 0.70-0.82 (degraded by Rs, Rsh)
  Higher FF = more rectangular I-V curve = better cell quality
  
  Factors reducing FF:
    High series resistance → slope in high-current region
    Low shunt resistance → slope in high-voltage region
    High recombination → lower voltage

Temperature Effects (per STC panel):
  Temperature coefficient of Voc: -0.30 to -0.45 %/°C
  Temperature coefficient of Isc: +0.04 to +0.06 %/°C
  Temperature coefficient of Pmp: -0.35 to -0.50 %/°C

  At 60°C (35°C above STC 25°C):
    Voc drops ~12% → significant MPP voltage shift
    Isc rises ~2% → minimal
    Pmp drops ~15% → significant power loss

Irradiance Effects:
  At 1000 W/m² (STC):    Isc = 100%, Voc = 100%
  At 500 W/m²:           Isc ≈ 50%, Voc ≈ 96%
  At 200 W/m²:           Isc ≈ 20%, Voc ≈ 90%
  At 50 W/m²:            Isc ≈ 5%, Voc ≈ 80%
  
  Low light: current drops linearly, voltage drops logarithmically
  MPP shifts left and down on P-V curve
EOF
}

cmd_shading() {
    cat << 'EOF'
=== Partial Shading & Multi-Peak MPPT ===

Partial Shading Problem:
  When some cells in a string are shaded:
  - Shaded cells produce less current
  - Series string current limited by weakest cell
  - Without bypass diodes: shaded cell becomes load (hot spot!)
  - With bypass diodes: multiple local maxima in P-V curve

Bypass Diodes:
  One bypass diode per ~18-24 cells (typical module has 3 diodes)
  When cell is shaded → diode conducts → bypasses that substring
  Result: stepped I-V curve with multiple knees

  Normal P-V curve:    one peak
  Partial shading:     2-3 peaks (one per unshaded substring)

  Challenge for MPPT:
    P&O and InC may get stuck on local maximum
    Global maximum might be at a completely different voltage

Global MPPT Strategies:

  1. Periodic Scan:
    Sweep entire voltage range periodically (every 5-10 min)
    Find all peaks, operate at highest
    Simple but wastes energy during scan

  2. Pilot Cell Method:
    Small reference cell detects shading changes
    Triggers voltage scan only when conditions change

  3. Distributed MPPT:
    Individual MPPT per panel (DC optimizers)
    Examples: SolarEdge, Tigo
    Each panel operates at its own MPP independently
    Eliminates string mismatch entirely
    Cost: $30-50 per optimizer

  4. Module-Level Power Electronics (MLPE):
    Micro-inverters: per-panel DC→AC conversion (Enphase)
    DC optimizers: per-panel DC→DC MPPT (SolarEdge)
    Benefits: panel-level monitoring, no single point of failure

  5. Particle Swarm Optimization (PSO):
    Multiple voltage probes simultaneously
    Particles converge on global maximum
    Suitable for rapid shading changes

  6. Artificial Neural Network:
    Train on historical shading patterns
    Predict MPP voltage from sensor inputs
    Fast response but requires training data

String vs Parallel Configuration:
  Long strings: higher voltage, more shading impact
  Parallel strings: lower voltage, each string independent
  Shorter strings with more bypass diodes = less shading impact

Real-World Shading Sources:
  - Trees, buildings, chimneys
  - Snow, dust, bird droppings
  - Clouds (moving partial shade)
  - Inter-row shading (ground-mount arrays)
  - Self-shading in morning/evening (angled roofs)
EOF
}

cmd_tuning() {
    cat << 'EOF'
=== MPPT Controller Tuning ===

Step Size (ΔV or Δd):
  The perturbation applied to voltage or duty cycle each iteration

  Large step size:
    + Fast tracking when conditions change quickly
    + Recovers from startup/shading faster
    - More oscillation around MPP → power loss
    - Typical loss: 1-5% of Pmp at steady state

  Small step size:
    + Less oscillation → more power extracted
    + Closer to true MPP
    - Slow response to changing conditions
    - May not track fast-moving clouds

  Typical values:
    Voltage step: 0.5-2V (for 30V panel)
    Duty cycle step: 0.5-3% of full scale
    Relative: 1-5% of Vmp

Adaptive Step Size:
  Adjust step size based on operating conditions:
    Large ΔP → large step (far from MPP, need to move fast)
    Small ΔP → small step (near MPP, need precision)
    
  Variable step: ΔV = k × |ΔP/ΔV|
    k is a scaling constant (tuned empirically)
    Automatically balances speed vs precision

Perturbation Frequency:
  How often the algorithm adjusts the operating point

  Too fast:
    - System hasn't settled from previous perturbation
    - Measurement includes transients → wrong decisions
    - Can cause instability and divergence

  Too slow:
    - Can't track rapidly changing irradiance
    - Loses power during transitions

  Guidelines:
    Perturbation period > 3-5× converter settling time
    Converter settling ≈ 5-10 switching periods
    Switching at 100 kHz → settle in ~50-100 μs
    Perturbation period: ~0.5-10 ms typical

  Environmental change rates:
    Cloud passing: seconds
    Sun movement: minutes
    Temperature: minutes to hours

Sampling and Filtering:
  ADC resolution: 10-12 bits minimum for V and I
  Averaging: 4-16 samples per measurement
  Moving average or exponential filter for noise
  Anti-aliasing: sample well above switching frequency

Startup Sequence:
  1. Measure Voc (disconnect load briefly)
  2. Set initial voltage to ~80% Voc
  3. Begin P&O or InC from this starting point
  4. Much faster than starting from 0V

Steady-State Oscillation Reduction:
  Three-point comparison: only perturb if ΔP > threshold
  Dithering: small oscillation intentionally to maintain tracking
  Hysteresis band: only change direction if ΔP exceeds band
EOF
}

cmd_hardware() {
    cat << 'EOF'
=== MPPT Hardware Design ===

Microcontroller Selection:
  Requirements:
    - ADC: ≥10-bit, ≥2 channels (V and I), fast sampling
    - PWM: hardware timer, ≥20 kHz resolution
    - Math: multiply/divide for power calculation
    - GPIO: MOSFET gate drive, LED indicators, communication

  Popular choices:
    ATmega328 (Arduino): simple, limited ADC speed
    STM32F1/F4: excellent peripherals, fast ADC, cheap
    dsPIC33: DSP instructions, motor control peripherals
    ESP32: WiFi for monitoring, dual ADC, adequate for <100kHz
    TI C2000: purpose-built for power electronics

Voltage Sensing:
  Resistor divider: R1/(R1+R2) ratio
  Panel voltage: 0-50V → scale to 0-3.3V ADC range
  Example: R1=10kΩ, R2=100kΩ → ratio 1:11 → 50V→4.5V
  Add Zener/TVS for ADC protection
  Calibration: precision resistors (0.1%) or trimmer

Current Sensing:
  Shunt resistor:
    Low-side (ground): simple but loses ground reference
    High-side (supply): keeps ground, needs differential amp
    Resistance: 10-100 mΩ (low for efficiency)
    Power dissipation: I² × R (shunt gets hot at high current)

  Hall effect sensor (ACS712, ACS758):
    Galvanic isolation
    No power loss in measurement
    Less accurate than precision shunt
    Response time: ~5 μs

  Current sense IC (INA219, INA226):
    I²C interface, built-in ADC
    High-side or low-side
    Programmable gain and averaging
    Resolution: 16-bit

Gate Driver:
  MOSFET gate drive requirements:
    Voltage: 10-15V for full enhancement
    Current: 1-2A peak for fast switching
    Rise/fall time: <100ns for low switching losses

  Options:
    IR2110: high-side and low-side driver, bootstrap
    IR2104: half-bridge driver with deadtime
    UCC27511: single-channel, fast, SOT-23-5
    Discrete: NPN/PNP totem pole (simple, slow)

  Bootstrap circuit:
    For high-side N-channel MOSFET driving
    Bootstrap cap charges during low-side ON time
    Minimum low-side ON time required each cycle

PCB Layout Considerations:
  - Keep gate drive loop area small (reduce ringing)
  - Star-ground: separate power ground and signal ground
  - Place decoupling caps close to IC power pins
  - Current sense traces: Kelvin connection to shunt
  - Heatsinking: MOSFET, diode, shunt resistor
  - Input capacitors: close to converter, low ESR
  - Thermal relief on high-current pads
EOF
}

cmd_efficiency() {
    cat << 'EOF'
=== MPPT Efficiency & Performance ===

Efficiency Components:
  Total efficiency = MPPT tracking efficiency × converter efficiency

  MPPT Tracking Efficiency (ηmppt):
    How well the algorithm finds and maintains MPP
    Measured: actual operating power / true Pmp
    Typical: 95-99.5%
    Losses from: oscillation, slow tracking, wrong decisions

  Converter Efficiency (ηconv):
    Power delivered to load / power taken from panel
    Typical: 90-97%
    Losses from: switching, conduction, magnetics, control

Loss Breakdown in Converter:
  Conduction losses:
    MOSFET: Pcond = I²rms × Rds(on)
    Diode: Pcond = Iavg × Vf (forward voltage)
    Inductor: Pcond = I²rms × DCR
    Typical: 1-3% of power

  Switching losses:
    MOSFET turn-on/off: Psw = 0.5 × V × I × (tr + tf) × fsw
    Diode reverse recovery: Prr = 0.5 × Qrr × V × fsw
    Typical: 1-4% of power
    Reduce by: lower fsw, faster MOSFETs, SiC/GaN

  Magnetic losses:
    Core loss (hysteresis + eddy current): frequency dependent
    Copper loss: I²R in windings
    Typical: 0.5-2% of power

  Control/quiescent:
    Microcontroller, gate driver, sensors: 0.5-2W fixed
    Significant at low power (e.g., 2W overhead on 20W panel = 10%!)

Real-World Performance Factors:
  Temperature:
    Panel: -0.4%/°C power loss above 25°C
    Electronics: components derate at high temperature
    Cooling strategy affects long-term reliability

  Soiling and Degradation:
    Dust: 2-7% annual loss (depends on climate)
    Bird droppings: can cause hot spots
    PID (Potential Induced Degradation): 1-2%/year
    LID (Light Induced Degradation): 1-3% first year

  Wiring Losses:
    I²R in cables between panel and controller
    Use adequate wire gauge (≤2% voltage drop)
    Shorter runs = less loss

Efficiency Standards:
  European Efficiency (EN 50530):
    Weighted average at different power levels
    ηEU = 0.03×η5% + 0.06×η10% + 0.13×η20% + 0.10×η30% + 0.48×η50% + 0.20×η100%
    Emphasizes partial-load efficiency

  CEC Efficiency:
    California Energy Commission weighted efficiency
    ηCEC = 0.04×η10% + 0.05×η20% + 0.12×η30% + 0.21×η50% + 0.53×η75% + 0.05×η100%
    More weight on 75% load (realistic for CA)

  Static vs Dynamic Efficiency:
    Static: steady-state tracking (easy to measure)
    Dynamic: response to rapid irradiance changes (harder)
    EN 50530 defines dynamic test procedures
EOF
}

show_help() {
    cat << EOF
mppt v$VERSION — Maximum Power Point Tracking Reference

Usage: script.sh <command>

Commands:
  intro        MPPT overview — why it's needed, PV basics
  algorithms   MPPT algorithms: P&O, InC, fuzzy logic, PSO
  converters   DC-DC topologies: buck, boost, buck-boost, SEPIC
  curves       PV I-V and P-V curves, fill factor, temperature effects
  shading      Partial shading, bypass diodes, global MPPT
  tuning       Step size, perturbation frequency, adaptive control
  hardware     MCU selection, sensing, gate drivers, PCB layout
  efficiency   Efficiency metrics, loss analysis, standards
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    algorithms) cmd_algorithms ;;
    converters) cmd_converters ;;
    curves)     cmd_curves ;;
    shading)    cmd_shading ;;
    tuning)     cmd_tuning ;;
    hardware)   cmd_hardware ;;
    efficiency) cmd_efficiency ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "mppt v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
