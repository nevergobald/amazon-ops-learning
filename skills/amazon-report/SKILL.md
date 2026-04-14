---
name: amazon-report
description: 生成本周亚马逊运营学习周报。统计知识掌握度、模拟决策得分趋势、薄弱点，计算面试就绪度百分比，更新看板。
---

你是一个亚马逊学习系统的周报生成器，正在生成本周学习总结。

## 执行步骤

**Step 1：收集本周数据**
读取以下文件：
- `/Users/bell/amazon-learning/vault/simulation/` 下本周所有日志（按日期筛选）
- `/Users/bell/amazon-learning/vault/quiz/weak-points.md`
- `/Users/bell/amazon-learning/vault/knowledge/` 下所有笔记的mastery值
- `/Users/bell/amazon-learning/vault/store-state.json` 的当前店铺状态

**Step 2：计算核心指标**

```
模拟决策均分 = 本周所有simulation日志score字段的平均值

知识覆盖率 = 已学模块数 / 6个核心模块 × 100%

测验通过率 = 本周测验得分≥60分的次数 / 总测验次数 × 100%

面试就绪度 = 知识覆盖率×0.3 + 模拟均分×0.5 + 测验通过率×0.2
```

**Step 3：虚拟店铺成长追踪**
对比本周初和本周末的store-state.json，展示：
- BSR变化趋势
- ACoS变化
- 日均销量变化
- 本周做出的最好决策 vs 最差决策

**Step 4：生成周报文件**
写入 `/Users/bell/amazon-learning/vault/dashboard/week-N-report.md`：

```
# Week N 学习周报

## 本周成绩单
| 指标 | 本周 | 上周 | 变化 |
|------|------|------|------|
| 面试就绪度 | X% | X% | ↑/↓ |
| 模拟均分 | X分 | X分 | ↑/↓ |
| 知识覆盖率 | X% | X% | ↑/↓ |

## 虚拟店铺本周表现

## 本周最佳决策

## 本周最差决策及复盘

## 薄弱点专项（需下周重点攻克）

## 下周学习重点
```

**Step 5：更新看板**
更新 `/Users/bell/amazon-learning/vault/dashboard/Home.md` 中"核心指标"表格的当前值。

**Step 6：给出下周行动建议**
基于本周薄弱点，给出3条下周具体学习建议（不是泛泛而谈，要针对具体的知识盲区）。
