# Codex 實測懶人包總目錄

> 版本：2026-05-20 可移植修正版
> 用途：讓下載者能依序設定自己的 Codex App、plugins、MCP、Obsidian、GitHub、Firebase、全域 skills 與專案初始化流程。
> 原則：文件中的 `{{...}}` 都是下載者必須替換的值；`Arry`、`icestone0128`、`codex-4e80b` 只作為本機實測例，不是預設值。

## 先填這張設定表

開始前，先決定自己的路徑與帳號。後續所有文件都引用這張表。

| 變數 | 說明 | 範例 |
| --- | --- | --- |
| `{{USER_NAME}}` | 你的系統使用者名稱 | `alex` |
| `{{HOME}}` | 使用者家目錄 | `/Users/alex` |
| `{{CODEX_HOME}}` | Codex 設定資料夾 | `/Users/alex/.codex` |
| `{{CODEX_CONFIG}}` | Codex MCP 設定檔 | `/Users/alex/.codex/config.toml` |
| `{{WORK_ROOT}}` | 專案工作根目錄 | `/Users/alex/Projects` 或 Google Drive 內的工作資料夾 |
| `{{SETUP_REPO}}` | 這份懶人包所在專案 | `{{WORK_ROOT}}/codex_installation` |
| `{{SYNC_ROOT}}` | Codex symlink 雲端同步母資料夾 | Google Drive / iCloud / Dropbox 內的 `codex_symlink` |
| `{{BACKUP_ROOT}}` | 本機備份位置 | `/Users/alex` |
| `{{OBSIDIAN_VAULT}}` | Obsidian vault 絕對路徑 | `/Users/alex/Obsidian/secondbrain` |
| `{{OBSIDIAN_PROJECTS}}` | Obsidian 專案庫資料夾 | `{{OBSIDIAN_VAULT}}/專案庫` |
| `{{NOTEBOOKLM_OUTPUT}}` | NotebookLM 成品下載整理資料夾 | `/Users/alex/Documents/NotebookLM` |
| `{{NOTEBOOKLM_MCP_COMMAND}}` | NotebookLM MCP 可執行檔 | `/Users/alex/.local/bin/notebooklm-mcp` |
| `{{GITHUB_USER}}` | GitHub 帳號 | `alex-dev` |
| `{{GITHUB_EMAIL}}` | Git commit email | `123456+alex-dev@users.noreply.github.com` |
| `{{REPO_NAME}}` | GitHub repo 名稱 | `my-project` |
| `{{GOOGLE_ACCOUNT}}` | Google 帳號 | `alex@example.com` |
| `{{FIREBASE_PROJECT_ID}}` | Firebase 專案 ID | `my-project-12345` |
| `{{FIRECRAWL_API_KEY}}` | Firecrawl API key | 只放在本機設定，不寫進 repo |
| `{{FILESYSTEM_ALLOWED_DIR}}` | Filesystem MCP 最小授權資料夾 | `/Users/alex/Documents` |
| `{{MCPVAULT_COMMAND}}` | Obsidian MCP 可執行檔 | `/opt/homebrew/bin/mcpvault` |
| `{{ASSISTANT_NAME}}` | 個人助手名稱 | `我的助手` |
| `{{ASSISTANT_SKILL_NAME}}` | 個人助手 skill 名稱 | `my-assistant` |
| `{{SETUP_PROJECT_NAME}}` | 設定專案在 Obsidian 的名稱 | `codex_installation` |

本機實測值保留在踩坑段落作為參考，但下載者不要直接照抄。

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
11. [[10-Codex版SkillCreator工作流]]
12. [[11-外部工具整合工作流]]
13. [[12-Brainstorm規劃模式]]
14. [[13-Social-Cards圖卡Skill安裝]]
15. [[14-Codex全域Skills跨裝置同步]]

## 共用前置條件

- 已安裝 Codex App，且可以開啟本機工作資料夾。
- macOS / Linux / WSL 皆可參考；Windows 原生路徑需要自行改寫。
- 已安裝 Git。
- 需要 GitHub 時，安裝 GitHub CLI `gh` 並登入。
- 需要 Firebase 時，準備 Firebase / Google 帳號與一個 Firebase project。
- 需要 Firecrawl 時，準備 Firecrawl API key。
- 需要 NotebookLM / Google Drive / Gmail / Calendar 時，使用 Codex App 內建 plugin 或 MCP 登入自己的 Google 帳號。

## 共同安全規則

- 不把 `.env`、API key、token、密碼、Admin 憑證、個資或敏感資料寫入 repo 或 Obsidian 筆記。
- 需要 API key 的 MCP 只能記錄遮蔽範例，例如 `fc-***`。
- 專案固定規則寫在專案根目錄 `AGENTS.md`。
- Codex 全域規則寫在 `{{CODEX_HOME}}/AGENTS.md`。
- 實際進度、踩坑與下一步寫在 Obsidian 專案駕駛艙，不寫進專案 `AGENTS.md`。
- Obsidian 專案駕駛艙一律放在 `{{OBSIDIAN_PROJECTS}}/<專案名稱>/專案工作流程.md`。
- MCP 或 skills 設定改完後，通常要開新 Codex 對話或重啟 Codex App 才會載入。
- MCP 設定使用 `{{CODEX_CONFIG}}`；不要把 Claude Code CLI 的 `~/.claude.json` 指令直接套用到 Codex App。
- Claude / Anthropic 文件只作為轉換來源；正式 Codex skills 放在 `{{CODEX_HOME}}/skills`。

## 檢查下載者是否已替換成功

設定前先搜尋整包：

```bash
rg -n "arrywu|icestone0128|codex-4e80b|我的雲端硬碟|{{" lazy-pack
```

合理結果：

- `{{...}}` 會出現在模板說明中。
- 不應該在你自己的設定檔、`AGENTS.md` 或實際專案檔裡留下別人的帳號、路徑或 Firebase project ID。

## 本版共同修正

- 專案名稱與資料夾盡量使用無空格命名，例如 `codex_installation`。
- Firebase Project ID 不能改名；資料夾改名後要同步更新 Firebase MCP 的 project directory。
- 個人助手設定以 `09-個人助手設定` 為準；舊 Agent Folder 文檔只作為轉換來源，不直接照做。
- Skill Creator 啟動包以 `10-Codex版SkillCreator工作流` 為準；Claude / Anthropic skill 教學只作為轉換來源，不直接照做。
- 外部工具整合以 `11-外部工具整合工作流` 為準；下載者可直接複製 `lazy-pack/skills/tool-integration-workflow/` 到自己的 `{{CODEX_HOME}}/skills/` 使用。
- Brainstorm 規劃模式以 `12-Brainstorm規劃模式` 為準；下載者可直接複製 `lazy-pack/skills/brainstorm/` 到自己的 `{{CODEX_HOME}}/skills/` 使用。
- Social Cards 圖卡 skill 以 `13-Social-Cards圖卡Skill安裝` 為準；下載者可直接複製 `lazy-pack/skills/social-cards/` 到自己的 `{{CODEX_HOME}}/skills/social-cards/`，再安裝 Playwright 依賴使用。
- Codex 全域 skills 跨裝置同步以 `14-Codex全域Skills跨裝置同步` 為準；下載者可直接複製 `lazy-pack/skills/cross-device-sync/` 到自己的 `{{CODEX_HOME}}/skills/cross-device-sync/`，再依文件把 `{{CODEX_HOME}}/skills` symlink 到自己的雲端同步資料夾。
