#!/usr/bin/env bash
set -e

echo "🎮 Installing Xbox Remote..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
SYSTEMD_DIR="$HOME/.config/systemd/user"
APP_DIR="$HOME/.local/share/applications"

# 1. Ensure target directories exist
mkdir -p "$BIN_DIR"
mkdir -p "$SYSTEMD_DIR"
mkdir -p "$APP_DIR"

# 2. Copy binary
echo "📦 Installing executable to $BIN_DIR/xbox-remote..."
cp "$SCRIPT_DIR/bin/xbox-remote" "$BIN_DIR/xbox-remote"
chmod +x "$BIN_DIR/xbox-remote"

# 3. Copy systemd user service
echo "⚙️  Installing systemd user service to $SYSTEMD_DIR/xbox-remote.service..."
cp "$SCRIPT_DIR/systemd/xbox-remote.service" "$SYSTEMD_DIR/xbox-remote.service"

# 4. Copy desktop entry
echo "🖥️  Installing desktop shortcut to $APP_DIR/xbox-remote-toggle.desktop..."
cp "$SCRIPT_DIR/desktop/xbox-remote-toggle.desktop" "$APP_DIR/xbox-remote-toggle.desktop"

# 5. Check /dev/uinput permissions
if [ ! -w /dev/uinput ]; then
    echo "⚠️  Note: Current user does not have write access to /dev/uinput."
    echo "   If the remote doesn't respond, add yourself to the input group or create a udev rule:"
    echo "   sudo usermod -a -G input \$USER"
    echo "   or echo 'KERNEL==\"uinput\", GROUP=\"input\", MODE=\"0660\"' | sudo tee /etc/udev/rules.d/99-uinput.rules"
fi

# 6. Reload & Enable Systemd Service
echo "🔄 Reloading systemd user daemon..."
systemctl --user daemon-reload
systemctl --user enable --now xbox-remote.service

echo ""
echo "✨ Installation complete! Xbox Remote is now active and running."
echo "   Status: systemctl --user status xbox-remote"
echo "   Toggle: xbox-remote toggle"
echo ""
