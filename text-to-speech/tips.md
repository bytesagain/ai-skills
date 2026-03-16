# Text to Speech Tips

1. **Write conversationally** — TTS scripts should avoid formal prose; use short sentences and spoken-word phrasing: "You know what?" beats "As is commonly understood"
2. **Mark your pauses** — Use the `ssml` command to add `<break>` tags at key moments so listeners can absorb information
3. **Match speed to context** — Tutorials should be slower (0.8x), news at normal pace (1.0x), ads can go slightly faster (1.1x)
4. **Assign distinct voices** — `multi-voice` scripts tag each character; map them to different TTS voices for clear distinction
5. **Fine-tune subtitle timing** — `subtitle` estimates at 150 WPM; adjust based on actual TTS engine speed after a test render
6. **Use emotion sparingly** — Limit to 1-2 emotion shifts per paragraph; too many changes sound unnatural
7. **Always preview first** — Generate the script, run it through your TTS engine, then adjust punctuation and pauses based on what you hear
8. **Follow ad structure** — Hook (3s) → Pain point (5s) → Solution (10s) → CTA (5s); time allocation matters for impact
