#!/usr/bin/env bash
set -euo pipefail

# General post-install to run right after Omarchy setup
# - Installs dependencies
# - Stows dotfile modules
# - Removes selected Omarchy WebApps
# - Configures Nautilus 'Open in Terminal' (Alacritty)
# - Disables systemd-networkd-wait-online.service (if present)

require_sudo() {
  if ! sudo -v; then
    echo "This script needs sudo privileges. Aborting." >&2
    exit 1
  fi
}

install_packages() {
  echo "Installing required packages via yay..."
  if ! command -v yay >/dev/null 2>&1; then
    echo "'yay' is required but was not found. Please install yay first." >&2
    exit 1
  fi
  # Visible list of required packages
  PACKAGES=(
    stow
    starship
    libva-utils                # screenrecord
    intel-media-driver         # screenrecord
    nautilus-open-any-terminal # Nautilus "Open in Terminal"
    zapzap
  )
  echo "Packages: ${PACKAGES[*]}"
  yay -S --needed --noconfirm "${PACKAGES[@]}" || true
}

stow_modules() {
  echo "Stowing modules (explicit list)..."
  # Explicit list of modules to stow
  local modules=(hypr nvim waybar alacritty bash starship)
  local repo_root
  repo_root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
  pushd "$repo_root" >/dev/null
  for mod in "${modules[@]}"; do
    if [[ -d "$mod" ]]; then
      stow "$mod"
    fi
  done
  popd >/dev/null
}

disable_network_wait_online() {
  echo "Disabling systemd-networkd-wait-online.service (if present)..."
  if systemctl list-unit-files | grep -q '^systemd-networkd-wait-online.service'; then
    sudo systemctl disable systemd-networkd-wait-online.service || true
  else
    echo "Service systemd-networkd-wait-online.service not found; skipping."
  fi
}

print_notes() {
  cat <<'EONOTE'

- Selected Omarchy WebApps have been removed (e.g., WhatsApp).
- Nautilus “Open in Terminal” is configured to use Alacritty.
- Selected dotfile modules have been stowed.
- systemd-networkd-wait-online.service was disabled (if present).
EONOTE
}

main() {
  require_sudo

  TOTAL_STEPS=5
  CURRENT_STEP=1

  echo "[$CURRENT_STEP/$TOTAL_STEPS] Installing required packages via yay..."
  install_packages

  CURRENT_STEP=$((CURRENT_STEP + 1))
  echo "[$CURRENT_STEP/$TOTAL_STEPS] Stowing modules (explicit list)..."
  stow_modules

  CURRENT_STEP=$((CURRENT_STEP + 1))
  echo "[$CURRENT_STEP/$TOTAL_STEPS] Disabling systemd-networkd-wait-online.service (if present)..."
  disable_network_wait_online

  CURRENT_STEP=$((CURRENT_STEP + 1))
  echo "[$CURRENT_STEP/$TOTAL_STEPS] Removing Omarchy WebApps..."
  "$(git rev-parse --show-toplevel 2>/dev/null || pwd)"/scripts/omarchy_remove_webapps.sh || true

  CURRENT_STEP=$((CURRENT_STEP + 1))
  echo "[$CURRENT_STEP/$TOTAL_STEPS] Configuring Nautilus 'Open in Terminal' (Alacritty)..."
  "$(git rev-parse --show-toplevel 2>/dev/null || pwd)"/scripts/nautilus_open_terminal.sh || true

  echo "[$TOTAL_STEPS/$TOTAL_STEPS] Done."
  print_notes
}

main "$@"
