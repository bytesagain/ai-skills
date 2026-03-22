#!/usr/bin/env bash
# sku — SKU Management Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== SKU (Stock Keeping Unit) ===

A SKU is a unique alphanumeric code assigned to a product for
inventory tracking and management. Each unique combination of
product attributes gets its own SKU.

Example:
  "Nike Air Max 90, Men's, Size 10, Black" = one SKU
  "Nike Air Max 90, Men's, Size 10, White" = different SKU
  Same shoe, different color = different SKU

SKU vs Other Identifiers:
  SKU     Internal to YOUR business — you define the format
          Different retailers have different SKUs for the same product
  UPC     Universal Product Code — 12 digits, same globally
          Assigned by GS1, printed on product barcode
  EAN     European Article Number — 13 digits, global standard
          UPC is a subset of EAN (add leading 0)
  GTIN    Global Trade Item Number — umbrella for UPC/EAN/ISBN
          14 digits, includes packaging level
  ASIN    Amazon Standard Identification Number — Amazon internal
  MPN     Manufacturer Part Number — assigned by manufacturer

Why SKUs Matter:
  Inventory tracking    Know exactly what you have and where
  Reorder management    Trigger replenishment at right levels
  Sales analysis        Which products sell, which don't
  Warehouse operations  Pick, pack, ship the right item
  Financial reporting   Cost of goods, margin by product

Scale:
  Small retail store:     500-5,000 SKUs
  Department store:       50,000-200,000 SKUs
  Amazon marketplace:     600,000,000+ SKUs
  Walmart stores:         ~120,000 SKUs per store
  Typical grocery store:  30,000-50,000 SKUs
EOF
}

cmd_naming() {
    cat << 'EOF'
=== SKU Naming Conventions ===

--- Good SKU Design Principles ---

1. Human-Readable (partially)
   BAD:  7294832749
   GOOD: SHOE-NKE-AM90-BLK-M10

2. Structured Segments
   Format: CATEGORY-BRAND-MODEL-COLOR-SIZE
   Each segment encodes a meaningful attribute
   Use consistent delimiters (dash preferred)

3. Consistent Length/Format
   All SKUs in same category should follow same pattern
   Easier to validate, sort, and process

4. No Spaces or Special Characters
   Alphanumeric + dash/underscore only
   Spaces cause system issues everywhere

5. Case-Insensitive
   Store uppercase, compare case-insensitively
   Prevents SKU-001 vs sku-001 confusion

--- Encoding Strategies ---

  Significant (Intelligent) SKU:
    BK-OFC-DSK-WAL-72     (Book, Office, Desk, Walnut, 72")
    Encodes product attributes in the code itself
    Pro: humans can read and interpret
    Con: changes in attributes require SKU changes

  Sequential (Dumb) SKU:
    PRD-000001, PRD-000002, PRD-000003
    Simple incrementing number with prefix
    Pro: never runs out, no encoding issues
    Con: tells you nothing about the product

  Hybrid (Recommended):
    FRN-CHAIR-00042
    Category prefix + sequential within category
    Balance of readability and simplicity

--- Anti-Patterns ---

  ✗ Using product name as SKU
    "Nike Air Max 90 Black 10" — spaces, long, inconsistent

  ✗ Reusing SKUs for different products
    Once assigned, a SKU should NEVER be reassigned

  ✗ Starting with zero
    Excel and databases eat leading zeros

  ✗ Encoding volatile attributes
    Don't encode price, supplier, or location in SKU
    These change; the SKU should not

  ✗ Too many segments
    AA-BB-CC-DD-EE-FF-GG-HH → too long, error-prone
    3-5 segments is optimal

  ✗ Using letters that look like numbers
    O vs 0, I vs 1, S vs 5 — avoid ambiguity
    Consider: exclude O, I, S, B, G from alphabetic segments
EOF
}

cmd_hierarchy() {
    cat << 'EOF'
=== Product Hierarchy Design ===

A well-designed product hierarchy enables reporting, merchandising,
and inventory management at every level.

--- Typical Hierarchy ---

  Level 1: Division         (Apparel, Electronics, Home)
  Level 2: Department       (Men's, Women's, Kids)
  Level 3: Category         (Footwear, Tops, Bottoms)
  Level 4: Subcategory      (Running Shoes, Casual Shoes, Boots)
  Level 5: Product Family   (Nike Air Max 90)
  Level 6: SKU (Variant)    (AM90-BLK-M10)

  Example Path:
    Apparel → Men's → Footwear → Running → Nike Air Max 90 → Black/Size 10

--- Attributes vs Hierarchy ---

  Fixed attributes (part of hierarchy):
    Category, subcategory, brand, product family
    Rarely change, define the product's identity

  Variable attributes (NOT in hierarchy):
    Color, size, material, scent
    Create variants (SKUs) within a product family
    Managed as attribute dimensions, not hierarchy levels

  Product Family (Parent):
    Nike Air Max 90 — the abstract "product"
    No inventory at this level — it's a grouping

  SKU (Child/Variant):
    Nike Air Max 90, Black, Size 10 — a purchasable item
    Has inventory, price, barcode

--- Data Model ---

  categories (id, name, parent_id, level)
    Self-referencing tree for n-level hierarchy

  products (id, name, category_id, brand_id, description)
    The product family / parent product

  variants / skus (id, product_id, sku_code, attributes_json)
    Each purchasable combination of attributes
    attributes: {"color": "black", "size": "10"}

  inventory (sku_id, location_id, quantity, reserved)
    Stock tracked at SKU + location level

--- Hierarchy Best Practices ---
  1. Maximum 5-6 levels (deeper = harder to manage)
  2. Each item belongs to exactly one path (no overlapping)
  3. Balanced tree (similar depth across branches)
  4. Consistent attribute dimensions per category
  5. Review and prune annually (dead categories, empty branches)
EOF
}

cmd_barcodes() {
    cat << 'EOF'
=== Barcodes and Product Identifiers ===

--- UPC-A (Universal Product Code) ---
  12 digits: N-MMMMM-IIIII-C
    N:     Number system (0=regular, 2=weighted items, 3=pharma)
    MMMMM: Manufacturer code (assigned by GS1)
    IIIII: Item number (assigned by manufacturer)
    C:     Check digit (modulo 10 algorithm)
  Used: North America retail
  Printed as: 1D barcode (vertical lines)

--- EAN-13 (European Article Number) ---
  13 digits: CC-MMMMM-IIIII-C
    CC: Country code (00-09=US, 40-44=Germany, 49=Japan, 690-695=China)
    Rest: same as UPC
  UPC-A is EAN-13 with leading 0
  Used: worldwide retail

--- GTIN (Global Trade Item Number) ---
  Umbrella system:
    GTIN-8:   EAN-8 (small products)
    GTIN-12:  UPC-A
    GTIN-13:  EAN-13
    GTIN-14:  For cases, pallets (packaging levels)
  In databases: store as 14-digit, left-pad with zeros

--- Check Digit Calculation (Modulo 10) ---
  For UPC/EAN:
  1. Multiply odd-position digits by 3, even by 1 (from right)
  2. Sum all products
  3. Check digit = (10 - sum mod 10) mod 10

  Example: 07123456789?
    0×1 + 7×3 + 1×1 + 2×3 + 3×1 + 4×3 + 5×1 + 6×3 + 7×1 + 8×3 + 9×1
    = 0+21+1+6+3+12+5+18+7+24+9 = 106
    Check = (10 - 106%10) % 10 = (10-6)%10 = 4

--- GS1 Company Prefix ---
  To get UPC/EAN codes:
    Join GS1 ($250/year US for small companies)
    Receive company prefix (6-10 digits)
    Assign remaining digits to your products
    Longer prefix = fewer product numbers available

--- Other Identifiers ---
  ISBN-13:  Books (prefix 978 or 979 + EAN format)
  ISSN:     Serial publications (8 digits)
  ASIN:     Amazon internal (10 alphanumeric characters)
  MPN:      Manufacturer Part Number (no standard format)
  PLU:      Price Look-Up code (4-5 digits, produce items)

--- 2D Barcodes ---
  QR Code:     Up to 4,296 alphanumeric characters
  Data Matrix:  Up to 2,335 alphanumeric characters
  GS1 DataMatrix: replacing linear barcodes in healthcare
  PDF417:      Used for shipping labels, ID cards
EOF
}

cmd_abc() {
    cat << 'EOF'
=== ABC/XYZ Inventory Analysis ===

--- ABC Analysis (Value-Based) ---

Classifies SKUs by their contribution to total revenue or cost.

  Class A: Top 80% of revenue, typically 10-20% of SKUs
    Highest value items — manage tightly
    Frequent cycle counts, accurate forecasts
    Premium warehouse locations (golden zone)

  Class B: Next 15% of revenue, typically 20-30% of SKUs
    Moderate value — standard management
    Regular cycle counts, periodic review

  Class C: Bottom 5% of revenue, typically 50-70% of SKUs
    Low value — simplified management
    Infrequent counts, higher stock levels (carrying cost is low)
    Candidates for rationalization

Calculation:
  1. List all SKUs with annual revenue (units × price)
  2. Sort descending by revenue
  3. Calculate cumulative percentage
  4. Assign: cumulative 0-80% = A, 80-95% = B, 95-100% = C

--- XYZ Analysis (Variability-Based) ---

Classifies SKUs by demand predictability.

  Class X: Stable demand (CV < 0.5)
    Easy to forecast, low safety stock needed
    Examples: staple foods, consumables, utilities

  Class Y: Moderate variability (CV 0.5-1.0)
    Seasonal patterns, moderate forecast accuracy
    Examples: fashion basics, some electronics

  Class Z: Highly variable demand (CV > 1.0)
    Unpredictable, hard to forecast
    Examples: new products, luxury, project-based

  CV = Coefficient of Variation = Standard Deviation / Mean

--- Combined ABC-XYZ Matrix ---

          X (Stable)       Y (Variable)     Z (Unpredictable)
  A       AX: Auto-replenish  AY: Forecast   AZ: Make-to-order
          High value, easy   High value,     High value,
          JIT delivery       safety stock    respond to demand

  B       BX: Standard       BY: Review      BZ: Case-by-case
          reorder point      frequently      evaluate stocking

  C       CX: Min/max        CY: Periodic    CZ: Don't stock
          auto-manage        order           order on demand only

--- Actions by Class ---
  AX: Automate completely, minimize stock, frequent delivery
  AZ: Don't forecast — respond to orders, consider make-to-order
  CX: Set generous min/max, don't waste time optimizing
  CZ: Consider dropping — low value + unpredictable = waste
EOF
}

cmd_lifecycle() {
    cat << 'EOF'
=== SKU Lifecycle Management ===

--- Lifecycle Stages ---

1. Introduction
   New product launched, SKU created
   Tasks:
     - Assign SKU code following naming convention
     - Set up in all systems (ERP, WMS, POS, website)
     - Assign barcode (UPC/EAN if retail)
     - Set initial inventory levels
     - Create product images, descriptions
     - Assign to category hierarchy
     - Set pricing, cost, and margin targets

2. Growth
   Sales increasing, gaining market traction
   Tasks:
     - Expand distribution (more locations)
     - Optimize reorder points based on actual demand
     - Negotiate better supplier pricing at volume
     - Expand variant range if successful (new colors, sizes)

3. Maturity
   Sales stable, well-understood demand patterns
   Tasks:
     - Fine-tune inventory levels (minimize excess)
     - Run promotions to maintain interest
     - Monitor for market shifts
     - Automate replenishment

4. Decline
   Sales dropping, market moving on
   Tasks:
     - Reduce order quantities
     - Consolidate to fewer locations
     - Plan clearance pricing
     - Identify replacement products

5. End of Life (EOL)
   Decision to discontinue
   Tasks:
     - Stop reordering
     - Sell through remaining inventory (markdown strategy)
     - Remove from active catalog/website
     - Archive SKU data (DO NOT delete)
     - Transfer warranty/support obligations
     - Notify affected customers/channels

--- SKU Status Codes ---
  ACTIVE       Available for sale and replenishment
  HOLD         Temporarily blocked (quality issue, legal)
  CLEARANCE    Selling remaining stock, no reorder
  DISCONTINUED Last units being sold, will not return
  ARCHIVED     No longer sold, data retained for history

--- Never Delete a SKU ---
  Why: historical orders reference it, financial records need it,
       returns may arrive years later, warranty claims need lookup
  Instead: mark as ARCHIVED with end date
  Some systems: "soft delete" with is_active flag
EOF
}

cmd_rationalization() {
    cat << 'EOF'
=== SKU Rationalization ===

SKU rationalization is the process of identifying and eliminating
underperforming products to reduce complexity and cost.

--- Why Rationalize ---
  Too many SKUs = higher costs:
    Warehouse space for slow-moving inventory
    More purchase orders, more suppliers to manage
    Demand forecasting harder (diluted across variants)
    Pick complexity increases in warehouse
    Marketing budget spread thin
    Shelf space wasted on non-performers

  Typical findings:
    20% of SKUs generate 80% of revenue (Pareto)
    30-40% of SKUs contribute < 1% each to revenue
    10-15% of SKUs haven't sold in 6+ months

--- Rationalization Criteria ---

  Revenue threshold:
    Drop SKUs with < $X annual revenue
    Typical: bottom 5-10% by revenue contribution

  Velocity threshold:
    Drop SKUs with < N units sold per month
    Consider turns: if turns < 1/year, question it

  Margin threshold:
    Drop SKUs with negative gross margin
    Or gross margin below minimum acceptable (e.g., < 15%)

  Strategic value:
    Some low-revenue SKUs are strategic:
      - Completes a product line (customers expect it)
      - Required by key accounts
      - New product in growth phase
      - Regulatory requirement
    Always check before cutting

--- Rationalization Process ---

  Step 1: Data Analysis
    Pull 12-24 months of sales data by SKU
    Calculate: revenue, margin, turns, velocity
    Run ABC analysis
    Flag: zero-movers, negative margin, declining trend

  Step 2: Cross-Reference
    Check with sales team: "Why do we carry this?"
    Check with key accounts: "Do you need this?"
    Check supplier MOQs: "Can we exit gracefully?"
    Check substitution: "What replaces this?"

  Step 3: Decision
    Cut: remove from catalog, sell through inventory
    Keep: strategic justification documented
    Modify: change pack size, combine variants, re-source

  Step 4: Execute
    Markdown remaining inventory
    Update all systems (ERP, WMS, website, catalogs)
    Notify affected customers/channels
    Set end dates for orders

  Step 5: Monitor
    Track results: did total revenue hold?
    Did margin improve?
    Did warehouse efficiency improve?
    Repeat annually
EOF
}

cmd_metrics() {
    cat << 'EOF'
=== SKU Performance Metrics ===

--- Inventory Turns ---
  Formula: COGS ÷ Average Inventory Value
  Or: Units Sold ÷ Average Units in Stock

  Benchmarks:
    Fast-moving consumer goods:  8-12 turns/year
    Retail (general):            4-6 turns/year
    Industrial/B2B:              3-5 turns/year
    Fashion:                     4-8 turns/year (seasonal)

  Higher turns = healthier inventory (money not sitting on shelves)
  Exception: strategic stock, long lead time items

--- Days of Supply (DOS) ---
  Formula: Current Inventory ÷ Average Daily Demand
  Or: 365 ÷ Inventory Turns

  Example: 500 units in stock, sell 10/day → 50 days of supply
  Target depends on lead time + safety stock requirement

--- Fill Rate ---
  Formula: Orders Fulfilled Complete ÷ Total Orders × 100%

  By SKU: what % of demand was met from stock?
  Target: 95-99% for A items, 90-95% for B, 85-90% for C

  100% fill rate is NOT the goal — cost of last 1% is enormous

--- Stockout Rate ---
  Formula: Days Out of Stock ÷ Total Days × 100%
  Or: Stockout Events ÷ Total Demand Events × 100%

  A items: target < 1% stockout
  C items: target < 5% stockout

--- GMROI (Gross Margin Return on Inventory Investment) ---
  Formula: Gross Margin ÷ Average Inventory Cost

  Example: $50,000 gross margin ÷ $25,000 avg inventory = 2.0
  Interpretation: every $1 in inventory generates $2 in gross margin
  Benchmark: > 3.0 is excellent, < 1.0 is underperforming

--- Velocity ---
  Units sold per time period (day, week, month)
  Used to assign warehouse locations:
    High velocity → pick face, ground level, near shipping
    Low velocity → upper rack, reserve storage

--- Sell-Through Rate ---
  Formula: Units Sold ÷ (Units Sold + Units in Stock) × 100%
  Period: typically monthly or seasonal
  Target: 80%+ by end of season (retail)
  Below 50% → potential markdown/clearance candidate

--- Dead Stock ---
  Inventory with zero sales for 6-12 months
  Industry average: 20-30% of SKUs are dead stock
  Costs: warehousing, insurance, depreciation, opportunity cost
  Action: clearance, donation, recycling, or write-off
EOF
}

show_help() {
    cat << EOF
sku v$VERSION — SKU Management Reference

Usage: script.sh <command>

Commands:
  intro          SKU concepts and relationship to other identifiers
  naming         SKU naming conventions and best practices
  hierarchy      Product hierarchy design and data modeling
  barcodes       UPC, EAN, GTIN, and barcode systems
  abc            ABC/XYZ inventory analysis and classification
  lifecycle      SKU lifecycle from introduction to end-of-life
  rationalization  Identifying and eliminating underperforming SKUs
  metrics        Key performance metrics: turns, fill rate, GMROI
  help           Show this help
  version        Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)            cmd_intro ;;
    naming)           cmd_naming ;;
    hierarchy)        cmd_hierarchy ;;
    barcodes)         cmd_barcodes ;;
    abc)              cmd_abc ;;
    lifecycle)        cmd_lifecycle ;;
    rationalization)  cmd_rationalization ;;
    metrics)          cmd_metrics ;;
    help|--help|-h)   show_help ;;
    version|--version|-v) echo "sku v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
