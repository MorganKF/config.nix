{ pkgs, ... }:
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
      environmentVariables = envVars;
      extraConfig = builtins.readFile ./config/nushell/config.nu;
    };
    neovim = {
      enable = true;
    };
    helix = {
      enable = true;
      languages = {
        language = [
          {
            name = "nix";
            formatter = {
              command = "nixfmt";
            };
          }
        ];
      };
      settings = {
        editor = {
          true-color = true;
        };
      };
    };
    nnn.enable = true;
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
      silent = true;
      nix-direnv.enable = true;
    };
    git.enable = true;
  };

  home = {
    packages = with pkgs; [ just ];
    sessionVariables = envVars;
    stateVersion = "24.05";
  };
}
