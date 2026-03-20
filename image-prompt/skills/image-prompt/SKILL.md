---
version: "2.1.0"
name: image-prompt
description: "AI image prompt optimizer. Generate and enhance prompts for Midjourney, DALL-E, and Stable Diffusion. Includes prompt enhancement."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# 🎨 Image Prompt — AI Art Prompt Generator & Optimizer

> Turn a vague idea into a detailed, production-ready image prompt. Built-in word banks for styles, lighting, composition, and quality modifiers — just provide a subject and go.

## Commands

### `generate <subject>`

Build a full image prompt from a subject. Randomly picks style, lighting, composition, and quality tags from the internal word bank to create a ready-to-use prompt.

```
image-prompt generate "a fox in a forest"
```

### `style <subject> <style>`

Generate a prompt locked to a specific art style. Supported styles:

- `photorealistic` — hyperrealistic photography look
- `anime` — Japanese animation aesthetic
- `oil-painting` — classical oil on canvas
- `watercolor` — soft watercolor washes
- `pixel-art` — retro pixel graphics
- `3d-render` — Blender/Octane 3D style
- `sketch` — pencil/charcoal drawing

```
image-prompt style "mountain village" watercolor
```

### `enhance <prompt>`

Take an existing prompt and upgrade it with quality boosters, detail tags, and a matching negative prompt suggestion.

```
image-prompt enhance "a cat sitting on a windowsill"
```

### `negative`

Print a curated list of commonly used negative prompt terms, grouped by category (anatomy, quality, style, artifacts).

```
image-prompt negative
```

### `template <type>`

Get a fill-in-the-blank prompt template for a specific genre. Available types:

- `portrait` — character/person focus
- `landscape` — scenery and environments
- `product` — commercial product shots
- `food` — food photography
- `architecture` — buildings and interiors
- `fantasy` — fantasy/sci-fi illustration

```
image-prompt template portrait
```

### `random`

Roll the dice — generates a completely random creative prompt by combining random subjects, styles, lighting, and composition from the word bank.

```
image-prompt random
```

### `translate <chinese_description>`

Convert a Chinese-language description into an English image prompt with appropriate tags.

```
image-prompt translate "一只猫坐在樱花树下"
```

### `save <name> <prompt>`

Save a prompt to your local library for later reuse.

```
image-prompt save hero-shot "a knight standing on a cliff, dramatic lighting, cinematic, 8k"
```

### `list`

Show all prompts saved in your local library.

```
image-prompt list
```

### `search <keyword>`

Search your saved prompts by keyword.

```
image-prompt search knight
```

### `help`

Show the help message with all available commands.

### `version`

Print the current version number.

## Examples

**Basic generation:**
```
$ image-prompt generate "an astronaut"
🎨 Prompt:
an astronaut, digital painting style, volumetric lighting, rule of thirds composition,
intricate details, sharp focus, 8k resolution, trending on artstation

📛 Negative:
blurry, low quality, deformed, watermark, text, signature
```

**Styled output:**
```
$ image-prompt style "cherry blossom garden" anime
🎨 Prompt:
cherry blossom garden, anime style, cel shading, vibrant colors, soft ambient lighting,
wide angle composition, detailed background, studio ghibli inspired, high quality anime art

📛 Negative:
photorealistic, 3d render, blurry, low quality, deformed
```

**Enhancing an existing prompt:**
```
$ image-prompt enhance "a dragon flying over a castle"
🎨 Enhanced Prompt:
a dragon flying over a castle, epic scale, dramatic rim lighting, aerial perspective,
intricate scales and details, sharp focus, 8k resolution, cinematic color grading,
volumetric clouds, masterpiece quality, trending on artstation

📛 Suggested Negative:
blurry, low quality, deformed, watermark, text, bad anatomy, disfigured
```

**Random prompt:**
```
$ image-prompt random
🎨 Random Prompt:
a mechanical owl perched on ancient ruins, steampunk style, golden hour lighting,
centered composition, intricate gears and clockwork, highly detailed, 4k wallpaper,
concept art

📛 Negative:
blurry, low quality, deformed, watermark, text, signature
```

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `IMAGE_PROMPT_DIR` | `$HOME/.image-prompt` | Base directory for saved prompts and history |

The data directory is created automatically on first run.

## Data Storage

All data is kept under `$HOME/.image-prompt/` (or the path set via `IMAGE_PROMPT_DIR`):

```
~/.image-prompt/
├── prompts.txt      # saved prompts (one per line: name|prompt)
└── history.log      # command usage log
```

Prompts are stored as plain text — easy to back up, grep, or move between machines.

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
