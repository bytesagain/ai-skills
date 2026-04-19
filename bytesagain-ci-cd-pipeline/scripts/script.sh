#!/usr/bin/env bash
# bytesagain-ci-cd-pipeline — CI/CD pipeline config generator
set -euo pipefail

CMD="${1:-help}"
shift || true

show_help() {
    echo "bytesagain-ci-cd-pipeline — Generate CI/CD pipeline configurations"
    echo ""
    echo "Usage:"
    echo "  bytesagain-ci-cd-pipeline github <stack>      GitHub Actions workflow"
    echo "  bytesagain-ci-cd-pipeline gitlab <stack>      GitLab CI config"
    echo "  bytesagain-ci-cd-pipeline jenkins <stack>     Jenkinsfile"
    echo "  bytesagain-ci-cd-pipeline checklist           Pre-deploy checklist"
    echo "  bytesagain-ci-cd-pipeline rollback <type>     Rollback strategy"
    echo ""
    echo "Stacks: node, python, go, docker, k8s"
    echo ""
}

cmd_github() {
    local stack="${1:-node}"
    CI_STACK="$stack" python3 << 'PYEOF'
import os; stack = os.environ.get("CI_STACK","node")

configs = {
    "node": """name: Node.js CI/CD

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18.x, 20.x]
    steps:
      - uses: actions/checkout@v4
      - name: Use Node.js \${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: \${{ matrix.node-version }}
          cache: 'npm'
      - run: npm ci
      - run: npm run lint
      - run: npm test
      - run: npm run build --if-present

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - name: Deploy to production
        env:
          DEPLOY_KEY: \${{ secrets.DEPLOY_KEY }}
        run: |
          echo "Add your deploy script here"
          # ssh user@server 'cd /app && git pull && pm2 restart all'
""",
    "python": """name: Python CI/CD

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.10", "3.11", "3.12"]
    steps:
      - uses: actions/checkout@v4
      - name: Set up Python \${{ matrix.python-version }}
        uses: actions/setup-python@v5
        with:
          python-version: \${{ matrix.python-version }}
      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt
          pip install pytest flake8
      - name: Lint with flake8
        run: flake8 . --max-line-length=88
      - name: Test with pytest
        run: pytest --tb=short

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - name: Deploy
        run: echo "Add your deploy steps here"
""",
    "go": """name: Go CI/CD

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Go
        uses: actions/setup-go@v5
        with:
          go-version: '1.21'
      - name: Build
        run: go build -v ./...
      - name: Test
        run: go test -v -race -coverprofile=coverage.out ./...
      - name: Vet
        run: go vet ./...
      - name: Upload binary
        uses: actions/upload-artifact@v4
        with:
          name: binary
          path: ./bin/
""",
    "docker": """name: Docker Build & Push

on:
  push:
    branches: [ main ]
    tags: [ 'v*.*.*' ]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: \${{ github.repository }}

jobs:
  build-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    steps:
      - uses: actions/checkout@v4
      - name: Log in to Container Registry
        uses: docker/login-action@v3
        with:
          registry: \${{ env.REGISTRY }}
          username: \${{ github.actor }}
          password: \${{ secrets.GITHUB_TOKEN }}
      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: \${{ env.REGISTRY }}/\${{ env.IMAGE_NAME }}
      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: \${{ steps.meta.outputs.tags }}
          labels: \${{ steps.meta.outputs.labels }}
""",
    "k8s": """name: Kubernetes Deploy

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up kubectl
        uses: azure/setup-kubectl@v3
      - name: Configure kubeconfig
        env:
          KUBE_CONFIG: \${{ secrets.KUBE_CONFIG }}
        run: |
          mkdir -p ~/.kube
          echo "\$KUBE_CONFIG" | base64 -d > ~/.kube/config
      - name: Deploy to Kubernetes
        run: |
          kubectl set image deployment/app app=\${{ env.IMAGE }}:latest
          kubectl rollout status deployment/app --timeout=120s
      - name: Verify deployment
        run: kubectl get pods -l app=myapp
"""
}

config = configs.get(stack, configs["node"])
print(f"# GitHub Actions — {stack.title()} Pipeline")
print(f"# Save as: .github/workflows/ci.yml\n")
print(config)
PYEOF
}

cmd_gitlab() {
    local stack="${1:-node}"
    CI_STACK="$stack" python3 << 'PYEOF'
import os; stack = os.environ.get("CI_STACK","node")
print(f"""# GitLab CI/CD — {stack.title()} Pipeline
# Save as: .gitlab-ci.yml

stages:
  - test
  - build
  - deploy

variables:
  DOCKER_DRIVER: overlay2

cache:
  key: \$CI_COMMIT_REF_SLUG
  paths:
    - node_modules/   # adjust for your stack

test:
  stage: test
  image: node:20-alpine   # adjust image for your stack
  script:
    - npm ci
    - npm run lint
    - npm test
  coverage: '/Statements.*?(\\d+(?:\\.\\d+)?)%/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml

build:
  stage: build
  script:
    - npm run build
  artifacts:
    paths:
      - dist/
  only:
    - main

deploy_production:
  stage: deploy
  script:
    - echo "Deploy to production"
    # - ssh \$DEPLOY_USER@\$DEPLOY_HOST "cd /app && git pull && pm2 restart all"
  environment:
    name: production
    url: https://your-domain.com
  only:
    - main
  when: manual   # require manual approval
""")
PYEOF
}

cmd_jenkins() {
    CI_STACK="$stack" python3 << 'PYEOF'
print("""// Jenkinsfile — Declarative Pipeline
// Place in repo root

pipeline {
    agent any
    
    environment {
        NODE_VERSION = '20'
        DEPLOY_ENV = 'production'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Install') {
            steps {
                sh 'npm ci'
            }
        }
        
        stage('Lint') {
            steps {
                sh 'npm run lint'
            }
        }
        
        stage('Test') {
            steps {
                sh 'npm test'
            }
            post {
                always {
                    junit 'test-results/**/*.xml'
                }
            }
        }
        
        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }
        
        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Deploy to production?', ok: 'Deploy'
                sh './scripts/deploy.sh'
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline succeeded!'
            // slackSend color: 'good', message: "Build succeeded: ${env.JOB_NAME}"
        }
        failure {
            echo 'Pipeline failed!'
            // slackSend color: 'danger', message: "Build failed: ${env.JOB_NAME}"
        }
    }
}
""")
PYEOF
}

cmd_checklist() {
    echo "=== Pre-Deploy Checklist ==="
    echo ""
    echo "Code Quality"
    echo "  [ ] All tests passing (unit + integration)"
    echo "  [ ] Code review approved"
    echo "  [ ] No high-severity linting errors"
    echo "  [ ] Dependencies updated and audited"
    echo ""
    echo "Configuration"
    echo "  [ ] Environment variables set in target env"
    echo "  [ ] Database migrations prepared"
    echo "  [ ] Feature flags configured"
    echo "  [ ] API keys and secrets rotated if needed"
    echo ""
    echo "Infrastructure"
    echo "  [ ] Sufficient capacity in target environment"
    echo "  [ ] Backup taken before deploy"
    echo "  [ ] Rollback plan documented"
    echo "  [ ] Monitoring/alerting in place"
    echo ""
    echo "Communication"
    echo "  [ ] Stakeholders notified of deploy window"
    echo "  [ ] On-call engineer assigned"
    echo "  [ ] Incident runbook accessible"
    echo ""
    echo "Post-Deploy"
    echo "  [ ] Health checks passing"
    echo "  [ ] Error rates normal"
    echo "  [ ] Key metrics within expected range"
    echo "  [ ] Smoke tests passed"
}

cmd_rollback() {
    local type="${1:-blue-green}"
    CI_STACK="$stack" CI_RTYPE="$type" python3 << 'PYEOF'
import os; rtype = os.environ.get("CI_RTYPE","blue-green")
strategies = {
    "blue-green": """
Blue-Green Rollback Strategy
=============================
Setup: Two identical environments (blue=current, green=new)

Rollback Steps:
  1. Detect issue in green environment
  2. Switch load balancer back to blue:
     kubectl patch service myapp -p '{"spec":{"selector":{"version":"blue"}}}'
  3. Verify blue is serving traffic:
     curl https://myapp.com/health
  4. Keep green running for debugging
  5. Root cause analysis before next deploy

Recovery Time: < 60 seconds (just DNS/LB switch)
""",
    "canary": """
Canary Rollback Strategy
=========================
Setup: Small % of traffic to new version, rest to stable

Rollback Steps:
  1. Detect elevated error rate in canary
  2. Route 0% traffic to canary:
     kubectl set weight canary 0 --service=myapp
  3. Keep canary pods for debugging
  4. Full rollback:
     kubectl rollout undo deployment/myapp
  5. Verify stable version handling all traffic

Recovery Time: 2-5 minutes
""",
    "rolling": """
Rolling Update Rollback Strategy
==================================
Default Kubernetes strategy

Rollback Steps:
  1. Detect issue during or after rolling update
  2. Immediate rollback:
     kubectl rollout undo deployment/myapp
  3. Check rollback status:
     kubectl rollout status deployment/myapp
  4. Verify with:
     kubectl get pods
     kubectl describe deployment myapp
  5. View rollback history:
     kubectl rollout history deployment/myapp

Recovery Time: 3-10 minutes (depends on pod count)
"""
}
print(strategies.get(rtype, strategies["rolling"]))
print("Available types: blue-green, canary, rolling")
PYEOF
}

case "$CMD" in
    github)    cmd_github "$@" ;;
    gitlab)    cmd_gitlab "$@" ;;
    jenkins)   cmd_jenkins ;;
    checklist) cmd_checklist ;;
    rollback)  cmd_rollback "$@" ;;
    help|--help|-h) show_help ;;
    *) echo "Unknown: $CMD"; show_help; exit 1 ;;
esac
