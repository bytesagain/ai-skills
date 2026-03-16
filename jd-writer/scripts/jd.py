#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""招聘JD撰写助手 - Python 3.6+"""
from __future__ import print_function
import sys
import datetime

# ── 职位模板库 ──
ROLE_TEMPLATES = {
    "前端开发": {
        "duties": [
            "负责公司Web前端产品的设计与开发",
            "与后端工程师协作，完成接口联调与数据对接",
            "参与前端技术选型和架构设计",
            "优化页面性能，提升用户体验",
            "编写高质量、可维护的前端代码",
        ],
        "skills": ["HTML/CSS/JavaScript", "React/Vue/Angular", "Webpack/Vite", "Git", "RESTful API"],
    },
    "后端开发": {
        "duties": [
            "负责服务端业务逻辑的设计与实现",
            "设计并优化数据库结构，保障数据一致性",
            "开发和维护RESTful API接口",
            "参与系统架构设计和技术方案评审",
            "排查和解决线上问题，保障系统稳定运行",
        ],
        "skills": ["Java/Go/Python", "Spring/Gin/Django", "MySQL/PostgreSQL", "Redis", "Docker/K8s"],
    },
    "产品经理": {
        "duties": [
            "负责产品规划、需求分析和功能设计",
            "撰写产品需求文档（PRD），推动项目落地",
            "跟踪产品数据，分析用户行为，持续优化产品体验",
            "协调设计、开发、测试等团队，确保项目按时交付",
            "关注行业动态和竞品分析，发掘产品创新机会",
        ],
        "skills": ["需求分析", "原型设计(Axure/Figma)", "数据分析", "项目管理", "用户研究"],
    },
    "数据分析": {
        "duties": [
            "负责业务数据的采集、清洗和分析",
            "建立数据指标体系，输出数据报告和洞察",
            "支持业务团队的数据需求，提供数据驱动的决策建议",
            "搭建和维护数据看板，实现数据可视化",
            "参与数据仓库建设和ETL流程优化",
        ],
        "skills": ["SQL", "Python/R", "Tableau/PowerBI", "Excel", "统计学基础"],
    },
    "UI设计": {
        "duties": [
            "负责产品的视觉设计和交互设计",
            "制定和维护设计规范，保障产品视觉一致性",
            "与产品经理和开发工程师紧密协作，推动设计落地",
            "进行用户研究和可用性测试，持续优化设计方案",
            "关注设计趋势，提升产品的审美水平和用户体验",
        ],
        "skills": ["Figma/Sketch", "Adobe系列", "交互设计", "设计规范", "用户体验研究"],
    },
}

LEVEL_CONFIG = {
    "初级": {"exp": "1-3年", "prefix": "初级", "extra": "有学习热情和成长意愿，能独立完成基础任务"},
    "中级": {"exp": "3-5年", "prefix": "中级", "extra": "有较强的独立工作能力，能主导模块级别的设计与开发"},
    "高级": {"exp": "5年以上", "prefix": "高级/资深", "extra": "有丰富的项目经验，能主导系统架构设计，具备团队指导能力"},
}

COMPANY_BENEFITS = {
    "互联网大厂": [
        "有竞争力的薪资 + 丰厚年终奖（14-18薪）",
        "六险一金（补充商业保险）",
        "弹性工作制，部分岗位支持远程办公",
        "免费三餐 + 下午茶 + 零食不限量",
        "健身房、按摩室等员工福利设施",
        "完善的培训体系和职业发展通道",
        "每年带薪年假15天起 + 额外福利假",
        "股票/期权激励计划",
    ],
    "创业公司": [
        "有竞争力的薪资 + 期权激励",
        "五险一金",
        "扁平化管理，快速成长机会",
        "弹性工作时间",
        "团队氛围好，技术驱动",
        "定期团建和技术分享",
        "节日福利和生日关怀",
    ],
    "外企": [
        "有竞争力的薪资（13-16薪）",
        "六险一金 + 补充医疗保险",
        "标准工作时间，拒绝加班文化",
        "每年15-20天带薪年假",
        "灵活办公，支持WFH",
        "全球化工作环境，跨文化交流",
        "完善的培训和海外交流机会",
        "员工援助计划（EAP）",
    ],
    "国企/央企": [
        "稳定的薪资体系 + 绩效奖金",
        "六险二金（企业年金）",
        "标准工作时间，节假日正常休息",
        "完善的职级晋升体系",
        "带薪年假 + 各类福利假",
        "食堂、宿舍等后勤保障",
        "工会福利和节日慰问",
        "子女教育和住房补贴",
    ],
}


def get_template(role):
    """获取最匹配的职位模板"""
    for key in ROLE_TEMPLATES:
        if key in role or role in key:
            return ROLE_TEMPLATES[key]
    # 通用模板
    return {
        "duties": [
            "负责{role}相关的核心工作内容".format(role=role),
            "参与团队项目，推动业务目标达成",
            "与跨部门团队协作，确保工作顺利推进",
            "持续学习和提升专业技能",
            "完成上级交办的其他工作任务",
        ],
        "skills": ["专业领域知识", "沟通协作能力", "问题解决能力", "学习能力", "团队合作精神"],
    }


def cmd_write(args):
    """生成完整JD"""
    if len(args) < 2:
        print("用法: jd.sh write \"职位\" \"公司\" [--level 初级|中级|高级]")
        sys.exit(1)

    role = args[0]
    company = args[1]
    level = "中级"
    if "--level" in args:
        idx = args.index("--level")
        if idx + 1 < len(args):
            level = args[idx + 1]

    if level not in LEVEL_CONFIG:
        level = "中级"

    lv = LEVEL_CONFIG[level]
    tmpl = get_template(role)
    today = datetime.date.today().strftime("%Y-%m-%d")

    # 确定公司类型用于福利
    benefits = COMPANY_BENEFITS.get("创业公司", list(COMPANY_BENEFITS.values())[0])
    for ctype in COMPANY_BENEFITS:
        if ctype in company:
            benefits = COMPANY_BENEFITS[ctype]
            break

    print("=" * 60)
    print("{company} 招聘 | {prefix}{role}".format(company=company, prefix=lv["prefix"], role=role))
    print("=" * 60)
    print("")
    print("## 职位信息")
    print("- 职位名称：{prefix}{role}".format(prefix=lv["prefix"], role=role))
    print("- 所属公司：{company}".format(company=company))
    print("- 经验要求：{exp}".format(exp=lv["exp"]))
    print("- 发布日期：{today}".format(today=today))
    print("")
    print("## 岗位职责")
    for i, duty in enumerate(tmpl["duties"], 1):
        print("{i}. {duty}".format(i=i, duty=duty))
    print("")
    print("## 任职要求")
    print("1. 本科及以上学历，计算机或相关专业优先")
    print("2. {exp}相关工作经验".format(exp=lv["exp"]))
    for i, skill in enumerate(tmpl["skills"], 3):
        print("{i}. 熟悉/掌握 {skill}".format(i=i, skill=skill))
    print("{i}. {extra}".format(i=len(tmpl["skills"]) + 3, extra=lv["extra"]))
    print("{i}. 良好的沟通表达能力和团队协作精神".format(i=len(tmpl["skills"]) + 4))
    print("")
    print("## 福利待遇")
    for b in benefits:
        print("- {b}".format(b=b))
    print("")
    print("## 关于{company}".format(company=company))
    print("{company}是一家充满活力的企业，致力于为用户提供优质的产品和服务。".format(company=company))
    print("我们注重人才培养，提供广阔的职业发展空间。")
    print("欢迎有志之士加入我们的团队！")
    print("")
    print("---")
    print("投递方式：请将简历发送至 hr@{placeholder}.com".format(placeholder=company.lower().replace(" ", "")))
    print("（JD由jd-writer生成，请根据实际情况调整）")


def cmd_requirements(args):
    """生成任职要求"""
    if len(args) < 1:
        print("用法: jd.sh requirements \"职位\"")
        sys.exit(1)

    role = args[0]
    tmpl = get_template(role)

    print("=" * 60)
    print("{role} - 任职要求".format(role=role))
    print("=" * 60)
    print("")
    print("### 基本要求")
    print("1. 本科及以上学历，相关专业优先")
    print("2. 有相关岗位工作或实习经验")
    print("3. 具备良好的学习能力和自驱力")
    print("")
    print("### 技能要求")
    for i, skill in enumerate(tmpl["skills"], 1):
        print("{i}. 熟练掌握 {skill}".format(i=i, skill=skill))
    print("")
    print("### 加分项")
    print("- 有知名企业或大型项目经验")
    print("- 有开源项目贡献或技术博客")
    print("- 对新技术有持续的学习热情")
    print("- 有良好的英语读写能力")
    print("")
    print("### 软技能")
    print("- 优秀的沟通表达能力")
    print("- 强烈的责任心和团队合作精神")
    print("- 良好的时间管理和多任务处理能力")
    print("- 积极主动，善于发现和解决问题")


def cmd_benefits(args):
    """生成福利亮点"""
    if len(args) < 1:
        print("用法: jd.sh benefits \"公司类型\"")
        print("可选类型：{types}".format(types="、".join(COMPANY_BENEFITS.keys())))
        sys.exit(1)

    ctype = args[0]
    matched = None
    for key in COMPANY_BENEFITS:
        if key in ctype or ctype in key:
            matched = key
            break

    if not matched:
        print("未找到匹配的公司类型：{ctype}".format(ctype=ctype))
        print("可选类型：{types}".format(types="、".join(COMPANY_BENEFITS.keys())))
        print("")
        print("展示所有类型的福利亮点：")
        for key, blist in COMPANY_BENEFITS.items():
            print("")
            print("### {key}".format(key=key))
            for b in blist:
                print("  - {b}".format(b=b))
        return

    print("=" * 60)
    print("{matched} - 福利亮点".format(matched=matched))
    print("=" * 60)
    print("")
    for i, b in enumerate(COMPANY_BENEFITS[matched], 1):
        print("{i}. {b}".format(i=i, b=b))
    print("")
    print("💡 提示：以上为参考模板，请根据公司实际福利情况调整。")


def cmd_optimize(args):
    """JD优化建议"""
    if len(args) < 1:
        print("用法: jd.sh optimize \"现有JD文本\"")
        sys.exit(1)

    jd_text = args[0]

    print("=" * 60)
    print("JD 优化分析报告")
    print("=" * 60)
    print("")
    print("### 原始JD")
    print(jd_text)
    print("")

    # 分析维度
    issues = []
    suggestions = []

    if len(jd_text) < 50:
        issues.append("JD内容过于简短，信息量不足")
        suggestions.append("建议补充详细的岗位职责（至少5条）")
        suggestions.append("建议补充明确的任职要求（学历、经验、技能）")

    if "薪" not in jd_text and "待遇" not in jd_text and "福利" not in jd_text:
        issues.append("缺少薪资/福利信息")
        suggestions.append("建议注明薪资范围或福利待遇，提升吸引力")

    if "年" not in jd_text and "经验" not in jd_text:
        issues.append("缺少经验要求")
        suggestions.append("建议明确所需工作经验年限")

    if "学历" not in jd_text and "本科" not in jd_text and "硕士" not in jd_text:
        issues.append("缺少学历要求")
        suggestions.append("建议注明最低学历要求")

    if "职责" not in jd_text and "负责" not in jd_text:
        issues.append("岗位职责描述不清晰")
        suggestions.append("建议用编号列出具体岗位职责")

    # 通用优化建议
    suggestions.append("使用结构化格式：职位信息 → 岗位职责 → 任职要求 → 福利待遇")
    suggestions.append("避免使用过于模糊的描述，用具体数据和场景说明")
    suggestions.append("加入公司亮点和团队介绍，增强吸引力")
    suggestions.append("注明工作地点和工作时间")

    print("### 发现的问题")
    if issues:
        for i, issue in enumerate(issues, 1):
            print("{i}. ⚠️  {issue}".format(i=i, issue=issue))
    else:
        print("✅ 未发现明显结构性问题")
    print("")

    print("### 优化建议")
    for i, sug in enumerate(suggestions, 1):
        print("{i}. {sug}".format(i=i, sug=sug))
    print("")
    print("💡 使用 `jd.sh write \"职位\" \"公司\"` 可以生成完整的JD模板作为参考。")


def cmd_benchmark(args):
    """薪资参考与市场基准"""
    if len(args) < 1:
        print("用法: jd.sh benchmark \"职位\" [\"城市\"]")
        sys.exit(1)

    role = args[0]
    city = args[1] if len(args) > 1 else "一线城市"

    # 薪资数据库（参考范围）
    SALARY_DB = {
        "前端开发": {"初级": "8-15K", "中级": "15-25K", "高级": "25-45K", "专家": "45-70K"},
        "后端开发": {"初级": "10-18K", "中级": "18-30K", "高级": "30-50K", "专家": "50-80K"},
        "产品经理": {"初级": "8-15K", "中级": "15-28K", "高级": "28-45K", "总监": "45-80K"},
        "数据分析": {"初级": "8-14K", "中级": "14-25K", "高级": "25-40K", "专家": "40-60K"},
        "UI设计":   {"初级": "6-12K", "中级": "12-22K", "高级": "22-35K", "专家": "35-50K"},
        "测试工程师": {"初级": "7-13K", "中级": "13-22K", "高级": "22-35K", "专家": "35-50K"},
        "运营":     {"初级": "6-10K", "中级": "10-18K", "高级": "18-30K", "总监": "30-50K"},
        "人力资源": {"初级": "6-10K", "中级": "10-18K", "高级": "18-30K", "总监": "30-50K"},
        "销售":     {"初级": "5-8K+提成", "中级": "8-15K+提成", "高级": "15-25K+提成", "总监": "25-40K+提成"},
        "市场营销": {"初级": "6-10K", "中级": "10-18K", "高级": "18-30K", "总监": "30-50K"},
    }

    CITY_FACTOR = {
        "北京": 1.0, "上海": 1.0, "深圳": 0.95, "杭州": 0.90,
        "广州": 0.85, "成都": 0.75, "武汉": 0.72, "南京": 0.80,
        "西安": 0.68, "长沙": 0.65, "重庆": 0.68, "苏州": 0.78,
        "一线城市": 1.0, "新一线": 0.80, "二线城市": 0.65, "三线城市": 0.50,
    }

    STANDARD_BENEFITS = {
        "基础标配": ["五险一金", "带薪年假", "法定节假日", "年度体检"],
        "中等水平": ["六险一金", "补充商业保险", "带薪年假10-15天", "年度体检", "节日福利", "生日关怀", "团建活动"],
        "优质福利": ["六险一金", "补充商业保险+家属", "带薪年假15-20天", "弹性工作制", "免费餐饮/餐补", "健身补贴", "学习基金", "股票/期权", "年度旅游"],
    }

    # 匹配职位
    matched_role = None
    for key in SALARY_DB:
        if key in role or role in key:
            matched_role = key
            break

    # 匹配城市系数
    factor = 1.0
    for key in CITY_FACTOR:
        if key in city or city in key:
            factor = CITY_FACTOR[key]
            break

    print("=" * 60)
    print("  薪资市场参考报告")
    print("=" * 60)
    print("")
    print("  职位：{}".format(role))
    print("  城市：{}（系数：{:.0f}%）".format(city, factor * 100))
    print("  数据参考时间：{}".format(datetime.date.today().strftime("%Y年%m月")))
    print("")

    print("-" * 60)
    print("  一、薪资范围参考（月薪，税前）")
    print("-" * 60)
    if matched_role:
        salary = SALARY_DB[matched_role]
        print("")
        for level, pay in salary.items():
            note = ""
            if factor != 1.0:
                note = " ← {}基准".format(city)
            print("  {:<6} {}{}".format(level + ":", pay, note))
        if factor != 1.0 and factor < 1.0:
            print("")
            print("  ⚠️  {}薪资约为一线城市的 {:.0f}%".format(city, factor * 100))
            print("  💡 但生活成本也相应较低，实际购买力差距没那么大")
    else:
        print("")
        print("  未找到 \"{}\" 的精确薪资数据".format(role))
        print("  建议参考以下相近岗位：")
        for key in SALARY_DB:
            print("    - {}".format(key))
    print("")

    print("-" * 60)
    print("  二、福利待遇标配参考")
    print("-" * 60)
    print("")
    for level, benefits in STANDARD_BENEFITS.items():
        print("  【{}】".format(level))
        for b in benefits:
            print("    ✓ {}".format(b))
        print("")

    print("-" * 60)
    print("  三、JD中薪资表述建议")
    print("-" * 60)
    print("")
    print("  ✅ 推荐写法：")
    print("    - \"月薪 15-25K·14薪\" — 透明、吸引力强")
    print("    - \"年薪 20-35万，含股票期权\" — 高端岗位适用")
    print("    - \"底薪 + 绩效奖金 + 年终奖\" — 销售类岗位适用")
    print("")
    print("  ❌ 避免写法：")
    print("    - \"面议\" — 候选人投递意愿降低30%+")
    print("    - \"有竞争力的薪资\" — 无信息量")
    print("    - 薪资范围过大如\"10-50K\" — 显得不专业")
    print("")
    print("  📊 数据来源说明：以上为行业参考范围，实际薪资因公司规模、")
    print("     业务阶段、个人能力等因素有所差异。建议结合招聘平台数据验证。")


def cmd_inclusive(args):
    """包容性检查"""
    if len(args) < 1:
        print("用法: jd.sh inclusive \"JD文本\"")
        sys.exit(1)

    jd_text = args[0]

    # 偏见词库
    BIAS_PATTERNS = {
        "性别偏见": {
            "keywords": ["男性优先", "仅限男性", "限男", "男士优先", "小姐姐", "小哥哥",
                         "美女", "帅哥", "女性优先", "仅限女性", "限女", "形象好气质佳",
                         "身高要求", "已婚已育优先", "未婚优先"],
            "suggestions": [
                "移除性别限定词，使用中性表述",
                "\"形象好气质佳\" → 删除或改为 \"具有专业形象\"",
                "\"小姐姐/小哥哥\" → 改为 \"团队成员/同事\"",
                "避免对婚育状况做要求，这属于就业歧视",
            ]
        },
        "年龄歧视": {
            "keywords": ["35岁以下", "30岁以下", "25岁以下", "90后", "95后",
                         "年轻", "应届", "限年龄", "45岁以下", "大龄勿扰"],
            "suggestions": [
                "用经验年限代替年龄限制：\"3-5年经验\" 而非 \"30岁以下\"",
                "\"年轻有活力\" → \"充满热情和干劲\"",
                "\"90后/95后\" → 删除，以能力和经验为标准",
                "法律提示：《就业促进法》禁止年龄歧视",
            ]
        },
        "学历歧视": {
            "keywords": ["985", "211", "双一流", "全日制", "第一学历",
                         "统招", "海归优先", "QS前100"],
            "suggestions": [
                "\"985/211\" → 改为 \"本科及以上学历，相关专业优先\"",
                "\"第一学历\" → 删除，关注最高学历和实际能力",
                "\"全日制\" → 考虑是否必要，许多优秀人才是非全日制",
                "建议增加\"同等能力者学历可适当放宽\"的表述",
            ]
        },
        "地域歧视": {
            "keywords": ["本地户口", "本地人", "户籍要求", "限本地"],
            "suggestions": [
                "除非岗位有户籍硬性要求（如公务员），否则应删除",
                "改为\"工作地点：XX城市\"即可",
            ]
        },
        "健康歧视": {
            "keywords": ["身体健康", "无传染病", "无残疾", "体检合格"],
            "suggestions": [
                "除非岗位有特殊体能要求，否则不应提及健康状况",
                "如确需体检，可写\"入职体检\"但不应作为筛选条件",
            ]
        },
        "隐性排斥": {
            "keywords": ["能加班", "适应高压", "能出差", "服从安排",
                         "不计较得失", "能接受996", "弹性工作时间长"],
            "suggestions": [
                "\"能加班/996\" → 改为说明实际工作节奏，如\"项目冲刺期可能需要加班\"",
                "\"服从安排\" → \"具备良好的执行力和适应能力\"",
                "\"不计较得失\" → 删除，这是压榨的暗示",
                "如实说明工作强度，吸引真正匹配的候选人",
            ]
        },
    }

    print("=" * 60)
    print("  JD 包容性检查报告")
    print("=" * 60)
    print("")
    print("  检查文本：")
    # 分行显示，每行不超过50字
    for i in range(0, len(jd_text), 50):
        print("    {}".format(jd_text[i:i+50]))
    print("")

    found_issues = []
    total_score = 100

    for category, data in BIAS_PATTERNS.items():
        found_keywords = []
        for kw in data["keywords"]:
            if kw in jd_text:
                found_keywords.append(kw)

        if found_keywords:
            total_score -= len(found_keywords) * 10
            found_issues.append({
                "category": category,
                "keywords": found_keywords,
                "suggestions": data["suggestions"],
            })

    if total_score < 0:
        total_score = 0

    # 评分
    print("-" * 60)
    print("  包容性评分：{}/100".format(total_score))
    print("-" * 60)
    if total_score >= 90:
        print("  ✅ 优秀 — JD用语规范，包容性良好")
    elif total_score >= 70:
        print("  ⚠️  良好 — 有少量问题需要修正")
    elif total_score >= 50:
        print("  ⚠️  一般 — 存在多处偏见用语，建议修改")
    else:
        print("  ❌ 较差 — 存在严重歧视性用语，必须修改")
    print("")

    if found_issues:
        print("-" * 60)
        print("  发现的问题")
        print("-" * 60)
        for i, issue in enumerate(found_issues, 1):
            print("")
            print("  {}. 【{}】".format(i, issue["category"]))
            print("     触发词：{}".format("、".join(issue["keywords"])))
            print("     修改建议：")
            for s in issue["suggestions"]:
                print("       → {}".format(s))
    else:
        print("  🎉 未发现明显偏见用语，JD表现良好！")

    print("")
    print("-" * 60)
    print("  通用包容性建议")
    print("-" * 60)
    print("")
    print("  1. 使用性别中性的职位名称")
    print("     \"程序员\" → \"软件工程师\"")
    print("     \"女秘书\" → \"行政助理\"")
    print("")
    print("  2. 聚焦能力和经验，而非个人属性")
    print("     强调\"3年项目管理经验\"而非\"30岁以下\"")
    print("")
    print("  3. 添加平等就业声明")
    print("     \"我们是平等就业机会雇主，欢迎不同背景的人才加入\"")
    print("")
    print("  4. 避免不必要的限定条件")
    print("     每一条要求都问自己：这真的是岗位必需的吗？")
    print("")
    print("  📋 法律参考：《就业促进法》《劳动法》《妇女权益保障法》")
    print("     均明确禁止就业歧视")


def cmd_help():
    print("=" * 60)
    print("jd-writer - 招聘JD撰写助手")
    print("=" * 60)
    print("")
    print("用法:")
    print("  jd.sh write \"职位\" \"公司\" [--level 初级|中级|高级]  生成完整JD")
    print("  jd.sh requirements \"职位\"                            生成任职要求")
    print("  jd.sh benefits \"公司类型\"                             生成福利亮点")
    print("  jd.sh optimize \"现有JD文本\"                          JD优化建议")
    print("  jd.sh benchmark \"职位\" [\"城市\"]                      薪资市场参考")
    print("  jd.sh inclusive \"JD文本\"                              包容性检查")
    print("  jd.sh help                                            显示帮助")
    print("")
    print("支持的职位模板: {roles}".format(roles="、".join(ROLE_TEMPLATES.keys())))
    print("支持的公司类型: {types}".format(types="、".join(COMPANY_BENEFITS.keys())))
    print("支持的级别: 初级、中级、高级")
    print("")
    print("示例:")
    print("  jd.sh write \"前端开发\" \"字节跳动\" --level 高级")
    print("  jd.sh requirements \"产品经理\"")
    print("  jd.sh benefits \"外企\"")
    print("  jd.sh benchmark \"后端开发\" \"杭州\"")
    print("  jd.sh inclusive \"招聘Java开发，男性优先，35岁以下\"")


def main():
    if len(sys.argv) < 2:
        cmd_help()
        sys.exit(0)

    cmd = sys.argv[1]
    args = sys.argv[2:]

    commands = {
        "write": cmd_write,
        "requirements": cmd_requirements,
        "benefits": cmd_benefits,
        "optimize": cmd_optimize,
        "benchmark": cmd_benchmark,
        "inclusive": cmd_inclusive,
        "help": lambda a: cmd_help(),
    }

    if cmd in commands:
        commands[cmd](args)
    else:
        print("未知命令: {cmd}".format(cmd=cmd))
        print("使用 jd.sh help 查看帮助")
        sys.exit(1)


if __name__ == "__main__":
    main()
