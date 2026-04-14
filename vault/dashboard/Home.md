# Amazon 运营学习看板

> 开始日期：2026-04-14 | 目标岗位：亚马逊运营/运营助理

## 核心指标

| 指标 | 当前值 | 目标值 |
|------|--------|--------|
| 面试就绪度 | 0% | >80% |
| 模拟得分均值 | - | >75分 |
| 知识模块覆盖 | 0/6 | 6/6 |
| 虚拟店铺BSR | 12,000 | <4,000 |
| 虚拟店铺ACoS | 21.3% | <18% |

## 知识库掌握度

```dataview
table mastery as "掌握度(%)", week as "学习周", date as "最后更新"
from "knowledge"
sort mastery asc
```

## 本周模拟记录

```dataview
table score as "得分", event as "今日事件"
from "simulation"
where date >= date(today) - dur(7 days)
sort file.name desc
```

## 薄弱点清单

```dataview
list
from "quiz"
where file.name = "weak-points"
```

## 快速指令
- `/amazon-learn` → 触发今日学习
- `/amazon-simulate` → 触发今日运营模拟
- `/amazon-quiz` → 触发知识测验
- `/amazon-report` → 生成本周报告
