# 20-SOIL-Image-Deck-Skill-安裝

> 版本：2026-05-25 Codex App 版
> 用途：建立 SOIL 風格 image-first 簡報，每頁以 AI 生成全頁圖像為核心，再打包成 .pptx，支援 baked 與 plate 模式。
> 成品：下載者可直接使用本文文末「內建 Skill 完整安裝內容」建立 `{{CODEX_HOME}}/skills/soil-image-deck/`，不需要取得原作者本機資料夾。

## 來源與歷史紀錄

- 初次同步日期：2026-05-25。
- 原始來源包：使用者提供的 SOIL Deck skills package；本版已整理為 `soil-image-deck`。
- Codex 全域 skill：`{{CODEX_HOME}}/skills/soil-image-deck/SKILL.md`。
- Obsidian 全域索引已記錄用途：SOIL 全圖像 PPTX；以 Codex 影像生成建立每頁全版圖，再用打包腳本輸出 baked 或可疊 editable text 的 plate 模式。

## 這版和來源工具文件的差異

| 項目 | Codex 版調整 |
|---|---|
| 1 | 將 Windows-only 範例改為跨平台 `python` / `python3` 指令，避免限定單一終端環境。 |
| 2 | 保留 `scripts/pack_pptx.py`、`references/spec-format.md` 與 `references/image-prompts.md`。 |
| 3 | 正式安裝路徑統一為 `{{CODEX_HOME}}/skills/soil-image-deck/`。 |

## 安裝方式

1. 打開本文文末「內建 Skill 完整安裝內容」。
2. 把整段安裝腳本複製到自己的環境執行。
3. 執行前先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。
4. 安裝後開新 Codex 對話或重啟 Codex App，讓新的全域 skill metadata 被重新載入。

## 驗證

```bash
test -f "{{CODEX_HOME}}/skills/soil-image-deck/SKILL.md" && echo "soil-image-deck SKILL.md ok"
test -d "{{CODEX_HOME}}/skills/soil-image-deck/references" && echo "references ok"
test -d "{{CODEX_HOME}}/skills/soil-image-deck/scripts" && echo "scripts ok"
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
2. 先決定 SOIL 節奏：引起動機 -> 維持注意 -> 喚起行動。
3. 依 skill 內 `SKILL.md` 與 references 規劃頁面、視覺、互動或 PowerPoint 結構。
4. 若需要 bitmap 視覺，使用 Codex 內建 image generation 生成，不用本機假圖替代。
5. 交付前檢查檔案可開啟、文字可讀、版面不溢出、引用資源可攜。

## 踩坑紀錄

### 1. 不要把來源工具專用路徑帶進正式安裝

正式版只使用 Codex 全域 skill 路徑 `{{CODEX_HOME}}/skills/soil-image-deck/`。不要建立非 Codex skill 位置、來源工具專用命令或來源作者的本機路徑。

### 2. AI 圖像規則不能用本機假圖替代

這三組 SOIL skills 的品質前提是視覺素材由 Codex 影像生成能力產生。只有精準幾何、數學圖或明確 prototype 需求可使用 deterministic SVG / Python 圖形。

### 3. 可攜式 package 要包含 references / scripts / examples

只複製 `SKILL.md` 不夠。本文內嵌完整 package，包含來源 package 中必要的 references、scripts 與 examples。

## 最終檢查清單

- [ ] `{{CODEX_HOME}}/skills/soil-image-deck/SKILL.md` 存在。
- [ ] references / scripts / examples 依本 skill package 實際內容存在。
- [ ] 搜尋 package 內沒有非 Codex 安裝路徑或非 Codex frontmatter 欄位。
- [ ] 開新 Codex 對話後，可用 `soil-image-deck` 或 SOIL 簡報相關語句觸發。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節會安裝：`soil-image-deck`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。

```bash
set -e

# ---- soil-image-deck ----
mkdir -p "{{CODEX_HOME}}/skills/soil-image-deck"
# soil-image-deck/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-image-deck/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/soil-image-deck/SKILL.md" <<'CODEX_LAZYPACK_SOIL_IMAGE_DECK_SKILL_MD'
---
name: soil-image-deck
description: >
  Create a SOIL-style image-first presentation where each slide is a full-page
  bitmap image, then package the images into a .pptx. Use when the user asks for
  a pure image deck, all-image slides, AI-generated poster-like slides, quick
  visual-impact teaching slides, livestream opening slides, social sharing
  slides, or a deck where later text editing is not important. Supports baked
  mode and plate mode with editable PowerPoint text overlays.
metadata:
  short-description: SOIL full-image PPTX deck
---

# SOIL Image Deck

Use this skill for visual-impact decks where every slide is driven by one
full-page image.

## Output Modes

- `baked`: each generated image already contains the slide text; the PPTX is one
  full-bleed image per slide.
- `plate`: generated images contain no text; the PPTX overlays editable
  PowerPoint text boxes from `spec.yaml`.

Default to `baked` for speed and social/livestream materials. Use `plate` when
the user needs editable text or expects later revisions.

## Hard Image Rule

Every slide image in this skill must be produced with Codex's built-in image
generation capability first. Do not create the slide images through local
Pillow/CSS/SVG/shape rendering, procedural graphics, or placeholder panels unless
the user explicitly asks for a non-AI prototype. The value of this skill is that
the slide itself is an AI-generated visual artifact.

## Workflow

1. Determine whether the user has material, only a topic, or an existing YAML
   spec. If enough information is already present, proceed directly.
2. Produce a page plan: page number, role, core point, minimal on-image text,
   image brief, and layout hint.
3. Define an `image_policy` with style tokens, negative prompt, size, quality,
   palette, and any pages upgraded to higher quality.
4. Generate images with the built-in image generation skill and preserve those
   generated outputs for packaging into `slides/images/`.
5. Visually inspect generated images before packaging. Reject images with
   unreadable text, wrong layout, unwanted symbols, or style drift.
6. Package the deck using `scripts/pack_pptx.py`.
7. Report the final `.pptx` absolute path and mode used.

## Design Rules

- Keep each slide to one core point.
- For baked mode, keep Chinese on-image text under about 20 characters per slide
  when possible.
- Avoid asking image generation to render dense paragraphs or data tables.
- Use SOIL rhythm: 引起動機 -> 維持注意 -> 喚起行動.
- Use 1-2 accent colors and consistent visual style.
- Cover and action pages may use higher image quality.

## Packaging

From the project folder, run the bundled packaging script with your local Python:

```bash
python "{{CODEX_HOME}}/skills/soil-image-deck/scripts/pack_pptx.py" \
  --images-dir "slides/images" \
  --output "slides/output.pptx" \
  --mode baked
```

For editable overlay mode:

```bash
python "{{CODEX_HOME}}/skills/soil-image-deck/scripts/pack_pptx.py" \
  --images-dir "slides/images" \
  --output "slides/output-editable.pptx" \
  --mode plate \
  --spec "slides/spec.yaml"
```

## When To Read References

- Read `references/spec-format.md` when using `plate` mode.
- Read `references/image-prompts.md` before generating images.

## Dependencies

- Python packages: `python-pptx`, `Pillow`, `PyYAML`.
- Image generation must use Codex's built-in image generation capability for
  every slide image. If the current environment cannot save those generated
  images to local files, stop and explain the file-persistence limitation instead
  of substituting local rendered graphics.
CODEX_LAZYPACK_SOIL_IMAGE_DECK_SKILL_MD

# soil-image-deck/references/image-prompts.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-image-deck/references/image-prompts.md")"
cat > "{{CODEX_HOME}}/skills/soil-image-deck/references/image-prompts.md" <<'CODEX_LAZYPACK_SOIL_IMAGE_DECK_REFERENCES_IMAGE-PROMPTS_MD'
# Image Prompt Guidance

All image assets for `soil-image-deck` must come from Codex built-in image
generation. Do not replace any image-generation step with local rendering.

## Prompt Parts

Build each image prompt from:

1. Layout hint.
2. Image content brief.
3. On-image text, only for `baked` mode.
4. Shared style tokens from `image_policy`.
5. Negative prompt.

Example:

```text
左文右圖。圖像內容：Q版數學老師站在發光黑板前，黑板有幾何圖形與簡潔符號。
圖上文字：標題「看見比例」。
風格：扁平向量插畫，16:9 橫版，深夜藍背景，亮青藍主色，金黃點綴。
避免：逼真照片、雜亂背景、亂碼、英文字。
```

## Plate Mode

For `plate`, the image must be text-free:

```text
整張圖不要任何文字、不要英文字母、不要符號、不要 logo。
左側 40% 留深色乾淨空白區供 PowerPoint 文字疊加。
圖像內容：...
風格：...
```

## Suggested Sizes

- Full slide: `1536x1024`.
- Square card or icon image: `1024x1024`.
- Vertical side panel: `1024x1536`.

## Quality

- Default low quality is enough for drafts and most teaching slides.
- Upgrade cover, section divider, and closing/action slides when they are the
  visual anchor of the presentation.
CODEX_LAZYPACK_SOIL_IMAGE_DECK_REFERENCES_IMAGE-PROMPTS_MD

# soil-image-deck/references/spec-format.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/soil-image-deck/references/spec-format.md")"
cat > "{{CODEX_HOME}}/skills/soil-image-deck/references/spec-format.md" <<'CODEX_LAZYPACK_SOIL_IMAGE_DECK_REFERENCES_SPEC-FORMAT_MD'
# Plate Mode Spec Format

Use `spec.yaml` when images are clean backgrounds and PowerPoint text should
remain editable.

```yaml
style:
  palette:
    bg: "#0D1B2A"
    primary: "#00C6FF"
    highlight: "#FFD700"
    text: "#FFFFFF"
    muted: "#A5B4CB"
    card: "#1E3A5F"
  font: "Microsoft JhengHei"
  title_font: "Microsoft JhengHei"
  body_font: "Microsoft JhengHei"

pages:
  - page: 1
    image: page_01
    img_x: 0
    img_y: 0
    img_w: 13.333
    img_h: 7.5
    bg: bg
    blocks:
      - type: badge
        text: "EP15"
        x: 0.7
        y: 0.7
        w: 2.2
        h: 0.5
        bg: primary
        color: bg
        size: 14
      - type: title
        text: "把生圖\n放進簡報"
        x: 0.7
        y: 1.6
        w: 6.5
        h: 2.5
        size: 48
        color: text
        bold: true
      - type: subtitle
        text: "gpt-image × SOIL 工作流"
        x: 0.7
        y: 4.75
        w: 6.5
        h: 1
        size: 22
        color: primary
```

## Block Types

- `title`, `subtitle`, `body`, `muted`, `highlight`: editable text.
- `badge`: rounded label with background color.
- `card`: rounded visual area without text.
- `bar`: thin separator bar.
- `progress`: progress bar with `current` and `total`.

Coordinates use PowerPoint inches on a 16:9 canvas: `13.333 x 7.5`.
CODEX_LAZYPACK_SOIL_IMAGE_DECK_REFERENCES_SPEC-FORMAT_MD

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
    default_font = style_cfg.get("font", "Microsoft JhengHei")
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
```

<!-- END EMBEDDED_SKILLS -->
