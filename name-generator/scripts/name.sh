#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

CMD="${1:-help}"
shift 2>/dev/null || true

show_help() {
cat << 'EOF'
✨ 起名取名助手

用法:
  name.sh baby "姓" [--gender 男|女|中性]   宝宝起名(5个)
  name.sh english "中文名"                  英文名推荐
  name.sh brand "行业" "调性"               品牌名生成
  name.sh pen "风格"                        笔名/网名
  name.sh meaning "字"                      字义查询(五行/笔画/含义)
  name.sh batch "姓" "性别" "风格"          批量生成(10个+含义+评分)
  name.sh help                              显示帮助
EOF
}

case "$CMD" in
  baby|english|brand|pen|meaning|batch)
    python3 -c "
import sys, random, hashlib, time

cmd = sys.argv[1]
args = sys.argv[2:]

# Use time-based seed for variety
random.seed(int(time.time()) ^ hash(str(args)))

if cmd == 'baby':
    if len(args) < 1:
        print('用法: name.sh baby \"姓\" [--gender 男|女|中性]')
        sys.exit(1)
    surname = args[0]
    gender = '中性'
    for i, a in enumerate(args):
        if a == '--gender' and i + 1 < len(args):
            gender = args[i + 1]

    # 名字库: (字, 含义)
    male_chars = [
        ('宇', '宇宙浩瀚，胸襟开阔'),
        ('轩', '气宇轩昂，风度翩翩'),
        ('泽', '恩泽广被，润物无声'),
        ('铭', '铭记于心，志向远大'),
        ('瑞', '祥瑞之兆，吉祥如意'),
        ('晨', '晨光熹微，朝气蓬勃'),
        ('博', '博学多才，见多识广'),
        ('睿', '聪慧睿智，明察秋毫'),
        ('翰', '翰墨飘香，文采斐然'),
        ('煜', '光明照耀，辉煌灿烂'),
        ('辰', '星辰大海，志存高远'),
        ('景', '前程似景，光明磊落'),
        ('承', '承前启后，薪火相传'),
        ('逸', '超凡脱俗，闲适自在'),
        ('恒', '持之以恒，坚定不移'),
        ('谦', '谦虚谨慎，温润如玉'),
        ('澄', '澄澈明净，心如止水'),
        ('彦', '才学出众，美士之称'),
        ('昊', '昊天广阔，志在四方'),
        ('哲', '哲思深远，明辨是非'),
    ]

    female_chars = [
        ('悦', '悦目赏心，快乐喜悦'),
        ('婉', '温婉可人，柔美动听'),
        ('诗', '诗情画意，才情横溢'),
        ('萱', '萱草忘忧，快乐无忧'),
        ('瑶', '美玉瑶光，珍贵美好'),
        ('芷', '芷兰芬芳，品格高洁'),
        ('琳', '美玉琳琅，温润高雅'),
        ('梦', '梦想成真，浪漫美好'),
        ('颖', '聪颖灵慧，出类拔萃'),
        ('雅', '温雅端庄，高雅不俗'),
        ('思', '思维敏捷，聪慧伶俐'),
        ('清', '清新脱俗，纯净美好'),
        ('若', '若水柔情，淡然从容'),
        ('晴', '晴空万里，开朗乐观'),
        ('舒', '舒适自在，从容不迫'),
        ('瑾', '美玉之光，品德高尚'),
        ('韵', '韵味悠长，优雅不凡'),
        ('锦', '锦绣前程，美好灿烂'),
        ('沐', '沐浴春风，温暖和煦'),
        ('安', '安宁祥和，平安喜乐'),
    ]

    neutral_chars = [
        ('安', '安宁祥和，平安喜乐'),
        ('瑞', '祥瑞之兆，吉祥如意'),
        ('晨', '晨光熹微，朝气蓬勃'),
        ('逸', '超凡脱俗，闲适自在'),
        ('禾', '禾苗生长，生机勃勃'),
        ('然', '自然洒脱，坦然从容'),
        ('清', '清新脱俗，纯净美好'),
        ('沐', '沐浴春风，温暖和煦'),
        ('知', '知书达理，聪慧通达'),
        ('乐', '快乐幸福，乐观向上'),
    ]

    if gender == '男':
        pool = male_chars
    elif gender == '女':
        pool = female_chars
    else:
        pool = neutral_chars

    # 双字名组合
    combos = []
    chars_used = set()
    attempts = 0
    while len(combos) < 5 and attempts < 100:
        attempts += 1
        c1 = random.choice(pool)
        c2 = random.choice(pool)
        if c1[0] != c2[0] and (c1[0], c2[0]) not in chars_used:
            chars_used.add((c1[0], c2[0]))
            combos.append((c1, c2))

    # 也生成单字名
    singles = random.sample(pool, min(2, len(pool)))

    print('=' * 50)
    gender_emoji = {'男': '👦', '女': '👧', '中性': '🌟'}
    print('{emoji} {surname}姓宝宝起名推荐 ({gender})'.format(
        emoji=gender_emoji.get(gender, '🌟'), surname=surname, gender=gender))
    print('=' * 50)
    print()

    print('📝 双字名推荐:')
    print()
    for i, (c1, c2) in enumerate(combos[:5], 1):
        name = '{surname}{c1}{c2}'.format(surname=surname, c1=c1[0], c2=c2[0])
        print('  {i}. 🏷️ {name}'.format(i=i, name=name))
        print('     {c1_char}: {c1_mean}'.format(c1_char=c1[0], c1_mean=c1[1]))
        print('     {c2_char}: {c2_mean}'.format(c2_char=c2[0], c2_mean=c2[1]))
        print('     寓意: {c1_m}，{c2_m}'.format(
            c1_m=c1[1].split('，')[0], c2_m=c2[1].split('，')[0]))
        print()

    print('📝 单字名推荐:')
    for s in singles:
        name = '{surname}{c}'.format(surname=surname, c=s[0])
        print('  🏷️ {name} — {mean}'.format(name=name, mean=s[1]))
    print()

    print('💡 起名建议:')
    print('  • 注意与姓氏搭配的声调和谐')
    print('  • 避免谐音歧义')
    print('  • 笔画不宜过多(方便书写)')
    print('  • 避免与长辈重名')

elif cmd == 'english':
    if len(args) < 1:
        print('用法: name.sh english \"中文名\"')
        sys.exit(1)
    cn_name = args[0]

    # 根据中文名首字推荐音近的英文名
    initial_map = {
        '张': ['James', 'Jason', 'Jane', 'Jasmine'],
        '王': ['William', 'Wendy', 'Wayne', 'Willa'],
        '李': ['Leo', 'Lily', 'Lucas', 'Linda'],
        '刘': ['Leo', 'Lucy', 'Luke', 'Leah'],
        '陈': ['Charles', 'Chris', 'Chelsea', 'Charlotte'],
        '杨': ['Yolanda', 'Yvonne', 'Yale', 'York'],
        '赵': ['Zoe', 'Zachary', 'Zara', 'Zen'],
        '黄': ['Hugo', 'Helen', 'Henry', 'Hannah'],
        '周': ['Joe', 'Joy', 'John', 'Joanne'],
        '吴': ['Woody', 'Winnie', 'Walter', 'Wren'],
        '徐': ['Xavier', 'Sherry', 'Sean', 'Stella'],
        '孙': ['Sunny', 'Samuel', 'Sandy', 'Simon'],
        '马': ['Mark', 'Mary', 'Max', 'Maya'],
        '朱': ['Julia', 'Justin', 'Judy', 'June'],
        '林': ['Lynn', 'Linda', 'Liam', 'Luna'],
        '曹': ['Calvin', 'Carl', 'Carol', 'Cathy'],
    }

    char_map = {
        '明': ['Bright', 'Raymond'],
        '华': ['Howard', 'Flora'],
        '伟': ['David', 'Victor'],
        '芳': ['Fanny', 'Florence'],
        '丽': ['Lily', 'Lisa'],
        '强': ['Charles', 'Chase'],
        '英': ['Ingrid', 'Ian'],
        '杰': ['Jack', 'Jay'],
        '文': ['Vincent', 'Vivian'],
        '美': ['May', 'Maggie'],
        '慧': ['Hope', 'Hazel'],
        '婷': ['Tiffany', 'Tina'],
        '雪': ['Snow', 'Shirley'],
        '琳': ['Lynn', 'Linda'],
        '瑞': ['Ray', 'Rachel'],
        '欣': ['Cindy', 'Chloe'],
    }

    # 通用热门英文名
    popular_male = ['Alexander', 'Benjamin', 'Daniel', 'Ethan', 'Nathan', 'Oliver', 'Ryan', 'Tyler', 'Vincent', 'Kevin']
    popular_female = ['Amber', 'Bella', 'Claire', 'Diana', 'Emily', 'Grace', 'Isabella', 'Natalie', 'Olivia', 'Sophia']

    surname = cn_name[0] if len(cn_name) > 0 else ''
    given = cn_name[1:] if len(cn_name) > 1 else ''

    print('=' * 50)
    print('🌍 {cn}的英文名推荐'.format(cn=cn_name))
    print('=' * 50)
    print()

    # 音近推荐
    if surname in initial_map:
        print('🔤 与姓氏\"{s}\"音近:'.format(s=surname))
        for n in initial_map[surname]:
            print('  • {name} ({cn} → {name})'.format(name=n, cn=surname))
        print()

    # 名字含义相关
    found = False
    for ch in given:
        if ch in char_map:
            if not found:
                print('💡 与名字含义相关:')
                found = True
            for n in char_map[ch]:
                print('  • {name} (对应\"{ch}\")'.format(name=n, ch=ch))
    if found:
        print()

    # 热门推荐
    print('⭐ 热门英文名推荐:')
    print('  男: {names}'.format(names=', '.join(random.sample(popular_male, 5))))
    print('  女: {names}'.format(names=', '.join(random.sample(popular_female, 5))))
    print()

    print('💡 选英文名建议:')
    print('  • 发音简单，外国人容易读')
    print('  • 避免与常见单词撞名')
    print('  • 可参考音近或意近的方式')
    print('  • 国际化场合建议避免太生僻的名字')

elif cmd == 'brand':
    if len(args) < 2:
        print('用法: name.sh brand \"行业\" \"调性\"')
        sys.exit(1)
    industry, tone = args[0], args[1]

    # 品牌名生成模式
    prefixes = {
        '科技': ['芯', '智', '云', '码', '数', '灵', '创', '微', '极', '量'],
        '餐饮': ['味', '鲜', '香', '膳', '食', '厨', '禾', '谷', '品', '珍'],
        '教育': ['启', '慧', '学', '智', '书', '知', '文', '博', '思', '育'],
        '时尚': ['衣', '裳', '锦', '绣', '潮', '范', '型', '美', '雅', '尚'],
        '健康': ['康', '寿', '元', '养', '安', '益', '和', '清', '润', '源'],
        '金融': ['信', '汇', '融', '盈', '丰', '瑞', '恒', '兴', '昌', '泰'],
    }

    suffixes = {
        '高端': ['铂', '鼎', '御', '璟', '阁', '荟'],
        '年轻': ['趣', '乐', '酷', '嗨', '范', '派'],
        '专业': ['研', '精', '匠', '典', '正', '臻'],
        '温暖': ['暖', '心', '家', '伴', '爱', '馨'],
        '简约': ['一', '初', '简', '素', '白', '本'],
        '国际': ['国际', '环球', '世纪', '全球', '世界', '天下'],
    }

    eng_parts = {
        '科技': ['Tech', 'Lab', 'Core', 'Nova', 'Sync', 'Link', 'Bit', 'Net'],
        '餐饮': ['Taste', 'Chef', 'Bite', 'Dish', 'Feast', 'Flavor', 'Fresh'],
        '教育': ['Edu', 'Mind', 'Learn', 'Think', 'Know', 'Wise', 'Spark'],
        '时尚': ['Style', 'Mode', 'Chic', 'Luxe', 'Vogue', 'Trend', 'Aura'],
        '健康': ['Vita', 'Pure', 'Well', 'Care', 'Life', 'Zen', 'Glow'],
        '金融': ['Cap', 'Fin', 'Trust', 'Prime', 'Apex', 'Vault', 'Peak'],
    }

    pres = prefixes.get(industry, list(prefixes.values())[0])
    sufs = suffixes.get(tone, list(suffixes.values())[0])
    engs = eng_parts.get(industry, list(eng_parts.values())[0])

    print('=' * 50)
    print('🏢 品牌名推荐 — {industry} × {tone}'.format(industry=industry, tone=tone))
    print('=' * 50)
    print()

    # 中文品牌名
    print('🇨🇳 中文品牌名:')
    cn_names = set()
    while len(cn_names) < 5:
        p = random.choice(pres)
        s = random.choice(sufs)
        n = p + s
        cn_names.add(n)

    for i, n in enumerate(cn_names, 1):
        print('  {i}. {name}'.format(i=i, name=n))
    print()

    # 英文品牌名
    print('🌐 英文品牌名:')
    en_names = set()
    while len(en_names) < 5:
        parts = random.sample(engs, 2)
        n = parts[0] + parts[1]
        en_names.add(n)
    for i, n in enumerate(en_names, 1):
        print('  {i}. {name}'.format(i=i, name=n))
    print()

    # 中英结合
    print('🔀 中英结合:')
    for i in range(3):
        cn = random.choice(pres) + random.choice(sufs)
        en = random.choice(engs)
        print('  {i}. {cn} ({en})'.format(i=i+1, cn=cn, en=en))
    print()

    print('💡 品牌命名建议:')
    print('  • 简短好记（2-4个字/音节为佳）')
    print('  • 确认商标是否可注册')
    print('  • 检查域名和社交媒体是否可用')
    print('  • 避免歧义和负面联想')

elif cmd == 'pen':
    if len(args) < 1:
        print('用法: name.sh pen \"风格\"')
        sys.exit(1)
    style = args[0]

    names = {
        '文艺': [
            ('清欢渡', '取自苏轼\"人间有味是清欢\"，淡然文艺'),
            ('半山听雨', '山间听雨，诗意生活'),
            ('南风知我意', '温柔的南风，懂我心意'),
            ('一盏浮生', '浮生若梦，一盏清茶'),
            ('花事了', '花开花落，淡看人生'),
            ('且听风吟', '聆听风声，悠然自得'),
            ('墨染青衫', '文人墨客，清雅风骨'),
        ],
        '古风': [
            ('长安故人', '长安城里的旧时光'),
            ('醉卧云端', '飘逸洒脱，仙气飘飘'),
            ('折戟沉沙', '壮志豪情，英雄气概'),
            ('青衫烟雨', '烟雨江南，翩翩公子'),
            ('剑归来', '江湖侠客，快意人生'),
            ('霜华满袖', '清冷高洁，不染尘埃'),
            ('夜阑珊', '夜深人静，灯火阑珊'),
        ],
        '搞笑': [
            ('我不是胖是膨胀', '自嘲式幽默'),
            ('佛系摸鱼达人', '躺平哲学'),
            ('一只咸鱼翻了身', '还是咸鱼'),
            ('学废了学废了', '自黑型学习者'),
            ('今天也想躺平', '每天的心声'),
            ('脑子进水养鱼了', '自嘲脑回路清奇'),
            ('人间清醒(并没有)', '反差萌'),
        ],
        '简约': [
            ('一', '大道至简'),
            ('三木', '拆字游戏，\"森\"'),
            ('不二', '独一无二'),
            ('且慢', '慢下来，享受生活'),
            ('也好', '一切都也好'),
            ('如是', '如是而已，简单纯粹'),
            ('无题', '无需标题，内容为王'),
        ],
        '英文': [
            ('Wanderlust', '对旅行的热爱与向往'),
            ('Moonchild', '月亮之子，浪漫神秘'),
            ('Daydreamer', '白日梦想家'),
            ('Echoes', '回响，思想的回声'),
            ('Starfall', '星陨，璀璨而短暂'),
            ('Neverland', '永无岛，永远的童心'),
            ('Serendipity', '美好的意外发现'),
        ],
    }

    pool = names.get(style, names['文艺'])
    selected = random.sample(pool, min(5, len(pool)))

    print('=' * 50)
    print('✍️  {style}风格笔名/网名推荐'.format(style=style))
    print('=' * 50)
    print()

    for i, (name, meaning) in enumerate(selected, 1):
        print('  {i}. 🏷️ {name}'.format(i=i, name=name))
        print('     💬 {meaning}'.format(meaning=meaning))
        print()

    all_styles = list(names.keys())
    other = [s for s in all_styles if s != style]
    print('🎨 其他风格可选: {styles}'.format(styles=' / '.join(other)))
    print()
    print('💡 取名建议:')
    print('  • 容易被记住比容易被理解更重要')
    print('  • 避免与大V/知名博主撞名')
    print('  • 搜索一下确认没有负面关联')
    print('  • 考虑跨平台统一使用')

elif cmd == 'meaning':
    if len(args) < 1:
        print('用法: name.sh meaning \"字\"')
        sys.exit(1)
    char = args[0]

    # 常用取名字字义库
    char_db = {
        '宇': {'五行': '土', '笔画': 6, '含义': '屋檐,引申为浩瀚宇宙、气度不凡', '寓意': '胸怀广阔，志向远大', '搭配': '浩宇、天宇、宇轩、宇泽、宇航'},
        '轩': {'五行': '土', '笔画': 10, '含义': '高大、轩昂，古代有窗的长廊', '寓意': '气宇轩昂，风度翩翩', '搭配': '子轩、浩轩、宇轩、俊轩、梓轩'},
        '泽': {'五行': '水', '笔画': 17, '含义': '水聚集处,恩惠、润泽', '寓意': '恩泽广被，润物无声', '搭配': '浩泽、宇泽、泽宇、恩泽、润泽'},
        '铭': {'五行': '金', '笔画': 14, '含义': '在器物上刻字,记住不忘', '寓意': '铭记于心，志向坚定', '搭配': '铭轩、铭泽、铭瑞、铭哲、铭远'},
        '瑞': {'五行': '金', '笔画': 14, '含义': '古代信物玉器,吉祥之意', '寓意': '祥瑞之兆，吉祥如意', '搭配': '瑞泽、铭瑞、瑞轩、嘉瑞、祥瑞'},
        '晨': {'五行': '金', '笔画': 11, '含义': '清晨、早上的阳光', '寓意': '朝气蓬勃，充满希望', '搭配': '晨曦、晨阳、晨宇、晨轩、晨熙'},
        '博': {'五行': '水', '笔画': 12, '含义': '大而广,多而广', '寓意': '博学多才，见多识广', '搭配': '博文、博宇、博远、博雅、博瀚'},
        '睿': {'五行': '金', '笔画': 14, '含义': '深明、通达,智慧', '寓意': '聪慧睿智，明察秋毫', '搭配': '睿泽、睿轩、睿博、睿哲、睿思'},
        '悦': {'五行': '金', '笔画': 11, '含义': '高兴、喜悦、愉悦', '寓意': '快乐开朗，心情舒畅', '搭配': '悦然、悦心、悦彤、悦琳、欣悦'},
        '婉': {'五行': '土', '笔画': 11, '含义': '柔顺、美好、和婉', '寓意': '温婉可人，柔美动听', '搭配': '婉清、婉如、婉仪、婉柔、静婉'},
        '诗': {'五行': '金', '笔画': 13, '含义': '诗歌、文学之美', '寓意': '诗情画意，才情横溢', '搭配': '诗涵、诗琪、诗雅、诗韵、诗瑶'},
        '萱': {'五行': '木', '笔画': 15, '含义': '萱草,忘忧之花,代表母爱', '寓意': '快乐无忧，美丽温暖', '搭配': '紫萱、雨萱、萱萱、梓萱、萱琪'},
        '瑶': {'五行': '火', '笔画': 15, '含义': '美玉,传说中的仙境之玉', '寓意': '美丽珍贵，光彩照人', '搭配': '瑶琴、梦瑶、瑶瑶、紫瑶、瑶华'},
        '浩': {'五行': '水', '笔画': 11, '含义': '水大、广大、盛大', '寓意': '浩然正气，气度非凡', '搭配': '浩然、浩宇、浩轩、浩泽、浩博'},
        '辰': {'五行': '土', '笔画': 7, '含义': '日月星辰,时光', '寓意': '星辰大海，志存高远', '搭配': '星辰、辰宇、辰轩、辰逸、辰熙'},
        '梓': {'五行': '木', '笔画': 11, '含义': '梓树,故乡的代称', '寓意': '生机勃勃，热爱故土', '搭配': '梓涵、梓轩、梓萱、梓豪、梓琪'},
        '涵': {'五行': '水', '笔画': 12, '含义': '包容、包含、涵养', '寓意': '学识渊博，涵养深厚', '搭配': '梓涵、诗涵、子涵、雨涵、涵宇'},
        '安': {'五行': '土', '笔画': 6, '含义': '安定、平安、安宁', '寓意': '安宁祥和，平安喜乐', '搭配': '安然、安宁、安琪、安晴、安澜'},
        '琪': {'五行': '木', '笔画': 13, '含义': '美玉,珍异', '寓意': '如美玉般珍贵美好', '搭配': '萱琪、诗琪、梓琪、琪琪、雨琪'},
        '熙': {'五行': '水', '笔画': 13, '含义': '光明、兴旺、和乐', '寓意': '前途光明，和乐融融', '搭配': '熙然、辰熙、子熙、晨熙、嘉熙'},
        '恒': {'五行': '水', '笔画': 10, '含义': '长久、永恒、恒心', '寓意': '持之以恒，坚定不移', '搭配': '恒宇、恒泽、恒瑞、恒博、永恒'},
        '哲': {'五行': '火', '笔画': 10, '含义': '有智慧的人、哲理', '寓意': '智慧深远，明辨是非', '搭配': '哲宇、睿哲、铭哲、明哲、思哲'},
        '清': {'五行': '水', '笔画': 12, '含义': '清澈、纯净、清白', '寓意': '清新脱俗，纯净美好', '搭配': '清然、清风、清雅、清婉、清心'},
        '雅': {'五行': '木', '笔画': 12, '含义': '高尚、文雅、优美', '寓意': '温雅端庄，高雅不俗', '搭配': '雅琪、诗雅、雅涵、博雅、文雅'},
    }

    info = char_db.get(char)
    if info:
        print('=' * 50)
        print('🔍 「{c}」字义详解'.format(c=char))
        print('=' * 50)
        print()
        print('📝 基本信息:')
        print('  字: {c}'.format(c=char))
        print('  笔画: {s}画'.format(s=info['笔画']))
        print('  五行: {wx}'.format(wx=info['五行']))
        print()
        print('📖 含义: {m}'.format(m=info['含义']))
        print('💫 寓意: {y}'.format(y=info['寓意']))
        print()
        print('🔗 常见搭配名:')
        for name in info['搭配'].split('、'):
            print('  • {name}'.format(name=name))
        print()
        # 五行相生相克
        wuxing_sheng = {'金': '水', '水': '木', '木': '火', '火': '土', '土': '金'}
        wuxing_ke = {'金': '木', '木': '土', '土': '水', '水': '火', '火': '金'}
        wx = info['五行']
        print('🔮 五行参考:')
        print('  {wx}生{sheng} — 搭配{sheng}属性的字更和谐'.format(wx=wx, sheng=wuxing_sheng[wx]))
        print('  {wx}克{ke} — 避免搭配{ke}属性的字'.format(wx=wx, ke=wuxing_ke[wx]))
    else:
        print('=' * 50)
        print('🔍 「{c}」字义查询'.format(c=char))
        print('=' * 50)
        print()
        print('暂无「{c}」的详细数据'.format(c=char))
        print()
        print('已收录的常用取名字: {chars}'.format(chars='、'.join(sorted(char_db.keys()))))
        print()
        print('💡 如需查询更多汉字，可搜索「{c} 五行 取名」'.format(c=char))

elif cmd == 'batch':
    if len(args) < 3:
        print('用法: name.sh batch \"姓\" \"性别\" \"风格\"')
        print('性别: 男 / 女')
        print('风格: 诗词 / 大气 / 温柔 / 简约 / 古风')
        sys.exit(1)
    surname = args[0]
    gender = args[1]
    style = args[2]

    # 按风格分的名字库 (字, 含义, 出处/风格说明)
    name_pool = {
        '男': {
            '诗词': [
                ('致远', '宁静致远', '出自诸葛亮《诫子书》', 92),
                ('思齐', '见贤思齐', '出自《论语》', 90),
                ('明哲', '明哲保身', '出自《诗经·大雅》', 88),
                ('子衿', '青青子衿，悠悠我心', '出自《诗经·郑风》', 91),
                ('望舒', '前望舒使先驱兮', '出自屈原《离骚》', 93),
                ('信芳', '苟余情其信芳', '出自屈原《离骚》', 87),
                ('修远', '路漫漫其修远兮', '出自屈原《离骚》', 89),
                ('凌云', '壮志凌云', '出自《汉书》', 90),
                ('弘毅', '士不可以不弘毅', '出自《论语》', 91),
                ('清扬', '有美一人，清扬婉兮', '出自《诗经·郑风》', 88),
                ('锦书', '云中谁寄锦书来', '出自李清照词', 86),
                ('长安', '长安一片月', '出自李白诗', 92),
            ],
            '大气': [
                ('浩然', '浩然正气', '气势磅礴，正义凛然', 93),
                ('天佑', '上天保佑', '天赐福泽，前程似锦', 90),
                ('瀚宇', '浩瀚宇宙', '胸怀如宇宙般广阔', 91),
                ('凯旋', '凯旋而归', '胜利归来，事业有成', 88),
                ('鼎盛', '鼎盛繁荣', '繁荣昌盛，登峰造极', 87),
                ('昊天', '昊天广阔', '如天空般辽阔无限', 90),
                ('承远', '承前启后', '继承传统，志向远大', 89),
                ('兆丰', '丰年之兆', '丰收吉祥，福泽深厚', 86),
                ('乾坤', '扭转乾坤', '大气磅礴，改天换地', 92),
                ('雄飞', '雄鹰展翅', '展翅高飞，志在四方', 88),
                ('泰山', '稳如泰山', '稳重可靠，气势恢宏', 85),
                ('鸿远', '鸿鹄之志', '志向高远，前途无量', 91),
            ],
            '简约': [
                ('一', '天下第一', '大道至简，独一无二', 88),
                ('然', '自然而然', '洒脱自如，淡然从容', 90),
                ('木', '参天大木', '朴实坚韧，茁壮成长', 85),
                ('安', '平安喜乐', '安宁祥和，平安一生', 92),
                ('初', '不忘初心', '纯真美好，保持初心', 89),
                ('白', '纯白无暇', '纯净正直，清白做人', 87),
                ('川', '百川归海', '奔流不息，胸怀广阔', 90),
                ('森', '森林茂密', '生机勃勃，蓬勃向上', 88),
                ('宁', '安宁静好', '宁静致远，平和安宁', 91),
                ('乐', '快乐人生', '乐观开朗，知足常乐', 89),
                ('石', '坚如磐石', '坚定不移，稳重踏实', 86),
                ('风', '清风明月', '潇洒自如，自由自在', 88),
            ],
            '古风': [
                ('云卿', '云中之卿', '飘逸洒脱，超凡脱俗', 91),
                ('墨白', '翰墨留白', '文雅有余韵', 90),
                ('剑心', '以剑明心', '侠气凛然，心志坚定', 88),
                ('清渊', '渊清玉绝', '清澈深远，品格高洁', 89),
                ('玄青', '玄衣青袍', '神秘高雅，超然物外', 87),
                ('怀瑾', '怀瑾握瑜', '品德高尚，才华出众', 92),
                ('临风', '临风而立', '风度翩翩，潇洒俊逸', 90),
                ('沧澜', '沧海波澜', '气度恢弘，历经沧桑', 88),
                ('九歌', '楚辞九歌', '浪漫雄奇，才华横溢', 89),
                ('长歌', '长歌当哭', '豪迈不羁，真性情', 87),
                ('霜华', '霜华满袖', '清冷高洁，不染尘埃', 90),
                ('青衫', '青衫磊落', '文人风骨，清雅脱俗', 88),
            ],
        },
        '女': {
            '诗词': [
                ('婉清', '有美一人，清扬婉兮', '出自《诗经》', 93),
                ('如雪', '如雪之白', '出自《诗经》', 88),
                ('静姝', '静女其姝', '出自《诗经·邶风》', 92),
                ('舒窈', '月出皎兮，佼人僚兮，舒窈纠兮', '出自《诗经·陈风》', 91),
                ('琼华', '蒹葭苍苍', '出自《诗经》，美玉之华', 89),
                ('若兮', '既含睇兮又宜笑', '出自《楚辞》', 90),
                ('知意', '我寄愁心与明月', '灵感来自李白诗', 87),
                ('清照', '人比黄花瘦', '致敬李清照', 91),
                ('初静', '人间初静', '安静美好，初心不改', 90),
                ('如梦', '如梦令', '灵感来自李清照词牌', 88),
                ('疏影', '疏影横斜水清浅', '出自林逋咏梅诗', 92),
                ('暗香', '暗香浮动月黄昏', '出自林逋咏梅诗', 89),
            ],
            '温柔': [
                ('暖暖', '温暖如春', '温柔体贴，温暖人心', 90),
                ('柔心', '柔情似水', '内心柔软，善解人意', 88),
                ('恬静', '恬淡宁静', '温婉安静，岁月静好', 91),
                ('念念', '念念不忘', '被深深牵挂，珍贵美好', 89),
                ('婉如', '温婉如玉', '温婉可人，如玉般温润', 92),
                ('柔嘉', '嘉言懿行', '柔美善良，品行端正', 90),
                ('绵绵', '绵绵不绝', '温情脉脉，细水长流', 87),
                ('语嫣', '巧笑嫣然', '语笑嫣然，倾国倾城', 91),
                ('安暖', '安暖相伴', '安定温暖，岁月静好', 89),
                ('如初', '如初见', '纯真美好，始终如一', 90),
                ('锦心', '锦心绣口', '心思细腻，聪慧可人', 88),
                ('惜颜', '珍惜容颜', '珍惜美好，容颜如花', 86),
            ],
            '简约': [
                ('一', '唯一无二', '简单纯粹，独一无二', 88),
                ('安', '平安', '安宁祥和，一生平安', 92),
                ('心', '用心生活', '真心纯粹，心地善良', 87),
                ('初', '初心', '不忘初心，美好如初', 90),
                ('禾', '丰禾', '生机勃勃，朴实无华', 86),
                ('知', '知心', '知书达理，聪慧温柔', 89),
                ('念', '惦念', '被牵挂惦念的女孩', 91),
                ('可', '可人', '可爱讨喜，人见人爱', 88),
                ('乐', '快乐', '永远快乐，积极向上', 90),
                ('南', '南方', '温暖如南，方向感', 85),
                ('也', '也好', '一切都也好，知足常乐', 84),
                ('之', '之乎', '文雅简洁，古典韵味', 87),
            ],
            '古风': [
                ('若兰', '若兰如芷', '品质如兰，高洁脱俗', 92),
                ('落薇', '落花微雨', '柔美飘逸，如花似梦', 91),
                ('清歌', '清歌一曲', '歌声清亮，才艺出众', 89),
                ('云裳', '霓裳羽衣', '飘逸如仙，美丽绝伦', 90),
                ('玉笙', '玉笙声里', '如玉般温润的女子', 88),
                ('月白', '月白风清', '清冷高雅，如月般明净', 91),
                ('锦瑟', '锦瑟无端', '华美而充满故事', 87),
                ('琴心', '琴心剑胆', '才艺双绝，侠骨柔情', 89),
                ('沉鱼', '沉鱼落雁', '美丽绝伦，倾国倾城', 85),
                ('如烟', '往事如烟', '飘渺灵动，如梦似幻', 88),
                ('霜雪', '傲雪凌霜', '坚韧不拔，美丽高洁', 90),
                ('画屏', '画屏闲展', '精致典雅，如画中人', 86),
            ],
        },
    }

    # 温柔 only for 女, 大气 only for 男
    if gender == '男' and style == '温柔':
        style = '简约'
    if gender == '女' and style == '大气':
        style = '温柔'

    pool = name_pool.get(gender, name_pool['男']).get(style)
    if not pool:
        pool = name_pool.get(gender, name_pool['男']).get('诗词')

    selected = random.sample(pool, min(10, len(pool)))

    gender_emoji = {'男': '👦', '女': '👧'}
    print('=' * 55)
    print('{emoji} {surname}姓{gender}宝起名 · {style}风格 (批量10个)'.format(
        emoji=gender_emoji.get(gender, '🌟'), surname=surname, gender=gender, style=style))
    print('=' * 55)
    print()

    for i, (name, meaning, source, score) in enumerate(selected, 1):
        full_name = '{surname}{name}'.format(surname=surname, name=name)
        # 评分星级
        if score >= 92:
            stars = '⭐⭐⭐⭐⭐'
        elif score >= 89:
            stars = '⭐⭐⭐⭐'
        elif score >= 86:
            stars = '⭐⭐⭐'
        else:
            stars = '⭐⭐'

        print('  {i:>2}. 🏷️  {name}  [{score}分] {stars}'.format(
            i=i, name=full_name, score=score, stars=stars))
        print('      含义: {meaning}'.format(meaning=meaning))
        print('      出处: {source}'.format(source=source))
        print()

    print('━' * 55)
    print('评分维度: 寓意(30%) + 声韵(25%) + 字形(20%) + 独特性(25%)')
    print()
    print('💡 批量生成建议:')
    print('  • 选3-5个最喜欢的，念出来感受声调')
    print('  • 写在纸上看字形搭配')
    print('  • 查一下是否有不好的谐音')
    print('  • 可尝试不同风格: 诗词 / 大气 / 温柔 / 简约 / 古风')

" "$CMD" "$@"
    ;;
  help|*)
    show_help
    ;;
esac

echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
