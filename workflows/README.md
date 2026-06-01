# workflows/ — 可版本化 workflow mirror

這裡保存 `codex_symlink/workflows/` 的可提交鏡像，方便把成熟前的跨專案 workflow 草稿納入 `codex_installation` 版本管理。

使用原則：

- 實際使用位置仍以 `codex_symlink/workflows/` 為準。
- 這裡只放需要 commit/push、可跨裝置或跨專案重用的 workflow 文件。
- 若 workflow 升級為全域 skill，再同步到全域 skills、LazyPack 與 Obsidian 全域 Skills 索引。

## 目前 workflow

- `heptabase-journal-reflection-interview.md`：結合 Heptabase CLI 與 Daily Interview Assistant，讀取指定日期 Journal，判斷是否有間歇式日記，逐題訪問後經使用者確認，寫入 Daily Log 的 `Reflection` 區塊並讀回驗證。
