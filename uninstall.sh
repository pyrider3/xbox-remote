#!/usr/bin/env bash
set -e

echo "🗑️  Uninstalling Xbox Remote..."

# 1. Stop and disable service
if systemctl --user is-active --quiet xbox-remote.service 2>/dev/null; then
    echo "⏹️  Stopping xbox-remote.service..."
    systemctl --user stop xbox-remote.service
fi

if systemctl --user is-enabled --quiet xbox-remote.service 2>/dev/null; then
    echo "🔒 Disabling xbox-remote.service..."
    systemctl --user disable xbox-remote.service
fi

# 2. Remove installed files
echo "🧹 Removing installed files..."
rm -f "$HOME/.local/bin/xbox-remote"
rm -f "$HOME/.config/systemd/user/xbox-remote.service"
rm -f "$HOME/.local/share/applications/xbox-remote-toggle.desktop"
rm -f "/run/user/$(id -u)/xbox-remote.pid"
rm -f "/run/user/$(id -u)/xbox-remote.state"

# 3. Reload systemd
systemctl --user daemon-reload
systemctl --user reset-failed 2>/dev/null || true

echo "✨ Uninstallation complete. Xbox Remote has been removed cleanly."
