---
name: SeedGen
description: "Random seed and test data generator. Create deterministic random sequences, generate seed phrases, produce reproducible test datasets, and manage random number generation for development and testing. Control randomness in your projects."
version: "2.0.0"
author: "BytesAgain"
tags: ["seed","random","generator","testing","data","deterministic","developer"]
categories: ["Developer Tools", "Utility"]
---
# SeedGen
Reproducible randomness. Generate seeds, test data, and deterministic sequences.
## Commands
- `seed` — Generate a random seed
- `sequence <seed> <n>` — Generate N numbers from seed
- `words <n>` — Generate random word list
- `hex <length>` — Random hex string
- `bytes <length>` — Random bytes (base64)
## Usage Examples
```bash
seedgen seed
seedgen sequence 42 10
seedgen words 12
seedgen hex 32
```
---
Powered by BytesAgain | bytesagain.com

- Run `seedgen help` for all commands

## When to Use

- when you need quick seedgen from the command line
- to automate seedgen tasks in your workflow

## Output

Returns reports to stdout. Redirect to a file with `seedgen run > output.txt`.

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
