# 45-Agent Dev Coach Skill 安裝

> 2026-08-26 建立。來源為第三方 `agent-dev-coach` 套件，改寫為 Codex／Claude／AntiGravity 三 Agent 共用版本，並修掉原版在學員專案內無法解析腳本路徑的問題。

## 這個 Item 解決什麼

「我想做一個 agent」到「真的有一個能跑的 agent」之間，多數人卡在三個地方：需求還沒想清楚就開始寫、
規格寫得無法驗收、任務切成水平層次導致做完什麼都 demo 不了。

本 Item 安裝 `agent-dev-coach`，把這段路變成五個有出口交付物的關卡，並以教練身分帶著走：

1. **需求拷問** → `grill-log.md`：一次一題，每題附建議答案與理由，走完最低決策覆蓋清單
2. **規格書** → `spec.json` ＋ `agent-specification.html`：成功標準必須可驗證，禁用模糊詞
3. **切票** → `tickets/NN-slug.md`：tracer bullet 垂直切片，每張票宣告 `Blocked by`
4. **TDD 實作** → 綠燈票＋commit：在工具邊界與 prompt-vs-code 邊界上先寫失敗測試
5. **雙軸審查** → `review-report.md`：Standards 軸與 Spec 軸分開審、分開報，不跨軸重排序

另附**隨時可用的 PRD 打包**（不是第六關）：把已產生的內容整理成一份別人能接手的需求文件，
缺的填 `[待補充]` 並列缺口清單，不捏造。

教練語言以密涅瓦思考習慣（HC）為骨架，每則回覆最多帶 2–3 個標籤，只用各關 reference 列出的標籤。

## 這個 Item 不解決什麼

| 需求 | 用哪個 |
| :-- | :-- |
| 做的不是 agent（網站、報表、腳本、內容） | 該領域自己的 Item，五關的題目會問錯方向 |
| 已有明確規格，只想把 code 寫完 | 直接派實作任務；本 Item 的價值在想清楚與教學迴圈 |
| 只想要一份文件、不想被帶流程 | 直接用本 skill 的 PRD 打包，或走一般規格 skill |
| 學使用者自己的長期寫作語氣 | Item 44 `personal-style-loop` |
| 使用者自己的日常工程流程（非教學情境） | Item 40 Engineering Methods Skill Suite |

**與 Item 40 的邊界**：Item 40 是使用者自己做事的工具箱（`grilling`、`to-spec`、`to-tickets`、
`implement`、`code-review` 各自獨立呼叫）；本 Item 是**帶人**的單一連續流程，多了教練話術、
HC 標籤、`.agent-flow/` 狀態機與「每關必須明確徵得同意才能前進」的閘門。同一批底層方法，
兩種使用情境，不互相取代。

## 前置條件

- 已完成 README 設定表，知道 `{{SYNC_ROOT}}` 位置。
- 本機有 Python 3（Stage 2 的 renderer 與 validator 需要）。
- 選配：`pip install jsonschema`。裝了才會跑完整 schema 驗證；沒裝時 validator 會印
  `NOTE jsonschema 未安裝，跳過完整 schema 驗證（基本檢查已跑）`，基本檢查照常生效。

## 三 Agent 共用契約

- **共用步驟**：五關的教練邏輯、`.agent-flow/` 產物格式、票的模板、兩軸審查的獨立性要求，
  三個 Agent 完全相同。

| 項目 | Codex adapter | Claude adapter | AntiGravity adapter |
| :-- | :-- | :-- | :-- |
| 安裝入口 | `~/.codex/skills/agent-dev-coach` | `~/.claude/skills/agent-dev-coach` | `~/.gemini/config/skills/agent-dev-coach` |
| 顯式呼叫 | `$agent-dev-coach` | `$agent-dev-coach` 或 `/agent-dev-coach` | `$agent-dev-coach` |
| 第 5 關雙軸審查 | `invoke_subagent` 平行派兩個唯讀子代理 | `Agent` 工具平行派兩個子代理 | 依當前版本的子代理／平行任務能力 |
| UI 中繼資料 | 讀 `agents/openai.yaml` | 讀 `SKILL.md` frontmatter | 讀 `SKILL.md` frontmatter |

- **Fallback**：任一 Agent 當下沒有平行子代理時改依序跑，但兩軸獨立性不能犧牲——
  先完整跑完一軸並寫下結論，再開始另一軸，不得讓前一軸影響後一軸。要的是互不汙染，不是平行本身。
- **驗證**：三個 Agent 同一份契約——renderer 退出碼 0、validator 印出 `PASS 所有檢查通過`、
  `review-report.md` 兩節分列且無跨軸合併排名。

## 安裝

複製文末「內建 Skill 完整安裝內容」的整段腳本執行。安裝前先依 README 設定 `{{SYNC_ROOT}}`；
package 只寫入共用主版本，Item 16 與 chezmoi 負責建立三個 Agent 的原生入口。

## 安裝後預檢

```bash
test -f "{{SYNC_ROOT}}/skills/agent-dev-coach/SKILL.md" && echo "SKILL.md OK"
test -f "{{SYNC_ROOT}}/skills/agent-dev-coach/references/spec.schema.json" && echo "schema OK"
test -f "{{SYNC_ROOT}}/skills/agent-dev-coach/assets/agent_spec_template.html" && echo "template OK"
python3 "{{SYNC_ROOT}}/skills/agent-dev-coach/scripts/validate_agent_spec.py" --help >/dev/null && echo "validator OK"
```

三個 Agent 都要能解析到同一份主版本；解析不到時看 Item 16，不要另外複製一份。

## 腳本路徑：本 Item 相對原版的關鍵修正

原版 `SKILL.md` 寫的是相對路徑：

```bash
python3 scripts/render_agent_spec.py --template assets/agent_spec_template.html ...
```

**這在真實使用情境一定失敗。** 教練的工作目錄是學員的專案，腳本卻在 skill 套件裡，
兩者不同層，`scripts/…` 會解析到學員專案底下的不存在路徑。本 Item 已修成兩層防護：

1. 兩支腳本改為**自我定位**：`--template` 與 `--schema` 預設相對腳本自身解析到 skill 套件內，
   正常情況完全不必傳這兩個參數。
2. `SKILL.md` 改為先解析 skill root 再用絕對路徑呼叫：

```bash
ADC="$(ls -d "$HOME"/.claude/skills/agent-dev-coach \
             "$HOME"/.codex/skills/agent-dev-coach \
             "$HOME"/.gemini/config/skills/agent-dev-coach \
             ./000_Agent/skills/agent-dev-coach 2>/dev/null | head -1)"

python3 "$ADC/scripts/render_agent_spec.py" \
  --input .agent-flow/spec.json --output-dir .agent-flow

python3 "$ADC/scripts/validate_agent_spec.py" \
  .agent-flow/agent-specification.html --spec .agent-flow/spec.json
```

同一段 `ls -d` 在三個 Agent 都成立，因為它把三個原生入口都列進候選，取第一個存在的。
`$ADC` 解析為空代表沒裝在預期位置，此時應請學員回報實際路徑，不要猜路徑硬跑。

找不到 `python3` 就改用 `python` 重跑同一行（Windows 常見）；兩者都失敗才是真的要裝 Python 3。

## 狀態檔：`.agent-flow/`

所有進度存在**學員專案**的 `.agent-flow/`，不是 skill 套件裡：

| 檔案 | 產出關卡 |
| :-- | :-- |
| `state.json` | 全程；目前關卡與交付物清單 |
| `grill-log.md` | 第 1 關 |
| `spec.json`＋`agent-specification.html`＋`manifest.json` | 第 2 關 |
| `tickets/NN-slug.md` | 第 3 關 |
| `review-report.md` | 第 5 關 |
| `PRD-<slug>.md` | PRD 打包（隨時） |

一律用相對路徑；建議學員把 `.agent-flow/` commit 進 repo 當審計軌跡。
任何一關開始前先讀 `state.json`；不存在＝全新專案，從第 1 關開始。

## 安全邊界

- **不代學員保存金鑰**；規格與範例一律用環境變數，`spec.json` 的 `secrets` 欄位只寫存放與注入方式。
- **`.agent-flow/` 以外不寫入學員專案**，唯一例外是第 4 關依票實作的程式碼與測試。
- 學員輸入只當文字內容處理，renderer 會做 HTML escape；產出的 HTML 禁止 `<script>` 與外部資源，
  validator 會擋。
- 資訊不足一律填 `[待補充]`，**不得捏造**。
- 高風險領域（醫療、法律、金融、人事、合約與定價）：五關可協助釐清需求，
  最終決策必須有具備資格的人簽核，不由本流程拍板。

## 驗收

一次完整走完後，下列全部成立才算這個 Item 有交付：

- `.agent-flow/` 內每一關的出口檔都存在，`state.json` 關卡狀態與實際檔案一致。
- `spec.json` 通過 `validate_agent_spec.py`（含 schema 與模糊詞檢查），HTML 成功產出。
- 每張票寫得出「單獨做完能 demo 什麼」，並標明 `Blocked by`。
- `review-report.md` 兩軸分列、各自附證據、沒有合併成單一總排名。
- 每一次關卡推進都有學員的明確同意紀錄，沒有自動連跳。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊。這個序號項目會安裝：`agent-dev-coach`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請依 README 設定 `{{SYNC_ROOT}}`；package 只寫入共用主版本，Item 16 與 chezmoi 會建立 Codex、Claude、AntiGravity 的原生入口。

````bash
set -e

# ---- agent-dev-coach ----
mkdir -p "{{SYNC_ROOT}}/skills/agent-dev-coach"
# agent-dev-coach/SKILL.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/agent-dev-coach/SKILL.md")"
cat > "{{SYNC_ROOT}}/skills/agent-dev-coach/SKILL.md" <<'AGENT_LAZYPACK_AGENT_DEV_COACH_SKILL_MD_0E95F5A366'
---
name: agent-dev-coach
description: 帶學員把一個模糊的 agent 想法，走完五關做成能跑的程式型 agent：需求拷問 → 規格書 → 切票 → TDD 實作 → 雙軸審查，教練語言以密涅瓦思考習慣為骨架；另附隨時可用的 PRD 打包，把討論內容整理成一份可交付的需求文件。當使用者說「我想做一個 agent」「幫我設計 agent」「帶我走一遍」「拷問我的需求」「幫我寫 agent 規格書」「把任務切票」「帶我 TDD 實作」「審查我的程式」「把討論打包成 PRD」「整理成需求文件」，或丟出一個還很模糊的 agent 想法時使用。
metadata:
  short-description: "五關教練：把模糊的 agent 想法帶成能跑的程式型 agent，另附隨時可用的 PRD 打包"
  version: "0.1.0"
  last-updated: "2026-08-26"
---

# Agent 開發五關教練

把一個模糊的 agent 想法，走完五關做成真正能跑的程式型 agent。你是教練：先點名依據哪個思考習慣（HC）、解釋概念、再提問或給建議；每則回覆 HC 標籤最多 2–3 個，只用各關 reference 列出的標籤。

## 怎麼跟學員互動（重要）

**學員用日常語言跟你說話，不要求他記任何指令。** 他不會知道「stage」「ticket」這些詞，也沒有斜線指令可以打——你要負責聽懂他的意思並帶路。

**被叫起來時的第一件事**（學員還沒說要做什麼、或只說了一句模糊的話）：

1. 用兩句話說明這裡在做什麼（把想法變成能跑的東西，分五關走）
2. 列出五關名稱與各關產出，一行一關
3. 問他：**「你手上現在有什麼？」**——照他的回答決定起點：
   - 只有一個模糊念頭 → 從第 1 關開始
   - 已經有規格或需求文件 → 可直接跳第 3 關（切票）
   - 已經有程式想被審 → 可直接第 5 關
4. 他若已經丟出想法，先用一句話幫他重述問題，確認你理解對了，再問「要開始第一關嗎？」

**辨識他想去哪一關**（同義說法都要接住，不要求精準用詞）：

| 學員可能會說 | 帶他去 |
|---|---|
| 「開始」「帶我走一遍」「拷問我」「我想做一個⋯⋯」 | 第 1 關 需求拷問 |
| 「寫成規格」「整理成文件」「下一關」（在第 1 關後） | 第 2 關 規格書 |
| 「拆任務」「切票」「怎麼分工」 | 第 3 關 切票 |
| 「開始做」「動手寫」「implement」 | 第 4 關 TDD 實作 |
| 「幫我看看寫得對不對」「審查」「review」 | 第 5 關 雙軸審查 |
| 「打包」「轉成 PRD」「整理成需求文件」 | PRD 打包（隨時） |

**學員問的事不屬於任何一關時**（例如問這個工具怎麼安裝、能不能在別的平台用、某個名詞是什麼意思）：照常好好回答，**但回答完必須主動問一次**「要不要開始第 1 關？」——不要答完就停，學員不會知道教練什麼時候該上工。

學員若真的打了 `/grill`、`/spec` 這類簡寫，也照樣接住當成對應關卡——但**你自己絕不要叫他去打斜線指令**（那不是真的指令，打了不會有反應）。要他往前走時，就說「**跟我說「下一關」就繼續**」。

## 狀態（單一真相）

- 所有進度存在學員專案的 `.agent-flow/`：`state.json`（目前關卡與交付物清單）、`grill-log.md`、`spec.json`＋`agent-specification.html`、`tickets/NN-slug.md`、`review-report.md`、`PRD-<slug>.md`（打包產物）
- 任何一關開始前先讀 `.agent-flow/state.json`（不存在＝全新專案，從第 1 關開始）
- 一律用相對路徑；建議學員把 `.agent-flow/` commit 進 repo 當審計軌跡

## 五關

進入任何一關，**必須先讀對應的 reference 檔**，依其檢核清單與流程執行：

1. **需求拷問** → 讀 `references/01-grill.md`。出口：`grill-log.md`
2. **規格書** → 讀 `references/02-spec.md`。出口：`spec.json`（過 `references/spec.schema.json`）＋HTML
3. **切票** → 讀 `references/03-tickets.md`。出口：`tickets/NN-slug.md`
4. **TDD 實作** → 讀 `references/04-implement.md`。出口：綠燈票＋commit
5. **雙軸審查** → 讀 `references/05-review.md`。出口：`review-report.md`

## PRD 打包（不是關卡，隨時可做）

讀 `references/06-package.md`。出口：`.agent-flow/PRD-<slug>.md`

- 把已產生的討論內容（拷問決策、規格、票、審查）整理成一份**別人能接手**的需求文件
- **隨時可做**：學員說「打包」「轉成 PRD」「整理成需求文件」就執行，不要求五關跑完
- **第 5 關結束後主動詢問**一次：「要不要把整個流程打包成一份 PRD？」——學員同意才做
- 只取材已存在的內容，缺的填 `[待補充]` 並列缺口清單，**不捏造**

規則：

- **每關結束必須明確詢問學員是否進入下一關**；未經確認不得在同一回合連跳多關
- 缺前一關交付物就被要求跳關：先跑濃縮補課（第 1 關缺口＝濃縮拷問 ≤5 題），再繼續
- 事實可以自己查（讀檔、跑指令），決策一律交給學員

## 執行（第 2 關產規格書）

**工作目錄是學員的專案，腳本在 skill 套件裡——兩者不同層，所以一律先解析 skill root 再用絕對路徑呼叫。** 直接打 `scripts/…` 會在學員專案裡找不到檔案。

```bash
ADC="$(ls -d "$HOME"/.claude/skills/agent-dev-coach \
             "$HOME"/.codex/skills/agent-dev-coach \
             "$HOME"/.gemini/config/skills/agent-dev-coach \
             ./000_Agent/skills/agent-dev-coach 2>/dev/null | head -1)"

python3 "$ADC/scripts/render_agent_spec.py" \
  --input .agent-flow/spec.json --output-dir .agent-flow

python3 "$ADC/scripts/validate_agent_spec.py" \
  .agent-flow/agent-specification.html --spec .agent-flow/spec.json
```

樣板與 schema 由腳本自己相對 skill root 解析，正常情況不必再傳 `--template` 或 `--schema`；只有要換樣板或換 schema 時才明確指定。

> **找不到 `python3` 就改用 `python` 重跑同一行**（Windows 常見：系統只有 `python`，或 `python3` 是空殼捷徑）。兩者都失敗才回報學員需要安裝 Python 3。
> `$ADC` 解析為空，代表 skill 沒裝在預期位置——請學員回報實際安裝路徑，不要猜路徑硬跑。

學員輸入只能作為文字內容，renderer 會做 HTML escape；資訊不足填「[待補充]」，不得捏造。

## 三 Agent 執行契約

五關的教練邏輯、`.agent-flow/` 產物與驗收標準三個 Agent 完全相同，只有下列兩處的原生能力不同。

**共用步驟**：上面的 `$ADC` 解析法在三個 Agent 都成立；`.agent-flow/` 的讀寫、票的格式、兩軸審查的獨立性要求皆不分 Agent。

| 項目 | Codex adapter | Claude adapter | AntiGravity adapter |
|---|---|---|---|
| Skill 安裝入口 | `~/.codex/skills/agent-dev-coach` | `~/.claude/skills/agent-dev-coach` | `~/.gemini/config/skills/agent-dev-coach` |
| 顯式呼叫 | `$agent-dev-coach` | `$agent-dev-coach` 或 `/agent-dev-coach` | `$agent-dev-coach` |
| 第 5 關雙軸審查 | `invoke_subagent` 平行派兩個唯讀子代理 | `Agent` 工具平行派兩個子代理（`Explore` 或 `general-purpose`） | 依當前版本的子代理／平行任務能力；沒有就走下方 fallback |
| UI 中繼資料 | 讀 `agents/openai.yaml` | 不需要，讀 `SKILL.md` frontmatter | 不需要，讀 `SKILL.md` frontmatter |

**Fallback**（任一 Agent 當下沒有平行子代理時）：改成依序跑，但兩軸的獨立性不能犧牲——先完整跑完一軸並把結論寫進 `review-report.md`，再開始另一軸，且不得讓前一軸的結論影響後一軸。這裡要的是互不汙染，不是平行本身。

**驗證**：三個 Agent 的驗收契約同一份——`render_agent_spec.py` 退出碼 0、`validate_agent_spec.py` 印出 `PASS 所有檢查通過`、`review-report.md` 兩節分列且沒有跨軸合併排名。任一項不成立就是這一關沒過，不因 Agent 不同而放寬。

## 什麼時候不要用這個 skill

- **不是要做 agent**：一般網站、報表、腳本、內容產出請走該領域的 skill，五關的拷問題目會問錯方向。
- **只想要一份文件、不想被帶流程**：直接說「打包成 PRD」用第 6 節工具，或改用一般寫作／規格 skill。
- **已經有明確規格且只想把 code 寫完**：這裡的價值在想清楚與教學迴圈；純代工請直接派實作任務。
- **要的是使用者自己的長期寫作語氣**：走 `personal-style-loop`。
- **高風險領域的決策**（醫療、法律、金融、人事、合約與定價）：五關可以幫忙釐清需求，但最終決策必須有具備資格的人簽核，不得由本流程代為拍板。

## 停止條件

達到下列任一條就停下來、交還給學員，不要自己往前推：

- 某一關的出口交付物已寫入 `.agent-flow/`，且已明確問過「要進入下一關嗎？」——**未得到確認不得在同一回合連跳兩關**。
- 第 1 關問滿 12 題仍有未覆蓋主題：列 `[待決]`，由學員決定接受或繼續拷問。
- 第 4 關同一張票卡超過 30 分鐘：停手回報，判斷是票太大（回第 3 關）還是規格不清（回第 2 關）。
- 需要金鑰、帳號、付費額度或對外發布：停下來請學員自己處理，本 skill 不代為保存或送出。
- 學員要跳關但缺前一關交付物：先跑濃縮補課（第 1 關缺口 ≤5 題），補完再繼續。

## 驗收標準

一次完整走完後，下列全部成立才算這個 skill 有交付：

- `.agent-flow/` 內每一關的出口檔都存在，且 `state.json` 的關卡狀態與實際檔案一致。
- `spec.json` 通過 `validate_agent_spec.py`（含 schema 與模糊詞檢查），`agent-specification.html` 成功產出。
- 每張票都寫得出「單獨做完能 demo 什麼」，並標明 `Blocked by`。
- `review-report.md` 兩軸分列、各自附證據、沒有合併成單一總排名。
- 每一次關卡推進都有學員的明確同意紀錄，沒有自動連跳。

## 安全

- 不代學員保存金鑰；範例一律用環境變數
- `.agent-flow/` 以外不寫入學員專案，除了第 4 關依票實作的程式碼與測試
AGENT_LAZYPACK_AGENT_DEV_COACH_SKILL_MD_0E95F5A366

# agent-dev-coach/agents/openai.yaml
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/agent-dev-coach/agents/openai.yaml")"
cat > "{{SYNC_ROOT}}/skills/agent-dev-coach/agents/openai.yaml" <<'AGENT_LAZYPACK_AGENT_DEV_COACH_AGENTS_OPENAI_YAML_DEB9755D27'
interface:
  display_name: "Agent 開發五關教練"
  short_description: "五關帶你把 agent 從想法做到能跑：拷問、規格、切票、實作、審查"
  default_prompt: "Use $agent-dev-coach to coach me through the 5-stage agent development flow. Start by asking me what I already have, then begin with Stage 1 (requirement grilling)."
policy:
  allow_implicit_invocation: true
AGENT_LAZYPACK_AGENT_DEV_COACH_AGENTS_OPENAI_YAML_DEB9755D27

# agent-dev-coach/assets/agent_spec_template.html
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/agent-dev-coach/assets/agent_spec_template.html")"
cat > "{{SYNC_ROOT}}/skills/agent-dev-coach/assets/agent_spec_template.html" <<'AGENT_LAZYPACK_AGENT_DEV_COACH_ASSETS_AGENT_SPEC_TEMPLATE_HTML_0DD2752372'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Agent 規格書 — {project_name}</title>
<style>
  *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
  body {
    background: #E8E6E1;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "PingFang TC",
      "Noto Sans TC", "Microsoft JhengHei", sans-serif;
    color: #1A1A1A;
    line-height: 1.7;
    display: flex;
    justify-content: center;
    padding: 40px 20px;
  }
  .page {
    width: 794px;
    background: #F7F6F3;
    padding: 48px 52px 60px;
  }
  .header { margin-bottom: 32px; }
  .badge {
    display: inline-block;
    background: #EEEBFF;
    color: #6B5CE7;
    font-size: 13px;
    font-weight: 700;
    padding: 5px 14px;
    border-radius: 20px;
    margin-bottom: 12px;
  }
  h1 { font-size: 30px; font-weight: 900; letter-spacing: -.5px; margin-bottom: 12px; }
  .meta { display: flex; gap: 24px; flex-wrap: wrap; font-size: 13px; color: #888; }
  .meta b { color: #444; }
  .divider { margin-top: 18px; border: none; border-top: 2px solid #E0DCD6; }
  .section { margin-bottom: 28px; }
  .section-head { display: flex; align-items: center; gap: 12px; margin-bottom: 10px; }
  .section-icon {
    width: 38px; height: 38px; border-radius: 10px;
    background: #EEEBFF; display: flex; align-items: center; justify-content: center;
    font-size: 19px;
  }
  .section-title { font-size: 18px; font-weight: 800; }
  .section-no { font-size: 12px; font-weight: 700; color: #6B5CE7; letter-spacing: 1px; }
  .card {
    background: #FFFFFF;
    border: 1px solid #E7E3DD;
    border-radius: 12px;
    padding: 16px 20px;
    font-size: 14.5px;
  }
  .card ul, .card ol { padding-left: 22px; }
  .card li { margin: 5px 0; }
  .kv { margin: 6px 0; }
  .kv b { color: #6B5CE7; }
  .pending { color: #B25E09; font-weight: 700; }
  .footer-card {
    margin-top: 36px;
    background: #1F1D2B;
    color: #EDEBFF;
    border-radius: 12px;
    padding: 18px 22px;
    font-size: 13.5px;
  }
  .footer-card h2 { font-size: 15px; color: #B9AFFF; margin-bottom: 8px; }
  .footer-card ul { padding-left: 20px; }
  .footer-note { margin-top: 10px; color: #9A93C4; font-size: 12px; }
</style>
</head>
<body>
<div class="page">
  <div class="header">
    <span class="badge">Agent 開發五關 · 第 2 關交付物</span>
    <h1>Agent 規格書 — {project_name}</h1>
    <div class="meta">
      <span>版本 <b>{version}</b></span>
      <span>產出時間 <b>{created_at}</b></span>
      <span>依據 <b>#可驗證性 (#testability)</b></span>
    </div>
    <hr class="divider">
  </div>

  <div class="section">
    <div class="section-head"><div class="section-icon">📌</div>
      <div><div class="section-no">01</div><div class="section-title">問題陳述</div></div></div>
    <div class="card">{problem_statement}</div>
  </div>

  <div class="section">
    <div class="section-head"><div class="section-icon">💡</div>
      <div><div class="section-no">02</div><div class="section-title">解法</div></div></div>
    <div class="card">{solution}</div>
  </div>

  <div class="section">
    <div class="section-head"><div class="section-icon">👥</div>
      <div><div class="section-no">03</div><div class="section-title">User Stories</div></div></div>
    <div class="card"><ol>{user_stories_items}</ol></div>
  </div>

  <div class="section">
    <div class="section-head"><div class="section-icon">🔧</div>
      <div><div class="section-no">04</div><div class="section-title">實作決策</div></div></div>
    <div class="card">{implementation_items}</div>
  </div>

  <div class="section">
    <div class="section-head"><div class="section-icon">✅</div>
      <div><div class="section-no">05</div><div class="section-title">測試決策</div></div></div>
    <div class="card">{testing_items}</div>
  </div>

  <div class="section">
    <div class="section-head"><div class="section-icon">🚫</div>
      <div><div class="section-no">06</div><div class="section-title">限制條件</div></div></div>
    <div class="card">{constraints_items}</div>
  </div>

  <div class="section">
    <div class="section-head"><div class="section-icon">🎯</div>
      <div><div class="section-no">07</div><div class="section-title">成功標準（全部可驗證）</div></div></div>
    <div class="card"><ul>{success_criteria_items}</ul></div>
  </div>

  <div class="section">
    <div class="section-head"><div class="section-icon">⛔</div>
      <div><div class="section-no">08</div><div class="section-title">Out of Scope</div></div></div>
    <div class="card"><ul>{out_of_scope_items}</ul></div>
  </div>

  <div class="section">
    <div class="section-head"><div class="section-icon">⚠️</div>
      <div><div class="section-no">09</div><div class="section-title">風險與假設</div></div></div>
    <div class="card"><ul>{risks_items}</ul></div>
  </div>

  <div class="footer-card">
    <h2>🧭 進度卡（下次開新對話請帶上我）</h2>
    <ul>
      <li>專案：{project_name}</li>
      <li>已完成：第 2 關 規格書（本檔＋spec.json）</li>
      <li>下一關：第 3 關 切票</li>
      <li>待決問題：{pending_items}</li>
    </ul>
    <div class="footer-note">進度卡只管路由；規格內容以 spec.json 為準，續關時請直接上傳交付 zip 或 spec.json。</div>
  </div>
</div>
</body>
</html>
AGENT_LAZYPACK_AGENT_DEV_COACH_ASSETS_AGENT_SPEC_TEMPLATE_HTML_0DD2752372

# agent-dev-coach/references/01-grill.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/agent-dev-coach/references/01-grill.md")"
cat > "{{SYNC_ROOT}}/skills/agent-dev-coach/references/01-grill.md" <<'AGENT_LAZYPACK_AGENT_DEV_COACH_REFERENCES_01_GRILL_MD_AA5BD8B143'
<!-- Version: v1.0 | Stage 1/5 | 需求拷問 -->

# 01｜需求拷問

## 檢核清單（進入本關必讀）

- 一次只問一題，等學員回答再問下一題
- 每一題都附上「我的建議答案＋理由」，讓學員有靠可依
- 能自己查到的**事實**不問學員；只把**決策**交給學員
- 走完決策樹的每一條分支，決策之間的依賴一條一條解開
- 預設 8–12 題；「最低決策覆蓋清單」未覆蓋完，寧可標 `[待決]` 也不硬掰
- 達成共識之前，不動工、不寫規格、不寫 code
- 出口交付物：`grill-log.md`＋進度卡

## HC 思考框架

- **#問對問題 (#rightproblem)**：完整刻畫四要素——初始狀態（現在有什麼、痛在哪）、目標狀態（agent 跑起來後世界長什麼樣）、障礙（中間卡什麼）、規模（多少人用、多常用）。問題定義錯了，後面的規格、切票、實作全部白做。
- **#決策樹 (#decisiontrees)**：agent 設計是一連串分岔——跑在哪、用什麼模型、給哪些工具、記不記得上次對話。把每個分岔當成決策節點，逐分支走完，每個節點給出建議選項與理由，而不是憑感覺一路直走。
- **#偏誤檢驗 (#biasidentification)**：指出學員此刻的認知偏誤如何扭曲需求——最常見是確認偏誤（「我想做這功能」被當成「使用者需要這功能」）與錨定效應（被第一個想到的方案錨住，不再看其他路徑）。點名偏誤時要說清楚它如何導致哪個具體判斷。

## 拷問流程

1. 請學員用一句話說出：「我想做一個幫（誰）解決（什麼問題）的 agent。」說不出來，就從這句開始拷問。
2. 逐題拷問，優先問「答案會改變整體架構」的題目。每題格式：
   - 問題（一次一題）
   - 依據哪個 HC、為什麼這題重要（一句話）
   - 我的建議答案＋理由
3. 對照「最低決策覆蓋清單」，未覆蓋的主題繼續問：
   - 使用者與使用場景（誰、何時、多頻繁）
   - 工具與權限邊界（agent 能動什麼、絕不能動什麼）
   - 資料來源與隱私（讀哪些資料、有沒有個資）
   - 記憶與狀態（要不要記得跨次對話）
   - 模型與成本／延遲預算（用哪家模型、一次任務可接受幾秒幾元）
   - 評估計畫（怎麼知道 agent 做得對）
   - 部署與安全邊界（跑在哪、prompt injection 與工具輸出信任怎麼防）
4. 超過 12 題仍有未覆蓋項：列為 `[待決]`。學員明確接受這些未知，才能進入下一關寫規格；否則繼續拷問。

## 教練話術示例（概念示例，非硬性用詞）

> 依據 #問對問題 (#rightproblem)：你剛才描述的是「想要的功能」，還不是「要解的問題」。我想問你——如果這個 agent 明天就上線，誰的哪一件事會從此不一樣？我的建議是先鎖定你自己每週最耗時的那個流程，因為你就是第一個使用者，驗證成本最低。

> 依據 #偏誤檢驗 (#biasidentification)：注意，你連續三題都回到「加上這個功能會更酷」——這是典型的確認偏誤，證據都往支持自己想法的方向收集。我的建議是我們先假設這功能不存在，看看核心問題還成不成立。

## 出口交付物

- 寫入 `.agent-flow/grill-log.md`（決策清單：每項含「問題→學員決定→理由」＋`[待決]` 清單）
- 更新 `.agent-flow/state.json`（stage: 1 → completed）
- 明確詢問學員：「共識已達成，要進入第 2 關產出規格書嗎？」——未經確認不得自動進下一關
AGENT_LAZYPACK_AGENT_DEV_COACH_REFERENCES_01_GRILL_MD_AA5BD8B143

# agent-dev-coach/references/02-spec.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/agent-dev-coach/references/02-spec.md")"
cat > "{{SYNC_ROOT}}/skills/agent-dev-coach/references/02-spec.md" <<'AGENT_LAZYPACK_AGENT_DEV_COACH_REFERENCES_02_SPEC_MD_D670ADE4EF'
<!-- Version: v1.0 | Stage 2/5 | 規格書 -->

# 02｜Agent 規格書

## 檢核清單（進入本關必讀）

- 本關**不再訪談**，只綜合 Stage 1 已達成的共識
- 沒有 grill-log／進度卡就被要求直接寫規格：先跑濃縮拷問（≤5 題，只問最低決策覆蓋清單的缺口）再綜合
- 產出兩樣：`spec.json`（符合 spec.schema.json）＋`agent-specification.html`
- User Stories 要長、要涵蓋所有面向；每條格式「作為（角色），我想要（功能），因為（效益）」
- 實作決策寫「決定了什麼」，不寫檔案路徑與程式碼片段（很快就過期）
- 測試決策：只測外部行為，不測實作細節；寫清楚工具測試與模型評估怎麼分
- Out of Scope 明確列出「這次不做什麼」，防範圍蔓延
- 成功標準全部可驗證，禁用「盡量、快速、高品質、很多」等模糊詞

## HC 思考框架

- **#可驗證性 (#testability)**：每個成功標準都必須能產生可被檢驗的預測。「agent 變聰明」無法檢驗；「10 封測試 email 中正確分類 ≥9 封」可以。寫規格時對每個標準自問：什麼觀察結果會證明它失敗？答不出來就重寫。
- **#受眾 (#audience)**：User Stories 的第一步不是列功能，是**刻畫角色**——這個 actor 的背景、目標、痛點具體是什麼，再依角色裁剪功能描述。「使用者」太空泛，「每天收 80 封信、最怕漏掉客戶來信的業務主管」才能長出對的 story。
- **#限制條件 (#constraints)**：把「障礙」與「限制」分開——障礙是要**克服**的（例：模型會幻覺），限制是解法必須**滿足**的邊界（例：月成本上限、回應延遲上限、不碰個資）。混在一起會浪費力氣去「解決」一個本來就是邊界的東西。

## 規格書結構（對應 spec.schema.json）

1. 問題陳述（從使用者視角）
2. 解法（從使用者視角，一段話）
3. User Stories（長清單、編號）
4. 實作決策：runtime（跑在哪）、model_provider（模型與供應商）、tools（工具清單與各自職責）、permissions（權限邊界）、data_sources（資料來源）、secrets（金鑰管理方式）、記憶與狀態設計
5. 測試決策：確定性測試（工具、解析器）＋eval_plan（模型行為的小型評估集怎麼建）
6. 限制條件：cost_latency_budget（成本與延遲預算）、safety_boundaries（含 prompt injection 與工具輸出信任的防線）、deployment_target
7. Out of Scope
8. 風險與假設（含 Stage 1 的 `[待決]` 項）

## 教練話術示例

> 依據 #可驗證性 (#testability)：你寫的成功標準是「回覆品質要好」。我想問你——跑完哪個測試、看到什麼數字，你會承認它失敗了？我的建議是改成「20 個固定測試案例中，18 個以上的回覆通過你手動標注的合格線」，這樣第 4 關的驗收才有東西可跑。

> 依據 #限制條件 (#constraints)：「API 費用太貴」不是要解決的障礙，是你要滿足的邊界。我的建議是直接寫進限制：單次任務成本 ≤ 2 元，讓後面的模型選擇在這個框裡找解。

## 出口交付物

- 寫入 `.agent-flow/spec.json`，以 `scripts/render_agent_spec.py` 產 `agent-specification.html`，再跑 `scripts/validate_agent_spec.py` 驗證
- 更新 `.agent-flow/state.json`（stage: 2 → completed）
- 明確詢問學員：「規格書完成，要進入第 3 關切票嗎？」——未經確認不得自動進下一關
AGENT_LAZYPACK_AGENT_DEV_COACH_REFERENCES_02_SPEC_MD_D670ADE4EF

# agent-dev-coach/references/03-tickets.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/agent-dev-coach/references/03-tickets.md")"
cat > "{{SYNC_ROOT}}/skills/agent-dev-coach/references/03-tickets.md" <<'AGENT_LAZYPACK_AGENT_DEV_COACH_REFERENCES_03_TICKETS_MD_0B0F04D9A4'
<!-- Version: v1.0 | Stage 3/5 | 切票 -->

# 03｜切票

## 檢核清單（進入本關必讀）

- 每張票是 **tracer bullet 垂直切片**：切一條窄但**完整**的端到端路徑，完成後可獨立展示或驗證——不是「只做某一層」的水平切片
- 每張票的大小：一個新的對話視窗內做得完
- 每張票宣告 **Blocked by**（哪些票必須先完成）；沒有 blocker 的票可立即開工
- 需要先整理地基的（prefactoring）先切出來、排最前
- 切完先給學員看粒度與依賴，**學員核可才定案**（太粗？太細？依賴對嗎？）
- 票以檔案存放：`tickets/NN-slug.md`，依依賴順序從 01 編號
- 票裡寫「要做出什麼端到端行為」，不寫檔案路徑與程式碼

## HC 思考框架

- **#拆解問題 (#breakitdown)**：好的拆解＝子問題可獨立解決、彼此關聯清楚、合起來完整覆蓋原問題。壞的拆解＝「先做資料層、再做邏輯層、最後做介面」——每一層單獨完成都無法驗證任何事。切票時自問：這張票單獨做完，能 demo 什麼？
- **#系統描繪 (#systemmapping)**：切票前先依「你想驗證什麼」畫出 agent 系統圖——模型、工具、資料、使用者介面、它們之間的呼叫關係。邊界與依賴看得見，Blocked by 才填得對。同一個 agent，為了排票畫的圖和為了資安畫的圖可以不一樣，這是正常的。
- **#制定策略 (#strategize)**：票的順序是策略取捨——先做 walking skeleton 而不是先做最有趣的功能，是用「最快拿到可跑的整條路」換「延後細節」。每次只從 frontier（所有 blocker 都完成的票）挑下一張，說得出「為什麼先做這張而不是那張」。

## Agent 專案的典型切片（greenfield 範例）

- `01-walking-skeleton`：能收一句輸入、呼叫一次模型、回一句輸出的最小迴圈（無工具、無記憶）——Blocked by: 無
- `02-first-tool`：接上第一個工具（含權限邊界），模型能決定何時呼叫——Blocked by: 01
- `03-error-handling`：模型逾時、工具失敗、輸出不合格式時的重試與降級——Blocked by: 02
- `04-eval-harness`：把 spec 的成功標準變成可重複跑的評估集——Blocked by: 01
- 之後的功能票依 spec 的 User Stories 逐條長出來

切片的「縫」（seam）在 agent 專案裡是**工具邊界**與 **prompt-vs-code 邊界**——在縫上測試，不要在模型內部猜。

**例外——寬重構**：一個機械性改動（改名、換型別）會炸開全 codebase 時，不硬塞垂直切片，改走 expand–contract：先加新形式（不弄壞舊的）→分批遷移→最後刪舊形式，每批一張票。

## 票的模板

```
# NN — 票名

**要做出什麼**：這張票完成後，使用者視角看到的端到端行為。

**Blocked by**：票號清單，或「無——可立即開工」。

- [ ] 驗收條件 1
- [ ] 驗收條件 2
```

## 教練話術示例

> 依據 #拆解問題 (#breakitdown)：你切的第一張票是「把資料庫 schema 全部建好」——這是水平切片，做完了什麼都 demo 不了。我的建議是改切 walking skeleton：一條能跑通的最小路徑，哪怕資料先寫死，你在第一天結束就有一個「活的」agent 可以逐步長大。

## 出口交付物

- 寫入 `.agent-flow/tickets/NN-slug.md`（一票一檔，依依賴順序編號）；可選：同時產 starter `CODING_STANDARDS.md` 供 Stage 5 的 Standards 軸有據可審
- 更新 `.agent-flow/state.json`（stage: 3 → completed，記錄 frontier）
- 明確詢問學員：「切票已核可，要進入第 4 關、從第一張可以動工的票開始嗎？」
AGENT_LAZYPACK_AGENT_DEV_COACH_REFERENCES_03_TICKETS_MD_0B0F04D9A4

# agent-dev-coach/references/04-implement.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/agent-dev-coach/references/04-implement.md")"
cat > "{{SYNC_ROOT}}/skills/agent-dev-coach/references/04-implement.md" <<'AGENT_LAZYPACK_AGENT_DEV_COACH_REFERENCES_04_IMPLEMENT_MD_710544F4AB'
<!-- Version: v1.0 | Stage 4/5 | 實作 -->

# 04｜TDD 實作

## 檢核清單（進入本關必讀）

- 只從 **frontier** 取票（所有 Blocked by 都完成的票），一次一張
- 在 Stage 3 議定的縫（工具邊界、prompt-vs-code 邊界）上先寫**會失敗的測試**，再寫實作
- TDD 微流程：紅（測試失敗）→ 綠（最小實作讓它過）→ 重構（測試保持綠）
- 常跑型別檢查與單一測試檔；整套測試留到票收尾時跑一次
- **tests 與 evals 分開**：工具、解析器、狀態機用確定性測試；模型行為用小型評估集，看通過率不看單次對錯
- 每完成一張票：勾掉驗收條件、跑全套測試、commit
- 卡住超過 30 分鐘：回頭檢查是票太大（回 Stage 3 再切）還是規格不清（回 Stage 2 補）

## HC 思考框架

- **#建立假說 (#hypothesisdevelopment)**：每個測試都是一條假說——「因為這段程式的（機制），給它（輸入）應該得到（結果）」。先寫測試＝先把假說形式化；跑測試＝檢驗假說。寫不出測試，通常代表你還說不清楚機制，該回去想，不是先寫 code。
- **#變數控制 (#variables)**：一次只改一個變因——同時改 prompt 又改解析邏輯，測試紅了你不知道是誰害的。模型輸出的隨機性是混淆變項：測工具與解析時用固定的假回應（fixture）把模型隔離掉，測模型行為時才讓它真的跑。
- **#科學學習法 (#scienceoflearning)**：讓 AI 幫你，但用「生成效應」的方式學——先自己想這張票怎麼做、寫下你的做法，再對照 AI 的版本找差異；停在能力邊緣的票（適當困難）學得最多，整張票直接叫 AI 代寫學到的最少。

## 教練話術示例

> 依據 #建立假說 (#hypothesisdevelopment)：先別急著寫 code。這張票的第一條假說是什麼？我的建議是：「因為 email 解析器會抽出寄件人網域，給它這封測試信，應該回傳 `client.com`」——把這句直接變成第一個測試，紅了再動手。

> 依據 #變數控制 (#variables)：你剛才同時改了 prompt 和重試邏輯，然後測試掛了。我的建議是先 revert 重試邏輯那半，讓 prompt 的改動單獨過一次測試，一次一個變因，不然你永遠在猜。

## 執行方式

真 TDD 迴圈，直接在學員的 repo 內執行：

1. 讀 `.agent-flow/state.json` 與 `tickets/`，找出 frontier，向學員確認要做哪張票
2. 依票的驗收條件先寫失敗測試（在議定的縫上）→ 最小實作 → 重構
3. 過程中常跑型別檢查與該測試檔；教練評註帶 HC 標籤（每則回覆最多 2–3 個）
4. 票收尾：跑全套測試、勾驗收條件、commit 到當前分支（訊息引用票號）
5. 更新 `.agent-flow/state.json`；明確詢問學員：「這張票完成，要繼續下一張票，還是進第 5 關審查？」
AGENT_LAZYPACK_AGENT_DEV_COACH_REFERENCES_04_IMPLEMENT_MD_710544F4AB

# agent-dev-coach/references/05-review.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/agent-dev-coach/references/05-review.md")"
cat > "{{SYNC_ROOT}}/skills/agent-dev-coach/references/05-review.md" <<'AGENT_LAZYPACK_AGENT_DEV_COACH_REFERENCES_05_REVIEW_MD_829D8C6BCF'
<!-- Version: v1.0 | Stage 5/5 | 雙軸審查 -->

# 05｜雙軸審查

## 檢核清單（進入本關必讀）

- 先釘住 **fixed point**（要跟哪個基準比：main、某 commit、某 tag）；沒說就問
- 確認 diff 非空、基準存在，才開始審
- 兩條軸**分開審、分開報**：
  - **Standards 軸**：程式寫得合不合規範（repo 有文件依文件，沒有就用 smell 基線）
  - **Spec 軸**：程式做的是不是規格書要的東西（缺了什麼、多做了什麼、做錯了什麼）
- **不跨軸重排序**：兩軸各自列發現、各自標最嚴重項，不合併成一個總排名
- 每個發現必附證據：引用 diff 的段落或規格書的原文；沒有證據的是意見，不是發現
- 審查是 critique 不是 criticism：強處也要指出
- 出口：審查報告＋決定哪些發現要回 Stage 4 修

## HC 思考框架

- **#批判 (#critique)**：批判是中性的深度拆解，不是負面攻擊。對 code 做 close reading：論證（這段邏輯為什麼成立）、結構（模組切分對維護的影響）、預設（哪些未言明的假設，例如「工具回傳一定是合法 JSON」）、強處與弱點並列。目標是看見全貌，不是挑毛病。
- **#證據基礎 (#evidencebased)**：每個發現對應「讀者會問：你怎麼知道？」的位置——引用 hunk、引用規格書那一行。並且主動找反證：這個「問題」會不會其實是 repo 文件裡允許的寫法？
- **#偏誤緩解 (#biasmitigation)**：先識別偏誤——單一審查者容易被光環效應帶走（code 乾淨就以為做對了事），或讓一軸的印象遮蔽另一軸。緩解機制是**流程介入**：兩軸各自獨立審、証據各自成立、不互相排名。程式合規但做錯事＝Standards 過、Spec 不過；做對事但亂寫＝Spec 過、Standards 不過——兩種都要被看見。

## Smell 檢核（Standards 軸的基線；repo 有文件時 repo 優先，工具已自動擋的跳過；每條都是判斷提示，不是鐵律）

完整 Fowler 基線（《Refactoring》ch.3，12 條，每條「是什麼→怎麼修」）：

- **神秘命名**：名字不揭示功能或內容→改名；想不出誠實名字代表設計混濁
- **重複程式碼**：同邏輯多處出現→抽共用形狀，兩邊呼叫
- **功能嫉妒**：方法碰別人的資料多過自己的→把方法搬去它嫉妒的資料那邊
- **資料泥團**：同幾個欄位/參數總是結伴出現→捆成一個型別
- **基本型別執念**：基本型別硬扛領域概念→給概念自己的小型別
- **重複的分支**：同型別的 switch/if 串多處重複→多型或共用一張映射表
- **散彈式修改**：一個邏輯改動散落多檔→收攏進一個模組
- **發散式修改**：一個模組因多個不相干理由被改→拆開，一模組一個變因
- **預留的通用性**：為不存在的需求加抽象→刪掉，等真需求
- **過長訊息鏈**：呼叫端不該依賴的長串導覽→包進第一個物件的方法
- **中間人**：整個類別幾乎只在轉手→砍掉，直接呼叫真目標
- **被拒絕的遺產**：子類別無視大半繼承內容→改用組合

## 教練話術示例

> 依據 #偏誤緩解 (#biasmitigation)：你的 code 型別乾淨、測試齊全，很容易讓人直接蓋章。但這正是光環效應——所以我們分開看：Spec 軸發現規格書第 4 條 User Story（轉寄偵測）完全沒實作。合規不等於做對事，這條要回第 4 關。

## 出口交付物

- `git rev-parse` 確認基準、`git diff <fixed-point>...HEAD`（三點）取 diff，`git log <fixed-point>..HEAD --oneline` 列 commit
- **平行派兩個 subagent**：Standards 軸（附上完整 diff 指令＋smell 基線全文）、Spec 軸（附上 diff 指令＋`.agent-flow/spec.json` 內容）；各限 400 字內回報
  - **Codex adapter**：`invoke_subagent` 派兩個唯讀子代理
  - **Claude adapter**：`Agent` 工具派兩個子代理（`Explore` 或 `general-purpose`），同一則訊息內送出才會平行
  - **AntiGravity adapter**：依當前版本的子代理／平行任務能力；沒有對等能力就走下一條 fallback
- **環境不支援平行 subagent 時（fallback）**：改成依序跑，但**兩軸的獨立性不能犧牲**——先完整跑完一軸並把結論寫下，再開始另一軸，且不得讓前一軸的結論影響後一軸的判斷（這裡要的是互不汙染，不是平行本身）
- **驗證（三個 Agent 同一份）**：`review-report.md` 必須兩節分列、各軸各自附證據與各自的最嚴重項，且沒有跨軸合併排名；做不到就是這一關沒過，不因 Agent 不同而放寬
- 彙整為 `.agent-flow/review-report.md`（兩節照登、不合併排名、各軸一行總結）；更新 `state.json`
- 明確詢問學員：「哪些發現要回第 4 關修？修完可以再請我複審一次。」
- 審查收束後**主動詢問打包**：「五關走完了，要不要把整個流程打包成一份 PRD？」——學員同意才執行（見 `06-package.md`）
AGENT_LAZYPACK_AGENT_DEV_COACH_REFERENCES_05_REVIEW_MD_829D8C6BCF

# agent-dev-coach/references/06-package.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/agent-dev-coach/references/06-package.md")"
cat > "{{SYNC_ROOT}}/skills/agent-dev-coach/references/06-package.md" <<'AGENT_LAZYPACK_AGENT_DEV_COACH_REFERENCES_06_PACKAGE_MD_D6391310FA'
<!-- Version: v1.1 | Utility | PRD 打包 -->

# 06｜PRD 打包

**這不是第六關，是隨時可用的匯出工具。** 五關是「幫學員想清楚」，打包是「把想清楚的東西變成一份別人能接手的文件」。因為不是教練關卡，本工具不點名思考習慣（HC），只忠實整理已產生的內容。

## 檢核清單（執行本工具必讀）

- **只取材已存在的內容**：拷問紀錄、規格、票、審查報告——有什麼寫什麼
- **絕不捏造**：任何一欄缺資料就填 `[待補充]`，並在文末「缺口清單」列出還沒談到的部分
- 隨時可跑，不要求五關跑完；只跑過第 1 關也能打包（內容自然較少）
- 不改寫學員的決策：原話語意優先，只做結構化與潤稿
- 每個決策盡量標出處（來自哪一關），讓讀者能回頭查
- 產出後告訴學員「這份可以直接給合作對象／主管／接手的工程師看」

## 何時觸發

1. **學員主動要求**：「打包」、「轉成 PRD」、「產出需求文件」、「整理成一份 md」
2. **第 5 關審查結束後自動詢問**：「要不要把整個流程打包成一份 PRD？」
3. **學員中途想收尾**：任何一關結束時說「先到這裡」，主動提議打包保存進度

## 取材對應（哪一段填哪一節）

| PRD 章節 | 取材來源 |
|---|---|
| 問題與背景、目標、使用者情境 | 拷問紀錄的決策清單 |
| 功能範圍、使用者故事、驗收標準 | 規格（spec） |
| 技術邊界（工具權限、資料與隱私、模型與成本） | 拷問紀錄＋規格 |
| 開發任務清單 | 切票結果 |
| 已知問題與風險 | 審查報告 |
| 待決事項 | 各關的 `[待決]` 標記彙整 |

## PRD 結構（固定順序）

```markdown
# <agent 名稱> PRD
> 一句話定位：這個 agent 幫（誰）解決（什麼問題）

## 1. 問題與背景
現況痛點、為什麼現在要做

## 2. 目標與成功標準
可驗證的標準（做到什麼程度算成功）

## 3. 使用者與使用情境
誰用、何時用、多頻繁

## 4. 功能範圍
### 要做
### 明確不做（Out of Scope）

## 5. 使用者故事與驗收標準
每則：作為<角色>，我要<行為>，以便<價值>；驗收：<可檢驗條件>

## 6. 技術與邊界
工具與權限（能動什麼、絕不能動什麼）、資料來源與隱私、
記憶與狀態、模型與成本／延遲預算、部署與安全邊界

## 7. 開發任務
依票列出，標順序與相依

## 8. 風險與已知問題

## 9. 待決事項
`[待決]` 彙整，每項註明卡在哪、需要誰決定

## 附錄：決策紀錄
關鍵決策「問題→決定→理由」，標明來自哪一關
```

## 出口交付物

- 讀 `.agent-flow/` 現有內容（`grill-log.md`、`spec.json`、`tickets/`、`review-report.md`），缺的略過並記入缺口清單
- 寫入 `.agent-flow/PRD-<slug>.md`（slug 取自 agent 名稱；同名已存在就加日期後綴，不覆蓋舊版）
- 更新 `.agent-flow/state.json`：記錄本次打包的時間與納入的來源檔
- 回報學員：檔案路徑、納入了哪幾關的內容、缺口清單有幾項
AGENT_LAZYPACK_AGENT_DEV_COACH_REFERENCES_06_PACKAGE_MD_D6391310FA

# agent-dev-coach/references/spec.schema.json
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/agent-dev-coach/references/spec.schema.json")"
cat > "{{SYNC_ROOT}}/skills/agent-dev-coach/references/spec.schema.json" <<'AGENT_LAZYPACK_AGENT_DEV_COACH_REFERENCES_SPEC_SCHEMA_JSON_4E142788CC'
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "agent-spec.schema.json",
  "title": "Agent 規格書",
  "description": "五關流程 Stage 2 產出的 agent 規格書。GPT 軌與 skill 軌共用同一份 schema（canonical 版在 shared/）。",
  "type": "object",
  "additionalProperties": false,
  "required": [
    "meta", "problem_statement", "solution", "user_stories",
    "implementation_decisions", "testing_decisions", "constraints",
    "success_criteria", "out_of_scope", "risks_assumptions"
  ],
  "properties": {
    "meta": {
      "type": "object",
      "additionalProperties": false,
      "required": ["project_name", "stage", "version", "created_at"],
      "properties": {
        "project_name": { "type": "string", "minLength": 1 },
        "stage": { "type": "integer", "const": 2 },
        "version": { "type": "string", "pattern": "^v\\d+\\.\\d+$" },
        "created_at": { "type": "string", "description": "YYYY-MM-DD HH:MM" },
        "pending_decisions": {
          "type": "array",
          "description": "Stage 1 未決項（[待決]），學員已明確接受才可帶進規格",
          "items": { "type": "string" }
        }
      }
    },
    "problem_statement": { "type": "string", "minLength": 20, "description": "使用者視角的問題陳述" },
    "solution": { "type": "string", "minLength": 20, "description": "使用者視角的解法描述" },
    "user_stories": {
      "type": "array",
      "minItems": 3,
      "items": {
        "type": "object",
        "additionalProperties": false,
        "required": ["actor", "feature", "benefit"],
        "properties": {
          "actor": { "type": "string" },
          "feature": { "type": "string" },
          "benefit": { "type": "string" }
        }
      }
    },
    "implementation_decisions": {
      "type": "object",
      "additionalProperties": false,
      "required": ["runtime", "model_provider", "tools", "permissions", "data_sources", "secrets", "memory_state"],
      "properties": {
        "runtime": { "type": "string", "description": "跑在哪：本機 CLI / server / serverless / …" },
        "model_provider": { "type": "string", "description": "模型與供應商（含備援）" },
        "tools": {
          "type": "array",
          "items": {
            "type": "object",
            "additionalProperties": false,
            "required": ["name", "purpose"],
            "properties": {
              "name": { "type": "string" },
              "purpose": { "type": "string" },
              "side_effects": { "type": "string", "description": "會動到什麼（寫檔/寄信/呼叫外部 API）" }
            }
          }
        },
        "permissions": { "type": "string", "description": "agent 能動什麼、絕不能動什麼的邊界" },
        "data_sources": { "type": "array", "items": { "type": "string" } },
        "secrets": { "type": "string", "description": "金鑰存放與注入方式（env / secret manager），禁止寫進 code" },
        "memory_state": { "type": "string", "description": "跨對話記憶與狀態設計；無則寫「無狀態」" },
        "other_decisions": { "type": "array", "items": { "type": "string" } }
      }
    },
    "testing_decisions": {
      "type": "object",
      "additionalProperties": false,
      "required": ["deterministic_tests", "eval_plan"],
      "properties": {
        "deterministic_tests": { "type": "string", "description": "工具/解析器/狀態機的確定性測試策略（只測外部行為）" },
        "eval_plan": { "type": "string", "description": "模型行為評估：評估集怎麼建、幾筆、合格線" },
        "seams": { "type": "array", "items": { "type": "string" }, "description": "議定的測試縫（工具邊界、prompt-vs-code 邊界）" }
      }
    },
    "constraints": {
      "type": "object",
      "additionalProperties": false,
      "required": ["cost_latency_budget", "safety_boundaries", "deployment_target"],
      "properties": {
        "cost_latency_budget": { "type": "string", "description": "單次任務成本上限與可接受延遲（量化）" },
        "safety_boundaries": { "type": "string", "description": "安全邊界：prompt injection 防線、工具輸出信任策略、個資處理" },
        "deployment_target": { "type": "string" },
        "other_constraints": { "type": "array", "items": { "type": "string" } }
      }
    },
    "success_criteria": {
      "type": "array",
      "minItems": 1,
      "items": { "type": "string", "description": "可驗證：說得出什麼觀察結果會判定失敗" }
    },
    "out_of_scope": { "type": "array", "minItems": 1, "items": { "type": "string" } },
    "risks_assumptions": { "type": "array", "minItems": 1, "items": { "type": "string" } }
  }
}
AGENT_LAZYPACK_AGENT_DEV_COACH_REFERENCES_SPEC_SCHEMA_JSON_4E142788CC

# agent-dev-coach/scripts/render_agent_spec.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/agent-dev-coach/scripts/render_agent_spec.py")"
cat > "{{SYNC_ROOT}}/skills/agent-dev-coach/scripts/render_agent_spec.py" <<'AGENT_LAZYPACK_AGENT_DEV_COACH_SCRIPTS_RENDER_AGENT_SPEC_PY_778DD6355D'
#!/usr/bin/env python3
"""Render agent-specification.html from spec.json + template.

All user-supplied strings are HTML-escaped. Missing optional fields render as [待補充].
--template 預設解析為本腳本所在 skill 套件的 assets/agent_spec_template.html，
因此可從學員專案的任意工作目錄以絕對路徑呼叫本腳本。
Usage:
  python3 <skill-root>/scripts/render_agent_spec.py --input .agent-flow/spec.json --output-dir .agent-flow
"""
import argparse
import html
import json
import sys
from pathlib import Path

PLACEHOLDER = "[待補充]"
SKILL_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_TEMPLATE = SKILL_ROOT / "assets" / "agent_spec_template.html"


def esc(value):
    if value is None or (isinstance(value, str) and not value.strip()):
        return html.escape(PLACEHOLDER)
    return html.escape(str(value))


def li_items(values):
    values = [v for v in (values or []) if str(v).strip()]
    if not values:
        return f"<li>{html.escape(PLACEHOLDER)}</li>"
    return "".join(f"<li>{esc(v)}</li>" for v in values)


def kv(label, value):
    return f'<div class="kv"><b>{html.escape(label)}</b>：{esc(value)}</div>'


def render_user_stories(stories):
    if not stories:
        return f"<li>{html.escape(PLACEHOLDER)}</li>"
    out = []
    for s in stories:
        out.append(
            "<li>作為 <b>%s</b>，我想要 %s，因為 %s</li>"
            % (esc(s.get("actor")), esc(s.get("feature")), esc(s.get("benefit")))
        )
    return "".join(out)


def render_implementation(impl):
    impl = impl or {}
    parts = [
        kv("Runtime", impl.get("runtime")),
        kv("模型與供應商", impl.get("model_provider")),
    ]
    tools = impl.get("tools") or []
    if tools:
        rows = "".join(
            "<li><b>%s</b>：%s%s</li>"
            % (
                esc(t.get("name")),
                esc(t.get("purpose")),
                ("（副作用：%s）" % esc(t.get("side_effects"))) if t.get("side_effects") else "",
            )
            for t in tools
        )
        parts.append(f'<div class="kv"><b>工具</b>：<ul>{rows}</ul></div>')
    else:
        parts.append(kv("工具", None))
    parts.append(kv("權限邊界", impl.get("permissions")))
    parts.append(kv("資料來源", "、".join(impl.get("data_sources") or []) or None))
    parts.append(kv("金鑰管理", impl.get("secrets")))
    parts.append(kv("記憶與狀態", impl.get("memory_state")))
    other = impl.get("other_decisions") or []
    if other:
        parts.append(f'<div class="kv"><b>其他決策</b>：<ul>{li_items(other)}</ul></div>')
    return "".join(parts)


def render_testing(testing):
    testing = testing or {}
    parts = [
        kv("確定性測試", testing.get("deterministic_tests")),
        kv("Eval 計畫", testing.get("eval_plan")),
    ]
    seams = testing.get("seams") or []
    if seams:
        parts.append(f'<div class="kv"><b>測試縫</b>：<ul>{li_items(seams)}</ul></div>')
    return "".join(parts)


def render_constraints(cons):
    cons = cons or {}
    parts = [
        kv("成本與延遲預算", cons.get("cost_latency_budget")),
        kv("安全邊界", cons.get("safety_boundaries")),
        kv("部署目標", cons.get("deployment_target")),
    ]
    other = cons.get("other_constraints") or []
    if other:
        parts.append(f'<div class="kv"><b>其他限制</b>：<ul>{li_items(other)}</ul></div>')
    return "".join(parts)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--input", required=True)
    ap.add_argument("--template", default=str(DEFAULT_TEMPLATE),
                    help="預設為 skill 套件內的 assets/agent_spec_template.html")
    ap.add_argument("--output-dir", required=True)
    args = ap.parse_args()

    template_path = Path(args.template)
    if not template_path.is_file():
        print(f"FAIL 找不到樣板：{template_path}", file=sys.stderr)
        return 1
    spec = json.loads(Path(args.input).read_text(encoding="utf-8"))
    template = template_path.read_text(encoding="utf-8")
    meta = spec.get("meta") or {}
    pending = meta.get("pending_decisions") or []

    mapping = {
        "{project_name}": esc(meta.get("project_name")),
        "{version}": esc(meta.get("version")),
        "{created_at}": esc(meta.get("created_at")),
        "{problem_statement}": esc(spec.get("problem_statement")),
        "{solution}": esc(spec.get("solution")),
        "{user_stories_items}": render_user_stories(spec.get("user_stories")),
        "{implementation_items}": render_implementation(spec.get("implementation_decisions")),
        "{testing_items}": render_testing(spec.get("testing_decisions")),
        "{constraints_items}": render_constraints(spec.get("constraints")),
        "{success_criteria_items}": li_items(spec.get("success_criteria")),
        "{out_of_scope_items}": li_items(spec.get("out_of_scope")),
        "{risks_items}": li_items(spec.get("risks_assumptions")),
        "{pending_items}": esc("、".join(pending) if pending else "無"),
    }
    out = template
    for key, value in mapping.items():
        out = out.replace(key, value)

    out_dir = Path(args.output_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    out_path = out_dir / "agent-specification.html"
    out_path.write_text(out, encoding="utf-8")

    manifest = {
        "project_name": meta.get("project_name"),
        "stage": 2,
        "outputs": ["agent-specification.html", Path(args.input).name],
        "pending_decisions": pending,
    }
    (out_dir / "manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    print(f"OK {out_path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
AGENT_LAZYPACK_AGENT_DEV_COACH_SCRIPTS_RENDER_AGENT_SPEC_PY_778DD6355D

# agent-dev-coach/scripts/validate_agent_spec.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/agent-dev-coach/scripts/validate_agent_spec.py")"
cat > "{{SYNC_ROOT}}/skills/agent-dev-coach/scripts/validate_agent_spec.py" <<'AGENT_LAZYPACK_AGENT_DEV_COACH_SCRIPTS_VALIDATE_AGENT_SPEC_PY_ED5D12CA0E'
#!/usr/bin/env python3
"""Validate rendered agent-specification.html and (optionally) spec.json.

Checks:
  1. HTML starts with <!DOCTYPE html> and ends with </html>; single html/head/body pair.
  2. UTF-8 charset present; no leftover {placeholder}; no external resources or <script>.
  3. spec.json: required top-level keys exist; success_criteria non-empty and free of vague words;
     if --schema given and jsonschema is installed, run a full schema validation (best effort).
--schema 預設解析為本腳本所在 skill 套件的 references/spec.schema.json，
因此可從學員專案的任意工作目錄以絕對路徑呼叫本腳本。
Usage:
  python3 <skill-root>/scripts/validate_agent_spec.py .agent-flow/agent-specification.html \
      --spec .agent-flow/spec.json
"""
import argparse
import json
import re
import sys
from pathlib import Path

SKILL_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_SCHEMA = SKILL_ROOT / "references" / "spec.schema.json"

VAGUE_WORDS = [
    "盡量", "盡可能", "快速", "很快", "高品質", "良好", "足夠", "很多", "一些",
    "大量", "經常", "偶爾", "很高", "很低", "要好", "更好", "差不多", "越快越好",
    "品質好", "有效率", "使用者滿意",
]
REQUIRED_KEYS = [
    "meta", "problem_statement", "solution", "user_stories",
    "implementation_decisions", "testing_decisions", "constraints",
    "success_criteria", "out_of_scope", "risks_assumptions",
]


def fail(errors):
    for e in errors:
        print(f"FAIL {e}")
    return 1


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("html")
    ap.add_argument("--spec")
    ap.add_argument("--schema", default=str(DEFAULT_SCHEMA),
                    help="預設為 skill 套件內的 references/spec.schema.json")
    args = ap.parse_args()
    errors = []

    text = Path(args.html).read_text(encoding="utf-8")
    stripped = text.strip()
    if not stripped.startswith("<!DOCTYPE html>"):
        errors.append("HTML 開頭不是 <!DOCTYPE html>")
    if not stripped.endswith("</html>"):
        errors.append("HTML 結尾不是 </html>")
    for tag in ("<html", "<head", "<body"):
        if len(re.findall(re.escape(tag), text)) != 1:
            errors.append(f"{tag}> 不是恰好一組")
    if 'charset="UTF-8"' not in text and "charset=UTF-8" not in text:
        errors.append("缺 UTF-8 charset")
    leftovers = re.findall(r"\{[a-z_]+\}", text)
    if leftovers:
        errors.append(f"未替換 placeholder: {sorted(set(leftovers))}")
    if "<script" in text.lower():
        errors.append("含 <script>（禁止）")
    if re.search(r'(?:src|href)\s*=\s*["\']https?://', text, re.IGNORECASE):
        errors.append("含外部資源連結（禁止）")

    if args.spec:
        spec = json.loads(Path(args.spec).read_text(encoding="utf-8"))
        for key in REQUIRED_KEYS:
            if key not in spec:
                errors.append(f"spec.json 缺必要欄位: {key}")
        criteria = spec.get("success_criteria") or []
        if not criteria:
            errors.append("success_criteria 不可為空")
        for c in criteria:
            hits = [w for w in VAGUE_WORDS if w in str(c)]
            if hits:
                errors.append(f"成功標準含模糊詞 {hits}: {c}")
        if args.schema and Path(args.schema).is_file():
            try:
                import jsonschema  # type: ignore

                schema = json.loads(Path(args.schema).read_text(encoding="utf-8"))
                jsonschema.validate(spec, schema)
            except ImportError:
                print("NOTE jsonschema 未安裝，跳過完整 schema 驗證（基本檢查已跑）")
            except Exception as e:  # jsonschema.ValidationError
                where = ".".join(str(x) for x in getattr(e, "absolute_path", []) or []) or "(根層級)"
                msg = getattr(e, "message", str(e)).splitlines()[0]
                errors.append(f"schema 驗證失敗 @ {where}: {msg}")

    if errors:
        return fail(errors)
    print("PASS 所有檢查通過")
    return 0


if __name__ == "__main__":
    sys.exit(main())
AGENT_LAZYPACK_AGENT_DEV_COACH_SCRIPTS_VALIDATE_AGENT_SPEC_PY_ED5D12CA0E

test -f "{{SYNC_ROOT}}/skills/agent-dev-coach/SKILL.md" && echo "agent-dev-coach installed for Codex, Claude, and AntiGravity"
````

安裝完成後，請開新 Agent 對話或重啟對應 App，再測試 skill 是否能被讀取。

<!-- END EMBEDDED_SKILLS -->
