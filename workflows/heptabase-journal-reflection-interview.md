# Heptabase Journal Reflection Interview Workflow

## 用途

當使用者要求「連到 Heptabase 看某一天的 Journal，使用 Daily Interview Assistant 訪問我，並把訪問後內容寫入該日 reflection」時，使用本 workflow。

本流程結合兩項能力：

- `heptabase-cli`：讀取與更新 Heptabase Journal。
- `diary-interview-assistant` / Daily Interview Assistant：依照日記內容或空白回想進行逐題訪問，整理成 3 個反思亮點。

## 觸發語意

使用者可能會說：

- 「請讀取我 Heptabase Journal 裡某一天的日記，然後用 Daily Interview Assistant 訪問我。」
- 「幫我把訪談後內容寫入 2026-05-31 的 reflection。」
- 「這天沒有間歇式日記，請直接用空白方式訪問。」
- 「依照間歇式日記訪問，最後寫到 reflection。」

## 必要輸入

- 日期：使用者提供的 Heptabase Journal 日期，統一轉成 `YYYY-MM-DD`。
- 寫入目標：預設為該日 Journal 裡 Daily Log 下的 `Reflection` toggle 內容區。

如果使用者提供相對日期或口語日期，先換算成明確日期並向使用者確認，尤其是未來日期或容易混淆的月份日期。

## 流程總覽

1. 連線與讀取 Heptabase Journal。
2. 檢查該日是否有「間歇式日記」內容。
3. 決定訪問模式。
4. 使用 Daily Interview Assistant 逐題訪問。
5. 整理訪談結果。
6. 詢問使用者是否寫入，以及確認寫入位置。
7. 寫入 Heptabase Journal 的 `Reflection` 區塊。
8. 重新讀取確認寫入成功後，workflow 才算完成。

## 詳細步驟

### 1. 連線與讀取 Journal

先確認 Heptabase CLI 可用：

```bash
heptabase --version
```

若版本不符合 `heptabase-cli` skill 支援範圍，停止並請使用者更新 Heptabase Desktop App 或 skill。

讀取指定日期：

```bash
heptabase journal read YYYY-MM-DD
```

如果沙盒內無法連線 Heptabase Desktop App local server，依 `heptabase-cli` skill 規則改用外部授權執行，不要直接讀寫 Heptabase 本機資料庫或 app storage。

### 2. 檢查是否有間歇式日記

從 Journal 的 ProseMirror JSON 檢查是否存在「間歇式日記」toggle 或同義區塊。

判斷標準：

- 有「間歇式日記」標題。
- 且下方有具體時間段、事件或活動，例如 `07:00 ~ 07:20 ...`。

如果只有空白段落，視為沒有間歇式日記。

### 3. 決定訪問模式

如果有間歇式日記，先問使用者：

> 我看到這一天有間歇式日記。你要我依照間歇式日記開始訪問，還是使用空白方式從頭訪問？

使用者選擇後再開始訪問。

如果沒有間歇式日記，不再詢問模式，直接使用 Daily Interview Assistant 的 `Empty Start` 流程。

### 4. 訪問規則

沿用 `diary-interview-assistant`：

- 一次只問一題。
- 問完等待使用者回答。
- `Diary Provided`：問 3 到 5 題，問題要具體連到日記中的事件、當時判斷、可能模式。
- `Empty Start`：問 5 題，依序涵蓋事實、驚喜、反思、可控改善、下一步。
- 如果使用者修正理解，下一題要依修正後的脈絡調整。

### 5. 整理輸出

訪問完成後，整理成 3 個反思亮點。

每個亮點至少包含：

- 亮點標題。
- 亮點解釋。
- 寫作延伸點子。
- 下一步小行動。
- 可選：文章草稿提示。

如果寫入 Heptabase 的 `Reflection` toggle，內容可以比完整 Daily Interview Assistant 最終輸出略精簡，以適合日記內閱讀；但不得省略核心洞察與可行動項目。

### 6. 寫入前確認

訪問與整理完成後，必須先問使用者：

> 我已整理好 reflection。是否要寫入 YYYY-MM-DD Journal 的 Daily Log > Reflection 下方？

只有使用者明確同意後才寫入。

如果使用者指定其他位置，例如日記底部、新增段落、Quick Note、或 Heptabase property，依使用者指定處理；若指定的位置不存在，先說明現況並請使用者確認是否建立新區塊或改寫入既有 `Reflection` toggle。

### 7. 寫入 Heptabase

安全寫入原則：

- 寫入前重新讀取該日 Journal，取得最新 `contentMd5`。
- 只更新 Daily Log 裡 `Reflection` toggle 的內容。
- 不改動 `Doing Great`、`Gratitude`、`Sleeping Log`、`Quick Note`、間歇式日記或其他區塊。
- 如果 `Reflection` toggle 原本已有內容，先詢問使用者要覆蓋、追加或取消。
- 使用 `contentMd5` 做衝突檢查。

建議寫入方式：

1. `heptabase journal read YYYY-MM-DD` 取得最新 ProseMirror JSON 與 `contentMd5`。
2. 解析 JSON，找到 Daily Log 下方包含 `Reflection` card 或 `Reflection` 標題的 toggle。
3. 保留 toggle header，只替換或追加其 child content。
4. 使用 `heptabase journal save YYYY-MM-DD --content-file <json-file> --content-md5 <md5>` 寫回。

如果遇到 `Content conflict`：

1. 不要覆蓋。
2. 重新讀取最新 Journal。
3. 把 reflection 重新套入最新版本。
4. 再用新的 `contentMd5` 寫入。

### 8. 完成確認

寫入後必須再次讀取：

```bash
heptabase journal read YYYY-MM-DD
```

確認：

- reflection 內容在 Daily Log 的 `Reflection` 下方。
- 不是被加到 Journal 最底部。
- 其他 Daily Log 區塊仍存在。
- 如果原本有間歇式日記，間歇式日記內容仍保留。

完成後回報使用者：

- 已寫入的日期。
- 寫入位置。
- 反思亮點標題。
- 是否有保留原本日記內容或處理版本衝突。

只有完成寫入與讀回確認後，才算 workflow 完成。

## 不可做的事

- 不可直接修改 Heptabase 本機資料庫、cache、app storage。
- 不可在未詢問使用者的情況下寫入 reflection。
- 不可因為 `Reflection` property 不存在，就自動改寫到 Journal 最底部。
- 不可覆蓋使用者剛新增的間歇式日記或 Daily Log 內容。
- 不可一次問多題，破壞 Daily Interview Assistant 的逐題訪問節奏。
