# 20-SOIL-Image-Deck-Skill-安裝

> 版本：2026-07-13 Codex App v2 版
> 用途：建立 SOIL 風格 image-first 簡報，每頁以 AI 生成全頁圖像為核心，再打包成 .pptx，支援 baked 與 plate 模式。
> 成品：下載者可直接使用本文文末「內建 Skill 完整安裝內容」建立 `{{CODEX_HOME}}/skills/soil-image-deck/`，不需要取得原作者本機資料夾。

## 來源與歷史紀錄

- 初次同步日期：2026-05-25。
- v2 更新日期：2026-07-13。
- 原始來源包：使用者提供的 SOIL Deck skills package；本版已整理為 `soil-image-deck`。
- v2 來源：`mathruffian-dot/soil-image-deck`，讀取 commit `a4da933 feat: add shared SOIL deck core`。
- 2026-07-13 補入 `yaml-image-deck` 路由：通用 YAML 圖片式簡報改用 LazyPack Item 38；需要 SOIL 六引擎才使用本 skill。
- Codex 全域 skill：`{{CODEX_HOME}}/skills/soil-image-deck/SKILL.md`。
- Obsidian 全域索引已記錄用途：SOIL 全圖像 PPTX；以 Codex 影像生成建立每頁全版圖，再用打包腳本輸出 baked 或可疊 editable text 的 plate 模式。

## 這版和來源工具文件的差異

| 項目 | Codex 版調整 |
|---|---|
| 1 | 將 Windows-only 範例改為跨平台 `python` / `python3` 指令，避免限定單一終端環境。 |
| 2 | v2 改為完整 SOIL image deck package，包含 `assets/soil-spec-template.yaml`、`references/soil-deck-core.md`、YAML profile、prompt contract、layout recipes、validation 與 subagent batching 指引。 |
| 3 | 新增 `scripts/validate_spec.py` 與 `scripts/verify_images.py`，並更新 `scripts/pack_pptx.py`：baked 模式先裁切 16:9；plate 模式要求繁中粗圓字型，不再默默退回尖角預設字型。 |
| 4 | 正式安裝路徑統一為 `{{CODEX_HOME}}/skills/soil-image-deck/`。 |
| 5 | 補入分流規則：`yaml-image-deck` 處理非 SOIL 的 NotebookLM-style / YAML-controlled image deck，本 skill 專注 SOIL 教學圖片式 PPTX。 |

## 安裝方式

1. 打開本文文末「內建 Skill 完整安裝內容」。
2. 把整段安裝腳本複製到自己的環境執行。
3. 執行前先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。
4. 若要使用內建 Python helpers，安裝依賴：

```bash
python -m pip install -r "{{CODEX_HOME}}/skills/soil-image-deck/requirements.txt"
```

依賴包含 `PyYAML`、`Pillow` 與 `python-pptx`，供 `validate_spec.py`、`verify_images.py` 與 `pack_pptx.py` 使用。

5. 安裝後開新 Codex 對話或重啟 Codex App，讓新的全域 skill metadata 被重新載入。

## 驗證

```bash
test -f "{{CODEX_HOME}}/skills/soil-image-deck/SKILL.md" && echo "soil-image-deck SKILL.md ok"
test -f "{{CODEX_HOME}}/skills/soil-image-deck/assets/soil-spec-template.yaml" && echo "soil spec template ok"
test -d "{{CODEX_HOME}}/skills/soil-image-deck/references" && echo "references ok"
test -d "{{CODEX_HOME}}/skills/soil-image-deck/scripts" && echo "scripts ok"
python -m pip install -r "{{CODEX_HOME}}/skills/soil-image-deck/requirements.txt"
python "{{CODEX_HOME}}/skills/soil-image-deck/scripts/validate_spec.py" --spec "{{CODEX_HOME}}/skills/soil-image-deck/assets/soil-spec-template.yaml"
```

合理結果是每一行都顯示 `ok`。

## 使用方式

安裝後可用下列語句觸發：

- 「使用 soil-image-deck 幫我做簡報」
- 「用 SOIL 架構做一份教學簡報」
- 「幫我把這份教材轉成 SOIL 風格 slides」
- 「幫我檢查這份 SOIL deck 的教學流與認知負荷」

觸發語意包含：pure image deck, all-image slides, AI-generated poster-like slides, visual-impact teaching slides, livestream opening slides, social sharing slides, 不需要後續文字編輯的簡報。

## 預設工作流程

1. 讀取使用者提供的主題、素材、教學目標、受眾與輸出格式。
2. 先完成 SOIL 六引擎：概念定位、脈絡定位、頁面架構、認知編修、風格建構、生產驗證。
3. 先做 renderer-neutral SOIL Core，保留 `learning_task`、`semantic_structure`、`layout.id`、`visible_text` 與 `speaker_only`，YAML 最後才出場。
4. 建立或更新 `spec.yaml`，先跑 `validate_spec.py`，再生成黃金樣張並鎖定風格。
5. 若需要 bitmap 視覺，使用 Codex 內建 image generation 生成，不用本機假圖替代。
6. 以 `verify_images.py` 檢查圖片存在與 16:9 比例，打包後再檢查 PPTX 可開啟、文字可讀、版面不溢出、引用資源可攜。

## 踩坑紀錄

### 1. 不要把來源工具專用路徑帶進正式安裝

正式版只使用 Codex 全域 skill 路徑 `{{CODEX_HOME}}/skills/soil-image-deck/`。不要建立非 Codex skill 位置、來源工具專用命令或來源作者的本機路徑。

### 2. AI 圖像規則不能用本機假圖替代

這三組 SOIL skills 的品質前提是視覺素材由 Codex 影像生成能力產生。只有精準幾何、數學圖或明確 prototype 需求可使用 deterministic SVG / Python 圖形。

### 3. 可攜式 package 要包含 assets / references / scripts / agents

只複製 `SKILL.md` 不夠。本文內嵌完整 v2 package，包含來源 package 中必要的 `assets/`、`references/`、`scripts/` 與 `agents/openai.yaml`。

### 4. YAML 不是第一步

v2 的重點是先完成概念、脈絡、頁面架構與認知編修，再把決策寫進 YAML。不要一開始就把任務變成填表，否則簡報會格式正確但教學意圖不清楚。

### 5. Plate 模式必須守住繁中粗圓字體

新版 `pack_pptx.py` 會尋找 `jf open 粉圓 2.1`、`GenSenRounded TW` 或 `GenJyuuGothic` 等繁中粗圓字型。找不到時會停止，避免輸出尖角、機械感或不符合樣張風格的文字。

## 最終檢查清單

- [ ] `{{CODEX_HOME}}/skills/soil-image-deck/SKILL.md` 存在。
- [ ] assets / references / scripts / agents 依本 skill package 實際內容存在。
- [ ] `validate_spec.py` 可通過內建 `assets/soil-spec-template.yaml`。
- [ ] 搜尋 package 內沒有非 Codex 安裝路徑或非 Codex frontmatter 欄位。
- [ ] 開新 Codex 對話後，可用 `soil-image-deck` 或 SOIL 簡報相關語句觸發。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節會安裝：`soil-image-deck`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。

````bash
set -e

# ---- soil-image-deck ----
rm -rf "{{CODEX_HOME}}/skills/soil-image-deck"
mkdir -p "{{CODEX_HOME}}/skills/soil-image-deck"
# soil-image-deck/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-image-deck/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/soil-image-deck/SKILL.md" <<'CODEX_LAZYPACK_SOIL_IMAGE_DECK_SKILL_MD'
---
name: soil-image-deck
description: Create SOIL-style image-first teaching presentations in which every slide is driven by an AI-generated full-page visual. Use when the user asks for a SOIL image deck, pure-image teaching slides, NotebookLM-style educational slides, a YAML-driven SOIL deck, visual-impact teacher training slides, or a baked/plate PPTX that follows 引起動機、維持注意、喚起行動 and the SOIL six-engine workflow.
---

# SOIL Image Deck

Use SOIL teaching decisions to create a coherent image-first deck. Produce a page plan and YAML design contract before image generation, lock the style with a golden sample, then generate, inspect, and package the deck.

Keep the planning model renderer-neutral. The same SOIL core can later feed `soil-html-deck`; image-specific output fields belong to the Image renderer layer. Read `references/soil-deck-core.md` before authoring or migrating YAML.

Use `yaml-image-deck` instead when the user wants a general YAML-controlled
image-first deck, NotebookLM-style picture deck, fixed visual grammar, or batch
image slides without SOIL teaching rhythm or the SOIL six-engine workflow.

## Configuration Axes

- `output_mode`: `baked` or `plate`.
- `planning_mode`: `quick` or `yaml_spec`.
- `generation_strategy`: `sequential` or `subagents`.
- `style_lock`: `none` or `golden_sample`.

Default to `yaml_spec`, `sequential`, and `golden_sample`. Use `subagents` only when the user explicitly requests parallel generation and the environment permits it.

## Hard Image Rule

- Generate every slide visual with Codex built-in image generation first.
- Do not replace image generation with Pillow, CSS, SVG, procedural shapes, or placeholders.
- Use an API/CLI image path only when the user explicitly requests it.
- Save every accepted image inside the project before packaging.

## Rounded Typography Policy

Default to bold rounded Traditional Chinese display lettering: thick even strokes, soft terminals, generous counters, friendly proportions, and low corner sharpness.

For `baked`, repeat the rounded typography requirement in every image prompt. Prohibit angular geometric Chinese type, condensed mechanical type, sharp wedges, and techno-stencil forms.

For `plate`, use the first installed font from `jf open 粉圓 2.1`, `GenSenRounded TW`, or `GenJyuuGothic`. If none is installed, stop before packaging and report the missing rounded Chinese font. Never silently fall back to an angular default.

## SOIL Six-Engine Workflow

1. **Concept positioning**: one big idea, three sub-ideas, misunderstandings, takeaway, minimal fact pack, and slide-vs-talk split.
2. **Context positioning**: arrange 引起動機 → 維持注意 → 喚起行動. A 10-slide default rhythm is approximately 2 / 6 / 2.
3. **Page architecture**: give each page one role, one core point, one learning task, one semantic relationship, one `layout.id`, minimal visible text, and one visual brief.
4. **Cognitive editing**: check 降雜訊、區塊化、增資訊、結構化、順脈絡、步驟化.
5. **Style construction**: create `spec.yaml` from `assets/soil-spec-template.yaml`; define palette, fixed shell, rounded typography, layout router, safe area, image policy, and validation rules.
6. **Production**: validate YAML, approve a golden sample, generate images, inspect the montage, selectively regenerate failed pages, package the PPTX, render it again, and verify delivery.

When the user supplies an existing validated SOIL YAML spec, skip engines 1–5 only if its concept, flow, page roles, and visual system are already explicit.

## Production Commands

Validate YAML:

```powershell
python .\scripts\validate_spec.py --spec .\spec.yaml
```

Verify generated images:

```powershell
python .\scripts\verify_images.py --spec .\spec.yaml --images-dir .\slides\images
```

In Codex, package with the Presentations skill and Artifact Tool. Embed one full-bleed image per slide, render the exported PPTX, inspect the montage, and run overflow checks.

For environments without Artifact Tool, `scripts/pack_pptx.py` is a portability fallback. It center-crops baked images to 16:9 and refuses silent substitution when no rounded Chinese font is available for `plate` mode.

Install the fallback script dependencies before using local packaging:

```bash
python -m pip install -r "{{CODEX_HOME}}/skills/soil-image-deck/requirements.txt"
```

Required packages:

- `PyYAML` for YAML validation and plate specs
- `Pillow` for image ratio checks and center-cropping
- `python-pptx` for fallback PPTX packaging

## Output Modes

- `baked`: the generated image contains the short visible text. Best for demos, social sharing, openings, and visual storytelling.
- `plate`: generate a text-free designed plate with reserved text zones; overlay editable text afterward. Best for long-lived teaching decks, revisions, formulas, and exact data.

Keep formulas, precise geometry, charts, and numeric evidence native/editable when correctness matters.

## References

- Read `references/soil-engines.md` for required planning outputs.
- Read `references/soil-deck-core.md` when the same plan may also produce an interactive HTML deck.
- Read `references/yaml-profile.md` before writing `spec.yaml`.
- Read `references/layout-recipes.md` before assigning layouts.
- Read `references/prompting.md` before image generation.
- Read `references/subagent-batching.md` when the user requests parallel generation.
- Read `references/validation.md` before packaging and delivery.
CODEX_LAZYPACK_SOIL_IMAGE_DECK_SKILL_MD

# soil-image-deck/agents/openai.yaml
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-image-deck/agents/openai.yaml")"
cat > "{{CODEX_HOME}}/skills/soil-image-deck/agents/openai.yaml" <<'CODEX_LAZYPACK_SOIL_IMAGE_DECK_AGENTS_OPENAI_YAML'
interface:
  display_name: "SOIL Image Deck"
  short_description: "用 SOIL 六引擎、黃金樣張與 YAML 生成一致的教學圖片簡報"
  default_prompt: "Use $soil-image-deck to turn this teaching topic into a SOIL image-first deck."
CODEX_LAZYPACK_SOIL_IMAGE_DECK_AGENTS_OPENAI_YAML

# soil-image-deck/assets/soil-spec-template.yaml
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-image-deck/assets/soil-spec-template.yaml")"
cat > "{{CODEX_HOME}}/skills/soil-image-deck/assets/soil-spec-template.yaml" <<'CODEX_LAZYPACK_SOIL_IMAGE_DECK_ASSETS_SOIL_SPEC_TEMPLATE_YAML'
schema_version: "soil_image_deck_v2"

deck:
  title: "SOIL image deck"
  audience: "Teachers"
  purpose: "Teach one concept clearly"
  takeaway: "One sentence students should retain"
  language: "zh-TW"
  output_mode: "baked"
  planning_mode: "yaml_spec"
  generation_strategy: "sequential"
  style_lock: "golden_sample"
  slide_count: 3

canvas:
  target_ratio: "16:9"
  safe_area_pct: {left: 6, right: 6, top: 10, bottom: 10}

soil_flow:
  sequence: [hook, attention, action]
  suggested_ratio: {hook: 0.2, attention: 0.6, action: 0.2}

design_system:
  visual_direction: "Warm educational editorial infographic"
  palette:
    background: "#F5F1E8"
    primary: "#176B87"
    highlight: "#F4A261"
    text: "#173042"
  typography:
    font_feel: "粗圓、飽滿、低稜角的繁體中文無襯線字"
    avoid: "尖角、窄長、機械感、科技模板字"
    plate_font_preferences:
      - "jf open 粉圓 2.1"
      - "GenSenRounded TW"
      - "GenJyuuGothic"
  style_reference: "slides/images/page_02.png"
  negative_prompt:
    - "不要 Logo 或浮水印"
    - "不要未指定文字"
    - "不要螢幕、投影幕或 mockup"

rhythm_policy:
  max_same_layout_in_row: 1
  alternate_visual_direction: true

layout_router:
  focus: "question_focus"
  hierarchy: "relationship_map"
  action: "action_next_step"

slides:
  - page: 1
    soil_phase: "hook"
    role: "question"
    learning_task: "Care about the problem"
    core_point: "The topic matters"
    semantic_structure: "focus"
    layout: {id: "question_focus", variant: "single_focal"}
    visible_text: {title: "為什麼要學？"}
    speaker_only: "Connect the question to the audience"
    visual: "One concrete tension or question"
    output: "slides/images/page_01.png"
  - page: 2
    soil_phase: "attention"
    role: "relationship"
    learning_task: "See how the parts relate"
    core_point: "Three parts work together"
    semantic_structure: "hierarchy"
    layout: {id: "relationship_map", variant: "three_layer_stack"}
    visible_text: {title: "三層一起工作", labels: ["概念", "脈絡", "頁面"]}
    speaker_only: "Explain one layer at a time"
    visual: "Three tactile layers connected into one teaching page"
    output: "slides/images/page_02.png"
  - page: 3
    soil_phase: "action"
    role: "action"
    learning_task: "Apply the method"
    core_point: "Start with the learning task"
    semantic_structure: "action"
    layout: {id: "action_next_step", variant: "center_statement"}
    visible_text: {title: "先決定學習任務"}
    speaker_only: "Ask the audience to apply the method"
    visual: "A teacher placing the final card into a coherent deck"
    output: "slides/images/page_03.png"

validation:
  regenerate_on:
    - "文字錯誤"
    - "字體不夠粗圓"
    - "教學任務或版型不清楚"
CODEX_LAZYPACK_SOIL_IMAGE_DECK_ASSETS_SOIL_SPEC_TEMPLATE_YAML

# soil-image-deck/references/layout-recipes.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-image-deck/references/layout-recipes.md")"
cat > "{{CODEX_HOME}}/skills/soil-image-deck/references/layout-recipes.md" <<'CODEX_LAZYPACK_SOIL_IMAGE_DECK_REFERENCES_LAYOUT_RECIPES_MD'
# SOIL Controlled Layouts

| Teaching job | Layout ID | Budget |
|---|---|---|
| 封面 | `cover_hero` | One title, one visual idea |
| 問題引入 | `question_focus` | One large question |
| 迷思澄清 | `misconception_dual` | Two sides |
| 比較 | `comparison_split` | Two options |
| 流程 | `process_timeline` | Three to five steps |
| 分類 | `classification_grid` | Four or six groups |
| 案例 | `case_scene_analysis` | Scenario plus interpretation |
| 關係 | `relationship_map` | Hierarchy or causal chain |
| 數據 | `data_focus` | One number or chart |
| 總結 | `summary_three` | Three takeaways |
| 行動 | `action_next_step` | One next step |
| 過渡 | `section_divider` | One line, full bleed |

Do not repeat one layout more than twice in a row. Alternate visual weight while preserving title anchor, palette, rounded typography, material, and recurring motif.
CODEX_LAZYPACK_SOIL_IMAGE_DECK_REFERENCES_LAYOUT_RECIPES_MD

# soil-image-deck/references/prompting.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-image-deck/references/prompting.md")"
cat > "{{CODEX_HOME}}/skills/soil-image-deck/references/prompting.md" <<'CODEX_LAZYPACK_SOIL_IMAGE_DECK_REFERENCES_PROMPTING_MD'
# SOIL Image Prompt Contract

Compile prompts in this order:

1. Full 16:9 slide image and safe area.
2. Controlled layout and reading path.
3. Teaching visual and information relationship.
4. Exact visible text for baked mode.
5. Shared style and golden-sample reference.
6. Rounded Traditional Chinese typography.
7. Negative prompt.

Rounded typography block:

```text
Typography: bold rounded Traditional Chinese display lettering with thick even
strokes, soft terminals, generous counters, friendly proportions, and low corner
sharpness. Avoid angular geometric Chinese type, condensed mechanical forms,
sharp wedges, thin strokes, or techno-stencil lettering. Render only the quoted
text, exactly once, with no extra characters.
```

State that the output is the slide itself, not a screen, projector, or mockup.

For plate mode, prohibit all text and generate calm reserved zones around the final overlay layout.
CODEX_LAZYPACK_SOIL_IMAGE_DECK_REFERENCES_PROMPTING_MD

# soil-image-deck/references/soil-deck-core.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-image-deck/references/soil-deck-core.md")"
cat > "{{CODEX_HOME}}/skills/soil-image-deck/references/soil-deck-core.md" <<'CODEX_LAZYPACK_SOIL_IMAGE_DECK_REFERENCES_SOIL_DECK_CORE_MD'
# SOIL Deck Core

Use one renderer-neutral planning model for Image, PowerPoint, and HTML outputs.

Core fields cover audience, purpose, SOIL flow, design system, page role, learning task, core point, semantic structure, visible copy, speaker-only content, and visual intent. Keep renderer-specific coordinates and behaviors outside the core.

```yaml
- page: 1
  soil_phase: "hook"
  role: "cover"
  learning_task: "Know why the topic matters"
  core_point: "One teachable claim"
  semantic_structure: "focus"
  layout: {id: "cover_hero", variant: "left_title_right_visual"}
  visible_text: {title: "Short title"}
  speaker_only: "What the teacher explains aloud"
  visual: {brief: "Concrete visual intent"}
```

## Renderer mapping

| Core field | Image/PPTX | Interactive HTML |
|---|---|---|
| `visible_text` | baked or plate overlay | live DOM text |
| `visual` | full slide or plate | hero/supporting asset |
| `layout.id` | image composition | responsive component |
| `semantic_structure` | visual relationship | interaction routing |
| `speaker_only` | notes or talk track | optional speaker mode |

When upgrading an Image Deck to HTML, preserve the core and add HTML-only `interaction`, `accessibility`, responsive behavior, and static fallback fields. Do not restart concept planning unless the existing core is incomplete.
CODEX_LAZYPACK_SOIL_IMAGE_DECK_REFERENCES_SOIL_DECK_CORE_MD

# soil-image-deck/references/soil-engines.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-image-deck/references/soil-engines.md")"
cat > "{{CODEX_HOME}}/skills/soil-image-deck/references/soil-engines.md" <<'CODEX_LAZYPACK_SOIL_IMAGE_DECK_REFERENCES_SOIL_ENGINES_MD'
# SOIL Planning Outputs

## Engine 1: Concept

- One central idea.
- Three supporting ideas.
- Three likely misunderstandings.
- One takeaway sentence.
- Minimal fact pack.
- Slide-visible content versus oral-only content.

## Engine 2: Context

- 引起動機: pain, curiosity, or a relevant question.
- 維持注意: explain, compare, classify, visualize, and practice.
- 喚起行動: synthesize, decide, apply, or take the next step.

## Engine 3: Page Architecture

For every page specify page number, SOIL phase, role, core point, learning task, semantic relationship, layout ID, visible text, oral-only content, visual brief, and output path.

## Engine 4: Cognitive Editing

- 降雜訊: remove decoration and repeated content.
- 區塊化: group related information.
- 增資訊: add labels, arrows, examples, or contrast only when helpful.
- 結構化: expose hierarchy and relationships.
- 順脈絡: place prerequisite ideas first.
- 步驟化: turn procedures into visible stages.

## Engines 5–6

Write the YAML design contract only after engines 1–4. Then generate and validate the deck; do not use YAML as a substitute for teaching judgment.
CODEX_LAZYPACK_SOIL_IMAGE_DECK_REFERENCES_SOIL_ENGINES_MD

# soil-image-deck/references/subagent-batching.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-image-deck/references/subagent-batching.md")"
cat > "{{CODEX_HOME}}/skills/soil-image-deck/references/subagent-batching.md" <<'CODEX_LAZYPACK_SOIL_IMAGE_DECK_REFERENCES_SUBAGENT_BATCHING_MD'
# SOIL Subagent Batching

Use only when the user explicitly requests parallel generation and subagents are available.

1. Generate one representative content slide sequentially.
2. Review teaching clarity, layout, exact text, rounded typography, and style.
3. Save the approved golden sample and write its path into YAML.
4. Assign non-overlapping page ranges.
5. Give every worker the same spec, golden sample, output folder, and prompt contract.
6. Require separate prompt logs and visual inspection.
7. The primary agent reviews the final montage and selectively regenerates failures.

Parallel generation shares quota and does not guarantee consistency without the golden sample.
CODEX_LAZYPACK_SOIL_IMAGE_DECK_REFERENCES_SUBAGENT_BATCHING_MD

# soil-image-deck/references/validation.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-image-deck/references/validation.md")"
cat > "{{CODEX_HOME}}/skills/soil-image-deck/references/validation.md" <<'CODEX_LAZYPACK_SOIL_IMAGE_DECK_REFERENCES_VALIDATION_MD'
# SOIL Deck Validation

Validate teaching quality and artifact quality.

Teaching checks:

- The deck follows 引起動機 → 維持注意 → 喚起行動.
- Every page has one learning task and one core point.
- The layout exposes the intended relationship.
- Oral-only explanations are not crammed into the image.

Image checks:

- Exact text is correct and no extra text appears.
- Chinese display type is visibly bold and rounded, not angular or condensed.
- Safe area, subject count, layout, palette, material, and golden-sample style pass.
- No screen mockup, logo, watermark, or accidental UI appears.

Delivery checks:

1. Validate YAML and image count/ratio.
2. Inspect every source image and a montage.
3. Package the deck.
4. Render the exported PPTX and inspect the rendered montage.
5. Run overflow checks and report final absolute paths.
CODEX_LAZYPACK_SOIL_IMAGE_DECK_REFERENCES_VALIDATION_MD

# soil-image-deck/references/yaml-profile.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-image-deck/references/yaml-profile.md")"
cat > "{{CODEX_HOME}}/skills/soil-image-deck/references/yaml-profile.md" <<'CODEX_LAZYPACK_SOIL_IMAGE_DECK_REFERENCES_YAML_PROFILE_MD'
# SOIL YAML Profile

Use these top-level sections:

```yaml
schema_version: "soil_image_deck_v2"
deck: {}
canvas: {}
soil_flow: {}
design_system: {}
rhythm_policy: {}
layout_router: {}
slides: []
validation: {}
```

The fixed layer belongs in `design_system`; controlled layout choices belong in `layout_router`; page teaching data belongs in `slides`.

Required per-slide fields:

```yaml
- page: 1
  soil_phase: "hook"
  role: "cover"
  learning_task: "Know why this topic matters"
  core_point: "One teachable claim"
  semantic_structure: "focus"
  layout: {id: "cover_hero", variant: "left_title_right_visual"}
  visible_text: {title: "Short title"}
  speaker_only: "What the teacher explains aloud"
  visual: "Concrete image brief"
  output: "slides/images/page_01.png"
```

Use percentage zones for image prompts. Use PowerPoint coordinates only in `plate` overlay blocks.
CODEX_LAZYPACK_SOIL_IMAGE_DECK_REFERENCES_YAML_PROFILE_MD

# soil-image-deck/requirements.txt
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-image-deck/requirements.txt")"
cat > "{{CODEX_HOME}}/skills/soil-image-deck/requirements.txt" <<'CODEX_LAZYPACK_SOIL_IMAGE_DECK_REQUIREMENTS_TXT'
PyYAML
Pillow
python-pptx
CODEX_LAZYPACK_SOIL_IMAGE_DECK_REQUIREMENTS_TXT

# soil-image-deck/scripts/pack_pptx.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-image-deck/scripts/pack_pptx.py")"
cat > "{{CODEX_HOME}}/skills/soil-image-deck/scripts/pack_pptx.py" <<'CODEX_LAZYPACK_SOIL_IMAGE_DECK_SCRIPTS_PACK_PPTX_PY'
"""
soil-image-deck 打包腳本

支援兩種模式：
- baked（預設）：圖裡已含文字，pptx 每頁一張 full-bleed 圖即可
- plate：圖為無文字底圖，依 YAML spec 疊加可編輯文字框
"""
import argparse
import glob
from pathlib import Path
import platform
import subprocess
import yaml
from PIL import Image
from pptx import Presentation
from pptx.util import Inches, Pt, Emu
from pptx.dml.color import RGBColor
from pptx.enum.shapes import MSO_SHAPE
from pptx.enum.text import PP_ALIGN, MSO_ANCHOR


def crop_to_ratio(src_path: str, target_w_in: float, target_h_in: float,
                  images_dir: Path = None) -> str:
    """依目標寬高比中央裁切，避免 python-pptx 強制拉伸變形。"""
    if not src_path:
        return src_path
    target_ratio = target_w_in / target_h_in
    img = Image.open(src_path)
    w, h = img.size
    current_ratio = w / h
    if abs(current_ratio - target_ratio) < 0.01:
        return src_path
    if current_ratio > target_ratio:
        new_w = int(h * target_ratio)
        left = (w - new_w) // 2
        img = img.crop((left, 0, left + new_w, h))
    else:
        new_h = int(w / target_ratio)
        top = (h - new_h) // 2
        img = img.crop((0, top, w, top + new_h))
    cache_dir = (images_dir or Path(src_path).parent) / "cropped"
    cache_dir.mkdir(parents=True, exist_ok=True)
    out = cache_dir / f"{Path(src_path).stem}__{target_w_in:.2f}x{target_h_in:.2f}.png"
    img.save(out)
    return str(out)


DEFAULT_PALETTE = {
    "bg": "#0D1B2A",
    "primary": "#00C6FF",
    "highlight": "#FFD700",
    "card": "#1E3A5F",
    "text": "#FFFFFF",
    "muted": "#A5B4CB",
}

ROUNDED_FONT_CANDIDATES = [
    "jf open 粉圓 2.1",
    "jf open 粉圓",
    "GenSenRounded TW",
    "GenJyuuGothic",
    "源柔ゴシック",
]


def _installed_font_names() -> set[str]:
    """Return installed font family/display names without adding dependencies."""
    names: set[str] = set()
    if platform.system() == "Windows":
        try:
            import winreg

            key_path = r"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
            for hive in (winreg.HKEY_LOCAL_MACHINE, winreg.HKEY_CURRENT_USER):
                try:
                    with winreg.OpenKey(hive, key_path) as key:
                        index = 0
                        while True:
                            try:
                                display_name, _, _ = winreg.EnumValue(key, index)
                            except OSError:
                                break
                            names.add(display_name.replace(" (TrueType)", "").strip())
                            index += 1
                except OSError:
                    continue
        except Exception:
            pass
    else:
        try:
            result = subprocess.run(
                ["fc-list", "--format=%{family}\n"],
                capture_output=True,
                text=True,
                check=False,
            )
            for line in result.stdout.splitlines():
                names.update(part.strip() for part in line.split(",") if part.strip())
        except OSError:
            pass
    return names


def _norm_font(value: str) -> str:
    return "".join(value.casefold().split())


def resolve_rounded_font(style_cfg: dict) -> str:
    """Choose an installed rounded CJK font; never silently use an angular fallback."""
    requested = style_cfg.get("font_preferences") or []
    if isinstance(requested, str):
        requested = [requested]
    candidates = list(dict.fromkeys([*requested, *ROUNDED_FONT_CANDIDATES]))
    installed = _installed_font_names()
    installed_by_norm = {_norm_font(name): name for name in installed}
    for candidate in candidates:
        normalized = _norm_font(candidate)
        if normalized in installed_by_norm:
            return installed_by_norm[normalized]
        for installed_norm, installed_name in installed_by_norm.items():
            if normalized in installed_norm or installed_norm in normalized:
                return installed_name
    raise SystemExit(
        "plate 模式需要繁體中文粗圓字型。請先安裝以下任一字型："
        + "、".join(ROUNDED_FONT_CANDIDATES[:3])
        + "。為避免稜角字體，本技能不會默默替換成 Microsoft JhengHei。"
    )


def hex_to_rgb(h: str) -> RGBColor:
    h = h.lstrip("#")
    return RGBColor(int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16))


def find_latest(images_dir: Path, prefix: str) -> str | None:
    cands = sorted(glob.glob(str(images_dir / f"{prefix}_*.png")))
    return cands[-1] if cands else None


def _resolve_color(name_or_hex: str, palette: dict) -> RGBColor:
    if not name_or_hex:
        return hex_to_rgb("#FFFFFF")
    if name_or_hex.startswith("#"):
        return hex_to_rgb(name_or_hex)
    hex_v = palette.get(name_or_hex, "#FFFFFF")
    return hex_to_rgb(hex_v)


def add_textbox(slide, block: dict, palette: dict, default_font: str, title_font: str | None = None, body_font: str | None = None):
    """依 block 規格在 slide 上加一個文字框。
    block keys: type, text, x, y, w, h, size, bold, color, align, anchor
    type: title / subtitle / body / badge / highlight
    """
    btype = block.get("type", "body")
    x = Inches(float(block["x"]))
    y = Inches(float(block["y"]))
    w = Inches(float(block["w"]))
    h = Inches(float(block["h"]))
    text = block.get("text", "")
    size = block.get("size")
    bold = block.get("bold")
    color_name = block.get("color")
    align_name = (block.get("align") or "left").lower()
    align_map = {"left": PP_ALIGN.LEFT, "center": PP_ALIGN.CENTER, "right": PP_ALIGN.RIGHT}
    anchor_map = {"top": MSO_ANCHOR.TOP, "middle": MSO_ANCHOR.MIDDLE, "bottom": MSO_ANCHOR.BOTTOM}
    anchor_name = (block.get("anchor") or "top").lower()

    # 類型預設值 — 依林長揚 #1 比例（55/34/21/13）規格化
    # 原比例在 16:9 投影片為海報級：title=55、subtitle=34、body=21、muted=13
    # 海報感適度放大至 title=72；其他按比例縮放
    defaults = {
        "title":     {"size": 72, "bold": True,  "color": "text"},
        "subtitle":  {"size": 34, "bold": True,  "color": "primary"},
        "body":      {"size": 21, "bold": False, "color": "text"},
        "badge":     {"size": 18, "bold": True,  "color": "bg"},
        "highlight": {"size": 26, "bold": True,  "color": "highlight"},
        "muted":     {"size": 14, "bold": False, "color": "muted"},
    }
    d = defaults.get(btype, defaults["body"])
    if d:
        size = size or d["size"]
        bold = d["bold"] if bold is None else bold
        color_name = color_name or d["color"]

    # 決定字型：block.font > 類型配對 > default_font
    TITLE_TYPES = {"title", "subtitle", "badge", "highlight"}
    font_name = block.get("font")
    if not font_name:
        if btype in TITLE_TYPES:
            font_name = title_font or default_font
        else:
            font_name = body_font or default_font

    # badge = 先畫圓角矩形底色，再放文字
    if btype == "badge":
        bg_color_name = block.get("bg") or "primary"
        shape = slide.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, x, y, w, h)
        shape.fill.solid()
        shape.fill.fore_color.rgb = _resolve_color(bg_color_name, palette)
        shape.line.fill.background()
        tf = shape.text_frame
        tf.margin_left = tf.margin_right = Emu(30000)
        tf.margin_top = tf.margin_bottom = Emu(20000)
        tf.vertical_anchor = MSO_ANCHOR.MIDDLE
        p = tf.paragraphs[0]
        p.alignment = PP_ALIGN.CENTER
        p.text = text
        for run in p.runs:
            run.font.size = Pt(size)
            run.font.bold = True
            run.font.color.rgb = _resolve_color(color_name, palette)
            run.font.name = font_name
        return

    # card = 矩形卡片底，無文字（僅背景）
    if btype == "card":
        card_color = block.get("bg") or "card"
        border_color = block.get("border")
        shape = slide.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, x, y, w, h)
        shape.fill.solid()
        shape.fill.fore_color.rgb = _resolve_color(card_color, palette)
        if border_color:
            shape.line.color.rgb = _resolve_color(border_color, palette)
            shape.line.width = Pt(block.get("border_width", 1.5))
        else:
            shape.line.fill.background()
        return

    # bar = 細橫條
    if btype == "bar":
        shape = slide.shapes.add_shape(MSO_SHAPE.RECTANGLE, x, y, w, h)
        shape.fill.solid()
        shape.fill.fore_color.rgb = _resolve_color(color_name, palette)
        shape.line.fill.background()
        return

    # progress = 進度條（林長揚 #23：放進度條減輕觀眾壓力）
    # block 需有 current（目前頁）與 total（總頁數）
    if btype == "progress":
        current = int(block.get("current", 1))
        total = int(block.get("total", 10))
        track_color = block.get("track") or "card"
        fill_color = color_name or "primary"
        # 底條
        track = slide.shapes.add_shape(MSO_SHAPE.RECTANGLE, x, y, w, h)
        track.fill.solid()
        track.fill.fore_color.rgb = _resolve_color(track_color, palette)
        track.line.fill.background()
        # 填充段
        ratio = max(0.0, min(1.0, current / total))
        fill_w = int(w.emu * ratio) if hasattr(w, "emu") else int(w * ratio)
        fill = slide.shapes.add_shape(MSO_SHAPE.RECTANGLE, x, y, Emu(fill_w), h)
        fill.fill.solid()
        fill.fill.fore_color.rgb = _resolve_color(fill_color, palette)
        fill.line.fill.background()
        return

    # 一般文字框
    tb = slide.shapes.add_textbox(x, y, w, h)
    tf = tb.text_frame
    tf.word_wrap = True
    tf.vertical_anchor = anchor_map.get(anchor_name, MSO_ANCHOR.TOP)
    tf.margin_left = tf.margin_right = Emu(0)
    tf.margin_top = tf.margin_bottom = Emu(0)
    lines = text.split("\n")
    # 林長揚 #5：行距為文字大小的 50–75%，預設 line_spacing=1.2（含字高 → 視覺行距約 60%）
    line_spacing = block.get("line_spacing", 1.2)
    for i, line in enumerate(lines):
        p = tf.paragraphs[0] if i == 0 else tf.add_paragraph()
        p.alignment = align_map.get(align_name, PP_ALIGN.LEFT)
        p.line_spacing = line_spacing
        p.text = line
        for run in p.runs:
            run.font.size = Pt(size)
            run.font.bold = bold
            run.font.color.rgb = _resolve_color(color_name, palette)
            run.font.name = font_name


def pack_baked(images_dir: Path, output: Path):
    prs = Presentation()
    prs.slide_width = Inches(13.333)
    prs.slide_height = Inches(7.5)
    blank = prs.slide_layouts[6]

    pngs = sorted(glob.glob(str(images_dir / "page_*.png")))
    if not pngs:
        raise SystemExit(f"錯誤：{images_dir} 找不到 page_*.png")

    by_page = {}
    for p in pngs:
        prefix = "_".join(Path(p).name.split("_")[:2])
        by_page[prefix] = p

    for prefix in sorted(by_page.keys()):
        png = by_page[prefix]
        png = crop_to_ratio(png, 13.333, 7.5, images_dir)
        slide = prs.slides.add_slide(blank)
        slide.shapes.add_picture(png, 0, 0, prs.slide_width, prs.slide_height)
        print(f"  [baked] {prefix}  <-  {Path(png).name}")

    output.parent.mkdir(parents=True, exist_ok=True)
    prs.save(output)
    print(f"[OK] {output.resolve()}  ({len(by_page)} 頁)")


def pack_plate(images_dir: Path, output: Path, spec_path: Path):
    spec = yaml.safe_load(spec_path.read_text(encoding="utf-8"))

    palette = {**DEFAULT_PALETTE, **(spec.get("style", {}).get("palette", {}))}
    style_cfg = spec.get("style", {})
    default_font = resolve_rounded_font(style_cfg)
    title_font = style_cfg.get("title_font") or default_font
    body_font = style_cfg.get("body_font") or default_font

    prs = Presentation()
    prs.slide_width = Inches(13.333)
    prs.slide_height = Inches(7.5)
    blank = prs.slide_layouts[6]

    pages = spec.get("pages", [])
    if not pages:
        raise SystemExit("spec.yaml 沒有 pages 欄位")

    for page_def in pages:
        slide = prs.slides.add_slide(blank)
        img_prefix = page_def.get("image")  # e.g. page_01
        img_path = find_latest(images_dir, img_prefix) if img_prefix else None

        # 全背景色底（保險用，底圖若透明或未對齊也看得乾淨）
        bg_name = page_def.get("bg") or "bg"
        bg_shape = slide.shapes.add_shape(MSO_SHAPE.RECTANGLE, 0, 0, prs.slide_width, prs.slide_height)
        bg_shape.fill.solid()
        bg_shape.fill.fore_color.rgb = _resolve_color(bg_name, palette)
        bg_shape.line.fill.background()

        # 底圖（自動依目標 slot 比例裁切，避免變形）
        if img_path:
            img_w = float(page_def.get("img_w", 13.333))
            img_h = float(page_def.get("img_h", 7.5))
            ix = Inches(float(page_def.get("img_x", 0)))
            iy = Inches(float(page_def.get("img_y", 0)))
            # 若 page_def 明確指定 no_crop: true，則保留原圖
            if not page_def.get("no_crop"):
                img_path = crop_to_ratio(img_path, img_w, img_h, images_dir)
            slide.shapes.add_picture(img_path, ix, iy, Inches(img_w), Inches(img_h))

        # 文字層
        for block in page_def.get("blocks", []):
            add_textbox(slide, block, palette, default_font, title_font, body_font)

        print(f"  [plate] page {page_def.get('page')}  img={img_prefix}  blocks={len(page_def.get('blocks', []))}")

    output.parent.mkdir(parents=True, exist_ok=True)
    prs.save(output)
    print(f"[OK] {output.resolve()}  ({len(pages)} 頁)")


def main():
    p = argparse.ArgumentParser(description="soil-image-deck 打包 pptx")
    p.add_argument("--images-dir", default="slides/images", help="圖片目錄")
    p.add_argument("--output", default="slides/output.pptx", help="輸出 pptx")
    p.add_argument("--mode", choices=["baked", "plate"], default="baked",
                   help="baked=圖內含文字；plate=底圖+可編輯文字框")
    p.add_argument("--spec", default=None, help="plate 模式的 YAML 規格檔")
    args = p.parse_args()

    images_dir = Path(args.images_dir)
    output = Path(args.output)

    if args.mode == "baked":
        pack_baked(images_dir, output)
    else:
        if not args.spec:
            raise SystemExit("plate 模式需要 --spec <spec.yaml>")
        pack_plate(images_dir, output, Path(args.spec))


if __name__ == "__main__":
    main()
CODEX_LAZYPACK_SOIL_IMAGE_DECK_SCRIPTS_PACK_PPTX_PY
chmod +x "{{CODEX_HOME}}/skills/soil-image-deck/scripts/pack_pptx.py"

# soil-image-deck/scripts/validate_spec.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-image-deck/scripts/validate_spec.py")"
cat > "{{CODEX_HOME}}/skills/soil-image-deck/scripts/validate_spec.py" <<'CODEX_LAZYPACK_SOIL_IMAGE_DECK_SCRIPTS_VALIDATE_SPEC_PY'
#!/usr/bin/env python3
import argparse
from pathlib import Path
import sys

try:
    import yaml
except ImportError:
    raise SystemExit("PyYAML is required: python -m pip install PyYAML")


ALLOWED_PHASES = {"hook", "attention", "action"}
ALLOWED_LAYOUTS = {
    "cover_hero", "question_focus", "misconception_dual", "comparison_split",
    "process_timeline", "classification_grid", "case_scene_analysis",
    "relationship_map", "data_focus", "summary_three", "action_next_step",
    "section_divider",
}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--spec", required=True)
    args = parser.parse_args()
    path = Path(args.spec)
    data = yaml.safe_load(path.read_text(encoding="utf-8"))
    errors = []

    required_root = ("schema_version", "deck", "canvas", "soil_flow", "design_system", "layout_router", "slides", "validation")
    for key in required_root:
        if not isinstance(data, dict) or key not in data:
            errors.append(f"root: missing {key}")

    slides = data.get("slides", []) if isinstance(data, dict) else []
    pages = []
    for index, slide in enumerate(slides, 1):
        where = f"slides[{index}]"
        for key in ("page", "soil_phase", "role", "learning_task", "core_point", "semantic_structure", "layout", "visible_text", "speaker_only", "visual", "output"):
            if not isinstance(slide, dict) or key not in slide:
                errors.append(f"{where}: missing {key}")
        if not isinstance(slide, dict):
            continue
        pages.append(slide.get("page"))
        if slide.get("soil_phase") not in ALLOWED_PHASES:
            errors.append(f"{where}: invalid soil_phase")
        layout_id = (slide.get("layout") or {}).get("id") if isinstance(slide.get("layout"), dict) else None
        if layout_id and layout_id not in ALLOWED_LAYOUTS:
            errors.append(f"{where}: unsupported layout id {layout_id}")

    if not slides:
        errors.append("root: slides must be a non-empty list")
    if len(pages) != len(set(pages)):
        errors.append("slides: duplicate page numbers")
    if pages and pages != list(range(1, len(pages) + 1)):
        errors.append("slides: page numbers must be sequential from 1")

    expected = (data.get("deck") or {}).get("slide_count") if isinstance(data, dict) else None
    if expected is not None and expected != len(slides):
        errors.append(f"deck.slide_count={expected}, but slides has {len(slides)} entries")

    font_feel = (((data.get("design_system") or {}).get("typography") or {}).get("font_feel", ""))
    if not any(token in str(font_feel).lower() for token in ("圓", "round")):
        errors.append("design_system.typography.font_feel must require rounded typography")

    phases = {slide.get("soil_phase") for slide in slides if isinstance(slide, dict)}
    if slides and phases != ALLOWED_PHASES:
        errors.append("slides must include hook, attention, and action phases")

    if errors:
        print("INVALID")
        for error in errors:
            print(f"- {error}")
        return 1
    print(f"VALID: {path} ({len(slides)} SOIL slides)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
CODEX_LAZYPACK_SOIL_IMAGE_DECK_SCRIPTS_VALIDATE_SPEC_PY
chmod +x "{{CODEX_HOME}}/skills/soil-image-deck/scripts/validate_spec.py"

# soil-image-deck/scripts/verify_images.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-image-deck/scripts/verify_images.py")"
cat > "{{CODEX_HOME}}/skills/soil-image-deck/scripts/verify_images.py" <<'CODEX_LAZYPACK_SOIL_IMAGE_DECK_SCRIPTS_VERIFY_IMAGES_PY'
#!/usr/bin/env python3
import argparse
from pathlib import Path
import sys

try:
    import yaml
    from PIL import Image
except ImportError:
    raise SystemExit("PyYAML and Pillow are required: python -m pip install PyYAML Pillow")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--spec", required=True)
    parser.add_argument("--images-dir", required=True)
    parser.add_argument("--ratio-tolerance", type=float, default=0.01)
    args = parser.parse_args()
    spec = yaml.safe_load(Path(args.spec).read_text(encoding="utf-8"))
    folder = Path(args.images_dir)
    errors = []

    for slide in spec.get("slides", []):
        expected = Path(slide["output"]).name
        path = folder / expected
        if not path.exists():
            errors.append(f"missing {expected}")
            continue
        with Image.open(path) as image:
            ratio = image.width / image.height
            if abs(ratio - 16 / 9) > args.ratio_tolerance:
                errors.append(f"{expected}: ratio {ratio:.4f} is not 16:9")
            print(f"{expected}: {image.width}x{image.height} ratio={ratio:.4f}")

    if errors:
        print("INVALID")
        for error in errors:
            print(f"- {error}")
        return 1
    print("VALID: all expected images exist and match the target ratio")
    return 0


if __name__ == "__main__":
    sys.exit(main())
CODEX_LAZYPACK_SOIL_IMAGE_DECK_SCRIPTS_VERIFY_IMAGES_PY
chmod +x "{{CODEX_HOME}}/skills/soil-image-deck/scripts/verify_images.py"

````

<!-- END EMBEDDED_SKILLS -->
