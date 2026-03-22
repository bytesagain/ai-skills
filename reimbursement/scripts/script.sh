#!/usr/bin/env bash
# reimbursement — Expense Reimbursement Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Expense Reimbursement Fundamentals ===

Reimbursement is the process of repaying employees for legitimate
business expenses they incur on behalf of the organization.

TYPES OF REIMBURSABLE EXPENSES:
  Travel          Airfare, trains, taxis, ride-shares, mileage
  Lodging         Hotels, Airbnb (with policy limits)
  Meals           Business meals (with per diem or actual cost)
  Transportation  Rental cars, parking, tolls, fuel
  Communication   Phone bills, internet (business portion)
  Professional    Conferences, certifications, training, books
  Office          Supplies, equipment, software licenses
  Client          Entertainment, gifts (with limits)

KEY PRINCIPLES:
  Business Purpose    Expense must have a clear business reason
  Reasonableness      Cost should be reasonable for the situation
  Documentation       Receipts and records must support the claim
  Timeliness          Claims submitted within policy timeframe
  Pre-Approval        Some expenses require advance authorization
  No Personal Benefit Reimbursed expenses shouldn't enrich the employee

ACCOUNTABLE PLAN (IRS Definition — US):
  Three requirements for tax-free reimbursement:
  1. Business connection — expense must be business-related
  2. Adequate accounting — submit receipts within reasonable time
  3. Return excess — give back any overpayment within reasonable time

  If ANY requirement is not met → treated as taxable wages!

REIMBURSEMENT METHODS:
  Actual Cost         Employee pays, submits receipts, gets repaid
  Per Diem            Fixed daily allowance (no receipts for meals)
  Corporate Card      Company pays directly, employee accounts for use
  Stipend/Allowance   Fixed monthly amount (may be taxable)
  Mileage Rate        Fixed rate per mile/km for personal vehicle use
EOF
}

cmd_categories() {
    cat << 'EOF'
=== Expense Categories ===

TRAVEL:
  Airfare              Economy class (business class with pre-approval)
  Rail/Train           Standard class for trips under certain distance
  Ride-share/Taxi      Airport transfers, local business travel
  Mileage              Personal vehicle at standard rate
  Parking              Airport, hotel, client site parking
  Tolls                Highway tolls during business travel
  Baggage fees         Standard checked bag (not excess baggage)

LODGING:
  Hotel                Up to GSA/company rate for the city
  Extended stay        For trips > 5 days (different rates may apply)
  Airbnb/Rental        With pre-approval, within rate limits
  Incidentals          Tips for housekeeping, bellhop

MEALS:
  Business meals       With clients/colleagues, document attendees + purpose
  Travel meals         While on business travel (per diem or actual)
  Team meals           Manager-approved team events
  NOT covered:         Personal meals at home location, alcohol (varies)

  Typical per diem breakdown (US GSA example):
    Breakfast:   $13-$20 (varies by city)
    Lunch:       $15-$25
    Dinner:      $26-$45
    Incidentals: $5

PROFESSIONAL DEVELOPMENT:
  Conferences          Registration, travel, materials
  Certifications       Exam fees, study materials
  Training courses     In-person or online courses
  Books/Subscriptions  Job-related publications
  Professional dues    Association memberships

OFFICE & EQUIPMENT:
  Home office           Desk, chair, monitor (often one-time allowance)
  Software/Tools        Subscriptions for work tools
  Office supplies       Notebooks, pens, printer ink
  Phone/Internet        Business percentage of personal plan

CLIENT EXPENSES:
  Business entertainment  Meals with clients, event tickets
  Client gifts            Within company/IRS limits ($25/person/year IRS)
  Travel for client work  Billed to client or company
EOF
}

cmd_perdiem() {
    cat << 'EOF'
=== Per Diem Rates ===

Per diem (Latin: "per day") — fixed daily allowance for meals
and incidental expenses during business travel.

US — GSA RATES (General Services Administration):
  Website: gsa.gov/travel/plan-book/per-diem-rates
  Updated annually (October 1)

  CONUS (Continental US):
    Standard rate:  $59/day meals + $5 incidentals = $64
    High-cost cities get higher rates:
      New York City:  $79 meals
      San Francisco:  $79 meals
      Washington DC:  $79 meals
      Los Angeles:    $74 meals
      Chicago:        $79 meals

  OCONUS (Outside Continental US):
    Set by Department of Defense
    Website: travel.dod.mil/allowances/per-diem

  Meals breakdown (standard $59):
    Breakfast:  $13  (22%)
    Lunch:      $15  (25%)
    Dinner:     $26  (44%)
    Incidentals: $5  (9%)

FIRST & LAST DAY RULE:
  Travel days get 75% of per diem (not full rate)
  Example: $64 standard → $48 on travel days

CONFERENCE/PROVIDED MEALS:
  If meals are provided (conference lunch, hotel breakfast):
  Deduct that meal from per diem
  Example: Hotel includes breakfast ($13), per diem = $64 - $13 = $51

INTERNATIONAL RATES:
  US: State Department rates (aoprals.state.gov)
  UK: HMRC benchmark rates
  China: Ministry of Finance rates by city tier
  EU: European Commission rates by country

PER DIEM vs ACTUAL COST:
  Per Diem Advantages:
    - No meal receipts needed (simpler)
    - Fixed budget (predictable costs)
    - Employee keeps the difference if frugal
  Actual Cost Advantages:
    - Reimburses true costs in expensive cities
    - No overpayment in cheap locations
    - Better for variable situations

TAX TREATMENT (US):
  Per diem within GSA rates = tax-free (accountable plan)
  Per diem above GSA rates = excess is taxable income
  Self-employed: can deduct actual expenses, not per diem
EOF
}

cmd_receipts() {
    cat << 'EOF'
=== Receipt Requirements ===

WHAT NEEDS A RECEIPT:
  Generally: Any single expense over $25-$75 (varies by policy)
  Always (regardless of amount):
    - Airfare / train tickets
    - Hotel / lodging
    - Rental cars
    - Conference registration
    - Equipment / technology purchases

RECEIPT MUST SHOW:
  1. Vendor name and address
  2. Date of purchase
  3. Itemized list of items/services
  4. Total amount paid
  5. Payment method (card last 4 digits)
  6. For meals: number of attendees, business purpose

ACCEPTABLE RECEIPT FORMATS:
  ✓ Original paper receipt
  ✓ Digital receipt (email confirmation)
  ✓ Photo/scan of receipt (most companies accept now)
  ✓ Credit card statement + vendor confirmation
  ✗ Handwritten notes without vendor documentation
  ✗ "I remember spending about $50"

MISSING RECEIPT AFFIDAVIT:
  When receipt is lost, most companies require:
  - Written statement describing the expense
  - Date, amount, vendor, business purpose
  - Signed by employee
  - Typically limited (e.g., max 3 per quarter, max $75 each)
  - Manager approval required

DIGITAL RECEIPT BEST PRACTICES:
  - Photograph receipts immediately after purchase
  - Use expense app with OCR (Expensify, SAP Concur, Brex)
  - Email receipts auto-forwarded to expense system
  - Keep originals for 7 years (tax audit window)
  - Ensure photos are legible (good lighting, flat, focused)

COMMON REJECTION REASONS:
  - Receipt doesn't match claimed amount
  - Personal items mixed with business expenses
  - Receipt illegible or incomplete
  - Expense outside policy limits
  - Missing business purpose documentation
  - Submitted past deadline
  - Duplicate submission (same receipt, two claims)
EOF
}

cmd_travel() {
    cat << 'EOF'
=== Travel Expense Rules ===

AIRFARE:
  Class policy:
    Economy:          Default for all flights
    Premium Economy:  Flights > 6 hours (with pre-approval)
    Business Class:   Flights > 8-10 hours, VP+ (varies by company)
    First Class:      Rarely approved (CEO/board only at most companies)

  Booking rules:
    - Book 14+ days in advance when possible (cost savings)
    - Use company-preferred booking tool/agency
    - Lowest logical fare within 2 hours of preferred time
    - Non-refundable unless trip is uncertain
    - Personal extensions: OK if flight cost doesn't increase

RENTAL CARS:
  - Mid-size or below (unless group of 3+)
  - Decline rental insurance if company has coverage
  - Refuel before return (avoid inflated fuel charges)
  - Toll transponders: document tolls for reimbursement
  - Personal use during business trip: prorate

MILEAGE REIMBURSEMENT:
  IRS standard rate (2024): $0.67/mile
  Covers: gas, insurance, depreciation, maintenance
  Track: date, destination, purpose, start/end odometer
  Apps: MileIQ, Everlance, TripLog (automatic tracking)
  Commute miles are NOT reimbursable

LODGING:
  - Government/corporate rates preferred
  - Maximum nightly rate based on city (GSA or company schedule)
  - Extended stay discount required for 5+ nights
  - No reimbursement for stays within commuting distance
  - Room service and minibar: generally not covered
  - Laundry: covered for trips of 5+ days
  - Early check-in / late checkout: with justification

GROUND TRANSPORTATION:
  Preferred order (cost-effective):
    1. Public transit / airport shuttle
    2. Ride-share (Uber/Lyft standard, not premium)
    3. Taxi
    4. Rental car (for multiple local trips)
  Surge pricing: document if no alternative available
  Tips: reasonable (15-20%)

INTERNATIONAL TRAVEL:
  - Visa fees and passport expediting: reimbursable
  - Currency exchange fees: reimbursable
  - Travel insurance: company should provide
  - Vaccinations required for travel: reimbursable
  - Phone/data roaming: reasonable business use
EOF
}

cmd_compliance() {
    cat << 'EOF'
=== Tax Compliance ===

US — IRS RULES:

  Accountable Plan (Section 62):
    ✓ Business connection required
    ✓ Adequate accounting within 60 days
    ✓ Return excess reimbursement within 120 days
    = Tax-free to employee, deductible by employer

  Non-Accountable Plan:
    Any plan that doesn't meet all three requirements
    = Taxable wages to employee (W-2 income)
    = Subject to payroll taxes (FICA, FUTA)
    ⚠️ This costs both employer AND employee more

  Business Meal Deduction:
    50% deductible for employer (permanent rule)
    Must document: attendees, business purpose, relationship

  Entertainment:
    NOT deductible after Tax Cuts and Jobs Act (2017)
    No deduction for: golf, sporting events, concerts
    Exception: company-wide events (holiday party = 100%)

  De Minimis Benefits:
    Small, infrequent benefits are tax-free
    Examples: coffee, snacks, occasional meals, small gifts
    No specific dollar limit (IRS says "reasonable")

  Home Office:
    Employees: NO deduction (eliminated 2018-2025)
    Self-employed: can deduct (simplified method: $5/sq ft, max 300 sq ft)
    Employer stipend: must be under accountable plan to be tax-free

RECORD RETENTION:
  IRS: Keep records for 3 years from filing date
  Best practice: Keep for 7 years (covers all audit windows)
  Digital records acceptable if legible and complete

INTERNATIONAL CONSIDERATIONS:
  VAT recovery:    EU/UK purchases may allow VAT refund for business expenses
  Tax treaties:    May affect treatment of cross-border reimbursements
  Transfer pricing: Intercompany reimbursements need arm's-length pricing
  Social security: Per diem may affect social security calculations in some countries
EOF
}

cmd_workflow() {
    cat << 'EOF'
=== Approval Workflows ===

TYPICAL WORKFLOW:
  1. Employee incurs expense
  2. Employee submits report (within 30-60 days)
  3. System auto-checks: receipt attached, within policy, no duplicates
  4. Manager reviews and approves
  5. Finance/AP reviews flagged items
  6. Payment processed (next payroll or direct deposit cycle)

SUBMISSION DEADLINES:
  Best practice: Submit within 30 days of expense
  IRS safe harbor: 60 days for adequate accounting
  Company policy: Often 30-60 days, quarterly at most
  Late submissions: May require VP approval, may be denied

APPROVAL LEVELS (common structure):
  < $100:     Auto-approved (within policy)
  $100-$500:  Direct manager approval
  $500-$2000: Director approval
  $2000+:     VP/Finance approval
  Pre-trip authorization: Required for any trip > $1000 total

EXCEPTION HANDLING:
  Over-limit expenses:
    - Employee explains justification
    - Manager approves with comment
    - Finance reviews in audit sample

  Out-of-policy expenses:
    - Separate approval workflow (skip to higher authority)
    - Must document business necessity
    - Pattern of exceptions → policy review needed

  Disputed charges:
    - Employee provides documentation
    - Finance investigates
    - Resolution within 30 days

COMMON EXPENSE TOOLS:
  SAP Concur       Enterprise-grade, wide adoption
  Expensify        Popular mid-market, good OCR
  Brex             Modern card + expense platform
  Ramp             Cost-saving focused, good controls
  Navan (TripActions)  Travel + expense combined
  Abacus           Real-time expense management
  Certify          Mid-market, Oracle-owned

AUDIT & FRAUD PREVENTION:
  - Random audit of 10-20% of reports
  - Benford's Law analysis for unusual amounts
  - Duplicate receipt detection (hash matching)
  - Weekend/holiday expense flagging
  - Split expense detection ($49 + $49 vs $98 to avoid threshold)
  - Trend analysis (employee X always maxes per diem)
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Reimbursement Policy Design Checklist ===

SCOPE & ELIGIBILITY:
  [ ] Who is covered (FTE, contractors, board members?)
  [ ] Which expenses are reimbursable (categories defined)
  [ ] Which expenses are NOT reimbursable (explicit exclusions)
  [ ] Pre-approval requirements by expense type and amount
  [ ] Policy for family/companion travel

RATES & LIMITS:
  [ ] Per diem rates defined (by city tier or GSA rates)
  [ ] Hotel rate caps by city
  [ ] Airfare class rules by flight duration/seniority
  [ ] Mileage rate defined (IRS or company rate)
  [ ] Meal limits (per person, per meal, with/without clients)
  [ ] Equipment/technology purchase limits
  [ ] Professional development annual budget per employee

DOCUMENTATION:
  [ ] Receipt requirements defined (threshold, what's needed)
  [ ] Digital receipt acceptance policy
  [ ] Missing receipt procedure (affidavit, limits)
  [ ] Business purpose documentation requirements
  [ ] Attendee documentation for meals

PROCESS:
  [ ] Submission deadline (days after expense)
  [ ] Approval chain by amount
  [ ] Reimbursement timeline (days after approval)
  [ ] Payment method (payroll, direct deposit, separate check)
  [ ] Currency conversion policy for international expenses
  [ ] Corporate card reconciliation process

COMPLIANCE:
  [ ] Accountable plan requirements met (IRS)
  [ ] Excess reimbursement return policy
  [ ] Audit sampling rate defined
  [ ] Fraud investigation procedure
  [ ] Policy violation consequences defined
  [ ] Record retention period specified

COMMUNICATION:
  [ ] Policy published and accessible to all employees
  [ ] New hire onboarding includes expense policy
  [ ] Annual policy refresh and communication
  [ ] FAQ document maintained
  [ ] Finance team contact for questions
  [ ] Training for managers on approval responsibilities
EOF
}

show_help() {
    cat << EOF
reimbursement v$VERSION — Expense Reimbursement Reference

Usage: script.sh <command>

Commands:
  intro        Reimbursement fundamentals and key principles
  categories   Expense categories — travel, meals, professional, office
  perdiem      Per diem rates — GSA, CONUS/OCONUS, meal breakdowns
  receipts     Receipt requirements and documentation rules
  travel       Travel expense rules — airfare, rental, mileage, lodging
  compliance   Tax compliance — accountable plans, IRS rules, deductions
  workflow     Approval workflows, tools, and audit procedures
  checklist    Policy design checklist for organizations
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    categories) cmd_categories ;;
    perdiem)    cmd_perdiem ;;
    receipts)   cmd_receipts ;;
    travel)     cmd_travel ;;
    compliance) cmd_compliance ;;
    workflow)   cmd_workflow ;;
    checklist)  cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "reimbursement v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
