#!/usr/bin/env bash
# photovoltaic — Solar PV Technology Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Photovoltaic Technology ===

Photovoltaic (PV) cells convert sunlight directly into electricity
using the photovoltaic effect discovered by Edmond Becquerel in 1839.

Physics of PV Cells:
  1. Photon absorption: sunlight photons enter semiconductor
  2. Electron-hole pair generation: photon energy > bandgap → free electron
  3. Charge separation: built-in electric field at p-n junction
  4. Current flow: electrons flow through external circuit → electricity

Key Physics:
  Bandgap (Eg): minimum photon energy to create electron-hole pair
    Silicon: 1.12 eV
    Photons with energy < Eg → pass through (not absorbed)
    Photons with energy > Eg → excess energy becomes heat
    Optimal bandgap: ~1.1-1.5 eV (Shockley-Queisser limit)

  Shockley-Queisser Limit:
    Maximum theoretical efficiency for single-junction cell
    ~33.7% at 1.34 eV bandgap under AM1.5 sunlight
    Silicon (1.12 eV): ~32% theoretical max
    Actual record: 26.8% (crystalline Si, heterojunction)

Standard Test Conditions (STC):
  Irradiance: 1000 W/m²
  Cell temperature: 25°C
  Air Mass: AM1.5 (spectrum at 48.2° zenith angle)
  
  NOCT (Nominal Operating Cell Temperature):
    Irradiance: 800 W/m², ambient: 20°C, wind: 1 m/s
    Typical NOCT: 42-48°C
    More realistic than STC for real-world performance

Solar Resource:
  Peak Sun Hours (PSH): equivalent hours of 1000 W/m² per day
    Sahara desert:       6-7 PSH
    Southern California: 5-6 PSH
    Central Europe:      2.5-3.5 PSH
    Northern China:      4-5 PSH
    Tropical regions:    4-5.5 PSH
  
  Annual irradiation (kWh/m²/year):
    Best sites: 2200-2500 (desert, tropics)
    Good sites: 1500-2000 (southern US, Mediterranean)
    Moderate: 1000-1500 (central Europe, northern China)
    Low: 700-1000 (northern Europe, maritime climate)

History:
  1839   Becquerel discovers photovoltaic effect
  1954   Bell Labs creates first practical Si cell (6%)
  1958   Vanguard I satellite uses solar cells
  1970s  Energy crisis drives terrestrial PV research
  2000s  Grid parity approached in sunny regions
  2020s  PV cheapest electricity source in most of world
  2024   Global installed PV: ~1,600 GW
EOF
}

cmd_cells() {
    cat << 'EOF'
=== Solar Cell Technologies ===

Monocrystalline Silicon (mono-Si):
  Single crystal structure, uniform black appearance
  Efficiency: 20-24% (commercial), 26.8% (record)
  Market share: ~80% (dominant technology)
  
  Manufacturing: Czochralski (CZ) process
    Melt polysilicon at 1425°C, pull single crystal ingot
    Slice into wafers: 150-180 μm thick
    
  Variants:
    PERC (Passivated Emitter and Rear Cell): standard now
    TOPCon (Tunnel Oxide Passivated Contact): emerging, ~25%
    HJT (Heterojunction): highest efficiency, ~25.5%
    IBC (Interdigitated Back Contact): all contacts on back, ~25%

Polycrystalline Silicon (poly-Si):
  Multiple crystal grains, blue speckled appearance
  Efficiency: 17-20% (lower than mono)
  Cost: slightly lower than mono
  Market share: declining (mono-Si cost advantage closed)
  Manufacturing: cast ingot (simpler, cheaper than CZ)

Thin-Film Technologies:
  CdTe (Cadmium Telluride):
    Efficiency: 18-22%, record 22.1%
    Manufacturer: First Solar (dominant)
    Bandgap: 1.5 eV (near optimal)
    Advantage: low cost, good in hot climates, low temp coefficient
    Concern: cadmium toxicity (contained, recyclable)
    
  CIGS (Copper Indium Gallium Selenide):
    Efficiency: 17-21%, record 23.6%
    Flexible substrates possible
    Limited commercial availability
    
  Amorphous Silicon (a-Si):
    Efficiency: 7-12%
    Very cheap, flexible, transparent possible
    Used in: calculators, building-integrated PV (BIPV)
    Staebler-Wronski effect: efficiency degrades 10-15% initially

Perovskite:
  ABX₃ crystal structure (e.g., CH₃NH₃PbI₃)
  Efficiency: 26.1% (lab record, single junction)
  Tandem with Si: 33.9% (record, perovskite-on-Si)
  
  Advantages: cheap materials, solution-processable, tunable bandgap
  Challenges: long-term stability, lead toxicity, encapsulation
  Timeline: commercial products emerging (2025+)

Bifacial Modules:
  Absorb light from both front and rear sides
  Rear gain: 5-30% additional energy (ground albedo dependent)
  Best with: white/reflective ground, elevated mounting
  Glass-glass construction (more durable)
  Becoming industry standard for utility-scale
EOF
}

cmd_modules() {
    cat << 'EOF'
=== PV Module Construction ===

Module Structure (front to back):
  1. Front glass: 3.2mm tempered, low-iron, anti-reflective coating
  2. Front encapsulant: EVA or POE (0.5mm)
  3. Solar cells: interconnected with ribbons
  4. Rear encapsulant: EVA or POE (0.5mm)
  5. Backsheet: polymer (TPT/TPE) or rear glass (bifacial)
  6. Frame: anodized aluminum (optional for frameless)
  7. Junction box: diodes and connectors on rear

Cell Interconnection:
  Cells connected in series by metallic ribbons (copper, tinned)
  Typical module: 60-cell (6×10) or 72-cell (6×12)
  Modern trend: larger wafers (M10: 182mm, M12/G12: 210mm)
  Module power: 400-700W+ (utility modules)

Half-Cut Cells:
  Standard cells laser-cut in half → lower current per string
  Benefits:
    - 50% lower resistive losses (I²R, half the current)
    - Better shade tolerance (upper and lower halves independent)
    - 2-3% higher module power output
    - Reduced hot spot risk
  Now standard in modern modules

Bypass Diodes:
  Typically 3 diodes per module (one per ~20 cells)
  Function: allow current to bypass shaded cell substrings
  Prevent: hot spots, reverse bias damage
  Located in junction box on module rear

Module Electrical Specifications (typical 400W mono):
  Pmax:   400 W (STC)
  Vmp:    34.0 V
  Imp:    11.76 A
  Voc:    41.2 V
  Isc:    12.54 A
  FF:     0.776
  Efficiency: 20.5%
  Temp coefficient Pmax: -0.35%/°C
  Temp coefficient Voc: -0.27%/°C
  NOCT: 45°C

Durability:
  Design life: 25-30 years
  Warranty: 25-year performance (≥80.7% of rated power)
  Certification: IEC 61215 (design), IEC 61730 (safety)
  
  Testing:
    Thermal cycling: -40°C to +85°C, 200 cycles
    Humidity freeze: 85°C/85%RH, 1000 hours
    Mechanical load: 5400 Pa front, 2400 Pa rear
    Hail: 25mm ice ball at 23 m/s

  Degradation:
    Year 1: 1-3% (LID — Light Induced Degradation)
    Subsequent: 0.3-0.5% per year (average)
    Total 25-year: ~85% of initial power
EOF
}

cmd_inverters() {
    cat << 'EOF'
=== Inverter Technologies ===

Function: Convert DC from panels to AC for grid or loads
Also: MPPT, monitoring, protection, grid interaction

String Inverter:
  One inverter per string of panels (5-12kW residential, up to 350kW commercial)
  1-2 MPPT inputs
  
  Pros: cost-effective, simple, high efficiency (97-98.5%)
  Cons: entire string affected by weakest panel
  Best for: unshaded roofs, uniform orientation
  
  Brands: Fronius, SMA, GoodWe, Sungrow, Huawei

Microinverter:
  One inverter per panel (250-500W)
  Panel-level MPPT and monitoring
  
  Pros: optimal per-panel production, shade tolerant
        no DC wiring (safer), easy expansion
  Cons: higher cost per watt, more components to fail
        harder to service (on roof), lower efficiency per unit
  Best for: complex roofs, partial shading, small systems
  
  Brands: Enphase (dominant), APsystems, Hoymiles

Central Inverter:
  Large single inverter for entire array (100kW-5MW+)
  Used in utility-scale solar farms
  
  Pros: lowest cost per watt, highest efficiency, easy maintenance
  Cons: single point of failure, less MPPT flexibility
  Best for: large ground-mount, uniform arrays

Hybrid Inverter:
  Combines PV inverter + battery inverter + charger
  Single unit manages: solar, battery, grid, backup loads
  
  Features:
    - Grid-tied with battery backup
    - Self-consumption optimization
    - Time-of-use shifting
    - Off-grid capable
  
  Brands: SolarEdge, Growatt, Victron, Deye, Goodwe

Grid-Following vs Grid-Forming:
  Grid-following (traditional):
    Requires grid voltage/frequency reference
    Shuts down when grid is lost (anti-islanding)
    Cannot black-start
    
  Grid-forming (emerging):
    Can create its own voltage/frequency reference
    Can operate islanded (off-grid or backup)
    Can black-start a microgrid
    Required for high-renewable grids (weak grid support)

Inverter Specifications:
  Efficiency:
    Peak: 97-99% (SiC-based inverters)
    European weighted: 95-98%
    CEC weighted: 96-98.5%
    
  MPPT voltage range: typically 200-850V DC
  Max input voltage: 600-1000V DC (residential), 1000-1500V (utility)
  Grid connection: single-phase (residential) or three-phase
  
  Protection:
    Anti-islanding (IEEE 1547, IEC 62116)
    Ground fault detection (GFDI)
    Arc fault detection (AFCI)
    Overvoltage/overcurrent protection
EOF
}

cmd_sizing() {
    cat << 'EOF'
=== PV System Sizing ===

Step 1: Determine Energy Requirement
  Review electricity bills for annual consumption (kWh/year)
  Typical household:
    US:     10,000 kWh/year
    China:  3,000-5,000 kWh/year
    EU:     3,000-4,000 kWh/year
    India:  1,500-2,500 kWh/year
  
  Monthly variation: air conditioning peaks, heating loads

Step 2: Assess Solar Resource
  Peak Sun Hours (PSH) for your location:
    Use: PVGIS, NASA POWER, Meteonorm databases
    Account for: tilt angle, orientation, shading

Step 3: Calculate System Size
  System size (kWp) = Annual energy (kWh) / (PSH × 365 × PR)
  
  PR (Performance Ratio): typically 0.75-0.85
    Accounts for: temperature, wiring, inverter, soiling, mismatch
  
  Example:
    10,000 kWh/year, 4.5 PSH, PR = 0.80
    Size = 10,000 / (4.5 × 365 × 0.80) = 7.6 kWp
    
    At 400W per panel: 7,600 / 400 = 19 panels
    Area: 19 × 1.8 m² ≈ 34 m²

Step 4: String Configuration
  Inverter MPPT voltage window determines string length
  Vmp at coldest temp (highest voltage):
    Vmp_cold = Vmp_stc × [1 + (Tmin - 25) × TkVoc/100]
    Must be < inverter max input voltage
  
  Vmp at hottest temp (lowest voltage):
    Vmp_hot = Vmp_stc × [1 + (Tmax - 25) × TkVoc/100]
    Must be > inverter minimum MPPT voltage
  
  String length: min_panels to max_panels per string

Derating Factors:
  Temperature:           -5 to -15% (hot climates)
  Soiling:              -2 to -5%
  Module mismatch:      -1 to -2%
  Wiring losses:        -1 to -2%
  Inverter efficiency:  -2 to -4%
  Shading:              -0 to -20% (site specific)
  Degradation (year 1): -1 to -3%
  Snow:                 -0 to -10%
  
  Total system loss: typically 15-25%

Tilt and Azimuth:
  Optimal tilt: approximately equal to latitude
    Summer optimization: latitude - 15°
    Winter optimization: latitude + 15°
    Year-round: latitude angle
  
  Azimuth (Northern hemisphere): south-facing (180°) is optimal
    ±30° from south: <5% energy loss
    East or west facing: ~15-20% less than south

  Flat roof: tilt racks at optimal angle
  Pitched roof: typically use roof angle (cost savings)
EOF
}

cmd_mounting() {
    cat << 'EOF'
=== Mounting Systems ===

Rooftop — Pitched Roof:
  Rail-based:
    Aluminum rails attached to roof structure via brackets
    Panels clamp to rails with mid-clamps and end-clamps
    Flashing or standoffs penetrate roof membrane
    Most common residential mounting method
    
  Rail-less:
    Panels attach directly to roof structure
    Fewer components, faster installation
    Limited to certain panel sizes and roof types

  Attachment methods:
    Composition shingles: lag bolts into rafters + flashing
    Metal roof (standing seam): S-5 clamps (no penetrations)
    Tile roof: tile hooks (replace tile, hook into rafter)
    Flat concrete: chemical anchors

Rooftop — Flat Roof:
  Ballasted:
    Heavy blocks (concrete) hold system down
    No roof penetrations (preserves warranty)
    Tilt angle: 5-15° (compromise: energy vs wind load)
    Requires: adequate roof structural capacity
    
  Mechanically attached:
    Bolted to roof structure
    Higher tilt angles possible
    Penetrations require flashing and sealant

Ground-Mount:
  Fixed-tilt:
    Posts driven into ground (pile-driven or helical)
    Or: concrete footings
    Rails support panel table
    Tilt: latitude angle ±15°
    Row spacing: avoid inter-row shading (GCR 0.3-0.5)
    GCR (Ground Coverage Ratio) = panel area / ground area
  
  Tracking Systems:
    Single-axis tracker:
      Rotates east-to-west following sun
      Energy gain: 15-25% over fixed tilt
      Dominant for utility-scale
      Companies: Nextracker, Array Technologies, Soltec
      
    Dual-axis tracker:
      Tracks both azimuth and altitude
      Energy gain: 25-40% over fixed
      Expensive, maintenance-heavy
      Used mainly for CPV (concentrated PV)

Structural Considerations:
  Wind load: design for local wind speed (ASCE 7, Eurocode)
  Snow load: additional weight on panels and structure
  Seismic: earthquake zone requirements
  Corrosion: coastal environments need marine-grade aluminum or steel
  Fire setbacks: clearance from roof edges, ridges, skylights
    California: 3-foot setback from ridge, 18" from edges

Grounding:
  All metal components bonded to ground (NEC, IEC)
  Equipment grounding conductor (EGC)
  Module frame grounding: WEEB clips or copper lugs
  Lightning protection: for exposed or large arrays
EOF
}

cmd_performance() {
    cat << 'EOF'
=== PV Performance Metrics ===

Performance Ratio (PR):
  PR = Actual energy output / Theoretical energy output
  Theoretical = Rated power × Total irradiation / 1000
  
  Typical PR values:
    Excellent: >82%
    Good: 75-82%
    Average: 70-75%
    Poor: <70%
  
  PR accounts for ALL losses except irradiation
  Temperature-corrected PR removes temperature effects

Capacity Utilization Factor (CUF):
  CUF = Annual energy (kWh) / (Rated power × 8760 hours)
  
  Typical values:
    Fixed-tilt, good site: 16-22%
    Single-axis tracking: 20-28%
    Germany: 10-12%
    India: 18-22%
    Middle East: 20-25%

Specific Yield:
  Energy per unit of installed capacity
  kWh/kWp/year
  
  Typical values:
    Desert (tracking): 2000-2400 kWh/kWp
    Southern US/China: 1400-1800 kWh/kWp
    Central Europe: 900-1200 kWh/kWp
    Northern Europe: 700-900 kWh/kWp

Degradation:
  LID (Light Induced Degradation):
    Occurs in first hours of sun exposure
    Mono PERC: 1-2%, resolved with LeTID treatment
    p-type: higher LID than n-type
  
  PID (Potential Induced Degradation):
    High system voltage causes ion migration
    Can reduce power by 30%+ if untreated
    Prevention: proper grounding, PID-resistant cells
    Recovery: reverse polarity treatment at night
  
  Annual degradation:
    Warranty guarantee: ≤0.5%/year
    Actual measured: 0.3-0.8%/year (technology dependent)
    n-type cells: lower degradation than p-type

Monitoring:
  Module-level:
    Microinverters or optimizers report per-panel
    Detect: underperforming panels, shading, damage
    
  String-level:
    String inverter reports per-MPPT input
    Detect: string-level issues, inverter problems
    
  Weather station:
    Pyranometer: measure actual irradiance (W/m²)
    Ambient temperature + module temperature sensors
    Wind speed: affects module cooling
    
  Key alerts:
    PR drop > 5% from baseline → investigate
    Sudden output drop → shading, inverter fault, grid issue
    Gradual decline → soiling, degradation, connection issue

Soiling Analysis:
  Soiling loss: 1-7% annually (climate dependent)
  Rain cleaning: natural in wet climates
  Manual/robot cleaning: arid regions, every 2-4 weeks
  Anti-soiling coatings: hydrophobic, reduce cleaning frequency
EOF
}

cmd_economics() {
    cat << 'EOF'
=== PV Economics ===

LCOE (Levelized Cost of Energy):
  LCOE = Total lifetime cost / Total lifetime energy production
  
  LCOE = (CAPEX × CRF + Annual OPEX) / Annual Energy
  CRF = Capital Recovery Factor = r(1+r)^n / ((1+r)^n - 1)
  r = discount rate, n = system lifetime
  
  Current LCOE (2024, utility-scale):
    Solar PV:    $20-50/MWh (record bids: $10-15/MWh)
    Onshore wind: $25-55/MWh
    Natural gas:  $45-75/MWh
    Coal:         $65-150/MWh
    Nuclear:      $60-120/MWh
  
  Solar PV is now the cheapest new electricity in most regions

Residential Economics:
  System cost (installed, 2024):
    US:     $2.50-3.50/W (before incentives)
    China:  $0.80-1.50/W
    EU:     $1.50-2.50/W
    India:  $0.70-1.20/W
  
  Payback period:
    With net metering + incentives: 4-8 years (US)
    Without incentives: 7-12 years
    Self-consumption heavy: 5-10 years
  
  25-year savings: $20,000-50,000+ (US residential)
  ROI: 10-20% annual (after payback)

Incentive Mechanisms:
  Investment Tax Credit (ITC):
    US: 30% federal tax credit (IRA 2022, through 2032)
    Reduces upfront cost significantly
    
  Feed-in Tariff (FiT):
    Guaranteed price for exported electricity
    Popular in EU, declining as solar reaches grid parity
    Fixed rate for 15-25 years
    
  Net Metering:
    Export surplus to grid, receive credit on bill
    1:1 crediting (retail rate) → best for consumer
    Some regions reducing to wholesale rate (NEM 3.0)
    
  Renewable Energy Certificates (RECs):
    Tradable certificates for each MWh of renewable generation
    Revenue stream for large generators
    
  Power Purchase Agreement (PPA):
    Third party owns system, user buys electricity at fixed rate
    No upfront cost for consumer
    Terms: 15-25 years, fixed or escalating rate

Battery Storage Integration:
  Time-of-use optimization:
    Store solar during day, use during evening peak rates
    Peak rate may be 2-3× off-peak
    
  Self-consumption maximization:
    Typical self-consumption without battery: 30-40%
    With battery: 60-80%
    
  Battery cost (2024):
    Residential: $300-500/kWh installed
    Utility-scale: $150-300/kWh installed
    Declining ~10-15% per year
    
  Virtual Power Plant (VPP):
    Aggregated home batteries managed by utility
    Grid services revenue for homeowner
    Growing model globally
EOF
}

show_help() {
    cat << EOF
photovoltaic v$VERSION — Solar PV Technology Reference

Usage: script.sh <command>

Commands:
  intro        PV overview — photoelectric effect, STC, solar resource
  cells        Cell technologies: mono, poly, thin-film, perovskite
  modules      Module construction: encapsulation, half-cut, specs
  inverters    Inverter types: string, micro, central, hybrid
  sizing       System sizing: load analysis, string config, derating
  mounting     Mounting systems: roof, ground, trackers, structural
  performance  Performance metrics: PR, CUF, degradation, monitoring
  economics    PV economics: LCOE, payback, incentives, storage
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    cells)       cmd_cells ;;
    modules)     cmd_modules ;;
    inverters)   cmd_inverters ;;
    sizing)      cmd_sizing ;;
    mounting)    cmd_mounting ;;
    performance) cmd_performance ;;
    economics)   cmd_economics ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "photovoltaic v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
