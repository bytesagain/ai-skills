#!/bin/bash
# CoreDNS - Cloud-Native DNS Server Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              COREDNS REFERENCE                              ║
║          Flexible, Extensible DNS Server                    ║
╚══════════════════════════════════════════════════════════════╝

CoreDNS is a cloud-native DNS server written in Go. It's the
default DNS in Kubernetes and a CNCF graduated project.

KEY FEATURES:
  Plugin-based    Chain plugins to build any DNS behavior
  Kubernetes      Default cluster DNS (replaced kube-dns)
  Service mesh    Integrates with Consul, etcd, cloud providers
  Minimal         Single binary, no dependencies
  Fast            Written in Go, highly concurrent

COREDNS vs BIND vs KUBE-DNS:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ CoreDNS  │ BIND     │ kube-dns │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Architecture │ Plugins  │ Monolith │ 3 containers│
  │ Config       │ Corefile │ named.conf│ ConfigMap│
  │ Language     │ Go       │ C        │ Go/C     │
  │ K8s native   │ Yes      │ No       │ Yes      │
  │ Extensible   │ Easy     │ Hard     │ Hard     │
  │ Performance  │ High     │ High     │ Medium   │
  │ CNCF         │ Graduated│ No       │ No       │
  └──────────────┴──────────┴──────────┴──────────┘

INSTALL:
  # Binary
  curl -LO https://github.com/coredns/coredns/releases/latest/download/coredns_*_linux_amd64.tgz
  tar xzf coredns_*.tgz
  sudo mv coredns /usr/local/bin/

  # Docker
  docker run -d -p 53:53/udp -v ./Corefile:/Corefile coredns/coredns

  # Kubernetes (already default)
  kubectl -n kube-system get pods -l k8s-app=kube-dns
EOF
}

cmd_corefile() {
cat << 'EOF'
COREFILE CONFIGURATION
========================

The Corefile is CoreDNS's config file. Each server block
defines a zone and its plugin chain.

BASIC FORWARDER:
  . {
      forward . 8.8.8.8 1.1.1.1
      cache 30
      log
      errors
  }

AUTHORITATIVE ZONE:
  example.com {
      file /etc/coredns/example.com.zone
      log
  }

  . {
      forward . 8.8.8.8
      cache 30
  }

MULTIPLE ZONES:
  example.com {
      file /etc/coredns/example.com.zone
  }

  internal.corp {
      file /etc/coredns/internal.zone
  }

  . {
      forward . 8.8.8.8 1.1.1.1
      cache 60
      log
  }

KUBERNETES DNS:
  .:53 {
      kubernetes cluster.local in-addr.arpa ip6.arpa {
          pods insecure
          fallthrough in-addr.arpa ip6.arpa
          ttl 30
      }
      forward . /etc/resolv.conf
      cache 30
      loop
      reload
      loadbalance
      errors
  }

  # This resolves:
  # service.namespace.svc.cluster.local
  # pod-ip.namespace.pod.cluster.local

SPLIT DNS (internal vs external):
  corp.example.com {
      forward . 10.0.0.53     # Internal DNS
  }

  . {
      forward . 8.8.8.8       # External DNS
      cache 300
  }

LISTEN ON SPECIFIC PORT/INTERFACE:
  .:5353 {
      forward . 8.8.8.8
  }

  192.168.1.1:53 {
      file /etc/coredns/internal.zone
  }

HTTPS/TLS:
  tls://.:853 {
      tls /etc/coredns/cert.pem /etc/coredns/key.pem
      forward . 8.8.8.8
  }
EOF
}

cmd_plugins() {
cat << 'EOF'
PLUGINS
=========

CoreDNS is entirely plugin-based. Each line in a server block
is a plugin. Order matters — plugins execute in order listed.

CORE PLUGINS:
  forward      Forward queries to upstream DNS
  file         Serve zone files (RFC 1035)
  cache        Cache DNS responses
  log          Query logging
  errors       Error logging
  health       HTTP health check endpoint (:8080/health)
  ready        Readiness endpoint (:8181/ready)
  reload       Auto-reload Corefile on changes
  loop         Detect and halt forwarding loops
  loadbalance  Randomize A/AAAA record order

KUBERNETES PLUGIN:
  kubernetes cluster.local {
      pods insecure          # Resolve pod IPs
      fallthrough            # Pass unresolved to next plugin
      ttl 30                 # Response TTL
  }

  # Resolves:
  # <service>.<namespace>.svc.cluster.local      → ClusterIP
  # <pod-ip-dashed>.<namespace>.pod.cluster.local → Pod IP
  # <service>.<namespace>.svc.cluster.local SRV   → Port info

HOSTS PLUGIN:
  . {
      hosts {
          10.0.0.1 server1.local
          10.0.0.2 server2.local
          10.0.0.3 db.local
          fallthrough
      }
      forward . 8.8.8.8
  }

REWRITE:
  . {
      rewrite name exact old.example.com new.example.com
      rewrite name suffix .old.com .new.com
      rewrite name regex (.*)\.test\.com {1}.prod.com
      forward . 8.8.8.8
  }

TEMPLATE:
  . {
      template IN A example.com {
          answer "{{ .Name }} 60 IN A 10.0.0.1"
      }
  }

ETCD:
  . {
      etcd example.com {
          endpoint http://localhost:2379
          path /skydns
      }
  }

PROMETHEUS METRICS:
  . {
      prometheus :9153
      forward . 8.8.8.8
      cache 30
  }

  # Exposes metrics at :9153/metrics
  # coredns_dns_requests_total
  # coredns_dns_responses_total
  # coredns_cache_hits_total

ACLS:
  . {
      acl {
          allow net 192.168.0.0/16
          block net 0.0.0.0/0
      }
      forward . 8.8.8.8
  }
EOF
}

cmd_kubernetes() {
cat << 'EOF'
KUBERNETES DNS
================

CoreDNS is the default DNS in Kubernetes.
Every pod gets DNS resolution for services automatically.

HOW IT WORKS:
  Pod → resolv.conf → CoreDNS ClusterIP → Resolve → Response

  /etc/resolv.conf in pods:
    nameserver 10.96.0.10        # CoreDNS ClusterIP
    search default.svc.cluster.local svc.cluster.local cluster.local
    options ndots:5

DNS RECORDS:
  # Service (ClusterIP)
  my-svc.my-ns.svc.cluster.local → 10.96.X.X

  # Headless Service (endpoints)
  my-svc.my-ns.svc.cluster.local → [Pod IPs]

  # SRV records
  _http._tcp.my-svc.my-ns.svc.cluster.local → port + hostname

  # Pod
  10-244-0-5.my-ns.pod.cluster.local → 10.244.0.5

  # ExternalName Service
  ext-svc.my-ns.svc.cluster.local → CNAME api.external.com

CUSTOMIZE COREDNS:
  kubectl -n kube-system edit configmap coredns

  # Add custom DNS entries
  apiVersion: v1
  kind: ConfigMap
  metadata:
    name: coredns
    namespace: kube-system
  data:
    Corefile: |
      .:53 {
          kubernetes cluster.local in-addr.arpa ip6.arpa {
              pods insecure
              fallthrough in-addr.arpa ip6.arpa
          }
          hosts {
              10.0.0.100 custom-host.example.com
              fallthrough
          }
          forward . /etc/resolv.conf
          cache 30
          loop
          reload
          loadbalance
      }

TROUBLESHOOTING K8S DNS:
  # Test DNS from a pod
  kubectl run dns-test --image=busybox --rm -it -- nslookup kubernetes.default
  kubectl run dns-test --image=busybox --rm -it -- nslookup my-service.my-namespace

  # Check CoreDNS pods
  kubectl -n kube-system get pods -l k8s-app=kube-dns
  kubectl -n kube-system logs -l k8s-app=kube-dns

  # Check CoreDNS config
  kubectl -n kube-system get configmap coredns -o yaml

  # Common issues:
  # - ndots:5 causes slow lookups → set dnsConfig in pod spec
  # - Loop detection → remove loop plugin or fix resolv.conf
  # - Pod can't resolve external → check forward plugin

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
CoreDNS - Cloud-Native DNS Server Reference

Commands:
  intro       Overview, comparison, install
  corefile    Configuration, zones, split DNS
  plugins     Forward, cache, rewrite, etcd, Prometheus
  kubernetes  K8s DNS, customization, troubleshooting

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  corefile)   cmd_corefile ;;
  plugins)    cmd_plugins ;;
  kubernetes) cmd_kubernetes ;;
  help|*)     show_help ;;
esac
