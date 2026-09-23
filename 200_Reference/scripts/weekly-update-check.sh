#!/usr/bin/env bash
# Weekly update check for every locally installed CLI, MCP runtime and app.
#
# Scope (decided 2026-09-23): all Homebrew formulae and casks (including
# auto-updating ones), every global npm package, uv-managed tools and Pythons,
# the Google Workspace MCP runtime, and the shared Python tools runtime.
# Every update is applied, major versions included.
#
# Slow downloads: cask archives are pre-fetched with a resumable curl and
# verified against Homebrew's published SHA-256 before `brew upgrade` runs, so
# a throttled CDN cannot stall or corrupt an install.
#
# Running GUI apps whose cask is being upgraded are quit through AppleScript
# (a normal quit, never a force kill) and reopened afterwards.
#
# Usage:
#   weekly-update-check.sh --dry-run   # report only, change nothing (default)
#   weekly-update-check.sh --apply     # install updates
#   weekly-update-check.sh --apply --report-dir DIR
#
# Never runs sudo. Exit code 0 = finished, 1 = at least one step failed.

set -uo pipefail

MODE="dry-run"
REPORT_DIR="${WEEKLY_UPDATE_REPORT_DIR:-${AGENT_DATA_HOME:-$HOME/.local/share/agent-tools}/weekly-update-check}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_MCP_INSTALLER="$SCRIPT_DIR/../lazy-pack/02-assets/google-workspace-mcp/install_google_workspace_mcp.sh"
PYTHON_TOOLS_INSTALLER="$SCRIPT_DIR/python-tools/install_python_tools.sh"
PYTHON_TOOLS_VERIFIER="$SCRIPT_DIR/python-tools/verify_python_tools.py"
LAUNCH_AGENT_LABEL="com.lazy-pack.google-workspace-mcp"
MCP_URL="http://127.0.0.1:8000/mcp"

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) MODE="dry-run" ;;
    --apply) MODE="apply" ;;
    --report-dir) REPORT_DIR="${2:?--report-dir requires a path}"; shift ;;
    *) printf 'Unknown argument: %s\n' "$1" >&2; exit 2 ;;
  esac
  shift
done

[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="$HOME/.local/bin:$HOME/.codex/python-tools/bin:$PATH"

mkdir -p "$REPORT_DIR"
STAMP="$(date +%Y%m%d-%H%M%S)"
REPORT="$REPORT_DIR/$STAMP-$MODE.md"
LOCK="$REPORT_DIR/.lock"
FAILURES=0
REOPEN_APPS=()

if ! mkdir "$LOCK" 2>/dev/null; then
  printf 'Another run holds %s; exiting.\n' "$LOCK" >&2
  exit 1
fi
trap 'rmdir "$LOCK" 2>/dev/null' EXIT

say() { printf '%s\n' "$*" | tee -a "$REPORT"; }
log() { printf '[weekly-update] %s\n' "$*" >&2; }
step_failed() { FAILURES=$((FAILURES + 1)); say "- ⛔ $1"; }
applying() { [ "$MODE" = "apply" ]; }

say "# 每週更新檢查 $STAMP"
say ""
say "模式：\`$MODE\`／主機：$(scutil --get ComputerName 2>/dev/null || hostname)"
say ""

# ---------------------------------------------------------------- Homebrew ---
say "## Homebrew"
say ""
if command -v brew >/dev/null 2>&1; then
  brew update >/dev/null 2>&1 || log "brew update reported an error; continuing with cached metadata"
  outdated_formulae="$(brew outdated --formula --quiet 2>/dev/null)"
  outdated_casks="$(brew outdated --cask --greedy --quiet 2>/dev/null)"
  say "落後的 formula：$(printf '%s' "$outdated_formulae" | grep -c . || true) 個"
  say "落後的 cask：$(printf '%s' "$outdated_casks" | grep -c . || true) 個"
  say ""
  [ -n "$outdated_formulae" ] && say '```' && say "$outdated_formulae" && say '```' && say ""
  [ -n "$outdated_casks" ] && say '```' && say "$outdated_casks" && say '```' && say ""

  # Pre-fetch each outdated cask so a slow CDN cannot stall `brew upgrade`.
  prefetch_cask() {
    local token="$1" meta url sha base cache part total got
    meta="$(brew info --cask --json=v2 "$token" 2>/dev/null)" || return 1
    read -r url sha < <(printf '%s' "$meta" | python3 -c "
import sys, json
c = json.load(sys.stdin)['casks'][0]
print(c.get('url') or '', c.get('sha256') or '')
") || return 1
    [ -n "$url" ] || return 1
    case "$sha" in ''|no_check) log "$token has no published checksum; letting brew fetch it"; return 1 ;; esac
    base="$(python3 -c "
import hashlib, sys, os, urllib.parse
url = sys.argv[1]
name = os.path.basename(urllib.parse.urlparse(url).path)
print(hashlib.sha256(url.encode()).hexdigest() + '--' + name)
" "$url")"
    cache="$HOME/Library/Caches/Homebrew/downloads/$base"
    part="$cache.incomplete"
    if [ -f "$cache" ] && [ "$(shasum -a 256 "$cache" | awk '{print $1}')" = "$sha" ]; then
      return 0
    fi
    total="$(curl -sIL --max-time 60 "$url" | tr -d '\r' | awk 'tolower($1)=="content-length:"{s=$2} END{print s}')"
    [ -n "$total" ] || return 1
    mkdir -p "$(dirname "$part")"
    for attempt in 1 2 3 4 5 6 7 8 9 10; do
      [ -f "$part" ] && [ "$(stat -f %z "$part")" -ge "$total" ] && break
      log "$token: resumable download attempt $attempt"
      curl --location --fail --retry 5 --retry-delay 5 --retry-all-errors \
           --speed-time 120 --speed-limit 1024 \
           --continue-at - --output "$part" "$url" && break
      sleep 15
    done
    [ -f "$part" ] && [ "$(stat -f %z "$part")" -eq "$total" ] || return 1
    got="$(shasum -a 256 "$part" | awk '{print $1}')"
    if [ "$got" != "$sha" ]; then
      log "$token: checksum mismatch, discarding pre-fetch"
      rm -f "$part"
      return 1
    fi
    mv "$part" "$cache"
    return 0
  }

  # Quit any running GUI app that belongs to an outdated cask; reopen later.
  quit_apps_for_cask() {
    local token="$1" app
    while IFS= read -r app; do
      [ -n "$app" ] || continue
      local name="${app%.app}"
      if pgrep -x "$name" >/dev/null 2>&1; then
        log "quitting $name for cask $token"
        osascript -e "tell application \"$name\" to quit" >/dev/null 2>&1
        for _ in $(seq 1 20); do pgrep -x "$name" >/dev/null 2>&1 || break; sleep 2; done
        if pgrep -x "$name" >/dev/null 2>&1; then
          say "- ⚠️ $name 沒有在 40 秒內關閉，跳過 $token，不強制結束"
          return 1
        fi
        REOPEN_APPS+=("$name")
      fi
    done < <(brew info --cask --json=v2 "$token" 2>/dev/null | python3 -c "
import sys, json
for artifact in json.load(sys.stdin)['casks'][0].get('artifacts', []):
    for app in (artifact.get('app') or []) if isinstance(artifact, dict) else []:
        if isinstance(app, str):
            print(app)
")
    return 0
  }

  if applying; then
    if [ -n "$outdated_formulae" ]; then
      if brew upgrade --formula >>"$REPORT.brew.log" 2>&1; then
        say "- ✅ formula 已升級"
      else
        step_failed "formula 升級失敗，詳見 $REPORT.brew.log"
      fi
    fi
    for token in $outdated_casks; do
      prefetch_cask "$token" || log "$token: pre-fetch skipped; brew will download it"
      if ! quit_apps_for_cask "$token"; then
        step_failed "$token 因為 App 無法正常關閉而略過"
        continue
      fi
      if brew upgrade --cask --greedy "$token" >>"$REPORT.brew.log" 2>&1; then
        say "- ✅ cask $token 已升級"
      else
        step_failed "cask $token 升級失敗，詳見 $REPORT.brew.log"
      fi
    done
    for name in "${REOPEN_APPS[@]:-}"; do
      [ -n "$name" ] || continue
      open -a "$name" >/dev/null 2>&1 && say "- ↩️ 已重新開啟 $name"
    done
  fi
else
  step_failed "找不到 brew"
fi
say ""

# --------------------------------------------------------------------- npm ---
say "## npm 全域套件"
say ""
# npm 12+ blocks dependency install scripts unless the package is listed in
# allow-scripts. These are the packages our global CLIs need (netlify-cli,
# wrangler, gemini-cli, firebase-tools and their native deps). Add a name here
# when the report shows a new "install scripts blocked" warning. npm 11 ignores
# the flag.
NPM_ALLOW_SCRIPTS="netlify-cli,esbuild,workerd,fsevents,sharp,unix-dgram,node-pty,@github/keytar,protobufjs,re2"
if command -v npm >/dev/null 2>&1; then
  npm_outdated="$(npm -g outdated --json 2>/dev/null | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
except Exception:
    data = {}
for name, info in data.items():
    print(f\"{name} {info.get('current','?')} -> {info.get('latest','?')}\")
")"
  if [ -n "$npm_outdated" ]; then
    say '```'; say "$npm_outdated"; say '```'; say ""
    if applying; then
      while IFS= read -r line; do
        pkg="${line%% *}"
        [ -n "$pkg" ] || continue
        npm_out="$(npm install -g --allow-scripts="$NPM_ALLOW_SCRIPTS" "$pkg@latest" 2>&1)"
        npm_rc=$?
        printf '%s\n' "$npm_out" >>"$REPORT.npm.log"
        if [ "$npm_rc" -eq 0 ]; then
          say "- ✅ $pkg 已升級"
          blocked="$(printf '%s\n' "$npm_out" | awk '/install scripts blocked/{f=1;next} f&&/^npm warn install-scripts   [^ ]/{print $4} f&&!/^npm warn install-scripts/{f=0}' | sort -u | tr '\n' ' ')"
          if [ -n "$blocked" ]; then
            say "  - ⚠️ 安裝腳本仍被擋：$blocked（確認可信後加進 NPM_ALLOW_SCRIPTS 再重跑）"
          fi
        else
          step_failed "npm $pkg 升級失敗，詳見 $REPORT.npm.log"
        fi
      done <<<"$npm_outdated"
    fi
  else
    say "全部已是最新。"
  fi
else
  step_failed "找不到 npm"
fi
say ""

# ---------------------------------------------------------------------- uv ---
say "## uv 工具與 Python"
say ""
if command -v uv >/dev/null 2>&1; then
  say '```'; say "$(uv tool list 2>/dev/null | grep -v '^-' || true)"; say '```'; say ""
  if applying; then
    if uv tool upgrade --all >>"$REPORT.uv.log" 2>&1; then
      say "- ✅ uv 工具已升級"
    else
      step_failed "uv tool upgrade 失敗，詳見 $REPORT.uv.log"
    fi
    # Upgrade every uv-managed minor series in place (venvs follow the symlink).
    while IFS= read -r series; do
      [ -n "$series" ] || continue
      uv python upgrade "$series" >>"$REPORT.uv.log" 2>&1 \
        && say "- ✅ uv Python $series 已檢查／升級" \
        || step_failed "uv python upgrade $series 失敗"
    done < <(uv python list --only-installed 2>/dev/null \
             | awk '{print $1}' | sed -n 's/^cpython-\([0-9]*\.[0-9]*\)\..*/\1/p' | sort -u)
  fi
else
  step_failed "找不到 uv"
fi
say ""

# ------------------------------------------- shared Python tools (Item 34) ---
# brew/npm/uv above never touch this runtime: Auto-Editor, the Groq and
# ElevenLabs SDKs and OpenCC live inside the Item 34 venv, so they only move
# when its installer runs (it always resolves the newest release).
say "## 共用 Python 工具包（Item 34）"
say ""
if [ -f "$PYTHON_TOOLS_INSTALLER" ]; then
  if applying; then
    if bash "$PYTHON_TOOLS_INSTALLER" >>"$REPORT.pythontools.log" 2>&1; then
      say "- ✅ 安裝器完成（Auto-Editor 與 venv 內套件一律取最新版）"
      if command -v auto-editor >/dev/null 2>&1; then
        say "- auto-editor：$(auto-editor --version 2>&1 | head -1)"
      fi
    else
      step_failed "共用 Python 工具包安裝器失敗，詳見 $REPORT.pythontools.log"
    fi
  else
    say "（dry-run：不執行安裝器）"
  fi
else
  step_failed "找不到安裝器：$PYTHON_TOOLS_INSTALLER"
fi
say ""

# ------------------------------------------------- Google Workspace MCP ------
say "## Google Workspace MCP"
say ""
if [ -f "$WORKSPACE_MCP_INSTALLER" ]; then
  if applying; then
    if bash "$WORKSPACE_MCP_INSTALLER" >>"$REPORT.mcp.log" 2>&1; then
      say "- ✅ 安裝器完成（一律取最新版，並重啟 LaunchAgent）"
    else
      step_failed "Google Workspace MCP 安裝器失敗，詳見 $REPORT.mcp.log"
    fi
  else
    say "（dry-run：不執行安裝器）"
  fi
else
  step_failed "找不到安裝器：$WORKSPACE_MCP_INSTALLER"
fi
say ""

# ------------------------------------------------------------ verification ---
say "## 驗證"
say ""
if applying; then
  launchctl kickstart -k "gui/$UID/$LAUNCH_AGENT_LABEL" >/dev/null 2>&1
  for _ in $(seq 1 20); do
    lsof -nP -iTCP:8000 -sTCP:LISTEN >/dev/null 2>&1 && break
    sleep 3
  done
fi
if lsof -nP -iTCP:8000 -sTCP:LISTEN >/dev/null 2>&1; then
  say "- ✅ Google Workspace MCP 正在監聽 $MCP_URL"
else
  step_failed "Google Workspace MCP 沒有在監聽 $MCP_URL"
fi

if [ -f "$PYTHON_TOOLS_VERIFIER" ]; then
  if python3 "$PYTHON_TOOLS_VERIFIER" >>"$REPORT.verify.log" 2>&1; then
    say "- ✅ 共用 Python 工具包驗證通過"
  else
    step_failed "共用 Python 工具包驗證失敗，詳見 $REPORT.verify.log"
  fi
fi

if command -v claude >/dev/null 2>&1; then
  claude_mcp="$(claude mcp list 2>/dev/null | grep -cE '✔' || true)"
  claude_bad="$(claude mcp list 2>/dev/null | grep -cE '✘' || true)"
  say "- Claude MCP：$claude_mcp 個連線正常，$claude_bad 個失敗"
  [ "${claude_bad:-0}" -gt 0 ] && step_failed "有 Claude MCP 連線失敗"
fi
if command -v codex >/dev/null 2>&1; then
  say "- Codex CLI：$(codex --version 2>/dev/null)"
fi
if command -v heptabase >/dev/null 2>&1; then
  hb_cli="$(heptabase --version 2>/dev/null)"
  hb_skill="$(sed -n 's/.*heptabase-cli-version-range: *"\([^"]*\)".*/\1/p' \
    "${SYNC_ROOT:-$HOME/.codex}/skills/heptabase-cli/SKILL.md" 2>/dev/null)"
  say "- Heptabase CLI $hb_cli／skill 相容範圍 ${hb_skill:-未知}"
  if [ -z "$hb_skill" ]; then
    say "- ⚠️ 讀不到 skill 的 heptabase-cli-version-range，無法比對相容範圍"
  else
    case "$hb_cli" in
      "${hb_skill%.x}".*) : ;;
      *) say "- ⚠️ Heptabase CLI 已超出 skill 宣告的相容範圍，需要從上游更新 skill" ;;
    esac
  fi
fi
say ""

# ---------------------------------------------------------------- versions ---
say "## 現在的版本"
say ""
say '```'
for c in brew git node npm python3 uv gh netlify firebase wrangler supabase chezmoi codex claude nlm heptabase mcpvault; do
  if command -v "$c" >/dev/null 2>&1; then
    say "$(printf '%-10s %s' "$c" "$("$c" --version 2>&1 | head -1)")"
  fi
done
say '```'
say ""
say "失敗步驟：$FAILURES"

printf '%s\n' "$REPORT"
[ "$FAILURES" -eq 0 ] || exit 1
