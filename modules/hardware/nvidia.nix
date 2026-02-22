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

          # Patch nvidia driver to work with most recent linux kernel
          package =
            let
              base = config.boot.kernelPackages.nvidiaPackages.mkDriver {
                version = "590.48.01";
                sha256_64bit = "sha256-ueL4BpN4FDHMh/TNKRCeEz3Oy1ClDWto1LO/LWlr1ok=";
                openSha256 = "sha256-hECHfguzwduEfPo5pCDjWE/MjtRDhINVr4b1awFdP44=";
                settingsSha256 = "sha256-4SfCWp3swUp+x+4cuIZ7SA5H7/NoizqgPJ6S9fm90fA=";
                persistencedSha256 = "";
              };
              cachyos-nvidia-patch = pkgs.fetchpatch {
                url = "https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/master/nvidia/nvidia-utils/kernel-6.19.patch";
                sha256 = "sha256-YuJjSUXE6jYSuZySYGnWSNG5sfVei7vvxDcHx3K+IN4=";
              };

              # Patch the appropriate driver based on config.hardware.nvidia.open
              driverAttr = if config.hardware.nvidia.open then "open" else "bin";
            in
            base
            // {
              ${driverAttr} = base.${driverAttr}.overrideAttrs (oldAttrs: {
                patches = (oldAttrs.patches or [ ]) ++ [ cachyos-nvidia-patch ];
              });
            };

          # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
          # Enable this if you have graphical corruption issues or application crashes after waking
          # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
          # of just the bare essentials.
          powerManagement.enable = false;

          # Fine-grained power management. Turns off GPU when not in use.
          # Experimental and only works on modern Nvidia GPUs (Turing or newer).
          powerManagement.finegrained = false;

        };
      };
    };
}
