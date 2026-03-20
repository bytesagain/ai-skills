#!/usr/bin/env bash
# NetPing — Network ping & diagnostic tool
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="netping"

# ─────────────────────────────────────────────────────────────
# Usage / Help
# ─────────────────────────────────────────────────────────────
usage() {
  cat <<'EOF'
NetPing — Network ping & diagnostic tool
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

USAGE:
  netping <command> [arguments]

COMMANDS:
  ping <host> [count]                Ping a host (default: 4 packets)
  ports <host> <port1,port2,...>     Check if TCP ports are open
  trace <host>                       Traceroute to host
  dns <domain>                       DNS lookup (A, AAAA, MX, NS, TXT)
  latency <host>                     Measure average latency (5 pings)
  http <url>                         Check HTTP status and timing
  sweep <subnet>                     Quick ping sweep (e.g. 192.168.1.0/24)
  help                               Show this help message
  version                            Show version

EXAMPLES:
  netping ping google.com
  netping ping 8.8.8.8 10
  netping ports example.com 80,443,8080
  netping trace cloudflare.com
  netping dns github.com
  netping latency 1.1.1.1
  netping http https://example.com
EOF
}

# ─────────────────────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────────────────────
die() { echo "ERROR: $*" >&2; exit 1; }

require_arg() {
  if [[ -z "${1:-}" ]]; then
    die "Missing required argument: $2"
  fi
}

require_cmd() {
  command -v "$1" &>/dev/null || die "Required command not found: $1"
}

# ─────────────────────────────────────────────────────────────
# Commands
# ─────────────────────────────────────────────────────────────

cmd_ping() {
  local host="${1:-}"
  local count="${2:-4}"
  require_arg "$host" "host"
  [[ "$count" =~ ^[0-9]+$ ]] || die "Count must be a positive integer"
  require_cmd ping
  echo "Pinging $host ($count packets)..."
  echo "─────────────────────────────────────"
  ping -c "$count" -W 5 "$host" 2>&1 || true
}

cmd_ports() {
  local host="${1:-}"
  local ports_str="${2:-}"
  require_arg "$host" "host"
  require_arg "$ports_str" "ports (comma-separated)"
  local timeout_sec=3
  echo "Port scan: $host"
  echo "─────────────────────────────────────"
  IFS=',' read -ra ports <<< "$ports_str"
  local open=0
  local closed=0
  for port in "${ports[@]}"; do
    port=$(echo "$port" | tr -d '[:space:]')
    [[ "$port" =~ ^[0-9]+$ ]] || { echo "  ⚠ Invalid port: $port"; continue; }
    if (echo >/dev/tcp/"$host"/"$port") 2>/dev/null; then
      echo "  ✅ Port $port — OPEN"
      (( open++ )) || true
    else
      echo "  ❌ Port $port — CLOSED/FILTERED"
      (( closed++ )) || true
    fi
  done
  echo "─────────────────────────────────────"
  echo "Summary: $open open, $closed closed/filtered"
}

cmd_trace() {
  local host="${1:-}"
  require_arg "$host" "host"
  echo "Traceroute to $host..."
  echo "─────────────────────────────────────"
  if command -v traceroute &>/dev/null; then
    traceroute -m 20 -w 3 "$host" 2>&1 || true
  elif command -v tracepath &>/dev/null; then
    tracepath "$host" 2>&1 || true
  else
    # Fallback: simple TTL-based ping trace
    echo "(traceroute/tracepath not found, using ping TTL method)"
    local ttl
    for ttl in $(seq 1 20); do
      local result
      result=$(ping -c 1 -t "$ttl" -W 2 "$host" 2>&1 || true)
      local hop_ip
      hop_ip=$(echo "$result" | grep -oP 'from \K[\d.]+' | head -1)
      if [[ -n "$hop_ip" ]]; then
        local rtt
        rtt=$(echo "$result" | grep -oP 'time=\K[\d.]+' | head -1)
        echo "  $ttl  $hop_ip  ${rtt:-?}ms"
        # If we reached the destination, stop
        if echo "$result" | grep -q "64 bytes\|ttl="; then
          local dest_check
          dest_check=$(getent hosts "$host" 2>/dev/null | awk '{print $1}' | head -1)
          [[ "$hop_ip" == "$dest_check" ]] && break
        fi
      else
        echo "  $ttl  * * *"
      fi
    done
  fi
}

cmd_dns() {
  local domain="${1:-}"
  require_arg "$domain" "domain"
  echo "DNS Lookup: $domain"
  echo "─────────────────────────────────────"

  if command -v dig &>/dev/null; then
    echo ""
    echo "A Records:"
    dig +short A "$domain" 2>/dev/null | sed 's/^/  /' || echo "  (none)"
    echo ""
    echo "AAAA Records:"
    dig +short AAAA "$domain" 2>/dev/null | sed 's/^/  /' || echo "  (none)"
    echo ""
    echo "MX Records:"
    dig +short MX "$domain" 2>/dev/null | sed 's/^/  /' || echo "  (none)"
    echo ""
    echo "NS Records:"
    dig +short NS "$domain" 2>/dev/null | sed 's/^/  /' || echo "  (none)"
    echo ""
    echo "TXT Records:"
    dig +short TXT "$domain" 2>/dev/null | sed 's/^/  /' || echo "  (none)"
  elif command -v nslookup &>/dev/null; then
    nslookup "$domain" 2>&1 | sed 's/^/  /'
  elif command -v getent &>/dev/null; then
    echo "A Records (via getent):"
    getent hosts "$domain" 2>/dev/null | sed 's/^/  /' || echo "  (none)"
  else
    die "No DNS lookup tool found (dig, nslookup, or getent required)"
  fi
}

cmd_latency() {
  local host="${1:-}"
  require_arg "$host" "host"
  require_cmd ping
  local count=5
  echo "Measuring latency to $host ($count pings)..."
  echo "─────────────────────────────────────"
  local output
  output=$(ping -c "$count" -W 5 "$host" 2>&1) || {
    echo "$output"
    die "Ping failed — host may be unreachable"
  }
  echo "$output" | tail -2
  echo ""
  # Extract individual RTTs
  local rtts
  rtts=$(echo "$output" | grep -oP 'time=\K[\d.]+')
  if [[ -n "$rtts" ]]; then
    local min max avg sum=0 n=0
    while IFS= read -r rtt; do
      sum=$(awk "BEGIN{printf \"%.3f\", $sum + $rtt}")
      (( n++ ))
      if [[ $n -eq 1 ]]; then
        min="$rtt"
        max="$rtt"
      else
        min=$(awk "BEGIN{print ($rtt < $min) ? $rtt : $min}")
        max=$(awk "BEGIN{print ($rtt > $max) ? $rtt : $max}")
      fi
    done <<< "$rtts"
    avg=$(awk "BEGIN{printf \"%.3f\", $sum / $n}")
    echo "Detailed stats:"
    echo "  Packets:  $n received"
    echo "  Min:      ${min}ms"
    echo "  Max:      ${max}ms"
    echo "  Average:  ${avg}ms"
  fi
}

cmd_http() {
  local url="${1:-}"
  require_arg "$url" "url"
  require_cmd curl
  echo "HTTP Check: $url"
  echo "─────────────────────────────────────"
  local http_code time_total time_connect time_starttransfer
  local curl_output
  curl_output=$(curl -sL -o /dev/null -w '%{http_code} %{time_total} %{time_connect} %{time_starttransfer}' \
    --max-time 15 "$url" 2>/dev/null || echo "000 0 0 0")
  http_code=$(echo "$curl_output" | awk '{print $1}')
  time_total=$(echo "$curl_output" | awk '{print $2}')
  time_connect=$(echo "$curl_output" | awk '{print $3}')
  time_starttransfer=$(echo "$curl_output" | awk '{print $4}')
  if [[ "$http_code" == "000" ]]; then
    echo "  Status:   ❌ UNREACHABLE"
    echo "  Error:    Connection failed or timed out"
  else
    local icon="✅"
    [[ "$http_code" -ge 400 ]] && icon="⚠️"
    [[ "$http_code" -ge 500 ]] && icon="❌"
    echo "  Status:   $icon HTTP $http_code"
    echo "  Connect:  ${time_connect}s"
    echo "  TTFB:     ${time_starttransfer}s"
    echo "  Total:    ${time_total}s"
  fi
}

cmd_sweep() {
  local subnet="${1:-}"
  require_arg "$subnet" "subnet (e.g. 192.168.1.0/24)"
  # Extract base and determine range
  local base
  base=$(echo "$subnet" | sed 's|\.[0-9]*/.*||')
  echo "Ping sweep: ${base}.1-254"
  echo "─────────────────────────────────────"
  local alive=0
  for i in $(seq 1 254); do
    local ip="${base}.${i}"
    if ping -c 1 -W 1 "$ip" &>/dev/null; then
      local hostname
      hostname=$(getent hosts "$ip" 2>/dev/null | awk '{print $2}' || true)
      echo "  ✅ $ip ${hostname:+(${hostname})}"
      (( alive++ )) || true
    fi
  done
  echo "─────────────────────────────────────"
  echo "Alive hosts: $alive / 254"
}

# ─────────────────────────────────────────────────────────────
# Main dispatcher
# ─────────────────────────────────────────────────────────────
main() {
  local cmd="${1:-help}"
  shift || true

  case "$cmd" in
    ping)    cmd_ping "$@" ;;
    ports)   cmd_ports "$@" ;;
    trace)   cmd_trace "$@" ;;
    dns)     cmd_dns "$@" ;;
    latency) cmd_latency "$@" ;;
    http)    cmd_http "$@" ;;
    sweep)   cmd_sweep "$@" ;;
    version) echo "$SCRIPT_NAME $VERSION" ;;
    help|--help|-h) usage ;;
    *)       die "Unknown command: $cmd (try 'netping help')" ;;
  esac
}

main "$@"
