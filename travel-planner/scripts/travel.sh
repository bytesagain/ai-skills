#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

CMD="${1:-help}"
shift 2>/dev/null || true

show_help() {
cat << 'EOF'
🌍 旅行攻略生成器

用法:
  travel.sh plan "目的地" "天数"          行程规划
  travel.sh budget "目的地" "天数" "人数"  预算估算
  travel.sh packing "目的地" "季节"       打包清单
  travel.sh checklist "类型"              场景打包清单(商务/亲子/海边/登山/出国)
  travel.sh tips "目的地"                 注意事项
  travel.sh emergency "目的地"            应急信息(报警/使馆/医院/保险)
  travel.sh help                          显示帮助
EOF
}

case "$CMD" in
  plan|budget|packing|tips|checklist|emergency)
    python3 -c "
import sys, json, random, hashlib

cmd = sys.argv[1]
args = sys.argv[2:]

def seed_from(s):
    return int(hashlib.md5(s.encode()).hexdigest()[:8], 16)

if cmd == 'plan':
    if len(args) < 2:
        print('用法: travel.sh plan \"目的地\" \"天数\"')
        sys.exit(1)
    dest, days = args[0], int(args[1])
    random.seed(seed_from(dest))

    morning_activities = ['逛古城/老街区', '参观博物馆', '游览标志性景点', '打卡网红地标', '逛当地市场', '参观寺庙/教堂', '城市徒步游', '参观艺术馆']
    afternoon_activities = ['品尝当地美食', '购物/逛商圈', '自然风光游', '体验当地文化', '主题公园', '湖畔/海边漫步', '手工艺体验', '拍照打卡']
    evening_activities = ['夜市小吃', '看夜景', '酒吧/咖啡厅', '看演出/表演', '河边散步', '品尝特色晚餐', '逛夜市', '泡温泉/SPA']

    print('=' * 50)
    print('🗺️  {dest} {days}日行程规划'.format(dest=dest, days=days))
    print('=' * 50)
    print()

    for d in range(1, days + 1):
        m = random.choice(morning_activities)
        a = random.choice(afternoon_activities)
        e = random.choice(evening_activities)
        if d == 1:
            theme = '初到{dest}·城市印象'.format(dest=dest)
        elif d == days:
            theme = '告别{dest}·满载而归'.format(dest=dest)
        else:
            themes = ['深度探索', '文化体验', '美食之旅', '自然风光', '休闲放松', '购物血拼']
            theme = random.choice(themes)
        print('📅 第{d}天 — {theme}'.format(d=d, theme=theme))
        print('  🌅 上午: {m}'.format(m=m))
        print('  ☀️  下午: {a}'.format(a=a))
        print('  🌙 晚上: {e}'.format(e=e))
        print()

    print('💡 小贴士:')
    print('  - 行程可根据实际情况灵活调整')
    print('  - 建议提前预订热门景点门票')
    print('  - 留出适当的休息和自由活动时间')

elif cmd == 'budget':
    if len(args) < 3:
        print('用法: travel.sh budget \"目的地\" \"天数\" \"人数\"')
        sys.exit(1)
    dest, days, people = args[0], int(args[1]), int(args[2])
    random.seed(seed_from(dest))

    # 根据目的地hash生成不同价位
    price_level = random.choice(['经济', '中等', '高端'])
    multipliers = {'经济': 0.7, '中等': 1.0, '高端': 1.5}
    m = multipliers[price_level]

    transport_pp = int(random.randint(800, 3000) * m)
    hotel_pn = int(random.randint(200, 800) * m)
    food_pd = int(random.randint(100, 300) * m)
    ticket_pd = int(random.randint(50, 200) * m)
    shopping = int(random.randint(500, 2000) * m)
    other = int(random.randint(200, 500) * m)

    transport_total = transport_pp * people
    hotel_total = hotel_pn * days
    food_total = food_pd * days * people
    ticket_total = ticket_pd * days * people
    total = transport_total + hotel_total + food_total + ticket_total + shopping * people + other * people

    print('=' * 50)
    print('💰 {dest} {days}天{people}人预算估算'.format(dest=dest, days=days, people=people))
    print('=' * 50)
    print()
    print('✈️  交通费: {t}元/人 × {p}人 = {total}元'.format(t=transport_pp, p=people, total=transport_total))
    print('   (含往返大交通+当地交通)')
    print()
    print('🏨 住宿费: {h}元/晚 × {d}晚 = {total}元'.format(h=hotel_pn, d=days, total=hotel_total))
    print('   (标准双人间/民宿)')
    print()
    print('🍜 餐饮费: {f}元/天/人 × {d}天 × {p}人 = {total}元'.format(f=food_pd, d=days, p=people, total=food_total))
    print()
    print('🎫 门票费: {t}元/天/人 × {d}天 × {p}人 = {total}元'.format(t=ticket_pd, d=days, p=people, total=ticket_total))
    print()
    print('🛍️  购物费: 约{s}元/人'.format(s=shopping))
    print('📋 其他:   约{o}元/人 (保险/通讯/小费等)'.format(o=other))
    print()
    print('━' * 50)
    print('💵 预估总费用: 约 {total} 元'.format(total=total))
    print('💵 人均费用:   约 {pp} 元'.format(pp=total // people))
    print('━' * 50)
    print()
    print('⚠️  以上为估算值，实际费用因季节、标准等有所浮动')

elif cmd == 'packing':
    if len(args) < 2:
        print('用法: travel.sh packing \"目的地\" \"季节\"')
        sys.exit(1)
    dest, season = args[0], args[1]

    base_items = {
        '证件': ['身份证/护照', '机票/车票(电子版)', '酒店预订确认', '旅行保险单', '少量现金+银行卡'],
        '电子设备': ['手机+充电器', '充电宝', '耳机', '相机(可选)', '万能转换插头'],
        '洗漱用品': ['牙刷牙膏', '洗面奶', '防晒霜', '毛巾', '纸巾/湿巾'],
        '药品': ['感冒药', '肠胃药', '创可贴', '防蚊液', '个人常用药'],
    }

    season_items = {
        '春天': {'衣物': ['薄外套', '长袖T恤×3', '长裤×2', '运动鞋', '雨伞/雨衣'], '特别提醒': '春季早晚温差大，注意增减衣物'},
        '夏天': {'衣物': ['短袖×4', '短裤×2', '凉鞋', '泳衣', '太阳帽/墨镜'], '特别提醒': '注意防晒补水，避免中暑'},
        '秋天': {'衣物': ['薄毛衣', '长袖×3', '牛仔裤×2', '运动鞋', '围巾'], '特别提醒': '秋季天气多变，建议带一件防风外套'},
        '冬天': {'衣物': ['羽绒服', '毛衣×2', '保暖内衣', '手套/帽子', '防滑靴'], '特别提醒': '注意保暖防寒，可贴暖宝宝'},
    }

    s = season_items.get(season, season_items['春天'])

    print('=' * 50)
    print('🧳 {dest}·{season} 打包清单'.format(dest=dest, season=season))
    print('=' * 50)
    print()

    for cat, items in base_items.items():
        print('📦 {cat}'.format(cat=cat))
        for item in items:
            print('  ☐ {item}'.format(item=item))
        print()

    print('👕 衣物（{season}）'.format(season=season))
    for item in s['衣物']:
        print('  ☐ {item}'.format(item=item))
    print()

    print('⚠️  {tip}'.format(tip=s['特别提醒']))
    print()
    print('💡 Tips: 根据目的地特点可能还需要:')
    print('  - 海边: 防水袋、浮潜装备')
    print('  - 高原: 氧气罐、唇膏')
    print('  - 出境: 签证、外币、翻译APP')

elif cmd == 'tips':
    if len(args) < 1:
        print('用法: travel.sh tips \"目的地\"')
        sys.exit(1)
    dest = args[0]
    random.seed(seed_from(dest))

    safety_tips = [
        '贵重物品随身携带，不要放在托运行李中',
        '出门前拍照记录酒店地址和房间号',
        '重要证件留电子备份（邮箱/云盘）',
        '深夜避免独自前往偏僻地区',
        '了解当地紧急电话号码',
    ]
    culture_tips = [
        '尊重当地风俗习惯和宗教信仰',
        '进入寺庙/清真寺注意着装',
        '拍照前先征得当地人同意',
        '学几句当地基本用语（你好/谢谢）',
        '了解当地小费文化',
    ]
    food_tips = [
        '尝试当地特色美食，但注意卫生',
        '街头小吃选择人多的摊位',
        '了解当地饮食禁忌',
        '自带水杯，注意饮水安全',
        '如有过敏，提前了解当地食材',
    ]
    transport_tips = [
        '提前了解当地公共交通方式',
        '打车用正规平台，记录车牌号',
        '了解当地交通规则（靠左/靠右）',
        '购买当地交通卡更划算',
        '高峰期预留充足出行时间',
    ]

    random.shuffle(safety_tips)
    random.shuffle(culture_tips)
    random.shuffle(food_tips)
    random.shuffle(transport_tips)

    print('=' * 50)
    print('📋 {dest} 旅行注意事项'.format(dest=dest))
    print('=' * 50)
    print()

    print('🛡️ 安全须知')
    for t in safety_tips[:4]:
        print('  • {t}'.format(t=t))
    print()

    print('🎭 文化礼仪')
    for t in culture_tips[:4]:
        print('  • {t}'.format(t=t))
    print()

    print('🍜 饮食建议')
    for t in food_tips[:4]:
        print('  • {t}'.format(t=t))
    print()

    print('🚗 交通出行')
    for t in transport_tips[:4]:
        print('  • {t}'.format(t=t))
    print()

    print('📱 实用APP推荐:')
    print('  • 地图导航: Google Maps / 高德地图')
    print('  • 翻译: Google翻译 / 有道翻译')
    print('  • 打车: 滴滴 / Grab / Uber')
    print('  • 住宿: 携程 / Booking / Airbnb')

elif cmd == 'checklist':
    if len(args) < 1:
        print('用法: travel.sh checklist \"类型\"')
        print('类型: 商务 / 亲子 / 海边 / 登山 / 出国')
        sys.exit(1)
    trip_type = args[0]

    checklists = {
        '商务': {
            '证件文件': ['身份证/护照', '公司名片(多带)', '笔记本电脑+充电器', '会议资料(纸质+电子)', '签字笔'],
            '商务着装': ['正装西装/套装×2', '衬衫×3', '领带/丝巾', '皮鞋', '皮带'],
            '电子设备': ['手机+充电器', '充电宝(飞机限20000mAh)', '投影转接头', '鼠标', 'U盘/移动硬盘'],
            '个人用品': ['洗漱包', '便携熨斗/去皱喷雾', '备用口罩', '眼罩耳塞', '常用药品'],
            '商务必备': ['公司小礼品(送客户)', '名片夹', '折叠伞', '便携衣架', '行程打印件'],
        },
        '亲子': {
            '宝宝必备': ['纸尿裤(按天数×8片)', '湿巾(大包+小包)', '奶瓶/水杯', '奶粉/辅食', '围兜×3'],
            '安全防护': ['防走失带/手环', '儿童防晒霜', '驱蚊贴', '创可贴', '退热贴+体温计'],
            '娱乐安抚': ['安抚玩具/小毯子', 'iPad+儿童耳机', '绘本2-3本', '零食小饼干', '贴纸/蜡笔'],
            '衣物': ['换洗衣物(多带2套)', '薄外套', '帽子', '舒适鞋', '睡衣'],
            '家长用品': ['婴儿背带/推车', '保温杯(泡奶用)', '密封袋(装脏衣物)', '便携餐具', '消毒湿巾'],
        },
        '海边': {
            '防晒装备': ['防晒霜SPF50+(多带)', '防晒衣/皮肤衣', '太阳帽(大帽檐)', '墨镜(偏光)', '晒后修复'],
            '水上用品': ['泳衣/泳裤×2', '浮潜面镜+呼吸管', '防水手机套', '沙滩巾', '人字拖'],
            '衣物': ['速干短袖×3', '沙滩裤×2', '薄外套(防风)', '凉鞋', '比基尼罩衫'],
            '安全': ['防水创可贴', '防蚊液', '藿香正气水', '防水袋(证件/现金)', '急救药品'],
            '娱乐': ['防水相机/GoPro', '充气浮排', '沙滩玩具', '扑克牌', '蓝牙音箱(防水)'],
        },
        '登山': {
            '装备': ['登山鞋(提前磨合)', '登山杖', '登山包(40-60L)', '头灯+备用电池', '防水袋'],
            '衣物': ['速干衣×3', '冲锋衣', '抓绒衣', '速干裤', '登山袜(厚)×3'],
            '补给': ['能量棒/巧克力', '电解质冲剂', '保温杯(装热水)', '压缩饼干', '水袋/水壶2L'],
            '安全': ['急救包', '防蚊虫喷雾', '防晒霜', '求生哨', '指南针/离线地图'],
            '露营(如需)': ['帐篷+防潮垫', '睡袋(看温标)', '炉头+气罐', '折叠餐具', '垃圾袋'],
        },
        '出国': {
            '证件': ['护照(有效期>6个月)', '签证/电子签打印件', '机票行程单', '酒店预订确认', '旅行保险单'],
            '通讯': ['目的地电话卡/eSIM', '万能转换插头', 'VPN(部分国家需要)', '离线地图下载', '翻译APP'],
            '金融': ['VISA/Master信用卡', '当地货币(少量)', '汇率查询APP', '紧急联络卡(英文)', '银联卡(备用)'],
            '健康': ['常用药品(带说明书英文)', '疫苗接种证明(如需)', '处方药英文证明', '旅行急救包', '口罩'],
            '实用': ['行李箱密码锁', '便携称(避免超重)', '分装瓶(100ml以内)', '颈枕+眼罩', '万能晾衣绳'],
        },
    }

    cl = checklists.get(trip_type)
    if not cl:
        print('不支持的类型: {t}'.format(t=trip_type))
        print('支持: {types}'.format(types=' / '.join(checklists.keys())))
        sys.exit(1)

    type_emoji = {'商务': '💼', '亲子': '👶', '海边': '🏖️', '登山': '⛰️', '出国': '✈️'}
    print('=' * 50)
    print('{emoji} {t}旅行打包清单'.format(emoji=type_emoji.get(trip_type, '🧳'), t=trip_type))
    print('=' * 50)
    print()

    for cat, items in cl.items():
        print('📦 {cat}'.format(cat=cat))
        for item in items:
            print('  ☐ {item}'.format(item=item))
        print()

    print('💡 {t}旅行特别提醒:'.format(t=trip_type))
    tips_map = {
        '商务': ['提前确认会议室设备是否兼容', '准备好电子版和纸质版双份资料', '预留充足交通时间，宁早勿迟'],
        '亲子': ['选择直飞航班减少折腾', '住宿选有厨房的公寓方便做辅食', '行程不要太赶，给孩子午睡时间'],
        '海边': ['涂防晒霜至少出门前20分钟', '不要在烈日下12-14点下水', '珊瑚/水母区域注意安全'],
        '登山': ['不要单独行动，至少结伴同行', '关注天气预报，雷雨天禁止登顶', '高海拔地区注意高反，缓慢上升'],
        '出国': ['护照首页拍照存云端备份', '了解当地紧急电话和使馆地址', '保管好小费零钱'],
    }
    for tip in tips_map.get(trip_type, []):
        print('  • {tip}'.format(tip=tip))

elif cmd == 'emergency':
    if len(args) < 1:
        print('用法: travel.sh emergency \"目的地\"')
        sys.exit(1)
    dest = args[0]

    # 常见目的地应急信息
    emergency_db = {
        '日本': {'报警': '110', '急救': '119', '火警': '119', '使馆': '+81-3-3403-3388', '区号': '+81', '货币': '日元(JPY)', '时差': '+1h'},
        '东京': {'报警': '110', '急救': '119', '火警': '119', '使馆': '+81-3-3403-3388', '区号': '+81', '货币': '日元(JPY)', '时差': '+1h'},
        '大阪': {'报警': '110', '急救': '119', '火警': '119', '使馆': '+81-6-6445-9481(领馆)', '区号': '+81', '货币': '日元(JPY)', '时差': '+1h'},
        '韩国': {'报警': '112', '急救': '119', '火警': '119', '使馆': '+82-2-738-1038', '区号': '+82', '货币': '韩元(KRW)', '时差': '+1h'},
        '首尔': {'报警': '112', '急救': '119', '火警': '119', '使馆': '+82-2-738-1038', '区号': '+82', '货币': '韩元(KRW)', '时差': '+1h'},
        '泰国': {'报警': '191', '急救': '1669', '火警': '199', '使馆': '+66-2-245-7044', '区号': '+66', '货币': '泰铢(THB)', '时差': '-1h'},
        '曼谷': {'报警': '191', '急救': '1669', '火警': '199', '使馆': '+66-2-245-7044', '区号': '+66', '货币': '泰铢(THB)', '时差': '-1h'},
        '美国': {'报警': '911', '急救': '911', '火警': '911', '使馆': '+1-202-495-2266', '区号': '+1', '货币': '美元(USD)', '时差': '-13~-16h'},
        '英国': {'报警': '999', '急救': '999', '火警': '999', '使馆': '+44-20-7299-4049', '区号': '+44', '货币': '英镑(GBP)', '时差': '-8h'},
        '法国': {'报警': '17', '急救': '15', '火警': '18', '使馆': '+33-1-4936-1230', '区号': '+33', '货币': '欧元(EUR)', '时差': '-7h'},
        '巴黎': {'报警': '17', '急救': '15', '火警': '18', '使馆': '+33-1-4936-1230', '区号': '+33', '货币': '欧元(EUR)', '时差': '-7h'},
        '澳大利亚': {'报警': '000', '急救': '000', '火警': '000', '使馆': '+61-2-6228-3999', '区号': '+61', '货币': '澳元(AUD)', '时差': '+2~3h'},
        '新加坡': {'报警': '999', '急救': '995', '火警': '995', '使馆': '+65-6471-2117', '区号': '+65', '货币': '新加坡元(SGD)', '时差': '0h'},
        '马来西亚': {'报警': '999', '急救': '999', '火警': '994', '使馆': '+60-3-2163-6815', '区号': '+60', '货币': '马币(MYR)', '时差': '0h'},
        '越南': {'报警': '113', '急救': '115', '火警': '114', '使馆': '+84-24-3845-3736', '区号': '+84', '货币': '越南盾(VND)', '时差': '-1h'},
        '德国': {'报警': '110', '急救': '112', '火警': '112', '使馆': '+49-30-27588-0', '区号': '+49', '货币': '欧元(EUR)', '时差': '-7h'},
        '意大利': {'报警': '112', '急救': '118', '火警': '115', '使馆': '+39-06-8413458', '区号': '+39', '货币': '欧元(EUR)', '时差': '-7h'},
        '西班牙': {'报警': '112', '急救': '112', '火警': '112', '使馆': '+34-91-519-4242', '区号': '+34', '货币': '欧元(EUR)', '时差': '-7h'},
        '印尼': {'报警': '110', '急救': '118', '火警': '113', '使馆': '+62-21-5761039', '区号': '+62', '货币': '印尼盾(IDR)', '时差': '-1~0h'},
        '巴厘岛': {'报警': '110', '急救': '118', '火警': '113', '使馆': '+62-361-239902(领馆)', '区号': '+62', '货币': '印尼盾(IDR)', '时差': '0h'},
    }

    # 国内目的地
    domestic = ['北京', '上海', '广州', '深圳', '成都', '杭州', '西安', '重庆', '三亚', '丽江',
                '大理', '厦门', '青岛', '苏州', '南京', '武汉', '长沙', '桂林', '拉萨', '张家界']

    is_domestic = dest in domestic or any(dest.startswith(p) for p in ['中国', '国内', '海南', '云南', '四川', '广东', '浙江', '江苏', '福建', '湖南', '贵州', '西藏', '新疆', '内蒙古'])

    print('=' * 50)
    print('🆘 {dest} 应急信息'.format(dest=dest))
    print('=' * 50)
    print()

    if is_domestic:
        print('📞 【紧急电话】')
        print('  🚔 报警: 110')
        print('  🚑 急救: 120')
        print('  🚒 火警: 119')
        print('  📞 交通事故: 122')
        print('  📞 旅游投诉: 12301')
        print('  📞 消费者投诉: 12315')
        print()
        print('🏥 【就医指南】')
        print('  • 搜索「{dest}三甲医院」找最近的大医院'.format(dest=dest))
        print('  • 急诊24小时开放，带身份证和医保卡')
        print('  • 下载「京东健康」「好大夫」可在线问诊')
        print()
        print('🛡️ 【旅行保险】')
        print('  • 建议购买旅行意外险(支付宝/微信可买)')
        print('  • 出险后第一时间拨打保险客服报案')
        print('  • 保留医疗发票、诊断证明等理赔材料')
        print()
        print('📱 【实用号码】')
        print('  • 天气查询: 12121')
        print('  • 道路救援: 12122')
        print('  • 法律援助: 12348')
    else:
        info = emergency_db.get(dest)
        if info:
            print('📞 【紧急电话】')
            print('  🚔 报警: {p}'.format(p=info['报警']))
            print('  🚑 急救: {a}'.format(a=info['急救']))
            print('  🚒 火警: {f}'.format(f=info['火警']))
            print('  🇨🇳 中国使馆/领馆: {e}'.format(e=info['使馆']))
            print()
            print('📋 【基本信息】')
            print('  国际区号: {c}'.format(c=info['区号']))
            print('  货币: {m}'.format(m=info['货币']))
            print('  与北京时差: {t}'.format(t=info['时差']))
        else:
            print('📞 【通用紧急信息】')
            print('  • 全球通用紧急号码: 112 (大部分国家可用)')
            print('  • 中国外交部全球领事保护热线: +86-10-12308')
            print()
            print('  ⚠️  未找到「{dest}」的详细数据'.format(dest=dest))
            print('  建议出发前搜索「{dest} 紧急电话」确认'.format(dest=dest))
        print()
        print('🇨🇳 【领事保护】')
        print('  📞 外交部全球领保热线: +86-10-12308 (24小时)')
        print('  📞 也可拨打 +86-10-65612308')
        print('  📱 下载「中国领事」APP，一键求助')
        print()
        print('🏥 【海外就医】')
        print('  • 优先前往当地公立医院急诊')
        print('  • 保留所有医疗收据和诊断报告(用于保险理赔)')
        print('  • 语言不通可请酒店前台协助翻译/陪同')
        print()
        print('🛡️ 【保险理赔流程】')
        print('  1. 出险后立即拨打保险公司海外救援热线')
        print('  2. 就医时保留完整发票、处方、诊断证明')
        print('  3. 回国后30天内提交理赔材料')
        print('  4. 需要材料：护照复印件、保单、医疗发票、')
        print('     诊断证明、费用清单、银行卡信息')
        print()
        print('📱 【出境必装APP】')
        print('  • 中国领事(领保)')
        print('  • Google Maps(导航)')
        print('  • Google Translate(翻译)')
        print('  • 旅行保险APP')

" "$CMD" "$@"
    ;;
  help|*)
    show_help
    ;;
esac

echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
