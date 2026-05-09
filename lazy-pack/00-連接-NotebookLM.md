# 00-連接 NotebookLM

## 目標

讓 Codex 能透過 NotebookLM MCP 讀取 NotebookLM，並固定 NotebookLM 成品下載與整理路徑。

## 實測成功設定

NotebookLM MCP command 使用：

```toml
[mcp_servers.notebooklm]
command = "/Users/arrywu/.local/bin/notebooklm-mcp"
args = []
startup_timeout_sec = 30
tool_timeout_sec = 120
```

實測注意：不要使用 `nlm mcp` 當作 Codex MCP command；本機成功載入的是 `/Users/arrywu/.local/bin/notebooklm-mcp`。

## 檢查步驟

1. 確認 NotebookLM MCP CLI 已安裝。
2. 確認已登入 Google 帳號。
3. 在 Codex 設定檔加入 NotebookLM MCP。
4. 重啟 Codex App 或重新開啟對話。
5. 測試能列出 NotebookLM notebooks。

## 預設輸出資料夾

主要輸出資料夾：

`/Users/arrywu/Documents/NotebookLM`

子資料夾：

- `slides`
- `infographics`
- `audio`
- `video`
- `docs`
- `sheets`
- `mindmaps`
- `quizzes`

## 踩坑修正

- MCP 設定改完後，工具不一定立刻出現，通常要重啟 Codex。
- 如果 NotebookLM 工具未載入，先檢查 `command` 是否是完整絕對路徑。
- 若日後下載 NotebookLM 成品，先放進 `/Users/arrywu/Documents/NotebookLM`，再依類型整理到子資料夾。

