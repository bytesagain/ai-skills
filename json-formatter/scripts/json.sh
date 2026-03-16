#!/usr/bin/env bash
# json.sh — JSON 瑞士军刀
# 用法: bash scripts/json.sh <command>

set -euo pipefail

CMD="${1:-help}"

case "$CMD" in

format)
cat << 'PYEOF'
## JSON 格式化任务

请将用户提供的JSON进行格式化美化，遵循以下规则：

1. 使用2空格缩进（除非用户指定其他缩进）
2. 每个键值对独占一行
3. 数组元素独占一行（短数组可单行）
4. 确保输出是合法JSON

### 操作步骤
1. 接收用户的JSON文本（可能是压缩的、格式混乱的）
2. 解析并验证JSON合法性
3. 按规则重新格式化输出
4. 如果JSON不合法，指出错误位置并建议修复

### 输出格式
```json
{
  "格式化后的": "JSON内容"
}
```

如果原始JSON有语法错误，先说明错误，再给出修复后的格式化版本。
PYEOF
;;

validate)
cat << 'PYEOF'
## JSON 验证任务

请验证用户提供的JSON是否合法，检查以下内容：

### 检查清单
1. **语法检查** — 括号匹配、逗号、引号
2. **常见错误检测**:
   - 尾部逗号 `{"a":1,}`
   - 单引号 `{'a':1}`
   - 未加引号的键 `{a:1}`
   - 注释 `// ...` 或 `/* ... */`
   - 特殊值 `undefined`, `NaN`, `Infinity`
   - 十六进制数字 `0xFF`
3. **编码检查** — 确保是UTF-8
4. **结构分析** — 嵌套深度、键数量

### 输出格式
```
✅ JSON 合法
- 类型: object/array
- 嵌套深度: N层
- 键数量: N个（顶层）
- 大小: N bytes
```

或者：
```
❌ JSON 不合法
- 错误位置: 第N行, 第M列
- 错误描述: 具体说明
- 修复建议: 怎么改
- 修复后的JSON: ...
```
PYEOF
;;

convert)
cat << 'PYEOF'
## JSON 转换任务

将JSON与其他格式互转。支持的转换方向：

### 支持的转换
- **JSON → YAML** — 标准YAML格式
- **JSON → XML** — 带根元素的XML
- **JSON → CSV** — 仅支持对象数组
- **YAML → JSON** — 标准JSON输出
- **XML → JSON** — 结构化JSON输出
- **CSV → JSON** — 对象数组格式

### 操作步骤
1. 确认用户的源格式和目标格式
2. 解析源数据
3. 执行转换
4. 输出目标格式的文本

### 转换注意事项
- JSON→CSV: 仅适用于扁平对象数组，嵌套字段用点号展平 (如 `address.city`)
- JSON→XML: 需要指定根元素名，数组用重复子元素表示
- YAML→JSON: 注意YAML锚点(&)和引用(*)的展开
- 保持数据类型一致性（数字、布尔等）

### 输出
先说明转换方向，然后输出转换结果的完整文本。
PYEOF
;;

minify)
cat << 'PYEOF'
## JSON 压缩任务

将格式化的JSON压缩为单行，去除所有不必要的空白字符。

### 操作步骤
1. 接收用户的JSON文本
2. 验证JSON合法性
3. 去除所有缩进、换行、多余空格
4. 输出压缩后的单行JSON
5. 报告压缩前后的大小对比

### 输出格式
```
压缩前: N 字符
压缩后: M 字符
节省: X% 空间

压缩结果:
{"key":"value","array":[1,2,3]}
```

### 注意事项
- 字符串内部的空格不能删除
- 确保压缩后的JSON仍然合法
- 对于超大JSON，提示用户用 jq -c 命令行工具
PYEOF
;;

diff)
cat << 'PYEOF'
## JSON 对比任务

对比两段JSON的差异，清晰展示新增、删除、修改的内容。

### 操作步骤
1. 接收用户提供的两段JSON（标记为A和B）
2. 递归对比所有键值对
3. 分类展示差异

### 差异分类
- 🟢 **新增** — B中有但A中没有的键
- 🔴 **删除** — A中有但B中没有的键
- 🟡 **修改** — 两边都有但值不同的键
- ⚪ **相同** — 值完全相同的键（可选显示）

### 输出格式
```
JSON 对比结果 (A → B)
━━━━━━━━━━━━━━━━━━━━

🟢 新增:
  + path.to.key: "new value"

🔴 删除:
  - path.to.key: "old value"

🟡 修改:
  ~ path.to.key: "old" → "new"
  ~ path.to.num: 1 → 2

📊 统计: 新增 N | 删除 N | 修改 N | 相同 N
```

### 注意事项
- 用JSON Path表示嵌套路径（如 `$.user.address.city`）
- 数组对比：按索引位置对比
- 类型变化也要标注（如 string→number）
PYEOF
;;

schema)
cat << 'PYEOF'
## JSON Schema 生成任务

从用户提供的JSON数据自动推断并生成JSON Schema。

### 操作步骤
1. 接收用户的JSON样本数据
2. 分析每个字段的类型
3. 推断约束条件（必需字段、格式等）
4. 生成符合 JSON Schema Draft-07 的Schema

### 推断规则
- 字符串: 检测是否为 email, uri, date-time, uuid 等格式
- 数字: 区分 integer 和 number
- 数组: 分析元素类型，生成 items schema
- 对象: 递归生成 properties
- 非null字段标记为 required
- 检测枚举模式（重复值少时用 enum）

### 输出格式
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "fieldName": {
      "type": "string",
      "description": "字段描述"
    }
  },
  "required": ["fieldName"]
}
```

### 增强选项
- 添加 description 字段说明
- 添加 examples 示例值
- 设置 additionalProperties: false（严格模式）
- 用户可要求调整任何推断结果
PYEOF
;;

help|*)
cat << 'EOF'
╔══════════════════════════════════════════════╗
║        JSON Formatter — JSON 瑞士军刀       ║
╠══════════════════════════════════════════════╣
║                                              ║
║  用法: bash scripts/json.sh <command>        ║
║                                              ║
║  命令:                                       ║
║    format   — 格式化/美化JSON                ║
║    validate — 验证JSON合法性                 ║
║    convert  — JSON与YAML/XML/CSV互转         ║
║    minify   — 压缩JSON                       ║
║    diff     — 对比两段JSON差异               ║
║    schema   — 从JSON生成Schema               ║
║                                              ║
║  示例:                                       ║
║    bash scripts/json.sh format               ║
║    bash scripts/json.sh validate             ║
║    bash scripts/json.sh convert              ║
║                                              ║
╚══════════════════════════════════════════════╝

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
;;

esac
