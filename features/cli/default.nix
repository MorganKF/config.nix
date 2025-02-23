{
  imports = [
    ./nushell
    ./neovim
    ./helix
  ];

  # TODO: Feature gate more software and settings
  programs = {
    nnn.enable = true;
    zoxide.enable = true;
    ripgrep.enable = true;
    fd.enable = true;
    fzf.enable = true;
    zellij.enable = true;
    bat.enable = true;
    git.enable = true;
  };
}
