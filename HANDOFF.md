# Project Handoff

## Current state

- Arry 私人全域 `waki-brain` 已安裝 13 個 AI 瓦基第二大腦專案包，共 46 個私人來源檔；版本 catalog 與已授權官網一致。
- Skill 已支援自然語意自動觸發，不必先說 Waki Brain 或專案包名稱；完整詞庫分為強觸發詞與需搭配語境的情境詞。
- 路由器採「正式包名／一個強觸發詞／至少兩個情境詞」判斷，並排除純檔名或資料夾改名操作。
- Codex、Claude、AntiGravity 共用同一個私人全域 package；每週日 06:00 的 `waki-brain-weekly-update` 排程維持啟用。
- 私人課程內容不進 public LazyPack、public repo、commit、push 或部署；公開 repo 只保存本交接紀錄。

## Next action

- 在 Codex、Claude 或 AntiGravity 的新對話直接使用一個未提及 Waki 的真實需求，確認自然語意觸發符合預期。
- 觀察下一次週日 06:00 版本檢查；只有官網新增、刪除、改名專案包或語意邊界需要調整時，才由 `codex-skill-creator` 更新詞庫與測試。

## Blockers

- 無。若已授權 Chrome session 失效，週日更新會安全停止並要求 Arry 重新從知識衛星課程進入官網。

## Last verified

- 2026-07-27，Codex App：13/13 自然需求正確選包；6 個一般敘述／純檔名案例未誤觸；同時包含檔名與實際領域任務時仍能正確路由。
- 2026-07-27，Codex App：Skill quick validator 通過；三 Agent compatibility audit 掃描 53 個檔案、0 findings；三個原生入口皆解析到同一全域 package。
- 2026-07-27，Codex App：本機 catalog 為 13 包、46 檔；公開 LazyPack 無 Waki 私人內容；secret signature 掃描與 `git diff --check` 通過。
