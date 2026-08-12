# Project Handoff

## Current state

- 三 Agent 共用全域 `clasp-setup` 已精確區分 clasp 3.3.0 的相容 alias
  與真正移除／重整的 v2 語法。
- `create`、`clone`、`deploy`、`deployments`、`list`、`status`、
  `undeploy` 均明列為仍可用 alias；正式 v3 名稱只作推薦路線。
- `login --status` 明列為已移除；`open ...` 與
  `apis enable|disable` 明列為另一組已重整 command shapes。
- LazyPack Item 41、自含式安裝內容、Obsidian 全域 Skills 索引、
  專案駕駛艙與懶人包鏡像均已同步。

## Next action

- 無必要後續。第一次實際處理 Apps Script 專案時，仍先核對 live
  npm `engines`、Google 帳號、`.clasp.json`、Git／備份、
  `.claspignore` 與 `show-file-status --json`，再逐次取得 OAuth、
  push、公開存取與 deployment 授權。

## Blockers

- 無。

## Last verified

- 2026-08-13，Codex App：`@google/clasp` 3.3.0 live `engines` 為
  Node `>=20.0.0`；七個舊名稱的 CLI help 均顯示為 alias，
  `login --status` 回報 `unknown option '--status'`。
- 2026-08-13，Codex App：`clasp-setup` 通過 quick validator、portable
  frontmatter validator 與三 Agent compatibility audit；三個原生入口
  均解析到同一全域主版本。
- 2026-08-13，Codex App：LazyPack Item 41 隔離安裝後與主版本逐檔
  一致，內嵌生成器 SHA-256 重跑不變；repo／Obsidian LazyPack
  `diff -qr`、`git diff --check` 與 secret-pattern scan 均通過。
