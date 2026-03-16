# SQL Generator — tips.md

## SQL学习路线

### 入门（1-2周）
1. SELECT/WHERE/ORDER BY
2. INSERT/UPDATE/DELETE
3. 基本聚合（COUNT/SUM/AVG）
4. GROUP BY + HAVING

### 进阶（2-4周）
1. JOIN（INNER/LEFT/RIGHT/FULL）
2. 子查询（IN/EXISTS/相关子查询）
3. UNION/INTERSECT/EXCEPT
4. CASE WHEN表达式
5. 日期函数、字符串函数

### 高级（1-2月）
1. 窗口函数（ROW_NUMBER/RANK/LAG/LEAD）
2. CTE（WITH递归）
3. 索引原理和优化
4. 执行计划分析（EXPLAIN）
5. 事务和锁

## JOIN类型速查

```
  A ∩ B   → INNER JOIN （只要匹配的）
  A       → LEFT JOIN  （A全保留，B没匹配的为NULL）
      B   → RIGHT JOIN （B全保留）
  A ∪ B   → FULL JOIN  （两边都保留）
  A × B   → CROSS JOIN （笛卡尔积，一般不用）
```

## 性能优化Checklist
1. ✅ 避免 SELECT *，只查需要的列
2. ✅ WHERE条件加索引
3. ✅ 避免在WHERE中对列使用函数
4. ✅ 用JOIN替代子查询（大多数情况更快）
5. ✅ LIMIT限制返回行数
6. ✅ 避免LIKE '%xxx'（前缀通配无法用索引）
7. ✅ 用EXPLAIN分析执行计划
8. ✅ 避免在循环中执行SQL（用批量操作）

## 面试高频SQL题
1. 查找第N高的薪资
2. 连续登录N天的用户
3. 每个部门薪资TOP3
4. 行转列/列转行
5. 计算同比/环比增长率
