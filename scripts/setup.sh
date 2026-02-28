#!/bin/bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  14 HEC — First-Time Setup
#  Run this once after cloning the repository.
#  Usage: bash scripts/setup.sh
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -e

echo ""
echo "  ╔══════════════════════════════════╗"
echo "  ║   14 HEC — First-Time Setup     ║"
echo "  ╚══════════════════════════════════╝"
echo ""

# Check Node.js
if ! command -v node &> /dev/null; then
  echo "  ✗ Node.js is not installed."
  echo ""
  echo "  Install it:"
  echo "    Option 1: https://nodejs.org (download LTS)"
  echo "    Option 2: brew install node"
  echo "    Option 3: curl -fsSL https://fnm.vercel.app/install | bash"
  echo ""
  exit 1
fi

NODE_VERSION=$(node -v)
echo "  ✓ Node.js $NODE_VERSION detected"

# Check Git
if ! command -v git &> /dev/null; then
  echo "  ✗ Git is not installed."
  echo "    Run: xcode-select --install"
  exit 1
fi

echo "  ✓ Git $(git --version | cut -d' ' -f3) detected"
echo ""

# Install dependencies
echo "  Installing dependencies (this takes a minute)..."
npm install --loglevel=warn
echo ""
echo "  ✓ Dependencies installed"

# Clean any stale database
DB_PATH="$HOME/Library/Application Support/14hec/14hec.db"
if [ -f "$DB_PATH" ]; then
  echo ""
  echo "  Clearing old database..."
  rm -f "$DB_PATH" "${DB_PATH}-shm" "${DB_PATH}-wal"
  echo "  ✓ Database cleared (will regenerate on first launch)"
fi

echo ""
echo "  ╔══════════════════════════════════╗"
echo "  ║   Setup complete!               ║"
echo "  ╠══════════════════════════════════╣"
echo "  ║                                 ║"
echo "  ║  Start the app:                 ║"
echo "  ║    npm run dev                  ║"
echo "  ║                                 ║"
echo "  ║  The database will be created   ║"
echo "  ║  automatically on first launch. ║"
echo "  ║                                 ║"
echo "  ║  To reset the database:         ║"
echo "  ║    rm ~/Library/Application\    ║"
echo "  ║      Support/14hec/14hec.db*    ║"
echo "  ║    npm run dev                  ║"
echo "  ║                                 ║"
echo "  ╚══════════════════════════════════╝"
echo ""
