#!/bin/bash
# Skopeo - Container Image Operations Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              SKOPEO REFERENCE                               ║
║          Container Image Operations Without Docker          ║
╚══════════════════════════════════════════════════════════════╝

Skopeo performs operations on container images and registries
WITHOUT requiring a daemon. Unlike docker, skopeo doesn't need
dockerd running — it works directly with registries.

KEY FEATURES:
  Copy images      Between registries without pulling locally
  Inspect          Remote image metadata without downloading
  Sign/verify      Image signatures for supply chain security
  Delete           Remove images from registries
  Sync             Mirror entire repositories
  No daemon        Works without Docker/containerd running

TRANSPORTS:
  docker://         Docker registry (Docker Hub, GCR, ECR)
  docker-archive:   Local .tar (docker save format)
  oci:              OCI layout directory
  oci-archive:      OCI .tar archive
  dir:              Simple directory layout
  containers-storage: Local container storage

INSTALL:
  sudo apt install skopeo            # Debian/Ubuntu
  brew install skopeo                # macOS
  sudo dnf install skopeo            # RHEL/Fedora
EOF
}

cmd_operations() {
cat << 'EOF'
CORE OPERATIONS
=================

INSPECT (without pulling):
  # Inspect remote image
  skopeo inspect docker://nginx:latest
  skopeo inspect docker://ghcr.io/owner/repo:tag

  # Raw manifest
  skopeo inspect --raw docker://nginx:latest

  # Specific arch manifest
  skopeo inspect --override-os linux --override-arch arm64 \
    docker://nginx:latest

  # Config blob (Dockerfile history)
  skopeo inspect --config docker://nginx:latest

COPY (between registries):
  # Registry to registry (no local pull!)
  skopeo copy \
    docker://myregistry.com/app:v1 \
    docker://newregistry.com/app:v1

  # Docker Hub to ECR
  skopeo copy \
    docker://nginx:latest \
    docker://123456789.dkr.ecr.us-east-1.amazonaws.com/nginx:latest

  # Registry to local tar
  skopeo copy docker://nginx:latest docker-archive:nginx.tar

  # Local tar to registry
  skopeo copy docker-archive:myapp.tar docker://registry.com/myapp:v1

  # Registry to OCI layout
  skopeo copy docker://nginx:latest oci:nginx-oci:latest

  # Multi-arch copy
  skopeo copy --all docker://nginx:latest docker://mirror.com/nginx:latest

DELETE:
  skopeo delete docker://registry.com/myapp:old-tag

  # Delete with credentials
  skopeo delete --creds user:pass docker://registry.com/myapp:v1

SYNC (mirror repos):
  # Mirror entire repo
  skopeo sync --src docker --dest docker \
    registry.com/myapp newregistry.com/

  # Mirror to local directory
  skopeo sync --src docker --dest dir registry.com/myapp ./mirror/

  # Sync from YAML manifest
  skopeo sync --src yaml --dest docker sync.yml registry.com/

  # sync.yml format:
  # docker.io:
  #   images:
  #     nginx:
  #       - "latest"
  #       - "1.25"
  #     redis:
  #       - "7"
EOF
}

cmd_auth() {
cat << 'EOF'
AUTHENTICATION & CI/CD
========================

AUTH:
  # Login (stores in $XDG_RUNTIME_DIR/containers/auth.json)
  skopeo login registry.com
  skopeo login -u user -p pass registry.com
  skopeo login --get-login registry.com

  # Use specific auth file
  skopeo inspect --authfile /path/auth.json docker://registry.com/app

  # Credentials inline
  skopeo copy --src-creds user:pass --dest-creds user2:pass2 \
    docker://src-registry.com/app:v1 \
    docker://dst-registry.com/app:v1

  # AWS ECR
  aws ecr get-login-password | skopeo login --username AWS --password-stdin \
    123456789.dkr.ecr.us-east-1.amazonaws.com

  # GCR
  skopeo login -u _json_key --password-stdin gcr.io < keyfile.json

CI/CD PATTERNS:
  # GitHub Actions — copy image on release
  - name: Copy to production registry
    run: |
      skopeo copy --all \
        --src-creds ${{ github.actor }}:${{ secrets.GITHUB_TOKEN }} \
        --dest-creds ${{ secrets.PROD_USER }}:${{ secrets.PROD_PASS }} \
        docker://ghcr.io/${{ github.repository }}:${{ github.sha }} \
        docker://prod-registry.com/app:${{ github.ref_name }}

  # Vulnerability scan before promote
  - name: Inspect and promote
    run: |
      # Check image metadata
      skopeo inspect docker://ghcr.io/app:staging | jq '.Labels'
      # Promote to production
      skopeo copy docker://ghcr.io/app:staging docker://ghcr.io/app:latest

IMAGE SIGNING:
  # Sign with sigstore/cosign
  cosign sign ghcr.io/myapp:v1

  # Skopeo respects signatures in transport
  skopeo copy --sign-by mykey@email.com \
    docker://src/app:v1 docker://dst/app:v1

  # Verify policy
  # /etc/containers/policy.json
  {
    "default": [{"type": "insecureAcceptAnything"}],
    "transports": {
      "docker": {
        "registry.com": [{"type": "signedBy", "keyType": "GPGKeys",
          "keyPath": "/etc/pki/rpm-gpg/RPM-GPG-KEY"}]
      }
    }
  }

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Skopeo - Container Image Operations Reference

Commands:
  intro        Overview, transports, install
  operations   Inspect, copy, delete, sync
  auth         Authentication, CI/CD, signing

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  operations) cmd_operations ;;
  auth)       cmd_auth ;;
  help|*)     show_help ;;
esac
