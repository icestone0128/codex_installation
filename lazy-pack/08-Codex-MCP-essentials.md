# 08-Codex MCP Essentials

## 目標

把 `04-mcp-essentials.md` 的 Claude Code CLI 安裝概念，改成適合 Codex App 的 MCP / plugin 設定方式。

本次實測補齊：

- Firecrawl MCP
- Filesystem MCP
- Playwright MCP
- Google Drive plugin

## Codex App 與 Claude Code CLI 差異

原文件多數指令使用 `claude mcp add ...` 或 `~/.claude.json`，這是 Claude Code CLI 的設定方式。

Codex App 這裡使用：

```toml
/Users/arrywu/.codex/config.toml
```

新增或修改 MCP server 後，通常要重啟 Codex App 或開新對話才會載入。

## 實測設定

### Firecrawl MCP

用途：抓取公開網頁、轉成乾淨文字或 Markdown，適合摘要文章、整理網頁資料。

Codex 設定位置：

```toml
[mcp_servers.firecrawl]
command = "env"
args = ["NPM_CONFIG_CACHE=/private/tmp/npm-cache", "FIRECRAWL_API_KEY=fc-***", "npx", "-y", "firecrawl-mcp"]
startup_timeout_sec = 30
tool_timeout_sec = 120
```

注意：

- API key 不可寫入 repo。
- 若 key 外洩，到 Firecrawl dashboard 旋轉或重建。
- 本次用 `https://example.com` 做 scrape 測試，回傳 HTTP 200，消耗 1 credit。

### Filesystem MCP

用途：讓 Codex 可透過 MCP 存取工作區外的指定資料夾。

本機只授權：

```text
/Users/arrywu/Documents
```

Codex 設定：

```toml
[mcp_servers.filesystem]
command = "env"
args = ["NPM_CONFIG_CACHE=/private/tmp/npm-cache", "npx", "-y", "@modelcontextprotocol/server-filesystem", "/Users/arrywu/Documents"]
startup_timeout_sec = 30
tool_timeout_sec = 120
```

注意：

- 不要一次授權 Desktop、Downloads、整個 Google Drive。
- Filesystem MCP 應採最小權限，只開實際需要的資料夾。
- 本次 server 啟動測試成功，顯示 `Secure MCP Filesystem Server running on stdio`。

### Playwright MCP

用途：讓 Codex 具備瀏覽器自動化能力，適合操作網頁、截圖、測試互動流程。

Codex 設定：

```toml
[mcp_servers.playwright]
command = "env"
args = ["NPM_CONFIG_CACHE=/private/tmp/npm-cache", "npx", "-y", "@playwright/mcp"]
startup_timeout_sec = 30
tool_timeout_sec = 120
```

已下載瀏覽器元件：

- Chromium
- Chromium headless shell
- FFmpeg

本次測試：

- `@playwright/mcp` 版本：`0.0.75`
- 實際開啟 `https://example.com` 並截圖成功。

### Google Drive plugin

用途：在 Codex App 中處理 Google Drive、Docs、Sheets、Slides。

這裡不使用原文件的 Google Workspace CLI (`gws`) 路線，原因：

- `gws` 需要額外 Google Cloud Project 與 OAuth 設定。
- Codex App 已有 Google Drive plugin，可直接提供 Drive / Docs / Sheets / Slides 工具。
- Gmail 與 Google Calendar 已分別透過 Codex App plugin 使用。

## 踩坑修正

### npm cache 權限問題

症狀：

```text
npm error Your cache folder contains root-owned files
```

修正：

MCP 設定裡用暫存 npm cache：

```toml
command = "env"
args = ["NPM_CONFIG_CACHE=/private/tmp/npm-cache", "npx", ...]
```

避免去改 `~/.npm` 權限，也避免使用 `sudo`。

### Playwright 下載瀏覽器被沙箱擋住

症狀：

```text
EPERM: operation not permitted, mkdir '/Users/arrywu/Library/Caches/ms-playwright'
```

修正：

Playwright 瀏覽器元件需要寫入使用者快取資料夾，若 Codex 沙箱擋住，需使用核准權限執行一次下載。

### Playwright Chromium 啟動被 macOS 權限擋住

症狀：

```text
MachPortRendezvousServer ... Permission denied
```

修正：

實際瀏覽器啟動測試需要核准較高權限。核准後，Playwright 可成功開啟 `https://example.com` 並產生截圖。

### Filesystem MCP 授權範圍不能太大

一次授權 Desktop、Documents、Downloads、整個 Google Drive 會造成過大的安全範圍。

本機採用最小權限：

```text
/Users/arrywu/Documents
```

若未來需要讀取其他資料夾，應由使用者明確指定單一路徑後再追加。

### Firecrawl key 不能進 Git

Firecrawl API key 是密鑰，不能寫入 repo、Obsidian 公開筆記或 README。

可以在設定範例中遮蔽：

```text
FIRECRAWL_API_KEY=fc-***
```

## 待確認

- 重啟 Codex App 或開新對話後，確認 Firecrawl / Filesystem / Playwright 是否出現在實際可呼叫工具清單。
- Firecrawl 免費額度會被測試消耗，測試公開網頁即可，不要對大量 URL 做壓力測試。
