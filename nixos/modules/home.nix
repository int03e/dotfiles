{ ... }:

{
  home.username = "int03e";
  home.homeDirectory = "/home/int03e";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  xdg.configFile = {
    "hypr/hyprland.conf".source = ../files/config/hypr/hyprland.conf;
    "hypr/hypridle.conf".source = ../files/config/hypr/hypridle.conf;
    "hypr/hyprlock.conf".source = ../files/config/hypr/hyprlock.conf;
    "hypr/scripts" = {
      source = ../files/config/hypr/scripts;
      recursive = true;
    };

    "noctalia/config.toml".source = ../files/config/noctalia/config.toml;

    "kitty/kitty.conf".source = ../files/config/kitty/kitty.conf;

    "waybar/config".source = ../files/config/waybar/config;
    "waybar/style.css".source = ../files/config/waybar/style.css;

    "wofi/config".source = ../files/config/wofi/config;
    "wofi/style.css".source = ../files/config/wofi/style.css;

    "swaync/config.json".source = ../files/config/swaync/config.json;
    "swaync/style.css".source = ../files/config/swaync/style.css;

    "kanshi/config".source = ../files/config/kanshi/config;

    "mpv/mpv.conf".source = ../files/config/mpv/mpv.conf;

    "btop/btop.conf".source = ../files/config/btop/btop.conf;
    "btop/themes" = {
      source = ../files/config/btop/themes;
      recursive = true;
    };

    "cava/shaders" = {
      source = ../files/config/cava/shaders;
      recursive = true;
    };
    "cava/themes" = {
      source = ../files/config/cava/themes;
      recursive = true;
    };

    "lazydocker/config.yml".source = ../files/config/lazydocker/config.yml;
    "lazygit/config.yml".source = ../files/config/lazygit/config.yml;

    "yazi/keymap.toml".source = ../files/config/yazi/keymap.toml;
    "yazi/yazi.toml".source = ../files/config/yazi/yazi.toml;
    "yazi/plugins" = {
      source = ../files/config/yazi/plugins;
      recursive = true;
    };

    "fish/config.fish".source = ../files/config/fish/config.fish;
    "fish/functions" = {
      source = ../files/config/fish/functions;
      recursive = true;
    };
    "fish/conf.d" = {
      source = ../files/config/fish/conf.d;
      recursive = true;
    };

    "git/ignore".source = ../files/config/git/ignore;

    "starship.toml".source = ../files/config/starship.toml;
    "mimeapps.list".source = ../files/config/mimeapps.list;
    "QtProject.conf".source = ../files/config/QtProject.conf;
  };
}
