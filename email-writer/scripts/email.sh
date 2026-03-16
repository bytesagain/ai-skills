#!/usr/bin/env bash
# email.sh — 邮件写作助手（中英双语）
set -euo pipefail

DATE=$(date '+%Y-%m-%d')

show_help() {
    cat <<'EOF'
邮件写作助手 - email.sh

用法：
  email.sh business  "收件人" "主题"              商务邮件
  email.sh followup  "主题"                       跟进邮件
  email.sh cold      "公司" "目的"                冷启动邮件
  email.sh apology   "原因"                       道歉邮件
  email.sh reply     "原文摘要" [--tone formal|friendly]  回复邮件
  email.sh series    "场景(销售|合作|催款|招聘)"    邮件序列（4封自动化）
  email.sh template  "类型(感谢|通知|邀请|拒绝|催款)" 邮件模板库
  email.sh subject   "内容描述"                    高打开率主题行生成
  email.sh follow-up "场景(求职|商务|催款|合作)"    催回复邮件序列（3次递进）
  email.sh help                                   显示本帮助

示例：
  email.sh business "王总" "合作方案"
  email.sh followup "上周会议跟进"
  email.sh cold "字节跳动" "技术合作"
  email.sh apology "发货延迟"
  email.sh reply "对方询问报价" --tone formal
EOF
}

cmd_business() {
    local recipient="$1"
    local subject="$2"
    python3 -c "
import sys

date = '${DATE}'
recipient = sys.argv[1]
subject = sys.argv[2]

print('=' * 60)
print('商务邮件模板'.center(60))
print('=' * 60)
print('')
print('【中文版】')
print('')
print('收件人：{}'.format(recipient))
print('主题：关于{} — 合作洽谈'.format(subject))
print('')
print('{}，您好！'.format(recipient))
print('')
print('感谢您百忙之中阅读此邮件。')
print('')
print('我是______（公司名）的______（职位），')
print('就{}事宜，希望与您进一步沟通：'.format(subject))
print('')
print('1. （要点一）')
print('2. （要点二）')
print('3. （要点三）')
print('')
print('如方便，希望能安排一次会议详细讨论。')
print('以下时间我都可以：')
print('  - ')
print('  - ')
print('')
print('期待您的回复。')
print('')
print('此致')
print('敬礼')
print('')
print('______（署名）')
print('______（职位）')
print('______（联系方式）')
print('')
print('-' * 60)
print('')
print('【English Version】')
print('')
print('To: {}'.format(recipient))
print('Subject: Re: {} — Business Proposal'.format(subject))
print('')
print('Dear {},'.format(recipient))
print('')
print('Thank you for taking the time to read this email.')
print('')
print('I am writing to discuss {} and explore potential'.format(subject))
print('collaboration opportunities:')
print('')
print('1. (Key point 1)')
print('2. (Key point 2)')
print('3. (Key point 3)')
print('')
print('Would you be available for a meeting to discuss further?')
print('I am available at the following times:')
print('  - ')
print('  - ')
print('')
print('Looking forward to your reply.')
print('')
print('Best regards,')
print('______')
print('______（Title）')
print('______（Contact）')
print('=' * 60)
" "$recipient" "$subject"
}

cmd_followup() {
    local subject="$1"
    python3 -c "
import sys

date = '${DATE}'
subject = sys.argv[1]

print('=' * 60)
print('跟进邮件模板'.center(60))
print('=' * 60)
print('')
print('【中文版】')
print('')
print('主题：跟进：{}'.format(subject))
print('')
print('您好，')
print('')
print('上次就「{}」的沟通，想跟您确认一下进展：'.format(subject))
print('')
print('1. 上次我们讨论了______')
print('2. 您提到会______')
print('3. 目前的状态是______')
print('')
print('请问是否有更新？如需我这边提供补充材料，')
print('随时告知。')
print('')
print('谢谢！')
print('______')
print('')
print('-' * 60)
print('')
print('【English Version】')
print('')
print('Subject: Follow-up: {}'.format(subject))
print('')
print('Hi,')
print('')
print('I wanted to follow up on our previous discussion')
print('regarding \"{}\".'.format(subject))
print('')
print('1. We discussed ______')
print('2. You mentioned ______')
print('3. Current status: ______')
print('')
print('Any updates on your end? Please let me know if you')
print('need any additional materials from us.')
print('')
print('Thanks,')
print('______')
print('=' * 60)
" "$subject"
}

cmd_cold() {
    local company="$1"
    local purpose="$2"
    python3 -c "
import sys

date = '${DATE}'
company = sys.argv[1]
purpose = sys.argv[2]

print('=' * 60)
print('冷启动邮件模板'.center(60))
print('=' * 60)
print('')
print('【中文版】')
print('')
print('主题：{}方面的合作机会 | ______（你的公司）x {}'.format(purpose, company))
print('')
print('您好，')
print('')
print('冒昧打扰，我是______（你的公司/职位）。')
print('')
print('关注到{}在______领域的出色表现，'.format(company))
print('特别是______方面。')
print('')
print('我们专注于{}，'.format(purpose))
print('相信在以下方面可以产生协同：')
print('')
print('  ✦ （价值点1 — 对对方的好处）')
print('  ✦ （价值点2 — 具体数据/案例）')
print('  ✦ （价值点3 — 差异化优势）')
print('')
print('是否方便用15分钟简单聊聊？')
print('')
print('附上我们的简介供参考：______')
print('')
print('期待交流！')
print('______')
print('')
print('-' * 60)
print('')
print('【English Version】')
print('')
print('Subject: {} Opportunity | ______ x {}'.format(purpose, company))
print('')
print('Hi,')
print('')
print('I hope this email finds you well. My name is ______')
print('from ______ (company).')
print('')
print('I have been following {}\\'s impressive work in ______,'.format(company))
print('particularly in ______ area.')
print('')
print('We specialize in {}, and I believe there are'.format(purpose))
print('synergies in the following areas:')
print('')
print('  - (Value proposition 1)')
print('  - (Value proposition 2)')
print('  - (Value proposition 3)')
print('')
print('Would you have 15 minutes for a quick chat?')
print('')
print('Best,')
print('______')
print('=' * 60)
" "$company" "$purpose"
}

cmd_apology() {
    local reason="$1"
    python3 -c "
import sys

date = '${DATE}'
reason = sys.argv[1]

print('=' * 60)
print('道歉邮件模板'.center(60))
print('=' * 60)
print('')
print('【中文版】')
print('')
print('主题：关于{}的致歉及解决方案'.format(reason))
print('')
print('尊敬的______：')
print('')
print('就「{}」一事，我们深表歉意。'.format(reason))
print('')
print('【事情经过】')
print('  ______（简要说明发生了什么）')
print('')
print('【原因分析】')
print('  ______（坦诚说明原因，不找借口）')
print('')
print('【解决方案】')
print('  1. 立即措施：______')
print('  2. 补偿方案：______')
print('  3. 防止复发：______')
print('')
print('【改进承诺】')
print('  我们已______，确保类似情况不再发生。')
print('')
print('再次为给您带来的不便表示诚挚歉意。')
print('如有任何疑问，请随时联系我。')
print('')
print('此致')
print('敬礼')
print('______')
print('')
print('-' * 60)
print('')
print('【English Version】')
print('')
print('Subject: Our Sincere Apology Regarding {} & Resolution Plan'.format(reason))
print('')
print('Dear ______,')
print('')
print('We sincerely apologize for the issue regarding')
print('\"{}\".'.format(reason))
print('')
print('[What Happened]')
print('  ______ (brief explanation)')
print('')
print('[Root Cause]')
print('  ______ (honest explanation)')
print('')
print('[Resolution]')
print('  1. Immediate action: ______')
print('  2. Compensation: ______')
print('  3. Prevention: ______')
print('')
print('We have taken steps to ensure this does not happen again.')
print('Please do not hesitate to reach out with any concerns.')
print('')
print('Sincerely,')
print('______')
print('=' * 60)
" "$reason"
}

cmd_reply() {
    local original="$1"
    shift
    local tone="formal"
    while [ $# -gt 0 ]; do
        case "$1" in
            --tone) tone="${2:-formal}"; shift 2 ;;
            *) shift ;;
        esac
    done
    python3 -c "
import sys

date = '${DATE}'
original = sys.argv[1]
tone = sys.argv[2]

print('=' * 60)
print('回复邮件模板（{}语气）'.format('正式' if tone == 'formal' else '友好'))
print('=' * 60)
print('')
print('原文摘要：{}'.format(original))
print('')

if tone == 'formal':
    print('【中文版 — 正式】')
    print('')
    print('______，您好！')
    print('')
    print('感谢您的来信。就您提到的「{}」，'.format(original))
    print('回复如下：')
    print('')
    print('1. （针对对方的第一个问题/要点）')
    print('2. （针对对方的第二个问题/要点）')
    print('3. （你的建议/方案）')
    print('')
    print('如有其他问题，欢迎随时沟通。')
    print('')
    print('此致')
    print('敬礼')
    print('______')
else:
    print('【中文版 — 友好】')
    print('')
    print('Hi ______，')
    print('')
    print('收到，关于「{}」：'.format(original))
    print('')
    print('1. （回应要点一）')
    print('2. （回应要点二）')
    print('')
    print('有什么问题随时找我哈～')
    print('')
    print('Best,')
    print('______')

print('')
print('-' * 60)
print('')

if tone == 'formal':
    print('【English — Formal】')
    print('')
    print('Dear ______,')
    print('')
    print('Thank you for your email regarding \"{}\".'.format(original))
    print('Please find my response below:')
    print('')
    print('1. (Response to point 1)')
    print('2. (Response to point 2)')
    print('3. (Your suggestion/proposal)')
    print('')
    print('Please do not hesitate to reach out if you have')
    print('further questions.')
    print('')
    print('Best regards,')
    print('______')
else:
    print('【English — Friendly】')
    print('')
    print('Hi ______,')
    print('')
    print('Thanks for reaching out! Regarding \"{}\": '.format(original))
    print('')
    print('1. (Response to point 1)')
    print('2. (Response to point 2)')
    print('')
    print('Let me know if you have any other questions!')
    print('')
    print('Cheers,')
    print('______')

print('=' * 60)
" "$original" "$tone"
}

# Main dispatch
case "${1:-help}" in
    business)
        [ $# -lt 3 ] && { echo "用法: email.sh business \"收件人\" \"主题\""; exit 1; }
        cmd_business "$2" "$3"
        ;;
    followup)
        [ $# -lt 2 ] && { echo "用法: email.sh followup \"主题\""; exit 1; }
        cmd_followup "$2"
        ;;
    cold)
        [ $# -lt 3 ] && { echo "用法: email.sh cold \"公司\" \"目的\""; exit 1; }
        cmd_cold "$2" "$3"
        ;;
    apology)
        [ $# -lt 2 ] && { echo "用法: email.sh apology \"原因\""; exit 1; }
        cmd_apology "$2"
        ;;
    reply)
        [ $# -lt 2 ] && { echo "用法: email.sh reply \"原文摘要\" [--tone formal|friendly]"; exit 1; }
        original="$2"
        shift 2
        cmd_reply "$original" "$@"
        ;;
    series)
        [ $# -lt 2 ] && { echo "用法: email.sh series \"场景(销售|合作|催款|招聘)\""; exit 1; }
        export EMAIL_SCENE="$2"
        export EMAIL_DATE="$DATE"
        python3 <<'PYEOF'
import os

scene = os.environ.get('EMAIL_SCENE', '')
date = os.environ.get('EMAIL_DATE', '')

scenes = {
    '销售': {
        'name': '销售跟进序列',
        'emails': [
            {
                'stage': '第1封 | 首次触达（Day 0）',
                'subject': '关于[产品/方案]的简短介绍',
                'body': [
                    '您好，',
                    '',
                    '我是______公司的______，专注于______领域。',
                    '',
                    '注意到贵公司在______方面的业务，我们在类似场景中帮助',
                    '______（客户名）实现了______（具体成果）。',
                    '',
                    '想用5分钟和您分享一下，看看是否对贵公司也有价值。',
                    '',
                    '方便的话，这周三或四下午如何？',
                    '',
                    '祝商祺',
                    '______',
                ],
            },
            {
                'stage': '第2封 | 价值跟进（Day 3）',
                'subject': '一个可能对贵公司有帮助的案例',
                'body': [
                    '您好，',
                    '',
                    '上次邮件提到的______方案，补充一个相关案例：',
                    '',
                    '【案例】______公司（与贵司同行业）',
                    '  痛点：______',
                    '  方案：______',
                    '  效果：______（用数据说话）',
                    '',
                    '附上详细案例PDF供参考。',
                    '',
                    '如有兴趣了解更多，随时回复此邮件。',
                    '',
                    '______',
                ],
            },
            {
                'stage': '第3封 | 温和催促（Day 7）',
                'subject': '简短跟进：是否收到之前的邮件？',
                'body': [
                    '您好，',
                    '',
                    '之前发了两封关于______的邮件，不确定是否到达您的收件箱。',
                    '',
                    '简单总结一下核心价值：',
                    '  ✦ [价值点1]',
                    '  ✦ [价值点2]',
                    '',
                    '如果现在不是合适的时机，也完全理解。',
                    '可以告诉我什么时候方便？',
                    '',
                    '______',
                ],
            },
            {
                'stage': '第4封 | 最后通知（Day 14）',
                'subject': '最后一次打扰 — 关于______',
                'body': [
                    '您好，',
                    '',
                    '这是关于______方案的最后一次跟进。',
                    '',
                    '理解您可能非常忙碌，不再继续打扰。',
                    '',
                    '如果将来有需要，随时联系我：',
                    '  📧 ______',
                    '  📱 ______',
                    '',
                    '祝一切顺利！',
                    '______',
                ],
            },
        ],
    },
    '合作': {
        'name': '商务合作序列',
        'emails': [
            {
                'stage': '第1封 | 初次接洽（Day 0）',
                'subject': '合作共赢：______x______',
                'body': [
                    '您好，',
                    '关注到贵公司在______的出色表现。',
                    '我们在______领域有互补优势，期待探讨合作可能。',
                    '附上公司简介供参考。',
                    '______',
                ],
            },
            {
                'stage': '第2封 | 方案跟进（Day 5）',
                'subject': '合作方案初步构想',
                'body': [
                    '您好，',
                    '基于上次邮件提到的合作方向，初步构想了以下方案：',
                    '  方案A：______',
                    '  方案B：______',
                    '是否方便安排一次电话详聊？',
                    '______',
                ],
            },
            {
                'stage': '第3封 | 礼貌催促（Day 10）',
                'subject': '跟进：合作方案',
                'body': [
                    '您好，简短跟进上次的合作构想。',
                    '如有任何疑问或需要调整方向，欢迎告知。',
                    '______',
                ],
            },
            {
                'stage': '第4封 | 温和收尾（Day 20）',
                'subject': '保持联系',
                'body': [
                    '您好，理解贵公司可能有其他优先事项。',
                    '如将来有合作机会，随时联系。',
                    '祝业务蒸蒸日上！',
                    '______',
                ],
            },
        ],
    },
    '催款': {
        'name': '催款邮件序列',
        'emails': [
            {
                'stage': '第1封 | 友好提醒（逾期1天）',
                'subject': '付款提醒：发票#______ 已到期',
                'body': [
                    '您好，',
                    '温馨提醒：发票#______（金额：______元）已于______到期。',
                    '如已付款请忽略，如有疑问请联系我。',
                    '______',
                ],
            },
            {
                'stage': '第2封 | 正式催促（逾期7天）',
                'subject': '第二次提醒：发票#______ 逾期7天',
                'body': [
                    '您好，',
                    '发票#______已逾期7天，金额______元。',
                    '请尽快安排付款。如有任何付款困难，请告知以便协商。',
                    '______',
                ],
            },
            {
                'stage': '第3封 | 严肃通知（逾期15天）',
                'subject': '紧急：发票#______ 逾期15天未付',
                'body': [
                    '您好，',
                    '发票#______已逾期15天。根据合同约定，逾期付款将产生______的滞纳金。',
                    '请在3个工作日内安排付款，否则我们将不得不采取进一步措施。',
                    '______',
                ],
            },
            {
                'stage': '第4封 | 最终通知（逾期30天）',
                'subject': '最终通知：发票#______ 逾期30天',
                'body': [
                    '您好，',
                    '这是关于发票#______的最终付款通知。',
                    '如在5个工作日内未收到付款，我们将按合同约定移交法务处理。',
                    '如需协商付款计划，请立即联系我。',
                    '______',
                ],
            },
        ],
    },
    '招聘': {
        'name': '招聘/求职序列',
        'emails': [
            {
                'stage': '第1封 | 投递申请（Day 0）',
                'subject': '应聘______岗位 — ______',
                'body': [
                    '尊敬的HR/招聘负责人：',
                    '我对贵公司的______岗位非常感兴趣。',
                    '附上简历供参考。核心优势：',
                    '  1. ______',
                    '  2. ______',
                    '期待有机会面谈。',
                    '______',
                ],
            },
            {
                'stage': '第2封 | 状态询问（Day 7）',
                'subject': '跟进：______岗位申请',
                'body': [
                    '您好，上周提交了______岗位的申请。',
                    '想了解一下目前的招聘进度。',
                    '如需要补充任何材料，请告知。',
                    '______',
                ],
            },
            {
                'stage': '第3封 | 面试后感谢（面试当天）',
                'subject': '感谢面试机会 — ______岗位',
                'body': [
                    '您好，感谢今天的面试机会。',
                    '交流中提到的______让我更加期待加入贵公司。',
                    '如有任何后续问题，随时联系我。',
                    '______',
                ],
            },
            {
                'stage': '第4封 | 最终跟进（面试后10天）',
                'subject': '跟进：面试结果',
                'body': [
                    '您好，想了解一下面试结果。',
                    '对这个岗位依然非常感兴趣。',
                    '无论结果如何，感谢贵公司的时间。',
                    '______',
                ],
            },
        ],
    },
}

if scene not in scenes:
    print('可用场景：{}'.format('、'.join(scenes.keys())))
    print('用法: email.sh series "场景"')
    import sys
    sys.exit(1)

s = scenes[scene]
print('=' * 60)
print('{}'.format(s['name']).center(60))
print('=' * 60)
print('')
print('场景：{}'.format(scene))
print('生成日期：{}'.format(date))
print('')

for email in s['emails']:
    print('━' * 60)
    print('📧 {}'.format(email['stage']))
    print('━' * 60)
    print('主题：{}'.format(email['subject']))
    print('')
    for line in email['body']:
        print('  {}'.format(line))
    print('')

print('=' * 60)
print('💡 邮件序列技巧：')
print('  - 每封邮件间隔3-7天，不要太密')
print('  - 每封邮件提供新价值，不要重复内容')
print('  - 4封无回复后停止，避免骚扰')
print('  - 最后一封留下好印象，保持长期关系')
print('=' * 60)
PYEOF
        ;;
    template)
        [ $# -lt 2 ] && { echo "用法: email.sh template \"类型(感谢|道歉|通知|邀请|催款|拒绝)\""; exit 1; }
        export EMAIL_TYPE="$2"
        export EMAIL_DATE="$DATE"
        python3 <<'PYEOF'
import os, sys

etype = os.environ.get('EMAIL_TYPE', '')
date = os.environ.get('EMAIL_DATE', '')

templates = {
    '感谢': {
        'cn_subject': '衷心感谢您的______',
        'cn_body': [
            '______，您好！',
            '',
            '衷心感谢您______（具体感谢的事项）。',
            '',
            '您的______（支持/帮助/指导/合作）对我们意义重大：',
            '  - ______（具体影响1）',
            '  - ______（具体影响2）',
            '',
            '期待未来有更多合作的机会。',
            '',
            '再次感谢！',
            '______',
        ],
        'en_subject': 'Thank You for ______',
        'en_body': [
            'Dear ______,',
            '',
            'I wanted to express my sincere gratitude for ______.',
            '',
            'Your support/help has made a significant impact:',
            '  - (Specific impact 1)',
            '  - (Specific impact 2)',
            '',
            'Looking forward to more opportunities to work together.',
            '',
            'Warmest regards,',
            '______',
        ],
    },
    '通知': {
        'cn_subject': '【通知】关于______的重要通知',
        'cn_body': [
            '各位同事/合作伙伴好，',
            '',
            '特此通知以下事项：',
            '',
            '【事项】______',
            '【生效日期】______',
            '【影响范围】______',
            '',
            '【详细说明】',
            '  1. ______',
            '  2. ______',
            '',
            '【需要您做的】',
            '  □ ______',
            '  □ ______',
            '',
            '如有疑问，请联系______。',
            '',
            '______',
        ],
        'en_subject': '[Notice] Important Update Regarding ______',
        'en_body': [
            'Dear all,',
            '',
            'This is to inform you about the following:',
            '',
            'Subject: ______',
            'Effective Date: ______',
            'Impact: ______',
            '',
            'Details:',
            '  1. ______',
            '  2. ______',
            '',
            'Action Required:',
            '  - ______',
            '',
            'For questions, please contact ______.',
            '',
            'Best regards,',
            '______',
        ],
    },
    '邀请': {
        'cn_subject': '诚邀参加：______',
        'cn_body': [
            '______，您好！',
            '',
            '诚挚邀请您参加我们的______活动。',
            '',
            '📅 时间：______',
            '📍 地点：______',
            '👥 参加人员：______',
            '📋 议程/流程：______',
            '',
            '本次活动亮点：',
            '  ✦ ______',
            '  ✦ ______',
            '',
            '请在______前回复确认是否参加。',
            '',
            '期待与您见面！',
            '______',
        ],
        'en_subject': 'Invitation: ______',
        'en_body': [
            'Dear ______,',
            '',
            'You are cordially invited to ______.',
            '',
            'Date: ______',
            'Venue: ______',
            'Agenda: ______',
            '',
            'Please RSVP by ______.',
            '',
            'We look forward to seeing you!',
            '______',
        ],
    },
    '拒绝': {
        'cn_subject': '关于______的回复',
        'cn_body': [
            '______，您好！',
            '',
            '感谢您的______（提议/邀请/申请）。',
            '经过认真考虑，遗憾地告知您，我们暂时无法______。',
            '',
            '【原因】',
            '  ______（坦诚但不伤害对方）',
            '',
            '【替代建议】',
            '  - ______（如果有的话）',
            '',
            '希望这不会影响我们的合作关系。',
            '如果将来有合适的机会，很乐意重新探讨。',
            '',
            '祝好',
            '______',
        ],
        'en_subject': 'Regarding Your ______',
        'en_body': [
            'Dear ______,',
            '',
            'Thank you for your ______ (proposal/invitation/application).',
            'After careful consideration, we regret to inform you that',
            'we are unable to ______ at this time.',
            '',
            'Reason: ______',
            '',
            'Alternative suggestion: ______',
            '',
            'We hope this does not affect our relationship.',
            '',
            'Best regards,',
            '______',
        ],
    },
    '催款': {
        'cn_subject': '付款提醒：发票#______',
        'cn_body': [
            '______，您好！',
            '',
            '温馨提醒，以下款项已到期/即将到期：',
            '',
            '  发票号：______',
            '  金  额：人民币 ______ 元',
            '  到期日：______',
            '  合同号：______',
            '',
            '请尽快安排付款。如已付款请忽略此提醒。',
            '',
            '付款方式：',
            '  户名：______',
            '  账号：______',
            '  开户行：______',
            '',
            '如有任何疑问，请联系______。',
            '',
            '______',
        ],
        'en_subject': 'Payment Reminder: Invoice #______',
        'en_body': [
            'Dear ______,',
            '',
            'This is a friendly reminder regarding:',
            '',
            '  Invoice: #______',
            '  Amount: ______',
            '  Due Date: ______',
            '',
            'Please arrange payment at your earliest convenience.',
            '',
            'Best regards,',
            '______',
        ],
    },
}

if etype not in templates:
    print('可用模板类型：{}'.format('、'.join(templates.keys())))
    sys.exit(1)

t = templates[etype]
print('=' * 60)
print('{}邮件模板'.format(etype).center(60))
print('=' * 60)
print('')
print('【中文版】')
print('')
print('主题：{}'.format(t['cn_subject']))
print('')
for line in t['cn_body']:
    print('  {}'.format(line))
print('')
print('-' * 60)
print('')
print('【English Version】')
print('')
print('Subject: {}'.format(t['en_subject']))
print('')
for line in t['en_body']:
    print('  {}'.format(line))
print('')
print('=' * 60)
PYEOF
        ;;
    subject)
        [ $# -lt 2 ] && { echo "用法: email.sh subject \"邮件内容描述\""; exit 1; }
        export EMAIL_CONTENT="$2"
        export EMAIL_DATE="$DATE"
        python3 <<'PYEOF'
import os

content = os.environ.get('EMAIL_CONTENT', '')
date = os.environ.get('EMAIL_DATE', '')

print('=' * 60)
print('高打开率邮件主题行'.center(60))
print('=' * 60)
print('')
print('邮件内容：{}'.format(content))
print('')

styles = [
    {
        'name': '🎯 直接明了型',
        'cn': '关于{} — 需要您的确认'.format(content),
        'en': 'Re: {} — Your Input Needed'.format(content),
        'tip': '适合：内部邮件、明确需要对方行动时',
    },
    {
        'name': '❓ 好奇驱动型',
        'cn': '{}的3个关键变化，您了解吗？'.format(content),
        'en': '3 Key Changes in {} You Should Know'.format(content),
        'tip': '适合：Newsletter、行业分享、冷启动邮件',
    },
    {
        'name': '📊 数据说服型',
        'cn': '{}：最新数据显示惊人趋势'.format(content),
        'en': '{}: New Data Reveals Surprising Trends'.format(content),
        'tip': '适合：报告、调研结果、B2B销售',
    },
    {
        'name': '⏰ 紧迫感型',
        'cn': '【重要】{}的截止日期临近'.format(content),
        'en': '[Action Required] {} Deadline Approaching'.format(content),
        'tip': '适合：催促、限时优惠、重要通知（不要滥用）',
    },
    {
        'name': '🤝 个人化型',
        'cn': '______，关于{}我有个想法想和您聊聊'.format(content),
        'en': '______, Quick thought on {} I\'d love to share'.format(content),
        'tip': '适合：一对一沟通、建立关系、高管邮件',
    },
]

for i, s in enumerate(styles, 1):
    print('{}. {}'.format(i, s['name']))
    print('   中文：{}'.format(s['cn']))
    print('   英文：{}'.format(s['en']))
    print('   💡 {}'.format(s['tip']))
    print('')

print('-' * 60)
print('📌 主题行写作要点：')
print('  1. 控制在50字符以内（移动端显示限制）')
print('  2. 把最重要的词放在前面')
print('  3. 避免全大写和过多感叹号（容易进垃圾箱）')
print('  4. 使用数字比文字更吸引眼球')
print('  5. 个人化（加入对方名字）可提升29%打开率')
print('  6. A/B测试：准备2-3个版本，选效果最好的')
print('=' * 60)
PYEOF
        ;;
    follow-up)
        [ $# -lt 2 ] && { echo "用法: email.sh follow-up \"场景(求职|商务|催款|合作)\""; exit 1; }
        export FOLLOWUP_SCENE="$2"
        export EMAIL_DATE="$DATE"
        python3 << 'PYEOF'
import os

scene = os.environ.get('FOLLOWUP_SCENE', '')
date = os.environ.get('EMAIL_DATE', '')

scenes = {
    '求职': {
        'name': '求职催回复序列',
        'context': '投递简历或面试后没有收到回复',
        'emails': [
            {
                'stage': '第1封 | 友善跟进（投递/面试后3-5天）',
                'tone': '☺️ 礼貌+热情',
                'cn_subject': '跟进：______岗位申请 — ______（姓名）',
                'cn_body': [
                    '尊敬的HR/面试官，您好！',
                    '',
                    '上周向贵公司投递了______岗位的简历，想礼貌地跟进一下申请进展。',
                    '',
                    '我对这个岗位非常感兴趣，尤其是______方面与我的经验高度匹配：',
                    '  • ______（核心优势1）',
                    '  • ______（核心优势2）',
                    '',
                    '如果需要补充任何材料，我随时可以提供。',
                    '',
                    '感谢您百忙之中的关注！',
                    '______',
                ],
                'en_subject': 'Following Up: Application for ______ Position',
                'en_body': [
                    'Dear Hiring Manager,',
                    '',
                    'I wanted to follow up on my application for the ______ position',
                    'submitted last week.',
                    '',
                    'I remain very enthusiastic about this opportunity, particularly',
                    'because my experience in ______ aligns well with your requirements.',
                    '',
                    'Please let me know if you need any additional materials.',
                    '',
                    'Thank you for your time and consideration.',
                    'Best regards,',
                    '______',
                ],
            },
            {
                'stage': '第2封 | 正式跟进（第1封后5-7天）',
                'tone': '📋 专业+提供新价值',
                'cn_subject': '再次跟进：______岗位 — 附加项目案例',
                'cn_body': [
                    '您好，',
                    '',
                    '之前就______岗位的申请做过一次跟进，理解贵公司可能正在',
                    '繁忙的招聘流程中。',
                    '',
                    '补充分享一个与该岗位相关的项目经验：',
                    '  项目：______',
                    '  我的角色：______',
                    '  成果：______（用数据量化）',
                    '',
                    '相信这个经验能很好地迁移到贵公司的业务场景中。',
                    '',
                    '如有任何消息，请随时告知。',
                    '______',
                ],
                'en_subject': 'Re: ______ Position — Additional Portfolio',
                'en_body': [
                    'Hi,',
                    '',
                    'Following up on my previous email regarding the ______ position.',
                    '',
                    'I wanted to share an additional project that is highly relevant:',
                    '  Project: ______',
                    '  My role: ______',
                    '  Results: ______ (quantified)',
                    '',
                    'I believe this experience would translate well to your team.',
                    '',
                    'Looking forward to hearing from you.',
                    '______',
                ],
            },
            {
                'stage': '第3封 | 最终跟进（第2封后7-10天）',
                'tone': '🤝 优雅收尾+保持关系',
                'cn_subject': '关于______岗位的最后跟进',
                'cn_body': [
                    '您好，',
                    '',
                    '这是关于______岗位申请的最后一次跟进。',
                    '',
                    '完全理解招聘过程需要时间，如果目前该岗位已有合适人选，',
                    '也真心为贵公司感到高兴。',
                    '',
                    '如果将来有合适的机会，非常希望能有合作的可能。',
                    '我的联系方式：______',
                    '',
                    '无论结果如何，感谢贵公司的时间和考虑！',
                    '祝贵公司业务蒸蒸日上。',
                    '',
                    '______',
                ],
                'en_subject': 'Final Follow-up: ______ Position',
                'en_body': [
                    'Hi,',
                    '',
                    'This is my final follow-up regarding the ______ position.',
                    '',
                    'I completely understand the hiring process takes time.',
                    'If the position has been filled, I wish you and the team',
                    'all the best.',
                    '',
                    'Should any suitable opportunities arise in the future,',
                    'I would love to be considered. My contact: ______',
                    '',
                    'Thank you for your time and consideration.',
                    'Best wishes,',
                    '______',
                ],
            },
        ],
    },
    '商务': {
        'name': '商务催回复序列',
        'context': '发送了合作提议/方案后没有回复',
        'emails': [
            {
                'stage': '第1封 | 友善提醒（发送后3天）',
                'tone': '☺️ 轻松+提供价值',
                'cn_subject': '快速跟进：关于______的合作方案',
                'cn_body': [
                    '______，您好！',
                    '',
                    '上次发送了关于______的合作方案，想确认您是否收到。',
                    '',
                    '补充一个小信息：我们最近刚帮______（类似客户）',
                    '在______方面取得了______的成果，详情可以分享给您参考。',
                    '',
                    '方便的话，这周是否有15分钟简单聊聊？',
                    '',
                    '______',
                ],
                'en_subject': 'Quick Follow-up: ______ Proposal',
                'en_body': [
                    'Hi ______,',
                    '',
                    'Just a quick follow-up on the ______ proposal I sent over.',
                    '',
                    'Quick update: we recently helped ______ (similar client)',
                    'achieve ______ results in this area.',
                    '',
                    'Would you have 15 minutes this week for a brief chat?',
                    '',
                    'Best,',
                    '______',
                ],
            },
            {
                'stage': '第2封 | 正式跟进（第1封后5天）',
                'tone': '📋 专业+直接',
                'cn_subject': '跟进：______合作方案 — 是否需要调整方向？',
                'cn_body': [
                    '______，您好！',
                    '',
                    '之前发了两次关于______的沟通邮件，想了解一下您的想法。',
                    '',
                    '完全理解您可能非常忙碌。方便的话，告诉我：',
                    '  A. 感兴趣，但现在不是好时机 → 我稍后再联系',
                    '  B. 需要调整方案方向 → 我可以重新定制',
                    '  C. 目前没有需求 → 完全理解',
                    '',
                    '一个字母的回复就够了 :)',
                    '',
                    '______',
                ],
                'en_subject': 'Re: ______ — Shall We Adjust the Approach?',
                'en_body': [
                    'Hi ______,',
                    '',
                    'Following up on my previous emails. Totally understand',
                    'you may be busy.',
                    '',
                    'A quick reply would be helpful:',
                    '  A. Interested but bad timing',
                    '  B. Need a different approach',
                    '  C. Not a fit right now',
                    '',
                    'A one-letter reply works perfectly :)',
                    '',
                    '______',
                ],
            },
            {
                'stage': '第3封 | 优雅收尾（第2封后7天）',
                'tone': '🤝 不卑不亢+留后路',
                'cn_subject': '最后跟进 — 保持联系',
                'cn_body': [
                    '______，您好！',
                    '',
                    '这是关于______方案的最后一次跟进，不再打扰。',
                    '',
                    '如果将来有需要，随时联系我：',
                    '  📧 ______',
                    '  📱 ______',
                    '',
                    '祝工作顺利，事业有成！',
                    '______',
                ],
                'en_subject': 'Closing the Loop — Staying in Touch',
                'en_body': [
                    'Hi ______,',
                    '',
                    'This will be my last follow-up. No hard feelings at all.',
                    '',
                    'If things change in the future, feel free to reach out:',
                    '  Email: ______',
                    '  Phone: ______',
                    '',
                    'Wishing you all the best!',
                    '______',
                ],
            },
        ],
    },
    '催款': {
        'name': '催款跟进序列',
        'context': '发票到期后对方未付款',
        'emails': [
            {
                'stage': '第1封 | 友善提醒（逾期1-3天）',
                'tone': '☺️ 温和+理解',
                'cn_subject': '温馨提醒：发票#______ 已到期',
                'cn_body': [
                    '______，您好！',
                    '',
                    '温馨提醒：以下款项已到期，可能是遗漏了：',
                    '  发票号：______',
                    '  金额：______元',
                    '  到期日：______',
                    '',
                    '如已安排付款请忽略此邮件。',
                    '如有任何疑问，随时联系我。',
                    '',
                    '谢谢！',
                    '______',
                ],
                'en_subject': 'Friendly Reminder: Invoice #______ Past Due',
                'en_body': [
                    'Hi ______,',
                    '',
                    'A friendly reminder that the following invoice is past due:',
                    '  Invoice: #______',
                    '  Amount: ______',
                    '  Due: ______',
                    '',
                    'If already processed, please disregard.',
                    '',
                    'Thanks,',
                    '______',
                ],
            },
            {
                'stage': '第2封 | 正式催促（逾期7-10天）',
                'tone': '📋 正式+明确',
                'cn_subject': '第二次提醒：发票#______ 逾期7天',
                'cn_body': [
                    '______，您好！',
                    '',
                    '发票#______已逾期7天，金额______元。',
                    '',
                    '请优先安排处理。如有付款困难，',
                    '我们可以协商分期付款方案。',
                    '',
                    '请在3个工作日内确认付款计划。',
                    '',
                    '______',
                ],
                'en_subject': 'Second Notice: Invoice #______ — 7 Days Overdue',
                'en_body': [
                    'Dear ______,',
                    '',
                    'Invoice #______ is now 7 days overdue (Amount: ______).',
                    '',
                    'Please prioritize this payment. If there are difficulties,',
                    'we are open to discussing a payment plan.',
                    '',
                    'Please confirm within 3 business days.',
                    '',
                    '______',
                ],
            },
            {
                'stage': '第3封 | 最终通知（逾期15-30天）',
                'tone': '⚠️ 严肃+后果告知',
                'cn_subject': '【紧急】最终付款通知 — 发票#______',
                'cn_body': [
                    '______，您好！',
                    '',
                    '发票#______已逾期超过15天，这是最终付款通知。',
                    '',
                    '根据合同约定：',
                    '  • 逾期将产生每日______的滞纳金',
                    '  • 超过30天未付将暂停相关服务',
                    '  • 我们将保留通过法律途径追讨的权利',
                    '',
                    '请在5个工作日内完成付款或联系我协商。',
                    '',
                    '希望尽快妥善解决此事。',
                    '______',
                ],
                'en_subject': '[URGENT] Final Payment Notice — Invoice #______',
                'en_body': [
                    'Dear ______,',
                    '',
                    'This is a final notice for Invoice #______, now 15+ days overdue.',
                    '',
                    'Per our agreement:',
                    '  - Late fees of ______ per day will apply',
                    '  - Services may be suspended after 30 days',
                    '  - We reserve the right to pursue legal remedies',
                    '',
                    'Please settle within 5 business days or contact me.',
                    '',
                    '______',
                ],
            },
        ],
    },
    '合作': {
        'name': '合作邀约催回复序列',
        'context': '发送合作邀请后对方未回复',
        'emails': [
            {
                'stage': '第1封 | 友善跟进（发送后3天）',
                'tone': '☺️ 轻松+补充价值',
                'cn_subject': '跟进：______合作邀请',
                'cn_body': [
                    '您好！',
                    '',
                    '上次发了一封关于合作的邮件，不确定是否到达收件箱。',
                    '',
                    '简单补充一下合作亮点：',
                    '  ✦ 双方用户画像高度重合',
                    '  ✦ 预期带来______的增长',
                    '  ✦ 已有______成功合作案例',
                    '',
                    '15分钟电话聊聊？我的时间很灵活。',
                    '',
                    '______',
                ],
                'en_subject': 'Following Up: Partnership Opportunity',
                'en_body': [
                    'Hi,',
                    '',
                    'Just following up on the partnership idea I shared.',
                    '',
                    'Quick highlights:',
                    '  - Strong audience overlap',
                    '  - Expected ______ growth potential',
                    '  - ______ successful case studies',
                    '',
                    '15-minute call? My schedule is flexible.',
                    '',
                    '______',
                ],
            },
            {
                'stage': '第2封 | 换角度跟进（第1封后5天）',
                'tone': '📋 新角度+降低门槛',
                'cn_subject': '换个角度：也许我们可以先从小项目开始？',
                'cn_body': [
                    '您好！',
                    '',
                    '理解全面合作可能需要更多考虑。',
                    '',
                    '不如先从一个小项目试水？',
                    '  比如：______（一个低成本、低风险的合作方式）',
                    '',
                    '先跑通一个小闭环，效果好再深入合作。',
                    '',
                    '这样是否更容易推进？',
                    '______',
                ],
                'en_subject': 'Alternative: Start Small?',
                'en_body': [
                    'Hi,',
                    '',
                    'Totally understand if a full partnership needs more thought.',
                    '',
                    'How about starting with a small pilot?',
                    '  e.g., ______ (low-cost, low-risk collaboration)',
                    '',
                    'Would this be easier to move forward with?',
                    '',
                    '______',
                ],
            },
            {
                'stage': '第3封 | 优雅收尾（第2封后7天）',
                'tone': '🤝 留门+保持联系',
                'cn_subject': '保持联系 — 期待未来合作',
                'cn_body': [
                    '您好！',
                    '',
                    '看起来现在可能不是合作的最佳时机，完全理解。',
                    '',
                    '我会持续关注贵公司的发展。',
                    '如果将来时机成熟，随时联系我：______',
                    '',
                    '祝事业顺利！',
                    '______',
                ],
                'en_subject': 'Staying Connected — Future Opportunities',
                'en_body': [
                    'Hi,',
                    '',
                    'Seems like the timing may not be right, and that is fine.',
                    '',
                    'I will keep following your work.',
                    'If things change, feel free to reach out: ______',
                    '',
                    'Wishing you continued success!',
                    '______',
                ],
            },
        ],
    },
}

if scene not in scenes:
    print('可用场景：{}'.format('、'.join(scenes.keys())))
    print('用法: email.sh follow-up "场景"')
    import sys
    sys.exit(1)

s = scenes[scene]
print('=' * 60)
print('  📧 {} — 催回复邮件序列（3次递进）'.format(s['name']))
print('=' * 60)
print('')
print('  场景：{}'.format(s['context']))
print('  策略：友善提醒 → 正式跟进 → 优雅收尾')
print('  生成日期：{}'.format(date))
print('')

for i, email in enumerate(s['emails'], 1):
    print('━' * 60)
    print('  {} {}'.format(email['stage'], email['tone']))
    print('━' * 60)
    print('')
    print('  【中文版】')
    print('  主题：{}'.format(email['cn_subject']))
    print('')
    for line in email['cn_body']:
        print('    {}'.format(line))
    print('')
    print('  【English】')
    print('  Subject: {}'.format(email['en_subject']))
    print('')
    for line in email['en_body']:
        print('    {}'.format(line))
    print('')

print('=' * 60)
print('💡 催回复核心技巧：')
print('  1. 间隔3-7天，不要每天催（会被拉黑）')
print('  2. 每封提供新价值，不要只说"请回复"')
print('  3. 3封无回复就停止，保留好印象')
print('  4. 降低对方回复门槛（给选项，一个字母就行）')
print('  5. 最后一封永远留门，保持长期关系')
print('=' * 60)
PYEOF
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "未知命令: $1"
        show_help
        exit 1
        ;;
esac

echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
