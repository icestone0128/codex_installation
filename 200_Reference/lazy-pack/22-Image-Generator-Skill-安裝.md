# 22-Image-Generator-Skill-安裝

> 版本：2026-05-25 三 Agent 共用版
> 用途：建立 `image-generator` 全域 skill，讓使用者用自然語句在 Codex、Claude、AntiGravity 裡生圖、修圖、寫圖像提示與整理圖片資產。
> 成品：下載者可直接使用本文文末「內建 Skill 完整安裝內容」建立 `{{SYNC_ROOT}}/skills/image-generator/`；預設優先當前 Agent 的原生生圖通道，缺少時再使用已核准 API／CLI／手動 fallback。

## 來源與歷史紀錄

- 初次同步日期：2026-05-25。
- 來源文件：`08-用Image Gen Skill在Codex生圖.md`。
- 三 Agent 共用全域 skill：`{{SYNC_ROOT}}/skills/image-generator/SKILL.md`。
- 這版定位：以當前 Agent 的原生 image generation capability 作為一般生圖與修圖入口；若該 Agent 沒有原生通道，依序改走已核准 API／CLI／手動流程。

## 這版和來源文件的差異

| 項目 | 三 Agent 共用版調整 |
|---|---|
| 1 | 將來源工具路徑、命令與 frontmatter 假設轉成共用核心及三個 Agent adapter。 |
| 2 | 不預設要求 `OPENAI_API_KEY`；一般生圖、修圖與提示設計先走當前 Agent 的原生影像生成能力。 |
| 3 | 使用可攜式路徑 `{{SYNC_ROOT}}/skills/image-generator/`，不寫入個人電腦絕對路徑。 |
| 4 | 把新手教學整理成可由三 Agent 觸發的共用 workflow 與 reference 文件。 |

## 安裝方式

1. 打開本文文末「內建 Skill 完整安裝內容」。
2. 把整段安裝腳本複製到自己的環境執行。
3. 執行前先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。
4. 安裝後依 Item 16 確認三 Agent 原生入口，分別重載 skill 清單。

## 驗證

```bash
test -f "{{SYNC_ROOT}}/skills/image-generator/SKILL.md" && echo "image-generator SKILL.md ok"
test -f "{{SYNC_ROOT}}/skills/image-generator/references/imagegen-codex-workflow.md" && echo "image-generator reference ok"
```

合理結果是每一行都顯示 `ok`。

## 使用方式

安裝後可用下列語句觸發：

- 「使用 image-generator 幫我生成一張教學封面圖」
- 「幫我畫一張 16:9 的數學闖關遊戲背景圖」
- 「幫我把這張圖改成 YouTube 縮圖風格」
- 「幫我寫一段適合 Codex 生圖的提示詞」
- 「生成一個透明背景的課程徽章素材」

觸發語意包含：image-generator、generate image、生圖、修圖、圖片編輯、圖像提示、封面、插圖、角色、背景、透明背景素材、縮圖、漫畫分鏡、教學圖片。

## 預設工作流程

1. 判斷任務是生圖、修圖、提示詞撰寫，還是圖片資產整理。
2. 擷取用途、比例、主體、場景、風格、色彩、文字需求與限制。
3. 一般情況直接使用當前 Agent 的原生 image generation capability；缺少時才走已核准 fallback，不要無故要求使用者設定 API key。
4. 預設建議圖片不要含文字；重要文字後續用簡報、HTML、Canva 或其他編輯工具加入。
5. 若使用者指定專案或 Obsidian 位置，完成後才回報實際檔案路徑。

## 踩坑紀錄

### 1. 不要把 API key 當成新手必備

當前 Agent 的原生生圖和外部 API 是兩條路。一般生圖、修圖、教材視覺與圖片提示先用原生能力；只有缺少原生通道、大量批次、自動化或成本追蹤需求才考慮已核准 API／CLI。

### 2. 不要把來源工具專屬路徑帶進共用核心

正式版使用三 Agent 共用主版本 `{{SYNC_ROOT}}/skills/image-generator/`。來源工具命令或 metadata 改寫為共用規則與各 Agent adapter。

### 3. 圖中文字通常要保守

若圖片需要標題、按鈕字或精準中文，優先生成「無文字」視覺，再用簡報、HTML、Canva 或其他工具加文字。

## 最終檢查清單

- [ ] `{{SYNC_ROOT}}/skills/image-generator/SKILL.md` 存在。
- [ ] `{{SYNC_ROOT}}/skills/image-generator/references/imagegen-codex-workflow.md` 存在。
- [ ] package 共用核心沒有來源工具專屬路徑、單一 Agent frontmatter 或無條件 API key 要求。
- [ ] Codex、Claude、AntiGravity 重載後，都可用 `image-generator`、生圖、修圖或圖片提示相關語句觸發。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊。這個序號項目會安裝：`image-generator`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請依 README 設定 `{{SYNC_ROOT}}`；package 只寫入共用主版本，Item 16 與 chezmoi 會建立 Codex、Claude、AntiGravity 的原生入口。

````bash
set -e

# ---- image-generator ----
mkdir -p "{{SYNC_ROOT}}/skills/image-generator"
# image-generator/SKILL.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/image-generator/SKILL.md")"
cat > "{{SYNC_ROOT}}/skills/image-generator/SKILL.md" <<'AGENT_LAZYPACK_IMAGE_GENERATOR_SKILL_MD_0E95F5A366'
---
name: image-generator
description: Use when the user asks to generate, edit, restyle, or prepare images in Codex, Claude, or AntiGravity, including 生圖, 修圖, 圖像提示, 教學圖片, 封面, 插圖, 角色, 背景, transparent-background assets, thumbnails, comic panels, or visual assets for slides, websites, games, and Obsidian notes. Use the active agent's native image tool when available, with a shared approved fallback route.
metadata:
  short-description: Generate and edit images across three agents
---

# Image Generator

Use this skill as the shared image-generation workflow for Codex, Claude, and
AntiGravity. It is a lightweight front door to the active agent's native image
capability or an approved shared fallback, not an automatic API-key setup.

## Core Rule

- For ordinary image creation, style exploration, or image editing, use the
  active agent's native image generation capability when it is available.
- Do not ask the user to set `OPENAI_API_KEY` for normal image work.
- Do not create API scripts, billing setup, batch-generation workflows, or CLI
  routes unless the user explicitly asks for API automation.
- Keep the shared package under `{{SYNC_ROOT}}/skills/image-generator`; native
  metadata or commands belong only in the corresponding Agent adapter.

## Agent Execution Notes

- Shared steps: use the same visual brief, source images, safety rules, output
  format, placement path, and acceptance criteria.
- Codex adapter: use the active native image generation/editing tool. Do not
  require the user to select a model name or configure an API key for this
  route.
- Claude adapter: use Claude's native image-capable tool when exposed; otherwise
  use the approved shared image CLI/API or browser/manual route.
- AntiGravity adapter: use AntiGravity's native image tool (`nanobanana 2` model
  configuration when applicable).
- Fallback: ask before enabling a paid/API route; if no generation route is
  authorized, deliver the final prompt and exact placement/verification steps.
- Verification: confirm subject fidelity, dimensions/aspect ratio, text policy,
  requested edits, file readability, and final placement identically.

## When To Use

Use this skill when the user asks for:

- new images, illustrations, covers, thumbnails, backgrounds, teaching visuals,
  game assets, badges, icons, comics, storyboards, or social visuals;
- edits to an attached or referenced image, such as restyling, changing the
  background, adjusting composition, creating variants, or making transparent
  assets;
- image prompts for later generation;
- guidance on where generated images should be saved or copied inside a project,
  Obsidian vault, slide deck, website, or asset folder.

If the request is really a deterministic diagram, chart, UI mockup, PowerPoint
layout, SVG icon, or code-native canvas element, decide whether a code/vector
tool is more appropriate before using image generation.

## Workflow

1. Identify the output intent: image generation, image editing, prompt writing,
   or asset placement.
2. Extract the minimum useful prompt fields:
   - purpose;
   - aspect ratio or target size;
   - subject and scene;
   - style;
   - colors;
   - text policy;
   - constraints and exclusions.
3. If enough information is present, generate or edit directly. Ask a short
   clarification only when the missing detail changes the output materially.
4. Prefer "no text" for images unless the user explicitly needs text in the
   image. Important text is usually better added later in slides, HTML, Canva,
   or another editor.
5. After generation, report the useful result and any local path or project
   placement action that was actually completed.

### Visual Prompt Kit｜Concept Card（1:1）

當上游 `visual-prompt-kit` 交出「Concept Card 正式生圖」時，這不是一般封面或長內容知識圖卡。
它只生成 **1 張 1:1 的極簡手繪概念圖卡**，必須保持一個核心命題、單一視覺隱喻與大量留白。

開始前必須檢查交接包中的 `briefs/concept-card-approval-log.md`，並執行：

```text
{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/validate_concept_card_approvals.py \
  briefs/concept-card-approval-log.md
```

只有 `PASS` 才能啟動原生生圖；缺少交接包、三道確認未完成，或 `person.mode` 不是 `none` 時，
停止並回到上游確認流程。不得用未確認的提案、預覽圖或其他 Concept Card 的內容代替。

交接包必須包含 `visual-dna.yaml`、唯一的 `briefs/concept-card-final.md`、圖中文字白名單、
目標比例和指定輸出路徑。這條路徑是「文字例外」：主標、副標與最多三個必要標籤必須依白名單
逐字生成，不能因一般圖片的無文字偏好而移除或自行改寫；其他文字一律排除。

生成後必須驗收：實際像素為 1:1、白名單以外的文字不存在、沒有任何人物／人臉／手部／剪影／人形
輪廓、沒有多欄資訊圖或複雜流程圖，且遮住文字後仍能看懂物件、動作與結果。任何一項失敗時，
只針對失敗項重生，不得裁切、拉伸或靜默交付。完整交接與驗收規格見
`references/concept-card-generation.md`。

### 全文章最高密度知識圖卡（9:16）

當使用者提供完整文章並明確要求「知識圖卡」、「盡量全部包含」或「最高密度」時，預設是
**單張 9:16 直式深度知識圖卡**，不是只放標題、金句與三個摘要的語錄卡。若使用者已指定
風格，直接沿用；未指定時才由上游視覺提案流程完成風格選擇。

生成前必須先建立可讀的內容覆蓋計畫，至少涵蓋原文中實際存在的：

1. 故事或問題情境；
2. 原因、心理機制或矛盾；
3. 核心框架、判斷法或關鍵區辨；
4. 行動方法、步驟或資源；
5. 結論或核心金句。

不可因插畫美感把其中任何一類縮成一句泛泛摘要。把所有會出現在卡上的文字以逐字清單放進
Prompt；插畫、分隔線、箭頭與小圖示只服務於閱讀順序，不得覆蓋、擠壓或取代知識文字。
使用 `scripts/validate_high_density_knowledge_card_plan.py` 先驗證計畫結構，再生成。

生成後依序檢查：文章五類內容是否真的都被呈現、逐字文本是否可讀且無憑空增寫、只有明列的
外語點綴文字、沒有敘事頁碼／Logo／浮水印，及實際像素是否符合目標比例。目標為 9:16 時，
使用 `scripts/validate_image_aspect.py --ratio 9:16 <image.png>`；不通過時只重生失敗成品，
不得裁切、拉伸或靜默交付。

三個 Agent 共用同一份內容覆蓋計畫、Prompt 與驗收結果：Codex 使用原生 image tool、Claude
使用其原生 image tool、AntiGravity 使用其原生 image tool；原生工具不可用時才依既有規則取得
使用者同意後走 shared fallback。工具不同不改變文字覆蓋、比例與驗收契約。

## Prompt Template

```text
Generate an image:
Purpose:
Aspect ratio:
Subject:
Scene:
Style:
Colors:
Text:
Constraints:
```

## Editing Images

When the user provides or references an image:

- preserve the user-specified subject, identity, composition, or object if they
  ask to keep it;
- state the intended edit in the prompt rather than rewriting the whole image
  from scratch;
- for transparent-background assets, request a clean isolated subject and avoid
  complex semi-transparent edges when possible;
- if the user needs project assets, copy or move the final file only when a
  concrete destination is requested and available.

## Safety And Secrets

- Never ask the user to paste API keys into chat, `AGENTS.md`, Obsidian notes,
  or repo files.
- If an API route is explicitly requested, keep secrets in local environment
  variables or ignored local files only.
- For public LazyPack documentation, keep paths portable with placeholders such
  as `{{CODEX_HOME}}`, `{{PROJECT_ROOT}}`, and `{{OBSIDIAN_VAULT}}`.

## Reference

Read `references/imagegen-codex-workflow.md` for examples, native adapter guidance,
and common pitfalls. For full-article 9:16 knowledge cards, read
`references/high-density-knowledge-card.md` and use its content-coverage template.
For an approved single-concept 1:1 card from `visual-prompt-kit`, read
`references/concept-card-generation.md`.
AGENT_LAZYPACK_IMAGE_GENERATOR_SKILL_MD_0E95F5A366

# image-generator/references/concept-card-generation.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/image-generator/references/concept-card-generation.md")"
cat > "{{SYNC_ROOT}}/skills/image-generator/references/concept-card-generation.md" <<'AGENT_LAZYPACK_IMAGE_GENERATOR_REFERENCES_CONCEPT_CARD_GENERATION_MD_7ED610DB59'
# Concept Card 正式生圖交接規格

此規格只處理由 `visual-prompt-kit` 已確認後交出的 **單張 1:1 極簡概念圖卡**。它不是 Cover，
不保留封面人物；也不是高密度知識圖卡，不摘要全文或加入步驟、列表與多欄資訊。

## 啟動閘門

下游只接受下列任務結構：

```text
100_Todo/projects/visual-prompt-kit/YYYY-MM-DD-{topic-slug}/
├── visual-dna.yaml
├── briefs/
│   ├── concept-card-final.md
│   └── concept-card-approval-log.md
└── assets/images/
```

執行前在任務目錄中驗證：

```text
{{SYNC_ROOT}}/skills/visual-prompt-kit/scripts/validate_concept_card_approvals.py \
  briefs/concept-card-approval-log.md
```

預期輸出必須是 `PASS：Concept Card 三道確認均已完成，可交棒 image-generator 正式生圖。`。
若不通過、缺少 `concept-card-final.md`、缺少 `visual-dna.yaml`，或 `person.mode` 不是 `none`，
不得生成；清楚指出哪個閘門未通過，回到上游流程。

## 生圖輸入契約

以 `concept-card-final.md` 為唯一內容來源，不自行擴寫文章。原生生圖 Prompt 至少逐項轉入：

- 核心命題、核心視覺隱喻、主要物體、動作／變化與語意驗證；
- 1:1 畫布、中央或中段單一圖解、大量乾淨留白；
- 背景、手繪線條、色彩與字體的 Design Anchor；
- 主標、副標、必要標籤的逐字繁中白名單；
- `person.mode: none` 與所有排除項目。

Prompt 必須明示：只有白名單的台灣繁體中文文字可以出現；禁止英文、日文、Logo、署名、
浮水印、假文字與未核准標籤。主標與副標不是選配，不得因「少文字」而省略；然而不得加入
完整段落、方法清單、案例、日期或促銷資訊。

## 原生生圖與檔案落點

1. 預設使用當前 Agent 的原生生圖工具；不要求 API key、模型名稱或 CLI fallback。
2. 一次只生成 1 張最終圖。Concept Card 沒有示意圖或多方案生圖階段。
3. 若使用者指定存檔，或成品將被專案引用，將選定成品放到：

   ```text
   100_Todo/projects/visual-prompt-kit/YYYY-MM-DD-{topic-slug}/assets/images/
   ```

   不得覆寫同名既有圖檔；重生使用版本化檔名。
4. 若原生工具無法直接保留指定文字、比例或無人物規格，回報限制並等待使用者決定是否改用已核准
   的 fallback；不得私自換用付費 API 或改變已確認內容。

## 驗收與重生

完成後依序檢查：

1. 以 `scripts/validate_image_aspect.py --ratio 1:1 <image.png>` 驗證實際像素。
2. 只出現白名單內的繁體中文字；沒有英文、日文、亂碼或假文字。
3. 沒有任何人物、人臉、手部、剪影或人形輪廓。
4. 只有一個主要物件或不可拆分的一組場景；沒有多欄資訊圖、心智圖、Dashboard、複雜流程圖。
5. 畫面保留大量留白，具備黑／深灰手繪線條與最多兩種有語意的強調色；沒有寫實光影、3D、漸層
   或無關裝飾。
6. 遮住文字後，仍可從物件、動作與結果讀出核心命題。

有任一失敗時，僅重生該張圖片並重做完整驗收。不得以裁切、拉伸、人工補入未確認文字或
口頭聲稱通過取代驗收。
AGENT_LAZYPACK_IMAGE_GENERATOR_REFERENCES_CONCEPT_CARD_GENERATION_MD_7ED610DB59

# image-generator/references/high-density-knowledge-card.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/image-generator/references/high-density-knowledge-card.md")"
cat > "{{SYNC_ROOT}}/skills/image-generator/references/high-density-knowledge-card.md" <<'AGENT_LAZYPACK_IMAGE_GENERATOR_REFERENCES_HIGH_DENSITY_KNOWLEDGE_CARD_MD_1A517138D5'
# 全文章最高密度知識圖卡契約

適用於使用者提供一篇完整文章，並要求「知識圖卡」、「盡量全部包含」或「最高密度」時。
成品是**一張 9:16 直式、可獨立閱讀的深度知識圖卡**；它不是輪播圖卡，也不是只放一則
金句的海報。

## 先做內容覆蓋，而非先想插畫

先從原文抽出所有可獨立理解的論點，按下列五類映射到圖卡。若原文沒有某一類，可明確標記
「原文無此類」，不可捏造；若有，就不能為了畫面簡潔而刪成泛泛摘要。

| 覆蓋類別 | 要回答的問題 |
|---|---|
| 故事或問題情境 | 發生了什麼？讀者正卡在哪裡？ |
| 原因／心理機制 | 為什麼會發生？彼此各處於什麼狀態？ |
| 核心框架／判斷法 | 用什麼概念重新理解問題？ |
| 行動方法 | 下一步怎麼做？順序或邊界是什麼？ |
| 結論／核心金句 | 最後必須帶走的判斷或提醒是什麼？ |

## 生成前計畫檔

在任務目錄建立 `briefs/knowledge-card-content.md`，再執行：

```text
scripts/validate_high_density_knowledge_card_plan.py briefs/knowledge-card-content.md
```

使用下列格式；每個區塊都要有具體內容。卡片文字可以依讀性拆成多個小段，但必須忠於下方
覆蓋內容。

```markdown
# 全文章最高密度 9:16 知識圖卡計畫

## 文章內容覆蓋

### 故事或問題情境
- {從原文保留的情境、衝突或痛點}

### 心理機制或原因
- {從原文保留的因果、心理狀態或矛盾}

### 核心框架或判斷法
- {從原文保留的概念、模型、區辨或原則}

### 行動方法
- {從原文保留的具體步驟、順序、資源或邊界}

### 結論或核心金句
- {從原文保留的最終結論}

## 卡片文字（逐字）

- 主標題：{台灣繁體中文}
- 副標題：{台灣繁體中文}
- 內文區塊：{依五類覆蓋整理的所有正文、對比、步驟與金句}
- 允許的外語點綴：{若無則寫「無」}

## 視覺裝飾與閱讀順序

- {由上到下的閱讀順序；每個插畫／箭頭／分隔線如何協助哪一段文字}

## 生成限制與驗收

- 目標比例：9:16
- 文字規則：台灣繁體中文；只允許上方明列的外語點綴。
- 禁止：不在清單內的外語招牌或文字、敘事頁碼、hashtag、Logo、簽名、浮水印、價格、促銷。
- 驗收：五類文章內容均可在成品中讀到；圖像不遮文字；逐字文本、禁項與實際像素比例均已檢查。
```

## 生圖 Prompt 的必要結構

用可讀的標示區塊寫 Prompt，而非單段堆疊形容詞：

1. **Use case / Asset type**：明示「ultra-high-density 9:16 knowledge card」。
2. **文章內容完整性**：列出五類內容與它們的關係；說明這是可獨立閱讀的完整論述。
3. **風格與插畫**：描述風格、色彩、紙張／材質；逐項說明裝飾只協助閱讀。
4. **構圖與文字層級**：指定連續閱讀順序與高密度、但不可犧牲可讀性的原則。
5. **Text (verbatim)**：列出每一段實際文字；不能只說「加上本文重點」。
6. **Constraints**：外語白名單、禁止項、無額外招牌文字、比例與驗收。

可用細線、留白、分隔線、箭頭、器物、抽象符號、人物或空間插畫作裝飾；人物只有在原文情境
或使用者方向確實需要時才加入。**插畫是閱讀導航，不是主角。**

## 生成後驗收與修正

1. 逐區對照內容覆蓋計畫，確認五類內容沒有缺漏或被錯誤合併。
2. 檢視可讀性：主標／區塊標／正文／步驟有明顯層級，線稿與裝飾不蓋住文字。
3. 對照 `Text (verbatim)`：不得有錯字、任意改寫、額外英文／日文招牌，或未核准的頁碼、Logo、
   浮水印。
4. 以實際檔案驗證比例：

   ```text
   scripts/validate_image_aspect.py --ratio 9:16 assets/images/<filename>.png
   ```

5. 缺的是內容或文字 → 以完整文字／內容覆蓋為唯一目標重生；缺的是比例 → 以畫布比例為唯一目標
   重生。一次只修正一個明確問題，避免把已正確的內容帶偏。

## 三 Agent 執行契約

- **Shared steps**：同一份計畫、同一份逐字文字、同一個比例與同一套驗收。
- **Codex adapter**：使用原生 image tool；輸出後保存到任務目錄並跑驗證。
- **Claude adapter**：使用原生 image tool；輸出後保存到任務目錄並跑同一驗證。
- **AntiGravity adapter**：使用原生 image tool；輸出後保存到任務目錄並跑同一驗證。
- **Fallback**：原生工具不可用時，保留同一份 Prompt 與驗收清單，取得使用者同意後才走已核准的
  shared fallback。
- **Verification**：沒有通過內容覆蓋、可讀性、文字白名單與實際比例，不得稱為正式交付。
AGENT_LAZYPACK_IMAGE_GENERATOR_REFERENCES_HIGH_DENSITY_KNOWLEDGE_CARD_MD_1A517138D5

# image-generator/references/imagegen-codex-workflow.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/image-generator/references/imagegen-codex-workflow.md")"
cat > "{{SYNC_ROOT}}/skills/image-generator/references/imagegen-codex-workflow.md" <<'AGENT_LAZYPACK_IMAGE_GENERATOR_REFERENCES_IMAGEGEN_CODEX_WORKFLOW_MD_502FEBA26E'
# Image Generator Reference: Three-Agent Image Workflow

This reference adapts the user-provided guide
`08-用Image Gen Skill在Codex生圖.md` into a workflow shared by Codex, Claude, and AntiGravity.

## Positioning

There are two possible image routes:

| Route | Best for | API key |
|---|---|---|
| Active Agent native image generation | ordinary image creation, teaching visuals, covers, thumbnails, image edits, simple assets | normally not required |
| Approved shared CLI/API/browser route | native tool unavailable, large batches, programmatic pipelines, or explicit cost tracking | depends on selected route and requires consent |

Default to the active Agent's native route. Mention a paid or key-based API only
when the user explicitly approves automation, large-scale generation, or API control.

## Beginner Requests

Useful prompt patterns:

```text
Generate a 16:9 teaching slide cover about AI helping teachers prepare lessons.
Style: bright modern illustration, warm classroom, clean composition.
Text: no text.
Constraints: no watermark, no futuristic UI, no clutter.
```

```text
Generate a transparent-background badge for a math game.
Subject: equation-solving champion badge.
Style: friendly classroom game asset.
Text: no text.
Constraints: clean silhouette, readable at small size.
```

```text
Edit the attached image into a YouTube thumbnail style.
Preserve the main person.
Change the background to a bright classroom.
Text: no text.
```

## Prompt Fields

Use these fields when the user needs help writing a prompt:

- Purpose: where the image will be used.
- Aspect ratio: 16:9, 1:1, 4:5, 9:16, transparent asset, etc.
- Subject: main person, object, scene, or concept.
- Scene: environment and composition.
- Style: photo, watercolor, modern anime illustration, flat editorial, etc.
- Colors: key palette or mood.
- Text: no text, or exact requested text if unavoidable.
- Constraints: no watermark, no logo, no clutter, no sci-fi UI, no fake text.

## Common Pitfalls

| Problem | Cause | Practical fix |
|---|---|---|
| User is unsure which quota is used | built-in image generation and API billing are separate systems | Use built-in image generation by default; API is only for explicit automation |
| Image contains poor text | image models may render text inaccurately | 一般圖片可改為無文字後製；但高密度知識圖卡或已確認的 Concept Card，必須保留逐字文字、逐區檢視並重生有缺字／錯字的成品，不可未經同意把文字改交外部排版 |
| 完整文章被做成少量摘要 | 先想畫面、沒有逐段盤點文章論點 | 建立五類內容覆蓋與逐字文本計畫；缺少故事、原因、框架、行動、結論任一類即重生 |
| Prompt 寫了比例但成品不對 | 只相信模型理解，沒有讀檔驗證 | 生成後以 `scripts/validate_image_aspect.py --ratio <比例>` 驗證實際 PNG 像素 |
| 出現未要求的英文／日文招牌 | 插畫場景自行補出環境文字 | 在 Prompt 建立外語白名單；生成後逐一檢視，未核准文字不可交付 |
| Transparent edges look messy | hair, smoke, glass, or semi-transparent objects are hard | Use a clean isolated subject and simple edges |
| Asset is hard to reuse | image stays only in generated output location | Copy it into the project or Obsidian attachment folder when requested |
| Prompt is too detailed without purpose | image loses focus | Start from purpose and composition, then add style and constraints |

## Project Placement

When the user wants the generated image saved into a standard four-box project,
prefer a task package under `100_Todo/projects/<image-task>/assets/images/`.
Use `200_Reference/docs/images/` only for deployable/static site assets and
`200_Reference/templates/images/` only for reusable templates. Do not create
project-root `assets/`, `public/`, or `src/` folders just for generated images.

- `{{PROJECT_ROOT}}/100_Todo/projects/<image-task>/assets/images/`
- `{{PROJECT_ROOT}}/200_Reference/docs/images/`
- `{{PROJECT_ROOT}}/200_Reference/templates/images/`
- `{{OBSIDIAN_VAULT}}/<note-folder>/attachments/`

Report the final path only after the file has actually been copied or created.

## Agent Execution Compatibility

- Keep the skill source in `{{SYNC_ROOT}}/skills/image-generator/`; each Agent
  reads it through its native skills entrypoint.
- Use the active Codex native image tool, Claude native image tool, or
  AntiGravity native image tool when available; use an
  approved shared CLI/API/browser route when it is not.
- Keep native metadata and commands in the corresponding adapter without forking
  the prompt, output, safety, or verification contract.
- Do not require API keys for normal image work.
- 當使用者要求全文章最高密度 9:16 知識圖卡時，三個 Agent 必須共用
  `references/high-density-knowledge-card.md` 的內容覆蓋、逐字文本與驗收契約；不可因原生工具不同
  而改成摘要卡或跳過實際比例驗證。
- 當上游 `visual-prompt-kit` 交出已確認的 Concept Card 時，三個 Agent 必須共用
  `references/concept-card-generation.md` 的三道確認、繁中白名單、無人物與 1:1 實際像素驗收；
  不可先生成示意圖，也不可把它改成封面或長內容資訊圖。
AGENT_LAZYPACK_IMAGE_GENERATOR_REFERENCES_IMAGEGEN_CODEX_WORKFLOW_MD_502FEBA26E

# image-generator/scripts/validate_high_density_knowledge_card_plan.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/image-generator/scripts/validate_high_density_knowledge_card_plan.py")"
cat > "{{SYNC_ROOT}}/skills/image-generator/scripts/validate_high_density_knowledge_card_plan.py" <<'AGENT_LAZYPACK_IMAGE_GENERATOR_SCRIPTS_VALIDATE_HIGH_DENSITY_KNOWLEDGE_CARD_PLAN_PY_D146D4A14F'
#!/usr/bin/env python3
"""Validate that a full-article 9:16 knowledge-card plan has all coverage sections."""

from __future__ import annotations

import argparse
from pathlib import Path


REQUIRED_SECTIONS = (
    "## 文章內容覆蓋",
    "### 故事或問題情境",
    "### 心理機制或原因",
    "### 核心框架或判斷法",
    "### 行動方法",
    "### 結論或核心金句",
    "## 卡片文字（逐字）",
    "## 視覺裝飾與閱讀順序",
    "## 生成限制與驗收",
)

REQUIRED_TEXT_FIELDS = (
    "主標題：",
    "副標題：",
    "內文區塊：",
    "允許的外語點綴：",
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="驗證全文章最高密度 9:16 知識圖卡的內容覆蓋與逐字文本計畫。"
    )
    parser.add_argument("plan_file", type=Path, help="knowledge-card-content.md 計畫檔。")
    return parser.parse_args()


def section_body(content: str, heading: str) -> str:
    heading_level = len(heading.split(maxsplit=1)[0])
    lines = content.splitlines()
    for start_index, line in enumerate(lines):
        if line.strip() != heading:
            continue
        body: list[str] = []
        for candidate in lines[start_index + 1 :]:
            stripped = candidate.lstrip()
            if stripped.startswith("#"):
                candidate_level = len(stripped) - len(stripped.lstrip("#"))
                if candidate_level <= heading_level:
                    break
            body.append(candidate)
        return "\n".join(body).strip()
    return ""


def main() -> int:
    args = parse_args()
    path = args.plan_file.resolve()
    if not path.is_file():
        print(f"知識圖卡計畫驗證失敗：找不到檔案：{path}")
        return 1

    content = path.read_text(encoding="utf-8")
    errors: list[str] = []
    for heading in REQUIRED_SECTIONS:
        body = section_body(content, heading)
        if not body:
            errors.append(f"缺少或留白必要區塊：{heading}")

    card_text = section_body(content, "## 卡片文字（逐字）")
    for field in REQUIRED_TEXT_FIELDS:
        if field not in card_text:
            errors.append(f"`## 卡片文字（逐字）` 缺少欄位：{field}")

    constraints = section_body(content, "## 生成限制與驗收")
    if "9:16" not in constraints:
        errors.append("`## 生成限制與驗收` 必須明示目標比例 `9:16`。")
    if "五類" not in constraints and "故事" not in constraints:
        errors.append("`## 生成限制與驗收` 必須包含文章內容覆蓋的驗收說明。")

    if errors:
        print("知識圖卡計畫驗證失敗：")
        for error in errors:
            print(f"- {error}")
        return 1

    print("PASS：全文章最高密度知識圖卡計畫具備五類內容覆蓋、逐字文本與 9:16 驗收條件。")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_IMAGE_GENERATOR_SCRIPTS_VALIDATE_HIGH_DENSITY_KNOWLEDGE_CARD_PLAN_PY_D146D4A14F

# image-generator/scripts/validate_image_aspect.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/image-generator/scripts/validate_image_aspect.py")"
cat > "{{SYNC_ROOT}}/skills/image-generator/scripts/validate_image_aspect.py" <<'AGENT_LAZYPACK_IMAGE_GENERATOR_SCRIPTS_VALIDATE_IMAGE_ASPECT_PY_825F866365'
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
        raise argparse.ArgumentTypeError("比例必須是 `9:16` 形式的正整數比。") from error
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
    parser.add_argument("--ratio", type=parse_ratio, required=True, help="目標比例，例如 9:16。")
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
        if delta > args.tolerance_pixels:
            errors.append(
                f"{path.name} 為 {width}×{height}；目標 {numerator}:{denominator} 應為寬 "
                f"{expected_width:.2f}px，誤差 {delta:.2f}px 超過 {args.tolerance_pixels:.2f}px。"
            )

    if errors:
        print("比例驗證失敗：")
        for error in errors:
            print(f"- {error}")
        return 1

    print(
        f"PASS：{len(args.images)} 張 PNG 均符合 {numerator}:{denominator}，"
        f"容許整數像素誤差 {args.tolerance_pixels:.2f}px。"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_IMAGE_GENERATOR_SCRIPTS_VALIDATE_IMAGE_ASPECT_PY_825F866365

test -f "{{SYNC_ROOT}}/skills/image-generator/SKILL.md" && echo "image-generator installed for Codex, Claude, and AntiGravity"
````

安裝完成後，請開新 Agent 對話或重啟對應 App，再測試 skill 是否能被讀取。

<!-- END EMBEDDED_SKILLS -->
