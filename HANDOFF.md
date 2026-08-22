# Project Handoff

## Current state

- 全域 skill `visual-prompt-kit` 與 `image-generator` 的實測與規則調整已轉到
  `trivial_matters_of_life` 進行；AntiGravity 在該專案直接把兩項修訂寫回
  `codex_symlink/skills/` 主版本：
  1. `visual-prompt-kit` Phase 2.5 由單輪合併問改為分兩輪依序詢問
     （第一輪風格校準 ➔ 第二輪人物選項確認）。
  2. `image-generator` 新增跨 Agent 模型偏好路由
     （Codex adapter `imagen 2` / AntiGravity adapter `nanobanana 2`）。
- 本次發現主版本修訂未同步回本專案的 LazyPack 內嵌安裝內容，已修復：
  重新執行 `200_Reference/scripts/sync-lazypack-embeds.py`
  （需帶 `SYNC_SKILLS_ROOT` 指向實際 `codex_symlink/skills` 路徑，
  預設路徑計算是錯的），只更動 LazyPack Item 22、43，其餘項目無 diff。
- Obsidian 懶人包鏡像、「全域 Skills 同步.md」、本專案駕駛艙均已補上
  今日同步紀錄；`trivial_matters_of_life/AGENTS.md` 新增固定規則，
  兩個 skill 之後的開發、測試與紀錄統一放在該專案。
- 已 commit 並 push 到 `origin/main`（`de7cbc2`）。

## Next action

- 週 2 系列圖卡、週 3 銷售頁圖版位，待使用者提供該週 prompt 後新增
  `references/placements/` 檔案；`SKILL.md` 不需修改。
- 週 4「組成銷售頁」使用既有 `landing-page`，不另建 skill。
- 之後 `visual-prompt-kit`／`image-generator` 若在 `trivial_matters_of_life`
  再有修訂，本專案只需重跑 `sync-lazypack-embeds.py`（記得帶
  `SYNC_SKILLS_ROOT`）並比對 diff，不必重新設計流程。

## Blockers

- 無。

## Last verified

- 2026-08-22，Claude Code：LazyPack Item 22、43 重新同步，repo 與 Obsidian
  懶人包 `diff -qr` 一致；`git status` 乾淨，已 push。
