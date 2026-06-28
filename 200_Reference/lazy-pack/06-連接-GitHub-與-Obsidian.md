# 06-連接-GitHub-與-Obsidian

## 目標

讓 Codex 同時能操作 GitHub 與 Obsidian，並把專案紀錄與版本控制分工清楚。

## 分工

- GitHub：程式碼、版本、GitHub Pages、Issue / PR。
- Obsidian：專案駕駛艙、進度、下一步、踩坑、SOP。
- Codex：讀取專案 `AGENTS.md` 與 Obsidian 駕駛艙，協助執行。

## 前置條件

- 已完成 `03-連接-GitHub`。
- 已建立 Obsidian vault：`{{OBSIDIAN_VAULT}}`。
- 已決定專案工作根目錄：`{{WORK_ROOT}}`。

## Obsidian 存取方式

優先順序：

1. Codex 工作區或沙箱已授權讀寫 `{{OBSIDIAN_VAULT}}`。
2. 使用 Filesystem MCP 授權 `{{OBSIDIAN_VAULT}}` 或其上層必要資料夾。
3. 使用 Obsidian MCP，例如 `mcpvault`。

如果使用 `mcpvault`，先找 command：

```bash
command -v mcpvault
```

在 `{{CODEX_CONFIG}}` 加入：

```toml
[mcp_servers.obsidian]
command = "{{MCPVAULT_COMMAND}}"
args = ["{{OBSIDIAN_VAULT}}"]
startup_timeout_sec = 20
tool_timeout_sec = 60
```

## 專案駕駛艙規則

所有 Codex 專案駕駛艙一律放在：

```text
{{OBSIDIAN_PROJECTS}}/<專案名稱>/專案工作流程.md
```

不要把駕駛艙放在 repo 裡，避免把日常進度和程式碼版本混在一起。

## 專案 AGENTS.md 要寫什麼

每個專案根目錄建立 `AGENTS.md`，至少包含：

```markdown
# <專案名稱> — AGENTS.md

## 專案入口

- 工作資料夾：`{{WORK_ROOT}}/<專案名稱>`
- GitHub repo：`{{GITHUB_USER}}/<REPO_NAME>` 或 `未建立`
- Obsidian vault：`{{OBSIDIAN_VAULT}}`
- 專案駕駛艙：`專案庫/<專案名稱>/專案工作流程.md`

## 工作規則

- 開工先讀本檔與 Obsidian 駕駛艙。
- 收工更新 Obsidian 駕駛艙。
- 不把 secrets 寫進 repo 或筆記。
```

## 驗證

1. Codex 能讀專案 `AGENTS.md`。
2. Codex 能讀 Obsidian 駕駛艙。
3. `git remote -v` 能顯示 GitHub remote。
4. 收工時能清楚說明：repo 狀態、Obsidian 駕駛艙位置、下一步。

## 設定範例

可使用 `mcpvault` 指向自己的 Obsidian vault。下載者要改成自己的 `{{OBSIDIAN_VAULT}}`。

## 踩坑修正

- 不要把專案駕駛艙建在工作資料夾 repo 裡；它應該在 Obsidian vault 內。
- Obsidian Web Clipper 的 vault 名稱要和 Obsidian Desktop 開啟的 vault 完全一致。
- `Vault not found` 通常是 Web Clipper 或 Obsidian URI 的 vault 名稱錯，不是筆記內容錯。
- Google Drive 資料夾名稱有空格時，部分工具處理會不穩；新專案優先用底線或連字號命名。
- Codex 側邊欄不一定即時反映資料夾改名，需要重新開啟專案或重啟 App。
