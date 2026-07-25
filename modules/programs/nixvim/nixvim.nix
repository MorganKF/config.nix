{ inputs, ... }:
{
  flake.modules.homeManager.nixvim =
    { config, lib, ... }:
    {
      imports = [
        inputs.nixvim.homeModules.nixvim
      ];

      programs.nixvim = {
        enable = true;
        defaultEditor = true;
        imports = [ ./_config ];
      };

      programs.nushell.environmentVariables = lib.mkIf (
        config.programs.nixvim.enable && config.programs.nushell.enable
      ) {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };
}
