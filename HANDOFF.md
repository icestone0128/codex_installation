# Project Handoff

## Current state

- Google Workspace MCP 已從 core read-only 改為可實際操作：wrapper
  `~/.codex/python-tools/bin/google-workspace-mcp-server` 與 LazyPack 主版本
  `200_Reference/lazy-pack/02-assets/google-workspace-mcp/run_google_workspace_mcp.sh`
  同步改為 `--permissions calendar:full drive:full gmail:full --tool-tier complete`。
  LaunchAgent 已重啟並監聽 `127.0.0.1:8000`，工具數由唯讀清單擴為 38 支，
  只載入 calendar／drive／gmail 三服務，未含 Docs／Sheets／Slides。
- OAuth 已由使用者重新完成同意，憑證從 6 個 readonly scope 換成 15 個
  （含 `gmail.send`、`gmail.modify`、`drive`、`calendar`），refresh token 存在，
  仍只存放於 `~/.codex/secrets/google_workspace_mcp_credentials`，權限 600。
- LazyPack Item 02 文件已標明目前設定是使用者明確要求的擴權結果，不是安裝預設；
  新環境仍從 core read-only 起步。Obsidian 懶人包鏡像 `diff -qr` 為 0。
- 全域主檔 `codex_symlink/core-rules.md` 新增「Google 服務接取預設路由
  （MCP 優先於 Connectors）」；Codex、Claude、AntiGravity 三個入口都已驗證讀得到。
  既有 Google 與 Notion connectors 依使用者決定保留，不關閉。
- chezmoi source `~/.local/share/chezmoi` 已建立首個 commit `b6d517c`
  （16 檔／189 行，三 Agent 入口 templates、Python bridge、shell profile
  modify_ scripts），工作樹乾淨。

## Next action

- 使用者將重載 session 以取得 38 支 google-workspace 工具；重載後確認清單含
  `send_gmail_message`、`create_drive_file`、`manage_event` 即為成功。
- 重載前的 session 只有舊的 9 支唯讀工具；若期間需要 Google 寫入操作，
  先向使用者確認是重載還是該次改走 connector，不得自行切換 route。
- chezmoi `update` 目前仍是 `skipped:no-remote`。若要讓新電腦真的能拉取設定，
  需另外建立 remote 並 push；這是選配，必須使用者明確要求。

## Blockers

- 無。

## Last verified

- 2026-08-02，Claude Code Desktop：google-workspace MCP 以新參數啟動並綁定
  8000，`workspace-cli list` 回報 38 tools 且含寫入工具；Calendar 與 Drive
  唯讀 smoke test 通過，未以真實資料測試寫入或寄信。
- 2026-08-02，Claude Code Desktop：OAuth 憑證 15 scopes、refresh token 存在、
  檔案權限 600；repo LazyPack 與 Obsidian 懶人包鏡像 `diff -qr` 為 0；
  `git diff --check` 通過，公開 diff secret-pattern scan 無命中。
- 2026-08-02，Claude Code Desktop：`~/.claude/CLAUDE.md`、`~/.codex/AGENTS.md`、
  `~/.gemini/GEMINI.md` 三個 symlink 均解析到 `codex_symlink/core-rules.md`，
  新規則在三個入口都命中。
