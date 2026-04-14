# Amazon 运营全自动学习系统

> 没有账号，没有老师，用 AI 模拟 300 次真实运营决策，12周达到可独立上岗的水平。

基于 **Claude Code + Obsidian** 构建。每天花 50 分钟，系统自动完成：知识输入 → 场景模拟 → 测验追踪 → 进度可视化。

---

## 这是什么

一套用 AI 驱动的亚马逊运营学习工具，解决三个核心问题：

| 传统学习的痛点 | 本系统的解法 |
|-------------|------------|
| 看完视频以为会了，实际一片空白 | 每次学习后强制测验，答错才算学会 |
| 没有真实账号无法练习决策 | 虚拟店铺模拟器，零成本做真实操盘 |
| 不知道自己处于什么水平 | Obsidian 看板实时显示掌握度 + 面试就绪度 |

---

## 效果演示

**每日学习（`/amazon-learn`）**

自动生成结构化知识笔记，写入 Obsidian 知识库：

```
今日主题：Listing 标题优化
→ 自动搜索内容
→ 生成：核心概念 / 操作步骤 / 数据标准 / 常见错误
→ 写入 vault/knowledge/Listing标题优化.md
→ 触发测验
```

**虚拟店铺模拟（`/amazon-simulate`）**

```
今日店铺数据：
BSR: 8,200 ↑  日销: 11单  ACoS: 31.2% ⚠️

触发事件：广告 ACoS 连续3天超过30%

决策问题：
1. 你会怎么调整竞价策略？
2. 哪些关键词应该被否定？
3. 预算是否需要重新分配？

→ 你的回答 → AI评分 → 标准答案对比 → 更新店铺状态
```

**Obsidian 学习看板**

![看板示意](https://via.placeholder.com/800x400?text=Obsidian+Dashboard)

---

## 四个核心指令

| 指令 | 作用 | 建议时间 |
|------|------|---------|
| `/amazon-learn` | 今日知识学习，自动写入笔记 | 每天早上 |
| `/amazon-simulate` | 虚拟店铺运营，做决策拿评分 | 每天晚上 |
| `/amazon-quiz` | 知识测验，追踪薄弱点 | learn 后自动触发 |
| `/amazon-report` | 生成周报，计算面试就绪度 | 每周日 |

---

## 12周学习路径

```
Phase 1（Week 1-3）  基础建立
├── Week 1：Amazon 平台基础 / Seller Central
├── Week 2：Listing 标题 / 关键词研究
└── Week 3：图片规范 / A+ 内容

Phase 2（Week 4-6）  核心运营
├── Week 4：FBA 发货 / 头程物流
├── Week 5：库存管理 / IPI 分数
└── Week 6：广告 SP 基础

Phase 3（Week 7-9）  分析决策
├── Week 7：广告进阶 / ACoS 优化
├── Week 8：账号健康 / 申诉 POA
└── Week 9：Business Report / Brand Analytics

Phase 4（Week 10-12）  综合实战
├── Week 10：SB/SD 广告 / 品牌推广
├── Week 11：竞品分析 / 选品公式
└── Week 12：模拟面试 / 作品集
```

**毕业标准：** 面试就绪度 ≥ 80% / 模拟均分连续14天 ≥ 75分 / 虚拟店铺 BSR 从12,000 提升至 <4,000

---

## 快速开始

### 前置要求

- [Claude Code](https://claude.ai/code) （需订阅）
- [Obsidian](https://obsidian.md) （免费）
- Node.js v18+（`brew install node`）

### 安装

```bash
# 克隆仓库
git clone https://github.com/nevergobald/amazon-ops-learning.git
cd amazon-ops-learning

# 一键安装
bash install.sh
```

安装完成后：

1. 用 Obsidian 打开 `vault/` 目录
2. 安装插件：**Dataview** + **Templater**（Settings → Community plugins）
3. 在 Claude Code 中进入项目目录，输入 `/amazon-learn` 开始

### 每日使用

```bash
# 早上：学习
/amazon-learn

# 晚上：模拟
/amazon-simulate

# 每周日：周报
/amazon-report
```

---

## 系统架构

```
Skill 层   /amazon-learn  /amazon-simulate  /amazon-quiz  /amazon-report
              ↓ 定义工作流
Agent 层   Claude 读取指令 → 理解上下文 → 执行任务
              ↓ 读写数据
数据层     Obsidian Vault（知识库 / 模拟日志 / 进度看板）
```

**MCP（Model Context Protocol）** 是连接 Claude 和 Obsidian 的通道，让 AI 能直接读写你的笔记文件，实现真正的自动化。

---

## 文件结构

```
amazon-ops-learning/
├── install.sh                   # 一键安装脚本
├── skills/                      # 四个 Claude Code Skill
│   ├── amazon-learn/
│   ├── amazon-simulate/
│   ├── amazon-quiz/
│   └── amazon-report/
└── vault/                       # Obsidian Vault
    ├── store-state.json         # 虚拟店铺状态（游戏存档）
    ├── dashboard/               # 学习看板 + 课程路线图
    ├── knowledge/               # 知识笔记（自动生成）
    ├── simulation/              # 每日模拟日志
    └── quiz/                    # 测验记录 + 薄弱点追踪
```

---

## 常见问题

**需要真实的亚马逊账号吗？**
不需要。虚拟店铺基于真实数据模型构建，所有练习在本地完成。

**学习内容可以自定义吗？**
可以。直接编辑 `vault/dashboard/roadmap.md` 中的"今日学习主题"，系统会按你写的内容执行。

**支持其他 AI 模型吗？**
Skill 本质是提示词模板，理论上可以迁移到任何支持工具调用的 LLM。详见 [迁移指南]。

---

## License

MIT — 自由使用和修改，欢迎 PR。

---

*如果这个项目对你有帮助，欢迎 Star ⭐*
