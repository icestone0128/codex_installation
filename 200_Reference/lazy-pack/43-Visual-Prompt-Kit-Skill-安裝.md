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
description: Use when the user wants to turn an article, note, or topic into visual design briefs for AI image generation, including 封面 Prompt, 課程封面, 圖卡 Prompt, 系列圖卡, 銷售頁圖片 Prompt, 縮圖, thumbnail, banner, or explicit $visual-prompt-kit invocation. Reads a local style library to recommend candidate styles with preview images, locks a shared visual DNA so a series stays consistent, and emits structured design briefs. This skill produces briefs only; image generation is handed to image-generator and page or carousel assembly to social-cards or landing-page.
metadata:
  short-description: Article to visual design briefs
---

# Visual Prompt Kit

把一篇文章變成可直接生圖的**視覺設計提案**。

這個 skill 只產出 brief，不產圖、不組版。單一職責讓同一份視覺 DNA 能同時餵給封面、
系列圖卡與銷售頁圖，不必每個版位重講一次風格。

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
「銷售頁圖片 Prompt」、「幫我做縮圖」、「把這篇文章做成封面」。

若使用者要的是**成品**而非 brief，先確認路由：品牌模板圖卡走 `social-cards`，
銷售頁組版走 `landing-page`，直接生圖走 `image-generator`。

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

**第二輪：人物選項確認（等使用者回答第一輪後才詢問）**
收到第一輪風格回覆後，**再發起第二輪詢問人物選項**（版位支援時）：
- 1. 不放人物 — 純文字與圖形構圖
- 2. 預留真人空位 — 生圖時不畫人，預留乾淨區域供事後貼入真人照片
- 3. 放角色插畫 — 依角色設定資產把角色畫進去

**沒有使用者回覆不得進入下一步**，非互動環境除外——那時直接走 C、不放人物，
並在輸出開頭說明未經校準。

風格庫的位置、schema、選單格式與缺庫時的退路見 `references/style-library.md`；
校準結果如何決定三組方案的定位見該 placement 檔。

### 3. 鎖定 visual DNA

使用者選定後，把風格 id、配色、字體階層、`accent_language`、構圖原則與禁止項
寫進 `visual-dna.yaml`。**同一主題的所有圖都讀這一份**，系列感來自這裡，
不是靠每張圖重複描述。schema 見 `references/visual-dna.md`。

### 4. 產出設計提案

依 placement 檔指定的模板輸出。除非該 placement 另有規定，一律：

- 提 3 組方案，各自用 codeblock 包住方便複製。
- 三組定位由步驟 2 的校準結果決定：使用者給了方向就以它為 Design Anchor
  做「精準命中 / 穩健變體 / 驚喜延伸」；沒給方向才走「勇敢先驅 / 保守 / 革命性」
  的最大差異化。兩種情況下三組視覺都必須有明顯差異。
- 每組先過減法檢查再寫模板。

### 5. 交棒

自己不生圖、不組版。交棒契約見 `references/handoff-contracts.md`。

## 輸出位置

```text
100_Todo/projects/visual-prompt-kit/YYYY-MM-DD-{topic-slug}/
├── visual-dna.yaml
└── briefs/<placement>-<variant>.md
```

沒有 `100_Todo/` 時使用最接近的專案本地輸出資料夾，並在回報中寫明實際路徑。

## 硬規則

1. 只產出 brief。不呼叫生圖工具、不寫 HTML、不組頁面。
2. 不輸出 Midjourney / Stable Diffusion 的單段指令語法。輸出是結構化提案文件。
3. 不自動加入 Logo、簽名、品牌名、作者名或浮水印，除非使用者明確要求。
4. 主標題與副標題一律台灣繁體中文。裝飾文字只能使用 style 檔 `accent_language`
   指定的那一種語言，且不得三語混用。
5. 一組方案最多 2-3 組裝飾文字、2-4 種裝飾元素、3 個主要視覺區塊。
6. 背景必須退後：可有質感，不可有搶走主標題的可辨識細節。
7. 只使用使用者提供的文章內容。不從記憶、人設或其他專案補料。
8. 風格校準是必要互動關卡，不可跳過；非互動環境改走「無偏好」路徑並明說。
9. 所有文字必須有容器或陰影保護，複雜背景中仍須清晰。核心金句每組必填。
10. 風格庫與角色設定若含第三方、付費課程或個人資產，不得複製進本 skill、
    public repo 或 LazyPack；只保留讀取機制與路徑指標。
11. 啟用「預留真人空位」時，無人物鐵則優先於所有其他規則：生圖不得畫出任何
    人物、人臉、人體或剪影。啟用「角色插畫」時反之，不得寫入任何 No Person 指示。

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
- **Verification**：候選數量為 5、每個都有推薦理由與可存取的預覽圖路徑、
  使用者明確選定後才寫入 `visual-dna.yaml`。

## 參考檔

- `references/style-library.md`：風格庫位置、schema、篩選與選單流程。
- `references/visual-dna.md`：`visual-dna.yaml` schema 與系列一致性規則。
- `references/handoff-contracts.md`：交棒給 image-generator / social-cards / landing-page。
- `references/placements/cover.md`：封面版位（課程封面、文章封面、縮圖）。
- `references/placements/cover-person.md`：封面人物選項。模式 P 預留真人空位
  （生圖不畫人）、模式 C 角色插畫（生圖要畫人），兩者互斥。
- `references/styles/japanese-modern.md`：日系現代風格（繁中主體、英文點綴）。
- `scripts/recommend_styles.py`：從風格庫篩出候選並輸出預覽圖路徑。
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_SKILL_MD_0E95F5A366

# visual-prompt-kit/agents/openai.yaml
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/agents/openai.yaml")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/agents/openai.yaml" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_AGENTS_OPENAI_YAML_DEB9755D27'
interface:
  display_name: "視覺提案套件"
  short_description: "文章轉視覺設計提案，附風格候選與預覽圖，只出 brief 不出圖"
  default_prompt: "Use $visual-prompt-kit to turn an article into visual design briefs."
AGENT_LAZYPACK_VISUAL_PROMPT_KIT_AGENTS_OPENAI_YAML_DEB9755D27

# visual-prompt-kit/references/handoff-contracts.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/visual-prompt-kit/references/handoff-contracts.md")"
cat > "{{SYNC_ROOT}}/skills/visual-prompt-kit/references/handoff-contracts.md" <<'AGENT_LAZYPACK_VISUAL_PROMPT_KIT_REFERENCES_HANDOFF_CONTRACTS_MD_F59DB8C89B'
# 交棒契約

本 skill 只產出 brief。實際產圖與組版一律交給下游，呼叫方向單向，不會循環。

```text
visual-prompt-kit  →  image-generator   生圖
                   →  social-cards      圖卡組版與匯出
                   →  landing-page      銷售頁組版
```

## → image-generator

交出：`visual-dna.yaml` 路徑、選定 brief 的完整內容、目標比例、輸出檔名與存放路徑。

由 `image-generator` 決定實際使用哪個 Agent 的原生生圖能力。本 skill 不指定 provider、
不要求 API key、不自行建立生圖腳本。

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
- 預設輸出：3 組方案。

## 角色

以資深數位社群視覺設計師的身分工作：精通現代黑體（Gothic）排版，純熟運用色塊疊加、
幾何分割、漸層與留白，讓畫面保持整潔感的同時具備強烈的標題感與視覺張力。

設計哲學：**先讓人一眼看懂，再讓細節慢慢加分。**

高點擊率不來自裝飾多，而來自主標清楚、視覺焦點明確、資訊層級乾淨、裝飾文字剛好。
你是懂得取捨的視覺編輯，不是把元素堆滿畫面的技師。

## 五個思考階段

依序完成，不可跳過。**Phase 2.5 是互動關卡，沒有使用者回覆不得進入 Phase 3。**

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
Phase 3 路徑 B，並在輸出開頭說明本次未經風格校準。

### Phase 3 創新維度定位

依 Phase 2.5 的回覆分兩條路。

**路徑 A — 使用者給了方向**（選了風格 id、描述了偏好，或兩者都有）

把該方向設為 **Design Anchor**。三組都必須回應它，但在它的框架內差異化：

| 方案 | 定位 | 說明 |
|---|---|---|
| A | 精準命中 | 最貼近使用者描述的版本，忠實呈現 |
| B | 穩健變體 | 在偏好基礎上收斂，更安全穩重，適合正式場景 |
| C | 驚喜延伸 | 在偏好基礎上大膽延伸，帶實驗性 |

**路徑 B — 使用者沒有偏好**

回到三點軸線，追求最大差異化：

| 方案 | 定位 | 說明 |
|---|---|---|
| A | 勇敢先驅 | 在成熟設計語彙中展現強烈個性 |
| B | 保守 | 安全穩重、信任感強，適合企業或教育場景 |
| C | 革命性 | 突破常規、高度差異化，製造視覺驚喜 |

### Phase 4 發想與減法檢查

每組先發散構圖策略（色塊疊加法 / 幾何切分法 / 空位焦點法 / 文字主導法），
再過減法檢查。沒過不准進模板。

啟用人物選項時，`cover-person.md` 的減法檢查增補項一併執行，且三組的人物
配置策略必須明顯不同。

三組在視覺上必須有**明顯**差異，讓使用者清楚感受到在選什麼。

### Phase 5 填寫模板

三組方案各自用 codeblock 包住，方便一鍵複製。

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
- [ ] 三組之間的差異是否夠明顯？

啟用人物選項時，另外執行 `cover-person.md` 的增補檢查項。

## 輸出結構

依序給三段：

1. **前期策略思考** — 受眾洞察、核心問題定義、三組方案在創新維度上的落點
   （路徑 A 時改為說明 Design Anchor 與三組如何在其框架內變奏）。
2. **視覺意象分析** — 解析目標族群，說明打算如何運用半透明色塊疊加、
   強烈字體對比、職人感光影、乾淨留白等元素來精準傳達情緒。
3. **三組設計指令** — 各自用 codeblock 包住，照下方模板逐欄填寫。

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

test -f "{{SYNC_ROOT}}/skills/visual-prompt-kit/SKILL.md" && echo "visual-prompt-kit installed for Codex, Claude, and AntiGravity"
````

安裝完成後，請開新 Agent 對話或重啟對應 App，再測試 skill 是否能被讀取。

<!-- END EMBEDDED_SKILLS -->
