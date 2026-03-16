---
version: "2.0.0"
name: Text to Speech
description: "TTS script generator. Podcast scripts, SSML markup, timing annotations, emotion tags, multi-voice dialogue, SRT subtitles, audiobook chapter scripts, commercial voiceover. Supports Google TTS, Azure TTS, AWS Polly, ElevenLabs. tts, voiceover, podcast, audio, speech-synthesis, developer-tools. Use when you need text to speech capabilities. Triggers on: text to speech."
---

# Text to Speech — Voice Script Generator

Professional TTS scripts for podcasts, ads, and everything in between.

## Core Capabilities

**Content Creation**
- `script` — Podcast/video voiceover scripts with natural tone
- `audiobook` — Audiobook chapter scripts with narration cues
- `commercial` — Ad voiceover scripts in 15s/30s/60s formats

**Technical Markup**
- `ssml` — SSML tag generation for rate, pitch, pauses, emphasis
- `timing` — Timeline annotations with precise timestamps
- `emotion` — Emotion/tone tagging for expressive delivery

**Multimedia**
- `multi-voice` — Multi-character dialogue scripts
- `subtitle` — SRT subtitle file generation

## Commands

| Command | Description |
|---------|-------------|
| `text-to-speech help` | Show usage info |
| `text-to-speech run` | Run main task |

## Examples

```bash
# Generate a podcast script
bash scripts/text-to-speech.sh script podcast "The future of AI"

# SSML markup
bash scripts/text-to-speech.sh ssml "Welcome to my channel"

# 30-second commercial
bash scripts/text-to-speech.sh commercial 30 "SuperProduct"

# Two-person dialogue
bash scripts/text-to-speech.sh multi-voice host,guest "Interview opener"
```

## Compatible Platforms

Google TTS / Azure TTS / AWS Polly / ElevenLabs / IBM Watson
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
