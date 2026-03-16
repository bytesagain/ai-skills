#!/usr/bin/env bash
# gaokao-essay: 高考作文生成器
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

CMD="${1:-help}"
shift 2>/dev/null || true

python3 - "$CMD" "$@" << 'PYTHON_EOF'
# -*- coding: utf-8 -*-
import sys
import random
from datetime import datetime

LQ = u'\u201c'
RQ = u'\u201d'

def show_help():
    print("""
=== 高考作文生成器 ===

用法:
  essay.sh write "题目" [--type 议论文|记叙文|材料作文]   生成完整作文
  essay.sh opening "主题"                                生成5个万能开头
  essay.sh ending "主题"                                 生成5个万能结尾
  essay.sh material "话题"                               作文素材库
  essay.sh structure "题目"                              3种议论文结构设计
  essay.sh score "作文文本"                              模拟评分(4维度)
  essay.sh help                                          显示此帮助
""".strip())

def write_essay(args):
    if not args:
        print("[错误] 请提供作文题目。用法: essay.sh write \"题目\" [--type 议论文]")
        sys.exit(1)

    title = args[0]
    essay_type = "议论文"
    for i, a in enumerate(args):
        if a == "--type" and i + 1 < len(args):
            essay_type = args[i + 1]

    if essay_type == "议论文":
        content = gen_yilun(title)
    elif essay_type == "记叙文":
        content = gen_jixu(title)
    elif essay_type == "材料作文":
        content = gen_cailiao(title)
    else:
        content = gen_yilun(title)

    print("=" * 60)
    print("  题目：{}".format(title))
    print("  类型：{}".format(essay_type))
    print("=" * 60)
    print()
    print(content)
    print()
    print("-" * 60)
    print("字数统计：约 {} 字".format(len(content.replace(" ", "").replace("\n", ""))))
    print("生成时间：{}".format(datetime.now().strftime("%Y-%m-%d %H:%M")))

def gen_yilun(title):
    openings = [
        '古人云：{lq}路漫漫其修远兮，吾将上下而求索。{rq}关于{lq}{t}{rq}这一话题，自古以来便是无数仁人志士思考的命题。在当今社会，它更具有深远的现实意义。'.format(lq=LQ, rq=RQ, t=title),
        '翻开历史的长卷，{lq}{t}{rq}如同一根金线，贯穿于人类文明发展的每一个篇章。从先秦诸子到当代思想家，这一主题始终焕发着永恒的光芒。'.format(lq=LQ, rq=RQ, t=title),
        '有人说，人生最重要的不是所站的位置，而是所朝的方向。当我们面对{lq}{t}{rq}这个话题时，不禁陷入深深的思考。'.format(lq=LQ, rq=RQ, t=title),
    ]
    bodies = [
        ('\n\n诚然，{lq}{t}{rq}的意义在于它揭示了一个深刻的道理：任何伟大的成就都不是一蹴而就的。'
         '正如司马迁忍辱负重，耗费十三年心血著成《史记》；正如曹雪芹{lq}披阅十载，增删五次{rq}方成《红楼梦》。'
         '他们用行动诠释了{lq}{t}{rq}的真谛。'
         '\n\n反观当下，快节奏的生活让许多人迷失了方向。有人急功近利，有人浅尝辄止，有人随波逐流。'
         '殊不知，正是这种浮躁的心态，让我们与{lq}{t}{rq}的精神背道而驰。'
         '\n\n然而，我们也欣喜地看到，新时代的青年正在用自己的方式践行{lq}{t}{rq}的理念。'
         '从科研实验室里日夜攻关的年轻学者，到扎根基层默默奉献的青年志愿者，'
         '他们用实际行动证明：{lq}{t}{rq}不是空洞的口号，而是脚踏实地的坚守。').format(t=title, lq=LQ, rq=RQ),
    ]
    endings = [
        ('\n\n鲁迅先生曾说：{lq}世上本没有路，走的人多了，也便成了路。{rq}'
         '让我们以{lq}{t}{rq}为航标，在人生的征途上砥砺前行。'
         '唯有如此，方能不负韶华，不负时代，书写属于我们这一代人的壮丽篇章。').format(t=title, lq=LQ, rq=RQ),
    ]
    return random.choice(openings) + random.choice(bodies) + random.choice(endings)

def gen_jixu(title):
    parts = []
    parts.append('那是一个平凡的午后，阳光透过窗帘的缝隙，在地板上投下斑驳的光影。'
                 '关于{lq}{t}{rq}的记忆，就从这一刻开始蔓延。'.format(t=title, lq=LQ, rq=RQ))
    parts.append('')
    parts.append('那天，我正坐在书桌前发呆，窗外的梧桐树在微风中沙沙作响。忽然，一件小事打破了这份宁静——')
    parts.append('')
    parts.append('奶奶推门进来，手里端着一碗热气腾腾的银耳汤。她的步伐很慢，每一步都小心翼翼，'
                 '生怕洒出哪怕一滴。{lq}天热，喝点汤解解暑。{rq}她笑着说，眼角的皱纹里藏着温柔。'.format(lq=LQ, rq=RQ))
    parts.append('')
    parts.append('那一刻，我忽然理解了{lq}{t}{rq}的含义。它不是什么轰轰烈烈的壮举，'
                 '而是藏在日常琐碎中的点滴温暖。是奶奶端来的一碗汤，是母亲深夜为我掖好的被角，'
                 '是父亲沉默却有力的目光。'.format(t=title, lq=LQ, rq=RQ))
    parts.append('')
    parts.append('我想起小时候，也是这样的午后，奶奶教我写字。她握着我的手，一笔一划地写下{lq}人{rq}字。'
                 '{lq}你看，{rq}她指着纸上的字说，{lq}{sq}人{sq}字只有两笔，一撇一捺，互相支撑才能站稳。{rq}'.format(lq=LQ, rq=RQ, sq="'"))
    parts.append('')
    parts.append('如今回想，那何尝不是关于{lq}{t}{rq}最朴素的启蒙？'.format(t=title, lq=LQ, rq=RQ))
    parts.append('')
    parts.append('日子一天天过去，我渐渐长大，奶奶渐渐变老。'
                 '但那碗银耳汤的温度，那个关于{lq}人{rq}字的道理，却始终温暖着我前行的路。'.format(lq=LQ, rq=RQ))
    parts.append('')
    parts.append('也许，{lq}{t}{rq}就是这样——不必惊天动地，只需在平凡的日子里，'
                 '用心感受，用爱回应。这便是生活给予我们最珍贵的馈赠。'.format(t=title, lq=LQ, rq=RQ))
    return '\n'.join(parts)

def gen_cailiao(title):
    parts = []
    parts.append('【材料引入】')
    parts.append('')
    parts.append('关于{lq}{t}{rq}，有这样一则材料引人深思：'.format(t=title, lq=LQ, rq=RQ))
    parts.append('')
    parts.append('一位老农在田间劳作，路人问他：{lq}您种了一辈子地，最大的收获是什么？{rq}'
                 '老农想了想说：{lq}我最大的收获，是学会了等待。种子埋下去，不能天天挖出来看，'
                 '你得相信它会发芽。{rq}'.format(lq=LQ, rq=RQ))
    parts.append('')
    parts.append('这段朴素的对话，恰恰道出了{lq}{t}{rq}的深层哲理。'.format(t=title, lq=LQ, rq=RQ))
    parts.append('')
    parts.append('【立意分析】')
    parts.append('')
    parts.append('从这则材料中，我们可以提炼出以下观点：其一，成长需要耐心，不能急于求成；'
                 '其二，信念的力量在于坚守，而非怀疑；其三，过程比结果更重要。')
    parts.append('')
    parts.append('三者之中，我认为最核心的启示是：{lq}{t}{rq}的本质在于——'
                 '真正有价值的事物，都需要时间的沉淀和耐心的浇灌。'.format(t=title, lq=LQ, rq=RQ))
    parts.append('')
    parts.append('【论证展开】')
    parts.append('')
    parts.append('纵观古今中外，无数事例印证了这一道理。')
    parts.append('')
    parts.append('达尔文花了二十年时间观察、记录、思考，才写出《物种起源》，颠覆了人类对生命的认知。'
                 '屠呦呦历经数百次实验失败，最终从青蒿中提取出青蒿素，拯救了数百万疟疾患者的生命。'
                 '他们的故事告诉我们：{lq}{t}{rq}从来不是一蹴而就的。'.format(t=title, lq=LQ, rq=RQ))
    parts.append('')
    parts.append('反面的例子同样值得警醒。方仲永少年天才，却因急功近利而{lq}泯然众人{rq}；'
                 '赵括纸上谈兵，空有理论而无实践积累，最终兵败长平。'
                 '急躁与浮躁，是{lq}{t}{rq}道路上最大的敌人。'.format(t=title, lq=LQ, rq=RQ))
    parts.append('')
    parts.append('【联系现实】')
    parts.append('')
    parts.append('当下社会，{lq}快餐文化{rq}{lq}速成班{rq}{lq}一夜暴富{rq}的思维弥漫。'
                 '然而，真正的学问、真正的能力、真正的人格魅力，哪一样不是日积月累的结果？'.format(lq=LQ, rq=RQ))
    parts.append('')
    parts.append('作为新时代的青年，我们更应该从材料中汲取智慧：'
                 '像老农一样，把种子埋好，然后耐心等待它生根、发芽、开花、结果。')
    parts.append('')
    parts.append('【总结升华】')
    parts.append('')
    parts.append('正如那位老农所言，学会等待，是一种智慧，更是一种信仰。'
                 '在{lq}{t}{rq}的道路上，让我们怀揣信念，脚踏实地，静待花开。'.format(t=title, lq=LQ, rq=RQ))
    return '\n'.join(parts)

def opening(args):
    if not args:
        print("[错误] 请提供主题。用法: essay.sh opening \"主题\"")
        sys.exit(1)
    topic = args[0]
    templates = [
        '【引用式开头】\n{lq}路漫漫其修远兮，吾将上下而求索。{rq}{t}，是人生旅途中一个永恒的话题。它如同夜空中最亮的星，指引着我们前行的方向。'.format(t=topic, lq=LQ, rq=RQ),
        '【设问式开头】\n何为{t}？是风雨中的坚守，还是困境里的突围？是默默无闻的耕耘，还是厚积薄发的绽放？不同的人或许有不同的回答，但有一点是相通的——{t}赋予了生命以意义。'.format(t=topic),
        '【排比式开头】\n{t}是春天里破土的嫩芽，蕴含着无限生机；{t}是夏日中奔涌的溪流，承载着不竭动力；{t}是秋风里成熟的果实，凝聚着汗水与智慧；{t}是冬雪下沉睡的种子，孕育着来年的希望。'.format(t=topic),
        '【对比式开头】\n有人说，{t}是强者的勋章；也有人说，{t}是弱者的枷锁。然而在我看来，{t}既非勋章，也非枷锁，而是每个人必须面对的人生课题。关键不在于它是什么，而在于我们如何看待它、如何践行它。'.format(t=topic),
        '【故事式开头】\n记得有这样一个故事：一个年轻人向智者请教{t}的秘诀。智者没有说话，而是带他来到一片竹林。{lq}你看这竹子，{rq}智者说，{lq}前四年只长了三厘米，但从第五年开始，每天能长三十厘米。{rq}年轻人恍然大悟——原来关于{t}，最重要的是沉淀与坚持。'.format(t=topic, lq=LQ, rq=RQ),
    ]
    print("=" * 60)
    print("  主题「{}」的5个万能开头".format(topic))
    print("=" * 60)
    for i, t in enumerate(templates, 1):
        print("\n{}. {}".format(i, t))
        print()

def ending(args):
    if not args:
        print("[错误] 请提供主题。用法: essay.sh ending \"主题\"")
        sys.exit(1)
    topic = args[0]
    templates = [
        '【引用式结尾】\n正如泰戈尔所言：{lq}不是锤的打击，而是水的载歌载舞，才使鹅卵石臻于完美。{rq}关于{t}，让我们以水的姿态，在岁月的长河中，打磨出属于自己的光芒。'.format(t=topic, lq=LQ, rq=RQ),
        '【展望式结尾】\n站在时代的潮头，回望来路，我们因{t}而充实；展望未来，我们因{t}而坚定。愿每一位青年都能以{t}为翼，翱翔在广阔的天空，书写无愧于时代的华章。'.format(t=topic),
        '【呼吁式结尾】\n{t}不是一句空洞的口号，而是需要我们用行动去践行的信念。让我们从现在做起，从点滴做起，将{t}的精神融入生活的每一天，共同创造更加美好的明天！'.format(t=topic),
        '【哲理式结尾】\n花开有时，落叶有声。关于{t}，也许我们无法给出一个标准答案。但正是在不断追问与探索的过程中，我们收获了成长，收获了智慧，收获了人生最宝贵的财富。这，便是{t}的意义所在。'.format(t=topic),
        '【回扣式结尾】\n行文至此，关于{t}的思考已然清晰。它不仅是个人修养的体现，更是社会进步的基石。让我们铭记：{t}之路虽远，行则将至；{t}之事虽难，做则必成。'.format(t=topic),
    ]
    print("=" * 60)
    print("  主题「{}」的5个万能结尾".format(topic))
    print("=" * 60)
    for i, t in enumerate(templates, 1):
        print("\n{}. {}".format(i, t))
        print()

def material(args):
    if not args:
        print("[错误] 请提供话题。用法: essay.sh material \"话题\"")
        sys.exit(1)
    topic = args[0]

    quotes = [
        {"author": "鲁迅", "quote": "世上本没有路，走的人多了，也便成了路。", "usage": "适用于开拓、创新、勇气类话题"},
        {"author": "屈原", "quote": "路漫漫其修远兮，吾将上下而求索。", "usage": "适用于坚持、求索、理想类话题"},
        {"author": "苏轼", "quote": "古之成大事者，不惟有超世之才，亦必有坚忍不拔之志。", "usage": "适用于毅力、成功、意志类话题"},
        {"author": "泰戈尔", "quote": "你今天受的苦，吃的亏，担的责，扛的罪，忍的痛，到最后都会变成光，照亮你的路。", "usage": "适用于磨难、成长、逆境类话题"},
        {"author": "爱因斯坦", "quote": "想象力比知识更重要，因为知识是有限的，而想象力概括着世界的一切。", "usage": "适用于创新、想象、突破类话题"},
        {"author": "孟子", "quote": "天将降大任于斯人也，必先苦其心志，劳其筋骨。", "usage": "适用于磨炼、担当、成长类话题"},
        {"author": "王阳明", "quote": "知是行之始，行是知之成。", "usage": "适用于知行合一、实践、行动类话题"},
        {"author": "曾国藩", "quote": "坚其志，苦其心，劳其力，事无大小，必有所成。", "usage": "适用于勤奋、坚持、成功类话题"},
    ]

    examples = [
        {"person": "司马迁", "event": "遭受宫刑后忍辱负重，耗费13年写成《史记》", "tag": "坚持、逆境、意志"},
        {"person": "屠呦呦", "event": "历经190多次失败，从青蒿中提取青蒿素，获诺贝尔奖", "tag": "坚持、科学、创新"},
        {"person": "苏轼", "event": "一生三次被贬，却写出大江东去的豪迈词篇", "tag": "乐观、逆境、豁达"},
        {"person": "袁隆平", "event": "扎根田间数十年，培育杂交水稻，解决亿万人温饱", "tag": "奉献、坚持、责任"},
        {"person": "钱学森", "event": "放弃美国优厚待遇，冲破重重阻碍回国，奠基中国航天", "tag": "爱国、选择、奉献"},
        {"person": "张桂梅", "event": "扎根山区创办女子高中，帮助上千名贫困女孩改变命运", "tag": "教育、奉献、坚守"},
        {"person": "勾践", "event": "卧薪尝胆，十年生聚，终灭吴国完成复国大业", "tag": "忍耐、坚持、逆袭"},
        {"person": "居里夫人", "event": "在简陋实验室中提炼出镭，两获诺贝尔奖", "tag": "坚持、科学、专注"},
    ]

    print("=" * 60)
    print("  话题「{}」的作文素材库".format(topic))
    print("=" * 60)

    print("\n【名人名言】\n")
    selected_quotes = random.sample(quotes, min(5, len(quotes)))
    for i, q in enumerate(selected_quotes, 1):
        print("{}. {}{}{}".format(i, LQ, q["quote"], RQ))
        print("   -- {}".format(q["author"]))
        print("   {}".format(q["usage"]))
        print()

    print("\n【经典事例】\n")
    selected_examples = random.sample(examples, min(5, len(examples)))
    for i, e in enumerate(selected_examples, 1):
        print("{}. {}：{}".format(i, e["person"], e["event"]))
        print("   适用标签：{}".format(e["tag"]))
        print()

    print("\n【运用示范】\n")
    ex = random.choice(selected_examples)
    print("将「{}」素材融入「{}」话题的示范段落：".format(ex["person"], topic))
    print()
    print("谈及{}，不禁让人想起{}的故事。{}。这段经历告诉我们，{}从来不是轻而易举的事情，"
          "它需要超乎常人的毅力与信念。正是这种精神，成为了照亮前行之路的火炬。".format(
        topic, ex["person"], ex["event"], topic
    ))

def main():
    args = sys.argv[1:]
    if not args:
        show_help()
        return

    cmd = args[0]
    rest = args[1:]

    if cmd == "help":
        show_help()
    elif cmd == "write":
        write_essay(rest)
    elif cmd == "opening":
        opening(rest)
    elif cmd == "ending":
        ending(rest)
    elif cmd == "material":
        material(rest)
    else:
        print("[错误] 未知命令: {}".format(cmd))
        show_help()
        sys.exit(1)

if __name__ == "__main__":
    main()
PYTHON_EOF

echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
