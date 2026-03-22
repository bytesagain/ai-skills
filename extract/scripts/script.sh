#!/usr/bin/env bash
# extract — Data Extraction Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Data Extraction ===

Extraction is the process of pulling structured data from sources —
the "E" in ETL (Extract, Transform, Load).

Extraction Methods:
  API-based      Pull data via REST/GraphQL/SOAP endpoints
  File-based     Read from CSV, JSON, XML, Parquet files
  Database       Query source databases directly (SQL)
  Web scraping   Parse HTML pages for embedded data
  Log parsing    Extract fields from unstructured log lines
  OCR            Convert images/scanned documents to text
  Stream         Consume from Kafka, RabbitMQ, CDC streams

Extraction Patterns:

  Full Extract:
    Pull all records every time
    Simple but wasteful for large datasets
    Use: small reference tables, initial loads

  Incremental Extract:
    Pull only new/changed records since last run
    Requires: watermark column (updated_at, id, sequence number)
    Most efficient for large, frequently updated sources

  Change Data Capture (CDC):
    Capture database changes from transaction log
    Tools: Debezium, AWS DMS, Oracle GoldenGate
    Most real-time, no query load on source

  Event-Driven:
    Source pushes changes via webhooks or message queue
    No polling, lowest latency
    Requires: source system cooperation

Data Quality at Extraction:
  1. Count records at source and destination (reconciliation)
  2. Checksum critical columns
  3. Monitor schema changes (new columns, type changes)
  4. Log extraction metadata: start time, row count, errors
  5. Handle encoding consistently (UTF-8 everywhere)
EOF
}

cmd_regex() {
    cat << 'EOF'
=== Regex Extraction Patterns ===

--- Common Extractions ---

Email:
  [a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}
  Matches: user@example.com, first.last+tag@sub.domain.org

URL:
  https?://[^\s<>"{}|\\^`\[\]]+
  Matches: http://example.com/path?q=1&r=2#anchor
  Better: https?://[^\s)>\]]+  (for URLs in parentheses/brackets)

IPv4:
  \b(?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\b
  Matches: 192.168.1.1, 10.0.0.255
  Simple (less strict): \d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}

IPv6:
  [0-9a-fA-F:]{3,39}
  Better handled by language-specific parsers

Phone (US):
  \(?[0-9]{3}\)?[-.\s]?[0-9]{3}[-.\s]?[0-9]{4}
  Matches: (555) 123-4567, 555.123.4567, 5551234567

Phone (International):
  \+?[0-9]{1,4}[-.\s]?\(?[0-9]{1,4}\)?[-.\s]?[0-9]{3,4}[-.\s]?[0-9]{3,4}

Date (ISO 8601):
  \d{4}-(?:0[1-9]|1[0-2])-(?:0[1-9]|[12]\d|3[01])
  Matches: 2024-01-15

Date (US format):
  (?:0[1-9]|1[0-2])/(?:0[1-9]|[12]\d|3[01])/(?:19|20)\d{2}
  Matches: 01/15/2024

Time (24h):
  (?:[01]\d|2[0-3]):[0-5]\d(?::[0-5]\d)?
  Matches: 14:30, 23:59:59

Money:
  \$[\d,]+\.?\d{0,2}
  Matches: $1,234.56, $99, $1,000,000.00

UUID:
  [0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}
  Matches: 550e8400-e29b-41d4-a716-446655440000

Credit Card (basic):
  \b(?:\d[ -]*?){13,16}\b
  NOTE: never log full card numbers in production

--- Regex Tips ---
  Use non-greedy (.*?) to avoid over-matching
  Named groups: (?P<name>pattern) for readability
  Word boundaries \b prevent partial matches
  Test with: regex101.com, regexr.com
  Escape special chars: . * + ? ^ $ { } [ ] ( ) | \
EOF
}

cmd_html() {
    cat << 'EOF'
=== HTML/Web Extraction ===

--- CSS Selectors ---
  div.class          Element with class
  #id                Element by ID
  div > p            Direct child
  div p              Any descendant
  div + p            Adjacent sibling
  a[href]            Attribute exists
  a[href^="https"]   Attribute starts with
  a[href$=".pdf"]    Attribute ends with
  a[href*="example"] Attribute contains
  tr:nth-child(2n)   Even rows
  p:first-of-type    First paragraph
  li:not(.active)    Negation

--- XPath ---
  //div[@class="price"]        Find by class
  //a/@href                    Extract attribute
  //table/tr[position()>1]/td  Skip header row
  //h1/text()                  Text content only
  //div[contains(@class,"item")]  Partial class match
  //p[last()]                  Last paragraph
  //div[@id="main"]//a         Descendant links
  (//table)[2]//tr             Rows from 2nd table

--- Extraction Strategy ---

  Static HTML:
    1. Fetch page with requests/curl
    2. Parse with Beautiful Soup, lxml, Cheerio
    3. Select elements via CSS/XPath
    4. Extract text/attributes

  JavaScript-Rendered (SPA):
    1. Use headless browser (Playwright, Puppeteer, Selenium)
    2. Wait for dynamic content to load
    3. Then parse rendered DOM
    Alternative: find underlying API calls in browser DevTools
      Network tab → XHR requests → often returns JSON directly

  API Discovery (preferred over scraping):
    1. Open browser DevTools → Network tab
    2. Navigate the site, watch for XHR/Fetch requests
    3. Look for JSON responses with the data you want
    4. Call that API endpoint directly
    5. Much more stable than HTML parsing

--- Anti-Scraping Defenses ---
  Rate limiting        → Add delays, use exponential backoff
  CAPTCHAs             → Use API instead, or CAPTCHA solving service
  IP blocking          → Rotate IPs, use proxies
  User-Agent checks    → Set realistic User-Agent header
  Cookie walls         → Maintain session cookies
  Dynamic class names  → Use attribute content selectors, not class names
  robots.txt           → Respect it (legal and ethical reasons)
EOF
}

cmd_text() {
    cat << 'EOF'
=== Text Extraction ===

--- Log Parsing ---

Common log formats:

  Apache/Nginx Combined Log:
    127.0.0.1 - frank [10/Oct/2024:13:55:36 -0700] "GET /api/users HTTP/1.1" 200 3456
    Fields: IP, ident, user, timestamp, request, status, bytes

    Regex: ^(\S+) \S+ (\S+) \[([^\]]+)\] "([^"]*)" (\d{3}) (\d+|-)

  Syslog:
    Oct 15 14:23:45 hostname sshd[12345]: Accepted publickey for user
    Fields: timestamp, hostname, process[pid], message

    Regex: ^(\w+ \d+ [\d:]+) (\S+) (\S+)\[(\d+)\]: (.*)

  JSON structured logs (modern):
    {"timestamp":"2024-01-15T10:30:00Z","level":"ERROR","msg":"connection refused","host":"db-01"}
    Parse with: jq, Python json module — no regex needed!

--- Delimiter Handling ---

  CSV pitfalls:
    Quoted fields:     "Smith, John",42,"New York"
    Escaped quotes:    "He said ""hello""",other
    Newlines in fields: "Line 1\nLine 2",next
    Mixed delimiters:  tabs in CSV, commas in TSV

  Never split CSV by comma — use a proper CSV parser
    Python: csv.reader() or pandas.read_csv()
    CLI: csvkit (csvcut, csvgrep, csvsql)
    Bash: awk -F',' (only safe for simple, unquoted CSV)

--- Fixed-Width Fields ---
  Common in legacy/mainframe systems, COBOL output

  Example record:
    JOHN      SMITH     19850315NYC  0004523500
    |---------|---------|--------|---|----------|
    First(10) Last(10)  DOB(8)  Loc(3) Balance(10)

  Extract with:
    cut -c1-10,11-20,21-28,29-31,32-41
    Python: struct.unpack or string slicing
    awk: substr($0, 1, 10)

--- Multi-Line Records ---
  Some formats span multiple lines per record:
    BEGIN
    Name: John Smith
    Age: 42
    END

  Approaches:
    awk '/BEGIN/,/END/'           # print range
    sed -n '/BEGIN/,/END/p'      # same in sed
    Python: read file, split on delimiter, parse each block
EOF
}

cmd_pdf() {
    cat << 'EOF'
=== PDF Extraction ===

PDFs are notoriously difficult to extract data from because they
describe APPEARANCE, not STRUCTURE.

--- PDF Types ---

  Text-based PDF:
    Contains actual text characters (searchable, selectable)
    Extract with: pdftotext, PyPDF2, pdfplumber
    Accuracy: high for simple layouts

  Scanned/Image PDF:
    Contains images of pages (not searchable)
    Requires: OCR (Optical Character Recognition)
    Tools: Tesseract, Amazon Textract, Google Document AI

  Mixed PDF:
    Some pages text, some scanned
    Strategy: try text extraction first, fall back to OCR

--- Tools ---

  pdftotext (poppler):
    pdftotext -layout input.pdf output.txt    # preserve layout
    pdftotext -raw input.pdf output.txt       # reading order
    Best for: simple text extraction

  pdfplumber (Python):
    Excellent for tables
    import pdfplumber
    with pdfplumber.open("file.pdf") as pdf:
        page = pdf.pages[0]
        table = page.extract_table()
    Detects table boundaries, handles merged cells

  Tabula (Java/Python):
    Specialized for table extraction
    tabula.read_pdf("file.pdf", pages="all")
    Works well for consistent table layouts

  Camelot (Python):
    Another table extractor, two modes:
    Lattice: tables with visible borders
    Stream: tables without borders (uses whitespace)

  Tesseract (OCR):
    tesseract input.png output -l eng --psm 6
    Page segmentation modes (PSM):
      3 = fully automatic (default)
      6 = assume uniform block of text
      11 = sparse text, no particular order
    Accuracy: 85-95% for clean scans, <70% for poor quality

--- Table Extraction Strategy ---
  1. Try pdfplumber/tabula first (fast, accurate for text PDFs)
  2. If no text layer → OCR with Tesseract
  3. Post-process: validate row/column counts, check totals
  4. For complex layouts: Amazon Textract or Google Document AI
  5. Last resort: convert PDF to image, use computer vision

--- Common Issues ---
  Multi-column layouts    → pdftotext -layout, or specify extraction area
  Headers/footers         → Detect repeated text, filter out
  Merged table cells      → Check for None/empty in extracted data
  Rotated text            → Pre-rotate pages before extraction
  Encrypted PDFs          → Decrypt first (if allowed): qpdf --decrypt
EOF
}

cmd_etl() {
    cat << 'EOF'
=== ETL Extraction Patterns ===

--- Full vs Incremental ---

  Full Extract:
    SELECT * FROM source_table;
    Simple, guaranteed complete
    Problem: slow for large tables, wastes bandwidth
    Use for: initial load, small reference tables, periodic reconciliation

  Incremental by Timestamp:
    SELECT * FROM source_table
    WHERE updated_at > '2024-01-15T00:00:00Z';

    Requires: reliable updated_at column on source
    Stores: high-water mark (last extracted timestamp)
    Pitfall: clock skew between source and ETL system
    Fix: overlap window (subtract 5 minutes from watermark)

  Incremental by ID:
    SELECT * FROM source_table WHERE id > 12345;
    Works for append-only tables (logs, events)
    Cannot capture updates or deletes

  CDC (Change Data Capture):
    Read database transaction log (WAL/binlog)
    Captures: INSERT, UPDATE, DELETE in real-time
    Tools: Debezium, AWS DMS, Oracle GoldenGate
    Lowest latency, no query overhead on source
    Complexity: schema evolution, log retention

--- Idempotent Extraction ---
  Goal: re-running extraction produces same result

  Strategies:
    1. Extract into staging table, then merge (UPSERT)
    2. Use deterministic extraction window (full hour, full day)
    3. Deduplicate by primary key after extraction
    4. Store extraction metadata: run_id, extracted_at, row_count

--- Extraction Metadata ---
  Log every extraction run:
    {
      "run_id": "2024-01-15-001",
      "source": "orders_db.public.orders",
      "method": "incremental_timestamp",
      "watermark_start": "2024-01-14T00:00:00Z",
      "watermark_end": "2024-01-15T00:00:00Z",
      "rows_extracted": 15234,
      "duration_seconds": 45,
      "status": "success"
    }

--- Rate Limiting Source Systems ---
  Never hammer source databases during business hours
  Strategies:
    - Extract during off-peak hours (overnight, weekends)
    - Use read replicas instead of primary database
    - Implement backpressure: slow down if source latency increases
    - Paginate large extractions (10,000 rows per batch)
    - Respect API rate limits: honor 429 responses, use exponential backoff
EOF
}

cmd_tools() {
    cat << 'EOF'
=== Extraction Tools ===

--- CLI Tools ---

grep:
  grep -oP '[\w.+-]+@[\w.-]+\.\w+' file.txt     # extract emails
  grep -oE 'https?://[^ ]+' file.txt             # extract URLs
  grep -c 'ERROR' app.log                          # count errors
  zgrep 'pattern' file.gz                          # search compressed

awk:
  awk '{print $3}' file.txt                  # 3rd column (space-delimited)
  awk -F',' '{print $1,$3}' data.csv         # 1st and 3rd CSV columns
  awk '/ERROR/{print $0}' app.log            # lines containing ERROR
  awk '{sum+=$2} END{print sum}' data.txt    # sum 2nd column

sed:
  sed -n '10,20p' file.txt                   # extract lines 10-20
  sed 's/.*name="\([^"]*\)".*/\1/' xml.txt   # extract attribute value
  sed -n '/START/,/END/p' file.txt           # extract between markers

jq (JSON):
  jq '.users[].name' data.json              # extract all user names
  jq '.items[] | {id, price}' data.json     # select specific fields
  jq -r '.[] | [.id, .name] | @csv' data.json  # JSON to CSV
  jq '.results | length' data.json          # count array elements

cut:
  cut -d',' -f1,3 data.csv        # columns 1 and 3 (comma-delimited)
  cut -c1-10 data.txt              # characters 1-10 (fixed-width)

--- Python Libraries ---

Beautiful Soup:    HTML parsing, CSS selectors
Scrapy:            Full web scraping framework with crawling
lxml:              Fast XML/HTML parsing with XPath
pandas:            read_csv, read_excel, read_json, read_sql
pdfplumber:        PDF text and table extraction
Tabula-py:         PDF table extraction (Java-backed)
pytesseract:       OCR via Tesseract
openpyxl:          Excel file reading
python-docx:       Word document extraction

--- Services ---
Amazon Textract:   AI-powered document extraction (tables, forms)
Google Document AI: Same category, Google's offering
Apache Tika:       Universal content extraction (100+ formats)
Firecrawl:         Web scraping API with JS rendering
EOF
}

cmd_pitfalls() {
    cat << 'EOF'
=== Extraction Pitfalls ===

1. Character Encoding
   Problem: Mojibake (garbled text) from wrong encoding assumption
   Cause: Source is Latin-1, you read as UTF-8 (or vice versa)
   Fix: Detect encoding (chardet library), convert to UTF-8 at extraction
   Rule: UTF-8 everywhere. Convert at the boundary, store as UTF-8.

2. Timezone Handling
   Problem: Timestamps without timezone info → ambiguous
   "2024-01-15 10:30:00" — which timezone?
   Fix: Always extract with timezone or convert to UTC immediately
   Store: UTC internally, convert for display only

3. Null vs Empty vs Missing
   Problem: "", NULL, "null", "N/A", "n/a", "-", "None" all mean different things
   Source CSV: ,, means empty; source may not distinguish NULL
   Fix: Define mapping rules at extraction time. Document them.

4. Schema Drift
   Problem: Source adds new columns, changes types, renames fields
   Your extraction breaks silently or loses data
   Fix: Schema validation at extraction time, alert on changes
   Tools: Great Expectations, dbt schema tests, custom assertions

5. Partial Extraction
   Problem: Extraction fails midway, leaving incomplete data
   Causes: network timeout, source system error, disk full
   Fix: Extract to temp staging, atomic swap on success only
   Store: watermark only after successful extraction

6. Duplicate Records
   Problem: Re-running extraction creates duplicates
   Causes: overlapping time windows, retry without dedup
   Fix: Deduplicate by natural key, use UPSERT/MERGE patterns
   Prevention: idempotent extraction design (same input → same output)

7. Over-Extracting HTML
   Problem: Getting text from HTML but including nav, footer, ads
   Fix: Target specific content containers, strip boilerplate
   Tools: readability algorithm (like Firefox Reader View)
   Rule: extract from the most specific selector possible

8. Rate Limit Exhaustion
   Problem: Scraping too fast → IP blocked, API key revoked
   Fix:
     - Add random delays: sleep(random(1, 3))
     - Honor Retry-After headers
     - Use exponential backoff on errors
     - Cache responses, don't re-fetch unchanged data
     - Rotate user agents and IPs if necessary (within ToS)
EOF
}

show_help() {
    cat << EOF
extract v$VERSION — Data Extraction Reference

Usage: script.sh <command>

Commands:
  intro        Data extraction overview and pipeline design
  regex        Regex patterns for common field extraction
  html         HTML/web extraction with CSS selectors and XPath
  text         Log parsing, delimiters, and fixed-width fields
  pdf          PDF extraction tools and table parsing
  etl          ETL extraction patterns: incremental, CDC, idempotency
  tools        CLI and Python extraction tools reference
  pitfalls     Common extraction mistakes and edge cases
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    regex)      cmd_regex ;;
    html)       cmd_html ;;
    text)       cmd_text ;;
    pdf)        cmd_pdf ;;
    etl)        cmd_etl ;;
    tools)      cmd_tools ;;
    pitfalls)   cmd_pitfalls ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "extract v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
