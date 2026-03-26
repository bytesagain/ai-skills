#!/bin/bash
# Containerd - Container Runtime Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              CONTAINERD REFERENCE                           ║
║          Industry-Standard Container Runtime                ║
╚══════════════════════════════════════════════════════════════╝

Containerd is the container runtime that powers Docker and
Kubernetes. It manages the complete container lifecycle: image
transfer, storage, execution, and networking.

CONTAINER RUNTIME STACK:
  kubectl / docker CLI          (user interface)
       ↓
  kubelet / dockerd             (orchestrator/daemon)
       ↓
  containerd                    (container runtime)
       ↓
  runc / crun / kata / gVisor   (OCI runtime)
       ↓
  Linux kernel (namespaces, cgroups, seccomp)

KEY FEATURES:
  OCI compliant       Standard container images
  CRI support         Kubernetes Container Runtime Interface
  Snapshotters        overlayfs, zfs, btrfs, devmapper
  Content store       Content-addressable image storage
  Plugin architecture Extend with custom plugins
  Namespaces          Isolate containers by namespace

CONTAINERD vs DOCKER vs CRI-O:
  ┌──────────────┬──────────────┬──────────┬──────────┐
  │ Feature      │ containerd   │ Docker   │ CRI-O    │
  ├──────────────┼──────────────┼──────────┼──────────┤
  │ Use case     │ Runtime      │ Full dev │ K8s only │
  │ CLI          │ ctr/nerdctl  │ docker   │ crictl   │
  │ K8s support  │ Yes (CRI)    │ Via shim │ Yes(CRI) │
  │ Image build  │ Via nerdctl  │ Built-in │ No       │
  │ Compose      │ Via nerdctl  │ Built-in │ No       │
  │ Footprint    │ Small        │ Large    │ Small    │
  │ Docker compat│ Via nerdctl  │ Native   │ No       │
  └──────────────┴──────────────┴──────────┴──────────┘

INSTALL:
  sudo apt install containerd
  # Or from GitHub releases
  # Kubernetes uses containerd by default since v1.24
EOF
}

cmd_usage() {
cat << 'EOF'
CTR & NERDCTL
===============

CTR (low-level CLI):
  # Image operations
  sudo ctr images pull docker.io/library/nginx:latest
  sudo ctr images list
  sudo ctr images remove docker.io/library/nginx:latest

  # Container operations
  sudo ctr run -d docker.io/library/nginx:latest web
  sudo ctr containers list
  sudo ctr tasks list                # Running tasks
  sudo ctr tasks kill web
  sudo ctr containers delete web

  # Namespaces
  sudo ctr namespaces list
  sudo ctr -n k8s.io containers list  # Kubernetes namespace
  sudo ctr -n moby containers list    # Docker namespace

NERDCTL (Docker-compatible CLI):
  # Install
  # github.com/containerd/nerdctl/releases

  # Same as Docker commands!
  nerdctl run -d -p 80:80 --name web nginx
  nerdctl ps
  nerdctl logs web
  nerdctl exec -it web bash
  nerdctl stop web
  nerdctl rm web

  # Image management
  nerdctl build -t myapp .           # Build with BuildKit
  nerdctl push myapp:latest
  nerdctl pull nginx:alpine
  nerdctl images

  # Docker Compose compatible!
  nerdctl compose up -d
  nerdctl compose down
  nerdctl compose ps

  # Rootless mode
  containerd-rootless-setuptool.sh install
  nerdctl run --rm -it alpine sh

CRICTL (Kubernetes CRI):
  crictl pull nginx:latest
  crictl images
  crictl ps                          # Running containers
  crictl pods                        # Running pods
  crictl logs <container-id>
  crictl exec -it <container-id> sh
  crictl stats                       # Resource usage
  crictl inspect <container-id>      # Container details
EOF
}

cmd_config() {
cat << 'EOF'
CONFIGURATION & KUBERNETES
==============================

CONFIG (/etc/containerd/config.toml):
  version = 2

  [plugins."io.containerd.grpc.v1.cri"]
    sandbox_image = "registry.k8s.io/pause:3.9"

    [plugins."io.containerd.grpc.v1.cri".containerd]
      default_runtime_name = "runc"

      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
        runtime_type = "io.containerd.runc.v2"
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
          SystemdCgroup = true

    [plugins."io.containerd.grpc.v1.cri".registry]
      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
          endpoint = ["https://mirror.gcr.io"]

  # Generate default config
  containerd config default > /etc/containerd/config.toml

KUBERNETES SETUP:
  # containerd is the default runtime since K8s 1.24
  # Verify
  kubectl get nodes -o wide
  # CONTAINER-RUNTIME column shows "containerd://1.7.x"

  # kubelet config
  # /var/lib/kubelet/config.yaml
  containerRuntimeEndpoint: unix:///run/containerd/containerd.sock

SNAPSHOTTERS:
  # Default: overlayfs
  # Options: native, overlayfs, zfs, btrfs, devmapper

  [plugins."io.containerd.grpc.v1.cri".containerd]
    snapshotter = "overlayfs"

  # Stargz (lazy image loading)
  # Images load as-needed, faster container startup

IMAGE ENCRYPTION:
  # containerd supports encrypted container images
  # Use imgcrypt plugin for OCI image encryption
  nerdctl image encrypt --recipient jwe:pub.pem myimage encrypted-image

DEBUGGING:
  # Check containerd status
  systemctl status containerd
  journalctl -u containerd -f

  # Socket
  ls -la /run/containerd/containerd.sock

  # Version
  containerd --version
  ctr version

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Containerd - Container Runtime Reference

Commands:
  intro    Architecture, comparison
  usage    ctr, nerdctl, crictl commands
  config   config.toml, Kubernetes, snapshotters

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)   cmd_intro ;;
  usage)   cmd_usage ;;
  config)  cmd_config ;;
  help|*)  show_help ;;
esac
