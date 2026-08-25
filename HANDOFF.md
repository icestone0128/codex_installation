# Project Handoff

## Current state

- 依課程 Pro-Kit 01「AI 分身起始助手」完成**整合**（非重跑）。唯讀盤點確認本機
  既有架構已等同該文件設計，文件中的「重指 `~/.claude/skills`」與「另建
  `~/Agent/my-agent/`」已明確排除、未執行；82 個 skills 與四條 symlink 入口未動。
- 主版本變更全在 `codex_symlink/`（非本 repo）：
  1. 新建 `knowledge/REPOS.md`——15 個 `agentic_projects` repo 路徑索引。含本機
     絕對路徑，只留私有 `codex_symlink`，**不進 public repo**。
  2. `knowledge/verification-checklist.md` 新增 Phase 0 工具可用性查證。
  3. `skills/arry-assistant/SKILL.md` 新增自我進化觸發條件 7 條。
  4. `core-rules.md` 重疊清理 378 → 363 行；備份
     `codex_symlink/backups/core-rules.md.bak.20260825-221658`。
  5. `core-rules.md` 新增 `## 對話與輸出語言`。
- 未採用：`memories/daily/`、`300_Journal/`（皆與既有機制重疊）。
- 本 repo 側：重跑 `200_Reference/scripts/sync-lazypack-embeds.py`
  （**必須帶 `SYNC_SKILLS_ROOT` 指向實際 `codex_symlink/skills`，預設路徑計算是錯的**）
  後只有 Item 09、43 有 diff。Item 09 是本次 `arry-assistant` 變更（+18 行）；
  Item 43 是 `visual-prompt-kit` 主版本 08-24／08-25 在 `trivial_matters_of_life`
  更新後未回同步造成的靜默過期（+953/-28）。
- 補做（使用者指出 Pro-Kit 訪談不該整套跳過）：
  - `arry-assistant` 新增〈首次啟用訪談〉——第三方經 LazyPack Item 09 安裝時，
    助手會先訪談再建資料層；含環境題（可自行查證就不問）與 5 題無法查證的人題。
    這是 Item 09 原本的缺口：會建資料層、但不會問使用者是誰。
  - `arry-assistant` 使用流程第 5 條升級為收工必跑 LazyPack 同步檢查（靜默過期第 2 次觸發，
    由今日新增的自我進化規則第 2 條提報、經使用者同意後升級）。
  - `memories/MEMORY.md` 最上方新增〈協作偏好〉區塊（含 START/END 標記），內容為本次
    訪談所得的個人協作偏好欄位。**實際答案只存在私有 `codex_symlink`，不寫入本 repo。**
    備份 `codex_symlink/backups/MEMORY.md.bak.*`。
    **風險**：MEMORY.md 由 rollout 機制自動追加，若未來有工具改為整檔重寫，本區塊可能被清掉；
    下次開工確認區塊仍在。
- Obsidian 側已全部收斂：懶人包鏡像、「全域 Skills 同步.md」、專案駕駛艙、
  Arry 助手鏡像皆已更新並驗證。

- Pro-Kit 03「寫出好 Skill」啟動包同樣以整合處理，**不另裝 `create-good-skills`**
  （會與「建立 skill 一律先用 `codex-skill-creator`」的全域規則衝突）。7 項缺口整合進
  `codex-skill-creator`：baseline-first、雙測試 Harness（含事前保留樣本）、方法來源路線
  分流（自己／身邊高手／團隊 SOP／公開專家）、模仿真人的誠實邊界（原本完全沒有的防線）、
  SKILL.md 八段 body、追問上限 4 題、`version: 0.1.0`。SKILL.md 202 → 287 行，
  Workflow 12 → 13 步。備份 `codex_symlink/backups/codex-skill-creator.SKILL.md.bak.*`。
- LazyPack Item 11 的**說明文字也一併改寫**，不只重新內嵌 skill；第三方照該文件安裝會得到
  與主版本一致的流程。內嵌 SKILL.md 與主版本 `diff` IDENTICAL。

## Next action

- LazyPack Item 11 待 commit／push 到 `origin/main`（Item 09、22、43 已於 `3555db9` 送出）。
- `OUTPUT_CHANNELS` 未單獨訪談（受一次 4 題上限限制），目前在〈協作偏好〉標為推論待確認；
  下次可補問一題確定最常交付的成果型態。
- 未來全域 skill 在其他專案（尤其 `trivial_matters_of_life`）被修改後，本專案
  LazyPack 會靜默過期。開工或收工時固定重跑 `sync-lazypack-embeds.py` 並看 diff，
  不要只憑 HANDOFF 記載判斷已同步。
- `chezmoi status` 有既有 `MM .zshenv` drift，與本次無關；依 Item 16 規則未對既有
  受管理模板執行 `chezmoi add`，待使用者決定是否處理。

## Blockers

- 無。

## Last verified

- 2026-08-25，Claude Code：安全掃描 key/token/絕對路徑命中 0；外部個人風格庫
  `card-style-library/` 僅以佔位符引用、實際內容未內嵌；repo LazyPack 與 Obsidian
  懶人包 `diff -qr` 一致；Arry 助手鏡像 `diff -qr` 通過；chezmoi shutdown checkpoint
  9 條 symlink 全 OK、`CHEZMOI_ADD=not-needed-for-existing-templates`；三個 Agent
  全域規則入口實測仍正常解析 `core-rules.md`。
