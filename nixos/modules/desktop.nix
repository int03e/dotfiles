{ pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      desktopManager.gnome.extraGSettingsOverrides = ''
        [org/gnome/desktop/peripherals/touchpad]
        natural-scroll=true
      '';
    };

    logind.lidSwitch = "ignore";

    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };

    pulseaudio.enable = false;
    # security.rtkit.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
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
