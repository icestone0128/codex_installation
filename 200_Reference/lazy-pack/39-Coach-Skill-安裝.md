# 39-Coach-Skill-安裝

> 名稱：Coach Skill
>
> 用途：在 Arry 的新電腦上，一次檢查並啟用四個私人全域教練：Life Coach、Voice Coach、Waki Brain、Productivity Coach。
>
> 重要：這是「私人來源橋接型」LazyPack，不是公開自含式課程包。公開 repo 只保存安裝器、驗證器與說明，不保存私人身份、記憶、購課教材或可重建課程 corpus。

## 四個教練

| 顯示名稱 | 實際 Skill ID | 主要用途 |
| --- | --- | --- |
| Life Coach | `future-coach` | 十年後的自己、人生與職場陪伴、情緒承接及小行動 |
| Voice Coach | `voice-coach` | 私人聲音課程診斷、單元推薦與 5～15 分鐘練習 |
| Waki Brain | `waki-brain` | 十三個私人專案包的內容、決策、策略、故事、簡報與查證路由 |
| Productivity Coach | `productivity-coach` | 精力、知識、成果卡點診斷；NotebookLM 為選配 |

`Life Coach` 是本安裝包的顯示名稱；目前實際可觸發的 Skill ID 維持 `future-coach`，不另建重複的第五個路由 Skill。

## 為什麼不把四套內容直接內嵌

- `future-coach` 需要 Arry 助手私人記憶層。
- `voice-coach` 含私人課程筆記、逐字稿與本機音檔路由。
- `waki-brain` 含 Arry 已購買並授權本人使用的十三個專案包。
- `productivity-coach` 含私人 v3.1／V4 課程規則與單元卡。

把上述內容放入 public LazyPack 或 public GitHub 會破壞隱私與內容權利邊界。本項目的正確安裝模型是：

```text
私人雲端 {{SYNC_ROOT}} 同步四個完整 Skill 主版本
→ Coach Skill 安裝器確認來源完整
→ 呼叫 Item 16 chezmoi bootstrap
→ 建立 Codex／Claude／AntiGravity 原生入口
→ 執行四套 Skill smoke test
```

## 前置條件

1. 新電腦已登入 Arry 使用的私人雲端同步帳號。
2. `{{SYNC_ROOT}}` 已完整同步，至少包含：
   - `skills/future-coach`
   - `skills/voice-coach`
   - `skills/waki-brain`
   - `skills/productivity-coach`
   - `skills/cross-device-sync`
   - `memories/MEMORY.md`
3. 已取得本 LazyPack repo，並完成 Item 16 的基本環境準備。
4. 本機有 Python 3；若沒有，先完成 Item 34。
5. 各 Agent 的登入、OAuth、NotebookLM、Chrome session 與其他服務認證仍需每台電腦分別登入，不跟著 Coach Skill 同步。
6. `{{SYNC_ROOT}}` 必須是 Arry 自己控制並信任的私人來源；驗證器會執行四個 Skill 內既有的 smoke-test scripts，不可把網路下載或陌生人提供的資料夾直接當成 `{{SYNC_ROOT}}`。

## 新電腦安裝

先做 dry-run：

```bash
bash "{{SETUP_REPO}}/200_Reference/scripts/coach-skill/install_coach_skill.sh" \
  --sync-root "{{SYNC_ROOT}}" \
  --dry-run
```

確認私人來源完整、Item 16 沒有入口衝突後才套用：

```bash
bash "{{SETUP_REPO}}/200_Reference/scripts/coach-skill/install_coach_skill.sh" \
  --sync-root "{{SYNC_ROOT}}" \
  --apply
```

新電腦尚未安裝 chezmoi 時，可明確授權安裝器交由 Item 16 安裝：

```bash
bash "{{SETUP_REPO}}/200_Reference/scripts/coach-skill/install_coach_skill.sh" \
  --sync-root "{{SYNC_ROOT}}" \
  --apply \
  --install-chezmoi
```

只想檢查現況：

```bash
bash "{{SETUP_REPO}}/200_Reference/scripts/coach-skill/install_coach_skill.sh" \
  --sync-root "{{SYNC_ROOT}}" \
  --verify-only
```

## 安裝器會檢查什麼

- 四個 Skill 的 `SKILL.md` 與 frontmatter 名稱。
- Future Coach 所需的 Arry 助手記憶層。
- Voice Coach 的課程索引、路由、查找工具及至少 65 份課程筆記／總索引。
- Waki Brain 的 catalog、路由器、更新工具及恰好 13 個專案包資料夾。
- Productivity Coach 的 v3.1 引擎、28 張單元卡、NotebookLM 選配流程、validator 與合併來源 freshness。
- `future-coach`、`voice-coach`、`waki-brain`、`productivity-coach` 是否能從三個 Agent 的原生 skills 入口讀取。

安裝器預設不顯示私人來源的完整本機路徑，也不讀取或輸出課程全文。

## 三 Agent 執行方式

### Agent execution notes

- Shared steps：四個 Agent Skill 都以 `{{SYNC_ROOT}}/skills` 為唯一內容主版本；相同安裝器、驗證器、隱私邊界與驗收標準適用於三個 Agent。
- Codex adapter：Item 16 建立 `{{CODEX_HOME}}/skills` 入口；安裝後開新 Codex 對話，再用 `$future-coach`、`$voice-coach`、`$waki-brain` 或 `$productivity-coach` 測試。
- Claude adapter：Item 16 建立 `{{CLAUDE_HOME}}/skills` 入口；重新啟動 Claude Code session 後使用同一組 Skill ID。
- AntiGravity adapter：Item 16 建立 `{{GEMINI_CONFIG}}/skills` 入口；重新啟動 AntiGravity／Gemini session 後使用同一組 Skill ID。
- Fallback：某個 Agent 尚未安裝時，Item 16 仍可先建立 future-ready 入口；先用已安裝的 Agent 完成驗證，日後安裝 Agent 本體並獨立登入。
- Verification：三個原生 skills 入口都必須解析到同一個 `{{SYNC_ROOT}}/skills`，四個 Skill 的 smoke test 必須得到相同 package 狀態。

## 使用邊界

- Coach Skill 只整理安裝與驗證，不合併四個 Skill 的觸發邏輯。
- Life Coach 的實際 Skill ID 是 `future-coach`。
- Productivity Coach 即使未連 NotebookLM 仍可完整運作；NotebookLM 不列為安裝必要條件。
- Voice Coach 的私人音檔連結若因新電腦掛載路徑不同而失效，只影響直接開啟音檔，不影響 Skill 內建課程文字教練；應在私人 `local-paths.md` 修正，不寫入公開 LazyPack。
- Waki Brain 官網、NotebookLM 與其他需要登入的服務，各電腦都必須使用自己的本機認證；不得同步 cookie、OAuth、token 或 session。
- 安裝器不移動、複製或刪除私人 Skill；它只驗證來源並讓 Item 16 管理三個 Agent 的入口。
- `--agents` 只接受 `codex`、`claude`、`antigravity` 白名單；路徑與參數皆以陣列／獨立引數傳遞，不拼接成 shell 指令。

## 驗收

```bash
python3 "{{SETUP_REPO}}/200_Reference/scripts/coach-skill/verify_coach_skill.py" \
  --sync-root "{{SYNC_ROOT}}" \
  --check-entrypoints
```

預期結果：

- 四個 package 與必要來源全部 `PASS`。
- Voice Coach 課程筆記數不少於 65。
- Waki Brain 專案包數為 13。
- Productivity Coach 編號單元卡數為 28，validator 與來源 freshness 通過。
- Codex、Claude、AntiGravity 三個 skills 入口與四個 Skill 可讀性全部 `PASS`。

完成後，開啟新的 Agent 對話再測試自然語意觸發。

## 更新

四個私人 Skill 更新後不需要重建 Agent 入口，因為三個 Agent 都讀同一個 `{{SYNC_ROOT}}/skills` 主版本。只需重新執行：

```bash
bash "{{SETUP_REPO}}/200_Reference/scripts/coach-skill/install_coach_skill.sh" \
  --sync-root "{{SYNC_ROOT}}" \
  --verify-only
```

公開 Item 39 只在安裝流程、檢查條件或 Skill 清單改變時更新，不同步私人課程內容。
