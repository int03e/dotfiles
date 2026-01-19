{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];
  nixpkgs.config.allowUnfree = true;
  # --- BOOTLOADER ---
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "1";
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "tuxedo_keyboard" "tuxedo_io" ];

  boot.kernelParams = [
    # This tells the kernel to ignore the generic ACPI backlight
    "acpi_backlight=native"

    # This tells the AMD driver to take control
    "amdgpu.backlight=0"

    # This ensures the kernel prefers the GPU backlight over ACPI
    "video.use_native_backlight=1"
  ];
  # Ensure the AMD driver is loaded early
  boot.initrd.kernelModules = [ "amdgpu" ];
  # --- NETWORKING ---
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # --- HARDWARE (Tuxedo & Bluetooth) ---
  hardware.tuxedo-drivers.enable = true;
  hardware.tuxedo-rs = {
    enable = true;
    tailor-gui.enable = true;
  };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  services.power-profiles-daemon.enable = false; # for tuxedo-rs compatibility

  # --- DISPLAY / DESKTOP ---
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.desktopManager.gnome.extraGSettingsOverrides = ''
    [org/gnome/desktop/peripherals/touchpad]
    natural-scroll=true
  '';

  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  systemd.tmpfiles.rules = [ "d /mnt/media 0755 root root -" ];

  fileSystems."/mnt/media" = {
    device = "/dev/disk/by-uuid/2f8f0bfa-bd2f-435f-a671-b84baade1549";
    fsType = "btrfs";
    options = [ "defaults" "nofail" "compress=zstd" ];
  };

  programs.hyprlock.enable = true;
  services.logind.lidSwitch = "ignore";

  programs.hyprland.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableFishIntegration =
      true; # This is true by default, but good to be explicit
  };
  # --- AUTOMATIC UPGRADES (FIXED) ---
  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    persistent = true;
    # postRun doesn't exist here, so we move the logic to a systemd override below
  };

  # This is the fix for your notification script
  systemd.services.nixos-upgrade = {
    postStop = ''
      USER_NAME="int03e"
      USER_ID=$(${pkgs.coreutils}/bin/id -u $USER_NAME)

      # We must pass the variables directly into the sudo command
      # and provide a fallback for DISPLAY just in case libnotify checks for it.
      NOTIFY_CMD="${pkgs.libnotify}/bin/notify-send"
      SUDO="/run/wrappers/bin/sudo"

      if [ "$SERVICE_RESULT" = "success" ]; then
        $SUDO -u $USER_NAME \
          DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$USER_ID/bus \
          DISPLAY=:0 \
          $NOTIFY_CMD -u normal "System Update Successful" "All apps and system packages are now up to date."
      else
        $SUDO -u $USER_NAME \
          DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$USER_ID/bus \
          DISPLAY=:0 \
          $NOTIFY_CMD -u critical "System Update Failed" "Weekly upgrade encountered an error. Check 'journalctl -u nixos-upgrade.service'."
      fi
    '';
  };

  virtualisation.docker.enable = true;

  # --- STORAGE & GARBAGE COLLECTION ---
  nix.gc = {
    automatic = true;
    dates = "*-*-01,15 03:15"; # Runs twice a month
    options = "--delete-older-than 14d";
  };
  nix.settings.auto-optimise-store = true; # Deduplicates files to save space

  # --- PROGRAMS & SHELL ---
  programs.tmux = {
    enable = true;
    clock24 = true;

    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
      # Plugin removed: We will use direct system commands instead
    ];

    extraConfig = ''
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '15'

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      set -g mouse on

      # --- SAGE GREEN THEME ---
      # colour65 is a sage/mossy green. 
      set -g status-style bg=colour65,fg=white
      set-window-option -g window-status-current-style bg=colour108,fg=black,bold

      # --- STATUS BAR ---
      # We use #(...) to run shell commands directly. 
      # This runs 'acpi', grabs the 4th column (99%,), and removes the comma.
      set -g status-right 'Bat: #(acpi | grep -o "[0-9]*%") | %H:%M '
      set -g status-right-length 50
    '';
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

  programs.firefox = {
    enable = true;
    preferences = {
      "browser.startup.page" = 3;
      "browser.sessionstore.max_resumed_crashes" = 10;
      "browser.sessionstore.resume_from_crash" = true;
      "browser.tabs.restore_on_demand" =
        true; # Loads tabs only when you click them (faster boot)
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  programs.fish.enable = true;
  programs.starship.enable = true;
  programs.fish.interactiveShellInit = ''
    set fish_greeting
    abbr -a nr 'sudo nixos-rebuild switch'
    abbr -a nt 'sudo nixos-rebuild test'
    ${pkgs.starship}/bin/starship init fish | source
  '';

  # --- LOCALIZATION & FONTS ---
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
    noto-fonts
    noto-fonts-color-emoji
  ];
  fonts.fontconfig.enable = true;

  # --- SOUND ---
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # --- USER ---
  users.users.int03e = {
    isNormalUser = true;
    description = "int03e";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.fish;
  };

  environment.variables = {
    DIRENV_LOG_FORMAT = "";
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  # --- SYSTEM PACKAGES ---
  environment.systemPackages = with pkgs; [
    wget
    gcc
    gnumake
    curl
    git
    ripgrep
    fd
    wlogout
    unzip
    fzf
    lazygit
    vlc
    slack
    kitty
    btop
    starship
    nixd
    nixfmt-rfc-style
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
    direnv
    google-cloud-sdk
    google-cloud-sql-proxy
    hypridle
    # TypeScript / JavaScript
    nodePackages.typescript-language-server
    vtsls
    nodePackages.prettier # Formatter
    # Add these two for Nix linting
    statix
    deadnix

    dbeaver-bin
    bruno

    (writeShellScriptBin "kbd-backlight-cycle"
      "  DEVICE=\"white:kbd_backlight\"\n  CURRENT=$(${pkgs.brightnessctl}/bin/brightnessctl --device=\"$DEVICE\" get)\n  if [ \"$CURRENT\" -eq 0 ]; then\n      ${pkgs.brightnessctl}/bin/brightnessctl --device=\"$DEVICE\" set 1\n  elif [ \"$CURRENT\" -eq 1 ]; then\n      ${pkgs.brightnessctl}/bin/brightnessctl --device=\"$DEVICE\" set 2\n  elif [ \"$CURRENT\" -eq 2 ]; then\n      ${pkgs.brightnessctl}/bin/brightnessctl --device=\"$DEVICE\" set 3\n  elif [ \"$CURRENT\" -eq 3 ]; then\n      ${pkgs.brightnessctl}/bin/brightnessctl --device=\"$DEVICE\" set 4\n  else\n      ${pkgs.brightnessctl}/bin/brightnessctl --device=\"$DEVICE\" set 0\n  fi\n")
  ];

  system.stateVersion = "25.11";
}
