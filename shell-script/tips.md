# Shell Script Helper — tips.md
## Bash最佳实践
1. 开头加 `set -euo pipefail`（出错即停、未定义变量报错、管道错误传播）
2. 变量双引号包裹 `"$var"`（防止空格/特殊字符问题）
3. 用 `[[ ]]` 代替 `[ ]`（更安全、支持正则）
4. 用 `$(command)` 代替反引号
5. 函数内用 `local` 声明局部变量
6. 长脚本加 `trap cleanup EXIT` 清理资源

## 常用模式
```bash
# 参数检查
[ $# -lt 1 ] && { echo "Usage: $0 <arg>"; exit 1; }

# 默认值
NAME="${1:-default}"

# 文件逐行读取
while IFS= read -r line; do echo "$line"; done < file.txt

# 并行执行
for f in *.txt; do process "$f" & done; wait

# 带超时
timeout 30 command || echo "Timeout!"
```
