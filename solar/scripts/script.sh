#!/usr/bin/env bash
# solar — Solar Energy Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Solar Energy ===

Solar photovoltaic (PV) systems convert sunlight directly into electricity
using the photovoltaic effect, discovered by Edmond Becquerel in 1839.

How PV Works:
  1. Photons from sunlight strike semiconductor material (usually silicon)
  2. Photon energy knocks electrons free from atoms
  3. Built-in electric field pushes electrons through circuit
  4. Electron flow = direct current (DC) electricity
  5. Inverter converts DC → AC for home/grid use

The Solar Spectrum:
  Ultraviolet    < 400nm     ~5% of energy   (too energetic, wasted as heat)
  Visible light  400-700nm   ~43% of energy  (primary conversion range)
  Infrared       > 700nm     ~52% of energy  (mostly wasted as heat)
  Theoretical max efficiency (single junction): 33.7% (Shockley-Queisser limit)

System Components:
  Solar Panels       Convert light → DC electricity
  Inverter           Convert DC → AC (grid-compatible)
  Mounting System    Secure panels to roof/ground
  Wiring & Conduit   Connect components (DC & AC runs)
  Meter / CT         Measure production and consumption
  Battery (optional) Store excess for later use
  Charge Controller  Regulate battery charging (off-grid)

System Types:
  Grid-Tied          Most common. Panels + inverter → grid.
                     Net metering credits excess production.
                     No batteries needed. No power during outage.

  Grid-Tied + Storage Panels + inverter + battery.
                      Backup during outages. Peak shaving.

  Off-Grid            Panels + charge controller + batteries + inverter.
                      Fully independent. Must size for worst month.

  Hybrid              Grid-tied with battery. Intelligent switching
                      between grid, solar, and battery based on rates.

Global Solar Capacity (2024):
  Total installed: ~1,600 GW worldwide
  China: ~600 GW    USA: ~175 GW    EU: ~260 GW
  Annual additions: ~400 GW/year and accelerating
EOF
}

cmd_panels() {
    cat << 'EOF'
=== Solar Panel Technologies ===

--- Monocrystalline Silicon (mono-Si) ---
  Efficiency: 20-24% (commercial panels)
  Appearance: Black cells, uniform color
  Lifespan: 25-30+ years
  Temp coefficient: -0.3 to -0.4%/°C
  Cost: $0.25-0.35/W (module level)
  Best for: Limited roof space (highest efficiency per area)
  Market share: ~80% of new installations

--- Polycrystalline Silicon (poly-Si) ---
  Efficiency: 16-18%
  Appearance: Blue cells, speckled pattern
  Lifespan: 25+ years
  Temp coefficient: -0.4 to -0.5%/°C
  Cost: $0.20-0.30/W
  Best for: Budget installations with ample space
  Market share: Declining, being replaced by mono

--- Thin-Film ---
  Types: CdTe (Cadmium Telluride), CIGS, Amorphous Silicon
  Efficiency: 11-15%
  Appearance: Uniform dark color, flexible options
  Temp coefficient: -0.2%/°C (better in heat)
  Cost: $0.15-0.25/W
  Best for: Large commercial roofs, BIPV, hot climates
  Advantage: Better low-light and partial shade performance

--- Bifacial ---
  Technology: Mono-Si cells on both sides
  Efficiency gain: 5-25% over monofacial (depends on albedo)
  Best ground albedo: White gravel (0.5), snow (0.8), grass (0.2)
  Mounting: Elevated ground mount or trackers
  Premium: ~5-10% over monofacial modules

--- N-Type vs P-Type ---
  P-Type: Traditional. Boron-doped. Susceptible to LID.
  N-Type: Newer. Phosphorus-doped. No LID. Higher efficiency.
  N-Type variants:
    TOPCon   Tunnel Oxide Passivated Contact (24%+ efficiency)
    HJT      Heterojunction (24%+ efficiency, low temp coeff)
    IBC      Interdigitated Back Contact (25%+, no front grid lines)

Panel Specifications to Compare:
  Wattage (Wp)        Peak power under STC (1000 W/m², 25°C)
  Efficiency (%)      Wp / panel area
  Temp coefficient    Power loss per °C above 25°C
  Warranty            Product (10-25yr) + performance (25-30yr)
  Degradation rate    Typically 0.4-0.5%/year
  Dimensions/weight   Affects mounting requirements
EOF
}

cmd_inverters() {
    cat << 'EOF'
=== Inverter Types ===

--- String Inverter ---
  How: All panels in a string connect to one central inverter
  Pros: Lowest cost, simple design, easy maintenance
  Cons: One shaded panel reduces entire string output (MPPT)
  Sizing: Inverter DC input ≥ 80% and ≤ 133% of array Wp
  Best for: Unshaded roofs, uniform orientation
  Brands: Fronius, SMA, Huawei, Sungrow
  Typical lifespan: 10-15 years (usually one replacement over system life)

--- Microinverter ---
  How: One small inverter per panel, converts DC→AC at panel
  Pros: Panel-level MPPT, shade-tolerant, monitoring per panel
  Cons: Higher cost, more failure points (but easier to replace)
  Sizing: Match microinverter VA rating to panel Wp
  Best for: Shaded roofs, complex roof shapes, mixed orientations
  Brands: Enphase (IQ8), APsystems
  Typical lifespan: 25 years (matched to panel warranty)

--- Power Optimizers + String Inverter ---
  How: Optimizer per panel (DC-DC), feeds optimized DC to string inverter
  Pros: Panel-level MPPT + monitoring, string inverter economics
  Cons: More components than pure string, optimizer can fail
  Best for: Partial shading with many panels
  Brands: SolarEdge (optimizers + inverter combo)

--- Hybrid Inverter ---
  How: Combined solar inverter + battery charger/inverter
  Pros: Single unit for solar + storage, grid-forming capability
  Cons: Higher upfront cost, vendor lock-in on battery compatibility
  Best for: New installs planning battery storage
  Brands: SolarEdge, Huawei, Goodwe, Sungrow

MPPT (Maximum Power Point Tracking):
  Every PV array has an optimal voltage/current for max power
  MPPT algorithm continuously adjusts to find this point
  String inverters: 1-3 MPPT inputs
  Microinverters: 1 MPPT per panel (optimal)

Sizing Rules of Thumb:
  DC:AC ratio (inverter loading ratio):
    1.0-1.3 typical for string inverters
    1.2 is common sweet spot (some clipping, better economics)
    Higher ratio = more clipping but better morning/evening production

  String voltage must be within inverter MPPT range:
    V_mpp × panels_in_series = string voltage
    Check at coldest temp (voltage increases when cold)
    Check at hottest temp (voltage decreases when hot)
EOF
}

cmd_sizing() {
    cat << 'EOF'
=== Solar System Sizing ===

Step 1: Determine Energy Need
  Monthly electricity bill → kWh/month
  Annual consumption = sum of 12 months
  Example: 900 kWh/month = 10,800 kWh/year

Step 2: Find Peak Sun Hours (PSH)
  PSH = average daily solar irradiance in kWh/m²/day
  Equivalent to hours of 1000 W/m² sunshine per day
  Examples:
    Phoenix, AZ:     6.5 PSH      Dubai:          5.8 PSH
    Los Angeles, CA:  5.5 PSH      Sydney:         4.7 PSH
    New York, NY:     4.0 PSH      Berlin:         2.8 PSH
    London, UK:       2.7 PSH      Tokyo:          3.8 PSH
  Source: PVWatts, SolarGIS, NASA POWER

Step 3: Calculate System Size
  Daily need = Annual kWh / 365
  System size (kW) = Daily need / PSH / system efficiency
  System efficiency: 0.75-0.85 (accounts for all losses)

  Example:
    10,800 kWh/yr ÷ 365 = 29.6 kWh/day
    29.6 ÷ 5.0 PSH ÷ 0.80 = 7.4 kW system

Step 4: Calculate Number of Panels
  Panels = System kW / Panel Wp × 1000
  Example: 7,400W ÷ 400W panels = 18.5 → 19 panels

Step 5: Check Roof/Ground Area
  Each 400W panel ≈ 1.9m² (2.0m × 0.95m)
  19 panels × 1.9m² = 36.1m² needed
  Add 20% for spacing, setbacks, and obstructions

System Losses Breakdown:
  Temperature loss      5-15%  (hot climates lose more)
  Inverter efficiency   2-4%   (96-98% efficient)
  Wiring (DC + AC)      1-3%
  Soiling/dust          2-5%   (varies by location)
  Shading               0-15%  (site-specific)
  Module mismatch       1-2%
  Degradation           0-0.5%/year
  Total system loss     15-25% typical

Wire Sizing (DC Side):
  Calculate max current: Isc × 1.25 (NEC safety factor)
  Voltage drop target: < 2% (DC), < 2% (AC)
  Use voltage drop calculator or NEC table 310.16
  Common DC wire: 10 AWG for residential runs < 30ft
EOF
}

cmd_mounting() {
    cat << 'EOF'
=== Mounting Systems ===

--- Roof Mount (Most Common Residential) ---
  Types:
    Rail-based    Aluminum rails bolted to rafters, panels clip to rails
    Rail-less     Panels bolt directly to brackets on rafters
    Ballasted     Weighted trays (flat roofs only, no penetrations)

  Roof Requirements:
    Age: < 10 years remaining life (or re-roof first)
    Material: Comp shingle, metal, tile, flat membrane
    Structural load: ~3 lbs/sqft (dead load) — verify with engineer
    Orientation: South-facing ideal (Northern hemisphere)

--- Ground Mount ---
  Types:
    Fixed-tilt     Posts + rails at fixed angle
    Single-axis    Track sun east→west (10-25% more energy)
    Dual-axis      Track sun both axes (25-40% more, expensive)

  Foundation: Driven piles, ground screws, concrete piers
  Clearance: 2-3 ft above ground (snow, vegetation)
  Spacing: Avoid row-to-row shading (rule: 2-3× panel height)

--- Tilt Angle ---
  Rule of thumb: Tilt = latitude for annual optimization
  Winter optimization: Tilt = latitude + 15°
  Summer optimization: Tilt = latitude - 15°
  Flat roofs: 10-15° tilt (self-cleaning, less wind load)

  Latitude examples:
    30°N (Houston)    → 30° tilt optimal
    40°N (New York)   → 40° tilt optimal
    50°N (London)     → 50° tilt optimal

--- Orientation (Azimuth) ---
  Ideal: True south (Northern hemisphere), true north (Southern)
  East/West split: ~15% less annual energy, but flatter production curve
  TOU rate optimization: West-facing may earn more with afternoon peak rates

--- Shading Analysis ---
  Tools: Solar Pathfinder, Suneye, Aurora Solar, Helioscope
  Key concepts:
    Solar window: 9 AM - 3 PM (critical production hours)
    Any shade on one cell affects the entire string (bypass diodes help)
    Use microinverters or optimizers for partially shaded arrays

  Shade sources to check:
    Trees (consider growth over 25 years!)
    Chimneys, vents, satellite dishes
    Neighboring buildings
    Power lines and poles
EOF
}

cmd_storage() {
    cat << 'EOF'
=== Battery Storage ===

--- Lithium-Ion (Most Common) ---
  Chemistry: LFP (LiFePO4) or NMC (Nickel Manganese Cobalt)

  LFP (Lithium Iron Phosphate):
    Cycle life: 6,000-10,000 cycles
    Safety: Excellent (no thermal runaway)
    Energy density: Lower (heavier/bigger)
    Cost: $200-350/kWh installed
    Best for: Daily cycling, long life
    Products: Tesla Powerwall 3, BYD, SimpliPhi

  NMC (Nickel Manganese Cobalt):
    Cycle life: 3,000-5,000 cycles
    Safety: Good (needs BMS management)
    Energy density: Higher (lighter/smaller)
    Cost: $250-400/kWh installed
    Best for: Space-constrained installs
    Products: LG RESU, Sonnen

--- Lead-Acid (Budget / Off-Grid) ---
  Types: Flooded (FLA), AGM, Gel
  Cycle life: 500-1,500 cycles (at 50% DOD)
  Usable capacity: 50% of rated (avoid deep discharge)
  Cost: $100-200/kWh (but more $/cycle due to short life)
  Maintenance: FLA needs watering, AGM/Gel sealed
  Best for: Budget off-grid, backup only

--- Sizing Battery Storage ---
  1. Determine backup needs:
     Essential loads × hours of backup desired
     Example: 5 kW loads × 8 hours = 40 kWh battery

  2. Account for depth of discharge (DOD):
     LFP: 90-100% DOD usable
     Lead-acid: 50% DOD recommended
     Battery size = Energy needed / DOD

  3. Round-trip efficiency:
     LFP: 95%    NMC: 92%    Lead-acid: 80%
     Actual stored energy = input × efficiency

--- Charge Controllers (Off-Grid) ---
  PWM (Pulse Width Modulation):
    Simple, cheap, less efficient
    Panel Vmp must match battery voltage
    Best for: Small systems, budget builds

  MPPT (Maximum Power Point Tracking):
    Converts higher panel voltage to battery voltage
    10-30% more efficient than PWM
    Allows longer wire runs (higher voltage DC)
    Best for: Any system > 200W
EOF
}

cmd_economics() {
    cat << 'EOF'
=== Solar Economics ===

LCOE (Levelized Cost of Energy):
  LCOE = Total lifetime cost / Total lifetime energy produced
  Includes: Equipment, install, maintenance, financing
  Residential solar LCOE: $0.05-0.10/kWh (2024)
  Utility solar LCOE: $0.02-0.05/kWh
  Compare to retail electricity: $0.10-0.40/kWh

Simple Payback Period:
  Payback = Net system cost / Annual electricity savings
  Example:
    System cost: $20,000
    Tax credit (30%): -$6,000
    Net cost: $14,000
    Annual production: 10,000 kWh × $0.15/kWh = $1,500/year
    Payback: $14,000 / $1,500 = 9.3 years

ROI and IRR:
  25-year ROI typically 200-400%
  IRR typically 8-15% (depends on electricity rate escalation)
  Better than most fixed-income investments

Incentives (US-Specific):
  Federal ITC: 30% tax credit (through 2032, steps down after)
  State rebates: Varies ($0-$1/W in some states)
  SREC markets: Sell renewable energy credits ($10-400/MWh)
  Accelerated depreciation: MACRS for commercial (5-year)

Net Metering:
  Full retail: Export credited at retail rate (best)
  Avoided cost: Export credited at wholesale (less valuable)
  Time-of-use: Export value varies by time of day
  Net billing: Instant netting at reduced export rate

  Key: Check your utility's net metering policy first!
  Many utilities are reducing net metering benefits.

Rate Escalation:
  Historical electricity rate increase: 2-4%/year
  Solar production cost: Fixed (no fuel cost escalation)
  The gap widens every year → solar gets more valuable over time

Financing Options:
  Cash purchase:    Best long-term ROI, highest upfront cost
  Solar loan:       Own the system, monthly payments < electric bill
  Lease/PPA:        No upfront cost, lower savings, don't own system
  PACE financing:   Property-assessed, stays with home on sale
EOF
}

cmd_maintenance() {
    cat << 'EOF'
=== Solar O&M (Operations & Maintenance) ===

Annual Maintenance Checklist:
  [ ] Visual inspection of panels (cracks, discoloration, hot spots)
  [ ] Check mounting hardware for corrosion or loosening
  [ ] Inspect wiring and conduit for damage or critter chews
  [ ] Verify inverter operation (error codes, production data)
  [ ] Clean panels if soiled (dust, pollen, bird droppings)
  [ ] Check monitoring system data for anomalies
  [ ] Trim vegetation that may cause new shading
  [ ] Verify grounding connections are intact

Panel Cleaning:
  When: Production drops > 5% compared to expected
  How: Soft brush + water (deionized preferred)
  When NOT to clean: Morning dew often self-cleans
  Frequency: 1-2×/year (dry climates), rarely in rainy areas
  Never: Use abrasives, pressure washers, or harsh chemicals
  Safety: Don't walk on panels, use extension poles from ground

Degradation Rates:
  Year 1: 2-3% (initial light-induced degradation, LID)
  Years 2-25: 0.3-0.5%/year (linear degradation)
  After 25 years: Still producing ~85-90% of original capacity
  LID is lower in N-type panels (~0.5% vs 2-3% for P-type)

Common Faults and Diagnosis:
  Low production          → Shading, soiling, inverter issue
  Inverter error/offline  → Grid fault, overtemp, ground fault
  Single panel low output → Cracked cell, failed bypass diode
  String voltage mismatch → Panel mismatch, connection issue
  Arc fault (AFCI trip)   → Damaged wire, loose connection

Monitoring:
  Panel-level: Enphase Enlighten, SolarEdge monitoring
  Inverter-level: Fronius Solar.web, SMA Sunny Portal
  Independent: Sense, Emporia Vue, IoTaWatt
  Key metrics: Daily kWh, peak kW, performance ratio

Performance Ratio:
  PR = Actual output / Theoretical output
  Theoretical = Irradiance × Array area × Panel efficiency
  Good PR: 75-85%
  Excellent PR: 85%+ (well-designed, minimal losses)
EOF
}

show_help() {
    cat << EOF
solar v$VERSION — Solar Energy Reference

Usage: script.sh <command>

Commands:
  intro        How photovoltaics work, system types, components
  panels       Panel technologies: mono, poly, thin-film, bifacial
  inverters    Inverter types: string, micro, optimizer, hybrid
  sizing       System sizing: load analysis, panel count, wire sizing
  mounting     Mounting: roof, ground, trackers, tilt, shading
  storage      Battery storage: LFP, NMC, lead-acid, sizing
  economics    Financial analysis: LCOE, payback, incentives
  maintenance  O&M: cleaning, monitoring, degradation, faults
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    panels)      cmd_panels ;;
    inverters)   cmd_inverters ;;
    sizing)      cmd_sizing ;;
    mounting)    cmd_mounting ;;
    storage)     cmd_storage ;;
    economics)   cmd_economics ;;
    maintenance) cmd_maintenance ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "solar v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
