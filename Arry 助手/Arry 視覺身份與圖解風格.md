---
title: Arry 視覺身份與圖解風格
date: 2026-06-14
updated: 2026-06-19
type: project-note
tags:
  - codex
  - arry-assistant
  - visual-note
  - image-generation
---

# Arry 視覺身份與圖解風格

## Canonical 分工

| 類型 | Canonical 檔案 | 內容邊界 |
|---|---|---|
| Skill 路由 | `skills/visual-note-generator/SKILL.md` | 觸發、載入順序、Workflow 與 Style Profile 的分工 |
| 通用流程／輸出 | `references/workflow-contract.md` | 方向校正、必要提問、生成流程、16:9／2K、存檔詢問 |
| 通用限制／踩坑 | `references/generation-guardrails.md` | 文字與版面鎖定、提示結構、驗收、修復、踩坑 |
| Style Profile 規格 | `references/style-profile-guide.md` | 個人風格允許欄位、優先序、替換方式 |
| Arry 預設風格 | `references/default-style-profile.yaml` | Arry 的背景、線條、配色、字體、裝飾、角色與署名 |
| 新風格模板 | `references/style-profile-template.yaml` | 其他使用者建立自己的風格 |
| Codex UI metadata | `agents/openai.yaml` | 顯示名稱、短說明、預設啟動 prompt；不包含流程或風格規則 |
| Knowledge 索引 | `knowledge/arry-visual-identity.yaml` | 個人資產位置與上述 canonical pointers；不重複保存風格 |

上述 Skill 路徑均位於：

`/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_symlink/skills/visual-note-generator/`

## 資產位置

- Codex Arry 角色設定：`codex_symlink/knowledge/arry-visual-identity/`
- Codex 圖解參考資產：`codex_symlink/knowledge/visual-note-references/`
- Obsidian Arry 角色設定：`專案庫/codex_installation/Arry 助手/Arry-Visual-Identity/`
- Obsidian 創作庫作品集：`創作庫/Visual-Note-References/`

## 固定原則

- Visual Note Generator 的 Workflow 對所有使用者相同。
- LazyPack 預設內建 Arry 的文字化 Style Profile；沒有 Arry 本機資產也能套用同一視覺方向。
- 其他使用者只替換 Style Profile，不修改 Workflow 或 Guardrails。
- 本機角色圖與作品集只作為選用 fidelity references。
