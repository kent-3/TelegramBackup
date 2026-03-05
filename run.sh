#!/usr/bin/env bash
set -euo pipefail

# ─── TelegramBackup launcher ───
# Handles Python check, virtual environment, dependencies, .env setup, and launch.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

VENV_DIR=".venv"
ENV_FILE=".env"
REQUIREMENTS="requirements.txt"

# ─── Check for Python 3 ───
find_python() {
    for cmd in python3 python; do
        if command -v "$cmd" &>/dev/null; then
            version=$("$cmd" --version 2>&1 | grep -oP '\d+\.\d+')
            major=$(echo "$version" | cut -d. -f1)
            minor=$(echo "$version" | cut -d. -f2)
            if [ "$major" -eq 3 ] && [ "$minor" -ge 6 ]; then
                echo "$cmd"
                return
            fi
        fi
    done
    return 1
}

PYTHON=$(find_python) || {
    echo "Error: Python 3.6+ is required but not found."
    echo ""
    echo "Install it with one of:"
    echo "  Ubuntu/Debian:  sudo apt install python3 python3-venv python3-pip"
    echo "  Fedora:         sudo dnf install python3"
    echo "  macOS:          brew install python3"
    echo "  Windows:        https://www.python.org/downloads/"
    exit 1
}

echo "Using $($PYTHON --version)"

# ─── Create virtual environment if needed ───
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    $PYTHON -m venv "$VENV_DIR"
fi

# Activate it
source "$VENV_DIR/bin/activate"

# ─── Install/update dependencies ───
# Only reinstall if requirements.txt is newer than the venv marker
MARKER="$VENV_DIR/.deps_installed"
if [ ! -f "$MARKER" ] || [ "$REQUIREMENTS" -nt "$MARKER" ]; then
    echo "Installing dependencies..."
    pip install -q --upgrade pip
    pip install -q -r "$REQUIREMENTS"
    touch "$MARKER"
else
    echo "Dependencies up to date."
fi

# ─── Set up .env if needed ───
if [ ! -f "$ENV_FILE" ]; then
    echo ""
    echo "══════════════════════════════════════════════════════════"
    echo "  First-time setup: Telegram API credentials needed"
    echo "══════════════════════════════════════════════════════════"
    echo ""
    echo "  1. Go to https://my.telegram.org and log in"
    echo "  2. Click 'API development tools'"
    echo "  3. Create an app (any name/short name is fine)"
    echo "  4. Copy your api_id and api_hash"
    echo ""

    read -rp "  Enter your API ID (numbers only): " api_id
    read -rp "  Enter your API Hash: " api_hash

    # Basic validation
    if ! [[ "$api_id" =~ ^[0-9]+$ ]]; then
        echo "Error: API ID must be a number."
        exit 1
    fi

    if [ -z "$api_hash" ]; then
        echo "Error: API Hash cannot be empty."
        exit 1
    fi

    cat > "$ENV_FILE" <<EOF
TELEGRAM_API_ID=$api_id
TELEGRAM_API_HASH=$api_hash
EOF

    echo ""
    echo "  Credentials saved to .env"
    echo "══════════════════════════════════════════════════════════"
    echo ""
fi

# ─── Launch ───
echo ""
echo "Starting TelegramBackup..."
echo ""
python telegram_backup.py
