#!/usr/bin/env bash
# lithium — Lithium Battery Technology Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Lithium-Ion Battery Technology ===

Lithium-ion batteries store energy through the reversible intercalation
of lithium ions between two electrode materials.

Working Principle:
  Discharge: Li⁺ ions move from anode → cathode through electrolyte
             Electrons flow through external circuit (useful work)
  Charge:    Li⁺ ions move from cathode → anode (reversed)
             External charger forces electrons back

Cell Components:
  Anode:       Typically graphite (LiC₆), silicon composites, or LTO
  Cathode:     Metal oxide (LiCoO₂, LiFePO₄, NMC, NCA)
  Electrolyte: Organic solvent + lithium salt (LiPF₆)
  Separator:   Porous polymer film (PE/PP, ~20 μm)
  Current collectors: copper (anode), aluminum (cathode)

Key Parameters:
  Nominal voltage:    2.4-3.8V depending on chemistry
  Specific energy:    100-265 Wh/kg (cell level)
  Energy density:     250-700 Wh/L (cell level)
  Cycle life:         500-10,000 cycles (chemistry dependent)
  Coulombic efficiency: >99.5% (mature cells)
  Self-discharge:     2-5% per month

History:
  1970s   M.S. Whittingham proposes TiS₂ cathode
  1980    John Goodenough develops LiCoO₂ cathode
  1985    Akira Yoshino creates first practical Li-ion prototype
  1991    Sony commercializes first Li-ion cell
  2019    Nobel Prize to Goodenough, Whittingham, Yoshino
  2020s   LFP renaissance, solid-state development, sodium-ion

Cell Form Factors:
  Cylindrical: 18650, 21700, 4680 (Tesla)
  Prismatic:   rectangular metal can (EV modules)
  Pouch:       flexible aluminum laminate (phones, drones)
EOF
}

cmd_chemistries() {
    cat << 'EOF'
=== Lithium Cell Chemistries Compared ===

LFP — Lithium Iron Phosphate (LiFePO₄):
  Voltage: 3.2V nominal, 3.65V max
  Energy:  90-160 Wh/kg
  Cycles:  2,000-10,000+
  Pros:    Safest, longest life, no cobalt, flat voltage curve
  Cons:    Lower energy density, poor low-temp performance
  Use:     EVs (Tesla SR, BYD), solar storage, marine

NMC — Nickel Manganese Cobalt (LiNiMnCoO₂):
  Variants: NMC111, NMC532, NMC622, NMC811
  Voltage: 3.6-3.7V nominal, 4.2V max
  Energy:  150-220 Wh/kg
  Cycles:  1,000-2,000
  Pros:    Good energy density, balanced performance
  Cons:    Cobalt cost, thermal stability decreases with Ni content
  Use:     EVs (most OEMs), e-bikes, power tools

NCA — Nickel Cobalt Aluminum (LiNiCoAlO₂):
  Voltage: 3.6V nominal, 4.2V max
  Energy:  200-265 Wh/kg
  Cycles:  500-1,000
  Pros:    Highest energy density, good power
  Cons:    Expensive, sensitive to overcharge, less safe
  Use:     Tesla (long range), premium EVs

LCO — Lithium Cobalt Oxide (LiCoO₂):
  Voltage: 3.6V nominal, 4.2V max
  Energy:  150-200 Wh/kg
  Cycles:  500-1,000
  Pros:    High energy density, established supply chain
  Cons:    Expensive cobalt, limited thermal stability
  Use:     Consumer electronics (phones, laptops)

LMO — Lithium Manganese Oxide (LiMn₂O₄):
  Voltage: 3.7V nominal, 4.2V max
  Energy:  100-150 Wh/kg
  Cycles:  300-700
  Pros:    High power, safe, low cost
  Cons:    Manganese dissolution, poor high-temp cycling
  Use:     Power tools, medical devices

LTO — Lithium Titanate (Li₄Ti₅O₁₂ anode):
  Voltage: 2.4V nominal
  Energy:  50-80 Wh/kg
  Cycles:  15,000-20,000+
  Pros:    Extreme cycle life, fast charge (6C), wide temp range
  Cons:    Low energy density, high cost, low voltage
  Use:     Grid storage, buses, extreme cold applications

Sodium-Ion (Na-ion):
  Voltage: ~3.1V nominal
  Energy:  100-160 Wh/kg
  Cycles:  2,000-4,000
  Pros:    No lithium/cobalt, abundant sodium, low cost
  Cons:    Lower energy density, early commercialization
  Use:     Stationary storage, low-cost EVs (CATL, HiNa)
EOF
}

cmd_charging() {
    cat << 'EOF'
=== Charging Protocols ===

CC-CV (Constant Current — Constant Voltage):
  Standard charging method for Li-ion:
  Phase 1 — CC: Charge at constant current (e.g., 0.5C)
    Battery voltage rises from ~3.0V to 4.2V
    ~65-80% of capacity delivered in CC phase
  Phase 2 — CV: Hold voltage at 4.2V, current tapers
    Current drops to cutoff (typically C/20 or C/50)
    Remaining 20-35% of capacity
  Total time: typically 2-3 hours at 0.5C

C-Rate Definition:
  1C = current to fully charge/discharge in 1 hour
  Example: 3000 mAh cell → 1C = 3.0A
  0.5C = 1.5A (2 hours), 2C = 6.0A (30 min theoretical)

Fast Charging Methods:
  Step Charging:
    Multiple CC stages at decreasing currents
    Example: 2C → 1.5C → 1C → 0.5C at voltage thresholds
    Reduces lithium plating risk vs constant high current

  Pulse Charging:
    Short high-current pulses with rest periods
    Rest allows ion diffusion, reduces concentration gradients
    Some evidence of improved cycle life

  CCCV with Preconditioning:
    If cell below 2.5V → trickle charge at C/10 first
    Prevents copper dissolution damage
    Switch to normal CC once voltage reaches ~3.0V

Temperature Effects on Charging:
  <0°C:    Charge at ≤0.1C (lithium plating risk!)
  0-10°C:  Charge at ≤0.3C
  10-45°C: Normal charging range
  >45°C:   Reduce charge rate, accelerates degradation

LFP-Specific:
  Flat voltage plateau makes SOC estimation harder
  CV phase shorter (3.65V cutoff)
  Can tolerate slightly higher charge rates than NMC

Charge Termination:
  Voltage cutoff: chemistry-specific (4.2V NMC, 3.65V LFP)
  Current cutoff: C/20 to C/50 (lower = more capacity, longer time)
  Timer cutoff: safety backup (typically 4-6 hours max)
  Temperature cutoff: ΔT/Δt > 1°C/min → stop
EOF
}

cmd_degradation() {
    cat << 'EOF'
=== Battery Degradation Mechanisms ===

Capacity Fade Sources:
  Loss of Lithium Inventory (LLI):
    Lithium consumed in side reactions → permanently lost
    Primary cause of capacity fade in first 500 cycles
  Loss of Active Material (LAM):
    Electrode material becomes disconnected or inactive
    Particle cracking, binder degradation, dissolution

SEI Layer Growth (Anode):
  Solid Electrolyte Interphase forms on first charge
  Continues growing slowly throughout life
  Consumes lithium → capacity loss
  Increases impedance → power fade
  Temperature dependent: doubles growth rate per +10°C
  Accelerated by: high SOC storage, high temperature

Lithium Plating (Anode):
  Metallic lithium deposits on anode surface
  Causes: charging too fast, low temperature, overcharge
  Consequences: capacity loss, internal short risk, dendrites
  Prevention: limit charge rate at low temp, proper BMS
  Detection: voltage plateau in relaxation, reduced coulombic efficiency

Cathode Degradation:
  NMC/NCA: transition metal dissolution, oxygen release at high SOC
  LFP: iron dissolution (rare, mainly at high temp)
  Surface reconstruction: layered → spinel → rock salt
  Particle cracking from repeated expansion/contraction

Calendar Aging:
  Degradation that occurs even without cycling
  Depends on: temperature and SOC during storage
  Optimal storage: 30-50% SOC at 15-25°C
  Worst case: 100% SOC at high temperature
  Rule of thumb: ~2-3% capacity loss per year at 25°C, 50% SOC

Cycling Aging Factors:
  Depth of Discharge: deeper cycles = faster degradation
  C-rate: higher currents = more stress (heat, gradients)
  Temperature: sweet spot 20-25°C for most chemistries
  Voltage window: narrower = longer life (e.g., 20-80% SOC)

Typical Degradation Rates:
  NMC: ~20% loss in 1,000-2,000 cycles (80% DOD)
  LFP: ~20% loss in 3,000-5,000 cycles (80% DOD)
  NCA: ~20% loss in 800-1,500 cycles (80% DOD)
  LTO: ~20% loss in 15,000+ cycles
EOF
}

cmd_bms() {
    cat << 'EOF'
=== Battery Management System (BMS) ===

Core BMS Functions:
  1. Cell voltage monitoring (per cell)
  2. Current measurement (pack level)
  3. Temperature monitoring (multiple points)
  4. State of Charge (SOC) estimation
  5. State of Health (SOH) estimation
  6. Cell balancing
  7. Protection (over-voltage, under-voltage, over-current, over-temp)
  8. Communication (CAN bus, SMBus, UART)

SOC Estimation Methods:
  Coulomb Counting:
    Integrate current over time: SOC = SOC₀ + ∫(I·dt)/Q
    Pros: simple, responsive
    Cons: sensor drift, needs periodic recalibration
    Accuracy: ±5-10% without correction

  Open Circuit Voltage (OCV):
    Map OCV to SOC from voltage-SOC lookup table
    Requires rest period (30+ min for equilibrium)
    Works well for NMC/NCA (sloped OCV), poor for LFP (flat)

  Kalman Filter (EKF/UKF):
    Combines coulomb counting + voltage model
    Self-correcting, handles noise
    Industry standard for EV applications
    Accuracy: ±2-3%

  Impedance-Based:
    EIS (Electrochemical Impedance Spectroscopy)
    Correlates impedance changes to SOC/SOH
    Used in advanced BMS and research

Cell Balancing:
  Why: cell-to-cell variation → weakest cell limits pack
  Passive Balancing:
    Burn excess energy from higher cells as heat (resistor)
    Simple, cheap, balances at top of charge
    Typical balance current: 50-200 mA
  Active Balancing:
    Transfer energy from higher to lower cells
    Methods: capacitor shuttle, inductor, transformer
    More complex, expensive, but faster and efficient
    Useful for large packs (EVs, grid storage)

Protection Thresholds (typical NMC):
  Over-voltage: 4.25-4.30V per cell → stop charge
  Under-voltage: 2.5-2.8V per cell → stop discharge
  Over-current: depends on cell rating (e.g., 2-3× continuous)
  Over-temperature: 60°C charge cutoff, 70°C discharge cutoff
  Under-temperature: -20°C discharge cutoff, 0°C charge cutoff
  Short circuit: <1 ms detection, MOSFET disconnect

BMS Topologies:
  Centralized: single PCB, wires to all cells (simple, small packs)
  Distributed: module-level boards + master controller (EVs)
  Modular: standardized slave boards per module (scalable)
EOF
}

cmd_safety() {
    cat << 'EOF'
=== Lithium Battery Safety ===

Thermal Runaway:
  Self-heating chain reaction → fire or explosion
  Stages:
    Stage 1 (90-120°C): SEI decomposition, mild heat
    Stage 2 (150-200°C): separator melts, internal short
    Stage 3 (200-250°C): cathode decomposition, oxygen release
    Stage 4 (>250°C): electrolyte ignition, venting, fire

  Triggers:
    Internal short circuit (manufacturing defect, dendrite)
    External short circuit (wiring fault, crash)
    Overcharge (BMS failure, charger fault)
    Over-discharge (copper dissolution → internal short on recharge)
    Mechanical damage (puncture, crush, drop)
    External heating (fire, sun exposure)

  Thermal runaway propagation:
    Cell-to-cell: heat from one cell ignites adjacent
    Mitigation: thermal barriers, spacing, cooling, venting

Safety Testing Standards:
  UN38.3: Transport testing (mandatory for shipping)
    T1: Altitude simulation (11.6 kPa, 6 hours)
    T2: Thermal cycling (-40°C to +75°C, 10 cycles)
    T3: Vibration (7-200 Hz, 3 hours per axis)
    T4: Shock (150g, 6 ms, 18 shocks)
    T5: External short circuit (<0.1Ω, 1 hour)
    T6: Impact/crush
    T7: Overcharge (2× rated current)
    T8: Forced discharge

  IEC 62133: Safety for portable applications
  UL 2054/2580: North American safety standard
  SAE J2464: EV battery abuse testing

Transport Regulations:
  IATA DGR: Section II for small quantities
  DOT 49 CFR: hazmat shipping regulations
  Packing Instructions:
    PI 965: lithium-ion cells/batteries alone
    PI 966: packed with equipment
    PI 967: contained in equipment
  State of Charge for shipping: ≤30% SOC (IATA requirement)

Fire Suppression:
  Water: effective for cooling (large quantities needed)
  CO₂/dry chemical: limited effectiveness
  Specialty agents: F-500, PyroCool, Novec
  Key: cool adjacent cells to prevent propagation
  EV fire: may require 10,000+ liters of water
EOF
}

cmd_sizing() {
    cat << 'EOF'
=== Battery Pack Sizing ===

Series vs Parallel Configuration:
  Series (S): increases voltage
    2S = 2 cells × 3.7V = 7.4V nominal
    Example: 14S LFP = 14 × 3.2V = 44.8V (48V system)
  Parallel (P): increases capacity
    2P = 2 × cell capacity (Ah)
    Example: 3P × 3.0Ah cells = 9.0Ah
  Notation: 14S3P = 14 series × 3 parallel = 42 cells total

Pack Energy Calculation:
  Energy (Wh) = Nominal Voltage (V) × Capacity (Ah)
  Example: 96S1P NMC (Tesla-class)
    96 × 3.7V × 5.0Ah = 1,776 Wh = 1.776 kWh (per string)
  Usable energy = total × usable SOC window (typically 85-95%)

Energy Cell vs Power Cell:
  Energy cells: optimized for capacity (Wh/kg)
    Thick electrodes, higher capacity, lower C-rate
    Applications: EVs, stationary storage
    Typical: 1-2C continuous discharge
  Power cells: optimized for current (W/kg)
    Thin electrodes, lower capacity, higher C-rate
    Applications: power tools, hybrid vehicles, drones
    Typical: 5-30C continuous discharge

Derating Factors:
  Temperature derating: capacity drops at low temp
    0°C: ~80% of rated capacity
    -20°C: ~60% of rated capacity
  Aging derating: design for EOL capacity (typically 80%)
  System losses: BMS, wiring, contactors (~3-5%)
  Design margin: 10-20% additional safety factor

Thermal Design:
  Heat generation: Q = I²R + entropic heat
  Cooling methods:
    Passive: heatsink fins, thermal pads, natural convection
    Active air: fans, ducted airflow
    Liquid: glycol/water loop, cold plates
    Immersion: direct contact with dielectric fluid
  Target: keep cells within 15-35°C, ΔT < 5°C cell-to-cell
  Thermal interface: pads (1-5 W/mK), gap fillers, potting

Wiring & Fusing:
  Cable sizing: based on max continuous current + derating
  Main fuse: 125-150% of max continuous current
  Cell-level fusing: wire bonds or fusible links
  Pre-charge circuit: limit inrush to capacitive loads
    Pre-charge resistor: V_pack / I_limit
    Time: 5-10 RC time constants
EOF
}

cmd_specs() {
    cat << 'EOF'
=== Reading Battery Datasheets ===

Key Specifications:
  Parameter              Typical Values        Notes
  ──────────────────────────────────────────────────────────
  Nominal Capacity       1-300 Ah              At 0.2C, 25°C (standard)
  Nominal Voltage        2.4-3.8V              Chemistry dependent
  Charge Voltage         3.65-4.35V            Never exceed!
  Discharge Cutoff       2.0-2.8V              Below → damage
  Max Charge Current     0.5-3C                Chemistry/form factor
  Max Discharge Current  1-30C (continuous)     Thermal limited
  Pulse Discharge        2-100C (10-30 sec)    Short duration only
  Internal Resistance    0.5-50 mΩ             Increases with aging
  Cycle Life             500-10,000            To 80% capacity
  Operating Temp         -20 to 60°C           Charge: 0 to 45°C
  Self-Discharge         2-5% /month           At 25°C
  Weight                 Varies                Check energy density

How to Read a Discharge Curve:
  X-axis: Capacity (Ah) or Depth of Discharge (%)
  Y-axis: Voltage (V)
  Key features:
    - Initial voltage drop (ohmic + activation losses)
    - Plateau region (useful capacity)
    - Knee point (capacity nearly exhausted)
    - Cutoff voltage (stop discharging here)
  Compare curves at different C-rates:
    Higher C-rate → lower voltage plateau → less usable capacity

Impedance (AC vs DC):
  AC impedance (1 kHz): mostly ohmic resistance
  DC resistance (DCIR): includes polarization
  DCIR = ΔV / ΔI (measured during pulse test)
  DCIR > AC impedance (always)
  Both increase with age → power fade indicator

Cycle Life Testing Conditions:
  Standard: 1C charge, 1C discharge, 25°C, 100% DOD
  Real-world is usually better (partial cycles, moderate temp)
  Calendar life: years at specified temperature and SOC
  Check test conditions carefully — they vary between manufacturers

Common Gotchas:
  - Capacity rated at 0.2C may drop 10-15% at 1C
  - Max charge current at 25°C, derate at other temps
  - Cycle life at 100% DOD, partial DOD lasts much longer
  - Internal resistance is for new cell, doubles by EOL
  - Operating temp ≠ charging temp (charging range is narrower)
EOF
}

show_help() {
    cat << EOF
lithium v$VERSION — Lithium Battery Technology Reference

Usage: script.sh <command>

Commands:
  intro        Li-ion overview — history, working principle, parameters
  chemistries  Cell chemistries: NMC, LFP, NCA, LCO, LMO, LTO
  charging     Charging protocols: CC-CV, fast charge, temperature
  degradation  Degradation mechanisms: SEI, plating, calendar aging
  bms          Battery Management System fundamentals
  safety       Thermal runaway, testing standards, transport rules
  sizing       Pack sizing — series/parallel, thermal, wiring
  specs        How to read battery datasheets and specs
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    chemistries)  cmd_chemistries ;;
    charging)     cmd_charging ;;
    degradation)  cmd_degradation ;;
    bms)          cmd_bms ;;
    safety)       cmd_safety ;;
    sizing)       cmd_sizing ;;
    specs)        cmd_specs ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "lithium v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
