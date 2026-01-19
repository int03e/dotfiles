Installation (NixOS)

1. clone the repo to ~/dotfiles
2. sudo stow --restow --target=/etc/nixos nixos 
3. stow --target=$HOME user

if you add a new config to your ~/.config folder and you want to sync it, run `./scripts/import-config`
