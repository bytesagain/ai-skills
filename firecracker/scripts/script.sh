#!/bin/bash
# Firecracker - Lightweight MicroVM Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              FIRECRACKER REFERENCE                          ║
║          Lightweight Virtual Machines for Serverless        ║
╚══════════════════════════════════════════════════════════════╝

Firecracker is an open-source virtual machine monitor (VMM) built
by AWS. It creates and manages lightweight microVMs that combine
the security of VMs with the speed of containers.

KEY FEATURES:
  Fast boot       <125ms to usable VM
  Low overhead    <5MB memory per microVM
  Secure          Hardware-level isolation (KVM)
  Minimal attack  Stripped-down device model
  Rate limiting   Built-in I/O throttling
  REST API        JSON API for management
  Snapshot        Save/restore VM state

WHO USES IT:
  AWS Lambda      Every function invocation
  AWS Fargate     Container workloads
  Fly.io          Edge computing platform
  Koyeb           Serverless platform
  Kata Containers Integration available

FIRECRACKER vs CONTAINERS vs QEMU:
  ┌──────────────┬────────────┬──────────┬──────────┐
  │ Feature      │Firecracker │Container │ QEMU     │
  ├──────────────┼────────────┼──────────┼──────────┤
  │ Isolation    │ Hardware   │ Process  │ Hardware │
  │ Boot time    │ <125ms     │ <1s      │ ~3s      │
  │ Memory       │ <5MB       │ ~0       │ ~50MB+   │
  │ Devices      │ Minimal    │ Host     │ Full     │
  │ Security     │ Strongest  │ Weakest  │ Strong   │
  │ Density      │ Thousands  │ Thousands│ Hundreds │
  │ GPU          │ No         │ Yes      │ Yes      │
  │ Use case     │ Serverless │ General  │ Full VM  │
  └──────────────┴────────────┴──────────┴──────────┘

REQUIREMENTS:
  Linux kernel 4.14+ with KVM support
  Intel VT-x or AMD-V
  /dev/kvm accessible
EOF
}

cmd_usage() {
cat << 'EOF'
LAUNCHING MICROVMS
====================

INSTALL:
  # Download binary
  ARCH=$(uname -m)
  curl -L https://github.com/firecracker-microvm/firecracker/releases/latest/download/firecracker-v*-${ARCH}.tgz | tar xz
  sudo mv release-*/firecracker-v* /usr/local/bin/firecracker

  # Check KVM
  [ -e /dev/kvm ] && echo "KVM available" || echo "No KVM!"

GET KERNEL + ROOTFS:
  # Download test images
  curl -L -o vmlinux https://s3.amazonaws.com/spec.ccfc.min/img/quickstart_guide/x86_64/kernels/vmlinux.bin
  curl -L -o rootfs.ext4 https://s3.amazonaws.com/spec.ccfc.min/img/quickstart_guide/x86_64/rootfs/bionic.rootfs.ext4

START FIRECRACKER:
  # Terminal 1: Start Firecracker (creates socket)
  rm -f /tmp/firecracker.socket
  firecracker --api-sock /tmp/firecracker.socket

  # Terminal 2: Configure and launch via API
  API="http://localhost/machine-config"
  SOCK="/tmp/firecracker.socket"

SET MACHINE CONFIG:
  curl --unix-socket $SOCK -X PUT "$API" \
    -H "Content-Type: application/json" \
    -d '{
      "vcpu_count": 2,
      "mem_size_mib": 256
    }'

SET KERNEL:
  curl --unix-socket $SOCK -X PUT "http://localhost/boot-source" \
    -H "Content-Type: application/json" \
    -d '{
      "kernel_image_path": "./vmlinux",
      "boot_args": "console=ttyS0 reboot=k panic=1 pci=off"
    }'

SET ROOT DRIVE:
  curl --unix-socket $SOCK -X PUT "http://localhost/drives/rootfs" \
    -H "Content-Type: application/json" \
    -d '{
      "drive_id": "rootfs",
      "path_on_host": "./rootfs.ext4",
      "is_root_device": true,
      "is_read_only": false
    }'

SET NETWORK:
  # Create TAP device first
  sudo ip tuntap add tap0 mode tap
  sudo ip addr add 172.16.0.1/24 dev tap0
  sudo ip link set tap0 up

  curl --unix-socket $SOCK -X PUT "http://localhost/network-interfaces/eth0" \
    -H "Content-Type: application/json" \
    -d '{
      "iface_id": "eth0",
      "guest_mac": "AA:FC:00:00:00:01",
      "host_dev_name": "tap0"
    }'

START VM:
  curl --unix-socket $SOCK -X PUT "http://localhost/actions" \
    -H "Content-Type: application/json" \
    -d '{"action_type": "InstanceStart"}'

  # VM boots in <125ms!
EOF
}

cmd_advanced() {
cat << 'EOF'
ADVANCED FEATURES
===================

SNAPSHOTS (save/restore):
  # Pause VM
  curl --unix-socket $SOCK -X PATCH "http://localhost/vm" \
    -d '{"state": "Paused"}'

  # Create snapshot
  curl --unix-socket $SOCK -X PUT "http://localhost/snapshot/create" \
    -d '{
      "snapshot_type": "Full",
      "snapshot_path": "./snapshot_file",
      "mem_file_path": "./mem_file"
    }'

  # Restore (new Firecracker instance)
  curl --unix-socket $SOCK2 -X PUT "http://localhost/snapshot/load" \
    -d '{
      "snapshot_path": "./snapshot_file",
      "mem_backend": {"backend_path": "./mem_file", "backend_type": "File"},
      "enable_diff_snapshots": false
    }'

  # Resume
  curl --unix-socket $SOCK2 -X PATCH "http://localhost/vm" \
    -d '{"state": "Resumed"}'

  # Restore is <5ms! Perfect for serverless cold starts.

RATE LIMITING (I/O throttling):
  curl --unix-socket $SOCK -X PUT "http://localhost/drives/rootfs" \
    -d '{
      "drive_id": "rootfs",
      "path_on_host": "./rootfs.ext4",
      "is_root_device": true,
      "is_read_only": false,
      "rate_limiter": {
        "bandwidth": {"size": 10485760, "refill_time": 1000},
        "ops": {"size": 500, "refill_time": 1000}
      }
    }'

  # Network rate limiting
  curl --unix-socket $SOCK -X PUT "http://localhost/network-interfaces/eth0" \
    -d '{
      "iface_id": "eth0",
      "host_dev_name": "tap0",
      "rx_rate_limiter": {"bandwidth": {"size": 1048576, "refill_time": 1000}},
      "tx_rate_limiter": {"bandwidth": {"size": 1048576, "refill_time": 1000}}
    }'

METRICS:
  curl --unix-socket $SOCK -X PUT "http://localhost/metrics" \
    -d '{"metrics_path": "/tmp/fc_metrics"}'

  # Metrics include:
  # - API server call count
  # - Boot time microseconds
  # - Block device operations
  # - Network packets rx/tx
  # - vCPU exit counts

JAILER (production security):
  jailer --id myvm1 \
    --exec-file /usr/local/bin/firecracker \
    --uid 1000 --gid 1000 \
    --chroot-base-dir /srv/jailer \
    --daemonize

  # Jailer provides:
  # - chroot isolation
  # - seccomp filters
  # - cgroup resource limits
  # - UID/GID mapping
  # - Network namespace

BUILDING ROOTFS:
  # From Docker image
  docker export $(docker create alpine:latest) > rootfs.tar
  dd if=/dev/zero of=rootfs.ext4 bs=1M count=512
  mkfs.ext4 rootfs.ext4
  mkdir /tmp/rootfs
  mount rootfs.ext4 /tmp/rootfs
  tar xf rootfs.tar -C /tmp/rootfs
  umount /tmp/rootfs

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Firecracker - Lightweight MicroVM Reference

Commands:
  intro     Overview, comparison, requirements
  usage     Launch microVMs via REST API
  advanced  Snapshots, rate limiting, jailer, rootfs

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  usage)    cmd_usage ;;
  advanced) cmd_advanced ;;
  help|*)   show_help ;;
esac
