# -*- coding: utf-8 -*-
"""doc-summarizer core — extractive summarization, keyword extraction, comparison."""
from __future__ import print_function
import sys
import re
import collections
import math

def read_file(path):
    with open(path, 'r', encoding='utf-8', errors='replace') as f:
        return f.read()

# ── sentence splitting (handles Chinese + English) ──

def split_sentences(text):
    """Split text into sentences using punctuation."""
    # Use findall to grab sentence-like chunks
    sentences = re.findall(r'[^。！？!?.]+[。！？!?.]?', text)
    result = []
    for s in sentences:
        s = s.strip()
        if s:
            result.append(s)
    # If still got nothing useful, try newline-based
    if len(result) <= 1 and '\n' in text:
        parts = text.split('\n')
        result = [p.strip() for p in parts if p.strip()]
    return result

# ── word/token counting ──

def count_words(text):
    """Count Chinese chars + English words."""
    chinese = re.findall(u'[\u4e00-\u9fff]', text)
    english = re.findall(r'[a-zA-Z]+', text)
    return len(chinese) + len(english)

def count_chars(text):
    return len(re.sub(r'\s', '', text))

# ── simple extractive summarizer ──

STOPWORDS = set([
    'the','a','an','is','are','was','were','be','been',
    'being','have','has','had','do','does','did','will',
    'would','could','should','may','might','shall','can',
    'to','of','in','for','on','with','at','by','from',
    'as','into','through','during','before','after',
    'and','but','or','nor','not','so','yet','both',
    'either','neither','each','every','all','any','few',
    'more','most','other','some','such','no','only',
    'own','same','than','too','very','just','because',
    'if','when','while','about','between','under','above',
    'it','its','this','that','these','those','i','me',
    'my','we','our','you','your','he','him','his','she',
    'her','they','them','their','what','which','who',
    'whom','how','where','there','then','here',
])

ZH_STOPWORDS = set([
    u'\u7684', u'\u4e86', u'\u5728', u'\u662f', u'\u6211',
    u'\u6709', u'\u548c', u'\u5c31', u'\u4e0d', u'\u4eba',
    u'\u90fd', u'\u4e00', u'\u4e00\u4e2a', u'\u4e0a', u'\u4e5f',
    u'\u5f88', u'\u5230', u'\u8bf4', u'\u8981', u'\u53bb',
    u'\u4f60', u'\u4f1a', u'\u7740', u'\u6ca1\u6709', u'\u770b',
    u'\u597d', u'\u81ea\u5df1', u'\u8fd9',
])

def tokenize(text):
    """Extract Chinese bigrams and English words."""
    tokens = []
    # English words
    for m in re.finditer(r'[a-zA-Z]+', text):
        w = m.group().lower()
        if w not in STOPWORDS and len(w) >= 3:
            tokens.append(w)
    # Chinese: extract bigrams (2-char sequences)
    chinese_chars = re.findall(u'[\u4e00-\u9fff]+', text)
    for run in chinese_chars:
        for i in range(len(run) - 1):
            bigram = run[i:i+2]
            if bigram not in ZH_STOPWORDS:
                tokens.append(bigram)
    return tokens

def score_sentences(sentences):
    """Score sentences by word frequency (TF-based)."""
    all_tokens = []
    for s in sentences:
        all_tokens.extend(tokenize(s))
    freq = collections.Counter(all_tokens)

    scored = []
    for i, s in enumerate(sentences):
        tokens = tokenize(s)
        if not tokens:
            scored.append((i, 0.0))
            continue
        score = sum(freq.get(t, 0) for t in tokens) / (len(tokens) + 1.0)
        # Position boost: earlier sentences get a slight boost
        position_boost = 1.0 / (1.0 + 0.1 * i)
        scored.append((i, score * (1.0 + 0.3 * position_boost)))
    return scored

def summarize(text, ratio=0.3, min_sentences=2, max_sentences=10):
    sentences = split_sentences(text)
    if len(sentences) <= min_sentences:
        return text.strip()
    scored = score_sentences(sentences)
    n = max(min_sentences, min(max_sentences, int(math.ceil(len(sentences) * ratio))))
    top = sorted(scored, key=lambda x: x[1], reverse=True)[:n]
    # Restore original order
    top_sorted = sorted(top, key=lambda x: x[0])
    return '\n'.join(sentences[i] for i, _ in top_sorted)

def extract_bullets(text, max_bullets=12):
    sentences = split_sentences(text)
    if not sentences:
        return '(no content)'
    scored = score_sentences(sentences)
    n = min(max_bullets, max(3, len(sentences) // 3))
    top = sorted(scored, key=lambda x: x[1], reverse=True)[:n]
    top_sorted = sorted(top, key=lambda x: x[0])
    lines = []
    for idx, (i, _) in enumerate(top_sorted):
        lines.append('  {num}. {sent}'.format(num=idx + 1, sent=sentences[i]))
    return '\n'.join(lines)

def extract_keywords(text, top_n=15):
    tokens = tokenize(text)
    freq = collections.Counter(tokens)
    top = freq.most_common(top_n)
    if not top:
        return '(no keywords found)'
    lines = []
    for word, count in top:
        lines.append('  - {w}  (x{c})'.format(w=word, c=count))
    return '\n'.join(lines)

def compare_docs(text1, text2):
    tokens1 = set(tokenize(text1))
    tokens2 = set(tokenize(text2))
    common = tokens1 & tokens2
    only1 = tokens1 - tokens2
    only2 = tokens2 - tokens1
    union = tokens1 | tokens2
    if len(union) > 0:
        similarity = len(common) * 100.0 / len(union)
    else:
        similarity = 0.0

    wc1 = count_words(text1)
    wc2 = count_words(text2)

    lines = []
    lines.append('=== Document Comparison ===')
    lines.append('')
    lines.append('Document 1: {n} words'.format(n=wc1))
    lines.append('Document 2: {n} words'.format(n=wc2))
    lines.append('Vocabulary overlap: {p:.1f}%'.format(p=similarity))
    lines.append('')
    common_list = sorted(common)[:20]
    lines.append('Common key terms ({n}):'.format(n=len(common_list)))
    for w in common_list:
        lines.append('  - {w}'.format(w=w))
    lines.append('')
    only1_list = sorted(only1)[:15]
    lines.append('Unique to Document 1 ({n}):'.format(n=len(only1_list)))
    for w in only1_list:
        lines.append('  - {w}'.format(w=w))
    lines.append('')
    only2_list = sorted(only2)[:15]
    lines.append('Unique to Document 2 ({n}):'.format(n=len(only2_list)))
    for w in only2_list:
        lines.append('  - {w}'.format(w=w))

    lines.append('')
    lines.append('--- Summary of Doc 1 ---')
    lines.append(summarize(text1, ratio=0.25, max_sentences=5))
    lines.append('')
    lines.append('--- Summary of Doc 2 ---')
    lines.append(summarize(text2, ratio=0.25, max_sentences=5))

    return '\n'.join(lines)

def do_wordcount(text):
    wc = count_words(text)
    cc = count_chars(text)
    sentences = split_sentences(text)
    lines_count = text.count('\n') + 1

    # Reading speed heuristic
    chinese_chars = len(re.findall(u'[\u4e00-\u9fff]', text))
    if chinese_chars > wc * 0.3:
        read_min = cc / 500.0
        speed_note = '~500 chars/min for Chinese'
    else:
        read_min = wc / 250.0
        speed_note = '~250 words/min for English'

    lines = []
    lines.append('=== Word Count & Reading Time ===')
    lines.append('')
    lines.append('Words (EN words + ZH chars): {n}'.format(n=wc))
    lines.append('Characters (non-space):      {n}'.format(n=cc))
    lines.append('Sentences:                   {n}'.format(n=len(sentences)))
    lines.append('Lines:                       {n}'.format(n=lines_count))
    lines.append('')
    if read_min < 1:
        lines.append('Estimated reading time: <1 minute ({note})'.format(note=speed_note))
    else:
        lines.append('Estimated reading time: ~{m} min ({note})'.format(
            m=int(math.ceil(read_min)), note=speed_note))
    return '\n'.join(lines)

# ── translate: bilingual summary with key terms ──

def detect_lang(text):
    """Detect dominant language: 'zh' or 'en'."""
    zh_chars = len(re.findall(u'[\u4e00-\u9fff]', text))
    en_words = len(re.findall(r'[a-zA-Z]+', text))
    return 'zh' if zh_chars > en_words else 'en'

def do_translate(text, target_lang='auto'):
    sentences = split_sentences(text)
    src_lang = detect_lang(text)

    if target_lang == 'auto':
        target_lang = 'en' if src_lang == 'zh' else 'cn'

    summary_text = summarize(text, ratio=0.4, min_sentences=2, max_sentences=8)
    kw_tokens = tokenize(text)
    freq = collections.Counter(kw_tokens)
    top_kw = freq.most_common(10)

    lines = []
    lines.append(u'=' * 60)
    lines.append(u'  \U0001f310  翻译摘要 / Translation Summary')
    lines.append(u'=' * 60)
    lines.append(u'')
    lines.append(u'源语言 (Source): {}'.format('中文' if src_lang == 'zh' else 'English'))
    lines.append(u'目标语言 (Target): {}'.format('English' if target_lang == 'en' else '中文'))
    lines.append(u'原文字数: {}'.format(count_words(text)))
    lines.append(u'')
    lines.append(u'-' * 50)
    lines.append(u'  📄 原文核心摘要')
    lines.append(u'-' * 50)
    lines.append(u'')
    lines.append(summary_text)
    lines.append(u'')
    lines.append(u'-' * 50)
    if target_lang == 'en':
        lines.append(u'  🔄 Translation Notes (ZH → EN)')
    else:
        lines.append(u'  🔄 翻译说明 (EN → ZH)')
    lines.append(u'-' * 50)
    lines.append(u'')
    if target_lang == 'en':
        lines.append(u'[NOTE] The following key terms should be translated with care:')
    else:
        lines.append(u'[注意] 以下关键术语需精确翻译:')
    lines.append(u'')
    for kw, cnt in top_kw:
        lines.append(u'  • {}  (出现 {}次)'.format(kw, cnt))
    lines.append(u'')
    lines.append(u'-' * 50)
    lines.append(u'  💡 翻译建议')
    lines.append(u'-' * 50)
    lines.append(u'')
    if target_lang == 'en':
        lines.append(u'  1. 保留专有名词原文，首次出现时附英文释义')
        lines.append(u'  2. 长句拆分为短句，符合英文表达习惯')
        lines.append(u'  3. 被动语态转主动语态')
        lines.append(u'  4. 数据和数字保持一致')
    else:
        lines.append(u'  1. 专业术语使用中文通用译法，首次出现附原文')
        lines.append(u'  2. 英文长从句拆解为中文短句')
        lines.append(u'  3. 主动语态优先')
        lines.append(u'  4. 保留原文数据引用')
    lines.append(u'')
    return '\n'.join(lines)

# ── meeting: structured meeting minutes extraction ──

def do_meeting(text):
    sentences = split_sentences(text)
    wc = count_words(text)

    # Heuristic extraction: find action items, decisions, deadlines
    action_patterns = [
        re.compile(u'(需要|要求|负责|跟进|完成|提交|准备|确认|安排|落实|推进|执行|处理|解决|制定|更新|检查|审核|通知)'),
        re.compile(r'(action|todo|follow.?up|assign|deadline|complete|submit|prepare|review|update)', re.IGNORECASE),
    ]
    decision_patterns = [
        re.compile(u'(决定|同意|确定|通过|批准|决议|一致|共识|明确|定下|结论|最终)'),
        re.compile(r'(decide|agree|approve|resolve|conclude|final|consensus)', re.IGNORECASE),
    ]
    date_pattern = re.compile(r'(\d{1,4}[-/\.]\d{1,2}[-/\.]\d{1,4}|\d{1,2}月\d{1,2}[日号]|(?:周|星期)[一二三四五六日天]|(?:下周|本周|明天|后天|月底|季末|年底)|(?:before|by|due|until)\s+\w+)', re.IGNORECASE)

    action_items = []
    decisions = []
    discussion_points = []
    deadlines_found = []

    for s in sentences:
        s_stripped = s.strip()
        if not s_stripped:
            continue
        is_action = any(p.search(s_stripped) for p in action_patterns)
        is_decision = any(p.search(s_stripped) for p in decision_patterns)
        date_match = date_pattern.search(s_stripped)

        if is_decision:
            decisions.append(s_stripped)
            if date_match:
                deadlines_found.append((s_stripped, date_match.group()))
        elif is_action:
            action_items.append(s_stripped)
            if date_match:
                deadlines_found.append((s_stripped, date_match.group()))
        else:
            discussion_points.append(s_stripped)

    # If nothing was categorized, use scoring to distribute
    if not decisions and not action_items:
        scored = score_sentences(sentences)
        scored_sorted = sorted(scored, key=lambda x: x[1], reverse=True)
        n = len(scored_sorted)
        for rank, (i, sc) in enumerate(scored_sorted):
            s_stripped = sentences[i].strip()
            if not s_stripped:
                continue
            if rank < max(1, n // 4):
                decisions.append(s_stripped)
            elif rank < max(2, n // 2):
                action_items.append(s_stripped)
            else:
                discussion_points.append(s_stripped)

    lines = []
    lines.append(u'=' * 60)
    lines.append(u'  📋  会议纪要 / Meeting Minutes')
    lines.append(u'=' * 60)
    lines.append(u'')
    lines.append(u'生成时间: {}'.format(__import__('datetime').datetime.now().strftime('%Y-%m-%d %H:%M')))
    lines.append(u'原文字数: {} 字'.format(wc))
    lines.append(u'')

    # Overview summary
    lines.append(u'-' * 50)
    lines.append(u'  📌 会议概要')
    lines.append(u'-' * 50)
    overview = summarize(text, ratio=0.2, min_sentences=1, max_sentences=3)
    lines.append(u'')
    lines.append(overview)
    lines.append(u'')

    # Decisions
    lines.append(u'-' * 50)
    lines.append(u'  ✅ 决议事项 ({} 条)'.format(len(decisions)))
    lines.append(u'-' * 50)
    lines.append(u'')
    if decisions:
        for i, d in enumerate(decisions, 1):
            lines.append(u'  {}. {}'.format(i, d))
    else:
        lines.append(u'  (未检测到明确决议)')
    lines.append(u'')

    # Action items
    lines.append(u'-' * 50)
    lines.append(u'  🎯 行动项 / Action Items ({} 条)'.format(len(action_items)))
    lines.append(u'-' * 50)
    lines.append(u'')
    if action_items:
        for i, a in enumerate(action_items, 1):
            date_m = date_pattern.search(a)
            deadline_str = u' ⏰ 截止: {}'.format(date_m.group()) if date_m else ''
            lines.append(u'  {}. {}{}'.format(i, a, deadline_str))
    else:
        lines.append(u'  (未检测到行动项)')
    lines.append(u'')

    # Deadlines summary
    if deadlines_found:
        lines.append(u'-' * 50)
        lines.append(u'  ⏰ 关键时间节点')
        lines.append(u'-' * 50)
        lines.append(u'')
        seen = set()
        for item_text, dl in deadlines_found:
            if dl not in seen:
                seen.add(dl)
                short = item_text[:60] + '...' if len(item_text) > 60 else item_text
                lines.append(u'  • {} → {}'.format(dl, short))
        lines.append(u'')

    # Discussion topics
    lines.append(u'-' * 50)
    lines.append(u'  💬 讨论要点 ({} 条)'.format(min(len(discussion_points), 8)))
    lines.append(u'-' * 50)
    lines.append(u'')
    for i, d in enumerate(discussion_points[:8], 1):
        lines.append(u'  {}. {}'.format(i, d))
    lines.append(u'')

    lines.append(u'=' * 60)
    lines.append(u'  [END OF MEETING MINUTES]')
    lines.append(u'=' * 60)
    return '\n'.join(lines)

# ── email: extract key points + suggest reply ──

def do_email(text):
    sentences = split_sentences(text)
    wc = count_words(text)

    # Detect urgency
    urgent_patterns = re.compile(u'(紧急|尽快|立即|马上|ASAP|urgent|immediately|critical|deadline|过期|逾期|催|加急)', re.IGNORECASE)
    is_urgent = bool(urgent_patterns.search(text))

    # Detect request type
    request_pattern = re.compile(u'(请|麻烦|帮忙|协助|需要你|能否|是否可以|please|could you|would you|can you|kindly|request|ask)', re.IGNORECASE)
    question_pattern = re.compile(u'(？|\?|吗|呢|何时|什么|怎么|为什么|how|what|when|where|why|which)', re.IGNORECASE)
    fyi_pattern = re.compile(u'(通知|告知|知悉|FYI|for your info|announce|inform|note that|update)', re.IGNORECASE)

    has_request = bool(request_pattern.search(text))
    has_question = bool(question_pattern.search(text))
    has_fyi = bool(fyi_pattern.search(text))

    # Determine email type
    if has_request:
        email_type = u'📩 请求/任务型'
        email_type_en = 'Request/Task'
    elif has_question:
        email_type = u'❓ 咨询/提问型'
        email_type_en = 'Question/Inquiry'
    elif has_fyi:
        email_type = u'📢 通知/知会型'
        email_type_en = 'FYI/Notification'
    else:
        email_type = u'📧 一般沟通'
        email_type_en = 'General'

    # Key points
    summary_text = summarize(text, ratio=0.35, min_sentences=1, max_sentences=5)
    bullets_text = extract_bullets(text, max_bullets=6)

    lines = []
    lines.append(u'=' * 60)
    lines.append(u'  📧  邮件分析 / Email Digest')
    lines.append(u'=' * 60)
    lines.append(u'')
    lines.append(u'邮件类型: {}'.format(email_type))
    lines.append(u'紧急程度: {}'.format(u'🔴 紧急' if is_urgent else u'🟢 普通'))
    lines.append(u'原文字数: {}'.format(wc))
    lines.append(u'')

    lines.append(u'-' * 50)
    lines.append(u'  📌 核心摘要')
    lines.append(u'-' * 50)
    lines.append(u'')
    lines.append(summary_text)
    lines.append(u'')

    lines.append(u'-' * 50)
    lines.append(u'  📋 要点列表')
    lines.append(u'-' * 50)
    lines.append(u'')
    lines.append(bullets_text)
    lines.append(u'')

    # Extract action required from the reader
    action_kw = re.compile(u'(请|需要|要求|必须|deadline|提交|回复|确认|审批|please|must|should|required)', re.IGNORECASE)
    actions = [s.strip() for s in sentences if action_kw.search(s)]

    if actions:
        lines.append(u'-' * 50)
        lines.append(u'  🎯 需要你做的事')
        lines.append(u'-' * 50)
        lines.append(u'')
        for i, a in enumerate(actions[:5], 1):
            lines.append(u'  {}. {}'.format(i, a))
        lines.append(u'')

    # Suggest reply
    lines.append(u'-' * 50)
    lines.append(u'  ✍️  建议回复 (3 种风格)')
    lines.append(u'-' * 50)
    lines.append(u'')

    if has_request or is_urgent:
        lines.append(u'  【简洁确认】')
        lines.append(u'  收到，我会尽快处理。如有问题再沟通。')
        lines.append(u'')
        lines.append(u'  【详细回复】')
        lines.append(u'  感谢来信。关于您提到的事项，我已了解具体需求，')
        lines.append(u'  计划在 [时间] 前完成。过程中如有需要协调的部分，')
        lines.append(u'  我会提前沟通。请放心。')
        lines.append(u'')
        lines.append(u'  【English Reply】')
        lines.append(u'  Thanks for your email. I\'ve noted the request and will')
        lines.append(u'  work on it by [deadline]. I\'ll keep you posted on progress.')
    elif has_question:
        lines.append(u'  【简洁回答】')
        lines.append(u'  关于您的问题，[直接回答]。如需进一步说明请告知。')
        lines.append(u'')
        lines.append(u'  【详细回答】')
        lines.append(u'  感谢您的咨询。针对您提出的问题，具体情况如下：')
        lines.append(u'  1. [回答要点一]')
        lines.append(u'  2. [回答要点二]')
        lines.append(u'  如有其他疑问，随时联系。')
        lines.append(u'')
        lines.append(u'  【English Reply】')
        lines.append(u'  Thanks for reaching out. Regarding your question:')
        lines.append(u'  [answer]. Let me know if you need more details.')
    else:
        lines.append(u'  【简洁确认】')
        lines.append(u'  收到，已知悉。谢谢通知。')
        lines.append(u'')
        lines.append(u'  【详细回复】')
        lines.append(u'  感谢告知。我已了解相关情况，后续如有需要我配合的部分，')
        lines.append(u'  请随时联系。')
        lines.append(u'')
        lines.append(u'  【English Reply】')
        lines.append(u'  Noted, thanks for the update. I\'ll follow up if needed.')
    lines.append(u'')
    return '\n'.join(lines)

# ── report: structured analytical report ──

def do_report(text):
    sentences = split_sentences(text)
    wc = count_words(text)
    kw_text = extract_keywords(text, top_n=10)
    summary_text = summarize(text, ratio=0.3, min_sentences=2, max_sentences=6)
    bullets_text = extract_bullets(text, max_bullets=8)

    # Detect data/numbers for "key findings"
    num_pattern = re.compile(r'(\d+\.?\d*\s*[%％万亿元美元rmb]|\d+\.?\d*\s*(?:percent|million|billion|trillion|yuan|usd|dollar))', re.IGNORECASE)
    data_sentences = [s.strip() for s in sentences if num_pattern.search(s)]

    # Detect comparison/trend language
    trend_pattern = re.compile(u'(增长|下降|提升|减少|增加|上升|下滑|翻倍|同比|环比|趋势|变化|increase|decrease|growth|decline|rise|drop|trend|compared)', re.IGNORECASE)
    trend_sentences = [s.strip() for s in sentences if trend_pattern.search(s)]

    # Detect problem/risk language
    risk_pattern = re.compile(u'(问题|风险|挑战|不足|缺陷|困难|隐患|瓶颈|障碍|issue|risk|challenge|problem|weakness|bottleneck|concern|gap)', re.IGNORECASE)
    risk_sentences = [s.strip() for s in sentences if risk_pattern.search(s)]

    lines = []
    lines.append(u'╔' + u'═' * 58 + u'╗')
    lines.append(u'║{:^58s}║'.format(u'📊  结构化分析报告 / Structured Report'))
    lines.append(u'╚' + u'═' * 58 + u'╝')
    lines.append(u'')
    lines.append(u'生成时间: {}'.format(__import__('datetime').datetime.now().strftime('%Y-%m-%d %H:%M')))
    lines.append(u'原文字数: {} 字 | 句子数: {}'.format(wc, len(sentences)))
    lines.append(u'')

    # 1. Executive Summary
    lines.append(u'┌' + u'─' * 50 + u'┐')
    lines.append(u'│  1. 执行摘要 (Executive Summary)' + u' ' * 16 + u'│')
    lines.append(u'└' + u'─' * 50 + u'┘')
    lines.append(u'')
    lines.append(summary_text)
    lines.append(u'')

    # 2. Key Findings
    lines.append(u'┌' + u'─' * 50 + u'┐')
    lines.append(u'│  2. 关键发现 (Key Findings)' + u' ' * 21 + u'│')
    lines.append(u'└' + u'─' * 50 + u'┘')
    lines.append(u'')
    if data_sentences:
        lines.append(u'  📈 数据要点:')
        for i, ds in enumerate(data_sentences[:5], 1):
            lines.append(u'    {}. {}'.format(i, ds))
        lines.append(u'')
    if trend_sentences:
        lines.append(u'  📊 趋势观察:')
        for i, ts in enumerate(trend_sentences[:5], 1):
            lines.append(u'    {}. {}'.format(i, ts))
        lines.append(u'')
    if not data_sentences and not trend_sentences:
        lines.append(bullets_text)
        lines.append(u'')

    # 3. Core points
    lines.append(u'┌' + u'─' * 50 + u'┐')
    lines.append(u'│  3. 核心要点 (Core Points)' + u' ' * 22 + u'│')
    lines.append(u'└' + u'─' * 50 + u'┘')
    lines.append(u'')
    lines.append(bullets_text)
    lines.append(u'')

    # 4. Risks / Issues
    lines.append(u'┌' + u'─' * 50 + u'┐')
    lines.append(u'│  4. 问题与风险 (Risks & Issues)' + u' ' * 17 + u'│')
    lines.append(u'└' + u'─' * 50 + u'┘')
    lines.append(u'')
    if risk_sentences:
        for i, rs in enumerate(risk_sentences[:5], 1):
            lines.append(u'  ⚠️  {}. {}'.format(i, rs))
    else:
        lines.append(u'  (未检测到明显风险/问题描述)')
    lines.append(u'')

    # 5. Keywords
    lines.append(u'┌' + u'─' * 50 + u'┐')
    lines.append(u'│  5. 关键词云 (Keywords)' + u' ' * 25 + u'│')
    lines.append(u'└' + u'─' * 50 + u'┘')
    lines.append(u'')
    lines.append(kw_text)
    lines.append(u'')

    # 6. Recommendations
    lines.append(u'┌' + u'─' * 50 + u'┐')
    lines.append(u'│  6. 建议与下一步 (Recommendations)' + u' ' * 14 + u'│')
    lines.append(u'└' + u'─' * 50 + u'┘')
    lines.append(u'')
    if risk_sentences:
        lines.append(u'  基于上述风险/问题，建议:')
        lines.append(u'  1. 优先处理已识别的 {} 项风险点'.format(len(risk_sentences[:5])))
        lines.append(u'  2. 针对数据趋势制定应对策略')
        lines.append(u'  3. 建立定期复盘机制，跟踪关键指标')
    else:
        lines.append(u'  基于文档内容，建议:')
        lines.append(u'  1. 深入分析上述关键发现的成因')
        lines.append(u'  2. 制定具体行动计划，明确责任人和截止时间')
        lines.append(u'  3. 建立持续追踪机制')
    lines.append(u'  4. 定期更新报告，对比历史数据')
    lines.append(u'  5. 与相关方共享报告，确保信息对齐')
    lines.append(u'')
    lines.append(u'═' * 60)
    lines.append(u'  [END OF REPORT]')
    lines.append(u'═' * 60)
    return '\n'.join(lines)

# ── mindmap: ASCII tree with real hierarchy (├ └ │) ──

def do_mindmap(text):
    sentences = split_sentences(text)
    wc = count_words(text)

    # --- Build clean keyword list from text ---
    # Extract all Chinese character runs (2+ chars) and find recurring subsequences
    all_tokens = tokenize(text)
    freq = collections.Counter(all_tokens)

    # Also extract 3-4 char sequences from Chinese runs for compound words
    zh_runs = re.findall(u'[\u4e00-\u9fff]{3,}', text)
    trigram_freq = collections.Counter()
    for run in zh_runs:
        for wlen in (4, 3):
            for i in range(len(run) - wlen + 1):
                seg = run[i:i+wlen]
                if seg not in ZH_STOPWORDS:
                    trigram_freq[seg] += 1
    # Only add n-grams that appear 2+ times (validates they're real compounds)
    for seg, cnt in trigram_freq.items():
        if cnt >= 2:
            freq[seg] = freq.get(seg, 0) + cnt

    # Deduplicate: prefer longer terms, remove substrings
    boundary_chars = set(u'的了在是有和就不也很到要去会着这那让通过来进行以及或')
    sorted_terms = sorted(freq.items(), key=lambda x: (-len(x[0]), -x[1]))
    clean_kw = collections.OrderedDict()
    for token, cnt in sorted_terms:
        if cnt < 2:
            continue
        # Skip tokens that start or end with function words
        if token[0] in boundary_chars or token[-1] in boundary_chars:
            continue
        # Skip if this is a substring of an already-kept longer term with similar freq
        is_sub = False
        for kept in clean_kw:
            if token in kept:
                is_sub = True
                break
        if not is_sub:
            clean_kw[token] = cnt

    # Re-sort by frequency
    top_kw = sorted(clean_kw.items(), key=lambda x: x[1], reverse=True)[:10]
    if not top_kw:
        return u'(内容过少，无法生成思维导图)'

    # For root: use the most meaningful term (prefer 3-4 char terms over 2-char)
    root_candidates = [(kw, cnt) for kw, cnt in top_kw if len(kw) >= 3]
    if root_candidates:
        root = root_candidates[0][0]
    else:
        root = top_kw[0][0]

    # Group sentences by keyword match - use all top keywords, not just root
    branches = collections.OrderedDict()
    assigned = set()
    for kw, cnt in top_kw[:7]:
        if kw == root:
            continue  # Don't make root a branch of itself
        branch_sents = []
        for i, s in enumerate(sentences):
            if i not in assigned and kw in s:
                branch_sents.append(s.strip())
                assigned.add(i)
        if branch_sents:
            branches[kw] = branch_sents

    # If no branches formed (all sentences share root keyword), group by position
    if not branches:
        # Split sentences into groups of ~2
        chunk_size = max(1, len(sentences) // 3)
        labels = [u'概念定义', u'核心技术', u'应用领域', u'发展趋势', u'其他']
        for gi in range(0, len(sentences), chunk_size):
            label_idx = min(gi // chunk_size, len(labels) - 1)
            chunk = [sentences[j].strip() for j in range(gi, min(gi + chunk_size, len(sentences)))
                     if sentences[j].strip()]
            if chunk:
                branches[labels[label_idx]] = chunk

    other = [sentences[i].strip() for i in range(len(sentences))
             if i not in assigned and sentences[i].strip()]
    if other and len(branches) < 6:
        branches[u'其他要点'] = other[:4]

    def get_sub_keywords(sent, branch_kw):
        """Get 3rd-level keywords: other top keywords in the sentence, or short clauses."""
        # Filter: only pick clean keywords (no function-word boundaries)
        boundary_garbage = re.compile(u'^[\u7684\u4e86\u5728\u662f\u6709\u548c\u5c31\u4e0d\u4e5f\u5f88\u5230\u8981\u53bb\u4f1a\u7740\u8fd9\u90a3\u80fd\u591f\u8ba9\u901a\u8fc7\u6765\u8fdb\u884c\u4ee5\u53ca\u6216]|[\u7684\u4e86\u5728\u662f\u6709\u548c\u5c31\u4e0d\u4e5f\u5f88\u5230\u8981\u53bb\u4f1a\u7740\u8fd9\u90a3\u80fd\u591f\u8ba9\u901a\u8fc7\u6765\u8fdb\u884c\u4ee5\u53ca\u6216]$')
        sub = []
        for kw, _ in top_kw:
            if kw != branch_kw and kw != root and kw in sent and kw not in sub:
                if not boundary_garbage.search(kw):
                    sub.append(kw)
            if len(sub) >= 3:
                return sub
        # Fallback: split by Chinese punctuation, keep short meaningful clauses
        clauses = re.split(u'[，、,;；：]', sent)
        for clause in clauses:
            clause = clause.strip().rstrip(u'。！？!?.')
            if 2 <= len(clause) <= 6 and clause != branch_kw and clause != root and clause not in sub:
                sub.append(clause)
            if len(sub) >= 3:
                break
        return sub[:3]

    lines = []
    lines.append(u'=' * 60)
    lines.append(u'  🧠  思维导图 / Mind Map')
    lines.append(u'=' * 60)
    lines.append(u'')
    lines.append(u'原文字数: {} | 主要分支: {}'.format(wc, len(branches)))
    lines.append(u'')
    lines.append(u'🌳 {}'.format(root))

    branch_keys = list(branches.keys())
    for bi, bk in enumerate(branch_keys):
        is_last_branch = (bi == len(branch_keys) - 1)
        branch_conn = u'└── ' if is_last_branch else u'├── '
        child_prefix = u'    ' if is_last_branch else u'│   '

        lines.append(u'{}📂 {}'.format(branch_conn, bk))

        branch_sents = branches[bk]
        for si, sent in enumerate(branch_sents[:4]):
            is_last_sent = (si == len(branch_sents[:4]) - 1)
            sent_conn = u'└── ' if is_last_sent else u'├── '
            leaf_prefix = u'    ' if is_last_sent else u'│   '

            display = sent[:55] + u'...' if len(sent) > 55 else sent
            lines.append(u'{}{}{}'.format(child_prefix, sent_conn, display))

            sub_kw = get_sub_keywords(sent, bk)
            for ki, skw in enumerate(sub_kw):
                is_last_kw = (ki == len(sub_kw) - 1)
                kw_conn = u'└─ ' if is_last_kw else u'├─ '
                lines.append(u'{}{}{}🔖 {}'.format(
                    child_prefix, leaf_prefix, kw_conn, skw))

    lines.append(u'')
    lines.append(u'-' * 50)
    lines.append(u'  📝 使用建议:')
    lines.append(u'  • 可将此结构导入 XMind/MindNode 等思维导图工具')
    lines.append(u'  • 各分支可进一步展开细化')
    lines.append(u'  • 关键词标签可用于后续检索和分类')
    lines.append(u'')
    return '\n'.join(lines)

# ── main ──

def main():
    if len(sys.argv) < 3:
        print('Usage: _summarize_core.py <mode> <file1> [file2]', file=sys.stderr)
        sys.exit(1)

    mode = sys.argv[1]
    file1 = sys.argv[2]
    text = read_file(file1)

    if mode == 'summarize':
        print('=== Summary ===')
        print()
        print(summarize(text))
    elif mode == 'bullets':
        print('=== Key Points ===')
        print()
        print(extract_bullets(text))
    elif mode == 'keywords':
        print('=== Keywords ===')
        print()
        print(extract_keywords(text))
    elif mode == 'compare':
        if len(sys.argv) < 4:
            print('Usage: _summarize_core.py compare <file1> <file2>', file=sys.stderr)
            sys.exit(1)
        text2 = read_file(sys.argv[3])
        print(compare_docs(text, text2))
    elif mode == 'wordcount':
        print(do_wordcount(text))
    elif mode == 'translate':
        target_lang = sys.argv[3] if len(sys.argv) > 3 else 'auto'
        print(do_translate(text, target_lang))
    elif mode == 'meeting':
        print(do_meeting(text))
    elif mode == 'email':
        print(do_email(text))
    elif mode == 'report':
        print(do_report(text))
    elif mode == 'mindmap':
        print(do_mindmap(text))
    else:
        print('Unknown mode: {m}'.format(m=mode), file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()
