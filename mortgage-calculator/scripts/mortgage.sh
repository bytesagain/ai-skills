#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

CMD="${1:-help}"

python3 - "$@" << 'PYTHON_SCRIPT'
import sys
import math

def fmt_money(v):
    return "{:,.2f}".format(v)

def equal_payment(total_wan, years, annual_rate_pct):
    """等额本息"""
    principal = total_wan * 10000.0
    months = years * 12
    monthly_rate = annual_rate_pct / 100.0 / 12.0

    if monthly_rate == 0:
        monthly_payment = principal / months
    else:
        monthly_payment = principal * monthly_rate * math.pow(1 + monthly_rate, months) / (math.pow(1 + monthly_rate, months) - 1)

    total_payment = monthly_payment * months
    total_interest = total_payment - principal

    return {
        'principal': principal,
        'months': months,
        'monthly_rate': monthly_rate,
        'monthly_payment': round(monthly_payment, 2),
        'total_payment': round(total_payment, 2),
        'total_interest': round(total_interest, 2),
    }

def equal_principal(total_wan, years, annual_rate_pct):
    """等额本金"""
    principal = total_wan * 10000.0
    months = years * 12
    monthly_rate = annual_rate_pct / 100.0 / 12.0
    monthly_principal = principal / months

    first_month_payment = monthly_principal + principal * monthly_rate
    last_month_payment = monthly_principal + monthly_principal * monthly_rate
    monthly_decrease = monthly_principal * monthly_rate

    total_interest = 0.0
    for i in range(months):
        remaining = principal - monthly_principal * i
        interest = remaining * monthly_rate
        total_interest += interest

    total_payment = principal + total_interest

    return {
        'principal': principal,
        'months': months,
        'monthly_principal': round(monthly_principal, 2),
        'first_month': round(first_month_payment, 2),
        'last_month': round(last_month_payment, 2),
        'monthly_decrease': round(monthly_decrease, 2),
        'total_payment': round(total_payment, 2),
        'total_interest': round(total_interest, 2),
    }

def calc_prepay(remaining_wan, paid_months, prepay_wan):
    """提前还款计算（简化：假设等额本息，利率3.5%）"""
    remaining = remaining_wan * 10000.0
    prepay_amount = prepay_wan * 10000.0
    # 假设常见利率3.5%
    annual_rate = 0.035
    monthly_rate = annual_rate / 12.0
    # 假设原始贷款30年
    original_months = 360
    remaining_months = original_months - paid_months

    if prepay_amount >= remaining:
        print("")
        print("🎉 提前还款金额已覆盖全部剩余本金！")
        print("  剩余本金: {} 元".format(fmt_money(remaining)))
        print("  可一次性还清，节省后续全部利息")
        return None

    new_remaining = remaining - prepay_amount

    # 不提前还款的总利息
    if monthly_rate > 0 and remaining_months > 0:
        old_monthly = remaining * monthly_rate * math.pow(1 + monthly_rate, remaining_months) / (math.pow(1 + monthly_rate, remaining_months) - 1)
        old_total = old_monthly * remaining_months
        old_interest = old_total - remaining
    else:
        old_interest = 0

    # 提前还款后（保持月供不变，缩短年限）
    if monthly_rate > 0 and new_remaining > 0:
        new_monthly = old_monthly  # 保持月供
        # 计算新的还款月数
        if new_monthly <= new_remaining * monthly_rate:
            new_months = remaining_months
        else:
            new_months = math.ceil(-math.log(1 - new_remaining * monthly_rate / new_monthly) / math.log(1 + monthly_rate))
        new_total = new_monthly * new_months
        new_interest = new_total - new_remaining
    else:
        new_months = 0
        new_interest = 0

    saved_interest = old_interest - new_interest - prepay_amount * 0  # 提前还的本金不算利息
    saved_months = remaining_months - new_months

    return {
        'remaining': remaining,
        'prepay': prepay_amount,
        'new_remaining': new_remaining,
        'old_interest': round(old_interest, 2),
        'new_interest': round(max(new_interest, 0), 2),
        'saved_interest': round(max(saved_interest, 0), 2),
        'old_months': remaining_months,
        'new_months': new_months,
        'saved_months': max(saved_months, 0),
        'monthly_payment': round(old_monthly, 2),
    }

def calc_afford(monthly_income, monthly_expense):
    """我能贷多少（月供不超过收入-支出的50%）"""
    disposable = monthly_income - monthly_expense
    max_payment = disposable * 0.5  # 建议月供不超50%可支配
    safe_payment = disposable * 0.3  # 安全线30%

    # 常见利率和年限组合
    scenarios = [
        (3.0, 30, "公积金30年"),
        (3.0, 20, "公积金20年"),
        (3.5, 30, "商贷30年(3.5%)"),
        (3.5, 20, "商贷20年(3.5%)"),
        (4.0, 30, "商贷30年(4.0%)"),
    ]

    print("")
    print("🏠 贷款能力评估")
    print("=" * 55)
    print("")
    print("  月收入:       {} 元".format(fmt_money(monthly_income)))
    print("  月支出:       {} 元".format(fmt_money(monthly_expense)))
    print("  可支配收入:   {} 元".format(fmt_money(disposable)))
    print("  建议月供上限: {} 元 (可支配的50%)".format(fmt_money(max_payment)))
    print("  安全月供线:   {} 元 (可支配的30%)".format(fmt_money(safe_payment)))
    print("")
    print("  📊 不同方案可贷金额:")
    print("  ─" * 22)
    print("  {:<18s} {:<14s} {:<14s}".format("方案", "可贷(50%)", "安全(30%)"))
    print("  " + "─" * 44)
    for rate, years, label in scenarios:
        months = years * 12
        monthly_rate = rate / 100.0 / 12.0
        if monthly_rate > 0:
            # 反算贷款额: P = PMT * ((1+r)^n - 1) / (r * (1+r)^n)
            factor = (math.pow(1 + monthly_rate, months) - 1) / (monthly_rate * math.pow(1 + monthly_rate, months))
            max_loan = max_payment * factor
            safe_loan = safe_payment * factor
        else:
            max_loan = max_payment * months
            safe_loan = safe_payment * months
        print("  {:<18s} {:<14s} {:<14s}".format(
            label,
            "{:.0f}万".format(max_loan / 10000),
            "{:.0f}万".format(safe_loan / 10000)))
    print("")
    print("  💡 建议:")
    print("     • 月供占可支配收入30%以内最安全")
    print("     • 别忘留3-6个月月供作为应急资金")
    print("     • 首付越多，月供越轻松")
    if max_payment < 2000:
        print("     • ⚠️ 当前可支配收入偏低，建议增加首付比例")
    print("")

def show_help():
    print("=" * 50)
    print("  房贷计算器")
    print("=" * 50)
    print("")
    print("用法:")
    print("  mortgage.sh equal-payment <总额万> <年限> <利率%>")
    print("      等额本息计算")
    print("  mortgage.sh equal-principal <总额万> <年限> <利率%>")
    print("      等额本金计算")
    print("  mortgage.sh prepay <剩余本金万> <已还月数> <提前还款万>")
    print("      提前还款计算（默认利率3.5%，30年期）")
    print("  mortgage.sh compare <总额万> <年限> <利率%>")
    print("      两种还款方式对比")
    print("  mortgage.sh afford <月收入> <月支出>")
    print("      我能贷多少？（反算贷款能力）")
    print("  mortgage.sh help")
    print("      显示帮助")
    print("")
    print("示例:")
    print("  mortgage.sh equal-payment 100 30 3.5")
    print("  mortgage.sh equal-principal 80 20 3.5")
    print("  mortgage.sh prepay 60 60 20")
    print("  mortgage.sh compare 100 30 3.5")
    print("  mortgage.sh afford 20000 5000")

def main():
    args = sys.argv[1:]
    if len(args) == 0:
        show_help()
        return

    cmd = args[0]

    if cmd == 'help':
        show_help()

    elif cmd == 'equal-payment':
        if len(args) < 4:
            print("用法: mortgage.sh equal-payment <总额万> <年限> <利率%>")
            sys.exit(1)
        total = float(args[1])
        years = int(args[2])
        rate = float(args[3])
        r = equal_payment(total, years, rate)
        print("")
        print("🏠 等额本息还款计算")
        print("─" * 40)
        print("  贷款总额:     {} 万元".format(fmt_money(total)))
        print("  贷款年限:     {} 年（{} 期）".format(years, r['months']))
        print("  年利率:       {}%".format(rate))
        print("─" * 40)
        print("  📅 每月月供:  {} 元".format(fmt_money(r['monthly_payment'])))
        print("  💰 还款总额:  {} 元".format(fmt_money(r['total_payment'])))
        print("  💸 总利息:    {} 元".format(fmt_money(r['total_interest'])))
        print("  📊 利息占比:  {:.1f}%".format(r['total_interest'] / r['total_payment'] * 100))
        print("")

    elif cmd == 'equal-principal':
        if len(args) < 4:
            print("用法: mortgage.sh equal-principal <总额万> <年限> <利率%>")
            sys.exit(1)
        total = float(args[1])
        years = int(args[2])
        rate = float(args[3])
        r = equal_principal(total, years, rate)
        print("")
        print("🏠 等额本金还款计算")
        print("─" * 40)
        print("  贷款总额:     {} 万元".format(fmt_money(total)))
        print("  贷款年限:     {} 年（{} 期）".format(years, r['months']))
        print("  年利率:       {}%".format(rate))
        print("─" * 40)
        print("  📅 首月月供:  {} 元".format(fmt_money(r['first_month'])))
        print("  📅 末月月供:  {} 元".format(fmt_money(r['last_month'])))
        print("  📉 每月递减:  {} 元".format(fmt_money(r['monthly_decrease'])))
        print("  💰 还款总额:  {} 元".format(fmt_money(r['total_payment'])))
        print("  💸 总利息:    {} 元".format(fmt_money(r['total_interest'])))
        print("  📊 利息占比:  {:.1f}%".format(r['total_interest'] / r['total_payment'] * 100))
        print("")

    elif cmd == 'prepay':
        if len(args) < 4:
            print("用法: mortgage.sh prepay <剩余本金万> <已还月数> <提前还款万>")
            sys.exit(1)
        remaining = float(args[1])
        paid_months = int(args[2])
        prepay = float(args[3])
        r = calc_prepay(remaining, paid_months, prepay)
        if r is not None:
            print("")
            print("💰 提前还款分析（缩短年限方案）")
            print("─" * 40)
            print("  剩余本金:     {} 元".format(fmt_money(r['remaining'])))
            print("  提前还款:     {} 元".format(fmt_money(r['prepay'])))
            print("  新剩余本金:   {} 元".format(fmt_money(r['new_remaining'])))
            print("─" * 40)
            print("  月供不变:     {} 元".format(fmt_money(r['monthly_payment'])))
            print("  原剩余期数:   {} 个月（{:.1f}年）".format(r['old_months'], r['old_months']/12.0))
            print("  新剩余期数:   {} 个月（{:.1f}年）".format(r['new_months'], r['new_months']/12.0))
            print("  ⏰ 缩短:      {} 个月（{:.1f}年）".format(r['saved_months'], r['saved_months']/12.0))
            print("  💸 节省利息:  {} 元".format(fmt_money(r['saved_interest'])))
            print("")

    elif cmd == 'compare':
        if len(args) < 4:
            print("用法: mortgage.sh compare <总额万> <年限> <利率%>")
            sys.exit(1)
        total = float(args[1])
        years = int(args[2])
        rate = float(args[3])
        ep = equal_payment(total, years, rate)
        epr = equal_principal(total, years, rate)
        diff_interest = ep['total_interest'] - epr['total_interest']
        print("")
        print("🏠 两种还款方式对比")
        print("─" * 50)
        print("  贷款: {} 万 | {} 年 | 利率 {}%".format(total, years, rate))
        print("─" * 50)
        print("  {:<16s} {:<18s} {:<18s}".format("", "等额本息", "等额本金"))
        print("  {:<16s} {:<18s} {:<18s}".format("月供", fmt_money(ep['monthly_payment']), "{} (首月)".format(fmt_money(epr['first_month']))))
        print("  {:<16s} {:<18s} {:<18s}".format("", "", "{} (末月)".format(fmt_money(epr['last_month']))))
        print("  {:<16s} {:<18s} {:<18s}".format("还款总额", fmt_money(ep['total_payment']), fmt_money(epr['total_payment'])))
        print("  {:<16s} {:<18s} {:<18s}".format("总利息", fmt_money(ep['total_interest']), fmt_money(epr['total_interest'])))
        print("─" * 50)
        print("  💡 等额本金比等额本息少付利息: {} 元".format(fmt_money(diff_interest)))
        print("  💡 等额本金前期月供更高，适合收入较高者")
        print("  💡 等额本息月供固定，适合收入稳定者")
        print("")

    elif cmd == 'afford':
        if len(args) < 3:
            print("用法: mortgage.sh afford <月收入> <月支出>")
            sys.exit(1)
        income = float(args[1])
        expense = float(args[2])
        calc_afford(income, expense)

    else:
        print("未知命令: {}".format(cmd))
        print("运行 'mortgage.sh help' 查看帮助")
        sys.exit(1)

if __name__ == '__main__':
    main()
PYTHON_SCRIPT

echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
