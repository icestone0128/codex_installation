---
name: visual-note-generator
description: Turn a photographed or scanned hand-drawn note into an upright, source-faithful, 16:9 visual note in Arry's established style. Use when the user provides 手繪筆記、圖解筆記、白紙草圖、拍照筆記 or asks for Visual Note Generator, Arry 圖解風格, Q 版角色 replacement, exact Traditional Chinese text preservation, or a finished 2K visual-note image. This skill is only for hand-drawn-note-to-image creation, not article rewriting, transcripts, social posts, infographics from prose, or slide outlines.
---

# Visual Note Generator

Create one finished visual-note image from one hand-drawn source. Treat the source as the authority for wording, structure, direction, gesture, and visual logic.

Read `references/arry-visual-note-style.md` completely before analyzing or generating the image. Use the built-in image-generation/editing capability for the raster result.

## Local Defaults

- Arry assistant root: `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_symlink`
- Arry visual identity assets: `{{ASSISTANT_ROOT}}/assets/arry-visual-identity/`
- Codex visual-note references: `{{ASSISTANT_ROOT}}/assets/visual-note-references/`
- Obsidian portfolio and preferred finished-work reference source: `{{OBSIDIAN_VAULT}}/創作庫/Visual-Note-References/`

For this user, replace `{{ASSISTANT_ROOT}}` with the Arry assistant root above and `{{OBSIDIAN_VAULT}}` with `/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/secondbrain`.

## Required Workflow

### 0. Normalize Orientation

Inspect the source before reading text or planning composition.

- If it is sideways or upside down, create a non-destructive upright working copy first.
- Apply the required clockwise/counterclockwise rotation exactly; do not rely on EXIF display behavior.
- View the rotated working copy and verify that all writing reads naturally before continuing.
- Never overwrite the user's original photo.

### 1. Extract Source Invariants

Create an internal source specification before generating:

- exact Traditional Chinese/English text, punctuation, numbering, and labels;
- title, blocks, arrows, diagrams, icons, speech bubbles, and visual metaphor;
- relative positions and reading order;
- character count, placement, direction, visible angle, pose, gesture, clothing, and props.

Do not silently guess ambiguous handwriting. Ask the user only about uncertain strings, conflicting placement instructions, or unclear character identity. Once corrected, treat the user's wording as canonical.

### 2. Run the Character Checkpoint

If any person appears in the source, pause before generation and ask whether to:

1. keep the original drawn character;
2. replace it with Arry;
3. create another Q-version character, such as Jensen or a 主管.

For another character, use the user's supplied identity reference or the closest explicitly selected portfolio reference. Do not turn every person into Arry.

Character invariants:

- Preserve the source character's side, direction, body angle, gesture, visible face angle, backpack/prop, and relationship to nearby content.
- Allow only small adjustments needed to avoid covering text.
- Do not invent pointing, thumbs-up, open-hand, or other gestures absent from the source.
- Every Arry character must include a legible handwritten signature exactly `Arry` beside the character without covering content.

If no person appears, do not add one unless the user explicitly requests it.

### 3. Select References Deliberately

Choose two to four references from the portfolio based on structural similarity: matching diagram type, road/mountain metaphor, character angle, density, or title treatment.

Label each image role in the generation prompt:

- source image: sole authority for content and composition;
- portfolio images: style or one named visual motif only;
- character sheet/reference: identity only.

Explicitly prohibit copying unrelated text, objects, gestures, props, tunnels, flags, or layout from reference works.

### 4. Generate the First Version

Generate an upright 16:9 image using the style specification. Preserve all source text verbatim and keep the composition substantially unchanged. Small spacing adjustments are allowed only for readability and 16:9 fitting.

Target the highest native resolution available. The final deliverable must be at least 2560 × 1440 pixels. If the generation output is smaller, create a high-quality Lanczos-upscaled final at 2560 × 1440 without changing content or aspect ratio.

### 5. Validate Before Calling It Done

Inspect the output against the upright source, not from memory. Verify:

- orientation is correct;
- aspect ratio is exactly 16:9;
- dimensions are at least 2560 × 1440;
- every string, number, punctuation mark, and label matches the canonical text inventory;
- title and blocks retain their original relative placement and reading order;
- characters retain the source direction, pose, gesture, props, and visible face angle;
- every Arry instance has the `Arry` signature;
- background and fills use the pale portfolio palette;
- decorative elements are sparse and do not introduce new meaning.

If anything fails, make one targeted correction at a time and state that all other elements must remain unchanged. Re-check the entire image after every edit because image edits can regress previously correct text or layout.

### 6. Portfolio Handoff

Show the result and iterate until the user explicitly confirms it is the desired image.

Only after confirmation, ask whether to place it in `{{OBSIDIAN_VAULT}}/創作庫/Visual-Note-References/` as a future reference. If yes:

- confirm the filename;
- use PNG unless the user requests another format;
- do not overwrite an existing work without explicit approval;
- verify the saved file exists and meets the 16:9/2K requirement.

## Hard Boundaries

- Do not add concepts, examples, claims, characters, labels, or metaphors absent from the source or explicit user instructions.
- Do not summarize, shorten, rewrite, or modernize source wording.
- Do not force a standard infographic layout over the user's hand-drawn composition.
- Do not produce photorealism, 3D rendering, corporate-slide styling, neon technology styling, dark beige backgrounds, dense decoration, or vector-perfect geometry.
- Do not save into the portfolio before user confirmation.
