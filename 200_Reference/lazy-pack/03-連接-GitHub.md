# 03-連接-GitHub

## 目標

確認 Git、GitHub CLI、GitHub connector 與 GitHub Pages 能正常使用。

## 前置條件

- 已有 GitHub 帳號：`{{GITHUB_USER}}`。
- 已安裝 Git。
- 已安裝 GitHub CLI `gh`。
- Codex App 已啟用 GitHub plugin / connector。

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
```

建議使用 GitHub noreply email，避免暴露個人信箱。

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
