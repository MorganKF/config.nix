{
  inputs,
  ...
}:
{
  flake.modules.nixos.bumblebee =
    { config, pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        morganf
      ];

      users.users.morganf = {
        extraGroups = [
          "networkmanager"
        ];
      };

      home-manager.users.morganf = {
        home.packages = [ ];
      };
    };
}
