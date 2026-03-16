#!/usr/bin/env bash
# employee-survey — 员工满意度调研工具
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"

show_help() {
cat << 'EOF'
📋 员工满意度调研工具

Commands:
  create [--type nps|satisfaction|engagement|exit|onboarding]
         — 生成HTML格式调查问卷
  nps [score1,score2,...]
         — 计算NPS净推荐值
  analyze [promoters] [passives] [detractors]
         — 满意度分析报告
  template
         — 经典问卷模板（10道题）
  benchmark
         — 行业基准数据参考
  help   — 显示此帮助
EOF
}

cmd_nps() {
    local scores="$INPUT"
    if [ -z "$scores" ]; then
        echo "用法: employee-survey nps 9,10,8,7,6,10,9,3,8,10"
        echo "分数范围: 0-10"
        return
    fi

    python3 << PYEOF
scores = [int(x.strip()) for x in "${scores}".split(",") if x.strip().isdigit()]
if not scores:
    print("请输入有效分数，用逗号分隔")
else:
    promoters = len([s for s in scores if s >= 9])
    passives = len([s for s in scores if 7 <= s <= 8])
    detractors = len([s for s in scores if s <= 6])
    total = len(scores)
    nps = round((promoters - detractors) / total * 100)
    avg = round(sum(scores) / total, 1)

    print("=" * 40)
    print("  NPS Net Promoter Score Analysis")
    print("=" * 40)
    print("")
    print("Total responses: {}".format(total))
    print("Average score: {}".format(avg))
    print("")
    print("Promoters (9-10): {} ({:.0f}%)".format(promoters, promoters/total*100))
    print("Passives  (7-8):  {} ({:.0f}%)".format(passives, passives/total*100))
    print("Detractors (0-6): {} ({:.0f}%)".format(detractors, detractors/total*100))
    print("")
    print("NPS Score: {}".format(nps))
    print("")
    if nps >= 70:
        print("Rating: EXCELLENT")
        print("Your organization has world-class employee loyalty.")
    elif nps >= 50:
        print("Rating: GREAT")
        print("Strong employee satisfaction. Keep it up!")
    elif nps >= 0:
        print("Rating: GOOD")
        print("Room for improvement. Focus on detractor feedback.")
    else:
        print("Rating: NEEDS ATTENTION")
        print("Significant dissatisfaction detected. Immediate action needed.")
    print("")
    print("Industry Benchmarks:")
    print("  Tech: 40-60 | Finance: 20-40 | Retail: 10-30")
    print("  Healthcare: 30-50 | Education: 20-40")
PYEOF
}

cmd_create() {
    local qtype="satisfaction"
    for arg in $INPUT; do
        case "$arg" in
            --type) shift ;;
            nps|satisfaction|engagement|exit|onboarding) qtype="$arg" ;;
        esac
    done

    case "$qtype" in
    nps) cat << 'EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>NPS员工推荐度调查</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}body{font-family:-apple-system,sans-serif;background:#f5f5f5;padding:20px}
.survey{max-width:600px;margin:0 auto;background:white;border-radius:12px;padding:32px;box-shadow:0 2px 12px rgba(0,0,0,0.08)}
h1{font-size:24px;margin-bottom:8px;color:#1a1a1a}
.subtitle{color:#666;margin-bottom:24px}
.question{margin-bottom:24px;padding:20px;background:#fafafa;border-radius:8px}
.question label{display:block;font-weight:600;margin-bottom:12px}
.nps-scale{display:flex;gap:8px;flex-wrap:wrap}
.nps-scale input[type=radio]{display:none}
.nps-scale label{width:44px;height:44px;display:flex;align-items:center;justify-content:center;border:2px solid #ddd;border-radius:8px;cursor:pointer;font-weight:600;transition:all 0.2s}
.nps-scale input:checked+label{background:#3b82f6;color:white;border-color:#3b82f6}
textarea{width:100%;padding:12px;border:1px solid #ddd;border-radius:8px;resize:vertical;min-height:80px}
.btn{width:100%;padding:14px;background:#3b82f6;color:white;border:none;border-radius:8px;font-size:16px;font-weight:600;cursor:pointer;margin-top:16px}
.btn:hover{background:#2563eb}
</style></head><body>
<div class="survey">
<h1>NPS 员工推荐度调查</h1>
<p class="subtitle">您的反馈对我们至关重要</p>
<div class="question">
<label>您有多大可能向朋友推荐在本公司工作？(0=完全不可能, 10=非常可能)</label>
<div class="nps-scale" id="nps">
<input type="radio" name="nps" id="n0" value="0"><label for="n0">0</label>
<input type="radio" name="nps" id="n1" value="1"><label for="n1">1</label>
<input type="radio" name="nps" id="n2" value="2"><label for="n2">2</label>
<input type="radio" name="nps" id="n3" value="3"><label for="n3">3</label>
<input type="radio" name="nps" id="n4" value="4"><label for="n4">4</label>
<input type="radio" name="nps" id="n5" value="5"><label for="n5">5</label>
<input type="radio" name="nps" id="n6" value="6"><label for="n6">6</label>
<input type="radio" name="nps" id="n7" value="7"><label for="n7">7</label>
<input type="radio" name="nps" id="n8" value="8"><label for="n8">8</label>
<input type="radio" name="nps" id="n9" value="9"><label for="n9">9</label>
<input type="radio" name="nps" id="n10" value="10"><label for="n10">10</label>
</div></div>
<div class="question"><label>最让您满意的方面是什么？</label><textarea placeholder="请分享..."></textarea></div>
<div class="question"><label>哪些方面需要改进？</label><textarea placeholder="请分享..."></textarea></div>
<button class="btn" type="button">提交反馈</button>
</div></body></html>
EOF
    ;;
    *) cat << 'EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>员工满意度调查</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}body{font-family:-apple-system,sans-serif;background:#f5f5f5;padding:20px}
.survey{max-width:600px;margin:0 auto;background:white;border-radius:12px;padding:32px;box-shadow:0 2px 12px rgba(0,0,0,0.08)}
h1{font-size:24px;margin-bottom:24px}
.q{margin-bottom:20px;padding:16px;background:#fafafa;border-radius:8px}
.q label{display:block;font-weight:600;margin-bottom:8px}
.stars{display:flex;gap:4px}
.stars input{display:none}.stars label{font-size:28px;cursor:pointer;color:#ddd}
.stars input:checked~label,.stars label:hover,.stars label:hover~label{color:#fbbf24}
select,textarea{width:100%;padding:10px;border:1px solid #ddd;border-radius:6px}
.btn{width:100%;padding:14px;background:#10b981;color:white;border:none;border-radius:8px;font-size:16px;font-weight:600;cursor:pointer;margin-top:16px}
</style></head><body>
<div class="survey">
<h1>📋 员工满意度调查</h1>
<div class="q"><label>1. 整体工作满意度</label><select><option>非常满意</option><option>满意</option><option>一般</option><option>不满意</option><option>非常不满意</option></select></div>
<div class="q"><label>2. 工作环境评价</label><select><option>优秀</option><option>良好</option><option>一般</option><option>需改进</option></select></div>
<div class="q"><label>3. 团队协作氛围</label><select><option>非常好</option><option>好</option><option>一般</option><option>差</option></select></div>
<div class="q"><label>4. 职业发展机会</label><select><option>非常充足</option><option>充足</option><option>一般</option><option>不足</option></select></div>
<div class="q"><label>5. 薪酬福利满意度</label><select><option>非常满意</option><option>满意</option><option>一般</option><option>不满意</option></select></div>
<div class="q"><label>6. 直属上级领导力</label><select><option>优秀</option><option>良好</option><option>一般</option><option>需改进</option></select></div>
<div class="q"><label>7. 工作生活平衡</label><select><option>很好</option><option>好</option><option>一般</option><option>差</option></select></div>
<div class="q"><label>8. 公司文化认同</label><select><option>非常认同</option><option>认同</option><option>一般</option><option>不认同</option></select></div>
<div class="q"><label>9. 培训学习机会</label><select><option>非常充足</option><option>充足</option><option>一般</option><option>不足</option></select></div>
<div class="q"><label>10. 其他建议</label><textarea rows="3" placeholder="请分享您的想法..."></textarea></div>
<button class="btn">提交问卷</button>
</div></body></html>
EOF
    ;;
    esac
}

cmd_template() {
cat << 'EOF'
📋 经典员工满意度问卷模板（10题）

使用说明：每题5分制（1=非常不同意, 5=非常同意）

1. 我对目前的工作内容感到满意
   [ ] 1  [ ] 2  [ ] 3  [ ] 4  [ ] 5

2. 我的工作量是合理的
   [ ] 1  [ ] 2  [ ] 3  [ ] 4  [ ] 5

3. 我在工作中能发挥自己的特长
   [ ] 1  [ ] 2  [ ] 3  [ ] 4  [ ] 5

4. 我对团队的协作氛围感到满意
   [ ] 1  [ ] 2  [ ] 3  [ ] 4  [ ] 5

5. 我的直属上级能给予有效的指导和支持
   [ ] 1  [ ] 2  [ ] 3  [ ] 4  [ ] 5

6. 公司提供了足够的职业发展机会
   [ ] 1  [ ] 2  [ ] 3  [ ] 4  [ ] 5

7. 我对目前的薪酬福利感到满意
   [ ] 1  [ ] 2  [ ] 3  [ ] 4  [ ] 5

8. 公司的工作环境（办公设施、工具等）良好
   [ ] 1  [ ] 2  [ ] 3  [ ] 4  [ ] 5

9. 我能很好地平衡工作和生活
   [ ] 1  [ ] 2  [ ] 3  [ ] 4  [ ] 5

10. 我愿意在这家公司长期发展
    [ ] 1  [ ] 2  [ ] 3  [ ] 4  [ ] 5

评分标准：
  总分 45-50: 非常满意 (留存率高)
  总分 35-44: 满意 (基本稳定)
  总分 25-34: 一般 (需关注)
  总分 15-24: 不满意 (离职风险)
  总分 10-14: 非常不满意 (紧急干预)
EOF
}

cmd_benchmark() {
cat << 'EOF'
📊 行业员工满意度基准数据 (2024)

整体满意度:
  科技行业:    72%  ████████████████████░░░░░
  金融行业:    68%  ███████████████████░░░░░░
  医疗行业:    65%  ██████████████████░░░░░░░
  教育行业:    63%  █████████████████░░░░░░░░
  制造业:      58%  ████████████████░░░░░░░░░
  零售业:      52%  ██████████████░░░░░░░░░░░

NPS基准:
  科技:  40~60     优秀: >70
  金融:  20~40     良好: 50~70
  零售:  10~30     一般: 0~50
  医疗:  30~50     需改进: <0

关键指标参考:
  自愿离职率:    科技 13% | 金融 11% | 零售 19%
  员工敬业度:    全球平均 23% (Gallup 2024)
  推荐率:        优秀企业 >80% | 平均 55%
  培训满意度:    行业平均 62%

影响满意度TOP 5因素:
  1. 薪酬公平性 (权重 22%)
  2. 职业发展机会 (权重 20%)
  3. 直属上级关系 (权重 18%)
  4. 工作生活平衡 (权重 15%)
  5. 企业文化/价值观 (权重 12%)
EOF
}

cmd_analyze() {
    local p="${1:-0}" pa="${2:-0}" d="${3:-0}"

    if [ "$p" = "0" ] && [ "$pa" = "0" ] && [ "$d" = "0" ]; then
        echo "用法: employee-survey analyze [promoters] [passives] [detractors]"
        echo "示例: employee-survey analyze 45 30 25"
        return
    fi

    python3 << PYEOF
p, pa, d = int("${p}"), int("${pa}"), int("${d}")
total = p + pa + d
if total == 0:
    print("Error: total responses cannot be 0")
else:
    nps = round((p - d) / total * 100)
    print("=" * 45)
    print("  Employee Satisfaction Analysis Report")
    print("=" * 45)
    print("")
    print("Responses: {}".format(total))
    print("Promoters:  {} ({:.1f}%)".format(p, p/total*100))
    print("Passives:   {} ({:.1f}%)".format(pa, pa/total*100))
    print("Detractors: {} ({:.1f}%)".format(d, d/total*100))
    print("")
    print("NPS: {}".format(nps))
    print("")
    print("Actions:")
    if d/total > 0.3:
        print("  [URGENT] Detractor rate >30%. Exit interviews needed.")
    if pa/total > 0.4:
        print("  [WATCH] High passive rate. Risk of silent attrition.")
    if p/total > 0.6:
        print("  [GOOD] Strong promoter base. Leverage for referrals.")
    print("")
    print("Estimated voluntary turnover risk:")
    risk = round(d / total * 100 * 0.4)
    print("  {}% of detractors likely to leave within 12 months".format(risk))
    print("  Estimated replacement cost: ${:,}/person".format(int(total * d/total * 0.4 * 50000)))
PYEOF
}

case "$CMD" in
    help|--help|-h) show_help ;;
    create) cmd_create ;;
    nps) cmd_nps ;;
    analyze) cmd_analyze $INPUT ;;
    template) cmd_template ;;
    benchmark) cmd_benchmark ;;
    *) echo "❓ 未知命令: $CMD"; show_help; exit 1 ;;
esac
