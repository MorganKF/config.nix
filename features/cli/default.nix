{ lib, ... }:
{
  imports = [
    ./nushell
    ./neovim
    ./helix
  ];

  # TODO: Feature gate more software and settings
  programs = {
    nnn.enable = lib.mkDefault true;
    zoxide.enable = lib.mkDefault true;
    ripgrep.enable = lib.mkDefault true;
    fd.enable = lib.mkDefault true;
    fzf.enable = lib.mkDefault true;
    zellij.enable = lib.mkDefault true;
    bat.enable = lib.mkDefault true;
    git.enable = lib.mkDefault true;
  };
}
