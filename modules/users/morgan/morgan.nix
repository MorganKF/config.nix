{
  self,
  lib,
  ...
}:
{
  flake.modules = lib.mkMerge [
    (self.factory.user "morganf" true)
    {
      nixos.morganf = {
        imports = with self.modules.nixos; [
          virtualisation
          transmission
        ];

        users.users.morganf = {
          extraGroups = [ "docker" ];
        };
      };

      darwin.morganf = { };

      homeManager.morganf =
        { pkgs, ... }:
        {
          imports = with self.modules.homeManager; [
            system-desktop
            comms
            kitty
          ];

          home.packages = with pkgs; [ thunderbird ];
        };
    }
  ];
}
