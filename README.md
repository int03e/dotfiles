# NixOS Dotfiles

My personal NixOS configuration, managed with **GNU Stow**.

## 📦 Components
- **Shell:** Fish + Starship
- **Editor:** Neovim
- **Window Manager:** Hyprland
- **Terminal:** Kitty
- **Bar:** Waybar
- **Notification:** SwayNotificationCenter

## 📂 Repository Structure

- **`nixos/`**: System-level configuration (bootloader, services, drivers). Symlinked to `/etc/nixos`.
- **`user/`**: User-level dotfiles (fish, neovim, starship, etc.). Symlinked to `$HOME`.
- **`scripts/`**: Helper scripts for managing configuration.

---

## Installation (Fresh Machine)

### 1. Clone the Repository
Open a terminal on your fresh NixOS installation and clone this repo.

```bash
mkdir -p ~/projects
cd ~/projects
git clone https://github.com/int03e/dotfiles.git
cd dotfiles
cp /etc/nixos/hardware-configuration.nix ~/projects/dotfiles/nixos/
# Backup original config just in case
sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak

sudo nix-shell -p stow --run "stow --restow --target=/etc/nixos nixos"
mkdir -p ~/.config

nix-shell -p stow --run "stow --target=$HOME user"

sudo nixos-rebuild switch
