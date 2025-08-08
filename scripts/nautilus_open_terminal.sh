#!/usr/bin/env bash
set -euo pipefail

# Configure Nautilus "Open in Terminal" to use Alacritty
# Assumes the package 'nautilus-open-any-terminal' was installed by post_install via yay

schema="com.github.stunkymonkey.nautilus-open-any-terminal"

if ! command -v gsettings >/dev/null 2>&1; then
  exit 0
fi

# Set fixed terminal to alacritty
current_terminal=$(gsettings get "$schema" terminal 2>/dev/null || echo "")
if [[ "$current_terminal" != "'alacritty'" ]]; then
  gsettings set "$schema" terminal alacritty || true
fi

# Optional: show button in toolbar if key exists
gsettings set "$schema" show-in-toolbar true 2>/dev/null || true

# Restart Nautilus if running
if pgrep -x nautilus >/dev/null 2>&1; then
  nautilus -q || true
fi

echo "Nautilus 'Open in Terminal' configured to use Alacritty."