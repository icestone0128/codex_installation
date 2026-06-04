# Codex 懶人包總目錄

> 版本：2026-05-27 可自行安裝版
> 用途：讓下載者從零開始設定 Codex App、全域 skills、plugins、MCP、Obsidian、GitHub、Firebase、NotebookLM 與專案初始化流程。
> 原則：文件中的 `{{...}}` 都是下載者必須替換的值；`{{...}}` 佔位符必須替換成下載者自己的路徑、帳號與 project ID。

## 先填這張設定表

開始前，先決定自己的路徑與帳號。後續所有文件都引用這張表。

| 變數 | 說明 | 範例 |
| --- | --- | --- |
| `{{USER_NAME}}` | 你的系統使用者名稱 | `alex` |
| `{{HOME}}` | 使用者家目錄 | 你的 home folder |
| `{{CODEX_HOME}}` | Codex 設定資料夾 | `{{HOME}}/.codex` |
| `{{CODEX_CONFIG}}` | Codex MCP 設定檔 | `{{CODEX_HOME}}/config.toml` |
| `{{WORK_ROOT}}` | 專案工作根目錄 | `{{HOME}}/Projects` 或雲端硬碟內的工作資料夾 |
| `{{PROJECT_ROOT}}` | 目前要操作的單一專案資料夾 | `{{WORK_ROOT}}/my-project` |
| `{{SETUP_REPO}}` | 這份懶人包所在專案 | `{{WORK_ROOT}}/codex_installation` |
| `{{SYNC_ROOT}}` | Codex symlink 雲端同步母資料夾 | Google Drive / iCloud / Dropbox 內的 `codex_symlink` |
| `{{GLOBAL_RULES}}` | 可攜式全域核心規則主檔 | `{{SYNC_ROOT}}/core-rules.md` |
| `{{BACKUP_ROOT}}` | 本機備份位置 | `{{HOME}}` |
| `{{OBSIDIAN_VAULT}}` | Obsidian vault 絕對路徑 | `{{HOME}}/Obsidian/secondbrain` |
| `{{OBSIDIAN_PROJECTS}}` | Obsidian 專案庫資料夾 | `{{OBSIDIAN_VAULT}}/專案庫` |
| `{{NOTEBOOKLM_OUTPUT}}` | NotebookLM 成品下載整理資料夾 | `{{HOME}}/Documents/NotebookLM` |
| `{{NOTEBOOKLM_MCP_COMMAND}}` | NotebookLM MCP 可執行檔 | `{{HOME}}/.local/bin/notebooklm-mcp` |
| `{{GITHUB_USER}}` | GitHub 帳號 | `alex-dev` |
| `{{GITHUB_EMAIL}}` | Git commit email | `123456+alex-dev@users.noreply.github.com` |
| `{{REPO_NAME}}` | GitHub repo 名稱 | `my-project` |
| `{{GOOGLE_ACCOUNT}}` | Google 帳號 | `alex@example.com` |
| `{{FIREBASE_PROJECT_ID}}` | Firebase 專案 ID | `my-project-12345` |
| `{{FIRECRAWL_API_KEY_SECRET_PATH}}` | Firecrawl API key 本機檔案 | `{{CODEX_HOME}}/secrets/firecrawl_api_key`；不寫進 repo |
| `{{FILESYSTEM_ALLOWED_DIR}}` | Filesystem MCP 最小授權資料夾 | `{{HOME}}/Documents` |
| `{{MCPVAULT_COMMAND}}` | Obsidian MCP 可執行檔 | `/opt/homebrew/bin/mcpvault` |
| `{{ASSISTANT_NAME}}` | 個人助手名稱 | `我的助手` |
| `{{ASSISTANT_SKILL_NAME}}` | 個人助手 skill 名稱 | `my-assistant` |
| `{{ASSISTANT_ROOT}}` | 個人助手全域資料層 | `{{SYNC_ROOT}}` |
| `{{ASSISTANT_MEMORY}}` | 個人助手跨專案記憶 | `{{ASSISTANT_ROOT}}/memories/MEMORY.md` |
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
14. [[14-Social-Cards-Skill-安裝]]
15. [[15-Landing-Page-Skill-安裝]]
16. [[16-Codex-全域-Skills-跨裝置同步]]
17. [[17-RightProblem-Coach-Skill-安裝]]
18. [[18-Document-to-Markdown-Skill-安裝]]
19. [[19-SOIL-HTML-Deck-Skill-安裝]]
20. [[20-SOIL-Image-Deck-Skill-安裝]]
21. [[21-SOIL-General-Deck-Skill-安裝]]
22. [[22-Image-Generator-Skill-安裝]]
23. [[23-Visual-Note-Generator-Skill-安裝]]
24. [[24-Diary-Interview-Assistant-Skill-安裝]]
25. [[25-Gemini-Free-API-Skill-安裝]]
26. [[26-HyperFrames-Skill-安裝]]
27. [[27-Video-Spec-Builder-Skill-安裝]]
28. [[28-Netlify-Deploy-Skill-安裝]]
29. [[29-Video-Processing-Automation-Skill-安裝]]
30. [[30-Video-Creation-Automation-Skill-安裝]]

## 全域 Skills 安裝總表

全域 skill 的完整內容已內嵌在對應的有序號懶人包文件中，不再另外提供獨立的 `skills/` 子目錄。安裝時請打開對應編號文件，使用文末「內建 Skill 完整安裝內容」。

```text
01：必裝 Codex skills 與基礎 plugins / connectors 檢查，例如 `pdf`、`playwright`、Notion、PDF、Browser plugin；不設定外部瀏覽器 MCP server
02：MCP / 外部工具 / CLI 連線，例如 Firecrawl、Filesystem、heptabase-cli
05：secondbrain-research-digest
07：notebooklm-architecture、presentation-workflow
09：arry-assistant
10：project-init-sync、startup-sync、shutdown-sync
11：codex-skill-creator
12：tool-integration-workflow
13：brainstorm
14：social-cards
15：landing-page
16：cross-device-sync
17：rightproblem-coach
18：doc-to-md
19：soil-html-deck
20：soil-image-deck
21：soil-general-deck
22：image-generator
23：visual-note-generator
24：diary-interview-assistant
25：gemini-free-api
26：HyperFrames 官方 skill suite：`hyperframes`、`hyperframes-cli`、`hyperframes-media`、`hyperframes-registry`、`website-to-hyperframes`、`remotion-to-hyperframes`、`gsap`、`animejs`、`css-animations`、`lottie`、`tailwind`、`three`、`typegpu`、`waapi`、`contribute-catalog`
27：video-spec-builder
28：netlify-deploy
29：video-processing-automation
30：video-creation-automation
```

路徑邊界固定如下：

| 類型 | 正式位置 | 用途 |
| --- | --- | --- |
| 可攜式全域核心規則 | `{{GLOBAL_RULES}}`；`{{CODEX_HOME}}/AGENTS.md` 只作為 symlink 入口 | Codex 與其他 AI agent 共用的長期工作規則、路徑、同步規則與操作邊界 |
| Codex 全域 skills | `{{CODEX_HOME}}/skills`；若跨裝置同步，才 symlink 到 `{{SYNC_ROOT}}/skills` | 需要被 Codex App 全域觸發的 skills |
| LazyPack 自含式安裝文件 | `{{SETUP_REPO}}/lazy-pack/01...30.md` | 每個序號文件內嵌對應全域 skill 的完整安裝內容 |
| Arry/個人助手全域入口 | `{{CODEX_HOME}}/skills/{{ASSISTANT_SKILL_NAME}}` | 每次專案初始化都要帶入，用來讀取個人助手資料層並協助判斷 skill 歸屬 |
| 個人助手跨專案記憶 | `{{ASSISTANT_ROOT}}/memories` | 個人偏好、踩坑、跨專案可重用決策 |
| 個人助手跨專案 workflow | `{{ASSISTANT_ROOT}}/workflows` | 尚未升級成全域 skill 的 workflow 草稿 |
| 專案本地 skills | 各專案 `000_Agent/skills` | 只服務該專案的 assistant skill 或 workflow；這個資料夾本身就是專案可攜式 skill 包 |

不要把專案 `000_Agent/skills` symlink 到 `{{CODEX_HOME}}/skills`。只有全域 Codex skills 才使用 `{{CODEX_HOME}}/skills`，也只有這一層需要指向雲端 `codex_symlink/skills`。

任何新建或修改的 skill 都要做成可攜式版本：

- 全域 skill：同步 `{{CODEX_HOME}}/skills/<skill-name>`、對應序號懶人包文件的內嵌安裝內容，與 Obsidian 全域 Skills 索引。
- 專案 skill：放在 `<project-root>/000_Agent/skills/<skill-name>`，保留完整 `SKILL.md`、references、scripts、assets；若該專案使用 Git，這個資料夾應跟著專案版本化。

每個有序號的懶人包文件都應自含需要安裝的 `SKILL.md`、`references/`、`scripts/`、`templates/`、`assets/`、`agents/` 或 package 檔內容。一般情況下，`node_modules/` 這類可重建相依套件不內嵌，改由安裝者在自己的電腦重建；但 `social-cards/node_modules/` 是本使用者指定保留的可攜式執行依賴特例，可在全域 skill 實體目錄中保留並同步。

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
| 9 | `cross-device-sync` | [[16-Codex-全域-Skills-跨裝置同步]] | 需設定 `{{SYNC_ROOT}}`；包含跨裝置同步、`core-rules.md` 可攜化與多 Agent 相容性健檢 |
| 10 | `heptabase-cli` | [[02-Codex-MCP-Essentials]] | 外部 CLI 連線類，需 Heptabase desktop app 與 CLI |
| 11 | Notion plugin | [[01-Codex-必裝-Skills-與-Plugins]] | 使用 Codex plugin / connector；不要建立自訂全域 skill |
| 12 | `pdf` / `playwright` skills 與 PDF / Browser plugin | [[01-Codex-必裝-Skills-與-Plugins]] | `pdf` 與 `playwright` 列為必裝 Codex skills；PDF 與 Browser plugin 也列為必裝檢查；不設定外部瀏覽器 MCP server |
| 13 | `rightproblem-coach` | [[17-RightProblem-Coach-Skill-安裝]] | 可直接安裝；包含問題規格書模板、HC 指南與分析框架 |
| 14 | `doc-to-md` | [[18-Document-to-Markdown-Skill-安裝]] | 可直接安裝；合併文字轉檔與 VLM 視覺解讀，自動分流 PDF/EPUB/TXT/掃描 PDF/圖片與圖表 |
| 15 | `landing-page` | [[15-Landing-Page-Skill-安裝]] | 可直接安裝；fallback 設計規則內建，UUPM 為選用 |
| 16 | `soil-html-deck` | [[19-SOIL-HTML-Deck-Skill-安裝]] | 可直接安裝；SOIL 互動 HTML 簡報 |
| 17 | `soil-image-deck` | [[20-SOIL-Image-Deck-Skill-安裝]] | 可直接安裝；SOIL 全圖像 PPTX |
| 18 | `soil-general-deck` | [[21-SOIL-General-Deck-Skill-安裝]] | 可直接安裝；SOIL 通用可編輯 PPTX |
| 19 | `image-generator` | [[22-Image-Generator-Skill-安裝]] | 可直接安裝；Codex 內建生圖與修圖入口 |
| 20 | `visual-note-generator` | [[23-Visual-Note-Generator-Skill-安裝]] | 可直接安裝；圖解筆記、生圖提示、Q 版角色與資訊圖表結構 |
| 21 | `diary-interview-assistant` | [[24-Diary-Interview-Assistant-Skill-安裝]] | 可直接安裝；間歇式日記訪談、寫作洞察與文章草稿提示 |
| 22 | `gemini-free-api` | [[25-Gemini-Free-API-Skill-安裝]] | 可直接安裝；Gemini API Free Tier、`GEMINI_API_KEY` 安全儲存、收費邊界與後端整合 |
| 23 | HyperFrames skill suite | [[26-HyperFrames-Skill-安裝]] | 可直接安裝；HTML/CSS/media/seekable animation 到 MP4 的影片 composition 工作流，實際 render 需 Node.js 22+ 與 FFmpeg |
| 24 | Video Spec Builder | [[27-Video-Spec-Builder-Skill-安裝]] | 可直接安裝；追問影片需求、拆分鏡、產出可交給 HyperFrames 的 `video-spec.md` |
| 25 | `netlify-deploy` | [[28-Netlify-Deploy-Skill-安裝]] | 可直接安裝；官方 Netlify MCP 設定、Netlify 前端部署與 Clasp + Apps Script API 閉環部署流程 |
| 26 | `video-processing-automation` | [[29-Video-Processing-Automation-Skill-安裝]] | 可直接安裝；原始影片到 YouTube / 社群影片上架包，含智能剪口播、字幕、文字稿、封面、metadata 與短片亮點 |
| 27 | `video-creation-automation` | [[30-Video-Creation-Automation-Skill-安裝]] | 可直接安裝；沒有現成影片時，先確認入口後生成腳本、設計、素材、旁白、composition 與渲染包；若已有影片則轉用 `video-processing-automation` |
| 28 | 其他內容製作類 skills | 對應序號文件 | 視需求安裝 |

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
- 可攜式全域核心規則寫在 `{{GLOBAL_RULES}}`；`{{CODEX_HOME}}/AGENTS.md` 只作為 Codex App 的 symlink 入口。
- 不要另外維護 `{{SYNC_ROOT}}/agents/AGENTS.md`；其他 AI agent 要讀同一份規則時，直接讀 `{{GLOBAL_RULES}}`。
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
- Social Cards Skill 以 [[14-Social-Cards-Skill-安裝]] 為準。
- Landing Page skill 以 [[15-Landing-Page-Skill-安裝]] 為準。
- Codex 全域 skills 跨裝置同步與多 Agent 相容性健檢以 [[16-Codex-全域-Skills-跨裝置同步]] 為準。
- RightProblem Coach skill 以 [[17-RightProblem-Coach-Skill-安裝]] 為準。
- Document to Markdown skill 以 [[18-Document-to-Markdown-Skill-安裝]] 為準。
- SOIL HTML Deck skill 以 [[19-SOIL-HTML-Deck-Skill-安裝]] 為準。
- SOIL Image Deck skill 以 [[20-SOIL-Image-Deck-Skill-安裝]] 為準。
- SOIL General Deck skill 以 [[21-SOIL-General-Deck-Skill-安裝]] 為準。
- Image Generator skill 以 [[22-Image-Generator-Skill-安裝]] 為準。
- 2026-05-24 起，有序號的懶人包文件本身內嵌對應全域 skill 的完整安裝內容；別人拿到本懶人包後，不需要另外取得原作者本機的 `{{CODEX_HOME}}/skills` 目錄，也不需要 舊版獨立 skills 子目錄。
- Diary Interview Assistant Skill 以 [[24-Diary-Interview-Assistant-Skill-安裝]] 為準。
- Gemini Free API Skill 以 [[25-Gemini-Free-API-Skill-安裝]] 為準。
- HyperFrames Skill suite 以 [[26-HyperFrames-Skill-安裝]] 為準。
- Video Spec Builder Skill 以 [[27-Video-Spec-Builder-Skill-安裝]] 為準。
- Netlify Deploy Skill 以 [[28-Netlify-Deploy-Skill-安裝]] 為準。
- Video Processing Automation Skill 以 [[29-Video-Processing-Automation-Skill-安裝]] 為準。
- Video Creation Automation Skill 以 [[30-Video-Creation-Automation-Skill-安裝]] 為準。
