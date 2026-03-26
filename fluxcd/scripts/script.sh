#!/bin/bash
# FluxCD - GitOps for Kubernetes Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              FLUXCD REFERENCE                               ║
║          GitOps Continuous Delivery for Kubernetes           ║
╚══════════════════════════════════════════════════════════════╝

FluxCD keeps Kubernetes clusters in sync with Git repositories.
Push to Git → Flux detects changes → applies to cluster.
CNCF graduated project.

FLUXCD vs ARGOCD:
  ┌──────────────┬──────────────┬──────────────┐
  │ Feature      │ FluxCD       │ ArgoCD       │
  ├──────────────┼──────────────┼──────────────┤
  │ UI           │ CLI (Weave)  │ Built-in web │
  │ Architecture │ Controllers  │ Server+UI    │
  │ GitOps model │ Pull-based   │ Pull-based   │
  │ Helm support │ Native       │ Native       │
  │ Kustomize    │ Native       │ Native       │
  │ Multi-tenant │ Built-in     │ Projects     │
  │ Notifications│ Built-in     │ Webhooks     │
  │ Image update │ Built-in     │ Plugin       │
  │ CNCF         │ Graduated    │ Graduated    │
  └──────────────┴──────────────┴──────────────┘

COMPONENTS:
  source-controller      Fetches Git/Helm/OCI sources
  kustomize-controller   Reconciles Kustomizations
  helm-controller        Reconciles HelmReleases
  notification-controller Handles alerts/webhooks
  image-reflector        Scans container registries
  image-automation       Updates Git with new image tags

INSTALL:
  flux install
  # or bootstrap (recommended)
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
SOURCES & KUSTOMIZATIONS
===========================

GIT SOURCE:
  apiVersion: source.toolkit.fluxcd.io/v1
  kind: GitRepository
  metadata:
    name: myapp
    namespace: flux-system
  spec:
    interval: 1m
    url: https://github.com/myorg/myapp.git
    ref:
      branch: main
    secretRef:
      name: github-creds      # For private repos

KUSTOMIZATION:
  apiVersion: kustomize.toolkit.fluxcd.io/v1
  kind: Kustomization
  metadata:
    name: myapp
    namespace: flux-system
  spec:
    interval: 5m
    path: ./deploy/overlays/prod
    sourceRef:
      kind: GitRepository
      name: myapp
    prune: true                 # Delete removed resources
    healthChecks:
      - apiVersion: apps/v1
        kind: Deployment
        name: myapp
        namespace: production
    timeout: 3m
    wait: true

HELM SOURCE:
  apiVersion: source.toolkit.fluxcd.io/v1
  kind: HelmRepository
  metadata:
    name: bitnami
    namespace: flux-system
  spec:
    interval: 1h
    url: https://charts.bitnami.com/bitnami

HELM RELEASE:
  apiVersion: helm.toolkit.fluxcd.io/v2
  kind: HelmRelease
  metadata:
    name: redis
    namespace: flux-system
  spec:
    interval: 5m
    chart:
      spec:
        chart: redis
        version: "18.x"
        sourceRef:
          kind: HelmRepository
          name: bitnami
    values:
      architecture: standalone
      auth:
        enabled: true
    valuesFrom:
      - kind: Secret
        name: redis-values
        valuesKey: values.yaml
EOF
}

cmd_advanced() {
cat << 'EOF'
IMAGE AUTOMATION & NOTIFICATIONS
====================================

IMAGE POLICY (auto-update tags):
  # Scan registry for new tags
  apiVersion: image.toolkit.fluxcd.io/v1beta2
  kind: ImageRepository
  metadata:
    name: myapp
  spec:
    image: ghcr.io/myorg/myapp
    interval: 5m

  # Define update policy
  apiVersion: image.toolkit.fluxcd.io/v1beta2
  kind: ImagePolicy
  metadata:
    name: myapp
  spec:
    imageRepositoryRef:
      name: myapp
    policy:
      semver:
        range: ">=1.0.0"

  # Auto-update Git with new tags
  apiVersion: image.toolkit.fluxcd.io/v1beta2
  kind: ImageUpdateAutomation
  metadata:
    name: myapp
  spec:
    interval: 5m
    sourceRef:
      kind: GitRepository
      name: fleet-infra
    git:
      commit:
        author:
          name: fluxcd
          email: flux@myorg.com
        messageTemplate: "chore: update {{.AutomationObject}} images"
    update:
      path: ./clusters/production
      strategy: Setters

NOTIFICATIONS:
  # Slack alert
  apiVersion: notification.toolkit.fluxcd.io/v1beta3
  kind: Provider
  metadata:
    name: slack
  spec:
    type: slack
    channel: deployments
    secretRef:
      name: slack-webhook

  apiVersion: notification.toolkit.fluxcd.io/v1beta3
  kind: Alert
  metadata:
    name: deployment-alerts
  spec:
    providerRef:
      name: slack
    eventSeverity: info
    eventSources:
      - kind: Kustomization
        name: "*"
      - kind: HelmRelease
        name: "*"

MULTI-TENANCY:
  # Tenant namespace with restricted access
  apiVersion: kustomize.toolkit.fluxcd.io/v1
  kind: Kustomization
  metadata:
    name: tenant-a
  spec:
    serviceAccountName: tenant-a    # Restricted SA
    path: ./tenants/tenant-a
    sourceRef:
      kind: GitRepository
      name: tenant-a-repo
    targetNamespace: tenant-a

FLUX CLI:
  flux get all                       # Status of all resources
  flux get kustomizations            # List kustomizations
  flux get helmreleases              # List Helm releases
  flux reconcile kustomization myapp # Force sync
  flux reconcile source git myapp    # Force fetch
  flux suspend kustomization myapp   # Pause reconciliation
  flux resume kustomization myapp    # Resume
  flux logs                          # Controller logs
  flux events                        # Recent events
  flux trace myapp                   # Debug dependency chain

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
FluxCD - GitOps for Kubernetes Reference

Commands:
  intro      Architecture, components, bootstrap
  sources    GitRepository, Kustomization, HelmRelease
  advanced   Image automation, notifications, multi-tenancy

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  sources)  cmd_sources ;;
  advanced) cmd_advanced ;;
  help|*)   show_help ;;
esac
