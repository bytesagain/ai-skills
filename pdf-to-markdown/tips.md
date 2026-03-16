# Markdown 语法完整参考 / Markdown Syntax Reference

> PDF to Markdown 技能参考文档
> 完整的 Markdown 语法速查手册

---

## 1. 标题 (Headings)

```markdown
# 一级标题 (H1)
## 二级标题 (H2)
### 三级标题 (H3)
#### 四级标题 (H4)
##### 五级标题 (H5)
###### 六级标题 (H6)
```

**最佳实践：**
- 一篇文档只用一个 H1
- 不要跳过层级（H2 后直接 H4）
- `#` 后面加空格

---

## 2. 段落与换行

```markdown
这是第一段。

这是第二段。（空行分隔段落）

这是一行末尾加两个空格  
实现段内换行。
```

---

## 3. 强调 (Emphasis)

```markdown
*斜体* 或 _斜体_
**粗体** 或 __粗体__
***粗斜体*** 或 ___粗斜体___
~~删除线~~
==高亮==（部分渲染器支持）
```

---

## 4. 列表 (Lists)

### 无序列表
```markdown
- 项目一
- 项目二
  - 子项目
  - 子项目
- 项目三
```

### 有序列表
```markdown
1. 第一步
2. 第二步
3. 第三步
   1. 子步骤
   2. 子步骤
```

### 任务列表
```markdown
- [x] 已完成任务
- [ ] 待办任务
- [ ] 另一个待办
```

---

## 5. 表格 (Tables)

```markdown
| 列1 | 列2 | 列3 |
|------|:----:|-----:|
| 左对齐 | 居中 | 右对齐 |
| 数据 | 数据 | 数据 |
```

**对齐方式：**
- `:---` 左对齐（默认）
- `:---:` 居中
- `---:` 右对齐

**表格技巧：**
- 列宽由内容自动决定
- 可以在单元格中使用 **粗体**、*斜体*、`代码`
- 不支持合并单元格（需用HTML）

---

## 6. 代码 (Code)

### 行内代码
```markdown
使用 `print()` 函数输出
```

### 代码块
````markdown
```python
def hello():
    print("Hello, World!")
```
````

### 常用语言标识
`python` `javascript` `sql` `bash` `json` `html` `css` `java` `go` `rust` `typescript` `yaml` `xml` `markdown`

---

## 7. 链接 (Links)

```markdown
[显示文本](https://example.com)
[带标题的链接](https://example.com "鼠标悬停提示")
<https://example.com>（自动链接）
[引用式链接][1]

[1]: https://example.com "引用式"
```

---

## 8. 图片 (Images)

```markdown
![替代文本](image.png)
![带标题](image.png "图片标题")

<!-- 调整大小（HTML） -->
<img src="image.png" width="300" alt="描述">
```

---

## 9. 引用 (Blockquotes)

```markdown
> 这是一段引用
> 可以多行

> 嵌套引用
>> 第二层
>>> 第三层
```

---

## 10. 分隔线 (Horizontal Rules)

```markdown
---
***
___
```

---

## 11. 数学公式 (Math)

### 行内公式
```markdown
这是行内公式 $E = mc^2$
```

### 块级公式
```markdown
$$
\sum_{i=1}^{n} x_i = x_1 + x_2 + \cdots + x_n
$$
```

### 常用公式语法
```
上标: x^2
下标: x_i
分数: \frac{a}{b}
根号: \sqrt{x}
求和: \sum_{i=1}^{n}
积分: \int_{a}^{b}
矩阵: \begin{bmatrix} a & b \\ c & d \end{bmatrix}
```

---

## 12. 脚注 (Footnotes)

```markdown
这是一段文字[^1]，这是另一个引用[^note]。

[^1]: 这是脚注内容。
[^note]: 这是具名脚注。
```

---

## 13. 定义列表 (Definition Lists)

```markdown
术语
: 定义内容

另一个术语
: 定义一
: 定义二
```

---

## 14. HTML 内嵌

```markdown
<details>
<summary>点击展开</summary>

隐藏的内容。

</details>

<kbd>Ctrl</kbd> + <kbd>C</kbd>

<mark>高亮文字</mark>

上标: X<sup>2</sup>
下标: H<sub>2</sub>O
```

---

## 15. 转义字符

以下字符需要反斜杠转义：

```
\   反斜杠
`   反引号
*   星号
_   下划线
{}  花括号
[]  方括号
()  圆括号
#   井号
+   加号
-   减号
.   点
!   感叹号
|   管道符
```

---

## 16. PDF转Markdown 常见问题

### 断行修复
PDF复制的文本常有不正确的换行：
```
原文：这是一段很长的文字被
PDF格式强制换行了。

修复：这是一段很长的文字被PDF格式强制换行了。
```

### 标题识别
常见PDF标题模式：
- `第一章 标题` → `## 第一章 标题`
- `1.1 标题` → `## 1.1 标题`
- `一、标题` → `## 一、标题`
- 全大写或加粗文字通常是标题

### 表格还原
PDF表格复制后通常丢失格式：
- 用空格或Tab分隔的列 → Markdown表格
- 注意对齐，检查列数是否一致

### 特殊字符处理
- 全角标点 → 保留（中文文档）
- 连字符 → 检查是否是断字
- 页码/页眉页脚 → 删除

---

## 17. 最佳实践

1. **一致性**: 选定一种风格后保持一致
2. **空行**: 块元素（标题、列表、代码块）前后空一行
3. **缩进**: 嵌套列表用2或4空格（保持一致）
4. **行长**: 建议每行不超过80字符（代码除外）
5. **文件命名**: 使用小写+连字符：`my-document.md`

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
