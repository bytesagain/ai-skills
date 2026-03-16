#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# Docker Analyzer — Docker image & container analysis (inspired by wagoodman/dive 53K+ stars)
set -euo pipefail
CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in
    help)
        echo "Docker Analyzer — image inspection & optimization"
        echo ""
        echo "Commands:"
        echo "  images               List all images with sizes"
        echo "  containers           List running containers"
        echo "  inspect <image>      Detailed image info"
        echo "  layers <image>       Show image layers"
        echo "  history <image>      Build history"
        echo "  size-report          Disk usage report"
        echo "  optimize <image>     Optimization suggestions"
        echo "  cleanup              Find removable items"
        echo "  compose-check [f]    Validate docker-compose"
        echo "  info                 Version info"
        echo ""
        echo "Powered by BytesAgain | bytesagain.com"
        ;;
    images)
        python3 << 'PYEOF'
import subprocess, json
try:
    out = subprocess.check_output(["docker", "images", "--format", "{{json .}}"], stderr=subprocess.STDOUT).decode()
    images = [json.loads(l) for l in out.strip().split("\n") if l.strip()]
    print("{:30s} {:15s} {:>10s} {:15s}".format("REPOSITORY", "TAG", "SIZE", "CREATED"))
    print("-" * 75)
    total = 0
    for img in sorted(images, key=lambda x: x.get("Repository","")):
        print("{:30s} {:15s} {:>10s} {:15s}".format(
            img.get("Repository","?")[:30], img.get("Tag","?")[:15],
            img.get("Size","?"), img.get("CreatedSince","?")))
    print("\nTotal: {} images".format(len(images)))
except FileNotFoundError:
    print("Docker not installed or not in PATH")
except subprocess.CalledProcessError as e:
    print("Docker error: {}".format(e.output.decode()[:100]))
PYEOF
        ;;
    containers)
        python3 << 'PYEOF'
import subprocess, json
try:
    out = subprocess.check_output(["docker", "ps", "-a", "--format", "{{json .}}"], stderr=subprocess.STDOUT).decode()
    containers = [json.loads(l) for l in out.strip().split("\n") if l.strip()]
    print("{:15s} {:25s} {:10s} {:15s} {:15s}".format("ID", "IMAGE", "STATUS", "PORTS", "NAMES"))
    print("-" * 85)
    for c in containers:
        print("{:15s} {:25s} {:10s} {:15s} {:15s}".format(
            c.get("ID","?")[:15], c.get("Image","?")[:25],
            c.get("State","?")[:10], c.get("Ports","")[:15], c.get("Names","?")[:15]))
    print("\nTotal: {} containers".format(len(containers)))
except FileNotFoundError:
    print("Docker not installed")
except subprocess.CalledProcessError as e:
    print("Error: {}".format(e.output.decode()[:100]))
PYEOF
        ;;
    inspect)
        image="${1:-}"
        [ -z "$image" ] && { echo "Usage: inspect <image>"; exit 1; }
        docker inspect "$image" 2>/dev/null | python3 -c "
import json, sys
d = json.load(sys.stdin)[0]
config = d.get('Config', {})
print('Image: {}'.format(d.get('RepoTags', ['?'])[0]))
print('ID: {}'.format(d.get('Id', '?')[:20]))
print('Created: {}'.format(d.get('Created', '?')[:19]))
print('Size: {:.1f} MB'.format(d.get('Size', 0) / 1048576))
print('OS/Arch: {}/{}'.format(d.get('Os','?'), d.get('Architecture','?')))
print('Entrypoint: {}'.format(config.get('Entrypoint', '?')))
print('Cmd: {}'.format(config.get('Cmd', '?')))
print('Env vars: {}'.format(len(config.get('Env', []))))
print('Exposed ports: {}'.format(list(config.get('ExposedPorts', {}).keys())))
print('Labels: {}'.format(len(config.get('Labels', {}))))
" || echo "Image not found: $image"
        ;;
    layers)
        image="${1:-}"
        [ -z "$image" ] && { echo "Usage: layers <image>"; exit 1; }
        docker history --no-trunc "$image" 2>/dev/null | head -30 || echo "Image not found"
        ;;
    history)
        image="${1:-}"
        [ -z "$image" ] && { echo "Usage: history <image>"; exit 1; }
        docker history "$image" 2>/dev/null || echo "Image not found"
        ;;
    size-report)
        docker system df 2>/dev/null || echo "Docker not available"
        ;;
    optimize)
        image="${1:-}"
        [ -z "$image" ] && { echo "Usage: optimize <image>"; exit 1; }
        python3 << PYEOF
import subprocess, json
image = "$image"
try:
    out = subprocess.check_output(["docker", "history", "--no-trunc", "--format", "{{json .}}", image], stderr=subprocess.STDOUT).decode()
    layers = [json.loads(l) for l in out.strip().split("\n") if l.strip()]
    suggestions = []
    run_count = 0
    copy_count = 0
    for l in layers:
        cmd = l.get("CreatedBy", "")
        if "RUN" in cmd: run_count += 1
        if "COPY" in cmd or "ADD" in cmd: copy_count += 1
        if "apt-get install" in cmd and "rm -rf /var/lib/apt" not in cmd:
            suggestions.append("Clean apt cache after install: add '&& rm -rf /var/lib/apt/lists/*'")
        if "pip install" in cmd and "--no-cache-dir" not in cmd:
            suggestions.append("Add --no-cache-dir to pip install")
    if run_count > 5:
        suggestions.append("Combine {} RUN commands to reduce layers".format(run_count))
    if not suggestions:
        suggestions.append("Image looks well-optimized!")
    print("Optimization Report: {}".format(image))
    print("  Layers: {}".format(len(layers)))
    print("  RUN commands: {}".format(run_count))
    print("  COPY/ADD: {}".format(copy_count))
    print("\nSuggestions:")
    for s in suggestions:
        print("  - {}".format(s))
except Exception as e:
    print("Error: {}".format(e))
PYEOF
        ;;
    cleanup)
        echo "Docker Cleanup Report:"
        echo ""
        echo "Dangling images:"
        docker images -f "dangling=true" -q 2>/dev/null | wc -l | xargs -I{} echo "  {} removable images"
        echo ""
        echo "Stopped containers:"
        docker ps -a -f "status=exited" -q 2>/dev/null | wc -l | xargs -I{} echo "  {} stopped containers"
        echo ""
        echo "To clean: docker system prune -a"
        ;;
    compose-check)
        file="${1:-docker-compose.yml}"
        [ ! -f "$file" ] && { echo "Not found: $file"; exit 1; }
        docker compose -f "$file" config --quiet 2>&1 && echo "✅ Valid: $file" || echo "❌ Invalid"
        ;;
    info)
        echo "Docker Analyzer v1.0.0"
        echo "Inspired by: wagoodman/dive (53,000+ GitHub stars)"
        echo "Powered by BytesAgain | bytesagain.com"
        ;;
    *)
        echo "Unknown: $CMD — run 'help' for usage"; exit 1
        ;;
esac
