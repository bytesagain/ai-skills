#!/usr/bin/env bash
# HTML Builder — generates real HTML code
# Usage: html.sh <command> [options]

set -euo pipefail

CMD="${1:-help}"; shift 2>/dev/null || true

# Parse flags
TITLE="My Page" LANG="zh-CN" DESC="" FIELDS="" COLS="" ROWS="3"
CHARSET="utf-8" CSS_FRAMEWORK="" ACTION="#" METHOD="POST"
while [[ $# -gt 0 ]]; do
    case "$1" in
        --title)     TITLE="$2"; shift 2 ;;
        --lang)      LANG="$2"; shift 2 ;;
        --desc)      DESC="$2"; shift 2 ;;
        --fields)    FIELDS="$2"; shift 2 ;;
        --cols)      COLS="$2"; shift 2 ;;
        --rows)      ROWS="$2"; shift 2 ;;
        --css)       CSS_FRAMEWORK="$2"; shift 2 ;;
        --action)    ACTION="$2"; shift 2 ;;
        --method)    METHOD="$2"; shift 2 ;;
        *) shift ;;
    esac
done

gen_boilerplate() {
    local css_link=""
    case "$CSS_FRAMEWORK" in
        tailwind)
            css_link='    <script src="https://cdn.tailwindcss.com"></script>' ;;
        bootstrap)
            css_link='    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">' ;;
        *)
            css_link="" ;;
    esac

    cat <<HTML
<!DOCTYPE html>
<html lang="${LANG}">
<head>
    <meta charset="${CHARSET}">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="${DESC:-${TITLE}}">
    <meta name="author" content="">

    <!-- Open Graph -->
    <meta property="og:title" content="${TITLE}">
    <meta property="og:description" content="${DESC:-${TITLE}}">
    <meta property="og:type" content="website">

    <title>${TITLE}</title>
${css_link}

    <!-- Favicon -->
    <link rel="icon" type="image/svg+xml" href="/favicon.svg">

    <style>
        /* CSS 变量 */
        :root {
            --primary: #3b82f6;
            --bg: #ffffff;
            --text: #1e293b;
            --gray: #64748b;
            --radius: 8px;
        }

        /* Reset */
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: system-ui, -apple-system, sans-serif;
            line-height: 1.6;
            color: var(--text);
            background: var(--bg);
        }

        /* 容器 */
        .container {
            width: min(90%, 1200px);
            margin-inline: auto;
            padding: 2rem 0;
        }

        /* 导航 */
        header {
            background: var(--text);
            color: white;
            padding: 1rem;
        }
        header nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
        }
        header a { color: white; text-decoration: none; padding: 0.5rem 1rem; }
        header a:hover { opacity: 0.8; }

        /* 主体 */
        main { min-height: 60vh; }

        /* 页脚 */
        footer {
            background: #f1f5f9;
            text-align: center;
            padding: 2rem;
            color: var(--gray);
            margin-top: 4rem;
        }

        /* 响应式 */
        @media (max-width: 768px) {
            header nav { flex-direction: column; gap: 0.5rem; }
        }
    </style>
</head>
<body>

    <header>
        <nav>
            <a href="/" style="font-size: 1.25rem; font-weight: bold;">${TITLE}</a>
            <div>
                <a href="#about">关于</a>
                <a href="#features">功能</a>
                <a href="#contact">联系</a>
            </div>
        </nav>
    </header>

    <main>
        <div class="container">
            <h1>${TITLE}</h1>
            <p>欢迎来到 ${TITLE}。在此编辑页面内容。</p>
        </div>
    </main>

    <footer>
        <p>&copy; $(date +%Y) ${TITLE}. All rights reserved.</p>
    </footer>

    <!-- Scripts -->
    <script>
        // Your JavaScript here
        console.log('${TITLE} loaded.');
    </script>
</body>
</html>
HTML
}

gen_form() {
    local fields="${FIELDS:-name,email,phone}"
    IFS=',' read -ra FIELD_ARR <<< "$fields"

    cat <<HTML
<!DOCTYPE html>
<html lang="${LANG}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>表单 — ${TITLE}</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: system-ui, sans-serif;
            background: #f8fafc;
            display: flex; justify-content: center; align-items: center;
            min-height: 100vh; padding: 1rem;
        }
        .form-card {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            width: min(100%, 500px);
            box-shadow: 0 4px 6px rgba(0,0,0,0.07);
        }
        .form-card h2 { margin-bottom: 1.5rem; color: #1e293b; }
        .form-group {
            margin-bottom: 1rem;
        }
        .form-group label {
            display: block;
            margin-bottom: 0.35rem;
            font-weight: 500;
            color: #475569;
            font-size: 0.9rem;
        }
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 0.6rem 0.75rem;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            font-size: 1rem;
            transition: border-color 0.2s;
        }
        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59,130,246,0.1);
        }
        .btn-submit {
            width: 100%;
            padding: 0.75rem;
            background: #3b82f6;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            margin-top: 0.5rem;
            transition: background 0.2s;
        }
        .btn-submit:hover { background: #2563eb; }
        .error { color: #ef4444; font-size: 0.8rem; margin-top: 0.25rem; display: none; }
    </style>
</head>
<body>
    <div class="form-card">
        <h2>${TITLE}</h2>
        <form action="${ACTION}" method="${METHOD}" id="mainForm" novalidate>
HTML

    # Generate form fields
    for field in "${FIELD_ARR[@]}"; do
        field=$(echo "$field" | xargs)  # trim whitespace
        local input_type="text"
        local label="$field"
        local placeholder=""

        # Detect field types by name
        case "$field" in
            email|邮箱)   input_type="email"; label="邮箱"; placeholder="your@email.com" ;;
            phone|电话|手机) input_type="tel"; label="电话"; placeholder="13800138000" ;;
            password|密码) input_type="password"; label="密码"; placeholder="请输入密码" ;;
            name|姓名)    input_type="text"; label="姓名"; placeholder="请输入姓名" ;;
            age|年龄)     input_type="number"; label="年龄"; placeholder="25" ;;
            date|日期)    input_type="date"; label="日期" ;;
            url|网址)     input_type="url"; label="网址"; placeholder="https://" ;;
            message|留言) input_type="textarea"; label="留言"; placeholder="请输入内容…" ;;
            *)           placeholder="请输入${field}" ;;
        esac

        if [[ "$input_type" == "textarea" ]]; then
            cat <<HTML
            <div class="form-group">
                <label for="${field}">${label}</label>
                <textarea id="${field}" name="${field}" rows="4" placeholder="${placeholder}" required></textarea>
                <div class="error">请填写${label}</div>
            </div>
HTML
        else
            cat <<HTML
            <div class="form-group">
                <label for="${field}">${label}</label>
                <input type="${input_type}" id="${field}" name="${field}" placeholder="${placeholder}" required>
                <div class="error">请填写${label}</div>
            </div>
HTML
        fi
    done

    cat <<'HTML'
            <button type="submit" class="btn-submit">提交</button>
        </form>
    </div>

    <script>
        document.getElementById('mainForm').addEventListener('submit', function(e) {
            let valid = true;
            this.querySelectorAll('[required]').forEach(function(el) {
                const err = el.parentElement.querySelector('.error');
                if (!el.value.trim()) {
                    valid = false;
                    el.style.borderColor = '#ef4444';
                    if (err) err.style.display = 'block';
                } else {
                    el.style.borderColor = '#cbd5e1';
                    if (err) err.style.display = 'none';
                }
            });
            if (!valid) e.preventDefault();
        });
    </script>
</body>
</html>
HTML
}

gen_table() {
    local cols="${COLS:-Name,Age,City}"
    local rows="${ROWS:-3}"
    IFS=',' read -ra COL_ARR <<< "$cols"
    local col_count=${#COL_ARR[@]}

    cat <<HTML
<!DOCTYPE html>
<html lang="${LANG}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>表格 — ${TITLE}</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: system-ui, sans-serif;
            background: #f8fafc;
            padding: 2rem;
        }
        h2 { margin-bottom: 1rem; color: #1e293b; }
        .table-wrapper {
            overflow-x: auto;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            min-width: 400px;
        }
        thead {
            background: #1e293b;
            color: white;
        }
        th {
            padding: 0.75rem 1rem;
            text-align: left;
            font-weight: 500;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        td {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid #e2e8f0;
            color: #475569;
        }
        tbody tr:hover {
            background: #f1f5f9;
        }
        tbody tr:last-child td {
            border-bottom: none;
        }
        /* 响应式 */
        @media (max-width: 600px) {
            th, td { padding: 0.5rem; font-size: 0.9rem; }
        }
    </style>
</head>
<body>
    <h2>${TITLE}</h2>
    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
HTML

    for col in "${COL_ARR[@]}"; do
        echo "                    <th>$(echo "$col" | xargs)</th>"
    done

    cat <<HTML
                </tr>
            </thead>
            <tbody>
HTML

    for ((r=1; r<=rows; r++)); do
        echo "                <tr>"
        for ((c=0; c<col_count; c++)); do
            local col_name
            col_name=$(echo "${COL_ARR[$c]}" | xargs)
            echo "                    <td>${col_name} ${r}</td>"
        done
        echo "                </tr>"
    done

    cat <<'HTML'
            </tbody>
        </table>
    </div>

    <script>
        // 点击排序（可选）
        document.querySelectorAll('th').forEach(function(th, index) {
            th.style.cursor = 'pointer';
            th.addEventListener('click', function() {
                const table = th.closest('table');
                const tbody = table.querySelector('tbody');
                const rows = Array.from(tbody.querySelectorAll('tr'));
                const asc = th.dataset.sort !== 'asc';
                rows.sort(function(a, b) {
                    const aVal = a.cells[index].textContent.trim();
                    const bVal = b.cells[index].textContent.trim();
                    return asc ? aVal.localeCompare(bVal) : bVal.localeCompare(aVal);
                });
                th.dataset.sort = asc ? 'asc' : 'desc';
                rows.forEach(function(row) { tbody.appendChild(row); });
            });
        });
    </script>
</body>
</html>
HTML
}

gen_landing() {
    cat <<HTML
<!DOCTYPE html>
<html lang="${LANG}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${TITLE}</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: system-ui, sans-serif; color: #1e293b; }
        .hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; text-align: center;
            padding: 6rem 1rem; min-height: 60vh;
            display: flex; flex-direction: column;
            justify-content: center; align-items: center;
        }
        .hero h1 { font-size: clamp(2rem, 5vw, 3.5rem); margin-bottom: 1rem; }
        .hero p { font-size: 1.2rem; max-width: 600px; opacity: 0.9; }
        .cta {
            display: inline-block; margin-top: 2rem;
            padding: 0.9rem 2.5rem; background: white;
            color: #764ba2; border-radius: 50px;
            font-weight: 600; font-size: 1.1rem;
            text-decoration: none; transition: transform 0.2s;
        }
        .cta:hover { transform: translateY(-2px); }
        .features {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem; padding: 4rem 2rem; max-width: 1000px; margin: 0 auto;
        }
        .feature { text-align: center; padding: 1.5rem; }
        .feature .icon { font-size: 2.5rem; margin-bottom: 1rem; }
        .feature h3 { margin-bottom: 0.5rem; }
        .feature p { color: #64748b; }
        footer { text-align: center; padding: 2rem; color: #94a3b8; }
    </style>
</head>
<body>
    <section class="hero">
        <h1>${TITLE}</h1>
        <p>${DESC:-在这里描述你的产品或服务的核心价值主张}</p>
        <a href="#cta" class="cta">立即开始 →</a>
    </section>
    <section class="features">
        <div class="feature">
            <div class="icon">🚀</div>
            <h3>快速上手</h3>
            <p>简单几步，即可开始使用。</p>
        </div>
        <div class="feature">
            <div class="icon">🔒</div>
            <h3>安全可靠</h3>
            <p>数据安全是我们的第一优先级。</p>
        </div>
        <div class="feature">
            <div class="icon">⚡</div>
            <h3>高性能</h3>
            <p>极致的速度和响应体验。</p>
        </div>
    </section>
    <footer>&copy; $(date +%Y) ${TITLE}</footer>
</body>
</html>
HTML
}

case "$CMD" in
    boilerplate|page|bp)
        gen_boilerplate ;;
    form)
        gen_form ;;
    table)
        gen_table ;;
    landing|lp)
        gen_landing ;;
    *)
        cat <<'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🏗️ HTML Builder — 使用指南
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  命令                 说明
  ──────────────────────────────────────────
  boilerplate          完整 HTML5 页面模板
    --title TEXT          页面标题
    --lang CODE           语言 (默认: zh-CN)
    --desc TEXT           描述
    --css tailwind|bootstrap  CSS框架

  form                 表单页面生成
    --fields LIST         字段列表 (逗号分隔)
    --title TEXT           表单标题
    --action URL          提交地址
    --method GET|POST     提交方式

  table                数据表格页面
    --cols LIST           列名 (逗号分隔)
    --rows NUM            行数 (默认: 3)

  landing              落地页模板
    --title TEXT          页面标题
    --desc TEXT           副标题描述

  示例:
    html.sh boilerplate --title "我的网站" --css tailwind
    html.sh form --fields "姓名,email,phone,message" --title "联系我们"
    html.sh table --cols "姓名,年龄,城市,职业" --rows 5
    html.sh landing --title "MyProduct" --desc "最好的产品"
EOF
        ;;
esac
