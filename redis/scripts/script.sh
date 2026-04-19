#!/usr/bin/env bash
# redis — Redis command reference and connection tester
set -euo pipefail

CMD="${1:-help}"
shift || true
ARG1="${1:-localhost}"
ARG2="${2:-6379}"

show_help() {
    echo "redis — Redis command reference and connection tester"
    echo ""
    echo "Usage:"
    echo "  redis cheatsheet [category]     Browse Redis commands"
    echo "  redis test [host] [port]        Test Redis connection"
    echo "  redis monitor [host] [port]     Show instance statistics"
    echo ""
    echo "Categories: string list hash set zset key server scripting"
}

cmd_cheatsheet() {
    local cat="${1:-all}"
    case "$cat" in
        string|str)
            echo "=== String Commands ==="
            echo "  SET key value [EX seconds]   Set key with optional expiry"
            echo "  GET key                      Get value"
            echo "  MSET k1 v1 k2 v2            Set multiple keys"
            echo "  MGET k1 k2                  Get multiple values"
            echo "  INCR key                     Increment integer value"
            echo "  INCRBY key n                 Increment by n"
            echo "  APPEND key value             Append to string"
            echo "  STRLEN key                   Get string length"
            echo "  GETSET key value             Set and return old value"
            echo "  SETNX key value              Set only if not exists"
            ;;
        list)
            echo "=== List Commands ==="
            echo "  LPUSH key val [val...]       Push to head"
            echo "  RPUSH key val [val...]       Push to tail"
            echo "  LPOP key [count]             Pop from head"
            echo "  RPOP key [count]             Pop from tail"
            echo "  LRANGE key start stop        Get range (0 -1 = all)"
            echo "  LLEN key                     Get list length"
            echo "  LINDEX key index             Get element at index"
            echo "  LINSERT key BEFORE|AFTER p v Insert relative to pivot"
            echo "  BLPOP key timeout            Blocking pop"
            ;;
        hash)
            echo "=== Hash Commands ==="
            echo "  HSET key field value         Set field"
            echo "  HGET key field               Get field"
            echo "  HMSET key f1 v1 f2 v2        Set multiple fields"
            echo "  HMGET key f1 f2              Get multiple fields"
            echo "  HGETALL key                  Get all fields and values"
            echo "  HDEL key field [field...]    Delete fields"
            echo "  HEXISTS key field            Check if field exists"
            echo "  HKEYS key                    Get all field names"
            echo "  HVALS key                    Get all values"
            echo "  HLEN key                     Count fields"
            echo "  HINCRBY key field n          Increment field by n"
            ;;
        set)
            echo "=== Set Commands ==="
            echo "  SADD key member [member...]  Add members"
            echo "  SREM key member [member...]  Remove members"
            echo "  SMEMBERS key                 Get all members"
            echo "  SISMEMBER key member         Check membership"
            echo "  SCARD key                    Count members"
            echo "  SUNION k1 k2                 Union of sets"
            echo "  SINTER k1 k2                 Intersection"
            echo "  SDIFF k1 k2                  Difference"
            echo "  SPOP key [count]             Remove random member"
            ;;
        zset|sorted)
            echo "=== Sorted Set Commands ==="
            echo "  ZADD key score member        Add with score"
            echo "  ZRANGE key start stop [WITHSCORES]  Get range by rank"
            echo "  ZRANGEBYSCORE key min max    Get range by score"
            echo "  ZRANK key member             Get rank"
            echo "  ZSCORE key member            Get score"
            echo "  ZREM key member [member...]  Remove members"
            echo "  ZCARD key                    Count members"
            echo "  ZINCRBY key n member         Increment score"
            echo "  ZREVRANGE key start stop     Get range reversed"
            ;;
        key|keys)
            echo "=== Key Commands ==="
            echo "  KEYS pattern                 Find keys (use SCAN in prod)"
            echo "  SCAN cursor [MATCH p] [COUNT n]  Iterate keys safely"
            echo "  EXISTS key [key...]          Check existence"
            echo "  DEL key [key...]             Delete keys"
            echo "  UNLINK key [key...]          Async delete"
            echo "  EXPIRE key seconds           Set TTL"
            echo "  EXPIREAT key timestamp       Expire at Unix time"
            echo "  TTL key                      Remaining TTL in seconds"
            echo "  PERSIST key                  Remove TTL"
            echo "  TYPE key                     Get value type"
            echo "  RENAME key newkey            Rename key"
            ;;
        server)
            echo "=== Server Commands ==="
            echo "  INFO [section]               Server information"
            echo "  DBSIZE                       Number of keys in db"
            echo "  FLUSHDB                      Delete all keys in db"
            echo "  FLUSHALL                     Delete all keys all dbs"
            echo "  SELECT index                 Switch database (0-15)"
            echo "  CONFIG GET parameter         Get config value"
            echo "  CONFIG SET param value       Set config value"
            echo "  BGSAVE                       Save snapshot async"
            echo "  LASTSAVE                     Timestamp of last save"
            echo "  MONITOR                      Stream commands (debug)"
            echo "  SLOWLOG GET [n]              Get slow queries"
            ;;
        scripting|lua)
            echo "=== Scripting Commands ==="
            echo "  EVAL script numkeys k.. a.. Execute Lua script"
            echo "  EVALSHA sha numkeys k.. a.. Execute cached script"
            echo "  SCRIPT LOAD script           Cache script, return SHA"
            echo "  SCRIPT EXISTS sha [sha..]    Check if scripts cached"
            echo "  SCRIPT FLUSH                 Clear script cache"
            echo ""
            echo "  Lua example:"
            echo "    EVAL \"return redis.call('get', KEYS[1])\" 1 mykey"
            ;;
        all|*)
            echo "Redis Command Categories — use: redis cheatsheet <category>"
            echo ""
            echo "  string    SET GET INCR APPEND STRLEN SETNX"
            echo "  list      LPUSH RPUSH LPOP RPOP LRANGE LLEN"
            echo "  hash      HSET HGET HMSET HGETALL HDEL HKEYS"
            echo "  set       SADD SMEMBERS SINTER SUNION SDIFF"
            echo "  zset      ZADD ZRANGE ZRANK ZSCORE ZINCRBY"
            echo "  key       KEYS SCAN EXISTS DEL EXPIRE TTL TYPE"
            echo "  server    INFO DBSIZE CONFIG BGSAVE SLOWLOG"
            echo "  scripting EVAL EVALSHA SCRIPT"
            echo ""
            echo "Run 'redis cheatsheet <category>' for detailed commands"
            ;;
    esac
}

cmd_test() {
    local host="$ARG1"
    local port="$ARG2"
    echo "Testing Redis connection: $host:$port"
    echo ""
    if ! command -v redis-cli &>/dev/null; then
        echo "⚠️  redis-cli not found. Install: apt-get install redis-tools"
        echo "   Connection test skipped. Use 'redis cheatsheet' for command reference."
        exit 0
    fi
    if redis-cli -h "$host" -p "$port" PING 2>/dev/null | grep -q PONG; then
        echo "✅ Connected successfully"
        echo ""
        redis-cli -h "$host" -p "$port" INFO server 2>/dev/null | grep -E "redis_version|uptime_in_days|os:" || true
    else
        echo "❌ Connection failed to $host:$port"
        echo "   Check: is Redis running? (systemctl status redis)"
        echo "   Check: firewall rules, bind address in redis.conf"
    fi
}

cmd_monitor() {
    local host="$ARG1"
    local port="$ARG2"
    echo "Redis Stats: $host:$port"
    echo ""
    if ! command -v redis-cli &>/dev/null; then
        echo "⚠️  redis-cli not found. Install: apt-get install redis-tools"
        exit 0
    fi
    if ! redis-cli -h "$host" -p "$port" PING 2>/dev/null | grep -q PONG; then
        echo "❌ Cannot connect to $host:$port"
        exit 1
    fi
    echo "📊 Key Statistics:"
    redis-cli -h "$host" -p "$port" DBSIZE 2>/dev/null | awk '{print "  Total keys: " $1}'
    echo ""
    echo "💾 Memory:"
    redis-cli -h "$host" -p "$port" INFO memory 2>/dev/null | grep -E "used_memory_human|maxmemory_human" | sed 's/^/  /'
    echo ""
    echo "🔌 Clients:"
    redis-cli -h "$host" -p "$port" INFO clients 2>/dev/null | grep "connected_clients" | sed 's/^/  /'
    echo ""
    echo "⚡ Stats:"
    redis-cli -h "$host" -p "$port" INFO stats 2>/dev/null | grep -E "total_commands_processed|instantaneous_ops_per_sec" | sed 's/^/  /'
}

case "$CMD" in
    cheatsheet|cs|ref) cmd_cheatsheet "${1:-all}" ;;
    test|ping|connect) cmd_test ;;
    monitor|stats|info) cmd_monitor ;;
    help|--help|-h) show_help ;;
    *) echo "Unknown command: $CMD"; show_help; exit 1 ;;
esac
