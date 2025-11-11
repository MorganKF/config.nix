{
  programs.nixvim = {
    plugins.alpha = {
      enable = true;
      layout.__raw = ''
        (function()
          local header_height = 8
          local button_count = 6
          local content_height = header_height + button_count + 4
          local win_height = vim.fn.winheight(0)
          local top_padding = math.max(0, math.floor((win_height - content_height) / 2))

          return {
            { type = "padding", val = top_padding },
            {
              type = "text",
              val = {
                "                                                     ",
                "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
                "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
                "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
                "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
                "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
                "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
                "                                                     ",
              },
              opts = { position = "center", hl = "Type" },
            },
            { type = "padding", val = 2 },
            {
              type = "group",
              val = {
                { type = "button", val = "󰱼  Find File", on_press = function() require('telescope.builtin').find_files() end, opts = { keymap = { "n", "f", ":Telescope find_files<CR>", { noremap = true, silent = true } }, shortcut = "f", position = "center", cursor = 5, width = 38, align_shortcut = "right", hl_shortcut = "Keyword" } },
                { type = "button", val = "  New File", on_press = function() vim.cmd('ene | startinsert') end, opts = { keymap = { "n", "n", ":ene <BAR> startinsert<CR>", { noremap = true, silent = true } }, shortcut = "n", position = "center", cursor = 5, width = 38, align_shortcut = "right", hl_shortcut = "Keyword" } },
                { type = "button", val = "󱎸  Find Text", on_press = function() require('telescope.builtin').live_grep() end, opts = { keymap = { "n", "g", ":Telescope live_grep<CR>", { noremap = true, silent = true } }, shortcut = "g", position = "center", cursor = 5, width = 38, align_shortcut = "right", hl_shortcut = "Keyword" } },
                { type = "button", val = "󰷊  Recent Files", on_press = function() require('telescope.builtin').oldfiles() end, opts = { keymap = { "n", "r", ":Telescope oldfiles<CR>", { noremap = true, silent = true } }, shortcut = "r", position = "center", cursor = 5, width = 38, align_shortcut = "right", hl_shortcut = "Keyword" } },
                { type = "button", val = "  Sessions", on_press = function() vim.cmd('Telescope persisted') end, opts = { keymap = { "n", "s", ":Telescope persisted<CR>", { noremap = true, silent = true } }, shortcut = "s", position = "center", cursor = 5, width = 38, align_shortcut = "right", hl_shortcut = "Keyword" } },
                { type = "button", val = "  Quit", on_press = function() vim.cmd('qa') end, opts = { keymap = { "n", "q", ":qa<CR>", { noremap = true, silent = true } }, shortcut = "q", position = "center", cursor = 5, width = 38, align_shortcut = "right", hl_shortcut = "Keyword" } },
              },
            },
            { type = "padding", val = 2 },
          }
        end)()
      '';
    };
  };
}
