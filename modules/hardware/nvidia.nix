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
          package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
            version = "615.78.08";
            sha256_64bit = "sha256-Pj9t3cLudnoIGFMAr3vjyyhuznZpjS3eNSRZl4LQf/4=";
            openSha256 = "sha256-HBINiOjL0ZJLIAJeNIBYHBnwgUXtNwPPtnFpAI1YwF4=";
            settingsSha256 = "sha256-ZEMo8I8Zc2Tq6RVDNYpAH+f094dUaZiBqO+5f6lIjRI=";
            persistencedSha256 = "sha256-RzeR6Ldct6MUxjnXRyThdh5Y3jjMehTVg85MtwuWNX4=";
          };
          open = true;
          nvidiaSettings = true;
          modesetting.enable = true;
          powerManagement.enable = false;
          powerManagement.finegrained = false;
        };
      };
    };
}
