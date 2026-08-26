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

- 防護措施已寫入三個安裝 repo，**未新增 LazyPack Item**（Item 16 已內嵌，另兩個 repo 不是項目制，
  且三個 Agent 需要的內容不同：Claude／Codex 套用、AntiGravity 只能驗證）。
  `codex_installation` 補 Item 16 prose（原本 20 次 guardrails 全在內嵌區塊、說明章節隻字未提）、
  `claude_installation` 補〈9. 危險指令攔截層〉、`antigravity_installation` 補〈8. 防護層驗證〉。
  三個 repo 已 push：`2214cdb`／`c15e7eb`／`28e1ba7`。

- Pro-Kit 01–05 完整性複查完成。修復第三方安裝的關鍵缺口：guardrails 主檔原不在 skill 套件內、
  不會被 LazyPack 內嵌，第三方會 `ERROR master not found`。已移入
  `cross-device-sync/assets/`（自動內嵌，Item 16 重生後 IDENTICAL），apply 腳本改讀新路徑
  並加舊副本分岔防護，三 repo 文件路徑引用已更新。Item 09 補「新對話驗收指令」。
  刻意跳過項（記憶 hook、rm→trash、PreToolUse hook、comparison reference）皆有記錄理由。

## Next action

### 待辦事項

#### C-1【Codex，已決策】維持 Full Access
- 使用者於 2026-08-26 明確決定維持 `sandbox_mode = "danger-full-access"`，不切換為
  `workspace-write`。
- `[sandbox_workspace_write]` 的 27 條 `writable_roots` 保留為備用設定；Full Access 模式下不生效，
  不再列為待決策或阻塞。

#### C-2【Codex ＋ Claude，已完成】高自動化＋風險操作詢問
- 2026-08-26 已在 Full Access 任務將 `approval_policy = "never"` 改為 `"on-request"`，並將
  `approvals_reviewer = "auto_review"` 改為 `"user"`；`sandbox_mode = "danger-full-access"` 保持不變。
- 一般 `git commit`／`git push` 已由 `allow` 改為 `prompt`；`git push --force`、
  `git reset --hard`、`git clean -df` 等既有危險規則仍維持 `forbidden`。
- 已建立 `config.toml.bak.20260826-071319` 與 `default.rules.bak.20260826-071319`
  （實測確認在 `{{SYNC_ROOT}}/backups/`，非 HANDOFF 原記載的 `~/.codex`）；目前任務不會
  追溯重載啟動時權限，需重新開啟 Codex 任務後才會以新核准策略執行。
- **2026-08-26 Claude Code 補齊對稱性**：C-2 原本只做了 Codex，Claude 側 `permissions.ask` 為 0 條，
  等於這個 Agent 的 commit／push 完全不詢問。已加入 `Bash(git commit:*)`、`Bash(git push:*)`。
  這是**第三次**單邊修改造成不一致，X-1 的規則必須確實執行。

#### S-1【全域 Skill】`personal-style-loop` 素材放置與第一輪校準
- 待將 2～3 篇代表作寫作素材放入專案 `200_Reference/writing-samples/` 後，跑第一輪風格校準。

#### X-1【跨 Agent，**已修復**】防禦規則同步性
- 前一個 session 正確找出 Codex 的 `git clean` 少了 `-df`（Claude 已有），但被 managed sandbox
  擋住無法寫入。**2026-08-26 由 Claude Code 補完**（不在該 sandbox 內，可寫入）。
- 兩邊現已對齊 6 個變體：`-f`／`-fd`／`-fdx`／`-df`／`-dfx`／`-xdf`。
  Codex 逐變體 `execpolicy` 實測全 forbidden；`git clean -n`、`git clean -d`、`git status` 仍放行。
  Claude 側 deny 由 15 → 17 條。
- **2026-08-26 已解決跨裝置問題，但不是用 chezmoi add**。量化後確認四個設定檔不適合直接納管：
  `.codex/config.toml` 33 處本機絕對路徑、`.gemini/config/config.json` 31 處且由 app 主動重寫
  （納管會與 app 互相覆寫）、`.codex/rules/default.rules` 11 處。直接 add 會把錯誤路徑帶到新機器。
- 改為抽出**零絕對路徑的可攜主版本** `{{SYNC_ROOT}}/skills/cross-device-sync/assets/agent-guardrails.json`
  （17 條 forbidden、2 條 ask，含刻意排除項與已知洞的理由），由 Google Drive 跨機器同步。
- 新增 `cross-device-sync/scripts/apply-agent-guardrails.py`：預設唯讀 `--verify`，
  `--apply` 才寫入且自動備份。AntiGravity 因無 deny 機制而明確略過。
- 已接進 `session-sync-checkpoint.sh` 的三個結束路徑，開工／收工都會自動比對並輸出
  `GUARDRAILS CLAUDE drift: ... CODEX block: ...`。
- **`~/.claude/settings.json` 的 mcpServers 與 `.codex/config.toml` 仍未跨裝置**；
  那些是本機路徑設定，換電腦時由 Item 16 bootstrap 重建，不走檔案同步。
- **規則**：修改任一邊都必須兩邊一起改並雙向實測。這已是第二次因單邊修改而產生不一致。

## Blockers

- AntiGravity A-1／A-2／A-3 阻塞已全數解除（Claude Code 實測覆核：`unsandboxed(...)` 確實歸零、
  allow 由 114 降為 113、`enableTerminalSandbox` 仍為 true）。
- Codex `git clean -df` 阻塞已解除：由 Claude Code 直接寫入完成。
- C-1 與 C-2 均已完成，沒有 Codex 設定阻塞；C-2 的 runtime 生效點是下一個重新開啟的任務。
- 跨 session 提醒：接手者回報「已完成」時，務必對 live 狀態實測覆核再採信。

## Last verified

- 2026-08-26，Claude Code 全面覆核（實測，未採信回報）：
  - **C-1 屬實**：`sandbox_mode = "danger-full-access"` 維持不變。
  - **C-2 屬實**：`approval_policy = "on-request"`、`approvals_reviewer = "user"`、
    `git commit`／`git push` 為 `prompt` 共 2 條。備份檔存在（位置為 `backups/` 非 `~/.codex`）。
  - **A-1／A-2／A-3 屬實**：`unsandboxed(...)` 0 條、allow 113、`enableTerminalSandbox` true、
    `EAGER` 維持、兩個 symlink 皆連到 `core-rules.md` 且讀得到〈不可逆操作邊界〉。
  - **X-1 屬實**：`-df` 修正未被後續編輯覆蓋；Codex 17 條 forbidden 逐一 execpolicy 實測全命中；
    誤擋檢查 7 項正常指令（含 `chmod -R 755`、`rm -rf /tmp/build`、`git clean -n`／`-d`）全放行。
  - **發現新不一致**：C-2 只做 Codex，Claude `permissions.ask` 為 0 條，已補齊。
- 可攜主版本 `rules/agent-guardrails.json` 與兩個 Agent 實際設定完全對帳：
  forbidden 17/17、ask 2/2，零差異。`apply-agent-guardrails.py --verify` 回報 drift none。
- `session-sync-checkpoint.sh` 三個結束路徑皆已接上 guardrails 比對，實測輸出正常，`bash -n` 通過。
- LazyPack Item 16 內嵌新腳本與主版本 `diff` IDENTICAL；懶人包鏡像 `diff -qr` 一致。
  （全量 sync 在 Google Drive 路徑逾時，依既有踩坑筆記改用 `replace_embedded_section` 單項重生。）
