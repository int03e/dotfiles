{ pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.desktopManager.gnome.extraGSettingsOverrides = ''
    [org/gnome/desktop/peripherals/touchpad]
    natural-scroll=true
  '';

  services.logind.lidSwitch = "ignore";

  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
    noto-fonts
    noto-fonts-color-emoji
  ];
  fonts.fontconfig.enable = true;
}
