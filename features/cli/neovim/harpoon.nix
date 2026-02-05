{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs; [ vimPlugins.harpoon2 ];
    extraConfigLua = "
      local harpoon = require('harpoon')

      harpoon:setup()

      vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end, {desc = 'Mark buffer'})
      vim.keymap.set('n', '<leader>e', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, {desc = 'Harpoon menu'})

      vim.keymap.set('n', '<C-n>', function() harpoon:list():select(1) end)
      vim.keymap.set('n', '<C-e>', function() harpoon:list():select(2) end)
      vim.keymap.set('n', '<C-i>', function() harpoon:list():select(3) end)
      vim.keymap.set('n', '<C-o>', function() harpoon:list():select(4) end)

      vim.keymap.set('n', '<S-l>', function() harpoon:list():prev() end, {noremap = true, silent = true})
      vim.keymap.set('n', '<S-h>', function() harpoon:list():next() end, {noremap = true, silent = true})
    ";
  };
}
