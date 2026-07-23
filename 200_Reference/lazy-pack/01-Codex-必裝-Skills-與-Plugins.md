# 01-Codex-必裝-Skills-與-Plugins

> 2026-07-20 更新：本文件列出三 Agent 共用的 PDF／Playwright 基礎 skill，並以 Codex App 為第一個 plugin／connector adapter 範例。Claude 與 AntiGravity 要依各自原生 connector／MCP 能力做同等驗證；共用 skills 不重複安裝。


## 目標

確認 Codex、Claude、AntiGravity 的基礎工作能力：GitHub、Gmail、Google Calendar、Google Drive、PDF、文件、試算表、簡報、瀏覽器、Playwright CLI、skill 建立與安裝。

## 前置條件

- 三 Agent 中至少一個現在可用；Item 16 會預先準備 Codex、Claude、AntiGravity 的全部入口。
- 每個已安裝 Agent 各自完成帳號登入，不同步 auth／token／cookie。
- 若要使用 Google 類工具，準備自己的 Google 帳號。
- 若要使用 GitHub，準備自己的 GitHub 帳號。

## 三 Agent 共用必裝 Skills

下載者必須先把這兩個 skills 安裝到 `{{SYNC_ROOT}}/skills`，再由 Item 16 提供三 Agent 原生入口：

| Skill | 用途 | 安裝後應看到 |
| --- | --- | --- |
| `pdf` | PDF 讀取、摘要、版面檢查、PDF 產生與渲染驗證 | `{{SYNC_ROOT}}/skills/pdf/SKILL.md` |
| `playwright` | 透過 Playwright CLI 操作真實瀏覽器、截圖、表單互動與 UI flow debug | `{{SYNC_ROOT}}/skills/playwright/SKILL.md` |

安裝完成後，分別對 Codex、Claude、AntiGravity 開新對話或重載 skill 清單。

驗證：

```bash
test -f "{{SYNC_ROOT}}/skills/pdf/SKILL.md" && echo "pdf skill ok"
test -f "{{SYNC_ROOT}}/skills/playwright/SKILL.md" && echo "playwright skill ok"
```

注意：這裡的 `playwright` 是三 Agent 共用 skill／CLI 工作流，不是外部 MCP server 設定。

## 建議啟用的 Plugins / Connectors

依需求啟用，不需要一次全部打開：

- GitHub：repo、PR、issue、CI。
- Gmail：信件搜尋、摘要、草稿。
- Google Calendar：行程、會議準備、空檔查詢。
- Google Drive：Drive、Docs、Sheets、Slides。
- Notion：workspace 搜尋、頁面讀取、database 讀取與明確確認後的頁面建立/更新。此項歸在 01 必裝 plugins/connectors 檢查，不需要建立自訂全域 skill。
- Browser：本機或遠端網頁測試、互動操作、截圖與基本前端檢查。優先當前 Agent 的原生 browser／computer-use 通道；需要 CLI 型真實瀏覽器自動化時，使用上方共用 `playwright` skill。
- PDF：讀取、摘要、檢查與引用 PDF 內容。此項搭配上方必裝的 `pdf` skill 使用。
- Documents：Word / docx 文件處理。
- Spreadsheets：xlsx / csv / Sheets 類任務。
- Presentations：PowerPoint / Slides 類任務。

## 建議確認的系統 Skills

Codex 通常已內建：

- `skill-creator`
- `skill-installer`
- `plugin-creator`
- `openai-docs`
- `imagegen`

這些在 `.system` 底下，由 Codex 管理。不要手動覆蓋。

## Agent Execution Notes

- Codex：使用 Codex App plugins／connectors／`.system` skills；本文的 sandbox TOML 只是 Codex adapter。
- Claude：依當前版本的 Connectors／MCP／原生工具清單完成同等 read-only 驗證；缺少時使用共用 CLI skills。
- AntiGravity：依當前版本的 MCP Store／原生 browser／工具清單完成同等 read-only 驗證；缺少時使用共用 CLI skills。
- 驗證結果要記錄「Agent、通道、登入／權限狀態、實測動作、fallback」，不用某 Agent 沒有原生 plugin 作為排除理由。

## 建議建立的自訂全域 Skills

自訂全域 skills 的共用主版本放在：

```text
{{SYNC_ROOT}}/skills
```

本懶人包的自訂 skill 內容已內嵌在對應序號文件中。01 處理三 Agent 共用基礎 skills，並記錄各 Agent 的 plugins／connectors／內建能力 adapter；自訂 skill 請依各序號文末腳本安裝。

```bash
mkdir -p "{{SYNC_ROOT}}/skills"

for skill in codex-skill-creator project-init-sync startup-sync shutdown-sync tool-integration-workflow brainstorm; do
  # 請使用本文文末「內建 Skill 完整安裝內容」；不需要額外複製舊版獨立 skills 子目錄。
done

find "{{SYNC_ROOT}}/skills" -maxdepth 2 -name SKILL.md -print
```

再依需求安裝個人、內容製作與工具類 skill：

| Skill | 用途 | 安裝時機 |
| --- | --- | --- |
| `arry-assistant` 或自訂助手名稱 | 個人助手資料層 | 完成 `09-個人助手設定` 後 |
| `secondbrain-research-digest` | Obsidian 研究整理 | 完成 `05-第二大腦設定指南` 後 |
| `cross-device-sync` | 全域 skills 跨裝置同步 | 完成主線後，需要同步多台裝置時 |
| `social-cards` | 圖卡輸出 | 需要社群圖卡時，並安裝 Node 依賴 |
| `notebooklm-architecture`、`presentation-workflow` | NotebookLM / 簡報 | 需要 NotebookLM 架構或簡報工作流時 |
| `visual-note-generator` | 圖解筆記 / 視覺筆記 | 將手繪筆記依固定 Workflow 與可替換 Style Profile 生成 16:9／2K 圖解時 |

下載者可照 `11-Codex-Skill-Creator-工作流.md` 建立自己的版本，不需要沿用 `Arry` 命名。

## Gmail 驗證流程

1. 啟用 Gmail plugin / connector。
2. 連接自己的 Google 帳號。
3. 請當前 Agent 查詢 Gmail labels 或 mailbox profile。
4. 若顯示已連接但查不到資料，重新確認授權。

不要把實測帳號寫進文件；使用 `{{GOOGLE_ACCOUNT}}` 或自己的帳號。

## Google Calendar 驗證流程

1. 啟用 Google Calendar plugin。
2. 連接自己的 Google 帳號。
3. 請當前 Agent 查詢今天或明天行程。
4. 確認時區正確。

## Google Drive 驗證流程

1. 啟用 Google Drive plugin。
2. 連接自己的 Google 帳號。
3. 請當前 Agent 搜尋一個測試文件或列出最近檔案。
4. 若要編輯文件，先指定明確檔案，避免誤改。

## Notion 驗證流程

1. 啟用 Notion plugin / connector。
2. 連接自己的 Notion workspace。
3. 請當前 Agent 用只讀方式驗證，例如讀取目前連線使用者資訊，或搜尋一個你指定的測試頁面。
4. 若要寫入 Notion page 或 database，先指定目標頁面／database，並要求當前 Agent 先讀取 schema 再寫入。

不要把 Notion token、workspace ID、page ID 或 database ID 寫進 repo、README、AGENTS.md、skills 或公開筆記。若 Codex plugin 已可用，優先用 plugin，不要先手動建立 API token。

## PDF Skill 驗證流程

1. 確認已安裝 `{{SYNC_ROOT}}/skills/pdf/SKILL.md`。
2. 用一份不敏感 PDF 測試讀取、摘要與頁面定位。
3. 若要引用 PDF 內容，要求 Codex 標明檔名與頁碼或可確認的位置。
4. 若要產出或修改 PDF，依 `pdf` skill 流程做渲染檢查。

若 PDF 產出或解析需要本機 Python 套件，Codex sandbox 應只補入窄範圍可寫路徑：

```toml
[sandbox_workspace_write]
writable_roots = [
  "{{HOME}}/.gitconfig",
  "{{PROJECT_ROOT}}/.git",
  "{{HOME}}/.npm",
  "{{HOME}}/.config/configstore",
  "{{HOME}}/.clasprc.json",
  "{{HOME}}/Library/Caches/pip",
  "{{HOME}}/Library/Caches/com.apple.python",
  "{{HOME}}/Library/Python",
  "{{HOME}}/Library/Preferences/netlify",
]
```

這些路徑用途：

- `{{PROJECT_ROOT}}/.git`：允許 trusted repo 的 Git refs、FETCH_HEAD 與 lock files 正常寫入。
- `{{HOME}}/.gitconfig`：允許 `gh auth setup-git` 設定 Git credential helper。
- `{{HOME}}/.npm`、`.config/configstore`：允許 npm / npx 與 Node CLI 工具使用快取與設定。
- `Library/Caches/pip`、`Library/Caches/com.apple.python`、`Library/Python`：允許 pip / Python 安裝與快取。
- `Library/Preferences/netlify`、`.clasprc.json`：允許 Netlify CLI 與 Clasp OAuth 設定。

驗證套件可用：

```bash
python3 -c "import reportlab, pdfplumber, pypdf; print('pdf libs ok')"
```

## Playwright Skill 驗證流程

1. 確認已安裝 `{{SYNC_ROOT}}/skills/playwright/SKILL.md`。
2. 確認本機有 `npx`，因為 `playwright` skill 的 wrapper script 需要它。
3. 用不敏感測試頁驗證瀏覽器操作，例如開啟 `https://example.com`、snapshot、screenshot。
4. 瀏覽器自動化先使用當前 Agent 的原生 browser／computer-use；需要可重現 CLI 時使用共用 `playwright` skill，不必為了同一目的重複安裝外部 browser MCP。

## 驗證全域 Skills

檢查：

```bash
find "{{SYNC_ROOT}}/skills" -maxdepth 2 -name SKILL.md -print
```

每個自訂 skill 至少要有：

```text
<skill-name>/SKILL.md
```

`SKILL.md` frontmatter 至少包含：

```markdown
---
name: skill-name
description: Use when...
---
```

新增或修改後，分別重載 Codex、Claude、AntiGravity 的 skill 入口。

## 踩坑修正

- Plugin 顯示安裝完成，不代表授權成功；要實際查詢資料驗證。
- 新增或修改 skills 後，通常要對三 Agent 分別開新對話或重載入口。
- 工具不在目前可呼叫清單時，先用當前 Agent 的 tool search／plugin／connector／MCP 清單檢查，不要假設已載入。
- 瀏覽器自動化優先當前 Agent 原生通道；需要 terminal／CLI 型真實瀏覽器操作時，使用必裝的 `playwright` skill。
- 全域規則主版本放 `{{SYNC_ROOT}}/core-rules.md`，專案規則放專案根目錄 `AGENTS.md`；三 Agent 原生入口由 Item 16 管理。
- 外部／第三方 skill 教學不能直接照搬；自訂 skills 共用主版本放 `{{SYNC_ROOT}}/skills`，來源專屬設定改寫為三個 adapter。
- 不要覆蓋 `{{CODEX_HOME}}/skills/.system/skill-creator`；需要優化時建立 companion skill。

## 內建 Skill 完整安裝內容

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊。這個序號項目會安裝：`pdf`、`playwright`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請依 README 設定 `{{SYNC_ROOT}}`；package 只寫入共用主版本，Item 16 與 chezmoi 會建立 Codex、Claude、AntiGravity 的原生入口。

````bash
set -e

# ---- pdf ----
mkdir -p "{{SYNC_ROOT}}/skills/pdf"
# pdf/LICENSE.txt
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/pdf/LICENSE.txt")"
cat > "{{SYNC_ROOT}}/skills/pdf/LICENSE.txt" <<'AGENT_LAZYPACK_PDF_LICENSE_TXT_D0ED4CC3FB'
Apache License
Version 2.0, January 2004
http://www.apache.org/licenses/

TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

1. Definitions.

   "License" shall mean the terms and conditions for use, reproduction,
   and distribution as defined by Sections 1 through 9 of this document.

   "Licensor" shall mean the copyright owner or entity authorized by
   the copyright owner that is granting the License.

   "Legal Entity" shall mean the union of the acting entity and all
   other entities that control, are controlled by, or are under common
   control with that entity. For the purposes of this definition,
   "control" means (i) the power, direct or indirect, to cause the
   direction or management of such entity, whether by contract or
   otherwise, or (ii) ownership of fifty percent (50%) or more of the
   outstanding shares, or (iii) beneficial ownership of such entity.

   "You" (or "Your") shall mean an individual or Legal Entity
   exercising permissions granted by this License.

   "Source" form shall mean the preferred form for making modifications,
   including but not limited to software source code, documentation
   source, and configuration files.

   "Object" form shall mean any form resulting from mechanical
   transformation or translation of a Source form, including but
   not limited to compiled object code, generated documentation,
   and conversions to other media types.

   "Work" shall mean the work of authorship, whether in Source or
   Object form, made available under the License, as indicated by a
   copyright notice that is included in or attached to the work
   (an example is provided in the Appendix below).

   "Derivative Works" shall mean any work, whether in Source or Object
   form, that is based on (or derived from) the Work and for which the
   editorial revisions, annotations, elaborations, or other modifications
   represent, as a whole, an original work of authorship. For the purposes
   of this License, Derivative Works shall not include works that remain
   separable from, or merely link (or bind by name) to the interfaces of,
   the Work and Derivative Works thereof.

   "Contribution" shall mean any work of authorship, including
   the original version of the Work and any modifications or additions
   to that Work or Derivative Works thereof, that is intentionally
   submitted to Licensor for inclusion in the Work by the copyright owner
   or by an individual or Legal Entity authorized to submit on behalf of
   the copyright owner. For the purposes of this definition, "submitted"
   means any form of electronic, verbal, or written communication sent
   to the Licensor or its representatives, including but not limited to
   communication on electronic mailing lists, source code control systems,
   and issue tracking systems that are managed by, or on behalf of, the
   Licensor for the purpose of discussing and improving the Work, but
   excluding communication that is conspicuously marked or otherwise
   designated in writing by the copyright owner as "Not a Contribution."

   "Contributor" shall mean Licensor and any individual or Legal Entity
   on behalf of whom a Contribution has been received by Licensor and
   subsequently incorporated within the Work.

2. Grant of Copyright License. Subject to the terms and conditions of
   this License, each Contributor hereby grants to You a perpetual,
   worldwide, non-exclusive, no-charge, royalty-free, irrevocable
   copyright license to reproduce, prepare Derivative Works of,
   publicly display, publicly perform, sublicense, and distribute the
   Work and such Derivative Works in Source or Object form.

3. Grant of Patent License. Subject to the terms and conditions of
   this License, each Contributor hereby grants to You a perpetual,
   worldwide, non-exclusive, no-charge, royalty-free, irrevocable
   (except as stated in this section) patent license to make, have made,
   use, offer to sell, sell, import, and otherwise transfer the Work,
   where such license applies only to those patent claims licensable
   by such Contributor that are necessarily infringed by their
   Contribution(s) alone or by combination of their Contribution(s)
   with the Work to which such Contribution(s) was submitted. If You
   institute patent litigation against any entity (including a
   cross-claim or counterclaim in a lawsuit) alleging that the Work
   or a Contribution incorporated within the Work constitutes direct
   or contributory patent infringement, then any patent licenses
   granted to You under this License for that Work shall terminate
   as of the date such litigation is filed.

4. Redistribution. You may reproduce and distribute copies of the
   Work or Derivative Works thereof in any medium, with or without
   modifications, and in Source or Object form, provided that You
   meet the following conditions:

   (a) You must give any other recipients of the Work or
       Derivative Works a copy of this License; and

   (b) You must cause any modified files to carry prominent notices
       stating that You changed the files; and

   (c) You must retain, in the Source form of any Derivative Works
       that You distribute, all copyright, patent, trademark, and
       attribution notices from the Source form of the Work,
       excluding those notices that do not pertain to any part of
       the Derivative Works; and

   (d) If the Work includes a "NOTICE" text file as part of its
       distribution, then any Derivative Works that You distribute must
       include a readable copy of the attribution notices contained
       within such NOTICE file, excluding those notices that do not
       pertain to any part of the Derivative Works, in at least one
       of the following places: within a NOTICE text file distributed
       as part of the Derivative Works; within the Source form or
       documentation, if provided along with the Derivative Works; or,
       within a display generated by the Derivative Works, if and
       wherever such third-party notices normally appear. The contents
       of the NOTICE file are for informational purposes only and
       do not modify the License. You may add Your own attribution
       notices within Derivative Works that You distribute, alongside
       or as an addendum to the NOTICE text from the Work, provided
       that such additional attribution notices cannot be construed
       as modifying the License.

   You may add Your own copyright statement to Your modifications and
   may provide additional or different license terms and conditions
   for use, reproduction, or distribution of Your modifications, or
   for any such Derivative Works as a whole, provided Your use,
   reproduction, and distribution of the Work otherwise complies with
   the conditions stated in this License.

5. Submission of Contributions. Unless You explicitly state otherwise,
   any Contribution intentionally submitted for inclusion in the Work
   by You to the Licensor shall be under the terms and conditions of
   this License, without any additional terms or conditions.
   Notwithstanding the above, nothing herein shall supersede or modify
   the terms of any separate license agreement you may have executed
   with Licensor regarding such Contributions.

6. Trademarks. This License does not grant permission to use the trade
   names, trademarks, service marks, or product names of the Licensor,
   except as required for reasonable and customary use in describing the
   origin of the Work and reproducing the content of the NOTICE file.

7. Disclaimer of Warranty. Unless required by applicable law or
   agreed to in writing, Licensor provides the Work (and each
   Contributor provides its Contributions) on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
   implied, including, without limitation, any warranties or conditions
   of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
   PARTICULAR PURPOSE. You are solely responsible for determining the
   appropriateness of using or redistributing the Work and assume any
   risks associated with Your exercise of permissions under this License.

8. Limitation of Liability. In no event and under no legal theory,
   whether in tort (including negligence), contract, or otherwise,
   unless required by applicable law (such as deliberate and grossly
   negligent acts) or agreed to in writing, shall any Contributor be
   liable to You for damages, including any direct, indirect, special,
   incidental, or consequential damages of any character arising as a
   result of this License or out of the use or inability to use the
   Work (including but not limited to damages for loss of goodwill,
   work stoppage, computer failure or malfunction, or any and all
   other commercial damages or losses), even if such Contributor
   has been advised of the possibility of such damages.

9. Accepting Warranty or Additional Liability. While redistributing
   the Work or Derivative Works thereof, You may choose to offer,
   and charge a fee for, acceptance of support, warranty, indemnity,
   or other liability obligations and/or rights consistent with this
   License. However, in accepting such obligations, You may act only
   on Your own behalf and on Your sole responsibility, not on behalf of
   any other Contributor, and only if You agree to indemnify,
   defend, and hold each Contributor harmless for any liability
   incurred by, or claims asserted against, such Contributor by reason
   of your accepting any such warranty or additional liability.

END OF TERMS AND CONDITIONS

APPENDIX: How to apply the Apache License to your work.

   To apply the Apache License to your work, attach the following
   boilerplate notice, with the fields enclosed by brackets "[]"
   replaced with your own identifying information. (Don\'t include
   the brackets!)  The text should be enclosed in the appropriate
   comment syntax for the file format. We also recommend that a
   file or class name and description of purpose be included on the
   same "printed page" as the copyright notice for easier
   identification within third-party archives.

Copyright [yyyy] [name of copyright owner]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
AGENT_LAZYPACK_PDF_LICENSE_TXT_D0ED4CC3FB

# pdf/SKILL.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/pdf/SKILL.md")"
cat > "{{SYNC_ROOT}}/skills/pdf/SKILL.md" <<'AGENT_LAZYPACK_PDF_SKILL_MD_0E95F5A366'
---
name: "pdf"
description: "Use when tasks involve reading, creating, or reviewing PDF files where rendering and layout matter; prefer visual checks by rendering pages (Poppler) and use Python tools such as `reportlab`, `pdfplumber`, and `pypdf` for generation and extraction."
---


# PDF Skill

## When to use
- Read or review PDF content where layout and visuals matter.
- Create PDFs programmatically with reliable formatting.
- Validate final rendering before delivery.

## Workflow
1. Prefer visual review: render PDF pages to PNGs and inspect them.
   - Use `pdftoppm` if available.
   - If unavailable, install Poppler or ask the user to review the output locally.
2. Use `reportlab` to generate PDFs when creating new documents.
3. Use `pdfplumber` (or `pypdf`) for text extraction and quick checks; do not rely on it for layout fidelity.
4. After each meaningful update, re-render pages and verify alignment, spacing, and legibility.

## Temp and output conventions
- In standard four-box projects, use `100_Todo/drafts/pdf/` for intermediate files; delete when done.
- Write final artifacts under `100_Todo/projects/pdf/` when the project has `100_Todo/`; do not create a project-root `output/pdf/` folder.
- Keep filenames stable and descriptive.

## Dependencies (install if missing)
Prefer `uv` for dependency management.

Python packages:
```
uv pip install reportlab pdfplumber pypdf
```
If `uv` is unavailable:
```
python3 -m pip install reportlab pdfplumber pypdf
```
System tools (for rendering):
```
# macOS (Homebrew)
brew install poppler

# Ubuntu/Debian
sudo apt-get install -y poppler-utils
```

If installation isn't possible in this environment, tell the user which dependency is missing and how to install it locally.

## Environment
No required environment variables.

## Rendering command
```
pdftoppm -png $INPUT_PDF $OUTPUT_PREFIX
```

## Quality expectations
- Maintain polished visual design: consistent typography, spacing, margins, and section hierarchy.
- Avoid rendering issues: clipped text, overlapping elements, broken tables, black squares, or unreadable glyphs.
- Charts, tables, and images must be sharp, aligned, and clearly labeled.
- Use ASCII hyphens only. Avoid U+2011 (non-breaking hyphen) and other Unicode dashes.
- Citations and references must be human-readable; never leave tool tokens or placeholder strings.

## Final checks
- Do not deliver until the latest PNG inspection shows zero visual or formatting defects.
- Confirm headers/footers, page numbering, and section transitions look polished.
- Keep intermediate files organized or remove them after final approval.
AGENT_LAZYPACK_PDF_SKILL_MD_0E95F5A366

# pdf/agents/openai.yaml
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/pdf/agents/openai.yaml")"
cat > "{{SYNC_ROOT}}/skills/pdf/agents/openai.yaml" <<'AGENT_LAZYPACK_PDF_AGENTS_OPENAI_YAML_DEB9755D27'
interface:
  display_name: "PDF Skill"
  short_description: "Create, edit, and review PDFs"
  icon_large: "./assets/pdf.png"
  default_prompt: "Create, edit, or review this PDF and summarize the key output or changes."
AGENT_LAZYPACK_PDF_AGENTS_OPENAI_YAML_DEB9755D27

# pdf/assets/pdf.png
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/pdf/assets/pdf.png")"
python3 - "{{SYNC_ROOT}}/skills/pdf/assets/pdf.png" <<'AGENT_LAZYPACK_PDF_ASSETS_PDF_PNG_6615B1D87E'
import base64
from pathlib import Path
import sys
payload = """iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAACXBIWXMAAAsTAAALEwEAmpwYAAAA
AXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAS1SURBVHgB7Z2/TxRBFMff7h6gkBg1Go3RaIwN
2piorTYWQGEDfwQ0FFBT0dNQQE0NNRY2UGgUSgPRkAghWvDD0BwE2L1z35iB5diDO5iZ/e7yPskm
B+xBdj/Me/NmZ+a8agwJMPgkQCFCwBAhYIgQMEQIGCIEDBEChggBQ4SAIULAECFgiBAwRAgYIgQM
EQKGCAGjRBlR3dykytISVdbWiHZ3yST+7ZsU3L9H9PQZ0cNHlCc8108Mo7k5iubnlQxblB49UAdT
vXWbvA+9RDduUB5wJoQFHE5OqpZhm6QQRVsb0fuu/y0GHCdCwpkZCqenyRWnhGhYSucLQsZ6Unct
40w+fST6+oWQsSoESobm22doKdaEcK6Ak6EBlmJNyOHYGEEDKsWKkMriIlVWVwkeQClWhIRxrZEb
wKSYFxJX3dxCcgWQFONCchGq0gCRYlxIlcem8gqAFPNCymXKNRlLkeH3NDKUIkLqkZEUEXIWGUgR
IefhWEohhVTDiIziUEoxhRh+JKxwJKWQQirlXfOthHEgpZg5JJZR+btDVrAspbBJPVz/Y6eVMCzl
9zrZoLBCqvv7FK7auWkKS62k0N3eaGOLDn6sKDnG4RZioZUUvg6pbO/QwfefsZxt82I2N8g0mc1c
dAmLOFz5pV57He3kXWslLwjosvjPOil4SUa5EkKSVLlLXDZTp3hl8/WODJ2AIULAECFgiBAwRAgY
IgQMEQKGCAFDhIAhQsAQIWCIEDAyH1z0OjqIrl9P/Vl1a6vh89POPfG+O3foXPb2Mp8Km7kQ/9Ur
ahkYqPtzXtfOaxX1cuqzzuel13odfC1t4+N0HocTE6nvdQl8yArevaPW4eGGzvWfP1eyWvr7Ka9A
PQ85GB093ligvZ2CN2+o1NtL3uPH6mbX7v6QPN+7e5eCt2+VQD54blY4NXXqb0SzsxTGRyo25nM1
CZQQvrnJnR7C+DULYfzOzlNCkufrvVNYRKm7Wx0Rh7qanMBfu9hN4qJAhyyVwJskSvz3c77JG1At
hEOT7g2xDD8OPZrK8nJDv0O1mriVeHHI4zBWC4fBtO/zusgIYG0klJB6yZtvVFO7B3GYYiEpLYyl
B/FRiwpjIuRs+CZxNzSql4TroFtAWk3BayDTFqairI2EErI/OHjphMs9LU1amIsWFlRdg0qhhk64
ZZT6+tRr3evKG7mel8VdWx2WuE7xnjxRyZxJq0HyQK6FBLGQWnRBiNBjugjGhTRbO/ANPAotDVTK
J85PfI97VpwzuPualsz1e84bhMwa41v88eAe7614FeBuuv/6NZnEeFLnWH5laGRIv0mMC+GeTlol
XDT4Gv24E2EaK93eZC1QVGxdoxUhpZ6eCw0M5okgMc5mEjuFIT/L6OqioqKe0VgKy9Yqda6YbcTY
rEmOBtjA6tBJy9BQoRI8X0vryAjZxKoQfQFFkOLqWpzs/a43Vc56RsdFCeLirzQwcDROZhOnH1dR
O6UHHX6Or3Khw2LX+eeHMHr+lHpYBLZpJj9C9uPHvNwqshh1yERILSgtBiHXQQgRjpHJ1mCIEDBE
CBgiBAwRAoYIAUOEgCFCwBAhYIgQMEQIGCIEDBEChggBQ4SA8Q/FuAFFXtlkkQAAAABJRU5ErkJg
gg=="""
Path(sys.argv[1]).write_bytes(base64.b64decode(payload))
AGENT_LAZYPACK_PDF_ASSETS_PDF_PNG_6615B1D87E

test -f "{{SYNC_ROOT}}/skills/pdf/SKILL.md" && echo "pdf installed for Codex, Claude, and AntiGravity"

# ---- playwright ----
mkdir -p "{{SYNC_ROOT}}/skills/playwright"
# playwright/LICENSE.txt
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/playwright/LICENSE.txt")"
cat > "{{SYNC_ROOT}}/skills/playwright/LICENSE.txt" <<'AGENT_LAZYPACK_PLAYWRIGHT_LICENSE_TXT_D0ED4CC3FB'
                                 Apache License
                           Version 2.0, January 2004
                        http://www.apache.org/licenses/

   TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

   1. Definitions.

      "License" shall mean the terms and conditions for use, reproduction,
      and distribution as defined by Sections 1 through 9 of this document.

      "Licensor" shall mean the copyright owner or entity authorized by
      the copyright owner that is granting the License.

      "Legal Entity" shall mean the union of the acting entity and all
      other entities that control, are controlled by, or are under common
      control with that entity. For the purposes of this definition,
      "control" means (i) the power, direct or indirect, to cause the
      direction or management of such entity, whether by contract or
      otherwise, or (ii) ownership of fifty percent (50%) or more of the
      outstanding shares, or (iii) beneficial ownership of such entity.

      "You" (or "Your") shall mean an individual or Legal Entity
      exercising permissions granted by this License.

      "Source" form shall mean the preferred form for making modifications,
      including but not limited to software source code, documentation
      source, and configuration files.

      "Object" form shall mean any form resulting from mechanical
      transformation or translation of a Source form, including but
      not limited to compiled object code, generated documentation,
      and conversions to other media types.

      "Work" shall mean the work of authorship, whether in Source or
      Object form, made available under the License, as indicated by a
      copyright notice that is included in or attached to the work
      (an example is provided in the Appendix below).

      "Derivative Works" shall mean any work, whether in Source or Object
      form, that is based on (or derived from) the Work and for which the
      editorial revisions, annotations, elaborations, or other modifications
      represent, as a whole, an original work of authorship. For the purposes
      of this License, Derivative Works shall not include works that remain
      separable from, or merely link (or bind by name) to the interfaces of,
      the Work and Derivative Works thereof.

      "Contribution" shall mean any work of authorship, including
      the original version of the Work and any modifications or additions
      to that Work or Derivative Works thereof, that is intentionally
      submitted to Licensor for inclusion in the Work by the copyright owner
      or by an individual or Legal Entity authorized to submit on behalf of
      the copyright owner. For the purposes of this definition, "submitted"
      means any form of electronic, verbal, or written communication sent
      to the Licensor or its representatives, including but not limited to
      communication on electronic mailing lists, source code control systems,
      and issue tracking systems that are managed by, or on behalf of, the
      Licensor for the purpose of discussing and improving the Work, but
      excluding communication that is conspicuously marked or otherwise
      designated in writing by the copyright owner as "Not a Contribution."

      "Contributor" shall mean Licensor and any individual or Legal Entity
      on behalf of whom a Contribution has been received by Licensor and
      subsequently incorporated within the Work.

   2. Grant of Copyright License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      copyright license to reproduce, prepare Derivative Works of,
      publicly display, publicly perform, sublicense, and distribute the
      Work and such Derivative Works in Source or Object form.

   3. Grant of Patent License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      (except as stated in this section) patent license to make, have made,
      use, offer to sell, sell, import, and otherwise transfer the Work,
      where such license applies only to those patent claims licensable
      by such Contributor that are necessarily infringed by their
      Contribution(s) alone or by combination of their Contribution(s)
      with the Work to which such Contribution(s) was submitted. If You
      institute patent litigation against any entity (including a
      cross-claim or counterclaim in a lawsuit) alleging that the Work
      or a Contribution incorporated within the Work constitutes direct
      or contributory patent infringement, then any patent licenses
      granted to You under this License for that Work shall terminate
      as of the date such litigation is filed.

   4. Redistribution. You may reproduce and distribute copies of the
      Work or Derivative Works thereof in any medium, with or without
      modifications, and in Source or Object form, provided that You
      meet the following conditions:

      (a) You must give any other recipients of the Work or
          Derivative Works a copy of this License; and

      (b) You must cause any modified files to carry prominent notices
          stating that You changed the files; and

      (c) You must retain, in the Source form of any Derivative Works
          that You distribute, all copyright, patent, trademark, and
          attribution notices from the Source form of the Work,
          excluding those notices that do not pertain to any part of
          the Derivative Works; and

      (d) If the Work includes a "NOTICE" text file as part of its
          distribution, then any Derivative Works that You distribute must
          include a readable copy of the attribution notices contained
          within such NOTICE file, excluding those notices that do not
          pertain to any part of the Derivative Works, in at least one
          of the following places: within a NOTICE text file distributed
          as part of the Derivative Works; within the Source form or
          documentation, if provided along with the Derivative Works; or,
          within a display generated by the Derivative Works, if and
          wherever such third-party notices normally appear. The contents
          of the NOTICE file are for informational purposes only and
          do not modify the License. You may add Your own attribution
          notices within Derivative Works that You distribute, alongside
          or as an addendum to the NOTICE text from the Work, provided
          that such additional attribution notices cannot be construed
          as modifying the License.

      You may add Your own copyright statement to Your modifications and
      may provide additional or different license terms and conditions
      for use, reproduction, or distribution of Your modifications, or
      for any such Derivative Works as a whole, provided Your use,
      reproduction, and distribution of the Work otherwise complies with
      the conditions stated in this License.

   5. Submission of Contributions. Unless You explicitly state otherwise,
      any Contribution intentionally submitted for inclusion in the Work
      by You to the Licensor shall be under the terms and conditions of
      this License, without any additional terms or conditions.
      Notwithstanding the above, nothing herein shall supersede or modify
      the terms of any separate license agreement you may have executed
      with Licensor regarding such Contributions.

   6. Trademarks. This License does not grant permission to use the trade
      names, trademarks, service marks, or product names of the Licensor,
      except as required for reasonable and customary use in describing the
      origin of the Work and reproducing the content of the NOTICE file.

   7. Disclaimer of Warranty. Unless required by applicable law or
      agreed to in writing, Licensor provides the Work (and each
      Contributor provides its Contributions) on an "AS IS" BASIS,
      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
      implied, including, without limitation, any warranties or conditions
      of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
      PARTICULAR PURPOSE. You are solely responsible for determining the
      appropriateness of using or redistributing the Work and assume any
      risks associated with Your exercise of permissions under this License.

   8. Limitation of Liability. In no event and under no legal theory,
      whether in tort (including negligence), contract, or otherwise,
      unless required by applicable law (such as deliberate and grossly
      negligent acts) or agreed to in writing, shall any Contributor be
      liable to You for damages, including any direct, indirect, special,
      incidental, or consequential damages of any character arising as a
      result of this License or out of the use or inability to use the
      Work (including but not limited to damages for loss of goodwill,
      work stoppage, computer failure or malfunction, or any and all
      other commercial damages or losses), even if such Contributor
      has been advised of the possibility of such damages.

   9. Accepting Warranty or Additional Liability. While redistributing
      the Work or Derivative Works thereof, You may choose to offer,
      and charge a fee for, acceptance of support, warranty, indemnity,
      or other liability obligations and/or rights consistent with this
      License. However, in accepting such obligations, You may act only
      on Your own behalf and on Your sole responsibility, not on behalf
      of any other Contributor, and only if You agree to indemnify,
      defend, and hold each Contributor harmless for any liability
      incurred by, or claims asserted against, such Contributor by reason
      of your accepting any such warranty or additional liability.

   END OF TERMS AND CONDITIONS

   APPENDIX: How to apply the Apache License to your work.

      To apply the Apache License to your work, attach the following
      boilerplate notice, with the fields enclosed by brackets "[]"
      replaced with your own identifying information. (Don't include
      the brackets!)  The text should be enclosed in the appropriate
      comment syntax for the file format. We also recommend that a
      file or class name and description of purpose be included on the
      same "printed page" as the copyright notice for easier
      identification within third-party archives.

   Copyright (c) Microsoft Corporation.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
AGENT_LAZYPACK_PLAYWRIGHT_LICENSE_TXT_D0ED4CC3FB

# playwright/NOTICE.txt
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/playwright/NOTICE.txt")"
cat > "{{SYNC_ROOT}}/skills/playwright/NOTICE.txt" <<'AGENT_LAZYPACK_PLAYWRIGHT_NOTICE_TXT_B810EBE4FF'
This skill includes material derived from the Microsoft playwright-cli repository.

Source:
- Repository: microsoft/playwright-cli
- Path: skills/playwright-cli/SKILL.md

Copyright (c) Microsoft Corporation.

Licensed under the Apache License, Version 2.0.
See LICENSE.txt in this directory.

Modifications:
- Adapted for the Codex skill collection.
- Added a wrapper script and local reference guides.
AGENT_LAZYPACK_PLAYWRIGHT_NOTICE_TXT_B810EBE4FF

# playwright/SKILL.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/playwright/SKILL.md")"
cat > "{{SYNC_ROOT}}/skills/playwright/SKILL.md" <<'AGENT_LAZYPACK_PLAYWRIGHT_SKILL_MD_0E95F5A366'
---
name: "playwright"
description: "Use when the task requires automating a real browser from the terminal (navigation, form filling, snapshots, screenshots, data extraction, UI-flow debugging) via `playwright-cli` or the bundled wrapper script."
---


# Playwright CLI Skill

Drive a real browser from the terminal using `playwright-cli`. Prefer the bundled wrapper script so the CLI works even when it is not globally installed.
Treat this skill as CLI-first automation. Do not pivot to `@playwright/test` unless the user explicitly asks for test files.

## Prerequisite check (required)

Before proposing commands, check whether `npx` is available (the wrapper depends on it):

```bash
command -v npx >/dev/null 2>&1
```

If it is not available, pause and ask the user to install Node.js/npm (which provides `npx`). Provide these steps verbatim:

```bash
# Verify Node/npm are installed
node --version
npm --version

# If missing, install Node.js/npm, then:
npm install -g @playwright/cli@latest
playwright-cli --help
```

Once `npx` is present, proceed with the wrapper script. A global install of `playwright-cli` is optional.

## Skill path (set once)

```bash
export SYNC_ROOT="${SYNC_ROOT:?Set SYNC_ROOT to the shared assistant root}"
export PWCLI="$SYNC_ROOT/skills/playwright/scripts/playwright_cli.sh"
```

The shared package lives under `$SYNC_ROOT/skills`; Codex, Claude, and AntiGravity access it through their native skills entrypoints.

## Quick start

Use the wrapper script:

```bash
"$PWCLI" open https://playwright.dev --headed
"$PWCLI" snapshot
"$PWCLI" click e15
"$PWCLI" type "Playwright"
"$PWCLI" press Enter
"$PWCLI" screenshot
```

If the user prefers a global install, this is also valid:

```bash
npm install -g @playwright/cli@latest
playwright-cli --help
```

## Core workflow

1. Open the page.
2. Snapshot to get stable element refs.
3. Interact using refs from the latest snapshot.
4. Re-snapshot after navigation or significant DOM changes.
5. Capture artifacts (screenshot, pdf, traces) when useful.

Minimal loop:

```bash
"$PWCLI" open https://example.com
"$PWCLI" snapshot
"$PWCLI" click e3
"$PWCLI" snapshot
```

## When to snapshot again

Snapshot again after:

- navigation
- clicking elements that change the UI substantially
- opening/closing modals or menus
- tab switches

Refs can go stale. When a command fails due to a missing ref, snapshot again.

## Recommended patterns

### Form fill and submit

```bash
"$PWCLI" open https://example.com/form
"$PWCLI" snapshot
"$PWCLI" fill e1 "user@example.com"
"$PWCLI" fill e2 "password123"
"$PWCLI" click e3
"$PWCLI" snapshot
```

### Debug a UI flow with traces

```bash
"$PWCLI" open https://example.com --headed
"$PWCLI" tracing-start
# ...interactions...
"$PWCLI" tracing-stop
```

### Multi-tab work

```bash
"$PWCLI" tab-new https://example.com
"$PWCLI" tab-list
"$PWCLI" tab-select 0
"$PWCLI" snapshot
```

## Wrapper script

The wrapper script uses `npx --package @playwright/cli playwright-cli` so the CLI can run without a global install:

```bash
"$PWCLI" --help
```

Prefer the wrapper unless the repository already standardizes on a global install.

## References

Open only what you need:

- CLI command reference: `references/cli.md`
- Practical workflows and troubleshooting: `references/workflows.md`

## Guardrails

- Always snapshot before referencing element ids like `e12`.
- Re-snapshot when refs seem stale.
- Prefer explicit commands over `eval` and `run-code` unless needed.
- When you do not have a fresh snapshot, use placeholder refs like `eX` and say why; do not bypass refs with `run-code`.
- Use `--headed` when a visual check will help.
- When capturing artifacts in a standard four-box project, use `100_Todo/projects/playwright/<label>/` and avoid introducing project-root `output/` folders.
- Default to CLI commands and workflows, not Playwright test specs.
AGENT_LAZYPACK_PLAYWRIGHT_SKILL_MD_0E95F5A366

# playwright/agents/openai.yaml
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/playwright/agents/openai.yaml")"
cat > "{{SYNC_ROOT}}/skills/playwright/agents/openai.yaml" <<'AGENT_LAZYPACK_PLAYWRIGHT_AGENTS_OPENAI_YAML_DEB9755D27'
interface:
  display_name: "Playwright CLI Skill"
  short_description: "Automate real browsers from the terminal"
  icon_small: "./assets/playwright-small.svg"
  icon_large: "./assets/playwright.png"
  default_prompt: "Automate this browser workflow with Playwright and produce a reliable script with run steps."
AGENT_LAZYPACK_PLAYWRIGHT_AGENTS_OPENAI_YAML_DEB9755D27

# playwright/assets/playwright-small.svg
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/playwright/assets/playwright-small.svg")"
cat > "{{SYNC_ROOT}}/skills/playwright/assets/playwright-small.svg" <<'AGENT_LAZYPACK_PLAYWRIGHT_ASSETS_PLAYWRIGHT_SMALL_SVG_09F54B079F'
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
  <path d="m8.55 7.568.124.028 5.16 1.548.137.054c.606.294.645 1.165.068 1.512l-.133.066-2.236.894-.894 2.236c-.285.713-1.263.714-1.578.065l-.054-.138-1.548-5.16a.866.866 0 0 1 .954-1.105ZM10 12.983l.715-1.787.037-.08a.865.865 0 0 1 .445-.402L12.983 10 8.721 8.72l1.278 4.262ZM4.723 10.38a.532.532 0 0 1 .752.752l-1.414 1.414a.532.532 0 1 1-.752-.752l1.414-1.414ZM2.27 5.86l1.932.517.1.039a.533.533 0 0 1-.269 1.007l-.106-.018-1.932-.517-.101-.039a.532.532 0 0 1 .27-1.006l.106.017Zm9.608-2.62a.532.532 0 0 1 .668.82l-1.414 1.414a.532.532 0 1 1-.752-.752l1.414-1.414.084-.068ZM6.237 1.618a.532.532 0 0 1 .652.377l.518 1.932.017.106a.533.533 0 0 1-1.007.27l-.039-.101-.517-1.932-.017-.106a.532.532 0 0 1 .393-.546Z"/>
</svg>
AGENT_LAZYPACK_PLAYWRIGHT_ASSETS_PLAYWRIGHT_SMALL_SVG_09F54B079F

# playwright/assets/playwright.png
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/playwright/assets/playwright.png")"
python3 - "{{SYNC_ROOT}}/skills/playwright/assets/playwright.png" <<'AGENT_LAZYPACK_PLAYWRIGHT_ASSETS_PLAYWRIGHT_PNG_BA9D88E747'
import base64
from pathlib import Path
import sys
payload = """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
j1jdIrQC6nEAAAAASUVORK5CYII="""
Path(sys.argv[1]).write_bytes(base64.b64decode(payload))
AGENT_LAZYPACK_PLAYWRIGHT_ASSETS_PLAYWRIGHT_PNG_BA9D88E747

# playwright/references/cli.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/playwright/references/cli.md")"
cat > "{{SYNC_ROOT}}/skills/playwright/references/cli.md" <<'AGENT_LAZYPACK_PLAYWRIGHT_REFERENCES_CLI_MD_CDC1230323'
# Playwright CLI Reference

Use the wrapper script unless the CLI is already installed globally:

```bash
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
export PWCLI="$SYNC_ROOT/skills/playwright/scripts/playwright_cli.sh"
"$PWCLI" --help
```

The shared package lives under `$SYNC_ROOT/skills` and is exposed through all three native skills entrypoints.

Optional convenience alias:

```bash
alias pwcli="$PWCLI"
```

## Core

```bash
pwcli open https://example.com
pwcli close
pwcli snapshot
pwcli click e3
pwcli dblclick e7
pwcli type "search terms"
pwcli press Enter
pwcli fill e5 "user@example.com"
pwcli drag e2 e8
pwcli hover e4
pwcli select e9 "option-value"
pwcli upload ./document.pdf
pwcli check e12
pwcli uncheck e12
pwcli eval "document.title"
pwcli eval "el => el.textContent" e5
pwcli dialog-accept
pwcli dialog-accept "confirmation text"
pwcli dialog-dismiss
pwcli resize 1920 1080
```

## Navigation

```bash
pwcli go-back
pwcli go-forward
pwcli reload
```

## Keyboard

```bash
pwcli press Enter
pwcli press ArrowDown
pwcli keydown Shift
pwcli keyup Shift
```

## Mouse

```bash
pwcli mousemove 150 300
pwcli mousedown
pwcli mousedown right
pwcli mouseup
pwcli mouseup right
pwcli mousewheel 0 100
```

## Save as

```bash
pwcli screenshot
pwcli screenshot e5
pwcli pdf
```

## Tabs

```bash
pwcli tab-list
pwcli tab-new
pwcli tab-new https://example.com/page
pwcli tab-close
pwcli tab-close 2
pwcli tab-select 0
```

## DevTools

```bash
pwcli console
pwcli console warning
pwcli network
pwcli run-code "await page.waitForTimeout(1000)"
pwcli tracing-start
pwcli tracing-stop
```

## Sessions

Use a named session to isolate work:

```bash
pwcli --session todo open https://demo.playwright.dev/todomvc
pwcli --session todo snapshot
```

Or set an environment variable once:

```bash
export PLAYWRIGHT_CLI_SESSION=todo
pwcli open https://demo.playwright.dev/todomvc
```
AGENT_LAZYPACK_PLAYWRIGHT_REFERENCES_CLI_MD_CDC1230323

# playwright/references/workflows.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/playwright/references/workflows.md")"
cat > "{{SYNC_ROOT}}/skills/playwright/references/workflows.md" <<'AGENT_LAZYPACK_PLAYWRIGHT_REFERENCES_WORKFLOWS_MD_87638EC098'
# Playwright CLI Workflows

Use the wrapper script and snapshot often.
Assume `PWCLI` is set and `pwcli` is an alias for `"$PWCLI"`.
In standard four-box projects, run commands from `100_Todo/projects/playwright/<label>/` to keep artifacts contained.

## Standard interaction loop

```bash
pwcli open https://example.com
pwcli snapshot
pwcli click e3
pwcli snapshot
```

## Form submission

```bash
pwcli open https://example.com/form --headed
pwcli snapshot
pwcli fill e1 "user@example.com"
pwcli fill e2 "password123"
pwcli click e3
pwcli snapshot
pwcli screenshot
```

## Data extraction

```bash
pwcli open https://example.com
pwcli snapshot
pwcli eval "document.title"
pwcli eval "el => el.textContent" e12
```

## Debugging and inspection

Capture console messages and network activity after reproducing an issue:

```bash
pwcli console warning
pwcli network
```

Record a trace around a suspicious flow:

```bash
pwcli tracing-start
# reproduce the issue
pwcli tracing-stop
pwcli screenshot
```

## Sessions

Use sessions to isolate work across projects:

```bash
pwcli --session marketing open https://example.com
pwcli --session marketing snapshot
pwcli --session checkout open https://example.com/checkout
```

Or set the session once:

```bash
export PLAYWRIGHT_CLI_SESSION=checkout
pwcli open https://example.com/checkout
```

## Configuration file

By default, the CLI reads `playwright-cli.json` from the current directory. Use `--config` to point at a specific file.

Minimal example:

```json
{
  "browser": {
    "launchOptions": {
      "headless": false
    },
    "contextOptions": {
      "viewport": { "width": 1280, "height": 720 }
    }
  }
}
```

## Troubleshooting

- If an element ref fails, run `pwcli snapshot` again and retry.
- If the page looks wrong, re-open with `--headed` and resize the window.
- If a flow depends on prior state, use a named `--session`.
AGENT_LAZYPACK_PLAYWRIGHT_REFERENCES_WORKFLOWS_MD_87638EC098

# playwright/scripts/playwright_cli.sh
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/playwright/scripts/playwright_cli.sh")"
cat > "{{SYNC_ROOT}}/skills/playwright/scripts/playwright_cli.sh" <<'AGENT_LAZYPACK_PLAYWRIGHT_SCRIPTS_PLAYWRIGHT_CLI_SH_8958AA4D91'
#!/usr/bin/env bash
set -euo pipefail

if ! command -v npx >/dev/null 2>&1; then
  echo "Error: npx is required but not found on PATH." >&2
  exit 1
fi

has_session_flag="false"
for arg in "$@"; do
  case "$arg" in
    --session|--session=*)
      has_session_flag="true"
      break
      ;;
  esac
done

cmd=(npx --yes --package @playwright/cli playwright-cli)
if [[ "${has_session_flag}" != "true" && -n "${PLAYWRIGHT_CLI_SESSION:-}" ]]; then
  cmd+=(--session "${PLAYWRIGHT_CLI_SESSION}")
fi
cmd+=("$@")

exec "${cmd[@]}"
AGENT_LAZYPACK_PLAYWRIGHT_SCRIPTS_PLAYWRIGHT_CLI_SH_8958AA4D91
chmod +x "{{SYNC_ROOT}}/skills/playwright/scripts/playwright_cli.sh"

test -f "{{SYNC_ROOT}}/skills/playwright/SKILL.md" && echo "playwright installed for Codex, Claude, and AntiGravity"
````

安裝完成後，請開新 Agent 對話或重啟對應 App，再測試 skill 是否能被讀取。

<!-- END EMBEDDED_SKILLS -->
