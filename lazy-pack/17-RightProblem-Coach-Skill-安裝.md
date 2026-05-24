# 17-RightProblem-Coach-Skill-安裝

> 版本：2026-05-24 Codex App 版
> 用途：把 RightProblem Coach 問題結構化流程安裝成 Codex App 全域 Skill，用 #問對問題 將模糊問題轉成可執行的問題規格書。
> 成品：下載者可直接使用本文文末「內建 Skill 完整安裝內容」建立 `{{CODEX_HOME}}/skills/rightproblem-coach/`，不需要額外的 `skills/` 子目錄。

## 來源與歷史紀錄

- 初次同步日期：2026-05-10。
- 原始來源包：`rightproblem-coach_v2.0_20260309_1500.zip`。
- 2026-05-24 重新核對來源包內容：包含 `SKILL.md`、`references/analysis-framework.md`、`references/hc-guide.md`、`references/template.html`；`__MACOSX/` 與 `.DS_Store` 為 macOS 壓縮附帶檔，不納入安裝內容。
- Codex 全域 skill：`/Users/arrywu/.codex/skills/rightproblem-coach/SKILL.md`。
- Obsidian 全域索引已記錄用途：用 #問對問題 將模糊問題轉成 9 大區塊問題規格書 HTML。

## 這版和來源工具文件的差異

| 原始取向 | Codex 版 |
|---|---|
| 可能依賴來源工具的 skill 路徑 | 改為 `{{CODEX_HOME}}/skills/rightproblem-coach` |
| 可能依賴特定 slash command | Codex 依 `SKILL.md` metadata 與自然語意觸發 |
| 產出流程分散在來源包 | 本文內嵌 `SKILL.md`、`references/analysis-framework.md`、`references/hc-guide.md`、`references/template.html` |
| 問題分析容易只停在建議 | Codex 版固定產出 9 大區塊問題規格書 HTML |

## 安裝方式

使用本文文末「內建 Skill 完整安裝內容」。執行前先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `/Users/alex/.codex`。

安裝後開新 Codex 對話或重啟 Codex App，讓 skill metadata 重新載入。

## 驗證

```bash
test -f "{{CODEX_HOME}}/skills/rightproblem-coach/SKILL.md" && echo "rightproblem-coach SKILL.md ok"
test -f "{{CODEX_HOME}}/skills/rightproblem-coach/references/analysis-framework.md" && echo "analysis framework ok"
test -f "{{CODEX_HOME}}/skills/rightproblem-coach/references/hc-guide.md" && echo "hc guide ok"
test -f "{{CODEX_HOME}}/skills/rightproblem-coach/references/template.html" && echo "template ok"
```

合理結果是四行都顯示 `ok`。

## 使用方式

安裝後可用下列語句觸發：

- 「使用 rightproblem-coach 分析這個問題」
- 「用 #問對問題 幫我重構這個問題」
- 「把這個模糊問題整理成問題規格書」
- 「幫我做 RightProblem Coach 分析」

預設輸出：

```text
<問題名稱>_rightproblem.html
```

## 預設工作流程

1. 先確認使用者描述的是問題、困擾、挑戰或決策阻礙。
2. 用 5 Whys、症狀 vs 問題、問題重構與優先級分類做內部分析。
3. 避免模糊詞，改成可觀察、可驗證、可量化的描述。
4. 產出 9 大區塊問題規格書 HTML。
5. 若使用者要求後續行動，再把問題規格書轉成計畫或任務。

## 踩坑紀錄

### 1. 不要只輸出一般建議

這個 skill 的價值是問題結構化，不是一般 coaching。輸出應落到問題規格書，並保留判斷依據。

### 2. 不要把症狀當根因

若使用者只描述表面現象，先做 5 Whys 與症狀 / 問題分離，再產出規格書。

### 3. HTML template 必須一起安裝

`references/template.html` 是輸出格式的重要依據，不能只安裝 `SKILL.md`。

### 4. 避免保證式診斷

RightProblem Coach 可以提出結構化判斷，但不應假裝已經知道所有背景；需要列出假設與待確認資料。

## 最終檢查清單

- [ ] `{{CODEX_HOME}}/skills/rightproblem-coach/SKILL.md` 存在。
- [ ] `references/analysis-framework.md` 存在。
- [ ] `references/hc-guide.md` 存在。
- [ ] `references/template.html` 存在。
- [ ] 開新 Codex 對話後，可用「#問對問題」或「RightProblem Coach」觸發。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節會安裝：`rightproblem-coach`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `/Users/alex/.codex`。

```bash
set -e

# ---- rightproblem-coach ----
mkdir -p "{{CODEX_HOME}}/skills/rightproblem-coach"
# rightproblem-coach/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/rightproblem-coach/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/rightproblem-coach/SKILL.md" <<'CODEX_LAZYPACK_RIGHTPROBLEM_COACH_SKILL_MD'
---
name: rightproblem-coach
description: 問題結構化教練。當需要：(1) 將模糊問題轉化為結構清晰的問題規格書 (2) 用 #問對問題 思考習慣分析問題根因 (3) 生成視覺化 HTML 問題規格書時使用此 Skill。基於密涅瓦大學 HC + PRD 分析框架。
---

# 問題結構化教練 v2.0

基於密涅瓦大學 #問對問題(#rightproblem) 思考習慣，將模糊問題轉化為 9 大區塊的「問題規格書」HTML。

## 觸發條件

用戶描述任何問題、困擾、挑戰，或明確說「幫我分析這個問題」。

## 工作流程

### Step 1：內部分析（不輸出給用戶）

收到問題描述後，在內部依序執行：

1. **5 Whys 根因分析**：連續問 5 次為什麼，找到根本原因
2. **問題重構**：嘗試 3 種方式描述問題，選最精準的
3. **症狀 vs 問題**：確認用戶描述的是症狀還是根本問題
4. **100x 資源測試**：區分障礙（可克服）vs 限制（必須繞過）
5. **優先級分類**：P1（不達成=無法解決）/ P2（不達成=明顯不滿）/ P3（錦上添花）
6. **魔鬼代言人**：挑戰自己的分析（隱含假設？範圍蔓延？替代方案？）

→ 詳見 `references/hc-guide.md` 和 `references/analysis-framework.md`

### Step 2：生成 HTML

1. 讀取 `references/template.html` 取得完整模板
2. 將分析結果填入 9 大區塊的 `{}` 佔位符
3. 資訊不足的欄位寫「[待補充]」

### Step 3：寫入檔案

```
輸出路徑：~/Desktop/問題規格書_{YYYYMMDD_HHMM}.html
```

用 Write tool 寫入完整 HTML，告知用戶用瀏覽器開啟。

## 9 大區塊

| # | 區塊 | 分析要點 |
|---|------|---------|
| 01 | 問題定義 | 5 Whys 找根因，區分症狀 vs 問題 |
| 02 | 目標 | P1/P2 優先級，P1 不超過 70% |
| 03 | 限制條件 | 100x 資源仍存在（物理/法規/行為/資源四類） |
| 04 | 障礙 | 100x 資源可解決，附根因和影響範圍 |
| 05 | 成功標準 | 禁用模糊詞，必須可驗證量化 |
| 06 | 建議方案 | 至少 3 方案比較（方案/解決/難度/費用） |
| 07 | 實施計劃 | Phase 1 快速上線的 3-4 步驟 |
| 08 | 排除範圍 | 明確不處理的事項，防範圍蔓延 |
| 09 | 風險與假設 | 魔鬼代言人挑戰 + 隱含假設 + 依賴風險 |

## 禁用模糊詞彙（強制替換）

| 禁止 | 替換為 |
|------|--------|
| 盡量/盡可能/適當地 | 明確數值 |
| 快速/即時/很快 | 具體時間 |
| 高品質/良好的/足夠的 | 可量測標準 |
| 等等/之類的/相關的 | 明確列舉 |
| 經常/偶爾/有時候 | 具體頻率 |
| 很多/一些/大量 | 具體數字 |

## 互動指令

| 指令 | 說明 |
|------|------|
| `/deep` | 先用 5 Whys 在聊天中引導用戶思考，再產出規格書 |
| `/help` | 說明 9 大區塊和 #問對問題 思考習慣 |

## 輸出規則

- **禁止**用純文字回覆分析結果
- **禁止**先問一堆問題再分析
- 收到問題 → 直接分析 → 寫入 HTML 檔案
- 聊天中只回覆：檔案路徑 + 一句話摘要（如「核心障礙是 X，建議方案 A」）

## 語言

繁體中文（台灣用語）
CODEX_LAZYPACK_RIGHTPROBLEM_COACH_SKILL_MD

# rightproblem-coach/references/analysis-framework.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/rightproblem-coach/references/analysis-framework.md")"
cat > "{{CODEX_HOME}}/skills/rightproblem-coach/references/analysis-framework.md" <<'CODEX_LAZYPACK_RIGHTPROBLEM_COACH_REFERENCES_ANALYSIS_FRAMEWORK_MD'
# 問題分析增強框架

基於 PRD 最佳實踐（spec-kit + 多代理評審），為問題規格書提供更深度的分析工具。

---

## 一、模糊詞彙偵測與替換

分析問題時，自動偵測並替換以下模糊用語：

| 類型 | 模糊詞彙 | 替換為 |
|------|---------|--------|
| 程度 | 盡量、盡可能、適當地 | 明確數值或條件 |
| 時間 | 即時、快速、很快、馬上 | 具體時間（如 < 30 分鐘、3 天內） |
| 範圍 | 等等、之類的、相關的 | 明確列舉所有項目 |
| 品質 | 高品質、良好的、足夠的 | 可量測標準（如正確率 > 95%） |
| 頻率 | 經常、偶爾、有時候 | 具體頻率（如每週 3 次、月發生率 < 5%） |
| 能力 | 應該能夠、可以考慮 | 「必須」或「不在範圍內」 |
| 數量 | 很多、一些、大量 | 具體數字（如 > 100 筆、3-5 個） |

**規則**：問題規格書中不允許出現任何上述模糊詞彙。

---

## 二、優先級分類決策樹

```
這個目標...

不達成時問題是否完全無法解決？
  ├─ 是 → P1（Must-Have）
  └─ 否
      不達成時用戶會明顯不滿？
        ├─ 是 → P2（Should-Have）
        └─ 否 → P3（Nice-to-Have）
```

**比例建議**：P1 佔 60-70%，P2 佔 20-25%，P3 佔 10-15%

---

## 三、成功標準品質規則

### 合格的成功標準

使用 Given/When/Then 思維驗證：

| 好的成功標準 | 差的成功標準 |
|------------|------------|
| 每週平均睡眠 ≥ 7 小時 | 睡眠品質提升 |
| 月營收達到 50 萬 | 營收成長 |
| 客戶等待時間 < 5 分鐘 | 客戶服務更快 |
| 離職率從 25% 降到 15% | 員工更滿意 |
| 每週運動 ≥ 3 次，每次 ≥ 30 分鐘 | 多運動 |

### 三種情境覆蓋

每個成功標準應考慮：
1. **正常情境**（Happy Path）：理想狀態下的達標標準
2. **邊界情境**（Boundary）：最低可接受標準
3. **異常情境**（Edge Case）：什麼情況下視為失敗

---

## 四、障礙 vs 限制：100x 資源測試（進階版）

### 基本判定

- **障礙（Obstacle）**：100 倍資源能解決 → 放 Section 04
- **限制（Constraint）**：100 倍資源仍存在 → 放 Section 03

### 限制的四大類型

| 類型 | 範例 | 特徵 |
|------|------|------|
| 物理/技術限制 | 手機螢幕只有 6 吋 | 客觀存在，無法改變 |
| 法規/政策限制 | 個資法規定不能收集 X 資料 | 外部規則，必須遵守 |
| 行為/文化限制 | 不能要求客戶改變使用習慣 | 人的行為難以強制改變 |
| 資源/預算限制 | 預算為零、只有 1 人 | 可協商但當前為硬限制 |

### 障礙的深層分析

每個障礙需回答：
- **根本原因是什麼？**（用 5 Whys 分析）
- **影響範圍有多大？**（只影響一個目標 or 多個目標？）
- **解決的優先順序？**（解決 OB-01 是否能連帶解決 OB-02？）

---

## 五、魔鬼代言人問題清單

分析完成後，用以下問題挑戰自己的分析：

### 隱含假設
- 這個分析是否假設了「現狀會持續」？
- 是否假設了利害關係人的支持？
- 是否假設了技術方案的可行性？

### 範圍蔓延風險
- 這個問題的邊界是否夠清楚？
- 有沒有可能在執行時不斷擴大範圍？
- 排除範圍是否足夠明確？

### 替代方案盲點
- 有沒有「完全不做」的選項？
- 有沒有更低成本的替代方案？
- 有沒有可能問題會自行解決？

### 依賴風險
- 方案是否依賴他人的配合？
- 如果關鍵依賴失敗，有什麼備案？

---

## 六、問題重構技巧

當分析卡住時，嘗試用不同角度重新定義問題：

| 重構方法 | 問法 |
|---------|------|
| 反轉 | 「如果問題的反面是什麼？」 |
| 放大 | 「如果這個問題影響 1000 人而不是 10 人？」 |
| 縮小 | 「如果只解決這個問題的一小部分，哪部分最有價值？」 |
| 換人 | 「如果從用戶/老闆/競爭對手的角度，問題是什麼？」 |
| 換時間 | 「一年後回頭看，什麼才是真正重要的？」 |

---

## 七、PRD 反模式（問題分析版）

| 反模式 | 問題 | 修正 |
|--------|------|------|
| 需求含糊 | 「系統應該更快」 | 改為「頁面載入 < 2 秒」 |
| 範圍蔓延 | 未明確排除範圍 | 加入排除範圍章節 |
| 解決方案混入問題 | 把手段當目標 | 區分「要達成什麼」vs「怎麼達成」 |
| 缺少驗收標準 | 成功無法驗證 | 每個目標附量化標準 |
| 優先級全是 P1 | 無法區分輕重 | 強制 P1 不超過 70% |
| 把症狀當問題 | 治標不治本 | 用 5 Whys 找根因 |
CODEX_LAZYPACK_RIGHTPROBLEM_COACH_REFERENCES_ANALYSIS_FRAMEWORK_MD

# rightproblem-coach/references/hc-guide.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/rightproblem-coach/references/hc-guide.md")"
cat > "{{CODEX_HOME}}/skills/rightproblem-coach/references/hc-guide.md" <<'CODEX_LAZYPACK_RIGHTPROBLEM_COACH_REFERENCES_HC_GUIDE_MD'
# #問對問題(#rightproblem) — 思考習慣指南

> 花再多時間解決錯誤的問題，都是浪費。在動手之前，先確認你問的是對的問題。

來源：密涅瓦大學 76 個思考習慣（Habits of Mind）

---

## 核心精神

愛因斯坦：「如果我有一個小時來解決問題，我會花 55 分鐘思考問題是什麼，5 分鐘思考解決方案。」

AI 時代的陷阱：AI 太好用了，你問什麼它就認真回答什麼——即使那個問題本身是錯的。例如你問「怎麼讓會議更有效率？」，但真正的問題可能是「這個會議根本不需要開」。

---

## 四大核心技巧

### 1. 五個為什麼（5 Whys）

豐田汽車發明的方法。連續問五次「為什麼」，找到根本原因。

範例：
- 問題：專案延遲了
- Why 1：程式碼有 bug
- Why 2：測試不夠完整
- Why 3：時間不夠測試
- Why 4：需求變更太頻繁
- Why 5：**初期需求分析不夠徹底** ← 根本原因

→ 真正要解決的不是 bug，而是需求分析流程。

### 2. 問題重構

同一個現象，不同的描述 → 不同的解決方向：

| 問題描述 | 可能方向 |
|---------|---------|
| 員工離職率太高 | 加薪、改善福利 |
| 員工對工作不滿意 | 改善工作內容、發展機會 |
| 公司文化有問題 | 領導風格、價值觀調整 |

選對問題的框架，比選對解決方案更重要。

### 3. 利害關係人分析

不同的人對「問題」有不同定義：
- 工程師 → 技術挑戰
- 業務 → 營收目標
- 用戶 → 使用體驗

在定義問題前，先搞清楚：**誰的問題才是真正需要解決的問題？**

### 4. AI 輔助問題探索

用 AI 幫你「重新思考問題」：
> 「我目前把問題定義為 X。請幫我分析這個問題定義可能遺漏什麼？有沒有更好的問題框架？」

---

## 什麼時候需要 #問對問題？

- **專案開始前**：確認要解決的是對的問題
- **遇到瓶頸時**：可能不是解決方案不對，而是問題定義不對
- **使用 AI 之前**：確認 prompt 問的是對的問題
- **團隊意見分歧時**：可能大家對「問題是什麼」有不同理解
- **解決方案效果不好時**：退一步想想，問題定義對嗎？

---

## 常見的坑

1. **太快跳到解決方案**：一看到問題就想解決，沒有先確認問題對不對
2. **接受別人給的問題定義**：老闆說問題是 X，就去解決 X，沒有質疑
3. **把症狀當成問題**：「離職率高」是症狀，不是問題本身
4. **問題太模糊**：「改善用戶體驗」不是一個可以解決的問題

---

## 自我檢查清單

- [ ] 你有沒有問過「這真的是需要解決的問題嗎？」
- [ ] 你有沒有探索過其他的問題定義？
- [ ] 利害關係人對問題的定義一致嗎？
- [ ] 這個問題定義足夠具體，可以產生可行的解決方案嗎？
- [ ] 你有沒有把症狀和問題區分開來？
CODEX_LAZYPACK_RIGHTPROBLEM_COACH_REFERENCES_HC_GUIDE_MD

# rightproblem-coach/references/template.html
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/rightproblem-coach/references/template.html")"
cat > "{{CODEX_HOME}}/skills/rightproblem-coach/references/template.html" <<'CODEX_LAZYPACK_RIGHTPROBLEM_COACH_REFERENCES_TEMPLATE_HTML'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>問題規格書</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700;900&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet">
<script src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>
<style>
  *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

  body {
    background: #E8E6E1;
    font-family: 'Noto Sans TC', sans-serif;
    color: #1A1A1A;
    line-height: 1.7;
    display: flex;
    justify-content: center;
    padding: 40px 20px;
  }

  #capture {
    width: 794px;
    min-height: 1123px;
    background: #F7F6F3;
    padding: 48px 52px 60px;
    position: relative;
  }

  /* ── Download Button ── */
  .download-btn {
    position: fixed;
    top: 20px;
    right: 20px;
    background: #6B5CE7;
    color: #fff;
    border: none;
    border-radius: 10px;
    padding: 10px 22px;
    font-family: 'Noto Sans TC', sans-serif;
    font-size: 14px;
    font-weight: 700;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 6px;
    box-shadow: 0 4px 16px rgba(107,92,231,.35);
    transition: transform .15s, box-shadow .15s;
    z-index: 9999;
  }
  .download-btn:hover {
    transform: translateY(-1px);
    box-shadow: 0 6px 20px rgba(107,92,231,.45);
  }
  .download-btn .material-icons-outlined { font-size: 18px; }

  /* ── Header ── */
  .header { margin-bottom: 36px; }

  .header-badge {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    background: #EEEBFF;
    color: #6B5CE7;
    font-size: 13px;
    font-weight: 700;
    padding: 5px 14px;
    border-radius: 20px;
    margin-bottom: 12px;
  }
  .header-badge .material-icons-outlined { font-size: 16px; }

  .header-title {
    font-size: 32px;
    font-weight: 900;
    color: #1A1A1A;
    letter-spacing: -.5px;
    margin-bottom: 16px;
  }

  .header-meta {
    display: flex;
    gap: 24px;
    flex-wrap: wrap;
  }
  .meta-item {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 13px;
    color: #888;
  }
  .meta-item .material-icons-outlined { font-size: 16px; color: #AAA; }
  .meta-value {
    font-weight: 700;
    color: #444;
  }

  .header-divider {
    margin-top: 20px;
    border: none;
    border-top: 2px solid #E0DCD6;
  }

  /* ── Sections ── */
  .section { margin-bottom: 32px; }

  .section-head {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 14px;
  }

  .section-icon {
    width: 40px;
    height: 40px;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
  }
  .section-icon .material-icons-outlined { font-size: 22px; }

  .section-label { display: flex; flex-direction: column; }
  .section-num { font-size: 12px; color: #AAA; font-weight: 500; line-height: 1.2; }
  .section-title { font-size: 20px; font-weight: 900; color: #1A1A1A; line-height: 1.3; }

  .content-box {
    background: #fff;
    border: 1px solid #E0DCD6;
    border-radius: 12px;
    padding: 20px;
  }

  /* ── Item rows ── */
  .item-row {
    display: flex;
    gap: 12px;
    padding: 14px 0;
    border-bottom: 1px solid #F0EEE9;
    align-items: flex-start;
  }
  .item-row:last-child { border-bottom: none; }
  .item-row:first-child { padding-top: 0; }

  .item-label {
    font-size: 13px;
    font-weight: 700;
    color: #888;
    min-width: 56px;
    flex-shrink: 0;
    padding-top: 2px;
  }
  .item-text {
    font-size: 15px;
    color: #333;
    line-height: 1.7;
    flex: 1;
  }

  .item-num {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 22px;
    height: 22px;
    border-radius: 50%;
    background: #F0EEE9;
    font-size: 12px;
    font-weight: 700;
    color: #888;
    flex-shrink: 0;
    margin-top: 2px;
  }

  .item-icon {
    font-size: 16px;
    flex-shrink: 0;
    margin-top: 3px;
  }

  /* ── Priority badges ── */
  .priority-badge {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    font-size: 12px;
    font-weight: 700;
    padding: 3px 10px;
    border-radius: 6px;
    flex-shrink: 0;
    margin-top: 1px;
  }
  .priority-p1 { background: #FFE0EC; color: #D63384; }
  .priority-p2 { background: #FFF3D6; color: #D4900A; }

  /* ── Constraint / Obstacle IDs ── */
  .item-id {
    font-size: 12px;
    font-weight: 700;
    color: #AAA;
    background: #F5F5F5;
    padding: 2px 8px;
    border-radius: 4px;
    flex-shrink: 0;
    margin-top: 2px;
  }

  .sub-field {
    font-size: 13px;
    color: #666;
    margin-top: 6px;
    padding-left: 4px;
    line-height: 1.6;
  }
  .sub-field strong {
    color: #888;
    font-weight: 700;
  }

  /* ── Comparison Table (Section 06) ── */
  .compare-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 14px;
  }
  .compare-table th {
    text-align: left;
    font-size: 12px;
    font-weight: 700;
    color: #AAA;
    padding: 10px 12px;
    border-bottom: 2px solid #E0DCD6;
    white-space: nowrap;
  }
  .compare-table td {
    padding: 12px;
    border-bottom: 1px solid #F0EEE9;
    color: #333;
    vertical-align: top;
  }
  .compare-table tr:last-child td { border-bottom: none; }

  .compare-table .recommend {
    background: #EEEBFF;
    border-radius: 0;
  }
  .compare-table .recommend td {
    color: #6B5CE7;
    font-weight: 700;
    border-bottom-color: #DDD8FF;
  }
  .compare-table .recommend td:first-child::before {
    content: '\2605';
    margin-right: 4px;
  }

  /* ── Timeline (Section 07) ── */
  .timeline {
    position: relative;
    padding-left: 36px;
  }
  .timeline::before {
    content: '';
    position: absolute;
    left: 13px;
    top: 8px;
    bottom: 8px;
    width: 2px;
    background: #E0DCD6;
  }

  .timeline-item {
    position: relative;
    padding: 0 0 24px 0;
  }
  .timeline-item:last-child { padding-bottom: 0; }

  .timeline-dot {
    position: absolute;
    left: -36px;
    top: 0;
    width: 28px;
    height: 28px;
    border-radius: 50%;
    background: #6B5CE7;
    color: #fff;
    font-size: 13px;
    font-weight: 700;
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1;
  }

  .timeline-content {
    background: #FAFAF8;
    border: 1px solid #F0EEE9;
    border-radius: 8px;
    padding: 12px 16px;
  }
  .timeline-title {
    font-size: 15px;
    font-weight: 700;
    color: #1A1A1A;
    margin-bottom: 2px;
  }
  .timeline-desc {
    font-size: 13px;
    color: #888;
    line-height: 1.6;
  }

  /* ── Exclusion items (Section 08) ── */
  .exclusion-item {
    display: flex;
    align-items: flex-start;
    gap: 10px;
    padding: 12px 0;
    border-bottom: 1px solid #F0EEE9;
    font-size: 15px;
    color: #333;
  }
  .exclusion-item:last-child { border-bottom: none; }
  .exclusion-item:first-child { padding-top: 0; }
  .exclusion-icon {
    font-size: 16px;
    flex-shrink: 0;
    margin-top: 3px;
    color: #D63384;
  }

  /* ── Risk / Assumption blocks (Section 09) ── */
  .sub-block { margin-bottom: 16px; }
  .sub-block:last-child { margin-bottom: 0; }

  .sub-block-title {
    font-size: 14px;
    font-weight: 700;
    color: #888;
    margin-bottom: 10px;
    display: flex;
    align-items: center;
    gap: 6px;
  }

  .risk-item {
    display: flex;
    align-items: flex-start;
    gap: 10px;
    padding: 10px 0;
    border-bottom: 1px solid #F0EEE9;
    font-size: 15px;
    color: #333;
  }
  .risk-item:last-child { border-bottom: none; }
  .risk-item:first-child { padding-top: 0; }
  .risk-icon {
    font-size: 16px;
    flex-shrink: 0;
    margin-top: 3px;
  }

  /* ── Print ── */
  @media print {
    .download-btn { display: none !important; }
    body { background: #fff; padding: 0; }
    #capture { box-shadow: none; }
  }
</style>
</head>
<body>

<button class="download-btn" onclick="downloadPNG()">
  <span class="material-icons-outlined">download</span>
  下載 PNG
</button>

<div id="capture">

  <!-- ════════════ HEADER ════════════ -->
  <div class="header">
    <div class="header-badge">
      <span class="material-icons-outlined">psychology</span>
      問題結構化分析
    </div>
    <h1 class="header-title">問題規格書</h1>
    <div class="header-meta">
      <div class="meta-item">
        <span class="material-icons-outlined">schedule</span>
        產生時間
        <span class="meta-value">{generated_time}</span>
      </div>
      <div class="meta-item">
        <span class="material-icons-outlined">layers</span>
        問題層級
        <span class="meta-value">{problem_level}</span>
      </div>
      <div class="meta-item">
        <span class="material-icons-outlined">speed</span>
        複雜度
        <span class="meta-value">{complexity}</span>
      </div>
    </div>
    <hr class="header-divider">
  </div>

  <!-- ════════════ 01 問題定義 ════════════ -->
  <div class="section">
    <div class="section-head">
      <div class="section-icon" style="background:#FFE0EC;">
        <span class="material-icons-outlined" style="color:#D63384;">report_problem</span>
      </div>
      <div class="section-label">
        <span class="section-num">SECTION 01</span>
        <span class="section-title">問題定義</span>
      </div>
    </div>
    <div class="content-box">
      <div class="item-row">
        <span class="item-label">現況</span>
        <span class="item-text">{current_situation}</span>
      </div>
      <div class="item-row">
        <span class="item-label">痛點</span>
        <div class="item-text">
          <div style="display:flex;align-items:flex-start;gap:8px;margin-bottom:6px;">
            <span class="item-num">1</span>
            <span>{pain_point_1}</span>
          </div>
          <div style="display:flex;align-items:flex-start;gap:8px;margin-bottom:6px;">
            <span class="item-num">2</span>
            <span>{pain_point_2}</span>
          </div>
          <div style="display:flex;align-items:flex-start;gap:8px;">
            <span class="item-num">3</span>
            <span>{pain_point_3}</span>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- ════════════ 02 目標 ════════════ -->
  <div class="section">
    <div class="section-head">
      <div class="section-icon" style="background:#FFF3D6;">
        <span class="material-icons-outlined" style="color:#D4900A;">flag</span>
      </div>
      <div class="section-label">
        <span class="section-num">SECTION 02</span>
        <span class="section-title">目標</span>
      </div>
    </div>
    <div class="content-box">
      <div class="item-row">
        <span class="priority-badge priority-p1">P1</span>
        <span class="item-text" style="display:flex;align-items:flex-start;gap:6px;">
          <span style="color:#0A8A4A;font-size:15px;flex-shrink:0;">&#x2705;</span>
          <span>{goal_p1_1}</span>
        </span>
      </div>
      <div class="item-row">
        <span class="priority-badge priority-p1">P1</span>
        <span class="item-text" style="display:flex;align-items:flex-start;gap:6px;">
          <span style="color:#0A8A4A;font-size:15px;flex-shrink:0;">&#x2705;</span>
          <span>{goal_p1_2}</span>
        </span>
      </div>
      <div class="item-row">
        <span class="priority-badge priority-p2">P2</span>
        <span class="item-text" style="display:flex;align-items:flex-start;gap:6px;">
          <span style="color:#0A8A4A;font-size:15px;flex-shrink:0;">&#x2705;</span>
          <span>{goal_p2_1}</span>
        </span>
      </div>
    </div>
  </div>

  <!-- ════════════ 03 限制條件 ════════════ -->
  <div class="section">
    <div class="section-head">
      <div class="section-icon" style="background:#FFE0EC;">
        <span class="material-icons-outlined" style="color:#D63384;">block</span>
      </div>
      <div class="section-label">
        <span class="section-num">SECTION 03</span>
        <span class="section-title">限制條件</span>
      </div>
    </div>
    <div class="content-box">
      <div class="item-row">
        <span class="item-id">CN-01</span>
        <span class="item-icon" style="color:#D63384;">&#x1F6AB;</span>
        <span class="item-text">{constraint_1}</span>
      </div>
      <div class="item-row">
        <span class="item-id">CN-02</span>
        <span class="item-icon" style="color:#D63384;">&#x1F6AB;</span>
        <span class="item-text">{constraint_2}</span>
      </div>
      <div class="item-row">
        <span class="item-id">CN-03</span>
        <span class="item-icon" style="color:#D63384;">&#x1F6AB;</span>
        <span class="item-text">{constraint_3}</span>
      </div>
    </div>
  </div>

  <!-- ════════════ 04 障礙 ════════════ -->
  <div class="section">
    <div class="section-head">
      <div class="section-icon" style="background:#D6F0FF;">
        <span class="material-icons-outlined" style="color:#0D7FBF;">construction</span>
      </div>
      <div class="section-label">
        <span class="section-num">SECTION 04</span>
        <span class="section-title">障礙</span>
      </div>
    </div>
    <div class="content-box">
      <div class="item-row" style="flex-direction:column;">
        <div style="display:flex;align-items:center;gap:12px;">
          <span class="item-id">OB-01</span>
          <span class="item-icon" style="color:#0D7FBF;">&rarr;</span>
          <span class="item-text" style="font-weight:700;">{obstacle_1}</span>
        </div>
        <div class="sub-field">
          <strong>根因：</strong>{obstacle_1_root_cause}<br>
          <strong>影響：</strong>{obstacle_1_impact}
        </div>
      </div>
      <div class="item-row" style="flex-direction:column;">
        <div style="display:flex;align-items:center;gap:12px;">
          <span class="item-id">OB-02</span>
          <span class="item-icon" style="color:#0D7FBF;">&rarr;</span>
          <span class="item-text" style="font-weight:700;">{obstacle_2}</span>
        </div>
        <div class="sub-field">
          <strong>根因：</strong>{obstacle_2_root_cause}<br>
          <strong>影響：</strong>{obstacle_2_impact}
        </div>
      </div>
    </div>
  </div>

  <!-- ════════════ 05 成功標準 ════════════ -->
  <div class="section">
    <div class="section-head">
      <div class="section-icon" style="background:#D6FFE8;">
        <span class="material-icons-outlined" style="color:#0A8A4A;">verified</span>
      </div>
      <div class="section-label">
        <span class="section-num">SECTION 05</span>
        <span class="section-title">成功標準</span>
      </div>
    </div>
    <div class="content-box">
      <div class="item-row">
        <span class="item-num">1</span>
        <span class="item-text">{success_criteria_1}</span>
      </div>
      <div class="item-row">
        <span class="item-num">2</span>
        <span class="item-text">{success_criteria_2}</span>
      </div>
      <div class="item-row">
        <span class="item-num">3</span>
        <span class="item-text">{success_criteria_3}</span>
      </div>
    </div>
  </div>

  <!-- ════════════ 06 建議方案 ════════════ -->
  <div class="section">
    <div class="section-head">
      <div class="section-icon" style="background:#EEEBFF;">
        <span class="material-icons-outlined" style="color:#6B5CE7;">lightbulb</span>
      </div>
      <div class="section-label">
        <span class="section-num">SECTION 06</span>
        <span class="section-title">建議方案</span>
      </div>
    </div>
    <div class="content-box" style="padding:0;overflow:hidden;">
      <table class="compare-table">
        <thead>
          <tr>
            <th style="width:24%;">方案</th>
            <th style="width:36%;">解決</th>
            <th style="width:20%;">難度</th>
            <th style="width:20%;">費用</th>
          </tr>
        </thead>
        <tbody>
          <tr class="recommend">
            <td>{solution_a_name}</td>
            <td>{solution_a_solve}</td>
            <td>{solution_a_difficulty}</td>
            <td>{solution_a_cost}</td>
          </tr>
          <tr>
            <td>{solution_b_name}</td>
            <td>{solution_b_solve}</td>
            <td>{solution_b_difficulty}</td>
            <td>{solution_b_cost}</td>
          </tr>
          <tr>
            <td>{solution_c_name}</td>
            <td>{solution_c_solve}</td>
            <td>{solution_c_difficulty}</td>
            <td>{solution_c_cost}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>

  <!-- ════════════ 07 實施計劃 ════════════ -->
  <div class="section">
    <div class="section-head">
      <div class="section-icon" style="background:#D6FFE8;">
        <span class="material-icons-outlined" style="color:#0A8A4A;">rocket_launch</span>
      </div>
      <div class="section-label">
        <span class="section-num">SECTION 07</span>
        <span class="section-title">實施計劃</span>
      </div>
    </div>
    <div class="content-box">
      <div class="timeline">
        <div class="timeline-item">
          <div class="timeline-dot">1</div>
          <div class="timeline-content">
            <div class="timeline-title">{step_1_title}</div>
            <div class="timeline-desc">{step_1_desc}</div>
          </div>
        </div>
        <div class="timeline-item">
          <div class="timeline-dot">2</div>
          <div class="timeline-content">
            <div class="timeline-title">{step_2_title}</div>
            <div class="timeline-desc">{step_2_desc}</div>
          </div>
        </div>
        <div class="timeline-item">
          <div class="timeline-dot">3</div>
          <div class="timeline-content">
            <div class="timeline-title">{step_3_title}</div>
            <div class="timeline-desc">{step_3_desc}</div>
          </div>
        </div>
        <div class="timeline-item">
          <div class="timeline-dot">4</div>
          <div class="timeline-content">
            <div class="timeline-title">{step_4_title}</div>
            <div class="timeline-desc">{step_4_desc}</div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- ════════════ 08 排除範圍 ════════════ -->
  <div class="section">
    <div class="section-head">
      <div class="section-icon" style="background:#F5F5F5;">
        <span class="material-icons-outlined" style="color:#666;">do_not_disturb</span>
      </div>
      <div class="section-label">
        <span class="section-num">SECTION 08</span>
        <span class="section-title">排除範圍</span>
      </div>
    </div>
    <div class="content-box">
      <div class="exclusion-item">
        <span class="exclusion-icon">&#x26D4;</span>
        <span>{exclusion_1}</span>
      </div>
      <div class="exclusion-item">
        <span class="exclusion-icon">&#x26D4;</span>
        <span>{exclusion_2}</span>
      </div>
      <div class="exclusion-item">
        <span class="exclusion-icon">&#x26D4;</span>
        <span>{exclusion_3}</span>
      </div>
    </div>
  </div>

  <!-- ════════════ 09 風險與假設 ════════════ -->
  <div class="section">
    <div class="section-head">
      <div class="section-icon" style="background:#FFF3D6;">
        <span class="material-icons-outlined" style="color:#D4900A;">warning</span>
      </div>
      <div class="section-label">
        <span class="section-num">SECTION 09</span>
        <span class="section-title">風險與假設</span>
      </div>
    </div>
    <div class="content-box">
      <div class="sub-block">
        <div class="sub-block-title">
          <span style="font-size:15px;">&#x26A0;&#xFE0F;</span>
          假設
        </div>
        <div class="risk-item">
          <span class="risk-icon" style="color:#D4900A;">&#x26A0;&#xFE0F;</span>
          <span>{assumption_1}</span>
        </div>
        <div class="risk-item">
          <span class="risk-icon" style="color:#D4900A;">&#x26A0;&#xFE0F;</span>
          <span>{assumption_2}</span>
        </div>
      </div>
      <div class="sub-block" style="border-top:1px solid #F0EEE9;padding-top:16px;">
        <div class="sub-block-title">
          <span style="font-size:15px;">&#x26A0;&#xFE0F;</span>
          風險
        </div>
        <div class="risk-item">
          <span class="risk-icon" style="color:#D63384;">&#x26A0;&#xFE0F;</span>
          <span>{risk_1}</span>
        </div>
        <div class="risk-item">
          <span class="risk-icon" style="color:#D63384;">&#x26A0;&#xFE0F;</span>
          <span>{risk_2}</span>
        </div>
      </div>
    </div>
  </div>

</div><!-- /#capture -->

<script>
function downloadPNG() {
  const btn = document.querySelector('.download-btn');
  btn.style.display = 'none';
  html2canvas(document.getElementById('capture'), {
    scale: 2,
    useCORS: true,
    backgroundColor: '#F7F6F3'
  }).then(function(canvas) {
    const link = document.createElement('a');
    link.download = '問題規格書.png';
    link.href = canvas.toDataURL('image/png');
    link.click();
    btn.style.display = 'block';
  }).catch(function() {
    btn.style.display = 'block';
  });
}
</script>

</body>
</html>
CODEX_LAZYPACK_RIGHTPROBLEM_COACH_REFERENCES_TEMPLATE_HTML

test -f "{{CODEX_HOME}}/skills/rightproblem-coach/SKILL.md" && echo "rightproblem-coach installed"

echo "embedded skills installed: rightproblem-coach"
```

<!-- END EMBEDDED_SKILLS -->
