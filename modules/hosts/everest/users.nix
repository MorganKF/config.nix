{
  inputs,
  ...
}:
{
  flake.modules.nixos.everest =
    { config, pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        morganf
      ];

      users.users.morganf = {
        extraGroups = [
          "networkmanager"
          "plugdev"
        ];
      };

      home-manager.users.morganf = {
        home.packages = with pkgs; [ unstable.osu-lazer-bin ];
      };
    };
}
