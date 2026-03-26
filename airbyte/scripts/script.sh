#!/bin/bash
# Airbyte - Open-Source Data Integration Platform Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              AIRBYTE REFERENCE                              ║
║          Open-Source ELT Data Integration                   ║
╚══════════════════════════════════════════════════════════════╝

Airbyte is an open-source data integration platform that syncs data
from applications, APIs, and databases to data warehouses, lakes,
and other destinations.

KEY CONCEPTS:
  Source          Where data comes from (API, database, file)
  Destination     Where data goes to (warehouse, lake, DB)
  Connection      Links a source to a destination
  Stream          A table or endpoint within a source
  Sync            The act of moving data
  Catalog         Schema definition of available streams
  Normalization   Transform raw JSON into structured tables

AIRBYTE vs COMPETITORS:
  ┌─────────────────┬──────────────┬──────────────┬──────────┐
  │ Feature         │ Airbyte      │ Fivetran     │ Stitch   │
  ├─────────────────┼──────────────┼──────────────┼──────────┤
  │ Open Source     │ Yes          │ No           │ No       │
  │ Connectors      │ 400+         │ 300+         │ 200+     │
  │ Custom Connect. │ Easy (CDK)   │ Hard         │ Hard     │
  │ Pricing         │ Free/usage   │ $$$/row      │ $$/row   │
  │ Self-hosted     │ Yes          │ No           │ No       │
  │ dbt Integration │ Native       │ Native       │ Limited  │
  │ Incremental     │ Yes          │ Yes          │ Yes      │
  │ CDC             │ Yes          │ Yes          │ Limited  │
  └─────────────────┴──────────────┴──────────────┴──────────┘

SYNC MODES:
  Full Refresh | Overwrite    Fetch everything, replace destination
  Full Refresh | Append       Fetch everything, add to destination
  Incremental  | Append       Only fetch new/changed records
  Incremental  | Deduped      Fetch new/changed, deduplicate by key

ARCHITECTURE:
  ┌─────────┐    ┌──────────┐    ┌─────────────┐
  │ Sources │───→│ Airbyte  │───→│Destinations │
  │ (APIs,  │    │ Platform │    │ (Warehouse, │
  │  DBs)   │    │          │    │  Lake, DB)  │
  └─────────┘    └──────────┘    └─────────────┘
                      │
                 ┌────┴────┐
                 │ Workers │  Docker containers
                 │ (sync)  │  per connection
                 └─────────┘
EOF
}

cmd_deploy() {
cat << 'EOF'
DEPLOYMENT OPTIONS
====================

1. DOCKER COMPOSE (Development/Small Scale)
   git clone https://github.com/airbytehq/airbyte.git
   cd airbyte
   ./run-ab-platform.sh

   Access: http://localhost:8000
   Default creds: airbyte / password

   Requirements:
   - Docker & Docker Compose
   - 4 CPU cores, 8GB RAM minimum
   - 30GB disk space

2. KUBERNETES (Production)
   # Using Helm
   helm repo add airbyte https://airbytehq.github.io/helm-charts
   helm install airbyte airbyte/airbyte \
     --namespace airbyte \
     --create-namespace \
     --values values.yaml

   values.yaml example:
     webapp:
       replicaCount: 2
     worker:
       replicaCount: 4
       resources:
         requests:
           cpu: "2"
           memory: "4Gi"
     postgresql:
       persistence:
         size: 50Gi

3. AIRBYTE CLOUD (Managed)
   - No infrastructure to manage
   - Pay per synced row
   - Same connectors as OSS
   - cloud.airbyte.com

PRODUCTION CHECKLIST:
  ☐ External PostgreSQL (not embedded)
  ☐ External logging (ELK/CloudWatch)
  ☐ Persistent volumes for state
  ☐ Worker resource limits configured
  ☐ Secrets stored in vault (not plaintext)
  ☐ Monitoring and alerting set up
  ☐ Backup strategy for config database
  ☐ Network policies for source/destination access
EOF
}

cmd_connectors() {
cat << 'EOF'
POPULAR CONNECTORS
====================

SOURCES (data from):
  Databases:
    PostgreSQL     CDC via Debezium, incremental via cursor
    MySQL          CDC + incremental
    MongoDB        Change streams
    SQL Server     CDC via Debezium
    Oracle         LogMiner CDC

  SaaS/APIs:
    Salesforce     Bulk + REST API, incremental
    HubSpot        CRM, Marketing, Sales data
    Stripe         Payments, subscriptions, invoices
    Shopify        Orders, products, customers
    GitHub         Repos, issues, PRs, commits
    Slack          Messages, channels, users
    Google Ads     Campaigns, ad groups, keywords
    Facebook Ads   Campaigns, ad sets, insights
    Zendesk        Tickets, users, organizations

  Files:
    S3 (CSV/JSON/Parquet)
    GCS files
    SFTP files
    Google Sheets

DESTINATIONS (data to):
  Warehouses:
    Snowflake      Most popular destination
    BigQuery       Native staging via GCS
    Redshift       S3 staging
    Databricks     Delta Lake

  Databases:
    PostgreSQL     Direct insert or COPY
    MySQL          Batch insert
    ClickHouse     Batch insert

  Lakes/Storage:
    S3             Parquet, JSON, CSV
    GCS            Parquet, JSON, CSV
    Delta Lake     Via Databricks connector

  Other:
    Kafka          Streaming destination
    Elasticsearch  Search/analytics

CONNECTOR STATUS LEVELS:
  Generally Available (GA)    Stable, supported, recommended
  Beta                        Working but may have edge cases
  Alpha                       Early stage, use with caution
  Community                   Maintained by community

CHECK CONNECTOR STATUS:
  Airbyte UI → Sources/Destinations → hover for status badge
  Or: https://docs.airbyte.com/integrations/
EOF
}

cmd_connections() {
cat << 'EOF'
CONNECTION CONFIGURATION
==========================

CREATING A CONNECTION:
  1. Set up Source (provide credentials, select tables)
  2. Set up Destination (provide credentials, target schema)
  3. Create Connection:
     - Select streams (tables/endpoints) to sync
     - Choose sync mode per stream
     - Set sync frequency
     - Configure namespace

SYNC MODES DEEP DIVE:

  Full Refresh | Overwrite:
    Every sync: fetch ALL data, replace entire table
    Use when: small tables, reference data, no update tracking
    Cost: high for large tables (reads everything every time)

  Full Refresh | Append:
    Every sync: fetch ALL data, append (creates duplicates)
    Use when: you handle dedup downstream (e.g., dbt)
    Warning: table grows indefinitely without cleanup

  Incremental | Append:
    Every sync: fetch only NEW records since last sync
    Requires: cursor field (updated_at, id, timestamp)
    Use when: event logs, time-series, append-only data
    Note: updates to existing records are NOT captured

  Incremental | Deduped History:
    Every sync: fetch new/changed records, deduplicate
    Requires: cursor field + primary key
    Use when: mutable data (CRM contacts, order statuses)
    Best: for most production use cases

  CDC (Change Data Capture):
    Real-time capture of inserts, updates, deletes
    Requires: database log access (WAL, binlog)
    Use when: need true real-time + delete detection

SYNC FREQUENCY:
  Manual          Trigger via UI or API
  Scheduled       Every N hours (1h, 2h, 6h, 12h, 24h)
  Cron            Custom cron expression
  Webhook         Trigger on external event (Cloud only)

NAMESPACE:
  destination_default    Use destination's default schema
  source                 Mirror source schema names
  custom                 Specify custom schema/dataset name

  Example: source=salesforce → destination schema "salesforce_raw"
EOF
}

cmd_cdc() {
cat << 'EOF'
CHANGE DATA CAPTURE (CDC)
===========================

CDC captures row-level changes (insert/update/delete) from database
transaction logs in real-time.

SUPPORTED CDC SOURCES:
  PostgreSQL    WAL (Write-Ahead Log) via Debezium
  MySQL         Binlog via Debezium
  SQL Server    CDC tables via Debezium
  MongoDB       Change Streams (native)
  Oracle        LogMiner

POSTGRESQL CDC SETUP:

  1. Enable logical replication:
     # postgresql.conf
     wal_level = logical
     max_replication_slots = 5
     max_wal_senders = 5

     # Restart PostgreSQL
     sudo systemctl restart postgresql

  2. Create replication user:
     CREATE USER airbyte_cdc REPLICATION LOGIN PASSWORD 'password';
     GRANT SELECT ON ALL TABLES IN SCHEMA public TO airbyte_cdc;
     ALTER DEFAULT PRIVILEGES IN SCHEMA public
       GRANT SELECT ON TABLES TO airbyte_cdc;

  3. Create publication:
     CREATE PUBLICATION airbyte_publication FOR ALL TABLES;

  4. In Airbyte source config:
     - Replication method: Logical Replication (CDC)
     - Publication: airbyte_publication

MYSQL CDC SETUP:

  1. Enable binlog:
     # my.cnf
     server-id = 1
     log_bin = mysql-bin
     binlog_format = ROW
     binlog_row_image = FULL
     expire_logs_days = 3

  2. Create user with replication privileges:
     CREATE USER 'airbyte'@'%' IDENTIFIED BY 'password';
     GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'airbyte'@'%';

CDC vs CURSOR-BASED INCREMENTAL:
  ┌──────────────┬──────────────────┬──────────────────┐
  │ Feature      │ CDC              │ Cursor           │
  ├──────────────┼──────────────────┼──────────────────┤
  │ Deletes      │ Captured         │ NOT captured     │
  │ Latency      │ Near real-time   │ Schedule-based   │
  │ Source load  │ Reads WAL only   │ Queries tables   │
  │ Setup        │ Complex          │ Simple           │
  │ Schema drift │ Auto-detected    │ Manual refresh   │
  │ Requirements │ DB admin access  │ Read access only │
  └──────────────┴──────────────────┴──────────────────┘

CDC BEST PRACTICES:
  - Monitor replication lag
  - Set WAL retention (avoid disk full)
  - Use dedicated replication slots per connection
  - Test failover behavior
  - Keep binlog/WAL retention ≥ sync interval
EOF
}

cmd_api() {
cat << 'EOF'
AIRBYTE API & AUTOMATION
===========================

Airbyte provides a REST API for programmatic control.

BASE URL: http://localhost:8000/api/v1

AUTHENTICATION:
  Basic Auth: airbyte:password (default)
  Cloud: Bearer token

LIST WORKSPACES:
  curl -X POST http://localhost:8000/api/v1/workspaces/list \
    -H "Content-Type: application/json" \
    -u "airbyte:password" \
    -d '{}'

LIST CONNECTIONS:
  curl -X POST http://localhost:8000/api/v1/connections/list \
    -H "Content-Type: application/json" \
    -u "airbyte:password" \
    -d '{"workspaceId": "<workspace-id>"}'

TRIGGER SYNC:
  curl -X POST http://localhost:8000/api/v1/connections/sync \
    -H "Content-Type: application/json" \
    -u "airbyte:password" \
    -d '{"connectionId": "<connection-id>"}'

CHECK SYNC STATUS:
  curl -X POST http://localhost:8000/api/v1/jobs/list \
    -H "Content-Type: application/json" \
    -u "airbyte:password" \
    -d '{
      "configTypes": ["sync"],
      "configId": "<connection-id>"
    }'

TERRAFORM PROVIDER:
  terraform {
    required_providers {
      airbyte = {
        source  = "airbytehq/airbyte"
        version = "~> 0.3"
      }
    }
  }

  resource "airbyte_source_postgres" "prod_db" {
    configuration = {
      host     = "db.example.com"
      port     = 5432
      database = "production"
      username = "airbyte"
      password = var.db_password
      ssl_mode = { preferred = {} }
      replication_method = {
        read_changes_using_write_ahead_log_cdc = {
          publication = "airbyte_publication"
        }
      }
    }
    name         = "Production PostgreSQL"
    workspace_id = var.workspace_id
  }

OCTAVIA CLI (Declarative Config):
  # Define connections as YAML
  octavia init
  octavia import all
  octavia apply

  # connection.yaml
  resource_name: "prod-to-warehouse"
  definition_type: connection
  configuration:
    source_id: <source-id>
    destination_id: <dest-id>
    schedule:
      units: 6
      time_unit: hours
    sync_catalog:
      - stream_name: users
        sync_mode: incremental
        destination_sync_mode: append_dedup
        cursor_field: [updated_at]
        primary_key: [[id]]
EOF
}

cmd_troubleshoot() {
cat << 'EOF'
TROUBLESHOOTING GUIDE
=======================

1. SYNC FAILURES

  "Connection refused" / "Timeout":
    - Source/destination not reachable from Airbyte workers
    - Check network connectivity, firewalls, security groups
    - For Docker: ensure source is not on localhost (use host.docker.internal)

  "Authentication failed":
    - Verify credentials in source/destination config
    - Check IP whitelist on database
    - For cloud DBs: enable connections from Airbyte IP

  "Out of memory":
    - Increase worker memory in docker-compose.yml or Helm values
    - Reduce batch size for large tables
    - Use incremental sync instead of full refresh

  "Schema has changed":
    - Source schema modified since connection created
    - Go to Connection → Schema → Refresh source schema → Save
    - May need to reset affected streams

2. SLOW SYNCS

  Diagnose:
    - Check "Records emitted" rate in sync logs
    - Check network latency between Airbyte and source/destination
    - Check source database load during sync

  Solutions:
    - Use CDC instead of cursor-based incremental
    - Reduce number of streams per connection
    - Increase worker parallelism
    - Use staging (S3/GCS) for warehouse destinations
    - Exclude unnecessary columns

3. DUPLICATE DATA

  Full Refresh | Append creates duplicates by design.
  Fix: Switch to Incremental | Deduped
  Or: Handle dedup in dbt downstream

  Incremental duplicates:
    - Cursor field not unique → duplicates near boundaries
    - Fix: use a more granular cursor (timestamp > date)
    - Or: use CDC for exact change tracking

4. DISK SPACE

  Airbyte stores temporary data during syncs.
  Monitor: /tmp/airbyte_local/ (Docker) or PV (Kubernetes)

  Cleanup:
    docker system prune -f
    # Or set TEMPORAL_RETENTION_PERIOD=3d in .env

5. CONNECTOR-SPECIFIC ISSUES

  PostgreSQL:
    - "replication slot already active" → drop and recreate slot
    - WAL disk growth → set max_slot_wal_keep_size

  Salesforce:
    - API rate limits → increase sync interval to 6h+
    - Bulk API timeout → reduce batch size

  Google Sheets:
    - 10 million cell limit → use BigQuery export instead
    - Rate limit → add delay between requests

DIAGNOSTIC COMMANDS:
  # Check Airbyte containers
  docker compose ps
  docker compose logs -f worker

  # Check specific sync job
  docker compose logs worker 2>&1 | grep <connection-id>

  # Restart specific component
  docker compose restart worker
  docker compose restart server

  # Check resource usage
  docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
EOF
}

cmd_best_practices() {
cat << 'EOF'
AIRBYTE BEST PRACTICES
========================

1. CONNECTION DESIGN
   - One connection per source-destination pair
   - Group related streams in same connection
   - Use separate connections for different SLAs
     (real-time CDC vs daily batch)
   - Name connections clearly: "prod-postgres → snowflake-raw"

2. SYNC STRATEGY
   - Default to Incremental | Deduped for mutable data
   - Use Full Refresh only for small reference tables
   - CDC for low-latency requirements
   - Schedule syncs during off-peak hours for large datasets

3. SCHEMA MANAGEMENT
   - Use raw tables + dbt transformation (ELT pattern)
   - Don't build directly on Airbyte output tables
   - Keep a raw/staging layer between Airbyte and analytics

   ELT Pipeline:
     Source → Airbyte → Raw Schema → dbt → Analytics Schema
                         (staging)    (transform)  (production)

4. MONITORING
   - Alert on sync failures (Airbyte has built-in notifications)
   - Monitor sync duration trends
   - Track data freshness in downstream tables
   - Set up Slack/email notifications for failures

5. SECURITY
   - Use read-only credentials for sources
   - Rotate credentials regularly
   - Use SSH tunnels for databases not on public internet
   - Enable TLS for all database connections
   - Store secrets in a vault, not Airbyte config

6. SCALING
   - Vertical: increase worker CPU/memory for large syncs
   - Horizontal: multiple workers in Kubernetes
   - Temporal: stagger sync schedules to avoid peaks
   - Network: place Airbyte in same region as sources/destinations

7. COST OPTIMIZATION (Cloud)
   - Use incremental syncs (fewer rows = lower cost)
   - Sync only needed streams and columns
   - Increase sync interval for non-critical data
   - Archive old data in source before initial sync

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Airbyte - Open-Source Data Integration Reference

Commands:
  intro           Platform overview and comparison
  deploy          Docker, Kubernetes, and Cloud deployment
  connectors      Popular sources and destinations
  connections     Sync modes, scheduling, namespaces
  cdc             Change Data Capture setup and best practices
  api             REST API, Terraform, and Octavia CLI
  troubleshoot    Common issues and diagnostic commands
  best-practices  Production deployment recommendations

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)           cmd_intro ;;
  deploy)          cmd_deploy ;;
  connectors)      cmd_connectors ;;
  connections)     cmd_connections ;;
  cdc)             cmd_cdc ;;
  api)             cmd_api ;;
  troubleshoot)    cmd_troubleshoot ;;
  best-practices)  cmd_best_practices ;;
  help|*)          show_help ;;
esac
