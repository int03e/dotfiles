{ pkgs, ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  services.blueman.enable = true;
  services.power-profiles-daemon.enable = false;

  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than +3";
  };
  nix.settings.auto-optimise-store = true;

  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    persistent = true;
    flake = "/home/int03e/projects/dotfiles/nixos#nixos";
    flags = [
      "--update-input"
      "nixpkgs"
      "--update-input"
      "nixvim"
    ];
  };

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    lidSwitchExternalPower = "suspend"; # Stays in sleep if plugged in
  };

  services.udev.packages = [ pkgs.via ];

  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowSuspendThenHibernate=yes
    HibernateDelaySec=30m
  '';

  services.gnome.evolution-data-server.enable = true;
  services.gnome.gnome-online-accounts.enable = true;
  services.gnome.gnome-keyring.enable = true;

  systemd.services.tuxedo-battery-set = {
    description = "Set Tuxedo battery charging profile";
    after = [
      "multi-user.target"
      "post-resume.target"
    ];
    wantedBy = [
      "multi-user.target"
      "post-resume.target"
    ];
    script = ''
      echo "stationary" > /sys/devices/platform/tuxedo_keyboard/charging_profile/charging_profile
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
  };

  systemd.services.nixos-upgrade = {
    postStop = ''
      USER_NAME="int03e"
      USER_ID=$(${pkgs.coreutils}/bin/id -u $USER_NAME)
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
}
