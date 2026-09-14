# Cloudflare + D1 OAuth 讀寫安裝與驗收

> 版本：1.0
> 修訂日期：2026-09-15
> 用途：讓 Wrangler CLI 與桌面 AI Agent 透過 Cloudflare 官方 OAuth 連上指定帳號的 D1，授予讀寫權限，但安裝驗收只進行唯讀查詢。
> 實測環境：macOS arm64、zsh、Node.js 25.9.0、npm 11.12.1、Wrangler 4.131.1、Codex CLI 0.153.4。

## 來源與本版差異

本文以 [mathruffian-dot/cloudflare-d1-oauth-agent-guide](https://github.com/mathruffian-dot/cloudflare-d1-oauth-agent-guide) v1.1 為主要轉換來源，實測時釘定 commit 為 `addbbadff948baec3bd8ca836dfc7f54a904e770`；上游採 MIT License。本 LazyPack 沒有逐字內嵌上游提示詞，而是保留其四層分工、階段式同意、憑證分級、最小權限與 OAuth 防重複原則，再加入這次實際安裝紀錄。

上游預設是 D1 唯讀；本版的「實測複製設定」依使用者明確要求改為 D1 讀寫：

- Wrangler OAuth：`account:read`、`user:read`、`d1:write`。當前實測版本沒有獨立 `d1:read`；`d1:write` 的說明同時包含查看與變更 D1。
- Cloudflare API MCP OAuth：三個必要權限加上 `D1 Metadata Read`、`D1 Read`、`D1 Write`，總共六項。
- 驗收仍只列出 D1 清單；不建立資料庫、不執行 SQL、不建立 binding、不部署 Worker。

執行時仍應重新查看當前官方文件與本機 `--help`；不得把本文的版本、參數或授權頁面計數當成永久不變的規格。

## 完成後會得到什麼

| 層次 | 完成狀態 | 不代表什麼 |
| --- | --- | --- |
| Cloudflare 網站 | 使用者已在正確的 Dashboard 帳號與 Account | 不代表 CLI 或 MCP 已授權 |
| Wrangler CLI | OAuth 有效、憑證使用 OS keychain、可列出 D1 | 不代表 Agent MCP 已連線 |
| Agent MCP | 官方 Cloudflare API MCP 已設定、OAuth 有效、六項權限已核准 | 不代表已建立 D1 或修改資料 |
| 應用程式 | 本 Item 預設不執行 | 不代表 Worker 已有 D1 binding |

## 安全邊界

- 密碼、Google 驗證碼、MFA、OAuth code、token、cookie、Account ID、完整 callback URL 與 keychain 內容不貼到聊天、repo、Obsidian、log 或截圖。
- 帳號條款、Google 帳號選擇、MFA 與 OAuth 核准由使用者本人在瀏覽器操作；Agent 可以導航和說明，不可代填認證資料。
- 禁止執行會印出憑證的 `wrangler auth token`，也不讀取 Wrangler、Codex、Claude 或 AntiGravity 的 OAuth 儲存內容。
- 發現既有授權時，先比對帳號、Account、權限與儲存方式；符合就沿用，不強制重登。
- 登出、重新授權、覆蓋設定、改用其他帳號，都必須先說明影響並取得明確同意。
- 寫入權限只是未來可用能力，不是當下執行寫入的同意。任何 D1 create、execute、migration、delete 或 binding 都要另行確認目標與變更內容。
- 一次只保留一個正在等待的 OAuth 程序；不在舊程序還活著時重開新授權。

## 一、選擇使用模式

在安裝或產生短效 OAuth URL 之前，先確定本次是哪一種：

1. 首次註冊：使用者要以自己選定的 Google 帳號建立 Cloudflare 帳號。
2. 沿用授權：已有 Cloudflare 帳號，先檢查現有 Wrangler 與 MCP 狀態。
3. 重演授權：只重做 Wrangler、只重做 MCP，或兩者都重做。

如果使用者沒有 Cloudflare 帳號，先開啟 [Cloudflare Dashboard](https://dash.cloudflare.com/) 由本人完成註冊。不要從 Gmail 地址推測是否已註冊，也不要因為本機有其他 Cloudflare 授權就自動覆蓋。

## 二、執行前只讀檢查

### 1. 查官方文件

每次執行先核對：

- [Wrangler 安裝與更新](https://developers.cloudflare.com/workers/wrangler/install-and-update/)
- [Wrangler 通用指令、OAuth 與 keychain](https://developers.cloudflare.com/workers/wrangler/commands/general/)
- [Wrangler D1 指令](https://developers.cloudflare.com/workers/wrangler/commands/d1/)
- [Cloudflare 官方 MCP servers](https://developers.cloudflare.com/agents/model-context-protocol/cloudflare/servers-for-cloudflare/)
- [Codex MCP 文件](https://developers.openai.com/codex/mcp)
- [Claude Code MCP 文件](https://docs.anthropic.com/en/docs/claude-code/mcp)
- [Google AntiGravity MCP 文件](https://antigravity.google/docs/mcp)

Cloudflare 官方建議在 Worker 專案內以 dev dependency 安裝 Wrangler。這次為了讓多個專案共用 CLI，實測採全域安裝。下載者要複製本次效果就選全域路線；要固定單一 Worker 專案版本則選專案路線。

### 2. 檢查版本、來源與現有狀態

macOS、Linux、WSL：

```bash
node --version
npm --version
command -v wrangler || true
wrangler --version 2>/dev/null || true
wrangler login --help 2>/dev/null || true
wrangler login --scopes-list 2>/dev/null || true
```

Windows PowerShell：

```powershell
node --version
npm --version
Get-Command wrangler -ErrorAction SilentlyContinue
wrangler --version
wrangler login --help
wrangler login --scopes-list
```

只檢查下列環境變數有沒有設定，不可印出值。

macOS、Linux、WSL：

```bash
for name in CLOUDFLARE_API_TOKEN CLOUDFLARE_API_KEY CLOUDFLARE_EMAIL CLOUDFLARE_ACCOUNT_ID CLOUDFLARE_AUTH_USE_KEYRING WRANGLER_PROFILE; do
  if printenv "$name" >/dev/null; then
    printf '%s=set\n' "$name"
  else
    printf '%s=unset\n' "$name"
  fi
done
```

Windows PowerShell：

```powershell
$names = @(
  "CLOUDFLARE_API_TOKEN",
  "CLOUDFLARE_API_KEY",
  "CLOUDFLARE_EMAIL",
  "CLOUDFLARE_ACCOUNT_ID",
  "CLOUDFLARE_AUTH_USE_KEYRING",
  "WRANGLER_PROFILE"
)
$names | ForEach-Object {
  $value = [Environment]::GetEnvironmentVariable($_)
  if ($null -eq $value) { "$_=unset" } else { "$_=set" }
}
```

若 `CLOUDFLARE_API_TOKEN`、API key、email、Account ID 或 Profile 已設定，先釐清它們是否指向目標帳號。不要為了判斷而回顯 secret。

## 三、安裝 Wrangler

### 實測複製路線：全域安裝

先預覽會從 npm 下載並修改全域 Node 套件；取得同意後才執行：

```bash
npm install -g wrangler@latest
wrangler --version
command -v wrangler
```

2026-09-15 實測基準為 Wrangler 4.131.1。如果導師或組織要重現當日參數行為，可在風險評估後將 `@latest` 改為 `@4.131.1`；新安裝一般應使用當前版並重跑 help gate。

### Cloudflare 官方建議路線：專案本地安裝

```bash
cd "{{PROJECT_ROOT}}"
npm install --save-dev wrangler@latest
npx wrangler --version
```

選這條後，下文所有 `wrangler` 指令都改成 `npx wrangler`。不要同時用全域與專案版而沒有記錄實際執行的來源。

## 四、Wrangler OAuth 讀寫授權

### 1. 先檢查既有授權

```bash
wrangler whoami --json
wrangler auth list
```

`whoami --json` 可能包含電子郵件與 Account ID。只在本機確認是否符合 `{{CLOUDFLARE_ACCOUNT_NAME}}`，報告只寫「相符」或「不相符」，不抄錄個資與 ID。`auth list` 在當前版本是 experimental；不存在就跳過，不因此破壞現有授權。

若已是正確帳號、權限與加密儲存，直接前往 D1 清單驗收。若需取代現有授權，先說明 `wrangler logout` 會使當前 OAuth token 失效並刪除儲存憑證，取得明確同意後才登出。

### 2. 確認權限名稱

```bash
wrangler login --scopes-list
```

本次實測可用項目包含：

- `account:read`：讀取 Account 與 membership 資訊。
- `user:read`：讀取使用者基本資訊。
- `d1:write`：查看與變更 D1 Databases。

當前 Wrangler 如果不傳 `--scopes`，預設會要求全部可用 scopes，不符合這個安裝檔的限定範圍。

### 3. 啟動一個可見的 device flow

macOS、Linux、WSL：

```bash
CLOUDFLARE_AUTH_USE_KEYRING=true wrangler login --device --browser=false --use-keyring --scopes account:read --scopes user:read --scopes d1:write
```

Windows PowerShell：

```powershell
$env:CLOUDFLARE_AUTH_USE_KEYRING = "true"
wrangler login --device --browser=false --use-keyring --scopes account:read --scopes user:read --scopes d1:write
```

操作原則：

1. 終端必須保持開啟，不在背景靜默跑 OAuth。
2. Wrangler 會印出驗證網址與短效代碼。開啟該網址，在 Cloudflare 官方頁面輸入代碼並由使用者核准。
3. 代碼不貼進聊天或截圖；瀏覽器已預填時只需核對後核准。
4. 當前官方文件說明 device code 通常在五分鐘後停止輪詢。如果過期，先等原程序確定結束，再由使用者同意重試。
5. 只有原指令回報成功才算 OAuth 完成；使用者說「已核准」還需搭配 CLI 結果。

### 4. 驗收 Wrangler

```bash
wrangler whoami --json
wrangler whoami
wrangler d1 list --json
```

驗收準則：

- `whoami` 顯示的帳號與 Account 符合使用者選定目標。
- 顯示 OAuth 憑證放在 OS keychain 或當前版本可驗證的加密儲存路徑。
- `d1 list --json` 呼叫成功。結果是 `[]` 或 0 個資料庫仍為成功。
- 不為了證明 write scope 而建立測試資料庫。

## 五、Cloudflare API MCP

官方 endpoint 固定使用：

```text
https://mcp.cloudflare.com/mcp
```

這是 Cloudflare API MCP，可搜尋並執行 Cloudflare API；不要誤用文件查詢端點 `https://docs.mcp.cloudflare.com/mcp` 或 Workers Bindings 端點 `https://bindings.mcp.cloudflare.com/mcp`。

### 授權頁面要精確選六項

連線官方 MCP 後，Cloudflare 授權頁面可能預選很多權限。2026-09-15 實測曾顯示 194 / 384；這個計數會變，不可當作驗收條件。

選擇步驟：

1. 確認目標 Account。
2. 選 `Custom`。
3. 按 `Deselect all`。
4. 搜尋 `D1`。
5. 勾選三個 D1 權限：
   - `D1 Metadata Read`（scope ID：`d1.metadata_read`）
   - `D1 Read`（scope ID：`d1.read`）
   - `D1 Write`（scope ID：`d1.write`）
6. 確認必要權限仍在：
   - `User`
   - `Account`
   - `Offline access`
7. 送出前以「六個名稱」為準，不以頁面上的總項目數為準；不得殘留其他 Cloudflare 產品權限。

### Codex adapter（本次已實測）

1. 先確認當前 CLI 支援指令：

```bash
codex --version
codex mcp --help
codex mcp add --help
codex mcp login --help
```

2. 在修改前備份 `{{CODEX_CONFIG}}`。下列 placeholder 必須先換成下載者自己的路徑：

```bash
mkdir -p "{{BACKUP_ROOT}}"
if [ -f "{{CODEX_CONFIG}}" ]; then
  stamp="$(date +%Y%m%d-%H%M%S)"
  cp -p "{{CODEX_CONFIG}}" "{{BACKUP_ROOT}}/codex-config.toml.bak.$stamp"
fi
```

3. 先查是否已有同名設定：

```bash
codex mcp get cloudflare-api
```

已有正確 URL 就不重複 `add`。已有錯誤設定時，先展示要改的差異並取得同意。

4. 尚未設定才新增：

```bash
codex mcp add cloudflare-api --url https://mcp.cloudflare.com/mcp
```

`add` 可能當場啟動 OAuth。若已開始，就在同一個程序完成上述六項選權；不同時再跑 `login`。

5. 只在設定已存在但狀態是未登入、而且沒有其他 OAuth 正在等待時，才執行：

```bash
codex mcp login cloudflare-api
```

6. 由使用者在 Cloudflare 頁面選六項權限、登入正確帳號並核准。不轉傳完整 callback URL、`code`、`state` 或 PKCE 參數。

7. 驗收本機設定：

```bash
codex mcp get cloudflare-api
codex mcp list
```

通過條件是 URL 正確、server 為 enabled、Auth 為 OAuth。OAuth 完成不足以推論一定使用 macOS Keychain；只可回報「由當前 Codex 客戶端管理 OAuth」，儲存實作要依當前版本另行查證。

8. 新增 MCP 後，當前對話可能不會動態載入新工具。開新 Codex 對話後驗收，不要把 OAuth 再做一次。

### Claude Code adapter（指令已查證，本帳號未實做 Cloudflare OAuth）

當前實測 Claude Code 2.1.205 支援 HTTP MCP 與 `login`。只有在使用者選擇 Claude adapter 時才新增：

```bash
claude --version
claude mcp add --help
claude mcp login --help
claude mcp get cloudflare-api
claude mcp add --transport http --scope user cloudflare-api https://mcp.cloudflare.com/mcp
claude mcp login cloudflare-api
claude mcp get cloudflare-api
```

如果 `add` 已啟動 OAuth，同樣不重複跑 `login`。在 Cloudflare 頁面仍選同一組六項權限。Claude 的 OAuth 儲存由 Claude Code 管理；不直接讀憑證檔來驗證。

### AntiGravity adapter（官方路徑已查證，本帳號未實做 Cloudflare OAuth）

1. 在 AntiGravity 開啟 `Settings` → `Customizations` → `MCP Servers`。
2. 先在 MCP Store 搜尋 Cloudflare；若已有官方項目，核對 endpoint 必須是 `https://mcp.cloudflare.com/mcp`。
3. 若需自訂 server，用 `Manage MCP Servers` → `View raw config` 在 `{{GEMINI_CONFIG}}/mcp_config.json` 的既有 `mcpServers` 物件中合併下列項目，不覆蓋整份檔案：

```json
{
  "mcpServers": {
    "cloudflare-api": {
      "serverUrl": "https://mcp.cloudflare.com/mcp"
    }
  }
}
```

4. 當前 AntiGravity 官方 schema 的遠端連線欄位是 `serverUrl`，不是舊式 `url` 或 `httpUrl`。
5. 儲存後按 Refresh，對 `cloudflare-api` 按 Authenticate，完成瀏覽器授權並選六項權限。
6. 官方文件記載 OAuth token 由 AntiGravity 儲存在它的本機 token 檔；不開啟、不複製、不同步該檔到雲端或 Git。

## 六、OAuth 逢時或跳回登入頁的處理

實際安裝遇過兩種相似情況：Wrangler device flow 在核准前逾時，以及 MCP 按 Continue 後先跳到 Cloudflare 登入驗證，導致原本的本機 callback 程序過期。

固定處理順序：

1. 不根據瀏覽器看到「核准」就宣告成功。
2. 回到啟動 OAuth 的原終端，確認程序是成功、失敗、逾時，或仍在等待。
3. 原程序仍在等待時不開第二個。
4. 已結束才用狀態指令檢查：Wrangler 用 `wrangler whoami --json`；Codex 用 `codex mcp list`；Claude 用 `claude mcp get cloudflare-api`。
5. 若顯示未登入，先請使用者在同一個瀏覽器 profile 登入正確的 Cloudflare Dashboard。
6. 重新預告通道、目標帳號、權限與儲存方式，取得一次新的重試同意。
7. 只啟動一個新 flow，重新選六項權限，完成後再用原程序與狀態指令交叉驗證。

不要留下「看似已核准，但本機還是 Not logged in」的半完成狀態。

## 七、開新對話進行 MCP 唯讀驗收

新對話只給這個任務：

```text
請只使用 cloudflare-api MCP，對目標 Cloudflare Account 進行唯讀驗收：
1. 確認目標 Account 相符，回報時不列出 email 或 Account ID。
2. 只列出 D1 資料庫清單與數量。
3. 只允許 GET；不建立、修改、刪除資源，不執行 SQL。
4. 清單為空仍視為連線與唯讀驗收成功。
5. 回報實際使用的 HTTP method、完成與未驗證項目。
```

驗收必須與 Wrangler 交叉比對：

| 檢查 | 通過條件 |
| --- | --- |
| Wrangler Account | 與使用者選定 Account 相符 |
| Wrangler D1 | 列表成功；0 個也通過 |
| MCP Account | 與 Wrangler 目標相符 |
| MCP D1 | 列表成功，數量與 Wrangler 相容 |
| 變更行為 | 本次只有 GET，無雲端資源異動 |
| D1 Write | scope 已授予，但寫入行為未驗證 |

2026-09-15 的實測結果是：Wrangler 與 Codex MCP 都對到同一個 Cloudflare Account，D1 均為 0 個、空清單，MCP 全程只使用 GET，沒有重新登入或修改任何資源。這是連線成功的正式通過範例，不是「還沒有驗收」。

## 八、完成證據與交接格式

報告每一項時必須加上證據級別：

1. `已實測`：本次指令、MCP tool 或 HTTP method 有實際結果。
2. `使用者確認`：使用者在瀏覽器完成登入或核准。
3. `官方文件說明`：文件有記載，但本環境尚未實做。
4. `尚未驗證`：沒有實際證據；不能改寫成已完成。

必要時可用下列無敏感資料交接：

```markdown
## Cloudflare + D1 交接

- 目標 Account：已核對，不記錄 email 或 Account ID。
- Wrangler：版本與來源已記錄；OAuth 狀態：已登入／未登入。
- Wrangler scopes：account:read、user:read、d1:write。
- Wrangler D1 驗收：成功／失敗；資料庫數量：<N>。
- MCP client：Codex／Claude／AntiGravity；server：cloudflare-api。
- MCP URL：https://mcp.cloudflare.com/mcp
- MCP 權限：User、Account、Offline access、D1 Metadata Read、D1 Read、D1 Write。
- MCP 狀態：已登入／未登入；是否需開新對話：是／否。
- MCP D1 驗收：成功／失敗；資料庫數量：<N>；HTTP method：GET-only／未知。
- 未執行：D1 建立、SQL、migration、binding、Worker 部署。
- 敏感資料：未寫入交接。
```

## 九、登出、移除與撤銷

這些都會改變現有連線狀態，不屬於安裝驗收的自動收尾。只在使用者明確要求後執行。

```bash
# 使 Wrangler OAuth token 失效，並刪除當前儲存憑證
wrangler logout

# 只清除 Codex 內的 Cloudflare MCP OAuth
codex mcp logout cloudflare-api

# 再移除 Codex 的 server 設定；這不等於先 logout
codex mcp remove cloudflare-api

# Claude Code 對應操作
claude mcp logout cloudflare-api
claude mcp remove --scope user cloudflare-api
```

AntiGravity 從 `Settings` → `Customizations` → `Installed MCP Servers` 移除或清除認證。要從 Cloudflare 伺服器端撤銷第三方應用時，使用當前 Dashboard 的授權管理界面，先核對只會撤銷目標應用，不刪除 Cloudflare Account 或 D1 資源。

## 十、常見問題

| 症狀 | 判斷 | 處理 |
| --- | --- | --- |
| `wrangler` 不存在 | 未安裝或 PATH 未載入 | 確認 Node/npm，取得下載同意後依全域或專案路線安裝 |
| `login` 參數不存在 | 文件與已安裝版本不一致 | 以本機 `wrangler login --help` 為執行依據；需升級時先取得同意 |
| 看到很多預選 MCP 權限 | Cloudflare API MCP 可接觸很多 API | 選 Custom、Deselect all，只留六個目標名稱 |
| 按 Continue 後要重登 Cloudflare | 瀏覽器 session 不在正確 Dashboard | 先完成本人登入；若本機 OAuth 已逾時，等原程序結束後再取得重試同意 |
| 瀏覽器說成功，CLI 說逾時 | callback 沒有在時限內回到原程序 | 以 CLI 為準，查狀態，不直接宣告成功；必要時單次重試 |
| `codex mcp list` 是 `Not logged in` | server 已加入但 OAuth 未完成 | 確認沒有舊 flow、預登入 Dashboard、取得同意後跑一次 `codex mcp login cloudflare-api` |
| 現在對話看不到新 MCP tools | 客戶端沒有動態載入 | 保留無敏感資料交接，開新對話進行唯讀驗收 |
| D1 清單是空的 | 帳號尚無資料庫 | 這仍證明清單 API 可讀；不需建立測試 DB |
| 已授 `D1 Write` 卻沒有寫入證據 | 本 Item 故意不對雲端做變更 | 回報「scope 已授予，write 行為尚未驗證」；不把授權說成寫入實測 |

## 十一、可直接交給 Agent 的執行提示詞

```text
請使用這份 LazyPack Item 46 協助我完成 Cloudflare + D1 讀寫 OAuth 安裝。

必須實際推進，不只寫教學文。執行前先用當前官方文件與本機 --help 查證參數，再分階段處理：Cloudflare 網站帳號、Wrangler OAuth、目前 Agent 的 Cloudflare API MCP OAuth、新對話唯讀驗收。

本次目標是「可讀寫，但驗收只讀」：
- Wrangler 限定 account:read、user:read、d1:write，使用 device flow 與 OS keychain。
- MCP 授權頁面選 Custom、Deselect all，只留 User、Account、Offline access、D1 Metadata Read、D1 Read、D1 Write 六項。
- 驗收只列出 D1；只允許 GET，不建立或修改資源，不執行 SQL。

先判斷我是首次註冊、沿用授權或重演授權。已有正確授權就沿用，不強制重登。安裝、登出、覆蓋設定、啟動 CLI OAuth 和啟動 MCP OAuth 都要分別先說明影響與權限，但同一範圍已取得的同意不重複詢問。

我會自己處理 Google 帳號選擇、密碼、MFA、條款與授權核准。不讀取或印出 token、cookie、keychain、OAuth code、Account ID 或完整 callback URL。一次只啟動一個 OAuth flow；逾時時先確認原程序已結束與實際狀態，再取得新的重試同意。

最後用「已實測／使用者確認／官方文件說明／尚未驗證」四級證據回報，並明確列出所用 Agent adapter、Wrangler 版本與來源、D1 數量、MCP HTTP method、未執行的寫入與應用 binding。
```

## 十二、本 Item 的驗收清單

- [ ] 上游來源、commit、授權與本版差異已記錄。
- [ ] Wrangler 參數已用當前 `--help` 核對，版本與實際 path 已記錄。
- [ ] 環境只檢查 secret 名稱是否存在，沒有回顯值。
- [ ] Wrangler 使用 keychain、device flow 與三個限定 scopes。
- [ ] Wrangler `whoami` 與 `d1 list --json` 實際通過，個資不寫入報告。
- [ ] MCP endpoint 為 `https://mcp.cloudflare.com/mcp`。
- [ ] MCP 只核准六項目標權限，其他產品權限為未選。
- [ ] MCP 在新對話以 GET-only 列出 D1，並與 Wrangler 結果相容。
- [ ] 已準確回報「D1 Write scope 已授予，寫入行為未驗證」。
- [ ] 未建立 D1、未執行 SQL/migration、未建立 binding、未部署 Worker。
- [ ] 沒有任何 token、email、Account ID、callback code、實體家目錄或使用者專屬資料被寫入公開檔案。
