#!/usr/bin/env bash
# phosphate — Phosphorus Fertilizer Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Phosphorus in Agriculture ===

Phosphorus (P) is one of the three primary macronutrients (N-P-K)
essential for plant growth. It cannot be substituted by any other
element — plants must have P to complete their life cycle.

Roles in Plants:
  Energy transfer:    ATP and ADP (cellular energy currency)
  DNA/RNA:            Backbone of genetic material
  Cell membranes:     Phospholipid bilayers
  Root development:   Stimulates early root growth
  Flowering/fruiting: Promotes reproductive development
  Seed formation:     High P content in seeds
  Photosynthesis:     Part of energy capture cycle

Phosphorus Cycle:
  Rock phosphate (geological) →
    Mining/weathering →
      Fertilizer/soil →
        Plant uptake (H2PO4⁻, HPO4²⁻) →
          Harvest removal / organic return →
            Soil organic P → mineralization → available P
                          → fixation → unavailable P
                          → runoff/erosion → water bodies

Global Reserves:
  Total reserves: ~70 billion tonnes (USGS estimate)
  Major producers:
    China:          ~85 Mt/year (largest producer)
    Morocco:        ~40 Mt/year (largest reserves: 50B tonnes)
    United States:  ~22 Mt/year (Florida, Idaho, Utah)
    Russia:         ~14 Mt/year
    Jordan:         ~9 Mt/year
  "Peak phosphorus": estimated 50-100 years at current extraction
  No synthetic alternative — P must be mined or recycled

Phosphorus vs Phosphate:
  Phosphorus (P):    The element
  Phosphate (PO4):   The ion (P bound to oxygen)
  P2O5:              Phosphorus pentoxide (fertilizer standard)
  Conversion:        P × 2.29 = P2O5    |    P2O5 × 0.44 = P

Deficiency Symptoms:
  - Purple/reddish leaves (anthocyanin accumulation)
  - Stunted growth (small plants)
  - Delayed maturity
  - Poor root development
  - Reduced tillering in cereals
  - Low seed set
  Most visible in young plants and cool soil conditions
EOF
}

cmd_products() {
    cat << 'EOF'
=== Phosphate Fertilizer Products ===

Product               Formula         N-P2O5-K2O    P2O5%
MAP (Mono-ammonium)   NH4H2PO4       11-52-0       52%
DAP (Di-ammonium)     (NH4)2HPO4     18-46-0       46%
TSP (Triple Super)    Ca(H2PO4)2     0-46-0        46%
SSP (Single Super)    Ca(H2PO4)2+    0-20-0        20%
                      CaSO4
Rock Phosphate        Ca3(PO4)2      0-30-0*       30%*
Bone Meal             Ca3(PO4)2      3-15-0        15%
Ammonium Polyphosphate NH4 poly-P    10-34-0       34%

* Rock phosphate: total P, only 2-3% available in neutral/alkaline soil

MAP (Monoammonium Phosphate):
  Most common phosphate fertilizer worldwide
  Granular, excellent handling properties
  Slightly acidic reaction in soil (pH effect: acidifying)
  Good for banding (starter fertilizer)
  Dissolves readily in soil moisture

DAP (Diammonium Phosphate):
  Second most common globally
  Higher N content than MAP (18% vs 11%)
  Alkaline initial reaction (pH ~8 at dissolution zone)
  Can cause seedling ammonia injury if placed too close
  Preferred for broadcast applications

TSP (Triple Superphosphate):
  No nitrogen — pure P source
  Good when N not needed but P is
  Made from rock phosphate + phosphoric acid
  Water-soluble, fast-acting

SSP (Single Superphosphate):
  Contains calcium and sulfur (bonus nutrients)
  Lower P concentration = higher transport cost per unit P
  Good for S-deficient soils
  Made from rock phosphate + sulfuric acid

Liquid Phosphate:
  Ammonium polyphosphate (10-34-0): fluid fertilizer
  Compatible with UAN (32-0-0) for blending
  Used in starter/popup fertilizers
  Excellent for fertigation and foliar application
  Polyphosphate hydrolyzes to orthophosphate in soil

Organic Phosphate Sources:
  Bone meal:     3-15-0 (slow release, needs acidic soil)
  Compost:       variable (typically 0.5-1% P)
  Manure:        varies widely — test before applying
  Biosolids:     1-3% P (sewage sludge, regulated)
  Fish meal:     4-7% P2O5
  Guano:         variable, up to 30% P2O5 (historical)
EOF
}

cmd_soiltest() {
    cat << 'EOF'
=== Soil Phosphorus Testing ===

Common Extraction Methods:

Bray P1 (Bray-Kurtz):
  Extractant: 0.025N HCl + 0.03N NH4F
  Best for: acid to neutral soils (pH < 7.2)
  Not valid for: alkaline soils (dissolves calcium phosphate → overestimates)
  Most common in US Midwest

Olsen (Sodium Bicarbonate):
  Extractant: 0.5M NaHCO3 at pH 8.5
  Best for: alkaline soils (pH > 7.0)
  Also works for acid soils
  Universal — used worldwide (especially arid regions)

Mehlich 3:
  Extractant: acetic acid + NH4NO3 + NH4F + HNO3 + EDTA
  Multi-element extraction (P, K, Ca, Mg, micronutrients)
  Works across wide pH range
  Increasingly preferred for efficiency (one test, many nutrients)

Interpretation (ppm or mg/kg):

  Category     Bray P1    Olsen    Mehlich 3    Action
  Very Low      <5         <3       <12         Heavy P needed
  Low           5-15       3-7      12-20       Build P level
  Medium        16-25      8-14     21-30       Maintenance
  High          26-50      15-25    31-50       Reduce/skip P
  Very High     >50        >25      >50         No P needed

Sampling Protocol:
  1. Sample 0-6 inches (15 cm) depth for P
  2. Collect 15-20 cores per field (zigzag pattern)
  3. Mix cores into composite sample
  4. Avoid recent fertilizer bands, field edges, dead furrows
  5. Sample every 2-4 years (P changes slowly)
  6. Sample same time of year for consistency
  7. For precision: grid sample at 2.5-acre cells

Soil P Buildup:
  To raise soil test P by 1 ppm:
    Approximately 10-20 lb P2O5/acre needed (varies by soil type)
  Clay soils: higher fixation → more P needed to raise test
  Sandy soils: lower fixation → less P needed but higher loss risk
  Maintenance: replace P removed by crop harvest

Critical Level Concept:
  Below critical level: strong yield response to P
  At critical level: 95% of maximum yield
  Above critical level: diminishing returns
  Way above: no response, environmental risk, waste of money
EOF
}

cmd_placement() {
    cat << 'EOF'
=== Phosphorus Application Methods ===

Broadcast:
  Spread uniformly across entire field surface
  Incorporate by tillage (P doesn't move much in soil)
  Best for: building soil P levels, high P rates
  When: pre-plant or fall application
  Efficiency: lower than banding (more soil contact = more fixation)

Band/Starter:
  Place P in concentrated band near seed
  2" beside and 2" below seed (2×2 placement)
  Or in-furrow (with seed — low rates only!)
  Best for: low-P soils, cold soils, early season boost
  Efficiency: 2-4× more efficient than broadcast per unit P
  Warning: in-furrow rate max 5-10 lb P2O5/acre (salt injury)

Deep Band:
  Place P at 6-8" depth (chisel/knife injection)
  Benefits: accessible during dry topsoil conditions
  Reduced runoff risk (below surface)
  Common in no-till systems

Foliar:
  Spray liquid P on leaves (emergency correction)
  Low rates only: 2-5 lb P2O5/acre per application
  Uptake limited — leaves not primary P absorption organ
  Use: supplement, not replacement for soil P

Fertigation:
  Apply liquid P through irrigation system
  Requires water-soluble products (polyphosphate, phosphoric acid)
  Good for: drip irrigation, high-value crops
  Caution: phosphoric acid can clog emitters if Ca is high

Timing:
  Pre-plant (fall or spring): most common
  At planting (starter): highest efficiency per unit
  In-season (top-dress): limited for P (low mobility)
  Split application: generally not needed (P is immobile)

No-Till Considerations:
  P stratifies at surface without tillage
  Top 2" may test very high, below 4" may test low
  Solutions:
    - Deep banding every 2-3 years
    - Subsurface placement at planting
    - Accept some stratification (roots near surface anyway)

Phosphorus Placement Comparison:
  Method      Efficiency   Cost    Best Use
  Broadcast   Low-Med      Low     Building soil P
  2×2 band    High         Medium  Low-P soils, cold soils
  In-furrow   Very High    Medium  Starter, small amounts
  Deep band   High         High    No-till, dry climates
  Foliar      Very Low     High    Emergency only
EOF
}

cmd_crops() {
    cat << 'EOF'
=== Crop Phosphorus Requirements ===

Phosphorus Removal in Harvested Crop:
  Crop            Yield Unit    P2O5 Removal (lb/unit)
  Corn (grain)    1 bushel      0.37
  Soybean         1 bushel      0.75
  Wheat           1 bushel      0.50
  Rice            1 cwt         0.27
  Cotton (lint)   1 bale        13.0
  Alfalfa hay     1 ton         12.0
  Corn silage     1 ton         3.5
  Potato          1 cwt         0.18
  Tomato          1 ton         0.5
  Apple           1 ton         0.5

Example — Corn at 200 bu/acre:
  Removal = 200 × 0.37 = 74 lb P2O5/acre removed in grain
  Maintenance rate: apply ≥74 lb P2O5/acre to maintain soil test

Crop Sensitivity to P:
  Very responsive:     corn, potato, sugar beet, alfalfa
  Moderately responsive: soybean, wheat, canola
  Less responsive:     barley, oats (efficient P scavengers)
  Very high demand:    potato (weak root system, high removal)

Phosphorus Uptake Timing:
  Corn:    60% of P taken up by silking (V12-R1)
  Soybean: peak uptake R3-R5 (pod fill)
  Wheat:   most P taken up by heading
  Key: P must be available EARLY — roots need it from day 1

Phosphorus and Crop Quality:
  Sugar beet:  excess P reduces sugar content
  Potato:      P improves tuber set and early bulking
  Grain crops: P affects grain test weight and protein (indirect)
  Fruit:       P promotes flowering and fruit set
  Forage:      P affects stand persistence (alfalfa especially)

Cover Crop P Cycling:
  Cover crops take up residual P, prevent loss
  When terminated, P returns to soil surface
  Best P-scavenging covers: buckwheat, brassicas
  Mycorrhizal covers: improve P access for following cash crop
EOF
}

cmd_cycling() {
    cat << 'EOF'
=== Phosphorus Cycling in Soil ===

Soil Phosphorus Pools:
  Solution P:     0.01-1 ppm (immediately plant-available)
  Labile P:       readily exchangeable with solution (days-weeks)
  Non-labile P:   slowly exchangeable (months-years)
  Mineral P:      bound to Ca, Fe, Al minerals (very slow release)
  Organic P:      30-65% of total P in many soils

Phosphorus Fixation:
  Definition: conversion of soluble P to insoluble forms
  pH effect on fixation:
    pH < 5.5:  P fixed by Fe and Al oxides (most severe)
    pH 6.0-7.0: LEAST fixation (optimal range)
    pH > 7.5:  P fixed by calcium (calcium phosphate precipitation)

  Fixation factors:
    - Soil pH (strongest factor)
    - Clay content (more clay = more fixation sites)
    - Organic matter (competes for fixation sites — helps P)
    - Fe/Al oxide content (tropical soils fix heavily)
    - Time (newly applied P more available than aged P)

Mycorrhizal Association:
  70-80% of plant species form arbuscular mycorrhizal (AM) relationships
  Fungal hyphae extend root exploration volume 10-100×
  AM fungi access P from smaller pores and greater distances
  Non-mycorrhizal crops: brassicas, beets, spinach (need more P)
  Mycorrhizal crops: corn, wheat, soybean, potato

  Promoting mycorrhizae:
    - Reduce tillage (hyphal network preserved)
    - Reduce high-P fertilizer rates (fungi less active when P abundant)
    - Use mycorrhizal cover crops in rotation
    - Avoid long fallow (fungi die without host roots)

Mineralization / Immobilization:
  Organic P → Inorganic P (mineralization): C:P ratio < 200
  Inorganic P → Organic P (immobilization): C:P ratio > 300
  Most crop residues have C:P 200-300 (near equilibrium)
  Manure additions stimulate mineralization (low C:P)
  Temperature and moisture drive microbial activity

Phosphorus Movement:
  Extremely immobile in soil (moves <1 inch per year)
  Diffusion is primary uptake mechanism (not mass flow)
  Roots must grow TO the phosphorus
  Band placement: concentrates P where roots are developing
  Leaching: rare except in sandy soils with very high P
EOF
}

cmd_environmental() {
    cat << 'EOF'
=== Environmental Phosphorus Management ===

Eutrophication:
  Excess P in surface water → algal blooms →
  oxygen depletion → fish kills → dead zones
  P is the limiting nutrient in most freshwater systems
  As little as 0.02 ppm P can trigger algal growth
  Examples: Lake Erie, Gulf of Mexico, Chesapeake Bay

Phosphorus Loss Pathways:
  1. Surface runoff (attached to sediment particles)
  2. Dissolved P in runoff water (most bioavailable)
  3. Erosion (major P transport mechanism)
  4. Tile drainage (subsurface, dissolved P — growing concern)
  5. Wind erosion of P-rich topsoil

Phosphorus Index (PI):
  Risk assessment tool rating field vulnerability to P loss
  Factors:
    Source: soil test P level, P application rate, method
    Transport: erosion rate, runoff, proximity to water, slope
  Rating: Low / Medium / High / Very High
  High/Very High: no additional P allowed until risk reduced

4R Nutrient Stewardship:
  Right Source:  Match P form to crop/soil need
  Right Rate:    Based on soil test and crop removal
  Right Time:    When crop can use it (not fall on frozen ground)
  Right Place:   Incorporate or band (not surface-applied before rain)

Best Management Practices (BMPs):
  1. Soil test regularly — don't over-apply
  2. Incorporate broadcast P within 24 hours
  3. No surface P application on frozen or saturated soil
  4. Maintain >30 feet vegetated buffer along waterways
  5. Use cover crops to hold soil and cycle P
  6. Reduce erosion: no-till, terraces, contour farming
  7. Manage manure P: test, calibrate, and apply at agronomic rates
  8. Consider P drawdown if soil test P is excessive

Manure P Management:
  Problem: manure applied at N rates often over-applies P
  Corn needs 150 lb N, gets enough P from ~3-4 tons manure
  But 6-8 tons applied for N needs → 2× P needed
  Solution: supplement manure with commercial N, apply manure at P rate
  Manure nutrient content varies — always lab-test before applying

Phosphorus Recycling:
  Struvite recovery: precipitate P from wastewater as fertilizer
  Manure processing: concentrate P for targeted application
  Biochar: can capture and slowly release P
  Urban waste: potential P source (food waste, biosolids)
  Goal: close the P cycle — from linear mining to circular economy
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Phosphorus Management Checklist ===

Soil Testing:
  [ ] Soil sampled within last 3 years (0-6" depth)
  [ ] Appropriate test method for soil pH (Bray/Olsen/Mehlich)
  [ ] Soil test P interpreted correctly for local guidelines
  [ ] Field mapped by soil test P level (precision if possible)

Fertilizer Planning:
  [ ] Crop P removal calculated for expected yield
  [ ] Build/maintain/drawdown strategy determined
  [ ] P source selected (MAP, DAP, TSP, manure, etc.)
  [ ] P rate calculated: maintenance + any build-up needed
  [ ] Application method chosen (broadcast, band, starter)
  [ ] P2O5 to product conversion correct
  [ ] Manure P credited (if applying manure)

Application:
  [ ] Equipment calibrated for target rate
  [ ] Timing appropriate (not on frozen/saturated soil)
  [ ] Broadcast P incorporated within 24 hours
  [ ] Starter P placed correctly (2×2 or safe in-furrow rate)
  [ ] Setback from waterways maintained (30+ feet)
  [ ] Manure applied at P-based rate (not just N-based)

Environmental:
  [ ] Phosphorus Index assessed for sensitive fields
  [ ] Buffers established along water bodies
  [ ] Erosion control practices in place
  [ ] No P applied on snow-covered or frozen ground
  [ ] Cover crops planned for erosion-prone fields
  [ ] Nutrient management plan filed (if required)

Record-Keeping:
  [ ] P application date, rate, source, method recorded
  [ ] Soil test results filed
  [ ] Yield data collected for removal calculations
  [ ] Manure analysis on file (if using manure)
  [ ] 4R documentation maintained for compliance
EOF
}

show_help() {
    cat << EOF
phosphate v$VERSION — Phosphorus Fertilizer Reference

Usage: script.sh <command>

Commands:
  intro          Phosphorus role, cycling, global reserves
  products       MAP, DAP, TSP, rock phosphate, organics
  soiltest       Bray, Olsen, Mehlich tests and interpretation
  placement      Broadcast, band, starter, foliar methods
  crops          Crop P requirements and removal rates
  cycling        Fixation, pH effects, mycorrhizae
  environmental  Runoff, P index, eutrophication, 4R
  checklist      Phosphorus management planning checklist
  help           Show this help
  version        Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)         cmd_intro ;;
    products)      cmd_products ;;
    soiltest)      cmd_soiltest ;;
    placement)     cmd_placement ;;
    crops)         cmd_crops ;;
    cycling)       cmd_cycling ;;
    environmental) cmd_environmental ;;
    checklist)     cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "phosphate v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
