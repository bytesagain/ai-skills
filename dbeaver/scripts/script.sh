#!/bin/bash
# DBeaver - Universal Database Tool Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              DBEAVER REFERENCE                              ║
║          Universal Database Management Tool                 ║
╚══════════════════════════════════════════════════════════════╝

DBeaver is a free, cross-platform database management tool that
supports all major databases through JDBC drivers.

SUPPORTED DATABASES:
  Relational    PostgreSQL, MySQL, MariaDB, SQLite, Oracle,
                SQL Server, DB2, H2, Derby
  Cloud         Amazon RDS/Redshift, Google BigQuery/Spanner,
                Azure SQL, Snowflake, Databricks
  NoSQL         MongoDB, Cassandra, Redis, DynamoDB
  Embedded      SQLite, H2, HSQLDB, Derby
  Time-series   InfluxDB, TimescaleDB, QuestDB
  Graph         Neo4j, ArangoDB
  Others        ClickHouse, CockroachDB, Trino/Presto

EDITIONS:
  Community     Free, open source (Apache 2.0)
  PRO           NoSQL support, cloud databases, ERD, data transfer
  Enterprise    Team collaboration, version control, admin tools

KEY FEATURES:
  SQL Editor        Syntax highlighting, auto-complete, templates
  ER Diagrams       Visual database design
  Data Editor       Spreadsheet-like data editing
  Data Transfer     Import/export CSV, JSON, XML, SQL
  SSH Tunneling     Connect through SSH
  Query History     Track all executed queries
  Multiple tabs     Work with multiple connections/queries
  Dark theme        Eye-friendly dark mode
EOF
}

cmd_connections() {
cat << 'EOF'
CONNECTIONS
=============

NEW CONNECTION:
  Database → New Database Connection (or Ctrl+Shift+N)
  1. Select database type
  2. Enter host, port, database, credentials
  3. Test Connection
  4. Finish

CONNECTION PARAMETERS:
  PostgreSQL:  host:5432/dbname  user/pass
  MySQL:       host:3306/dbname  user/pass
  SQLite:      /path/to/database.db
  MongoDB:     mongodb://host:27017/dbname
  Redis:       host:6379
  SQL Server:  host:1433;database=dbname

SSH TUNNEL:
  1. Connection → SSH tab
  2. Enable "Use SSH Tunnel"
  3. Host: jump-server.example.com
  4. Port: 22
  5. Auth: key file or password
  6. Local port: auto (forwards to DB host:port)

  Use case: DB behind firewall, only accessible via bastion host

ADVANCED:
  # JDBC URL (manual)
  jdbc:postgresql://host:5432/mydb?ssl=true&sslmode=require

  # Driver properties
  Connection → Driver Properties tab
  - ssl = true
  - sslmode = require
  - ApplicationName = DBeaver

  # Connection timeout
  Connection → Connection Details → Keep-Alive

MULTIPLE ENVIRONMENTS:
  Create connection folders:
  Development/
  ├── dev-postgres
  ├── dev-redis
  Staging/
  ├── staging-postgres
  Production/
  ├── prod-postgres (read-only!)

  # Color-code connections
  Right-click connection → Connection Color
  Red = Production, Green = Development, Yellow = Staging
EOF
}

cmd_sqleditor() {
cat << 'EOF'
SQL EDITOR
============

KEYBOARD SHORTCUTS:
  Ctrl+Enter        Execute statement (at cursor)
  Ctrl+Alt+X        Execute script (all statements)
  Ctrl+Shift+E      Explain execution plan
  Ctrl+Space        Auto-complete
  Ctrl+Shift+F      Format SQL
  Ctrl+/            Toggle comment
  Ctrl+D            Delete line
  Ctrl+Alt+Up/Down  Duplicate line
  Alt+Up/Down       Move line
  F4                Open table editor (from selected name)
  Ctrl+Shift+N      New connection
  Ctrl+]            New SQL editor
  Ctrl+F            Find/Replace
  Ctrl+Shift+U      Uppercase
  Ctrl+Shift+L      Lowercase

SQL TEMPLATES:
  Type abbreviation + Tab to expand:
  sel    → SELECT * FROM |
  ins    → INSERT INTO | () VALUES ()
  upd    → UPDATE | SET
  del    → DELETE FROM | WHERE
  cre    → CREATE TABLE | ()
  alt    → ALTER TABLE |

  # Custom templates:
  Window → Preferences → SQL Editor → Templates

VARIABLES:
  -- Use in scripts
  @set schemaName = public
  @set tableName = users

  SELECT * FROM ${schemaName}.${tableName};

  -- Prompted variables
  SELECT * FROM users WHERE id = :userId;
  -- DBeaver will prompt for userId value

EXECUTION PLAN:
  Ctrl+Shift+E shows visual explain plan
  - Shows table scans, index usage, joins
  - Color-coded: red = expensive, green = fast
  - Click nodes for details

RESULT TABS:
  - Multiple result sets in tabs
  - Edit data directly in results grid
  - Filter/sort without changing query
  - Export results to file
  - Copy as SQL INSERT statements

DATA EDITOR:
  - Click cell to edit
  - Ctrl+I: set NULL
  - Tab: next cell
  - Enter: save row
  - Add row: click + icon
  - Delete row: select → Delete
  - Filter bar: type column conditions
  - Sort: click column header
EOF
}

cmd_features() {
cat << 'EOF'
ADVANCED FEATURES
===================

ER DIAGRAMS:
  Right-click schema → View Diagram
  - Auto-generates from foreign keys
  - Drag tables to arrange
  - Show/hide columns
  - Export as PNG/SVG
  - Print

  Custom diagram:
  File → New → ER Diagram
  Drag tables from navigator

DATA TRANSFER:
  Export:
    Right-click table → Export Data
    Formats: CSV, JSON, XML, SQL INSERT, HTML, Markdown, Excel
    Options: encoding, delimiter, null handling, row limit

  Import:
    Right-click table → Import Data
    Source: CSV, JSON, XML, another table/database

  Database migration:
    Tools → Database Compare
    Tools → Schema Transfer

QUERY HISTORY:
  Window → Query Manager
  - All executed queries with timestamps
  - Filter by connection, date, status
  - Re-execute from history
  - Export history

BOOKMARKS:
  Right-click in Navigator → Add Bookmark
  - Save frequently used tables/views
  - Organize in folders
  - Quick access from Bookmarks view

SCRIPTING:
  -- Generate DDL
  Right-click table → Generate SQL → DDL

  -- Generate CRUD
  Right-click table → Generate SQL → SELECT/INSERT/UPDATE/DELETE

  -- Compare schemas
  Tools → Compare/Migrate → Schema Compare
  Generates ALTER scripts

SEARCH:
  -- Find table/column by name
  Ctrl+Shift+R → type name

  -- Search data across tables
  Edit → Search → Data (PRO)

  -- Full-text search in metadata
  Navigator search bar

MOCK DATA (PRO):
  Right-click table → Generate Mock Data
  - Generates realistic test data
  - Types: names, emails, addresses, dates, numbers
  - Respects foreign keys and constraints
  - Configurable row count

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
DBeaver - Universal Database Tool Reference

Commands:
  intro        Overview, supported databases
  connections  Setup, SSH tunnel, environments
  sqleditor    Shortcuts, templates, variables, explain
  features     ER diagrams, data transfer, scripting

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)       cmd_intro ;;
  connections) cmd_connections ;;
  sqleditor)   cmd_sqleditor ;;
  features)    cmd_features ;;
  help|*)      show_help ;;
esac
