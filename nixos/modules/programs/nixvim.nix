{ pkgs, inputs, ... }:

inputs.nixvim.legacyPackages.${pkgs.system}.makeNixvim {
  colorschemes.catppuccin.enable = true;

  clipboard = {
    providers = {
      wl-copy.enable = true;
      xclip.enable = true;
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
      key = "<leader>fo";
      action = "<cmd>Oil<cr>";
      options.desc = "Open Oil";
    }
    {
      mode = "n";
      key = "<leader>fy";
      action = "<cmd>Yazi<cr>";
      options.desc = "Open Yazi";
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
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>sr";
      action = "<cmd>GrugFar<cr>";
      options.desc = "Search and Replace";
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>sf";
      action = "<cmd>lua require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } })<CR>";
      options.desc = "Search and Replace (Current File)";
    }
    {
      mode = "n";
      key = "<leader>sg";
      action = "<cmd>lua Snacks.picker.grep({ args = { \"-S\", \"-F\" } })<cr>";
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
    {
      mode = "n";
      key = "<leader>cu";
      action = "<cmd>UndotreeToggle<cr>";
      options.desc = "Undotree";
    }
    {
      mode = "n";
      key = "<leader>ghp";
      action = "<cmd>Gitsigns preview_hunk<cr>";
      options.desc = "Preview Git Hunk";
    }
    {
      mode = "n";
      key = "<leader>ghd";
      action = "<cmd>Gitsigns toggle_deleted<cr>";
      options.desc = "Toggle Git Deleted";
    }
    {
      mode = "n";
      key = "<leader>ghu";
      action = "<cmd>Gitsigns reset_hunk<cr>";
      options.desc = "Undo Git Hunk";
    }
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
  ];

  plugins = {
    web-devicons.enable = true;
    bufferline.enable = true;
    lualine.enable = true;
    neo-tree.enable = true;
    oil.enable = true;
    yazi.enable = true;
    grug-far.enable = true;
    flash.enable = true;

    undotree = {
      enable = true;
      settings = {
        focusOnToggle = true;
        highlightChangedText = true;
        windowLayout = 2;
        autoOpenDiff = true;
      };
    };

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
            __unkeyed-1 = "<leader>f";
            group = "Files/Find";
          }
          {
            __unkeyed-1 = "<leader>g";
            group = "Git/Find";
          }
          {
            __unkeyed-1 = "<leader>j";
            group = "Jump/Flash";
          }
          {
            __unkeyed-1 = "<leader>s";
            group = "Search";
          }
        ];
      };
    };

    cmp = {
      enable = true;
      settings = {
        sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
        mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };
      };
    };

    gitsigns = {
      enable = true;
      settings = {
        current_line_blame = true;
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
      };
    };
    snacks = {
      enable = true;
      settings = {
        picker.enabled = true;
        lazygit.enabled = true;
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
        nixd.enable = true;
        vtsls.enable = true;
      };
    };
  };

  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "dooing";
      src = pkgs.fetchFromGitHub {
        owner = "atiladefreitas";
        repo = "dooing";
        rev = "4beaedd7195e6df39f8c2a5bbae1db7eb6d952d3";
        hash = "sha256-cKGRCgdgETE9RyNGkDWnNe5m31s9vB6rGlI8+DhuSeg=";
      };
    })
  ];

  extraPackages = with pkgs; [
    yazi
    typescript-language-server
    nixd
    nixfmt-rfc-style
    prettierd
    stylua
  ];

  extraConfigLua = ''
    require("dooing").setup({})
    require("yazi").setup({})
  '';
}
