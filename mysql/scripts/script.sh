#!/bin/bash
# MySQL - Relational Database Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              MYSQL REFERENCE                                ║
║          The World's Most Popular Open-Source RDBMS          ║
╚══════════════════════════════════════════════════════════════╝

MySQL is the world's most popular open-source relational
database, powering WordPress, Facebook, Twitter, and millions
of applications.

MYSQL 8.x KEY FEATURES:
  Window functions     ROW_NUMBER, RANK, DENSE_RANK, etc.
  CTEs                 WITH RECURSIVE
  JSON support         Native JSON type + functions
  Invisible columns    Hidden from SELECT *
  CHECK constraints    Now enforced (unlike 5.x)
  Roles                Fine-grained access control
  InnoDB Cluster       Built-in HA
  Clone plugin         Fast replica provisioning

STORAGE ENGINES:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ InnoDB   │ MyISAM   │ Memory   │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Transactions │ Yes      │ No       │ No       │
  │ Row locking  │ Yes      │ Table    │ Table    │
  │ Foreign keys │ Yes      │ No       │ No       │
  │ Crash safe   │ Yes      │ No       │ No       │
  │ Full-text    │ Yes      │ Yes      │ No       │
  │ Speed (read) │ Fast     │ Faster   │ Fastest  │
  │ Default      │ Yes(8.x) │ Legacy   │ Temp     │
  └──────────────┴──────────┴──────────┴──────────┘
  Always use InnoDB unless you have a specific reason not to.

CONNECT:
  mysql -u root -p
  mysql -h hostname -u user -p database
  mysql -u root -p -e "SELECT 1"    # One-shot
EOF
}

cmd_queries() {
cat << 'EOF'
SQL & JSON
============

JSON TYPE (native):
  CREATE TABLE events (
      id BIGINT AUTO_INCREMENT PRIMARY KEY,
      data JSON NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

  INSERT INTO events (data) VALUES
  ('{"type":"click","page":"/home","user_id":42}');

  -- Extract
  SELECT data->>'$.type' AS event_type,
         data->>'$.page' AS page,
         JSON_EXTRACT(data, '$.user_id') AS uid
  FROM events;

  -- Search
  SELECT * FROM events
  WHERE data->>'$.type' = 'click';

  -- JSON functions
  SELECT JSON_KEYS(data) FROM events;
  SELECT JSON_LENGTH(data) FROM events;
  SELECT JSON_CONTAINS(data, '"click"', '$.type') FROM events;
  SELECT JSON_ARRAY(1, 2, 3);
  SELECT JSON_OBJECT('name', name, 'age', age) FROM users;

  -- Generated column from JSON
  ALTER TABLE events
  ADD event_type VARCHAR(50) GENERATED ALWAYS AS (data->>'$.type') STORED;
  CREATE INDEX idx_event_type ON events(event_type);

WINDOW FUNCTIONS:
  SELECT name, department, salary,
      ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS rn,
      RANK() OVER (ORDER BY salary DESC) AS overall_rank,
      SUM(salary) OVER (PARTITION BY department) AS dept_total,
      LAG(salary) OVER (ORDER BY hire_date) AS prev_salary,
      LEAD(salary) OVER (ORDER BY hire_date) AS next_salary,
      NTH_VALUE(salary, 1) OVER (
          PARTITION BY department ORDER BY salary DESC
          ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
      ) AS top_salary
  FROM employees;

CTE:
  WITH RECURSIVE org_chart AS (
      SELECT id, name, manager_id, 1 AS level
      FROM employees WHERE manager_id IS NULL
      UNION ALL
      SELECT e.id, e.name, e.manager_id, o.level + 1
      FROM employees e JOIN org_chart o ON e.manager_id = o.id
  )
  SELECT REPEAT('  ', level - 1) || name AS tree, level
  FROM org_chart ORDER BY level, name;

FULL-TEXT SEARCH:
  ALTER TABLE articles ADD FULLTEXT INDEX ft_idx (title, body);
  SELECT *, MATCH(title, body) AGAINST('mysql performance' IN NATURAL LANGUAGE MODE) AS score
  FROM articles
  WHERE MATCH(title, body) AGAINST('mysql performance' IN NATURAL LANGUAGE MODE);

  -- Boolean mode
  WHERE MATCH(title) AGAINST('+mysql -postgresql' IN BOOLEAN MODE);

UPSERT:
  INSERT INTO users (email, name, login_count)
  VALUES ('a@b.com', 'Alice', 1)
  ON DUPLICATE KEY UPDATE
      name = VALUES(name),
      login_count = login_count + 1;
EOF
}

cmd_admin() {
cat << 'EOF'
ADMIN & PERFORMANCE
=====================

USER MANAGEMENT:
  CREATE USER 'app'@'%' IDENTIFIED BY 'strong_password';
  GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.* TO 'app'@'%';
  GRANT ALL PRIVILEGES ON mydb.* TO 'admin'@'localhost';
  REVOKE DELETE ON mydb.* FROM 'app'@'%';
  FLUSH PRIVILEGES;

  -- Roles (MySQL 8+)
  CREATE ROLE 'reader', 'writer';
  GRANT SELECT ON mydb.* TO 'reader';
  GRANT INSERT, UPDATE, DELETE ON mydb.* TO 'writer';
  GRANT 'reader', 'writer' TO 'app'@'%';
  SET DEFAULT ROLE ALL TO 'app'@'%';

PERFORMANCE:
  -- Explain query plan
  EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'x@y.com';

  -- Index tips
  -- Leftmost prefix rule for composite indexes
  CREATE INDEX idx_name_age ON users(last_name, first_name, age);
  -- This index helps: WHERE last_name = 'Smith'
  -- This index helps: WHERE last_name = 'Smith' AND first_name = 'John'
  -- This index does NOT help: WHERE first_name = 'John' (skips leftmost)

  -- Covering index (no table lookup needed)
  CREATE INDEX idx_covering ON orders(user_id, status, total);

  -- Slow query log
  SET GLOBAL slow_query_log = 'ON';
  SET GLOBAL long_query_time = 1;  -- Seconds
  SET GLOBAL log_queries_not_using_indexes = 'ON';

  -- Process list
  SHOW PROCESSLIST;
  KILL <process_id>;

  -- Status
  SHOW GLOBAL STATUS LIKE 'Threads%';
  SHOW GLOBAL STATUS LIKE 'Questions';
  SHOW ENGINE INNODB STATUS\G

  -- Buffer pool (most important tuning)
  SET GLOBAL innodb_buffer_pool_size = 4294967296;  -- 4GB (70-80% of RAM)

BACKUP:
  # Logical backup
  mysqldump -u root -p --all-databases > full_backup.sql
  mysqldump -u root -p mydb users posts > partial.sql
  mysqldump -u root -p --single-transaction mydb > consistent.sql

  # Restore
  mysql -u root -p mydb < backup.sql

  # Physical backup (faster for large DBs)
  # Use mysqlbackup (Enterprise) or Percona XtraBackup

REPLICATION:
  -- Source (primary)
  SET GLOBAL server_id = 1;
  CREATE USER 'repl'@'%' IDENTIFIED BY 'password';
  GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';

  -- Replica
  CHANGE REPLICATION SOURCE TO
      SOURCE_HOST='primary',
      SOURCE_USER='repl',
      SOURCE_PASSWORD='password',
      SOURCE_AUTO_POSITION=1;
  START REPLICA;
  SHOW REPLICA STATUS\G

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
MySQL - Relational Database Reference

Commands:
  intro    Overview, engines, features
  queries  JSON, window functions, CTE, FTS, upsert
  admin    Users, performance, backup, replication

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)   cmd_intro ;;
  queries) cmd_queries ;;
  admin)   cmd_admin ;;
  help|*)  show_help ;;
esac
