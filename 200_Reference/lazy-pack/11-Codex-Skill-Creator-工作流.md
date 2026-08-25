# 11-Codex-Skill-Creator-工作流

> 2026-05-24 更新：本文件已改為自含式 Skill 安裝文件。請使用文末「內建 Skill 完整安裝內容」，不需要額外的舊版獨立 skills 子目錄。

> 2026-08-01 更新：吸收 Claude Skill Forge 通用模板中可攜的部分，新增「使用者修正優先」對話萃取規則、Claude 相容 frontmatter 嚴格驗證，以及只有明確需要 Claude 上傳時才使用的選配 ZIP 封裝工具；不強制固定四問、`references/`、`examples/` 或每次打包 ZIP。


## 目標

把外部／第三方取向的 Skill Creator 啟動包，改寫為三 Agent 共用的 skill 建立流程，同時支援 Codex、Claude、AntiGravity，並判斷新 skill 應該放在全域還是專案本地。也支援把一段滿意對話、prompt、輸出格式或工作流萃取成可重用的跨 Agent skill。

這份文件是之後建立、優化、驗證三 Agent 共用 skills 的正式懶人包。`codex-skill-creator` 是為了相容舊觸發語意而保留的 skill ID；它的產出必須同時相容 Codex、Claude 與 AntiGravity。

## 前置條件

- 已完成 `README.md` 的設定表。
- 已知道三 Agent 共用 skills 主版本位置：`{{SYNC_ROOT}}/skills`。
- 已知道專案本地 skills 位置：`<project-root>/000_Agent/skills`。
- 已確認系統內建 skills 位置：`{{CODEX_HOME}}/skills/.system`。
- 已知道 Obsidian 全域 skill 索引位置；若沒有，可先建立：

```text
{{OBSIDIAN_PROJECTS}}/{{SETUP_PROJECT_NAME}}/全域 Skills/全域 Skills 同步.md
```

## 固定結論

- 使用環境：Codex、Claude、AntiGravity 固定全部相容。
- 自訂全域 skills 的唯一主版本固定放在 `{{SYNC_ROOT}}/skills`，三 Agent 原生入口由 Item 16 與 chezmoi 管理。
- `{{CODEX_HOME}}/skills/.system` 是 Codex 內建 adapter 資產，平常只讀取；Claude 與 AntiGravity 使用各自原生入口，不複製 `.system`。
- 個人助手或單一專案的本地 skills 固定放在對應的 `000_Agent/skills`，不要 symlink 到全域共用主版本。
- `codex-skill-creator` 是自訂 skill 建立與維護的必要入口；系統內建 creator 只讀，只作輔助參考。
- 共用 `SKILL.md` 必須同時符合 Claude 的嚴格 frontmatter 可攜範圍：非空且合法的 `name`、非空且清楚描述「做什麼＋何時用」的第三人稱 `description`，並拒絕保留字與 XML markup。
- 只有使用者明確需要 Claude Customize／API 上傳成品時才建立 ZIP；ZIP 是衍生發布物，不是第二份 skill 主版本，也不自動上傳。
- 全域 skills 有新增、修改或刪除時，要同步更新 Obsidian 的全域 Skills 索引。
- 任何 skill 不論全域或專案本地，都要做成可攜式版本。

## 歸屬判斷

建立或修改 skill 前，先判斷：

| 問題 | 判斷 |
| --- | --- |
| 會跨多個專案重複使用嗎？ | 是，放全域 `{{SYNC_ROOT}}/skills/<skill-name>` |
| 需要在任何 Codex、Claude 或 AntiGravity 對話都能觸發嗎？ | 是，放全域 |
| 只服務目前專案的資料、流程、工具或客戶脈絡嗎？ | 是，放 `<project-root>/000_Agent/skills/<skill-name>` |
| 含有不適合公開或跨專案複用的專案脈絡嗎？ | 放專案本地 |
| 目前只是流程草稿，尚未穩定複用嗎？ | 先放 `000_Agent/skills`，成熟後再升級全域 |

可攜化規則：

- 全域 skill：實作在 `{{SYNC_ROOT}}/skills/<skill-name>`，同步可攜副本到 `本文件文末內嵌內容：<skill-name>`，並更新 Obsidian 全域 Skills 索引。
- 專案 skill：實作在 `<project-root>/000_Agent/skills/<skill-name>`，該資料夾必須包含完整 `SKILL.md` 與必要資源；若專案使用 Git，跟著專案提交。
- 不把 `000_Agent/skills` symlink 到 `{{SYNC_ROOT}}/skills`。

## 建立三 Agent Skill Creator 必要入口

建議 skill 名稱：

```text
codex-skill-creator
```

建立：

```text
{{SYNC_ROOT}}/skills/codex-skill-creator/SKILL.md
{{SYNC_ROOT}}/skills/codex-skill-creator/agents/openai.yaml
{{SYNC_ROOT}}/skills/codex-skill-creator/references/built-in-quality-practices.md
{{SYNC_ROOT}}/skills/codex-skill-creator/references/codex-bootstrap-adapter.md
{{SYNC_ROOT}}/skills/codex-skill-creator/references/conversation-to-skill.md
{{SYNC_ROOT}}/skills/codex-skill-creator/references/standalone-claude-package.md
{{SYNC_ROOT}}/skills/codex-skill-creator/scripts/package_claude_skill.py
```

用途：

- 把 外部 / 第三方 skill 教學轉成 三 Agent 相容流程。
- 把成功對話、prompt、輸出格式或重複工作流萃取成三 Agent 共用 skill。
- 將使用者中途拒絕、修正、縮限、改名或重排的最新明確要求視為第一級驗收證據。
- 建立、優化、驗證自訂全域或專案本地 skills。
- 需要 Claude 上傳檔時，以同一共用主版本驗證並衍生安全 ZIP，不強制每個 skill 都打包。
- 記得同步可攜式版本；全域 skill 同步 Obsidian 全域 skill 索引，專案 skill 同步專案駕駛艙。
- 顯式呼叫使用 `$codex-skill-creator`；自然語句如「幫我建立 skill」、「把這段對話變成 skill」也必須觸發。
- 沒有結構化選項 UI 時，改用簡短編號選項或一次一題的純文字訪談，不中斷工作流。
- 目標 skill 已存在時，先讀取並判斷是局部修正、完整更新、改名或無需修改；完整替換與改名前先建 timestamped backup 或確認版本控制可回復。
- 建立檔案不算完成；必須用一組代表性輸入實際觸發並驗證輸出。
- 新建 skill 時，優先使用系統內建 `init_skill.py` 建立標準骨架；更新後使用 `quick_validate.py`，並維護 `agents/openai.yaml`。
- 內建 `quick_validate.py` 後再執行 `package_claude_skill.py validate`，補查保留字、資料夾名稱、非空 metadata 與明顯非第三人稱描述。
- 依任務脆弱度選擇高／中／低自由度；`SKILL.md` 採漸進揭露，詳細內容移入直接連結的 `references/`。
- 複雜或高影響 skill 在能力可用時進行無答案洩漏的 forward-test；若測試耗時、需額外核准或會碰觸 live system，先取得使用者同意。

## Skill 養成節奏

- 先建一個最高價值 skill，使用 3–5 次後再根據失敗案例調整 `description`、步驟、範例與邊界。
- 不一次大量建立未驗證 skills。若使用者要儲存候選清單，可寫到 `<project-root>/100_Todo/projects/skill-candidates.md` 或使用者指定位置。
- 候選清單只放優先度、用途與預期觸發頻率；不另建一套 daily memory。
- 長期未觸發或高度重疊的 skill，應移除、合併或縮小範圍。

## 直接安裝本懶人包版本

下載本 repo 後，直接使用本文文末的內建安裝腳本建立 companion skill：

```bash
mkdir -p "{{SYNC_ROOT}}/skills/codex-skill-creator"
# 請使用本文文末「內建 Skill 完整安裝內容」；不需要額外複製舊版獨立 skills 子目錄。
test -f "{{SYNC_ROOT}}/skills/codex-skill-creator/SKILL.md" && echo "codex-skill-creator installed"
```

若下載者沒有使用 Obsidian 全域 skill 索引，安裝後可跳過本文的 Obsidian 同步步驟。

## 來源啟動包轉換規則

| 外部 / 第三方 啟動包項目 | 三 Agent 相容做法 |
| --- | --- |
| 來源工具的全域 skills 路徑 | 需要全域觸發時改用共用主版本 `{{SYNC_ROOT}}/skills`，三 Agent 再各用原生入口讀取 |
| 來源工具的專案級 skills 路徑 專案 skill | 改放該專案 `000_Agent/skills`，只服務該專案 |
| `000_Agent/skills` symlink | 不建立；`000_Agent/skills` 是專案本地 skill 區，不等於全域共用 skills |
| 來源工具 slash command `/skill-name` | 保留可攜式自然語意觸發；若某 Agent 支援原生顯式呼叫，另在 adapter 註記它的呼叫方式 |
| `allowed-tools` | 不寫入共用核心；工具權限依當前 Agent 的 session、plugin／connector／MCP 與 sandbox 控制 |
| `disable-model-invocation` / `user-invocable` | 不寫入；觸發邊界寫在 `description` 與本文規則 |
| `when_to_use` | 轉成 `description` 的觸發語意與本文工作流程 |
| 來源工具 subagent 設定 | 轉成共用的「可否委派、任務邊界、輸出契約」；各 Agent 實際委派命令放 adapter |
| 安裝第三方或改用內建 creator | 不取代 `codex-skill-creator`；其他 creator 內容只作輔助參考 |
| 告知重啟來源工具 | 對本次影響的 Codex、Claude、AntiGravity 分別開新對話或重載 skill 入口 |

## 三 Agent 共用 Skill 標準結構

最小結構：

```text
<skill-name>/
└── SKILL.md
```

需要範例、模板或長規則時：

```text
<skill-name>/
├── SKILL.md
├── agents/
│   └── openai.yaml  # 建議的 Codex UI metadata
├── references/
├── scripts/
└── assets/
```

原則：

- `SKILL.md` 保持精簡，放觸發、路徑、流程與安全規則。
- 長範例、來源轉換表、模板放 `references/`。
- 只有需要穩定重複執行的檢查或轉換，才放 `scripts/`。
- `references/`、`scripts/`、`assets/` 與範例都是按需建立；最低完整結構仍可以只有 `SKILL.md`。
- 新建 skill 優先用 `.system/skill-creator/scripts/init_skill.py`；驗證優先用 `quick_validate.py`。
- 執行 validator 前先確認該 Python 可 `import yaml`；預設 Python 缺 PyYAML 時，改用已有依賴的 interpreter 並回報 fallback，不靜默略過驗證。
- `agents/openai.yaml` 的 `default_prompt` 必須使用真實 `$skill-name`，且重大修改後要重新核對。
- `SKILL.md` 實務上維持在 500 行內，references 直接由 `SKILL.md` 連結，避免多層追索。
- 不額外建立 README、安裝指南、變更紀錄，除非使用者明確要求。

## Frontmatter 範本

```markdown
---
name: skill-name
description: Use when the user asks for [具體任務], [觸發語], or [工作流程]. Include input source, action, and expected output.
metadata:
  short-description: Short user-facing phrase
---
```

檢查規則：

- `name` 必須非空、最多 64 字元、只用小寫英文字母／數字／單一連字號，不能包含 `claude`、`anthropic` 或 XML markup，且必須與資料夾名稱一致。
- `description` 必須非空、最多 1024 字元、不含 XML markup、使用第三人稱，並同時說明 skill 做什麼與何時使用。
- 動名詞名稱只是建議，不是載入條件。
- 不放 來源工具專用 欄位。
- 不寫 API key、token、密碼或個資。

## 選配 Claude ZIP 發布

只有使用者明確要求 Claude Customize／API 上傳 ZIP 時，才讀取：

```text
{{SYNC_ROOT}}/skills/codex-skill-creator/references/standalone-claude-package.md
```

先驗證，再建立本機衍生檔：

```bash
python3 "{{SYNC_ROOT}}/skills/codex-skill-creator/scripts/package_claude_skill.py" \
  validate "<skill-folder>"

python3 "{{SYNC_ROOT}}/skills/codex-skill-creator/scripts/package_claude_skill.py" \
  package "<skill-folder>" --output-dir "<output-directory>" --version 1.0.0
```

工具會拒絕 symlink、`.env`、credentials、private-key 類檔案，排除 cache、venv、`node_modules` 與 Git 資料，並確認 ZIP 最上層是 frontmatter `name` 對應的資料夾。`--timestamp` 與版本檔名是本懶人包的防覆寫慣例，不是 Claude 官方必填規格；未取得額外授權不得自動上傳。

## 建立第一個真實 Skill 的流程

### 1. 訪談

有互動式提問工具就使用；一次只問一題，每題 2～3 個互斥選項，推薦項放第一個。
**整段建立流程最多四個必要追問**，不要一次丟長問卷。已能從對話、檔案或助手記憶得到的答案不要重問。

#### 入口：先確認要建的是不是工作方法

```text
你現在最想讓 AI 學會什麼？

1. 我的長期寫作風格 —— 讓 AI 用你的語氣寫，可持續校準
2. 一套會重複使用的工作方法 —— 判斷、步驟與停止條件
3. 我不確定，先描述問題
```

- 選 1 → 轉交 Item 44 `personal-style-loop`，本流程不處理長期寫作風格。
- 選 3 → 請使用者用**一句話**描述最近卡住的真實工作，再推薦一條請他確認。
  若只是一次性任務，兩條都不走，直接把那件事做完。
- 選 2 → 繼續下面的路線分流。

#### 路線：你想留下誰的工作方法？

```text
這套工作方法主要來自誰？

1. 我自己
2. 身邊高手或團隊
3. 公開專家
```

選 2 時再問一題：「一位具體高手」還是「團隊共同流程」——兩者走不同路線。

| 路線 | 來源 | 要收的素材 | 第二題怎麼選 |
| :-- | :-- | :-- | :-- |
| A. 自己 | 你自己的做法 | 2～3 份有代表性的真實成品；你給過的修改與回饋；**另外保留 1 份不放進建立階段** | 用那份保留成品 |
| B. 身邊高手 | 同事、主管、前輩 | 對方同意提供的訪談或工作說明；成功與失敗案例；檢查表或匿名化紀錄 | 邊界或資料不足案例，再請本人 review |
| C. 團隊 SOP | 正在執行的共同流程 | 口述、舊文件、截圖、執行紀錄、新人常問的問題、上下游文件 | 例外情境，**兩邊都要跑**：讓新人試跑驗證清楚度，讓資深同事檢查例外與判斷 |
| D. 公開專家 | 多個原始公開來源、案例，以及批評與矛盾資料。見下方〈模仿真人的誠實邊界〉 | 三題各測一件事：**已知題**測方向、**未談過的題**測誠實、**爭議邊界題**測會不會過度自信 |

#### 路線 A 的首要篩選：熟練度優先於頻率

第一個 skill 必須來自使用者**已經做得好**的工作。因為校準題要求他一眼認得出輸出對不對；
還在學的領域出不了校準題，那個 skill 只能被欣賞、不能被驗證。

問這五題，一次一題：

1. 最近一週或一個月，哪件事你做了 3 次以上？
2. **哪件事你很會做，但每次都要重新想一次、或很難教別人？**
3. 那件事裡，你固定用哪些工具、看哪些資料、產出什麼？
4. 哪一步 AI 先做 60% 就很有幫助？哪一步一定要你本人拍板？
5. 做錯會有什麼風險？（價格承諾、個資、合約、對外公開）

**第 2 題是關鍵。**「很難教別人」代表存在值得萃取的隱性判斷；容易教的通常只需要一張檢查表。

整理 3～5 個候選攤開比較，不要直接跳到結論：

| 任務 | 你有多熟 | 重複性 | AI 可先做哪一段 | 風險 | 適合當第一個嗎 |
| :-- | :-- | :-- | :-- | :-- | :-- |

#### 不該硬做成 Skill 的情況

符合任一項就不要硬推：

- **一次性**：未來不太會重複，skill 賺不回它的成本。
- **高風險無專業覆核**：法律、醫療、財務、安全，且沒有合格的人在迴圈裡。
- **具約束力的承諾**：承諾價格、合約條款、付款或人事決策。
- **無法驗收**：沒有人說得出「做得好」長什麼樣，就寫不出驗收標準，也出不了校準題。
- **素材不安全**：機密或個資無法在這個流程裡安全處理。

改提供成本更低的東西，依序是：檢查表 → prompt 範本 → 書面 SOP → 只做 AI 輔助草稿、判斷仍由使用者做。
**明說是哪一條踩到了**，不要照做然後附一句警語。

接著推薦**一個**任務，說明為什麼它不會太大、不危險、也不是一次性。

#### 使用者講不清楚自己怎麼做時

放慢，改用**回溯上一個真實案例**：那件事怎麼進來的、你先看什麼、你決定了什麼、你交出什麼。
問「你的 SOP 是什麼」只會得到一個理想化、跟實際做法不符的答案。

拆解環節時逐項確認（已知的不要重問）：啟動與不該啟動的時機、必要輸入、固定步驟與判斷規則（含例外）、
用到的工具檔案範本、輸出格式與驗收方式、必須停下來問人的紅線、
**隱私與去識別化**（哪些要移除、遮蔽，或根本不能離開這台機器）。

#### 再問最多四題

1. **真實工作**：希望它反覆幫你完成哪一類工作？
2. **成果與驗收**：完成後交付什麼？你怎麼判斷做得好？
3. **參考資料**：目前有哪些作品、文件、案例或公開來源？
4. **邊界**：什麼情況不能做、資料不足要問誰、有哪些敏感內容？

原則：

- 萃取的是選擇、判斷、順序與品質標準，不是語氣形容詞。
- 路線 B、C 先確認同意、權限與機密邊界；路線 C 先查有沒有同名或衝突版本。
- **要拿到素材本身**。只知道「有哪些資料」不夠；素材到手前不要進入萃取，也不要展開長訪談。
- 素材含公司機密、客戶個資、未公開價格或合約條款時，**先匿名化再萃取**；醫療、法律、投資內容保留人工確認。skill 的素材會被反覆讀取，一次疏漏會長期存在。
- 使用者說「不確定」時，先請他描述最近一次卡住的工作。**如果做一次性任務就能解決，就直接做**，不要為了產出 Skill 而硬做 Skill。

### 模仿真人的誠實邊界

只要 skill 會編碼某個真人的判斷、語氣或人格（路線 D，以及會脫離當事人參與的路線 B），下列是硬性防線，不是風格建議：

- 先縮小到**一個工作領域**，不要做完整人格。
- 至少使用兩種不同場景的公開來源，優先本人長文、演講、訪談、決策與作品案例。
- **刻意納入**矛盾、限制或批評資料；只收正面內容會編出一個漫畫化的版本。
- 在 skill 內記錄來源與調研截止時間。
- 只保存轉化後的摘要、規則與來源索引，不重新打包大量原始內容。
- 沒有明確證據前，**不得聲稱**本人授權、合作、背書或審閱過。
- **不假扮本人**，不把推測寫成直接引言。
- 專家沒談過的問題，標註「以下是根據公開框架的推論」。
- 醫療、法律、投資等高風險領域，保留專業覆核並寫進 skill 的停止條件。
- 聲音與肖像另有同意要求；skill 涉及任一項時，先看全域規則關於聲音克隆的規定。

### 2. 收斂成一個推薦 skill

輸出：

- 最推薦的一個 skill。
- 兩個備選。
- 為什麼這個最適合先做。

若使用者同意，直接建立，不停在建議。

### 3. 產出 Skill brief 並取得確認

建檔前先寫出 brief、給使用者確認。**兩題測試要在這裡就設計好**——在 skill 還不存在的時候決定，
才不會變成照著 skill 實際產出的東西回頭補測試。

```markdown
# Skill brief：<名稱>

## 這個 Skill 解決什麼問題
## 何時啟動
## 不該啟動的情境
## 必要輸入
## 工作流程與判斷規則
## 參考資料／工具
## 停止條件（必須問人）
## 輸出格式
## 驗收標準
## 建議的校準題（已知結果）
## 建議的保留／邊界題
```

最後兩段直接餵給步驟 6 的雙測試。這裡指定的保留題必須在步驟 4 萃取開始前就抽起來，
建立過程中不得讓 skill 看到。

brief 副本可存 `<project-root>/100_Todo/projects/skill-candidates.md` 或使用者同意的位置；
不要為它另建一套平行資料夾。

### 4. 先跑沒有 Skill 的 baseline

**建立 skill 前**，拿一個真實任務讓目前的 AI 在**沒有載入任何 skill** 的情況下做一次。記錄：

- 哪裡本來就做對了。
- 哪裡太通用、判斷錯誤、漏掉邊界，或輸出不能用。
- 上述哪一點是使用者真正在意的。

然後**只針對觀察到的落差寫規則**。baseline 已經做好的地方寫進去就是 no-op：占 context 又不改變行為。這比「先寫完再刪」便宜，因為那一行從來不會被寫出來。

**保留樣本要在本步驟開始前就先留起來**（由步驟 3 的 brief 指定）。路線 A 是先抽掉一份真實成品不給 AI 看；其他路線是事先講好哪個案例要留。事後才選的保留題不算保留題。

### 5. 建立檔案

建立：

```text
{{SYNC_ROOT}}/skills/<skill-name>/SKILL.md
<project-root>/000_Agent/skills/<skill-name>/SKILL.md
```

視需要加：

```text
{{SYNC_ROOT}}/skills/<skill-name>/references/<reference>.md
<project-root>/000_Agent/skills/<skill-name>/references/<reference>.md
```

二選一建立，不要同時建立兩份正式來源；除非是把專案 skill 升級成全域 skill，才複製到全域 skills 並同步 LazyPack。

### 6. 驗證

必查：

- `SKILL.md` 存在。
- frontmatter 有 `---`、`name`、`description`。
- `name` 等於資料夾名稱。
- `description` 有具體觸發語。
- `references/` 內被引用的檔案真的存在。
- 使用者在原對話中的最新可重用修正已轉成驗收條件、邊界或步驟順序，而不是遺失在聊天紀錄中。
- 沒有誤放 來源工具專用 欄位或路徑。
- `SKILL.md` 寫明**不適用情境**、**停止條件**與**驗收標準**這三段（最常被略過、也最常事後才發現缺）。
- 新 skill 的 frontmatter 有 `version: 0.1.0` 與 `last-updated`。

**兩題測試（缺一不可）**：

1. **校準題**：用已知正確結果的案例，確認 skill 能重現關鍵判斷。
2. **保留／未知／邊界題**：用步驟 3 的 brief 指定、且在步驟 4 之前就抽起來的那一份（挑選方式見步驟 1 的路線表），確認 skill 是會推理而不是背答案。

兩題都要跟 baseline 比。**若沒有變好**：找出一個最明確的落差 → 只補能解決它的規則 → 用同一題再測一次。不要因為一題失敗就塞進一整套新框架。

回報時要列出兩題結果，以及因為測試而修改了哪些規則。**測試沒有真的跑，就不能說完成**，要明確標示還缺哪一步。

初版固定是 `0.1.0`。之後每次遇到真實失敗，只修一個最大的落差再測，不要一次重寫。

範例檢查：

```bash
find "{{SYNC_ROOT}}/skills/<skill-name>" -maxdepth 2 -type f -print
sed -n '1,20p' "{{SYNC_ROOT}}/skills/<skill-name>/SKILL.md"
python3 "{{SYNC_ROOT}}/skills/codex-skill-creator/scripts/package_claude_skill.py" validate "{{SYNC_ROOT}}/skills/<skill-name>"
```

### 7. 同步

每次全域 skill 變更後，更新：

```text
{{OBSIDIAN_PROJECTS}}/{{SETUP_PROJECT_NAME}}/全域 Skills/全域 Skills 同步.md
```

至少更新三處：

- 自訂全域 Skills 表格。
- Skill 摘要段落。
- 最近同步紀錄。

若下載者沒有使用 Obsidian，也至少在 `{{SETUP_REPO}}/README.md` 或專案駕駛艙記錄 skill 清單。

每次專案 skill 變更後，更新該專案：

```text
<project-root>/000_Agent/skills/<skill-name>/
{{OBSIDIAN_PROJECTS}}/<project-name>/專案工作流程.md
```

至少記錄 skill 名稱、用途、實際路徑、可攜式資源是否完整。

## 本懶人包內含範例

本懶人包已附：

```text
{{SYNC_ROOT}}/skills/codex-skill-creator/SKILL.md
{{SYNC_ROOT}}/skills/codex-skill-creator/references/codex-bootstrap-adapter.md
{{SYNC_ROOT}}/skills/codex-skill-creator/references/conversation-to-skill.md
{{SYNC_ROOT}}/skills/codex-skill-creator/references/standalone-claude-package.md
{{SYNC_ROOT}}/skills/codex-skill-creator/scripts/package_claude_skill.py
{{SYNC_ROOT}}/skills/secondbrain-research-digest/SKILL.md
{{SYNC_ROOT}}/skills/secondbrain-research-digest/references/research-note-template.md
```

下載者應使用自己的 `{{CODEX_HOME}}` 與自己的 skill 名稱。

## 驗證

完成 skill 建立或更新後：

1. 檢查 skill 檔案：

```bash
find "{{SYNC_ROOT}}/skills/<skill-name>" -maxdepth 2 -type f -print
```

2. 檢查 frontmatter：

```bash
sed -n '1,20p' "{{SYNC_ROOT}}/skills/<skill-name>/SKILL.md"
```

3. 確認：
   - `name` 等於資料夾名。
   - `description` 有明確觸發情境。
   - 引用的 `references/` 檔案存在。
   - 沒有 來源工具的 skills 路徑、`allowed-tools`、`disable-model-invocation`、`user-invocable` 等 來源工具專用 正式設定。
   - `agents/openai.yaml` 與 `SKILL.md` 一致，且已執行系統內建 `quick_validate.py`（若可用）。
   - 新增 scripts 已實際執行；複雜 skill 已做獨立 forward-test，或記錄無法執行的原因與 fallback。
4. 分別用 Codex、Claude、AntiGravity 的原生入口重載 skill，並用同一組自然語言任務做最小驗證。
5. 確認可攜式版本完整：全域 skill 同步 `本文件文末內嵌內容：<skill-name>`；專案 skill 保留在 `<project-root>/000_Agent/skills/<skill-name>`。
6. 同步 Obsidian 全域 Skills 索引、專案駕駛艙或專案 README。

## 踩坑修正

- 原始 `02-skill-creator-bootstrap.md` 是 來源工具 啟動包，不能原樣執行。
- 不要把第三方 `skill-creator` sparse checkout 到任一 Agent 的內建系統目錄；共用主版本固定放 `{{SYNC_ROOT}}/skills`。
- 不要覆蓋 `{{CODEX_HOME}}/skills/.system/skill-creator`，因為它是 Codex 自己管理的 adapter 資產。
- 全域 skills 不放在來源工具的專屬路徑；專案級 skills 放 `<project-root>/000_Agent/skills`，但不建立到全域主版本的 symlink。
- 共用核心不依賴單一 Agent 的 slash command；要靠 `description` 寫清楚自然語意觸發，再為各 Agent 記錄可選顯式呼叫 adapter。
- 來源工具專用 frontmatter 欄位要轉成三 Agent 都能理解的共用文字規則；原生 metadata 只放對應 adapter。
- 新增 skill 後不代表現有對話立即可見；通常要對三 Agent 各自開新對話或重載原生入口。
- Obsidian 同步紀錄要放在「最近同步紀錄」表格，不要誤插到自訂 skills 表格。
- Markdown 範本內若有巢狀 code fence，外層要用 `~~~markdown`，避免 YAML 範例提早結束區塊。
- 候選清單若寫進 repo 內，會出現在 git 未追蹤狀態；收工時要明確決定是否納入版本控制。

## 之後怎麼用

當使用者要求「建立 skill」、「優化 skill」、「把來源 skill 教學轉成三 Agent 共用版」、「把剛剛這段對話變成 skill」、「從對話萃取 Skill」、「跑 Skill Creator 啟動包」時：

1. 先套用本文件的三 Agent 共用契約與 adapter 規則。
2. 使用 `codex-skill-creator` companion skill。
3. 若是從對話萃取 skill，先確認要固化的片段、skill 名稱、是否保留優化過程與觸發/輸出格式。
4. 先把使用者在對話中的最新修正整理成可重用驗收條件；已知資訊不重問。
5. 若是第一個真實工作 skill，先做簡短訪談。
6. 判斷 skill 歸屬，建立或更新 `{{SYNC_ROOT}}/skills/<skill-name>` 或 `<project-root>/000_Agent/skills/<skill-name>`。
7. 驗證 frontmatter、路徑與 reference，並執行共用可攜 validator。
8. 若系統 helper 可用，執行 `init_skill.py`／`generate_openai_yaml.py`／`quick_validate.py` 對應步驟，並視複雜度做 forward-test。
9. 使用者明確要 Claude ZIP 時才建立本機衍生 archive；不自動上傳。
10. 同步可攜式版本：全域同步 LazyPack 與 Obsidian 全域 Skills；專案同步專案 `000_Agent/skills` 與專案駕駛艙。
11. 回報 Codex、Claude、AntiGravity 各自的安裝入口、重載方式、實際驗證與 fallback。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊。這個序號項目會安裝：`codex-skill-creator`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請依 README 設定 `{{SYNC_ROOT}}`；package 只寫入共用主版本，Item 16 與 chezmoi 會建立 Codex、Claude、AntiGravity 的原生入口。

````bash
set -e

# ---- codex-skill-creator ----
mkdir -p "{{SYNC_ROOT}}/skills/codex-skill-creator"
# codex-skill-creator/SKILL.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/codex-skill-creator/SKILL.md")"
cat > "{{SYNC_ROOT}}/skills/codex-skill-creator/SKILL.md" <<'AGENT_LAZYPACK_CODEX_SKILL_CREATOR_SKILL_MD_0E95F5A366'
---
name: codex-skill-creator
description: Builds, extracts, adapts, improves, validates, renames, and synchronizes custom Agent Skills shared by Codex, Claude, and AntiGravity. Use when creating or maintaining global or project-local skills, adapting third-party guides, or turning successful conversations into reusable cross-agent packages.
metadata:
  short-description: Build cross-agent skills
---

# Cross-Agent Skill Creator (`codex-skill-creator`)

Use this skill as Arry's required entry workflow for creating and maintaining custom skills shared by Codex, Claude, and AntiGravity. The installed ID remains `codex-skill-creator` for trigger compatibility. Codex's built-in `skill-creator` is one read-only supporting adapter; it does not replace this workflow or its ownership, portability, and multi-surface sync rules.

## Invocation And Interview Rules

- Explicit invocation: `$codex-skill-creator`.
- Natural-language triggers such as "幫我建立 skill", "把這段對話變成 skill", or "更新這個 skill" must also use this workflow.
- Ask only the questions needed to determine scope, ownership, inputs, output, and boundaries. Cap the whole creation flow at four essential follow-up questions; ask one at a time with two or three mutually exclusive options, and never issue a long questionnaire. Anything already answered by the conversation, the files, or the assistant memory is not a question.
- When a structured question UI is available, use it. Otherwise present concise numbered choices or ask one short plain-text question at a time; do not stop merely because an interactive picker is unavailable.
- If the user asks to judge first, audit and report before writing. If the user asks to implement, carry the work through skill update, portable copy, mirror note, and verification.
- If the target skill already exists, inspect it first and state whether the task is a narrow patch, full refresh, rename, or no-op. For a full replacement or rename, make a timestamped backup or use version control before replacing files; for a narrow patch, preserve unrelated content.

## Default Paths

- Custom global skill source: `{{SYNC_ROOT}}/skills`.
- Native entrypoints: Codex `{{CODEX_HOME}}/skills`, Claude `{{CLAUDE_HOME}}/skills`, and AntiGravity `{{GEMINI_CONFIG}}/skills`; chezmoi points all three to `{{SYNC_ROOT}}/skills`.
- Project-local skills: `<project-root>/000_Agent/skills`.
- Global portable copy root: `{{SETUP_REPO}}/200_Reference/lazy-pack/<對應序號文件>`.
- Codex built-in system skills: `$CODEX_HOME/skills/.system` (a read-only initializer/validator adapter, not the shared source).
- Optional skill mirror note: ask the user for their Obsidian or project inventory path when no local mirror is already documented.
- This user's current mirror note: `{{OBSIDIAN_PROJECTS}}/{{SETUP_PROJECT_NAME}}/全域 Skills/全域 Skills 同步.md`.
- This user's current project root: `{{SETUP_REPO}}`.
- This user's current Obsidian vault: `{{OBSIDIAN_VAULT}}`.

## Portability Rules

1. Treat absolute personal paths as local defaults, not universal requirements.
2. When adapting this skill package for another user, replace `ASSISTANT_NAME`, `ASSISTANT_ROOT`, `OBSIDIAN_VAULT`, `PROJECT_LIBRARY`, and `WORK_ROOT` before depending on personal-workflow skills.
3. Keep general-purpose skills independent from personal memory or vault paths unless the user explicitly wants them connected.
4. If a mirror note does not exist, create one only after the user confirms where their durable skill inventory should live.
5. Every skill must have a portable package: global skills mirror to `{{SETUP_REPO}}/200_Reference/lazy-pack/<對應序號文件>`; project skills live as complete packages under `<project-root>/000_Agent/skills/<skill-name>`.

## Compatibility Rules

1. Keep one shared package under `{{SYNC_ROOT}}/skills` or the project `000_Agent/skills`; native Agent paths are adapters, not additional sources.
2. Do not overwrite `{{CODEX_HOME}}/skills/.system/skill-creator` or route the user around `codex-skill-creator`; built-in material may be consulted only as supporting guidance.
3. Use shared frontmatter with `name`, `description`, and optional `metadata.short-description`; keep vendor-specific metadata in a native adapter file.
4. Keep shared frontmatter inside the strict portable envelope required by Claude as one consumer of the package: `name` is non-empty, at most 64 characters, lowercase letters/digits/hyphens only, contains neither `claude` nor `anthropic`, contains no XML markup, and matches the folder name. `description` is non-empty, at most 1024 characters, contains no XML markup, uses third-person phrasing, and states both what the skill does and when to use it. Gerund naming is a recommendation, not a requirement.
5. Convert fields such as `allowed-tools`, `disable-model-invocation`, `user-invocable`, `when_to_use`, or subagent config into portable trigger, permission, and workflow instructions unless all three agents support the field identically.
6. Do not assume one invocation syntax. Put the durable trigger intent in metadata and document native invocation differences only when they matter.
7. Keep `SKILL.md` concise. Move detailed examples, source adaptations, schemas, and checklists into `references/`.
8. After adding, changing, or deleting a custom global skill, update the LazyPack portable copy and Obsidian global skill mirror note.
9. After adding, changing, or deleting a project-local skill, keep the complete portable package under the project `000_Agent/skills` and update the project cockpit.
10. Do not create alternative content roots. Global source work stays under `{{SYNC_ROOT}}/skills`; project-local work stays under `<project-root>/000_Agent/skills`.
11. Any Agent-specific connector, MCP, image tool, sandbox, model, UI, or command step must include `Shared steps`, `Codex adapter`, `Claude adapter`, `AntiGravity adapter`, `Fallback`, and `Verification` notes. Read `../cross-device-sync/references/agent-execution-compatibility.md` for the contract.

## Ownership Decision

Before deciding where a skill belongs, decide whether it should exist. Do not build one for work
that is one-off, that commits prices, contract terms, payment, or personnel decisions, that is
high-stakes (legal, medical, financial, safety) without a qualified human in the loop, that no one
can state a good result for, or that depends on confidential material this workflow cannot handle
safely. Name the disqualifier and offer the smaller thing instead — a checklist, a prompt template,
a written SOP, or an AI-assisted draft the user still judges. Do not build it anyway with a warning
attached. `references/first-skill-consultation.md` has the full criteria and the fallback ladder.

Then decide where it belongs:

- Global: reusable across projects, should trigger from any of the three agents, or is part of Arry's standard workflow. Store in `{{SYNC_ROOT}}/skills/<skill-name>` and sync native entrypoints plus `{{SETUP_REPO}}/200_Reference/lazy-pack/<對應序號文件>`.
- Project-local: only useful for the current project, depends on project-specific context, or is still a local draft. Store in `<project-root>/000_Agent/skills/<skill-name>`.
- Arry assistant remains a global entry skill. Use it during project initialization to read the assistant data layer and help decide whether future skills are global or project-local.

Do not symlink `000_Agent/skills` into `{{SYNC_ROOT}}/skills`.

## Mode Selection

Choose the branch before writing files:

- Source-adapter mode: external or third-party skill material needs conversion into shared instructions and three native adapters. Read `references/codex-bootstrap-adapter.md`.
- Conversation-extraction mode: the user wants to turn a successful conversation, prompt, output style, debugging pattern, or repeated workflow into a reusable skill. Read `references/conversation-to-skill.md`.
- Direct-maintenance mode: an existing shared skill needs a small improvement, validation, or sync repair. Read the target skill and patch only the needed sections.
- First-skill interview mode: the user wants help finding a practical first skill. Use the short interview below.
- Standalone Claude ZIP output: the user explicitly needs a local archive for Claude Customize upload or another Claude distribution surface. Read `references/standalone-claude-package.md`; do not make ZIP creation or upload the default for shared skills.

For field-by-field conversion details, read `references/codex-bootstrap-adapter.md` when the source material is 來源工具導向 or third-party-specific.

Before creating or substantially redesigning a skill, read `references/built-in-quality-practices.md`. It integrates the quality controls from Codex's built-in `skill-creator` while keeping this skill as the single user-facing entry workflow.

For methodology on invocation load, information hierarchy, progressive
disclosure, completion criteria, and pruning, consult `$writing-great-skills`.
Treat it as design reference only; this skill remains the required creation,
adaptation, packaging, and validation workflow.

## Method Source Routing

`Mode Selection` decides **what kind of source material** you are converting. This section decides
**whose working method** you are capturing. They are independent: a conversation-extraction job can
capture the user's own method, and a source-adapter job can capture a public expert's. Settle both
before collecting material, because the route changes what counts as sufficient evidence, what
consent is required, and how the second test is designed.

Before the route, confirm the user wants a work method at all. Ask one at a time, two or three
mutually exclusive options each, every option carrying a plain-language consequence:

```text
你現在最想讓 AI 學會什麼？

1. 我的長期寫作風格 —— 讓 AI 用你的語氣寫，可持續校準
2. 一套會重複使用的工作方法 —— 判斷、步驟與停止條件
3. 我不確定，先描述問題
```

Answer 1 routes to `$personal-style-loop` and stops here. Answer 3 asks the user to describe the
last time this work got stuck **in one sentence**, then recommends one branch for them to confirm;
if a one-off task would settle it, do the task and build nothing. Answer 2 continues below.

Then ask: *whose way of working should this skill preserve?*

```text
這套工作方法主要來自誰？

1. 我自己
2. 身邊高手或團隊
3. 公開專家
```

Answer 2 needs one more question: 「一位具體高手」or「團隊共同流程」— they take different routes.

| Route | Source | Material to collect | Second test (see `Baseline And Harness`) |
| :-- | :-- | :-- | :-- |
| A. The user | Their own practice | 2-3 representative real deliverables; past corrections and feedback they have given; **one held-back deliverable** | The held-back deliverable |
| B. A colleague | A peer, manager, or mentor | Interview or work notes they agreed to share; both success and failure cases; checklists or anonymised transcripts | An edge or insufficient-data case, then have that person review |
| C. Team SOP | A shared live process | Verbal walkthroughs, old documents, screenshots, execution records, questions newcomers keep asking, upstream/downstream docs | An exception case. Run it **both ways**: a newcomer dry run for clarity, and a senior colleague checking the exceptions and judgement calls |
| D. A public figure | Multiple primary public sources, cases, plus critical and contradicting material. See the ethics section below | Three tests, each checking something different: a **known** question tests direction, an **unaddressed** question tests honesty, and a **contested edge** question tests whether it stays appropriately uncertain instead of overconfident |

Route rules:

- Extract choices, judgement, ordering, and quality bars, not adjectives about tone.
- For routes B and C, confirm consent, permissions, and confidentiality before collecting anything. Check for an existing or conflicting version of the same SOP first.
- Ask for the actual material. Knowing that material exists is not the same as having it; do not start extraction or open a long interview before it is in hand.
- Anonymise before extraction whenever the material carries company confidential information, client personal data, unpublished pricing, or contract terms, and keep a human confirmation step for medical, legal, or financial content. A skill's material gets read repeatedly, so one lapse persists.
- If the user is unsure which route applies, have them describe the last time this work got stuck. If a one-off task would solve it, do the task. Do not manufacture a skill to justify the workflow.
- Long-term personal writing voice is out of scope for this skill; route it to `$personal-style-loop`, which calibrates against the user's real samples with held-back reference versions.

## Ethical Boundaries For Modelling A Person

These apply whenever a skill encodes a real person's judgement, voice, or persona, which in practice
means route D and any route B skill that will outlive the colleague's involvement. They are hard
guardrails, not style preferences.

- Narrow the scope to one working domain before starting. Do not build a whole personality.
- Use at least two different kinds of public source, preferring the person's own long-form writing, talks, interviews, documented decisions, and case studies.
- Deliberately include contradicting, limiting, or critical material. A skill built only from favourable sources encodes a caricature.
- Record the sources and the research cut-off date in the skill.
- Store transformed summaries, rules, and a source index. Do not repackage large volumes of the original material.
- Never claim authorisation, endorsement, partnership, or review by the person without documented evidence of it.
- Never impersonate the person, and never present an inference as a direct quotation.
- Mark anything the person has not addressed as an inference drawn from their public framework.
- For medical, legal, financial, or other high-stakes domains, keep professional review in the loop and say so in the skill's stopping conditions.
- Voice and likeness carry their own consent requirements; see the global rules on voice cloning before a skill touches either.

## Design Quality Rules

- Start from concrete trigger examples and expected outputs. Skip discovery only when existing usage already makes them unambiguous.
- Choose the appropriate degree of freedom:
  - high freedom for judgment-heavy guidance with several valid approaches
  - medium freedom for preferred patterns with controlled variation
  - low freedom for fragile, repetitive, or safety-critical operations that need deterministic scripts
- Use progressive disclosure: metadata is always visible, `SKILL.md` is loaded on trigger, and detailed references are loaded only when needed.
- Keep `SKILL.md` under 500 lines when practical. Move schemas, long examples, provider variants, and deep checklists into directly linked `references/` files; avoid reference chains deeper than one level.
- Give `SKILL.md` a body the user can audit. Unless the skill's shape genuinely demands otherwise, cover: when to use it, when **not** to use it, required inputs, judgement and workflow, output format, stopping conditions, and acceptance criteria. The three most often skipped, and most often missed later, are **when not to use it**, **stopping conditions**, and **acceptance criteria**.
- Version a new skill at `0.1.0` and record `last-updated`, both **inside `metadata:`**. The built-in validator only accepts `name`, `description`, `license`, `allowed-tools`, and `metadata` at the top level, so a top-level `version`, `last-updated`, or `user-invocable` fails validation. Treat the first release as provisional: on each real-world failure, fix the single largest gap and re-test it, rather than bolting on a new framework.
- Do not add auxiliary `README.md`, installation guides, changelogs, or placeholder resource files unless they are required by the skill's actual operation or explicitly requested.
- Create only the resource directories the skill needs. Repeated deterministic work belongs in `scripts/`; domain guidance belongs in `references/`; output templates and media belong in `assets/`.
- Treat `agents/openai.yaml` as a Codex UI adapter, not a package compatibility boundary. Keep it aligned with `SKILL.md`, quote string values, and make `default_prompt` explicitly mention `$<skill-name>`.

## Baseline And Harness

A skill is only worth its context cost if it changes behaviour. Prove that with a measurement before
you write and two tests after. This loop runs for every route in `Method Source Routing`.

### Before writing: run the baseline

Take one real task the skill is meant to handle and let the current agent do it with **no skill
loaded**. Record where it was already right, where it was too generic, misjudged, missed a boundary,
or produced something unusable, and which of those the user actually cares about.

Then write rules only for the observed gaps. Anything the baseline already did well is a no-op: it
costs context and changes nothing. This is cheaper than writing first and pruning later, because the
line never gets written. Pruning (`$writing-great-skills`) still applies to whatever survives.

Reserve the holdout **before** extraction starts. On route A that means setting aside one real
deliverable the skill is not allowed to see; on the other routes it means agreeing up front which
case is being kept back. A holdout chosen after the fact is not a holdout.

### After writing: run both tests

1. **Calibration** — a case whose correct outcome is already known. Confirms the skill reproduces the key judgement.
2. **Holdout, unknown, or edge** — chosen by route (see the routing table). Confirms the skill generalises instead of memorising the material it was built from.

Compare both against the baseline. If the skill is not better:

1. Name the single clearest gap.
2. Add only what closes that gap.
3. Re-run the same test.

Do not add a whole new framework because one case failed. Report both test results and the rules
they caused you to change; a skill whose tests were never run is not finished, and must be reported
as unfinished rather than complete.

## Workflow

1. Identify the target:
   - New global skill: create `{{SYNC_ROOT}}/skills/<skill-name>/SKILL.md`.
   - New project skill: create `<project-root>/000_Agent/skills/<skill-name>/SKILL.md`.
   - Existing custom skill: read the current skill first, then patch only the needed sections.
   - Built-in system skill: do not patch; create a companion custom skill or a reference note.
   - Confirm that this request is being handled through `codex-skill-creator`; do not hand custom-skill ownership to the built-in creator.
   - For a new skill, normalize the name to lowercase hyphen-case, keep it at 64 characters or fewer, reject the reserved words `claude` and `anthropic`, and use the built-in initializer when available:
     `python3 "${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-creator/scripts/init_skill.py" <skill-name> --path <parent> [--resources ...] --interface ...`.
   - If the built-in initializer is unavailable, create the same minimal structure manually and record that fallback in the result.
2. Settle the method source route and run the baseline before extracting anything. See `Method Source Routing` and `Baseline And Harness`; reserve the holdout at this point, not later.
3. Extract the useful workflow from the source material:
   - trigger scenarios
   - repeatable steps
   - validation checks
   - resource layout
   - user-facing interview questions
   - failure handling
   - privacy or project-context boundaries
4. Convert to the shared three-agent contract:
   - replace source-specific content roots with `{{SYNC_ROOT}}/skills` or project `000_Agent/skills`
   - preserve trigger intent in metadata and document native invocation only when it differs
   - keep shared task logic together and move only real runtime differences into the three adapter notes
   - preserve a common CLI/script route whenever native tools differ
5. Write the skill package:
   - `SKILL.md` for compact operating instructions
   - `references/` for detailed adapted source notes
   - `scripts/` only when deterministic checks are genuinely useful
   - `assets/` only when files are used in final outputs
   - `agents/openai.yaml` as optional Codex UI metadata; Claude and AntiGravity continue to use the shared `SKILL.md` plus their native discovery behavior
   - if replacing an existing package, preserve or back up the previous package before the replacement
6. Validate:
   - `SKILL.md` exists
   - frontmatter starts and ends with `---`
   - `name` matches the folder name
   - `description` clearly names the triggering tasks
   - referenced files actually exist
   - no source-only path or field controls shared behavior unless it is isolated and labeled as a native adapter
   - personal paths are either replaced with portable placeholders or clearly labeled as this user's local defaults
   - no unresolved placeholders remain in active instructions unless they are intentionally part of a portable template
   - run the built-in validator when available:
     `python3 "${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-creator/scripts/quick_validate.py" <skill-folder>`
   - before running it, confirm the selected interpreter can `import yaml`; if the default `python3` cannot, use another available interpreter with PyYAML and report the fallback rather than silently skipping validation
   - run the shared portable-envelope validator, which supplements the built-in check with reserved-name, folder-match, non-empty metadata, and obvious first-/second-person description checks:
     `python3 "{{SYNC_ROOT}}/skills/codex-skill-creator/scripts/package_claude_skill.py" validate <skill-folder>`
   - test every added script directly; for several similar scripts, test a representative sample
   - verify `agents/openai.yaml` still matches the skill name, purpose, and real Codex invocation without changing Claude or AntiGravity behavior
   - run `cross-device-sync/scripts/audit-agent-compatibility.py` on the changed package and portable documentation
7. Package a standalone Claude ZIP only when explicitly requested:
   - follow `references/standalone-claude-package.md`
   - validate before packaging and inspect the archive after creation
   - keep the shared source package authoritative; the ZIP is a derived distribution artifact
   - do not upload it or change a Claude account without separate authorization
8. Sync portable copies and indexes:
   - Global skill: sync `{{SETUP_REPO}}/200_Reference/lazy-pack/<對應序號文件>` and the Obsidian global skill mirror note.
   - Project skill: keep the complete portable package under `<project-root>/000_Agent/skills/<skill-name>` and update the project cockpit.
9. Sync the Obsidian mirror note when the skill is global:
   - add or update the custom skill table row
   - add or update the skill summary section
   - append a dated sync record
10. Report the result with exact paths, ownership level, portable-copy status, all three native entrypoints, and per-agent restart/fresh-session requirements.
11. Test discoverability with the real skill name: use `$<skill-name>` when explicit invocation is useful, or a natural-language trigger covered by the skill description.
12. Run the calibration test and the holdout/unknown/edge test from `Baseline And Harness`, compare both against the baseline, and fold the resulting fixes back into the skill. One trigger-and-output check alone does not finish the workflow; files written without executed tests must be reported as unfinished.
13. Forward-test complex or high-impact skills with a fresh independent agent when that capability is available. Give it the raw skill and a realistic user request, not the intended answer or suspected defect. Ask the user first if the test may take substantial time, require extra approvals, or touch live systems. If independent agents are unavailable, document the local realistic trial as the fallback.

## Interview Pattern For A First Skill

When the user wants help choosing their first skill, screen on **fluency first, frequency second**.
The strongest signal is work they do well but still rethink from scratch each time, or find hard to
teach someone else: that is tacit judgement worth capturing. Work they are still learning cannot be
tested, because the calibration case requires them to recognise a correct output on sight.

For anything beyond a quick pick — a user who cannot yet articulate how they work, several
candidates to compare, or a task whose risk profile is unclear — read
`references/first-skill-consultation.md` and run the coached flow. It covers the discovery
questions, the candidate comparison table, the disqualifiers and their fallbacks, the step
breakdown including privacy and de-identification, the last-real-case technique for users who
cannot describe their own process, and the brief template.

The brief is confirmed before any file is written, and it names both tests from
`Baseline And Harness` up front. Designing the calibration and holdout cases before the skill exists
is what stops them from being shaped to fit whatever the skill turns out to produce.

Then propose one recommended skill and two alternatives. Once the user chooses, create the skill
rather than leaving them with a plan.

After the first skill is built:

- give the user one concrete test prompt using `$<skill-name>` or a matching natural-language trigger
- recommend using it 3-5 times before broadening the workflow
- revise the description, steps, examples, or boundaries from observed failures
- do not mass-create speculative skills; optionally maintain a short candidate list under `<project-root>/100_Todo/projects/skill-candidates.md` or another user-approved location
- remove, merge, or narrow skills that remain unused or overlap heavily with another workflow

## Validation Checklist

- Global skill source lives under `{{SYNC_ROOT}}/skills/<skill-name>/` and resolves through all three native entrypoints; project skill lives under `<project-root>/000_Agent/skills/<skill-name>/`.
- Portable package exists in the correct place: `{{SETUP_REPO}}/200_Reference/lazy-pack/<對應序號文件>` for global, project `000_Agent/skills/<skill-name>` for project-local.
- `SKILL.md` frontmatter includes `name` and `description`.
- Shared frontmatter passes the portable envelope: valid non-reserved folder-matching `name`; non-empty third-person `description` of at most 1024 characters that states what the skill does and when to use it; no XML markup.
- `description` includes concrete trigger phrases and use cases.
- Detailed material is in `references/`, not bloating `SKILL.md`.
- The chosen instruction freedom matches task fragility; deterministic operations use scripts when appropriate.
- New skills were initialized with the built-in helper when available, or the fallback was reported.
- `agents/openai.yaml` exists when useful as the Codex UI adapter and remains aligned with `SKILL.md`; it is not required by Claude or AntiGravity.
- The built-in `quick_validate.py` passed when available.
- The skill avoids secrets, tokens, and personal data.
- Agent-specific behavior has all three adapter notes, a shared fallback, and one verification contract.
- The user-facing creation or maintenance route is `codex-skill-creator`, not the built-in creator.
- Explicit invocation uses the actual folder/frontmatter name, for example `$social-cards` or `$landing-page`; do not invent aliases that are not installed.
- Existing skill replacement has a backup or version-control recovery path; narrow updates preserve unrelated files.
- The method source route was settled before material was collected, and route B/C/D consent, permission, and confidentiality checks were completed.
- A skill encoding a real person's judgement satisfies `Ethical Boundaries For Modelling A Person`: scope narrowed, at least two source kinds, contradicting material included, sources and cut-off date recorded, no claimed endorsement, no impersonation, inferences marked, high-stakes domains keep professional review.
- A no-skill baseline was run before writing, and the written rules trace to observed gaps rather than to behaviour the baseline already produced.
- The holdout was reserved before extraction began.
- Both the calibration test and the holdout/unknown/edge test were executed, compared against the baseline, and the resulting fixes were written back; any test not run is explicitly reported as unfinished.
- `SKILL.md` states when not to use the skill, its stopping conditions, and its acceptance criteria.
- The task passed the disqualifier check: not one-off, not a binding commitment, not high-stakes without human review, has a stateable good result, and its material can be handled safely.
- A first skill was screened on the user's fluency with the work, not only on how often it recurs.
- Where a brief was produced, the user confirmed it before any file was written, and it named both test cases.
- A new skill carries `0.1.0` and `last-updated` inside `metadata:`, and the built-in `quick_validate.py` accepted the frontmatter.
- Complex skills received an uncontaminated forward-test when available, or the fallback and reason were reported.
- A standalone Claude ZIP exists only when explicitly requested, contains the named skill folder at archive root, excludes local caches and likely secret files, and remains a derived artifact rather than a second source package.
- Obsidian mirror note is updated for global skill changes; project cockpit is updated for project-local skill changes.
AGENT_LAZYPACK_CODEX_SKILL_CREATOR_SKILL_MD_0E95F5A366

# codex-skill-creator/agents/openai.yaml
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/codex-skill-creator/agents/openai.yaml")"
cat > "{{SYNC_ROOT}}/skills/codex-skill-creator/agents/openai.yaml" <<'AGENT_LAZYPACK_CODEX_SKILL_CREATOR_AGENTS_OPENAI_YAML_DEB9755D27'
interface:
  display_name: "Cross-Agent Skill Creator"
  short_description: "Create skills shared by Codex, Claude, and AntiGravity"
  default_prompt: "Use $codex-skill-creator to create or improve a portable skill shared by Codex, Claude, and AntiGravity."
AGENT_LAZYPACK_CODEX_SKILL_CREATOR_AGENTS_OPENAI_YAML_DEB9755D27

# codex-skill-creator/references/built-in-quality-practices.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/codex-skill-creator/references/built-in-quality-practices.md")"
cat > "{{SYNC_ROOT}}/skills/codex-skill-creator/references/built-in-quality-practices.md" <<'AGENT_LAZYPACK_CODEX_SKILL_CREATOR_REFERENCES_BUILT_IN_QUALITY_PRACTICES_MD_0B0EA38A28'
# Built-in Skill Creator Quality Practices

Use this reference when creating a new skill or substantially redesigning an existing one. It integrates the durable quality practices from Codex's built-in `skill-creator`; `codex-skill-creator` remains the single entry workflow and owns placement, portability, and synchronization.

## 1. Start From Real Usage

Collect or infer concrete examples of:

- what the user says to trigger the skill
- required inputs and source material
- the expected output or action
- decisions the skill must make
- prohibited behavior and safety boundaries

Do not prolong discovery when existing usage already answers these questions.

## 2. Select The Degree Of Freedom

- High freedom: use concise prose and heuristics when several approaches are valid.
- Medium freedom: use preferred patterns, pseudocode, or parameterized helpers when some variation is acceptable.
- Low freedom: use deterministic scripts and strict sequencing when the operation is fragile, repetitive, or costly to get wrong.

The narrower the safe path, the more explicit the guardrails should be.

## 3. Plan The Package

For each example, identify reusable resources:

- `scripts/`: repeated deterministic operations
- `references/`: domain knowledge, schemas, detailed workflows, provider-specific guidance
- `assets/`: templates, icons, fonts, media, or boilerplate copied into final outputs
- `agents/openai.yaml`: recommended UI-facing metadata for skill lists and invocation chips

Create only necessary directories. Avoid placeholder resources and auxiliary files such as `README.md`, installation guides, quick references, and changelogs unless the skill directly needs them.

## 4. Initialize New Skills

When the built-in helper exists, initialize a new skill with:

```bash
python3 "${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-creator/scripts/init_skill.py" \
  <skill-name> --path <parent-directory> \
  [--resources scripts,references,assets] \
  --interface display_name="<Display Name>" \
  --interface short_description="<25-64 character UI description>" \
  --interface default_prompt="Use $<skill-name> to <representative task>."
```

Rules:

- normalize names to lowercase hyphen-case
- keep names at 64 characters or fewer
- reject `claude` and `anthropic` in the shared skill name so the package remains loadable by Claude
- make the folder name match frontmatter `name`
- keep `description` non-empty, at most 1024 characters, free of XML markup, and in third-person language that states both what the skill does and when to use it
- do not use `--examples` unless placeholder examples will be replaced or removed immediately
- if the helper is unavailable, create the equivalent minimal package manually and report the fallback

## 5. Write For Progressive Disclosure

Use three levels:

1. metadata: compact trigger routing that is always visible
2. `SKILL.md`: essential procedure loaded when triggered
3. resources: detailed material loaded or executed only when needed

Keep `SKILL.md` under 500 lines when practical. Link required references directly from `SKILL.md`; avoid deep reference chains. For references longer than roughly 100 lines, add a short table of contents.

## 6. Maintain UI Metadata

When supported, generate or refresh `agents/openai.yaml` with:

```bash
python3 "${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-creator/scripts/generate_openai_yaml.py" \
  <skill-folder> \
  --interface display_name="<Display Name>" \
  --interface short_description="<25-64 character UI description>" \
  --interface default_prompt="Use $<skill-name> to <representative task>."
```

Quote all string values. Include optional icons, brand colors, dependencies, or invocation policy only when they are real requirements. After substantial `SKILL.md` changes, verify that display name, description, and prompt still match the skill.

## 7. Validate And Test

Run the built-in validator when available:

```bash
python3 "${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-creator/scripts/quick_validate.py" <skill-folder>
```

First verify that the selected interpreter can `import yaml`. If the default `python3` lacks PyYAML, use another available interpreter that has it and report the fallback. Do not silently skip validation or install packages globally without considering the environment's package-management policy.

Then run the shared portability validator:

```bash
python3 "{{SYNC_ROOT}}/skills/codex-skill-creator/scripts/package_claude_skill.py" \
  validate <skill-folder>
```

This supplements the built-in validator with folder-name matching, reserved-name checks, required non-empty metadata, and obvious first-/second-person description detection. When the user explicitly asks for a Claude upload ZIP, use the same script's `package` command and follow `references/standalone-claude-package.md`; ZIP creation is not the default shared-skill workflow.

Also verify:

- every referenced file exists
- scripts execute successfully; test a representative sample when several scripts share one pattern
- placeholder files and TODO text are gone
- no secret, token, private data, or unintended absolute personal path remains
- one realistic trigger produces the expected output without relying on hidden conversation context

## 8. Forward-Test Without Leaking The Answer

For complex or high-impact skills, use a fresh independent agent when available. Pass the skill and a realistic user request, but do not provide the intended answer, suspected bug, or planned fix. Prefer raw prompts, artifacts, diffs, logs, or traces.

Ask the user before forward-testing only when it may take substantial time, require additional approvals, or modify live systems. If independent agents are unavailable, perform and report a realistic local trial instead.

Iterate from observed failures, then revalidate metadata, scripts, portable copies, and indexes.
AGENT_LAZYPACK_CODEX_SKILL_CREATOR_REFERENCES_BUILT_IN_QUALITY_PRACTICES_MD_0B0EA38A28

# codex-skill-creator/references/codex-bootstrap-adapter.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/codex-skill-creator/references/codex-bootstrap-adapter.md")"
cat > "{{SYNC_ROOT}}/skills/codex-skill-creator/references/codex-bootstrap-adapter.md" <<'AGENT_LAZYPACK_CODEX_SKILL_CREATOR_REFERENCES_CODEX_BOOTSTRAP_ADAPTER_MD_30B8989A3A'
---
title: Cross-Agent Skill Creator Bootstrap Adapter
date: 2026-05-20
type: reference
tags:
  - codex
  - skills
  - compatibility
---

# Cross-Agent Skill Creator Bootstrap Adapter

This reference adapts `02-skill-creator-bootstrap.md` into one package shared by Codex, Claude, and AntiGravity. The source is useful as a workflow pattern, but source-specific paths and commands must not be copied verbatim.

## Keep From The Source

- Start by detecting the user's actual skill environment before writing files.
- Install or create a complete skill folder, not only `SKILL.md`, when supporting resources are required.
- Use an interview to choose a first high-value skill instead of creating abstract examples.
- Validate that the skill exists, has correct frontmatter, and references real support files.
- Treat skill creation as iterative: create one useful skill, test it, then revise after real use.
- Give users both an explicit `$skill-name` invocation and natural-language examples that match the installed skill's real name.
- If an interactive picker is unavailable, continue with concise numbered choices or one short plain-text question at a time.
- If a skill already exists, inspect it first and offer a narrow update, full refresh with backup, skip, or cancel rather than overwriting blindly.
- Finish by creating and realistically testing one useful skill; installation or scaffolding alone is not completion.
- Keep a small candidate backlog and improve skills after real use instead of mass-generating speculative packages.

## Convert For Three Agents

| Source assumption | Shared package and native adapters |
|---|---|
| Source-specific global skills path | `{{SYNC_ROOT}}/skills` for skills that must trigger across projects; chezmoi exposes it through all three native paths |
| 來源工具 project-level skills path | `<project-root>/000_Agent/skills` for skills that serve only one project |
| `000_Agent/skills` as symlink target | Do not symlink it into `{{SYNC_ROOT}}/skills`; it is the project-local portable skill package |
| alternate global content roots | Do not create them; native Agent paths remain thin entrypoint adapters to `{{SYNC_ROOT}}/skills` |
| alternate project discovery paths | Do not create them; this setup uses `<project-root>/000_Agent/skills` only |
| slash command `/skill-name` | Preserve natural-language trigger intent; document `$skill-name` or another native syntax only as an adapter |
| source structured-question tool | Use the active Agent's structured UI when available; otherwise continue with numbered choices or concise plain-text questions |
| source subagents in `agents/*.md` | Keep the task boundary portable; use the active Agent's supported delegation only when authorized and available |
| `allowed-tools` | Convert to plain permission and fallback rules unless all three agents support the field identically |
| `disable-model-invocation` / `user-invocable` | Omit; express trigger boundaries in `description` and body instructions |
| Third-party or built-in creator install | Use `codex-skill-creator` as the required custom-skill workflow; consult other creator material only as supporting guidance |
| Tell user to restart the source tool | Record the fresh-session or restart step for Codex, Claude, and AntiGravity separately |

## Shared Agent Skill Package Standard

Minimum:

```text
<skill-name>/
└── SKILL.md
```

Optional:

```text
<skill-name>/
├── SKILL.md
├── references/   # detailed docs loaded only when needed
├── scripts/      # deterministic utilities
└── assets/       # templates or output resources
```

Avoid extra `README.md`, installation guides, or changelogs inside a skill unless the user explicitly asks for them.

## Frontmatter Template

```markdown
---
name: skill-name
description: Use when the user asks for [specific task], [trigger phrase], or [workflow]. Include the domain, action, and output expectation.
metadata:
  short-description: Short user-facing phrase
---
```

Rules:

- `name` must match the folder name.
- `description` should front-load the most likely trigger phrases.
- Keep body instructions procedural and compact.
- Put long examples or source adaptations in `references/`.

## Portable Skill Sync Requirement

After any custom global skill change, update:

`{{OBSIDIAN_PROJECTS}}/{{SETUP_PROJECT_NAME}}/全域 Skills/全域 Skills 同步.md`

and sync the portable copy:

`{{SETUP_REPO}}/200_Reference/lazy-pack/<對應序號文件>`

After any project-local skill change, keep the complete portable package under:

`<project-root>/000_Agent/skills/<skill-name>`

and record the skill in that project's cockpit.

Update three areas when applicable:

1. Custom skills table row
2. Skill summary section
3. Recent sync record with the date and exact change

Do not edit the system skill contents under `.system`; the mirror note may list them as read-only built-ins.

## Source Update Decisions

When adapting newer installation guides, retain environment inspection, complete-package validation, iterative testing, plain-text interview fallback, and explicit `$skill-name` examples. Do not import alternate skill roots, another runtime's rule files, another runtime's commands, or another creator as the primary user workflow.

Adapt the source's candidate-list idea to an approved project location such as `<project-root>/100_Todo/projects/skill-candidates.md`; do not create a duplicate daily-memory system. A useful cadence is: build one skill, run it 3-5 times, revise from observed failures, then decide whether the next candidate is still worth creating.
AGENT_LAZYPACK_CODEX_SKILL_CREATOR_REFERENCES_CODEX_BOOTSTRAP_ADAPTER_MD_30B8989A3A

# codex-skill-creator/references/conversation-to-skill.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/codex-skill-creator/references/conversation-to-skill.md")"
cat > "{{SYNC_ROOT}}/skills/codex-skill-creator/references/conversation-to-skill.md" <<'AGENT_LAZYPACK_CODEX_SKILL_CREATOR_REFERENCES_CONVERSATION_TO_SKILL_MD_4D4BF7D9EA'
---
title: Conversation To Skill Extraction
date: 2026-06-14
type: reference
tags:
  - codex
  - skills
  - workflow
---

# Conversation To Skill Extraction

Use this branch when the user says a previous conversation, prompt, result, or workflow should become a reusable skill shared by Codex, Claude, and AntiGravity.

## Goal

Turn the satisfying part of a conversation into a portable skill that another session in any of the three agents can use without needing the full original chat.

The output should preserve the reusable method, not the entire conversation history.

## Confirm Before Packaging

Ask only what is missing. If the current conversation already answers a question, state the assumption and continue.

1. Which part should be solidified: the whole workflow, one output format, a prompt style, a tool sequence, or a validation checklist?
2. What should the skill be called? Normalize the folder name to lowercase hyphen-case, but keep a user-facing title if useful.
3. Should the optimization process be preserved as a reference, or only the final operating method?
4. What should trigger the skill, and what should it deliver?

If the conversation contains private data, secrets, personal stories, client details, or project-only context, ask before placing any of it in a global skill. Prefer abstract examples and placeholders.

## Extraction Steps

Before abstracting the workflow, build a short correction ledger from the conversation:

- capture every point where the user rejected, corrected, narrowed, renamed, or reordered the result
- treat the latest explicit correction as canonical when it conflicts with an earlier preference
- keep only corrections that define reusable behavior; leave one-off wording and temporary context out of a global skill

User corrections are first-class evidence because they reveal hidden acceptance criteria that the initial request often omitted.

1. Identify the repeated job:
   - user trigger phrases
   - desired output
   - required inputs
   - decisions the active agent must make
   - things every agent must avoid
   - correction-derived acceptance criteria
2. Separate reusable method from incidental context:
   - keep stable steps, heuristics, formats, and checks
   - remove one-off names, temporary paths, credentials, and private details
   - replace local-only assumptions with documented defaults or placeholders
3. Decide ownership:
   - global when it will help across projects or should trigger anywhere
   - project-local when it depends on one repo, client, vault area, or unpublished context
   - reference note only when the method is useful but not yet stable enough for a skill
4. Design the package:
   - keep `SKILL.md` focused on trigger routing and core workflow
   - move detailed prompt patterns, examples, schemas, and long checklists into `references/`
   - add `scripts/` only for deterministic repeated operations
   - add `assets/` only for files used in final outputs
5. Write validation criteria:
   - frontmatter name matches the folder
   - description includes the conversation-derived triggers
   - referenced files exist
   - the skill can work without the original conversation
   - sensitive context has been removed or intentionally scoped to a project-local skill

## Recommended Output Shape

For a new global skill, start with the minimum complete package:

```text
{{SYNC_ROOT}}/skills/<skill-name>/
└── SKILL.md
```

For a project-local skill:

```text
<project-root>/000_Agent/skills/<skill-name>/
└── SKILL.md
```

Add `references/`, `scripts/`, or `assets/` only when the extracted workflow actually needs them. If examples are needed, prefer short synthetic examples in a directly linked reference. Do not paste the full original conversation unless the user explicitly asks and the content is safe for the chosen skill scope.

## Skill Draft Checklist

- The description names the real user phrase that should trigger the skill.
- The latest reusable user corrections are reflected as acceptance criteria, boundaries, or workflow ordering rather than being lost in the raw conversation.
- The body tells the active agent when to read each reference file.
- The workflow explains what to do first, what to ask, what to produce, and how to verify.
- The skill contains no secrets, raw private chat, or one-off project state unless it is project-local and intentionally scoped.
- The final report states whether the skill is global or project-local, where it was written, what portable copy was updated, and which agents need a fresh session or restart.
AGENT_LAZYPACK_CODEX_SKILL_CREATOR_REFERENCES_CONVERSATION_TO_SKILL_MD_4D4BF7D9EA

# codex-skill-creator/references/first-skill-consultation.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/codex-skill-creator/references/first-skill-consultation.md")"
cat > "{{SYNC_ROOT}}/skills/codex-skill-creator/references/first-skill-consultation.md" <<'AGENT_LAZYPACK_CODEX_SKILL_CREATOR_REFERENCES_FIRST_SKILL_CONSULTATION_MD_96D900B837'
# First-Skill Consultation

Read this when the user wants help choosing and scoping their first skill, or when they have a
repeated task but cannot yet articulate how they do it. It replaces the short interview in
`SKILL.md` with a coached, one-step-at-a-time flow that ends in a confirmed brief.

Act as a consultant, not an order-taker: make a judgement, then ask the user to confirm it. Advance
one small step at a time. Use Traditional Chinese with the user unless they choose otherwise.

## 1. Find work they are already expert at

Screen on **fluency first, frequency second**. A first skill must come from work the user already
does well, because the calibration test requires them to recognise a correct output on sight. A
skill built on work they are still learning cannot be tested, only admired.

Ask one at a time:

1. In the last week or month, which task did you do three or more times?
2. Which task are you good at, but still have to think through from scratch each time, or find hard to teach someone else?
3. In that task, which tools do you always use, which material do you read, and what do you produce?
4. Which step would help most if AI got it 60% right? Which step must you personally sign off?
5. What is the damage if it goes wrong? (price commitments, personal data, contracts, anything published)

Question 2 is the load-bearing one. "Hard to teach someone else" is the signal that tacit judgement
exists and is worth capturing; work that is easy to teach usually just needs a checklist.

Collect three to five candidates and compare them openly:

| 任務 | 你有多熟 | 重複性 | AI 可先做哪一段 | 風險 | 適合當第一個嗎 |
| :-- | :-- | :-- | :-- | :-- | :-- |

## 2. Disqualify what should not become a skill

Do not push a task into a skill when any of these hold:

- **One-off**: unlikely to recur, so the skill can never earn back its cost.
- **High-stakes without professional review**: legal, medical, financial, or safety work with no qualified human in the loop.
- **Binding commitments**: committing prices, contract terms, payment, or personnel decisions.
- **Unverifiable**: no one can state what a good result looks like, so no acceptance criterion and no calibration test can exist.
- **Unsafe material**: confidential or personal data that cannot be handled safely in this workflow.

Offer the smaller thing instead, in increasing order of cost: a checklist, a prompt template, a
written SOP, or an AI-assisted draft with the user still doing the judgement. Say plainly which
disqualifier applied. Do not build the skill anyway with a warning attached.

Then recommend exactly one task, and say why it is not too large, not too dangerous, and not one-off.

## 3. Break the work into steps

Confirm each of these for the recommended task. Skip anything already answered.

- When it should start, and when it should **not** start
- Required inputs before beginning
- Fixed steps and judgement rules, including the exceptions
- Tools, files, and reference templates used
- Output format and how the user checks it
- The red lines where it must stop and ask a person
- Privacy and de-identification: what must be removed, masked, or never leave the machine

If the user cannot describe their own steps, slow down and **walk back through their last real
case**: what landed on their desk, what they looked at first, what they decided, what they produced.
Asking "what is your SOP" invites an idealised answer that does not match what they actually do.

## 4. Produce a brief and get it confirmed

Write the brief, show it, and get explicit confirmation before any file is created. Designing the
two tests here — before the skill exists — is what stops them from being written to match whatever
the skill happens to produce.

```markdown
# Skill brief：<name>

## 這個 Skill 解決什麼問題
## 何時啟動
## 不該啟動的情境
## 必要輸入
## 工作流程與判斷規則
## 參考資料／工具
## 停止條件（必須問人）
## 輸出格式
## 驗收標準
## 建議的校準題（已知結果）
## 建議的保留／邊界題
```

The last two lines feed `Baseline And Harness` directly. The holdout named here is the one reserved
before extraction; it must not be shown to the skill during construction.

If the user's real goal is a long-term personal writing voice rather than a work method, stop here
and route them to `$personal-style-loop` instead. It calibrates against their real samples with the
published versions held back, which this workflow does not do.

## 5. Hand off to construction

Return to the `SKILL.md` workflow with the method source route set to **A (the user's own practice)**
and the brief as input. Do not re-run a long interview: the information is already gathered. Go
straight to the baseline, then build, then run both tests.

Optionally keep a copy of the brief at `<project-root>/100_Todo/projects/skill-candidates.md` or
another location the user approves. Do not create a parallel folder structure for it.

## Completion

The user should be able to answer all of these:

- Which real task I already know well does my first skill handle?
- How does each step work, with what, producing what?
- When does it start, and when must it stop and ask me?
- Is the skill written into the skills folder rather than living in the conversation?
- Did a baseline and at least one round of test-driven correction actually run?
- Did I open a fresh session and successfully invoke it by name?
AGENT_LAZYPACK_CODEX_SKILL_CREATOR_REFERENCES_FIRST_SKILL_CONSULTATION_MD_96D900B837

# codex-skill-creator/references/standalone-claude-package.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/codex-skill-creator/references/standalone-claude-package.md")"
cat > "{{SYNC_ROOT}}/skills/codex-skill-creator/references/standalone-claude-package.md" <<'AGENT_LAZYPACK_CODEX_SKILL_CREATOR_REFERENCES_STANDALONE_CLAUDE_PACKAGE_MD_AF2B981C30'
---
title: Standalone Claude Skill Package
date: 2026-08-01
type: reference
tags:
  - claude
  - skills
  - packaging
---

# Standalone Claude Skill Package

Use this route only when the user explicitly needs a local ZIP for Claude Customize upload, Claude API upload, or another Claude-specific distribution surface. The shared package under `{{SYNC_ROOT}}/skills` or project `000_Agent/skills` remains authoritative; the ZIP is a derived artifact.

## Shared Requirements

- Finish and validate the shared Codex/Claude/AntiGravity package first.
- Keep the minimum package at `SKILL.md`; add `references/`, `scripts/`, `assets/`, or examples only when they are operationally useful.
- Do not put secrets, credentials, `.env` files, caches, virtual environments, dependency trees, raw private conversations, or unrelated project files in the archive.
- Refuse symlinks inside the package so the archive cannot silently copy data from outside the skill directory.
- Do not upload the ZIP or change a Claude account unless the user separately authorizes that external action.

## Claude-Compatible Frontmatter

The shared `SKILL.md` must use this portable envelope:

- `name`: non-empty, at most 64 characters, lowercase letters/digits/hyphens only, no `claude` or `anthropic`, no XML markup, and equal to the folder name
- `description`: non-empty, at most 1024 characters, no XML markup, third-person phrasing, and a clear statement of what the skill does and when to use it; the validator treats a missing usage condition as an error
- Gerund naming is recommended but not required.

These constraints were verified against Anthropic's Agent Skills overview and authoring guidance on 2026-08-01. Recheck current official documentation if Claude changes its upload contract.

Official references:

- [Skill authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)
- [How to create custom skills](https://support.claude.com/en/articles/12512198-how-to-create-custom-skills)

## Package Workflow

1. Run Codex's built-in `quick_validate.py` when available.
2. Run the shared validator:

   ```bash
   python3 "{{SYNC_ROOT}}/skills/codex-skill-creator/scripts/package_claude_skill.py" \
     validate <skill-folder>
   ```

3. Create the local ZIP only after validation passes:

   ```bash
   python3 "{{SYNC_ROOT}}/skills/codex-skill-creator/scripts/package_claude_skill.py" \
     package <skill-folder> --output-dir <output-directory> --version 1.0.0
   ```

   Add `--timestamp` when multiple builds of the same version must coexist. Version and timestamp formatting are local distribution conventions, not Claude platform requirements.

4. Inspect the reported archive entries. The ZIP root must contain exactly the named skill folder, with `SKILL.md` inside it.
5. Keep the ZIP outside the authoritative skill folder. Do not edit the ZIP as a second source.

## Agent Adapters

### Shared steps

All three agents create and validate the same shared package before any destination-specific delivery.

### Codex adapter

Run the local packaging script and return the resulting file path. Use Claude UI control only when the user explicitly asks for upload and the active session has that capability.

### Claude adapter

For Claude Customize upload, upload the validated ZIP whose root contains the named skill folder. For Claude Code filesystem discovery, use the shared/native skill folder directly; a ZIP is unnecessary unless requested for transfer.

### AntiGravity adapter

Use the same shared package for normal discovery. Produce the Claude ZIP only as a destination artifact when the user asks to transfer the skill to Claude.

### Fallback

If the packaging helper cannot run, validate the package manually, archive the named folder without following symlinks, exclude local caches and likely secret files, then inspect the archive listing before delivery. Report the fallback.

### Verification

- the shared source still exists unchanged
- the archive contains `<skill-name>/SKILL.md`
- every archive entry stays below `<skill-name>/`
- no excluded cache, dependency, environment, credential, or symlink entry is present
- the ZIP was not uploaded without authorization
AGENT_LAZYPACK_CODEX_SKILL_CREATOR_REFERENCES_STANDALONE_CLAUDE_PACKAGE_MD_AF2B981C30

# codex-skill-creator/scripts/package_claude_skill.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/codex-skill-creator/scripts/package_claude_skill.py")"
cat > "{{SYNC_ROOT}}/skills/codex-skill-creator/scripts/package_claude_skill.py" <<'AGENT_LAZYPACK_CODEX_SKILL_CREATOR_SCRIPTS_PACKAGE_CLAUDE_SKILL_PY_26DB4AC9F2'
#!/usr/bin/env python3
"""Validate a shared Agent Skill and optionally build a Claude upload ZIP."""

from __future__ import annotations

import argparse
from datetime import datetime
from pathlib import Path
import re
import sys
import zipfile

import yaml


NAME_PATTERN = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
RESERVED_NAME_WORDS = ("anthropic", "claude")
OBVIOUS_NON_THIRD_PERSON = re.compile(
    r"^(?:i(?:\s|['’]m\b|['’]ll\b|['’]ve\b)|we\b|you\b)", re.IGNORECASE
)
USAGE_CONDITION_PATTERN = re.compile(
    r"\b(?:use when|use for|when|for requests?|for tasks?|triggered by)\b"
    r"|(?:當|適用於|用於|觸發|需要.{0,20}時)",
    re.IGNORECASE,
)
VERSION_PATTERN = re.compile(r"^[0-9]+(?:\.[0-9]+){0,2}(?:[-.][0-9A-Za-z.-]+)?$")
EXCLUDED_DIRS = {
    ".git",
    ".mypy_cache",
    ".pytest_cache",
    ".ruff_cache",
    ".venv",
    "__pycache__",
    "node_modules",
    "venv",
}
SKIPPED_FILES = {".DS_Store"}
SENSITIVE_FILES = {".env", ".env.local", "credentials.json", "id_rsa"}
EXCLUDED_SUFFIXES = {".key", ".pem", ".p12", ".pfx", ".pyc"}


class SkillPackageError(ValueError):
    """Raised when a skill cannot be safely validated or packaged."""


def load_frontmatter(skill_dir: Path) -> dict[str, object]:
    skill_md = skill_dir / "SKILL.md"
    if not skill_md.is_file():
        raise SkillPackageError(f"SKILL.md not found: {skill_md}")
    content = skill_md.read_text(encoding="utf-8")
    match = re.match(r"^---\r?\n(.*?)\r?\n---(?:\r?\n|$)", content, re.DOTALL)
    if not match:
        raise SkillPackageError("SKILL.md must start with valid YAML frontmatter")
    try:
        frontmatter = yaml.safe_load(match.group(1))
    except yaml.YAMLError as exc:
        raise SkillPackageError(f"invalid YAML frontmatter: {exc}") from exc
    if not isinstance(frontmatter, dict):
        raise SkillPackageError("frontmatter must be a YAML mapping")
    return frontmatter


def validate_skill(skill_dir: Path) -> tuple[str, list[str]]:
    skill_dir = skill_dir.expanduser().resolve()
    if not skill_dir.is_dir():
        raise SkillPackageError(f"skill directory not found: {skill_dir}")

    frontmatter = load_frontmatter(skill_dir)
    name = frontmatter.get("name")
    description = frontmatter.get("description")

    if not isinstance(name, str) or not name.strip():
        raise SkillPackageError("frontmatter name must be a non-empty string")
    name = name.strip()
    if len(name) > 64:
        raise SkillPackageError(f"name exceeds 64 characters: {len(name)}")
    if not NAME_PATTERN.fullmatch(name):
        raise SkillPackageError("name must use lowercase letters, digits, and single hyphens")
    if any(word in name for word in RESERVED_NAME_WORDS):
        raise SkillPackageError("name cannot contain reserved words: anthropic, claude")
    if skill_dir.name != name:
        raise SkillPackageError(
            f"folder name '{skill_dir.name}' does not match frontmatter name '{name}'"
        )

    if not isinstance(description, str) or not description.strip():
        raise SkillPackageError("frontmatter description must be a non-empty string")
    description = description.strip()
    if len(description) > 1024:
        raise SkillPackageError(f"description exceeds 1024 characters: {len(description)}")
    if "<" in description or ">" in description:
        raise SkillPackageError("description cannot contain XML or angle brackets")
    if OBVIOUS_NON_THIRD_PERSON.match(description):
        raise SkillPackageError(
            "description must use third-person phrasing; do not start with I, we, or you"
        )

    if not USAGE_CONDITION_PATTERN.search(description):
        raise SkillPackageError(
            "description must state when to use the skill with a concrete trigger or context"
        )
    return name, []


def collect_package_files(skill_dir: Path) -> list[Path]:
    files: list[Path] = []
    for path in sorted(skill_dir.rglob("*")):
        relative = path.relative_to(skill_dir)
        if any(part in EXCLUDED_DIRS for part in relative.parts):
            continue
        if path.is_symlink():
            raise SkillPackageError(f"symlinks are not allowed in a standalone ZIP: {relative}")
        if not path.is_file():
            continue
        if path.name in SKIPPED_FILES:
            continue
        if (
            path.name in SENSITIVE_FILES
            or path.name.startswith(".env.")
            or path.suffix.lower() in EXCLUDED_SUFFIXES
        ):
            raise SkillPackageError(f"likely local or sensitive file must be removed: {relative}")
        files.append(path)
    if not files:
        raise SkillPackageError("skill package contains no files")
    return files


def build_zip(
    skill_dir: Path,
    output_dir: Path,
    version: str,
    include_timestamp: bool,
) -> Path:
    if not VERSION_PATTERN.fullmatch(version):
        raise SkillPackageError("version must look like 1, 1.0, or 1.0.0")
    skill_dir = skill_dir.expanduser().resolve()
    name, warnings = validate_skill(skill_dir)
    files = collect_package_files(skill_dir)

    output_dir = output_dir.expanduser().resolve()
    try:
        output_dir.relative_to(skill_dir)
    except ValueError:
        pass
    else:
        raise SkillPackageError("output directory must stay outside the source skill folder")
    output_dir.mkdir(parents=True, exist_ok=True)
    timestamp = datetime.now().strftime("-%Y%m%d-%H%M%S") if include_timestamp else ""
    archive = output_dir / f"{name}-v{version}{timestamp}.zip"
    if archive.exists():
        raise SkillPackageError(f"refusing to overwrite existing archive: {archive}")

    with zipfile.ZipFile(archive, "w", compression=zipfile.ZIP_DEFLATED) as handle:
        for path in files:
            relative = path.relative_to(skill_dir)
            handle.write(path, arcname=(Path(name) / relative).as_posix())

    with zipfile.ZipFile(archive) as handle:
        entries = handle.namelist()
        required = f"{name}/SKILL.md"
        if required not in entries:
            archive.unlink(missing_ok=True)
            raise SkillPackageError(f"archive verification failed: missing {required}")
        if any(not entry.startswith(f"{name}/") for entry in entries):
            archive.unlink(missing_ok=True)
            raise SkillPackageError("archive verification failed: entry escaped skill root")

    for warning in warnings:
        print(f"WARNING: {warning}")
    print(f"VALID name={name} files={len(files)}")
    print(f"ARCHIVE {archive}")
    print(f"ENTRIES {len(entries)} root={name}/")
    return archive


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Validate a shared Agent Skill and optionally build a Claude upload ZIP."
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    validate_parser = subparsers.add_parser("validate", help="validate shared frontmatter")
    validate_parser.add_argument("skill_dir", type=Path)

    package_parser = subparsers.add_parser("package", help="validate and build a ZIP")
    package_parser.add_argument("skill_dir", type=Path)
    package_parser.add_argument("--output-dir", type=Path, required=True)
    package_parser.add_argument("--version", default="1.0.0")
    package_parser.add_argument(
        "--timestamp", action="store_true", help="append a local build timestamp"
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        if args.command == "validate":
            name, warnings = validate_skill(args.skill_dir)
            for warning in warnings:
                print(f"WARNING: {warning}")
            print(f"VALID name={name}")
            return 0
        build_zip(args.skill_dir, args.output_dir, args.version, args.timestamp)
        return 0
    except (OSError, SkillPackageError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_CODEX_SKILL_CREATOR_SCRIPTS_PACKAGE_CLAUDE_SKILL_PY_26DB4AC9F2
chmod +x "{{SYNC_ROOT}}/skills/codex-skill-creator/scripts/package_claude_skill.py"

test -f "{{SYNC_ROOT}}/skills/codex-skill-creator/SKILL.md" && echo "codex-skill-creator installed for Codex, Claude, and AntiGravity"
````

安裝完成後，請開新 Agent 對話或重啟對應 App，再測試 skill 是否能被讀取。

<!-- END EMBEDDED_SKILLS -->
