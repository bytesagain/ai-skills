#!/bin/bash
# Cron Scheduler - Unix Job Scheduling Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              CRON REFERENCE                                 ║
║          Unix/Linux Job Scheduling                          ║
╚══════════════════════════════════════════════════════════════╝

Cron is the standard Unix job scheduler. It runs commands at
specified times and intervals.

CRON EXPRESSION FORMAT:
  ┌───────── minute (0-59)
  │ ┌───────── hour (0-23)
  │ │ ┌───────── day of month (1-31)
  │ │ │ ┌───────── month (1-12 or JAN-DEC)
  │ │ │ │ ┌───────── day of week (0-7 or SUN-SAT, 0 and 7 = Sunday)
  │ │ │ │ │
  * * * * *  command

SPECIAL CHARACTERS:
  *    Any value
  ,    Value list (1,3,5)
  -    Range (1-5)
  /    Step (*/15 = every 15)

EXAMPLES:
  * * * * *              Every minute
  */5 * * * *            Every 5 minutes
  0 * * * *              Every hour (at :00)
  0 */2 * * *            Every 2 hours
  30 9 * * *             Daily at 09:30
  0 9 * * 1-5            Weekdays at 09:00
  0 0 * * *              Midnight daily
  0 0 1 * *              First of every month
  0 0 * * 0              Every Sunday midnight
  15 14 1 * *            1st of month at 14:15
  0 22 * * 1-5           Weekdays at 22:00
  0 9,18 * * *           Daily at 09:00 and 18:00
  */10 9-17 * * 1-5      Every 10 min, 9am-5pm, weekdays

SPECIAL STRINGS:
  @reboot                Run once at startup
  @yearly   (= 0 0 1 1 *)  Once a year
  @monthly  (= 0 0 1 * *)  Once a month
  @weekly   (= 0 0 * * 0)  Once a week
  @daily    (= 0 0 * * *)  Once a day
  @hourly   (= 0 * * * *)  Once an hour
EOF
}

cmd_management() {
cat << 'EOF'
CRONTAB MANAGEMENT
====================

COMMANDS:
  crontab -e               # Edit your crontab
  crontab -l               # List your crontab
  crontab -r               # Remove your crontab (careful!)
  crontab -u username -e   # Edit another user's crontab (root only)
  crontab -u username -l   # List another user's crontab

CRONTAB FILE FORMAT:
  # Environment variables
  SHELL=/bin/bash
  PATH=/usr/local/bin:/usr/bin:/bin
  MAILTO=admin@example.com
  HOME=/home/admin

  # Jobs
  0 5 * * * /home/admin/scripts/backup.sh
  */10 * * * * /usr/bin/python3 /home/admin/monitor.py
  0 0 * * 0 /home/admin/scripts/weekly-cleanup.sh

SYSTEM CRONTAB (/etc/crontab):
  # Has extra user field
  SHELL=/bin/bash
  PATH=/sbin:/bin:/usr/sbin:/usr/bin

  # min hour dom mon dow user command
  0 3 * * * root /usr/local/bin/backup.sh
  */5 * * * * www-data /var/www/app/cron.php

CRON DIRECTORIES:
  /etc/cron.d/         Drop-in crontab files (system format)
  /etc/cron.daily/     Scripts run daily
  /etc/cron.hourly/    Scripts run hourly
  /etc/cron.weekly/    Scripts run weekly
  /etc/cron.monthly/   Scripts run monthly

  # Scripts in these dirs must be executable and have no extension
  chmod +x /etc/cron.daily/my-script

OUTPUT HANDLING:
  # Discard all output
  0 * * * * /path/script.sh > /dev/null 2>&1

  # Log to file
  0 * * * * /path/script.sh >> /var/log/myjob.log 2>&1

  # Email output (set MAILTO)
  MAILTO=admin@example.com
  0 * * * * /path/script.sh

  # Log with timestamp
  0 * * * * /path/script.sh 2>&1 | ts '[%Y-%m-%d %H:%M:%S]' >> /var/log/myjob.log
EOF
}

cmd_patterns() {
cat << 'EOF'
COMMON PATTERNS & BEST PRACTICES
===================================

LOCK FILE (prevent overlap):
  #!/bin/bash
  LOCKFILE=/tmp/myjob.lock
  if [ -f "$LOCKFILE" ]; then
      echo "Already running"
      exit 0
  fi
  trap "rm -f $LOCKFILE" EXIT
  touch "$LOCKFILE"
  # ... your job here ...

  # Or use flock:
  */5 * * * * flock -n /tmp/myjob.lock /path/script.sh

TIMEOUT:
  */5 * * * * timeout 240 /path/long-running-job.sh

RANDOM DELAY (distribute load):
  # Sleep 0-300 seconds before running
  0 3 * * * sleep $((RANDOM \% 300)) && /path/script.sh

ERROR NOTIFICATION:
  #!/bin/bash
  set -euo pipefail
  /path/to/job.sh || {
      echo "Job failed at $(date)" | mail -s "CRON ALERT" admin@example.com
      exit 1
  }

LOG ROTATION:
  # In /etc/logrotate.d/mycron
  /var/log/myjob.log {
      daily
      rotate 7
      compress
      missingok
      notifempty
  }

ENVIRONMENT GOTCHAS:
  Cron has minimal environment! Common issues:
  - PATH is limited (use full paths)
  - No shell aliases or functions
  - No .bashrc/.profile loaded
  - HOME may differ from expected

  Fix: Set PATH in crontab or use full paths:
  PATH=/usr/local/bin:/usr/bin:/bin:/home/admin/.local/bin
  0 * * * * /full/path/to/python3 /full/path/to/script.py

DEBUGGING:
  # Check cron is running
  systemctl status cron      # Debian/Ubuntu
  systemctl status crond     # RHEL/CentOS

  # Check cron logs
  grep CRON /var/log/syslog           # Debian/Ubuntu
  grep CRON /var/log/cron             # RHEL/CentOS
  journalctl -u cron --since today    # systemd

  # Test your command manually first!
  env -i SHELL=/bin/bash PATH=/usr/bin:/bin HOME=$HOME /path/script.sh

ALTERNATIVES:
  systemd timers   More flexible, better logging
  anacron          For machines not always on
  at               One-time scheduled jobs
  fcron            For laptops (catches missed jobs)

SYSTEMD TIMER EQUIVALENT:
  # /etc/systemd/system/backup.timer
  [Unit]
  Description=Daily backup

  [Timer]
  OnCalendar=*-*-* 03:00:00
  Persistent=true

  [Install]
  WantedBy=timers.target

  # /etc/systemd/system/backup.service
  [Unit]
  Description=Backup job

  [Service]
  Type=oneshot
  ExecStart=/home/admin/scripts/backup.sh
  User=admin

  systemctl enable --now backup.timer
  systemctl list-timers

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Cron Scheduler - Unix Job Scheduling Reference

Commands:
  intro       Cron expressions, format, examples
  management  crontab, directories, output handling
  patterns    Locking, timeout, debugging, systemd timers

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  management) cmd_management ;;
  patterns)   cmd_patterns ;;
  help|*)     show_help ;;
esac
