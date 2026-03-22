#!/usr/bin/env bash
# osmosis — Membrane Separation Technology Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Osmosis & Membrane Technology ===

Osmosis is the spontaneous movement of solvent molecules through
a semipermeable membrane from a region of lower solute concentration
to a region of higher solute concentration.

Natural Osmosis:
  Membrane allows water to pass but blocks dissolved salts
  Water moves from dilute side → concentrated side
  Continues until osmotic pressure equilibrium reached

Osmotic Pressure (van't Hoff equation):
  π = iMRT
  Where:
    π = osmotic pressure (atm or bar)
    i = van't Hoff factor (ions per molecule: NaCl → 2)
    M = molar concentration (mol/L)
    R = gas constant (0.08206 L·atm/mol·K)
    T = temperature (Kelvin)

  Practical osmotic pressure values:
    Fresh water:       ~0 bar
    Brackish water:    1-10 bar (1,000-10,000 ppm TDS)
    Seawater:          ~27 bar (35,000 ppm TDS)
    Dead Sea:          ~200 bar (340,000 ppm TDS)
    RO concentrate:    40-70 bar (depending on recovery)

Membrane Processes Spectrum:
  Process          Driving Force        Removes
  ────────────────────────────────────────────────────
  MF (Microfiltration)     0.1-2 bar    Bacteria, particles (>0.1μm)
  UF (Ultrafiltration)     1-10 bar     Viruses, proteins (>0.01μm)
  NF (Nanofiltration)      5-20 bar     Divalent ions, organics
  RO (Reverse Osmosis)     15-80 bar    All dissolved solids
  FO (Forward Osmosis)     Osmotic ΔP   Same as RO, lower energy

Water Treatment Applications:
  Municipal:   drinking water, wastewater reclamation
  Industrial:  boiler feedwater, process water, cooling tower makeup
  Desalination: seawater, brackish groundwater
  Food/Bev:    juice concentration, dairy processing
  Pharma:      WFI (Water for Injection), USP purified water
  Power:       nuclear plant coolant purification
EOF
}

cmd_reverse() {
    cat << 'EOF'
=== Reverse Osmosis (RO) ===

Principle:
  Apply pressure GREATER than osmotic pressure
  Forces water molecules through membrane AGAINST natural osmosis
  Solute molecules are rejected (blocked by membrane)

  Feed → [Membrane] → Permeate (clean water)
                    → Concentrate (reject/brine)

Key Parameters:
  Feed pressure:  15-80 bar (depending on salinity)
  Recovery rate:  40-85% (permeate/feed volume ratio)
  Salt rejection: 95-99.8% (for TPA membranes)
  Permeate flux:  15-30 LMH (liters/m²/hour)

System Components:
  1. Feed pump (intake from source)
  2. Pretreatment (see pretreatment command)
  3. High-pressure pump (10-80 bar)
  4. Membrane array (pressure vessels with elements)
  5. Energy recovery device (ERD)
  6. Post-treatment (remineralization, pH, disinfection)
  7. Concentrate disposal

Array Configuration:
  Single pass: feed → membranes → permeate
  Two pass: permeate from 1st pass → 2nd RO → ultra-pure
  
  Staging:
    Stage 1: 6 vessels, Stage 2: 3 vessels (2:1 ratio)
    Concentrate from Stage 1 feeds Stage 2
    Increases overall recovery rate

  Typical element: 8" × 40" spiral wound (37 m² membrane area)
  Vessels hold 6-7 elements in series
  Large plant: thousands of elements

Operating Modes:
  Constant flux: adjust pressure as membrane ages
  Constant pressure: flux declines as membrane ages
  Batch RO: pressurize, extract, replenish (emerging)
  CCRO (Closed Circuit RO): recirculate concentrate for high recovery

Recovery Rate Selection:
  Seawater RO:  40-50% (limited by osmotic pressure and scaling)
  Brackish RO:  75-85% (higher recovery possible)
  Wastewater:   80-90% (depends on fouling potential)
  
  Higher recovery → more product, but:
    - Higher concentrate salinity → more pressure needed
    - More scaling risk (CaSO₄, CaCO₃, silica)
    - Lower permeate quality
EOF
}

cmd_membranes() {
    cat << 'EOF'
=== Membrane Types ===

Thin-Film Composite (TFC):
  Most common RO membrane material
  Structure:
    Support layer: polyester fabric (120 μm)
    Microporous layer: polysulfone (40 μm)
    Active layer: polyamide (0.2 μm) — does the separation!
  
  Properties:
    Salt rejection: 99.0-99.8%
    pH range: 2-11 (cleaning), 3-10 (continuous)
    Max temperature: 45°C
    Chlorine tolerance: NONE (degrades polyamide)
    Max pressure: 41-83 bar
  
  Manufacturers: Dow/DuPont (FilmTec), Toray, LG, Hydranautics

Cellulose Triacetate (CTA):
  Older technology, still used in specific applications
  Properties:
    Salt rejection: 95-99%
    Chlorine tolerant: up to 1 ppm (advantage over TFC!)
    Biofouling resistant
    Lower rejection than TFC
    pH range narrower (4-8)
  Use: FO membranes, chlorinated feedwater

Module Configurations:
  Spiral Wound:
    Flat sheets wound around permeate tube
    Most common for RO/NF
    Standard sizes: 4" and 8" diameter
    Membrane area: 7.4-37 m² per element
    Pros: high packing density, standardized
    Cons: fouling-sensitive, needs pretreatment

  Hollow Fiber:
    Thousands of thin tubes (0.5-2mm diameter)
    Water flows through wall (inside-out or outside-in)
    Highest packing density (surface area per volume)
    Used in: UF/MF pretreatment, some RO
    Pros: backwashable, compact
    Cons: plugging risk, lower pressure rating

  Tubular:
    Large tubes (5-25mm diameter)
    Feed flows inside the tube
    Pros: handles high turbidity, easy to clean
    Cons: low packing density, expensive
    Use: food industry, high-solids wastewater

  Flat Sheet/Plate & Frame:
    Stacked flat membranes with spacers
    Used in: MBR (membrane bioreactor), ED
    Pros: easy to inspect/replace individual sheets
    Cons: low packing density

Emerging Membranes:
  Aquaporin: biomimetic (water channel proteins)
  Graphene oxide: atomic-thin, high permeability
  MOF (Metal-Organic Framework): tunable pore size
  Carbon nanotube: ultrafast water transport
EOF
}

cmd_desalination() {
    cat << 'EOF'
=== Desalination Engineering ===

Seawater RO (SWRO):
  Feed salinity: 32,000-45,000 ppm TDS
  Operating pressure: 55-70 bar
  Recovery: 40-50%
  Permeate quality: <500 ppm TDS (typically <200 ppm)
  SEC: 3-5 kWh/m³ (with ERD)
  
  Largest SWRO plants:
    Ras Al Khair (Saudi Arabia):    1,036,000 m³/day
    Sorek B (Israel):               548,000 m³/day
    Jubail 3A (Saudi Arabia):       600,000 m³/day

Brackish Water RO (BWRO):
  Feed salinity: 1,000-10,000 ppm TDS
  Operating pressure: 10-30 bar
  Recovery: 75-90%
  SEC: 0.5-2.5 kWh/m³
  Lower cost than SWRO (lower pressure, higher recovery)

Energy Recovery Devices (ERD):
  Recover energy from high-pressure concentrate stream
  
  Isobaric devices (PX Pressure Exchanger):
    Transfer pressure directly from concentrate to feed
    Efficiency: 95-98%
    Reduces SWRO energy by ~60%
    Dominant technology in large SWRO plants
  
  Turbocharger (Pelton turbine + pump):
    Convert concentrate kinetic energy to boost pressure
    Efficiency: 75-85%
    Simpler, lower capital cost
    Better for smaller plants

Desalination Cost Breakdown:
  Capital (CAPEX): 30-40%
    Membranes, pumps, ERD, piping, intake/outfall
  Energy (OPEX): 30-40%
    Electricity for high-pressure pumps
  Chemicals: 5-10%
    Antiscalant, cleaning, post-treatment
  Membrane replacement: 5-10%
    Every 5-7 years typically
  Labor & maintenance: 10-15%

  Total cost of water:
    SWRO: $0.50-1.50/m³
    BWRO: $0.30-0.80/m³
    (varies hugely by location, scale, energy cost)

Concentrate Disposal:
  Surface water discharge: ocean outfall (most common for coastal)
  Deep well injection: inland plants
  Evaporation ponds: arid regions, small plants
  Zero Liquid Discharge (ZLD): crystallizer + brine concentrator
  Beneficial use: salt harvesting, mineral recovery
EOF
}

cmd_fouling() {
    cat << 'EOF'
=== Membrane Fouling ===

Types of Fouling:

  1. Particulate/Colloidal Fouling:
    Suspended solids deposit on membrane surface
    Sources: silt, clay, iron flocs, silica colloids
    Measured by: SDI (Silt Density Index) or MFI
    Target: SDI < 3 for RO feed (< 5 is minimum)
    Prevention: UF/MF pretreatment, media filtration

  2. Biological Fouling (Biofouling):
    Bacteria attach and form biofilm on membrane surface
    Most problematic and difficult fouling type
    Even 99.9% bacterial removal → survivors colonize
    Biofilm protects bacteria from biocides
    Signs: pressure drop increase, normalized flux decline
    Prevention: chlorination → dechlorination, biocide dosing

  3. Organic Fouling:
    Natural Organic Matter (NOM), humic acids, proteins
    Sources: surface water, wastewater, biological treatment
    Measured by: TOC, UV254 absorbance
    Prevention: coagulation, activated carbon, NF pretreatment

  4. Scaling (Inorganic Fouling):
    Precipitation of sparite minerals on membrane surface
    Common scalants:
      CaCO₃ (calcium carbonate) — most common
      CaSO₄ (calcium sulfate / gypsum)
      BaSO₄ (barium sulfate)
      SiO₂  (silica) — very difficult to remove
      CaF₂  (calcium fluoride)
    Prevention: antiscalant dosing, acid injection, limit recovery

Fouling Indicators:
  Normalized permeate flow:    declining → fouling
  Normalized salt passage:     increasing → membrane damage
  Feed-concentrate ΔP:         increasing → channel blockage
  Normalize all data to standard temperature (25°C reference)

Cleaning Procedures:
  Frequency: when flux drops 10-15% or ΔP increases 15%
  
  Alkaline clean (pH 11-12):
    NaOH + surfactant (sodium dodecyl sulfate)
    Removes: biofouling, organic fouling
    Temperature: 35°C (max 45°C for TFC)
    Contact time: 1-4 hours
  
  Acid clean (pH 2-3):
    HCl or citric acid
    Removes: CaCO₃ scaling, metal oxides
    Temperature: 25-35°C
    Contact time: 1-2 hours
  
  Cleaning order: typically alkaline first, then acid
  Always flush with permeate between chemical steps
  
  CIP (Clean-In-Place): recirculate cleaning solution
  through membrane array without removing elements
EOF
}

cmd_pretreatment() {
    cat << 'EOF'
=== Pretreatment Systems ===

Purpose: protect RO membranes from fouling and damage
"The success of an RO system is 90% pretreatment"

Conventional Pretreatment:
  1. Screening/Straining:
     Remove large debris, marine life (intake)
     Bar screens (25mm), traveling screens (3mm)
     
  2. Coagulation/Flocculation:
     Add coagulant (FeCl₃ or alum) to aggregate colloids
     Dose: 1-20 mg/L depending on raw water quality
     Rapid mix → slow mix (flocculation basin)
     
  3. Clarification:
     Settle flocs in sedimentation basin
     Or: DAF (Dissolved Air Flotation) for algae-rich water
     
  4. Media Filtration:
     Dual media: anthracite + sand (gravity or pressure)
     Removes remaining suspended solids
     Backwash periodically (every 24-48 hours)
     Target: turbidity < 0.5 NTU, SDI < 3

  5. Cartridge Filtration:
     5 μm polypropylene cartridges (final protection)
     Last barrier before high-pressure pump
     Replace when ΔP reaches 1.5-2.5 bar

Membrane Pretreatment (UF/MF):
  Ultrafiltration replaces steps 2-4 above
  Pore size: 0.01-0.1 μm (absolute barrier)
  Consistent permeate quality regardless of feed variation
  
  Advantages over conventional:
    - Guaranteed SDI < 2.5 (usually < 2.0)
    - Smaller footprint (60-70% less space)
    - Automated operation
    - Better removal of bacteria and viruses
  
  Disadvantages:
    - Higher capital cost for membranes
    - UF membrane replacement (5-7 year life)
    - Backwash waste stream management

Chemical Dosing:
  Antiscalant:
    Prevents scale formation on membrane surface
    Dose: 2-5 mg/L (phosphonate or polymer-based)
    Must be compatible with membrane and water chemistry
    
  Acid (H₂SO₄ or HCl):
    Lower pH to prevent CaCO₃ scaling
    Target pH: 6.5-7.0 for seawater
    Calculate Langelier Saturation Index (LSI)
    LSI < 0 → water is undersaturated (safe)
    
  Sodium bisulfite (NaHSO₃):
    Reduce residual chlorine (protects polyamide TFC)
    Dose: 3× stoichiometric of residual chlorine
    Target: < 0.02 ppm free chlorine at RO feed

  Biocide:
    DBNPA (intermittent, 10-20 ppm, 30 min)
    Chloramine (continuous, 2-3 ppm, CTA only)
    UV disinfection: non-chemical alternative
EOF
}

cmd_energy() {
    cat << 'EOF'
=== Energy Analysis ===

Thermodynamic Minimum Energy:
  Minimum energy to separate salt from water
  At 0% recovery: ~1.06 kWh/m³ (seawater, 35 g/L, 25°C)
  At 50% recovery: ~1.56 kWh/m³
  Real systems: 3-5 kWh/m³ (2-3× theoretical minimum)

Specific Energy Consumption (SEC):
  SEC = Energy consumed / Volume of permeate produced
  Units: kWh/m³

  Typical SEC values:
    Technology                   SEC (kWh/m³)
    ──────────────────────────────────────────────
    SWRO (no ERD):               6-8
    SWRO (with turbocharger):    4-5
    SWRO (with PX ERD):          2.5-3.5
    BWRO:                        0.5-2.5
    UF pretreatment:             0.05-0.2
    Total SWRO plant:            3.5-5.5 (incl pretreat, post)

  SEC depends on:
    Feed salinity (higher → more energy)
    Recovery rate (higher → diminishing returns)
    Temperature (warmer → lower viscosity → less pressure)
    Membrane age (fouled → more pressure needed)
    ERD efficiency

Energy Recovery Devices Compared:
  Device              Efficiency    Capacity         Cost
  ─────────────────────────────────────────────────────────
  PX (Pressure Exchanger)  95-98%  Large (>1000 m³/d)  High
  Turbocharger          75-85%  Medium                  Medium
  Pelton turbine        80-90%  Any size                Low
  DWEER                 95-97%  Large                   High
  
  Energy saved by ERD: 2-3 kWh/m³ for seawater RO
  Without ERD: ~70% of energy goes to waste in concentrate

Renewable Energy Integration:
  Solar-powered RO:
    PV + batteries or direct DC coupling
    Variable output → need buffer or flexible operation
    Off-grid: common for small brackish water systems
    Grid-connected: PV reduces electricity cost
    
  Wind-powered RO:
    Variable power → batch or flexible operation
    Best for coastal sites (wind + seawater available)
    
  Hybrid: solar + wind + diesel backup
    Most common for remote off-grid desalination
    Batteries or water storage as buffer

  Salinity gradient energy (osmotic power):
    Mix fresh river water with seawater through membrane
    Generates ~0.7 kWh/m³ of river water
    PRO (Pressure-Retarded Osmosis) technology
    Still largely experimental
EOF
}

cmd_forward() {
    cat << 'EOF'
=== Forward Osmosis & Emerging Technologies ===

Forward Osmosis (FO):
  Uses osmotic pressure difference (no hydraulic pressure needed)
  
  Draw solution (high osmotic pressure) pulls water through membrane
  Feed → [Membrane] ← Draw Solution
  Water moves from feed to draw solution naturally
  
  Draw solution must then be regenerated (separate water from draw)
  
  Draw Solutes:
    NaCl: simple, but hard to separate from product water
    NH₃/CO₂: thermally decomposable at 60°C (innovative)
    MgCl₂: high osmotic pressure, easier to reconcentrate
    Glucose/sucrose: food industry applications
    Magnetic nanoparticles: separable by magnetic field
  
  Advantages:
    Low/no hydraulic pressure (less energy for pumping)
    Lower fouling propensity (no pressure compaction)
    Can treat high-salinity feeds (brine concentration)
  
  Challenges:
    Draw solution regeneration (often needs RO anyway!)
    Internal concentration polarization in membranes
    Lower flux than RO
    Draw solute reverse diffusion (contaminates feed)

  Applications:
    Emergency water treatment (no pressure needed)
    Osmotic dilution before RO (reduces RO energy)
    Food concentration (preserves flavors)
    Fertigation (fertilizer as draw solution → irrigation)

Pressure-Retarded Osmosis (PRO):
  Harvest energy from salinity gradients
  River water + seawater → osmotic power
  Water from river permeates into pressurized seawater
  Pressurized permeate drives turbine → electricity
  
  Theoretical: ~0.7 kWh/m³ of river water
  Practical: 0.1-0.3 kWh/m³ (membrane limitations)
  Statkraft (Norway): first prototype (2009), discontinued (2014)
  Challenge: membrane cost vs energy value

Electrodialysis (ED):
  Ion-exchange membranes + electric field
  Alternating cation/anion membranes
  Electric field pulls ions through selective membranes
  
  Advantages over RO:
    Selective ion removal
    No high pressure needed
    Handles high-salinity better
    Membranes last 10+ years
  
  Applications: brackish water, salt production, food processing

Membrane Distillation (MD):
  Hydrophobic membrane + temperature difference
  Hot feed → water vapor passes through membrane → cold permeate
  100% salt rejection (theoretically)
  Uses low-grade heat (solar thermal, waste heat)
  Not yet widely commercialized

Capacitive Deionization (CDI):
  Electrodes adsorb ions when charged, release when discharged
  Low energy for low-salinity water (<3,000 ppm)
  Emerging for brackish water treatment
  Intercalation electrodes improve capacity
EOF
}

show_help() {
    cat << EOF
osmosis v$VERSION — Membrane Separation Technology Reference

Usage: script.sh <command>

Commands:
  intro        Osmosis overview — osmotic pressure, membrane spectrum
  reverse      Reverse osmosis process, design, and operation
  membranes    Membrane types: TFC, CTA, hollow fiber, spiral wound
  desalination Desalination engineering — SWRO, BWRO, energy recovery
  fouling      Membrane fouling types, detection, and cleaning
  pretreatment Pretreatment systems — conventional and membrane
  energy       Energy analysis — SEC, ERD, renewable integration
  forward      Forward osmosis and emerging membrane technologies
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    reverse)      cmd_reverse ;;
    membranes)    cmd_membranes ;;
    desalination) cmd_desalination ;;
    fouling)      cmd_fouling ;;
    pretreatment) cmd_pretreatment ;;
    energy)       cmd_energy ;;
    forward)      cmd_forward ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "osmosis v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
