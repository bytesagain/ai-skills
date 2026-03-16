#!/usr/bin/env bash
# README Generator — generates complete README.md files
# Usage: readme.sh <command> [options]

set -euo pipefail

CMD="${1:-help}"; shift 2>/dev/null || true

# Parse flags
NAME="MyProject" DESC="A great project" LICENSE="MIT" AUTHOR=""
LANG_TYPE="" FEATURES="" INSTALL="" REPO="" BADGE="yes"
while [[ $# -gt 0 ]]; do
    case "$1" in
        --name)     NAME="$2"; shift 2 ;;
        --desc)     DESC="$2"; shift 2 ;;
        --license)  LICENSE="$2"; shift 2 ;;
        --author)   AUTHOR="$2"; shift 2 ;;
        --lang)     LANG_TYPE="$2"; shift 2 ;;
        --features) FEATURES="$2"; shift 2 ;;
        --install)  INSTALL="$2"; shift 2 ;;
        --repo)     REPO="$2"; shift 2 ;;
        --no-badge) BADGE="no"; shift ;;
        *) shift ;;
    esac
done

# Detect project type from files
detect_lang() {
    if [[ -n "$LANG_TYPE" ]]; then
        echo "$LANG_TYPE"
    elif [[ -f "package.json" ]]; then
        if grep -q '"react"' package.json 2>/dev/null; then echo "react"
        elif grep -q '"vue"' package.json 2>/dev/null; then echo "vue"
        elif grep -q '"next"' package.json 2>/dev/null; then echo "nextjs"
        else echo "node"
        fi
    elif [[ -f "requirements.txt" || -f "pyproject.toml" || -f "setup.py" ]]; then
        echo "python"
    elif [[ -f "go.mod" ]]; then
        echo "go"
    elif [[ -f "Cargo.toml" ]]; then
        echo "rust"
    elif [[ -f "pom.xml" || -f "build.gradle" ]]; then
        echo "java"
    else
        echo "generic"
    fi
}

gen_badges() {
    if [[ "$BADGE" == "no" ]]; then return; fi
    local lang
    lang=$(detect_lang)

    # License badge
    local license_badge=""
    case "$LICENSE" in
        MIT)     license_badge="[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)" ;;
        Apache*) license_badge="[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)" ;;
        GPL*)    license_badge="[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)" ;;
        *)       license_badge="![License](https://img.shields.io/badge/License-${LICENSE}-green.svg)" ;;
    esac

    echo "$license_badge"

    # Language-specific badges
    case "$lang" in
        node|react|vue|nextjs)
            echo "![Node.js](https://img.shields.io/badge/Node.js-18+-green?logo=node.js)" ;;
        python)
            echo "![Python](https://img.shields.io/badge/Python-3.8+-blue?logo=python)" ;;
        go)
            echo "![Go](https://img.shields.io/badge/Go-1.20+-00ADD8?logo=go)" ;;
        rust)
            echo "![Rust](https://img.shields.io/badge/Rust-1.70+-orange?logo=rust)" ;;
    esac

    if [[ -n "$REPO" ]]; then
        echo "![GitHub stars](https://img.shields.io/github/stars/${REPO}?style=social)"
    fi
    echo ""
}

gen_install_section() {
    local lang
    lang=$(detect_lang)

    case "$lang" in
        node|react|vue|nextjs)
            cat <<MD
## 📦 安装

\`\`\`bash
# 克隆项目
git clone https://github.com/${REPO:-username/${NAME}}.git
cd ${NAME}

# 安装依赖
npm install
# 或
yarn install
# 或
pnpm install

# 启动开发服务器
npm run dev

# 构建生产版本
npm run build
\`\`\`
MD
            ;;
        python)
            cat <<MD
## 📦 安装

\`\`\`bash
# 克隆项目
git clone https://github.com/${REPO:-username/${NAME}}.git
cd ${NAME}

# 创建虚拟环境
python -m venv venv
source venv/bin/activate  # Linux/macOS
# venv\\Scripts\\activate   # Windows

# 安装依赖
pip install -r requirements.txt

# 运行
python main.py
\`\`\`
MD
            ;;
        go)
            cat <<MD
## 📦 安装

\`\`\`bash
# 方式 1: go install
go install github.com/${REPO:-username/${NAME}}@latest

# 方式 2: 源码编译
git clone https://github.com/${REPO:-username/${NAME}}.git
cd ${NAME}
go build -o ${NAME} .

# 运行
./${NAME}
\`\`\`
MD
            ;;
        rust)
            cat <<MD
## 📦 安装

\`\`\`bash
# 方式 1: cargo install
cargo install ${NAME}

# 方式 2: 源码编译
git clone https://github.com/${REPO:-username/${NAME}}.git
cd ${NAME}
cargo build --release

# 运行
./target/release/${NAME}
\`\`\`
MD
            ;;
        *)
            cat <<MD
## 📦 安装

\`\`\`bash
# 克隆项目
git clone https://github.com/${REPO:-username/${NAME}}.git
cd ${NAME}

# 按项目说明安装依赖并运行
\`\`\`
MD
            ;;
    esac
}

gen_readme() {
    local lang
    lang=$(detect_lang)

    # Header
    echo "# ${NAME}"
    echo ""
    gen_badges
    echo "> ${DESC}"
    echo ""

    # Table of Contents
    cat <<'MD'
## 📋 目录

- [功能特性](#-功能特性)
- [安装](#-安装)
- [使用方法](#-使用方法)
- [配置](#-配置)
- [项目结构](#-项目结构)
- [API 文档](#-api-文档)
- [开发](#-开发)
- [贡献指南](#-贡献指南)
- [许可证](#-许可证)

MD

    # Features
    echo "## ✨ 功能特性"
    echo ""
    if [[ -n "$FEATURES" ]]; then
        IFS=',' read -ra FEAT_ARR <<< "$FEATURES"
        for feat in "${FEAT_ARR[@]}"; do
            echo "- ✅ $(echo "$feat" | xargs)"
        done
    else
        cat <<'MD'
- ✅ 功能一：简要描述
- ✅ 功能二：简要描述
- ✅ 功能三：简要描述
- 🚧 计划中：即将推出的功能
MD
    fi
    echo ""

    # Prerequisites
    echo "## 🔧 前置要求"
    echo ""
    case "$lang" in
        node|react|vue|nextjs)
            echo "- Node.js >= 18.0"
            echo "- npm / yarn / pnpm" ;;
        python)
            echo "- Python >= 3.8"
            echo "- pip" ;;
        go)
            echo "- Go >= 1.20" ;;
        rust)
            echo "- Rust >= 1.70"
            echo "- Cargo" ;;
        *)
            echo "- 根据项目需求填写" ;;
    esac
    echo ""

    # Install
    gen_install_section

    # Usage
    cat <<MD

## 🚀 使用方法

\`\`\`bash
# 基本用法
${NAME} [options]

# 示例
${NAME} --help
\`\`\`

## ⚙️ 配置

| 环境变量 | 说明 | 默认值 |
|---------|------|--------|
| \`PORT\` | 服务端口 | \`3000\` |
| \`NODE_ENV\` | 环境 | \`development\` |
| \`DB_URL\` | 数据库连接 | — |

## 📁 项目结构

\`\`\`
${NAME}/
MD

    # Generate project structure based on language
    case "$lang" in
        node|react|vue|nextjs)
            cat <<MD
├── src/               # 源代码
│   ├── components/    # 组件
│   ├── pages/         # 页面
│   ├── utils/         # 工具函数
│   └── index.js       # 入口文件
├── public/            # 静态资源
├── tests/             # 测试文件
├── .env.example       # 环境变量示例
├── package.json
└── README.md
MD
            ;;
        python)
            cat <<MD
├── ${NAME}/           # 主包
│   ├── __init__.py
│   ├── main.py        # 入口
│   ├── models/        # 数据模型
│   ├── services/      # 业务逻辑
│   └── utils/         # 工具
├── tests/             # 测试
├── requirements.txt
├── .env.example
└── README.md
MD
            ;;
        go)
            cat <<MD
├── cmd/               # 命令入口
│   └── main.go
├── internal/          # 内部包
│   ├── handler/       # HTTP 处理器
│   ├── service/       # 业务逻辑
│   └── model/         # 数据模型
├── pkg/               # 公共包
├── go.mod
├── go.sum
├── Makefile
└── README.md
MD
            ;;
        *)
            cat <<MD
├── src/               # 源代码
├── tests/             # 测试
├── docs/              # 文档
├── .env.example
└── README.md
MD
            ;;
    esac

    cat <<MD
\`\`\`

## 📖 API 文档

<!-- 如果有 API，在此描述 -->

### \`GET /api/example\`

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| \`id\` | string | 是 | 资源 ID |

**响应示例:**

\`\`\`json
{
  "code": 200,
  "data": {},
  "message": "success"
}
\`\`\`

## 🛠️ 开发

\`\`\`bash
# 安装开发依赖
$(case "$lang" in
    node*|react|vue|nextjs) echo "npm install" ;;
    python) echo "pip install -r requirements-dev.txt" ;;
    go) echo "go mod download" ;;
    *) echo "# 安装依赖" ;;
esac)

# 运行测试
$(case "$lang" in
    node*|react|vue|nextjs) echo "npm test" ;;
    python) echo "pytest" ;;
    go) echo "go test ./..." ;;
    *) echo "# 运行测试" ;;
esac)

# 代码检查
$(case "$lang" in
    node*|react|vue|nextjs) echo "npm run lint" ;;
    python) echo "flake8 . && mypy ." ;;
    go) echo "golangci-lint run" ;;
    *) echo "# 代码检查" ;;
esac)
\`\`\`

## 🤝 贡献指南

1. Fork 本项目
2. 创建特性分支 (\`git checkout -b feature/amazing-feature\`)
3. 提交更改 (\`git commit -m 'feat: add amazing feature'\`)
4. 推送到分支 (\`git push origin feature/amazing-feature\`)
5. 提交 Pull Request

## 📄 许可证

本项目基于 [${LICENSE}](LICENSE) 许可证开源。

## 🙏 致谢

- [依赖/灵感来源](链接)

---

<p align="center">Made with ❤️ by ${AUTHOR:-Your Name}</p>
MD
}

gen_minimal() {
    cat <<MD
# ${NAME}

${DESC}

## 安装

\`\`\`bash
git clone https://github.com/${REPO:-username/${NAME}}.git
cd ${NAME}
# 安装依赖并运行
\`\`\`

## 使用

\`\`\`bash
${NAME} --help
\`\`\`

## 许可证

${LICENSE}
MD
}

case "$CMD" in
    generate|gen|full)
        gen_readme ;;
    minimal|mini|simple)
        gen_minimal ;;
    badges)
        gen_badges ;;
    *)
        cat <<'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📝 README Generator — 使用指南
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  命令                 说明
  ──────────────────────────────────────────
  generate             生成完整 README.md
    --name TEXT          项目名称
    --desc TEXT          项目描述
    --license MIT|Apache|GPL  许可证
    --author TEXT        作者名
    --lang TEXT          语言 (node|python|go|rust)
    --features LIST      功能列表 (逗号分隔)
    --repo USER/REPO     GitHub 仓库路径
    --no-badge           不生成徽章

  minimal              生成精简版 README

  badges               只生成徽章

  示例:
    readme.sh generate --name "MyApp" --desc "A cool app" --license MIT --lang node
    readme.sh generate --name "api-server" --lang go --features "REST API,WebSocket,JWT认证"
    readme.sh minimal --name "quick-tool" --desc "A quick tool"
    readme.sh generate --name "MyLib" --repo "username/mylib" --author "John"
EOF
        ;;
esac
