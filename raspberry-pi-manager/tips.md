# Tips for Raspberry Pi Manager

## System Health

1. **Keep the CPU temperature below 70°C.** Throttling starts at 80°C and significantly impacts performance. Use a heatsink + fan if running heavy workloads.

2. **Monitor disk usage proactively.** SD cards fill up silently — logs, temp files, and package caches are common culprits. Set up a cron alert at 80%.

3. **Use `--watch` mode for debugging performance issues.** Real-time CPU and memory monitoring helps identify spikes and memory leaks.

4. **Log metrics to CSV** for long-term trend analysis. A weekly review of temperature and load patterns can prevent failures before they happen.

## GPIO Best Practices

- **Always double-check pin numbering.** BCM numbering (GPIO17) and physical pin numbering (pin 11) are different. The script uses BCM by default.
- **Use pull-up/pull-down resistors** for input pins to avoid floating values
- **Don't draw more than 16mA per GPIO pin** — use a transistor or relay for higher-power devices
- **The `pinout` command** is your quick reference — no need to Google the diagram every time

## Sensor Tips

- **DHT22 > DHT11** for accuracy (±0.5°C vs ±2°C), but DHT11 is cheaper
- **DS18B20** requires 1-Wire to be enabled: `sudo raspi-config` → Interface Options → 1-Wire
- **BME280 via I2C** — enable I2C first: `sudo raspi-config` → Interface Options → I2C
- **Log sensor data to CSV** and use `chart-generator` skill for visualization

## Remote Management

- **Set up SSH key authentication** — password auth over the internet is risky
- **Use a reverse SSH tunnel or VPN** for remote access without port forwarding
- **The `--fleet` mode** is powerful but runs commands sequentially — for large fleets, consider parallel execution with `xargs -P`

## SD Card Longevity

- **Use log2ram** to reduce SD card writes (logs stay in RAM, flushed periodically)
- **Set `noatime` mount option** in `/etc/fstab` to reduce unnecessary writes
- **Move heavy I/O to a USB drive** — databases, media, downloads
- **Keep a backup image** — use the `backup` command monthly

## Security Hardening

- Change the default password immediately
- Disable password-based SSH login
- Keep the system updated: `bash scripts/pi-manager.sh update`
- Disable unused services to reduce attack surface
- Consider running `fail2ban` for SSH brute-force protection

## Performance Tuning

- **Overclock cautiously.** Start with "mild" and test stability under load before going higher.
- **Disable the GUI** if running headless: saves ~200MB RAM
- **Use zram** for swap instead of SD card swap — faster and reduces card wear
- **64-bit OS** uses more RAM but gives access to >4GB on Pi 4/5
