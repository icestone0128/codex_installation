# 02-連接 GitHub

## 目標

確認 Git、GitHub CLI、GitHub connector 與 GitHub Pages 能正常使用。

## 實測成功狀態

- Git 已安裝。
- GitHub CLI 已安裝。
- GitHub CLI 已登入 `icestone0128`。
- GitHub connector / plugin 已啟用。
- 曾成功建立測試 repo 並啟用 GitHub Pages。

## 檢查指令

```bash
git --version
gh auth status
git config --global user.name
git config --global user.email
```

建議 Git 全域設定：

```bash
git config --global user.name "icestone0128"
git config --global user.email "282601468+icestone0128@users.noreply.github.com"
```

## GitHub Pages 注意

- 如果要用 GitHub Pages，repo 通常要公開。
- 若只是私人備份，repo 預設 private。
- 建立 Pages 後要實際打開網址確認內容，不只看設定。

## 踩坑修正

- 本地專案若沒有 `git remote -v`，代表還沒有綁 GitHub repo；資料夾改名不會影響 GitHub。
- 先確認 local repo、remote、branch，再決定要不要 rename GitHub repo。
- Google Drive 內的 repo 若發生 ref 更新衝突，可考慮設定 `git config windows.appendAtomically false`，但 macOS 不一定需要。

