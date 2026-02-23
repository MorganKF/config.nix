{ inputs, ... }:
{
  flake.modules.homeManager.nixvim =
    { pkgs, ... }:
    {
      imports = [
        inputs.nixvim.homeModules.nixvim
      ];

      programs.nixvim = {
        enable = true;
        defaultEditor = true;
        package = inputs.neovim-nightly.packages.${pkgs.hostPlatform.system}.default;
        imports = [ ./_config ];
      };
    };
}
