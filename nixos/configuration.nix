{
  imports = [
    ./hardware-configuration.nix
    ./modules/boot-hardware.nix
    ./modules/desktop.nix
    ./modules/services.nix
    ./modules/programs.nix
    ./modules/user.nix
  ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";
}
