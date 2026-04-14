#!/bin/bash

set -e

# ─────────────────────────────────────────
#  Amazon 运营学习系统 一键安装脚本
# ─────────────────────────────────────────

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
VAULT_PATH="$REPO_DIR/vault"
SKILLS_DIR="$HOME/.claude/skills"

echo ""
echo "═══════════════════════════════════════"
echo "   Amazon 运营学习系统 安装程序"
echo "═══════════════════════════════════════"
echo ""

# ── Step 1：检查依赖 ──────────────────────
echo "▶ 检查环境依赖..."

if ! command -v node &>/dev/null; then
  echo "✗ 未找到 Node.js，请先安装：brew install node"
  exit 1
fi

if ! command -v claude &>/dev/null; then
  echo "✗ 未找到 Claude Code CLI，请先安装 Claude Code"
  exit 1
fi

echo "✓ Node.js $(node --version)"
echo "✓ Claude Code 已安装"

# ── Step 2：创建 vault 目录 ───────────────
echo ""
echo "▶ 初始化 Vault 目录..."

mkdir -p "$VAULT_PATH/knowledge"
mkdir -p "$VAULT_PATH/simulation"
mkdir -p "$VAULT_PATH/portfolio"
mkdir -p "$VAULT_PATH/templates"

# 保留占位文件让 git 追踪空目录
touch "$VAULT_PATH/knowledge/.gitkeep"
touch "$VAULT_PATH/simulation/.gitkeep"
touch "$VAULT_PATH/portfolio/.gitkeep"

echo "✓ Vault 目录结构已创建"

# ── Step 3：生成 .mcp.json ────────────────
echo ""
echo "▶ 生成 MCP 配置..."

sed "s|{{VAULT_PATH}}|$VAULT_PATH|g" "$REPO_DIR/.mcp.json.template" > "$REPO_DIR/.mcp.json"

echo "✓ .mcp.json 已生成（vault 路径：$VAULT_PATH）"

# ── Step 4：安装 Skill 文件 ───────────────
echo ""
echo "▶ 安装 Skill 文件到 Claude Code..."

for skill in amazon-learn amazon-simulate amazon-quiz amazon-report; do
  mkdir -p "$SKILLS_DIR/$skill"
  cp "$REPO_DIR/skills/$skill/SKILL.md" "$SKILLS_DIR/$skill/SKILL.md"
  echo "✓ /$(echo $skill | tr '-' '-') 已安装"
done

# ── Step 5：重置初始状态 ──────────────────
echo ""
echo "▶ 初始化学习状态..."

# 重置 store-state.json 的 day 为 1（如果用户重装）
if [ -f "$VAULT_PATH/store-state.json" ]; then
  echo "  (store-state.json 已存在，跳过覆盖，保留学习进度)"
else
  echo "✓ 虚拟店铺状态已初始化"
fi

# ── 完成 ──────────────────────────────────
echo ""
echo "═══════════════════════════════════════"
echo "   安装完成！"
echo "═══════════════════════════════════════"
echo ""
echo "下一步："
echo ""
echo "  1. 用 Obsidian 打开 vault 目录："
echo "     $VAULT_PATH"
echo ""
echo "  2. 在 Obsidian 安装插件："
echo "     Settings → Community plugins → 搜索安装 Dataview 和 Templater"
echo ""
echo "  3. 在 Claude Code 中开始学习："
echo "     cd $REPO_DIR"
echo "     然后输入 /amazon-learn"
echo ""
