# 02-Codex-MCP-Essentials

> 2026-05-31 更新：Heptabase CLI Skill 已更新為 `0.4.x` 相容，支援 tag/card properties、PDF parsed content、audio/video transcript 與 local file export 讀取流程。


## 目標

把 來源工具 CLI 取向的 MCP 安裝概念，改成適合 Codex App 的 MCP / plugin 設定方式。

## 前置條件

- 已安裝 Codex App。
- 已決定 `{{CODEX_CONFIG}}`。
- 已安裝 Node.js / npm。
- 需要 Firecrawl 時，準備 `{{FIRECRAWL_API_KEY}}`。
- 需要 Filesystem MCP 時，先決定最小授權資料夾。

## Codex App 與 來源工具 CLI 差異

來源工具 CLI 常用 `claude mcp add ...` 或 來源工具 MCP 設定檔。

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

用途：讓 Codex 透過 Heptabase CLI 管理 note、journal、tag、card、whiteboard 與 AI Tutor 內容。

這一項歸在 02，因為它是外部工具 / CLI 連線能力，不放在 01 的基礎 plugin 檢查裡。使用前請確認：

- 已安裝 Heptabase desktop app。
- Heptabase CLI 可用，並符合 skill 相容版本 `0.4.x`。
- 實際操作前先用 read-only 指令確認連線，不直接寫入。

安裝方式請使用本文文末「內建 Skill 完整安裝內容」。

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
5. Browser plugin：開啟 `https://example.com` 並截圖。
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

## 設定範例

本機曾成功測試：

- Firecrawl 抓 `https://example.com`。
- Filesystem MCP 授權單一路徑。
- Codex Browser plugin 開啟 `https://example.com` 並截圖。

下載者要用自己的 API key 與授權資料夾。

## 踩坑修正

- Codex App 已有 Browser plugin 時，瀏覽器自動化優先使用 plugin。
- Filesystem MCP 授權範圍不能太大，否則安全風險高。
- Firecrawl key 不能進 Git、Obsidian 公開筆記或 README。
- 重啟 Codex App 或開新對話後，再確認 MCP 是否出現在實際可呼叫工具清單。


<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節會安裝：`heptabase-cli`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{CODEX_HOME}}`。

```bash
set -e

# ---- heptabase-cli ----
mkdir -p "{{CODEX_HOME}}/skills/heptabase-cli"
# heptabase-cli/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/heptabase-cli/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/heptabase-cli/SKILL.md" <<'CODEX_LAZYPACK_HEPTABASE_CLI_SKILL_MD'
---
name: heptabase-cli
description: Interact with Heptabase using the CLI to create, read, and edit notes, journals, tags, cards, list whiteboards and manage cards on whiteboards, and browse AI Tutor goals, courses, and lessons. Use when the user asks to manage their Heptabase knowledge base, search cards, work with journals, tags, or whiteboards, or read AI Tutor content.
metadata:
  heptabase-cli-version-range: "0.4.x"
---

## Prerequisites

- CLI installed from the desktop app. The command is `heptabase` on macOS/Linux; Windows installs `heptabase.cmd` for cmd/PowerShell and a `heptabase` shim for POSIX shells.
- Check version compatibility before use with `heptabase --version`. If the installed CLI version is outside this skill's compatibility range (`0.4.x`), you MUST stop and ask the user to update either the Heptabase desktop app or this skill package before continuing.

## 使用流程

1. Confirm the task type: read/search, create/update, journal work, tag work, whiteboard card management, or AI Tutor browsing.
2. Check CLI availability and version with `heptabase --version`. Continue only when the installed version is compatible with `0.4.x`.
3. Make sure the Heptabase desktop app and local CLI server are running. If commands fail because the app is closed, run `heptabase start` and retry the low-risk read command.
4. For unfamiliar commands or flags, run `heptabase help` or `<command> --help` before guessing syntax.
5. Execute the smallest command that satisfies the request. Prefer read-only commands before mutations when identifying cards, notes, tags, or whiteboards.
6. Parse JSON output directly, using `jq` only when it helps inspect or filter results.
7. For write operations, confirm the target object and requested change before mutating data unless the user has already specified both clearly.
8. If the CLI does not support the requested operation, stop and report the limitation instead of using Heptabase local files, app storage, cache, internal endpoints, or other non-CLI access paths.

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
- **List cards on a whiteboard:** `heptabase whiteboard cards <whiteboardId>`
- **Add a card to a whiteboard:** `heptabase whiteboard add-card --whiteboard-id <whiteboardId> --card-id <cardIdOrDate>`
- **List tag database columns:** `heptabase tag properties <tagId>`
- **List cards under a tag with property values:** `heptabase tag cards <tagId> --include-properties`
- **Read all structured properties on a card:** `heptabase card properties <cardIdOrDate>`
- **Set one card property:** `heptabase card set-property <cardIdOrDate> --property-id <propertyId> --value "<value>"`
- **Read PDF card metadata:** `heptabase pdf metadata <pdfCardId>`
- **Read PDF pages:** `heptabase pdf read --start-page 1 --end-page 3 <pdfCardId>`
- **Read audio transcript metadata:** `heptabase audio metadata <audioCardId>`
- **Read audio transcript range:** `heptabase audio read --start-seconds 0 --end-seconds 120 <audioCardId>`
- **Read video transcript metadata:** `heptabase video metadata <videoCardId>`
- **Read video transcript range:** `heptabase video read --start-seconds 0 --end-seconds 120 <videoCardId>`
- **List exportable files on a card:** `heptabase file list <cardId>`
- **Export a local Heptabase file:** `heptabase file export --output-dir <outputDir> <fileId>`

## Tag Database Properties

Heptabase CLI v0.3.0+ adds read access to tag database schemas and read/write access to per-card property values.

Use this flow for structured data tasks:

1. Ask the user which existing tag database to use, or identify it with `heptabase tag list`.
2. Read property columns first with `heptabase tag properties <tagId>`.
3. Read card property values before writing:
   - `heptabase card properties <cardIdOrDate>`
   - or `heptabase tag cards <tagId> --include-properties`
4. For writes, set one property value at a time with `heptabase card set-property`.
5. For arrays, objects, booleans, numbers, or null, use the command's `--json-value` option after checking `heptabase card set-property --help`.

Do not create, rename, or delete tag database columns through the CLI unless the command help explicitly supports it. If a select or multi-select option does not exist, ask the user to create it in the Heptabase desktop app before setting that value.

## PDF, Audio, Video, And Files

Heptabase CLI v0.4.0 adds read access for parsed PDF card content, audio transcripts, video transcripts, and exportable local files referenced by supported cards.

Use this flow for PDF/media tasks:

1. Identify the target card or file ID from the user's request, search results, or `heptabase file list <cardId>`.
2. Read metadata first with `heptabase pdf metadata`, `heptabase audio metadata`, or `heptabase video metadata`.
3. Read small page or time ranges first before expanding the range.
4. Export files only with `heptabase file export`; do not inspect Heptabase app storage directly.
5. If parsed content or export is unavailable for a card type, report the CLI limitation instead of trying non-CLI access paths.

## All output is JSON

Every command prints JSON to stdout. You can parse it with `jq` or pipe it to other tools.

## Troubleshooting

- **Desktop app must be running.** The CLI communicates with a local server inside the app. If the app is closed, all commands fail. Run `heptabase start` to launch and wait for readiness.
- **Mutations are serialized.** Write operations (create, save, append, trash, restore, tag add/remove, whiteboard add-card/remove-card) run one at a time to prevent conflicts. Reads are concurrent.
- **Request body size limit.** The server rejects request bodies larger than 1 MB.
- **Request timeout.** The server times out requests that take longer than 10 seconds to send their body.

## Known limitations

- **Auto-enabling local server/CLI install not supported.** If the local CLI server is disabled or CLI wiring is missing, the skill cannot repair it by itself; ask the user to enable Local CLI Server and CLI install from desktop settings first.
- **Binary/media upload workflows not supported.** This skill can read supported PDF/media parsed content and export supported local files, but it does not upload files or run media-processing APIs.
- **Tag database schema editing is not supported through this workflow.** You can read property columns and set card values, but schema design such as creating columns, renaming columns, deleting columns, or adding select options should be done in the Heptabase desktop app unless current CLI help explicitly says otherwise.
- **Whiteboard creation/edit/delete not supported yet.** You can list whiteboards and add, list, or remove cards on them, but you can't create, rename, move, or delete whiteboards.
- **Unsupported card files may return empty file lists.** `heptabase file list` currently returns exportable files for PDF/media cards and an empty files array for unsupported card types.

## Warnings

- **Use the CLI as the only data access path.** Never directly read, write, or modify Heptabase app data through local database files, app storage, cache files, internal endpoints, or any other non-CLI mechanism. If the CLI does not support the requested operation, stop and report that it is not supported.
CODEX_LAZYPACK_HEPTABASE_CLI_SKILL_MD

test -f "{{CODEX_HOME}}/skills/heptabase-cli/SKILL.md" && echo "heptabase-cli installed"

echo "embedded skills installed: heptabase-cli"
```

<!-- END EMBEDDED_SKILLS -->
