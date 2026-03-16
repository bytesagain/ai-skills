# JSON Formatter — 参考文档

## JSON 基础

### 合法 JSON 数据类型
- **对象** `{}` — 键值对集合，键必须是双引号字符串
- **数组** `[]` — 有序值列表
- **字符串** `"hello"` — 必须双引号
- **数字** `42`, `3.14`, `-1`, `1e10`
- **布尔** `true`, `false`
- **null** `null`

### 常见 JSON 错误
1. 尾部逗号 `{"a":1,}` — 不允许
2. 单引号 `{'a':1}` — 必须双引号
3. 注释 `// comment` — JSON不支持注释
4. 未加引号的键 `{a:1}` — 键必须加双引号
5. 尾部多余逗号在数组 `[1,2,3,]`

## 格式化约定

### 缩进风格
- 2空格缩进（推荐，紧凑）
- 4空格缩进（易读）
- Tab缩进（少用）

### 排序
- 按键名字母排序（便于对比）
- 保持原顺序（保留语义）

## JSON 转换参考

### JSON → YAML 映射
```
{}        → 缩进键值对
[]        → - 列表项
"string"  → string（无引号，除非有特殊字符）
null      → null 或 ~
true/false → true/false
```

### JSON → XML 映射
```
{"root": {"name": "test"}}
→
<root><name>test</name></root>
```
注意：JSON数组到XML没有标准映射，通常用重复元素。

### JSON → CSV
- 仅适用于对象数组 `[{...}, {...}]`
- 第一层键作为列头
- 嵌套对象需要展平

## JSON Schema 参考

### 基本类型映射
| JSON值 | Schema type |
|---------|------------|
| `"abc"` | `"string"` |
| `42` | `"integer"` |
| `3.14` | `"number"` |
| `true` | `"boolean"` |
| `null` | `"null"` |
| `{}` | `"object"` |
| `[]` | `"array"` |

### Schema 关键字
- `type` — 数据类型
- `properties` — 对象属性定义
- `required` — 必需字段
- `items` — 数组元素定义
- `enum` — 枚举值
- `pattern` — 正则验证
- `minimum/maximum` — 数值范围
- `minLength/maxLength` — 字符串长度

## JSON Diff 策略
1. **结构对比** — 哪些键新增/删除/修改
2. **值对比** — 相同键的值变化
3. **类型变化** — 值类型从string变成number等
4. **数组对比** — 顺序敏感 vs 顺序无关

## 性能建议
- 大文件(>1MB)使用流式解析
- jq 命令行工具高效处理
- Python json模块足够大多数场景
