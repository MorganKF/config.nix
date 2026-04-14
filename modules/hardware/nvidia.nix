{
  flake.modules.nixos.nvidia =
    { pkgs, config, ... }:
    {
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
        };

        nvidia = {
          open = true;
          nvidiaSettings = true;
          modesetting.enable = true;
          powerManagement.enable = false;
          powerManagement.finegrained = false;
        };
      };
    };
}
