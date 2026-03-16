#!/usr/bin/env bash
# api.sh — API测试工具（真实HTTP请求版）
# Usage: bash api.sh <command> [args...]
# Commands: get, post, put, delete, test, mock, status, headers, report
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true
INPUT="$*"

# ── 颜色 ──
RED='\033[0;31m'; GRN='\033[0;32m'; YEL='\033[0;33m'; CYN='\033[0;36m'; RST='\033[0m'

# ── HTTP请求核心 ──
http_request() {
  local method="$1"
  local url="$2"
  local data="${3:-}"
  local headers="${4:-}"
  local auth="${5:-}"

  echo "# 🔗 API测试结果"
  echo ""
  echo "> 时间: $(date '+%Y-%m-%d %H:%M:%S')"
  echo ""

  # 构造curl命令
  local curl_cmd="curl -sS -w '\n---HTTP_INFO---\nHTTP_CODE:%{http_code}\nTIME_TOTAL:%{time_total}\nTIME_CONNECT:%{time_connect}\nTIME_STARTTRANSFER:%{time_starttransfer}\nSIZE_DOWNLOAD:%{size_download}\nCONTENT_TYPE:%{content_type}\nREDIRECT_URL:%{redirect_url}' -X ${method}"

  # 添加headers
  if [[ -n "$headers" ]]; then
    IFS=';' read -ra hdr_arr <<< "$headers"
    for h in "${hdr_arr[@]}"; do
      curl_cmd+=" -H '$(echo "$h" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')'"
    done
  fi

  # 添加认证
  if [[ -n "$auth" ]]; then
    if [[ "$auth" == Bearer* ]]; then
      curl_cmd+=" -H 'Authorization: $auth'"
    elif [[ "$auth" == *:* ]]; then
      curl_cmd+=" -u '$auth'"
    else
      curl_cmd+=" -H 'Authorization: Bearer $auth'"
    fi
  fi

  # 添加数据
  if [[ -n "$data" ]]; then
    curl_cmd+=" -H 'Content-Type: application/json' -d '$data'"
  fi

  curl_cmd+=" '${url}'"

  echo "## 📡 请求"
  echo ""
  echo "| 属性 | 值 |"
  echo "|------|-----|"
  echo "| 方法 | \`${method}\` |"
  echo "| URL | \`${url}\` |"
  [[ -n "$data" ]] && echo "| Body | \`${data:0:100}\` |"
  [[ -n "$headers" ]] && echo "| Headers | \`${headers}\` |"
  [[ -n "$auth" ]] && echo "| Auth | \`${auth:0:20}...\` |"
  echo ""

  echo "### cURL命令"
  echo '```bash'
  echo "curl -X ${method} \\"
  [[ -n "$headers" ]] && {
    IFS=';' read -ra hdr_arr <<< "$headers"
    for h in "${hdr_arr[@]}"; do
      echo "  -H '$(echo "$h" | sed 's/^[[:space:]]*//')' \\"
    done
  }
  [[ -n "$data" ]] && echo "  -d '${data}' \\"
  [[ -n "$auth" ]] && echo "  -H 'Authorization: ${auth:0:30}...' \\"
  echo "  '${url}'"
  echo '```'
  echo ""

  # 执行请求
  echo "## 📥 响应"
  echo ""

  local response
  local start_time
  start_time=$(date +%s%N)

  # 构造实际的curl参数数组
  local -a curl_args=(-sS -w '\n---HTTP_INFO---\nHTTP_CODE:%{http_code}\nTIME_TOTAL:%{time_total}\nTIME_CONNECT:%{time_connect}\nTIME_STARTTRANSFER:%{time_starttransfer}\nSIZE_DOWNLOAD:%{size_download}\nCONTENT_TYPE:%{content_type}' -X "$method")

  if [[ -n "$headers" ]]; then
    IFS=';' read -ra hdr_arr <<< "$headers"
    for h in "${hdr_arr[@]}"; do
      curl_args+=(-H "$(echo "$h" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')")
    done
  fi
  [[ -n "$auth" ]] && curl_args+=(-H "Authorization: ${auth}")
  if [[ -n "$data" ]]; then
    curl_args+=(-H "Content-Type: application/json" -d "$data")
  fi
  curl_args+=("$url")

  response=$(curl "${curl_args[@]}" 2>&1) || true

  # 解析响应
  local body info
  body=$(echo "$response" | sed '/---HTTP_INFO---/,$d')
  info=$(echo "$response" | sed -n '/---HTTP_INFO---/,$p')

  local http_code time_total time_connect size_download content_type
  http_code=$(echo "$info" | grep 'HTTP_CODE:' | cut -d: -f2)
  time_total=$(echo "$info" | grep 'TIME_TOTAL:' | cut -d: -f2)
  time_connect=$(echo "$info" | grep 'TIME_CONNECT:' | cut -d: -f2)
  size_download=$(echo "$info" | grep 'SIZE_DOWNLOAD:' | cut -d: -f2)
  content_type=$(echo "$info" | grep 'CONTENT_TYPE:' | cut -d: -f2-)

  # 状态码颜色
  local status_emoji="✅"
  if [[ -n "$http_code" ]]; then
    case "${http_code:0:1}" in
      2) status_emoji="✅" ;;
      3) status_emoji="↪️" ;;
      4) status_emoji="⚠️" ;;
      5) status_emoji="❌" ;;
    esac
  fi

  echo "| 属性 | 值 |"
  echo "|------|-----|"
  echo "| 状态码 | ${status_emoji} ${http_code:-N/A} $(get_status_text "${http_code:-0}") |"
  echo "| 总耗时 | ${time_total:-N/A}s |"
  echo "| 连接耗时 | ${time_connect:-N/A}s |"
  echo "| 响应大小 | ${size_download:-0} bytes |"
  echo "| Content-Type | ${content_type:-N/A} |"
  echo ""

  # 性能评级
  if [[ -n "$time_total" ]]; then
    local perf_grade
    if (( $(echo "$time_total < 0.3" | bc -l 2>/dev/null || echo 0) )); then
      perf_grade="🟢 极快 (<300ms)"
    elif (( $(echo "$time_total < 1" | bc -l 2>/dev/null || echo 0) )); then
      perf_grade="🟡 正常 (<1s)"
    elif (( $(echo "$time_total < 3" | bc -l 2>/dev/null || echo 0) )); then
      perf_grade="🟠 较慢 (<3s)"
    else
      perf_grade="🔴 很慢 (>3s)"
    fi
    echo "**性能评级:** ${perf_grade}"
    echo ""
  fi

  echo "### 响应体"
  echo ""
  if [[ -n "$body" ]]; then
    # 尝试格式化JSON
    local formatted
    formatted=$(echo "$body" | python3 -m json.tool 2>/dev/null) || formatted="$body"
    echo '```json'
    echo "${formatted:0:5000}"
    if (( ${#formatted} > 5000 )); then
      echo "... (截断，总长度: ${#formatted})"
    fi
    echo '```'
  else
    echo "*(空响应)*"
  fi
}

# ── 状态码说明 ──
get_status_text() {
  case "$1" in
    200) echo "OK" ;; 201) echo "Created" ;; 204) echo "No Content" ;;
    301) echo "Moved Permanently" ;; 302) echo "Found" ;; 304) echo "Not Modified" ;;
    400) echo "Bad Request" ;; 401) echo "Unauthorized" ;; 403) echo "Forbidden" ;;
    404) echo "Not Found" ;; 405) echo "Method Not Allowed" ;; 408) echo "Request Timeout" ;;
    409) echo "Conflict" ;; 413) echo "Payload Too Large" ;; 422) echo "Unprocessable Entity" ;;
    429) echo "Too Many Requests" ;;
    500) echo "Internal Server Error" ;; 502) echo "Bad Gateway" ;; 503) echo "Service Unavailable" ;;
    504) echo "Gateway Timeout" ;; *) echo "" ;;
  esac
}

# ── Mock服务器 ──
generate_mock() {
  local endpoint="${1:-/api/users}"
  local method="${2:-GET}"

  echo "# 🎭 Mock数据生成 — ${method} ${endpoint}"
  echo ""

  # 根据endpoint猜测数据结构
  local resource
  resource=$(echo "$endpoint" | sed 's/.*\///' | sed 's/s$//')

  cat <<EOF
## 模拟响应

### 成功响应 (200)
\`\`\`json
{
  "code": 200,
  "message": "success",
  "data": {
    "${resource}s": [
      {
        "id": $(shuf -i 1000-9999 -n1),
        "name": "$(echo "张三 李四 王五 赵六 钱七 孙八" | tr ' ' '\n' | shuf -n1)",
        "email": "user$(shuf -i 100-999 -n1)@example.com",
        "phone": "138$(shuf -i 10000000-99999999 -n1)",
        "status": "$(echo "active inactive pending" | tr ' ' '\n' | shuf -n1)",
        "role": "$(echo "admin user editor viewer" | tr ' ' '\n' | shuf -n1)",
        "created_at": "$(date -d "-$((RANDOM % 365)) days" '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date '+%Y-%m-%dT%H:%M:%SZ')",
        "updated_at": "$(date '+%Y-%m-%dT%H:%M:%SZ')"
      },
      {
        "id": $(shuf -i 1000-9999 -n1),
        "name": "$(echo "周九 吴十 郑一 冯二 陈三" | tr ' ' '\n' | shuf -n1)",
        "email": "user$(shuf -i 100-999 -n1)@example.com",
        "phone": "139$(shuf -i 10000000-99999999 -n1)",
        "status": "active",
        "role": "user",
        "created_at": "$(date -d "-$((RANDOM % 30)) days" '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date '+%Y-%m-%dT%H:%M:%SZ')",
        "updated_at": "$(date '+%Y-%m-%dT%H:%M:%SZ')"
      }
    ],
    "pagination": {
      "page": 1,
      "page_size": 20,
      "total": $(shuf -i 50-500 -n1),
      "total_pages": $(shuf -i 3-25 -n1)
    }
  }
}
\`\`\`

### 错误响应 (400)
\`\`\`json
{
  "code": 400,
  "message": "参数错误",
  "errors": [
    {"field": "email", "message": "邮箱格式不正确"},
    {"field": "name", "message": "名称不能为空"}
  ]
}
\`\`\`

### 认证错误 (401)
\`\`\`json
{
  "code": 401,
  "message": "未授权，请提供有效的认证信息",
  "error": "invalid_token"
}
\`\`\`

### 服务器错误 (500)
\`\`\`json
{
  "code": 500,
  "message": "服务器内部错误",
  "request_id": "req_$(head -c 8 /dev/urandom | od -An -tx1 | tr -d ' \n')"
}
\`\`\`
EOF
}

# ── 批量测试 ──
run_test_suite() {
  local base_url="$1"
  [[ -z "$base_url" ]] && { echo "❌ 请提供API基础URL"; exit 1; }

  echo "# 🧪 API测试报告"
  echo ""
  echo "> 基础URL: ${base_url}"
  echo "> 测试时间: $(date '+%Y-%m-%d %H:%M:%S')"
  echo ""

  local total=0 passed=0 failed=0 errors=0
  local results=()

  # 测试用例
  local -a test_cases=(
    "GET|${base_url}|健康检查"
    "GET|${base_url}/|首页"
  )

  echo "| # | 方法 | URL | 状态码 | 耗时 | 结果 |"
  echo "|---|------|-----|--------|------|------|"

  for tc in "${test_cases[@]}"; do
    IFS='|' read -r method url desc <<< "$tc"
    ((total++))

    local code time_total
    local resp_info
    resp_info=$(curl -sS -o /dev/null -w "%{http_code}|%{time_total}" -X "$method" "$url" --connect-timeout 5 --max-time 10 2>/dev/null) || resp_info="0|0"
    code="${resp_info%%|*}"
    time_total="${resp_info#*|}"

    local result_emoji
    case "${code:0:1}" in
      2) result_emoji="✅ PASS"; ((passed++)) ;;
      3) result_emoji="↪️ REDIRECT"; ((passed++)) ;;
      4|5) result_emoji="❌ FAIL"; ((failed++)) ;;
      *) result_emoji="⚠️ ERROR"; ((errors++)) ;;
    esac

    echo "| $total | $method | \`${url:0:50}\` | $code | ${time_total}s | $result_emoji |"
  done

  echo ""
  echo "## 📊 测试结果汇总"
  echo ""
  echo "| 指标 | 值 |"
  echo "|------|-----|"
  echo "| 总测试数 | $total |"
  echo "| ✅ 通过 | $passed |"
  echo "| ❌ 失败 | $failed |"
  echo "| ⚠️ 错误 | $errors |"
  local pass_rate=0
  (( total > 0 )) && pass_rate=$((passed * 100 / total))
  echo "| 通过率 | ${pass_rate}% |"
}

# ── 状态码速查 ──
status_reference() {
  cat <<'EOF'
# 📖 HTTP状态码速查

## 1xx 信息
| 代码 | 含义 | 说明 |
|------|------|------|
| 100 | Continue | 继续请求 |
| 101 | Switching Protocols | 协议切换(WebSocket) |

## 2xx 成功
| 代码 | 含义 | 说明 |
|------|------|------|
| 200 | OK | 请求成功 |
| 201 | Created | 资源创建成功(POST) |
| 204 | No Content | 成功但无返回(DELETE) |

## 3xx 重定向
| 代码 | 含义 | 说明 |
|------|------|------|
| 301 | Moved Permanently | 永久重定向(SEO) |
| 302 | Found | 临时重定向 |
| 304 | Not Modified | 缓存有效 |

## 4xx 客户端错误
| 代码 | 含义 | 说明 | 排查方向 |
|------|------|------|---------|
| 400 | Bad Request | 请求参数错误 | 检查参数格式 |
| 401 | Unauthorized | 未认证 | 检查Token/Key |
| 403 | Forbidden | 无权限 | 检查权限配置 |
| 404 | Not Found | 资源不存在 | 检查URL路径 |
| 405 | Method Not Allowed | 方法不允许 | 检查HTTP方法 |
| 408 | Request Timeout | 请求超时 | 检查网络/服务 |
| 409 | Conflict | 资源冲突 | 检查数据一致性 |
| 413 | Payload Too Large | 请求体过大 | 压缩/分片上传 |
| 422 | Unprocessable Entity | 参数校验失败 | 检查业务逻辑 |
| 429 | Too Many Requests | 限流 | 添加重试/降频 |

## 5xx 服务端错误
| 代码 | 含义 | 说明 | 排查方向 |
|------|------|------|---------|
| 500 | Internal Server Error | 服务器错误 | 检查服务端日志 |
| 502 | Bad Gateway | 网关错误 | 检查上游服务 |
| 503 | Service Unavailable | 服务不可用 | 检查服务状态 |
| 504 | Gateway Timeout | 网关超时 | 检查上游响应 |
EOF
}

# ── 帮助 ──
show_help() {
  cat <<'HELP'
🔗 API测试工具 — api.sh

用法: bash api.sh <command> [args...]

命令:
  get <url> [headers] [auth]
        → 发送GET请求（含性能分析+响应解析）
  post <url> <json_body> [headers] [auth]
        → 发送POST请求
  put <url> <json_body> [headers] [auth]
        → 发送PUT请求
  delete <url> [headers] [auth]
        → 发送DELETE请求
  test <base_url>
        → 批量测试（健康检查+连通性）
  mock [endpoint] [method]
        → 生成Mock数据（含成功/错误响应）
  status
        → HTTP状态码速查表
  help  → 显示帮助

示例:
  bash api.sh get https://api.github.com/users/octocat
  bash api.sh post https://httpbin.org/post '{"name":"test"}'
  bash api.sh get https://api.example.com "" "Bearer sk-xxx"
  bash api.sh mock /api/users GET
  bash api.sh test https://api.example.com
  bash api.sh status

💡 特性:
  - 真实HTTP请求+响应解析
  - 性能评级（响应时间）
  - 自动JSON格式化
  - Mock数据生成（随机真实数据）
  - HTTP状态码速查
HELP
}

case "$CMD" in
  get)
    IFS='|' read -ra A <<< "$(echo "$INPUT" | sed 's/  */|/g')"
    http_request "GET" "${A[0]}" "" "${A[1]:-}" "${A[2]:-}"
    ;;
  post)
    IFS='|' read -ra A <<< "$(echo "$INPUT" | sed 's/  */|/g')"
    http_request "POST" "${A[0]}" "${A[1]:-}" "${A[2]:-}" "${A[3]:-}"
    ;;
  put)
    IFS='|' read -ra A <<< "$(echo "$INPUT" | sed 's/  */|/g')"
    http_request "PUT" "${A[0]}" "${A[1]:-}" "${A[2]:-}" "${A[3]:-}"
    ;;
  delete)
    IFS='|' read -ra A <<< "$(echo "$INPUT" | sed 's/  */|/g')"
    http_request "DELETE" "${A[0]}" "" "${A[1]:-}" "${A[2]:-}"
    ;;
  test)   run_test_suite "${INPUT%% *}" ;;
  mock)
    IFS=' ' read -ra A <<< "$INPUT"
    generate_mock "${A[0]:-/api/users}" "${A[1]:-GET}"
    ;;
  status) status_reference ;;
  help|*) show_help ;;
esac
