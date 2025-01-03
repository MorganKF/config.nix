{pkgs, envVars, ...}: {
  programs = {
    nushell = {
      enable = true;
      environmentVariables = envVars;
      extraConfig = builtins.readFile ./nushell/config.nu;
    };
    neovim = {
      enable = true;
    };
    helix = {
      enable = true;
      languages = {
        language-server = {
          typescript-language-server = {
            command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
            args = [ "--stdio" ];
            config = {
              tsserver = {
                path = "${pkgs.nodePackages.typescript}/lib/node_modules/typescript/lib";
              };
            };
          };
          nil = {
            command = "${pkgs.nil}/bin/nil";
          };
        };
        language = [
          {
            name = "cpp";
            auto-format = true;
          }
          {
            name = "nix";
            auto-format = true;
            formatter = {
              command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
            };
          }
        ];
      };
      settings = {
        theme = "dracula_at_night";
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
}