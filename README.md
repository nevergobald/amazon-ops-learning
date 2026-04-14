# Amazon 运营学习系统
## 完整搭建与使用说明

> 基于 Claude Code + Obsidian 构建的全自动跨境电商运营学习系统。
> 通过 AI 驱动的知识输入、模拟决策、测验追踪，12周达到可独立上岗的运营能力。

---

## 目录

1. [系统概述](#1-系统概述)
2. [环境要求](#2-环境要求)
3. [安装步骤](#3-安装步骤)
4. [目录结构说明](#4-目录结构说明)
5. [四个核心指令](#5-四个核心指令)
6. [12周学习路径](#6-12周学习路径)
7. [Obsidian 配置](#7-obsidian-配置)
8. [日常使用流程](#8-日常使用流程)
9. [验收标准](#9-验收标准)
10. [常见问题](#10-常见问题)

---

## 1. 系统概述

### 设计目标

解决跨境电商学习的三大痛点：

| 痛点 | 本系统的解法 |
|------|------------|
| 只有输入没有反馈 | 每次学习后自动触发测验，强制输出 |
| 没有账号无法练习 | 虚拟店铺模拟器，零成本做真实决策 |
| 进度不可量化 | Obsidian 看板实时显示掌握度和面试就绪度 |

### 三层架构

```
Skill 层（工作流）  →  定义"做什么"
     ↓
Agent 层（Claude）  →  负责理解和执行
     ↓
数据层（Obsidian）  →  存储所有学习记录
```

### 四个核心指令

```
/amazon-learn     每日知识学习，自动写入笔记
/amazon-simulate  虚拟店铺运营模拟，做决策拿评分
/amazon-quiz      知识测验，追踪薄弱点
/amazon-report    周报，计算面试就绪度
```

---

## 2. 环境要求

| 工具 | 版本要求 | 用途 |
|------|---------|------|
| macOS | 任意 | 运行环境 |
| Claude Code | 最新版 | AI 执行引擎 |
| Obsidian | 最新版 | 知识库可视化 |
| Node.js | v18+ | 运行 MCP 服务 |
| Homebrew | 任意 | 包管理 |

---

## 3. 安装步骤

### Step 1：安装基础工具

```bash
# 安装 Node.js（如果未安装）
brew install node

# 验证版本
node --version  # 应显示 v18 或以上
```

### Step 2：安装 Obsidian

前往 obsidian.md 下载安装，或：

```bash
brew install --cask obsidian
```

### Step 3：克隆/创建项目目录

```bash
# 创建项目目录
mkdir -p ~/amazon-learning/vault/{knowledge,simulation,quiz,portfolio,templates,dashboard}
```

### Step 4：初始化 MCP 配置

在 `~/amazon-learning/` 目录下创建 `.mcp.json`：

```json
{
  "mcpServers": {
    "amazon-vault": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/你的用户名/amazon-learning/vault"
      ]
    }
  }
}
```

> 注意：将 `你的用户名` 替换为你的 macOS 用户名（用 `whoami` 命令查看）

### Step 5：初始化虚拟店铺状态

创建 `~/amazon-learning/vault/store-state.json`：

```json
{
  "meta": {
    "day": 1,
    "start_date": "你的开始日期",
    "phase": "launch",
    "total_score": 0,
    "decision_count": 0
  },
  "product": {
    "name": "不锈钢厨房刀具套装5件",
    "category": "Kitchen & Dining",
    "price": 39.99,
    "cost": 12.50,
    "asin": "MOCK_B09KNIFE5"
  },
  "performance": {
    "bsr": 12000,
    "sessions": 45,
    "units_sold": 3,
    "conversion_rate": 6.7,
    "reviews": 12,
    "rating": 4.1
  },
  "inventory": {
    "fba_stock": 180,
    "inbound": 0,
    "days_of_supply": 60,
    "reorder_triggered": false
  },
  "advertising": {
    "daily_budget": 20,
    "spend": 8.5,
    "ad_sales": 39.99,
    "acos": 21.3,
    "impressions": 3200,
    "clicks": 22,
    "ctr": 0.69
  },
  "account_health": {
    "odr": 0.2,
    "late_shipment_rate": 0,
    "valid_tracking_rate": 100,
    "status": "healthy"
  },
  "history": []
}
```

### Step 6：安装 Skill 文件

每个 Skill 是 `~/.claude/skills/` 下的一个目录，包含 `SKILL.md`。

**目录结构：**
```
~/.claude/skills/
├── amazon-learn/
│   └── SKILL.md
├── amazon-simulate/
│   └── SKILL.md
├── amazon-quiz/
│   └── SKILL.md
└── amazon-report/
    └── SKILL.md
```

创建命令：
```bash
mkdir -p ~/.claude/skills/amazon-learn
mkdir -p ~/.claude/skills/amazon-simulate
mkdir -p ~/.claude/skills/amazon-quiz
mkdir -p ~/.claude/skills/amazon-report
```

各 Skill 的 `SKILL.md` 内容见附录 A。

### Step 7：在 Obsidian 打开 Vault

1. 打开 Obsidian
2. 点击 `Open folder as vault`
3. 选择 `~/amazon-learning/vault`
4. 进入 Settings → Community plugins → 开启社区插件
5. 搜索并安装：**Dataview**、**Templater**
6. 安装后将两个插件的开关拨为紫色（启用）

### Step 8：验证安装

在 Claude Code 中输入：

```
/amazon-learn
```

若在 `vault/knowledge/` 下生成了新的 `.md` 文件，说明安装成功。

---

## 4. 目录结构说明

```
amazon-learning/
├── .mcp.json                    ← MCP 配置，让 Claude 能读写 vault
├── README.md                    ← 本文档
└── vault/                       ← Obsidian Vault 根目录
    ├── store-state.json         ← 虚拟店铺当前状态（核心数据）
    ├── dashboard/
    │   ├── Home.md              ← 总看板（Dataview 渲染）
    │   ├── roadmap.md           ← 12周课程表 + 今日主题
    │   └── week-N-report.md     ← 每周自动生成的周报
    ├── knowledge/               ← 知识笔记（/amazon-learn 自动写入）
    │   ├── Amazon平台基础认知.md
    │   ├── Listing优化.md
    │   └── ...
    ├── simulation/              ← 每日运营模拟记录
    │   ├── 2026-04-14.md
    │   └── ...
    ├── quiz/                    ← 测验记录
    │   └── weak-points.md       ← 薄弱点追踪
    ├── portfolio/               ← 作品集（面试用）
    └── templates/               ← 笔记模板
```

### 关键文件说明

**`store-state.json`**
虚拟店铺的完整状态，每次 `/amazon-simulate` 后自动更新。记录 BSR、销量、广告数据、库存、账号健康等指标，是模拟器的"游戏存档"。

**`roadmap.md`**
12周课程表 + 今日学习主题。`/amazon-learn` 从这里读取今日任务，完成后自动更新明日主题。

**`weak-points.md`**
测验答错的知识点自动追加。下次测验时优先从这里选题，形成针对性复习闭环。

**`Home.md`**
Dataview 驱动的实时看板，自动聚合所有学习数据，无需手动更新。

---

## 5. 四个核心指令

### `/amazon-learn`

**触发时机：** 每日开始学习时

**执行过程：**
```
1. 读取 roadmap.md → 获取今日主题
2. 基于 Claude 内置知识生成结构化笔记
3. 写入 vault/knowledge/[主题].md
4. 更新 roadmap.md（标记完成 + 写入明日主题）
5. 提示用户运行 /amazon-quiz
```

**输出：** 一篇包含核心概念/操作步骤/数据标准/常见错误的知识笔记

---

### `/amazon-simulate`

**触发时机：** 每日完成学习后，或单独练习决策

**执行过程：**
```
1. 读取 store-state.json → 获取店铺当前状态
2. 生成今日数据波动 + 随机触发 1-2 个运营事件
3. 展示今日运营日报（表格形式）
4. 提出 3 个决策问题，逐一等待回答
5. 对每个决策评分（方向40% + 数据依据30% + 可操作性30%）
6. 给出标准答案对比
7. 更新 store-state.json + 写入 simulation/YYYY-MM-DD.md
```

**输出：** 决策评分 + 店铺状态演变 + 日志记录

**事件库示例：**

| 阶段 | 可能触发的事件 |
|------|--------------|
| 新品期（Day 1-14） | 首批差评/竞品跟卖/广告ACoS超标/库存消耗异常 |
| 成长期（Day 15-30） | BSR进入Top 5000/高转化词出现/FBA库存预警 |
| 稳定期（Day 31+） | 竞品降价/大促报名/预算超支/Listing优化机会 |

---

### `/amazon-quiz`

**触发时机：** 每次 `/amazon-learn` 完成后，或主动复习

**执行过程：**
```
1. 读取 knowledge/ 下 mastery 最低的笔记
2. 生成 5 道题（严格基于当日笔记内容）
3. 逐题展示，即时评分和解析
4. 测验结束：汇总得分 + 更新 mastery + 追加薄弱点
```

**题型结构：**

| 题号 | 类型 | 考核重点 |
|------|------|---------|
| 第1题 | 是非判断 | 核心概念理解 |
| 第2题 | 是非判断 | 容易混淆的错误认知 |
| 第3题 | 场景分析 | 数据标准的实际应用 |
| 第4题 | 场景决策 | 操作步骤的综合运用 |
| 第5题 | 开放应用 | 笔记内容的迁移理解 |

**mastery 更新规则：**

```
5题全对 → mastery +30
3-4题对 → mastery +15
1-2题对 → mastery +5
0题对   → mastery 不变，标记需重点复习
```

---

### `/amazon-report`

**触发时机：** 每周日，或需要了解整体进度时

**执行过程：**
```
1. 读取本周所有 simulation/ 日志 → 计算决策均分
2. 读取 weak-points.md → 统计未解决薄弱点
3. 读取所有 knowledge/ 笔记的 mastery 值
4. 计算面试就绪度
5. 生成周报写入 dashboard/week-N-report.md
6. 更新 Home.md 核心指标
```

**面试就绪度公式：**

```
面试就绪度 = 知识覆盖率 × 30%
           + 模拟决策均分 × 50%
           + 测验通过率 × 20%
```

---

## 6. 12周学习路径

### 整体规划

| 阶段 | 周次 | 核心内容 | 里程碑 |
|------|------|---------|--------|
| Phase 1 基础 | Week 1-3 | 平台认知/Listing/图片A+ | 能独立写出80分Listing |
| Phase 2 运营 | Week 4-6 | FBA/广告基础/广告进阶 | 能看懂搜索词报告做调整 |
| Phase 3 分析 | Week 7-9 | 账号健康/数据分析/SB广告 | 能独立做运营日报 |
| Phase 4 实战 | Week 10-12 | 竞品选品/综合压测/面试 | 面试就绪度 >80% |

### 每日标准流程

```
早上（30分钟）
└── /amazon-learn → 生成今日知识笔记 → 自动触发 /amazon-quiz

晚上（20分钟）
└── /amazon-simulate → 查看今日店铺数据 → 做3个运营决策

每周日（10分钟）
└── /amazon-report → 查看周报 → 确认下周学习重点
```

---

## 7. Obsidian 配置

### 必装插件

| 插件 | 用途 |
|------|------|
| Dataview | 渲染 Home.md 的动态表格 |
| Templater | 笔记模板自动填充 |

### 安装方法

```
Settings → Community plugins → Turn on community plugins
→ Browse → 搜索 Dataview → Install → Enable
→ Browse → 搜索 Templater → Install → Enable
```

### Home.md 看板说明

打开 `vault/dashboard/Home.md`，Dataview 会自动渲染三个动态区域：

**知识库掌握度表**
显示所有知识笔记的 mastery 值，按升序排列，帮助识别最薄弱的模块。

**本周模拟记录表**
显示最近7天的模拟日志，包括每日得分和触发事件。

**薄弱点清单**
直接显示 `quiz/weak-points.md` 中的待攻克列表。

---

## 8. 日常使用流程

### 第一次使用

```bash
# 1. 确认在正确目录
cd ~/amazon-learning

# 2. 在 Obsidian 打开 vault，确认 Home.md 正常渲染

# 3. 运行第一次学习
/amazon-learn

# 4. 完成测验
/amazon-quiz

# 5. 晚上运行模拟
/amazon-simulate
```

### 日常使用（第2天起）

```
早上：/amazon-learn
      ↓（自动触发）
      /amazon-quiz

晚上：/amazon-simulate

每周日：/amazon-report
```

### 如何查看学习进度

1. 打开 Obsidian → `dashboard/Home.md`
2. 核心指标表显示当前面试就绪度
3. 知识库表显示各模块 mastery 值
4. 模拟记录表显示近7天决策得分趋势

### 如何复习薄弱点

```
/amazon-quiz
```
系统自动优先对 mastery 最低的笔记出题，无需手动指定。

---

## 9. 验收标准

### 阶段验收

| 时间节点 | 验收内容 | 通过标准 |
|---------|---------|---------|
| Week 3末 | Listing 优化测试 | AI 评分 >70分 |
| Week 6末 | 广告报表解读 | 调整方向无明显错误 |
| Week 9末 | 连续7天模拟 | 均分 >75分 |
| Week 12末 | AI 模拟面试 | 通过率 >80% |

### 毕业标准（可投简历）

```
□ 面试就绪度指数 ≥ 80%
□ 模拟均分连续14天 ≥ 75分
□ 虚拟店铺 BSR < 4,000（从初始12,000）
□ 完成作品集：3个Listing优化案例 + 1份选品报告
□ AI 模拟面试10题通过率 ≥ 80%
```

### 虚拟店铺目标状态

| 指标 | 初始值 | 12周目标 |
|------|--------|---------|
| BSR | 12,000 | <4,000 |
| 日销量 | 3单 | 15-20单 |
| ACoS | 21.3% | <18% |
| 评分 | 4.1 | 4.4+ |
| 库存健康 | 60天 | 30-45天 |

---

## 10. 常见问题

**Q：Skill 提示 Unknown skill？**
检查 `~/.claude/skills/amazon-learn/` 目录下是否有 `SKILL.md` 文件（不是 `.md` 文件放在 skills 根目录下）。

**Q：Obsidian 的 Dataview 表格不显示数据？**
确认 Dataview 插件开关是紫色（已启用），并确认 knowledge/ 目录下有笔记文件。

**Q：`/amazon-simulate` 说找不到 store-state.json？**
确认文件路径是 `vault/store-state.json`，不是 `vault/dashboard/` 或其他子目录。

**Q：能跳过某天不学习吗？**
可以，roadmap.md 不会自动推进，只有运行 `/amazon-learn` 才会更新进度。

**Q：能修改虚拟店铺的产品吗？**
可以直接编辑 `store-state.json` 的 product 字段，改成你感兴趣的类目和产品。

**Q：想重新开始模拟器怎么办？**
将 `store-state.json` 的 `meta.day` 改回 1，`performance/inventory/advertising` 改回初始值即可。

---

## 附录 A：Skill 文件内容

Skill 文件存放路径：`~/.claude/skills/[skill名称]/SKILL.md`

完整内容参见项目 `skills-backup/` 目录，或联系系统管理员获取。

---

## 附录 B：知识笔记模板

每篇知识笔记的标准格式：

```markdown
---
tags: [标签1, 标签2]
date: YYYY-MM-DD
week: WeekN
mastery: 0
---

## 一句话总结

## 核心概念

## 操作步骤
1. 
2. 
3. 

## 关键数据标准
| 指标 | 健康值 | 警戒值 |
|------|--------|--------|

## 常见错误

## 关联知识
[[相关笔记]]
```

---

*本系统基于 Claude Code + Obsidian 构建，学习内容覆盖亚马逊运营全流程。*
*如需迁移到其他 AI 工具（DeepSeek/文心等），参见设计文档中的替换方案章节。*
