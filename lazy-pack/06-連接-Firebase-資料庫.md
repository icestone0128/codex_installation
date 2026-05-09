# 06-連接 Firebase 資料庫

## 目標

讓 Codex 透過 Firebase CLI / Firebase MCP 管理 Firestore 專案、rules 與測試資料。

## 實測專案

- Firebase display name：`Codex`
- Firebase Project ID：`codex-4e80b`
- Project number：`323057435700`
- Firestore location：`asia-east1`
- Firestore mode：Native

## 本機設定

專案 `.firebaserc`：

```json
{
  "projects": {
    "default": "codex-4e80b"
  }
}
```

Codex MCP 設定：

```toml
[mcp_servers.firebase]
command = "npx"
args = ["-y", "firebase-tools@latest", "mcp"]
startup_timeout_sec = 60
tool_timeout_sec = 120
```

## Firestore rules 實測

曾部署到 `codex-4e80b`，允許測試 collection，其他預設拒絕。

部署前必須先確認：

- 正在使用的 Firebase project ID。
- rules 檔案內容。
- 使用者明確同意部署。

## 踩坑修正

- Firebase Project ID 不能改名；若只是顯示名稱要改，通常要到 Firebase / Google Cloud Console。
- Google Drive 專案資料夾改名後，要同步更新 Firebase MCP 的 project directory。
- `gcloud` 本機未安裝，不能假設可用它改 Firebase display name。
- `npx firebase-tools` 可能遇到 npm cache 權限問題，可改用臨時快取：

```bash
env NPM_CONFIG_CACHE=/private/tmp/npm-cache npx -y firebase-tools@latest projects:list
```

- 如果 CLI 顯示 `firebase-tools update check failed`，不一定是 Firebase 專案錯；可能只是 `/Users/arrywu/.config` 權限問題。
- Firestore 測試資料測完要刪除，避免留下假資料。

