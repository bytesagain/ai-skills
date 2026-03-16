# Tips for Roomba Control

## Getting Better Cleans

1. **Schedule during quiet hours.** The Roomba works best when the house is empty — no feet, pets, or toys to dodge.

2. **Use room-specific cleaning** on supported models (i/j/s series). Targeted runs are faster and more efficient than full-house cleans.

3. **Empty the bin before each clean** (or rely on the auto-empty base if you have one). A full bin significantly reduces suction power.

4. **Check consumables monthly.** The `consumables` command shows remaining life. Replace filters and brushes before they're completely worn to maintain cleaning performance.

5. **Run `stats`** weekly to track cleaning efficiency. Declining coverage area might mean the robot needs maintenance.

## Multi-Room Strategy

- Clean high-traffic areas (kitchen, hallways) daily
- Clean bedrooms and offices 2-3x per week
- Do a full-house clean once a week
- Use `--rooms` to target specific areas per schedule

## Consumable Replacement Schedule

| Part | Typical Lifespan | Signs of Wear |
|------|------------------|---------------|
| Filter | 2 months | Visible debris, reduced suction |
| Side Brush | 2-3 months | Bent/worn bristles |
| Main Brush | 6-8 months | Frayed bristles, reduced pickup |
| Dust Bag | 30 days (auto-empty) | Base indicates full |

## Troubleshooting

- **"Roomba stuck"** — Check for tangled hair on brushes, stuck wheels, or obstacles. Clear and restart.
- **"Charging error"** — Clean the charging contacts on both the robot and dock with a dry cloth.
- **Room names not matching** — Names must match exactly what's in the iRobot app, including capitalization.
- **Wi-Fi disconnects** — Keep the dock within good Wi-Fi range. Consider a Wi-Fi extender if your Pi is far from the router.

## Automation Recipes

- Clean the kitchen 30 minutes after dinner (tie to a calendar event or manual trigger)
- Run a deep clean before weekly house guests
- Alert when bin is full so you can empty it before the next scheduled clean
- Pair with `homeassistant-toolkit` for trigger-based cleaning (e.g., everyone leaves the house)
