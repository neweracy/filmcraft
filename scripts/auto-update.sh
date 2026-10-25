#!/usr/bin/env bash
# Pull upstream updates, merge into the current branch, rebuild the CLI binary.
# Safe: aborts on a dirty tree or a merge conflict instead of forcing anything.
set -euo pipefail

repo="$(cd "$(dirname "$0")/.." && pwd)"
# Run globally: if the repo or git is gone, exit quietly instead of erroring.
if [ ! -d "$repo/.git" ]; then
  echo "auto-update: repo not found at $repo, skipping."
  exit 0
fi
cd "$repo"

# Don't touch a dirty tree.
if [ -n "$(git status --porcelain --untracked-files=no)" ]; then
  echo "auto-update: uncommitted changes present, skipping." >&2
  exit 0
fi

git fetch upstream --quiet

behind=$(git rev-list --count HEAD..upstream/main)
if [ "$behind" -eq 0 ]; then
  echo "auto-update: already up to date with upstream/main."
  exit 0
fi

echo "auto-update: $behind new upstream commit(s), merging."
if ! git merge --no-edit upstream/main; then
  git merge --abort
  echo "auto-update: merge conflict, aborted. Resolve manually." >&2
  exit 1
fi

# Rebuild the MCP binary so the new code is what Kiro runs.
cargo build --release -p filmcraft-cli -p filmcraft
echo "auto-update: merged and rebuilt."
