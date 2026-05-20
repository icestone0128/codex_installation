# Codex 實測懶人包總目錄

> 版本：2026-05-09 實測修正版
> 存放位置：Obsidian `專案庫/codex_installation/懶人包/`
> 來源：先前提供的 Codex 懶人包與本機實測紀錄

## 使用順序

1. [[00-連接-NotebookLM]]
2. [[01-Codex必裝Skills與Plugins]]
3. [[02-連接-GitHub]]
4. [[03-連接GitHub與Obsidian]]
5. [[04-建立第二大腦-Obsidian]]
6. [[05-第二大腦設定指南]]
7. [[06-連接-Firebase-資料庫]]
8. [[07-專案初始化工作模式]]
9. [[08-Codex-MCP-essentials]]
10. [[09-個人助手設定]]

## 本版共同修正

- 專案名稱與資料夾盡量使用無空格命名，例如 `codex_installation`。
- Obsidian 專案駕駛艙一律放在 `專案庫/<專案名稱>/專案工作流程.md`。
- Codex 全域規則寫在 `/Users/arrywu/.codex/AGENTS.md`。
- 專案固定規則寫在專案根目錄 `AGENTS.md`。
- 實際進度、踩坑與下一步寫在 Obsidian 專案駕駛艙，不寫進專案 `AGENTS.md`。
- MCP 或 skills 設定改完後，通常要重開 Codex 對話或重啟 Codex App 才會載入。
- Firebase Project ID 不能改名；資料夾改名後要同步更新 Firebase MCP 的 project directory。
- 不把 `.env`、API key、token、密碼、Admin 憑證、個資或敏感資料寫入 repo 或筆記。
- MCP 設定使用 `/Users/arrywu/.codex/config.toml`；不要把 Claude Code CLI 的 `~/.claude.json` 指令直接套用到 Codex App。
- 需要 API key 的 MCP 只能記錄遮蔽範例，實際密鑰不可提交。
- 個人助手設定以 `09-個人助手設定` 為準；舊 Agent Folder 文檔只作為轉換來源，不直接照做。

## 固定路徑

- Codex 專案工作資料夾：`/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation`
- Obsidian vault：`/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/secondbrain`
- Obsidian 專案庫：`/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/secondbrain/專案庫`
- NotebookLM 輸出資料夾：`/Users/arrywu/Documents/NotebookLM`
