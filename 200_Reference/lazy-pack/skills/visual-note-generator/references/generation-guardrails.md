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
