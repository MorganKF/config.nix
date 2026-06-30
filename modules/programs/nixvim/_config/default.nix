{
  pkgs,
  ...
}:
{

  imports = [
    ./keymaps.nix
    ./autocmds.nix
    ./plugins
  ];

  performance.byteCompileLua = {
    enable = true;
    nvimRuntime = true;
    plugins = true;
  };
  extraPackages = pkgs.lib.optionals pkgs.stdenv.isLinux [
    pkgs.wl-clipboard
  ];
  extraConfigLua = ''
    if vim.env.SSH_TTY ~= nil or vim.env.SSH_CLIENT ~= nil then
      vim.g.clipboard = {
        name = 'OSC 52',
        copy = {
          ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
          ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
        },
        paste = {
          ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
          ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
        },
      }
    end
  '';
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
}
