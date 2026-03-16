#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

CMD="${1:-help}"
shift 2>/dev/null || true

show_help() {
cat << 'EOF'
💪 健身计划生成器

用法:
  fitness.sh workout "目标" [--level 新手|中级|高级]  训练计划
  fitness.sh diet "目标" "体重kg"                     饮食方案
  fitness.sh cardio "时长分钟"                        有氧训练
  fitness.sh stretch                                  拉伸动作
  fitness.sh tdee "体重" "身高" "年龄" "活动量"       TDEE计算
  fitness.sh tworkout "目标" "可用时间分钟"            按时间定制训练
  fitness.sh progress "体重1,体重2,..."               进度追踪+趋势
  fitness.sh help                                     显示帮助

目标: 增肌 | 减脂 | 塑形
活动量: 久坐 | 轻度 | 中度 | 高强度 | 运动员
EOF
}

case "$CMD" in
  workout|diet|cardio|stretch|tdee|tworkout|progress)
    python3 -c "
import sys, json, random

cmd = sys.argv[1]
args = sys.argv[2:]

if cmd == 'workout':
    if len(args) < 1:
        print('用法: fitness.sh workout \"目标\" [--level 新手|中级|高级]')
        sys.exit(1)
    goal = args[0]
    level = '中级'
    for i, a in enumerate(args):
        if a == '--level' and i + 1 < len(args):
            level = args[i + 1]

    sets_map = {'新手': (3, '8-10'), '中级': (4, '10-12'), '高级': (5, '12-15')}
    sets, reps = sets_map.get(level, (4, '10-12'))

    plans = {
        '增肌': {
            '周一 胸部+三头': ['平板杠铃卧推', '上斜哑铃卧推', '龙门架夹胸', '绳索下压', '窄距卧推'],
            '周二 背部+二头': ['引体向上', '杠铃划船', '高位下拉', '哑铃弯举', '锤式弯举'],
            '周三 休息/有氧': ['轻度有氧30分钟', '泡沫轴放松'],
            '周四 肩部+腹部': ['哑铃推举', '侧平举', '面拉', '卷腹', '平板支撑'],
            '周五 腿部': ['深蹲', '腿举', '罗马尼亚硬拉', '腿弯举', '小腿提踵'],
            '周末 休息': ['拉伸放松', '散步或轻度活动'],
        },
        '减脂': {
            '周一 全身HIIT': ['波比跳', '高抬腿', '登山者', '深蹲跳', '开合跳'],
            '周二 上肢+核心': ['俯卧撑', '哑铃推举', '平板支撑', '俄罗斯转体', '卷腹'],
            '周三 有氧': ['跑步/快走40分钟', '跳绳3组×3分钟'],
            '周四 下肢+核心': ['深蹲', '箭步蹲', '臀桥', '仰卧抬腿', '自行车卷腹'],
            '周五 全身循环': ['壶铃摇摆', '战绳', '药球砸地', '跳箱', 'TRX划船'],
            '周末 活动恢复': ['游泳/骑车/徒步', '瑜伽拉伸'],
        },
        '塑形': {
            '周一 臀腿塑形': ['深蹲', '臀推', '侧向弓步', '单腿硬拉', '蚌式开合'],
            '周二 上肢塑形': ['哑铃飞鸟', '反向飞鸟', '弹力带侧平举', '三头臂屈伸', '弯举'],
            '周三 核心+有氧': ['平板支撑变体', '死虫式', '侧平板', '有氧30分钟'],
            '周四 全身功能': ['土耳其起立', '单腿蹲', '哑铃推举', '划船', '农夫行走'],
            '周五 臀腿+核心': ['保加利亚深蹲', '相扑硬拉', '臀桥', '卷腹', '超人式'],
            '周末 休息': ['瑜伽/普拉提', '泡沫轴放松'],
        },
    }

    plan = plans.get(goal, plans['增肌'])

    print('=' * 50)
    print('🏋️ {goal}训练计划 ({level})'.format(goal=goal, level=level))
    print('=' * 50)
    print()
    print('📋 每组{sets}组 × {reps}次 | 组间休息60-90秒'.format(sets=sets, reps=reps))
    print()

    for day, exercises in plan.items():
        print('📅 {day}'.format(day=day))
        for i, ex in enumerate(exercises, 1):
            print('  {i}. {ex}'.format(i=i, ex=ex))
        print()

    print('💡 训练建议:')
    print('  • 训练前充分热身10分钟')
    print('  • 动作标准比重量更重要')
    print('  • 保证充足睡眠(7-8小时)')
    print('  • 循序渐进增加训练强度')

elif cmd == 'diet':
    if len(args) < 2:
        print('用法: fitness.sh diet \"目标\" \"体重kg\"')
        sys.exit(1)
    goal, weight = args[0], float(args[1])

    if goal == '增肌':
        calories = int(weight * 35)
        protein = round(weight * 2.0, 1)
        carb = round(weight * 4.5, 1)
        fat = round(weight * 1.0, 1)
    elif goal == '减脂':
        calories = int(weight * 25)
        protein = round(weight * 2.2, 1)
        carb = round(weight * 2.5, 1)
        fat = round(weight * 0.8, 1)
    else:
        calories = int(weight * 30)
        protein = round(weight * 1.8, 1)
        carb = round(weight * 3.5, 1)
        fat = round(weight * 0.9, 1)

    print('=' * 50)
    print('🥗 {goal}饮食方案 (体重{w}kg)'.format(goal=goal, w=weight))
    print('=' * 50)
    print()
    print('📊 每日营养目标:')
    print('  🔥 热量: {cal} kcal'.format(cal=calories))
    print('  🥩 蛋白质: {p}g'.format(p=protein))
    print('  🍚 碳水: {c}g'.format(c=carb))
    print('  🥑 脂肪: {f}g'.format(f=fat))
    print()

    meals = {
        '增肌': {
            '🌅 早餐 (7:00)': '全麦面包2片 + 鸡蛋3个 + 牛奶250ml + 香蕉1根',
            '🍎 加餐 (10:00)': '蛋白粉1勺 + 坚果一小把',
            '☀️ 午餐 (12:00)': '糙米饭200g + 鸡胸肉200g + 西兰花 + 少油炒菜',
            '🍌 加餐 (15:00)': '全麦面包 + 花生酱 + 酸奶',
            '🌙 晚餐 (18:00)': '意面/米饭150g + 牛肉/鱼肉200g + 蔬菜沙拉',
            '🥛 睡前 (21:00)': '酪蛋白粉1勺 或 脱脂牛奶',
        },
        '减脂': {
            '🌅 早餐 (7:00)': '鸡蛋2个(1全蛋1蛋白) + 燕麦50g + 蓝莓',
            '🍎 加餐 (10:00)': '苹果1个 + 少量杏仁',
            '☀️ 午餐 (12:00)': '糙米饭100g + 鸡胸肉150g + 大量蔬菜',
            '🍌 加餐 (15:00)': '蛋白粉1勺 + 黄瓜',
            '🌙 晚餐 (18:00)': '鱼肉/虾150g + 蔬菜沙拉(少油醋汁)',
        },
        '塑形': {
            '🌅 早餐 (7:00)': '全麦吐司1片 + 鸡蛋2个 + 牛奶200ml',
            '🍎 加餐 (10:00)': '酸奶 + 水果',
            '☀️ 午餐 (12:00)': '杂粮饭150g + 鸡胸/鱼肉150g + 蔬菜',
            '🍌 加餐 (15:00)': '蛋白棒或坚果一小把',
            '🌙 晚餐 (18:00)': '瘦肉/豆腐150g + 蔬菜 + 少量主食',
        },
    }

    meal = meals.get(goal, meals['塑形'])
    print('🍽️ 每日餐食建议:')
    print()
    for time, food in meal.items():
        print('  {time}'.format(time=time))
        print('    {food}'.format(food=food))
        print()

    print('💧 每日饮水: {w}ml 以上'.format(w=int(weight * 40)))
    print()
    print('⚠️  以上为参考方案，请根据个人体质调整')

elif cmd == 'cardio':
    if len(args) < 1:
        print('用法: fitness.sh cardio \"时长分钟\"')
        sys.exit(1)
    duration = int(args[0])

    print('=' * 50)
    print('🏃 {d}分钟有氧训练方案'.format(d=duration))
    print('=' * 50)
    print()

    if duration <= 15:
        print('⚡ HIIT高强度间歇 ({d}分钟)'.format(d=duration))
        print()
        print('  热身: 2分钟原地踏步')
        print()
        rounds = (duration - 3) // 2
        exercises = ['波比跳', '高抬腿', '深蹲跳', '登山者', '开合跳', '俯卧撑跳', '星形跳']
        print('  训练: {r}组循环'.format(r=rounds))
        for i in range(min(rounds, len(exercises))):
            print('    第{n}组: {ex} 30秒 + 休息30秒'.format(n=i+1, ex=exercises[i]))
        print()
        print('  放松: 1分钟慢走+拉伸')
    elif duration <= 30:
        print('🔥 中等强度有氧 ({d}分钟)'.format(d=duration))
        print()
        print('  0-5分钟:   热身慢跑/快走')
        print('  5-10分钟:  中速跑 (心率130-150)')
        print('  10-15分钟: 加速跑 (心率150-170)')
        print('  15-20分钟: 中速跑恢复')
        print('  20-25分钟: 间歇冲刺 (30秒快+30秒慢×5)')
        print('  25-{d}分钟: 放松慢跑+拉伸'.format(d=duration))
    else:
        print('🌊 稳态有氧 ({d}分钟)'.format(d=duration))
        print()
        print('  方案A - 跑步:')
        print('    0-5分钟:    热身快走')
        print('    5-{m}分钟:  中等配速持续跑 (心率120-140)'.format(m=duration-5))
        print('    最后5分钟:  放松慢走')
        print()
        print('  方案B - 混合有氧:')
        seg = (duration - 10) // 3
        print('    0-5分钟:       热身')
        print('    5-{m}分钟:     跑步机/户外跑'.format(m=5+seg))
        print('    {m1}-{m2}分钟: 椭圆机/动感单车'.format(m1=5+seg, m2=5+seg*2))
        print('    {m1}-{m2}分钟: 划船机/跳绳'.format(m1=5+seg*2, m2=5+seg*3))
        print('    最后5分钟:     放松拉伸')

    print()
    print('💡 有氧建议:')
    print('  • 保持能说话但不能唱歌的强度')
    print('  • 运动前后各5分钟热身/放松')
    print('  • 每周3-5次有氧效果最佳')
    print('  • 空腹有氧减脂效果更好(因人而异)')

elif cmd == 'stretch':
    print('=' * 50)
    print('🧘 全身拉伸动作 (15-20分钟)')
    print('=' * 50)
    print()

    stretches = [
        ('颈部', [
            '颈部左右侧屈 — 每侧15秒',
            '颈部前后屈伸 — 各15秒',
            '颈部环绕 — 顺逆各5圈',
        ]),
        ('肩部', [
            '手臂过头伸展 — 每侧20秒',
            '肩部环绕 — 前后各10圈',
            '胸前交叉拉伸 — 每侧20秒',
        ]),
        ('背部', [
            '猫牛式 — 10次',
            '婴儿式 — 保持30秒',
            '脊柱扭转 — 每侧20秒',
        ]),
        ('臀腿', [
            '站姿股四头肌拉伸 — 每侧20秒',
            '坐姿前屈 — 保持30秒',
            '鸽子式 — 每侧30秒',
            '蝴蝶式 — 保持30秒',
        ]),
        ('小腿+脚踝', [
            '小腿拉伸(推墙) — 每侧20秒',
            '脚踝环绕 — 每侧10圈',
            '脚趾抓地 — 10次',
        ]),
    ]

    for part, moves in stretches:
        print('🔹 {part}'.format(part=part))
        for m in moves:
            print('   • {m}'.format(m=m))
        print()

    print('💡 拉伸建议:')
    print('  • 拉伸时保持自然呼吸，不要憋气')
    print('  • 感到轻微拉扯感即可，不要硬拉到痛')
    print('  • 运动后拉伸效果优于运动前')
    print('  • 每个动作保持15-30秒')

elif cmd == 'tdee':
    if len(args) < 4:
        print('用法: fitness.sh tdee \"体重kg\" \"身高cm\" \"年龄\" \"活动量\"')
        print('活动量: 久坐 / 轻度 / 中度 / 高强度 / 运动员')
        sys.exit(1)
    weight = float(args[0])
    height = float(args[1])
    age = int(args[2])
    activity = args[3]

    # Mifflin-St Jeor公式
    bmr_male = 10 * weight + 6.25 * height - 5 * age + 5
    bmr_female = 10 * weight + 6.25 * height - 5 * age - 161

    activity_map = {
        '久坐': (1.2, '办公室工作，几乎不运动'),
        '轻度': (1.375, '每周运动1-3天'),
        '中度': (1.55, '每周运动3-5天'),
        '高强度': (1.725, '每周运动6-7天'),
        '运动员': (1.9, '每天高强度训练或体力工作'),
    }

    factor, desc = activity_map.get(activity, (1.55, '每周运动3-5天'))

    tdee_male = int(bmr_male * factor)
    tdee_female = int(bmr_female * factor)

    print('=' * 50)
    print('🔥 TDEE 每日热量需求计算')
    print('=' * 50)
    print()
    print('📊 你的数据:')
    print('  体重: {w}kg | 身高: {h}cm | 年龄: {a}岁'.format(w=weight, h=height, a=age))
    print('  活动量: {act} ({desc})'.format(act=activity, desc=desc))
    print()
    print('━' * 50)
    print('📋 基础代谢率 (BMR):')
    print('  ♂ 男性: {bmr} kcal/天'.format(bmr=int(bmr_male)))
    print('  ♀ 女性: {bmr} kcal/天'.format(bmr=int(bmr_female)))
    print()
    print('🔥 每日总消耗 (TDEE):')
    print('  ♂ 男性: {tdee} kcal/天'.format(tdee=tdee_male))
    print('  ♀ 女性: {tdee} kcal/天'.format(tdee=tdee_female))
    print('━' * 50)
    print()
    print('🎯 不同目标热量建议:')
    print()
    print('  ♂ 男性:')
    print('    🔻 减脂: {cal} kcal/天 (TDEE × 0.8，缺口约{gap}kcal)'.format(
        cal=int(tdee_male * 0.8), gap=int(tdee_male * 0.2)))
    print('    ⚖️  维持: {cal} kcal/天'.format(cal=tdee_male))
    print('    🔺 增肌: {cal} kcal/天 (TDEE × 1.15，盈余约{gap}kcal)'.format(
        cal=int(tdee_male * 1.15), gap=int(tdee_male * 0.15)))
    print()
    print('  ♀ 女性:')
    print('    🔻 减脂: {cal} kcal/天 (TDEE × 0.8，缺口约{gap}kcal)'.format(
        cal=int(tdee_female * 0.8), gap=int(tdee_female * 0.2)))
    print('    ⚖️  维持: {cal} kcal/天'.format(cal=tdee_female))
    print('    🔺 增肌: {cal} kcal/天 (TDEE × 1.15，盈余约{gap}kcal)'.format(
        cal=int(tdee_female * 1.15), gap=int(tdee_female * 0.15)))
    print()
    print('📊 宏量营养素建议 (以男性TDEE为例):')
    p_cal = int(weight * 2.0 * 4)
    f_cal = int(tdee_male * 0.25)
    c_cal = tdee_male - p_cal - f_cal
    print('  🥩 蛋白质: {g}g ({cal}kcal, {pct}%)'.format(
        g=int(weight*2.0), cal=p_cal, pct=int(p_cal*100/tdee_male)))
    print('  🥑 脂肪: {g}g ({cal}kcal, 25%)'.format(
        g=int(f_cal/9), cal=f_cal))
    print('  🍚 碳水: {g}g ({cal}kcal, {pct}%)'.format(
        g=int(c_cal/4), cal=c_cal, pct=int(c_cal*100/tdee_male)))
    print()
    print('⚠️  以上基于Mifflin-St Jeor公式估算')
    print('   实际热量需求因个体差异可能有10-15%浮动')
    print('   建议根据2-3周体重变化动态调整')

elif cmd == 'tworkout':
    if len(args) < 2:
        print('用法: fitness.sh tworkout \"目标\" \"可用时间(分钟)\"')
        print('目标: 增肌 / 减脂 / 塑形')
        sys.exit(1)
    goal = args[0]
    minutes = int(args[1])

    print('=' * 50)
    print('⏱️  {m}分钟{goal}速练方案'.format(m=minutes, goal=goal))
    print('=' * 50)
    print()

    if minutes <= 15:
        if goal == '减脂':
            print('🔥 {m}分钟HIIT燃脂 (无器械)'.format(m=minutes))
            print()
            print('  热身 (2分钟):')
            print('    • 原地开合跳 30秒')
            print('    • 手臂绕圈 30秒')
            print('    • 高抬腿 30秒')
            print('    • 臀部激活 30秒')
            print()
            rounds = (minutes - 3) // 1
            exercises = ['波比跳', '登山者', '深蹲跳', '高抬腿', '俯卧撑', '开合跳', '平板支撑交替抬手', '侧向跳']
            print('  训练 ({m}分钟): 每个动作30秒→休息10秒→下一个'.format(m=minutes-3))
            for i in range(min(rounds, len(exercises))):
                print('    {n}. {ex}'.format(n=i+1, ex=exercises[i]))
            print()
            print('  放松 (1分钟): 拉伸+深呼吸')
        else:
            print('💪 {m}分钟快速力量训练'.format(m=minutes))
            print()
            print('  全身复合动作 (每个动作做到力竭):')
            print('    1. 俯卧撑/跪姿俯卧撑 × 3组')
            print('    2. 深蹲 × 3组')
            print('    3. 平板支撑 × 3组(各30秒)')
            print()
            print('  ⚡ 组间休息30秒，动作间休息45秒')
    elif minutes <= 30:
        if goal == '减脂':
            print('🔥 {m}分钟中等强度燃脂'.format(m=minutes))
            print()
            print('  热身 (3分钟): 快走/慢跑')
            print()
            print('  第一循环 (8分钟):')
            print('    1. 波比跳 × 45秒 + 休息15秒')
            print('    2. 高抬腿 × 45秒 + 休息15秒')
            print('    3. 登山者 × 45秒 + 休息15秒')
            print('    4. 深蹲跳 × 45秒 + 休息15秒')
            print()
            print('  休息2分钟')
            print()
            print('  第二循环 (8分钟):')
            print('    1. 开合跳 × 45秒 + 休息15秒')
            print('    2. 俯卧撑 × 45秒 + 休息15秒')
            print('    3. 仰卧抬腿 × 45秒 + 休息15秒')
            print('    4. 侧弓步 × 45秒 + 休息15秒')
            print()
            print('  核心训练 (5分钟):')
            print('    1. 平板支撑 60秒')
            print('    2. 侧平板 每侧45秒')
            print('    3. 俄罗斯转体 60秒')
            print()
            print('  拉伸 (4分钟)')
        elif goal == '增肌':
            print('💪 {m}分钟增肌速练 (需哑铃)'.format(m=minutes))
            print()
            print('  热身 (3分钟)')
            print()
            print('  超级组A (10分钟):')
            print('    1A. 哑铃卧推 4×10')
            print('    1B. 哑铃划船 4×10')
            print('    (两个动作交替做，组间休息60秒)')
            print()
            print('  超级组B (10分钟):')
            print('    2A. 哑铃推举 3×12')
            print('    2B. 哑铃弯举 3×12')
            print('    (两个动作交替做，组间休息60秒)')
            print()
            print('  收尾 (4分钟):')
            print('    3. 深蹲 3×15')
            print()
            print('  拉伸 (3分钟)')
        else:
            print('✨ {m}分钟塑形训练'.format(m=minutes))
            print()
            print('  热身 (3分钟)')
            print()
            print('  臀腿塑形 (12分钟):')
            print('    1. 深蹲 3×15')
            print('    2. 侧向弓步 3×12/侧')
            print('    3. 臀桥 3×15')
            print('    4. 蚌式开合 3×15/侧')
            print()
            print('  上肢塑形 (8分钟):')
            print('    1. 俯卧撑 3×10')
            print('    2. 三头臂屈伸 3×12')
            print('    3. 弹力带侧平举 3×15')
            print()
            print('  核心 (4分钟):')
            print('    1. 平板支撑 2×45秒')
            print('    2. 死虫式 2×12')
            print()
            print('  拉伸 (3分钟)')
    else:
        if goal == '增肌':
            print('💪 {m}分钟完整增肌训练'.format(m=minutes))
            print()
            print('  热身 (5分钟): 有氧+动态拉伸')
            print()
            print('  主训练 (推拉腿全面覆盖):')
            print()
            print('  推 (15分钟):')
            print('    1. 杠铃/哑铃卧推 4×8-10')
            print('    2. 上斜哑铃卧推 3×10-12')
            print('    3. 哑铃推举 3×10-12')
            print('    4. 绳索下压 3×12-15')
            print()
            print('  拉 (15分钟):')
            print('    5. 引体向上/高位下拉 4×8-10')
            print('    6. 杠铃划船 3×10-12')
            print('    7. 面拉 3×15')
            print('    8. 哑铃弯举 3×12')
            print()
            print('  腿 (15分钟):')
            print('    9. 深蹲 4×8-10')
            print('    10. 罗马尼亚硬拉 3×10-12')
            print('    11. 腿举 3×12')
            print('    12. 小腿提踵 3×15')
            print()
            rest = minutes - 55
            if rest > 0:
                print('  核心 ({m}分钟):'.format(m=min(rest, 5)))
                print('    13. 卷腹 3×15')
                print('    14. 平板支撑 2×60秒')
            print()
            print('  拉伸放松 (5分钟)')
        elif goal == '减脂':
            print('🔥 {m}分钟完整燃脂训练'.format(m=minutes))
            print()
            print('  热身 (5分钟)')
            print()
            print('  力量循环 (20分钟): 做3轮')
            print('    1. 深蹲 × 15')
            print('    2. 俯卧撑 × 12')
            print('    3. 哑铃划船 × 12/侧')
            print('    4. 箭步蹲 × 12/侧')
            print('    5. 哑铃推举 × 12')
            print('    (每轮间休息90秒)')
            print()
            print('  HIIT (15分钟): 40秒运动+20秒休息')
            print('    1. 波比跳')
            print('    2. 高抬腿')
            print('    3. 登山者')
            print('    4. 深蹲跳')
            print('    5. 开合跳')
            print('    (做3轮)')
            print()
            rest = minutes - 45
            if rest > 0:
                print('  稳态有氧 ({m}分钟): 中速跑/快走'.format(m=min(rest, 10)))
            print()
            print('  拉伸放松 (5分钟)')
        else:
            print('✨ {m}分钟完整塑形训练'.format(m=minutes))
            print()
            print('  热身 (5分钟)')
            print()
            print('  臀腿 (20分钟):')
            print('    1. 深蹲 4×15')
            print('    2. 臀推 4×12')
            print('    3. 保加利亚深蹲 3×10/侧')
            print('    4. 侧弓步 3×12/侧')
            print('    5. 蚌式开合 3×15/侧')
            print()
            print('  上肢+核心 (15分钟):')
            print('    6. 俯卧撑/跪姿俯卧撑 3×12')
            print('    7. 弹力带侧平举 3×15')
            print('    8. 三头臂屈伸 3×12')
            print('    9. 平板支撑 3×45秒')
            print('    10. 死虫式 3×12')
            print()
            rest = minutes - 45
            if rest > 0:
                print('  有氧 ({m}分钟): 快走/椭圆机'.format(m=min(rest, 10)))
            print()
            print('  拉伸放松 (5分钟)')

    print()
    print('💡 训练建议:')
    print('  • 感到不适立即停止，安全第一')
    print('  • 无器械也能练，自重训练同样有效')
    print('  • 训练前1-2小时进食，避免空腹高强度训练')
    print('  • 训练后30分钟内补充蛋白质')

elif cmd == 'progress':
    if len(args) < 1:
        print('用法: fitness.sh progress \"体重1,体重2,...\"')
        print('例如: fitness.sh progress \"75.5,75.0,74.8,74.2,73.9\"')
        sys.exit(1)
    try:
        weights = [float(w.strip()) for w in args[0].split(',') if w.strip()]
    except ValueError:
        print('[错误] 体重格式不正确，请用逗号分隔数字')
        print('例如: fitness.sh progress \"75.5,75.0,74.8,74.2,73.9\"')
        sys.exit(1)

    if len(weights) < 2:
        print('[错误] 至少需要2个体重数据')
        sys.exit(1)

    start_w = weights[0]
    current_w = weights[-1]
    total_change = current_w - start_w
    n = len(weights)

    # 计算趋势
    avg_change = total_change / (n - 1)
    max_w = max(weights)
    min_w = min(weights)

    # 计算波动性
    diffs = [abs(weights[i] - weights[i-1]) for i in range(1, n)]
    avg_diff = sum(diffs) / len(diffs)

    print('=' * 50)
    print('📊 体重进度追踪')
    print('=' * 50)
    print()
    print('📈 体重数据 ({n}次记录):'.format(n=n))
    print()

    # ASCII 趋势图
    chart_width = 40
    chart_height = 10
    w_range = max_w - min_w if max_w != min_w else 1
    print('  {max_w:.1f}kg ┤'.format(max_w=max_w))
    for row in range(chart_height - 2, -1, -1):
        line_val = min_w + (w_range * row / (chart_height - 1))
        chars = []
        for i, w in enumerate(weights):
            pos = int((w - min_w) / w_range * (chart_height - 1))
            if pos == row:
                chars.append('●')
            elif i > 0:
                prev_pos = int((weights[i-1] - min_w) / w_range * (chart_height - 1))
                if (prev_pos <= row <= pos) or (pos <= row <= prev_pos):
                    chars.append('│')
                else:
                    chars.append(' ')
            else:
                chars.append(' ')
        # 每个数据点占一定宽度
        step = max(1, chart_width // n)
        display = ''
        for c in chars:
            display += c + ' ' * (step - 1)
        if row == 0:
            print('  {min_w:.1f}kg ┤{line}'.format(min_w=min_w, line=display))
        else:
            print('          │{line}'.format(line=display))
    print('          └' + '─' * (chart_width + 2))
    label = '    '
    for i in range(n):
        step = max(1, chart_width // n)
        label += str(i+1)
        label += ' ' * (step - len(str(i+1)))
    print(label + ' (次)')
    print()

    # 统计
    print('📋 统计分析:')
    print('  起始体重: {w:.1f}kg'.format(w=start_w))
    print('  当前体重: {w:.1f}kg'.format(w=current_w))
    print('  总变化:   {c:+.1f}kg'.format(c=total_change))
    print('  平均每次: {c:+.2f}kg'.format(c=avg_change))
    print('  最高: {w:.1f}kg | 最低: {w2:.1f}kg'.format(w=max_w, w2=min_w))
    print('  波动性:   {d:.2f}kg/次 (越小越稳定)'.format(d=avg_diff))
    print()

    # 趋势判断
    if total_change < -0.5:
        print('📉 趋势: 体重下降中 ✅')
        print('  坚持得不错！体重整体呈下降趋势。')
        if avg_change < -1:
            print('  ⚠️  减重速度较快({c:.1f}kg/次)，注意不要太激进'.format(c=avg_change))
            print('  建议每周减重0.5-1kg，过快可能丢失肌肉')
    elif total_change > 0.5:
        print('📈 趋势: 体重上升中')
        if True:  # Could check if intentional
            print('  如果目标是增肌，体重上升是正常的')
            print('  如果目标是减脂，需要调整饮食和运动')
    else:
        print('➡️  趋势: 体重基本稳定')
        print('  体重波动在正常范围内')

    # 预测
    if abs(avg_change) > 0.05:
        print()
        print('🔮 趋势预测 (按当前速率):')
        for weeks in [4, 8, 12]:
            predicted = current_w + avg_change * weeks
            print('  {w}周后: 约{p:.1f}kg ({c:+.1f}kg)'.format(
                w=weeks, p=predicted, c=avg_change * weeks))

    print()
    print('💡 建议:')
    if avg_diff > 1:
        print('  • 体重波动较大，注意饮食规律性')
        print('  • 建议每天固定时间称重(晨起空腹)')
    print('  • 每周记录一次更有参考价值')
    print('  • 配合体脂率和围度测量更科学')
    print('  • 不要太在意短期波动，看长期趋势')

" "$CMD" "$@"
    ;;
  help|*)
    show_help
    ;;
esac

echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
