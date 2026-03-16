#!/usr/bin/env bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  BMI Calculator — 真实计算版
#  使用 bash + bc 实现 BMI 计算、WHO 分类、理想体重范围
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
set -euo pipefail

# ─── 工具函数 ────────────────────────────────────────────────────────────────
err() { echo "❌ 错误: $1" >&2; exit 1; }

check_bc() {
    command -v bc &>/dev/null || err "需要 bc 命令，请安装: sudo apt install bc"
}

# 浮点计算 helper (scale=4)
calc() { echo "scale=4; $1" | bc -l 2>/dev/null; }

# 检查是否为正数
is_positive_number() {
    local val="$1"
    [[ -z "$val" ]] && return 1
    # 匹配正整数或正小数
    [[ "$val" =~ ^[0-9]*\.?[0-9]+$ ]] && (( $(echo "$val > 0" | bc -l) )) && return 0
    return 1
}

# ─── WHO BMI 分类 ────────────────────────────────────────────────────────────
classify_bmi() {
    local bmi="$1"
    local category="" color="" advice=""

    # 使用 bc 进行浮点比较
    if (( $(echo "$bmi < 16.0" | bc -l) )); then
        category="严重偏瘦 (Severely Underweight)"
        color="🔴"
        advice="体重严重不足，建议尽快就医，制定增重计划"
    elif (( $(echo "$bmi < 17.0" | bc -l) )); then
        category="中度偏瘦 (Moderately Underweight)"
        color="🟠"
        advice="体重偏低，建议增加营养摄入，适当增重"
    elif (( $(echo "$bmi < 18.5" | bc -l) )); then
        category="轻度偏瘦 (Mildly Underweight)"
        color="🟡"
        advice="略微偏瘦，注意均衡饮食，适当增加蛋白质摄入"
    elif (( $(echo "$bmi < 25.0" | bc -l) )); then
        category="正常 (Normal)"
        color="🟢"
        advice="体重正常，继续保持健康的生活方式"
    elif (( $(echo "$bmi < 30.0" | bc -l) )); then
        category="超重 (Overweight)"
        color="🟡"
        advice="体重偏高，建议控制饮食，增加运动量"
    elif (( $(echo "$bmi < 35.0" | bc -l) )); then
        category="I级肥胖 (Obese Class I)"
        color="🟠"
        advice="需要减重，建议制定饮食和运动计划，必要时就医"
    elif (( $(echo "$bmi < 40.0" | bc -l) )); then
        category="II级肥胖 (Obese Class II)"
        color="🔴"
        advice="严重超重，强烈建议就医，在医生指导下减重"
    else
        category="III级肥胖 (Obese Class III)"
        color="🔴"
        advice="病态肥胖，请立即就医，可能需要医疗干预"
    fi

    echo "$color|$category|$advice"
}

# 亚洲标准分类 (WHO 西太平洋区域标准)
classify_bmi_asian() {
    local bmi="$1"
    local category=""

    if (( $(echo "$bmi < 18.5" | bc -l) )); then
        category="偏瘦"
    elif (( $(echo "$bmi < 23.0" | bc -l) )); then
        category="正常"
    elif (( $(echo "$bmi < 25.0" | bc -l) )); then
        category="超重"
    elif (( $(echo "$bmi < 30.0" | bc -l) )); then
        category="I级肥胖"
    else
        category="II级肥胖"
    fi
    echo "$category"
}

# ─── 子命令: calculate ──────────────────────────────────────────────────────
cmd_calculate() {
    local height="" weight=""

    # 解析参数
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --height|-h) height="$2"; shift 2 ;;
            --weight|-w) weight="$2"; shift 2 ;;
            *) shift ;;
        esac
    done

    # 校验
    [[ -z "$height" ]] && err "缺少身高参数。用法: calculate --height 175 --weight 70"
    [[ -z "$weight" ]] && err "缺少体重参数。用法: calculate --height 175 --weight 70"
    is_positive_number "$height" || err "身高必须是正数 (单位: cm)"
    is_positive_number "$weight" || err "体重必须是正数 (单位: kg)"

    # 合理范围检查
    if (( $(echo "$height < 50 || $height > 280" | bc -l) )); then
        err "身高范围异常 (合理范围: 50-280 cm)，请检查输入"
    fi
    if (( $(echo "$weight < 2 || $weight > 500" | bc -l) )); then
        err "体重范围异常 (合理范围: 2-500 kg)，请检查输入"
    fi

    check_bc

    # BMI = 体重(kg) / 身高(m)^2
    local height_m
    height_m=$(calc "$height / 100")
    local bmi
    bmi=$(calc "$weight / ($height_m * $height_m)")
    # 保留2位小数
    bmi=$(printf "%.2f" "$bmi")

    # 分类
    local IFS='|'
    local classification
    classification=$(classify_bmi "$bmi")
    read -r color category advice <<< "$classification"
    local asian_cat
    asian_cat=$(classify_bmi_asian "$bmi")

    # 正常体重范围 (BMI 18.5-24.9)
    local normal_min normal_max
    normal_min=$(calc "18.5 * $height_m * $height_m")
    normal_max=$(calc "24.9 * $height_m * $height_m")
    normal_min=$(printf "%.1f" "$normal_min")
    normal_max=$(printf "%.1f" "$normal_max")

    # 输出结果
    cat << RESULT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📊 BMI 计算结果
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📏 身高: ${height} cm (${height_m} m)
  ⚖️  体重: ${weight} kg

  ┌─────────────────────────────────────┐
  │  BMI = ${bmi}                       
  │  ${color} WHO分类: ${category}
  │  🌏 亚洲标准: ${asian_cat}
  └─────────────────────────────────────┘

  📐 计算公式: BMI = ${weight} / ${height_m}² = ${bmi}
  📋 正常体重范围 (BMI 18.5-24.9): ${normal_min} ~ ${normal_max} kg

  💡 建议: ${advice}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
RESULT
}

# ─── 子命令: classify ────────────────────────────────────────────────────────
cmd_classify() {
    cat << 'TABLE'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 WHO BMI 分类标准
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ┌──────────────┬───────────────────────────────┐
  │ BMI 范围     │ 分类                          │
  ├──────────────┼───────────────────────────────┤
  │ < 16.0       │ 🔴 严重偏瘦 (Severely UW)     │
  │ 16.0 - 16.9  │ 🟠 中度偏瘦 (Moderately UW)   │
  │ 17.0 - 18.4  │ 🟡 轻度偏瘦 (Mildly UW)       │
  │ 18.5 - 24.9  │ 🟢 正常 (Normal)              │
  │ 25.0 - 29.9  │ 🟡 超重 (Overweight)           │
  │ 30.0 - 34.9  │ 🟠 I级肥胖 (Obese I)          │
  │ 35.0 - 39.9  │ 🔴 II级肥胖 (Obese II)        │
  │ ≥ 40.0       │ 🔴 III级肥胖 (Obese III)      │
  └──────────────┴───────────────────────────────┘

  🌏 亚洲标准 (WHO 西太平洋区域):
  ┌──────────────┬───────────────────────────────┐
  │ BMI 范围     │ 分类                          │
  ├──────────────┼───────────────────────────────┤
  │ < 18.5       │ 偏瘦                          │
  │ 18.5 - 22.9  │ 正常                          │
  │ 23.0 - 24.9  │ 超重                          │
  │ 25.0 - 29.9  │ I级肥胖                       │
  │ ≥ 30.0       │ II级肥胖                      │
  └──────────────┴───────────────────────────────┘

  ⚠️  注意: 亚洲人群的健康风险阈值低于国际标准。
      BMI 仅为参考指标，不能替代专业医学评估。

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TABLE
}

# ─── 子命令: ideal-weight ────────────────────────────────────────────────────
cmd_ideal_weight() {
    local height=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --height|-h) height="$2"; shift 2 ;;
            *) shift ;;
        esac
    done

    [[ -z "$height" ]] && err "缺少身高参数。用法: ideal-weight --height 175"
    is_positive_number "$height" || err "身高必须是正数 (单位: cm)"

    if (( $(echo "$height < 50 || $height > 280" | bc -l) )); then
        err "身高范围异常 (合理范围: 50-280 cm)"
    fi

    check_bc

    local height_m
    height_m=$(calc "$height / 100")

    # WHO 国际标准 (BMI 18.5 - 24.9)
    local who_min who_max
    who_min=$(calc "18.5 * $height_m * $height_m")
    who_max=$(calc "24.9 * $height_m * $height_m")
    who_min=$(printf "%.1f" "$who_min")
    who_max=$(printf "%.1f" "$who_max")

    # 亚洲标准 (BMI 18.5 - 22.9)
    local asian_min asian_max
    asian_min=$(calc "18.5 * $height_m * $height_m")
    asian_max=$(calc "22.9 * $height_m * $height_m")
    asian_min=$(printf "%.1f" "$asian_min")
    asian_max=$(printf "%.1f" "$asian_max")

    # Broca 公式 (适用于成人)
    local broca_male broca_female
    broca_male=$(calc "($height - 100) * 0.9")
    broca_female=$(calc "($height - 100) * 0.85")
    broca_male=$(printf "%.1f" "$broca_male")
    broca_female=$(printf "%.1f" "$broca_female")

    # Devine 公式
    # 男: 50 + 0.91 * (height_cm - 152.4)
    # 女: 45.5 + 0.91 * (height_cm - 152.4)
    local devine_male devine_female
    devine_male=$(calc "50 + 0.91 * ($height - 152.4)")
    devine_female=$(calc "45.5 + 0.91 * ($height - 152.4)")
    devine_male=$(printf "%.1f" "$devine_male")
    devine_female=$(printf "%.1f" "$devine_female")

    # Robinson 公式
    # 男: 52 + 0.75 * (height_cm - 152.4)
    # 女: 49 + 0.67 * (height_cm - 152.4)
    local robin_male robin_female
    robin_male=$(calc "52 + 0.75 * ($height - 152.4)")
    robin_female=$(calc "49 + 0.67 * ($height - 152.4)")
    robin_male=$(printf "%.1f" "$robin_male")
    robin_female=$(printf "%.1f" "$robin_female")

    # BMI=22 时的理想体重 (常用参考点)
    local ideal_22
    ideal_22=$(calc "22.0 * $height_m * $height_m")
    ideal_22=$(printf "%.1f" "$ideal_22")

    cat << RESULT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ⚖️  理想体重范围  (身高: ${height} cm)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📊 基于 BMI 的健康体重范围:
  ┌────────────────┬──────────────────────┐
  │ 标准           │ 体重范围 (kg)        │
  ├────────────────┼──────────────────────┤
  │ WHO 国际标准   │ ${who_min} ~ ${who_max}     │
  │ (BMI 18.5-24.9)│                      │
  ├────────────────┼──────────────────────┤
  │ 亚洲标准       │ ${asian_min} ~ ${asian_max}     │
  │ (BMI 18.5-22.9)│                      │
  ├────────────────┼──────────────────────┤
  │ BMI=22 理想值  │ ${ideal_22}              │
  └────────────────┴──────────────────────┘

  📐 经典公式估算:
  ┌────────────────┬──────────┬──────────┐
  │ 公式           │ 男性(kg) │ 女性(kg) │
  ├────────────────┼──────────┼──────────┤
  │ Broca 公式     │ ${broca_male}    │ ${broca_female}    │
  │ Devine 公式    │ ${devine_male}    │ ${devine_female}    │
  │ Robinson 公式  │ ${robin_male}    │ ${robin_female}    │
  └────────────────┴──────────┴──────────┘

  📝 公式说明:
  • Broca:    男 = (身高-100)×0.9 | 女 = (身高-100)×0.85
  • Devine:   男 = 50+0.91×(身高-152.4) | 女 = 45.5+0.91×(身高-152.4)
  • Robinson: 男 = 52+0.75×(身高-152.4) | 女 = 49+0.67×(身高-152.4)

  ⚠️  以上为参考值，实际理想体重还需考虑年龄、体脂率、
      肌肉量等因素。建议结合体脂率综合评估。

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
RESULT
}

# ─── 主路由 ──────────────────────────────────────────────────────────────────
CMD="${1:-}"; shift 2>/dev/null || true

case "$CMD" in
    calculate)    cmd_calculate "$@" ;;
    classify)     cmd_classify ;;
    ideal-weight) cmd_ideal_weight "$@" ;;
    *)
        cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📊 BMI Calculator — 使用指南
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  命令:
    calculate --height <cm> --weight <kg>
        计算BMI值，输出分类和建议
        示例: calculate --height 175 --weight 70

    classify
        显示WHO BMI分类标准表

    ideal-weight --height <cm>
        根据身高计算理想体重范围
        示例: ideal-weight --height 175

  所有计算均在本地完成，使用 bc 精确计算。

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
        ;;
esac
