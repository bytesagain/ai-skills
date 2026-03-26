#!/usr/bin/env bash
# inventory-manager — Inventory Management Reference
set -euo pipefail
VERSION="5.0.0"

cmd_intro() { cat << 'EOF'
# Inventory Management — Overview

## What is Inventory Management?
The practice of tracking, ordering, storing, and using a company's inventory
including raw materials, components, and finished goods.

## Core Concepts
  SKU (Stock Keeping Unit): Unique identifier for each product variant
    Example: TSHRT-BLU-M (T-Shirt, Blue, Medium)
    Convention: CATEGORY-ATTRIBUTE-SIZE or alphanumeric code

  Inventory Valuation Methods:
    FIFO (First In, First Out): Oldest stock sold first
      Best for: Perishables, fashion, most businesses
      Tax effect: Lower COGS in rising price environment

    LIFO (Last In, First Out): Newest stock sold first
      Best for: Tax optimization in inflationary periods
      Note: Banned under IFRS, allowed under US GAAP

    Weighted Average: Total cost / total units
      Best for: Commodities, bulk items, simple tracking
      Formula: (Existing cost + New purchase cost) / Total units

## Inventory Types
  Raw Materials:    Inputs for manufacturing
  Work-in-Progress: Partially completed goods
  Finished Goods:   Ready for sale
  MRO:             Maintenance, Repair, and Operations supplies
  Safety Stock:     Buffer against demand variability
  Dead Stock:       Items that haven't sold (typically >12 months)

## Key Metrics
  Turnover Ratio = COGS / Average Inventory
    Good: 5-10 (depends on industry). Grocery: 14+. Luxury: 2-4.
  Days of Supply = (Average Inventory / COGS) × 365
  Fill Rate = Orders shipped complete / Total orders × 100%
  Stockout Rate = Items out of stock / Total items × 100%
EOF
}

cmd_standards() { cat << 'EOF'
# Inventory Standards & Barcodes

## Barcode Formats
  UPC-A:    12 digits, North America retail standard
            Example: 012345678905 (1 prefix + 5 manufacturer + 5 product + 1 check)
  EAN-13:   13 digits, international standard (superset of UPC)
            Example: 4006381333931
  Code 128:  Variable length, alphanumeric, used in logistics/shipping
  Code 39:   Alphanumeric, used in automotive and defense (MIL-STD-1189)
  QR Code:   2D matrix, up to 7,089 numeric or 4,296 alphanumeric characters
  GS1-128:   Supply chain standard with Application Identifiers
            AI(01) = GTIN, AI(17) = Expiry date, AI(10) = Batch number

## GS1 Standards
  GTIN (Global Trade Item Number): Universal product identification
  GLN (Global Location Number): Identify physical locations
  SSCC (Serial Shipping Container Code): Track logistics units
  GS1 DataMatrix: 2D barcode for healthcare and small items
  EPCIS: Event-based supply chain visibility standard

## Inventory Counting Methods
  Physical Inventory: Count everything, typically annual, operations stop
  Cycle Counting: Count subset daily/weekly, operations continue
    ABC method: Count A items monthly, B quarterly, C annually
  Perpetual Inventory: Real-time tracking via POS/WMS systems
  Spot Check: Random verification of specific items

## WMS (Warehouse Management System) Standards
  OAGIS: Open Applications Group Integration Specification
  GS1 EDI (EDIFACT/EANCOM): Electronic document exchange
  WMOS: Warehouse Management Open Standard
EOF
}

cmd_troubleshooting() { cat << 'EOF'
# Inventory Troubleshooting Guide

## Stock Discrepancy (System vs Physical Count)
  Common causes:
    - Receiving errors (wrong quantity entered)
    - Unrecorded damage/returns/shrinkage
    - Picking errors (wrong item or quantity)
    - System lag (transactions not yet posted)
  Fix process:
    1. Isolate the SKU and freeze transactions
    2. Physical recount by different team
    3. Trace all transactions for last 30 days
    4. Adjust inventory with documented reason code
    5. Root cause analysis to prevent recurrence

## Phantom Inventory (System shows stock, shelf is empty)
  Causes: Theft, unrecorded damage, receiving errors, system bugs
  Impact: Overselling, customer disappointment, lost revenue
  Prevention:
    - Regular cycle counts (top-selling items weekly)
    - Real-time POS deductions
    - RFID tracking for high-value items
    - Security cameras at receiving and storage

## Overstock / Dead Stock
  Signs: Turnover ratio <2, items unsold >6 months
  Solutions:
    - Bundle with popular items
    - Discount clearance (20% → 40% → 70% escalation)
    - Donate for tax write-off
    - Return to supplier (if agreement exists)
    - Liquidation channels (B-stock, outlet stores)
  Prevention: Set par levels, review slow-movers monthly

## Stockouts
  Impact: 21-43% of customers will buy from competitor
  Common causes:
    - Demand spike not forecasted
    - Supplier lead time increase
    - Safety stock too low
    - Reorder point not properly calculated
  Fix: Reorder Point = (Average Daily Demand × Lead Time) + Safety Stock
EOF
}

cmd_performance() { cat << 'EOF'
# Inventory Optimization

## ABC Analysis
  A Items: Top 20% of SKUs = 80% of revenue (tight control)
  B Items: Next 30% of SKUs = 15% of revenue (moderate control)
  C Items: Bottom 50% of SKUs = 5% of revenue (loose control)

  A: Daily review, highest accuracy counts, best shelf location
  B: Weekly review, regular cycle counts
  C: Monthly review, periodic counts, consider discontinuation

## Economic Order Quantity (EOQ)
  Formula: EOQ = √(2DS / H)
    D = Annual demand (units)
    S = Ordering cost per order ($)
    H = Holding cost per unit per year ($)
  Example: D=10000, S=$50, H=$2 → EOQ = √(2×10000×50/2) = 707 units

## Safety Stock Calculation
  Basic: Safety Stock = Z × σ_demand × √(Lead Time)
    Z = Service level factor (1.65 for 95%, 2.33 for 99%)
    σ = Standard deviation of daily demand
  Example: Z=1.65, σ=5, LT=4 days → SS = 1.65 × 5 × 2 = 16.5 ≈ 17 units

## Reorder Point
  ROP = (Average Daily Demand × Lead Time) + Safety Stock
  Example: 50 units/day × 7 days + 17 = 367 units

## Inventory Turnover Targets by Industry
  Grocery/Perishable:  14-20 turns/year
  Fast Fashion:        8-12 turns/year
  Electronics:         6-8 turns/year
  General Retail:      4-6 turns/year
  Industrial/MRO:      2-4 turns/year
  Luxury Goods:        1-3 turns/year

## Demand Forecasting Methods
  Moving Average:      Simple, weights all periods equally
  Exponential Smoothing: Recent data weighted more heavily (α = 0.1-0.3)
  Seasonal Decomposition: Trend + Seasonal + Residual
  Machine Learning:    Random Forest, LSTM for complex patterns
EOF
}

cmd_security() { cat << 'EOF'
# Inventory Security

## Shrinkage Prevention
  Average retail shrinkage: 1.4% of sales (NRF 2023)
  Sources: Employee theft (28%), shoplifting (37%), admin error (21%), vendor fraud (6%)
  Controls:
    - Separation of duties (receiver ≠ counter ≠ adjuster)
    - Cycle counting with variance investigation
    - Security cameras at receiving dock and stockroom
    - Access control: Badge entry for warehouse areas
    - Background checks for warehouse staff
    - POS exception reporting (voids, refunds, discounts)

## Access Control Best Practices
  Role-based access in WMS:
    Viewer:    Read-only inventory reports
    Picker:    View pick lists, confirm picks
    Receiver:  Create receiving records, adjust quantities
    Manager:   Approve adjustments, run reports, set reorder points
    Admin:     User management, system configuration
  Audit trail: Log who changed what, when, and why

## Data Security
  Barcode/RFID data: Don't encode pricing (use lookup tables)
  WMS cloud security: SOC 2 Type II compliance
  API security: Token-based auth, rate limiting, IP allowlists
  Backup: Daily incremental, weekly full, off-site replication

## Physical Security
  Warehouse zones: Locked cages for high-value items
  Key management: Electronic locks with audit trail
  Receiving: Two-person verification for high-value shipments
  Shipping: Weight verification against pick list
  Returns: Separate processing area, inspect before restocking
EOF
}

cmd_migration() { cat << 'EOF'
# Inventory System Migration Guide

## Spreadsheet → WMS Migration
  Phase 1 (Weeks 1-2): Data cleanup
    - Standardize SKU naming convention
    - Remove duplicate entries
    - Verify all quantities with physical count
    - Map spreadsheet columns to WMS fields

  Phase 2 (Weeks 3-4): System setup
    - Configure WMS locations (zones, aisles, bins)
    - Set up user roles and permissions
    - Define workflows (receiving, picking, shipping)
    - Configure barcode/label formats

  Phase 3 (Week 5): Data import
    - Export spreadsheet to CSV
    - Map fields to WMS import format
    - Import in test environment first
    - Verify counts match

  Phase 4 (Week 6): Go-live
    - Freeze spreadsheet updates
    - Final physical count
    - Import final data to production
    - Train all users (2-4 hours per role)
    - Run parallel for 1-2 weeks

## Common WMS Platforms
  Enterprise:  SAP WM, Oracle WMS Cloud, Manhattan Associates
  Mid-market:  Fishbowl, NetSuite WMS, Cin7
  Small:       inFlow, Sortly, Stockpile (free)
  E-commerce:  ShipBob, ShipHero, Skubana
  Open source: Odoo Inventory, ERPNext

## Legacy → Cloud Migration
  Key decisions:
    - Lift-and-shift vs re-implementation
    - Data history: Migrate all or last 2-3 years?
    - Integration points: ERP, POS, e-commerce, 3PL
    - Downtime tolerance: Big bang vs phased rollout
  Timeline: Typically 3-6 months for mid-size operation
EOF
}

cmd_cheatsheet() { cat << 'EOF'
# Inventory Formulas & Quick Reference

## Key Formulas
  Inventory Turnover = COGS / Average Inventory
  Days of Supply = 365 / Inventory Turnover
  Gross Margin ROI = Gross Margin / Average Inventory Cost
  EOQ = √(2 × Demand × Order Cost / Holding Cost)
  Reorder Point = (Daily Demand × Lead Time) + Safety Stock
  Safety Stock = Z × σ_demand × √(Lead Time)
  Fill Rate = (Orders Complete / Total Orders) × 100%
  Carrying Cost = (Holding Cost / Total Inventory Value) × 100%
    Typical carrying cost: 20-30% of inventory value annually

## Service Level Z-Scores
  90% service level → Z = 1.28
  95% service level → Z = 1.65
  97% service level → Z = 1.88
  99% service level → Z = 2.33
  99.9% service level → Z = 3.09

## Barcode Specifications
  UPC-A:      12 digits, 37.29mm × 25.93mm minimum
  EAN-13:     13 digits, 37.29mm × 25.93mm minimum
  Code 128:   Variable, 5.72mm min height
  QR Code:    21×21 to 177×177 modules

## Common Adjustment Reason Codes
  DMG — Damaged goods
  EXP — Expired/obsolete
  RET — Customer return
  SHR — Shrinkage/theft
  CNT — Count adjustment
  RCV — Receiving error correction
  XFR — Transfer between locations

## ABC Classification Rules of Thumb
  A: Top 10-20% SKUs, 60-80% revenue → weekly review
  B: Next 20-30% SKUs, 15-25% revenue → bi-weekly review
  C: Bottom 50-70% SKUs, 5-10% revenue → monthly review
EOF
}

cmd_faq() { cat << 'EOF'
# Inventory Management — FAQ

Q: How often should I do a physical inventory count?
A: Full physical count: At least annually (required for tax purposes).
   Cycle counting is preferred: Count a portion daily/weekly.
   ABC approach: A items monthly, B items quarterly, C items semi-annually.
   Accuracy target: 95%+ for A items, 90%+ for B/C items.

Q: What inventory turnover ratio should I target?
A: Varies widely by industry. General retail: 4-6 turns/year.
   Grocery: 14-20. Electronics: 6-8. Luxury: 1-3.
   Too high = potential stockouts. Too low = excess capital tied up.
   Compare against industry benchmarks, not arbitrary targets.

Q: FIFO or Weighted Average — which is better?
A: FIFO is preferred for most businesses, especially perishables.
   It matches physical flow (sell old stock first).
   Weighted Average is simpler for commodities and bulk items.
   LIFO is rarely used outside US (banned under IFRS).
   Consult your accountant for tax implications.

Q: How do I reduce carrying costs?
A: Carrying costs average 20-30% of inventory value per year.
   Components: Storage (rent), insurance, obsolescence, capital cost.
   Strategies: Reduce lead times, improve demand forecasting,
   implement JIT where possible, negotiate consignment with suppliers,
   liquidate dead stock promptly.

Q: When should I implement a WMS?
A: Consider WMS when: >500 SKUs, >$1M inventory, multiple locations,
   or when spreadsheet errors cause frequent stockouts/overstocks.
   ROI typically achieved within 12-18 months.
   Start with cloud-based (lower upfront cost, faster deployment).

Q: How do I handle seasonal inventory?
A: Pre-season: Build stock 2-3 months ahead based on forecast.
   Peak season: Monitor daily, reorder aggressively for top sellers.
   Post-season: Markdown schedule (week 1: 20%, week 3: 40%, week 6: 70%).
   Off-season: Negotiate storage deals, analyze what sold for next year.
EOF
}

cmd_help() {
    echo "inventory-manager v$VERSION — Inventory Management Reference"
    echo ""
    echo "Usage: inventory-manager <command>"
    echo ""
    echo "Commands:"
    echo "  intro           Inventory concepts, valuation methods, metrics"
    echo "  standards       Barcode formats, GS1 standards, counting methods"
    echo "  troubleshooting Stock discrepancies, phantom inventory, stockouts"
    echo "  performance     ABC analysis, EOQ, safety stock, forecasting"
    echo "  security        Shrinkage prevention, access control, auditing"
    echo "  migration       Spreadsheet→WMS, legacy→cloud migration"
    echo "  cheatsheet      Formulas, Z-scores, barcode specs"
    echo "  faq             Counting frequency, turnover targets, costs"
    echo "  help            Show this help"
}

case "${1:-help}" in
    intro) cmd_intro ;; standards) cmd_standards ;;
    troubleshooting) cmd_troubleshooting ;; performance) cmd_performance ;;
    security) cmd_security ;; migration) cmd_migration ;;
    cheatsheet) cmd_cheatsheet ;; faq) cmd_faq ;;
    help|--help|-h) cmd_help ;;
    *) echo "Unknown: $1"; echo "Run: inventory-manager help" ;;
esac
