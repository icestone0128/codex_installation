#!/usr/bin/env bash
set -u

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SYNC_ROOT="${SYNC_ROOT:-/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_symlink}"
SETUP_REPO="${SETUP_REPO:-/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_installation}"
LAZYPACK_ROOT="${LAZYPACK_ROOT:-$SETUP_REPO/200_Reference/lazy-pack}"
OBSIDIAN_LAZYPACK="${OBSIDIAN_LAZYPACK:-/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/secondbrain/專案庫/codex_installation/懶人包}"

failures=0
warnings=0

pass() {
  printf 'PASS %s\n' "$1"
}

warn() {
  warnings=$((warnings + 1))
  printf 'WARN %s\n' "$1"
}

fail() {
  failures=$((failures + 1))
  printf 'FAIL %s\n' "$1"
}

check_path() {
  if [ -e "$1" ]; then
    pass "$2"
  else
    fail "$2 ($1 missing)"
  fi
}

check_symlink_target() {
  local link_path="$1"
  local expected="$2"
  local label="$3"

  if [ ! -L "$link_path" ]; then
    fail "$label ($link_path is not a symlink)"
    return
  fi

  local actual
  actual="$(readlink "$link_path")"
  if [ "$actual" = "$expected" ]; then
    pass "$label"
  else
    fail "$label (expected $expected, got $actual)"
  fi
}

printf 'Codex sync health check\n'
printf 'CODEX_HOME=%s\n' "$CODEX_HOME"
printf 'SYNC_ROOT=%s\n' "$SYNC_ROOT"
printf 'SETUP_REPO=%s\n' "$SETUP_REPO"
printf 'LAZYPACK_ROOT=%s\n' "$LAZYPACK_ROOT"
printf 'OBSIDIAN_LAZYPACK=%s\n\n' "$OBSIDIAN_LAZYPACK"

check_path "$SYNC_ROOT/core-rules.md" "portable core-rules exists"
check_symlink_target "$CODEX_HOME/AGENTS.md" "$SYNC_ROOT/core-rules.md" "Codex AGENTS.md points to portable core-rules"
check_symlink_target "$CODEX_HOME/skills" "$SYNC_ROOT/skills" "Codex skills points to portable skills"
check_symlink_target "$CODEX_HOME/memories" "$SYNC_ROOT/memories" "Codex memories points to portable memories"
check_symlink_target "$CODEX_HOME/rules" "$SYNC_ROOT/rules" "Codex rules points to portable rules"
check_symlink_target "$CODEX_HOME/automations" "$SYNC_ROOT/automations" "Codex automations points to portable automations"

if [ -d "$SYNC_ROOT/skills" ]; then
  skill_count="$(find -L "$SYNC_ROOT/skills" -maxdepth 2 -name SKILL.md -print 2>/dev/null | wc -l | tr -d ' ')"
  if [ "$skill_count" -gt 0 ]; then
    pass "portable skills discoverable ($skill_count SKILL.md files)"
  else
    fail "portable skills discoverable"
  fi
fi

if [ -d "$SETUP_REPO/.git" ]; then
  repo_status="$(git -C "$SETUP_REPO" status --short)"
  if [ -z "$repo_status" ]; then
    pass "codex_installation git worktree clean"
  else
    warn "codex_installation has uncommitted changes"
    printf '%s\n' "$repo_status"
  fi
else
  fail "codex_installation git repo exists"
fi

if [ -d "$LAZYPACK_ROOT" ] && [ -d "$OBSIDIAN_LAZYPACK" ]; then
  diff_output="$(diff -qr "$LAZYPACK_ROOT" "$OBSIDIAN_LAZYPACK" 2>&1)"
  if [ -z "$diff_output" ]; then
    pass "repo lazy-pack matches Obsidian mirror"
  else
    warn "repo lazy-pack differs from Obsidian mirror"
    printf '%s\n' "$diff_output"
  fi
else
  warn "lazy-pack mirror comparison skipped"
fi

if [ -f "$CODEX_HOME/config.toml" ]; then
  if grep -Eq '(API_KEY|TOKEN|PASSWORD|SECRET)=[^{}[:space:]]+' "$CODEX_HOME/config.toml"; then
    warn "config.toml appears to contain inline secret-like values; keep it local and do not sync directly"
  else
    pass "config.toml has no obvious inline secret pattern"
  fi
else
  warn "config.toml not found"
fi

if git -C "$SETUP_REPO" grep -nE '(fc-[A-Za-z0-9]{20,}|AIza[0-9A-Za-z_-]{20,})' -- . ':!200_Reference/lazy-pack/26-HyperFrames-Skill-安裝.md' >/tmp/codex-sync-health-secret-scan.txt 2>/dev/null; then
  warn "repo tracked files may contain secret-like values"
  sed -n '1,20p' /tmp/codex-sync-health-secret-scan.txt
else
  pass "repo tracked files have no obvious Firecrawl/Gemini secret pattern"
fi
rm -f /tmp/codex-sync-health-secret-scan.txt

printf '\nSummary: %s failure(s), %s warning(s)\n' "$failures" "$warnings"

if [ "$failures" -gt 0 ]; then
  exit 1
fi
