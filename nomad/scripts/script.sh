#!/bin/bash
# Nomad - Workload Orchestrator Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              NOMAD REFERENCE                                ║
║          Simple, Flexible Workload Orchestrator             ║
╚══════════════════════════════════════════════════════════════╝

HashiCorp Nomad is a workload orchestrator that deploys and
manages containers, binaries, VMs, and batch jobs. Simpler
than Kubernetes, handles more workload types.

KEY FEATURES:
  Multi-workload   Containers, binaries, JVM, VMs, batch
  Simple           Single binary, no etcd/external deps
  Scalable         Tested to 10,000+ nodes
  Multi-region     Built-in federation across datacenters
  Task drivers     Docker, exec, Java, QEMU, containerd
  Integrations     Consul (service mesh), Vault (secrets)
  Bin packing      Efficient resource utilization
  Batch & system   Not just services — batch jobs, system daemons

NOMAD vs KUBERNETES:
  ┌──────────────┬──────────┬──────────┐
  │ Feature      │ Nomad    │ K8s      │
  ├──────────────┼──────────┼──────────┤
  │ Complexity   │ Simple   │ Complex  │
  │ Workloads    │ All types│ Containers│
  │ Setup        │ 1 binary │ Many     │
  │ Dependencies │ None     │ etcd+    │
  │ Learning     │ Days     │ Months   │
  │ Federation   │ Built-in │ Complex  │
  │ Ecosystem    │ HashiCorp│ Massive  │
  │ Adoption     │ Growing  │ Standard │
  └──────────────┴──────────┴──────────┘

INSTALL:
  # Binary
  curl -fsSL https://releases.hashicorp.com/nomad/1.7.5/nomad_1.7.5_linux_amd64.zip -o nomad.zip
  unzip nomad.zip && sudo mv nomad /usr/local/bin/

  # Dev mode
  nomad agent -dev
EOF
}

cmd_jobs() {
cat << 'EOF'
JOB SPECIFICATIONS
====================

BASIC JOB (web service):
  job "webapp" {
    datacenters = ["dc1"]
    type = "service"

    group "web" {
      count = 3

      network {
        port "http" { to = 8080 }
      }

      service {
        name = "webapp"
        port = "http"
        check {
          type     = "http"
          path     = "/health"
          interval = "10s"
          timeout  = "2s"
        }
      }

      task "app" {
        driver = "docker"
        config {
          image = "myapp:v1.2"
          ports = ["http"]
        }
        resources {
          cpu    = 500   # MHz
          memory = 256   # MB
        }
        env {
          PORT = "${NOMAD_PORT_http}"
        }
      }
    }
  }

BATCH JOB:
  job "etl" {
    type = "batch"
    periodic {
      cron = "0 * * * *"    # Every hour
      time_zone = "UTC"
    }
    group "process" {
      task "transform" {
        driver = "docker"
        config {
          image = "etl-pipeline:latest"
          args  = ["--date", "${NOMAD_META_date}"]
        }
        resources {
          cpu    = 2000
          memory = 1024
        }
      }
    }
  }

SYSTEM JOB (runs on every node):
  job "monitoring" {
    type = "system"
    group "agents" {
      task "node-exporter" {
        driver = "docker"
        config {
          image = "prom/node-exporter"
          network_mode = "host"
        }
      }
    }
  }

CANARY DEPLOYMENT:
  group "web" {
    count = 5
    update {
      max_parallel     = 1
      canary           = 1
      min_healthy_time = "30s"
      healthy_deadline = "5m"
      auto_revert      = true
      auto_promote     = false  # Manual promotion
    }
  }

VAULT SECRETS:
  task "app" {
    vault { policies = ["webapp"] }
    template {
      data = <<EOF
DB_PASSWORD={{ with secret "secret/data/db" }}{{ .Data.data.password }}{{ end }}
EOF
      destination = "secrets/env"
      env         = true
    }
  }
EOF
}

cmd_ops() {
cat << 'EOF'
OPERATIONS & CLI
==================

CLI:
  nomad job run webapp.nomad        # Deploy job
  nomad job plan webapp.nomad       # Dry-run (show changes)
  nomad job stop webapp             # Stop job
  nomad job status webapp           # Job status
  nomad job deployments webapp      # Deployment history

  nomad alloc status <alloc-id>     # Allocation details
  nomad alloc logs <alloc-id>       # Container/task logs
  nomad alloc exec <alloc-id> /bin/sh  # Shell into alloc

  nomad node status                 # Cluster nodes
  nomad server members              # Server cluster

  nomad deployment promote <id>     # Promote canary
  nomad job scale webapp web 5      # Scale to 5

  nomad operator raft list-peers    # Raft cluster peers
  nomad operator snapshot save backup.snap  # Backup state

CLUSTER SETUP:
  # Server config (server.hcl)
  datacenter = "dc1"
  data_dir   = "/opt/nomad/data"
  server {
    enabled          = true
    bootstrap_expect = 3    # Wait for 3 servers
  }

  # Client config (client.hcl)
  datacenter = "dc1"
  data_dir   = "/opt/nomad/data"
  client {
    enabled = true
    servers = ["server1:4647", "server2:4647", "server3:4647"]
  }

  # Start
  nomad agent -config=server.hcl
  nomad agent -config=client.hcl

CONSUL INTEGRATION:
  consul {
    address = "127.0.0.1:8500"
  }
  # Services auto-register in Consul
  # Consul Connect for service mesh

ACL:
  nomad acl bootstrap               # Get management token
  nomad acl policy apply dev dev.hcl
  nomad acl token create -name="ci" -policy="dev"

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Nomad - Workload Orchestrator Reference

Commands:
  intro    Overview, K8s comparison
  jobs     Service, batch, system jobs, canary, Vault
  ops      CLI, cluster setup, Consul, ACL

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro) cmd_intro ;;
  jobs)  cmd_jobs ;;
  ops)   cmd_ops ;;
  help|*) show_help ;;
esac
