{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  nixvimPkg = import ./programs/nixvim.nix { inherit pkgs inputs; };
in
{
  imports = [
    ./programs/tmux.nix
  ];

  environment.variables = {
    DIRENV_LOG_FORMAT = "";
    NIXPKGS_ALLOW_UNFREE = "1";
    EDITOR = "nvim";
  };

  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    set fish_greeting
    abbr -a nr 'sudo nixos-rebuild switch --flake "path:/home/int03e/projects/dotfiles/nixos#nixos"'
    abbr -a nt 'sudo nixos-rebuild test --flake "path:/home/int03e/projects/dotfiles/nixos#nixos"' 
    abbr -a gc3 'sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +3 && sudo nix-collect-garbage'
    abbr -a bat-desk 'echo "stationary" | sudo tee /sys/devices/platform/tuxedo_keyboard/charging_profile/charging_profile'
    abbr -a bat-full 'echo "high_capacity" | sudo tee /sys/devices/platform/tuxedo_keyboard/charging_profile/charging_profile'
    abbr -a bat-status 'upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state|energy-rate|percentage"'
    ${pkgs.starship}/bin/starship init fish | source
  '';

  programs.starship.enable = true;
  programs.dconf.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableFishIntegration = true;
    silent = true;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
  ];

  programs.neovim.enable = false;

  programs.firefox = {
    enable = true;
    preferences = {
      "browser.startup.page" = 3;
      "browser.sessionstore.max_resumed_crashes" = 10;
      "browser.sessionstore.resume_from_crash" = true;
      "browser.tabs.restore_on_demand" = true;
    };
  };

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  programs.git = {
    enable = true;
    config = {
      safe = {
        directory = "/home/int03e/projects/dotfiles";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    nixvimPkg
    (runCommand "nv-alias" { } ''
      mkdir -p $out/bin
      ln -s ${pkgs.neovim}/bin/nvim $out/bin/nv
    '')
    (runCommand "vim-aliases" { } ''
      mkdir -p $out/bin
      ln -s ${nixvimPkg}/bin/nvim $out/bin/vim
      ln -s ${nixvimPkg}/bin/nvim $out/bin/vi
    '')
    wl-clipboard
    inputs.noctalia.packages.${pkgs.system}.default
    protontricks
    via
    socat
    luarocks
    kanshi
    wget
    vial
    lazydocker
    gcc
    gnumake
    curl
    ripgrep
    fd
    unzip
    fzf
    lazygit
    vlc
    slack
    kitty
    btop
    dbeaver-bin
    bruno
    starship
    nixd
    nixfmt
    statix
    deadnix
    direnv
    libnotify
    bibata-cursors
    adwaita-icon-theme
    pavucontrol
    hyprshot
    grim
    slurp
    brightnessctl
    wireplumber
    libinput
    acpi
    hypridle
    google-cloud-sdk
    google-cloud-sql-proxy
    nodePackages.typescript-language-server
    vtsls
    nodePackages.prettier
    stylua
    stow
    bc
    transmission_4-gtk
    yazi
    bat
    telegram-desktop
    lua-language-server
    mpv

    (writeShellScriptBin "kbd-backlight-cycle" ''
      DEVICE="white:kbd_backlight"
      BCTL="${pkgs.brightnessctl}/bin/brightnessctl"
      CURRENT=$($BCTL --device="$DEVICE" get)

      case "$CURRENT" in
        0) $BCTL --device="$DEVICE" set 1 ;;
        1) $BCTL --device="$DEVICE" set 2 ;;
        2) $BCTL --device="$DEVICE" set 3 ;;
        3) $BCTL --device="$DEVICE" set 4 ;;
        *) $BCTL --device="$DEVICE" set 0 ;;
      esac
    '')
  ];
}
