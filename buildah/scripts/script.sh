#!/bin/bash
# Buildah - OCI Container Image Builder Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              BUILDAH REFERENCE                              ║
║          Build OCI Container Images Without Docker          ║
╚══════════════════════════════════════════════════════════════╝

Buildah is a tool for building OCI-compliant container images.
Unlike Docker, it doesn't require a daemon and can build images
without root privileges.

KEY ADVANTAGES:
  Daemonless     No background service needed
  Rootless       Build images as non-root user
  Dockerfile     Full Dockerfile/Containerfile support
  Scripted       Shell-scriptable image building
  OCI compliant  Standard container image format
  No runtime     Build-only (no container execution)
  Fine-grained   Mount, modify, commit at each step

BUILDAH vs DOCKER BUILD vs KANIKO:
  ┌──────────────┬──────────┬────────────┬──────────┐
  │ Feature      │ Buildah  │ Docker     │ Kaniko   │
  ├──────────────┼──────────┼────────────┼──────────┤
  │ Daemon       │ No       │ Yes        │ No       │
  │ Rootless     │ Yes      │ Rootless*  │ No       │
  │ Dockerfile   │ Yes      │ Yes        │ Yes      │
  │ Scripted     │ Yes      │ No         │ No       │
  │ CI/CD        │ Excellent│ Needs DinD │ Excellent│
  │ K8s native   │ Yes      │ Privileged │ Yes      │
  │ Runs contain.│ No       │ Yes        │ No       │
  │ OCI format   │ Yes      │ Yes        │ Yes      │
  └──────────────┴──────────┴────────────┴──────────┘
  * Docker rootless mode is newer and more limited

ECOSYSTEM:
  Buildah    Build images
  Podman     Run containers (docker CLI compatible)
  Skopeo     Copy/inspect images between registries
EOF
}

cmd_dockerfile() {
cat << 'EOF'
DOCKERFILE/CONTAINERFILE BUILDS
=================================

BASIC BUILD:
  buildah bud -t myapp:v1 .
  buildah bud -f Dockerfile.prod -t myapp:prod .

  # Equivalent to docker build:
  buildah bud --layers -t myapp:latest .

CONTAINERFILE:
  # Containerfile (Buildah's preferred name for Dockerfile)
  FROM python:3.12-slim
  WORKDIR /app
  COPY requirements.txt .
  RUN pip install --no-cache-dir -r requirements.txt
  COPY . .
  EXPOSE 8000
  CMD ["python", "app.py"]

BUILD OPTIONS:
  buildah bud \
    -t registry.example.com/myapp:v1 \     # Tag
    -f Containerfile.prod \                 # Specify file
    --build-arg VERSION=1.0 \              # Build args
    --no-cache \                           # No layer cache
    --layers \                             # Cache layers
    --squash \                             # Squash all layers
    --format oci \                         # OCI format (default)
    --format docker \                      # Docker format
    --target builder \                     # Multi-stage target
    --platform linux/amd64,linux/arm64 \   # Multi-arch
    .

MULTI-STAGE:
  # Containerfile
  FROM golang:1.22 AS builder
  WORKDIR /app
  COPY . .
  RUN CGO_ENABLED=0 go build -o server

  FROM scratch
  COPY --from=builder /app/server /server
  CMD ["/server"]

  buildah bud -t myapp:latest .
  # Final image only contains the binary

PUSH TO REGISTRY:
  buildah push myapp:v1 docker://registry.example.com/myapp:v1
  buildah push myapp:v1 docker://docker.io/username/myapp:v1

  # Login first
  buildah login registry.example.com
  buildah login docker.io
EOF
}

cmd_scripted() {
cat << 'EOF'
SCRIPTED BUILDS (Buildah's Superpower)
=========================================

Instead of Dockerfile, build images with shell commands.
Full programmatic control at every step.

BASIC SCRIPTED BUILD:
  #!/bin/bash
  # build.sh — Create a Python app image

  # Start from base image
  container=$(buildah from python:3.12-slim)

  # Run commands inside
  buildah run $container -- pip install flask gunicorn

  # Copy files
  buildah copy $container ./app /app
  buildah copy $container ./requirements.txt /app/

  # Set working directory
  buildah config --workingdir /app $container

  # Set environment variables
  buildah config --env FLASK_APP=app.py $container
  buildah config --env FLASK_ENV=production $container

  # Set entrypoint and cmd
  buildah config --entrypoint '["gunicorn"]' $container
  buildah config --cmd '"app:app" "-b" "0.0.0.0:8000"' $container

  # Expose port
  buildah config --port 8000 $container

  # Set labels
  buildah config --label maintainer="team@example.com" $container
  buildah config --label version="1.0.0" $container

  # Commit to image
  buildah commit $container myapp:v1

  # Cleanup
  buildah rm $container

WHY SCRIPTED:
  - Conditional logic (if/else based on build args)
  - Loop over files/configs
  - Call external tools during build
  - Dynamic content generation
  - Better error handling than Dockerfile RUN
  - Integration with CI/CD scripts

ADVANCED SCRIPTED:
  #!/bin/bash
  set -euo pipefail

  VERSION=${1:-latest}
  BASE_IMAGE=${2:-ubuntu:22.04}

  ctr=$(buildah from $BASE_IMAGE)
  mnt=$(buildah mount $ctr)

  # Direct filesystem access!
  cp -r ./config/* $mnt/etc/myapp/
  echo "version=$VERSION" > $mnt/etc/myapp/version

  # Install only what we need
  buildah run $ctr -- apt-get update
  buildah run $ctr -- apt-get install -y --no-install-recommends curl ca-certificates
  buildah run $ctr -- apt-get clean
  rm -rf $mnt/var/lib/apt/lists/*

  buildah unmount $ctr
  buildah commit --squash $ctr myapp:$VERSION
  buildah rm $ctr

  echo "Built myapp:$VERSION"

MOUNT (Direct Filesystem Access):
  ctr=$(buildah from alpine:3.19)
  mnt=$(buildah mount $ctr)

  # Now $mnt is the container's rootfs
  ls $mnt/etc/
  cp myconfig.conf $mnt/etc/
  chown 1000:1000 $mnt/app

  buildah unmount $ctr
EOF
}

cmd_advanced() {
cat << 'EOF'
ADVANCED FEATURES
===================

ROOTLESS BUILDS:
  # No root required!
  buildah bud -t myapp:v1 .
  buildah push myapp:v1 docker://registry.example.com/myapp:v1

  # Configure user namespaces
  echo "user:100000:65536" | sudo tee /etc/subuid
  echo "user:100000:65536" | sudo tee /etc/subgid

MULTI-ARCH BUILDS:
  # Build for multiple architectures
  buildah bud --platform linux/amd64 -t myapp:amd64 .
  buildah bud --platform linux/arm64 -t myapp:arm64 .

  # Create manifest list
  buildah manifest create myapp:latest
  buildah manifest add myapp:latest myapp:amd64
  buildah manifest add myapp:latest myapp:arm64
  buildah manifest push myapp:latest docker://registry.example.com/myapp:latest

CI/CD (GitLab CI):
  build:
    image: quay.io/buildah/stable
    stage: build
    script:
      - buildah bud --layers -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
      - buildah login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
      - buildah push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA

CI/CD (GitHub Actions):
  - name: Build image
    run: |
      buildah bud -t ghcr.io/${{ github.repository }}:${{ github.sha }} .
      buildah login -u ${{ github.actor }} -p ${{ secrets.GITHUB_TOKEN }} ghcr.io
      buildah push ghcr.io/${{ github.repository }}:${{ github.sha }}

INSPECT & DEBUG:
  buildah images                        # List images
  buildah containers                    # List working containers
  buildah inspect myapp:v1              # Image details
  buildah inspect --type container $ctr # Container details

  # Image history
  buildah inspect myapp:v1 | jq '.Docker.history'

  # Check image size
  buildah images --format "{{.Name}} {{.Size}}"

STORAGE:
  # Default: ~/.local/share/containers/storage/ (rootless)
  # Override: /etc/containers/storage.conf
  buildah info  # Show storage info

CLEANUP:
  buildah rm --all                      # Remove all containers
  buildah rmi --all                     # Remove all images
  buildah rmi --prune                   # Remove dangling images

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Buildah - OCI Container Image Builder Reference

Commands:
  intro        Overview, comparison, ecosystem
  dockerfile   Containerfile builds, multi-stage, push
  scripted     Shell-scriptable builds, mount, filesystem access
  advanced     Rootless, multi-arch, CI/CD, inspect

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  dockerfile) cmd_dockerfile ;;
  scripted)   cmd_scripted ;;
  advanced)   cmd_advanced ;;
  help|*)     show_help ;;
esac
