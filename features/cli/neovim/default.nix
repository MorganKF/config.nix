{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  neovim = config.features.cli.neovim;
in
{
  options.features.cli.neovim.enable = mkEnableOption "Enable neovim";

  imports = [
    ./keymaps.nix
    ./autocmds.nix
    ./harpoon.nix
    ./dashboard.nix
  ];

  config = mkIf neovim.enable {
    programs.nixvim = {
      enable = true;
      package = inputs.neovim-nightly.packages.${pkgs.system}.default;
      defaultEditor = true;
      performance.byteCompileLua = {
        enable = true;
        nvimRuntime = true;
        plugins = true;
      };
      extraPackages = pkgs.lib.optionals pkgs.stdenv.isLinux [
        pkgs.wl-clipboard
      ];
      globals = {
        mapleader = " ";
        maplocalleader = "\\";
        markdown_fenced_languages = [
          "ts=typescript"
        ];
      };
      opts = {
        number = true;
        relativenumber = true;
        autowrite = true;
        confirm = true;
        expandtab = true;
        shiftwidth = 2;
        smartcase = true;
        smartindent = true;
        tabstop = 2;
        termguicolors = true;
        undofile = true;
        undolevels = 10000;
        updatetime = 200;
        virtualedit = "block";
        clipboard = "unnamedplus";
        wildmode = "longest:full,full";
        wrap = false;
      };
      colorschemes.nightfox = {
        enable = true;
        flavor = "carbonfox";
      };
      plugins.flash.enable = true;
      plugins.lualine = {
        enable = true;
        settings = {
          options = {
            theme = "auto";
          };
          sections.lualine_x.__raw = "{
          {
            require('noice').api.statusline.mode.get,
            cond = require('noice').api.statusline.mode.has,
            color = { fg = '#ff9e64' },
          }
        }";
        };
      };
      plugins.oil = {
        enable = true;
        settings = {
          win_options = {
            winbar = "%#@attribute.builtin#%{substitute(v:lua.require('oil').get_current_dir(), '^' . $HOME, '~', '')}";
          };
        };
      };
      plugins.gitsigns.enable = true;
      plugins.telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
        };
      };
      plugins.blink-cmp = {
        enable = true;
        settings = {
          keymap = {
            preset = "super-tab";
          };
          sources = {
            providers = {
              buffer = {
                score_offset = -7;
              };
            };
          };
          completion.menu.draw.components.kind_icon = {
            ellipsis = false;
            text.__raw = "
              function(ctx)
                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                return kind_icon
              end
            ";
            highlight.__raw = "
              function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
              end
            ";
          };
        };
      };
      plugins.persisted.enable = true;
      plugins.noice = {
        enable = true;
        settings.presets = {
          inc_rename = true;
          lsp_doc_border = true;
        };
      };
      plugins.dressing = {
        enable = true;
        settings = {
          select = {
            enable = true;
            backend = [
              "telescope"
              "builtin"
            ];
            telescope.__raw = "require('telescope.themes').get_cursor()";
          };
        };
      };
      plugins.neoscroll = {
        enable = true;
      };
      plugins.indent-blankline = {
        enable = true;
        settings = {
          scope.enabled = true;
          exclude = {
            filetypes = [
              "alpha"
              "help"
              "terminal"
            ];
          };
        };
      };
      plugins.inc-rename.enable = true;
      plugins.mini = {
        enable = true;
        mockDevIcons = true;
        modules = {
          icons = { };
          cursorword = { };
          ai = { };
          pairs = {
            modes = {
              insert = true;
              command = true;
            };
            skip_ts = [ "string" ];
            skip_unbalanced = true;
            markdown = true;
          };
          surround = {
            mappings = {
              add = "gsa";
              delete = "gsd";
              find = "gsf";
              find_left = "gsF";
              highlight = "gsh";
              replace = "gsr";
              update_n_lines = "gsn";
            };
          };
        };
      };
      plugins.ts-autotag.enable = true;
      plugins.grug-far = {
        enable = true;
        settings = {
          debounceMs = 1000;
          engine = "ripgrep";
          engines = {
            ripgrep = {
              path = lib.getExe pkgs.ripgrep;
              showReplaceDiff = true;
            };
          };
          maxSearchMatches = 2000;
          maxWorkers = 8;
          minSearchChars = 1;
          normalModeSearch = false;
        };
      };
      plugins.treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };
      plugins.lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;
          nushell.enable = true;
          zls.enable = true;
          slint_lsp.enable = true;
          vtsls = {
            enable = true;
            # Autostart with autocmd
            autostart = false;
          };
          gopls.enable = true;
          denols = {
            enable = true;
            autostart = false;
            rootMarkers = [
              "deno.json"
              "deno.jsonc"
            ];
          };
          biome.enable = true;
          eslint.enable = true;
          tailwindcss.enable = true;
        };
      };
      plugins.lsp-lines = {
        enable = true;
        luaConfig.post = "
          vim.diagnostic.config({ virtual_lines = { only_current_line = true } })
        ";
      };
      plugins.friendly-snippets.enable = true;
      plugins.rustaceanvim.enable = true;
      plugins.conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            timeout_ms = 1000;
            lsp_format = "fallback";
          };
          formatters_by_ft = {
            nix = [ "nixfmt" ];
            zig = [ "zig fmt" ];
            javascript = {
              __unkeyed-2 = "prettier";
              timeout_ms = 2000;
              stop_after_first = true;
            };
            typescript = {
              __unkeyed-1 = "deno fmt";
              __unkeyed-2 = "prettier";
              timeout_ms = 2000;
              stop_after_first = true;
            };
            javascriptreact = {
              __unkeyed-2 = "prettier";
              timeout_ms = 2000;
              stop_after_first = true;
            };
            typescriptreact = {
              __unkeyed-1 = "deno fmt";
              __unkeyed-2 = "prettier";
              timeout_ms = 2000;
              stop_after_first = true;
            };
            json = {
              __unkeyed-1 = "deno fmt";
              __unkeyed-2 = "biome";
              __unkeyed-3 = "prettier";
              timeout_ms = 2000;
              stop_after_first = true;
            };
            css = {
              __unkeyed-2 = "biome";
              __unkeyed-3 = "prettier";
              timeout_ms = 2000;
              stop_after_first = true;
            };
          };
          formatters = {
            nixfmt = {
              command = lib.getExe pkgs.nixfmt;
            };
          };
        };
      };
    };
  };
}
