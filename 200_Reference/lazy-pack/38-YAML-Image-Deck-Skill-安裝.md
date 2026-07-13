# 38-YAML-Image-Deck-Skill-安裝

> 版本：2026-07-13 Codex App 版
> 用途：建立通用 YAML-controlled image-first deck，不限定 SOIL；用固定視覺語法、受控版型、黃金樣張與逐頁 YAML 內容產生 NotebookLM-style 圖片式簡報。
> 成品：下載者可直接使用本文文末「內建 Skill 完整安裝內容」建立 `{{CODEX_HOME}}/skills/yaml-image-deck/`，不需要取得原作者本機資料夾。

## 來源與歷史紀錄

- 初次同步日期：2026-07-13。
- 來源 repo：`mathruffian-dot/yaml-image-deck`。
- 來源 commit：`8fd0e1e feat: add YAML-driven image deck skill`。
- Codex 全域 skill：`{{CODEX_HOME}}/skills/yaml-image-deck/SKILL.md`。
- 適用場景：NotebookLM-style image presentation、非 SOIL 的全圖片 PPTX、固定視覺語法的 batch image slides、baked 或 plate 模式。

## 和 SOIL Deck Skills 的分工

| 需求 | 使用 |
|---|---|
| 通用 YAML 圖片式簡報，不限定教學法 | `yaml-image-deck` |
| 需要 SOIL 教學節奏、六引擎、引起動機 / 維持注意 / 喚起行動 | `soil-image-deck` |
| 需要互動網頁簡報 | `soil-html-deck` |
| 需要可編輯 PowerPoint 文字與物件 | `soil-general-deck` |
| NotebookLM 風格 YAML 規劃與反覆修改 | `presentation-workflow`；必要時轉給 `yaml-image-deck` 產出可控圖片式 deck |

## 這版和來源工具文件的差異

| 項目 | Codex 版調整 |
|---|---|
| 1 | 保留 `yaml-image-deck` 為獨立全域 skill，不併入 SOIL 三 skill，避免模糊通用圖片簡報與 SOIL 教學簡報的邊界。 |
| 2 | 正式安裝路徑統一為 `{{CODEX_HOME}}/skills/yaml-image-deck/`。 |
| 3 | 保留來源 package 的 `assets/spec-template.yaml`、layout / prompting / schema / validation / subagent references，以及 `validate_spec.py`、`verify_images.py`。 |
| 4 | Codex 預設使用內建 image generation，不要求 API key；本機腳本只做 YAML 檢查、圖片比例檢查與包裝前驗收輔助。 |

## 安裝方式

1. 打開本文文末「內建 Skill 完整安裝內容」。
2. 把整段安裝腳本複製到自己的環境執行。
3. 執行前先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。
4. 若要使用內建 Python helpers，安裝依賴：

```bash
python -m pip install -r "{{CODEX_HOME}}/skills/yaml-image-deck/requirements.txt"
```

依賴包含 `PyYAML` 與 `Pillow`，供 `validate_spec.py` 與 `verify_images.py` 使用。

5. 安裝後開新 Codex 對話或重啟 Codex App，讓新的全域 skill metadata 被重新載入。

## 驗證

```bash
test -f "{{CODEX_HOME}}/skills/yaml-image-deck/SKILL.md" && echo "yaml-image-deck SKILL.md ok"
test -f "{{CODEX_HOME}}/skills/yaml-image-deck/assets/spec-template.yaml" && echo "spec template ok"
test -d "{{CODEX_HOME}}/skills/yaml-image-deck/references" && echo "references ok"
test -d "{{CODEX_HOME}}/skills/yaml-image-deck/scripts" && echo "scripts ok"
python -m pip install -r "{{CODEX_HOME}}/skills/yaml-image-deck/requirements.txt"
python "{{CODEX_HOME}}/skills/yaml-image-deck/scripts/validate_spec.py" --spec "{{CODEX_HOME}}/skills/yaml-image-deck/assets/spec-template.yaml"
```

合理結果是每一行都顯示 `ok`，且 validator 顯示 `VALID`。

## 使用方式

安裝後可用下列語句觸發：

- 「使用 yaml-image-deck 幫我做圖片式簡報」
- 「把這份內容做成 YAML 控制版型的圖片簡報」
- 「做一份 NotebookLM-style 全圖片 PPTX」
- 「固定視覺語法，用黃金樣張批次生圖」
- 「我要 baked / plate 模式的圖片 deck」

觸發語意包含：YAML image deck, NotebookLM-style image presentation, full-image PPTX, fixed visual grammar, controlled layouts, golden-sample style locking, batch image slides, baked slides, text-free plates。

## 預設工作流程

1. 確認簡報工作、受眾、中心 takeaway、頁數與語言。
2. 從 `assets/spec-template.yaml` 建立或整理 `spec.yaml`。
3. 為每頁指定 `semantic_structure` 與固定 `layout.id`。
4. 先跑 `validate_spec.py`。
5. 產生一張代表性內容頁作為黃金樣張，確認後寫入 `design_system.style_reference`。
6. 使用 Codex 內建 image generation 逐頁生成圖片，保存到專案資料夾。
7. 用 `verify_images.py` 檢查圖片存在與 16:9 比例。
8. 交給目前可用的簡報工作流打包 PPTX；交付時回報 PPTX 路徑、圖片資料夾、spec 路徑與模式。

## 踩坑紀錄

### 1. YAML 是設計契約，不是像素渲染程式

YAML 固定視覺語法、版型路由與逐頁內容；真正的投影片圖像仍由 Codex image generation 產生。不要用 Pillow / CSS / SVG 假圖取代圖片生成。

### 2. 通用圖片 deck 不等於 SOIL 教學 deck

`yaml-image-deck` 不要求 SOIL 六引擎。若使用者要求教學節奏、引起動機、維持注意與喚起行動，應改用 `soil-image-deck`。

### 3. Plate 模式必須先確認繁中粗圓字型

如果輸出 text-free plates 後要疊可編輯文字，打包前需確認本機有適合的繁中粗圓字型；不要默默使用尖角、機械感或不可讀的預設字型。

## 最終檢查清單

- [ ] `{{CODEX_HOME}}/skills/yaml-image-deck/SKILL.md` 存在。
- [ ] `assets/spec-template.yaml` 存在。
- [ ] references / scripts / agents 依本 skill package 實際內容存在。
- [ ] `validate_spec.py` 可通過內建 `assets/spec-template.yaml`。
- [ ] 搜尋 package 內沒有非 Codex 安裝路徑或非 Codex frontmatter 欄位。
- [ ] 開新 Codex 對話後，可用 `yaml-image-deck` 或 YAML 圖片簡報相關語句觸發。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節會安裝：`yaml-image-deck`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。

````bash
set -e

# ---- yaml-image-deck ----
rm -rf "{{CODEX_HOME}}/skills/yaml-image-deck"
mkdir -p "{{CODEX_HOME}}/skills/yaml-image-deck"
# yaml-image-deck/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/yaml-image-deck/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/yaml-image-deck/SKILL.md" <<'CODEX_LAZYPACK_YAML_IMAGE_DECK_SKILL_MD'
---
name: yaml-image-deck
description: Create consistent image-first slide decks from a structured YAML design system, layout registry, and per-slide content. Use when the user asks for a YAML image deck, NotebookLM-style image presentation, full-image PPTX, fixed visual grammar with controlled layouts, golden-sample style locking, or batch image slides across any subject. Supports baked slides and text-free plates with editable overlays.
---

# YAML Image Deck

Turn structured content into a consistent full-image presentation. Treat YAML as a design contract and prompt compiler input, not as pixel-perfect rendering code.

## Configuration Axes

- `output_mode`: `baked` or `plate`.
- `planning_mode`: `quick` or `yaml_spec`.
- `generation_strategy`: `sequential` or `subagents`.
- `style_lock`: `none` or `golden_sample`.

Default to `yaml_spec`, `sequential`, and `golden_sample`. Use `subagents` only when the user explicitly requests parallel generation and the active environment permits it.

## Hard Rules

- Use Codex built-in image generation by default. Do not require an API key unless the user explicitly selects an API/CLI workflow.
- Generate every slide visual with image generation before packaging. Local tools may crop, validate, montage, and package; they must not replace AI-generated slide art.
- Keep one core claim per slide and visible Chinese text short.
- Use a 16:9 target canvas and keep critical content inside the YAML safe area.
- Preserve each final image in the project; never leave project assets only under the built-in generated-images directory.
- Visually inspect every slide and the full montage before delivery.

## Rounded Typography Policy

The default visual language must use bold rounded Traditional Chinese lettering: thick strokes, generous counters, soft terminals, low corner sharpness, and no narrow mechanical forms.

For `baked` slides, repeat this typography direction in every image prompt and prohibit angular, condensed, high-contrast, or techno-stencil Chinese type.

For `plate` slides, use the first installed font from:

1. `jf open 粉圓 2.1`
2. `GenSenRounded TW`
3. `源柔ゴシック` / `GenJyuuGothic`

If none is installed, report the missing rounded Chinese font before final packaging. Do not silently substitute an angular default. Read `references/prompting.md` for the exact prompt tokens.

## Workflow

1. Define the communication job, audience, central takeaway, and slide count.
2. Create or normalize `spec.yaml` from `assets/spec-template.yaml`.
3. Assign each slide a semantic relationship and a fixed `layout.id`. Read `references/layout-library.md`.
4. Validate the spec:

   ```powershell
   python .\scripts\validate_spec.py --spec .\spec.yaml
   ```

5. Compile each prompt in this order: canvas and safe area, layout, page visual, exact text, global style, typography, reference image, negative constraints.
6. Generate one representative content slide first. Review it as the golden sample and save its path into `design_system.style_reference`.
7. Generate remaining slides one image call per slide. When explicit parallel generation is requested, read `references/subagent-batching.md` and give every worker the same YAML and golden sample.
8. Inspect exact text, layout, subject count, safe area, rounded typography, and style consistency. Regenerate only failed pages.
9. Run output verification:

   ```powershell
   python .\scripts\verify_images.py --spec .\spec.yaml --images-dir .\slides\images
   ```

10. Package through the active presentation workflow. In Codex, use the Presentations skill and Artifact Tool; embed one full-bleed image per slide, render the exported PPTX, inspect a montage, and run overflow checks.
11. Report the PPTX path, mode, source-image folder, spec path, and final prompt records.

## Output Modes

- `baked`: text is rendered inside each image. Use for fast demos, social sharing, and visual storytelling.
- `plate`: image generation produces a text-free designed plate with reserved zones; editable PowerPoint text is applied afterward. Use for revisions, dense Chinese, formulas, exact data, and long-lived decks.

Keep formulas, precise geometry, charts, and numeric evidence native/editable whenever correctness matters.

## Local Python Helpers

The bundled scripts are optional validation helpers. Install the packages in
`requirements.txt` before using them:

```bash
python -m pip install -r "{{CODEX_HOME}}/skills/yaml-image-deck/requirements.txt"
```

Required packages:

- `PyYAML` for `scripts/validate_spec.py`
- `Pillow` for `scripts/verify_images.py`

## References

- Read `references/schema.md` when creating or changing YAML fields.
- Read `references/layout-library.md` before routing slides.
- Read `references/prompting.md` before image generation.
- Read `references/subagent-batching.md` when the user requests parallel generation.
- Read `references/validation.md` before packaging and delivery.
CODEX_LAZYPACK_YAML_IMAGE_DECK_SKILL_MD

# yaml-image-deck/agents/openai.yaml
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/yaml-image-deck/agents/openai.yaml")"
cat > "{{CODEX_HOME}}/skills/yaml-image-deck/agents/openai.yaml" <<'CODEX_LAZYPACK_YAML_IMAGE_DECK_AGENTS_OPENAI_YAML'
interface:
  display_name: "YAML Image Deck"
  short_description: "以 YAML 規格鎖定風格與版型，批次生成一致的圖片式簡報"
  default_prompt: "Use $yaml-image-deck to turn this topic into a consistent YAML-driven image deck."
CODEX_LAZYPACK_YAML_IMAGE_DECK_AGENTS_OPENAI_YAML

# yaml-image-deck/assets/spec-template.yaml
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/yaml-image-deck/assets/spec-template.yaml")"
cat > "{{CODEX_HOME}}/skills/yaml-image-deck/assets/spec-template.yaml" <<'CODEX_LAZYPACK_YAML_IMAGE_DECK_ASSETS_SPEC_TEMPLATE_YAML'
schema_version: "yaml_image_deck_v1"

deck:
  title: "Example image deck"
  audience: "General audience"
  purpose: "Explain one idea clearly"
  takeaway: "Consistency comes from visual grammar"
  language: "zh-TW"
  output_mode: "baked"
  planning_mode: "yaml_spec"
  generation_strategy: "sequential"
  style_lock: "golden_sample"
  slide_count: 3

canvas:
  target_ratio: "16:9"
  safe_area_pct: {left: 6, right: 6, top: 10, bottom: 10}

design_system:
  visual_direction: "Warm editorial educational infographic"
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
    - "不要螢幕、投影幕或簡報 mockup"

layout_router:
  focus: "cover_hero"
  hierarchy: "relationship_map"
  synthesis: "summary_three"

slides:
  - page: 1
    role: "cover"
    core_point: "Introduce the central idea"
    semantic_structure: "focus"
    layout: {id: "cover_hero", variant: "left_title_right_visual"}
    visible_text: {title: "設計先有語法"}
    visual: "A visual system blueprint unfolding into several coordinated slides"
    output: "slides/images/page_01.png"
  - page: 2
    role: "relationship"
    core_point: "Show the system layers"
    semantic_structure: "hierarchy"
    layout: {id: "relationship_map", variant: "three_layer_stack"}
    visible_text: {title: "三層一起工作", labels: ["骨架", "版型", "內容"]}
    visual: "Three tactile layers connected into one finished slide"
    output: "slides/images/page_02.png"
  - page: 3
    role: "summary"
    core_point: "Close with a reusable principle"
    semantic_structure: "synthesis"
    layout: {id: "summary_three", variant: "center_statement"}
    visible_text: {title: "一致但不重複"}
    visual: "Different slide silhouettes connected by one shared visual grammar"
    output: "slides/images/page_03.png"

validation:
  regenerate_on:
    - "文字錯誤"
    - "字體不夠粗圓"
    - "版型或風格漂移"
CODEX_LAZYPACK_YAML_IMAGE_DECK_ASSETS_SPEC_TEMPLATE_YAML

# yaml-image-deck/references/layout-library.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/yaml-image-deck/references/layout-library.md")"
cat > "{{CODEX_HOME}}/skills/yaml-image-deck/references/layout-library.md" <<'CODEX_LAZYPACK_YAML_IMAGE_DECK_REFERENCES_LAYOUT_LIBRARY_MD'
# Controlled Layout Library

Route by information relationship, not by decoration.

| Relationship | Layout ID | Composition |
|---|---|---|
| focus | `cover_hero`, `question_focus` | One dominant claim and one focal visual |
| contrast | `misconception_dual`, `comparison_split` | Two balanced or weighted sides |
| sequence | `process_timeline` | Three to five ordered steps |
| classification | `classification_grid` | 2x2 or 2x3 groups |
| scenario | `case_scene_analysis` | Situation plus interpretation |
| hierarchy | `relationship_map` | Layered, tree, or center-and-branches |
| causal | `relationship_map` | Cause-to-effect chain |
| metric | `data_focus` | One number or one chart plus conclusion |
| synthesis | `summary_three` | Three takeaways and one core sentence |
| action | `action_next_step` | Clear next move or checklist |
| section | `section_divider` | Full-bleed transition with one line |

Rules:

- Do not repeat the same layout more than twice in a row.
- Use full-bleed compositions mainly for cover, section, and closing pages.
- Split content when a layout exceeds its item budget.
- Alternate left/right visual weight without changing the fixed visual grammar.
CODEX_LAZYPACK_YAML_IMAGE_DECK_REFERENCES_LAYOUT_LIBRARY_MD

# yaml-image-deck/references/prompting.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/yaml-image-deck/references/prompting.md")"
cat > "{{CODEX_HOME}}/skills/yaml-image-deck/references/prompting.md" <<'CODEX_LAZYPACK_YAML_IMAGE_DECK_REFERENCES_PROMPTING_MD'
# Prompt Compilation

Compile every slide prompt in this order:

1. Full 16:9 slide image and safe area.
2. Layout zones and reading order.
3. Visual subject, action, and relationship.
4. Exact visible text.
5. Shared style tokens and golden-sample reference.
6. Rounded typography policy.
7. Negative constraints.

Use this typography block for baked slides:

```text
Typography: bold rounded Traditional Chinese display lettering, thick even strokes,
soft terminals, generous counters, friendly proportions, low corner sharpness.
Avoid angular geometric Chinese type, condensed type, techno stencil forms,
sharp wedges, thin strokes, or high-contrast calligraphic forms.
Render the quoted text verbatim and add no other characters.
```

For `plate`, generate no text and reserve a calm text zone. Apply a verified installed rounded Chinese font during packaging.

Always state that the output is the slide itself, not a monitor, projector, laptop, or mockup.
CODEX_LAZYPACK_YAML_IMAGE_DECK_REFERENCES_PROMPTING_MD

# yaml-image-deck/references/schema.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/yaml-image-deck/references/schema.md")"
cat > "{{CODEX_HOME}}/skills/yaml-image-deck/references/schema.md" <<'CODEX_LAZYPACK_YAML_IMAGE_DECK_REFERENCES_SCHEMA_MD'
# YAML Schema

Use four layers:

1. `deck`: audience, purpose, mode, slide count, output.
2. `canvas` and `design_system`: fixed ratio, safe area, palette, visual direction, rounded typography, negative prompt.
3. `layout_router` and `layout_library`: controlled layout choices.
4. `slides`: page-specific teaching or communication data.

Required top-level keys:

```yaml
schema_version: "yaml_image_deck_v1"
deck: {}
canvas: {}
design_system: {}
layout_router: {}
slides: []
validation: {}
```

Required slide keys:

```yaml
- page: 1
  role: "cover"
  core_point: "One claim"
  semantic_structure: "focus"
  layout: {id: "cover_hero", variant: "left_title_right_visual"}
  visible_text: {title: "Short title"}
  visual: "Concrete image brief"
  output: "slides/images/page_01.png"
```

Use percentage zones for image prompting. Use PowerPoint coordinates only in a separate `overlay_blocks` section for `plate` mode.

Keep keys and enum values in English. Content may use the audience language.
CODEX_LAZYPACK_YAML_IMAGE_DECK_REFERENCES_SCHEMA_MD

# yaml-image-deck/references/subagent-batching.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/yaml-image-deck/references/subagent-batching.md")"
cat > "{{CODEX_HOME}}/skills/yaml-image-deck/references/subagent-batching.md" <<'CODEX_LAZYPACK_YAML_IMAGE_DECK_REFERENCES_SUBAGENT_BATCHING_MD'
# Subagent Batching

Use only when the user explicitly requests parallel generation and subagents are available.

1. Generate and approve one representative golden sample sequentially.
2. Save it in the project and write its path to `design_system.style_reference`.
3. Split non-overlapping page ranges across workers.
4. Give every worker the same `spec.yaml`, golden sample, prompt contract, output directory, and typography policy.
5. Require one image call per slide, local persistence, visual inspection, and a separate prompt log.
6. Do not let workers modify the same files.
7. The primary agent must inspect the final montage and regenerate drifted pages.

Parallel workers reduce waiting time; they do not increase image quota or guarantee style consistency.
CODEX_LAZYPACK_YAML_IMAGE_DECK_REFERENCES_SUBAGENT_BATCHING_MD

# yaml-image-deck/references/validation.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/yaml-image-deck/references/validation.md")"
cat > "{{CODEX_HOME}}/skills/yaml-image-deck/references/validation.md" <<'CODEX_LAZYPACK_YAML_IMAGE_DECK_REFERENCES_VALIDATION_MD'
# Validation

Reject or regenerate a page when any of these occur:

- Exact text is wrong, missing, duplicated, or supplemented.
- Typography is angular, narrow, mechanical, or inconsistent with the rounded policy.
- Layout differs materially from `layout.id`.
- Critical content crosses the safe area.
- Subject count or step count is wrong.
- Palette, material, lighting, or recurring motif drifts from the golden sample.
- The image depicts a screen or slide mockup instead of the slide itself.

Before delivery:

1. Validate YAML.
2. Verify file count, names, dimensions, and ratio.
3. Inspect every source image and a contact sheet.
4. Package the PPTX.
5. Render the exported PPTX again.
6. Inspect the rendered montage and run overflow checks.
CODEX_LAZYPACK_YAML_IMAGE_DECK_REFERENCES_VALIDATION_MD

# yaml-image-deck/requirements.txt
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/yaml-image-deck/requirements.txt")"
cat > "{{CODEX_HOME}}/skills/yaml-image-deck/requirements.txt" <<'CODEX_LAZYPACK_YAML_IMAGE_DECK_REQUIREMENTS_TXT'
PyYAML
Pillow
CODEX_LAZYPACK_YAML_IMAGE_DECK_REQUIREMENTS_TXT

# yaml-image-deck/scripts/validate_spec.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/yaml-image-deck/scripts/validate_spec.py")"
cat > "{{CODEX_HOME}}/skills/yaml-image-deck/scripts/validate_spec.py" <<'CODEX_LAZYPACK_YAML_IMAGE_DECK_SCRIPTS_VALIDATE_SPEC_PY'
#!/usr/bin/env python3
import argparse
from pathlib import Path
import sys

try:
    import yaml
except ImportError:
    raise SystemExit("PyYAML is required: python -m pip install PyYAML")


ALLOWED_LAYOUTS = {
    "cover_hero", "question_focus", "misconception_dual", "comparison_split",
    "process_timeline", "classification_grid", "case_scene_analysis",
    "relationship_map", "data_focus", "summary_three", "action_next_step",
    "section_divider",
}


def require(mapping, key, where, errors):
    if not isinstance(mapping, dict) or key not in mapping:
        errors.append(f"{where}: missing {key}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--spec", required=True)
    args = parser.parse_args()
    path = Path(args.spec)
    data = yaml.safe_load(path.read_text(encoding="utf-8"))
    errors = []

    for key in ("schema_version", "deck", "canvas", "design_system", "layout_router", "slides", "validation"):
        require(data, key, "root", errors)

    slides = data.get("slides", []) if isinstance(data, dict) else []
    if not isinstance(slides, list) or not slides:
        errors.append("root: slides must be a non-empty list")
        slides = []

    pages = []
    for index, slide in enumerate(slides, 1):
        where = f"slides[{index}]"
        for key in ("page", "role", "core_point", "semantic_structure", "layout", "visible_text", "visual", "output"):
            require(slide, key, where, errors)
        if isinstance(slide, dict):
            pages.append(slide.get("page"))
            layout_id = (slide.get("layout") or {}).get("id") if isinstance(slide.get("layout"), dict) else None
            if layout_id and layout_id not in ALLOWED_LAYOUTS:
                errors.append(f"{where}: unsupported layout id {layout_id}")

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

    if errors:
        print("INVALID")
        for error in errors:
            print(f"- {error}")
        return 1
    print(f"VALID: {path} ({len(slides)} slides)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
CODEX_LAZYPACK_YAML_IMAGE_DECK_SCRIPTS_VALIDATE_SPEC_PY
chmod +x "{{CODEX_HOME}}/skills/yaml-image-deck/scripts/validate_spec.py"

# yaml-image-deck/scripts/verify_images.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/yaml-image-deck/scripts/verify_images.py")"
cat > "{{CODEX_HOME}}/skills/yaml-image-deck/scripts/verify_images.py" <<'CODEX_LAZYPACK_YAML_IMAGE_DECK_SCRIPTS_VERIFY_IMAGES_PY'
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
    target_ratio = 16 / 9
    errors = []

    for slide in spec.get("slides", []):
        page = int(slide["page"])
        expected = Path(slide.get("output", f"page_{page:02d}.png")).name
        path = folder / expected
        if not path.exists():
            errors.append(f"missing {expected}")
            continue
        with Image.open(path) as image:
            ratio = image.width / image.height
            if abs(ratio - target_ratio) > args.ratio_tolerance:
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
CODEX_LAZYPACK_YAML_IMAGE_DECK_SCRIPTS_VERIFY_IMAGES_PY
chmod +x "{{CODEX_HOME}}/skills/yaml-image-deck/scripts/verify_images.py"

````

<!-- END EMBEDDED_SKILLS -->
