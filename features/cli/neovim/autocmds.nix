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

      # Start correct typescript LSP
      {
        event = "BufEnter";
        callback.__raw = ''
          function()
            local fname = vim.api.nvim_buf_get_name(0)
            local ts_root = require('lspconfig.util').root_pattern('package.json', 'tsconfig.json', 'jsconfig.json')(fname)
            local deno_root = require('lspconfig.util').root_pattern('deno.json', 'deno.jsonc')(fname)
            local ft = vim.bo.filetype

            if ft == "javascript" or ft == "javascriptreact" or ft == "typescript" or ft == "typescriptreact" then
              if deno_root == nil and ts_root ~= nil then
                vim.cmd('LspStart vtsls')
              end
            end
          end
        '';
      }
    ];
  };
}
