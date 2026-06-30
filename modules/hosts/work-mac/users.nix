{
  inputs,
  ...
}:
{
  flake.modules.darwin.work-mac =
    { config, pkgs, ... }:
    {
      imports = with inputs.self.modules.darwin; [
        morganf
      ];

      home-manager.users.morganf = {
      };
    };
}
