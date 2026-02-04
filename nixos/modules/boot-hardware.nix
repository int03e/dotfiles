{ pkgs, ... }:

{
  boot = {
    loader.grub = {
      enable = true;
      device = "nodev"; # "nodev" is required for UEFI setups
      efiSupport = true;

      useOSProber = true;
    };

    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;

    kernelModules = [ "tuxedo_keyboard" "tuxedo_io" ];
    blacklistedKernelModules = [ "asus_wmi" "asus_nb_wmi" ];
    initrd.kernelModules = [ "amdgpu" ];

    kernelParams = [
      "acpi_backlight=native"
      "amdgpu.backlight=0"
      "video.use_native_backlight=1"
      "resume_offset=239663104"
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

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 34 * 1024; # Size in MB (e.g., 34GB for 32GB RAM)
  }];

  boot.resumeDevice = "/dev/disk/by-uuid/2a88ba25-c2ba-48c0-988a-09009ea1efdd";
}
