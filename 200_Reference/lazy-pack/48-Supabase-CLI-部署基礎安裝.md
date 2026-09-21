# Codex 懶人包 #48：Supabase CLI 與部署基礎安裝

> 版本：v1.0　更新日期：2026-09-21
> 適用：macOS、Codex、Claude Code、AntiGravity 共用的 Supabase CLI 工作流
> 上游參考：`mathruffian-dot/codex-lazy-packs` Item 04（MIT，最後比對 `574818e2d80b31807b74fcf62dd5b90b9e46ef3f`）。本 Item 依官方現況重寫，不直接複製上游內容。

## 這個 Item 會完成什麼

- 安裝官方 Supabase CLI，供未來任何專案使用。
- 讓本人透過 Supabase Dashboard 登入，再由 `supabase login` 將管理 token 存入本機原生憑證儲存。
- 建立一條可重跑的「初始化 → 連結目標專案 → 預覽 migration → 取得確認後部署」路線。

本 Item **不會**自動建立雲端 Supabase 專案、不會建立資料表或 Edge Function、不會部署前端，也不會安裝 Supabase MCP。Supabase CLI 部署的是資料庫 migration、設定與 Edge Functions；網站前端仍須用 Netlify、Cloudflare Pages、Vercel 或其他前端主機。

## 為什麼不沿用上游的 MCP 與 `service_role` key

上游 Item 04 的核心目標是讓 Agent 直接讀寫雲端資料庫，並要求把 `service_role` key 交給 MCP。這把可繞過 Row Level Security 的高權限憑證交給每一個 Agent 對話，和「先安全地建立未來部署能力」不是同一件事。

此 Item 改用官方 CLI：登入 token 由 Supabase CLI 的原生憑證儲存管理，日後真正部署仍以 migration review、`--dry-run` 與明確確認為閘門。若未來確實需要 Supabase MCP，請另開任務，先界定目標專案、最小 scope、可用工具與資料風險；不得以 `service_role` key 當成預設答案。

## 登入與憑證邊界

| 用途 | 通道 | 保存位置 | 不可做的事 |
| :-- | :-- | :-- | :-- |
| Dashboard 帳號登入 | Supabase 支援的登入提供者 | 瀏覽器 session | 不把密碼、2FA、session 複製給 Agent |
| CLI 管理權限 | `supabase login` 的 Personal Access Token（PAT） | OS 原生憑證儲存；沒有時才 fallback 到 `~/.supabase/access-token` | 不貼入 repo、`.env`、LazyPack、MCP、聊天或截圖 |
| CI/CD | scoped PAT | GitHub Actions Secrets 或等效 secret store | 不把 token 寫進 workflow 原始碼 |
| 資料庫連線 | database password / platform credential | 本機憑證儲存或執行時 secret | 不放入 `supabase/config.toml`、repo 或前端 |

Dashboard 的登入選項會變動。2026-09-21 實測有 GitHub、ChatGPT、SSO、email/password；沒有 Google 按鈕。請選你實際可用的提供者。建立帳號、輸入密碼、2FA 與最後授權一律由本人完成。

登入後，`supabase login` 會開啟瀏覽器產生 CLI PAT。它可存取 Supabase Management API；一般互動式開發可使用 CLI 管理的原生憑證。日後交給 CI 或 Agent 自動化時，應建立**只涵蓋必要 organization／project／操作的 scoped PAT**，並在離職、遺失裝置或不再使用時，從 Supabase Account Tokens 頁面撤銷。

## Phase 1：先檢查環境

在終端機執行：

```bash
node --version
npm --version
git --version
brew --version
```

使用 npm／npx 時 Supabase CLI 要求 Node.js 20 以上。只想在單一專案使用時，可在該專案安裝：

```bash
npm install --save-dev supabase
npx supabase --help
```

本 Item 的 macOS 主線使用 Homebrew 全域安裝，因為它供未來多個專案共用。

## Phase 2：安裝官方 CLI

```bash
brew install supabase/tap/supabase
supabase --version
supabase --help
```

看到版本與指令說明才算安裝完成。這一步不需要 Docker；只有要在本機啟動完整 Supabase stack 時，才另行安裝並啟動 Docker 相容 container runtime。

## Phase 3：登入 Dashboard 與 CLI

1. 在瀏覽器前往 <https://supabase.com/dashboard>。
2. 選擇 Dashboard 當下提供、且屬於你本人的登入方式，例如 GitHub。
3. 由本人完成密碼、2FA、同意頁與可能的帳號建立。
4. 回到終端機執行：

```bash
supabase login
supabase projects list
```

`supabase projects list` 是低風險的唯讀驗證。沒有任何專案時，空清單也是成功結果。不要把 PAT 複製貼給 Agent；若 CLI 沒有 native credential storage 而建立 `~/.supabase/access-token`，確認它未被同步或 Git 追蹤，並限制為目前使用者可讀。

如果由瀏覽器自動化協助登入，權杖產生後不要再讀取頁面文字、DOM 或 accessibility snapshot，因為完整 PAT 可能被帶進工具輸出。安全做法是由本人接手複製，或讓自動化直接按 `Copy` 後用本機剪貼簿送入 CLI，而且不讀回剪貼簿內容；若完整 PAT 曾出現在聊天、log、截圖或工具輸出，立即撤銷並重新建立。

## Phase 4：未來建立專案與部署

建立雲端專案會產生雲端資源，可能涉及額度、帳單與資料保存位置，因此要在有專案名稱、organization、region 與 database password 決定後，另行確認再做。

之後在**真正的應用程式 repo 根目錄**（不是本 LazyPack repo）採用下列流程：

```bash
supabase init
supabase link --project-ref <YOUR_PROJECT_REF>
supabase db push --dry-run
```

先確認 `--dry-run` 列出的 migration、目標 project ref 與環境無誤，再取得明確同意才可執行：

```bash
supabase db push
```

若有 Edge Functions，部署前先確認 function 名稱與目標 project，再執行：

```bash
supabase functions deploy <FUNCTION_NAME>
```

**禁止對遠端 production 專案執行 `supabase db reset --linked`。** 該指令會清空遠端 schema 與資料後重放 migration，只適合可丟棄的開發／staging 環境。

## CI/CD 路線（未在本 Item 自動建立）

需要 GitHub Actions 時，將 scoped PAT 與 project ref 放進 GitHub Actions Secrets，分別命名為 `SUPABASE_ACCESS_TOKEN` 與 `SUPABASE_PROJECT_REF`。workflow 只應執行已審查的 migration 或 Edge Function 部署；不要把 `service_role` key、database password 或 token 印到 log。

## 三 Agent adapter

| Agent | 共用做法 | 專屬設定 |
| :-- | :-- | :-- |
| Codex | 從專案終端機執行官方 CLI；以 `--dry-run` 先審查 | 不新增 MCP、不把 PAT 寫進 `config.toml` |
| Claude Code | 從專案終端機執行相同 CLI 與 migration 檔 | 不新增 connector 或 MCP 作為部署前提 |
| AntiGravity | 從專案終端機執行相同 CLI 與 migration 檔 | 不新增 MCP Store 項目作為部署前提 |

三者共用相同 repo 內的 `supabase/` migration／function 設定；CLI 登入狀態仍是每台電腦、每個 OS 使用者的本機憑證，不能同步或提交。

## 驗收與撤銷

安裝後的最小驗收：

```bash
supabase --version
supabase projects list
```

不再使用時，先在 Supabase Dashboard 的 Account Tokens 撤銷 PAT，再執行：

```bash
supabase logout
brew uninstall supabase
```

如只想移除目前專案的 npm 版本，改用該專案的 package manager 移除 `supabase`；不要手動刪除未知的憑證檔或整個 home directory。

## 官方參考

- [Supabase CLI 安裝與本機開發](https://supabase.com/docs/guides/local-development/cli/getting-started)
- [Supabase CLI 登入與 PAT](https://supabase.com/docs/reference/cli/supabase-login)
- [資料庫 migration 部署](https://supabase.com/docs/guides/deployment/database-migrations)
- [Edge Functions 部署](https://supabase.com/docs/guides/functions/deploy)
- [Scoped Personal Access Tokens](https://supabase.com/docs/guides/platform/personal-access-tokens)
