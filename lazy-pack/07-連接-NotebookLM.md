# 07-連接-NotebookLM

> 2026-05-24 更新：本文件已改為自含式 Skill 安裝文件。請使用文末「內建 Skill 完整安裝內容」，不要再依賴舊版 `對應序號文件的內嵌 Skill 區塊：` 子目錄。


## 目標

讓 Codex 能讀取 NotebookLM，並固定 NotebookLM 成品下載與整理路徑。

## 前置條件

- 已安裝 Codex App。
- 已有 Google 帳號並可使用 NotebookLM。
- 已決定 `{{NOTEBOOKLM_OUTPUT}}`，例如 `/Users/alex/Documents/NotebookLM`。
- 若使用 NotebookLM MCP，需已安裝對應 CLI，並確認可登入 Google 帳號。

## 建立輸出資料夾

建立主資料夾與成品分類：

```bash
mkdir -p "{{NOTEBOOKLM_OUTPUT}}"/{slides,infographics,audio,video,docs,sheets,mindmaps,quizzes}
```

用途：

- `slides`：簡報
- `infographics`：資訊圖表
- `audio`：音訊
- `video`：影片
- `docs`：文件
- `sheets`：試算表
- `mindmaps`：心智圖
- `quizzes`：測驗

## NotebookLM MCP 設定

先找出 NotebookLM MCP command 的實際位置：

```bash
command -v notebooklm-mcp
```

若找不到，代表尚未安裝或不在 PATH。不同安裝方式會得到不同路徑，請以你的電腦實際輸出為準。

在 `{{CODEX_CONFIG}}` 加入：

```toml
[mcp_servers.notebooklm]
command = "{{NOTEBOOKLM_MCP_COMMAND}}"
args = []
startup_timeout_sec = 30
tool_timeout_sec = 120
```

範例：

```toml
[mcp_servers.notebooklm]
command = "/Users/alex/.local/bin/notebooklm-mcp"
args = []
startup_timeout_sec = 30
tool_timeout_sec = 120
```

## 可選：安裝 NotebookLM 內容製作 Skills

如果下載者要用 NotebookLM 做簡報、資訊圖表或教學內容，可安裝：

```bash
for skill in notebooklm-architecture presentation-workflow visual-note-generator; do
  mkdir -p "{{CODEX_HOME}}/skills/$skill"
  # 舊版 對應序號文件的內嵌 Skill 區塊 複製指令已取消；請使用文末「內建 Skill 完整安裝內容」。
  test -f "{{CODEX_HOME}}/skills/$skill/SKILL.md" && echo "$skill installed"
done
```

## 驗證

1. 重啟 Codex App 或開新對話。
2. 請 Codex 檢查 NotebookLM 工具是否可用。
3. 測試列出 notebooks 或讀取一個測試 notebook。
4. 下載任何 NotebookLM 成品後，放入 `{{NOTEBOOKLM_OUTPUT}}` 對應子資料夾。

## 設定範本

曾成功使用：

```toml
[mcp_servers.notebooklm]
command = "{{NOTEBOOKLM_MCP_COMMAND}}"
args = []
startup_timeout_sec = 30
tool_timeout_sec = 120
```

這是模板值，下載者必須改成自己的 `{{NOTEBOOKLM_MCP_COMMAND}}`。

## 踩坑修正

- MCP 設定改完後，工具不一定立刻出現，通常要重啟 Codex。
- 不要假設 `nlm mcp` 一定能當 Codex MCP command；以 `command -v notebooklm-mcp` 或實際可執行檔為準。
- 如果 NotebookLM 工具未載入，先檢查 `command` 是否是完整絕對路徑。
- Google 帳號登入狀態會影響 NotebookLM 讀取；必要時重新登入 MCP 或 Google connector。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節取代舊版 `對應序號文件的內嵌 Skill 區塊：` 子目錄。這個序號項目會安裝：`notebooklm-architecture`, `presentation-workflow`, `visual-note-generator`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `/Users/alex/.codex`。

```bash
set -e

decode_base64() {
  if base64 --help 2>/dev/null | grep -q -- '-d'; then
    base64 -d
  else
    base64 -D
  fi
}

# ---- notebooklm-architecture ----
mkdir -p "{{CODEX_HOME}}/skills/notebooklm-architecture"
# notebooklm-architecture/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/notebooklm-architecture/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/notebooklm-architecture/SKILL.md" <<'CODEX_LAZYPACK_NOTEBOOKLM_ARCHITECTURE_SKILL_MD'
---
name: notebooklm-architecture
description: Create reusable NotebookLM architecture source files that control a notebook's role, thinking logic, teaching method, output structure, formatting, and source-selection behavior. Use when the user asks to design, revise, or package NotebookLM control prompts, Soul Frameworks, Body Frameworks, source files, note-to-source workflows, YAML-like configuration content, teacher-facing NotebookLM templates, or reusable architecture instructions for NotebookLM.
---

# NotebookLM Architecture

## Purpose

Create file-ready NotebookLM framework content that a teacher can save as a note, convert into a source, export to Google Docs, and reuse across notebooks.

Use two framework types:

- Soul Framework: control the AI role, tone, reasoning, teaching method, and knowledge-handling attitude.
- Body Framework: control the output structure, layout, numbering, visual format, table style, and required sections.

For the full source rules from the original document, read `references/framework-spec.md`.

## Workflow

1. Identify the requested framework target.
   - Use Soul Framework when the user asks for role, voice, persona, thinking logic, reasoning rules, teaching method, or conversation style.
   - Use Body Framework when the user asks for layout, format, section structure, table proportions, numbering rules, visual style, or output shape.
   - If both are needed, create two clearly separated framework file contents.

2. Name the framework.
   - Use the user's explicit name when provided.
   - Otherwise infer a short descriptive Chinese name from the purpose.

3. Output only reusable file content plus the required teacher workflow.
   - Wrap each file's content between `---檔案內容開始---` and `---檔案內容結束---`.
   - Put the framework declaration as the first line inside the wrapper.
   - After the file content, include the NotebookLM conversion steps.

4. If the user asks to modify an existing framework document, edit the document directly when it is available and writable. Remind the user that NotebookLM can sync from the modified document.

## Required Declarations

Soul Framework first line:

```text
此為 [名稱] 靈魂框架, 勾選此資料則決定 AI 的角色定位與思考邏輯。
```

Body Framework first line:

```text
此為 [名稱] 格式框架, 勾選此資料則按照以下的結構與格式要求做輸出。
```

## Content Requirements

Soul Frameworks must include:

- `[身分設定]`
- `[邏輯約束]`
- `[知識處理態度]`
- `[對話風格]`

Body Frameworks must include the relevant subset of:

- `[結構比例]`
- `[視覺格式]`
- `[編號規範]`
- Specific output sections, tables, or formatting rules requested by the user.

Keep framework text operational and source-friendly. Write instructions that NotebookLM can follow after the source is checked, not commentary about the process.

## NotebookLM Conversion Steps

After producing framework content, include these steps unless the user explicitly asks for content only:

1. 點擊下方「儲存至記事 (Save to Note)」。
2. 進入記事後選擇「轉換成來源」。
3. 進入記事後選擇「匯出至 Google 文件」。
4. 於目標筆記本點擊「新增來源」，從 Google 雲端硬碟匯入該文件；之後可修改文件並讓 NotebookLM 同步。
CODEX_LAZYPACK_NOTEBOOKLM_ARCHITECTURE_SKILL_MD

# notebooklm-architecture/agents/openai.yaml
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/notebooklm-architecture/agents/openai.yaml")"
cat > "{{CODEX_HOME}}/skills/notebooklm-architecture/agents/openai.yaml" <<'CODEX_LAZYPACK_NOTEBOOKLM_ARCHITECTURE_AGENTS_OPENAI_YAML'
interface:
  display_name: "NotebookLM Architecture"
  short_description: "Create reusable NotebookLM Soul and Body framework source files."
  default_prompt: "Create a NotebookLM framework source file for the requested role, thinking logic, teaching method, structure, or output format."
CODEX_LAZYPACK_NOTEBOOKLM_ARCHITECTURE_AGENTS_OPENAI_YAML

# notebooklm-architecture/references/framework-spec.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/notebooklm-architecture/references/framework-spec.md")"
cat > "{{CODEX_HOME}}/skills/notebooklm-architecture/references/framework-spec.md" <<'CODEX_LAZYPACK_NOTEBOOKLM_ARCHITECTURE_REFERENCES_FRAMEWORK_SPEC_MD'
# NotebookLM Framework Spec

Source: `/Users/arrywu/Downloads/NotebookLM 系統架構大師.docx`

## Role

Act as a NotebookLM system architecture master. Convert configuration into files so teachers can produce checkable, swappable framework sources.

The two core source-file types are:

- Soul Framework: determines AI role positioning and thinking logic.
- Body Framework: determines structure and output format.

## Decision Rules

Create a Soul Framework when the user asks to set:

- AI role
- tone
- thinking method
- teaching method
- knowledge-processing attitude
- dialogue style

Create a Body Framework when the user asks to set:

- layout
- output format
- table proportions
- specific structure
- visual formatting
- numbering rules

If the request mixes both kinds of control, produce separate Soul and Body framework contents.

## Mandatory Wrapper

Every framework output must be wrapped exactly like this:

```text
---檔案內容開始---
[framework content]
---檔案內容結束---
```

## Mandatory First Line

Soul Framework:

```text
此為 [名稱] 靈魂框架, 勾選此資料則決定 AI 的角色定位與思考邏輯。
```

Body Framework:

```text
此為 [名稱] 格式框架, 勾選此資料則按照以下的結構與格式要求做輸出。
```

## Soul Framework Core Sections

Include these sections:

- `[身分設定]`
- `[邏輯約束]`
- `[知識處理態度]`
- `[對話風格]`

## Body Framework Core Sections

Include these sections when relevant:

- `[結構比例]`
- `[視覺格式]`
- `[編號規範]`

Add any requested structure, table, checklist, or output sections as explicit rules.

## Teacher Workflow

After producing framework content, guide the teacher to turn it into a NotebookLM source:

1. 點擊下方「儲存至記事 (Save to Note)」。
2. 進入記事後選擇「轉換成來源」。
3. 進入記事後選擇「匯出至 Google 文件」。
4. 於目標筆記本點擊「新增來源」，從 Google 雲端硬碟匯入該文件，可以修改後在別的筆記本使用。

If changes are needed later, edit the document directly and sync it in NotebookLM.
CODEX_LAZYPACK_NOTEBOOKLM_ARCHITECTURE_REFERENCES_FRAMEWORK_SPEC_MD

test -f "{{CODEX_HOME}}/skills/notebooklm-architecture/SKILL.md" && echo "notebooklm-architecture installed"

# ---- presentation-workflow ----
mkdir -p "{{CODEX_HOME}}/skills/presentation-workflow"
# presentation-workflow/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/presentation-workflow/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/presentation-workflow/SKILL.md" <<'CODEX_LAZYPACK_PRESENTATION_WORKFLOW_SKILL_MD'
---
name: presentation-workflow
description: Analyze and create presentations with an emphasis on NotebookLM slide generation, YAML-controlled visual style, and repeatable deck iteration. Use when Codex needs to read or critique a slide deck, plan a presentation, create slide content, generate or refine NotebookLM YAML style specifications, translate visual references such as Pinterest posters or landing pages into design language, define per-slide layouts and prompts, or revise NotebookLM-generated slides page by page.
---

# Presentation Workflow

Use this skill to analyze, plan, create, and revise presentations. When the task involves NotebookLM, treat YAML as a design specification file that tells NotebookLM how to generate the deck's visual style and page-by-page structure.

## Source Method

This skill is based on the user's Word document: `用 YAML 精準控制 NotebookLM 的簡報風格.docx`.

Core idea: do not ask NotebookLM to make a vague "good-looking" deck. Give it a structured YAML design brief with global style rules and page-level slide plans, then iterate with concrete slide-specific corrections.

## Workflow

1. Clarify the deck job:
   - Analyze an existing deck.
   - Create a new deck from source material.
   - Build a NotebookLM YAML style specification.
   - Revise a NotebookLM-generated deck.
2. Define the presentation goal:
   - audience, purpose, language, tone, target slide count, and delivery context.
3. Build or inspect the narrative:
   - Plan what each slide should do before writing layout instructions.
   - Decide the exact page count when working with NotebookLM YAML.
4. Define the visual language:
   - Use atmosphere, color scheme, typography, layout rules, image style, layout design, and decorative elements.
   - If the user provides visual references, analyze the underlying design logic rather than copying surface decoration.
5. Write YAML:
   - Combine `global_design` and `slides`.
   - Put style values in quoted strings.
   - Use page keys such as `p1`, `p2`, `p3`.
6. Generate or revise:
   - For NotebookLM, add the YAML file as a source and prompt NotebookLM to follow it.
   - After generation, review slide by slide and update only the pages that need improvement.
7. Preserve the best version:
   - Lock slides that already work.
   - Iterate weak slides two or three times, then assemble the best pages into the final deck.

## NotebookLM YAML Pattern

Read [notebooklm-yaml-style.md](references/notebooklm-yaml-style.md) when the user asks for YAML, NotebookLM slide control, or a reusable style template.

Use two major sections:

- `global_design`: the deck-wide design system.
- `slides`: the page-by-page construction plan.

The minimum useful global design fields are:

- `atmosphere`: three adjectives that define the whole tone.
- `color_scheme`: background, text, accent, and secondary colors.
- `typography`: heading, body, and data text rules.
- `layout_rules`: navigation, image style, layout design, and decorative elements.

The minimum useful slide fields are:

- `type`: the slide role, such as cover, intro, content, overview, or ending.
- `layout_style`: the layout method in descriptive terms.
- `visual_description`: a concrete description of how the page should look.
- `content`: exact title/subtitle text or a `generation_prompt`.

## Visual Reference Workflow

Read [style-extraction-workflow.md](references/style-extraction-workflow.md) when the user wants to turn Pinterest, posters, landing pages, screenshots, mood boards, or reference images into a presentation style.

Default process:

1. Collect a small set of references.
2. Ask what attracts the user: color, layout, image treatment, texture, atmosphere, or typography.
3. Extract design vocabulary:
   - color strategy
   - typography
   - composition
   - image treatment
   - texture and decoration
   - overall atmosphere
4. Convert the vocabulary into YAML fields.
5. Let the user adjust the style description before generating slides.

## Presentation Analysis

When analyzing an existing presentation:

1. Identify the deck's intended audience, purpose, and narrative.
2. Check whether slide titles communicate meaning or only label topics.
3. Inspect page density, visual hierarchy, layout consistency, and image relevance.
4. Identify the highest-impact fixes first.
5. If it is a NotebookLM deck, suggest YAML changes rather than only visual comments.

Lead review output with actionable findings. Keep compliments brief and specific.

## Creation Standards

For new presentations:

- Plan slide count and slide roles before writing slide copy.
- Use one main idea per slide.
- Prefer concrete visual descriptions over abstract style words.
- Use slide-level `generation_prompt` values for content pages.
- Use exact title/subtitle values for cover and section pages.
- Avoid generic phrases such as "high quality", "modern", or "professional" unless they are supported by concrete color, typography, layout, and image rules.

## NotebookLM Iteration

After NotebookLM produces a first draft:

1. Keep the slides that already work.
2. Give page-specific corrections:
   - "p1: move title/subtitle left and image right."
   - "p2: keep the layout, but change the character expression."
   - "p3: use three horizontal columns for the three directions."
3. Update the YAML instead of regenerating from vague comments.
4. Use Canva or PowerPoint for small typo or font fixes when faster than another NotebookLM generation.

## Output Formats

For a YAML request, return:

- a short explanation of the design direction
- a complete YAML block
- a NotebookLM usage prompt
- optional revision prompts

For deck creation, return:

- deck thesis
- slide outline
- slide-by-slide content
- visual direction
- YAML style specification when NotebookLM is involved

For analysis, return:

- diagnosis
- prioritized fixes
- revised structure or YAML changes
- slide-by-slide notes when possible
CODEX_LAZYPACK_PRESENTATION_WORKFLOW_SKILL_MD

# presentation-workflow/agents/openai.yaml
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/presentation-workflow/agents/openai.yaml")"
cat > "{{CODEX_HOME}}/skills/presentation-workflow/agents/openai.yaml" <<'CODEX_LAZYPACK_PRESENTATION_WORKFLOW_AGENTS_OPENAI_YAML'
interface:
  display_name: "Presentation Workflow"
  short_description: "NotebookLM YAML slide control"
  default_prompt: "Use $presentation-workflow to create a NotebookLM YAML style specification for this presentation."
CODEX_LAZYPACK_PRESENTATION_WORKFLOW_AGENTS_OPENAI_YAML

# presentation-workflow/references/notebooklm-yaml-style.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/presentation-workflow/references/notebooklm-yaml-style.md")"
cat > "{{CODEX_HOME}}/skills/presentation-workflow/references/notebooklm-yaml-style.md" <<'CODEX_LAZYPACK_PRESENTATION_WORKFLOW_REFERENCES_NOTEBOOKLM_YAML_STYLE_MD'
# NotebookLM YAML Style Control

Use this reference to create a YAML style specification for NotebookLM slide generation.

## Core Principle

YAML works as a design instruction file for NotebookLM. Instead of typing a cramped prompt into a custom field, save the style instructions as a source file and tell NotebookLM:

```text
請依照 style_spec_[style-name].yaml 的規範設計簡報。
```

This lets NotebookLM read a richer design context and makes style versions reusable.

## Full Template

Use this structure as the default template.

```yaml
global_design:
  atmosphere: "[形容詞1], [形容詞2], [形容詞3]"
  color_scheme:
    background: "[Hex Code]"
    text: "[Hex Code]"
    accent: "[Hex Code - 用於重點標示或數據圖表]"
    secondary: "[Hex Code - 用於次要資訊或分隔線]"
  typography:
    heading: "[字體名稱或類別]"
    body: "[字體名稱或類別]"
    data: "[字體名稱或類別]"
  layout_rules:
    navigation: "[位置與形式]"
    image_style:
      - "[圖片處理方式]"
      - "[圖表形式]"
    layout_design:
      - "[格線與留白]"
      - "[對齊方式]"
    decorative_elements: "[視覺點綴]"

slides:
  p1:
    type: "封面"
    layout_style: "[樣式名稱]"
    visual_description: "[詳細描述畫面如何構成]"
    content:
      title: "[簡報大標題]"
      subtitle: "[簡報副標題]"
  p2:
    type: "引言頁"
    layout_style: "[樣式名稱]"
    visual_description: "[詳細描述畫面如何構成]"
    content:
      title: "[引言頁標題]"
      generation_prompt: "[指導 AI 生成內容的具體提示]"
  p3:
    type: "[頁面類型]"
    layout_style: "[樣式名稱]"
    visual_description: "[詳細描述畫面如何構成]"
    content:
      title: "[標題]"
      generation_prompt: "[指導 AI 生成內容的具體提示]"
```

## Global Design Fields

`atmosphere`: Use three adjectives to define the overall mood. These words guide the rest of the visual decisions.

`color_scheme`: Define color roles, not only color names. Include background, text, accent, and secondary colors. Prefer hex codes.

`typography`: Define heading, body, and data styles. Include font family or category, weight, size range, line height, and any special treatment such as tight tracking.

`layout_rules.navigation`: Define page number, section label, or progress marker placement.

`layout_rules.image_style`: Describe photo treatment, illustration style, cutouts, filters, chart style, or whether to avoid shadows and 3D effects.

`layout_rules.layout_design`: Describe grid, margins, alignment, balance, overlap, collage rules, or whitespace.

`layout_rules.decorative_elements`: Define decorative rules such as thin lines, geometric blocks, ribbons, hand-drawn curves, paper texture, or halftone effects.

## Slide Planning Fields

`type`: Define the slide function: cover, intro, agenda, overview, content, comparison, case, quote, summary, ending.

`layout_style`: Name the layout approach in descriptive words, such as full-bleed split, center-focus, three-column overview, image-text split, or collage layout.

`visual_description`: Describe the actual page composition. Be concrete about placement, scale, background, image treatment, overlays, and hierarchy.

`content`: Use direct `title` and `subtitle` values for fixed pages. Use `generation_prompt` for pages where NotebookLM should summarize source content.

## Writing Rules

- Put style values in double quotes.
- Use indentation consistently.
- Use concrete design language instead of vague quality words.
- Specify exact slide count and page keys when the deck structure matters.
- Keep content prompts short and tied to source sections.
- Add constraints for privacy and factuality when working with sensitive or educational material.

## NotebookLM Usage Prompt

```text
請根據已選取的原始資料，並嚴格依照 style_spec_[style-name].yaml 的 global_design 與 slides 規範生成簡報。
請維持繁體中文，避免補造來源沒有提供的事實。
```

## Revision Prompt Pattern

```text
請根據以下頁面級回饋修改 YAML 並重新生成簡報：
- p1：封面排版太分散，請改成主標與副標在左側，主要圖像在右側。
- p2：保留目前中央聚焦式排版，但人物表情改成思考感，不要皺眉。
- p3：此頁講三個方向，請改成水平三欄，每欄一個重點並搭配黑白去背影像。
其他已經滿意的頁面請保持不變。
```

## Common Fixes

- If the first draft looks generic, strengthen `atmosphere`, `image_style`, `layout_design`, and `decorative_elements`.
- If pages feel messy, make `visual_description` more explicit and reduce the number of visual elements.
- If content is too wordy, constrain `generation_prompt` with word count and tone.
- If a slide works well, lock it and only iterate weak pages.
- If only typos or font glitches remain, fix them directly in Canva or PowerPoint instead of regenerating the whole deck.
CODEX_LAZYPACK_PRESENTATION_WORKFLOW_REFERENCES_NOTEBOOKLM_YAML_STYLE_MD

# presentation-workflow/references/style-extraction-workflow.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/presentation-workflow/references/style-extraction-workflow.md")"
cat > "{{CODEX_HOME}}/skills/presentation-workflow/references/style-extraction-workflow.md" <<'CODEX_LAZYPACK_PRESENTATION_WORKFLOW_REFERENCES_STYLE_EXTRACTION_WORKFLOW_MD'
# Style Extraction Workflow

Use this reference when converting visual inspiration into NotebookLM YAML style instructions.

## Where To Look

For visual exploration, search for:

- `Poster`
- `Landing page`
- specific style terms such as retro collage, neumorphism, duotone print, graffiti pixel, minimal tech

Posters and landing pages are useful because they often show strong composition, bold color, and clear attention-grabbing hierarchy.

## Observation Questions

When a reference catches attention, ask:

- What attracts the user: color, composition, typography, image treatment, texture, motion, contrast, or atmosphere?
- What is the color strategy?
- What elements construct the style?
- How does the layout change across different content types?
- What should be copied as a principle, and what should not be copied literally?

## Extraction Categories

Break the style into these categories:

- `atmosphere`: 3 adjectives.
- `color_strategy`: dominant colors, contrast, background, accent, support colors.
- `typography`: heading, body, data, label, or ribbon text rules.
- `composition`: grid, alignment, split, overlap, scale, negative space.
- `image_treatment`: cutouts, black-and-white photos, filters, paper texture, halftone, flat illustration.
- `decorative_elements`: lines, geometric blocks, ribbons, hand-drawn marks, texture, borders.
- `navigation`: section markers, page numbers, progress labels.

## Example: Retro Collage Cyberpunk

Extracted style:

- Collage method: overlap images and geometric color blocks with offset placement.
- Texture: paper texture and halftone print effects for a retro feel.
- Color strategy: high-saturation warm or bright colors contrasted with cooler muted tones.
- Atmosphere: futuristic, high-contrast, dynamic.

Possible YAML values:

```yaml
global_design:
  atmosphere: "未來感, 張力對比, 動態感"
  color_scheme:
    background: "#F5F0E6"
    text: "#111111"
    accent: "#2150DB"
    secondary: "#12CD75"
    highlight: "#B8A3E8"
  typography:
    heading: "思源黑體 Bold 800, 48-72pt, 字距緊湊, 視覺衝擊感"
    body: "思源黑體 Medium 500, 18-22pt, 行高 1.5, 易於閱讀"
    ribbon_text: "Roboto Regular 400, 12-16pt, 英文全大寫"
  layout_rules:
    navigation: "內容頁左上角以 14-16pt 顯示當前方向，封面與結尾頁不顯示"
    image_style:
      - "使用去背處理的真實攝影"
      - "人物動作要有動態感，必要時使用黑白影像"
    layout_design:
      - "打破傳統格線，採自由拼貼式佈局"
      - "文字與圖片可重疊、傾斜、打破邊界"
      - "保留適度留白，避免過度擁擠"
      - "米白背景可使用 #D4C9B8 格線底紋；深藍或綠色背景使用純色"
    decorative_elements: "使用手繪黑色曲線穿梭版面，連接不同視覺元素"
```

## Practical Tips

- Use Google Fonts to test font weight and size ranges before writing typography instructions.
- Add size constraints when NotebookLM makes titles or body text too large.
- If layout ideas are unclear, let NotebookLM generate one draft from source material first, then revise YAML from the actual pages.
- Build a reusable inspiration library with tags and folders so style vocabulary accumulates over time.
- Use a project template in Claude Project or a similar AI workspace to turn long style discussions into YAML automatically.
CODEX_LAZYPACK_PRESENTATION_WORKFLOW_REFERENCES_STYLE_EXTRACTION_WORKFLOW_MD

test -f "{{CODEX_HOME}}/skills/presentation-workflow/SKILL.md" && echo "presentation-workflow installed"

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
3. Load `references/prompt-library.md` when exact reusable wording or output structure is needed.
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

### Transcript To Article Or Post

Turn a visual-note transcript or reading reflection into a publishable article or social post while preserving the user's original viewpoint. Do not summarize mechanically. Build resonance, situation, viewpoint, perspective shift, and a memorable closing line.

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

## 1. Hand-Drawn Visual Note To AI Image

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
- 整體風格偏「教育型圖解 x 親切手繪感」
- 不要過度擬真，不要 3D
- 不要加入任何未出現在手繪中的內容

請輸出一張高解析度的圖像。
```

## 2. Add Personal Q-Version Character

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

## 3. Photo To Reusable Educator Avatar

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

## 4. Visual-Note Transcript To Reading Reflection Article

Use when the user provides a voice transcript and wants a publishable long-form article.

```text
請根據以下「語音逐字稿內容」，幫我整理並重寫成一篇適合發佈在臉書與專欄平台的「閱讀心得型爆文文章」。

寫作前提：
- 內容來源僅限於逐字稿與我的原始觀點
- 不要新增理論、案例或書籍內容
- 請保留我的身份視角（如老師／工程師／創作者等）

文章請使用以下固定結構：
1. 開頭共鳴段：從一個我真實遇到的困擾或矛盾切入，讓讀者感覺「這是在說我」。
2. 真實情境／個人經驗：具體描述我在工作、教學或生活中的場景，避免抽象總結。
3. 閱讀後的關鍵觀點：說清楚這本書或這個概念，真正打中我的哪一點。
4. 我的視角轉換：明確寫出我原本的想法、現在的不同想法，以及這個轉換會影響我接下來怎麼做。
5. 收尾金句：用一句站在我身份立場的話作結，可被截圖、可被記住。

格式與風格要求：
- 每段加上小標題
- 小標題前使用「▋」符號
- 每段不超過 4 行
- 語氣自然、真誠，有個人立場
- 避免教學語氣與口號式勵志
```

## 5. Article To Shareable Viewpoint Post

Use when the user provides a reading-reflection column and wants a Facebook-friendly post.

```text
請將以下「閱讀心得專欄內容」，改寫成一篇適合發佈在臉書、容易被轉分享的「觀點型貼文」。

改寫前提：
- 不要摘要原文
- 不要介紹書籍內容
- 聚焦在「這個觀點在說誰的痛點」
- 保留我的身份立場與個人語氣（老師／工程師／家長／創作者等）

貼文請使用以下結構：
1. 開頭一擊（1-2 行）：直接點出多數人正在經歷、卻說不出口的狀態。
2. 情緒共鳴段（3-5 行）：用生活或工作中的熟悉畫面，讓讀者覺得「你怎麼知道我在想什麼」。
3. 我的立場：用一句清楚的判斷說出「我現在怎麼看這件事？」
4. 視角轉換：說明這個觀點如何改變我接下來的選擇、教學方式、工作決策或生活態度。
5. 可被轉貼的收尾句：用一句能被截圖、標人、轉貼的話作結，不說教、不喊口號。

格式與風格要求：
- 每段不超過 2-3 行
- 全文可用換行製造節奏
- 語氣真實、有溫度，但有立場
- 不使用 hashtag 也能成立
```

## 6. Voice Text To Visual Diagram Image

Use when the user gives spoken explanation text and wants a visual diagram prompt.

```text
請根據以下內容，生成一張 16:9 橫式彩色插圖風格的「視覺圖解」。

風格設定：
- 插畫風格（非寫實、非照片）
- 手繪感、溫暖、有人的溫度
- 類似資訊圖表 x 故事插畫的混合
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

## 7. Article To Infographic Content

Use when the user wants the content structure for one 16:9 infographic.

```text
請根據我提供的這篇專欄文章，幫我整理成「一張資訊圖表」適合使用的內容結構。

整理原則：
- 不是摘要文章
- 而是把文章的「核心觀點」視覺化
- 內容需適合放在一張 16:9 橫式資訊圖中

請輸出以下內容：
1. 一句主標題（具觀點、可吸引目光）
2. 3-5 個關鍵重點（每點不超過 15 字）
3. 每個重點的一句補充說明（口語、易懂）
4. 一句可放在圖表底部的收尾金句

風格要求：
- 保留作者的個人立場與語氣
- 不使用學術或教科書語言
- 不加入文章中沒有的新觀點
```

## 8. Article To Slide Structure

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

echo "embedded skills installed: notebooklm-architecture presentation-workflow visual-note-generator"
```

<!-- END EMBEDDED_SKILLS -->
