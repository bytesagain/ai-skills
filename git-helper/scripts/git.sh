#!/usr/bin/env bash
# git.sh — Git 命令助手
# 用法: bash scripts/git.sh <command>

set -euo pipefail

CMD="${1:-help}"

case "$CMD" in

command)
cat << 'PYEOF'
## Git 命令生成任务

根据用户的自然语言描述，生成对应的Git命令。

### 操作步骤
1. 理解用户想完成的Git操作
2. 生成准确的Git命令（可能是一组命令）
3. 解释每条命令的作用
4. 提醒注意事项和风险

### 输出格式
```
📋 需求: [用户描述]

💻 命令:
  git command1        # 说明1
  git command2        # 说明2

📝 解释:
  第1步: 做什么，为什么
  第2步: 做什么，为什么

⚠️ 注意:
  - 风险提示（如有）
  - 前置条件
  - 是否可逆
```

### 常见场景
- 分支创建/切换/合并/删除
- 提交/修改提交/撤销提交
- 远程操作（push/pull/fetch）
- 标签操作
- stash操作
- cherry-pick
- rebase交互式操作
- submodule操作
- worktree操作

### 安全建议
- 区分危险操作（reset --hard, force push）和安全操作
- 危险操作用 ⚠️ 标注
- 建议先备份或创建分支
PYEOF
;;

conflict)
cat << 'PYEOF'
## Git 冲突解决任务

指导用户解决Git合并冲突。

### 操作步骤
1. 了解冲突发生的场景（merge/rebase/cherry-pick/stash）
2. 解释冲突标记的含义
3. 给出具体的解决步骤
4. 提供命令行和IDE两种解决方式

### 输出格式
```
🔀 冲突解决指南
━━━━━━━━━━━━━━

📍 冲突场景: merge / rebase / cherry-pick

📋 步骤:
  1. 查看冲突文件
     $ git status

  2. 编辑冲突文件
     <<<<<<< HEAD
     你的代码（当前分支）
     =======
     对方代码（合并分支）
     >>>>>>> branch-name

  3. 解决方案选择:
     a) 保留你的: git checkout --ours <file>
     b) 保留对方: git checkout --theirs <file>
     c) 手动合并: 编辑文件，保留需要的部分

  4. 标记解决: git add <file>
  5. 完成: git commit / git rebase --continue

💡 技巧:
  - 用 git diff 查看变更
  - 用 git log --merge 查看冲突提交
  - 复杂冲突用 git mergetool
```

### 预防冲突
- 经常同步主分支
- 小而频繁的提交
- 团队沟通谁在改什么文件
PYEOF
;;

workflow)
cat << 'PYEOF'
## Git 工作流指导任务

根据团队规模和项目类型推荐合适的Git工作流。

### 支持的工作流
1. **GitFlow** — 版本化发布，大型团队
2. **GitHub Flow** — 简单PR流，持续部署
3. **Trunk-Based** — 持续集成，短分支
4. **GitLab Flow** — 环境分支，有测试/预发布

### 操作步骤
1. 了解团队规模、发布频率、项目类型
2. 推荐最合适的工作流
3. 画出分支结构图（ASCII）
4. 给出具体操作命令序列
5. 说明分支命名规范

### 输出格式
```
🌿 推荐工作流: [名称]
━━━━━━━━━━━━━━━━━━━━

📊 分支结构:
  main ──────●──────●──────●──── 生产环境
              \    /        \
  develop ─────●──●──────────●── 开发线
                \          /
  feature/xxx ───●────────●───── 功能分支

📝 分支命名:
  - 功能: feature/user-login
  - 修复: fix/login-error
  - 发布: release/v1.2.0
  - 热修: hotfix/critical-bug

💻 日常操作流程:
  1. 创建功能分支: git checkout -b feature/xxx develop
  2. 开发并提交: git commit ...
  3. 推送: git push origin feature/xxx
  4. 创建PR/MR
  5. Code Review
  6. 合并到develop
  7. 删除功能分支

📋 团队规则建议:
  - PR必须至少1人Review
  - 合并前必须通过CI
  - 不允许直接push到main/develop
```
PYEOF
;;

ignore)
cat << 'PYEOF'
## .gitignore 生成任务

根据项目类型生成合适的.gitignore文件。

### 操作步骤
1. 确认项目语言/框架（Python/Node/Java/Go/等）
2. 确认使用的IDE（VSCode/IDEA/Vim/等）
3. 确认操作系统（macOS/Linux/Windows）
4. 生成完整的.gitignore

### 输出格式
生成带注释分类的.gitignore文件内容：

```gitignore
# ===== 操作系统 =====
.DS_Store
Thumbs.db

# ===== IDE =====
.idea/
.vscode/

# ===== 语言/框架 =====
[语言特定的忽略规则]

# ===== 环境和密钥 =====
.env
.env.local
*.pem
*.key

# ===== 构建产物 =====
dist/
build/

# ===== 日志 =====
*.log
logs/
```

### 支持的项目类型
Python, Node.js, Java, Go, Rust, Ruby, PHP,
C/C++, Swift, Kotlin, Flutter/Dart, Unity,
React, Vue, Angular, Next.js, Django, Flask,
Spring Boot, Laravel, Rails...

### 提示
- 推荐参考 github/gitignore 仓库
- 可以用 gitignore.io 在线生成
PYEOF
;;

message)
cat << 'PYEOF'
## Commit Message 生成任务

根据用户描述的代码变更，生成规范的commit message。

### Conventional Commits 格式
```
<type>(<scope>): <subject>    ← 标题行（50字符以内）
                               ← 空行
<body>                         ← 正文（72字符换行）
                               ← 空行
<footer>                       ← 脚注
```

### 操作步骤
1. 了解用户做了什么修改
2. 确定type（feat/fix/docs/style/refactor/perf/test/chore）
3. 确定scope（可选，受影响的模块）
4. 写简洁的subject（英文祈使语气）
5. 如有需要，写body详细说明

### 输出格式
```
📝 Commit Message:

feat(auth): add Google OAuth2 login

- Implement OAuth2 authorization flow
- Add callback URL handler
- Store refresh tokens in database

Closes #42

---
🔤 中文版（如需）:
feat(认证): 添加Google OAuth2登录

- 实现OAuth2授权流程
- 添加回调URL处理
- 数据库存储刷新令牌

关闭 #42
```

### type 选择指南
- 新功能 → `feat`
- 修bug → `fix`
- 改文档 → `docs`
- 代码格式/lint → `style`
- 重构 → `refactor`
- 性能优化 → `perf`
- 加测试 → `test`
- 构建/工具 → `chore`

### 提供多个选项
如果不确定用户的意图，提供2-3个不同风格的commit message供选择。
PYEOF
;;

undo)
cat << 'PYEOF'
## Git 撤销操作任务

指导用户安全地撤销各种Git操作。

### 常见撤销场景

#### 1. 撤销工作区修改（未暂存）
```
git checkout -- <file>       # 旧语法
git restore <file>           # 新语法 (Git 2.23+)
```

#### 2. 取消暂存（已add未commit）
```
git reset HEAD <file>        # 旧语法
git restore --staged <file>  # 新语法
```

#### 3. 修改上一次commit
```
git commit --amend           # 修改message或追加文件
```

#### 4. 撤销commit（保留代码）
```
git reset --soft HEAD~1      # 回到暂存区
git reset --mixed HEAD~1     # 回到工作区（默认）
```

#### 5. 撤销commit（丢弃代码）
```
git reset --hard HEAD~1      # ⚠️ 危险！不可逆
```

#### 6. 安全撤销（已推送的commit）
```
git revert <commit>          # 创建反向提交
```

### 操作步骤
1. 了解用户当前的状态（哪一步操作要撤销）
2. 确认是否已推送到远程
3. 推荐最安全的撤销方式
4. 给出具体命令和解释
5. 标注危险操作

### 输出格式
```
⏪ 撤销操作指南
━━━━━━━━━━━━━━

📍 当前状态: [描述]
🎯 目标: [用户想要达到的状态]

💻 操作命令:
  git xxx        # 说明

⚠️ 风险等级: 低/中/高
📝 注意: 是否可逆，影响范围

🔄 如果撤销错了:
  git reflog     # 查看操作历史
  git reset --hard <hash>  # 恢复到指定状态
```

### 安全提示
- 推送前的撤销用 reset
- 推送后的撤销用 revert
- 永远可以用 git reflog 找回（30天内）
- 强烈建议：重大操作前先创建备份分支
PYEOF
;;

help|*)
cat << 'EOF'
╔══════════════════════════════════════════════╗
║        Git Helper — Git 命令助手             ║
╠══════════════════════════════════════════════╣
║                                              ║
║  用法: bash scripts/git.sh <command>         ║
║                                              ║
║  命令:                                       ║
║    command  — 根据描述生成Git命令            ║
║    conflict — 冲突解决指导                   ║
║    workflow — 工作流指导(GitFlow/Trunk)      ║
║    ignore   — 生成.gitignore                 ║
║    message  — 生成commit message             ║
║    undo     — 撤销操作指导                   ║
║                                              ║
║  示例:                                       ║
║    bash scripts/git.sh command               ║
║    bash scripts/git.sh ignore                ║
║    bash scripts/git.sh message               ║
║                                              ║
╚══════════════════════════════════════════════╝

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
;;

esac
