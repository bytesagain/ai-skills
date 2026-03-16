#!/usr/bin/env bash
# GitHub Actions Workflow Generator
# Usage: bash main.sh --type <type> --lang <language> [options]
set -euo pipefail

TYPE=""
LANG_TARGET=""
DEPLOY_TARGET=""
INCLUDE_CACHE="true"
INCLUDE_MATRIX="false"
NODE_VERSIONS=""
PYTHON_VERSIONS=""
OUTPUT=""

show_help() {
    cat << 'HELPEOF'
GitHub Actions Workflow Generator — Create CI/CD pipelines

Usage: bash main.sh --type <type> --lang <lang> [options]

Options:
  --type <type>       Workflow type: ci, cd, test, lint, release, docker, terraform
  --lang <lang>       Language: node, python, go, java, rust, docker, terraform
  --deploy <target>   Deploy target: aws, gcp, vercel, netlify, docker-hub, ghcr
  --matrix            Enable matrix testing (multiple versions)
  --no-cache          Disable dependency caching
  --output <file>     Output file (default: stdout)
  --help              Show this help

Examples:
  bash main.sh --type ci --lang node
  bash main.sh --type ci --lang python --matrix
  bash main.sh --type cd --lang docker --deploy docker-hub
  bash main.sh --type release --lang node
  bash main.sh --type terraform

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --type) TYPE="$2"; shift 2;;
        --lang) LANG_TARGET="$2"; shift 2;;
        --deploy) DEPLOY_TARGET="$2"; shift 2;;
        --matrix) INCLUDE_MATRIX="true"; shift;;
        --no-cache) INCLUDE_CACHE="false"; shift;;
        --output) OUTPUT="$2"; shift 2;;
        --help|-h) show_help; exit 0;;
        *) echo "Unknown: $1"; show_help; exit 1;;
    esac
done

[ -z "$TYPE" ] && { echo "Error: --type required"; show_help; exit 1; }

generate_workflow() {
    python3 << PYEOF
import sys

wtype = "$TYPE"
lang = "$LANG_TARGET"
deploy = "$DEPLOY_TARGET"
matrix = "$INCLUDE_MATRIX" == "true"
cache = "$INCLUDE_CACHE" == "true"

def node_ci():
    versions = "['18', '20', '22']" if matrix else ""
    out = """name: CI
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest"""
    if matrix:
        out += """
    strategy:
      matrix:
        node-version: [18, 20, 22]"""
    out += """
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: {}""".format("\\${{{{ matrix.node-version }}}}" if matrix else "20")
    if cache:
        out += """
          cache: 'npm'"""
    out += """
      - run: npm ci
      - run: npm run lint --if-present
      - run: npm test
      - run: npm run build --if-present"""
    return out

def python_ci():
    out = """name: CI
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest"""
    if matrix:
        out += """
    strategy:
      matrix:
        python-version: ['3.10', '3.11', '3.12']"""
    out += """
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: {}""".format("\\${{{{ matrix.python-version }}}}" if matrix else "'3.12'")
    if cache:
        out += """
          cache: 'pip'"""
    out += """
      - run: pip install -r requirements.txt
      - run: pip install pytest flake8
      - run: flake8 . --count --select=E9,F63,F7,F82 --show-source
      - run: pytest --tb=short"""
    return out

def go_ci():
    out = """name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-go@v5
        with:
          go-version: '1.22'
      - run: go mod download
      - run: go vet ./...
      - run: go test -race -coverprofile=coverage.out ./...
      - run: go build -v ./..."""
    return out

def docker_cd():
    registry = {
        "docker-hub": ("docker.io", "DOCKERHUB_USERNAME", "DOCKERHUB_TOKEN"),
        "ghcr": ("ghcr.io", "GITHUB_ACTOR", "GITHUB_TOKEN"),
    }.get(deploy, ("ghcr.io", "GITHUB_ACTOR", "GITHUB_TOKEN"))
    
    out = """name: Build & Push Docker
on:
  push:
    branches: [main]
    tags: ['v*']

env:
  REGISTRY: {registry}
  IMAGE_NAME: ${{{{github.repository}}}}

jobs:
  build-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    steps:
      - uses: actions/checkout@v4
      - uses: docker/setup-buildx-action@v3
      - uses: docker/login-action@v3
        with:
          registry: {registry}
          username: ${{{{secrets.{user}}}}}
          password: ${{{{secrets.{token}}}}}
      - uses: docker/metadata-action@v5
        id: meta
        with:
          images: {registry}/${{{{github.repository}}}}
          tags: |
            type=ref,event=branch
            type=semver,pattern={{{{version}}}}
            type=sha
      - uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{{{steps.meta.outputs.tags}}}}
          labels: ${{{{steps.meta.outputs.labels}}}}
          cache-from: type=gha
          cache-to: type=gha,mode=max""".format(
        registry=registry[0], user=registry[1], token=registry[2])
    return out

def release():
    out = """name: Release
on:
  push:
    tags: ['v*']

permissions:
  contents: write

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: Generate changelog
        id: changelog
        run: |
          echo "## Changes" > changelog.md
          git log $(git describe --tags --abbrev=0 HEAD^)..HEAD --oneline >> changelog.md
      - uses: softprops/action-gh-release@v1
        with:
          body_path: changelog.md
          generate_release_notes: true"""
    return out

def terraform():
    out = """name: Terraform
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

permissions:
  contents: read
  pull-requests: write

jobs:
  terraform:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: ./terraform
    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.7.0
      - name: Terraform Init
        run: terraform init
      - name: Terraform Format
        run: terraform fmt -check
      - name: Terraform Plan
        run: terraform plan -no-color
        continue-on-error: true
      - name: Terraform Apply
        if: github.ref == 'refs/heads/main' && github.event_name == 'push'
        run: terraform apply -auto-approve"""
    return out

generators = {
    ("ci", "node"): node_ci,
    ("ci", "python"): python_ci,
    ("ci", "go"): go_ci,
    ("cd", "docker"): docker_cd,
    ("release", ""): release,
    ("release", "node"): release,
    ("terraform", ""): terraform,
    ("terraform", "terraform"): terraform,
}

key = (wtype, lang)
if key not in generators:
    key = (wtype, "")
    if key not in generators:
        print("# Error: No template for type='{}' lang='{}'".format(wtype, lang))
        print("# Available: ci(node/python/go), cd(docker), release, terraform")
        sys.exit(1)

workflow = generators[key]()
print("# Generated by GitHub Actions Generator (BytesAgain)")
print(workflow)
PYEOF
}

output_content() {
    echo "# GitHub Actions Workflow"
    echo "# Type: $TYPE | Language: $LANG_TARGET"
    echo ""
    echo '```yaml'
    generate_workflow
    echo '```'
    echo ""
    echo "---"
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

if [ -n "$OUTPUT" ]; then
    output_content > "$OUTPUT"
    echo "Saved to $OUTPUT"
else
    output_content
fi
