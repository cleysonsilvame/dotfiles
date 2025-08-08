#!/usr/bin/env bash
set -euo pipefail

# General post-install to run right after Omarchy setup
# - Installs dependencies
# - Stows dotfile modules
# - Removes selected Omarchy WebApps
# - Configures Nautilus 'Open in Terminal' (Alacritty)

require_sudo() {
  if ! sudo -v; then
    echo "This script needs sudo privileges. Aborting." >&2
    exit 1
  fi
}

install_packages() {
  echo "[1/4] Installing required packages via yay..."
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
  )
  echo "Packages: ${PACKAGES[*]}"
  yay -S --needed --noconfirm "${PACKAGES[@]}" || true
}

stow_modules() {
  echo "[2/4] Stowing modules (explicit list)..."
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

print_notes() {
  cat <<'EONOTE'

[4/4] Done.

- Selected Omarchy WebApps have been removed (e.g., WhatsApp).
- Nautilus “Open in Terminal” is configured to use Alacritty.
- Selected dotfile modules have been stowed.
EONOTE
}

main() {
  require_sudo
  install_packages
  stow_modules
  echo "[3/4] Removing Omarchy WebApps..."
  "$(git rev-parse --show-toplevel 2>/dev/null || pwd)"/scripts/omarchy_remove_webapps.sh || true
  echo "[4/4] Configuring Nautilus 'Open in Terminal' (Alacritty)..."
  "$(git rev-parse --show-toplevel 2>/dev/null || pwd)"/scripts/nautilus_open_terminal.sh || true
  print_notes
}

main "$@"
