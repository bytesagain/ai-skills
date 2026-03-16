#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# Benchmark Tool — command performance benchmarking (inspired by sharkdp/hyperfine 27K+ stars)
set -euo pipefail
CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in
    help)
        echo "Benchmark Tool — command & script performance testing"
        echo ""
        echo "Commands:"
        echo "  run <cmd>             Benchmark a command (10 runs)"
        echo "  compare <c1> <c2>     Compare two commands"
        echo "  script <file>         Benchmark a script"
        echo "  http <url>            HTTP endpoint benchmark"
        echo "  disk [path]           Disk I/O benchmark"
        echo "  cpu                   CPU benchmark"
        echo "  memory                Memory benchmark"
        echo "  system                Full system benchmark"
        echo "  info                  Version info"
        echo ""
        echo "Powered by BytesAgain | bytesagain.com"
        ;;
    run)
        cmd="$*"
        [ -z "$cmd" ] && { echo "Usage: run <command>"; exit 1; }
        python3 << PYEOF
import subprocess, time, statistics
cmd = """$cmd"""
runs = 10
times = []
print("Benchmarking: {}".format(cmd))
print("Runs: {}".format(runs))
print("")
for i in range(runs):
    start = time.time()
    try:
        subprocess.run(cmd, shell=True, capture_output=True, timeout=30)
    except subprocess.TimeoutExpired:
        print("  Run {}: TIMEOUT (>30s)".format(i+1))
        continue
    elapsed = time.time() - start
    times.append(elapsed)
    print("  Run {:>2d}: {:.3f}s".format(i+1, elapsed))
if times:
    print("")
    print("Results:")
    print("  Mean:   {:.3f}s".format(statistics.mean(times)))
    print("  Median: {:.3f}s".format(statistics.median(times)))
    print("  Min:    {:.3f}s".format(min(times)))
    print("  Max:    {:.3f}s".format(max(times)))
    if len(times) > 1:
        print("  StdDev: {:.3f}s".format(statistics.stdev(times)))
PYEOF
        ;;
    compare)
        cmd1="${1:-}"; cmd2="${2:-}"
        [ -z "$cmd1" ] || [ -z "$cmd2" ] && { echo "Usage: compare <cmd1> <cmd2>"; exit 1; }
        python3 << PYEOF
import subprocess, time, statistics
cmds = ["""$cmd1""", """$cmd2"""]
results = {}
runs = 5
for cmd in cmds:
    times = []
    for i in range(runs):
        start = time.time()
        try:
            subprocess.run(cmd, shell=True, capture_output=True, timeout=30)
        except:
            continue
        times.append(time.time() - start)
    results[cmd] = times
print("Comparison ({} runs each):".format(runs))
print("")
for cmd, times in results.items():
    if times:
        avg = statistics.mean(times)
        print("  {}: {:.3f}s avg ({:.3f}-{:.3f})".format(cmd[:40], avg, min(times), max(times)))
    else:
        print("  {}: FAILED".format(cmd[:40]))
vals = list(results.values())
if len(vals) == 2 and vals[0] and vals[1]:
    a, b = statistics.mean(vals[0]), statistics.mean(vals[1])
    if b > 0:
        ratio = a / b
        faster = cmds[0] if a < b else cmds[1]
        print("\n  {} is {:.1f}x faster".format(faster[:40], max(ratio, 1/ratio)))
PYEOF
        ;;
    script)
        file="${1:-}"
        [ -z "$file" ] && { echo "Usage: script <file>"; exit 1; }
        [ ! -f "$file" ] && { echo "File not found: $file"; exit 1; }
        bash "$0" run "bash $file"
        ;;
    http)
        url="${1:-}"
        [ -z "$url" ] && { echo "Usage: http <url>"; exit 1; }
        python3 << PYEOF
import time
try:
    from urllib.request import urlopen, Request
except:
    from urllib2 import urlopen, Request
url = "$url"
runs = 10
times = []
codes = []
print("HTTP Benchmark: {}".format(url))
print("Runs: {}".format(runs))
print("")
for i in range(runs):
    start = time.time()
    try:
        resp = urlopen(Request(url, headers={"User-Agent": "BenchmarkTool/1.0"}), timeout=10)
        code = resp.getcode()
        resp.read()
    except Exception as e:
        code = str(e)[:20]
    elapsed = time.time() - start
    times.append(elapsed)
    codes.append(code)
    print("  {:>2d}: {:.3f}s [{}]".format(i+1, elapsed, code))
import statistics
print("")
print("Results:")
print("  Mean:    {:.3f}s".format(statistics.mean(times)))
print("  Median:  {:.3f}s".format(statistics.median(times)))
print("  Min:     {:.3f}s".format(min(times)))
print("  Max:     {:.3f}s".format(max(times)))
print("  Success: {}/{}".format(sum(1 for c in codes if c==200), runs))
PYEOF
        ;;
    disk)
        path="${1:-/tmp}"
        python3 << PYEOF
import time, os, tempfile
path = "$path"
print("Disk I/O Benchmark: {}".format(path))
print("")
# Write test
data = b"x" * 1048576  # 1MB
start = time.time()
for i in range(100):
    fp = os.path.join(path, "_bench_{}".format(i))
    with open(fp, "wb") as f:
        f.write(data)
write_time = time.time() - start
# Read test
start = time.time()
for i in range(100):
    fp = os.path.join(path, "_bench_{}".format(i))
    with open(fp, "rb") as f:
        f.read()
read_time = time.time() - start
# Cleanup
for i in range(100):
    try: os.remove(os.path.join(path, "_bench_{}".format(i)))
    except: pass
print("  Write: {:.1f} MB/s (100 MB in {:.2f}s)".format(100/write_time, write_time))
print("  Read:  {:.1f} MB/s (100 MB in {:.2f}s)".format(100/read_time, read_time))
PYEOF
        ;;
    cpu)
        python3 << 'PYEOF'
import time
print("CPU Benchmark:")
# Integer
start = time.time()
x = 0
for i in range(10000000): x += i
int_time = time.time() - start
# Float
start = time.time()
x = 1.0
for i in range(5000000): x = x * 1.000001 + 0.000001
float_time = time.time() - start
# Prime
start = time.time()
primes = []
for n in range(2, 50000):
    is_p = True
    for d in range(2, int(n**0.5)+1):
        if n % d == 0: is_p = False; break
    if is_p: primes.append(n)
prime_time = time.time() - start
print("  Integer (10M ops):  {:.2f}s".format(int_time))
print("  Float (5M ops):     {:.2f}s".format(float_time))
print("  Primes (<50K):      {:.2f}s ({} found)".format(prime_time, len(primes)))
print("  Total:              {:.2f}s".format(int_time+float_time+prime_time))
PYEOF
        ;;
    memory)
        python3 << 'PYEOF'
import time
print("Memory Benchmark:")
# Allocation
start = time.time()
data = [bytearray(1024) for _ in range(100000)]  # 100MB
alloc_time = time.time() - start
# Access
start = time.time()
for d in data: d[0] = 1
access_time = time.time() - start
del data
print("  Alloc 100MB:   {:.3f}s".format(alloc_time))
print("  Access 100K:   {:.3f}s".format(access_time))
PYEOF
        ;;
    system)
        echo "Full System Benchmark"
        echo "====================="
        bash "$0" cpu
        echo ""
        bash "$0" memory
        echo ""
        bash "$0" disk /tmp
        ;;
    info)
        echo "Benchmark Tool v1.0.0"
        echo "Inspired by: sharkdp/hyperfine (27,000+ GitHub stars)"
        echo "Powered by BytesAgain | bytesagain.com"
        ;;
    *)
        echo "Unknown: $CMD — run 'help' for usage"; exit 1
        ;;
esac
