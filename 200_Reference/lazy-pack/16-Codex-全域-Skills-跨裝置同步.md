# 16-Codex-全域-Skills-跨裝置同步

> 2026-07-21 更新：chezmoi 維持必要安裝；除三 Agent 規則／skills 入口外，新增三 Agent 共用 Python-tools 中立 bridge、env loader、保留既有內容的 shell profile modifier，以及開工／收工 checkpoint。請使用文末自含式 Skill 安裝內容。


> 版本：2026-07-21 Cross-Agent Shared Runtime Bridge 版
> 用途：用「雲端內容主版本 + chezmoi 原生入口 + 每機重建的本機 runtime」讓 Codex、Claude、AntiGravity 在新電腦或既有電腦共用專案、全域規則、skills 與 Python wrapper 指令。
> 成品：下載者可安裝 `cross-device-sync`，再用內建 `bootstrap-agent-sync.sh` 安裝 chezmoi、預覽、備份、建立 Agent 入口與 Python bridge，並驗證 fresh shell。

## 這份文件會做什麼

這份懶人包處理 **電腦與 Agent 的全域 bootstrap**。它不取代 Item 10 的專案初始化流程，也不把專案本地 `000_Agent/skills` 混進全域 skills。

共享內容主版本是：

```text
{{SYNC_ROOT}}/core-rules.md
{{SYNC_ROOT}}/skills
{{SYNC_ROOT}}/memories
```

chezmoi 負責在每台電腦建立原生入口：

```text
Codex:       {{CODEX_HOME}}/AGENTS.md, {{CODEX_HOME}}/skills, {{CODEX_HOME}}/memories
Claude:      {{CLAUDE_HOME}}/CLAUDE.md, {{CLAUDE_HOME}}/skills
AntiGravity: {{GEMINI_HOME}}/GEMINI.md, {{GEMINI_HOME}}/config/skills
```

三個 Agent 共用的本機 Python 指令入口是：

```text
Runtime（每台電腦重建）：{{CODEX_HOME}}/python-tools
中立 bridge：{{HOME}}/.local/share/agent-tools/python-tools
env loader：{{HOME}}/.config/agent-tools/python-tools.env（載入 zsh／bash profiles）
```

bridge 讓三個 Agent 都從同一個 `bin` 呼叫相同 wrapper，但不把 venv 收進 chezmoi 或雲端。Runtime 由 Item 34 安裝；Item 12／18／32／33／35／37 可把選用 wrapper 補到同一個 `bin`。

這樣新裝置先同步 `{{SYNC_ROOT}}`，再跑同一支 bootstrap，就能重建入口。Claude 或 AntiGravity 尚未安裝也可以先建立入口；Agent 本體與登入仍各自安裝、各自登入。

若你也要讓 Codex 與其他 AI agent 共用同一份全域規則，主檔固定放：

```text
{{SYNC_ROOT}}/core-rules.md
```

不要再建立或維護 `{{SYNC_ROOT}}/agents/AGENTS.md`。`core-rules.md` 與 `skills/` 都只有一個內容主版本；各 Agent home 只有入口。

路徑邊界：

- `{{CODEX_HOME}}/skills`：Codex 全域 skills 入口。
- `{{CLAUDE_HOME}}/skills`：Claude skills 入口；`{{CLAUDE_HOME}}/CLAUDE.md` 是全域規則入口。
- `{{GEMINI_HOME}}/config/skills`：AntiGravity 正式 skills 入口；`{{GEMINI_HOME}}/GEMINI.md` 是正式全域規則入口。
- `{{GEMINI_HOME}}/config/AGENTS.md` 與 `{{GEMINI_HOME}}/config/plugins/codex/skills`：既有環境的相容別名，不是新主路徑。
- `{{SYNC_ROOT}}/core-rules.md`：可攜式全域核心規則主檔；其他 AI agent 也應讀這一份。
- `{{CHEZMOI_SOURCE}}`：只保存可攜式 symlink templates、Python env loader 與 shell profile modifier；機器實際 `syncRoot`、`pythonToolsHome` 放在 chezmoi local config。
- `{{HOME}}/.local/share/agent-tools/python-tools`：三 Agent 中立 Python 入口；指向該機器的 `{{CODEX_HOME}}/python-tools`，不指向雲端 venv。
- `{{HOME}}/.config/agent-tools/python-tools.env`：把中立入口的 `bin` 加入 PATH；`.zshenv`、`.zprofile`、`.profile`、`.bash_profile` 只由 `modify_` scripts 管理標記區塊，不覆蓋其他內容。
- `{{SYNC_ROOT}}/memories`、`{{SYNC_ROOT}}/workflows`、`{{SYNC_ROOT}}/knowledge`：個人助手全域資料層；不 symlink 到 `{{CODEX_HOME}}/skills`。
- `<project-root>/000_Agent/skills`：單一專案本地 skill；不 symlink 到 `{{CODEX_HOME}}/skills`。

## 必裝需求與責任分工

| 項目 | 是否必要 | 負責內容 |
|---|---:|---|
| 雲端同步工具 | 必要 | 同步 `{{SYNC_ROOT}}` 的實體內容 |
| chezmoi | **必要** | 新電腦 bootstrap、入口重建、衝突預覽與修復 |
| Git | chezmoi source 選配 | 只有使用者要版本備份時才 commit／remote／push |
| Codex / Claude / AntiGravity 本體 | 按需安裝 | 各自執行與登入；未安裝者仍可先準備入口 |
| Item 34 | 共用 Python 工具時必要 | 在每台電腦重建 runtime；不跨電腦同步 venv |
| Item 10 | 新專案必要 | `AGENTS.md`、薄 `CLAUDE.md`、`HANDOFF.md` 與開工／收工生命週期 |

chezmoi 不取代 symlink：symlink 是 Agent 每次讀取共享內容的即時入口；chezmoi 是在每台電腦安全、可重跑地建立這些 symlink 的管理器。

## Agent CLI 按需安裝

先建立 Item 16 的共享入口，再逐機安裝 Agent 本體；兩者互不取代。每台新電腦先確認必要 runtime：

```bash
git --version
node --version
npm --version
```

Gemini CLI 需要 Node.js 20 以上。macOS 已有 Homebrew 與 Node.js 時，2026-07-21 實測的穩定安裝路徑為：

```bash
# Claude Code：Homebrew stable cask
brew install --cask claude-code

# Gemini CLI：Google 官方 npm stable package
npm install -g @google/gemini-cli@latest
```

Claude Code 官方也提供 macOS、Linux 與 WSL 的原生安裝器；非 Homebrew 環境可依官方當期文件使用：

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

安裝後先做不需模型呼叫的驗證：

```bash
command -v claude
claude --version
claude doctor

command -v gemini
gemini --version
gemini --help
```

登入是另一個本機步驟。執行前先確認要使用的帳號與訂閱／配額；OAuth 會開啟瀏覽器，憑證不可寫入 LazyPack、專案、Obsidian 或 chezmoi source：

```bash
claude auth login
gemini
```

Claude 可用 `claude auth status` 做只讀狀態檢查。Gemini 第一次執行時選擇 Google Login、Gemini API key 或 Vertex AI；個人使用預設採 Google Login。更新時沿用原安裝管道：Homebrew Claude 執行 `brew upgrade --cask claude-code`，npm Gemini 執行 `npm install -g @google/gemini-cli@latest`。

## 多 Agent 相容性健檢

如果你未來可能使用其他 AI agent，本項也提供「多 Agent 相容性健檢」流程。這不是要建立另一套 agent 專用設定，而是檢查哪些資產可以被其他 agent 安全讀取、哪些必須轉換、哪些不應同步。

健檢重點：

- `{{SYNC_ROOT}}/core-rules.md` 是否仍是唯一全域核心規則主檔。
- 三個 Agent 的原生規則入口是否都指向同一份 `core-rules.md`。
- `{{SYNC_ROOT}}/skills`、`memories`、`workflows`、`knowledge` 是否保持可攜式 Markdown / package 結構。
- MCP、plugin、hooks、commands、subtask / delegation 設定是否只做格式轉換，不直接共用不相容設定檔。
- session、logs、auth、cache、token、shell snapshot 是否明確排除。
- Python bridge 是否指向該機器的 runtime、fresh shell 是否找到 `python-tools-python`，且三個 Agent 沒有各自複製 venv。

bootstrap 預設 dry-run；只有加 `--apply` 才修改入口。詳細檢查表已內嵌在 `cross-device-sync/references/multi-agent-compatibility.md`；跨 Agent 全域設定規格放在 `cross-device-sync/references/global-settings-spec.md`。

## 不會同步的東西

不要把整個 `{{CODEX_HOME}}` 丟進雲端同步。`{{CODEX_HOME}}` 裡通常會有：

- `auth.json`
- `sessions/` / `log/` / `*.sqlite*` / `config.local.toml`
- cache / tmp
- shell snapshots
- 本機狀態與登入資訊
- Python venv、compiled wheels、模型與大型 runtime cache

這些跨裝置同步容易壞，也有隱私風險。本文件只讓 Agent 入口連到共享內容；登入與執行狀態全部留在本機。

## 先填變數

依你的環境替換：

| 變數 | 說明 | 範例 |
|---|---|---|
| `{{CODEX_HOME}}` | Codex 設定資料夾 | `{{CODEX_HOME}}` |
| `{{CLAUDE_HOME}}` | Claude 設定資料夾 | `{{HOME}}` 底下的 Claude 設定位置 |
| `{{GEMINI_HOME}}` | AntiGravity / Gemini 家目錄 | `{{HOME}}` 底下的 Gemini 設定位置 |
| `{{CHEZMOI_SOURCE}}` | chezmoi source state | `{{HOME}}` 底下的 chezmoi 預設 source 位置 |
| `{{SETUP_REPO}}` | 這份懶人包所在專案 | `{{SETUP_REPO}}` |
| `{{SYNC_ROOT}}` | 雲端同步母資料夾 | 你的雲端同步資料夾中的 `codex_symlink` |
| `{{GLOBAL_RULES}}` | 可攜式全域核心規則主檔 | `{{SYNC_ROOT}}/core-rules.md` |
| `{{BACKUP_ROOT}}` | 本機備份位置 | `{{HOME}}` |
| `{{PYTHON_TOOLS_HOME}}` | 每台機器的本機 Python tools runtime | `{{CODEX_HOME}}/python-tools` |
| `{{SECRETS_DIR}}` | 本機 secrets 資料夾 | `{{CODEX_HOME}}/secrets` |
| `{{LOCAL_BIN}}` | 使用者本機 CLI wrapper 資料夾 | 你的本機 bin 資料夾 |
| `{{OBSIDIAN_VAULT}}` | Obsidian vault | 你的 Obsidian vault |
| `{{LOCAL_FILE_PATH}}` | 使用者貼上的單一檔案或資料夾路徑 | 只作為 placeholder |

請先把上表變數替換成自己的實際路徑；不要直接複製其他人的本機路徑。

## LazyPack 公開打包與 placeholder 規則

當你把全域 skill、跨 Agent 規則、安裝腳本或工具設定打包成 LazyPack 時，公開內容必須保持可攜式：

- 不展示作者本機實體安裝目錄、雲端帳號掛載路徑、Obsidian vault 真實路徑、工具家目錄或 email 字串。
- Markdown、README、templates、內嵌 shell / Python installer 都使用 `{{...}}` placeholder。
- 可執行腳本可以在本機 runtime 計算實際路徑，但一般輸出不列印完整路徑；只顯示 placeholder 或「已設定」狀態。
- 新增 placeholder 時，同步更新 LazyPack README 的設定表。
- 完成前掃描公開範圍，確認沒有實體路徑、帳號字串、literal tilde-style config home 或 absolute user-home 範例殘留。

## Step 1：安裝 cross-device-sync skill

先把本懶人包附的 skill 複製到 Codex 全域 skills。

```bash
mkdir -p "{{SYNC_ROOT}}/skills/cross-device-sync"
# 請使用本文文末「內建 Skill 完整安裝內容」；不需要額外複製舊版獨立 skills 子目錄。
test -f "{{SYNC_ROOT}}/skills/cross-device-sync/SKILL.md" && echo "cross-device-sync installed"
```

安裝後先不要手動搬資料夾。使用內建 installer：

```bash
SCRIPT="{{SYNC_ROOT}}/skills/cross-device-sync/scripts/bootstrap-agent-sync.sh"

# 只預覽；不安裝、不改入口
bash "$SCRIPT" \
  --sync-root "{{SYNC_ROOT}}" \
  --agents codex,claude,antigravity

# 確認預覽與備份位置後，必要時安裝 chezmoi 並套用
bash "$SCRIPT" \
  --sync-root "{{SYNC_ROOT}}" \
  --agents codex,claude,antigravity \
  --install-chezmoi \
  --apply
```

腳本支援 macOS Homebrew、Linux Homebrew／官方 installer、Windows 原生 winget。它會驗證 `{{SYNC_ROOT}}`、備份既有入口／Python bridge／env loader／shell profiles、拒絕不明實體檔或錯誤 symlink、初始化 chezmoi、寫入 machine-local `syncRoot` 與 `pythonToolsHome`、apply，並驗證 fresh shell。若 Item 34 尚未安裝，bridge 可先建立並明確回報 pending。

完成後：

```bash
chezmoi status
chezmoi doctor
```

`chezmoi status` 應為空。`chezmoi doctor` 若只警告 source Git repo 尚未 commit，代表功能可用；是否建立 remote、commit 或 push 仍由使用者決定。

## 建立 private remote 與新電腦從 remote 重建（選配）

沒有 remote 時 chezmoi 仍可在本機正常運作，只是開工 checkpoint 的 `chezmoi update` 會固定回報 `CHEZMOI_UPDATE=skipped:no-remote`，新電腦也只能靠手動搬 source。要讓新電腦真的能一行拉回三 Agent 入口，才需要這一步。

**先做安全掃描，再建 remote。** source 只應包含 symlink templates、`modify_` scripts 與 env loader，不應出現任何真實憑證：

```bash
cd "$(chezmoi source-path)"
git ls-files
grep -rInE "(sk-|gho_|ghp_|github_pat|AIza|xoxb-|BEGIN [A-Z ]*PRIVATE KEY)" . --exclude-dir=.git
```

`git ls-files` 應只列出受管理入口 templates；grep 應無命中。`.chezmoi.toml.tmpl` 若使用 `promptStringOnce`，`syncRoot` 與 `pythonToolsHome` 只會寫進每台機器的 local config，不會進 source，因此 source 內不該出現任何絕對路徑或帳號字串。

**remote 一律建 private。** 目前內容雖然不含 secret，但 dotfiles source 日後很容易被加入個人設定；private 讓後續擴充不必每次重新評估外洩風險。

```bash
cd "$(chezmoi source-path)"
gh repo create <YOUR_DOTFILES_REPO> --private --source=. --remote=origin --push
```

驗證：

```bash
gh repo view <OWNER>/<YOUR_DOTFILES_REPO> --json visibility,defaultBranchRef
git -C "$(chezmoi source-path)" status -sb
```

`visibility` 應為 `PRIVATE`，且本地 branch 已 tracking `origin/main`。之後重跑開工 checkpoint，`CHEZMOI_UPDATE` 應從 `skipped:no-remote` 變成 `running` → `complete`。

**新電腦從 remote 重建：**

```bash
chezmoi init --apply https://github.com/<OWNER>/<YOUR_DOTFILES_REPO>.git
```

會提示輸入該機器的 `syncRoot`（雲端硬碟內的 `codex_symlink` 路徑）與 `pythonToolsHome`。這一步只重建三 Agent 入口 symlink、Python bridge 與 shell profile 標記區塊；Python runtime 本身仍必須用 Item 34 在該機器重建，不從 remote 拉取 venv、模型或 cache。

不要把 API key、OAuth token、session、MCP 認證或 Agent 設定資料庫加進這個 repo，即使它是 private。

## 危險指令防護層（跨機器可攜）

三個 Agent 的攔截設定檔（`~/.claude/settings.json`、`~/.codex/rules/default.rules`、
`~/.gemini/config/config.json`）**刻意不納入 chezmoi**：它們合計含 75 處本機絕對路徑，
其中 AntiGravity 的 `config.json` 還會被 app 主動重寫（納管會與 app 互相覆寫）。
直接同步會讓新電腦拿到指向不存在路徑的設定，比不同步更糟。

可攜的是**規則本身**：

```text
{{SYNC_ROOT}}/skills/cross-device-sync/assets/agent-guardrails.json
```

零本機絕對路徑，記錄 17 條 `forbidden`、2 條 `ask`，以及刻意排除項與已知洞的理由。
新電腦用套用腳本重建：

```bash
# 預設唯讀，只回報差異
python3 "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/apply-agent-guardrails.py" \
  --sync-root "{{SYNC_ROOT}}"

# 確認後才寫入，會自動備份到 {{SYNC_ROOT}}/backups/
python3 "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/apply-agent-guardrails.py" \
  --sync-root "{{SYNC_ROOT}}" --apply
```

各 Agent 的套用方式不同，腳本會自行處理：

| Agent | 機制 | 格式 |
| :-- | :-- | :-- |
| Claude Code | `permissions.deny` / `permissions.ask` | `"Bash(sudo:*)"` |
| Codex | `rules/default.rules` 的 `arry-dangerous-rules` 區塊 | `prefix_rule(..., decision="forbidden"\|"prompt")`。**值是 `forbidden` 不是 `deny`** |
| AntiGravity | **無此機制**，腳本明確略過 | 改走 sandbox 與判斷層驗證，見 `antigravity_installation` 的懶人包 |

驗證：

```bash
# Codex
codex execpolicy check --pretty --rules ~/.codex/rules/default.rules -- sudo ls   # 應為 forbidden
codex execpolicy check --pretty --rules ~/.codex/rules/default.rules -- git status # 應未命中或 allow

# Claude Code：在拋棄式目錄實際執行，被擋會回 permission denied
```

> [!IMPORTANT]
> **`rm -rf` 刻意未納入。** 11 個安裝腳本正當使用它清理自己的 `$temp_dir`／`$STAGING_DIR`／`venv`，
> 無差別攔截會弄壞安裝流程。排除理由記在主版本的 `excluded` 欄位。

> [!NOTE]
> **權限模式（sandbox／approval）是個人選擇，本節不強制。** 攔截規則在任何權限模式下都生效；
> 要不要讓一般指令也跳確認（Codex `approval_policy`、Claude 的權限模式、AntiGravity
> `autoExecutionPolicy`），依自己的工作節奏在各 Agent 設定中調整。

> [!WARNING]
> **修改規則時三個 Agent 必須一起改並雙向實測。** 單邊修改已造成過三次不一致
> （Claude 漏 `git clean -fd` 與 `--force-with-lease`、Codex 誤擋 `chmod -R 755`、
> Claude 漏 `ask`）。已知洞：`git push origin main --force` 因前綴比對限制兩邊都擋不到。

## 開工／收工自動 checkpoint

Item 10 的 `startup-sync` 與 `shutdown-sync` 固定呼叫同一支腳本；Codex、Claude、AntiGravity 都使用相同命令：

```bash
CHECKPOINT="{{SYNC_ROOT}}/skills/cross-device-sync/scripts/session-sync-checkpoint.sh"

# 開工：檢查入口，並在安全條件齊備時 update
bash "$CHECKPOINT" --phase startup --sync-root "{{SYNC_ROOT}}" --update

# 收工：檢查入口與 source 狀態，不自動套用遠端變更
bash "$CHECKPOINT" --phase shutdown --sync-root "{{SYNC_ROOT}}"
```

checkpoint 固定先執行 bootstrap dry-run 與 `chezmoi status`。開工加 `--update` 時，只有下列條件全部成立才會備份所有受管理 Agent 入口、Python bridge、env loader 與 shell profiles 後執行 `chezmoi update`：

- chezmoi source 是 Git repo 且已有至少一個 commit。
- source worktree 乾淨。
- source 已設定 remote。

條件不足時是安全 no-op，腳本只回報 `CHEZMOI_UPDATE=skipped:<reason>`，不開 TTY、不覆寫現有入口。

`chezmoi add` 不是日常開工／收工動作。既有規則／skills 入口、Python bridge、env loader 與 shell modifier 已是受管理 templates；直接重新 add 可能移除 template 屬性，headless shell 還會因嘗試開 `/dev/tty` 失敗。只在新增白名單入口時，才先擴充 `bootstrap-agent-sync.sh` 的可攜 template、備份與 dry-run，再用受控 `chezmoi add` 檢視 diff。


checkpoint 每次結束都會輸出防護規則的比對結果：

```text
GUARDRAILS CLAUDE drift: none CODEX block: present
```

`drift` 非 `none` 或 `block` 顯示 `MISSING` 時，表示某一邊被單獨改過，重跑套用腳本即可對齊。

## 收工保留期清理（session artifacts retention）

收工 checkpoint 會順手清掉超過保留期的過程檔，預設保留 **7 天**。清理範圍是寫死的白名單，腳本不接受任意目錄：

| 對象 | 規則 |
| :-- | :-- |
| `{{SYNC_ROOT}}/backups/*` | 超過保留期就刪 |
| `~/agent-sync-backup-*`（chezmoi checkpoint 備份） | 超過保留期就刪 |
| `__pycache__` | 一律刪（下次執行自動重生） |
| `.DS_Store` | 一律刪（Finder metadata） |
| 執行中 Agent 的沙盒 | 超過保留期就刪，**只清當前這一個 Agent** |

### 為什麼只清當前 Agent

三個 Agent 各自有自己的暫存狀態。刪掉另一個 Agent 的狀態時，那個 Agent 可能正在跑，
會弄壞進行中的 session。所以 `--agent auto`（預設）只清偵測到正在執行的那一個；
`--agent all` 存在但必須明確指定。當前 session 的檔案一律跳過，不看年齡。

偵測依據：`CLAUDECODE`／`CLAUDE_CODE_SESSION_ID` → Claude，`CODEX_HOME` 或 `AI_AGENT` 含 codex →
Codex，`AI_AGENT` 含 antigravity／gemini → AntiGravity。判斷不出來就不清任何沙盒。

### 各 Agent 的白名單

只清可重生的暫存狀態，其餘一律不碰：

| Agent | 會清 |
| :-- | :-- |
| Claude `~/.claude` | `backups/.claude.json.backup.*`、`shell-snapshots/`、`session-env/`、`telemetry/`、`tasks/`、`sessions/` |
| Codex `~/.codex` | `.codex-global-state.json.bak`、`.tmp/`、`ambient-suggestions/`、`config.toml.bak*` |
| AntiGravity `~/.gemini/antigravity` | `brain/`（當前 conversation 除外） |

**明確排除，因為裡面是成品或耐久資料**：

- `~/.codex/generated_images`、`audio-to-md`、`doc-to-md`、`vlm-to-md`、`attachments`、
  `dictation-history` —— 這些是產出，不是暫存
- `~/.codex/sessions` 與 `archived_sessions` —— `memories/` 的 rollout summaries 用 id 引用這些逐字稿。
  2026-08-27 實測確認 `MEMORY.md` 引用的一份逐字稿現在就在 `archived_sessions/`。
  要清必須明確加 `--include-codex-archives`（可釋出約 2.4G，但會斷開記憶的稽核軌跡）
- `~/.claude/projects` —— 逐字稿與助手記憶目錄
- 任何 runtime、模型、快取、憑證、設定與 symlink

白名單有自動檢查：實測三個 Agent 的 glob 觸及的頂層項目與 28 個受保護項目零交集。

```bash
# 只清當前執行中的 Agent（預設）
python3 "$PRUNE" --sync-root "{{SYNC_ROOT}}" --apply

# 指定某一個；或完全不碰沙盒
python3 "$PRUNE" --sync-root "{{SYNC_ROOT}}" --agent codex --apply
python3 "$PRUNE" --sync-root "{{SYNC_ROOT}}" --agent none --apply

# 連 Codex 逐字稿封存一起清（會斷開 memories 的引用）
python3 "$PRUNE" --sync-root "{{SYNC_ROOT}}" --agent codex --include-codex-archives --apply
```

`skills/`、`memories/`、`knowledge/`、`100_Todo/` 與任何 git 工作樹都不在範圍內。目錄年齡取「內部最新的 mtime」，所以最近被動過的備份不會因為建立日期舊而被誤刪。

### 孤兒媒體：提出決策，不代為處置

2026-08-26 發現一個名為 `cleanup` 的備份裡，存著 49 張生成圖的**唯一副本**——當初「清理」把成品移出 live 位置後沒有放回去，備份事實上變成正本。照字面清備份就會永久損失。

因此刪除 `backups/` 內任何項目之前，腳本會先建立 live 媒體索引，把備份裡的每個媒體檔拿去比對。**同名且同大小**在備份區以外存在，才算有副本。

比不到副本的項目，腳本**不會替你決定**——不刪，也不會就這樣永遠擋著變成堆積，而是列為待決策，等一個明確的答覆：

| 答覆方式 | 意思 |
| :-- | :-- |
| `--interactive` | 逐一詢問，一次問一個（直接按 Enter 是保留） |
| `--approve-delete NAME` | 不用互動，直接同意刪除指定的那一個 |
| `--keep-orphans` | 本次全部保留 |
| `--allow-orphan-media` | 本次全部刪除 |

沒有答覆時就報 `PENDING` 並原地保留，所以無人看顧的收工掃描既不會偷刪、也不會擅自替你結案。

收工 checkpoint 的輸出會直接把待決策項目推到你面前：

```text
PRUNE PRUNED=0 FREED=0B KEPT=4 PENDING=1
  ORPHAN-MEDIA  backups/_t  (26.2d, 2.9K)
PRUNE 需要你決定去留，收工不會代為處理。逐一詢問：
  python3 ".../prune-session-artifacts.py" --sync-root "{{SYNC_ROOT}}" --interactive --apply
```

手動執行時，結尾會列出每個待決項目的 `open` 指令讓你先看內容，再附上三種處理方式的完整指令。

互動提示長這樣，直接按 Enter 等於保留：

```text
  ORPHAN-MEDIA  backups/carousel-renders.bak  (26.2d, 900K)
                  7 個媒體檔在備份區以外找不到同名同大小的副本：
                  - carousel-01.jpg
                  刪除 carousel-renders.bak？ [d]刪除 / [k]保留(預設) / [D]全部刪除 / [K]全部保留 >
```

沒有可用終端機時（例如被包在自動化流程裡），`--interactive` 不會假裝問過，而是照樣報 `PENDING` 留待下次。

### 手動執行

```bash
PRUNE="{{SYNC_ROOT}}/skills/cross-device-sync/scripts/prune-session-artifacts.py"

# 預設 dry run，只列出會刪什麼，不動任何檔案
python3 "$PRUNE" --sync-root "{{SYNC_ROOT}}"

# 確認後才實際刪除
python3 "$PRUNE" --sync-root "{{SYNC_ROOT}}" --apply

# 逐一處理待決策項目
python3 "$PRUNE" --sync-root "{{SYNC_ROOT}}" --interactive --apply

# 改保留期；停用整個清理
python3 "$PRUNE" --sync-root "{{SYNC_ROOT}}" --days 30 --apply
bash "$CHECKPOINT" --phase shutdown --sync-root "{{SYNC_ROOT}}" --no-prune
```

checkpoint 也接受 `--prune-days N`。開工階段不會執行清理，只有收工會。

## 實際踩坑紀錄（2026-07-20～2026-07-21 驗證）

- Homebrew 第一次執行可能先自動更新，數分鐘沒有明顯輸出；不要因安靜就重複啟動另一個安裝程序。
- `chezmoi init --promptString` 配對的是 template 顯示給使用者的 prompt 文字，不是 `.chezmoi.toml.tmpl` 裡的 key。配錯時 headless shell 會嘗試開 `/dev/tty`，出現 `device not configured`。
- installer 內的 `CHEZMOI_SOURCE` 只是腳本變數，不是 chezmoi 原生全域環境變數。直接驗證非預設 source 時要明確傳 `chezmoi --source <path> ...`。
- 原有正確 symlink 可以保留；chézmoi 管的是「如何重建」，不是強迫把內容搬走。實體檔或指向別處的 symlink 一律先備份與人工判斷。
- Agent CLI 沒安裝不等於不能建立入口；入口與 Agent 本體安裝應分開處理，登入憑證更不能跟著同步。
- Gemini 官方首頁雖列出 `brew install gemini-cli`，但 2026-07-21 的 Homebrew formula 已標示為上游不支援並排定停用；新安裝改走 Google 官方部署文件的 `npm install -g @google/gemini-cli@latest`，不要改裝成不同產品的 CLI。
- 在離線測試 source 對已管理 symlink 重跑 `chezmoi add --template-symlinks` 時，chezmoi 警告會「remove template attribute」；無 TTY 環境隨後失敗為 `could not open a new TTY`。這證實既有 templates 不應在每次收工重新 add。
- `chezmoi update` 本質上會更新 source 並 apply；因此不應在 source 尚無 commit／remote 或 worktree 不乾淨時自動執行。checkpoint 把這三個條件收成機器可驗證的 gate。
- 把整份 zsh／bash profile 當一般 template 會覆蓋現有 key loader、Homebrew 或 alias。改用四個 `modify_` scripts，只替換 `agent-python-tools` 標記區塊；標記不完整或重複時停止。
- venv 不能可靠跨 OS、CPU、Python ABI 或 home path 搬移。Item 34 每機重建 runtime，Item 16 只管理中立 bridge 與 PATH loader。
- Agent 對話通常在啟動時取得 PATH；安裝後要開新對話／終端，或 source `{{HOME}}/.config/agent-tools/python-tools.env`。
- 只在 `.zshenv` prepend PATH 仍可能被後續 `.zprofile` 的 Homebrew／user Python 設定蓋到後面，導致同名舊指令先被找到。四個 profile 都載入同一個 idempotent env loader；loader 會移除重複 bridge 路徑再放回 PATH 最前面。

## 舊版手動搬移流程（只供既有安裝遷移參考）

以下 Step 2–6 保留給已經依舊版建立實體 `{{CODEX_HOME}}/skills` 的使用者理解遷移原理。新安裝與新電腦一律使用上面的 chezmoi bootstrap，不要手動拆開執行。

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
test -f "{{SYNC_ROOT}}/skills/cross-device-sync/SKILL.md" && echo "cross-device-sync readable"
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

每台電腦的 Codex、Claude、AntiGravity 都需要各自安裝與登入；不同步任一 Agent 的 `auth.json`、token、cookie、OAuth session 或 local state。

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
- 不要同步 `{{CODEX_HOME}}/python-tools` 的 venv；只同步可重建腳本，並讓 chezmoi 管理中立 bridge／loader。
- 不要同步 `auth.json`、token、`.env`、sqlite、logs、sessions、cache。
- 全域 skill 主版本固定是 `{{SYNC_ROOT}}/skills`；Codex、Claude、AntiGravity 只使用 chezmoi 管理的原生入口，專案 skill 固定放 `<project-root>/000_Agent/skills`。
- 不要把私密 skills、個人記憶或草稿放進 public repo。
- 先備份，再 symlink。
- 改完後重開正在使用的 Agent 對話或 App。

## 驗收紀錄範本

完成後請記錄自己的結果：

```text
{{CODEX_HOME}}/skills
→ {{SYNC_ROOT}}/skills

BACKUP={{BACKUP_ROOT}}/codex-backup-YYYYMMDD-HHMMSS
OLD={{CODEX_HOME}}/skills.before-symlink-YYYYMMDD-HHMMSS
RESULT=<可讀到的自訂 skill 數量與抽測結果>
```

## 最終檢查清單

- [ ] `{{CODEX_HOME}}/skills` 是 symlink。
- [ ] `readlink "{{CODEX_HOME}}/skills"` 指向 `{{SYNC_ROOT}}/skills`。
- [ ] `{{CLAUDE_HOME}}/CLAUDE.md` 與 `{{CLAUDE_HOME}}/skills` 指向共享主版本（Claude 未安裝也先準備）。
- [ ] `{{GEMINI_HOME}}/GEMINI.md` 與 `{{GEMINI_HOME}}/config/skills` 指向共享主版本（AntiGravity 未安裝也先準備）。
- [ ] `{{HOME}}/.local/share/agent-tools/python-tools` 指向本機 `{{PYTHON_TOOLS_HOME}}`，不是雲端 runtime。
- [ ] `{{HOME}}/.config/agent-tools/python-tools.env` 存在，`.zshenv`、`.zprofile`、`.profile`、`.bash_profile` 各只有一組完整標記。
- [ ] fresh shell 的 `command -v python-tools-python` 指向中立 bridge；Codex、Claude、AntiGravity 呼叫相同 wrapper 名稱。
- [ ] `chezmoi status` 為空，`chezmoi doctor` 沒有功能性錯誤。
- [ ] `{{SYNC_ROOT}}/skills` 內有自訂 skills。
- [ ] `{{SYNC_ROOT}}/skills/cross-device-sync/SKILL.md` 可讀。
- [ ] 本機備份資料夾存在。
- [ ] 未同步整個 `{{CODEX_HOME}}`。
- [ ] 未同步任何 token、憑證、`.env`、sqlite、logs、sessions。
- [ ] chezmoi source 只有 templates，沒有 token、auth、session、cache 或私密資料。
- [ ] 開新 Agent 對話後，所選 Agent 可讀共享規則與 skills。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊。這個序號項目會安裝：`cross-device-sync`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請依 README 設定 `{{SYNC_ROOT}}`；package 只寫入共用主版本，Item 16 與 chezmoi 會建立 Codex、Claude、AntiGravity 的原生入口。

````bash
set -e

# ---- cross-device-sync ----
mkdir -p "{{SYNC_ROOT}}/skills/cross-device-sync"
# cross-device-sync/SKILL.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/cross-device-sync/SKILL.md")"
cat > "{{SYNC_ROOT}}/skills/cross-device-sync/SKILL.md" <<'AGENT_LAZYPACK_CROSS_DEVICE_SYNC_SKILL_MD_0E95F5A366'
---
name: cross-device-sync
description: Use when the user asks to install, bootstrap, audit, repair, or document cross-device and cross-agent synchronization for Claude Code, Codex, AntiGravity/Gemini, chezmoi/dotfiles, shared local Python tools, global skills, AGENTS.md or CLAUDE.md rules, shared core-rules.md, Arry Assistant data, Obsidian cockpits, AI assistant memory, cloud sync, GitHub backups, or a new-computer migration across macOS, Windows, Linux, Google Drive, iCloud, Dropbox, or OneDrive.
metadata:
  short-description: Bootstrap and verify cross-agent portability
---

# Cross-Device Sync

Use this skill to make the user's AI-agent setup portable across devices without binding rules, skills, memory, or bootstrap logic to one machine or one vendor-specific app folder.

The durable assets remain agent-neutral where possible. Each agent uses its own supported adapter entrypoints:

- Codex: `$CODEX_HOME/AGENTS.md` and `$CODEX_HOME/skills`, or `~/.codex/...`
- Claude Code: `$CLAUDE_HOME/CLAUDE.md` and `$CLAUDE_HOME/skills`, or `~/.claude/...`
- AntiGravity/Gemini: `~/.gemini/GEMINI.md` and `~/.gemini/config/skills`; older `~/.gemini/config/AGENTS.md` and `plugins/codex/skills` may remain as compatibility aliases during migration
- Chezmoi source state: `~/.local/share/chezmoi` by default; it manages entrypoint templates and symlinks, not the shared content itself
- Portable global rules: `ASSISTANT_ROOT/core-rules.md` or `SYNC_ROOT/core-rules.md`; `$CODEX_HOME/AGENTS.md` may be a symlink entrypoint to that file
- Custom global skill source: `SYNC_ROOT/skills`; expose the same package source through Codex, Claude, and AntiGravity native skills entrypoints
- Shared local Python command surface: `~/.local/share/agent-tools/python-tools/bin`; it is a neutral symlink bridge to the device-local runtime, normally `$CODEX_HOME/python-tools`, and all three Agents invoke the same wrapper names
- Shared shell loader: `~/.config/agent-tools/python-tools.env`; chezmoi inserts an idempotent source block into `.zshenv`, `.zprofile`, `.profile`, and `.bash_profile` without owning the rest of those files
- Project rules: `AGENTS.md`
- Optional assistant data-layer root: `ASSISTANT_ROOT`
- Optional assistant global layer: `ASSISTANT_ROOT`, containing `skills/`, `memories/`, `workflows/`, and `knowledge/`
- Optional assistant local work/reference layers: `100_Todo/` and `200_Reference/` under the selected assistant or project root
- Optional Obsidian vault: `OBSIDIAN_VAULT`
- Optional project cockpit: `PROJECT_LIBRARY/<project-name>/專案工作流程.md`

This user's current defaults are documented in the root `README.md`; treat them as examples to replace, not universal paths.

## Non-Negotiables

- Arry's default profile always manages Codex, Claude, and AntiGravity entrypoints, including future-ready entrypoints when an app is not installed yet. Keep each agent's native config format separate and do not copy tool-specific commands, hooks, MCP config, or delegation formats literally.
- Do not move, symlink, delete, or overwrite the user's existing Codex config, skills, memories, or Obsidian notes without first showing the concrete plan and getting explicit confirmation.
- Always make a timestamped backup before any operation that moves files, rewrites symlinks, changes Git remotes, or edits shared assistant memory.
- Never sync secrets, OAuth tokens, API keys, local credentials, app caches, shell snapshots, or machine-specific state across devices.
- Never sync or copy a Python virtual environment between devices. Rebuild it locally with LazyPack Item 34; let Item 16 manage only its neutral bridge, shell loader, and machine-local runtime path.
- Treat `~/.codex/auth.json`, `~/.codex/sessions/`, `~/.codex/log/`, SQLite state, caches, and local override config as machine-local; never sync or commit them.
- Treat public repos as public. Do not put private backups, credentials, private memory, drafts, or personal logs into tracked project files.
- Prefer the user's established project folder and knowledge cockpit pattern unless they choose another sync route.
- Share durable Markdown assets such as `core-rules.md`, documented workflows, and portable skill packages across all three agents; do not symlink incompatible app config files together.
- Convert external agent global-setting guides into this portability model instead of creating a separate global-settings skill.

## Chezmoi And Symlink Roles

- Cloud storage or Git synchronizes durable content. A symlink exposes that content at an agent's live path.
- Chezmoi installs, recreates, templates, audits, and repairs those live entrypoints on each device. It does not replace the cloud sync provider.
- Keep `SYNC_ROOT` and `pythonToolsHome` machine-specific in the local chezmoi config. Store only `{{ .syncRoot }}` and `{{ .pythonToolsHome }}` templates in the source state so account-specific cloud paths and runtime locations do not enter a portable dotfiles repo.
- A local chezmoi source repo may remain uncommitted while testing. `chezmoi doctor` will report a dirty working-tree warning until the user explicitly chooses a private remote and authorizes commit/push.
- Use `scripts/bootstrap-agent-sync.sh` for deterministic audit/apply behavior on macOS, Linux, or WSL. Windows native users should install chezmoi with WinGet and run the equivalent documented commands; symlinks may require Developer Mode or an elevated shell.

## Startup And Shutdown Checkpoint

Use `scripts/session-sync-checkpoint.sh` from all three Agents so the user does not need to restate the chezmoi policy for every task.

Startup command:

```bash
"{{SYNC_ROOT}}/skills/cross-device-sync/scripts/session-sync-checkpoint.sh" \
  --phase startup \
  --sync-root "{{SYNC_ROOT}}" \
  --update
```

Shutdown command:

```bash
"{{SYNC_ROOT}}/skills/cross-device-sync/scripts/session-sync-checkpoint.sh" \
  --phase shutdown \
  --sync-root "{{SYNC_ROOT}}"
```

Policy:

- Both phases run the bootstrap dry-run and `chezmoi status`.
- Startup may run `chezmoi update` automatically only when the source has at least one commit, a configured remote, and a clean working tree. The script backs up all managed Agent entrypoints first. Otherwise update is a safe no-op and reports the reason once.
- Shutdown does not pull or apply remote changes.
- Do not run `chezmoi add` on existing managed rule, skill, Python bridge, environment-loader, or profile-modifier entries. An isolated test confirmed that adding an existing managed symlink can remove its template attribute; in a headless Agent it may also attempt `/dev/tty`. That would replace portable template state with a machine-specific path.
- `chezmoi add` is only for a genuinely new approved entrypoint. Extend the bootstrap whitelist and create its portable template first, back up the destination, then inspect the source diff and rerun the checkpoint. Changes inside `{{SYNC_ROOT}}` or the local Python runtime do not need `chezmoi add` because their own installers/sync channels own that content.
- Project session state is separate from machine bootstrap: `startup-sync` always reads project-root `HANDOFF.md`; `shutdown-sync` always creates or refreshes it.

### Agent execution notes

- Shared steps: all three Agents call the same checkpoint script and use the same handoff fields and safety gates.
- Codex adapter: run through the available terminal; Codex sandbox must allow the narrow chezmoi config/source and managed entrypoint paths.
- Claude adapter: run the same script through Claude's terminal environment; when no local terminal is available, use the project's normal shell and return the checkpoint output to Claude.
- AntiGravity adapter: run the same script through the local shell; verify the Gemini entrypoints listed by the bootstrap dry-run.
- Shared Python adapter: all three Agents call `python-tools-python`, `audio-to-md`, `doc-to-md`, and any other installed wrapper by the same command name. If an Agent shell does not load user profiles, source `~/.config/agent-tools/python-tools.env` or use the neutral bridge's absolute `bin` path.
- Fallback: run `bootstrap-agent-sync.sh --dry-run`, `chezmoi status`, and the guarded Git-source checks manually without changing the policy.
- Verification: every selected Agent entrypoint resolves to `SYNC_ROOT`, the neutral Python bridge resolves to the device-local runtime, a fresh shell discovers `python-tools-python`, `chezmoi status` is clean or its differences are reported, and `HANDOFF.md` matches live project state.

## LazyPack Public Packaging Policy

Use this route whenever the user asks to package, publish, mirror, or update a LazyPack item, portable installer, public README, embedded skill installer, setup script, template, or cross-agent installation guide.

Public packaging rules:

1. Never expose the author's real local installation directories, cloud-account mount paths, vault paths, user names, email addresses, repository checkout paths, or machine-specific tool homes in public LazyPack content.
2. Use placeholders in public Markdown, embedded shell/Python scripts, templates, README tables, and Obsidian mirrors. Common placeholders include:
   - `{{HOME}}`
   - `{{CODEX_HOME}}`
   - `{{CLAUDE_HOME}}`
   - `{{GEMINI_HOME}}`
   - `{{GEMINI_CONFIG}}`
   - `{{CHEZMOI_SOURCE}}`
   - `{{SYNC_ROOT}}`
   - `{{GLOBAL_RULES}}`
   - `{{SETUP_REPO}}`
   - `{{ANTIGRAVITY_SETUP_REPO}}`
   - `{{OBSIDIAN_VAULT}}`
   - `{{OBSIDIAN_PROJECTS}}`
   - `{{SECRETS_DIR}}`
   - `{{LOCAL_BIN}}`
   - `{{DOWNLOADS_DIR}}`
   - `{{LOCAL_FILE_PATH}}`
3. In executable installers, prefer environment variables with safe defaults over hardcoded public paths. Runtime code may compute a real local path internally, but it must not print the full path unless the user is running a private local diagnostic and has asked for it.
4. Public examples must be provider-neutral. Use descriptions such as "your cloud-synced folder" instead of embedding a real Google Drive, iCloud, Dropbox, OneDrive, or account-specific path.
5. Any LazyPack item that introduces placeholders must either link to the LazyPack README placeholder table or include a focused local table for the new variables.
6. Before finishing, scan the public packaging scope for real-path residue. At minimum check LazyPack Markdown, public README files, setup scripts, templates, and embedded installer code for:
   - real user home paths
   - cloud account identifiers
   - email-address mount paths
   - literal tilde-style Codex or Gemini config homes shown as public install instructions instead of placeholders
   - absolute user-home examples
7. When reporting completion for public packaging work, explain the placeholders used, but do not expand them to the author's actual local paths.

Private project notes may record verification results, but public LazyPack content must remain portable and machine-neutral.

## Workflow

1. Read local rules:
   - Current project `AGENTS.md`
   - Secondbrain `AGENTS.md` if Obsidian notes are involved
   - `arry-assistant` skill if Arry Assistant data is involved
2. Inventory current state before proposing changes:
   - `$CODEX_HOME/config.toml` or `~/.codex/config.toml`
   - `$CODEX_HOME/AGENTS.md` and its symlink target; if portability is intended, the target should be `ASSISTANT_ROOT/core-rules.md` or `SYNC_ROOT/core-rules.md`
   - `$CODEX_HOME/skills` or `~/.codex/skills`
   - `$CODEX_HOME/memories` or `~/.codex/memories` if memory portability is in scope
   - project `AGENTS.md` files that should travel with each project
   - relevant Obsidian cockpit notes
3. Confirm the machine and sync context briefly in Traditional Chinese; do not ask Arry to choose among the three required agents:
   - device mix: one computer, multiple Macs, Mac plus Windows, Windows/Linux first, or custom
   - preferred sync channel: Google Drive, iCloud, Dropbox, OneDrive, GitHub only, or let Codex recommend
   - backup/versioning preference: private GitHub repo, public repo with strict ignores, local backup only, or decide later
   - health-check frequency: manual, weekly, or scheduled
4. Recommend a route and wait for explicit approval before state changes.
5. After approval, implement in small reversible steps:
   - run `scripts/bootstrap-agent-sync.sh --sync-root <path> --dry-run`
   - install chezmoi only when missing and explicitly approved; prefer the official package-manager route
   - create timestamped backups
   - initialize or reuse the approved chezmoi source state without adding a remote, commit, or push automatically
   - keep `SYNC_ROOT` in machine-local chezmoi config data and agent adapters in portable templates
   - apply the Codex, Claude, and AntiGravity rule/skill entrypoint symlinks; create future-ready parent folders even when a corresponding app is not installed yet
   - keep the Python virtual environment local, then expose its `bin` directory through the neutral bridge and idempotent shell loader shared by all three Agents
   - create `.gitignore` before any Git add
   - create a health-check script if useful
   - create or update a migration note
6. Verify:
   - paths exist
   - `chezmoi status` is empty after apply
   - `chezmoi doctor` has no functional failures; an uncommitted source warning is acceptable until private versioning is approved
   - symlink targets exist if symlinks were used
   - ignored files are actually ignored
   - no secrets or machine-local state are staged
   - Codex skill frontmatter still validates if skills were moved or created
   - Codex, Claude, and AntiGravity use their native global skill entrypoints; `SYNC_ROOT/skills` remains the shared package source, and project-local skills remain under the project's documented path
   - all three Agent shells discover the same Python wrapper commands without duplicating the runtime; a missing local runtime is reported as the Item 34 dependency
7. Report exact paths changed for private local work. For public LazyPack or portable packaging work, report placeholder names and verification results without expanding the author's real local paths.

## Multi-Agent Compatibility Audit

Use this route when the user asks whether the three agents can use the same setup, whether another runtime should read the same memory/rules, or whether a single-agent guide should be merged into this portability workflow.

Default behavior:

1. Audit first; do not modify files.
2. Treat `SYNC_ROOT/core-rules.md` as the cross-agent global rules source of truth.
3. Treat `$CODEX_HOME/AGENTS.md` as Codex's symlink entrypoint to that file.
4. Keep app-specific config files separate; convert settings formats instead of sharing them directly.
5. Classify each asset as portable, convertible, local-only, or unsafe-to-sync.
6. Produce a report with risks, recommended changes, and confirmation gates.

Read `references/multi-agent-compatibility.md` for the detailed checklist and report template.

## Cross-Agent Global Settings

Use this route when the user provides an AI Agent global settings guide, asks where a global rule belongs, wants Codex / Claude Code / OpenCode / AntiGravity-Gemini to share policy safely, or mentions dotfiles/chezmoi for AI settings.

Default behavior:

1. Treat `core-rules.md` as the durable shared policy source where appropriate.
2. Keep each agent's live config entrypoint separate; do not symlink incompatible config formats together.
3. Convert app-specific rules into portable Markdown policy, references, or LazyPack content.
4. Keep secrets, OAuth, sessions, cookies, local state DBs, and full private config contents out of repos and public notes.
5. Keep the deterministic chezmoi/bootstrap installer in this skill and LazyPack Item 16; project lifecycle behavior remains in Item 10.

Read `references/global-settings-spec.md` for the converted policy, path map,
the shared STT/TTS provider order, voice-reply boundary, and speech-input
assumption boundary.

## Three-Agent Portability Map

Use this mapping when converting a single-agent source guide:

| Source guide concept | Shared package and native adapters |
|---|---|
| Source-specific global skills path | `SYNC_ROOT/skills`, exposed through `$CODEX_HOME/skills`, `$CLAUDE_HOME/skills`, and `$GEMINI_CONFIG/skills` |
| Source-specific global or project rule file | `AGENTS.md` for canonical project rules, `core-rules.md` for portable global rules, and thin native adapters such as Claude's `CLAUDE.md` |
| Global agent rules shared across tools | `ASSISTANT_ROOT/core-rules.md` or `SYNC_ROOT/core-rules.md`, with native symlink entrypoints for all three agents |
| Source-specific command shortcuts | Agent Skills metadata, natural-language triggers, and a documented native invocation for each agent when syntax differs |
| Source-specific delegation format | Shared task boundaries plus the active agent's supported delegation or validation mechanism |
| Source-specific memory folder | `SYNC_ROOT/memories` as durable source; any native memory hook is an adapter and must not fork the data |
| `000_Agent` from source kit | Project-local assistant layer only; this user's global assistant layer is `ASSISTANT_ROOT` with `memories/`, `workflows/`, `knowledge/`, and `skills/` |
| Source-specific credentials/local state | Do not sync; each device logs in independently |

## Sync Route Guidance

- Apple-only multi-device setup: iCloud can work, but verify paths and symlink behavior carefully.
- Mac plus Windows or Android-heavy setup: Google Drive or Dropbox is usually more predictable.
- Windows/Linux-first setup: Google Drive, OneDrive, Dropbox, or GitHub-only depending on existing habits.
- Single computer: focus on portability backup and migration docs; real-time sync may be unnecessary.
- Existing personal-assistant workflows: prefer the user's already-established sync provider and project cockpit pattern.

## What To Sync

Usually portable:

- custom global skill packages under `SYNC_ROOT/skills`, excluding agent-managed system/bundled packages
- portable global operating rules in `ASSISTANT_ROOT/core-rules.md` or `SYNC_ROOT/core-rules.md`, so other AI agents can read the same rule file
- reusable project rules and templates
- personal assistant durable references and reusable memory under `ASSISTANT_ROOT/memories` and `ASSISTANT_ROOT/workflows`, when the user explicitly wants that layer synced
- migration docs, health-check scripts, and setup notes

Usually not portable:

- tokens, OAuth files, credentials, API keys, `.env`
- `$CODEX_HOME/auth.json`, `$CODEX_HOME/sessions/`, `$CODEX_HOME/log/`, `$CODEX_HOME/*.sqlite*`, and `$CODEX_HOME/config.local.toml`
- per-device local settings
- caches, telemetry, shell snapshots, conversation state
- generated temp files and logs unless the user explicitly wants archival logs

## Reference

When more detail is needed:

- Read `references/codex-playbook.md` before executing a real cross-device setup, audit, repair, GitHub backup, health-check script, or migration-manual task. It contains the full Codex-converted Section A-G workflow, routes, templates, checks, pitfalls, and FAQ.
- Read `references/multi-agent-compatibility.md` before checking whether Codex settings, global rules, skills, memory, MCP, prompts, hooks, or project rules can be used by other AI agents.
- Read `references/global-settings-spec.md` before converting a cross-agent global settings guide, voice reply rule, speech-input assumption, or dotfiles/chezmoi AI config policy into this setup.
- Read `references/source-adaptation.md` when you need to understand how external assistant setup material was converted into shared packages and native adapters.
- Read `references/agent-execution-compatibility.md` before adding or reviewing an Agent-specific connector, plugin, MCP, image tool, sandbox, model, or script branch.
- Run `python3 scripts/audit-agent-compatibility.py --root <path> [...]` to catch exclusionary or single-agent-default wording before syncing LazyPack and Obsidian mirrors.
- Run `scripts/bootstrap-agent-sync.sh --help` before a real first-install/bootstrap execution. Always audit with `--dry-run` before `--apply`.
AGENT_LAZYPACK_CROSS_DEVICE_SYNC_SKILL_MD_0E95F5A366

# cross-device-sync/agents/openai.yaml
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/cross-device-sync/agents/openai.yaml")"
cat > "{{SYNC_ROOT}}/skills/cross-device-sync/agents/openai.yaml" <<'AGENT_LAZYPACK_CROSS_DEVICE_SYNC_AGENTS_OPENAI_YAML_DEB9755D27'
display_name: Cross-Device & Agent Sync
short_description: Bootstrap Claude, Codex, and AntiGravity portability.
default_prompt: Use $cross-device-sync to audit or bootstrap a safe chezmoi-managed cross-device and cross-agent setup.
AGENT_LAZYPACK_CROSS_DEVICE_SYNC_AGENTS_OPENAI_YAML_DEB9755D27

# cross-device-sync/assets/agent-guardrails.json
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/cross-device-sync/assets/agent-guardrails.json")"
cat > "{{SYNC_ROOT}}/skills/cross-device-sync/assets/agent-guardrails.json" <<'AGENT_LAZYPACK_CROSS_DEVICE_SYNC_ASSETS_AGENT_GUARDRAILS_JSON_3CA8879092'
{
  "_comment": "跨 Agent 危險指令防護的可攜主版本。零本機絕對路徑，可直接跨機器套用。本檔隨 cross-device-sync skill 發布（assets/），LazyPack Item 16 會完整內嵌。修改後三個 Agent 必須一起同步並雙向實測（見 knowledge/prompt-defense-baseline.md §4.2）。",
  "_updated": "2026-08-26",
  "forbidden": {
    "_comment": "絕對不執行。Claude 寫入 permissions.deny；Codex 寫入 rules/default.rules 的 arry-dangerous-rules 區塊。",
    "sudo": [
      "sudo"
    ],
    "chmod_777": [
      "chmod 777",
      "chmod -R 777"
    ],
    "disk": [
      "mkfs",
      "diskutil eraseDisk"
    ],
    "git_history": [
      "git push --force",
      "git push -f",
      "git push --force-with-lease",
      "git reset --hard",
      "git branch -D"
    ],
    "git_clean": [
      "git clean -f",
      "git clean -fd",
      "git clean -fdx",
      "git clean -df",
      "git clean -dfx",
      "git clean -xdf"
    ],
    "system": [
      "shutdown"
    ]
  },
  "ask": {
    "_comment": "執行前詢問使用者。Claude 寫入 permissions.ask；Codex 寫成 decision=\"prompt\"。2026-08-26 起 git_publish 清空，commit/push 不再詢問，理由見 excluded。",
    "git_publish": []
  },
  "excluded": {
    "_comment": "刻意不納入，附理由。",
    "rm -rf": "11 個安裝腳本正當使用（doc-to-md、audio-to-md、cli-anything、install_python_tools 等），刪的是 $temp_dir／$STAGING_DIR／venv。無差別擋會弄壞安裝流程。需路徑感知的 hook 才能處理。",
    "dd": "也用於一般檔案複製與測試，誤擋率高。",
    "chmod -R (不含 777)": "chmod -R 755、chmod -R u+x 都是正常操作。2026-08-26 曾因把 -R 當獨立條件而誤擋。",
    "git commit / git push": "2026-08-26 依使用者決定，這兩條 ask 規則整條拿掉。實測發現 Claude 的 permissions.ask 優先權高於 PreToolUse hook 的 allow，無法用自動審核器取代彈窗，只能整條拿掉。core-rules.md 已同步把 commit/push 從 C 級移到 D 級，並在〈commit 與 push 的現行處理〉列出 Agent 執行前仍必須自行完成的檢查（掃金鑰、確認 repo 可見性與分支）。force push、reset --hard、clean -f、branch -D 仍在 forbidden，不受影響。"
  },
  "known_gaps": {
    "_comment": "已知且目前無法修補，需人工留意。",
    "git push origin main --force": "兩邊都是前綴比對，--force 不在固定位置就抓不到。force push 前需人工確認。",
    "antigravity": "AntiGravity 無指令 deny 機制（globalPermissionGrants 只有 allow）。其防線是 enableTerminalSandbox 與 core-rules.md 判斷層。"
  },
  "apply": {
    "claude": "~/.claude/settings.json → permissions.deny 用 \"Bash(<cmd>:*)\" 格式逐條列；permissions.ask 同格式。",
    "codex": "~/.codex/rules/default.rules → prefix_rule(pattern=[...], decision=\"forbidden\"|\"prompt\")，包在 # >>> arry-dangerous-rules >>> 區塊內。注意值是 forbidden 不是 deny。",
    "antigravity": "無對應機制，不套用。",
    "verify_claude": "在拋棄式目錄實際執行該指令，看是否回 permission denied。",
    "verify_codex": "codex execpolicy check --pretty --rules ~/.codex/rules/default.rules -- <指令>，看 decision 欄。"
  }
}
AGENT_LAZYPACK_CROSS_DEVICE_SYNC_ASSETS_AGENT_GUARDRAILS_JSON_3CA8879092

# cross-device-sync/references/agent-execution-compatibility.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/cross-device-sync/references/agent-execution-compatibility.md")"
cat > "{{SYNC_ROOT}}/skills/cross-device-sync/references/agent-execution-compatibility.md" <<'AGENT_LAZYPACK_CROSS_DEVICE_SYNC_REFERENCES_AGENT_EXECUTION_COMPATIBILITY_MD_961557E704'
# Codex / Claude / AntiGravity Execution Compatibility

Use this contract whenever a shared skill or project workflow depends on an Agent-specific tool, config format, permission model, model route, or UI.

## Shared Contract

The three agents must share:

- one task goal and scope;
- one source package under `{{SYNC_ROOT}}/skills` or the project `000_Agent/skills`;
- one input and output contract;
- one safety and approval boundary;
- one project state source: `AGENTS.md`, `HANDOFF.md`, project files, and the Obsidian cockpit when used;
- one verification standard.

Only the execution adapter may vary. A missing native feature is a routing decision, not a reason to drop that agent.

## Required Note Format

Whenever an execution step differs, record it in the same skill, script help, README, or project workflow:

```markdown
### Agent execution notes

- Shared steps: inputs, outputs, safety gates, and verification common to all three.
- Codex adapter: native tool/config/permission/restart details.
- Claude adapter: native tool/config/permission/restart details.
- AntiGravity adapter: native tool/config/permission/restart details.
- Fallback: shared CLI/script, approved API, or browser/manual route.
- Verification: the same observable result for every adapter.
```

Do not create three independent workflows. Keep the common logic together and limit each adapter note to the real runtime difference.

## Route Matrix

| Capability | Shared first choice | Codex adapter | Claude adapter | AntiGravity adapter |
| --- | --- | --- | --- | --- |
| Rules | `core-rules.md` and project `AGENTS.md` | `AGENTS.md` native entry | thin `CLAUDE.md` import or global symlink | `GEMINI.md` native entry |
| Skills | `{{SYNC_ROOT}}/skills` | `{{CODEX_HOME}}/skills` symlink | `{{CLAUDE_HOME}}/skills` symlink | `{{GEMINI_CONFIG}}/skills` symlink |
| Deterministic work | project/shared script | run through available terminal | run through available terminal | run through available terminal |
| Shared local Python tools | neutral `~/.local/share/agent-tools/python-tools/bin` wrappers | call the shared command name or neutral absolute path | call the same shared command name or neutral absolute path | call the same shared command name or neutral absolute path |
| MCP or connector | same service intent and permission scope | Codex-native config/tool surface | Claude-native config/tool surface verified at execution time | AntiGravity-native config/tool surface verified at execution time |
| Image generation | same visual brief and acceptance criteria | native image tool when available | native image tool when available; otherwise approved shared route | native image tool when available; otherwise approved shared route |
| Browser/UI | same read/write authorization boundary | available browser/computer tool or shared browser script | available browser/computer tool or shared browser script | available browser/computer tool or shared browser script |
| Model selection | same task and output contract | current Codex primary model | current Claude native default | current AntiGravity primary model |

Agent capabilities and config syntax can change. Check the active tool list, local `--help`, repository instructions, or current official documentation before writing a config-specific command. Record the verified native command without changing the shared workflow.

## Script Branching

For a script whose behavior really differs by runtime, prefer:

```text
--agent auto|codex|claude|antigravity
```

Rules:

1. `auto` may inspect explicit environment markers or installed commands, but must print the selected adapter.
2. Explicit selection must override detection.
3. Every adapter must accept the same core inputs and produce the same output shape.
4. Put credentials in the local secret store or native auth layer, never in arguments, logs, LazyPack, or shared Markdown.
5. Tests must cover `--help`, invalid agent values, `auto`, and at least one dry-run for every adapter.

If there is no behavioral difference, do not add an artificial branch; run the same shared script from all three agents.

## Skill Package Notes

- `SKILL.md`, `references/`, `scripts/`, and `assets/` are the shared package.
- `agents/openai.yaml` is a Codex UI adapter only. Its presence must not change the package's Claude or AntiGravity behavior.
- Vendor-specific frontmatter or command metadata belongs in a native adapter file only when supported. Keep shared trigger intent and procedure in `SKILL.md`.
- Public installers write the package to `{{SYNC_ROOT}}/skills`; Item 16 and chezmoi expose it at all three native entrypoints.

## Verification Gate

Before declaring a workflow compatible:

1. Run the shared package validator and every added script test.
2. Confirm the three native entrypoints resolve to the same skill source.
3. Run the exclusion-word audit:

```bash
python3 "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/audit-agent-compatibility.py" \
  --root "{{SYNC_ROOT}}/core-rules.md" \
  --root "{{SYNC_ROOT}}/skills" \
  --root "{{SETUP_REPO}}/200_Reference/lazy-pack"
```

4. For each native adapter actually used, perform one low-risk read-only or dry-run check.
5. Confirm all adapters lead to the same expected output or state.
AGENT_LAZYPACK_CROSS_DEVICE_SYNC_REFERENCES_AGENT_EXECUTION_COMPATIBILITY_MD_961557E704

# cross-device-sync/references/codex-playbook.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/cross-device-sync/references/codex-playbook.md")"
cat > "{{SYNC_ROOT}}/skills/cross-device-sync/references/codex-playbook.md" <<'AGENT_LAZYPACK_CROSS_DEVICE_SYNC_REFERENCES_CODEX_PLAYBOOK_MD_4F30E54D07'
# Cross-Device And Cross-Agent Sync Playbook

This is the executable Codex, Claude, and AntiGravity adaptation of an external cross-device assistant setup guide.

The original source targeted one assistant app. This playbook keeps the useful portability model while separating shared assets from Codex, Claude, and AntiGravity native entrypoints. Chezmoi owns reproducible bootstrap; the cloud sync root owns content.

## Purpose

Help the user make their AI assistant setup portable:

- keep reusable rules, skills, memory, workflow docs, and migration notes owned by the user
- avoid hiding important assets only inside one local app folder
- separate portable assets from credentials, cache, app state, and device-specific files
- support a new computer, a second computer, and active use from Codex, Claude, or AntiGravity

## What The User Should Get

After an approved execution, the user should have some or all of:

- a sync route selected for their device mix
- a timestamped backup before risky file movement
- a visible mother folder for portable assistant assets
- required chezmoi-managed native entrypoint symlinks for each selected agent, after preview and conflict checks
- a chezmoi-managed neutral Python-tools bridge and shell loader so all three Agents discover the same device-local wrappers
- optional private GitHub backup with a `.gitignore`
- optional `sync-health.sh` or equivalent health check
- a migration note explaining how to restore on a new device or adapt to a future AI tool
- a final verification report with exact changed paths

## Shared And Native Surfaces

Default portable Codex surfaces:

| Purpose | Path or rule |
|---|---|
| Portable global rules | `{{SYNC_ROOT}}/core-rules.md` |
| Shared custom skills | `{{SYNC_ROOT}}/skills` |
| Codex entrypoints | `{{CODEX_HOME}}/AGENTS.md`, `{{CODEX_HOME}}/skills`, `{{CODEX_HOME}}/memories` |
| Claude entrypoints | `{{CLAUDE_HOME}}/CLAUDE.md`, `{{CLAUDE_HOME}}/skills` |
| AntiGravity entrypoints | `{{GEMINI_HOME}}/GEMINI.md`, `{{GEMINI_HOME}}/config/skills` |
| AntiGravity compatibility aliases | `{{GEMINI_HOME}}/config/AGENTS.md`, `{{GEMINI_HOME}}/config/plugins/codex/skills` |
| Chezmoi source | `{{CHEZMOI_SOURCE}}`; templates only, secrets excluded |
| Device-local Python runtime | `{{CODEX_HOME}}/python-tools`; rebuild per computer with LazyPack Item 34, never sync the venv |
| Three-Agent Python command surface | `{{HOME}}/.local/share/agent-tools/python-tools/bin`; neutral bridge managed by Item 16 and loaded through `{{HOME}}/.config/agent-tools/python-tools.env` |
| System skills | `{{CODEX_HOME}}/skills/.system` |
| Project rules | canonical `AGENTS.md`; Claude adapter is a thin `CLAUDE.md` containing `@AGENTS.md` |
| Cross-agent session state | required project `HANDOFF.md`; startup reads it and shutdown creates or refreshes it |
| Main project | `{{SETUP_REPO}}` |
| Arry Assistant global data-layer root | `{{SYNC_ROOT}}` |
| Arry Assistant memory/workflow layer | `{{SYNC_ROOT}}/memories`, `{{SYNC_ROOT}}/workflows` |
| Arry Assistant local work/reference layers | `100_Todo/` and `200_Reference/` under `codex_installation` |
| Obsidian vault | `{{OBSIDIAN_VAULT}}` |
| Global skill mirror note | `專案庫/codex_installation/全域 Skills/全域 Skills 同步.md` |
| GitHub repo visibility | `{{GITHUB_USER}}/{{SETUP_REPO_NAME}}` is public |

## Absolute Safety Rules

1. Do not perform real sync setup during skill installation.
2. Do not move, delete, symlink, or overwrite agent entrypoints, `AGENTS.md`, Obsidian notes, Arry Assistant data, or Git history without explicit user approval after showing a concrete plan.
3. Make a timestamped backup before moving files, replacing files with symlinks, changing remotes, or editing shared memory.
4. Do not sync secrets or machine state:
   - `.env`, API keys, tokens, passwords
   - OAuth credentials and auth files
   - local settings tied to one computer
   - cache, telemetry, shell snapshots, session state
   - generated logs unless the user explicitly wants archival logs
5. Treat `codex_installation` as a public repo. Do not place private backups, credentials, private memory, drafts, or personal logs in tracked project paths.
6. Do not edit system skills under `{{CODEX_HOME}}/skills/.system`.
7. If Obsidian notes are involved, read the vault `AGENTS.md` and update additively.
8. Chezmoi is required for bootstrap and repair, but it must not own the cloud content tree, Python virtual environments, credentials, sessions, caches, MCP auth, or project repositories.

## Section A: Preflight And Interview

### A-1. Confirm The Existing Codex/Arry Base

Check whether the user's existing Codex App assistant base is present:

```bash
test -d "{{CODEX_HOME}}" && echo "Codex home exists"
test -d "{{CODEX_HOME}}/skills" && echo "Codex skills folder exists"
test -d "{{SYNC_ROOT}}" && echo "Arry Assistant global root exists"
test -d "{{SYNC_ROOT}}/memories" && echo "Arry Assistant memory exists"
test -d "{{SYNC_ROOT}}/workflows" && echo "Arry Assistant workflows exists"
test -d "{{PROJECT_ROOT}}/100_Todo" && echo "Arry Assistant work layer exists"
test -d "{{PROJECT_ROOT}}/200_Reference" && echo "Arry Assistant reference layer exists"
test -f "{{SETUP_REPO}}/AGENTS.md" && echo "codex_installation AGENTS.md exists"
```

If core pieces are missing, stop and explain the missing prerequisite. Do not invent a second assistant data layer. The existing architecture is a root plus layers: `codex_installation/` contains `000_Agent/`, `100_Todo/`, and `200_Reference/`.

### A-2. Inventory Current Assets

Gather only metadata unless the user asks for deeper inspection:

```bash
ls -la "{{CODEX_HOME}}" 2>/dev/null | head -40
find "{{CODEX_HOME}}/skills" -maxdepth 2 -name SKILL.md -print 2>/dev/null | sort
find "{{SETUP_REPO}}" -maxdepth 1 -type d -print 2>/dev/null | sort
find "{{SYNC_ROOT}}/memories" -maxdepth 2 -type f -print 2>/dev/null | sort | head -80
```

Record:

- does `config.toml` exist?
- how many custom skills exist?
- which assets are custom versus Codex-managed `.system`?
- whether Arry Assistant root, core, work, and reference layers are already under Google Drive
- whether `codex_installation` is public and what files are tracked
- whether the target Obsidian cockpit exists
- whether the current project has Git and a remote

### A-3. Ask Four Questions

Use concise Traditional Chinese. In Codex App, a plain text question is acceptable unless the current mode/tooling provides an interactive choice UI.

Ask:

1. 你的裝置組合是：只有一台、多台 Mac、Mac + Windows、Windows/Linux 為主，或其他？
2. 你想用哪個同步管道：Google Drive、iCloud、Dropbox、OneDrive、只靠 GitHub，或讓我推薦？
3. 要不要加 GitHub 版本備份：私有 repo、公開 repo、不要、之後再說？
4. 健康檢查要怎麼跑：手動、每週、每天排程，或先不要？

### A-4. Recommend A Route

Route logic:

| Device mix | Default recommendation |
|---|---|
| 多台 Mac | iCloud or existing Google Drive, depending on where the user reads notes |
| Mac + Windows | Google Drive or Dropbox |
| Windows/Linux first | Google Drive, OneDrive, Dropbox, or GitHub-only |
| Single computer | portability backup plus private GitHub, no real-time sync required |
| Existing Arry workflow on this machine | Google Drive plus Obsidian cockpit is the strongest default |

Before changing anything, show:

- device mix
- chosen sync channel
- GitHub backup decision
- health-check cadence
- exact target mother folder
- whether the target is the data-layer root, the portable global rules file `core-rules.md`, the global core layer, or a separate backup/export folder
- exact files or folders to touch
- exact exclusions
- rollback plan

Then wait for explicit approval.

## Section B: Mandatory Backup

Use a Codex-specific backup name and place it somewhere visible and outside the risky operation. Because `codex_installation` is public, do not create private backups inside tracked project paths. If a backup must live under the project folder temporarily, first ensure the backup folder is ignored and report that clearly.

Example:

```bash
BACKUP_DIR="$HOME/codex-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
: "${CODEX_HOME:?Set CODEX_HOME before running this snippet.}"
cp -a "${CODEX_HOME}/config.toml" "$BACKUP_DIR/config.toml" 2>/dev/null || true
cp -a "${CODEX_HOME}/skills" "$BACKUP_DIR/skills" 2>/dev/null || true
```

If Arry Assistant data will be changed:

```bash
cp -a "{{SYNC_ROOT}}/memories" "$BACKUP_DIR/memories" 2>/dev/null || true
cp -a "{{SYNC_ROOT}}/workflows" "$BACKUP_DIR/workflows" 2>/dev/null || true
cp -a "{{SYNC_ROOT}}/knowledge" "$BACKUP_DIR/knowledge" 2>/dev/null || true
cp -a "{{PROJECT_ROOT}}/100_Todo" "$BACKUP_DIR/100_Todo" 2>/dev/null || true
cp -a "{{PROJECT_ROOT}}/200_Reference" "$BACKUP_DIR/200_Reference" 2>/dev/null || true
```

Verify backup:

```bash
find "$BACKUP_DIR" -maxdepth 3 -type f | wc -l
```

Tell the user:

- backup path
- what was backed up
- what was not backed up
- how to restore at a high level

Do not include destructive restore commands in final text unless the user is actively restoring.

## Section C: Build The Sync Architecture

### C-1. Choose Mother Folder

Possible mother folders:

| Route | Example mother folder |
|---|---|
| Existing Google Drive workflow | `{{SETUP_REPO}}` as the data-layer root |
| Arry Assistant global memory/workflows | `{{SYNC_ROOT}}/memories` and `{{SYNC_ROOT}}/workflows` |
| iCloud | `$HOME/Library/Mobile Documents/com~apple~CloudDocs/Arry-Agent` |
| Dropbox | `$HOME/Dropbox/Arry-Agent` |
| OneDrive | `$HOME/Library/CloudStorage/OneDrive-Personal/Arry-Agent` |
| GitHub only | `$HOME/Arry-Agent` or an approved project folder |

For this user, prefer the existing Google Drive `codex_symlink` root when the task concerns the global Arry Assistant data layer. Do not put private memory back into the public `codex_installation` repo.

### C-2. Decide What To Sync

Portable candidates:

- custom skill source or exported copies
- stable assistant rules and preferences, with cross-tool global operating rules in `core-rules.md`
- reusable workflow docs
- migration docs
- health-check scripts
- curated memory intended for cross-project use
- Obsidian cockpit summaries and skill inventory indexes

Avoid syncing:

- `{{CODEX_HOME}}/skills/.system`
- credentials, OAuth state, secrets, `.env`
- session state, temporary caches, logs
- per-device config unless confirmed safe
- private drafts or personal memory in a public repo

### C-3. Copy Versus Symlink

Use symlinks only when they solve a real duplication problem and the user understands the tradeoff.

Safer default:

- keep the Codex-facing path as `{{CODEX_HOME}}/skills`; it may be symlinked to `{{SYNC_ROOT}}/skills` after cross-device sync is configured
- mirror documentation, install instructions, and inventory into Obsidian and the existing project notes
- back up and version controlled exports as needed
- on a second device, recreate the symlink only after confirming the Google Drive folder has synced and the local `{{CODEX_HOME}}/skills` target has been backed up

Riskier route:

- move selected custom skills into the mother folder
- symlink them back into `{{SYNC_ROOT}}/skills/<skill-name>`

Before symlinking, verify:

- target exists
- source is not a system skill
- backup is complete
- no file would be overwritten
- the target folder is private or explicitly safe for the contents being moved

### C-4. Route Notes

Apple/iCloud:

- Best for Apple-only setups.
- Decide mother location based on where the user reads Markdown. Obsidian generally wants real files inside its vault, not symlink targets.
- Keep symlinks outside iCloud when possible.

Dropbox:

- Useful across operating systems.
- Prefer mother folder inside Dropbox and symlink from local app path to mother, not the reverse.

Google Drive:

- Good default on this machine because projects already live in Google Drive.
- Quote paths carefully because they contain spaces and non-ASCII characters.
- Expect occasional sync delay.

OneDrive:

- Common for Microsoft-heavy setups.
- Check actual local path first.

GitHub only:

- Good for single-computer portability.
- Versioned backup matters more than real-time sync.

## Section D: GitHub Backup

Only do this if the user selected GitHub backup.

### D-1. Initialize Or Reuse Git

Check first:

```bash
git status --short --branch
git remote -v
```

Do not initialize inside the wrong folder. Do not add unrelated files.

In the current architecture, `codex_installation` already has a public GitHub repo. Do not use that public repo for private assistant memory or backups. If the user wants GitHub backup for private memory, recommend a separate private repo.

### D-2. `.gitignore` For Private Repo

Use and adapt:

```gitignore
# Secrets and credentials
.env
.env.*
**/credentials.json
**/*.key
**/.credentials.json
**/token*
**/auth*

# Codex local or machine state
.codex/tmp/
.codex/cache/
.codex/sessions/
.codex/auth*

# System and build noise
.DS_Store
Thumbs.db
*.log
node_modules/
.venv*/
__pycache__/
```

### D-3. Extra Rules For Public Repo

Add stricter exclusions:

```gitignore
# Personal or private memory
000_Agent/memories/
000_Agent/**/private/
100_Todo/drafts/
100_Todo/archive/
300_Journal/
500_People/
*.private.md
codex-backup-*/
.local-backups/
```

### D-4. Stage Carefully

Before staging:

```bash
git status --short
```

After staging:

```bash
git diff --cached --name-only
```

Never stage secrets or machine-local state. If unsure, stop and ask.

### D-5. Push

If using GitHub CLI or connector, prefer private repositories for assistant memory. If the user wants public, warn that memory and personal notes may leak.

## Section E: Health Check Script

Generate a health check only after the target architecture is known. The check must cover the shared source and all three native entrypoints.

Suggested `sync-health.sh` shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "Codex / Claude / AntiGravity sync health check"
FAIL=0

: "${CODEX_HOME:?Set CODEX_HOME before running this check.}"
: "${CLAUDE_HOME:?Set CLAUDE_HOME before running this check.}"
: "${GEMINI_CONFIG:?Set GEMINI_CONFIG before running this check.}"
: "${SYNC_ROOT:?Set SYNC_ROOT before running this check.}"
SKILLS_DIR="$SYNC_ROOT/skills"
MOTHER="${1:-}"

check_exists() {
  local label="$1"
  local path="$2"
  if [ -e "$path" ]; then
    echo "OK: $label -> $path"
  else
    echo "MISSING: $label -> $path"
    FAIL=$((FAIL+1))
  fi
}

check_exists "Codex home" "$CODEX_HOME"
check_exists "Claude home" "$CLAUDE_HOME"
check_exists "AntiGravity config" "$GEMINI_CONFIG"
check_exists "Shared skills" "$SKILLS_DIR"
check_exists "Codex skills entry" "$CODEX_HOME/skills"
check_exists "Claude skills entry" "$CLAUDE_HOME/skills"
check_exists "AntiGravity skills entry" "$GEMINI_CONFIG/skills"

if [ -n "$MOTHER" ]; then
  check_exists "Mother folder" "$MOTHER"
  if [ -d "$MOTHER/000_Agent" ]; then
    check_exists "Arry core layer" "$MOTHER/000_Agent"
    check_exists "Arry work layer" "$MOTHER/100_Todo"
    check_exists "Arry reference layer" "$MOTHER/200_Reference"
  fi
fi

if [ -d "$SKILLS_DIR" ]; then
  while IFS= read -r skill; do
    if ! grep -q "^name:" "$skill" || ! grep -q "^description:" "$skill"; then
      echo "BAD FRONTMATTER: $skill"
      FAIL=$((FAIL+1))
    fi
  done < <(find "$SKILLS_DIR" -maxdepth 2 -name SKILL.md -not -path "*/.system/*" -print)
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  echo "All checks passed."
else
  echo "$FAIL issue(s) found."
  exit 1
fi
```

Cadence:

- manual: create the script only
- weekly: document it in the cockpit or weekly review checklist
- daily scheduled: ask before adding cron/launchd because that changes local machine behavior

## Section F: Migration Manual

Create or update a migration note when the user asks for a durable setup. Suggested location:

- assistant data-layer root: `codex_symlink/MIGRATION.md` for global assistant migration
- Obsidian cockpit summary: `專案庫/<project>/專案工作流程.md`

Suggested sections:

```markdown
# Codex AI Assistant Migration Manual

## Current Architecture

- Mother folder:
- Data-layer root:
- Global core layer:
- Work/reference layers:
- Sync channel:
- GitHub repo:
- Health check:
- Last verified:

## New Computer

1. Install the desired agents and sign in normally; agent installation and assistant-content bootstrap are separate steps.
2. Sync or clone the mother folder.
3. Install chezmoi using the platform-native package manager.
4. Run the bundled Item 16 bootstrap in dry-run mode, then apply it to recreate Codex, Claude, and AntiGravity native entrypoints plus the neutral Python-tools bridge.
5. Run Item 34 to rebuild the local Python runtime; install any optional LazyPack items whose wrappers are needed, then start a new Agent conversation or source the shared environment loader.
6. Log in separately for services that use OAuth or local credentials.
7. Confirm `000_Agent/`, `100_Todo/`, and `200_Reference/` boundaries are still intact.
8. Run `chezmoi status`, `chezmoi doctor`, and the health check.

## Future AI Tool

1. Identify that tool's rule-file convention.
2. Convert project `AGENTS.md` rules instead of copying blindly; put cross-tool global rules in `{{SYNC_ROOT}}/core-rules.md`.
3. Reuse Markdown knowledge and workflows where compatible.
4. Rebuild tool-specific skills in the target format.

## Restore From Backup

- Backup path:
- What it contains:
- What still needs manual login:
```

## Section G: Completion Checklist

Before reporting done, verify:

- backup exists if any risky action was taken
- selected mother/data-layer folder exists
- `000_Agent/`, `100_Todo/`, and `200_Reference/` boundaries remain intact when using the Arry Assistant architecture
- approved portable files exist in expected location
- symlink targets exist if symlinks were used
- the neutral Python-tools bridge points to the device-local runtime and a fresh shell discovers `python-tools-python`
- health check exists and runs if generated
- migration note exists if requested
- `.gitignore` exists before Git staging
- no secrets are staged
- no private memory, drafts, or backups are staged into public `codex_installation`
- Obsidian mirror note is updated if global skills changed
- Codex restart/new conversation requirement is reported when applicable

## Section H: Multi-Agent Compatibility Audit

Use this section when the user wants the same assistant assets available from Codex, Claude, and AntiGravity, or wants to add another agent later.

This is an audit-first flow. Do not change files until the user approves the report.

Check these surfaces:

| Surface | Portable approach |
|---|---|
| Global rules | `{{SYNC_ROOT}}/core-rules.md` remains the source of truth |
| Codex global rules entrypoint | `{{CODEX_HOME}}/AGENTS.md` points to `{{SYNC_ROOT}}/core-rules.md` |
| Claude global rules entrypoint | `{{CLAUDE_HOME}}/CLAUDE.md` points to `{{SYNC_ROOT}}/core-rules.md` |
| AntiGravity global rules entrypoint | `{{GEMINI_HOME}}/GEMINI.md` points to `{{SYNC_ROOT}}/core-rules.md` |
| Global skills | keep portable packages under `{{SYNC_ROOT}}/skills`; link each supported native skills entrypoint |
| Project skills | keep project-only packages under each project's `000_Agent/skills` |
| MCP/tools | convert by intent into the target app's config format; never share incompatible config files directly |
| Memory | store durable preferences and decisions in Markdown under `{{SYNC_ROOT}}/memories` |
| Sessions/logs/auth/cache | keep local; do not sync |
| Project state | use canonical project `AGENTS.md`, required `HANDOFF.md`, and Obsidian cockpit notes |
| Bootstrap state | keep chezmoi templates in `{{CHEZMOI_SOURCE}}`; keep machine-specific `syncRoot` in the local chezmoi config |
| Shared Python commands | rebuild `{{CODEX_HOME}}/python-tools` per computer; manage only its neutral bridge, environment loader, and machine-specific `pythonToolsHome` with chezmoi |

Report each item as one of:

- portable as-is
- convertible with a target-specific adapter
- local-only
- unsafe to sync

For the full checklist and report template, read `references/multi-agent-compatibility.md`.

## Pitfalls Converted From Source

- Backup is mandatory because move plus symlink operations can break the user's assistant setup quickly.
- Obsidian and similar local vault tools often behave best with real files inside the vault, not symlinked targets.
- Sync route should follow device mix and reading habits, not popularity.
- Single-computer users still benefit from portability and versioned backup.
- Private and public GitHub backups need different privacy defaults.
- Health checks should not be cron by default; scheduled checks are local machine configuration and should be opt-in.
- Sync `core-rules.md`, skills, and memory; do not sync app state/cache/credentials.
- Chezmoi's `--promptString` matches the visible prompt text, not the template key; a headless mismatch tries `/dev/tty` and fails.
- Taking over `.zshenv`, `.zprofile`, `.profile`, or `.bash_profile` as whole-file templates can erase unrelated user settings; use the bundled `modify_` scripts to own only the marked loader block.
- A Python venv is not portable across operating systems or home paths. Rebuild it from Item 34 and expose it through the neutral bridge instead of syncing or cloning the runtime.
- `CHEZMOI_SOURCE` in the bundled installer is a script option variable, not a native chezmoi environment variable; direct CLI verification must pass `--source` when using a non-default source.
- Homebrew may spend several minutes auto-updating before the first `brew install chezmoi` prints useful progress.
- Never replace an unexpected physical file or a symlink to a different target automatically; back it up and resolve the conflict first.
- A migration manual is part of portability because future setup context is otherwise lost.

## FAQ Converted To Codex

### I already have Arry Assistant. Does this replace it?

No. Use the existing `codex_symlink` as the global data-layer root. Keep private memory out of the public `codex_installation` repo.

### Should Codex credentials be synced?

No. Each device should log in independently. Do not copy auth tokens or OAuth files.

### Can system skills be synced?

Do not edit or move `.system` skills. They are managed by Codex. Only custom skills should be backed up or mirrored.

### What if iCloud or another sync tool mishandles symlinks?

Prefer real files in the cloud mother folder and local symlinks pointing to those real files. Verify with the health check. If a target is broken, stop and restore from backup rather than guessing.

### What if two computers edit the same memory file?

Expect conflicts. Resolve with file comparison or Git history. Avoid simultaneous edits on multiple machines.

### How should Windows symlinks be handled?

Windows symlinks may require developer mode or administrator permissions. If the user is not comfortable with that, avoid symlinks and use copy/install steps plus Git backup.

### Can the user switch sync providers later?

Yes. Back up first, choose a new mother folder, move only approved portable assets, verify, then update the migration note.

### Can the user publish skills but keep memory private?

Yes. Use separate repos or a strict `.gitignore`. Public repos should exclude personal memory, drafts, journals, people notes, and private files.

## Attribution Note

The source file credits Raymond Hou / 雷蒙 and is licensed CC BY-NC-SA 4.0 for personal use. Keep attribution in derived notes when quoting or redistributing source-derived material. This file is the Codex-specific adapter playbook inside a three-Agent shared skill; Claude and AntiGravity use the companion compatibility references and the same portability contract.
AGENT_LAZYPACK_CROSS_DEVICE_SYNC_REFERENCES_CODEX_PLAYBOOK_MD_4F30E54D07

# cross-device-sync/references/global-settings-spec.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/cross-device-sync/references/global-settings-spec.md")"
cat > "{{SYNC_ROOT}}/skills/cross-device-sync/references/global-settings-spec.md" <<'AGENT_LAZYPACK_CROSS_DEVICE_SYNC_REFERENCES_GLOBAL_SETTINGS_SPEC_MD_8CD5E9DFC7'
# Cross-Agent Global Settings Spec

This reference adapts AI agent global-setting guides into the `cross-device-sync` portability model. Treat source guides for Claude Code, OpenCode, Gemini/AntiGravity, or other agents as source context, not Codex paths to copy literally.

## Agent Surfaces

| Agent | User-level rule/config location | Notes |
| --- | --- | --- |
| Codex App / Codex CLI | `{{CODEX_HOME}}/AGENTS.md`, `{{CODEX_HOME}}/skills`, `{{CODEX_CONFIG}}` | `AGENTS.md` may be a symlink to a portable global rules file. MCP config uses Codex TOML, not Claude/OpenCode JSON. |
| Claude Code | `{{CLAUDE_HOME}}/CLAUDE.md`, `{{CLAUDE_HOME}}/skills/`, `{{CLAUDE_HOME}}/rules/` | `CLAUDE.md` can be a symlink to the shared core rules. A project `CLAUDE.md` should import `AGENTS.md` with `@AGENTS.md` when both agents share the project. |
| OpenCode | `{{HOME}}/.config/opencode/opencode.json`, `instructions/` | JSON must remain valid; do not print full config if it may contain secrets. |
| AntiGravity / Gemini | `{{GEMINI_HOME}}/GEMINI.md`, `{{GEMINI_CONFIG}}/skills/`, `{{GEMINI_CONFIG}}/mcp_config.json` | Current global rule and skills entrypoints are `GEMINI.md` and `config/skills`. Older `config/AGENTS.md` and `config/plugins/codex/skills` may remain as temporary compatibility aliases. |

## Placement Rules

- Cross-agent durable policy belongs in `{{SYNC_ROOT}}/core-rules.md` or another approved shared Markdown policy file.
- Portable global skill packages belong in `{{SYNC_ROOT}}/skills/<skill-name>`; each agent exposes compatible packages through its native global skills entrypoint.
- Project rules belong in project `AGENTS.md`, not in global skills.
- Per-agent live config files are adapters. Keep their format separate and generate or update them only after user approval.
- Do not create a standalone global-settings skill when the content is actually portability, compatibility, or global-rule placement policy; merge it into `cross-device-sync`.
- Create a separate focused skill only when there is a real repeatable operation, deterministic script, or domain workflow that should trigger independently.

## Voice Reply Rules

- Trigger voice reply only when explicitly requested: "用語音回答", "唸出來", "唸給我聽", "用語音講結論".
- Spoken script should be 100-250 Chinese characters when possible.
- Prefer conclusion and next action; keep details in text.
- Ask for female or male before TTS unless the request already specifies it; do not synthesize while gender is unknown.
- Female route: ElevenLabs Anna Su, then Edge-TTS HsiaoChen, then macOS `say`.
- Male route: skip ElevenLabs, then Edge-TTS YunJhe, then macOS `say`.
- Traditional Chinese female profile: `zh-TW-HsiaoChenNeural`.
- Traditional Chinese male profile: `zh-TW-YunJheNeural`.
- Edge-TTS is a cloud TTS service. Do not use it for sensitive text unless the user accepts that boundary.
- Do not substitute voice cloning. Authorized voice cloning belongs to a dedicated skill such as VoxCPM2.

## Speech-To-Text Rules

- Formal transcription uses Groq Whisper `whisper-large-v3-turbo` first.
- Missing or invalid credentials, API/network/quota/model/upload failure, or an
  explicit local-only requirement immediately falls back to local
  faster-whisper `large-v3-turbo`.
- whisper.cpp is only for an explicitly requested fast preview.
- SenseVoice is supplementary for Chinese/Cantonese cross-checks, language,
  emotion, and sound-event tags; it is not the formal subtitle route.
- MacWhisper is the final Whisper option and its timestamps must be validated.
- Python `openai-whisper`, OpenAI Whisper API, HyperFrames' local transcription,
  and other wrappers are not defaults. Use them only for an explicitly
  requested comparison or an approved project-specific exception.
- Use the shared preferred-route adapter for SRT/HyperFrames inputs and report
  the actual engine plus any Groq fallback reason.

## Startup / Shutdown Sync

The shared skill root provides `startup-sync` and `shutdown-sync` for Codex, Claude, and AntiGravity. When adapting source rules:

- `開工` means read project rules and required `HANDOFF.md`, run the guarded chezmoi startup checkpoint, then inspect cockpit, Git/GitHub/hosting state and avoid unasked project writes.
- `收工` means create or update required `HANDOFF.md`, run the chezmoi shutdown checkpoint, summarize changes, sync allowed mirrors, update cockpit, check Git state, and ask before commit/push unless explicitly requested.
- Item 10 owns project initialization/startup/shutdown behavior. Item 16 owns machine bootstrap, agent adapters, chezmoi, and cross-device repair.
- `chezmoi add` is not a routine shutdown action. Use it only for a newly approved bootstrap whitelist entry after adding a portable `.syncRoot` template, backing up, and reviewing the source diff.

## Chezmoi / Dotfiles

- Chezmoi is the required bootstrap and adapter manager for the cross-device profile. Cloud storage or Git still synchronizes the durable content; symlinks remain the live entrypoint mechanism.
- Keep machine-specific `syncRoot` data in the local chezmoi config. The source state stores templates such as `{{ .syncRoot }}/core-rules.md`, not one user's cloud account path.
- Manage Codex, Claude, and AntiGravity entrypoints separately. Never symlink their incompatible MCP, auth, session, cache, or full settings files together.
- Manage one neutral Python command bridge for all three Agents: `{{HOME}}/.local/share/agent-tools/python-tools` points to the device-local runtime, and `{{HOME}}/.config/agent-tools/python-tools.env` adds its `bin` directory to Agent shells.
- Keep `pythonToolsHome` machine-specific in local chezmoi data. Do not sync a venv or hardcode the author's runtime path into the portable source.
- Always run a dry-run/diff, create a timestamped backup, and stop on physical-file or mismatched-symlink conflicts before apply.
- Never add secrets, session files, OAuth tokens, cookies, or local state DBs to dotfiles.
- Do not add a dotfiles remote, commit, or push unless the user explicitly asks. A dirty-source warning from `chezmoi doctor` is expected before the source is intentionally versioned.

### Required install routes

| Platform | Preferred chezmoi installation |
| --- | --- |
| macOS with Homebrew | `brew install chezmoi` |
| Windows native | `winget install twpayne.chezmoi` |
| Linux / WSL | Distribution package manager when current enough; otherwise the official installer into `{{HOME}}/.local/bin` |

Use `cross-device-sync/scripts/bootstrap-agent-sync.sh` on macOS, Linux, or WSL. Its default is dry-run; writes require `--apply`, and automatic chezmoi installation additionally requires `--install-chezmoi`.

### Verified pitfalls

- Homebrew may auto-update before downloading chezmoi, so a quiet period is not automatically a failure. Wait for the final bottle/install result before switching routes.
- `--promptString` matches the visible prompt text, not the stored data key. For the bundled template, headless initialization must pass `--promptString "Portable AI assistant sync root=<path>"` and `--promptString "Local Python tools runtime=<path>"`; using the data keys directly can try to open `/dev/tty` and fail in a headless Agent shell.
- `CHEZMOI_SOURCE` is a LazyPack/script environment variable, not a native chezmoi global flag. Direct CLI verification of an alternate source must use `chezmoi --source <path> ...`.
- Existing physical files or symlinks pointing elsewhere are conflicts. Back them up and resolve them intentionally; do not force-apply over them.
- Do not use a normal chezmoi file template for `.zshenv`, `.zprofile`, `.profile`, or `.bash_profile`; the bundled `modify_` scripts own only the marked Python-tools loader block and preserve existing aliases, key loaders, and environment settings.

## Speech Input Assumptions

Speech-to-text mistakes should be handled by the dedicated `voice-input-normalization` skill. The shared principle is:

- infer obvious low-risk corrections from context
- confirm before acting on ambiguous names, paths, commands, numbers, dates, money, destructive actions, or authorization
- do not silently rewrite critical details into guessed values
AGENT_LAZYPACK_CROSS_DEVICE_SYNC_REFERENCES_GLOBAL_SETTINGS_SPEC_MD_8CD5E9DFC7

# cross-device-sync/references/multi-agent-compatibility.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/cross-device-sync/references/multi-agent-compatibility.md")"
cat > "{{SYNC_ROOT}}/skills/cross-device-sync/references/multi-agent-compatibility.md" <<'AGENT_LAZYPACK_CROSS_DEVICE_SYNC_REFERENCES_MULTI_AGENT_COMPATIBILITY_MD_8767475F57'
# Multi-Agent Compatibility Audit

Use this checklist to keep Codex, Claude, and AntiGravity on the same durable assistant setup.

The goal is not to make every app read the same config folder. The goal is to keep the user's rules, skills, workflows, memory, and migration notes in portable Markdown/packages, then expose each AI agent to those assets through that agent's own supported entrypoints.

## Core Principle

Share durable assets. Convert app-specific settings. Never sync secrets or local runtime state.

Durable assets:

- `SYNC_ROOT/core-rules.md`
- portable skill packages under `SYNC_ROOT/skills`
- reusable memory and preference notes under `SYNC_ROOT/memories`
- workflow notes under `SYNC_ROOT/workflows`
- knowledge indexes under `SYNC_ROOT/knowledge`
- project `AGENTS.md` files and Obsidian project cockpits

Device-local assets:

- Codex `config.toml`
- agent-specific settings files
- plugin manifests and caches
- session databases and logs
- auth files and OAuth tokens
- shell snapshots and temp files
- Python virtual environments, binary wheels, compiled extensions, and model caches

## Audit Steps

### 1. Confirm The Rules Source Of Truth

Check:

```bash
test -f "{{SYNC_ROOT}}/core-rules.md" && echo "core-rules exists"
test -L "{{CODEX_HOME}}/AGENTS.md" && readlink "{{CODEX_HOME}}/AGENTS.md"
```

Expected:

- `{{SYNC_ROOT}}/core-rules.md` exists.
- `{{CODEX_HOME}}/AGENTS.md` points to `{{SYNC_ROOT}}/core-rules.md`.
- There is no separate legacy global rules file competing with `core-rules.md`.

Supported entrypoints:

- Codex uses `{{CODEX_HOME}}/AGENTS.md` and `{{CODEX_HOME}}/skills`.
- Claude Code uses `{{CLAUDE_HOME}}/CLAUDE.md` and `{{CLAUDE_HOME}}/skills`.
- AntiGravity uses `{{GEMINI_HOME}}/GEMINI.md` and `{{GEMINI_CONFIG}}/skills`.
- Older AntiGravity `{{GEMINI_CONFIG}}/AGENTS.md` and `{{GEMINI_CONFIG}}/plugins/codex/skills` may remain as compatibility aliases during a verified migration.
- All three entrypoints point to the same durable `{{SYNC_ROOT}}/core-rules.md` and `{{SYNC_ROOT}}/skills` through their native paths.

If a fourth agent is added later, give it a thin native adapter to the same durable assets after validating its supported formats.

### 2. Classify Skills And Workflows

Check:

```bash
find "{{SYNC_ROOT}}/skills" -maxdepth 2 -name SKILL.md -print | sort
find "{{SYNC_ROOT}}/workflows" -maxdepth 2 -type f -print 2>/dev/null | sort
```

Classification:

| Asset | Default decision |
|---|---|
| Agent Skills-compatible `SKILL.md` package | Portable source, keep under `SYNC_ROOT/skills`; document the three native execution adapters whenever tools or invocation differ |
| Project-only skill | Keep in project `000_Agent/skills` |
| Draft workflow | Keep in `SYNC_ROOT/workflows` until promoted |
| Runtime plugin cache | Local-only, do not sync |
| Agent marketplace install metadata | Local-only or reinstall per app |

Do not symlink project `000_Agent/skills` into the shared global skills source.

### 3. Check MCP And External Tools

MCP settings are usually not directly portable because each app has its own config format and permission model.

Audit:

```bash
test -f "{{CODEX_CONFIG}}" && sed -n '1,220p' "{{CODEX_CONFIG}}"
```

Classify each integration with three adapter columns:

- Codex connector／plugin or Codex TOML MCP route
- Claude connector／plugin, `.mcp.json`, or Claude native config route
- AntiGravity／Gemini connector, MCP config, or native tool route
- shared local CLI route
- approved API route with secret stored outside repo
- browser/manual fallback

Rule: convert settings by intent. Do not symlink one agent's config file into another agent's config location. Every required integration must document all three adapters or an explicit shared fallback.

### 4. Check Memory And Durable Preferences

Portable memory should be human-readable Markdown or structured notes, not raw session history.

Check:

```bash
find "{{SYNC_ROOT}}/memories" -maxdepth 2 -type f -print 2>/dev/null | sort
```

Good candidates:

- durable preferences
- reusable decisions
- project naming conventions
- path rules
- repeated troubleshooting knowledge

Do not sync:

- raw session databases
- private logs
- app telemetry
- generated summaries containing secrets
- OAuth or token caches

### 5. Check Project Rules And Cockpits

For each active project:

- project root has `AGENTS.md`
- Obsidian cockpit exists under the expected project library path
- `AGENTS.md` points to stable project rules, not daily progress
- cockpit carries progress, next actions, and sync notes

Keep the same project `AGENTS.md` as canonical. Claude receives a thin `CLAUDE.md` import; AntiGravity uses the same project contract through its native rule discovery. Do not fork the rules.

Claude Code does not read `AGENTS.md` directly. For a shared project, use a thin project `CLAUDE.md` containing `@AGENTS.md`, then append only genuinely Claude-specific instructions.

### 5.1 Check Chezmoi Ownership

When chezmoi is part of the selected profile, verify:

```bash
chezmoi source-path
chezmoi diff
chezmoi status
chezmoi doctor
```

Expected:

- `diff` and `status` are empty after apply.
- rule and skill entrypoints are managed symlinks pointing to the selected `SYNC_ROOT`.
- the source state contains templates, not a public copy of one user's cloud account path.
- no auth, session, MCP credential, cookie, cache, or local database is managed.
- a dirty working-tree warning is acceptable until the user chooses and authorizes private dotfiles versioning.

### 5.2 Check The Shared Python Command Surface

The runtime is local to each computer, but its command surface is shared by all three Agents:

```bash
test -L "{{HOME}}/.local/share/agent-tools/python-tools"
readlink "{{HOME}}/.local/share/agent-tools/python-tools"
test -f "{{HOME}}/.config/agent-tools/python-tools.env"
zsh -lc 'command -v python-tools-python'
```

Expected:

- the neutral bridge points to the device-local `{{CODEX_HOME}}/python-tools` runtime, or to the explicit machine-local `pythonToolsHome` selected during bootstrap
- `.zshenv`, `.zprofile`, `.profile`, and `.bash_profile` contain one managed loader block while preserving all unrelated shell content
- Codex, Claude, and AntiGravity use the same wrapper names from the neutral bridge; do not build three virtual environments or maintain three divergent wrapper directories
- a new computer installs Item 34 to rebuild the runtime and Item 16 to recreate the bridge; the venv itself is never placed in cloud storage, Git, LazyPack, or Obsidian
- optional wrappers such as `cli-hub`, `taigi-teaching-agent`, and `voice-reply` appear in the same shared `bin` directory after their owning LazyPack items are installed

### 6. Check Commands, Hooks, And Agent Delegation

Do not copy commands or hooks across tools literally.

Classify:

| Source item | Multi-agent route |
|---|---|
| repeated workflow prompt | convert to skill or workflow note |
| one-off prompt | convert to prompt template |
| hook | rewrite only after checking target event model and permissions |
| agent delegation pattern | convert to checklist, validation pass, or explicit subtask only when the target supports it |
| app plugin | reinstall or rebuild for the target app |

### 7. Produce The Report

Use this format:

```text
## 現況摘要
- 專案位置：
- 同步方式：
- Codex 已有：
- 其他 AI agent 可共用：

## 可攜資產
-

## 需要轉換的資產
-

## 不應同步的資產
-

## 風險清單
1.
2.
3.

## 建議修改清單
高優先：
-

中優先：
-

低優先：
-

## 下一步執行計畫
1. 先改哪些檔案：
2. 需要備份哪些檔案：
3. 哪些步驟要等使用者確認：
```

For an audit-only request, do not edit files. For an implementation request, apply the approved compatibility contract and then rerun the deterministic audit.

## Fit With LazyPack Item 16

This audit and the deterministic chezmoi bootstrap belong inside LazyPack Item 16 because they manage machine portability and agent adapters. Project creation, `HANDOFF.md`, startup, and shutdown remain in Item 10.
AGENT_LAZYPACK_CROSS_DEVICE_SYNC_REFERENCES_MULTI_AGENT_COMPATIBILITY_MD_8767475F57

# cross-device-sync/references/source-adaptation.md
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/cross-device-sync/references/source-adaptation.md")"
cat > "{{SYNC_ROOT}}/skills/cross-device-sync/references/source-adaptation.md" <<'AGENT_LAZYPACK_CROSS_DEVICE_SYNC_REFERENCES_SOURCE_ADAPTATION_MD_6047167E40'
# Source Adaptation: Cross-Device Assistant Setup

Source type: external assistant portability guide

The source document described moving an assistant app configuration into a portable user-owned folder, backing it up, linking it back into the app, adding optional GitHub backup, generating a health-check script, and writing a migration manual.

The current version keeps the useful operating model but exposes durable assets through native Claude Code, Codex, and AntiGravity adapters. Chezmoi manages device bootstrap and adapter reconstruction; it does not replace cloud content synchronization.

## Preserved Ideas

- Treat assistant setup as a user-owned portable asset, not a vendor-owned hidden folder.
- Pick the sync route based on device mix, not trendiness.
- Back up before moving files or creating symlinks.
- Keep portable `core-rules.md`, skills, and durable memory separate from machine-local state.
- Use GitHub as optional versioned offsite backup, preferably private.
- Generate health checks and migration notes so future device changes are repeatable.

## Converted Assumptions

| Original source-guide idea | Shared package and three native adapters |
|---|---|
| Source app config root is the main config root | `{{SYNC_ROOT}}` stores durable shared assets; each Agent keeps its own config root |
| Source-specific skills path stores skills | `{{SYNC_ROOT}}/skills` stores shared global packages and all three native entrypoints point to it |
| Source app rule file is the rule file | `AGENTS.md` is the project rule file; cross-tool global rules belong in `{{SYNC_ROOT}}/core-rules.md` |
| Source app command shortcuts are user-facing entry points | Shared metadata and user intent define triggers; native invocation is an adapter |
| Source app delegation format is part of the workflow | Shared task boundaries remain stable; each Agent uses its supported delegation or validation mechanism |
| `000_Agent/` is created by pro-kit 01 | This user's global Arry Assistant data lives under `codex_symlink/`; project-local data may use each project's `000_Agent/` |
| Source examples refer to Raymond/Raymond-Agent | Use Arry Assistant and the user's configured `{{SYNC_ROOT}}` / `{{OBSIDIAN_VAULT}}` placeholders |
| One app folder is the shared source | Keep `{{SYNC_ROOT}}` as the shared content source and use per-agent entrypoint adapters managed by chezmoi |

## Shared Safety And Adapter Changes

- Installing the skill alone must not move or symlink live agent assets. The bundled bootstrap defaults to dry-run and requires explicit `--apply`.
- Any future sync setup must be plan-first and approval-gated because it can affect all three Agent environments.
- The default sync approach for this user should align with Google Drive project folders and Obsidian project cockpits.
- The existing Arry Assistant architecture uses Google Drive `codex_symlink/` as the global layer for `skills/`, `memories/`, `workflows/`, and `knowledge/`; project-local data may still use each project's `000_Agent/`.
- `{{GITHUB_USER}}/{{SETUP_REPO_NAME}}` is public, so private backups and personal memory must not be staged or tracked there.
- System or bundled skills managed by any Agent remain local adapters and should not be edited or moved into the shared source manually.
- Global skill changes must update the Obsidian mirror note at `專案庫/codex_installation/全域 Skills/全域 Skills 同步.md`.

## Interview Questions

Use short Traditional Chinese questions, usually one round:

1. 你要同步的裝置組合是什麼：只有一台、多台 Mac、Mac + Windows、Windows/Linux 為主，或其他？
2. 你想用哪個同步管道：Google Drive、iCloud、Dropbox、OneDrive、GitHub only，或讓 Codex 推薦？
3. 要不要加 GitHub 版本備份：私有 repo、公開 repo、不要、之後再說？
4. 健康檢查要怎麼跑：手動、每週、或排程？

After answers, summarize:

- device mix
- selected sync route
- backup/versioning route
- health-check cadence
- exact paths that would be touched
- exact files excluded for safety

Then wait for user approval before changing state.

## Suggested `.gitignore` Blocks

For private backups:

```gitignore
# Secrets and credentials
.env
.env.*
**/credentials.json
**/*.key
**/.credentials.json
**/token*

# Agent-local or machine state
.codex/tmp/
.codex/cache/
.codex/sessions/
.codex/auth*
.codex/log/
.codex/*.sqlite*
.codex/config.local.toml

# System and build noise
.DS_Store
Thumbs.db
*.log
node_modules/
.venv*/
__pycache__/
```

For public backups, add:

```gitignore
# Personal or private memory
000_Agent/memories/
100_Todo/drafts/
100_Todo/archive/
300_Journal/
500_People/
*.private.md
```

Adjust these blocks to the actual folder layout before writing them.

## Health Check Shape

A cross-agent health check should verify:

- selected mother folder exists
- approved portable files exist
- custom skill folders each contain `SKILL.md`
- `SKILL.md` frontmatter includes `name` and `description`
- symlink targets exist if symlinks are used
- Git repo has a remote if GitHub backup was selected
- ignored sensitive files are not staged

The check should not print secrets, token contents, or private memory contents.

`{{SYNC_ROOT}}/skills` remains the package source of truth. Codex, Claude, and AntiGravity may expose it through their documented global skill entrypoints; those entrypoints are adapters, not additional sources of truth. Project-local skills remain in the project's documented local skill folder.

## Completeness Update

The first installed version summarized the source at a high level. The complete portability conversion now lives in `codex-playbook.md` and covers:

- Section A preflight and four-question interview
- Section B mandatory backup
- Section C sync architecture and provider routes
- Section D private/public GitHub backup guidance
- Section E Codex health-check script shape
- Section F migration manual template
- Section G completion checklist
- Section H multi-agent compatibility audit, adapted from a later cross-tool health-check guide
- pitfalls and FAQ converted from the source app into shared guidance plus Codex, Claude, and AntiGravity adapters

## 2026-06-01 Multi-Agent Compatibility Addition

The later source was reviewed as a portability health-check pattern. Its concepts were converted into a generic multi-agent audit instead of copying one runtime's paths and hooks literally.

Preserved ideas:

- audit before modifying files
- distinguish durable Markdown assets from app-specific settings
- map rules, skills, tools, memory, commands, hooks, and agent delegation separately
- convert settings formats instead of symlinking incompatible app config files
- output risks and suggested next steps before execution

Three-agent compatibility conversion:

- source-specific names are not used as operating surfaces
- `{{SYNC_ROOT}}/core-rules.md` is the cross-agent global rules source of truth
- Codex, Claude, and AntiGravity keep native symlink entrypoints
- `{{SYNC_ROOT}}/skills`, `memories`, `workflows`, and `knowledge` remain the portable assistant data layer
- all three Agents read those durable assets through their own supported entrypoints

## 2026-07-20 Chezmoi And Three-Agent Bootstrap

The architecture was expanded after the user clarified that Claude Code remains a future target and that LazyPack must retain first-install capability even when a tool is not installed on the current computer.

Kept and strengthened:

- chezmoi as the required new-device bootstrap and adapter manager
- symlinks as the final live connection to shared content
- one shared `core-rules.md` and one shared skill-package source
- per-agent native entrypoints for Claude Code, Codex, and AntiGravity
- first-time detection, installation guidance, timestamped backup, dry-run, apply, and verification

Integrated from `mathruffian-dot/cross-device-agent-skills` at the architectural level:

- a small project `HANDOFF.md` for the latest cross-agent session state
- startup reads the handoff before proposing work
- shutdown refreshes the handoff but still requires explicit Git commit/push intent
- project `AGENTS.md` remains canonical; Claude receives a thin `CLAUDE.md` adapter instead of a forked rule set

Do not copy the upstream lowercase paths, `git add .`, Claude-only home assumptions, or commit/push behavior literally.
AGENT_LAZYPACK_CROSS_DEVICE_SYNC_REFERENCES_SOURCE_ADAPTATION_MD_6047167E40

# cross-device-sync/scripts/apply-agent-guardrails.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/apply-agent-guardrails.py")"
cat > "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/apply-agent-guardrails.py" <<'AGENT_LAZYPACK_CROSS_DEVICE_SYNC_SCRIPTS_APPLY_AGENT_GUARDRAILS_PY_C26E39A3E3'
#!/usr/bin/env python3
"""Apply or verify the portable cross-agent guardrails.

Master: <SYNC_ROOT>/skills/cross-device-sync/assets/agent-guardrails.json (no machine-specific paths; ships inside the skill so LazyPack embeds it).
Targets: ~/.claude/settings.json (permissions.deny / permissions.ask)
         ~/.codex/rules/default.rules (arry-dangerous-rules block)

AntiGravity has no command-deny mechanism and is intentionally skipped.
Default is --verify (read-only). Use --apply to write, which backs up first.
"""
from __future__ import annotations
import argparse, json, os, re, shutil, sys, datetime
from pathlib import Path

BLOCK_START = "# >>> arry-dangerous-rules >>>"
BLOCK_END = "# <<< arry-dangerous-rules <<<"


def load_master(sync_root: Path) -> dict:
    p = sync_root / "skills" / "cross-device-sync" / "assets" / "agent-guardrails.json"
    legacy = sync_root / "rules" / "agent-guardrails.json"
    if not p.is_file():
        sys.exit(f"ERROR master not found: {p}")
    if legacy.is_file() and legacy.read_text(encoding="utf-8") != p.read_text(encoding="utf-8"):
        sys.exit(f"ERROR legacy copy at {legacy} differs from the master; merge or delete it before applying")
    return json.loads(p.read_text(encoding="utf-8"))


def wanted(master: dict) -> tuple[list[str], list[str]]:
    forbidden: list[str] = []
    for key, val in master["forbidden"].items():
        if key != "_comment":
            forbidden.extend(val)
    ask = list(master["ask"]["git_publish"])
    return forbidden, ask


def backup(path: Path, backups: Path) -> Path | None:
    if not path.exists():
        return None
    backups.mkdir(parents=True, exist_ok=True)
    stamp = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
    dest = backups / f"{path.name}.bak.{stamp}"
    shutil.copy2(path, dest)
    return dest


def claude_state(path: Path) -> tuple[set[str], set[str]]:
    if not path.is_file():
        return set(), set()
    perms = json.loads(path.read_text(encoding="utf-8")).get("permissions", {})
    strip = lambda x: re.sub(r"^Bash\(|:\*\)$", "", x)
    return {strip(x) for x in perms.get("deny", [])}, {strip(x) for x in perms.get("ask", [])}


def apply_claude(path: Path, forbidden: list[str], ask: list[str]) -> None:
    data = json.loads(path.read_text(encoding="utf-8")) if path.is_file() else {}
    perms = data.setdefault("permissions", {})
    perms["deny"] = [f"Bash({c}:*)" for c in forbidden]
    perms["ask"] = [f"Bash({c}:*)" for c in ask]
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def render_codex_block(master: dict, ask: list[str]) -> str:
    lines = [BLOCK_START,
             "# Generated from cross-device-sync/assets/agent-guardrails.json. Edit the master, not this block."]
    just = {
        "sudo": "權限提升後所有後續指令都不受一般使用者權限限制；請自行在終端機執行。",
        "chmod_777": "777 等於拆掉存取控制；請指定實際需要的權限。",
        "disk": "直接動磁碟區塊，目標打錯即全部資料消失。",
        "git_history": "覆寫遠端歷史或讓未 commit 的工作消失；請先確認並自行執行。",
        "git_clean": "連未追蹤檔案一起刪除；請先確認清單。",
        "system": "中斷所有進行中的工作。",
    }
    for key, cmds in master["forbidden"].items():
        if key == "_comment":
            continue
        for cmd in cmds:
            pat = ", ".join(f'"{t}"' for t in cmd.split())
            lines.append(f'prefix_rule(pattern=[{pat}], decision="forbidden",')
            lines.append(f'    justification="{just.get(key, "危險指令。")}")')
    for cmd in ask:
        pat = ", ".join(f'"{t}"' for t in cmd.split())
        lines.append(f'prefix_rule(pattern=[{pat}], decision="prompt")')
    lines.append(BLOCK_END)
    return "\n".join(lines) + "\n"


def apply_codex(path: Path, block: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    text = path.read_text(encoding="utf-8") if path.is_file() else ""
    if BLOCK_START in text and BLOCK_END in text:
        head, rest = text.split(BLOCK_START, 1)
        _, tail = rest.split(BLOCK_END, 1)
        text = head.rstrip("\n") + "\n\n" + block + tail.lstrip("\n")
    else:
        text = text.rstrip("\n") + "\n\n" + block
    path.write_text(text, encoding="utf-8")


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--sync-root", required=True)
    ap.add_argument("--apply", action="store_true", help="write changes (default is read-only verify)")
    args = ap.parse_args()

    sync_root = Path(args.sync_root).expanduser()
    master = load_master(sync_root)
    forbidden, ask = wanted(master)
    claude = Path.home() / ".claude" / "settings.json"
    codex = Path.home() / ".codex" / "rules" / "default.rules"
    backups = sync_root / "backups"

    print(f"MASTER forbidden={len(forbidden)} ask={len(ask)}")

    have_deny, have_ask = claude_state(claude)
    drift = sorted(set(forbidden) ^ have_deny) + sorted(set(ask) ^ have_ask)

    if args.apply:
        b1 = backup(claude, backups)
        apply_claude(claude, forbidden, ask)
        print(f"APPLIED claude: {claude}  BACKUP={b1}")
        b2 = backup(codex, backups)
        apply_codex(codex, render_codex_block(master, ask))
        print(f"APPLIED codex:  {codex}  BACKUP={b2}")
        print("VERIFY codex with: codex execpolicy check --pretty --rules ~/.codex/rules/default.rules -- <cmd>")
    else:
        print("CLAUDE drift:", drift or "none")
        has_block = codex.is_file() and BLOCK_START in codex.read_text(encoding="utf-8")
        print("CODEX block:", "present" if has_block else "MISSING")
        print("MODE verify-only; rerun with --apply to write")

    print("ANTIGRAVITY skipped: no command-deny mechanism (see knowledge/prompt-defense-baseline.md)")


if __name__ == "__main__":
    main()
AGENT_LAZYPACK_CROSS_DEVICE_SYNC_SCRIPTS_APPLY_AGENT_GUARDRAILS_PY_C26E39A3E3
chmod +x "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/apply-agent-guardrails.py"

# cross-device-sync/scripts/audit-agent-compatibility.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/audit-agent-compatibility.py")"
cat > "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/audit-agent-compatibility.py" <<'AGENT_LAZYPACK_CROSS_DEVICE_SYNC_SCRIPTS_AUDIT_AGENT_COMPATIBILITY_PY_5BE365A65B'
#!/usr/bin/env python3
"""Find wording that turns a shared workflow back into a single-agent default."""

from __future__ import annotations

import argparse
from dataclasses import dataclass
from pathlib import Path
import re
import sys


TEXT_SUFFIXES = {".md", ".py", ".sh", ".toml", ".yaml", ".yml", ".json", ".txt"}
SKIP_PARTS = {".git", ".system", "node_modules", "__pycache__", ".venv", "venv"}


@dataclass(frozen=True)
class Rule:
    label: str
    pattern: re.Pattern[str]


RULES = (
    Rule("single-agent label", re.compile(r"codex" + r"[- /]?only|only\s+" + r"codex", re.I)),
    Rule("single-agent Chinese default", re.compile(r"只(使用|安裝|支援)[^\n]{0,20}" + r"Codex", re.I)),
    Rule("single-agent edition", re.compile(r"Codex\s*App\s*" + r"版", re.I)),
    Rule("single-agent compatibility", re.compile(r"Codex(?:\s*App)?[- ]?" + r"compatible", re.I)),
    Rule("single-agent conversion", re.compile(r"轉成\s*" + r"Codex(?:\s*App)?", re.I)),
    Rule("agent removal wording", re.compile(r"(清除|移除|排除)[^\n]{0,40}" + r"Claude", re.I)),
    Rule("agent exclusion wording", re.compile(r"排除[^\n]{0,40}(Agent|代理)|non[- ]" + r"Codex\s+(agent|routing|skill|path)", re.I)),
    Rule("single-agent profile choice", re.compile(r"Codex only[^\n]{0,80}(Claude only|AntiGravity only)", re.I)),
)


def iter_files(root: Path):
    if root.is_file():
        yield root
        return
    if not root.is_dir():
        return
    for path in sorted(root.rglob("*")):
        if not path.is_file() or path.suffix.lower() not in TEXT_SUFFIXES:
            continue
        if any(part in SKIP_PARTS for part in path.parts):
            continue
        yield path


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Audit shared rules, skills, LazyPack, and notes for single-agent-default wording."
    )
    parser.add_argument("--root", action="append", required=True, help="File or directory to scan; repeatable.")
    args = parser.parse_args()

    findings: list[tuple[Path, int, str]] = []
    scanned: set[Path] = set()
    self_path = Path(__file__).resolve()

    for raw_root in args.root:
        root = Path(raw_root).expanduser().resolve()
        if not root.exists():
            print(f"ERROR missing root: {root}", file=sys.stderr)
            return 2
        for path in iter_files(root):
            resolved = path.resolve()
            if resolved == self_path or resolved in scanned:
                continue
            scanned.add(resolved)
            try:
                lines = path.read_text(encoding="utf-8").splitlines()
            except UnicodeDecodeError:
                continue
            for number, line in enumerate(lines, 1):
                if "Rule(" in line and "re.compile" in line:
                    continue
                for rule in RULES:
                    if rule.pattern.search(line):
                        findings.append((path, number, rule.label))

    print(f"scanned_files={len(scanned)}")
    if findings:
        for path, number, label in findings:
            print(f"{path}:{number}: {label}")
        print(f"findings={len(findings)}")
        return 1

    print("findings=0")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
AGENT_LAZYPACK_CROSS_DEVICE_SYNC_SCRIPTS_AUDIT_AGENT_COMPATIBILITY_PY_5BE365A65B
chmod +x "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/audit-agent-compatibility.py"

# cross-device-sync/scripts/bootstrap-agent-sync.sh
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/bootstrap-agent-sync.sh")"
cat > "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/bootstrap-agent-sync.sh" <<'AGENT_LAZYPACK_CROSS_DEVICE_SYNC_SCRIPTS_BOOTSTRAP_AGENT_SYNC_SH_E2A05A691B'
#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bootstrap-agent-sync.sh --sync-root PATH [options]

Options:
  --agents LIST       Comma-separated: codex,claude,antigravity
                      Default: codex,claude,antigravity
  --source PATH       Chezmoi source directory
                      Default: ~/.local/share/chezmoi
  --backup-root PATH  Backup parent directory.
                      Default: <sync-root>/backups
  --python-tools-home PATH
                      Shared local Python tools runtime
                      Default: $CODEX_HOME/python-tools
  --install-chezmoi   Install chezmoi when missing (requires --apply)
  --apply             Write source templates and apply managed symlinks
  --dry-run           Audit and print the plan only (default)
  -h, --help          Show this help

The script manages AI-agent rule/skill entrypoint symlinks plus one neutral
local Python-tools bridge and shell loader shared by all three Agents. It never
syncs a Python virtual environment, credentials, sessions, caches, MCP configs,
or secrets.
EOF
}

apply=0
install_chezmoi=0
agents="codex,claude,antigravity"
sync_root=""
source_dir="${CHEZMOI_SOURCE:-$HOME/.local/share/chezmoi}"
backup_root="${BACKUP_ROOT:-}"
python_tools_home=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --agents)
      agents="${2:?--agents requires a value}"
      shift 2
      ;;
    --sync-root)
      sync_root="${2:?--sync-root requires a value}"
      shift 2
      ;;
    --source)
      source_dir="${2:?--source requires a value}"
      shift 2
      ;;
    --backup-root)
      backup_root="${2:?--backup-root requires a value}"
      shift 2
      ;;
    --python-tools-home)
      python_tools_home="${2:?--python-tools-home requires a value}"
      shift 2
      ;;
    --install-chezmoi)
      install_chezmoi=1
      shift
      ;;
    --apply)
      apply=1
      shift
      ;;
    --dry-run)
      apply=0
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'ERROR unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [ -z "$sync_root" ]; then
  printf 'ERROR --sync-root is required\n' >&2
  exit 2
fi

case "$sync_root" in
  /*) ;;
  *)
    printf 'ERROR --sync-root must be an absolute path\n' >&2
    exit 2
    ;;
esac

# Keep entrypoint backups on the shared root, matching core-rules and the
# session checkpoint, so every agent and machine restores from one place.
[ -n "$backup_root" ] || backup_root="$sync_root/backups"

if [ ! -f "$sync_root/core-rules.md" ] || [ ! -d "$sync_root/skills" ]; then
  printf 'ERROR sync root must contain core-rules.md and skills/\n' >&2
  exit 1
fi

has_agent() {
  case ",$agents," in
    *",$1,"*) return 0 ;;
    *) return 1 ;;
  esac
}

for agent in codex claude antigravity; do
  if has_agent "$agent"; then
    :
  fi
done

unknown_agents="$(printf '%s' "$agents" | tr ',' '\n' | sed '/^codex$/d; /^claude$/d; /^antigravity$/d; /^$/d')"
if [ -n "$unknown_agents" ]; then
  printf 'ERROR unsupported agent(s): %s\n' "$(printf '%s' "$unknown_agents" | tr '\n' ' ')" >&2
  exit 2
fi

install_chezmoi_now() {
  if command -v chezmoi >/dev/null 2>&1; then
    return
  fi

  if [ "$apply" -ne 1 ] || [ "$install_chezmoi" -ne 1 ]; then
    printf 'MISSING chezmoi; rerun with --install-chezmoi --apply\n'
    return 1
  fi

  case "$(uname -s)" in
    Darwin)
      if command -v brew >/dev/null 2>&1; then
        brew install chezmoi
      else
        printf 'ERROR Homebrew is required for the default macOS install route\n' >&2
        return 1
      fi
      ;;
    Linux)
      if command -v brew >/dev/null 2>&1; then
        brew install chezmoi
      elif command -v curl >/dev/null 2>&1; then
        sh -c "$(curl -fsLS https://get.chezmoi.io/lb)"
        export PATH="$HOME/.local/bin:$PATH"
      else
        printf 'ERROR install curl or use the official package-manager command for chezmoi\n' >&2
        return 1
      fi
      ;;
    MINGW*|MSYS*|CYGWIN*)
      if command -v winget >/dev/null 2>&1; then
        winget install --id twpayne.chezmoi --exact
      else
        printf 'ERROR run in PowerShell: winget install twpayne.chezmoi\n' >&2
        return 1
      fi
      ;;
    *)
      printf 'ERROR unsupported OS; follow https://www.chezmoi.io/install/\n' >&2
      return 1
      ;;
  esac

  command -v chezmoi >/dev/null 2>&1 || {
    printf 'ERROR chezmoi installed but is not available in PATH; restart the shell and rerun\n' >&2
    return 1
  }
}

codex_home="${CODEX_HOME:-$HOME/.codex}"
claude_home="${CLAUDE_HOME:-$HOME/.claude}"
gemini_home="${GEMINI_HOME:-$HOME/.gemini}"
gemini_config="${GEMINI_CONFIG:-$gemini_home/config}"
if [ -z "$python_tools_home" ]; then
  python_tools_home="${PYTHON_TOOLS_HOME:-$codex_home/python-tools}"
fi
case "$python_tools_home" in
  /*) ;;
  *)
    printf 'ERROR --python-tools-home must be an absolute path\n' >&2
    exit 2
    ;;
esac
python_tools_bridge="$HOME/.local/share/agent-tools/python-tools"
python_tools_env="$HOME/.config/agent-tools/python-tools.env"

targets=()
if has_agent codex; then
  targets+=(
    "$codex_home/AGENTS.md|$sync_root/core-rules.md"
    "$codex_home/skills|$sync_root/skills"
  )
  if [ -d "$sync_root/memories" ]; then
    targets+=("$codex_home/memories|$sync_root/memories")
  fi
fi
if has_agent claude; then
  targets+=(
    "$claude_home/CLAUDE.md|$sync_root/core-rules.md"
    "$claude_home/skills|$sync_root/skills"
  )
fi
if has_agent antigravity; then
  targets+=(
    "$gemini_home/GEMINI.md|$sync_root/core-rules.md"
    "$gemini_config/skills|$sync_root/skills"
    "$gemini_config/AGENTS.md|$sync_root/core-rules.md"
    "$gemini_config/plugins/codex/skills|$sync_root/skills"
  )
fi

printf 'Agent sync bootstrap\n'
printf 'MODE=%s\n' "$([ "$apply" -eq 1 ] && printf apply || printf dry-run)"
printf 'AGENTS=%s\n' "$agents"
printf 'SYNC_ROOT=<configured>\n'
printf 'CHEZMOI_SOURCE=<configured>\n'
printf 'PYTHON_TOOLS_HOME=<configured>\n'

conflicts=0
for spec in "${targets[@]}"; do
  target="${spec%%|*}"
  expected="${spec#*|}"
  if [ -L "$target" ]; then
    actual="$(readlink "$target")"
    if [ "$actual" = "$expected" ]; then
      printf 'OK symlink: %s\n' "${target#$HOME/}"
    else
      printf 'CONFLICT symlink target differs: %s\n' "${target#$HOME/}"
      conflicts=$((conflicts + 1))
    fi
  elif [ -e "$target" ]; then
    printf 'CONFLICT physical target exists: %s\n' "${target#$HOME/}"
    conflicts=$((conflicts + 1))
  else
    printf 'CREATE symlink: %s\n' "${target#$HOME/}"
  fi
done

if [ -L "$python_tools_bridge" ]; then
  if [ "$(readlink "$python_tools_bridge")" = "$python_tools_home" ]; then
    printf 'OK Python tools bridge: %s\n' "${python_tools_bridge#$HOME/}"
  else
    printf 'CONFLICT Python tools bridge target differs: %s\n' "${python_tools_bridge#$HOME/}"
    conflicts=$((conflicts + 1))
  fi
elif [ -e "$python_tools_bridge" ]; then
  printf 'CONFLICT physical Python tools bridge exists: %s\n' "${python_tools_bridge#$HOME/}"
  conflicts=$((conflicts + 1))
else
  printf 'CREATE Python tools bridge: %s\n' "${python_tools_bridge#$HOME/}"
fi

if [ -x "$python_tools_home/bin/python-tools-python" ]; then
  printf 'OK Python tools runtime available\n'
else
  printf 'PENDING Python tools runtime; install LazyPack Item 34 on this device\n'
fi

if [ "$conflicts" -gt 0 ]; then
  printf 'ERROR resolve or back up %s conflict(s) before applying\n' "$conflicts" >&2
  exit 1
fi

if [ "$apply" -ne 1 ]; then
  if command -v chezmoi >/dev/null 2>&1; then
    printf 'OK chezmoi: %s\n' "$(chezmoi --version | sed 's/,.*//')"
  else
    printf 'MISSING chezmoi\n'
  fi
  printf 'DRY_RUN complete; no files changed\n'
  exit 0
fi

install_chezmoi_now

stamp="$(date +%Y%m%d-%H%M%S)"
backup_dir="$backup_root/agent-sync-backup-$(hostname -s)-$stamp"
mkdir -p "$backup_dir/entrypoints"
for spec in "${targets[@]}"; do
  target="${spec%%|*}"
  if [ -e "$target" ] || [ -L "$target" ]; then
    safe_name="$(printf '%s' "${target#$HOME/}" | tr '/' '_')"
    cp -a "$target" "$backup_dir/entrypoints/$safe_name"
  fi
done
for target in "$python_tools_bridge" "$python_tools_env" "$HOME/.zshenv" "$HOME/.zprofile" "$HOME/.profile" "$HOME/.bash_profile"; do
  if [ -e "$target" ] || [ -L "$target" ]; then
    safe_name="$(printf '%s' "${target#$HOME/}" | tr '/' '_')"
    cp -a "$target" "$backup_dir/entrypoints/$safe_name"
  fi
done

if [ ! -d "$source_dir/.git" ]; then
  chezmoi init --source "$source_dir"
fi

write_source() {
  path="$1"
  content="$2"
  mkdir -p "$(dirname "$path")"
  if [ -f "$path" ] && [ "$(cat "$path")" != "$content" ]; then
    cp -a "$path" "$backup_dir/$(printf '%s' "${path#$source_dir/}" | tr '/' '_').before"
  fi
  printf '%s\n' "$content" > "$path"
}

config_template='{{- $syncRoot := promptStringOnce . "syncRoot" "Portable AI assistant sync root" -}}
{{- $pythonToolsHome := promptStringOnce . "pythonToolsHome" "Local Python tools runtime" -}}
[data]
    syncRoot = {{ $syncRoot | quote }}
    pythonToolsHome = {{ $pythonToolsHome | quote }}'
write_source "$source_dir/.chezmoi.toml.tmpl" "$config_template"

if has_agent codex; then
  write_source "$source_dir/dot_codex/symlink_AGENTS.md.tmpl" '{{ .syncRoot }}/core-rules.md'
  write_source "$source_dir/dot_codex/symlink_skills.tmpl" '{{ .syncRoot }}/skills'
  if [ -d "$sync_root/memories" ]; then
    write_source "$source_dir/dot_codex/symlink_memories.tmpl" '{{ .syncRoot }}/memories'
  fi
fi
if has_agent claude; then
  write_source "$source_dir/dot_claude/symlink_CLAUDE.md.tmpl" '{{ .syncRoot }}/core-rules.md'
  write_source "$source_dir/dot_claude/symlink_skills.tmpl" '{{ .syncRoot }}/skills'
fi
if has_agent antigravity; then
  write_source "$source_dir/dot_gemini/symlink_GEMINI.md.tmpl" '{{ .syncRoot }}/core-rules.md'
  write_source "$source_dir/dot_gemini/config/symlink_skills.tmpl" '{{ .syncRoot }}/skills'
  write_source "$source_dir/dot_gemini/config/symlink_AGENTS.md.tmpl" '{{ .syncRoot }}/core-rules.md'
  write_source "$source_dir/dot_gemini/config/plugins/codex/symlink_skills.tmpl" '{{ .syncRoot }}/skills'
fi

write_source "$source_dir/dot_local/share/agent-tools/symlink_python-tools.tmpl" '{{ .pythonToolsHome }}'
write_source "$source_dir/dot_config/agent-tools/python-tools.env" '# Shared by Codex, Claude Code, and AntiGravity/Gemini.
# The runtime stays local to each computer; chezmoi manages only this loader.
AGENT_PYTHON_TOOLS_HOME="${AGENT_PYTHON_TOOLS_HOME:-$HOME/.local/share/agent-tools/python-tools}"
export AGENT_PYTHON_TOOLS_HOME
if [ -d "$AGENT_PYTHON_TOOLS_HOME/bin" ]; then
  AGENT_PYTHON_TOOLS_BIN="$AGENT_PYTHON_TOOLS_HOME/bin"
  PATH="$AGENT_PYTHON_TOOLS_BIN$(printf '\''%s'\'' "$PATH" | awk -v managed="$AGENT_PYTHON_TOOLS_BIN" '\''BEGIN { RS = ":" } $0 != managed { printf ":%s", $0 }'\'')"
  export PATH
  unset AGENT_PYTHON_TOOLS_BIN
fi

# Shared machine-local data root. Every agent writes regenerable machine-local
# data here rather than into its own sandbox, so Codex, Claude, and AntiGravity
# can pick up each other work on this computer. Project-scoped work products
# still belong in the project folder, not here.
AGENT_DATA_HOME="${AGENT_DATA_HOME:-$HOME/.local/share/agent-tools}"
export AGENT_DATA_HOME
AGENT_CACHE_HOME="${AGENT_CACHE_HOME:-$AGENT_DATA_HOME/cache}"
export AGENT_CACHE_HOME
AGENT_SHARED_WORK="${AGENT_SHARED_WORK:-$AGENT_DATA_HOME/shared-work}"
export AGENT_SHARED_WORK

# Keep Python bytecode out of synced project folders on every project, not just
# the ones whose scripts remember to set it. A project runtime overrides this
# through: eval "$(project-venv.sh env --project-root .)"
PYTHONPYCACHEPREFIX="${PYTHONPYCACHEPREFIX:-$AGENT_CACHE_HOME/python}"
export PYTHONPYCACHEPREFIX'

profile_modifier='#!/bin/sh
set -eu

awk '\''
BEGIN {
  start = "# >>> agent-python-tools >>>"
  finish = "# <<< agent-python-tools <<<"
  loader = "[ -r \"$HOME/.config/agent-tools/python-tools.env\" ] && . \"$HOME/.config/agent-tools/python-tools.env\""
}
$0 == start {
  starts++
  inside = 1
  next
}
$0 == finish {
  finishes++
  inside = 0
  next
}
!inside {
  lines[++count] = $0
}
END {
  if (starts != finishes || starts > 1 || finishes > 1) {
    print "ERROR malformed agent-python-tools managed block" > "/dev/stderr"
    exit 2
  }
  while (count > 0 && lines[count] == "") {
    count--
  }
  for (i = 1; i <= count; i++) {
    print lines[i]
  }
  if (count > 0) {
    print ""
  }
  print start
  print loader
  print finish
}
'\'''
write_source "$source_dir/modify_dot_zshenv" "$profile_modifier"
write_source "$source_dir/modify_dot_zprofile" "$profile_modifier"
write_source "$source_dir/modify_dot_profile" "$profile_modifier"
write_source "$source_dir/modify_dot_bash_profile" "$profile_modifier"
chmod +x \
  "$source_dir/modify_dot_zshenv" \
  "$source_dir/modify_dot_zprofile" \
  "$source_dir/modify_dot_profile" \
  "$source_dir/modify_dot_bash_profile"

config_path="$(chezmoi dump-config --format=json | sed -n 's/.*"configFile"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)"
if [ -z "$config_path" ] || [ ! -f "$config_path" ]; then
  chezmoi init --source "$source_dir" \
    --promptString "Portable AI assistant sync root=$sync_root" \
    --promptString "Local Python tools runtime=$python_tools_home"
else
  configured_root="$(chezmoi execute-template '{{ .syncRoot }}' 2>/dev/null || true)"
  if [ "$configured_root" != "$sync_root" ]; then
    printf 'ERROR existing chezmoi data.syncRoot differs; update the local config intentionally\n' >&2
    exit 1
  fi
  configured_python_tools="$(chezmoi execute-template '{{ .pythonToolsHome }}' 2>/dev/null || true)"
  if [ -n "$configured_python_tools" ] && [ "$configured_python_tools" != "$python_tools_home" ]; then
    printf 'ERROR existing chezmoi data.pythonToolsHome differs; update the local config intentionally\n' >&2
    exit 1
  fi
fi

if [ -f "$config_path" ] && [ -z "$(chezmoi execute-template '{{ .pythonToolsHome }}' 2>/dev/null || true)" ]; then
  chezmoi init --source "$source_dir" \
    --promptString "Portable AI assistant sync root=$sync_root" \
    --promptString "Local Python tools runtime=$python_tools_home"
fi

chezmoi --source "$source_dir" apply

for spec in "${targets[@]}"; do
  target="${spec%%|*}"
  expected="${spec#*|}"
  if [ ! -L "$target" ] || [ "$(readlink "$target")" != "$expected" ] || [ ! -e "$target" ]; then
    printf 'ERROR verification failed: %s\n' "${target#$HOME/}" >&2
    exit 1
  fi
done

if [ ! -L "$python_tools_bridge" ] || [ "$(readlink "$python_tools_bridge")" != "$python_tools_home" ]; then
  printf 'ERROR Python tools bridge verification failed\n' >&2
  exit 1
fi
if [ ! -f "$python_tools_env" ]; then
  printf 'ERROR Python tools environment loader verification failed\n' >&2
  exit 1
fi
for profile in "$HOME/.zshenv" "$HOME/.zprofile" "$HOME/.profile" "$HOME/.bash_profile"; do
  if ! grep -Fq '# >>> agent-python-tools >>>' "$profile" || \
     ! grep -Fq '# <<< agent-python-tools <<<' "$profile"; then
    printf 'ERROR Python tools profile loader verification failed: %s\n' "${profile#$HOME/}" >&2
    exit 1
  fi
done

if [ -x "$python_tools_home/bin/python-tools-python" ]; then
  if command -v zsh >/dev/null 2>&1; then
    resolved_python_tools="$(zsh -lc 'command -v python-tools-python' 2>/dev/null || true)"
  else
    resolved_python_tools="$(sh -lc '. "$HOME/.profile"; command -v python-tools-python' 2>/dev/null || true)"
  fi
  if [ -z "$resolved_python_tools" ]; then
    printf 'ERROR fresh shell cannot discover python-tools-python\n' >&2
    exit 1
  fi
  "$python_tools_bridge/bin/python-tools-python" -c 'import sys; print(sys.executable)' >/dev/null
  printf 'OK shared Python tools command: python-tools-python\n'
else
  printf 'PENDING shared Python tools command until LazyPack Item 34 is installed\n'
fi

printf 'APPLY complete\n'
printf 'BACKUP=%s\n' "$backup_dir"
printf 'Run: chezmoi diff && chezmoi status && chezmoi doctor\n'
AGENT_LAZYPACK_CROSS_DEVICE_SYNC_SCRIPTS_BOOTSTRAP_AGENT_SYNC_SH_E2A05A691B
chmod +x "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/bootstrap-agent-sync.sh"

# cross-device-sync/scripts/project-venv.sh
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/project-venv.sh")"
cat > "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/project-venv.sh" <<'AGENT_LAZYPACK_CROSS_DEVICE_SYNC_SCRIPTS_PROJECT_VENV_SH_C6AE258E40'
#!/usr/bin/env bash
# Shared project virtualenv entry point for Codex, Claude, and AntiGravity.
#
# A virtualenv pins absolute interpreter paths and holds thousands of tiny
# files, so it is machine-local by nature and must never sit inside a synced
# project folder. On Google Drive, iCloud, or Dropbox the provider evicts cold
# file content and keeps only metadata; the next import then re-downloads the
# tree file by file, which has been measured at minutes per run. Only
# requirements.txt belongs in the project repository.
#
# Every machine and every agent resolves the same path, so no environment
# variable is needed to share a runtime between Codex, Claude, and AntiGravity.

set -euo pipefail

runtime_root="${AGENT_PROJECT_RUNTIMES:-$HOME/.local/share/agent-tools/project-runtimes}"

usage() {
  cat <<'EOF'
Usage: project-venv.sh <command> [options]

Commands:
  path      Print the interpreter path for the project runtime.
  cache     Print the machine-local cache root for the project.
  env       Print shell exports for the runtime and its caches.
            Use as: eval "$(project-venv.sh env --project-root .)"
  ensure    Create the runtime if missing, install requirements, print the path.
  list      List every project runtime on this machine.
  remove    Delete one project runtime (it can always be rebuilt).

Options:
  --project NAME        Runtime name. Default: basename of --project-root.
  --project-root PATH   Project directory. Default: current directory.
  --requirements PATH   Requirements file.
                        Default: <project-root>/200_Reference/scripts/requirements.txt
  --python BIN          Interpreter used to create the venv. Default: python3
  --agent NAME          auto|codex|claude|antigravity. Accepted for cross-agent
                        contract parity; the resolved path is identical for all.
  -h, --help            Show this help.

Runtime root: $AGENT_PROJECT_RUNTIMES, or ~/.local/share/agent-tools/project-runtimes
EOF
}

command_name="${1:-}"
[ "$#" -gt 0 ] && shift || true

project=""
project_root="$PWD"
requirements=""
python_bin="python3"
agent="auto"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --project)       project="${2:?--project requires a name}"; shift 2 ;;
    --project-root)  project_root="${2:?--project-root requires a path}"; shift 2 ;;
    --requirements)  requirements="${2:?--requirements requires a path}"; shift 2 ;;
    --python)        python_bin="${2:?--python requires an interpreter}"; shift 2 ;;
    --agent)         agent="${2:?--agent requires a name}"; shift 2 ;;
    -h|--help)       usage; exit 0 ;;
    *) printf 'ERROR unknown argument: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
done

case "$agent" in
  auto|codex|claude|antigravity) ;;
  *) printf 'ERROR --agent must be auto, codex, claude, or antigravity\n' >&2; exit 2 ;;
esac

case "$command_name" in
  path|cache|env|ensure|list|remove) ;;
  "") usage >&2; exit 2 ;;
  *) printf 'ERROR unknown command: %s\n' "$command_name" >&2; usage >&2; exit 2 ;;
esac

if [ "$command_name" = "list" ]; then
  if [ ! -d "$runtime_root" ]; then
    printf 'RUNTIME_ROOT=%s (none yet)\n' "$runtime_root"
    exit 0
  fi
  printf 'RUNTIME_ROOT=%s\n' "$runtime_root"
  for entry in "$runtime_root"/*/; do
    [ -d "$entry" ] || continue
    name="$(basename "$entry")"
    if [ -x "$entry/.venv/bin/python" ]; then
      printf '  %-32s %s\n' "$name" "$("$entry/.venv/bin/python" --version 2>&1)"
    else
      printf '  %-32s (incomplete)\n' "$name"
    fi
  done
  exit 0
fi

if [ -z "$project" ]; then
  case "$project_root" in
    /*) ;;
    *) project_root="$PWD/$project_root" ;;
  esac
  project="$(basename "$project_root")"
fi

case "$project" in
  ""|*/*|.|..) printf 'ERROR --project must be a plain directory name\n' >&2; exit 2 ;;
esac

venv_dir="$runtime_root/$project/.venv"
venv_python="$venv_dir/bin/python"
# Regenerable caches belong next to the venv, never inside the synced project.
# Work products another agent must resume stay in the project instead.
cache_dir="$runtime_root/$project/cache"

if [ "$command_name" = "remove" ]; then
  if [ -d "$runtime_root/$project" ]; then
    rm -rf "${runtime_root:?}/$project"
    printf 'REMOVED=%s\n' "$runtime_root/$project"
  else
    printf 'REMOVED=none (%s did not exist)\n' "$runtime_root/$project"
  fi
  exit 0
fi

if [ "$command_name" = "path" ]; then
  printf '%s\n' "$venv_python"
  [ -x "$venv_python" ] || { printf 'ERROR runtime missing; run: project-venv.sh ensure --project %s\n' "$project" >&2; exit 1; }
  exit 0
fi

if [ "$command_name" = "cache" ]; then
  printf '%s\n' "$cache_dir"
  exit 0
fi

if [ "$command_name" = "env" ]; then
  printf 'export PROJECT_RUNTIME_HOME=%s\n' "\"$runtime_root/$project\""
  printf 'export PROJECT_VENV_PYTHON=%s\n' "\"$venv_python\""
  printf 'export PROJECT_CACHE_HOME=%s\n' "\"$cache_dir\""
  printf 'export PYTHONPYCACHEPREFIX=%s\n' "\"$cache_dir/python\""
  printf 'export PYTEST_ADDOPTS=%s\n' "\"-o cache_dir=$cache_dir/pytest\""
  exit 0
fi

# ensure
if [ ! -x "$venv_python" ]; then
  command -v "$python_bin" >/dev/null 2>&1 || {
    printf 'ERROR interpreter not found: %s\n' "$python_bin" >&2; exit 1; }
  mkdir -p "$runtime_root/$project"
  "$python_bin" -m venv "$venv_dir"
  printf 'CREATED=%s\n' "$venv_dir"
else
  printf 'EXISTS=%s\n' "$venv_dir"
fi

if [ -z "$requirements" ]; then
  requirements="$project_root/200_Reference/scripts/requirements.txt"
fi

if [ -f "$requirements" ]; then
  "$venv_python" -m pip install --quiet --upgrade pip
  "$venv_python" -m pip install --quiet -r "$requirements"
  printf 'REQUIREMENTS=%s\n' "$requirements"
else
  printf 'REQUIREMENTS=none (%s not found)\n' "$requirements"
fi

mkdir -p "$cache_dir/python" "$cache_dir/pytest"
printf 'CACHE=%s\n' "$cache_dir"
printf 'PYTHON=%s\n' "$venv_python"
"$venv_python" --version
AGENT_LAZYPACK_CROSS_DEVICE_SYNC_SCRIPTS_PROJECT_VENV_SH_C6AE258E40
chmod +x "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/project-venv.sh"

# cross-device-sync/scripts/prune-session-artifacts.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/prune-session-artifacts.py")"
cat > "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/prune-session-artifacts.py" <<'AGENT_LAZYPACK_CROSS_DEVICE_SYNC_SCRIPTS_PRUNE_SESSION_ARTIFACTS_PY_17EFC2D8E4'
#!/usr/bin/env python3
"""Prune session artifacts (backups and regenerable caches) past a retention window.

Scope is a hardcoded whitelist. The script never accepts an arbitrary directory
to delete, and never touches skills/, memories/, knowledge/, 100_Todo/, or any
git working tree.

Retention targets:
  1. <sync-root>/backups/*            entries older than --days
  2. <home>/agent-sync-backup-*       chezmoi checkpoint backups older than --days
  3. __pycache__ directories          always (regenerates on next run)
  4. .DS_Store files                  always (Finder metadata)
  5. the running agent's sandbox      transient state older than --days

Agent sandboxes
---------------
Each agent keeps transient state in its own config root. Only the agent that is
actually running gets swept (--agent auto), because deleting another agent's
state while it is live can corrupt a session in progress. --agent all is
available but must be chosen deliberately.

The per-agent lists below are allowlists of regenerable state. Everything else
in those roots is off limits, in particular the directories that hold real
output or durable data:

  ~/.codex/generated_images, audio-to-md, doc-to-md, vlm-to-md, attachments,
  dictation-history   -- produced work, not scratch
  ~/.codex/sessions, archived_sessions
                      -- referenced by rollout summaries in memories/;
                         archived_sessions needs --include-codex-archives
  ~/.claude/projects  -- interactive-session transcripts (human-origin) and
                         the assistant memory directory; HEADLESS print-mode
                         transcripts (claude -p pipeline calls, plan mode, no
                         human-origin record) ARE swept past the window --
                         they are machine scratch whose results persist in
                         the invoking pipeline's own reports
  runtimes, models, caches, credentials, config, and any symlink

The current session is always protected: entries whose name carries the running
session id are skipped regardless of age.

Orphan media are a decision, not a veto
---------------------------------------
2026-08-26 a cleanup backup turned out to hold the only copy of 49 generated
images: the "cleanup" had moved them out of their live location and nothing put
them back. Deleting the backup would have destroyed real work.

So before removing anything under backups/, every media file inside it is
checked against a live index built from --live-root. A media file counts as
duplicated only when a file with the same name AND the same byte size exists
outside the backup locations.

An entry holding unmatched media is never deleted on the owner's behalf. It is
raised as a pending decision and waits for an explicit answer:

  --interactive           ask about each one, one at a time (default: keep)
  --approve-delete NAME   answer for one entry without a prompt
  --keep-orphans          answer "keep everything" for this run
  --allow-orphan-media    answer "delete everything" for this run

Without an answer the entry is reported as PENDING and left alone, so an
unattended sweep can never quietly resolve it either way.

Usage:
  prune-session-artifacts.py --sync-root PATH [--days 7] [--apply]
"""

from __future__ import annotations

import argparse
import os
import shutil
import sys
import time
from pathlib import Path

MEDIA_SUFFIXES = {
    ".png", ".jpg", ".jpeg", ".gif", ".webp", ".svg", ".heic",
    ".mp4", ".mov", ".m4v", ".webm",
    ".wav", ".m4a", ".mp3", ".aac", ".flac",
    ".srt", ".vtt", ".pdf",
}
SKIP_DIRS = {".git", "node_modules", "__pycache__", ".venv", "venv"}

# Allowlists of regenerable per-agent state. Never widen these to a whole
# config root: these roots also hold produced work, credentials, and runtimes.
AGENT_TARGETS = {
    "claude": {
        "root": lambda: Path.home() / ".claude",
        "globs": [
            "backups/.claude.json.backup.*",
            "shell-snapshots/*",
            "session-env/*",
            "telemetry/*",
            "tasks/*",
            "sessions/*",
        ],
        "session_env": ("CLAUDE_CODE_SESSION_ID", "CLAUDE_CODE_HOST_SESSION_ID"),
    },
    "codex": {
        "root": lambda: Path(os.environ.get("CODEX_HOME") or Path.home() / ".codex"),
        "globs": [
            ".codex-global-state.json.bak",
            ".tmp/*",
            "ambient-suggestions/*",
            "config.toml.bak*",
            "config.toml.backup*",
        ],
        # Opt-in only: rollout summaries in memories/ cite these transcripts by
        # id, and archiving is where sessions/ files end up. Verified 2026-08-27
        # that a transcript MEMORY.md references now lives here.
        "opt_in_globs": {"archives": ["archived_sessions/*"]},
        "session_env": ("CODEX_SESSION_ID",),
    },
    "antigravity": {
        "root": lambda: Path.home() / ".gemini" / "antigravity",
        "globs": ["brain/*"],
        "session_env": ("GEMINI_SESSION_ID", "ANTIGRAVITY_CONVERSATION_ID"),
    },
}
# Never delete these even if a glob would reach them.
AGENT_NEVER = {"plugins.sync.lock", ".gitkeep", ".DS_Store"}
CACHE_ROOT_NAMES = {"agentic_projects"}


def detect_agent() -> str | None:
    """Which agent is running right now? None when it cannot be determined."""
    if os.environ.get("CLAUDECODE") or os.environ.get("CLAUDE_CODE_SESSION_ID"):
        return "claude"
    marker = (os.environ.get("AI_AGENT") or "").lower()
    if "claude" in marker:
        return "claude"
    if "codex" in marker or os.environ.get("CODEX_HOME"):
        return "codex"
    if "antigravity" in marker or "gemini" in marker:
        return "antigravity"
    return None


def current_session_tokens(spec: dict) -> list[str]:
    return [v for name in spec.get("session_env", ()) if (v := os.environ.get(name))]


HEADLESS_PROBE_LINES = 20
HEADLESS_RECENT_GUARD_SECONDS = 30 * 60


def transcript_is_headless(path: Path) -> bool:
    """True only for a print-mode pipeline transcript, never an interactive one.

    A human-driven session records origin {kind: human} on its user turns and
    is protected no matter what mode it ran in.  Headless `claude -p` calls
    (verified against 9,913 pipeline transcripts, 2026-08-28) run in plan mode
    and carry no human-origin record.  Unreadable files are treated as
    interactive: deletion needs positive evidence.
    """
    import json
    permission_mode = None
    try:
        with path.open(encoding="utf-8", errors="replace") as handle:
            for index, line in enumerate(handle):
                if index >= HEADLESS_PROBE_LINES:
                    break
                try:
                    record = json.loads(line)
                except Exception:
                    continue
                origin = record.get("origin")
                if isinstance(origin, dict) and origin.get("kind") == "human":
                    return False
                permission_mode = permission_mode or record.get("permissionMode")
    except OSError:
        return False
    return permission_mode == "plan"


def sweep_claude_headless_transcripts(
    cutoff: float, tokens: list[str], args
) -> tuple[int, int, int]:
    projects_root = Path.home() / ".claude" / "projects"
    if not projects_root.is_dir():
        return 0, 0, 0
    import time as _time
    recent_guard = _time.time() - HEADLESS_RECENT_GUARD_SECONDS
    hits, hit_bytes, kept = [], 0, 0
    for project_dir in sorted(projects_root.iterdir()):
        if not project_dir.is_dir() or project_dir.is_symlink():
            continue
        for entry in sorted(project_dir.glob("*.jsonl")):
            if entry.is_symlink():
                continue
            if any(token and token in entry.name for token in tokens):
                kept += 1
                continue
            try:
                stat = entry.lstat()
            except OSError:
                continue
            if stat.st_mtime >= cutoff or stat.st_mtime >= recent_guard:
                kept += 1
                continue
            if not transcript_is_headless(entry):
                kept += 1
                continue
            hits.append(entry)
            hit_bytes += stat.st_size
    if not hits:
        print(f"    {'KEEP':<13} claude/projects headless transcripts  ({kept} 項保留)")
        return 0, 0, kept
    verb = "DELETE" if args.apply else "WOULD-DELETE"
    print(
        f"    {verb:<13} claude/projects headless transcripts  "
        f"({len(hits)} 項, {human(hit_bytes)}；另保留 {kept} 項)"
    )
    for entry in hits[:3]:
        print(f"                    - {entry.parent.name[:24]}…/{entry.name}")
    if len(hits) > 3:
        print(f"                    … 另外 {len(hits) - 3} 項")
    for entry in hits:
        remove(entry, args.apply)
    return len(hits), hit_bytes, kept


def sweep_agent(agent: str, cutoff: float, args) -> tuple[int, int, int]:
    spec = AGENT_TARGETS[agent]
    root = spec["root"]()
    print(f"  [{agent}] {root}")
    if not root.is_dir():
        print("    (不存在，略過)")
        return 0, 0, 0
    tokens = current_session_tokens(spec)
    removed = removed_bytes = kept = 0
    patterns = list(spec["globs"])
    if args.include_codex_archives:
        for extra in spec.get("opt_in_globs", {}).values():
            patterns.extend(extra)
    elif spec.get("opt_in_globs"):
        print("    SKIP          codex/archived_sessions  "
              "(memories 的 rollout summaries 引用這些逐字稿；要清請加 --include-codex-archives)")
    for pattern in patterns:
        group = pattern.split("/")[0] if "/" in pattern else pattern
        hits, hit_bytes, skipped, current = [], 0, 0, 0
        for entry in sorted(root.glob(pattern)):
            if entry.name in AGENT_NEVER or entry.is_symlink():
                continue
            if any(token and token in entry.name for token in tokens):
                current += 1
                continue
            if newest_mtime(entry) >= cutoff:
                skipped += 1
                continue
            hits.append(entry)
            hit_bytes += tree_size(entry)
        kept += skipped + current
        if not hits:
            if skipped or current:
                note = f"{skipped} 項未達保留期" + (f"、{current} 項為當前 session" if current else "")
                print(f"    {'KEEP':<13} {agent}/{group}  ({note})")
            continue
        verb = "DELETE" if args.apply else "WOULD-DELETE"
        note = f"{len(hits)} 項, {human(hit_bytes)}"
        if skipped or current:
            note += f"（另保留 {skipped + current} 項）"
        print(f"    {verb:<13} {agent}/{group}  ({note})")
        for entry in hits[:3]:
            print(f"                    - {entry.name}")
        if len(hits) > 3:
            print(f"                    … 另外 {len(hits) - 3} 項")
        for entry in hits:
            remove(entry, args.apply)
        removed += len(hits)
        removed_bytes += hit_bytes
    if agent == "claude":
        headless_days = (
            args.headless_transcript_days
            if args.headless_transcript_days is not None
            else args.days
        )
        import time as _time
        headless_cutoff = _time.time() - headless_days * 86400
        t_removed, t_bytes, t_kept = sweep_claude_headless_transcripts(
            headless_cutoff, tokens, args
        )
        removed += t_removed
        removed_bytes += t_bytes
        kept += t_kept
    if removed == 0 and kept == 0:
        print("    (無可清理項目)")
    return removed, removed_bytes, kept


def human(size: float) -> str:
    for unit in ("B", "K", "M", "G"):
        if size < 1024 or unit == "G":
            return f"{size:.0f}{unit}" if unit == "B" else f"{size:.1f}{unit}"
        size /= 1024
    return f"{size:.1f}G"


def tree_size(path: Path) -> int:
    if path.is_file():
        return path.stat().st_size
    total = 0
    for current, directories, filenames in os.walk(path, onerror=lambda _: None):
        directories[:] = [d for d in directories if d not in SKIP_DIRS]
        for name in filenames:
            try:
                total += (Path(current) / name).stat().st_size
            except OSError:
                pass
    return total


def newest_mtime(path: Path) -> float:
    """Newest mtime anywhere inside, so recently touched trees are kept."""
    try:
        newest = path.stat().st_mtime
    except OSError:
        return time.time()
    if path.is_file():
        return newest
    for current, directories, filenames in os.walk(path, onerror=lambda _: None):
        directories[:] = [d for d in directories if d not in SKIP_DIRS]
        for name in list(directories) + filenames:
            try:
                newest = max(newest, (Path(current) / name).stat().st_mtime)
            except OSError:
                pass
    return newest


def media_files(path: Path) -> list[Path]:
    if path.is_file():
        return [path] if path.suffix.lower() in MEDIA_SUFFIXES else []
    found = []
    for current, directories, filenames in os.walk(path, onerror=lambda _: None):
        directories[:] = [d for d in directories if d not in SKIP_DIRS]
        for name in filenames:
            if Path(name).suffix.lower() in MEDIA_SUFFIXES:
                found.append(Path(current) / name)
    return found


def build_live_index(roots: list[Path], excluded: list[Path]) -> set[tuple[str, int]]:
    """Index (name, size) of every media file that lives outside the backup areas."""
    index: set[tuple[str, int]] = set()
    excluded_resolved = [e.resolve() for e in excluded if e.exists()]
    for root in roots:
        if not root.exists():
            continue
        for current, directories, filenames in os.walk(root, onerror=lambda _: None):
            current_path = Path(current)
            directories[:] = [d for d in directories if d not in SKIP_DIRS]
            try:
                resolved = current_path.resolve()
            except OSError:
                continue
            if any(resolved == e or e in resolved.parents for e in excluded_resolved):
                directories[:] = []
                continue
            for name in filenames:
                if Path(name).suffix.lower() not in MEDIA_SUFFIXES:
                    continue
                try:
                    index.add((name, (current_path / name).stat().st_size))
                except OSError:
                    pass
    return index


def orphan_media(entry: Path, live: set[tuple[str, int]]) -> list[Path]:
    orphans = []
    for item in media_files(entry):
        try:
            key = (item.name, item.stat().st_size)
        except OSError:
            continue
        if key not in live:
            orphans.append(item)
    return orphans


def remove(path: Path, apply: bool) -> None:
    if not apply:
        return
    if path.is_dir() and not path.is_symlink():
        shutil.rmtree(path)
    else:
        path.unlink()


def show_orphan(entry: Path, label: str, age_days: float, orphans: list[Path], size: int) -> None:
    print(f"  {'ORPHAN-MEDIA':<13} {label}/{entry.name}  ({age_days:.1f}d, {human(size)})")
    print(f"                  {len(orphans)} 個媒體檔在備份區以外找不到同名同大小的副本：")
    for item in orphans[:8]:
        print(f"                  - {item.name}")
    if len(orphans) > 8:
        print(f"                  … 另外 {len(orphans) - 8} 個")


def ask(entry_name: str) -> str:
    """Ask the owner what to do.

    Returns delete/keep/all-delete/all-keep, or "pending" when no terminal is
    attached: an unattended run must not report a decision nobody made.
    """
    prompt = (
        f"                  刪除 {entry_name}？"
        " [d]刪除 / [k]保留(預設) / [D]全部刪除 / [K]全部保留 > "
    )
    answer = None
    # stdin first: a pty without a controlling terminal cannot open /dev/tty.
    if sys.stdin is not None and sys.stdin.isatty():
        try:
            print(prompt, end="", flush=True)
            answer = sys.stdin.readline()
        except (OSError, KeyboardInterrupt):
            answer = None
    if answer is None:
        try:
            with open("/dev/tty", "r+") as tty:
                tty.write(prompt)
                tty.flush()
                answer = tty.readline()
        except (OSError, KeyboardInterrupt):
            return "pending"
    if answer == "":          # EOF, not an answer
        return "pending"
    return {"d": "delete", "D": "all-delete", "k": "keep", "K": "all-keep"}.get(answer.strip(), "keep")


def sweep(
    entries: list[Path],
    cutoff: float,
    live: set[tuple[str, int]],
    args,
    label: str,
    check_orphans: bool,
) -> tuple[int, int, int, list[Path]]:
    removed = removed_bytes = kept = 0
    pending: list[Path] = []
    blanket = "all-delete" if args.allow_orphan_media else ("all-keep" if args.keep_orphans else None)

    for entry in sorted(entries):
        entry_mtime = newest_mtime(entry)
        age_days = (time.time() - entry_mtime) / 86400
        if entry_mtime >= cutoff:
            print(f"  {'KEEP':<13} {label}/{entry.name}  ({age_days:.1f}d, 未達保留期)")
            kept += 1
            continue

        size = tree_size(entry)
        orphans = orphan_media(entry, live) if check_orphans else []

        if orphans:
            decision = blanket
            if decision is None and entry.name in args.approve_delete:
                decision = "delete"
            if decision is None and args.interactive:
                show_orphan(entry, label, age_days, orphans, size)
                answer = ask(entry.name)
                if answer == "pending":
                    print("                  → 沒有可用的終端機，無法詢問；本次保留待決")
                    pending.append(entry)
                    kept += 1
                    continue
                if answer in ("all-delete", "all-keep"):
                    blanket = answer
                    decision = answer
                else:
                    decision = answer
            elif decision is None:
                show_orphan(entry, label, age_days, orphans, size)
                print("                  → 需要你決定，本次保留（見結尾的處理方式）")
                pending.append(entry)
                kept += 1
                continue

            if decision in ("keep", "all-keep"):
                print(f"  {'KEEP':<13} {label}/{entry.name}  (你選擇保留)")
                kept += 1
                continue
            print(f"  {'APPROVED':<13} {label}/{entry.name}  (你同意刪除 {len(orphans)} 個唯一媒體檔)")

        verb = "DELETE" if args.apply else "WOULD-DELETE"
        print(f"  {verb:<13} {label}/{entry.name}  ({age_days:.1f}d, {human(size)})")
        remove(entry, args.apply)
        removed += 1
        removed_bytes += size
    return removed, removed_bytes, kept, pending


def prune_caches(roots: list[Path], apply: bool) -> tuple[int, int]:
    pycache = 0
    ds_store = 0
    for root in roots:
        if not root.exists():
            continue
        for current, directories, filenames in os.walk(root, topdown=True, onerror=lambda _: None):
            if ".git" in directories:
                directories.remove(".git")
            current_path = Path(current)
            for name in list(directories):
                if name == "__pycache__":
                    remove(current_path / name, apply)
                    directories.remove(name)
                    pycache += 1
            for name in filenames:
                if name == ".DS_Store":
                    remove(current_path / name, apply)
                    ds_store += 1
    return pycache, ds_store


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--sync-root", required=True, help="Shared assistant root holding backups/.")
    parser.add_argument("--days", type=int, default=7, help="Retention window in days (default 7).")
    parser.add_argument(
        "--headless-transcript-days",
        type=int,
        default=None,
        help=(
            "Retention window for headless claude -p transcripts under "
            "~/.claude/projects (default: same as --days; 0 sweeps all)."
        ),
    )
    parser.add_argument("--home", default=os.path.expanduser("~"), help="Home holding agent-sync-backup-* (default $HOME).")
    parser.add_argument("--live-root", action="append", default=[], help="Where live copies may exist; repeatable.")
    parser.add_argument("--apply", action="store_true", help="Actually delete. Without it the run is a dry run.")
    parser.add_argument("--interactive", action="store_true", help="Ask about each orphan-media entry, one at a time.")
    parser.add_argument("--approve-delete", action="append", default=[], metavar="NAME", help="Approve deleting one orphan-media entry by name; repeatable.")
    parser.add_argument("--keep-orphans", action="store_true", help="Answer 'keep' for every orphan-media entry this run.")
    parser.add_argument("--allow-orphan-media", action="store_true", help="Answer 'delete' for every orphan-media entry this run.")
    parser.add_argument("--skip-caches", action="store_true", help="Do not touch __pycache__ and .DS_Store.")
    parser.add_argument("--include-codex-archives", action="store_true",
                        help="Also sweep ~/.codex/archived_sessions. Rollout summaries in memories/ cite these transcripts.")
    parser.add_argument("--agent", default="auto", choices=["auto", "codex", "claude", "antigravity", "all", "none"],
                        help="Which agent sandbox to sweep. 'auto' (default) sweeps only the agent running now.")
    args = parser.parse_args()

    sync_root = Path(args.sync_root).expanduser().resolve()
    if not sync_root.is_dir():
        print(f"ERROR sync-root 不存在：{sync_root}", file=sys.stderr)
        return 1
    if args.days < 1:
        print("ERROR --days 至少為 1", file=sys.stderr)
        return 1
    if args.allow_orphan_media and args.keep_orphans:
        print("ERROR --allow-orphan-media 與 --keep-orphans 互斥", file=sys.stderr)
        return 1

    home = Path(args.home).expanduser()
    backups = sync_root / "backups"
    checkpoint_backups = sorted(home.glob("agent-sync-backup-*"))

    drive = sync_root.parent
    live_roots = [Path(p).expanduser() for p in args.live_root] or [
        sync_root,
        drive / "agentic_projects",
        drive / "secondbrain",
    ]
    cache_roots = [sync_root] + [drive / name for name in CACHE_ROOT_NAMES]

    cutoff = time.time() - args.days * 86400
    mode = "APPLY" if args.apply else "DRY-RUN"
    print(f"MODE={mode}  RETENTION={args.days}d  SYNC_ROOT={sync_root}")

    backup_entries = sorted(backups.iterdir()) if backups.is_dir() else []
    check_orphans = bool(backup_entries) and not args.allow_orphan_media
    live_index: set[tuple[str, int]] = set()
    if check_orphans:
        print("建立 live 媒體索引…", flush=True)
        live_index = build_live_index(live_roots, excluded=[backups] + checkpoint_backups)
        print(f"  索引 {len(live_index)} 個媒體檔")

    total_removed = total_bytes = total_kept = 0
    pending: list[Path] = []

    print(f"[1/4] {backups}")
    if backup_entries:
        r, b, k, p = sweep(backup_entries, cutoff, live_index, args, "backups", check_orphans)
        total_removed, total_bytes, total_kept = total_removed + r, total_bytes + b, total_kept + k
        pending += p
    else:
        print("  (空的，無需處理)")

    print(f"[2/4] {home}/agent-sync-backup-*")
    if checkpoint_backups:
        r, b, k, _ = sweep(checkpoint_backups, cutoff, live_index, args, "home", False)
        total_removed, total_bytes, total_kept = total_removed + r, total_bytes + b, total_kept + k
    else:
        print("  (無)")

    print("[3/4] __pycache__ / .DS_Store")
    if args.skip_caches:
        print("  (--skip-caches，略過)")
    else:
        pycache, ds_store = prune_caches(cache_roots, args.apply)
        verb = "removed" if args.apply else "would-remove"
        print(f"  {verb} __pycache__={pycache} .DS_Store={ds_store}")

    print("[4/4] Agent 沙盒")
    if args.agent == "none":
        print("  (--agent none，略過)")
    else:
        if args.agent == "all":
            agents = list(AGENT_TARGETS)
        elif args.agent == "auto":
            detected = detect_agent()
            agents = [detected] if detected else []
            if detected:
                print(f"  偵測到執行中的 Agent：{detected}（只清這一個；其他 Agent 的狀態可能正在使用）")
            else:
                print("  無法判斷執行中的 Agent，未清任何沙盒。需要時明確指定 --agent")
        else:
            agents = [args.agent]
        for agent in agents:
            r, b, k = sweep_agent(agent, cutoff, args)
            total_removed, total_bytes, total_kept = total_removed + r, total_bytes + b, total_kept + k

    print(f"PRUNED={total_removed} FREED={human(total_bytes)} KEPT={total_kept} PENDING={len(pending)}")

    if pending:
        script = Path(__file__).resolve()
        print()
        print(f"有 {len(pending)} 個項目存著在別處找不到副本的媒體檔，需要你決定去留。")
        print("先看過內容再決定：")
        for entry in pending:
            print(f"  open \"{entry}\"")
        print()
        print("逐一詢問後處理：")
        print(f'  python3 "{script}" --sync-root "{sync_root}" --interactive --apply')
        print("同意刪除其中某一個：")
        print(f'  python3 "{script}" --sync-root "{sync_root}" --approve-delete "{pending[0].name}" --apply')
        print("決定全部留著（本次不再提示）：")
        print(f'  python3 "{script}" --sync-root "{sync_root}" --keep-orphans --apply')

    if not args.apply:
        print("這是 dry run，沒有刪除任何東西。加 --apply 才會實際執行。")
    return 0


if __name__ == "__main__":
    sys.exit(main())
AGENT_LAZYPACK_CROSS_DEVICE_SYNC_SCRIPTS_PRUNE_SESSION_ARTIFACTS_PY_17EFC2D8E4
chmod +x "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/prune-session-artifacts.py"

# cross-device-sync/scripts/scan-unarchived-artifacts.py
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/scan-unarchived-artifacts.py")"
cat > "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/scan-unarchived-artifacts.py" <<'AGENT_LAZYPACK_CROSS_DEVICE_SYNC_SCRIPTS_SCAN_UNARCHIVED_ARTIFACTS_PY_9046016D36'
#!/usr/bin/env python3
"""回報停留在 Agent 私有沙盒、尚未歸檔的任務產物。

core-rules〈跨 Agent 任務生成檔案強制歸檔專案目錄〉要求任務產生的中間檔與成品
必須落在專案資料夾，讓另一個 Agent 或另一台機器接得下去。沙盒只能當本次執行的
暫存。這支腳本在收工時掃描三個 Agent 的沙盒，把「像是任務產物、又還留在沙盒裡」
的檔案列出來。

只回報，不搬也不刪。搬到哪裡要看任務脈絡，那是 Agent 與使用者的判斷，不是腳本的。

明確不列入（不是漏掉，是刻意排除）：
  * Agent 自身的 session 逐字稿與紀錄（`.jsonl`、`.log`）。那是 Agent 的執行紀錄，
    不是任務產物；搬走會讓 --continue／--resume 失效。
  * metadata、cache、鎖檔、`.DS_Store` 等可重生或無意義的附屬檔。
"""

from __future__ import annotations

import argparse
import os
import sys
import time
from pathlib import Path

# 看起來像「任務產物」的副檔名：文件、素材、程式、資料。
ARTIFACT_SUFFIXES = {
    ".md", ".txt", ".html", ".htm", ".pdf", ".csv", ".tsv", ".json", ".yaml", ".yml",
    ".png", ".jpg", ".jpeg", ".gif", ".webp", ".svg", ".heic",
    ".mp3", ".wav", ".m4a", ".aac", ".flac",
    ".mp4", ".mov", ".mkv", ".webm",
    ".docx", ".xlsx", ".pptx", ".key", ".pages", ".numbers",
    ".py", ".sh", ".js", ".ts", ".css", ".sql",
    ".zip", ".tar", ".gz", ".srt", ".vtt",
}

# 即使副檔名符合也要跳過的檔名樣式。
SKIP_NAMES = {".DS_Store", ".gitkeep"}
SKIP_SUFFIX_CHAINS = (".metadata.json", ".lock", ".tmp", ".part")
SKIP_DIR_PARTS = {"__pycache__", ".git", "node_modules", ".venv", "cache", ".cache"}


def agent_roots(home: Path, agent: str) -> list[tuple[str, Path]]:
    """回傳 (agent, 沙盒根目錄)。不存在的路徑由呼叫端過濾。"""
    uid = os.getuid()
    roots: list[tuple[str, Path]] = []
    if agent in ("claude", "all"):
        roots.append(("claude", Path(f"/private/tmp/claude-{uid}")))
        roots.append(("claude", home / ".claude" / "projects"))
    if agent in ("antigravity", "all"):
        roots.append(("antigravity", home / ".gemini" / "antigravity" / "brain"))
        roots.append(("antigravity", home / ".gemini" / "tmp"))
    if agent in ("codex", "all"):
        roots.append(("codex", home / ".codex" / "tmp"))
        roots.append(("codex", home / ".codex" / "generated_images"))
        roots.append(("codex", home / ".codex" / "attachments"))
    return roots


def detect_agent() -> str:
    """猜目前執行中的 Agent；猜不到就掃全部，寧可多報不要漏報。"""
    if os.environ.get("CLAUDE_CODE_SESSION") or os.environ.get("CLAUDECODE"):
        return "claude"
    if os.environ.get("CODEX_HOME") or os.environ.get("CODEX_SESSION_ID"):
        return "codex"
    if os.environ.get("GEMINI_CLI") or os.environ.get("ANTIGRAVITY_SESSION"):
        return "antigravity"
    return "all"


def is_artifact(path: Path) -> bool:
    name = path.name
    if name in SKIP_NAMES or name.startswith("."):
        return False
    if any(name.endswith(chain) for chain in SKIP_SUFFIX_CHAINS):
        return False
    if SKIP_DIR_PARTS & set(path.parts):
        return False
    return path.suffix.lower() in ARTIFACT_SUFFIXES


def scan(root: Path, cutoff: float) -> list[Path]:
    found: list[Path] = []
    for current, directories, filenames in os.walk(root, followlinks=False):
        directories[:] = [d for d in directories if d not in SKIP_DIR_PARTS]
        current_path = Path(current)
        for filename in filenames:
            candidate = current_path / filename
            try:
                if candidate.stat().st_mtime < cutoff:
                    continue
            except OSError:
                continue
            if is_artifact(candidate):
                found.append(candidate)
    return found


def build_live_index(roots: list[Path]) -> set[tuple[str, int]]:
    """(檔名, 大小) 索引。在專案或 Drive 找得到同名同大小的副本，就不算未歸檔。

    沿用 prune-session-artifacts.py 的判準。沙盒裡大量出現的是既有內容的解壓副本或
    驗證用暫存，逐檔列出只會淹沒真正沒歸檔的那幾筆。
    """
    index: set[tuple[str, int]] = set()
    for root in roots:
        if not root.is_dir():
            continue
        for current, directories, filenames in os.walk(root, followlinks=False):
            directories[:] = [d for d in directories if d not in SKIP_DIR_PARTS]
            current_path = Path(current)
            for filename in filenames:
                if Path(filename).suffix.lower() not in ARTIFACT_SUFFIXES:
                    continue
                try:
                    index.add((filename, (current_path / filename).stat().st_size))
                except OSError:
                    continue
    return index


def session_bucket(path: Path) -> Path:
    """把檔案歸到它所屬的 session 暫存目錄，讓輸出以工作為單位而非逐檔。"""
    for parent in path.parents:
        if parent.name in {"scratchpad", "tool-results", "scratch"}:
            return parent
    return path.parent


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--sync-root", required=True, help="共用助手根目錄，同時作為 live 索引來源之一。")
    parser.add_argument("--hours", type=float, default=24.0,
                        help="只看這段時間內改過的檔案，代表本次工作區間。預設 24。")
    parser.add_argument("--agent", default="auto",
                        choices=["auto", "codex", "claude", "antigravity", "all"],
                        help="掃哪個 Agent 的沙盒。auto 會偵測目前執行中的 Agent。")
    parser.add_argument("--live-root", action="append", default=[],
                        help="額外的 live 索引來源，可重複指定。")
    parser.add_argument("--limit", type=int, default=15, help="最多列出幾個目錄群組。預設 15。")
    parser.add_argument("--all-files", action="store_true",
                        help="逐檔列出，不做目錄分組。")
    args = parser.parse_args()

    sync_root = Path(args.sync_root).expanduser()
    if not (sync_root / "core-rules.md").is_file():
        print(f"ERROR sync-root 不含 core-rules.md：{sync_root}", file=sys.stderr)
        return 1
    if args.hours <= 0:
        print("ERROR --hours 必須大於 0", file=sys.stderr)
        return 1

    agent = detect_agent() if args.agent == "auto" else args.agent
    cutoff = time.time() - args.hours * 3600
    home = Path.home()

    candidates: list[tuple[str, Path]] = []
    for owner, root in agent_roots(home, agent):
        if not root.is_dir():
            continue
        for path in scan(root, cutoff):
            candidates.append((owner, path))

    if not candidates:
        print(f"UNARCHIVED=0 AGENT={agent} WINDOW={args.hours:g}h")
        return 0

    drive = sync_root.parent
    live_roots = [Path(p).expanduser() for p in args.live_root] or [
        sync_root,
        drive / "agentic_projects",
        drive / "secondbrain",
    ]
    live = build_live_index(live_roots)

    hits = []
    for owner, path in candidates:
        try:
            size = path.stat().st_size
        except OSError:
            continue
        if (path.name, size) in live:
            continue
        hits.append((owner, path, size))

    skipped = len(candidates) - len(hits)
    print(f"UNARCHIVED={len(hits)} AGENT={agent} WINDOW={args.hours:g}h "
          f"MATCHED_ELSEWHERE={skipped}")
    if not hits:
        print("沙盒內的檔案在專案或 Drive 都找得到副本，沒有未歸檔產物。")
        return 0

    print("以下產物只存在於 Agent 沙盒，core-rules 要求歸檔到專案資料夾後才收工：")
    if args.all_files:
        for owner, path, size in sorted(hits, key=lambda item: item[1])[: args.limit]:
            print(f"  [{owner}] {path}  ({size / 1024:.0f} KB)")
        remaining = len(hits) - args.limit
    else:
        groups: dict[Path, list[tuple[str, Path, int]]] = {}
        for owner, path, size in hits:
            groups.setdefault(session_bucket(path), []).append((owner, path, size))
        ordered = sorted(groups.items(), key=lambda item: -sum(h[2] for h in item[1]))
        for bucket, members in ordered[: args.limit]:
            total = sum(h[2] for h in members) / 1024
            print(f"  [{members[0][0]}] {bucket}")
            print(f"      {len(members)} 個檔案，共 {total:.0f} KB，例如："
                  f" {', '.join(sorted(m[1].name for m in members)[:3])}")
        remaining = len(ordered) - args.limit
    if remaining > 0:
        print(f"  …另有 {remaining} 筆未列出（--limit 可調整，--all-files 可逐檔列出）")
    print()
    print("歸檔落點（core-rules〈落點三分法〉）：")
    print("  中間草稿與工程檔  → <專案>/100_Todo/drafts/<任務名>/")
    print("  正式交付與成品    → <專案>/100_Todo/projects/<任務名>/")
    print("  已完成封存        → <專案>/100_Todo/archive/<類別>/<任務名>/")
    print("純屬本次驗證、不需保留的暫存，說明一句即可；這支腳本只回報，不搬也不刪。")
    return 0


if __name__ == "__main__":
    sys.exit(main())
AGENT_LAZYPACK_CROSS_DEVICE_SYNC_SCRIPTS_SCAN_UNARCHIVED_ARTIFACTS_PY_9046016D36
chmod +x "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/scan-unarchived-artifacts.py"

# cross-device-sync/scripts/session-sync-checkpoint.sh
mkdir -p "$(dirname "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/session-sync-checkpoint.sh")"
cat > "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/session-sync-checkpoint.sh" <<'AGENT_LAZYPACK_CROSS_DEVICE_SYNC_SCRIPTS_SESSION_SYNC_CHECKPOINT_SH_29BFBFC51C'
#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  session-sync-checkpoint.sh --phase startup|shutdown --sync-root PATH [options]

Options:
  --source PATH       Chezmoi source directory.
                      Default: ~/.local/share/chezmoi
  --backup-root PATH  Backup parent used before an automatic update.
                      Default: <sync-root>/backups
  --update            On startup, run chezmoi update only when the source has
                      a commit, a remote, and a clean working tree.
  --prune-days N      Retention window for session artifacts on shutdown.
                      Default: 7
  --no-prune          Skip the shutdown retention sweep entirely.
  --scan-hours N      Window for the shutdown unarchived-artifact scan.
                      Default: 24
  --no-scan           Skip the shutdown unarchived-artifact scan.
  -h, --help          Show this help.

On shutdown the checkpoint prunes session artifacts past the retention window:
<sync-root>/backups entries, ~/agent-sync-backup-* checkpoints, and regenerable
__pycache__ and .DS_Store. A backup holding a media file with no copy anywhere
else is reported as ORPHAN-MEDIA and kept, so a "cleanup" backup that became the
only copy of real work is never swept away.

The checkpoint never runs chezmoi add for existing managed templates. Adding
an already managed symlink can remove its template attribute and hardcode a
machine path. New managed entrypoints must first be added to the bootstrap
whitelist with a portable template and reviewed as a setup change. The shared
Python virtual environment remains local; only its neutral bridge and profile
loader are managed by chezmoi.
EOF
}

phase=""
sync_root=""
source_dir="${CHEZMOI_SOURCE:-$HOME/.local/share/chezmoi}"
backup_root="${BACKUP_ROOT:-}"
run_update=0
prune_days="${PRUNE_DAYS:-7}"
run_prune=1
run_scan=1
scan_hours="${SCAN_HOURS:-24}"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --phase)
      phase="${2:?--phase requires startup or shutdown}"
      shift 2
      ;;
    --sync-root)
      sync_root="${2:?--sync-root requires a path}"
      shift 2
      ;;
    --source)
      source_dir="${2:?--source requires a path}"
      shift 2
      ;;
    --backup-root)
      backup_root="${2:?--backup-root requires a path}"
      shift 2
      ;;
    --prune-days)
      prune_days="${2:?--prune-days requires a number}"
      shift 2
      ;;
    --no-prune)
      run_prune=0
      shift
      ;;
    --scan-hours)
      scan_hours="${2:?--scan-hours requires a number}"
      shift 2
      ;;
    --no-scan)
      run_scan=0
      shift
      ;;
    --update)
      run_update=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'ERROR unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "$phase" in
  startup|shutdown) ;;
  *)
    printf 'ERROR --phase must be startup or shutdown\n' >&2
    exit 2
    ;;
esac

case "$sync_root" in
  /*) ;;
  *)
    printf 'ERROR --sync-root must be an absolute path\n' >&2
    exit 2
    ;;
esac

if [ ! -f "$sync_root/core-rules.md" ] || [ ! -d "$sync_root/skills" ]; then
  printf 'ERROR sync root must contain core-rules.md and skills/\n' >&2
  exit 1
fi

# Keep entrypoint backups on the shared root so all three agents and every
# machine restore from one place, as core-rules requires. Flat naming keeps
# each checkpoint a separate <sync-root>/backups/* entry for the prune sweep.
[ -n "$backup_root" ] || backup_root="$sync_root/backups"

if ! command -v chezmoi >/dev/null 2>&1; then
  printf 'ERROR chezmoi is required; install it through LazyPack Item 16\n' >&2
  exit 1
fi

script_dir="$(cd "$(dirname "$0")" && pwd)"
bootstrap="$script_dir/bootstrap-agent-sync.sh"
if [ ! -x "$bootstrap" ]; then
  printf 'ERROR bootstrap helper is missing or not executable\n' >&2
  exit 1
fi

run_prune_sweep() {
  [ "$phase" = "shutdown" ] || return 0
  if [ "$run_prune" -ne 1 ]; then
    printf 'PRUNE=skipped\n'
    return 0
  fi
  prune_script="$sync_root/skills/cross-device-sync/scripts/prune-session-artifacts.py"
  if [ ! -f "$prune_script" ]; then
    printf 'PRUNE=script-missing\n'
    return 0
  fi
  prune_out="$(python3 "$prune_script" --sync-root "$sync_root" --days "$prune_days" --apply 2>&1 || true)"
  prune_summary="$(printf '%s' "$prune_out" | grep -E '^PRUNED=' | head -1)"
  printf 'PRUNE %s\n' "$prune_summary"
  pending_count="$(printf '%s' "$prune_summary" | sed -n 's/.*PENDING=\([0-9]*\).*/\1/p')"
  if [ -n "$pending_count" ] && [ "$pending_count" -gt 0 ] 2>/dev/null; then
    printf '%s\n' "$prune_out" | grep -E 'ORPHAN-MEDIA' || true
    printf 'PRUNE 需要你決定去留，收工不會代為處理。逐一詢問：\n'
    printf '  python3 "%s" --sync-root "%s" --interactive --apply\n' "$prune_script" "$sync_root"
  fi
}

run_unarchived_scan() {
  [ "$phase" = "shutdown" ] || return 0
  if [ "$run_scan" -ne 1 ]; then
    printf 'UNARCHIVED=skipped\n'
    return 0
  fi
  scan_script="$sync_root/skills/cross-device-sync/scripts/scan-unarchived-artifacts.py"
  if [ ! -f "$scan_script" ]; then
    printf 'UNARCHIVED=script-missing\n'
    return 0
  fi
  scan_out="$(python3 "$scan_script" --sync-root "$sync_root" --hours "$scan_hours" 2>&1 || true)"
  printf '%s\n' "$scan_out" | grep -E '^UNARCHIVED=' | head -1
  scan_count="$(printf '%s' "$scan_out" | sed -n 's/^UNARCHIVED=\([0-9]*\).*/\1/p' | head -1)"
  if [ -n "$scan_count" ] && [ "$scan_count" -gt 0 ] 2>/dev/null; then
    printf '%s\n' "$scan_out" | sed -n '2,$p'
  fi
}

printf 'Session sync checkpoint\n'
printf 'PHASE=%s\n' "$phase"
printf 'SYNC_ROOT=<configured>\n'
printf 'CHEZMOI_SOURCE=<configured>\n'

"$bootstrap" \
  --sync-root "$sync_root" \
  --source "$source_dir" \
  --dry-run

status_output="$(chezmoi --source "$source_dir" status)"
if [ -n "$status_output" ]; then
  printf 'CHEZMOI_STATUS=changes-detected\n'
  printf '%s\n' "$status_output"
else
  printf 'CHEZMOI_STATUS=clean\n'
fi

if [ "$phase" != "startup" ] || [ "$run_update" -ne 1 ]; then
  printf 'CHEZMOI_UPDATE=not-requested\n'
  printf 'CHEZMOI_ADD=not-needed-for-existing-templates\n'
guardrails_script="$sync_root/skills/cross-device-sync/scripts/apply-agent-guardrails.py"
if [ -f "$guardrails_script" ]; then
  guardrails_out="$(python3 "$guardrails_script" --sync-root "$sync_root" 2>&1 || true)"
  printf 'GUARDRAILS %s\n' "$(printf '%s' "$guardrails_out" | grep -E '^CLAUDE drift:|^CODEX block:' | tr '\n' ' ')"
else
  printf 'GUARDRAILS=script-missing\n'
fi
  run_prune_sweep
  run_unarchived_scan
  exit 0
fi

skip_update() {
  printf 'CHEZMOI_UPDATE=skipped:%s\n' "$1"
  printf 'CHEZMOI_ADD=not-needed-for-existing-templates\n'
guardrails_script="$sync_root/skills/cross-device-sync/scripts/apply-agent-guardrails.py"
if [ -f "$guardrails_script" ]; then
  guardrails_out="$(python3 "$guardrails_script" --sync-root "$sync_root" 2>&1 || true)"
  printf 'GUARDRAILS %s\n' "$(printf '%s' "$guardrails_out" | grep -E '^CLAUDE drift:|^CODEX block:' | tr '\n' ' ')"
else
  printf 'GUARDRAILS=script-missing\n'
fi
  exit 0
}

if [ ! -d "$source_dir/.git" ]; then
  skip_update 'no-git-source'
fi

if ! git -C "$source_dir" rev-parse --verify HEAD >/dev/null 2>&1; then
  skip_update 'no-source-commit'
fi

if [ -n "$(git -C "$source_dir" status --porcelain)" ]; then
  skip_update 'source-dirty'
fi

remote_name="$(git -C "$source_dir" remote | head -1)"
if [ -z "$remote_name" ]; then
  skip_update 'no-remote'
fi

stamp="$(hostname -s)-$(date +%Y%m%d-%H%M%S)"
backup_dir="$backup_root/agent-sync-backup-$stamp/session-startup"
mkdir -p "$backup_dir"

entrypoints=(
  "$HOME/.codex/AGENTS.md"
  "$HOME/.codex/skills"
  "$HOME/.codex/memories"
  "$HOME/.claude/CLAUDE.md"
  "$HOME/.claude/skills"
  "$HOME/.gemini/GEMINI.md"
  "$HOME/.gemini/config/AGENTS.md"
  "$HOME/.gemini/config/skills"
  "$HOME/.gemini/config/plugins/codex/skills"
  "$HOME/.local/share/agent-tools/python-tools"
  "$HOME/.config/agent-tools/python-tools.env"
  "$HOME/.zshenv"
  "$HOME/.zprofile"
  "$HOME/.profile"
  "$HOME/.bash_profile"
)

for target in "${entrypoints[@]}"; do
  if [ -e "$target" ] || [ -L "$target" ]; then
    safe_name="$(printf '%s' "${target#$HOME/}" | tr '/' '_')"
    cp -a "$target" "$backup_dir/$safe_name"
  fi
done

printf 'CHEZMOI_UPDATE=running\n'
chezmoi --source "$source_dir" update

"$bootstrap" \
  --sync-root "$sync_root" \
  --source "$source_dir" \
  --dry-run

status_output="$(chezmoi --source "$source_dir" status)"
if [ -n "$status_output" ]; then
  printf 'ERROR chezmoi status is not clean after update\n' >&2
  printf '%s\n' "$status_output" >&2
  printf 'BACKUP=%s\n' "$backup_dir" >&2
  exit 1
fi

printf 'CHEZMOI_UPDATE=complete\n'
printf 'BACKUP=%s\n' "$backup_dir"
printf 'CHEZMOI_ADD=not-needed-for-existing-templates\n'
guardrails_script="$sync_root/skills/cross-device-sync/scripts/apply-agent-guardrails.py"
if [ -f "$guardrails_script" ]; then
  guardrails_out="$(python3 "$guardrails_script" --sync-root "$sync_root" 2>&1 || true)"
  printf 'GUARDRAILS %s\n' "$(printf '%s' "$guardrails_out" | grep -E '^CLAUDE drift:|^CODEX block:' | tr '\n' ' ')"
else
  printf 'GUARDRAILS=script-missing\n'
fi
AGENT_LAZYPACK_CROSS_DEVICE_SYNC_SCRIPTS_SESSION_SYNC_CHECKPOINT_SH_29BFBFC51C
chmod +x "{{SYNC_ROOT}}/skills/cross-device-sync/scripts/session-sync-checkpoint.sh"

test -f "{{SYNC_ROOT}}/skills/cross-device-sync/SKILL.md" && echo "cross-device-sync installed for Codex, Claude, and AntiGravity"
````

安裝完成後，請開新 Agent 對話或重啟對應 App，再測試 skill 是否能被讀取。

<!-- END EMBEDDED_SKILLS -->
