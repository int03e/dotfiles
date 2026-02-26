{ pkgs, inputs, ... }:

inputs.nixvim.legacyPackages.${pkgs.system}.makeNixvim {
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
}
