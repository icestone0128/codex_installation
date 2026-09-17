# 03-連接-GitHub

## 目標

確認 Codex、Claude、AntiGravity 都可透過共用 Git／GitHub CLI 處理 repo，並分別驗證各 Agent 原生 GitHub connector／plugin／MCP 與 GitHub Pages 能力。

## 前置條件

- 已有 GitHub 帳號：`{{GITHUB_USER}}`。
- 已安裝 Git。
- 已安裝 GitHub CLI `gh`。
- 三 Agent 中已安裝者要分別檢查 GitHub connector／plugin／MCP；沒有原生通道時改用共用 `git`／`gh` CLI，該 Agent 仍保留完整工作能力。

## Agent Execution Notes

- 通用路線：`git`、`gh`、repo 內腳本與同一套 branch／commit／push 授權邊界。
- Codex：可使用 GitHub plugin／connector，但仍要用 `git status`、`git remote -v` 與 `gh` 驗證 live state。
- Claude：可使用當前版本的 GitHub connector／MCP；缺少或權限不足時回退到 `git`／`gh`。
- AntiGravity：可使用當前版本的 GitHub connector／MCP；缺少或權限不足時回退到 `git`／`gh`。
- 任一 Agent 執行 commit、push、repo create、Pages 設定前，都遵守同一使用者授權與 secret 掃描契約。

## 安裝檢查

```bash
git --version
gh --version
gh auth status
git config --global user.name
git config --global user.email
```

若尚未登入：

```bash
gh auth login
```

## Git 全域設定

設定為自己的 GitHub 身分：

```bash
git config --global user.name "{{GITHUB_USER}}"
git config --global user.email "{{GITHUB_EMAIL}}"
git config --global core.quotepath off
```

建議使用 GitHub noreply email，避免暴露個人信箱。

`core.quotepath off` 讓 `git status`、`git log --name-only` 直接顯示中文檔名，不會變成 `\346\210\221` 這類跳脫碼，Agent 比對檔名與路徑時也不會誤判。

另外，commit 或 push 前固定做三項檢查（全域規則〈commit 與 push 的現行處理〉有完整版）：

```bash
gh repo view --json nameWithOwner,visibility -q '.nameWithOwner+" "+.visibility'   # 確認擁有者與公開／私人
git diff --cached --name-status                                                     # 只 add 指定檔案，不用 git add -A／git add .
git diff --cached --name-only -z | xargs -0 -I{} find {} -maxdepth 0 -type f -size +50M   # 有輸出就停，大檔不進 GitHub
```

## 清除 Git 歷史中不想公開的字樣（選用）

適用情境：repo 的舊 commit 或 commit 訊息裡留有不該公開的字樣，例如外部教材出處、內部專案代號。只改目前檔案不夠，任何人都能翻歷史看到。

先問使用者一個決定：

1. **要清除 Git 歷史嗎？**
   - 只改目前檔案，保留歷史（預設、最安全）：一般瀏覽 repo 看不到，但翻歷史仍查得到。
   - 改寫歷史並強制推送：所有 commit 的 SHA 都會改變；別人的 clone、fork 或已用完整 SHA 存下的連結可能仍留有舊內容，要徹底清除需另外聯絡 GitHub Support。

選擇改寫時，用 Item 16 內嵌的 `cross-device-sync/scripts/prepare-history-scrub.sh`。它只在暫存副本改寫並驗證，**不會推送**：

```bash
# 替換清單放在 repo 以外；一行一條「perl regex<TAB>替換文字」，較具體的規則放前面
printf 'OldSourceName Kit\t外部教材\nOldSourceName\t外部教材\n' > "$HOME/scrub-rules.tsv"

bash "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/prepare-history-scrub.sh" \
  --repo-url "https://github.com/{{GITHUB_USER}}/{{REPO_NAME}}.git" \
  --rules "$HOME/scrub-rules.tsv" \
  --workdir "$HOME/history-scrub-work"
```

腳本會自動驗證：commit 數不變、commit 訊息與每個版本內容的殘留都是 0；若最新版本本來就沒有這些字樣，最新檔案樹必須和改寫前完全相同。只檢查目標分支，`refs/original` 裡的改寫前備份不算。二進位檔不會修改。

驗證通過後才做以下兩步。這兩步不可逆，由 repo 擁有者本人執行，Agent 不代為執行：

1. 用腳本印出的指令，從改寫後的副本強制推送。
2. 每個既有 clone 在沒有未提交修改的前提下，先 `git fetch origin`，再 `git reset --hard origin/main` 對齊。

推送前先確認沒有分支保護、fork 或 PR 會留住舊歷史：

```bash
gh api "repos/{{GITHUB_USER}}/{{REPO_NAME}}" --jq '{forks_count,visibility,default_branch}'
gh pr list -R "{{GITHUB_USER}}/{{REPO_NAME}}" --state all --limit 5
```

若本機 `git fetch` 出現 `cannot lock ref ... expected <舊 SHA>`，通常是遠端參考已經被另一個 fetch 更新；確認 `git rev-parse origin/main` 與 `git ls-remote origin refs/heads/main` 一致即可，不必重跑。

## 建立或連接 Repo

在專案資料夾內檢查：

```bash
git status
git remote -v
```

若尚未建立 Git：

```bash
git init
git branch -M main
```

若要建立 GitHub repo：

```bash
gh repo create "{{GITHUB_USER}}/{{REPO_NAME}}" --private --source=. --remote=origin
```

若要公開並使用 GitHub Pages：

```bash
gh repo create "{{GITHUB_USER}}/{{REPO_NAME}}" --public --source=. --remote=origin
```

## GitHub Pages 注意

- 如果要用 GitHub Pages，repo 通常要 public，或帳號方案需支援 private Pages。
- Pages source 要明確決定。若遵守標準專案結構，靜態網站工作來源放 `200_Reference/docs/`，再同步發布到獨立 `gh-pages` 分支根目錄；不要在 main 根目錄保留 `docs/`。
- 建立 Pages 後要實際打開網址確認內容，不只看設定。
- 若網站入口在 `200_Reference/docs/index.html`，可將該資料夾內容同步到 `gh-pages` 分支，Pages source 設為 `gh-pages` / `/`。

## 驗證

```bash
git status --short --branch
git remote -v
gh repo view "{{GITHUB_USER}}/{{REPO_NAME}}"
```

若使用 Pages，再確認：

```bash
gh api "repos/{{GITHUB_USER}}/{{REPO_NAME}}/pages"
curl -I "https://{{GITHUB_USER}}.github.io/{{REPO_NAME}}/"
```

## 設定範例

曾在本機使用：

- GitHub user：`{{GITHUB_USER}}`
- GitHub Pages source：`gh-pages` branch `/`
- 本地網站工作來源：`200_Reference/docs/`

這只是實測值，下載者必須改成自己的 GitHub 帳號與 repo。

## 踩坑修正

- 本地專案若沒有 `git remote -v`，代表還沒有綁 GitHub repo；資料夾改名不會自動改 GitHub repo。
- 先確認 local repo、remote、branch，再決定要不要 rename GitHub repo。
- Google Drive 內的 repo 偶爾可能遇到檔案同步與 Git 操作衝突；重要專案可考慮放在一般本機工作資料夾，再用 Obsidian 記錄進度。
- 不要把 `.env`、金鑰或 token commit 進 repo。
