---
version: "2.0.0"
name: raspberry-pi-manager
description: "Manage Raspberry Pi devices — GPIO control, system monitoring (CPU/temp/memory), service management, sensor data reading, and remote deployment. Use when you need raspberry pi manager capabilities. Triggers on: raspberry pi manager."
author: BytesAgain
---

# Raspberry Pi Manager

A Swiss Army knife for Raspberry Pi administration. Whether you're running a single Pi as a home server or managing a fleet of IoT nodes, this toolkit gives you instant access to system stats, GPIO pins, services, sensors, and deployment workflows.

The script runs locally on the Pi or connects remotely via SSH. For local use, just execute the script directly. For remote management, configure SSH access.

### Local Usage

```bash
bash scripts/pi-manager.sh system
bash scripts/pi-manager.sh gpio read 17
```

### Remote Usage

```bash
export PI_HOST="pi@192.168.1.200"
export PI_SSH_KEY="~/.ssh/id_rsa"

bash scripts/pi-manager.sh --remote system
bash scripts/pi-manager.sh --remote gpio read 17
```

Multiple Pi support:

```bash
export PI_HOSTS="pi@node1.local,pi@node2.local,pi@node3.local"
bash scripts/pi-manager.sh --fleet system
```

## System Monitoring

Real-time insight into your Pi's health.

```bash
# Full system dashboard
$ bash scripts/pi-manager.sh system

┌─ Raspberry Pi 4 Model B (4GB) ─────────────────────┐
│                                                      │
│  CPU:    4× ARM Cortex-A72 @ 1.5GHz                │
│  Load:   0.42, 0.38, 0.31                          │
│  Temp:   48.3°C / 118.9°F  [████░░░░░░ OK]         │
│  Memory: 1.2GB / 3.7GB     [████████░░ 32%]        │
│  Disk:   12.4GB / 29.1GB   [█████████░ 43%]        │
│  Swap:   0MB / 100MB       [░░░░░░░░░░ 0%]         │
│  Uptime: 14 days, 7:23:41                           │
│  OS:     Raspberry Pi OS (Bookworm) 64-bit          │
│                                                      │
│  Network:                                            │
│    eth0:  192.168.1.200 (1000 Mbps)                 │
│    wlan0: 192.168.1.201 (72 Mbps, -42 dBm)         │
└──────────────────────────────────────────────────────┘
```

### Individual Metrics

```bash
# Temperature with threshold warning
bash scripts/pi-manager.sh temp
bash scripts/pi-manager.sh temp --warn 70 --crit 80

# CPU usage (snapshot or continuous)
bash scripts/pi-manager.sh cpu
bash scripts/pi-manager.sh cpu --watch 5   # Update every 5s

# Memory breakdown
bash scripts/pi-manager.sh memory

# Disk usage by mount point
bash scripts/pi-manager.sh disk

# Network interfaces and traffic
bash scripts/pi-manager.sh network

# Top processes by CPU/memory
bash scripts/pi-manager.sh top 10
```

### Historical Data

```bash
# Log system metrics to CSV (for graphing)
bash scripts/pi-manager.sh monitor --interval 60 --output metrics.csv

# View logged metrics
bash scripts/pi-manager.sh monitor --view metrics.csv --last 24h
```

## GPIO Control

Direct pin manipulation for hardware projects.

```bash
# Pin layout reference
bash scripts/pi-manager.sh gpio pinout

# Read a pin state
bash scripts/pi-manager.sh gpio read 17

# Set pin output
bash scripts/pi-manager.sh gpio write 17 high
bash scripts/pi-manager.sh gpio write 17 low

# Set pin mode
bash scripts/pi-manager.sh gpio mode 17 output
bash scripts/pi-manager.sh gpio mode 18 input --pull up

# PWM output (hardware PWM on supported pins)
bash scripts/pi-manager.sh gpio pwm 18 75    # 75% duty cycle

# Watch pin for changes
bash scripts/pi-manager.sh gpio watch 17 --edge both

# Bulk operations
bash scripts/pi-manager.sh gpio write 17,18,27,22 high
bash scripts/pi-manager.sh gpio read 17,18,27,22

# GPIO status overview
bash scripts/pi-manager.sh gpio status
```

## Service Management

Control systemd services running on the Pi.

```bash
# List all services (active, failed, inactive)
bash scripts/pi-manager.sh service list
bash scripts/pi-manager.sh service list --failed

# Service operations
bash scripts/pi-manager.sh service status nginx
bash scripts/pi-manager.sh service start nginx
bash scripts/pi-manager.sh service stop nginx
bash scripts/pi-manager.sh service restart nginx
bash scripts/pi-manager.sh service enable nginx
bash scripts/pi-manager.sh service disable nginx

# View service logs
bash scripts/pi-manager.sh service logs nginx --lines 50
bash scripts/pi-manager.sh service logs nginx --follow

# Create a new service from a script
bash scripts/pi-manager.sh service create my-app /home/pi/app/start.sh \
  --description "My Application" \
  --restart always \
  --user pi
```

## Sensor Data

Read common sensors connected to your Pi.

```bash
# DHT11/DHT22 temperature & humidity
bash scripts/pi-manager.sh sensor dht22 4      # GPIO pin 4

# DS18B20 temperature sensor (1-Wire)
bash scripts/pi-manager.sh sensor ds18b20

# BMP280/BME280 (I2C)
bash scripts/pi-manager.sh sensor bme280

# HC-SR04 ultrasonic distance
bash scripts/pi-manager.sh sensor distance 23 24  # Trigger/Echo pins

# PIR motion sensor
bash scripts/pi-manager.sh sensor pir 17 --watch

# Light sensor (analog via MCP3008 ADC)
bash scripts/pi-manager.sh sensor light 0       # ADC channel 0

# Log sensor readings
bash scripts/pi-manager.sh sensor dht22 4 --log --interval 300 --output temp_log.csv
```

## Remote Deployment

Deploy applications and configurations to your Pi.

```bash
# Copy files to Pi
bash scripts/pi-manager.sh deploy push ./app/ /home/pi/app/

# Pull files from Pi
bash scripts/pi-manager.sh deploy pull /home/pi/logs/ ./local-logs/

# Run a script on the Pi
bash scripts/pi-manager.sh deploy exec ./setup.sh

# Full deployment workflow
bash scripts/pi-manager.sh deploy run ./deploy.yml
```

### Deploy manifest (`deploy.yml`):

```yaml
target: pi@192.168.1.200
steps:
  - copy: ./app/ → /home/pi/app/
  - run: cd /home/pi/app && pip3 install -r requirements.txt
  - run: sudo systemctl restart my-app
  - verify: curl -s http://localhost:8080/health
```

```bash
# Fleet deployment
bash scripts/pi-manager.sh --fleet deploy run ./deploy.yml
# Deploys to all configured Pi hosts sequentially
```

## Maintenance

```bash
# System update
bash scripts/pi-manager.sh update

# Firmware update check
bash scripts/pi-manager.sh firmware

# Reboot / shutdown
bash scripts/pi-manager.sh reboot
bash scripts/pi-manager.sh shutdown

# Backup SD card (creates compressed image)
bash scripts/pi-manager.sh backup /path/to/backup.img.gz

# Overclock profiles
bash scripts/pi-manager.sh overclock show
bash scripts/pi-manager.sh overclock mild    # 1.8GHz
bash scripts/pi-manager.sh overclock medium  # 2.0GHz
```

## Monitoring Alerts

Set up threshold-based alerts:

```bash
# Alert if temperature exceeds 75°C
bash scripts/pi-manager.sh alert temp 75

# Alert if disk usage exceeds 90%
bash scripts/pi-manager.sh alert disk 90

# Alert if a service goes down
bash scripts/pi-manager.sh alert service nginx

# All alerts — suitable for cron
bash scripts/pi-manager.sh alert check
```

Designed to be used standalone or as part of a larger IoT management workflow. Pair with `homeassistant-toolkit` for full smart home integration.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Commands

Run `raspberry-pi-manager help` to see all available commands.
