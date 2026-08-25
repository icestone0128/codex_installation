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

- Pro-Kit 04 同樣不裝 skill（其 FAQ 自陳沒有 `first-personal-skill` 要裝）。上一輪整合 03 時
  已覆蓋大半，本輪只補 4 項進 `codex-skill-creator`：熟練度優先於頻率的第一個 skill 篩選、
  勸退清單（一次性／高風險無覆核／承諾價格合約付款人事／無法驗收／素材不安全）、
  Skill brief 作為建檔前確認產物且兩題測試在此設計、回溯式訪談與去識別化確認項。
  顧問流程抽到 `references/first-skill-consultation.md`；勸退條件壓縮版留在 SKILL.md
  §Ownership Decision，因為它適用所有建 skill 情境，不能只放在單一分支的 reference 裡。
  SKILL.md 287 → 307 行，套件 7 → 8 檔。
- 修正既有錯誤：LazyPack Item 11 的建立流程原本把 baseline 排在「收斂成一個推薦 skill」之前，
  但 baseline 必須跑在已選定的任務上。已重排為 訪談 → 收斂 → brief → baseline → 建檔 →
  驗證 → 同步，並修好重排後失效的步驟交叉引用。

- Pro-Kit 05 整合：其 `create-good-skills` 分支已於 03 完成，另一條 `personal-style-loop`
  是本機完全沒有的能力。發現**三處指向同一個不存在的寫作風格能力**：
  `codex-skill-creator:115`（本人稍早寫入）、`speak-human-tw` description，以及
  `arry-assistant` 與協作偏好路由表的「動筆前先讀 `writing-samples/`」——
  但 15 個專案的 `writing-samples/` 全部只有 `.gitkeep`。
- 依 `codex-skill-creator` 完整流程建立全域 skill `personal-style-loop`（3 檔），
  並新增 LazyPack **Item 44**、註冊進 `sync-lazypack-embeds.py`、補 README 目錄與安裝總表。
  全域 skill 數 82 → 83。
- **修正稍早造成的缺陷**：`codex-skill-creator` 的 `version`／`last-updated` 規則沿用
  Pro-Kit 03 模板寫成頂層 frontmatter，但 `quick_validate.py` 只接受 `name`／`description`／
  `license`／`allowed-tools`／`metadata`，會讓每個新 skill 產生無效 frontmatter。
  已改為要求寫在 `metadata:` 內並加進驗證清單。
- `speak-human-tw` 的懸空指向**刻意不動**：它是 MIT 上游治理 skill，改 description 會與上游分岔。

- 補做：05 的分流樹與所有情境式提問同步進 LazyPack。複查發現前一輪寫得不夠——
  `personal-style-loop` 的分支選項沒列出、`codex-skill-creator` 路線 C 漏了資深同事覆核、
  路線 D 漏了三題分工，兩者都沒有最上層的入口分流問題。已全部補上，
  並在 Item 11 與 44 的**說明文字**中寫出完整提問樹（第三方讀的是這段，不是內嵌 skill）。
  `personal-style-loop` 140 → 197 行、`codex-skill-creator` 307 → 333 行。

- 索引計數修正：先前「82 個 skills」把 `README.md` 算進去了。正確為實際 skill **82 個**
  （必裝共享 2 ＋ 自訂全域 80）。Obsidian 索引表格補上 `personal-style-loop` 並寫入計數口徑。
- Pro-Kit 02 以**判斷層 ＋ 窄 deny** 整合，不建 skill、不裝 hook：
  - 第一層 `rm` → 垃圾桶 alias **確認不整合**（只保護終端機手動輸入，使用者不用終端機）。
  - 判斷層改 3 個既有檔案：`core-rules.md` 新增〈不可逆操作邊界〉四級分類並修正
    「不可逆動作先確認」原本被埋在 Google MCP 章節、只對 Google 生效的問題；
    `knowledge/prompt-defense-baseline.md §4` 擴充為分級細則並新增 §4.2 說明判斷層的侷限；
    `arry-assistant` 使用流程加入指向。
  - 攔截層寫入 `~/.claude/settings.json` 的 11 條 `permissions.deny`，每條先實測誤擋風險。
    `rm -rf` **刻意不納入**——11 個安裝腳本在用，無差別擋會弄壞它們。
  - 五項驗證全過：`sudo` 實測被擋、一般 git 未誤擋、三個同步腳本正常、既有設定保留、JSON 合法。

## Next action

- 本輪 repo 無變更（改動在 `codex_symlink` 與 `~/.claude/settings.json`），前次 push 為 `85ce0fa`。
- `~/.claude/settings.json` **不在 chezmoi 管理範圍**，deny 清單不會跟著換電腦；
  要納管需走 Item 16 受控流程，尚未執行。
- Codex 的 deny 規則尚未做。`~/.codex/rules/default.rules` 目前全是累積的 `allow`，0 條 deny。
- `rm -rf` 的路徑感知攔截需要 PreToolUse hook，本次未做；判斷層已用文字規範涵蓋。
- **`personal-style-loop` 尚未經真實素材校準**：它的校準題與保留題無法執行，因為
  `writing-samples/` 是空的。依該 skill 自己的停止條件，素材不足就不得開始。
  下一步是放 2～3 篇完整代表作進某個專案的 `200_Reference/writing-samples/`，再跑第一輪校準。
  在那之前它是 `0.1.0` 未校準初版。
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
