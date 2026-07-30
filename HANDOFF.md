# Project Handoff

## Current state

- Google Workspace MCP 已採 Claude-first 路線完成安裝；Codex 保留原生
  Google Drive、Gmail、Calendar plugins，避免同義工具重複。
- 本機固定使用 `workspace-mcp==1.22.2`、共用 Python runtime、
  loopback HTTP endpoint 與 macOS LaunchAgent。
- 公開 LazyPack Item 02 已包含完整安裝文件、runner、installer 與
  LaunchAgent template；Obsidian 懶人包鏡像已同步。
- 預設工具契約只啟用 Drive／Gmail／Calendar core read-only，OAuth
  client 與 token 只保存在本機 secrets 目錄，不進 repo 或 Obsidian。

## Next action

- 日常 Claude 任務直接使用 `google-workspace` MCP；Codex 繼續使用官方
  Google plugins。
- 更新 `workspace-mcp` 前先審查版本、重跑 Item 02 installer、確認 9 個
  唯讀工具與三服務 smoke test，再同步 LazyPack／Obsidian。
- 若 callback 顯示 OAuth state 過期，重新觸發任一唯讀工具取得新 URL，
  不需重建 OAuth client。

## Blockers

- 無。

## Last verified

- 2026-07-30，Codex App：MCP handshake、Claude adapter、loopback
  listener、LaunchAgent 與 read-only 工具契約通過。
- 2026-07-30，Codex App：Calendar、Drive、Gmail 三項真實唯讀 smoke
  test 通過；OAuth token 檔案權限為 `600`。
- 2026-07-30，Codex App：macOS 實機重裝與 Linux／WSL 隔離安裝通過；
  Bash／plist、公開路徑、secret pattern 與 `git diff --check` 通過。
- 2026-07-30，Codex App：repo LazyPack 與 Obsidian 懶人包鏡像
  `diff -qr` 為 0。
