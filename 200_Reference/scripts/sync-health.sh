#!/usr/bin/env bash
set -u

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
GEMINI_HOME="${GEMINI_HOME:-$HOME/.gemini}"
CHEZMOI_SOURCE="${CHEZMOI_SOURCE:-$HOME/.local/share/chezmoi}"
PYTHON_TOOLS_HOME="${PYTHON_TOOLS_HOME:-$CODEX_HOME/python-tools}"
PYTHON_TOOLS_BRIDGE="${PYTHON_TOOLS_BRIDGE:-$HOME/.local/share/agent-tools/python-tools}"
PYTHON_TOOLS_ENV="${PYTHON_TOOLS_ENV:-$HOME/.config/agent-tools/python-tools.env}"
: "${SYNC_ROOT:?Set SYNC_ROOT to your portable sync root before running this script.}"
: "${SETUP_REPO:?Set SETUP_REPO to your setup repo before running this script.}"
LAZYPACK_ROOT="${LAZYPACK_ROOT:-$SETUP_REPO/200_Reference/lazy-pack}"
: "${OBSIDIAN_LAZYPACK:?Set OBSIDIAN_LAZYPACK to your LazyPack mirror before running this script.}"

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
    fail "$2 (missing)"
  fi
}

check_symlink_target() {
  local link_path="$1"
  local expected="$2"
  local label="$3"

  if [ ! -L "$link_path" ]; then
    fail "$label (not a symlink)"
    return
  fi

  local actual
  actual="$(readlink "$link_path")"
  if [ "$actual" = "$expected" ]; then
    pass "$label"
  else
    fail "$label (target mismatch)"
  fi
}

printf 'Cross-agent sync health check\n'
printf 'CODEX_HOME=<set>\n'
printf 'CLAUDE_HOME=<set>\n'
printf 'GEMINI_HOME=<set>\n'
printf 'CHEZMOI_SOURCE=<set>\n'
printf 'PYTHON_TOOLS_HOME=<set>\n'
printf 'PYTHON_TOOLS_BRIDGE=<set>\n'
printf 'SYNC_ROOT=<set>\n'
printf 'SETUP_REPO=<set>\n'
printf 'LAZYPACK_ROOT=<set>\n'
printf 'OBSIDIAN_LAZYPACK=<set>\n\n'

check_path "$SYNC_ROOT/core-rules.md" "portable core-rules exists"
check_symlink_target "$CODEX_HOME/AGENTS.md" "$SYNC_ROOT/core-rules.md" "Codex AGENTS.md points to portable core-rules"
check_symlink_target "$CODEX_HOME/skills" "$SYNC_ROOT/skills" "Codex skills points to portable skills"
check_symlink_target "$CODEX_HOME/memories" "$SYNC_ROOT/memories" "Codex memories points to portable memories"
check_symlink_target "$CLAUDE_HOME/CLAUDE.md" "$SYNC_ROOT/core-rules.md" "Claude CLAUDE.md points to portable core-rules"
check_symlink_target "$CLAUDE_HOME/skills" "$SYNC_ROOT/skills" "Claude skills points to portable skills"
check_symlink_target "$GEMINI_HOME/GEMINI.md" "$SYNC_ROOT/core-rules.md" "AntiGravity GEMINI.md points to portable core-rules"
check_symlink_target "$GEMINI_HOME/config/AGENTS.md" "$SYNC_ROOT/core-rules.md" "AntiGravity AGENTS.md points to portable core-rules"
check_symlink_target "$GEMINI_HOME/config/skills" "$SYNC_ROOT/skills" "AntiGravity skills points to portable skills"
check_symlink_target "$GEMINI_HOME/config/plugins/codex/skills" "$SYNC_ROOT/skills" "AntiGravity Codex-plugin skills points to portable skills"
check_symlink_target "$PYTHON_TOOLS_BRIDGE" "$PYTHON_TOOLS_HOME" "neutral Python tools bridge points to the local runtime"

if [ -f "$PYTHON_TOOLS_ENV" ]; then
  pass "shared Python tools environment loader exists"
else
  fail "shared Python tools environment loader exists"
fi

for profile in "$HOME/.zshenv" "$HOME/.zprofile" "$HOME/.profile" "$HOME/.bash_profile"; do
  label="$(basename "$profile") loads shared Python tools environment"
  if [ -f "$profile" ] && \
     grep -Fq '# >>> agent-python-tools >>>' "$profile" && \
     grep -Fq '# <<< agent-python-tools <<<' "$profile"; then
    pass "$label"
  else
    fail "$label"
  fi
done

if [ -x "$PYTHON_TOOLS_HOME/bin/python-tools-python" ]; then
  pass "shared Python tools runtime exists"
  if "$PYTHON_TOOLS_BRIDGE/bin/python-tools-python" -c 'import sys; assert sys.version_info >= (3, 12)' >/dev/null 2>&1; then
    pass "shared Python tools runtime executes through neutral bridge"
  else
    fail "shared Python tools runtime executes through neutral bridge"
  fi
else
  fail "shared Python tools runtime exists (install LazyPack Item 34)"
fi

if command -v zsh >/dev/null 2>&1; then
  python_tools_command="$(zsh -lc 'command -v python-tools-python' 2>/dev/null || true)"
else
  python_tools_command="$(sh -lc '. "$HOME/.profile"; command -v python-tools-python' 2>/dev/null || true)"
fi
if [ -n "$python_tools_command" ]; then
  pass "fresh Agent shell discovers python-tools-python"
else
  fail "fresh Agent shell discovers python-tools-python"
fi

if command -v chezmoi >/dev/null 2>&1; then
  pass "chezmoi installed ($(chezmoi --version | awk '{print $3}' | tr -d ','))"
  if [ -d "$CHEZMOI_SOURCE" ]; then
    pass "chezmoi source exists"
  else
    fail "chezmoi source exists"
  fi
  if [ -z "$(chezmoi status 2>/dev/null)" ]; then
    pass "chezmoi managed entrypoints match templates"
  else
    warn "chezmoi reports pending entrypoint changes"
  fi
else
  fail "chezmoi installed (required by LazyPack Item 16)"
fi

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
  if grep -Eq '(fc-[A-Za-z0-9]{20,}|AIza[0-9A-Za-z_-]{20,}|sk-[A-Za-z0-9_-]{20,}|ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,})' "$CODEX_HOME/config.toml"; then
    warn "config.toml appears to contain a literal token pattern; keep it local and move the credential to the secrets directory"
  else
    pass "config.toml has no obvious literal token pattern (secret-file/env references are allowed)"
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
