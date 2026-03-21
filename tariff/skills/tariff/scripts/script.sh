#!/usr/bin/env bash
# tariff — International Trade Tariff Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Tariffs — Overview ===

A tariff is a tax imposed by a government on imported or exported goods.
Tariffs are the primary instrument of trade policy worldwide.

Purpose:
  Revenue        Generate government income (historically primary)
  Protection     Shield domestic industries from foreign competition
  Retaliation    Respond to unfair trade practices
  Negotiation    Leverage in trade agreement negotiations
  National Security  Protect strategic industries

Key Organizations:
  WTO    World Trade Organization — sets global trade rules
  WCO    World Customs Organization — manages HS nomenclature
  CBP    U.S. Customs and Border Protection — enforces U.S. tariffs
  USITC  U.S. International Trade Commission — maintains HTS

Key Documents:
  Harmonized System (HS)     International 6-digit classification
  HTS (U.S.)                 Harmonized Tariff Schedule (10-digit)
  TARIC (EU)                 EU integrated tariff (10-digit)
  Customs Tariff (China)     8-10 digit classification

Tariff vs Duty vs Tax:
  Tariff    The schedule/rate applied to goods
  Duty      The actual amount owed (tariff × value)
  Tax       Broader term; tariffs are a type of tax

Global Trends:
  1947    GATT established — average tariffs ~22%
  1994    WTO replaces GATT
  2000s   Average global tariffs ~5%
  2018+   U.S.-China trade war, tariffs resurge
  2020s   Supply chain reshoring, strategic tariffs

Tariff Impact:
  Importers    Pay duty at point of entry (pass to consumers)
  Consumers    Higher prices for imported goods
  Domestic industry    Protected from cheaper imports
  Government   Revenue (U.S. collected ~$80B/year pre-2018)
  Trade partners    May retaliate with counter-tariffs
EOF
}

cmd_hscode() {
    cat << 'EOF'
=== Harmonized System (HS) Codes ===

The HS is an international standardized system of names and
numbers to classify traded products. Maintained by the WCO.

Structure:
  XX          Chapter (2 digits)     97 chapters
  XXXX        Heading (4 digits)     ~1,200 headings
  XXXXXX      Subheading (6 digits)  ~5,000 subheadings
  XXXXXXXX+   National (8-10 digits) Country-specific detail

Example: 6109.10.0012
  61          Chapter: Knitted or crocheted garments
  6109        Heading: T-shirts, singlets, tank tops
  6109.10     Subheading: Of cotton
  6109.10.00  U.S. HTS: Cotton T-shirts
  6109.10.0012  Statistical suffix: Men's, knit

Classification Rules (General Rules of Interpretation — GRI):

GRI 1: Classify by heading terms and section/chapter notes
  → Always start here. Most goods classified at this level.

GRI 2(a): Incomplete/unfinished articles classified as complete
  if they have the essential character of the complete article
GRI 2(b): Mixtures of materials — classify by essential character

GRI 3: When goods classifiable under two or more headings:
  (a) Most specific heading prevails
  (b) Mixtures/composites — essential character determines
  (c) Last in numerical order prevails (tie-breaker)

GRI 4: Goods not classifiable above → most analogous heading

GRI 5: Cases, containers, packing materials:
  (a) Specially shaped containers classified with contents
  (b) Packing materials classified with contents (unless reusable)

GRI 6: Classification within a heading follows the same rules

Key Chapter Examples:
  01-05     Live animals, animal products
  06-14     Vegetable products
  15        Animal/vegetable fats and oils
  16-24     Prepared foodstuffs, beverages, tobacco
  25-27     Mineral products
  28-38     Chemical products
  39-40     Plastics and rubber
  44-49     Wood, paper products
  50-63     Textiles and apparel
  72-83     Base metals
  84-85     Machinery and electrical equipment
  87        Vehicles
  90        Optical and measuring instruments
  95        Toys and games
  97        Works of art
EOF
}

cmd_valuation() {
    cat << 'EOF'
=== Customs Valuation ===

Customs value determines the base amount on which duties are calculated.
Based on WTO Customs Valuation Agreement (Article VII of GATT).

6 Methods (applied in order — use first applicable):

Method 1: Transaction Value (most common — ~95% of imports)
  Price actually paid or payable for goods when sold for export
  
  Includes (added to price):
    - Commissions and brokerage (except buying commissions)
    - Cost of containers and packing
    - Assists (materials/tools provided to seller free/reduced)
    - Royalties and license fees related to the goods
    - Proceeds of resale accruing to seller
    - Freight and insurance to port of entry (CIF countries)
  
  Excludes (if separately identified):
    - Post-importation transport costs
    - Construction/assembly after import
    - Duties and taxes in the importing country
    - Buying commissions
  
  Cannot use if:
    - Buyer and seller are related (unless price unaffected)
    - Restrictions on disposition of goods
    - Price subject to conditions that can't be valued
    - Resale proceeds not determinable

Method 2: Transaction Value of Identical Goods
  Value of identical goods sold for export at same time
  Same country of origin, same commercial level, same quantity
  Adjustments allowed for transport costs

Method 3: Transaction Value of Similar Goods
  Like Method 2 but for "similar" (not identical) goods
  Same function, commercially interchangeable

Method 4: Deductive Value
  Start from selling price in importing country
  Deduct: profit, transport, duties, commissions
  Work backward to arrive at import value

Method 5: Computed Value
  Build up from cost of production
  Add: materials, fabrication, profit, general expenses
  Rarely used (requires foreign producer cooperation)

Method 6: Fallback Method
  Flexible application of Methods 1-5
  Cannot be based on: domestic market price, higher of two values,
  price in export country, arbitrary or fictitious values

Transfer Pricing:
  Related-party transactions (parent company → subsidiary)
  Must demonstrate arm's length pricing
  Customs value must reflect open market value
  Advance Pricing Agreement (APA) can provide certainty
EOF
}

cmd_agreements() {
    cat << 'EOF'
=== Trade Agreements ===

Most Favored Nation (MFN):
  WTO principle: treat all trading partners equally
  The "normal" tariff rate applied to WTO members
  Also called "Normal Trade Relations" (NTR) in U.S.
  Column 1 General rates in U.S. HTS

Free Trade Agreements (FTAs):
  Reduce or eliminate tariffs between member countries
  Require Rules of Origin compliance
  
  Major U.S. FTAs:
    USMCA (2020)     United States, Mexico, Canada
    KORUS (2012)     United States, South Korea
    CAFTA-DR (2006)  Central America + Dominican Republic
    Australia (2005) U.S.-Australia FTA
    Singapore (2004) U.S.-Singapore FTA
    Israel (1985)    U.S.-Israel FTA

  Major Global FTAs:
    EU Single Market    27 EU member states (zero internal tariffs)
    RCEP (2022)         15 Asia-Pacific nations (largest by GDP)
    CPTPP (2018)        11 Pacific Rim countries
    AfCFTA (2021)       54 African countries
    Mercosur            Brazil, Argentina, Uruguay, Paraguay

Generalized System of Preferences (GSP):
  Developed countries grant preferential (lower) tariffs to
  developing countries — unilateral, non-reciprocal
  U.S. GSP: ~120 beneficiary countries, ~3,500 products
  Products enter duty-free if:
    - Country is eligible beneficiary
    - Product is on GSP list
    - Rules of origin met (35% value added in beneficiary country)
    - Competitive need limits not exceeded

Rules of Origin:
  Determine where a product is "from" for tariff purposes
  Types:
    Wholly Obtained:  Grown, mined, or made entirely in one country
    Substantial Transformation:  Product fundamentally changed
    Tariff Shift:     HS code changes through processing
    Regional Value Content:  Minimum % of value from FTA region
  
  Example (USMCA auto):
    75% Regional Value Content required
    70% steel and aluminum from North America
    $16/hour labor value content requirement

Column Rates (U.S. HTS):
  Column 1 General    MFN/NTR rate (most countries)
  Column 1 Special    Preferential rate (FTAs, GSP)
  Column 2           Non-MFN rate (very high, few countries)
  Currently Column 2: Cuba, North Korea, Russia, Belarus
EOF
}

cmd_duties() {
    cat << 'EOF'
=== Types of Duties ===

Ad Valorem Duty:
  Calculated as percentage of customs value
  Example: 5% ad valorem on goods valued at $10,000 = $500 duty
  Most common type globally
  Advantage: Adjusts with price changes

Specific Duty:
  Fixed amount per unit (weight, volume, quantity)
  Example: $0.05 per kilogram, $2.00 per dozen
  Advantage: Easy to administer
  Disadvantage: Doesn't adjust with inflation/price

Compound Duty:
  Combination of ad valorem + specific
  Example: 10% ad valorem + $0.50/kg
  Common for agricultural products

Tariff Rate Quota (TRQ):
  Lower rate up to a quota, higher rate beyond
  Example: Sugar TRQ
    In-quota: 0.625¢/lb (first 1.5M tons)
    Over-quota: 15.36¢/lb
  Purpose: Allow some imports at low cost, protect beyond

Anti-Dumping Duties (ADD):
  Applied when foreign goods sold below fair market value
  Calculation: fair value - export price = dumping margin
  Example: Chinese steel dumped at 30% below fair value → 30% ADD
  Process: Petition → investigation → preliminary → final order
  Duration: 5-year sunset reviews

Countervailing Duties (CVD):
  Applied when foreign government subsidizes exports
  Offsets the subsidy amount
  Examples of subsidies: tax breaks, cheap loans, grants
  Often applied alongside anti-dumping duties

Section 301 Duties (U.S.):
  Imposed in response to unfair trade practices
  2018-present: 25% on $250B of Chinese goods
  Additional lists at 7.5% and 25% rates
  Exclusion process available (product-specific)

Section 232 Duties (U.S.):
  National security tariffs
  25% on steel imports (2018)
  10% on aluminum imports (2018)
  Some countries exempted via quota agreements

Safeguard Duties:
  Temporary duties to protect domestic industry from import surge
  WTO allows under specific conditions
  Must prove: increased imports → serious injury to domestic industry
  Time-limited (4 years, extendable to 8)
EOF
}

cmd_compliance() {
    cat << 'EOF'
=== Trade Compliance ===

Record Keeping (U.S. — 19 USC § 1508):
  Required records to retain for 5 years:
    - Entry documents (CF 7501, commercial invoice)
    - Customs broker powers of attorney
    - Purchase orders and contracts
    - Shipping documents (B/L, packing lists)
    - Payment records
    - Correspondence related to imports
    - Country of origin documentation
    - FTA certificates of origin
  Penalties for failure: $10,000-$100,000 per violation

Reasonable Care Standard (19 USC § 1484):
  Importers must exercise "reasonable care" in:
    - Classifying goods (correct HS/HTS code)
    - Declaring value (customs valuation)
    - Stating country of origin
    - Claiming FTA benefits
    - Marking requirements
  CBP evaluates based on complexity and importer's resources

Penalties:
  Negligence:         0-4x revenue loss (duties owed)
  Gross Negligence:   4x-8x revenue loss  
  Fraud:              Full domestic value of goods + criminal prosecution
  Marking violations: 10% of value + seizure risk
  
  Prior Disclosure:
    Self-reporting violations before CBP discovers them
    Reduces penalties significantly (interest only in some cases)
    Must be complete and detailed disclosure

Focused Assessment (CBP Audit):
  Pre-Assessment Survey:  CBP evaluates importer's internal controls
  Focused Assessment:     Detailed audit of specific areas
  Common audit triggers:
    - High import volume
    - Pattern of incorrect classifications
    - Related-party transactions
    - Prior violations
    - Random selection

C-TPAT (Customs-Trade Partnership Against Terrorism):
  Voluntary program for supply chain security
  Benefits: Reduced inspections, faster processing, priority access
  Tiers: 1 (certified), 2 (validated), 3 (partners)
  Members: importers, carriers, brokers, manufacturers

Forced Labor / Import Restrictions:
  19 USC § 1307 — Goods made with forced labor prohibited
  UFLPA (2022): Presumption that goods from Xinjiang use forced labor
  Must demonstrate supply chain due diligence
  CBP can detain and seize suspected goods (WRO — Withhold Release Order)
EOF
}

cmd_examples() {
    cat << 'EOF'
=== Tariff Calculation Examples ===

--- Basic Ad Valorem Calculation ---
Product: Cotton T-shirts from Vietnam
HTS: 6109.10.0012
Duty Rate: 16.5% ad valorem
Transaction Value: $50,000 (FOB)
Freight to U.S.: $2,000
Insurance: $500
Customs Value: $50,000 (U.S. uses FOB, not CIF)
Duty: $50,000 × 16.5% = $8,250

--- Specific Duty Calculation ---
Product: Sugar (raw cane)
HTS: 1701.14.10
Duty Rate: 1.4606¢/kg (in-quota)
Weight: 20,000 kg
Duty: 20,000 × $0.014606 = $292.12

--- Compound Duty ---
Product: Swiss wristwatches
HTS: 9101.11.40
Duty Rate: 3.1% + $5.40 each
Value: $100,000 (500 watches)
Duty: ($100,000 × 3.1%) + (500 × $5.40)
     = $3,100 + $2,700 = $5,800

--- FTA Preferential Rate ---
Product: Auto parts from Mexico (USMCA)
HTS: 8708.29.5060
MFN Rate: 2.5%
USMCA Rate: Free (0%)
Customs Value: $200,000
MFN Duty: $200,000 × 2.5% = $5,000
USMCA Duty: $0
Savings: $5,000 (must have valid certificate of origin)

--- Section 301 Additional Duty ---
Product: Electronics from China
HTS: 8471.30.0100
MFN Rate: 0% (free)
Section 301 List 3: 25%
Customs Value: $1,000,000
Normal Duty: $0
Section 301: $1,000,000 × 25% = $250,000
Total Duty: $250,000

--- Anti-Dumping + CVD ---
Product: Steel pipes from Country X
HTS: 7306.30.5028
MFN Rate: 0%
ADD Rate: 35.81%
CVD Rate: 12.44%
Customs Value: $500,000
MFN Duty: $0
ADD: $500,000 × 35.81% = $179,050
CVD: $500,000 × 12.44% = $62,200
Total: $241,250 (48.25% effective rate)
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Import/Export Tariff Compliance Checklist ===

Pre-Import:
  [ ] Product correctly classified (HTS code verified)
  [ ] Binding ruling obtained for complex classifications
  [ ] Customs value properly determined
  [ ] Country of origin established
  [ ] Check for applicable FTA preferential rates
  [ ] Verify FTA certificate of origin requirements
  [ ] Check for ADD/CVD orders on product/country
  [ ] Verify no import prohibitions or restrictions
  [ ] Licensed customs broker engaged
  [ ] Import bond in place (continuous or single entry)

Documentation:
  [ ] Commercial invoice with required elements
  [ ] Packing list with weights and dimensions
  [ ] Bill of lading or airway bill
  [ ] Certificate of origin (if claiming FTA)
  [ ] Import permits/licenses (if required)
  [ ] FDA/EPA/CPSC/FCC clearances (if applicable)
  [ ] Country of origin marking compliant
  [ ] ISF (10+2) filed 24 hours before vessel loading

Duty Calculation:
  [ ] Correct duty rate applied (MFN, special, column 2)
  [ ] Proper valuation method used
  [ ] Assists and royalties included in value
  [ ] Related-party pricing documented
  [ ] ADD/CVD deposits calculated
  [ ] Section 301/232 duties included
  [ ] MPF and HMF calculated

Post-Entry:
  [ ] Entry documents filed within 15 days of arrival
  [ ] Duties paid within 10 working days of entry
  [ ] Records retained for 5 years minimum
  [ ] Reconciliation filed if required
  [ ] Monitor for liquidation (usually within 314 days)
  [ ] Review for refund opportunities (unused merchandise drawback)
  [ ] Periodic internal audit of import compliance
EOF
}

show_help() {
    cat << EOF
tariff v$VERSION — International Trade Tariff Reference

Usage: script.sh <command>

Commands:
  intro        Tariffs overview — purpose, types, impact
  hscode       HS code structure and classification rules (GRI)
  valuation    Customs valuation — 6 methods
  agreements   Trade agreements — FTAs, GSP, MFN rates
  duties       Duty types — ad valorem, ADD, CVD, 301, 232
  compliance   Trade compliance — records, penalties, audits
  examples     Tariff calculation examples
  checklist    Import/export compliance checklist
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    hscode)     cmd_hscode ;;
    valuation)  cmd_valuation ;;
    agreements) cmd_agreements ;;
    duties)     cmd_duties ;;
    compliance) cmd_compliance ;;
    examples)   cmd_examples ;;
    checklist)  cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "tariff v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
