# Project Handoff

## Current state

- Arry 助手 Obsidian 鏡像規則已改為排除頂層 `knowledge/visual-note-references/` 與 `.DS_Store`；圖解作品只保留全域 Knowledge 與 Obsidian 創作庫兩處。
- `arry-assistant` 新增共用 `scripts/sync_obsidian_mirror.py`；`shutdown-sync`、`project-init-sync`、LazyPack Item 09／10、Obsidian 鏡像與全域 Skills 索引已同步。本次收工已取得使用者 commit／push 授權，提交結果以 Git 歷史為準。
- 第三方 MIT 全域 skill `speak-human-tw`（上游 `Raymondhou0917/speak-human-tw`
  v1.4.0，commit `c8041dfc`）已安裝到共用主版本
  `codex_symlink/skills/speak-human-tw`，三個原生入口都解析得到。
- 套件內容：`SKILL.md`、6 個 `references/`、`evals/benchmark.md` 與
  `run-eval.md`、`LICENSE`，加上本地新增的
  `references/agent-adapters.md` 與 `agents/openai.yaml`。
- 上游 README 圖片、`scripts/generate_star_history.py`、`.github/`、
  `CONTRIBUTING.md`、`CHANGELOG.md`、`install/` 未納入。
- Frontmatter 已正規化：上游頂層 `version`、`author`、`tags`、
  `maturity`、`review_cadence`、`last-updated`、`changelog`、
  `user-invocable` 收進 `metadata:`，正文規則一字未改。
- LazyPack Item 42 已由既有 `sync-lazypack-embeds.py` 產生自含式安裝
  區塊；README、Obsidian 懶人包鏡像、全域 Skills 索引與專案駕駛艙
  均已同步。
- commit `1525e8f` 已推上 `origin/main`，工作樹乾淨。

## Next action

- 本次同步規則提交完成後無必要後續；日後維持雙位置圖解作品路由與過濾式鏡像驗證。
- 無必要後續。日後上游發新版時，依
  `speak-human-tw/references/agent-adapters.md` 的更新程序做 diff、
  重做 frontmatter 正規化、補回參考導航連結，再重跑
  `SYNC_SKILLS_ROOT=<codex_symlink/skills> python3 200_Reference/scripts/sync-lazypack-embeds.py`
  與 Obsidian 兩處同步。

## Blockers

- 無。安裝來源網址附帶的第三方存取憑證已建議使用者自行撤銷；該
  憑證未寫入任何檔案，也未用於任何請求（repo 為 public，clone
  不需要它）。

## Last verified

- 2026-08-13，Claude Code：`speak-human-tw` 通過 `quick_validate.py`、
  `package_claude_skill.py validate` 與
  `audit-agent-compatibility.py`（scanned_files=11, findings=0）；
  `SKILL.md` 9 個相對連結目標全部存在。
- 2026-08-13，Claude Code：LazyPack Item 42 內嵌腳本在隔離目錄實跑，
  產出 12 檔並與主版本 `diff -r` IDENTICAL；repo 與 Obsidian
  懶人包 `diff -qr` 一致；staged diff secret-pattern scan 為 0。
- 2026-08-13，Claude Code：實際觸發試跑走完兩輪契約 — 第一輪輸出
  10 條編號清單後停在確認問句，第二輪依「都不用」維持原文，
  未產出改寫版、未動任何檔案。
- 2026-08-13，Claude Code：chezmoi shutdown checkpoint 全部 symlink
  與 Python bridge OK，`CHEZMOI_STATUS=clean`，未 update、
  未對既有 templates 執行 `add`。
- 2026-08-14，Codex：同步腳本隔離正向／負向測試、正式同步、`--verify-only`、三個 skills validators、跨 Agent compatibility audit、LazyPack Item 09／10 鏡像與圖解作品雙位置 `diff -qr` 均通過。
