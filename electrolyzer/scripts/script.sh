#!/usr/bin/env bash
# electrolyzer — Electrolyzer Technology Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Water Electrolysis: Splitting Water into Hydrogen & Oxygen ===

Electrolysis: 2H₂O + electricity → 2H₂ + O₂

The fundamental reaction to produce green hydrogen from
renewable electricity and water.

Hydrogen Color Spectrum:
  Grey:    SMR (steam methane reforming), no CCS — 95% of H₂ today
  Blue:    SMR + carbon capture and storage
  Green:   Electrolysis powered by renewable electricity ← this skill
  Pink:    Electrolysis powered by nuclear
  Turquoise: Methane pyrolysis (solid carbon + H₂)
  White:   Naturally occurring geological hydrogen

Why Green Hydrogen:
  - Decarbonize hard-to-electrify sectors (steel, ammonia, shipping)
  - Store renewable energy (seasonal, long-duration)
  - Replace grey hydrogen (90 Mt/year market)
  - Enable synthetic fuels (e-methanol, e-kerosene)

Thermodynamic Minimum:
  ΔG = 237 kJ/mol → reversible voltage: 1.23 V (25°C, 1 bar)
  ΔH = 286 kJ/mol → thermoneutral voltage: 1.48 V
  
  At 1.23V: need external heat (endothermic)
  At 1.48V: no heat exchange (thermoneutral)
  Above 1.48V: generates waste heat (exothermic)
  
  Real operating voltage: 1.6–2.2 V (overpotentials + resistance)

Energy Content of Hydrogen:
  LHV: 120 MJ/kg = 33.3 kWh/kg
  HHV: 142 MJ/kg = 39.4 kWh/kg
  
  Theoretical minimum: 39.4 kWh/kg H₂ (HHV basis)
  Current practice: 50–65 kWh/kg H₂ (system level)

Global Electrolyzer Capacity:
  2020: ~0.3 GW installed
  2023: ~1.4 GW installed
  2030 target: 100–200 GW (IEA Net Zero scenario)
  Largest single: 260 MW (NEOM, Saudi Arabia — under construction)
EOF
}

cmd_alkaline() {
    cat << 'EOF'
=== Alkaline Electrolysis (AEL) ===

The most mature electrolysis technology — deployed since 1920s.
Chlor-alkali industry has decades of operating experience.

How It Works:
  Electrolyte: 25–30% KOH (potassium hydroxide) solution
  
  Cathode (−): 2H₂O + 2e⁻ → H₂ + 2OH⁻
  Anode (+):   2OH⁻ → ½O₂ + H₂O + 2e⁻
  
  Separator: porous diaphragm (Zirfon, polysulfone)
  Allows OH⁻ ions to pass, blocks H₂ and O₂ mixing

Key Parameters:
  Operating temp:    60–90°C
  Pressure:          1–30 bar (atmospheric to pressurized)
  Current density:   200–400 mA/cm² (lower than PEM)
  Cell voltage:      1.8–2.4 V
  Stack efficiency:  62–70% (HHV basis)
  System efficiency: 55–65% (HHV basis, including BOP)
  
  Specific energy:   50–58 kWh/kg H₂ (system level)
  Water consumption: 9–10 L/kg H₂ (stoichiometric: 9 L/kg)

Materials:
  Cathode: Nickel (Raney nickel for higher activity)
  Anode: Nickel or nickel-coated steel
  Separator: Zirfon (ZrO₂ + polysulfone), asbestos (legacy)
  Bipolar plates: nickel-plated steel
  
  NO precious metals needed → lower cost than PEM

Advantages:
  ✓ Lowest CAPEX ($500–1,200/kW)
  ✓ Long lifetime (60,000–90,000 hours stack)
  ✓ No precious metal catalysts
  ✓ Proven at large scale (>100 MW)
  ✓ Robust, forgiving operation

Limitations:
  ✗ Slow dynamic response (minutes to ramp)
  ✗ Limited partial load (20–40% minimum)
  ✗ Lower current density → larger footprint
  ✗ KOH is corrosive → material constraints
  ✗ Gas crossover risk at low loads (H₂ in O₂)

Major Manufacturers:
  Nel (Norway):       A-series, 3.5 MW per stack
  thyssenkrupp (DE):  20 MW modules
  LONGi (China):      ALK series, price leader
  Sunfire (Germany):  HyLink ALKALINE
  McPhy (France):     McLyzer
EOF
}

cmd_pem() {
    cat << 'EOF'
=== PEM Electrolysis (PEMEL) ===

Proton Exchange Membrane — solid polymer electrolyte.
Invented 1960s (GE), commercialized 2000s+.

How It Works:
  Membrane: Nafion (perfluorosulfonic acid, ~0.2mm thick)
  
  Anode (+): H₂O → 2H⁺ + ½O₂ + 2e⁻
  Cathode (−): 2H⁺ + 2e⁻ → H₂
  
  Protons (H⁺) migrate through membrane from anode to cathode
  Membrane also separates H₂ and O₂ (very low gas crossover)

Key Parameters:
  Operating temp:    50–80°C
  Pressure:          20–50 bar (differential or balanced)
  Current density:   1,000–4,000 mA/cm² (5-10× higher than AEL!)
  Cell voltage:      1.6–2.2 V
  Stack efficiency:  60–68% (HHV)
  System efficiency: 52–62% (HHV, including BOP)
  
  Specific energy:   52–62 kWh/kg H₂ (system level)
  Ramp rate:         seconds (0→100% in <10 seconds)
  Turn-down ratio:   5–100% load range

Materials:
  Anode catalyst:   Iridium oxide (IrO₂) — 1–3 mg/cm²
  Cathode catalyst: Platinum (Pt) — 0.3–1 mg/cm²
  Membrane:         Nafion 115/117 (DuPont) or PFSA alternatives
  Bipolar plates:   Titanium (corrosion resistant)
  PTL (porous transport layer): sintered titanium

  Critical materials:
    Iridium: $50,000–150,000/kg, 7 tons/year global production
    Platinum: $30,000–40,000/kg
    → Major cost and supply chain risk
    → Research: reduce loading to <0.1 mg/cm², Ir-free catalysts

Advantages:
  ✓ Fast dynamic response (seconds) → ideal for renewables
  ✓ High current density → compact footprint
  ✓ Wide load range (5–160% nominal)
  ✓ High-pressure output (30–50 bar directly)
  ✓ Very high gas purity (>99.99%)
  ✓ Quick start/stop capability

Limitations:
  ✗ Higher CAPEX ($1,000–2,000/kW)
  ✗ Precious metal catalysts (Ir, Pt)
  ✗ Membrane degradation (40,000–60,000 hours)
  ✗ Acidic environment → expensive materials (Ti)

Major Manufacturers:
  ITM Power (UK):    NEPTUNE platform, up to 5 MW stack
  Plug Power (US):   GenKey solutions
  Siemens Energy:    Silyzer 300, 17.5 MW module
  Nel (Norway):      M-series PEM
  H-TEC Systems:     ME450 series
EOF
}

cmd_soec() {
    cat << 'EOF'
=== Solid Oxide Electrolysis (SOEC) ===

High-temperature electrolysis using ceramic cells.
Highest potential efficiency — uses heat to reduce electricity need.

How It Works:
  Electrolyte: Yttria-stabilized zirconia (YSZ, ceramic)
  
  Cathode (−): H₂O + 2e⁻ → H₂ + O²⁻
  Anode (+):   O²⁻ → ½O₂ + 2e⁻
  
  O²⁻ (oxide ions) migrate through ceramic electrolyte
  Feed: STEAM (not liquid water) at 700–850°C

Key Parameters:
  Operating temp:    700–850°C
  Pressure:          1–25 bar
  Current density:   300–1,000 mA/cm²
  Cell voltage:      1.0–1.5 V (lower than AEL/PEM due to heat!)
  Stack efficiency:  80–90% (HHV, if heat is "free")
  System efficiency: 70–85% (HHV, with waste heat)
  
  Specific energy:   37–45 kWh/kg H₂ (with heat integration)
  Without free heat: ~55 kWh/kg H₂

Thermodynamic Advantage:
  At 800°C, part of energy comes from heat (TΔS):
    Reversible voltage: 1.23V at 25°C → 0.95V at 800°C
    Thermoneutral:     1.48V at 25°C → 1.29V at 800°C
  
  Less electricity needed → highest electrical efficiency
  Best when paired with: nuclear, solar thermal, industrial waste heat

Materials:
  Cathode: Ni-YSZ cermet (nickel + ceramic composite)
  Anode: LSM (lanthanum strontium manganite) or LSCF
  Electrolyte: YSZ (8 mol% Y₂O₃) — 5–15 μm thick
  Interconnect: Cr-Fe alloy or ceramic
  
  No precious metals! All materials are abundant.

Co-Electrolysis:
  SOEC can co-electrolyze H₂O + CO₂ → H₂ + CO (syngas!)
  Syngas → Fischer-Tropsch → synthetic fuels
  → Direct path from CO₂ + H₂O + electricity → jet fuel
  This is unique to SOEC — PEM and AEL cannot do this.

Reversible Operation:
  SOEC can operate in REVERSE as a fuel cell (SOFC)
  Electrolyzer mode: electricity + steam → H₂ + O₂
  Fuel cell mode:    H₂ + O₂ → electricity + heat
  Enables: round-trip energy storage (>70% efficiency)

Challenges:
  ✗ Degradation: 1–3%/1000h (ceramic sintering, Ni agglomeration)
  ✗ Thermal cycling: cracking from expansion mismatch
  ✗ Startup time: hours to reach operating temperature
  ✗ Limited commercial scale (largest: 4 MW)
  ✗ High-temp sealing challenges

Manufacturers:
  Bloom Energy (US):    solid oxide platform (fuel cell + electrolyzer)
  Sunfire (Germany):     HyLink SOEC (industrial heat integration)
  Haldor Topsoe (DK):   SOEC + e-fuels integration
  Ceres Power (UK):     SteelCell technology
EOF
}

cmd_stackdesign() {
    cat << 'EOF'
=== Stack Design ===

An electrolyzer stack is multiple cells connected in series.
Higher voltage, same current through each cell.

Cell Components (PEM example):
  ┌──────────────────────────────┐
  │  Bipolar Plate (Ti/Steel)    │  ← distributes water, collects gas
  │  ┌──────────────────────┐    │
  │  │  Anode PTL (Ti mesh)  │   │  ← porous transport layer
  │  │  Anode Catalyst (IrO₂)│   │
  │  │  ══ Membrane (Nafion)═│   │  ← proton conductor, gas barrier
  │  │  Cathode Catalyst (Pt) │  │
  │  │  Cathode GDL (carbon)  │  │  ← gas diffusion layer
  │  └──────────────────────┘    │
  │  Bipolar Plate               │
  └──────────────────────────────┘

Polarization Curve (I-V):
  Voltage = E_rev + η_activation + η_ohmic + η_mass_transport
  
  Region 1 (low current): dominated by activation overpotential
    Catalyst-dependent, logarithmic increase
  
  Region 2 (medium current): dominated by ohmic losses
    Linear increase, I×R through membrane + contacts
  
  Region 3 (high current): mass transport limitation
    Water/gas transport limits, exponential increase
    
  Typical operating point: 1.7–2.0V at design current density

Stack Assembly:
  Number of cells:    50–200 per stack (typical)
  Stack voltage:      cell voltage × number of cells
  Example: 100 cells × 1.9V = 190V DC
  
  Active area per cell: 500–5,000 cm² (PEM), up to 30,000 cm² (AEL)
  Compression: 20–40 bar bolting force (PEM), uniform critical
  Sealing: gaskets (FKM, EPDM, PTFE), or O-rings

Current Density Selection:
  Low (200 mA/cm²):
    Lower voltage, higher efficiency, less degradation
    But: larger stack needed, higher CAPEX
  
  High (2000+ mA/cm²):
    Smaller stack, lower CAPEX per kW
    But: more heat, faster degradation, lower efficiency
  
  Optimal: balance CAPEX (favors high CD) vs OPEX (favors low CD)
  Trend: increasing CD as catalyst costs decrease

Stack Sizing:
  H₂ production = (I × n_cells × η_F) / (2F)
  Where:
    I = current (A)
    n_cells = number of cells
    η_F = Faradaic efficiency (~0.99)
    F = Faraday constant (96,485 C/mol)
    2 = electrons per H₂ molecule
  
  1 MW PEM stack at 2 A/cm², 1000 cm² area:
    I = 2000A, 100 cells → ~18 kg H₂/hour
EOF
}

cmd_bop() {
    cat << 'EOF'
=== Balance of Plant (BOP) ===

The stack only produces hydrogen — BOP handles everything else.
BOP is typically 40–60% of total system cost!

Water Treatment:
  Feed water quality for PEM: Type II deionized water
    Conductivity: <1 μS/cm (ideally <0.1 μS/cm)
    TOC: <50 ppb
  
  Treatment train:
    Municipal water → softener → RO → EDI → DI water tank
    EDI (Electrodeionization): continuous ion removal
    
  Consumption: 9–10 L H₂O per kg H₂ (theoretical: 8.9 L/kg)
  Including cooling: 20–30 L/kg H₂ total water use

Power Electronics:
  Input: grid AC (medium voltage) or renewable DC
  AC/DC rectifier → DC bus → stack DC
  
  Thyristor rectifier: simple, cheap, lower efficiency (95%)
  IGBT rectifier: fast response, active control (97–98%)
  
  Power quality: ripple current affects membrane degradation
  Target: <5% current ripple
  
  Transformer: step down MV → LV (690V → stack voltage)
  Efficiency loss: 1–3% in power conversion

Gas Processing:
  H₂ processing:
    Gas-liquid separator (remove water droplets)
    Deoxygenation (catalytic, remove trace O₂ from H₂)
    Dryer (PSA or desiccant, remove moisture)
    Output: >99.999% H₂ (5N purity)
  
  O₂ processing:
    Gas-liquid separator
    Usually vented (unless captured for medical/industrial use)
    Safety: O₂-enriched atmosphere → fire risk!

Thermal Management:
  Stack generates heat: 20–40% of input power becomes heat
  Cooling: deionized water loop → heat exchanger → cooling tower
  Temperature control: ±2°C of setpoint
  
  Heat recovery: 60–80°C waste heat for:
    District heating, water preheating, building heating
    SOEC: heat integration with industrial process

Hydrogen Compression & Storage:
  PEM output: 30–50 bar (often sufficient for pipeline)
  Alkaline output: 1–30 bar (may need compression)
  Storage pressure: 200–700 bar (vehicles), 30–100 bar (pipeline)
  
  Compressor types:
    Reciprocating: 10–700 bar, proven, maintenance
    Ionic: liquid piston, oil-free, 45–1000 bar
    Electrochemical: compress during electrolysis (PEM advantage)
  
  Energy for compression: 2–5 kWh/kg H₂ (30→700 bar)

Safety Systems:
  H₂ detection: LEL sensors (<25% of 4% LEL)
  Ventilation: Zone 2 ATEX classification
  Purge: N₂ purging before start/stop
  Emergency shutdown: automatic on H₂ detection/loss of water
EOF
}

cmd_efficiency() {
    cat << 'EOF'
=== Efficiency Metrics ===

Cell Voltage Efficiency:
  η_voltage = E_thermoneutral / V_cell = 1.48 / V_cell
  At 1.8V: η = 1.48/1.8 = 82%
  At 2.0V: η = 1.48/2.0 = 74%
  Lower voltage = higher efficiency but lower production rate

Faradaic (Current) Efficiency:
  η_faradaic = actual H₂ produced / theoretical H₂ from current
  Typical: 95–99% (losses from gas crossover, parasitic reactions)
  PEM: >99% at nominal load
  Alkaline: 95–98% (more gas crossover through diaphragm)

Stack Efficiency:
  η_stack = η_voltage × η_faradaic
  PEM at 2.0V: 74% × 99% = 73% (HHV basis)
  Alkaline at 1.9V: 78% × 97% = 76% (HHV basis)
  SOEC at 1.3V: 114% (!) × 99% = 113% (uses heat input)

System Efficiency:
  η_system = η_stack × η_BOP
  BOP losses: power electronics (2–3%), pumps (1–2%),
              compression (3–8%), cooling (1–2%), controls (<1%)
  
  Typical system efficiency (kWh/kg H₂):
    PEM:      52–62 kWh/kg (system, LHV)
    Alkaline: 50–58 kWh/kg (system, LHV)
    SOEC:     37–45 kWh/kg (with heat, LHV)
  
  Theoretical minimum: 33.3 kWh/kg (LHV)

Degradation:
  Stack performance degrades over time:
    PEM:      1–3 μV/h cell voltage increase
    Alkaline: 0.5–2 μV/h
    SOEC:     3–10 μV/h (highest, improving rapidly)
  
  End of life: when voltage increase reaches 10–15%
  Example: PEM at 2 μV/h → +17 mV/year → 10 years to +170mV
  
  Degradation factors:
    Current density (higher = faster degradation)
    Temperature cycling (thermal stress)
    Load cycling (expansion/contraction)
    Water purity (impurities poison catalysts)
    Oxygen in hydrogen side (membrane degradation)

Capacity Factor:
  Hours of operation per year / 8,760 hours
  Grid-connected: 90–95% (limited by maintenance)
  Renewable-coupled: 20–50% (limited by RE availability)
  
  Impact: lower CF → higher LCOH (CAPEX spread over fewer kg)
  CAPEX-intensive: 4000 h/yr may be breakeven minimum
EOF
}

cmd_economics() {
    cat << 'EOF'
=== Green Hydrogen Economics ===

LCOH — Levelized Cost of Hydrogen:
  LCOH = (CAPEX_annual + OPEX + Electricity) / H₂_produced

  Components:
    CAPEX:       30–50% of LCOH (at high capacity factor)
    Electricity: 50–70% of LCOH (dominant cost!)
    O&M:         3–5% of CAPEX per year

CAPEX Trends ($/kW):
                    2020        2023        2030 (target)
  PEM              $1,200–2,000 $800–1,400  $200–500
  Alkaline         $500–1,200   $400–900    $150–400
  SOEC             $2,500–5,000 $2,000–3,000 $500–1,000

Electricity Cost Impact:
  Electricity price  →  LCOH (at 55 kWh/kg, 90% CF)
  $0.02/kWh             $1.5–2.5/kg
  $0.04/kWh             $2.5–3.5/kg
  $0.06/kWh             $3.5–4.5/kg
  $0.08/kWh             $4.5–5.5/kg
  
  Target: <$2/kg to compete with grey hydrogen (~$1.5/kg)
  Need: <$0.03/kWh electricity AND <$400/kW CAPEX

LCOH by Production Method (2024):
  Grey hydrogen (SMR):           $1.0–2.0/kg
  Blue hydrogen (SMR + CCS):    $1.5–3.0/kg
  Green hydrogen (best solar):  $3.0–5.0/kg
  Green hydrogen (average):     $4.0–8.0/kg
  Green hydrogen (offshore wind): $5.0–10.0/kg

Cost Reduction Pathways:
  Manufacturing scale:
    Current: <5 GW/year global manufacturing
    Target: >100 GW/year by 2030
    Learning rate: 15–20% cost reduction per doubling
  
  Material reduction:
    PEM: reduce Ir loading from 2 mg/cm² → 0.2 mg/cm²
    PEM: replace Ti bipolar plates with coated steel
    Non-PGM catalysts: Fe, Co, Ni-based (research stage)
  
  Efficiency improvement:
    Higher current density → smaller stack → lower CAPEX/kW
    Better catalysts → lower overpotential → less electricity
    Heat integration (SOEC) → 30% less electricity
  
  Operational:
    Higher capacity factor (co-located with solar + wind)
    Stack lifetime extension (80,000+ hours)
    Predictive maintenance → reduce downtime

Government Incentives:
  US IRA (45V):        $3/kg H₂ production tax credit (10 years)
  EU REPowerEU:        €3/kg H₂ auctions (H₂ Bank)
  China:               provincial subsidies, $0.5–1.5/kg
  India:               $0.60/kg (SIGHT program)
  
  With $3/kg subsidy + $0.03/kWh solar:
    LCOH effectively: ~$0–1/kg (competitive with grey!)
EOF
}

show_help() {
    cat << EOF
electrolyzer v$VERSION — Electrolyzer Technology Reference

Usage: script.sh <command>

Commands:
  intro        Water electrolysis overview and hydrogen colors
  alkaline     Alkaline electrolysis technology
  pem          PEM electrolysis (proton exchange membrane)
  soec         Solid oxide electrolysis (high temperature)
  stackdesign  Cell and stack design, polarization curves
  bop          Balance of plant: water, power, gas, thermal
  efficiency   Voltage, current, system efficiency, degradation
  economics    LCOH, CAPEX trends, cost reduction pathways
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    alkaline)    cmd_alkaline ;;
    pem)         cmd_pem ;;
    soec)        cmd_soec ;;
    stackdesign) cmd_stackdesign ;;
    bop)         cmd_bop ;;
    efficiency)  cmd_efficiency ;;
    economics)   cmd_economics ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "electrolyzer v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
