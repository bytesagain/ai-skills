#!/bin/bash
# Colima - Container Runtimes on macOS/Linux Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              COLIMA REFERENCE                               ║
║          Container Runtimes on macOS (and Linux)            ║
╚══════════════════════════════════════════════════════════════╝

Colima is a minimal-setup container runtime for macOS and Linux.
It replaces Docker Desktop with a lightweight VM running containerd
or Docker engine.

WHY COLIMA:
  Free           No Docker Desktop licensing fees
  Lightweight    Uses Lima VM, minimal resources
  Docker compat  Full Docker CLI compatibility
  Kubernetes     Built-in K3s single-node cluster
  Rootless       No root access required
  Fast startup   ~30 seconds to ready

COLIMA vs DOCKER DESKTOP vs RANCHER DESKTOP:
  ┌──────────────┬──────────┬──────────┬──────────────┐
  │ Feature      │ Colima   │ Docker   │ Rancher Desk │
  ├──────────────┼──────────┼──────────┼──────────────┤
  │ Cost         │ Free     │ $11+/mo  │ Free         │
  │ GUI          │ CLI only │ Full GUI │ Full GUI     │
  │ Resources    │ Low      │ Medium   │ Medium       │
  │ Kubernetes   │ K3s      │ K8s      │ K3s/K8s      │
  │ Startup      │ ~30s     │ ~60s     │ ~60s         │
  │ Docker CLI   │ Yes      │ Yes      │ Yes          │
  │ Containerd   │ Yes      │ No       │ Yes          │
  │ License      │ MIT      │ Propriet.│ Apache 2.0   │
  └──────────────┴──────────┴──────────┴──────────────┘

INSTALL:
  # macOS
  brew install colima docker docker-compose

  # Linux
  curl -LO https://github.com/abiosoft/colima/releases/latest/download/colima-Linux-x86_64
  chmod +x colima-Linux-x86_64
  sudo mv colima-Linux-x86_64 /usr/local/bin/colima

PREREQUISITES:
  macOS: Homebrew, docker CLI (not Desktop)
  Linux: docker CLI, QEMU
EOF
}

cmd_usage() {
cat << 'EOF'
DAILY USAGE
=============

START:
  colima start                    # Default: 2 CPU, 2GB RAM, 60GB disk
  colima start --cpu 4 --memory 8 # Custom resources
  colima start --disk 100         # 100GB disk
  colima start --arch aarch64     # ARM emulation on Intel
  colima start --arch x86_64      # x86 emulation on Apple Silicon
  colima start --vm-type vz       # macOS Virtualization.framework (faster)
  colima start --mount-type virtiofs # Faster file mounts (macOS 13+)

STOP/STATUS:
  colima stop                     # Stop VM
  colima status                   # Current status
  colima list                     # List all profiles
  colima delete                   # Delete VM and data

DOCKER COMMANDS (just work):
  docker run -it ubuntu bash
  docker compose up -d
  docker build -t myapp .
  docker ps
  docker images

PROFILES (multiple environments):
  colima start --profile dev      # Dev environment
  colima start --profile test --cpu 4 --memory 8
  colima list                     # See all profiles

  # Switch context
  docker context use colima-dev
  docker context use colima-test

VOLUME MOUNTS:
  # Default: home directory is mounted
  docker run -v ~/projects:/app ubuntu ls /app

  # Custom mounts
  colima start --mount ~/work:w    # Mount ~/work as writable
  colima start --mount /data:r     # Mount /data as read-only

FILE SHARING PERFORMANCE:
  colima start --mount-type 9p     # Default, compatible
  colima start --mount-type sshfs  # Better performance
  colima start --mount-type virtiofs # Best (macOS 13+, vz only)

SSH INTO VM:
  colima ssh                       # Enter the VM
  colima ssh -- df -h              # Run command in VM
EOF
}

cmd_kubernetes() {
cat << 'EOF'
KUBERNETES (K3s)
==================

START WITH K8S:
  colima start --kubernetes
  colima start --kubernetes --cpu 4 --memory 8

  # kubectl auto-configured
  kubectl get nodes
  kubectl get pods -A

WHAT YOU GET:
  - Single-node K3s cluster
  - CoreDNS, Traefik ingress (optional)
  - Local-path storage provisioner
  - Metrics server
  - kubectl context auto-set

DEPLOY APP:
  kubectl create deployment nginx --image=nginx
  kubectl expose deployment nginx --port=80 --type=NodePort
  kubectl get svc nginx

  # Access via colima VM IP
  curl $(colima status | grep 'address' | awk '{print $2}'):$(kubectl get svc nginx -o jsonpath='{.spec.ports[0].nodePort}')

PORT FORWARDING:
  kubectl port-forward svc/nginx 8080:80
  # Access at localhost:8080

INGRESS:
  # K3s includes Traefik by default
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: myapp
  spec:
    rules:
    - host: myapp.local
      http:
        paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: myapp
              port:
                number: 80

HELM:
  brew install helm
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm install my-redis bitnami/redis

STOP K8S:
  colima kubernetes stop           # Stop K8s, keep Docker
  colima kubernetes start          # Restart K8s
  colima kubernetes reset          # Reset K8s cluster
EOF
}

cmd_troubleshoot() {
cat << 'EOF'
TROUBLESHOOTING
=================

COMMON ISSUES:

  "Cannot connect to Docker daemon":
    colima status           # Is it running?
    colima start            # Start it
    docker context ls       # Check context
    docker context use colima  # Switch to colima

  Slow file I/O:
    colima stop
    colima start --mount-type virtiofs --vm-type vz
    # Requires macOS 13+ and Apple Silicon

  Out of disk space:
    colima ssh -- df -h
    docker system prune -a   # Clean images/containers
    # Or recreate with more disk:
    colima delete
    colima start --disk 200

  Port conflicts:
    # Check what's using port
    lsof -i :8080
    # Use different host port
    docker run -p 9090:8080 myapp

  DNS issues in containers:
    # Add custom DNS
    docker run --dns 8.8.8.8 myapp

CONFIGURATION FILE:
  ~/.colima/default/colima.yaml

  # Edit defaults:
  cpu: 4
  memory: 8
  disk: 100
  vmType: vz
  mountType: virtiofs
  docker:
    insecure-registries:
      - "registry.local:5000"

RUNTIME OPTIONS:
  colima start --runtime docker      # Docker engine (default)
  colima start --runtime containerd  # containerd (use nerdctl)

  # With containerd, use nerdctl instead of docker:
  nerdctl run -it ubuntu bash
  nerdctl build -t myapp .

NETWORKING:
  # Colima VM has its own IP
  colima status  # Shows IP address

  # Host-to-container: use localhost:port (port forwarding)
  # Container-to-host: use host.docker.internal

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Colima - Container Runtimes on macOS Reference

Commands:
  intro         Overview, comparison, install
  usage         Start/stop, profiles, mounts, file sharing
  kubernetes    K3s cluster, kubectl, Helm, ingress
  troubleshoot  Common issues, config, networking

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)        cmd_intro ;;
  usage)        cmd_usage ;;
  kubernetes)   cmd_kubernetes ;;
  troubleshoot) cmd_troubleshoot ;;
  help|*)       show_help ;;
esac
