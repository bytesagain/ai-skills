# Tips for Home Assistant Toolkit

## Quick Wins

1. **Use `dashboard` for a daily overview** — It pulls your most important entities into a single view. Great as a morning check.

2. **Tab completion for entity IDs** — Pipe `entities` output through grep to find what you need:
   ```bash
   bash scripts/ha-toolkit.sh entities light | grep bedroom
   ```

3. **JSON payloads for `call`** — You can pass arbitrary service data as JSON. Check HA developer tools for the exact format.

4. **Combine with `watch`** — Use the Linux `watch` command for a live dashboard:
   ```bash
   watch -n 10 'bash scripts/ha-toolkit.sh state sensor.power_consumption'
   ```

5. **Pipe to jq** — The script outputs JSON for most commands. Combine with `jq` for powerful filtering.

## Common Mistakes

- Forgetting the domain prefix — it's `light.kitchen`, not just `kitchen`
- Using the UI name instead of the entity ID — check with `entities` command
- Not URL-encoding the HA_URL (avoid trailing slashes)

## Performance Tips

- The `history` command can be slow for entities with frequent state changes — limit the time window
- Cache frequently-used entity IDs in a shell alias file
- Use `--timeout 10` if your HA instance is slow to respond

## Integration Ideas

- Pair with `raspberry-pi-manager` to use a Pi as a dedicated HA terminal
- Use cron to trigger automations at specific times without HA's built-in scheduler
- Pipe sensor data to `chart-generator` for custom visualizations
