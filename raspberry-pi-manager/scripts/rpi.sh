#!/usr/bin/env bash
# Raspberry Pi Manager — Monitor and manage Raspberry Pi systems
# Usage: bash rpi.sh <command> [options]
set -euo pipefail

COMMAND="${1:-help}"
shift 2>/dev/null || true

RPI_HOST="${RPI_HOST:-}"
RPI_USER="${RPI_USER:-pi}"
DATA_DIR="${HOME}/.rpi-manager"
mkdir -p "$DATA_DIR"

_ssh() {
  if [ -n "$RPI_HOST" ]; then
    ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no "${RPI_USER}@${RPI_HOST}" "$@"
  else
    # Local execution (for when running on the Pi itself)
    eval "$@"
  fi
}

case "$COMMAND" in
  status)
    python3 << 'PYEOF'
import os, sys, json, time, subprocess

rpi_host = os.environ.get("RPI_HOST", "")
rpi_user = os.environ.get("RPI_USER", "pi")

def run_cmd(cmd):
    if rpi_host:
        full_cmd = "ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no {}@{} '{}'".format(rpi_user, rpi_host, cmd)
    else:
        full_cmd = cmd
    try:
        result = subprocess.check_output(full_cmd, shell=True, stderr=subprocess.STDOUT)
        return result.decode("utf-8", errors="replace").strip()
    except subprocess.CalledProcessError:
        return ""
    except Exception:
        return ""

# Check if we can detect Pi
is_pi = False
model = run_cmd("cat /proc/device-tree/model 2>/dev/null || cat /sys/firmware/devicetree/base/model 2>/dev/null")
if "Raspberry Pi" in model or not rpi_host:
    is_pi = True

if not model and not rpi_host:
    model = "Unknown (not a Raspberry Pi or remote host not set)"

print("=" * 60)
print("RASPBERRY PI STATUS")
print("=" * 60)
print("")
print("Model: {}".format(model or "N/A"))

if rpi_host:
    print("Host: {}@{}".format(rpi_user, rpi_host))
else:
    print("Mode: Local")

# CPU Temperature
temp = run_cmd("cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null")
if temp:
    try:
        temp_c = int(temp) / 1000.0
        temp_f = temp_c * 9/5 + 32
        warn = " ⚠️ HIGH!" if temp_c > 70 else " 🔥" if temp_c > 60 else ""
        print("")
        print("🌡️ Temperature: {:.1f}°C / {:.1f}°F{}".format(temp_c, temp_f, warn))
    except ValueError:
        pass

# CPU Usage
cpu = run_cmd("top -bn1 | head -3 | tail -1")
if cpu:
    print("")
    print("💻 CPU: {}".format(cpu.strip()))

# CPU frequency
freq = run_cmd("cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 2>/dev/null")
if freq:
    try:
        freq_mhz = int(freq) / 1000
        print("   Frequency: {:.0f} MHz".format(freq_mhz))
    except ValueError:
        pass

# Memory
mem = run_cmd("free -m | grep Mem")
if mem:
    parts = mem.split()
    if len(parts) >= 3:
        total = int(parts[1])
        used = int(parts[2])
        pct = (used / total * 100) if total > 0 else 0
        bar_len = int(pct / 5)
        bar = "█" * bar_len + "░" * (20 - bar_len)
        print("")
        print("🧠 Memory: [{}] {:.0f}%".format(bar, pct))
        print("   {} MB used / {} MB total".format(used, total))

# Disk
disk = run_cmd("df -h / | tail -1")
if disk:
    parts = disk.split()
    if len(parts) >= 5:
        print("")
        print("💾 Disk: {} used / {} total ({}%)".format(parts[2], parts[1], parts[4].replace("%", "")))

# Uptime
uptime = run_cmd("uptime -p 2>/dev/null || uptime")
if uptime:
    print("")
    print("⏱️ Uptime: {}".format(uptime.replace("up ", "")))

# Network
ip_addr = run_cmd("hostname -I 2>/dev/null")
hostname = run_cmd("hostname 2>/dev/null")
if ip_addr:
    print("")
    print("🌐 Network:")
    print("   Hostname: {}".format(hostname))
    print("   IP: {}".format(ip_addr.strip()))

# GPU Memory (Pi-specific)
gpu_mem = run_cmd("vcgencmd get_mem gpu 2>/dev/null")
if gpu_mem:
    print("")
    print("🎮 GPU Memory: {}".format(gpu_mem.replace("gpu=", "")))

# Throttle status
throttle = run_cmd("vcgencmd get_throttled 2>/dev/null")
if throttle:
    throttle_val = throttle.split("=")[-1] if "=" in throttle else ""
    if throttle_val == "0x0":
        print("✅ No throttling detected")
    else:
        print("⚠️ Throttling: {} (check power supply!)".format(throttle_val))

# OS info
os_info = run_cmd("cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d'\"' -f2")
kernel = run_cmd("uname -r 2>/dev/null")
print("")
print("📦 OS: {}".format(os_info or "Unknown"))
print("   Kernel: {}".format(kernel or "Unknown"))
PYEOF
    ;;

  gpio)
    ACTION="${1:-list}"
    PIN="${2:-}"
    VALUE="${3:-}"
    
    python3 << 'PYEOF'
import sys, os, subprocess

action = sys.argv[1] if len(sys.argv) > 1 else "list"
pin = sys.argv[2] if len(sys.argv) > 2 else ""
value = sys.argv[3] if len(sys.argv) > 3 else ""

rpi_host = os.environ.get("RPI_HOST", "")
rpi_user = os.environ.get("RPI_USER", "pi")

def run_cmd(cmd):
    if rpi_host:
        full_cmd = "ssh -o ConnectTimeout=5 {}@{} '{}'".format(rpi_user, rpi_host, cmd)
    else:
        full_cmd = cmd
    try:
        return subprocess.check_output(full_cmd, shell=True, stderr=subprocess.STDOUT).decode("utf-8").strip()
    except Exception as e:
        return "Error: {}".format(str(e))

if action == "list":
    print("=" * 55)
    print("GPIO PIN REFERENCE (Raspberry Pi)")
    print("=" * 55)
    print("")
    print("Physical Pin Layout (40-pin header):")
    print("")
    pins = [
        ("3V3", 1, 2, "5V"),
        ("GPIO2 (SDA)", 3, 4, "5V"),
        ("GPIO3 (SCL)", 5, 6, "GND"),
        ("GPIO4", 7, 8, "GPIO14 (TX)"),
        ("GND", 9, 10, "GPIO15 (RX)"),
        ("GPIO17", 11, 12, "GPIO18 (PWM)"),
        ("GPIO27", 13, 14, "GND"),
        ("GPIO22", 15, 16, "GPIO23"),
        ("3V3", 17, 18, "GPIO24"),
        ("GPIO10 (MOSI)", 19, 20, "GND"),
        ("GPIO9 (MISO)", 21, 22, "GPIO25"),
        ("GPIO11 (SCLK)", 23, 24, "GPIO8 (CE0)"),
        ("GND", 25, 26, "GPIO7 (CE1)"),
        ("ID_SD", 27, 28, "ID_SC"),
        ("GPIO5", 29, 30, "GND"),
        ("GPIO6", 31, 32, "GPIO12 (PWM)"),
        ("GPIO13 (PWM)", 33, 34, "GND"),
        ("GPIO19", 35, 36, "GPIO16"),
        ("GPIO26", 37, 38, "GPIO20"),
        ("GND", 39, 40, "GPIO21")
    ]
    
    for left, lpin, rpin, right in pins:
        print("  {:>16} [{:>2}] [{:<2}] {:<16}".format(left, lpin, rpin, right))
    
    print("")
    result = run_cmd("raspi-gpio get 2>/dev/null | head -20")
    if result and "Error" not in result:
        print("Current GPIO states (first 20):")
        print(result)

elif action == "read":
    if not pin:
        print("Usage: bash rpi.sh gpio read <pin>")
        sys.exit(1)
    result = run_cmd("raspi-gpio get {} 2>/dev/null || cat /sys/class/gpio/gpio{}/value 2>/dev/null".format(pin, pin))
    print("GPIO {}: {}".format(pin, result))

elif action == "set":
    if not pin or not value:
        print("Usage: bash rpi.sh gpio set <pin> <0|1>")
        sys.exit(1)
    run_cmd("raspi-gpio set {} op && raspi-gpio set {} dl 2>/dev/null; echo {} > /sys/class/gpio/gpio{}/value 2>/dev/null".format(pin, pin if value == "0" else "", value, pin))
    print("GPIO {} set to {}".format(pin, value))

else:
    print("GPIO actions: list, read <pin>, set <pin> <0|1>")
PYEOF
    ;;

  services)
    python3 << 'PYEOF'
import subprocess, os

rpi_host = os.environ.get("RPI_HOST", "")
rpi_user = os.environ.get("RPI_USER", "pi")

def run_cmd(cmd):
    if rpi_host:
        full_cmd = "ssh -o ConnectTimeout=5 {}@{} '{}'".format(rpi_user, rpi_host, cmd)
    else:
        full_cmd = cmd
    try:
        return subprocess.check_output(full_cmd, shell=True, stderr=subprocess.STDOUT).decode("utf-8").strip()
    except Exception:
        return ""

print("=" * 60)
print("SYSTEM SERVICES")
print("=" * 60)
print("")

services = ["ssh", "cron", "nginx", "apache2", "mosquitto", "docker", 
            "nodered", "zigbee2mqtt", "homeassistant", "pihole-FTL",
            "bluetooth", "avahi-daemon"]

for svc in services:
    status = run_cmd("systemctl is-active {} 2>/dev/null".format(svc))
    if status == "active":
        print("  🟢 {} — running".format(svc))
    elif status == "inactive":
        print("  ⚫ {} — stopped".format(svc))
    elif status == "failed":
        print("  🔴 {} — failed".format(svc))
    # Skip if service doesn't exist

print("")
print("Manage: sudo systemctl [start|stop|restart] <service>")
PYEOF
    ;;

  sensors)
    python3 << 'PYEOF'
import subprocess, os, json

rpi_host = os.environ.get("RPI_HOST", "")
rpi_user = os.environ.get("RPI_USER", "pi")

def run_cmd(cmd):
    if rpi_host:
        full_cmd = "ssh -o ConnectTimeout=5 {}@{} '{}'".format(rpi_user, rpi_host, cmd)
    else:
        full_cmd = cmd
    try:
        return subprocess.check_output(full_cmd, shell=True, stderr=subprocess.STDOUT).decode("utf-8").strip()
    except Exception:
        return ""

print("=" * 55)
print("SENSOR DATA")
print("=" * 55)
print("")

# I2C devices
i2c = run_cmd("i2cdetect -y 1 2>/dev/null")
if i2c:
    print("I2C Devices found:")
    print(i2c)
    print("")

# 1-Wire temperature sensors (DS18B20)
w1_devices = run_cmd("ls /sys/bus/w1/devices/ 2>/dev/null | grep -v w1_bus_master")
if w1_devices:
    print("1-Wire Temperature Sensors:")
    for dev in w1_devices.split("\n"):
        if dev.strip():
            temp = run_cmd("cat /sys/bus/w1/devices/{}/temperature 2>/dev/null".format(dev.strip()))
            if temp:
                try:
                    temp_c = int(temp) / 1000.0
                    print("  {} — {:.1f}°C / {:.1f}°F".format(dev.strip(), temp_c, temp_c * 9/5 + 32))
                except ValueError:
                    pass
    print("")

# Camera
camera = run_cmd("vcgencmd get_camera 2>/dev/null")
if camera:
    print("Camera: {}".format(camera))

# USB devices
usb = run_cmd("lsusb 2>/dev/null")
if usb:
    print("")
    print("USB Devices:")
    for line in usb.split("\n")[:10]:
        print("  {}".format(line.strip()))

print("")
print("Common sensor libraries:")
print("  pip install adafruit-circuitpython-dht  # DHT11/22")
print("  pip install adafruit-circuitpython-bme280  # BME280")
print("  pip install adafruit-circuitpython-bmp280  # BMP280")
print("  pip install RPi.GPIO  # GPIO control")
PYEOF
    ;;

  update)
    echo "Updating Raspberry Pi system..."
    _ssh "sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"
    echo "Update complete."
    ;;

  reboot)
    echo "Rebooting Raspberry Pi..."
    echo "⚠️  This will disconnect the session."
    _ssh "sudo reboot"
    ;;

  deploy)
    FILE="${1:-}"
    DEST="${2:-/home/pi/}"
    
    if [ -z "$FILE" ]; then
      echo "Usage: bash rpi.sh deploy <local_file> [remote_path]"
      echo "Example: bash rpi.sh deploy app.py /home/pi/myapp/"
      exit 1
    fi
    
    if [ -n "$RPI_HOST" ]; then
      scp "$FILE" "${RPI_USER}@${RPI_HOST}:${DEST}"
      echo "Deployed $FILE to ${RPI_HOST}:${DEST}"
    else
      cp "$FILE" "$DEST"
      echo "Copied $FILE to $DEST"
    fi
    ;;

  help|*)
    cat << 'HELPEOF'
Raspberry Pi Manager — Monitor and manage your Pi

MONITORING:
  status                Full system status (CPU, RAM, temp, disk)
  services              List system services
  sensors               Read connected sensors

GPIO:
  gpio list             Pin reference chart
  gpio read <pin>       Read GPIO pin value
  gpio set <pin> <0|1>  Set GPIO output

MANAGEMENT:
  update                System update (apt upgrade)
  reboot                Reboot Pi
  deploy <file> [path]  Deploy file to Pi via SCP

ENV VARS:
  RPI_HOST — Pi IP/hostname (omit for local)
  RPI_USER — SSH username (default: pi)

EXAMPLES:
  bash rpi.sh status
  bash rpi.sh gpio list
  bash rpi.sh gpio read 17
  bash rpi.sh services
  bash rpi.sh sensors
  bash rpi.sh deploy app.py /home/pi/myapp/

LOCAL vs REMOTE:
  Set RPI_HOST to manage remote Pi via SSH
  Leave unset to manage the current machine
HELPEOF
    ;;
esac

echo ""
echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
