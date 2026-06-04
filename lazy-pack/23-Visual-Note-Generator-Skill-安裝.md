# 23-Visual-Note-Generator-Skill-安裝

> 版本：2026-05-26 Codex App 版
> 用途：建立 `visual-note-generator` 全域 skill，將手繪圖解、語音逐字稿、文章或教學想法轉成圖解筆記、生圖提示、Q 版角色提示、社群文章、資訊圖表與簡報結構。
> 成品：下載者可直接使用本文文末「內建 Skill 完整安裝內容」建立 `{{CODEX_HOME}}/skills/visual-note-generator/`，不需要取得原作者本機資料夾，也不需要任何非 Codex 工具。

## 來源與歷史紀錄

- 初次同步日期：2026-05-09。
- 拆分成獨立 LazyPack Item 日期：2026-05-26。
- 依 Google Drive `圖解筆記生圖指令` 更新提示庫日期：2026-05-26。
- 來源文件：Google Docs `圖解筆記生圖指令`（已匯入 Obsidian：`知識庫/圖解筆記生圖指令.md`）。
- Codex 全域 skill：`{{CODEX_HOME}}/skills/visual-note-generator/SKILL.md`。
- 這版定位：獨立的內容製作 skill，不附屬於 NotebookLM 連線項目；可單獨安裝與使用。

## 這版和來源文件的差異

| 項目 | Codex 版調整 |
|---|---|
| 1 | 轉成 Codex App 全域 skill 結構，使用 `{{CODEX_HOME}}/skills/visual-note-generator/`。 |
| 2 | 保留來源邊界規則：只根據使用者提供的手繪、逐字稿、文章或想法，不自行新增概念。 |
| 3 | 將 Google Drive `圖解筆記生圖指令` 的 8 類提示整理到 `references/prompt-library.md`，讓下載者可直接重複使用。 |
| 4 | 加入 `agents/openai.yaml` 作為可攜式介面摘要；不依賴 來源工具 專用設定。 |

## 安裝方式

1. 打開本文文末「內建 Skill 完整安裝內容」。
2. 把整段安裝腳本複製到自己的環境執行。
3. 執行前先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。
4. 安裝後開新 Codex 對話或重啟 Codex App，讓新的全域 skill metadata 被重新載入。

## 驗證

```bash
test -f "{{CODEX_HOME}}/skills/visual-note-generator/SKILL.md" && echo "visual-note-generator SKILL.md ok"
test -f "{{CODEX_HOME}}/skills/visual-note-generator/references/prompt-library.md" && echo "visual-note-generator prompt library ok"
test -f "{{CODEX_HOME}}/skills/visual-note-generator/agents/openai.yaml" && echo "visual-note-generator agent metadata ok"
```

合理結果是每一行都顯示 `ok`。

## 使用方式

安裝後可用下列語句觸發：

- 「使用 visual-note-generator，把這張手繪圖解轉成 AI 生圖提示」
- 「幫我把這段語音逐字稿整理成圖解筆記」
- 「把這篇文章轉成一張 16:9 資訊圖表結構」
- 「幫我設計 Q 版教學角色提示」
- 「把這篇心得改寫成可分享的觀點型貼文」

觸發語意包含：visual-note-generator、圖解筆記、視覺筆記、手繪圖解、AI 生圖提示、Q 版角色、資訊圖表、visual note、infographic、prompt library。

## 預設工作流程

1. 判斷來源型態：手繪筆記、生成圖、個人照片、語音逐字稿、文章或欄位草稿。
2. 判斷輸出目標：圖片提示、角色提示、社群貼文、文章、資訊圖表內容結構或簡報結構。
3. 需要精準格式時讀取 `references/prompt-library.md`。
4. 以使用者提供內容作為邊界，不新增未出現在來源中的概念、案例、書籍內容、配件或視覺元素。
5. 預設使用繁體中文；若使用者指定其他語言才切換。
6. 若使用者要求實際生圖，且 Codex 影像生成能力可用，先組出提示詞再進行生成。

## 踩坑紀錄

### 1. 不要把 Visual Note Generator 當成 NotebookLM 附屬項目

這個 skill 可用在 NotebookLM 內容製作，但本質是獨立的視覺筆記與內容轉換流程。LazyPack 中應作為單獨 Item 安裝，不放在 `07-連接-NotebookLM.md` 的內嵌 skill 區塊。

### 2. 不要自行補內容

這個 skill 的核心價值是 source-bounded。使用者沒有提供的概念、例子、人物配件、書籍內容或視覺細節，不要為了讓圖更豐富而自行加入。

### 3. 圖像提示要保留文字限制

若是要生成圖解或資訊圖，提示詞要明確限制文字量。精準中文字通常適合後製加入，不一定交給生圖模型直接產生。

## 最終檢查清單

- [ ] `{{CODEX_HOME}}/skills/visual-note-generator/SKILL.md` 存在。
- [ ] `{{CODEX_HOME}}/skills/visual-note-generator/references/prompt-library.md` 存在。
- [ ] `{{CODEX_HOME}}/skills/visual-note-generator/agents/openai.yaml` 存在。
- [ ] 搜尋 package 內沒有 來源工具 專用路徑或本機個人絕對路徑。
- [ ] 開新 Codex 對話後，可用 `visual-note-generator`、圖解筆記或手繪圖解相關語句觸發。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節會安裝：`visual-note-generator`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。

```bash
set -e

# ---- visual-note-generator ----
mkdir -p "{{CODEX_HOME}}/skills/visual-note-generator"
# visual-note-generator/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/visual-note-generator/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/visual-note-generator/SKILL.md" <<'CODEX_LAZYPACK_VISUAL_NOTE_GENERATOR_SKILL_MD'
---
name: visual-note-generator
description: Generate and transform educational visual notes from hand-drawn diagrams, voice transcripts, articles, or draft teaching ideas. Use when Codex needs to create AI image prompts for visual notes, 16:9 infographic structures, Q-version educator avatars, social/article rewrites from visual-note transcripts, or slide structures based on the user's original content without adding unsupported ideas.
---

# Visual Note Generator

## Core Rule

Use the user's supplied source as the boundary. Do not add concepts, claims, examples, book content, accessories, or visual details that are not present in the source or explicitly requested by the user.

Prefer Traditional Chinese output unless the user asks for another language.

## Workflow

1. Identify the source type: hand-drawn note image, generated visual note, personal photo, voice transcript, article, or column draft.
2. Identify the target output: image prompt, avatar prompt, social post, article, infographic content structure, or slide structure.
3. Load `references/prompt-library.md` when exact reusable wording or output structure is needed. This library is based on the user's Google Drive source file `圖解筆記生圖指令`.
4. Preserve the user's identity perspective, such as teacher, engineer, creator, parent, or another stated role.
5. Keep visual outputs educational, warm, clean, and readable. Avoid photorealism, 3D, excessive technology style, corporate-slide stiffness, and clutter.
6. For image prompts, explicitly state the aspect ratio, style, content boundary, text limits, and negative constraints.

## Task Patterns

### Hand-Drawn Note To Visual Diagram

Create a 16:9 horizontal, high-resolution visual diagram prompt. Preserve the original structure, wording, logic, and hierarchy. Emphasize clear lines, warm layered color, educational diagram style, and a friendly hand-drawn feel.

### Add Educator Avatar

Add a small Q-version educator character only as a supporting identity marker. Keep the diagram as the main subject. Place the character to one side, smiling or pointing toward a key point, without blocking content.

### Photo To Reusable Avatar

When a user provides a personal photo, transform the person into a professional, reusable educational Q-version avatar. Preserve major traits such as hairstyle, face shape, glasses, or facial hair. Avoid exaggerated costumes, babyish style, or props not present in the photo.

### Transcript To Reading Reflection Article

Turn a voice transcript into a publishable long-form reading-reflection article while preserving the user's original viewpoint. Follow the fixed sequence: opening resonance, real situation or personal experience, key reading insight, perspective shift, and memorable closing line.

### Reading Reflection To Viewpoint Post

Turn a reading-reflection column into a Facebook-friendly viewpoint post. Do not summarize the original or introduce book content. Focus on the reader pain point, the user's stance, a perspective shift, and a shareable closing sentence.

### Text To Infographic Or Slides

Convert a column or article into a 16:9 infographic structure or slide outline. Visualize the core viewpoint instead of summarizing the whole text. Keep each slide or infographic section focused on one idea.

## Output Discipline

- Ask only when a missing parameter blocks useful output, such as the number of slides.
- If the source is too long, first extract the core viewpoint and identity stance, then generate the requested structure.
- If the user asks to generate an actual image and the `imagegen` skill or image tool is available, use it after composing the prompt.
- If generating prompts only, output ready-to-paste prompts with placeholders clearly marked.
CODEX_LAZYPACK_VISUAL_NOTE_GENERATOR_SKILL_MD

# visual-note-generator/agents/openai.yaml
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/visual-note-generator/agents/openai.yaml")"
cat > "{{CODEX_HOME}}/skills/visual-note-generator/agents/openai.yaml" <<'CODEX_LAZYPACK_VISUAL_NOTE_GENERATOR_AGENTS_OPENAI_YAML'
interface:
  display_name: "圖解筆記生成"
  short_description: "把手繪筆記、語音逐字稿與文章轉成教學圖解素材與簡報結構"
  default_prompt: "Use $visual-note-generator to turn my hand-drawn notes or draft text into a clean educational visual note."

policy:
  allow_implicit_invocation: true
CODEX_LAZYPACK_VISUAL_NOTE_GENERATOR_AGENTS_OPENAI_YAML

# visual-note-generator/references/prompt-library.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/visual-note-generator/references/prompt-library.md")"
cat > "{{CODEX_HOME}}/skills/visual-note-generator/references/prompt-library.md" <<'CODEX_LAZYPACK_VISUAL_NOTE_GENERATOR_REFERENCES_PROMPT_LIBRARY_MD'
# Prompt Library

Use these templates as source-bounded patterns. Adapt wording to the user's actual material and requested platform.

Canonical source: the user's Google Drive document `圖解筆記生圖指令`.

## 1. 手繪圖解筆記生成 AI 圖

Use when the user uploads or references a hand-drawn visual note and wants a clean generated diagram.

```text
請以我上傳的「手繪圖解筆記」為唯一內容來源，不要自行新增概念或文字。

請將這張手繪圖解轉換為：
- 16:9 橫式比例
- 彩色、乾淨、專業的視覺圖解
- 適合用於簡報、社群貼文與課程教材

視覺風格需求：
- 保留原本的結構、文字與邏輯
- 線條清楚、顏色溫和但有層次
- 整體風格偏「教育型圖解 × 親切手繪感」
- 不要過度擬真，不要 3D
- 不要加入任何未出現在手繪中的內容

請輸出一張高解析度的圖像。
```

## 2. 生成圖結合個人 Q 版圖版本

Use after a 16:9 visual note exists and the user wants an author/teacher identity marker.

```text
請在完成的 16:9 彩色圖解中，加入一個「Q 版人物角色」，作為作者的代表。

角色需求：
- 風格：可愛但不幼稚、教育型 Q 版
- 角色姿勢：站在圖解一側，微笑、指向重點
- 角色比例：小巧，不遮擋圖解內容
- 角色服裝：簡單（上衣＋褲子或裙子）
- 整體風格需與圖解一致，不突兀

請注意：
- 圖解內容仍然是主角
- Q 版角色只是陪襯與識別用
```

## 3. 如果沒有個人圖像怎麼辦

Use when the user has no existing character image but provides a personal photo.

```text
請以我上傳的照片作為角色外觀參考，將照片中的人物轉換為「教育用途的 Q 版角色」。

角色風格需求：
- 日系 Q 版風格（可愛但不幼稚）
- 頭部比例稍大、身體比例小
- 保留照片中的主要特徵（髮型、臉型、眼鏡／鬍子等）
- 表情親切、有專注感，而不是搞笑表情

用途設定：
- 這個角色會長期用在「圖解筆記、簡報、教學內容」
- 風格需耐看、專業、可反覆使用
- 不要太卡通化，不要嬰兒風

畫面需求：
- 半身或全身皆可
- 簡單站姿或拿筆、指向前方
- 白底或透明背景
- 高解析度輸出

請不要加入照片中沒有的配件或誇張服裝。
```

## 4. 圖解筆記轉語音

Use when the user provides a voice transcript and wants a publishable long-form article.

Note: the source document names this section `圖解筆記轉語音`, but the actual prompt transforms a voice transcript into a reading-reflection article.

```text
請根據以下「語音逐字稿內容」，幫我整理並重寫成一篇適合發佈在臉書與專欄平台的「閱讀心得型爆文文章」。

寫作前提：
- 內容來源僅限於逐字稿與我的原始觀點
- 不要新增理論、案例或書籍內容
- 請保留我的身份視角（如老師／工程師／創作者等）

文章請使用以下固定結構：
① 開頭共鳴段
從一個我真實遇到的困擾或矛盾切入，
讓讀者感覺「這是在說我」。

② 真實情境／個人經驗
具體描述我在工作、教學或生活中的場景，
避免抽象總結。

③ 閱讀後的關鍵觀點
說清楚這本書或這個概念，真正打中我的哪一點。

④ 我的視角轉換（核心段落）
請明確寫出：
- 我原本的想法是什麼？
- 現在的想法有什麼不同？
- 這個轉換，會影響我接下來怎麼做？

⑤ 收尾金句
用一句「站在我身份立場」的話作結，
可被截圖、可被記住。

格式與風格要求：
- 每段加上小標題
- 小標題前使用「▋」符號
- 每段不超過 4 行
- 語氣自然、真誠，有個人立場
- 避免教學語氣與口號式勵志
```

## 5. 語音文字轉文章

Use when the user provides a reading-reflection column and wants a Facebook-friendly post.

```text
請將以下「閱讀心得專欄內容」，改寫成一篇適合發佈在臉書、容易被轉分享的「觀點型貼文」。

改寫前提：
- 不要摘要原文
- 不要介紹書籍內容
- 聚焦在「這個觀點在說誰的痛點」
- 保留我的身份立場與個人語氣（老師／工程師／家長／創作者等）

貼文請使用以下結構：
① 開頭一擊（1–2 行）
直接點出多數人正在經歷、卻說不出口的狀態，
讓人一看就停下來。

② 情緒共鳴段（3–5 行）
用生活或工作中的熟悉畫面，
讓讀者覺得「你怎麼知道我在想什麼」。

③ 我的立場（關鍵段）
用一句清楚的判斷說出：
「我現在怎麼看這件事？」
避免模糊、避免中庸。

④ 視角轉換（價值段）
說明這個觀點，如何改變我接下來的選擇、
教學方式、工作決策或生活態度。

⑤ 可被轉貼的收尾句
用一句能被截圖、標人、轉貼的話作結，
不說教、不喊口號。

格式與風格要求：
- 每段不超過 2-3 行
- 全文可用換行製造節奏
- 語氣真實、有溫度，但有立場
- 不使用 hashtag 也能成立
```

## 6. 語音文字轉 AI 圖

Use when the user gives spoken explanation text and wants a visual diagram prompt.

```text
請根據以下內容，生成一張 16:9 橫式彩色插圖風格的「視覺圖解」。

風格設定：
- 插畫風格（非寫實、非照片）
- 手繪感、溫暖、有人的溫度
- 類似資訊圖表 × 故事插畫的混合
- 色彩柔和但重點清楚
- 不要過度科技感、不像企業簡報

畫面要求：
- 畫面中央有一位正在思考／設計人生的人物（可 Q 版或簡化插畫）
- 畫面中清楚呈現「思考結構」與「概念關係」
- 使用簡單圖形（框、箭頭、區塊）輔助理解
- 文字只保留關鍵詞，不要整段文字

主題與概念來源如下（請不要逐字照抄，而是轉化成視覺）：
【貼上我剛剛對著圖說的文字內容】

重點：
- 圖片目的是「放大觀念」，不是重現手繪稿
- 請讓畫面一眼就看懂核心概念
```

## 7. 文字轉資訊圖表

Use when the user wants the content structure for one 16:9 infographic.

```text
請根據我提供的這篇專欄文章，幫我整理成「一張資訊圖表」適合使用的內容結構。

整理原則：
- 不是摘要文章
- 而是把文章的「核心觀點」視覺化
- 內容需適合放在一張 16:9 橫式資訊圖中

請輸出以下內容：
1️⃣ 一句主標題（具觀點、可吸引目光）
2️⃣ 3–5 個關鍵重點（每點不超過 15 字）
3️⃣ 每個重點的一句補充說明（口語、易懂）
4️⃣ 一句可放在圖表底部的收尾金句

風格要求：
- 保留作者的個人立場與語氣
- 不使用學術或教科書語言
- 不加入文章中沒有的新觀點
```

## 8. 文字轉簡報

Use when the user wants a talk, teaching, or internal-share slide outline.

```text
請將這篇專欄內容，轉換成一份「＿＿＿＿頁的簡報結構」。

每一頁請包含：
- 投影片標題（一句話觀點）
- 2-4 個重點 bullet（口語、可講）
- 一句講者備註（提醒這一頁要說什麼）

簡報目的：
- 用於分享觀點、教學或內部簡報
- 不是報告書，也不是條列摘要

風格要求：
- 每一頁只傳達一個重點
- 語氣自然，像是在對人說話
- 不加入原文沒有的內容
- 不加入文章中沒有的新觀點
```
CODEX_LAZYPACK_VISUAL_NOTE_GENERATOR_REFERENCES_PROMPT_LIBRARY_MD

test -f "{{CODEX_HOME}}/skills/visual-note-generator/SKILL.md" && echo "visual-note-generator installed"

echo "embedded skills installed: visual-note-generator"
```

<!-- END EMBEDDED_SKILLS -->
