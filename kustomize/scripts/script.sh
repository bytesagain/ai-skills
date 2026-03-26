#!/bin/bash
# Kustomize - Kubernetes Config Customization Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              KUSTOMIZE REFERENCE                            ║
║          Template-Free Kubernetes Config Customization      ║
╚══════════════════════════════════════════════════════════════╝

Kustomize lets you customize Kubernetes YAML without templates.
Instead of Helm's Go templating, Kustomize uses overlays and
patches on plain YAML. Built into kubectl since v1.14.

KUSTOMIZE vs HELM:
  ┌──────────────┬──────────────┬──────────────┐
  │ Feature      │ Kustomize    │ Helm         │
  ├──────────────┼──────────────┼──────────────┤
  │ Approach     │ Overlay/patch│ Templates    │
  │ Learning     │ Easy         │ Moderate     │
  │ Config files │ Plain YAML   │ Go templates │
  │ Packaging    │ Directories  │ Charts       │
  │ Built-in     │ Yes (kubectl)│ Separate     │
  │ Complexity   │ Simple       │ Powerful     │
  │ Best for     │ Config tweaks│ App packaging│
  └──────────────┴──────────────┴──────────────┘

DIRECTORY STRUCTURE:
  myapp/
  ├── base/
  │   ├── kustomization.yaml
  │   ├── deployment.yaml
  │   └── service.yaml
  └── overlays/
      ├── dev/
      │   └── kustomization.yaml
      ├── staging/
      │   └── kustomization.yaml
      └── prod/
          ├── kustomization.yaml
          └── replica-patch.yaml
EOF
}

cmd_config() {
cat << 'EOF'
KUSTOMIZATION.YAML
=====================

BASE:
  # base/kustomization.yaml
  apiVersion: kustomize.config.k8s.io/v1beta1
  kind: Kustomization
  resources:
    - deployment.yaml
    - service.yaml
    - configmap.yaml
  commonLabels:
    app: myapp
  namespace: default

OVERLAY (dev):
  # overlays/dev/kustomization.yaml
  apiVersion: kustomize.config.k8s.io/v1beta1
  kind: Kustomization
  resources:
    - ../../base
  namespace: dev
  namePrefix: dev-
  commonLabels:
    env: development
  patches:
    - target:
        kind: Deployment
        name: myapp
      patch: |
        - op: replace
          path: /spec/replicas
          value: 1

OVERLAY (prod):
  # overlays/prod/kustomization.yaml
  apiVersion: kustomize.config.k8s.io/v1beta1
  kind: Kustomization
  resources:
    - ../../base
  namespace: production
  namePrefix: prod-
  replicas:
    - name: myapp
      count: 5
  images:
    - name: myapp
      newTag: v2.1.0
  configMapGenerator:
    - name: app-config
      literals:
        - LOG_LEVEL=warn
        - DB_HOST=prod-db.internal

GENERATORS:
  # ConfigMap from file
  configMapGenerator:
    - name: nginx-config
      files:
        - nginx.conf
    - name: env-config
      envs:
        - .env

  # Secret from literals
  secretGenerator:
    - name: db-creds
      literals:
        - username=admin
        - password=s3cret
      type: kubernetes.io/basic-auth

PATCHES:
  # Strategic merge patch
  patches:
    - path: increase-replicas.yaml

  # JSON patch
  patches:
    - target:
        kind: Deployment
        name: myapp
      patch: |
        - op: add
          path: /spec/template/spec/containers/0/resources
          value:
            limits:
              cpu: "2"
              memory: 2Gi
            requests:
              cpu: "500m"
              memory: 512Mi

  # Inline patch
  patches:
    - patch: |
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          name: myapp
        spec:
          replicas: 3
EOF
}

cmd_commands() {
cat << 'EOF'
CLI & ADVANCED FEATURES
=========================

COMMANDS:
  # Preview output (built into kubectl)
  kubectl kustomize overlays/prod/
  kustomize build overlays/prod/

  # Apply
  kubectl apply -k overlays/prod/
  kubectl delete -k overlays/prod/

  # Diff before apply
  kubectl diff -k overlays/prod/

  # Edit kustomization
  kustomize edit add resource new-service.yaml
  kustomize edit set image myapp=myapp:v2.0
  kustomize edit set namespace production
  kustomize edit add label env:prod

COMPONENTS (reusable mixins):
  # components/monitoring/kustomization.yaml
  apiVersion: kustomize.config.k8s.io/v1alpha1
  kind: Component
  resources:
    - service-monitor.yaml
  patches:
    - path: add-prometheus-annotations.yaml

  # Use in overlay
  # overlays/prod/kustomization.yaml
  components:
    - ../../components/monitoring
    - ../../components/logging

TRANSFORMERS:
  # Add annotations to all resources
  commonAnnotations:
    team: backend
    oncall: "@backend-team"

  # Replace image tags
  images:
    - name: nginx
      newName: my-registry.com/nginx
      newTag: "1.25"
    - name: myapp
      digest: sha256:abc123...

ARGOCD + KUSTOMIZE:
  # ArgoCD Application
  apiVersion: argoproj.io/v1alpha1
  kind: Application
  spec:
    source:
      repoURL: https://github.com/myorg/k8s-configs.git
      path: overlays/prod
      targetRevision: HEAD

  # FluxCD Kustomization
  apiVersion: kustomize.toolkit.fluxcd.io/v1
  kind: Kustomization
  spec:
    path: ./overlays/prod
    sourceRef:
      kind: GitRepository
      name: myapp

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Kustomize - Kubernetes Config Customization Reference

Commands:
  intro      Overview, vs Helm, directory structure
  config     kustomization.yaml, overlays, patches, generators
  commands   CLI, components, transformers, GitOps

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  config)   cmd_config ;;
  commands) cmd_commands ;;
  help|*)   show_help ;;
esac
