{ pkgs, lib, ... }:

{
  # --- 2. BOOT & KERNEL CONFIG ---
  boot = {
    # This now automatically points to the overridden set above
    kernelPackages = pkgs.linuxPackages_latest;

    # Load the modules by name
    kernelModules = [
      "tuxedo_keyboard"
      "tuxedo_io"
    ];

    # Conflict Prevention
    blacklistedKernelModules = [
      "asus_wmi"
      "asus_nb_wmi"
      "uniwill_wmi"
      "clevo_wmi"
    ];

    extraModprobeConfig = ''
      # Required for Gen 10 battery logic on v4 drivers
      options tuxedo_keyboard tuxedo_io force_io=1

      # Force hijacker drivers to stay dead
      install asus_wmi /run/current-system/sw/bin/false
      install asus_nb_wmi /run/current-system/sw/bin/false
      install uniwill_wmi /run/current-system/sw/bin/false
      install clevo_wmi /run/current-system/sw/bin/false
    '';

    kernelParams = [
      "tuxedo_keyboard.support_battery_extension=1"
      "acpi_backlight=native"
      "amdgpu.backlight=0"
      "video.use_native_backlight=1"
      # Hibernation settings (previously confirmed working)
      "resume=/dev/disk/by-uuid/2a88ba25-c2ba-48c0-988a-09009ea1efdd"
      "resume_offset=239663104"
      "rtc_cmos.use_acpi_alarm=1"
    ];

    resumeDevice = "/dev/disk/by-uuid/2a88ba25-c2ba-48c0-988a-09009ea1efdd";

    # HiDPI Grub Fix
    loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      gfxmodeEfi = "1024x768";
      fontSize = 32;
    };
  };

  # --- 3. HARDWARE MODULES ---
  # Enable the official module; it will now use our 4.20.1 package
  hardware.tuxedo-drivers = {
    enable = true;
    settings = {
      charging-profile = "stationary"; # Or "balanced", etc.
    };
  };

  hardware.tuxedo-rs = {
    enable = true;
    tailor-gui.enable = true;
  };

  # --- 4. POWER MANAGEMENT (Lid & Sleep) ---
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

  # --- 5. AUTOMATIC BATTERY LIMIT ---
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
      ${pkgs.coreutils}/bin/sleep 20
      TUX_PATH="/sys/devices/platform/tuxedo_keyboard/charging_profile/charging_profile"
      if [ -f "$TUX_PATH" ]; then
        echo "stationary" > "$TUX_PATH"
      fi
    '';
    serviceConfig.Type = "oneshot";
  };

  # --- 6. STORAGE & CONSOLE ---
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
