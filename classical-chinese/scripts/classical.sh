#!/usr/bin/env bash
# classical-chinese — 文言文工具
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
run_python() {
python3 << 'PYEOF'
import sys, hashlib
from datetime import datetime

cmd = sys.argv[1] if len(sys.argv) > 1 else "help"
inp = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else ""

FAMOUS_QUOTES = [
    {"text": "学而时习之，不亦说乎", "source": "《论语》", "author": "孔子", "trans": "Learning and practicing regularly, is that not a pleasure?"},
    {"text": "知之为知之，不知为不知，是知也", "source": "《论语》", "author": "孔子", "trans": "To know what you know and know what you do not know - that is true knowledge."},
    {"text": "天行健，君子以自强不息", "source": "《周易》", "author": "", "trans": "Heaven moves vigorously; the noble person strives unceasingly."},
    {"text": "路漫漫其修远兮，吾将上下而求索", "source": "《离骚》", "author": "屈原", "trans": "The road ahead is long; I shall search high and low."},
    {"text": "先天下之忧而忧，后天下之乐而乐", "source": "《岳阳楼记》", "author": "范仲淹", "trans": "Worry before the world worries; rejoice after the world rejoices."},
    {"text": "不以物喜，不以己悲", "source": "《岳阳楼记》", "author": "范仲淹", "trans": "Neither elated by external things nor saddened by personal setbacks."},
    {"text": "落霞与孤鹜齐飞，秋水共长天一色", "source": "《滕王阁序》", "author": "王勃", "trans": "Sunset clouds fly with the solitary duck; autumn waters merge with the endless sky."},
    {"text": "醉翁之意不在酒，在乎山水之间也", "source": "《醉翁亭记》", "author": "欧阳修", "trans": "The old drunkard cares not for wine, but for the mountains and waters."},
    {"text": "出师未捷身先死，长使英雄泪满襟", "source": "《蜀相》", "author": "杜甫", "trans": "Before victory, the hero fell; ever since, heroes weep."},
    {"text": "大漠孤烟直，长河落日圆", "source": "《使至塞上》", "author": "王维", "trans": "A lone plume of smoke rises straight from the vast desert; the sun sets round over the long river."},
    {"text": "人生自古谁无死，留取丹心照汗青", "source": "《过零丁洋》", "author": "文天祥", "trans": "Who has not died since ancient times? Let my loyal heart shine in history."},
    {"text": "千里之行，始于足下", "source": "《道德经》", "author": "老子", "trans": "A journey of a thousand miles begins with a single step."},
    {"text": "三人行，必有我师焉", "source": "《论语》", "author": "孔子", "trans": "Among three people walking, one must be my teacher."},
    {"text": "水至清则无鱼，人至察则无徒", "source": "《大戴礼记》", "author": "", "trans": "Water too clear has no fish; a person too strict has no friends."},
    {"text": "老骥伏枥，志在千里", "source": "《龟虽寿》", "author": "曹操", "trans": "An old horse in the stable still aspires to gallop a thousand miles."},
    {"text": "山不在高，有仙则名；水不在深，有龙则灵", "source": "《陋室铭》", "author": "刘禹锡", "trans": "Mountains need not be high if immortals dwell; waters need not be deep if dragons reside."},
    {"text": "世事洞明皆学问，人情练达即文章", "source": "《红楼梦》", "author": "曹雪芹", "trans": "Understanding the world is scholarship; mastering human relations is literature."},
    {"text": "天将降大任于斯人也，必先苦其心志", "source": "《孟子》", "author": "孟子", "trans": "Heaven, about to confer a great responsibility, first tests the will."},
    {"text": "己所不欲，勿施于人", "source": "《论语》", "author": "孔子", "trans": "Do not do unto others what you would not have them do unto you."},
    {"text": "锲而不舍，金石可镂", "source": "《荀子》", "author": "荀子", "trans": "With perseverance, even metal and stone can be carved."},
]

COMMON_WORDS = {
    "之": "of, it, go to (structural particle or pronoun)",
    "乎": "question particle; in, at",
    "者": "the one who; -er suffix",
    "也": "sentence-final particle (assertion)",
    "矣": "already; sentence-final (change of state)",
    "焉": "here, there; how; sentence particle",
    "哉": "exclamation particle (how...!)",
    "其": "his/her/its; that; should",
    "而": "and, but, yet (conjunction)",
    "则": "then, in that case",
    "以": "with, by means of; because",
    "于": "in, at, to, from, than",
    "为": "do, act as, be; for the sake of",
    "所": "place; that which (relative clause)",
    "与": "and, with; give",
    "曰": "said, spoke",
    "谓": "call, say, mean",
    "虽": "although, even though",
    "然": "so, thus; but, however; -ly suffix",
    "故": "therefore; old, former; reason",
}

DYNASTIES = [
    {"name": "先秦", "period": "~221 BC", "works": "《诗经》《楚辞》《论语》《孟子》《道德经》《庄子》《左传》", "style": "质朴简练，诸子百家"},
    {"name": "秦汉", "period": "221BC-220AD", "works": "《史记》《汉书》《古诗十九首》", "style": "雄浑大气，史传文学"},
    {"name": "魏晋", "period": "220-589", "works": "《世说新语》《陶渊明集》《文心雕龙》", "style": "清谈玄学，田园诗"},
    {"name": "唐", "period": "618-907", "works": "李白、杜甫、白居易、韩愈、柳宗元", "style": "诗歌鼎盛，古文运动"},
    {"name": "宋", "period": "960-1279", "works": "苏轼、欧阳修、辛弃疾、李清照", "style": "词的黄金期，理学散文"},
    {"name": "元明清", "period": "1271-1912", "works": "《三国》《水浒》《红楼梦》《聊斋》", "style": "小说戏曲，八股文"},
]

def cmd_quote():
    if inp:
        keyword = inp.strip()
        matches = [q for q in FAMOUS_QUOTES if keyword in q["text"] or keyword in q["source"] or keyword in q["author"]]
        if not matches:
            print("No matches for: {}".format(keyword))
            print("Try: 孔子, 论语, 天, 人生, etc.")
            return
    else:
        seed = int(hashlib.md5(datetime.now().strftime("%Y%m%d%H").encode()).hexdigest()[:8], 16)
        matches = [FAMOUS_QUOTES[seed % len(FAMOUS_QUOTES)]]

    for q in matches:
        print("=" * 55)
        print("  {}".format(q["text"]))
        print("  — {} {}".format(q["author"], q["source"]))
        print("  Translation: {}".format(q["trans"]))
        print("")

def cmd_word():
    if not inp:
        print("Usage: word <character>")
        print("Example: word 之")
        print("")
        print("Common classical Chinese function words:")
        for w, m in sorted(COMMON_WORDS.items()):
            print("  {} — {}".format(w, m))
        return

    char = inp.strip()
    if char in COMMON_WORDS:
        print("  {} — {}".format(char, COMMON_WORDS[char]))
        examples = [q for q in FAMOUS_QUOTES if char in q["text"]]
        if examples:
            print("")
            print("  Examples:")
            for e in examples[:3]:
                print("    {} ({})".format(e["text"], e["source"]))
    else:
        print("  {} — not in database".format(char))
        print("  Available: {}".format(" ".join(sorted(COMMON_WORDS.keys()))))

def cmd_dynasty():
    if inp:
        keyword = inp.strip()
        matches = [d for d in DYNASTIES if keyword in d["name"]]
        if matches:
            d = matches[0]
            print("=" * 50)
            print("  {} ({})".format(d["name"], d["period"]))
            print("=" * 50)
            print("  Style: {}".format(d["style"]))
            print("  Key works: {}".format(d["works"]))
            return

    print("=" * 55)
    print("  Chinese Literary History by Dynasty")
    print("=" * 55)
    print("")
    for d in DYNASTIES:
        print("  {:6s} {:15s} {}".format(d["name"], d["period"], d["style"]))
        print("         {}".format(d["works"]))
        print("")

def cmd_translate():
    if not inp:
        print("Usage: translate <classical_chinese_text>")
        print("Example: translate 学而时习之")
        return

    text = inp.strip()
    for q in FAMOUS_QUOTES:
        if text in q["text"] or q["text"] in text:
            print("  原文: {}".format(q["text"]))
            print("  出处: {} {}".format(q["author"], q["source"]))
            print("  译文: {}".format(q["trans"]))
            return

    print("  原文: {}".format(text))
    print("  [Translation not in database]")
    print("")
    print("  字词解析:")
    for char in text:
        if char in COMMON_WORDS:
            print("    {} — {}".format(char, COMMON_WORDS[char]))

commands = {
    "quote": cmd_quote, "word": cmd_word,
    "dynasty": cmd_dynasty, "translate": cmd_translate,
}
if cmd == "help":
    print("Classical Chinese Tool")
    print("")
    print("Commands:")
    print("  quote [keyword]        — Famous quotes (search or random)")
    print("  word [char]            — Word/character dictionary")
    print("  dynasty [name]         — Literary history by dynasty")
    print("  translate <text>       — Translate classical text")
elif cmd in commands:
    commands[cmd]()
else:
    print("Unknown: {}".format(cmd))
print("")
print("Powered by BytesAgain | bytesagain.com")
PYEOF
}
run_python "$CMD" $INPUT
