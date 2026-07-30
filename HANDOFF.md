# Project Handoff

## Current state

- `mattpocock/skills` 的 41 個來源項目已完成盤點：22 個穩定
  engineering／productivity skills 已適配為三 Agent 共用套件，其餘
  19 個 deprecated／in-progress／misc／personal 項目只在 manifest
  追蹤。
- 全域主版本新增 `engineering-methods`、`setup-engineering-methods`、
  `grill-me` 等 22 個 packages；`engineering-methods` 內建只讀上游
  SHA checker、完整 manifest、更新流程與 suite verifier。
- LazyPack Item 40 完整內嵌 22 個 packages；Item 11 已接入
  `writing-great-skills` 方法論。Repo LazyPack、Obsidian 懶人包鏡像與
  全域 Skills 索引一致。
- 公開發布 commit `774d00b feat: add engineering methods skill suite`
  已推送至 `origin/main`。

## Next action

- 日常使用從 `$engineering-methods` 選流程，或直接呼叫
  `$grill-me`、`$to-spec`、`$to-tickets`、`$implement` 等成員。
- 未來先執行
  `engineering-methods/scripts/check_upstream.py`；只有上游 SHA 改變時，
  才依 `references/update-workflow.md` 重新分類、適配、重建 Item 40、
  同步 Obsidian 並做隔離安裝。

## Blockers

- 無。

## Last verified

- 2026-07-30，Codex App：23 個受影響 skills 通過 quick validation；
  suite verifier 22／22、0 findings；上游 baseline SHA 仍為 current。
- 2026-07-30，Codex App：跨 Agent audit 掃描 615 個檔案、0 findings；
  Item 40 在隔離 `SYNC_ROOT` 真實安裝 22／22。
- 2026-07-30，Codex App：LazyPack／Obsidian `diff -qr` 為 0；
  `sync-health.sh` 為 0 failures、1 個預期未提交變更 warning。
- 2026-07-30，Codex App：`origin/main` 已包含 `774d00b`。
