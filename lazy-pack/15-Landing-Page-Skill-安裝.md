# 15-Landing-Page-Skill-安裝

> 2026-05-24 更新：本文件已改為自含式 Skill 安裝文件。請使用文末「內建 Skill 完整安裝內容」，不要再依賴舊版 `對應序號文件的內嵌 Skill 區塊：` 子目錄。


> 版本：2026-05-24 Codex App 版
> 用途：把引導式 Landing Page 生成流程安裝成 Codex App 全域 Skill，用來產生課程頁、銷售頁、活動報名頁、產品頁或名單收集頁。
> 成品：下載者可把本懶人包內的 `對應序號文件的內嵌 Skill 區塊：landing-page/` 複製到自己的 `{{CODEX_HOME}}/skills/landing-page/`，再用自然語句觸發。

## 來源與授權

- 原始來源頁：`https://cc.lifehacker.tw`
- 原始 repo：`https://github.com/lifehacker-tw/claude-code-mini-course.git`
- 原始 skill folder：`skills/landing-page/`
- 原作者：Raymond Hou / 雷蒙
- 原始授權：CC BY-NC-SA 4.0，個人使用、學習、分享自由，禁止商業用途。

本文件只做 Codex App 相容改寫。若要商業使用，請先確認原始授權與作者授權。

## 這版和原始來源工具文件的差異

| 原始文件 | Codex 版 |
|---|---|
| 安裝到來源工具的全域 skills 路徑 | 安裝到 `{{CODEX_HOME}}/skills/landing-page` |
| 依賴 slash command 或特定工具選單 | Codex 依 `SKILL.md` metadata 與自然語句觸發 |
| 可選 UUPM 設計工具 | UUPM 為選用；未安裝時使用 bundled fallback design rules |
| 可能假設特定本機路徑 | 全部改成 `{{...}}` 佔位符 |
| 只描述 workflow | 這版補齊 question bank、fallback design rules、HTML template 與 countdown script |

## 安裝方式

下載本懶人包後，讓 Codex 在你的設定專案根目錄執行：

```bash
mkdir -p "{{CODEX_HOME}}/skills/landing-page"
# 舊版 對應序號文件的內嵌 Skill 區塊 複製指令已取消；請使用文末「內建 Skill 完整安裝內容」。
test -f "{{CODEX_HOME}}/skills/landing-page/SKILL.md" && echo "landing-page installed"
```

安裝後開新 Codex 對話或重啟 Codex App，讓 skill metadata 重新載入。

## 驗證

```bash
test -f "{{CODEX_HOME}}/skills/landing-page/SKILL.md" && echo "SKILL.md ok"
test -f "{{CODEX_HOME}}/skills/landing-page/references/question-bank.md" && echo "question bank ok"
test -f "{{CODEX_HOME}}/skills/landing-page/references/fallback-design-rules.md" && echo "fallback design rules ok"
test -f "{{CODEX_HOME}}/skills/landing-page/templates/base.html" && echo "base template ok"
test -f "{{CODEX_HOME}}/skills/landing-page/templates/countdown.js" && echo "countdown template ok"
```

合理結果是五行都顯示 `ok`。

## 使用方式

安裝後開新 Codex 對話或重啟 Codex App，然後用下列任一方式觸發：

- 「使用 landing-page skill 幫我做一頁課程銷售頁」
- 「幫我做 landing page」
- 「做一頁活動報名頁」
- 「做產品頁」
- 「把這個頁面重新套 landing-page 風格」

Codex 會依 Skill 流程先訪談需求，再產生：

```text
generated-pages/<slug>/
├── index.html
├── answers.json
└── design-system.md
```

## 預設工作流程

1. 先判斷模式：引導模式、快速貼資料模式，或重套風格模式。
2. 用 `references/question-bank.md` 收集產品定位、頁面內容、受眾、CTA、倒數計時與定價等資訊。
3. 檢查專案是否已有 `DESIGN.md`；若沒有，就使用 `references/fallback-design-rules.md`。
4. 先提出 2 到 3 個視覺方向，等使用者選定後再產生 HTML。
5. 以 `templates/base.html` 產生單頁 HTML；需要倒數計時時才加入 `templates/countdown.js`。
6. 產出 `index.html`、`answers.json`、`design-system.md`。
7. 若可行，使用瀏覽器檢查桌面與手機寬度，確認沒有空白畫面、明顯重疊或破版。

## 踩坑紀錄

### 1. UUPM 是選用，不是前置依賴

若找不到 `uipro` 或 `ui-ux-pro-max`，不要中斷流程。直接使用 bundled fallback design rules。

### 2. 不要自動部署或接付款

Landing Page skill 只產生本機 HTML、內容結構與設計方向。不要自動部署、建立表單後端、串金流、收 API key 或寫入正式金流設定。

### 3. CTA 連結需要使用者提供

若使用者沒有提供正式 CTA URL，先使用 `#` 或明確標示 placeholder，不要自行編造付款、報名或外部服務連結。

### 4. 使用者素材優先

頁面文案只能使用使用者提供的答案、來源文件或明確授權內容。不要用個人記憶補 testimonials、銷售數字、名人背書或保證條款。

### 5. 修改全域 skill 後要重啟或開新對話

Codex App 不一定會在同一個對話立刻載入新的 skill metadata。安裝或改名後，開新對話或重啟 Codex App 再測試。

## 最終檢查清單

- [ ] `{{CODEX_HOME}}/skills/landing-page/SKILL.md` 存在。
- [ ] `SKILL.md` 的 `name` 是 `landing-page`。
- [ ] `metadata.short-description` 是 `Guided landing page generator`。
- [ ] `references/question-bank.md` 存在。
- [ ] `references/fallback-design-rules.md` 存在。
- [ ] `references/uupm-integration.md` 存在，且被視為選用。
- [ ] `templates/base.html` 存在。
- [ ] `templates/countdown.js` 存在。
- [ ] 開新 Codex 對話後，用「landing page」、「銷售頁」、「報名頁」或「活動頁」可觸發。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節取代舊版 `對應序號文件的內嵌 Skill 區塊：` 子目錄。這個序號項目會安裝：`landing-page`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `/Users/alex/.codex`。

```bash
set -e

decode_base64() {
  if base64 --help 2>/dev/null | grep -q -- '-d'; then
    base64 -d
  else
    base64 -D
  fi
}

# ---- landing-page ----
mkdir -p "{{CODEX_HOME}}/skills/landing-page"
# landing-page/README.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/landing-page/README.md")"
cat > "{{CODEX_HOME}}/skills/landing-page/README.md" <<'CODEX_LAZYPACK_LANDING_PAGE_README_MD'
# landing-page

Codex-compatible guided landing page skill adapted from "引導式 Landing Page 生成 by 雷小蒙 / Raymond Hou".

## What It Does

- Runs a structured interview for course, event, service, product, or signup landing pages.
- Generates `generated-pages/<slug>/index.html`.
- Saves `answers.json` for future rewrites or restyling.
- Saves `design-system.md` documenting the chosen visual direction.
- Supports optional countdown sections.
- Works without optional design tools by using bundled fallback design rules.

## Codex Usage

Ask naturally, for example:

- `使用 landing-page skill 幫我做一頁課程銷售頁`
- `幫我做 landing page`
- `幫我改版這個銷售頁`
- `用 landing-page 重新套風格`

Codex skills are triggered by metadata and context. Do not depend on a slash-command menu.

## Package Structure

```text
landing-page/
├── SKILL.md
├── README.md
├── references/
│   ├── question-bank.md
│   ├── uupm-integration.md
│   └── fallback-design-rules.md
└── templates/
    ├── base.html
    └── countdown.js
```

## Installation

Copy this folder to the Codex global skills folder:

```bash
mkdir -p "{{CODEX_HOME}}/skills/landing-page"
# 舊版 對應序號文件的內嵌 Skill 區塊 複製指令已取消；請使用文末「內建 Skill 完整安裝內容」。
```

Start a new Codex conversation or restart Codex App if the skill metadata does not refresh immediately.

## License

Source attribution: 雷蒙三十 Starter Kit / Raymond Hou.

License: CC BY-NC-SA 4.0. Personal use, learning, and sharing are allowed; commercial use is not allowed under this license.
CODEX_LAZYPACK_LANDING_PAGE_README_MD

# landing-page/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/landing-page/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/landing-page/SKILL.md" <<'CODEX_LAZYPACK_LANDING_PAGE_SKILL_MD'
---
name: landing-page
description: Use when the user asks to create, rewrite, or restyle a landing page, sales page, course page, event signup page, product launch page, or lead-capture page. Run a guided Traditional Chinese interview, then generate a complete single-page HTML landing page with copy, visual direction, optional countdown, answers.json, and preview instructions. Trigger phrases include landing page, landing-page skill, 銷售頁, 報名頁, 課程頁, 活動頁, 產品頁, and 幫我做 landing page.
metadata:
  short-description: Guided landing page generator
---

# Landing Page Skill

Use this skill to guide the user from a rough offer into a complete landing page. The source workflow was adapted for Codex App, so do not depend on slash-command menus, non-Codex skill folders, or assistant-specific installers.

## Operating Rules

1. Use Traditional Chinese by default unless the user requests another language.
2. Ask one question at a time unless the user asks for a fast mode or pastes all material at once.
3. Use only the user's answers and explicitly provided source files for the page content. Do not fill from memory, persona notes, or unrelated project context.
4. If the user is stuck, offer 3 draft options based only on the answers already collected.
5. Do not install optional design tools automatically. If a tool such as UUPM is unavailable, continue with fallback design rules.
6. Do not auto-deploy, wire payments, collect secrets, or create production forms. CTA links are plain links unless the user provides a safe target URL.
7. When output files are written, keep them under `generated-pages/<slug>/` in the active project unless the user chooses another folder.
8. After generating HTML for a local app or page, use available browser verification when practical, or report the exact file path for preview.

## Source Files

- `references/question-bank.md`: the guided 17-question interview and examples.
- `references/fallback-design-rules.md`: design rules to use when no external design system is available.
- `references/uupm-integration.md`: optional UUPM-compatible workflow. Treat this as optional and Codex-adapted.
- `templates/base.html`: single-page landing page skeleton.
- `templates/countdown.js`: countdown behavior for countdown-enabled pages.

## Workflow

### 1. Decide The Mode

Use guided mode by default:

- A. Product positioning: product type, industry, tone, slug.
- B. Page content: hero, hook, about, outcomes, testimonials, audience, info, pricing, FAQ, speaker or maker.
- C. Conversion layer: countdown, deadline behavior, CTA text, CTA URL.

Use fast mode when the user says they will paste everything at once. In fast mode, classify the pasted content into the same answer structure and ask only for missing critical fields.

Use restyle mode when the user asks to revise an existing generated page. First look for `generated-pages/<slug>/answers.json`; if it exists, reuse it and ask only what should change.

### 2. Collect Answers

Read `references/question-bank.md` before asking detailed interview questions.

For each guided question:

- Show the question.
- Include short good and weak examples when useful.
- Accept `skip` only for optional sections.
- Accept "幫我生 3 個" and provide three concise choices based on prior answers.

Store the final structured answers as:

```json
{
  "product": {
    "type": "",
    "industry": "",
    "tone": [],
    "slug": ""
  },
  "content": {
    "hero": { "title": "", "subtitle": "" },
    "hook": "",
    "about": "",
    "learn": [],
    "testimonials": [],
    "audience": { "fit": [], "unfit": [] },
    "info": [],
    "pricing": [],
    "faq": [],
    "speaker": { "name": "", "bio": [], "photo": "" }
  },
  "countdown": {
    "enabled": false,
    "deadline": "",
    "onZero": "ended-state"
  },
  "cta": { "text": "", "href": "#" }
}
```

### 3. Choose The Design Direction

First check whether the active project has a design guide:

- `DESIGN.md`
- `design.md`
- `docs/DESIGN.md`
- `brand/DESIGN.md`

If found, summarize the brand colors, typography, and tone, then ask whether to use it. If the user confirms, use it and skip optional design-system discovery.

If no design guide exists, check whether a Codex-compatible UUPM installation is available by looking for a `uipro` command or a Codex skill/package named `ui-ux-pro-max`. If it is unavailable or fails, use `references/fallback-design-rules.md`.

Always present 2 or 3 style directions before writing the page. Each direction should include color, typography, layout mood, section rhythm, and why it fits the offer.

### 4. Generate The Page

Use `templates/base.html` as the base structure and `templates/countdown.js` only when countdown is enabled.

The generated page should include:

- Sticky navigation with section anchors.
- Hero with clear promise and CTA.
- Hook or pain-point section.
- About or mechanism section.
- Outcomes or what-you-get section.
- Optional testimonials.
- Fit and unfit audience section.
- Event, product, or offer information.
- Pricing or plan section.
- CTA section.
- Speaker, maker, or brand section.
- FAQ section.

Keep the HTML self-contained:

- Use CDN assets only when suitable and disclosed.
- Inline CSS for design tokens and custom layout.
- Inline countdown JavaScript only when needed.
- Use image URLs supplied by the user, or placeholders that are clearly marked.

### 5. Write Outputs

Create:

```text
generated-pages/<slug>/
├── index.html
├── answers.json
└── design-system.md
```

`design-system.md` should summarize the chosen visual direction, including colors, fonts, layout rules, and notable constraints. If no external design system was used, say it was generated from fallback rules.

### 6. Verify

Before final response:

- Confirm `SKILL.md` support files were available if the skill package is being maintained.
- Confirm generated `index.html` exists.
- If a browser tool is available and the output is local, preview the page and check for blank rendering, obvious overlap, broken anchors, and mobile width issues.
- Report exact output paths and any verification not performed.

## Out Of Scope

- Payment processing.
- Form backend integration.
- Full deployment.
- Member portals or subscription apps.
- Refund or legal guarantee copy unless the user supplies exact text.
- Claims, testimonials, or credentials not provided by the user.

## Attribution

Adapted from "引導式 Landing Page 生成 by 雷小蒙 / Raymond Hou" under CC BY-NC-SA 4.0. Preserve attribution and non-commercial license notes when sharing this skill package.
CODEX_LAZYPACK_LANDING_PAGE_SKILL_MD

# landing-page/references/fallback-design-rules.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/landing-page/references/fallback-design-rules.md")"
cat > "{{CODEX_HOME}}/skills/landing-page/references/fallback-design-rules.md" <<'CODEX_LAZYPACK_LANDING_PAGE_REFERENCES_FALLBACK_DESIGN_RULES_MD'
# Fallback Design Rules — Codex fallback design mode

When UUPM or another external design system is unavailable, Codex should generate the visual direction directly from the user's answers. There is no industry design database in this mode, so follow these rules to keep the page polished and usable.

---

## 鐵律 1：字體只配一組

**只允許這幾種組合之一，不要自由發揮：**

| 組合 | Headline | Body | 適合 |
|:--|:--|:--|:--|
| A. 襯線 + 無襯線 | Noto Serif TC | Noto Sans TC | 編輯感、沉穩、高客單 |
| B. 純無襯線（中） | Noto Sans TC 700 | Noto Sans TC 400 | 現代、SaaS、簡潔 |
| C. 雙無襯線 | Space Grotesk | Inter | 英文為主、科技感 |

**不允許：** 手寫體、裝飾字體、多於兩種字體混用。

選哪組根據 A3（調性關鍵字）：
- 「沉穩／專業／高級」→ A
- 「現代／清晰／SaaS」→ B
- 「科技／極簡／英文」→ C

### Google Fonts import 範本

```html
<!-- 組合 A -->
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&family=Noto+Serif+TC:wght@400;500;700&display=swap" rel="stylesheet">

<!-- 組合 B -->
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@400;500;700&display=swap" rel="stylesheet">

<!-- 組合 C -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Space+Grotesk:wght@500;700&display=swap" rel="stylesheet">
```

---

## 鐵律 2：主色 + CTA 色 + 中性色三種內

**只允許 3 個主要顏色：**

```css
:root {
  --color-primary: /* 品牌主色 */;
  --color-cta: /* 按鈕／倒數／急迫元素 */;
  --color-text: /* 文字與中性色 */;

  /* 衍生色（從上面算出） */
  --color-bg: /* 背景，通常是主色的極淺色或白色 */;
  --color-muted: /* 次要文字，text 的 opacity 0.6 */;
  --color-border: /* 分隔線，text 的 opacity 0.1 */;
}
```

### 建議調色盤（依調性）

| 調性 | Primary | CTA | Text | Bg |
|:--|:--|:--|:--|:--|
| 沉穩專業 | `#1E3A5F`（深藍） | `#D4A017`（金） | `#1A1A1A` | `#FAFAF8` |
| 活力年輕 | `#FF5A5F`（珊瑚） | `#2B2D42`（炭） | `#1A1A1A` | `#FFFFFF` |
| 科技現代 | `#0F172A`（深炭） | `#3B82F6`（藍） | `#0F172A` | `#F8FAFC` |
| 高級編輯 | `#2D2A32`（黑紫） | `#C9A87C`（駝） | `#2D2A32` | `#FAF7F2` |
| 自然有機 | `#4A5D3A`（苔綠） | `#E07856`（陶） | `#2D2A32` | `#F5F2E8` |

根據 A3 調性關鍵字挑一組，或從這幾組衍生微調。

**禁止：**
- 超過 3 個主色（3 + 衍生色不算）
- 高飽和彩虹漸層（AI purple/pink gradient）
- 對比度低於 4.5:1

---

## 鐵律 3：間距走 8px base grid

**所有間距用 8 的倍數：**

| Token | px | Tailwind | 用途 |
|:--|:--|:--|:--|
| `space-1` | 4px | `p-1` | 微距（icon 旁） |
| `space-2` | 8px | `p-2` | 緊密 |
| `space-3` | 12px | `p-3` | 標準小 |
| `space-4` | 16px | `p-4` | 標準 |
| `space-6` | 24px | `p-6` | 區塊內 |
| `space-8` | 32px | `p-8` | 卡片 padding |
| `space-12` | 48px | `p-12` | section 間 |
| `space-16` | 64px | `p-16` | 大分隔 |
| `space-24` | 96px | `py-24` | section 垂直間距（桌機） |

### Section 垂直節奏

桌機：section 間 `py-24`（96px）
手機：section 間 `py-16`（64px）

Hero 區更大：桌機 `py-32`（128px），手機 `py-20`（80px）。

### Container 寬度

內容最大寬度：`max-w-2xl`（672px），閱讀型
宣傳／視覺：`max-w-4xl`（896px）
Grid／多欄：`max-w-5xl`（1024px）

**不允許：** 任意奇數間距（13px、17px、25px 之類）。

---

## 組合成 Tailwind 配置

生成 HTML 時把上面的規則注入成 inline `<style>` 或 Tailwind config：

```html
<script src="https://cdn.tailwindcss.com"></script>
<script>
  tailwind.config = {
    theme: {
      extend: {
        colors: {
          primary: 'var(--color-primary)',
          cta: 'var(--color-cta)',
        },
        fontFamily: {
          headline: ['var(--font-headline)'],
          body: ['var(--font-body)'],
        },
      },
    },
  };
</script>
```

---

## 最終檢查（每次 fallback 生成後跑）

- [ ] 字體用了剛好兩種（或一種）
- [ ] 主色 + CTA + 中性色，共 3 個主色
- [ ] 所有 padding / margin 都是 8 的倍數
- [ ] 對比度 4.5:1 以上
- [ ] `prefers-reduced-motion` 尊重
- [ ] CTA 按鈕有 `cursor-pointer` + hover transition 200-300ms
- [ ] 響應式斷點：375 / 768 / 1024

任何一項不符合，在 Step 5 的輸出訊息裡附 ⚠️ 提醒。
CODEX_LAZYPACK_LANDING_PAGE_REFERENCES_FALLBACK_DESIGN_RULES_MD

# landing-page/references/question-bank.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/landing-page/references/question-bank.md")"
cat > "{{CODEX_HOME}}/skills/landing-page/references/question-bank.md" <<'CODEX_LAZYPACK_LANDING_PAGE_REFERENCES_QUESTION_BANK_MD'
# Question Bank — 引導式問答完整題目

所有問題呈現時遵守這個樣板：

```
<編號>. <問題>

💡 <guardrail，好／壞範例>

🎯 你的答案：_______________

💬 或輸入：
   - skip 跳過（可選題才有這選項）
   - 幫我生 3 個 → AI 根據前面答案代生 3 版本
```

---

## 階段 A：產品定位（4 題，全部必填）

### A1. 你要做哪一種銷售頁？

```
A1. 你要做哪一種銷售頁？

💡 三種選一：
   1. 實體活動／工作坊／講座（有日期、地點、名額）
   2. 線上課程／自學課（無日期，隨時購買）
   3. 數位產品（模板、電子書、工具、訂閱包）

🎯 你的答案（1 / 2 / 3）：___
```

**用途：** 決定 info 區塊的欄位（活動要日期地點名額，線上課要模組數，數位產品要格式/規格）。

### A2. 你的產品屬於什麼產業／主題？

```
A2. 你的產品屬於什麼產業／主題？（中文自由描述）

💡 講清楚產品在做什麼、屬於什麼領域
   ✅ 「Notion 線上課程，教生產力管理」
   ✅ 「AI 寫作工具，幫自媒體寫文案」
   ✅ 「美容 spa，主打放鬆療程」
   ❌ 「很棒的課程」（太模糊）

AI 會自動翻譯成英文關鍵字去餵 UUPM，不用手動翻譯。

🎯 你的答案（中文）：_______________
```

**AI 處理邏輯：** 收到中文答案後，內部翻譯成 3-5 個英文關鍵字當 UUPM query。翻譯結果給使用者看一眼（「我會用 `xxx xxx xxx` 去搜 UUPM，OK 嗎？」），確認後才送。

### A3. 你的品牌調性 3 個關鍵字？

```
A3. 你的品牌調性 3 個關鍵字？

💡 這會輔助 UUPM 挑風格
   範例：
   - 「沉穩、專業、親和」→ 會選 Soft UI / Minimalism
   - 「活潑、年輕、大膽」→ 會選 Neubrutalism / Vibrant
   - 「高級、編輯感、留白」→ 會選 Exaggerated Minimalism

🎯 你的答案（3 個詞，逗號分隔）：_______________
```

### A4. 產品名稱 / slug？

```
A4. 產品名稱 / slug（英數字與連字號，會當資料夾名稱）

💡 格式：小寫英文 + 連字號
   ✅ notion-one-day
   ✅ ai-writing-system
   ❌ Notion 一日班（中文不能當 slug）
   ❌ Product Name With Spaces

🎯 你的答案：_______________
```

---

## 階段 B：內容填入（10 題）

### B1. 一句話說清楚你能帶給受眾的改變？

```
B1. 一句話說清楚你能帶給受眾的改變？（可加成果數字更具體）

💡 重點：不是描述產品，是描述「用了之後人會變怎樣」
   ✅ 「30 天把寫銷售頁從 3 天縮到 3 小時」（改變 + 數字）
   ✅ 「幫創作者把想法從腦袋搬到 IG 不再卡關」（改變 + 對象）
   ❌ 「Notion 一日入門實體班」（只是產品名）
   ❌ 「專業 Notion 教學課程」（形容詞堆疊）

🎯 你的答案：_______________
```

**對應區塊：** Hero title。

### B2. 受眾的痛點？他們深夜睡不著煩的事

```
B2. 你的受眾現在最痛的 2-3 件事？

💡 寫實、具體、可驗證
   ✅ 「想整理 Notion 但每次開了就不知道從哪下手，拖了半年」
   ✅ 「寫 IG 文案寫到凌晨三點，隔天還是沒貼」
   ❌ 「效率不夠好」（太抽象）

🎯 你的答案（2-3 點）：_______________
```

**對應區塊：** Hook section。

### B3. 產品／課程簡介（2-3 段）

```
B3. 用 2-3 段講清楚你的產品是什麼、怎麼運作、有什麼特別

💡 第一段：這是什麼
   第二段：怎麼跟別人不一樣
   第三段：你為什麼能做這個（你的 credibility）

🎯 你的答案：_______________
```

**對應區塊：** About section。

### B4. 學完／買完能具體做到 3-5 件事

```
B4. 使用者用完你的產品後，能具體做到哪 3-5 件事？

💡 動詞開頭、可驗證
   ✅ 「做出第一個可發布的 Notion 模板」
   ✅ 「寫出 5 支可發到 IG 的短影片腳本」
   ❌ 「變得更有效率」（無法驗證）

🎯 你的答案（3-5 點）：_______________
```

**對應區塊：** What you'll learn section。

### B5a. 要不要放學員見證？（Y/N）

```
B5a. 要不要放學員見證／使用者回饋？

💡 有 3 則以上再放、沒有就跳過（比擺假見證好太多）

🎯 你的答案（y / n）：___
```

### B5b.（若 B5a=Y）見證內容

```
B5b. 3-5 則見證，每則包含：姓名 / 角色 / 一段話

💡 好見證講「具體改變」而不是「很棒」
   ✅ 「上完課我把 4 個系統合併成 1 個 Notion，每天省 40 分鐘」— 小明／文字工作者
   ❌ 「老師很厲害，推薦大家上」— 小明

🎯 你的答案（一則一則貼，或 json 格式）：_______________
```

**對應區塊：** Testimonials section（可選）。

### B6. 適合誰？不適合誰？

```
B6. 明確標示：適合誰、不適合誰

💡 標不適合的人反而會提升轉換，讓適合的人感覺更確信
   適合：
   - [對象類型 1]
   - [對象類型 2]
   - [對象類型 3]
   不適合：
   - [類型 1]
   - [類型 2]

🎯 你的答案：_______________
```

**對應區塊：** Audience section。

### B7. 日期／規格／數量資訊

```
B7. 填入這場活動／課程／產品的硬資訊（會用 emoji icon 呈現）

💡 依 A1 的類型不同：
   實體活動：📅 日期時間 / ⏱️ 總時長 / 📍 地點 / 👥 名額 / 💻 攜帶設備
   線上課程：📦 模組數 / ⏱️ 總時長 / 📹 影片型式 / 👥 報名人數 / 🔄 更新政策
   數位產品：📦 格式 / 📄 頁數／檔案數 / 🔄 更新政策 / 💾 檔案大小

🎯 你的答案（label: value 一行一條）：_______________
```

**對應區塊：** Info section。

### B8. 價格方案

```
B8. 價格方案（可多方案：早鳥 / 原價 / VIP）

💡 每個方案包含：
   - 方案名稱（早鳥 / 原價 / VIP）
   - 價格
   - 備註（早鳥截止時間、VIP 加值內容等）

🎯 你的答案：_______________
```

**對應區塊：** Pricing section。

### B9. FAQ（至少 3 題）

```
B9. 列 3-7 則最常被問到的問題 + 回答

💡 問學員最可能猶豫的點：
   - 我真的學得來嗎？（適合度）
   - 跟 OO 有什麼不一樣？（對比）
   - 可以退款嗎？（風險感知）
   - 需要準備什麼？（準備成本）

🎯 你的答案（Q: ... / A: ... 格式）：_______________
```

**對應區塊：** FAQ section。

### B10. 講師／創作者介紹

```
B10. 關於你（或講師），姓名 + 3-5 點經歷 + 照片 URL（可 skip 照片）

💡 經歷選跟這個產品最相關的
   ✅ 賣 Notion 課 → 列 Notion 相關成就（教過幾人、做過什麼公司的系統）
   ❌ 賣 Notion 課 → 列 10 年 Photoshop 經驗（無關）

🎯 你的答案：
   姓名：___
   經歷（3-5 點）：
     - ___
     - ___
     - ___
   照片 URL（可 skip）：___
```

**對應區塊：** Speaker section。

---

## 階段 C：倒數與 CTA（3-4 題）

### C0. 要不要倒數計時？

```
C0. 要不要放倒數計時器？

💡 有真實截止時間再放（否則會廉價）
   ✅ 早鳥價 5/20 23:59 截止
   ✅ 活動 5/25 開始，剩 XX 天
   ❌ 「限時優惠」但沒真的會調價

🎯 你的答案（y / n）：___
```

### C1.（若 C0=Y）倒數結束日期 + 時間

```
C1. 倒數結束的準確時間（ISO 8601 格式）

💡 格式：YYYY-MM-DDTHH:MM:SS+08:00
   範例：2026-04-30T23:59:00+08:00（2026/4/30 晚上 23:59）

🎯 你的答案：_______________
```

### C2.（若 C0=Y）倒數結束後的行為

```
C2. 時間到 0 時，倒數元件怎麼處理？

💡 選一：
   1. hide ， 整個倒數區塊消失
   2. ended-state ， 變成「本次活動已結束」文字
      （頁面還能看、但 CTA 按鈕變灰）

🎯 你的答案（1 / 2）：___
```

### C3. CTA 按鈕文字 + 連結

```
C3. CTA 按鈕上要寫什麼？連去哪裡？

💡 按鈕文字短、動詞開頭、對齊承諾
   ✅ 「立即報名」「加入購物車」「搶早鳥價」
   ✅ 「開始 30 天練習」「免費試看第一課」
   ❌ 「點擊這裡」「更多資訊」

🎯 按鈕文字：___
🎯 連結 URL：___
```

---

## 收集完後的確認

問完所有題目，整理成 `answers.json` 格式的預覽，讓使用者確認後進 Step 2。

如果使用者在任何題目回 `幫我生 3 個`，AI 根據前面已答的問題生 3 個候選，讓使用者挑一個或修改。

如果使用者說「我全部貼一次」、「熟練模式」，跳過 guardrails 展示，直接收整段文案後一次分類到對應區塊。
CODEX_LAZYPACK_LANDING_PAGE_REFERENCES_QUESTION_BANK_MD

# landing-page/references/uupm-integration.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/landing-page/references/uupm-integration.md")"
cat > "{{CODEX_HOME}}/skills/landing-page/references/uupm-integration.md" <<'CODEX_LAZYPACK_LANDING_PAGE_REFERENCES_UUPM_INTEGRATION_MD'
# UUPM Integration — Codex-compatible optional path

UUPM is optional. The `landing-page` skill must work without it by using `fallback-design-rules.md`.

Do not auto-install UUPM. If the user wants to add UUPM later, route that as a separate tool-integration task and verify the Codex-compatible install path before using it.

## 1. Detection

After the positioning questions, check only non-destructive signals:

```bash
if command -v uipro >/dev/null 2>&1; then
  echo "UUPM_COMMAND_AVAILABLE"
elif [ -d "$HOME/.codex/skills/ui-ux-pro-max" ]; then
  echo "UUPM_CODEX_SKILL_AVAILABLE"
else
  echo "UUPM_NOT_AVAILABLE"
fi
```

If unavailable, continue with fallback mode.

## 2. User Message When Unavailable

Use a concise note, not an installation prompt:

```text
我目前沒有偵測到可直接使用的 UUPM 設計系統工具。這不影響生成頁面；我會先用內建 fallback 設計規則產生 2-3 個風格方向。之後若你想整合 UUPM，可以另外開一個工具整合任務處理。
```

## 3. Building A Query

Use the user's A-stage answers:

```text
query = "<industry keywords> <tone keywords> <product type>"
slug = "<user slug>"
```

If the answer is in Chinese, translate internally into 3-5 English search keywords and show the user the search phrase before using it.

## 4. Calling An Available UUPM Tool

Prefer a documented `uipro` command if present. If the only available integration is a Codex-compatible `ui-ux-pro-max` skill folder, inspect that skill's current instructions before calling any script.

The expected output is a Markdown design-system document. Save or copy the chosen design summary into:

```text
generated-pages/<slug>/design-system.md
```

## 5. Parse Design-System Markdown

Look for these sections:

- Pattern or layout strategy.
- Colors.
- Typography.
- Effects.
- Anti-patterns.
- Pre-delivery checklist.

If parsing fails or the result lacks colors and typography, switch to fallback mode.

## 6. Convert To CSS Variables

Inject the selected design tokens into the generated page:

```css
:root {
  --color-primary: #21A4B1;
  --color-secondary: #A8D5BA;
  --color-cta: #D4AF37;
  --color-bg: #FFF5F5;
  --color-text: #2D3436;
  --font-headline: "Cormorant Garamond", serif;
  --font-body: "Montserrat", sans-serif;
  --transition-base: 250ms cubic-bezier(0.4, 0, 0.2, 1);
  --shadow-soft: 0 4px 12px rgba(0, 0, 0, 0.06);
}
```

Only add external font links when the user accepts external CDN use or when the project already uses those fonts.

## 7. Present Style Options

Offer 2 or 3 style directions. Possible landing-page styles:

| # | Style | Use When |
|:--|:--|:--|
| 1 | Hero-Centric Design | The offer needs strong first-screen impact. |
| 2 | Conversion-Optimized | The page should drive signups or purchases quickly. |
| 3 | Feature-Rich Showcase | The product needs feature explanation. |
| 4 | Minimal & Direct | The audience already understands the offer. |
| 5 | Social Proof-Focused | Testimonials and credibility matter most. |
| 6 | Interactive Product Demo | The product is best understood by seeing it. |
| 7 | Trust & Authority | B2B, professional, or expert positioning. |
| 8 | Storytelling-Driven | A narrative arc sells the transformation. |

For each option, summarize color, type, layout, CTA rhythm, and tradeoff.

## 8. Delivery Checklist

After generating HTML, verify:

- Clickable links and buttons have pointer affordance.
- Hover transitions are 150-300ms where motion is used.
- Text contrast is readable.
- Layout works at 375, 768, 1024, and 1440 px widths when browser verification is available.
- Motion respects `prefers-reduced-motion`.

## 9. Fallback Conditions

Use fallback mode when:

- UUPM is unavailable.
- The user does not want external design tooling.
- UUPM output cannot be parsed.
- Any UUPM script or command fails.
- Browser or shell verification is unavailable.
CODEX_LAZYPACK_LANDING_PAGE_REFERENCES_UUPM_INTEGRATION_MD

# landing-page/templates/base.html
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/landing-page/templates/base.html")"
cat > "{{CODEX_HOME}}/skills/landing-page/templates/base.html" <<'CODEX_LAZYPACK_LANDING_PAGE_TEMPLATES_BASE_HTML'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{{title}}</title>
  <meta name="description" content="{{hero.subtitle}}">

  <!-- Tailwind CDN -->
  <script src="https://cdn.tailwindcss.com"></script>

  <!-- Google Fonts — 由產生時依 design system 決定 -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="{{fonts.googleFontsUrl}}" rel="stylesheet">

  <style>
    :root {
      --color-primary: {{colors.primary}};
      --color-cta: {{colors.cta}};
      --color-text: {{colors.text}};
      --color-bg: {{colors.bg}};
      --color-muted: {{colors.muted}};
      --color-border: {{colors.border}};
      --font-headline: {{fonts.headline}};
      --font-body: {{fonts.body}};
      --transition: 250ms cubic-bezier(0.4, 0, 0.2, 1);
      --shadow-soft: 0 4px 12px rgba(0, 0, 0, 0.06);
      --shadow-hover: 0 8px 24px rgba(0, 0, 0, 0.10);
    }

    html { scroll-behavior: smooth; }
    body {
      font-family: var(--font-body);
      color: var(--color-text);
      background: var(--color-bg);
      line-height: 1.7;
    }

    h1, h2, h3 { font-family: var(--font-headline); font-weight: 700; line-height: 1.25; }
    h1 { font-size: clamp(2rem, 5vw, 3.5rem); }
    h2 { font-size: clamp(1.5rem, 3.5vw, 2.25rem); margin-bottom: 1rem; }
    h3 { font-size: 1.25rem; margin-bottom: 0.75rem; }

    .container-tight { max-width: 672px; margin: 0 auto; padding: 0 1.5rem; }
    .container-wide { max-width: 896px; margin: 0 auto; padding: 0 1.5rem; }
    section { padding: 4rem 0; }
    @media (min-width: 768px) { section { padding: 6rem 0; } }
    #hero { padding: 5rem 0 4rem; }
    @media (min-width: 768px) { #hero { padding: 8rem 0 6rem; } }

    .cta-primary {
      display: inline-block;
      background: var(--color-cta);
      color: #fff;
      padding: 1rem 2rem;
      border-radius: 8px;
      font-weight: 600;
      text-decoration: none;
      cursor: pointer;
      transition: all var(--transition);
      box-shadow: var(--shadow-soft);
    }
    .cta-primary:hover { transform: translateY(-2px); box-shadow: var(--shadow-hover); }
    .cta-primary:focus-visible { outline: 3px solid var(--color-primary); outline-offset: 3px; }

    /* Hero 大型倒數 */
    #countdown-big {
      display: flex;
      gap: 12px;
      justify-content: center;
      margin: 2rem 0;
      font-variant-numeric: tabular-nums;
    }
    #countdown-big .unit {
      background: rgba(0, 0, 0, 0.04);
      border: 1px solid var(--color-border);
      padding: 12px 16px;
      border-radius: 8px;
      min-width: 72px;
      text-align: center;
    }
    #countdown-big .num { font-size: 2rem; font-weight: 700; color: var(--color-primary); }
    #countdown-big .label { font-size: 0.7rem; text-transform: uppercase; letter-spacing: 2px; color: var(--color-muted); }

    /* 底部 sticky */
    #countdown-sticky {
      position: fixed;
      bottom: 0;
      left: 0;
      right: 0;
      background: var(--color-text);
      color: #fff;
      padding: 0.75rem 1.5rem;
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 1rem;
      z-index: 50;
      transform: translateY(100%);
      transition: transform var(--transition);
      box-shadow: 0 -4px 20px rgba(0, 0, 0, 0.15);
    }
    #countdown-sticky.visible { transform: translateY(0); }
    #countdown-sticky .cta-compact {
      background: var(--color-cta);
      color: #fff;
      padding: 0.5rem 1.25rem;
      border-radius: 6px;
      font-weight: 600;
      text-decoration: none;
      white-space: nowrap;
      cursor: pointer;
      transition: opacity var(--transition);
    }
    #countdown-sticky .cta-compact:hover { opacity: 0.9; }
    @media (max-width: 640px) {
      #countdown-sticky { padding: 0.5rem 1rem; font-size: 0.85rem; }
      #countdown-sticky .cta-compact { padding: 0.4rem 0.9rem; font-size: 0.85rem; }
    }

    /* 其他 section */
    #hook p, #about p { font-size: 1.1rem; margin-bottom: 1rem; }
    .info-item { display: flex; gap: 0.75rem; padding: 0.75rem 0; border-bottom: 1px solid var(--color-border); }
    .info-item:last-child { border-bottom: none; }
    .info-label { font-weight: 600; min-width: 140px; }

    .pricing-card {
      background: #fff;
      border: 1px solid var(--color-border);
      border-radius: 12px;
      padding: 2rem;
      box-shadow: var(--shadow-soft);
      transition: all var(--transition);
    }
    .pricing-card.highlighted {
      border: 2px solid var(--color-cta);
      transform: scale(1.02);
    }
    .pricing-price { font-size: 2rem; font-weight: 700; color: var(--color-primary); }

    .testimonial {
      background: #fff;
      border-radius: 12px;
      padding: 1.5rem;
      box-shadow: var(--shadow-soft);
    }
    .testimonial .quote { font-style: italic; margin-bottom: 1rem; }
    .testimonial .author { font-size: 0.9rem; color: var(--color-muted); }

    .faq-item {
      border-bottom: 1px solid var(--color-border);
      padding: 1rem 0;
    }
    .faq-item summary {
      cursor: pointer;
      font-weight: 600;
      padding: 0.5rem 0;
      list-style: none;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .faq-item summary::after {
      content: "+";
      font-size: 1.5rem;
      transition: transform var(--transition);
    }
    .faq-item[open] summary::after { transform: rotate(45deg); }
    .faq-item p { padding: 0.75rem 0; color: var(--color-muted); }

    .speaker-card { display: flex; gap: 1.5rem; align-items: flex-start; }
    .speaker-photo {
      width: 120px; height: 120px;
      border-radius: 50%;
      object-fit: cover;
      flex-shrink: 0;
    }
    @media (max-width: 640px) {
      .speaker-card { flex-direction: column; align-items: center; text-align: center; }
    }

    @media (prefers-reduced-motion: reduce) {
      * { transition: none !important; animation: none !important; }
    }
  </style>
</head>
<body>

  <!-- ===== Nav（必要、sticky top） -->
  <nav class="site-nav" id="siteNav">
    <div class="nav-inner">
      <a class="nav-brand" href="#top">{{nav.brandText}}</a>
      <ul class="nav-links">
        <li><a href="#about">{{nav.linkAbout}}</a></li>
        <li><a href="#learn">{{nav.linkLearn}}</a></li>
        <li><a href="#audience">{{nav.linkAudience}}</a></li>
        <li><a href="#pricing">{{nav.linkPricing}}</a></li>
        <li><a href="#speaker">{{nav.linkSpeaker}}</a></li>
        <li><a href="#faq">{{nav.linkFaq}}</a></li>
      </ul>
      <a class="nav-cta" href="{{cta.href}}">{{nav.ctaShort}}</a>
    </div>
  </nav>

  <a id="top"></a>

  <!-- 1. Hero（必要） -->
  <section id="hero">
    <div class="container-tight text-center">
      <h1>{{hero.title}}</h1>
      <p class="text-xl text-gray-600" style="color: var(--color-muted);">{{hero.subtitle}}</p>

      <!-- {{COUNTDOWN_BIG_START}} 只在 countdown.enabled 時保留 -->
      <div id="countdown-big" data-deadline="{{countdown.deadline}}" data-onzero="{{countdown.onZero}}">
        <div class="unit"><div class="num" data-unit="days">00</div><div class="label">天</div></div>
        <div class="unit"><div class="num" data-unit="hours">00</div><div class="label">時</div></div>
        <div class="unit"><div class="num" data-unit="mins">00</div><div class="label">分</div></div>
        <div class="unit"><div class="num" data-unit="secs">00</div><div class="label">秒</div></div>
      </div>
      <!-- {{COUNTDOWN_BIG_END}} -->

      <a class="cta-primary" href="{{cta.href}}">{{cta.text}}</a>
    </div>
  </section>

  <!-- 2. Hook（必要） -->
  <section id="hook">
    <div class="container-tight">
      <h2>{{hook.heading}}</h2>
      {{hook.paragraphs}}
    </div>
  </section>

  <!-- 3. About（必要） -->
  <section id="about">
    <div class="container-tight">
      <h2>{{about.heading}}</h2>
      {{about.paragraphs}}
    </div>
  </section>

  <!-- 4. What you'll learn（必要） -->
  <section id="learn">
    <div class="container-tight">
      <h2>{{learn.heading}}</h2>
      <ul class="space-y-3 text-lg">
        {{learn.items}}
      </ul>
    </div>
  </section>

  <!-- {{TESTIMONIALS_START}} 只在 testimonials 有內容時保留 -->
  <!-- 5. Testimonials（可選） -->
  <section id="testimonials">
    <div class="container-wide">
      <h2 class="text-center">{{testimonials.heading}}</h2>
      <div class="grid md:grid-cols-2 gap-6 mt-8">
        {{testimonials.items}}
      </div>
    </div>
  </section>
  <!-- {{TESTIMONIALS_END}} -->

  <!-- 6. Audience（必要） -->
  <section id="audience">
    <div class="container-tight">
      <h2>{{audience.heading}}</h2>
      <div class="grid md:grid-cols-2 gap-6 mt-6">
        <div>
          <h3>✓ 適合你，如果…</h3>
          <ul class="space-y-2">{{audience.fit}}</ul>
        </div>
        <div>
          <h3>✗ 不適合你，如果…</h3>
          <ul class="space-y-2" style="color: var(--color-muted);">{{audience.unfit}}</ul>
        </div>
      </div>
    </div>
  </section>

  <!-- 7. Info（必要） -->
  <section id="info">
    <div class="container-tight">
      <h2>{{info.heading}}</h2>
      <div class="mt-6">
        {{info.items}}
      </div>
    </div>
  </section>

  <!-- 8. Pricing（必要） -->
  <section id="pricing">
    <div class="container-wide">
      <h2 class="text-center">{{pricing.heading}}</h2>
      <div class="grid md:grid-cols-{{pricing.columnCount}} gap-6 mt-8">
        {{pricing.cards}}
      </div>
    </div>
  </section>

  <!-- 9. Final CTA（必要） -->
  <section id="cta-final">
    <div class="container-tight text-center">
      <h2>{{finalCta.heading}}</h2>
      <p class="text-lg mb-6" style="color: var(--color-muted);">{{finalCta.body}}</p>
      <a class="cta-primary" href="{{cta.href}}">{{cta.text}}</a>
    </div>
  </section>

  <!-- 10. Speaker（必要） -->
  <section id="speaker">
    <div class="container-tight">
      <h2>{{speaker.heading}}</h2>
      <div class="speaker-card mt-6">
        {{#if speaker.photo}}
          <img src="{{speaker.photo}}" alt="{{speaker.name}}" class="speaker-photo">
        {{/if}}
        <div>
          <h3>{{speaker.name}}</h3>
          <ul class="space-y-1">{{speaker.bioItems}}</ul>
        </div>
      </div>
    </div>
  </section>

  <!-- 11. FAQ（必要） -->
  <section id="faq">
    <div class="container-tight">
      <h2>{{faq.heading}}</h2>
      <div class="mt-6">
        {{faq.items}}
      </div>
    </div>
  </section>

  <!-- {{COUNTDOWN_STICKY_START}} 只在 countdown.enabled 時保留 -->
  <div id="countdown-sticky" data-deadline="{{countdown.deadline}}" data-onzero="{{countdown.onZero}}">
    <span>倒數 <strong class="time"></strong></span>
    <a class="cta-compact" href="{{cta.href}}">{{cta.text}} →</a>
  </div>
  <!-- {{COUNTDOWN_STICKY_END}} -->

  <!-- {{COUNTDOWN_JS_START}} 只在 countdown.enabled 時保留 -->
  <script>/* countdown.js 內容注入這裡 */</script>
  <!-- {{COUNTDOWN_JS_END}} -->

</body>
</html>
CODEX_LAZYPACK_LANDING_PAGE_TEMPLATES_BASE_HTML

# landing-page/templates/countdown.js
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/landing-page/templates/countdown.js")"
cat > "{{CODEX_HOME}}/skills/landing-page/templates/countdown.js" <<'CODEX_LAZYPACK_LANDING_PAGE_TEMPLATES_COUNTDOWN_JS'
(function () {
  'use strict';

  var bigEl = document.getElementById('countdown-big');
  var stickyEl = document.getElementById('countdown-sticky');
  var heroEl = document.getElementById('hero');

  if (!bigEl && !stickyEl) return;

  var deadlineStr = (bigEl || stickyEl).getAttribute('data-deadline');
  var onZero = (bigEl || stickyEl).getAttribute('data-onzero') || 'ended-state';
  var deadline = new Date(deadlineStr).getTime();

  if (isNaN(deadline)) {
    console.warn('[countdown] invalid deadline:', deadlineStr);
    return;
  }

  function pad(n) {
    return String(n).padStart(2, '0');
  }

  function tick() {
    var now = Date.now();
    var diff = deadline - now;

    if (diff <= 0) {
      handleZero();
      return false;
    }

    var days = Math.floor(diff / 86400000);
    var hours = Math.floor((diff % 86400000) / 3600000);
    var mins = Math.floor((diff % 3600000) / 60000);
    var secs = Math.floor((diff % 60000) / 1000);

    if (bigEl) {
      var units = { days: days, hours: hours, mins: mins, secs: secs };
      bigEl.querySelectorAll('[data-unit]').forEach(function (el) {
        el.textContent = pad(units[el.dataset.unit] || 0);
      });
    }

    if (stickyEl) {
      var timeEl = stickyEl.querySelector('.time');
      if (timeEl) {
        timeEl.textContent = days + '天 ' + pad(hours) + ':' + pad(mins) + ':' + pad(secs);
      }
    }

    return true;
  }

  function handleZero() {
    if (onZero === 'hide') {
      if (bigEl) bigEl.remove();
      if (stickyEl) stickyEl.remove();
    } else {
      var msg = '<div style="text-align:center;opacity:0.6;padding:1rem;">本次活動已結束</div>';
      if (bigEl) bigEl.innerHTML = msg;
      if (stickyEl) {
        stickyEl.innerHTML = '<span style="width:100%;text-align:center;">本次活動已結束</span>';
        stickyEl.classList.add('visible');
      }
    }
  }

  // 滾動偵測：滾過 Hero 才顯示 sticky
  if (heroEl && stickyEl) {
    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        stickyEl.classList.toggle('visible', !entry.isIntersecting);
      });
    }, { threshold: 0 });
    observer.observe(heroEl);
  }

  // 啟動
  if (tick()) {
    var interval = setInterval(function () {
      if (!tick()) clearInterval(interval);
    }, 1000);
  }
})();
CODEX_LAZYPACK_LANDING_PAGE_TEMPLATES_COUNTDOWN_JS

test -f "{{CODEX_HOME}}/skills/landing-page/SKILL.md" && echo "landing-page installed"

echo "embedded skills installed: landing-page"
```

<!-- END EMBEDDED_SKILLS -->
