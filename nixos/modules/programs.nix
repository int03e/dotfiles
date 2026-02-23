{ pkgs, lib, inputs, ... }:

let
  nixvimPkg = inputs.nixvim.legacyPackages.${pkgs.system}.makeNixvim {
    colorschemes.catppuccin.enable = true;

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      termguicolors = true;
      clipboard = "unnamedplus";
      completeopt = "menu,menuone,noselect";
    };

    globals.mapleader = " ";

    keymaps = [
      {
        mode = "n";
        key = "-";
        action = "<cmd>Oil<cr>";
        options.desc = "Open Parent Directory (Oil)";
      }
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<cr>";
        options.desc = "Explorer (Neo-tree)";
      }
      {
        mode = "n";
        key = "gd";
        action = "<cmd>lua Snacks.picker.lsp_definitions()<cr>";
        options.desc = "Goto Definition";
      }
      {
        mode = "n";
        key = "gr";
        action = "<cmd>lua Snacks.picker.lsp_references()<cr>";
        options.desc = "References";
      }
      {
        mode = "n";
        key = "<leader>ca";
        action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
        options.desc = "Code Action";
      }
      {
        mode = "n";
        key = "<leader>cf";
        action = ''<cmd>lua require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 500 })<cr>'';
        options.desc = "Format";
      }
      {
        mode = "n";
        key = "<leader>sr";
        action = "<cmd>GrugFar<cr>";
        options.desc = "Search and Replace";
      }
      {
        mode = "n";
        key = "<leader>sg";
        action = "<cmd>lua Snacks.picker.grep()<cr>";
        options.desc = "Grep (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>lua Snacks.picker.files()<cr>";
        options.desc = "Find Files (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>lua Snacks.lazygit.open()<cr>";
        options.desc = "Lazygit (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>td";
        action = "<cmd>Dooing<cr>";
        options.desc = "Todo List (Dooing)";
      }
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>BufferLineCyclePrev<cr>";
        options.desc = "Prev Buffer";
      }
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>BufferLineCycleNext<cr>";
        options.desc = "Next Buffer";
      }
      {
        mode = "n";
        key = "[b";
        action = "<cmd>BufferLineCyclePrev<cr>";
        options.desc = "Prev Buffer";
      }
      {
        mode = "n";
        key = "]b";
        action = "<cmd>BufferLineCycleNext<cr>";
        options.desc = "Next Buffer";
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>lua Snacks.bufdelete()<cr>";
        options.desc = "Delete Buffer";
      }
    ];

    plugins = {
      web-devicons.enable = true;
      bufferline.enable = true;
      lualine.enable = true;
      which-key.enable = true;
      neo-tree.enable = true;
      oil.enable = true;
      grug-far.enable = true;

      cmp = {
        enable = true;
        settings = {
          autoEnableSources = true;
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          mapping = {
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
        };
      };

      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;
          current_line_blame_opts = {
            virt_text = true;
            virt_text_pos = "eol";
            delay = 500;
          };
        };
      };

      mini = {
        enable = true;
        modules.ai = { };
      };

      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            lsp_fallback = true;
            timeout_ms = 1000;
          };
          formatters_by_ft = {
            lua = [ "stylua" ];
            nix = [ "nixfmt" ];
            javascript = [ "prettier" ];
            typescript = [ "prettier" ];
            javascriptreact = [ "prettier" ];
            typescriptreact = [ "prettier" ];
            json = [ "prettier" ];
            html = [ "prettier" ];
            css = [ "prettier" ];
          };
        };
      };

      snacks = {
        enable = true;
        settings = {
          picker.enabled = true;
          lazygit.enabled = true;
          notifier.enabled = true;
          words.enabled = true;
          input.enabled = true;
          bufdelete.enabled = true;
        };
      };

      treesitter.enable = true;

      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;
          nixd = {
            enable = true;
            settings = {
              nixpkgs = {
                expr = "import <nixpkgs> { }";
              };
              formatting = {
                command = [ "nixfmt" ];
              };
              options = {
                nixos = {
                  expr = "(attributes (import <nixpkgs/nixos> { configuration = [ ]; })).options";
                };
              };
            };
          };
          vtsls = {
            enable = true;
            settings = {
              vtsls.autoUseWorkspaceTsdk = true;
              typescript = {
                suggest = {
                  completeFunctionCalls = true;
                  autoImports = true;
                };
                updateImportsOnFileMove = {
                  enabled = "always";
                };
              };
              javascript = {
                suggest = {
                  autoImports = true;
                };
              };
            };
          };
        };
      };
    };

    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "dooing";
        src = pkgs.fetchFromGitHub {
          owner = "atiladefreitas";
          repo = "dooing";
          rev = "master";
          hash = "sha256-0WXYtNpjl5U7waO6SyMSx0H7SKbKKWrnmMFxSGRVIAk=";
        };
      })
    ];

    extraConfigLua = ''
      require("dooing").setup({})
    '';

    autoCmd = [
      {
        event = [ "BufWritePre" ];
        pattern = [
          "*.ts"
          "*.tsx"
          "*.js"
          "*.jsx"
        ];
        callback = {
          __raw = ''
            function()
              vim.lsp.buf.code_action({
                context = { only = { "source.addMissingImports.ts" }, diagnostics = {} },
                apply = true,
              })
              vim.lsp.buf.code_action({
                context = { only = { "source.organizeImports.ts" }, diagnostics = {} },
                apply = true,
              })
            end
          '';
        };
      }
    ];
  };
in
{
  environment.variables = {
    DIRENV_LOG_FORMAT = "";
    NIXPKGS_ALLOW_UNFREE = "1";
    EDITOR = "nvim";
  };

  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;

  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    set fish_greeting
    abbr -a nr 'sudo nixos-rebuild switch --flake ~/projects/dotfiles/nixos#nixos'
    abbr -a nt 'sudo nixos-rebuild test --flake ~/projects/dotfiles/nixos#nixos'
    abbr -a gc3 'sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +3 && sudo nix-collect-garbage'
    abbr -a bat-desk 'echo "stationary" | sudo tee /sys/devices/platform/tuxedo_keyboard/charging_profile/charging_profile'
    abbr -a bat-full 'echo "high_capacity" | sudo tee /sys/devices/platform/tuxedo_keyboard/charging_profile/charging_profile'
    abbr -a bat-status 'upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state|energy-rate|percentage"'
    ${pkgs.starship}/bin/starship init fish | source
  '';

  programs.starship.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableFishIntegration = true;
    silent = true;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
  ];

  programs.neovim.enable = false;

  programs.firefox = {
    enable = true;
    preferences = {
      "browser.startup.page" = 3;
      "browser.sessionstore.max_resumed_crashes" = 10;
      "browser.sessionstore.resume_from_crash" = true;
      "browser.tabs.restore_on_demand" = true;
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
    ];
    extraConfig = ''
      set -g base-index 1
      setw -g pane-base-index 1
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '15'
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      set -g mouse on
      set -g status-style bg=colour65,fg=white
      set-window-option -g window-status-current-style bg=colour108,fg=black,bold
      set -g status-right 'Bat: #(acpi | grep -o "[0-9]*%") | %H:%M '
      set -g status-right-length 50
    '';
  };

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  environment.systemPackages = with pkgs; [
    nixvimPkg
    (runCommand "nv-alias" { } ''
      mkdir -p $out/bin
      ln -s ${pkgs.neovim}/bin/nvim $out/bin/nv
    '')
    (runCommand "vim-aliases" { } ''
      mkdir -p $out/bin
      ln -s ${nixvimPkg}/bin/nvim $out/bin/vim
      ln -s ${nixvimPkg}/bin/nvim $out/bin/vi
    '')
    wl-clipboard
    protontricks
    via
    socat
    luarocks
    kanshi
    wget
    vial
    lazydocker
    gcc
    gnumake
    curl
    git
    ripgrep
    fd
    unzip
    fzf
    wlogout
    lazygit
    vlc
    slack
    kitty
    btop
    dbeaver-bin
    bruno
    starship
    nixd
    nixfmt
    statix
    deadnix
    direnv
    waybar
    libnotify
    networkmanagerapplet
    swaynotificationcenter
    wofi
    swaybg
    blueman
    bibata-cursors
    adwaita-icon-theme
    pavucontrol
    hyprshot
    grim
    slurp
    brightnessctl
    wireplumber
    libinput
    acpi
    hypridle
    google-cloud-sdk
    google-cloud-sql-proxy
    nodePackages.typescript-language-server
    vtsls
    nodePackages.prettier
    stylua
    stow
    bc
    transmission_4-gtk
    yazi
    bat
    telegram-desktop
    lua-language-server

    (writeShellScriptBin "kbd-backlight-cycle" "  DEVICE=\"white:kbd_backlight\"\n  CURRENT=$(${pkgs.brightnessctl}/bin/brightnessctl --device=\"$DEVICE\" get)\n  if [ \"$CURRENT\" -eq 0 ]; then\n      ${pkgs.brightnessctl}/bin/brightnessctl --device=\"$DEVICE\" set 1\n  elif [ \"$CURRENT\" -eq 1 ]; then\n      ${pkgs.brightnessctl}/bin/brightnessctl --device=\"$DEVICE\" set 2\n  elif [ \"$CURRENT\" -eq 2 ]; then\n      ${pkgs.brightnessctl}/bin/brightnessctl --device=\"$DEVICE\" set 3\n  elif [ \"$CURRENT\" -eq 3 ]; then\n      ${pkgs.brightnessctl}/bin/brightnessctl --device=\"$DEVICE\" set 4\n  else\n      ${pkgs.brightnessctl}/bin/brightnessctl --device=\"$DEVICE\" set 0\n  fi\n")
  ];
}
