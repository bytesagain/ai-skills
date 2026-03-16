#!/usr/bin/env bash
# Schema Builder — Powered by BytesAgain
set -euo pipefail

COMMAND="${1:-help}"
ARG="${2:-users}"
BRAND="Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"

case "$COMMAND" in

design)
  python3 - "$ARG" << 'PYEOF'
import sys
name = sys.argv[1] if len(sys.argv) > 1 else "users"

templates = {
    "users": {
        "table": "users",
        "fields": [
            ("id", "BIGINT", "PRIMARY KEY, AUTO_INCREMENT"),
            ("username", "VARCHAR(50)", "NOT NULL, UNIQUE"),
            ("email", "VARCHAR(100)", "NOT NULL, UNIQUE"),
            ("password_hash", "VARCHAR(255)", "NOT NULL"),
            ("avatar_url", "VARCHAR(500)", "NULL"),
            ("role", "ENUM('user','admin','moderator')", "DEFAULT 'user'"),
            ("is_active", "BOOLEAN", "DEFAULT TRUE"),
            ("last_login_at", "DATETIME", "NULL"),
            ("created_at", "DATETIME", "DEFAULT CURRENT_TIMESTAMP"),
            ("updated_at", "DATETIME", "DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"),
        ],
        "indexes": ["idx_users_email (email)", "idx_users_username (username)"],
        "relations": []
    },
    "products": {
        "table": "products",
        "fields": [
            ("id", "BIGINT", "PRIMARY KEY, AUTO_INCREMENT"),
            ("name", "VARCHAR(200)", "NOT NULL"),
            ("slug", "VARCHAR(200)", "NOT NULL, UNIQUE"),
            ("description", "TEXT", "NULL"),
            ("price", "DECIMAL(10,2)", "NOT NULL"),
            ("stock", "INT", "DEFAULT 0"),
            ("category_id", "BIGINT", "FOREIGN KEY -> categories(id)"),
            ("is_published", "BOOLEAN", "DEFAULT FALSE"),
            ("created_at", "DATETIME", "DEFAULT CURRENT_TIMESTAMP"),
            ("updated_at", "DATETIME", "DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"),
        ],
        "indexes": ["idx_products_slug (slug)", "idx_products_category (category_id)"],
        "relations": ["products.category_id -> categories.id"]
    },
    "orders": {
        "table": "orders",
        "fields": [
            ("id", "BIGINT", "PRIMARY KEY, AUTO_INCREMENT"),
            ("order_no", "VARCHAR(32)", "NOT NULL, UNIQUE"),
            ("user_id", "BIGINT", "FOREIGN KEY -> users(id)"),
            ("total_amount", "DECIMAL(12,2)", "NOT NULL"),
            ("status", "ENUM('pending','paid','shipped','completed','cancelled')", "DEFAULT 'pending'"),
            ("shipping_address", "JSON", "NULL"),
            ("paid_at", "DATETIME", "NULL"),
            ("created_at", "DATETIME", "DEFAULT CURRENT_TIMESTAMP"),
            ("updated_at", "DATETIME", "DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"),
        ],
        "indexes": ["idx_orders_user (user_id)", "idx_orders_status (status)", "idx_orders_order_no (order_no)"],
        "relations": ["orders.user_id -> users.id"]
    }
}

schema = templates.get(name, {
    "table": name,
    "fields": [
        ("id", "BIGINT", "PRIMARY KEY, AUTO_INCREMENT"),
        ("name", "VARCHAR(100)", "NOT NULL"),
        ("description", "TEXT", "NULL"),
        ("status", "VARCHAR(20)", "DEFAULT 'active'"),
        ("created_at", "DATETIME", "DEFAULT CURRENT_TIMESTAMP"),
        ("updated_at", "DATETIME", "DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"),
    ],
    "indexes": [],
    "relations": []
})

print("=" * 60)
print("  Schema Design: {}".format(schema["table"]))
print("=" * 60)
print("")
print("{:<20} {:<25} {}".format("Column", "Type", "Constraints"))
print("-" * 60)
for col, dtype, constraints in schema["fields"]:
    print("{:<20} {:<25} {}".format(col, dtype, constraints))
print("")
if schema["indexes"]:
    print("Indexes:")
    for idx in schema["indexes"]:
        print("  - {}".format(idx))
    print("")
if schema["relations"]:
    print("Relations:")
    for rel in schema["relations"]:
        print("  - {}".format(rel))
print("")
print("=" * 60)
PYEOF
  echo "$BRAND"
  ;;

sql)
  python3 - "$ARG" << 'PYEOF'
import sys
name = sys.argv[1] if len(sys.argv) > 1 else "users"

tables = {
    "users": """CREATE TABLE IF NOT EXISTS users (
  id            BIGINT AUTO_INCREMENT PRIMARY KEY,
  username      VARCHAR(50)  NOT NULL UNIQUE,
  email         VARCHAR(100) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  avatar_url    VARCHAR(500) NULL,
  role          ENUM('user', 'admin', 'moderator') DEFAULT 'user',
  is_active     BOOLEAN DEFAULT TRUE,
  last_login_at DATETIME NULL,
  created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  INDEX idx_users_email (email),
  INDEX idx_users_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;""",
    "products": """CREATE TABLE IF NOT EXISTS products (
  id           BIGINT AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(200) NOT NULL,
  slug         VARCHAR(200) NOT NULL UNIQUE,
  description  TEXT NULL,
  price        DECIMAL(10,2) NOT NULL,
  stock        INT DEFAULT 0,
  category_id  BIGINT NULL,
  is_published BOOLEAN DEFAULT FALSE,
  created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  INDEX idx_products_slug (slug),
  INDEX idx_products_category (category_id),
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;""",
    "orders": """CREATE TABLE IF NOT EXISTS orders (
  id             BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_no       VARCHAR(32) NOT NULL UNIQUE,
  user_id        BIGINT NOT NULL,
  total_amount   DECIMAL(12,2) NOT NULL,
  status         ENUM('pending','paid','shipped','completed','cancelled') DEFAULT 'pending',
  shipping_address JSON NULL,
  paid_at        DATETIME NULL,
  created_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at     DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  INDEX idx_orders_user (user_id),
  INDEX idx_orders_status (status),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;"""
}

sql = tables.get(name, """CREATE TABLE IF NOT EXISTS {name} (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(100) NOT NULL,
  description TEXT NULL,
  status      VARCHAR(20) DEFAULT 'active',
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;""".format(name=name))

print("-- Schema Builder: {} table".format(name))
print("-- Generated SQL (MySQL)")
print("")
print(sql)
PYEOF
  echo ""
  echo "-- $BRAND"
  ;;

migrate)
  python3 - "$ARG" << 'PYEOF'
import sys
from datetime import datetime
name = sys.argv[1] if len(sys.argv) > 1 else "users"
ts = datetime.now().strftime("%Y%m%d%H%M%S")

print("""-- Migration: create_{name}_table
-- Timestamp: {ts}

-- ========== UP ==========
CREATE TABLE IF NOT EXISTS {name} (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(100) NOT NULL,
  description TEXT NULL,
  status      VARCHAR(20) DEFAULT 'active',
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO migrations (name, batch) VALUES ('create_{name}_table', 1);

-- ========== DOWN ==========
-- DROP TABLE IF EXISTS {name};
-- DELETE FROM migrations WHERE name = 'create_{name}_table';""".format(name=name, ts=ts))
PYEOF
  echo ""
  echo "-- $BRAND"
  ;;

seed)
  python3 - "$ARG" << 'PYEOF'
import sys, hashlib
name = sys.argv[1] if len(sys.argv) > 1 else "users"

seeds = {
    "users": """INSERT INTO users (username, email, password_hash, role, is_active) VALUES
  ('alice',   'alice@example.com',   '{h1}', 'admin', TRUE),
  ('bob',     'bob@example.com',     '{h2}', 'user',  TRUE),
  ('charlie', 'charlie@example.com', '{h3}', 'user',  TRUE),
  ('diana',   'diana@example.com',   '{h4}', 'moderator', TRUE),
  ('eve',     'eve@example.com',     '{h5}', 'user',  FALSE);""".format(
        h1=hashlib.sha256(b"password123").hexdigest()[:60],
        h2=hashlib.sha256(b"password456").hexdigest()[:60],
        h3=hashlib.sha256(b"password789").hexdigest()[:60],
        h4=hashlib.sha256(b"password000").hexdigest()[:60],
        h5=hashlib.sha256(b"password111").hexdigest()[:60]
    ),
    "products": """INSERT INTO products (name, slug, description, price, stock, is_published) VALUES
  ('Wireless Mouse',     'wireless-mouse',     'Ergonomic wireless mouse',    29.99, 150, TRUE),
  ('Mechanical Keyboard','mechanical-keyboard','RGB mechanical keyboard',     89.99, 80,  TRUE),
  ('USB-C Hub',          'usb-c-hub',          '7-in-1 USB-C adapter',        45.00, 200, TRUE),
  ('Monitor Stand',      'monitor-stand',      'Adjustable monitor riser',    35.50, 60,  FALSE),
  ('Laptop Sleeve',      'laptop-sleeve',      '15-inch neoprene sleeve',     19.99, 300, TRUE);""",
    "orders": """INSERT INTO orders (order_no, user_id, total_amount, status) VALUES
  ('ORD-20240101-001', 1, 119.98, 'completed'),
  ('ORD-20240102-002', 2,  29.99, 'shipped'),
  ('ORD-20240103-003', 3,  89.99, 'paid'),
  ('ORD-20240104-004', 1,  45.00, 'pending'),
  ('ORD-20240105-005', 4,  55.49, 'cancelled');"""
}

sql = seeds.get(name, """INSERT INTO {name} (name, description, status) VALUES
  ('Sample 1', 'First sample record',  'active'),
  ('Sample 2', 'Second sample record', 'active'),
  ('Sample 3', 'Third sample record',  'inactive'),
  ('Sample 4', 'Fourth sample record', 'active'),
  ('Sample 5', 'Fifth sample record',  'archived');""".format(name=name))

print("-- Seed data for: {}".format(name))
print("-- WARNING: Development/testing only!")
print("")
print(sql)
PYEOF
  echo ""
  echo "-- $BRAND"
  ;;

erd)
  python3 - "$ARG" << 'PYEOF'
import sys
name = sys.argv[1] if len(sys.argv) > 1 else "ecommerce"

print("""
============================================================
  ER Diagram: {} System
============================================================

  +-------------------+       +--------------------+
  |      users        |       |    categories       |
  +-------------------+       +--------------------+
  | PK id             |       | PK id               |
  |    username       |       |    name              |
  |    email          |       |    parent_id (FK)    |
  |    password_hash  |       +--------------------+
  |    role           |                |
  |    is_active      |                | 1:N
  +-------------------+                |
         | 1:N              +--------------------+
         |                  |     products        |
         v                  +--------------------+
  +-------------------+     | PK id               |
  |      orders       |     |    name              |
  +-------------------+     |    price             |
  | PK id             |     |    stock             |
  |    order_no       |     | FK category_id       |
  | FK user_id -------+     +--------------------+
  |    total_amount   |                |
  |    status         |                | M:N
  +-------------------+                |
         | 1:N              +--------------------+
         |                  |   order_items       |
         v                  +--------------------+
  +-------------------+     | PK id               |
  |    order_items    |     | FK order_id          |
  +-------------------+     | FK product_id        |
  | PK id             |     |    quantity           |
  | FK order_id ------+     |    unit_price         |
  | FK product_id ----+     +--------------------+
  |    quantity       |
  |    unit_price     |
  +-------------------+

  Relations:
    users      1 ---< N  orders
    orders     1 ---< N  order_items
    products   1 ---< N  order_items
    categories 1 ---< N  products
    categories 1 ---< N  categories (self-referencing)

============================================================""".format(name))
PYEOF
  echo "$BRAND"
  ;;

optimize)
  python3 - "$ARG" << 'PYEOF'
import sys
name = sys.argv[1] if len(sys.argv) > 1 else "users"

print("=" * 60)
print("  Schema Optimization Report: {}".format(name))
print("=" * 60)
print("")
print("[INDEX RECOMMENDATIONS]")
print("  1. Add composite index for common query patterns")
print("     ALTER TABLE {} ADD INDEX idx_status_created (status, created_at);".format(name))
print("  2. Consider covering index for list queries")
print("     ALTER TABLE {} ADD INDEX idx_covering (status, name, created_at);".format(name))
print("")
print("[DATA TYPE OPTIMIZATION]")
print("  1. Use UNSIGNED for auto-increment IDs (doubles max value)")
print("  2. VARCHAR vs TEXT: use VARCHAR for searchable, TEXT for long content")
print("  3. ENUM vs VARCHAR: ENUM saves space but is harder to modify")
print("  4. Use DATETIME over TIMESTAMP for dates beyond 2038")
print("")
print("[PERFORMANCE TIPS]")
print("  1. Enable query cache for read-heavy tables")
print("  2. Partition large tables by date range")
print("  3. Use connection pooling (~10 connections per app instance)")
print("  4. Monitor slow query log (threshold: 1s)")
print("  5. Consider read replicas for reporting queries")
print("")
print("[NORMALIZATION CHECK]")
print("  1. No repeating groups (1NF)              [check]")
print("  2. All non-key cols depend on full PK (2NF)[check]")
print("  3. No transitive dependencies (3NF)       [check]")
print("  4. Denormalize only for proven bottlenecks")
print("")
print("=" * 60)
PYEOF
  echo "$BRAND"
  ;;

nosql)
  python3 - "$ARG" << 'PYEOF'
import sys, json
name = sys.argv[1] if len(sys.argv) > 1 else "users"

schemas = {
    "users": {
        "collection": "users",
        "schema": {
            "_id": "ObjectId",
            "username": {"type": "String", "required": True, "unique": True},
            "email": {"type": "String", "required": True, "unique": True},
            "passwordHash": {"type": "String", "required": True},
            "profile": {
                "avatar": "String",
                "bio": "String",
                "social": {"twitter": "String", "github": "String"}
            },
            "role": {"type": "String", "enum": ["user", "admin", "moderator"], "default": "user"},
            "isActive": {"type": "Boolean", "default": True},
            "lastLoginAt": "Date",
            "createdAt": "Date",
            "updatedAt": "Date"
        },
        "indexes": [
            {"fields": {"email": 1}, "options": {"unique": True}},
            {"fields": {"username": 1}, "options": {"unique": True}},
            {"fields": {"role": 1, "isActive": 1}}
        ]
    }
}

schema = schemas.get(name, {
    "collection": name,
    "schema": {
        "_id": "ObjectId",
        "name": {"type": "String", "required": True},
        "data": {"type": "Mixed"},
        "status": {"type": "String", "default": "active"},
        "createdAt": "Date",
        "updatedAt": "Date"
    },
    "indexes": [{"fields": {"status": 1, "createdAt": -1}}]
})

print("// MongoDB Schema: {}".format(name))
print("// Collection: {}".format(schema["collection"]))
print("")
print(json.dumps(schema, indent=2, ensure_ascii=False))
PYEOF
  echo ""
  echo "// $BRAND"
  ;;

compare)
  python3 << 'PYEOF'
print("=" * 60)
print("  Schema Comparison Tool")
print("=" * 60)
print("")
print("  Usage: Provide two schema files to compare")
print("")
print("  Example diff output:")
print("")
print("  Table: users")
print("  + added column:   phone VARCHAR(20)       [NEW]")
print("  ~ changed column: role VARCHAR(20)         [WAS: ENUM]")
print("  - removed column: legacy_field              [DROPPED]")
print("  + added index:    idx_users_phone (phone)  [NEW]")
print("")
print("  Suggested migration:")
print("  ALTER TABLE users ADD COLUMN phone VARCHAR(20);")
print("  ALTER TABLE users MODIFY COLUMN role VARCHAR(20);")
print("  ALTER TABLE users DROP COLUMN legacy_field;")
print("  ALTER TABLE users ADD INDEX idx_users_phone (phone);")
print("")
print("  TIP: Always back up before running migrations!")
print("")
print("=" * 60)
PYEOF
  echo "$BRAND"
  ;;

help|*)
  cat << 'HELPEOF'
╔══════════════════════════════════════════════════╗
║         🗃️  Schema Builder                       ║
╠══════════════════════════════════════════════════╣
║  design   <table>  — Design schema layout        ║
║  sql      <table>  — Generate CREATE TABLE SQL   ║
║  migrate  <table>  — Generate migration script   ║
║  seed     <table>  — Generate seed data          ║
║  erd      [name]   — ASCII ER diagram            ║
║  optimize <table>  — Index & perf suggestions    ║
║  nosql    <name>   — MongoDB schema              ║
║  compare           — Schema diff tool            ║
╚══════════════════════════════════════════════════╝
HELPEOF
  echo "$BRAND"
  ;;

esac
