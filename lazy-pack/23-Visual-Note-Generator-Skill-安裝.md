# 23-Visual-Note-Generator-Skill-安裝

> 版本：2026-06-19 Codex App 版  
> 用途：使用固定、可攜的手繪筆記轉圖流程，搭配可替換的個人 Style Profile，生成方向正確、文字與版面忠實、16:9、至少 2K 的圖解作品。

## 設計原則

這個 Skill 將「通用流程」和「個人風格」分開：

| 檔案 | 責任 | 是否因使用者而改變 |
|---|---|---|
| `SKILL.md` | 觸發、載入順序、流程與 Style Profile 邊界 | 否 |
| `references/workflow-contract.md` | 方向校正、必要提問、生成步驟、輸出格式、作品集交付 | 否 |
| `references/generation-guardrails.md` | 內容與版面限制、提示結構、驗收、修復與踩坑 | 否 |
| `references/style-profile-guide.md` | Style Profile 欄位、優先序與替換方式 | 否 |
| `references/default-style-profile.yaml` | 預設個人風格；內建 Arry 風格，純文字即可使用 | 是 |
| `references/style-profile-template.yaml` | 其他使用者建立個人風格的空白模板 | 是 |
| `agents/openai.yaml` | Codex UI 顯示名稱、簡介與預設啟動 prompt | 否；不是流程或風格來源 |

## 預設效果

所有 LazyPack 安裝者預設都會取得 Arry 的文字化風格：近白暖底、黑色手繪線、低飽和粉彩、橘紅重點、大量留白、克制點綴、教育型 Q 版人物與手寫標題。

這個預設不依賴 Arry 的本機圖片路徑。若使用者本機有角色圖或作品集，可作為額外 fidelity reference；若沒有，仍使用 YAML 文字風格完成生成。

## 固定 Workflow

- 先校正照片方向，再讀取文字與版面。
- 建立精確文字、版面、圖示與人物姿勢清單。
- 原稿有人物時，先確認保留、套用 Profile 角色，或建立其他 Q 版角色。
- 保留人物方向、角度、手勢與道具，不自行新增動作。
- 原文逐字保留，版塊只接受小幅挪移。
- 每次編修後重新檢查全部文字與版面。
- 成品固定 16:9，最終至少 2560 × 1440。
- 使用者確認成品後，才詢問是否存入作品集。

## 改成自己的風格

1. 複製 `references/style-profile-template.yaml`。
2. 依 3–8 張代表作品填入背景、線條、配色、字體、裝飾、角色與參考圖用途。
3. 將完成的內容存成新的 YAML，並在使用時明確選擇；若要成為預設，取代 `default-style-profile.yaml`。
4. 不要修改 `workflow-contract.md` 來改顏色、角色或手繪風格。
5. 本機資產路徑是選用項目；維持 `missing_asset_behavior: use_text_profile`。

## 安裝

完整可攜套件位於 `skills/visual-note-generator/`。

```bash
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator"
rsync -a "{{LAZY_PACK_ROOT}}/skills/visual-note-generator/" \
  "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator/"
```

## 驗證

```bash
python3 "${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-creator/scripts/quick_validate.py" \
  "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator"

test -f "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator/SKILL.md"
test -f "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator/references/workflow-contract.md"
test -f "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator/references/generation-guardrails.md"
test -f "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator/references/style-profile-guide.md"
test -f "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator/references/default-style-profile.yaml"
test -f "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator/references/style-profile-template.yaml"
test -f "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator/agents/openai.yaml"
```

更新全域 Skill 後，建議開新 Codex 對話，讓 metadata 重新載入。
