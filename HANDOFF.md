# Project Handoff

## Current state

- LazyPack Item 43 已補記：commit `823a3ff`（2026-09-09 07:23）更新 Visual Prompt Kit 安裝文件
  （+1377／−25 行）與 README 一行，已推送，Obsidian `懶人包/` 鏡像 `diff -qr` 一致。
- 完成 `lifehacker-tw/claude-code-mini-course` pro-kit 01–08 的上游比對。授權於 2026-07-18
  的 commit `ec7b3b8` 由 CC BY-NC-SA 4.0 改為付費學員限定；本地 snapshot 凍結在 `b2cd801`。
  結論：架構層面六項我方較完整，不跟進；唯一真實缺口是 Office 文件轉 Markdown。
- 本次全域層變更（皆為新增章節，未改寫既有條目）：
  - `core-rules.md` 新增〈第三方教材與上游來源整合規則〉四條。
  - `knowledge/我的工具清單.md` 新增 anydoc 條目。
  - `knowledge/context-management-strategy.md` 新增〈Skills 預算管理原則〉。
  - `skills/doc-to-md/SKILL.md` 新增 Step 0 Office → anydoc 路由。
  - `skills/codex-skill-creator/SKILL.md` 新增〈Semantic Overlap Check〉。
- anydoc v0.2.4 已安裝（`firecrawl/anydoc`，MIT，獨立上游，非取自課程），`.docx` 實測通過。
- Codex CLI 已升級 0.149.1 → 0.153.4（原版本跑不動預設模型 `gpt-6-astra`）。
- Skill description 全面精簡完成：83 個 skill 全部 ≤175 字元，總量 27,395 → 11,190（−59%）。
  被模型截斷者 64 → 0，`Skill descriptions were shortened` 警告已消失，且 skill 數量未減少。
  截斷機制實測為「動態擠壓」而非固定上限：總量降下來後 Codex 就不再截斷任何描述。
- 修好一個獨立既有 bug：`rightproblem-coach` 的 description 含 `#`，YAML 把後半當註解，
  實際只解析到 40 字元，60% 觸發詞長期無效。

- LazyPack 已同步：`sync-lazypack-embeds.py` 重新內嵌 39 個 Item，複驗 40 identical / 0 to change；
  `verify-lazypack-embeds.py` 抽驗三個 Item DIFFERS=0；Obsidian `懶人包/` 鏡像 `diff -qr` 一致；
  Obsidian 全域 Skills 索引已補 2026-09-10 同步紀錄。
- `knowledge/` 可達性稽核完成：19 個檔案／子目錄全部在 `agent-execution-strategy.md` 索引中
  且有明確載入時機。修正兩處索引與實作不一致（`arry-evp-reporting-playbook.md` 的三個 owner
  skill 都沒引用、`image-generator` 被列為 `arry-visual-identity` owner 但引用 0 次），皆已補指標。
- `startup-sync` 第 6 步擴充為「MCP + skills 預算 + frontmatter 有效性」並附檢查腳本；
  新增第 7 步指出知識索引位置，同時明確要求開工時不載入全部策略。

- `core-rules.md` 已精煉：27,216 → 18,307 字元（−33%），佔 Codex session 起始 prompt 從 49% 降到 39%。
  作法是把「程序」移進對應 skill、只在 core-rules 留觸發條件與指標，並新增〈路徑常數〉表取代 8 處展開的絕對路徑。
  合併四個同步章節為單一〈同步義務〉表；`Arry 助手開工與收工三方同步規範` 整節移除（已被 startup/shutdown-sync 覆蓋）。
- 精煉後做了規則遺失檢查，抓到 4 條真的掉了，已補回 owner skill：LazyPack README 安裝總表標示、
  懶人包舊版改名封存程序、全域 Skills 索引欄位要求（→ `shutdown-sync`）、開工 `git fetch` 落後／衝突檢查（→ `startup-sync`）。
- `shutdown-sync` 原本**完全沒有** LazyPack 同步步驟（今天只靠 core-rules 才知道要做），已補為第 5 步並附腳本。

- 記憶層完成分層重整：`MEMORY.md` 48,480 → 1,145 tokens（Task Group 日誌移入 `memories/archive/`），
  `raw_memories.md` 與 `automation_memory_fallback.md` 一併封存（兩者原本無人引用）。
  新增 `knowledge/memory-tiering.md`（T0 常駐／T1 開工／T2 按需／T3 封存，分層軸是載入觸發條件）
  與 `extensions/ad_hoc/notes/INDEX.md`（46 則，原本無索引等同不可達）。
- 查明 2026-08-21 Codex 原生記憶 pipeline 停擺原因：consolidation 會把既有記憶讀回當輸入，
  48k tokens 的 `MEMORY.md` 撐爆 context，`memory_stage1` 2 筆失敗且 retry 歸零。根因已移除。
- `startup-sync` 原本字面要求 read `MEMORY.md`（當時 48k tokens），已改為只讀協作偏好；
  `shutdown-sync` 加入 `MEMORY.md` 分層守門（超過 3,000 tokens 就把 Task Group 移進 archive）。
- 誤放在 `memories/skills/` 的 `obsidian-weekly-knowledge-refresh-secondbrain` 移入 `skills/`，
  並修好 `disable-model-invocation` 與 `user-invocable: false` 並存導致完全無法觸發的問題。全域 skill 83 → 84。
- 常駐 context 現況：core-rules 8,838 + 協作偏好 1,145 ≈ **9,983 tokens**。
- CC BY-NC-SA ShareAlike 標示缺口已補齊：Item 13／14／15 與 Item 16 的主版本
  （`cross-device-sync/references/codex-playbook.md`）都加上「本檔同以 CC BY-NC-SA 4.0 釋出」
  與來源凍結說明（snapshot `b2cd801`，上游 2026-07-18 改為付費學員限定後不再取用）。
  Item 42 查證後無缺口 —— 它來自不同 repo（`Raymondhou0917/speak-human-tw`，MIT），
  LICENSE 已隨 package 內嵌且版本與 commit 都有釘。
- `~/.codex/memories` symlink 依先前建議維持現狀（該 repo 無 remote，無外洩風險），此項結案。

## Next action

- **驗證記憶 pipeline 是否復活（需要你操作）**：用**互動式** Codex（桌面版或 `codex` CLI）開一次
  session，然後跑：
  `sqlite3 ~/.codex/memories_1.sqlite "SELECT kind,status,COUNT(*),MAX(datetime(finished_at,'unixepoch','localtime')) FROM jobs GROUP BY kind,status;"`
  現況：253 個 rollout 只處理過 27 個，2026-08-21 之後累積 29 個未處理，jobs 表沒有新的排隊列。
  非互動式 `codex exec` 不會觸發排程（config 有 `disable_on_external_context` 等閘門），
  所以本次無法從這裡驗證。若互動式開啟後仍無新 job，再查 `[memories]` 的
  `min_rollout_idle_hours`、`max_rollout_age_days`、`min_rate_limit_remaining_percent` 等預設值。
  2026-07-17 那 2 筆 `retry_remaining=0` 的 stage1 未重置（未改動 Codex 內部狀態 DB）。

## Blockers

- 無。

## Last verified

- 2026-09-10 09:10 CST，Claude Code；83 個 skill frontmatter YAML 全數通過驗證，
  `codex debug prompt-input` 確認 0 個描述被截斷，`codex exec` 確認預算警告消失，
  anydoc `.docx` 轉換退出碼 0，Codex CLI 0.153.4；LazyPack 40 identical / 0 to change，Obsidian 鏡像 `diff -qr` 一致。
