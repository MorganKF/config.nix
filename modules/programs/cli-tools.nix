{ inputs, ... }:
let
  genericPackages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        unrar
      ];
    };
in
{
  flake.modules.nixos.cli-tools = {
    imports = [
      genericPackages
    ];
    home-manager.sharedModules = [
      inputs.self.modules.homeManager.cli-tools
      inputs.self.modules.homeManager.nixvim
    ];
  };

  flake.modules.darwin.cli-tools = {
    imports = [
      genericPackages
    ];
    home-manager.sharedModules = [
      inputs.self.modules.homeManager.cli-tools
      inputs.self.modules.homeManager.nixvim
    ];
  };

  flake.modules.homeManager.cli-tools = {
    programs = {
      yazi.enable = true;
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
