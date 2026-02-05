{
  programs.nixvim = {
    plugins.which-key = {
      enable = true;
      settings = {
        preset = "helix";
        spec = [
          {
            __unkeyed = "<leader>s";
            group = "Search";
            icon = "";
          }
          {
            __unkeyed = "<leader>c";
            group = "Code";
            icon = "󰅩";
          }
        ];
      };
    };

    keymaps = [
      # Reserve space for leader
      {
        mode = "n";
        key = "<SPACE>";
        action = "<Nop>";
      }

      # Clear highlighting on escape
      {
        mode = "n";
        action = "<cmd>noh<cr><esc>";
        key = "<esc>";
        options.silent = true;
      }

      # Close buffer
      {
        mode = "n";
        action = "<cmd>bd<cr>";
        key = "<leader>bd";
        options.silent = true;
      }

      # Better up/down
      {
        mode = [
          "n"
          "x"
        ];
        key = "j";
        action = "v:count == 0 ? 'gj' : 'j'";
        options = {
          desc = "Down";
          expr = true;
          silent = true;
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<Down>";
        action = "v:count == 0 ? 'gj' : 'j'";
        options = {
          desc = "Down";
          expr = true;
          silent = true;
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "k";
        action = "v:count == 0 ? 'gk' : 'k'";
        options = {
          desc = "Up";
          expr = true;
          silent = true;
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<Up>";
        action = "v:count == 0 ? 'gk' : 'k'";
        options = {
          desc = "Up";
          expr = true;
          silent = true;
        };
      }

      # Move between windows with <ctrl> arrow keys
      {
        mode = "n";
        key = "<C-Left>";
        action = "<C-w>h";
        options = {
          desc = "Go to left window";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = "<C-w>l";
        options = {
          desc = "Go to right window";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<C-Up>";
        action = "<C-w>k";
        options = {
          desc = "Go to upper window";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<C-Down>";
        action = "<C-w>j";
        options = {
          desc = "Go to lower window";
          remap = true;
        };
      }

      # Undo break-points
      {
        mode = "i";
        key = ",";
        action = ",<c-g>u";
      }
      {
        mode = "i";
        key = ".";
        action = ".<c-g>u";
      }
      {
        mode = "i";
        key = ";";
        action = ";<c-g>u";
      }

      # Save file
      {
        mode = [
          "i"
          "x"
          "n"
          "s"
        ];
        key = "<C-s>";
        action = "<cmd>w<cr><esc>";
        options = {
          desc = "Save file";
        };
      }

      # Windowing
      {
        mode = "n";
        key = "<leader>w";
        action = "<c-w>";
        options = {
          desc = "Windows";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<leader>-";
        action = "<C-W>s";
        options = {
          desc = "Split window below";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<leader>|";
        action = "<C-W>v";
        options = {
          desc = "Split window right";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<leader>wd";
        action = "<C-W>c";
        options = {
          desc = "Delete window";
          remap = true;
        };
      }

      # Grug-far
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>sr";
        action = "<cmd>lua require('grug-far').open({ transient = true })<cr>";
        options = {
          silent = true;
          desc = "Find and replace";
        };
      }

      # Oil
      {
        mode = "n";
        key = "<Tab>";
        action.__raw = "
          function()
            vim.cmd((vim.bo.filetype == 'oil') and 'bp' or 'Oil')
          end
        ";
        options.desc = "Toggle file explorer";
      }

      # Flash
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "s";
        action = "<cmd>lua require('flash').jump()<cr>";
        options = {
          desc = "Flash";
        };
      }
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "S";
        action = "<cmd>lua require('flash').treesitter()<cr>";
        options = {
          desc = "Flash treesitter";
        };
      }
      {
        mode = "o";
        key = "r";
        action = "<cmd>lua require('flash').remote()<cr>";
        options = {
          desc = "Remote flash";
        };
      }
      {
        mode = [
          "o"
          "x"
        ];
        key = "R";
        action = "<cmd>lua require('flash').treesitter_search()<cr>";
        options = {
          desc = "Treesitter search";
        };
      }
      {
        mode = "c";
        key = "<c-s>";
        action = "<cmd>lua require('flash').toggle()<cr>";
        options = {
          desc = "Toggle flash search";
        };
      }
    ];

    # LSP keymaps
    plugins.lsp.keymaps = {
      lspBuf = {
        K = "hover";
        gr = "references";
        gd = "definition";
        gi = "implementation";
        gt = "type_definition";
      };
      extra = [
        {
          mode = "n";
          key = "<leader>cr";
          action.__raw = "
            function()
              return ':IncRename ' .. vim.fn.expand('<cword>') 
            end
          ";
          options = {
            desc = "Rename";
            expr = true;
          };
        }
        {
          mode = [
            "n"
            "v"
          ];
          key = "<leader>ca";
          action.__raw = "
            function()
              vim.lsp.buf.code_action()
            end
          ";
          options = {
            desc = "Code action";
          };
        }
        {
          mode = "n";
          key = "<leader>cd";
          action.__raw = "require('telescope.builtin').lsp_definitions";
          options.desc = "LSP Definitions";
        }
      ];
    };

    plugins.telescope.keymaps = {
      "<leader><leader>" = {
        action = "find_files";
        options = {
          desc = "Find files";
        };
      };
      "<leader>/" = {
        action = "live_grep";
        options = {
          desc = "Live grep";
        };
      };
      "<leader>E" = {
        action = "buffers";
        options = {
          desc = "Buffers";
        };
      };
    };
  };
}
