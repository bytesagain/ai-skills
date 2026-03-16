# Git Helper — 参考文档

## Git 常用命令速查

### 基础操作
```bash
git init                    # 初始化仓库
git clone <url>             # 克隆仓库
git add <file>              # 暂存文件
git add .                   # 暂存所有修改
git commit -m "message"     # 提交
git push origin <branch>    # 推送
git pull origin <branch>    # 拉取
git fetch                   # 获取远程更新（不合并）
```

### 分支操作
```bash
git branch                  # 查看本地分支
git branch -a               # 查看所有分支
git branch <name>           # 创建分支
git checkout <branch>       # 切换分支
git checkout -b <branch>    # 创建并切换
git switch <branch>         # 切换分支（新语法）
git switch -c <branch>      # 创建并切换（新语法）
git merge <branch>          # 合并分支
git rebase <branch>         # 变基
git branch -d <branch>      # 删除已合并分支
git branch -D <branch>      # 强制删除分支
```

### 查看信息
```bash
git status                  # 查看状态
git log --oneline           # 简洁日志
git log --graph --all       # 图形化日志
git diff                    # 查看未暂存改动
git diff --staged           # 查看已暂存改动
git show <commit>           # 查看提交详情
git blame <file>            # 查看文件修改历史
```

### 撤销操作
```bash
git checkout -- <file>      # 撤销工作区修改
git restore <file>          # 撤销工作区修改（新语法）
git reset HEAD <file>       # 取消暂存
git restore --staged <file> # 取消暂存（新语法）
git reset --soft HEAD~1     # 撤销提交，保留修改在暂存区
git reset --mixed HEAD~1    # 撤销提交，保留修改在工作区
git reset --hard HEAD~1     # 撤销提交，丢弃所有修改
git revert <commit>         # 创建反向提交
```

## Commit Message 规范 (Conventional Commits)

### 格式
```
<type>(<scope>): <subject>

<body>

<footer>
```

### 类型
| type | 说明 |
|------|------|
| `feat` | 新功能 |
| `fix` | 修复bug |
| `docs` | 文档变更 |
| `style` | 代码格式（不影响功能） |
| `refactor` | 重构（不是新功能也不是修bug） |
| `perf` | 性能优化 |
| `test` | 添加测试 |
| `chore` | 构建过程或辅助工具变动 |
| `ci` | CI配置变更 |
| `build` | 构建系统变更 |
| `revert` | 回滚 |

### 示例
```
feat(auth): add OAuth2 login support

- Implement Google OAuth2 provider
- Add token refresh mechanism
- Update user model with OAuth fields

Closes #123
```

## 工作流对比

### GitFlow
```
main ──────────────────────────── 稳定发布
  └── develop ─────────────────── 开发主线
        ├── feature/xxx ────────── 功能分支
        ├── release/v1.0 ──────── 发布分支
        └── hotfix/xxx ─────────── 热修复
```
适合：版本化发布的项目，大型团队

### Trunk-Based
```
main ──────────────────────────── 唯一长期分支
  ├── short-lived-branch-1 ──── 短期分支(1-2天)
  ├── short-lived-branch-2
  └── feature flags ──────────── 功能开关控制
```
适合：持续部署，小型敏捷团队

### GitHub Flow
```
main ──────────────────────────── 始终可部署
  └── feature-branch ──────────── PR后合并
```
适合：Web应用，持续交付

## .gitignore 常见模式

### 通用
```
# OS文件
.DS_Store
Thumbs.db
*.swp
*~

# IDE
.idea/
.vscode/
*.iml

# 环境变量
.env
.env.local
```

### 按语言
- **Python**: `__pycache__/`, `*.pyc`, `venv/`, `.eggs/`
- **Node.js**: `node_modules/`, `dist/`, `.next/`
- **Java**: `target/`, `*.class`, `*.jar`
- **Go**: `vendor/`, `*.exe`
- **Rust**: `target/`, `Cargo.lock`(库项目)

## 冲突解决策略

### 冲突标记
```
<<<<<<< HEAD
你的修改
=======
对方的修改
>>>>>>> branch-name
```

### 解决步骤
1. `git status` 查看冲突文件
2. 编辑冲突文件，选择保留哪边（或合并两边）
3. 删除冲突标记 `<<<<<<<`, `=======`, `>>>>>>>`
4. `git add <file>` 标记为已解决
5. `git commit` 完成合并

### 工具
- `git mergetool` — 图形化合并工具
- VS Code内置冲突解决界面
- `git checkout --ours <file>` — 保留我的版本
- `git checkout --theirs <file>` — 保留对方版本
