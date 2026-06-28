# 23-Visual-Note-Generator-Skill-安裝

> 版本：2026-06-19 Codex App 版  
> 用途：使用固定、可攜的手繪筆記轉圖流程，搭配可替換的個人 Style Profile，生成方向正確、文字與版面忠實、16:9、至少 2K 的圖解作品。

## 設計原則

這個 Skill 將「通用流程」和「個人風格」分開：

| 檔案 | 責任 | 是否因使用者而改變 |
|---|---|---|
| `SKILL.md` | 觸發、載入順序、流程與 Style Profile 邊界 | 否 |
| `references/workflow-contract.md` | 方向校正、必要提問、生成步驟、輸出格式、作品集交付 | 否 |
| `references/generation-guardrails.md` | 內容與版面限制、提示結構、驗收、修復與踩坑 | 否 |
| `references/style-profile-guide.md` | Style Profile 欄位、優先序與替換方式 | 否 |
| `references/default-style-profile.yaml` | 預設個人風格；內建 Arry 風格，純文字即可使用 | 是 |
| `references/style-profile-template.yaml` | 其他使用者建立個人風格的空白模板 | 是 |
| `agents/openai.yaml` | Codex UI 顯示名稱、簡介與預設啟動 prompt | 否；不是流程或風格來源 |

## 預設效果

所有 LazyPack 安裝者預設都會取得 Arry 的文字化風格：近白暖底、黑色手繪線、低飽和粉彩、橘紅重點、大量留白、克制點綴、教育型 Q 版人物與手寫標題。

這個預設不依賴 Arry 的本機圖片路徑。若使用者本機有角色圖或作品集，可作為額外 fidelity reference；若沒有，仍使用 YAML 文字風格完成生成。

## 固定 Workflow

- 先校正照片方向，再讀取文字與版面。
- 建立精確文字、版面、圖示與人物姿勢清單。
- 原稿有人物時，先確認保留、套用 Profile 角色，或建立其他 Q 版角色。
- 保留人物方向、角度、手勢與道具，不自行新增動作。
- 原文逐字保留，版塊只接受小幅挪移。
- 每次編修後重新檢查全部文字與版面。
- 成品固定 16:9，最終至少 2560 × 1440。
- 使用者確認成品後，才詢問是否存入作品集。

## 改成自己的風格

1. 複製 `references/style-profile-template.yaml`。
2. 依 3–8 張代表作品填入背景、線條、配色、字體、裝飾、角色與參考圖用途。
3. 將完成的內容存成新的 YAML，並在使用時明確選擇；若要成為預設，取代 `default-style-profile.yaml`。
4. 不要修改 `workflow-contract.md` 來改顏色、角色或手繪風格。
5. 本機資產路徑是選用項目；維持 `missing_asset_behavior: use_text_profile`。

## 安裝

本文件採自含式安裝；全域 skill 的實體主版本在 `{{CODEX_HOME}}/skills/visual-note-generator/`，Arry 環境中該路徑會透過 symlink 指向 `{{SYNC_ROOT}}/skills/visual-note-generator/`。LazyPack 不再維護舊式獨立 skill 子目錄。

```bash
mkdir -p "{{CODEX_HOME}}/skills/visual-note-generator/references" "{{CODEX_HOME}}/skills/visual-note-generator/agents"

# visual-note-generator/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/visual-note-generator/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/visual-note-generator/SKILL.md" <<'CODEX_LAZYPACK_VISUAL_NOTE_SKILL_MD'
---
name: visual-note-generator
description: Turn a photographed or scanned hand-drawn note into an upright, source-faithful 16:9 visual note using a replaceable personal Style Profile. Use when the user provides 手繪筆記、圖解筆記、白紙草圖、拍照筆記 or asks for Visual Note Generator, exact Traditional Chinese text preservation, Q-version character handling, a personalized hand-drawn style, or a finished 2K visual-note image. This skill is only for hand-drawn-note-to-image creation, not article rewriting, transcripts, social posts, prose-to-infographic work, or slide outlines.
---

# Visual Note Generator

Create one finished raster visual note from one hand-drawn source. Keep the workflow portable and keep personal rendering style in a replaceable YAML Style Profile.

## File Responsibilities

- `SKILL.md`: trigger, routing, loading order, and ownership boundaries.
- `references/workflow-contract.md`: process steps, required questions, output contract, and portfolio handoff.
- `references/generation-guardrails.md`: content/layout locks, prompt construction, validation, failure recovery, and learned pitfalls.
- `references/style-profile-guide.md`: Style Profile schema, precedence, customization, and portability rules.
- `references/default-style-profile.yaml`: bundled default personal style. It currently contains Arry's established style so every LazyPack installation can reproduce that look without local image assets.
- `references/style-profile-template.yaml`: blank portable starting point for another user's style.
- `agents/openai.yaml`: Codex UI metadata only. Never treat it as workflow instructions, output rules, or style data.

## Mandatory Loading Order

Before analyzing or generating:

1. Read `references/workflow-contract.md` completely.
2. Read `references/generation-guardrails.md` completely.
3. Read `references/style-profile-guide.md` completely.
4. Resolve and read exactly one Style Profile:
   - explicit profile supplied or selected by the user;
   - otherwise `references/default-style-profile.yaml`.

Do not merge Style Profile fields into the generic workflow files. Do not infer generic workflow rules from a personal profile.

## Style Profile Precedence

Use this order:

1. the user's explicit instructions for the current image;
2. a user-selected or attached Style Profile;
3. the bundled `default-style-profile.yaml`;
4. generic clean hand-drawn rendering only if no profile can be read.

User instructions may override style choices, but never override source-text fidelity or safety constraints unless the user explicitly corrects the source content.

## Execution

- Use the built-in image-generation/editing capability for the raster result.
- Treat the upright source image as the sole content and composition authority.
- Treat the selected Style Profile as rendering data only.
- Apply the workflow and guardrails independently of which Style Profile is selected.
- Deliver exactly 16:9 and at least 2560 × 1440 pixels; upscale with high-quality Lanczos resampling when native generation is smaller.

## Portability

The bundled Arry profile is textual and must work without Arry's local asset folders. Local character sheets and portfolio images are optional fidelity references, not installation requirements.

Another user should keep the same Skill workflow and replace only `default-style-profile.yaml` with a profile based on `style-profile-template.yaml`. They must not rewrite `workflow-contract.md` merely to change colors, handwriting, characters, decorations, or visual mood.
CODEX_LAZYPACK_VISUAL_NOTE_SKILL_MD

# visual-note-generator/agents/openai.yaml
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/visual-note-generator/agents/openai.yaml")"
cat > "{{CODEX_HOME}}/skills/visual-note-generator/agents/openai.yaml" <<'CODEX_LAZYPACK_VISUAL_NOTE_AGENTS_OPENAI_YAML'
interface:
  display_name: "圖解筆記生成"
  short_description: "把手繪筆記套用可替換 Style Profile 生成圖解"
  default_prompt: "Use $visual-note-generator to turn this hand-drawn note into an upright, source-faithful 16:9 visual note using the selected Style Profile."

policy:
  allow_implicit_invocation: true
CODEX_LAZYPACK_VISUAL_NOTE_AGENTS_OPENAI_YAML

# visual-note-generator/references/default-style-profile.yaml
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/visual-note-generator/references/default-style-profile.yaml")"
cat > "{{CODEX_HOME}}/skills/visual-note-generator/references/default-style-profile.yaml" <<'CODEX_LAZYPACK_VISUAL_NOTE_REFERENCES_DEFAULT_STYLE_PROFILE_YAML'
profile_version: "1.0"
profile_id: "arry-default"
display_name: "Arry warm educational hand-drawn notes"
classification: "personal-rendering-style-only"

visual_style:
  canvas_mood:
    background: "very pale warm white or ivory, nearly white"
    white_space_ratio: "approximately 75-85 percent"
    texture: "subtle paper or marker texture; never tan, sepia, gray, or heavily shaded"
  line_language:
    primary: "clean black hand-marker or pen outlines"
    geometry: "slightly human and irregular, never sterile vector-perfect"
    fills: "light marker hatching or translucent pastel washes"
    arrows: "simple black hand-drawn arrows and braces"
  palette:
    primary_accent: "orange-red for title banners, flags, underlines, and key emphasis"
    secondary_accents:
      - "clear blue"
      - "soft purple"
      - "leaf green"
      - "yellow-orange"
      - "soft pink"
    fill_behavior: "low saturation, translucent, pale enough that white remains dominant"
    avoid:
      - "heavy gradients"
      - "dark shadows"
      - "muddy beige"
      - "neon colors"
      - "large saturated panels"
  typography:
    traditional_chinese: "clear handwritten marker lettering"
    english: "simple handwritten Latin lettering"
    body_color: "black"
    emphasis_colors:
      - "orange-red"
      - "dark blue"
    hierarchy: "large title, medium section labels, compact readable body text"
  composition_preferences:
    atmosphere: "clean sketchbook spread with generous breathing room"
    title_treatments:
      - "ribbon banner"
      - "outlined arrow banner"
      - "large handwritten title with underline"
    common_shapes:
      - "rounded rectangles"
      - "speech and thought bubbles"
      - "Venn circles"
      - "simple grids and axes"
      - "hand-drawn braces"
      - "mountains, roads, flags, keys, stars, and lightbulbs when supported by the source"
    decoration: "sparse stars, spark lines, clouds, tape strokes, and underlines; never decorate every empty area"
    density: "spacious, readable, educational, and warm rather than corporate"

character_profiles:
  arry:
    role: "recurring professional Q-version educator and author identity"
    appearance:
      hair: "short black hair with soft layered bangs"
      eyes: "large warm dark-brown eyes"
      face: "round friendly face with light blush"
      outfit: "white inner shirt, light beige-orange striped overshirt, khaki pants, white sneakers"
      mood: "warm, optimistic, curious, calm, and helpful"
    rendering: "professional educational chibi; expressive but not babyish"
    pose_policy: "match the source pose, direction, gesture, visible face angle, and props instead of defaulting to a front-facing presenter"
    signature:
      required: true
      exact_text: "Arry"
      placement: "small handwritten signature beside the character without covering content"
  other_characters:
    rendering: "use the same professional educational chibi line language"
    identity_policy: "preserve supplied hair, glasses, clothing, role cues, and source pose"
    signature_policy: "never label another character as Arry"

reference_guidance:
  use_by_property:
    mountain_road_and_summit: "3-3 OKR：做最重要的事_Arry.png"
    pale_palette_and_diagrams: "4-1 心理安全感_Arry.png"
    thinking_side_profile_and_boxes: "1-1 做你的生命設計師_Arry.png"
    multi_character_role_scenes: "解碼主管思維.jpg"
    mixed_diagrams_and_restrained_decoration: "5-4 1枝筆＋1張紙說服各種人_Arry.png"
    rear_three_quarter_backpack_and_road: "6-3 精實學習法_Arry.png"
  selection_rule: "select references by one named property and do not copy unrelated content"

optional_asset_routes:
  character_assets: "{{ASSISTANT_ROOT}}/knowledge/arry-visual-identity/"
  visual_note_references: "{{ASSISTANT_ROOT}}/knowledge/visual-note-references/"
  obsidian_portfolio: "{{OBSIDIAN_VAULT}}/創作庫/Visual-Note-References/"
  missing_asset_behavior: "use_text_profile"

rendering_snippet: "Render as an Arry-style educational visual note: near-white warm ivory background, clean black hand-marker lines, slight human irregularity, sparse orange-red emphasis, pale blue/purple/green/yellow-orange/pink washes, generous whitespace, handwritten Traditional Chinese, restrained sketchbook decoration, and professional educational Q-version characters."
CODEX_LAZYPACK_VISUAL_NOTE_REFERENCES_DEFAULT_STYLE_PROFILE_YAML

# visual-note-generator/references/generation-guardrails.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/visual-note-generator/references/generation-guardrails.md")"
cat > "{{CODEX_HOME}}/skills/visual-note-generator/references/generation-guardrails.md" <<'CODEX_LAZYPACK_VISUAL_NOTE_REFERENCES_GENERATION_GUARDRAILS_MD'
# Generation Guardrails and Failure Recovery

These rules apply to every Style Profile.

## Content and Composition Locks

- Use the upright source as the sole authority for concepts, wording, hierarchy, and visual logic.
- Preserve all text verbatim. Do not summarize, shorten, modernize, translate, or replace difficult words.
- Preserve relative block placement, reading order, character side, direction, pose, gesture, and props.
- Do not force a standard infographic layout over the source.
- Do not add unsupported concepts, labels, characters, metaphors, examples, or claims.
- Small spacing, scale, and alignment adjustments are allowed only for legibility and 16:9 fitting.

## Prompt Assembly Contract

Build generation or edit prompts in this order:

1. `REFERENCE ROLES`: state the role of every supplied image.
2. `EXACT TEXT`: list canonical strings verbatim.
3. `COMPOSITION INVARIANTS`: list locations, reading order, diagrams, and character direction/pose.
4. `SELECTED STYLE PROFILE`: translate only the relevant profile fields into rendering instructions.
5. `CHARACTER DECISION`: state the confirmed identity and any profile-defined signature rule.
6. `OUTPUT CONTRACT`: 16:9, highest native quality, final minimum 2560 × 1440.
7. `NEGATIVE CONSTRAINTS`: no new content, no layout redesign, no gesture invention, no copied reference text, no watermark.

When a reference is used for one property, explicitly forbid copying its unrelated text, objects, people, gestures, or layout.

## Validation Checklist

Compare the generated image with the upright source and selected Style Profile:

- orientation is correct;
- aspect ratio is exactly 16:9;
- dimensions are at least 2560 × 1440;
- every string, number, punctuation mark, Latin letter, and symbol is correct;
- title and blocks preserve relative placement and reading order;
- diagrams and arrows preserve their relationships;
- characters preserve direction, pose, visible face angle, gesture, clothing, and props;
- profile-specific identity marks or signatures are present;
- palette, line style, typography, decoration, and visual density match the selected profile;
- no reference-only content leaked into the image;
- no watermark, accidental crop, or unintended border appears.

## Failure Recovery

Make one targeted correction at a time. State the exact change and declare all other elements invariant. Re-run the full validation checklist after every edit.

If two targeted edit attempts keep corrupting correct text or layout:

- stop repeating broad image edits;
- explain the unstable elements;
- use deterministic text overlay/compositing when appropriate, or ask the user which defect should be prioritized;
- never claim exact text fidelity without re-reading the image.

## Learned Pitfalls

### Orientation Drift

Raw pixels and displayed EXIF orientation may differ. Rotate a working copy and inspect it before deciding left/right placement.

### Handwriting Misread

Similar Chinese characters, abbreviations, or Latin letters are easily misread. Build a canonical text inventory and ask about uncertain strings before generation.

### Character Drift

Style references can move a character to another side or invent a presenter gesture. Source pose and direction are hard invariants.

### Missing Identity Mark

A profile may require a signature or author mark. Treat it as identity data and validate it after every generation or edit.

### Style Profile Contamination

Do not copy workflow rules, output dimensions, or source text into a Style Profile. Do not copy palette or character identity into workflow files.

### Reference Contamination

A motif reference can introduce tunnels, flags, text, or props. Restrict every reference to one declared role.

### Edit Regression

An edit may silently damage previously correct areas. Re-check all text and layout after every edit.

### False 2K Assumption

Do not treat “high resolution” as proof of 2K. Inspect pixel dimensions and upscale when required.
CODEX_LAZYPACK_VISUAL_NOTE_REFERENCES_GENERATION_GUARDRAILS_MD

# visual-note-generator/references/style-profile-guide.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/visual-note-generator/references/style-profile-guide.md")"
cat > "{{CODEX_HOME}}/skills/visual-note-generator/references/style-profile-guide.md" <<'CODEX_LAZYPACK_VISUAL_NOTE_REFERENCES_STYLE_PROFILE_GUIDE_MD'
# Style Profile Guide

A Style Profile is personal rendering data. It changes how a note looks without changing how the Skill works.

## What Belongs in a Style Profile

- background tone and texture;
- line weight, irregularity, and drawing medium;
- palette and fill behavior;
- typography appearance and emphasis colors;
- typical shapes and decorative vocabulary;
- whitespace and visual-density preferences;
- character identities, appearance, clothing, author marks, and signature rules;
- optional portfolio filenames and asset paths used only for fidelity;
- a concise rendering prompt snippet.

## What Must Not Be in a Style Profile

- orientation workflow;
- required user questions;
- source transcription rules;
- output aspect ratio, resolution, or file format;
- generic content/layout fidelity rules;
- validation procedure;
- failure recovery;
- save, overwrite, or portfolio handoff behavior.

Those belong in `workflow-contract.md` or `generation-guardrails.md`.

## Default and Custom Profiles

`default-style-profile.yaml` is bundled with Arry's textual style. It is the default for every LazyPack installation and works without Arry's private/local image folders.

To use another personal style:

1. Copy `style-profile-template.yaml` to a new YAML file in this `references/` directory.
2. Give it a unique `profile_id` and `display_name`.
3. Analyze three to eight representative works and fill only stable visual traits.
4. Add optional local asset paths if available; keep `missing_asset_behavior: use_text_profile`.
5. Select that file explicitly in the request, or replace `default-style-profile.yaml` if it should become the installation default.
6. Keep workflow and guardrail files unchanged.

## Profile Precedence

1. current user instructions;
2. explicitly selected profile;
3. bundled default profile;
4. generic clean hand-drawn fallback.

## Asset Behavior

Asset paths are optional fidelity enhancements. A portable installation must still render from the YAML's textual traits when those paths are absent.

Never create another user's personal folder structure merely because an optional path is missing.

## Schema Stability

Keep these top-level keys:

- `profile_version`
- `profile_id`
- `display_name`
- `classification`
- `visual_style`
- `character_profiles`
- `reference_guidance`
- `optional_asset_routes`
- `rendering_snippet`

Additional style-only keys are allowed. Workflow keys are not.
CODEX_LAZYPACK_VISUAL_NOTE_REFERENCES_STYLE_PROFILE_GUIDE_MD

# visual-note-generator/references/style-profile-template.yaml
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/visual-note-generator/references/style-profile-template.yaml")"
cat > "{{CODEX_HOME}}/skills/visual-note-generator/references/style-profile-template.yaml" <<'CODEX_LAZYPACK_VISUAL_NOTE_REFERENCES_STYLE_PROFILE_TEMPLATE_YAML'
profile_version: "1.0"
profile_id: "replace-with-unique-id"
display_name: "Replace with personal style name"
classification: "personal-rendering-style-only"

visual_style:
  canvas_mood:
    background: "Describe background color and brightness"
    white_space_ratio: "Describe desired whitespace"
    texture: "Describe paper, marker, watercolor, or other texture"
  line_language:
    primary: "Describe line color and medium"
    geometry: "Describe line regularity"
    fills: "Describe fill technique"
    arrows: "Describe arrow and connector style"
  palette:
    primary_accent: "Primary accent"
    secondary_accents:
      - "Accent 1"
      - "Accent 2"
    fill_behavior: "Describe saturation and opacity"
    avoid:
      - "Unwanted palette behavior"
  typography:
    traditional_chinese: "Describe Chinese lettering"
    english: "Describe Latin lettering"
    body_color: "Body text color"
    emphasis_colors:
      - "Emphasis color"
    hierarchy: "Describe title, section, and body hierarchy"
  composition_preferences:
    atmosphere: "Describe overall visual atmosphere"
    title_treatments:
      - "Preferred title treatment"
    common_shapes:
      - "Preferred shape vocabulary"
    decoration: "Describe allowed decoration and density"
    density: "Describe whitespace and information density"

character_profiles:
  default_character:
    role: "Describe recurring character role"
    appearance:
      hair: "Describe"
      eyes: "Describe"
      face: "Describe"
      outfit: "Describe"
      mood: "Describe"
    rendering: "Describe character illustration style"
    pose_policy: "Describe only style-specific pose tendencies; source pose remains authoritative"
    signature:
      required: false
      exact_text: ""
      placement: ""

reference_guidance:
  use_by_property: {}
  selection_rule: "select references by one named property and do not copy unrelated content"

optional_asset_routes:
  character_assets: ""
  visual_note_references: ""
  obsidian_portfolio: ""
  missing_asset_behavior: "use_text_profile"

rendering_snippet: "Write one concise paragraph that describes only the personal rendering style."
CODEX_LAZYPACK_VISUAL_NOTE_REFERENCES_STYLE_PROFILE_TEMPLATE_YAML

# visual-note-generator/references/workflow-contract.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/visual-note-generator/references/workflow-contract.md")"
cat > "{{CODEX_HOME}}/skills/visual-note-generator/references/workflow-contract.md" <<'CODEX_LAZYPACK_VISUAL_NOTE_REFERENCES_WORKFLOW_CONTRACT_MD'
# Workflow Contract

This file defines the generic process and output behavior. It must remain valid when the personal Style Profile changes.

## Inputs

Required:

- one photographed or scanned hand-drawn note;
- a readable source or user corrections for ambiguous text.

Optional:

- a selected Style Profile;
- character identity references;
- portfolio images for style fidelity;
- a requested filename or destination.

## Required Workflow

### 0. Normalize Orientation

- Inspect the raw image before transcription.
- If sideways or upside down, create a non-destructive upright working copy.
- Apply the required clockwise or counterclockwise rotation exactly.
- View the working copy and confirm that text reads naturally before continuing.
- Never overwrite the original source image.

### 1. Build a Source Specification

Record internally:

- every exact string, punctuation mark, number, Latin letter, and symbol;
- title, sections, diagrams, arrows, braces, icons, speech bubbles, and visual metaphor;
- relative positions, reading order, hierarchy, and whitespace;
- each character's location, direction, body angle, visible face angle, pose, gesture, clothing, and props.

Do not silently guess ambiguous handwriting. Ask only for the uncertain strings. User corrections become canonical.

### 2. Ask the Character Question When Needed

If a person appears in the source, ask whether to:

1. keep the original drawn character;
2. replace it with a character defined in the selected Style Profile;
3. create another Q-version character from a supplied reference.

Preserve the source direction, pose, gesture, props, and visible face angle. Allow only small shifts needed to prevent overlap. If no person appears, do not add one unless explicitly requested.

### 3. Resolve the Style Profile

- Use the profile precedence defined in `SKILL.md`.
- Read the profile before choosing reference images or writing the generation prompt.
- If optional asset paths do not exist, continue from the textual profile; do not fail and do not recreate another user's directory structure.
- If the user requests a different personal style, use or create a new profile based on `style-profile-template.yaml` rather than editing generic workflow files.

### 4. Select Reference Images

Use two to four references only when available and useful. Select by a named property such as palette, title treatment, diagram density, character angle, or road/mountain rendering.

Assign each image exactly one role:

- source image: content and composition authority;
- style reference: rendering only;
- character reference: identity only;
- motif reference: one named structural motif only.

### 5. Generate and Iterate

- Generate an upright 16:9 image at the highest native resolution available.
- Preserve source text and composition; allow only small spacing adjustments.
- Inspect the first result against the upright source and the selected profile.
- Correct one issue at a time. After every edit, re-check the entire image for regressions.

### 6. Produce the Final Deliverable

The final image must be:

- exactly 16:9;
- at least 2560 × 1440 pixels;
- PNG unless the user requests another format;
- free of watermarks and unintended borders;
- visually checked after any required upscaling.

If native generation is smaller, create a 2560 × 1440 Lanczos-upscaled version without changing composition or aspect ratio.

### 7. Portfolio Handoff

- Iterate until the user explicitly confirms the image is correct.
- Only after confirmation, ask whether to save it as a future style reference.
- If yes, confirm the filename and destination.
- Do not overwrite an existing work without explicit approval.
- Verify the saved file exists and meets the output contract.

## Further Questions

Ask only when one of these affects the result materially:

- ambiguous handwriting;
- unclear rotation direction;
- a character is present and identity choice is required;
- conflicting placement instructions;
- the user requests a non-default style but has not supplied or selected a profile;
- the destination or overwrite decision is unresolved after final approval.

Do not ask again for details already visible in the source or already specified by the user.
CODEX_LAZYPACK_VISUAL_NOTE_REFERENCES_WORKFLOW_CONTRACT_MD

echo "Installed visual-note-generator skill into {{CODEX_HOME}}/skills/visual-note-generator"
```

## 驗證

```bash
python3 "${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-creator/scripts/quick_validate.py" \
  "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator"

test -f "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator/SKILL.md"
test -f "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator/agents/openai.yaml"
test -f "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator/references/default-style-profile.yaml"
test -f "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator/references/generation-guardrails.md"
test -f "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator/references/style-profile-guide.md"
test -f "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator/references/style-profile-template.yaml"
test -f "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator/references/workflow-contract.md"
```

更新全域 Skill 後，建議開新 Codex 對話，讓 metadata 重新載入。
