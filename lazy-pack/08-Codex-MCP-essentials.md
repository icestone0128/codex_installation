# 08-Codex MCP Essentials

## 目標

把 Claude Code CLI 取向的 MCP 安裝概念，改成適合 Codex App 的 MCP / plugin 設定方式。

## 前置條件

- 已安裝 Codex App。
- 已決定 `{{CODEX_CONFIG}}`。
- 已安裝 Node.js / npm。
- 需要 Firecrawl 時，準備 `{{FIRECRAWL_API_KEY}}`。
- 需要 Filesystem MCP 時，先決定最小授權資料夾。

## Codex App 與 Claude Code CLI 差異

Claude Code CLI 常用 `claude mcp add ...` 或 `~/.claude.json`。

Codex App 使用：

```text
{{CODEX_CONFIG}}
```

新增或修改 MCP server 後，通常要重啟 Codex App 或開新對話才會載入。

## Firecrawl MCP

用途：抓取公開網頁、轉成乾淨文字或 Markdown，適合摘要文章、整理網頁資料。

在 `{{CODEX_CONFIG}}` 加入：

```toml
[mcp_servers.firecrawl]
command = "env"
args = ["NPM_CONFIG_CACHE=/private/tmp/npm-cache", "FIRECRAWL_API_KEY={{FIRECRAWL_API_KEY}}", "npx", "-y", "firecrawl-mcp"]
startup_timeout_sec = 30
tool_timeout_sec = 120
```

安全規則：

- API key 不可寫入 repo。
- 文件只能寫遮蔽範例，例如 `fc-***`。
- 若 key 外洩，到 Firecrawl dashboard 旋轉或重建。

驗證：

- 用公開測試頁，例如 `https://example.com`。
- 不要用大量 URL 做壓力測試。

## Filesystem MCP

用途：讓 Codex 透過 MCP 存取工作區外的指定資料夾。

先選最小授權範圍，例如：

```text
{{FILESYSTEM_ALLOWED_DIR}}
```

範例：

```text
/Users/alex/Documents
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

## Playwright MCP

用途：讓 Codex 具備瀏覽器自動化能力，適合操作網頁、截圖、測試互動流程。

在 `{{CODEX_CONFIG}}` 加入：

```toml
[mcp_servers.playwright]
command = "env"
args = ["NPM_CONFIG_CACHE=/private/tmp/npm-cache", "npx", "-y", "@playwright/mcp"]
startup_timeout_sec = 30
tool_timeout_sec = 120
```

首次使用可能需要下載瀏覽器元件。若被沙箱或 macOS 權限擋住，依 Codex 提示核准一次。

驗證：

- 開啟 `https://example.com`。
- 截圖。
- 確認畫面不是空白。

## Google Drive / Gmail / Calendar

Codex App 有對應 plugins / connectors 時，優先使用 plugin，不必走舊的 Google Workspace CLI (`gws`) 路線。

建議：

- Drive / Docs / Sheets / Slides：Google Drive plugin。
- Gmail：Gmail plugin。
- Calendar：Google Calendar plugin。

## 驗證

改完 `{{CODEX_CONFIG}}` 後：

1. 重啟 Codex App 或開新對話。
2. 請 Codex 回報目前可用 MCP / plugin 工具。
3. Firecrawl：抓取 `https://example.com`。
4. Filesystem：列出 `{{FILESYSTEM_ALLOWED_DIR}}` 內的一個測試資料夾。
5. Playwright：開啟 `https://example.com` 並截圖。
6. Google Drive / Gmail / Calendar：各查一個不敏感的測試項目。

若任何一項失敗，先檢查 command 絕對路徑、API key、登入狀態與 Codex 是否已重啟。

## npm cache 權限修正

症狀：

```text
npm error Your cache folder contains root-owned files
```

修正：MCP 設定裡用暫存 npm cache。

```toml
command = "env"
args = ["NPM_CONFIG_CACHE=/private/tmp/npm-cache", "npx", ...]
```

避免去改 `~/.npm` 權限，也避免使用 `sudo`。

## 本機實測例

本機曾成功測試：

- Firecrawl 抓 `https://example.com`。
- Filesystem MCP 授權單一路徑。
- Playwright MCP 開啟 `https://example.com` 並截圖。

下載者要用自己的 API key 與授權資料夾。

## 踩坑修正

- Playwright 下載瀏覽器元件可能需要寫入使用者快取資料夾；若 Codex 沙箱擋住，需核准權限。
- Playwright Chromium 啟動可能被 macOS 權限擋住；實際瀏覽器測試可能需要較高權限。
- Filesystem MCP 授權範圍不能太大，否則安全風險高。
- Firecrawl key 不能進 Git、Obsidian 公開筆記或 README。
- 重啟 Codex App 或開新對話後，再確認 MCP 是否出現在實際可呼叫工具清單。
