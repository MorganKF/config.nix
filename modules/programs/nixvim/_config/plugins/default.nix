{ pkgs, lib, ... }:
{
  imports = [
    ./harpoon.nix
    ./dashboard.nix
  ];

  plugins = {
    flash.enable = true;
    lualine = {
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
    oil = {
      enable = true;
      settings = {
        win_options = {
          winbar = "%#@attribute.builtin#%{substitute(v:lua.require('oil').get_current_dir(), '^' . $HOME, '~', '')}";
        };
      };
    };
    gitsigns.enable = true;
    telescope = {
      enable = true;
      extensions = {
        fzf-native.enable = true;
      };
    };
    blink-cmp = {
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
    persisted.enable = true;
    noice = {
      enable = true;
      settings.presets = {
        inc_rename = true;
        lsp_doc_border = true;
      };
    };
    dressing = {
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
    neoscroll = {
      enable = true;
    };
    indent-blankline = {
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
    inc-rename.enable = true;
    mini = {
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
    ts-autotag.enable = true;
    grug-far = {
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
    treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
    };
    lsp = {
      enable = true;
      servers = {
        nil_ls.enable = true;
        nushell.enable = true;
        zls.enable = true;
        slint_lsp.enable = true;
        vtsls.enable = true;
        gopls.enable = true;
        html.enable = true;
        emmet_language_server.enable = true;
        cssls.enable = true;
        denols.enable = true;
        svelte.enable = true;
        biome = {
          enable = true;
          cmd = [
            "${pkgs.biome}/bin/biome"
            "lsp-proxy"
          ];
        };
        eslint.enable = true;
      };
    };
    lsp-lines = {
      enable = true;
      luaConfig.post = "
          vim.diagnostic.config({ virtual_lines = { only_current_line = true } })
        ";
    };
    friendly-snippets.enable = true;
    rustaceanvim.enable = true;
    conform-nvim = {
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
            __unkeyed-1 = "biome";
            __unkeyed-2 = "prettier";
            timeout_ms = 2000;
            stop_after_first = true;
          };
          typescript = {
            __unkeyed-1 = "deno fmt";
            __unkeyed-2 = "biome";
            __unkeyed-3 = "prettier";
            timeout_ms = 2000;
            stop_after_first = true;
          };
          javascriptreact = {
            __unkeyed-2 = "biome";
            __unkeyed-1 = "prettier";
            timeout_ms = 2000;
            stop_after_first = true;
          };
          typescriptreact = {
            __unkeyed-1 = "deno fmt";
            __unkeyed-2 = "biome";
            __unkeyed-3 = "prettier";
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
            __unkeyed-1 = "biome";
            __unkeyed-2 = "prettier";
            timeout_ms = 2000;
            stop_after_first = true;
          };
        };
        formatters = {
          nixfmt.command = lib.getExe pkgs.nixfmt;
          biome.command = lib.getExe pkgs.biome;
        };
      };
    };
  };

}
