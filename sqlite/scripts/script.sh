#!/bin/bash
# SQLite - Embedded SQL Database Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              SQLITE REFERENCE                               ║
║          The Most Used Database in the World                ║
╚══════════════════════════════════════════════════════════════╝

SQLite is a self-contained, serverless, zero-configuration SQL
database engine. It's embedded in every smartphone, browser,
and most applications.

WHERE SQLITE IS USED:
  Every iPhone/Android  Contact, messages, photos metadata
  Every browser         Cookies, history, bookmarks
  Every OS              System databases
  Embedded devices      IoT, automotive, avionics
  Application data      Desktop apps, Electron, games
  Development           Prototyping, testing, local dev

SQLITE LIMITS:
  Max DB size          281 TB
  Max row size         1 GB
  Max columns          2000
  Max SQL length       1 billion bytes
  Concurrent readers   Unlimited
  Concurrent writers   1 (WAL mode helps)

WHEN TO USE / NOT USE:
  ✅ Embedded/mobile/desktop apps
  ✅ Testing and prototyping
  ✅ Small-to-medium websites (< 100K hits/day)
  ✅ Data analysis and exploration
  ✅ Application file format
  ❌ High-write concurrency
  ❌ Client-server applications
  ❌ Very large datasets (> 1 TB)
  ❌ Replication needed

CLI:
  sqlite3 mydb.db               # Open/create database
  sqlite3 :memory:              # In-memory database
  .help                          # Show all dot commands
  .tables                        # List tables
  .schema                        # Show all CREATE statements
  .schema tablename              # Show one table schema
  .mode column                   # Column output mode
  .headers on                    # Show column headers
  .quit                          # Exit
EOF
}

cmd_sql() {
cat << 'EOF'
SQL FEATURES
==============

DDL:
  CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT UNIQUE,
      age INTEGER CHECK(age >= 0),
      created_at TEXT DEFAULT (datetime('now')),
      bio TEXT DEFAULT ''
  );

  CREATE TABLE posts (
      id INTEGER PRIMARY KEY,
      user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
      title TEXT NOT NULL,
      body TEXT,
      tags TEXT,  -- JSON array stored as text
      created_at TEXT DEFAULT (datetime('now'))
  );

  CREATE INDEX idx_posts_user ON posts(user_id);
  CREATE UNIQUE INDEX idx_users_email ON users(email);

DATA TYPES (flexible typing):
  INTEGER    Whole numbers (1, 2, 8 byte)
  REAL       Floating point (8 byte IEEE)
  TEXT       UTF-8/16 string
  BLOB       Binary data
  NULL       Null value
  -- SQLite uses "type affinity" — stores what you give it

JSON (built-in since 3.38):
  -- Store JSON
  INSERT INTO posts (tags) VALUES ('["python","sql","data"]');

  -- Query JSON
  SELECT json_extract(tags, '$[0]') FROM posts;        -- "python"
  SELECT * FROM posts WHERE json_extract(tags, '$[0]') = 'python';

  -- json_each (expand array)
  SELECT p.title, j.value AS tag
  FROM posts p, json_each(p.tags) j;

  -- json_object / json_array
  SELECT json_object('name', name, 'age', age) FROM users;

WINDOW FUNCTIONS:
  SELECT name, salary,
      RANK() OVER (ORDER BY salary DESC) AS rank,
      SUM(salary) OVER () AS total,
      salary * 100.0 / SUM(salary) OVER () AS pct,
      AVG(salary) OVER (
          ORDER BY hire_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
      ) AS moving_avg
  FROM employees;

CTE (Common Table Expressions):
  WITH RECURSIVE countdown(n) AS (
      SELECT 10
      UNION ALL
      SELECT n - 1 FROM countdown WHERE n > 0
  )
  SELECT n FROM countdown;

  -- Hierarchical query
  WITH RECURSIVE tree AS (
      SELECT id, name, parent_id, 0 AS depth
      FROM categories WHERE parent_id IS NULL
      UNION ALL
      SELECT c.id, c.name, c.parent_id, t.depth + 1
      FROM categories c JOIN tree t ON c.parent_id = t.id
  )
  SELECT * FROM tree ORDER BY depth, name;

UPSERT:
  INSERT INTO users (email, name)
  VALUES ('a@b.com', 'Alice')
  ON CONFLICT(email) DO UPDATE SET name = excluded.name;

FTS5 (Full-Text Search):
  CREATE VIRTUAL TABLE docs_fts USING fts5(title, body);
  INSERT INTO docs_fts SELECT title, body FROM documents;
  SELECT * FROM docs_fts WHERE docs_fts MATCH 'python AND database';
  SELECT * FROM docs_fts WHERE docs_fts MATCH 'NEAR(python sqlite)';
  SELECT highlight(docs_fts, 0, '<b>', '</b>') FROM docs_fts WHERE docs_fts MATCH 'sqlite';
EOF
}

cmd_python() {
cat << 'EOF'
PYTHON & PERFORMANCE
======================

PYTHON (stdlib — no install needed):
  import sqlite3

  # Connect
  con = sqlite3.connect("mydb.db")
  con = sqlite3.connect(":memory:")         # In-memory

  # Row factory (access by column name)
  con.row_factory = sqlite3.Row

  cur = con.cursor()

  # Execute
  cur.execute("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, name TEXT)")
  cur.execute("INSERT INTO users (name) VALUES (?)", ("Alice",))
  con.commit()

  # Query
  cur.execute("SELECT * FROM users WHERE name = ?", ("Alice",))
  row = cur.fetchone()
  rows = cur.fetchall()

  # Executemany (batch insert)
  data = [("Bob",), ("Charlie",), ("Diana",)]
  cur.executemany("INSERT INTO users (name) VALUES (?)", data)
  con.commit()

  # Context manager
  with sqlite3.connect("mydb.db") as con:
      con.execute("INSERT INTO users (name) VALUES (?)", ("Eve",))
      # Auto-commits on exit

PRAGMAS (performance tuning):
  PRAGMA journal_mode = WAL;        -- Write-Ahead Logging (concurrent reads!)
  PRAGMA synchronous = NORMAL;      -- Faster writes (slight risk)
  PRAGMA cache_size = -64000;       -- 64MB cache (default 2MB)
  PRAGMA mmap_size = 268435456;     -- Memory-map 256MB
  PRAGMA temp_store = MEMORY;       -- Temp tables in RAM
  PRAGMA foreign_keys = ON;         -- Enable FK constraints (off by default!)
  PRAGMA busy_timeout = 5000;       -- Wait 5s on lock instead of failing

  -- Check integrity
  PRAGMA integrity_check;
  PRAGMA quick_check;

  -- Database info
  PRAGMA page_size;
  PRAGMA page_count;
  PRAGMA database_list;
  PRAGMA table_info(users);
  PRAGMA index_list(users);

BACKUP:
  sqlite3 mydb.db ".backup backup.db"
  sqlite3 mydb.db ".dump" > backup.sql

  -- Online backup (Python)
  src = sqlite3.connect("mydb.db")
  dst = sqlite3.connect("backup.db")
  src.backup(dst)

CLI IMPORT/EXPORT:
  .mode csv
  .import data.csv tablename

  .headers on
  .mode csv
  .output export.csv
  SELECT * FROM users;
  .output stdout

EXTENSIONS:
  .load /path/to/extension
  -- Popular: spatialite (GIS), sqlean (stats, regexp, crypto)

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
SQLite - Embedded SQL Database Reference

Commands:
  intro    Overview, limits, CLI
  sql      DDL, JSON, window functions, CTE, FTS5
  python   Python stdlib, pragmas, backup, import

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)  cmd_intro ;;
  sql)    cmd_sql ;;
  python) cmd_python ;;
  help|*) show_help ;;
esac
