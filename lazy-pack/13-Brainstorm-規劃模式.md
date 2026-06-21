# 13-Brainstorm-規劃模式

> 2026-05-24 更新：本文件已改為自含式 Skill 安裝文件。請使用文末「內建 Skill 完整安裝內容」，不需要額外的舊版獨立 skills 子目錄。


## 目標

把 來源工具 取向的 `/brainstorm` 規劃流程，轉成 Codex App 可用的全域 skill。

這個 skill 用在「先想清楚再動手」的情境：當使用者只有模糊想法、怕 AI 直接開工做錯方向，或想先得到一份計劃書時，Codex 會先釐清需求、列假設、比較方案，直到使用者確認計劃後才開始實作。

## 前置條件

- 已完成 `README.md` 的設定表。
- 已知道 Codex skills 位置：`{{CODEX_HOME}}/skills`。
- 已完成或讀過 `11-Codex-Skill-Creator-工作流.md`。
- 若使用 Obsidian 全域 skill 索引，已知道位置：

```text
{{OBSIDIAN_PROJECTS}}/{{SETUP_PROJECT_NAME}}/全域 Skills/全域 Skills 同步.md
```

## 固定結論

- skill 名稱：`brainstorm`
- 正式安裝位置：

```text
{{CODEX_HOME}}/skills/brainstorm/
```

- 本文件已內嵌可直接建立的 skill 原始檔：

```text
本文件文末內嵌內容：brainstorm/SKILL.md
本文件文末內嵌內容：brainstorm/references/source-adaptation.md
```

- Codex 版觸發方式不是 來源工具 slash command，而是靠 skill metadata 與自然語意觸發，例如：
  - `$brainstorm`
  - `brainstorm 我想做一個記帳 App`
  - `/brainstorm 我想改善目前的工作流程`
  - `先幫我規劃，不要直接執行`
  - `請先把這個想法整理成計劃`

## 直接安裝

下載本 repo 後，直接使用本文文末的內建安裝腳本建立到自己的 Codex skills 位置：

```bash
mkdir -p "{{CODEX_HOME}}/skills/brainstorm"
# 請使用本文文末「內建 Skill 完整安裝內容」；不需要額外複製舊版獨立 skills 子目錄。
```

如果你已經有同名 skill，先備份再覆蓋：

```bash
cp -R "{{CODEX_HOME}}/skills/brainstorm" "{{CODEX_HOME}}/skills/brainstorm.backup.$(date +%Y%m%d-%H%M%S)"
# 請使用本文文末「內建 Skill 完整安裝內容」；不需要額外複製舊版獨立 skills 子目錄。
```

## 驗證安裝

檢查檔案存在：

```bash
find "{{CODEX_HOME}}/skills/brainstorm" -maxdepth 3 -type f -print
```

應看到：

```text
{{CODEX_HOME}}/skills/brainstorm/SKILL.md
{{CODEX_HOME}}/skills/brainstorm/references/source-adaptation.md
```

檢查 frontmatter：

```bash
sed -n '1,12p' "{{CODEX_HOME}}/skills/brainstorm/SKILL.md"
```

應包含：

```markdown
---
name: brainstorm
description: Use when the user says brainstorm, $brainstorm, /brainstorm, 規劃模式, 先想清楚再動手...
metadata:
  short-description: 先規劃再執行的引導式需求釐清
---
```

安裝後，開新 Codex 對話或重啟 Codex App，讓 skill 清單重新載入。

## 何時會觸發

使用者提出以下需求時應使用：

- 「brainstorm 我想做一個新工具」
- `$brainstorm`
- 「/brainstorm 我想改善這個專案」
- 「先幫我規劃，不要執行」
- 「我有一個模糊想法，幫我釐清」
- 「先列方案比較，等我確認後再做」

不應用在：

- 使用者已經要求直接做一個明確的小修正。
- 單純查詢事實、翻譯、改一句文字。
- 已有清楚規格且使用者明確不要再討論方案。

## 工作流程

1. 先確認溝通深度：小白、半技術、工程師或由 Codex 判斷。
2. 確認主題與任務類型：新東西、解決問題、改善現有東西或還不確定。
3. 輕量讀取上下文，例如 `AGENTS.md`、Git 狀態、根目錄主要檔案與使用者指定檔案。
4. 列出 3-6 個假設，請使用者修正。
5. 最多問 5 個關鍵問題，一次只問一個主要問題。
6. 提出 1-3 個方案並給推薦。
7. 產出計劃書；使用者確認前不實作。
8. 使用者選擇「現在執行」後，才離開 brainstorm 模式並開始做事。

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

Codex 版不在安裝時固定 `PLANS_DIR`。使用 skill 時才依專案狀況決定：

1. 若目前專案已有 `plans/`，優先放在 `plans/`。
2. 若目前專案使用個人助手本地層且已有 `100_Todo/plans/`，可放在 `100_Todo/plans/`。
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
| `brainstorm` | `{{CODEX_HOME}}/skills/brainstorm/SKILL.md` | Brainstorm 規劃模式；用引導式問答把模糊想法轉成可執行計劃，確認前不實作 | 已同步 |
```

## 來源工具 轉換重點

| 來源工具 原流程 | Codex App 相容做法 |
| --- | --- |
| `/brainstorm` slash command | 可保留為觸發語；顯式呼叫使用實際名稱 `$brainstorm` |
| 來源工具的全域 skills 路徑 | 需要全域觸發時改用 `{{CODEX_HOME}}/skills` |
| 來源工具的專案級 skills | 改放該專案 `000_Agent/skills`，只服務該專案 |
| `000_Agent/skills` symlink | 不建立；`000_Agent/skills` 是本地 skill 區，不等於 Codex 全域 skills |
| `AskUserQuestion` | 改成 Codex 對話中的單題引導 |
| 安裝時固定 `PLANS_DIR` | 使用 skill 時依專案決定 |
| 來源工具 Plan Mode 比較 | 改成 Codex 的「確認計劃前不實作」硬性閘門 |

## 踩坑修正

- 不要把原始 來源工具 安裝段落直接照貼到 Codex。
- 不要建立 來源工具的 skills 路徑或 command shim；專案級 skill 只放該專案 `000_Agent/skills`。
- Codex 不保證 `/brainstorm` 會像 來源工具 slash command 一樣被 UI 特別處理；要在 `description` 寫清楚自然語意觸發。
- 安裝後通常要開新 Codex 對話或重啟 Codex App。
- 這個 skill 是規劃閘門，不是自動執行工具；使用者確認前不要動檔案。

## 設定範例

本機曾建立：

```text
{{CODEX_HOME}}/skills/brainstorm/SKILL.md
{{CODEX_HOME}}/skills/brainstorm/references/source-adaptation.md
```

並已把原始 來源工具 `/brainstorm` 安裝劇本轉成 Codex App 相容流程。下載者應使用自己的 `{{CODEX_HOME}}` 與自己的專案位置。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊。這個序號項目會安裝：`brainstorm`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `~/.codex`。

````bash
set -e

decode_base64() {
  if base64 --help 2>/dev/null | grep -q -- '-d'; then
    base64 -d
  else
    base64 -D
  fi
}

# ---- brainstorm ----
mkdir -p "{{CODEX_HOME}}/skills/brainstorm"
# brainstorm/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/brainstorm/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/brainstorm/SKILL.md" <<'CODEX_LAZYPACK_BRAINSTORM_SKILL_MD_7372A3995C'
---
name: brainstorm
description: Use when the user says brainstorm, $brainstorm, /brainstorm, 規劃模式, 先想清楚再動手, or asks to turn a vague idea into a concrete plan before implementation. Guides the user through concise Traditional Chinese planning questions, compares options, writes a plan, and does not implement until the user confirms.
metadata:
  short-description: 先規劃再執行的引導式需求釐清
---

# Brainstorm 規劃模式

把模糊想法變成可執行計劃。這是 Codex App 版的規劃流程：不依賴其他工具的 command 或專用互動機制；使用者可以用 `$brainstorm`、「brainstorm」、「/brainstorm」或「先幫我規劃」觸發。

> 來源改編：核心理念來自「AI 規劃模式 by 雷小蒙」與 obra/superpowers brainstorming skill。來源工具 專用安裝、路徑、slash command 與工具名稱已轉成 Codex App 可用規則。

## 硬性閘門

在使用者確認計劃之前，不可以：

- 寫程式碼或修改既有檔案。
- 建立專案結構或 scaffold。
- 執行會改變狀態的安裝、設定、部署、刪除、搬移動作。
- 把初步假設當成已確認需求。

允許做的事：讀取相關檔案、檢查狀態、詢問問題、整理方案、產出計劃書草稿。若使用者明確要求保存計劃書，可建立計劃書檔案；除此之外先不寫入。

## 溝通原則

- 全程使用繁體中文回覆使用者。
- 一次只問一個主要問題。
- 優先提供 2-4 個可選方向，必要時附「我建議」與一句理由。
- 如果使用者不耐煩、連續說「你決定」、「直接做」，最多再問一個關鍵問題，然後進入計劃草案。
- 挑戰過大的範圍：直接建議先做核心版本，把延伸功能放到「這次不包含」。
- 不做空泛附和，直接推進釐清、比較與決策。

## Phase 0：確認溝通深度

第一個問題先確認溝通模式，除非使用者已經明確指定。

可用選項：

1. 小白模式：少用技術詞，重點放在成果、風險、延伸與需要使用者配合的事。
2. 半技術模式：保留必要檔名、工具名、API、框架名，第一次出現時用一句話說明。
3. 工程師模式：直接使用技術詞彙、檔案路徑、架構與測試策略。
4. 你決定：先用半技術模式，根據使用者反應調整。

後續每個假設、方案比較、計劃書都要符合選定深度。

## Phase 1：確認主題與類型

如果使用者已提供主題，直接復述成一句「我理解你要做的是...」。如果沒有，先問：「你想規劃什麼？用一句話描述就好。」

接著判斷任務類型，必要時詢問使用者：

- 新東西：新功能、新專案、新工具。
- 解決問題：bug、錯誤、流程卡住。
- 改善現有東西：優化、重構、變好用。
- 還不確定：需要先找方向。

## Phase 2：快速讀取上下文

依任務範圍做輕量檢查，不超讀整個資料夾：

- 讀取專案 `AGENTS.md` 或使用者指定的規則檔。
- 若是 Git repo，可看目前狀態與最近幾筆 commit。
- 掃描根目錄主要檔案與資料夾。
- 如果主題提到特定檔案、功能或錯誤，讀取相關內容。
- 若涉及 Obsidian、NotebookLM、全域 skill、Arry 助手或外部工具，遵守對應專案規則與已安裝 skills。

## Phase 3：列出假設並請使用者修正

根據主題與上下文列出 3-6 個假設。格式依溝通深度調整。

半技術或工程師模式可包含技術假設，例如：

```markdown
根據你的描述和目前專案，我先列出我的理解：

1. 目標：...
2. 範圍：...
3. 技術方向：...
4. 使用者：...
5. 不做的事：...
```

小白模式改用成果導向，例如：

```markdown
我先用白話整理我的理解：

1. 你想得到的成果：...
2. 使用方式：...
3. 這次先做的部分：...
4. 目前先不碰的部分：...
5. 可能的風險：...
```

結尾只問一個問題：「這些理解有哪裡需要修正？」並提供可選方向：全部正確、部分修正、大方向不對。

## Phase 4：深度釐清

最多問 5 個關鍵問題；已經確認的事不要重問。

新東西優先釐清：

- 給誰用。
- 最重要的 1-2 個功能。
- 是否要跟現有專案、工具或部署方式一致。
- 使用者最後會在哪裡看到或使用成果。

解決問題優先釐清：

- 什麼時候開始。
- 是否能穩定重現。
- 錯誤訊息或失敗畫面。
- 已經試過什麼。

改善現有東西優先釐清：

- 現在最不滿意的地方。
- 理想狀態。
- 參考對象。
- 可接受改動範圍。

## Phase 5：提出方案

通常提出 2-3 個方案；簡單任務可只提出 1 個建議做法並請確認。

半技術或工程師模式表格欄位：做法、優點、缺點、適合情境、工作量、風險。

小白模式表格欄位：做完長什麼樣、好處、限制、可能風險、未來能延伸什麼、需要使用者做的事。

必須給一個推薦方案與一句理由，然後問使用者要選哪個方案，或是否混合調整。

## Phase 6：產出計劃書

使用者選定方案後，產出一份可執行計劃書。預設先在對話中顯示；只有使用者要求保存，或任務明確需要計劃檔，才寫入檔案。

建議格式：

```markdown
# [計劃名稱]

> 建立時間：YYYY-MM-DD HH:MM
> 類型：[新功能 / 問題修復 / 改善優化 / 方向釐清]
> 狀態：待確認

## 一句話版

[這次要做什麼]

## 背景和動機

[為什麼要做，解決什麼問題]

## 已確認的決策

- [決策 1]
- [決策 2]

## 具體步驟

### Step 1：[步驟名稱]
- 做什麼：...
- 產出：...
- 注意：...

## 預計成果

- [成果 1]
- [成果 2]

## 這次不包含

- [排除項目]

## 風險與處理

- [風險]：[處理方式]
```

保存計劃書時，優先使用目前專案的 `plans/`；若專案已有 `100_Todo/plans/` 或使用者指定位置，改用該位置。檔名格式：`YYYY-MM-DD-[主題關鍵字].md`。

## Phase 7：確認下一步

計劃書完成後，只問一個問題：「你接下來要怎麼做？」

可選方向：

1. 現在依照計劃執行。
2. 先修改計劃書。
3. 先存著，之後再做。

只有使用者選擇或明確表示要執行時，才離開 brainstorm 規劃模式並開始實作。

## 自我檢查

交付計劃前先檢查：

- 沒有 `TBD`、`待確認` 卻沒標出需要使用者決策的地方。
- 步驟沒有互相矛盾。
- 步驟數量合理，通常 3-8 步。
- 每一步都具體到下一位 Codex 看了也知道要做什麼。
- 有清楚列出不包含範圍。
- 回覆語氣符合 Phase 0 的溝通深度。
CODEX_LAZYPACK_BRAINSTORM_SKILL_MD_7372A3995C

# brainstorm/references/source-adaptation.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/brainstorm/references/source-adaptation.md")"
cat > "{{CODEX_HOME}}/skills/brainstorm/references/source-adaptation.md" <<'CODEX_LAZYPACK_BRAINSTORM_REFERENCES_SOURCE_ADAPTATION_MD_97DFD86D17'
# Brainstorm 來源轉換說明

來源檔：`04-brainstorm.md`

原始來源是 來源工具 的 `/brainstorm` 安裝劇本，包含 `來源工具的舊 skills 路徑`、`AskUserQuestion`、slash command 與 來源工具 Plan Mode 比較。安裝到 Codex App 時已做以下轉換：

- 安裝位置改為 `{{CODEX_HOME}}/skills/brainstorm/`。
- 觸發方式改為 `$brainstorm`、Codex skill metadata 與自然語意，例如「brainstorm」、「/brainstorm」、「先想清楚再動手」。
- 移除 來源工具 專用路徑：`來源工具的舊 skills 路徑`、專案 `000_Agent/skills` symlink、來源工具 command shim。
- 移除 來源工具 專用工具名稱 `AskUserQuestion`，改為 Codex 對話中的單題引導；若未來 Codex App 提供可用選項 UI，可用該 UI 呈現選項。
- 保留硬性閘門：使用者確認計劃前不實作、不 scaffold、不修改檔案。
- 保留四種溝通模式：小白、半技術、工程師、AI 判斷。
- 保留核心階段：確認主題、掃描上下文、列假設、深度釐清、方案比較、計劃書、下一步確認。
- 保存計劃書的預設位置改成 Codex 專案慣例：目前專案 `plans/`，或既有 `100_Todo/plans/`，或使用者指定路徑。

授權與致謝：原文標示「AI 規劃模式 by 雷小蒙」採 CC BY-NC-SA 4.0 個人使用自由、禁止商業用途；核心理念參考 obra/superpowers brainstorming skill（MIT License）。本檔只保存 Codex 相容改編摘要，不複製原始全文。
CODEX_LAZYPACK_BRAINSTORM_REFERENCES_SOURCE_ADAPTATION_MD_97DFD86D17

test -f "{{CODEX_HOME}}/skills/brainstorm/SKILL.md" && echo "brainstorm installed"

echo "embedded skills installed: brainstorm"
````

<!-- END EMBEDDED_SKILLS -->
