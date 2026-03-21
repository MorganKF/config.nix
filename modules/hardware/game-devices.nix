{
  flake.modules.nixos.game-devices =
    { pkgs, config, ... }:
    {
      boot = {
        kernelModules = [
          "uinput"
        ];
      };

      hardware = {
        uinput.enable = true;
      };

      services.udev.packages = with pkgs; [ game-devices-udev-rules ];
    };
}
