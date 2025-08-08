# My Dotfiles

This repository contains my personal configuration files (dotfiles) for an Arch Linux environment with Hyprland, set up via Omarchy.

These dotfiles are managed using [GNU Stow](https://www.gnu.org/software/stow/).

## 1. Initial System Setup

The foundation of this setup is a clean Arch Linux installation.

### 1.1. Arch Linux Installation

Use the `archinstall` script for the base installation. As per the [Omarchy documentation](https://manuals.omamix.org/2/the-omarchy-manual/50/getting-started), it is recommended to use the BTRFS filesystem with LUKS encryption.

### 1.2. Omarchy (Hyprland) Installation

After the base installation, set up the Hyprland environment by running the Omarchy script:

```bash
wget -O - https://install.omarchy.org | bash
```

## 2. Dotfiles Installation

With the base system configured, apply the custom settings from this repository.

### 2.1. Clone the Repository

```bash
git clone <YOUR_REPOSITORY_URL> ~/dotfiles
cd ~/dotfiles
```

### 2.2. Post-install steps

```bash
./scripts/post_install.sh
```

This will install `stow` and apply all modules automatically.

## Managed Programs

*   alacritty
*   nvim
*   hypr
*   waybar
*   bash
*   starship
*   (and others you might add)



# TODO:

- [ ] Add FiraCode Nerd Font to the dotfiles
- [ ] Change arrow keybinds for hjkl to focus
- [ ] Fix non hidden files in nvim
- [ ] Check if add the keyboard settings from ~/.config/fcitx5/
- [ ] add keysmaps for vscode mode using as example the astronvim config
- [ ] Adicionar configuração do Ctrl T do Diego no meu dotfiles

