# 22-Image-Generator-Skill-安裝

> 版本：2026-05-25 三 Agent 共用版
> 用途：建立 `image-generator` 全域 skill，讓使用者用自然語句在 Codex、Claude、AntiGravity 裡生圖、修圖、寫圖像提示與整理圖片資產。
> 成品：下載者可直接使用本文文末「內建 Skill 完整安裝內容」建立 `{{SYNC_ROOT}}/skills/image-generator/`；預設優先當前 Agent 的原生生圖通道，缺少時再使用已核准 API／CLI／手動 fallback。

## 來源與歷史紀錄

- 初次同步日期：2026-05-25。
- 來源文件：`08-用Image Gen Skill在Codex生圖.md`。
- 三 Agent 共用全域 skill：`{{SYNC_ROOT}}/skills/image-generator/SKILL.md`。
- 這版定位：以當前 Agent 的原生 image generation capability 作為一般生圖與修圖入口；若該 Agent 沒有原生通道，依序改走已核准 API／CLI／手動流程。

## 這版和來源文件的差異

| 項目 | 三 Agent 共用版調整 |
|---|---|
| 1 | 將來源工具路徑、命令與 frontmatter 假設轉成共用核心及三個 Agent adapter。 |
| 2 | 不預設要求 `OPENAI_API_KEY`；一般生圖、修圖與提示設計先走當前 Agent 的原生影像生成能力。 |
| 3 | 使用可攜式路徑 `{{SYNC_ROOT}}/skills/image-generator/`，不寫入個人電腦絕對路徑。 |
| 4 | 把新手教學整理成可由三 Agent 觸發的共用 workflow 與 reference 文件。 |

## 安裝方式

1. 打開本文文末「內建 Skill 完整安裝內容」。
2. 把整段安裝腳本複製到自己的環境執行。
3. 執行前先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。
4. 安裝後依 Item 16 確認三 Agent 原生入口，分別重載 skill 清單。

## 驗證

```bash
test -f "{{SYNC_ROOT}}/skills/image-generator/SKILL.md" && echo "image-generator SKILL.md ok"
test -f "{{SYNC_ROOT}}/skills/image-generator/references/imagegen-codex-workflow.md" && echo "image-generator reference ok"
```

合理結果是每一行都顯示 `ok`。

## 使用方式

安裝後可用下列語句觸發：

- 「使用 image-generator 幫我生成一張教學封面圖」
- 「幫我畫一張 16:9 的數學闖關遊戲背景圖」
- 「幫我把這張圖改成 YouTube 縮圖風格」
- 「幫我寫一段適合 Codex 生圖的提示詞」
- 「生成一個透明背景的課程徽章素材」

觸發語意包含：image-generator、generate image、生圖、修圖、圖片編輯、圖像提示、封面、插圖、角色、背景、透明背景素材、縮圖、漫畫分鏡、教學圖片。

## 預設工作流程

1. 判斷任務是生圖、修圖、提示詞撰寫，還是圖片資產整理。
2. 擷取用途、比例、主體、場景、風格、色彩、文字需求與限制。
3. 一般情況直接使用當前 Agent 的原生 image generation capability；缺少時才走已核准 fallback，不要無故要求使用者設定 API key。
4. 預設建議圖片不要含文字；重要文字後續用簡報、HTML、Canva 或其他編輯工具加入。
5. 若使用者指定專案或 Obsidian 位置，完成後才回報實際檔案路徑。

## 踩坑紀錄

### 1. 不要把 API key 當成新手必備

當前 Agent 的原生生圖和外部 API 是兩條路。一般生圖、修圖、教材視覺與圖片提示先用原生能力；只有缺少原生通道、大量批次、自動化或成本追蹤需求才考慮已核准 API／CLI。

### 2. 不要把來源工具專屬路徑帶進共用核心

正式版使用三 Agent 共用主版本 `{{SYNC_ROOT}}/skills/image-generator/`。來源工具命令或 metadata 改寫為共用規則與各 Agent adapter。

### 3. 圖中文字通常要保守

若圖片需要標題、按鈕字或精準中文，優先生成「無文字」視覺，再用簡報、HTML、Canva 或其他工具加文字。

## 最終檢查清單

- [ ] `{{SYNC_ROOT}}/skills/image-generator/SKILL.md` 存在。
- [ ] `{{SYNC_ROOT}}/skills/image-generator/references/imagegen-codex-workflow.md` 存在。
- [ ] package 共用核心沒有來源工具專屬路徑、單一 Agent frontmatter 或無條件 API key 要求。
- [ ] Codex、Claude、AntiGravity 重載後，都可用 `image-generator`、生圖、修圖或圖片提示相關語句觸發。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊。這個序號項目會安裝：`image-generator`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請依 README 設定 `{{SYNC_ROOT}}`；package 只寫入共用主版本，Item 16 與 chezmoi 會建立 Codex、Claude、AntiGravity 的原生入口。

````bash
set -e

# ---- image-generator ----
mkdir -p "{{SYNC_ROOT}}/skills/image-generator"
# image-generator/SKILL.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/image-generator/SKILL.md")"
cat > "{{SYNC_ROOT}}/skills/image-generator/SKILL.md" <<'AGENT_LAZYPACK_IMAGE_GENERATOR_SKILL_MD_0E95F5A366'
---
name: image-generator
description: Use when the user asks to generate, edit, restyle, or prepare images in Codex, Claude, or AntiGravity, including 生圖, 修圖, 圖像提示, 教學圖片, 封面, 插圖, 角色, 背景, transparent-background assets, thumbnails, comic panels, or visual assets for slides, websites, games, and Obsidian notes. Use the active agent's native image tool when available, with a shared approved fallback route.
metadata:
  short-description: Generate and edit images across three agents
---

# Image Generator

Use this skill as the shared image-generation workflow for Codex, Claude, and
AntiGravity. It is a lightweight front door to the active agent's native image
capability or an approved shared fallback, not an automatic API-key setup.

## Core Rule

- For ordinary image creation, style exploration, or image editing, use the
  active agent's native image generation capability when it is available.
- Do not ask the user to set `OPENAI_API_KEY` for normal image work.
- Do not create API scripts, billing setup, batch-generation workflows, or CLI
  routes unless the user explicitly asks for API automation.
- Keep the shared package under `{{SYNC_ROOT}}/skills/image-generator`; native
  metadata or commands belong only in the corresponding Agent adapter.

## Agent Execution Notes

- Shared steps: use the same visual brief, source images, safety rules, output
  format, placement path, and acceptance criteria.
- Codex adapter: use the native image generation/editing tool with `imagen 2`
  model configuration when applicable.
- Claude adapter: use Claude's native image-capable tool when exposed; otherwise
  use the approved shared image CLI/API or browser/manual route.
- AntiGravity adapter: use AntiGravity's native image tool (`nanobanana 2` model
  configuration when applicable).
- Fallback: ask before enabling a paid/API route; if no generation route is
  authorized, deliver the final prompt and exact placement/verification steps.
- Verification: confirm subject fidelity, dimensions/aspect ratio, text policy,
  requested edits, file readability, and final placement identically.

## When To Use

Use this skill when the user asks for:

- new images, illustrations, covers, thumbnails, backgrounds, teaching visuals,
  game assets, badges, icons, comics, storyboards, or social visuals;
- edits to an attached or referenced image, such as restyling, changing the
  background, adjusting composition, creating variants, or making transparent
  assets;
- image prompts for later generation;
- guidance on where generated images should be saved or copied inside a project,
  Obsidian vault, slide deck, website, or asset folder.

If the request is really a deterministic diagram, chart, UI mockup, PowerPoint
layout, SVG icon, or code-native canvas element, decide whether a code/vector
tool is more appropriate before using image generation.

## Workflow

1. Identify the output intent: image generation, image editing, prompt writing,
   or asset placement.
2. Extract the minimum useful prompt fields:
   - purpose;
   - aspect ratio or target size;
   - subject and scene;
   - style;
   - colors;
   - text policy;
   - constraints and exclusions.
3. If enough information is present, generate or edit directly. Ask a short
   clarification only when the missing detail changes the output materially.
4. Prefer "no text" for images unless the user explicitly needs text in the
   image. Important text is usually better added later in slides, HTML, Canva,
   or another editor.
5. After generation, report the useful result and any local path or project
   placement action that was actually completed.

## Prompt Template

```text
Generate an image:
Purpose:
Aspect ratio:
Subject:
Scene:
Style:
Colors:
Text:
Constraints:
```

## Editing Images

When the user provides or references an image:

- preserve the user-specified subject, identity, composition, or object if they
  ask to keep it;
- state the intended edit in the prompt rather than rewriting the whole image
  from scratch;
- for transparent-background assets, request a clean isolated subject and avoid
  complex semi-transparent edges when possible;
- if the user needs project assets, copy or move the final file only when a
  concrete destination is requested and available.

## Safety And Secrets

- Never ask the user to paste API keys into chat, `AGENTS.md`, Obsidian notes,
  or repo files.
- If an API route is explicitly requested, keep secrets in local environment
  variables or ignored local files only.
- For public LazyPack documentation, keep paths portable with placeholders such
  as `{{CODEX_HOME}}`, `{{PROJECT_ROOT}}`, and `{{OBSIDIAN_VAULT}}`.

## Reference

Read `references/imagegen-codex-workflow.md` for examples, native adapter guidance,
and common pitfalls.
AGENT_LAZYPACK_IMAGE_GENERATOR_SKILL_MD_0E95F5A366

# image-generator/references/imagegen-codex-workflow.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/image-generator/references/imagegen-codex-workflow.md")"
cat > "{{SYNC_ROOT}}/skills/image-generator/references/imagegen-codex-workflow.md" <<'AGENT_LAZYPACK_IMAGE_GENERATOR_REFERENCES_IMAGEGEN_CODEX_WORKFLOW_MD_502FEBA26E'
# Image Generator Reference: Three-Agent Image Workflow

This reference adapts the user-provided guide
`08-用Image Gen Skill在Codex生圖.md` into a workflow shared by Codex, Claude, and AntiGravity.

## Positioning

There are two possible image routes:

| Route | Best for | API key |
|---|---|---|
| Active Agent native image generation | ordinary image creation, teaching visuals, covers, thumbnails, image edits, simple assets | normally not required |
| Approved shared CLI/API/browser route | native tool unavailable, large batches, programmatic pipelines, or explicit cost tracking | depends on selected route and requires consent |

Default to the active Agent's native route. Mention a paid or key-based API only
when the user explicitly approves automation, large-scale generation, or API control.

## Beginner Requests

Useful prompt patterns:

```text
Generate a 16:9 teaching slide cover about AI helping teachers prepare lessons.
Style: bright modern illustration, warm classroom, clean composition.
Text: no text.
Constraints: no watermark, no futuristic UI, no clutter.
```

```text
Generate a transparent-background badge for a math game.
Subject: equation-solving champion badge.
Style: friendly classroom game asset.
Text: no text.
Constraints: clean silhouette, readable at small size.
```

```text
Edit the attached image into a YouTube thumbnail style.
Preserve the main person.
Change the background to a bright classroom.
Text: no text.
```

## Prompt Fields

Use these fields when the user needs help writing a prompt:

- Purpose: where the image will be used.
- Aspect ratio: 16:9, 1:1, 4:5, 9:16, transparent asset, etc.
- Subject: main person, object, scene, or concept.
- Scene: environment and composition.
- Style: photo, watercolor, modern anime illustration, flat editorial, etc.
- Colors: key palette or mood.
- Text: no text, or exact requested text if unavoidable.
- Constraints: no watermark, no logo, no clutter, no sci-fi UI, no fake text.

## Common Pitfalls

| Problem | Cause | Practical fix |
|---|---|---|
| User is unsure which quota is used | built-in image generation and API billing are separate systems | Use built-in image generation by default; API is only for explicit automation |
| Image contains poor text | image models may render text inaccurately | Generate with no text, then add text later in slides or design tools |
| Transparent edges look messy | hair, smoke, glass, or semi-transparent objects are hard | Use a clean isolated subject and simple edges |
| Asset is hard to reuse | image stays only in generated output location | Copy it into the project or Obsidian attachment folder when requested |
| Prompt is too detailed without purpose | image loses focus | Start from purpose and composition, then add style and constraints |

## Project Placement

When the user wants the generated image saved into a standard four-box project,
prefer a task package under `100_Todo/projects/<image-task>/assets/images/`.
Use `200_Reference/docs/images/` only for deployable/static site assets and
`200_Reference/templates/images/` only for reusable templates. Do not create
project-root `assets/`, `public/`, or `src/` folders just for generated images.

- `{{PROJECT_ROOT}}/100_Todo/projects/<image-task>/assets/images/`
- `{{PROJECT_ROOT}}/200_Reference/docs/images/`
- `{{PROJECT_ROOT}}/200_Reference/templates/images/`
- `{{OBSIDIAN_VAULT}}/<note-folder>/attachments/`

Report the final path only after the file has actually been copied or created.

## Agent Execution Compatibility

- Keep the skill source in `{{SYNC_ROOT}}/skills/image-generator/`; each Agent
  reads it through its native skills entrypoint.
- Use the Codex native image tool (`imagen 2`), Claude native image tool, or
  AntiGravity native image tool (`nanobanana 2`) when available; use an
  approved shared CLI/API/browser route when it is not.
- Keep native metadata and commands in the corresponding adapter without forking
  the prompt, output, safety, or verification contract.
- Do not require API keys for normal image work.
AGENT_LAZYPACK_IMAGE_GENERATOR_REFERENCES_IMAGEGEN_CODEX_WORKFLOW_MD_502FEBA26E

test -f "{{SYNC_ROOT}}/skills/image-generator/SKILL.md" && echo "image-generator installed for Codex, Claude, and AntiGravity"
````

安裝完成後，請開新 Agent 對話或重啟對應 App，再測試 skill 是否能被讀取。

<!-- END EMBEDDED_SKILLS -->
