#!/usr/bin/env bash
CMD="$1"; shift 2>/dev/null; INPUT="$*"
case "$CMD" in
  code) cat << 'PROMPT'
You are a senior QA engineer. Generate a comprehensive pre-publish CODE QUALITY checklist. Cover:
1. 代码审查 (Code Review)
   - PR是否已审批
   - 代码规范(ESLint/Prettier/Black)
   - 无TODO/FIXME/HACK残留
   - 无console.log/print调试
   - 无硬编码密钥/密码
2. 测试覆盖
   - 单元测试覆盖率>80%
   - 集成测试通过
   - E2E关键流程覆盖
   - 边界条件测试
3. 安全检查
   - 依赖漏洞扫描(npm audit/safety)
   - SQL注入/XSS防护
   - 认证授权检查
   - 敏感数据脱敏
4. 性能
   - Bundle大小对比
   - 数据库查询优化
   - N+1查询检查
   - 内存泄漏检查
Output as Markdown checklist with ☐ for each item. Use Chinese.
Project:
PROMPT
    echo "$INPUT" ;;
  api) cat << 'PROMPT'
You are an API architect. Generate a pre-publish API CHECKLIST. Cover:
1. 功能完整性
   - 所有端点测试通过
   - 请求/响应格式正确
   - 错误码规范(4xx/5xx)
   - 分页/排序/过滤正常
2. 安全
   - 认证(JWT/OAuth/API Key)
   - 限流(Rate Limiting)配置
   - CORS设置
   - 输入验证(参数校验)
3. 文档
   - Swagger/OpenAPI更新
   - 示例请求/响应
   - 错误码文档
   - Breaking Changes说明
4. 兼容性
   - 向后兼容检查
   - API版本管理
   - 废弃接口通知
   - SDK/客户端同步
Output as Markdown checklist. Use Chinese.
API:
PROMPT
    echo "$INPUT" ;;
  deploy) cat << 'PROMPT'
You are a DevOps lead. Generate a DEPLOYMENT checklist. Cover:
1. 环境配置
   - 环境变量(.env)已更新
   - 密钥/证书就位
   - 配置文件差异对比
   - Feature Flags设置
2. 数据库
   - Migration脚本就绪
   - 数据备份已完成
   - 回滚Migration准备
   - 索引检查
3. 基础设施
   - SSL证书有效
   - DNS配置正确
   - CDN缓存策略
   - 负载均衡配置
4. 监控
   - 日志收集配置
   - 告警规则设置
   - APM就绪
   - 健康检查端点
Output as Markdown checklist. Use Chinese.
Deployment:
PROMPT
    echo "$INPUT" ;;
  version) cat << 'PROMPT'
You are a release manager. Guide on VERSION MANAGEMENT. Cover:
1. 语义化版本(SemVer)
   - MAJOR: 不兼容的API修改
   - MINOR: 向下兼容的功能新增
   - PATCH: 向下兼容的Bug修复
   - 预发布: 1.0.0-beta.1
2. CHANGELOG
   - Added/Changed/Deprecated/Removed/Fixed/Security
   - Keep a Changelog格式
   - 关联Issue/PR编号
3. Git操作
   - Tag打法: v1.2.3
   - Release Branch策略
   - Commit Message规范
   - Cherry-pick流程
4. Release Notes
   - 面向用户的更新说明
   - 升级指南
   - Breaking Changes迁移
Output practical guide with examples. Use Chinese.
Version:
PROMPT
    echo "$INPUT" ;;
  launch) cat << 'PROMPT'
You are a launch coordinator. Generate a LAUNCH DAY checklist. Cover:
1. 上线前(T-4h)
   ☐ 回滚方案已准备并测试
   ☐ 值班人员已安排
   ☐ 监控大盘已打开
   ☐ 通知相关团队
2. 发布中(T-0)
   ☐ 灰度发布(1%→10%→50%→100%)
   ☐ 每阶段验证核心指标
   ☐ 实时监控错误率
   ☐ 数据库负载观察
3. 发布后(T+1h)
   ☐ 核心功能验证
   ☐ 性能指标对比
   ☐ 用户反馈监控
   ☐ 错误日志检查
4. 应急
   ☐ 回滚触发条件定义
   ☐ 一键回滚脚本就绪
   ☐ 升级通道畅通
   ☐ 用户公告模板准备
Make it actionable with timeline. Use Chinese.
Launch:
PROMPT
    echo "$INPUT" ;;
  regression) cat << 'PROMPT'
You are a QA lead. Generate a REGRESSION TEST plan. Cover:
1. 核心流程(P0)
   - 用户注册/登录
   - 核心业务流程
   - 支付/交易
   - 数据增删改查
2. 边界条件
   - 空值/极值输入
   - 并发操作
   - 网络异常
   - 权限边界
3. 兼容性
   - 多浏览器(Chrome/Safari/Firefox)
   - 多设备(PC/Mobile/Tablet)
   - 多系统(iOS/Android/Windows/Mac)
   - 多语言/时区
4. 性能基准
   - 页面加载<3秒
   - API响应<200ms
   - 并发用户数
   - 内存/CPU基线
Output as test plan with priority levels. Use Chinese.
Project:
PROMPT
    echo "$INPUT" ;;
  *) cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✅ Test & Publish Checker — 使用指南
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  code [项目]        代码质量检查清单
  api [接口]         API发布检查
  deploy [环境]      部署检查清单
  version [版本号]    版本管理指南
  launch [项目]      上线日检查清单
  regression [项目]   回归测试计划

  💡 发布前至少跑一遍 launch 清单！

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;
esac
