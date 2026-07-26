# 13-Brainstorm-規劃模式

> 2026-05-24 更新：本文件已改為自含式 Skill 安裝文件。請使用文末「內建 Skill 完整安裝內容」，不需要額外的舊版獨立 skills 子目錄。


## 目標

把既有 `/brainstorm` 規劃流程與 RDQ 需求探索四象限法整合成三 Agent 共用的單一全域 skill，同時支援 Codex、Claude、AntiGravity。

這個 skill 用在「先想清楚再動手」的情境。每次觸發且使用者尚未指定模式時，先詢問要使用 Quick 或 RDQ：Quick 以最少互動完成假設、方案與計劃；RDQ 先用四象限釐清隱藏需求、風險與驗收條件，確認需求規格卡後再產出執行計劃。三 Agent 使用同一輸入／輸出契約，只有提問 UI 與可讀取的專案內容介面可以不同。

## 前置條件

- 已完成 `README.md` 的設定表。
- 已知道三 Agent 共用 skills 主版本：`{{SYNC_ROOT}}/skills`。
- 已完成或讀過 `11-Codex-Skill-Creator-工作流.md`。
- 若使用 Obsidian 全域 skill 索引，已知道位置：

```text
{{OBSIDIAN_PROJECTS}}/{{SETUP_PROJECT_NAME}}/全域 Skills/全域 Skills 同步.md
```

## 固定結論

- skill 名稱：`brainstorm`
- 正式安裝位置：

```text
{{SYNC_ROOT}}/skills/brainstorm/
```

- 本文件已內嵌可直接建立的 skill 原始檔：

```text
本文件文末內嵌內容：brainstorm/SKILL.md
本文件文末內嵌內容：brainstorm/agents/openai.yaml
本文件文末內嵌內容：brainstorm/references/rdq-method.md
本文件文末內嵌內容：brainstorm/references/rdq-question-bank.md
本文件文末內嵌內容：brainstorm/references/rdq-spec-template.md
本文件文末內嵌內容：brainstorm/references/rdq-method-positioning.md
本文件文末內嵌內容：brainstorm/references/source-adaptation.md
```

- 共用觸發方式是 skill metadata 與自然語意；當前 Agent 若支援顯式 skill 呼叫可作為 adapter，例如：
  - `$brainstorm`
  - `brainstorm 我想做一個記帳 App`
  - `/brainstorm 我想改善目前的工作流程`
  - `用 RDQ 幫我先釐清這個機構設計任務`
  - `先訪談我再做`
  - `先幫我規劃，不要直接執行`
  - `請先把這個想法整理成計劃`

## 直接安裝

下載本 repo 後，直接使用本文文末的內建安裝腳本建立到 `{{SYNC_ROOT}}/skills`：

```bash
mkdir -p "{{SYNC_ROOT}}/skills/brainstorm"
# 請使用本文文末「內建 Skill 完整安裝內容」；不需要額外複製舊版獨立 skills 子目錄。
```

如果你已經有同名 skill，先備份再覆蓋：

```bash
cp -R "{{SYNC_ROOT}}/skills/brainstorm" "{{SYNC_ROOT}}/skills/brainstorm.backup.$(date +%Y%m%d-%H%M%S)"
# 請使用本文文末「內建 Skill 完整安裝內容」；不需要額外複製舊版獨立 skills 子目錄。
```

## 驗證安裝

檢查檔案存在：

```bash
find "{{SYNC_ROOT}}/skills/brainstorm" -maxdepth 3 -type f -print
```

應看到：

```text
{{SYNC_ROOT}}/skills/brainstorm/SKILL.md
{{SYNC_ROOT}}/skills/brainstorm/agents/openai.yaml
{{SYNC_ROOT}}/skills/brainstorm/references/rdq-method.md
{{SYNC_ROOT}}/skills/brainstorm/references/rdq-question-bank.md
{{SYNC_ROOT}}/skills/brainstorm/references/rdq-spec-template.md
{{SYNC_ROOT}}/skills/brainstorm/references/rdq-method-positioning.md
{{SYNC_ROOT}}/skills/brainstorm/references/source-adaptation.md
```

檢查 frontmatter：

```bash
sed -n '1,12p' "{{SYNC_ROOT}}/skills/brainstorm/SKILL.md"
```

應包含：

```markdown
---
name: brainstorm
description: Use when the user says brainstorm, $brainstorm, /brainstorm, 規劃模式, 用 RDQ, 先訪談我...
metadata:
  short-description: 先選 Quick 或 RDQ，再確認需求與計劃
---
```

安裝後，對 Codex、Claude、AntiGravity 分別開新對話或重載 skill 清單。

## 何時會觸發

使用者提出以下需求時應使用：

- 「brainstorm 我想做一個新工具」
- `$brainstorm`
- 「/brainstorm 我想改善這個專案」
- 「用 RDQ 幫我釐清需求」
- 「先訪談我再做」
- 「先幫我規劃，不要執行」
- 「我有一個模糊想法，幫我釐清」
- 「先列方案比較，等我確認後再做」

不應用在：

- 使用者已經要求直接做一個明確的小修正。
- 單純查詢事實、翻譯、改一句文字。
- 已有清楚規格且使用者明確不要再討論方案。

## 工作流程

1. 若使用者尚未指定，第一個問題先詢問 Quick 或 RDQ。
2. Quick：輕量讀取上下文、回顯假設、最多問 5 個關鍵問題、比較方案、產出計劃。
3. RDQ：靜默選擇 RDQ Lite／Full，用四象限擷取已知、解答疑問、訪談隱藏需求、提出未知風險。
4. RDQ 先產出一頁 `draft` 需求規格卡；使用者確認後改為 `confirmed`。
5. confirmed 規格卡交回 Brainstorm 產出執行計劃，不重問已確認事項。
6. Quick 與 RDQ 都要等執行計劃確認後才開始做事。
7. 溝通深度預設半技術，依使用者語氣調整，不再增加另一輪開場選擇。
8. RDQ 原始 `lesson` 領域已替換為 `mechanical` 機構工程與產品開發題庫。

## 硬性閘門

在使用者確認計劃之前，不可以：

- 寫程式碼或修改既有檔案。
- 建立專案結構或 scaffold。
- 執行會改變狀態的安裝、設定、部署、刪除、搬移動作。
- 把初步假設當成已確認需求。

允許做的事：

- 讀取相關檔案。
- 檢查狀態。
- 詢問問題。
- 整理方案。
- 產出計劃書草稿。

## 計劃書位置

三 Agent 共用版不在安裝時固定 `PLANS_DIR`。使用 skill 時才依專案狀況決定：

1. 若目前專案有 `100_Todo/`，預設放在 `100_Todo/projects/brainstorm/`。
2. 若目前專案已有明確規劃目錄且使用者要求沿用，可放在該既有目錄。
3. 若使用者指定位置，以使用者指定為準。
4. 若使用者只想在對話中看計劃，不需要建立檔案。

檔名建議：

```text
YYYY-MM-DD-[主題關鍵字].md
```

## 同步 Obsidian 全域 Skill 索引

若你使用 Obsidian 記錄全域 skills，新增或更新這個 skill 後，同步：

```text
{{OBSIDIAN_PROJECTS}}/{{SETUP_PROJECT_NAME}}/全域 Skills/全域 Skills 同步.md
```

至少補三處：

1. 自訂全域 Skills 表格。
2. Skill 摘要段落。
3. 最近同步紀錄。

範例表格列：

```markdown
| `brainstorm` | `{{SYNC_ROOT}}/skills/brainstorm/SKILL.md` | Brainstorm 規劃模式；用引導式問答把模糊想法轉成可執行計劃，確認前不實作 | 已同步 |
```

## 來源工具 轉換重點

| 來源工具 原流程 | 三 Agent 相容做法 |
| --- | --- |
| `/brainstorm` slash command | 可保留為觸發語；顯式呼叫使用實際名稱 `$brainstorm` |
| 來源工具的全域 skills 路徑 | 需要全域觸發時改用 `{{CODEX_HOME}}/skills` |
| 來源工具的專案級 skills | 改放該專案 `000_Agent/skills`，只服務該專案 |
| `000_Agent/skills` symlink | 不建立；`000_Agent/skills` 是本地 skill 區，不等於 Codex 全域 skills |
| `AskUserQuestion` | 不當成共用依賴；三 Agent 有原生選項 UI 時使用，沒有時改為純文字編號 |
| 安裝時固定 `PLANS_DIR` | 使用 skill 時依專案決定 |
| RDQ 的 ChatGPT 與 Claude 分流 repo | 抽出共用四象限、互動預算與規格卡，差異只保留在 Agent execution notes 與 `agents/openai.yaml` |
| RDQ 原始 `lesson` 教材題庫 | 完整替換為 `mechanical` 機構工程與產品開發 |

## 踩坑修正

- 不要把原始 來源工具 安裝段落直接照貼到 Codex。
- 不要建立 來源工具的 skills 路徑或 command shim；專案級 skill 只放該專案 `000_Agent/skills`。
- 共用核心不假設 `/brainstorm` 會被任一 UI 特別處理；要在 `description` 寫清楚自然語意觸發，各 Agent 顯式呼叫另記 adapter。
- 不要另外安裝會競爭觸發的 `rdq` skill；RDQ 是 `brainstorm` 的內建深度模式。
- 頂層只詢問 Quick／RDQ；RDQ Lite／Full 由 Agent 靜默判定，不再詢問使用者。
- 安裝後通常要對三 Agent 分別開新對話或重載入口。
- 這個 skill 是規劃閘門，不是自動執行工具；使用者確認前不要動檔案。

## 設定範例

本機曾建立：

```text
{{SYNC_ROOT}}/skills/brainstorm/SKILL.md
{{SYNC_ROOT}}/skills/brainstorm/agents/openai.yaml
{{SYNC_ROOT}}/skills/brainstorm/references/rdq-method.md
{{SYNC_ROOT}}/skills/brainstorm/references/rdq-question-bank.md
{{SYNC_ROOT}}/skills/brainstorm/references/rdq-spec-template.md
{{SYNC_ROOT}}/skills/brainstorm/references/rdq-method-positioning.md
{{SYNC_ROOT}}/skills/brainstorm/references/source-adaptation.md
```

並已把原始 來源工具 `/brainstorm` 安裝劇本轉成 三 Agent 相容流程。下載者應使用自己的 `{{CODEX_HOME}}` 與自己的專案位置。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊。這個序號項目會安裝：`brainstorm`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請依 README 設定 `{{SYNC_ROOT}}`；package 只寫入共用主版本，Item 16 與 chezmoi 會建立 Codex、Claude、AntiGravity 的原生入口。

````bash
set -e

# ---- brainstorm ----
mkdir -p "{{SYNC_ROOT}}/skills/brainstorm"
# brainstorm/SKILL.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/brainstorm/SKILL.md")"
cat > "{{SYNC_ROOT}}/skills/brainstorm/SKILL.md" <<'AGENT_LAZYPACK_BRAINSTORM_SKILL_MD_0E95F5A366'
---
name: brainstorm
description: Use when the user says brainstorm, $brainstorm, /brainstorm, 規劃模式, 用 RDQ, 先訪談我, 先想清楚再動手, 幫我釐清需求, or asks to turn a vague idea into a confirmed requirement and executable plan. First ask the user to choose Quick or RDQ unless they already named a mode; do not implement until the required specification and plan confirmations are complete.
metadata:
  short-description: 先選 Quick 或 RDQ，再確認需求與計劃
---

# Brainstorm：Quick／RDQ 規劃模式

把模糊想法轉成可確認的需求與可執行計劃。這是 Codex、Claude 與 AntiGravity 共用的單一規劃入口；RDQ 是內建的深度需求探索模式，不另外安裝或觸發第二個 `rdq` skill。

## 第一個問題：選擇模式

只要本 skill 被觸發，而且使用者尚未明確指定 `Quick` 或 `RDQ`，第一個主要問題固定是：

```text
這次想用哪一種規劃？

1. Quick：快速釐清、比較方案、產出執行計劃；適合一般、可逆、單一產出的任務。
2. RDQ：先用四象限探索隱藏需求與風險，確認需求規格卡後再產出執行計劃；適合中大型、跨天、公開、花錢或不可逆的任務。
```

- 根據目前任務給一句推薦理由，但選擇權留給使用者。
- 使用者已說「Quick」「用 RDQ」或等價語意時，直接進入該模式，不重問。
- 使用者說「你決定」時：單一、可逆、半天內可完成的任務選 Quick；多產出、跨天、公開、花錢或不可逆的任務選 RDQ，並明說選擇結果。
- 尚未進入 Quick／RDQ 時，使用者明確說「直接做」「不要規劃」，就退出本 skill，依一般任務流程處理。已進入 RDQ 後的停止語依 `rdq-method.md` 收斂成規格卡，仍須完成確認閘門。
- 溝通深度預設為半技術模式；使用者指定小白或工程師模式時再切換，不另外增加一次開場選擇。

## 共用硬性閘門

在使用者完成目前模式要求的確認之前，不可以：

- 寫程式碼或修改既有檔案。
- 建立專案結構或 scaffold。
- 執行會改變狀態的安裝、設定、部署、刪除或搬移。
- 把初步假設當成已確認需求。

允許：讀取相關檔案、檢查狀態、查證使用者已提出的疑問、整理方案，以及在對話中產出規格卡或計劃草稿。只有使用者明確要求保存時，才可寫入規格卡或計劃檔。

## 共用溝通原則

- 全程使用繁體中文。
- 不重問對話、附件、專案規則、`HANDOFF.md` 或現有檔案已經回答的事項。
- Quick 模式一次只問一個主要問題。
- RDQ 模式依互動預算，可在同一輪列出最多 3 個具體選項題與 3–5 項建議，避免增加回覆輪次。
- 使用者連續說「你決定」「都可以」時停止追問，採合理預設並明列為假設。
- 需求過大時先提出核心版本，把延伸內容列入「本次不納入」。

## Quick 模式

Quick 適合一般、可逆、單一產出的規劃。目標是用最少互動形成一份可執行計劃。

### Q1. 確認主題與任務類型

若主題已明確，先用一句話回顯；否則只問：「你想規劃什麼？用一句話描述就好。」

任務類型：

- 新東西：新功能、新專案、新工具。
- 解決問題：bug、錯誤、流程卡住。
- 改善現有東西：優化、重構、變好用。
- 還不確定：需要先找方向。

### Q2. 輕量讀取上下文

依任務範圍按需讀取，不大範圍掃描：

- 專案 `AGENTS.md`、`HANDOFF.md`、README 與使用者指定檔案。
- Git 狀態與最近幾筆 commit。
- 根目錄主要檔案與相關功能。
- 附件、連接資料、ChatGPT Project 或目前 Agent 可用的專案內容。

### Q3. 回顯假設

列出 3–6 個假設，涵蓋目標、範圍、使用者、產出、限制與本次不做的事。只問：「這些理解有哪裡需要修正？」

### Q4. 關鍵釐清

最多問 5 個會改變方案或造成返工的問題；已知事項不重問。若使用者想直接看方案，採合理預設並標示。

### Q5. 方案比較

通常提出 2–3 個方案；簡單任務可只提出一個建議做法。至少包含：

- 做法。
- 優點與限制。
- 工作量與風險。
- 適合情境。
- 推薦方案與理由。

### Q6. 產出 Quick 計劃

計劃至少包含：

```markdown
# [計劃名稱]

## 一句話版
## 背景和動機
## 已確認的決策
## 具體步驟
## 預計成果
## 本次不包含
## 風險與處理
## 驗收方式
```

### Q7. 確認

計劃完成後只提供：

1. 現在依計劃執行。
2. 先修改計劃。
3. 先保存，之後再做。

只有使用者選擇或明確表示執行時，才離開 Quick 模式開始實作。

## RDQ 模式

RDQ 是需求探索層，適合中大型、高成本或不可逆任務。選定 RDQ 後必須直接讀取：

- `references/rdq-method.md`
- `references/rdq-question-bank.md` 的對應領域段落
- `references/rdq-spec-template.md`

只有公開介紹、研究或示範 RDQ 方法時，才讀 `references/rdq-method-positioning.md`。

RDQ 流程：

1. 靜默選擇內部 `RDQ Lite` 或 `RDQ Full`；不要再詢問使用者。
2. 用四象限擷取已知、解答疑問、訪談隱藏需求、提出未知風險與選項。
3. 產出一頁 `draft` 需求規格卡並等待確認。
4. 規格卡確認後改為 `confirmed`。
5. 把 confirmed 規格卡當成 Quick 的已確認輸入，不重問，直接比較必要方案並產出執行計劃。
6. 等使用者確認執行計劃後才實作或交棒。

需求確認與執行計劃確認是兩個不同閘門；前者確認「做什麼」，後者確認「怎麼做」。

## 機構工程領域

RDQ 原始來源中的 `lesson` 教材領域已移除，替換為 `mechanical` 機構工程與產品開發領域。當任務涉及下列內容時讀取題庫的 `mechanical` 段：

- 機構設計、產品結構、外觀件、內部堆疊或介面。
- 材料、製程、表面處理、成本、重量、厚度或強度取捨。
- 公差分析、基準、配合、裝配、DFM／DFA 或供應商可製造性。
- EVT／DVT／PVT／MP、可靠度、測試、失效分析、DFMEA、ECN／ECR。
- 2D／3D、BOM、規格、設計審查或量產問題。

跨領域任務以主要交付物選一個主領域，再從其他段落補充最多一個真正會導致返工的問題。

## 輸出與保存位置

所有內容預設先完整顯示在對話中。只有使用者要求保存時才寫檔：

- Quick 計劃：`100_Todo/projects/brainstorm/YYYY-MM-DD-[主題].md`
- RDQ 規格卡：`100_Todo/projects/brainstorm/rdq/RDQ-spec-[主題]-YYYYMMDD.md`
- RDQ 後續計劃：`100_Todo/projects/brainstorm/YYYY-MM-DD-[主題].md`

若專案已有明確規劃目錄或使用者指定位置，沿用該位置。不要在專案根目錄建立 `plans/` 或 `rdq/`。

## Agent execution notes

- Shared steps: 三個 Agent 共用相同的 Quick／RDQ 選擇題、硬性閘門、RDQ 四象限、機構工程題庫、規格卡、計劃格式與驗收標準。
- Codex adapter: 有結構化提問 UI 時可用；沒有時使用純文字編號選項。`agents/openai.yaml` 只提供 Codex／ChatGPT UI metadata，不改變共用流程。
- Claude adapter: 可使用原生結構化單選／多選提問能力；不可把該工具名稱寫成共用流程的必要依賴。專案狀態以 `AGENTS.md` 與薄 `CLAUDE.md` adapter 為準。
- AntiGravity adapter: 使用可用的原生選項介面；沒有時使用相同的純文字編號格式。專案狀態以 `AGENTS.md` 與 `GEMINI.md` 入口為準。
- Fallback: 任一 Agent 缺少結構化 UI 或本機檔案權限時，仍在同一則訊息提供簡潔編號選項，並把規格卡與計劃完整貼在對話中。
- Verification: 三個 Agent 都必須先取得 Quick／RDQ 選擇；RDQ 輸出相同欄位的規格卡；確認前不得修改狀態；已確認內容不得被下游重問。

## 自我檢查

交付規格卡或計劃前確認：

- 已詢問 Quick／RDQ，或使用者已明確指定模式。
- 沒有把 `RDQ Lite／Full` 當成第二次模式選擇題。
- 沒有重問已知事項。
- Quick 步驟通常為 3–8 步；RDQ 規格卡可在一個螢幕掃完。
- 沒有未標示的 TBD、矛盾或無法驗收的描述。
- 已列出本次不包含與必要風險。
- 機構工程任務使用 `mechanical`，沒有套用原始 `lesson` 教材題庫。
- 使用者確認前沒有寫檔或執行會改變狀態的動作。

## 來源

來源整合與授權說明見 `references/source-adaptation.md`。
AGENT_LAZYPACK_BRAINSTORM_SKILL_MD_0E95F5A366

# brainstorm/agents/openai.yaml
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/brainstorm/agents/openai.yaml")"
cat > "{{SYNC_ROOT}}/skills/brainstorm/agents/openai.yaml" <<'AGENT_LAZYPACK_BRAINSTORM_AGENTS_OPENAI_YAML_DEB9755D27'
interface:
  display_name: "Brainstorm — Quick / RDQ"
  short_description: "先選 Quick 或 RDQ，再確認需求與執行計劃"
  default_prompt: "Use $brainstorm to ask me whether to use Quick or RDQ, then produce a confirmed requirement and plan before implementation."

policy:
  allow_implicit_invocation: true
AGENT_LAZYPACK_BRAINSTORM_AGENTS_OPENAI_YAML_DEB9755D27

# brainstorm/references/rdq-method-positioning.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/brainstorm/references/rdq-method-positioning.md")"
cat > "{{SYNC_ROOT}}/skills/brainstorm/references/rdq-method-positioning.md" <<'AGENT_LAZYPACK_BRAINSTORM_REFERENCES_RDQ_METHOD_POSITIONING_MD_9D7297F165'
# RDQ Method 的來源與研究定位

## 對外表述

RDQ Method 並非宣稱創造 Known／Unknown 四象限或需求工程理論，而是將既有的知識分類、Unknown Knowns 討論及 Requirements Elicitation 整合、重新詮釋並流程化，用於 AI Agent、AI Skill 與專案前期的需求建構。

The RDQ Method does not claim authorship of the known–unknown knowledge model or requirements engineering. It is an integrative and experimental method that adapts established concepts into a structured requirement-discovery workflow for AI agents, skills, and projects.

## 目前定位

- 實驗性方法。
- 可稱為整合型方法、實務框架或 AI 專案前期需求建構流程。
- 不宜稱為已驗證的學術理論、國際標準或通用 Agent 標準。
- 不得在沒有對照組時宣稱能降低特定百分比的修改次數。
- 規格卡 telemetry 是單臂描述性資料，存在任務難度與自選偏誤。

## 認識論限制

AI 無法真正判定使用者「知不知道自己知道」。RDQ 以「使用者現在當場答得出來嗎？」作為 Unknown Knowns 的操作型近似，必須如實說明。
AGENT_LAZYPACK_BRAINSTORM_REFERENCES_RDQ_METHOD_POSITIONING_MD_9D7297F165

# brainstorm/references/rdq-method.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/brainstorm/references/rdq-method.md")"
cat > "{{SYNC_ROOT}}/skills/brainstorm/references/rdq-method.md" <<'AGENT_LAZYPACK_BRAINSTORM_REFERENCES_RDQ_METHOD_MD_3B1247A411'
# RDQ 共用方法

本文件只在使用者選擇 `RDQ` 模式後讀取。RDQ 是 Brainstorm 的深度需求探索層，不是另一個 skill ID。

## 四象限

每個象限使用專屬動詞，不可越界：

| 象限 | 使用者狀態 | 動作 | 不可做 |
|---|---|---|---|
| Ⅰ Known Knowns | 已經明說或環境已知 | 只擷取、回顯 | 不提問 |
| Ⅱ Known Unknowns | 使用者主動提出的疑問 | 先解答、查證 | 不把問題丟回使用者 |
| Ⅲ Unknown Knowns | 使用者知道但沒想到要說 | 只訪談 | 不問當場答不出的事 |
| Ⅳ Unknown Unknowns | 尚未想到的風險、選項與替代方案 | 主動提出並標代價 | 不問開放式問題 |

判別規則：

- 使用者現在當場答得出來 → 象限Ⅲ，用具體選項詢問。
- 使用者需要先取得資訊才能判斷 → 象限Ⅳ，提供選項、影響與代價。

永遠不要問「你還有什麼沒想到的嗎？」

## RDQ 內部互動預算

使用者只選擇頂層 `Quick` 或 `RDQ`。進入 RDQ 後，由 Agent 靜默選擇：

| 內部模式 | 適用情況 | 訪談 | 建議 | 確認 |
|---|---|---|---|---|
| RDQ Lite | 單一成品、半天內可完成 | 1 輪，最多 3 題 | 同輪 3–5 項 | 1 次規格卡確認 |
| RDQ Full | 多產出、跨天、公開、花錢或不可逆 | 最多 2 輪，每輪最多 4 題 | 可獨立 1 輪 | 1 次規格卡確認 |

- Full 第二輪只在第一輪答案開啟新分支時使用。
- 一輪內過半答案為「都可以／你決定」時停止追加訪談。
- 使用者說「直接做」「不用問了」「先給我初版」時，停止訪談，以現有資訊產出規格卡。
- 必要資訊已完整時可以零題坍縮，直接產出規格卡。

## 紅黃綠燈

| 等級 | 判準 | 動作 |
|---|---|---|
| 紅燈 | 答案不同會造成重做、成本、合規或不可逆影響 | 優先詢問 |
| 黃燈 | 有合理預設值 | 不詢問，列為待確認假設 |
| 綠燈 | 不影響成果是否可用 | 自行決定 |

紅燈題超出互動預算時，降級為規格卡上的待確認假設，不無限追問。

## 執行流程

### 1. 象限Ⅰ：回顯已知資訊

在目前介面、權限與任務範圍允許時，讀取：

- 使用者訊息與本對話已確認內容。
- 附件、連接資料、ChatGPT Project 或其他 Agent 可見的專案內容。
- 專案 `AGENTS.md`、薄 `CLAUDE.md`／`GEMINI.md` 入口、README、設定檔與 `HANDOFF.md`。
- 當前相關檔案與既有 RDQ 規格卡。

回顯目標、對象、產出與限制。語音輸入中推測還原的人名、日期、數字、檔名與路徑必須醒目標示。

### 2. 象限Ⅱ：先解答疑問

找出使用者已經主動提出的問題，先回答或查證；不要讓使用者帶著未解疑問進入訪談。

### 3. 象限Ⅲ：訪談

1. 讀 `rdq-question-bank.md` 的對應領域段落。
2. 依紅黃綠燈篩題，先問最可能導致返工的問題。
3. 已知資訊不可重問。
4. 選項必須具體到可以直接寫入規格，涵蓋光譜兩端與「不確定／其他」。
5. RDQ Lite 最多 3 題；第 4 個紅燈題改列為待確認假設。

### 4. 象限Ⅳ：主動提供建議

提出 3–5 項真正有用的風險、選項或替代方案。每項格式：

```text
建議 — 代價或影響
```

- 不預設採納。
- 全部不採納也能繼續。
- 未採納的項目列為「本次不納入」，不解讀為永久反對。
- RDQ Lite 必須與象限Ⅲ放在同一則訊息中。

### 5. 需求規格卡

依 `rdq-spec-template.md` 產出一頁 `draft` 規格卡：

- 一律先完整貼在對話中。
- 未問到但會影響成果的內容列為待確認假設。
- 使用者要求保存時，才寫入專案規劃資料夾。

### 6. 需求確認

在使用者明確確認前，不產出執行計劃、不實作。提供：

1. 照這份需求繼續規劃。
2. 有地方要改。
3. RDQ Full 才可選擇再問一輪。

需要修改時只改規格卡並再次確認，不重跑整套訪談。確認後改為 `status: confirmed`。

`status` 是可攜式流程契約，不宣稱是跨所有產品自動執行的機器鎖。

### 7. 交給 Brainstorm 規劃

confirmed 規格卡是後續計劃的唯一需求輸入：

- 不重問已確認事項。
- 只在不同做法會實質改變成本、風險或成果時比較方案。
- 產出執行計劃並等待第二個確認閘門。
- 只有計劃也獲得確認，才開始實作或交給下游技能。

交棒聲明：

> 需求已經過 RDQ 訪談與使用者確認。請勿重複詢問已確認事項；仍須遵守執行計劃與下游產出本身的必要確認關卡。

## 示範與研究模式

只有使用者說「示範 RDQ」「demo RDQ」或要公開介紹方法時，才：

- 顯示每個象限名稱。
- 為空象限顯示簡短佔位。
- 說明環境掃描實際找到哪些資訊。
- 讀取 `rdq-method-positioning.md` 並附上來源與研究定位。

日常使用不要增加這些儀式性內容。
AGENT_LAZYPACK_BRAINSTORM_REFERENCES_RDQ_METHOD_MD_3B1247A411

# brainstorm/references/rdq-question-bank.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/brainstorm/references/rdq-question-bank.md")"
cat > "{{SYNC_ROOT}}/skills/brainstorm/references/rdq-question-bank.md" <<'AGENT_LAZYPACK_BRAINSTORM_REFERENCES_RDQ_QUESTION_BANK_MD_1DAA75CC7D'
# RDQ 題庫：象限Ⅲ訪談與象限Ⅳ建議

只讀取任務對應領域；通用段只補充領域段沒有的問題。概念重複時只保留較具體的一版。

## 目錄

- [領域判定](#領域判定)
- [研習、演講與內部訓練](#研習演講與內部訓練)
- [簡報與投影片](#簡報與投影片)
- [機構工程與產品開發](#機構工程與產品開發)
- [影片內容](#影片內容)
- [程式與網頁專案](#程式與網頁專案)
- [通用](#通用)

## 使用規則

- 象限Ⅲ依「不問會導致多少返工」排序。
- 選項附「不確定／其他」；每輪提供「先這樣，直接開始」。
- 象限Ⅳ每次選 3–5 項，每項附代價，不預設採納。
- 題庫是選題來源，不是每次全部詢問的清單。

## 領域判定

| 任務主要成品 | domain | 讀取段落 |
|---|---|---|
| 研習、演講、工作坊、內部訓練 | `workshop` | 研習、演講與內部訓練 |
| PPTX、Google Slides、PDF、互動簡報 | `slides` | 簡報與投影片 |
| 機構設計、圖面、驗證、DFM、量產改善 | `mechanical` | 機構工程與產品開發 |
| YouTube、Shorts、直播、影片素材 | `video` | 影片內容 |
| 網頁、工具、資料庫、部署 | `dev` | 程式與網頁專案 |
| 以上皆非或尚不明確 | `general` | 通用 |

跨領域任務以主要交付物為主，另一段只補充會導致返工的問題。無法判斷時用通用段，優先確認產出形態與成功標準。

## 研習、演講與內部訓練

### 象限Ⅲ訪談題

| 題目 | 具體選項方向 | 不問的風險 |
|---|---|---|
| 參與者的背景與程度？ | 新手／有基礎／熟手／程度落差大 | 起點錯誤會重排內容與示範深度 |
| 能否登入、安裝或操作指定工具？ | 個人帳號／公司帳號受限／不能安裝／尚未確認 | 實作環節可能整段失效 |
| 裝置、網路與場地條件？ | 個人筆電／受管制電腦／只有手機／尚未實測 | 工具與互動方式可能無法執行 |
| 時間與活動比例？ | 60–90 分鐘示範／半天含實作／全天／系列活動 | 內容容量與流程差異巨大 |
| 是否錄影、公開或涉及公司機密？ | 不錄影／內部留存／未列出／公開 | 素材、案例與保密處理完全不同 |
| 主辦或主管要求的交付物？ | 投影片／講義／操作手冊／參與者成品 | 最終格式錯誤會整份重做 |

### 象限Ⅳ建議

- 為登入與安裝步驟準備短操作影片及完成品備案 — 多 1–2 小時準備，但能避免現場卡關。
- 準備斷網可用的離線或純文字版本 — 需要維護兩版，但現場故障時仍能完成。
- 事前確認錄影、入鏡、公司資料及第三方素材範圍 — 多一次溝通，降低外洩或重剪風險。
- 為程度落差準備核心路徑與進階加碼題 — 增加設計時間，但不會讓新手掉隊或熟手無聊。
- 設定活動後的具體行動與回收方式 — 增加追蹤成本，但能確認是否真正落地。

## 簡報與投影片

### 象限Ⅲ訪談題

| 題目 | 具體選項方向 | 不問的風險 |
|---|---|---|
| 誰使用、誰觀看？ | 自己講／交給同事講／主管決策／客戶審查／留檔自讀 | 資訊密度與敘事方式不同 |
| 最終檔案？ | HTML／PPTX／Google Slides／PDF | 平台與播放方式不同 |
| 現場網路與播放設備？ | 穩定／不能連外／主辦電腦／尚未實測 | 媒體、字級與互動可能失效 |
| 是否需要即時互動？ | 不需要／口頭／手機 QR／系統內操作 | 決定是否需要後端與部署 |
| 簡報時間與決策目的？ | 10 分鐘提案／30 分鐘評審／60 分鐘說明／自讀 | 頁數與論證結構不同 |
| 是否包含機密或客戶資料？ | 公開／公司內部／NDA／尚未確認 | 分享範圍錯誤可能無法回收 |

### 象限Ⅳ建議

- 鎖定最小字級並用縮圖檢查可讀性 — 內容量下降，但遠距觀看更可靠。
- 不讓顏色成為唯一資訊來源 — 增加標記工作，但提升無障礙與投影容錯。
- 做離線降級版並將必要媒體存成本機檔 — 檔案變大，但不依賴網路。
- 分成現場版與可獨立閱讀的留檔版 — 需要維護兩版，但事後閱讀不依賴講者。
- 公開前做機密、客戶資訊與授權素材掃描 — 多一道檢查，降低不可逆外洩。

## 機構工程與產品開發

### 象限Ⅲ訪談題

| 題目 | 具體選項方向 | 不問的風險 |
|---|---|---|
| 專案目前在哪個階段？ | 概念／EVT／DVT／PVT／MP／量產維護 | 可改動自由度、證據要求與時程完全不同 |
| 這次最優先的設計目標？ | 厚度／重量／強度／外觀／成本／可靠度／組裝效率 | 最佳化方向互相衝突，選錯會整體重設計 |
| 既有 envelope、keep-out 與介面凍結到什麼程度？ | 全未定／部分凍結／客戶凍結／量產規格不可改 | 接口判斷錯誤會造成跨模組重工或 ECN |
| 預計材料、製程與產量？ | CNC／鈑金／沖壓／塑膠射出／壓鑄／擠型／複合製程；試作或量產 | 肉厚、拔模、R 角、公差、模具與成本架構不同 |
| 主要載荷、環境與壽命條件？ | 靜載／跌落／衝擊／振動／溫循／濕熱／循環壽命／未定 | 驗證條件不完整會導致假安全或過度設計 |
| 這次交付物與設計基線？ | 概念報告／3D／2D／BOM／公差分析／DFMEA／驗證報告／ECN | 交付深度錯誤會漏掉審查或製造所需證據 |
| 關鍵尺寸、基準與配合由誰主導？ | 本模組／對接模組／供應商／客戶規格／尚未對齊 | 基準鏈不一致會造成裝配干涉與量產良率問題 |
| 驗收與量產判準？ | 尺寸公差／功能測試／可靠度標準／Cpk／良率／客訴門檻 | 沒有 pass/fail 標準，DVT 或量產結論無法成立 |

### 象限Ⅳ建議

- 先建立介面、keep-out、基準與變更責任矩陣 — 多一次跨部門對齊，但能避免模組間互相假設。
- 對 CTQ 做公差堆疊並明確區分 RSS、Worst Case 與量產能力 — 增加分析時間，但能在開模前發現裝配與良率風險。
- 在凍結材料與製程前，和供應商做 DFM／DFA 與模具風險審查 — 需要提前投入供應商資源，但可降低後期改模。
- 將模擬、試作與實測串成同一份驗證矩陣，明列樣本數與 pass/fail — 增加測試規劃成本，但避免只憑單點結果下結論。
- 對高風險項目建立 DFMEA、失效機制與 detection plan — 前期文件較多，但能把量產與客訴風險提前。
- 準備至少一組材料／製程替代方案及成本、重量、可靠度 trade-off — 增加評估工作，但供應或成本變動時不必從零重來。

## 影片內容

### 象限Ⅲ訪談題

| 題目 | 具體選項方向 | 不問的風險 |
|---|---|---|
| 觀眾已經知道什麼？ | 專業熟手／一般使用者／AI 新手／管理決策者 | 腳本密度與例子不同 |
| 畫面有無敏感內容？ | 全部自製／公司資料／客戶資料／第三方素材／金鑰與通知 | 公開後可能無法補救 |
| 單支、系列、短片或直播？ | 8–15 分鐘／系列／Shorts／直播 | 命名、模板與腳本結構不同 |
| 畫面怎麼產生？ | 螢幕錄影／真人出鏡／生成素材與配音／重剪舊片 | 工時與逐字稿需求差異大 |
| 上架範圍？ | 公開／未列出／公司內部／現場離線 | SEO、保密與長期連結策略不同 |
| 看完要採取什麼行動？ | 留下印象／跟做／轉發／點擊或報名 | 節奏與配套素材不同 |

### 象限Ⅳ建議

- 上片前逐段檢查金鑰、分頁、檔名、通知、公司與客戶資料 — 多 5–10 分鐘，避免敏感資訊被截圖。
- 保存音樂、圖片及第三方素材的授權證明 — 素材選擇變少，但降低下架風險。
- 重要影片先未列出，請 2–3 人試看後再公開 — 延後一天，但能在網址與觀看資料累積前修正。
- 開頭先展示成品與觀看收穫 — 增加腳本設計時間，但提高理解速度。
- 腳本預留可獨立切成短片的段落與章節時間碼 — 前期較慢，但同一素材可重複使用。

## 程式與網頁專案

### 象限Ⅲ訪談題

| 題目 | 具體選項方向 | 不問的風險 |
|---|---|---|
| 同時使用人數？ | 個人／小團隊／大型活動／公開服務／離線工具 | 併發與後端需求不同 |
| 是否呼叫 AI、誰負擔金鑰？ | 不需要／個人本機／共用金鑰／使用者自備 | 金鑰與費用架構不同 |
| 資料重整後是否保留？ | 不保留／同裝置／跨裝置／需匯出 | 決定儲存層與資料模型 |
| 是否需要身分？ | 匿名／活動碼／公司 SSO／正式登入 | 身分層牽動個資與安全規則 |
| 如何交付？ | 單一 HTML／靜態網站／伺服器／既有系統子頁 | 純前端與後端部署分歧 |
| 最差裝置與網路？ | 桌機／舊手機／大型共用 Wi-Fi／完全離線 | 版面與同步策略不同 |

### 象限Ⅳ建議

- 不把 API key 放在前端或 Git 歷史 — 增加代理層複雜度，但避免金鑰外洩。
- 設定用量上限與帳務警示 — 限制彈性，但避免費用失控。
- 一開始就設定資料庫安全規則與用量估算 — 多花設定時間，降低公開讀寫風險。
- 規劃資料刪除期限與最小化原則 — 減少長期分析資料，但降低隱私責任。
- 用最差裝置與網路做實測 — 增加測試時間，避免現場部分裝置失效。
- 從第一版提供標準格式匯出 — 多一段資料處理，但平台更換時能帶走資料。

## 通用

### 象限Ⅲ訪談題

| 題目 | 具體選項方向 | 不問的風險 |
|---|---|---|
| 最後交給誰？ | 自己／固定熟人／不特定使用者／審查單位 | 防呆、說明、授權與格式不同 |
| 絕對不能發生什麼？ | 可重做／不能覆蓋原檔／內容不能外流／有明文規定 | 不可逆錯誤代價高 |
| 在哪裡使用？ | 自己電腦／他人裝置／現場且網路不穩／長期網路存取 | 技術與交付方式不同 |
| 何時要可用？ | 今天／本週／固定死線／無死線 | 完整度與範圍選擇不同 |
| 可以花錢嗎？ | 完全免費／既有訂閱／小額／公司預算 | 工具選型可能整組更換 |
| 怎樣算成功？ | 自己認可／別人可自行完成／具體數字／通過審查 | 沒有驗收標準容易整體重做 |
| 一次性或重複使用？ | 一次／偶爾手改／固定套用／多人共用 | 過度或不足模板化 |
| 現在有什麼起點？ | 從零／零散素材／半成品／舊版改造 | 容易做出不相容的新版本 |

### 象限Ⅳ建議

- 先做結構完整但細節從簡的粗胚 — 第一版較陽春，但能提早修正方向。
- 準備壞掉時的離線、靜態或純文字備案 — 多維護一份替代品，降低中斷風險。
- 交付前檢查個資、機密、授權素材與公開範圍 — 多一道掃描，避免難以回收的外洩。
- 明確列出本次不做的功能 — 本次範圍較小，但更容易準時完成。
- 盤點既有檔案、模板、技能或專案後再決定是否重做 — 增加短暫盤點時間，可能大幅減少重工。
AGENT_LAZYPACK_BRAINSTORM_REFERENCES_RDQ_QUESTION_BANK_MD_1DAA75CC7D

# brainstorm/references/rdq-spec-template.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/brainstorm/references/rdq-spec-template.md")"
cat > "{{SYNC_ROOT}}/skills/brainstorm/references/rdq-spec-template.md" <<'AGENT_LAZYPACK_BRAINSTORM_REFERENCES_RDQ_SPEC_TEMPLATE_MD_44F6FA8BE8'
# RDQ 需求規格卡模板

將規格卡控制在約 40 行內，讓使用者能在一個螢幕掃完。

## 交付與儲存

- 一律先完整貼在對話中。
- 只有使用者要求保存時，才寫入 `100_Todo/projects/brainstorm/rdq/RDQ-spec-<任務slug>-<YYYYMMDD>.md`。
- 若專案已有規劃目錄或使用者指定位置，沿用該位置。
- 沒有檔案系統時，只使用對話內 Markdown。
- `status` 是工作流程契約，不是跨所有產品自動執行的機器鎖。

## 模板

```markdown
---
rdq_version: 1
edition: cross-agent-brainstorm
task: <一句話任務，30 字內>
domain: <workshop|slides|mechanical|video|dev|general>
date: <YYYY-MM-DD>
status: draft
telemetry:
  mode: <lite|full>
  rounds: <訪談輪數>
  questions: <總題數>
  q4_adopted: <象限Ⅳ採納條數>
  revisions: 0
downstream: brainstorm
---

# RDQ 需求規格：<任務名>

## 一句話任務
<一句能單獨看懂的任務描述>

## 已確認
- <使用者明說、環境掃描或訪談確認的需求>

## 待確認假設
- <未詢問或跳過的項目> → 預設採 <值>

## 已採納建議
- <象限Ⅳ採納的建議>

## 本次不納入
- <這次明確不做或未採納的項目>

## 一段式需求規格
<能獨立交給 Brainstorm 規劃的完整一段話；人名、日期、數字、檔名與路徑使用粗體>

## 驗收條件
- [ ] <可實際檢查的條件，2–4 項>
```

## 欄位規則

- `draft`：尚未取得使用者明確確認，不得產出執行計劃或製作成品。
- `confirmed`：使用者已確認，可交回 Brainstorm 產出執行計劃。
- `telemetry`：只作描述性紀錄，不作為效果因果證據；沒有持久檔案時可省略。
- `revisions`：只有規格卡持久保存且能更新時才維護。
- 「本次不納入」代表本次範圍決定，不代表永久反對。

## 寫作要求

- 使用繁體中文。
- 關鍵詞醒目標示，讓語音輸入的同音錯字有最後一道人工確認。
- 未問到但會影響成果的內容必須列入待確認假設。
- 一段式需求規格不可使用「如上」「同前」等依賴上文的說法。
- 日常模式省略空段落；示範模式才保留空象限。
- 機構工程任務使用 `domain: mechanical`，不要使用原始來源的 `lesson`。
AGENT_LAZYPACK_BRAINSTORM_REFERENCES_RDQ_SPEC_TEMPLATE_MD_44F6FA8BE8

# brainstorm/references/source-adaptation.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/brainstorm/references/source-adaptation.md")"
cat > "{{SYNC_ROOT}}/skills/brainstorm/references/source-adaptation.md" <<'AGENT_LAZYPACK_BRAINSTORM_REFERENCES_SOURCE_ADAPTATION_MD_6047167E40'
# Brainstorm／RDQ 來源轉換說明

## 現行架構

- 唯一 skill ID：`brainstorm`。
- 使用者入口：Quick 或 RDQ。
- Quick 保留既有 Brainstorm 的假設回顯、方案比較、計劃書與確認閘門。
- RDQ 作為內建深度模式，使用四象限需求探索、互動預算、紅黃綠燈與需求規格卡。
- 共用 package 安裝在 `{{SYNC_ROOT}}/skills/brainstorm/`；Codex、Claude、AntiGravity 使用各自原生入口讀取同一主版本。

## 來源

### 既有 Brainstorm

- 來源摘要：`04-brainstorm.md`、「AI 規劃模式 by 雷小蒙」與 `obra/superpowers` brainstorming skill。
- 保留：先釐清再實作、假設回顯、方案比較、計劃書與確認閘門。
- 授權紀錄：原始說明標示雷小蒙版本為 CC BY-NC-SA 4.0；`obra/superpowers` 為 MIT。現行檔案只保存三 Agent 共用的改編流程與摘要，不複製原始安裝全文。

### RDQ ChatGPT／Codex 版

- Repo：`https://github.com/mathruffian-dot/rdq-skill-chatgpt-app`
- 參考 commit：`ad893a6153a7991f45a05912c6f648446ad39dca`
- 授權：MIT。
- 採用：ChatGPT Project／附件／連接資料能力感知、無結構化 UI 時的純文字同輪降級、可攜式 `status` 說明、`agents/openai.yaml`。

### RDQ Claude 版

- Repo：`https://github.com/mathruffian-dot/rdq-skill`
- 參考 commit：`c8ea601faed67ae3c502b21663f4670112ef0270`
- 授權：MIT。
- 採用：象限動詞鎖定、紅黃綠燈、互動預算、停止條件、跨領域補題方法與 confirmed spec 交棒契約。

## 三 Agent 轉換

- 移除只適用單一 Agent 的全域 skill 路徑與安裝命令。
- 不把 Claude 的結構化提問工具當成共用依賴；Codex、Claude、AntiGravity 有原生選項 UI 時使用，沒有時一律降級成純文字編號。
- 不硬編碼來源 repo 的教育類下游 skills；confirmed 規格卡先交回 Brainstorm 產出計劃，再依目前環境路由到真正存在的執行 skill。
- ChatGPT／Codex 的 `agents/openai.yaml` 只作 UI adapter，不改變 Claude 或 AntiGravity 的行為。
- 專案規則以 `AGENTS.md` 為共用主版本；Claude 與 AntiGravity 只使用各自的薄入口 adapter。

## 使用者專屬調整

- 每次觸發且未指定模式時，第一個問題固定詢問 Quick 或 RDQ。
- 原本 Brainstorm 的溝通深度選擇改為預設半技術並自動調整，避免連續兩次模式詢問。
- RDQ 來源中的 `lesson` 教材領域已完整移除，改為 `mechanical` 機構工程與產品開發。
- mechanical 題庫涵蓋產品階段、設計目標、介面、材料製程、載荷環境、基準公差、驗收、DFM／DFA、DFMEA 與量產風險。
- 規格卡與計劃只有在使用者要求保存時才寫入 `100_Todo/projects/brainstorm/`，不在專案根目錄建立 `rdq/` 或 `plans/`。
AGENT_LAZYPACK_BRAINSTORM_REFERENCES_SOURCE_ADAPTATION_MD_6047167E40

test -f "{{SYNC_ROOT}}/skills/brainstorm/SKILL.md" && echo "brainstorm installed for Codex, Claude, and AntiGravity"
````

安裝完成後，請開新 Agent 對話或重啟對應 App，再測試 skill 是否能被讀取。

<!-- END EMBEDDED_SKILLS -->
