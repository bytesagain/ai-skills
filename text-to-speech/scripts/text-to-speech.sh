#!/usr/bin/env bash
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in

script)
  TYPE="${1:-podcast}"
  TOPIC="${2:-technology}"
  python3 << 'PYEOF'
import sys
stype = sys.argv[1] if len(sys.argv) > 1 else "podcast"
topic = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else "technology"

print("=" * 60)
print("  TTS Script: {} ({})".format(topic, stype))
print("=" * 60)
print("")

if stype == "podcast":
    print("---")
    print("Type: Podcast Script")
    print("Topic: {}".format(topic))
    print("Duration: ~5 minutes")
    print("Tone: Conversational, engaging")
    print("---")
    print("")
    print("[INTRO - 30s]")
    print("")
    print("Hey everyone, welcome back to the show!")
    print("Today we're diving into {} --".format(topic))
    print("a topic I've been really excited about.")
    print("")
    print("(pause 1s)")
    print("")
    print("[SECTION 1 - 90s]")
    print("")
    print("So let me start with the basics.")
    print("What exactly is {}, and why should you care?".format(topic))
    print("")
    print("(pause 0.5s)")
    print("")
    print("Think of it this way...")
    print("[TODO: Add your explanation here]")
    print("")
    print("[SECTION 2 - 90s]")
    print("")
    print("Now here's where it gets interesting.")
    print("[TODO: Deep dive content]")
    print("")
    print("[SECTION 3 - 60s]")
    print("")
    print("Let me share a real-world example.")
    print("[TODO: Case study or example]")
    print("")
    print("[OUTRO - 30s]")
    print("")
    print("That's a wrap for today!")
    print("If you found this useful, hit subscribe")
    print("and leave a comment with your thoughts on {}".format(topic))
    print("See you next time!")

elif stype == "video":
    print("---")
    print("Type: Video Voiceover")
    print("Topic: {}".format(topic))
    print("Duration: ~3 minutes")
    print("Tone: Energetic, clear")
    print("---")
    print("")
    print("[HOOK - 5s]")
    print("Did you know about {}? Let me show you.".format(topic))
    print("")
    print("[INTRO - 15s]")
    print("In this video, I'll walk you through everything")
    print("you need to know about {}.".format(topic))
    print("")
    print("[BODY - 120s]")
    print("[Scene 1] First, let's look at...")
    print("[Scene 2] Next, notice how...")
    print("[Scene 3] And finally...")
    print("")
    print("[CTA - 10s]")
    print("Like and subscribe for more content like this!")

elif stype == "narration":
    print("---")
    print("Type: Narration")
    print("Topic: {}".format(topic))
    print("Tone: Calm, authoritative")
    print("---")
    print("")
    print("[BEGIN]")
    print("")
    print("{}.".format(topic))
    print("")
    print("(pause 2s)")
    print("")
    print("In the following minutes, we will explore")
    print("the key aspects of this subject.")
    print("")
    print("[SECTION 1]")
    print("[TODO: Content]")
    print("")
    print("[SECTION 2]")
    print("[TODO: Content]")
    print("")
    print("[END]")
    print("Thank you for listening.")

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

ssml)
  TEXT="${1:-Hello World}"
  python3 << 'PYEOF'
import sys
text = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "Hello World"

print("=" * 60)
print("  SSML Markup Generator")
print("=" * 60)
print("")
print("--- Original Text ---")
print(text)
print("")
print("--- SSML Output ---")
print("")
print('<speak>')
print('  <prosody rate="medium" pitch="medium">')

sentences = text.replace(".", ".|").replace("!", "!|").replace("?", "?|").replace(",", ",|").split("|")
for s in sentences:
    s = s.strip()
    if not s:
        continue
    if s.endswith("?"):
        print('    <prosody pitch="+10%">{}</prosody>'.format(s))
    elif s.endswith("!"):
        print('    <emphasis level="strong">{}</emphasis>'.format(s))
    else:
        print('    {}'.format(s))
    print('    <break time="500ms"/>')

print('  </prosody>')
print('</speak>')
print("")
print("--- SSML Cheat Sheet ---")
print('<break time="500ms"/>          Pause')
print('<prosody rate="slow">          Speed: x-slow/slow/medium/fast/x-fast')
print('<prosody pitch="+20%">         Pitch: x-low/low/medium/high/x-high')
print('<prosody volume="loud">        Volume: silent/soft/medium/loud')
print('<emphasis level="strong">      Emphasis: reduced/moderate/strong')
print('<say-as interpret-as="date">   Interpret: date/time/telephone/cardinal')
print('<phoneme ph="...">             Pronunciation override')
print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

timing)
  TEXT="${1:-Sample text for timing}"
  WPM="${2:-150}"
  python3 << 'PYEOF'
import sys
text = sys.argv[1] if len(sys.argv) > 1 else "Sample text for timing annotation. This is the second sentence. And here is the third one."
wpm = int(sys.argv[2]) if len(sys.argv) > 2 else 150

print("=" * 60)
print("  Timing Annotation ({} WPM)".format(wpm))
print("=" * 60)
print("")

sentences = [s.strip() for s in text.replace(".", ".|").replace("!", "!|").replace("?", "?|").split("|") if s.strip()]
current_time = 0.0

for i, sent in enumerate(sentences, 1):
    word_count = len(sent.split())
    duration = (word_count / wpm) * 60
    start_min = int(current_time) // 60
    start_sec = current_time % 60
    end_time = current_time + duration
    end_min = int(end_time) // 60
    end_sec = end_time % 60

    print("[{:02d}:{:05.2f} - {:02d}:{:05.2f}] ({:.1f}s, {} words)".format(
        start_min, start_sec, end_min, end_sec, duration, word_count
    ))
    print("  {}".format(sent))
    print("")
    current_time = end_time + 0.5

total_min = int(current_time) // 60
total_sec = current_time % 60
print("---")
print("Total duration: {:02d}:{:05.2f}".format(total_min, total_sec))
print("Total words: {}".format(sum(len(s.split()) for s in sentences)))
print("Speed: {} WPM".format(wpm))
print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

emotion)
  TEXT="${1:-I am so excited about this new project}"
  python3 << 'PYEOF'
import sys
text = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "I am so excited about this new project"

emotions = {
    "happy": ["excited", "great", "awesome", "love", "wonderful", "amazing", "happy", "joy"],
    "sad": ["unfortunately", "sorry", "sad", "miss", "lost", "regret", "disappointing"],
    "angry": ["hate", "terrible", "worst", "furious", "outrageous", "ridiculous"],
    "surprised": ["wow", "unbelievable", "incredible", "shocking", "unexpected"],
    "calm": ["however", "therefore", "meanwhile", "additionally", "furthermore"],
    "urgent": ["now", "immediately", "hurry", "quick", "urgent", "asap", "deadline"],
}

words_lower = text.lower()
detected = []
for emotion, keywords in emotions.items():
    for kw in keywords:
        if kw in words_lower:
            detected.append((emotion, kw))
            break

if not detected:
    detected = [("neutral", "-")]

print("=" * 60)
print("  Emotion Annotation")
print("=" * 60)
print("")
print("Text: {}".format(text))
print("")
print("Detected emotions:")
for emo, trigger in detected:
    icon = {"happy": ":-)", "sad": ":-(", "angry": ">:(", "surprised": ":O",
            "calm": ":-|", "urgent": "!!!", "neutral": ":-|"}.get(emo, "?")
    print("  {} {} (trigger: '{}')".format(icon, emo.upper(), trigger))
print("")
print("--- Annotated Script ---")
print("")
print("[{}] {}".format(detected[0][0].upper(), text))
print("")
print("--- Emotion Tags Reference ---")
print("  [HAPPY]      Warm, upbeat tone")
print("  [SAD]        Slower, softer delivery")
print("  [ANGRY]      Firm, intense tone")
print("  [SURPRISED]  Higher pitch, emphasis")
print("  [CALM]       Even, measured pace")
print("  [URGENT]     Fast, pressing tone")
print("  [NEUTRAL]    Standard delivery")
print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

multi-voice)
  VOICES="${1:-host,guest}"
  TOPIC="${2:-interview}"
  python3 << 'PYEOF'
import sys
voices_str = sys.argv[1] if len(sys.argv) > 1 else "host,guest"
topic = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else "interview"
voices = [v.strip() for v in voices_str.split(",")]

print("=" * 60)
print("  Multi-Voice Dialogue Script")
print("  Voices: {}".format(", ".join(voices)))
print("=" * 60)
print("")
print("---")
print("Topic: {}".format(topic))
print("Voices: {}".format(len(voices)))

for i, v in enumerate(voices):
    rec = ["Nova", "Onyx", "Alloy", "Echo", "Fable", "Shimmer"]
    print("  {}: [Recommended TTS voice: {}]".format(v.upper(), rec[i % len(rec)]))
print("---")
print("")

if len(voices) >= 2:
    v1, v2 = voices[0], voices[1]
    print("[{}] Welcome everyone! Today we're talking".format(v1.upper()))
    print("      about {} -- a fascinating topic.".format(topic))
    print("")
    print("      (pause 1s)")
    print("")
    print("[{}] Thanks for having me! I'm really excited".format(v2.upper()))
    print("      to share my thoughts on this.")
    print("")
    print("[{}] So let's start from the beginning.".format(v1.upper()))
    print("      What got you interested in {}?".format(topic))
    print("")
    print("[{}] Great question. It all started when...".format(v2.upper()))
    print("      [TODO: Add response content]")
    print("")
    print("[{}] That's really interesting. And how do you see".format(v1.upper()))
    print("      this evolving in the future?")
    print("")
    print("[{}] I think we'll see...".format(v2.upper()))
    print("      [TODO: Add response content]")
    print("")
    if len(voices) > 2:
        print("[{}] If I may add to that...".format(voices[2].upper()))
        print("      [TODO: Third voice content]")
        print("")
    print("[{}] Wonderful insights! That's all for today.".format(v1.upper()))
    print("      Thanks for joining us!")
    print("")
    print("[{}] My pleasure! Thanks everyone.".format(v2.upper()))

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

subtitle)
  TEXT="${1:-Welcome to our channel. Today we discuss AI. Lets get started.}"
  python3 << 'PYEOF'
import sys
text = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "Welcome to our channel. Today we discuss AI. Lets get started."

sentences = [s.strip() for s in text.replace(".", ".|").replace("!", "!|").replace("?", "?|").split("|") if s.strip()]
wpm = 150
current_time = 0.0

print("=" * 60)
print("  SRT Subtitle File")
print("=" * 60)
print("")

for i, sent in enumerate(sentences, 1):
    word_count = len(sent.split())
    duration = max((word_count / wpm) * 60, 1.0)

    sh = int(current_time) // 3600
    sm = (int(current_time) % 3600) // 60
    ss = int(current_time) % 60
    sms = int((current_time % 1) * 1000)

    end = current_time + duration
    eh = int(end) // 3600
    em = (int(end) % 3600) // 60
    es = int(end) % 60
    ems = int((end % 1) * 1000)

    print("{}".format(i))
    print("{:02d}:{:02d}:{:02d},{:03d} --> {:02d}:{:02d}:{:02d},{:03d}".format(
        sh, sm, ss, sms, eh, em, es, ems
    ))
    print(sent)
    print("")

    current_time = end + 0.2

print("---")
print("Subtitles: {} entries".format(len(sentences)))
print("Format: SRT (SubRip)")
print("Estimated WPM: {}".format(wpm))
print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

audiobook)
  TITLE="${1:-Chapter 1}"
  python3 << 'PYEOF'
import sys
title = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "Chapter 1"

print("=" * 60)
print("  Audiobook Chapter Script")
print("=" * 60)
print("")
print("---")
print("Chapter: {}".format(title))
print("Narrator voice: Warm, measured (recommended: Nova/Onyx)")
print("Pace: 140-160 WPM")
print("---")
print("")
print("[CHAPTER INTRO]")
print("")
print("(silence 2s)")
print("")
print("[NARRATOR] {}".format(title))
print("")
print("(pause 3s)")
print("")
print("[NARRATOR - calm, setting the scene]")
print("[TODO: Opening paragraph. Set the scene,")
print(" introduce the mood. Slightly slower pace.]")
print("")
print("(pause 1s)")
print("")
print("[NARRATOR - normal pace]")
print("[TODO: Main content of the chapter.]")
print("")
print("[NARRATOR - if dialogue]")
print('  "Quoted dialogue here," [CHARACTER_NAME] said.')
print('  [Shift voice slightly for each character]')
print("")
print("[NARRATOR - building tension]")
print("[TODO: Climactic section. Slightly faster,")
print(" more intense delivery.]")
print("")
print("(pause 2s)")
print("")
print("[NARRATOR - winding down]")
print("[TODO: Chapter closing. Return to calm pace.]")
print("")
print("(silence 3s)")
print("")
print("[END OF {}]".format(title.upper()))
print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

commercial)
  DURATION="${1:-30}"
  PRODUCT="${2:-SuperApp}"
  python3 << 'PYEOF'
import sys
duration = int(sys.argv[1]) if len(sys.argv) > 1 else 30
product = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else "SuperApp"

print("=" * 60)
print("  Commercial Voiceover ({}s)".format(duration))
print("  Product: {}".format(product))
print("=" * 60)
print("")

if duration == 15:
    print("--- 15-Second Spot ---")
    print("")
    print("[0-3s] HOOK (energetic)")
    print("Tired of [pain point]?")
    print("")
    print("[3-10s] SOLUTION (confident)")
    print("{} makes it simple.".format(product))
    print("[Key benefit in one sentence]")
    print("")
    print("[10-15s] CTA (urgent)")
    print("Download {} today. Free trial available.".format(product))
    print("")

elif duration == 30:
    print("--- 30-Second Spot ---")
    print("")
    print("[0-5s] HOOK (attention-grabbing)")
    print("What if you could [dream outcome]?")
    print("")
    print("(beat)")
    print("")
    print("[5-12s] PAIN POINT (empathetic)")
    print("We know [pain point] is frustrating.")
    print("You've tried everything, but nothing works.")
    print("")
    print("[12-22s] SOLUTION (confident, warm)")
    print("That's why we built {}.".format(product))
    print("[Feature 1] that [benefit 1].")
    print("[Feature 2] that [benefit 2].")
    print("")
    print("[22-30s] CTA (urgent but friendly)")
    print("Try {} free for 30 days.".format(product))
    print("Visit {}.com. That's {}.com.".format(product.lower().replace(" ", ""), product.lower().replace(" ", "")))
    print("")

elif duration == 60:
    print("--- 60-Second Spot ---")
    print("")
    print("[0-5s] HOOK")
    print("[Compelling question or scenario]")
    print("")
    print("[5-15s] STORY/PAIN")
    print("[Relatable story about the problem]")
    print("")
    print("[15-35s] SOLUTION + FEATURES")
    print("Introducing {}.".format(product))
    print("[Feature 1]: [Benefit explanation]")
    print("[Feature 2]: [Benefit explanation]")
    print("[Feature 3]: [Benefit explanation]")
    print("")
    print("[35-50s] SOCIAL PROOF")
    print("Trusted by [number] users.")
    print("[Testimonial or stat]")
    print("")
    print("[50-60s] CTA")
    print("Get started with {} today.".format(product))
    print("Visit [website]. Use code [CODE] for [discount].")
    print("{} -- [tagline].".format(product))

else:
    print("Supported durations: 15, 30, 60 seconds")
    print("Usage: commercial <15|30|60> <product_name>")

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

*)
  echo "Text to Speech - Voice Script Generator"
  echo ""
  echo "Usage: bash text-to-speech.sh <command> [args]"
  echo ""
  echo "Commands:"
  echo "  script <type> <topic>        Podcast/video voiceover script"
  echo "  ssml <text>                  Generate SSML markup"
  echo "  timing <text> <wpm>          Add timing annotations"
  echo "  emotion <text>               Add emotion/tone tags"
  echo "  multi-voice <voices> <topic> Multi-character dialogue"
  echo "  subtitle <text>              Generate SRT subtitles"
  echo "  audiobook <chapter_title>    Audiobook chapter script"
  echo "  commercial <duration> <name> Commercial voiceover"
  echo ""
  echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
  ;;

esac
