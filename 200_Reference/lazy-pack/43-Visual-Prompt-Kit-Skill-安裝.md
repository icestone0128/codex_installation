# 43-Visual Prompt Kit Skill 安裝

> 版本：2026-08-22
> 定位：把文章轉成可直接生圖的視覺設計提案；只出 brief，不出圖、不組版。

## 這個 Item 解決什麼

要做課程封面、系列知識圖卡或銷售頁圖片時，常見的失敗是每張圖各自為政：這張用日系極簡、下一張變成賽博龐克，十張放在一起看不出是同一套。原因是風格決策散在每一次對話裡，沒有被固定下來。

`visual-prompt-kit` 把視覺決策拆成三個獨立維度——**版位（placement）× 風格（style）× 裝飾語言（accent language）**——並用一份 `visual-dna.yaml` 鎖住整個系列的配色、字體階層與構圖上限。之後不論做封面、圖卡還是銷售頁圖，都讀同一份 DNA，系列感不靠人工盯。

新增版位或風格是新增一個檔案，`SKILL.md` 不需要動。

## 邊界

- 只產出結構化設計提案文件，**不輸出 Midjourney / Stable Diffusion 的單段指令語法**。
- 不呼叫生圖工具、不寫 HTML、不組頁面。生圖交 `image-generator`，圖卡組版交 `social-cards`，銷售頁組版交 `landing-page`。
- 不自動加入 Logo、簽名、品牌名、作者名或浮水印。

## 外部依賴：風格庫（不內嵌）

本 Item **只內嵌 skill 本體，不內嵌任何風格庫資料**。

skill 讀取的風格庫是使用者自備的外部資料，預設位置 `{{ASSISTANT_ROOT}}/knowledge/card-style-library/`，需要 `styles.yaml` 與 `previews/`。`references/style-library.md` 定義了完整 schema，任何符合該 schema 的風格庫都能接上。

沒有風格庫也能用：skill 會走「無庫模式」，改用 `references/styles/` 內建的風格檔提供候選，並明說這批候選沒有預覽圖。

之所以不內嵌，是因為風格庫可能是第三方或付費課程內容。**請勿把任何受授權限制的風格資料放進本 repo 或 LazyPack。**

## 三 Agent 共用契約

主版本：`{{SYNC_ROOT}}/skills/visual-prompt-kit`。三個 Agent 透過 Item 16 的 chezmoi 原生 symlink 入口讀同一份 package。

文章解析、風格篩選、visual DNA、提案模板、減法檢查、輸出路徑與驗證標準三個 Agent 完全相同。唯一差異是**候選預覽圖怎麼呈現**：

- Codex：`$visual-prompt-kit`，UI metadata 來自 `agents/openai.yaml`。以編號清單呈現候選並附預覽圖絕對路徑。
- Claude：`/visual-prompt-kit` 或自然語言命中 description。編號清單之外額外用原生檔案傳送直接呈現預覽圖。
- AntiGravity：自然語言命中 description。同 Codex，編號清單加絕對路徑。
- Fallback：任一 Agent 無法內嵌顯示圖片時，仍必須給出預覽圖絕對路徑，不可略過視覺比較直接替使用者決定。
- Verification：候選數量為 5、每個都有推薦理由與可存取的預覽圖路徑、使用者明確選定後才寫入 `visual-dna.yaml`。

## 相依

- `image-generator`（Item 22）：下游生圖。
- `social-cards`（Item 14）：下游圖卡組版與 PNG 匯出。
- `landing-page`（Item 15）：下游銷售頁組版，填 `[IMG-*]` 佔位符。
- Python 3 與 PyYAML：`scripts/recommend_styles.py` 需要。

三個下游 skill 都是選配，缺任何一個都不影響 brief 產出。

## 安裝

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊。這個序號項目會安裝：`visual-prompt-kit`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請依 README 設定 `{{SYNC_ROOT}}`；package 只寫入共用主版本，Item 16 與 chezmoi 會建立 Codex、Claude、AntiGravity 的原生入口。

````bash
set -e

# ---- visual-prompt-kit ----
mkdir -p "{{SYNC_ROOT}}/skills/visual-prompt-kit"
# visual-prompt-kit/SKILL.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/SKILL.md")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/SKILL.md" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_SKILL_MD_0E95F5A366'
---
name: visual-prompt-kit
description: "Use when the user wants to turn an article, note, or topic into visual design briefs for AI image generation, including 封面 Prompt, 課程封面, 圖卡 Prompt, 系列圖卡, 銷售頁圖片 Prompt, 縮圖, thumbnail, banner, or explicit $visual-prompt-kit invocation. Reads a local style library to recommend candidate styles with preview images, locks shared visual DNA, and enforces final-prompt approval gates for Cover and carousel image generation."
metadata:
  short-description: Article to visual design briefs
---

# Visual Prompt Kit

把一篇文章變成可直接生圖的**視覺設計提案**。

這個 skill 負責 brief、確認關卡與交棒，不自行選擇生圖 provider，也不組版。Cover 與
輪播圖卡都必須先完成對應的確認紀錄與驗證器；輪播的第一關可交棒 `image-generator` 產出
首張展示圖，Cover 則先確認最終提案與提示詞，通過後才可交棒正式生圖。這讓同一份視覺
DNA 能同時餵給封面、系列圖卡與銷售頁圖，不必每個版位重講一次風格。

## 三個維度

輸出由三個獨立維度決定，任何一個都能單獨替換：

| 維度 | 說明 | 位置 |
|---|---|---|
| Placement 版位 | 這張圖要用在哪：封面、系列圖卡、銷售頁圖 | `references/placements/` |
| Style 風格 | 視覺語彙：日系現代、極簡、賽博⋯ | `references/styles/` + 風格庫 |
| Accent language 裝飾語言 | 裝飾文字用哪一種語言 | style 檔的 `accent_language` |

新增版位或風格是**新增檔案**，不是改本檔。擴充程序見「擴充」一節。

## 觸發語

`$visual-prompt-kit`、「封面 Prompt」、「課程封面」、「圖卡 Prompt」、「系列圖卡」、
「高密度輪播圖卡」、「4:5 輪播圖卡」、
「銷售頁圖片 Prompt」、「幫我做縮圖」、「把這篇文章做成封面」、「萃取風格」、
「幫我萃取這張圖的風格」、「把這張圖的風格收進風格庫」。

若使用者要的是**成品**而非 brief，先確認路由：品牌模板圖卡走 `social-cards`，
銷售頁組版走 `landing-page`，直接生圖走 `image-generator`。

若使用者是給一張參考圖、要分析或收藏它的設計風格，走「萃取風格」流程
（見下方獨立章節），不是主流程的步驟 2 風格校準。

## 工作流程

### 1. 取得文章與版位

- 收文章（貼上、檔案路徑或網址）。網址優先用可用的網頁讀取工具擷取正文。
- 確認 placement。使用者沒說時依語意判斷並複述一次，不要靜默假設。
- 讀取 `references/placements/<placement>.md` 再繼續。

### 2. 風格與人物校準（分階段互動關卡）

先呈現文章洞察，**分兩輪依序詢問**風格方向與人物選項。請勿將兩者合併在一輪一次問完，以免使用者視覺與決策訊息混淆。

**第一輪：風格校準**
先呈現文章洞察並詢問風格。**絕對不要一次列出整個風格庫。** 三種回法同時給：

- **A 挑編號**：用 `scripts/recommend_styles.py` 篩 **5 個候選**，每個附一行
  「為什麼適合這篇」，並**把 5 張預覽圖交給使用者看**。風格是視覺決策，
  只給文字描述等於沒給。要求換一批時把已出現的 id 併入 `--exclude`。
- **B 描述偏好**：色調、構圖取向、情緒調性，講一項也算。
- **C 你決定**：改走最大差異化的三點軸線。

**收斂規則（所有版位一體適用）**：使用者回覆 A 或 B，風格方向即已定案——
直接進入鎖定 visual DNA，**不得再強制使用者在多組風格變體間做第二次選擇**。
只有回覆 C（或非互動環境）時，才由 AI 依創新維度軸線提出三組最大差異化
方案供選擇——此規則三個版位一體適用。

**第二輪：人物選項確認（等使用者回答第一輪後才詢問）**
收到第一輪風格回覆後，**再發起第二輪詢問人物選項**（版位支援時）：
- 1. 不放人物 — 純文字與圖形構圖
- 2. 預留真人空位 — 生圖時不畫人，預留乾淨區域供事後貼入真人照片
- 3. 放角色插畫 — 依角色設定資產把角色畫進去

**沒有使用者回覆不得進入下一步**。非互動環境可走 C、不放人物，並在輸出開頭說明
未經校準；但輪播圖卡只能停在未確認的第 1 關提案，Cover 只能停在未確認的最終提案與
提示詞，兩者都不能視為已確認或進入正式生圖。

風格庫的位置、schema、選單格式與缺庫時的退路見 `references/style-library.md`；
校準結果如何決定方案組數與定位見該 placement 檔。

### 3. 鎖定 visual DNA

使用者選定後，把風格 id、配色、字體階層、`accent_language`、構圖原則與禁止項
寫進 `visual-dna.yaml`。**同一主題的所有圖都讀這一份**，系列感來自這裡，
不是靠每張圖重複描述。schema 見 `references/visual-dna.md`。

### 3.5 輪播圖卡的四道確認關卡（多張系列版位必要）

`carousel`（低密度輪播圖卡）與 `carousel-info`（高密度輪播圖卡）必須依下列順序
執行。**前一關未獲使用者明確確認，不得進入下一關。**

1. **首張展示提案確認**：A（挑編號）或 B（描述偏好）各提供 **1 組** Slide 01
   展示圖與完整提示詞；C（你決定）提供 **3 組**最大差異化的 Slide 01 展示圖與
   完整提示詞，使用者選定其中一組後才鎖定 `visual-dna.yaml`。首張展示圖是最終
   全套生圖前唯一允許的圖片產出，必須透過 `image-generator` 交棒產生。
2. **文本大綱確認**：依文章結構或知識點決定 N，先在內部一次完成全部 N 張提示詞計畫，
   但只向使用者列出可校稿的文本大綱。每張不可只給標題或方向，欄位契約見
   〈輪播文本大綱共同欄位〉。
3. **全套提示詞確認**：若第 2 關文字未改，直接提出同一份已完成的提示詞計畫做總檢；
   若文字有改，只重算受影響張次後，再提出整套更新版。這不是第二次規劃；此階段不得
   產出正式成品圖。高密度 `carousel-info` 的每組提示詞另須使用六段輕量結構，讓畫布、
   共用 DNA、逐字文本與禁項可被逐段校稿，但不把構圖鎖成固定模板。
4. **正式生圖**：只有第 3 關獲確認後，先以
   `scripts/validate_carousel_approvals.py` 驗證 `briefs/approval-log.md`，通過後才交棒
   `image-generator` 產出整套 N 張成品；高密度每張生成後必須再以
   `scripts/validate_image_aspect.py --ratio 4:5` 檢查實際像素比例。若首張展示圖的文字與
   視覺 DNA 未改，可直接納入成品；否則重生 Slide 01。

每個輪播任務從 `assets/carousel-approval-log-template.md` 建立
`briefs/approval-log.md`，記錄第 1–3 關的 `pending`、`confirmed` 或
`revisions-requested` 狀態與確認日期。單張版位（cover）不採用這套四關流程。

### 3.5.1 輪播文本大綱共同欄位與一次規劃規則

第 2 關的目的，是讓使用者在提示詞與生圖之前，逐張校訂所有會出現在圖卡上的文字。
因此 `carousel` 與 `carousel-info` 的每一張文本大綱都**必須**使用相同五欄位：

1. **主標題**：本張第一閱讀層。
2. **副標題**：讓讀者不讀原文也能理解本張命題。
3. **核心金句**：本張最應被記住的一句話。
4. **內文重點／內容說明**：2–3 個可編修的重點或說明句。
5. **氣氛裝飾文字**：2–3 組、只用 `visual-dna.yaml` 的 `language.accent`；它是文字內容，
   不是事後由生圖端任意補的裝飾。

文本大綱以 `## Slide 01` 這類逐張區塊呈現；不得只給表格欄位名稱或「副標題方向」。
低密度 `carousel` 的第 2 關另有固定格式：每張必須明示六段正式輸出結構中的第 2 項
`### 1. 文本內容`，並在該段填完以上五欄。色彩、字體、佈局與規格則留到第 3 關的完整
五層 Brief，不在第 2 關混入，以便使用者專注修文字。

低密度 `carousel` 的 N 固定為 **8–12 張**：Hook、The Gap、The Vision、Transformation、
Social Proof／Authority、How／Action、Final Call 七個敘事角色不可合併；只有 The System
可依文章的獨立知識點收斂為 1 張或擴展為 5 張。因此 8 張是有效下限，10 張是 The System
有 3 個知識點時的預設，12 張是有效上限。高密度 `carousel-info` 仍依知識點決定張數，
不沿用這個固定區間。

**一次規劃、兩段式揭露**：第 2 關開始前，AI 必須依已鎖定的 `visual-dna.yaml` 與全套
文本內容，在內部完成 N 張提示詞計畫並存為 `briefs/.{placement}-prompt-plan.md`；該檔不在
第 2 關展示。若使用者確認文本無修改，第 3 關直接把同一份計畫轉成
`briefs/{placement}-full.md` 提出總檢，不得再另起一輪重新規劃。若使用者修改某張文字，
只更新該張（以及確實受共用內容影響的張次）的計畫，然後仍將全套最新版本提出整體確認。

呈現第 2 關前必須執行兩個結構驗證：

```text
scripts/validate_carousel_outline.py --placement carousel briefs/carousel-outline.md
scripts/validate_carousel_prompt_plan.py --placement carousel briefs/carousel-outline.md briefs/.carousel-prompt-plan.md
scripts/validate_carousel_outline.py --placement carousel-info briefs/carousel-info-outline.md
scripts/validate_carousel_prompt_plan.py --placement carousel-info --require-structured-high-density briefs/carousel-info-outline.md briefs/.carousel-info-prompt-plan.md
```

驗證通過只代表欄位與提示詞計畫齊全，不代表已獲使用者確認；仍須等使用者明確確認後，
才可把 `briefs/approval-log.md` 的 `文本大綱` 更新為 `confirmed`。

### 3.6 Cover 封面的兩道確認關卡（單張版位必要）

`cover` 是單張最終成品，不需要輪播的文本大綱或首張展示圖；風格庫預覽圖已在
Phase 2.5 提供視覺校準。**不得為了確認而先產出一張 Cover 展示圖**，以免重複使用
生圖額度。Cover 必須依序完成：

1. **視覺方向與人物確認**：完成 Phase 2.5 的風格與人物選項。A／B 直接鎖定方向；
   C（你決定）確認委託視覺方向，並在下一關以最終提案選定其中一組。
2. **最終 Cover 提案與提示詞確認**：A／B 提供 1 組完整提案與提示詞；C 提供 3 組
   最大差異化的完整提案與提示詞。使用者明確確認（C 為選定其中一組）後，才能鎖定
   最終 `visual-dna.yaml` 與生圖內容。
3. **正式生圖**：先以 `scripts/validate_cover_approvals.py` 驗證
   `briefs/cover-approval-log.md`，通過後才交棒 `image-generator`。提案或提示詞一經
   修訂，必須回到第 2 關重新確認。

每個 Cover 任務從 `assets/cover-approval-log-template.md` 建立
`briefs/cover-approval-log.md`，記錄兩道確認關卡與正式生圖狀態。

### 4. 產出設計提案

依 placement 檔指定的模板輸出。輪播版位必須優先遵守上述四道確認關卡；Cover 必須優先
遵守上述兩道確認關卡；除非該 placement 另有規定，一律：

- 方案組數依步驟 2 收斂規則：使用者已選定風格（A/B）→ **1 組方案**忠實
  呈現選定風格；使用者說「你決定」（C）→ 3 組「勇敢先驅 / 保守 / 革命性」
  最大差異化方案，三組視覺必須有明顯差異。
- 每組各自用 codeblock 包住方便複製。
- 每組先過減法檢查再寫模板。

### 5. 交棒

除輪播第一關的首張展示、輪播第四關與 Cover 最終確認後的正式生圖交棒外，不生圖、不
組版。輪播第四關前必須通過 `scripts/validate_carousel_approvals.py briefs/approval-log.md`；
Cover 正式生圖前必須通過
`scripts/validate_cover_approvals.py briefs/cover-approval-log.md`。交棒契約見
`references/handoff-contracts.md`。

## 萃取風格（把參考圖收進風格庫）

跟上面五步驟主流程平行的獨立功能：給一張參考圖，用固定模板描述它的
設計風格，經使用者確認後併入本機風格庫，未來 `recommend_styles.py`
就能直接篩到，不必每次重新分析同一張圖。

完整模板、欄位映射、確認關卡與寫入步驟見
`references/style-extraction.md`，不要另外發明格式或跳過確認直接寫入。

## 輸出位置

```text
100_Todo/projects/visual-prompt-kit/YYYY-MM-DD-{topic-slug}/
├── visual-dna.yaml
└── briefs/<placement>-<variant>.md
```

沒有 `100_Todo/` 時使用最接近的專案本地輸出資料夾，並在回報中寫明實際路徑。

## 硬規則

1. 只產出 brief、確認狀態與交棒資料；不自行選擇生圖 provider、不寫 HTML、不組頁面。
   輪播版位僅可在第 1 關透過交棒產出首張展示圖，整套正式生圖一律等第 3 關確認後
   才交給 `image-generator` 執行；Cover 一律等最終提案與提示詞確認、確認驗證器通過後
   才交棒正式生圖。
2. 不輸出 Midjourney / Stable Diffusion 的單段指令語法（`/imagine` 等）。
   輸出預設是結構化提案文件；高密度 `carousel-info` 以六段輕量結構保留自然語言彈性，
   但指令語法仍然禁止。
3. 不自動加入 Logo、簽名、品牌名、作者名或浮水印，除非使用者明確要求。
4. 主標題與副標題一律台灣繁體中文。裝飾文字只能使用 style 檔 `accent_language`
   指定的那一種語言，且不得三語混用。
5. 一組方案最多 2-3 組裝飾文字、2-4 種裝飾元素、3 個主要視覺區塊。
   （呈現層規則，版位檔可明文放寬——carousel-info 把這些交給生圖端自由發揮。）
6. 背景必須退後：可有質感，不可有搶走主標題的可辨識細節。
7. 只使用使用者提供的文章內容。不從記憶、人設或其他專案補料。
8. 風格校準是必要互動關卡，不可跳過；非互動環境可改走「無偏好」草案並明說，
   但輪播圖卡與 Cover 都不得自動跨越任何確認關卡或正式生圖。
9. 所有文字必須有容器或陰影保護，複雜背景中仍須清晰。核心金句每組必填。
   （前半同屬呈現層規則，版位檔可明文放寬；風格校準與知識點清晰不可放寬。）
10. 風格庫與角色設定若含第三方、付費課程或個人資產，不得複製進本 skill、
    public repo 或 LazyPack；只保留讀取機制與路徑指標。
11. 啟用「預留真人空位」時，無人物鐵則優先於所有其他規則：生圖不得畫出任何
    人物、人臉、人體或剪影。啟用「角色插畫」時反之，不得寫入任何 No Person 指示。
12. 萃取風格寫入本機風格庫前必須先用 `--dry-run` 給使用者看最終內容並取得
    明確同意，不可靜默寫入；未經確認不得移除 `--dry-run` 正式執行。
13. 萃取新增的風格一律標記 `origin: 自訂`，只能用 `add_style.py` 附加寫入，
    不得覆寫既有 id 或竄改課程來源的既有筆數。
14. 傳給生圖端（image-generator）的指令中，語言依 `visual-dna.yaml` 的
    `language` 區塊映射，不得寫死：標題固定宣告 Traditional Chinese；
    點綴文字宣告 `language.accent` 對應的語言；對 `language.forbidden` 的
    每種語言加入明確否定提示；且不得以「{語言} typography / {語言} text」
    的形式提到 forbidden 語言（會誘發生圖模型產生該語言文字——實測
    `Japanese typography` 會招來日文假名）。完整映射見
    `references/handoff-contracts.md` 的「語言映射契約」，所有版位一體適用。
15. 使用者在風格校準回覆 A（挑編號）或 B（描述偏好）即為定案，直接鎖定
    visual DNA；不得再強制使用者在多組風格變體間做第二次選擇。三組差異化
    提案只在使用者回覆 C（你決定）或非互動環境時提供。
16. **多張系列版位四關流程**：`carousel` 與 `carousel-info` 必須依序完成：首張展示
    提案與提示詞確認 → 全套文本大綱確認 → 全套 N 張正式提示詞確認 → 正式生圖。
    第 2 關每張均須完整列出「主標題／副標題／核心金句／內文重點／氣氛裝飾文字」；
    低密度並須使用六段結構中的 `### 1. 文本內容`、固定 8–12 張，且只能伸縮 The System
    的 1–5 張知識段落，不得只給標題或方向；高密度每張提示詞必須有「任務與畫布／共用
    視覺 DNA／本張文字（逐字）／本張視覺方向／設計自由度／不可違反與驗收」六段，
    不限制固定版面。第 2 關先完成
    全套提示詞計畫，只延後對使用者揭露；文字未改時第 3 關直接提同一份計畫，有改才更新
    受影響提示詞。A／B 在第一關提供 1 組展示提案；C 在第一關提供 3 組展示提案並由
    使用者選定 1 組；**不得跳過任何確認關卡，也不得在第 3 關前產出正式成品圖。**
    高密度正式 PNG 生成後另須以 `validate_image_aspect.py --ratio 4:5` 驗收實際像素比例；
    不通過時不可靜默交付、裁切或拉伸。
17. **Cover 單張兩關流程**：`cover` 必須依序完成視覺方向與人物確認 → 最終 Cover
    提案與提示詞確認 → `validate_cover_approvals.py` 通過 → 正式生圖。A／B 第二關提供
    1 組完整提案；C 提供 3 組並由使用者選定 1 組。**Cover 不產出展示圖，也不得在
    最終提案與提示詞確認前生圖。**
18. **風格庫對齊與自由發揮分流（路徑 A/B vs 路徑 C）**：
    - **路徑 A（挑編號 #001–#100）與路徑 B（描述偏好）**：AI 必須嚴格對齊既定風格庫 `knowledge/card-style-library/styles.yaml` 中的文檔描述 (`desc`)、特徵 (`chars`) 與 Prompt，並調閱 `previews/{id:03d}.jpg` 實體預覽圖檔（路徑 A 對應指定編號；路徑 B 搜尋比對最近似的風格編號 #N），據以建立 `visual-dna.yaml`、Briefs 與 Prompt，嚴禁脫離參考資料自創不相干的風格或構圖元素。
    - **路徑 C（「你決定」）**：由 AI 完全自由發揮設計創意，依據創新維度軸線設計 3 組最大差異化（勇敢先驅 / 保守 / 革命性）的創新視覺提案，不受風格庫既有文檔與圖像約束。

## 擴充

新增版位：在 `references/placements/` 新增一個檔案，寫明輸入、輸出模板、
數量、比例與該版位特有的減法檢查。本檔不需要修改。

新增風格：在 `references/styles/` 新增一個檔案，或直接引用風格庫的 id。
風格檔至少要有 `visual_grammar`、`primary_language`、`accent_language`、
`forbidden_languages`。

## Agent 執行

- **Shared steps**：文章解析、風格篩選與選單、visual DNA、提案模板、減法檢查、
  輸出路徑與驗證標準三個 Agent 完全相同。
- **Codex adapter**：以編號清單呈現 5 個候選，並附預覽圖的絕對路徑供使用者開啟。
- **Claude adapter**：同樣輸出編號清單，並額外用原生檔案傳送把 5 張預覽圖直接呈現；
  結果契約與編號清單一致。
- **AntiGravity adapter**：同 Codex，以編號清單加絕對路徑呈現。
- **Fallback**：任一 Agent 無法內嵌顯示圖片時，仍必須給出預覽圖的絕對路徑，
  不可略過視覺比較這一步而直接替使用者決定。
- **Verification**：候選數量為 5、每個都有推薦理由與可存取的預覽圖路徑；輪播第 2 關
  必須先以 `validate_carousel_outline.py` 驗證每張五個文本欄位（低密度另驗證
  `### 1. 文本內容`），再以 `validate_carousel_prompt_plan.py` 驗證提示詞計畫與大綱張次
  一一對應（高密度加 `--require-structured-high-density` 驗證六段提示詞）；並保留首張展示、
  文本大綱、全套提示詞三次明確確認紀錄；Cover 任務必須有視覺方向與人物、最終提案與
  提示詞兩次明確確認紀錄。兩者各自的生圖前驗證器通過後才可交棒；高密度正式 PNG 另須
  通過 `validate_image_aspect.py --ratio 4:5` 才可交付。
- **萃取風格**：三個 Agent 共用同一套模板與 `add_style.py` 呼叫方式；差異只在
  呈現填好模板的方式（見 `references/style-extraction.md` 的 Agent 執行）。
  寫入前一律先跑 `--dry-run`，使用者同意後才移除該旗標正式寫入。

## 參考檔

- `references/style-library.md`：風格庫位置、schema、篩選與選單流程。
- `references/visual-dna.md`：`visual-dna.yaml` schema 與系列一致性規則。
- `references/style-extraction.md`：萃取風格模板、欄位映射與寫入風格庫流程。
- `references/handoff-contracts.md`：交棒給 image-generator / social-cards / landing-page。
- `references/placements/cover.md`：封面版位（課程封面、文章封面、縮圖）。
- `references/placements/carousel.md`：低密度輪播圖卡版位（1:1 連續敘事 Carousel，
  固定 8–12 張；只伸縮 The System 的 1–5 張知識段落。固定四關：首張展示提案 →
  文本大綱 → 全套五層提示詞 → 正式生圖）。
- `references/placements/carousel-info.md`：高密度輪播圖卡版位（4:5 直式 Info Carousel，
  一張一個知識點。固定四關：首張展示提案 → 文本大綱 → 全套六段輕量結構提示詞 →
  正式生圖；鎖畫布／文字／風格／禁項，版面與裝飾交給生圖端自由發揮）。
- `references/placements/cover-person.md`：封面人物選項。模式 P 預留真人空位
  （生圖不畫人）、模式 C 角色插畫（生圖要畫人），兩者互斥。
- `references/styles/japanese-modern.md`：日系現代風格（繁中主體、英文點綴）。
- `scripts/recommend_styles.py`：從風格庫篩出候選並輸出預覽圖路徑。
- `scripts/add_style.py`：把萃取的新風格附加寫入風格庫的 `styles.yaml`。
- `scripts/validate_carousel_workflow.py`：驗證兩種輪播圖卡都保有四道確認關卡。
- `scripts/validate_carousel_outline.py`：驗證第 2 關逐張文本大綱的共同五欄位；低密度
  另驗證六段結構中的 `### 1. 文本內容`。
- `scripts/validate_carousel_prompt_plan.py`：驗證內部提示詞計畫與文本大綱的張次完全對應。
- `scripts/validate_image_aspect.py`：驗證正式圖片的實際像素比例；高密度輪播固定 4:5。
- `scripts/validate_carousel_approvals.py`：正式生圖前驗證任務的前三次使用者確認。
- `scripts/validate_cover_workflow.py`：驗證 Cover 封面保有兩道確認關卡與生圖驗證器。
- `scripts/validate_cover_approvals.py`：正式生圖前驗證 Cover 的兩次使用者確認。
- `assets/carousel-approval-log-template.md`：輪播任務的三次確認紀錄模板。
- `assets/cover-approval-log-template.md`：Cover 任務的兩次確認紀錄模板。
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_SKILL_MD_0E95F5A366

# visual-prompt-kit/agents/openai.yaml
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/agents/openai.yaml")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/agents/openai.yaml" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_AGENTS_OPENAI_YAML_DEB9755D27'
interface:
  display_name: "視覺提案套件"
  short_description: "文章轉視覺提案；Cover與輪播皆先確認再生圖"
  default_prompt: "使用 $visual-prompt-kit 將文章轉成具確認關卡的 Cover 或輪播圖卡視覺提案。"
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_AGENTS_OPENAI_YAML_DEB9755D27

# visual-prompt-kit/assets/carousel-approval-log-template.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/assets/carousel-approval-log-template.md")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/assets/carousel-approval-log-template.md" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_ASSETS_CAROUSEL_APPROVAL_LOG_TEMPLATE_MD_7479854BD7'
# 輪播圖卡確認紀錄

- 首張展示提案：pending
  - 確認日期：
  - 使用者回覆：
- 文本大綱：pending
  - 確認日期：
  - 使用者回覆：
- 全套提示詞：pending
  - 確認日期：
  - 使用者回覆：
- 正式生圖：not-started
  - 產出日期：
  - 備註：

使用規則：每一關只能在使用者明確確認後改為 `confirmed`。若使用者要求修訂，改為
`revisions-requested`；不得在前三關全部為 `confirmed` 前將「正式生圖」改為進行中。
正式交棒前必須使用 `scripts/validate_carousel_approvals.py` 驗證本檔並取得 `PASS`。
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_ASSETS_CAROUSEL_APPROVAL_LOG_TEMPLATE_MD_7479854BD7

# visual-prompt-kit/assets/cover-approval-log-template.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/assets/cover-approval-log-template.md")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/assets/cover-approval-log-template.md" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_ASSETS_COVER_APPROVAL_LOG_TEMPLATE_MD_C3FC5A8FF1'
# Cover 封面確認紀錄

- 視覺方向與人物：pending
  - 確認日期：
  - 使用者回覆：
- 最終 Cover 提案與提示詞：pending
  - 確認日期：
  - 使用者回覆：
- 正式生圖：not-started
  - 產出日期：
  - 備註：

使用規則：

- 收到使用者的風格方向與人物選項後，才把「視覺方向與人物」改為 `confirmed`。
  使用者選 C（你決定）時，C 本身是委託視覺方向的確認；最終仍須在下一關選定或確認提案。
- A／B 只能提供 1 組最終 Cover 提案與提示詞；C 提供 3 組最大差異化提案與提示詞，
  使用者選定其中一組才把「最終 Cover 提案與提示詞」改為 `confirmed`。
- 使用者要求修改最終提案或提示詞時，將該欄改為 `revisions-requested`；修訂後必須再次獲得
  明確確認，才可改回 `confirmed`。
- 正式交棒前必須使用 `scripts/validate_cover_approvals.py` 驗證本檔並取得 `PASS`；
  不得在前兩項皆為 `confirmed` 前將「正式生圖」改為進行中。
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_ASSETS_COVER_APPROVAL_LOG_TEMPLATE_MD_C3FC5A8FF1

# visual-prompt-kit/references/handoff-contracts.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/references/handoff-contracts.md")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/references/handoff-contracts.md" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_REFERENCES_HANDOFF_CONTRACTS_MD_F59DB8C89B'
# 交棒契約

本 skill 只產出 brief 與確認狀態。實際產圖與組版一律交給下游，呼叫方向單向，不會循環。

```text
visual-prompt-kit  →  image-generator   生圖
                   →  social-cards      圖卡組版與匯出
                   →  landing-page      銷售頁組版
```

## → image-generator

Cover 與輪播圖卡的確認關卡不同，交棒時不可混淆：

1. **Cover 正式生圖**：Cover 不產出展示圖。只有
   `briefs/cover-approval-log.md` 的「視覺方向與人物」與「最終 Cover 提案與提示詞」都標為
   `confirmed` 時，才交出選定的 `visual-dna.yaml` 路徑、單組已確認 brief／提示詞、目標比例、
   輸出檔名與存放路徑。交棒前必須執行
   `scripts/validate_cover_approvals.py briefs/cover-approval-log.md` 並取得 `PASS`。
2. **輪播第 1 關首張展示**：交出 Slide 01 的展示 brief、對應完整提示詞、目標比例與
   輸出路徑。A／B 只交 1 組；C 交 3 組最大差異化提案。這是全套正式生圖前唯一
   允許的圖片產出。
3. **輪播第 4 關正式生圖**：只有 `briefs/approval-log.md` 的「首張展示提案」、「文本大綱」、
   「全套提示詞」都標為 `confirmed` 時，才交出 `visual-dna.yaml` 路徑、全套 N 張
   已確認 brief／提示詞、目標比例、輸出檔名與存放路徑。交棒前必須執行
   `scripts/validate_carousel_approvals.py briefs/approval-log.md` 並取得 `PASS`。

所有帶有指定比例的交棒，在生成後都要由下游回傳實際像素尺寸並完成比例驗收，不能只看
Prompt 中的比例文字。高密度 `carousel-info` 固定執行：

```text
scripts/validate_image_aspect.py --ratio 4:5 assets/images/slide-*.png
```

若任何一張不通過，下游只重生該張並再次驗證；不得用裁切、拉伸或口頭宣稱符合比例取代
驗收。第二次仍不通過時，停在未交付狀態，向使用者說明原生工具限制並請其決定替代路徑。

若輪播第 2 或第 3 關調整了 Slide 01 的文字或視覺 DNA，展示圖不可直接當成正式成品，
必須在第 4 關重生。使用者只要 brief、不要展示圖或成品時，不進行任何圖片交棒。

由 `image-generator` 決定實際使用哪個 Agent 的原生生圖能力。本 skill 不指定 provider、
不要求 API key、不自行建立生圖腳本。

### 語言映射契約（所有版位共用，依 visual-dna.yaml 變數）

Brief 轉換為生圖 Prompt 時，語言指定一律**取自該系列 `visual-dna.yaml` 的
`language` 區塊**，不得在任何版位檔或 Prompt 中把語言寫死：

1. **主標／副標（固定）**：`Traditional Chinese title text: "[主標題]"`、
   `Traditional Chinese subtitle text: "[副標題]"`。這是唯一的常數——
   硬規則 4 規定主體一律台灣繁體中文。
2. **點綴文字（變數）**：`{language.accent 的英文語言名} accent text: "[點綴文字]"`。
   `accent: en` → `English accent text: "..."`；`accent: ja` →
   `Japanese accent text: "..."`，依此類推。
3. **禁用語言否定提示（變數）**：對 `language.forbidden` 列出的**每一種**語言
   加入明確否定句。`forbidden: [ja]` →
   `Strictly NO Japanese hiragana, katakana, or Japanese text`；
   `forbidden: [en]` → `Strictly NO English text or Latin letters`，依此類推。
4. **觸發詞紀律**：不得在風格描述中以「{語言} typography」「{語言} text」的
   形式提到 `forbidden` 清單裡的語言——生圖模型會因此在畫面中產生該語言
   文字（實測：Prompt 含 `Japanese typography` 會誘發日文假名）。
   視覺語彙一律用風格名稱表達（如 `Modern Japanese Web Style` 指日式現代
   網頁視覺，不是日文文字）；accent 語言則必須用第 2 點的明確欄位宣告，
   不靠風格詞暗示。

**預設組合**（日系現代風 `japanese-modern`）：`accent: en`、`forbidden: [ja]`
→ 英文點綴＋日文否定提示。使用者要換點綴語言時，只改 `visual-dna.yaml` 的
`language.accent` 與 `language.forbidden`，映射自動跟著翻轉，
任何版位檔都不需要修改。

## → social-cards

`social-cards` 的產線是 HTML 模板加截圖，配色固定在它自己的品牌模板裡。兩條產線並存，
不要合併：

- 日常貼文、需要品牌一致 → 直接用 `social-cards`，不必經過本 skill。
- 課程、銷售、需要視覺張力 → 本 skill 出 brief，`image-generator` 出圖，再把圖交給
  `social-cards` 的 `content-image` 模板組版與匯出 PNG。

交出：每張圖的檔案絕對路徑，以及對應的卡片順序。

## → landing-page

`landing-page` 用 `[IMG-Hero]`、`[IMG-Pain]` 這類佔位符管理圖片。

交出：佔位符 ID 與圖檔路徑的對應表，以及每張圖的比例。

**銷售頁的組版是 `landing-page` 的工作，不是本 skill 的。** 本 skill 只負責讓
那些佔位符有圖可填。

## 不交棒的情況

使用者只要 brief、不要成品時，交付 brief 就結束。不要自作主張往下走完整條產線。
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_REFERENCES_HANDOFF_CONTRACTS_MD_F59DB8C89B

# visual-prompt-kit/references/style-extraction.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/references/style-extraction.md")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/references/style-extraction.md" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_REFERENCES_STYLE_EXTRACTION_MD_E929E97B9C'
# 萃取風格：從參考圖建立新風格

給一張參考圖，用固定模板描述它的設計風格，經使用者確認後併入本機風格庫
（`references/style-library.md` 的 `styles.yaml`），之後 `recommend_styles.py`
篩候選時就能直接抽到，不必每次重新分析同一張圖。

## 觸發語

「萃取風格」、「幫我萃取這張圖的風格」、「把這張圖的風格收進風格庫」、
使用者提供一張圖並要求描述或收藏其設計風格時。

## 前置條件

需要有本機風格庫才能寫入（見 `references/style-library.md` 的位置與 schema）。
風格庫不存在時，仍可產出萃取模板文字，但明說無法寫入，並停在「無庫模式」。

## 萃取模板

```text
請使用「{風格名稱}」的風格設計{作品類型}。

以{背景特徵}作為基底，
搭配{核心視覺元素}，
整體色彩以{主要配色邏輯}為主。

文字風格為{字體特徵＋權重感}，
搭配{強調色／對比方式}提升辨識度。

整體風格參考{風格來源／文化類型}，
呈現出{整體氛圍／情緒關鍵字}的視覺感受。
```

這是唯一的萃取模板，不要另外發明格式。八個欄位都要填，不確定的欄位寧可
寫「不明顯／無特定」也不要留空或編造圖片沒有的細節——第 7 條硬規則
（只使用使用者提供的內容）在這裡同樣適用：只描述這張圖實際看到的東西。

## 工作流程

### 1. 收圖

使用者提供本機路徑或直接貼上的圖片。用原生讀圖能力查看內容，只分析
**這一張**圖，不臆測、不補其他來源的風格資訊。

### 2. 套用模板

逐項分析並把八個欄位填進模板，連同**作品類型**一起問清楚
（例如「知識圖卡」「課程封面」「banner」；沒有特別用途就用「知識圖卡」，
跟現有庫的用途保持一致）。把填好的完整段落貼給使用者看。

### 3. 使用者確認（必要關卡）

**未經使用者確認前不得寫入風格庫。** 這是要永久併入共用資產的資料，
比一般 brief 更需要覆核：任何一格描述錯了都會讓這個風格未來被誤用。
使用者可以整段接受，或指出某幾格要修正——修正後重新呈現一次再問。

### 4. 映射成 styles.yaml 欄位

| 模板欄位 | 用途 | 對應 schema 欄位 |
|---|---|---|
| 風格名稱 | 風格的名字 | `name_zh`（可選補 `name_en` / `name_ja`） |
| 作品類型 | prompt 開頭「設計 ___」的用途詞 | 併入 `prompt` 全文，不是獨立欄位 |
| 背景特徵 | 底色／材質／場景 | 併入 `desc` 與 `prompt` |
| 核心視覺元素 | 主要視覺物件／構圖重點 | 併入 `desc`；最具代表性的 1-2 個收進 `chars` |
| 主要配色邏輯 | 主色／配色關係 | 併入 `desc`；收一項進 `chars` |
| 字體特徵＋權重感 | 標題字體調性 | 併入 `prompt`；可收一項進 `chars` |
| 強調色／對比方式 | 提升辨識度的手法 | 併入 `prompt` |
| 風格來源／文化類型 | 這個風格的源流 | 併入 `desc` 與 `prompt`；也用來判斷 `category` |
| 整體氛圍／情緒關鍵字 | 情緒／氛圍 | 併入 `desc`；收一項進 `chars` |

具體規則：

- `prompt`：把模板八個欄位全部代入後的完整文字，**去除換行合併成一段**，
  跟現有庫其餘 100 筆的 `prompt` 呈現格式一致（單行、不分段）。
- `desc`：1-3 句連續段落，濃縮背景、核心元素、配色與氛圍，比照現有庫的密度，
  不是模板的逐字複製。
- `chars`：固定 4 個短語標籤，從核心元素、配色、字體、氛圍四個面向各挑一個代表詞。
- `category`：從風格庫既有的 7 大分類挑最接近的一個（跑
  `python3 scripts/recommend_styles.py --library <風格庫路徑> --list-scenes`
  可以看到目前的分類與場景清單）。真的沒有對應分類才用 `--allow-new-category`。
- `scenes`：從既有 7 個場景標籤挑 1-2 個。真的都不合適才用 `--allow-new-scene`。
- `origin`：固定 `自訂`，用來跟課程來源的 `日系` / `國際通用` 區分。往後課程
  改版時的更新程序（見 `card-style-library/README.md`）只處理 `origin` 非
  `自訂` 的 id，不會動到使用者自建的風格。
- `extracted_from`：填來源說明（例如圖片檔名或使用者描述的出處），方便日後
  追溯這個風格是從哪張圖萃取的。

### 5. 寫入風格庫

先用 `--dry-run` 印出即將寫入的 entry 文字與新 preview 路徑，給使用者看
最終內容：

```bash
python3 scripts/add_style.py --library <風格庫路徑> \
  --image <參考圖路徑> \
  --name-zh "風格名稱" \
  --category "現代插畫" \
  --scenes "知識學習,商業職場" \
  --desc "..." \
  --chars "核心元素,配色,字體調性,氛圍關鍵字" \
  --prompt "已代入八個欄位、合併成一段的完整文字" \
  --extracted-from "使用者提供的參考圖 xxx.jpg" \
  --dry-run
```

使用者同意後，拿掉 `--dry-run` 正式寫入。腳本會：

1. 把圖片置中裁切成正方形、縮成 800×800 JPEG，存成
   `previews/{新 id:03d}.jpg`，跟現有 100 張預覽圖規格一致。
2. 以純文字附加（append）新 entry 到 `styles.yaml` 尾端，格式比照既有 99 筆
   手刻格式，**不重新格式化整份檔案**，避免動到其他 100 筆的排版。
3. 更新 `meta.count`，並在寫入前做一次完整 YAML 解析檢查；解析失敗就中止、
   不寫入檔案。

id 由「目前最大 id + 1」自動指定（預設從 101 開始），除非用 `--id` 指定。

### 6. 回報

寫入完成後回報：新 id、新 preview 絕對路徑、更新後的 `meta.count`，並提醒
之後 `recommend_styles.py --scenes ... --category ...` 可以直接篩到這個新風格。

## 版權提醒

參考圖若是他人作品的截圖，萃取出的**文字風格描述**通常沒有問題，但只把
縮圖存進使用者私有、不進 repo 也不進 LazyPack 的本機風格庫（見
`card-style-library/README.md` 的使用邊界），不要把原圖或縮圖複製到任何
公開位置。

## Agent 執行

- **Shared steps**：模板固定八欄位、映射規則、`--dry-run` 覆核關卡、
  `add_style.py` 呼叫方式三個 Agent 完全相同。
- **Codex / AntiGravity adapter**：填好模板後以文字呈現給使用者確認；
  `--dry-run` 輸出直接印出。
- **Claude adapter**：同樣先以文字呈現模板供確認；若參考圖是本機檔案，
  可用原生檔案讀取直接顯示圖片協助使用者核對是不是同一張。
- **Verification**：`--dry-run` 內容經使用者明確同意後才移除該旗標正式寫入；
  寫入後確認回傳的 id、preview 路徑與 `meta.count` 都存在。
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_REFERENCES_STYLE_EXTRACTION_MD_E929E97B9C

# visual-prompt-kit/references/style-library.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/references/style-library.md")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/references/style-library.md" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_REFERENCES_STYLE_LIBRARY_MD_38543875AA'
# 風格庫：位置、schema 與選單流程

## 位置

風格庫是**外部資料**，不隨本 skill 發布。預設位置：

```text
{{ASSISTANT_ROOT}}/knowledge/card-style-library/
├── styles.yaml
└── previews/001.jpg … NNN.jpg
```

Arry 的本機預設 `ASSISTANT_ROOT` 是 Google Drive 的 `codex_symlink`。
其他使用者需自備風格庫或改用「無庫模式」。

風格庫可能是第三方或付費課程內容。**不得複製進本 skill、public repo 或 LazyPack。**

## schema

`styles.yaml` 至少要有 `meta` 與 `styles` 兩段。每筆風格：

| 欄位 | 必要 | 用途 |
|---|---|---|
| `id` | ✅ | 唯一整數，對應 `previews/{id:03d}.jpg` |
| `name_zh` | ✅ | 選單顯示名 |
| `category` | ✅ | 粗分類，用於平衡候選多樣性 |
| `scenes` | ✅ | 適用場景標籤，主要篩選依據 |
| `desc` | ✅ | 風格描述 |
| `chars` | ✅ | 特徵標籤，用來寫推薦理由 |
| `prompt` | ✅ | 可直接使用的風格提示詞 |
| `preview` | | 預覽圖相對路徑；缺少時由 `id` 推導 |
| `name_ja` / `name_en` | | 補充名稱 |
| `origin` | | 風格源流，用於多樣性平衡 |

## 選單流程

### 篩選

用 `scripts/recommend_styles.py`，不要自己土法掃 YAML：

```bash
python3 scripts/recommend_styles.py --library <風格庫路徑> --scenes 知識學習,商業職場 --count 5
```

常用參數：`--category` 限定分類、`--exclude` 排除已看過的 id、`--id N` 取單一風格
完整資料、`--list-scenes` 列出可用場景標籤、`--json` 輸出機器可讀格式。

腳本會平衡候選的 `category` 與 `origin`，避免 5 個都是同一路數。

### 呈現

每個候選一行，格式固定：

```text
{編號}. #{id} {name_zh}（{category}）— {為什麼適合這篇}
```

推薦理由必須連結到**這篇文章**的調性或主題，不能只是複述 `desc`。

然後**把 5 張預覽圖交給使用者看**。這一步不可省略：

- 有原生圖片呈現能力的 Agent，直接呈現 5 張圖。
- 沒有的，輸出 5 個預覽圖絕對路徑，請使用者自行開啟。
- 兩種情況都不可以替使用者決定，或用文字描述取代視覺比較。

候選之外一定要同時給另外兩條路：**自由描述偏好**，或**讓 Agent 決定**。
候選清單是選項，不是強制；使用者的口頭描述和風格庫 id 有同等效力。

### 收斂

- 選一個 id → 該風格是 Design Anchor，進入 visual DNA。
- 選 id 再補一句修正（「但要更暗」「文字再大一點」）→ 兩者都收進 Anchor，
  以口頭修正優先。
- 只描述偏好、沒選 id → 用描述當 Anchor。可再跑一次腳本找語彙相近的風格
  當參考，但不要反過來用風格庫覆蓋使用者的描述。
- 說「換一批」→ 把已出現的 id 併入 `--exclude` 再跑一次。
- 說「我自己挑」→ 依 `--category` 分批列出名稱與 id，不要一次倒 100 筆。
- 說「你決定」或沒有偏好 → 不設 Anchor，走最大差異化路徑。
- 非互動環境 → 同「你決定」，並在輸出開頭說明未經校準。

## 無庫模式

風格庫不存在或讀取失敗時**不要中止**：

1. 明說風格庫不可用，以及查找過的路徑。
2. 改用 `references/styles/` 內建的風格檔提供候選。
3. 提醒使用者這批候選沒有預覽圖，並詢問是否仍要繼續。
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_REFERENCES_STYLE_LIBRARY_MD_38543875AA

# visual-prompt-kit/references/visual-dna.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/references/visual-dna.md")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/references/visual-dna.md" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_REFERENCES_VISUAL_DNA_MD_799DB77D09'
# visual-dna.yaml

系列一致性的**唯一來源**。同一主題底下的所有圖都讀這一份，不要在每個 brief 裡
重複描述風格——那是系列感失控的主因。

## 產生時機

使用者選定風格之後、寫第一份 brief 之前。使用者沒有明確選定前不要寫入。

## schema

```yaml
topic: 文章或主題名稱
slug: topic-slug
created: YYYY-MM-DD

style:
  source: library | builtin        # 來自風格庫或內建 style 檔
  id: 7                            # source=library 時必填
  name: 手寫混搭數位風
  visual_grammar: japanese-modern
  reference_prompt: >              # 風格庫的 prompt 或 style 檔摘要
    ...

language:
  primary: zh-TW                   # 主標題與副標題
  accent: en                       # 裝飾文字（Ashirai）
  forbidden: [ja]                  # 畫面上不得出現的語言

palette:
  background: ...
  accent: ...                      # 只用來凸顯 2-3 個關鍵字
  text_primary: ...

typography:
  heading: ...                     # 標題字體特徵
  accent: ...                      # 裝飾字體特徵
  scale_contrast: ...              # 主副標級距對比

composition:
  blocks_max: 3                    # 主要視覺區塊上限
  ashirai_max: 3                   # 裝飾文字組數上限
  decoration_max: 4                # 裝飾元素種類上限
  background_recede: true

person:
  mode: none | placeholder | character   # 三選一，placeholder 與 character 互斥
  # mode: placeholder 時
  zone_strategy: ...        # 三組各自的空位配置策略必須不同
  light_source: ...         # 主光源方向，供後製對齊
  # mode: character 時
  asset_registry: ...       # 角色資產登錄檔路徑
  style_profile: ...        # canonical 風格來源，不在本檔複製風格資料

forbidden:
  - logo
  - 簽名
  - 浮水印
  - 作者名
```

## 使用規則

1. 每個 placement 的 brief 都引用同一份 `visual-dna.yaml`，只補該版位特有的內容。
2. `language`、`palette`、`typography` 跨版位一致。要改就改這份，不要在單一 brief 裡覆寫。
3. `composition` 的上限是硬上限，不是建議值。
4. 使用者中途要換風格時，更新這份並明說哪些既有 brief 會受影響。

## person 欄位

`mode` 決定整個系列的人物處理方式，跨版位一致：

- `none` — 不放人物。
- `placeholder` — 生圖**不畫人**，預留乾淨空位供事後貼真人照片。
- `character` — 生圖**要畫**角色插畫。

`placeholder` 與 `character` 互斥，同一張圖不可以既留空位又畫角色。
中途要換 mode 時更新這份，並明說哪些既有 brief 會受影響。細節見
`placements/cover-person.md`。
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_REFERENCES_VISUAL_DNA_MD_799DB77D09

# visual-prompt-kit/references/placements/carousel-info.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/references/placements/carousel-info.md")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/references/placements/carousel-info.md" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_REFERENCES_PLACEMENTS_CAROUSEL_INFO_MD_FD5237A143'
# Placement：高密度輪播圖卡（Info Carousel）

適用於 Instagram / LinkedIn 的 **4:5 直式連續資訊圖卡**。與低密度輪播圖卡
（`carousel.md`）同族，但控制程度不同：低密度版用完整分欄位模板精確控制視覺決策；
本版位用可校稿的**輕量結構化提示詞**鎖住畫布、文字、風格與底線，版面、構圖、裝飾與
資訊層級仍交給生圖端自由發揮。

在三種圖卡應用中的密度定位：

| 應用 | 比例 | 張數 | 資訊密度 |
|---|---|---|---|
| 低密度輪播圖卡（`carousel.md`） | 1:1 | N 張輪播 | 低（重敘事） |
| **高密度輪播圖卡（本版位）** | 4:5 | N 張輪播 | **中** |
| 9:16 知識圖卡（Knowledge 歸檔） | 9:16 | 一次一張 | 高 |

本版位每張的文字量**介於 1:1 低密度輪播與 9:16 知識圖卡之間**：副標與重點
比 1:1 豐富，讓輪播承載更多資訊；但不像 9:16 單張那樣塞下完整知識點的
所有細節——輪播的資訊量分攤在 N 張上。

- 比例：**固定 `4:5`**，不詢問、不提供其他選項。
- **張數 N 由 AI 依文章內容決定**：一張一個知識點，在前置分析暫定張數並附理由；
  最終張數與文字在文本大綱關卡確認。
- 固定四道確認關卡：**首張展示提案確認 → 文本大綱確認 → 全套提示詞確認 →
  正式生圖**。前一關未經使用者明確確認，不得進入下一關。
- A／B 與 C 的後續流程完全相同；唯一差異是第一關的展示提案數量：A／B 是 1 組，
  C 是 3 組最大差異化提案。

## 指令哲學：輕量結構化，而非版面規格化

每組指令都採用下列 **6 段人可讀區塊**。目的不是要求模型照欄位排版，而是讓 Agent
與使用者能逐段校稿、讓畫布比例不再藏在自然語言段落裡。每個區塊內仍以自然語言描述，
不必硬湊字數或子欄位。

1. **任務與畫布**：用途、固定 4:5 直式畫布、比例優先權。
2. **共用視覺 DNA**：整套不變的視覺語彙、配色、背景、字體氣質與字重原則。
3. **本張文字（逐字）**：所有需出現在本張的繁中主文字與允許的點綴文字。
4. **本張視覺方向**：本張唯一的知識意象、情緒或閱讀重心。
5. **設計自由度**：明確授權生圖端自行決定版面、資訊層級、容器、留白與裝飾。
6. **不可違反與驗收**：語言、人物、品牌／標籤禁令，以及正式輸出後的比例驗收。

這不是低密度版的完整五層 Brief：**不規定**版面分區、裝飾元素數量、文字字數上限、
容器樣式或構圖策略。指令寫得像委託一位懂行的設計師，不是像填一張規格單。

每張提示詞的最低結構如下；第 2、4、5 段可依風格與知識點長短調整，但六個段名不可省略：

```text
【任務與畫布】
為 Instagram／LinkedIn 產生一張高密度輪播圖卡。畫布必須是 4:5 直式；優先遵守此比例，
不可輸出為正方形、3:4 或 2:3。

【共用視覺 DNA】
{全套共用的自然語言風格段落}

【本張文字（逐字）】
主標題：「{主標題}」
副標題：「{副標題}」
核心金句：「{核心金句}」
內文重點：{2–3 點}
氣氛裝飾文字：{2–3 組 accent 語言文字}

【本張視覺方向】
{只描述本張的知識意象、情緒與閱讀重心}

【設計自由度】
請自行決定文字層級、留白、容器、圖形與構圖；不要受固定欄位或固定格線限制。

【不可違反與驗收】
{依 visual-dna.yaml 映射語言與人物限制；不出現敘事標籤、頁碼、hashtag、Logo、簽名、
浮水印、價格或促銷文字。完成後以實際像素比例驗收為 4:5。}
```

## 設計底線（僅此而已，不再加碼）

1. **風格跨張一致**：整套 N 張使用同一段風格描述（源自選定風格與
   `visual-dna.yaml`），不逐張變換風格。
2. **一張一個知識點**：讀者不需原文即可理解本張內容；快速掃過也能
   抓到重點——風格段落中應包含字重層級原則（重點粗、正文細之類），
   但具體怎麼排由生圖端決定。
3. **主要文字為台灣繁體中文**；裝飾性外語點綴依 `visual-dna.yaml` 的
   `language.accent`，不混用 `language.forbidden` 的語言。
4. **不出現**：敘事標籤（Hook / Slide 01⋯）、hashtag、價格促銷、
   Logo、簽名、浮水印。
5. **預設不放人物**（`person.mode: none`），使用者主動要求時才讀
   `cover-person.md`。

## 前置分析與風格校準

### Step 1 洞察與定義

同 `carousel.md` 的 Step 1 與 Step 2：辨別受眾與動機、提煉 Core Message。
本版位另加：**列出文章的知識點清單**（每點一句話），張數 N 由清單推導——
通常是知識點數 + 開頭引入 + 收尾行動。

### Step 2 風格校準（互動關卡）

選單格式與 `carousel.md` 的 Step 3 完全相同（A 風格庫 5 候選附預覽圖 /
B 自由描述 / C 你決定），洞察摘要中一併呈現知識點清單與規劃張數供確認：

```text
我已完成文章分析：

- 目標受眾：{簡述}
- 核心訊息：{簡述}
- 知識點清單：{每點一句話}
- 規劃張數：{N} 張 — {一句理由}
```

**沒有使用者回覆不得進入第 1 關。** 非互動環境只可輸出 C 的未確認草案，並在
輸出開頭說明缺少使用者確認；不得自動跨越第 1–3 關或生圖。

**收斂規則（與其他版位一致）**：使用者選了 A（風格編號）或 B（描述偏好），
以該方向建立一組首張展示提案；使用者說「你決定」（C）時，依創新維度三點軸線
建立 **3 組最大差異化首張展示提案**（A 勇敢先驅 / B 保守 / C 革命性）。A／B
在展示提案前可先寫入暫定 DNA；C 在使用者選定展示提案後才寫入正式 DNA。兩種
路徑都必須在第 1 關確認後，才可進入相同的第 2–4 關流程。

### 第 1 關：首張展示提案確認

風格校準後，先產出首張展示提案，不得直接列出全套文本大綱或提示詞。

- A／B：先依選定風格寫入 `visual-dna.yaml`（`person.mode: none`），提供 **1 組**
  Slide 01 展示圖與對應完整提示詞。
- C：依三點軸線建立 **3 組**暫定視覺 DNA，各提供 Slide 01 展示圖與對應完整提示詞；
  使用者選定其中一組後才寫入正式 `visual-dna.yaml`。
- 展示圖一律交棒 `image-generator` 產生，是第 3 關確認前唯一可產出的圖片；展示提示詞
  也必須使用本版位的六段輕量結構。

從 `assets/carousel-approval-log-template.md` 建立 `briefs/approval-log.md`，並把
`首張展示提案` 設為 `pending`。只有使用者確認展示圖與
對應提示詞後，更新為 `confirmed`，才可進入第 2 關。

#### 共用視覺 DNA 段落寫法

把選定風格展開成**一段完整的自然語言風格描述**，整套 N 張共用。
風格庫選出的風格以其 `prompt` 為基底擴寫；自由描述則直接成文。
段落應涵蓋（有幾項寫幾項，不硬湊）：

- 開頭固定句式：`請使用「{風格名稱}」的風格設計知識圖卡。`
- 背景基底與質感
- 主要視覺元素與插畫／圖形語彙
- 配色邏輯（低彩度單色系／深色高對比⋯）
- 字體氣質與**字重層級原則**——重點資訊用什麼字重標示、正文維持什麼字重、
  粗體的使用節制原則（參考範例二的寫法：每段只挑 1–2 個重點加粗，
  優先給核心概念、關鍵數字、步驟關鍵字）
- 整體氛圍與風格源流

寫作範例（兩種密度都合法，依風格本身的複雜度決定長短）：

```text
請使用「手寫混搭數位」的風格設計知識圖卡。主標題使用精確的粗黑體中文，
旁邊或下方搭配手寫感的英文短語作為氛圍裝飾。手寫字可以稍微傾斜或不規則
排列，與工整的黑體形成溫度上的對比。背景保持簡潔（深色或淺色皆可），
讓手寫與數位的混搭成為視覺焦點。
```

更多完整寫作範例（含長版的字重層級寫法）見 Arry 本機 Knowledge 的
`{{ASSISTANT_ROOT}}/knowledge/card-style-library/knowledge-card-prompts.md`——該檔是 9:16
單張知識圖卡的成品 prompt 庫，風格段落的寫法可直接借鑑，但本版位輸出時
比例一律改成 4:5、密度收斂到輪播的中等水位。其他使用者沒有該檔時，
以上方內建範例為準。

### 第 2 關：文本大綱確認

首張展示提案獲確認後，先在內部依已鎖定的 `visual-dna.yaml` 與全套內容完成 N 張
六段輕量結構的提示詞計畫；此時只向使用者列出文本大綱，供逐張審閱與修訂文字。張數 N 依
知識點推導，通常是知識點數 + 開頭引入 + 收尾行動，不限於 10 張。每張以
`## Slide 01` 這類區塊完整填入以下共同五欄位，不能只寫「副標題方向」或摘要：

- 主標題
- 副標題
- 核心金句
- 內文重點／內容說明（2–3 個可校稿重點）
- 氣氛裝飾文字（2–3 組，只用 `visual-dna.yaml` 的 `language.accent`）

本版位在第 2 關只確認文字，不限制生圖端的版面、構圖或裝飾做法；這些仍在第 3 關的
輕量結構化提示詞中保有自由。呈現文本前必須執行：

```text
scripts/validate_carousel_outline.py --placement carousel-info briefs/carousel-info-outline.md
scripts/validate_carousel_prompt_plan.py --placement carousel-info --require-structured-high-density briefs/carousel-info-outline.md briefs/.carousel-info-prompt-plan.md
```

把 `briefs/approval-log.md` 的 `文本大綱` 設為 `pending`。大綱未經使用者確認不得
提出完整指令；文字未修改時，第 3 關直接提出同一份已完成的提示詞計畫。使用者要求
修改時，只重算受影響張次後，重新提出整套更新版供總檢。確認後更新為 `confirmed`，
才可進入第 3 關；兩支驗證器通過只代表結構完整，不代表使用者已確認。

### 第 3 關：全套提示詞確認

依已確認文本，將第 2 關已完成的提示詞計畫直接寫入 `briefs/carousel-info-full.md`；
文字未修改時不得另起一輪規劃。若第 2 關曾修改文字，先只重算受影響張次，再將更新後的
全套 N 組提示詞寫入同一檔。每組指令都用 codeblock 包住，並沿用第 2 關已完成的
**六段輕量結構**。其中「共用視覺 DNA」跨張完全一致；「本張文字（逐字）」完全對應
已確認的文本大綱；「本張視覺方向」才依張次改變：

```text
【任務與畫布】
為 Instagram／LinkedIn 產生一張高密度輪播圖卡。畫布必須是 4:5 直式；優先遵守此比例，
不可輸出為正方形、3:4 或 2:3。

【共用視覺 DNA】
{全套共用的自然語言風格段落}

【本張文字（逐字）】
主標題：「{標題}」
副標題：「{一到兩句說明}」
核心金句：「{核心金句}」
內文重點：{2–3 點}
氣氛裝飾文字：{accent 語言文字}

【本張視覺方向】
{本張知識意象、情緒與閱讀重心}

【設計自由度】
請自行決定文字層級、留白、容器、圖形與構圖；不要受固定欄位或固定格線限制。

【不可違反與驗收】
{依 visual-dna.yaml 的語言／人物限制；無敘事標籤、頁碼、hashtag、Logo、簽名、浮水印、
價格或促銷文字。完成後以實際像素比例驗收為 4:5。}
```

一次產出全部 N 組交使用者確認。敘事順序沿用 `carousel.md` 的原則：開頭引入、
收尾行動固定保留，中段每張一個知識點依文章邏輯排列。使用者有修改意見時，修訂
受影響提示詞後重新呈現；**全套提示詞未經確認不得生圖。** 全套獲確認後，將
`briefs/approval-log.md` 的 `全套提示詞` 更新為 `confirmed`。呈現第 3 關前，必須以同一支
驗證器確認 `briefs/carousel-info-full.md` 仍保有逐張對應與六段結構：

```text
scripts/validate_carousel_prompt_plan.py --placement carousel-info --require-structured-high-density briefs/carousel-info-outline.md briefs/carousel-info-full.md
```

### 第 4 關：正式生圖

第 3 關確認後，先以本 skill 的 `scripts/validate_carousel_approvals.py` 驗證
`briefs/approval-log.md`；通過後才交棒 `image-generator` 產出最終交付版本，第一行固定
是總指令行（張數代入實際 N），接著逐張列出已確認的 N 組指令：

```text
使用以下指令產生圖卡，共 {N} 張輪播圖卡 output by slide by slide format
```

第 4 關不改內容；若使用者此時又提出修改，回到第 2 或第 3 關修訂並重新確認。
首張展示圖只有在文字與視覺 DNA 都未變動時，才能直接納入正式成品；否則重生 Slide 01。

每張 PNG 生成完成後，**尚未通過比例驗收前不得交付為正式成品**。對全套圖片執行：

```text
scripts/validate_image_aspect.py --ratio 4:5 assets/images/slide-*.png
```

原生生圖工具的輸出尺寸可以是接近 4:5 的整數像素（例如四捨五入後的尺寸），但不得是
其他比例。若某張未通過，先只重生該張並在「任務與畫布」段重申 4:5；第二次仍失敗時，
不得裁切、拉伸或靜默交付，應回報原生工具限制並請使用者決定是否授權改用可控畫布的
替代生圖／組版路徑。

## 生圖轉換（僅第 4 關）

交棒 `image-generator` 時，遵循 `../handoff-contracts.md` 的「語言映射契約」：
標題固定繁中欄位宣告，點綴文字與禁用語言否定提示依 `visual-dna.yaml` 的
`language.accent` / `language.forbidden` 變數映射，並遵守其觸發詞紀律。
本版位的六段輕量結構照用不動，但轉換為生圖 Prompt 時上述映射與否定提示不可省略；
不能把「任務與畫布」或「不可違反與驗收」為了縮短 Prompt 而刪除。

## 檢查（輕量）

- [ ] 每張提示詞是否都有六段輕量結構，並由驗證器通過？
- [ ] 整套是否共用同一段視覺 DNA、無逐張變風格？
- [ ] 風格段落是否含字重層級原則？
- [ ] 第 1 關是否提供首張展示圖與對應提示詞？A／B 是否為 1 組、C 是否為 3 組？
- [ ] 文本大綱是否已經使用者確認？
- [ ] 全套 N 組提示詞是否已經使用者確認？
- [ ] 每張是否對應一個知識點、無重複無遺漏？張數是否等於確認的 N？
- [ ] 是否沒有敘事標籤、hashtag、促銷、Logo、簽名、浮水印？
- [ ] 主要文字是否繁體中文、外語點綴是否只用 accent 語言？
- [ ] 生圖轉換是否遵守語言映射契約（accent／forbidden 依 DNA 變數映射、
      否定提示已加、無 forbidden 語言觸發詞）？
- [ ] 總指令行張數是否代入正確？
- [ ] `briefs/approval-log.md` 的首張展示提案、文本大綱、全套提示詞是否皆為 `confirmed`？
- [ ] 每張正式 PNG 是否已由 `validate_image_aspect.py --ratio 4:5` 通過？

不檢查版面分區、裝飾數量、字數上限——那些是生圖端的自由；但畫布比例、逐字文本、
語言與禁項是驗收條件，不屬於自由範圍。

## 輸出檔名

```text
briefs/carousel-info-proposal-{01|A|B|C}.md  # 第 1 關：A/B 一組，C 三組 Slide 01 展示提案
briefs/carousel-info-outline.md               # 第 2 關：全套文本大綱
briefs/carousel-info-full.md                  # 第 3 關：全套 N 組六段輕量結構化提示詞
briefs/approval-log.md                        # 第 1–3 關確認狀態
```

`approval-log.md` 一律由本 skill 的 `assets/carousel-approval-log-template.md` 複製後填寫。

## 相關

- `carousel.md`：低密度輪播圖卡版位（1:1、完整分欄位模板精確控制）。
  要精確控制視覺選它；要保留構圖自由、但仍需可校稿 Prompt 選本版位。
- `cover-person.md`：人物選項。本版位預設不啟用。
- `../visual-dna.md`：風格一致性的記錄位置。
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_REFERENCES_PLACEMENTS_CAROUSEL_INFO_MD_FD5237A143

# visual-prompt-kit/references/placements/carousel.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/references/placements/carousel.md")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/references/placements/carousel.md" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_REFERENCES_PLACEMENTS_CAROUSEL_MD_5FBC59A164'
# Placement：低密度輪播圖卡（Carousel）

適用於 Instagram / LinkedIn 的連續敘事輪播圖卡。把一篇資訊密度高的知識型文章，
精煉為 **N 張具備強烈邏輯連貫性**的圖卡設計指令。在三種圖卡應用中屬於
**低密度**一級：重敘事與視覺衝擊、單張文字量最輕（中密度 4:5 見
`carousel-info.md`，高密度 9:16 單張見風格庫的 `card-style-library/knowledge-card-prompts.md`）。

- 比例：**固定 `1:1`**，不詢問、不提供其他選項。
- **張數 N 固定為 8–12 張**（不是固定 10 張）：在第一回合的定義階段規劃張數並附一句理由，
  供使用者一併確認。Hook、The Gap、The Vision、Transformation、Social Proof／Authority、
  How／Action、Final Call 七段固定保留；**只有 The System 可從 1 張擴展為 5 張**，所以
  8 張是最少、10 張是預設、12 張是最多。敘事弧線完整優先於湊滿張數。
- 固定四道確認關卡：**首張展示提案確認 → 文本大綱確認 → 全套提示詞確認 →
  正式生圖**。前一關未經使用者明確確認，不得進入下一關。
- A／B 與 C 的後續流程完全相同；唯一差異是第一關的展示提案數量：A／B 是 1 組，
  C 是 3 組最大差異化提案。

## 原始腳本的繼承與後續覆寫

本規格繼承使用者提供的原始腳本之角色設定、日系數位設計語彙、1:1 比例、知識密度、
十張預設敘事弧線與六段結構化輸出格式；下列是使用者後續明確確認、優先於原始腳本的規則：

- 原本固定 10 張，改為 **8–12 張**；僅 The System 可由 1 張伸縮到 5 張。
- 原本兩回合確認後直接交付全套，改為四關流程，並採「一次完整規劃、兩段式揭露」。
- 原本風格校準後一律提供三案，改為 A／B 提供 1 組、C 提供 3 組首張展示提案。
- 原本將核心金句置於敘事定位，改為 `### 1. 文本內容` 的可編輯共同欄位，與其他文本一併確認。

## 角色

以日本數位視覺設計師的身分工作：專精於把高資訊密度的知識型文章，拆解並重組為
具備「連續敘事感」的系列圖卡。設計哲學：**在視覺克制中承載知識重量，
讓文字成為視覺藝術的一環。**

不只是執行視覺的技師，更是擁有設計思考（Design Thinking）系統方法論的提案者：
先洞察受眾、定義問題核心，再聚斂出最精準的視覺敘事方案。

## 設計原則（必須遵守）

1. **知識密度平衡**：每張圖卡的文字量以「讀者不需要原文就能理解這張圖卡的
   核心概念」為標準。主標題精簡（5–8 字），副標題可延伸至 2–3 句完整說明，
   確保知識邏輯完整傳達而非只剩標題骨架。
2. **高易讀性**：粗體現代黑體，巨大的文字級距（Hierarchy）創造視覺衝擊。
3. **連續性敘事**：整套圖卡從「引發共鳴」到「行動指引」流暢轉承。
4. **跨張視覺一致性**：同一套圖卡的背景色系、主標字體、容器樣式必須統一，
   讓觀看者滑動時感受到整體感而非拼湊感。一致性的唯一來源是
   `visual-dna.yaml`——每一張都讀同一份，不在單張指令裡另立色系或字體。
5. **資訊降噪**：不使用花俏裝飾，僅運用幾何圖形、半透明容器或高質感色塊
   區隔資訊。
6. **禁止促銷**：不包含任何價格、折扣或促銷資訊，專注於知識內容的精準傳達。
7. **敘事標籤不上圖**：Hook、Gap、Vision、Slide 01 等敘事架構標籤僅為設計師
   內部思考工具，嚴禁出現在任何圖卡的文本內容欄位（主標題、副標題、裝飾文字）。
8. **不使用 Tag**：圖卡內不加入任何 hashtag 或標籤文字（如 #知識管理），
   所有資訊層次僅透過主標題、副標題與裝飾文字建立。

## 人物選項

本版位**預設不放人物、不發起第二輪人物詢問**（`visual-dna.yaml` 的
`person.mode: none`）。只有使用者主動要求在圖卡放人物時，才讀
`cover-person.md` 並依其規則處理；此時整套圖卡的人物策略仍須跨張一致。

## 前置分析與第 1 關展示提案

依序完成 4 個 Step。**Step 3 是互動關卡，沒有使用者回覆不得進入 Step 4。**

### Step 1 洞察（Empathize）

辨別目標受眾身份（職場工作者 / 創作者 / 學習者⋯）與深層動機：他們為什麼會想
看這一系列圖卡。找出文章中最能打動人心的情緒點。

### Step 2 定義（Define）

提煉 1 個 Core Message：「看完整套圖卡後，受眾最應該記住的一件事」。
找到整套圖卡的**核心金句**，作為整套視覺的靈魂錨點。

同時**暫定張數 N**：依文章的架構密度規劃敘事弧線需要幾張（核心架構有幾個
步驟、需不需要前後對比與權威背書張），並準備一句理由，在 Step 3 連同洞察
呈現；最終張數與文字在第 2 關文本大綱才確認。

### Step 3 風格校準（互動關卡）

先把洞察攤給使用者看，再依 `references/style-library.md` 的選單流程詢問風格。
選單格式與封面版位一致：

```text
我已完成文章分析：

- 目標受眾：{簡述}
- 核心訊息：{簡述}
- 情緒方向：{簡述}
- 規劃張數：{N} 張 — {一句理由，如：核心架構有四個步驟，加上前後鋪陳與收尾}

在開始提案之前，先確認視覺方向。三種回法都可以：

A. 從下面 5 個候選挑一個編號
   {依 references/style-library.md 篩出的 5 個候選，各附一行「為什麼適合這篇」}
   {並把 5 張預覽圖交給使用者看}

B. 直接描述你的偏好
   色調（深色系／明亮系）、構圖（幾何切割／極簡留白／卡片堆疊）、
   情緒調性（權威專業／溫暖親近／衝擊力強）都可以，講一項也行。

C. 說「你決定」
   我依創新維度軸線給三組最大差異化的方案。
```

**非互動環境**（`codex exec`、`claude -p`、CI、排程）只可走 Step 4 路徑 C 的
未確認草案，並在輸出開頭說明缺少使用者確認；不得自動跨越第 1–3 關或生圖。

### Step 4 首張展示提案確認（第 1 關）

依 Step 3 的回覆分兩條路進行：

**路徑 A / B — 使用者給了方向（選擇 A 風格編號 或 B 描述偏好）**

1. 鎖定該風格寫入 `visual-dna.yaml`。
2. 依據選定風格產出 **1 組專屬設計提案**：提供 **1 張 Slide 01 展示圖**（交棒
   `image-generator` 生圖）與 **1 組 Slide 01 完整五層架構 Sample Brief**（包含 1.
   文本內容、2. 色彩計畫、3. 字體特徵、4. 佈局構圖、5. 規格風格）供使用者審閱。
3. 從 `assets/carousel-approval-log-template.md` 建立 `briefs/approval-log.md`，並將
   `首張展示提案` 設為 `pending`。**展示提案未經確認，
   不得列出文本大綱、產出全套提示詞或生圖其餘頁面。**
4. 使用者確認展示提案後，把此關更新為 `confirmed`，才可進入第 2 關。

**路徑 C — 使用者說「你決定」（選擇 C）或非互動環境**

1. 依創新維度三點軸線提出 **3 組最大差異化風格提案**（A 勇敢先驅 / B 保守 / C 革命性）。
2. 每組各自提供 **1 張 Slide 01 展示圖**（共 3 張 1:1 展示圖）與 **1 組 Slide 01 完整
   五層架構 Sample Brief** 供使用者比較與選定。
3. 在 `briefs/approval-log.md` 將 `首張展示提案` 設為 `pending`。使用者選定其中一組後，
   才鎖定寫入 `visual-dna.yaml`，並把此關更新為 `confirmed`；後續與 A／B 完全相同。

## 第 2 關：文本大綱確認

首張展示提案獲確認後，先在內部依已鎖定的 `visual-dna.yaml` 與全套內容完成 N 張
五層 Brief 的提示詞計畫；此時只向使用者列出文本大綱，供逐張審閱與修訂文字。N 由
文章的敘事結構決定，但固定為 8–12 張；不得為了湊數而改變敘事弧線。

低密度的文本大綱**固定先列出六段正式輸出結構中的第 2 項**：`### 1. 文本內容`。
每張以 `## Slide 01` 這類區塊呈現，且 `### 1. 文本內容` 必須完整填入以下共同五欄位：

- 主標題
- 副標題
- 核心金句
- 內文重點／內容說明（2–3 個可校稿重點）
- 氣氛裝飾文字（2–3 組，只用 `visual-dna.yaml` 的 `language.accent`）

第 2 關只呈現可修改的文字；不得提早附上色彩、字體、佈局、構圖或規格。核心金句在
第 3 關同樣保留在 `### 1. 文本內容`，讓文本大綱與正式五層 Brief 的文字欄位一致。
呈現文本前必須執行：

```text
scripts/validate_carousel_outline.py --placement carousel briefs/carousel-outline.md
scripts/validate_carousel_prompt_plan.py --placement carousel briefs/carousel-outline.md briefs/.carousel-prompt-plan.md
```

把 `briefs/approval-log.md` 的 `文本大綱` 設為 `pending`。使用者確認無須修改文字時，
第 3 關直接提出同一份已完成的提示詞計畫；若修改文字，只重算受影響張次後，提出全套
更新版供總檢。完成文字編修並明確確認後，更新為 `confirmed`，才可進入第 3 關。
兩支驗證器通過只代表結構完整，不代表使用者已確認。

## 第 3 關：全套提示詞確認

文本大綱確認後，將第 2 關已完成的提示詞計畫直接寫入 `briefs/carousel-full.md`，交給
使用者逐張確認；文字無修改時不得另起一輪規劃。若第 2 關曾修改文字，先只重算受影響
張次，再將更新後的完整 N 組提示詞寫入同一檔。N 組全部引用同一份 `visual-dna.yaml`，
單張只填該張特有的敘事內容。**此階段只審閱提示詞，不得產出正式成品圖。**

若使用者要求修改任何頁面，修訂受影響的提示詞後再次呈現確認；只有全套提示詞獲得
明確確認，才把 `briefs/approval-log.md` 的 `全套提示詞` 更新為 `confirmed`。

## 第 4 關：正式生圖

第 3 關確認後，先以本 skill 的 `scripts/validate_carousel_approvals.py` 驗證
`briefs/approval-log.md`；通過後才交棒 `image-generator` 產出全套 N 張實體圖卡。交棒
總指令第一行固定為：

```text
使用以下指令產生圖卡，共 {N} 張輪播圖卡 output by slide by slide format
```

接著逐張交出已確認的 N 組指令。首張展示圖只有在文字與視覺 DNA 都未變動時，才能直接
納入正式成品；否則必須重生 Slide 01。

敘事弧線依下表規劃。這是 **10 張時的預設結構**：The System 有 3 張知識段落。
N 的伸縮**只能**發生在 The System：文章沒有可分開講的知識點時，將 Part 1–3 收斂為
一張，形成 8 張；文章有 2／4 個獨立知識點時，形成 9／11 張；有 5 個獨立知識點時，
擴展為 12 張。Hook、The Gap、The Vision、Transformation、Social Proof／Authority、
How／Action 與 Final Call 一律保留、不得合併，且 Final Call 永遠是最後一張。

| 張次 | 敘事角色 | 敘事任務 |
|---|---|---|
| Slide 01 | Hook | 爆擊痛點的提問或現狀揭露 |
| Slide 02 | The Gap | 揭示理想與現實的巨大差距 |
| Slide 03 | The Vision | 大腦升級，定義新的解決方案標準 |
| Slide 04 | The System - Part 1 | 核心架構拆解 / 步驟一（The System 可為 1–5 張） |
| Slide 05 | The System - Part 2 | 核心架構拆解 / 步驟二（預設結構） |
| Slide 06 | The System - Part 3 | 核心架構拆解 / 步驟三（預設結構） |
| Slide 07 | Transformation | 展示使用後的具體改變（前後對比意象） |
| Slide 08 | Social Proof / Authority | 權威感背書、數據支持或邏輯證實 |
| Slide 09 | How / Action | 具體的行動指引或第一步 |
| Slide 10 | Final Call | 結尾視覺鉤子與品牌留白 |

「敘事角色」欄位是內部規劃用途，**嚴禁將這些標籤文字輸出到任何圖卡的
文本內容中**。

## 減法檢查

每組指令（Sample 與正式）進模板前逐項確認：

- [ ] 主標題是不是第一視覺，且在 5–8 字內？
- [ ] 副標題是否 30–50 字、讓讀者無需原文即可理解本張核心概念？
- [ ] 所有文字是否有容器或陰影保護？（複雜背景中仍須清晰）
- [ ] Ashirai 是否 2-3 組，且只用 `visual-dna.yaml` 的 `language.accent`？
- [ ] 是否沒有混入 `language.forbidden` 的語言？
- [ ] 主要視覺區塊是否 ≤ 3 個？裝飾元素是否只保留 2-4 種？
- [ ] 背景是否退後、與整套色系一致？
- [ ] 是否沒有出現敘事標籤（Hook / Gap / Slide 01⋯）與任何 hashtag？
- [ ] 是否沒有價格、折扣或促銷資訊？
- [ ] 是否沒有自動加入 Logo、簽名、品牌名、作者名、浮水印？
- [ ] 核心金句是否已填？
- [ ] 本張的色系、字體、容器樣式是否與 `visual-dna.yaml` 一致？

第 1 關另加：A／B 是否只提供 1 組首張展示提案？C 的 3 組 Sample 差異是否夠明顯？
第 2 關另加：張數是否在 8–12 張？The System 是否依獨立知識點在 1–5 張間伸縮，
且其他七個固定敘事角色均已保留？每張是否都有 `### 1. 文本內容` 的五個共同欄位？
`validate_carousel_outline.py` 與 `validate_carousel_prompt_plan.py` 是否通過？
文本大綱是否已獲使用者確認？張數是否與確認後的大綱一致？
第 3 關另加：是否已提供全部 N 組五層提示詞並獲確認？
第 4 關另加：總指令行的張數是否代入正確？N 張的敘事轉承是否流暢、無斷裂或重複？
Hook 與 Final Call 是否都在？`briefs/approval-log.md` 的第 1–3 關是否皆為 `confirmed`？

## 輸出模板

**不要壓縮成 `/imagine prompt:` 或任何單段英文描述句。** 唯一合法格式是這份
分欄位文件。**每組指令的輸出以「5. 規格與風格」結束**，codeblock 之後不附加
任何額外內容——包含視覺渲染描述、單段英文彙整或補充說明段落。

```text
## 【圖卡序列 X：標題】

### 0. 敘事定位
（本區塊為設計師內部思考記錄，不得將任何內容輸出至圖卡的任何視覺位置）
- 敘事角色：{本張在 10 張弧線中的角色，如 Hook / Gap / Vision，僅供內部參考}
- 情緒目標：{觀看者 3 秒內應產生的心理反應，如共鳴感、好奇心、信任感}

### 1. 文本內容
- 主標題：{放大、具衝擊力的核心關鍵字，5–8 字內，台灣繁體中文}
- 副標題：{解釋性敘述，30–50 字，讓讀者無需原文即可理解核心概念。台灣繁體中文}
- 核心金句：{本張圖卡最應被記住的一句話，驅動整張視覺設計的情緒。必填}
- 內文重點／內容說明：{2–3 個可校稿條列重點；涉及步驟、對比或列舉時，每點 10–15 字。台灣繁體中文}
- 氣氛裝飾文字：{2–3 組，只用 accent 語言；欄位名稱本身嚴禁出現在圖卡上}

### 2. 色彩計畫
- 背景特徵：{與整套圖卡一致的背景風格描述}
- 重點強調色：{本張的強調色，需與整套色系相容}
- 文字色方案：{主標文字顏色} / {背景容器之顏色}

### 3. 字體特徵
- 標題風：{特粗黑體 Extra Bold Gothic 或現代等寬字體，整套統一}
- 裝飾字體：{纖細 Sans-serif 或手寫感字體，僅用於少量 Ashirai}
- 整體印象：{如現代數位感、優雅知性、權威感}

### 4. 佈局與構圖
- 視覺策略：{如中心對稱、卡片堆疊、對角線分割、極簡留白}
- 關鍵元素：{核心幾何圖形或符號，如巨大的箭頭、圓形矩陣}

### 5. 規格與風格
- 尺寸比例：1:1
- 風格關鍵字：{如 Modern Japanese, Minimalist Info-card, High Impact, Clean Overlay}
```

## 填寫範例

以「用第二大腦筆記法擺脫資訊焦慮」的 Slide 01 為例：

```text
## 【圖卡序列 1：資訊焦慮的真相】

### 0. 敘事定位
（本區塊為設計師內部思考記錄，不得將任何內容輸出至圖卡的任何視覺位置）
- 敘事角色：Hook — 以現狀揭露引發滑動動機
- 情緒目標：共鳴感 → 「這就是我每天的狀態」

### 1. 文本內容
- 主標題：筆記越多越焦慮？
- 副標題：收藏了上百篇文章、記了滿滿的筆記，需要用的時候卻一片空白——問題不在你，在方法。
- 核心金句：你不是記性差，是筆記從來沒替你工作過。
- 內文重點／內容說明：（本張不使用）
- 氣氛裝飾文字：Information Overload／Why Notes Fail

### 2. 色彩計畫
- 背景特徵：深藏青單色底，右上角一層低對比的紙張紋理，整體安靜退後。
- 重點強調色：暖橘色，只用於主標題中的「焦慮」二字與一條底線。
- 文字色方案：純白 #FFFFFF / 深藏青半透明容器

### 3. 字體特徵
- 標題風：特粗黑體 Extra Bold Gothic，級距極大。
- 裝飾字體：纖細大寫 Sans-serif，加大 letter-spacing。
- 整體印象：權威感、現代數位感、克制。

### 4. 佈局與構圖
- 視覺策略：中心對稱，文字主導，大面積留白。
- 關鍵元素：主標下方一疊逐漸傾倒的抽象紙張色塊，暗示筆記堆積。

### 5. 規格與風格
- 尺寸比例：1:1
- 風格關鍵字：Modern Japanese Web Style, Minimalist Info-card, High Impact, Clean Overlay
```

## 生圖轉換

交棒 `image-generator` 時，遵循 `../handoff-contracts.md` 的「語言映射契約」：
標題固定繁中欄位宣告，點綴文字與禁用語言否定提示依 `visual-dna.yaml` 的
`language.accent` / `language.forbidden` 變數映射，並遵守其觸發詞紀律
（不得以「{語言} typography / text」形式提到 forbidden 語言）。
適用於第 4 關的全套正式生圖。

## 跨頁視覺一致性生圖規範（Visual DNA Prompt Stacking）

為了確保從 Slide 01 到 Slide NN 整套圖卡的視覺深度、容器質感與配色 100% 一致，交棒 `image-generator` 生成每一頁 Prompt 時，必須採用 **三段式 Prompt 堆疊結構**：

1. **固定 Visual DNA 前綴 (Visual DNA Prefix)**：
   包含從 `visual-dna.yaml` 繼承的完整視覺基底——精確背景色碼（如 `#F7F5F0`）、卡片容器材質（如 `rounded soft translucent frosted glass card #FFFFFFCC`）、莫蘭迪配色方案（`#2C3E50` 與 `#E6A15C`）、以及抽象幾何構圖聲明（`Minimalist abstract geometric shapes only, strictly NO human illustrations, NO face avatars`）。
2. **單頁結構化內容與佈局 (Page Specific Content)**：
   包含該頁特有的文本（`Traditional Chinese title text: "..."`）、副標題或條列點，以及該頁的微觀元件佈局。
3. **固定風格與否定限制後綴 (Style & Negative Suffix)**：
   包含標準風格關鍵字（`Modern Japanese Web Style, Soft Flat Illustration, Warm Pastel, Clean Overlay, High Consistency`）與否定提示（`Strictly NO Japanese hiragana, NO katakana, NO Japanese text, NO human figures`）。

每一頁都必須完整攜帶第一段與第三段，絕不可在 Slide 02..NN 簡化或刪減視覺基底描述，否則會導致各頁材質、容器、配色與插畫元素飄移（例如誤產出人物插畫或遺失玻璃卡片容器）。

## 輸出檔名

依 SKILL.md 的輸出位置規則：

```text
briefs/carousel-proposal-{01|A|B|C}.md  # 第 1 關：A/B 一組，C 三組 Slide 01 展示提案
briefs/carousel-outline.md               # 第 2 關：全套文本大綱
briefs/carousel-full.md                  # 第 3 關：全套 N 組五層提示詞
briefs/approval-log.md                   # 第 1–3 關確認狀態
```

`approval-log.md` 一律由本 skill 的 `assets/carousel-approval-log-template.md` 複製後填寫。

## 語氣

展現設計職人的專業，對細節（字體粗細、色塊透明度、層次感）有精確描述，
充滿審美洞察力。語氣沉穩權威，展現方法論的縝密思考。

## 相關

- `cover.md`：封面版位。單張、高點擊率導向；本版位的風格校準選單與
  創新維度定位方式與其一致。
- `cover-person.md`：人物選項。本版位預設不啟用，使用者主動要求時才讀取。
- `../visual-dna.md`：跨張一致性的唯一來源。
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_REFERENCES_PLACEMENTS_CAROUSEL_MD_5FBC59A164

# visual-prompt-kit/references/placements/cover-person.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/references/placements/cover-person.md")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/references/placements/cover-person.md" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_REFERENCES_PLACEMENTS_COVER_PERSON_MD_BCA09525E0'
# 封面人物選項

`cover` placement 的加購模組。先讀 `cover.md`，本檔只寫**差異**。

人物有兩種模式，**互斥**，由 Phase 2.5 決定：

| | 模式 P 真人空位 | 模式 C 角色插畫 |
|---|---|---|
| 生圖時畫人嗎 | **絕對不畫** | **要畫** |
| 人物來源 | 事後貼真人照片 | 角色設定資產 |
| 第 4 欄欄位 | 人物空位保留區 | 角色配置 |
| 風格關鍵字 | `Empty Talent Placeholder, No Person` | 依角色風格 |

兩模式不得混用：同一張圖不可以既留空位又畫角色。

---

## 模式 P：預留真人空位（Talent Placeholder）

### 無人物鐵則（最高優先）

**優先於本檔與 `cover.md` 的所有其他敘述。**

設計描述最終會交給生圖工具。生成的圖片中**絕對不可出現任何人物、人臉、人體、半身、
剪影、人影、人形輪廓或任何暗示人存在的元素**。

所有「人像」規劃指的都是**預留一塊乾淨的空白區域**，供使用者事後自行貼上真人照片。
生圖階段這塊區域必須是**空的**——只有背景、留白與光影。

「人物空位」是**一個位置**，不是**一個人**。描述它時主詞永遠是「這塊空間／這塊留白／
這個區域」，**絕對不要**寫「一個人、一位人物、他的身體、他的臉、他的姿勢、他的服裝、
他的打光」。

可以說明「這塊空位的比例適合日後貼入胸上半身照」，但生圖時該處必須為空。
若描述會導致生圖模型畫出任何人物，即為嚴重錯誤。

### 空位規劃六要素

每組方案都必須寫齊：

1. **空位位置** — 放在畫面哪一側（左下／右側整條／置中偏右），避免與主標題重疊。
   最安全的是「空位在一側、文字在另一側」的分區構圖。
2. **形狀與尺寸** — 這塊空間的比例適合日後貼入什麼照片（半身／胸上／大頭／站姿），
   佔畫面寬度約幾成。這是空間預留比例，不是要畫人。
3. **層級** — 通常在模糊背景之上、主標題文字容器之下，確保未來貼圖不蓋到標題。
4. **融合方式** — 柔邊漸層／底部漸層融入／色塊襯底／一道輪廓光帶，讓事後貼上的
   照片邊緣能自然融合。
5. **乾淨空間** — 該區背景必須低資訊、無人物，裝飾與文字一律避開。
6. **主光源方向** — 說明畫面主光源從哪來，方便後製時讓人物打光與背景一致。

### 兩處負面指示（必填）

模板**維持五欄，不新增欄位**。無人物負面指示內建在兩個位置，每組方案都要出現：

- **第 2 欄「背景特徵」結尾**，例如：
  > 整體畫面不含任何人物、人臉或人影，人物所在區域維持乾淨留白。
- **第 4 欄「人物空位保留區」結尾**，例如：
  > 此預留區生圖時必須為空，請勿繪製任何人物、人臉、人體或剪影；
  > No person, no face, no human figure — leave this area as clean empty background for later compositing.

第 4 欄的英文負面指示是**給生圖工具的指令**，不是畫面上的視覺文字，不受
「禁止三語混用」限制。

### 對 cover.md 的其他調整

- **主要視覺區塊**改為：一個主標題區、一個人物空白區、一個輔助資訊區。人物空白區
  取代原本「核心視覺物件」的位置角色；除此之外不得再加大型視覺物件。
- **人物空位仍是配角**，主標題仍是第一視覺。
- **三組空位配置必須差異化**，例如分區式（空位在右、文字在左）／滿版單側直條
  （文字壓底部漸層）／嵌入幾何色塊（與切割構圖呼應），方便比較擺放策略。
- 構圖策略可加入「空位焦點法」。
- **風格關鍵字**加入 `Empty Talent Placeholder, No Person`。
- 第 5 欄不變。

### 減法檢查增補

在 `cover.md` 的 10 項之外，再加 4 項：

- [ ] 是否已明確規劃人物空位，且不遮擋主標題、不喧賓奪主？
- [ ] 空位所在區域是否保留足夠乾淨的空間（無裝飾、無文字壓上）？
- [ ] 第 2 欄與第 4 欄結尾是否都寫了無人物負面指示？
- [ ] 整份描述是否完全沒有「畫一個人」的暗示？
      （「人物約佔畫面 85%」「他穿著」「他的表情」這類敘述一律不得出現）

---

## 模式 C：角色插畫

生圖**要畫出角色**。無人物鐵則在本模式**完全不適用**，也不得寫入任何
`No Person` 負面指示——那會讓生圖工具拒畫。

### 角色資產

角色設定是**外部個人資產**，不隨本 skill 發布。預設從資產登錄檔讀取：

```text
{{ASSISTANT_ROOT}}/knowledge/arry-visual-identity.yaml
```

該檔是**指標檔**，只登錄資產位置與 canonical 風格來源，本身不含風格資料。依它取得：

- `asset_roots.codex_character_assets` — 角色設定圖、手勢集、表情集
- `canonical_style_profile` — 角色的權威風格定義

**風格資料的主版本不在本 skill。** 不要在這裡複製一份角色描述；一律從
`canonical_style_profile` 讀取，避免兩處漂移。角色資產缺失時明說，並詢問是否改走
模式 P 或不放人物。

### 規則

- 角色是**配角**，主標題仍是第一視覺。角色不得佔據畫面主導地位。
- 角色仍計入「最多 2-3 個主要視覺區塊」的上限。
- 角色風格必須與 canonical style profile 一致；不要即興改畫風、比例或配色。
- 不得把插畫角色與真人照片混用在同一張圖。
- 不得將角色標註為他人，也不得替角色加上姓名文字——那會撞到
  `cover.md` 的「不自動加入作者名、簽名、浮水印」。
- **三組角色配置必須差異化**：位置、取景（半身／全身／局部）、與文字的層級關係。

### 第 4 欄

模板仍**維持五欄**。在第 4 欄「佈局與構圖」內以一個子項描述**角色配置**：
位置、取景範圍、佔畫面比例、層級（在文字之下或之上）、與背景的融合與光源方向。

不要寫無人物負面指示。

### 減法檢查增補

- [ ] 角色是否為配角，沒有搶走主標題的第一視覺？
- [ ] 角色風格是否與 canonical style profile 一致？
- [ ] 是否沒有替角色加上姓名、簽名或浮水印文字？
- [ ] 三組的角色配置是否有明顯差異？
- [ ] 是否**沒有**誤寫 `No Person` 之類的負面指示？

---

## 語言規則不受影響

兩個模式都沿用 `visual-dna.yaml` 的 `language` 設定。預設 `accent: en`、
`forbidden: [ja]`。模式 P 第 4 欄結尾給生圖工具的英文負面指示是指令、不是畫面文字，
不算進語言限制。
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_REFERENCES_PLACEMENTS_COVER_PERSON_MD_BCA09525E0

# visual-prompt-kit/references/placements/cover.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/references/placements/cover.md")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/references/placements/cover.md" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_REFERENCES_PLACEMENTS_COVER_MD_8E3587E5D5'
# Placement：封面

適用於課程封面、文章封面、YouTube 縮圖、知識型創作者封面、產品 Banner。
單張、高點擊率導向、資訊層級極清楚。

- 預設比例：`16:9`。正方形社群封面用 `1:1`，直式用 `4:5`。使用者未指定時問一次。
- 輸出組數依風格校準結果而定：使用者已選定風格（A 挑編號或 B 描述偏好）
  時輸出 **1 組方案**；使用者說「你決定」（C）或非互動環境時輸出
  **3 組最大差異化方案**。不論路徑，都須完成最終提案與提示詞確認後才正式生圖。

## 角色

以資深數位社群視覺設計師的身分工作：精通現代黑體（Gothic）排版，純熟運用色塊疊加、
幾何分割、漸層與留白，讓畫面保持整潔感的同時具備強烈的標題感與視覺張力。

設計哲學：**先讓人一眼看懂，再讓細節慢慢加分。**

高點擊率不來自裝飾多，而來自主標清楚、視覺焦點明確、資訊層級乾淨、裝飾文字剛好。
你是懂得取捨的視覺編輯，不是把元素堆滿畫面的技師。

## 六個思考階段

依序完成，不可跳過。**Phase 2.5 與 Phase 6 都是互動關卡；沒有使用者明確確認不得
進入下一個生圖動作。**

### Phase 1 洞察（Empathize）

辨別目標受眾身份（職場工作者 / 創作者 / 學習者⋯）與深層動機：他們為什麼點進來、
想解決什麼問題。找出文章中最能打動人心的情緒點——這是視覺設計的起點。

### Phase 2 定義（Define）

提煉 1 個核心訊息（讀完最該記住的一件事），定義這張圖的任務
（驅動點擊 / 建立信任 / 傳遞專業 / 製造好奇），並找到本次提案的**核心金句**。

### Phase 2.5 風格與人物校準（分階段互動）

先把洞察攤給使用者看，**分兩輪依序詢問**風格方向與人物選項。

**第一輪：風格校準**

```text
我已完成文章分析：

- 目標受眾：{簡述}
- 核心訊息：{簡述}
- 情緒方向：{簡述}

在開始提案之前，先確認視覺方向。三種回法都可以：

A. 從下面 5 個候選挑一個編號
   {依 references/style-library.md 篩出的 5 個候選，各附一行「為什麼適合這篇」}
   {並把 5 張預覽圖交給使用者看}

B. 直接描述你的偏好
   色調（深色系／明亮系）、構圖（人像焦點／幾何切割／文字主導）、
   情緒調性（權威專業／溫暖親近／衝擊力強）都可以，講一項也行。

C. 說「你決定」
   我依創新維度軸線給三組最大差異化的方案。
```

**第二輪：人物選項確認（收到第一輪回覆後發起）**

```text
收到視覺風格偏好！接著確認這張封面要不要放人物？

1. 不放 — 純文字與圖形構圖
2. 預留真人空位 — 生圖時不畫人，留一塊乾淨區域，你事後貼自己的照片
3. 放角色插畫 — 依角色設定資產把角色畫進去
```

**分兩輪進行，避免混淆。**
選 2 或 3 時，接著讀 `cover-person.md`，該檔的規則覆蓋本檔的對應段落。
選 2 時「無人物鐵則」的優先級高於本檔所有敘述。

**非互動環境**（`codex exec`、`claude -p`、CI、排程）沒有人能回答，直接走
Phase 3 路徑 B，並在輸出開頭說明本次未經風格校準。只能產出未確認的最終 Cover
提案與提示詞；不得進入 Phase 6 或正式生圖。

### Phase 3 方案定位

依 Phase 2.5 的回覆分兩條路。**判斷準則：使用者選了 A（風格編號）或
B（描述偏好），風格方向即已定案——直接鎖入 `visual-dna.yaml`，
不得再強制使用者在多組變體間做第二次選擇。**

**路徑 A — 使用者給了方向**（選了風格 id、描述了偏好，或兩者都有）

該方向即為定案。寫入 `visual-dna.yaml` 後，**只產出 1 組方案**，
忠實呈現使用者選定的風格。只有使用者**主動要求**多組變體時，
才在該風格框架內提供「精準命中 / 穩健變體 / 驚喜延伸」的變奏。

**路徑 B — 使用者說「你決定」（C）或沒有偏好**

此時才由 AI 依創新維度三點軸線提出 **3 組最大差異化方案**供選擇：

| 方案 | 定位 | 說明 |
|---|---|---|
| A | 勇敢先驅 | 在成熟設計語彙中展現強烈個性 |
| B | 保守 | 安全穩重、信任感強，適合企業或教育場景 |
| C | 革命性 | 突破常規、高度差異化，製造視覺驚喜 |

三組都要完成 Phase 4、Phase 5 的完整提案與提示詞，留待 Phase 6 讓使用者選定其中一組；
選定後才把該組寫入正式 `visual-dna.yaml`。

### Phase 4 發想與減法檢查

每組先發散構圖策略（色塊疊加法 / 幾何切分法 / 空位焦點法 / 文字主導法），
再過減法檢查。沒過不准進模板。

啟用人物選項時，`cover-person.md` 的減法檢查增補項一併執行；路徑 B 時
三組的人物配置策略必須明顯不同。

路徑 B 的三組在視覺上必須有**明顯**差異，讓使用者清楚感受到在選什麼。

### Phase 5 填寫模板

每組方案各自用 codeblock 包住，方便一鍵複製（路徑 A 為 1 組，路徑 B 為 3 組）。

## Phase 6 最終確認與正式生圖

Cover 是單張最終成品，**不產出展示圖**：Phase 2.5 的風格庫預覽圖已負責視覺校準，
額外先生成展示圖只會重複耗用生圖額度。

1. 從 `assets/cover-approval-log-template.md` 建立
   `briefs/cover-approval-log.md`。完成使用者的風格與人物回覆後，把「視覺方向與人物」
   更新為 `confirmed`。
2. 呈現 Phase 5 的完整提案與提示詞，請使用者確認：A／B 必須明確確認唯一提案；
   C 必須從 3 組完整提案中選定 1 組。只有明確回覆後，才能把「最終 Cover 提案與提示詞」
   更新為 `confirmed`。
3. 執行本 skill 的
   `scripts/validate_cover_approvals.py briefs/cover-approval-log.md`。通過並取得 `PASS` 後，
   才交棒 `image-generator` 產出最終 Cover。

若使用者要求更改主標、副標、構圖、人物或任何提示詞內容，將「最終 Cover 提案與提示詞」
改為 `revisions-requested`，回到本階段修訂並再次確認。不得以舊的確認紀錄直接生圖。

## 減法檢查

每組方案進模板前逐項確認：

- [ ] 主標題是不是第一視覺？
- [ ] 所有文字是否有容器或陰影保護？（複雜背景中仍須清晰）
- [ ] Ashirai 是否 2-3 組，且只用 `visual-dna.yaml` 的 `language.accent`？
- [ ] 是否沒有混入 `language.forbidden` 的語言？
- [ ] 主要視覺區塊是否 ≤ 3 個？
- [ ] 裝飾元素是否只保留 2-4 種？
- [ ] 背景是否退後（模糊 / 半透明 / 低對比 / 景深）？
- [ ] 是否沒有自動加入 Logo、簽名、品牌名、作者名、浮水印？
- [ ] 核心金句是否已填？
- [ ] （路徑 B）三組之間的差異是否夠明顯？

啟用人物選項時，另外執行 `cover-person.md` 的增補檢查項。

## 輸出結構

依序給三段：

1. **前期策略思考** — 受眾洞察、核心問題定義；路徑 A 說明選定風格如何
   回應文章調性，路徑 B 說明三組方案在創新維度上的落點。
2. **視覺意象分析** — 解析目標族群，說明打算如何運用半透明色塊疊加、
   強烈字體對比、職人感光影、乾淨留白等元素來精準傳達情緒。
3. **設計指令** — 各自用 codeblock 包住，照下方模板逐欄填寫
   （路徑 A 為 1 組，路徑 B 為 3 組）。

## 輸出模板

**不要壓縮成 `/imagine prompt:` 或任何單段英文描述句。** 唯一合法格式是這份分欄位文件。

```text
## 【指令名稱：專案標題】

### 0. 提案定位
- 創新維度：{軸線落點 + 一句話理由}
- 核心金句：{這組提案的那句話，整組視覺的靈魂錨點。必填}
- 情緒目標：{希望觀看者 3 秒內產生的心理反應}

### 1. 文本內容
- 主標題：{含核心關鍵字，精簡有衝擊力。繁體中文}
- 副標題：{補充主標細節。繁體中文}
- 氛圍裝飾文字 Ashirai：{2-3 組，只用 accent 語言}

### 2. 色彩計畫
- 背景特徵：{背景必須退後，不可搶主標}
- 重點強調色：{只用來凸顯 2-3 個關鍵字}
- 文字色方案：{主標題色} / {色塊或裝飾邊條色}

### 3. 字體特徵
- 標題風：{如特粗黑體 Extra Bold Gothic、粗圓體，強調易讀性與標題感}
- 裝飾字體：{如纖細 Sans-serif、Condensed Sans-serif。僅用於少量 Ashirai}
- 整體印象：{如強勢專業 / 現代數位感 / 優雅職人 / 清爽可信}

### 4. 佈局與構圖
- 文字容器：{必須保護主標題可讀性}
- 視覺焦點：{主體位置與文字覆蓋邏輯，≤ 3 個主要視覺區塊}
- 裝飾元素：{2-4 種。明確寫出哪些保留、哪些不使用}

### 5. 規格與風格
- 尺寸比例：{16:9 / 3:2 / 1:1 / 4:5}
- 風格關鍵字：{如 Modern Japanese Web Style, High Impact, Clean Overlay, Minimal Ashirai}
```

## 填寫範例

以「如何挑選適合遠端辦公的高品質軟體工具」為例：

```text
## 【指令名稱：遠端辦公的究極工具箱】

### 0. 提案定位
- 創新維度：勇敢先驅 — 在熟悉的科技工具感中，以大膽的對角切割構圖製造張力。
- 核心金句：工具選對了，努力才不會白費。
- 情緒目標：共鳴感 → 讓觀看者立刻覺得「這就是我的問題」。

### 1. 文本內容
- 主標題：效率提升 200%！必備軟體清單
- 副標題：從溝通到專案管理，專業人士的真實選擇。
- 氛圍裝飾文字 Ashirai：Smart Tool Selection／Work Better

### 2. 色彩計畫
- 背景特徵：簡潔白色桌面，筆電與一杯咖啡，採光明亮；背景細節以景深模糊處理。
- 重點強調色：藍紫漸層色塊，只用於標題關鍵字與一條視線引導線。
- 文字色方案：純白 #FFFFFF／炭黑 #333333

### 3. 字體特徵
- 標題風：特粗黑體 Extra Bold Gothic，強調功能性與速度感。
- 裝飾字體：纖細 Sans-serif 搭配少量英文小標籤，不使用大面積手寫字。
- 整體印象：強勢專業、現代數位感、乾淨高效。

### 4. 佈局與構圖
- 文字容器：白色半透明圓角矩形，置於畫面左側 60% 區域。
- 視覺焦點：筆電與咖啡杯位於右側，以模糊與低對比處理；第一視覺集中在主標題。
- 裝飾元素：保留一條主標底線、一個小型英文標籤、一組微型星標；
  不使用貼紙、大量側邊文字、重複徽章或多層 UI 卡片。

### 5. 規格與風格
- 尺寸比例：16:9
- 風格關鍵字：Modern Japanese Web Style, High Impact, Clean Overlay, Professional Thumbnail, Minimal Ashirai
```

## 生圖轉換

只在 Phase 6 通過 `validate_cover_approvals.py` 後才可交棒 `image-generator`。交棒時遵循
`../handoff-contracts.md` 的
「語言映射契約」：標題固定繁中欄位宣告，點綴文字與禁用語言否定提示
依 `visual-dna.yaml` 的 `language.accent` / `language.forbidden` 變數映射，
不在本檔寫死任何語言。

## 語氣

展現設計職人的專業與權威，對字體粗細、色塊透明度、層次感、留白比例有精確描述。
但專業不是把畫面塞滿，而是知道什麼該留下、什麼該刪掉。

## 相關

- `cover-person.md`：封面人物選項。模式 P 預留真人空位（生圖不畫人）、
  模式 C 角色插畫（生圖要畫人）。兩者互斥。
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_REFERENCES_PLACEMENTS_COVER_MD_8E3587E5D5

# visual-prompt-kit/references/styles/japanese-modern.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/references/styles/japanese-modern.md")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/references/styles/japanese-modern.md" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_REFERENCES_STYLES_JAPANESE_MODERN_MD_C8BC436093'
# Style：日系現代（Japanese Modern）

```yaml
visual_grammar: japanese-modern
primary_language: zh-TW
accent_language: en
forbidden_languages: [ja]
```

參考日本當代數位產業、線上教育與 3C 科技類的視覺特徵：YouTube 縮圖、專業線上課程
封面、知識型創作者封面、科技產品 Banner。

## 視覺語彙

- 極致易讀性、專業美感、高品質光影
- 明確視覺焦點、克制的裝飾文字
- 現代黑體（Gothic）排版，善用色塊疊加、幾何分割、漸層與留白
- 日本特有的「整潔感」，同時具備強烈的「標題感」與視覺張力

## 語言系統

畫面文字語言層級：

1. **主標題 / 副標題**：台灣繁體中文
2. **Ashirai / 裝飾性文字**：英文
3. **禁止日文裝飾字**

「Ashirai（あしらい）」指的是**裝飾性點綴**這個設計功能，不是語言。日本設計本來就
大量使用英文當裝飾層，中文主體 × 英文點綴是成立的組合。

禁止項包含但不限於：日文短句、日文標籤、日文貼紙、日文側邊字、日文註解、
日文手寫字、日文徽章。除非使用者明確指定，畫面中不得同時出現中文、英文、日文三種語言。

### 為什麼是英文

生圖模型渲染日文假名與漢字的錯字率遠高於英文。系列圖卡一次十張時，這個差異會被放大十倍。

### 要日文點綴時

不要複製這份檔案。把 `visual-dna.yaml` 的 `language.accent` 改成 `ja`、
`language.forbidden` 改成 `[en]` 即可；視覺語彙完全不變。

## 裝飾字體方向

英文手寫體、細襯線、或全大寫細字加大 letter-spacing。僅用於少量 Ashirai，
不可大面積使用。手寫感英文可稍微傾斜或不規則排列，但不得干擾中文主標題。
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_REFERENCES_STYLES_JAPANESE_MODERN_MD_C8BC436093

# visual-prompt-kit/scripts/add_style.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/add_style.py")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/add_style.py" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_SCRIPTS_ADD_STYLE_PY_2961B03564'
#!/usr/bin/env python3
"""Merge one extracted style into the local card-style-library styles.yaml.

Appends the new entry as raw text formatted to match the file's existing
hand-curated block style, instead of round-tripping the whole file through a
YAML dumper — that would risk reformatting the other 100+ entries. See
references/style-extraction.md for the interactive workflow that produces
the arguments to this script.
"""
from __future__ import annotations

import argparse
import json
import os
import re
import sys
from datetime import date
from pathlib import Path

DEFAULT_DIRS = [
    os.environ.get("VISUAL_STYLE_LIBRARY", ""),
    "~/.codex/memories/../knowledge/card-style-library",
]


def resolve_library(explicit: str | None) -> Path:
    cands = [explicit] if explicit else DEFAULT_DIRS
    for c in cands:
        if not c:
            continue
        p = Path(c).expanduser().resolve()
        if p.is_file():
            p = p.parent
        if (p / "styles.yaml").is_file():
            return p
    tried = ", ".join(str(Path(c).expanduser().resolve()) for c in cands if c) or "(none)"
    sys.exit(
        f"style library not found. tried: {tried}\n"
        "pass --library <dir containing styles.yaml>, or set VISUAL_STYLE_LIBRARY."
    )


def yaml_str(s: str) -> str:
    """Double-quoted YAML scalar. JSON string quoting is a valid subset of YAML."""
    return json.dumps(s, ensure_ascii=False)


def yaml_flow_list(items: list[str]) -> str:
    return "[" + ", ".join(items) + "]"


def load(text: str) -> tuple[dict, list[dict]]:
    try:
        import yaml
    except ImportError:
        sys.exit("PyYAML required. install it, or run with an interpreter that has it.")
    data = yaml.safe_load(text)
    meta = data.get("meta") if isinstance(data, dict) else None
    styles = data.get("styles") if isinstance(data, dict) else None
    if not styles:
        sys.exit("no 'styles' list found in styles.yaml")
    return meta or {}, styles


def regenerate_styles_md(lib: Path, yaml_text: str) -> Path:
    """styles.md is the Obsidian-browsable mirror of styles.yaml (identical content).

    Obsidian's file explorer hides .yaml files, so the library keeps an
    auto-generated .md wrapper next to it. Regenerated on every write here;
    never edited by hand.
    """
    md = (
        "# card-style-library styles.yaml 對照版\n\n"
        "本檔由 `styles.yaml` 自動生成，內容與其完全一致，僅供 Obsidian 瀏覽與搜尋。\n"
        "**不要直接編輯本檔**——修改一律進 `styles.yaml`（新增風格用 visual-prompt-kit 的\n"
        "`add_style.py`，它寫入後會自動重新生成本檔）。\n\n"
        "```yaml\n" + yaml_text.rstrip("\n") + "\n```\n"
    )
    out = lib / "styles.md"
    out.write_text(md, encoding="utf-8")
    return out


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--library")
    ap.add_argument("--image", required=True, help="reference image the style was extracted from")
    ap.add_argument("--name-zh", required=True)
    ap.add_argument("--name-en", default="")
    ap.add_argument("--name-ja", default="")
    ap.add_argument("--category", required=True, help="must match an existing meta.categories entry")
    ap.add_argument("--scenes", required=True, help="comma separated, from meta.scenes")
    ap.add_argument("--desc", required=True)
    ap.add_argument("--chars", required=True, help="comma separated tags, library convention is 4")
    ap.add_argument("--prompt", required=True, help="the filled extraction template, as one prompt string")
    ap.add_argument("--origin", default="自訂", help="default 自訂 marks it apart from course-sourced entries")
    ap.add_argument("--extracted-from", default="", help="short provenance note, e.g. source filename")
    ap.add_argument("--id", type=int, help="override the auto-assigned id (default: max existing id + 1)")
    ap.add_argument("--allow-new-category", action="store_true")
    ap.add_argument("--allow-new-scene", action="store_true")
    ap.add_argument("--dry-run", action="store_true", help="print the entry and preview path, write nothing")
    a = ap.parse_args()

    lib = resolve_library(a.library)
    yaml_path = lib / "styles.yaml"
    text = yaml_path.read_text(encoding="utf-8")
    meta, styles = load(text)

    categories = meta.get("categories") or []
    if not a.allow_new_category and a.category not in categories:
        sys.exit(
            f"category {a.category!r} not in library categories: {categories}\n"
            "pass --allow-new-category to add a new one."
        )

    scenes_allowed = meta.get("scenes") or []
    scenes = [s.strip() for s in a.scenes.split(",") if s.strip()]
    if not scenes:
        sys.exit("need at least 1 --scenes tag.")
    if not a.allow_new_scene:
        bad = [s for s in scenes if s not in scenes_allowed]
        if bad:
            sys.exit(
                f"scenes {bad} not in library scenes: {scenes_allowed}\n"
                "pass --allow-new-scene to add new ones."
            )

    chars = [c.strip() for c in a.chars.split(",") if c.strip()]
    if len(chars) < 2:
        sys.exit("need at least 2 --chars tags (library convention is 4).")
    if len(chars) != 4:
        print(f"note: library convention is 4 chars tags, got {len(chars)}.", file=sys.stderr)

    existing_ids = {int(s["id"]) for s in styles}
    new_id = a.id if a.id is not None else (max(existing_ids, default=0) + 1)
    if new_id in existing_ids:
        sys.exit(f"id {new_id} already exists in the library.")
    dup = next((s for s in styles if s.get("name_zh") == a.name_zh), None)
    if dup:
        print(f"warning: name_zh {a.name_zh!r} already used by id {dup['id']}.", file=sys.stderr)

    src = Path(a.image).expanduser().resolve()
    if not src.is_file():
        sys.exit(f"image not found: {src}")

    preview_rel = f"previews/{new_id:03d}.jpg"
    preview_abs = lib / preview_rel

    lines = [f"  - id: {new_id}"]
    lines.append(f"    name_zh: {yaml_str(a.name_zh)}")
    if a.name_ja:
        lines.append(f"    name_ja: {yaml_str(a.name_ja)}")
    if a.name_en:
        lines.append(f"    name_en: {yaml_str(a.name_en)}")
    lines.append(f"    category: {yaml_str(a.category)}")
    lines.append(f"    origin: {yaml_str(a.origin)}")
    lines.append(f"    scenes: {yaml_flow_list(scenes)}")
    lines.append(f"    desc: {yaml_str(a.desc)}")
    lines.append(f"    chars: {yaml_flow_list(chars)}")
    lines.append("    prompt_mode: custom")
    lines.append(f"    preview: {preview_rel}")
    lines.append(f"    prompt: {yaml_str(a.prompt)}")
    if a.extracted_from:
        lines.append(f"    extracted_from: {yaml_str(a.extracted_from)}")
    lines.append(f"    captured_at: {date.today().isoformat()}")
    entry_text = "\n".join(lines) + "\n"

    print(entry_text)
    print(f"preview -> {preview_abs}")

    if a.dry_run:
        print("\n(dry run; nothing written)")
        return

    try:
        from PIL import Image
    except ImportError:
        sys.exit("Pillow required to normalize the preview image. install it, or drop --dry-run.")

    img = Image.open(src).convert("RGB")
    side = min(img.size)
    left = (img.width - side) // 2
    top = (img.height - side) // 2
    img = img.crop((left, top, left + side, top + side)).resize((800, 800), Image.LANCZOS)
    preview_abs.parent.mkdir(parents=True, exist_ok=True)
    img.save(preview_abs, "JPEG", quality=92)
    if preview_abs.read_bytes()[:2] != b"\xff\xd8":
        sys.exit("preview write failed JPEG magic byte check")

    new_count = len(styles) + 1
    new_text = text.rstrip("\n") + "\n" + entry_text
    new_text = re.sub(r"(?m)^(  count: )\d+$", rf"\g<1>{new_count}", new_text, count=1)

    try:
        import yaml
        yaml.safe_load(new_text)  # round-trip sanity check before committing to disk
    except Exception as e:
        sys.exit(f"refusing to write: appended file failed to parse as YAML: {e}")

    yaml_path.write_text(new_text, encoding="utf-8")
    md_path = regenerate_styles_md(lib, new_text)
    print(f"\nwrote id {new_id} to {yaml_path}, count now {new_count}.")
    print(f"regenerated Obsidian mirror doc: {md_path}")


if __name__ == "__main__":
    main()
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_SCRIPTS_ADD_STYLE_PY_2961B03564
chmod +x "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/add_style.py"

# visual-prompt-kit/scripts/recommend_styles.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/recommend_styles.py")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/recommend_styles.py" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_SCRIPTS_RECOMMEND_STYLES_PY_9BAF6A1A56'
#!/usr/bin/env python3
"""Recommend candidate visual styles from a local style library.

The library is external data (see references/style-library.md); this script never
ships one. It filters by scene tags and category, balances the shortlist across
categories and origins, and prints preview image paths so the calling agent can
show them to the user.
"""
from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path

DEFAULT_DIRS = [
    os.environ.get("VISUAL_STYLE_LIBRARY", ""),
    "~/.codex/memories/../knowledge/card-style-library",
]


def resolve_library(explicit: str | None) -> Path:
    cands = [explicit] if explicit else DEFAULT_DIRS
    for c in cands:
        if not c:
            continue
        p = Path(c).expanduser().resolve()
        if p.is_file():
            p = p.parent
        if (p / "styles.yaml").is_file():
            return p
    tried = ", ".join(str(Path(c).expanduser().resolve()) for c in cands if c) or "(none)"
    sys.exit(
        f"style library not found. tried: {tried}\n"
        "pass --library <dir containing styles.yaml>, or set VISUAL_STYLE_LIBRARY."
    )


def load(lib: Path) -> list[dict]:
    try:
        import yaml
    except ImportError:
        sys.exit("PyYAML required. install it, or run with an interpreter that has it.")
    data = yaml.safe_load((lib / "styles.yaml").read_text(encoding="utf-8"))
    styles = data.get("styles") if isinstance(data, dict) else None
    if not styles:
        sys.exit(f"no 'styles' list in {lib / 'styles.yaml'}")
    for s in styles:
        rel = s.get("preview") or f"previews/{int(s['id']):03d}.jpg"
        p = lib / rel
        s["_preview"] = str(p) if p.is_file() else ""
    return styles


def shortlist(styles, scenes, category, exclude, count):
    """Filter, score, then interleave by category so the shortlist stays varied."""
    pool = [s for s in styles if int(s["id"]) not in exclude]
    if category:
        pool = [s for s in pool if s.get("category") == category]
    if scenes:
        scored = []
        for s in pool:
            hits = len(set(scenes) & set(s.get("scenes") or []))
            if hits:
                scored.append((-hits, int(s["id"]), s))
        pool = [s for _, _, s in sorted(scored, key=lambda t: (t[0], t[1]))]

    buckets: dict[tuple, list] = {}
    for s in pool:
        buckets.setdefault((s.get("category"), s.get("origin")), []).append(s)
    out, keys = [], list(buckets)
    while len(out) < count and any(buckets[k] for k in keys):
        for k in keys:
            if buckets[k] and len(out) < count:
                out.append(buckets[k].pop(0))
    return out


def render(rows, as_json):
    if as_json:
        print(json.dumps(
            [{k: v for k, v in r.items() if not k.startswith("_")}
             | {"preview_path": r.get("_preview", "")} for r in rows],
            ensure_ascii=False, indent=2))
        return
    if not rows:
        print("no matching style. widen --scenes, drop --category, or clear --exclude.")
        return
    for n, s in enumerate(rows, 1):
        print(f"{n}. #{s['id']} {s.get('name_zh','')}（{s.get('category','')}）")
        print(f"   場景：{'、'.join(s.get('scenes') or []) or '-'}")
        print(f"   特徵：{'、'.join(s.get('chars') or []) or '-'}")
        print(f"   預覽：{s.get('_preview') or '(缺預覽圖)'}")
    print(f"\n排除本批請加：--exclude {','.join(str(s['id']) for s in rows)}")


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--library")
    ap.add_argument("--scenes", default="", help="comma separated scene tags")
    ap.add_argument("--category", default="")
    ap.add_argument("--exclude", default="", help="comma separated ids already shown")
    ap.add_argument("--count", type=int, default=5)
    ap.add_argument("--id", type=int, help="dump one style in full, including prompt")
    ap.add_argument("--list-scenes", action="store_true")
    ap.add_argument("--json", action="store_true")
    a = ap.parse_args()

    lib = resolve_library(a.library)
    styles = load(lib)

    if a.list_scenes:
        scenes = sorted({t for s in styles for t in (s.get("scenes") or [])})
        cats = sorted({s.get("category") for s in styles if s.get("category")})
        print("scenes:", "、".join(scenes))
        print("categories:", "、".join(cats))
        print("total styles:", len(styles))
        return

    if a.id is not None:
        hit = next((s for s in styles if int(s["id"]) == a.id), None)
        if not hit:
            sys.exit(f"id {a.id} not in library")
        render([hit], True) if a.json else print(
            f"#{hit['id']} {hit.get('name_zh','')}（{hit.get('category','')}）\n"
            f"場景：{'、'.join(hit.get('scenes') or [])}\n"
            f"特徵：{'、'.join(hit.get('chars') or [])}\n"
            f"預覽：{hit.get('_preview') or '(缺預覽圖)'}\n\n"
            f"{hit.get('prompt','')}")
        return

    scenes = [x.strip() for x in a.scenes.split(",") if x.strip()]
    exclude = {int(x) for x in a.exclude.replace(" ", "").split(",") if x}
    render(shortlist(styles, scenes, a.category.strip(), exclude, a.count), a.json)


if __name__ == "__main__":
    main()
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_SCRIPTS_RECOMMEND_STYLES_PY_9BAF6A1A56
chmod +x "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/recommend_styles.py"

# visual-prompt-kit/scripts/validate_carousel_approvals.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/validate_carousel_approvals.py")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/validate_carousel_approvals.py" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_SCRIPTS_VALIDATE_CAROUSEL_APPROVALS_PY_26251E7F86'
#!/usr/bin/env python3
"""Block a carousel final-image handoff until its three approvals are recorded."""

from __future__ import annotations

import argparse
import re
from pathlib import Path


REQUIRED_APPROVALS = ("首張展示提案", "文本大綱", "全套提示詞")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="驗證輪播圖卡是否已完成前三道使用者確認，可進入正式生圖。"
    )
    parser.add_argument(
        "approval_log",
        type=Path,
        help="任務的 briefs/approval-log.md 路徑。",
    )
    return parser.parse_args()


def approval_status(content: str, label: str) -> str | None:
    match = re.search(rf"(?m)^- {re.escape(label)}：([^\s]+)\s*$", content)
    return match.group(1) if match else None


def main() -> int:
    approval_log = parse_args().approval_log
    if not approval_log.is_file():
        print(f"無法正式生圖：找不到確認紀錄：{approval_log}")
        return 1

    content = approval_log.read_text(encoding="utf-8")
    incomplete = [
        label
        for label in REQUIRED_APPROVALS
        if approval_status(content, label) != "confirmed"
    ]
    if incomplete:
        print("無法正式生圖：以下關卡尚未獲使用者明確確認：")
        for label in incomplete:
            print(f"- {label}")
        return 1

    final_status = approval_status(content, "正式生圖")
    if final_status != "not-started":
        print(
            "無法啟動新的正式生圖交棒："
            f"「正式生圖」目前狀態為 {final_status or '缺少狀態'}。"
        )
        return 1

    print("PASS：前三道確認均已完成，可交棒 image-generator 正式生圖。")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_SCRIPTS_VALIDATE_CAROUSEL_APPROVALS_PY_26251E7F86
chmod +x "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/validate_carousel_approvals.py"

# visual-prompt-kit/scripts/validate_carousel_outline.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/validate_carousel_outline.py")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/validate_carousel_outline.py" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_SCRIPTS_VALIDATE_CAROUSEL_OUTLINE_PY_140BB2E0D3'
#!/usr/bin/env python3
"""Validate the editable text-outline contract for carousel Gate 2."""

from __future__ import annotations

import argparse
import re
from pathlib import Path


REQUIRED_FIELDS = (
    "主標題",
    "副標題",
    "核心金句",
    "內文重點／內容說明",
    "氣氛裝飾文字",
)
LOW_DENSITY_MIN_SLIDES = 8
LOW_DENSITY_MAX_SLIDES = 12
SLIDE_HEADER = re.compile(r"(?m)^## Slide (\d{2})\s*$")
TEXT_SECTION = re.compile(r"(?m)^### 1\. 文本內容\s*$")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="驗證輪播圖卡第 2 關的逐張可校稿文本大綱。"
    )
    parser.add_argument(
        "outline_file",
        type=Path,
        help="第 2 關文本大綱 Markdown 檔案。",
    )
    parser.add_argument(
        "--placement",
        choices=("carousel", "carousel-info"),
        required=True,
        help="carousel 為低密度；carousel-info 為高密度。",
    )
    return parser.parse_args()


def split_slides(content: str) -> list[tuple[str, str]]:
    matches = list(SLIDE_HEADER.finditer(content))
    slides: list[tuple[str, str]] = []
    for index, match in enumerate(matches):
        end = matches[index + 1].start() if index + 1 < len(matches) else len(content)
        slides.append((match.group(1), content[match.end() : end]))
    return slides


def validate_slides(placement: str, slides: list[tuple[str, str]]) -> list[str]:
    errors: list[str] = []
    if not slides:
        return ["找不到 `## Slide 01` 格式的逐張文本大綱。"]
    if placement == "carousel" and not (
        LOW_DENSITY_MIN_SLIDES <= len(slides) <= LOW_DENSITY_MAX_SLIDES
    ):
        errors.append(
            "低密度輪播圖卡必須為 "
            f"{LOW_DENSITY_MIN_SLIDES}–{LOW_DENSITY_MAX_SLIDES} 張；目前為 {len(slides)} 張。"
        )

    for slide_number, body in slides:
        prefix = f"Slide {slide_number}"
        if placement == "carousel" and not TEXT_SECTION.search(body):
            errors.append(f"{prefix} 缺少六段結構中的 `### 1. 文本內容`。")
        for field in REQUIRED_FIELDS:
            inline_value = re.compile(
                rf"(?m)^[ \t]*-[ \t]*{re.escape(field)}：[ \t]*\S+"
            )
            nested_value = re.compile(
                rf"(?m)^[ \t]*-[ \t]*{re.escape(field)}：[ \t]*$\n^[ \t]+-[ \t]+\S+"
            )
            if not inline_value.search(body) and not nested_value.search(body):
                errors.append(f"{prefix} 缺少或留白必要欄位：{field}。")
    return errors


def main() -> int:
    args = parse_args()
    outline_path = args.outline_file.resolve()
    if not outline_path.is_file():
        print(f"文本大綱驗證失敗：找不到檔案：{outline_path}")
        return 1

    slides = split_slides(outline_path.read_text(encoding="utf-8"))
    errors = validate_slides(args.placement, slides)
    if errors:
        print("文本大綱驗證失敗：")
        for error in errors:
            print(f"- {error}")
        return 1

    density = "低密度" if args.placement == "carousel" else "高密度"
    range_note = "，符合 8–12 張範圍" if args.placement == "carousel" else ""
    print(
        f"PASS：{density}輪播圖卡第 2 關共有 {len(slides)} 張{range_note}，"
        "逐張五個文本欄位完整。"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_SCRIPTS_VALIDATE_CAROUSEL_OUTLINE_PY_140BB2E0D3

# visual-prompt-kit/scripts/validate_carousel_prompt_plan.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/validate_carousel_prompt_plan.py")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/validate_carousel_prompt_plan.py" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_SCRIPTS_VALIDATE_CAROUSEL_PROMPT_PLAN_PY_4EE16C84BE'
#!/usr/bin/env python3
"""Verify that a Gate 2 text outline and its internal prompt plan cover the same slides."""

from __future__ import annotations

import argparse
import re
from pathlib import Path


SLIDE_HEADER = re.compile(r"(?m)^## Slide (\d{2})\s*$")
PROMPT_BLOCK = re.compile(r"(?ms)^## Slide (\d{2})\s*$.*?^```text\s*$.*?^```\s*$")
PROMPT_BODY_BLOCK = re.compile(
    r"(?ms)^## Slide (?P<number>\d{2})\s*$.*?^```text\s*$\n(?P<body>.*?)^```\s*$"
)

HIGH_DENSITY_PROMPT_SECTIONS = (
    "【任務與畫布】",
    "【共用視覺 DNA】",
    "【本張文字（逐字）】",
    "【本張視覺方向】",
    "【設計自由度】",
    "【不可違反與驗收】",
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="驗證輪播第 2 關內部提示詞計畫與文本大綱張次一致。"
    )
    parser.add_argument(
        "outline_file",
        type=Path,
        help="第 2 關文本大綱 Markdown 檔案。",
    )
    parser.add_argument(
        "prompt_plan_file",
        type=Path,
        help="未展示給使用者的完整提示詞計畫檔案。",
    )
    parser.add_argument(
        "--placement",
        choices=("carousel", "carousel-info"),
        required=True,
        help="carousel 為低密度；carousel-info 為高密度。",
    )
    parser.add_argument(
        "--require-structured-high-density",
        action="store_true",
        help=(
            "要求高密度提示詞的每張 text codeblock 都使用六段輕量結構；"
            "既有舊任務未指定此旗標時仍可做張次相容性驗證。"
        ),
    )
    return parser.parse_args()


def slide_numbers(content: str) -> list[str]:
    return SLIDE_HEADER.findall(content)


def main() -> int:
    args = parse_args()
    outline_path = args.outline_file.resolve()
    plan_path = args.prompt_plan_file.resolve()
    errors: list[str] = []
    if not outline_path.is_file():
        errors.append(f"找不到文本大綱：{outline_path}")
    if not plan_path.is_file():
        errors.append(f"找不到內部提示詞計畫：{plan_path}")
    if errors:
        print("提示詞計畫驗證失敗：")
        for error in errors:
            print(f"- {error}")
        return 1

    outline_numbers = slide_numbers(outline_path.read_text(encoding="utf-8"))
    plan_content = plan_path.read_text(encoding="utf-8")
    plan_numbers = slide_numbers(plan_content)
    complete_prompt_numbers = PROMPT_BLOCK.findall(plan_content)
    prompt_bodies = re.findall(r"(?ms)^```text\s*$\n(.*?)^```\s*$", plan_content)

    if not outline_numbers:
        errors.append("文本大綱沒有任何 `## Slide 01` 區塊。")
    if args.placement == "carousel" and not (8 <= len(outline_numbers) <= 12):
        errors.append(
            "低密度輪播圖卡必須為 8–12 張；"
            f"文本大綱目前為 {len(outline_numbers)} 張。"
        )
    if outline_numbers != plan_numbers:
        errors.append(
            "文本大綱與內部提示詞計畫的張次不一致："
            f"大綱={outline_numbers}；計畫={plan_numbers}。"
        )
    if plan_numbers != complete_prompt_numbers:
        errors.append("每張內部提示詞計畫都必須有一個完整的 `text` codeblock。")
    if len(prompt_bodies) != len(plan_numbers) or any(not body.strip() for body in prompt_bodies):
        errors.append("每張內部提示詞計畫的 `text` codeblock 都必須包含完整提示詞。")
    if args.placement == "carousel" and "### 5. 規格與風格" not in plan_content:
        errors.append("低密度內部提示詞計畫缺少五層 Brief 的 `### 5. 規格與風格`。")
    if args.require_structured_high_density:
        if args.placement != "carousel-info":
            errors.append("`--require-structured-high-density` 只適用於 carousel-info。")
        else:
            prompt_by_slide = {
                match.group("number"): match.group("body")
                for match in PROMPT_BODY_BLOCK.finditer(plan_content)
            }
            for number in plan_numbers:
                body = prompt_by_slide.get(number, "")
                missing_sections = [
                    section
                    for section in HIGH_DENSITY_PROMPT_SECTIONS
                    if section not in body
                ]
                if missing_sections:
                    errors.append(
                        f"Slide {number} 缺少高密度六段提示詞區塊："
                        + "、".join(missing_sections)
                    )

    if errors:
        print("提示詞計畫驗證失敗：")
        for error in errors:
            print(f"- {error}")
        return 1

    structure_note = (
        "，並符合高密度六段輕量結構"
        if args.require_structured_high_density
        else ""
    )
    print(
        f"PASS：{args.placement} 的 {len(plan_numbers)} 張內部提示詞計畫已與文本大綱逐張對應"
        f"{structure_note}。"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_SCRIPTS_VALIDATE_CAROUSEL_PROMPT_PLAN_PY_4EE16C84BE

# visual-prompt-kit/scripts/validate_carousel_workflow.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/validate_carousel_workflow.py")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/validate_carousel_workflow.py" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_SCRIPTS_VALIDATE_CAROUSEL_WORKFLOW_PY_02DAF407B1'
#!/usr/bin/env python3
"""Validate the mandatory four-gate workflow for both carousel placements."""

from __future__ import annotations

import argparse
from pathlib import Path


REQUIRED_MARKERS = {
    "SKILL.md": (
        "首張展示提案確認",
        "文本大綱確認",
        "全套提示詞確認",
        "正式生圖",
        "不得跳過任何確認關卡",
        "briefs/approval-log.md",
        "輪播文本大綱共同欄位與一次規劃規則",
        "scripts/validate_carousel_outline.py",
        "scripts/validate_carousel_prompt_plan.py",
        "固定 8–12 張",
        "scripts/validate_carousel_approvals.py",
        "validate_image_aspect.py --ratio 4:5",
    ),
    "references/placements/carousel.md": (
        "Slide 01 展示圖",
        "## 第 2 關：文本大綱確認",
        "## 第 3 關：全套提示詞確認",
        "## 第 4 關：正式生圖",
        "briefs/approval-log.md",
        "六段正式輸出結構中的第 2 項",
        "scripts/validate_carousel_outline.py",
        "scripts/validate_carousel_prompt_plan.py",
        "scripts/validate_carousel_approvals.py",
    ),
    "references/placements/carousel-info.md": (
        "Slide 01 展示圖",
        "### 第 2 關：文本大綱確認",
        "### 第 3 關：全套提示詞確認",
        "### 第 4 關：正式生圖",
        "briefs/approval-log.md",
        "共同五欄位",
        "scripts/validate_carousel_outline.py",
        "scripts/validate_carousel_prompt_plan.py",
        "scripts/validate_carousel_approvals.py",
        "六段輕量結構",
        "--require-structured-high-density",
        "validate_image_aspect.py --ratio 4:5",
    ),
    "references/handoff-contracts.md": (
        "第 1 關首張展示",
        "第 4 關正式生圖",
        "都標為 `confirmed`",
        "scripts/validate_carousel_approvals.py",
    ),
    "assets/carousel-approval-log-template.md": (
        "首張展示提案：pending",
        "文本大綱：pending",
        "全套提示詞：pending",
        "正式生圖：not-started",
        "scripts/validate_carousel_approvals.py",
    ),
}

FORBIDDEN_MARKERS = {
    "references/placements/carousel.md": (
        "自動交棒 `image-generator` 執行全套實體生圖",
        "大綱確認 ➔ 產出全套 N 張五層架構 Briefs 文件（`carousel-full.md`） ➔ 自動交棒",
    ),
    "references/placements/carousel-info.md": (
        "## 第二輪：組裝生圖交付版本",
        "內容未經確認不得進入第二輪",
    ),
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="驗證低密度與高密度輪播圖卡的四道確認關卡。"
    )
    parser.add_argument(
        "--root",
        type=Path,
        default=Path(__file__).resolve().parents[1],
        help="visual-prompt-kit 套件根目錄；預設為本腳本所在套件。",
    )
    return parser.parse_args()


def validate_required_markers(root: Path) -> list[str]:
    errors: list[str] = []
    for relative_path, markers in REQUIRED_MARKERS.items():
        path = root / relative_path
        if not path.is_file():
            errors.append(f"缺少檔案：{relative_path}")
            continue

        content = path.read_text(encoding="utf-8")
        for marker in markers:
            if marker not in content:
                errors.append(f"{relative_path} 缺少必要標記：{marker}")
    return errors


def validate_forbidden_markers(root: Path) -> list[str]:
    errors: list[str] = []
    for relative_path, markers in FORBIDDEN_MARKERS.items():
        content = (root / relative_path).read_text(encoding="utf-8")
        for marker in markers:
            if marker in content:
                errors.append(f"{relative_path} 仍保留過時流程：{marker}")
    return errors


def main() -> int:
    root = parse_args().root.resolve()
    errors = validate_required_markers(root) + validate_forbidden_markers(root)
    if errors:
        print("輪播流程驗證失敗：")
        for error in errors:
            print(f"- {error}")
        return 1

    print("PASS：輪播圖卡保有四道確認關卡、可校稿文本大綱與一次規劃規則；低密度固定 8–12 張。")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_SCRIPTS_VALIDATE_CAROUSEL_WORKFLOW_PY_02DAF407B1
chmod +x "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/validate_carousel_workflow.py"

# visual-prompt-kit/scripts/validate_cover_approvals.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/validate_cover_approvals.py")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/validate_cover_approvals.py" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_SCRIPTS_VALIDATE_COVER_APPROVALS_PY_7C257F0127'
#!/usr/bin/env python3
"""Block a Cover final-image handoff until its two approvals are recorded."""

from __future__ import annotations

import argparse
import re
from pathlib import Path


REQUIRED_APPROVALS = ("視覺方向與人物", "最終 Cover 提案與提示詞")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="驗證 Cover 封面是否已完成兩道使用者確認，可進入正式生圖。"
    )
    parser.add_argument(
        "approval_log",
        type=Path,
        help="任務的 briefs/cover-approval-log.md 路徑。",
    )
    return parser.parse_args()


def approval_status(content: str, label: str) -> str | None:
    match = re.search(rf"(?m)^- {re.escape(label)}：([^\s]+)\s*$", content)
    return match.group(1) if match else None


def main() -> int:
    approval_log = parse_args().approval_log
    if not approval_log.is_file():
        print(f"無法正式生圖：找不到 Cover 確認紀錄：{approval_log}")
        return 1

    content = approval_log.read_text(encoding="utf-8")
    incomplete = [
        label
        for label in REQUIRED_APPROVALS
        if approval_status(content, label) != "confirmed"
    ]
    if incomplete:
        print("無法正式生圖：以下 Cover 關卡尚未獲使用者明確確認：")
        for label in incomplete:
            print(f"- {label}")
        return 1

    final_status = approval_status(content, "正式生圖")
    if final_status != "not-started":
        print(
            "無法啟動新的 Cover 正式生圖交棒："
            f"「正式生圖」目前狀態為 {final_status or '缺少狀態'}。"
        )
        return 1

    print("PASS：Cover 的兩道確認均已完成，可交棒 image-generator 正式生圖。")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_SCRIPTS_VALIDATE_COVER_APPROVALS_PY_7C257F0127
chmod +x "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/validate_cover_approvals.py"

# visual-prompt-kit/scripts/validate_cover_workflow.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/validate_cover_workflow.py")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/validate_cover_workflow.py" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_SCRIPTS_VALIDATE_COVER_WORKFLOW_PY_FF3C911020'
#!/usr/bin/env python3
"""Validate the mandatory two-gate Cover workflow and its final-image guard."""

from __future__ import annotations

import argparse
from pathlib import Path


REQUIRED_MARKERS = {
    "SKILL.md": (
        "Cover 封面的兩道確認關卡",
        "最終 Cover 提案與提示詞確認",
        "scripts/validate_cover_approvals.py",
        "assets/cover-approval-log-template.md",
    ),
    "references/placements/cover.md": (
        "## Phase 6 最終確認與正式生圖",
        "briefs/cover-approval-log.md",
        "scripts/validate_cover_approvals.py",
        "不產出展示圖",
    ),
    "references/handoff-contracts.md": (
        "Cover 正式生圖",
        "cover-approval-log.md",
        "scripts/validate_cover_approvals.py",
    ),
    "assets/cover-approval-log-template.md": (
        "視覺方向與人物：pending",
        "最終 Cover 提案與提示詞：pending",
        "正式生圖：not-started",
    ),
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="驗證 Cover 封面的兩道確認關卡與正式生圖驗證器。"
    )
    parser.add_argument(
        "--root",
        type=Path,
        default=Path(__file__).resolve().parents[1],
        help="visual-prompt-kit 套件根目錄；預設為本腳本所在套件。",
    )
    return parser.parse_args()


def main() -> int:
    root = parse_args().root.resolve()
    errors: list[str] = []
    for relative_path, markers in REQUIRED_MARKERS.items():
        path = root / relative_path
        if not path.is_file():
            errors.append(f"缺少檔案：{relative_path}")
            continue
        content = path.read_text(encoding="utf-8")
        for marker in markers:
            if marker not in content:
                errors.append(f"{relative_path} 缺少必要標記：{marker}")

    if errors:
        print("Cover 流程驗證失敗：")
        for error in errors:
            print(f"- {error}")
        return 1

    print("PASS：Cover 封面保有兩道確認關卡與正式生圖驗證器。")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_SCRIPTS_VALIDATE_COVER_WORKFLOW_PY_FF3C911020
chmod +x "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/validate_cover_workflow.py"

# visual-prompt-kit/scripts/validate_image_aspect.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/validate_image_aspect.py")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/validate_image_aspect.py" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_SCRIPTS_VALIDATE_IMAGE_ASPECT_PY_825F866365'
#!/usr/bin/env python3
"""Validate PNG image dimensions against a requested aspect ratio."""

from __future__ import annotations

import argparse
import struct
from pathlib import Path


PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"


def parse_ratio(value: str) -> tuple[int, int]:
    try:
        numerator_text, denominator_text = value.split(":", maxsplit=1)
        numerator = int(numerator_text)
        denominator = int(denominator_text)
    except (ValueError, TypeError) as error:
        raise argparse.ArgumentTypeError("比例必須是 `4:5` 形式的正整數比。") from error
    if numerator <= 0 or denominator <= 0:
        raise argparse.ArgumentTypeError("比例的兩個數字都必須大於 0。")
    return numerator, denominator


def read_png_dimensions(path: Path) -> tuple[int, int]:
    with path.open("rb") as image_file:
        header = image_file.read(24)
    if len(header) < 24 or not header.startswith(PNG_SIGNATURE) or header[12:16] != b"IHDR":
        raise ValueError("只支援可讀取 IHDR 的 PNG 檔案。")
    return struct.unpack(">II", header[16:24])


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="以實際 PNG 像素尺寸驗證圖片比例；容許原生工具整數像素四捨五入。"
    )
    parser.add_argument("images", nargs="+", type=Path, help="待驗證的 PNG 圖片。")
    parser.add_argument("--ratio", type=parse_ratio, required=True, help="目標比例，例如 4:5。")
    parser.add_argument(
        "--tolerance-pixels",
        type=float,
        default=1.0,
        help="容許相對於目標寬度的像素誤差；預設 1.0。",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    numerator, denominator = args.ratio
    if args.tolerance_pixels < 0:
        print("比例驗證失敗：`--tolerance-pixels` 不得小於 0。")
        return 1

    errors: list[str] = []
    passed: list[str] = []
    for image_path in args.images:
        path = image_path.resolve()
        if not path.is_file():
            errors.append(f"找不到圖片：{path}")
            continue
        try:
            width, height = read_png_dimensions(path)
        except (OSError, ValueError) as error:
            errors.append(f"無法讀取 {path.name}：{error}")
            continue

        expected_width = height * numerator / denominator
        delta = abs(width - expected_width)
        if delta <= args.tolerance_pixels:
            passed.append(f"{path.name}（{width}×{height}，誤差 {delta:.2f}px）")
        else:
            errors.append(
                f"{path.name} 為 {width}×{height}；目標 {numerator}:{denominator} "
                f"應為寬 {expected_width:.2f}px，誤差 {delta:.2f}px 超過 "
                f"{args.tolerance_pixels:.2f}px。"
            )

    if errors:
        print("比例驗證失敗：")
        for error in errors:
            print(f"- {error}")
        return 1

    print(
        f"PASS：{len(passed)} 張 PNG 均符合 {numerator}:{denominator}，"
        f"容許整數像素誤差 {args.tolerance_pixels:.2f}px。"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_SCRIPTS_VALIDATE_IMAGE_ASPECT_PY_825F866365

test -f "{{SYNC_ROOT}}/skills/visual-prompt-kit/SKILL.md" && echo "visual-prompt-kit installed for Codex, Claude, and AntiGravity"
````

安裝完成後，請開新 Agent 對話或重啟對應 App，再測試 skill 是否能被讀取。

<!-- END EMBEDDED_SKILLS -->
