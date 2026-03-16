# Tips for Philips Hue Controller

## Getting the Most Out of Your Lights

1. **Name your lights clearly in the Hue app first.** The script uses the names from the bridge, so "Desk Lamp" is much more useful than "Hue color lamp 3".

2. **Use hex colors from design tools.** Grab colors from Coolors.co, Adobe Color, or any design tool and paste them directly: `color 1 "#E8735A"`.

3. **Sunrise alarm is a game-changer.** Set a 20-minute sunrise in your bedroom — it simulates natural dawn and helps you wake up gently before your alarm goes off.

4. **The `candle` effect is great for dinner parties.** Run it on 2-3 lights in the dining area for a cozy, flickering ambiance.

5. **Create "status light" workflows.** Use a single bulb to show if you're in a meeting (red), available (green), or away (off).

## Color Temperature Guide

| Setting | Kelvin | Best For |
|---------|--------|----------|
| warm | 2700K | Evening relaxation, bedrooms |
| neutral | 4000K | General living, kitchens |
| cool | 5000K | Office work, concentration |
| daylight | 6500K | Task lighting, makeup mirrors |

## Troubleshooting

- **Bridge not found?** Make sure your computer and the bridge are on the same network/VLAN
- **Lights unresponsive?** Check if the physical switch is on — Hue bulbs need constant power
- **Colors look wrong?** Some older Hue White Ambiance bulbs don't support full RGB — only color temperature
- **Rate limited?** The bridge handles ~10 commands per second. Batch operations have built-in delays.

## Power User Tricks

- Chain commands in a script for complex scenes that aren't possible in the Hue app
- Use `--transition` flag (in deciseconds) for smooth fades: 10 = 1 second
- Pair with `homeassistant-toolkit` for automation rules that go beyond what Hue's built-in schedules offer
