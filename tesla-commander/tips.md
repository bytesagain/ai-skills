# Tips for Tesla Commander

## Daily Use

1. **The `summary` command is your friend.** One line with everything you need: battery, range, location, lock status. Perfect for a quick morning check.

2. **Pre-condition before you leave.** Set up a cron job to start climate control 15 minutes before your commute. Your car will be comfortable and the battery pre-warmed for better range.

3. **Set charge limit to 80% for daily use.** Tesla recommends not charging to 100% unless you need the range. Use `charge limit 80` and only bump to 100 before road trips.

4. **Use `track` sparingly.** Continuous location tracking wakes the car and drains the 12V battery. Keep intervals at 5+ minutes, or better yet, only poll when needed.

## Automation Ideas

- **Arrival alert:** Check location every 10 min and notify when the car arrives at a specific address
- **Charge completion notification:** Poll charge status and alert when done
- **Weekly efficiency report:** Use `efficiency` command in a Sunday cron job
- **Auto-lock check:** Verify the car is locked at bedtime, lock it if not

## Security Best Practices

- **Never share your access token.** It provides full control of your vehicle.
- **Use a dedicated Tesla account** if you share scripts with others
- **Rotate tokens regularly** — use the built-in refresh flow
- **Keep token file permissions tight:** `chmod 600 ~/.tesla-commander/`

## Common Gotchas

- **"Vehicle unavailable"** — The car is in deep sleep. The script will attempt a wake-up, but it can take 10-30 seconds. Be patient.
- **"Invalid command"** — Some commands (like seat heaters, dog mode) are only available on certain models/trims
- **"Rate limited"** — Tesla limits API calls. The script handles backoff, but avoid running multiple instances simultaneously
- **Token expiry** — Access tokens last ~8 hours. Set up automatic refresh in cron.

## Range Optimization

Use the `efficiency` command to track your driving habits:
- Wh/mi below 250 = excellent
- 250-300 = good
- 300+ = check tire pressure, reduce speed, pre-condition while plugged in
