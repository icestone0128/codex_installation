# Project Handoff

## Current state

- 新增全域 skill `visual-prompt-kit`（9 檔）：文章 → 視覺設計提案。
  版位 × 風格 × 裝飾語言三個獨立維度，`visual-dna.yaml` 鎖系列一致性。
  只出 brief，不生圖、不組版。
- 風格校準是必要互動關卡，一輪問完兩題：
  1. 風格（A 從 5 個候選挑編號附預覽圖／B 自由描述偏好／C 你決定）
  2. 封面人物（不放／預留真人空位／放角色插畫）
- 封面人物兩模式互斥且各自封閉：模式 P 生圖絕不畫人（無人物鐵則、
  空位六要素、第 2 與第 4 欄結尾各一次負面指示）；模式 C 生圖要畫角色，
  明令禁寫 No Person，資產從 `knowledge/arry-visual-identity.yaml` 指標檔讀，
  風格 canonical 來源仍是 `visual-note-generator` 的 style profile。
- 語言預設 `accent: en`、`forbidden: [ja]`（繁中主體＋英文點綴）。
  來源 prompt 舊版為日文點綴，已依使用者要求反轉，未回退。
- 新增 `knowledge/card-style-library/`：100 種風格 `styles.yaml`
  ＋ 100 張 800×800 預覽圖（15 MB）＋ README。屬課程專屬內容，
  只在私有 Google Drive 與 Obsidian 鏡像，不進 public repo 或 LazyPack。
- LazyPack Item 43 已建立並註冊進 `sync-lazypack-embeds.py`；
  內嵌 9 個 skill 檔，風格庫與角色資產內嵌命中皆為 0。
- 已 commit 並 push 到 `origin/main`。

## Next action

- 實作試跑由其他 Agent 進行（使用者指定）。回饋後再依實際卡點修描述、步驟或邊界。
- 週 2 系列圖卡、週 3 銷售頁圖版位，待使用者提供該週 prompt 後新增
  `references/placements/` 檔案；`SKILL.md` 不需修改。
- 週 4「組成銷售頁」使用既有 `landing-page`，不另建 skill。

## Blockers

- 無。

## Last verified

- 2026-08-22，Claude Code：`quick_validate.py` 通過、
  `package_claude_skill.py validate` VALID、
  `audit-agent-compatibility.py` scanned_files=9 findings=0、
  `SKILL.md` 7 個相對連結目標全部存在、三個原生入口都解析得到。
- 2026-08-22，Claude Code：`recommend_styles.py` 實測 8 條路徑通過；
  兩模式互不污染檢查 6 項全過。
- 2026-08-22，Claude Code：LazyPack Item 43 內嵌腳本在隔離目錄實跑，
  產出 9 檔並與主版本 `diff -r` IDENTICAL；repo 與 Obsidian 懶人包
  `diff -qr` 一致。
- 2026-08-22，Claude Code：風格庫 100 筆欄位雜湊逐筆比對 0 筆不符；
  預覽圖檔名推導與頁面實際 URL 0 筆不符、0 筆重複。
