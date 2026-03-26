#!/bin/bash
# MariaDB - MySQL-Compatible Database Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              MARIADB REFERENCE                              ║
║          The MySQL Fork Done Right                          ║
╚══════════════════════════════════════════════════════════════╝

MariaDB is a community-developed fork of MySQL, created by
MySQL's original creator (Monty Widenius). It's the default
MySQL replacement in most Linux distros.

MARIADB vs MYSQL:
  ┌──────────────────┬──────────────┬──────────────┐
  │ Feature          │ MariaDB      │ MySQL 8      │
  ├──────────────────┼──────────────┼──────────────┤
  │ License          │ GPLv2        │ GPL + Prop   │
  │ Governance       │ Community    │ Oracle       │
  │ JSON             │ JSON alias   │ Native type  │
  │ Thread pool      │ Built-in     │ Enterprise   │
  │ Encryption       │ Built-in     │ Enterprise   │
  │ Temporal tables  │ Yes          │ No           │
  │ Sequences        │ Yes          │ No           │
  │ Oracle compat    │ Yes (mode)   │ No           │
  │ Columnstore      │ Yes          │ No           │
  │ Default distro   │ Most Linux   │ Some         │
  └──────────────────┴──────────────┴──────────────┘

UNIQUE FEATURES:
  System versioning  Temporal tables — query data at any point in time
  Sequences          CREATE SEQUENCE (not just AUTO_INCREMENT)
  Columnstore        MariaDB ColumnStore engine for analytics
  Spider engine      Sharding built into the engine layer
  S3 engine          Query data directly from S3
  CONNECT engine     Query CSV, XML, JSON, ODBC as tables
  Oracle mode        SET SQL_MODE='ORACLE' for PL/SQL compatibility
  Encryption         Data-at-rest encryption built-in (not Enterprise-only)
  Thread pool        Built-in connection pooling

INSTALL:
  # Debian/Ubuntu
  sudo apt install mariadb-server
  sudo mariadb-secure-installation

  # RHEL/CentOS
  sudo dnf install mariadb-server
  sudo systemctl start mariadb
EOF
}

cmd_features() {
cat << 'EOF'
MARIADB-SPECIFIC FEATURES
============================

TEMPORAL TABLES (system versioning):
  -- Track all changes automatically
  CREATE TABLE products (
      id INT PRIMARY KEY,
      name VARCHAR(100),
      price DECIMAL(10,2)
  ) WITH SYSTEM VERSIONING;

  -- Update normally
  UPDATE products SET price = 29.99 WHERE id = 1;

  -- Query historical data!
  SELECT * FROM products FOR SYSTEM_TIME AS OF '2026-01-01 00:00:00';
  SELECT * FROM products FOR SYSTEM_TIME BETWEEN '2026-01-01' AND '2026-03-01';
  SELECT * FROM products FOR SYSTEM_TIME ALL;  -- All versions

  -- Application-time periods
  CREATE TABLE contracts (
      id INT,
      customer_id INT,
      rate DECIMAL(10,2),
      valid_from DATE,
      valid_to DATE,
      PERIOD FOR validity(valid_from, valid_to)
  );

SEQUENCES:
  CREATE SEQUENCE order_seq START WITH 1000 INCREMENT BY 1;
  SELECT NEXT VALUE FOR order_seq;
  SELECT NEXTVAL(order_seq);
  ALTER SEQUENCE order_seq RESTART WITH 5000;

CONNECT ENGINE (query external data):
  -- Query CSV file as a table
  CREATE TABLE csv_data (
      name VARCHAR(50),
      value DECIMAL(10,2)
  ) ENGINE=CONNECT TABLE_TYPE=CSV FILE_NAME='/data/input.csv'
  HEADER=1 SEP_CHAR=',';

  SELECT * FROM csv_data WHERE value > 100;

  -- Query JSON file
  CREATE TABLE json_data
  ENGINE=CONNECT TABLE_TYPE=JSON FILE_NAME='/data/input.json';

  -- Query another database via ODBC
  CREATE TABLE remote_users
  ENGINE=CONNECT TABLE_TYPE=ODBC
  CONNECTION='DSN=pgdb;UID=user;PWD=pass'
  SRCDEF='SELECT * FROM users';

SPIDER ENGINE (sharding):
  -- Shard a table across multiple servers
  CREATE TABLE orders (
      id BIGINT PRIMARY KEY,
      user_id INT,
      total DECIMAL(10,2)
  ) ENGINE=SPIDER
  COMMENT='wrapper "mysql", table "orders"'
  PARTITION BY HASH(id) (
      PARTITION p1 COMMENT='host "shard1", port "3306"',
      PARTITION p2 COMMENT='host "shard2", port "3306"'
  );

ENCRYPTION:
  -- Enable at-rest encryption (my.cnf)
  [mariadb]
  plugin_load_add = file_key_management
  file_key_management_filename = /etc/mysql/keys.enc
  file_key_management_filekey = FILE:/etc/mysql/keys.key
  innodb_encrypt_tables = ON
  innodb_encrypt_log = ON
  encrypt_tmp_files = ON

  -- Per-table
  CREATE TABLE secrets (...) ENCRYPTED=YES ENCRYPTION_KEY_ID=1;
EOF
}

cmd_admin() {
cat << 'EOF'
ADMIN & MIGRATION
====================

GALERA CLUSTER (multi-master HA):
  # 3+ nodes, synchronous replication, all nodes writable

  [galera]
  wsrep_on = ON
  wsrep_provider = /usr/lib/galera/libgalera_smm.so
  wsrep_cluster_address = "gpc://node1,node2,node3"
  wsrep_cluster_name = "my_cluster"
  wsrep_node_address = "this_node_ip"
  wsrep_sst_method = mariabackup

  # Bootstrap first node
  galera_new_cluster

  # Join other nodes
  systemctl start mariadb

MAXSCALE (proxy/load balancer):
  # MariaDB MaxScale — query routing, load balancing, failover
  # Automatic read/write splitting
  # Automatic failover promotion

  [ReadWriteSplit-Service]
  type = service
  router = readwritesplit
  servers = db1, db2, db3
  user = maxscale
  password = xxx

MYSQL → MARIADB MIGRATION:
  1. mysqldump from MySQL
  2. Install MariaDB (same datadir works for minor versions)
  3. Import dump
  4. mariadb-upgrade
  5. Update connection strings (mysql → mariadb, same protocol)

  -- Compatibility: 95%+ drop-in replacement
  -- Watch for: JSON type differences, auth plugin, GIS functions

PERFORMANCE:
  -- Thread pool (built-in, not Enterprise)
  [mariadb]
  thread_handling = pool-of-threads
  thread_pool_size = 16

  -- Query cache (still available, removed in MySQL 8)
  query_cache_type = ON
  query_cache_size = 256M

  -- Optimizer hints
  SELECT /*+ NO_RANGE_OPTIMIZATION(t idx) */ * FROM t;
  SELECT /*+ BKA(t1) */ * FROM t1 JOIN t2;

BACKUP:
  mariadb-backup --backup --target-dir=/backup/full
  mariadb-backup --prepare --target-dir=/backup/full
  mariadb-backup --copy-back --target-dir=/backup/full

  # Or logical
  mariadb-dump --all-databases --single-transaction > backup.sql

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
MariaDB - MySQL-Compatible Database Reference

Commands:
  intro      Overview, comparison with MySQL
  features   Temporal tables, sequences, CONNECT, Spider, encryption
  admin      Galera cluster, MaxScale, migration, backup

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  features) cmd_features ;;
  admin)    cmd_admin ;;
  help|*)   show_help ;;
esac
