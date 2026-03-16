# API Tester — 参考文档

## HTTP 方法

| 方法 | 用途 | 幂等 | 安全 | 请求体 |
|------|------|------|------|--------|
| GET | 查询资源 | ✅ | ✅ | ❌ |
| POST | 创建资源 | ❌ | ❌ | ✅ |
| PUT | 全量更新 | ✅ | ❌ | ✅ |
| PATCH | 部分更新 | ❌ | ❌ | ✅ |
| DELETE | 删除资源 | ✅ | ❌ | 可选 |
| HEAD | 获取头信息 | ✅ | ✅ | ❌ |
| OPTIONS | 查询支持方法 | ✅ | ✅ | ❌ |

## HTTP 状态码

### 1xx 信息
| 码 | 含义 |
|----|------|
| 100 | Continue |
| 101 | Switching Protocols |

### 2xx 成功
| 码 | 含义 | 常见场景 |
|----|------|----------|
| 200 | OK | GET成功 |
| 201 | Created | POST创建成功 |
| 204 | No Content | DELETE成功 |

### 3xx 重定向
| 码 | 含义 |
|----|------|
| 301 | Moved Permanently (永久重定向) |
| 302 | Found (临时重定向) |
| 304 | Not Modified (缓存有效) |
| 307 | Temporary Redirect |
| 308 | Permanent Redirect |

### 4xx 客户端错误
| 码 | 含义 | 常见场景 |
|----|------|----------|
| 400 | Bad Request | 请求参数错误 |
| 401 | Unauthorized | 未认证 |
| 403 | Forbidden | 无权限 |
| 404 | Not Found | 资源不存在 |
| 405 | Method Not Allowed | 方法不支持 |
| 408 | Request Timeout | 请求超时 |
| 409 | Conflict | 资源冲突 |
| 413 | Payload Too Large | 请求体过大 |
| 415 | Unsupported Media Type | 不支持的类型 |
| 422 | Unprocessable Entity | 语义错误 |
| 429 | Too Many Requests | 限流 |

### 5xx 服务端错误
| 码 | 含义 |
|----|------|
| 500 | Internal Server Error |
| 501 | Not Implemented |
| 502 | Bad Gateway |
| 503 | Service Unavailable |
| 504 | Gateway Timeout |

## 常用 Headers

### 请求头
```
Content-Type: application/json          # 请求体类型
Accept: application/json                 # 期望响应类型
Authorization: Bearer <token>            # 认证令牌
User-Agent: MyApp/1.0                    # 客户端标识
X-Request-ID: uuid                       # 请求追踪ID
Cache-Control: no-cache                  # 缓存控制
If-None-Match: "etag"                    # 条件请求
```

### 响应头
```
Content-Type: application/json           # 响应体类型
X-RateLimit-Limit: 100                   # 限流上限
X-RateLimit-Remaining: 95               # 剩余次数
X-RateLimit-Reset: 1609459200           # 重置时间戳
ETag: "33a64df551425fcc55e4d42a148795d9" # 实体标签
Access-Control-Allow-Origin: *           # CORS
```

### Content-Type 常见值
```
application/json                         # JSON
application/x-www-form-urlencoded        # 表单(默认)
multipart/form-data                      # 文件上传
text/plain                               # 纯文本
text/html                                # HTML
application/xml                          # XML
application/octet-stream                 # 二进制
```

## curl 常用参数
```bash
-X METHOD        # 指定HTTP方法
-H "header"      # 添加请求头
-d '{"data"}'    # POST数据
-F "file=@path"  # 上传文件
-o file          # 输出到文件
-v               # 详细输出（含headers）
-s               # 静默模式
-k               # 忽略SSL证书
-L               # 跟随重定向
-w "%{http_code}"  # 输出状态码
--connect-timeout 10  # 连接超时
-u user:pass     # 基本认证
-b "cookie"      # 发送cookie
-c cookie.txt    # 保存cookie
```

## RESTful API 设计规范

### URL 命名
```
GET    /api/v1/users          # 列表
POST   /api/v1/users          # 创建
GET    /api/v1/users/{id}     # 详情
PUT    /api/v1/users/{id}     # 全量更新
PATCH  /api/v1/users/{id}     # 部分更新
DELETE /api/v1/users/{id}     # 删除

# 子资源
GET    /api/v1/users/{id}/orders
# 查询参数
GET    /api/v1/users?page=1&limit=20&sort=name&order=asc
```

### 响应格式
```json
{
  "code": 200,
  "message": "success",
  "data": {},
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100
  }
}
```

## Mock 数据字段参考
- 姓名: 张三, John Doe
- 邮箱: user@example.com
- 手机: 13800138000
- 地址: 北京市朝阳区xxx路
- 头像: https://picsum.photos/200
- UUID: 550e8400-e29b-41d4-a716-446655440000
- 时间: 2024-01-15T10:30:00Z
