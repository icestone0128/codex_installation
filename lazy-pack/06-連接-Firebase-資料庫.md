# 06-連接 Firebase 資料庫

## 目標

讓 Codex 透過 Firebase CLI / Firebase MCP 管理 Firestore 專案、rules 與測試資料。

## 前置條件

- 已有 Google / Firebase 帳號。
- 已建立 Firebase project，取得 `{{FIREBASE_PROJECT_ID}}`。
- 已安裝 Node.js 與 npm。
- Codex 可讀寫專案資料夾。

## 建立本機 Firebase 設定

在專案根目錄建立 `.firebaserc`：

```json
{
  "projects": {
    "default": "{{FIREBASE_PROJECT_ID}}"
  }
}
```

建立 `firebase.json`：

```json
{
  "firestore": {
    "rules": "firestore.rules"
  }
}
```

建立最小 `firestore.rules`：

```text
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

先用拒絕全部的規則起步，再針對需求打開。

## Firebase CLI

列出專案：

```bash
npx -y firebase-tools@latest projects:list
```

若遇到 npm cache 權限問題：

```bash
env NPM_CONFIG_CACHE=/private/tmp/npm-cache npx -y firebase-tools@latest projects:list
```

部署 rules 前必須確認：

- 正在使用的 Firebase project ID 是 `{{FIREBASE_PROJECT_ID}}`。
- rules 檔案內容已被你審核。
- 使用者明確同意部署。

部署：

```bash
npx -y firebase-tools@latest deploy --only firestore:rules --project "{{FIREBASE_PROJECT_ID}}"
```

## Codex MCP 設定

在 `{{CODEX_CONFIG}}` 加入：

```toml
[mcp_servers.firebase]
command = "env"
args = ["NPM_CONFIG_CACHE=/private/tmp/npm-cache", "npx", "-y", "firebase-tools@latest", "mcp"]
startup_timeout_sec = 60
tool_timeout_sec = 120
```

重啟 Codex App 或開新對話後再測試。

## 驗證

```bash
npx -y firebase-tools@latest projects:list
npx -y firebase-tools@latest firestore:databases:list --project "{{FIREBASE_PROJECT_ID}}"
```

如果要測試寫入，使用專門的測試 collection，測完刪除。

## 本機實測例

曾使用：

- Firebase Project ID：`codex-4e80b`
- Firestore location：`asia-east1`
- Firestore mode：Native

這只是實測例，下載者要換成自己的 Firebase project。

## 踩坑修正

- Firebase Project ID 不能改名；若只是顯示名稱要改，通常要到 Firebase / Google Cloud Console。
- 本地資料夾改名後，要同步檢查 `.firebaserc`、Codex MCP 工作目錄與部署文件。
- `gcloud` 不一定已安裝，不能假設可用它改 Firebase display name。
- `firebase-tools update check failed` 不一定是 Firebase 專案錯；可能只是本機 config 權限問題。
- Firestore 測試資料測完要刪除，避免留下假資料。
- 不要把 service account key 或 Admin SDK 憑證寫進 repo。
