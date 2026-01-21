{ pkgs, ... }:

{
  boot = {
    loader.grub = {
      enable = true;
      device = "nodev"; # "nodev" is required for UEFI setups
      efiSupport = true;

      # 3. Enable OS Prober to find Tuxedo OS on the other SSD
      useOSProber = true;
    };

    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;

    kernelModules = [ "tuxedo_keyboard" "tuxedo_io" ];
    initrd.kernelModules = [ "amdgpu" ];

    kernelParams = [
      "acpi_backlight=native"
      "amdgpu.backlight=0"
      "video.use_native_backlight=1"
    ];
  };

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
