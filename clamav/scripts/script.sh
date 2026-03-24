#!/usr/bin/env bash
# clamav — ClamAV antivirus reference. Real commands, real configs.
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

show_help() {
    cat << 'HELPEOF'
clamav — ClamAV Open-Source Antivirus Reference

Usage: clamav <command>

Commands:
  intro           ClamAV architecture, components, and installation
  scan            Scanning files and directories with clamscan
  update          Updating virus databases with freshclam
  daemon          Running clamd for on-access and high-speed scanning
  signatures      Writing custom signatures (.ndb, .ldb, .hdb)
  quarantine      Handling infected files (move, copy, remove)
  automation      Cron jobs, email alerts, and scheduled scanning
  performance     Tuning memory, threads, and exclusions
  help            Show this help
  version         Show version

Powered by BytesAgain | bytesagain.com
HELPEOF
}

cmd_intro() {
    cat << 'EOF'
# ClamAV — Open-Source Antivirus

## What is ClamAV?

ClamAV is an open-source antivirus engine maintained by Cisco/Talos.
It detects trojans, viruses, malware, and other threats. It's the
standard AV for Linux mail gateways and file servers.

## Components

  clamscan      Command-line scanner (loads engine per invocation)
  clamdscan     Client that connects to clamd daemon (fast, no reload)
  clamd         Daemon — keeps virus DB in memory, handles scan requests
  freshclam     Database updater — downloads latest signatures
  clamconf      Display current ClamAV configuration
  clambc        Bytecode signature testing tool
  sigtool       Signature manipulation and info tool

## Installation

  ### RHEL/CentOS/AlmaLinux (EPEL required):
  # yum install epel-release
  # yum install clamav clamav-update clamd

  ### Debian/Ubuntu:
  # apt install clamav clamav-daemon clamav-freshclam

  ### From source:
  $ wget https://www.clamav.net/downloads/production/clamav-1.3.0.tar.gz
  $ tar xzf clamav-1.3.0.tar.gz && cd clamav-1.3.0
  $ cmake .. -D CMAKE_INSTALL_PREFIX=/usr/local
  $ cmake --build . && sudo cmake --install .

## Virus Database Files

  Stored in /var/lib/clamav/ (default):
    main.cvd        Main signature database (~150MB, ~6M+ sigs)
    daily.cvd       Daily updates (incremental)
    bytecode.cvd    Bytecode signatures for advanced detection

  CVD = ClamAV Virus Database (compressed, signed archive)
  When incremental updates apply, .cvd becomes .cld + .cdiff files.

## First Run

  1. Update the signature database:
     # freshclam

  2. Test with the EICAR test file:
     $ curl -O https://secure.eicar.org/eicar.com.txt
     $ clamscan eicar.com.txt
     eicar.com.txt: Eicar-Signature FOUND
     ----------- SCAN SUMMARY -----------
     Known viruses: 8678103
     Scanned files: 1
     Infected files: 1

## Version Check

  $ clamscan --version
  ClamAV 1.3.0/27174/Thu Jan 11 08:26:21 2024
  (engine version / signature count / last DB update)
EOF
}

cmd_scan() {
    cat << 'EOF'
# ClamAV — Scanning with clamscan

## Basic Scanning

  $ clamscan file.txt                    # Scan a single file
  $ clamscan -r /home/user/              # Recursive scan
  $ clamscan -ri /home/user/             # Recursive, show infected only
  $ clamscan -r /srv/                    # Scan server data

## Useful Options

  -r, --recursive         Scan directories recursively
  -i, --infected          Show only infected files
  -v, --verbose           Verbose output (show every file scanned)
  --no-summary            Suppress the summary at the end
  -l FILE, --log=FILE     Write scan report to FILE
  --bell                  Ring bell on virus detection

## File Type Handling

  --scan-pdf=yes          Scan PDF files (default: yes)
  --scan-html=yes         Scan HTML files (default: yes)
  --scan-mail=yes         Scan mail files (default: yes)
  --scan-ole2=yes         Scan OLE2 (MS Office) files
  --scan-archive=yes      Scan inside archives (zip, rar, tar, etc.)
  --max-filesize=100M     Skip files larger than 100MB
  --max-scansize=400M     Max data scanned per archive

## Exit Codes

  0    No virus found
  1    Virus(es) found
  2    Some error(s) occurred (read error, etc.)

  Use in scripts:
  clamscan -ri /data/uploads/
  if [ $? -eq 1 ]; then
      echo "INFECTED FILES FOUND" | mail -s "ClamAV Alert" admin@example.com
  fi

## Scanning with Exclusions

  --exclude='\.log$'                  Exclude by regex on filename
  --exclude-dir='/proc'               Exclude directories
  --exclude-dir='/sys'
  --exclude-dir='/dev'

  Full system scan (exclude virtual filesystems):
  # clamscan -r -i \
      --exclude-dir='^/proc' \
      --exclude-dir='^/sys' \
      --exclude-dir='^/dev' \
      --exclude-dir='^/run' \
      -l /var/log/clamav/fullscan.log \
      /

## Using clamdscan (Daemon Client)

  Much faster than clamscan because it doesn't reload the database.
  Requires clamd to be running.

  $ clamdscan /home/user/downloads/
  $ clamdscan --multiscan /srv/           # Parallel scanning
  $ clamdscan --fdpass /path/to/file      # Pass file descriptor to clamd
  $ clamdscan --stream /path/to/file      # Stream file over socket

## Pipe Scanning

  $ cat suspicious.bin | clamscan -
  stdin: Win.Trojan.Agent-12345 FOUND

  $ wget -qO- http://example.com/file.bin | clamscan -
EOF
}

cmd_update() {
    cat << 'EOF'
# ClamAV — Updating Virus Databases

## freshclam — The Update Tool

  # freshclam                        # Update all databases
  # freshclam --show-progress        # Show download progress
  # freshclam -v                     # Verbose output
  # freshclam --checks=24            # Check 24 times per day

## freshclam Configuration

  /etc/clamav/freshclam.conf (Debian) or /etc/freshclam.conf (RHEL)
  ────────────────────────────────────────────────────────────────
  # Database mirror
  DatabaseMirror database.clamav.net

  # How many times per day to check (max 50)
  Checks 24

  # Where to store databases
  DatabaseDirectory /var/lib/clamav

  # Log file
  UpdateLogFile /var/log/clamav/freshclam.log

  # Run as this user
  DatabaseOwner clamav

  # Optional: HTTP proxy
  # HTTPProxyServer proxy.example.com
  # HTTPProxyPort 3128
  # HTTPProxyUsername proxyuser
  # HTTPProxyPassword proxypass

  # Receive notifications of new engine versions
  NotifyClamd /etc/clamav/clamd.conf

  # Connection timeout
  ConnectTimeout 30
  ReceiveTimeout 60

## Running freshclam as a Daemon

  # freshclam -d                     # Run in background
  # systemctl enable --now clamav-freshclam   # Systemd service

  Check daemon status:
  $ systemctl status clamav-freshclam
  $ tail -f /var/log/clamav/freshclam.log

## Private Mirror

  For networks with many ClamAV nodes, run a local mirror:

  # pip install cvdupdate
  $ cvd update                       # Download databases
  $ cvd serve                        # Start local HTTP mirror

  On clients, point DatabaseMirror to your local mirror:
  PrivateMirror http://mirror.internal:8080

## Database Info

  $ sigtool --info /var/lib/clamav/main.cvd
  File: main.cvd
  Build time: 09 Sep 2023
  Version: 62
  Signatures: 6631190
  Functionality level: 90
  Builder: sigmgr
  MD5: ...
  Digital signature: valid

## Common Errors

  WARNING: Your ClamAV installation is OUTDATED!
  → Update ClamAV engine to latest version.

  WARNING: FreshClam received error code 429
  → Rate limited. Reduce Checks value or use a private mirror.

  ERROR: Can't create freshclam.dat in /var/lib/clamav
  → Fix permissions: chown clamav:clamav /var/lib/clamav
EOF
}

cmd_daemon() {
    cat << 'EOF'
# ClamAV — clamd Daemon

## Why Use clamd?

  clamscan loads the entire virus database (~300MB RAM) every invocation.
  clamd loads it once and keeps it in memory — subsequent scans via
  clamdscan take milliseconds instead of 15-30 seconds to start.

## clamd Configuration

  /etc/clamav/clamd.conf (Debian) or /etc/clamd.d/scan.conf (RHEL)
  ──────────────────────────────────────────────────────────────────
  # Socket for local connections
  LocalSocket /var/run/clamav/clamd.ctl
  LocalSocketMode 660

  # OR TCP socket for network scanning
  # TCPSocket 3310
  # TCPAddr 127.0.0.1

  # Run as
  User clamav

  # Logging
  LogFile /var/log/clamav/clamd.log
  LogTime yes
  LogFileMaxSize 5M
  LogRotate yes
  LogSyslog yes

  # Limits
  MaxScanSize 400M
  MaxFileSize 100M
  MaxRecursion 16
  MaxFiles 10000
  MaxScanTime 120000

  # Scan options
  ScanPE yes
  ScanELF yes
  ScanOLE2 yes
  ScanPDF yes
  ScanHTML yes
  ScanMail yes
  ScanArchive yes

  # On-access scanning (requires kernel ≥ 3.8, fanotify)
  # OnAccessIncludePath /home
  # OnAccessIncludePath /var/www
  # OnAccessExcludePath /var/www/logs
  # OnAccessPrevention yes
  # OnAccessExtraScanning yes

  # Self-check interval (reload DB if changed)
  SelfCheck 3600

## Starting clamd

  # systemctl enable --now clamav-daemon      # Debian
  # systemctl enable --now clamd@scan         # RHEL

  Verify:
  $ clamdscan --ping                          # Pings clamd
  PONG

  $ clamdscan --version
  ClamAV 1.3.0/27174/Thu Jan 11 08:26:21 2024

## Scanning via clamd

  $ clamdscan /home/uploads/                  # Uses clamd
  $ clamdscan --multiscan /srv/data/          # Parallel multi-threaded scan
  $ clamdscan --stream /path/to/file          # Stream mode (no file path needed)
  $ clamdscan --fdpass /path/to/file          # Pass FD via socket (fastest)

## On-Access Scanning

  Real-time scanning as files are accessed (Linux fanotify):

  1. Enable in clamd.conf:
     OnAccessIncludePath /home
     OnAccessPrevention yes

  2. Start the on-access service:
     # clamonacc --foreground --log=/var/log/clamav/onacc.log

  3. As systemd service:
     # systemctl enable --now clamav-clamonacc

## Socket Permissions

  For integration with other services (Postfix, vsftpd):
  LocalSocket /var/run/clamav/clamd.ctl
  LocalSocketGroup mail
  LocalSocketMode 666

  Add mail user to clamav group: # usermod -aG clamav postfix
EOF
}

cmd_signatures() {
    cat << 'EOF'
# ClamAV — Custom Signatures

## Signature Databases

  Custom signatures go in /var/lib/clamav/ with these extensions:
    .hdb     MD5 hash-based signatures
    .hsb     SHA1/SHA256 hash-based signatures
    .ndb     Extended format (body-based pattern matching)
    .ldb     Logical signatures (complex conditions)
    .yar     YARA rules (ClamAV 0.99+)

## Hash-Based Signatures (.hdb / .hsb)

  Simplest method — match by file hash.

  Format: hash:filesize:name

  ### Generate and add:
  $ md5sum malware.exe
  d41d8cd98f00b204e9800998ecf8427e  malware.exe
  $ echo "d41d8cd98f00b204e9800998ecf8427e:68:Custom.Malware.Agent" \
      >> /var/lib/clamav/custom.hdb

  ### SHA256 version:
  $ sha256sum malware.exe | awk '{print $1":68:Custom.Malware.Agent"}' \
      >> /var/lib/clamav/custom.hsb

## Body-Based Signatures (.ndb)

  Match hex patterns within file content.

  Format: MalwareName:TargetType:Offset:HexSignature

  TargetType: 0=any, 1=PE, 2=OLE2, 3=HTML, 4=Mail, 5=Graphics
              6=ELF, 7=ASCII text, 9=Mach-O

  Offset:     *=anywhere, 0=start, EOF-n=end, n=exact byte offset
              float means within first N bytes

  ### Examples:
  # Detect EICAR test string anywhere in file
  Custom.Test.EICAR:0:*:5835304f255041505b344c50585a35342850\
  5e2937434329377d2445494341522d5354414e444152442d414e544956495255\
  532d544553542d46494c452124482b482a

  # Detect specific PHP webshell pattern
  Custom.Webshell.PHPEval:0:*:6576616c28626173653634\
  5f6465636f646528    (eval(base64_decode()

  ### Convert ASCII to hex for signatures:
  $ echo -n 'eval(base64_decode(' | xxd -p
  6576616c28626173653634...

## Logical Signatures (.ldb)

  Combine multiple conditions with AND/OR logic.

  Format: SignatureName;TargetType;LogicalExpression;Subsig0;Subsig1;...

  ### Example (match if BOTH patterns present):
  Custom.Backdoor.Multi;Target:0;(0&1);\
  6576616c28;626173653634

  Operators: & (AND), | (OR), parentheses for grouping
  Quantifiers: 0=first subsig, 1=second, etc.

## YARA Rules

  ClamAV supports YARA rules natively:

  Save as /var/lib/clamav/custom.yar:
  ─────────────────────────────────
  rule php_backdoor {
      meta:
          description = "Detect PHP backdoor"
      strings:
          $eval = "eval(" ascii
          $base64 = "base64_decode" ascii
          $system = "system(" ascii
      condition:
          $eval and ($base64 or $system)
  }

## Testing Signatures

  $ clamscan --database=/var/lib/clamav/custom.ndb testfile
  $ sigtool --decode-sigs --find-sigs="Custom.Malware"

  After adding signatures, reload clamd:
  # clamdscan --reload
  OR:
  # kill -USR2 $(pidof clamd)      # SIGUSR2 triggers database reload
EOF
}

cmd_quarantine() {
    cat << 'EOF'
# ClamAV — Quarantine & Handling Infected Files

## Move Infected Files (Quarantine)

  $ clamscan -r --move=/var/quarantine /srv/uploads/
  $ clamscan -ri --move=/var/quarantine /home/

  Files are moved to the quarantine directory with their original
  filename preserved. If a name collision occurs, ClamAV appends
  a numeric suffix.

## Copy Infected Files (Keep Original)

  $ clamscan -r --copy=/var/quarantine /srv/uploads/

  Copies infected files to quarantine WITHOUT removing originals.
  Useful for forensic analysis or when you need to verify
  before deleting.

## Remove Infected Files

  $ clamscan -r --remove /srv/uploads/

  WARNING: This permanently deletes infected files. No undo.
  Use --move or --copy first to preserve evidence.

  Safer alternative — remove only if confirmed:
  $ clamscan -r --remove=yes /srv/uploads/

## Setting Up a Quarantine Directory

  # mkdir -p /var/quarantine
  # chmod 700 /var/quarantine
  # chown clamav:clamav /var/quarantine

  Recommended: Mount quarantine with noexec,nosuid
  Add to /etc/fstab:
  tmpfs /var/quarantine tmpfs noexec,nosuid,nodev,size=1G 0 0

## Quarantine Logging

  Log all quarantine actions:
  $ clamscan -r -i --move=/var/quarantine \
      --log=/var/log/clamav/quarantine.log /srv/

  Log format includes:
  /srv/uploads/malware.zip: Win.Trojan.Agent-12345 FOUND
  /srv/uploads/malware.zip: moved to '/var/quarantine/malware.zip'

## Reviewing Quarantined Files

  List quarantined files:
  $ ls -la /var/quarantine/

  Check what was detected:
  $ clamscan --no-summary /var/quarantine/malware.zip
  /var/quarantine/malware.zip: Win.Trojan.Agent-12345 FOUND

  Get file info:
  $ file /var/quarantine/malware.zip
  $ strings /var/quarantine/malware.zip | head -20

## Quarantine Cleanup

  Delete quarantined files older than 30 days:
  # find /var/quarantine -type f -mtime +30 -delete

  Cron job for automatic cleanup:
  0 3 * * 0 find /var/quarantine -type f -mtime +30 -delete

## Integration with Mail Servers

  Postfix + ClamAV (via clamav-milter or amavisd):
  - Infected attachments quarantined to /var/lib/amavis/virusmails/
  - Clean messages delivered normally
  - Notifications sent to postmaster

  In amavisd.conf:
  $virus_quarantine_to = 'virus-quarantine@example.com';
  $final_virus_destiny  = D_DISCARD;
EOF
}

cmd_automation() {
    cat << 'EOF'
# ClamAV — Automation & Scheduled Scanning

## Cron-Based Scanning

  ### Daily scan of uploads at 2 AM:
  0 2 * * * /usr/bin/clamscan -ri --move=/var/quarantine \
      /srv/uploads/ >> /var/log/clamav/daily-scan.log 2>&1

  ### Weekly full system scan (Sunday 3 AM):
  0 3 * * 0 /usr/bin/clamscan -ri \
      --exclude-dir='^/proc' --exclude-dir='^/sys' \
      --exclude-dir='^/dev' --exclude-dir='^/run' \
      --move=/var/quarantine \
      -l /var/log/clamav/weekly-scan.log /

  ### Scan new files in incoming directory every hour:
  0 * * * * /usr/bin/clamscan -ri --move=/var/quarantine \
      /var/incoming/ 2>&1 | mail -s "ClamAV Hourly" admin@example.com

## Scan Script with Email Notification

  #!/bin/bash
  # /usr/local/bin/clamav-scan.sh
  SCAN_DIR="/srv/data"
  LOG="/var/log/clamav/scan-$(date +\%Y\%m\%d).log"
  QUARANTINE="/var/quarantine"
  EMAIL="admin@example.com"

  /usr/bin/clamscan -ri --move="$QUARANTINE" "$SCAN_DIR" > "$LOG" 2>&1
  RESULT=$?

  if [ "$RESULT" -eq 1 ]; then
      INFECTED=$(grep "FOUND" "$LOG" | wc -l)
      echo "ClamAV found $INFECTED infected file(s)." | \
          mail -s "⚠ ClamAV: $INFECTED threats found" \
          -A "$LOG" "$EMAIL"
  elif [ "$RESULT" -eq 2 ]; then
      echo "ClamAV scan encountered errors." | \
          mail -s "❌ ClamAV: Scan errors" -A "$LOG" "$EMAIL"
  fi

  # Rotate logs older than 90 days
  find /var/log/clamav/ -name 'scan-*.log' -mtime +90 -delete

## Monitoring freshclam

  Watch for update failures:
  $ grep -i "error\|warning\|fail" /var/log/clamav/freshclam.log

  Alert if database is outdated (>3 days):
  #!/bin/bash
  DB_AGE=$(find /var/lib/clamav/daily.cvd -mtime +3 2>/dev/null || \
           find /var/lib/clamav/daily.cld -mtime +3 2>/dev/null)
  if [ -n "$DB_AGE" ]; then
      echo "ClamAV database is over 3 days old!" | \
          mail -s "ClamAV: Outdated database" admin@example.com
  fi

## Systemd Timer (Alternative to Cron)

  /etc/systemd/system/clamav-scan.timer:
  ─────────────────────────────────────
  [Unit]
  Description=Daily ClamAV Scan

  [Timer]
  OnCalendar=*-*-* 02:00:00
  Persistent=true

  [Install]
  WantedBy=timers.target

  /etc/systemd/system/clamav-scan.service:
  ────────────────────────────────────────
  [Unit]
  Description=ClamAV System Scan

  [Service]
  Type=oneshot
  ExecStart=/usr/local/bin/clamav-scan.sh
  Nice=19
  IOSchedulingClass=idle

  # systemctl enable --now clamav-scan.timer

## inotifywait Integration (Real-Time without clamonacc)

  #!/bin/bash
  # Scan files immediately when created in uploads directory
  inotifywait -m -r -e create -e moved_to /srv/uploads/ |
  while read dir event file; do
      clamdscan --no-summary "${dir}${file}" || \
          mv "${dir}${file}" /var/quarantine/
  done
EOF
}

cmd_performance() {
    cat << 'EOF'
# ClamAV — Performance Tuning

## Memory Usage

  clamd loads the entire signature database into RAM:
  - main.cvd: ~150-300MB resident memory
  - Total with daily.cvd + bytecode: ~400-800MB RSS

  Reduce memory:
  - Disable unneeded signature types in clamd.conf:
    PhishingSignatures no         # Saves ~50MB if not scanning email
    PhishingScanURLs no
    HeuristicAlerts no

  - Use clamscan instead of clamd for infrequent scans
    (loads/unloads DB per invocation — less persistent RAM use)

## Multithreaded Scanning

  clamd is multithreaded by default:
  MaxThreads 12                    # Max concurrent scan threads
  IdleTimeout 30                   # Kill idle threads after 30s

  clamdscan --multiscan /path/     # Uses all available clamd threads

  clamscan is single-threaded. For parallel scanning without clamd:
  $ find /srv -type f | xargs -P 4 -I {} clamscan --no-summary {}
  (4 parallel processes)

## Scan Speed Optimization

  ### Skip large files:
  MaxFileSize 25M                  # Don't scan files over 25MB
  MaxScanSize 100M                 # Max data per archive scan

  ### Exclude patterns (clamscan):
  --exclude='\.iso$'
  --exclude='\.vmdk$'
  --exclude='\.img$'
  --exclude-dir='/backup'
  --exclude-dir='/var/lib/mysql'   # DB files — use application-level AV

  ### Exclude in clamd.conf:
  ExcludePath ^/proc
  ExcludePath ^/sys
  ExcludePath ^/dev
  ExcludePath ^/var/lib/mysql
  ExcludePath \.log$

## Archive Scanning Limits

  Deep archive scanning can be extremely slow. Limit it:
  MaxRecursion 10                  # Max archive nesting depth (default 17)
  MaxFiles 10000                   # Max files in archive (default 10000)
  MaxScanSize 100M                 # Max data to scan per file/archive
  MaxPartitions 50                 # Max partitions in raw disk image
  MaxIconsPE 100                   # Max icons in PE file
  AlertExceedsMax yes              # Alert instead of silently skip

## I/O Priority

  Reduce impact on production workloads:
  # ionice -c3 clamscan -r /srv/     # Idle I/O priority
  # nice -n 19 clamscan -r /srv/     # Lowest CPU priority

  In systemd service:
  [Service]
  Nice=19
  IOSchedulingClass=idle
  CPUQuota=50%
  MemoryMax=1G

## Benchmarking

  $ time clamscan -r /srv/data/
  real    12m34.567s
  user    11m22.333s
  sys     1m12.234s

  $ clamscan --statistics=pcre -r /tmp/testfiles/
  (Shows PCRE engine performance stats)

## Preloading (clamd)

  clamd preloads all signatures at startup. Startup time is 15-60s
  depending on hardware. After that, scans are near-instant.

  Monitor clamd startup:
  $ systemctl status clamav-daemon
  $ tail -f /var/log/clamav/clamd.log
  (Look for "Self checking every 3600 seconds" = ready)
EOF
}

CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in
    intro) cmd_intro "$@" ;;
    scan) cmd_scan "$@" ;;
    update) cmd_update "$@" ;;
    daemon) cmd_daemon "$@" ;;
    signatures) cmd_signatures "$@" ;;
    quarantine) cmd_quarantine "$@" ;;
    automation) cmd_automation "$@" ;;
    performance) cmd_performance "$@" ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "clamav v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: clamav help"; exit 1 ;;
esac
