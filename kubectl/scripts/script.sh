#!/bin/bash
# Kubectl - Kubernetes CLI Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              KUBECTL REFERENCE                              ║
║          Kubernetes Command Line Tool                       ║
╚══════════════════════════════════════════════════════════════╝

kubectl is the CLI for Kubernetes cluster management. It talks
to the kube-apiserver to manage all cluster resources.

KUBECONFIG:
  export KUBECONFIG=~/.kube/config
  kubectl config view                  # Show config
  kubectl config get-contexts          # List contexts
  kubectl config use-context prod      # Switch context
  kubectl config set-context --current --namespace=myns

RESOURCE TYPES (short names):
  po    pods              svc   services
  deploy deployments      rs    replicasets
  ds    daemonsets        sts   statefulsets
  cm    configmaps        secret secrets
  ns    namespaces        no    nodes
  pv    persistentvolumes pvc   persistentvolumeclaims
  ing   ingresses         ep    endpoints
  sa    serviceaccounts   hpa   horizontalpodautoscalers
  crd   customresourcedefinitions
EOF
}

cmd_resources() {
cat << 'EOF'
RESOURCE MANAGEMENT
=====================

GET:
  kubectl get pods                     # List pods
  kubectl get pods -o wide             # Extra info (node, IP)
  kubectl get pods -o yaml             # Full YAML
  kubectl get pods -o json             # JSON
  kubectl get pods --sort-by=.metadata.creationTimestamp
  kubectl get pods -l app=web          # Label selector
  kubectl get pods -A                  # All namespaces
  kubectl get pods --field-selector=status.phase=Running
  kubectl get all                      # Pods, services, deployments

  # Custom columns
  kubectl get pods -o custom-columns=\
    NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName

  # Watch
  kubectl get pods -w

CREATE / APPLY:
  kubectl apply -f deployment.yaml     # Create/update
  kubectl apply -f ./manifests/        # Apply directory
  kubectl apply -f https://raw.githubusercontent.com/...
  kubectl create deployment web --image=nginx --replicas=3
  kubectl create service clusterip web --tcp=80:80
  kubectl create configmap myconfig --from-file=config.ini
  kubectl create secret generic mysecret --from-literal=key=value

DELETE:
  kubectl delete pod mypod
  kubectl delete -f deployment.yaml
  kubectl delete pods -l app=old       # By label
  kubectl delete pods --all -n test    # All in namespace
  kubectl delete pod mypod --grace-period=0 --force

EDIT / PATCH:
  kubectl edit deployment web
  kubectl patch deployment web -p '{"spec":{"replicas":5}}'
  kubectl set image deployment/web app=nginx:1.25
  kubectl scale deployment web --replicas=10
  kubectl rollout restart deployment web
EOF
}

cmd_debugging() {
cat << 'EOF'
DEBUGGING & TROUBLESHOOTING
==============================

LOGS:
  kubectl logs mypod                   # Pod logs
  kubectl logs mypod -c mycontainer    # Specific container
  kubectl logs mypod --previous        # Previous crash logs
  kubectl logs mypod -f                # Follow/stream
  kubectl logs mypod --tail=100        # Last 100 lines
  kubectl logs mypod --since=1h        # Last hour
  kubectl logs -l app=web              # All pods with label

EXEC:
  kubectl exec -it mypod -- /bin/bash  # Shell into pod
  kubectl exec mypod -- cat /etc/hosts # Run command
  kubectl exec -it mypod -c sidecar -- sh  # Specific container

DEBUG:
  kubectl describe pod mypod           # Detailed info + events
  kubectl describe node mynode
  kubectl get events --sort-by=.lastTimestamp
  kubectl get events -w                # Watch events

  # Debug pod (ephemeral container)
  kubectl debug mypod -it --image=busybox
  kubectl debug node/mynode -it --image=ubuntu

PORT FORWARD:
  kubectl port-forward pod/mypod 8080:80
  kubectl port-forward svc/myservice 8080:80
  kubectl port-forward deploy/web 3000:3000

COPY:
  kubectl cp mypod:/var/log/app.log ./app.log
  kubectl cp ./config.ini mypod:/etc/config.ini

TOP (metrics):
  kubectl top pods                     # Pod CPU/memory
  kubectl top pods --sort-by=cpu
  kubectl top nodes                    # Node resources

DRAIN / CORDON:
  kubectl cordon mynode                # Mark unschedulable
  kubectl uncordon mynode              # Mark schedulable
  kubectl drain mynode --ignore-daemonsets --delete-emptydir-data
EOF
}

cmd_advanced() {
cat << 'EOF'
ADVANCED PATTERNS
===================

JSONPATH:
  # Get pod IPs
  kubectl get pods -o jsonpath='{.items[*].status.podIP}'

  # Get image names
  kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[0].image}{"\n"}{end}'

  # Node external IPs
  kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="ExternalIP")].address}'

RBAC:
  kubectl auth can-i create pods                    # Check permission
  kubectl auth can-i create pods --as=system:serviceaccount:ns:sa
  kubectl create clusterrolebinding admin --clusterrole=admin --user=user@example.com
  kubectl get clusterroles
  kubectl describe clusterrole admin

ROLLOUTS:
  kubectl rollout status deployment web
  kubectl rollout history deployment web
  kubectl rollout undo deployment web               # Rollback
  kubectl rollout undo deployment web --to-revision=3
  kubectl rollout pause deployment web
  kubectl rollout resume deployment web

DRY RUN & DIFF:
  kubectl apply -f deploy.yaml --dry-run=server     # Server-side validation
  kubectl apply -f deploy.yaml --dry-run=client -o yaml  # Generate YAML
  kubectl diff -f deploy.yaml                       # Show what would change

  # Generate YAML from imperative
  kubectl create deployment web --image=nginx --dry-run=client -o yaml > deploy.yaml

WAIT:
  kubectl wait --for=condition=Ready pod/mypod --timeout=120s
  kubectl wait --for=condition=Available deployment/web
  kubectl wait --for=delete pod/mypod --timeout=60s

KREW (plugin manager):
  kubectl krew install ctx              # Switch contexts
  kubectl krew install ns               # Switch namespaces
  kubectl krew install neat             # Clean YAML output
  kubectl krew install tree             # Resource hierarchy
  kubectl krew install sniff            # Packet capture

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Kubectl - Kubernetes CLI Reference

Commands:
  intro       Config, contexts, resource types
  resources   Get, create, apply, delete, patch, scale
  debugging   Logs, exec, debug, port-forward, drain
  advanced    JSONPath, RBAC, rollouts, dry-run, krew

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)     cmd_intro ;;
  resources) cmd_resources ;;
  debugging) cmd_debugging ;;
  advanced)  cmd_advanced ;;
  help|*)    show_help ;;
esac
