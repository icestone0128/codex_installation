# 02-Codex-MCP-Essentials

> 2026-06-01 更新：Heptabase CLI Skill 已依 `heptameta/heptabase-cli-skills` v1.4.0 重新同步，維持 `0.4.x` 相容，並補齊 property、PDF、file、transcript 與 Codex sandbox references。


## 目標

把 來源工具 CLI 取向的 MCP 安裝概念，改成適合 Codex App 的 MCP / plugin 設定方式。

## 前置條件

- 已安裝 Codex App。
- 已決定 `{{CODEX_CONFIG}}`。
- 已安裝 Node.js / npm。
- 需要 Firecrawl 時，準備 `{{CODEX_HOME}}/secrets/firecrawl_api_key`，權限設為 `600`。
- 需要 Filesystem MCP 時，先決定最小授權資料夾。

## Codex App 與 來源工具 CLI 差異

來源工具 CLI 常用 `來源工具 mcp add ...` 或 來源工具 MCP 設定檔。

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
command = "sh"
args = ["-lc", "NPM_CONFIG_CACHE=/private/tmp/npm-cache FIRECRAWL_API_KEY=$(cat {{CODEX_HOME}}/secrets/firecrawl_api_key) npx -y firecrawl-mcp"]
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
- Heptabase desktop app 的 local CLI server 已啟用；如果 read-only 指令回報無法連線，先執行 `heptabase start` 或在桌面 app 的 Settings > AI Features 啟用 CLI。
- 實際操作前先用 read-only 指令確認連線，不直接寫入。

安裝方式請使用本文文末「內建 Skill 完整安裝內容」；本項會同步安裝 `SKILL.md` 與 `references/`。

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

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `~/.codex`。

```bash
set -e

# ---- heptabase-cli ----
mkdir -p "{{CODEX_HOME}}/skills/heptabase-cli"
# heptabase-cli/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/heptabase-cli/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/heptabase-cli/SKILL.md" <<'CODEX_LAZYPACK_HEPTABASE_CLI_SKILL_MD'
---
name: heptabase-cli
description: Interact with Heptabase using the CLI to manage knowledge base content, search cards, edit properties, read parsed PDF and media transcript content, export local files, manage whiteboard cards, and browse AI Tutor goals, courses, and lessons.
allowed-tools: Bash(heptabase *) Bash(jq *) Bash(mktemp *)
metadata:
  heptabase-cli-version-range: "0.4.x"
---

## Prerequisites

- CLI installed from the desktop app. The command is `heptabase` on macOS/Linux; Windows installs `heptabase.cmd` for cmd/PowerShell and a `heptabase` shim for POSIX shells.
- Check version compatibility before use with `heptabase --version`. If the installed CLI version is outside this skill's compatibility range (`0.4.x`), you MUST stop and ask the user to update either the Heptabase desktop app or this skill package before continuing.

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
CODEX_LAZYPACK_HEPTABASE_CLI_SKILL_MD

# heptabase-cli/references/codex-sandbox.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/heptabase-cli/references/codex-sandbox.md")"
cat > "{{CODEX_HOME}}/skills/heptabase-cli/references/codex-sandbox.md" <<'CODEX_LAZYPACK_HEPTABASE_CLI_REFERENCES_CODEX_SANDBOX_MD'
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
CODEX_LAZYPACK_HEPTABASE_CLI_REFERENCES_CODEX_SANDBOX_MD

# heptabase-cli/references/file-reading.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/heptabase-cli/references/file-reading.md")"
cat > "{{CODEX_HOME}}/skills/heptabase-cli/references/file-reading.md" <<'CODEX_LAZYPACK_HEPTABASE_CLI_REFERENCES_FILE_READING_MD'
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
CODEX_LAZYPACK_HEPTABASE_CLI_REFERENCES_FILE_READING_MD

# heptabase-cli/references/pdf-reading.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/heptabase-cli/references/pdf-reading.md")"
cat > "{{CODEX_HOME}}/skills/heptabase-cli/references/pdf-reading.md" <<'CODEX_LAZYPACK_HEPTABASE_CLI_REFERENCES_PDF_READING_MD'
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
CODEX_LAZYPACK_HEPTABASE_CLI_REFERENCES_PDF_READING_MD

# heptabase-cli/references/property-values.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/heptabase-cli/references/property-values.md")"
cat > "{{CODEX_HOME}}/skills/heptabase-cli/references/property-values.md" <<'CODEX_LAZYPACK_HEPTABASE_CLI_REFERENCES_PROPERTY_VALUES_MD'
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
CODEX_LAZYPACK_HEPTABASE_CLI_REFERENCES_PROPERTY_VALUES_MD

# heptabase-cli/references/transcript-reading.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/heptabase-cli/references/transcript-reading.md")"
cat > "{{CODEX_HOME}}/skills/heptabase-cli/references/transcript-reading.md" <<'CODEX_LAZYPACK_HEPTABASE_CLI_REFERENCES_TRANSCRIPT_READING_MD'
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
CODEX_LAZYPACK_HEPTABASE_CLI_REFERENCES_TRANSCRIPT_READING_MD

test -f "{{CODEX_HOME}}/skills/heptabase-cli/SKILL.md" && echo "heptabase-cli installed"
test -f "{{CODEX_HOME}}/skills/heptabase-cli/references/codex-sandbox.md" && echo "heptabase-cli references installed"

echo "embedded skills installed: heptabase-cli"
```

<!-- END EMBEDDED_SKILLS -->
