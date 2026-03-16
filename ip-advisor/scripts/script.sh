#!/usr/bin/env bash
# ip-advisor - System operations and monitoring tool
set -euo pipefail
VERSION="2.0.0"
DATA_DIR="${IP_ADVISOR_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/ip-advisor}"
DB="$DATA_DIR/data.log"
mkdir -p "$DATA_DIR"

show_help() {
    cat << EOF
ip-advisor v$VERSION

System operations and monitoring tool

Usage: ip-advisor <command> [args]

Commands:
  status               System status
  check                Health check
  monitor              Start monitoring
  logs                 View logs
  config               Show config
  restart              Restart guide
  backup               Backup helper
  alert                Set alert
  optimize             Optimization tips
  info                 System info
  help                 Show this help
  version              Show version

Data: \$DATA_DIR
EOF
}

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

cmd_status() {
    echo "  $(uptime 2>/dev/null || echo "uptime: unknown")"
    _log "status" "${1:-}"
}

cmd_check() {
    echo "  CPU: $(grep -c processor /proc/cpuinfo 2>/dev/null || echo "?") cores
      Mem: $(free -h 2>/dev/null | awk "/Mem/{print \$3"/"\$2}" || echo "?")"
    _log "check" "${1:-}"
}

cmd_monitor() {
    echo "  Monitoring: $1"
    _log "monitor" "${1:-}"
}

cmd_logs() {
    echo "  Recent: $(tail -5 /var/log/syslog 2>/dev/null || echo "no access")"
    _log "logs" "${1:-}"
}

cmd_config() {
    echo "  Config dir: $DATA_DIR"
    _log "config" "${1:-}"
}

cmd_restart() {
    echo "  systemctl restart $1"
    _log "restart" "${1:-}"
}

cmd_backup() {
    echo "  Backup: tar czf backup-$(date +%Y%m%d).tar.gz $1"
    _log "backup" "${1:-}"
}

cmd_alert() {
    echo "  Alert: $1 threshold $2"
    _log "alert" "${1:-}"
}

cmd_optimize() {
    echo "  1. Clear cache | 2. Compress logs | 3. Kill zombies"
    _log "optimize" "${1:-}"
}

cmd_info() {
    uname -a 2>/dev/null; echo "  Disk: $(df -h / 2>/dev/null | tail -1)"
    _log "info" "${1:-}"
}

case "${1:-help}" in
    status) shift; cmd_status "$@" ;;
    check) shift; cmd_check "$@" ;;
    monitor) shift; cmd_monitor "$@" ;;
    logs) shift; cmd_logs "$@" ;;
    config) shift; cmd_config "$@" ;;
    restart) shift; cmd_restart "$@" ;;
    backup) shift; cmd_backup "$@" ;;
    alert) shift; cmd_alert "$@" ;;
    optimize) shift; cmd_optimize "$@" ;;
    info) shift; cmd_info "$@" ;;
    help|-h) show_help ;;
    version|-v) echo "ip-advisor v$VERSION" ;;
    *) echo "Unknown: $1"; show_help; exit 1 ;;
esac
