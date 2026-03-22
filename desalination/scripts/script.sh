#!/usr/bin/env bash
# desalination — Desalination Technology Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Desalination: Fresh Water from the Sea ===

Desalination removes dissolved salts and minerals from seawater
or brackish water to produce potable or industrial-grade water.

Source Water Types:
  Type              TDS (mg/L)     Examples
  ────              ──────────     ────────
  Fresh water       <500           Rivers, lakes
  Brackish water    1,000–10,000   Ground water, estuaries
  Seawater          30,000–45,000  Oceans (avg 35,000)
  Brine             >50,000        Reject streams, salt lakes

  TDS = Total Dissolved Solids
  Seawater ~35 g/L: NaCl 85%, MgCl₂ 5%, MgSO₄ 4%, CaSO₄ 3%

Global Scale:
  Installed capacity: ~110 million m³/day (2024)
  Number of plants: ~22,000 worldwide
  Top countries: Saudi Arabia, UAE, Israel, Spain, Australia
  Growth: 7-9% per year
  People dependent: 300+ million

Technology Market Share:
  Reverse Osmosis (RO):           69% of capacity
  Multi-Stage Flash (MSF):        18%
  Multi-Effect Distillation (MED): 7%
  Electrodialysis (ED):           3%
  Other (MVC, FO, MD):            3%

  Trend: RO dominates new builds (>85% of new capacity)
  Thermal still used where: waste heat available, high TDS, co-generation

Water Quality Standards:
  WHO drinking water:    <500 mg/L TDS
  RO permeate:           50–300 mg/L TDS (typical)
  Thermal distillate:    5–25 mg/L TDS (very pure)
  
  Post-treatment needed: remineralization (add Ca²⁺, Mg²⁺)
  pH adjustment: CO₂ + lime → stabilize for distribution
EOF
}

cmd_ro() {
    cat << 'EOF'
=== Reverse Osmosis (RO) ===

Natural osmosis: water moves from low to high salt concentration.
REVERSE osmosis: apply pressure to force water from HIGH to LOW
salt concentration through a semi-permeable membrane.

Key Parameters:
  Osmotic pressure (π):
    π = i × M × R × T
    Seawater (35 g/L): ~27 bar osmotic pressure
    Brackish (5 g/L): ~3.5 bar
    Must exceed π to produce permeate
  
  Operating pressure:
    Seawater RO:   55–70 bar (typically 60 bar)
    Brackish RO:   10–25 bar
    Nanofiltration: 5–15 bar

  Recovery Rate:
    = Permeate flow / Feed flow × 100%
    Seawater: 40–50% (limited by osmotic pressure increase)
    Brackish: 75–90% (lower osmotic pressure)
    Higher recovery → more concentrated brine → more energy

  Salt Rejection:
    = (1 - Cp/Cf) × 100%
    Modern SWRO membranes: 99.5–99.8%
    Two-pass RO: 99.9%+ (boron removal, high purity)

  Flux (water flow through membrane):
    = Permeate flow / Membrane area
    Typical: 13–17 LMH (liters/m²/hour) for SWRO
    Higher flux → more production but faster fouling

RO System Layout:
  Intake → Screen → Pretreatment → Cartridge Filter
  → High-Pressure Pump → RO Membrane Array
  → Permeate (product) + Concentrate (reject)
  → Energy Recovery Device → Brine discharge
  → Post-treatment → Product water storage

Membrane Element:
  Spiral-wound: industry standard
  8" × 40" element: 37–41 m² membrane area
  16" element: 4× area (large plants)
  Typical vessel: 7–8 elements in series
  Array: 100s to 1000s of vessels in parallel
EOF
}

cmd_thermal() {
    cat << 'EOF'
=== Thermal Desalination ===

Evaporate seawater → condense pure steam → fresh water.
Heat-driven: uses steam or waste heat, not pressure.

Multi-Stage Flash (MSF):
  Process:
    1. Seawater heated to 90–110°C (Top Brine Temperature)
    2. Flows through 15–28 stages at decreasing pressure
    3. At each stage: brine "flashes" (evaporates instantly)
    4. Steam condenses on tubes → collected as distillate
  
  Key parameters:
    GOR (Gain Output Ratio): 8–12 kg water per kg steam
    TBT: 90–110°C (limited by CaSO₄ scaling)
    Energy: 250–330 MJ/m³ thermal + 3–5 kWh/m³ electrical
    Capacity: up to 75,000 m³/day per unit
  
  Pros: very robust, handles high TDS, minimal pretreatment
  Cons: high energy, large footprint, declining market share
  Dominates in: Gulf states (co-generation with power plants)

Multi-Effect Distillation (MED):
  Process:
    1. Seawater sprayed on tubes in first effect
    2. Hot steam inside tubes → seawater evaporates outside
    3. Generated steam feeds next effect (lower pressure/temp)
    4. Repeat through 8–16 effects
  
  Key parameters:
    GOR: 10–16 (better than MSF)
    TBT: 65–70°C (lower → less scaling, can use waste heat)
    Energy: 150–230 MJ/m³ thermal + 1.5–2.5 kWh/m³ electrical
    Capacity: up to 36,000 m³/day per unit
  
  Pros: lower energy than MSF, works with waste/solar heat
  Cons: smaller unit capacity, corrosion management
  MED-TVC: with thermal vapor compression → GOR up to 16

Mechanical Vapor Compression (MVC):
  Process:
    1. Evaporate seawater in a vessel
    2. Mechanical compressor compresses vapor (raises temp)
    3. Compressed vapor condenses on evaporator tubes
    4. Heat of condensation evaporates more seawater
  
  Energy: 7–12 kWh/m³ (electricity only, no steam needed)
  Capacity: 500–5,000 m³/day (smaller plants)
  Pros: standalone (no steam supply needed), compact
  Cons: limited scale, compressor maintenance

Technology Comparison:
                    RO        MSF       MED       MVC
  Energy (kWh/m³)  3–4       15–25     10–18     7–12
  TDS tolerance    ≤45,000   ≤70,000   ≤70,000   ≤45,000
  Recovery         40–50%    25–40%    25–40%    40–50%
  Scale            any       large     medium    small
  Heat needed?     No        Yes       Yes       No
EOF
}

cmd_pretreatment() {
    cat << 'EOF'
=== Feed Water Pretreatment ===

Pretreatment protects RO membranes from fouling, scaling, and damage.
Rule: "Take care of pretreatment, and the membranes take care of themselves."

Intake Types:
  Open intake:     seawater from shoreline or offshore
    Pros: unlimited capacity
    Cons: needs extensive pretreatment (organics, algae, debris)
  
  Beach wells:     vertical or horizontal wells through sand
    Pros: natural filtration, consistent quality
    Cons: limited capacity, site-specific, iron/manganese risk

Pretreatment Train (conventional):
  1. Intake screens (>3mm) → remove debris, marine life
  2. Coagulation (FeCl₃) → destabilize colloids
  3. Flocculation → aggregate particles
  4. Sedimentation or DAF → remove flocs
  5. Media filtration (sand/anthracite) → remove suspended solids
  6. Cartridge filter (5μm) → final protection before RO

Pretreatment Train (membrane-based):
  1. Intake screens
  2. Coagulation (lower dose)
  3. UF/MF membranes (0.04–0.1 μm) → replaces media filters
  4. Cartridge filter (optional)
  
  UF pretreatment advantages:
    Better & consistent permeate quality (SDI < 2)
    Smaller footprint
    Better during algal blooms (red tide events)
    Higher capital cost but lower membrane replacement

Water Quality Parameters:
  SDI (Silt Density Index):
    SDI < 3: acceptable for SWRO
    SDI < 5: acceptable for BWRO
    SDI > 5: improve pretreatment!
    Measured: time to filter 500mL through 0.45μm at 30 psi

Chemical Dosing:
  Antiscalant:     prevent CaCO₃, CaSO₄, BaSO₄ scaling
  Acid:            H₂SO₄ to lower pH (prevent CaCO₃ scaling)
  Chlorine:        biofouling control (must dechlorinate before RO!)
  Sodium bisulfite: dechlorination (SBS, 3 mg/L per 1 mg/L Cl₂)
  Coagulant:       FeCl₃ 1–10 mg/L for particle removal

WARNING: Chlorine destroys polyamide RO membranes!
  Max 0.1 mg/L free chlorine for PA membranes
  Always dechlorinate + verify with ORP before RO feed
EOF
}

cmd_energy() {
    cat << 'EOF'
=== Energy Consumption & Recovery ===

Theoretical Minimum Energy:
  Thermodynamic limit for SWRO at 50% recovery: ~1.06 kWh/m³
  Best current practice: 2.5–3.0 kWh/m³ (total plant)
  Typical SWRO plant: 3.0–4.5 kWh/m³ (total)
  
  Energy breakdown (typical SWRO):
    High-pressure pump:    65%
    Pretreatment:          10%
    Intake/outfall:        8%
    Post-treatment:        5%
    Product delivery:      7%
    Auxiliary:             5%

Energy Recovery Devices (ERD):
  Recover energy from high-pressure concentrate (reject) stream.
  Concentrate exits at 55–65 bar → huge energy potential!

  Pressure Exchanger (PX, isobaric):
    Ceramic rotor transfers pressure directly: brine → feed
    Efficiency: 95–98%
    Market leader: Energy Recovery Inc. (ERI PX)
    Saves: 40–60% of energy consumption
    Dominant technology for SWRO

  Turbocharger:
    Hydraulic turbine converts brine pressure to shaft power
    Powers booster pump on feed side
    Efficiency: 80–90%
    Used in: medium-sized plants, retrofits

  Pelton Turbine:
    Impulse turbine converts brine pressure to electricity
    Fed back to motor of HP pump
    Efficiency: 85–92%
    Legacy technology, being replaced by PX

SWRO Energy Over Time:
  1970s:  ~20 kWh/m³ (no energy recovery)
  1980s:  ~10 kWh/m³ (Pelton turbines)
  1990s:  ~5 kWh/m³ (turbochargers)
  2000s:  ~3.5 kWh/m³ (pressure exchangers)
  2020s:  ~2.5–3.0 kWh/m³ (optimized PX + high-efficiency pumps)

Renewable Energy Integration:
  Solar PV + RO: well-matched (daytime production)
  Wind + RO: variable, needs storage or grid backup
  Solar thermal + MED: direct heat use
  Hybrid: solar PV + battery + RO for off-grid
  Energy cost: 40–50% of total water cost (critical factor)
EOF
}

cmd_membranes() {
    cat << 'EOF'
=== RO Membranes ===

Membrane Types:
  Thin-Film Composite (TFC) — industry standard:
    Support layer: polysulfone (porous)
    Active layer: polyamide (ultra-thin, 0.2 μm)
    Backing: polyester nonwoven fabric
    
    SWRO: high rejection (99.5-99.8%), lower flux
    BWRO: lower rejection (99.0-99.5%), higher flux
    Low-energy: lower pressure, slightly lower rejection
    High-boron rejection: for meeting WHO boron limits

  Cellulose Acetate (CA) — legacy:
    Chlorine tolerant (1 mg/L continuous)
    Lower rejection (95-98%)
    pH range: 4-6 (narrow)
    Still used in: some wastewater applications

Major Manufacturers:
  DuPont (FilmTec):      SW30 series — most widely deployed
  Toray:                 TM800 series — high flux
  LG Chem (NanoH₂O):    high permeability membranes
  Hydranautics:          SWC series
  Toyobo:               hollow fiber (CTA)

Membrane Performance (8" element):
  Element         Flow (m³/d)   Rejection   Application
  ───────         ───────────   ─────────   ───────────
  SW30HRLE-400i   28            99.8%       Standard SWRO
  SW30XLE-400i    34            99.7%       Low-energy SWRO
  BW30-400        40            99.5%       Brackish water
  BW30LE-440      48            99.3%       Low-energy BWRO

Fouling Types:
  Biological:    Biofilm growth (most common, hardest to remove)
  Colloidal:     Silt, clay, organic colloids
  Organic:       NOM (natural organic matter), oil
  Scaling:       CaCO₃, CaSO₄, BaSO₄, silica, CaF₂

Cleaning (CIP — Clean In Place):
  Frequency: every 1–6 months (depends on feed water quality)
  
  Organic/biological fouling:
    Alkaline: NaOH (pH 12, 35°C, 1–4 hours)
    + Surfactant or enzyme detergent
  
  Inorganic scaling:
    Acid: HCl or citric acid (pH 2, 25°C, 2–4 hours)
    Citric acid preferred (less aggressive)
  
  Warning: never mix acid and alkaline solutions!

Membrane Life:
  Design life: 5–7 years
  Actual: 3–10 years (depends on feed water and operation)
  Replacement cost: $300–$800 per element
  Indicators: salt passage increase, pressure drop increase
  Normalize: track performance at standard conditions
EOF
}

cmd_brine() {
    cat << 'EOF'
=== Brine Management ===

For every 100 L of seawater processed by SWRO:
  ~45 L becomes product water (permeate)
  ~55 L becomes brine at ~64 g/L TDS (1.8× seawater)

Brine Disposal Methods:

  Ocean Outfall (most common):
    Diffuser system: multi-port diffuser on seabed
    Dilution: target 1:20 within 50-100m of discharge
    Modeling: near-field (jet dynamics) + far-field (dispersion)
    Environmental: monitor salinity, dissolved oxygen, marine life
    Regulation: environmental impact assessment required
    Cost: lowest ($0.05–0.30/m³)

  Deep Well Injection:
    Inject into deep saline aquifer (>300m depth)
    Requires: suitable geology, no freshwater contamination
    Permits: extensive hydrogeological study
    Used in: inland plants (Florida, Middle East)
    Cost: $0.30–1.00/m³

  Evaporation Ponds:
    Large, shallow ponds — solar evaporation
    Requires: arid climate, cheap land
    Lined to prevent groundwater contamination
    Salt harvested or disposed
    Cost: $0.50–2.00/m³ (land-intensive)

  Zero Liquid Discharge (ZLD):
    Brine concentrator → crystallizer → solid salt
    Technologies: MVC, electrodialysis, eutectic freeze
    Energy: 20-70 kWh/m³ brine (very high!)
    Cost: $3–10/m³ (most expensive)
    Use when: no other discharge option, salt is valuable

Brine Valorization:
  Mineral extraction:
    NaCl:  table salt, industrial salt
    Mg(OH)₂: flame retardant, water treatment
    Gypsum (CaSO₄): construction
    Lithium: from concentrated brine (emerging)
  
  Energy:
    Salinity gradient power (PRO, RED): 0.5-0.7 kWh/m³
    Not yet commercially viable but promising

Environmental Impact:
  Salinity increase → stress on marine organisms
  Chemical residues: antiscalants, cleaning chemicals
  Temperature: thermal plants discharge warm brine
  Dissolved oxygen: lower in dense brine
  Impingement/entrainment: open intake risks to marine life
  
  Mitigation:
    Diffuser design for rapid dilution
    Subsurface intake (beach wells) → no entrainment
    Green chemistry: biodegradable antiscalants
    Marine monitoring programs
EOF
}

cmd_economics() {
    cat << 'EOF'
=== Desalination Economics ===

LCOW — Levelized Cost of Water:
  LCOW = (CAPEX_annualized + OPEX) / annual_production
  
  Typical ranges (USD/m³):
    Large SWRO (>100,000 m³/d):     $0.50–1.00
    Medium SWRO (10,000–100,000):   $0.80–1.50
    Small SWRO (<10,000 m³/d):      $1.50–3.00
    Brackish RO:                     $0.30–0.80
    MSF (co-generation):            $1.00–1.50
    MED (waste heat):               $0.80–1.30
    MVC (small thermal):            $1.50–3.00

CAPEX Breakdown (SWRO):
  RO equipment (membranes, vessels, pumps): 35–45%
  Pretreatment:                             15–20%
  Intake & outfall:                         10–15%
  Civil works:                              10–15%
  Electrical & controls:                    8–12%
  Post-treatment:                           3–5%
  
  Total CAPEX: $1,000–2,000 per m³/day capacity
  Large plant (200,000 m³/d): $200–400 million

OPEX Breakdown (SWRO):
  Energy:                    35–50%
  Membrane replacement:      8–15%
  Chemicals:                 5–10%
  Labor:                     5–15%
  Maintenance:               8–12%
  Membrane cleaning:         2–5%

Cost Reduction Trends:
  1990: $2.50–4.00/m³
  2000: $1.00–2.00/m³
  2010: $0.70–1.20/m³
  2020: $0.30–0.80/m³ (record low bids)
  
  Drivers:
    Membrane performance improvement (2×/decade)
    Energy recovery devices (PX)
    Larger plant scale (economies of scale)
    Competition (BOT/BOOT contract bidding)

Record Low Bids:
  Ras Al Khair (Saudi): ~$0.50/m³ (2010, massive scale)
  Sorek (Israel):       ~$0.52/m³ (2013)
  Taweelah (UAE):       ~$0.36/m³ (2019, lowest ever)
  Jubail 3A (Saudi):    ~$0.41/m³ (2020)

  Note: ultra-low bids assume: cheap energy, 25-year contract,
  government-backed, large scale (200,000+ m³/d)

Financial Structure:
  BOT (Build-Operate-Transfer): 20–25 year contracts
  BOOT (Build-Own-Operate-Transfer): developer retains ownership
  EPC + O&M: separate construction and operation contracts
  PPP: public-private partnership
  Water purchase agreement: $/m³ guaranteed offtake
EOF
}

show_help() {
    cat << EOF
desalination v$VERSION — Desalination Technology Reference

Usage: script.sh <command>

Commands:
  intro         Desalination overview, water sources, global scale
  ro            Reverse osmosis fundamentals and system design
  thermal       MSF, MED, MVC thermal desalination methods
  pretreatment  Feed water treatment, SDI, chemical dosing
  energy        Energy consumption, recovery devices, trends
  membranes     RO membrane types, fouling, cleaning, selection
  brine         Brine disposal, ZLD, environmental impact
  economics     CAPEX, OPEX, LCOW, and cost trends
  help          Show this help
  version       Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    ro)           cmd_ro ;;
    thermal)      cmd_thermal ;;
    pretreatment) cmd_pretreatment ;;
    energy)       cmd_energy ;;
    membranes)    cmd_membranes ;;
    brine)        cmd_brine ;;
    economics)    cmd_economics ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "desalination v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
