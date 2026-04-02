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
      "-L"
      "--recreate-lock-file"
    ];
  };

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    lidSwitchExternalPower = "suspend";
  };

  services.udev.packages = [ pkgs.via ];

  services.gnome.evolution-data-server.enable = true;
  services.gnome.gnome-online-accounts.enable = true;
  services.gnome.gnome-keyring.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  systemd.services.nixos-upgrade = {
    onSuccess = [ "nixos-upgrade-notify-success.service" ];
    onFailure = [ "nixos-upgrade-notify-failure.service" ];
  };

  systemd.services.nixos-upgrade-notify-success = {
    script = "${pkgs.libnotify}/bin/notify-send -u normal 'System Update Successful' 'All apps and system packages are now up to date.'";
    serviceConfig = {
      User = "int03e";
      Environment = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus";
    };
  };

  systemd.services.nixos-upgrade-notify-failure = {
    script = "${pkgs.libnotify}/bin/notify-send -u critical 'System Update Failed' 'Weekly upgrade encountered an error. Check journalctl -u nixos-upgrade.service.'";
    serviceConfig = {
      User = "int03e";
      Environment = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus";
    };
  };
}
