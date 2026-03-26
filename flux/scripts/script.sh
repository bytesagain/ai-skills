#!/bin/bash
# Flux - GitOps for Kubernetes Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              FLUX REFERENCE                                 ║
║          GitOps Toolkit for Kubernetes                      ║
╚══════════════════════════════════════════════════════════════╝

Flux is a CNCF graduated project that keeps Kubernetes clusters
in sync with sources of configuration (Git repos, Helm repos,
OCI registries) using GitOps principles.

GITOPS PRINCIPLES:
  1. Declarative   Desired state in Git
  2. Versioned     Git history = audit log
  3. Automated     Changes auto-applied
  4. Reconciled    Drift auto-corrected

KEY COMPONENTS:
  Source Controller      Fetches from Git/Helm/OCI
  Kustomize Controller   Applies Kustomize overlays
  Helm Controller        Manages Helm releases
  Notification Controller Alerts/webhooks
  Image Automation       Auto-update image tags

FLUX vs ARGOCD:
  ┌──────────────┬──────────┬──────────┐
  │ Feature      │ Flux     │ ArgoCD   │
  ├──────────────┼──────────┼──────────┤
  │ Architecture │ Toolkit  │ Monolith │
  │ UI           │ Web*     │ Built-in │
  │ Multi-tenant │ Native   │ Projects │
  │ Helm         │ Native   │ Native   │
  │ Kustomize    │ Native   │ Native   │
  │ Image update │ Built-in │ Plugin   │
  │ Notifications│ Built-in │ Built-in │
  │ CNCF         │ Graduated│ Graduated│
  │ CLI          │ flux     │ argocd   │
  └──────────────┴──────────┴──────────┘
  * Flux UI via Weave GitOps

INSTALL:
  # CLI
  curl -s https://fluxcd.io/install.sh | sudo bash

  # Bootstrap (installs Flux in cluster + sets up Git repo)
  flux bootstrap github \
    --owner=myorg \
    --repository=fleet-infra \
    --branch=main \
    --path=clusters/production \
    --personal
EOF
}

cmd_sources() {
cat << 'EOF'
SOURCES & KUSTOMIZATION
==========================

GIT REPOSITORY:
  apiVersion: source.toolkit.fluxcd.io/v1
  kind: GitRepository
  metadata:
    name: my-app
    namespace: flux-system
  spec:
    interval: 1m
    url: https://github.com/myorg/my-app
    ref:
      branch: main
    secretRef:
      name: github-credentials    # For private repos

KUSTOMIZATION (deploy from Git):
  apiVersion: kustomize.toolkit.fluxcd.io/v1
  kind: Kustomization
  metadata:
    name: my-app
    namespace: flux-system
  spec:
    interval: 5m
    path: ./deploy/production
    sourceRef:
      kind: GitRepository
      name: my-app
    prune: true                   # Delete removed resources
    healthChecks:
    - apiVersion: apps/v1
      kind: Deployment
      name: my-app
      namespace: default
    timeout: 2m

HELM REPOSITORY:
  apiVersion: source.toolkit.fluxcd.io/v1beta2
  kind: HelmRepository
  metadata:
    name: bitnami
    namespace: flux-system
  spec:
    interval: 1h
    url: https://charts.bitnami.com/bitnami

HELM RELEASE:
  apiVersion: helm.toolkit.fluxcd.io/v2beta2
  kind: HelmRelease
  metadata:
    name: redis
    namespace: default
  spec:
    interval: 5m
    chart:
      spec:
        chart: redis
        version: "18.x"
        sourceRef:
          kind: HelmRepository
          name: bitnami
          namespace: flux-system
    values:
      auth:
        enabled: true
        password: "${REDIS_PASSWORD}"
      replica:
        replicaCount: 3

OCI REPOSITORY:
  apiVersion: source.toolkit.fluxcd.io/v1beta2
  kind: OCIRepository
  metadata:
    name: my-app
    namespace: flux-system
  spec:
    interval: 5m
    url: oci://ghcr.io/myorg/my-app-manifests
    ref:
      tag: latest
EOF
}

cmd_automation() {
cat << 'EOF'
IMAGE AUTOMATION & NOTIFICATIONS
====================================

IMAGE AUTO-UPDATE:
  # 1. Scan registry for new tags
  apiVersion: image.toolkit.fluxcd.io/v1beta2
  kind: ImageRepository
  metadata:
    name: my-app
    namespace: flux-system
  spec:
    image: ghcr.io/myorg/my-app
    interval: 1m

  # 2. Define update policy
  apiVersion: image.toolkit.fluxcd.io/v1beta2
  kind: ImagePolicy
  metadata:
    name: my-app
    namespace: flux-system
  spec:
    imageRepositoryRef:
      name: my-app
    policy:
      semver:
        range: ">=1.0.0"
    # Or: alphabetical, numerical

  # 3. Auto-update Git repo
  apiVersion: image.toolkit.fluxcd.io/v1beta2
  kind: ImageUpdateAutomation
  metadata:
    name: flux-system
    namespace: flux-system
  spec:
    interval: 1m
    sourceRef:
      kind: GitRepository
      name: flux-system
    git:
      checkout:
        ref:
          branch: main
      commit:
        author:
          email: flux@myorg.com
          name: flux-bot
        messageTemplate: "Auto-update image {{range .Updated.Images}}{{.}}{{end}}"
      push:
        branch: main
    update:
      path: ./clusters/production
      strategy: Setters

  # 4. Mark image in deployment YAML:
  image: ghcr.io/myorg/my-app:1.2.3 # {"$imagepolicy": "flux-system:my-app"}

NOTIFICATIONS:
  # Alert to Slack on reconciliation failure
  apiVersion: notification.toolkit.fluxcd.io/v1beta3
  kind: Provider
  metadata:
    name: slack
    namespace: flux-system
  spec:
    type: slack
    channel: deployments
    secretRef:
      name: slack-webhook

  apiVersion: notification.toolkit.fluxcd.io/v1beta3
  kind: Alert
  metadata:
    name: on-failure
    namespace: flux-system
  spec:
    providerRef:
      name: slack
    eventSeverity: error
    eventSources:
    - kind: Kustomization
      name: "*"
    - kind: HelmRelease
      name: "*"

FLUX CLI:
  flux get all                    # All resources status
  flux get kustomizations         # Kustomization status
  flux get helmreleases           # Helm release status
  flux get sources git            # Git sources
  flux reconcile kustomization my-app  # Force sync
  flux reconcile source git my-app     # Force fetch
  flux suspend kustomization my-app    # Pause reconciliation
  flux resume kustomization my-app     # Resume
  flux logs --all-namespaces      # Controller logs
  flux diff kustomization my-app  # Preview changes

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Flux - GitOps for Kubernetes Reference

Commands:
  intro       Overview, GitOps principles, comparison
  sources     Git/Helm/OCI sources, Kustomization, HelmRelease
  automation  Image auto-update, notifications, CLI

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  sources)    cmd_sources ;;
  automation) cmd_automation ;;
  help|*)     show_help ;;
esac
