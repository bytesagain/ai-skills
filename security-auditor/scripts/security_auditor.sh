#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# Security Auditor — system security audit (inspired by CISOfy/lynis 15K+ stars)
set -euo pipefail
CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in
    help)
        echo "Security Auditor — system security checking & hardening"
        echo ""
        echo "Commands:"
        echo "  scan              Full security scan"
        echo "  users             User account audit"
        echo "  ports             Open ports check"
        echo "  ssh               SSH configuration audit"
        echo "  firewall          Firewall status"
        echo "  updates           Pending security updates"
        echo "  permissions       File permission issues"
        echo "  passwords         Password policy check"
        echo "  network           Network security check"
        echo "  report            Generate security report"
        echo "  info              Version info"
        echo ""
        echo "Powered by BytesAgain | bytesagain.com"
        ;;
    scan)
        echo "=============================================="
        echo "  Security Scan — $(date '+%Y-%m-%d %H:%M')"
        echo "  Host: $(hostname)"
        echo "=============================================="
        echo ""
        score=100; issues=0

        # OS info
        echo "[*] System info"
        echo "    OS: $(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d'"' -f2 || uname -s)"
        echo "    Kernel: $(uname -r)"
        echo "    Uptime: $(uptime -p 2>/dev/null || uptime)"
        echo ""

        # Root login
        echo "[*] SSH root login"
        if grep -q "^PermitRootLogin yes" /etc/ssh/sshd_config 2>/dev/null; then
            echo "    ⚠ Root login enabled"; score=$((score-10)); issues=$((issues+1))
        else
            echo "    ✅ Root login disabled/limited"
        fi

        # Password auth
        echo "[*] SSH password auth"
        if grep -q "^PasswordAuthentication yes" /etc/ssh/sshd_config 2>/dev/null; then
            echo "    ⚠ Password auth enabled (key-only preferred)"; score=$((score-5)); issues=$((issues+1))
        else
            echo "    ✅ Password auth disabled"
        fi

        # Firewall
        echo "[*] Firewall"
        if command -v ufw >/dev/null 2>&1; then
            status=$(ufw status 2>/dev/null | head -1)
            echo "    UFW: $status"
            [ "$status" != "Status: active" ] && { score=$((score-15)); issues=$((issues+1)); }
        elif command -v firewall-cmd >/dev/null 2>&1; then
            echo "    Firewalld: $(firewall-cmd --state 2>/dev/null || echo 'unknown')"
        elif command -v iptables >/dev/null 2>&1; then
            rules=$(iptables -L 2>/dev/null | grep -c "ACCEPT\|DROP\|REJECT" || echo 0)
            echo "    iptables rules: $rules"
            [ "$rules" -lt 3 ] && { echo "    ⚠ Minimal firewall rules"; score=$((score-10)); issues=$((issues+1)); }
        else
            echo "    ⚠ No firewall detected"; score=$((score-15)); issues=$((issues+1))
        fi

        # Open ports
        echo "[*] Open ports"
        if command -v ss >/dev/null 2>&1; then
            ports=$(ss -tlnp 2>/dev/null | grep LISTEN | awk '{print $4}' | grep -oP ':\K\d+' | sort -un)
            echo "    Listening: $(echo $ports | tr '\n' ' ')"
            count=$(echo "$ports" | wc -w)
            [ "$count" -gt 10 ] && { echo "    ⚠ Many open ports ($count)"; score=$((score-5)); issues=$((issues+1)); }
        fi

        # SUID files
        echo "[*] SUID binaries"
        suid_count=$(find /usr -perm -4000 -type f 2>/dev/null | wc -l)
        echo "    Count: $suid_count"
        [ "$suid_count" -gt 20 ] && { echo "    ⚠ Many SUID files"; score=$((score-5)); issues=$((issues+1)); }

        # World-writable
        echo "[*] World-writable files"
        ww=$(find /etc /var -perm -o+w -type f 2>/dev/null | wc -l)
        echo "    Count: $ww"
        [ "$ww" -gt 0 ] && { echo "    ⚠ Found world-writable files"; score=$((score-5)); issues=$((issues+1)); }

        # Updates
        echo "[*] Pending updates"
        if command -v apt >/dev/null 2>&1; then
            updates=$(apt list --upgradable 2>/dev/null | grep -c upgradable || echo 0)
            echo "    Pending: $updates"
            [ "$updates" -gt 20 ] && { score=$((score-10)); issues=$((issues+1)); }
        elif command -v yum >/dev/null 2>&1; then
            echo "    (check with: yum check-update)"
        fi

        echo ""
        echo "=============================================="
        [ "$score" -ge 80 ] && grade="A" || { [ "$score" -ge 60 ] && grade="B" || { [ "$score" -ge 40 ] && grade="C" || grade="D"; }; }
        echo "  Score: $score/100 (Grade: $grade)"
        echo "  Issues found: $issues"
        echo "=============================================="
        ;;
    users)
        echo "User Account Audit:"
        echo ""
        echo "Users with login shell:"
        grep -v '/nologin\|/false' /etc/passwd 2>/dev/null | awk -F: '{printf "  %-15s UID:%-5s %s\n", $1, $3, $7}'
        echo ""
        echo "Users with UID 0 (root-level):"
        awk -F: '$3==0{print "  "$1}' /etc/passwd 2>/dev/null
        echo ""
        echo "Recently logged in:"
        last -5 2>/dev/null || echo "  (unavailable)"
        ;;
    ports)
        echo "Open Ports:"
        ss -tlnp 2>/dev/null || netstat -tlnp 2>/dev/null || echo "ss/netstat not available"
        ;;
    ssh)
        echo "SSH Configuration Audit:"
        echo ""
        for key in PermitRootLogin PasswordAuthentication PubkeyAuthentication Port MaxAuthTries X11Forwarding AllowTcpForwarding; do
            val=$(grep "^$key " /etc/ssh/sshd_config 2>/dev/null | awk '{print $2}')
            [ -z "$val" ] && val="(default)"
            echo "  $key: $val"
        done
        ;;
    firewall)
        echo "Firewall Status:"
        ufw status verbose 2>/dev/null || \
        firewall-cmd --list-all 2>/dev/null || \
        iptables -L -n 2>/dev/null | head -30 || \
        echo "No firewall tools found"
        ;;
    updates)
        echo "Pending Updates:"
        apt list --upgradable 2>/dev/null || yum check-update 2>/dev/null || echo "Package manager not detected"
        ;;
    permissions)
        echo "Permission Issues:"
        echo ""
        echo "World-writable files in /etc:"
        find /etc -perm -o+w -type f 2>/dev/null | head -10 || echo "  (none)"
        echo ""
        echo "Unowned files:"
        find / -nouser -o -nogroup 2>/dev/null | head -10 || echo "  (none)"
        ;;
    passwords)
        echo "Password Policy:"
        echo ""
        echo "Accounts without password:"
        awk -F: '($2=="!" || $2=="*" || $2==""){print "  "$1}' /etc/shadow 2>/dev/null || echo "  (need root)"
        echo ""
        if [ -f /etc/login.defs ]; then
            echo "Policy (/etc/login.defs):"
            grep -E "^PASS_MAX_DAYS|^PASS_MIN_DAYS|^PASS_MIN_LEN|^PASS_WARN_AGE" /etc/login.defs 2>/dev/null | sed 's/^/  /'
        fi
        ;;
    network)
        echo "Network Security:"
        echo ""
        echo "DNS servers:"
        grep nameserver /etc/resolv.conf 2>/dev/null | sed 's/^/  /'
        echo ""
        echo "IP forwarding:"
        echo "  IPv4: $(cat /proc/sys/net/ipv4/ip_forward 2>/dev/null || echo '?')"
        echo ""
        echo "Active connections:"
        ss -tn 2>/dev/null | grep ESTAB | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn | head -10 | sed 's/^/  /'
        ;;
    report)
        echo "Generating full security report..."
        echo ""
        bash "$0" scan 2>/dev/null
        echo ""
        bash "$0" users 2>/dev/null
        echo ""
        bash "$0" ssh 2>/dev/null
        ;;
    info)
        echo "Security Auditor v1.0.0"
        echo "Inspired by: CISOfy/lynis (15,000+ GitHub stars)"
        echo "Powered by BytesAgain | bytesagain.com"
        ;;
    *)
        echo "Unknown: $CMD — run 'help' for usage"; exit 1
        ;;
esac
