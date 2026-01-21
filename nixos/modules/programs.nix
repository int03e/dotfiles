{ pkgs, ... }:

{
  environment.variables = {
    DIRENV_LOG_FORMAT = "";
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;

  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    set fish_greeting
    abbr -a nr 'sudo nixos-rebuild switch'
    abbr -a nt 'sudo nixos-rebuild test'
    abbr -a gc3 'sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +3 && sudo nix-collect-garbage'
    ${pkgs.starship}/bin/starship init fish | source
  '';

  programs.starship.enable = true;

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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  programs.firefox = {
    enable = true;
    preferences = {
      "browser.startup.page" = 3;
      "browser.sessionstore.max_resumed_crashes" = 10;
      "browser.sessionstore.resume_from_crash" = true;
      "browser.tabs.restore_on_demand" = true;
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
    ];
    extraConfig = ''
      set -g base-index 1
      setw -g pane-base-index 1
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '15'
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      set -g mouse on
      set -g status-style bg=colour65,fg=white
      set-window-option -g window-status-current-style bg=colour108,fg=black,bold
      set -g status-right 'Bat: #(acpi | grep -o "[0-9]*%") | %H:%M '
      set -g status-right-length 50
    '';
  };

  environment.systemPackages = with pkgs; [
    wget
    gcc
    gnumake
    curl
    git
    ripgrep
    fd
    unzip
    fzf
    wlogout
    lazygit
    vlc
    slack
    kitty
    btop
    dbeaver-bin
    bruno
    starship
    nixd
    nixfmt-rfc-style
    statix
    deadnix
    direnv
    waybar
    libnotify
    networkmanagerapplet
    swaynotificationcenter
    wofi
    swaybg
    blueman
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
    stow
    bc
    transmission_4-gtk
    yazi
    bat

    (writeShellScriptBin "kbd-backlight-cycle"
      "  DEVICE=\"white:kbd_backlight\"\n  CURRENT=$(${pkgs.brightnessctl}/bin/brightnessctl --device=\"$DEVICE\" get)\n  if [ \"$CURRENT\" -eq 0 ]; then\n      ${pkgs.brightnessctl}/bin/brightnessctl --device=\"$DEVICE\" set 1\n  elif [ \"$CURRENT\" -eq 1 ]; then\n      ${pkgs.brightnessctl}/bin/brightnessctl --device=\"$DEVICE\" set 2\n  elif [ \"$CURRENT\" -eq 2 ]; then\n      ${pkgs.brightnessctl}/bin/brightnessctl --device=\"$DEVICE\" set 3\n  elif [ \"$CURRENT\" -eq 3 ]; then\n      ${pkgs.brightnessctl}/bin/brightnessctl --device=\"$DEVICE\" set 4\n  else\n      ${pkgs.brightnessctl}/bin/brightnessctl --device=\"$DEVICE\" set 0\n  fi\n")
  ];
}
