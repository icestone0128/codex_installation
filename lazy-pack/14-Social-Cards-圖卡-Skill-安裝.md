# 14-Social-Cards-圖卡-Skill-安裝

> 版本：2026-05-21 Codex App 版
> 用途：把 Raymond Hou / 雷蒙的 `skills/social-cards` 來源工具 安裝劇本，轉成可直接安裝到 Codex App 的全域 Skill。
> 成品：下載者可把本懶人包內的 `lazy-pack/skills/social-cards/` 複製到自己的 `{{CODEX_HOME}}/skills/social-cards/`，再安裝 Playwright 依賴後使用。

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
| 安裝到 `000_Agent/skills` 或 來源工具的 skills 路徑 | 安裝到 `{{CODEX_HOME}}/skills/social-cards` |
| skill 名稱為 `cards` | skill id 為 `social-cards`，顯示名稱為 Social Cards |
| `/cards` 是 slash command | `/cards` 只是觸發語；Codex 依 `SKILL.md` metadata 觸發 |
| `blue-dark` / `orange-light` | 已改為 `brand-dark` / `brand-light` |
| 原始 sample handle 是 `@raymond0917` | 模板預設改為 `@yourhandle` |
| 原始配色 | 本懶人包預設 Pantone 285C，數位色 `#0072CE` |

## 安裝方式 A：直接使用懶人包內的 skill

這是最穩的方式。下載本懶人包後，讓 Codex 在你的設定專案根目錄執行：

```bash
mkdir -p "{{CODEX_HOME}}/skills/social-cards"
rsync -a --delete --exclude node_modules "{{SETUP_REPO}}/lazy-pack/skills/social-cards/" "{{CODEX_HOME}}/skills/social-cards/"
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
test -d "{{CODEX_HOME}}/skills/social-cards/assets/brand-dark" && echo "brand-dark ok"
test -d "{{CODEX_HOME}}/skills/social-cards/assets/brand-light" && echo "brand-light ok"
test -f "{{CODEX_HOME}}/skills/social-cards/scripts/screenshot.mjs" && echo "screenshot script ok"
test -d "{{CODEX_HOME}}/skills/social-cards/node_modules/playwright" && echo "Playwright ok"
```

再做一次實際匯出測試：

```bash
mkdir -p /tmp/social-cards-test
cp "{{CODEX_HOME}}/skills/social-cards/assets/brand-light/cover.html" /tmp/social-cards-test/01-cover.html
cp "{{CODEX_HOME}}/skills/social-cards/assets/brand-dark/content-text.html" /tmp/social-cards-test/02-content.html
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
- [ ] `assets/brand-dark/` 有 4 個 HTML 模板。
- [ ] `assets/brand-light/` 有 4 個 HTML 模板。
- [ ] 模板主色使用 `#0072CE`。
- [ ] 模板 sample handle 是 `@yourhandle`。
- [ ] `scripts/screenshot.mjs` 存在。
- [ ] `node_modules/playwright` 存在。
- [ ] 實測匯出 PNG 成功。
- [ ] 開新 Codex 對話後，用「Social Cards」或「做圖卡」可觸發。
