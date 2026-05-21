---
name: social-cards
description: Use when the user asks to use Social Cards, make IG cards, social cards, carousel posts, "/cards", "做圖卡", "幫我做 IG 圖", or turn an article, note, URL, Markdown file, or pasted text into branded social-media PNG cards using the Pantone 285C brand templates.
metadata:
  short-description: Social Cards
---

# Social Cards

把文章、筆記、網址或貼上的文字轉成品牌一致的社群圖卡。預設品牌色為 Pantone 285C，數位色使用 `#0072CE`。

## Trigger Phrases

- 「做圖卡」
- 「/cards」
- 「Social Cards」
- 「幫我做 IG 圖」
- 「社群圖卡」
- 「把這篇做成圖卡」
- 使用者提供文章、Markdown、網址或段落，並要求轉成 IG / Threads / X 可用圖卡

## Assets

模板 HTML 在本 skill 的 `assets/` 子資料夾：

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

## Workflow

1. 收集內容來源：貼文、網址、Markdown 檔案路徑或使用者直接貼上的文字。
2. 若來源是網址，優先使用可用的網頁讀取工具擷取主要內容；若來源是本機檔案，先讀檔再整理。
3. 詢問或合理推定輸出比例：預設 `4:5`（1080 x 1350）；若使用者要求正方形，改為 `1:1`（1080 x 1080）。
4. 詢問風格：預設 `brand-light`，也可選 `brand-dark`。兩者都必須維持 Pantone 285C / `#0072CE` 作為品牌主色。
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
- 提到流程、介面、設定檔、程式碼、前後對照或使用者提供圖片時，優先使用 `content-image`。
- 寧可多拆卡，不要把單張塞滿。

## Codex Notes

- 不依賴 來源工具 slash-command 系統；`/cards` 只是使用者可能輸入的觸發語。
- 不使用 來源工具專用 frontmatter 或工具欄位。
- 若 Playwright、Chromium 或 `node_modules/` 尚未安裝，先告知需要安裝本 skill 的截圖依賴，再於本 skill 資料夾執行 `npm install` 並驗證。
- 複製給其他使用者或其他電腦時，不必複製 `node_modules/`；保留 `package.json` 與 `package-lock.json`，在新環境重新安裝依賴。
- 匯出後可刪除中間 HTML，保留 PNG；除非使用者要求保留可編輯 HTML。
