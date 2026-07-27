# Codex 懶人包總目錄

> 版本：2026-07-28 可自行安裝版
> 用途：讓下載者從零開始設定 Codex、Claude、AntiGravity 共用的全域規則與 skills，以及 plugins、MCP、Obsidian、GitHub、Firebase、NotebookLM 與專案初始化流程。
> 原則：文件中的 `{{...}}` 都是下載者必須替換的值；公開懶人包、內嵌安裝腳本與 templates 不展示作者本機實體安裝目錄。

2026-07-21 更新：Item 10 將 `HANDOFF.md` 收為開工必讀、收工必寫；Item 16 加入共享 `session-sync-checkpoint.sh`、三 Agent Python-tools 中立 bridge 與安全 shell loader，以可驗證 gate 執行 `chezmoi update`，並限制 `chezmoi add` 只用於新增白名單入口；Item 34 成為每台電腦重建共用 Python runtime 的主線項目。共享全域 skill 主版本固定為 `{{SYNC_ROOT}}/skills`，專案 skill 固定為 `<project-root>/000_Agent/skills`。

2026-07-28 更新：新增 [[39-Coach-Skill-安裝]]，把 Life Coach（實際 ID `future-coach`）、Voice Coach、Waki Brain、Productivity Coach 整理成 Arry 私人新電腦安裝群組。Item 39 只公開安全安裝器與驗證器；四個私人 Skill 本體必須先由私人雲端同步到 `{{SYNC_ROOT}}`，不會內嵌到 public LazyPack。

## 先填這張設定表

開始前，先決定自己的路徑與帳號。後續所有文件都引用這張表。

| 變數 | 說明 | 範例 |
| --- | --- | --- |
| `{{USER_NAME}}` | 你的系統使用者名稱 | `alex` |
| `{{HOME}}` | 使用者家目錄 | 你的 home folder |
| `{{CODEX_HOME}}` | Codex 設定資料夾 | `{{HOME}}/.codex` |
| `{{CODEX_CONFIG}}` | Codex MCP 設定檔 | `{{CODEX_HOME}}/config.toml` |
| `{{CLAUDE_HOME}}` | Claude 設定資料夾 | `{{HOME}}/.claude` |
| `{{GEMINI_HOME}}` | AntiGravity / Gemini 家目錄 | `{{HOME}}/.gemini` |
| `{{GEMINI_CONFIG}}` | AntiGravity / Gemini 相容設定資料夾 | `{{GEMINI_HOME}}/config` |
| `{{CHEZMOI_SOURCE}}` | chezmoi source state | `{{HOME}}/.local/share/chezmoi` |
| `{{PYTHON_TOOLS_HOME}}` | 每台電腦的本機 Python tools runtime | `{{CODEX_HOME}}/python-tools` |
| `{{WORK_ROOT}}` | 專案工作根目錄 | `{{HOME}}/Projects` 或雲端硬碟內的工作資料夾 |
| `{{PROJECT_ROOT}}` | 目前要操作的單一專案資料夾 | `{{WORK_ROOT}}/my-project` |
| `{{SETUP_REPO}}` | 這份懶人包所在專案 | `{{WORK_ROOT}}/codex_installation` |
| `{{SETUP_REPO_NAME}}` | 這份懶人包 repo 名稱 | `codex_installation` |
| `{{ANTIGRAVITY_SETUP_REPO}}` | AntiGravity 懶人包所在專案 | `{{WORK_ROOT}}/antigravity_installation` |
| `{{SYNC_ROOT}}` | 三 Agent 共用的雲端內容主版本 | Google Drive／iCloud／Dropbox 內的同步資料夾（可沿用 `codex_symlink` 既有名稱） |
| `{{GLOBAL_RULES}}` | 可攜式全域核心規則主檔 | `{{SYNC_ROOT}}/core-rules.md` |
| `{{BACKUP_ROOT}}` | 本機備份位置 | `{{HOME}}` |
| `{{SECRETS_DIR}}` | 本機 secrets 資料夾 | `{{CODEX_HOME}}/secrets` |
| `{{LOCAL_BIN}}` | 使用者本機 CLI wrapper 資料夾 | `{{HOME}}` 底下的本機 bin 資料夾 |
| `{{DOWNLOADS_DIR}}` | 下載資料夾 | `{{HOME}}` 底下的下載資料夾 |
| `{{LOCAL_FILE_PATH}}` | 使用者貼上的單一檔案或資料夾路徑 | 只作為 placeholder，不寫作者實體路徑 |
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
| `{{HOMEBREW_PREFIX}}` | Homebrew 安裝前綴 | 由 `brew --prefix` 取得 |
| `{{MCPVAULT_COMMAND}}` | Obsidian MCP 可執行檔 | `{{HOMEBREW_PREFIX}}/bin/mcpvault` |
| `{{ASSISTANT_NAME}}` | 個人助手名稱 | `我的助手` |
| `{{ASSISTANT_SKILL_NAME}}` | 個人助手 skill 名稱 | `my-assistant` |
| `{{ASSISTANT_ROOT}}` | 個人助手全域資料層 | `{{SYNC_ROOT}}` |
| `{{ASSISTANT_MEMORY}}` | 個人助手跨專案記憶 | `{{ASSISTANT_ROOT}}/memories/MEMORY.md` |
| `{{ASSISTANT_WORKFLOWS}}` | 個人助手跨專案 workflow 草稿 | `{{ASSISTANT_ROOT}}/workflows` |
| `{{SETUP_PROJECT_NAME}}` | 設定專案在 Obsidian 的名稱 | `codex_installation` |

後續文件若出現範例值，只能作為格式參考；下載者必須替換成自己的實際路徑與帳號。維護者新增或更新 LazyPack 時，必須把公開文件、內嵌 installer、scripts 與 templates 內的本機路徑改成上表 placeholder，並在完成前掃描確認沒有實體安裝目錄或帳號字串殘留。

## 安裝主線

照這個順序做，下載者可以從空白環境建立 Codex、Claude、AntiGravity 共用專案架構。即使當下尚未安裝其中某個 Agent，Item 16 仍會預先建好入口：

1. [[01-Codex-必裝-Skills-與-Plugins]]
2. [[02-Codex-MCP-Essentials]]
3. [[03-連接-GitHub]]
4. [[04-建立第二大腦-Obsidian]]
5. [[05-第二大腦設定指南]]
6. [[06-連接-GitHub-與-Obsidian]]
7. [[07-連接-NotebookLM]]
8. [[08-連接-Firebase-資料庫]]
9. [[16-Codex-全域-Skills-跨裝置同步]]（chezmoi 必裝；建立 Agent 全域入口與三 Agent 共用 Python bridge）
10. [[34-Python-Tools-全域工具包安裝]]（每台電腦重建本機 runtime；不要同步 venv）
11. [[09-個人助手設定]]
12. [[10-專案初始化工作模式]]

## 進階模組

主線完成後，再依需求安裝：

12. [[11-Codex-Skill-Creator-工作流]]
13. [[12-外部工具整合工作流]]
14. [[13-Brainstorm-規劃模式]]
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
31. [[31-YouTube-Transcript-Collector-Skill-安裝]]
32. [[32-VoxCPM2-Voice-Cloner-Skill-安裝]]
33. [[33-Audio-to-Markdown-Skill-安裝]]
34. [[34-Python-Tools-全域工具包安裝]]
35. [[35-Taigi-Teaching-Agent-安裝]]
36. [[36-Voice-Input-Normalization]]
37. [[37-Voice-Reply-Skill-安裝]]
38. [[38-YAML-Image-Deck-Skill-安裝]]
39. [[39-Coach-Skill-安裝]]

## 全域 Skills 安裝總表

公開可散布的全域 skill 完整內容已內嵌在對應的有序號懶人包文件中，不再另外提供獨立的 `skills/` 子目錄。安裝時請打開對應編號文件，使用文末「內建 Skill 完整安裝內容」。Item 39 是明確例外：它是 Arry 私人來源橋接型安裝群組，只內建公開安全的 installer／verifier，不內嵌私人身份、記憶或購課內容。

```text
01：三 Agent 共用 `pdf`、`playwright` skills，並對 Codex／Claude／AntiGravity 各自的 plugins、connectors、MCP 與原生 browser 能力做 adapter 檢查
02：MCP / 外部工具 / CLI 連線，例如 Firecrawl、Filesystem、heptabase-cli
05：secondbrain-research-digest
07：notebooklm-architecture、presentation-workflow
09：arry-assistant
10：project-init-sync、startup-sync、shutdown-sync；開工必讀、收工必寫 `HANDOFF.md`，共用 Item 16 checkpoint
11：codex-skill-creator
12：tool-integration-workflow、cli-anything；包含「通道 x 鑰匙」判斷、Google Workspace 個人資料 OAuth 規則、常見服務路線、跨 Agent 設定入口，以及沒有現成工具時的 CLI-Anything 安裝與 fallback 指引
13：brainstorm；內建 Quick 規劃與 RDQ 四象限需求探索，原始 `lesson` 題庫已替換為機構工程 `mechanical`
14：social-cards
15：landing-page
16：cross-device-sync；chezmoi 必裝，負責 Codex／Claude／AntiGravity 原生入口與三 Agent 共用 Python-tools 中立 bridge／env loader／shell profile 標記區塊的 dry-run、備份、apply、驗證與新電腦重建；內建 session checkpoint、受控 update 與新入口 add 規則，不同步 venv
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
31：youtube-transcript-collector
32：voxcpm2-voice-cloner
33：audio-to-md
34：Python teaching file tools global runtime；不是 skill，安裝 Word / Excel / PPT / PDF / OCR / 圖表 / 影音輔助 Python 套件，建立跨專案 wrapper，並在 macOS/Homebrew 上安裝 Tesseract、Ghostscript、Poppler、ffmpeg 等系統工具；技能 runtime 仍各自放在 `{{CODEX_HOME}}/<skill-name>`
35：Taigi Teaching Agent；不是 skill，安裝 `mathruffian-dot/taigi-teaching-agent` 臺語教材產生器、Python 3.12 專用 venv 與 `taigi-teaching-agent` wrapper
36：voice-input-normalization；語音輸入文字正規化跨 Agent 安裝，包含 Codex / Claude Code / AntiGravity-Gemini / OpenCode 的 dry-run、apply、remove、備份與 idempotent upsert；跨 Agent 全域設定規範已併入 Item 16 `cross-device-sync`
37：voice-reply；三 Agent 共用的 macOS 語音回覆 skill，優先 Edge-TTS 串流，其次 Edge-TTS 整檔播放，最後 macOS `say` 離線備援；本機 runtime 沿用 `{{CODEX_HOME}}/voice-reply/.venv` 與 `{{CODEX_HOME}}/python-tools/bin`，但三個 Agent 都呼叫同一 wrapper
38：yaml-image-deck；通用 YAML-controlled image-first deck，不限定 SOIL；用固定視覺語法、受控版型、黃金樣張與逐頁 YAML 內容產生 NotebookLM-style 圖片式簡報
39：Coach Skill；Arry 私人來源橋接型安裝群組，驗證並啟用 `future-coach`、`voice-coach`、`waki-brain`、`productivity-coach`；需要私人 `{{SYNC_ROOT}}`，公開 Item 不含四套私人 corpus
```

Coach Skill 的四個成員都屬 Arry 私人 Skill：`future-coach` 含個人身份與記憶路由，`voice-coach`、`waki-brain`、`productivity-coach` 含私人課程或購課內容。它們只存在私人 `{{SYNC_ROOT}}/skills` 與 Obsidian 全域索引；Item 39 只提供安裝／驗證橋接，不提供可重建 corpus。這是隱私與內容權利邊界，不是 Agent 相容性限制。

路徑邊界固定如下：

| 類型 | 正式位置 | 用途 |
| --- | --- | --- |
| 可攜式全域核心規則 | `{{GLOBAL_RULES}}` | Codex、Claude、AntiGravity 共用的唯一內容主版本 |
| 跨 Agent 全域 skills | `{{SYNC_ROOT}}/skills` | 三個 Agent 共用的 skill package 主版本 |
| Chezmoi bootstrap | `{{CHEZMOI_SOURCE}}` | 維護三個 Agent 的原生規則／skills 入口 templates；不保存 secrets |
| Agent 原生入口 | `{{CODEX_HOME}}/*`、`{{CLAUDE_HOME}}/*`、`{{GEMINI_HOME}}/*` | symlink 到共享主版本，不複製內容 |
| LazyPack 安裝文件 | `{{SETUP_REPO}}/200_Reference/lazy-pack/01...39.md` | Items 01～38 依各文件標示內嵌公開可散布內容；Item 39 只含私人來源橋接 installer／verifier |
| 全域 Python 工具 runtime | `{{CODEX_HOME}}/python-tools` | 每台電腦本機重建的 Python 工具 venv 與 wrapper；供 Codex／Claude／AntiGravity 和所有專案共用，不放模型或技能專屬 runtime |
| 三 Agent Python 中立入口 | `{{HOME}}/.local/share/agent-tools/python-tools` | Item 16 的 chezmoi symlink，指向該機器的 Python tools runtime；三個 Agent 都從它的 `bin` 呼叫相同 wrapper |
| 三 Agent Python env loader | `{{HOME}}/.config/agent-tools/python-tools.env` | Item 16 建立；透過不覆蓋既有內容的 `.zshenv`／`.zprofile`／`.profile`／`.bash_profile` 標記區塊載入 PATH |
| Arry/個人助手全域入口 | `{{SYNC_ROOT}}/skills/{{ASSISTANT_SKILL_NAME}}` | 每次專案初始化都要帶入，用來讀取個人助手資料層並協助判斷 skill 歸屬 |
| 個人助手跨專案記憶 | `{{ASSISTANT_ROOT}}/memories` | 個人偏好、踩坑、跨專案可重用決策 |
| 個人助手跨專案 workflow | `{{ASSISTANT_ROOT}}/workflows` | 尚未升級成全域 skill 的 workflow 草稿 |
| 專案本地 skills | 各專案 `000_Agent/skills` | 只服務該專案的 assistant skill 或 workflow；這個資料夾本身就是專案可攜式 skill 包 |

不要把專案 `000_Agent/skills` symlink 到全域 skills。只有 `{{SYNC_ROOT}}/skills` 是共享主版本，各 Agent home 只保留 chezmoi 管理的原生入口。

任何新建或修改的 skill 都要做成可攜式版本：

- 全域 skill：同步 `{{SYNC_ROOT}}/skills/<skill-name>`、對應序號懶人包文件的內嵌安裝內容，與 Obsidian 全域 Skills 索引。
- 專案 skill：放在 `<project-root>/000_Agent/skills/<skill-name>`，保留完整 `SKILL.md`、references、scripts、assets；若該專案使用 Git，這個資料夾應跟著專案版本化。

維護者更新 Item 09／10／16 的 source skills 後，執行 `python3 200_Reference/scripts/sync-lazypack-embeds.py` 重建自含式安裝區塊；若 source skills 不在 repo 同層的 `codex_symlink/skills`，先設定 `SYNC_SKILLS_ROOT`。重跑前後內容應保持 idempotent，完成後仍要做隔離安裝驗證。

公開可散布的有序號懶人包文件應自含需要安裝的 `SKILL.md`、`references/`、`scripts/`、`templates/`、`assets/`、`agents/` 或 package 檔內容。一般情況下，`node_modules/` 這類可重建相依套件不內嵌，改由安裝者在自己的電腦重建；但 `social-cards/node_modules/` 是本使用者指定保留的可攜式執行依賴特例。Item 39 因私人身份、記憶與購課授權，採「公開 installer／verifier＋私人 `{{SYNC_ROOT}}`」模式，不把私人 package 內嵌到公開文件。

建議安裝順序：

| 順序 | Skill | 對應懶人包 | 狀態 |
| --- | --- | --- | --- |
| 1 | `cross-device-sync` | [[16-Codex-全域-Skills-跨裝置同步]] | 先設定 `{{SYNC_ROOT}}`；chezmoi 必裝，建立 Codex／Claude／AntiGravity 原生入口、Python-tools 中立 bridge 與 shell loader |
| 2 | `codex-skill-creator` | [[11-Codex-Skill-Creator-工作流]] | 為相容舊觸發語意保留此 ID；產出必須同時支援三 Agent |
| 3 | `project-init-sync` | [[10-專案初始化工作模式]] | 可直接安裝；Agent profile 固定為 Codex＋Claude＋AntiGravity，不刪除未安裝者 |
| 4 | `startup-sync` | [[10-專案初始化工作模式]] | 必讀 `HANDOFF.md`，執行受控 chezmoi checkpoint，再以 live state 為準 |
| 5 | `shutdown-sync` | [[10-專案初始化工作模式]] | 必建／必更新 `HANDOFF.md`，執行 chezmoi status checkpoint，不自動 commit／push |
| 6 | `arry-assistant` | [[09-個人助手設定]] | 個人助手模板；含 `agent-execution-strategy.md` 策略總入口，安裝時需改名與替換資料層路徑 |
| 7 | `secondbrain-research-digest` | [[05-第二大腦設定指南]] | 需設定 `{{OBSIDIAN_VAULT}}` |
| 8 | `tool-integration-workflow` / `cli-anything` | [[12-外部工具整合工作流]] | `tool-integration-workflow` 可直接安裝；`cli-anything` 透過 `200_Reference/scripts/cli-anything/install_cli_anything.sh` 將上游名為 `codex-skill` 的來源 package 安裝成三 Agent 共用 skill 與 CLI-Hub |
| 9 | `brainstorm` | [[13-Brainstorm-規劃模式]] | 可直接安裝；單一入口先選 Quick／RDQ，RDQ 含機構工程題庫 |
| 10 | `heptabase-cli` | [[02-Codex-MCP-Essentials]] | 外部 CLI 連線類，需 Heptabase desktop app 與 CLI |
| 11 | Notion connector／plugin／MCP | [[01-Codex-必裝-Skills-與-Plugins]] | 分別使用三 Agent 的原生通道；缺少時記錄已核准 fallback |
| 12 | `pdf`／`playwright` skills 與 PDF／Browser 原生能力 | [[01-Codex-必裝-Skills-與-Plugins]] | `pdf` 與 `playwright` 列為三 Agent 共用必裝 skills；各 Agent 原生 PDF／browser 能力另做 adapter 檢查 |
| 13 | `rightproblem-coach` | [[17-RightProblem-Coach-Skill-安裝]] | 可直接安裝；包含問題規格書模板、HC 指南與分析框架 |
| 14 | `doc-to-md` | [[18-Document-to-Markdown-Skill-安裝]] | 可直接安裝；合併文字轉檔與 VLM 視覺解讀，自動分流 PDF/EPUB/TXT/掃描 PDF/圖片與圖表 |
| 15 | `landing-page` | [[15-Landing-Page-Skill-安裝]] | 可直接安裝；支援引導生成與既有文案轉 CMS HTML，fallback 設計規則內建，UUPM 為選用 |
| 16 | `soil-html-deck` | [[19-SOIL-HTML-Deck-Skill-安裝]] | 可直接安裝；SOIL 互動 HTML 簡報 |
| 17 | `soil-image-deck` | [[20-SOIL-Image-Deck-Skill-安裝]] | 可直接安裝；SOIL 全圖像 PPTX |
| 18 | `soil-general-deck` | [[21-SOIL-General-Deck-Skill-安裝]] | 可直接安裝；SOIL 通用可編輯 PPTX |
| 19 | `yaml-image-deck` | [[38-YAML-Image-Deck-Skill-安裝]] | 可直接安裝；通用 YAML-controlled image-first deck，適合 NotebookLM-style 圖片式簡報、固定視覺語法、受控版型與黃金樣張，不限定 SOIL |
| 20 | `image-generator` | [[22-Image-Generator-Skill-安裝]] | 可直接安裝；優先當前 Agent 原生生圖／修圖能力，缺少時走已核准 fallback |
| 21 | `visual-note-generator` | [[23-Visual-Note-Generator-Skill-安裝]] | 可直接安裝；固定手繪筆記 Workflow、可替換 Style Profile、內建 Arry 預設風格與 16:9／2K 驗收 |
| 22 | `diary-interview-assistant` | [[24-Diary-Interview-Assistant-Skill-安裝]] | 可直接安裝；間歇式日記訪談、寫作洞察與文章草稿提示 |
| 23 | `gemini-free-api` | [[25-Gemini-Free-API-Skill-安裝]] | 可直接安裝；Gemini API Free Tier、`GEMINI_API_KEY` 安全儲存、收費邊界與後端整合 |
| 24 | HyperFrames skill suite | [[26-HyperFrames-Skill-安裝]] | 可直接安裝；HTML/CSS/media/seekable animation 到 MP4 的影片 composition 工作流，含相片紀念影片預覽、音訊驗證與完稿後資料夾清理詢問；實際 render 需 Node.js 22+ 與 FFmpeg |
| 25 | Video Spec Builder | [[27-Video-Spec-Builder-Skill-安裝]] | 可直接安裝；追問影片需求、拆分鏡、產出可交給 HyperFrames 的 `video-spec.md` |
| 26 | `netlify-deploy` | [[28-Netlify-Deploy-Skill-安裝]] | 可直接安裝；官方 Netlify MCP 設定、Netlify 前端部署與 Clasp + Apps Script API 閉環部署流程 |
| 27 | `video-processing-automation` | [[29-Video-Processing-Automation-Skill-安裝]] | 可直接安裝；原始影片到 YouTube / 社群影片上架包，含智能剪口播、Groq STT、專案詞彙表字幕修正、文字稿、封面、metadata、短片亮點與 ffprobe 驗收 |
| 28 | `video-creation-automation` | [[30-Video-Creation-Automation-Skill-安裝]] | 可直接安裝；沒有現成影片時，先確認入口後生成腳本、設計、素材、旁白、HyperFrames composition 與渲染包；補入離線可重現資源、lint / validate / inspect / ffprobe 驗收；若已有影片則轉用 `video-processing-automation` |
| 29 | `youtube-transcript-collector` | [[31-YouTube-Transcript-Collector-Skill-安裝]] | 可直接安裝；頻道搜尋同時抓 `/videos` 與 `/streams` 並去重，先匯入 YouTube 影片總表，再判斷直播/中文字幕狀態，逐支抓取 `zh-TW` / `zh-Hant` 字幕 MD；web client 看不到字幕時可用 android player client fallback，並讓 `字幕 MD` 欄只放實際檔案連結 |
| 30 | `voxcpm2-voice-cloner` | [[32-VoxCPM2-Voice-Cloner-Skill-安裝]] | 可直接安裝；授權聲音克隆、合成聲音設計、Apple Silicon MPS／CUDA／CPU、本機 runtime／模型快取路由與 consent gate |
| 31 | `audio-to-md` | [[33-Audio-to-Markdown-Skill-安裝]] | 可直接安裝；Phase 1 前先詢問使用者選本機 Whisper 或 Groq 雲端 STT，將音訊／影片轉成 Markdown 逐字稿知識庫；Phase 2 由當前 Agent 依同一契約做逐段校稿、摘要與重點整理，需要的差異腳本記在 adapter |
| 32 | Python teaching file tools runtime | [[34-Python-Tools-全域工具包安裝]] | 可直接安裝；每台電腦建立 `{{CODEX_HOME}}/python-tools`，透過 Item 16 中立 bridge 供 Codex／Claude／AntiGravity 與所有專案共用 Word／Excel／PPT／PDF／OCR／圖表／影音輔助 Python 套件和 wrapper；內含完整 wrapper 來源矩陣，額外功能由 Items 12／18／32／33／35／37 補齊；macOS/Homebrew 會安裝 Tesseract、Ghostscript、Poppler、ffmpeg，LibreOffice 可用 `INSTALL_OFFICE_TOOLS=1` 按需安裝 |
| 33 | Taigi Teaching Agent | [[35-Taigi-Teaching-Agent-安裝]] | 可直接安裝；建立 `{{CODEX_HOME}}/python-tools/taigi-teaching-agent`、專用 Python 3.12 venv 與 `taigi-teaching-agent` wrapper，用於臺羅標音、臺語 TTS、教材檢核與範例教材生成 |
| 34 | Voice Input Normalization | [[36-Voice-Input-Normalization]] | 可直接安裝；包含 `voice-input-normalization`，提供 Codex / Claude Code / AntiGravity-Gemini / OpenCode 的 dry-run、apply、remove、備份與 idempotent upsert；跨 Agent 全域設定規範歸 Item 16 `cross-device-sync` |
| 35 | Voice Reply | [[37-Voice-Reply-Skill-安裝]] | 可直接安裝；三 Agent 共用 macOS 語音回覆 wrapper，優先 Edge-TTS 串流，整檔播放備援，最後 macOS `say` 離線備援 |
| 36 | Coach Skill | [[39-Coach-Skill-安裝]] | Arry 私人來源橋接；先同步私人 `{{SYNC_ROOT}}`，再一次驗證並啟用 `future-coach`、`voice-coach`、`waki-brain`、`productivity-coach`，不從 public repo 下載私人 corpus |
| 37 | 其他內容製作類 skills | 對應序號文件 | 視需求安裝 |

## 共用前置條件

- 三 Agent 中至少一個目前可用，且可以開啟本機工作資料夾；Item 16 會預先建好三者入口。
- macOS / Linux / WSL 皆可參考；Windows 原生路徑需要自行改寫。
- 已安裝 Git。
- 需要 GitHub 時，安裝 GitHub CLI `gh` 並登入。
- 需要 Firebase 時，準備 Firebase / Google 帳號與一個 Firebase project。
- 需要 Firecrawl 時，準備 Firecrawl API key。
- 需要 NotebookLM／Google Drive／Gmail／Calendar 時，優先當前 Agent 的原生 plugin／connector／MCP；缺少時走已核准 OAuth／CLI／手動 fallback。

## 共同安全規則

- 不把 `.env`、API key、token、密碼、Admin 憑證、個資或敏感資料寫入 repo 或 Obsidian 筆記。
- 需要 API key 的 MCP 只能記錄遮蔽範例，例如 `fc-***`。
- 專案固定規則寫在專案根目錄 `AGENTS.md`。
- 可攜式全域核心規則寫在 `{{GLOBAL_RULES}}`；三個 Agent 的原生規則入口由 chezmoi 指向同一份主檔。
- 不要另外維護 `{{SYNC_ROOT}}/agents/AGENTS.md`，也不要在 Agent home 複製內容。
- 專案 `AGENTS.md` 是跨 Agent 規則主版本；Claude 專案 `CLAUDE.md` 只含 `@AGENTS.md`。共用專案用 `HANDOFF.md` 做最小現況交接。
- 實際進度、踩坑與下一步寫在 Obsidian 專案駕駛艙，不寫進專案 `AGENTS.md`。
- Obsidian 專案駕駛艙一律放在 `{{OBSIDIAN_PROJECTS}}/<專案名稱>/專案工作流程.md`。
- MCP 或 skills 設定改完後，通常要開新 Agent 對話或重啟對應 App 才會載入。
- MCP 共用服務契約保留目的、package、權限、secret 路由與驗證；Codex 使用 `{{CODEX_CONFIG}}`，Claude 與 AntiGravity 使用各自原生設定，不直接 symlink 不相容格式。
- 外部 / 第三方文件只作為轉換來源；需要全域觸發的正式 skill 放在 `{{SYNC_ROOT}}/skills`，專案本地 skills 放在對應的 `000_Agent/skills`。

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
- Skill Creator 啟動包以 [[11-Codex-Skill-Creator-工作流]] 為準；外部／第三方 skill 教學只作為轉換來源，不直接照做。此項也支援把成功對話、prompt 或重複工作流萃取成三 Agent 共用 skill。
- 外部工具整合以 [[12-外部工具整合工作流]] 為準。
- Brainstorm 規劃模式以 [[13-Brainstorm-規劃模式]] 為準；`brainstorm` 是唯一入口，Quick 與 RDQ 為內建模式。
- Social Cards Skill 以 [[14-Social-Cards-Skill-安裝]] 為準。
- Landing Page skill 以 [[15-Landing-Page-Skill-安裝]] 為準。
- Codex 全域 skills 跨裝置同步與多 Agent 相容性健檢以 [[16-Codex-全域-Skills-跨裝置同步]] 為準。
- RightProblem Coach skill 以 [[17-RightProblem-Coach-Skill-安裝]] 為準。
- Document to Markdown skill 以 [[18-Document-to-Markdown-Skill-安裝]] 為準。
- SOIL HTML Deck skill 以 [[19-SOIL-HTML-Deck-Skill-安裝]] 為準。
- SOIL Image Deck skill 以 [[20-SOIL-Image-Deck-Skill-安裝]] 為準。
- SOIL General Deck skill 以 [[21-SOIL-General-Deck-Skill-安裝]] 為準。
- YAML Image Deck skill 以 [[38-YAML-Image-Deck-Skill-安裝]] 為準；它是通用 YAML 圖片式簡報，不取代 SOIL 三組 skills。
- Coach Skill 私人教練安裝群組以 [[39-Coach-Skill-安裝]] 為準；公開文件只提供安裝與驗證橋接，四個私人 Skill 本體必須由 Arry 的私人 `{{SYNC_ROOT}}` 同步。
- Image Generator skill 以 [[22-Image-Generator-Skill-安裝]] 為準。
- 2026-05-24 起，公開可散布的有序號懶人包文件本身內嵌對應全域 skill 的完整安裝內容；Item 39 是私人來源例外，必須先取得 Arry 自己的私人雲端 `{{SYNC_ROOT}}`，public repo 不提供四套私人 corpus。
- Diary Interview Assistant Skill 以 [[24-Diary-Interview-Assistant-Skill-安裝]] 為準。
- Gemini Free API Skill 以 [[25-Gemini-Free-API-Skill-安裝]] 為準。
- HyperFrames Skill suite 以 [[26-HyperFrames-Skill-安裝]] 為準。
- Video Spec Builder Skill 以 [[27-Video-Spec-Builder-Skill-安裝]] 為準。
- Netlify Deploy Skill 以 [[28-Netlify-Deploy-Skill-安裝]] 為準。
- Video Processing Automation Skill 以 [[29-Video-Processing-Automation-Skill-安裝]] 為準。
- Video Creation Automation Skill 以 [[30-Video-Creation-Automation-Skill-安裝]] 為準。
- YouTube Transcript Collector Skill 以 [[31-YouTube-Transcript-Collector-Skill-安裝]] 為準。
- VoxCPM2 Voice Cloner Skill 以 [[32-VoxCPM2-Voice-Cloner-Skill-安裝]] 為準；runtime／模型快取放本機 Codex runtime，reusable voice profile 放全域助手資產，生成音檔放當次專案資料夾並排除 Git。
