{ inputs, ... }:
{
  flake.modules.nixos.cli-tools = {
    home-manager.sharedModules = [
      inputs.self.modules.homeManager.cli-tools
      inputs.self.modules.homeManager.nixvim
    ];
  };

  flake.modules.darwin.cli-tools = {
    home-manager.sharedModules = [
      inputs.self.modules.homeManager.cli-tools
      inputs.self.modules.homeManager.nixvim
    ];
  };

  flake.modules.homeManager.cli-tools =
    { pkgs, ... }:
    let
      devenvHook = pkgs.runCommand "devenv-hook.nu" { } ''
        ${pkgs.unstable.devenv}/bin/devenv hook nu > $out
      '';
    in
    {
      home.packages = with pkgs; [
        unstable.devenv
        unrar
      ];

      programs.nushell.extraConfig = ''
        source ${devenvHook}
      '';

      programs = {
        yazi = {
          enable = true;
          shellWrapperName = "y";
        };
        zoxide.enable = true;
        ripgrep.enable = true;
        fd.enable = true;
        fzf.enable = true;
        zellij.enable = true;
        bat.enable = true;
        git.enable = true;
      };

      services = {
        ssh-agent.enable = true;
      };
    };
}
