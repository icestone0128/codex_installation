# 08-連接-Firebase-資料庫

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

### 安裝全域 Firebase CLI

官方建議用 npm 安裝 Firebase CLI，讓電腦上可直接使用 `firebase` 指令：

```bash
npm install -g firebase-tools
```

安裝前先確認 Node.js 與 npm 可用：

```bash
node --version
npm --version
```

安裝後驗證：

```bash
command -v firebase
firebase --version
firebase login:list
firebase projects:list
```

若尚未登入，使用官方登入流程：

```bash
firebase login
```

### 安裝時常見權限問題

若 npm 回報 cache 權限問題，例如 `~/.npm` 內有舊的 root-owned 檔案，可先改用臨時 cache 路徑安裝：

```bash
npm install -g firebase-tools --cache /private/tmp/npm-cache
```

若錯誤發生在全域 npm 目錄，例如 `/opt/homebrew/lib/node_modules/firebase-tools` 無法建立，代表目前使用者沒有該全域目錄寫入權限。這時需要用系統授權方式執行全域安裝，或改用不需要全域安裝的 `npx` 方式。

若 `firebase --version` 或 `firebase login:list` 已能輸出結果，但同時出現：

```text
firebase-tools update check failed
```

通常不是 Firebase project 設定錯，而是 Firebase CLI 想寫入本機 config store 時被權限或沙盒限制擋住。先在正常使用者 shell 中重跑驗證；若只有 Codex 沙盒內出現，使用 Codex 授權的外部執行環境驗證即可。

若要讓 Codex sandbox 內的 Firebase CLI 驗證不再出現這個 update check 權限警告，將 Firebase CLI 使用的本機 config store 加入 `{{CODEX_CONFIG}}` 的 `[sandbox_workspace_write].writable_roots`，修改後開新 Codex 對話或重啟：

```toml
"{{HOME}}/.config/configstore",
```

不要為了 Firebase CLI update check 放寬整個 home 目錄。

### 不安裝全域 CLI 的臨時用法

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
firebase --version
firebase login:list
firebase projects:list
npx -y firebase-tools@latest projects:list
npx -y firebase-tools@latest firestore:databases:list --project "{{FIREBASE_PROJECT_ID}}"
```

如果要測試寫入，使用專門的測試 collection，測完刪除。

## 設定範例

曾使用：

- Firebase Project ID：`codex-4e80b`
- Firestore location：`asia-east1`
- Firestore mode：Native

這只是設定範例，下載者要換成自己的 Firebase project。

## 踩坑修正

- 全域安裝可用 `npm install -g firebase-tools`；若只想臨時使用，可改用 `npx -y firebase-tools@latest ...`。
- npm cache 權限錯誤可用 `--cache /private/tmp/npm-cache` 暫時避開。
- Homebrew npm 的全域目錄可能需要系統授權才能寫入，不要把這類權限錯誤誤判成 Firebase 帳號或 project 問題。
- 如果 Node.js 版本太新，安裝時可能出現 package engine warning；只要安裝與 `firebase --version` 驗證成功，先記錄警告即可。若後續 emulator 或 hosting 功能異常，再切到 Firebase CLI 支援的 Node LTS 版本。
- Firebase Project ID 不能改名；若只是顯示名稱要改，通常要到 Firebase / Google Cloud Console。
- 本地資料夾改名後，要同步檢查 `.firebaserc`、Codex MCP 工作目錄與部署文件。
- `gcloud` 不一定已安裝，不能假設可用它改 Firebase display name。
- `firebase-tools update check failed` 不一定是 Firebase 專案錯；可能只是本機 config 權限問題。
- Firestore 測試資料測完要刪除，避免留下假資料。
- 不要把 service account key 或 Admin SDK 憑證寫進 repo。
