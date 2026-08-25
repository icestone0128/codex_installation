# 02-Codex-MCP-Essentials

> 2026-07-30 更新：新增 Claude-first 的 Google Workspace MCP 必要項，固定使用 `workspace-mcp==1.22.2`、本機 loopback HTTP 與共用 Python runtime；完整 installer、runner 與 macOS LaunchAgent template 放在 `02-assets/google-workspace-mcp/`。MCP 仍採「共用服務契約＋Codex／Claude／AntiGravity 原生 adapter」。
>
> 2026-08-02 更新：Google Workspace MCP 由使用者明確要求改為可實際操作，權限提升為 Drive／Gmail／Calendar `full` 加 `--tool-tier complete`，取代原本的 core read-only 預設。擴權後仍維持 loopback-only 綁定與 secrets 隔離，且寫入類動作（寄信、刪檔、修改行事曆）在各 Agent 執行前仍需逐次向使用者確認。


## 目標

把來源工具 CLI 取向的 MCP 安裝概念，改成 Codex、Claude、AntiGravity 都可執行的整合方式：共用服務目的、package、權限、secret 路由與驗證，設定檔則分別使用三個原生 adapter。

## 前置條件

- 三 Agent 中至少一個現在可用；Item 16 已準備三者原生入口。
- 若設定 Codex adapter，已決定 `{{CODEX_CONFIG}}`；Claude 與 AntiGravity 依當前安裝版本的官方 help 確認原生 MCP 設定位置。
- 已安裝 Node.js / npm。
- 新電腦先跑最小檢查；缺工具時先告知用途與安裝位置，再取得使用者同意，不要靜默安裝：

```bash
node --version
npm --version
git --version
python3 --version
```

- 多數本地 stdio MCP server 透過 `npx` 啟動，沒有 Node.js / npm 會直接失敗。
- Git 只在安裝腳本需要 clone 或從 GitHub 安裝時才是必要。
- Python 只在 Python CLI、uv tool 或 CLI-Anything harness 需要時才是必要。
- Google Workspace MCP 需要 `uv` 與 Python 3.10+；本 Item 的安裝器固定用 Python 3.12，並重用 Item 34 的 `{{CODEX_HOME}}/python-tools` 共用 runtime。
- 需要 Firecrawl 時，準備 `{{CODEX_HOME}}/secrets/firecrawl_api_key`，權限設為 `600`。
- 需要 Filesystem MCP 時，先決定最小授權資料夾。

## 三 Agent MCP adapter

共用層只定義服務目的、package／endpoint、權限、secret 路由與最小驗證。不同 MCP client 的設定檔格式不共用、不 symlink。

Codex adapter 使用：

```text
{{CODEX_CONFIG}}
```

也可使用 Codex CLI 的 MCP 指令建立本機 stdio server：

```bash
codex mcp add <名稱> -- npx -y <MCP套件名>
codex mcp list
```

新增或修改 MCP server 後，通常要重啟 Codex App 或開新對話才會載入。

Claude adapter：依當前版本的 `claude mcp add`、專案 `.mcp.json` 或 user config 建立，並用 `claude mcp list` 或官方 help 確認。AntiGravity adapter：依當前版本 MCP Store 或 `{{GEMINI_CONFIG}}/mcp_config.json` 建立並重載。若原生 MCP 通道不可用，三者都可回退到官方 CLI、已核准 API 或手動流程。

## Firecrawl MCP

用途：抓取公開網頁、轉成乾淨文字或 Markdown，適合摘要文章、整理網頁資料。

在 `{{CODEX_CONFIG}}` 加入：

```toml
[mcp_servers.firecrawl]
command = "sh"
args = ["-lc", "NPM_CONFIG_CACHE=/private/tmp/firecrawl-mcp-cache FIRECRAWL_API_KEY=$(cat {{CODEX_HOME}}/secrets/firecrawl_api_key) npx -y firecrawl-mcp"]
startup_timeout_sec = 30
tool_timeout_sec = 120
```

安全規則：

- API key 只放在 `{{CODEX_HOME}}/secrets/firecrawl_api_key` 或等效本機 secret manager，不可寫入 repo。
- 文件只能寫遮蔽範例，例如 `fc-***`。
- 若 key 外洩，到 Firecrawl dashboard 旋轉或重建。

驗證：

- 用公開測試頁，例如 `https://example.com`。
- 不要用大量 URL 做壓力測試。
- 若 `npx firecrawl-mcp` 出現套件樹或 nested dependency 解析錯誤，先改用 Firecrawl 專用 cache：`NPM_CONFIG_CACHE=/private/tmp/firecrawl-mcp-cache`，不要和其他 MCP 共用已污染的 npm cache。

## Filesystem MCP

用途：讓當前 Agent 透過 MCP 存取工作區外的指定資料夾。三 Agent 的授權範圍要分別驗證，不得假設共用權限。

先選最小授權範圍，例如：

```text
{{FILESYSTEM_ALLOWED_DIR}}
```

範例：

```text
{{FILESYSTEM_ALLOWED_DIR}}
```

在 `{{CODEX_CONFIG}}` 加入：

```toml
[mcp_servers.filesystem]
command = "env"
args = ["NPM_CONFIG_CACHE=/private/tmp/npm-cache", "npx", "-y", "@modelcontextprotocol/server-filesystem", "{{FILESYSTEM_ALLOWED_DIR}}"]
startup_timeout_sec = 30
tool_timeout_sec = 120
```

安全規則：

- 不要一次授權 Desktop、Downloads、整個雲端硬碟。
- 只開實際需要的單一路徑。
- 需要更多資料夾時，再由使用者明確追加。

## Heptabase CLI Skill

用途：讓 Codex、Claude、AntiGravity 都能透過共用 Heptabase CLI skill 管理 note、journal、tag、card、whiteboard 與 AI Tutor 內容。

這一項歸在 02，因為它是外部工具 / CLI 連線能力，不放在 01 的基礎 plugin 檢查裡。使用前請確認：

- 已安裝 Heptabase desktop app。
- Heptabase CLI 可用，並符合 skill 相容版本 `0.5.x`（用 `heptabase --version` 確認）。
  CLI 沒有自己的更新機制：PATH 上的 `heptabase` 是 wrapper，實際執行桌面 app 內的 bundle，
  版本只會隨 app 更新而變動，Homebrew 管不到。
- Heptabase desktop app 的 local CLI server 已啟用；如果 read-only 指令回報無法連線，先執行 `heptabase start` 或在桌面 app 的 Settings > AI Features 啟用 CLI。
- 實際操作前先用 read-only 指令確認連線，不直接寫入。

安裝方式請使用本文文末「內建 Skill 完整安裝內容」；本項會同步安裝 `SKILL.md` 與 `references/`。

## Google Workspace MCP（Claude-first 必要項）

用途：在 Claude Code 沒有 Codex Google plugins 的環境中，提供同一個 Drive／Gmail／Calendar 工作面。來源是 [taylorwilsdon/google_workspace_mcp](https://github.com/taylorwilsdon/google_workspace_mcp)，Python package 固定為 `workspace-mcp==1.22.2`；更新版本前要先重跑權限與工具清單驗證。

新安裝的建議起點是最小權限；本機目前這台則是使用者明確要求後的可操作設定：

- 只啟用 `calendar`、`drive`、`gmail`。
- 新環境建議起點：`--tool-tier core` 加三服務 `readonly`。
- 本機目前設定（2026-08-02，使用者要求）：`--tool-tier complete` 加 `calendar:full drive:full gmail:full`，可建立與修改 Drive 檔案、行事曆事件，並具備 Gmail 寄信 scope。
- 擴權不改變其他邊界：HTTP server 只綁定 `127.0.0.1:8000`，不對區網或網際網路開放。
- 擴權後由 Agent 行為層把關：寄信、刪除、覆蓋與其他不可逆動作，執行前一律逐次向使用者確認，不因為 scope 已開就自動執行。
- OAuth client secret 與 token 只放在 `{{CODEX_HOME}}/secrets`，不寫進 repo、LazyPack、Obsidian 或 Agent 設定。
- Codex 已有 Google Drive、Gmail、Calendar 官方 plugins 時繼續使用原生 plugins；避免在同一個 Agent 重複暴露兩套同義工具。Claude 預設連這個 MCP；AntiGravity 依其目前原生 MCP 入口加上同一 endpoint。

### 1. Google Cloud 最小設定

建議建立一個專用 Google Cloud project；若帳號已達 project quota，可沿用既有 project，但只新增獨立 OAuth client，不改 Firebase 或其他服務設定。

1. 在 OAuth consent screen 建立 app，External 測試模式要把自己的 Google 帳號加入 Test users。
2. 只啟用：
   - Google Drive API
   - Gmail API
   - Google Calendar API
3. 建立 `Desktop app` 類型的 OAuth 2.0 Client。
4. 不要把下載的 OAuth JSON 放進 repo。只把 client ID、client secret 與登入帳號存成下列本機檔案：

```text
{{CODEX_HOME}}/secrets/google_workspace_mcp_oauth_client_id
{{CODEX_HOME}}/secrets/google_workspace_mcp_oauth_client_secret
{{CODEX_HOME}}/secrets/google_workspace_mcp_user_email
```

安全寫入範例：

```bash
install -d -m 700 "{{CODEX_HOME}}/secrets"

IFS= read -r -p "OAuth client ID: " google_client_id
printf '%s\n' "$google_client_id" > "{{CODEX_HOME}}/secrets/google_workspace_mcp_oauth_client_id"
unset google_client_id

IFS= read -r -s -p "OAuth client secret: " google_client_secret
printf '\n'
printf '%s\n' "$google_client_secret" > "{{CODEX_HOME}}/secrets/google_workspace_mcp_oauth_client_secret"
unset google_client_secret

IFS= read -r -p "Google account email: " google_user_email
printf '%s\n' "$google_user_email" > "{{CODEX_HOME}}/secrets/google_workspace_mcp_user_email"
unset google_user_email

chmod 600 "{{CODEX_HOME}}/secrets/google_workspace_mcp_"*
```

### 2. 安裝共用 runtime 與本機服務

從完整 LazyPack 根目錄執行：

```bash
bash 02-assets/google-workspace-mcp/install_google_workspace_mcp.sh
```

若從本 repo 根目錄執行：

```bash
bash 200_Reference/lazy-pack/02-assets/google-workspace-mcp/install_google_workspace_mcp.sh
```

安裝器會：

- 用 `uv tool` 把固定版本安裝到 `{{CODEX_HOME}}/python-tools/google-workspace-mcp/uv-tools`。
- 把共用執行入口放在 `{{CODEX_HOME}}/python-tools/bin`。
- 建立 `{{CODEX_HOME}}/secrets/google_workspace_mcp_credentials` 作為 OAuth token 目錄，權限為 `700`。
- 在 macOS 建立 `com.lazy-pack.google-workspace-mcp` LaunchAgent，保持 loopback server 可用。
- 預設以 user scope 新增 Claude HTTP adapter：`google-workspace -> http://127.0.0.1:8000/mcp`。
- 等待 server readiness 後才判定成功，避免背景啟動較慢造成假失敗。

Linux／WSL 不會安裝 macOS LaunchAgent；請用 systemd user service 或在使用前執行：

```bash
"{{CODEX_HOME}}/python-tools/bin/google-workspace-mcp-server"
```

### 3. 三 Agent adapter

共用 endpoint：

```text
http://127.0.0.1:8000/mcp
```

Claude adapter（安裝器預設自動完成）：

```bash
claude mcp add --transport http --scope user google-workspace http://127.0.0.1:8000/mcp
claude mcp list
```

Codex adapter（只有在沒有或停用對應 Google plugins 時才加）：

```bash
codex mcp add google-workspace --url http://127.0.0.1:8000/mcp
codex mcp list
```

AntiGravity adapter：在目前版本的 MCP Store 或 `{{GEMINI_CONFIG}}/mcp_config.json` 加入相同 HTTP endpoint，再重載。若使用 Gemini CLI：

```bash
gemini mcp add --scope user --transport http google-workspace http://127.0.0.1:8000/mcp
gemini mcp list
```

三個 adapter 不共用設定檔，也不把彼此的 JSON／TOML 做 symlink；共用的只有 endpoint、權限、OAuth secret 路由與驗證標準。

### 4. OAuth 與唯讀驗證

先驗證 server：

```bash
bash 02-assets/google-workspace-mcp/install_google_workspace_mcp.sh --check
"{{CODEX_HOME}}/python-tools/bin/workspace-cli" \
  --url http://127.0.0.1:8000/mcp \
  list
```

第一次實際呼叫 Google 工具時，依畫面開啟 OAuth URL 並同意指定 scope；token 會進入 `{{CODEX_HOME}}/secrets/google_workspace_mcp_credentials`。之後只做低風險 read-only smoke test：

- Calendar：列出日曆或查一段短日期範圍。
- Drive：搜尋一個已知、不敏感的測試檔名。
- Gmail：搜尋自己的低敏感測試郵件；不要批次讀整個信箱。
- 若沿用新環境建議的 core read-only 起點，工具清單不應包含寄信、建立 Drive 檔案、建立資料夾或修改行事曆事件等寫入工具。
- 若採用本機目前的 `complete` 加 `full` 設定，工具清單會包含上述寫入工具；smoke test 仍只做唯讀查詢，不用真實資料驗證寫入或寄信。

新增 Docs／Sheets／Slides／Tasks 或從 read-only 擴權，都要回到最小權限評估並取得使用者明確要求；不要把 `complete` tier 當成安裝成功捷徑或預設值。擴權後必須重新完成 OAuth 同意，舊 token 的 scope 不會自動升級。

### 5. 更新、停用與撤銷

版本更新必須明確指定並重新驗證：

```bash
WORKSPACE_MCP_VERSION=<已審查版本> \
  bash 02-assets/google-workspace-mcp/install_google_workspace_mcp.sh
```

停用 Claude adapter：

```bash
claude mcp remove --scope user google-workspace
```

撤銷時同步：

1. 在 Google Account 撤銷該 app 的授權。
2. 在 Google Cloud 刪除或停用對應 OAuth client。
3. 卸載各 Agent adapter。
4. 停止本機 LaunchAgent。
5. 將 `{{CODEX_HOME}}/secrets/google_workspace_mcp_credentials` 移到垃圾桶或安全刪除。

## 驗證

完成當前 Agent adapter 後：

1. 重載對應的 Codex、Claude 或 AntiGravity 對話／MCP 設定。
2. 使用該 Agent 的原生 list／status 指令或工具清單確認載入；Codex 可用 `codex mcp list`，Claude 可用 `claude mcp list`。
3. 請當前 Agent 回報目前可用 MCP／plugin／connector 工具。
4. Firecrawl：抓取 `https://example.com`。
5. Filesystem：列出 `{{FILESYSTEM_ALLOWED_DIR}}` 內的一個測試資料夾。
6. Browser plugin：開啟 `https://example.com` 並截圖。
7. Google Workspace MCP：確認 endpoint handshake、三服務工具清單與目前 `--permissions` 設定相符，並各做一個低敏感 read-only 查詢；有原生 Google plugins 的 Codex 不重複安裝 adapter。

若任何一項失敗，先檢查 command 絕對路徑、API key、登入狀態與當前 Agent 是否已重載，再測試共用 CLI／API fallback。

## 跨系統 MCP 設定坑

- Codex App 使用 TOML；不要直接 symlink 或照貼 Claude、AntiGravity、OpenCode 的 JSON 設定檔。
- JSON 設定檔不能有註解或多餘逗號；共用的 MCP 目的、package 與權限保持一致，再分別寫成 Codex TOML、Claude 原生設定與 AntiGravity 原生設定。
- Windows 路徑在 JSON 中要用 `C:/path` 或 `C:\\path`；單一 `\` 會破壞 JSON。Codex TOML 中也應避免未跳脫的反斜線。
- Claude Code 在 Windows 原生環境啟動 `npx` stdio MCP 時常需要 `cmd /c`；這是 Claude 的格式，不要直接套進 Codex TOML。
- ChatGPT App 的官方 Apps / Plugins 入口可能改名；若介面和文件不同，以目前 App UI 或官方文件為準。
- 如果 MCP 裝太多造成回應變慢或工具選擇混亂，停用本專案不需要的 MCP，只保留當前任務需要的工具。

## npm cache 權限修正

症狀：

```text
npm error Your cache folder contains root-owned files
```

修正：MCP 設定裡用暫存 npm cache；Firecrawl MCP 建議使用獨立 cache，避免與其他 `npx` MCP 共用套件樹。

```toml
command = "env"
args = ["NPM_CONFIG_CACHE=/private/tmp/npm-cache", "npx", ...]

[mcp_servers.firecrawl]
command = "sh"
args = ["-lc", "NPM_CONFIG_CACHE=/private/tmp/firecrawl-mcp-cache FIRECRAWL_API_KEY=$(cat {{CODEX_HOME}}/secrets/firecrawl_api_key) npx -y firecrawl-mcp"]
```

避免去改 `~/.npm` 權限，也避免使用 `sudo`。

## 設定範例

本機 Codex adapter 曾成功測試；Claude 與 AntiGravity 安裝後也要重複同一組低風險測試：

- Firecrawl 抓 `https://example.com`。
- Filesystem MCP 授權單一路徑。
- Codex Browser plugin 開啟 `https://example.com` 並截圖。

下載者要用自己的 API key 與授權資料夾。

## 踩坑修正

- 當前 Agent 已有原生 browser／computer-use 時，瀏覽器自動化優先使用原生通道；需要可重現 CLI 時改用 `playwright` skill。
- Filesystem MCP 授權範圍不能太大，否則安全風險高。
- Firecrawl key 不能進 Git、Obsidian 公開筆記或 README。
- Google Workspace OAuth client secret 與 token 只能放在 `{{CODEX_HOME}}/secrets`；OAuth consent、Desktop client、三個 API 與首次登入缺一不可。
- Google Workspace MCP 目前為 Drive／Gmail／Calendar `full` 加 `complete` tier，是使用者在 2026-08-02 明確要求的可操作設定，不是安裝預設。新環境從 core read-only 起步，只有在使用者明確要求時才擴權，並且要重跑 OAuth 同意與工具清單驗證。
- 首次 OAuth 的 authorization URL 含短效 state；看到 `Invalid or expired OAuth state parameter` 時，不要重建 client，直接重跑原本的唯讀工具取得新 URL，並在約 10 分鐘內完成同意與 callback。
- macOS LaunchAgent 啟動 Python server 可能需要數秒；安裝器要等待 MCP handshake，不以單次立即探測判定失敗。
- 對影響到的 Codex、Claude、AntiGravity 分別重載後，再確認 MCP 是否出現在實際可呼叫工具清單。


<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊。這個序號項目會安裝：`heptabase-cli`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請依 README 設定 `{{SYNC_ROOT}}`；package 只寫入共用主版本，Item 16 與 chezmoi 會建立 Codex、Claude、AntiGravity 的原生入口。

````bash
set -e

# ---- heptabase-cli ----
mkdir -p "{{SYNC_ROOT}}/skills/heptabase-cli"
# heptabase-cli/SKILL.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/heptabase-cli/SKILL.md")"
cat > "{{SYNC_ROOT}}/skills/heptabase-cli/SKILL.md" <<'AGENT_LAZYPACK_HEPTABASE_CLI_SKILL_MD_0E95F5A366'
---
name: heptabase-cli
description: >-
  Reads and edits a Heptabase knowledge base through the `heptabase` CLI. Use when the user says
  Heptabase, 白板, whiteboard, 卡片, card library, 日記, journal, AI Tutor, 學習課程, or asks to search
  cards, read or append notes and journals, edit card properties or tags, read parsed PDF pages,
  read audio or video transcripts, export a file from a card, place cards on a whiteboard, or browse
  AI Tutor goals, courses, and lessons. Requires the desktop app running with CLI enabled. Not for
  Obsidian or other note apps, and not for Heptabase features the CLI does not expose.
allowed-tools: Bash(heptabase *) Bash(jq *) Bash(mktemp *)
metadata:
  heptabase-cli-version-range: "0.5.x"
  last-updated: "2026-08-26"
---

## Prerequisites

- CLI installed from the desktop app. The command is `heptabase` on macOS/Linux; Windows installs `heptabase.cmd` for cmd/PowerShell and a `heptabase` shim for POSIX shells.
- Check version compatibility before use with `heptabase --version`. If the installed CLI version is outside this skill's compatibility range (`0.5.x`), you MUST stop and ask the user to update either the Heptabase desktop app or this skill package before continuing.
- The CLI has no updater of its own. `heptabase` on PATH is a thin wrapper that runs the bundle inside the desktop app, so the CLI version moves only when the app is updated. Homebrew does not manage it.

## Command discovery

Run `heptabase help` to see all available top-level commands. This is always up to date. Each command supports `--help` for detailed usage:

```bash
heptabase help
heptabase note --help
heptabase note create --help
```

## Common recipes

Use these as quick recipes for frequent requests. For less common flags or if a command fails, run `heptabase help` or `<command> --help` to discover the correct syntax.

- **Recent cards:** `heptabase card list --sort createdTime --direction descending --limit 20`
- **Today's journal:** `heptabase journal read $(date +%Y-%m-%d)`
- **Search cards by keyword:** `heptabase card list -q "<keyword>" --limit 20`
- **List tag properties:** `heptabase tag properties <tagId>`
- **List cards with property values:** `heptabase tag cards <tagId> --include-properties`
- **Read card properties:** `heptabase card properties <cardIdOrDate>`
- **Set card property:** first read `references/property-values.md`, then use `heptabase card set-property <cardIdOrDate> --property-id <propertyId> --value "Published"` for strings/options or `--json-value ...` for typed JSON values.
- **Read parsed PDF content:** first read `references/pdf-reading.md`, then use `heptabase pdf metadata <pdfCardId>` to discover `totalPages`, and read a page range with `heptabase pdf read <pdfCardId> --start-page N --end-page N`.
- **Read transcript content:** first read `references/transcript-reading.md`, then use `heptabase audio metadata <audioCardId>` or `heptabase video metadata <videoCardId>` to discover `transcriptStatus` and `durationSeconds`, and read overlapping transcript entries in a time range with `heptabase audio read <audioCardId> --start-seconds 0 --end-seconds 300` or `heptabase video read <videoCardId> --start-seconds 0 --end-seconds 300`.
- **Read a file from a PDF/media card:** first read `references/file-reading.md`, then use `heptabase file list --card-id <cardId>` to find the right file `id`, run `mktemp -d`, and pass the returned directory path to `heptabase file export <fileId> --output-dir <scratchDir>`. Read the returned `path` with your native file-reading tool.
- **Read a file by `fileId`:** first read `references/file-reading.md`, then run `mktemp -d` and pass the returned directory path to `heptabase file export <fileId> --output-dir <scratchDir>`. Read the returned `path` with your native file-reading tool.
- **List cards on a whiteboard:** `heptabase whiteboard cards <whiteboardId>`
- **Add a card to a whiteboard:** `heptabase whiteboard add-card --whiteboard-id <whiteboardId> --card-id <cardIdOrDate>`
- **Add a local file to a whiteboard:** `heptabase local-file add --whiteboard-id <whiteboardId> --path <absolutePath>`. One absolute path per call; it places a placeholder, it does not copy the file into Heptabase.

## AI Tutor: goals, courses, lessons

Three read-only command groups, arranged as a hierarchy: a **goal** is a top-level topic, it holds **courses**, and each course holds **lessons**. Start at whichever level the user names; only walk down from `goal list` when they have not named one.

- **List root goals with their courses:** `heptabase goal list` — returns each goal plus its child courses, so this alone often answers "what am I learning".
- **List every course across all goals:** `heptabase course list` — `goalId` is the parent goal, or `null` when the course is itself a root goal.
- **Read a course syllabus:** `heptabase course read <courseId>` — returns `overview`, `expectedOutcome`, and nested `topics`/`subtopics`. Each subtopic carries `status` (`notStarted` | `inProgress` | `covered`) and `coveredSummary`; use those to report progress rather than guessing from titles.
- **List lessons in a course:** `heptabase lesson list <courseId>` — chronological.
- **Read a lesson plan and its artifact card:** `heptabase lesson read <lessonId>`.
- **Read lesson chat messages:** `heptabase lesson list-messages <lessonId> --limit 20 --offset 0` — max 100 per page; page through with `--offset` rather than raising the limit past 100.

All of these take UUIDs, not titles. Resolve a title to an id with the list command one level up; do not guess an id.

## Property editing

Before setting a property value, you MUST read `references/property-values.md` and inspect the target property with `heptabase card properties <cardIdOrDate>` and/or `heptabase tag properties <tagId>`. Property formats vary by type, and relation writes replace the full relation value. For relation properties, use `heptabase tag properties <sourceTagId>` to get the property definition's `relationTargetTagId`, then list valid related cards before writing.

## File reading

Before reading/listing files or exporting a file, you MUST read `references/file-reading.md`.

## PDF reading

Before reading parsed PDF content, you MUST read `references/pdf-reading.md`.

## Transcript reading

Before reading parsed media transcripts, you MUST read `references/transcript-reading.md`.

## All output is JSON

Every command prints JSON to stdout. You can parse it with `jq` or pipe it to other tools.

## Troubleshooting

- **Desktop app must be running.** The CLI communicates with a local server inside the app. If the app is closed, all commands fail. Run `heptabase start` to launch and wait for readiness.
- **Codex sandbox may block the local CLI server.** If Heptabase starts but Codex says the CLI server is not ready, read `references/codex-sandbox.md`; retry `heptabase` commands outside the sandbox when Codex supports escalation.
- **Mutations are serialized.** Write operations (create, save, append, trash, restore, tag add/remove, card set-property, file export, whiteboard add-card/remove-card) run one at a time to prevent conflicts. Reads are concurrent.
- **Request body size limit.** The server rejects request bodies larger than 1 MB.
- **Request timeout.** The server times out requests that take longer than 10 seconds to send their body.

## Known limitations

- **Auto-enabling local server/CLI install not supported.** If the local CLI server is disabled or CLI wiring is missing, the skill cannot repair it by itself; ask the user to enable Local CLI Server and CLI install from desktop settings first.
- **File export is local-file-only.** `heptabase file export` works only when the file metadata and raw file are already available locally in the desktop app. It does not download missing files from cloud storage.
- **Binary/media upload workflows not supported.** This skill is for JSON/text operations on notes/journals/tags/cards and AI Tutor reads, not file upload or media-processing APIs.
- **Whiteboard creation/edit/delete not supported yet.** You can list whiteboards and add, list, or remove cards on them, but you can't create, rename, move, or delete whiteboards.
- **Property filtering not supported yet.** You can read tag property schemas, read property values, and set one property value on a card, but you can't query cards by property value.

## Warnings

- **Use the CLI as the only data access path.** Never directly read, write, or modify Heptabase app data through local database files, app storage, cache files, internal endpoints, or any other non-CLI mechanism. If the CLI does not support the requested operation, stop and report that it is not supported.
AGENT_LAZYPACK_HEPTABASE_CLI_SKILL_MD_0E95F5A366

# heptabase-cli/references/codex-sandbox.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/heptabase-cli/references/codex-sandbox.md")"
cat > "{{SYNC_ROOT}}/skills/heptabase-cli/references/codex-sandbox.md" <<'AGENT_LAZYPACK_HEPTABASE_CLI_REFERENCES_CODEX_SANDBOX_MD_5151D78187'
# Codex Sandbox Troubleshooting

The Heptabase CLI talks to the running desktop app through a local server. Codex
may need permission to run `heptabase` outside its workspace sandbox so the CLI
can reach that local server.

## Common Symptom

```json
{
  "error": "Heptabase started, but the CLI server is not ready yet. Ensure CLI is enabled..."
}
```

First, retry the command outside the sandbox. In Codex, request escalation for
`heptabase` commands when the tool supports it.

If it still fails, ask the user to make sure the desktop app has CLI enabled at
`Settings > AI Features`.

If you want a persistent `workspace-write` setup, ask the user to add this to
`~/.codex/config.toml`:

```toml
[sandbox_workspace_write]
network_access = true
```

Restart Codex and retry the command.
AGENT_LAZYPACK_HEPTABASE_CLI_REFERENCES_CODEX_SANDBOX_MD_5151D78187

# heptabase-cli/references/file-reading.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/heptabase-cli/references/file-reading.md")"
cat > "{{SYNC_ROOT}}/skills/heptabase-cli/references/file-reading.md" <<'AGENT_LAZYPACK_HEPTABASE_CLI_REFERENCES_FILE_READING_MD_0BE79148E0'
# File Reading

Use `heptabase file list` to resolve a PDF/media card ID into exportable file IDs. Use `heptabase file export` to copy a local raw file into a scratch directory so native file-reading tools can inspect it.

## Command Summary

```bash
heptabase file list --card-id <pdf-or-media-card-id>
heptabase file export <fileId> --output-dir <existing-directory>
```

- `file list --card-id` returns exportable files for PDF/media cards. Unsupported card types return an empty `files` array.
- `file export` copies a local raw file into `--output-dir` and returns the file path to read.
- Read only the returned `path`; never inspect Heptabase internal file paths.

## List Files

If you have a PDF or media card ID, list its files first:

```bash
heptabase file list --card-id 22222222-2222-4222-8222-222222222222
```

Example response:

```json
{
  "cardId": "22222222-2222-4222-8222-222222222222",
  "cardType": "pdf",
  "files": [
    {
      "id": "55555555-5555-4555-8555-555555555555",
      "purpose": "content",
      "name": "report.pdf",
      "mimeType": "application/pdf",
      "size": 123456,
      "lastEditedTime": "2026-05-02T00:00:00.000Z"
    }
  ]
}
```

Pick the file `id` whose `purpose` you need, then pass that `id` to `file export` as `<fileId>`.

## Export And Read

1. Create a scratch directory:

```bash
mktemp -d
```

Copy the returned directory path for the next command.

2. Export the file:

```bash
heptabase file export 55555555-5555-4555-8555-555555555555 --output-dir <scratchDirFromMktemp>
```

3. Parse the JSON response and read the returned `path` with your native file-reading tool.

Example response:

```json
{
  "fileId": "55555555-5555-4555-8555-555555555555",
  "path": "/tmp/hepta-read/report-55555555-5555-4555-8555-555555555555.pdf",
  "filename": "report-55555555-5555-4555-8555-555555555555.pdf",
  "originalName": "report.pdf",
  "mimeType": "application/pdf",
  "size": 123456,
  "lastEditedTime": "2026-05-02T00:00:00.000Z"
}
```

Now read `/tmp/hepta-read/report-55555555-5555-4555-8555-555555555555.pdf` with your native file-reading tool.

## Avoid Reading Huge Files Blindly

- Check `size`, `mimeType`, and `name` before reading.
- For textual PDF reads, prefer `references/pdf-reading.md` and `heptabase pdf read` over exporting the raw PDF.
- If the file is large, ask the user before reading the whole file or use targeted extraction, search, or page reads to avoid wasting tokens.

## Clean Up Scratch Files

- Exported files are temporary scratch copies. After you finish reading them, delete the scratch directory created by `mktemp -d`.
- Do not delete the scratch directory until all tools that need the returned `path` are done.

## Troubleshooting

- `file list --card-id` returns empty `files`: this card has no exportable local file. If the user expected a PDF/media file, ask them to verify the card.
- `file export` says the file is unavailable locally: ask the user to open/sync the file in Heptabase, then retry.
- Invalid or missing `--output-dir`: create a scratch directory with `mktemp -d` and retry.
AGENT_LAZYPACK_HEPTABASE_CLI_REFERENCES_FILE_READING_MD_0BE79148E0

# heptabase-cli/references/pdf-reading.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/heptabase-cli/references/pdf-reading.md")"
cat > "{{SYNC_ROOT}}/skills/heptabase-cli/references/pdf-reading.md" <<'AGENT_LAZYPACK_HEPTABASE_CLI_REFERENCES_PDF_READING_MD_31FFFB5E2E'
# PDF Reading

## Common Usage Pattern

1. Find PDF card IDs:

```bash
heptabase card list --card-types pdf --limit 20
heptabase card list -q "<keyword>" --card-types pdf --limit 20
```

2. Read metadata before content:

```bash
heptabase pdf metadata <pdfCardId>
```

3. Read small page ranges:

```bash
heptabase pdf read <pdfCardId> --start-page 1 --end-page 5
```

## Pagination Guidance

- Always call `pdf metadata` first.
- Page numbers are 1-indexed and inclusive.
- Empty or image-only pages are returned with `markdown: ""` so the range is continuous.
- Read 5-10 pages by default to avoid burning through tokens.
- Ask the user before requesting significantly more than 100 pages.

## When To Use `pdf read` Vs `file export`

- Use `pdf read` for textual analysis. It returns Heptabase's parsed Markdown, ready for the LLM.
- Use `file export` for visual or structural inspection. It returns the raw `.pdf` binary path for native PDF tools. This is rarely needed.

## Troubleshooting

- `parsedStatus: "processing"`: wait and retry later.
- `parsedStatus: "failed"` or `"notSupported"`: parsed Markdown is not available for this PDF.
- `parsedStatus: null`: this PDF card is not parsed yet. Ask the user to open the PDF in Heptabase and click the **Parse** button.
AGENT_LAZYPACK_HEPTABASE_CLI_REFERENCES_PDF_READING_MD_31FFFB5E2E

# heptabase-cli/references/property-values.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/heptabase-cli/references/property-values.md")"
cat > "{{SYNC_ROOT}}/skills/heptabase-cli/references/property-values.md" <<'AGENT_LAZYPACK_HEPTABASE_CLI_REFERENCES_PROPERTY_VALUES_MD_8FC6105DC1'
# Property Value Formats

Read property definitions and current values before writing:

```bash
heptabase tag properties <tagId>
heptabase card properties <cardIdOrDate>
heptabase tag cards <tagId> --include-properties
```

Use `card set-property` to replace one property value on one card:

```bash
heptabase card set-property <cardIdOrDate> --property-id <propertyId> (--value <value> | --json-value <json>)
```

Pass exactly one of `--value` or `--json-value`.

- Use `--value` when the CLI should send the argument as a literal string, such as text content or a select option name.
- Use `--json-value` when the value's JSON type matters, such as numbers, booleans, arrays, objects, relation values, and `null`.
- Use `--json-value null` to clear a property.

Read commands return property values as:

```json
{
  "id": "property-id",
  "name": "Status",
  "type": "select",
  "value": "Published"
}
```

Relation property reads return an array of populated relation objects, not a plain ID array:

```json
{
  "id": "property-id",
  "name": "Related",
  "type": "relation",
  "value": [{ "id": "related-card-id", "type": "note" }]
}
```

## Write Formats

<!-- prettier-ignore -->
| Property type | Format |
| --- | --- |
| `text` | Plain string via `--value "Draft notes"`. Stores a plain-text paragraph. |
| `number` | Number via `--json-value 42`, or a formatted numeric string via `--value "1,234"`. |
| `select` | Existing option name or raw option ID via `--value "Published"`. Option names are case-sensitive, matching the database UI. |
| `multiSelect` | JSON array of existing option names or raw option IDs via `--json-value '["Tag1","Tag2"]'`. Option names are case-sensitive, matching the database UI. Duplicate resolved options are rejected. |
| `date` | JSON object via `--json-value '{"start":"2026-05-05T00:00:00.000Z"}'`. The CLI normalizes `start` to an ISO UTC string with milliseconds and stores `end: null` because the UI does not display date ranges. |
| `checkbox` | Boolean via `--json-value true` or `--json-value false`. |
| `url` | Literal string via `--value "https://example.com"`. |
| `phone` | Literal string via `--value "+1 555 123 4567"`. |
| `email` | Literal string via `--value "person@example.com"`. |
| `relation` | JSON array of related card IDs or journal dates via `--json-value '["card-id","2026-05-05"]'`. Replaces the full relation value. Related cards must belong to the relation property's target tag database, source-type cards are rejected, and duplicate resolved cards are rejected. |

## Relation Properties

Relation writes are not self-contained. You must first discover the relation property's target tag database, then list cards in that database.

1. If you only have a card ID/date, run `heptabase card properties <cardIdOrDate>` to find the source tag containing the relation property.
2. Run `heptabase tag properties <sourceTagId>`.
3. Find the relation property. Its definition includes `relationTargetTagId`.
4. Run `heptabase tag cards <relationTargetTagId>` to list related-card candidates. Do not use source-type cards as relation values; relation writes reject them even when they belong to the target tag database.
5. Set the relation with the selected card IDs or journal dates:

```bash
heptabase card set-property <cardIdOrDate> --property-id <relationPropertyId> --json-value '["related-card-id"]'
```

Do not guess related card IDs from unrelated searches. If a card is not under `relationTargetTagId`, or it is a source-type card, the write is rejected.

## Examples

```bash
# Set select by option name
heptabase card set-property <cardIdOrDate> --property-id <propertyId> --value "Published"

# Set multi-select by option names
heptabase card set-property <cardIdOrDate> --property-id <propertyId> --json-value '["Research","Draft"]'

# Set a date
heptabase card set-property <cardIdOrDate> --property-id <propertyId> --json-value '{"start":"2026-05-05T00:00:00.000Z"}'

# Set a checkbox
heptabase card set-property <cardIdOrDate> --property-id <propertyId> --json-value true

# Replace relation values with a card and a journal
heptabase card set-property <cardIdOrDate> --property-id <propertyId> --json-value '["related-card-id","2026-05-05"]'

# Clear a property
heptabase card set-property <cardIdOrDate> --property-id <propertyId> --json-value null
```
AGENT_LAZYPACK_HEPTABASE_CLI_REFERENCES_PROPERTY_VALUES_MD_8FC6105DC1

# heptabase-cli/references/transcript-reading.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/heptabase-cli/references/transcript-reading.md")"
cat > "{{SYNC_ROOT}}/skills/heptabase-cli/references/transcript-reading.md" <<'AGENT_LAZYPACK_HEPTABASE_CLI_REFERENCES_TRANSCRIPT_READING_MD_21904738FE'
# Transcript Reading

## Common Usage Pattern

1. Find audio and video card IDs:

```bash
heptabase card list --card-types audio,video --limit 20
heptabase card list -q "<keyword>" --card-types audio,video --limit 20
```

2. Read metadata before transcript content:

```bash
heptabase audio metadata <audioCardId>
heptabase video metadata <videoCardId>
```

3. Read small time ranges:

```bash
heptabase audio read <audioCardId> --start-seconds 0 --end-seconds 300
heptabase video read <videoCardId> --start-seconds 0 --end-seconds 300
```

## Pagination Guidance

- Always call `audio metadata` or `video metadata` first.
- `audio read` and `video read` return entries that overlap the requested inclusive range, not only entries that start inside it. For example, with `--start-seconds 60 --end-seconds 120`, an entry from 55s to 65s is returned.
- Read 10-minute windows by default to avoid burning through tokens.
- Ask the user before requesting significantly more than 1 hour at once.

## When To Use Transcript Read Vs File Export

- Use `audio read` or `video read` for textual analysis. It returns Heptabase's parsed transcript entries, ready for the LLM.
- Use `file export` for raw media inspection. It returns the local audio/video file path for native tools. This is rarely needed.

## Troubleshooting

- `transcriptStatus: "processing"`: wait and retry later.
- `transcriptStatus: "failed"`: parsed transcript content is not available for this media card.
- `transcriptStatus: null`: this media card has not been transcribed yet. Ask the user to generate a transcript in Heptabase first.
AGENT_LAZYPACK_HEPTABASE_CLI_REFERENCES_TRANSCRIPT_READING_MD_21904738FE

test -f "{{SYNC_ROOT}}/skills/heptabase-cli/SKILL.md" && echo "heptabase-cli installed for Codex, Claude, and AntiGravity"
````

安裝完成後，請開新 Agent 對話或重啟對應 App，再測試 skill 是否能被讀取。

<!-- END EMBEDDED_SKILLS -->
