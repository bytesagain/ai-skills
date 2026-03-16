#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

CMD="${1:-help}"

python3 - "$@" << 'PYTHON_SCRIPT'
import sys
import os
import json
import datetime

DATA_DIR = os.path.expanduser("~/.bookkeeping")
RECORDS_FILE = os.path.join(DATA_DIR, "records.json")
BUDGETS_FILE = os.path.join(DATA_DIR, "budgets.json")

def ensure_data_dir():
    if not os.path.exists(DATA_DIR):
        os.makedirs(DATA_DIR)

def load_records():
    ensure_data_dir()
    if os.path.exists(RECORDS_FILE):
        with open(RECORDS_FILE, 'r') as f:
            return json.load(f)
    return []

def save_records(records):
    ensure_data_dir()
    with open(RECORDS_FILE, 'w') as f:
        json.dump(records, f, ensure_ascii=False, indent=2)

def load_budgets():
    ensure_data_dir()
    if os.path.exists(BUDGETS_FILE):
        with open(BUDGETS_FILE, 'r') as f:
            return json.load(f)
    return {}

def save_budgets(budgets):
    ensure_data_dir()
    with open(BUDGETS_FILE, 'w') as f:
        json.dump(budgets, f, ensure_ascii=False, indent=2)

def fmt_money(v):
    return "{:,.2f}".format(v)

def get_current_month():
    return datetime.date.today().strftime("%Y-%m")

def add_record(amount, category, note, record_type):
    records = load_records()
    now = datetime.datetime.now()
    record = {
        'id': len(records) + 1,
        'date': now.strftime("%Y-%m-%d"),
        'time': now.strftime("%H:%M:%S"),
        'type': record_type,
        'amount': round(float(amount), 2),
        'category': category,
        'note': note,
    }
    records.append(record)
    save_records(records)
    emoji = "💰" if record_type == "income" else "💸"
    type_label = "收入" if record_type == "income" else "支出"
    print("")
    print("{} 记账成功！".format(emoji))
    print("─" * 35)
    print("  类型: {}".format(type_label))
    print("  金额: {} 元".format(fmt_money(record['amount'])))
    print("  类别: {}".format(category))
    print("  备注: {}".format(note))
    print("  日期: {} {}".format(record['date'], record['time']))
    print("  编号: #{}".format(record['id']))
    print("")

def list_records(month):
    records = load_records()
    filtered = [r for r in records if r['date'].startswith(month)]

    if not filtered:
        print("")
        print("📋 {} 暂无记录".format(month))
        print("")
        return

    print("")
    print("📋 {} 收支记录".format(month))
    print("─" * 55)
    print("  {:<4s} {:<12s} {:<6s} {:<10s} {:<8s} {}".format(
        "编号", "日期", "类型", "金额", "类别", "备注"))
    print("  " + "─" * 52)

    total_income = 0
    total_expense = 0
    for r in filtered:
        type_label = "收入" if r['type'] == 'income' else "支出"
        emoji = "+" if r['type'] == 'income' else "-"
        print("  {:<4s} {:<12s} {:<6s} {}{:<9s} {:<8s} {}".format(
            "#{}".format(r['id']),
            r['date'],
            type_label,
            emoji,
            fmt_money(r['amount']),
            r['category'],
            r.get('note', '')
        ))
        if r['type'] == 'income':
            total_income += r['amount']
        else:
            total_expense += r['amount']

    print("  " + "─" * 52)
    print("  共 {} 条记录 | 收入: {} | 支出: {} | 结余: {}".format(
        len(filtered),
        fmt_money(total_income),
        fmt_money(total_expense),
        fmt_money(total_income - total_expense)
    ))
    print("")

def report(month):
    records = load_records()
    budgets = load_budgets()
    filtered = [r for r in records if r['date'].startswith(month)]

    if not filtered:
        print("")
        print("📊 {} 暂无记录，无法生成报表".format(month))
        print("")
        return

    total_income = 0
    total_expense = 0
    income_by_cat = {}
    expense_by_cat = {}

    for r in filtered:
        if r['type'] == 'income':
            total_income += r['amount']
            cat = r['category']
            income_by_cat[cat] = income_by_cat.get(cat, 0) + r['amount']
        else:
            total_expense += r['amount']
            cat = r['category']
            expense_by_cat[cat] = expense_by_cat.get(cat, 0) + r['amount']

    balance = total_income - total_expense

    print("")
    print("📊 {} 月度收支报表".format(month))
    print("=" * 45)
    print("")
    print("  💰 总收入:  {} 元".format(fmt_money(total_income)))
    print("  💸 总支出:  {} 元".format(fmt_money(total_expense)))
    emoji = "📈" if balance >= 0 else "📉"
    print("  {} 结余:    {} 元".format(emoji, fmt_money(balance)))
    if total_income > 0:
        save_rate = (balance / total_income) * 100
        print("  💹 储蓄率:  {:.1f}%".format(save_rate))
    print("")

    if income_by_cat:
        print("  📥 收入明细:")
        sorted_income = sorted(income_by_cat.items(), key=lambda x: x[1], reverse=True)
        for cat, amount in sorted_income:
            pct = amount / total_income * 100 if total_income > 0 else 0
            bar_len = int(pct / 5)
            bar = "█" * bar_len
            print("     {:<8s} {:>10s}  ({:>5.1f}%) {}".format(cat, fmt_money(amount), pct, bar))
        print("")

    if expense_by_cat:
        print("  📤 支出明细:")
        sorted_expense = sorted(expense_by_cat.items(), key=lambda x: x[1], reverse=True)
        for cat, amount in sorted_expense:
            pct = amount / total_expense * 100 if total_expense > 0 else 0
            bar_len = int(pct / 5)
            bar = "█" * bar_len
            budget_info = ""
            if cat in budgets:
                budget_val = budgets[cat]
                if amount > budget_val:
                    budget_info = " ⚠️ 超预算 {}".format(fmt_money(amount - budget_val))
                else:
                    budget_info = " ✅ 预算内 (剩{})".format(fmt_money(budget_val - amount))
            print("     {:<8s} {:>10s}  ({:>5.1f}%) {}{}".format(
                cat, fmt_money(amount), pct, bar, budget_info))
        print("")

    # 日均统计
    days_in_month = set(r['date'] for r in filtered)
    num_days = len(days_in_month)
    if num_days > 0:
        print("  📅 统计:")
        print("     记录天数: {} 天".format(num_days))
        print("     日均支出: {} 元".format(fmt_money(total_expense / num_days)))
        if total_income > 0:
            print("     日均收入: {} 元".format(fmt_money(total_income / num_days)))
    print("")

def set_budget(category, amount):
    budgets = load_budgets()
    budgets[category] = round(float(amount), 2)
    save_budgets(budgets)
    print("")
    print("✅ 预算设置成功！")
    print("─" * 35)
    print("  类别: {}".format(category))
    print("  月预算: {} 元".format(fmt_money(float(amount))))
    print("")

    # 显示当月该类别已花费
    month = get_current_month()
    records = load_records()
    spent = sum(r['amount'] for r in records
                if r['date'].startswith(month) and r['category'] == category and r['type'] == 'expense')
    if spent > 0:
        remaining = float(amount) - spent
        print("  📊 本月已花费: {} 元".format(fmt_money(spent)))
        if remaining >= 0:
            print("  💰 预算剩余:   {} 元".format(fmt_money(remaining)))
        else:
            print("  ⚠️ 已超预算:   {} 元".format(fmt_money(abs(remaining))))
        print("")

def load_goals():
    ensure_data_dir()
    goals_file = os.path.join(DATA_DIR, "goals.json")
    if os.path.exists(goals_file):
        with open(goals_file, 'r') as f:
            return json.load(f)
    return []

def save_goals(goals):
    ensure_data_dir()
    goals_file = os.path.join(DATA_DIR, "goals.json")
    with open(goals_file, 'w') as f:
        json.dump(goals, f, ensure_ascii=False, indent=2)

def get_prev_month(month_str):
    """获取上一个月 YYYY-MM"""
    parts = month_str.split('-')
    y = int(parts[0])
    m = int(parts[1])
    m -= 1
    if m == 0:
        m = 12
        y -= 1
    return "{}-{:02d}".format(y, m)

def get_same_month_last_year(month_str):
    """获取去年同月 YYYY-MM"""
    parts = month_str.split('-')
    y = int(parts[0]) - 1
    m = int(parts[1])
    return "{}-{:02d}".format(y, m)

def enhanced_report(month):
    """增强版月度报表：含同比环比"""
    records = load_records()
    budgets = load_budgets()
    filtered = [r for r in records if r['date'].startswith(month)]

    if not filtered:
        print("")
        print("📊 {} 暂无记录，无法生成报表".format(month))
        print("")
        return

    total_income = 0
    total_expense = 0
    income_by_cat = {}
    expense_by_cat = {}

    for r in filtered:
        if r['type'] == 'income':
            total_income += r['amount']
            cat = r['category']
            income_by_cat[cat] = income_by_cat.get(cat, 0) + r['amount']
        else:
            total_expense += r['amount']
            cat = r['category']
            expense_by_cat[cat] = expense_by_cat.get(cat, 0) + r['amount']

    balance = total_income - total_expense

    print("")
    print("📊 {} 月度收支报表".format(month))
    print("=" * 50)
    print("")
    print("  💰 总收入:  {} 元".format(fmt_money(total_income)))
    print("  💸 总支出:  {} 元".format(fmt_money(total_expense)))
    emoji = "📈" if balance >= 0 else "📉"
    print("  {} 结余:    {} 元".format(emoji, fmt_money(balance)))
    if total_income > 0:
        save_rate = (balance / total_income) * 100
        print("  💹 储蓄率:  {:.1f}%".format(save_rate))
    print("")

    # === 同比环比分析 ===
    prev_month = get_prev_month(month)
    yoy_month = get_same_month_last_year(month)
    prev_records = [r for r in records if r['date'].startswith(prev_month)]
    yoy_records = [r for r in records if r['date'].startswith(yoy_month)]

    prev_expense = sum(r['amount'] for r in prev_records if r['type'] == 'expense')
    prev_income = sum(r['amount'] for r in prev_records if r['type'] == 'income')
    yoy_expense = sum(r['amount'] for r in yoy_records if r['type'] == 'expense')
    yoy_income = sum(r['amount'] for r in yoy_records if r['type'] == 'income')

    has_comparison = prev_expense > 0 or yoy_expense > 0
    if has_comparison:
        print("  📊 同比环比分析:")
        if prev_expense > 0:
            mom_pct = (total_expense - prev_expense) / prev_expense * 100
            arrow = "↑" if mom_pct > 0 else "↓"
            print("     环比(vs {}): 支出{} {:.1f}%".format(prev_month, arrow, abs(mom_pct)))
        if prev_income > 0:
            mom_inc_pct = (total_income - prev_income) / prev_income * 100
            arrow = "↑" if mom_inc_pct > 0 else "↓"
            print("     环比(vs {}): 收入{} {:.1f}%".format(prev_month, arrow, abs(mom_inc_pct)))
        if yoy_expense > 0:
            yoy_pct = (total_expense - yoy_expense) / yoy_expense * 100
            arrow = "↑" if yoy_pct > 0 else "↓"
            print("     同比(vs {}): 支出{} {:.1f}%".format(yoy_month, arrow, abs(yoy_pct)))
        if yoy_income > 0:
            yoy_inc_pct = (total_income - yoy_income) / yoy_income * 100
            arrow = "↑" if yoy_inc_pct > 0 else "↓"
            print("     同比(vs {}): 收入{} {:.1f}%".format(yoy_month, arrow, abs(yoy_inc_pct)))
        print("")

    if income_by_cat:
        print("  📥 收入明细:")
        sorted_income = sorted(income_by_cat.items(), key=lambda x: x[1], reverse=True)
        for cat, amount in sorted_income:
            pct = amount / total_income * 100 if total_income > 0 else 0
            bar_len = int(pct / 5)
            bar = "█" * bar_len
            print("     {:<8s} {:>10s}  ({:>5.1f}%) {}".format(cat, fmt_money(amount), pct, bar))
        print("")

    if expense_by_cat:
        print("  📤 支出明细:")
        sorted_expense = sorted(expense_by_cat.items(), key=lambda x: x[1], reverse=True)
        for cat, amount in sorted_expense:
            pct = amount / total_expense * 100 if total_expense > 0 else 0
            bar_len = int(pct / 5)
            bar = "█" * bar_len
            budget_info = ""
            if cat in budgets:
                budget_val = budgets[cat]
                if amount > budget_val:
                    budget_info = " ⚠️ 超预算 {}".format(fmt_money(amount - budget_val))
                else:
                    budget_info = " ✅ 预算内 (剩{})".format(fmt_money(budget_val - amount))
            print("     {:<8s} {:>10s}  ({:>5.1f}%) {}{}".format(
                cat, fmt_money(amount), pct, bar, budget_info))
        print("")

    # === 支出TOP3 + 省钱建议 ===
    if expense_by_cat:
        sorted_exp = sorted(expense_by_cat.items(), key=lambda x: x[1], reverse=True)
        print("  🔥 支出TOP3:")
        for i, (cat, amount) in enumerate(sorted_exp[:3], 1):
            pct = amount / total_expense * 100
            print("     {}. {} — {} 元 ({:.1f}%)".format(i, cat, fmt_money(amount), pct))
        print("")

    # 日均统计
    days_in_month = set(r['date'] for r in filtered)
    num_days = len(days_in_month)
    if num_days > 0:
        print("  📅 统计:")
        print("     记录天数: {} 天".format(num_days))
        print("     日均支出: {} 元".format(fmt_money(total_expense / num_days)))
        if total_income > 0:
            print("     日均收入: {} 元".format(fmt_money(total_income / num_days)))
    print("")

def set_goal(name, target_amount, months):
    """设置存钱目标"""
    goals = load_goals()
    target = round(float(target_amount), 2)
    num_months = int(months)
    monthly_need = round(target / num_months, 2)
    now = datetime.datetime.now()

    goal = {
        'name': name,
        'target': target,
        'months': num_months,
        'monthly_need': monthly_need,
        'created': now.strftime("%Y-%m-%d"),
        'saved': 0,
    }

    # 更新已有目标或新增
    updated = False
    for i, g in enumerate(goals):
        if g['name'] == name:
            goals[i] = goal
            updated = True
            break
    if not updated:
        goals.append(goal)
    save_goals(goals)

    print("")
    print("🎯 存钱目标设置成功！")
    print("─" * 40)
    print("  目标名称:   {}".format(name))
    print("  目标金额:   {} 元".format(fmt_money(target)))
    print("  计划周期:   {} 个月".format(num_months))
    print("  每月需存:   {} 元".format(fmt_money(monthly_need)))
    print("")
    print("  💡 每天约需存 {} 元".format(fmt_money(monthly_need / 30)))
    print("")

def show_goals():
    """查看所有存钱目标进度"""
    goals = load_goals()
    if not goals:
        print("")
        print("🎯 暂无存钱目标")
        print("   用 book.sh goal <目标名> <金额> <月数> 创建")
        print("")
        return

    records = load_records()
    # 计算实际结余作为"已存"参考
    print("")
    print("🎯 存钱目标追踪")
    print("=" * 50)
    for g in goals:
        created = g.get('created', '2026-01-01')
        saved = g.get('saved', 0)
        target = g['target']
        pct = (saved / target * 100) if target > 0 else 0
        bar_total = 20
        bar_filled = int(pct / 100 * bar_total)
        bar = "█" * bar_filled + "░" * (bar_total - bar_filled)
        remaining = max(target - saved, 0)
        months_left = g.get('months', 12)

        print("")
        print("  📌 {}".format(g['name']))
        print("     目标: {} 元 | 周期: {} 个月".format(fmt_money(target), g['months']))
        print("     已存: {} 元 | 剩余: {} 元".format(fmt_money(saved), fmt_money(remaining)))
        print("     进度: [{}] {:.1f}%".format(bar, pct))
        print("     每月需存: {} 元".format(fmt_money(g.get('monthly_need', target / max(months_left, 1)))))
        if saved >= target:
            print("     🎉 目标已达成！恭喜！")
    print("")

def save_to_goal(name, amount):
    """往目标里存钱"""
    goals = load_goals()
    found = False
    for g in goals:
        if g['name'] == name:
            g['saved'] = g.get('saved', 0) + round(float(amount), 2)
            found = True
            target = g['target']
            saved = g['saved']
            pct = (saved / target * 100) if target > 0 else 0
            save_goals(goals)
            print("")
            print("💰 存入成功！")
            print("─" * 35)
            print("  目标: {}".format(name))
            print("  本次存入: {} 元".format(fmt_money(float(amount))))
            print("  累计已存: {} 元".format(fmt_money(saved)))
            print("  目标进度: {:.1f}%".format(pct))
            if saved >= target:
                print("  🎉 恭喜！目标已达成！")
            else:
                print("  剩余: {} 元".format(fmt_money(target - saved)))
            print("")
            break
    if not found:
        print("")
        print("⚠️ 未找到目标: {}".format(name))
        print("   用 book.sh goal <目标名> <金额> <月数> 创建")
        print("")

def show_help():
    print("=" * 50)
    print("  记账管家")
    print("=" * 50)
    print("")
    print("用法:")
    print('  book.sh add <金额> <类别> <备注> [--type income|expense]')
    print("      记一笔账（默认为支出）")
    print("  book.sh list [--month YYYY-MM]")
    print("      查看记录（默认当月）")
    print("  book.sh report [--month YYYY-MM]")
    print("      月度收支报表（含同比环比+分类饼图）")
    print("  book.sh budget <类别> <月预算>")
    print("      设置类别月预算")
    print("  book.sh goal <目标名> <金额> <月数>")
    print("      设置存钱目标")
    print("  book.sh goal-save <目标名> <金额>")
    print("      往目标里存钱")
    print("  book.sh goals")
    print("      查看所有存钱目标进度")
    print("  book.sh help")
    print("      显示帮助")
    print("")
    print("示例:")
    print('  book.sh add 35.5 餐饮 "午餐外卖"')
    print('  book.sh add 15000 工资 "3月工资" --type income')
    print("  book.sh list")
    print("  book.sh list --month 2026-02")
    print("  book.sh report")
    print("  book.sh budget 餐饮 2000")
    print('  book.sh goal "买相机" 8000 6')
    print('  book.sh goal-save "买相机" 1500')
    print("  book.sh goals")
    print("")
    print("数据存储: ~/.bookkeeping/")

def main():
    args = sys.argv[1:]
    if len(args) == 0:
        show_help()
        return

    cmd = args[0]

    if cmd == 'help':
        show_help()

    elif cmd == 'add':
        if len(args) < 4:
            print("用法: book.sh add <金额> <类别> <备注> [--type income|expense]")
            sys.exit(1)
        amount = args[1]
        category = args[2]
        note = args[3]
        record_type = "expense"
        if '--type' in args:
            idx = args.index('--type')
            if idx + 1 < len(args):
                record_type = args[idx + 1]
                if record_type not in ('income', 'expense'):
                    print("类型必须是 income 或 expense")
                    sys.exit(1)
        add_record(amount, category, note, record_type)

    elif cmd == 'list':
        month = get_current_month()
        if '--month' in args:
            idx = args.index('--month')
            if idx + 1 < len(args):
                month = args[idx + 1]
        list_records(month)

    elif cmd == 'report':
        month = get_current_month()
        if '--month' in args:
            idx = args.index('--month')
            if idx + 1 < len(args):
                month = args[idx + 1]
        enhanced_report(month)

    elif cmd == 'budget':
        if len(args) < 3:
            print("用法: book.sh budget <类别> <月预算>")
            sys.exit(1)
        set_budget(args[1], args[2])

    elif cmd == 'goal':
        if len(args) < 4:
            print("用法: book.sh goal <目标名> <金额> <月数>")
            sys.exit(1)
        set_goal(args[1], args[2], args[3])

    elif cmd == 'goal-save':
        if len(args) < 3:
            print("用法: book.sh goal-save <目标名> <金额>")
            sys.exit(1)
        save_to_goal(args[1], args[2])

    elif cmd == 'goals':
        show_goals()

    else:
        print("未知命令: {}".format(cmd))
        print("运行 'book.sh help' 查看帮助")
        sys.exit(1)

if __name__ == '__main__':
    main()
PYTHON_SCRIPT

echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
