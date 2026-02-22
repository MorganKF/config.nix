{ inputs, ... }:
{
  # TODO: Export config as a standalone package
  flake.modules.homeManager.nixvim = {
    imports = [
      inputs.nixvim.homeModules.nixvim
      ./_config
    ];
  };
}
