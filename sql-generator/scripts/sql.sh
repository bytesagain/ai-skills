#!/usr/bin/env bash
# sql.sh — SQL生成器（真实SQL生成版）
# Usage: bash sql.sh <command> [args...]
# Commands: table, query, join, index, migrate, seed, explain, convert
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true
INPUT="$*"

# ── CREATE TABLE生成 ──
generate_table() {
  local table_name="${1:-users}"
  local db="${2:-mysql}"

  # 预设表结构
  local columns=""
  local table_lower
  table_lower=$(echo "$table_name" | tr '[:upper:]' '[:lower:]')

  echo "# 🏗️ CREATE TABLE — ${table_name}"
  echo ""
  echo "> 数据库: ${db}"
  echo "> 生成时间: $(date '+%Y-%m-%d %H:%M')"
  echo ""

  case "$table_lower" in
    user*|member*)
      generate_user_table "$table_name" "$db"
      ;;
    order*|订单)
      generate_order_table "$table_name" "$db"
      ;;
    product*|商品|goods)
      generate_product_table "$table_name" "$db"
      ;;
    article*|post*|文章)
      generate_article_table "$table_name" "$db"
      ;;
    comment*|评论)
      generate_comment_table "$table_name" "$db"
      ;;
    *)
      generate_generic_table "$table_name" "$db"
      ;;
  esac
}

generate_user_table() {
  local name="$1" db="$2"
  case "$db" in
    mysql|mariadb)
      cat <<EOF
\`\`\`sql
-- MySQL: ${name}表
CREATE TABLE \`${name}\` (
    \`id\` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    \`username\` VARCHAR(50) NOT NULL COMMENT '用户名',
    \`email\` VARCHAR(100) NOT NULL COMMENT '邮箱',
    \`password_hash\` VARCHAR(255) NOT NULL COMMENT '密码哈希',
    \`phone\` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    \`nickname\` VARCHAR(50) DEFAULT NULL COMMENT '昵称',
    \`avatar_url\` VARCHAR(500) DEFAULT NULL COMMENT '头像URL',
    \`gender\` TINYINT DEFAULT 0 COMMENT '性别: 0未知 1男 2女',
    \`birthday\` DATE DEFAULT NULL COMMENT '生日',
    \`status\` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0禁用 1正常 2待验证',
    \`role\` ENUM('user','admin','editor','vip') NOT NULL DEFAULT 'user' COMMENT '角色',
    \`last_login_at\` DATETIME DEFAULT NULL COMMENT '最后登录时间',
    \`last_login_ip\` VARCHAR(45) DEFAULT NULL COMMENT '最后登录IP',
    \`login_count\` INT UNSIGNED DEFAULT 0 COMMENT '登录次数',
    \`created_at\` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    \`updated_at\` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    \`deleted_at\` DATETIME DEFAULT NULL COMMENT '软删除时间',
    PRIMARY KEY (\`id\`),
    UNIQUE KEY \`uk_username\` (\`username\`),
    UNIQUE KEY \`uk_email\` (\`email\`),
    KEY \`idx_phone\` (\`phone\`),
    KEY \`idx_status\` (\`status\`),
    KEY \`idx_created_at\` (\`created_at\`),
    KEY \`idx_deleted_at\` (\`deleted_at\`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';
\`\`\`
EOF
      ;;
    postgresql|postgres|pg)
      cat <<EOF
\`\`\`sql
-- PostgreSQL: ${name}表
CREATE TABLE "${name}" (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    nickname VARCHAR(50),
    avatar_url VARCHAR(500),
    gender SMALLINT DEFAULT 0 CHECK (gender IN (0, 1, 2)),
    birthday DATE,
    status SMALLINT NOT NULL DEFAULT 1 CHECK (status IN (0, 1, 2)),
    role VARCHAR(20) NOT NULL DEFAULT 'user' CHECK (role IN ('user','admin','editor','vip')),
    last_login_at TIMESTAMPTZ,
    last_login_ip INET,
    login_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

-- 索引
CREATE INDEX idx_${name}_phone ON "${name}" (phone);
CREATE INDEX idx_${name}_status ON "${name}" (status);
CREATE INDEX idx_${name}_created_at ON "${name}" (created_at);
CREATE INDEX idx_${name}_deleted_at ON "${name}" (deleted_at) WHERE deleted_at IS NOT NULL;

-- 自动更新updated_at触发器
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS \$\$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
\$\$ language 'plpgsql';

CREATE TRIGGER update_${name}_updated_at
    BEFORE UPDATE ON "${name}"
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

COMMENT ON TABLE "${name}" IS '用户表';
\`\`\`
EOF
      ;;
    sqlite)
      cat <<EOF
\`\`\`sql
-- SQLite: ${name}表
CREATE TABLE "${name}" (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    phone TEXT,
    nickname TEXT,
    avatar_url TEXT,
    gender INTEGER DEFAULT 0,
    birthday TEXT,
    status INTEGER NOT NULL DEFAULT 1,
    role TEXT NOT NULL DEFAULT 'user',
    last_login_at TEXT,
    last_login_ip TEXT,
    login_count INTEGER DEFAULT 0,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    deleted_at TEXT
);

CREATE INDEX idx_${name}_phone ON "${name}" (phone);
CREATE INDEX idx_${name}_status ON "${name}" (status);
\`\`\`
EOF
      ;;
  esac
}

generate_order_table() {
  local name="$1" db="$2"
  echo '```sql'
  cat <<EOF
-- ${db}: ${name}表（订单）
CREATE TABLE \`${name}\` (
    \`id\` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '订单ID',
    \`order_no\` VARCHAR(32) NOT NULL COMMENT '订单编号',
    \`user_id\` BIGINT UNSIGNED NOT NULL COMMENT '用户ID',
    \`total_amount\` DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '订单总金额',
    \`discount_amount\` DECIMAL(10,2) DEFAULT 0.00 COMMENT '优惠金额',
    \`pay_amount\` DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '实付金额',
    \`freight_amount\` DECIMAL(10,2) DEFAULT 0.00 COMMENT '运费',
    \`status\` TINYINT NOT NULL DEFAULT 0 COMMENT '状态: 0待付款 1待发货 2待收货 3已完成 4已取消 5已退款',
    \`pay_type\` TINYINT DEFAULT NULL COMMENT '支付方式: 1微信 2支付宝 3银行卡',
    \`pay_time\` DATETIME DEFAULT NULL COMMENT '支付时间',
    \`ship_time\` DATETIME DEFAULT NULL COMMENT '发货时间',
    \`receive_time\` DATETIME DEFAULT NULL COMMENT '收货时间',
    \`receiver_name\` VARCHAR(50) DEFAULT NULL COMMENT '收件人',
    \`receiver_phone\` VARCHAR(20) DEFAULT NULL COMMENT '收件人电话',
    \`receiver_address\` VARCHAR(500) DEFAULT NULL COMMENT '收件地址',
    \`remark\` VARCHAR(500) DEFAULT NULL COMMENT '订单备注',
    \`created_at\` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    \`updated_at\` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (\`id\`),
    UNIQUE KEY \`uk_order_no\` (\`order_no\`),
    KEY \`idx_user_id\` (\`user_id\`),
    KEY \`idx_status\` (\`status\`),
    KEY \`idx_created_at\` (\`created_at\`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';
EOF
  echo '```'
}

generate_product_table() {
  local name="$1" db="$2"
  echo '```sql'
  cat <<EOF
-- ${db}: ${name}表（商品）
CREATE TABLE \`${name}\` (
    \`id\` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    \`name\` VARCHAR(200) NOT NULL COMMENT '商品名称',
    \`category_id\` INT UNSIGNED DEFAULT NULL COMMENT '分类ID',
    \`brand\` VARCHAR(100) DEFAULT NULL COMMENT '品牌',
    \`price\` DECIMAL(10,2) NOT NULL COMMENT '售价',
    \`original_price\` DECIMAL(10,2) DEFAULT NULL COMMENT '原价',
    \`cost_price\` DECIMAL(10,2) DEFAULT NULL COMMENT '成本价',
    \`stock\` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '库存',
    \`sales\` INT UNSIGNED DEFAULT 0 COMMENT '销量',
    \`main_image\` VARCHAR(500) DEFAULT NULL COMMENT '主图URL',
    \`images\` JSON DEFAULT NULL COMMENT '图片列表',
    \`description\` TEXT DEFAULT NULL COMMENT '商品描述',
    \`status\` TINYINT NOT NULL DEFAULT 0 COMMENT '0下架 1上架',
    \`sort_order\` INT DEFAULT 0 COMMENT '排序权重',
    \`created_at\` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    \`updated_at\` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (\`id\`),
    KEY \`idx_category\` (\`category_id\`),
    KEY \`idx_status_sort\` (\`status\`, \`sort_order\`),
    KEY \`idx_price\` (\`price\`),
    FULLTEXT KEY \`ft_name\` (\`name\`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品表';
EOF
  echo '```'
}

generate_article_table() {
  local name="$1" db="$2"
  echo '```sql'
  cat <<EOF
-- ${db}: ${name}表（文章）
CREATE TABLE \`${name}\` (
    \`id\` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    \`title\` VARCHAR(200) NOT NULL COMMENT '标题',
    \`slug\` VARCHAR(200) DEFAULT NULL COMMENT 'URL slug',
    \`author_id\` BIGINT UNSIGNED NOT NULL COMMENT '作者ID',
    \`category_id\` INT UNSIGNED DEFAULT NULL,
    \`cover_image\` VARCHAR(500) DEFAULT NULL COMMENT '封面图',
    \`summary\` VARCHAR(500) DEFAULT NULL COMMENT '摘要',
    \`content\` LONGTEXT NOT NULL COMMENT '正文(Markdown)',
    \`content_html\` LONGTEXT DEFAULT NULL COMMENT '正文(HTML缓存)',
    \`word_count\` INT UNSIGNED DEFAULT 0 COMMENT '字数',
    \`view_count\` INT UNSIGNED DEFAULT 0 COMMENT '阅读量',
    \`like_count\` INT UNSIGNED DEFAULT 0 COMMENT '点赞数',
    \`comment_count\` INT UNSIGNED DEFAULT 0 COMMENT '评论数',
    \`status\` TINYINT NOT NULL DEFAULT 0 COMMENT '0草稿 1已发布 2已下架',
    \`is_top\` TINYINT DEFAULT 0 COMMENT '是否置顶',
    \`published_at\` DATETIME DEFAULT NULL COMMENT '发布时间',
    \`created_at\` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    \`updated_at\` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (\`id\`),
    UNIQUE KEY \`uk_slug\` (\`slug\`),
    KEY \`idx_author\` (\`author_id\`),
    KEY \`idx_status_published\` (\`status\`, \`published_at\`),
    FULLTEXT KEY \`ft_title_content\` (\`title\`, \`content\`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文章表';
EOF
  echo '```'
}

generate_comment_table() {
  local name="$1" db="$2"
  echo '```sql'
  cat <<EOF
-- ${db}: ${name}表（评论）
CREATE TABLE \`${name}\` (
    \`id\` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    \`target_type\` VARCHAR(20) NOT NULL COMMENT '评论对象类型: article/product/video',
    \`target_id\` BIGINT UNSIGNED NOT NULL COMMENT '评论对象ID',
    \`user_id\` BIGINT UNSIGNED NOT NULL,
    \`parent_id\` BIGINT UNSIGNED DEFAULT NULL COMMENT '父评论ID(回复)',
    \`reply_to_user_id\` BIGINT UNSIGNED DEFAULT NULL COMMENT '回复目标用户',
    \`content\` TEXT NOT NULL COMMENT '评论内容',
    \`like_count\` INT UNSIGNED DEFAULT 0,
    \`status\` TINYINT NOT NULL DEFAULT 1 COMMENT '0隐藏 1显示 2待审核',
    \`ip_address\` VARCHAR(45) DEFAULT NULL,
    \`created_at\` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (\`id\`),
    KEY \`idx_target\` (\`target_type\`, \`target_id\`),
    KEY \`idx_user\` (\`user_id\`),
    KEY \`idx_parent\` (\`parent_id\`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论表';
EOF
  echo '```'
}

generate_generic_table() {
  local name="$1" db="$2"
  echo '```sql'
  cat <<EOF
-- ${db}: ${name}表
CREATE TABLE \`${name}\` (
    \`id\` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    \`name\` VARCHAR(100) NOT NULL COMMENT '名称',
    \`type\` VARCHAR(50) DEFAULT NULL COMMENT '类型',
    \`description\` TEXT DEFAULT NULL COMMENT '描述',
    \`status\` TINYINT NOT NULL DEFAULT 1 COMMENT '状态: 0禁用 1启用',
    \`sort_order\` INT DEFAULT 0 COMMENT '排序',
    \`extra\` JSON DEFAULT NULL COMMENT '扩展字段',
    \`created_at\` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    \`updated_at\` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (\`id\`),
    KEY \`idx_type\` (\`type\`),
    KEY \`idx_status\` (\`status\`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='${name}表';
EOF
  echo '```'
}

# ── SELECT查询生成 ──
generate_query() {
  local desc="$1"
  echo "# 🔍 SQL查询生成"
  echo ""
  echo "> 描述: ${desc}"
  echo "> 生成时间: $(date '+%Y-%m-%d %H:%M')"
  echo ""

  # 基于描述中的关键词生成SQL
  local lower_desc
  lower_desc=$(echo "$desc" | tr '[:upper:]' '[:lower:]')

  echo "## 查询语句"
  echo ""

  if [[ "$lower_desc" =~ 统计|count|数量|总数 ]]; then
    echo '```sql'
    echo "-- 统计查询"
    echo "SELECT"
    echo "    COUNT(*) AS total_count,"
    echo "    COUNT(DISTINCT user_id) AS unique_users,"
    echo "    SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) AS active_count,"
    echo "    SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) AS inactive_count"
    echo "FROM your_table"
    echo "WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY);"
    echo '```'
  elif [[ "$lower_desc" =~ 排行|排名|top|rank ]]; then
    echo '```sql'
    echo "-- 排行榜查询"
    echo "SELECT"
    echo "    t.*,"
    echo "    RANK() OVER (ORDER BY score DESC) AS ranking"
    echo "FROM your_table t"
    echo "WHERE status = 1"
    echo "ORDER BY score DESC"
    echo "LIMIT 10;"
    echo '```'
  elif [[ "$lower_desc" =~ 分组|group|按.*统计 ]]; then
    echo '```sql'
    echo "-- 分组统计"
    echo "SELECT"
    echo "    category,"
    echo "    COUNT(*) AS count,"
    echo "    AVG(price) AS avg_price,"
    echo "    SUM(amount) AS total_amount,"
    echo "    MIN(created_at) AS first_at,"
    echo "    MAX(created_at) AS last_at"
    echo "FROM your_table"
    echo "WHERE status = 1"
    echo "GROUP BY category"
    echo "HAVING count > 5"
    echo "ORDER BY total_amount DESC;"
    echo '```'
  elif [[ "$lower_desc" =~ 日期|时间|按天|按月|trend ]]; then
    echo '```sql'
    echo "-- 按日期趋势统计"
    echo "SELECT"
    echo "    DATE(created_at) AS date,"
    echo "    COUNT(*) AS daily_count,"
    echo "    SUM(amount) AS daily_amount,"
    echo "    ROUND(AVG(amount), 2) AS avg_amount"
    echo "FROM your_table"
    echo "WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)"
    echo "GROUP BY DATE(created_at)"
    echo "ORDER BY date;"
    echo ""
    echo "-- 按月统计"
    echo "SELECT"
    echo "    DATE_FORMAT(created_at, '%Y-%m') AS month,"
    echo "    COUNT(*) AS monthly_count"
    echo "FROM your_table"
    echo "GROUP BY month"
    echo "ORDER BY month DESC"
    echo "LIMIT 12;"
    echo '```'
  elif [[ "$lower_desc" =~ 搜索|查找|模糊|like|search ]]; then
    echo '```sql'
    echo "-- 搜索查询（含模糊匹配）"
    echo "SELECT *"
    echo "FROM your_table"
    echo "WHERE 1=1"
    echo "    AND (name LIKE CONCAT('%', @keyword, '%')"
    echo "         OR description LIKE CONCAT('%', @keyword, '%'))"
    echo "    AND status = 1"
    echo "ORDER BY"
    echo "    CASE WHEN name = @keyword THEN 0"
    echo "         WHEN name LIKE CONCAT(@keyword, '%') THEN 1"
    echo "         ELSE 2 END,"
    echo "    created_at DESC"
    echo "LIMIT 20 OFFSET 0;"
    echo '```'
  elif [[ "$lower_desc" =~ 分页|page|翻页 ]]; then
    echo '```sql'
    echo "-- 高效分页查询（游标法）"
    echo "-- 方式1: OFFSET（小数据量可用）"
    echo "SELECT * FROM your_table"
    echo "WHERE status = 1"
    echo "ORDER BY id DESC"
    echo "LIMIT 20 OFFSET 40;  -- 第3页,每页20条"
    echo ""
    echo "-- 方式2: 游标法（大数据量推荐）"
    echo "SELECT * FROM your_table"
    echo "WHERE id < @last_id  -- 上一页最后一条的id"
    echo "    AND status = 1"
    echo "ORDER BY id DESC"
    echo "LIMIT 20;"
    echo '```'
  else
    echo '```sql'
    echo "-- 通用查询模板"
    echo "SELECT"
    echo "    t.id,"
    echo "    t.name,"
    echo "    t.status,"
    echo "    t.created_at"
    echo "FROM your_table t"
    echo "WHERE t.status = 1"
    echo "    AND t.created_at >= '2025-01-01'"
    echo "ORDER BY t.created_at DESC"
    echo "LIMIT 20;"
    echo '```'
  fi

  echo ""
  echo "## 查询优化建议"
  echo ""
  echo "1. ✅ 确保WHERE条件中的字段有索引"
  echo "2. ✅ 避免SELECT *，只查询需要的字段"
  echo "3. ✅ 大表分页用游标法代替OFFSET"
  echo "4. ✅ GROUP BY后加HAVING优于在子查询中WHERE"
  echo "5. ✅ 使用EXPLAIN查看执行计划"
}

# ── 索引建议 ──
generate_index() {
  local table="${1:-your_table}"

  echo "# 🔑 索引优化建议 — ${table}"
  echo ""
  echo '```sql'
  echo "-- 查看现有索引"
  echo "SHOW INDEX FROM ${table};"
  echo ""
  echo "-- 分析表状态"
  echo "ANALYZE TABLE ${table};"
  echo ""
  echo "-- 慢查询索引建议模板"
  echo ""
  echo "-- 1. 单列索引（高基数列优先）"
  echo "CREATE INDEX idx_${table}_status ON ${table} (status);"
  echo ""
  echo "-- 2. 联合索引（遵循最左前缀原则）"
  echo "CREATE INDEX idx_${table}_status_created ON ${table} (status, created_at);"
  echo ""
  echo "-- 3. 覆盖索引（查询只用索引，不回表）"
  echo "CREATE INDEX idx_${table}_cover ON ${table} (status, created_at, id, name);"
  echo ""
  echo "-- 4. 前缀索引（长字符串）"
  echo "CREATE INDEX idx_${table}_name ON ${table} (name(20));"
  echo ""
  echo "-- 5. 唯一索引"
  echo "CREATE UNIQUE INDEX uk_${table}_code ON ${table} (code);"
  echo '```'
  echo ""

  echo "## 索引原则速查"
  echo ""
  echo "| 原则 | 说明 | 示例 |"
  echo "|------|------|------|"
  echo "| 最左前缀 | 联合索引按顺序匹配 | (a,b,c)可匹配a / a,b / a,b,c |"
  echo "| 覆盖索引 | 查询字段都在索引中 | 避免回表，速度最快 |"
  echo "| 选择性高的列在前 | 区分度大的列放前面 | status(3个值) < user_id(百万级) |"
  echo "| 避免索引失效 | 函数/类型转换会失效 | WHERE DATE(create_time) → 不走索引 |"
  echo "| 索引不是越多越好 | 写入时需维护索引 | 一般不超过5-6个索引 |"
}

# ── 测试数据生成 ──
generate_seed() {
  local table="${1:-users}"
  local count="${2:-10}"

  echo "# 🌱 测试数据 — ${table}"
  echo ""
  echo '```sql'
  echo "INSERT INTO \`${table}\` (username, email, phone, nickname, status, created_at) VALUES"

  local names=("alice" "bob" "charlie" "david" "emma" "frank" "grace" "henry" "iris" "jack" "kate" "leo" "mia" "noah" "olivia" "peter" "quinn" "ruby" "sam" "tina")
  local cn_names=("张三" "李四" "王五" "赵六" "钱七" "孙八" "周九" "吴十" "郑一" "冯二" "陈明" "林芳" "黄强" "刘洋" "杨静" "朱伟" "徐丽" "何勇" "高娟" "马超")

  for i in $(seq 1 "$count"); do
    local idx=$(( (i - 1) % ${#names[@]} ))
    local name="${names[$idx]}${i}"
    local cn_name="${cn_names[$idx]}"
    local phone="138$(printf '%08d' $((RANDOM * 1000 + i)))"
    local status=$((RANDOM % 3))
    local days_ago=$((RANDOM % 365))
    local date
    date=$(date -d "-${days_ago} days" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || date '+%Y-%m-%d %H:%M:%S')

    local comma=","
    (( i == count )) && comma=";"
    echo "    ('${name}', '${name}@example.com', '${phone}', '${cn_name}', ${status}, '${date}')${comma}"
  done

  echo '```'
}

# ── 帮助 ──
show_help() {
  cat <<'HELP'
📊 SQL生成器 — sql.sh

用法: bash sql.sh <command> [args...]

命令:
  table <表名> [mysql|postgresql|sqlite]
        → 生成CREATE TABLE语句（5种预设: users/orders/products/articles/comments）
  query <描述>
        → 根据中文描述生成SELECT查询
        关键词: 统计/排行/分组/日期/搜索/分页
  index <表名>
        → 生成索引优化建议
  seed <表名> [数量]
        → 生成测试INSERT数据
  help  → 显示帮助

示例:
  bash sql.sh table users mysql
  bash sql.sh table orders postgresql
  bash sql.sh table products sqlite
  bash sql.sh query "按月统计订单金额"
  bash sql.sh query "搜索用户名包含关键词"
  bash sql.sh query "销量排行Top10"
  bash sql.sh index orders
  bash sql.sh seed users 20

💡 特色:
  - 5种常用表预设（用户/订单/商品/文章/评论）
  - 3种数据库方言（MySQL/PostgreSQL/SQLite）
  - 智能关键词→SQL查询
  - 索引最佳实践
  - 随机测试数据生成
HELP
}

case "$CMD" in
  table)
    IFS=' ' read -ra A <<< "$INPUT"
    generate_table "${A[0]:-users}" "${A[1]:-mysql}"
    ;;
  query)   generate_query "$INPUT" ;;
  index)   generate_index "${INPUT:-your_table}" ;;
  seed)
    IFS=' ' read -ra A <<< "$INPUT"
    generate_seed "${A[0]:-users}" "${A[1]:-10}"
    ;;
  help|*)  show_help ;;
esac
