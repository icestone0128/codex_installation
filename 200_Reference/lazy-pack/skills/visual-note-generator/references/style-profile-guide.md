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
