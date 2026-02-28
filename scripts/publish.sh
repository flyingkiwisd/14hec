#!/bin/bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  14 HEC — Publish Your Work
#  Pushes your branch to GitHub for others to see.
#  Usage: bash scripts/publish.sh
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -e

echo ""
echo "  ╔══════════════════════════════════╗"
echo "  ║   14 HEC — Publishing           ║"
echo "  ╚══════════════════════════════════╝"
echo ""

CURRENT_BRANCH=$(git branch --show-current)
echo "  You are on branch: $CURRENT_BRANCH"

# Guard: don't push directly to main
if [ "$CURRENT_BRANCH" = "main" ]; then
  echo ""
  echo "  ✗ Cannot push directly to main."
  echo ""
  echo "  Create a personal branch first:"
  echo "    git checkout -b yourname/feature-description"
  echo ""
  echo "  Then commit your changes and run this script again."
  exit 1
fi

# Check for uncommitted changes
if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
  echo ""
  echo "  ✗ You have uncommitted changes."
  echo "  Commit first, or ask Claude Code:"
  echo '    git add . && git commit -m "your message"'
  exit 1
fi

# Push
echo "  Pushing to GitHub..."
git push -u origin "$CURRENT_BRANCH"

echo ""
echo "  ✓ Branch pushed!"
echo ""
echo "  To create a Pull Request:"
echo "    gh pr create --title \"Your title\" --body \"What you changed\""
echo ""
echo "  Or visit GitHub:"
echo "    gh browse"
echo ""
