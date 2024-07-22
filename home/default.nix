{ pkgs-unstable, ... }:
let
  envVars = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
in
{
  programs = {
    home-manager.enable = true;
    nushell = {
      enable = true;
      package = pkgs-unstable.nushell;
      environmentVariables = envVars;
      extraConfig = builtins.readFile ./dots/nushell/config.nu;
      extraEnv = builtins.readFile ./dots/nushell/env.nu;
    };
    neovim = {
      enable = true;
      package = pkgs-unstable.neovim-unwrapped;
    };
    carapace.enable = true;
    zoxide.enable = true;
    ripgrep.enable = true;
    fd.enable = true;
    fzf.enable = true;
    zellij.enable = true;
    bat.enable = true;
    starship.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    git.enable = true;
  };

  home = {
    packages = with pkgs-unstable; [ just ];
    sessionVariables = envVars;
    stateVersion = "24.05";
  };
}
