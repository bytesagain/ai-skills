#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

CMD="${1:-help}"

python3 - "$@" << 'PYTHON_SCRIPT'
import sys
import math

# ============ 2024 综合所得年度税率表 ============
ANNUAL_BRACKETS = [
    (36000,   0.03, 0),
    (144000,  0.10, 2520),
    (300000,  0.20, 16920),
    (420000,  0.25, 31920),
    (660000,  0.30, 52920),
    (960000,  0.35, 85920),
    (float('inf'), 0.45, 181920),
]

# ============ 年终奖月度换算税率表 ============
BONUS_MONTHLY_BRACKETS = [
    (3000,    0.03, 0),
    (12000,   0.10, 210),
    (25000,   0.20, 1410),
    (35000,   0.25, 2660),
    (55000,   0.30, 4410),
    (80000,   0.35, 7160),
    (float('inf'), 0.45, 15160),
]

# ============ 劳务报酬预扣率 ============
FREELANCE_BRACKETS = [
    (20000,   0.20, 0),
    (50000,   0.30, 2000),
    (float('inf'), 0.40, 7000),
]

def calc_annual_tax(taxable_income):
    """年度综合所得税额"""
    if taxable_income <= 0:
        return 0.0
    for upper, rate, deduction in ANNUAL_BRACKETS:
        if taxable_income <= upper:
            return taxable_income * rate - deduction
    return 0.0

def calc_monthly_tax(salary, social_insurance):
    """月薪个税（简化为单月计算）"""
    monthly_exempt = 5000
    taxable = salary - social_insurance - monthly_exempt
    if taxable <= 0:
        return {
            'salary': salary,
            'social_insurance': social_insurance,
            'exempt': monthly_exempt,
            'taxable': 0,
            'tax': 0,
            'after_tax': salary - social_insurance,
        }
    # 换算为年度应纳税所得额来查表
    annual_taxable = taxable * 12
    annual_tax = calc_annual_tax(annual_taxable)
    monthly_tax = round(annual_tax / 12, 2)
    return {
        'salary': salary,
        'social_insurance': social_insurance,
        'exempt': monthly_exempt,
        'taxable': round(taxable, 2),
        'tax': monthly_tax,
        'after_tax': round(salary - social_insurance - monthly_tax, 2),
    }

def calc_bonus_tax(bonus):
    """全年一次性奖金单独计税"""
    monthly_avg = bonus / 12.0
    tax = 0.0
    for upper, rate, deduction in BONUS_MONTHLY_BRACKETS:
        if monthly_avg <= upper:
            tax = bonus * rate - deduction
            break
    tax = round(max(tax, 0), 2)
    return {
        'bonus': bonus,
        'monthly_avg': round(monthly_avg, 2),
        'tax': tax,
        'after_tax': round(bonus - tax, 2),
        'effective_rate': round(tax / bonus * 100, 2) if bonus > 0 else 0,
    }

def calc_freelance_tax(income):
    """劳务报酬预扣预缴"""
    if income <= 800:
        taxable = 0
    elif income <= 4000:
        taxable = income - 800
    else:
        taxable = income * 0.8
    tax = 0.0
    for upper, rate, deduction in FREELANCE_BRACKETS:
        if taxable <= upper:
            tax = taxable * rate - deduction
            break
    tax = round(max(tax, 0), 2)
    return {
        'income': income,
        'taxable': round(taxable, 2),
        'tax': tax,
        'after_tax': round(income - tax, 2),
        'effective_rate': round(tax / income * 100, 2) if income > 0 else 0,
    }

def calc_annual_settlement(annual_income, special_deductions):
    """年度综合所得汇算清缴"""
    annual_exempt = 60000
    taxable = annual_income - special_deductions - annual_exempt
    if taxable <= 0:
        taxable = 0
    tax = round(calc_annual_tax(taxable), 2)
    monthly_avg_tax = round(tax / 12, 2)

    # 估算已预缴税额（按月均工资预扣）
    monthly_salary = annual_income / 12
    monthly_deduction = special_deductions / 12
    prepaid_tax = 0
    cumulative_income = 0
    cumulative_deduction = 0
    cumulative_tax = 0
    for m in range(12):
        cumulative_income += monthly_salary
        cumulative_deduction += monthly_deduction
        cum_taxable = cumulative_income - cumulative_deduction - 5000 * (m + 1)
        if cum_taxable <= 0:
            cum_taxable = 0
        cum_tax_should = calc_annual_tax(cum_taxable)
        month_tax = cum_tax_should - cumulative_tax
        cumulative_tax = cum_tax_should
        prepaid_tax += max(month_tax, 0)

    prepaid_tax = round(prepaid_tax, 2)
    refund = round(prepaid_tax - tax, 2)

    return {
        'annual_income': annual_income,
        'special_deductions': special_deductions,
        'annual_exempt': annual_exempt,
        'taxable': round(taxable, 2),
        'tax': tax,
        'prepaid_tax': prepaid_tax,
        'refund': refund,
        'monthly_avg_tax': monthly_avg_tax,
        'after_tax': round(annual_income - special_deductions - tax, 2),
        'effective_rate': round(tax / annual_income * 100, 2) if annual_income > 0 else 0,
    }

def optimize_tax(monthly_salary):
    """合理避税建议"""
    annual = monthly_salary * 12
    print("")
    print("💡 个税优化建议（月薪 {} 元）".format(fmt_money(monthly_salary)))
    print("=" * 55)
    print("")

    # 1. 公积金优化
    print("  1️⃣  公积金优化（免税额度最大化）")
    print("  ─" * 22)
    max_base = min(monthly_salary, 34188)  # 2024年上限参考
    ratios = [0.05, 0.07, 0.08, 0.10, 0.12]
    for ratio in ratios:
        gjj = round(max_base * ratio, 2)
        gjj_total = round(gjj * 2, 2)  # 个人+单位
        r = calc_monthly_tax(monthly_salary, gjj)
        print("     公积金{:>3.0f}%: 个人缴{:>8s} → 月税{:>8s} → 到手{:>10s}".format(
            ratio * 100, fmt_money(gjj), fmt_money(r['tax']), fmt_money(r['after_tax'])))
    print("     💡 公积金比例越高，到手看似少但实际含公积金余额更多")
    print("")

    # 2. 专项附加扣除清单
    print("  2️⃣  专项附加扣除（别漏了！最高可扣8600/月）")
    print("  ─" * 22)
    deductions = [
        ("子女教育", "2000/月/孩", "3岁到博士毕业"),
        ("继续教育", "400/月", "学历教育；职业资格3600/年"),
        ("住房贷款利息", "1000/月", "首套房贷，最长240个月"),
        ("住房租金", "800~1500/月", "无自有住房，按城市等级"),
        ("赡养老人", "3000/月", "独生子女；非独最高1500"),
        ("3岁以下婴幼儿", "2000/月/孩", "从出生当月起"),
        ("大病医疗", "最高80000/年", "个人负担超15000部分"),
    ]
    for name, amount, note in deductions:
        print("     {:<12s} {:<14s} {}".format(name, amount, note))
    print("")

    # 3. 年终奖分配优化
    print("  3️⃣  年终奖 vs 并入综合所得（选最优！）")
    print("  ─" * 22)
    # 假设年总包不变，测试不同年终奖拆分
    total_annual = annual
    test_bonuses = [0, 36000, 60000, 144000, annual * 0.2]
    test_bonuses = [b for b in test_bonuses if b < total_annual and b >= 0]
    test_bonuses = sorted(set([round(b, 0) for b in test_bonuses]))

    print("     {:<14s} {:<12s} {:<12s} {:<12s} {:<12s}".format(
        "年终奖", "年终奖税", "工资税", "合计税", "实际到手"))
    print("     " + "─" * 58)
    for bonus in test_bonuses:
        salary_part = total_annual - bonus
        if salary_part < 0:
            continue
        # 年终奖单独计税
        bonus_r = calc_bonus_tax(bonus)
        # 工资部分按年度汇算（假设无其他扣除）
        wage_taxable = salary_part - 60000
        if wage_taxable < 0:
            wage_taxable = 0
        wage_tax = round(calc_annual_tax(wage_taxable), 2)
        total_tax = bonus_r['tax'] + wage_tax
        take_home = total_annual - total_tax
        print("     {:<14s} {:<12s} {:<12s} {:<12s} {:<12s}".format(
            fmt_money(bonus), fmt_money(bonus_r['tax']),
            fmt_money(wage_tax), fmt_money(total_tax), fmt_money(take_home)))
    print("     💡 选合计税最少的方案！年终奖临界点: 36000/144000/300000")
    print("")

    # 4. 个人养老金
    print("  4️⃣  个人养老金（年扣12000，税率高的人更划算）")
    print("  ─" * 22)
    r_without = calc_monthly_tax(monthly_salary, 0)
    r_with_pension = calc_monthly_tax(monthly_salary, 1000)  # 12000/12=1000
    monthly_save = r_without['tax'] - r_with_pension['tax']
    annual_save = round(monthly_save * 12, 2)
    print("     每年缴12000元个人养老金")
    print("     每月可省税: {} 元 → 每年省: {} 元".format(fmt_money(monthly_save), fmt_money(annual_save)))
    print("     💡 退休后取出时按3%缴税，适合当前税率>3%的人")
    print("")

def compare_offers(salary1, salary2):
    """两个offer税后收入对比"""
    print("")
    print("⚖️ Offer税后收入对比")
    print("=" * 55)
    print("")

    # 假设五险一金按工资的22%估算（个人部分）
    social_rates = [0.22, 0.18, 0.15]
    social_labels = ["22%(一线城市)", "18%(二线城市)", "15%(三线城市)"]

    for rate, label in zip(social_rates, social_labels):
        print("  📍 五险一金比例: {}".format(label))
        print("  ─" * 22)
        print("  {:<16s} {:<16s} {:<16s}".format("", "Offer A", "Offer B"))
        s1, s2 = float(salary1), float(salary2)
        si1, si2 = round(s1 * rate, 2), round(s2 * rate, 2)
        r1 = calc_monthly_tax(s1, si1)
        r2 = calc_monthly_tax(s2, si2)
        print("  {:<16s} {:<16s} {:<16s}".format("税前月薪", fmt_money(s1), fmt_money(s2)))
        print("  {:<16s} {:<16s} {:<16s}".format("五险一金", fmt_money(si1), fmt_money(si2)))
        print("  {:<16s} {:<16s} {:<16s}".format("个税", fmt_money(r1['tax']), fmt_money(r2['tax'])))
        print("  {:<16s} {:<16s} {:<16s}".format("税后到手", fmt_money(r1['after_tax']), fmt_money(r2['after_tax'])))
        annual1 = round(r1['after_tax'] * 12, 2)
        annual2 = round(r2['after_tax'] * 12, 2)
        print("  {:<16s} {:<16s} {:<16s}".format("年到手", fmt_money(annual1), fmt_money(annual2)))
        diff = annual1 - annual2
        if diff > 0:
            print("  💡 Offer A 每年多到手 {} 元".format(fmt_money(diff)))
        elif diff < 0:
            print("  💡 Offer B 每年多到手 {} 元".format(fmt_money(abs(diff))))
        else:
            print("  💡 两个Offer到手收入一样")
        print("")

def show_help():
    print("=" * 50)
    print("  中国个人所得税计算器 (2024年税率)")
    print("=" * 50)
    print("")
    print("用法:")
    print("  tax.sh monthly <月薪> <五险一金>    月薪个税")
    print("  tax.sh bonus <年终奖>               年终奖个税")
    print("  tax.sh freelance <收入>              劳务报酬个税")
    print("  tax.sh annual <年收入> <专项扣除>    年度汇算（含退补税）")
    print("  tax.sh optimize <月薪>               合理避税建议")
    print("  tax.sh compare <月薪1> <月薪2>       两个Offer税后对比")
    print("  tax.sh help                          显示帮助")
    print("")
    print("示例:")
    print("  tax.sh monthly 15000 2000")
    print("  tax.sh bonus 50000")
    print("  tax.sh freelance 8000")
    print("  tax.sh annual 300000 60000")
    print("  tax.sh optimize 20000")
    print("  tax.sh compare 15000 18000")

def fmt_money(v):
    return "{:,.2f}".format(v)

def main():
    args = sys.argv[1:]
    if len(args) == 0:
        show_help()
        return

    cmd = args[0]

    if cmd == 'help':
        show_help()

    elif cmd == 'monthly':
        if len(args) < 3:
            print("用法: tax.sh monthly <月薪> <五险一金>")
            sys.exit(1)
        salary = float(args[1])
        social = float(args[2])
        r = calc_monthly_tax(salary, social)
        print("")
        print("📋 月薪个税计算")
        print("─" * 35)
        print("  税前月薪:     {}".format(fmt_money(r['salary'])))
        print("  五险一金:    -{}".format(fmt_money(r['social_insurance'])))
        print("  起征点:      -{}".format(fmt_money(r['exempt'])))
        print("  应纳税所得:   {}".format(fmt_money(r['taxable'])))
        print("─" * 35)
        print("  💰 应缴个税:  {}".format(fmt_money(r['tax'])))
        print("  💵 税后到手:  {}".format(fmt_money(r['after_tax'])))
        print("")

    elif cmd == 'bonus':
        if len(args) < 2:
            print("用法: tax.sh bonus <年终奖>")
            sys.exit(1)
        bonus = float(args[1])
        r = calc_bonus_tax(bonus)
        print("")
        print("🎁 年终奖个税计算（单独计税）")
        print("─" * 35)
        print("  年终奖金额:   {}".format(fmt_money(r['bonus'])))
        print("  月均(÷12):    {}".format(fmt_money(r['monthly_avg'])))
        print("─" * 35)
        print("  💰 应缴个税:  {}".format(fmt_money(r['tax'])))
        print("  💵 税后到手:  {}".format(fmt_money(r['after_tax'])))
        print("  📊 实际税率:  {}%".format(r['effective_rate']))
        print("")

    elif cmd == 'freelance':
        if len(args) < 2:
            print("用法: tax.sh freelance <收入>")
            sys.exit(1)
        income = float(args[1])
        r = calc_freelance_tax(income)
        print("")
        print("📝 劳务报酬个税计算（预扣预缴）")
        print("─" * 35)
        print("  劳务收入:     {}".format(fmt_money(r['income'])))
        print("  应纳税所得:   {}".format(fmt_money(r['taxable'])))
        print("─" * 35)
        print("  💰 预扣个税:  {}".format(fmt_money(r['tax'])))
        print("  💵 实际到手:  {}".format(fmt_money(r['after_tax'])))
        print("  📊 实际税率:  {}%".format(r['effective_rate']))
        print("")

    elif cmd == 'annual':
        if len(args) < 3:
            print("用法: tax.sh annual <年收入> <专项扣除>")
            sys.exit(1)
        income = float(args[1])
        deductions = float(args[2])
        r = calc_annual_settlement(income, deductions)
        print("")
        print("📊 年度综合所得汇算清缴")
        print("─" * 40)
        print("  年度总收入:   {}".format(fmt_money(r['annual_income'])))
        print("  专项扣除:    -{}".format(fmt_money(r['special_deductions'])))
        print("  免征额:      -{}".format(fmt_money(r['annual_exempt'])))
        print("  应纳税所得:   {}".format(fmt_money(r['taxable'])))
        print("─" * 40)
        print("  💰 全年应缴:  {}".format(fmt_money(r['tax'])))
        print("  💳 已预缴:    {}".format(fmt_money(r['prepaid_tax'])))
        if r['refund'] > 0:
            print("  🎉 应退税:    {} 元 ← 记得去退！".format(fmt_money(r['refund'])))
        elif r['refund'] < 0:
            print("  ⚠️ 应补税:    {} 元".format(fmt_money(abs(r['refund']))))
        else:
            print("  ✅ 无需退补")
        print("  💵 月均税额:  {}".format(fmt_money(r['monthly_avg_tax'])))
        print("  💵 税后收入:  {}".format(fmt_money(r['after_tax'])))
        print("  📊 实际税率:  {}%".format(r['effective_rate']))
        print("")

    elif cmd == 'optimize':
        if len(args) < 2:
            print("用法: tax.sh optimize <月薪>")
            sys.exit(1)
        optimize_tax(float(args[1]))

    elif cmd == 'compare':
        if len(args) < 3:
            print("用法: tax.sh compare <月薪1> <月薪2>")
            sys.exit(1)
        compare_offers(args[1], args[2])

    else:
        print("未知命令: {}".format(cmd))
        print("运行 'tax.sh help' 查看帮助")
        sys.exit(1)

if __name__ == '__main__':
    main()
PYTHON_SCRIPT

echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
