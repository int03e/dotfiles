{ pkgs, lib, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ ];
    blacklistedKernelModules = [
      "asus_wmi"
      "asus_nb_wmi"
      "uniwill_wmi"
      "clevo_wmi"
    ];
    extraModprobeConfig = ''
      install asus_wmi /run/current-system/sw/bin/false
      install asus_nb_wmi /run/current-system/sw/bin/false
      install uniwill_wmi /run/current-system/sw/bin/false
      install clevo_wmi /run/current-system/sw/bin/false
    '';
    kernelParams = [
      "acpi_backlight=native"
      "amdgpu.backlight=0"
      "video.use_native_backlight=1"
      "resume=/dev/disk/by-uuid/2a88ba25-c2ba-48c0-988a-09009ea1efdd"
      "resume_offset=239663104"
      "rtc_cmos.use_acpi_alarm=1"
    ];
    resumeDevice = "/dev/disk/by-uuid/2a88ba25-c2ba-48c0-988a-09009ea1efdd";
    loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      gfxmodeEfi = "2880x1800";
      theme = pkgs.sleek-grub-theme;
    };
  };

  hardware.tuxedo-rs = {
    enable = true;
    tailor-gui.enable = true;
  };

  services.logind = {
    lidSwitch = lib.mkForce "suspend-then-hibernate";
    lidSwitchExternalPower = lib.mkForce "suspend";
  };

  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "1h";
    AllowSuspend = "yes";
    AllowHibernation = "yes";
    AllowSuspendThenHibernate = "yes";
  };

  fileSystems."/mnt/media" = {
    device = "/dev/disk/by-uuid/2f8f0bfa-bd2f-435f-a671-b84baade1549";
    fsType = "btrfs";
    options = [
      "defaults"
      "nofail"
      "compress=zstd"
    ];
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 34 * 1024;
    }
  ];
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
}
