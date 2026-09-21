# 02-Codex-MCP-Essentials

> 2026-09-17 更新：Google Workspace MCP 改為三 Agent 共用；安裝腳本支援 `--agent all|claude|codex|antigravity`，Codex 會停用同義的 Gmail／Google Calendar／Google Drive plugins，AntiGravity 以 `serverUrl` 寫入 `mcp_config.json`；本機權限範圍新增 `docs:full sheets:full slides:full`（擴權後需重新完成 OAuth 同意，並在 Google Cloud 啟用 Docs、Sheets、Slides API）。
>
> 2026-07-30 更新：新增 Claude-first 的 Google Workspace MCP 必要項，安裝時自動取 `workspace-mcp` 最新版、本機 loopback HTTP 與共用 Python runtime；完整 installer、runner 與 macOS LaunchAgent template 放在 `02-assets/google-workspace-mcp/`。MCP 仍採「共用服務契約＋Codex／Claude／AntiGravity 原生 adapter」。
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
- Heptabase CLI 可用，且 `heptabase --version` 落在 skill frontmatter `heptabase-cli-version-range` 宣告的相容範圍內；超出範圍時先更新本 skill（取上游 `heptameta/heptabase-cli-skills` 最新版），不要硬用。
  CLI 沒有自己的更新機制：PATH 上的 `heptabase` 是 wrapper，實際執行桌面 app 內的 bundle，
  版本只會隨 app 更新而變動，Homebrew 管不到。
- Heptabase desktop app 的 local CLI server 已啟用；如果 read-only 指令回報無法連線，先執行 `heptabase start` 或在桌面 app 的 Settings > AI Features 啟用 CLI。
- 實際操作前先用 read-only 指令確認連線，不直接寫入。

安裝方式請使用本文文末「內建 Skill 完整安裝內容」；本項會同步安裝 `SKILL.md` 與 `references/`。

## Google Workspace MCP（三 Agent 共用必要項）

用途：讓 Codex、Claude、AntiGravity 透過同一個本機 MCP 使用 Drive／Gmail／Calendar，權限邊界、OAuth 授權與工具行為集中在一處。來源是 [taylorwilsdon/google_workspace_mcp](https://github.com/taylorwilsdon/google_workspace_mcp)，Python package 為 `workspace-mcp`，安裝與重跑安裝器時一律取 PyPI 最新版；每次安裝或更新後都要重跑權限與工具清單驗證。

新安裝的建議起點是最小權限；本機目前這台則是使用者明確要求後的可操作設定：

- 新環境預設只啟用 `calendar`、`drive`、`gmail`；需要 Docs、Sheets、Slides 時再明確擴權。
- 新環境建議起點：`--tool-tier core` 加三服務 `readonly`。
- 本機目前設定（2026-09-17，使用者要求擴權）：再加上 `docs:full sheets:full slides:full`，共六個服務。擴權步驟：改 runner 的 `--permissions`、重啟 LaunchAgent、在 Google Cloud 啟用 Google Docs API、Google Sheets API、Google Slides API，再依工具回傳的授權連結重新完成 OAuth 同意。
- 本機目前設定（2026-08-02，使用者要求）：`--tool-tier complete` 加 `calendar:full drive:full gmail:full`，可建立與修改 Drive 檔案、行事曆事件，並具備 Gmail 寄信 scope。
- 擴權不改變其他邊界：HTTP server 只綁定 `127.0.0.1:8000`，不對區網或網際網路開放。
- 擴權後由 Agent 行為層把關：寄信、刪除、覆蓋與其他不可逆動作，執行前一律逐次向使用者確認，不因為 scope 已開就自動執行。
- OAuth client secret 與 token 只放在 `{{CODEX_HOME}}/secrets`，不寫進 repo、LazyPack、Obsidian 或 Agent 設定。
- 三個 Agent 都連這個 MCP。Codex 若已啟用 Gmail、Google Calendar、Google Drive 官方 plugins，改為停用（`enabled = false`），避免同一個 Agent 同時出現兩套同義工具；AntiGravity 用 `mcp_config.json` 的 `serverUrl` 連同一個 endpoint。
- OAuth 授權存在本機 MCP 服務，三個 Agent 共用同一份；授權失效時任一 Agent 呼叫工具都會拿到授權連結，由本人在瀏覽器完成同意後三邊一起恢復。

### 0. 安裝前的三個決定（一次一題）

先問使用者，已回答過就不重問。括號內是維護者本機的實際選擇，照選就會得到相同效果。

1. **哪些 Agent 要接這個 MCP？**
   - 三個都接（本機選擇）：安裝腳本加 `--agent all`，Codex、Claude、AntiGravity 用同一個 endpoint 與同一份 OAuth 授權。
   - 只接其中一個：`--agent claude`、`--agent codex` 或 `--agent antigravity`；沒接的 Agent 就不會有 Google 工具，並要把 Item 16 `agent-mcp-parity.json` 的 `required_everywhere` 移除 `google-workspace`。
2. **要開哪些 Google 服務、到什麼權限？**
   - 六個服務完整權限（本機選擇）：`calendar:full drive:full gmail:full docs:full sheets:full slides:full`，可以讀寫文件、試算表、簡報、行事曆並寄信；寄信、刪除、覆寫仍逐次確認。
   - 三個服務唯讀（最小權限）：`calendar:readonly drive:readonly gmail:readonly`，只能查，不能改。
   - 自訂：依需要組合；每個服務都要在 Google Cloud 啟用對應 API。
3. **Codex 已啟用 Gmail／Google Calendar／Google Drive 官方 plugins 時怎麼辦？**
   - 停用 plugins，只走 MCP（本機選擇）：同一個 Agent 不會出現兩套同義工具，權限邊界集中在一處；安裝腳本會先備份 `config.toml` 再改成 `enabled = false`。
   - 保留 plugins、不幫 Codex 接 MCP：改用 `--agent claude` 或 `--agent antigravity`。

依答案修改 `02-assets/google-workspace-mcp/run_google_workspace_mcp.sh` 的 `--permissions`，再執行：

```bash
bash 02-assets/google-workspace-mcp/install_google_workspace_mcp.sh --agent=all
```

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

Codex adapter：

```bash
codex mcp add google-workspace --url http://127.0.0.1:8000/mcp
codex mcp list
```

接著在 `{{CODEX_CONFIG}}` 把已啟用的 `[plugins."gmail@openai-curated"]`、`[plugins."google-calendar@openai-curated"]`、`[plugins."google-drive@openai-curated"]` 改成 `enabled = false`（改前先備份），重開 Codex。

AntiGravity adapter：在 `{{GEMINI_CONFIG}}/mcp_config.json` 的 `mcpServers` 加入下列項目，再重載 AntiGravity。遠端 MCP 的欄位是 `serverUrl`（AntiGravity 內建文件的寫法），不是 Claude 的 `url`／`type`：

```json
"google-workspace": { "serverUrl": "http://127.0.0.1:8000/mcp" }
```

`gemini mcp add` 寫的是 Gemini CLI 自己的設定，不是 AntiGravity IDE 讀的 `mcp_config.json`；只有也使用 Gemini CLI 時才另外執行：

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

Codex 驗證（`codex exec` 每次都重新載入工具清單，適合確認 Codex adapter 真的叫得到）：

```bash
cd /tmp && codex exec --skip-git-repo-check -s read-only \
  "只用 google-workspace MCP 列出我的 Google 日曆數量，不做任何寫入。最後一行輸出 CODEX_GOOGLE_VERIFY calendar=<ok|fail>"
```

AntiGravity 驗證：改完 `mcp_config.json` 後重新載入 AntiGravity，請它列出 Google 日曆；工具清單裡看得到 `google-workspace` 才算接上。

#### 擴權步驟與踩坑

擴權（例如加入 Docs、Sheets、Slides）照這個順序：

1. 改 runner 的 `--permissions`，並讓 `02-assets/google-workspace-mcp/run_google_workspace_mcp.sh` 與本機 `{{CODEX_HOME}}/python-tools/bin/google-workspace-mcp-server` 保持一致。
2. 重啟服務：`launchctl kickstart -k "gui/$(id -u)/com.lazy-pack.google-workspace-mcp"`。
3. 在 Google Cloud 啟用對應 API（Google Docs API、Google Sheets API、Google Slides API）。
4. 呼叫一個新服務的工具，依回傳的授權連結由本人在瀏覽器重新同意。
5. 再跑一次 `install_google_workspace_mcp.sh --check`，它會依 `--permissions` 逐一確認每個服務的工具都在。

常見誤判：

- **重啟後約 1 分鐘才開始監聽**：這段時間 `curl` 回 `000`，不是壞掉；等 `lsof -nP -iTCP:8000 -sTCP:LISTEN` 有結果再驗證。
- **不要用清單類工具判斷擴權成功**：`list_spreadsheets`、`search_docs` 走的是 Drive API，舊權限也會成功。要叫真的用到該服務 API 的工具：Sheets 用 `read_sheet_values`、Docs 用 `inspect_doc_structure`、Slides 用 `get_presentation`。
- **已連線的對話第一次呼叫回 `session expired`**：服務重啟造成，重試一次即可；新工具會自動出現在現有對話。
- **AntiGravity 欄位名稱是 `serverUrl`**，不是 Claude 的 `type`／`url`；`gemini mcp add` 寫的是 Gemini CLI 設定，不會進 AntiGravity 的 `mcp_config.json`。

### 5. 更新、停用與撤銷

更新到最新版就是重跑安裝器（會自動取最新版），完成後重跑上方的權限與工具清單驗證：

```bash
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
7. Google Workspace MCP：確認 endpoint handshake、工具清單與目前 `--permissions` 設定的服務相符，並各做一個低敏感 read-only 查詢；Codex 的 Google plugins 保持停用，不與 MCP 並存 adapter。

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
# heptabase-cli/LICENSE
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/heptabase-cli/LICENSE")"
cat > "{{SYNC_ROOT}}/skills/heptabase-cli/LICENSE" <<'AGENT_LAZYPACK_HEPTABASE_CLI_LICENSE_C693279643'
MIT License

Copyright (c) 2026 Heptabase

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
AGENT_LAZYPACK_HEPTABASE_CLI_LICENSE_C693279643

# heptabase-cli/SKILL.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/heptabase-cli/SKILL.md")"
cat > "{{SYNC_ROOT}}/skills/heptabase-cli/SKILL.md" <<'AGENT_LAZYPACK_HEPTABASE_CLI_SKILL_MD_0E95F5A366'
---
name: heptabase-cli
description: "要讀寫 Heptabase 白板、卡片、日記、AI Tutor，或開啟 Heptabase 連結時使用；需桌面版執行中。"
allowed-tools: Bash(heptabase *) Bash(jq *) Bash(mktemp *)
metadata:
  heptabase-cli-version-range: "0.6.x"
  last-updated: "2026-09-22"
---

## Prerequisites

- CLI installed from the desktop app. The command is `heptabase` on macOS/Linux; Windows installs `heptabase.cmd` for cmd/PowerShell and a `heptabase` shim for POSIX shells.
- Check version compatibility before use with `heptabase --version`. If the installed CLI version is outside this skill's compatibility range (`0.6.x`), you MUST stop and ask the user to update either the Heptabase desktop app or this skill package before continuing.
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
- **Create a note from markdown:** `heptabase note create --content "# Title\n\nBody"` (marks Created by AI by default; add `--no-created-by-ai` for human-owned content).
- **Create today's journal from markdown:** `heptabase journal create --content "Body"` (marks Created by AI by default; add `--no-created-by-ai` for human-owned content).
- **Append markdown to a note:** `heptabase note append <cardId> --content "More content"`.
- **Edit note content with JSON save:** first read `references/card-content-schema.md`, then use `heptabase note read <cardId>`, modify the returned ProseMirror JSON, and save with `heptabase note save <cardId> --content-md5 <contentMd5> --content-file <path>`.
- **Work with properties:** use `heptabase tag cards <tagId> --include-properties` to list tagged cards with values, or `heptabase card properties <cardIdOrDate>` to inspect one card. Before writing, read `references/property-values.md`, inspect definitions with `heptabase tag properties <tagId>`, then use `heptabase card set-property <cardIdOrDate> --property-id <propertyId> --value "Published"` for strings/options or `--json-value ...` for typed JSON values.
- **Read parsed PDF content:** first read `references/pdf-reading.md`, then use `heptabase pdf metadata <pdfCardId>` to discover `totalPages`, and read a page range with `heptabase pdf read <pdfCardId> --start-page N --end-page N`.
- **Read transcript content:** first read `references/transcript-reading.md`, then use `heptabase audio metadata <audioCardId>` or `heptabase video metadata <videoCardId>` to discover `transcriptStatus` and `durationSeconds`, and read overlapping transcript entries in a time range with `heptabase audio read <audioCardId> --start-seconds 0 --end-seconds 300` or `heptabase video read <videoCardId> --start-seconds 0 --end-seconds 300`.
- **Read an attached file:** first read `references/file-reading.md`. If needed, find its ID with `heptabase file list --card-id <cardId>`, then run `mktemp -d` and `heptabase file export <fileId> --output-dir <scratchDir>`. Read the returned `path` with your native file-reading tool.
- **Inspect a whiteboard:** `heptabase whiteboard read <whiteboardId> --mode structure`, then `heptabase whiteboard read-layout <whiteboardId>`.
- **Read chat messages:** Copy a chat ID from `whiteboard read` output, then use `heptabase object read chat <chatId> --offset <n> --limit <n>` to paginate non-removed messages with their displayed author, timestamp, quoted content, and message content. For a whiteboard chat-messages element, use `heptabase object read chatMessagesElement <elementId> --offset <n> --limit <n>`.
- **Check or view whiteboard layout:** run `heptabase whiteboard lint <whiteboardId>`. For visual review, first read `references/whiteboard.md`, then use `heptabase whiteboard screenshot <whiteboardId> --output <existingDirectory>/whiteboard.png` and inspect the returned local path.
- **Change whiteboard layout or a mind map:** first read `references/whiteboard.md`; for mind maps, also read `references/mind-maps.md`. Commands with nested or batch input use `--input <path|->` and canonical JSON.
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

## Heptabase URLs (Deep links)

When the user shares a Heptabase URL (aka. deep link), use the CLI to read it — do NOT open it in a browser if the user does not explicitly ask you to (the app requires authentication and browsers used by agents are typically not logged in).

URL patterns and how to handle them:

- **Journal card:** `https://app.heptabase.com/<workspaceId>/card/<YYYY-MM-DD>` → `heptabase journal read <YYYY-MM-DD>`
- **Card by UUID:** `https://app.heptabase.com/<workspaceId>/card/<uuid>` → first run `heptabase card properties <uuid>` to discover the card type, then read its content with the matching command (`heptabase note read <uuid>`, `heptabase pdf metadata <uuid>`, etc.).
- **Whiteboard:** `https://app.heptabase.com/<workspaceId>/whiteboard/<uuid>` → run `heptabase whiteboard read <uuid> --mode structure` and `heptabase whiteboard read-layout <uuid>`. Read `references/whiteboard.md` before any layout mutation or visual judgment.

The `<workspaceId>` segment in the URL is not needed by the CLI — extract only the card/whiteboard ID.

## Note and journal card content editing

Use `create` / `append` with Markdown for ordinary writing. Before calling `heptabase note save` / `heptabase journal save` with ProseMirror JSON, you MUST read `references/card-content-schema.md`. Also read it before generating Markdown that uses Heptabase-specific extensions such as card mentions, whiteboard mentions, dates, videos, math, or toggle/todo lists.

## Created by AI marking

`note create` and `journal create` mark content as Created by AI by default. Before deciding whether to pass `--no-created-by-ai`, you MUST read `references/created-by-ai.md`.

## Property editing

Before setting a property value, you MUST read `references/property-values.md` and inspect the target property with `heptabase card properties <cardIdOrDate>` and/or `heptabase tag properties <tagId>`. Property formats vary by type, and relation writes replace the full relation value. For relation properties, use `heptabase tag properties <sourceTagId>` to get the property definition's `relationTargetTagId`, then list valid related cards before writing.

## File reading

Before reading/listing files or exporting a file, you MUST read `references/file-reading.md`.

## PDF reading

Before reading parsed PDF content, you MUST read `references/pdf-reading.md`.

## Transcript reading

Before reading parsed media transcripts, you MUST read `references/transcript-reading.md`.

## Whiteboard work

Before deliberate placement, movement, arrangement, resizing, sectioning, connection work, removal, or visual verification, you MUST read `references/whiteboard.md`. It defines exact placement references, selection and destination shapes, read-before-write rules, and the verification loop.

For mind-map creation or structural edits, also read `references/mind-maps.md`. Read the current mind map again before updating it so stable structural node IDs are current.

The existing `whiteboard cards`, `add-card`, and `remove-card` commands are narrow legacy commands. Prefer `whiteboard read`, `read-layout`, and the canonical `--input` commands for structured whiteboard work.

The canonical mutation commands cover whiteboard hierarchy and shortcuts; object placement and cross-whiteboard moves; move, arrange, align, resize, color, and removal; Sections and connections; and mind-map creation and updates. Run `heptabase whiteboard --help` for the current list and read the linked references for nested input.

## Canonical JSON input

Commands with nested or batch data accept `--input <path|->`; `-` reads JSON from stdin. Build JSON with `jq` or write it to a temporary file. Do not interpolate untrusted text into hand-built shell JSON.

Inspect every mutation result. A handled top-level `status: "failed"` is printed and exits with status `1`. A successful top-level result exits with `0` even when item results contain `failureReasonCode` fields, so check them before reporting full success.

## All output is JSON

Every command prints JSON to stdout. You can parse it with `jq` or pipe it to other tools. `whiteboard screenshot` writes the PNG to `--output` and prints metadata only; it never prints image bytes.

## Troubleshooting

- **Desktop app must be running.** The CLI communicates with a local server inside the app. If the app is closed, all commands fail. Run `heptabase start` to launch and wait for readiness.
- **Codex sandbox may block the local CLI server.** If Heptabase starts but Codex says the CLI server is not ready, read `references/codex-sandbox.md`; retry `heptabase` commands outside the sandbox when Codex supports escalation.
- **Mutations are serialized.** Write operations run one at a time to prevent conflicts. Reads are concurrent.
- **Request body size limit.** The server rejects request bodies larger than 1 MB.
- **Request timeout.** The server times out requests that take longer than 10 seconds to send their body.

## Known limitations

- **Auto-enabling local server/CLI install not supported.** If the local CLI server is disabled or CLI wiring is missing, the skill cannot repair it by itself; ask the user to enable Local CLI Server and CLI install from desktop settings first.
- **File export is local-file-only.** `heptabase file export` works only when the file metadata and raw file are already available locally in the desktop app. It does not download missing files from cloud storage.
- **Binary/media upload workflows not supported.** This skill can export locally available files and whiteboard PNGs, but it cannot upload files or call media-processing APIs.
- **Whiteboard scope is intentionally bounded.** The CLI cannot delete a whiteboard or underlying Card, move content across spaces, create arbitrary shapes, or perform one semantic whole-board auto-layout command. `remove-objects` removes canvas placements, not source Cards.
- **No CLI undo command or Agent history.** Whiteboard mutations use the app's normal domain actions, but the CLI does not expose Agent chat undo, tool-call persistence, or the Agent screenshot checklist. Read first and verify the result yourself.
- **Whiteboard content is local.** Whiteboard reads use content available in the running desktop app and do not run backend-only PDF, web, or YouTube enrichment. Use dedicated PDF and media commands for full source content. Full web card content is not available through the CLI; use the source URL in the whiteboard output.
- **Screenshots are schematic.** They support spatial review but do not replace semantic reads or deterministic lint.
- **Property filtering not supported yet.** You can read tag property schemas, read property values, and set one property value on a card, but you can't query cards by property value.

## Warnings

- **Use the CLI as the only data access path.** Never directly read, write, or modify Heptabase app data through local database files, app storage, cache files, internal endpoints, or any other non-CLI mechanism. If the CLI does not support the requested operation, stop and report that it is not supported.
AGENT_LAZYPACK_HEPTABASE_CLI_SKILL_MD_0E95F5A366

# heptabase-cli/references/card-content-schema.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/heptabase-cli/references/card-content-schema.md")"
cat > "{{SYNC_ROOT}}/skills/heptabase-cli/references/card-content-schema.md" <<'AGENT_LAZYPACK_HEPTABASE_CLI_REFERENCES_CARD_CONTENT_SCHEMA_MD_1B1BEA64CB'
# Card Content Schema

This reference covers note and journal content writes through the Heptabase CLI.

Read this before generating ProseMirror JSON: the card content schema is strict, and guessed structures can fail validation or damage card content.

Prefer Markdown for ordinary writing and appending. Use ProseMirror JSON only when you need to preserve existing structure or create schema nodes/marks that Markdown cannot express.

## Top-Level JSON Shape

A ProseMirror document is a JSON object:

```json
{
  "type": "doc",
  "content": [
    {
      "type": "paragraph",
      "attrs": { "id": null },
      "content": [{ "type": "text", "text": "Hello" }]
    }
  ]
}
```

The `text` node is special: put the characters in a `text` property (not in `attrs`), and put optional formatting in a `marks` array on the same object. See [Marks](#marks) and [Paragraph With Marks And Link](#paragraph-with-marks-and-link).

The document must contain at least one block. `{"type":"doc","content":[]}` is invalid.

When editing existing content, preserve existing `id` values from `read`. For new blocks, omit `id` or set it to `null`; the CLI save handler backfills valid IDs. Do not create custom string IDs yourself.

## Markdown Content

For everyday note content, you can use Markdown instead of JSON. The table below maps Markdown syntax to the ProseMirror nodes and marks the CLI creates:

<!-- prettier-ignore -->
| Markdown | ProseMirror result |
| --- | --- |
| `# H1` through `###### H6` | `heading` |
| Plain text paragraphs | `paragraph` |
| `>` quote | `blockquote` |
| `- item` | `bullet_list_item` |
| `1. item` | `numbered_list_item` |
| `- [ ] item`, `- [x] item` | `todo_list_item` |
| `+ item` | `toggle_list_item` |
| Triple backtick fences | `code_block` |
| `---` | `horizontal_rule` |
| Markdown tables | `table` |
| `![](src)`, `![](src "title")` | `image` block (`alt` is ignored so no need to set it) |
| `{{video URL}}`, `{{youtube URL}}`, `{{vimeo URL}}`, `{{bilibili URL}}` | `video` block |
| `{{card UUID}}` | inline `card` mention |
| `{{pdf_card UUID}}` | inline `pdf_card` mention |
| `{{whiteboard UUID}}` | inline `whiteboard` mention |
| `{{date YYYY-MM-DD}}` | inline `date` mention |
| `$x$`, `$$x$$` | `math_inline`, `math_display` |
| `**bold**`, `*italic*`, `~~strike~~`, `` `code` ``, `[link](url)` | marks |

Below is an example with inline mentions, an image block, a standalone video line (note the blank lines), and a todo item:

```markdown
# Sprint notes

Discussed in {{card 11111111-1111-4111-8111-111111111111}} on {{date 2026-06-04}}.

This is an image:

![](https://example.com/diagram.png)

This is a video:

{{youtube https://www.youtube.com/watch?v=example}}

- [ ] Summarize the recording
```

Video markdown rules:

- The whole line must be only `{{video URL}}`, `{{youtube URL}}`, `{{vimeo URL}}`, or `{{bilibili URL}}` — no text before or after on the same line.
- Put a blank line before and after the video line when other blocks are nearby.
- Invalid: `Watch this: {{youtube https://...}}` (trailing text prevents a `video` block).

## ProseMirror Nodes

### Blocks

<!-- prettier-ignore -->
| Node | Content | Attrs |
| --- | --- | --- |
| `doc` | `block+` | none |
| `paragraph` | `inline*` | `id?: UUID string or null` |
| `heading` | `inline*` | `id?: UUID string or null`, `level?: 1-6` (default `1`) |
| `blockquote` | `block+` | `id?: UUID string or null` |
| `horizontal_rule` | none | `id?: UUID string or null` |
| `code_block` | `text*` | `id?: UUID string or null`, `params?: string or null` (see [Code Block Params](#code-block-params); default `""`) |
| `math_display` | `text*` | `id?: UUID string or null` |
| `bullet_list_item` | `paragraph block*` | `id?: UUID string or null`, `folded?: boolean`, `format?: 0, 1, 2, "0", "1", "2", or null` |
| `numbered_list_item` | `paragraph block*` | `id?: UUID string or null`, `order?: positive integer or null`, `format?: 0, 1, 2, "0", "1", "2", or null` |
| `todo_list_item` | `paragraph block*` | `id?: UUID string or null`, `checked?: boolean`, `dueDate?: YYYY-MM-DD string or null`, `lastCheckedTime?: ISO 8601 string or null`, `lastUpdatedTime?: ISO 8601 string` (see [Timestamp Attrs](#timestamp-attrs)) |
| `toggle_list_item` | `heading` or `paragraph`, then `block*` | `id?: UUID string or null`, `folded?: boolean` |
| `table` | `table_row+` | `id?: UUID string or null`, `hasRowHeader?: boolean`, `hasColumnHeader?: boolean` |
| `table_row` | zero or more `table_cell` or `table_header` nodes | `id?: UUID string or null` |
| `table_cell`, `table_header` | `block+` | `id?: UUID string or null`, `colspan?: positive integer`, `rowspan?: positive integer`, `colwidth?: positive integer[] or null`, `backgroundColor?: editor color or null`, `textColor?: editor color or null` (see [Editor Colors](#editor-colors)) |
| `image` | none | `id?: UUID string or null`, `src?: string or null`, `fileId?: UUID string or null`, `width?: string or null`, `originalHeight?: number or null`, `originalWidth?: number or null`, `alignment?: left, center, or right`, `reference?: media reference or null` (preserve from `read`; do not create manually); **legacy markdown:** `alt`, `title` |
| `video` | none | `id?: UUID string or null`, `fileId?: UUID string or null`, `url?: string or null`, `width?: string or null`, `alignment?: left, center, or right`, `originalWidth?: number or null`, `originalHeight?: number or null`, `reference?: media reference or null` (preserve from `read`; do not create manually); **deprecated:** `source` (legacy iframe embeds; omit on new content) |
| `audio` | none | `id?: UUID string or null`, `url?: string or null`, `fileId?: UUID string or null`, `reference?: media reference or null` (preserve from `read`; do not create manually) |
| `file` | none | `id?: UUID string or null`, `fileId?: UUID string or null`, `url?: string or null`, `reference?: media reference or null` (preserve from `read`; do not create manually) |
| `bookmark` | none | `url: full URL string`, `id?: UUID string or null`, `title?: string or null`, `description?: string or null`, `thumbnailUrl?: string or null`, `faviconUrl?: string or null`, `siteName?: string or null`, `lastUpdatedTime?: ISO 8601 string or null` (see [Timestamp Attrs](#timestamp-attrs)) |
| `embed` | none | supported `objectType`: `note`, `journal`, `highlightElement`, `image`, `video`, or `audio`; `objectId: UUID string` (or `YYYY-MM-DD` when `objectType` is `journal`), `id?: UUID string or null`; `originalWidth`, `originalHeight`, `width`, and `alignment` |
| `mention` | none | supported `objectType`: `note`, `journal`, `highlightElement`, `image`, `video`, or `audio`; `objectId: UUID string` (or `YYYY-MM-DD` when `objectType` is `journal`), `id?: UUID string or null` |

Block media nodes cannot appear inside a paragraph. Use inline mention nodes for inline references.

#### Code Block Params

Code block `params` are serialized as `[!]<language>[:displayMode]`, where `!` enables line wrapping and `displayMode` applies to Mermaid blocks (`code`, `preview`, or `split`). See [Code Block](#code-block).

#### Timestamp Attrs

Use ISO 8601 strings for timestamp attrs, for example `2026-05-26T00:00:00.000Z`.

#### Media References

Media `reference` attrs are internal metadata. Preserve them when editing existing JSON from `read`, but do not create them manually. If present, the value must be either `null` or an object with `objectType` and `objectId`. Supported `objectType` values are `card`, `textElement`, `journal`, `highlightElement`, `mediaElement`, `mediaCard`, `pdfCard`, `insight`, `chatMessage`, `chat2AccountRelation`, and `webCard`. `objectId` must be a UUID string, except `journal` references use a `YYYY-MM-DD` date string.

#### Editor Colors

Editor colors for `table_cell` / `table_header` `backgroundColor` and `textColor` are `gray`, `brown`, `orange`, `yellow`, `green`, `blue`, `purple`, `pink`, and `red`.

### Inline Nodes

<!-- prettier-ignore -->
| Node | Attrs |
| --- | --- |
| `text` | none |
| `math_inline` | none |
| `hard_break` | none |
| `web` | `url: full URL string`, `title?: string or null` |
| `date` | `date: string` (`YYYY-MM-DD`) |
| `whiteboard` | `whiteboardId: UUID string` |
| `card` | `cardId: UUID string` |
| `pdf_card` | `pdfCardId: UUID string` |
| `section` | `sectionId: UUID string` |
| `tag` | `tagId: UUID string` |
| `highlight_element` | `highlightElementId: UUID string` |
| `image_card`, `video_card`, `audio_card` | `cardId: UUID string` |
| `web_card` | `webCardId: UUID string` |
| `chat` | `chatId: UUID string`, `chatMessageId?: UUID string or null`, `quotedChatMessageId?: UUID string or null` |

- **`text`** — Put characters in `text` (required) and optional formatting in `marks`. See [Top-Level JSON Shape](#top-level-json-shape) and [Marks](#marks).
- **`math_inline`** — Put the TeX inside `content` as a child `text` node. See [Math](#math).
- **`people`** — Do not use `people`. It exists in a special editor schema, but the CLI save schema rejects it.

### Marks

Marks only attach to `text` nodes. Each mark is an entry in that node's `marks` array: `{ "type": "<mark>", "attrs": ... }` (many marks have no `attrs`).

When you save as Markdown, you can get bold, italic, and stuff from the syntax in [Markdown Content](#markdown-content). But you cannot get underline or text/background color that way because there is no Markdown syntax for them — save as JSON (ProseMirror) if you need those marks.

<!-- prettier-ignore -->
| Mark | Attrs | Notes |
| --- | --- | --- |
| `em` | none | italic |
| `strong` | none | bold |
| `strike` | none | strikethrough |
| `underline` | none | underline |
| `code` | none | inline code |
| `link` | `href: non-empty string` | `href` is required; **deprecated (legacy markdown):** `title`, `data-internal-href`, `edited` — preserve from `read` if present, do not set on new links |
| `color` | `type: text or background`, `color: gray, brown, orange, yellow, green, blue, purple, pink, or red` | both attrs are required when the mark is present |
| `highlight` | `ids: UUID string[]` | read-only highlight/comment metadata; do not create manually |
| `anchor` | `ids: UUID string[]` | read-only anchor metadata; do not create manually |

### Deprecated attributes

Some attrs remain in the schema as legacy. When **creating** new JSON, omit them unless you are round-tripping an existing document from `read`:

<!-- prettier-ignore -->
| Node or mark | Deprecated attrs | Notes |
| --- | --- | --- |
| `image` | `alt`, `title` | Markdown import ignores them; use `fileId` / `src` and `alignment` instead |
| `video` | `source` | Legacy iframe `data-source`; use `fileId` or `url` |
| `link` | `title`, `data-internal-href`, `edited` | Use `href` only for new external links; internal links are resolved by the app |

## Examples

### Minimal Note

```json
{
  "type": "doc",
  "content": [{ "type": "heading", "attrs": { "level": 1, "id": null } }]
}
```

### Paragraph With Marks And Link

```json
{
  "type": "doc",
  "content": [
    {
      "type": "paragraph",
      "attrs": { "id": null },
      "content": [
        { "type": "text", "text": "This is " },
        { "type": "text", "marks": [{ "type": "strong" }], "text": "bold" },
        { "type": "text", "text": " and " },
        { "type": "text", "marks": [{ "type": "em" }], "text": "italic" },
        { "type": "text", "text": ", with " },
        {
          "type": "text",
          "marks": [
            {
              "type": "link",
              "attrs": { "href": "https://heptabase.com" }
            }
          ],
          "text": "a link"
        },
        { "type": "text", "text": "." }
      ]
    }
  ]
}
```

### Todo Item

```json
{
  "type": "doc",
  "content": [
    {
      "type": "todo_list_item",
      "attrs": {
        "id": null,
        "checked": false,
        "lastUpdatedTime": "2026-05-26T00:00:00.000Z"
      },
      "content": [
        {
          "type": "paragraph",
          "attrs": { "id": null },
          "content": [{ "type": "text", "text": "Review schema rules" }]
        }
      ]
    }
  ]
}
```

### Code Block

```json
{
  "type": "doc",
  "content": [
    {
      "type": "code_block",
      "attrs": { "id": null, "params": "typescript" },
      "content": [{ "type": "text", "text": "const answer = 42;" }]
    },
    {
      "type": "code_block",
      "attrs": { "id": null, "params": "!mermaid:preview" },
      "content": [{ "type": "text", "text": "flowchart TD\n  A[Draft] --> B[Review]" }]
    }
  ]
}
```

Use `!` to enable line wrapping, for example `!typescript`. For Mermaid code blocks, append `:code`, `:preview`, or `:split` to choose the display mode.

### Inline Card Mention

```json
{
  "type": "doc",
  "content": [
    {
      "type": "paragraph",
      "attrs": { "id": null },
      "content": [
        { "type": "text", "text": "See also: " },
        {
          "type": "card",
          "attrs": { "cardId": "11111111-1111-4111-8111-111111111111" }
        }
      ]
    }
  ]
}
```

### Mirror Embed

```json
{
  "type": "doc",
  "content": [
    {
      "type": "embed",
      "attrs": {
        "id": null,
        "objectType": "note",
        "objectId": "11111111-1111-4111-8111-111111111111",
        "width": "100%",
        "alignment": "center"
      }
    }
  ]
}
```

### Math

`math_display` is a block; `math_inline` is an inline sibling next to `text` inside a paragraph. Neither uses `attrs` or a top-level `text` property for the formula. Put the TeX string in `content` as a single child `text` node. Multiple child `text` nodes are schema-valid, but prefer one child `text` node when creating new math content.

```json
{
  "type": "doc",
  "content": [
    {
      "type": "math_display",
      "attrs": { "id": null },
      "content": [{ "type": "text", "text": "\\int_0^1 x^2 \\,dx = \\frac{1}{3}" }]
    },
    {
      "type": "paragraph",
      "attrs": { "id": null },
      "content": [
        { "type": "text", "text": "Inline: " },
        {
          "type": "math_inline",
          "content": [{ "type": "text", "text": "a^2 + b^2 = c^2" }]
        },
        { "type": "text", "text": " in a sentence." }
      ]
    }
  ]
}
```

### Table

```json
{
  "type": "doc",
  "content": [
    {
      "type": "table",
      "attrs": { "id": null, "hasRowHeader": false, "hasColumnHeader": true },
      "content": [
        {
          "type": "table_row",
          "attrs": { "id": null },
          "content": [
            {
              "type": "table_header",
              "attrs": { "colspan": 1, "rowspan": 1 },
              "content": [
                {
                  "type": "paragraph",
                  "attrs": { "id": null },
                  "content": [{ "type": "text", "text": "Name" }]
                }
              ]
            },
            {
              "type": "table_header",
              "attrs": { "colspan": 1, "rowspan": 1 },
              "content": [
                {
                  "type": "paragraph",
                  "attrs": { "id": null },
                  "content": [{ "type": "text", "text": "Status" }]
                }
              ]
            }
          ]
        },
        {
          "type": "table_row",
          "attrs": { "id": null },
          "content": [
            {
              "type": "table_cell",
              "attrs": { "colspan": 1, "rowspan": 1 },
              "content": [
                {
                  "type": "paragraph",
                  "attrs": { "id": null },
                  "content": [{ "type": "text", "text": "Schema docs" }]
                }
              ]
            },
            {
              "type": "table_cell",
              "attrs": { "colspan": 1, "rowspan": 1 },
              "content": [
                {
                  "type": "paragraph",
                  "attrs": { "id": null },
                  "content": [{ "type": "text", "text": "Draft" }]
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}
```

## Dos

- Do read first and edit the returned `content` when replacing a card or journal.
- Do pass the latest `contentMd5` to `save`.
- Do preserve existing `id` values from `read`.
- Do use `id: null` or omit `id` on new blocks; the save handler backfills valid IDs.
- Do resolve real target IDs with CLI reads/lists before creating inline mentions or embeds.

## Don'ts

- Don't write an empty document.
- Don't put text in `attrs.text`.
- Don't create custom string IDs for new blocks.
- Don't invent UUIDs for `cardId`, `whiteboardId`, `pdfCardId`, `tagId`, or other references.
- Don't use `people` inline mentions through the CLI schema.
- Don't add `highlight` or `anchor` marks when creating new content.
- Don't set deprecated attrs on new content; preserve them only when editing existing JSON from `read`.
- Don't assume `embed` and block `mention` can target every card type; use only `note`, `journal`, `highlightElement`, `image`, `video`, or `audio`.
- Don't edit Heptabase local database files directly to bypass the CLI.
AGENT_LAZYPACK_HEPTABASE_CLI_REFERENCES_CARD_CONTENT_SCHEMA_MD_1B1BEA64CB

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

# heptabase-cli/references/created-by-ai.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/heptabase-cli/references/created-by-ai.md")"
cat > "{{SYNC_ROOT}}/skills/heptabase-cli/references/created-by-ai.md" <<'AGENT_LAZYPACK_HEPTABASE_CLI_REFERENCES_CREATED_BY_AI_MD_A981F7F3D9'
# Created by AI Marking

`note create` and `journal create` mark new content as **Created by AI** by default.

For notes, Card Library’s Created by AI filter keeps them separate from human-owned cards.
For journals, the same create-time mark is stored as `aiArtifactInfo`; later `append` / `save` cannot change it. Journals are not shown in the Card Library Created by AI filter.

## Default (mark)

Use the default when you are drafting, researching, summarizing, or otherwise generating content as an agent. Leave the mark on so the user can filter AI-created notes in Card Library.

```bash
heptabase note create --content "# Draft\n\n..."
heptabase journal create --content "..."
```

## Opt out (`--no-created-by-ai`)

Pass `--no-created-by-ai` when the user wants the note or journal as **theirs** — for example:

- They ask you to capture or write something they will own and edit as a normal note or journal
- They are dictating or you are acting only as a scribe
- They explicitly say not to mark it as Created by AI

```bash
heptabase note create --no-created-by-ai --content "# My note\n\n..."
heptabase journal create --no-created-by-ai --content "..."
```

## Timing

- The mark is set **only at create time**. Later `append` / `save` do not add or remove it.
- Prefer deciding before the first `create`. Do not create unmarked then recreate just to change the mark.
- For journals, the mark is written only when the journal date did not already have a journal row (filling an existing empty journal does not add the mark).
AGENT_LAZYPACK_HEPTABASE_CLI_REFERENCES_CREATED_BY_AI_MD_A981F7F3D9

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

# heptabase-cli/references/mind-maps.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/heptabase-cli/references/mind-maps.md")"
cat > "{{SYNC_ROOT}}/skills/heptabase-cli/references/mind-maps.md" <<'AGENT_LAZYPACK_HEPTABASE_CLI_REFERENCES_MIND_MAPS_MD_A1B781DF4B'
# Mind maps

Read this together with `whiteboard.md`. A mind map is an editable rooted tree with stable structural node IDs.

## Design defaults

- Design the semantic tree before choosing rich node types.
- Use one concise text root.
- Use mostly short `textNode` labels, with one concept per node and parallel wording among siblings.
- Default to 4–7 top-level branches, 2–4 levels, and about 20–50 nodes. The 300-node limit is a ceiling, not a target.
- Default to horizontal layout. Omit side, edge color, and collapsed state unless the user or existing map calls for them.
- For updates, preserve the map's current wording, depth, node mix, layout, colors, sides, and collapsed state. Make the smallest requested change.

## Node types

| Type | Use |
| --- | --- |
| `textNode` | Default concise label owned by the mind map. Plain text only. |
| `cardNode` | A regular Card whose independent identity matters. It may create a Card, reference one, or consume a Card placement. Only regular Cards are supported; PDF, web, media, and journal sources are not. |
| `highlightElementNode` | Consume an existing standalone Highlight Element placement. The command cannot create a new Highlight Element. |
| `textElementNode` | Create a visual Text Element or consume an existing standalone Text Element placement. |

Build the full text-node skeleton first. Use rich nodes only where added detail or independent identity matters.

## Create a mind map

Create one complete flat, ordered tree with `create-mind-map --input <path|->`:

```bash
heptabase whiteboard create-mind-map --input input.json
```

```json
{
  "whiteboardId": "<whiteboardId>",
  "layout": "horizontal",
  "destination": { "type": "auto" },
  "nodes": [
    {
      "nodeKey": "root",
      "parentNodeKey": null,
      "node": { "type": "textNode", "content": "Customer onboarding" }
    },
    {
      "nodeKey": "activation",
      "parentNodeKey": "root",
      "node": { "type": "textNode", "content": "Activation" }
    },
    {
      "nodeKey": "first-value",
      "parentNodeKey": "activation",
      "node": { "type": "textNode", "content": "First value" }
    },
    {
      "nodeKey": "risks",
      "parentNodeKey": "root",
      "node": { "type": "textNode", "content": "Risks" }
    }
  ]
}
```

Rules:

- `nodeKey` is unique within the call.
- Exactly one node has `parentNodeKey: null`.
- Every other parent key must exist, and the graph must be connected and acyclic.
- Array order is sibling order under each parent.
- `side: "left"` or `"right"` is meaningful only on a direct child of the root. Omit it to balance branches automatically.
- `edgeColor` accepts `yellow`, `red`, `blue`, `green`, `black`, `orange`, `purple`, or `white`; normally omit it.

## Rich node definitions

Create a reusable Card:

```json
{
  "type": "cardNode",
  "source": {
    "type": "newCard",
    "content": "# Activation evidence\n\nDetailed explanation"
  }
}
```

Reference a regular Card without consuming a whiteboard placement:

```json
{
  "type": "cardNode",
  "source": { "type": "existingCard", "cardId": "<cardId>" }
}
```

Consume one current Card placement into the map:

```json
{
  "type": "cardNode",
  "source": { "type": "cardInstance", "id": "inst:<placementId>" }
}
```

Consume a Highlight Element placement:

```json
{
  "type": "highlightElementNode",
  "source": { "type": "highlightElementInstance", "id": "inst:<placementId>" }
}
```

Create or consume a Text Element:

```json
{
  "type": "textElementNode",
  "source": { "type": "newTextElement", "content": "**Supporting detail**" }
}
```

```json
{
  "type": "textElementNode",
  "source": { "type": "textElement", "id": "inst:<placementId>" }
}
```

Before consuming a placement, read the target whiteboard layout and use its exact `inst:` ID when available. Consuming turns that standalone placement into a structural node and can change its Section membership and connected relations. Do not consume an object merely to copy its text.

## Read before updating

Use the canonical `mindMapId`, not the Mind Map Instance ID:

```bash
heptabase object read mindMap <mindMapId>
```

Copy current structural `mindMapNodeId` values from that output. Do not reuse node IDs from an old read after another edit.

## Update operations

`update-mind-map` takes an ordered operation list:

```bash
heptabase whiteboard update-mind-map --input input.json
```

```json
{
  "mindMapId": "<mindMapId>",
  "operations": [
    {
      "operation": "addNode",
      "nodeKey": "risk-mitigation",
      "parent": { "type": "existingNode", "mindMapNodeId": "<risksNodeId>" },
      "position": { "type": "last" },
      "node": { "type": "textNode", "content": "Mitigation" }
    },
    {
      "operation": "setCollapsed",
      "target": { "type": "newNode", "nodeKey": "risk-mitigation" },
      "isCollapsed": true
    }
  ]
}
```

Operations run sequentially. A `newNode` reference may target only an earlier `addNode` in the same call.

Supported operations:

| Operation | Important fields |
| --- | --- |
| `addNode` | `nodeKey`, `parent`, optional `position`, `side`, `edgeColor`, and `node` |
| `updateTextNode` | `target`, complete replacement plain-text `content`; only for `textNode` |
| `moveNode` | `target`, new `parent`, optional `position` and root-child `side` |
| `deleteSubtree` | `target`; deletes it and all descendants, but cannot delete the root |
| `setLayout` | `layout`: `horizontal` or `vertical` |
| `setCollapsed` | `target`, `isCollapsed` |
| `setEdgeColor` | non-root `target`, `edgeColor`; applies to its subtree |

Node references:

```json
{ "type": "existingNode", "mindMapNodeId": "<mindMapNodeId>" }
```

```json
{ "type": "newNode", "nodeKey": "<earlierNodeKey>" }
```

Sibling positions:

```json
{ "type": "first" }
```

```json
{ "type": "last" }
```

```json
{ "type": "before", "sibling": { "type": "existingNode", "mindMapNodeId": "<siblingId>" } }
```

```json
{ "type": "after", "sibling": { "type": "newNode", "nodeKey": "<earlierNodeKey>" } }
```

The root cannot be moved, deleted, or recolored with `setEdgeColor`. `updateTextNode` cannot change a node type or edit Card, Highlight Element, or Text Element content.

Deleting a Card node removes its map placement but keeps the canonical Card. Deleting a Highlight Element or Text Element node removes that attached canvas element rather than detaching it as a standalone placement.

## Atomicity and limits

- Creation and update are all-or-nothing. Invalid structure, source ambiguity, scope failure, or a bad sequential operation commits nothing.
- One update accepts at most 100 operations.
- The final map accepts at most 300 nodes.
- A compiled change above 1,000 persisted actions fails. Split a large update into smaller calls that each leave a valid map.
- Inspect `status`, `operationFailureReasonCode`, and any reported operation index, node key, source ID, or candidate instance IDs before continuing.

## Verify

After creation or update:

1. Run `heptabase object read mindMap <mindMapId>` and confirm hierarchy, order, wording, node types, and stable IDs.
2. Run `heptabase whiteboard read-layout <whiteboardId>` and `heptabase whiteboard lint <whiteboardId>`.
3. Export and inspect a focused schematic screenshot as described in `whiteboard.md`.
4. Check that surrounding objects, Sections, and connections remain correct. Repair and repeat before claiming completion.
AGENT_LAZYPACK_HEPTABASE_CLI_REFERENCES_MIND_MAPS_MD_A1B781DF4B

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

# heptabase-cli/references/whiteboard.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/heptabase-cli/references/whiteboard.md")"
cat > "{{SYNC_ROOT}}/skills/heptabase-cli/references/whiteboard.md" <<'AGENT_LAZYPACK_HEPTABASE_CLI_REFERENCES_WHITEBOARD_MD_D094E5C56F'
# Whiteboard work

Use this reference for whiteboard structure reads, layout changes, and visual checks. Copy IDs and object types from current CLI output. Do not guess them.

## Read before writing

Start each layout-changing turn from current state:

```bash
heptabase whiteboard read <whiteboardId> --mode structure
heptabase whiteboard read-layout <whiteboardId>
```

Use `--mode content` when grouping or order depends on meaning. Add `--include-connection-ids` when inspecting or repairing routes.

For a focused layout read, send canonical JSON:

```json
{
  "whiteboardId": "<whiteboardId>",
  "focus": {
    "objects": [
      { "id": "inst:<placementId>", "objectType": "card" },
      { "id": "<sectionId>", "objectType": "section" }
    ],
    "padding": 160
  },
  "shouldIncludeConnectionIds": true
}
```

Pass it as a file or through stdin:

```bash
heptabase whiteboard read-layout --input input.json
jq -n --arg id '<whiteboardId>' '{whiteboardId: $id}' | heptabase whiteboard read-layout --input -
```

`focus` and `viewport` are mutually exclusive. A viewport has `x`, `y`, `width`, and `height`.

## Object references

Most whiteboard inputs use:

```json
{ "id": "<objectId>", "objectType": "<objectType>" }
```

- Copy `objectType` exactly from `whiteboard read` or `read-layout`.
- Use the exact `inst:<placementId>` whenever layout output provides it. A canonical object may have more than one visible placement.
- `place-objects` is different: it takes canonical source IDs or a journal date, never `inst:` IDs.
- Read both source and destination layouts before a cross-whiteboard move.

## Selections and destinations

Selections:

```json
{ "type": "objects", "objects": [{ "id": "inst:<placementId>", "objectType": "card" }] }
```

```json
{ "type": "box", "box": { "x": 0, "y": 0, "width": 1200, "height": 800 } }
```

```json
{ "type": "all" }
```

`all` is only supported by `move-objects-across`. A box is resolved against current layout at execution time, so reread and reconfirm it if the board may have changed.

Destinations:

```json
{ "type": "auto" }
```

```json
{ "type": "point", "x": 100, "y": 200 }
```

```json
{ "type": "delta", "dx": 300, "dy": 0 }
```

```json
{
  "type": "nextTo",
  "objectId": "inst:<anchorPlacementId>",
  "objectType": "card",
  "side": "right",
  "gap": 120,
  "alignment": "center"
}
```

```json
{ "type": "inSection", "sectionId": "<sectionId>" }
```

`place-objects` and `create-shortcut` support `auto`, `point`, `nextTo`, and `inSection`. `move-objects` supports `delta`, `point`, and `nextTo`. `arrange-objects` has an optional `point` or `nextTo` anchor.

## Safe layout loop

1. Read semantic structure and current layout. Include connection IDs when routes are in scope.
2. Define the smallest authorized object set. Preserve unrelated content and the board's existing visual rules.
3. Resize objects before arranging them. Treat input order as reading order.
4. Apply one coherent mutation group and inspect all handled failure fields in the JSON result.
5. Reread the changed area and run `heptabase whiteboard lint <whiteboardId>`.
6. Export and inspect a focused screenshot. Repair and repeat. For substantial work, finish with a whole-board screenshot and lint.

A clean lint result does not prove the layout is understandable. A screenshot does not replace reading content or linting geometry.

## Placement and hierarchy

Create and move hierarchy with flat flags:

```bash
heptabase whiteboard create --title "Projects" --parent-whiteboard-id <parentWhiteboardId>
heptabase whiteboard move <whiteboardId> --target-parent-whiteboard-id <parentWhiteboardId>
heptabase object rename whiteboard <whiteboardId> --new-name "Projects"
```

Omit `--target-parent-whiteboard-id` to move a whiteboard to root. A shortcut does not change hierarchy:

```bash
heptabase whiteboard create-shortcut --input input.json
```

```json
{
  "whiteboardId": "<destinationWhiteboardId>",
  "linkedWhiteboardId": "<linkedWhiteboardId>",
  "destination": { "type": "auto" }
}
```

Place existing source objects:

```bash
heptabase whiteboard place-objects --input input.json
```

```json
{
  "whiteboardId": "<whiteboardId>",
  "objects": [
    { "id": "<cardId>", "objectType": "card" },
    { "id": "<pdfCardId>", "objectType": "pdfCard" }
  ],
  "destination": { "type": "auto" }
}
```

Supported placement types are `card`, `journal`, `pdfCard`, `imageCard`, `videoCard`, `audioCard`, and `webCard`.

## Move, arrange, and align

Move one or more selections on the same whiteboard:

```bash
heptabase whiteboard move-objects --input input.json
```

```json
{
  "whiteboardId": "<whiteboardId>",
  "moves": [
    {
      "selection": {
        "type": "objects",
        "objects": [{ "id": "inst:<placementId>", "objectType": "card" }]
      },
      "destination": {
        "type": "nextTo",
        "objectId": "<sectionId>",
        "objectType": "section",
        "side": "right"
      }
    }
  ]
}
```

Move a selection to another whiteboard:

```bash
heptabase whiteboard move-objects-across --input input.json
```

```json
{
  "sourceWhiteboardId": "<sourceWhiteboardId>",
  "destinationWhiteboardId": "<destinationWhiteboardId>",
  "selection": { "type": "all" }
}
```

This keeps relative layout and relations fully inside the moved group. Relations crossing the selection boundary are removed and reported. Cross-space moves are not supported.

Arrange objects in input order:

```bash
heptabase whiteboard arrange-objects --input input.json
```

```json
{
  "whiteboardId": "<whiteboardId>",
  "objects": [
    { "id": "inst:<firstPlacementId>", "objectType": "card" },
    { "id": "inst:<secondPlacementId>", "objectType": "card" }
  ],
  "layout": { "type": "row", "gap": 0, "alignment": "center" },
  "anchor": { "type": "point", "x": 100, "y": 200 }
}
```

Layout shapes are:

- Row: `type`, optional `gap`, optional `alignment` of `top`, `center`, or `bottom`.
- Column: `type`, optional `gap`, optional `alignment` of `left`, `center`, or `right`.
- Grid: `type`, optional `columns`, `rowGap`, and `columnGap`.

Use a grid only for genuine peers. Use exact center alignment for a direct connected handoff.

Align targets to their own selection bounds or stationary references:

```bash
heptabase whiteboard align-objects --input input.json
```

```json
{
  "whiteboardId": "<whiteboardId>",
  "targetObjects": [{ "id": "inst:<placementId>", "objectType": "card" }],
  "referenceObjects": [{ "id": "inst:<referencePlacementId>", "objectType": "card" }],
  "alignment": "centerVertically"
}
```

Alignment values are `left`, `centerHorizontally`, `right`, `top`, `centerVertically`, and `bottom`. Alignment changes only one axis.

Never arrange or move a Section together with one of its descendants. Moving a Section already carries its members.

## Resize, color, remove, and section

Resize examples:

```bash
heptabase whiteboard resize-objects --input input.json
```

```json
{
  "whiteboardId": "<whiteboardId>",
  "resizes": [
    { "id": "inst:<readerCardPlacementId>", "objectType": "card", "mode": "fitToContent" },
    { "id": "inst:<sourcePlacementId>", "objectType": "pdfCard", "mode": "defaultSize" },
    { "id": "inst:<mediaPlacementId>", "objectType": "imageCard", "mode": "setSize", "width": 600 },
    { "id": "inst:<foldablePlacementId>", "objectType": "card", "mode": "setFolded", "isFolded": false }
  ]
}
```

Use `fitToContent` for content meant to be read on the canvas and `defaultSize` for long sources or previews. Media normally sets one dimension to preserve aspect ratio. Do not include the same object twice in one resize call. Fit a containing Section in a later call after its members change.

Color input uses `updates` with `yellow`, `red`, `blue`, `green`, `black`, `orange`, `purple`, or `white`:

```bash
heptabase whiteboard recolor-objects --input input.json
```

```json
{
  "whiteboardId": "<whiteboardId>",
  "updates": [{ "id": "inst:<placementId>", "objectType": "card", "color": "blue" }]
}
```

Remove placements without deleting source Cards:

```bash
heptabase whiteboard remove-objects --input input.json
```

```json
{
  "whiteboardId": "<whiteboardId>",
  "removals": [{ "id": "inst:<placementId>", "objectType": "card" }]
}
```

Removing a Section frame leaves its members. Create a Section only after its members are arranged:

```bash
heptabase whiteboard create-section --input input.json
```

```json
{
  "whiteboardId": "<whiteboardId>",
  "title": "Research",
  "color": "yellow",
  "objects": [{ "id": "inst:<placementId>", "objectType": "card" }]
}
```

A new Section wraps current geometry; it does not arrange scattered objects. Use Sections for meaningful scope, phase, category, or navigation.

## Connections

Read layout with `--include-connection-ids` before changing a route. Create only relationships that grouping alone does not show:

```bash
heptabase whiteboard create-connections --input input.json
```

```json
{
  "whiteboardId": "<whiteboardId>",
  "connections": [
    {
      "from": { "id": "inst:<sourcePlacementId>", "objectType": "card", "position": "right" },
      "to": { "id": "inst:<targetPlacementId>", "objectType": "card", "position": "left" },
      "direction": "oneWay",
      "routeType": "straight"
    }
  ]
}
```

Endpoint positions are `auto`, `top`, `right`, `bottom`, and `left`. Directions are `oneWay`, `twoWay`, and `none`. Routes are `straight`, `elbow`, and `curve`. Omit control points first; add the fewest needed only for a real obstacle.

Update one connection with a partial patch:

```bash
heptabase whiteboard update-connection --input input.json
```

```json
{
  "whiteboardId": "<whiteboardId>",
  "connectionId": "<connectionId>",
  "from": { "position": "right" },
  "to": { "position": "left" },
  "routeType": "straight"
}
```

After any endpoint move, resize, or route update, reread and inspect every affected route. Keep important paths traceable and avoid crossings through unrelated readable objects.

## Visual verification

Capture the whole board:

```bash
heptabase whiteboard screenshot <whiteboardId> --output <existingDirectory>/whiteboard.png
```

Capture a changed area by passing the same `focus` shape used by `read-layout`:

```bash
heptabase whiteboard screenshot --input focus.json --output <existingDirectory>/focus.png
```

The output path must end in `.png` and its parent directory must exist. Existing files are not replaced unless `--force` is set. Do not use `--force` unless replacement is intended.

Inspect the returned absolute path with the agent's image-reading tool. Check grouping, reading order, spacing, alignment, containment, route clarity, whitespace, and the complete changed area. Repair and recapture every material problem before claiming completion.

## Result handling

- Check `status`, `operationFailureReasonCode`, per-item `failureReasonCode`, warning fields, and candidate instance IDs.
- Arrangement, alignment, mind-map creation, and mind-map updates are coupled operations that fail as a unit when their structure is invalid.
- Some placement, movement, resize, color, removal, Section, and connection batches can return mixed item results. Do not silently treat partial success as completion.
- The CLI has no undo command. Use current reads, small scopes, and post-write checks.
AGENT_LAZYPACK_HEPTABASE_CLI_REFERENCES_WHITEBOARD_MD_D094E5C56F

test -f "{{SYNC_ROOT}}/skills/heptabase-cli/SKILL.md" && echo "heptabase-cli installed for Codex, Claude, and AntiGravity"
````

安裝完成後，請開新 Agent 對話或重啟對應 App，再測試 skill 是否能被讀取。

<!-- END EMBEDDED_SKILLS -->
