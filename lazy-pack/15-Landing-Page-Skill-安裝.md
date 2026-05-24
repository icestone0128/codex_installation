# 15-Landing-Page-Skill-安裝

> 版本：2026-05-24 Codex App 版
> 用途：把引導式 Landing Page 生成流程安裝成 Codex App 全域 Skill，用來產生課程頁、銷售頁、活動報名頁、產品頁或名單收集頁。
> 成品：下載者可把本懶人包內的 `lazy-pack/skills/landing-page/` 複製到自己的 `{{CODEX_HOME}}/skills/landing-page/`，再用自然語句觸發。

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
rsync -a --delete "{{SETUP_REPO}}/lazy-pack/skills/landing-page/" "{{CODEX_HOME}}/skills/landing-page/"
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
