# Tips for Ring Security

## Event Management

1. **Check the `analytics` command regularly.** It shows activity patterns — unusually high event counts might indicate a problem (or just a windy day triggering your motion sensor).

2. **Export events monthly.** Keep a local record with `export csv` in case you ever need to reference historical data. Ring's cloud retention depends on your subscription.

3. **Tune motion sensitivity in the Ring app.** If you're getting too many false positives, adjust motion zones and sensitivity there — the API doesn't expose these settings.

4. **Use `--type motion` vs `--type ding`** to separate actual doorbell presses from motion alerts.

## Battery Life

- Battery devices (Stick Up Cam, Spotlight Cam Battery) drain faster with:
  - High motion frequency
  - Cold weather
  - Live view usage
  - Poor Wi-Fi signal (more retries)
- Use `battery --below 30` in a weekly cron to get early warnings
- Wired devices (Doorbell Pro, Floodlight Cam) don't have this issue

## Security Modes

- **Home mode:** Disarms indoor cameras, keeps outdoor ones active
- **Away mode:** Arms everything
- **Disarmed:** All monitoring off (not recommended)
- Set up mode changes in cron: arm at bedtime, disarm in the morning

## Troubleshooting

- **"Token expired"** — Run `auth login` again. You'll need your 2FA code.
- **"Device offline"** — Check Wi-Fi. Power cycle the device. Check the Ring app for firmware updates.
- **Events not showing** — There can be a 1-2 minute delay between event occurrence and API availability
- **Slow API responses** — Ring's API can be sluggish during peak hours. The script retries automatically.

## Privacy Notes

- Ring events are stored in Amazon's cloud — be aware of data retention policies
- Shared users on your Ring account can also see events
- Video recordings require a Ring Protect subscription ($3.99/mo per device or $12.99/mo for all)
- Consider local-only alternatives (like Frigate) if cloud storage concerns you
