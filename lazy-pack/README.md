# Codex 懶人包總目錄

> 版本：2026-05-21 可自行安裝版
> 用途：讓下載者從零開始設定 Codex App、全域 skills、plugins、MCP、Obsidian、GitHub、Firebase、NotebookLM 與專案初始化流程。
> 原則：文件中的 `{{...}}` 都是下載者必須替換的值；`{{...}}` 佔位符必須替換成下載者自己的路徑、帳號與 project ID。

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
| `{{ASSISTANT_ROOT}}` | 個人助手全域資料層 | `{{SYNC_ROOT}}` |
| `{{ASSISTANT_MEMORY}}` | 個人助手跨專案記憶 | `{{ASSISTANT_ROOT}}/memory/MEMORY.md` |
| `{{ASSISTANT_WORKFLOWS}}` | 個人助手跨專案 workflow 草稿 | `{{ASSISTANT_ROOT}}/workflows` |
| `{{SETUP_PROJECT_NAME}}` | 設定專案在 Obsidian 的名稱 | `codex_installation` |

後續文件若出現範例值，只能作為格式參考；下載者必須替換成自己的實際路徑與帳號。

## 安裝主線

照這個順序做，下載者可以從空白 Codex App 一路安裝到可開新專案：

1. [[01-Codex-必裝-Skills-與-Plugins]]
2. [[02-Codex-MCP-Essentials]]
3. [[03-連接-GitHub]]
4. [[04-建立第二大腦-Obsidian]]
5. [[05-第二大腦設定指南]]
6. [[06-連接-GitHub-與-Obsidian]]
7. [[07-連接-NotebookLM]]
8. [[08-連接-Firebase-資料庫]]
9. [[09-個人助手設定]]
10. [[10-專案初始化工作模式]]

## 進階模組

主線完成後，再依需求安裝：

11. [[11-Codex-Skill-Creator-工作流]]
12. [[12-外部工具整合工作流]]
13. [[13-Brainstorm-規劃模式]]
14. [[14-Social-Cards-圖卡-Skill-安裝]]
15. [[15-Landing-Page-Skill-安裝]]
16. [[16-Codex-全域-Skills-跨裝置同步]]

## 全域 Skills 安裝總表

可直接複製成 Codex 全域 skill 的套件放在 `lazy-pack/skills/`。安裝方式一致：

```bash
mkdir -p "{{CODEX_HOME}}/skills/<skill-name>"
rsync -a --delete "{{SETUP_REPO}}/lazy-pack/skills/<skill-name>/" "{{CODEX_HOME}}/skills/<skill-name>/"
test -f "{{CODEX_HOME}}/skills/<skill-name>/SKILL.md" && echo "<skill-name> installed"
```

路徑邊界固定如下：

| 類型 | 正式位置 | 用途 |
| --- | --- | --- |
| Codex 全域 skills | `{{CODEX_HOME}}/skills`；若跨裝置同步，才 symlink 到 `{{SYNC_ROOT}}/skills` | 需要被 Codex App 全域觸發的 skills |
| LazyPack 可攜化副本 | `{{SETUP_REPO}}/lazy-pack/skills` | 供複製、安裝、版本化的全域 skills 套件 |
| Arry/個人助手全域入口 | `{{CODEX_HOME}}/skills/{{ASSISTANT_SKILL_NAME}}` | 每次專案初始化都要帶入，用來讀取個人助手資料層並協助判斷 skill 歸屬 |
| 個人助手跨專案記憶 | `{{ASSISTANT_ROOT}}/memory` | 個人偏好、踩坑、跨專案可重用決策 |
| 個人助手跨專案 workflow | `{{ASSISTANT_ROOT}}/workflows` | 尚未升級成全域 skill 的 workflow 草稿 |
| 專案本地 skills | 各專案 `000_Agent/skills` | 只服務該專案的 assistant skill 或 workflow；這個資料夾本身就是專案可攜式 skill 包 |

不要把專案 `000_Agent/skills` symlink 到 `{{CODEX_HOME}}/skills`。只有全域 Codex skills 才使用 `{{CODEX_HOME}}/skills`，也只有這一層需要指向雲端 `codex_symlink/skills`。

任何新建或修改的 skill 都要做成可攜式版本：

- 全域 skill：同步 `{{CODEX_HOME}}/skills/<skill-name>`、`{{SETUP_REPO}}/lazy-pack/skills/<skill-name>` 與 Obsidian 全域 Skills 索引。
- 專案 skill：放在 `<project-root>/000_Agent/skills/<skill-name>`，保留完整 `SKILL.md`、references、scripts、assets；若該專案使用 Git，這個資料夾應跟著專案版本化。

建議安裝順序：

| 順序 | Skill | 對應懶人包 | 狀態 |
| --- | --- | --- | --- |
| 1 | `codex-skill-creator` | [[11-Codex-Skill-Creator-工作流]] | 可直接安裝，可選 Obsidian skill 索引 |
| 2 | `project-init-sync` | [[10-專案初始化工作模式]] | 可直接安裝，需替換專案預設路徑 |
| 3 | `startup-sync` | [[10-專案初始化工作模式]] | 可直接安裝，依專案 `AGENTS.md` 工作 |
| 4 | `shutdown-sync` | [[10-專案初始化工作模式]] | 可直接安裝，依專案 `AGENTS.md` 工作 |
| 5 | `arry-assistant` | [[09-個人助手設定]] | 個人助手模板，需改名與替換資料層路徑 |
| 6 | `secondbrain-research-digest` | [[05-第二大腦設定指南]] | 需設定 `{{OBSIDIAN_VAULT}}` |
| 7 | `tool-integration-workflow` | [[12-外部工具整合工作流]] | 可直接安裝 |
| 8 | `brainstorm` | [[13-Brainstorm-規劃模式]] | 可直接安裝 |
| 9 | `cross-device-sync` | [[16-Codex-全域-Skills-跨裝置同步]] | 需設定 `{{SYNC_ROOT}}` |
| 10 | `pdf`, `playwright` | `lazy-pack/skills/README.md` | 可直接安裝；PDF 需 Poppler/Python 依賴，Playwright 需 Node/npm |
| 11 | `landing-page` | [[15-Landing-Page-Skill-安裝]] | 可直接安裝；fallback 設計規則內建，UUPM 為選用 |
| 12 | 其他內容製作類 skills | `lazy-pack/skills/README.md` | 視需求安裝 |

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
- MCP 設定使用 `{{CODEX_CONFIG}}`；不要把其他工具的 CLI 或 MCP 設定檔指令直接套用到 Codex App。
- 外部 / Anthropic 文件只作為轉換來源；需要全域觸發的正式 Codex skills 放在 `{{CODEX_HOME}}/skills`，專案或個人助手本地 skills 放在對應的 `000_Agent/skills`。

## 檢查下載者是否已替換成功

設定前先搜尋整包：

```bash
rg -n "<舊使用者名稱>|<舊 GitHub 帳號>|<舊 Firebase project id>|<舊雲端硬碟路徑>" lazy-pack
```

合理結果：

- `{{...}}` 會出現在模板說明中。
- 不應該在你自己的設定檔、`AGENTS.md` 或實際專案檔裡留下別人的帳號、路徑或 Firebase project ID。

## 本版共同修正

- 專案名稱與資料夾盡量使用無空格命名，例如 `codex_installation`。
- Firebase Project ID 不能改名；資料夾改名後要同步更新 Firebase MCP 的 project directory。
- 個人助手設定以 `09-個人助手設定` 為準；舊 Agent Folder 文檔只作為轉換來源，不直接照做。
- Skill Creator 啟動包以 [[11-Codex-Skill-Creator-工作流]] 為準；外部 / Anthropic skill 教學只作為轉換來源，不直接照做。
- 外部工具整合以 [[12-外部工具整合工作流]] 為準。
- Brainstorm 規劃模式以 [[13-Brainstorm-規劃模式]] 為準。
- Social Cards 圖卡 skill 以 [[14-Social-Cards-圖卡-Skill-安裝]] 為準。
- Landing Page skill 以 [[15-Landing-Page-Skill-安裝]] 為準。
- Codex 全域 skills 跨裝置同步以 [[16-Codex-全域-Skills-跨裝置同步]] 為準。
