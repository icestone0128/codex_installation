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
