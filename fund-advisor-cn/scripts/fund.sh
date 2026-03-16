#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

CMD="${1:-help}"

python3 - "$@" << 'PYTHON_SCRIPT'
import sys
import math

def fmt_money(v):
    return "{:,.2f}".format(v)

def calc_invest(monthly, annual_rate_pct, years):
    """定投收益计算（复利）"""
    monthly_rate = annual_rate_pct / 100.0 / 12.0
    months = years * 12
    total_invested = monthly * months

    if monthly_rate == 0:
        final_value = total_invested
    else:
        # 定投终值公式: FV = PMT * ((1+r)^n - 1) / r * (1+r)
        final_value = monthly * ((math.pow(1 + monthly_rate, months) - 1) / monthly_rate) * (1 + monthly_rate)

    profit = final_value - total_invested
    profit_rate = (profit / total_invested * 100) if total_invested > 0 else 0

    return {
        'monthly': monthly,
        'annual_rate': annual_rate_pct,
        'years': years,
        'months': months,
        'total_invested': round(total_invested, 2),
        'final_value': round(final_value, 2),
        'profit': round(profit, 2),
        'profit_rate': round(profit_rate, 2),
    }

def calc_compare(monthly, years, rates_str):
    """多收益率对比"""
    rates = [float(r.strip()) for r in rates_str.split(',')]
    results = []
    for rate in rates:
        r = calc_invest(monthly, rate, years)
        results.append(r)
    return results

def allocate_assets(risk_type, total_amount):
    """资产配置建议"""
    total = float(total_amount)
    print("")

    plans = {
        '保守': {
            'emoji': '🛡️',
            'desc': '保守型 — 稳字当头，跑赢通胀',
            'expected': '3%~5%',
            'allocation': [
                ('货币基金', 0.30, '1.5%~2.5%', '余额宝/零钱通，随时取用'),
                ('纯债基金', 0.40, '3%~5%', '短债/中短债基金，波动小'),
                ('指数基金', 0.20, '6%~10%', '沪深300，定投摊低成本'),
                ('黄金ETF', 0.10, '3%~8%', '抗通胀+避险配置'),
            ],
            'tips': [
                '核心目标：保本增值，跑赢通胀(2%~3%)',
                '债券基金选纯债，不选可转债（波动大）',
                '指数部分用定投方式买入，降低择时风险',
                '每季度检查一次，偏离>5%才调整',
            ]
        },
        '稳健': {
            'emoji': '⚖️',
            'desc': '稳健型 — 攻守兼备，长期增值',
            'expected': '6%~10%',
            'allocation': [
                ('货币基金', 0.10, '1.5%~2.5%', '应急资金，3-6个月支出'),
                ('债券基金', 0.25, '3%~6%', '纯债+混合债，稳定底仓'),
                ('宽基指数', 0.35, '8%~12%', '沪深300+中证500，定投核心'),
                ('行业主题', 0.15, '10%~20%', '消费/医药/科技，轮动配置'),
                ('QDII/黄金', 0.15, '5%~15%', '海外指数+黄金，分散风险'),
            ],
            'tips': [
                '核心目标：年化6%~10%，承受15%以内回撤',
                '指数基金占大头，坚持定投不择时',
                '行业主题不超过20%，避免押注单一赛道',
                '每半年再平衡一次，卖涨补跌',
                '至少持有3年以上，穿越一个完整周期',
            ]
        },
        '激进': {
            'emoji': '🚀',
            'desc': '激进型 — 追求高收益，承受高波动',
            'expected': '10%~15%+',
            'allocation': [
                ('货币基金', 0.05, '1.5%~2.5%', '极少量应急资金'),
                ('宽基指数', 0.30, '8%~12%', '沪深300+中证500+创业板'),
                ('行业指数', 0.25, '10%~25%', '半导体/新能源/AI/消费'),
                ('主动股基', 0.20, '12%~20%', '优秀基金经理的偏股混合'),
                ('QDII海外', 0.15, '8%~18%', '纳斯达克100/标普500'),
                ('另类资产', 0.05, '高波动', '商品/REITs'),
            ],
            'tips': [
                '核心目标：长期年化10%+，能承受30%以上回撤',
                '必须是3-5年不用的闲钱！',
                '大跌是加仓良机，越跌越买（纪律执行）',
                '行业集中度不超过30%，分散是唯一免费的午餐',
                '每季度再平衡，严格执行止盈纪律',
                '学会看PE/PB估值，低估买高估卖',
            ]
        }
    }

    if risk_type not in plans:
        print("⚠️  未知风险偏好: {}".format(risk_type))
        print("   支持: 保守 / 稳健 / 激进")
        return

    plan = plans[risk_type]
    print("{} {}".format(plan['emoji'], plan['desc']))
    print("=" * 55)
    print("  总投资金额: {} 元".format(fmt_money(total)))
    print("  预期年化:   {}".format(plan['expected']))
    print("")
    print("  📊 资产配置方案:")
    print("  {:<12s} {:<8s} {:<14s} {:<12s} {}".format(
        "资产类别", "比例", "金额", "预期收益", "说明"))
    print("  " + "─" * 65)
    for name, ratio, expected, note in plan['allocation']:
        amount = total * ratio
        print("  {:<12s} {:>5.0f}%   {:<14s} {:<12s} {}".format(
            name, ratio * 100, fmt_money(amount), expected, note))
    print("")
    print("  💡 配置要点:")
    for i, tip in enumerate(plan['tips'], 1):
        print("     {}. {}".format(i, tip))
    print("")

def rebalance_portfolio(holdings_str):
    """再平衡建议"""
    print("")
    print("🔄 投资组合再平衡分析")
    print("=" * 55)

    # 解析持仓: "股票50,债券30,货币20" 格式
    parts = holdings_str.split(',')
    holdings = {}
    total = 0
    for part in parts:
        part = part.strip()
        # 尝试解析 "名称金额" 或 "名称 金额"
        for i in range(len(part)):
            if part[i].isdigit() or part[i] == '.':
                name = part[:i].strip()
                amount = float(part[i:])
                holdings[name] = amount
                total += amount
                break

    if not holdings or total == 0:
        print("  ⚠️ 解析失败，请用格式: \"股票50000,债券30000,货币20000\"")
        return

    print("")
    print("  📋 当前持仓 (总计: {} 元):".format(fmt_money(total)))
    print("  {:<12s} {:<14s} {:<8s} {}".format("类别", "金额", "占比", ""))
    print("  " + "─" * 45)
    for name, amount in sorted(holdings.items(), key=lambda x: x[1], reverse=True):
        pct = amount / total * 100
        bar_len = int(pct / 5)
        bar = "█" * bar_len
        print("  {:<12s} {:<14s} {:>5.1f}%  {}".format(name, fmt_money(amount), pct, bar))
    print("")

    # 标准配置参考（稳健型）
    targets = {
        '股票': 0.35, '股基': 0.35, '指数': 0.35,
        '债券': 0.30, '债基': 0.30,
        '货币': 0.15, '现金': 0.15,
        '黄金': 0.10,
        '海外': 0.10, 'QDII': 0.10,
    }

    print("  📐 稳健型目标配置 vs 当前偏离:")
    print("  {:<12s} {:<8s} {:<8s} {:<10s} {}".format("类别", "当前", "目标", "偏离", "建议"))
    print("  " + "─" * 55)
    has_suggestion = False
    for name, amount in holdings.items():
        current_pct = amount / total * 100
        target_pct = targets.get(name, 0) * 100
        if target_pct == 0:
            # 未知分类，按当前比例建议
            print("  {:<12s} {:>5.1f}%   {:>5s}   {:>5s}   ℹ️ 未在标准配置中".format(
                name, current_pct, "-", "-"))
            continue
        deviation = current_pct - target_pct
        if abs(deviation) > 5:
            has_suggestion = True
            if deviation > 0:
                action = "⬇ 减持 {}".format(fmt_money(amount - total * targets[name]))
            else:
                action = "⬆ 增持 {}".format(fmt_money(total * targets[name] - amount))
        else:
            action = "✅ 在合理范围"
        print("  {:<12s} {:>5.1f}%   {:>5.1f}%  {:>+5.1f}%   {}".format(
            name, current_pct, target_pct, deviation, action))
    print("")

    if has_suggestion:
        print("  ⚠️ 部分资产偏离目标配置>5%，建议再平衡")
        print("  💡 再平衡方法:")
        print("     1. 卖出超配资产，买入低配资产")
        print("     2. 或：新增资金全部投入低配类别")
        print("     3. 建议每半年检查一次")
    else:
        print("  ✅ 当前配置在合理范围内，暂无需调整")
    print("")

def show_types():
    print("")
    print("📚 基金类型科普")
    print("=" * 55)
    print("")
    print("1️⃣  货币基金")
    print("   风险: ⭐ 极低")
    print("   预期年化: 1.5%~2.5%")
    print("   特点: 类似活期存款，随时赎回，收益稳定")
    print("   适合: 现金管理、应急资金")
    print("   代表: 余额宝、零钱通")
    print("")
    print("2️⃣  债券基金")
    print("   风险: ⭐⭐ 较低")
    print("   预期年化: 3%~6%")
    print("   特点: 主要投资债券，波动较小")
    print("   适合: 稳健投资者、中短期投资")
    print("   分类: 纯债基金、混合债基、可转债基金")
    print("")
    print("3️⃣  指数基金")
    print("   风险: ⭐⭐⭐ 中等")
    print("   预期年化: 6%~12%（长期）")
    print("   特点: 跟踪指数，费率低，透明度高")
    print("   适合: 定投首选，长期投资者")
    print("   代表: 沪深300、中证500、创业板指数")
    print("")
    print("4️⃣  混合基金")
    print("   风险: ⭐⭐⭐ 中等偏高")
    print("   预期年化: 5%~15%（视配置）")
    print("   特点: 股债混合配置，灵活调整比例")
    print("   适合: 有一定风险承受能力的投资者")
    print("   分类: 偏股混合、偏债混合、灵活配置")
    print("")
    print("5️⃣  股票基金")
    print("   风险: ⭐⭐⭐⭐ 较高")
    print("   预期年化: 8%~20%+（波动大）")
    print("   特点: 80%以上投资股票，收益和风险都高")
    print("   适合: 高风险承受能力、长期持有")
    print("")
    print("6️⃣  QDII基金")
    print("   风险: ⭐⭐⭐⭐ 较高")
    print("   预期年化: 视标的市场而定")
    print("   特点: 投资海外市场，分散地域风险")
    print("   适合: 全球配置、对冲国内市场风险")
    print("")
    print("💡 定投建议：指数基金是定投首选，低费率+分散风险")
    print("")

def show_strategy(risk_type):
    print("")
    risk_map = {
        '保守': {
            'emoji': '🛡️',
            'allocation': '债券70% + 指数30%',
            'expected': '4%~6%',
            'period': '1~3年',
            'stop_profit': '15%~20%',
            'tips': [
                '以纯债基金为主，搭配少量宽基指数',
                '定投频率：每月1次即可',
                '止盈策略：收益达15%可分批止盈',
                '推荐标的：短债基金 + 沪深300指数',
                '遇到大跌不加仓，保持原有节奏',
            ]
        },
        '稳健': {
            'emoji': '⚖️',
            'allocation': '指数50% + 债券30% + 混合20%',
            'expected': '6%~10%',
            'period': '3~5年',
            'stop_profit': '25%~35%',
            'tips': [
                '以宽基指数为核心，债券和混合做卫星',
                '定投频率：每月1~2次（发薪日定投）',
                '止盈策略：目标收益率法，达25%止盈一半',
                '推荐标的：沪深300 + 中证500 + 纯债',
                '大跌时可适当加倍定投（越跌越买）',
                '坚持3年以上，不看短期波动',
            ]
        },
        '积极': {
            'emoji': '🚀',
            'allocation': '指数60% + 股票基金30% + 行业10%',
            'expected': '10%~15%+',
            'period': '5年以上',
            'stop_profit': '40%~60%',
            'tips': [
                '以宽基指数+行业指数为主',
                '定投频率：每周1次，分散买入时机',
                '止盈策略：估值止盈法，PE>历史80%分位时止盈',
                '推荐标的：创业板 + 中证500 + 消费/科技行业',
                '大跌是加仓良机，定投金额可翻倍',
                '必须能承受30%以上的短期浮亏',
                '定投周期至少5年，享受完整牛熊周期',
            ]
        }
    }

    if risk_type not in risk_map:
        print("⚠️  未知风险偏好: {}".format(risk_type))
        print("   支持: 保守 / 稳健 / 积极")
        return

    s = risk_map[risk_type]
    print("{} {} 型定投策略".format(s['emoji'], risk_type))
    print("=" * 45)
    print("")
    print("  📊 资产配置:   {}".format(s['allocation']))
    print("  📈 预期年化:   {}".format(s['expected']))
    print("  ⏱️  建议周期:   {}".format(s['period']))
    print("  🎯 止盈目标:   {}".format(s['stop_profit']))
    print("")
    print("  💡 策略要点:")
    for i, tip in enumerate(s['tips'], 1):
        print("     {}. {}".format(i, tip))
    print("")

def calc_sharpe(annual_return, volatility, risk_free):
    """夏普比率"""
    sharpe = (annual_return - risk_free) / volatility if volatility > 0 else 0
    print("")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("  📐 夏普比率 (Sharpe Ratio)")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("  年化收益:    {}%".format(annual_return))
    print("  年化波动率:  {}%".format(volatility))
    print("  无风险利率:  {}%".format(risk_free))
    print("  ──────────────────────")
    print("  夏普比率:    {:.4f}".format(sharpe))
    print("")
    if sharpe < 0:
        print("  📉 评级: 极差 — 收益不如无风险资产")
    elif sharpe < 0.5:
        print("  ⚠️  评级: 较差 — 风险补偿不足")
    elif sharpe < 1.0:
        print("  📊 评级: 一般 — 可接受")
    elif sharpe < 2.0:
        print("  ✅ 评级: 优秀 — 风险收益比良好")
    else:
        print("  🏆 评级: 卓越 — 顶级风险调整收益")
    print("")
    print("  💡 公式: Sharpe = (Rp - Rf) / σp")
    print("  💡 基准: >1.0优秀, >2.0卓越, <0不如存银行")
    print("")

def calc_max_drawdown(nav_str):
    """最大回撤"""
    navs = [float(x.strip()) for x in nav_str.split(',')]
    peak = navs[0]
    max_dd = 0
    max_dd_peak = navs[0]
    max_dd_trough = navs[0]
    current_peak = navs[0]
    
    for nav in navs:
        if nav > current_peak:
            current_peak = nav
        dd = (current_peak - nav) / current_peak * 100
        if dd > max_dd:
            max_dd = dd
            max_dd_peak = current_peak
            max_dd_trough = nav
    
    print("")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("  📉 最大回撤 (Max Drawdown)")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("  净值序列:  {} 个数据点".format(len(navs)))
    print("  最高点:    {}".format(max_dd_peak))
    print("  最低点:    {}".format(max_dd_trough))
    print("  ──────────────────────")
    print("  最大回撤:  {:.2f}%".format(max_dd))
    print("")
    if max_dd < 10:
        print("  ✅ 风险极低 — 低波动产品(货币/短债)")
    elif max_dd < 20:
        print("  📊 风险适中 — 均衡型产品")
    elif max_dd < 30:
        print("  ⚠️  风险较高 — 偏股型基金正常范围")
    elif max_dd < 50:
        print("  🔴 风险高 — 需要强大心理承受力")
    else:
        print("  💀 极高风险 — 超过50%回撤，考虑是否适合")
    print("")
    print("  💡 公式: MDD = (Peak - Trough) / Peak × 100%")
    print("  💡 沪深300历史最大回撤约72%(2007-2008)")
    print("")

def calc_kelly(win_rate_pct, odds):
    """凯利公式"""
    p = win_rate_pct / 100.0
    q = 1 - p
    b = odds
    kelly = (b * p - q) / b if b > 0 else 0
    half_kelly = kelly / 2
    
    print("")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("  🎯 凯利公式 (Kelly Criterion)")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("  胜率:      {}%".format(win_rate_pct))
    print("  赔率:      {} (赚{}倍/亏1倍)".format(odds, odds))
    print("  ──────────────────────")
    print("  凯利仓位:  {:.1f}%".format(kelly * 100))
    print("  半凯利:    {:.1f}% (推荐,更稳)".format(half_kelly * 100))
    print("")
    if kelly <= 0:
        print("  🚫 建议: 不参与! 期望为负")
    elif kelly < 0.1:
        print("  ⚠️  建议: 小仓位试探")
    elif kelly < 0.25:
        print("  📊 建议: 适中仓位")
    else:
        print("  ✅ 建议: 凯利公式建议重仓，但实操用半凯利更安全")
    print("")
    ev = p * odds - q
    print("  📈 期望值: 每投1元预期收益 {:.2f} 元".format(ev))
    print("  💡 公式: f = (bp - q) / b")
    print("  💡 实战: 永远用半凯利，避免连续亏损爆仓")
    print("")

def calc_monte_carlo(monthly, annual_return, annual_vol, years):
    """蒙特卡罗模拟"""
    import random
    random.seed(42)
    
    monthly_return = annual_return / 100.0 / 12.0
    monthly_vol = annual_vol / 100.0 / (12 ** 0.5)
    months = years * 12
    simulations = 1000
    total_invested = monthly * months
    
    results = []
    for _ in range(simulations):
        balance = 0
        for m in range(months):
            r = random.gauss(monthly_return, monthly_vol)
            balance = (balance + monthly) * (1 + r)
        results.append(balance)
    
    results.sort()
    p5 = results[int(simulations * 0.05)]
    p25 = results[int(simulations * 0.25)]
    p50 = results[int(simulations * 0.50)]
    p75 = results[int(simulations * 0.75)]
    p95 = results[int(simulations * 0.95)]
    avg = sum(results) / len(results)
    
    print("")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("  🎲 蒙特卡罗模拟 (1000次)")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("  月定投:    {} 元".format(fmt_money(monthly)))
    print("  预期收益:  {}%/年".format(annual_return))
    print("  波动率:    {}%/年".format(annual_vol))
    print("  定投年数:  {} 年".format(years))
    print("  总投入:    {} 元".format(fmt_money(total_invested)))
    print("  ──────────────────────")
    print("  最悲观 5%:   {} 元".format(fmt_money(p5)))
    print("  较悲观25%:   {} 元".format(fmt_money(p25)))
    print("  中位数 50%:  {} 元".format(fmt_money(p50)))
    print("  较乐观 75%:  {} 元".format(fmt_money(p75)))
    print("  最乐观 95%:  {} 元".format(fmt_money(p95)))
    print("  平均值:      {} 元".format(fmt_money(avg)))
    print("")
    lose_prob = len([r for r in results if r < total_invested]) / simulations * 100
    double_prob = len([r for r in results if r > total_invested * 2]) / simulations * 100
    print("  📊 亏损概率:  {:.1f}%".format(lose_prob))
    print("  📊 翻倍概率:  {:.1f}%".format(double_prob))
    print("")
    print("  💡 基于正态分布随机模拟，实际市场有肥尾效应")
    print("  💡 波动率越高，结果分散度越大")
    print("")

def calc_fire(annual_expense, return_rate, current_savings):
    """FIRE财务自由计算"""
    fire_number = annual_expense * 25  # 4% rule
    safe_fire = annual_expense / (return_rate / 100.0) if return_rate > 0 else 0
    gap = max(0, fire_number - current_savings)
    
    # How many years to FIRE with current savings + investment
    if return_rate > 0 and gap > 0:
        r = return_rate / 100.0
        # Simplified: years = ln(FIRE/current) / ln(1+r)
        if current_savings > 0:
            years_no_save = math.log(fire_number / current_savings) / math.log(1 + r)
        else:
            years_no_save = float('inf')
    else:
        years_no_save = float('inf')
    
    print("")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("  🔥 FIRE 财务自由计算")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("  年支出:        {} 元".format(fmt_money(annual_expense)))
    print("  投资收益率:    {}%/年".format(return_rate))
    print("  当前存款:      {} 元".format(fmt_money(current_savings)))
    print("  ──────────────────────")
    print("  4%法则目标:    {} 元 (年支出×25)".format(fmt_money(fire_number)))
    print("  精确目标:      {} 元 (年支出÷收益率)".format(fmt_money(safe_fire)))
    print("  还差:          {} 元".format(fmt_money(gap)))
    if years_no_save < 100:
        print("  纯投资到达:    {:.1f} 年 (不再追加)".format(years_no_save))
    print("")
    print("  📋 FIRE 三级目标:")
    print("    Coast FIRE:   {} 元 (存够本金,靠复利增长)".format(fmt_money(fire_number * 0.4)))
    print("    Lean FIRE:    {} 元 (基本生活自由)".format(fmt_money(fire_number * 0.6)))
    print("    Fat FIRE:     {} 元 (高品质生活自由)".format(fmt_money(fire_number * 1.5)))
    print("")
    # Monthly savings needed
    for y in [5, 10, 15, 20]:
        r_m = return_rate / 100.0 / 12.0
        n = y * 12
        if r_m > 0:
            monthly_needed = gap * r_m / (math.pow(1 + r_m, n) - 1)
        else:
            monthly_needed = gap / n if n > 0 else 0
        print("  {}年达成需月存: {} 元".format(y, fmt_money(monthly_needed)))
    print("")
    print("  💡 4%法则: 每年取出不超过4%，资产可维持30年+")
    print("")

def calc_var(total_amount, annual_return, annual_vol, confidence):
    """VaR风险价值"""
    z_scores = {90: 1.282, 95: 1.645, 99: 2.326}
    z = z_scores.get(int(confidence), 1.645)
    
    daily_return = annual_return / 100.0 / 252
    daily_vol = annual_vol / 100.0 / (252 ** 0.5)
    
    daily_var = total_amount * (daily_return - z * daily_vol)
    monthly_var = total_amount * (annual_return / 100.0 / 12 - z * annual_vol / 100.0 / (12 ** 0.5))
    annual_var = total_amount * (annual_return / 100.0 - z * annual_vol / 100.0)
    
    print("")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("  ⚠️  VaR 风险价值")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("  投资总额:    {} 元".format(fmt_money(total_amount)))
    print("  年化收益:    {}%".format(annual_return))
    print("  年化波动:    {}%".format(annual_vol))
    print("  置信度:      {}%".format(confidence))
    print("  ──────────────────────")
    print("  单日最大亏损: {} 元".format(fmt_money(abs(daily_var))))
    print("  单月最大亏损: {} 元".format(fmt_money(abs(monthly_var))))
    print("  全年最大亏损: {} 元".format(fmt_money(abs(annual_var))))
    print("")
    print("  📊 含义: 在{}%置信度下".format(int(confidence)))
    print("     单日亏损不超过 {} 元".format(fmt_money(abs(daily_var))))
    print("     (即{}%的交易日亏损在此范围内)".format(int(confidence)))
    print("")
    print("  💡 VaR不衡量极端情况(黑天鹅)")
    print("  💡 实际使用建议同时参考最大回撤")
    print("")

def calc_irr(cashflow_str):
    """内部收益率"""
    cfs = [float(x.strip()) for x in cashflow_str.split(',')]
    
    # Newton's method for IRR
    def npv(rate, cashflows):
        return sum(cf / (1 + rate) ** i for i, cf in enumerate(cashflows))
    
    rate = 0.1  # initial guess
    for _ in range(1000):
        f = npv(rate, cfs)
        # derivative
        df = sum(-i * cf / (1 + rate) ** (i + 1) for i, cf in enumerate(cfs))
        if abs(df) < 1e-12:
            break
        new_rate = rate - f / df
        if abs(new_rate - rate) < 1e-10:
            rate = new_rate
            break
        rate = new_rate
    
    print("")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("  📈 IRR 内部收益率")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("  现金流: {}".format(' → '.join([fmt_money(c) for c in cfs])))
    print("  期数:   {} 期".format(len(cfs)))
    print("  ──────────────────────")
    print("  IRR:    {:.2f}%".format(rate * 100))
    total_in = sum(abs(c) for c in cfs if c < 0)
    total_out = sum(c for c in cfs if c > 0)
    print("  总投入: {} 元".format(fmt_money(total_in)))
    print("  总回收: {} 元".format(fmt_money(total_out)))
    print("  净利润: {} 元".format(fmt_money(total_out - total_in)))
    print("")
    if rate > 0.15:
        print("  🏆 优秀投资! IRR > 15%")
    elif rate > 0.08:
        print("  ✅ 良好投资, 跑赢大盘")
    elif rate > 0:
        print("  📊 一般投资")
    else:
        print("  ❌ 亏损投资")
    print("")
    print("  💡 IRR = 使NPV为0的折现率")
    print("  💡 适合评估定投、分期等不规则现金流")
    print("")

def calc_avg_cost(records_str):
    """持仓成本计算(摊薄法)"""
    records = records_str.split(',')
    total_cost = 0
    total_shares = 0
    
    print("")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("  💰 持仓成本分析")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    
    for i, record in enumerate(records):
        parts = record.strip().split('x')
        price = float(parts[0])
        shares = float(parts[1])
        cost = price * shares
        total_cost += cost
        total_shares += shares
        avg = total_cost / total_shares
        print("  第{}笔: 价格{} × {}份 = {} 元 | 摊薄成本: {}".format(
            i + 1, price, fmt_money(shares), fmt_money(cost), fmt_money(avg / 1) if shares > 0 else '0'))
    
    avg_cost = total_cost / total_shares if total_shares > 0 else 0
    print("  ──────────────────────")
    print("  总份额:    {}".format(fmt_money(total_shares)))
    print("  总成本:    {} 元".format(fmt_money(total_cost)))
    print("  平均成本:  {} 元/份".format(fmt_money(avg_cost)))
    print("")
    # Break-even and target prices
    print("  📊 目标价位:")
    for pct in [5, 10, 20, 50, 100]:
        target = avg_cost * (1 + pct / 100.0)
        profit = total_shares * (target - avg_cost)
        print("    +{}%: {} 元/份 → 盈利 {} 元".format(pct, fmt_money(target), fmt_money(profit)))
    print("")
    print("  💡 低位多买，高位少买，定投自动实现")
    print("")

def show_help():
    print("=" * 50)
    print("  基金定投顾问")
    print("=" * 50)
    print("")
    print("用法:")
    print("  fund.sh invest <月定投额> <年化收益%> <定投年数>")
    print("      定投收益计算")
    print("  fund.sh dca <月定投额> <年化收益%> <定投年数>")
    print("      定投计算器（同invest，含复利+真实年化）")
    print("  fund.sh compare <金额> <年数> <收益率1%,收益率2%,...>")
    print("      多收益率对比")
    print("  fund.sh allocate <保守|稳健|激进> <总金额>")
    print("      资产配置建议（三种方案详细配置）")
    print("  fund.sh rebalance <当前持仓>")
    print("      再平衡建议（偏离目标配置时提醒调整）")
    print("  fund.sh types")
    print("      基金类型科普")
    print("  fund.sh strategy <保守|稳健|积极>")
    print("      定投策略建议")
    print("  fund.sh help")
    print("      显示帮助")
    print("")
    print("示例:")
    print("  fund.sh invest 2000 8 10")
    print("  fund.sh dca 3000 10 20")
    print("  fund.sh compare 1000 10 5,8,12")
    print("  fund.sh allocate 稳健 100000")
    print('  fund.sh rebalance "股票50000,债券30000,货币20000"')
    print("  fund.sh types")
    print("  fund.sh strategy 稳健")

def main():
    args = sys.argv[1:]
    if len(args) == 0:
        show_help()
        return

    cmd = args[0]

    if cmd == 'help':
        show_help()

    elif cmd == 'invest' or cmd == 'dca':
        if len(args) < 4:
            print("用法: fund.sh {} <月定投额> <年化收益%> <定投年数>".format(cmd))
            sys.exit(1)
        monthly = float(args[1])
        rate = float(args[2])
        years = int(args[3])
        r = calc_invest(monthly, rate, years)
        print("")
        print("📈 定投收益计算（复利）")
        print("─" * 40)
        print("  每月定投:     {} 元".format(fmt_money(r['monthly'])))
        print("  年化收益率:   {}%".format(r['annual_rate']))
        print("  定投年数:     {} 年（{} 期）".format(r['years'], r['months']))
        print("─" * 40)
        print("  💰 累计投入:  {} 元".format(fmt_money(r['total_invested'])))
        print("  📊 期末市值:  {} 元".format(fmt_money(r['final_value'])))
        print("  🎉 投资收益:  {} 元".format(fmt_money(r['profit'])))
        print("  📈 总收益率:  {}%".format(r['profit_rate']))
        # 真实年化收益率
        if r['total_invested'] > 0 and years > 0:
            real_annual = (pow(r['final_value'] / r['total_invested'], 1.0 / years) - 1) * 100
            print("  📊 真实年化:  {:.2f}% (考虑分批投入)".format(real_annual))
        print("")
        # 年度明细（每5年一个节点）
        if years >= 5:
            print("  📅 定投里程碑:")
            for y in range(5, years + 1, 5):
                milestone = calc_invest(monthly, rate, y)
                print("     第{:>2d}年: 投入 {} → 市值 {} (+{:.0f}%)".format(
                    y,
                    fmt_money(milestone['total_invested']),
                    fmt_money(milestone['final_value']),
                    milestone['profit_rate']
                ))
            print("")

    elif cmd == 'compare':
        if len(args) < 4:
            print("用法: fund.sh compare <金额> <年数> <收益率1%,收益率2%,...>")
            sys.exit(1)
        monthly = float(args[1])
        years = int(args[2])
        rates_str = args[3]
        results = calc_compare(monthly, years, rates_str)
        print("")
        print("📊 定投收益率对比")
        print("─" * 55)
        print("  每月定投: {} 元 | 定投: {} 年".format(fmt_money(monthly), years))
        print("─" * 55)
        print("  {:<8s}  {:<15s}  {:<15s}  {:<10s}".format("年化", "累计投入", "期末市值", "总收益率"))
        print("  " + "─" * 50)
        for r in results:
            print("  {:<8s}  {:<15s}  {:<15s}  {:<10s}".format(
                "{}%".format(r['annual_rate']),
                fmt_money(r['total_invested']),
                fmt_money(r['final_value']),
                "{}%".format(r['profit_rate'])
            ))
        print("")
        if len(results) >= 2:
            diff = results[-1]['final_value'] - results[0]['final_value']
            print("  💡 最高与最低收益率差异: {} 元".format(fmt_money(abs(diff))))
            print("  💡 长期复利效应显著，收益率差几个点，结果差很多！")
        print("")

    elif cmd == 'types':
        show_types()

    elif cmd == 'strategy':
        if len(args) < 2:
            print("用法: fund.sh strategy <保守|稳健|积极>")
            sys.exit(1)
        show_strategy(args[1])

    elif cmd == 'allocate':
        if len(args) < 3:
            print("用法: fund.sh allocate <保守|稳健|激进> <总金额>")
            sys.exit(1)
        allocate_assets(args[1], args[2])

    elif cmd == 'rebalance':
        if len(args) < 2:
            print("用法: fund.sh rebalance \"股票50000,债券30000,货币20000\"")
            sys.exit(1)
        rebalance_portfolio(args[1])

    elif cmd == 'sharpe':
        if len(args) < 4:
            print("用法: fund.sh sharpe <年化收益%> <年化波动率%> <无风险利率%>")
            print("示例: fund.sh sharpe 15 20 3")
            sys.exit(1)
        calc_sharpe(float(args[1]), float(args[2]), float(args[3]))

    elif cmd == 'maxdd':
        if len(args) < 2:
            print("用法: fund.sh maxdd <净值序列,逗号分隔>")
            print("示例: fund.sh maxdd 1.0,1.2,1.1,0.9,1.0,1.3")
            sys.exit(1)
        calc_max_drawdown(args[1])

    elif cmd == 'kelly':
        if len(args) < 3:
            print("用法: fund.sh kelly <胜率%> <赔率(盈亏比)>")
            print("示例: fund.sh kelly 60 2   (60%胜率，赚2倍亏1倍)")
            sys.exit(1)
        calc_kelly(float(args[1]), float(args[2]))

    elif cmd == 'monte':
        if len(args) < 4:
            print("用法: fund.sh monte <月定投额> <年化收益%> <年化波动率%> [年数]")
            print("示例: fund.sh monte 1000 10 15 20")
            sys.exit(1)
        years = int(args[4]) if len(args) > 4 else 10
        calc_monte_carlo(float(args[1]), float(args[2]), float(args[3]), years)

    elif cmd == 'fire':
        if len(args) < 3:
            print("用法: fund.sh fire <年支出> <年投资收益%> [当前存款]")
            print("示例: fund.sh fire 120000 6 500000")
            sys.exit(1)
        current = float(args[3]) if len(args) > 3 else 0
        calc_fire(float(args[1]), float(args[2]), current)

    elif cmd == 'var':
        if len(args) < 4:
            print("用法: fund.sh var <投资总额> <年化收益%> <年化波动率%> [置信度%]")
            print("示例: fund.sh var 100000 8 15 95")
            sys.exit(1)
        conf = float(args[4]) if len(args) > 4 else 95
        calc_var(float(args[1]), float(args[2]), float(args[3]), conf)

    elif cmd == 'irr':
        if len(args) < 2:
            print("用法: fund.sh irr <现金流序列,逗号分隔>")
            print("示例: fund.sh irr -10000,3000,3000,3000,3000  (初始投1万,每年回3千)")
            sys.exit(1)
        calc_irr(args[1])

    elif cmd == 'cost':
        if len(args) < 2:
            print("用法: fund.sh cost <买入记录: 价格x份额,价格x份额,...>")
            print("示例: fund.sh cost 1.2x1000,1.0x2000,0.8x3000")
            sys.exit(1)
        calc_avg_cost(args[1])

    else:
        print("未知命令: {}".format(cmd))
        print("运行 'fund.sh help' 查看帮助")
        sys.exit(1)

if __name__ == '__main__':
    main()
PYTHON_SCRIPT

echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
