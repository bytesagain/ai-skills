#!/usr/bin/env bash
# ledger — Double-Entry Bookkeeping Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Ledger — Double-Entry Bookkeeping ===

A ledger is the principal book of record for financial transactions.
Every business transaction is recorded as a journal entry in the ledger.

The Accounting Equation:
  Assets = Liabilities + Equity

  This MUST always balance. Every transaction affects at least
  two accounts, keeping the equation in balance.

  Expanded form:
  Assets = Liabilities + (Owner's Equity + Revenue - Expenses)

Double-Entry Principle:
  Every transaction has equal debits and credits.

  Debit:   Left side of the account (Dr)
  Credit:  Right side of the account (Cr)

  For EVERY transaction:
    Total Debits = Total Credits

  Example: Buy $1,000 of inventory with cash:
    Debit:  Inventory (Asset ↑)     $1,000
    Credit: Cash (Asset ↓)          $1,000

History:
  1494  Luca Pacioli published "Summa de Arithmetica"
        First systematic description of double-entry bookkeeping
        Venice, Italy — used by merchants for centuries before

Key Terms:
  Journal       Chronological record of all transactions
  Ledger        Organized by account (T-accounts)
  Trial Balance Sum of all debits = sum of all credits
  Posting       Transferring journal entries to ledger accounts

  Fiscal Year   12-month accounting period
  Period Close   Process of finalizing a period's records
  Audit Trail   Complete record of all changes (immutable)

Why Double-Entry:
  1. Self-balancing: errors are detectable (debits ≠ credits)
  2. Complete picture: every transaction's source and destination
  3. Financial statements: directly derivable from ledger
  4. Audit trail: every dollar is tracked
  5. Fraud detection: harder to manipulate balanced books
EOF
}

cmd_accounts() {
    cat << 'EOF'
=== Chart of Accounts ===

The chart of accounts is a structured list of all accounts
used to record transactions.

--- Five Account Types ---

  1. ASSETS (what you own)
     Normal balance: DEBIT
     Debit increases, Credit decreases
     Examples:
       1000  Cash
       1100  Accounts Receivable
       1200  Inventory
       1300  Prepaid Expenses
       1500  Equipment
       1600  Accumulated Depreciation (contra asset, credit normal)

  2. LIABILITIES (what you owe)
     Normal balance: CREDIT
     Credit increases, Debit decreases
     Examples:
       2000  Accounts Payable
       2100  Accrued Expenses
       2200  Unearned Revenue
       2300  Notes Payable
       2500  Long-term Debt

  3. EQUITY (owner's investment + retained earnings)
     Normal balance: CREDIT
     Credit increases, Debit decreases
     Examples:
       3000  Owner's Equity / Common Stock
       3100  Retained Earnings
       3200  Dividends (contra equity, debit normal)

  4. REVENUE (what you earn)
     Normal balance: CREDIT
     Credit increases, Debit decreases
     Examples:
       4000  Sales Revenue
       4100  Service Revenue
       4200  Interest Income
       4900  Returns & Allowances (contra revenue, debit normal)

  5. EXPENSES (what you spend)
     Normal balance: DEBIT
     Debit increases, Credit decreases
     Examples:
       5000  Cost of Goods Sold (COGS)
       5100  Salaries Expense
       5200  Rent Expense
       5300  Utilities Expense
       5400  Depreciation Expense
       5500  Insurance Expense

--- Numbering Convention ---
  1xxx  Assets
  2xxx  Liabilities
  3xxx  Equity
  4xxx  Revenue
  5xxx  Expenses
  6xxx  Other Income/Expense
  7xxx  Taxes

--- Normal Balance Quick Reference ---
  Account Type    Increase    Decrease    Normal Balance
  Asset           DEBIT       CREDIT      DEBIT
  Liability       CREDIT      DEBIT       CREDIT
  Equity          CREDIT      DEBIT       CREDIT
  Revenue         CREDIT      DEBIT       CREDIT
  Expense         DEBIT       CREDIT      DEBIT

  Memory aid (DEALER):
    Dividends, Expenses, Assets → DEBIT normal
    Liabilities, Equity, Revenue → CREDIT normal
EOF
}

cmd_entries() {
    cat << 'EOF'
=== Journal Entries ===

Format:
  Date | Account | Debit | Credit | Description

Rule: Total Debits MUST equal Total Credits

--- Common Business Transactions ---

  1. Customer pays $500 cash for services:
     Dr  Cash                    500
       Cr  Service Revenue              500
     (Asset ↑, Revenue ↑)

  2. Purchase $2,000 inventory on credit:
     Dr  Inventory              2,000
       Cr  Accounts Payable           2,000
     (Asset ↑, Liability ↑)

  3. Pay $1,200 rent with check:
     Dr  Rent Expense           1,200
       Cr  Cash                       1,200
     (Expense ↑, Asset ↓)

  4. Receive $3,000 payment from customer on account:
     Dr  Cash                   3,000
       Cr  Accounts Receivable        3,000
     (Asset ↑ Cash, Asset ↓ AR)

  5. Pay employees $8,000 salary:
     Dr  Salaries Expense       8,000
       Cr  Cash                       8,000
     (Expense ↑, Asset ↓)

  6. Owner invests $50,000 in business:
     Dr  Cash                  50,000
       Cr  Owner's Equity            50,000
     (Asset ↑, Equity ↑)

  7. Sell product for $1,000 (cost was $600):
     Dr  Cash                   1,000
       Cr  Sales Revenue              1,000
     Dr  Cost of Goods Sold       600
       Cr  Inventory                    600
     (Two entries: revenue recognition + cost matching)

  8. Record monthly depreciation $200:
     Dr  Depreciation Expense     200
       Cr  Accumulated Depreciation     200
     (Expense ↑, Contra-Asset ↑)

--- Compound Entries ---
  Multiple debits and/or credits in one entry:

  Pay $1,500 including $1,200 principal + $300 interest:
     Dr  Notes Payable          1,200
     Dr  Interest Expense         300
       Cr  Cash                       1,500

--- Adjusting Entries ---
  Made at period end to match revenue/expenses to correct period:
  - Accrued revenue (earned but not billed)
  - Accrued expenses (incurred but not paid)
  - Deferred revenue (received but not earned)
  - Prepaid expenses (paid but not used)
  - Depreciation
EOF
}

cmd_statements() {
    cat << 'EOF'
=== Financial Statements ===

--- Balance Sheet (Statement of Financial Position) ---
  Snapshot of company's financial position at a point in time.

  ASSETS
    Current Assets
      Cash                           $50,000
      Accounts Receivable             25,000
      Inventory                       30,000
      Prepaid Expenses                 5,000
    Total Current Assets                       $110,000

    Non-Current Assets
      Equipment                      $80,000
      Less: Accumulated Depreciation (20,000)
    Total Non-Current Assets                    $60,000

  TOTAL ASSETS                                 $170,000

  LIABILITIES
    Current Liabilities
      Accounts Payable               $15,000
      Accrued Expenses                 5,000
    Total Current Liabilities                   $20,000

    Non-Current Liabilities
      Long-term Debt                  $50,000
    Total Liabilities                           $70,000

  EQUITY
    Owner's Equity                    $80,000
    Retained Earnings                  20,000
  Total Equity                                 $100,000

  TOTAL LIABILITIES + EQUITY                   $170,000
  (Must equal Total Assets!)

--- Income Statement (Profit & Loss) ---
  Performance over a period (month, quarter, year).

  Revenue
    Sales Revenue                    $200,000
    Service Revenue                    50,000
  Total Revenue                                $250,000

  Expenses
    Cost of Goods Sold              ($120,000)
    Salaries                         (60,000)
    Rent                             (24,000)
    Utilities                         (6,000)
    Depreciation                      (5,000)
  Total Expenses                              ($215,000)

  NET INCOME                                    $35,000

--- Cash Flow Statement ---
  Cash movements over a period, categorized:

  Operating Activities:
    Net Income                       $35,000
    + Depreciation                     5,000
    - Increase in AR                  (3,000)
    + Decrease in Inventory            2,000
  Net Cash from Operations                      $39,000

  Investing Activities:
    Purchase of Equipment           ($15,000)
  Net Cash from Investing                      ($15,000)

  Financing Activities:
    Loan Repayment                  ($10,000)
    Owner Drawings                   (5,000)
  Net Cash from Financing                      ($15,000)

  NET CHANGE IN CASH                             $9,000
EOF
}

cmd_cycle() {
    cat << 'EOF'
=== The Accounting Cycle ===

The accounting cycle repeats every fiscal period (month/quarter/year).

Step 1: Identify Transactions
  Source documents: invoices, receipts, bank statements, contracts
  Each economic event that affects financial position

Step 2: Record Journal Entries
  Analyze transaction → determine accounts affected
  Apply double-entry: debits and credits
  Record in chronological order in the journal

Step 3: Post to Ledger
  Transfer journal entries to individual ledger accounts
  Each account accumulates its debit and credit totals
  Modern systems do this automatically

Step 4: Prepare Trial Balance
  List all accounts with their debit or credit balances
  Total debits must equal total credits
  If not balanced → find and fix errors

Step 5: Make Adjusting Entries
  At period end, adjust for:
  - Accrued revenues and expenses
  - Deferred revenues and expenses
  - Depreciation
  - Bad debt estimates
  Ensures matching principle (revenue with related expenses)

Step 6: Prepare Adjusted Trial Balance
  After adjustments, verify debits still equal credits

Step 7: Prepare Financial Statements
  From adjusted trial balance:
  1. Income Statement (Revenue - Expenses = Net Income)
  2. Statement of Owner's Equity
  3. Balance Sheet (Assets = Liabilities + Equity)
  4. Cash Flow Statement

Step 8: Close Temporary Accounts
  Revenue, Expense, and Dividend accounts are "closed"
  Their balances transfer to Retained Earnings
  These accounts start the next period at zero

  Closing entries:
    Dr  Revenue accounts          xxx
      Cr  Income Summary                xxx
    Dr  Income Summary            xxx
      Cr  Expense accounts              xxx
    Dr  Income Summary (net income) xxx
      Cr  Retained Earnings             xxx

Step 9: Post-Closing Trial Balance
  Only permanent accounts remain (Assets, Liabilities, Equity)
  Temporary accounts are all zero
  Ready for next period

Timeline:
  Daily:     Steps 1-3 (record transactions)
  Monthly:   Steps 4-7 (trial balance, adjustments, statements)
  Year-end:  Steps 8-9 (closing entries, start fresh)
EOF
}

cmd_schema() {
    cat << 'EOF'
=== Ledger Database Schema ===

--- Core Tables ---

  accounts
    id              UUID PRIMARY KEY
    code            VARCHAR(20) UNIQUE    -- "1000", "5100"
    name            VARCHAR(100)          -- "Cash", "Rent Expense"
    type            ENUM('asset','liability','equity','revenue','expense')
    normal_balance  ENUM('debit','credit')
    parent_id       UUID REFERENCES accounts(id)  -- hierarchy
    is_active       BOOLEAN DEFAULT true
    created_at      TIMESTAMP

  journal_entries (header)
    id              UUID PRIMARY KEY
    date            DATE NOT NULL
    description     VARCHAR(500)
    reference       VARCHAR(50)           -- invoice #, check #
    status          ENUM('draft','posted','voided')
    created_by      UUID REFERENCES users(id)
    created_at      TIMESTAMP
    posted_at       TIMESTAMP

  journal_lines (detail)
    id              UUID PRIMARY KEY
    entry_id        UUID REFERENCES journal_entries(id)
    account_id      UUID REFERENCES accounts(id)
    debit           DECIMAL(19,4) DEFAULT 0
    credit          DECIMAL(19,4) DEFAULT 0
    memo            VARCHAR(200)
    line_order      INT

--- Key Constraints ---
  -- Every entry must balance:
  CHECK: SUM(debit) = SUM(credit) for each entry_id

  -- No negative amounts:
  CHECK: debit >= 0 AND credit >= 0

  -- Each line has debit OR credit (not both):
  CHECK: (debit > 0 AND credit = 0) OR (debit = 0 AND credit > 0)

--- Immutability Rules ---
  1. NEVER update or delete posted journal entries
  2. To fix: create a reversing entry (same amounts, swapped Dr/Cr)
  3. Then create the correct entry
  4. This preserves complete audit trail

  -- Posted entries are immutable:
  CREATE POLICY no_modify_posted ON journal_entries
    FOR UPDATE USING (status != 'posted');

--- Balance Calculation ---
  -- Account balance = SUM(debits) - SUM(credits)
  -- For debit-normal accounts (assets, expenses): positive = normal
  -- For credit-normal accounts (liabilities, equity, revenue): negate

  SELECT a.code, a.name,
    SUM(jl.debit) - SUM(jl.credit) AS balance
  FROM journal_lines jl
  JOIN accounts a ON jl.account_id = a.id
  JOIN journal_entries je ON jl.entry_id = je.id
  WHERE je.status = 'posted'
    AND je.date <= '2024-12-31'
  GROUP BY a.id, a.code, a.name;

--- Multi-Currency Support ---
  journal_lines (extended):
    currency        CHAR(3)               -- "USD", "EUR"
    amount_local    DECIMAL(19,4)         -- in transaction currency
    exchange_rate   DECIMAL(12,6)
    amount_base     DECIMAL(19,4)         -- in base/reporting currency
EOF
}

cmd_tools() {
    cat << 'EOF'
=== Ledger Tools ===

--- Plaintext Accounting ---
  Store financial records as plain text files.
  Version-controlled, auditable, portable.

  ledger-cli (John Wiegley, 2003):
    The original plaintext accounting tool. C++.

    ; file: finances.ledger
    2024-01-15 * Grocery Store
        Expenses:Food             $50.00
        Assets:Checking

    2024-01-16 * Salary
        Assets:Checking         $5000.00
        Income:Salary

    # Commands:
    ledger -f finances.ledger balance
    ledger -f finances.ledger register Expenses
    ledger -f finances.ledger balance --monthly

  hledger (Simon Michael, Haskell):
    Modern rewrite. Web UI. More user-friendly.

    hledger -f finances.journal balance
    hledger -f finances.journal register
    hledger-web                    # browser-based UI

  beancount (Martin Blais, Python):
    Strictest syntax. Built-in validation. Fava web UI.

    2024-01-15 * "Grocery Store"
      Expenses:Food          50.00 USD
      Assets:Checking

    bean-check finances.beancount      # validate
    fava finances.beancount            # web UI

--- Comparison ---
  ┌────────────┬───────────┬──────────┬───────────┐
  │            │ ledger    │ hledger  │ beancount │
  ├────────────┼───────────┼──────────┼───────────┤
  │ Language   │ C++       │ Haskell  │ Python    │
  │ Speed      │ Fastest   │ Fast     │ Moderate  │
  │ Strictness │ Relaxed   │ Medium   │ Strictest │
  │ Web UI     │ No        │ Yes      │ Yes (fava)│
  │ Multi-curr │ Yes       │ Yes      │ Yes       │
  │ Validation │ Minimal   │ Good     │ Excellent │
  │ Plugins    │ No        │ Limited  │ Yes       │
  └────────────┴───────────┴──────────┴───────────┘

--- Commercial Software ---
  Small Business:
    QuickBooks (Intuit) — market leader
    Xero — cloud-native, popular internationally
    FreshBooks — invoicing-focused
    Wave — free for small businesses

  Enterprise:
    SAP — largest ERP system
    Oracle Financials — enterprise GL
    NetSuite — cloud ERP
    Sage Intacct — mid-market cloud accounting

  Open Source:
    GnuCash — desktop double-entry (GTK)
    ERPNext — full ERP with accounting (Python)
    Odoo — modular ERP with accounting

--- API-First Ledger Services ---
  For building fintech applications:
    Modern Treasury — payment + ledger API
    Moov — open-source fintech infrastructure
    Fragment — programmable ledger API
    TigerBeetle — high-performance financial DB
EOF
}

cmd_rules() {
    cat << 'EOF'
=== Accounting Rules & Principles ===

--- GAAP (Generally Accepted Accounting Principles) ---
  US standard. Key principles:

  Revenue Recognition:
    Record revenue when earned (delivered), not when cash received.
    Five-step model (ASC 606):
      1. Identify the contract
      2. Identify performance obligations
      3. Determine transaction price
      4. Allocate price to obligations
      5. Recognize revenue as obligations are satisfied

  Matching Principle:
    Record expenses in same period as related revenue.
    Sold $100K of product in March → record COGS in March
    (even if you bought inventory in January)

  Historical Cost:
    Record assets at original purchase price.
    Exceptions: fair value for investments, impairment testing.

  Conservatism:
    When in doubt, report lower values for assets and higher for liabilities.
    Recognize losses immediately, defer gains until realized.

  Materiality:
    Small amounts can be simplified.
    $5 office supply can be expensed immediately (not depreciated).
    Threshold depends on company size.

--- IFRS (International Financial Reporting Standards) ---
  Used globally (except US which uses GAAP).
  Key differences from GAAP:
    LIFO inventory: Not allowed under IFRS
    Development costs: Can be capitalized under IFRS
    Revaluation: Allowed for fixed assets under IFRS
    Convergence: GAAP and IFRS becoming more similar

--- Cash vs Accrual Basis ---
  Cash Basis:
    Record when cash changes hands
    Simple. Used by small businesses.
    Revenue: when payment received
    Expense: when payment made
    Problem: doesn't show true economic picture

  Accrual Basis:
    Record when transaction occurs (regardless of cash)
    Required by GAAP/IFRS for public companies
    Revenue: when earned (goods delivered/services rendered)
    Expense: when incurred (matched to revenue period)
    Better: shows obligations and expected receipts

  Example: December work, January payment
    Cash basis:  Revenue in January (when paid)
    Accrual:     Revenue in December (when earned)
                 Accounts Receivable in December
                 Cash in January (AR cleared)

--- Key Ratios (From Ledger Data) ---
  Current Ratio:     Current Assets / Current Liabilities
                     (> 1.5 is healthy)
  Quick Ratio:       (Cash + AR) / Current Liabilities
  Debt-to-Equity:    Total Liabilities / Total Equity
  Gross Margin:      (Revenue - COGS) / Revenue
  Net Profit Margin: Net Income / Revenue
  Days Sales Outstanding: (AR / Revenue) × 365
  Inventory Turnover: COGS / Average Inventory
EOF
}

show_help() {
    cat << EOF
ledger v$VERSION — Double-Entry Bookkeeping Reference

Usage: script.sh <command>

Commands:
  intro        Double-entry principle, accounting equation
  accounts     Chart of accounts: types, numbering, normal balances
  entries      Journal entries: debits, credits, examples
  statements   Financial statements: balance sheet, P&L, cash flow
  cycle        The accounting cycle: transaction to statements
  schema       Ledger database schema: tables, immutability, audit
  tools        Plaintext accounting, commercial, API-first ledgers
  rules        GAAP, IFRS, accrual vs cash, key ratios
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    accounts)   cmd_accounts ;;
    entries)    cmd_entries ;;
    statements) cmd_statements ;;
    cycle)      cmd_cycle ;;
    schema)     cmd_schema ;;
    tools)      cmd_tools ;;
    rules)      cmd_rules ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "ledger v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
