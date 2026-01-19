#!/usr/bin/env bash

REPO_DIR="$HOME/projects/dotfiles/user/.config"
CONFIG_DIR="$HOME/.config"

echo "Scanning $CONFIG_DIR for new configs..."

for item in "$CONFIG_DIR"/*; do
	name=$(basename "$item")
	if [ -e "$REPO_DIR/$name" ]; then
	else
		echo "Found new config: $name. Moving to repo..."
		mv "$item" "$REPO_DIR/"
	fi
done

echo "Restowing..."
cd "$HOME/projects/dotfiles"
stow --target=$HOME user

echo "Done! All configs are now tracked."
