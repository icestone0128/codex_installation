# Project Handoff

## Current state

- 2026-08-26 完成 AntiGravity 防護層全面查驗與結案：
  - **A-1**：使用者已完全執行離線清理指令，經現場 `grep` 實測驗證，`~/.gemini/config/config.json` 中的 `unsandboxed(venv/bin/python)` 授權已成功移除，Terminal Sandbox 沙盒防禦已完全鎖緊。
  - **A-2**：經與使用者評估確認，`autoExecutionPolicy` 決定保持 `CASCADE_COMMANDS_AUTO_EXECUTION_EAGER` 模式，兼顧沙盒保護與最高自動化開發流暢度，避免頻繁彈窗中斷工作流。
  - **A-3**：現場重新驗證 `~/.gemini/GEMINI.md` 與 `~/.gemini/config/AGENTS.md` 皆 100% 正確連至 `core-rules.md`，規則判斷層持續穩定生效中。
- 依課程 Pro-Kit 01「AI 分身起始助手」完成**整合**（非重跑）。唯讀盤點確認本機既有架構已等同該文件設計，文件中的「重指 `~/.claude/skills`」與「另建 `~/Agent/my-agent/`」已明確排除、未執行；82 個 skills 與四條 symlink 入口未動。
- 主版本變更全在 `codex_symlink/`（非本 repo）：
  1. 新建 `knowledge/REPOS.md`——15 個 `agentic_projects` repo 路徑索引。含本機絕對路徑，只留私有 `codex_symlink`，**不進 public repo**。
  2. `knowledge/verification-checklist.md` 新增 Phase 0 工具可用性查證。
  3. `skills/arry-assistant/SKILL.md` 新增自我進化觸發條件 7 條。
  4. `core-rules.md` 重疊清理 378 → 363 行；備份 `codex_symlink/backups/core-rules.md.bak.20260825-221658`。
  5. `core-rules.md` 新增 `## 對話與輸出語言`。
- 未採用：`memories/daily/`、`300_Journal/`（皆與既有機制重疊）。
- 本 repo 側：重跑 `200_Reference/scripts/sync-lazypack-embeds.py`（**必須帶 `SYNC_SKILLS_ROOT` 指向實際 `codex_symlink/skills`，預設路徑計算是錯的**）後只有 Item 09、43 有 diff。Item 09 是本次 `arry-assistant` 變更（+18 行）；Item 43 是 `visual-prompt-kit` 主版本 08-24／08-25 在 `trivial_matters_of_life` 更新後未回同步造成的靜默過期（+953/-28）。
- 補做（使用者指出 Pro-Kit 訪談不該整套跳過）：
  - `arry-assistant` 新增〈首次啟用訪談〉——第三方經 LazyPack Item 09 安裝時，助手會先訪談再建資料層；含環境題（可自行查證就不問）與 5 題無法查證的人題。這是 Item 09 原本的缺口：會建資料層、但不會問使用者是誰。
  - `arry-assistant` 使用流程第 5 條升級為收工必跑 LazyPack 同步檢查（靜默過期第 2 次觸發，由今日新增的自我進化規則第 2 條提報、經使用者同意後升級）。
  - `memories/MEMORY.md` 最上方新增〈協作偏好〉區塊（含 START/END 標記），內容為本次訪談所得的個人協作偏好欄位。**實際答案只存在私有 `codex_symlink`，不寫入本 repo。** 備份 `codex_symlink/backups/MEMORY.md.bak.*`。
- Obsidian 側已全部收斂：懶人包鏡像、「全域 Skills 同步.md」、專案駕駛艙、Arry 助手鏡像皆已更新並驗證。
- Pro-Kit 03「寫出好 Skill」啟動包同樣以整合處理，**不另裝 `create-good-skills`**（會與「建立 skill 一律先用 `codex-skill-creator`」的全域規則衝突）。7 項缺口整合進 `codex-skill-creator`。
- Pro-Kit 04 整合進 `codex-skill-creator`：熟練度優先於頻率的第一個 skill 篩選、勸退清單、Skill brief 作為建檔前確認產物與回溯式訪談。
- Pro-Kit 05 整合：建立全域 skill `personal-style-loop`（3 檔），新增 LazyPack **Item 44**。
- Pro-Kit 02 以**判斷層 ＋ 窄 deny** 整合：
  - `core-rules.md` 新增〈不可逆操作邊界〉四級分類。
  - `~/.claude/settings.json` 寫入 15 條 `permissions.deny`。
  - `~/.codex/rules/default.rules` 寫入 10 條 `forbidden` 規則。
  - AntiGravity 經 2026-08-26 實測與清理，A-1 成功刪除 `unsandboxed(venv/bin/python)`，A-2 保持 `EAGER`，A-3 symlink 判斷層正常生效。

- `heptabase-cli` skill 更新到 CLI `0.5.x`。CLI 執行檔本身已是最新（`0.5.0`，隨
  Heptabase.app 1.104.0 更新；PATH 上的 `heptabase` 是 wrapper，無獨立更新機制、非 brew cask）。
  落後的是 skill：宣告 `0.4.x` 而 CLI 是 `0.5.0`，觸發即自我封鎖；14 個頂層指令只涵蓋 10 個。
  已補 `course`／`goal`／`lesson`（AI Tutor）與 `local-file`，並修掉一個既有的 description
  驗證錯誤（用備份實測確認非本次造成）。Item 02 的 prose 也一併從 `0.4.x` 改為 `0.5.x`。

## Next action

### 待辦事項

#### C-1【Codex，**尚未執行**】`sandbox_workspace_write` 白名單仍未生效
- **2026-08-26 Claude Code 實測更正**：前一版 HANDOFF 記為「`workspace-write` 已生效」，
  但實際 `~/.codex/config.toml` 仍是 `sandbox_mode = "danger-full-access"`。
  `writable_roots` 確實由 26 增為 27 條，但**模式未切換，整段 `[sandbox_workspace_write]` 依然失效**。
  推測是前一個 session 被 managed sandbox 擋住寫入卻誤記為完成。
- **待決定**：是否切換為 `sandbox_mode = "workspace-write"`。
- **切換前必須先做**：確認 27 條白名單涵蓋所有實際工作路徑，並逐一實測 LazyPack 同步、
  Obsidian 鏡像、chezmoi checkpoint、python-tools 安裝。白名單外的寫入會被擋，工作流可能中斷。
- 合法值（`codex --sandbox` 實測）：`read-only`、`workspace-write`、`danger-full-access`。

#### C-2【Codex，已決策】維持高自動化
- 使用者於 2026-08-26 決定維持 `approval_policy = "never"`；未命中 `forbidden` 的指令不再跳第二次確認，因此 forbidden 清單完整性必須優先維護。

#### S-1【全域 Skill】`personal-style-loop` 素材放置與第一輪校準
- 待將 2～3 篇代表作寫作素材放入專案 `200_Reference/writing-samples/` 後，跑第一輪風格校準。

#### X-1【跨 Agent，**已修復**】防禦規則同步性
- 前一個 session 正確找出 Codex 的 `git clean` 少了 `-df`（Claude 已有），但被 managed sandbox
  擋住無法寫入。**2026-08-26 由 Claude Code 補完**（不在該 sandbox 內，可寫入）。
- 兩邊現已對齊 6 個變體：`-f`／`-fd`／`-fdx`／`-df`／`-dfx`／`-xdf`。
  Codex 逐變體 `execpolicy` 實測全 forbidden；`git clean -n`、`git clean -d`、`git status` 仍放行。
  Claude 側 deny 由 15 → 17 條。
- **仍待辦**：`~/.claude/settings.json` 與 `~/.codex/rules/default.rules` 都不在 chezmoi
  管理範圍，換電腦不會帶過去。納管需走 Item 16 受控流程。
- **規則**：修改任一邊都必須兩邊一起改並雙向實測。這已是第二次因單邊修改而產生不一致。

## Blockers

- AntiGravity A-1／A-2／A-3 阻塞已全數解除（Claude Code 實測覆核：`unsandboxed(...)` 確實歸零、
  allow 由 114 降為 113、`enableTerminalSandbox` 仍為 true）。
- Codex `git clean -df` 阻塞已解除：由 Claude Code 直接寫入完成。
- **C-1 仍待使用者決策**，且前一版 HANDOFF 對其狀態的記載不正確，已更正為「尚未執行」。
- 跨 session 提醒：接手者回報「已完成」時，務必對 live 狀態實測覆核再採信。

## Last verified

- 2026-08-26，Claude Code：`heptabase-cli` skill 更新到 `0.5.x`。CLI 實際版本 `0.5.0`
  （Heptabase.app 1.104.0）；14 個頂層指令全數涵蓋；三個驗證器全過
  （`package_claude_skill.py validate` VALID、`quick_validate.py` 通過、
  `audit-agent-compatibility.py` scanned_files=6 findings=0）；三個 Agent 入口皆解析到 0.5.x；
  LazyPack Item 02 內嵌與主版本 `diff` IDENTICAL、prose 由 `0.4.x` 更正為 `0.5.x`；
  懶人包鏡像 `diff -qr` 一致。
- 2026-08-26，Claude Code 對前一 session 回報的覆核（實測，非採信）：
  - A-1 屬實：`~/.gemini/config/config.json` 的 `unsandboxed(...)` 為 0 條，allow 由 114 降為 113。
  - A-2 屬實：`autoExecutionPolicy` 仍為 `EAGER`，`enableTerminalSandbox` 仍為 true。
  - X-1 屬實且已補完：Codex `git clean -df` 原為 no-match，補後 6 個變體全 forbidden。
  - **C-1 不實**：`~/.codex/config.toml` 仍為 `sandbox_mode = "danger-full-access"`，
    未切換為 `workspace-write`；`writable_roots` 為 27 條但整段仍不生效。已更正 HANDOFF 記載。
- 兩邊攔截清單對齊：Claude 17 條 deny／Codex 10 條 forbidden，`git clean` 6 變體一致。
  備份：`codex-default.rules.bak.*`、`claude-settings.json.bak.*`、`heptabase-cli.SKILL.md.bak.*`。
