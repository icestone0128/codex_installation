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
