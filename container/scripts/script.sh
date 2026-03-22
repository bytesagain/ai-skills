#!/usr/bin/env bash
# container — Container Technology Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Container Technology ===

A container is a standard unit of software that packages code and
all its dependencies so the application runs reliably across environments.

Containers are NOT lightweight VMs. They are isolated processes
sharing the host kernel, using Linux namespaces and cgroups.

  VM:         App → Guest OS → Hypervisor → Host OS → Hardware
  Container:  App → Container Runtime → Host OS → Hardware

History:
  1979    chroot — first process isolation on Unix
  2000    FreeBSD Jails — full process isolation
  2006    Google Process Containers → cgroups in Linux kernel
  2008    LXC (Linux Containers) — first complete container system
  2013    Docker — made containers developer-friendly
  2015    OCI (Open Container Initiative) — standardized format
  2017    containerd donated to CNCF
  2020    Kubernetes deprecates Docker runtime (uses containerd/CRI-O)

Architecture Stack:
  ┌─────────────────────────┐
  │ Container (your app)    │
  ├─────────────────────────┤
  │ Container Runtime       │
  │ (runc, crun)            │
  ├─────────────────────────┤
  │ Container Manager       │
  │ (containerd, CRI-O)     │
  ├─────────────────────────┤
  │ Container Engine        │
  │ (Docker, Podman)        │
  ├─────────────────────────┤
  │ Linux Kernel            │
  │ (namespaces + cgroups)  │
  └─────────────────────────┘

OCI Standards:
  Image Spec      How container images are built and structured
  Runtime Spec    How containers are created and run
  Distribution    How images are pushed/pulled from registries

Key Concepts:
  Image       Read-only template with app + dependencies (layers)
  Container   Running instance of an image
  Registry    Server that stores and distributes images
  Volume      Persistent storage that outlives the container
  Network     Virtual network connecting containers
EOF
}

cmd_namespaces() {
    cat << 'EOF'
=== Linux Namespaces ===

Namespaces provide isolation — each container sees its own view
of system resources, unaware of other containers.

7 Namespace Types:

  PID (Process ID)
    Container sees its own PID tree starting from PID 1
    Container's PID 1 = host's PID 48293 (example)
    Container can't see or signal host processes
    /proc inside container only shows container's processes

  NET (Network)
    Container gets its own network stack:
      - Network interfaces (eth0, lo)
      - IP addresses
      - Routing tables
      - iptables rules
      - Port space (container can use port 80 even if host uses it)
    Connected to host via virtual ethernet pair (veth)

  MNT (Mount)
    Container sees its own filesystem tree
    Host's /etc/passwd is NOT visible (container has its own)
    Volumes are mount points crossing namespace boundary
    Union filesystem (OverlayFS) provides layered view

  UTS (Unix Timesharing System)
    Container has its own hostname and domain name
    `hostname` inside container ≠ host hostname

  IPC (Inter-Process Communication)
    Isolates shared memory, semaphores, message queues
    Containers can't access each other's shared memory
    Unless explicitly sharing IPC namespace

  USER
    Maps container UIDs to host UIDs
    Container root (UID 0) → host UID 100000 (rootless)
    Prevents privilege escalation if container is compromised
    Requires: user namespace remapping in daemon config

  CGROUP (Control Group)
    Container sees only its own cgroup hierarchy
    Can't see or modify other containers' resource limits
    Added in Linux 4.6

Viewing Namespaces:
  ls -la /proc/<PID>/ns/          # list all namespaces for a process
  lsns                            # list all namespaces on system
  nsenter -t <PID> -n ip addr     # enter network namespace of PID
  unshare --pid --mount --fork bash  # create new namespaces manually
EOF
}

cmd_cgroups() {
    cat << 'EOF'
=== Control Groups (cgroups) ===

Cgroups limit, account for, and isolate resource usage of processes.
While namespaces control WHAT a process can see, cgroups control
HOW MUCH a process can use.

cgroups v1 vs v2:
  v1: Multiple hierarchies, one per resource controller (legacy)
  v2: Single unified hierarchy, all controllers in one tree (modern)
  Docker/Podman support both; Kubernetes requires v2 for some features

Key Controllers:

  CPU:
    cpu.shares         Relative weight (default: 1024)
    cpu.cfs_quota_us   Hard limit in microseconds per period
    cpu.cfs_period_us  Period length (default: 100000 = 100ms)
    Example: quota=50000, period=100000 → 0.5 CPU cores max
    Docker: --cpus=0.5 or --cpu-shares=512

  Memory:
    memory.limit_in_bytes    Hard memory limit
    memory.soft_limit_in_bytes  Soft limit (reclaimed under pressure)
    memory.oom_control       Enable/disable OOM killer
    Docker: --memory=512m --memory-swap=1g
    OOM: kernel kills process when hard limit exceeded

  Block I/O:
    blkio.weight              Relative I/O weight (100-1000)
    blkio.throttle.read_bps   Max read bytes/sec per device
    blkio.throttle.write_bps  Max write bytes/sec per device
    Docker: --blkio-weight=500 --device-read-bps=/dev/sda:10mb

  PIDs:
    pids.max     Maximum number of processes
    Docker: --pids-limit=100
    Prevents fork bombs from affecting host

  Network (indirect):
    cgroups don't directly limit network bandwidth
    Use tc (traffic control) or CNI plugins for network QoS

cgroups v2 Hierarchy:
  /sys/fs/cgroup/
  ├── system.slice/
  │   └── docker-<id>.scope/
  │       ├── cpu.max           "50000 100000"
  │       ├── memory.max        "536870912"
  │       ├── memory.current    "134217728"
  │       ├── pids.max          "100"
  │       └── pids.current      "23"
  └── user.slice/

Monitoring:
  cat /sys/fs/cgroup/.../memory.current    # current usage
  cat /sys/fs/cgroup/.../cpu.stat          # CPU statistics
  docker stats                              # real-time resource usage
  systemd-cgtop                            # top-like view for cgroups
EOF
}

cmd_images() {
    cat << 'EOF'
=== Container Images ===

An OCI image is a read-only, layered filesystem bundle containing
everything needed to run an application.

Layer Architecture:
  ┌─────────────────────┐
  │ Container layer (RW) │  ← writable, temporary
  ├─────────────────────┤
  │ Layer 4: COPY app   │  ← your application code
  ├─────────────────────┤
  │ Layer 3: RUN install │  ← installed packages
  ├─────────────────────┤
  │ Layer 2: ENV setup   │  ← environment config
  ├─────────────────────┤
  │ Layer 1: base image  │  ← alpine/ubuntu/debian
  └─────────────────────┘

  Each Dockerfile instruction creates a new layer.
  Layers are content-addressable (SHA256 hash).
  Shared layers are stored once (deduplication).

Image Manifest (OCI):
  {
    "schemaVersion": 2,
    "mediaType": "application/vnd.oci.image.manifest.v1+json",
    "config": { "digest": "sha256:abc..." },
    "layers": [
      { "digest": "sha256:111...", "size": 29534848 },
      { "digest": "sha256:222...", "size": 1572864 },
      { "digest": "sha256:333...", "size": 8388608 }
    ]
  }

Union Filesystem (OverlayFS):
  Merges multiple layers into a single view:
    lowerdir   Read-only image layers (stacked)
    upperdir   Writable container layer
    workdir    Internal scratch space
    merged     What the container actually sees

  Copy-on-Write (CoW):
    Read:  file served from lowest layer that has it
    Write: file copied to upperdir, then modified there
    Delete: whiteout file created in upperdir

Image Size Optimization:
  1. Use minimal base images:
     ubuntu:22.04     ~77MB
     debian:slim      ~52MB
     alpine:3.18      ~7MB
     distroless       ~2MB (no shell, no package manager)
     scratch          0MB (truly empty, for static binaries)

  2. Multi-stage builds:
     FROM golang:1.21 AS builder
     RUN go build -o /app .
     FROM alpine:3.18
     COPY --from=builder /app /app
     # Final image: ~12MB instead of ~800MB

  3. Layer ordering: put rarely-changing layers first
     COPY go.mod go.sum ./       # dependencies change rarely
     RUN go mod download
     COPY . .                    # code changes often
     # Maximizes layer cache hits

  4. Combine RUN commands:
     BAD:  RUN apt-get update
           RUN apt-get install -y curl
           RUN rm -rf /var/lib/apt/lists/*
     GOOD: RUN apt-get update && \
             apt-get install -y curl && \
             rm -rf /var/lib/apt/lists/*
     # One layer instead of three
EOF
}

cmd_networking() {
    cat << 'EOF'
=== Container Networking ===

--- Bridge Network (default) ---
  Container ←veth pair→ docker0 bridge ←NAT→ host eth0 → internet

  docker0: virtual bridge (172.17.0.1/16 default)
  Each container gets a veth pair: one end in container, one on bridge
  NAT via iptables for outbound traffic
  Port mapping (-p 8080:80) for inbound traffic

  Container-to-container: via bridge IP, same network
  Container-to-host: via docker0 gateway (172.17.0.1)
  Container-to-internet: NAT masquerade through host

--- Host Network ---
  Container shares host's network namespace directly
  No network isolation, no port mapping needed
  Container's localhost = host's localhost
  Best performance (no veth overhead)
  Use for: performance-critical apps, network monitoring tools

--- Overlay Network ---
  Spans multiple Docker hosts (Docker Swarm / K8s)
  VXLAN encapsulation: container traffic wrapped in UDP (port 4789)
  Each overlay network has its own subnet
  Container-to-container works across hosts transparently
  Requires: key-value store (etcd/consul) or Swarm manager

--- Macvlan ---
  Container gets its own MAC address on the physical network
  Appears as a separate physical device to the network
  No NAT, no bridge — direct L2 connectivity
  Use for: legacy apps that need L2 network access, DHCP

--- None ---
  No networking at all (only loopback)
  Use for: batch processing, security-sensitive workloads

CNI (Container Network Interface):
  Standard plugin interface used by Kubernetes
  Popular CNI plugins:
    Calico     L3 routing + network policy (most popular)
    Flannel    Simple overlay (VXLAN) — easy to set up
    Cilium     eBPF-based, high performance, L7 policy
    Weave      Mesh overlay with encryption
    Multus     Multiple network interfaces per pod

DNS Resolution:
  Containers on same user-defined network can resolve by name
  docker run --name db postgres
  docker run --link db:db myapp  # deprecated, use networks instead
  Docker's embedded DNS: 127.0.0.11
EOF
}

cmd_storage() {
    cat << 'EOF'
=== Container Storage ===

Container filesystem is ephemeral — destroyed when container is removed.
Persistent data requires volumes or bind mounts.

--- Three Storage Options ---

1. Volumes (Docker-managed):
   docker volume create mydata
   docker run -v mydata:/app/data myimage

   Stored at: /var/lib/docker/volumes/mydata/_data
   Managed by Docker, portable between hosts
   Can be shared between containers
   Support volume drivers (NFS, cloud storage, etc.)
   Best for: databases, application state, shared data

2. Bind Mounts (host path):
   docker run -v /host/path:/container/path myimage

   Direct mapping of host directory into container
   Changes visible immediately in both directions
   No Docker management — you handle permissions
   Best for: development (live code reload), config files

3. tmpfs Mounts (memory only):
   docker run --tmpfs /app/cache myimage

   Stored in host memory, never written to disk
   Lost when container stops
   Best for: sensitive data (secrets, session tokens)

--- Storage Drivers ---

  OverlayFS (overlay2):  Default on modern Linux
    Fast, stable, well-tested
    Efficient with layer sharing
    Requires: d_type support in filesystem (ext4, xfs with ftype=1)

  Btrfs:  Uses Btrfs snapshots for layers
    Good for many containers with shared base
    Requires: Btrfs filesystem

  ZFS:    Uses ZFS datasets for layers
    Best data integrity, compression, snapshots
    Higher memory usage
    Requires: ZFS filesystem

  DeviceMapper:  Uses thin provisioning
    Legacy option, not recommended for new deployments

--- Volume Best Practices ---

  Database data:     Named volume (docker volume create pgdata)
  Logs:              Bind mount to host log directory, or log driver
  Config files:      Bind mount read-only (-v ./config:/etc/app:ro)
  Secrets:           Docker secrets (Swarm) or tmpfs mount
  Build cache:       Named volume (survives container rebuilds)
  Uploads:           Named volume with backup strategy

  Backup volumes:
    docker run --rm -v mydata:/data -v $(pwd):/backup \
      alpine tar czf /backup/mydata.tar.gz /data

  Permissions:
    Container user must match volume file ownership
    Use --user flag or fix permissions in Dockerfile
    Common issue: container runs as root, volume owned by 1000
EOF
}

cmd_runtimes() {
    cat << 'EOF'
=== Container Runtimes Compared ===

--- Low-Level Runtimes (OCI Runtime) ---

runc:
  Reference implementation of OCI runtime spec
  Written in Go, maintained by Open Container Initiative
  Creates namespaces, sets up cgroups, executes container process
  Used by: Docker, containerd, CRI-O (default)
  Security: shares host kernel — VM-level isolation not provided

crun:
  OCI runtime written in C (faster than runc)
  2-3× faster container startup
  Lower memory footprint
  Default in: Podman, Red Hat systems

youki:
  OCI runtime written in Rust
  Focus on memory safety
  Compatible with Docker and Podman
  Experimental but growing

--- High-Level Runtimes (Container Manager) ---

containerd:
  Full container lifecycle management
  Image pull, storage, networking, runtime supervision
  Docker uses containerd internally since Docker 1.11
  Kubernetes uses containerd via CRI plugin (default since K8s 1.24)
  CNCF graduated project

CRI-O:
  Purpose-built for Kubernetes (nothing more)
  Implements Kubernetes CRI (Container Runtime Interface)
  Lighter than containerd (no Docker compatibility needed)
  Default in: OpenShift, some K8s distributions

--- Container Engines (User-Facing) ---

Docker:
  docker CLI → dockerd → containerd → runc
  Most popular, best developer experience
  Docker Desktop for Mac/Windows (includes VM)
  Docker Compose for multi-container apps

Podman:
  Daemonless — no background service required
  Rootless by default (no root needed)
  CLI-compatible with Docker (alias docker=podman)
  Pods concept (group of containers, like K8s pod)
  Default in RHEL 8+, Fedora

--- Sandbox Runtimes (Enhanced Isolation) ---

gVisor (runsc):
  Google's application kernel — intercepts syscalls
  Container thinks it's talking to Linux kernel
  Actually talking to gVisor's user-space kernel
  ~300 of 400+ Linux syscalls supported
  Trade-off: better isolation, some performance cost (~10-20%)
  Used by: Google Cloud Run, some GKE workloads

Kata Containers:
  Lightweight VM per container (real hardware isolation)
  Uses QEMU/Firecracker to run minimal VM
  Startup: ~100ms (vs ~10s for traditional VM)
  Compatible with OCI runtime spec
  Trade-off: VM-level isolation, higher resource overhead
  Used by: multi-tenant environments, sensitive workloads

Firecracker:
  Amazon's microVM manager (powers AWS Lambda/Fargate)
  Boots VM in ~125ms, <5MB memory overhead
  Minimal attack surface (limited device model)
EOF
}

cmd_security() {
    cat << 'EOF'
=== Container Security ===

--- Linux Capabilities ---
  Containers run with a reduced set of Linux capabilities.
  Instead of full root power, only specific capabilities are granted.

  Default Docker capabilities (13 of 41):
    CHOWN, DAC_OVERRIDE, FSETID, FOWNER, MKNOD, NET_RAW,
    SETGID, SETUID, SETFCAP, SETPCAP, NET_BIND_SERVICE,
    SYS_CHROOT, KILL, AUDIT_WRITE

  Dropped by default (dangerous):
    SYS_ADMIN    Mount filesystems, load kernel modules
    NET_ADMIN    Configure network interfaces
    SYS_PTRACE   Debug other processes
    SYS_RAWIO    Direct hardware I/O access

  Best practice: drop ALL, add only what's needed
    docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE myapp

--- Seccomp (Secure Computing) ---
  Filters which system calls a container can make.
  Default Docker profile blocks ~44 dangerous syscalls:
    mount, umount, reboot, swapon, swapoff, init_module,
    delete_module, acct, settimeofday, sethostname, ...

  Custom profile: JSON file listing allowed/blocked syscalls
  docker run --security-opt seccomp=profile.json myapp

--- AppArmor / SELinux ---
  AppArmor (Ubuntu/Debian default):
    Mandatory access control — restricts file/network access
    Docker applies default profile: docker-default
    Prevents: writing to /proc, /sys, mounting filesystems

  SELinux (RHEL/CentOS/Fedora):
    Label-based access control
    Container processes get: svirt_lxc_net_t label
    Prevents: accessing host files, other containers' data

--- Rootless Containers ---
  Run entire container engine without root privileges.
  Container root (UID 0) maps to unprivileged host UID.
  Even if container is compromised, attacker has no host root.

  Podman: rootless by default
  Docker: rootless mode available (dockerd-rootless.sh)
  Limitations: no binding to ports < 1024 (without capabilities)

--- Image Security ---
  1. Scan images for CVEs: trivy, grype, snyk
  2. Use minimal base images (less attack surface)
  3. Don't run as root in container (USER directive)
  4. Don't store secrets in images (use runtime secrets)
  5. Pin image versions (don't use :latest in production)
  6. Sign images: cosign, Docker Content Trust
  7. Use read-only filesystem: docker run --read-only

--- Runtime Security Checklist ---
  [ ] No --privileged flag (grants ALL capabilities)
  [ ] No --pid=host (can see all host processes)
  [ ] No --network=host in production (no network isolation)
  [ ] Memory limits set (prevent DoS)
  [ ] PID limits set (prevent fork bombs)
  [ ] Read-only root filesystem where possible
  [ ] No sensitive host paths mounted
  [ ] Seccomp profile applied (default or custom)
  [ ] Non-root user in Dockerfile (USER 1000)
  [ ] Health checks defined (HEALTHCHECK instruction)
EOF
}

show_help() {
    cat << EOF
container v$VERSION — Container Technology Reference

Usage: script.sh <command>

Commands:
  intro        Container technology history and architecture
  namespaces   Linux namespaces — process isolation mechanism
  cgroups      Control groups — resource limiting
  images       OCI image format, layers, and optimization
  networking   Bridge, host, overlay, and CNI networking
  storage      Volumes, bind mounts, and storage drivers
  runtimes     Runtime comparison: runc, containerd, gVisor, Kata
  security     Capabilities, seccomp, AppArmor, rootless mode
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    namespaces) cmd_namespaces ;;
    cgroups)    cmd_cgroups ;;
    images)     cmd_images ;;
    networking) cmd_networking ;;
    storage)    cmd_storage ;;
    runtimes)   cmd_runtimes ;;
    security)   cmd_security ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "container v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
