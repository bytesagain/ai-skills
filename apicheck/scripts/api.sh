#!/usr/bin/env bash
# api.sh — API 测试助手
# 用法: bash scripts/api.sh <command>

set -euo pipefail

CMD="${1:-help}"

case "$CMD" in

request)
cat << 'PYEOF'
## API 请求构造任务

帮助用户构造完整的API请求。

### 操作步骤
1. 确认请求信息:
   - HTTP方法 (GET/POST/PUT/PATCH/DELETE)
   - URL 地址
   - 请求头 (Headers)
   - 请求参数 (Query Parameters)
   - 请求体 (Body)
   - 认证方式 (Bearer Token/Basic Auth/API Key)
2. 构造完整请求
3. 提供多语言/工具的代码

### 输出格式
```
📡 API 请求
━━━━━━━━━━

方法: POST
URL:  https://api.example.com/v1/users
Headers:
  Content-Type: application/json
  Authorization: Bearer xxx
Body:
  {
    "name": "张三",
    "email": "zhangsan@example.com"
  }

💻 代码示例:

curl:
  curl -X POST 'https://api.example.com/v1/users' \
    -H 'Content-Type: application/json' \
    -H 'Authorization: Bearer xxx' \
    -d '{"name":"张三","email":"zhangsan@example.com"}'

Python (requests):
  import requests
  resp = requests.post(
      'https://api.example.com/v1/users',
      headers={'Authorization': 'Bearer xxx'},
      json={'name': '张三', 'email': 'zhangsan@example.com'}
  )

JavaScript (fetch):
  fetch('https://api.example.com/v1/users', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer xxx'
    },
    body: JSON.stringify({name: '张三', email: 'zhangsan@example.com'})
  })
```
PYEOF
;;

curl)
cat << 'PYEOF'
## curl 命令生成任务

根据用户需求生成可直接执行的curl命令。

### 操作步骤
1. 了解请求的目标API和参数
2. 生成curl命令（带注释）
3. 提供常用变体（verbose/silent等）
4. 解释每个参数含义

### 输出格式
```
🔧 curl 命令
━━━━━━━━━━━

# 基本版
curl -X POST 'https://api.example.com/v1/users' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_TOKEN' \
  -d '{
    "name": "张三",
    "email": "zhangsan@example.com"
  }'

# 详细输出版（含响应头）
curl -v -X POST ...

# 静默版（只输出响应体）
curl -s -X POST ... | jq .

# 带状态码输出
curl -s -o /dev/null -w "%{http_code}" -X POST ...

# 保存响应到文件
curl -o response.json -X POST ...

📝 参数说明:
  -X POST          指定HTTP方法
  -H 'header'      设置请求头
  -d 'data'        设置请求体
  -v               详细输出
  -s               静默模式
  -o file          输出到文件
  | jq .           格式化JSON输出
```

### Windows 兼容
提供 Windows CMD 和 PowerShell 版本（单引号改双引号等）。
PYEOF
;;

mock)
cat << 'PYEOF'
## Mock 数据生成任务

根据API接口定义或用户描述生成逼真的Mock数据。

### 操作步骤
1. 了解数据结构（字段名、类型、关系）
2. 生成逼真的测试数据
3. 提供单条和列表版本
4. 可指定数量

### 输出格式
```
📦 Mock 数据
━━━━━━━━━━━

单条数据:
{
  "id": 1001,
  "name": "张三",
  "email": "zhangsan@example.com",
  "phone": "13812345678",
  "avatar": "https://picsum.photos/200?random=1",
  "role": "admin",
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-03-10T14:22:00Z"
}

列表数据 (5条):
[
  {"id": 1001, "name": "张三", ...},
  {"id": 1002, "name": "李四", ...},
  ...
]

分页响应:
{
  "code": 200,
  "message": "success",
  "data": [...],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 156,
    "total_pages": 8
  }
}
```

### 数据逼真度
- 中文姓名使用常见姓氏+名字
- 手机号使用合法号段
- 邮箱域名多样化
- 日期时间合理分布
- ID递增或UUID格式
- 枚举值随机分布
PYEOF
;;

doc)
cat << 'PYEOF'
## API 文档编写任务

为API接口编写清晰完整的文档。

### 操作步骤
1. 了解API功能和参数
2. 按标准格式编写文档
3. 包含请求和响应示例
4. 列出错误码

### 输出格式 (Markdown)
```markdown
## 创建用户

创建一个新用户账号。

### 基本信息
- **URL**: `/api/v1/users`
- **方法**: `POST`
- **认证**: 需要 Bearer Token
- **Content-Type**: `application/json`

### 请求参数

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| name | string | ✅ | 用户名，2-50字符 |
| email | string | ✅ | 邮箱地址 |
| phone | string | ❌ | 手机号 |
| role | string | ❌ | 角色，默认 "user" |

### 请求示例
POST /api/v1/users
{
  "name": "张三",
  "email": "zhangsan@example.com"
}

### 成功响应 (201)
{
  "code": 201,
  "message": "用户创建成功",
  "data": {
    "id": 1001,
    "name": "张三",
    ...
  }
}

### 错误响应
| 状态码 | 错误码 | 说明 |
|--------|--------|------|
| 400 | INVALID_PARAM | 参数不合法 |
| 409 | EMAIL_EXISTS | 邮箱已注册 |
| 401 | UNAUTHORIZED | 未认证 |
```

### 文档风格
可选: Markdown / OpenAPI(Swagger) / Apifox 格式
PYEOF
;;

status)
cat << 'PYEOF'
## HTTP 状态码速查任务

解释HTTP状态码的含义和使用场景。

### 操作步骤
1. 接收用户询问的状态码
2. 给出完整解释
3. 说明常见原因和解决方法

### 输出格式
```
📊 HTTP 状态码: 429 Too Many Requests
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 含义:
  客户端发送了太多请求，触发了服务端的限流策略。

📋 分类: 4xx 客户端错误

🔍 常见原因:
  1. API调用频率超过限制
  2. 爬虫请求过快
  3. 循环中未加延时
  4. 未正确处理分页

🛠️ 解决方法:
  1. 查看 Retry-After 响应头
  2. 实现指数退避重试
  3. 减少请求频率
  4. 使用缓存减少重复请求
  5. 联系API提供方提升配额

💻 相关响应头:
  Retry-After: 60
  X-RateLimit-Limit: 100
  X-RateLimit-Remaining: 0
  X-RateLimit-Reset: 1609459200
```

### 速查表模式
如果用户要求速查表，按分类列出所有常见状态码。
PYEOF
;;

headers)
cat << 'PYEOF'
## HTTP Headers 说明任务

解释HTTP请求头和响应头的含义和用法。

### 操作步骤
1. 接收用户询问的Header名称
2. 给出详细解释
3. 列出所有可能的值
4. 提供使用示例

### 输出格式
```
📋 HTTP Header: Content-Type
━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 含义:
  指定请求体或响应体的媒体类型（MIME type）。

📍 用于: 请求 + 响应

📊 常见值:
  application/json           JSON数据
  application/xml            XML数据
  text/html                  HTML页面
  text/plain                 纯文本
  multipart/form-data        文件上传
  application/x-www-form-urlencoded  表单提交
  application/octet-stream   二进制文件
  image/png                  PNG图片
  image/jpeg                 JPEG图片

💻 使用示例:
  请求:
    curl -H 'Content-Type: application/json' ...

  响应:
    HTTP/1.1 200 OK
    Content-Type: application/json; charset=utf-8

⚠️ 注意:
  - charset通常是utf-8
  - multipart/form-data的boundary由客户端自动生成
  - 不设置Content-Type，默认是text/plain
```

### 分类速查
如果用户要求列表，按类别展示：
- 通用头（General）
- 请求头（Request）
- 响应头（Response）
- 安全相关头（Security）
- 缓存相关头（Cache）
- CORS相关头
PYEOF
;;

help|*)
cat << 'EOF'
╔══════════════════════════════════════════════╗
║        API Tester — API 测试助手             ║
╠══════════════════════════════════════════════╣
║                                              ║
║  用法: bash scripts/api.sh <command>         ║
║                                              ║
║  命令:                                       ║
║    request — 构造API请求                     ║
║    curl    — 生成curl命令                    ║
║    mock    — 生成Mock数据                    ║
║    doc     — 编写API文档                     ║
║    status  — HTTP状态码速查                  ║
║    headers — HTTP Headers说明                ║
║                                              ║
║  示例:                                       ║
║    bash scripts/api.sh request               ║
║    bash scripts/api.sh curl                  ║
║    bash scripts/api.sh status                ║
║                                              ║
╚══════════════════════════════════════════════╝

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
;;

esac
