# Project Handoff

## Current state

- `doc-to-md` v1.6.0 已吸收 `doc-vlm-to-md` 安裝包中可攜部分：PDF
  page-adjacent combined Markdown、manifest、UTF-8、防遞迴 router、完成度
  validator 與原子 ZIP 打包；公開 LazyPack Item 18 已重建。內建腳本固定
  使用 `~/.codex/doc-to-md/venv/bin/python3`，不再把通用
  `python-tools-python` 誤當成文件依賴完整的 runtime。
- `codex-skill-creator` 已吸收 Claude Skill Forge 中可攜部分：使用者最新
  修正優先的 correction ledger、Claude 相容 frontmatter hard validation，
  以及只有明確要求時才建立的安全 Claude ZIP；公開 LazyPack Item 11 已重建。
- 兩個全域 Skills、LazyPack 內嵌安裝內容、Obsidian 懶人包鏡像與全域
  Skills 索引均已同步；本次收工將 Item 11、Item 18 與本交接檔發布到
  `origin/main`，不部署。

## Next action

- 沒有必要的後續修復；下次可直接在新對話使用更新後的 `doc-to-md` 或
  `$codex-skill-creator`。
- 未來變更全域 Skill 時，繼續用
  `200_Reference/scripts/sync-lazypack-embeds.py` 重建對應 LazyPack，並實際
  比對 Obsidian 鏡像與三 Agent 原生入口。
- Claude ZIP 只在使用者明確要求 Customize／API 上傳成品時建立；共用
  Skill 主版本仍固定放在 `codex_symlink/skills`。

## Blockers

- 無。

## Last verified

- 2026-08-01，Codex App：`doc-to-md` 使用專用 runtime 的 5 個公開契約
  測試通過；Item 18 隔離安裝 17 個檔案與主版本一致，內建與 portable
  validation、三 Agent audit 均通過。
- 2026-08-01，Codex App：`codex-skill-creator` 內建／portable validator、
  ZIP 正負向測試與獨立 forward-test 通過；Item 11 隔離安裝 7/7 一致，
  compatibility audit 為 0 findings。
- 2026-08-01，Codex App：repo LazyPack 與 Obsidian 懶人包鏡像
  `diff -qr` 為 0；內嵌同步 idempotent，`git diff --check` 與公開 diff
  secret-pattern scan 通過。
