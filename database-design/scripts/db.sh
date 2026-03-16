#!/usr/bin/env bash
# Database Design Helper - Generates SQL schemas, ER diagrams, and indexes
# Usage: db.sh <command> [options]
set -euo pipefail

DATE=$(date +"%Y-%m-%d")

show_help() {
  cat <<'EOF'
Database Design Helper - 数据库设计助手

Commands:
  schema --table <name> --fields "field1:type,field2:type,..."
      Generate CREATE TABLE statement

  er-diagram --tables "table1,table2,table3"
      Generate a text-based ER diagram

  index --table <name> --fields "field1,field2" [--unique] [--name <index_name>]
      Generate CREATE INDEX statement

  seed --table <name> --fields "field1:type,field2:type" [--rows 10]
      Generate INSERT statements with sample data

  migration --table <name> --action <add|drop|modify> --field "name:type"
      Generate ALTER TABLE migration

  help
      Show this help message

Field Types:
  int, bigint, varchar, text, boolean, date, datetime, timestamp,
  decimal, float, json, uuid, enum(val1|val2|val3)

Options:
  --table    Table name
  --fields   Comma-separated field definitions (name:type)
  --tables   Comma-separated table names (for ER diagram)
  --unique   Create unique index
  --name     Custom index name
  --rows     Number of sample rows to generate (default: 5)
  --engine   Database engine: mysql, postgres, sqlite (default: mysql)
EOF
}

TABLE=""
FIELDS=""
TABLES=""
UNIQUE=""
INDEX_NAME=""
ROWS=5
ENGINE="mysql"
ACTION=""
FIELD=""

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --table) TABLE="$2"; shift 2 ;;
      --fields) FIELDS="$2"; shift 2 ;;
      --tables) TABLES="$2"; shift 2 ;;
      --unique) UNIQUE="UNIQUE "; shift ;;
      --name) INDEX_NAME="$2"; shift 2 ;;
      --rows) ROWS="$2"; shift 2 ;;
      --engine) ENGINE="$2"; shift 2 ;;
      --action) ACTION="$2"; shift 2 ;;
      --field) FIELD="$2"; shift 2 ;;
      *) shift ;;
    esac
  done
}

map_type() {
  local field_type="$1"
  local engine="${2:-mysql}"

  case "$engine" in
    postgres)
      case "$field_type" in
        int) echo "INTEGER" ;;
        bigint) echo "BIGINT" ;;
        varchar) echo "VARCHAR(255)" ;;
        text) echo "TEXT" ;;
        boolean) echo "BOOLEAN" ;;
        date) echo "DATE" ;;
        datetime) echo "TIMESTAMP" ;;
        timestamp) echo "TIMESTAMP WITH TIME ZONE" ;;
        decimal) echo "DECIMAL(10,2)" ;;
        float) echo "DOUBLE PRECISION" ;;
        json) echo "JSONB" ;;
        uuid) echo "UUID" ;;
        enum*) echo "VARCHAR(50)" ;;
        *) echo "VARCHAR(255)" ;;
      esac
      ;;
    sqlite)
      case "$field_type" in
        int|bigint) echo "INTEGER" ;;
        varchar|text|uuid) echo "TEXT" ;;
        boolean) echo "INTEGER" ;;
        date|datetime|timestamp) echo "TEXT" ;;
        decimal|float) echo "REAL" ;;
        json) echo "TEXT" ;;
        enum*) echo "TEXT" ;;
        *) echo "TEXT" ;;
      esac
      ;;
    *) # mysql
      case "$field_type" in
        int) echo "INT" ;;
        bigint) echo "BIGINT" ;;
        varchar) echo "VARCHAR(255)" ;;
        text) echo "TEXT" ;;
        boolean) echo "TINYINT(1)" ;;
        date) echo "DATE" ;;
        datetime) echo "DATETIME" ;;
        timestamp) echo "TIMESTAMP" ;;
        decimal) echo "DECIMAL(10,2)" ;;
        float) echo "FLOAT" ;;
        json) echo "JSON" ;;
        uuid) echo "CHAR(36)" ;;
        enum*)
          local vals
          vals=$(echo "$field_type" | sed "s/enum(//;s/)//;s/|/','/g")
          echo "ENUM('${vals}')"
          ;;
        *) echo "VARCHAR(255)" ;;
      esac
      ;;
  esac
}

generate_schema() {
  parse_args "$@"

  if [[ -z "$TABLE" || -z "$FIELDS" ]]; then
    echo "Error: --table and --fields are required"
    echo "Usage: db.sh schema --table users --fields \"id:int,name:varchar,email:varchar\""
    exit 1
  fi

  local auto_increment="AUTO_INCREMENT"
  local engine_suffix=" ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
  local timestamp_default="CURRENT_TIMESTAMP"
  local id_type
  id_type=$(map_type "int" "$ENGINE")

  case "$ENGINE" in
    postgres)
      auto_increment=""
      engine_suffix=""
      ;;
    sqlite)
      auto_increment="AUTOINCREMENT"
      engine_suffix=""
      ;;
  esac

  echo "-- ============================================================"
  echo "-- Table: ${TABLE}"
  echo "-- Generated: ${DATE}"
  echo "-- Engine: ${ENGINE}"
  echo "-- ============================================================"
  echo ""

  if [[ "$ENGINE" == "postgres" ]]; then
    echo "CREATE TABLE IF NOT EXISTS \"${TABLE}\" ("
  else
    echo "CREATE TABLE IF NOT EXISTS \`${TABLE}\` ("
  fi

  # Parse fields
  IFS=',' read -ra field_array <<< "$FIELDS"
  local total=${#field_array[@]}
  local count=0
  local has_id=false

  for field_def in "${field_array[@]}"; do
    local fname ftype
    fname=$(echo "$field_def" | cut -d: -f1 | xargs)
    ftype=$(echo "$field_def" | cut -d: -f2 | xargs)
    local sql_type
    sql_type=$(map_type "$ftype" "$ENGINE")
    count=$((count + 1))

    local nullable="NOT NULL"
    local extra=""

    if [[ "$fname" == "id" ]]; then
      has_id=true
      if [[ "$ENGINE" == "postgres" ]]; then
        sql_type="SERIAL"
        extra=" PRIMARY KEY"
        nullable=""
      else
        extra=" ${auto_increment} PRIMARY KEY"
      fi
    fi

    local comma=","
    # Don't add comma yet - we'll add timestamps and closing

    if [[ "$ENGINE" == "postgres" ]]; then
      echo "    \"${fname}\" ${sql_type} ${nullable}${extra}${comma}"
    else
      echo "    \`${fname}\` ${sql_type} ${nullable}${extra}${comma}"
    fi
  done

  # Add timestamps
  if [[ "$ENGINE" == "postgres" ]]; then
    echo "    \"created_at\" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,"
    echo "    \"updated_at\" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP"
  elif [[ "$ENGINE" == "sqlite" ]]; then
    echo "    \`created_at\` TEXT NOT NULL DEFAULT (datetime('now')),"
    echo "    \`updated_at\` TEXT NOT NULL DEFAULT (datetime('now'))"
  else
    echo "    \`created_at\` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,"
    echo "    \`updated_at\` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"
  fi

  echo ")${engine_suffix};"
  echo ""

  # Add helpful comments
  echo "-- Suggested indexes:"
  for field_def in "${field_array[@]}"; do
    local fname
    fname=$(echo "$field_def" | cut -d: -f1 | xargs)
    if [[ "$fname" == "email" || "$fname" == "username" || "$fname" == "phone" ]]; then
      if [[ "$ENGINE" == "postgres" ]]; then
        echo "-- CREATE UNIQUE INDEX idx_${TABLE}_${fname} ON \"${TABLE}\" (\"${fname}\");"
      else
        echo "-- CREATE UNIQUE INDEX idx_${TABLE}_${fname} ON \`${TABLE}\` (\`${fname}\`);"
      fi
    elif [[ "$fname" == *"_id" || "$fname" == "status" || "$fname" == "type" ]]; then
      if [[ "$ENGINE" == "postgres" ]]; then
        echo "-- CREATE INDEX idx_${TABLE}_${fname} ON \"${TABLE}\" (\"${fname}\");"
      else
        echo "-- CREATE INDEX idx_${TABLE}_${fname} ON \`${TABLE}\` (\`${fname}\`);"
      fi
    fi
  done
}

generate_er_diagram() {
  parse_args "$@"

  if [[ -z "$TABLES" ]]; then
    echo "Error: --tables is required"
    echo "Usage: db.sh er-diagram --tables \"users,orders,products\""
    exit 1
  fi

  IFS=',' read -ra table_array <<< "$TABLES"

  echo "==============================================================="
  echo "  Entity-Relationship Diagram (Text)"
  echo "  Generated: ${DATE}"
  echo "==============================================================="
  echo ""

  # Generate table boxes with common fields
  for tbl in "${table_array[@]}"; do
    tbl=$(echo "$tbl" | xargs)
    local width=45
    local border
    border=$(printf '%*s' $width '' | tr ' ' '─')

    echo "┌${border}┐"
    printf "│ %-$((width - 2))s │\n" "${tbl^^}"
    echo "├${border}┤"

    # Generate sensible default fields based on table name
    printf "│ %-$((width - 2))s │\n" "PK  id            INT (AUTO_INCREMENT)"

    case "$tbl" in
      user*|member*|account*)
        printf "│ %-$((width - 2))s │\n" "    username      VARCHAR(50)"
        printf "│ %-$((width - 2))s │\n" "    email         VARCHAR(255)"
        printf "│ %-$((width - 2))s │\n" "    password_hash VARCHAR(255)"
        printf "│ %-$((width - 2))s │\n" "    phone         VARCHAR(20)"
        printf "│ %-$((width - 2))s │\n" "    avatar_url    VARCHAR(500)"
        printf "│ %-$((width - 2))s │\n" "    status        ENUM(active,disabled)"
        ;;
      order*)
        printf "│ %-$((width - 2))s │\n" "FK  user_id       INT → users.id"
        printf "│ %-$((width - 2))s │\n" "    order_no      VARCHAR(32)"
        printf "│ %-$((width - 2))s │\n" "    total_amount  DECIMAL(10,2)"
        printf "│ %-$((width - 2))s │\n" "    status        ENUM(pending,paid,shipped)"
        printf "│ %-$((width - 2))s │\n" "    payment_method VARCHAR(20)"
        printf "│ %-$((width - 2))s │\n" "    shipping_addr TEXT"
        ;;
      product*|item*)
        printf "│ %-$((width - 2))s │\n" "FK  category_id   INT → categories.id"
        printf "│ %-$((width - 2))s │\n" "    name          VARCHAR(200)"
        printf "│ %-$((width - 2))s │\n" "    description   TEXT"
        printf "│ %-$((width - 2))s │\n" "    price         DECIMAL(10,2)"
        printf "│ %-$((width - 2))s │\n" "    stock         INT"
        printf "│ %-$((width - 2))s │\n" "    sku           VARCHAR(50)"
        printf "│ %-$((width - 2))s │\n" "    status        ENUM(active,inactive)"
        ;;
      categor*)
        printf "│ %-$((width - 2))s │\n" "FK  parent_id     INT → categories.id"
        printf "│ %-$((width - 2))s │\n" "    name          VARCHAR(100)"
        printf "│ %-$((width - 2))s │\n" "    slug          VARCHAR(100)"
        printf "│ %-$((width - 2))s │\n" "    sort_order    INT"
        ;;
      comment*|review*)
        printf "│ %-$((width - 2))s │\n" "FK  user_id       INT → users.id"
        printf "│ %-$((width - 2))s │\n" "FK  product_id    INT → products.id"
        printf "│ %-$((width - 2))s │\n" "    content       TEXT"
        printf "│ %-$((width - 2))s │\n" "    rating        TINYINT"
        ;;
      payment*)
        printf "│ %-$((width - 2))s │\n" "FK  order_id      INT → orders.id"
        printf "│ %-$((width - 2))s │\n" "    amount        DECIMAL(10,2)"
        printf "│ %-$((width - 2))s │\n" "    method        VARCHAR(20)"
        printf "│ %-$((width - 2))s │\n" "    transaction_id VARCHAR(100)"
        printf "│ %-$((width - 2))s │\n" "    status        ENUM(pending,completed)"
        ;;
      *)
        printf "│ %-$((width - 2))s │\n" "    name          VARCHAR(255)"
        printf "│ %-$((width - 2))s │\n" "    description   TEXT"
        printf "│ %-$((width - 2))s │\n" "    status        VARCHAR(20)"
        ;;
    esac

    printf "│ %-$((width - 2))s │\n" "    created_at    TIMESTAMP"
    printf "│ %-$((width - 2))s │\n" "    updated_at    TIMESTAMP"
    echo "└${border}┘"
    echo ""
  done

  # Generate relationships
  echo "───────────────────────────────────────────────"
  echo "  Relationships / 关系"
  echo "───────────────────────────────────────────────"
  echo ""

  # Auto-detect relationships
  local rel_count=0
  for tbl in "${table_array[@]}"; do
    tbl=$(echo "$tbl" | xargs)
    case "$tbl" in
      order*)
        echo "  users ──┤1:N├── orders"
        echo "    (一个用户可以有多个订单)"
        rel_count=$((rel_count + 1))
        ;;
      product*)
        for other in "${table_array[@]}"; do
          other=$(echo "$other" | xargs)
          if [[ "$other" == order* ]]; then
            echo "  orders ──┤N:M├── products (via order_items)"
            echo "    (订单和产品是多对多关系)"
            rel_count=$((rel_count + 1))
          fi
        done
        ;;
      comment*|review*)
        echo "  users ──┤1:N├── ${tbl}"
        echo "    (一个用户可以有多条评论)"
        rel_count=$((rel_count + 1))
        ;;
      payment*)
        echo "  orders ──┤1:1├── payments"
        echo "    (一个订单对应一条支付记录)"
        rel_count=$((rel_count + 1))
        ;;
    esac
  done

  if [[ $rel_count -eq 0 ]]; then
    echo "  (No automatic relationships detected."
    echo "   Add FK fields like user_id, order_id to define relationships.)"
  fi

  echo ""
  echo "───────────────────────────────────────────────"
  echo "  Legend / 图例"
  echo "───────────────────────────────────────────────"
  echo "  PK = Primary Key    FK = Foreign Key"
  echo "  1:1 = One to One    1:N = One to Many"
  echo "  N:M = Many to Many"
  echo "  ──┤├── = Relationship connector"
}

generate_index() {
  parse_args "$@"

  if [[ -z "$TABLE" || -z "$FIELDS" ]]; then
    echo "Error: --table and --fields are required"
    echo "Usage: db.sh index --table users --fields \"email\" [--unique]"
    exit 1
  fi

  local field_list
  field_list=$(echo "$FIELDS" | xargs)

  # Generate index name if not provided
  if [[ -z "$INDEX_NAME" ]]; then
    local sanitized
    sanitized=$(echo "$field_list" | tr ',' '_' | tr -d ' ')
    INDEX_NAME="idx_${TABLE}_${sanitized}"
  fi

  echo "-- ============================================================"
  echo "-- Index: ${INDEX_NAME}"
  echo "-- Table: ${TABLE}"
  echo "-- Fields: ${field_list}"
  echo "-- Generated: ${DATE}"
  echo "-- ============================================================"
  echo ""

  # Format fields for SQL
  local formatted_fields=""
  IFS=',' read -ra idx_fields <<< "$field_list"

  for i in "${!idx_fields[@]}"; do
    local f
    f=$(echo "${idx_fields[$i]}" | xargs)
    if [[ $i -gt 0 ]]; then
      formatted_fields+=", "
    fi
    if [[ "$ENGINE" == "postgres" ]]; then
      formatted_fields+="\"${f}\""
    else
      formatted_fields+="\`${f}\`"
    fi
  done

  if [[ "$ENGINE" == "postgres" ]]; then
    echo "CREATE ${UNIQUE}INDEX ${INDEX_NAME}"
    echo "    ON \"${TABLE}\" (${formatted_fields});"
  else
    echo "CREATE ${UNIQUE}INDEX ${INDEX_NAME}"
    echo "    ON \`${TABLE}\` (${formatted_fields});"
  fi

  echo ""
  echo "-- To drop this index:"
  if [[ "$ENGINE" == "postgres" ]]; then
    echo "-- DROP INDEX IF EXISTS ${INDEX_NAME};"
  else
    echo "-- DROP INDEX ${INDEX_NAME} ON \`${TABLE}\`;"
  fi

  echo ""
  echo "-- To check index usage (MySQL):"
  echo "-- EXPLAIN SELECT * FROM \`${TABLE}\` WHERE ${idx_fields[0]} = 'value';"
  echo "-- SHOW INDEX FROM \`${TABLE}\`;"
}

generate_seed() {
  parse_args "$@"

  if [[ -z "$TABLE" || -z "$FIELDS" ]]; then
    echo "Error: --table and --fields are required"
    echo "Usage: db.sh seed --table users --fields \"id:int,name:varchar,email:varchar\" --rows 10"
    exit 1
  fi

  echo "-- ============================================================"
  echo "-- Seed data for: ${TABLE}"
  echo "-- Generated: ${DATE}"
  echo "-- ============================================================"
  echo ""

  IFS=',' read -ra field_array <<< "$FIELDS"
  local field_names=()
  local field_types=()

  for field_def in "${field_array[@]}"; do
    local fname ftype
    fname=$(echo "$field_def" | cut -d: -f1 | xargs)
    ftype=$(echo "$field_def" | cut -d: -f2 | xargs)
    field_names+=("$fname")
    field_types+=("$ftype")
  done

  # Build field name list
  local names_str=""
  for i in "${!field_names[@]}"; do
    if [[ $i -gt 0 ]]; then names_str+=", "; fi
    names_str+="\`${field_names[$i]}\`"
  done

  echo "INSERT INTO \`${TABLE}\` (${names_str}) VALUES"

  local names=("Alice" "Bob" "Charlie" "Diana" "Eve" "Frank" "Grace" "Henry" "Ivy" "Jack")
  local domains=("example.com" "test.com" "demo.org" "sample.net" "mock.io")

  for row in $(seq 1 "$ROWS"); do
    local values=""
    for i in "${!field_types[@]}"; do
      if [[ $i -gt 0 ]]; then values+=", "; fi
      local fname="${field_names[$i]}"
      local ftype="${field_types[$i]}"
      case "$ftype" in
        int|bigint)
          if [[ "$fname" == "id" ]]; then
            values+="${row}"
          elif [[ "$fname" == *"_id" ]]; then
            values+="$((RANDOM % 5 + 1))"
          else
            values+="$((RANDOM % 1000))"
          fi
          ;;
        varchar|text)
          if [[ "$fname" == "name" || "$fname" == "username" ]]; then
            values+="'${names[$((row - 1)) % ${#names[@]}]}'"
          elif [[ "$fname" == "email" ]]; then
            local n="${names[$((row - 1)) % ${#names[@]}]}"
            local d="${domains[$((row - 1)) % ${#domains[@]}]}"
            values+="'$(echo "$n" | tr '[:upper:]' '[:lower:]')@${d}'"
          elif [[ "$fname" == "phone" ]]; then
            values+="'+1-555-$(printf '%04d' $((RANDOM % 10000)))'"
          elif [[ "$fname" == "status" ]]; then
            local statuses=("active" "inactive" "pending")
            values+="'${statuses[$((RANDOM % 3))]}'"
          else
            values+="'Sample ${fname} ${row}'"
          fi
          ;;
        boolean)
          values+="$((RANDOM % 2))"
          ;;
        date)
          values+="'2024-$(printf '%02d' $((RANDOM % 12 + 1)))-$(printf '%02d' $((RANDOM % 28 + 1)))'"
          ;;
        datetime|timestamp)
          values+="NOW()"
          ;;
        decimal|float)
          values+="$((RANDOM % 1000)).$((RANDOM % 100))"
          ;;
        *)
          values+="'value_${row}'"
          ;;
      esac
    done

    if [[ $row -eq $ROWS ]]; then
      echo "    (${values});"
    else
      echo "    (${values}),"
    fi
  done
}

generate_migration() {
  parse_args "$@"

  if [[ -z "$TABLE" || -z "$ACTION" || -z "$FIELD" ]]; then
    echo "Error: --table, --action, and --field are required"
    echo "Usage: db.sh migration --table users --action add --field \"avatar:varchar\""
    exit 1
  fi

  local fname ftype
  fname=$(echo "$FIELD" | cut -d: -f1 | xargs)
  ftype=$(echo "$FIELD" | cut -d: -f2 -s | xargs)
  local sql_type
  sql_type=$(map_type "${ftype:-varchar}" "$ENGINE")

  echo "-- ============================================================"
  echo "-- Migration: ${ACTION} ${fname} on ${TABLE}"
  echo "-- Generated: ${DATE}"
  echo "-- ============================================================"
  echo ""

  echo "-- Up migration"
  case "$ACTION" in
    add)
      echo "ALTER TABLE \`${TABLE}\` ADD COLUMN \`${fname}\` ${sql_type};"
      ;;
    drop)
      echo "ALTER TABLE \`${TABLE}\` DROP COLUMN \`${fname}\`;"
      ;;
    modify)
      echo "ALTER TABLE \`${TABLE}\` MODIFY COLUMN \`${fname}\` ${sql_type};"
      ;;
    *)
      echo "-- Error: Unknown action '${ACTION}'. Use: add, drop, modify"
      exit 1
      ;;
  esac

  echo ""
  echo "-- Down migration (rollback)"
  case "$ACTION" in
    add)
      echo "ALTER TABLE \`${TABLE}\` DROP COLUMN \`${fname}\`;"
      ;;
    drop)
      echo "-- WARNING: Cannot auto-generate rollback for DROP (data lost)"
      echo "-- ALTER TABLE \`${TABLE}\` ADD COLUMN \`${fname}\` ${sql_type};"
      ;;
    modify)
      echo "-- WARNING: Cannot auto-generate rollback for MODIFY"
      echo "-- ALTER TABLE \`${TABLE}\` MODIFY COLUMN \`${fname}\` <original_type>;"
      ;;
  esac
}

# Main command router
CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in
  schema)
    generate_schema "$@"
    ;;
  er-diagram|er|erd)
    generate_er_diagram "$@"
    ;;
  index|idx)
    generate_index "$@"
    ;;
  seed)
    generate_seed "$@"
    ;;
  migration|migrate)
    generate_migration "$@"
    ;;
  help|--help|-h)
    show_help
    ;;
  *)
    echo "Error: Unknown command '$CMD'"
    echo "Run 'db.sh help' for usage information."
    exit 1
    ;;
esac
