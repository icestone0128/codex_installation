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
