{ inputs, ... }:
{

  flake.modules.nixos.nushell =
    { pkgs, ... }:
    {
      home-manager.sharedModules = [ inputs.self.modules.homeManager.nushell ];
      users.defaultUserShell = pkgs.nushell;
    };

  flake.modules.darwin.nushell = { pkgs, ... }: {
    home-manager.sharedModules = [ inputs.self.modules.homeManager.nushell ];

    # Forward zsh sessions directly into nushell
    programs.zsh.enable = true;
    programs.zsh.interactiveShellInit = ''
      if [[ $(basename $(ps -p $PPID -o comm=)) != "nu" && -z ''${ZSH_EXECUTION_STRING+x} ]]; then
        exec ${pkgs.nushell}/bin/nu
      fi
    '';
  };

  flake.modules.homeManager.nushell = {
    home.shell.enableNushellIntegration = true;
    programs = {
      nushell = {
        enable = true;
        settings = {
          show_banner = false;
        };
      };
      direnv = {
        enable = true;
        silent = true;
        nix-direnv.enable = true;
      };
      carapace.enable = true;
      starship.enable = true;
      nix-your-shell.enable = true;
    };
  };
}
