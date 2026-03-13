{ pkgs, inputs, ... }:

inputs.nixvim.legacyPackages.${pkgs.system}.makeNixvim {
  colorschemes.catppuccin.enable = true;

  clipboard = {
    providers = {
      wl-copy.enable = true; # For Wayland
      xclip.enable = true; # For X11
    };
  };

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

  # Briefly highlight text when you copy (yank) it
  autoGroups = {
    highlight_yank = {
      clear = true;
    };
  };
  autoCmd = [
    {
      event = "TextYankPost";
      group = "highlight_yank";
      callback = {
        __raw = "function() vim.highlight.on_yank() end";
      };
    }
  ];

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

    # --- LSP Keymaps ---
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
      key = "K";
      action = "<cmd>lua vim.lsp.buf.hover()<cr>";
      options.desc = "Hover Documentation";
    }
    {
      mode = "n";
      key = "<leader>cr";
      action = "<cmd>lua vim.lsp.buf.rename()<cr>";
      options.desc = "Rename Symbol";
    }
    {
      mode = "n";
      key = "[d";
      action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
      options.desc = "Previous Diagnostic";
    }
    {
      mode = "n";
      key = "]d";
      action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
      options.desc = "Next Diagnostic";
    }

    {
      mode = "n";
      key = "<leader>cf";
      action = ''<cmd>lua require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 500 })<cr>'';
      options.desc = "Format";
    }

    # --- Search & Find ---
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

    # --- Tools ---
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

    # --- Buffers ---
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
    {
      mode = "n";
      key = "<leader>bo";
      action = "<cmd>lua Snacks.bufdelete.other()<cr>";
      options.desc = "Delete Other Buffers";
    }

    # --- Git Hunk Keymaps ---
    {
      mode = "n";
      key = "<leader>ghp";
      action = "<cmd>Gitsigns preview_hunk<cr>";
      options.desc = "Preview Git Hunk (Diff)";
    }
    {
      mode = "n";
      key = "<leader>ghd";
      action = "<cmd>Gitsigns toggle_deleted<cr>";
      options.desc = "Toggle Git Deleted Lines";
    }
    {
      mode = "n";
      key = "<leader>ghu";
      action = "<cmd>Gitsigns reset_hunk<cr>";
      options.desc = "Undo Git Hunk (Reset)";
    }

    # NEW: Flash Keymaps
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "<leader>jj";
      action = "<cmd>lua require('flash').jump()<cr>";
      options.desc = "Flash Jump";
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "<leader>jt";
      action = "<cmd>lua require('flash').treesitter()<cr>";
      options.desc = "Flash Treesitter";
    }
    {
      mode = "o";
      key = "<leader>jr";
      action = "<cmd>lua require('flash').remote()<cr>";
      options.desc = "Remote Flash";
    }
    {
      mode = [
        "o"
        "x"
      ];
      key = "<leader>js";
      action = "<cmd>lua require('flash').treesitter_search()<cr>";
      options.desc = "Treesitter Search";
    }
  ];

  plugins = {
    web-devicons.enable = true;
    bufferline.enable = true;
    lualine.enable = true;
    neo-tree.enable = true;
    oil.enable = true;
    grug-far.enable = true;

    # NEW: Enable Flash.nvim
    flash.enable = true;

    which-key = {
      enable = true;
      settings = {
        spec = [
          {
            __unkeyed-1 = "<leader>b";
            group = "Buffers";
          }
          {
            __unkeyed-1 = "<leader>c";
            group = "Code";
          }
          {
            __unkeyed-1 = "<leader>g";
            group = "Git/Find";
          }
          {
            __unkeyed-1 = "<leader>gh";
            group = "Git Hunk";
          }
          {
            # NEW: Register <leader>j group in which-key
            __unkeyed-1 = "<leader>j";
            group = "Jump/Flash";
          }
          {
            __unkeyed-1 = "<leader>s";
            group = "Search";
          }
          {
            __unkeyed-1 = "<leader>t";
            group = "Todos";
          }
        ];
      };
    };

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
        word_diff = true;
      };
    };

    mini = {
      enable = true;
      modules = {
        ai = { };
        pairs = { };
      };
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

    treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        ensure_installed = "all";
      };
    };

    lsp = {
      enable = true;
      servers = {
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
}
