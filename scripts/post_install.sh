#!/usr/bin/env bash
set -euo pipefail

# General post-install to run right after Omarchy setup
# - Installs dependencies
# - Stows dotfile modules
# - Switches from Omarchy seamless autologin to greetd + tuigreet (no autologin)
# - Configures greetd to start Hyprland via UWSM

require_sudo() {
  if ! sudo -v; then
    echo "This script needs sudo privileges. Aborting." >&2
    exit 1
  fi
}

install_packages() {
  echo "[1/5] Installing required packages via yay..."
  if ! command -v yay >/dev/null 2>&1; then
    echo "'yay' is required but was not found. Please install yay first." >&2
    exit 1
  fi
  # Visible list of required packages
  PACKAGES=(
    stow
    starship
    greetd
    greetd-tuigreet
    libva-utils    # screenrecord
    intel-media-driver # screenrecord
    nautilus-open-any-terminal # Nautilus "Open in Terminal"
  )
  echo "Packages: ${PACKAGES[*]}"
  yay -S --needed --noconfirm "${PACKAGES[@]}" || true
}

stow_modules() {
  echo "[2/5] Stowing modules (explicit list)..."
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

configure_greetd() {
  echo "[4/5] Configuring greetd (no autologin)..."
  sudo install -d -m 755 /etc/greetd
  sudo tee /etc/greetd/config.toml >/dev/null <<'EOF'
[terminal]
vt = 1

[default_session]
# Greeter (tuigreet) launching Hyprland via UWSM
command = "tuigreet --time --remember --remember-session --asterisks --cmd uwsm start -- hyprland.desktop"
user = "greeter"
EOF

  # Disable Omarchy seamless autologin if present
  if systemctl list-unit-files | grep -q '^omarchy-seamless-login.service'; then
    echo "Disabling omarchy-seamless-login.service..."
    sudo systemctl disable --now omarchy-seamless-login.service || true
  fi

  echo "Enabling greetd.service..."
  sudo systemctl enable --now greetd.service
}

print_notes() {
  cat <<'EONOTE'
[5/5] Done.

- greetd + tuigreet has been configured. On next boot, you'll see a TUI greeter.
- Hyprland is launched via UWSM to match your current Omarchy setup.
- If you had added a lock-on-start to ~/.config/hypr/autostart.conf, you may want to remove it when using a greeter.

Rollback:
  sudo systemctl disable --now greetd.service
  sudo systemctl enable --now omarchy-seamless-login.service
EONOTE
}

main() {
  require_sudo
  install_packages
  stow_modules
  echo "[3/5] Configuring Nautilus 'Open in Terminal' (Alacritty)..."
  "$(git rev-parse --show-toplevel 2>/dev/null || pwd)"/scripts/nautilus_open_terminal.sh || true
  configure_greetd
  print_notes
}

main "$@"
