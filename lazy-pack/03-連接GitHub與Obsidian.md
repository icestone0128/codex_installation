# 03-連接 GitHub 與 Obsidian

## 目標

讓 Codex 同時能操作 GitHub 與 Obsidian，並把專案紀錄與版本控制分工清楚。

## 分工

- GitHub：程式碼、版本、GitHub Pages、Issue / PR。
- Obsidian：專案駕駛艙、進度、下一步、踩坑、SOP。
- Codex：讀取專案 `AGENTS.md` 與 Obsidian 駕駛艙，協助執行。

## Obsidian MCP 實測設定

使用 `mcpvault`：

```toml
[mcp_servers.obsidian]
command = "/opt/homebrew/bin/mcpvault"
args = ["/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/secondbrain"]
startup_timeout_sec = 20
tool_timeout_sec = 60
```

## 專案駕駛艙新規則

所有 Codex 專案駕駛艙一律放在：

`專案庫/<專案名稱>/專案工作流程.md`

例如：

`專案庫/codex_installation/專案工作流程.md`

## 踩坑修正

- 不要把專案駕駛艙建在工作資料夾 repo 裡；它應該在 Obsidian vault 內。
- Obsidian Web Clipper 的 vault 名稱要和 Obsidian Desktop 開啟的 vault 完全一致。
- 曾發生 Web Clipper URL 帶 `vault=Codex`，但真正 vault 是 `secondbrain`，導致 `Vault not found`。
- Google Drive 資料夾名稱有空格時，部分補丁或工具處理會不穩；新專案優先用底線命名。
- Codex 側邊欄不一定即時反映資料夾改名，需要重新開啟專案或重啟 App。

