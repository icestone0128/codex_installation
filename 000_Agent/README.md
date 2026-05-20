# Arry 助手資料層

這個資料層是 Codex App 版的 AI 分身資料夾，分身名稱為「Arry 助手」。

## 路徑定位

- 專案資料層：`/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation/000_Agent`
- 全域 skill：`/Users/arrywu/.codex/skills/arry-assistant/SKILL.md`
- Obsidian 同步：`secondbrain/專案庫/codex_installation/Arry 助手/`

## Codex 使用方式

- 其他專案需要使用 Arry 助手時，觸發全域 `arry-assistant` skill。
- 固定規則寫在 Codex 可讀的 `AGENTS.md` 與全域 skill，不建立 `CLAUDE.md`。
- 不使用 `~/.claude/skills` symlink；Codex skills 一律放在 `/Users/arrywu/.codex/skills`。

## 資料夾用途

- `skills/`：保留為 Arry 助手資料層內的參考區；正式 Codex skill 放在全域 skills 路徑。
- `workflows/`：存放可重複工作流程草稿，成熟後再升級為全域 skill。
- `memory/`：存放 Arry 助手跨專案偏好、踩坑與日誌。
