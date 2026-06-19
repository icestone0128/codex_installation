# 23-Visual-Note-Generator-Skill-安裝

> 版本：2026-06-19 Codex App 版  
> 用途：把一張拍照或掃描的手繪筆記，轉成方向正確、文字與版面忠實、符合 Arry 視覺風格的 16:9、至少 2K 圖解作品。

## Skill 定位

此 Skill 只保留「手繪筆記 → 完成圖解」流程。舊版未實際使用的逐字稿轉文章、社群貼文、文章轉資訊圖表、簡報結構與泛用角色提示已移除。

核心能力：

- 先校正照片方向，再讀取文字與版面。
- 原稿有人物時，先確認保留原角色、替換成 Arry，或建立 Jensen／主管等其他 Q 版角色。
- 保留人物方向、角度、手勢、背包與其他道具；不自行新增動作。
- 每一個 Arry 角色都必須署名 `Arry`。
- 原文逐字保留，版塊只接受小幅挪移。
- 套用 Arry 作品集的近白暖色底、手繪黑線、低飽和粉彩與克制點綴。
- 成品固定 16:9，最終檔至少 2560 × 1440。
- 使用者確認成品後，才詢問是否存入 Obsidian `創作庫/Visual-Note-References/`。

## 可攜 Skill 套件

完整套件位於：

`skills/visual-note-generator/`

包含：

- `SKILL.md`：方向校正、文字盤點、角色確認、生成、驗收與作品集交付流程。
- `references/arry-visual-note-style.md`：風格拆解、角色規格、參考圖選擇、提示結構與踩坑。
- `agents/openai.yaml`：Codex App 顯示與預設提示。

## 安裝

將 LazyPack 根目錄替換為實際路徑後執行：

```bash
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator"
rsync -a "{{LAZY_PACK_ROOT}}/skills/visual-note-generator/" \
  "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator/"
```

此使用者的 Arry 角色與作品集路徑已寫成 `SKILL.md` 的 local defaults；其他使用者安裝後，需替換 `{{ASSISTANT_ROOT}}` 與 `{{OBSIDIAN_VAULT}}`。

## 驗證

```bash
python3 "${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-creator/scripts/quick_validate.py" \
  "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator"
```

並確認：

```bash
test -f "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator/SKILL.md"
test -f "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator/references/arry-visual-note-style.md"
test -f "${CODEX_HOME:-$HOME/.codex}/skills/visual-note-generator/agents/openai.yaml"
```

更新全域 Skill 後，建議開新 Codex 對話，讓 metadata 重新載入。
