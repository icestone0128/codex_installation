# 00-連接 NotebookLM

## 目標

讓 Codex 能讀取 NotebookLM，並固定 NotebookLM 成品下載與整理路徑。

## 前置條件

- 已安裝 Codex App。
- 已有 Google 帳號並可使用 NotebookLM。
- 已決定 `{{NOTEBOOKLM_OUTPUT}}`，例如 `/Users/alex/Documents/NotebookLM`。
- 若使用 NotebookLM MCP，需已安裝對應 CLI，並確認可登入 Google 帳號。

## 建立輸出資料夾

建立主資料夾與成品分類：

```bash
mkdir -p "{{NOTEBOOKLM_OUTPUT}}"/{slides,infographics,audio,video,docs,sheets,mindmaps,quizzes}
```

用途：

- `slides`：簡報
- `infographics`：資訊圖表
- `audio`：音訊
- `video`：影片
- `docs`：文件
- `sheets`：試算表
- `mindmaps`：心智圖
- `quizzes`：測驗

## NotebookLM MCP 設定

先找出 NotebookLM MCP command 的實際位置：

```bash
command -v notebooklm-mcp
```

若找不到，代表尚未安裝或不在 PATH。不同安裝方式會得到不同路徑，請以你的電腦實際輸出為準。

在 `{{CODEX_CONFIG}}` 加入：

```toml
[mcp_servers.notebooklm]
command = "{{NOTEBOOKLM_MCP_COMMAND}}"
args = []
startup_timeout_sec = 30
tool_timeout_sec = 120
```

範例：

```toml
[mcp_servers.notebooklm]
command = "/Users/alex/.local/bin/notebooklm-mcp"
args = []
startup_timeout_sec = 30
tool_timeout_sec = 120
```

## 驗證

1. 重啟 Codex App 或開新對話。
2. 請 Codex 檢查 NotebookLM 工具是否可用。
3. 測試列出 notebooks 或讀取一個測試 notebook。
4. 下載任何 NotebookLM 成品後，放入 `{{NOTEBOOKLM_OUTPUT}}` 對應子資料夾。

## 本機實測例

曾成功使用：

```toml
[mcp_servers.notebooklm]
command = "/Users/arrywu/.local/bin/notebooklm-mcp"
args = []
startup_timeout_sec = 30
tool_timeout_sec = 120
```

這只是實測例，下載者不可直接照抄 `/Users/arrywu/...`。

## 踩坑修正

- MCP 設定改完後，工具不一定立刻出現，通常要重啟 Codex。
- 不要假設 `nlm mcp` 一定能當 Codex MCP command；以 `command -v notebooklm-mcp` 或實際可執行檔為準。
- 如果 NotebookLM 工具未載入，先檢查 `command` 是否是完整絕對路徑。
- Google 帳號登入狀態會影響 NotebookLM 讀取；必要時重新登入 MCP 或 Google connector。
