# 14-Social-Cards-圖卡-Skill-安裝

> 2026-05-24 更新：本文件已改為自含式 Skill 安裝文件。請使用文末「內建 Skill 完整安裝內容」，不需要額外的舊版獨立 skills 子目錄。


> 版本：2026-05-25 Codex App 版
> 用途：把 Raymond Hou / 雷蒙的 `skills/social-cards` 來源工具 安裝劇本，轉成可直接安裝到 Codex App 的全域 Skill。
> 成品：下載者可直接使用本文文末「內建 Skill 完整安裝內容」建立 `{{CODEX_HOME}}/skills/social-cards/`，再安裝 Playwright 依賴後使用。

## 來源與授權

- 原始來源頁：`https://cc.lifehacker.tw`
- 原始 repo：`https://github.com/lifehacker-tw/claude-code-mini-course.git`
- 原始 skill folder：`skills/social-cards/`
- 原作者：Raymond Hou / 雷蒙
- 原始授權：CC BY-NC-SA 4.0，個人使用、學習、分享自由，禁止商業用途。

本文件只做 Codex App 相容改寫。若要商業使用，請先確認原始授權與作者授權。

## 這版和原始 來源工具 文件的差異

| 原始文件 | Codex 版 |
|---|---|
| 安裝到 來源工具的全域 skills 路徑 | 安裝到 `{{CODEX_HOME}}/skills/social-cards` |
| 安裝到 `000_Agent/skills` | 只在它是單一專案或個人助手本地卡片流程時使用，不作為全域安裝 |
| skill 名稱為 `cards` | skill id 為 `social-cards`，顯示名稱為 Social Cards |
| `/cards` 是 slash command | `/cards` 只是觸發語；Codex 依 `SKILL.md` metadata 觸發 |
| `blue-dark` / `orange-light` | 已同步保留為上游模板 |
| Pantone 285C 本機品牌版 | 保留 `brand-dark` / `brand-light` 作為相容模板 |
| 原始 sample handle 是 `@raymond0917` | 依模板來源保留或在生成時要求使用者確認 handle |

## 安裝方式 A：直接使用懶人包內的 skill

這是最穩的方式。下載本懶人包後，讓 Codex 在你的設定專案根目錄執行：

```bash
mkdir -p "{{CODEX_HOME}}/skills/social-cards"
# 請使用本文文末「內建 Skill 完整安裝內容」；不需要額外複製舊版獨立 skills 子目錄。
cd "{{CODEX_HOME}}/skills/social-cards"
NPM_CONFIG_CACHE=/private/tmp/npm-cache npm install
NPM_CONFIG_CACHE=/private/tmp/npm-cache PLAYWRIGHT_BROWSERS_PATH=0 npx playwright install chromium
```

若你不是 macOS，也可以先拿掉 `NPM_CONFIG_CACHE=/private/tmp/npm-cache`，只有遇到 npm cache 權限錯誤時再加回來。

## 安裝方式 B：從原始 repo 重新抓取後轉換

只有在你想重新取得上游版本時才用這個方式。

```bash
TMPDIR_CARDS=$(mktemp -d)
git -C "$TMPDIR_CARDS" init -q
git -C "$TMPDIR_CARDS" remote add origin https://github.com/lifehacker-tw/claude-code-mini-course.git
git -C "$TMPDIR_CARDS" config core.sparseCheckout true
printf "skills/social-cards/\n" > "$TMPDIR_CARDS/.git/info/sparse-checkout"
git -C "$TMPDIR_CARDS" pull --depth 1 origin master
```

接著不要直接照原始 `SKILL.md` 安裝。要做 Codex 轉換：

1. 安裝路徑改成 `{{CODEX_HOME}}/skills/social-cards`。
2. `SKILL.md` frontmatter 只保留 Codex 可用欄位：`name`、`description`、`metadata.short-description`。
3. 移除 來源工具專用欄位與 slash command 假設。
4. 若要沿用本懶人包品牌版，把模板資料夾改為 `brand-dark` / `brand-light`，並把主色改成 `#0072CE`。
5. 把原始 sample handle 改成 `@yourhandle`。
6. 安裝 Playwright 與 Chromium。

## 驗證

```bash
test -f "{{CODEX_HOME}}/skills/social-cards/SKILL.md" && echo "SKILL.md ok"
test -d "{{CODEX_HOME}}/skills/social-cards/assets/blue-dark" && echo "blue-dark ok"
test -d "{{CODEX_HOME}}/skills/social-cards/assets/orange-light" && echo "orange-light ok"
test -d "{{CODEX_HOME}}/skills/social-cards/assets/brand-dark" && echo "brand-dark ok"
test -d "{{CODEX_HOME}}/skills/social-cards/assets/brand-light" && echo "brand-light ok"
test -f "{{CODEX_HOME}}/skills/social-cards/scripts/screenshot.mjs" && echo "screenshot script ok"
test -d "{{CODEX_HOME}}/skills/social-cards/node_modules/playwright" && echo "Playwright ok"
```

再做一次實際匯出測試：

```bash
mkdir -p /tmp/social-cards-test
cp "{{CODEX_HOME}}/skills/social-cards/assets/orange-light/cover.html" /tmp/social-cards-test/01-cover.html
cp "{{CODEX_HOME}}/skills/social-cards/assets/blue-dark/content-text.html" /tmp/social-cards-test/02-content.html
cd "{{CODEX_HOME}}/skills/social-cards"
PLAYWRIGHT_BROWSERS_PATH=0 node scripts/screenshot.mjs /tmp/social-cards-test
find /tmp/social-cards-test -maxdepth 1 -name "*.png" -print
```

應該看到兩張 PNG。

## 使用方式

安裝後開新 Codex 對話或重啟 Codex App，然後用下列任一方式觸發：

- 「Social Cards」
- 「做圖卡」
- 「幫我做 IG 圖」
- 「把這篇做成圖卡」
- 「使用手寫混搭數位風格，把這篇做成圖卡」
- `/cards` 加上一段文字、網址或 Markdown 檔案路徑

Codex 會依 Skill 流程：收集內容、確認尺寸、確認 handle、拆卡、產生預覽、等待修改、確認後匯出 PNG。

## 踩坑紀錄

### 1. 不要把來源工具路徑照搬到 Codex

原始文件會偵測 `000_Agent/skills` 和 來源工具的 skills 路徑。Codex App 的全域 skill 位置是：

```text
{{CODEX_HOME}}/skills
```

通常是：

```text
/Users/<你的使用者名稱>/.codex/skills
```

如果這套卡片流程只服務某一個專案或個人助手資料層，不需要全域觸發，才放在該專案或助手的 `000_Agent/skills/social-cards`。不要把 `000_Agent/skills` symlink 到 `{{CODEX_HOME}}/skills`。

### 2. `cards` 和 Social Cards 的命名要分清楚

Codex skill id 建議用無空格資料夾名稱，所以本版使用：

```text
social-cards
```

對外顯示名稱寫在標題與 short-description：

```text
Social Cards
```

### 3. `/cards` 不是 Codex slash command

在 Codex 裡，`/cards` 只能當作使用者可能輸入的觸發文字。不要期待它出現在 來源工具 的 `/` 選單。

### 4. npm cache 可能遇到權限錯誤

若 `npm install` 出現 `.npm/_cacache` 權限問題，不要先改全域 npm 權限。先用暫存 cache：

```bash
NPM_CONFIG_CACHE=/private/tmp/npm-cache npm install
```

### 5. Playwright 瀏覽器最好安裝在 skill 本地

使用：

```bash
PLAYWRIGHT_BROWSERS_PATH=0 npx playwright install chromium
```

這會讓 Chromium 跟著 skill 的 `node_modules` 放在一起，比較可移植。

### 6. node_modules 內可能帶有上游範例 `SKILL.md`

Playwright 依賴內曾出現上游工具範例 `SKILL.md`，可能含有非 Codex 欄位。安裝後可檢查：

```bash
find "{{CODEX_HOME}}/skills/social-cards" -path "*/SKILL.md" -print
```

合理結果應只看到：

```text
{{CODEX_HOME}}/skills/social-cards/SKILL.md
```

若看到 `node_modules` 裡還有其他 `SKILL.md`，可以刪除那些上游範例檔，不影響 Playwright 執行。

### 7. 修改全域 skill 後要重啟或開新對話

Codex App 不一定會在同一個對話立刻載入新的 skill metadata。安裝或改名後，開新對話或重啟 Codex App 再測試。

## 最終檢查清單

- [ ] `{{CODEX_HOME}}/skills/social-cards/SKILL.md` 存在。
- [ ] `SKILL.md` 的 `name` 是 `social-cards`。
- [ ] `metadata.short-description` 是 `Social Cards`。
- [ ] `assets/blue-dark/` 有 4 個 HTML 模板。
- [ ] `assets/orange-light/` 有 4 個 HTML 模板。
- [ ] `assets/brand-dark/` 有 4 個 HTML 模板，作為 Pantone 285C 相容模板。
- [ ] `assets/brand-light/` 有 4 個 HTML 模板，作為 Pantone 285C 相容模板。
- [ ] `scripts/screenshot.mjs` 存在。
- [ ] `node_modules/playwright` 存在。
- [ ] 實測匯出 PNG 成功。
- [ ] 開新 Codex 對話後，用「Social Cards」或「做圖卡」可觸發。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊。這個序號項目會安裝：`social-cards`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾。

````bash
set -e

# ---- social-cards ----
mkdir -p "{{CODEX_HOME}}/skills/social-cards"
# social-cards/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/social-cards/SKILL.md" <<'CODEX_LAZYPACK_SOCIAL_CARDS_SKILL_MD'
---
name: social-cards
description: Use when the user asks to use Social Cards, make IG cards, social cards, carousel posts, "/cards", "做圖卡", "幫我做 IG 圖", or turn an article, note, URL, Markdown file, or pasted text into branded social-media PNG cards using bundled blue-dark, orange-light, or Pantone 285C brand templates.
metadata:
  short-description: Social Cards
---

# Social Cards

把文章、筆記、網址或貼上的文字轉成品牌一致的社群圖卡。預設使用上游 `orange-light` / `blue-dark` 兩套模板；本機仍保留 Pantone 285C 版 `brand-light` / `brand-dark` 作為相容模板。

## Trigger Phrases

- 「做圖卡」
- 「/cards」
- 「Social Cards」
- 「幫我做 IG 圖」
- 「社群圖卡」
- 「把這篇做成圖卡」
- 「手寫混搭數位風格」
- 使用者提供文章、Markdown、網址或段落，並要求轉成 IG / Threads / X 可用圖卡

## Assets

模板 HTML 在本 skill 的 `assets/` 子資料夾：

- `assets/blue-dark/cover.html`
- `assets/blue-dark/content-text.html`
- `assets/blue-dark/content-image.html`
- `assets/blue-dark/cta.html`
- `assets/orange-light/cover.html`
- `assets/orange-light/content-text.html`
- `assets/orange-light/content-image.html`
- `assets/orange-light/cta.html`

相容模板：

- `assets/brand-dark/cover.html`
- `assets/brand-dark/content-text.html`
- `assets/brand-dark/content-image.html`
- `assets/brand-dark/cta.html`
- `assets/brand-light/cover.html`
- `assets/brand-light/content-text.html`
- `assets/brand-light/content-image.html`
- `assets/brand-light/cta.html`

截圖腳本：`scripts/screenshot.mjs`

來源與授權摘要：`references/source-adaptation.md`

上游 README 快照：`references/upstream-readme.md`

## Optional Style Presets

### 手寫混搭數位風格

Only apply this preset when the user explicitly says `手寫混搭數位風格`. Do not make it the default for ordinary Social Cards requests.

- 主標題使用精確、清楚、偏粗黑體的中文，優先確保可讀性與資訊層級。
- 在主標題旁邊或下方加入短英文手寫感裝飾語，例如 1-4 個單字的 mood phrase；它是氛圍元素，不承載主要資訊。
- 手寫英文可以稍微傾斜、錯位或不規則排列，但不得干擾中文標題、內文、頁碼或 CTA。
- 背景維持簡潔，可用深色或淺色；讓「工整黑體中文 x 手寫英文」成為視覺焦點。
- 版面可以有數位感的留白、細線、框線、格線或輕微 UI 感元素，但避免過度裝飾。
- 若使用者沒有指定英文短語，依內容產生簡短氛圍詞，例如 `learn better`, `make it clear`, `tiny steps`, `focus mode`。

## Workflow

1. 收集內容來源：貼文、網址、Markdown 檔案路徑或使用者直接貼上的文字。
2. 若來源是網址，優先使用可用的網頁讀取工具擷取主要內容；若來源是本機檔案，先讀檔再整理。
3. 詢問或合理推定輸出比例：預設 `4:5`（1080 x 1350）；若使用者要求正方形，改為 `1:1`（1080 x 1080）。
4. 詢問風格：預設 `orange-light`，也可選 `blue-dark`；若使用者指定 Pantone 285C 品牌版，使用 `brand-light` 或 `brand-dark`；若使用者明確說 `手寫混搭數位風格`，才套用該 optional style preset。
5. 確認社群 handle。若當前輸出根目錄已有 `output/.handle`，可讀取後向使用者確認；沒有就詢問一次。
6. 拆卡並先展示規劃，等使用者確認後才產生預覽：
   - 第 1 張：`cover`
   - 中間：`content-text` 或 `content-image`
   - 最後：`cta`
7. 產生輸出資料夾：`output/YYYY-MM-DD-{topic-slug}/`。
8. 讀取對應模板，替換標題、內文、條列、handle、頁碼與圖片路徑。圖片一律用絕對路徑，並維持等比顯示。
9. 建立 `preview.html` 總覽頁並打開預覽。預覽階段只產生 HTML，不產生 PNG。
10. 依使用者回饋修改單張或整組圖卡。
11. 使用者明確確認「匯出」後，執行 `node {SKILL_DIR}/scripts/screenshot.mjs output/YYYY-MM-DD-{topic-slug}/` 匯出 2x PNG。
12. 完成後回報 PNG 資料夾位置與檔名。

## Card Planning Rules

- 標題最多 10 個中文字左右；超過時拆行或拆卡。
- 每張只放一個主張或重點。
- 內文最多 3-4 行。
- 條列最多 4 個，每項不超過 25 字。
- 使用 `手寫混搭數位風格` 時，手寫英文只作為裝飾層，不能取代中文主標題或降低資訊可讀性。
- 提到流程、介面、設定檔、程式碼、前後對照或使用者提供圖片時，優先使用 `content-image`。
- 寧可多拆卡，不要把單張塞滿。

## Codex Notes

- 不依賴 Claude Code slash-command 系統；`/cards` 只是使用者可能輸入的觸發語。
- 不使用 Claude 專用 frontmatter 或工具欄位。
- 若 Playwright、Chromium 或 `node_modules/` 尚未安裝，先告知需要安裝本 skill 的截圖依賴，再於本 skill 資料夾執行 `npm install` 並驗證。
- 複製給其他使用者或其他電腦時，不必複製 `node_modules/`；保留 `package.json` 與 `package-lock.json`，在新環境重新安裝依賴。
- 匯出後可刪除中間 HTML，保留 PNG；除非使用者要求保留可編輯 HTML。
CODEX_LAZYPACK_SOCIAL_CARDS_SKILL_MD

# social-cards/assets/blue-dark/content-image.html
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/assets/blue-dark/content-image.html")"
cat > "{{CODEX_HOME}}/skills/social-cards/assets/blue-dark/content-image.html" <<'CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BLUE_DARK_CONTENT_IMAGE_HTML'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=1080">
<title>Content Image — Blue Dark</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Noto+Sans+TC:wght@400;500;700;900&display=swap" rel="stylesheet">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  .card {
    width: 1080px;
    height: 1350px;
    background:
      radial-gradient(ellipse 900px 900px at 100% 0%, #0A2A35 0%, transparent 70%),
      radial-gradient(circle 1200px at -10% 105%, #4AB897 0%, rgba(74,184,151,0.5) 25%, rgba(74,184,151,0.15) 50%, transparent 75%),
      #01101A;
    position: relative;
    overflow: hidden;
    font-family: 'Inter', 'Noto Sans TC', sans-serif;
    padding: 80px 90px;
    display: flex;
    flex-direction: column;
  }
  .title {
    font-weight: 900;
    font-size: 72px;
    color: #fff;
    line-height: 1.3;
    margin-bottom: 28px;
    text-shadow: 0 2px 8px rgba(0,0,0,0.3);
  }
  .description {
    font-weight: 500;
    font-size: 44px;
    color: rgba(255,255,255,0.65);
    line-height: 1.6;
    margin-bottom: 48px;
  }
  .image-area {
    flex: 1;
    background: #D9D9D9;
    border-radius: 20px;
    overflow: hidden;
    box-shadow: 0 12px 40px rgba(0,0,0,0.3);
  }
  .image-area img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
  .handle {
    position: absolute;
    bottom: 72px;
    left: 90px;
    font-family: 'Inter', sans-serif;
    font-size: 33px;
    font-weight: 600;
    color: rgba(255,255,255,0.3);
  }
</style>
</head>
<body>
<div class="card">
  <h2 class="title">標題標題標題標題標題</h2>
  <p class="description">內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文</p>
  <div class="image-area">
    <!-- 替換為 <img src="your-screenshot.png"> -->
  </div>
  <span class="handle">@raymond0917</span>
</div>
</body>
</html>
CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BLUE_DARK_CONTENT_IMAGE_HTML

# social-cards/assets/blue-dark/content-text.html
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/assets/blue-dark/content-text.html")"
cat > "{{CODEX_HOME}}/skills/social-cards/assets/blue-dark/content-text.html" <<'CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BLUE_DARK_CONTENT_TEXT_HTML'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=1080">
<title>Content Text — Blue Dark</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Noto+Sans+TC:wght@400;500;700;900&display=swap" rel="stylesheet">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  .card {
    width: 1080px;
    height: 1350px;
    background:
      radial-gradient(ellipse 900px 900px at 100% 0%, #0A2A35 0%, transparent 70%),
      radial-gradient(circle 1200px at -10% 105%, #4AB897 0%, rgba(74,184,151,0.5) 25%, rgba(74,184,151,0.15) 50%, transparent 75%),
      #01101A;
    position: relative;
    overflow: hidden;
    font-family: 'Inter', 'Noto Sans TC', sans-serif;
    padding: 100px 90px;
    display: flex;
    flex-direction: column;
  }
  .title {
    font-weight: 900;
    font-size: 72px;
    color: #fff;
    line-height: 1.4;
    margin-bottom: 56px;
  }
  .bullet-list {
    list-style: none;
    padding: 0;
    display: flex;
    flex-direction: column;
    gap: 36px;
    flex: 1;
  }
  .bullet-item {
    display: flex;
    gap: 36px;
    align-items: flex-start;
  }
  .bullet-dot {
    flex-shrink: 0;
    width: 22px;
    height: 22px;
    background: #fff;
    border-radius: 50%;
    margin-top: 30px;
  }
  .bullet-text {
    font-size: 44px;
    font-weight: 500;
    color: rgba(255,255,255,0.8);
    line-height: 1.6;
  }
  .handle {
    position: absolute;
    bottom: 72px;
    left: 90px;
    font-family: 'Inter', sans-serif;
    font-size: 33px;
    font-weight: 600;
    color: rgba(255,255,255,0.3);
  }
</style>
</head>
<body>
<div class="card">
  <h2 class="title">標題標題<br>標題標題標題標題？</h2>

  <div class="bullet-list">
    <div class="bullet-item">
      <div class="bullet-dot"></div>
      <p class="bullet-text">內文內文內文內文內文內文內文內文內文內文內文</p>
    </div>
    <div class="bullet-item">
      <div class="bullet-dot"></div>
      <p class="bullet-text">內文內文內文內文內文內文內文內文內文內文內文內文內文</p>
    </div>
    <div class="bullet-item">
      <div class="bullet-dot"></div>
      <p class="bullet-text">內文內文內文內文內文內文內文內文內文內文內文</p>
    </div>
    <div class="bullet-item">
      <div class="bullet-dot"></div>
      <p class="bullet-text">內文內文內文內文內文內文內文內文內文內文內文內文內文</p>
    </div>
  </div>

  <span class="handle">@raymond0917</span>
</div>
</body>
</html>
CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BLUE_DARK_CONTENT_TEXT_HTML

# social-cards/assets/blue-dark/cover.html
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/assets/blue-dark/cover.html")"
cat > "{{CODEX_HOME}}/skills/social-cards/assets/blue-dark/cover.html" <<'CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BLUE_DARK_COVER_HTML'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=1080">
<title>Cover — Blue Dark</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Noto+Sans+TC:wght@400;500;700;900&display=swap" rel="stylesheet">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  .card {
    width: 1080px;
    height: 1350px;
    background:
      radial-gradient(ellipse 900px 900px at 100% 0%, #0A2A35 0%, transparent 70%),
      radial-gradient(circle 1200px at -10% 105%, #4AB897 0%, rgba(74,184,151,0.5) 25%, rgba(74,184,151,0.15) 50%, transparent 75%),
      #01101A;
    position: relative;
    overflow: hidden;
    font-family: 'Inter', 'Noto Sans TC', sans-serif;
  }
  .content {
    position: absolute;
    bottom: 200px;
    left: 90px;
    right: 90px;
  }
  .title {
    font-weight: 900;
    font-size: 88px;
    color: #fff;
    line-height: 1.3;
    margin-bottom: 32px;
  }
  .subtitle {
    font-weight: 500;
    font-size: 44px;
    color: #6DE3EA;
    line-height: 1.5;
  }
  .handle {
    position: absolute;
    bottom: 72px;
    left: 90px;
    font-family: 'Inter', sans-serif;
    font-size: 33px;
    font-weight: 600;
    color: rgba(255,255,255,0.3);
  }
</style>
</head>
<body>
<div class="card">
  <div class="content">
    <h1 class="title">標題標題<br>標題標題標題標題</h1>
    <p class="subtitle">副標題副標題副標題</p>
  </div>
  <span class="handle">@raymond0917</span>
</div>
</body>
</html>
CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BLUE_DARK_COVER_HTML

# social-cards/assets/blue-dark/cta.html
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/assets/blue-dark/cta.html")"
cat > "{{CODEX_HOME}}/skills/social-cards/assets/blue-dark/cta.html" <<'CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BLUE_DARK_CTA_HTML'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=1080">
<title>CTA — Blue Dark</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Noto+Sans+TC:wght@400;500;700;900&display=swap" rel="stylesheet">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  .card {
    width: 1080px;
    height: 1350px;
    background:
      radial-gradient(ellipse 900px 900px at 100% 0%, #0A2A35 0%, transparent 70%),
      radial-gradient(circle 1200px at -10% 105%, #4AB897 0%, rgba(74,184,151,0.5) 25%, rgba(74,184,151,0.15) 50%, transparent 75%),
      #01101A;
    position: relative;
    overflow: hidden;
    font-family: 'Inter', 'Noto Sans TC', sans-serif;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }
  .title {
    font-weight: 900;
    font-size: 88px;
    color: #fff;
    text-align: center;
    line-height: 1.35;
    margin-bottom: 44px;
  }
  .subtitle {
    font-weight: 500;
    font-size: 40px;
    color: rgba(255,255,255,0.5);
    text-align: center;
    line-height: 1.6;
    margin-bottom: 52px;
  }
  .handle-badge {
    display: inline-block;
    background: rgba(255,255,255,0.12);
    border: 1px solid rgba(255,255,255,0.2);
    color: #fff;
    font-family: 'Inter', sans-serif;
    font-size: 40px;
    font-weight: 700;
    padding: 20px 48px;
    border-radius: 60px;
  }
  /* 底部互動提示 */
  .bottom-actions {
    position: absolute;
    bottom: 64px;
    left: 90px;
    right: 90px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .action {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 12px;
    color: #fff;
  }
  .action-icon {
    width: 44px;
    height: 44px;
  }
  .action-icon svg {
    width: 44px;
    height: 44px;
    fill: none;
    stroke: #fff;
    stroke-width: 2;
  }
  .action-text {
    font-size: 26px;
    font-weight: 500;
  }
</style>
</head>
<body>
<div class="card">
  <h2 class="title">有幫助的話<br>記得按讚分享</h2>
  <p class="subtitle">更多教學與實戰分享<br>追蹤我的帳號，不錯過最新內容</p>
  <span class="handle-badge">@raymond0917</span>

  <div class="bottom-actions">
    <div class="action">
      <span class="action-icon"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg></span>
      <span class="action-text">喜歡點愛心</span>
    </div>
    <div class="action">
      <span class="action-icon"><svg viewBox="0 0 24 24"><path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"/></svg></span>
      <span class="action-text">實用請收藏</span>
    </div>
  </div>
</div>
</body>
</html>
CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BLUE_DARK_CTA_HTML

# social-cards/assets/brand-dark/content-image.html
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/assets/brand-dark/content-image.html")"
cat > "{{CODEX_HOME}}/skills/social-cards/assets/brand-dark/content-image.html" <<'CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BRAND_DARK_CONTENT_IMAGE_HTML'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=1080">
<title>Content Image — Brand Dark</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Noto+Sans+TC:wght@400;500;700;900&display=swap" rel="stylesheet">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  .card {
    width: 1080px;
    height: 1350px;
    background:
      radial-gradient(ellipse 900px 900px at 100% 0%, #003A70 0%, transparent 70%),
      radial-gradient(circle 1200px at -10% 105%, #0072CE 0%, rgba(0,114,206,0.5) 25%, rgba(0,114,206,0.15) 50%, transparent 75%),
      #001F3F;
    position: relative;
    overflow: hidden;
    font-family: 'Inter', 'Noto Sans TC', sans-serif;
    padding: 80px 90px;
    display: flex;
    flex-direction: column;
  }
  .title {
    font-weight: 900;
    font-size: 72px;
    color: #fff;
    line-height: 1.3;
    margin-bottom: 28px;
    text-shadow: 0 2px 8px rgba(0,0,0,0.3);
  }
  .description {
    font-weight: 500;
    font-size: 44px;
    color: rgba(255,255,255,0.65);
    line-height: 1.6;
    margin-bottom: 48px;
  }
  .image-area {
    flex: 1;
    background: #D9D9D9;
    border-radius: 20px;
    overflow: hidden;
    box-shadow: 0 12px 40px rgba(0,0,0,0.3);
  }
  .image-area img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
  .handle {
    position: absolute;
    bottom: 72px;
    left: 90px;
    font-family: 'Inter', sans-serif;
    font-size: 33px;
    font-weight: 600;
    color: rgba(255,255,255,0.3);
  }
</style>
</head>
<body>
<div class="card">
  <h2 class="title">標題標題標題標題標題</h2>
  <p class="description">內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文</p>
  <div class="image-area">
    <!-- 替換為 <img src="your-screenshot.png"> -->
  </div>
  <span class="handle">@yourhandle</span>
</div>
</body>
</html>
CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BRAND_DARK_CONTENT_IMAGE_HTML

# social-cards/assets/brand-dark/content-text.html
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/assets/brand-dark/content-text.html")"
cat > "{{CODEX_HOME}}/skills/social-cards/assets/brand-dark/content-text.html" <<'CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BRAND_DARK_CONTENT_TEXT_HTML'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=1080">
<title>Content Text — Brand Dark</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Noto+Sans+TC:wght@400;500;700;900&display=swap" rel="stylesheet">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  .card {
    width: 1080px;
    height: 1350px;
    background:
      radial-gradient(ellipse 900px 900px at 100% 0%, #003A70 0%, transparent 70%),
      radial-gradient(circle 1200px at -10% 105%, #0072CE 0%, rgba(0,114,206,0.5) 25%, rgba(0,114,206,0.15) 50%, transparent 75%),
      #001F3F;
    position: relative;
    overflow: hidden;
    font-family: 'Inter', 'Noto Sans TC', sans-serif;
    padding: 100px 90px;
    display: flex;
    flex-direction: column;
  }
  .title {
    font-weight: 900;
    font-size: 72px;
    color: #fff;
    line-height: 1.4;
    margin-bottom: 56px;
  }
  .bullet-list {
    list-style: none;
    padding: 0;
    display: flex;
    flex-direction: column;
    gap: 36px;
    flex: 1;
  }
  .bullet-item {
    display: flex;
    gap: 36px;
    align-items: flex-start;
  }
  .bullet-dot {
    flex-shrink: 0;
    width: 22px;
    height: 22px;
    background: #fff;
    border-radius: 50%;
    margin-top: 30px;
  }
  .bullet-text {
    font-size: 44px;
    font-weight: 500;
    color: rgba(255,255,255,0.8);
    line-height: 1.6;
  }
  .handle {
    position: absolute;
    bottom: 72px;
    left: 90px;
    font-family: 'Inter', sans-serif;
    font-size: 33px;
    font-weight: 600;
    color: rgba(255,255,255,0.3);
  }
</style>
</head>
<body>
<div class="card">
  <h2 class="title">標題標題<br>標題標題標題標題？</h2>

  <div class="bullet-list">
    <div class="bullet-item">
      <div class="bullet-dot"></div>
      <p class="bullet-text">內文內文內文內文內文內文內文內文內文內文內文</p>
    </div>
    <div class="bullet-item">
      <div class="bullet-dot"></div>
      <p class="bullet-text">內文內文內文內文內文內文內文內文內文內文內文內文內文</p>
    </div>
    <div class="bullet-item">
      <div class="bullet-dot"></div>
      <p class="bullet-text">內文內文內文內文內文內文內文內文內文內文內文</p>
    </div>
    <div class="bullet-item">
      <div class="bullet-dot"></div>
      <p class="bullet-text">內文內文內文內文內文內文內文內文內文內文內文內文內文</p>
    </div>
  </div>

  <span class="handle">@yourhandle</span>
</div>
</body>
</html>
CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BRAND_DARK_CONTENT_TEXT_HTML

# social-cards/assets/brand-dark/cover.html
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/assets/brand-dark/cover.html")"
cat > "{{CODEX_HOME}}/skills/social-cards/assets/brand-dark/cover.html" <<'CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BRAND_DARK_COVER_HTML'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=1080">
<title>Cover — Brand Dark</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Noto+Sans+TC:wght@400;500;700;900&display=swap" rel="stylesheet">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  .card {
    width: 1080px;
    height: 1350px;
    background:
      radial-gradient(ellipse 900px 900px at 100% 0%, #003A70 0%, transparent 70%),
      radial-gradient(circle 1200px at -10% 105%, #0072CE 0%, rgba(0,114,206,0.5) 25%, rgba(0,114,206,0.15) 50%, transparent 75%),
      #001F3F;
    position: relative;
    overflow: hidden;
    font-family: 'Inter', 'Noto Sans TC', sans-serif;
  }
  .content {
    position: absolute;
    bottom: 200px;
    left: 90px;
    right: 90px;
  }
  .title {
    font-weight: 900;
    font-size: 88px;
    color: #fff;
    line-height: 1.3;
    margin-bottom: 32px;
  }
  .subtitle {
    font-weight: 500;
    font-size: 44px;
    color: #7DB9E8;
    line-height: 1.5;
  }
  .handle {
    position: absolute;
    bottom: 72px;
    left: 90px;
    font-family: 'Inter', sans-serif;
    font-size: 33px;
    font-weight: 600;
    color: rgba(255,255,255,0.3);
  }
</style>
</head>
<body>
<div class="card">
  <div class="content">
    <h1 class="title">標題標題<br>標題標題標題標題</h1>
    <p class="subtitle">副標題副標題副標題</p>
  </div>
  <span class="handle">@yourhandle</span>
</div>
</body>
</html>
CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BRAND_DARK_COVER_HTML

# social-cards/assets/brand-dark/cta.html
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/assets/brand-dark/cta.html")"
cat > "{{CODEX_HOME}}/skills/social-cards/assets/brand-dark/cta.html" <<'CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BRAND_DARK_CTA_HTML'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=1080">
<title>CTA — Brand Dark</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Noto+Sans+TC:wght@400;500;700;900&display=swap" rel="stylesheet">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  .card {
    width: 1080px;
    height: 1350px;
    background:
      radial-gradient(ellipse 900px 900px at 100% 0%, #003A70 0%, transparent 70%),
      radial-gradient(circle 1200px at -10% 105%, #0072CE 0%, rgba(0,114,206,0.5) 25%, rgba(0,114,206,0.15) 50%, transparent 75%),
      #001F3F;
    position: relative;
    overflow: hidden;
    font-family: 'Inter', 'Noto Sans TC', sans-serif;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }
  .title {
    font-weight: 900;
    font-size: 88px;
    color: #fff;
    text-align: center;
    line-height: 1.35;
    margin-bottom: 44px;
  }
  .subtitle {
    font-weight: 500;
    font-size: 40px;
    color: rgba(255,255,255,0.5);
    text-align: center;
    line-height: 1.6;
    margin-bottom: 52px;
  }
  .handle-badge {
    display: inline-block;
    background: rgba(255,255,255,0.12);
    border: 1px solid rgba(255,255,255,0.2);
    color: #fff;
    font-family: 'Inter', sans-serif;
    font-size: 40px;
    font-weight: 700;
    padding: 20px 48px;
    border-radius: 60px;
  }
  /* 底部互動提示 */
  .bottom-actions {
    position: absolute;
    bottom: 64px;
    left: 90px;
    right: 90px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .action {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 12px;
    color: #fff;
  }
  .action-icon {
    width: 44px;
    height: 44px;
  }
  .action-icon svg {
    width: 44px;
    height: 44px;
    fill: none;
    stroke: #fff;
    stroke-width: 2;
  }
  .action-text {
    font-size: 26px;
    font-weight: 500;
  }
</style>
</head>
<body>
<div class="card">
  <h2 class="title">有幫助的話<br>記得按讚分享</h2>
  <p class="subtitle">更多教學與實戰分享<br>追蹤我的帳號，不錯過最新內容</p>
  <span class="handle-badge">@yourhandle</span>

  <div class="bottom-actions">
    <div class="action">
      <span class="action-icon"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg></span>
      <span class="action-text">喜歡點愛心</span>
    </div>
    <div class="action">
      <span class="action-icon"><svg viewBox="0 0 24 24"><path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"/></svg></span>
      <span class="action-text">實用請收藏</span>
    </div>
  </div>
</div>
</body>
</html>
CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BRAND_DARK_CTA_HTML

# social-cards/assets/brand-light/content-image.html
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/assets/brand-light/content-image.html")"
cat > "{{CODEX_HOME}}/skills/social-cards/assets/brand-light/content-image.html" <<'CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BRAND_LIGHT_CONTENT_IMAGE_HTML'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=1080">
<title>Content Image — Brand Light</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Noto+Sans+TC:wght@400;500;700;900&display=swap" rel="stylesheet">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  .card {
    width: 1080px;
    height: 1350px;
    background: #F6F7F8;
    position: relative;
    overflow: hidden;
    font-family: 'Inter', 'Noto Sans TC', sans-serif;
  }
  /* 頂部橘色色塊（居中） */
  .deco-bar {
    position: absolute;
    top: 0;
    left: 227px;
    width: 636px;
    height: 18px;
    background: #0072CE;
  }
  .title {
    position: absolute;
    top: 107px;
    left: 83px;
    right: 83px;
    font-size: 72px;
    font-weight: 900;
    color: #0072CE;
    line-height: 1.4;
    text-align: center;
  }
  .description {
    position: absolute;
    top: 253px;
    left: 103px;
    right: 103px;
    font-size: 44px;
    font-weight: 500;
    color: #40444D;
    line-height: 1.6;
    text-align: center;
  }
  .image-area {
    position: absolute;
    top: 590px;
    left: 83px;
    right: 83px;
    height: 519px;
    background: #D9D9D9;
    border-radius: 17px;
    overflow: hidden;
    box-shadow: 0px 22px 22px 12px rgba(200, 200, 200, 0.25);
  }
  .image-area img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
  .handle {
    position: absolute;
    bottom: 72px;
    left: 90px;
    font-family: 'Inter', sans-serif;
    font-size: 33px;
    font-weight: 600;
    color: rgba(0,0,0,0.25);
  }
</style>
</head>
<body>
<div class="card">
  <div class="deco-bar"></div>
  <h2 class="title">標題標題標題標題標題</h2>
  <p class="description">內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文</p>
  <div class="image-area">
    <!-- 替換為 <img src="your-screenshot.png"> -->
  </div>
  <span class="handle">@yourhandle</span>
</div>
</body>
</html>
CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BRAND_LIGHT_CONTENT_IMAGE_HTML

# social-cards/assets/brand-light/content-text.html
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/assets/brand-light/content-text.html")"
cat > "{{CODEX_HOME}}/skills/social-cards/assets/brand-light/content-text.html" <<'CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BRAND_LIGHT_CONTENT_TEXT_HTML'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=1080">
<title>Content Text — Brand Light</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Noto+Sans+TC:wght@400;500;700;900&display=swap" rel="stylesheet">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  .card {
    width: 1080px;
    height: 1350px;
    background: #F6F7F8;
    position: relative;
    overflow: hidden;
    font-family: 'Inter', 'Noto Sans TC', sans-serif;
    padding: 100px 90px;
    display: flex;
    flex-direction: column;
  }
  .title {
    font-weight: 900;
    font-size: 72px;
    color: #0072CE;
    line-height: 1.4;
    margin-bottom: 56px;
  }
  .bullet-list {
    list-style: none;
    padding: 0;
    display: flex;
    flex-direction: column;
    gap: 36px;
    flex: 1;
  }
  .bullet-item {
    display: flex;
    gap: 36px;
    align-items: flex-start;
    padding-left: 24px;
  }
  .bullet-dot {
    flex-shrink: 0;
    width: 22px;
    height: 22px;
    background: #0072CE;
    border-radius: 50%;
    margin-top: 30px;
  }
  .bullet-text {
    font-size: 44px;
    font-weight: 500;
    color: #40444D;
    line-height: 1.6;
  }
  .handle {
    position: absolute;
    bottom: 72px;
    left: 90px;
    font-family: 'Inter', sans-serif;
    font-size: 33px;
    font-weight: 600;
    color: rgba(0,0,0,0.25);
  }
</style>
</head>
<body>
<div class="card">
  <h2 class="title">標題標題<br>標題標題標題標題？</h2>

  <div class="bullet-list">
    <div class="bullet-item">
      <div class="bullet-dot"></div>
      <p class="bullet-text">內文內文內文內文內文內文內文內文內文內文內文</p>
    </div>
    <div class="bullet-item">
      <div class="bullet-dot"></div>
      <p class="bullet-text">內文內文內文內文內文內文內文內文內文內文內文內文內文</p>
    </div>
    <div class="bullet-item">
      <div class="bullet-dot"></div>
      <p class="bullet-text">內文內文內文內文內文內文內文內文內文內文內文</p>
    </div>
    <div class="bullet-item">
      <div class="bullet-dot"></div>
      <p class="bullet-text">內文內文內文內文內文內文內文內文內文內文內文內文內文</p>
    </div>
  </div>

  <span class="handle">@yourhandle</span>
</div>
</body>
</html>
CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BRAND_LIGHT_CONTENT_TEXT_HTML

# social-cards/assets/brand-light/cover.html
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/assets/brand-light/cover.html")"
cat > "{{CODEX_HOME}}/skills/social-cards/assets/brand-light/cover.html" <<'CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BRAND_LIGHT_COVER_HTML'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=1080">
<title>Cover — Brand Light</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Noto+Sans+TC:wght@400;500;700;900&display=swap" rel="stylesheet">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  .card {
    width: 1080px;
    height: 1350px;
    background: #fff;
    position: relative;
    overflow: hidden;
    font-family: 'Inter', 'Noto Sans TC', sans-serif;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }
  /* 頂部品牌藍薄紗 */
  .card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 600px;
    background: linear-gradient(180deg, rgba(0,114,206,0.22) 0%, rgba(0,114,206,0.06) 65%, transparent 100%);
    pointer-events: none;
  }
  /* 格紋紋理 */
  .card::after {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-image:
      linear-gradient(rgba(0,0,0,0.03) 1px, transparent 1px),
      linear-gradient(90deg, rgba(0,0,0,0.03) 1px, transparent 1px);
    background-size: 40px 40px;
    pointer-events: none;
  }
  .title {
    font-weight: 900;
    font-size: 88px;
    color: #0072CE;
    text-align: center;
    line-height: 1.35;
    margin-bottom: 36px;
  }
  .divider {
    width: 80px;
    height: 5px;
    background: #0072CE;
    border-radius: 3px;
    margin-bottom: 40px;
  }
  .subtitle {
    font-weight: 500;
    font-size: 44px;
    color: #40444D;
    text-align: center;
    line-height: 1.6;
    padding: 0 100px;
  }
  .handle {
    position: absolute;
    bottom: 72px;
    left: 90px;
    font-family: 'Inter', sans-serif;
    font-size: 33px;
    font-weight: 600;
    color: rgba(0,0,0,0.25);
  }
</style>
</head>
<body>
<div class="card">
  <h1 class="title">標題標題<br>標題標題標題標題</h1>
  <div class="divider"></div>
  <p class="subtitle">副標題副標題副標題副標題<br>副標題副標題副標題</p>
  <span class="handle">@yourhandle</span>
</div>
</body>
</html>
CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BRAND_LIGHT_COVER_HTML

# social-cards/assets/brand-light/cta.html
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/assets/brand-light/cta.html")"
cat > "{{CODEX_HOME}}/skills/social-cards/assets/brand-light/cta.html" <<'CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BRAND_LIGHT_CTA_HTML'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=1080">
<title>CTA — Brand Light</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Noto+Sans+TC:wght@400;500;700;900&display=swap" rel="stylesheet">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  .card {
    width: 1080px;
    height: 1350px;
    background: #fff;
    position: relative;
    overflow: hidden;
    font-family: 'Inter', 'Noto Sans TC', sans-serif;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }
  .title {
    font-weight: 900;
    font-size: 88px;
    color: #0072CE;
    text-align: center;
    line-height: 1.35;
    margin-bottom: 44px;
  }
  .subtitle {
    font-weight: 500;
    font-size: 40px;
    color: #666;
    text-align: center;
    line-height: 1.6;
    margin-bottom: 52px;
  }
  .handle-badge {
    display: inline-block;
    background: #0072CE;
    color: #fff;
    font-family: 'Inter', sans-serif;
    font-size: 40px;
    font-weight: 700;
    padding: 20px 48px;
    border-radius: 60px;
  }
  .bottom-actions {
    position: absolute;
    bottom: 64px;
    left: 90px;
    right: 90px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .action {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 12px;
    color: #40444D;
  }
  .action-icon {
    width: 44px;
    height: 44px;
  }
  .action-icon svg {
    width: 44px;
    height: 44px;
    fill: none;
    stroke: #40444D;
    stroke-width: 2;
  }
  .action-text {
    font-size: 26px;
    font-weight: 500;
  }
</style>
</head>
<body>
<div class="card">
  <h2 class="title">有幫助的話<br>記得按讚分享</h2>
  <p class="subtitle">更多教學與實戰分享<br>追蹤我的帳號，不錯過最新內容</p>
  <span class="handle-badge">@yourhandle</span>

  <div class="bottom-actions">
    <div class="action">
      <span class="action-icon"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg></span>
      <span class="action-text">喜歡點愛心</span>
    </div>
    <div class="action">
      <span class="action-icon"><svg viewBox="0 0 24 24"><path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"/></svg></span>
      <span class="action-text">實用請收藏</span>
    </div>
  </div>
</div>
</body>
</html>
CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_BRAND_LIGHT_CTA_HTML

# social-cards/assets/orange-light/content-image.html
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/assets/orange-light/content-image.html")"
cat > "{{CODEX_HOME}}/skills/social-cards/assets/orange-light/content-image.html" <<'CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_ORANGE_LIGHT_CONTENT_IMAGE_HTML'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=1080">
<title>Content Image — Orange Light</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Noto+Sans+TC:wght@400;500;700;900&display=swap" rel="stylesheet">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  .card {
    width: 1080px;
    height: 1350px;
    background: #F6F7F8;
    position: relative;
    overflow: hidden;
    font-family: 'Inter', 'Noto Sans TC', sans-serif;
  }
  /* 頂部橘色色塊（居中） */
  .deco-bar {
    position: absolute;
    top: 0;
    left: 227px;
    width: 636px;
    height: 18px;
    background: #E27F2E;
  }
  .title {
    position: absolute;
    top: 107px;
    left: 83px;
    right: 83px;
    font-size: 72px;
    font-weight: 900;
    color: #E27F2E;
    line-height: 1.4;
    text-align: center;
  }
  .description {
    position: absolute;
    top: 253px;
    left: 103px;
    right: 103px;
    font-size: 44px;
    font-weight: 500;
    color: #40444D;
    line-height: 1.6;
    text-align: center;
  }
  .image-area {
    position: absolute;
    top: 590px;
    left: 83px;
    right: 83px;
    height: 519px;
    background: #D9D9D9;
    border-radius: 17px;
    overflow: hidden;
    box-shadow: 0px 22px 22px 12px rgba(200, 200, 200, 0.25);
  }
  .image-area img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
  .handle {
    position: absolute;
    bottom: 72px;
    left: 90px;
    font-family: 'Inter', sans-serif;
    font-size: 33px;
    font-weight: 600;
    color: rgba(0,0,0,0.25);
  }
</style>
</head>
<body>
<div class="card">
  <div class="deco-bar"></div>
  <h2 class="title">標題標題標題標題標題</h2>
  <p class="description">內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文內文</p>
  <div class="image-area">
    <!-- 替換為 <img src="your-screenshot.png"> -->
  </div>
  <span class="handle">@raymond0917</span>
</div>
</body>
</html>
CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_ORANGE_LIGHT_CONTENT_IMAGE_HTML

# social-cards/assets/orange-light/content-text.html
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/assets/orange-light/content-text.html")"
cat > "{{CODEX_HOME}}/skills/social-cards/assets/orange-light/content-text.html" <<'CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_ORANGE_LIGHT_CONTENT_TEXT_HTML'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=1080">
<title>Content Text — Orange Light</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Noto+Sans+TC:wght@400;500;700;900&display=swap" rel="stylesheet">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  .card {
    width: 1080px;
    height: 1350px;
    background: #F6F7F8;
    position: relative;
    overflow: hidden;
    font-family: 'Inter', 'Noto Sans TC', sans-serif;
    padding: 100px 90px;
    display: flex;
    flex-direction: column;
  }
  .title {
    font-weight: 900;
    font-size: 72px;
    color: #E27F2E;
    line-height: 1.4;
    margin-bottom: 56px;
  }
  .bullet-list {
    list-style: none;
    padding: 0;
    display: flex;
    flex-direction: column;
    gap: 36px;
    flex: 1;
  }
  .bullet-item {
    display: flex;
    gap: 36px;
    align-items: flex-start;
    padding-left: 24px;
  }
  .bullet-dot {
    flex-shrink: 0;
    width: 22px;
    height: 22px;
    background: #E27F2E;
    border-radius: 50%;
    margin-top: 30px;
  }
  .bullet-text {
    font-size: 44px;
    font-weight: 500;
    color: #40444D;
    line-height: 1.6;
  }
  .handle {
    position: absolute;
    bottom: 72px;
    left: 90px;
    font-family: 'Inter', sans-serif;
    font-size: 33px;
    font-weight: 600;
    color: rgba(0,0,0,0.25);
  }
</style>
</head>
<body>
<div class="card">
  <h2 class="title">標題標題<br>標題標題標題標題？</h2>

  <div class="bullet-list">
    <div class="bullet-item">
      <div class="bullet-dot"></div>
      <p class="bullet-text">內文內文內文內文內文內文內文內文內文內文內文</p>
    </div>
    <div class="bullet-item">
      <div class="bullet-dot"></div>
      <p class="bullet-text">內文內文內文內文內文內文內文內文內文內文內文內文內文</p>
    </div>
    <div class="bullet-item">
      <div class="bullet-dot"></div>
      <p class="bullet-text">內文內文內文內文內文內文內文內文內文內文內文</p>
    </div>
    <div class="bullet-item">
      <div class="bullet-dot"></div>
      <p class="bullet-text">內文內文內文內文內文內文內文內文內文內文內文內文內文</p>
    </div>
  </div>

  <span class="handle">@raymond0917</span>
</div>
</body>
</html>
CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_ORANGE_LIGHT_CONTENT_TEXT_HTML

# social-cards/assets/orange-light/cover.html
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/assets/orange-light/cover.html")"
cat > "{{CODEX_HOME}}/skills/social-cards/assets/orange-light/cover.html" <<'CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_ORANGE_LIGHT_COVER_HTML'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=1080">
<title>Cover — Orange Light</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Noto+Sans+TC:wght@400;500;700;900&display=swap" rel="stylesheet">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  .card {
    width: 1080px;
    height: 1350px;
    background: #fff;
    position: relative;
    overflow: hidden;
    font-family: 'Inter', 'Noto Sans TC', sans-serif;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }
  /* 頂部淡橘色薄紗 */
  .card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 600px;
    background: linear-gradient(180deg, rgba(231,155,80,0.22) 0%, rgba(231,155,80,0.06) 65%, transparent 100%);
    pointer-events: none;
  }
  /* 格紋紋理 */
  .card::after {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-image:
      linear-gradient(rgba(0,0,0,0.03) 1px, transparent 1px),
      linear-gradient(90deg, rgba(0,0,0,0.03) 1px, transparent 1px);
    background-size: 40px 40px;
    pointer-events: none;
  }
  .title {
    font-weight: 900;
    font-size: 88px;
    color: #E27F2E;
    text-align: center;
    line-height: 1.35;
    margin-bottom: 36px;
  }
  .divider {
    width: 80px;
    height: 5px;
    background: #E27F2E;
    border-radius: 3px;
    margin-bottom: 40px;
  }
  .subtitle {
    font-weight: 500;
    font-size: 44px;
    color: #40444D;
    text-align: center;
    line-height: 1.6;
    padding: 0 100px;
  }
  .handle {
    position: absolute;
    bottom: 72px;
    left: 90px;
    font-family: 'Inter', sans-serif;
    font-size: 33px;
    font-weight: 600;
    color: rgba(0,0,0,0.25);
  }
</style>
</head>
<body>
<div class="card">
  <h1 class="title">標題標題<br>標題標題標題標題</h1>
  <div class="divider"></div>
  <p class="subtitle">副標題副標題副標題副標題<br>副標題副標題副標題</p>
  <span class="handle">@raymond0917</span>
</div>
</body>
</html>
CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_ORANGE_LIGHT_COVER_HTML

# social-cards/assets/orange-light/cta.html
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/assets/orange-light/cta.html")"
cat > "{{CODEX_HOME}}/skills/social-cards/assets/orange-light/cta.html" <<'CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_ORANGE_LIGHT_CTA_HTML'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=1080">
<title>CTA — Orange Light</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Noto+Sans+TC:wght@400;500;700;900&display=swap" rel="stylesheet">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  .card {
    width: 1080px;
    height: 1350px;
    background: #fff;
    position: relative;
    overflow: hidden;
    font-family: 'Inter', 'Noto Sans TC', sans-serif;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }
  .title {
    font-weight: 900;
    font-size: 88px;
    color: #E27F2E;
    text-align: center;
    line-height: 1.35;
    margin-bottom: 44px;
  }
  .subtitle {
    font-weight: 500;
    font-size: 40px;
    color: #666;
    text-align: center;
    line-height: 1.6;
    margin-bottom: 52px;
  }
  .handle-badge {
    display: inline-block;
    background: #E27F2E;
    color: #fff;
    font-family: 'Inter', sans-serif;
    font-size: 40px;
    font-weight: 700;
    padding: 20px 48px;
    border-radius: 60px;
  }
  .bottom-actions {
    position: absolute;
    bottom: 64px;
    left: 90px;
    right: 90px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .action {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 12px;
    color: #40444D;
  }
  .action-icon {
    width: 44px;
    height: 44px;
  }
  .action-icon svg {
    width: 44px;
    height: 44px;
    fill: none;
    stroke: #40444D;
    stroke-width: 2;
  }
  .action-text {
    font-size: 26px;
    font-weight: 500;
  }
</style>
</head>
<body>
<div class="card">
  <h2 class="title">有幫助的話<br>記得按讚分享</h2>
  <p class="subtitle">更多教學與實戰分享<br>追蹤我的帳號，不錯過最新內容</p>
  <span class="handle-badge">@raymond0917</span>

  <div class="bottom-actions">
    <div class="action">
      <span class="action-icon"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg></span>
      <span class="action-text">喜歡點愛心</span>
    </div>
    <div class="action">
      <span class="action-icon"><svg viewBox="0 0 24 24"><path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"/></svg></span>
      <span class="action-text">實用請收藏</span>
    </div>
  </div>
</div>
</body>
</html>
CODEX_LAZYPACK_SOCIAL_CARDS_ASSETS_ORANGE_LIGHT_CTA_HTML

# social-cards/package-lock.json
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/package-lock.json")"
cat > "{{CODEX_HOME}}/skills/social-cards/package-lock.json" <<'CODEX_LAZYPACK_SOCIAL_CARDS_PACKAGE_LOCK_JSON'
{
  "name": "social-cards",
  "version": "1.0.0",
  "lockfileVersion": 3,
  "requires": true,
  "packages": {
    "": {
      "name": "social-cards",
      "version": "1.0.0",
      "license": "CC-BY-NC-SA-4.0",
      "dependencies": {
        "playwright": "^1.60.0"
      }
    },
    "node_modules/fsevents": {
      "version": "2.3.2",
      "resolved": "https://registry.npmjs.org/fsevents/-/fsevents-2.3.2.tgz",
      "integrity": "sha512-xiqMQR4xAeHTuB9uWm+fFRcIOgKBMiOBP+eXiyT7jsgVCq1bkVygt00oASowB7EdtpOHaaPgKt812P9ab+DDKA==",
      "hasInstallScript": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "darwin"
      ],
      "engines": {
        "node": "^8.16.0 || ^10.6.0 || >=11.0.0"
      }
    },
    "node_modules/playwright": {
      "version": "1.60.0",
      "resolved": "https://registry.npmjs.org/playwright/-/playwright-1.60.0.tgz",
      "integrity": "sha512-hheHdokM8cdqCb0lcE3s+zT4t4W+vvjpGxsZlDnikarzx8tSzMebh3UiFtgqwFwnTnjYQcsyMF8ei2mCO/tpeA==",
      "license": "Apache-2.0",
      "dependencies": {
        "playwright-core": "1.60.0"
      },
      "bin": {
        "playwright": "cli.js"
      },
      "engines": {
        "node": ">=18"
      },
      "optionalDependencies": {
        "fsevents": "2.3.2"
      }
    },
    "node_modules/playwright-core": {
      "version": "1.60.0",
      "resolved": "https://registry.npmjs.org/playwright-core/-/playwright-core-1.60.0.tgz",
      "integrity": "sha512-9bW6zvX/m0lEbgTKJ6YppOKx8H3VOPBMOCFh2irXFOT4BbHgrx5hPjwJYLT40Lu+4qtD36qKc/Hn56StUW57IA==",
      "license": "Apache-2.0",
      "bin": {
        "playwright-core": "cli.js"
      },
      "engines": {
        "node": ">=18"
      }
    }
  }
}
CODEX_LAZYPACK_SOCIAL_CARDS_PACKAGE_LOCK_JSON

# social-cards/package.json
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/package.json")"
cat > "{{CODEX_HOME}}/skills/social-cards/package.json" <<'CODEX_LAZYPACK_SOCIAL_CARDS_PACKAGE_JSON'
{
  "name": "social-cards",
  "version": "1.0.0",
  "description": "Codex skill for generating Pantone 285C branded social cards.",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "CC-BY-NC-SA-4.0",
  "type": "commonjs",
  "dependencies": {
    "playwright": "^1.60.0"
  }
}
CODEX_LAZYPACK_SOCIAL_CARDS_PACKAGE_JSON

# social-cards/preview-all.html
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/preview-all.html")"
cat > "{{CODEX_HOME}}/skills/social-cards/preview-all.html" <<'CODEX_LAZYPACK_SOCIAL_CARDS_PREVIEW_ALL_HTML'
<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<title>Social Cards — 全版型預覽</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { background: #f0f0f0; font-family: 'Inter', -apple-system, sans-serif; padding: 40px; }
  .row { margin-bottom: 60px; }
  .row-label {
    font-size: 14px; font-weight: 600; color: #999;
    letter-spacing: 2px; margin-bottom: 16px;
  }
  .grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 24px;
  }
  .cell { display: flex; flex-direction: column; gap: 8px; }
  .cell-label {
    font-size: 12px; font-weight: 600; color: #aaa;
    letter-spacing: 1px;
  }
  .frame-wrap {
    width: 100%;
    aspect-ratio: 1080 / 1350;
    position: relative;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 2px 12px rgba(0,0,0,0.12);
  }
  .frame-wrap iframe {
    position: absolute;
    top: 0; left: 0;
    width: 1080px;
    height: 1350px;
    transform-origin: top left;
    border: none;
  }
</style>
<script>
  function scaleFrames() {
    document.querySelectorAll('.frame-wrap').forEach(wrap => {
      const scale = wrap.offsetWidth / 1080;
      wrap.querySelector('iframe').style.transform = `scale(${scale})`;
    });
  }
  window.addEventListener('load', scaleFrames);
  window.addEventListener('resize', scaleFrames);
</script>
</head>
<body>

<div class="row">
  <div class="row-label">ORANGE LIGHT</div>
  <div class="grid">
    <div class="cell">
      <div class="cell-label">orange-cover</div>
      <div class="frame-wrap"><iframe src="assets/orange-light/cover.html"></iframe></div>
    </div>
    <div class="cell">
      <div class="cell-label">orange-img</div>
      <div class="frame-wrap"><iframe src="assets/orange-light/content-image.html"></iframe></div>
    </div>
    <div class="cell">
      <div class="cell-label">orange-text</div>
      <div class="frame-wrap"><iframe src="assets/orange-light/content-text.html"></iframe></div>
    </div>
    <div class="cell">
      <div class="cell-label">orange-cta</div>
      <div class="frame-wrap"><iframe src="assets/orange-light/cta.html"></iframe></div>
    </div>
  </div>
</div>

<div class="row">
  <div class="row-label">BLUE DARK</div>
  <div class="grid">
    <div class="cell">
      <div class="cell-label">dark-cover</div>
      <div class="frame-wrap"><iframe src="assets/blue-dark/cover.html"></iframe></div>
    </div>
    <div class="cell">
      <div class="cell-label">dark-img</div>
      <div class="frame-wrap"><iframe src="assets/blue-dark/content-image.html"></iframe></div>
    </div>
    <div class="cell">
      <div class="cell-label">dark-text</div>
      <div class="frame-wrap"><iframe src="assets/blue-dark/content-text.html"></iframe></div>
    </div>
    <div class="cell">
      <div class="cell-label">dark-cta</div>
      <div class="frame-wrap"><iframe src="assets/blue-dark/cta.html"></iframe></div>
    </div>
  </div>
</div>

</body>
</html>
CODEX_LAZYPACK_SOCIAL_CARDS_PREVIEW_ALL_HTML

# social-cards/references/source-adaptation.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/references/source-adaptation.md")"
cat > "{{CODEX_HOME}}/skills/social-cards/references/source-adaptation.md" <<'CODEX_LAZYPACK_SOCIAL_CARDS_REFERENCES_SOURCE_ADAPTATION_MD'
---
title: Social Cards Source Adaptation
date: 2026-05-25
type: reference
tags:
  - codex
  - skills
  - social-cards
---

# Source Adaptation

This skill adapts the third-party `skills/social-cards` package from:

- Source page in document: `https://cc.lifehacker.tw`
- Source repo: `https://github.com/lifehacker-tw/claude-code-mini-course.git`
- Source folder: `skills/social-cards/`
- Source snapshot checked: `b2cd801`
- Original author attribution in source: Raymond Hou / 雷蒙
- Blog listed in source: `https://raymondhouch.com`
- Threads listed in source: `@raymond0917`
- Course listed in source: `https://lifehacker.tw/courses/24hr-claude-code-tutorial`
- Newsletter listed in source: `https://raymondhouch.com/subscribe`
- License stated by source: CC BY-NC-SA 4.0, personal learning and sharing allowed, commercial use prohibited

## Codex Conversion

- Target Codex global skill path: `{{CODEX_HOME}}/skills/social-cards`.
- Project-local option: if this card workflow is only for one project, use `<project-root>/000_Agent/skills/social-cards` instead and keep it as that project's portable skill package.
- Display name requested by user: Social Cards.
- Previous temporary package path: `codex_installation/converted-skills/cards`（已清理）。
- Removed source-only Claude-specific metadata fields.
- Replaced Claude command assumptions with Codex trigger metadata and procedural instructions.
- Synced upstream template sets `blue-dark` / `orange-light` from the source repo.
- Kept the existing Pantone 285C template sets `brand-dark` / `brand-light` as Codex-local compatibility templates.
- Updated the default flow to use upstream `orange-light` / `blue-dark`, while allowing Pantone 285C output when requested.

## Original Install Script Conversion Checklist

| Source instruction | Codex-compatible result |
|---|---|
| Install into Claude global skills path | Installed into `{{CODEX_HOME}}/skills/social-cards` |
| Install into `000_Agent/skills` | Valid only for a project-local or assistant-local workflow; do not symlink it into global skills |
| Rename install folder to `cards` | Renamed to `social-cards`; display name is Social Cards |
| Use `/cards` as a slash command | Kept `/cards` as a trigger phrase only; Codex uses skill metadata |
| Keep `blue-dark` and `orange-light` template sets | Synced from upstream; existing `brand-dark` and `brand-light` remain available for Pantone 285C branding |
| Install Playwright and Chromium | Installed locally in the skill folder |
| Verify by checking core files | Verified `SKILL.md`, 8 templates, screenshot script, Playwright, and Chromium |
| Export 2x PNG through Playwright | Verified with two generated PNG files in `/private/tmp/social-cards-rename-test/` |

## Brand Color

- Pantone: Pantone 285C
- Digital HEX: `#0072CE`
- RGB: `0, 114, 206`

Use `#0072CE` as the main accent when the user selects the Pantone 285C brand templates. Use the upstream colors when the user selects `blue-dark` or `orange-light`.
CODEX_LAZYPACK_SOCIAL_CARDS_REFERENCES_SOURCE_ADAPTATION_MD

# social-cards/references/upstream-readme.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/references/upstream-readme.md")"
cat > "{{CODEX_HOME}}/skills/social-cards/references/upstream-readme.md" <<'CODEX_LAZYPACK_SOCIAL_CARDS_REFERENCES_UPSTREAM_README_MD'
# 社群圖卡產生器 by 雷小蒙：不會設計也能一句話出 IG 圖卡

> **ver. 1.0** ｜ **Last edited: 2026-04-18**
> ⭐ 初學者友善｜10 分鐘安裝｜跨平台（macOS / Linux / Windows WSL）
> 丟一篇文章給 AI，它自動拆成一組品牌風格統一的 IG 圖卡，預覽確認後一鍵匯出 2x PNG。

```text
═══════════════════════════════════════════════════════════════
 社群圖卡產生器 by 雷小蒙 · by 雷蒙（Raymond Hou）
───────────────────────────────────────────────────────────────
 Source:      https://cc.lifehacker.tw
 Blog:        https://raymondhouch.com
 Threads:     @raymond0917
 License:     CC BY-NC-SA 4.0 · 個人使用自由；禁止商業用途
═══════════════════════════════════════════════════════════════
```

## 你可能遇過這個問題

你寫了一篇文章、做了一份教學筆記，想分享到 IG。

打開 Canva，光選模板就花了 20 分鐘。調字體、換顏色、對齊圖片，弄了一個多小時，出來的東西還是不滿意——配色不統一、每次做出來都長不一樣。

或者你根本不想碰設計軟體，覺得「我只是想把這段文字變成好看的圖而已，為什麼這麼麻煩」。

**社群圖卡產生器**專治這個問題。你跟 AI 說「幫我把這篇做成圖卡」，它會自動幫你：拆成適合 IG 的一張張圖、套上統一的品牌配色、讓你預覽修改、最後一鍵匯出可以直接發的 PNG。

## 裝完之後你會得到什麼

- **一個 `/cards` 指令** — 說「做圖卡」或 `/cards` 就會觸發
- **2 套品牌配色可選**：
  - 🔵 **藍黑系** — 深色科技感，適合教學、工具介紹
  - 🟠 **橘白系** — 明亮溫暖，適合觀點分享、心得
- **4 種卡片版型**：封面（cover）、純文字（content-text）、文字+圖片（content-image）、結尾呼籲（cta）
- **2 種尺寸**：4:5（1080×1350，IG 最常用）、1:1（1080×1080，IG / X 通用）
- **AI 自動拆卡** — 你只要給內容，AI 判斷要拆幾張、每張放什麼
- **預覽 → 修改 → 匯出** — 先在瀏覽器看完整效果，改到滿意再匯出 2x PNG
- **@handle 記憶** — 第一次設定你的帳號，之後自動帶入

## 資料夾結構

```
social-cards/
├── SKILL.md              ← Skill 主劇本（給 Claude 讀）
├── README.md             ← 你正在看的這份（給人讀）
├── assets/
│   ├── blue-dark/        ← 4 個藍黑系 HTML 模板
│   └── orange-light/     ← 4 個橘白系 HTML 模板
└── scripts/
    └── screenshot.mjs    ← Playwright 截圖腳本
```

## 怎麼安裝？

### 方式 1：直接複製資料夾（推薦）

```bash
# 如果你跑過 pro-kit 01「AI 分身起始助手」
cp -r social-cards/ 000_Agent/skills/cards/

# 或者用 Claude Code 預設位置
cp -r social-cards/ ~/.claude/skills/cards/
```

> [!IMPORTANT]
> 資料夾名稱要改成 `cards`（對應 SKILL.md 裡的 `name: cards`）。

安裝 Playwright（截圖用）：

```bash
cd ~/.claude/skills/cards/
npm init -y
npm install playwright
npx playwright install chromium
```

### 方式 2：貼給 Claude Code 代裝

把整個資料夾 + 本 README 貼給 Claude Code，跟它說：

> 幫我把這個社群圖卡 Skill 裝好

AI 會自動建立資料夾、複製模板、安裝 Playwright、驗證。

### 驗證

重開 Claude Code，打 `/cards` 或跟它說「做圖卡」，應該會啟動引導流程。

## 需要安裝什麼？

| 工具 | 用途 | 怎麼裝 |
|:--|:--|:--|
| **Node.js** | 執行截圖腳本 | 裝 Claude Code 終端機版時已經有了。桌面版用戶如果沒有，跟 AI 說「幫我裝 Node.js」 |
| **Playwright** | 把 HTML 圖卡截圖成 PNG | 見上方「方式 1」的 npm install 指令 |

## 怎麼用？

三種使用方式：

**方式一：給網址**
```
/cards https://你的文章網址.com
```

**方式二：給檔案**
```
/cards 200 Notes/我的讀書筆記.md
```

**方式三：直接打字**
```
做圖卡

（然後貼上你的文字內容）
```

AI 會帶你走完整個流程：選配色 → 選尺寸 → 確認帳號 → 自動拆卡 → 預覽 → 修改 → 匯出 PNG。

## 一次圖卡製作流程大約長這樣

1. 你丟一篇文章給 AI
2. AI 問你：藍黑還是橘白？4:5 還是 1:1？
3. AI 把文章拆成 5-8 張圖卡，列出規劃讓你確認
4. 你說 OK（或調整）
5. AI 生成預覽，在瀏覽器打開給你看
6. 你看完覺得第 3 張文字太長 → 跟 AI 說 → AI 改好 → 重新整理
7. 你說「匯出」→ AI 截圖，幾秒後 PNG 就在資料夾裡了

全程大約 3-5 分鐘，取決於你修改幾次。

## 搭配推薦

> [!TIP]
> 搭配迷你課 **3-2「品牌社群圖卡 & 簡報自動生成」** 一起看，先理解品牌配色與內容密度規則，做出來的圖卡會更專業。

## 授權

- **License**：CC BY-NC-SA 4.0 · 個人使用、學習、分享自由；禁止商業用途
- 出自 雷蒙三十 Starter Kit — cc.lifehacker.tw | CC BY-NC-SA 4.0
- [迷你課](https://lifehacker.tw/courses/24hr-claude-code-tutorial) · [週報](https://raymondhouch.com/subscribe) · [Threads @raymond0917](https://www.threads.com/@raymond0917)
CODEX_LAZYPACK_SOCIAL_CARDS_REFERENCES_UPSTREAM_README_MD

# social-cards/scripts/screenshot.mjs
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/social-cards/scripts/screenshot.mjs")"
cat > "{{CODEX_HOME}}/skills/social-cards/scripts/screenshot.mjs" <<'CODEX_LAZYPACK_SOCIAL_CARDS_SCRIPTS_SCREENSHOT_MJS'
// 社群圖卡截圖腳本（by 雷小蒙）
// 用法：node scripts/screenshot.mjs <output-folder>
// 會把資料夾內所有 .html（除了 preview.html）截成 2x PNG，最後刪除 HTML 只留 PNG

import { chromium } from 'playwright';
import { readdirSync, unlinkSync } from 'fs';
import { resolve } from 'path';

const dir = process.argv[2];
if (!dir) { console.error('Usage: node screenshot.mjs <folder>'); process.exit(1); }

const files = readdirSync(dir).filter(f => f.endsWith('.html') && f !== 'preview.html').sort();
console.log(`Found ${files.length} HTML files in ${dir}`);

const browser = await chromium.launch();
const context = await browser.newContext({ deviceScaleFactor: 2 });

for (const file of files) {
  const page = await context.newPage();
  await page.goto('file://' + resolve(dir, file));
  await page.waitForTimeout(2500);
  const card = await page.$('.card');
  const pngName = file.replace('.html', '.png');
  await card.screenshot({ path: resolve(dir, pngName) });
  await page.close();
  console.log(`✅ ${pngName}`);
}

await browser.close();

for (const file of [...files, 'preview.html']) {
  try { unlinkSync(resolve(dir, file)); } catch {}
}

console.log(`\n全部匯出完成！${files.length} 張 2x PNG 在 ${dir}/`);
CODEX_LAZYPACK_SOCIAL_CARDS_SCRIPTS_SCREENSHOT_MJS

cd "{{CODEX_HOME}}/skills/social-cards"
npm install
npx playwright install chromium

echo "Installed social-cards to {{CODEX_HOME}}/skills/social-cards"
````

<!-- END EMBEDDED_SKILLS -->
