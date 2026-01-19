{ pkgs, ... }:

{
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "1";
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelModules = [ "tuxedo_keyboard" "tuxedo_io" ];
  boot.initrd.kernelModules = [ "amdgpu" ];

  boot.kernelParams = [
    "acpi_backlight=native"
    "amdgpu.backlight=0"
    "video.use_native_backlight=1"
  ];

  hardware.tuxedo-drivers.enable = true;
  hardware.tuxedo-rs = {
    enable = true;
    tailor-gui.enable = true;
  };

  systemd.tmpfiles.rules = [ "d /mnt/media 0755 root root -" ];

  fileSystems."/mnt/media" = {
    device = "/dev/disk/by-uuid/2f8f0bfa-bd2f-435f-a671-b84baade1549";
    fsType = "btrfs";
    options = [ "defaults" "nofail" "compress=zstd" ];
  };
}
