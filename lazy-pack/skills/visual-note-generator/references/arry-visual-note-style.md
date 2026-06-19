# Arry Visual Note Style and Generation Guardrails

Use this as the canonical style reference for transforming a hand-drawn note. The source note controls content and layout; this reference controls rendering style, palette, character consistency, and validation.

## Style Architecture

### Canvas and Atmosphere

- Use a 16:9 horizontal canvas, minimum 2560 × 1440 final pixels.
- Keep 75–85% of the canvas visually white or near-white.
- Use a very pale warm-white/ivory paper tone, not tan, sepia, gray, or a dark beige wash.
- Keep generous breathing room between blocks. The page should feel like a clean sketchbook spread, not a filled infographic template.

### Line Language

- Draw with clean black hand-marker or pen lines.
- Retain slight human irregularity in curves and boxes; avoid sterile vector-perfect geometry.
- Use medium-weight outlines for main blocks and lighter hatch/marker texture for fills.
- Use simple black arrows and braces. Keep arrow motion hand-drawn and readable.

### Typography

- Use legible Traditional Chinese handwritten marker lettering.
- Preserve every source string verbatim, including punctuation, numbering, Latin letters, and symbols.
- Use black for body text. Use dark blue or orange-red selectively for title words and major emphasis.
- Keep headings larger than body text and leave enough line spacing for mobile/social viewing.
- Do not replace difficult wording with synonyms or shorter phrases.

### Palette

Use low-saturation, translucent pastel fills with stronger outlines:

- orange-red: title banners, key emphasis, flags, underline accents;
- blue: primary frameworks, goals, boxes, selected numbering;
- purple: secondary concepts, overlap areas, people/group diagrams;
- green: actions, growth, paths, foliage, positive progression;
- yellow-orange: highlights, stars, small attention marks;
- soft pink: contrast blocks, emotion or caution accents.

Keep fills pale enough that the background remains dominant. Avoid heavy gradients, dark shadows, muddy beige, neon colors, and large saturated panels.

### Composition

- Preserve the source layout, hierarchy, directional flow, and visual metaphor.
- Keep title, section numbering, diagrams, and character placement in their original regions.
- Allow small nudges, scaling, or spacing changes only to fit 16:9 and prevent overlap.
- Common Arry-work vocabulary includes ribbon/arrow title banners, rounded rectangles, speech/thought bubbles, Venn circles, simple grids, mountains/roads, flags, keys, stars, lightbulbs, tape, and hand-drawn braces. Use only shapes already present in the source or minimal accents that do not add meaning.
- Decorative marks should be sparse: a few stars, spark lines, clouds, tape strokes, or underlines. Never decorate every empty area.

### Character Rendering

All characters use a professional educational Q-version style: large expressive eyes, clean proportions, warm skin tone, soft blush, clear silhouette, and the same hand-drawn outline language as the note.

For Arry:

- short black hair with soft layered bangs;
- warm dark-brown eyes;
- round friendly face;
- white inner shirt;
- light beige-orange striped overshirt;
- khaki pants and white sneakers when full body is visible;
- calm, curious, professional educator mood;
- handwritten `Arry` signature beside every Arry appearance.

Do not default to a front-facing smiling presenter. Match the source pose exactly: front, side, three-quarter, rear, seated, walking, backpacked, thinking, or any other visible action. Show only the amount of face visible in the source. Preserve the original hand and arm gesture.

For Jensen, 主管, or other Q-version characters:

- use a supplied or explicitly selected identity reference;
- preserve recognizable hair, glasses, clothing, role cues, and source pose;
- keep their visual treatment consistent with the portfolio;
- do not label or sign them as Arry.

## Reference Selection Rules

Select portfolio references by the needed property, not by general attractiveness:

- mountain road, summit, travel direction: `3-3 OKR：做最重要的事_Arry.png`;
- pale airy palette and source-faithful diagrams: `4-1 心理安全感_Arry.png`;
- Arry thinking/side profile and structured note boxes: `1-1 做你的生命設計師_Arry.png`;
- multi-character and role-based scenes: `解碼主管思維.jpg`;
- mixed diagrams with restrained decoration: `5-4 1枝筆＋1張紙說服各種人_Arry.png`;
- rear/three-quarter Arry with backpack and road: `6-3 精實學習法_Arry.png`.

When a reference is selected for one property, forbid copying its unrelated text, objects, or layout.

## Prompt Skeleton

Structure generation/edit prompts with these sections:

1. `REFERENCE ROLES`: identify source, style references, and character references.
2. `EXACT TEXT`: list canonical strings verbatim.
3. `COMPOSITION INVARIANTS`: list block locations, reading order, arrows, diagrams, and character pose/direction.
4. `STYLE`: apply the palette, line language, typography, and restrained decoration above.
5. `CHARACTER`: state the confirmed identity and signature rule.
6. `OUTPUT`: 16:9, highest native quality, final minimum 2560 × 1440.
7. `NEGATIVE CONSTRAINTS`: no new content, no layout redesign, no gesture invention, no copied reference text, no dark background, no photorealism, no 3D, no watermark.

## Failure Modes Learned from Real Runs

### Orientation Was Interpreted Incorrectly

Photos may display differently from their raw pixel orientation. Create and inspect an upright working copy before transcription or composition analysis. Never infer the intended final left/right positions from an unrotated preview.

### Handwriting Was Misread

Visually similar words or abbreviations can be misread. Build a canonical text inventory and ask about uncertain strings before generation. User corrections always override OCR/model guesses.

### Character Placement or Gesture Drifted

Reference images can pull a character to another side or invent a presenter gesture. Treat source side, direction, visible face angle, backpack/props, and gesture as hard invariants. State them explicitly in the prompt.

### Arry Signature Was Missing

The signature is mandatory, not optional decoration. Validate the exact Latin text `Arry` after every generation or edit.

### Background Became Too Dark

Specify near-white warm ivory, pale translucent fills, minimal beige cast, and no heavy shading. Use existing portfolio images as palette references.

### Structural References Contaminated the Image

A mountain-road reference may introduce tunnels, flags, shrubs, text, or other unrelated objects. Assign one explicit reference role and prohibit every unrelated copied element.

### Targeted Edits Regressed Correct Areas

Image editing can change text or layout outside the requested region. After each targeted correction, re-check all source strings, layout invariants, character rules, signature, palette, ratio, and dimensions.

### Generated Output Was Below 2K

Check actual pixel dimensions; do not assume “high resolution” means 2K. If either dimension is below 2560 × 1440, create a 2560 × 1440 Lanczos-upscaled final and verify the result.
