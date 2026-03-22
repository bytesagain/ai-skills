#!/usr/bin/env bash
# fuel-cell — Fuel Cell Technology Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Fuel Cell Fundamentals ===

A fuel cell converts chemical energy directly into electrical energy
through electrochemical reactions — NOT combustion. Like a battery
that never runs out (as long as fuel is supplied).

Basic Reaction (Hydrogen Fuel Cell):
  Anode:    H₂ → 2H⁺ + 2e⁻
  Cathode:  ½O₂ + 2H⁺ + 2e⁻ → H₂O
  Overall:  H₂ + ½O₂ → H₂O + electricity + heat

  Only byproduct: water and heat!

Structure:
  ┌──────────────────────────┐
  │   Hydrogen → Anode      │←── electrons flow through
  │              │           │    external circuit (power!)
  │         [Electrolyte]    │←── ions pass through
  │              │           │
  │   Oxygen  → Cathode     │←── electrons return
  └──────────────────────────┘

Thermodynamics:
  Gibbs free energy: ΔG = -nFE
    n = electrons transferred (2 for H₂)
    F = Faraday constant (96,485 C/mol)
    E = cell voltage

  Theoretical voltage: 1.23 V (at standard conditions)
  Practical voltage: 0.6 – 0.8 V (under load)
  Efficiency: NOT limited by Carnot cycle
    Carnot max = 1 - T_cold/T_hot ≈ 40-60%
    Fuel cell theoretical = ΔG/ΔH ≈ 83% (for H₂)
    Practical: 40-65% electrical efficiency

History:
  1839    William Grove demonstrates first fuel cell
  1950s   GE develops PEM for NASA Gemini program
  1960s   NASA Apollo uses AFC fuel cells
  1990s   PEM fuel cell vehicles prototyped
  2014    Toyota Mirai — first mass-produced FCV
  2020s   Green hydrogen economy gains momentum
EOF
}

cmd_types() {
    cat << 'EOF'
=== Fuel Cell Types Comparison ===

Type        Temp(°C)   Electrolyte          Fuel           Efficiency
PEMFC       60-80      Polymer membrane     Pure H₂        40-60%
AFC         60-90      KOH solution         Pure H₂        60-70%
PAFC        150-200    Phosphoric acid      H₂ (CO < 1%)   40-50%
MCFC        600-700    Molten carbonate     H₂, CH₄, CO    45-55%
SOFC        600-1000   Solid ceramic        H₂, CH₄, CO    50-65%
DMFC        60-90      Polymer membrane     Methanol        20-30%

--- PEMFC (Proton Exchange Membrane) ---
  Pros: Fast start, high power density, compact
  Cons: Needs pure H₂, expensive Pt catalyst, water management
  Use: Vehicles (Toyota Mirai, Hyundai Nexo), portable power

--- AFC (Alkaline) ---
  Pros: Highest efficiency, non-precious catalysts possible
  Cons: CO₂ intolerant (poisons KOH electrolyte)
  Use: Space applications (NASA), submarines

--- PAFC (Phosphoric Acid) ---
  Pros: CO tolerant up to 1%, mature technology
  Cons: Large, heavy, slow start, moderate efficiency
  Use: Stationary power (UTC PureCell 400)

--- MCFC (Molten Carbonate) ---
  Pros: Fuel flexible (natural gas direct), no precious metals
  Cons: Corrosive electrolyte, slow start, short life
  Use: Large stationary (Fuel Cell Energy DFC)

--- SOFC (Solid Oxide) ---
  Pros: Highest efficiency, fuel flexible, long life
  Cons: High temp → slow start, material degradation
  Use: Stationary power, CHP, data centers (Bloom Energy)

--- DMFC (Direct Methanol) ---
  Pros: Liquid fuel (easy storage), no reformer needed
  Cons: Low efficiency, methanol crossover, low power
  Use: Portable electronics, military field power
EOF
}

cmd_pem() {
    cat << 'EOF'
=== PEM Fuel Cells (PEMFC) ===

The dominant fuel cell type for transport and portable applications.

Membrane-Electrode Assembly (MEA):
  ┌─────────────────────────────┐
  │  Gas Diffusion Layer (GDL)  │ Carbon paper/cloth
  │  Anode Catalyst Layer       │ Pt/C (0.05-0.4 mg/cm²)
  │  Proton Exchange Membrane   │ Nafion® (25-183 μm)
  │  Cathode Catalyst Layer     │ Pt/C (0.2-0.4 mg/cm²)
  │  Gas Diffusion Layer (GDL)  │ Carbon paper/cloth
  └─────────────────────────────┘

Membrane (Nafion®):
  Material: Perfluorosulfonic acid (PFSA)
  Proton conductivity: 0.1 S/cm (hydrated)
  Must stay hydrated! Dry membrane = high resistance
  Must not flood! Liquid water blocks gas flow
  Operating range: 60-90°C (typically 80°C)

Catalyst:
  Platinum is the standard (expensive!)
    Anode: 0.05-0.1 mg Pt/cm² (hydrogen oxidation is fast)
    Cathode: 0.2-0.4 mg Pt/cm² (oxygen reduction is slow)
  Loading reduction target: < 0.125 mg/cm² total
  Alternatives under research: Pt alloys, non-PGM catalysts

Performance (Polarization Curve):
  Voltage vs Current Density
  1.23V ─── Theoretical OCV
  1.0V  ─── Activation losses (catalyst kinetics)
  0.7V  ─── Ohmic losses (membrane resistance) ← operating point
  0.4V  ─── Mass transport losses (gas diffusion limits)

  Typical operating: 0.6-0.7 V per cell at 1-2 A/cm²
  Power density: 0.5-1.0 W/cm²
  Stack: 300-400 cells in series for automotive

Water Management:
  Too dry → membrane dehydrates → resistance increases
  Too wet → flooding → gas channels blocked → performance drop
  Solutions: humidified reactant gases, internal humidification
  Back-diffusion, electro-osmotic drag, external humidifiers

Fuel Purity Requirements:
  H₂: > 99.97% purity
  CO < 0.2 ppm (poisons Pt catalyst)
  NH₃ < 0.1 ppm
  Total sulfur < 0.004 ppm
  This is why reformate gas needs extensive cleanup
EOF
}

cmd_sofc() {
    cat << 'EOF'
=== Solid Oxide Fuel Cells (SOFC) ===

High-temperature fuel cells for stationary power and CHP.

Operating Temperature: 600-1000°C
  High-temp SOFC: 800-1000°C (traditional)
  Intermediate-temp SOFC: 600-800°C (modern trend)

Materials:
  Electrolyte: YSZ (yttria-stabilized zirconia)
    8 mol% Y₂O₃-ZrO₂
    Ionic conductor (O²⁻ ions)
    Dense, gas-tight layer (10-20 μm)

  Anode: Ni-YSZ cermet
    Nickel for catalysis + electronic conduction
    YSZ for ionic conduction + structural support
    Porous (30-40% porosity) for gas access

  Cathode: LSM (lanthanum strontium manganite)
    La₁₋ₓSrₓMnO₃
    Mixed ionic-electronic conductor
    Porous for oxygen access

  Interconnect: Stainless steel (IT-SOFC) or LaCrO₃ (HT-SOFC)

Cell Designs:
  Planar:     Flat plates stacked, higher power density
  Tubular:    Tubes bundled, better thermal cycling
  Micro-tubular: Small tubes, rapid start-up (< 10 min)

Advantages:
  ✓ Fuel flexible — H₂, CO, CH₄, syngas, even NH₃
  ✓ Internal reforming — can reform methane directly on anode
  ✓ No precious metal catalysts (Ni instead of Pt)
  ✓ Highest electrical efficiency of any fuel cell
  ✓ High-quality waste heat for CHP (combined heat & power)
     Electrical: 50-65%, CHP: 80-90%

Challenges:
  ✗ Slow start-up (30 min to hours for thermal equilibrium)
  ✗ Thermal cycling degrades seals and interfaces
  ✗ Chromium poisoning from steel interconnects
  ✗ Nickel coarsening at anode over time
  ✗ Sulfur poisoning (< 1 ppm tolerance in fuel)

Applications:
  Bloom Energy Server: 250 kW per unit, natural gas
  Data centers, hospitals, universities
  Micro-CHP: 1-5 kW residential (Japan ENE-FARM)
  Military: JP-8 fuel compatible SOFC generators
  SOEC: Solid Oxide Electrolysis Cell (reverse mode for H₂ production)
EOF
}

cmd_efficiency() {
    cat << 'EOF'
=== Fuel Cell Efficiency ===

--- Thermodynamic Efficiency ---
  Maximum theoretical: η_thermo = ΔG / ΔH
  For H₂ + ½O₂ → H₂O:
    ΔG = -237.2 kJ/mol (Gibbs free energy)
    ΔH = -285.8 kJ/mol (LHV: -241.8 kJ/mol)
    η_max = 237.2 / 285.8 = 83% (HHV basis)

  NOT limited by Carnot cycle!
  Heat engines: η_Carnot = 1 - T_cold/T_hot
  At 500°C: Carnot max ≈ 61%
  Fuel cell at 80°C: theoretical max ≈ 83%

--- Voltage Efficiency ---
  η_voltage = V_cell / E_thermo
  E_thermo = 1.23V (reversible voltage at 25°C)
  Typical V_cell = 0.65V under load
  η_voltage = 0.65/1.23 = 53%

--- Losses (Overpotentials) ---
  1. Activation loss (η_act):
     Energy to start electrochemical reaction
     Dominant at low current density
     Mainly cathode (oxygen reduction is sluggish)
     Reduced by: better catalysts, higher temperature

  2. Ohmic loss (η_ohm):
     Resistance in membrane, electrodes, interconnects
     Linear with current: V = IR
     Reduced by: thinner membranes, better hydration

  3. Mass transport loss (η_conc):
     Reactant depletion at electrode surface
     Dominant at high current density
     Reduced by: better flow field design, thinner GDL

--- System Efficiency ---
  η_system = η_cell × η_fuel_utilization × η_parasitic

  Fuel utilization: fraction of fuel actually reacted
    Single-pass: 70-85%
    With recirculation: 85-95%

  Parasitic loads: pumps, blowers, cooling, controls
    Typically 5-15% of gross power

  Real-world system efficiencies:
    PEMFC vehicle:    50-60% peak, 30-40% drive cycle
    SOFC stationary:  50-65% electrical
    SOFC CHP:         80-90% total (heat + power)
    MCFC:             47% electrical, 80%+ CHP

--- Efficiency vs Load ---
  Unlike engines, fuel cells are MOST efficient at partial load
  Peak efficiency typically at 20-40% of rated power
  Engines peak at 80-100% load
  This makes fuel cells ideal for variable-load applications
EOF
}

cmd_bop() {
    cat << 'EOF'
=== Balance of Plant (BOP) ===

The fuel cell stack alone doesn't work — BOP components make it a system.

--- Air Supply ---
  Compressor/blower for cathode air
  Air filter (remove particulates, pollutants)
  Humidifier (PEM: air must be humidified)
  Pressure control valve
  Consumes 10-20% of system power (biggest parasitic load)

--- Fuel Supply ---
  Pressure regulator (H₂ tank: 350-700 bar → 1-3 bar)
  Recirculation pump (recycle unused H₂)
  Purge valve (remove N₂ and water accumulation)
  For natural gas SOFC: desulfurizer + pre-reformer

--- Humidification (PEM) ---
  Membrane humidifier: uses exhaust water to humidify inlet
  Direct injection: spray water into air stream
  Internal: stack design uses product water
  Target: 80-100% relative humidity at membrane

--- Thermal Management ---
  PEM (80°C):
    Liquid coolant loop (deionized water or glycol)
    Radiator or heat exchanger
    Coolant pump
    Temperature control to ±2°C across stack

  SOFC (800°C):
    Air cooling (cathode air excess)
    Heat exchangers for thermal integration
    Insulation to maintain temperature
    Startup heater (initial heat-up)

--- Power Conditioning ---
  DC-DC converter: match fuel cell voltage to bus voltage
    Fuel cell: variable 200-400 VDC
    Bus: regulated 48V, 400V, or 800V

  DC-AC inverter: for grid connection or AC loads
  Battery buffer: handles transient loads
    Fuel cell responds in seconds
    Battery handles millisecond transients

--- Control System ---
  Monitors: voltage, current, temperature, pressure, humidity
  Controls: air flow, fuel flow, cooling, purge timing
  Safety: leak detection, emergency shutdown
  Diagnostics: EIS (Electrochemical Impedance Spectroscopy)
  CAN bus or EtherCAT for automotive applications

--- BOP Cost Breakdown (typical PEMFC system) ---
  Stack: 40-50% of system cost
  Air compressor: 10-15%
  Power electronics: 10-15%
  Humidifier: 5-8%
  Thermal management: 5-8%
  Hydrogen storage: 10-15%
  Controls & sensors: 5%
EOF
}

cmd_degradation() {
    cat << 'EOF'
=== Fuel Cell Degradation ===

--- PEM Degradation Mechanisms ---

  Membrane degradation:
    Chemical: radical attack (OH•, OOH•) on PFSA polymer
    Mechanical: creep, pin-holes from humidity cycling
    Rate: 1-10 μV/h (voltage decay)
    Accelerated by: open circuit, low humidity, high temperature

  Catalyst degradation:
    Pt dissolution: Pt → Pt²⁺ (accelerated by voltage cycling)
    Ostwald ripening: small Pt particles dissolve, redeposit on large ones
    Pt migration: Pt²⁺ moves into membrane → "Pt band"
    Carbon support corrosion: C + 2H₂O → CO₂ + 4H⁺ + 4e⁻
      Accelerated by: high potential (> 1.0V), startup/shutdown

  GDL degradation:
    Hydrophobicity loss (PTFE coating degrades)
    Compression set → reduced porosity
    Carbon fiber oxidation

--- SOFC Degradation ---
  Ni coarsening: Ni particles agglomerate → less active surface
  Chromium poisoning: Cr from steel interconnects deposits on cathode
  Sulfur poisoning: even 1 ppm H₂S degrades Ni anode
  Delamination: thermal cycling causes layer separation
  Rate: 0.1-0.5%/1000 hours voltage decay

--- Mitigation Strategies ---

  Operating strategies:
    Avoid open circuit voltage (OCV) — use dummy load
    Limit voltage cycling range (0.6-0.85V)
    Maintain proper humidification (PEM)
    Slow startup/shutdown ramps
    Periodic voltage recovery (air starvation pulse)

  Material improvements:
    Stabilized Pt alloys (PtCo, PtNi) — resist dissolution
    Graphitized carbon supports — resist corrosion
    Reinforced membranes (ePTFE-reinforced Nafion)
    Radical scavengers (Ce, Mn oxides in membrane)
    Protective coatings on SOFC interconnects

--- Lifetime Targets ---
  Automotive PEMFC:   5,000-8,000 hours (DOE target: 8,000h)
  Bus PEMFC:          25,000 hours
  Stationary SOFC:    40,000-80,000 hours
  Portable DMFC:      2,000-5,000 hours

  Degradation rate targets:
    Automotive: < 10% power loss over 5,000 hours
    Stationary: < 0.2%/1000h voltage decay
EOF
}

cmd_applications() {
    cat << 'EOF'
=== Fuel Cell Applications ===

--- Transportation ---
  Passenger vehicles (FCEV):
    Toyota Mirai: 128 kW PEMFC, 650 km range, 700 bar H₂
    Hyundai Nexo: 95 kW PEMFC, 610 km range
    Honda Clarity: 103 kW (discontinued 2021)
    Refueling: 3-5 minutes (vs 30+ min BEV fast charge)

  Heavy-duty trucks:
    Hyundai XCIENT: 180 kW PEMFC, 400 km range
    Nikola Tre: 200 kW, class 8 truck
    Fuel cells competitive for long-haul (weight, range, refuel time)

  Buses:
    Van Hool, Solaris, Wrightbus
    100-150 kW systems, 300-400 km range
    12,000+ fuel cell buses deployed globally

  Trains:
    Alstom Coradia iLint: first hydrogen train (2018, Germany)
    Replaces diesel on non-electrified routes

  Maritime:
    Submarine AIP (Air-Independent Propulsion)
    Ferry boats (Norled MF Hydra, Norway)
    Port equipment (forklifts — 60,000+ deployed)

--- Stationary Power ---
  Large scale (100 kW - 10 MW):
    Bloom Energy Server: 250 kW SOFC, natural gas
    FuelCell Energy DFC: 1.4 MW MCFC
    Data centers, hospitals, industrial CHP

  Micro-CHP (1-5 kW):
    Japan ENE-FARM: 400,000+ residential SOFC units
    Generates electricity + hot water
    37% electrical + 53% thermal = 90% total efficiency

  Backup power:
    Telecom towers: replaces diesel generators
    UPS: hospitals, data centers
    Advantage: quiet, clean, long-duration (vs batteries)

--- Portable Power ---
  Military: 20-500W soldier-portable generators
  Drones: extended flight time (2-4× battery endurance)
  Consumer: camping, RV auxiliary power
  DMFC: direct methanol for low-power electronics
EOF
}

show_help() {
    cat << EOF
fuel-cell v$VERSION — Fuel Cell Technology Reference

Usage: script.sh <command>

Commands:
  intro        Fuel cell fundamentals and electrochemistry
  types        Fuel cell types comparison (PEM, SOFC, etc.)
  pem          PEM fuel cell details and components
  sofc         Solid oxide fuel cell technology
  efficiency   Efficiency calculations and losses
  bop          Balance of plant components
  degradation  Degradation mechanisms and mitigation
  applications Transport, stationary, and portable uses
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    types)        cmd_types ;;
    pem)          cmd_pem ;;
    sofc)         cmd_sofc ;;
    efficiency)   cmd_efficiency ;;
    bop)          cmd_bop ;;
    degradation)  cmd_degradation ;;
    applications|apps) cmd_applications ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "fuel-cell v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
