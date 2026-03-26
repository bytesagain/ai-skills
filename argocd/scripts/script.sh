#!/bin/bash
# Argo CD - GitOps Continuous Delivery for Kubernetes Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              ARGO CD REFERENCE                              ║
║          Declarative GitOps CD for Kubernetes               ║
╚══════════════════════════════════════════════════════════════╝

Argo CD is a declarative GitOps continuous delivery tool for Kubernetes.
It watches Git repos and automatically syncs cluster state to match
the desired state defined in Git.

CORE PRINCIPLE:
  Git = single source of truth for infrastructure and applications.
  Any change goes through Git (PR review) → Argo CD applies it.

KEY CONCEPTS:
  Application      A group of K8s resources defined in Git
  Project          Logical grouping + RBAC for applications
  Sync             Deploy desired state from Git to cluster
  Health           Is the app running correctly?
  Refresh          Re-read Git to detect drift
  Diff             Compare desired (Git) vs live (cluster)
  Rollback         Revert to a previous Git commit
  Hook             Run jobs at sync phases (PreSync, Sync, PostSync)

ARCHITECTURE:
  ┌────────────┐     ┌────────────────┐     ┌──────────┐
  │  Git Repo  │────→│   Argo CD      │────→│  K8s     │
  │ (manifests)│     │  ┌──────────┐  │     │ Cluster  │
  │            │     │  │API Server│  │     │          │
  │            │     │  ├──────────┤  │     │          │
  │            │     │  │Repo Srvr │  │     │          │
  │            │     │  ├──────────┤  │     │          │
  │            │     │  │App Ctrl  │  │     │          │
  │            │     │  └──────────┘  │     │          │
  └────────────┘     └────────────────┘     └──────────┘

SYNC STRATEGIES:
  Manual        User triggers sync from UI/CLI
  Automated     Auto-sync when Git changes detected
  Self-heal     Auto-revert manual cluster changes
  Prune         Delete resources removed from Git
EOF
}

cmd_install() {
cat << 'EOF'
INSTALLATION & SETUP
======================

INSTALL:
  kubectl create namespace argocd
  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

  # Wait for pods
  kubectl wait --for=condition=Ready pods --all -n argocd --timeout=300s

  # Get initial admin password
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

ACCESS UI:
  # Port-forward
  kubectl port-forward svc/argocd-server -n argocd 8080:443
  # Open https://localhost:8080
  # Login: admin / <password from above>

  # Or expose via Ingress
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: argocd-server
    namespace: argocd
    annotations:
      nginx.ingress.kubernetes.io/ssl-passthrough: "true"
  spec:
    rules:
    - host: argocd.example.com
      http:
        paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: argocd-server
              port:
                number: 443

CLI INSTALL:
  # macOS
  brew install argocd

  # Linux
  curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
  chmod +x argocd && sudo mv argocd /usr/local/bin/

  # Login
  argocd login localhost:8080 --insecure
  argocd account update-password

HELM INSTALL (Production):
  helm repo add argo https://argoproj.github.io/argo-helm
  helm install argocd argo/argo-cd \
    --namespace argocd \
    --create-namespace \
    --values values.yaml

  values.yaml:
    server:
      replicas: 2
      ingress:
        enabled: true
        hosts: [argocd.example.com]
    controller:
      replicas: 1
    repoServer:
      replicas: 2
    redis:
      resources:
        limits:
          memory: 256Mi
EOF
}

cmd_apps() {
cat << 'EOF'
APPLICATION MANAGEMENT
========================

CREATE APPLICATION (CLI):
  argocd app create my-app \
    --repo https://github.com/org/repo.git \
    --path k8s/production \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace default \
    --sync-policy automated \
    --auto-prune \
    --self-heal

CREATE APPLICATION (YAML):
  apiVersion: argoproj.io/v1alpha1
  kind: Application
  metadata:
    name: my-app
    namespace: argocd
  spec:
    project: default
    source:
      repoURL: https://github.com/org/repo.git
      targetRevision: main
      path: k8s/production
    destination:
      server: https://kubernetes.default.svc
      namespace: default
    syncPolicy:
      automated:
        prune: true
        selfHeal: true
      syncOptions:
        - CreateNamespace=true
      retry:
        limit: 5
        backoff:
          duration: 5s
          factor: 2
          maxDuration: 3m

HELM APPLICATION:
  spec:
    source:
      repoURL: https://charts.bitnami.com/bitnami
      chart: nginx
      targetRevision: 15.0.0
      helm:
        releaseName: my-nginx
        values: |
          replicaCount: 3
          service:
            type: ClusterIP
        parameters:
          - name: image.tag
            value: "1.25"

KUSTOMIZE APPLICATION:
  spec:
    source:
      repoURL: https://github.com/org/repo.git
      path: overlays/production
      kustomize:
        namePrefix: prod-
        images:
          - myapp=registry.example.com/myapp:v1.2.3

CLI OPERATIONS:
  argocd app list                     # List all apps
  argocd app get my-app               # App details
  argocd app sync my-app              # Manual sync
  argocd app diff my-app              # Show diff
  argocd app history my-app           # Deployment history
  argocd app rollback my-app <id>     # Rollback
  argocd app delete my-app            # Delete app
  argocd app set my-app --parameter image.tag=v2.0  # Update param
EOF
}

cmd_patterns() {
cat << 'EOF'
GITOPS PATTERNS
=================

1. APP OF APPS
   One "parent" Application deploys other Applications.

   # apps/Chart.yaml or apps/ directory
   apiVersion: argoproj.io/v1alpha1
   kind: Application
   metadata:
     name: app-of-apps
   spec:
     source:
       path: apps/         # Contains other Application YAMLs
     destination:
       namespace: argocd

   apps/
   ├── frontend.yaml       # Application: frontend
   ├── backend.yaml        # Application: backend
   ├── database.yaml       # Application: database
   └── monitoring.yaml     # Application: monitoring

2. APPLICATIONSET
   Generate Applications from templates.

   apiVersion: argoproj.io/v1alpha1
   kind: ApplicationSet
   metadata:
     name: cluster-addons
   spec:
     generators:
     - list:
         elements:
         - cluster: staging
           url: https://staging.k8s.example.com
         - cluster: production
           url: https://prod.k8s.example.com
     template:
       metadata:
         name: '{{cluster}}-addons'
       spec:
         source:
           repoURL: https://github.com/org/addons.git
           path: 'overlays/{{cluster}}'
         destination:
           server: '{{url}}'

   Generators:
     list        Static list of parameters
     clusters    All registered clusters
     git         Directories or files in a Git repo
     matrix      Combine two generators
     merge       Merge multiple generators
     pullRequest GitHub/GitLab PRs (preview environments!)

3. MULTI-ENVIRONMENT
   Repo structure:
   ├── base/                # Shared manifests
   │   ├── deployment.yaml
   │   └── service.yaml
   ├── overlays/
   │   ├── staging/
   │   │   └── kustomization.yaml
   │   └── production/
   │       └── kustomization.yaml

   Two Argo CD Applications:
   - my-app-staging:  path=overlays/staging
   - my-app-prod:     path=overlays/production

4. PROGRESSIVE DELIVERY
   Use Argo Rollouts for canary/blue-green:

   apiVersion: argoproj.io/v1alpha1
   kind: Rollout
   spec:
     strategy:
       canary:
         steps:
         - setWeight: 10        # 10% traffic
         - pause: { duration: 5m }
         - setWeight: 30
         - pause: { duration: 10m }
         - setWeight: 60
         - pause: { duration: 10m }

5. SYNC WAVES & HOOKS
   Control deployment order:

   metadata:
     annotations:
       argocd.argoproj.io/sync-wave: "1"    # Lower = first

   Wave order:
     -1  Namespace, CRDs
      0  ConfigMaps, Secrets
      1  Database migrations (Job)
      2  Deployments
      3  Post-deploy tests (Job)

   Hooks:
     argocd.argoproj.io/hook: PreSync     # Before sync
     argocd.argoproj.io/hook: Sync        # During sync
     argocd.argoproj.io/hook: PostSync    # After sync
     argocd.argoproj.io/hook: SyncFail   # On failure
EOF
}

cmd_security() {
cat << 'EOF'
SECURITY & RBAC
=================

PROJECTS (RBAC boundaries):
  apiVersion: argoproj.io/v1alpha1
  kind: AppProject
  metadata:
    name: team-frontend
    namespace: argocd
  spec:
    description: Frontend team applications
    sourceRepos:
      - 'https://github.com/org/frontend-*'
    destinations:
      - namespace: 'frontend-*'
        server: https://kubernetes.default.svc
    clusterResourceWhitelist:
      - group: ''
        kind: Namespace
    namespaceResourceWhitelist:
      - group: '*'
        kind: '*'
    roles:
      - name: frontend-dev
        policies:
          - p, proj:team-frontend:frontend-dev, applications, get, team-frontend/*, allow
          - p, proj:team-frontend:frontend-dev, applications, sync, team-frontend/*, allow

RBAC POLICY:
  # argocd-rbac-cm ConfigMap
  policy.csv: |
    p, role:readonly, applications, get, */*, allow
    p, role:developer, applications, sync, */*, allow
    p, role:developer, applications, get, */*, allow
    p, role:admin, *, *, */*, allow
    g, my-team, role:developer
    g, ops-team, role:admin

SSO INTEGRATION:
  # argocd-cm ConfigMap
  url: https://argocd.example.com
  dex.config: |
    connectors:
    - type: github
      id: github
      name: GitHub
      config:
        clientID: $GITHUB_CLIENT_ID
        clientSecret: $GITHUB_CLIENT_SECRET
        orgs:
        - name: my-org

  # Or OIDC directly:
  oidc.config: |
    name: Okta
    issuer: https://my-org.okta.com
    clientID: xxxxxxxxx
    clientSecret: $OIDC_CLIENT_SECRET

SECRETS MANAGEMENT:
  Argo CD should NOT store secrets in Git!

  Options:
  1. Sealed Secrets (Bitnami)
     kubeseal < secret.yaml > sealed-secret.yaml
     # Encrypted secret safe to commit to Git

  2. External Secrets Operator
     Fetch secrets from AWS SM, Vault, GCP SM at runtime

  3. SOPS + age/PGP
     Encrypt secret values in YAML files

  4. Vault Agent Injector
     HashiCorp Vault injects secrets into pods

NOTIFICATIONS:
  # argocd-notifications-cm
  trigger.on-sync-succeeded: |
    - send: [slack]
      when: app.status.sync.status == 'Synced'

  template.slack: |
    message: "{{.app.metadata.name}} synced successfully"

  service.slack: |
    token: $SLACK_TOKEN
    channel: #deployments

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Argo CD - GitOps Continuous Delivery Reference

Commands:
  intro      GitOps principles, architecture, sync strategies
  install    Installation (kubectl, Helm), UI access, CLI
  apps       Application creation (CLI, YAML, Helm, Kustomize)
  patterns   App-of-apps, ApplicationSet, multi-env, canary
  security   Projects, RBAC, SSO, secrets management

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  install)  cmd_install ;;
  apps)     cmd_apps ;;
  patterns) cmd_patterns ;;
  security) cmd_security ;;
  help|*)   show_help ;;
esac
