# Codex 全域 Skills 跨裝置同步

> 版本：2026-05-21 Codex App 版
> 用途：把 Codex 全域 skills 搬到雲端同步資料夾，並讓 `{{CODEX_HOME}}/skills` 用 symlink 指回雲端實體資料夾。
> 成品：下載者可直接安裝 `cross-device-sync` skill，並依本文件把全域 skills 同步到 Google Drive / iCloud / Dropbox / OneDrive。

## 這份文件會做什麼

這份懶人包只處理 **Codex 全域 skills** 的跨裝置同步。

它會把：

```text
{{CODEX_HOME}}/skills
```

改成 symlink，指向你雲端資料夾裡的：

```text
{{SYNC_ROOT}}/skills
```

這樣新裝置只要登入同一個雲端帳號，再重建 symlink，就能讀到同一份全域 skills。

## 不會同步的東西

不要把整個 `{{CODEX_HOME}}` 丟進雲端同步。`{{CODEX_HOME}}` 裡通常會有：

- `auth.json`
- logs / sqlite / sessions
- cache / tmp
- shell snapshots
- 本機狀態與登入資訊

這些跨裝置同步容易壞，也有隱私風險。本文件只同步 `skills/`。

## 先填變數

依你的環境替換：

| 變數 | 說明 | 範例 |
|---|---|---|
| `{{CODEX_HOME}}` | Codex 設定資料夾 | `/Users/alex/.codex` |
| `{{SETUP_REPO}}` | 這份懶人包所在專案 | `/Users/alex/Projects/codex_installation` |
| `{{SYNC_ROOT}}` | 雲端同步母資料夾 | `/Users/alex/Library/CloudStorage/GoogleDrive-alex@example.com/My Drive/codex_symlink` |
| `{{BACKUP_ROOT}}` | 本機備份位置 | `/Users/alex` |

本機實測值：

```text
{{CODEX_HOME}} = /Users/arrywu/.codex
{{SYNC_ROOT}} = /Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_symlink
```

下載者不要直接照抄本機實測路徑。

## Step 1：安裝 cross-device-sync skill

先把本懶人包附的 skill 複製到 Codex 全域 skills。

```bash
mkdir -p "{{CODEX_HOME}}/skills/cross-device-sync"
rsync -a --delete "{{SETUP_REPO}}/lazy-pack/skills/cross-device-sync/" "{{CODEX_HOME}}/skills/cross-device-sync/"
test -f "{{CODEX_HOME}}/skills/cross-device-sync/SKILL.md" && echo "cross-device-sync installed"
```

安裝後建議開新 Codex 對話，再用「跨裝置同步」或「cross-device-sync」觸發。

## Step 2：確認目前 skills 不是 symlink

```bash
if [ -L "{{CODEX_HOME}}/skills" ]; then
  echo "目前已經是 symlink：$(readlink "{{CODEX_HOME}}/skills")"
else
  echo "目前是實體資料夾，可以繼續"
fi
```

如果已經是 symlink，先不要重跑後續步驟。請先確認它是不是已經指向你要的雲端資料夾。

## Step 3：確認雲端目標資料夾

```bash
mkdir -p "{{SYNC_ROOT}}"
ls -la "{{SYNC_ROOT}}"
```

如果 `{{SYNC_ROOT}}/skills` 已存在，先檢查裡面是不是你要保留的 skills。不要直接覆蓋。

```bash
if [ -e "{{SYNC_ROOT}}/skills" ]; then
  echo "目標已存在，請先檢查：{{SYNC_ROOT}}/skills"
  exit 1
fi
```

## Step 4：建立備份、複製、改 symlink

這一步會改動 `{{CODEX_HOME}}/skills`。請完整執行，不要拆開跳步。

```bash
set -e

SOURCE="{{CODEX_HOME}}/skills"
ROOT="{{SYNC_ROOT}}"
TARGET="$ROOT/skills"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="{{BACKUP_ROOT}}/codex-backup-$STAMP"
OLD="$SOURCE.before-symlink-$STAMP"

if [ ! -d "$SOURCE" ] || [ -L "$SOURCE" ]; then
  echo "SOURCE_NOT_REAL_DIR:$SOURCE"
  exit 1
fi

if [ -e "$TARGET" ]; then
  echo "TARGET_ALREADY_EXISTS:$TARGET"
  exit 1
fi

mkdir -p "$BACKUP" "$ROOT"
cp -a "$SOURCE" "$BACKUP/skills"
cp -a "$SOURCE" "$TARGET"
mv "$SOURCE" "$OLD"
ln -s "$TARGET" "$SOURCE"

echo "BACKUP=$BACKUP"
echo "OLD=$OLD"
echo "TARGET=$TARGET"
echo "LINK=$(readlink "$SOURCE")"
```

## Step 5：驗證

```bash
test -L "{{CODEX_HOME}}/skills" && echo "skills is symlink"
test -d "$(readlink "{{CODEX_HOME}}/skills")" && echo "target exists"
find "$(readlink "{{CODEX_HOME}}/skills")" -maxdepth 2 -name SKILL.md -not -path "*/.system/*" -print | wc -l
test -f "{{CODEX_HOME}}/skills/cross-device-sync/SKILL.md" && echo "cross-device-sync readable"
```

合理結果：

- `skills is symlink`
- `target exists`
- skill 數量大於 0
- `cross-device-sync readable`

注意：`find "{{CODEX_HOME}}/skills"` 在某些系統上不會跟進 symlink，所以檢查數量時要用 `readlink` 取得實體目標。

## Step 6：第二台電腦怎麼接

第二台電腦登入同一個雲端帳號，等 `{{SYNC_ROOT}}/skills` 同步完成後：

```bash
set -e

SOURCE="{{CODEX_HOME}}/skills"
TARGET="{{SYNC_ROOT}}/skills"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="{{BACKUP_ROOT}}/codex-backup-$STAMP"

if [ ! -d "$TARGET" ]; then
  echo "TARGET_MISSING:$TARGET"
  exit 1
fi

if [ -e "$SOURCE" ] && [ ! -L "$SOURCE" ]; then
  mkdir -p "$BACKUP"
  cp -a "$SOURCE" "$BACKUP/skills"
  mv "$SOURCE" "$SOURCE.before-symlink-$STAMP"
fi

if [ -L "$SOURCE" ]; then
  rm "$SOURCE"
fi

ln -s "$TARGET" "$SOURCE"
test -f "$SOURCE/cross-device-sync/SKILL.md" && echo "skills symlink ready"
```

每台電腦的 Codex App 仍需要各自登入，不要同步 `auth.json`。

## 回復方式

如果改完後 Codex 讀不到 skills，先找剛才輸出的：

```text
BACKUP=...
OLD=...
```

最安全的回復方式：

```bash
rm "{{CODEX_HOME}}/skills"
mv "{{CODEX_HOME}}/skills.before-symlink-YYYYMMDD-HHMMSS" "{{CODEX_HOME}}/skills"
```

如果 `before-symlink` 不在了，才使用 `{{BACKUP_ROOT}}/codex-backup-YYYYMMDD-HHMMSS/skills` 還原。

## 下載者安全規則

- 不要同步整個 `{{CODEX_HOME}}`。
- 不要同步 `auth.json`、token、`.env`、sqlite、logs、sessions、cache。
- 不要把私密 skills、個人記憶或草稿放進 public repo。
- 先備份，再 symlink。
- 改完後重開 Codex 新對話或重啟 Codex App。

## 本機實測紀錄

本機已完成：

```text
/Users/arrywu/.codex/skills
→ /Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_symlink/skills
```

保留備份：

```text
/Users/arrywu/codex-backup-20260521-081840/skills
/Users/arrywu/.codex/skills.before-symlink-20260521-081840
```

實測結果：Google Drive 目標內可讀到 16 個自訂 skill，`cross-device-sync` 可正常讀取。

## 最終檢查清單

- [ ] `{{CODEX_HOME}}/skills` 是 symlink。
- [ ] `readlink "{{CODEX_HOME}}/skills"` 指向 `{{SYNC_ROOT}}/skills`。
- [ ] `{{SYNC_ROOT}}/skills` 內有自訂 skills。
- [ ] `{{CODEX_HOME}}/skills/cross-device-sync/SKILL.md` 可讀。
- [ ] 本機備份資料夾存在。
- [ ] 未同步整個 `{{CODEX_HOME}}`。
- [ ] 未同步任何 token、憑證、`.env`、sqlite、logs、sessions。
- [ ] 開新 Codex 對話後，全域 skills 可觸發。
