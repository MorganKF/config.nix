{
  programs.nixvim = {
    autoCmd = [
      # Highlight on yank
      {
        event = [ "TextYankPost" ];
        callback.__raw = "
          function()
            (vim.hl or vim.highlight).on_yank()
          end
        ";
      }

      # Resize splits
      {
        event = "VimResized";
        callback.__raw = "
          function()
            local current_tab = vim.fn.tabpagenr()
            vim.cmd('tabdo wincmd =')
            vim.cmd('tabnext ' .. current_tab)
          end
        ";
      }
    ];
  };
}
