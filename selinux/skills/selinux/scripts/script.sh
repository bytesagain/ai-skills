#!/usr/bin/env bash
# selinux — SELinux mandatory access control reference. Real commands, real configs.
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

show_help() {
    cat << 'HELPEOF'
selinux — SELinux Mandatory Access Control Reference

Usage: selinux <command>

Commands:
  intro           MAC vs DAC, SELinux architecture and origin
  modes           Enforcing, permissive, disabled — switching modes
  contexts        Security contexts (user:role:type:level)
  booleans        SELinux booleans for runtime policy tuning
  policy          Policy types, modules, and management
  troubleshoot    audit2why, sealert, and fixing AVC denials
  file-labels     chcon, restorecon, semanage fcontext
  ports           Managing port labels with semanage port
  help            Show this help
  version         Show version

Powered by BytesAgain | bytesagain.com
HELPEOF
}

cmd_intro() {
    cat << 'EOF'
# SELinux — Mandatory Access Control

## DAC vs MAC

Traditional Unix uses Discretionary Access Control (DAC) — file owners set
permissions (rwx). Any process running as root bypasses all DAC checks.

SELinux adds Mandatory Access Control (MAC) on top of DAC. Even root processes
are confined by policy. A compromised httpd running as root still cannot read
/etc/shadow unless the SELinux policy explicitly allows the httpd_t type to
access shadow_t files.

## Origin

SELinux was developed by the NSA (National Security Agency) and released as
open source in 2000. It was merged into the mainline Linux kernel in 2.6.0
(December 2003). Red Hat adopted it as the default in RHEL 4.

## Architecture

  Userspace process
       ↓ system call
  Linux Security Module (LSM) hook
       ↓
  SELinux Access Vector Cache (AVC)
       ↓ cache miss
  Security Server (policy engine in kernel)
       ↓
  Allow / Deny → if denied, logged to /var/log/audit/audit.log

## Key Components

  sestatus          Show current SELinux status, mode, and policy
  getenforce        Print current mode (Enforcing/Permissive/Disabled)
  /etc/selinux/config   Persistent configuration (SELINUX= and SELINUXTYPE=)
  /sys/fs/selinux/      Kernel interface (pseudo-filesystem)

## Package Requirements (RHEL/CentOS/Fedora)

  yum install policycoreutils policycoreutils-python-utils
  yum install selinux-policy selinux-policy-targeted
  yum install setroubleshoot-server     # for sealert
  yum install setools-console           # sesearch, seinfo

## Quick Status Check

  $ sestatus
  SELinux status:                 enabled
  SELinuxfs mount:                /sys/fs/selinux
  SELinux root directory:         /etc/selinux
  Loaded policy name:             targeted
  Current mode:                   enforcing
  Mode from config file:          enforcing
  Policy MLS status:              enabled
  Policy deny_unknown status:     allowed
  Memory protection checking:     actual (secure)
  Max kernel policy version:      33
EOF
}

cmd_modes() {
    cat << 'EOF'
# SELinux — Modes

## Three Modes

  Enforcing    Policy is enforced. Violations are denied AND logged.
  Permissive   Policy is NOT enforced. Violations are logged only.
  Disabled     SELinux is completely off. No labeling, no logging.

## Check Current Mode

  $ getenforce
  Enforcing

  $ sestatus | grep "Current mode"
  Current mode:                   enforcing

## Switch at Runtime (temporary, until reboot)

  # setenforce 1          # Switch to Enforcing
  # setenforce 0          # Switch to Permissive

  Note: You CANNOT switch to/from Disabled at runtime.
  Disabled requires a reboot.

## Persistent Configuration

  /etc/selinux/config
  ─────────────────────
  # This file controls the state of SELinux on the system.
  SELINUX=enforcing
  # SELINUX=permissive
  # SELINUX=disabled

  SELINUXTYPE=targeted

  After changing to disabled or from disabled: reboot required.

## Per-Domain Permissive Mode

  Instead of making the entire system permissive, you can make
  a single domain permissive while the rest stays enforcing:

  # semanage permissive -a httpd_t       # Make httpd_t permissive
  # semanage permissive -d httpd_t       # Restore to enforcing
  # semanage permissive -l               # List permissive domains

  This is useful for debugging a single service without weakening
  the entire system.

## Boot Parameters

  Kernel command line (GRUB):
    enforcing=0        Boot in permissive mode
    enforcing=1        Boot in enforcing mode
    selinux=0          Disable SELinux entirely (avoid this)
    selinux=1          Enable SELinux

  Edit /etc/default/grub → GRUB_CMDLINE_LINUX, then:
  # grub2-mkconfig -o /boot/grub2/grub.cfg

## Re-enabling After Disabled

  If SELinux was disabled, re-enabling requires a full filesystem relabel:
  1. Set SELINUX=enforcing in /etc/selinux/config
  2. Touch the relabel flag: # touch /.autorelabel
  3. Reboot — the system will relabel all files (can take 10-30+ minutes)
EOF
}

cmd_contexts() {
    cat << 'EOF'
# SELinux — Security Contexts

## Context Format

  Every process, file, port, and user has a security context:

    user:role:type:level
    │     │    │     └─ MLS/MCS level (s0, s0:c0.c1023)
    │     │    └─ Type (most important — used by Type Enforcement)
    │     └─ Role (used by RBAC — role-based access control)
    └─ SELinux user (mapped from Linux user)

  Example:
    system_u:system_r:httpd_t:s0

## Viewing File Contexts

  $ ls -Z /var/www/html/index.html
  unconfined_u:object_r:httpd_sys_content_t:s0 /var/www/html/index.html

  $ ls -Zd /var/www/html
  system_u:object_r:httpd_sys_content_t:s0 /var/www/html

  $ ls -Z /etc/shadow
  system_u:object_r:shadow_t:s0 /etc/shadow

## Viewing Process Contexts

  $ ps -eZ | grep httpd
  system_u:system_r:httpd_t:s0    1234 ?  00:00:02 httpd

  $ ps -eZ | grep sshd
  system_u:system_r:sshd_t:s0-s0:c0.c1023  890 ?  00:00:00 sshd

## Common SELinux Users

  unconfined_u    Mapped to regular Linux users (no confinement)
  system_u        System processes and files
  staff_u         Users who can switch to sysadm_r
  user_u          Confined regular users (no su/sudo to root)
  sysadm_u        Full system admin (if RBAC enabled)

## Mapping Linux Users to SELinux Users

  $ semanage login -l
  Login Name     SELinux User    MLS/MCS Range     Service
  __default__    unconfined_u    s0-s0:c0.c1023    *
  root           unconfined_u    s0-s0:c0.c1023    *

  # semanage login -a -s staff_u jdoe        # Map jdoe to staff_u
  # semanage login -d jdoe                   # Remove mapping

## Important Types (Targeted Policy)

  httpd_t                 Apache/Nginx process
  httpd_sys_content_t     Web content (read-only by httpd)
  httpd_sys_rw_content_t  Web content (read-write by httpd)
  mysqld_t                MySQL/MariaDB process
  mysqld_db_t             MySQL data files
  sshd_t                  SSH daemon
  user_home_t             User home directory files
  tmp_t                   /tmp files
  var_log_t               Log files
  shadow_t                /etc/shadow
  etc_t                   Generic /etc files

## id -Z (Current User Context)

  $ id -Z
  unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
EOF
}

cmd_booleans() {
    cat << 'EOF'
# SELinux — Booleans

## What Are Booleans?

Booleans are on/off switches that modify SELinux policy at runtime
without writing custom policy modules. They're the simplest way to
adjust what confined processes can do.

## Listing Booleans

  $ getsebool -a                    # List all booleans and values
  $ getsebool -a | wc -l            # Typically 300-400+ booleans
  $ getsebool httpd_can_network_connect
  httpd_can_network_connect --> off

  $ semanage boolean -l              # List with descriptions
  $ semanage boolean -l | grep httpd # Filter for httpd-related

## Setting Booleans

  Temporary (revert on reboot):
  # setsebool httpd_can_network_connect on

  Persistent (survives reboot — writes to policy store):
  # setsebool -P httpd_can_network_connect on

  The -P flag is critical. Without it, your change is lost on reboot.

## Commonly Needed Booleans

  ### Web Server (httpd)
  httpd_can_network_connect=on        Allow httpd to make outbound TCP
                                      (needed for reverse proxy, API calls)
  httpd_can_network_connect_db=on     Allow httpd to connect to databases
  httpd_can_sendmail=on               Allow httpd to send mail
  httpd_enable_homedirs=on            Allow httpd to serve ~/public_html
  httpd_use_nfs=on                    Allow httpd to serve NFS-mounted content
  httpd_can_network_relay=on          Allow httpd to act as reverse proxy
  httpd_execmem=on                    Allow httpd to execute memory (PHP JIT)

  ### Samba
  samba_enable_home_dirs=on           Allow Samba to share home dirs
  samba_export_all_ro=on              Allow Samba read-only access everywhere
  samba_export_all_rw=on              Allow Samba read-write access everywhere

  ### FTP
  ftpd_full_access=on                Allow FTP full filesystem access
  ftpd_use_nfs=on                    Allow FTP to serve NFS content
  ftp_home_dir=on                    Allow FTP access to home dirs

  ### NFS / CIFS
  use_nfs_home_dirs=on               Allow NFS home directories
  use_samba_home_dirs=on             Allow CIFS home directories

  ### Other
  domain_can_mmap_files=on           Allow domains to memory-map files
  virt_use_nfs=on                    Allow VMs to use NFS storage
  named_write_master_zones=on        Allow BIND to write zone files

## Finding Which Boolean You Need

  When you get an AVC denial, audit2why often tells you exactly
  which boolean to set:

  $ ausearch -m avc -ts recent | audit2why
  ...
  Was caused by: The boolean httpd_can_network_connect was set incorrectly.
  Allow: setsebool -P httpd_can_network_connect 1
EOF
}

cmd_policy() {
    cat << 'EOF'
# SELinux — Policy Types & Modules

## Policy Types (SELINUXTYPE in /etc/selinux/config)

  targeted     Default on RHEL/CentOS/Fedora. Only specific daemons are
               confined; everything else runs as unconfined_t.
               ~500 confined domains. Best balance of security and usability.

  mls          Multi-Level Security. Implements Bell-LaPadula model
               (no read up, no write down). Used in classified environments.
               Every process and file gets a sensitivity level (s0-s15)
               and compartments (c0-c1023).

  minimum      Like targeted but starts with fewer modules loaded.
               You add only what you need.

## Policy Modules

  The policy is modular — composed of base + many loadable modules.

  $ semodule -l                      # List loaded modules
  $ semodule -l | wc -l              # Count modules (~400+)
  $ semodule -lfull                  # Full list with priority & version

  Modules are stored in /etc/selinux/targeted/modules/active/

## Installing/Removing Modules

  # semodule -i mymodule.pp          # Install a compiled module
  # semodule -r mymodule             # Remove a module
  # semodule -d mymodule             # Disable a module
  # semodule -e mymodule             # Enable a disabled module

## Creating Custom Policy Modules

  When audit2why says you need a custom policy:

  1. Generate a Type Enforcement (.te) file from AVC denials:
     $ ausearch -m avc -ts recent | audit2allow -m myfix > myfix.te

  2. Review the .te file (NEVER blindly compile audit2allow output):
     $ cat myfix.te
     module myfix 1.0;
     require {
         type httpd_t;
         type var_lib_t;
         class file { read open getattr };
     }
     allow httpd_t var_lib_t:file { read open getattr };

  3. Compile to a policy package:
     $ checkmodule -M -m -o myfix.mod myfix.te
     $ semodule_package -o myfix.pp -m myfix.mod

  4. Install:
     # semodule -i myfix.pp

## Querying Policy Rules

  $ sesearch --allow -s httpd_t -t httpd_sys_content_t
  allow httpd_t httpd_sys_content_t:file { getattr ioctl lock open read };
  allow httpd_t httpd_sys_content_t:dir { getattr ioctl lock open read search };

  $ seinfo -t | grep httpd            # List all types matching httpd
  $ seinfo -r                          # List all roles
  $ seinfo -u                          # List all SELinux users
  $ seinfo --portcon 80                # What type owns port 80

## Policy Priorities (RHEL 8+)

  Modules have priority levels (default 400). Higher priority wins:
  # semodule -i myfix.pp -X 500       # Install at priority 500
EOF
}

cmd_troubleshoot() {
    cat << 'EOF'
# SELinux — Troubleshooting AVC Denials

## The AVC Denial Log Entry

  Denials appear in /var/log/audit/audit.log (if auditd is running)
  or in journalctl / dmesg if auditd is not installed.

  type=AVC msg=audit(1615389210.123:456): avc:  denied  { read } for
  pid=1234 comm="httpd" name="config.php" dev="sda1" ino=789012
  scontext=system_u:system_r:httpd_t:s0
  tcontext=unconfined_u:object_r:user_home_t:s0
  tclass=file permissive=0

  Key fields:
    denied { read }     — the permission that was denied
    comm="httpd"        — the process name
    name="config.php"   — the target file
    scontext=...httpd_t — source (process) type
    tcontext=...user_home_t — target (file) type
    tclass=file         — object class

## audit2why — Explain Why It Was Denied

  $ ausearch -m avc -ts today | audit2why

  Typical output:
    Was caused by:
      Missing type enforcement (TE) allow rule.
    OR:
      The boolean httpd_can_network_connect was set incorrectly.
      Allow: setsebool -P httpd_can_network_connect 1
    OR:
      Missing file context — use restorecon.

## sealert — Human-Readable Analysis

  Requires: yum install setroubleshoot-server

  $ sealert -a /var/log/audit/audit.log

  Output includes:
  - What happened (plain English)
  - Confidence rating for each suggested fix
  - Exact commands to fix the issue

  Real-time alerts via setroubleshootd (D-Bus notifications):
  # systemctl enable --now setroubleshootd

  Check recent alerts:
  $ journalctl -t setroubleshoot --since today

## Common Causes & Fixes

  1. Wrong file context (most common):
     A file was created in the wrong location or copied without
     preserving context (cp instead of cp --preserve=context).
     Fix: # restorecon -Rv /path/to/files

  2. Boolean not set:
     Fix: # setsebool -P boolean_name on

  3. Non-standard port:
     httpd trying to listen on port 8443.
     Fix: # semanage port -a -t http_port_t -p tcp 8443

  4. Custom application needs policy:
     Fix: Generate module with audit2allow (see 'policy' command)

  5. File in wrong location:
     e.g., web files in /srv instead of /var/www
     Fix: # semanage fcontext -a -t httpd_sys_content_t "/srv/www(/.*)?"
          # restorecon -Rv /srv/www

## Debugging Workflow

  1. Check if SELinux is the problem:
     # setenforce 0    (temporarily permissive)
     Test again. If it works → SELinux is blocking it.
     # setenforce 1    (re-enable immediately)

  2. Find the denial:
     $ ausearch -m avc -ts recent
     $ ausearch -m avc -c httpd    (filter by command)

  3. Analyze:
     $ ausearch -m avc -ts recent | audit2why

  4. Fix and verify.
EOF
}

cmd_file_labels() {
    cat << 'EOF'
# SELinux — File Labels (Contexts)

## How Files Get Labeled

  Files inherit context from their parent directory when created.
  cp creates a new file → gets destination directory context.
  mv preserves the original context (often causes problems!).

  $ cp /home/user/index.html /var/www/html/    # Gets httpd_sys_content_t ✓
  $ mv /home/user/index.html /var/www/html/    # Keeps user_home_t ✗

## Viewing File Contexts

  $ ls -Z /var/www/html/
  -rw-r--r--. root root unconfined_u:object_r:httpd_sys_content_t:s0 index.html

  $ stat -c '%C' /var/www/html/index.html
  unconfined_u:object_r:httpd_sys_content_t:s0

## chcon — Change Context (Temporary)

  Changes do NOT survive a restorecon or filesystem relabel.
  Use only for testing.

  # chcon -t httpd_sys_content_t /srv/www/index.html
  # chcon -R -t httpd_sys_content_t /srv/www/        # Recursive
  # chcon --reference=/var/www/html /srv/www/         # Copy context from ref

## restorecon — Restore Default Context

  Resets file contexts to the default defined in the file context database.
  This is the command you'll use most often.

  # restorecon -v /var/www/html/index.html     # Single file, verbose
  # restorecon -Rv /var/www/html/              # Recursive
  # restorecon -Rv -n /var/www/html/           # Dry run (show what would change)

  -F forces reset of user, role, and type (normally only type is reset).

## semanage fcontext — Persistent File Context Rules

  This is the correct way to permanently define contexts for custom paths.

  ### Add a rule:
  # semanage fcontext -a -t httpd_sys_content_t "/srv/www(/.*)?"
  # restorecon -Rv /srv/www/

  ### Add a rule for read-write web content:
  # semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/uploads(/.*)?"
  # restorecon -Rv /var/www/uploads/

  ### List custom rules:
  $ semanage fcontext -l -C     # -C shows only local customizations

  ### Delete a rule:
  # semanage fcontext -d -t httpd_sys_content_t "/srv/www(/.*)?"

  ### List all default rules:
  $ semanage fcontext -l | grep httpd
  /var/www(/.*)?        all files   system_u:object_r:httpd_sys_content_t:s0
  /var/www/cgi-bin(/.*)?  all files   system_u:object_r:httpd_sys_script_exec_t:s0

## matchpathcon — Check Expected Context

  $ matchpathcon /var/www/html/index.html
  /var/www/html/index.html    system_u:object_r:httpd_sys_content_t:s0

  Compare expected vs actual:
  $ matchpathcon -V /var/www/html/index.html
  /var/www/html/index.html verified.

## Equivalence Rules

  Make SELinux treat one path the same as another:
  # semanage fcontext -a -e /var/www /srv/www
  (Now /srv/www gets the same labeling rules as /var/www)

## Common Gotchas

  - tar/rsync: Use --selinux flag to preserve contexts
    $ tar --selinux -czf backup.tar.gz /var/www/
    $ rsync -aZ source/ dest/       # -Z preserves SELinux contexts
  - Files created in /tmp get tmp_t — move to target and restorecon
  - Docker volumes may need :Z or :z mount option for relabeling
EOF
}

cmd_ports() {
    cat << 'EOF'
# SELinux — Port Labels

## How Port Labeling Works

  SELinux assigns types to network ports. A confined process can only
  bind to or connect to ports labeled with types it has policy for.

  Example: httpd_t can bind to http_port_t ports. By default that
  includes 80, 443, 488, 8008, 8009, 8443.

## List Port Assignments

  $ semanage port -l                           # All port labels
  $ semanage port -l | grep http_port_t
  http_port_t                    tcp      80, 81, 443, 488, 8008, 8009, 8443
  http_port_t                    udp      80, 81, 443, 488, 8008, 8009, 8443

  $ semanage port -l | grep ssh
  ssh_port_t                     tcp      22

  $ semanage port -l | grep 3306
  mysqld_port_t                  tcp      1186, 3306, 63132-63164

## Adding Custom Ports

  ### Allow httpd to listen on port 8080:
  # semanage port -a -t http_port_t -p tcp 8080

  ### Allow httpd to listen on port 9443:
  # semanage port -a -t http_port_t -p tcp 9443

  ### Allow SSH on non-standard port:
  # semanage port -a -t ssh_port_t -p tcp 2222

  ### Allow a database on a custom port:
  # semanage port -a -t mysqld_port_t -p tcp 3307
  # semanage port -a -t postgresql_port_t -p tcp 5433

## Modifying Existing Port Labels

  If a port is already assigned to another type, use -m (modify):
  # semanage port -m -t http_port_t -p tcp 8888

  Common error without -m:
  ValueError: Port tcp/8888 already defined

## Deleting Custom Port Labels

  # semanage port -d -t http_port_t -p tcp 8080

  You can only delete custom (locally added) labels, not built-in ones.

## Listing Only Custom Ports

  $ semanage port -l -C
  (Shows only locally customized port labels)

## Port Ranges

  # semanage port -a -t http_port_t -p tcp 8000-8099
  (Adds a range of ports in one command)

## Common Port Types

  http_port_t          TCP 80, 443, 8008, 8009, 8443
  ssh_port_t           TCP 22
  smtp_port_t          TCP 25, 465, 587
  mysqld_port_t        TCP 3306
  postgresql_port_t    TCP 5432
  dns_port_t           TCP/UDP 53
  ntp_port_t           UDP 123
  ldap_port_t          TCP 389, 636
  kerberos_port_t      TCP/UDP 88, 749
  mongod_port_t        TCP 27017-27019
  redis_port_t         TCP 6379
  zabbix_port_t        TCP 10050, 10051

## Troubleshooting Port Denials

  AVC denial for bind():
  type=AVC msg=audit(...): avc: denied { name_bind } for pid=1234
  comm="httpd" src=8090 scontext=...httpd_t tcontext=...unreserved_port_t

  Fix: # semanage port -a -t http_port_t -p tcp 8090

  AVC denial for connect():
  type=AVC msg=audit(...): avc: denied { name_connect } for pid=5678
  comm="httpd" ... tcontext=...port_t

  Fix: Check if you need httpd_can_network_connect boolean instead.
EOF
}

CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in
    intro) cmd_intro "$@" ;;
    modes) cmd_modes "$@" ;;
    contexts) cmd_contexts "$@" ;;
    booleans) cmd_booleans "$@" ;;
    policy) cmd_policy "$@" ;;
    troubleshoot) cmd_troubleshoot "$@" ;;
    file-labels) cmd_file_labels "$@" ;;
    ports) cmd_ports "$@" ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "selinux v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: selinux help"; exit 1 ;;
esac
