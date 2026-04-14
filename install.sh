#!/bin/bash

set -e

# ─────────────────────────────────────────
#  Amazon 运营学习系统 一键安装脚本
# ─────────────────────────────────────────

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
VAULT_PATH="$REPO_DIR/vault"
SKILLS_SRC="$REPO_DIR/skills"
SKILLS_DST="$HOME/.claude/skills"
TODAY="$(date +%Y-%m-%d)"

echo ""
echo "======================================="
echo "   Amazon 运营学习系统 安装程序"
echo "======================================="
echo ""
echo "安装目录：$REPO_DIR"
echo ""

# ── Step 1：检查依赖 ──────────────────────
echo ">> 检查环境依赖..."

MISSING=0

if ! command -v node &>/dev/null; then
  echo "  [✗] Node.js 未安装"
  echo "      请先执行：brew install node"
  MISSING=1
else
  echo "  [✓] Node.js $(node --version)"
fi

if ! command -v claude &>/dev/null; then
  echo "  [✗] Claude Code 未安装"
  echo "      请先安装 Claude Code：https://claude.ai/code"
  MISSING=1
else
  echo "  [✓] Claude Code 已安装"
fi

if [ $MISSING -eq 1 ]; then
  echo ""
  echo "请先解决以上依赖问题后重新运行安装脚本。"
  exit 1
fi

# ── Step 2：创建 vault 目录 ───────────────
echo ""
echo ">> 初始化 Vault 目录..."

mkdir -p "$VAULT_PATH/knowledge"
mkdir -p "$VAULT_PATH/simulation"
mkdir -p "$VAULT_PATH/portfolio"
mkdir -p "$VAULT_PATH/templates"

echo "  [✓] Vault 目录结构已创建：$VAULT_PATH"

# ── Step 3：生成 .mcp.json ────────────────
echo ""
echo ">> 生成 MCP 配置..."

if [ ! -f "$REPO_DIR/.mcp.json.template" ]; then
  echo "  [✗] 找不到 .mcp.json.template，请确认仓库完整克隆"
  exit 1
fi

sed "s|{{VAULT_PATH}}|$VAULT_PATH|g" "$REPO_DIR/.mcp.json.template" > "$REPO_DIR/.mcp.json"

# 验证生成结果
if grep -q "$VAULT_PATH" "$REPO_DIR/.mcp.json"; then
  echo "  [✓] .mcp.json 已生成"
else
  echo "  [✗] .mcp.json 生成失败，请手动检查 .mcp.json.template"
  exit 1
fi

# ── Step 4：安装 Skill 文件 ───────────────
echo ""
echo ">> 安装 Skill 文件到 Claude Code..."

mkdir -p "$SKILLS_DST"

SKILL_OK=0
for skill in amazon-learn amazon-simulate amazon-quiz amazon-report; do
  SRC="$SKILLS_SRC/$skill/SKILL.md"
  DST_DIR="$SKILLS_DST/$skill"

  if [ ! -f "$SRC" ]; then
    echo "  [✗] 找不到 $skill/SKILL.md，请确认仓库完整克隆"
    SKILL_OK=1
    continue
  fi

  mkdir -p "$DST_DIR"
  cp "$SRC" "$DST_DIR/SKILL.md"
  echo "  [✓] /$skill 已安装"
done

if [ $SKILL_OK -eq 1 ]; then
  echo ""
  echo "部分 Skill 安装失败，请检查 skills/ 目录是否完整。"
  exit 1
fi

# ── Step 5：填写初始日期 ──────────────────
echo ""
echo ">> 初始化学习状态..."

# 更新 store-state.json 的 start_date
if [ -f "$VAULT_PATH/store-state.json" ]; then
  sed -i '' "s|\"start_date\": \"\"|\"start_date\": \"$TODAY\"|g" "$VAULT_PATH/store-state.json"
  echo "  [✓] 虚拟店铺开始日期设为：$TODAY"
fi

# 更新 roadmap.md 的开始日期
if [ -f "$VAULT_PATH/dashboard/roadmap.md" ]; then
  sed -i '' "s|开始日期：（安装后填写）|开始日期：$TODAY|g" "$VAULT_PATH/dashboard/roadmap.md"
  echo "  [✓] 学习路线图开始日期设为：$TODAY"
fi

# ── 完成 ──────────────────────────────────
echo ""
echo "======================================="
echo "   安装完成！"
echo "======================================="
echo ""
echo "下一步："
echo ""
echo "  1. 用 Obsidian 打开 vault 目录："
echo "     $VAULT_PATH"
echo ""
echo "  2. 在 Obsidian 安装两个插件："
echo "     Settings -> Community plugins"
echo "     搜索并安装：Dataview 和 Templater"
echo ""
echo "  3. 在 Claude Code 中进入项目目录："
echo "     cd $REPO_DIR"
echo ""
echo "  4. 开始第一天学习："
echo "     /amazon-learn"
echo ""
