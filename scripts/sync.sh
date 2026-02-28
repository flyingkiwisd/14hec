#!/bin/bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  14 HEC — Sync Latest Changes
#  Pulls latest main and merges into your branch.
#  Usage: bash scripts/sync.sh
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -e

echo ""
echo "  ╔══════════════════════════════════╗"
echo "  ║   14 HEC — Syncing              ║"
echo "  ╚══════════════════════════════════╝"
echo ""

CURRENT_BRANCH=$(git branch --show-current)
echo "  You are on branch: $CURRENT_BRANCH"

# Stash uncommitted changes if needed
STASHED=false
if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
  echo "  Stashing uncommitted changes..."
  git stash
  STASHED=true
fi

# Fetch from remote
echo "  Fetching from GitHub..."
git fetch origin

if [ "$CURRENT_BRANCH" = "main" ]; then
  # On main — just pull
  echo "  Pulling latest main..."
  git pull origin main
else
  # On a feature branch — update main then merge
  echo "  Updating main..."
  git checkout main
  git pull origin main
  echo "  Switching back to $CURRENT_BRANCH..."
  git checkout "$CURRENT_BRANCH"
  echo "  Merging main into $CURRENT_BRANCH..."
  if ! git merge main --no-edit; then
    echo ""
    echo "  ⚠  MERGE CONFLICT detected!"
    echo "  Ask Claude Code to help resolve the conflicts."
    echo "  After resolving: git add . && git commit"
    [ "$STASHED" = true ] && echo "  Note: run 'git stash pop' after resolving."
    exit 1
  fi
fi

# Restore stashed changes
if [ "$STASHED" = true ]; then
  echo "  Restoring stashed changes..."
  git stash pop
fi

# Detect dependency changes
if git diff HEAD@{1} --name-only 2>/dev/null | grep -q "package-lock.json"; then
  echo ""
  echo "  Dependencies changed — running npm install..."
  npm install --loglevel=warn
fi

# Detect seed data changes
if git diff HEAD@{1} --name-only 2>/dev/null | grep -q "src/seed/\|migrations/"; then
  echo ""
  echo "  ⚠  Seed data or schema changed!"
  echo "  Reset your database to pick up changes:"
  echo "    rm ~/Library/Application\ Support/14hec/14hec.db*"
  echo "    npm run dev"
fi

echo ""
echo "  ✓ Sync complete! You are on: $CURRENT_BRANCH"
echo ""
