# 21-SOIL-General-Deck-Skill-安裝

> 版本：2026-05-25 Codex App 版
> 用途：建立、分析或改善 SOIL 風格通用 PowerPoint，輸出可編輯 .pptx，強調資訊清楚度、敘事結構與可驗證版面。
> 成品：下載者可直接使用本文文末「內建 Skill 完整安裝內容」建立 `{{CODEX_HOME}}/skills/soil-general-deck/`，不需要取得原作者本機資料夾。

## 來源與歷史紀錄

- 初次同步日期：2026-05-25。
- 原始來源包：使用者提供的 SOIL Deck skills package；本版已改名為 `soil-general-deck`。
- Codex 全域 skill：`{{CODEX_HOME}}/skills/soil-general-deck/SKILL.md`。
- Obsidian 全域索引已記錄用途：SOIL 通用可編輯 PPTX；用 SOIL engines 規劃簡報流，建立可編輯文字、AI 視覺、幾何圖與版面驗證。

## 這版和來源工具文件的差異

| 項目 | Codex 版調整 |
|---|---|
| 1 | 移除來源工具專用路徑與非 Codex skill 位置；正式版只保留 Codex 相容限制。 |
| 2 | 將 reference 內的來源工具品質描述改為 `Codex-quality`。 |
| 3 | 正式安裝路徑統一為 `{{CODEX_HOME}}/skills/soil-general-deck/`。 |

## 安裝方式

1. 打開本文文末「內建 Skill 完整安裝內容」。
2. 把整段安裝腳本複製到自己的環境執行。
3. 執行前先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。
4. 安裝後開新 Codex 對話或重啟 Codex App，讓新的全域 skill metadata 被重新載入。

## 驗證

```bash
test -f "{{CODEX_HOME}}/skills/soil-general-deck/SKILL.md" && echo "soil-general-deck SKILL.md ok"
test -d "{{CODEX_HOME}}/skills/soil-general-deck/references" && echo "references ok"
```

合理結果是每一行都顯示 `ok`。

## 使用方式

安裝後可用下列語句觸發：

- 「使用 soil-general-deck 幫我做簡報」
- 「用 SOIL 架構做一份通用簡報」
- 「幫我把這份教材轉成 SOIL 風格 slides」
- 「幫我檢查這份 SOIL deck 的簡報流與資訊清楚度」

觸發語意包含：general slides, presentation decks, material-to-slides, SOIL slides, presentation design, 通用簡報診斷與改善。

## 預設工作流程

1. 讀取使用者提供的主題、素材、簡報目標、受眾與輸出格式。
2. 先決定 SOIL 節奏：引起動機 -> 維持注意 -> 喚起行動。
3. 依 skill 內 `SKILL.md` 與 references 規劃頁面、視覺、互動或 PowerPoint 結構。
4. 若需要 bitmap 視覺，使用 Codex 內建 image generation 生成，不用本機假圖替代。
5. 交付前檢查檔案可開啟、文字可讀、版面不溢出、引用資源可攜。

## 踩坑紀錄

### 1. 不要把來源工具專用路徑帶進正式安裝

正式版只使用 Codex 全域 skill 路徑 `{{CODEX_HOME}}/skills/soil-general-deck/`。不要建立非 Codex skill 位置、來源工具專用命令或來源作者的本機路徑。

### 2. AI 圖像規則不能用本機假圖替代

這三組 SOIL skills 的品質前提是視覺素材由 Codex 影像生成能力產生。只有精準幾何、數學圖或明確 prototype 需求可使用 deterministic SVG / Python 圖形。

### 3. 可攜式 package 要包含實際需要的 references

只複製 `SKILL.md` 不夠。本文內嵌完整 package，包含本 skill 需要的 references。

## 最終檢查清單

- [ ] `{{CODEX_HOME}}/skills/soil-general-deck/SKILL.md` 存在。
- [ ] references 依本 skill package 實際內容存在。
- [ ] 搜尋 package 內沒有非 Codex 安裝路徑或非 Codex frontmatter 欄位。
- [ ] 開新 Codex 對話後，可用 `soil-general-deck` 或 SOIL 簡報相關語句觸發。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節會安裝：`soil-general-deck`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。

```bash
set -e

# ---- soil-general-deck ----
mkdir -p "{{CODEX_HOME}}/skills/soil-general-deck"
# soil-general-deck/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-general-deck/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/soil-general-deck/SKILL.md" <<'CODEX_LAZYPACK_SOIL_GENERAL_DECK_SKILL_MD'
---
name: soil-general-deck
description: >
  Create, analyze, or improve SOIL-style general PowerPoint decks. Use when the
  user asks for general slides, presentation decks, material-to-slides,
  SOIL slides, presentation design, or a review of an existing
  general deck's information clarity and narrative flow. Produces editable .pptx
  slides with PowerPoint text objects, optional AI illustrations, optional
  geometry diagrams, and a SOIL presentation structure.
metadata:
  short-description: SOIL editable general PPTX deck
---

# SOIL General Deck

Use this skill for editable general PowerPoint decks. The goal is information
clarity first, visual design second, and file correctness last.

## Output Contract

- Produce an editable `.pptx` unless the user asks only for diagnosis or style.
- Text should remain PowerPoint text objects.
- Every non-geometric visual image, including cover visuals, background images,
  illustrations, section-divider images, and card images, must be generated with
  Codex's built-in image generation capability first. Do not substitute local
  shape rendering or procedural placeholder images for AI images.
- For math symbols in PowerPoint, use the two-layer text-box approach when needed:
  keep readable surrounding text editable, and isolate symbols/formulas in
  separate boxes or rendered image snippets if PowerPoint text handling is weak.
- Report the final absolute file path.

## Mode Selection

Choose the path from the user's request:

- Material to deck: run SOIL engines 1-6.
- Topic only: first expand a minimal presentation outline, then run engines 1-6.
- Existing deck review: inspect the deck, run clarity diagnosis, then propose
  or implement fixes.
- Style definition: run only the style engine and output a reusable style spec.

If the user has already provided enough detail, do not stop for a long interview.
Ask only the next missing detail that affects the work, usually audience and
lesson duration.

## Core Workflow

1. Concept positioning: identify the one big idea, three sub-ideas, common
   misunderstandings, takeaway sentence, minimal fact pack, and slide-vs-talk
   split. See `references/soil-engines.md`.
2. Context positioning: arrange 引起動機 -> 維持注意 -> 喚起行動.
3. Page architecture: choose page roles, one core point per page, layout recipe,
   and any `visuals` or `geometry` needs. See `references/layout-recipes.md`.
4. Cognitive editing: reduce noise, chunk, add information, structure, sequence,
   and step the content.
5. Style construction: define palette, fonts, title/body scale, motif, and image
   policy.
6. Build and verify the PPTX using the local presentation workflow. Prefer the
   available Presentations skill when it is active; otherwise use
   `python-pptx` patterns consistent with the repo.

## Design Rules

- Use a 16:9 wide deck.
- Type scale: cover title 72-84pt, slide title 44-56pt, subtitle 28-34pt,
  body 18-21pt, muted 14-16pt.
- Use bold, readable Chinese fonts. Default to Microsoft JhengHei unless a
  project font is clearly available.
- Keep page titles short, ideally <= 10 Chinese characters.
- Use fixed alignment grids and consistent margins.
- Every page should have either a visual, a diagram, a comparison structure, a
  strong question, or a clear typographic focal point.
- Use only 1-2 accent colors.

## References

- Read `references/soil-engines.md` for SOIL planning outputs.
- Read `references/layout-recipes.md` before building slides.
- Read `references/visual-assets.md` when AI illustrations or background images
  are needed.
- Read `references/geometry.md` for math diagrams.
- Read `references/validation.md` before final delivery.

## Codex Compatibility Notes

- Use Codex App-compatible paths such as `{{CODEX_HOME}}/skills/soil-general-deck/`; any command examples should be cross-platform where possible.
- Do not add source-tool command folders, source-tool slash commands, or non-Codex skill locations to this package.
- Use Codex built-in image generation for every bitmap visual image. Only precise
  math/geometry diagrams are exempt; those should be deterministic SVG/Python
  drawings for correctness.
- Keep AGENTS.md clean; progress and presentation notes belong in Obsidian if the
  user asks for project synchronization.
CODEX_LAZYPACK_SOIL_GENERAL_DECK_SKILL_MD

# soil-general-deck/references/geometry.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-general-deck/references/geometry.md")"
cat > "{{CODEX_HOME}}/skills/soil-general-deck/references/geometry.md" <<'CODEX_LAZYPACK_SOIL_GENERAL_DECK_REFERENCES_GEOMETRY_MD'
# Geometry Diagrams

Use this reference when a general deck needs math diagrams.

## Planning Fields

For each geometry need, specify:

```yaml
geometry:
  id: slide_04_fig_01
  type: triangle
  purpose: show angle sum
  labels: [A, B, C]
  highlights:
    - angle: A
      color: primary
  canvas:
    width: 720
    height: 480
```

## Rendering Approach

- Prefer deterministic SVG or Python-generated diagrams over AI-generated math
  diagrams.
- Export diagrams as PNG or SVG, inspect them, then insert them into the deck.
- Keep labels large enough for projection.
- Use consistent colors with the slide palette.

## Supported Common Types

- triangle
- quadrilateral
- circle
- coordinate plane
- solid 3D sketch
- parallel lines cut by a transversal
- triangle centers
- similar triangles

For unsupported shapes, create a custom SVG/Python drawing with explicit
coordinates. Do not rely on image generation for precise geometric correctness.
CODEX_LAZYPACK_SOIL_GENERAL_DECK_REFERENCES_GEOMETRY_MD

# soil-general-deck/references/layout-recipes.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-general-deck/references/layout-recipes.md")"
cat > "{{CODEX_HOME}}/skills/soil-general-deck/references/layout-recipes.md" <<'CODEX_LAZYPACK_SOIL_GENERAL_DECK_REFERENCES_LAYOUT-RECIPES_MD'
# Layout Recipes

Use a 16:9 canvas. Keep margins at least 0.5 inches unless a full-bleed slide is
intentional.

## Page Roles

| Role | Layout |
|---|---|
| 封面 | Large title, subtitle, presenter/date, optional full-bleed or half-bleed visual |
| 問題引入 | One large question plus one support line |
| 迷思澄清 | Two columns: 誤解 vs 正確理解 |
| 比較 | Two-column or table with minimal borders |
| 流程 | 3-5 steps with arrows or timeline |
| 分類 | 2x2 or 2x3 grid |
| 案例 | Scenario visual plus short interpretation |
| 數據 | One big number or one chart, not a dense table |
| 總結 | Three takeaways and the one-sentence core |
| 行動 | Clear next step and closing sentence |
| 過渡 | Full color/image slide with one line |

## Grid Defaults

- Left margin: 0.6-0.7 inch.
- Right column starts around 6.7 inch for half-half layouts.
- Three cards: x positions around 0.6, 4.85, 9.1.
- Use consistent title y across standard content slides.

## Image Plate + Editable Text Layout

For Codex-quality "image + editable text" decks, do not build a generic dark
text panel over any image. First decide the text region, then generate a
text-free AI plate with that region already calm enough for text.

Preferred compositions:

- left 42-45% text region, visual action on right
- right 42-45% text region, visual action on left
- top-left title region plus lower cards or workflow objects
- center-left closing text region with a strong visual on the right

Avoid these failure modes:

- a full-slide dark overlay that makes the AI image disappear
- a big rectangle that blocks the main subject
- transparent masks stacked on top of already dark images
- duplicate text boxes used only as shadows, which makes editing tedious
- placing long bullet lists over busy detailed scenery

## Text Hierarchy

- Cover title: 72-84pt.
- Slide title: 44-56pt.
- Subtitle: 28-34pt.
- Body: 18-21pt.
- Note/muted: 14-16pt.
- Badge: 18-22pt.

## Math Text In PowerPoint

PowerPoint editable text is not the same as Word OMML. For formulas:

- Keep normal Chinese explanation in editable text boxes.
- Put formula parts in separate text boxes when the font or baseline needs
  different handling.
- For complex notation, render the formula as a small transparent image and
  place it beside editable labels.
- Avoid a single mixed text box containing long Chinese text and fragile formula
  notation.
CODEX_LAZYPACK_SOIL_GENERAL_DECK_REFERENCES_LAYOUT-RECIPES_MD

# soil-general-deck/references/soil-engines.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-general-deck/references/soil-engines.md")"
cat > "{{CODEX_HOME}}/skills/soil-general-deck/references/soil-engines.md" <<'CODEX_LAZYPACK_SOIL_GENERAL_DECK_REFERENCES_SOIL-ENGINES_MD'
# SOIL Engines

## Engine 1: Concept Positioning

Output:

```markdown
## 概念定位稿

### 總概念
[一句話]

### 三個子概念
1. [...]
2. [...]
3. [...]

### 三個常見誤解
1. [誤解] -> 正確理解：[...]

### 帶走一句話
[學生最後要記住的一句話]

### 最小事實包
- [...]

### 投影片 vs 講稿分配
| 內容 | 建議位置 | 原因 |
|---|---|---|
```

## Engine 2: Context Positioning

Use three sections:

- 引起動機: pain, curiosity, or a question the audience cares about.
- 維持注意: explain, compare, classify, visualize, and practice.
- 喚起行動: decision, method, summary, or next step.

For a 10-slide deck, a common ratio is 2 / 6 / 2.

## Engine 3: Page Architecture

For each page, specify:

- page number
- title
- role
- SOIL section
- one core point
- layout recipe
- visible text
- speaker notes or oral-only content
- visuals, if any
- geometry, if any

## Engine 4: Cognitive Editing

Use the six checks:

- 降雜訊: remove decorative or repeated content.
- 區塊化: group related content into visible chunks.
- 增資訊: add labels, arrows, examples, or contrast where they help.
- 結構化: make hierarchy and relationships obvious.
- 順脈絡: put prerequisite ideas first.
- 步驟化: convert procedures into numbered or staged visuals.

## Engine 5: Style Construction

Define:

- audience and tone
- palette: background, text, muted, primary, highlight, warning
- title font and body font
- shape language: cards, lines, arrows, badges
- image policy: style tokens, negative prompt, role-specific sizes

## Engine 6: Production

Build the PowerPoint only after visual/geometry requirements are clear. Do not
make a complete deck and then retrofit diagrams; reserve layout space before
production.
CODEX_LAZYPACK_SOIL_GENERAL_DECK_REFERENCES_SOIL-ENGINES_MD

# soil-general-deck/references/validation.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-general-deck/references/validation.md")"
cat > "{{CODEX_HOME}}/skills/soil-general-deck/references/validation.md" <<'CODEX_LAZYPACK_SOIL_GENERAL_DECK_REFERENCES_VALIDATION_MD'
# Validation

Before final delivery:

- Open or render the PPTX and inspect every slide.
- Check that titles are not cropped.
- Check that text boxes do not overlap.
- Check that Chinese fonts render correctly.
- Check that math notation is readable.
- Check that all images and diagrams are embedded and visible.
- Confirm SOIL rhythm is clear: 引起動機 -> 維持注意 -> 喚起行動.
- Confirm every slide has one core point.
- Confirm final file path and any support files are reported to the user.

If a slide overflows:

1. Split the content into two slides.
2. Switch a 1xN layout into 2xN.
3. Shorten body text and move details to speaker notes.
4. Reduce local padding or image size.
5. Only then adjust local font size. Do not shrink the whole deck's type scale.
CODEX_LAZYPACK_SOIL_GENERAL_DECK_REFERENCES_VALIDATION_MD

# soil-general-deck/references/visual-assets.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-general-deck/references/visual-assets.md")"
cat > "{{CODEX_HOME}}/skills/soil-general-deck/references/visual-assets.md" <<'CODEX_LAZYPACK_SOIL_GENERAL_DECK_REFERENCES_VISUAL-ASSETS_MD'
# Visual Assets

Use visuals only when they teach, orient, or create attention.

Every visual image in this reference must be generated with Codex's built-in
image generation capability unless it is a real user-provided asset. Local
rendering with shapes, CSS, Pillow, SVG art, or placeholder panels is not an
acceptable substitute for AI-generated visuals.

## Visual Roles

| Role | Use | Suggested Placement |
|---|---|---|
| illustration | concept or scenario image | right column or inset |
| background | cover/action/section visual | full bleed with overlay |
| hero | strong half-slide visual | right half |
| side_panel | decorative but meaningful strip | left or right edge |
| section_divider | chapter transition | full bleed |
| accent | small supporting icon/object | near the relevant text |

## Prompt Rules

- Include a consistent style token from the style engine.
- Ask for no readable text unless text must be baked into the image.
- Reserve clean space for text overlays on backgrounds.
- For editable-text image plates, generate the plate around the final text
  layout. Ask for a calm dark or light text zone in the exact side/region where
  PowerPoint text will sit, instead of adding a large overlay panel afterward.
- Use `low` quality for drafts and most illustrations; upgrade visual anchor
  pages only when needed.

## Editable Plate Rules

Use these rules when the output is "AI image + editable PowerPoint text":

- Generate fresh text-free plate images for the deck instead of trying to fix a
  busy image with opaque masks.
- Treat the image as the designed page background: it should already include
  quiet negative space, edge framing, or a natural empty panel for text.
- Do not cover more than about 35-45% of the image with a post-added rectangle
  or translucent mask. If text does not read, regenerate the image with better
  reserved space.
- Keep overlay text to one editable PowerPoint text object per phrase. Avoid
  duplicate shadow text layers unless the user explicitly prefers visual polish
  over easy editing.
- If a slide needs dense bullets, split the slide or redesign the image plate;
  do not solve it by darkening the whole page.

## Final Deck Rule

Do not embed relative paths that will break after moving the deck folder. Insert
images into the PPTX file itself.
CODEX_LAZYPACK_SOIL_GENERAL_DECK_REFERENCES_VISUAL-ASSETS_MD
```

<!-- END EMBEDDED_SKILLS -->
