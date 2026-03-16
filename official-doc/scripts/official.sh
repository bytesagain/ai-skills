#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

ACTION="${1:-help}"
shift 2>/dev/null || true

python3 - "$ACTION" "$@" << 'PYEOF'
# -*- coding: utf-8 -*-
import sys
import datetime

def today():
    return datetime.date.today().strftime("%Y年%m月%d日")

def year():
    return str(datetime.date.today().year)

def doc_number():
    """生成示例发文字号"""
    return "〔{}〕X号".format(year())

def notice(title, content):
    print("""
================================================================================

                    [发文机关标志/红头]

                  ━━━━━━━━━━━━━━━━━━━━

  [机关名]发〔{yr}〕X号


                     {title}


[主送机关]：

  {content}。根据[依据/背景]，现将有关事项通知如下：

  一、[第一项内容]

    [具体要求和说明]

  二、[第二项内容]

    [具体要求和说明]

  三、[第三项内容]

    [具体要求和说明]

  四、工作要求

    （一）高度重视。[要求各单位/部门提高认识]

    （二）精心组织。[要求制定方案、明确责任]

    （三）加强督查。[要求建立检查机制、及时反馈]

  请各[单位/部门]认真贯彻执行，确保各项工作落到实处。


                                        [发文机关名称]
                                        {date}

  ─────────────────────────────────────────────
  抄送：[抄送单位]
  [机关名称]办公室                 {date}印发
  ─────────────────────────────────────────────

================================================================================
💡 公文格式说明：
   - 标题：发文机关 + 事由 + 文种（如"关于...的通知"）
   - 正文：缘由 → 事项 → 要求
   - 字体：标题方正小标宋2号，正文仿宋3号
   - 页边距：上3.7cm 下3.5cm 左2.8cm 右2.6cm
================================================================================
""".format(title=title, content=content, date=today(), yr=year()))

def request(reason, content):
    print("""
================================================================================

                    [发文机关标志/红头]

                  ━━━━━━━━━━━━━━━━━━━━

  [机关名]发〔{yr}〕X号


              关于{reason}的请示


[上级机关名称]：

  [开头说明请示的背景和缘由]。为[目的]，现就{reason}请示如下：

  一、基本情况

    {content}。

    [补充说明当前情况、存在的问题、请示的必要性]

  二、请示事项

    （一）[具体请示内容1]

    （二）[具体请示内容2]

    （三）[具体请示内容3]

  三、经费预算（如涉及）

    本事项预计需要经费[X]万元，资金来源为[预算科目/专项资金]。
    具体预算明细如下：
      1. [项目1]：[X]万元
      2. [项目2]：[X]万元
      3. [项目3]：[X]万元

  以上请示，妥否，请批示。


                                        [发文机关名称]
                                        {date}

  ─────────────────────────────────────────────
  联系人：[姓名]    电话：[号码]
  ─────────────────────────────────────────────

================================================================================
💡 请示格式要点：
   - 一文一事（每份请示只讲一件事）
   - 主送一个机关（不可多头请示）
   - 结尾用"妥否，请批示"或"以上请示，请审批"
   - 不可夹带报告内容
================================================================================
""".format(reason=reason, content=content, date=today(), yr=year()))

def report(topic, content):
    print("""
================================================================================

                    [发文机关标志/红头]

                  ━━━━━━━━━━━━━━━━━━━━

  [机关名]发〔{yr}〕X号


              关于{topic}的报告


[上级机关名称]：

  根据[要求/部署/安排]，现将{topic}有关情况报告如下：

  一、基本情况

    {content}。

    [概述整体工作情况、背景]

  二、主要做法和成效

    （一）[做法1]
      [具体内容和取得的成效，用数据说话]

    （二）[做法2]
      [具体内容和取得的成效]

    （三）[做法3]
      [具体内容和取得的成效]

  三、存在的问题和困难

    （一）[问题1]
      [具体描述]

    （二）[问题2]
      [具体描述]

  四、下一步工作计划

    （一）[计划1]
      [具体措施和时间安排]

    （二）[计划2]
      [具体措施和时间安排]

    （三）[计划3]
      [具体措施和时间安排]

  特此报告。


                                        [发文机关名称]
                                        {date}

  ─────────────────────────────────────────────
  抄送：[相关单位]
  ─────────────────────────────────────────────

================================================================================
💡 报告格式要点：
   - 报告不得夹带请示事项
   - 结尾用"特此报告"
   - 内容要实事求是，用数据和事实说话
   - 既要总结成绩，也要客观反映问题
================================================================================
""".format(topic=topic, content=content, date=today(), yr=year()))

def reply(original_request, opinion):
    print("""
================================================================================

                    [发文机关标志/红头]

                  ━━━━━━━━━━━━━━━━━━━━

  [机关名]发〔{yr}〕X号


              关于{original}的批复


[下级机关名称]：

  你[单位/部门]《{original}》（[原文字号]）收悉。
  经研究，现批复如下：

  一、总体意见

    {opinion}。

  二、具体意见

    （一）[针对请示第一项的批复意见]

    （二）[针对请示第二项的批复意见]

    （三）[针对请示第三项的批复意见]

  三、相关要求

    （一）[执行要求1]

    （二）[执行要求2]

    （三）请你[单位]按照上述意见抓好落实，并将执行情况
          及时报告我[机关]。

  此复。


                                        [发文机关名称]
                                        {date}

  ─────────────────────────────────────────────
  抄送：[相关单位]
  [机关名称]办公室                 {date}印发
  ─────────────────────────────────────────────

================================================================================
💡 批复格式要点：
   - 批复针对请示，一请示一批复
   - 开头引叙原请示标题和发文字号
   - 态度明确：同意/不同意/部分同意
   - 结尾用"此复"或"特此批复"
================================================================================
""".format(original=original_request, opinion=opinion, date=today(), yr=year()))

def format_check(text):
    """公文格式检查"""
    issues = []
    suggestions = []
    score = 100

    # 检查标题格式
    if "关于" not in text and "通知" not in text and "报告" not in text and "请示" not in text:
        issues.append("缺少标准公文标题（应包含\"关于...的通知/报告/请示/批复\"）")
        score -= 15

    # 检查发文字号
    if "〔" not in text and "号" not in text:
        issues.append("缺少发文字号（格式：[机关代字]〔年份〕X号）")
        score -= 10

    # 检查主送机关
    if "：" not in text:
        issues.append("缺少主送机关（应明确行文对象）")
        score -= 10

    # 检查日期
    has_date = False
    for d in ["年", "月", "日"]:
        if d in text:
            has_date = True
            break
    if not has_date:
        issues.append("缺少日期（应标注发文日期）")
        score -= 10

    # 检查结尾用语
    endings = ["特此通知", "特此报告", "妥否，请批示", "此复", "以上请示"]
    has_ending = False
    for e in endings:
        if e in text:
            has_ending = True
            break
    if not has_ending:
        issues.append("缺少规范结尾用语（如\"特此通知\"\"特此报告\"\"妥否，请批示\"）")
        score -= 10

    # 检查签章
    if "签" not in text and "盖章" not in text and "发文机关" not in text:
        issues.append("缺少落款签章区域")
        score -= 5

    # 检查段落格式
    if "一、" not in text and "（一）" not in text:
        suggestions.append("建议使用规范的段落编号（一、二、三 或 （一）（二）（三））")
        score -= 5

    # 检查长度
    if len(text) < 50:
        suggestions.append("公文内容过短，可能缺少必要信息")
        score -= 10
    elif len(text) > 3000:
        suggestions.append("公文篇幅较长，建议精简或拆分")

    if score < 0:
        score = 0

    print("=" * 60)
    print("  公文格式检查报告")
    print("=" * 60)
    print("")
    print("  送检文本：")
    for i in range(0, min(len(text), 200), 50):
        print("    {}".format(text[i:i+50]))
    if len(text) > 200:
        print("    ...（共{}字）".format(len(text)))
    print("")

    print("-" * 60)
    print("  格式评分：{}/100".format(score))
    print("-" * 60)
    if score >= 90:
        print("  ✅ 优秀 — 格式基本规范")
    elif score >= 70:
        print("  ⚠️  良好 — 有少量格式问题")
    elif score >= 50:
        print("  ⚠️  一般 — 存在多处格式问题")
    else:
        print("  ❌ 较差 — 格式问题严重，需要重写")
    print("")

    if issues:
        print("-" * 60)
        print("  发现的问题")
        print("-" * 60)
        for i, issue in enumerate(issues, 1):
            print("  {}. ❌ {}".format(i, issue))
        print("")

    if suggestions:
        print("-" * 60)
        print("  改进建议")
        print("-" * 60)
        for i, sug in enumerate(suggestions, 1):
            print("  {}. 💡 {}".format(i, sug))
        print("")

    print("-" * 60)
    print("  标准公文格式规范")
    print("-" * 60)
    print("")
    print("  1. 文头区域")
    print("     - 发文机关标志（红头）")
    print("     - 发文字号：[机关代字]〔年份〕X号")
    print("     - 签发人（上行文需要）")
    print("")
    print("  2. 正文区域")
    print("     - 标题：发文机关 + 事由 + 文种")
    print("     - 主送机关：顶格写")
    print("     - 正文：缘由 → 事项 → 要求")
    print("     - 段落编号：一、（一）1.（1）")
    print("")
    print("  3. 版记区域")
    print("     - 发文机关署名")
    print("     - 成文日期")
    print("     - 印章")
    print("     - 抄送机关（如有）")
    print("")
    print("  4. 排版规范")
    print("     - 标题：方正小标宋体 2号")
    print("     - 正文：仿宋体 3号")
    print("     - 页边距：上3.7cm 下3.5cm 左2.8cm 右2.6cm")
    print("     - 行距：28-29磅")

def tone_check(text):
    """语气/用语检查"""
    # 口语化表达 → 公文用语 映射
    TONE_MAP = [
        ("我觉得", "经研究认为", "主观用语 → 客观用语"),
        ("我们觉得", "经研究认为", "主观用语 → 客观用语"),
        ("大概", "约/大约/预计", "模糊用语 → 精确用语"),
        ("差不多", "基本/大致", "口语化 → 正式用语"),
        ("很多", "大量/众多/若干", "模糊用语 → 正式量词"),
        ("一些", "部分/若干", "口语化 → 正式用语"),
        ("搞", "开展/推进/实施", "口语化 → 正式动词"),
        ("搞好", "做好/落实", "口语化 → 正式动词"),
        ("弄", "进行/完成/处理", "口语化 → 正式动词"),
        ("干", "从事/执行/开展", "口语化 → 正式动词"),
        ("要", "应/须/需", "口语化 → 正式助词"),
        ("得", "需要/必须/应当", "口语化 → 正式助词"),
        ("不行", "不可/不宜/不得", "口语化 → 正式否定"),
        ("不能", "不得/不应/不宜", "口语化 → 正式否定"),
        ("马上", "立即/即刻/即时", "口语化 → 正式时间词"),
        ("赶紧", "尽快/从速/立即", "口语化 → 正式时间词"),
        ("然后", "随后/此后/继而", "口语化 → 正式连接词"),
        ("但是", "但/然而/不过", "口语化 → 正式转折词"),
        ("所以", "因此/故/据此", "口语化 → 正式因果词"),
        ("因为", "鉴于/由于/因", "口语化 → 正式原因词"),
        ("这个", "该/此/本", "口语化 → 正式指示词"),
        ("那个", "该/彼", "口语化 → 正式指示词"),
        ("东西", "物品/事项/内容", "口语化 → 正式名词"),
        ("老板", "领导/主管/负责人", "口语化 → 正式称谓"),
        ("小伙伴", "同事/成员/同仁", "口语化 → 正式称谓"),
        ("OK", "可以/同意/准予", "外来语 → 中文正式用语"),
        ("嗯", "[删除]", "语气词不应出现在公文中"),
        ("吧", "[删除或改写]", "语气词不应出现在公文中"),
        ("呢", "[删除或改写]", "语气词不应出现在公文中"),
        ("啊", "[删除或改写]", "语气词不应出现在公文中"),
        ("哈", "[删除或改写]", "语气词不应出现在公文中"),
    ]

    print("=" * 60)
    print("  公文语气/用语检查报告")
    print("=" * 60)
    print("")
    print("  送检文本：")
    for i in range(0, min(len(text), 200), 50):
        print("    {}".format(text[i:i+50]))
    if len(text) > 200:
        print("    ...（共{}字）".format(len(text)))
    print("")

    found = []
    for informal, formal, category in TONE_MAP:
        if informal in text:
            found.append({
                "informal": informal,
                "formal": formal,
                "category": category,
            })

    score = max(0, 100 - len(found) * 8)

    print("-" * 60)
    print("  语气规范评分：{}/100".format(score))
    print("-" * 60)
    if score >= 90:
        print("  ✅ 优秀 — 用语规范，符合公文标准")
    elif score >= 70:
        print("  ⚠️  良好 — 有少量口语化表达")
    elif score >= 50:
        print("  ⚠️  一般 — 口语化表达较多，需要修改")
    else:
        print("  ❌ 较差 — 大量口语化表达，不符合公文标准")
    print("")

    if found:
        print("-" * 60)
        print("  需要修改的用语")
        print("-" * 60)
        print("")
        print("  | 口语化表达 | 建议替换为 | 说明 |")
        print("  |-----------|-----------|------|")
        for item in found:
            print("  | {} | {} | {} |".format(
                item["informal"], item["formal"], item["category"]))
        print("")

    print("-" * 60)
    print("  公文常用规范表达")
    print("-" * 60)
    print("")
    print("  开头用语：")
    print("    根据...  |  为了...  |  为贯彻落实...")
    print("    鉴于...  |  为进一步...  |  按照...要求")
    print("")
    print("  过渡用语：")
    print("    经研究决定...  |  现将有关事项通知如下...")
    print("    现就...提出以下意见...")
    print("")
    print("  要求用语：")
    print("    各单位要...  |  务必...  |  切实做好...")
    print("    确保...  |  严格执行...  |  认真贯彻...")
    print("")
    print("  结尾用语：")
    print("    特此通知  |  特此报告  |  妥否，请批示")
    print("    此复  |  以上意见如无不妥，请批转各地执行")

def template_lib(doc_type):
    """模板库"""
    templates = {
        "通知": {
            "title": "通知",
            "desc": "向下级机关或平级机关传达事项",
            "structure": [
                "标题：关于[事由]的通知",
                "主送：[接收单位]",
                "正文结构：",
                "  缘由（为什么发通知）",
                "  事项（通知什么内容，分条列出）",
                "  要求（对执行的要求）",
                "结尾：特此通知 / 请各单位认真贯彻执行",
            ],
        },
        "报告": {
            "title": "报告",
            "desc": "向上级机关汇报工作、反映情况",
            "structure": [
                "标题：关于[事由]的报告",
                "主送：[上级机关]",
                "正文结构：",
                "  基本情况（概述）",
                "  主要做法和成效（分条，用数据）",
                "  存在的问题（客观反映）",
                "  下一步计划（具体措施）",
                "结尾：特此报告",
            ],
        },
        "请示": {
            "title": "请示",
            "desc": "向上级机关请求指示或批准",
            "structure": [
                "标题：关于[事由]的请示",
                "主送：[上级机关]（只能主送一个）",
                "正文结构：",
                "  请示缘由（为什么要请示）",
                "  请示事项（具体请求什么，分条）",
                "  经费预算（如涉及费用）",
                "结尾：以上请示，妥否，请批示",
                "⚠️ 一文一事，不可夹带报告内容",
            ],
        },
        "批复": {
            "title": "批复",
            "desc": "上级机关对下级请示的答复",
            "structure": [
                "标题：关于[原请示事由]的批复",
                "主送：[请示机关]",
                "正文结构：",
                "  引叙原文（你单位《关于...的请示》收悉）",
                "  批复意见（同意/不同意/部分同意）",
                "  具体要求（执行注意事项）",
                "结尾：此复 / 特此批复",
            ],
        },
        "会议纪要": {
            "title": "会议纪要",
            "desc": "记录会议情况和议定事项",
            "structure": [
                "标题：[会议名称]会议纪要",
                "正文结构：",
                "  会议概况（时间、地点、主持人、参会人）",
                "  会议议题和讨论情况",
                "  会议决定事项（逐条列出）",
                "  任务分工和时间要求",
                "注意：不加盖印章，由主持人签发",
            ],
        },
        "工作总结": {
            "title": "工作总结",
            "desc": "总结一定时期的工作情况",
            "structure": [
                "标题：关于[时期][工作]的总结",
                "正文结构：",
                "  基本情况和总体评价",
                "  主要工作和成绩（分条，用数据）",
                "  经验和做法（可复制的好方法）",
                "  存在的问题和不足",
                "  下一步工作思路和计划",
            ],
        },
    }

    if doc_type == "all" or doc_type not in templates:
        print("=" * 60)
        print("  公文模板库")
        print("=" * 60)
        print("")
        for key, tmpl in templates.items():
            print("  📄 {} — {}".format(tmpl["title"], tmpl["desc"]))
        print("")
        print("  用法：official.sh template <类型>")
        print("  类型：{}".format(" | ".join(templates.keys())))
        if doc_type != "all" and doc_type not in templates:
            print("")
            print("  ❌ 未找到类型：{}".format(doc_type))
        return

    tmpl = templates[doc_type]
    print("=" * 60)
    print("  📄 {} 模板".format(tmpl["title"]))
    print("  {}".format(tmpl["desc"]))
    print("=" * 60)
    print("")

    print("-" * 60)
    print("  结构规范")
    print("-" * 60)
    print("")
    for item in tmpl["structure"]:
        if item.startswith("  "):
            print("    {}".format(item.strip()))
        else:
            print("  {}".format(item))
    print("")

    # 生成对应的完整模板
    print("-" * 60)
    print("  完整模板（可直接使用）")
    print("-" * 60)
    print("")
    print("  💡 使用命令生成完整{type}：".format(type=doc_type))
    cmd_map = {
        "通知": 'official.sh notice "标题" "内容"',
        "报告": 'official.sh report "主题" "内容"',
        "请示": 'official.sh request "事由" "请示内容"',
        "批复": 'official.sh reply "原请示" "批复意见"',
        "会议纪要": '（可参考 meeting-notes skill）',
        "工作总结": '（参考报告格式，调整结构）',
    }
    print("  {}".format(cmd_map.get(doc_type, "")))

def show_help():
    print("""
📄 公文生成器（标准格式）
==============================

用法：official.sh <命令> [参数...]

命令：
  notice       <标题> <内容>              通知
  request      <事由> <请示内容>          请示
  report       <主题> <内容>              报告
  reply        <原请示> <批复意见>        批复
  format-check <文本>                     格式检查
  tone         <文本>                     语气/用语检查
  template     <类型>                     模板库
  help                                    显示此帮助

模板类型：通知 | 报告 | 请示 | 批复 | 会议纪要 | 工作总结

示例：
  official.sh notice "关于开展安全检查的通知" "安全生产大检查"
  official.sh request "购置办公设备" "因业务发展需要拟购置电脑10台"
  official.sh format-check "关于...的通知..."
  official.sh tone "我觉得这个方案差不多可以搞一下"
  official.sh template "通知"
  official.sh template "all"
""")

if __name__ == "__main__":
    action = sys.argv[1] if len(sys.argv) > 1 else "help"
    args = sys.argv[2:]

    if action == "notice":
        if len(args) < 2:
            print("❌ 用法: official.sh notice <标题> <内容>")
            sys.exit(1)
        notice(args[0], args[1])
    elif action == "request":
        if len(args) < 2:
            print("❌ 用法: official.sh request <事由> <请示内容>")
            sys.exit(1)
        request(args[0], args[1])
    elif action == "report":
        if len(args) < 2:
            print("❌ 用法: official.sh report <主题> <内容>")
            sys.exit(1)
        report(args[0], args[1])
    elif action == "reply":
        if len(args) < 2:
            print("❌ 用法: official.sh reply <原请示> <批复意见>")
            sys.exit(1)
        reply(args[0], args[1])
    elif action == "format-check":
        if len(args) < 1:
            print("❌ 用法: official.sh format-check <文本>")
            sys.exit(1)
        format_check(args[0])
    elif action == "tone":
        if len(args) < 1:
            print("❌ 用法: official.sh tone <文本>")
            sys.exit(1)
        tone_check(args[0])
    elif action == "template":
        if len(args) < 1:
            template_lib("all")
        else:
            template_lib(args[0])
    elif action == "help":
        show_help()
    else:
        print("❌ 未知命令: {}".format(action))
        show_help()
        sys.exit(1)
PYEOF

echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
