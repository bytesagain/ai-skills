#!/usr/bin/env bash
# copy — File & Data Copy Operations Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Copy Operations Overview ===

Copying is the fundamental operation of duplicating data from source
to destination. Different strategies have vastly different performance
and correctness characteristics.

Copy Semantics:
  Shallow Copy    Copy metadata/references only (symlinks stay as links)
  Deep Copy       Recursively copy all data (follow and duplicate symlinks)
  Reflink/CoW     Share data blocks until modified (instant, space-efficient)
  Hard Link       Multiple names for same inode (no data duplication)

Core Unix Commands:
  cp              Basic file/directory copy
  cp -a           Archive mode (preserves permissions, timestamps, symlinks)
  cp -r           Recursive directory copy
  cp --reflink    Copy-on-write (if filesystem supports it)
  rsync           Incremental sync with delta transfer
  dd              Block-level copy (raw disk/partition)
  tar | tar       Stream-based copy (preserves everything)
  scp / sftp      Secure remote copy over SSH
  pv              Pipe viewer (copy with progress)

Key Considerations:
  1. Metadata preservation (permissions, timestamps, xattrs, ACLs)
  2. Symlink handling (follow vs preserve)
  3. Sparse file handling (maintain holes or fill them)
  4. Cross-filesystem behavior (device boundaries)
  5. Atomic operations (partial copy risk)
  6. Character encoding in filenames
  7. Large file support (>2GB, >4GB boundaries)

Platform Differences:
  Linux     cp -a, rsync, reflink on btrfs/xfs
  macOS     cp -pR, ditto (preserves resource forks), rsync (no coreutils)
  Windows   robocopy, xcopy, Copy-Item (PowerShell)
  FreeBSD   cp -a, rsync
EOF
}

cmd_rsync() {
    cat << 'EOF'
=== Rsync Patterns ===

Rsync is the gold standard for efficient file synchronization.
It uses delta-transfer algorithm to send only differences.

Basic Patterns:

  # Local sync
  rsync -av src/ dest/

  # Remote sync (SSH)
  rsync -avz src/ user@host:dest/

  # Mirror (delete extraneous files in dest)
  rsync -av --delete src/ dest/

  # Dry run (preview changes)
  rsync -avn --delete src/ dest/

Essential Flags:
  -a    Archive (recursive, preserves permissions/timestamps/symlinks)
  -v    Verbose
  -z    Compress during transfer
  -P    Progress + partial (resume interrupted transfers)
  -n    Dry run
  --delete           Remove files in dest not in src
  --delete-after     Delete after transfer (safer)
  --exclude='*.tmp'  Skip matching files
  --include='*.log'  Force include matching files
  --backup           Keep backup of replaced files
  --backup-dir=DIR   Put backups in specific directory
  --bwlimit=1000     Limit bandwidth (KB/s)
  --checksum         Compare by checksum, not mod-time/size

Trailing Slash Matters:
  rsync -av src/ dest/    Copies CONTENTS of src into dest
  rsync -av src  dest/    Copies src DIRECTORY into dest (dest/src/...)

Exclude Patterns:
  --exclude='*.pyc'
  --exclude='.git/'
  --exclude='node_modules/'
  --exclude-from='.rsyncignore'

  # Include only certain files
  --include='*.py' --exclude='*'

Incremental Backup with Hard Links:
  rsync -av --link-dest=../prev-backup src/ backup-2024-01-15/
  # Unchanged files are hard-linked to previous backup
  # Only changed files take new disk space

Remote Rsync Tricks:
  # Use specific SSH key
  rsync -av -e "ssh -i ~/.ssh/mykey" src/ user@host:dest/

  # Use non-standard port
  rsync -av -e "ssh -p 2222" src/ user@host:dest/

  # Limit to specific interface
  rsync -av --address=192.168.1.10 src/ user@host:dest/
EOF
}

cmd_cow() {
    cat << 'EOF'
=== Copy-on-Write (CoW) ===

Copy-on-Write creates an instant copy that shares data blocks
with the original. New blocks are allocated only when modified.

How It Works:
  1. Copy operation creates new metadata pointing to same blocks
  2. Both files share physical storage (zero copy time)
  3. When either file is modified, only changed blocks are duplicated
  4. Unmodified blocks remain shared indefinitely

Filesystem Support:
  Btrfs       Full CoW support (default behavior)
  XFS         Reflink support (mkfs.xfs -m reflink=1)
  APFS        Native CoW on macOS (10.13+)
  ZFS         Block-level CoW (always on)
  OCFS2       Reflink support
  ext4        Not supported
  NTFS        Not supported (ReFS has it on Windows Server)

Using Reflinks:
  # GNU cp with reflink
  cp --reflink=auto src dest    # Use CoW if possible, fall back to copy
  cp --reflink=always src dest  # Fail if CoW not available

  # Btrfs-specific
  btrfs filesystem du -s dir/   # Shows shared vs exclusive space

  # macOS APFS
  cp -c src dest                # APFS clone (CoW)

Benefits:
  - Instant copy (O(1) time regardless of file size)
  - Space efficient (shared blocks)
  - Great for snapshots, VM images, container layers
  - No performance penalty for reads

Gotchas:
  - CoW fragmentation over time (Btrfs defrag needed)
  - Cross-filesystem copies can't use CoW
  - Some backup tools don't preserve CoW relationships
  - Quota accounting may show shared space differently
  - Not all tools support --reflink (check coreutils version ≥8.24)

When to Use CoW:
  ✓ VM disk images (quick clones for testing)
  ✓ Container layers (overlayfs + CoW filesystem)
  ✓ Build systems (copy source tree for clean builds)
  ✓ Database snapshots (instant point-in-time copies)
  ✗ Files that will be completely rewritten (no benefit)
  ✗ Cross-device copies (not possible)
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Copy Patterns ===

1. Full Mirror
   rsync -av --delete src/ dest/
   - Exact replica of source
   - Deletions propagate to destination
   - Use for active mirrors and CDN origin sync

2. Incremental Backup (with hard links)
   rsync -av --link-dest=../yesterday src/ backup-today/
   - Each backup appears as full copy
   - Unchanged files are hard-linked (zero extra space)
   - Delete old backups without affecting newer ones
   - Used by: Time Machine, rsnapshot, borgbackup

3. Differential Copy
   rsync -av --compare-dest=../baseline src/ diff-output/
   - Only copies files that differ from baseline
   - Good for creating patch/update packages

4. Append-Only Sync
   rsync -av --append-verify src/logs/ dest/logs/
   - Only transfers new data appended to files
   - Perfect for growing log files
   - --append-verify checksums after append

5. Streaming Copy (tar pipe)
   tar cf - -C src . | tar xf - -C dest
   - Preserves all metadata including hard links
   - Good for moving entire directory trees
   - Can pipe through ssh: tar cf - . | ssh host 'tar xf - -C /dest'
   - Can pipe through pv for progress: tar cf - . | pv | tar xf - -C /dest

6. Atomic Copy Pattern
   cp src dest.tmp && mv dest.tmp dest
   - Never leaves dest in partial state
   - mv is atomic on same filesystem
   - Essential for config files and databases

7. Sparse-Aware Copy
   cp --sparse=always src dest
   rsync --sparse src dest
   - Preserves holes in sparse files
   - Critical for VM images and databases
   - Without this, a 100GB sparse file with 1GB data becomes 100GB

8. Parallel Copy
   find src -type f | parallel -j8 cp {} dest/{/}
   - Copy multiple files simultaneously
   - Good for many small files on SSD
   - For HDD: sequential is usually faster (seek overhead)
EOF
}

cmd_filters() {
    cat << 'EOF'
=== File Filtering Techniques ===

By Extension:
  # Copy only Python files
  rsync -av --include='*/' --include='*.py' --exclude='*' src/ dest/

  # Copy everything except compiled files
  rsync -av --exclude='*.pyc' --exclude='*.o' --exclude='*.class' src/ dest/

  # Using find + cp
  find src -name '*.jpg' -exec cp --parents {} dest/ \;

By Date:
  # Files modified in last 7 days
  find src -mtime -7 -exec cp --parents {} dest/ \;

  # Files newer than a reference file
  find src -newer reference.txt -exec cp --parents {} dest/ \;

  # rsync: skip files newer in destination
  rsync -av --update src/ dest/

By Size:
  # Files larger than 10MB
  find src -size +10M -exec cp --parents {} dest/ \;

  # Files smaller than 1KB
  find src -size -1k -exec cp --parents {} dest/ \;

  # rsync: skip files above size
  rsync -av --max-size=50m src/ dest/

By Pattern File:
  # .rsyncignore (same syntax as .gitignore)
  rsync -av --exclude-from='.rsyncignore' src/ dest/

  # Content of .rsyncignore:
  # *.log
  # .git/
  # node_modules/
  # __pycache__/
  # *.tmp

Git-Aware Filtering:
  # Copy only tracked files
  git ls-files | rsync -av --files-from=- . dest/

  # Copy only modified files
  git diff --name-only | rsync -av --files-from=- . dest/

  # Respect .gitignore with rsync
  rsync -av --filter=':- .gitignore' src/ dest/

Combined Filters (order matters in rsync):
  rsync -av \
    --include='*.py' \
    --include='*.txt' \
    --include='*/' \
    --exclude='*' \
    --exclude='__pycache__/' \
    src/ dest/
  # Rules are evaluated top-to-bottom, first match wins
EOF
}

cmd_performance() {
    cat << 'EOF'
=== Copy Performance Optimization ===

Buffer & Block Size:
  # dd with optimal block size (test for your hardware)
  dd if=src of=dest bs=1M            # 1MB blocks (good default)
  dd if=src of=dest bs=64K           # 64KB for random I/O
  dd if=src of=dest bs=4M            # 4MB for sequential large files

  # Large file copy with progress
  pv -s $(stat -c%s src) src > dest

  # rsync with custom block size
  rsync -av --block-size=131072 src/ dest/

Parallel Copy Tools:
  GNU parallel:
    find src -type f | parallel -j$(nproc) cp {} dest/

  fpsync (part of fpart):
    fpsync -n 8 -f 1000 src/ dest/
    # -n 8: use 8 parallel rsync workers
    # -f 1000: pack 1000 files per rsync job

  rclone (for cloud/remote):
    rclone copy src remote:dest --transfers=16 --checkers=8

I/O Scheduling:
  # Set I/O priority (Linux)
  ionice -c2 -n0 cp src dest        # Best-effort, highest priority
  ionice -c3 cp src dest            # Idle-only (won't impact other I/O)

  # Use direct I/O to bypass page cache (large files)
  dd if=src of=dest bs=1M iflag=direct oflag=direct

Compression During Transfer:
  rsync -avz src/ remote:dest/      # Built-in compression
  rsync -av -e "ssh -C" src/ remote:dest/  # SSH compression
  # Don't compress already-compressed files:
  rsync -avz --skip-compress=gz/jpg/mp4/zip src/ remote:dest/

Network Optimization:
  # Increase SSH buffer
  rsync -av -e "ssh -o 'Compression=no' -T -c aes128-ctr" src/ remote:dest/

  # Use bbcp for high-bandwidth links
  bbcp -P 2 -w 4m src remote:dest

  # Use lftp for parallel SFTP
  lftp -e "mirror --parallel=10 src dest" sftp://host

Benchmarks (typical SSD, same machine):
  cp -a           ~400 MB/s for large files
  rsync -a        ~350 MB/s (overhead from checksumming)
  cp --reflink    ~instant (CoW, no data copied)
  dd bs=1M        ~500 MB/s (minimal overhead)
  tar | tar       ~380 MB/s (good metadata preservation)
EOF
}

cmd_errors() {
    cat << 'EOF'
=== Copy Errors & Troubleshooting ===

Permission Denied:
  Error: cp: cannot open 'file': Permission denied
  Fix:   sudo cp, or fix source permissions
         Check: ls -la file, stat file
         SELinux: ls -Z file, restorecon -v file

Cross-Device Link:
  Error: mv: cannot move across filesystems
  Fix:   Use cp + rm instead of mv
         Or: rsync -av --remove-source-files src dest

No Space Left on Device:
  Error: cp: write error: No space left on device
  Check: df -h dest_partition
  Fix:   Free space, or use rsync --max-size to copy in stages

Filename Too Long:
  Error: cp: cannot create 'path': File name too long
  Limits: ext4=255 bytes per component, 4096 bytes full path
  Fix:   Shorten names, or use tar to preserve long paths

Argument List Too Long:
  Error: /bin/cp: Argument list too long
  Cause: Glob expands to too many files (ARG_MAX limit)
  Fix:   find . -name '*.log' -exec cp {} dest/ \;
         Or: find . -name '*.log' | xargs -I{} cp {} dest/
         Or: rsync -av --include='*.log' --exclude='*' . dest/

Broken Symlinks:
  Error: cp: cannot stat 'link': No such file or directory
  Fix:   cp -a (preserves symlinks without following)
         Or: cp --no-dereference
         Check: find . -xtype l (find broken symlinks)

Sparse Files Expanding:
  Problem: 1GB sparse file becomes 100GB after copy
  Fix:    cp --sparse=always src dest
          rsync --sparse src dest
          tar --sparse -cf - src | tar xf - -C dest

Rsync Partial Transfers:
  Problem: Large transfer interrupted
  Fix:    rsync -avP src dest  (--partial + --progress)
          Re-run same command to resume
          --partial keeps partially transferred files

Timestamp Precision:
  Problem: Timestamps differ after copy (FAT32 = 2s resolution)
  Fix:    rsync --modify-window=2 src/ dest/
          Or accept that FAT32/exFAT can't preserve exact times
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Copy Verification Checklist ===

Pre-Copy:
  [ ] Verify source exists and is readable
  [ ] Check destination has sufficient space (df -h)
  [ ] Determine metadata requirements (permissions, timestamps, xattrs)
  [ ] Choose appropriate tool (cp, rsync, tar, reflink)
  [ ] Decide symlink handling (follow vs preserve)
  [ ] Check for sparse files that need special handling
  [ ] Run dry run first (rsync -avn, cp with echo)
  [ ] Consider bandwidth/I/O impact on production systems

During Copy:
  [ ] Monitor progress (rsync -P, pv, or watch df)
  [ ] Check for errors in output (pipe stderr to log)
  [ ] Verify no source modifications during copy (if consistency needed)
  [ ] Monitor disk space on destination

Post-Copy Verification:
  [ ] File count matches
      find src -type f | wc -l
      find dest -type f | wc -l

  [ ] Total size matches
      du -sb src/
      du -sb dest/

  [ ] Checksums match (for critical data)
      find src -type f -exec md5sum {} + | sort > src.md5
      cd dest && md5sum -c ../src.md5

  [ ] Permissions preserved
      rsync -avn src/ dest/  (should show no changes)

  [ ] Symlinks preserved correctly
      find dest -type l | head

  [ ] Timestamps preserved
      stat src/file dest/file  (compare mtime)

  [ ] No broken symlinks introduced
      find dest -xtype l

  [ ] Sparse files maintained (if applicable)
      du -sh file vs ls -lh file (allocated vs apparent size)

Integrity Tools:
  sha256sum   Cryptographic verification
  md5sum      Fast verification (not security-grade)
  rsync -c    Checksum-based comparison
  diff -rq    Quick directory comparison
  hashdeep    Recursive hashing with verification
EOF
}

show_help() {
    cat << EOF
copy v$VERSION — File & Data Copy Operations Reference

Usage: script.sh <command>

Commands:
  intro        Copy operations overview — types, tools, platforms
  rsync        Rsync patterns — flags, excludes, incremental backup
  cow          Copy-on-Write — reflinks, filesystem support
  patterns     Copy patterns — mirror, incremental, atomic, parallel
  filters      File filtering — by extension, date, size, gitignore
  performance  Performance tuning — buffer sizes, parallel copy, I/O
  errors       Common copy errors and troubleshooting guide
  checklist    Pre-copy and post-copy verification checklist
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    rsync)       cmd_rsync ;;
    cow)         cmd_cow ;;
    patterns)    cmd_patterns ;;
    filters)     cmd_filters ;;
    performance) cmd_performance ;;
    errors)      cmd_errors ;;
    checklist)   cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "copy v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
