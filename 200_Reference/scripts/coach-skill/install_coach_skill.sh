#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
VERIFY_SCRIPT="$SCRIPT_DIR/verify_coach_skill.py"
SYNC_ROOT=""
MODE="dry-run"
AGENTS="codex,claude,antigravity"
INSTALL_CHEZMOI=0
PYTHON_BIN="${PYTHON_BIN:-python3}"

usage() {
  cat <<'EOF'
Usage:
  install_coach_skill.sh --sync-root PATH [options]

Options:
  --agents LIST       Comma-separated: codex,claude,antigravity
                      Default: codex,claude,antigravity
  --dry-run           Validate private sources and preview Item 16 bootstrap
                      without changing Agent entrypoints (default)
  --apply             Apply Item 16 bootstrap, then verify all four skills
  --verify-only       Verify current sources and Agent entrypoints only
  --install-chezmoi   Allow Item 16 to install chezmoi; requires --apply
  -h, --help          Show this help

Coach Skill is a private-source bridge. It never downloads, embeds, uploads,
or publishes the private course corpus. The selected sync root must already
contain future-coach, voice-coach, waki-brain, and productivity-coach. Only
use a trusted private sync root owned by the user.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --sync-root)
      [[ $# -ge 2 ]] || { echo "Missing value for --sync-root" >&2; exit 2; }
      SYNC_ROOT="$2"
      shift 2
      ;;
    --agents)
      [[ $# -ge 2 ]] || { echo "Missing value for --agents" >&2; exit 2; }
      AGENTS="$2"
      shift 2
      ;;
    --dry-run)
      MODE="dry-run"
      shift
      ;;
    --apply)
      MODE="apply"
      shift
      ;;
    --verify-only)
      MODE="verify-only"
      shift
      ;;
    --install-chezmoi)
      INSTALL_CHEZMOI=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

[[ -n "$SYNC_ROOT" ]] || { echo "--sync-root is required" >&2; exit 2; }
[[ -d "$SYNC_ROOT" ]] || { echo "SYNC_ROOT does not exist" >&2; exit 1; }
IFS=',' read -r -a requested_agents <<< "$AGENTS"
for agent in "${requested_agents[@]}"; do
  case "$agent" in
    codex|claude|antigravity) ;;
    *)
      echo "Unknown Agent in --agents: $agent" >&2
      exit 2
      ;;
  esac
done
command -v "$PYTHON_BIN" >/dev/null 2>&1 || {
  echo "Python 3 is required; complete LazyPack Item 34 first" >&2
  exit 1
}
[[ -f "$VERIFY_SCRIPT" ]] || { echo "Coach Skill verifier is missing" >&2; exit 1; }

if [[ "$INSTALL_CHEZMOI" -eq 1 && "$MODE" != "apply" ]]; then
  echo "--install-chezmoi requires --apply" >&2
  exit 2
fi

echo "Coach Skill"
echo "MODE=$MODE"
echo "AGENTS=$AGENTS"
echo "PRIVATE_SOURCE=required"
echo "PRIVATE_SOURCE_TRUST=required"
echo "PUBLIC_COURSE_CONTENT=excluded"

"$PYTHON_BIN" "$VERIFY_SCRIPT" \
  --sync-root "$SYNC_ROOT" \
  --agents "$AGENTS"

if [[ "$MODE" == "verify-only" ]]; then
  "$PYTHON_BIN" "$VERIFY_SCRIPT" \
    --sync-root "$SYNC_ROOT" \
    --agents "$AGENTS" \
    --check-entrypoints
  exit 0
fi

BOOTSTRAP="$SYNC_ROOT/skills/cross-device-sync/scripts/bootstrap-agent-sync.sh"
[[ -x "$BOOTSTRAP" ]] || {
  echo "Item 16 bootstrap is missing; install cross-device-sync first" >&2
  exit 1
}

bootstrap_args=(
  --sync-root "$SYNC_ROOT"
  --agents "$AGENTS"
)

if [[ "$MODE" == "dry-run" ]]; then
  "$BOOTSTRAP" "${bootstrap_args[@]}" --dry-run
  echo "Coach Skill dry-run complete; no Agent entrypoints changed"
  exit 0
fi

if [[ "$INSTALL_CHEZMOI" -eq 1 ]]; then
  bootstrap_args+=(--install-chezmoi)
fi
"$BOOTSTRAP" "${bootstrap_args[@]}" --apply

"$PYTHON_BIN" "$VERIFY_SCRIPT" \
  --sync-root "$SYNC_ROOT" \
  --agents "$AGENTS" \
  --check-entrypoints

echo "Coach Skill installed for the selected Agent entrypoints"
echo "Open a new Agent conversation before testing natural-language triggers"
